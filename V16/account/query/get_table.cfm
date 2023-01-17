<cfquery name="GET_TABLE" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_PERIOD
	WHERE
		PERIOD_YEAR =#gecensene#
</cfquery>
