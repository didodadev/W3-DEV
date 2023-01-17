<cfloop from="1" to="#attributes.sabitrowCount#" index="i">
	<cfif evaluate("attributes.sabit_row_kontrol_#i#") eq 1>
		<cfif (evaluate("attributes.sabit_is_ehesap#i#") eq 1 and session.ep.ehesap) or evaluate("attributes.sabit_is_ehesap#i#") eq 0>
			<cfquery name="add_row" datasource="#dsn#">
				UPDATE 
					SALARYPARAM_GET
				SET
					COMMENT_GET = '#wrk_eval("attributes.sabit_comment_get#i#")#',
					AMOUNT_GET = #evaluate("attributes.sabit_amount_get#i#")#,
					TOTAL_GET = <cfif len(evaluate("attributes.sabit_total_get#i#"))>#evaluate("attributes.sabit_total_get#i#")#,<cfelse>#evaluate("attributes.sabit_amount_get#i#")#,</cfif>
					SHOW = #evaluate("attributes.sabit_show#i#")#,
					METHOD_GET = #evaluate("attributes.sabit_method_get#i#")#,
					PERIOD_GET = #evaluate("attributes.sabit_period_get#i#")#,
					START_SAL_MON = #evaluate("attributes.sabit_start_sal_mon#i#")#,
					END_SAL_MON = #evaluate("attributes.sabit_end_sal_mon#i#")#,
					EMPLOYEE_ID = #attributes.EMPLOYEE_ID#,
					TERM = #evaluate("attributes.sabit_term#i#")#,
					CALC_DAYS = #evaluate("attributes.sabit_calc_days#i#")#,
					FROM_SALARY = #evaluate("attributes.sabit_FROM_SALARY#i#")#,
					<cfif session.ep.ehesap>
						IS_EHESAP = #evaluate("attributes.sabit_is_ehesap#i#")#,
					</cfif>
					ACCOUNT_CODE =  <cfif isDefined("attributes.sabit_account_code#i#") and len(evaluate("attributes.sabit_account_code#i#")) and isDefined("attributes.sabit_account_name#i#") and len(evaluate("attributes.sabit_account_name#i#"))>'#evaluate("attributes.sabit_account_code#i#")#'<cfelse>NULL</cfif>,
					TAX =  <cfif len(evaluate("attributes.sabit_tax#i#"))>#evaluate("attributes.sabit_tax#i#")#<cfelse>0</cfif>,
					ACCOUNT_NAME =  <cfif isDefined("attributes.sabit_account_name#i#") and len(evaluate("attributes.sabit_account_name#i#"))>'#evaluate("attributes.sabit_account_name#i#")#'<cfelse>NULL</cfif>,
					COMPANY_ID = <cfif isDefined("attributes.sabit_company_id#i#") and len(evaluate("attributes.sabit_company_id#i#")) and len(evaluate("attributes.sabit_member_name#i#"))>#evaluate("attributes.sabit_company_id#i#")#<cfelse>NULL</cfif>,
					CONSUMER_ID = <cfif isDefined("attributes.sabit_consumer_id#i#") and len(evaluate("attributes.sabit_consumer_id#i#")) and len(evaluate("attributes.sabit_member_name#i#"))>#evaluate("attributes.sabit_consumer_id#i#")#<cfelse>NULL</cfif>,
					ACC_TYPE_ID = <cfif isDefined("attributes.sabit_acc_type_id#i#") and len(evaluate("attributes.sabit_acc_type_id#i#"))>#evaluate("attributes.sabit_acc_type_id#i#")#<cfelse>NULL</cfif>,
					MONEY = '#evaluate("attributes.sabit_money#i#")#',
					UPDATE_DATE = #NOW()#,
					UPDATE_EMP = #SESSION.EP.USERID#,
					UPDATE_IP = '#CGI.REMOTE_ADDR#',
					DETAIL = <cfif len(evaluate("attributes.sabit_detail#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.sabit_detail#i#')#"><cfelse>NULL</cfif>,
					PROCESS_STAGE = <cfif isDefined("attributes.sabit_process_stage_#i#") And len(evaluate("attributes.sabit_process_stage_#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_process_stage_#i#')#"><cfelse>NULL</cfif>,
					IS_NET_TO_GROSS = <cfif isDefined("attributes.sabit_is_net_to_gross#i#") and len(evaluate("attributes.sabit_is_net_to_gross#i#"))><cfqueryparam cfsqltype="cf_sql_bit" value='#evaluate("attributes.sabit_is_net_to_gross#i#")#'><cfelse>0</cfif> 
				WHERE
					EMPLOYEE_ID=#attributes.EMPLOYEE_ID# AND
					IN_OUT_ID = #attributes.in_out_id# AND
					SPG_ID = #evaluate("attributes.spg_id#i#")#
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery name="del_" datasource="#dsn#">
			DELETE FROM SALARYPARAM_GET WHERE SPG_ID = #evaluate("attributes.spg_id#i#")#
		</cfquery>
	</cfif>
</cfloop>
<cfloop from="1" to="#attributes.rowCount#" index="i">
	<cfif evaluate("attributes.row_kontrol_#i#") eq 1>
		<cfif (evaluate("attributes.is_ehesap#i#") eq 1 and session.ep.ehesap) or evaluate("attributes.is_ehesap#i#") eq 0>
			<cfquery name="add_row" datasource="#dsn#">
				INSERT INTO SALARYPARAM_GET
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
						<cfif session.ep.ehesap>
						IS_EHESAP,
						</cfif>
						ACCOUNT_CODE,
						ACCOUNT_NAME,
						COMPANY_ID,
						CONSUMER_ID,
						ACC_TYPE_ID,
						MONEY,
						TAX,
						UPDATE_DATE,
						UPDATE_EMP,
						UPDATE_IP,
						DETAIL,
						PROCESS_STAGE,
						IS_NET_TO_GROSS
					)
				VALUES
					(
						'#wrk_eval("attributes.comment_get#i#")#',
						<cfif len(evaluate("attributes.total_get#i#"))>#evaluate("attributes.total_get#i#")#,<cfelse>#evaluate("attributes.amount_get#i#")#,</cfif>
						#evaluate("attributes.amount_get#i#")#,
						#evaluate("attributes.show#i#")#,
						#evaluate("attributes.method_get#i#")#,
						#evaluate("attributes.period_get#i#")#,
						#evaluate("attributes.start_sal_mon#i#")#,
						#evaluate("attributes.end_sal_mon#i#")#,
						#attributes.EMPLOYEE_ID#,
						#evaluate("attributes.term#i#")#,
						#evaluate("attributes.calc_days#i#")#,
						#evaluate("attributes.FROM_SALARY#i#")#,
						#attributes.in_out_id#,
						<cfif isdefined("attributes.is_inst_avans#i#") and len(evaluate("attributes.is_inst_avans#i#"))>#evaluate("attributes.is_inst_avans#i#")#<cfelse>0</cfif>,
						<cfif session.ep.ehesap>
							#evaluate("attributes.is_ehesap#i#")#,
						</cfif>
						<cfif isDefined("attributes.account_code#i#") and len(evaluate("attributes.account_code#i#")) and isDefined("attributes.account_name#i#") and len(evaluate("attributes.account_name#i#"))>'#evaluate("attributes.account_code#i#")#'<cfelse>NULL</cfif>,
						<cfif isDefined("attributes.account_name#i#") and len(evaluate("attributes.account_name#i#"))>'#evaluate("attributes.account_name#i#")#'<cfelse>NULL</cfif>,
						<cfif isDefined("attributes.company_id#i#") and len(evaluate("attributes.company_id#i#")) and len(evaluate("attributes.member_name#i#"))>#evaluate("attributes.company_id#i#")#<cfelse>NULL</cfif>,
						<cfif isDefined("attributes.consumer_id#i#") and len(evaluate("attributes.consumer_id#i#")) and len(evaluate("attributes.member_name#i#"))>#evaluate("attributes.consumer_id#i#")#<cfelse>NULL</cfif>,
						<cfif isDefined("attributes.acc_type_id#i#") and len(evaluate("attributes.acc_type_id#i#"))>#evaluate("attributes.acc_type_id#i#")#<cfelse>NULL</cfif>,
						'#evaluate("attributes.money#i#")#',
						<cfif len(evaluate("attributes.tax#i#"))>#evaluate("attributes.tax#i#")#<cfelse>0</cfif>,
						#NOW()#,
						#SESSION.EP.USERID#,
						'#CGI.REMOTE_ADDR#',
						<cfif len(evaluate("attributes.detail#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.process_stage_#i#") and len(evaluate("attributes.process_stage_#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.process_stage_#i#')#"><cfelse>NULL</cfif>,
						<cfif isDefined("attributes.is_net_to_gross#i#") and len(evaluate("attributes.is_net_to_gross#i#"))><cfqueryparam cfsqltype="cf_sql_bit" value='#evaluate("attributes.is_net_to_gross#i#")#'><cfelse>0</cfif> 
					)
			</cfquery>
		</cfif>
	</cfif>
</cfloop>
<cfif isdefined("attributes.from_upd_salary") and len(attributes.from_upd_salary)>
	<cflocation url="#request.self#?fuseaction=ehesap.list_salary&event=upd&in_out_id=#attributes.in_out_id#&employee_id=#attributes.employee_id#&type=6" addtoken="No">
<cfelseif not isdefined("attributes.draggable")>
	<script type="text/javascript">
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</script>
</cfif>