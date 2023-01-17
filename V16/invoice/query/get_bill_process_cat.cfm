<cfif not isdefined("new_dsn3_group")><cfset new_dsn3_group = dsn3></cfif>
<cfquery name="get_process_type" datasource="#new_dsn3_group#">
	SELECT 
		*
	FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>

<cfscript>
	process_cat = form.PROCESS_CAT;
	process_type =  get_process_type.process_type;
	is_dept_based_acc = get_process_type.IS_DEPT_BASED_ACC;
	inv_profile_id = get_process_type.PROFILE_ID;
	is_cari = get_process_type.IS_CARI;
	is_account = get_process_type.IS_ACCOUNT;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	invoice_cat = get_process_type.PROCESS_TYPE;
	is_discount = get_process_type.IS_DISCOUNT;
	is_budget = get_process_type.IS_BUDGET;
	is_project_based_acc=get_process_type.IS_PROJECT_BASED_ACC;
	is_project_based_budget=get_process_type.IS_PROJECT_BASED_BUDGET;
	is_due_date_based_cari=get_process_type.IS_DUE_DATE_BASED_CARI;
	is_paymethod_based_cari=get_process_type.IS_PAYMETHOD_BASED_CARI;
	is_prod_cost_acc_action=get_process_type.IS_PROD_COST_ACC_ACTION;
	is_row_project_based_cari = get_process_type.IS_ROW_PROJECT_BASED_CARI;
	is_expensing_tax = get_process_type.IS_EXPENSING_TAX;
	is_export_registered = get_process_type.IS_EXPORT_REGISTERED;
	is_export_product = get_process_type.IS_EXPORT_PRODUCT;
	next_periods_accrual_action = get_process_type.NEXT_PERIODS_ACCRUAL_ACTION;
	accrual_budget_action = get_process_type.ACCRUAL_BUDGET_ACTION;
	is_expensing_bsmv = get_process_type.IS_EXPENSING_BSMV;
	is_budget_reserved = get_process_type.IS_BUDGET_RESERVED_CONTROL;
	is_visible_tevkifat = get_process_type.IS_VISIBLE_TEVKIFAT;
	is_account_type_id = get_process_type.ACCOUNT_TYPE_ID;
</cfscript>
<cfif not isdefined("attributes.project_id")><!--- faturalardaki proje seçeneği gelmedigi durumlarda actionlarda çakan yerler vardı onlar için eklendiAysenur20080201--->
	<cfset attributes.project_id = "">
</cfif>
<!--- <cfif listfind("531,591",invoice_cat)>
	<cfquery name="GET_KAMBIYO_MONEY" datasource="#dsn2#">
		SELECT 
			ACCOUNT_950,RATE1, RATE2 
		FROM 
			SETUP_MONEY
		WHERE
			MONEY='#form.basket_money#'
	</cfquery>
</cfif> --->
