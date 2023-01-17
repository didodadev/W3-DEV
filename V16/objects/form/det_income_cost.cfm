<cfparam name="attributes.expense_id" default="">
<cfscript>
	income_cost= createObject("component","V16.objects.cfc.income_cost") ;
	GET_MONEY=income_cost.GET_MONEY(); 
	GET_EXPENSE_MONEY=income_cost.GET_EXPENSE_MONEY(expense_id:attributes.expense_id);
	GET_EXPENSE=income_cost.GET_EXPENSE(expense_id:attributes.expense_id);
	CHK_SEND_INV=income_cost.CHK_SEND_INV(expense_id:attributes.expense_id);
	CHK_SEND_ARC=income_cost.CHK_SEND_ARC(expense_id:attributes.expense_id);
	CONTROL_EINVOICE=income_cost.CONTROL_EINVOICE(expense_id:attributes.expense_id);
	CONTROL_EARCHIVE=income_cost.CONTROL_EARCHIVE(expense_id:attributes.expense_id);
	GET_DOCUMENT_TYPE=income_cost.GET_DOCUMENT_TYPE();
</cfscript>
<cfif len(get_expense.ch_company_id) and get_expense.ch_company_id neq 0>
	<cfset get_expense_comp=income_cost.get_expense_comp(ch_company_id:get_expense.ch_company_id)>
<cfelseif len(get_expense.ch_consumer_id)>
	<cfset GET_CONS_NAME=income_cost.GET_CONS_NAME(ch_consumer_id:get_expense.ch_consumer_id)>
</cfif>
<cf_catalystHeader>
<div class="row">
<div class="col col-9">
    <cf_get_workcube_asset  asset_cat_id='-17' module_id='49' action_section='EXPENSE_ID' action_id='#attributes.expense_id#'>
    <cf_get_workcube_note company_id="#session.ep.company_id#" asset_cat_id='-17' module_id='49' action_section='EXPENSE_ID' action_id='#attributes.expense_id#'>
</div>
</div>