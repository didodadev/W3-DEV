<cfquery name="GET_USAGE_PURPOSE" datasource="#dsn#">
	SELECT 
		USAGE_PURPOSE_ID, 
		USAGE_PURPOSE 
	FROM 
		SETUP_USAGE_PURPOSE
	ORDER BY 
		USAGE_PURPOSE
</cfquery>
