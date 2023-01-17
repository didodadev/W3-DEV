<cfquery name="get_pro_ship" datasource="#DSN3#">
	SELECT
		PRODUCT_NAME,STOCK_ID,SUM(QUANTITY) AS QUANTITY,ORDER_HEAD
	FROM
		ORDER_ROW,
		ORDERS
	WHERE
		ORDERS.ORDER_ID=ORDER_ROW.ORDER_ID AND
		ORDERS.ORDER_ID=#attributes.order_id#
	GROUP BY
		STOCK_ID,PRODUCT_NAME,ORDER_HEAD
</cfquery>
<cfquery name="get_orders_ship" datasource="#dsn3#">
	SELECT 
		SHIP_ID
	FROM
		ORDERS_SHIP
	WHERE
		ORDER_ID=#attributes.order_id#
		AND PERIOD_ID=#session.ep.period_id#
</cfquery>
<cfif get_orders_ship.recordcount>
	<cfquery name="get_ship_det" datasource="#DSN2#">
		SELECT
			STOCK_ID,SUM(AMOUNT) AS AMOUNT
		FROM
			SHIP,
			SHIP_ROW
		WHERE
			SHIP_ROW.SHIP_ID=SHIP.SHIP_ID AND
			SHIP_ROW.ROW_ORDER_ID=#attributes.order_id# AND
			SHIP.SHIP_ID IN (#listsort(valuelist(get_orders_ship.SHIP_ID),"numeric","asc",",")#)
		GROUP BY
			STOCK_ID		
	</cfquery>
<cfelse>
	<cfset get_ship_det.recordcount=0>
</cfif>

