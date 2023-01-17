<cfset satir_borc_turu = "">
<cfset satir_borc_tutari = "">
<cfset satir_vade_tarihi = "">
<cf_date tarih = 'attributes.process_date'>
<cf_date tarih = 'attributes.postpone_pay_net_duedate_1'>
<cf_date tarih = 'attributes.postpone_pay_net_duedate_2'>
<cf_date tarih = 'attributes.postpone_pay_net_duedate_3'>
<cflock timeout="60">
	<cftransaction>
		<cfquery name="UPD_COMPANY_DEBIT" datasource="#DSN#">
			UPDATE
				COMPANY_DEBIT_POSTPONE
			SET
				COMPANY_ID = #attributes.cpid#,
				BRANCH_ID = #attributes.branch_id#,
				PROCESS_CAT = #attributes.process_stage#,
				PROCESS_DATE = #attributes.process_date#,
				DETAIL = '#attributes.detail#',
				IS_JOB_ADD = #attributes.is_job_add#,
				IS_JOB_CONTINUE = #attributes.is_job_continue#,
				IS_JOB_POSTPONE = #attributes.is_job_postpone#,
				JOB_ADD_DETAIL = '#attributes.job_add_detail#',
				JOB_CONTINUE_DETAIL = '#attributes.job_continue_detail#',
				JOB_POSTPONE_DETAIL_TOTAL = #filternum(attributes.job_postpone_detail_total)#,
				DEBT_REASON_DETAIL = '#attributes.debt_reason_detail#',
				MANAGER_IDEA_DETAIL = '#attributes.manager_idea_detail#',
				POSTPONE_PAY_NETTOTAL1 = #filternum(attributes.postpone_pay_nettotal_1)#,
				POSTPONE_PAY_NETTOTAL2 = #filternum(attributes.postpone_pay_nettotal_2)#,
				POSTPONE_PAY_NETTOTAL3 = #filternum(attributes.postpone_pay_nettotal_3)#,
				POSTPONE_PAY_NET_DUEDATE1 = #attributes.postpone_pay_net_duedate_1#,
				POSTPONE_PAY_NET_DUEDATE2 = #attributes.postpone_pay_net_duedate_2#,
				POSTPONE_PAY_NET_DUEDATE3 = #attributes.postpone_pay_net_duedate_3#,
				DUEDATE_DIFF_RATE = #filternum(attributes.duedate_diff_rate)#,
				DUEDATE_DIFF_KDV = #attributes.duedate_diff_kdv#,
				DUEDATE_DIFF_TOTAL = #filternum(attributes.duedate_diff_total)#,
				POSTPONE_DAY_NUMBER = #attributes.postpone_day_number#,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#',
				IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>
			WHERE
				COMPANY_DEBIT_POSTPONE_ID = #attributes.debit_postpone_id#
		</cfquery>
		 
		<cfquery name="DEL_COMPANY_DEBIT_ROW" datasource="#dsn#">
			DELETE FROM COMPANY_DEBIT_POSTPONE_ROW WHERE POSTPONE_ID = #attributes.debit_postpone_id#
		</cfquery>
		
		<cfloop from="1" to="3" index="x">
			<cfif evaluate('attributes.record_num#x#') gt 0>
			<cfloop from="1" to="#listlast(evaluate('attributes.record_num#x#'),'_')#" index="f">
				
				<cfif evaluate('attributes.row_kontrol#x#_#f#') gt 0>
					<cfset satir_borc_turu = evaluate('attributes.postpone_debt_type#x#_#f#')>
					<cfset satir_vade_tarihi = evaluate('attributes.postpone_due_date#x#_#f#')>
					<cfset satir_borc_tutari = filterNum(evaluate('attributes.postpone_total#x#_#f#'))>
					<cf_date tarih = 'satir_vade_tarihi'>
					
					<cfquery name="ADD_COMPANY_DEBIT_ROW" datasource="#DSN#">
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
							#attributes.debit_postpone_id#,
							#x#,
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
				'#ucase('COMPANY_DEBIT_POSTPONE_ID')#',
				 #attributes.debit_postpone_id#,
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
	action_page='#request.self#?fuseaction=crm.detail_company&cpid=#attributes.cpid#&is_open_request=3&action_id=#attributes.debit_postpone_id#' 
	action_id='#attributes.debit_postpone_id#'
	old_process_line='#attributes.old_process_line#'
	warning_description = 'Satışa Açma Talebi : #attributes.fullname#'>
<script type="text/javascript">
	wrk_opener_reload(); 
	self.close();
</script>
