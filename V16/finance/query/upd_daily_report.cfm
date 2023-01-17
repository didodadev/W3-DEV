<cf_date tarih='attributes.report_date'>
<cfquery name="GET_TOTAL_KALAN" datasource="#DSN2#">
  	SELECT STORE_REPORT_DATE FROM STORE_REPORT WHERE STORE_REPORT_DATE = #attributes.report_date# AND BRANCH_ID = #attributes.branch_id# AND STORE_REPORT_ID <> #attributes.STORE_REPORT_ID#
</cfquery>
<cfif (get_total_kalan.recordcount)>
		<script type="text/javascript">
			alert("Bu Gün ve Şubeye Ait Kayıt Var !");
			history.go(-1);
		</script>
	<cfabort>
</cfif>
<cflock name="#createuuid()#" timeout="70">
	<cftransaction>
		<cfquery name="ADD_GENEL" datasource="#DSN2#">
			UPDATE
				STORE_REPORT
			SET
				STORE_REPORT_DATE = <cfif len(attributes.report_date)>#attributes.report_date#,<cfelse>NULL,</cfif>
				BRANCH_ID = #attributes.branch_id#,
				REPORT_ORDER_EMP = <cfif len(report_emp_id)>#report_emp_id#,<cfelse>NULL,</cfif>
				DEVREDEN = <cfif len(attributes.summary_genel_kalan)>#attributes.summary_genel_kalan#,<cfelse>0,</cfif>
				DETAIL = <cfif len(attributes.ek_info)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ek_info#">,<cfelse>NULL,</cfif>
				BANKAYA_YATAN = <cfif len(attributes.bankaya_yatan)>#attributes.bankaya_yatan#,<cfelse>0,</cfif>
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_DATE = #NOW()#,
				REPORT_APPROVAL_EMP = <cfif len(attributes.approval_emp_id)>#attributes.approval_emp_id#,<cfelse>NULL,</cfif>
				REPORT_APPROVAL_DATE = #NOW()#,
				DEVREDEN_IN = <cfif len(attributes.kalan_eski)>#attributes.kalan_eski#<cfelse>0</cfif>
			WHERE
				STORE_REPORT_ID = #attributes.store_report_id#
		</cfquery>

		<cfquery name="GET_STORE_POS_CASH" datasource="#DSN2#">
			SELECT STORE_POS_ID FROM STORE_POS_CASH WHERE STORE_REPORT_ID = #attributes.store_report_id#
		</cfquery>
		<cfquery name="DEL_CASH_POS" datasource="#DSN2#">
			DELETE FROM STORE_POS_CASH WHERE STORE_REPORT_ID = #attributes.store_report_id#
		</cfquery>
		<cfquery name="GET_DAILY_SALES_REPORT" datasource="#DSN2#">
			SELECT EQUIPMENT AS EQUIPMENT, POS_ID AS POS_ID FROM #dsn3_alias#.POS_EQUIPMENT WHERE BRANCH_ID = #attributes.branch_id# AND POS_ID IN(#valuelist(get_store_pos_cash.store_pos_id)#) ORDER BY POS_ID
		</cfquery>
		<cfloop query="get_daily_sales_report">
			<cfscript>
				form_total_cash = evaluate("attributes.total_cash#currentrow#");
				form_total_credit = evaluate("attributes.total_credit#currentrow#");
				form_total = evaluate("attributes.total#currentrow#");
				form_employee = evaluate("attributes.employee#currentrow#");
				form_employee_id = evaluate("attributes.employee_id#currentrow#");
				form_open_cash = evaluate("attributes.open_cash#currentrow#");
				form_given_money = evaluate("attributes.given_money#currentrow#");
				form_pos_no = evaluate("attributes.pos_no#currentrow#");
				form_z_no = evaluate("attributes.z_no#currentrow#");
				form_pos_id = evaluate("attributes.pos_id#currentrow#");
			</cfscript>
				<cfquery name="ADD_DAILY_SALES_REPORT" datasource="#DSN2#">
					INSERT
					INTO
						STORE_POS_CASH
						(
							SALES_CASH,
							SALES_CREDIT,
							SALES_TOTAL,
							MONEY_ID,
							EMPLOYEE_ID,
							OPEN_CASH,
							GIVEN_TOTAL,
							STORE_REPORT_DATE,
							BRANCH_ID,
							POS_NO,
							STORE_REPORT_ID,
							Z_NO,
							STORE_POS_ID,
							RECORD_EMP,
							RECORD_DATE,
							RECORD_IP
						)
					VALUES
						(
							<cfif len(form_total_cash)>#form_total_cash#,<cfelse>0,</cfif>
							<cfif len(form_total_credit)>#form_total_credit#,<cfelse>0,</cfif>
							<cfif len(form_total)>#form_total#,<cfelse>0,</cfif>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
							<cfif len(form_employee) and len(form_employee_id)>#form_employee_id#,<cfelse>NULL,</cfif>
							<cfif len(form_open_cash)>#form_open_cash#,<cfelse>0,</cfif>
							<cfif len(form_given_money)>#form_given_money#,<cfelse>NULL,</cfif>
							<cfif len(attributes.report_date)>#attributes.report_date#,<cfelse>NULL,</cfif>
							#attributes.branch_id#,
							<cfif len(form_pos_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form_pos_no#">,<cfelse>NULL,</cfif>
							#attributes.store_report_id#,
							<cfif len(form_z_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form_z_no#">,<cfelse>NULL,</cfif>
							<cfif len(form_pos_id)>#form_pos_id#,<cfelse>NULL,</cfif>
							#SESSION.EP.USERID#,
							#NOW()#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
						)
				</cfquery>
		</cfloop>
		<cfquery name="DEL_CASH_POS" datasource="#DSN2#">
			DELETE FROM STORE_POS_BANK WHERE STORE_REPORT_ID = #attributes.STORE_REPORT_ID#
		</cfquery>
		<cfquery name="GET_CREDIT_PAYMENT" datasource="#DSN2#">
			SELECT PAYMENT_TYPE_ID, CARD_NO, NUMBER_OF_INSTALMENT, SERVICE_RATE, OTHER_COMISSION_RATE, IS_COMISSION FROM #dsn3_alias#.CREDITCARD_PAYMENT_TYPE WHERE IS_ACTIVE = 1 ORDER BY CARD_NO
		</cfquery>
		<cfloop query="get_credit_payment">
			<cfscript>
				form_bank_branch_id = evaluate("attributes.bank_branch_id#currentrow#");
				form_number_of_operation = evaluate("attributes.number_of_operation#currentrow#");
				form_sales_credit = evaluate("attributes.sales_credit#currentrow#");
				form_puanli_pesin = evaluate("attributes.puanli_pesin#currentrow#");
				form_puanli = evaluate("attributes.puanli#currentrow#");
			</cfscript>
				<cfquery name="ADD_STORE_BANK_POS" datasource="#DSN2#">
					INSERT
					INTO
						STORE_POS_BANK
						(
							BANK_ID,
							SALES_CREDIT,
							SALES_TAKSIT,
							SALES_CREDIT_MONEY_ID,
							SALES_TAKSIT_MONEY_ID,
							BRANCH_ID,
							STORE_REPORT_DATE,
							STORE_REPORT_ID,
							PUANLI_PESIN,
							PUANLI,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE
						)
					VALUES
						(
							<cfif len(form_bank_branch_id)>#form_bank_branch_id#,<cfelse>0,</cfif>
							<cfif len(form_sales_credit)>#form_sales_credit#,<cfelse>0,</cfif>
							<cfif len(form_number_of_operation)>#form_number_of_operation#,<cfelse>0,</cfif>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
							#attributes.branch_id#,
							<cfif len(attributes.report_date)>#attributes.report_date#,<cfelse>NULL,</cfif>
							#attributes.store_report_id#,
							<cfif len(form_puanli_pesin)>#form_puanli_pesin#,<cfelse>0,</cfif>
							<cfif len(form_puanli)>#form_puanli#,<cfelse>0,</cfif>
							#SESSION.EP.USERID#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
							#NOW()#
						)
				</cfquery>
			</cfloop>
			<cfquery name="DEL_STORE_EXPENSE" datasource="#DSN2#">
				DELETE FROM STORE_EXPENSE WHERE STORE_REPORT_ID = #attributes.store_report_id#
			</cfquery>
			<cfif len(attributes.record_num) and attributes.record_num neq "">
				<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif evaluate("attributes.row_kontrol#i#")>
					<cfscript>
						form_detail = evaluate("attributes.detail#i#");
						form_payment_tax = evaluate("attributes.payment_tax#i#");
						form_expense_total = evaluate("attributes.expense_total#i#");
						form_money_type = evaluate("attributes.money_type#i#");
						attributes.form_money_type = listgetat(form_money_type, 1, ',');
						form_payment_type = evaluate("attributes.payment_type#i#");
						form_payment_net_total_tax = evaluate("attributes.payment_net_total_tax#i#");
						form_payment_net_total = evaluate("attributes.payment_net_total#i#");
					</cfscript>
					<cfquery name="ADD_EXPENSE" datasource="#DSN2#">
						INSERT
							INTO
							STORE_EXPENSE
							(
								EXPENSE_TYPE_ID,
								DETAIL,
								EXPENSE_MONEY,
								MONEY_ID,
								BRANCH_ID,
								STORE_REPORT_DATE,
								STORE_REPORT_ID,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE,
								TAX,
								TAX_TOTAL,
								TOTAL
							)
							VALUES
							(
								<cfif len(form_payment_type)>#form_payment_type#,<cfelse>NULL,</cfif>
								<cfif len(form_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form_detail#">,<cfelse>NULL,</cfif>
								<cfif len(form_expense_total)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form_expense_total#">,<cfelse>0,</cfif>
								<cfif len(attributes.form_money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.form_money_type#">,<cfelse>NULL,</cfif>
								#attributes.branch_id#,
								<cfif len(attributes.report_date)>#attributes.report_date#,<cfelse>NULL,</cfif>
								#attributes.store_report_id#,
								#SESSION.EP.USERID#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
								#NOW()#,
								<cfif len(form_payment_tax)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form_payment_tax#">,<cfelse>NULL,</cfif>
								<cfif len(form_payment_net_total_tax)>#form_payment_net_total_tax#,<cfelse>0,</cfif>
								<cfif len(form_payment_net_total)>#form_payment_net_total#<cfelse>0</cfif>
							)
					</cfquery>
					</cfif>
				</cfloop>
				</cfif>
			<cfquery name="DEL_INCOME_ROWS" datasource="#DSN2#">
				DELETE FROM STORE_INCOME WHERE STORE_REPORT_ID = #attributes.store_report_id#
			</cfquery>
			<cfif len(attributes.income_record_num) and (attributes.income_record_num neq "")>
				<cfloop from="1" to="#attributes.income_record_num#" index="i">
					<cfif evaluate("attributes.income_row_kontrol#i#")>
						<cfset form_income_detail = evaluate("attributes.income_detail#i#")>
						<cfset form_income_payment_tax = evaluate("attributes.income_payment_tax#i#")>
						<cfset form_income_expense_total = evaluate("attributes.income_expense_total#i#")>
						<cfset form_income_money_type = evaluate("attributes.income_money_type#i#")>
						<cfset attributes.form_income_money_type = listgetat(form_income_money_type, 1, ',')>
						<cfset form_income_payment_type = evaluate("attributes.income_payment_type#i#")>
						<cfset form_income_payment_net_total_tax = evaluate("attributes.income_payment_net_total_tax#i#")>
						<cfset form_income_payment_net_total = evaluate("attributes.income_payment_net_total#i#")>
						<cfquery name="ADD_EXPENSE" datasource="#DSN2#">
							INSERT INTO
								STORE_INCOME
								(
									INCOME_TYPE_ID,
									DETAIL,
									INCOME_MONEY,
									MONEY_ID,
									BRANCH_ID,
									STORE_REPORT_DATE,
									STORE_REPORT_ID,
									RECORD_EMP,
									RECORD_IP,
									RECORD_DATE,
									TAX,
									TAX_TOTAL,
									TOTAL
								)
								VALUES
								(
									<cfif len(form_income_payment_type)>#form_income_payment_type#,<cfelse>NULL,</cfif>
									<cfif len(form_income_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form_income_detail#">,<cfelse>NULL,</cfif>
									<cfif len(form_income_expense_total)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form_income_expense_total#">,<cfelse>0,</cfif>
									<cfif len(attributes.form_income_money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.form_income_money_type#">,<cfelse>NULL,</cfif>
									#attributes.branch_id#,
									<cfif len(attributes.report_date)>#attributes.report_date#,<cfelse>NULL,</cfif>
									#attributes.store_report_id#,
									#SESSION.EP.USERID#,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
									#NOW()#,
									<cfif len(form_income_payment_tax)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form_income_payment_tax#">,<cfelse>NULL,</cfif>
									<cfif len(form_income_payment_net_total_tax)>#form_income_payment_net_total_tax#,<cfelse>0,</cfif>
									<cfif len(form_income_payment_net_total)>#form_income_payment_net_total#<cfelse>0</cfif>
								)
						</cfquery>
					</cfif>
				</cfloop>
				</cfif>
	</cftransaction>
</cflock>

<script>
	window.location.href = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_stores_daily_reports&event=upd&id=#attributes.store_report_id#</cfoutput>';
</script>

