<!---
	Autocomplate için yapıldı aranan kritere uygun tüm aktif ürünleri getirir
--->
<cffunction name="get_product_autocomplete" access="public" returnType="query" output="no">
	<cfargument name="product_name" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="">
	<cfargument name="is_store_module" required="no" type="numeric">
	<cfargument name="is_stock_code" required="no" type="numeric">
    <cfargument name="price_cat_id" required="no" type="numeric">
	<cfif len(arguments.maxrows)>
		<cfquery name="get_product" datasource="#dsn3#" maxrows="#arguments.maxrows#">
			SELECT
				STOCKS.TAX,
				STOCKS.STOCK_ID,
				STOCKS.PRODUCT_ID,
				STOCKS.PRODUCT_NAME,
				STOCKS.PROPERTY,
				STOCKS.STOCK_CODE,
				STOCKS.STOCK_CODE_2,
				STOCKS.PRODUCT_CODE_2,
                PRODUCT_UNIT.PRODUCT_UNIT_ID,
				PRODUCT_UNIT.MAIN_UNIT,
				(SELECT TOP 1 ROUND(ISNULL(PC.PURCHASE_NET_SYSTEM,0)+ISNULL(PC.PURCHASE_EXTRA_COST_SYSTEM,0),4) FROM PRODUCT_COST PC WHERE PC.PRODUCT_ID = STOCKS.PRODUCT_ID ORDER BY PC.START_DATE DESC,PC.RECORD_DATE DESC) AS PRODUCT_COST,
       			PRODUCT_CAT.PROFIT_MARGIN,
          		PRODUCT_CAT.PRODUCT_CATID,
                <cfif isdefined("arguments.price_cat_id") and arguments.price_cat_id eq "-2">
                        PRICE_STANDART.PRICE,
                        PRICE_STANDART.PRICE_KDV,
                        PRICE_STANDART.IS_KDV,
                        PRICE_STANDART.MONEY,
                        SETUP_MONEY.MONEY + ';' + CONVERT(VARCHAR(100),SETUP_MONEY.RATE1) + ';' + CONVERT(VARCHAR(100),SETUP_MONEY.RATE2) AS RATE2,
                    </cfif>
                PRODUCT_CAT.PRODUCT_CATID
			FROM
				PRODUCT_CAT,
				STOCKS,
				PRODUCT_UNIT,
				PRODUCT
                <cfif isdefined("arguments.price_cat_id") and arguments.price_cat_id eq "-2">
                    ,PRICE_STANDART
                    ,#DSN_ALIAS#.SETUP_MONEY
                </cfif>
			WHERE
				PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
				STOCKS.PRODUCT_STATUS = 1 AND
				STOCKS.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID AND
				PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
				PRODUCT_UNIT.IS_MAIN = 1 AND
                <cfif isdefined("arguments.price_cat_id") and arguments.price_cat_id eq "-2">
                    PRICE_STANDART.PRICESTANDART_STATUS = 1	AND
                    PRICE_STANDART.PURCHASESALES = 1 AND
                    PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND
                    SETUP_MONEY.MONEY = PRICE_STANDART.MONEY AND
                    PERIOD_ID = #session.ep.period_id# AND 
                    MONEY_STATUS = 1 AND
                </cfif>
				<cfif not (isdefined('arguments.is_stock_code') and arguments.is_stock_code eq 1)>
				(
					STOCKS.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_name#%">
				OR
					STOCKS.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_name#%">
				OR
					STOCKS.STOCK_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_name#%">
				OR 
					PRODUCT.MANUFACT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_name#%">
				)
				<cfelse>
					STOCKS.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.product_name#%">
				</cfif>
				<cfif isdefined('arguments.is_store_module') and arguments.is_store_module eq 1>
					AND PRODUCT.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #dsn1_alias#.PRODUCT_BRANCH WHERE BRANCH_ID IN(SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#))
				</cfif>
			ORDER BY
				STOCKS.PRODUCT_NAME
		</cfquery>
	<cfelse>
		<cfquery name="get_product" datasource="#dsn3#">
			SELECT
				STOCKS.TAX,
				STOCKS.STOCK_ID,
				STOCKS.PRODUCT_ID,
				STOCKS.PRODUCT_NAME,
				STOCKS.PROPERTY,
				STOCKS.STOCK_CODE,
				STOCKS.STOCK_CODE_2,
                PRODUCT_UNIT.PRODUCT_UNIT_ID,
				PRODUCT_UNIT.MAIN_UNIT,
				(SELECT TOP 1 ROUND(ISNULL(PC.PURCHASE_NET_SYSTEM,0)+ISNULL(PC.PURCHASE_EXTRA_COST_SYSTEM,0),4) FROM PRODUCT_COST PC WHERE PC.PRODUCT_ID = STOCKS.PRODUCT_ID ORDER BY PC.START_DATE DESC,PC.RECORD_DATE DESC) AS PRODUCT_COST,
				PRODUCT_CAT.PROFIT_MARGIN
			FROM
				PRODUCT_CAT,
				STOCKS,
				PRODUCT_UNIT,
				PRODUCT
			WHERE
				PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
				STOCKS.PRODUCT_STATUS = 1 AND
				STOCKS.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID AND
				PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
				PRODUCT_UNIT.IS_MAIN = 1 AND
				<cfif not (isdefined('arguments.is_stock_code') and arguments.is_stock_code eq 1)>
				 (
					STOCKS.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_name#%">
				OR
					STOCKS.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_name#%">
				OR
					STOCKS.STOCK_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_name#%">
				OR
					PRODUCT.MANUFACT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_name#%">
				)
				<cfelse>
					STOCKS.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.product_name#%">
				</cfif>
				<cfif isdefined('arguments.is_store_module') and arguments.is_store_module eq 1>
					AND PRODUCT.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #dsn1_alias#.PRODUCT_BRANCH WHERE BRANCH_ID IN(SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#))
				</cfif>
			ORDER BY
				STOCKS.PRODUCT_NAME
		</cfquery>
	</cfif>
	<cfreturn get_product>
</cffunction>

