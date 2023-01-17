<cfquery name="GET_UNITS" datasource="#dsn#">
	SELECT 
		UNIT,
		UNIT_ID 
	FROM 
		SETUP_UNIT
	ORDER BY
		UNIT
</cfquery>
