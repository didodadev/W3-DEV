<cf_date tarih = "attributes.valid_date">
<cflock timeout="60">
	<cftransaction>
		<cfquery name="GET_COMPANY_RISK" datasource="#DSN#" result="MAX_ID">
			INSERT INTO
				COMPANY_RISK_REQUEST
			(
				COMPANY_ID,
				BRANCH_ID,
				PROCESS_CAT,
				RISK_TOTAL,
				RISK_MONEY_CURRENCY,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				DETAIL,
				VALID_DATE,
				IS_RUN,
				IS_MULTI,
				IS_ACTIVE
			)
			VALUES
			(
				#attributes.cpid#,
				#attributes.branch_id#,
				#attributes.process_stage#,
				#attributes.risk_total#,
				'#attributes.money_type#',
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#',
				'#attributes.detail#',
				<cfif len(attributes.valid_date)>#attributes.valid_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.valid_date)>0<cfelse>NULL</cfif>,
				0,
				<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>
			)
		</cfquery>
		<cfset request_id = MAX_ID.IDENTITYCOL>
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
				'REQUEST_ID',
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
	action_page='#request.self#?fuseaction=crm.detail_company&cpid=#attributes.cpid#&is_open_request=1&action_id=#MAX_ID.IDENTITYCOL#' 
	action_id='#MAX_ID.IDENTITYCOL#'
	warning_description = 'Risk Talebi : #attributes.fullname#'>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=crm.list_risk_request&event=upd&request_id=#request_id#</cfoutput>"
</script>

