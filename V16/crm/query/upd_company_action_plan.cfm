<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_NOTE" datasource="#DSN#">
			INSERT INTO 
				COMPANY_ACTION_PLAN_NOTES 
				(
					COMPANY_ID,
					BRANCH_ID,
					PROCESS_CAT_ID,
					SUBJECT,
					DETAIL,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP,
					RELATED_ACTION_ID
				) 
				VALUES 
				(
					#attributes.cpid#,
					#attributes.branch_id#,
					#attributes.process_stage#,
					'#attributes.subject#',
					'#attributes.detail#',
					#session.ep.userid#,
					#now()#,
					'#cgi.remote_addr#',
					#attributes.action_plan_id#
				)
		</cfquery>
		<cf_workcube_process 
			is_upd='1' 
			old_process_line='#attributes.old_process_line#'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_page='#request.self#?fuseaction=crm.detail_company&cpid=#attributes.cpid#' 
			action_id='#attributes.cpid#'
			warning_description = 'Eylem Planı : #attributes.detail#'>
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif isDefined("attributes.draggable") and attributes.draggable eq 1>
		location.href = document.referrer;
	<cfelse>
		window.close();
		wrk_opener_reload();
	</cfif>
</script>
