<cfquery name="GET_ZONE" datasource="#DSN#">
	SELECT
		ZONE_ID,
		ZONE_NAME
	FROM
		ZONE
	ORDER BY
		ZONE_NAME
</cfquery>

