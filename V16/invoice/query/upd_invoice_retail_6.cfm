<!--- 
	Kayıt Atacağı Yerler 
	2- Kredi Kartı Dökümü ve Satırları 
	3- Muhasebe Hareketleri 
	4- Cari Hareketler  
	5- INVOICE_CASH_POS tablosu
--->
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cfif isdefined("attributes.is_pos") and len(attributes.is_pos)>
	<cfloop from="1" to="5" index="kp">
		<cfif evaluate('attributes.pos_amount_#kp#') gt 0>
			<cfscript>
				action_to_account_id_first = listfirst(evaluate('attributes.POS_#kp#'),';');
				account_currency_id = listgetat(evaluate('attributes.POS_#kp#'),2,';');
				payment_type_id = listgetat(evaluate('attributes.POS_#kp#'),3,';');
				temp_pos_tutar = evaluate('attributes.pos_amount_#kp#');
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
			<cfif len(evaluate('pos_action_id_#kp#'))>
				<cfquery name="UPD_CREDIT_PAYMENT" datasource="#dsn2#">
					UPDATE
						#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS
					SET
						PROCESS_CAT=#FORM.PROCESS_CAT#,
						ACTION_TYPE_ID = #INVOICE_CAT#,
						PAYMENT_TYPE_ID = #payment_type_id#,<!--- ödeme yöntemi --->
						NUMBER_OF_INSTALMENT = <cfif len(get_credit_payment.number_of_instalment)>#get_credit_payment.number_of_instalment#,<cfelse>NULL,</cfif><!--- ödeme yöntemi taksit sayısı --->
						ACTION_TO_ACCOUNT_ID = #action_to_account_id_first#,<!--- ödeme yöntmiyle seçilen hesap --->
						ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#account_currency_id#">,<!--- hesap para birimi --->
						ACTION_FROM_COMPANY_ID = <cfif isdefined("attributes.company_id") and len(attributes.company_id)>#attributes.company_id#,<cfelse>NULL,</cfif>
						PARTNER_ID = <cfif len(attributes.partner_id)>#attributes.partner_id#,<cfelse>NULL,</cfif>
						CONSUMER_ID = <cfif len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>
						STORE_REPORT_DATE = #attributes.invoice_date#,
						SALES_CREDIT = #temp_pos_tutar#,
						COMMISSION_AMOUNT = #commission_multiplier_amount#,<!--- ödeme yöntemindeki hizmet komisyon ORANIYLA yapılmış olan komsiyon tutarı--->
						ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="KREDİ KARTI TAHSİLAT (Per)">,
						<cfif is_account eq 1>IS_ACCOUNT = 1,IS_ACCOUNT_TYPE = 13,<cfelse>IS_ACCOUNT = 0,IS_ACCOUNT_TYPE = 13,</cfif>
						ACTION_PERIOD_ID = #session.ep.period_id#,
						OTHER_CASH_ACT_VALUE = #wrk_round(evaluate('attributes.pos_amount_#kp#')*credit_currency_multiplier2/credit_currency_multiplier)#,
						OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.basket_money#">,
						UPDATE_EMP = #session.ep.userid#,
						UPDATE_DATE = #now()#,
						UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					WHERE
						CREDITCARD_PAYMENT_ID=#evaluate('pos_action_id_#kp#')#
				</cfquery>
				<cfquery name="UPD_INVOICE_CASH_POS" datasource="#dsn2#">
					UPDATE 
						INVOICE_CASH_POS
					SET
						POS_ID = #payment_type_id#
					WHERE
						POS_ACTION_ID=#evaluate('pos_action_id_#kp#')# AND
						INVOICE_ID=#form.invoice_id# AND
						POS_PERIOD_ID = #session.ep.period_id#
				</cfquery>
				<cfquery name="DEL_CARD_ROWS" datasource="#dsn2#">
					DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS WHERE CREDITCARD_PAYMENT_ID = #evaluate('pos_action_id_#kp#')#
				</cfquery>
				<cfset GET_MAX_CC_PAYMENTS.MAX_PAYMENT_ID=evaluate('pos_action_id_#kp#')>
			<cfelse>
				<cfquery name="ADD_CREDIT_PAYMENT" datasource="#dsn2#">
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
							IS_ACCOUNT,
							IS_ACCOUNT_TYPE,
							OTHER_CASH_ACT_VALUE,
							OTHER_MONEY,
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
							#evaluate('attributes.pos_amount_#kp#')#,
							#commission_multiplier_amount#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="KREDİ KARTI TAHSİLAT (Per)">,
							<cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
							#wrk_round(evaluate('attributes.pos_amount_#kp#')*credit_currency_multiplier2/credit_currency_multiplier)#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.basket_money#">,
							#session.ep.period_id#,
							#session.ep.userid#,
							#now()#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							#ListGetAt(session.ep.user_location,2,"-")#					
						)
				</cfquery>
				<cfquery name="GET_MAX_CC_PAYMENTS" datasource="#dsn2#">
					SELECT MAX(CREDITCARD_PAYMENT_ID) AS MAX_PAYMENT_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE WRK_ID = '#wrk_id#'
				</cfquery>
				<cfquery name="ADD_INVOICE_CASH_POS" datasource="#dsn2#">
					INSERT INTO INVOICE_CASH_POS
						(
							INVOICE_ID,
							POS_ID,
							POS_ACTION_ID,
							POS_PERIOD_ID
						)
					VALUES
						(
							#form.invoice_id#,
							#payment_type_id#,
							#GET_MAX_CC_PAYMENTS.MAX_PAYMENT_ID#,
							#session.ep.period_id#
						)
				</cfquery>
			</cfif>
			<cfquery name="DEL_PAYMENT_MONEY" datasource="#dsn2#">
				DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENT_MONEY WHERE ACTION_ID = #GET_MAX_CC_PAYMENTS.MAX_PAYMENT_ID#
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
							#GET_MAX_CC_PAYMENTS.MAX_PAYMENT_ID#,
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
					CREDITCARD_PAYMENT_ID = #GET_MAX_CC_PAYMENTS.MAX_PAYMENT_ID#
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
			<cfscript>
			if(is_cari eq 1)
			{
				if(account_currency_id is session.ep.money)
				{
					carici
					(
						action_id : GET_MAX_CC_PAYMENTS.MAX_PAYMENT_ID,
						action_table : 'CREDIT_CARD_BANK_PAYMENTS',
						workcube_process_type : 241,		
						workcube_old_process_type : 241,
						process_cat : form.process_cat,	
						islem_tarihi : attributes.invoice_date,
						due_date : due_value_date,
						islem_belge_no : FORM.INVOICE_NUMBER,
						to_account_id : action_to_account_id_first,
						islem_tutari : temp_pos_tutar,
						other_money_value : wrk_round(evaluate('attributes.pos_amount_#kp#')/credit_currency_multiplier),
						other_money : form.basket_money,			
						action_currency : session.ep.money,									
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
						action_id : GET_MAX_CC_PAYMENTS.MAX_PAYMENT_ID,
						action_table : 'CREDIT_CARD_BANK_PAYMENTS',
						workcube_process_type : 241,		
						workcube_old_process_type : 241,
						process_cat : form.process_cat,	
						islem_tarihi : attributes.invoice_date,
						due_date : due_value_date,
						islem_belge_no : FORM.INVOICE_NUMBER,
						to_account_id : action_to_account_id_first,
						islem_tutari :  wrk_round(evaluate('attributes.pos_amount_#kp#')*credit_currency_multiplier2),
						other_money : account_currency_id,
						other_money_value: evaluate('attributes.pos_amount_#kp#'),
						action_currency : session.ep.money ,									
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
			else
				cari_sil(action_id:GET_MAX_CC_PAYMENTS.MAX_PAYMENT_ID, process_type:241);
				
			if (is_account eq 1)
			{
				if(account_currency_id is session.ep.money)
				{
	
					muhasebeci (
						action_id: GET_MAX_CC_PAYMENTS.MAX_PAYMENT_ID,
						workcube_process_type: 241,
						workcube_old_process_type :241,
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
						action_id: GET_MAX_CC_PAYMENTS.MAX_PAYMENT_ID,
						workcube_process_type: 241,
						workcube_old_process_type :241,
						account_card_type: 13,
						company_id : attributes.company_id,
						consumer_id : attributes.consumer_id,
						islem_tarihi: attributes.invoice_date,
						fis_satir_detay: 'KREDİ KARTI TAHSİLAT (Per)',
						borc_hesaplar: GET_CREDIT_PAYMENT.account_code,
						borc_tutarlar: evaluate("system_pos_amount_#kp#"),
						other_amount_borc : temp_pos_tutar,
						other_currency_borc : account_currency_id,
						alacak_hesaplar: ACC,
						alacak_tutarlar: evaluate("system_pos_amount_#kp#"),
						other_amount_alacak : temp_pos_tutar,
						other_currency_alacak : account_currency_id,
						belge_no : form.invoice_number,
						fis_detay: 'KREDİ KARTI TAHSİLAT (Per)',
						currency_multiplier : attributes.currency_multiplier,
						to_branch_id : to_branch_id
						);		
				}
			}
			else
				muhasebe_sil(action_id:GET_MAX_CC_PAYMENTS.MAX_PAYMENT_ID, process_type:241);
			</cfscript>
		<cfelse>
			<cfif len(evaluate('pos_action_id_#kp#'))>
				<cfquery name="DEL_CARD" datasource="#dsn2#">
					DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE CREDITCARD_PAYMENT_ID = #evaluate('pos_action_id_#kp#')#
				</cfquery>
				<cfquery name="DEL_CARD_ROWS" datasource="#dsn2#">
					DELETE FROM
						#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS
					WHERE
						CREDITCARD_PAYMENT_ID = #evaluate('pos_action_id_#kp#')#
				</cfquery>
				<cfquery name="DEL_INVOICE_CASH_POS" datasource="#dsn2#">
					DELETE FROM INVOICE_CASH_POS WHERE POS_ACTION_ID = #evaluate('pos_action_id_#kp#')# AND INVOICE_ID=#form.invoice_id# AND POS_PERIOD_ID = #session.ep.period_id#
				</cfquery>
				<cfscript>
					cari_sil(action_id:evaluate('pos_action_id_#kp#'), process_type:241);
					muhasebe_sil(action_id:evaluate('pos_action_id_#kp#'), process_type:241);
				</cfscript>
			</cfif>
		</cfif>
	</cfloop>
<cfelse>
	<cfquery name="invoice_pos_detail" datasource="#dsn2#">
		SELECT POS_ID,POS_ACTION_ID,INVOICE_CASH_ID FROM INVOICE_CASH_POS WHERE INVOICE_ID=#form.invoice_id# AND POS_ID IS NOT NULL AND POS_PERIOD_ID = #session.ep.period_id#
	</cfquery>
	<cfif invoice_pos_detail.recordcount>
		<cfscript>
			for(i=1; i lte invoice_pos_detail.recordcount; i=i+1)
				{
					cari_sil(action_id:invoice_pos_detail.pos_action_id[#i#], process_type:241);
					muhasebe_sil(action_id:invoice_pos_detail.pos_action_id[#i#], process_type:241);
				}
		</cfscript>
		<cfquery name="DEL_CARD" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE CREDITCARD_PAYMENT_ID IN (#valuelist(invoice_pos_detail.POS_ACTION_ID)#)
		</cfquery>
		<cfquery name="DEL_CARD_ROWS" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS WHERE CREDITCARD_PAYMENT_ID IN (#valuelist(invoice_pos_detail.POS_ACTION_ID)#)
		</cfquery>
		<cfquery name="DEL_CASH_ACTIONS" datasource="#dsn2#">
			DELETE FROM INVOICE_CASH_POS WHERE INVOICE_ID=#form.invoice_id# AND POS_ACTION_ID IN (#valuelist(invoice_pos_detail.POS_ACTION_ID)#) AND POS_PERIOD_ID = #session.ep.period_id#
		</cfquery>
	</cfif>
</cfif>

