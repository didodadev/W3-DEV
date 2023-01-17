<cfquery name="GET_ORDER_NUMBER" datasource="#dsn3#">
	SELECT 
		ORDER_NUMBER
	FROM 
		ORDERS 
	WHERE 
		ORDER_ID = #ATTRIBUTES.ORDER_ID#
</cfquery>
