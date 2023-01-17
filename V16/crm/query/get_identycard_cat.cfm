<cfquery name="GET_IDENTYCARD_CAT" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_IDENTYCARD
	ORDER BY
		IDENTYCAT
</cfquery>
