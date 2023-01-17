<cfquery name="PRODUCT_NAME" datasource="#DSN3#">
	SELECT
		STOCKS.STOCK_ID,
		STOCKS.PRODUCT_ID,
		PRODUCT.PRODUCT_NAME,
		STOCKS.PROPERTY,
		STOCKS.STOCK_CODE,
		STOCKS.BARCOD,
		PRODUCT.IS_TERAZI,
		PRODUCT.MANUFACT_CODE,
		PRODUCT.PRODUCT_CODE_2,
		PRODUCT.SHELF_LIFE
	FROM
		PRODUCT,
		STOCKS
	WHERE
		STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
		STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
		<cfif isdefined("kontrol_seri_no")>
			AND STOCKS.IS_SERIAL_NO = 1
		</cfif>
</cfquery>