<cfquery name="GET_SCHEDULED_REPORT" datasource="#DSN#">
	SELECT 
		*
	FROM 
		SCHEDULED_REPORTS
	WHERE
		REPORT_ID = #attributes.report_id#
</cfquery>
