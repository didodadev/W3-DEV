<cfsetting showdebugoutput="no">
<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.is_difference" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.process_cat_id" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.he_start_date" default="">
<cfparam name="attributes.he_finish_date" default="">
<cfparam name="attributes.invoice_start_date" default="">
<cfparam name="attributes.invoice_finish_date" default="">
<cfif len(attributes.he_start_date) and isdate(attributes.he_start_date) >
	<cf_date tarih="attributes.he_start_date">
</cfif>
<cfif len(attributes.he_finish_date) and isdate(attributes.he_finish_date)>
	<cf_date tarih="attributes.he_finish_date">
</cfif>
<cfif len(attributes.invoice_start_date) and isdate(attributes.invoice_start_date) >
	<cf_date tarih="attributes.invoice_start_date">
</cfif>
<cfif len(attributes.invoice_finish_date) and isdate(attributes.invoice_finish_date)>
	<cf_date tarih="attributes.invoice_finish_date">
</cfif>
<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
    SELECT 
        PROCESS_TYPE,
        PROCESS_CAT,
        PROCESS_CAT_ID
    FROM 
        SETUP_PROCESS_CAT
    WHERE 
        PROCESS_TYPE = 1201
    ORDER BY
        PROCESS_CAT
</cfquery>
<cfquery name="get_process_type" datasource="#dsn#">
    SELECT
        PTR.STAGE,
        PTR.PROCESS_ROW_ID
    FROM
        PROCESS_TYPE_ROWS PTR,
        PROCESS_TYPE_OUR_COMPANY PTO,
        PROCESS_TYPE PT
    WHERE
        PT.IS_ACTIVE = 1 AND
        PTR.PROCESS_ID = PT.PROCESS_ID AND
        PT.PROCESS_ID = PTO.PROCESS_ID AND
        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.health_expense_approve%">
    ORDER BY
        PTR.LINE_NUMBER
</cfquery>
<cfif isdefined('attributes.is_form_submit')>
    <cfquery name="get_data" datasource="#dsn2#">
        SELECT 
            ERD.RECEIVING_DETAIL_ID,
            ERD.EINVOICE_ID,
            ERD.PAYABLE_AMOUNT, 
            ERD.PAYABLE_AMOUNT_CURRENCY,
            EIP.ACTION_TYPE,
            EIPR.EXPENSE_STAGE,
            EIP.TOTAL_AMOUNT_KDVLI,
            EIPR.NET_TOTAL_AMOUNT,
            EIPR.PAPER_NO,
            EIPR.EXPENSE_ID,
            EIP.CH_COMPANY_ID,
			EIP.CH_CONSUMER_ID,
			EIP.CH_EMPLOYEE_ID,
            EIP.PROCESS_CAT,
            CMP.FULLNAME,
            CNS.CONSUMER_NAME,
            CNS.CONSUMER_SURNAME,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            EIP.EXPENSE_DATE AS EIP_EXPENSE_DATE,
            EIPR.EXPENSE_DATE AS EIPR_EXPENSE_DATE
        FROM 
            EINVOICE_RECEIVING_DETAIL ERD
            LEFT JOIN EXPENSE_ITEM_PLANS EIP ON ERD.EXPENSE_ID = EIP.EXPENSE_ID
            LEFT JOIN EXPENSE_ITEM_PLAN_REQUESTS EIPR ON EIPR.EXPENSE_ITEM_PLANS_ID = EIP.EXPENSE_ID AND EIPR.EMP_ID = EIP.EMP_ID AND (EIPR.COMPANY_ID = EIP.CH_COMPANY_ID OR EIPR.COMPANY_ID = EIP.CH_CONSUMER_ID OR EIPR.COMPANY_ID = EIP.CH_EMPLOYEE_ID)
            LEFT JOIN #dsn_alias#.COMPANY CMP ON CMP.COMPANY_ID = EIP.CH_COMPANY_ID
            LEFT JOIN #dsn_alias#.CONSUMER CNS ON CNS.CONSUMER_ID = EIP.CH_CONSUMER_ID
            LEFT JOIN #dsn_alias#.EMPLOYEES E ON E.EMPLOYEE_ID = EIP.CH_EMPLOYEE_ID
        WHERE
            EIP.ACTION_TYPE = 1201
            <cfif len(attributes.he_start_date)>
                AND	EIPR.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.he_start_date#">
            </cfif>
            <cfif len(attributes.he_finish_date)>
                AND	EIPR.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.he_finish_date#">
            </cfif>
            <cfif len(attributes.invoice_start_date)>
                AND	EIP.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.invoice_start_date#">
            </cfif>
            <cfif len(attributes.invoice_finish_date)>
                AND	EIP.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.invoice_finish_date#">
            </cfif>
            <cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0 and attributes.member_type is 'partner'>
                AND EIP.CH_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
            </cfif>
            <cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0 and attributes.member_type is 'consumer'>
                AND EIP.CH_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
            </cfif>
            <cfif len(attributes.company) and len(attributes.employee_id) and attributes.employee_id neq 0 and attributes.member_type is 'employee'>
                AND EIP.CH_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.employee_id,'_')#">
            </cfif>
            <cfif len(attributes.is_difference) and attributes.is_difference eq 1>
                AND (ERD.PAYABLE_AMOUNT <> EIP.TOTAL_AMOUNT_KDVLI OR ERD.PAYABLE_AMOUNT <> EIPR.NET_TOTAL_AMOUNT OR EIP.TOTAL_AMOUNT_KDVLI <> EIPR.NET_TOTAL_AMOUNT)
            <cfelseif len(attributes.is_difference) and attributes.is_difference eq 2>
                AND (ERD.PAYABLE_AMOUNT = EIP.TOTAL_AMOUNT_KDVLI AND ERD.PAYABLE_AMOUNT = EIPR.NET_TOTAL_AMOUNT AND EIP.TOTAL_AMOUNT_KDVLI = EIPR.NET_TOTAL_AMOUNT)
            </cfif>
            <cfif len(attributes.process_stage)>
                AND EIPR.EXPENSE_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#" list="true">)
            </cfif>
            <cfif len(attributes.process_cat_id)>
                AND EIP.PROCESS_CAT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat_id#" list="true">)
            </cfif>
    </cfquery>
