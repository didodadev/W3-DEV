<cfset attributes.BARCODE=TRIM(barcode_no)>
<cfquery name="GET_MAX_UNIT" datasource="#dsn3#">
	SELECT MAX(PRODUCT_UNIT_ID) AS MAX_UNIT FROM #dsn1_alias#.PRODUCT_UNIT
</cfquery>
<cfquery name="ADD_STOCK_CODE" datasource="#dsn3#">
	INSERT INTO 
		#dsn1_alias#.STOCKS_BARCODES
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
