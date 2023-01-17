<cfquery name="get_rec" datasource="#DSN#">
	SELECT
		PRO_CURRENCY_ID
	FROM
		PRO_PROJECTS
	WHERE
		PRO_CURRENCY_ID=#URL.ID#
</cfquery>

