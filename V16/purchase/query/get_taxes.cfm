<cfquery name="GET_TAXES" datasource="#dsn2#">
	SELECT
		*
	FROM
		SETUP_TAX
	ORDER BY
		TAX
</cfquery>
