<cfquery name="GET_IT_CONCERN" datasource="#dsn#">
	SELECT
		CONCERN_ID,
		CONCERN_NAME
	FROM
		SETUP_IT_CONCERNED
	ORDER BY
		CONCERN_ID
</cfquery>

