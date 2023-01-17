<cfquery name="GET_SCHEDULES" datasource="#DSN#">
	SELECT 
		*
	FROM 
		SCHEDULE_SETTINGS		
	ORDER BY
		SCHEDULE_NAME
</cfquery>
