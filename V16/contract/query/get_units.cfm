<cfquery name="GET_UNITS" datasource="#DSN#">
	SELECT 
		UNIT_ID,UNIT 
	FROM 
		SETUP_UNIT 
	ORDER BY
		UNIT 
</cfquery>
