<cfset satir_borc_turu = "">
<cfset satir_borc_tutari = "">
<cfset satir_vade_tarihi = "">
<cflock timeout="60">
	<cftransaction>
		<cfquery name="add_company_saw_request" datasource="#dsn#" result="MAX_ID">
			INSERT INTO
				COMPANY_LAW_REQUEST
			(
				COMPANY_ID,
				BRANCH_ID,
				RELATED_ID,
				PROCESS_CAT,
				DETAIL,
				GUARANTOR_DETAIL,
				MORTGAGE_DETAIL,
				PAWN_DETAIL,
				PERFORM_PAY_NETTOTAL1,
				PERFORM_PAY_NETTOTAL2,
				IS_MUACCELLIYET,
				IS_ACTIVE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				#attributes.cpid#,
				#listfirst(attributes.branch_id,'-')#,
				#listlast(attributes.branch_id,'-')#,
				#attributes.process_stage#,
				'#attributes.detail#',
				'#attributes.guarantor_detail#',
				'#attributes.mortgage_detail#',
				'#attributes.pawn_detail#',
				#filterNum(attributes.perform_pay_nettotal_1)#,
				#filterNum(attributes.perform_pay_nettotal_2)#,
				#attributes.is_muaccelliyet#,
				<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#'
			)
		</cfquery>
		<cfloop from="1" to="2" index="x">
			<cfif evaluate('attributes.record_num#x#') gt 0>
			<cfloop from="1" to="#listlast(evaluate('attributes.record_num#x#'),'_')#" index="f">
				<cfif evaluate('attributes.row_kontrol#x#_#f#') gt 0>
					<cfset satir_borc_turu = evaluate('attributes.perform_type#x#_#f#')>
					<cfset satir_vade_tarihi = evaluate('attributes.perform_due_date#x#_#f#')>
					<cfset satir_borc_tutari = replace(replace(evaluate('attributes.perform_total#x#_#f#'),'.',''),',','.')>
					<cf_date tarih = 'satir_vade_tarihi'>

					<cfquery name="add_low_request_row" datasource="#dsn#">
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
								#MAX_ID.IDENTITYCOL#,
								#x#,
								#attributes.cpid#,
								#satir_borc_turu#,
								<cfif len(satir_vade_tarihi)>#satir_vade_tarihi#<cfelse>NULL</cfif>,
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
	action_page='#request.self#?fuseaction=crm.detail_company&cpid=#attributes.cpid#&is_open_request=2&action_id=#MAX_ID.IDENTITYCOL#' 
	action_id='#MAX_ID.IDENTITYCOL#'
	warning_description = 'Avukata Verme Talebi : #attributes.fullname#'>
<script type="text/javascript">
	wrk_opener_reload(); 
	self.close();
</script>
