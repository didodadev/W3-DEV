<cfquery name="GET_BRAND_NAME" datasource="#DSN3#">
	SELECT 
		BRAND_NAME	
	FROM
		PRODUCT_BRANDS
	WHERE
		BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
</cfquery>
