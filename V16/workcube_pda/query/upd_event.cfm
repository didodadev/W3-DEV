<cf_date tarih='attributes.startdate'>
<cf_date tarih='attributes.finishdate'>
<cfscript>
	attributes.startdate = date_add("h",attributes.event_start_clock - session.pda.time_zone,attributes.startdate);
	attributes.startdate = date_add("n",attributes.event_start_minute,attributes.startdate);
	attributes.finishdate = date_add("h",attributes.event_finish_clock - session.pda.time_zone,attributes.finishdate);
	attributes.finishdate = date_add("n",attributes.event_finish_minute,attributes.finishdate);
</cfscript>
<cfquery name="ADD_EVENT" datasource="#DSN#">
	UPDATE 
		EVENT
	SET
		EVENT_TO_POS = <cfif isdefined('attributes.to_emp_ids') and len(attributes.to_emp_ids)>',#attributes.to_emp_ids#,'<cfelse>NULL</cfif>,
		EVENT_TO_PAR = <cfif isdefined('attributes.to_par_ids') and len(attributes.to_par_ids)>',#attributes.to_par_ids#,',<cfelse>NULL,</cfif>
		EVENT_TO_CON = <cfif isdefined('attributes.to_cons_ids') and len(attributes.to_cons_ids)>',#attributes.to_cons_ids#,',<cfelse>NULL,</cfif>
		EVENT_CC_POS = <cfif isdefined('attributes.cc_emp_ids') and len(attributes.cc_emp_ids)>',#attributes.cc_emp_ids#,',<cfelse>NULL,</cfif>
		EVENT_CC_PAR = <cfif isdefined('attributes.cc_par_ids') and len(attributes.cc_par_ids)>',#attributes.cc_par_ids#,',<cfelse>NULL,</cfif>
		EVENT_CC_CON = <cfif isdefined('attributes.cc_cons_ids') and len(attributes.cc_cons_ids)>',#attributes.cc_cons_ids#,',<cfelse>NULL,</cfif>
		EVENTCAT_ID = #attributes.eventcat_id#, 
		STARTDATE = #attributes.startdate#, 
		FINISHDATE = #attributes.finishdate#, 
		EVENT_HEAD = '#attributes.event_head#', 
		EVENT_DETAIL = '#attributes.event_detail#', 		
		UPDATE_EMP = #session.pda.userid#,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		VIEW_TO_ALL = <cfif isdefined('attributes.view_to_all')>1<cfelse>NULL</cfif>
	WHERE
		EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
</cfquery>
<cflocation url="#request.self#?fuseaction=pda.form_upd_event&event_id=#attributes.event_id#&reserv=1" addtoken="no">
