
    <cfif len(attributes.report_type)>
        <cfquery name="stdt_aktif" dbtype="query">
            SELECT 
                COUNT(EMPLOYEE_ID) AS EMP_CT
            FROM  
                get_stdt_emp_count
        </cfquery>	
        <cfquery name="fndt_aktif" dbtype="query">
            SELECT 
                COUNT(EMPLOYEE_ID) AS EMP_CT
            FROM  
            get_fndt_emp_count
        </cfquery>
        <cfif isdefined('is_removal')>
            <cfquery name="nakil_cnt" dbtype="query">
                SELECT 
                    COUNT(EMPLOYEE_ID) AS EMP_CT
                FROM  
                    get_nakil_emp_count
            </cfquery>	
            <cfif nakil_cnt.recordcount>
                <cfset nakil_sys = nakil_cnt.EMP_CT>
            <cfelse>
                <cfset nakil_sys = 0>
            </cfif>
        <cfelse>
            <cfset nakil_sys = 0>
        </cfif>
        <cfif stdt_aktif.recordcount>
            <cfset aktif_1 = stdt_aktif.EMP_CT>
        <cfelse>
            <cfset aktif_1 = 0>
        </cfif>
        <cfif fndt_aktif.recordcount>
            <cfset aktif_2 = fndt_aktif.EMP_CT>
        <cfelse>
            <cfset aktif_2 = 0>
        </cfif>
        <cfif aktif_2 neq 0 or aktif_1 neq 0 or nakil_sys neq 0>
            <cfset ortalama = wrk_round((nakil_sys + aktif_1 + aktif_2) / 2)>
        </cfif>
    </cfif>
    <cfif listFind(attributes.report_type,2) or listFind(attributes.report_type,5)>
        <cfquery name="get_explanation_out" datasource="#dsn#">
            SELECT 
                EIO.EXPLANATION_ID, 
                COUNT (EIO.EMPLOYEE_ID) AS EMP_CT 
            FROM 
                EMPLOYEES_IN_OUT EIO INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
                LEFT JOIN EMPLOYEE_POSITIONS EP ON EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID
                <cfif isdefined('is_duty_changes')>
                    LEFT JOIN EMPLOYEE_POSITIONS_CHANGE_HISTORY EPC ON 
                        EPC.EMPLOYEE_ID = EIO.EMPLOYEE_ID 
                        AND EPC.START_DATE <= EIO.FINISH_DATE
                        AND EPC.FINISH_DATE >= EIO.FINISH_DATE
                        AND EPC.RECORD_DATE = (SELECT MAX(RECORD_DATE) FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY WHERE EMPLOYEE_ID = EIO.EMPLOYEE_ID AND START_DATE <= EIO.FINISH_DATE AND FINISH_DATE >= EIO.FINISH_DATE)
                </cfif>
                , DEPARTMENT D,
                BRANCH B LEFT JOIN ZONE Z ON Z.ZONE_ID = B.ZONE_ID
            WHERE
                <cfif isdefined('is_duty_changes')>
                    ((EPC.ID IS NULL AND 
                </cfif>
                EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND EIO.BRANCH_ID = B.BRANCH_ID
                <cfif len(attributes.department)>
                    AND EIO.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
                </cfif>
                <cfif len(attributes.branch_id)>
                    AND EIO.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
                </cfif>
                <cfif len(attributes.unit_id)>
                    AND EP.FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#">
                </cfif>
                <cfif len(attributes.title_id)>
                    AND EP.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">
                </cfif>
                <cfif isdefined('is_duty_changes')>
                    ) OR (EPC.ID IS NOT NULL AND EPC.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.BRANCH_ID = B.BRANCH_ID
                    <cfif len(attributes.department)>
                        AND EPC.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
                    </cfif>
                    <cfif len(attributes.branch_id)>
                        AND D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
                    </cfif>
                    <cfif len(attributes.unit_id)>
                        AND EPC.FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#">
                    </cfif>
                    <cfif len(attributes.title_id)>
                        AND EPC.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">
                    </cfif>
                    ))
                </cfif>
                <cfif len(attributes.collar_type)>
                    AND EP.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#">
                </cfif>
                <cfif len(attributes.organization_step_id)>
                    AND EP.ORGANIZATION_STEP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.organization_step_id#" list="yes">)
                </cfif>
                <cfif len(attributes.position_cat_id)>
                    AND EP.POSITION_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#" list="yes">)
                </cfif>
                <cfif len(attributes.duty_type)>
                    AND EP.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE DUTY_TYPE IN (#attributes.duty_type#) AND FINISH_DATE IS NULL)
                </cfif>
                AND (EP.EMPLOYEE_ID IS NULL OR EP.IS_MASTER = 1) 
                AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#"> 
                AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#"> 
                AND EIO.FINISH_DATE IS NOT NULL
                <cfif isdefined('is_removal')>
                    AND EIO.EXPLANATION_ID NOT IN (18)
                </cfif>
                <cfif len(attributes.comp_id)>
                    AND B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#">
                </cfif>
                <cfif len(attributes.zone_id)>
                    AND B.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
                </cfif>
                <cfif len(attributes.hierarchy)>
                    AND D.HIERARCHY = '#attributes.hierarchy#'
                </cfif>
            GROUP BY EIO.EXPLANATION_ID
        </cfquery>
    </cfif>
    <cfif listFind(attributes.report_type,1)>
        <cfquery name="get_in_comp_reason" datasource="#dsn#">
            SELECT     
                EFR.REASON, 
                COUNT (EIO.EMPLOYEE_ID) AS EMP_CT
            FROM    
            	EMPLOYEES_IN_OUT EIO INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
                LEFT JOIN SETUP_EMPLOYEE_FIRE_REASONS EFR ON EIO.IN_COMPANY_REASON_ID = EFR.REASON_ID
                LEFT JOIN EMPLOYEE_POSITIONS EP ON EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID
                <cfif isdefined('is_duty_changes')>
                    LEFT JOIN EMPLOYEE_POSITIONS_CHANGE_HISTORY EPC ON 
                        EPC.EMPLOYEE_ID = EIO.EMPLOYEE_ID 
                        AND EPC.START_DATE <= EIO.FINISH_DATE
                        AND EPC.FINISH_DATE >= EIO.FINISH_DATE
                        AND EPC.RECORD_DATE = (SELECT MAX(RECORD_DATE) FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY WHERE EMPLOYEE_ID = EIO.EMPLOYEE_ID AND START_DATE <= EIO.FINISH_DATE AND FINISH_DATE >= EIO.FINISH_DATE)
                </cfif>
                , DEPARTMENT D,
                BRANCH B LEFT JOIN ZONE Z ON Z.ZONE_ID = B.ZONE_ID
            WHERE
                <cfif isdefined('is_duty_changes')>
                    ((EPC.ID IS NULL AND 
                </cfif>
                EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND EIO.BRANCH_ID = B.BRANCH_ID
                <cfif len(attributes.department)>
                    AND EIO.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
                </cfif>
                <cfif len(attributes.branch_id)>
                    AND EIO.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
                </cfif>
                <cfif len(attributes.unit_id)>
                    AND EP.FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#">
                </cfif>
                <cfif len(attributes.title_id)>
                    AND EP.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">
                </cfif>
                <cfif isdefined('is_duty_changes')>
                    ) OR (EPC.ID IS NOT NULL AND EPC.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.BRANCH_ID = B.BRANCH_ID
                    <cfif len(attributes.department)>
                        AND EPC.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
                    </cfif>
                    <cfif len(attributes.branch_id)>
                        AND D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
                    </cfif>
                    <cfif len(attributes.unit_id)>
                        AND EPC.FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#">
                    </cfif>
                    <cfif len(attributes.title_id)>
                        AND EPC.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">
                    </cfif>
                    ))
                </cfif>
                AND (EP.EMPLOYEE_ID IS NULL OR EP.IS_MASTER = 1) 
                AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#">
                AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#">
                AND	EIO.FINISH_DATE IS NOT NULL
                <cfif isdefined('is_removal')>
                    AND EIO.EXPLANATION_ID NOT IN (18)
                </cfif>
                <cfif len(attributes.comp_id)>
                    AND B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#">
                </cfif>
                <cfif len(attributes.collar_type)>
                    AND EP.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#">
                </cfif>
                <cfif len(attributes.organization_step_id)>
                    AND EP.ORGANIZATION_STEP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.organization_step_id#" list="yes">)
                </cfif>
                <cfif len(attributes.position_cat_id)>
                    AND EP.POSITION_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#" list="yes">)
                </cfif>
                <cfif len(attributes.duty_type)>
                    AND EP.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE DUTY_TYPE IN (#attributes.duty_type#) AND FINISH_DATE IS NULL)
                </cfif>
                <cfif len(attributes.zone_id)>
                    AND B.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
                </cfif>
                <cfif len(attributes.hierarchy)>
                    AND D.HIERARCHY = '#attributes.hierarchy#'
                </cfif>
            GROUP BY
                EFR.REASON
        </cfquery>
        <cf_report_list>
            <thead>
                <tr>
                    <th colspan="3"><cf_get_lang dictionary_id='61300.Şirkete göre'></th>
                </tr>
                <tr>
                    <th><cf_get_lang dictionary_id='53643.Şirket İçi Gerekçe'></th>
                    <th style="width:100px;"><cf_get_lang dictionary_id='61304.İşten Çıkan Sayısı'></th>
                    <th class="header_icn_text"><cf_get_lang dictionary_id='59148.Çalışan Devir Oranı (Turnover) Raporu'></th>
                </tr>
            </thead>
            <tbody>	
                <cfif get_in_comp_reason.recordcount>
                    <cfset total_emp=0>
                    <cfset total_turnover=0>
                    <cfoutput query="get_in_comp_reason">
                        <tr>
                            <cfset total_emp = total_emp + EMP_CT>
                            <cfif isdefined('ortalama')><cfset total_turnover = total_turnover + wrk_round((EMP_CT * 100) / ortalama)><cfelse><cfset total_turnover = 0></cfif>
                            <td><cfif len(reason)>#REASON#<cfelse><cf_get_lang dictionary_id='61306.Tanımlı Olmayanlar'></cfif></td>
                            <td style="text-align:center; width:100px;">#EMP_CT#</td>
                            <td style="text-align:center; width:120px;"><cfif isdefined('ortalama')>#wrk_round((EMP_CT * 100) / ortalama)#%<cfelse>0</cfif></td>
                        </tr>
                    </cfoutput>
                    <tfoot>
                    <tr>
                        <td style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
                        <td style="text-align:center; width:100px;" class="txtbold"><cfoutput>#total_emp#</cfoutput></td>
                        <td style="text-align:center; width:120px;" class="txtbold"><cfoutput>#total_turnover#%</cfoutput></td>
                    </tr>
                    </tfoot>
                <cfelse>
                    <tr><td colspan="3"><cf_get_lang_main no ='72.Kayıt Yok'></td></tr>
                </cfif>
            </tbody>
        </cf_report_list>
        <!-- sil -->
        <table>
        <td valign="top">
            <cfset my_height = ((get_in_comp_reason.recordcount*20)+90)>
            <cfif my_height lt 200>
                <cfset my_height = 200>
            <cfelseif my_height gt 400>
                <cfset my_height = 400>
            </cfif>
            <cfchart chartheight="#my_height#" chartwidth="300" show3d="yes" format="jpg" font="Arial" labelformat="number" pieslicestyle="solid">
                <cfchartseries type="bar" itemcolumn="reason" colorlist="0099FF,6666CC,33CC33,CC6600,FF6600,FFCC00,FF66FF,999933,CCCC99,996699" paintstyle="raise">
                    <cfoutput query="get_in_comp_reason">
                        <cfsavecontent variable="header"><cfif len(reason)>#REASON#<cfelse><cf_get_lang dictionary_id='61306.Tanımlı Olmayanlar'></cfif></cfsavecontent>
                        <cfif isdefined('ortalama')><cfset val=#wrk_round((EMP_CT * 100) / ortalama)#><cfelse><cfset val=0></cfif>
                        <cfchartdata item="#header#" value="#val#">
                    </cfoutput>
                </cfchartseries>
            </cfchart>
        </td>
        </table>
        <!-- sil -->

    </cfif>
    <cfif listFind(attributes.report_type,2)>
        <cf_report_list>
            <thead>
                <tr>
                    <th colspan="3"><cf_get_lang dictionary_id='61309.İşten çıkış gerekçesine göre'></th>
                </tr>
                <tr>
                    <th><cf_get_lang dictionary_id='61309.İşten çıkış gerekçesine göre'></th>
                    <th style="width:100px;"><cf_get_lang dictionary_id='61304.İşten Çıkan Sayısı'></th>
                    <th class="header_icn_text"><cf_get_lang dictionary_id='59148.Çalışan Devir Oranı (Turnover) Raporu'></th>
                </tr>
            </thead>
            <tbody>	
                <cfif get_explanation_out.recordcount>
                    <cfset total_emp=0>
                    <cfset total_turnover=0>
                    <cfoutput query="get_explanation_out">
                        <tr>
                            <cfset total_emp = total_emp + EMP_CT>
                            <cfif isdefined('ortalama')><cfset total_turnover = total_turnover + wrk_round((EMP_CT * 100) / ortalama)><cfelse><cfset total_turnover = 0></cfif>
                            <td>#get_explanation_name(explanation_id)#</td>
                            <td style="text-align:center; width:100px;">#EMP_CT#</td>
                            <td style="text-align:center; width:120px;"><cfif isdefined('ortalama')>#wrk_round((EMP_CT * 100) / ortalama)#<cfelse>0</cfif>%</td>
                        </tr>
                    </cfoutput>
                    <tfoot>
                        <tr>
                            <td style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
                            <td style="text-align:center; width:100px;" class="txtbold"><cfoutput>#total_emp#</cfoutput></td>
                            <td style="text-align:center; width:120px;" class="txtbold"><cfoutput>#total_turnover#%</cfoutput></td>
                        </tr>
                    </tfoot>
                <cfelse>
                    <tr><td colspan="3"><cf_get_lang_main no ='72.Kayıt Yok'></td></tr>
                </cfif>
            </tbody>
        </cf_report_list>
        <!-- sil -->
        <table>
            <td valign="top">
                <cfset my_height = ((get_explanation_out.recordcount*20)+110)>
                <cfif my_height lt 200>
                    <cfset my_height = 200>
                <cfelseif my_height gt 400>
                    <cfset my_height = 400>
                </cfif>
                <cfchart chartheight="#my_height#" show3d="yes"
                    format="jpg"
                    font="Arial" labelformat="number" pieslicestyle="solid">
                    <cfchartseries type="bar" itemcolumn="explanation_id" colorlist="0099FF,6666CC,33CC33,CC6600,FF6600,FFCC00,FF66FF,999933,CCCC99,996699" paintstyle="raise">
                        <cfoutput query="get_explanation_out">
                            <cfif isdefined('ortalama')><cfset val = wrk_round((EMP_CT * 100) / ortalama)><cfelse><cfset val = 0></cfif>
                            <cfchartdata item="#get_explanation_name(explanation_id)#" value="#val#">
                        </cfoutput>
                    </cfchartseries>
                </cfchart>
            </td> 
        </table>
        <!-- sil -->
    </cfif>
    <cfif listFind(attributes.report_type,3)>
        <cfquery name="get_emp_out_kidem" datasource="#dsn#">
        SELECT
            EIO.EMPLOYEE_ID,
            DATEDIFF(month, E.KIDEM_DATE, EIO.FINISH_DATE) AS FARK
        FROM
            EMPLOYEES_IN_OUT EIO INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
            LEFT JOIN EMPLOYEE_POSITIONS EP ON EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID
            <cfif isdefined('is_duty_changes')>
                LEFT JOIN EMPLOYEE_POSITIONS_CHANGE_HISTORY EPC ON 
                    EPC.EMPLOYEE_ID = EIO.EMPLOYEE_ID 
                    AND EPC.START_DATE <= EIO.FINISH_DATE
                    AND EPC.FINISH_DATE >= EIO.FINISH_DATE
                    AND EPC.RECORD_DATE = (SELECT MAX(RECORD_DATE) FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY WHERE EMPLOYEE_ID = EIO.EMPLOYEE_ID AND START_DATE <= EIO.FINISH_DATE AND FINISH_DATE >= EIO.FINISH_DATE)
            </cfif>
            , DEPARTMENT D,
            BRANCH B LEFT JOIN ZONE Z ON Z.ZONE_ID = B.ZONE_ID
        WHERE
            <cfif isdefined('is_duty_changes')>
                ((EPC.ID IS NULL AND 
            </cfif>
            EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND EIO.BRANCH_ID = B.BRANCH_ID
            <cfif len(attributes.department)>
                AND EIO.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
            </cfif>
            <cfif len(attributes.branch_id)>
                AND EIO.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
            </cfif>
            <cfif len(attributes.unit_id)>
                AND EP.FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#">
            </cfif>
            <cfif len(attributes.title_id)>
                AND EP.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">
            </cfif>
            <cfif isdefined('is_duty_changes')>
                ) OR (EPC.ID IS NOT NULL AND EPC.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.BRANCH_ID = B.BRANCH_ID
                <cfif len(attributes.department)>
                    AND EPC.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
                </cfif>
                <cfif len(attributes.branch_id)>
                    AND D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
                </cfif>
                <cfif len(attributes.unit_id)>
                    AND EPC.FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#">
                </cfif>
                <cfif len(attributes.title_id)>
                    AND EPC.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">
                </cfif>
                ))
            </cfif>
            AND (EP.EMPLOYEE_ID IS NULL OR EP.IS_MASTER = 1) 
            AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#"> 
            AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#"> 
            AND EIO.FINISH_DATE IS NOT NULL
            <cfif isdefined('is_removal')>
                AND EIO.EXPLANATION_ID NOT IN (18)
            </cfif>
            <cfif len(attributes.comp_id)>
                AND B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#">
            </cfif>
            <cfif len(attributes.zone_id)>
                AND B.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
            </cfif>
            <cfif len(attributes.hierarchy)>
                AND D.HIERARCHY = '#attributes.hierarchy#'
            </cfif>
        </cfquery>
            <cf_report_list>
                <thead>
                    <tr>
                        <th colspan="3"><cf_get_lang dictionary_id='61310.Kıdeme göre'></th>
                    </tr>
                    <tr>
                        <th><cf_get_lang dictionary_id='61311.Kıdem Süresi'></th>
                        <th style="width:100px;"><cf_get_lang dictionary_id='61304.İşten Çıkan Sayısı'></th>
                        <th class="header_icn_text"><cf_get_lang dictionary_id='59148.Çalışan Devir Oranı (Turnover) Raporu'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfset satir1 = 0>
                    <cfset satir2 = 0>
                    <cfset satir3 = 0>
                    <cfset satir4 = 0>
                    <cfset satir5 = 0>
                    <cfset satir6 = 0>
                    <cfset satir7 = 0>
                    <cfif get_emp_out_kidem.recordcount>
                        <cfset total_emp = 0>
                        <cfset total_turnover = 0>
                        <cfoutput query="get_emp_out_kidem">
                            <cfif FARK lte 6>
                                <cfset satir1 = satir1 + 1>
                            <cfelseif FARK gt 6 and FARK lte 12>
                                <cfset satir2 = satir2 + 1>
                            <cfelseif FARK gt 12 and FARK lte 24>
                                <cfset satir3 = satir3 + 1>
                            <cfelseif FARK gt 24 and FARK lte 36>
                                <cfset satir4 = satir4 + 1>
                            <cfelseif FARK gt 36 and FARK lte 60>
                                <cfset satir5 = satir5 + 1>
                            <cfelseif FARK gt 60 and FARK lte 120>
                                <cfset satir6 = satir6 + 1>
                            <cfelseif FARK gt 120>
                                <cfset satir7 = satir7 + 1>
                            </cfif>
                        </cfoutput>
                        <cfset total_emp = satir1 + satir2 + satir3 + satir4 + satir5  + satir6  + satir7>
                        <cfif IsDefined('ortalama')><cfset total_turnover = wrk_round((satir1 * 100) / ortalama) + wrk_round((satir2 * 100) / ortalama) + wrk_round((satir3 * 100) / ortalama) + wrk_round((satir4 * 100) / ortalama) + wrk_round((satir5 * 100) / ortalama) + wrk_round((satir6 * 100) / ortalama) + wrk_round((satir7 * 100) / ortalama)><cfelse><cfset total_turnover = 0></cfif>
                        <cfoutput>
                            <tr>
                                <td>0 - 6 <cf_get_lang dictionary_id='58724.Ay'></td>
                                <td style="text-align:center; width:100px;">#satir1#</td>
                                <td style="text-align:center; width:120px;"><cfif IsDefined('ortalama')>#wrk_round((satir1 * 100) / ortalama)#<cfelse>0</cfif>%</td>
                            </tr>
                            <tr>
                                <td>6 <cf_get_lang dictionary_id='58724.Ay'> - 1 <cf_get_lang dictionary_id='58455.Yıl'></td>
                                <td style="text-align:center; width:100px;">#satir2#</td>
                                <td style="text-align:center; width:120px;"><cfif IsDefined('ortalama')>#wrk_round((satir2 * 100) / ortalama)#<cfelse>0</cfif>%</td>
                            </tr>
                            <tr>
                                <td>1 - 2 <cf_get_lang dictionary_id='58455.Yıl'></td>
                                <td style="text-align:center; width:100px;">#satir3#</td>
                                <td style="text-align:center; width:120px;"><cfif IsDefined('ortalama')>#wrk_round((satir3 * 100) / ortalama)#<cfelse>0</cfif>%</td>
                            </tr>
                            <tr>
                                <td>2 - 3 <cf_get_lang dictionary_id='58455.Yıl'></td>
                                <td style="text-align:center; width:100px;">#satir4#</td>
                                <td style="text-align:center; width:120px;"><cfif IsDefined('ortalama')>#wrk_round((satir4 * 100) / ortalama)#<cfelse>0</cfif>%</td>
                            </tr>
                            <tr>
                                <td>3 - 5 <cf_get_lang dictionary_id='58455.Yıl'></td>
                                <td style="text-align:center; width:100px;">#satir5#</td>
                                <td style="text-align:center; width:120px;"><cfif IsDefined('ortalama')>#wrk_round((satir5 * 100) / ortalama)#<cfelse>0</cfif>%</td>
                            </tr>
                            <tr>
                                <td>5 - 10 <cf_get_lang dictionary_id='58455.Yıl'></td>
                                <td style="text-align:center; width:100px;">#satir6#</td>
                                <td style="text-align:center; width:120px;"><cfif IsDefined('ortalama')>#wrk_round((satir6 * 100) / ortalama)#<cfelse>0</cfif>%</td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id='61312.10 yıl ve üzeri'></td>
                                <td style="text-align:center; width:100px;">#satir7#</td>
                                <td style="text-align:center; width:120px;"><cfif IsDefined('ortalama')>#wrk_round((satir7 * 100) / ortalama)#<cfelse>0</cfif>%</td>
                            </tr>
                        </cfoutput>
                        <tfoot>
                            <tr>
                                <td style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                <td style="text-align:center; width:100px;" class="txtbold"><cfoutput>#total_emp#</cfoutput></td>
                                <td style="text-align:center; width:120px;" class="txtbold"><cfoutput>#total_turnover#%</cfoutput></td>
                            </tr>
                        </tfoot>
                    <cfelse>
                        <tr><td colspan="3"><cf_get_lang_main no ='72.Kayıt Yok'></td></tr>
                    </cfif>
                </tbody>
            </cf_report_list>
        <!-- sil -->
        <table>
        <td valign="top">
            <cfset my_height = ((7*20)+90)>
            <cfif my_height lt 200>
                <cfset my_height = 200>
            <cfelseif my_height gt 400>
                <cfset my_height = 400>
            </cfif>
            <cfchart chartheight="#my_height#" show3d="yes"
                format="jpg"
                font="Arial" labelformat="number" pieslicestyle="solid">
                <cfchartseries type="bar" itemcolumn="kidem" colorlist="0099FF,6666CC,33CC33,CC6600,FF6600,FFCC00,FF66FF,999933,CCCC99,996699" paintstyle="raise">
                    <cfif get_emp_out_kidem.recordcount>
                    	<cfif IsDefined('ortalama')>
                            <cfchartdata item="0 - 6 ay" value="#wrk_round(satir1 * 100 / ortalama)#">
                            <cfchartdata item="6 ay - 1 yıl" value="#wrk_round(satir2 * 100 / ortalama)#">
                            <cfchartdata item="1 - 2 yıl" value="#wrk_round(satir3 * 100 / ortalama)#">
                            <cfchartdata item="2 - 3 yıl" value="#wrk_round(satir4 * 100 / ortalama)#">
                            <cfchartdata item="3 - 5 yıl" value="#wrk_round(satir5 * 100 / ortalama)#">
                            <cfchartdata item="5 - 10 yıl" value="#wrk_round(satir6 * 100 / ortalama)#">
                            <cfchartdata item="10 yıl ve üzeri" value="#wrk_round(satir7 * 100 / ortalama)#">
                        <cfelse>
                        	<cfchartdata item="0 - 6 ay" value="0">
                            <cfchartdata item="6 ay - 1 yıl" value="0">
                            <cfchartdata item="1 - 2 yıl" value="0">
                            <cfchartdata item="2 - 3 yıl" value="0">
                            <cfchartdata item="3 - 5 yıl" value="0">
                            <cfchartdata item="5 - 10 yıl" value="0">
                            <cfchartdata item="10 yıl ve üzeri" value="0">
                       	</cfif>
                    </cfif>
                </cfchartseries>
            </cfchart>
        </td> 
        </table>
        <!-- sil -->
    </cfif>
    <cfif listFind(attributes.report_type,4)>
        <cfquery name="get_emp_out_sex" datasource="#dsn#">
            SELECT 
                CASE ED.SEX WHEN 0 THEN 'Kadın' WHEN 1 THEN 'Erkek' END AS CINSIYET, 
                COUNT (EIO.EMPLOYEE_ID) AS EMP_CT 
            FROM 
            	EMPLOYEES_IN_OUT EIO INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
                LEFT JOIN EMPLOYEES_DETAIL ED ON EIO.EMPLOYEE_ID = ED.EMPLOYEE_ID
                LEFT JOIN EMPLOYEE_POSITIONS EP ON EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID
                <cfif isdefined('is_duty_changes')>
                    LEFT JOIN EMPLOYEE_POSITIONS_CHANGE_HISTORY EPC ON 
                        EPC.EMPLOYEE_ID = EIO.EMPLOYEE_ID 
                        AND EPC.START_DATE <= EIO.FINISH_DATE
                        AND EPC.FINISH_DATE >= EIO.FINISH_DATE
                        AND EPC.RECORD_DATE = (SELECT MAX(RECORD_DATE) FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY WHERE EMPLOYEE_ID = EIO.EMPLOYEE_ID AND START_DATE <= EIO.FINISH_DATE AND FINISH_DATE >= EIO.FINISH_DATE)
                </cfif>
                , DEPARTMENT D,
                BRANCH B LEFT JOIN ZONE Z ON Z.ZONE_ID = B.ZONE_ID
            WHERE 
                <cfif isdefined('is_duty_changes')>
                    ((EPC.ID IS NULL AND 
                </cfif>
                EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND EIO.BRANCH_ID = B.BRANCH_ID
                <cfif len(attributes.department)>
                    AND EIO.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
                </cfif>
                <cfif len(attributes.branch_id)>
                    AND EIO.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
                </cfif>
                <cfif len(attributes.unit_id)>
                    AND EP.FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#">
                </cfif>
                <cfif len(attributes.title_id)>
                    AND EP.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">
                </cfif>
                <cfif isdefined('is_duty_changes')>
                    ) OR (EPC.ID IS NOT NULL AND EPC.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.BRANCH_ID = B.BRANCH_ID
                    <cfif len(attributes.department)>
                        AND EPC.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
                    </cfif>
                    <cfif len(attributes.branch_id)>
                        AND D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
                    </cfif>
                    <cfif len(attributes.unit_id)>
                        AND EPC.FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#">
                    </cfif>
                    <cfif len(attributes.title_id)>
                        AND EPC.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">
                    </cfif>
                    ))
                </cfif>
                AND (EP.EMPLOYEE_ID IS NULL OR EP.IS_MASTER = 1) 
                AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#"> 
                AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#"> 
                AND EIO.FINISH_DATE IS NOT NULL
                <cfif isdefined('is_removal')>
                    AND EIO.EXPLANATION_ID NOT IN (18)
                </cfif>
                <cfif len(attributes.comp_id)>
                    AND B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#">
                </cfif>
                <cfif len(attributes.zone_id)>
                    AND B.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
                </cfif>
                <cfif len(attributes.hierarchy)>
                    AND D.HIERARCHY = '#attributes.hierarchy#'
                </cfif>
            GROUP BY ED.SEX
        </cfquery>
        <cf_report_list>
            <thead>
                <tr>
                    <th colspan="3"><cf_get_lang dictionary_id='61313.Cinsiyete göre'></th>
                </tr>
                <tr>
                    <th><cf_get_lang dictionary_id='57764.Cinsiyet'></th>
                    <th style="width:100px;"><cf_get_lang dictionary_id='61304.İşten Çıkan Sayısı'></th>
                    <th class="header_icn_text"><cf_get_lang dictionary_id='59148.Çalışan Devir Oranı (Turnover) Raporu'></th>
                </tr>
            </thead>
            <tbody>	
                <cfif get_emp_out_sex.recordcount>
                    <cfset total_emp=0>
                    <cfset total_turnover=0>
                    <cfoutput query="get_emp_out_sex">
                        <tr>
                            <cfset total_emp = total_emp + EMP_CT>
                            <cfif IsDefined('ortalama')><cfset total_turnover = total_turnover + wrk_round((EMP_CT * 100) / ortalama)><cfset total_turnover = 0></cfif>
                            <td>#CINSIYET#</td>
                            <td style="text-align:center; width:100px;">#EMP_CT#</td>
                            <td style="text-align:center; width:120px;"><cfif IsDefined('ortalama')>#wrk_round((EMP_CT * 100) / ortalama)#<cfelse>0</cfif>%</td>
                        </tr>
                    </cfoutput>
                    <tfoot>
                        <tr>
                            <td style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
                            <td style="text-align:center; width:100px;" class="txtbold"><cfoutput>#total_emp#</cfoutput></td>
                            <td style="text-align:center; width:120px;" class="txtbold"><cfoutput>#total_turnover#%</cfoutput></td>
                        </tr>
                    </tfoot>
                <cfelse>
                    <tr><td colspan="3"><cf_get_lang_main no ='72.Kayıt Yok'></td></tr>
                </cfif>
            </tbody>
        </cf_report_list>
            <!-- sil -->
            <table>
            <td valign="top">
                <cfset my_height = ((get_emp_out_sex.recordcount*20)+90)>
                <cfif my_height lt 200>
                    <cfset my_height = 200>
                <cfelseif my_height gt 400>
                    <cfset my_height = 400>
                </cfif>
                <cfchart chartheight="#my_height#" show3d="yes"
                    format="jpg"
                    font="Arial" labelformat="number" pieslicestyle="solid">
                    <cfchartseries type="bar" itemcolumn="CINSIYET" colorlist="0099FF,6666CC,33CC33,CC6600,FF6600,FFCC00,FF66FF,999933,CCCC99,996699" paintstyle="raise">
                        <cfoutput query="get_emp_out_sex">
                        	<cfif IsDefined('ortalama')><cfset val = wrk_round((EMP_CT * 100) / ortalama)><cfelse><cfset val = 0></cfif>
                            <cfchartdata item="#CINSIYET#" value="#val#">
                        </cfoutput>
                    </cfchartseries>
                </cfchart>
            </td> 
            </table>
            <!-- sil -->
    </cfif>
    <cfif listFind(attributes.report_type,5)>
    	<cfquery name="get_istifa_cnt" dbtype="query">
            SELECT 
                EMP_CT
            FROM  
                get_explanation_out WHERE EXPLANATION_ID IN (21,2,30,4,3,6,7,29,33,14,10,37)
        </cfquery>	
        <cfif get_istifa_cnt.recordcount>
            <cfquery name="get_istifa" dbtype="query">
                SELECT 
                    SUM(EMP_CT) AS EMP_CT
                FROM  
                    get_explanation_out WHERE EXPLANATION_ID IN (21,2,30,4,3,6,7,29,33,14,10,37)
            </cfquery>
        	<cfset istifa_cnt = get_istifa.EMP_CT>
        <cfelse>
        	<cfset istifa_cnt = 0>
        </cfif>
        <cfquery name="get_fesih_cnt" dbtype="query">
            SELECT 
                EMP_CT
            FROM  
                get_explanation_out WHERE EXPLANATION_ID IN (25,26,31,1,19,17,23,24,11,34,9,15,35,36,38,8,12,13,16)
        </cfquery>
        <cfif get_fesih_cnt.recordcount>
            <cfquery name="get_fesih" dbtype="query">
                SELECT 
                    SUM(EMP_CT) AS EMP_CT
                FROM  
                    get_explanation_out WHERE EXPLANATION_ID IN (25,26,31,1,19,17,23,24,11,34,9,15,35,36,38,8,12,13,16)
            </cfquery>
            <cfset fesih_cnt = get_fesih.EMP_CT>
		<cfelse>
			<cfset fesih_cnt = 0>
		</cfif>
        <cfquery name="get_diger_cnt" dbtype="query">
            SELECT 
                EMP_CT
            FROM  
                get_explanation_out WHERE EXPLANATION_ID IN (27,5,32,18,22,28,20)
        </cfquery>
        <cfif get_diger_cnt.recordcount>
            <cfquery name="get_diger" dbtype="query">
                SELECT 
                    SUM(EMP_CT) AS EMP_CT
                FROM  
                    get_explanation_out WHERE EXPLANATION_ID IN (27,5,32,18,22,28,20)
            </cfquery>
        	<cfset diger_cnt = get_diger.EMP_CT>
		<cfelse>
			<cfset diger_cnt = 0>
		</cfif>
        <cf_report_list>
            <thead>
                <tr>
                    <th colspan="3"><cf_get_lang dictionary_id='61314.İstifa - Fesih durumuna göre'></th>
                </tr>
                <tr>
                    <th><cf_get_lang dictionary_id='61315.İstifa - Fesih'></th>
                    <th style="width:100px;"><cf_get_lang dictionary_id='61304.İşten Çıkan Sayısı'></th>
                    <th class="header_icn_text"><cf_get_lang dictionary_id='59148.Çalışan Devir Oranı (Turnover) Raporu'></th>
                </tr>
            </thead>
            <tbody>	
                <cfif get_explanation_out.recordcount>
                    <cfset total_emp=0>
                    <cfset total_turnover=0>
                    <cfoutput>
                        <tr>
                            <cfset total_emp = total_emp + istifa_cnt>
                            <cfif isdefined('ortalama')><cfset total_turnover = total_turnover + wrk_round((istifa_cnt * 100) / ortalama)><cfelse><cfset total_turnover = 0></cfif>
                            <td><cf_get_lang dictionary_id='55508.İstifa'></td>
                            <td style="text-align:center; width:100px;">#istifa_cnt#</td>
                            <td style="text-align:center; width:120px;"><cfif isdefined('ortalama')>#wrk_round((istifa_cnt * 100) / ortalama)#<cfelse>0</cfif>%</td>
                        </tr>
                        <tr>
                            <cfset total_emp = total_emp + fesih_cnt>
                            <cfif isdefined('ortalama')><cfset total_turnover = total_turnover + wrk_round((fesih_cnt * 100) / ortalama)><cfelse><cfset total_turnover = 0></cfif>
                            <td><cf_get_lang dictionary_id='55509.Fesih'></td>
                            <td style="text-align:center; width:100px;">#fesih_cnt#</td>
                            <td style="text-align:center; width:120px;"><cfif isdefined('ortalama')>#wrk_round((fesih_cnt * 100) / ortalama)#<cfelse>0</cfif>%</td>
                        </tr>
                        <tr>
                            <cfset total_emp = total_emp + diger_cnt>
                            <cfif isdefined('ortalama')><cfset total_turnover = total_turnover + wrk_round((diger_cnt * 100) / ortalama)><cfelse><cfset total_turnover = 0></cfif>
                            <td><cf_get_lang_main no ='744.Diğer'></td>
                            <td style="text-align:center; width:100px;">#diger_cnt#</td>
                            <td style="text-align:center; width:120px;"><cfif isdefined('ortalama')>#wrk_round((diger_cnt * 100) / ortalama)#<cfelse>0</cfif>%</td>
                        </tr>
                    </cfoutput>
                    <tfoot>
                        <tr>
                            <td style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
                            <td style="text-align:center; width:100px;" class="txtbold"><cfoutput>#total_emp#</cfoutput></td>
                            <td style="text-align:center; width:120px;" class="txtbold"><cfoutput>#total_turnover#%</cfoutput></td>
                        </tr>
                    </tfoot>
                <cfelse>
                    <tr><td colspan="3"><cf_get_lang_main no ='72.Kayıt Yok'></td></tr>
                </cfif>
            </tbody>
        </cf_report_list>
        <!-- sil -->
        <table>
        <td valign="top">
            <cfset my_height = ((get_explanation_out.recordcount*20)+110)>
            <cfif my_height lt 200>
                <cfset my_height = 200>
            <cfelseif my_height gt 400>
                <cfset my_height = 400>
            </cfif>
            <cfchart chartheight="#my_height#" show3d="yes"
                format="jpg"
                font="Arial" labelformat="number" pieslicestyle="solid">
                <cfchartseries type="bar" itemcolumn="explanation_id" colorlist="0099FF,6666CC,33CC33,CC6600,FF6600,FFCC00,FF66FF,999933,CCCC99,996699" paintstyle="raise">
					<cfif isdefined('ortalama')>
                        <cfchartdata item="İstifa" value="#wrk_round((istifa_cnt * 100) / ortalama)#">
                        <cfchartdata item="Fesih" value="#wrk_round((fesih_cnt * 100) / ortalama)#">
                        <cfchartdata item="Diğer" value="#wrk_round((diger_cnt * 100) / ortalama)#">
                    <cfelse>
                        <cfchartdata item="İstifa" value="0">
                        <cfchartdata item="Fesih" value="0">
                        <cfchartdata item="Diğer" value="0">
                    </cfif>
                </cfchartseries>
            </cfchart>
        </td> 
        </table>
        <!-- sil -->
    </cfif>

