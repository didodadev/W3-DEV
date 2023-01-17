<cfquery name="PRODUCTS" datasource="#DSN3#">
	SELECT  
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			PRODUCT.PRODUCT_NAME,
			STOCKS.PROPERTY,
			STOCKS.BARCOD AS BARCOD,
			PRODUCT.TAX AS TAX,
			PRODUCT.IS_ZERO_STOCK,
			PRODUCT.PRODUCT_CATID,
			PRODUCT.IS_SERIAL_NO,
			STOCKS.MANUFACT_CODE,
			<cfif attributes.price_catid gt 0 >
				PRICE.PRICE,
				PRICE.MONEY,
			<cfelse>
				PRICE_STANDART.PRICE,
				PRICE_STANDART.MONEY,
			</cfif>
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.UNIT_ID,
			PRODUCT_UNIT.MAIN_UNIT,
			PRODUCT_UNIT.MULTIPLIER
		FROM
			PRODUCT,
			PRODUCT_CAT,
			STOCKS,
		<cfif attributes.price_catid gt 0>
			PRICE, PRICE_CAT,
		<cfelse>
			PRICE_STANDART,
		</cfif>
			PRODUCT_UNIT
		WHERE
			PRODUCT.PRODUCT_STATUS = 1 AND 
			PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND 
			PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND 
			PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND 
			PRODUCT.IS_SALES=1 
			<cfif isDefined("attributes.product_cat_code") and len(attributes.product_cat_code)>
				AND PRODUCT.PRODUCT_CODE LIKE '#attributes.product_cat_code#.%'
			</cfif>
			<cfif attributes.price_catid lt 0>
				AND PRICE_STANDART.PRICESTANDART_STATUS = 1			
			</cfif>
			<cfif attributes.price_catid gt 0><!--- dinamik bir fiyat kategorisi istenmisse --->
				AND PRICE_CAT.PRICE_CATID = #attributes.price_catid#			
				AND	PRICE_CAT.PRICE_CAT_STATUS = 1
				AND PRICE.PRODUCT_ID = STOCKS.PRODUCT_ID
				AND	PRICE_CAT.PRICE_CATID = PRICE.PRICE_CATID
				AND PRICE.STARTDATE <= #now()#
				AND (PRICE.FINISHDATE >= #now()# OR PRICE.FINISHDATE IS NULL)
				AND PRICE.UNIT = PRODUCT_UNIT.PRODUCT_UNIT_ID
				<!--- AND PRICE.UNIT = STOCKS.PRODUCT_UNIT_ID --->
			<cfelse><!--- if attributes.price_catid eq '-2' Standart Satis Fiyatlari Default Gelsin --->
				AND PRICE_STANDART.PURCHASESALES = 1
				AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
				<!--- AND PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID --->
				AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
			</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword) gt 1>
				AND
					(
					STOCKS.STOCK_CODE LIKE '#attributes.keyword#%' OR
					<!--- PRODUCT.PRODUCT_ID IN (SELECT PRODUCT_ID FROM GET_STOCK_BARCODES WHERE BARCODE = '#attributes.keyword#') OR --->
					PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'%#attributes.keyword#%'
					)
			<cfelseif isDefined("attributes.keyword") and len(attributes.keyword) eq 1>
				AND	PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'#attributes.keyword#%' 
			</cfif>
		ORDER BY
			PRODUCT.PRODUCT_NAME,STOCKS.PROPERTY,PRODUCT_UNIT.ADD_UNIT
</cfquery>
