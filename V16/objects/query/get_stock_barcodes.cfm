<cfquery name="GET_STOCKS_BARCODES" datasource="#dsn3#">
	SELECT 
		* 
	FROM 
		STOCKS_BARCODES 
	WHERE
		BARCODE = '#attributes.BARCODE#'
</cfquery>
