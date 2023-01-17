<cfquery name="GET_BRAND_NAME" datasource="#DSN3#">
	SELECT 
		BRAND_NAME	
	FROM
		PRODUCT_BRANDS
	WHERE
		BRAND_ID = #attributes.brand_id#
</cfquery>
