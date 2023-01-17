<!---  Sayfa pid (ynai urun id ) ile calisisyor ve invoicerowdaki en son alinan urun faturasina gore urunun fiyiatini bize getiriryor --->
<cfif attributes.calc_type is 1>
	<cfquery name="GET_PRICE" datasource="#dsn2#">
		SELECT
			MAX(INVOICE.INVOICE_DATE),
			(PRICE/#attributes.MULTIPLIER#)/(AMOUNT*#attributes.MULTIPLIER#) AS PRICE,
			'#session.ep.money#' AS MONEY
		FROM
			INVOICE_ROW,
			INVOICE
		WHERE
			INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
			INVOICE_ROW.PRODUCT_ID = #attributes.pid#	AND 	
			INVOICE_ROW.PURCHASE_SALES = 0 
		GROUP BY 
			INVOICE_ROW.PRICE,
			INVOICE_ROW.AMOUNT	
	</cfquery>
<cfelseif attributes.calc_type is 2>
	<cfquery name="GET_PRICE" datasource="#dsn2#">
		SELECT
			MIN(INVOICE.INVOICE_DATE),
			(PRICE/#attributes.MULTIPLIER#)/(AMOUNT*#attributes.MULTIPLIER#) AS PRICE,
			'#session.ep.money#' AS MONEY
		FROM
			INVOICE_ROW,
			INVOICE
		WHERE
			INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
			INVOICE_ROW.PRODUCT_ID = #attributes.pid# AND 	
			INVOICE.PURCHASE_SALES = 0 
		GROUP BY 
			INVOICE_ROW.PRICE,
			INVOICE_ROW.AMOUNT	
	</cfquery>
<cfelseif attributes.calc_type is 3>	
  <cfquery name="GET_PRICE" datasource="#dsn3#">
	SELECT 	
		PRICE_STANDART.PRICE,
		PRICE_STANDART.MONEY,
		0 AS EXTRA_COST_VALUE
	FROM 
		PRICE_STANDART,
		PRODUCT_UNIT
	WHERE  
		PRICE_STANDART.PURCHASESALES = 0 AND 
		PRODUCT_UNIT.IS_MAIN = 1 AND 
		PRICE_STANDART.PRICESTANDART_STATUS = 1 AND 
		PRICE_STANDART.PRODUCT_ID = #attributes.pid# AND 
		PRODUCT_UNIT.PRODUCT_ID = #attributes.pid#
	</cfquery>
<cfelseif attributes.calc_type is 4>	
  <cfquery name="GET_PRICE" datasource="#dsn3#">
	SELECT 	
		PRICE_STANDART.PRICE,
		PRICE_STANDART.MONEY,
		0 AS EXTRA_COST_VALUE
	FROM 
		PRICE_STANDART,
		PRODUCT_UNIT
	WHERE  
		PRICE_STANDART.PURCHASESALES = 1 AND 
		PRODUCT_UNIT.IS_MAIN = 1 AND 
		PRICE_STANDART.PRICESTANDART_STATUS = 1 AND 
		PRICE_STANDART.PRODUCT_ID = #attributes.pid# AND 
		PRODUCT_UNIT.PRODUCT_ID = #attributes.pid#
	</cfquery>
<cfelseif attributes.calc_type eq 5>
	<cfquery name="GET_PRICE" datasource="#dsn3#" maxrows="1">
		SELECT 
			PRODUCT_COST.PURCHASE_NET AS PRICE,
			PRODUCT_COST.MONEY AS MONEY,
			PURCHASE_EXTRA_COST AS EXTRA_COST_VALUE
		FROM
			PRODUCT_COST
		WHERE
			PRODUCT_COST.PRODUCT_ID = #attributes.pid# AND
			PRODUCT_COST.PRODUCT_COST_STATUS = 1
		ORDER BY RECORD_DATE DESC
	</cfquery>
	<cfif get_price.recordcount eq 0>
	  <cfquery name="GET_PRICE" datasource="#dsn3#">
		SELECT 	
			PRICE_STANDART.PRICE,
			PRICE_STANDART.MONEY,
			0 AS EXTRA_COST_VALUE
		FROM 
			PRICE_STANDART,
			PRODUCT_UNIT
		WHERE  
			PRICE_STANDART.PURCHASESALES = 0 AND 
			PRODUCT_UNIT.IS_MAIN = 1 AND 
			PRICE_STANDART.PRICESTANDART_STATUS = 1 AND 
			PRICE_STANDART.PRODUCT_ID = #attributes.pid# AND 
			PRODUCT_UNIT.PRODUCT_ID = #attributes.pid#
		</cfquery>
	</cfif>
</cfif>
