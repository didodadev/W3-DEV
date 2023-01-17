<cfquery name="GET_EVENT" datasource="#DSN#">
	SELECT 
		EVENT_ID,
		STARTDATE,
		FINISHDATE,
		LINK_ID,
		EVENT_HEAD,
		EVENTCAT_ID,
		EVENT_DETAIL,
		VIEW_TO_ALL,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_DATE,
		UPDATE_EMP		
	FROM 
		EVENT
	WHERE 
		EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#"> 
		<cfif isdefined('session.pda.agenda_view_only_owned_agenda')>
			AND EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pda.userid#,%">
		</cfif>
</cfquery>

