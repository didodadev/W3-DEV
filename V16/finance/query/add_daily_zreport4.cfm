<cfif isdefined("attributes.is_pos") and len(attributes.is_pos) and isdefined("attributes.record_num2")>
	<cfloop from="1" to="#attributes.record_num2#" index="pos_sira">
		<cfif evaluate('attributes.row_kontrol_2#pos_sira#') and evaluate('attributes.pos_amount_#pos_sira#') gt 0>
			<cfscript>
				action_to_account_id_first = listfirst(evaluate('attributes.POS_#pos_sira#'),';');
				account_currency_id = listgetat(evaluate('attributes.POS_#pos_sira#'),2,';');
				payment_type_id = listgetat(evaluate('attributes.POS_#pos_sira#'),3,';');
				temp_pos_tutar = evaluate('attributes.pos_amount_#pos_sira#');
				to_branch_id = ListGetAt(session.ep.user_location,2,"-");
			</cfscript>
			<cfquery name="GET_CREDIT_PAYMENT" datasource="#dsn2#">
				SELECT 
					PAYMENT_TYPE_ID, 
					NUMBER_OF_INSTALMENT, 
					P_TO_INSTALMENT_ACCOUNT,
					ACCOUNT_CODE,
					SERVICE_RATE,
					IS_PESIN
				FROM 
					#dsn3_alias#.CREDITCARD_PAYMENT_TYPE 
				WHERE 
					PAYMENT_TYPE_ID = #payment_type_id#
			</cfquery>
			<!--- Ödeme yöntemindeki hesaba geçiş gününe göre vade hesaplanıyor --->
			<cfif get_credit_payment.recordcount and len(get_credit_payment.p_to_instalment_account)>
				<cfset due_value_date = date_add("d",get_credit_payment.p_to_instalment_account,attributes.invoice_date)>
			<cfelse>
				<cfset due_value_date = attributes.action_date>
			</cfif> 
			<cfif len(GET_CREDIT_PAYMENT.SERVICE_RATE) and GET_CREDIT_PAYMENT.SERVICE_RATE neq 0>
				<!--- ödeme yöntemindeki seçilen hizmet komisyon çarpanına göre komisyon oranı hesaplanır --->
				<cfset commission_multiplier_amount = wrk_round(temp_pos_tutar * GET_CREDIT_PAYMENT.SERVICE_RATE /100)>
			<cfelse>
				<cfset commission_multiplier_amount = 0>
			</cfif>
			<cfset credit_currency_multiplier = ''>
			<cfif isDefined('attributes.kur_say') and len(attributes.kur_say)>
				<cfloop from="1" to="#attributes.kur_say#" index="mon">
					<cfif evaluate("attributes.hidden_rd_money_#mon#") is form.basket_money>
						<cfset credit_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#')>
					</cfif>
					<cfif evaluate("attributes.hidden_rd_money_#mon#") is account_currency_id>
						<cfset credit_currency_multiplier2 = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#')>
					</cfif>
				</cfloop>	
			</cfif>
			<cfquery name="ADD_CREDIT_PAYMENT" datasource="#dsn2#" result="MAX_ID">
				INSERT INTO
					#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS
				(
					PROCESS_CAT,
					ACTION_TYPE_ID,
					WRK_ID,
					PAYMENT_TYPE_ID,<!--- ödeme yöntemi --->
					NUMBER_OF_INSTALMENT,<!--- ödeme yöntemi taksit sayısı --->
					ACTION_TO_ACCOUNT_ID,<!--- ödeme yöntmiyle seçilen hesap --->
					ACTION_CURRENCY_ID,<!--- hesap para birimi --->
					STORE_REPORT_DATE,<!--- işlem tarihi --->
					SALES_CREDIT,<!--- işlem tutarı --->
					COMMISSION_AMOUNT,<!--- ödeme yöntemindeki hizmet komisyon ORANIYLA yapılmış olan komsiyon tutarı--->
					ACTION_TYPE,
					OTHER_CASH_ACT_VALUE,
					OTHER_MONEY,
					IS_ACCOUNT,
					IS_ACCOUNT_TYPE,
					ACTION_PERIOD_ID,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP,
					TO_BRANCH_ID
				)
				VALUES
				(
					#FORM.PROCESS_CAT#,
					#INVOICE_CAT#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
					#payment_type_id#,
					<cfif len(get_credit_payment.number_of_instalment)>#get_credit_payment.number_of_instalment#,<cfelse>NULL,</cfif>
					#action_to_account_id_first#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#account_currency_id#">,
					#attributes.invoice_date#,
					#evaluate('attributes.pos_amount_#pos_sira#')#,
					#commission_multiplier_amount#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="KREDİ KARTI TAHSİLAT (Z Raporu)">,
					#wrk_round(evaluate('attributes.pos_amount_#pos_sira#')*credit_currency_multiplier2/credit_currency_multiplier)#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.basket_money#">,
					<cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
					#session.ep.period_id#,
					#session.ep.userid#,
					#now()#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">	,
					#ListGetAt(session.ep.user_location,2,"-")#						
				)
			</cfquery>
            <cfset GET_MAX.MAX_ID = MAX_ID.IDENTITYCOL>
			<cfloop from="1" to="#attributes.kur_say#" index="j">
				<cfquery name="ADD_CREDIT_MONEY" datasource="#dsn2#">
					INSERT INTO
						#dsn3_alias#.CREDIT_CARD_BANK_PAYMENT_MONEY
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					VALUES
					(
						#GET_MAX.MAX_ID#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval("attributes.hidden_rd_money_#j#")#">,
						#evaluate("attributes.txt_rate2_#j#")#,
						#evaluate("attributes.txt_rate1_#j#")#,
						<cfif evaluate("attributes.hidden_rd_money_#j#") is account_currency_id>1<cfelse>0</cfif>
					)
				</cfquery>
			</cfloop>
			<cfquery name="GET_CREDIT_CARD_BANK_PAYMENT" datasource="#DSN2#">
				SELECT 
					SALES_CREDIT,
					COMMISSION_AMOUNT,
					PAYMENT_TYPE_ID,
					STORE_REPORT_DATE,
					CREDITCARD_PAYMENT_ID
				FROM 
					#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS 
				WHERE 
					CREDITCARD_PAYMENT_ID = #get_max.max_id#
			</cfquery>
	
			<!--- işlem tarihi üstüne hesaba geçiş tarihi eklenerek rowlara yazılır --->
			<cfset bank_action_date = date_add("d", GET_CREDIT_PAYMENT.P_TO_INSTALMENT_ACCOUNT,GET_CREDIT_CARD_BANK_PAYMENT.STORE_REPORT_DATE)>
			<cfif (GET_CREDIT_PAYMENT.IS_PESIN eq 1) or (not len(GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT)) or (GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT eq 0)>
				<cfset satir_sayisi = 1>
				<cfset operation_type = 'Peşin Giriş'>
				<cfset tutar = GET_CREDIT_CARD_BANK_PAYMENT.SALES_CREDIT>
				<cfif (GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT) gt 0>
					<cfset komsiyon_tutar = GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT>
				<cfelse>
					<cfset komsiyon_tutar = 0>
				</cfif>
			<cfelse>
				<cfset satir_sayisi = GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT>
				<cfset tutar = (GET_CREDIT_CARD_BANK_PAYMENT.SALES_CREDIT/GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT)>
				<cfif (GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT) gt 0>
					<cfset komsiyon_tutar = (GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT/GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT)>
				<cfelse>
					<cfset komsiyon_tutar = 0>
				</cfif>
			</cfif>
			<cfloop from="1" to="#satir_sayisi#" index="i">
				<cfquery name="ADD_CREDIT_CARD_BANK_PAYMENT_ROWS" datasource="#dsn2#">
					INSERT INTO
						#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS
					(
						STORE_REPORT_DATE,<!--- tahsilat işlem tarihi --->
						BANK_ACTION_DATE,<!--- hesaba geçiş tarihi --->
						CREDITCARD_PAYMENT_ID,<!--- tahsilat id si --->
						PAYMENT_TYPE_ID,<!--- ödeme yöntemi id si --->
						OPERATION_NAME,
						AMOUNT,<!--- işlem tutarı --->
						COMMISSION_AMOUNT<!--- komsiyon tutarı --->
					)
					VALUES
					(
						#CreateODBCDateTime(GET_CREDIT_CARD_BANK_PAYMENT.STORE_REPORT_DATE)#,
						#bank_action_date#,
						#GET_CREDIT_CARD_BANK_PAYMENT.CREDITCARD_PAYMENT_ID#,
						#GET_CREDIT_CARD_BANK_PAYMENT.PAYMENT_TYPE_ID#,
						<cfif isDefined("operation_type")><cfqueryparam cfsqltype="cf_sql_varchar" value="#operation_type#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#i#. Taksit"></cfif>,
						#tutar#,
						#komsiyon_tutar#
					)
				</cfquery>
				<cfset bank_action_date = date_add("m",1,bank_action_date)>
			</cfloop>
			<cfquery name="ADD_INVOICE_CASH_POS" datasource="#dsn2#">
				INSERT INTO 
					INVOICE_CASH_POS
				(
					INVOICE_ID,
					POS_ID,
					POS_ACTION_ID,
					POS_PERIOD_ID
				)
				VALUES
				(
					#get_invoice_id.max_id#,
					#payment_type_id#,
					#get_max.max_id#,
					#session.ep.period_id#
				)
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
