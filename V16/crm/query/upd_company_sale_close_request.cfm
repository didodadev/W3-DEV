<cflock timeout="60">
	<cftransaction>
		<cfquery name="ADD_SALE_REQUEST" datasource="#DSN#">
			UPDATE
				COMPANY_SALE_CLOSE_REQUEST
			SET
				COMPANY_ID = #attributes.cpid#,
				BRANCH_ID = #attributes.branch_id#,
				PROCESS_CAT = #attributes.process_stage#,
				DETAIL = '#attributes.detail#',
				RECORD_DATE = #now()#,
				RECORD_EMP = #session.ep.userid#,
				RECORD_IP = '#cgi.REMOTE_ADDR#',
				IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>
			WHERE
				SALE_CLOSE_REQUEST_ID = #attributes.SALE_REQUEST_ID#
		</cfquery>
		<cfquery name="ADD_NOTE" datasource="#DSN#">
			INSERT INTO 
				NOTES
			(
				ACTION_SECTION,
				ACTION_ID,
				NOTE_HEAD,
				NOTE_BODY,
				IS_SPECIAL,
				IS_WARNING,
				COMPANY_ID,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				'SALE_CLOSE_REQUEST_ID',
				 #attributes.SALE_REQUEST_ID#,
				'#left(attributes.detail,75)#',
				'#attributes.detail#',
				 0,
				 0,
				 #session.ep.company_id#,
				 #session.ep.userid#,
				 #now()#,
				'#cgi.remote_addr#'
			)
		</cfquery>
		<cf_workcube_process 
			is_upd='1' 
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_page='#request.self#?fuseaction=crm.detail_company&cpid=#attributes.cpid#&is_open_request=4&action_id=#attributes.SALE_REQUEST_ID#' 
			action_id='#attributes.SALE_REQUEST_ID#'
			old_process_line='#attributes.old_process_line#'
			warning_description = 'Satışa Kapama Talebi : #attributes.fullname#'>
	</cftransaction>
</cflock>
<script type="text/javascript">
	location.href = document.referrer;
</script>
