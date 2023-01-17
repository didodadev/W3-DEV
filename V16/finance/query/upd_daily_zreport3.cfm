<cfif isdefined("form.is_cash") and (form.is_cash eq 1)>
	<cfloop from="1" to="#kur_say#" index="k">
		 <cfif isdefined("kasa#k#") and isdefined("cash_amount#k#") and (evaluate('cash_amount#k#') gt 0)>
			<cfquery name="get_cash_code" datasource="#dsn2#">
				SELECT CASH_ACC_CODE,BRANCH_ID FROM CASH WHERE CASH_ID = #evaluate("kasa#k#")#
			</cfquery>
			<cfif len(get_cash_code.BRANCH_ID)>
				<cfset cash_branch_id = get_cash_code.BRANCH_ID>
			<cfelse>
				<cfset cash_branch_id = ''>
			</cfif>
		  	<cfif isdefined("cash_action_id_#k#") and len(evaluate("cash_action_id_#k#"))>
				<cfquery name="UPD_ALISF_KAPA" datasource="#dsn2#">
					UPDATE 
						CASH_ACTIONS
					SET					
						CASH_ACTION_TO_CASH_ID=#evaluate("kasa#k#")#,
						ACTION_TYPE_ID=69,
						BILL_ID=#form.invoice_id#,
						CASH_ACTION_VALUE=#evaluate('cash_amount#k#')#,
						CASH_ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('currency_type#k#')#">,					
						ACTION_DATE=#attributes.invoice_date#,
						IS_PROCESSED=#is_account#,
						PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
						IS_ACCOUNT = <cfif is_account>1,<cfelse>0,</cfif>
						IS_ACCOUNT_TYPE = 11,
						PROCESS_CAT=0,
						UPDATE_EMP=#session.ep.userid#,
						UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
						UPDATE_DATE=#now()#,
						ACTION_VALUE = #evaluate('system_cash_amount#k#')#,
						ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
						<cfif len(session.ep.money2)>
							,ACTION_VALUE_2 = #wrk_round(evaluate('system_cash_amount#k#')/attributes.currency_multiplier,4)#
							,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
						</cfif>
					WHERE
						ACTION_ID=#evaluate("cash_action_id_#k#")#
				</cfquery>
				<cfquery name="UPD_INVOICE_CASH_POS2" datasource="#dsn2#">
					UPDATE 
						INVOICE_CASH_POS
					SET
						KASA_ID=#evaluate("kasa#k#")#
					WHERE
						INVOICE_ID=#form.invoice_id#
						AND CASH_ID=#evaluate("cash_action_id_#k#")#
				</cfquery>
				<cfset act_id=evaluate("cash_action_id_#k#")>
			<cfelse>
				<cfquery name="ADD_ALISF_KAPA" datasource="#dsn2#">
					INSERT INTO CASH_ACTIONS
						(
							CASH_ACTION_TO_CASH_ID,
							ACTION_TYPE,
							ACTION_TYPE_ID,
							BILL_ID,
							CASH_ACTION_VALUE,
							CASH_ACTION_CURRENCY_ID,
							ACTION_DATE,
							ACTION_DETAIL,
							IS_PROCESSED,
							PAPER_NO,
							IS_ACCOUNT,
							IS_ACCOUNT_TYPE,
							PROCESS_CAT,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE,
							ACTION_VALUE,
							ACTION_CURRENCY_ID
							<cfif len(session.ep.money2)>
								,ACTION_VALUE_2
								,ACTION_CURRENCY_ID_2
							</cfif>
						)
					VALUES
						(
							#evaluate("kasa#k#")#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="Z RAPORU KAPAMA İŞLEMİ">,
							69,
							#form.invoice_id#,
							#evaluate('cash_amount#k#')#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('currency_type#k#')#">,
							#attributes.invoice_date#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="Z RAPORU KAPAMA İŞLEMİ">,
						<cfif is_account>1<cfelse>0</cfif>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
							<cfif is_account eq 1>
								1,
								11,
							<cfelse>
								0,
								11,
							</cfif>
							0,
							#session.ep.userid#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							#now()#,
							#evaluate('system_cash_amount#k#')#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
							<cfif len(session.ep.money2)>
								,#wrk_round(evaluate('system_cash_amount#k#')/attributes.currency_multiplier,4)#
								,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
							</cfif>
						)
				</cfquery>
				<cfquery name="GET_ACT_ID" datasource="#dsn2#">
					SELECT MAX(ACTION_ID) AS ACT_ID	FROM CASH_ACTIONS
				</cfquery>
				<cfset act_id=get_act_id.ACT_ID>
				<cfquery name="UPD_INVOICE_CASH" datasource="#dsn2#">
					INSERT INTO INVOICE_CASH_POS
						(
							INVOICE_ID,
							CASH_ID,
							KASA_ID
						)
					VALUES
						(
							#form.invoice_id#,
							#ACT_ID#,
							#evaluate("kasa#k#")#
						)
				</cfquery>
			</cfif>
		<cfelse>
			<cfif isdefined("cash_action_id_#k#") and  len(evaluate('cash_action_id_#k#'))>
				<cfquery name="DEL_CASH_ACTIONS" datasource="#dsn2#">
					DELETE FROM CASH_ACTIONS WHERE ACTION_ID = #evaluate('cash_action_id_#k#')# AND ACTION_TYPE_ID=69
				</cfquery>
				<cfquery name="DEL_CASH_ACTIONS" datasource="#dsn2#">
					DELETE FROM INVOICE_CASH_POS WHERE INVOICE_ID=#form.invoice_id# AND CASH_ID = #evaluate('cash_action_id_#k#')#
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>
	<cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
		UPDATE 
			INVOICE
		SET
			IS_CASH=1,
			IS_ACCOUNTED = #is_account#
		WHERE
			INVOICE_ID=#form.invoice_id#
	</cfquery>
<cfelse>
	<cfquery name="control_invoice_cash" datasource="#dsn2#">
		SELECT CASH_ID,KASA_ID,INVOICE_CASH_ID FROM INVOICE_CASH_POS WHERE INVOICE_ID=#form.invoice_id# AND CASH_ID IS NOT NULL
	</cfquery>
	<cfif control_invoice_cash.recordcount>
		<cfquery name="DEL_CASH_ACTIONS" datasource="#dsn2#">
			DELETE FROM CASH_ACTIONS WHERE ACTION_ID IN (#valuelist(control_invoice_cash.CASH_ID)#)
		</cfquery>
		<cfquery name="DEL_CASH_ACTIONS" datasource="#dsn2#">
			DELETE FROM INVOICE_CASH_POS WHERE INVOICE_ID=#form.invoice_id# AND CASH_ID IN (#valuelist(control_invoice_cash.CASH_ID)#)
		</cfquery>
	</cfif>
	<cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
		UPDATE 
			INVOICE
		SET
			IS_CASH = 0,
			IS_ACCOUNTED = 0
		WHERE
			INVOICE_ID = #form.invoice_id#
	</cfquery>		
</cfif>

