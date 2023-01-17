<cflock timeout="60">
	<cftransaction>
		<cfquery name="upd_company_endorsement" datasource="#DSN#">
			UPDATE
				COMPANY_GUESS_ENDORSEMENT
			SET
				COMPANY_ID = #attributes.cpid#,
				PROCESS_CAT = #attributes.process_stage#,
				GUESS_ENDORSEMENT_TOTAL = #attributes.endorsement_total#,
				GUESS_ENDORSEMENT_MONEY_CURRENCY = '#attributes.money_type#',
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#',
				DETAIL = '#attributes.detail#',
				IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>
			WHERE
				GUESS_ENDORSEMENT_ID = #attributes.endorsement_id#
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
		<cfquery name="add_note" datasource="#DSN#">
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
				 #attributes.endorsement_id#,
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
	action_page='#request.self#?fuseaction=crm.detail_company&cpid=#attributes.cpid#&is_open_request=1&action_id=#attributes.endorsement_id#' 
	action_id='#attributes.endorsement_id#'
	old_process_line='#attributes.old_process_line#'
	warning_description = 'Tahmini Ciro Talebi : #attributes.fullname#'>
<script type="text/javascript">
	wrk_opener_reload(); 
	self.close();
</script>
