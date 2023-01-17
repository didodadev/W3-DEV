<cfquery name="GET_GRPS" datasource="#DSN#">
	SELECT GROUP_ID FROM USERS WHERE POSITIONS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pda.userid#,%">
</cfquery>
<cfquery name="GET_WRKGROUPS" datasource="#DSN#">
	SELECT WORKGROUP_ID FROM WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#">	
</cfquery>
<cfscript>
	grps = valuelist(get_grps.group_id);
	wrkgroups = valuelist(get_wrkgroups.workgroup_id);
</cfscript>
<cfquery name="GET_DAILY_EVENTS" datasource="#DSN#">
	SELECT DISTINCT
		EVENT_ID,
		STARTDATE,
		FINISHDATE,
		EVENTCAT,
		VALID,
		RECORD_PAR,
		UPDATE_PAR,
		EVENT_HEAD
	FROM 
		EVENT,
		EVENT_CAT
	WHERE
		EVENT.EVENTCAT_ID = EVENT_CAT.EVENTCAT_ID AND
		(
			( STARTDATE >= #attributes.to_day# AND STARTDATE < #DATEADD('D',1,attributes.to_day)# )
		OR
			( FINISHDATE >= #attributes.to_day# AND FINISHDATE < #DATEADD('D',1,attributes.to_day)# )
		) 
		<cfif isdefined('session.pda.agenda_event_cat_id') and len(session.pda.agenda_event_cat_id)>
			AND	EVENT_CAT.EVENTCAT_ID IN (#session.pda.agenda_event_cat_id#)
		</cfif>
		<cfif isdefined('session.pda.agenda_view_only_owned_agenda') and len(session.pda.agenda_view_only_owned_agenda)>
            AND 
            (
                EVENT.EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pda.userid#,%"> OR                			  EVENT.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#">
            )
		</cfif>		
</cfquery>
