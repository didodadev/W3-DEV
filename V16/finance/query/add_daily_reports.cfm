
<cf_date tarih='attributes.report_date'>
<cfquery name="GET_TOTAL_KALAN" datasource="#DSN2#">
	SELECT STORE_REPORT_DATE FROM STORE_REPORT WHERE STORE_REPORT_DATE = #attributes.report_date# AND BRANCH_ID = #attributes.branch_id#
</cfquery>
<cfif get_total_kalan.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='550.Bu Gün ve Şubeye Ait Kayıt Var'> !");
			history.go(-1);
		</script>
     <cfabort>
</cfif>
<cflock name="#createUUID()#" timeout="100">
	<cftransaction>
		<cfquery name="ADD_GENEL" datasource="#DSN2#">
			INSERT INTO
				STORE_REPORT
				(
					STORE_REPORT_DATE,<!--- rapor tarihi --->
					BRANCH_ID,<!--- rapor düzenlenen tarih --->
					REPORT_ORDER_EMP,<!--- raporu düzenleyen --->
					RECORD_DATE,
					RECORD_IP,
					RECORD_EMP,
					DEVREDEN,
					DETAIL,
					BANKAYA_YATAN,
					DEVREDEN_IN<!--- dünden kalan --->
				)
				VALUES
				(
					#attributes.report_date#,
					#attributes.branch_id#,
					<cfif len(report_emp_id)>#report_emp_id#,<cfelse>NULL,</cfif>
					#now()#,
					'#cgi.remote_addr#',
					#session.ep.userid#,
					<cfif len(attributes.summary_genel_kalan)>#attributes.summary_genel_kalan#,<cfelse>0,</cfif>
					<cfif len(attributes.ek_info)>'#attributes.ek_info#',<cfelse>NULL,</cfif>
					<cfif len(attributes.bankaya_yatan)>#attributes.bankaya_yatan#,<cfelse>0,</cfif>
					<cfif len(attributes.kalan_eski)>#attributes.kalan_eski#<cfelse>0</cfif>
				)
		</cfquery>
		<cfquery name="GET_MAX_ID" datasource="#DSN2#">
			SELECT MAX(STORE_REPORT_ID) AS STORE_REPORT_ID FROM STORE_REPORT
		</cfquery>
		<cfquery name="GET_DAILY_SALES_REPORT" datasource="#DSN2#">
			SELECT EQUIPMENT AS EQUIPMENT,POS_ID FROM #dsn3_alias#.POS_EQUIPMENT WHERE BRANCH_ID = #attributes.branch_id# AND IS_STATUS = 1 ORDER BY POS_ID
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
						'#session.ep.money#',
						<cfif len(form_employee) and len(form_employee_id)>#form_employee_id#,<cfelse>NULL,</cfif>
						<cfif len(form_open_cash)>#form_open_cash#,<cfelse>0,</cfif>
						<cfif len(form_given_money)>#form_given_money#,<cfelse>NULL,</cfif>
						<cfif len(attributes.report_date)>#attributes.report_date#,<cfelse>NULL,</cfif>
						#attributes.branch_id#,
						<cfif len(form_pos_no)>'#form_pos_no#',<cfelse>NULL,</cfif>
						#get_max_id.STORE_REPORT_ID#,
						<cfif len(form_z_no)>'#form_z_no#',<cfelse>NULL,</cfif>
						<cfif len(form_pos_id)>#form_pos_id#,<cfelse>NULL,</cfif>
						#SESSION.EP.USERID#,
						#NOW()#,
						'#CGI.REMOTE_ADDR#'
					)
			</cfquery>
		</cfloop>
		<cfquery name="GET_CREDIT_PAYMENT" datasource="#dsn2#">
			SELECT PAYMENT_TYPE_ID,CARD_NO,NUMBER_OF_INSTALMENT,SERVICE_RATE,OTHER_COMISSION_RATE,IS_COMISSION FROM #dsn3_alias#.CREDITCARD_PAYMENT_TYPE WHERE IS_ACTIVE = 1 ORDER BY CARD_NO
		</cfquery>
		<cfloop query="get_credit_payment">
			<cfscript>
				form_bank_branch_id = evaluate("attributes.bank_branch_id#currentrow#");
				form_number_of_operation = evaluate("attributes.number_of_operation#currentrow#");
				form_sales_credit = evaluate("attributes.sales_credit#currentrow#");
				form_puanli_pesin = evaluate("attributes.puanli_pesin#currentrow#");
				form_puanli = evaluate("attributes.puanli#currentrow#");
				
				total_service_rate = 0;
				total_other_comission_rate = 0;
				taksit_miktar = 0;
				form_toplam_puan = ( form_sales_credit + form_puanli - form_puanli_pesin);
			</cfscript>
				<cfquery name="ADD_STORE_BANK_POS" datasource="#DSN2#">
					INSERT
					INTO
						STORE_POS_BANK
						(
							BANK_ID,<!--- ödeme yöntemi id si --->
							SALES_CREDIT,
							SALES_TAKSIT,<!--- işlem sayısı --->
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
							'#session.ep.money#',
							'#session.ep.money#',
							#attributes.branch_id#,
							<cfif len(attributes.report_date)>#attributes.report_date#,<cfelse>NULL,</cfif>
							#get_max_id.store_report_id#,
							0,<!--- şimdilik kapatıldı   <cfif len(form_puanli_pesin)>#form_puanli_pesin#,<cfelse>0,</cfif> --->
							0,<!--- şimdilik kapatıldı  <cfif len(form_puanli)>#form_puanli#,<cfelse>0,</cfif> --->
							#SESSION.EP.USERID#,
							'#CGI.REMOTE_ADDR#',
							#NOW()#
						)
				</cfquery>
				<!---İlerleyen zamanlarda düzenlenecek,şimdilik ksadece kendi tablolarına kayıt atıcaz <cfquery name="GET_MAX_BANK_POS" datasource="#DSN2#">
					SELECT MAX(STORE_BANK_POS_ID) AS MAX_ID FROM STORE_POS_BANK
				</cfquery>
				<cfif form_sales_credit gt 0>
					<cfquery name="ADD_CREDIT_CARD_BANK_PAYMENTS" datasource="#DSN2#">
						INSERT
						INTO
							#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS
						(
							BANK_POS_ID,<!--- şuba kasa raporundan ara tablodaki id --->
							PAYMENT_TYPE_ID,<!--- ödeme yöntem idsi --->
							STORE_REPORT_DATE,
							NUMBER_OF_OPERATION,<!--- işlem sayısı --->
							SALES_CREDIT,
							PUANLI_PESIN,
							PUANLI,
							TOPLAM_PUAN,
							NUMBER_OF_INSTALMENT,
							HIZMET_KOMISYON_ORANI,
							DIGER_KOMISYON_ORANI,
							TAKSIT_TUTAR,
							RECORD_EMP,
							RECORD_DATE,
							RECORD_IP,
							STORE_REPORT_ID,
							SERVICE_RATE,
							OTHER_COMISSION_RATE,
							ACTION_PERIOD_ID
						)
						VALUES
						(
							<cfif len(get_max_bank_pos.max_id)>#get_max_bank_pos.max_id#,<cfelse>NULL,</cfif>
							<cfif len(form_bank_branch_id)>#form_bank_branch_id#,<cfelse>NULL,</cfif>
							#attributes.report_date#,
							#form_number_of_operation#,
							#form_sales_credit#,
							0,<!---şimdilik kapatıldı   #form_puanli_pesin#, --->
							0,<!---şimdilik kapatıldı    #form_puanli#, --->
							0,<!--- şimdilik kapatıldı    #form_toplam_puan#, --->
							<cfif len(get_credit_payment.number_of_instalment)>#get_credit_payment.number_of_instalment#,<cfelse>NULL,</cfif>
							#total_service_rate#,
							#total_other_comission_rate#,
							#taksit_miktar#,
							#session.ep.userid#,
							#now()#,
							'#cgi.remote_addr#',
							#get_max_id.store_report_id#,
							<cfif len(get_credit_payment.service_rate)>#get_credit_payment.service_rate#,<cfelse>NULL,</cfif>
							<cfif len(get_credit_payment.other_comission_rate)>#get_credit_payment.other_comission_rate#,<cfelse>NULL,</cfif>
							#session.ep.period_id#
						)
					</cfquery>
				</cfif> --->
		</cfloop>
		<!--- İlerleyen zamanlarda düzenlenecek,şimdilik ksadece kendi tablolarına kayıt atıcaz <cfquery name="GET_CREDIT_CARD_BANK_PAYMENT" datasource="#DSN2#">
			SELECT NUMBER_OF_INSTALMENT, PUANLI, BANK_POS_ID, PAYMENT_TYPE_ID, PUANLI_PESIN, STORE_REPORT_DATE, TAKSIT_TUTAR, STORE_REPORT_ID, CREDITCARD_PAYMENT_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE STORE_REPORT_ID = #get_max_id.store_report_id# AND ACTION_PERIOD_ID = #session.ep.period_id#
		</cfquery>
		<cfloop query="get_credit_card_bank_payment">
			<cfif len(get_credit_card_bank_payment.number_of_instalment)>
				<cfif get_credit_card_bank_payment.number_of_instalment gt 0>
					<cfset loop_count = 2 + get_credit_card_bank_payment.number_of_instalment>
				<cfelse>
					<cfset loop_count = 3>
				</cfif>
				<cfloop from="1" to="#loop_count#" index="i">
					<cfscript>
						if (i eq 1) { type = 'Puan Satış'; }
						if (i eq 2) { type = 'Verilen Puan'; }
						if ((loop_count eq 3) and (i eq 3)) { type = 'Peşin'; }
						if ((loop_count gt 3) and (i gt 2)) { type = '#i-2#. Taksit'; }
						if (i eq  1) { operation = 'Giriş'; taksit_miktari = get_credit_card_bank_payment.puanli; }
						if (i eq  2) { operation = 'Çıkış'; taksit_miktari = get_credit_card_bank_payment.puanli_pesin; }
						if (i gte 3) { operation = 'Giriş'; taksit_miktari = get_credit_card_bank_payment.taksit_tutar; }
					</cfscript>
					<cfquery name="ADD_CREDIT_CARD_BANK_PAYMENT_ROWS" datasource="#DSN2#">
						INSERT
						INTO
							#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS
							(
								STORE_REPORT_DATE,
								STORE_REPORT_ID,
								CREDITCARD_PAYMENT_ID,
								BANK_POS_ID,
								PAYMENT_TYPE_ID,
								TYPE,
								OPERATION_NAME,
								AMOUNT
							)
						VALUES
							(
								'#get_credit_card_bank_payment.store_report_date#',
								#get_credit_card_bank_payment.store_report_id#,
								#get_credit_card_bank_payment.creditcard_payment_id#,
								#get_credit_card_bank_payment.bank_pos_id#,
								#get_credit_card_bank_payment.payment_type_id#,
								'#type#',
								'#operation#',
								#taksit_miktari#
							)
					</cfquery>
				</cfloop>
			</cfif>
		</cfloop> --->
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
								<cfif len(form_detail)>'#form_detail#',<cfelse>NULL,</cfif>
								<cfif len(form_expense_total)>'#form_expense_total#',<cfelse>0,</cfif>
								<cfif len(attributes.form_money_type)>'#attributes.form_money_type#',<cfelse>NULL,</cfif>
								#attributes.branch_id#,
								<cfif len(attributes.report_date)>#attributes.report_date#,<cfelse>NULL,</cfif>
								#get_max_id.store_report_id#,
								#SESSION.EP.USERID#,
								'#CGI.REMOTE_ADDR#',
								#NOW()#,
								<cfif len(form_payment_tax)>'#form_payment_tax#',<cfelse>NULL,</cfif>
								<cfif len(form_payment_net_total_tax)>#form_payment_net_total_tax#,<cfelse>0,</cfif>
								<cfif len(form_payment_net_total)>#form_payment_net_total#<cfelse>0</cfif>
							)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		<cfif len(attributes.income_record_num) and (attributes.income_record_num neq "")>
			<cfloop from="1" to="#attributes.income_record_num#" index="i">
			<cfif evaluate("attributes.income_row_kontrol#i#")>
				<cfscript>
					form_income_detail = evaluate("attributes.income_detail#i#");
					form_income_payment_tax = evaluate("attributes.income_payment_tax#i#");
					form_income_expense_total = evaluate("attributes.income_expense_total#i#");
					form_income_money_type = evaluate("attributes.income_money_type#i#");
					attributes.form_income_money_type = listgetat(form_income_money_type, 1, ',');
					form_income_payment_type = evaluate("attributes.income_payment_type#i#");
					form_income_payment_net_total_tax = evaluate("attributes.income_payment_net_total_tax#i#");
					form_income_payment_net_total = evaluate("attributes.income_payment_net_total#i#");
				</cfscript>
				<cfquery name="ADD_EXPENSE" datasource="#DSN2#">
					INSERT
						INTO
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
							<cfif len(form_income_payment_type)>#form_income_payment_type#,<cfelse>null,</cfif>
							<cfif len(form_income_detail)>'#form_income_detail#',<cfelse>null,</cfif>
							<cfif len(form_income_expense_total)>'#form_income_expense_total#',<cfelse>0,</cfif>
							<cfif len(attributes.form_income_money_type)>'#attributes.form_income_money_type#',<cfelse>null,</cfif>
							#attributes.branch_id#,
							<cfif len(attributes.report_date)>#attributes.report_date#,<cfelse>null,</cfif>
							#get_max_id.store_report_id#,
							#SESSION.EP.USERID#,
							'#CGI.REMOTE_ADDR#',
							#NOW()#,
							<cfif len(form_income_payment_tax)>'#form_income_payment_tax#',<cfelse>null,</cfif>
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
	window.location.href = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_stores_daily_reports&event=upd&id=#get_max_id.store_report_id#</cfoutput>';
</script>

