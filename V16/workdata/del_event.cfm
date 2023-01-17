<cffunction name="del_event" access="public" returnType="boolean" output="no">
	<cfquery name="del_event_" datasource="#dsn#">
		DELETE FROM
			EVENT
		WHERE
			EVENT_ID = #attributes.id#
	</cfquery>
	<cfreturn true>
</cffunction>
