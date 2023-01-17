<cfquery name="GET_PRODUCT_BRAND" datasource="#DSN1_alias#">
	SELECT 
		PRODUCT_BRANDS.BRAND_NAME
	FROM
		PRODUCT_BRANDS
	WHERE
		PRODUCT_BRANDS.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
</cfquery>

