<cfquery name="GET_PROCESS_CATS" datasource="#dsn3#">
	SELECT 
		*
	FROM 
		SETUP_PROCESS_CAT
	ORDER BY
		PROCESS_CAT
</cfquery>
