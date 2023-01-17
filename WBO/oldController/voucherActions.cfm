<cf_get_lang_set module_name="cheque">
<cf_xml_page_edit fuseact="cheque.list_voucher_actions">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.voucher_number" default="">
<cfparam name="attributes.page_action_type" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.account_id" default="">
<cfparam name="attributes.special_definition_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.product_name" default="">
<cfif isdefined("attributes.is_form_submitted")>
	<cfif isdefined("attributes.employee_id")>
        <cfscript>
            attributes.acc_type_id = '';
            if(listlen(attributes.employee_id,'_') eq 2)
            {
                attributes.acc_type_id = listlast(attributes.employee_id,'_');
                attributes.emp_id = listfirst(attributes.employee_id,'_');
            }
            else
                attributes.emp_id = attributes.employee_id;
        </cfscript>
    </cfif>
    <cfif len(attributes.start_date) and isdate(attributes.start_date)>
        <cf_date tarih = "attributes.start_date">
    </cfif>
    <cfif len(attributes.finish_date) and isdate(attributes.finish_date)>
        <cf_date tarih = "attributes.finish_date">
    </cfif>
	<cfinclude template="../cheque/query/get_voucher_actions.cfm">
	<cfset arama_yapilmali = 0 >
<cfelse>
	<cfset get_voucher_actions.recordcount = 0 >
	<cfset arama_yapilmali = 1 >
</cfif>
<cfset islem_tipi = '97,98,99,100,101,104,108,109,136,137'>
<cfquery name="get_process_cat" datasource="#dsn3#">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#islem_tipi#) ORDER BY PROCESS_TYPE
</cfquery>
<cfif isdefined("session.payroll")>
	<cfscript>structdelete(session,"payroll");</cfscript>
</cfif>
<cfif isdefined("session.payroll_bank")>
	<cfscript>structdelete(session,"payroll_bank");</cfscript>
</cfif>
<cfif isdefined("session.payroll_rev")>
	<cfscript>structdelete(session,"payroll_rev");</cfscript>
</cfif>
<cfif isdefined("session.payroll_comp")>
	<cfscript>structdelete(session,"payroll_comp");</cfscript>
</cfif>
<cfif isdefined("session.upd_payroll")>
	<cfscript>structdelete(session,"upd_payroll");</cfscript>
</cfif>
<cfif isdefined("session.upd_payroll_bank")>
	<cfscript>structdelete(session,"upd_payroll_bank");</cfscript>
</cfif>
<cfif isdefined("session.upd_payroll_rev")>
	<cfscript>structdelete(session,"upd_payroll_rev");</cfscript>
</cfif>
<cfif isdefined("session.upd_payroll_comp")>
	<cfscript>structdelete(session,"upd_payroll_comp");</cfscript>
</cfif>
<cfif isdefined("session.company_id")>
	<cfscript>structdelete(session,"company_id");</cfscript>
</cfif>
<cfif isdefined("session.emp_id")>
	<cfscript>structdelete(session,"emp_id");</cfscript>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<script type="text/javascript">
	$(document).ready(function(){
		document.getElementById('keyword').focus();
	});
	function control_update(act_id)
	{
		var get_ord_number =wrk_safe_query('chq_get_ord_number','dsn3',0,act_id);
		alert('<cf_get_lang no="275.Bu İşlemi İlgili Olduğu"> ' + get_ord_number.ORDER_NUMBER +' <cf_get_lang no="276.Nolu Siparişin Ödeme Planından Güncelleyebilirsiniz">!');
		return false;
	}	
	function return_company()
	{	
		if(document.getElementById('member_type').value=='employee')
		{	
			var emp_id=document.getElementById('employee_id').value;
			var GET_COMPANY=wrk_safe_query('chq_get_company','dsn',0,emp_id);
			document.getElementById('company_id').value=GET_COMPANY.COMP_ID;
		}
		else
			return false;
	}
	function kontrol ()
		{
			if (!date_check (document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!"))
				return false;
			else
				return true;	
		}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'cheque.list_voucher_actions';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'cheque/display/list_voucher_actions.cfm';

</cfscript>
