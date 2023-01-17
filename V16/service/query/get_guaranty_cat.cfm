<cfquery name="GET_GUARANTY_CAT" datasource="#DSN#">
	SELECT 
		*
	FROM 
		SETUP_GUARANTY
	ORDER BY
		GUARANTYCAT
</cfquery>
