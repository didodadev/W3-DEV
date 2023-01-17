<cfif len(get_sale_det.department_id)>
	<cfquery name="GET_STORE" datasource="#DSN#">
		SELECT 
			DEPARTMENT_ID,
			DEPARTMENT_HEAD 
		FROM 
			DEPARTMENT 
		WHERE 
			DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.department_id#">
	</cfquery>
</cfif>
<cfif len(get_sale_det.ship_method)>
	<cfquery name="GET_METHOD" datasource="#DSN#">
		SELECT 
			SHIP_METHOD_ID,
			SHIP_METHOD
		FROM 
			SHIP_METHOD 
		WHERE 
			SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.ship_method#">
	</cfquery>
</cfif>

<cfif len(get_sale_det.pay_method)>
	<cfquery name="GET_METHOD2" datasource="#DSN#">
		SELECT 
			PAYMETHOD_ID,
			PAYMETHOD,
			DUE_DAY
		FROM 
			SETUP_PAYMETHOD 
		WHERE 
			PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.pay_method#">
	</cfquery>
<cfelseif len(get_sale_det.card_paymethod_id)>
	<cfquery name="GET_METHOD_CARD" datasource="#DSN3#">
		SELECT 
			CARD_NO
		FROM 
			CREDITCARD_PAYMENT_TYPE 
		WHERE 
			PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.card_paymethod_id#">
	</cfquery>
</cfif>
