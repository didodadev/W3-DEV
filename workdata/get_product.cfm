<!--- 
	amac            : PRODUCT_NAME vererek PRODUCT_ID,PRODUCT_NAME bilgisini getirmek
	parametre adi   : product_name
	ayirma isareti  : YOK
	kullanim        : get_product('Bil') 
	Yazan           : Sevda Mersin
	Tarih           : 01.11.2007
 --->
<cffunction name="get_product" access="public" returntype="query" output="no">
	<cfargument name="product_name" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="-1">
	<cfargument name="is_store_module" required="no" type="numeric">
	<cfquery name="GET_PRODUCT" datasource="#DSN3#">
		SELECT
			STOCKS.TAX,
			STOCKS.STOCK_CODE,
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.PRODUCT_NAME,
			STOCKS.IS_SERIAL_NO,
			PRODUCT_UNIT.MAIN_UNIT,
            PRODUCT_CAT.PRODUCT_CATID,
            PRODUCT.PRODUCT_CODE
		FROM
			PRODUCT_CAT,
			STOCKS,
			PRODUCT_UNIT,
			PRODUCT
		WHERE
			PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			STOCKS.PRODUCT_STATUS = 1 AND
			STOCKS.STOCK_STATUS = 1 AND
			STOCKS.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID AND
			PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			PRODUCT_UNIT.IS_MAIN = 1 AND
			(
            	STOCKS.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.product_name#%"> OR
            	STOCKS.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.product_name#%">
            )
			<cfif arguments.is_store_module eq 1>
				AND PRODUCT.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #dsn1_alias#.PRODUCT_BRANCH WHERE BRANCH_ID IN(SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">))
			</cfif>
		ORDER BY
			STOCKS.PRODUCT_NAME
	</cfquery>
	<cfreturn get_product>
</cffunction>

