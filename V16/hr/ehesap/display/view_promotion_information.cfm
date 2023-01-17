<!---
    File: V16\hr\ehesap\display\view_promotion_information.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2022-01-28
    Description: Terfi bilgileri raporu
    History:
    To Do:

--->
<cfset title = "#UCase(getLang('','Aylık Terfi Bilgileri','65082'))#">


<cfset get_title_cmp = createObject("component","V16.hr.cfc.get_titles")>

<cfset get_component = createObject("component","V16.hr.ehesap.cfc.payroll_job")>

<cfif get_puantaj_personal.recordCount eq 0>
    <cf_box title="Bordro"><cf_get_lang dictionary_id="57484.Kayıt Yok">!</cf_box>
    <cfabort>
</cfif>
<cfset get_factor = get_component.get_factor_definition(
        start_month : puantaj_start_,
        end_month : puantaj_start_
    )>
<cfset factor = get_factor.salary_factor><!--- Aylık Katsayı --->

<cfset last_date = dateadd("m",-1,puantaj_start_)>
<cfset get_factor_old = get_component.get_factor_definition(
        start_month : last_date,
        end_month : last_date
    )>
<cfset factor_old = get_factor_old.salary_factor><!--- Aylık Katsayı önceki ay--->

<cfset all_total = 0>
<cfset page_max_row = 10>
<cfset total_page = (round(get_puantaj_personal.recordCount/page_max_row) LT 1)?1:round(get_puantaj_personal.recordCount/page_max_row)>

