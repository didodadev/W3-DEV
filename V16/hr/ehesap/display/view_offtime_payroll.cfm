<!---
    File: V16\hr\ehesap\display\view_offtime_payroll.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2022-01-14
    Description: Sağlık Raporu Kesintisi Bulunanların Listesi
    History:
    To Do:

--->
<cfset title = "#UCase(getLang('','Sağlık Raporu Kesintisi Bulunanların Listesi','65044'))#">
<cfset comment_id = x_interruption_health_report_id>
<cfset get_title_cmp = createObject("component","V16.hr.cfc.get_titles")>

<cfquery name="get_emp_offtimes" datasource="#dsn#">
	SELECT
		SUM(DATEDIFF(D,OFFTIME.STARTDATE,OFFTIME.FINISHDATE))+1 AS TOTAL_DAY,
        OFFTIMECAT_ID,
        EMPLOYEE_ID
	FROM
		OFFTIME
	WHERE
		OFFTIME.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#valuelist(get_puantaj_personal.EMPLOYEE_ID)#" list="yes">) AND
		(
			(
			(OFFTIME.SUB_OFFTIMECAT_ID = 0 OR OFFTIME.SUB_OFFTIMECAT_ID IS NULL) AND
			OFFTIME.OFFTIMECAT_ID = #x_interruption_health_report_id#
			)
		) AND
		OFFTIME.VALID = 1 AND
		(OFFTIME.IS_PUANTAJ_OFF = 0 OR OFFTIME.IS_PUANTAJ_OFF IS NULL) AND
		STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('h',-session.ep.time_zone,puantaj_finish_)#"> AND
		FINISHDATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('h',-session.ep.time_zone,puantaj_start_)#"> 
    GROUP BY
        OFFTIMECAT_ID,
        EMPLOYEE_ID
</cfquery>

<cfif get_emp_offtimes.recordCount eq 0>
    <cf_box title="Bordro"><cf_get_lang dictionary_id="57484.Kayıt Yok">!</cf_box>
    <cfabort>
</cfif>

<cfset page_max_row = 10>
<cfset total_page = (round(get_emp_offtimes.recordCount/page_max_row) LT 1)?1:round(get_emp_offtimes.recordCount/page_max_row)>

<cf_box title="#title#" closable="0" uidrop="1">
    <div class="printThis">
        <style>
            .printableArea{
                display: block;
                position: relative;
                page-break-after: always;
                width: 208mm;
                height: 295mm;
                display: block;
                position: relative;
                margin: 0 auto;
                padding:10mm 5px 5px 5px;
            }    
        
            .printableArea * {
                font-family: Arial,Helvetica Neue,Helvetica,sans-serif; 
                -webkit-box-sizing: border-box;
                -moz-box-sizing: border-box;
                box-sizing: border-box;
                font-size: 12px;
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
            padding: 3mm;
            }
            table#tablo_alt_baslik {
                width: 100%;
                padding: 10px 200px;
                box-sizing: border-box;
                border-collapse: collapse;
                border: 0px;
                margin-top:3mm;
            }
        
            tr#tablo_alt_baslik td {
            border: 1px solid black;
            padding: 3mm;
            }

            table#tablo_td td {
                padding: 3mm;
            }
            table#tablo_ust_baslik td {
                padding: 3mm;
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
                            <th nowrap="nowrap"><cf_get_lang dictionary_id='55657.Sıra No'></th>
                            <th nowrap="nowrap"><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
                            <th nowrap="nowrap"><cf_get_lang dictionary_id='63668.Personel No'></th>
                            <th colspan="2"><cf_get_lang dictionary_id='57897.Adı'></th>
                            <th><cf_get_lang dictionary_id='58550.Soyadı'></th>
                            <th nowrap="nowrap" colspan="2"><cf_get_lang dictionary_id='57571.Ünvan'></th>  
                            <th><cf_get_lang dictionary_id='57434.Rapor'></th> 
                        </tr>
                        <cfoutput query="get_emp_offtimes"  startrow="#((i-1)*page_max_row)+1#" maxrows="#page_max_row#">     
                            <cfquery name="get_interruption_emp" dbtype="query">
                                SELECT
                                    *
                                FROM 
                                    get_puantaj_personal 
                                WHERE 
                                    EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EMPLOYEE_ID#">
                            </cfquery>
                            <tr>
                                <td class="left" nowrap="nowrap">#currentrow#</td>
                                <td class="left">#get_interruption_emp.TC_IDENTY_NO#</td>
                                <td class="left">#get_interruption_emp.REGISTRY_NO#</td>
                                <td class="left" nowrap="nowrap" colspan="2">#get_interruption_emp.EMPLOYEE_NAME#</td>
                                <td class="left" nowrap="nowrap">#get_interruption_emp.EMPLOYEE_SURNAME#</td>
                                <td class="left" nowrap="nowrap" colspan="2">#get_interruption_emp.TITLE#</td>
                                <td class="right">#TOTAL_DAY#</td>
                            </tr>
                        </cfoutput>
                    </table>
                    <cfoutput>
                        <table id="tablo_alt_baslik">
                            <tr>
                                <td class="no-border">&nbsp;</td>
                                <td><cf_get_lang dictionary_id='64961.Gerçekleştirme Görevlisi'> (<cf_get_lang dictionary_id='64962.Maaş Mutemedi'>)</td>
                                <td><cf_get_lang dictionary_id='64961.Gerçekleştirme Görevlisi'></td>
                                <!--- <td><cf_get_lang dictionary_id='62976.Harcama Yetkilisi'></td>     --->
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
