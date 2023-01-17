<cfquery name="GET_MOBILCAT" datasource="#dsn#">
	SELECT
		MOBILCAT_ID, MOBILCAT
	FROM
		SETUP_MOBILCAT
	ORDER BY
		MOBILCAT  ASC
</cfquery>
