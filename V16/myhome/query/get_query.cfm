<cfquery name="get_query" datasource="#dsn#">
	SELECT
		*
	FROM
		REPORT
	WHERE
		REPORT_ID = #attributes.report_id#
</cfquery>

