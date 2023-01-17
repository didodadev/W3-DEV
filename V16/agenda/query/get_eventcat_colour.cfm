<cfquery name="get_eventcat_colour" datasource="#dsn#">
	SELECT
		COLOUR
	FROM
		EVENT_CAT
	WHERE
		EVENTCAT = '#attributes.EVENTCAT#'
</cfquery>
