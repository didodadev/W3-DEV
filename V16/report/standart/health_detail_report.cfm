<cfsetting showdebugoutput="no">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.group_paper_no" default="">
<cfparam name="attributes.expense_stage" default="">
<cfparam name="attributes.assurance_id" default="">
<cfparam name="attributes.is_relative" default="">
<cfparam name="attributes.is_invoice" default="">
<cfparam name="attributes.search_date1" default="">
<cfparam name="attributes.search_date2" default="">
<cfif len(attributes.search_date1) and isdate(attributes.search_date1)>
    <cf_date tarih = "attributes.search_date1">
</cfif>
<cfif len(attributes.search_date2) and isdate(attributes.search_date2)>
    <cf_date tarih = "attributes.search_date2">
</cfif>
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset get_x_rnd_nmbr = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'hr.health_expense_approve',
    property_name : 'x_rnd_nmbr'
)>
<cfif get_x_rnd_nmbr.recordcount>
	<cfset x_rnd_nmbr = get_x_rnd_nmbr.property_value>
<cfelse>
	<cfset x_rnd_nmbr = 2>
</cfif>
<cfset HealthExpense = createObject("component","V16.myhome.cfc.health_expense") />
<cfset get_process_type = HealthExpense.GetProcessType(fuseaction : 'hr.health_expense_approve')>
<cfset get_assurance = HealthExpense.GetAssurance()>
<cfif isdefined('attributes.is_form_submit')>
    <cfquery name="get_data" datasource="#dsn2#">
        SELECT
            E.PAPER_TYPE PAPER_TYPE,
            SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME,
            E.EMP_ID,
            E.MONEY,
            E.DETAIL,
            E.PAYMENT_INTERRUPTION_VALUE,
            EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME AS EMP_FULLNAME,
            E.ASSURANCE_ID,
            E.TREATMENT_ID,
            E.TREATED TREATED,
            E.TOTAL_AMOUNT,
            ISNULL(E.NET_TOTAL_AMOUNT,0) AS AMOUNT,
            ISNULL(E.TREATMENT_AMOUNT,0) AS TREATMENT_AMOUNT,
            ISNULL(E.OUR_COMPANY_HEALTH_AMOUNT,0) AS OUR_COMPANY_HEALTH_AMOUNT,
            ISNULL(E.EMPLOYEE_HEALTH_AMOUNT,0) AS EMPLOYEE_HEALTH_AMOUNT,
            T.TREATMENT TREATMENT,
            H.ASSURANCE ASSURANCE,
            E.EXPENSE_DATE EXP_DATE,
            E.RECORD_DATE RECORD_DATE,
            E.UPDATE_DATE UPDATE_DATE,
            E.EXPENSE_DATE,
            E.PAYMENT_DATE,
            E.EXPENSE_ID EXPENSE,
            E.PAPER_NO,
            E.DEPARTMENT_ID,
            E.BRANCH_ID,
            BRANCH.BRANCH_NAME BRANCH_NAME,
            DEPARTMENT.DEPARTMENT_HEAD DEPARTMENT_HEAD,
            E.RECORD_EMP RECORD_EMP,
            E.EXPENSE_STAGE,
            ER.NAME + ' ' + ER.SURNAME AS FULLNAME,
            E.RELATIVE_ID,
            E.EXPENSE_ITEM_PLANS_ID,
            ER.RELATIVE_LEVEL,
            E.COMPANY_AMOUNT_RATE,
            E.COMPANY_ID,
            E.CONSUMER_ID,
            E.COMPANY_NAME,
            E.INVOICE_NO,
            C.FULLNAME AS COMPANY_FULLNAME,
            E.PROCESS_CAT,
            (
                SELECT
                    TOP 1
                    GENERAL_PAPER.GENERAL_PAPER_NO 
                FROM
                    #dsn#.GENERAL_PAPER
                    LEFT JOIN #dsn#.PAGE_WARNINGS ON PAGE_WARNINGS.GENERAL_PAPER_ID = GENERAL_PAPER.GENERAL_PAPER_ID
                WHERE
                    E.EXPENSE_ID IN (SELECT * FROM #dsn#.fnSplit((GENERAL_PAPER.ACTION_LIST_ID), ','))
                    AND STAGE_ID = E.EXPENSE_STAGE
                    <cfif len(attributes.group_paper_no)>
                        AND GENERAL_PAPER.GENERAL_PAPER_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.group_paper_no#">
                    </cfif>
                    AND PAGE_WARNINGS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                    AND PAGE_WARNINGS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                ORDER BY
                    GENERAL_PAPER.GENERAL_PAPER_ID DESC
            ) AS GENERAL_PAPER_NO,
            E.ASSURANCE_TYPE_ID,
            E.SYSTEM_RELATION
        FROM
            EXPENSE_ITEM_PLAN_REQUESTS E
            LEFT JOIN #dsn#.SETUP_DOCUMENT_TYPE ON SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID = E.PAPER_TYPE
            LEFT JOIN #dsn#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = E.EMP_ID
            LEFT JOIN #dsn#.SETUP_HEALTH_ASSURANCE_TYPE H ON H.ASSURANCE_ID = E.ASSURANCE_ID
            LEFT JOIN #dsn#.SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS T ON T.TREATMENT_ID = E.TREATMENT_ID
            LEFT JOIN #dsn#.DEPARTMENT ON DEPARTMENT.DEPARTMENT_ID = E.DEPARTMENT_ID
            LEFT JOIN #dsn#.BRANCH ON BRANCH.BRANCH_ID = E.BRANCH_ID
            LEFT JOIN #dsn#.PROCESS_TYPE_ROWS PTR on PTR.PROCESS_ROW_ID=E.EXPENSE_STAGE
            LEFT JOIN #dsn#.EMPLOYEES_RELATIVES  ER on ER.RELATIVE_ID = E.RELATIVE_ID
            LEFT JOIN #dsn#.COMPANY C ON C.COMPANY_ID = E.COMPANY_ID
        WHERE
            1=1
            AND E.TREATED IS NOT NULL
            <cfif len(attributes.expense_stage)>
                AND E.EXPENSE_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_stage#">
            </cfif>
            <cfif len(attributes.assurance_id)>
                AND E.ASSURANCE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assurance_id#" list="true">)
            </cfif>
            <cfif len(attributes.is_relative)>
                AND E.TREATED = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_relative#">
            </cfif>
            <cfif len(attributes.is_invoice) and attributes.is_invoice eq 1>
                AND E.INVOICE_NO IS NOT NULL
            <cfelseif len(attributes.is_invoice) and attributes.is_invoice eq 2>
                AND E.INVOICE_NO IS NULL
            </cfif>
            <cfif len(attributes.group_paper_no)>
                AND E.EXPENSE_ID IN (SELECT * FROM #dsn#.fnSplit((SELECT TOP 1 ACTION_LIST_ID FROM #dsn#.GENERAL_PAPER WHERE GENERAL_PAPER_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.group_paper_no#"> ORDER BY GENERAL_PAPER_ID DESC), ','))
            </cfif>
            <cfif len(attributes.search_date1)>
                AND E.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.search_date1#">
            </cfif>
            <cfif len(attributes.search_date2)>
                AND E.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.search_date2#">
            </cfif>
    </cfquery>
<cfelse>
	<cfset get_data.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_data.recordcount#">
<cfsavecontent variable="head"><cf_get_lang dictionary_id='61010.Sağlık Detay Raporu'></cfsavecontent>
<cfform name="search_form" method="post" action="#request.self#?fuseaction=report.health_detail_report">
    <cf_report_list_search title="#head#">
        <cf_report_list_search_area>
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="col col-3 col-md-6 col-xs-12">
                            <div class="form-group" id="item-general_paper">
                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60286.Toplu Belge No'></label>
                                <div class="col col-12 col-xs-12">  
                                    <input type="text" name="group_paper_no" id="group_paper_no" placeholder="<cf_get_lang dictionary_id='60286.Toplu Belge No'>" value="<cfoutput>#attributes.group_paper_no#</cfoutput>" />
                                </div>
                            </div>
                            <div class="form-group" id="item-process_stage">
                                <label class="col col-12"><cf_get_lang dictionary_id="57482.Aşama"></label>
                                <div class="col col-12">
                                    <select name="expense_stage" id="expense_stage">
                                        <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                        <cfoutput query="get_process_type">
                                            <option value="#process_row_id#" <cfif attributes.expense_stage eq get_process_type.process_row_id>selected</cfif>>#stage#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-6 col-xs-12">
                            <div class="form-group" id="item-assurance">
                                <label class="col col-12"><cf_get_lang dictionary_id="58689.Teminat"><cf_get_lang dictionary_id="216.Tipi"></label>
                                <div class="col col-12">
                                    <cf_multiselect_check
                                        name="assurance_id"
                                        option_name="ASSURANCE"
                                        option_value="assurance_id"
                                        width="130"
                                        value="#attributes.assurance_id#"
                                        query_name="get_assurance">
                                </div>
                            </div>
                            <div class="form-group" id="item-search_date">
                                <label class="col col-12"><cf_get_lang dictionary_id="33203.Belge Tarihi"></label>
                                <div class="col col-6">
                                    <div class="input-group">
                                        <cfsavecontent variable="txt1"><cf_get_lang dictionary_id="57782.Tarih Değerini Kontrol Ediniz">!</cfsavecontent>
                                        <cfinput type="text" name="search_date1" value="#dateformat(attributes.search_date1, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#txt1#">
                                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="search_date1"></span>
                                        <span class="input-group-addon no-bg"></span>
                                    </div>
                                </div>
                                <div class="col col-6">
                                    <div class="input-group">
                                        <cfinput type="text" name="search_date2" value="#dateformat(attributes.search_date2, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#txt1#">
                                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="search_date2"></span> 
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-6 col-xs-12">
                            <div class="form-group" id="item-is_relative">
                                <label class="col col-12"><cf_get_lang dictionary_id="34712.Tedavi Gören"></label>
                                <div class="col col-12">
                                    <select name="is_relative" id="is_relative">
                                        <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                        <option value="1" <cfif attributes.is_relative eq 1>selected</cfif>><cf_get_lang dictionary_id="40429.kendisi"></option>
                                        <option value="2" <cfif attributes.is_relative eq 2>selected</cfif>><cf_get_lang dictionary_id="40117.yakını"></option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-6 col-xs-12">
                            <div class="form-group" id="item-is_invoice">
                                <label class="col col-12"><cf_get_lang dictionary_id="59585.Anlaşmalı kurum"></label>
                                <div class="col col-12">
                                    <select name="is_invoice" id="is_invoice" style="width:200px;">
                                        <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                        <option value="1" <cfif attributes.is_invoice eq 1>selected</cfif>><cf_get_lang dictionary_id="57495.Evet"></option>
                                        <option value="2" <cfif attributes.is_invoice eq 2>selected</cfif>><cf_get_lang dictionary_id="57496.Hayır"></option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                            <cfelse>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
                            </cfif>
                            <input type="hidden" name="is_form_submit" id="is_form_submit" value="1">
                            <cf_wrk_report_search_button button_type='1' is_excel='1' search_function="control()">
                        </div>
                    </div>
                </div>
            </div>
        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset type_ = 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">
<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.is_form_submit")>
    <cf_report_list>
        <cfif attributes.is_excel eq 1>
            <cfset type_ = 1>
            <cfset attributes.startrow = 1>
            <cfset attributes.maxrows = get_data.recordcount>
        <cfelse>
            <cfset type_ = 0>
        </cfif>
        <thead>
            <tr>
                <th width="50"><cf_get_lang dictionary_id="58577.Sıra"></th>
                <th width="50"><cf_get_lang dictionary_id='57880.Belge No'></th>
                <th width="50"><cf_get_lang dictionary_id='60286.Toplu Belge No'></th>
                <th><cf_get_lang dictionary_id="30152.Tip"></th>
                <th><cf_get_lang dictionary_id="57576.Çalışan"></th>
                <th><cf_get_lang dictionary_id="34712.tedavi gören"></th>
                <th><cf_get_lang dictionary_id="46665.Hasta"></th>
                <th><cf_get_lang dictionary_id='57453.Şube'> - <cf_get_lang dictionary_id='57572.Departman'></th>
                <th><cf_get_lang dictionary_id="59977.Sağlık Kurumu"></th>
                <th><cf_get_lang dictionary_id="36199.Açıklama"></th>
                <th><cf_get_lang dictionary_id="58689.Teminat"><cf_get_lang dictionary_id="216.Tipi"></th>
                <th><cf_get_lang dictionary_id="56623.Tedavi"><cf_get_lang dictionary_id="58651.Türü"></th>
                <th><cf_get_lang dictionary_id="33203.Belge Tarihi"></th>
                <th><cf_get_lang dictionary_id="58851.Ödeme Tarihi"></th>
                <th><cf_get_lang dictionary_id="58794.Referans No"></th>
                <th><cf_get_lang dictionary_id="48323.Fatura Tutarı"></th>
                <th><cf_get_lang dictionary_id="59887.Tedaviye Esas Tutar"></th>
                <th><cf_get_lang dictionary_id="61027.Ödeme Oranı"></th>
                <th><cf_get_lang dictionary_id="41154.Kurum Payı"></th>
                <th><cf_get_lang dictionary_id="41148.Çalışan Payı"></th>
                <th><cf_get_lang dictionary_id="32191.Kesinti"></th>
                <th><cf_get_lang dictionary_id="57482.Aşama"></th>

            <tr>
        </thead>
        <tbody>
            <cfif get_data.recordcount>
                <cfset expense_stage_list = ''>
                <cfoutput query="get_data">
                    <cfif len(expense_stage) and not listfind(expense_stage_list,expense_stage)>
                        <cfset expense_stage_list=listappend(expense_stage_list,expense_stage)>
                    </cfif>
                </cfoutput>
                <cfif len(expense_stage_list)>
                    <cfquery name="get_stage" datasource="#dsn#">
                        SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#expense_stage_list#)
                    </cfquery> 
                    <cfset expense_stage_list = listsort(listdeleteduplicates(valuelist(get_stage.process_row_id,',')),'numeric','ASC',',')>
                </cfif>
                <cfoutput query="get_data" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <cfset relative_name = '' />
                        <td>#currentRow#</td>
                        <td>#paper_no#</td>
                        <td>#general_paper_no#</td>
                        <td>
                            <cfif len(INVOICE_NO)>
                                <cf_get_lang dictionary_id="59585.Anlaşmalı Kurum">
                            <cfelse>
                                <cf_get_lang dictionary_id="61028.Personel Harcaması">
                            </cfif>
                        </td>
                        <td>#EMP_FULLNAME#</td>
                        <cfif Len(RELATIVE_ID) and len(RELATIVE_LEVEL)>
                            <cfswitch expression="#RELATIVE_LEVEL#">
                                <cfcase value="1">
                                    <cfset relative_name = 'Babası' />
                                </cfcase>
                                <cfcase value="2">
                                    <cfset relative_name = 'Annesi' />
                                </cfcase>
                                <cfcase value="3">
                                    <cfset relative_name = 'Eşi' />
                                </cfcase>
                                <cfcase value="4">
                                    <cfset relative_name = 'Oğlu' />
                                </cfcase>
                                <cfcase value="5">
                                    <cfset relative_name = 'Kızı' />
                                </cfcase>
                                <cfcase value="6">
                                    <cfset relative_name = 'Kardeşi' />
                                </cfcase>
                            </cfswitch>
                            <td>#relative_name#</td>
                        <cfelse>
                            <td><cf_get_lang dictionary_id="40429.kendisi"></td>
                        </cfif>
                        <td>
                            <cfif TREATED eq 2 and len(RELATIVE_ID) and len(RELATIVE_LEVEL)>
                                #FULLNAME#
                            <cfelse>
                                #EMP_FULLNAME#
                            </cfif>
                        </td>
                        <td>#BRANCH_NAME# - #DEPARTMENT_HEAD#</td>
                        <td>
                            <cfif len(company_id) or len(consumer_id)>
                                <cfif len(company_id)>
                                    #COMPANY_FULLNAME#
                                <cfelseif len(consumer_id)>
                                    #get_cons_info(consumer_id,2,0)#>
                                </cfif>
                            <cfelse>
                                <cfif len(COMPANY_NAME)>
                                    #COMPANY_NAME#
                                </cfif>
                            </cfif>
                        </td>
                        <td>#DETAIL#</td>
                        <td>#ASSURANCE#<cfif assurance_type_id eq 1> - <cf_get_lang dictionary_id = "41536.Kamu"><cfelseif assurance_type_id eq 2> - <cf_get_lang dictionary_id = "57979.Özel"></cfif></td>
                        <td>#TREATMENT#</td>
                        <td>#dateFormat(EXP_DATE,dateformat_style)#</td>
                        <td>
                            <cfif len(PAYMENT_DATE)>
                                #dateFormat(PAYMENT_DATE,dateformat_style)#
                            </cfif>
                        </td>
                        <td><cfif len(SYSTEM_RELATION)>#SYSTEM_RELATION#<cfelse>#INVOICE_NO#</cfif></td>
                        <td style="text-align:right;">#TLFormat(AMOUNT,x_rnd_nmbr)#</td>
                        <td style="text-align:right;">#TLFormat(TREATMENT_AMOUNT,x_rnd_nmbr)#</td>
                        <td style="text-align:right;">#TLFormat(COMPANY_AMOUNT_RATE,x_rnd_nmbr)#</td>
                        <td style="text-align:right;">#TLFormat(OUR_COMPANY_HEALTH_AMOUNT,x_rnd_nmbr)#</td>
                        <td style="text-align:right;">#TLFormat(EMPLOYEE_HEALTH_AMOUNT,x_rnd_nmbr)#</td>
                        <td style="text-align:right;">#TLFormat(PAYMENT_INTERRUPTION_VALUE,x_rnd_nmbr)#</td>
                        <td>
                            <cfif len(expense_stage)>
                                <cf_workcube_process type="color-status" process_stage="#expense_stage#" fuseaction="hr.health_expense_approve">
                            </cfif>
                        </td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="17"><cf_get_lang dictionary_id='57484.kayıt yok'>!</td>
                </tr>
            </cfif>
        </tbody>
    </cf_report_list>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "report.health_detail_report">
	<cfif isdefined('attributes.is_form_submit')>
		<cfset url_str = '#url_str#&is_form_submit=1'>
    </cfif>
    <cfif len(attributes.group_paper_no)>
		<cfset url_str = "#url_str#&group_paper_no=#attributes.group_paper_no#">
    </cfif>
    <cfif len(attributes.expense_stage)>
		<cfset url_str = "#url_str#&expense_stage=#attributes.expense_stage#">
    </cfif>
    <cfif len(attributes.assurance_id)>
        <cfset url_str = "#url_str#&assurance_id=#attributes.assurance_id#">
    </cfif>
    <cfif len(attributes.is_relative)>
        <cfset url_str = "#url_str#&is_relative=#attributes.is_relative#">
    </cfif>
    <cfif len(attributes.is_invoice)>
        <cfset url_str = "#url_str#&is_invoice=#attributes.is_invoice#">
    </cfif>
    <cfif len(attributes.search_date1)>
        <cfset url_str = "#url_str#&search_date1=#dateformat(attributes.search_date1,dateformat_style)#">
    </cfif>
    <cfif len(attributes.search_date2)>
        <cfset url_str = "#url_str#&search_date2=#dateformat(attributes.search_date2,dateformat_style)#">
    </cfif>
    <cf_paging
        page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="#url_str#">
</cfif>
<script type="text/javascript">
    function control(){
        if(document.getElementById('search_date1').value != '' && document.getElementById('search_date2').value != ''){
            if(!date_check (document.getElementById('search_date1'),document.getElementById('search_date2'),"<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Önce Olamaz'>!")){
                document.getElementById('search_date1').focus();
                return false;
            }
        }
        if(document.search_form.is_excel.checked==false){
            document.search_form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
            return true;
        }
        else
            document.search_form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_health_detail_report</cfoutput>";
    }
</script>