<cf_date tarih = "attributes.valid_date">
<cflock timeout="60">
	<cftransaction>
		<cfquery name="GET_COMPANY_RISK" datasource="#DSN#">
			UPDATE
				COMPANY_RISK_REQUEST
			SET
				COMPANY_ID = #attributes.cpid#,
				BRANCH_ID = #attributes.branch_id#,
				PROCESS_CAT = #attributes.process_stage#,
				RISK_TOTAL = #attributes.risk_total#,
				RISK_MONEY_CURRENCY = '#attributes.money_type#',
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#',
				DETAIL = '#attributes.detail#',
				VALID_DATE = <cfif len(attributes.valid_date)>#attributes.valid_date#<cfelse>NULL</cfif>,
				IS_RUN = <cfif len(attributes.valid_date)>0<cfelse>NULL</cfif>,
				IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>
			WHERE
				REQUEST_ID = #attributes.request_id#
		</cfquery>
		<cfset request_id = attributes.request_id>
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
				 #attributes.request_id#,
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
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_page='#request.self#?fuseaction=crm.detail_company&cpid=#attributes.cpid#&is_open_request=1&action_id=#attributes.request_id#' 
		action_id='#attributes.request_id#'
		old_process_line='#attributes.old_process_line#'
		warning_description = 'Risk Talebi : #attributes.fullname#'>	
<script type="text/javascript">
	location.href = document.referrer;
</script>
