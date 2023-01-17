<cfif isdefined("attributes.price_catid") and (attributes.price_catid gt 0)>
	<cfquery name="get_product_detail_hepsi" datasource="#dsn3#">
		SELECT
			P.PRODUCT_NAME,
			P.TAX,
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.UNIT_MULTIPLIER,
			PRODUCT_UNIT.UNIT_MULTIPLIER_STATIC,
			STOCKS.PROPERTY,
			GET_STOCK_BARCODES.BARCODE,
			PRICE.MONEY,
			PRICE.IS_KDV,
			PRICE.PRICE_KDV,
			PRICE.PRICE,
			PRICE.PRICE_DISCOUNT,
			PRICE.STARTDATE,
			PRICE.FINISHDATE,
			PRICE.PRICE_CATID,
			PRICE.PRICE_ID
		FROM 
			PRODUCT P, 
			PRODUCT_UNIT,
			STOCKS,
			GET_STOCK_BARCODES,
			PRICE
		WHERE
			PRICE.PRICE_CATID = #attributes.price_catid# AND
		<cfif isdefined("attributes.startdate") and len(attributes.startdate) AND isdefined("attributes.finishdate") and len(attributes.finishdate)>
			PRICE.STARTDATE BETWEEN #attributes.startdate# AND #attributes.finishdate# AND
		<cfelseif isdefined("attributes.startdate") and len(attributes.startdate)>
			<cfset finishdate = date_add("d",1,attributes.startdate)>
			PRICE.STARTDATE BETWEEN #attributes.startdate# AND #finishdate# AND
		<cfelseif isdefined("attributes.finishdate") and len(attributes.finishdate)><!--- sadece finish verirse boş döner --->
			1=2 AND
		<cfelse>
			PRICE.STARTDATE <= #now()# AND
			(PRICE.FINISHDATE >= #now()# OR PRICE.FINISHDATE IS NULL) AND 
		</cfif>
			GET_STOCK_BARCODES.BARCODE IN (#ListQualify(attributes.barcode,"'",",")#) AND
			P.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID AND
			GET_STOCK_BARCODES.PRODUCT_ID = P.PRODUCT_ID AND
			GET_STOCK_BARCODES.STOCK_ID = STOCKS.STOCK_ID AND
			STOCKS.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
			P.PRODUCT_ID = PRICE.PRODUCT_ID AND
			PRICE.UNIT = PRODUCT_UNIT.PRODUCT_UNIT_ID
		<cfif database_type is 'MSSQL'>
			AND LEN(GET_STOCK_BARCODES.BARCODE) > 6
		<cfelseif database_type is 'DB2'>
			AND LENGTH(GET_STOCK_BARCODES.BARCODE) > 6
		</cfif>
			AND ( PRICE.PRICE_KDV > 0 OR PRICE.PRICE > 0 )
	</cfquery>
<cfelseif isdefined("attributes.price_catid") and (attributes.price_catid eq -2)>
	<cfquery name="get_product_detail_hepsi" datasource="#dsn3#">
		SELECT
			P.PRODUCT_NAME,
			P.TAX,
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.UNIT_MULTIPLIER,
			PRODUCT_UNIT.UNIT_MULTIPLIER_STATIC,
			STOCKS.PROPERTY,
			GET_STOCK_BARCODES.BARCODE,
			PRICE_STANDART.PRICE,
			PRICE_STANDART.PRICE_KDV,
			0 AS PRICE_DISCOUNT,				
			PRICE_STANDART.MONEY,
			PRICE_STANDART.IS_KDV,
			PRICE_STANDART.UNIT_ID,
			PRICE_STANDART.RECORD_DATE AS STARTDATE,
			'' AS FINISHDATE,
			PRICESTANDART_ID AS PRICE_ID
		FROM 
			PRODUCT P, 
			PRODUCT_UNIT,
			STOCKS,
			GET_STOCK_BARCODES,
			PRICE_STANDART
		WHERE  
			PRICE_STANDART.PURCHASESALES = 1 AND 
			PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
			PRODUCT_UNIT.IS_MAIN = 1 AND
			GET_STOCK_BARCODES.BARCODE IN (#ListQualify(attributes.barcode,"'",",")#) AND
			P.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID AND
			GET_STOCK_BARCODES.PRODUCT_ID = P.PRODUCT_ID AND
			STOCKS.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
			P.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
			GET_STOCK_BARCODES.STOCK_ID = STOCKS.STOCK_ID AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND
			(PRICE_STANDART.PRICE_KDV > 0 OR PRICE_STANDART.PRICE > 0)
		<cfif database_type is 'MSSQL'>
			AND LEN(GET_STOCK_BARCODES.BARCODE) > 6
		<cfelseif database_type is 'DB2'>
			AND LENGTH(GET_STOCK_BARCODES.BARCODE) > 6
		</cfif>
	</cfquery>
</cfif>
