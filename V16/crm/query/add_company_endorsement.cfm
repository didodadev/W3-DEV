<cflock timeout="60">
	<cftransaction>
		<cfquery name="add_company_quess_endorsement" datasource="#DSN#" result="MAX_ID">
			INSERT INTO
				COMPANY_GUESS_ENDORSEMENT
			(
				COMPANY_ID,
				PROCESS_CAT,
				GUESS_ENDORSEMENT_TOTAL,
				GUESS_ENDORSEMENT_MONEY_CURRENCY,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				DETAIL,
				IS_ACTIVE
			)
			VALUES
			(
				#attributes.cpid#,
				#attributes.process_stage#,
				#attributes.endorsement_total#,
				'#attributes.money_type#',
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#',
				'#attributes.detail#',
				<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>
			)
		</cfquery>
		<!--- Musterinin tahmini cirosunu gunceller --->
		<cfquery name="upd_company_detail_endorsement" datasource="#dsn#">
			UPDATE
				COMPANY
			SET
				GUESS_ENDORSEMENT = #attributes.endorsement_total#,
				GUESS_ENDORSEMENT_MONEY = '#attributes.money_type#'
			WHERE
				COMPANY_ID = #attributes.cpid#
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
				'GUESS_ENDORSEMENT_ID',
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
	warning_description = 'Tahmini Ciro Talebi : #attributes.fullname#'>
<script type="text/javascript">
	wrk_opener_reload(); 
	self.close();
</script>
