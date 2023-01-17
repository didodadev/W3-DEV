<cfquery name="get_stock_row" datasource="#dsn2#">
	SELECT
		PROD_ORDER_NUMBER
	FROM
		STOCK_FIS
	WHERE
		PROD_ORDER_NUMBER=#attributes.P_ORDER_ID#		
</cfquery>
<cfquery name="GET_DET_PO" datasource="#dsn3#">
	SELECT * FROM PRODUCTION_ORDER_RESULTS WHERE P_ORDER_ID = #attributes.P_ORDER_ID#
</cfquery>
