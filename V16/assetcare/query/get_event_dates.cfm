<cfif isDefined("attributes.EVENT_ID") AND attributes.EVENT_ID neq 0>
<cfquery name="EVENT_DATES" datasource="#dsn#">
	SELECT
		STARTDATE,
		FINISHDATE
	FROM
		EVENT
	WHERE
		EVENT_ID = #attributes.EVENT_ID#
</cfquery>
</cfif>
