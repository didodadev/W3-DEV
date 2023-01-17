<cf_date tarih='form.startdate'>
<cf_date tarih='form.finishdate'>

<cfquery name="UPD_EVENT" datasource="#DSN#">
	UPDATE 
		EVENT 
	SET 
		EVENT_TO_POS = <cfif isdefined('attributes.to_emp_ids') and len(attributes.to_emp_ids)>',#attributes.to_emp_ids#,'<cfelse>NULL</cfif>,
		EVENT_TO_PAR = <cfif isdefined('attributes.to_par_ids') and len(attributes.to_par_ids)>',#attributes.to_par_ids#,',<cfelse>NULL,</cfif>
		EVENT_TO_CON = <cfif isdefined('attributes.to_cons_ids') and len(attributes.to_cons_ids)>',#attributes.to_cons_ids#,',<cfelse>NULL,</cfif>
		EVENT_CC_POS = <cfif isdefined('attributes.cc_emp_ids') and len(attributes.cc_emp_ids)>',#attributes.cc_emp_ids#,',<cfelse>NULL,</cfif>
		EVENT_CC_PAR = <cfif isdefined('attributes.cc_par_ids') and len(attributes.cc_par_ids)>',#attributes.cc_par_ids#,',<cfelse>NULL,</cfif>
		EVENT_CC_CON = <cfif isdefined('attributes.cc_cons_ids') and len(attributes.cc_cons_ids)>',#attributes.cc_cons_ids#,',<cfelse>NULL,</cfif>
		VIEW_TO_ALL = <cfif isDefined("form.view_to_all") and len(form.view_to_all)>1,<cfelse>0,</cfif>
		WARNING_START= <cfif len(form.warning_start)>#form.warning_start#,<cfelse>NULL,</cfif>
		LINK_ID = <cfif not len(link_id)>null,<cfelse>#link_id#,</cfif>
		STARTDATE = #attributes.startdate#, 
		FINISHDATE = #attributes.finishdate#, 
		WARNING_EMAIL = #form.email_alert_day#, 
		EVENTCAT_ID = #form.eventcat_id#, 
		EVENT_HEAD = '#form.event_head#',
		EVENT_STAGE = #attributes.process_stage#, 
		EVENT_DETAIL = '#form.event_detail#',
		<cfif isDefined("session.pp.userid")>
			UPDATE_PAR = #session.pp.userid#,
		</cfif>
		UPDATE_DATE = #now()#, 
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
		EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.event_id#">
</cfquery>

<cflocation url="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(attributes.event_id,session.pp.userid,"CFMX_COMPAT","Hex")#&company_id=#attributes.company_id#" addtoken="no">


