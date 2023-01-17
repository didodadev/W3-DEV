<cfset attributes.BARCODE=TRIM(barcode_no)>
<cfquery name="GET_MAX_STCK" datasource="#dsn1#">
	SELECT MAX(STOCK_ID) AS MAX_STCK FROM STOCKS
</cfquery>

<cfquery name="GET_MAX_UNIT" datasource="#dsn1#">
	SELECT MAX(PRODUCT_UNIT_ID) AS MAX_UNIT FROM PRODUCT_UNIT
</cfquery>
<cfquery name="ADD_STOCK_CODE" datasource="#dsn1#">
	INSERT INTO 
		STOCKS_BARCODES
		(
			STOCK_ID,
			BARCODE,
			UNIT_ID
		)
	VALUES 
		(
			#GET_MAX_STCK.MAX_STCK#,
			'#attributes.BARCODE#',
			#GET_MAX_UNIT.MAX_UNIT#
		)
</cfquery>
