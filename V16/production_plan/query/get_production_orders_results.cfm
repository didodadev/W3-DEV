<cfquery name="get_production_order" datasource="#dsn3#">
	SELECT
		*
	FROM
		PRODUCTION_ORDERS
	WHERE 
		P_ORDER_ID = #attributes.P_ORDER_ID#
</cfquery> 
<cfquery name="get_production_orders_results" datasource="#dsn3#">
	SELECT
		*
	FROM
		PRODUCTION_ORDER_RESULTS
	WHERE
		P_ORDER_ID = #attributes.P_ORDER_ID#
</cfquery>
