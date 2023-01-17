<cfquery name="GET_BRAND" datasource="#DSN#">
	SELECT 
		BRAND_ID,
		BRAND_NAME
	FROM
		SETUP_BRAND
	ORDER BY
		BRAND_NAME
</cfquery>
