<cfquery name="get_product_unit" datasource="#DSN3#">
	SELECT * FROM PRODUCT_UNIT WHERE PRODUCT_ID = #attributes.product_id#
</cfquery>
<cfquery name="get_reserved_orders_purchase_1" datasource="#dsn3#">
	SELECT 
		ORD.AMOUNT,
		ORD.DEPARTMENT_ID,
		UNIT_ID
	FROM
		ORDER_ROW_DEPARTMENTS ORD,
		ORDER_ROW ORR
	WHERE 
		ORR.ORDER_ROW_ID = ORD.ORDER_ROW_ID AND
		ORR.PRODUCT_ID = #attributes.product_id# AND 
		ORR.ORDER_ID IN (SELECT ORDER_ID FROM ORDERS WHERE RESERVED = 1 AND PURCHASE_SALES=0 AND ORDER_CURRENCY <>-6)
</cfquery>
<cfquery name="get_reserved_orders_purchase_2" datasource="#dsn3#">
	SELECT 
		ORR.QUANTITY AS AMOUNT,
		ORR.DELIVER_DEPT AS DEPARTMENT_ID,
		UNIT_ID
	FROM
		ORDER_ROW ORR
	WHERE 
		ORR.ORDER_ROW_ID NOT IN (SELECT ORDER_ROW_ID FROM ORDER_ROW_DEPARTMENTS) AND
		ORR.PRODUCT_ID = #attributes.product_id# AND
		ORR.ORDER_ID IN (SELECT ORDER_ID FROM ORDERS WHERE RESERVED = 1 AND PURCHASE_SALES=0 AND IS_PROCESSED<>1)
</cfquery>
<cfquery name="get_reserved_orders_purchase" dbtype="query">
	SELECT 
		SUM(get_reserved_orders_purchase_1.AMOUNT*MULTIPLIER) AMOUNT,
		DEPARTMENT_ID
	FROM
		get_reserved_orders_purchase_1,
		get_product_unit
	WHERE
		get_reserved_orders_purchase_1.UNIT_ID = get_product_unit.PRODUCT_UNIT_ID
		
	GROUP BY DEPARTMENT_ID		
	UNION 
	SELECT 
		SUM(get_reserved_orders_purchase_2.AMOUNT*MULTIPLIER) AMOUNT,
		DEPARTMENT_ID
	FROM
		get_reserved_orders_purchase_2,
		get_product_unit
	WHERE
		get_reserved_orders_purchase_2.UNIT_ID = get_product_unit.PRODUCT_UNIT_ID
	GROUP BY DEPARTMENT_ID
</cfquery>
<cfquery name="get_reserved_orders_sale_1" datasource="#dsn3#">
	SELECT 
		ORR.QUANTITY AS AMOUNT,
		ORR.DELIVER_DEPT AS DEPARTMENT_ID,
		UNIT_ID
	FROM
		ORDER_ROW ORR
	WHERE 
		ORR.PRODUCT_ID = #attributes.product_id# AND
		ORR.ORDER_ID IN (SELECT ORDER_ID FROM ORDERS WHERE RESERVED = 1 AND PURCHASE_SALES=1 AND IS_PROCESSED<>1)
</cfquery>
<cfquery name="get_reserved_orders_sale" dbtype="query">
	SELECT 
		SUM(get_reserved_orders_sale_1.AMOUNT*MULTIPLIER) AMOUNT,
		DEPARTMENT_ID
	FROM
		get_reserved_orders_sale_1,
		get_product_unit
	WHERE
		get_reserved_orders_sale_1.UNIT_ID = get_product_unit.PRODUCT_UNIT_ID
	 GROUP BY DEPARTMENT_ID
</cfquery>
