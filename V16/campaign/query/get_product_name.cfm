<cfquery name="PRODUCT_NAME" datasource="#dsn3#">
	SELECT
		STOCKS.STOCK_ID,
		STOCKS.PRODUCT_ID,
		PRODUCT.PRODUCT_NAME,
		STOCKS.PROPERTY
	FROM
		PRODUCT,
		PRODUCT_CAT,
		STOCKS
	WHERE
		STOCK_ID = #attributes.STOCK_ID#
</cfquery>	
	

