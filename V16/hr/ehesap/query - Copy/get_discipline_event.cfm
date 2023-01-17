<cfquery datasource="#DSN#" name="get_event">
	SELECT
		*
	FROM
		EMPLOYEES_EVENT_REPORT
	WHERE
		EVENT_ID=#attributes.event_id#
</cfquery>

