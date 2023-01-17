<cfquery name="get_unique" datasource="#DSN3#">
	SELECT 
		P_ORDER_ID,QUANTITY
	FROM 
		PRODUCTION_ORDERS 
	WHERE 
		ORDER_ID=#attributes.ORDER_ID# 
	AND
		STOCK_ID=#attributes.STOCK_ID#
</cfquery>
