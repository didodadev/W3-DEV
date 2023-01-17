<cfquery name="GET_UNIT" datasource="#DSN#">
	SELECT 
		UNIT,
		UNIT_ID 
	FROM 
		SETUP_UNIT
	ORDER BY 
		UNIT
</cfquery>
