<cf_date tarih='attributes.startdate'>
<cf_date tarih='attributes.finishdate'>
<cfscript>
	attributes.startdate = date_add("h",attributes.event_start_clock - session.pda.time_zone,attributes.startdate);
	attributes.startdate = date_add("n",attributes.event_start_minute,attributes.startdate);
	attributes.finishdate = date_add("h",attributes.event_finish_clock - session.pda.time_zone,attributes.finishdate);
	attributes.finishdate = date_add("n",attributes.event_finish_minute,attributes.finishdate);
</cfscript>
<cfquery name="ADD_EVENT" datasource="#DSN#" result="MAX_ID">
	INSERT INTO EVENT
	(
		EVENTCAT_ID, 
		STARTDATE, 
		FINISHDATE, 
		EVENT_HEAD, 
		EVENT_DETAIL, 		
		EVENT_TO_POS,
		EVENT_TO_PAR,
		EVENT_TO_CON,
		EVENT_CC_POS,
		EVENT_CC_PAR,
		EVENT_CC_CON,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
		<cfif isDefined("attributes.view_to_all")>
			,VIEW_TO_ALL
		</cfif>
	)
	VALUES
	(
		#attributes.eventcat_id#, 
		#attributes.startdate#, 
		#attributes.finishdate#, 
		'#attributes.event_head#', 
		'#attributes.event_detail#',
		<cfif isdefined('attributes.to_emp_ids') and len(attributes.to_emp_ids)>',#attributes.to_emp_ids#,',<cfelse>NULL,</cfif>
		<cfif isdefined('attributes.to_par_ids') and len(attributes.to_par_ids)>',#attributes.to_par_ids#,',<cfelse>NULL,</cfif>
		<cfif isdefined('attributes.to_cons_ids') and len(attributes.to_cons_ids)>',#attributes.to_cons_ids#,',<cfelse>NULL,</cfif>
		<cfif isdefined('attributes.cc_emp_ids') and len(attributes.cc_emp_ids)>',#attributes.cc_emp_ids#,',<cfelse>NULL,</cfif>
		<cfif isdefined('attributes.cc_par_ids') and len(attributes.cc_par_ids)>',#attributes.cc_par_ids#,',<cfelse>NULL,</cfif>
		<cfif isdefined('attributes.cc_cons_ids') and len(attributes.cc_cons_ids)>',#attributes.cc_cons_ids#,',<cfelse>NULL,</cfif>
		#session.pda.userid#,
		'#cgi.remote_addr#',
		#now()#
		<cfif isDefined("attributes.view_to_all")>
			,#attributes.view_to_all#
		</cfif>
	)
</cfquery>
<cfif isdefined("action_id") or isdefined("action_section")>
 	<cfquery name="INS_OFFER_PLUS" datasource="#DSN#">
		INSERT INTO
			EVENTS_RELATED
			(
				ACTION_ID,
				ACTION_SECTION,
				EVENT_ID,
				COMPANY_ID		
			)
			VALUES
			(
				#action_id#,
				'#action_section#',
				#MAX_ID.IDENTITYCOL#,
				#session.pda.our_company_id#		 
			)	
	</cfquery>
</cfif>

<cflocation url="#request.self#?fuseaction=pda.form_upd_event&event_id=#MAX_ID.IDENTITYCOL#&reserv=1" addtoken="no">
