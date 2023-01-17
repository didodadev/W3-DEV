<cfquery name="GET_PRIORITY" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_PRIORITY
	ORDER BY
		PRIORITY
</cfquery>
