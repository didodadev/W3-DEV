<cf_report_list>
        <cfif isdefined('report_type_batch') and report_type_batch eq 0>
            <cfquery name="get_out_comp" datasource="#dsn#">
                SELECT     
                    OC.COMPANY_NAME, 
                    OC.COMP_ID
                FROM  
                    OUR_COMPANY OC
                <cfif len(attributes.comp_id)>
                    WHERE
                        OC.COMP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">)
                </cfif>
                <cfif not session.ep.ehesap>
                    WHERE OC.COMP_ID IN (SELECT DISTINCT B.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH B ON B.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
                </cfif>
                ORDER BY
                    OC.COMPANY_NAME
            </cfquery>
                    <thead>
                        <tr>
                            <th colspan="6"><cf_get_lang dictionary_id='61300.Şirkete göre'></th>
                        </tr>
                        <tr>
                            <th><cf_get_lang_main no='162.Şirket'></th>
                            <th style="width:80px;"><cf_get_lang dictionary_id='61301.Dönem Başı Çalışan Sayısı'></th>
                            <th style="width:80px;"><cf_get_lang dictionary_id='61302.Dönem Sonu Çalışan Sayısı'></th>
                            <th style="width:60px;"><cf_get_lang dictionary_id='61303.İşe Giren Sayısı'></th>
                            <th style="width:70px;"><cf_get_lang dictionary_id='61304.İşten Çıkan Sayısı'></th>
                            <th class="header_icn_text"><cf_get_lang dictionary_id='59148.Çalışan Devir Oranı (Turnover) Raporu'></th>
                        </tr>
                    </thead>
                    <tbody>	
                        <cfif get_out_comp.recordcount>
                            <cfset total_emp=0>
                            <cfset total_giris=0>
                            <cfset total_aktif2=0>
                            <cfset total_aktif1=0>
                            <cfset ortalama = 0>
                            <cfoutput query="get_out_comp">
                                <cfquery name="stdt_aktif" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_stdt_emp_count WHERE COMPANY_ID = #get_out_comp.COMP_ID#
                                </cfquery>	
                                <cfquery name="fndt_aktif" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_fndt_emp_count WHERE COMPANY_ID = #get_out_comp.COMP_ID#
                                </cfquery>	
                                <cfquery name="giris_emp" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_in_emp_count WHERE COMPANY_ID = #get_out_comp.COMP_ID#
                                </cfquery>
                                <cfquery name="cikis_emp" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_out_emp_count WHERE COMPANY_ID = #get_out_comp.COMP_ID#
                                </cfquery>	
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
                                <cfif giris_emp.recordcount>
                                    <cfset giris = giris_emp.EMP_CT>
                                <cfelse>
                                    <cfset giris = 0>
                                </cfif>
                                <cfif cikis_emp.recordcount>
                                    <cfset cikis = cikis_emp.EMP_CT>
                                <cfelse>
                                    <cfset cikis = 0>
                                </cfif>
                                <cfif isdefined('is_removal')>
                                    <cfquery name="nakil_cnt" dbtype="query">
                                        SELECT 
                                            COUNT(EMPLOYEE_ID) AS EMP_CT
                                        FROM  
                                            get_nakil_emp_count WHERE COMPANY_ID = #get_out_comp.COMP_ID#
                                    </cfquery>	
                                    <cfif nakil_cnt.recordcount>
                                        <cfset nakil_sys = nakil_cnt.EMP_CT>
                                    <cfelse>
                                        <cfset nakil_sys = 0>
                                    </cfif>
                                    <cfset aktif_2 = aktif_2 + nakil_sys>
                                </cfif>
                                <cfif aktif_2 neq 0 or aktif_1 neq 0>
                                    <cfset ortalama = wrk_round((aktif_1 + aktif_2) / 2)>
                                </cfif>
                                <tr>
                                    <cfset total_emp = total_emp + cikis>
                                    <cfset total_giris = total_giris + giris>
                                    <cfset total_aktif2 = total_aktif2 + aktif_2>
                                    <cfset total_aktif1 = total_aktif1 + aktif_1>
                                    <td>#COMPANY_NAME#</td>
                                    <td style="text-align:center; width:80px;">#aktif_1#</td>
                                    <td style="text-align:center; width:80px;">#aktif_2#</td>
                                    <td style="text-align:center; width:60px;">#giris#</td>
                                    <td style="text-align:center; width:70px;">#cikis#</td>
                                    <td style="text-align:center; width:80px;"><cfif ortalama gt 0>#wrk_round((cikis * 100) / ortalama)#%<cfelse>-</cfif></td>
                                    
                                </tr>
                            </cfoutput>
                            <tfoot>
                            <tr>
                                <td style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                <td style="text-align:center; width:80px;" class="txtbold"><cfoutput>#total_aktif1#</cfoutput></td>
                                <td style="text-align:center; width:80px;" class="txtbold"><cfoutput>#total_aktif2#</cfoutput></td>
                                <td style="text-align:center; width:60px;" class="txtbold"><cfoutput>#total_giris#</cfoutput></td>
                                <td style="text-align:center; width:70px;" class="txtbold"><cfoutput>#total_emp#</cfoutput></td>
                                <td></td>
                            </tr>
                            </tfoot>
                        <cfelse>
                            <tr><td colspan="6"><cf_get_lang_main no ='72.Kayıt Yok'></td></tr>
                        </cfif>
                    </tbody>
            <!--- sil --->
            <table>
                <td valign="top">
                    <cfset my_height = ((get_out_comp.recordcount*20)+90)>
                    <cfif my_height lt 200>
                        <cfset my_height = 200>
                    <cfelseif my_height gt 400>
                        <cfset my_height = 400>
                    </cfif><!-- sil -->
                    <cfchart chartheight="#my_height#" chartwidth="300" show3D="yes" format="jpg" font="Arial" labelformat="number" pieslicestyle="solid">
                        <cfchartseries type="bar" itemcolumn="COMPANY_NAME" colorlist="0099FF,6666CC,33CC33,CC6600,FF6600,FFCC00,FF66FF,999933,CCCC99,996699" paintstyle="raise">
                            <cfoutput query="get_out_comp">
                                <cfquery name="stdt_aktif" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_stdt_emp_count WHERE COMPANY_ID = #get_out_comp.COMP_ID#
                                </cfquery>	
                                <cfquery name="fndt_aktif" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_fndt_emp_count WHERE COMPANY_ID = #get_out_comp.COMP_ID#
                                </cfquery>	
                                <cfquery name="cikis_emp" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_out_emp_count WHERE COMPANY_ID = #get_out_comp.COMP_ID#
                                </cfquery>
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
                                <cfif cikis_emp.recordcount>
                                    <cfset cikis = cikis_emp.EMP_CT>
                                <cfelse>
                                    <cfset cikis = 0>
                                </cfif>
                                <cfif isdefined('is_removal')>
                                    <cfquery name="nakil_cnt" dbtype="query">
                                        SELECT 
                                            COUNT(EMPLOYEE_ID) AS EMP_CT
                                        FROM  
                                            get_nakil_emp_count WHERE COMPANY_ID = #get_out_comp.COMP_ID#
                                    </cfquery>	
                                    <cfif nakil_cnt.recordcount>
                                        <cfset nakil_sys = nakil_cnt.EMP_CT>
                                    <cfelse>
                                        <cfset nakil_sys = 0>
                                    </cfif>
                                    <cfset aktif_2 = aktif_2 + nakil_sys>
                                </cfif>
                                <cfif aktif_2 neq 0 or aktif_1 neq 0>
                                    <cfset ortalama = wrk_round((aktif_1 + aktif_2) / 2)>
                                </cfif>
                                <cfsavecontent variable="header">#COMPANY_NAME#</cfsavecontent>
                                <cfsavecontent variable="deger"><cfif ortalama gt 0>#wrk_round((cikis) * 100 / ortalama)#<cfelse>0</cfif></cfsavecontent>
                                <cfif deger gt 0>
                                    <cfchartdata item="#header#" value="#deger#">
                                </cfif>
                            </cfoutput>
                        </cfchartseries>
                    </cfchart><!-- sil -->
                </td>
            </table>
            <!--- sil --->
        <cfelseif isdefined('report_type_batch') and report_type_batch eq 1>
             <cfquery name="get_out_branch" datasource="#dsn#">
                SELECT     
                    OC.COMPANY_NAME, 
                    B.BRANCH_NAME,
                    B.BRANCH_ID
                FROM
                    BRANCH B
                    INNER JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
                WHERE
                    1 = 1
                    <cfif len(attributes.comp_id)>
                        AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">)
                    </cfif>
                    <cfif len(attributes.branch_id)>
                        AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
                    </cfif>
                    <cfif not session.ep.ehesap>
                        AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
                        AND OC.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
                    </cfif>
                ORDER BY
                    OC.COMPANY_NAME, B.BRANCH_NAME
            </cfquery>
                    <thead>
                        <tr>
                            <th colspan="7"><cf_get_lang dictionary_id='61305.Şubeye göre'></th>
                        </tr>
                        <tr>
                            <th><cf_get_lang_main no='162.Şirket'></th>
                            <th><cf_get_lang_main no='41.Şube'></th>
                            <th style="width:80px;"><cf_get_lang dictionary_id='61301.Dönem Başı Çalışan Sayısı'></th>
                            <th style="width:80px;"><cf_get_lang dictionary_id='61302.Dönem Sonu Çalışan Sayısı'></th>
                            <th style="width:60px;"><cf_get_lang dictionary_id='61303.İşe Giren Sayısı'></th>
                            <th style="width:70px;"><cf_get_lang dictionary_id='61304.İşten Çıkan Sayısı'></th>
                            <th class="header_icn_text"><cf_get_lang dictionary_id='59148.Çalışan Devir Oranı (Turnover) Raporu'></th>
                        </tr>
                    </thead>
                    <tbody>	
                        <cfif get_out_branch.recordcount>
                            <cfset total_emp=0>
                            <cfset ortalama = 0>
                            <cfset total_giris=0>
                            <cfset total_aktif2=0>
                            <cfset total_aktif1=0>
                            <cfoutput query="get_out_branch">
                                <cfquery name="stdt_aktif" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_stdt_emp_count WHERE BRANCH_ID = #get_out_branch.BRANCH_ID#
                                </cfquery>	
                                <cfquery name="fndt_aktif" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_fndt_emp_count WHERE BRANCH_ID = #get_out_branch.BRANCH_ID#
                                </cfquery>	
                                <cfquery name="giris_emp" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_in_emp_count WHERE BRANCH_ID = #get_out_branch.BRANCH_ID#
                                </cfquery>
                                <cfquery name="cikis_emp" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_out_emp_count WHERE BRANCH_ID = #get_out_branch.BRANCH_ID#
                                </cfquery>
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
                                <cfif giris_emp.recordcount>
                                    <cfset giris = giris_emp.EMP_CT>
                                <cfelse>
                                    <cfset giris = 0>
                                </cfif>
                                <cfif cikis_emp.recordcount>
                                    <cfset cikis = cikis_emp.EMP_CT>
                                <cfelse>
                                    <cfset cikis = 0>
                                </cfif>
                                <cfif isdefined('is_removal')>
                                    <cfquery name="nakil_cnt" dbtype="query">
                                        SELECT 
                                            COUNT(EMPLOYEE_ID) AS EMP_CT
                                        FROM  
                                            get_nakil_emp_count WHERE BRANCH_ID = #get_out_branch.BRANCH_ID#
                                    </cfquery>	
                                    <cfif nakil_cnt.recordcount>
                                        <cfset nakil_sys = nakil_cnt.EMP_CT>
                                    <cfelse>
                                        <cfset nakil_sys = 0>
                                    </cfif>
                                    <cfset aktif_2 = aktif_2 + nakil_sys>
                                </cfif>
                                <cfif aktif_2 neq 0 or aktif_1 neq 0>
                                    <cfset ortalama = wrk_round((aktif_1 + aktif_2) / 2)>
                                </cfif>
                                <tr>
                                    <cfset total_emp = total_emp + cikis>
                                    <cfset total_giris = total_giris + giris>
                                    <cfset total_aktif2 = total_aktif2 + aktif_2>
                                    <cfset total_aktif1 = total_aktif1 + aktif_1>
                                    <td>#COMPANY_NAME#</td>
                                    <td>#BRANCH_NAME#</td>
                                    <td style="text-align:center; width:80px;">#aktif_1#</td>
                                    <td style="text-align:center; width:80px;">#aktif_2#</td>
                                    <td style="text-align:center; width:60px;">#giris#</td>
                                    <td style="text-align:center; width:70px;">#cikis#</td>
                                    <td style="text-align:center; width:80px;"><cfif ortalama gt 0>#wrk_round((cikis * 100) / ortalama)#%<cfelse>-</cfif></td>
                                </tr>
                            </cfoutput>
                            <tfoot>
                                <tr>
                                    <td colspan="2" style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                    <td style="text-align:center; width:80px;" class="txtbold"><cfoutput>#total_aktif1#</cfoutput></td>
                                    <td style="text-align:center; width:80px;" class="txtbold"><cfoutput>#total_aktif2#</cfoutput></td>
                                    <td style="text-align:center; width:60px;" class="txtbold"><cfoutput>#total_giris#</cfoutput></td>
                                    <td style="text-align:center; width:70px;" class="txtbold"><cfoutput>#total_emp#</cfoutput></td>
                                    <td></td>
                                </tr>
                            </tfoot>
                        <cfelse>
                            <tr><td colspan="7"><cf_get_lang_main no ='72.Kayıt Yok'></td></tr>
                        </cfif>
                    </tbody>
             <!-- sil -->
             <table>
            <td valign="top">
                <cfset my_height = ((get_out_branch.recordcount*20)+90)>
                <cfif my_height lt 200>
                    <cfset my_height = 200>
                <cfelseif my_height gt 400>
                    <cfset my_height = 400>
                </cfif>
                <cfchart chartheight="#my_height#" chartwidth="300" show3D="yes" format="jpg" font="Arial" labelformat="number" pieslicestyle="solid">
                    <cfchartseries type="bar" itemcolumn="BRANCH_NAME" colorlist="0099FF,6666CC,33CC33,CC6600,FF6600,FFCC00,FF66FF,999933,CCCC99,996699" paintstyle="raise">
                        <cfoutput query="get_out_branch">
                            <cfquery name="stdt_aktif" dbtype="query">
                                SELECT 
                                    COUNT(EMPLOYEE_ID) AS EMP_CT
                                FROM  
                                    get_stdt_emp_count WHERE BRANCH_ID = #get_out_branch.BRANCH_ID#
                            </cfquery>	
                            <cfquery name="fndt_aktif" dbtype="query">
                                SELECT 
                                    COUNT(EMPLOYEE_ID) AS EMP_CT
                                FROM  
                                    get_fndt_emp_count WHERE BRANCH_ID = #get_out_branch.BRANCH_ID#
                            </cfquery>	
                            <cfquery name="cikis_emp" dbtype="query">
                                SELECT 
                                    COUNT(EMPLOYEE_ID) AS EMP_CT
                                FROM  
                                    get_out_emp_count WHERE BRANCH_ID = #get_out_branch.BRANCH_ID#
                            </cfquery>
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
                            <cfif cikis_emp.recordcount>
                                <cfset cikis = cikis_emp.EMP_CT>
                            <cfelse>
                                <cfset cikis = 0>
                            </cfif>
                            <cfif isdefined('is_removal')>
                                <cfquery name="nakil_cnt" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_nakil_emp_count WHERE BRANCH_ID = #get_out_branch.BRANCH_ID#
                                </cfquery>	
                                <cfif len(nakil_cnt.EMP_CT)>
                                	<cfset aktif_2 = aktif_2 + nakil_cnt.EMP_CT>
								</cfif>
                            </cfif>
                            <cfif aktif_2 neq 0 or aktif_1 neq 0>
                                <cfset ortalama = wrk_round((aktif_1 + aktif_2) / 2)>
                            </cfif>
                            <cfsavecontent variable="header">#BRANCH_NAME#-#COMPANY_NAME#</cfsavecontent>
                            <cfsavecontent variable="deger"><cfif ortalama gt 0>#wrk_round((cikis * 100) / ortalama)#<cfelse>0</cfif></cfsavecontent>
                            <cfif deger gt 0>
                                <cfchartdata item="#header#" value="#deger#">
                            </cfif>
                        </cfoutput>
                    </cfchartseries>
                </cfchart>
            </td>
            </table>
             <!-- sil -->
        <cfelseif isdefined('report_type_batch') and report_type_batch eq 2>
             <cfquery name="get_out_department" datasource="#dsn#">
                SELECT     
                    OC.COMPANY_NAME, 
                    B.BRANCH_NAME,
                    D.DEPARTMENT_HEAD,
                    D.DEPARTMENT_ID
                FROM 
                    DEPARTMENT D
                    INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
                    INNER JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
                WHERE
                    D.IS_STORE <> 1 
                    AND D.DEPARTMENT_STATUS = 1
                    <cfif len(attributes.comp_id)>
                        AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">)
                    </cfif>
                    <cfif len(attributes.branch_id)>
                        AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
                    </cfif>
                    <cfif not session.ep.ehesap>
                        AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
                        AND OC.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
                    </cfif>
                    <cfif len(attributes.department)>
                        AND D.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#" list = "yes">)
                    </cfif> 
                    <cfif len(attributes.hierarchy)>
                        AND D.HIERARCHY = '#attributes.hierarchy#'
                    </cfif>
                ORDER BY
                    OC.COMPANY_NAME, B.BRANCH_NAME, D.DEPARTMENT_HEAD
            </cfquery>
                    <thead>
                        <tr>
                            <th colspan="8">Departmana göre</th>
                        </tr>
                        <tr>
                            <th><cf_get_lang_main no='162.Şirket'></th>
                            <th><cf_get_lang_main no='41.Şube'></th>
                            <th><cf_get_lang_main no='160.Departman'></th>
                            <th style="width:80px;"><cf_get_lang dictionary_id='61301.Dönem Başı Çalışan Sayısı'></th>
                            <th style="width:80px;"><cf_get_lang dictionary_id='61302.Dönem Sonu Çalışan Sayısı'></th>
                            <th style="width:60px;"><cf_get_lang dictionary_id='61303.İşe Giren Sayısı'></th>
                            <th style="width:70px;"><cf_get_lang dictionary_id='61304.İşten Çıkan Sayısı'></th>
                            <th class="header_icn_text"><cf_get_lang dictionary_id='59148.Çalışan Devir Oranı (Turnover) Raporu'></th>
                        </tr>
                    </thead>
                    <tbody>	
                        <cfif get_out_department.recordcount>
                            <cfset total_emp=0>
                            <cfset ortalama = 0>
                            <cfset total_giris=0>
                            <cfset total_aktif2=0>
                            <cfset total_aktif1=0>
                            <cfoutput query="get_out_department">
                                <cfquery name="stdt_aktif" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_stdt_emp_count WHERE DEPARTMENT_ID = #get_out_department.DEPARTMENT_ID# <cfif len(attributes.hierarchy)>AND HIERARCHY = '#attributes.hierarchy#'</cfif>
                                </cfquery>	
                                <cfquery name="fndt_aktif" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_fndt_emp_count WHERE DEPARTMENT_ID = #get_out_department.DEPARTMENT_ID# <cfif len(attributes.hierarchy)>AND HIERARCHY = '#attributes.hierarchy#'</cfif>
                                </cfquery>	
                                <cfquery name="giris_emp" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_in_emp_count WHERE DEPARTMENT_ID = #get_out_department.DEPARTMENT_ID# <cfif len(attributes.hierarchy)>AND HIERARCHY = '#attributes.hierarchy#'</cfif>
                                </cfquery>
                                <cfquery name="cikis_emp" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_out_emp_count WHERE DEPARTMENT_ID = #get_out_department.DEPARTMENT_ID# <cfif len(attributes.hierarchy)>AND HIERARCHY = '#attributes.hierarchy#'</cfif>
                                </cfquery>
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
                                <cfif giris_emp.recordcount>
                                    <cfset giris = giris_emp.EMP_CT>
                                <cfelse>
                                    <cfset giris = 0>
                                </cfif>
                                <cfif cikis_emp.recordcount>
                                    <cfset cikis = cikis_emp.EMP_CT>
                                <cfelse>
                                    <cfset cikis = 0>
                                </cfif>
                                <cfif isdefined('is_removal')>
                                    <cfquery name="nakil_cnt" dbtype="query">
                                        SELECT 
                                            COUNT(EMPLOYEE_ID) AS EMP_CT
                                        FROM  
                                            get_nakil_emp_count WHERE DEPARTMENT_ID = #get_out_department.DEPARTMENT_ID# <cfif len(attributes.hierarchy)>AND HIERARCHY = '#attributes.hierarchy#'</cfif>
                                    </cfquery>	
                                    <cfif nakil_cnt.recordcount>
                                        <cfset aktif_2 = nakil_cnt.EMP_CT + aktif_2>
                                    </cfif>
                                </cfif>
                                <cfif aktif_2 neq 0 or aktif_1 neq 0>
                                    <cfset ortalama = wrk_round((aktif_1 + aktif_2) / 2)>
                                </cfif>
                                <tr>
                                    <cfset total_emp = total_emp + cikis>
                                    <cfset total_giris = total_giris + giris>
                                    <cfset total_aktif2 = total_aktif2 + aktif_2>
                                    <cfset total_aktif1 = total_aktif1 + aktif_1>
                                    <td>#COMPANY_NAME#</td>
                                    <td>#BRANCH_NAME#</td>
                                    <td>#DEPARTMENT_HEAD#</td>
                                    <td style="text-align:center; width:80px;">#aktif_1#</td>
                                    <td style="text-align:center; width:80px;">#aktif_2#</td>
                                    <td style="text-align:center; width:60px;">#giris#</td>
                                    <td style="text-align:center; width:70px;">#cikis#</td>
                                    <td style="text-align:center; width:80px;"><cfif ortalama gt 0>#wrk_round((cikis * 100) / ortalama)#%<cfelse>-</cfif></td>
                                </tr>
                            </cfoutput>
                            <tfoot>
                                <tr>
                                    <td colspan="3" style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                    <td style="text-align:center; width:80px;" class="txtbold"><cfoutput>#total_aktif1#</cfoutput></td>
                                    <td style="text-align:center; width:80px;" class="txtbold"><cfoutput>#total_aktif2#</cfoutput></td>
                                    <td style="text-align:center; width:60px;" class="txtbold"><cfoutput>#total_giris#</cfoutput></td>
                                    <td style="text-align:center; width:70px;" class="txtbold"><cfoutput>#total_emp#</cfoutput></td>
                                    <td></td>
                                </tr>
                            </tfoot>
                        <cfelse>
                            <tr><td colspan="8"><cf_get_lang_main no ='72.Kayıt Yok'></td></tr>
                        </cfif>
                    </tbody>
             <!-- sil -->
            <table>
            <td valign="top">
                <cfset my_height = ((get_out_department.recordcount*20)+90)>
                <cfif my_height lt 200>
                    <cfset my_height = 200>
                <cfelseif my_height gt 400>
                    <cfset my_height = 400>
                </cfif>
                <cfchart chartheight="#my_height#" chartwidth="300" show3D="yes" format="jpg" font="Arial" labelformat="number" pieslicestyle="solid">
                    <cfchartseries type="bar" itemcolumn="DEPARTMENT_HEAD" colorlist="0099FF,6666CC,33CC33,CC6600,FF6600,FFCC00,FF66FF,999933,CCCC99,996699" paintstyle="raise">
                        <cfoutput query="get_out_department">
                            <cfquery name="stdt_aktif" dbtype="query">
                                SELECT 
                                    COUNT(EMPLOYEE_ID) AS EMP_CT
                                FROM  
                                    get_stdt_emp_count WHERE DEPARTMENT_ID = #get_out_department.DEPARTMENT_ID# <cfif len(attributes.hierarchy)>AND HIERARCHY = '#attributes.hierarchy#'</cfif>
                            </cfquery>	
                            <cfquery name="fndt_aktif" dbtype="query">
                                SELECT 
                                    COUNT(EMPLOYEE_ID) AS EMP_CT
                                FROM  
                                    get_fndt_emp_count WHERE DEPARTMENT_ID = #get_out_department.DEPARTMENT_ID# <cfif len(attributes.hierarchy)>AND HIERARCHY = '#attributes.hierarchy#'</cfif>
                            </cfquery>	
                            <cfquery name="cikis_emp" dbtype="query">
                                SELECT 
                                    COUNT(EMPLOYEE_ID) AS EMP_CT
                                FROM  
                                    get_out_emp_count WHERE DEPARTMENT_ID = #get_out_department.DEPARTMENT_ID# <cfif len(attributes.hierarchy)>AND HIERARCHY = '#attributes.hierarchy#'</cfif>
                            </cfquery>
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
                            <cfif cikis_emp.recordcount>
                                <cfset cikis = cikis_emp.EMP_CT>
                            <cfelse>
                                <cfset cikis = 0>
                            </cfif>
                            <cfif isdefined('is_removal')>
                                <cfquery name="nakil_cnt" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_nakil_emp_count WHERE DEPARTMENT_ID = #get_out_department.DEPARTMENT_ID# <cfif len(attributes.hierarchy)>AND HIERARCHY = '#attributes.hierarchy#'</cfif>
                                </cfquery>	
                                <cfif nakil_cnt.recordcount>
                                    <cfset aktif_2 = nakil_cnt.EMP_CT + aktif_2>
                                </cfif>
                            </cfif>
                            <cfif aktif_2 neq 0 or aktif_1 neq 0>
                                <cfset ortalama = wrk_round((aktif_1 + aktif_2) / 2)>
                            </cfif>
                            <cfsavecontent variable="header">#DEPARTMENT_HEAD#-#BRANCH_NAME#-#COMPANY_NAME#</cfsavecontent>
                            <cfsavecontent variable="deger"><cfif ortalama gt 0>#wrk_round((cikis * 100) / ortalama)#<cfelse>0</cfif></cfsavecontent>
                            <cfif deger gt 0>
                                <cfchartdata item="#header#" value="#deger#">
                            </cfif>
                        </cfoutput>
                    </cfchartseries>
                </cfchart>
            </td>
            </table>
             <!-- sil -->
        <cfelseif isdefined('report_type_batch') and report_type_batch eq 3>
             <cfquery name="get_out_title" datasource="#dsn#">
                SELECT DISTINCT
                    ST.TITLE,
                    ST.TITLE_ID
                FROM
                	SETUP_TITLE ST
                	<cfif len(attributes.hierarchy)>
                            ,EMPLOYEE_POSITIONS EP
                            ,DEPARTMENT D
                        WHERE
                            EP.TITLE_ID = ST.TITLE_ID
                            AND D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                            AND D.HIERARCHY = '#attributes.hierarchy#'
                    </cfif>
                ORDER BY
                    ST.TITLE
            </cfquery>
                    <thead>
                        <tr>
                            <th colspan="6">Ünvana göre</th>
                        </tr>
                        <tr>
                            <th><cf_get_lang_main no='159.Ünvan'></th>
                            <th style="width:80px;"><cf_get_lang dictionary_id='61301.Dönem Başı Çalışan Sayısı'></th>
                            <th style="width:80px;"><cf_get_lang dictionary_id='61302.Dönem Sonu Çalışan Sayısı'></th>
                            <th style="width:60px;"><cf_get_lang dictionary_id='61303.İşe Giren Sayısı'></th>
                            <th style="width:70px;"><cf_get_lang dictionary_id='61303.İşe Giren Sayısı'></th>
                            <th class="header_icn_text"><cf_get_lang dictionary_id='59148.Çalışan Devir Oranı (Turnover) Raporu'></th>
                        </tr>
                    </thead>
                    <tbody>	
                        <cfif get_out_title.recordcount>
                            <cfset total_emp=0>
                            <cfset ortalama=0>
                            <cfset total_giris=0>
                            <cfset total_aktif2=0>
                            <cfset total_aktif1=0>
                            <cfoutput query="get_out_title">
                                <cfquery name="stdt_aktif" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_stdt_emp_count WHERE TITLE_ID <cfif len(get_out_title.TITLE_ID)>= #get_out_title.TITLE_ID#<cfelse>IS NULL</cfif> <cfif len(attributes.hierarchy)>AND HIERARCHY = '#attributes.hierarchy#'</cfif>
                                </cfquery>	
                                <cfquery name="fndt_aktif" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_fndt_emp_count WHERE TITLE_ID <cfif len(get_out_title.TITLE_ID)>= #get_out_title.TITLE_ID#<cfelse>IS NULL</cfif> <cfif len(attributes.hierarchy)>AND HIERARCHY = '#attributes.hierarchy#'</cfif>
                                </cfquery>	
                                <cfquery name="giris_emp" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_in_emp_count WHERE TITLE_ID <cfif len(get_out_title.TITLE_ID)>= #get_out_title.TITLE_ID#<cfelse>IS NULL</cfif> <cfif len(attributes.hierarchy)>AND HIERARCHY = '#attributes.hierarchy#'</cfif>
                                </cfquery>
                                <cfquery name="cikis_emp" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_out_emp_count WHERE TITLE_ID <cfif len(get_out_title.TITLE_ID)>= #get_out_title.TITLE_ID#<cfelse>IS NULL</cfif> <cfif len(attributes.hierarchy)>AND HIERARCHY = '#attributes.hierarchy#'</cfif>
                                </cfquery>
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
                                <cfif giris_emp.recordcount>
                                    <cfset giris = giris_emp.EMP_CT>
                                <cfelse>
                                    <cfset giris = 0>
                                </cfif>
                                <cfif cikis_emp.recordcount>
                                    <cfset cikis = cikis_emp.EMP_CT>
                                <cfelse>
                                    <cfset cikis = 0>
                                </cfif>
                                <cfif isdefined('is_removal')>
                                    <cfquery name="nakil_cnt" dbtype="query">
                                        SELECT 
                                            COUNT(EMPLOYEE_ID) AS EMP_CT
                                        FROM  
                                            get_nakil_emp_count WHERE TITLE_ID <cfif len(get_out_title.TITLE_ID)>= #get_out_title.TITLE_ID#<cfelse>IS NULL</cfif> <cfif len(attributes.hierarchy)>AND HIERARCHY = '#attributes.hierarchy#'</cfif>
                                    </cfquery>	
                                    <cfif nakil_cnt.recordcount>
                                        <cfset aktif_2 = nakil_cnt.EMP_CT + aktif_2>
                                    </cfif>
                                </cfif>
                                <cfif aktif_2 neq 0 or aktif_1 neq 0>
                                    <cfset ortalama = wrk_round((aktif_1 + aktif_2) / 2)>
                                </cfif>
                                <tr>
                                    <cfset total_emp = total_emp + cikis>
                                    <cfset total_giris = total_giris + giris>
                                    <cfset total_aktif2 = total_aktif2 + aktif_2>
                                    <cfset total_aktif1 = total_aktif1 + aktif_1>
                                    <td><cfif len(title)>#TITLE#<cfelse><cf_get_lang dictionary_id='61306.Tanımlı Olmayanlar'></cfif></td>
                                    <td style="text-align:center; width:80px;">#aktif_1#</td>
                                    <td style="text-align:center; width:80px;">#aktif_2#</td>
                                    <td style="text-align:center; width:60px;">#giris#</td>
                                    <td style="text-align:center; width:70px;">#cikis#</td>
                                    <td style="text-align:center; width:80px;"><cfif ortalama gt 0>#wrk_round((cikis * 100) / ortalama)#%<cfelse>-</cfif></td>
                                </tr>
                            </cfoutput>
                            <tfoot>
                                <tr>
                                    <td style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                    <td style="text-align:center; width:80px;" class="txtbold"><cfoutput>#total_aktif1#</cfoutput></td>
                                    <td style="text-align:center; width:80px;" class="txtbold"><cfoutput>#total_aktif2#</cfoutput></td>
                                    <td style="text-align:center; width:60px;" class="txtbold"><cfoutput>#total_giris#</cfoutput></td>
                                    <td style="text-align:center; width:70px;" class="txtbold"><cfoutput>#total_emp#</cfoutput></td>
                                    <td></td>
                                </tr>
                            </tfoot>
                        <cfelse>
                            <tr><td colspan="6"><cf_get_lang_main no ='72.Kayıt Yok'></td></tr>
                        </cfif>
                    </tbody>
             <!-- sil -->
            <table>
             <td valign="top">
                <cfset my_height = ((get_out_title.recordcount*20)+90)>
                <cfif my_height lt 200>
                    <cfset my_height = 200>
                <cfelseif my_height gt 400>
                    <cfset my_height = 400>
                </cfif>
                <cfchart chartheight="#my_height#" chartwidth="300" show3D="yes" format="jpg" font="Arial" labelformat="number" pieslicestyle="solid">
                    <cfchartseries type="bar" itemcolumn="TITLE" colorlist="0099FF,6666CC,33CC33,CC6600,FF6600,FFCC00,FF66FF,999933,CCCC99,996699" paintstyle="raise">
                        <cfoutput query="get_out_title">
                            <cfquery name="stdt_aktif" dbtype="query">
                                SELECT 
                                    COUNT(EMPLOYEE_ID) AS EMP_CT
                                FROM  
                                    get_stdt_emp_count WHERE TITLE_ID <cfif len(get_out_title.TITLE_ID)>= #get_out_title.TITLE_ID#<cfelse>IS NULL</cfif> <cfif len(attributes.hierarchy)>AND HIERARCHY = '#attributes.hierarchy#'</cfif>
                            </cfquery>	
                            <cfquery name="fndt_aktif" dbtype="query">
                                SELECT 
                                    COUNT(EMPLOYEE_ID) AS EMP_CT
                                FROM  
                                    get_fndt_emp_count WHERE TITLE_ID <cfif len(get_out_title.TITLE_ID)>= #get_out_title.TITLE_ID#<cfelse>IS NULL</cfif> <cfif len(attributes.hierarchy)>AND HIERARCHY = '#attributes.hierarchy#'</cfif>
                            </cfquery>
                            <cfquery name="cikis_emp" dbtype="query">
                                SELECT 
                                    COUNT(EMPLOYEE_ID) AS EMP_CT
                                FROM  
                                    get_out_emp_count WHERE TITLE_ID <cfif len(get_out_title.TITLE_ID)>= #get_out_title.TITLE_ID#<cfelse>IS NULL</cfif> <cfif len(attributes.hierarchy)>AND HIERARCHY = '#attributes.hierarchy#'</cfif>
                            </cfquery>	
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
                            <cfif cikis_emp.recordcount>
                                <cfset cikis = cikis_emp.EMP_CT>
                            <cfelse>
                                <cfset cikis = 0>
                            </cfif>
                            <cfif isdefined('is_removal')>
                                <cfquery name="nakil_cnt" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_nakil_emp_count WHERE TITLE_ID <cfif len(get_out_title.TITLE_ID)>= #get_out_title.TITLE_ID#<cfelse>IS NULL</cfif> <cfif len(attributes.hierarchy)>AND HIERARCHY = '#attributes.hierarchy#'</cfif>
                                </cfquery>	
                                <cfif nakil_cnt.recordcount>
                                    <cfset aktif_2 = nakil_cnt.EMP_CT + aktif_2>
                                </cfif>
                            </cfif>
                            <cfif aktif_2 neq 0 or aktif_1 neq 0>
                                <cfset ortalama = wrk_round((aktif_1 + aktif_2) / 2)>
                            </cfif>
                            <cfsavecontent variable="header"><cfif len(title)>#TITLE#<cfelse><cf_get_lang dictionary_id='61306.Tanımlı Olmayanlar'></cfif></cfsavecontent>
                            <cfsavecontent variable="deger"><cfif ortalama gt 0>#wrk_round((cikis * 100) / ortalama)#<cfelse>0</cfif></cfsavecontent>
                            <cfif deger gt 0>
                                <cfchartdata item="#header#" value="#deger#">
                            </cfif>
                        </cfoutput>
                    </cfchartseries>
                </cfchart>
             </td>
            </table>
             <!-- sil -->
        <cfelseif isdefined('report_type_batch') and report_type_batch eq 4>
             <cfquery name="get_out_function" datasource="#dsn#">
                SELECT DISTINCT
                    CU.UNIT_NAME,
                    CU.UNIT_ID
                FROM 
                    SETUP_CV_UNIT CU
                    <cfif len(attributes.hierarchy)>
                            ,EMPLOYEE_POSITIONS EP
                            ,DEPARTMENT D
                   </cfif>
                WHERE
                    1=1
                    <cfif len(attributes.unit_id)>
                        AND CU.UNIT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#" list = "yes">)
                    </cfif>
                    <cfif len(attributes.hierarchy)>
                    	AND EP.FUNC_ID = CU.UNIT_ID
                        AND D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                        AND D.HIERARCHY = '#attributes.hierarchy#'
                    </cfif>
                ORDER BY
                    CU.UNIT_NAME
            </cfquery>
                    <thead>
                        <tr>
                            <th colspan="6"><cf_get_lang dictionary_id='61307.Fonksiyona göre'></th>
                        </tr>
                        <tr>
                            <th><cf_get_lang_main no='1289.Fonksiyon'></th>
                            <th style="width:80px;"><cf_get_lang dictionary_id='61301.Dönem Başı Çalışan Sayısı'></th>
                            <th style="width:80px;"><cf_get_lang dictionary_id='61302.Dönem Sonu Çalışan Sayısı'></th>
                            <th style="width:60px;"><cf_get_lang dictionary_id='61303.İşe Giren Sayısı'></th>
                            <th style="width:70px;"><cf_get_lang dictionary_id='61304.İşten Çıkan Sayısı'></th>
                            <th class="header_icn_text"><cf_get_lang dictionary_id='59148.Çalışan Devir Oranı (Turnover) Raporu'></th>
                        </tr>
                    </thead>
                    <tbody>	
                        <cfif get_out_function.recordcount>
                            <cfset total_emp=0>
                            <cfset ortalama=0>
                            <cfset total_giris=0>
                            <cfset total_aktif2=0>
                            <cfset total_aktif1=0>
                            <cfoutput query="get_out_function">
                                <cfquery name="stdt_aktif" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_stdt_emp_count WHERE FUNC_ID <cfif len(get_out_function.UNIT_ID)>= #get_out_function.UNIT_ID#<cfelse>IS NULL</cfif>
                                </cfquery>	
                                <cfquery name="fndt_aktif" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_fndt_emp_count WHERE FUNC_ID <cfif len(get_out_function.UNIT_ID)>= #get_out_function.UNIT_ID#<cfelse>IS NULL</cfif>
                                </cfquery>	
                                <cfquery name="giris_emp" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_in_emp_count WHERE FUNC_ID <cfif len(get_out_function.UNIT_ID)>= #get_out_function.UNIT_ID#<cfelse>IS NULL</cfif>
                                </cfquery>
                                <cfquery name="cikis_emp" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_out_emp_count WHERE FUNC_ID <cfif len(get_out_function.UNIT_ID)>= #get_out_function.UNIT_ID#<cfelse>IS NULL</cfif>
                                </cfquery>	
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
                                <cfif giris_emp.recordcount>
                                    <cfset giris = giris_emp.EMP_CT>
                                <cfelse>
                                    <cfset giris = 0>
                                </cfif>
                                <cfif cikis_emp.recordcount>
                                    <cfset cikis = cikis_emp.EMP_CT>
                                <cfelse>
                                    <cfset cikis = 0>
                                </cfif>
                                <cfif isdefined('is_removal')>
                                    <cfquery name="nakil_cnt" dbtype="query">
                                        SELECT 
                                            COUNT(EMPLOYEE_ID) AS EMP_CT
                                        FROM  
                                            get_nakil_emp_count WHERE FUNC_ID <cfif len(get_out_function.UNIT_ID)>= #get_out_function.UNIT_ID#<cfelse>IS NULL</cfif>
                                    </cfquery>	
                                    <cfif nakil_cnt.recordcount>
                                        <cfset aktif_2 = nakil_cnt.EMP_CT + aktif_2>
                                    </cfif>
                                </cfif>
                                <cfif aktif_2 neq 0 or aktif_1 neq 0>
                                    <cfset ortalama = wrk_round((aktif_1 + aktif_2) / 2)>
                                </cfif>
                                <tr>
                                    <cfset total_emp = total_emp + cikis>
                                    <cfset total_giris = total_giris + giris>
                                    <cfset total_aktif2 = total_aktif2 + aktif_2>
                                    <cfset total_aktif1 = total_aktif1 + aktif_1>
                                    <td><cfif len(UNIT_NAME)>#UNIT_NAME#<cfelse><cf_get_lang dictionary_id='61306.Tanımlı Olmayanlar'></cfif></td>
                                    <td style="text-align:center; width:80px;">#aktif_1#</td>
                                    <td style="text-align:center; width:80px;">#aktif_2#</td>
                                    <td style="text-align:center; width:60px;">#giris#</td>
                                    <td style="text-align:center; width:70px;">#cikis#</td>
                                    <td style="text-align:center; width:80px;"><cfif ortalama gt 0>#wrk_round((cikis * 100) / ortalama)#%<cfelse>-</cfif></td>
                                </tr>
                            </cfoutput>
                            <tfoot>
                                <tr>
                                    <td style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                    <td style="text-align:center; width:80px;" class="txtbold"><cfoutput>#total_aktif1#</cfoutput></td>
                                    <td style="text-align:center; width:80px;" class="txtbold"><cfoutput>#total_aktif2#</cfoutput></td>
                                    <td style="text-align:center; width:60px;" class="txtbold"><cfoutput>#total_giris#</cfoutput></td>
                                    <td style="text-align:center; width:70px;" class="txtbold"><cfoutput>#total_emp#</cfoutput></td>
                                    <td></td>
                                </tr>
                            </tfoot>
                        <cfelse>
                            <tr><td colspan="6"><cf_get_lang_main no ='72.Kayıt Yok'></td></tr>
                        </cfif>
                    </tbody>
             <!-- sil -->
            <table>
            <td valign="top">
                <cfset my_height = ((get_out_function.recordcount*20)+90)>
                <cfif my_height lt 200>
                    <cfset my_height = 200>
                <cfelseif my_height gt 400>
                    <cfset my_height = 400>
                </cfif>
                <cfchart chartheight="#my_height#" chartwidth="300" show3D="yes" format="jpg" font="Arial" labelformat="number" pieslicestyle="solid">
                    <cfchartseries type="bar" itemcolumn="UNIT_NAME" colorlist="0099FF,6666CC,33CC33,CC6600,FF6600,FFCC00,FF66FF,999933,CCCC99,996699" paintstyle="raise">
                        <cfoutput query="get_out_function">
                            <cfquery name="stdt_aktif" dbtype="query">
                                SELECT 
                                    COUNT(EMPLOYEE_ID) AS EMP_CT
                                FROM  
                                    get_stdt_emp_count WHERE FUNC_ID <cfif len(get_out_function.UNIT_ID)>= #get_out_function.UNIT_ID#<cfelse>IS NULL</cfif>
                            </cfquery>	
                            <cfquery name="fndt_aktif" dbtype="query">
                                SELECT 
                                    COUNT(EMPLOYEE_ID) AS EMP_CT
                                FROM  
                                    get_fndt_emp_count WHERE FUNC_ID <cfif len(get_out_function.UNIT_ID)>= #get_out_function.UNIT_ID#<cfelse>IS NULL</cfif>
                            </cfquery>	
                            <cfquery name="cikis_emp" dbtype="query">
                                SELECT 
                                    COUNT(EMPLOYEE_ID) AS EMP_CT
                                FROM  
                                    get_out_emp_count WHERE FUNC_ID <cfif len(get_out_function.UNIT_ID)>= #get_out_function.UNIT_ID#<cfelse>IS NULL</cfif>
                            </cfquery>	
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
                            <cfif cikis_emp.recordcount>
                                <cfset cikis = cikis_emp.EMP_CT>
                            <cfelse>
                                <cfset cikis = 0>
                            </cfif>
                            <cfif isdefined('is_removal')>
                                <cfquery name="nakil_cnt" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_nakil_emp_count WHERE FUNC_ID <cfif len(get_out_function.UNIT_ID)>= #get_out_function.UNIT_ID#<cfelse>IS NULL</cfif>
                                </cfquery>	
                                <cfif nakil_cnt.recordcount>
                                    <cfset aktif_2 = nakil_cnt.EMP_CT + aktif_2>
                                </cfif>
                            </cfif>
                            <cfif aktif_2 neq 0 or aktif_1 neq 0>
                                <cfset ortalama = wrk_round((aktif_1 + aktif_2) / 2)>
                            </cfif>
                            <cfsavecontent variable="header"><cfif len(UNIT_NAME)>#UNIT_NAME#<cfelse><cf_get_lang dictionary_id='61306.Tanımlı Olmayanlar'></cfif></cfsavecontent>
                            <cfsavecontent variable="deger"><cfif ortalama gt 0>#wrk_round((cikis * 100) / ortalama)#<cfelse>0</cfif></cfsavecontent>
                            <cfif deger gt 0>
                                <cfchartdata item="#header#" value="#deger#">
                            </cfif>
                        </cfoutput>
                    </cfchartseries>
                </cfchart>
            </td>
            </table>
             <!-- sil -->
        <cfelseif isdefined('report_type_batch') and report_type_batch eq 5>
             <cfquery name="get_out_zone" datasource="#dsn#">
                SELECT DISTINCT 
                    Z.ZONE_ID,
                    Z.ZONE_NAME
                FROM
                    ZONE Z INNER JOIN BRANCH B ON B.ZONE_ID = Z.ZONE_ID
                    INNER JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
                WHERE
                    Z.ZONE_STATUS=1
                    <cfif len(attributes.comp_id)>
                        AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">)
                    </cfif>
                    <cfif len(attributes.zone_id)>
                        AND B.ZONE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#" list = "yes">)
                    </cfif>
                ORDER BY
                    Z.ZONE_NAME
            </cfquery>
                    <thead>
                        <tr>
                            <th colspan="6"><cf_get_lang dictionary_id='61308.Bölgeye göre'></th>
                        </tr>
                        <tr>
                            <th><cf_get_lang_main no='580.Bölge'></th>
                            <th style="width:80px;"><cf_get_lang dictionary_id='61301.Dönem Başı Çalışan Sayısı'></th>
                            <th style="width:80px;"><cf_get_lang dictionary_id='61302.Dönem Sonu Çalışan Sayısı'></th>
                            <th style="width:60px;"><cf_get_lang dictionary_id='61303.İşe Giren Sayısı'></th>
                            <th style="width:70px;"><cf_get_lang dictionary_id='61304.İşten Çıkan Sayısı'></th>
                            <th class="header_icn_text"><cf_get_lang dictionary_id='59148.Çalışan Devir Oranı (Turnover) Raporu'></th>
                        </tr>
                    </thead>
                    <tbody>	
                        <cfif get_out_zone.recordcount>
                            <cfset total_emp=0>
                            <cfset ortalama = 0>
                            <cfset total_giris=0>
                            <cfset total_aktif2=0>
                            <cfset total_aktif1=0>
                            <cfoutput query="get_out_zone">
                                <cfquery name="stdt_aktif" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_stdt_emp_count WHERE ZONE_ID = #get_out_zone.ZONE_ID#
                                </cfquery>	
                                <cfquery name="fndt_aktif" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_fndt_emp_count WHERE ZONE_ID = #get_out_zone.ZONE_ID#
                                </cfquery>	
                                <cfquery name="giris_emp" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_in_emp_count WHERE ZONE_ID = #get_out_zone.ZONE_ID#
                                </cfquery>
                                <cfquery name="cikis_emp" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_out_emp_count WHERE ZONE_ID = #get_out_zone.ZONE_ID#
                                </cfquery>
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
                                <cfif giris_emp.recordcount>
                                    <cfset giris = giris_emp.EMP_CT>
                                <cfelse>
                                    <cfset giris = 0>
                                </cfif>
                                <cfif cikis_emp.recordcount>
                                    <cfset cikis = cikis_emp.EMP_CT>
                                <cfelse>
                                    <cfset cikis = 0>
                                </cfif>
                                <cfif isdefined('is_removal')>
                                    <cfquery name="nakil_cnt" dbtype="query">
                                        SELECT 
                                            COUNT(EMPLOYEE_ID) AS EMP_CT
                                        FROM  
                                            get_nakil_emp_count WHERE ZONE_ID = #get_out_zone.ZONE_ID#
                                    </cfquery>	
                                    <cfif nakil_cnt.recordcount>
                                        <cfset nakil_sys = nakil_cnt.EMP_CT>
                                    <cfelse>
                                        <cfset nakil_sys = 0>
                                    </cfif>
                                    <cfset aktif_2 = aktif_2 + nakil_sys>
                                </cfif>
                                <cfif aktif_2 neq 0 or aktif_1 neq 0>
                                    <cfset ortalama = wrk_round((aktif_1 + aktif_2) / 2)>
                                </cfif>
                                <tr>
                                    <cfset total_emp = total_emp + cikis>
                                    <cfset total_giris = total_giris + giris>
                                    <cfset total_aktif2 = total_aktif2 + aktif_2>
                                    <cfset total_aktif1 = total_aktif1 + aktif_1>
                                    <td>#ZONE_NAME#</td>
                                    <td style="text-align:center; width:80px;">#aktif_1#</td>
                                    <td style="text-align:center; width:80px;">#aktif_2#</td>
                                    <td style="text-align:center; width:60px;">#giris#</td>
                                    <td style="text-align:center; width:70px;">#cikis#</td>
                                    <td style="text-align:center; width:80px;"><cfif ortalama gt 0>#wrk_round((cikis * 100) / ortalama)#%<cfelse>-</cfif></td>
                                </tr>
                            </cfoutput>
                            <tfoot>
                                <tr>
                                    <td style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                    <td style="text-align:center; width:80px;" class="txtbold"><cfoutput>#total_aktif1#</cfoutput></td>
                                    <td style="text-align:center; width:80px;" class="txtbold"><cfoutput>#total_aktif2#</cfoutput></td>
                                    <td style="text-align:center; width:60px;" class="txtbold"><cfoutput>#total_giris#</cfoutput></td>
                                    <td style="text-align:center; width:70px;" class="txtbold"><cfoutput>#total_emp#</cfoutput></td>
                                    <td></td>
                                </tr>
                            </tfoot>
                        <cfelse>
                            <tr><td colspan="6"><cf_get_lang_main no ='72.Kayıt Yok'></td></tr>
                        </cfif>
                    </tbody>
             <!-- sil -->
             <table>
            <td valign="top">
                <cfset my_height = ((get_out_zone.recordcount*20)+90)>
                <cfif my_height lt 200>
                    <cfset my_height = 200>
                <cfelseif my_height gt 400>
                    <cfset my_height = 400>
                </cfif>
                <cfchart chartheight="#my_height#" chartwidth="300" show3D="yes" format="jpg" font="Arial" labelformat="number" pieslicestyle="solid">
                    <cfchartseries type="bar" itemcolumn="ZONE_NAME" colorlist="0099FF,6666CC,33CC33,CC6600,FF6600,FFCC00,FF66FF,999933,CCCC99,996699" paintstyle="raise">
                        <cfoutput query="get_out_zone">
                            <cfquery name="stdt_aktif" dbtype="query">
                                SELECT 
                                    COUNT(EMPLOYEE_ID) AS EMP_CT
                                FROM  
                                    get_stdt_emp_count WHERE ZONE_ID = #get_out_zone.ZONE_ID#
                            </cfquery>	
                            <cfquery name="fndt_aktif" dbtype="query">
                                SELECT 
                                    COUNT(EMPLOYEE_ID) AS EMP_CT
                                FROM  
                                    get_fndt_emp_count WHERE ZONE_ID = #get_out_zone.ZONE_ID#
                            </cfquery>	
                            <cfquery name="cikis_emp" dbtype="query">
                                SELECT 
                                    COUNT(EMPLOYEE_ID) AS EMP_CT
                                FROM  
                                    get_out_emp_count WHERE ZONE_ID = #get_out_zone.ZONE_ID#
                            </cfquery>
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
                            <cfif cikis_emp.recordcount>
                                <cfset cikis = cikis_emp.EMP_CT>
                            <cfelse>
                                <cfset cikis = 0>
                            </cfif>
                            <cfif isdefined('is_removal')>
                            	
                                <cfquery name="nakil_cnt" dbtype="query">
                                    SELECT 
                                        COUNT(EMPLOYEE_ID) AS EMP_CT
                                    FROM  
                                        get_nakil_emp_count WHERE ZONE_ID = #get_out_zone.ZONE_ID#
                                </cfquery>
                                <cfif len(nakil_cnt.EMP_CT)>
                                	<cfset aktif_2 = aktif_2 + nakil_cnt.EMP_CT>
								</cfif>
                            </cfif>
                            <cfif aktif_2 neq 0 or aktif_1 neq 0>
                                <cfset ortalama = wrk_round((aktif_1 + aktif_2) / 2)>
                            </cfif>
                            <cfsavecontent variable="header">#ZONE_NAME#</cfsavecontent>
                            <cfsavecontent variable="deger"><cfif ortalama gt 0>#wrk_round((cikis * 100) / ortalama)#<cfelse>0</cfif></cfsavecontent>
                            <cfif deger gt 0>
                                <cfchartdata item="#header#" value="#deger#">
                            </cfif>
                        </cfoutput>
                    </cfchartseries>
                </cfchart>
            </td>
            </table>
             <!-- sil -->
        </cfif>
</cf_report_list>
