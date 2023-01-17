<cfquery name="GET_IDENTYCARD_CAT" datasource="#DSN#">
	SELECT 
		IDENTYCAT_ID,
		IDENTYCAT
	FROM 
		SETUP_IDENTYCARD
</cfquery>
