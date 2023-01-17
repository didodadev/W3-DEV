<cfquery name="GET_STOCK" datasource="#DSN3#">
	SELECT
		STOCK_ID
	FROM
		STOCKS
	WHERE
		PRODUCT_ID = #attributes.pid# AND
		BARCOD = '#get_product.barcod#'
</cfquery>