<cfelse>
	<cfset get_data.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_data.recordcount#">
<cfsavecontent variable="head"><cf_get_lang dictionary_id='60814.Sağlık Faturaları Kontrol Raporu'></cfsavecontent>
<cfform name="search_form" method="post" action="#request.self#?fuseaction=report.health_expenses_report">
    <cf_report_list_search title="#head#">
        <cf_report_list_search_area>
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="col col-4 col-md-6 col-xs-12">
                            <div class="form-group">
                                <label class="col col-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                                <div class="col col-12">
                                    <cf_multiselect_check
                                        name="process_stage"
                                        option_name="STAGE"
                                        option_value="PROCESS_ROW_ID"
                                        width="130"
                                        value="#attributes.process_stage#"
                                        query_name="get_process_type">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-12"><cf_get_lang dictionary_id="57124.İşlem Kategorisi"></label>
                                <div class="col col-12">
                                    <cf_multiselect_check
                                        name="process_cat_id"
                                        option_name="PROCESS_CAT"
                                        option_value="PROCESS_CAT_ID"
                                        width="130"
                                        value="#attributes.process_cat_id#"
                                        query_name="GET_PROCESS_CAT">
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-6 col-xs-12">
                            <div class="form-group" id="form_ul_company">
                                <label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                        <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                                        <input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                        <input type="hidden" name="employee_id" id="employee_id" value="<cfif len(attributes.company)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                                        <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type") and len(attributes.member_type)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                                        <input name="company" type="text" id="company" style="width:100px;" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif fusebox.circuit is 'store'>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','search_form','3','250');" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_comp_name=search_form.company&field_comp_id=search_form.company_id&field_consumer=search_form.consumer_id&field_member_name=search_form.company&field_emp_id=search_form.employee_id&field_name=search_form.company&field_type=search_form.member_type<cfif fusebox.circuit is 'store'>&is_store_module=1</cfif>&select_list=2,3,1,9</cfoutput>&keyword='+encodeURIComponent(document.search_form.company.value),'list')"></span>
                                     </div>
                                 </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="60820.Fark Olanlar"></label>
                                <div class="col col-12 col-xs-12">
                                    <select name="is_difference" id="is_difference">
                                        <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                        <option value="1" <cfif attributes.is_difference eq 1>selected</cfif>><cf_get_lang dictionary_id="60821.Fark Olanlar"></option>
                                        <option value="2" <cfif attributes.is_difference eq 2>selected</cfif>><cf_get_lang dictionary_id="60822.Fark Olmayanlar"></option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-6 col-xs-12">
                            <div class="form-group">
                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="33706.Sağlık Harcaması"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
                                <div class="col col-6 col-md-6">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                        <cfif isdefined('attributes.he_start_date') and isdate(attributes.he_start_date)>
                                            <cfinput type="text" name="he_start_date" id="he_start_date" maxlength="10" validate="#validate_style#" message="#message#"  value="#dateformat(attributes.he_start_date,dateformat_style)#">
                                        <cfelse>
                                            <cfinput type="text" name="he_start_date" id="he_start_date" maxlength="10" validate="#validate_style#" message="#message#" >
                                        </cfif>
                                        <span class="input-group-addon">
                                            <cf_wrk_date_image date_field="he_start_date">
                                        </span>
                                    </div>
                                </div>
                                <div class="col col-6 col-md-6">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                        <cfif isdefined("attributes.he_finish_date") and isdate(attributes.he_finish_date)>
                                            <cfinput type="text" name="he_finish_date" id="he_finish_date" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.he_finish_date,dateformat_style)#">
                                        <cfelse>
                                            <cfinput type="text" name="he_finish_date" id="he_finish_date" maxlength="10" validate="#validate_style#" message="#message#" >
                                        </cfif>
                                        <span class="input-group-addon">
                                            <cf_wrk_date_image date_field="he_finish_date">
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57441.Fatura"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
                                <div class="col col-6 col-md-6">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                        <cfif isdefined('attributes.invoice_start_date') and isdate(attributes.invoice_start_date)>
                                            <cfinput type="text" name="invoice_start_date" id="invoice_start_date" maxlength="10" validate="#validate_style#" message="#message#"  value="#dateformat(attributes.invoice_start_date,dateformat_style)#">
                                        <cfelse>
                                            <cfinput type="text" name="invoice_start_date" id="invoice_start_date" maxlength="10" validate="#validate_style#" message="#message#" >
                                        </cfif>
                                        <span class="input-group-addon">
                                            <cf_wrk_date_image date_field="invoice_start_date">
                                        </span>
                                    </div>
                                </div>
                                <div class="col col-6 col-md-6">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                        <cfif isdefined("attributes.invoice_finish_date") and isdate(attributes.invoice_finish_date)>
                                            <cfinput type="text" name="invoice_finish_date" id="invoice_finish_date" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.invoice_finish_date,dateformat_style)#">
                                        <cfelse>
                                            <cfinput type="text" name="invoice_finish_date" id="invoice_finish_date" maxlength="10" validate="#validate_style#" message="#message#" >
                                        </cfif>
                                        <span class="input-group-addon">
                                            <cf_wrk_date_image date_field="invoice_finish_date">
                                        </span>
                                    </div>
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
                <th><cf_get_lang dictionary_id='57487.No'></th>
                <th><cf_get_lang dictionary_id='30525.E-Fatura No'></th>
                <th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
                <th><cf_get_lang dictionary_id='60870.E-Fatura Tutarı'></th>
                <th><cf_get_lang dictionary_id='60871.Anlaşmalı Kurum Faturası'></th>
                <th><cf_get_lang dictionary_id='33706.Sağlık Harcaması'></th>
                <th><cf_get_lang dictionary_id='60872.Sağlık Harcaması Belge No'></th>
                <th><cf_get_lang dictionary_id='60873.Sağlık Harcaması Durum'></th>
            <tr>
        </thead>
        <tbody>
            <cfif get_data.recordcount>
                <cfoutput query="get_data" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#EINVOICE_ID#</td>
                        <td>
                            <cfif len(ch_company_id)>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#ch_company_id#','medium');">#fullname#</a>
                            <cfelseif len(ch_consumer_id)>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#ch_consumer_id#','medium');"> #consumer_name# #consumer_surname#</a>
                            <cfelseif len(ch_employee_id)>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#ch_employee_id#','medium');"> #employee_name# #employee_surname#</a>
                            </cfif>
                        </td>
                        <td style="text-align:right;">#TLFormat(PAYABLE_AMOUNT)#</td>
                        <td style="text-align:right;">#TLFormat(TOTAL_AMOUNT_KDVLI)#</td>
                        <td style="text-align:right;">
                            <cfif len(NET_TOTAL_AMOUNT)>
                                #TLFormat(NET_TOTAL_AMOUNT)#
                            <cfelse>
                                -
                            </cfif>
                        </td>
                        <td>
                            <cfif len(PAPER_NO)>
                                <a href="#request.self#?fuseaction=hr.health_expense_approve&event=upd&health_id=#EXPENSE_ID#" target="_blank">#PAPER_NO#</a>
                            <cfelse>
                                -
                            </cfif>
                        </td>
                        <td>
                            <cfif len(expense_stage)>
                                <cf_workcube_process type="color-status" process_stage="#expense_stage#" fuseaction="hr.health_expense_approve">
                            <cfelse>
                                -
                            </cfif>
                        </td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="8"><cf_get_lang dictionary_id='57484.kayıt yok'>!</td>
                </tr>
            </cfif>
        </tbody>
    </cf_report_list>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "report.health_expenses_report">
	<cfif isdefined('attributes.is_form_submit')>
		<cfset url_str = '#url_str#&is_form_submit=1'>
    </cfif>
    <cfif len(attributes.is_difference)>
		<cfset url_str = '#url_str#&is_difference=#attributes.is_difference#'>
    </cfif>
    <cfif len(attributes.process_stage)>
		<cfset url_str = '#url_str#&process_stage=#attributes.process_stage#'>
    </cfif>
    <cfif len(attributes.process_cat_id)>
		<cfset url_str = '#url_str#&process_cat_id=#attributes.process_cat_id#'>
    </cfif>
    <cfif len(attributes.company)>
		<cfset url_str = '#url_str#&company=#attributes.company#'>
    </cfif>
    <cfif len(attributes.company_id)>
		<cfset url_str = '#url_str#&company_id=#attributes.company_id#'>
    </cfif>
    <cfif len(attributes.consumer_id)>
		<cfset url_str = '#url_str#&consumer_id=#attributes.consumer_id#'>
    </cfif>
    <cfif len(attributes.employee_id)>
		<cfset url_str = '#url_str#&employee_id=#attributes.employee_id#'>
    </cfif>
    <cfif len(attributes.member_type)>
		<cfset url_str = '#url_str#&member_type=#attributes.member_type#'>
    </cfif>
    <cfif len(attributes.he_start_date) and isdate(attributes.he_start_date)>
		<cfset url_str = "#url_str#&he_start_date=#dateformat(attributes.he_start_date,dateformat_style)#">
    </cfif>
    <cfif len(attributes.he_finish_date) and isdate(attributes.he_finish_date)>
        <cfset url_str = "#url_str#&he_finish_date=#dateformat(attributes.he_finish_date,dateformat_style)#">
    </cfif>
    <cfif len(attributes.invoice_start_date) and isdate(attributes.invoice_start_date)>
		<cfset url_str = "#url_str#&invoice_start_date=#dateformat(attributes.invoice_start_date,dateformat_style)#">
    </cfif>
    <cfif len(attributes.invoice_finish_date) and isdate(attributes.invoice_finish_date)>
        <cfset url_str = "#url_str#&invoice_finish_date=#dateformat(attributes.invoice_finish_date,dateformat_style)#">
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
        if(!date_check(search_form.he_start_date,search_form.he_finish_date,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
            return false;
        }
        if(!date_check(search_form.invoice_start_date,search_form.invoice_finish_date,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
            return false;
        }
        if(document.search_form.is_excel.checked==false){
            document.search_form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
            return true;
        }
        else
            document.search_form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_health_expenses_report</cfoutput>";
    }
</script>