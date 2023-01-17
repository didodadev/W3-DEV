<cfquery name="get_pos_process_cat" datasource="#dsn2#" maxrows="1">
	SELECT IS_ACCOUNT,IS_CARI,IS_ACCOUNT_GROUP FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 241
</cfquery>
<cfif get_pos_process_cat.recordcount>
	<cfset is_account_pos = get_pos_process_cat.is_account>
	<cfset is_account_group_pos = get_pos_process_cat.is_account_group>
	<cfset is_cari_pos = get_pos_process_cat.is_cari>
<cfelse>
	<cfset is_account_pos = 1>
	<cfset is_account_group_pos = 1>
	<cfset is_cari_pos = 1>
</cfif>
<cfloop from="1" to="#attributes.record_num2#" index="pos_sira">
	<cfif isdefined("attributes.row_kontrol_2#pos_sira#") and evaluate('attributes.row_kontrol_2#pos_sira#') eq 1>
	<cfif isdefined("attributes.pos_amount_#pos_sira#") and evaluate('attributes.pos_amount_#pos_sira#') gt 0>
		<cfscript>
			action_to_account_id_first = listfirst(evaluate('attributes.POS_#pos_sira#'),';');
			account_currency_id = listgetat(evaluate('attributes.POS_#pos_sira#'),2,';');
			payment_type_id = listgetat(evaluate('attributes.POS_#pos_sira#'),3,';');
			temp_pos_tutar = evaluate('attributes.pos_amount_#pos_sira#');
			to_branch_id = listgetat(session.ep.user_location,2,"-");
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
			<cfset due_value_date = date_add("d",get_credit_payment.p_to_instalment_account,attributes.order_date)>
		<cfelse>
			<cfset due_value_date = attributes.order_date>
		</cfif> 
		<cfif len(GET_CREDIT_PAYMENT.SERVICE_RATE) and GET_CREDIT_PAYMENT.SERVICE_RATE neq 0>
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
		<cfquery name="ADD_CREDIT_PAYMENT" datasource="#dsn2#">
			INSERT
			INTO
				#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS
				(
					PROCESS_CAT,
					ACTION_TYPE_ID,
					WRK_ID,
					PAYMENT_TYPE_ID,
					NUMBER_OF_INSTALMENT,
					ACTION_TO_ACCOUNT_ID,
					ACTION_CURRENCY_ID,
					ACTION_FROM_COMPANY_ID,
					PARTNER_ID,
					CONSUMER_ID,
					STORE_REPORT_DATE,
					SALES_CREDIT,
					COMMISSION_AMOUNT,
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
					0,
					241,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
					#payment_type_id#,
					<cfif len(get_credit_payment.number_of_instalment)>#get_credit_payment.number_of_instalment#,<cfelse>NULL,</cfif>
					#action_to_account_id_first#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#account_currency_id#">,
					<cfif isdefined("attributes.company_id") and len(attributes.company_id)>#attributes.company_id#,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>
					#attributes.order_date#,
					#evaluate('attributes.pos_amount_#pos_sira#')#,
					#commission_multiplier_amount#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="KREDİ KARTI TAHSİLAT">,
					#wrk_round(evaluate('attributes.pos_amount_#pos_sira#')*credit_currency_multiplier2/credit_currency_multiplier)#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.basket_money#">,
					<cfif is_account_pos eq 1>1,13,<cfelse>0,13,</cfif>
					#session.ep.period_id#,
					#session.ep.userid#,
					#now()#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					#ListGetAt(session.ep.user_location,2,"-")#			
				)
		</cfquery>
		<cfquery name="GET_MAX" datasource="#dsn2#">
			SELECT MAX(CREDITCARD_PAYMENT_ID) AS MAX_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE WRK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">
		</cfquery>
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
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.hidden_rd_money_#j#')#">,
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
				INSERT
				INTO
					#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS
					(
						STORE_REPORT_DATE,
						BANK_ACTION_DATE,
						CREDITCARD_PAYMENT_ID,
						PAYMENT_TYPE_ID,
						OPERATION_NAME,
						AMOUNT,
						COMMISSION_AMOUNT
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
		<cfquery name="add_order_cash_pos" datasource="#dsn2#">
			INSERT INTO 
				#dsn3_alias#.ORDER_CASH_POS
				(
					ORDER_ID,
					POS_ID,
					POS_ACTION_ID
				)
			VALUES
				(
					#get_max_order.max_id#,
					#payment_type_id#,
					#get_max.max_id#
				)
		</cfquery>
		<cfscript>
			if(is_cari_pos eq 1)
			{
				if(account_currency_id is session.ep.money)
				{
					carici
					(
						action_id : get_max.max_id,
						action_table : 'CREDIT_CARD_BANK_PAYMENTS',
						workcube_process_type : 241,		
						process_cat : 0,	
						islem_tarihi : attributes.order_date,
						due_date : due_value_date,
						islem_belge_no : get_last_order.order_number,
						to_account_id : action_to_account_id_first,
						islem_tutari : temp_pos_tutar,
						other_money_value : wrk_round(evaluate('attributes.pos_amount_#pos_sira#')/credit_currency_multiplier),
						other_money : form.basket_money,			
						action_currency : session.ep.money,									
						islem_detay : 'KREDİ KARTI TAHSİLAT',
						account_card_type : 13,
						from_cmp_id : attributes.company_id,
						from_consumer_id : attributes.consumer_id,
						currency_multiplier : attributes.currency_multiplier,
						to_branch_id : to_branch_id
					);
				}
				else
				{
					carici
					(
						action_id : get_max.max_id,
						action_table : 'CREDIT_CARD_BANK_PAYMENTS',
						workcube_process_type : 241,		
						process_cat : 0,	
						islem_tarihi : attributes.order_date,
						due_date : due_value_date,
						islem_belge_no : get_last_order.order_number,
						to_account_id : action_to_account_id_first,
						islem_tutari :  wrk_round(evaluate('attributes.pos_amount_#pos_sira#')*credit_currency_multiplier),
						other_money : account_currency_id,
						other_money_value:  evaluate('attributes.pos_amount_#pos_sira#'),
						action_currency : session.ep.money ,									
						islem_detay : 'KREDİ KARTI TAHSİLAT',
						account_card_type : 13,
						from_cmp_id : attributes.company_id,
						from_consumer_id : attributes.consumer_id,
						currency_multiplier : attributes.currency_multiplier,
						to_branch_id : to_branch_id
					);
				}
			}
			if(is_account_pos eq 1)
			{
				if(account_currency_id is session.ep.money)
				{
					muhasebeci (
						action_id: get_max.max_id,
						workcube_process_type: 241,
						process_cat : 0,
						account_card_type: 13,
						company_id : attributes.company_id,
						consumer_id : attributes.consumer_id,
						islem_tarihi: attributes.order_date,
						fis_satir_detay: 'KREDİ KARTI TAHSİLAT',
						borc_hesaplar: GET_CREDIT_PAYMENT.account_code,
						borc_tutarlar: temp_pos_tutar,
						other_amount_borc : temp_pos_tutar,
						other_currency_borc : account_currency_id,
						alacak_hesaplar: ACC,
						alacak_tutarlar: temp_pos_tutar,
						other_amount_alacak : temp_pos_tutar,
						other_currency_alacak : account_currency_id,
						belge_no : get_last_order.order_number,
						fis_detay: 'KREDİ KARTI TAHSİLAT',
						currency_multiplier : attributes.currency_multiplier,
						to_branch_id : to_branch_id
						);		
				}
				else
				{
					muhasebeci (
						action_id: get_max.max_id,
						workcube_process_type: 241,
						process_cat : 0,
						account_card_type: 13,
						company_id : attributes.company_id,
						consumer_id : attributes.consumer_id,
						islem_tarihi: attributes.order_date,
						fis_satir_detay: 'KREDİ KARTI TAHSİLAT',
						borc_hesaplar: GET_CREDIT_PAYMENT.account_code,
						borc_tutarlar: evaluate("system_pos_amount_#pos_sira#"),
						other_amount_borc : temp_pos_tutar,
						other_currency_borc : account_currency_id,
						alacak_hesaplar: ACC,
						alacak_tutarlar: evaluate("system_pos_amount_#pos_sira#"),
						other_amount_alacak : temp_pos_tutar,
						other_currency_alacak : account_currency_id,
						belge_no : get_last_order.order_number,
						fis_detay: 'KREDİ KARTI TAHSİLAT',
						currency_multiplier : attributes.currency_multiplier,
						to_branch_id : to_branch_id
						);		
				}
			}
		</cfscript>
	</cfif>
	</cfif>
</cfloop>
