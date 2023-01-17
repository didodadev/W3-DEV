<cf_get_lang_set module_name="cheque">
<cf_xml_page_edit fuseact="cheque.list_cheque_actions">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.cheque_number" default="">
<cfparam name="attributes.page_action_type" default="">
<cfparam name="attributes.account_id" default="">
<cfparam name="attributes.branch_id" default="">
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
	<cfinclude template="../cheque/query/get_cheque_actions.cfm">
<cfelse>
	<cfset GET_CHEQUE_ACTIONS.recordcount = 0>
</cfif>
<cfset islem_tipi = '90,91,92,93,94,95,105,133,134,135'>
<cfquery name="get_process_cat" datasource="#dsn3#">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#islem_tipi#) ORDER BY PROCESS_TYPE
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_cheque_actions.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
	$(document).ready(function(){
		document.getElementById('keyword').focus();
	});
	function control_update(act_id)
	{
		var get_ord_number = wrk_safe_query('chq_get_ord_number','dsn3',0,act_id);
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
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'cheque.list_cheque_actions';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'cheque/display/list_cheque_actions.cfm';

</cfscript>
