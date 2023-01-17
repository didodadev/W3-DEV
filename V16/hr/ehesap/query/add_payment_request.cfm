<cf_date  tarih='attributes.duedate'>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol_#i#") eq 1 and LEN(evaluate("attributes.emp_id#i#"))>
				<cfquery name="add_row_to_tbl" datasource="#DSN#" result="MAX_ID">
					INSERT INTO
						CORRESPONDENCE_PAYMENT
						(
							IN_OUT_ID,
						<cfif (isdefined("hepsi_onayli") and hepsi_onayli) or fusebox.circuit is "ehesap">
							VALID_EMP,
							VALID_DATE,
							STATUS,
						</cfif>
							RECORD_EMP,
							RECORD_DATE,
							PRIORITY,
							DUEDATE,
							PAYMETHOD_ID,
							TO_EMPLOYEE_ID,
							AMOUNT,
							MONEY,
							DETAIL,
							SUBJECT,
							PROCESS_STAGE,
							PERIOD_ID,
							DEMAND_TYPE
						)
						VALUES
						(
							#evaluate("attributes.in_out_id#i#")#,
						<cfif (isdefined("hepsi_onayli") and hepsi_onayli) or fusebox.circuit is "ehesap">
							#SESSION.EP.USERID#,
							#NOW()#,
							1,
						</cfif>
							#SESSION.EP.USERID#,
							#NOW()#,
							#attributes.PRIORITY#,
							#attributes.duedate#,
							<cfif isdefined("attributes.pay_method#i#")>#evaluate("attributes.pay_method#i#")#<cfelse>NULL</cfif>,
							#evaluate("attributes.emp_id#i#")#,
							#evaluate("attributes.total#i#")#,
							<cfif isdefined("attributes.money#i#")>'#wrk_eval("attributes.money#i#")#'<cfelse>NULL</cfif>,
							'#attributes.detail#',
							'#SUBJECT#',
							#evaluate("attributes.process_stage#i#")#,
							#SESSION.EP.PERIOD_ID#,
							<cfif isdefined("attributes.demand_type#i#")>#evaluate("attributes.demand_type#i#")#<cfelse>NULL</cfif>
							

						)
				</cfquery>
				<cfif (isdefined("hepsi_onayli") and hepsi_onayli) or fusebox.circuit is "ehesap">
					<cfquery name="get_hr_ssk_1" datasource="#dsn#">
						SELECT
							EMPLOYEES_IN_OUT.PUANTAJ_GROUP_IDS,
							EMPLOYEES_IN_OUT.BRANCH_ID
						FROM
							EMPLOYEES_IN_OUT
						WHERE
							EMPLOYEES_IN_OUT.IN_OUT_ID = #evaluate("attributes.in_out_id#i#")#
					</cfquery>
					<cfset attributes.sal_mon = MONTH(attributes.duedate)>
					<cfset attributes.sal_year = YEAR(attributes.duedate)>
					<cfset attributes.group_id = "">
					<cfif len(get_hr_ssk_1.puantaj_group_ids)>
						<cfset attributes.group_id = "#get_hr_ssk_1.PUANTAJ_GROUP_IDS#,">
					</cfif>
					<cfset attributes.branch_id = get_hr_ssk_1.branch_id>
					<cfset not_kontrol_parameter = 1>
					<cfinclude template="../query/get_program_parameter.cfm">
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO
							SALARYPARAM_GET
						(
							COMMENT_GET,
							AMOUNT_GET,
							TOTAL_GET,
							SHOW,
							METHOD_GET,
							PERIOD_GET, 
							START_SAL_MON,
							END_SAL_MON,
							EMPLOYEE_ID,
							TERM,
							CALC_DAYS,
							FROM_SALARY,
							IN_OUT_ID,
							IS_INST_AVANS,
							DETAIL,
							ACCOUNT_CODE,
							ACCOUNT_NAME,
							COMPANY_ID,
							CONSUMER_ID,
							ACC_TYPE_ID,
							MONEY,
							PAYMENT_ID,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP
						)
						VALUES
						(
							'Avans',
							#evaluate("attributes.total#i#")#,
							#evaluate("attributes.total#i#")#,
							<cfif get_program_parameters.is_avans_off eq 1>0<cfelse>1</cfif>,
							1,
							1,
							#month(attributes.duedate)#,
							#month(attributes.duedate)#,
							#evaluate("attributes.emp_id#i#")#,
							#year(attributes.duedate)#,
							0,
							0,
							#evaluate("attributes.in_out_id#i#")#,
							0,
							<cfif isdefined("attributes.detail") and len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
							<cfif isDefined("get_program_parameters.account_code") and len(get_program_parameters.account_code)>'#get_program_parameters.account_code#'<cfelse>NULL</cfif>,
							<cfif isDefined("get_program_parameters.account_name") and len(get_program_parameters.account_name)>'#get_program_parameters.account_name#'<cfelse>NULL</cfif>,
							<cfif isDefined("get_program_parameters.company_id") and len(get_program_parameters.company_id)>#get_program_parameters.company_id#<cfelse>NULL</cfif>,
							<cfif isDefined("get_program_parameters.consumer_id") and len(get_program_parameters.consumer_id)>#get_program_parameters.consumer_id#<cfelse>NULL</cfif>,
							<cfif isDefined("get_program_parameters.acc_type_id") and len(get_program_parameters.acc_type_id)>#get_program_parameters.acc_type_id#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.money#i#")>'#wrk_eval("attributes.money#i#")#'<cfelse>NULL</cfif>,
							#MAX_ID.IDENTITYCOL#,
							#NOW()#,
							#SESSION.EP.USERID#,
							'#CGI.REMOTE_ADDR#'
						)
					</cfquery>
				</cfif>
				<cf_workcube_process
					is_upd='1'
					old_process_line='0'
					process_stage='#evaluate("attributes.process_stage#i#")#'
					record_member='#session.ep.userid#'
					record_date='#now()#'
					action_table='CORRESPONDENCE_PAYMENT'
					action_column='ID'
					action_id='#MAX_ID.IDENTITYCOL#'
					action_page="#request.self#?fuseaction=ehesap.list_payment_requests&event=upd&id=#MAX_ID.IDENTITYCOL#"
					warning_description = 'Avans Talebi : #MAX_ID.IDENTITYCOL#'>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<script type="text/javascript">
<cfif isdefined("attributes.modal_id") and len(attributes.modal_id)>
closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
location.href = document.referrer;
<cfelse>
	window.close();
	wrk_opener_reload();
</cfif>
</script> 
