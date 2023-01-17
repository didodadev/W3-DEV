<cfif len(GET_SALE_DET.DEPARTMENT_ID)>
	<cfquery name="GET_STORE" datasource="#dsn#">
		SELECT 
			DEPARTMENT_ID,
			DEPARTMENT_HEAD 
		FROM 
			DEPARTMENT 
		WHERE 
			DEPARTMENT_ID=#GET_SALE_DET.DEPARTMENT_ID#
	</cfquery>
</cfif>
<cfif len(GET_SALE_DET.SHIP_METHOD)>
	<cfquery name="GET_METHOD" datasource="#dsn#">
		SELECT 
			SHIP_METHOD_ID,
			SHIP_METHOD
		FROM 
			SHIP_METHOD 
		WHERE 
			SHIP_METHOD_ID=#GET_SALE_DET.SHIP_METHOD#
	</cfquery>
</cfif>

<cfif len(GET_SALE_DET.PAY_METHOD)>
	<cfquery name="GET_METHOD2" datasource="#dsn#">
		SELECT 
			PAYMETHOD_ID,
			PAYMETHOD,
			DUE_DAY
		FROM 
			SETUP_PAYMETHOD 
		WHERE  
			PAYMETHOD_STATUS = 1 AND 
			PAYMETHOD_ID = #GET_SALE_DET.PAY_METHOD#
	</cfquery>
<cfelseif len(GET_SALE_DET.CARD_PAYMETHOD_ID)>
	<cfquery name="GET_METHOD_CARD" datasource="#dsn3#">
		SELECT 
			CARD_NO
		FROM 
			CREDITCARD_PAYMENT_TYPE 
		WHERE 
			PAYMENT_TYPE_ID=#GET_SALE_DET.CARD_PAYMETHOD_ID#
	</cfquery>
</cfif>
