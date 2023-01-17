<cffunction name="get_product_objects2" access="public" returntype="query" output="no">
	<cfargument name="product_name" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="-1">
	<cfargument name="is_store_module" required="no" type="numeric">
	<cfquery name="GET_PRODUCT_OBJECTS2" datasource="#DSN3#">
		SELECT
			PRODUCT.IS_INVENTORY,
			PRODUCT.PRODUCT_NAME,
			STOCKS.PROPERTY,
			PRODUCT.PRODUCT_ID,
			STOCKS.STOCK_ID,
			STOCKS.STOCK_CODE,
			PRODUCT.PRODUCT_CODE,
			PRODUCT.TAX,
			PRODUCT.PRODUCT_CATID,
			PRODUCT.IS_SERIAL_NO,
			PRICE_STANDART.PRICE,
			PRICE_STANDART.PRICE_KDV,
			PRICE_STANDART.IS_KDV,
			PRICE_STANDART.MONEY,
            PRODUCT_CAT.PRODUCT_CATID,
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.UNIT_ID,
			PRODUCT_UNIT.MAIN_UNIT,
			PRODUCT_UNIT.MULTIPLIER,
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.PRODUCT_UNIT_ID,
			PRODUCT_UNIT.WEIGHT
		FROM
			PRODUCT,
			PRODUCT_CAT,
			PRODUCT_UNIT,
			PRICE_STANDART,
			STOCKS
		WHERE			
			PRODUCT.PRODUCT_STATUS = 1 AND
			STOCKS.STOCK_STATUS = 1 AND
			PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND
			PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND 
			PRODUCT.IS_EXTRANET = 1 AND
			PRODUCT_UNIT.IS_MAIN =1 AND	
			(
            	STOCKS.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.product_name#%"> OR
            	STOCKS.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.product_name#%">
            ) AND
			<!--- STOCKS.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.product_name#%"> AND --->
			PRICE_STANDART.PRICESTANDART_STATUS = 1	AND
			PRICE_STANDART.PURCHASESALES = 1 AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID	
		ORDER BY
			PRODUCT.PRODUCT_NAME
	</cfquery>
	<cfreturn get_product_objects2>
</cffunction>

