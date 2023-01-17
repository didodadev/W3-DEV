<cfset cmpExpense = createObject("component","V16.myhome.cfc.health_expense") />
<cfset get_expense = cmpExpense.GET_EXPENSE(health_id : attributes.health_id) />
<cfquery name="add_contract_comparison" datasource="#dsn2#">
	INSERT INTO 
		INVOICE_CONTRACT_COMPARISON
	(
		MAIN_INVOICE_ID,
		MAIN_INVOICE_DATE,
		MAIN_INVOICE_NUMBER,
		COMPANY_ID,
		MAIN_PRODUCT_ID,
		MAIN_STOCK_ID,
		AMOUNT,
		DIFF_RATE,
		DIFF_AMOUNT,
		DIFF_AMOUNT_OTHER,
		OTHER_MONEY,
		IS_DIFF_DISCOUNT,
		IS_DIFF_PRICE,
		DIFF_TYPE,
		TAX,
		NOTE,
		INVOICE_TYPE,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
	)
	VALUES
	(
		<cfif len(attributes.expense_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#"><cfelse>NULL</cfif>,
		<cfif len(get_expense.invoice_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_expense.invoice_date#"><cfelse>NULL</cfif>,
		<cfif len(attributes.invoice_no)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.invoice_no#"><cfelse>NULL</cfif>,
		<cfif len(attributes.company_id) and len(attributes.company)><cfqueryparam cfsqltype="integer" value="#attributes.company_id#"><cfelse>NULL</cfif>,
		<cfif len(attributes.product_id) and len(attributes.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"><cfelse>NULL</cfif>,
		<cfif len(attributes.stock_id) and len(attributes.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"><cfelse>NULL</cfif>,
		<cfif len(attributes.amount)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount#"><cfelse>NULL</cfif>,
		0,
		<cfif len(attributes.amount)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount#"><cfelse>NULL</cfif>,
		<cfif len(attributes.currency_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.currency_amount#"><cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#listfirst(attributes.rd_money,',')#">,
		0,
		0,
		<cfif len(attributes.diff_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.diff_type#"><cfelse>NULL</cfif>,
		<cfif len(attributes.kdv)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.kdv#"><cfelse>NULL</cfif>,
		<cfif len(attributes.invoice_details)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.invoice_details#"><cfelse>NULL</cfif>,
		<cfif len(attributes.pur_sales_info)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.pur_sales_info#"><cfelse>NULL</cfif>,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#',
		#NOW()#
	)
</cfquery>
<script type="text/javascript">
	<cfif isDefined('attributes.draggable')>closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>)<cfelse>window.close()</cfif>;
	location.reload();
</script>