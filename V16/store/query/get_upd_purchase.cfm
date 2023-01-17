<cfquery name="GET_UPD_PURCHASE" datasource="#dsn2#">
	SELECT 
    	* 
    FROM 
    	SHIP 
    WHERE 
    	SHIP_ID=#attributes.SHIP_ID#
</cfquery>
<cfif GET_UPD_PURCHASE.recordcount>
	<cfquery name="get_order" datasource="#dsn3#">
		SELECT
			ORDER_ID 
		FROM 
			ORDERS_SHIP 
		WHERE 
			SHIP_ID=#GET_UPD_PURCHASE.SHIP_ID#
			AND PERIOD_ID=#session.ep.period_id#
	</cfquery>
	<cfquery name="get_order_num" datasource="#dsn3#">
		SELECT 
			ORDER_NUMBER 
		FROM 
			ORDERS 
		WHERE 
			<cfif get_order.recordcount>
			ORDER_ID IN (#listsort(valuelist(get_order.ORDER_ID),"numeric","asc",",")#)
			<cfelse>
			ORDER_ID IS NULL
			</cfif>
	</cfquery>
</cfif>
<cfquery name="get_teslim" datasource="#DSN2#">
	SELECT PRODUCT_ID FROM STOCKS_ROW WHERE PROCESS_TYPE=81 AND UPD_ID = #URL.SHIP_ID#	AND STOCK_IN >0
</cfquery>

