<cfif isDefined("session.ep.company_id")>
	<cfset my_our_comp_ = session.ep.company_id>
<cfelseif isDefined('session.pp.our_company_id')>
	<cfset my_our_comp_ = session.pp.our_company_id>
<cfelseif isDefined('session.ww.our_company_id')>
	<cfset my_our_comp_ = session.ww.our_company_id>
</cfif>
<cfquery name="GET_PROCESS" datasource="#DSN#" maxrows="1">
	SELECT TOP 1
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_our_comp_#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%objects2.form_add_event%">
		<cfif isdefined("session.pp")>
			AND PTR.IS_PARTNER = 1
		<cfelse>
			AND PTR.IS_CONSUMER = 1
		</cfif>
	ORDER BY
		PTR.PROCESS_ROW_ID ASC
</cfquery>
<cfif not get_process.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='33.İşlem Tipleri Tanımlı Değil! Lütfen Müşteri Temsilcinize Başvurun'>.");
		history.back();
	</script>
	<cfabort>
</cfif>

<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_EVENT" datasource="#DSN#" result="MAX_ID">
			INSERT INTO 
				EVENT
				(
					EVENTCAT_ID,
					STARTDATE, 
					FINISHDATE, 
					EVENT_HEAD,
					EVENT_DETAIL,
					EVENT_STAGE,		
					WARNING_EMAIL, 
					<cfif isdefined("url.project_id")>PROJECT_ID,</cfif>
					<cfif isdefined('attributes.to_emp_ids') and len(attributes.to_emp_ids)>EVENT_TO_POS,</cfif>
					<cfif isdefined('attributes.to_par_ids') and len(attributes.to_par_ids)>EVENT_TO_PAR,</cfif>
					<cfif isdefined('attributes.to_cons_ids') and len(attributes.to_cons_ids)>EVENT_TO_CON,</cfif>
					<cfif isdefined('attributes.cc_emp_ids') and len(attributes.cc_emp_ids)>EVENT_CC_POS,</cfif>
					<cfif isdefined('attributes.cc_par_ids') and len(attributes.cc_par_ids)>EVENT_CC_PAR,</cfif>
					<cfif isdefined('attributes.cc_cons_ids') and len(attributes.cc_cons_ids)>EVENT_CC_CON,</cfif>
					<cfif isdefined('form.warning_start') and len(form.warning_start)>WARNING_START,</cfif>
					<cfif isDefined("form.view_to_all")>VIEW_TO_ALL,</cfif>
					<cfif isDefined("session.pp.userid")>RECORD_PAR,</cfif>
					<cfif isDefined("link_id")>LINK_ID,</cfif>
					RECORD_IP,
					RECORD_DATE
				)
				VALUES
				(
					#eventcat_id#, 
					#attributes.startdate#, 
					#attributes.finishdate#, 
					'#form.event_head#', 
					'#form.event_detail#',
					#attributes.process_stage#,
					#form.email_alert_day#, 
					<cfif isdefined("url.project_id")>#url.project_id#,</cfif>
					<cfif isdefined('attributes.to_emp_ids') and len(attributes.to_emp_ids)>',#attributes.to_emp_ids#,',</cfif>
					<cfif isdefined('attributes.to_par_ids') and len(attributes.to_par_ids)>',#attributes.to_par_ids#,',</cfif>
					<cfif isdefined('attributes.to_cons_ids') and  len(attributes.to_cons_ids)>',#attributes.to_cons_ids#,',</cfif>
					<cfif isdefined('attributes.cc_emp_ids') and len(attributes.cc_emp_ids)>',#attributes.cc_emp_ids#,',</cfif>
					<cfif isdefined('attributes.cc_par_ids') and len(attributes.cc_par_ids)>',#attributes.cc_par_ids#,',</cfif>
					<cfif isdefined('attributes.cc_cons_ids') and len(attributes.cc_cons_ids)>',#attributes.cc_cons_ids#,',</cfif>
					<cfif isdefined('form.warning_start') and len(form.warning_start)>#form.warning_start#,</cfif>
					<cfif isDefined("form.view_to_all")>#form.view_to_all#,</cfif>
					<cfif isdefined("session.pp.userid")>#session.pp.userid#,</cfif>
					<cfif isdefined("link_id")>#link_id#,</cfif>
					'#cgi.remote_addr#',
					#now()#
				)
		</cfquery>
	</cftransaction>
</cflock>
<cfif isdefined("attributes.action_id") or isdefined("attributes.action_section")>
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
				#attributes.action_id#,
				'#attributes.action_section#',
				#max_id.identitycol#,
				<cfif isdefined("session.ep.company_id")>
					#session.ep.company_id#
				<cfelseif isDefined('session.pp.our_company_id')>
					#session.pp.our_company_id#
                <cfelseif isDefined('session.ww.our_company_id')>
					#session.ww.our_company_id#
				</cfif>
			)	
	</cfquery>
	<script type="text/javascript">
		 wrk_opener_reload();
		 window.close();
	</script>
</cfif>
<cfif isDefined('session.pp.userid')>
	<cflocation url="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(max_id.identitycol,session.pp.userid,"CFMX_COMPAT","Hex")#&company_id=#attributes.company_id#" addtoken="no">
<cfelseif isDefined('session.ww.userid')>
	<cflocation url="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(max_id.identitycol,session.ww.userid,"CFMX_COMPAT","Hex")#" addtoken="no">
</cfif>
