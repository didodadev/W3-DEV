<!--- 
	Kayıt Atacağı Yerler 
	2- Kredi Kartı Dökümü ve Satırları 
	3- Muhasebe Hareketleri 
	4- Cari Hareketler  
	5-INVOICE_CASH_POS tablosu
--->
<cfinclude template = "../../objects/query/session_base.cfm">
<cfloop from="1" to="5" index="pos_sira">
	<cfif isdefined("attributes.pos_amount_#pos_sira#") and filterNum(evaluate('attributes.pos_amount_#pos_sira#')) gt 0>
		<cfscript>
			action_to_account_id_first = listfirst(evaluate('attributes.POS_#pos_sira#'),';');
			account_currency_id = listgetat(evaluate('attributes.POS_#pos_sira#'),2,';');
			payment_type_id = listgetat(evaluate('attributes.POS_#pos_sira#'),3,';');
			temp_pos_tutar = evaluate('attributes.pos_amount_#pos_sira#');
			to_branch_id = ListGetAt(session_base.user_location,2,"-");
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
			INSERT
			INTO
				#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS
				(
					PROCESS_CAT,
					ACTION_TYPE_ID,
					WRK_ID,
					PAYMENT_TYPE_ID,<!--- ödeme yöntemi --->
					NUMBER_OF_INSTALMENT,<!--- ödeme yöntemi taksit sayısı --->
					ACTION_TO_ACCOUNT_ID,<!--- ödeme yöntmiyle seçilen hesap --->
					ACTION_CURRENCY_ID,<!--- hesap para birimi --->
					ACTION_FROM_COMPANY_ID,
					PARTNER_ID,
					CONSUMER_ID,
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
					<cfif isdefined("attributes.company_id") and len(attributes.company_id)>#attributes.company_id#,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>
					#attributes.invoice_date#,
					#temp_pos_tutar#,
					#commission_multiplier_amount#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="KREDİ KARTI TAHSİLAT (Per)">,
					#wrk_round(temp_pos_tutar)*credit_currency_multiplier2/credit_currency_multiplier#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.basket_money#">,
					<cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
					#session_base.period_id#,
					#session_base.userid#,
					#now()#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					#ListGetAt(session_base.user_location,2,"-")#						
				)
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
						#MAX_ID.IDENTITYCOL#,
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
				CREDITCARD_PAYMENT_ID = #MAX_ID.IDENTITYCOL#
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
				INSERT
				INTO
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
			INSERT INTO INVOICE_CASH_POS
				(
					INVOICE_ID,
					POS_ID,<!--- artık pos_id degilde,ödeme yöntemi id tutulcak --->
					POS_ACTION_ID,
					POS_PERIOD_ID
				)
			VALUES
				(
					#get_invoice_id.max_id#,
					#payment_type_id#,
					#MAX_ID.IDENTITYCOL#,
					#session_base.period_id#
				)
		</cfquery>
		<cfscript>
			if(is_cari eq 1)
			{
				if(account_currency_id is session_base.money)
				{
					carici
					(
						action_id : MAX_ID.IDENTITYCOL,
						action_table : 'CREDIT_CARD_BANK_PAYMENTS',
						workcube_process_type : 241,		
						process_cat : form.process_cat,	
						islem_tarihi : attributes.invoice_date,
						due_date : due_value_date,
						islem_belge_no : FORM.INVOICE_NUMBER,
						to_account_id : action_to_account_id_first,
						islem_tutari : temp_pos_tutar,
						other_money_value : wrk_round(temp_pos_tutar)/credit_currency_multiplier,
						other_money : form.basket_money,			
						action_currency : session_base.money,									
						islem_detay : 'KREDİ KARTI TAHSİLAT (Per)',
						action_detail : note,
						account_card_type : 13,
						from_cmp_id : attributes.company_id,
						from_consumer_id : attributes.consumer_id,
						currency_multiplier : attributes.currency_multiplier,
						to_branch_id : to_branch_id,
						rate2:paper_currency_multiplier
					);
				}
				else
				{
					carici
					(
						action_id : MAX_ID.IDENTITYCOL,
						action_table : 'CREDIT_CARD_BANK_PAYMENTS',
						workcube_process_type : 241,		
						process_cat : form.process_cat,	
						islem_tarihi : attributes.invoice_date,
						due_date : due_value_date,
						islem_belge_no : FORM.INVOICE_NUMBER,
						to_account_id : action_to_account_id_first,
						islem_tutari :  wrk_round(temp_pos_tutar)*credit_currency_multiplier,
						other_money : account_currency_id,
						other_money_value: temp_pos_tutar,
						action_currency : session_base.money ,									
						islem_detay : 'KREDİ KARTI TAHSİLAT (Per)',
						action_detail : note,
						account_card_type : 13,
						from_cmp_id : attributes.company_id,
						from_consumer_id : attributes.consumer_id,
						currency_multiplier : attributes.currency_multiplier,
						to_branch_id : to_branch_id
					);
				}
			}
		if (is_account eq 1)
		{
			if(account_currency_id is session_base.money)
			{

				muhasebeci (
					action_id: MAX_ID.IDENTITYCOL,
					workcube_process_type: 241,
					account_card_type: 13,
					company_id : attributes.company_id,
					consumer_id : attributes.consumer_id,
					islem_tarihi: attributes.invoice_date,
					fis_satir_detay: 'KREDİ KARTI TAHSİLAT (Per)',
					borc_hesaplar: GET_CREDIT_PAYMENT.account_code,
					borc_tutarlar: temp_pos_tutar,
					other_amount_borc : temp_pos_tutar,
					other_currency_borc : account_currency_id,
					alacak_hesaplar: ACC,
					alacak_tutarlar: temp_pos_tutar,
					other_amount_alacak : temp_pos_tutar,
					other_currency_alacak : account_currency_id,
					belge_no : form.invoice_number,
					fis_detay: 'KREDİ KARTI TAHSİLAT (Per)',
					currency_multiplier : attributes.currency_multiplier,
					to_branch_id : to_branch_id
					);		
			}
			else
			{
				muhasebeci (
					action_id: MAX_ID.IDENTITYCOL,
					workcube_process_type: 241,
					account_card_type: 13,
					company_id : attributes.company_id,
					consumer_id : attributes.consumer_id,
					islem_tarihi: attributes.invoice_date,
					fis_satir_detay: 'KREDİ KARTI TAHSİLAT (Per)',
					borc_hesaplar: GET_CREDIT_PAYMENT.account_code,
					borc_tutarlar: filterNum(evaluate("system_pos_amount_#pos_sira#")),
					other_amount_borc : temp_pos_tutar,
					other_currency_borc : account_currency_id,
					alacak_hesaplar: ACC,
					alacak_tutarlar: filterNum(evaluate("system_pos_amount_#pos_sira#")),
					other_amount_alacak : temp_pos_tutar,
					other_currency_alacak : account_currency_id,
					belge_no : form.invoice_number,
					fis_detay: 'KREDİ KARTI TAHSİLAT (Per)',
					currency_multiplier : attributes.currency_multiplier,
					to_branch_id : to_branch_id
					);		
			}
		}
		</cfscript>
	</cfif>
</cfloop>