<cf_box title="#title#" closable="0" uidrop="1">
    <div class="printThis">
        <style>
            .printableArea{
                display: block;
                position: relative;
                page-break-after: always;
                display: block;
                position: relative;
                width: 285mm;
                height: 200mm;
                padding:10mm 5mm 5mm 5mm;

            }    
        
            .printableArea * {
                font-family: Arial,Helvetica Neue,Helvetica,sans-serif; 
                -webkit-box-sizing: border-box;
                -moz-box-sizing: border-box;
                box-sizing: border-box;
                font-size: 11px;
            }
            .printableArea *:before,
            .printableArea *:after {
                -webkit-box-sizing: border-box;
                -moz-box-sizing: border-box;
                box-sizing: border-box;
            }
        
            <!--- SADECE DEVELOPER DA AÇ --->
                /* .printableArea div{border:1px solid red;}
                .printableArea{border: 1px solid #2196F3; } */
            <!--- SADECE DEVELOPER DA AÇ --->   
        
            .bold{font-weight: bold;}
            .underline{text-decoration:underline;}
            .left{text-align:left;}
            .center{text-align:center;}
            .right{text-align:right;}
            .no-border{border:0px;}
        
            table#tablo_ust_baslik {
                width: 100%;
                padding: 10px 200px;
                box-sizing: border-box;
                border-collapse: collapse;
                border: 0px;                
            }
        
            table#tablo_ust_baslik th {
            border: 1px solid black;
            padding: 3px;
            font-size:9px;
            }
            table#tablo_ust_baslik td {
                padding: 3px;
                font-size:9px;
            }
            table#tablo_alt_baslik {
                width: 40%;
                padding: 10px 200px;
                box-sizing: border-box;
                border-collapse: collapse;
                border: 0px;
                margin: 5px auto;
            }
        
            table#tablo_alt_baslik td {
            border: 1px solid black;
            padding: 2mm 1mm;
            }
        
            #bordrologo{
                width: 100px  !important;
                height: 50px  !important;
                display: block;
                margin-left: auto;
                margin-right: auto;
                width: 50%;
                -webkit-filter: grayscale(100%); /* Safari 6.0 - 9.0 */
                filter: grayscale(100%);
            }
            #paper_title{
                text-align: center;
                vertical-align: middle;
                line-height: 90px;
                font-size: 16pt;
            }
        
            table#tablo_ust_ekbilgi {
                min-width: 110mm;
                margin: 2mm 0mm;
            }
        
            @media print      {
                .printableArea{
                    page-break-after:always;
                }
            }
           
        
        </style>
        <cfloop index="i" from="1" to="#total_page#">    
            <cfset page_total = 0>
            <div class="printableArea" id="printBordro">
                <div id="logo">
                    <img src="https://ms.hmb.gov.tr/uploads/2018/12/logo.png" id="bordrologo"/>
                </div>
                <div id = "paper_title">
                    <cfoutput>#title#</cfoutput>
                </div>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <cfoutput>
                        <table style="width:100%">
                            <tr>
                                <th><cf_get_lang dictionary_id='64935.Muhasebe Birim Kodu'> - <cf_get_lang dictionary_id='57897.Adı'>     : #GET_PUANTAJ_PERSONAL.BRANCH_POSTCODE# - #GET_PUANTAJ_PERSONAL.related_company#</th>
                                <th><cf_get_lang dictionary_id='58455.Yıl'> : <cfoutput>#attributes.sal_year#</cfoutput></th>
                            </tr>
                            <tr>
                                <th><cf_get_lang dictionary_id='51485.Kurum Kodu'> - <cf_get_lang dictionary_id='57897.Adı'>: #GET_PUANTAJ_PERSONAL.BRANCH_ID# - #GET_PUANTAJ_PERSONAL.related_company#</th>
                                <th><cf_get_lang dictionary_id='58724.Ay'> : <cfoutput>#attributes.sal_mon#</cfoutput></th>
                            </tr>
                            <tr>
                                <th><cf_get_lang dictionary_id='64936.VKN No'> / <cf_get_lang dictionary_id='64937.VKN Adı'> :#GET_PUANTAJ_PERSONAL.BRANCH_TAX_NO# / #GET_PUANTAJ_PERSONAL.branch_fullname#</th>
                                <th><cf_get_lang dictionary_id='64941.Maaş Belge No'> :?</th>
                            </tr>
                            <tr>
                                <th></th>
                                <th><cf_get_lang dictionary_id='64953.'> :?</th>
                            </tr>
                        </table>
                    </cfoutput>
                    <table id="tablo_ust_baslik">
                        <tr>
                            <cfoutput>
                                <th nowrap="nowrap"><cf_get_lang dictionary_id='55657.Sıra No'></th>
                                <th nowrap="nowrap"><cf_get_lang dictionary_id='63668.Personel No'></th>
                                <th nowrap="nowrap"><cf_get_lang dictionary_id='55757.Adı Soyadı'></th>
                                <th nowrap="nowrap"><cf_get_lang dictionary_id='57847.Ödeme'> #left(getLang('','Derece','54179'),1)# / #left(getLang('','Kademe','58710'),1)#</th>
                                <th nowrap="nowrap"><cf_get_lang dictionary_id='58541.Emekli'> #left(getLang('','Derece','54179'),1)# / #left(getLang('','Kademe','58710'),1)#</th>
                                <th nowrap="nowrap"><cf_get_lang dictionary_id='65083.Ek Gösterge Ödes / Emes'></th>
                                <th nowrap="nowrap"><cf_get_lang dictionary_id='35263.Kıdem'></th>    
                                <th nowrap="nowrap"><cf_get_lang dictionary_id='65084.Özel Hizmet'></th>     
                                <th nowrap="nowrap"><cf_get_lang dictionary_id='65085.Makam Taz. Oranı'></th>     
                                <th nowrap="nowrap"><cf_get_lang dictionary_id='65086.İş Güçlüğü Puanı'></th>
                                <th nowrap="nowrap"><cf_get_lang dictionary_id='65087.El.Tem.Güç. Puanı'></th> 
                                <th nowrap="nowrap"><cf_get_lang dictionary_id='65088.İş Riski Puanı'></th>   
                                <th nowrap="nowrap"><cf_get_lang dictionary_id='65089.Mal .Sor. Taz. Puanı'></th>   
                                <th nowrap="nowrap"><cf_get_lang dictionary_id='63283.Görev Tazminatı'></th> 
                                <th nowrap="nowrap"><cf_get_lang dictionary_id='62884.Üniversite Ödeneği'></th>   
                                <th nowrap="nowrap"><cf_get_lang dictionary_id='65090.Ek Ödeme'></th> 
                                <th nowrap="nowrap"><cf_get_lang dictionary_id='65091.Kıst Gün'></th>          
                            </cfoutput>
                          
                        </tr>                        
                        <cfset row_num = 1>
                        <cfquery name="get_puantaj_personal_" dbtype="query">
                            SELECT * FROM get_puantaj_personal WHERE STATUE_TYPE  = 1 or STATUE_TYPE = 8
                        </cfquery>
                        <cfoutput query="get_puantaj_personal_"  startrow="#((i-1)*page_max_row)+1#" maxrows="#page_max_row#">
                            <cfquery name="get_in_out_history" datasource="#dsn#">
                                WITH T1 AS(
                                    SELECT
                                        OPR.GRADE,
                                        OPR.STEP,
                                        OPR.SEVERANCE_PENSION / #factor_old# bbb,
                                        OPR.ADDITIONAL_SCORE,
                                        PRIVATE_SERVICE_COMPENSATION,
                                        PRIVATE_SERVICE_COMPENSATION  / #factor_old / 9500 * 100#  AA,
                                        (#len(PRIVATE_SERVICE_COMPENSATION) ? PRIVATE_SERVICE_COMPENSATION / factor / 9500 * 100 : 0#) NEW_PRIVATE_SERVICE_COMPENSATION,
                                        BUSINESS_RISK,
                                        #len(SEVERANCE_PENSION) ? SEVERANCE_PENSION / factor : 0# NEW_SEVERANCE_PENSION,
                                        SAL_MON,
                                        SAL_YEAR,
                                        #len(BUSINESS_RISK) ? BUSINESS_RISK / get_factor.benefit_factor : 0# NEW_BUSINESS_RISK,
                                        #len(EXECUTIVE_INDICATOR_COMPENSATION) ? EXECUTIVE_INDICATOR_COMPENSATION / factor : 0# NEW_EXECUTIVE_INDICATOR_COMPENSATION,
                                        #len(ADMINISTRATIVE_COMPENSATION) ? ADMINISTRATIVE_COMPENSATION / factor : 0# NEW_ADMINISTRATIVE_COMPENSATION,
                                        #len(ADDITIONAL_INDICATOR_COMPENSATION) ? ADDITIONAL_INDICATOR_COMPENSATION / factor / 9500 * 100 : 0# NEW_ADDITIONAL_INDICATOR_COMPENSATION,
                                        #len(ADDITIONAL_INDICATORS) ? ADDITIONAL_INDICATORS / factor : 0# NEW_ADDITIONAL_INDICATORS,
                                        EP.RECORD_DATE,
                                        EPR.IN_OUT_ID
                                    FROM
                                        EMPLOYEES_PUANTAJ EP
                                        INNER JOIN EMPLOYEES_PUANTAJ_ROWS EPR ON EPR.PUANTAJ_ID = EP.PUANTAJ_ID
                                        INNER JOIN OFFICER_PAYROLL_ROW OPR ON OPR.PAYROLL_ID = EP.PUANTAJ_ID AND EPR.EMPLOYEE_PUANTAJ_ID = OPR.EMPLOYEE_PAYROLL_ID
                                WHERE
                                    EPR.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#in_out_id#">
                                    
                                    <cfif year(puantaj_start_) neq year(last_date)>
                                            AND SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#month(last_date)#">
                                            AND SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(last_date)#">
                                        <cfelse>
                                            AND SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#month(last_date)#">
                                            AND SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(puantaj_start_)#">
                                        </cfif>
                                    AND STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                                    AND 
                                    (
                                        ISNULL(OPR.GRADE,0) <> <cfqueryparam cfsqltype="cf_sql_integer" value="#len(GRADE) ? GRADE : 0#">
                                        OR 
                                        ISNULL(OPR.STEP,0) <> <cfqueryparam cfsqltype="cf_sql_integer" value="#len(STEP) ? STEP : 0#">
                                        OR 
                                        ISNULL(OPR.NORMAL_GRADE,0) <> <cfqueryparam cfsqltype="cf_sql_integer" value="#len(NORMAL_GRADE) ? NORMAL_GRADE : 0#">
                                        OR
                                        ISNULL(OPR.NORMAL_STEP,0) <> <cfqueryparam cfsqltype="cf_sql_integer" value="#len(NORMAL_STEP) ? NORMAL_STEP : 0#">
                                        OR
                                        STR(ISNULL(SEVERANCE_PENSION,0) / #factor_old#) <> <cfqueryparam cfsqltype="cf_sql_float" value="#len(SEVERANCE_PENSION) ? SEVERANCE_PENSION / factor : 0#">
                                        OR
                                        STR(ISNULL(PRIVATE_SERVICE_COMPENSATION,0)  / #factor_old#  / 9500 * 100) <> <cfqueryparam cfsqltype="cf_sql_float" value="#len(PRIVATE_SERVICE_COMPENSATION) ? PRIVATE_SERVICE_COMPENSATION / factor / 9500 * 100 : 0#">
                                        OR
                                        STR(ISNULL(BUSINESS_RISK,0) / #get_factor_old.benefit_factor#) <> <cfqueryparam cfsqltype="cf_sql_float" value="#len(BUSINESS_RISK) ? BUSINESS_RISK / get_factor.benefit_factor : 0#">
                                        OR
                                        STR(ISNULL(EXECUTIVE_INDICATOR_COMPENSATION,0) / #factor_old#) <> <cfqueryparam cfsqltype="cf_sql_float" value="#len(EXECUTIVE_INDICATOR_COMPENSATION) ? EXECUTIVE_INDICATOR_COMPENSATION / factor : 0#">
                                        OR
                                        STR(ISNULL(ADMINISTRATIVE_COMPENSATION,0) / #factor_old#) <> <cfqueryparam cfsqltype="cf_sql_float" value="#len(ADMINISTRATIVE_COMPENSATION) ? ADMINISTRATIVE_COMPENSATION / factor : 0#">
                                        OR
                                        STR(ISNULL(OPR.ADDITIONAL_INDICATOR_COMPENSATION,0) / #factor_old#  / 9500 * 100 ) <> <cfqueryparam cfsqltype="cf_sql_float" value="#len(ADDITIONAL_INDICATOR_COMPENSATION) ? ADDITIONAL_INDICATOR_COMPENSATION / factor / 9500 * 100 : 0#">
                                        OR
                                        STR(ISNULL(ADDITIONAL_INDICATORS,0) / #factor_old#) <> <cfqueryparam cfsqltype="cf_sql_float" value="#len(ADDITIONAL_INDICATORS) ? ADDITIONAL_INDICATORS / factor : 0#">
                                    )
                                ), T2 AS(
                                    SELECT 
                                    TOP 1
                                        EIO.ADDITIONAL_SCORE_NORMAL,
                                        EIO.SEVERANCE_PENSION_SCORE,
                                        EIO.PRIVATE_SERVICE_SCORE,
                                        EIO.EXECUTIVE_INDICATOR_SCORE,
                                        EIO.PERQUISITE_SCORE,
                                        EIO.BUSINESS_RISK_EMP,
                                        EIO.JUL_DIFFICULTIES,
                                        EIO.WORK_DIFFICULTY,
                                        EIO.ADMINISTRATIVE_INDICATOR_SCORE,
                                        EIO.UNIVERSITY_ALLOWANCE,
                                        EIO.ADDITIONAL_INDICATOR_COMPENSATION,
                                        EIO.FINANCIAL_RESPONSIBILITY,
                                        EIO.IN_OUT_ID
                                    FROM
                                        EMPLOYEES_IN_OUT_HISTORY EIO where 
                                        EIO.IN_OUT_ID = (SELECT TOP 1 IN_OUT_ID FROM T1) AND 
                                        EIO.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RECORD_DATE#">
                                    ORDER BY
                                        EIO.RECORD_DATE DESC
                                )  SELECT * from T1 LEFT JOIN T2 ON T2.IN_OUT_ID = T1.IN_OUT_ID
                            </cfquery>
                            <cfif get_in_out_history.recordCount gt 0>
                                <cfloop query="get_in_out_history">
                                    <tr>
                                        <td class="left" nowrap="nowrap">#row_num#</td>
                                        <td class="left">#get_puantaj_personal_.REGISTRY_NO#</td>
                                        <td class="left" nowrap="nowrap">#get_puantaj_personal_.EMPLOYEE_NAME# #get_puantaj_personal_.EMPLOYEE_SURNAME#</td>
                                        <td class="left" nowrap="nowrap">#get_puantaj_personal_.NORMAL_GRADE# - #get_puantaj_personal_.NORMAL_STEP#</td>
                                        <td class="left" nowrap="nowrap">#get_puantaj_personal_.GRADE# - #get_puantaj_personal_.STEP#</td>
                                        <td class="right" nowrap="nowrap">#tlFormat(get_puantaj_personal_.NORMAL_ADDITIONAL_SCORE)#</td>
                                        <td class="right" nowrap="nowrap">#tlFormat(SEVERANCE_PENSION_SCORE)#</td>
                                        <td class="right" nowrap="nowrap">#tlFormat(PRIVATE_SERVICE_SCORE)#</td>
                                        <td class="right" nowrap="nowrap">#tlFormat(EXECUTIVE_INDICATOR_SCORE)#</td>
                                        <td class="right" nowrap="nowrap">#tlFormat(WORK_DIFFICULTY)#</td>
                                        <td class="right" nowrap="nowrap">#tlFormat(JUL_DIFFICULTIES)#</td>
                                        <td class="right" nowrap="nowrap">#tlFormat(BUSINESS_RISK_EMP)#</td>
                                        <td class="right" nowrap="nowrap">#tlFormat(FINANCIAL_RESPONSIBILITY)#</td>
                                        <td class="right" nowrap="nowrap">#tlFormat(ADMINISTRATIVE_INDICATOR_SCORE)#</td>
                                        <td class="right" nowrap="nowrap">#tlFormat(UNIVERSITY_ALLOWANCE)#</td>
                                        <td class="right" nowrap="nowrap">#tlFormat(ADDITIONAL_INDICATOR_COMPENSATION)#</td>
                                        <td class="right" nowrap="nowrap">?</td>
                                    </tr>
                                    <cfset row_num ++>
                                </cfloop>
                            </cfif>
                        </cfoutput> 
                    </table>
                    <cfoutput>
                        <table id="tablo_alt_baslik">
                            <tr>
                                <td class="no-border">&nbsp;</td>
                                <td><cf_get_lang dictionary_id='64961.Gerçekleştirme Görevlisi'> (<cf_get_lang dictionary_id='64962.Maaş Mutemedi'>)</td>
                                <td><cf_get_lang dictionary_id='64961.Gerçekleştirme Görevlisi'></td>
                                <!--- <td><cf_get_lang dictionary_id='62976.Harcama Yetkilisi'></td>  --->   
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id='32370.Adı Soyadı'></td>
                                <td><cfif len(GET_PUANTAJ_PERSONAL.SALARY_SYNDIC_POS_ID)>#get_emp_info(GET_PUANTAJ_PERSONAL.SALARY_SYNDIC_POS_ID,1,0)#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                                <td><cfif len(GET_PUANTAJ_PERSONAL.FULFILLMENT_OFFICER_POS_ID)>#get_emp_info(GET_PUANTAJ_PERSONAL.FULFILLMENT_OFFICER_POS_ID,1,0)#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                                <!--- <td><cfif len(GET_PUANTAJ_PERSONAL.EXPENSE_USER_POS_ID)>#get_emp_info(GET_PUANTAJ_PERSONAL.EXPENSE_USER_POS_ID,1,0)#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td> --->
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id='57571.Ünvan'></td>
                                <td><cfif len(GET_PUANTAJ_PERSONAL.SALARY_SYNDIC_POS_ID)>#get_title_cmp.get_position_title(position_id: GET_PUANTAJ_PERSONAL.SALARY_SYNDIC_POS_ID).TITLE#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                                <td><cfif len(GET_PUANTAJ_PERSONAL.FULFILLMENT_OFFICER_POS_ID)>#get_title_cmp.get_position_title(position_id: GET_PUANTAJ_PERSONAL.FULFILLMENT_OFFICER_POS_ID).TITLE#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                                <!--- <td><cfif len(GET_PUANTAJ_PERSONAL.EXPENSE_USER_POS_ID)>#get_title_cmp.get_position_title(position_id: GET_PUANTAJ_PERSONAL.EXPENSE_USER_POS_ID).TITLE#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td> --->
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id='64960.Sistem Onay Tarih / Saati'></td>
                                <td>#dateFormat(now(),dateformat_style)# #timeFormat(now(),timeformat_style)#</td>
                                <td>#dateFormat(now(),dateformat_style)# #timeFormat(now(),timeformat_style)#</td>
                                <!--- <td>#dateFormat(now(),dateformat_style)# #timeFormat(now(),timeformat_style)#</td> --->
                            </tr>
                        </table>
                    </cfoutput>
                </div>
                <div style="position: absolute;bottom: 8mm;right: 8mm;"><cfoutput>#i#/#total_page#</cfoutput></div>
            </div>        
        </cfloop>
    </div> 
</cf_box>
