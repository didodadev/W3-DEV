<cfquery name="GET_BRAND_NAME" datasource="#dsn3#">
	SELECT 
		BRAND_NAME
	FROM 
		PRODUCT_BRANDS
	WHERE
		BRAND_ID = #BRAND_ID#
</cfquery>
