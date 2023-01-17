<cfquery name="GET_ORDER_LIST" datasource="#dsn3#">
	SELECT 
		ORDERS.ORDER_ID,
		ORDERS.CONSUMER_ID,
		ORDERS.PARTNER_ID,
		ORDERS.ORDER_NUMBER,
		ORDERS.ORDER_CURRENCY,
		ORDERS.ORDER_HEAD,
		ORDERS.OTHER_MONEY,
		ORDERS.TAX,
		ORDERS.COMMETHOD_ID,
		ORDERS.NETTOTAL, 
		ORDERS.ORDER_CURRENCY, 
		ORDERS.RECORD_DATE, 
		ORDERS.DELIVERDATE, 
		ORDERS.RECORD_EMP, 
		ORDERS.PRIORITY_ID, 
		ORDERS.IS_PROCESSED, 
		ORDERS.IS_WORK, 
		EMP.EMPLOYEE_NAME, 
		EMP.EMPLOYEE_EMAIL, 
		EMP.EMPLOYEE_SURNAME,
		ORDERS.ORDER_DATE
	FROM 
		ORDERS, 
		ORDER_ROW,
		#dsn_alias#.EMPLOYEES AS EMP
	WHERE 		
		ORDERS.ORDER_STATUS = 1 
		AND ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID
		AND	ORDER_ROW.ORDER_ROW_CURRENCY = -6
		AND	ORDERS.RECORD_EMP = EMP.EMPLOYEE_ID 
		AND	ORDERS.IS_PROCESSED = 0
		AND	ORDERS.PURCHASE_SALES = 0 
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(	EMP.EMPLOYEE_NAME LIKE '<cfif len(attributes.keyword) gte 3>%</cfif>#attributes.keyword#%'
			OR	EMP.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.keyword) gte 3>%</cfif>#attributes.keyword#%' 
		)
	</cfif>
	<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
		AND ORDERS.COMPANY_ID = #attributes.comp_id#
	</cfif>
	<cfif isdefined("attributes.cons_id") and len(attributes.cons_id)>
		AND ORDERS.CONSUMER_ID = #attributes.cons_id#
	</cfif>
</cfquery>

