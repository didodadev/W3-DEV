<cfquery name="GET_STORE_REPORT" datasource="#DSN2#">
	SELECT STORE_REPORT_DATE FROM STORE_REPORT WHERE STORE_REPORT_ID = #attributes.id#
</cfquery>
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="DEL_CREDIT_CARD_PAYMENT_TYPES" datasource="#DSN2#">
			DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE STORE_REPORT_ID = #attributes.id# AND ACTION_PERIOD_ID = #session.ep.period_id#
		</cfquery>
		<cfquery name="DEL_CREDIT_CARD_PAYMENT_TYPES_ROWS" datasource="#DSN2#">
			DELETE FROM
				#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS
			WHERE
				STORE_REPORT_ID IN
				(
					SELECT STORE_REPORT_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE STORE_REPORT_ID = #attributes.id# AND ACTION_PERIOD_ID = #session.ep.period_id#
				)
		</cfquery>
		<cfquery name="GET_CREDIT_PAYMENT" datasource="#DSN2#">
			SELECT 
				CREDITCARD_PAYMENT_TYPE.PAYMENT_TYPE_ID, 
				CREDITCARD_PAYMENT_TYPE.CARD_NO,
				CREDITCARD_PAYMENT_TYPE.NUMBER_OF_INSTALMENT,
				CREDITCARD_PAYMENT_TYPE.SERVICE_RATE,
				CREDITCARD_PAYMENT_TYPE.OTHER_COMISSION_RATE,
				CREDITCARD_PAYMENT_TYPE.IS_COMISSION,
				STORE_POS_BANK.*
			FROM 
				#dsn3_alias#.CREDITCARD_PAYMENT_TYPE AS CREDITCARD_PAYMENT_TYPE,
				STORE_POS_BANK AS STORE_POS_BANK
			WHERE 
				CREDITCARD_PAYMENT_TYPE.IS_ACTIVE = 1 AND
				STORE_POS_BANK.BANK_ID = CREDITCARD_PAYMENT_TYPE.PAYMENT_TYPE_ID AND
				STORE_POS_BANK.STORE_REPORT_ID = #attributes.id# AND
				STORE_POS_BANK.SALES_CREDIT <> 0
			ORDER BY 
				CREDITCARD_PAYMENT_TYPE.CARD_NO
		</cfquery>
		<cfloop query="get_credit_payment">
			<cfscript>
				form_number_of_operation = evaluate("attributes.number_of_operation#currentrow#");
				form_sales_credit = evaluate("attributes.sales_credit#currentrow#");
				form_puanli_pesin = evaluate("attributes.puanli_pesin#currentrow#");
				form_puanli = evaluate("attributes.puanli#currentrow#");
				
				total_service_rate = 0;
				total_other_comission_rate = 0;
				taksit_miktar = 0;
				form_toplam_puan = ( form_sales_credit + form_puanli - form_puanli_pesin);
				
				if (len(get_credit_payment.service_rate)) {total_service_rate = (( get_credit_payment.service_rate * form_sales_credit) / 100);}
				if (len(get_credit_payment.other_comission_rate)) { total_other_comission_rate = ( (get_credit_payment.other_comission_rate * form_sales_credit) / 100);}
				
				if (len(get_credit_payment.number_of_instalment) and (get_credit_payment.number_of_instalment neq 0) and (get_credit_payment.is_comission eq 1)) { taksit_miktar = (( form_sales_credit + form_puanli_pesin - form_puanli - total_other_comission_rate ) / get_credit_payment.number_of_instalment);}
				if (len(get_credit_payment.number_of_instalment) and (get_credit_payment.number_of_instalment neq 0) and (get_credit_payment.is_comission eq 0)) { taksit_miktar = (( form_sales_credit + form_puanli_pesin - form_puanli ) / get_credit_payment.number_of_instalment);}
				if (len(get_credit_payment.number_of_instalment) and (get_credit_payment.number_of_instalment eq  0) and (get_credit_payment.is_comission eq 1)) { taksit_miktar = ( form_sales_credit + form_puanli_pesin - form_puanli - total_other_comission_rate );}
				if (len(get_credit_payment.number_of_instalment) and (get_credit_payment.number_of_instalment eq  0) and (get_credit_payment.is_comission eq 0)) { taksit_miktar = ( form_sales_credit + form_puanli_pesin - form_puanli );}
			</cfscript>
			<cfif form_sales_credit gt 0>
				<cfquery name="ADD_CREDIT_CARD_BANK_PAYMENTS" datasource="#DSN2#">
					INSERT
					INTO
						#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS
					(
						BANK_POS_ID,
						PAYMENT_TYPE_ID,
						STORE_REPORT_DATE,
						NUMBER_OF_OPERATION,
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
						ACTION_PERIOD_ID,
						TO_BRANCH_ID
					)
					VALUES
					(
						<cfif len(get_credit_payment.store_bank_pos_id)>#get_credit_payment.store_bank_pos_id#,<cfelse>NULL,</cfif>
						<cfif len(get_credit_payment.branch_id)>#get_credit_payment.branch_id#,<cfelse>NULL,</cfif>
						'#get_credit_payment.store_report_date#',
						#form_number_of_operation#,
						#form_sales_credit#,
						#form_puanli_pesin#,
						#form_puanli#,
						#form_toplam_puan#,
						<cfif len(get_credit_payment.number_of_instalment)>#get_credit_payment.number_of_instalment#,<cfelse>NULL,</cfif>
						#total_service_rate#,
						#total_other_comission_rate#,
						#taksit_miktar#,
						#session.ep.userid#,
						#now()#,
						'#cgi.remote_addr#',
						#attributes.id#,
						<cfif len(get_credit_payment.service_rate)>#get_credit_payment.service_rate#,<cfelse>NULL,</cfif>
						<cfif len(get_credit_payment.other_comission_rate)>#get_credit_payment.other_comission_rate#,<cfelse>NULL,</cfif>
						#session.ep.period_id#,
						#ListGetAt(session.ep.user_location,2,"-")#		
					)
				</cfquery>
			</cfif>
		</cfloop>
		<cfquery name="GET_CREDIT_CARD_BANK_PAYMENT" datasource="#DSN2#">
			SELECT NUMBER_OF_INSTALMENT, PUANLI, BANK_POS_ID, PAYMENT_TYPE_ID, PUANLI_PESIN, STORE_REPORT_DATE, TAKSIT_TUTAR, STORE_REPORT_ID, CREDITCARD_PAYMENT_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE STORE_REPORT_ID = #attributes.id# AND ACTION_PERIOD_ID = #session.ep.period_id#
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
		</cfloop>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
