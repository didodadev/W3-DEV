<cfquery name="del_events" datasource="#dsn#">
	DELETE FROM EVENTS_RELATED WHERE RELATED_ID = #attributes.related_id#
</cfquery>

