<cfquery name="GET_FUEL_TYPE" datasource="#DSN#">
	SELECT
		FUEL_ID,
		FUEL_NAME
	FROM
		SETUP_FUEL_TYPE
	ORDER BY
		FUEL_ID
</cfquery> 
