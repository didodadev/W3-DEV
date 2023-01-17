<cfset satir_borc_turu = "">
<cfset satir_borc_tutari = "">
<cfset satir_vade_tarihi = "">
<cflock timeout="60">
	<cftransaction>
		<cfquery name="upd_law_request" datasource="#dsn#">
			UPDATE
				COMPANY_LAW_REQUEST
			SET
				COMPANY_ID = #attributes.cpid#,
				BRANCH_ID = #attributes.branch_id#,
				PROCESS_CAT = #attributes.process_stage#,
				DETAIL = '#attributes.detail#',
				GUARANTOR_DETAIL = '#attributes.guarantor_detail#',
				MORTGAGE_DETAIL = '#attributes.mortgage_detail#',
				PAWN_DETAIL = '#attributes.pawn_detail#',
				PERFORM_PAY_NETTOTAL1 = #filternum(attributes.perform_pay_nettotal_1)#,
				PERFORM_PAY_NETTOTAL2 = #filternum(attributes.perform_pay_nettotal_2)#,
				IS_MUACCELLIYET = #attributes.is_muaccelliyet#,
				IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE
				LAW_REQUEST_ID = #attributes.law_request_id#
		</cfquery>
		
		<cfquery name="del_low_request_row" datasource="#dsn#">
			DELETE FROM COMPANY_LAW_REQUEST_ROW WHERE LAW_REQUEST_ID = #attributes.law_request_id#
		</cfquery>
		
		<cfloop from="1" to="2" index="x">
			<cfif evaluate('attributes.record_num#x#') gt 0>
			<cfloop from="1" to="#listlast(evaluate('attributes.record_num#x#'),'_')#" index="f">
				
				<cfif evaluate('attributes.row_kontrol#x#_#f#') gt 0>
					<cfset satir_borc_turu = evaluate('attributes.perform_type#x#_#f#')>
					<cfset satir_vade_tarihi = evaluate('attributes.perform_due_date#x#_#f#')>
					<cfset satir_borc_tutari = replace(replace(evaluate('attributes.perform_total#x#_#f#'),'.',''),',','.')>
					<cf_date tarih = 'satir_vade_tarihi'>
					
					<cfquery name="add_law_request_row" datasource="#dsn#">
						INSERT INTO
							COMPANY_LAW_REQUEST_ROW
							(
								LAW_REQUEST_ID,
								TYPE_ID,
								COMPANY_ID,
								PERFORM_TYPE,
								PERFORM_DUE_DATE,
								PERFORM_TOTAL,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
							)
							VALUES
							(
								#attributes.law_request_id#,
								#x#,
								#attributes.cpid#,
								#satir_borc_turu#,
								#satir_vade_tarihi#,
								#satir_borc_tutari#,
								#now()#,
								#session.ep.userid#,
								'#cgi.remote_addr#'
							)
					</cfquery>
				</cfif>
			</cfloop>
			</cfif>
		</cfloop>
		
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
					'LAW_REQUEST_ID',
					 #attributes.law_request_id#,
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
	action_page='#request.self#?fuseaction=crm.detail_company&cpid=#attributes.cpid#&is_open_request=2&action_id=#attributes.law_request_id#' 
	action_id='#attributes.law_request_id#'
	old_process_line='#attributes.old_process_line#'
	warning_description = 'Avukata Verme Talebi : #attributes.fullname#'>
<script type="text/javascript">
	wrk_opener_reload(); 
	self.close();
</script>	
