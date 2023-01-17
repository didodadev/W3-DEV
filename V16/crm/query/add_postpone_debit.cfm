<cfset satir_borc_turu = "">
<cfset satir_borc_tutari = "">
<cfset satir_vade_tarihi = "">
<cf_date tarih = 'attributes.process_date'>
<cf_date tarih = 'attributes.postpone_pay_net_duedate_1'>
<cf_date tarih = 'attributes.postpone_pay_net_duedate_2'>
<cf_date tarih = 'attributes.postpone_pay_net_duedate_3'>
<cflock timeout="60">
	<cftransaction>
		<cfquery name="add_company_debit" datasource="#dsn#" result="MAX_ID">
			INSERT INTO
				COMPANY_DEBIT_POSTPONE
				(
					COMPANY_ID,
					BRANCH_ID,
					RELATED_ID,
					PROCESS_CAT,
					PROCESS_DATE,
					DETAIL,
					IS_JOB_ADD,
					IS_JOB_CONTINUE,
					IS_JOB_POSTPONE,
					JOB_ADD_DETAIL,
					JOB_CONTINUE_DETAIL,
					JOB_POSTPONE_DETAIL_TOTAL,
					DEBT_REASON_DETAIL,
					MANAGER_IDEA_DETAIL,
					POSTPONE_PAY_NETTOTAL1,
					POSTPONE_PAY_NETTOTAL2,
					POSTPONE_PAY_NETTOTAL3,
					POSTPONE_PAY_NET_DUEDATE1,
					POSTPONE_PAY_NET_DUEDATE2,
					POSTPONE_PAY_NET_DUEDATE3,
					DUEDATE_DIFF_RATE,
					DUEDATE_DIFF_KDV,
					DUEDATE_DIFF_TOTAL,
					POSTPONE_DAY_NUMBER,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					IS_ACTIVE
				)
				VALUES
				(
					#attributes.cpid#,
					#listfirst(attributes.branch_id,'-')#,
					#listlast(attributes.branch_id,'-')#,
					#attributes.process_stage#,
					#attributes.process_date#,
					'#attributes.detail#',
					#attributes.is_job_add#,
					#attributes.is_job_continue#,
					#attributes.is_job_postpone#,
					'#attributes.job_add_detail#',
					'#attributes.job_continue_detail#',
					#attributes.job_postpone_detail_total#,
					'#attributes.debt_reason_detail#',
					'#attributes.manager_idea_detail#',
					#attributes.postpone_pay_nettotal_1#,
					#attributes.postpone_pay_nettotal_2#,
					#attributes.postpone_pay_nettotal_3#,
					#attributes.postpone_pay_net_duedate_1#,
					#attributes.postpone_pay_net_duedate_2#,
					#attributes.postpone_pay_net_duedate_3#,
					#attributes.duedate_diff_rate#,
					#attributes.duedate_diff_kdv#,
					#attributes.duedate_diff_total#,
					#attributes.postpone_day_number#,
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#',
					<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>
				)
		</cfquery>
		<cfloop from="1" to="3" index="x">
			<cfif evaluate('attributes.record_num#x#') gt 0>
			<cfloop from="1" to="#listlast(evaluate('attributes.record_num#x#'),'_')#" index="f">
				<cfif evaluate('attributes.row_kontrol#x#_#f#') gt 0>
					<cfset satir_borc_turu = evaluate('attributes.postpone_debt_type#x#_#f#')>
					<cfset satir_vade_tarihi = evaluate('attributes.postpone_due_date#x#_#f#')>
					<cfset satir_borc_tutari = filterNum(evaluate('attributes.postpone_total#x#_#f#'))>
					<cf_date tarih = 'satir_vade_tarihi'>
					
					<cfquery name="add_company_debit_row" datasource="#dsn#">
						INSERT INTO
							COMPANY_DEBIT_POSTPONE_ROW
							(
								COMPANY_ID,
								POSTPONE_ID,
								TYPE_ID,
								POSTPONE_DEBT_TYPE,
								POSTPONE_DUE_DATE,
								POSTPONE_TOTAL,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
							)
							VALUES
							(
								#attributes.cpid#,
								#MAX_ID.IDENTITYCOL#,
								#x#,
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
				'COMPANY_DEBIT_POSTPONE_ID',
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
	wrk_opener_reload(); 
	self.close();
</script>
