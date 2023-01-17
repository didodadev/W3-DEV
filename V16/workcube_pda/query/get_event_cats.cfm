<cfquery name="GET_EVENT_CATS" datasource="#DSN#">
	SELECT 
		EVENTCAT_ID, 
		EVENTCAT
	FROM 
		EVENT_CAT 
		<cfif isdefined('session.pda.agenda_event_cat_id') and len(session.pda.agenda_event_cat_id)>
			WHERE
				EVENTCAT_ID IN (#session.pda.agenda_event_cat_id#)
		</cfif>
	ORDER BY 
		EVENTCAT
</cfquery>
