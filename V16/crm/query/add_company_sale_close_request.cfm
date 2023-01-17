<cflock timeout="60">
	<cftransaction>
		<cfquery name="ADD_SALE_REQUEST" datasource="#dsn#" result="MAX_ID">
			INSERT INTO
				COMPANY_SALE_CLOSE_REQUEST
			(
				COMPANY_ID,
				BRANCH_ID,
				PROCESS_CAT,
				DETAIL,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				IS_ACTIVE
			)
			VALUES
			(
				#attributes.cpid#,
				#attributes.branch_id#,
				#attributes.process_stage#,
				'#attributes.detail#',
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#',
				<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>
			)
		</cfquery>
		<cfset sale_request_id = MAX_ID.IDENTITYCOL>
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
				'#ucase('SALE_CLOSE_REQUEST_ID')#',
				 #MAX_ID.IDENTITYCOL#,
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
	</cftransaction>
</cflock>		
<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_page='#request.self#?fuseaction=crm.detail_company&cpid=#attributes.cpid#&is_open_request=4&action_id=#MAX_ID.IDENTITYCOL#' 
	action_id='#MAX_ID.IDENTITYCOL#'
	warning_description = 'Satışa Kapama Talebi : #attributes.fullname#'>
<script type="text/javascript">
	location.href = "<cfoutput>#request.self#?fuseaction=crm.list_sales_close_request&event=upd&sale_request_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
</script>
