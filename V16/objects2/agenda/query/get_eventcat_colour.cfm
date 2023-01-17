<cfquery name="GET_EVENTCAT_COLOUR" datasource="#DSN#">
	SELECT
		COLOUR
	FROM
		EVENT_CAT
	WHERE
		EVENTCAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.eventcat#">
</cfquery>
