<cfquery name="GET_LANGUAGES" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_LANGUAGE
	ORDER BY
		LANGUAGE_ID
</cfquery>
