<cfquery name="GET_SUPPORTS" datasource="#DSN#">
	SELECT
		SUPPORT_CAT_ID,
		SUPPORT_CAT
	FROM
		SETUP_SUPPORT
	ORDER BY
		SUPPORT_CAT
</cfquery>