<cfquery name="get_product_ids" datasource="#dsn3#">
	SELECT DISTINCT 
		CPP.PRODUCT_ID,
		P.PRODUCT_NAME,
		GSB.BARCODE
	FROM 
		CATALOG_PROMOTION_PRODUCTS CPP,
		PRODUCT P,
		GET_STOCK_BARCODES GSB
	WHERE 
		CPP.CATALOG_ID IN (SELECT CATALOG_ID FROM CATALOG_PROMOTION WHERE CAMP_ID = #attributes.CAMP_ID# AND IS_APPLIED = 1)	
		AND
		P.PRODUCT_ID = CPP.PRODUCT_ID
		AND
		GSB.PRODUCT_ID = P.PRODUCT_ID
</cfquery>
<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<cfscript>
CRLF = Chr(13) & Chr(10);
</cfscript>
<cfheader name="Expires" value="#Now()#">
<cfcontent type="text/plain;charset=utf-8">
<cfheader name="Content-Disposition" value="attachment; filename=sube">
<cfoutput query="get_product_ids">#barcode#,1,#PRODUCT_NAME##CRLF#</cfoutput>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
