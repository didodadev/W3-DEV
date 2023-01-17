<cfquery name="GET_UPD_PURCHASE" datasource="#dsn3#">
	SELECT 
		*
	FROM 
		ORDERS
	WHERE 
		ORDER_ID = #attributes.order_id#	
</cfquery>
