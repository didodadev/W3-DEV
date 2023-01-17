<cfquery name="order_detail" datasource="#dsn3#">
	SELECT 
		* 
	FROM 
		ORDERS 
	WHERE 
		ORDER_ID=#attributes.ORDER_ID#
</cfquery>
<cfquery name="GET_ORDERS_PRODUCTS" datasource="#DSN3#">
	SELECT 
		ORR.ORDER_ROW_ID,
		ORR.SPECT_VAR_NAME,
		ORR.SPECT_VAR_ID,
		ORR.PRODUCT_ID, 
		ORR.STOCK_ID, 
		ORR.QUANTITY,
		S.STOCK_CODE, 
		S.IS_PRODUCTION,
		S.PROPERTY,
		S.PRODUCT_NAME, 
		S.IS_PURCHASE 
	FROM
		ORDER_ROW ORR,
		STOCKS S 
	 WHERE
		<!--- ORR.ORDER_ID = #attributes.ORDER_ID# AND --->
        ORR.ORDER_ROW_ID = #attributes.ORDER_ROW_ID# AND
		ORR.STOCK_ID = S.STOCK_ID
</cfquery>
