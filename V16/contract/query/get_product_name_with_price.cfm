<cfquery name="PRODUCT_NAMES" datasource="#dsn3#">
	SELECT
		STOCKS.STOCK_ID,
		STOCKS.PRODUCT_ID,
		STOCKS.PROPERTY,
		STOCKS.STOCK_CODE,
		STOCKS.PRODUCT_UNIT_ID,
		STOCKS.PRODUCT_NAME,
		STOCKS.COMPANY_ID,
		STOCKS.IS_SERIAL_NO,
		PRODUCT_UNIT.MAIN_UNIT,
		PRICE_STANDART.PRICE,
		PRICE_STANDART.PRICE_KDV,
		PRICE_STANDART.MONEY
	FROM
		PRODUCT_CAT,
		STOCKS,
		PRODUCT_UNIT,
		PRICE_STANDART 
	WHERE
		STOCKS.PRODUCT_STATUS = 1 AND
		STOCKS.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID AND
		PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
		PRODUCT_UNIT.IS_MAIN = 1
	<cfif isdefined("attributes.from_promotion")>
		AND STOCKS.IS_SALES = 1
	</cfif>
	<cfif isdefined("attributes.is_hizmet") and (attributes.is_hizmet eq 1)>
		AND STOCKS.IS_INVENTORY = 0
	</cfif>	
	<cfif  len(attributes.product_cat) and isDefined("attributes.product_cat_code") and len(attributes.product_cat_code)>
		AND STOCKS.STOCK_CODE LIKE '#PRODUCT_CAT_CODE#%'
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
		<cfif listlen(attributes.keyword,"+") gt 1>
			(
				<cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
					STOCKS.PRODUCT_NAME LIKE '%#ListGetAt(attributes.keyword,pro_index,"+")#%' 
					<cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
				</cfloop>
			)	
			<cfelse>
				STOCKS.PRODUCT_NAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' OR
				STOCKS.STOCK_CODE LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
			</cfif>
		)
	</cfif>
		 AND STOCKS.PRODUCT_ID=PRICE_STANDART.PRODUCT_ID
		 AND PRICE_STANDART.PRICESTANDART_STATUS=1
		 AND PRICE_STANDART.PURCHASESALES = 1 
	ORDER BY STOCKS.PRODUCT_NAME,STOCKS.PROPERTY
</cfquery>

