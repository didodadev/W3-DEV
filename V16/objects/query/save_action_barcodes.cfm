<cfsetting showdebugoutput="no">
<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<cfscript>
	CRLF = Chr(13) & Chr(10);
</cfscript>
<cfquery name="GET_PRODUCT_IDS" datasource="#DSN3#">
	SELECT DISTINCT 
		CPP.PRODUCT_ID,
		P.PRODUCT_NAME,
		GSB.BARCODE
	FROM 
		CATALOG_PROMOTION_PRODUCTS CPP,
		PRODUCT P,
		GET_STOCK_BARCODES GSB
	WHERE
		ISNUMERIC(GSB.BARCODE) = 1 AND
		<cfif isDefined("attributes.x_active_for_barcode_file") and attributes.x_active_for_barcode_file eq 1>
			P.PRODUCT_STATUS = 1 AND
		</cfif>
		CPP.CATALOG_ID = #attributes.catalog_id# AND
		P.PRODUCT_ID = CPP.PRODUCT_ID AND
		GSB.PRODUCT_ID = P.PRODUCT_ID
</cfquery>

<cfheader name="Expires" value="#Now()#">
<cfcontent type="text/plain;charset=utf-8">
<cfheader name="Content-Disposition" value="attachment; filename=aksiyon">
<cfoutput query="get_product_ids">#barcode#,1,#product_name##CRLF#</cfoutput>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
