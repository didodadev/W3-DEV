<cfquery name="GET_PROCESS_TYPE" datasource="#DSN3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		IS_ACCOUNT_GROUP,
		IS_BUDGET,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
	SELECT ACCOUNT_CURRENCY_ID,ACCOUNT_ACC_CODE FROM ACCOUNTS WHERE ACCOUNT_ID = #listfirst(attributes.action_from_account_id,';')#
</cfquery>
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_cari = get_process_type.IS_CARI;
	is_account = get_process_type.IS_ACCOUNT;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	is_budget = get_process_type.IS_BUDGET;
	action_from_account_id = listfirst(attributes.action_from_account_id,';');
	branch_id = listlast(attributes.action_from_account_id,';');
	currency_multiplier = '';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
	{
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is form.money_type)
				other_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is GET_ACCOUNTS.ACCOUNT_CURRENCY_ID)
				dovizli_islem_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}
	}
</cfscript>
<cfset total_tax_price = 0>
<cfset total_tax_price_other = 0>
<cfloop from="1" to="#attributes.record_num#" index="i">
	<cfif evaluate("attributes.row_kontrol#i#") and len(evaluate("attributes.tax_price_#i#"))>
		<cfset total_tax_price = total_tax_price + evaluate("attributes.tax_price_#i#")>
		<cfset total_tax_price_other = total_tax_price_other + evaluate("attributes.tax_price_other_#i#")>
	</cfif>
</cfloop>
<cfif not len(attributes.interest_price_other)><cfset attributes.interest_price_other = 0></cfif>
<cfif not len(attributes.delay_price_other)><cfset attributes.delay_price_other = 0></cfif>
<cf_date tarih='attributes.revenue_date'>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="UPD_BANK_ACTION" datasource="#attributes.temp_dsn#">
			UPDATE
				BANK_ACTIONS
			SET
				PROCESS_CAT = #form.process_cat#,
				ACTION_TO_ACCOUNT_ID = #action_from_account_id#,
				ACTION_FROM_COMPANY_ID = <cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
				ACTION_VALUE = <cfif attributes.is_just_capital_price eq 1>#wrk_round(attributes.cash_action_value - attributes.interest_price - attributes.delay_price - total_tax_price)#,<cfelse>#attributes.cash_action_value#,</cfif>
				ACTION_DATE = #attributes.revenue_date#,
				ACTION_DETAIL=<cfif len(attributes.details)>'#left(attributes.details,100)#',<cfelse>NULL,</cfif>
				ACTION_CURRENCY_ID = '#GET_ACCOUNTS.ACCOUNT_CURRENCY_ID#',
				<cfif attributes.is_just_capital_price eq 1>
					OTHER_CASH_ACT_VALUE = <cfif len(attributes.other_cash_act_value)>#wrk_round(attributes.other_cash_act_value - attributes.interest_price_other - attributes.delay_price_other - total_tax_price_other)#,<cfelse>NULL,</cfif>
				<cfelse>
					OTHER_CASH_ACT_VALUE = <cfif len(attributes.other_cash_act_value)>#attributes.other_cash_act_value#,<cfelse>NULL,</cfif>
				</cfif>
			    OTHER_MONEY = <cfif len(money_type)>'#money_type#',<cfelse>NULL,</cfif>
                PROJECT_ID = <cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#,<cfelse>NULL,</cfif>
				IS_ACCOUNT = <cfif is_account eq 1>1,<cfelse>0,</cfif>
				IS_ACCOUNT_TYPE = 13,
				PAPER_NO = <cfif isdefined("attributes.document_no") and len(attributes.document_no)>'#attributes.document_no#',<cfelse>NULL,</cfif>
				<cfif attributes.is_just_capital_price eq 1>
					MASRAF = NULL,
				<cfelse>
					MASRAF = #total_tax_price#,
				</cfif>
				UPDATE_EMP=#SESSION.EP.USERID#,
				UPDATE_IP='#CGI.REMOTE_ADDR#',
				UPDATE_DATE=#NOW()# ,
				SYSTEM_ACTION_VALUE = <cfif attributes.is_just_capital_price eq 1>#wrk_round(attributes.system_amount_value - attributes.interest_price - attributes.delay_price - total_tax_price)#<cfelse>#attributes.system_amount_value#</cfif>,
				SYSTEM_CURRENCY_ID = '#session.ep.money#',
                FROM_BRANCH_ID = #branch_id#
				<cfif len(session.ep.money2)>
					<cfif attributes.is_just_capital_price eq 1>
						,ACTION_VALUE_2 = #wrk_round((attributes.system_amount_value - attributes.interest_price - attributes.delay_price - total_tax_price)/currency_multiplier,4)#
					<cfelse>
						,ACTION_VALUE_2 = #wrk_round(attributes.system_amount_value/currency_multiplier,4)#
					</cfif>
					,ACTION_CURRENCY_ID_2 = '#session.ep.money2#'
				</cfif>
			WHERE
				ACTION_ID = #attributes.bank_action_id#
		</cfquery>
		<cfquery name="UPD_CREDIT_PAYMENT" datasource="#attributes.temp_dsn#">
			UPDATE
				CREDIT_CONTRACT_PAYMENT_INCOME
			SET
				PROCESS_CAT = #form.process_cat#,
				PROCESS_TYPE = #process_type#,
				DOCUMENT_NO = <cfif isdefined("attributes.document_no") and len(attributes.document_no)>'#attributes.document_no#',<cfelse>NULL,</cfif>
				DETAIL=<cfif len(attributes.details)>'#left(attributes.details,100)#',<cfelse>NULL,</cfif>
				COMPANY_ID = <cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
				PARTNER_ID = <cfif len(attributes.partner_id)>#attributes.partner_id#,<cfelse>NULL,</cfif>
				BANK_ACCOUNT_ID = #action_from_account_id#,
				ACTION_CURRENCY_ID = '#GET_ACCOUNTS.ACCOUNT_CURRENCY_ID#',
				EXPENSE_CENTER_ID = <cfif len(attributes.expense_center_id)>#attributes.expense_center_id#<cfelse>NULL</cfif>,
				PROCESS_DATE = #attributes.revenue_date#,
				CAPITAL_EXPENSE_ITEM_ID = <cfif isdefined("attributes.capital_expense_id") and len(attributes.capital_expense_id) and len(attributes.capital_expense)>#attributes.capital_expense_id#<cfelse>NULL</cfif>,
				INTEREST_EXPENSE_ITEM_ID = <cfif len(attributes.interest_expense_id) and len(attributes.interest_expense)>#attributes.interest_expense_id#<cfelse>NULL</cfif>,
				DELAY_EXPENSE_ITEM_ID = <cfif len(attributes.delay_expense_id) and len(attributes.delay_expense)>#attributes.delay_expense_id#<cfelse>NULL</cfif>,
				CAPITAL_PRICE = #attributes.capital_price#,
				INTEREST_PRICE = <cfif len(attributes.interest_price)>#attributes.interest_price#<cfelse>0</cfif>,
				TAX_PRICE = #total_tax_price#,
				DELAY_PRICE = <cfif len(attributes.delay_price)>#attributes.delay_price#<cfelse>0</cfif>,
				TOTAL_PRICE = #attributes.cash_action_value#,
				OTHER_TOTAL_PRICE = <cfif len(attributes.other_cash_act_value)>#attributes.other_cash_act_value#,<cfelse>NULL,</cfif>
				OTHER_MONEY = <cfif len(money_type)>'#money_type#'<cfelse>NULL</cfif>,
				CAPITAL_EXPENSE_ITEM_ID_ACC= <cfif len(attributes.debt_account_id) and len(attributes.debt_account_code)>'#attributes.debt_account_id#'<cfelse>NULL</cfif>,
				INTEREST_EXPENSE_ITEM_ID_ACC= <cfif len(attributes.debt_account_id2) and len(attributes.debt_account_code2)>'#attributes.debt_account_id2#'<cfelse>NULL</cfif>,
				DELAY_EXPENSE_ITEM_ID_ACC= <cfif len(attributes.debt_account_id4) and len(attributes.debt_account_code4)>'#attributes.debt_account_id4#'<cfelse>NULL</cfif>,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_DATE = #now()#
			WHERE
				CREDIT_CONTRACT_PAYMENT_ID = #attributes.credit_contract_payment_id#
		</cfquery>
		<cfquery name="UPD_CREDIT_CONTRACT_ROW" datasource="#attributes.temp_dsn#">
			UPDATE
				#dsn3_alias#.CREDIT_CONTRACT_ROW
			SET
				PROCESS_DATE = #attributes.revenue_date#,
				CAPITAL_PRICE = #attributes.capital_price#,
				INTEREST_PRICE = <cfif len(attributes.interest_price)>#attributes.interest_price#<cfelse>0</cfif>,
				TAX_PRICE = #total_tax_price#,
				DELAY_PRICE = <cfif len(attributes.delay_price)>#attributes.delay_price#<cfelse>0</cfif>,
				TOTAL_PRICE = #attributes.other_cash_act_value#,
				OTHER_MONEY = '#money_type#'
			WHERE
				CREDIT_CONTRACT_ID = #attributes.credit_contract_id# AND
				ACTION_ID = #attributes.credit_contract_payment_id#
		</cfquery>
		<cfquery name="del_payment_tax" datasource="#attributes.temp_dsn#">
			DELETE FROM #dsn2_alias#.CREDIT_CONTRACT_PAYMENT_INCOME_TAX WHERE CREDIT_CONTRACT_PAYMENT_ID = #attributes.credit_contract_payment_id#
		</cfquery>
		<!--- Vergi masraf satırları yazılıyor --->
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#") and len(evaluate("attributes.tax_price_#i#"))>
				<cfquery name="add_row" datasource="#attributes.temp_dsn#">
					INSERT INTO
						#dsn2_alias#.CREDIT_CONTRACT_PAYMENT_INCOME_TAX
					(
						CREDIT_CONTRACT_PAYMENT_ID,
						TAX_PRICE,
						TAX_EXPENSE_ITEM_ID,
						TAX_EXPENSE_ITEM_ID_ACC
					)
					VALUES
					(
						#attributes.credit_contract_payment_id#,
						#evaluate("attributes.tax_price_#i#")#,
						<cfif len(evaluate("attributes.tax_expense_id_#i#")) and len(evaluate("attributes.tax_expense_#i#"))>#evaluate("attributes.tax_expense_id_#i#")#<cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.debt_account_id3_#i#"))>'#evaluate("attributes.debt_account_id3_#i#")#'<cfelse>NULL</cfif>
					)
				</cfquery>
			</cfif>
		</cfloop>
		<cfquery name="get_credit_number" datasource="#dsn2#">
			SELECT CREDIT_NO FROM #dsn3_alias#.CREDIT_CONTRACT WHERE CREDIT_CONTRACT_ID = #attributes.credit_contract_id#
		</cfquery>
		<cfscript>
			if(is_budget)
				include('upd_revenue_budget_actions.cfm');//bütçe hareketleri
			else
				butce_sil(action_id:attributes.credit_contract_payment_id,process_type:process_type,muhasebe_db:attributes.temp_dsn);
			if(is_cari)
			{
				if(GET_ACCOUNTS.ACCOUNT_CURRENCY_ID is session.ep.money)
				{
					new_action_value = attributes.system_amount_value;
					new_oher_action_value = attributes.other_cash_act_value;
					carici (
						action_id : attributes.credit_contract_payment_id,
						action_table : 'CREDIT_CONTRACT_PAYMENT_INCOME',
						islem_belge_no : attributes.document_no,
						workcube_process_type : process_type,		
						workcube_old_process_type :form.old_process_type,		
						process_cat : form.process_cat,	
						islem_tarihi : attributes.revenue_date,
						to_account_id : action_from_account_id,
						to_branch_id : branch_id,
						islem_tutari : new_action_value,
						action_currency : session.ep.money,
						other_money_value : new_oher_action_value,
						other_money : form.money_type,
						currency_multiplier : currency_multiplier,
						islem_detay : 'KREDİ TAHSİLATI',
						action_detail : left(attributes.details,100),
						account_card_type : 13,
						due_date: attributes.revenue_date,
						from_cmp_id : attributes.company_id,
						rate2:other_currency_multiplier
						);
				}
				else
				{
					new_action_value = attributes.system_amount_value;
					new_oher_action_value = attributes.other_cash_act_value;
					carici (
						action_id : attributes.credit_contract_payment_id,
						action_table : 'CREDIT_CONTRACT_PAYMENT_INCOME',
						islem_belge_no : attributes.document_no,
						workcube_process_type :process_type,		
						workcube_old_process_type :form.old_process_type,		
						process_cat : form.process_cat,	
						islem_tarihi : attributes.revenue_date,
						to_account_id : action_from_account_id,
						to_branch_id : branch_id,
						islem_tutari : new_action_value,
						action_currency : session.ep.money,
						other_money_value : new_oher_action_value,
						other_money : GET_ACCOUNTS.ACCOUNT_CURRENCY_ID,
						currency_multiplier : currency_multiplier,
						islem_detay : 'KREDİ TAHSİLATI',
						action_detail : left(attributes.details,100),
						account_card_type : 13,
						due_date: attributes.revenue_date,
						from_cmp_id : attributes.company_id,
						rate2:other_currency_multiplier
						);
				}
			}
			else
				cari_sil(action_id:attributes.credit_contract_payment_id,process_type:form.old_process_type,cari_db:attributes.temp_dsn);

			if(is_account)
			{
				if(GET_ACCOUNTS.ACCOUNT_CURRENCY_ID is session.ep.money)
				{ 
					GET_NO_ = cfquery(datasource:"#attributes.temp_dsn#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
					//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
					str_fark_gelir =GET_NO_.FARK_GELIR;
					str_fark_gider =GET_NO_.FARK_GIDER;
					str_max_round = 0.1;
					str_round_detail = 'KREDİ TAHSİLATI İŞLEMİ';

					str_alacakli_hesaplar = attributes.debt_account_id;
					str_alacakli_tutarlar = attributes.system_amount;
					str_alacakli_other_tutar = attributes.other_cash_act_value;
					str_alacakli_other_currency = form.money_type;
					if(len(attributes.details))
						detail_ = "#get_credit_number.credit_no# - #attributes.details#";
					else
						detail_ = "#get_credit_number.credit_no# - KREDİ TAHSİLATI İŞLEMİ";
					str_borclu_hesaplar = GET_ACCOUNTS.ACCOUNT_ACC_CODE;
					str_borclu_tutarlar = attributes.capital_price;
					str_borclu_other_tutar = attributes.capital_price;
					str_borclu_other_currency = session.ep.money;

					if(len(attributes.debt_account_id2) and attributes.interest_price gt 0)
					{
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,attributes.debt_account_id2,",");	
						str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,attributes.interest_price,",");
						str_borclu_other_tutar = ListAppend(str_borclu_other_tutar,wrk_round(attributes.interest_price/other_currency_multiplier),",");
						str_borclu_other_currency = ListAppend(str_borclu_other_currency,form.money_type,",");
					}
					for(i=1; i lte attributes.record_num; i=i+1)
					{
						if (evaluate("attributes.row_kontrol#i#") and len(evaluate("attributes.tax_price_#i#")) and evaluate("attributes.tax_price_#i#") gt 0)
						{
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,evaluate("attributes.debt_account_id3_#i#"),",");	
							str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,evaluate("attributes.tax_price_#i#"),",");
							str_borclu_other_tutar = ListAppend(str_borclu_other_tutar,wrk_round(evaluate("attributes.tax_price_#i#")/other_currency_multiplier),",");
							str_borclu_other_currency = ListAppend(str_borclu_other_currency,form.money_type,",");
						}
					}
					if(len(attributes.delay_expense_id) and attributes.delay_price gt 0)
					{
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,attributes.debt_account_id4,",");	
							str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,attributes.delay_price,",");
							str_borclu_other_tutar = ListAppend(str_borclu_other_tutar,wrk_round(attributes.delay_price/other_currency_multiplier),",");
							str_borclu_other_currency = ListAppend(str_borclu_other_currency,form.money_type,",");
					}
					muhasebeci (
						action_id : attributes.credit_contract_payment_id,
						workcube_process_type : process_type,
						workcube_old_process_type :form.old_process_type,	
						workcube_process_cat:form.process_cat,	
						account_card_type:13,
						company_id : attributes.company_id,
						islem_tarihi : attributes.revenue_date,
						belge_no : attributes.document_no,
						fis_satir_detay : detail_,
						borc_hesaplar : str_borclu_hesaplar,
						borc_tutarlar : str_borclu_tutarlar,
						other_amount_borc : str_borclu_other_tutar,
						other_currency_borc : str_borclu_other_currency,
						alacak_hesaplar : str_alacakli_hesaplar,
						alacak_tutarlar : str_alacakli_tutarlar,
						other_amount_alacak : str_alacakli_other_tutar,
						other_currency_alacak : str_alacakli_other_currency,
						currency_multiplier : currency_multiplier,
						is_account_group : is_account_group,
						fis_detay:detail_,
						to_branch_id : branch_id,
						muhasebe_db:attributes.temp_dsn,
						dept_round_account :str_fark_gider,
						claim_round_account : str_fark_gelir,
						max_round_amount :str_max_round,
						round_row_detail:str_round_detail,
						acc_project_id: attributes.project_id
					);
				}
				else
				{
					GET_NO_ = cfquery(datasource:"#attributes.temp_dsn#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
					//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
					str_fark_gelir =GET_NO_.FARK_GELIR;
					str_fark_gider =GET_NO_.FARK_GIDER;
					str_max_round = 0.1;
					str_round_detail = 'DÖVİZLİ KREDİ TAHSİLATI İŞLEMİ';
					if(len(attributes.details))
						detail_ = "#get_credit_number.credit_no# - #attributes.details#";
					else
						detail_ = "#get_credit_number.credit_no# - DÖVİZLİ KREDİ TAHSİLATI İŞLEMİ";
						
					str_alacakli_hesaplar = attributes.debt_account_id;
					str_alacakli_tutarlar = attributes.system_amount;
					str_alacakli_other_tutar = attributes.other_cash_act_value;
					str_alacakli_other_currency = GET_ACCOUNTS.ACCOUNT_CURRENCY_ID;
					
					str_borclu_hesaplar = GET_ACCOUNTS.ACCOUNT_ACC_CODE;
					str_borclu_tutarlar =  wrk_round(attributes.capital_price*dovizli_islem_multiplier);
					str_borclu_other_tutar = attributes.capital_price;
					str_borclu_other_currency = GET_ACCOUNTS.ACCOUNT_CURRENCY_ID;
					
					if(len(attributes.interest_expense_id) and attributes.interest_price gt 0)
					{
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,attributes.debt_account_id2,",");	
						str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,wrk_round(attributes.interest_price*dovizli_islem_multiplier),",");
						str_borclu_other_tutar = ListAppend(str_borclu_other_tutar,attributes.interest_price,",");
						str_borclu_other_currency = ListAppend(str_borclu_other_currency,GET_ACCOUNTS.ACCOUNT_CURRENCY_ID,",");
					}
					for(i=1; i lte attributes.record_num; i=i+1)
					{
						if (evaluate("attributes.row_kontrol#i#") and len(evaluate("attributes.tax_price_#i#")) and evaluate("attributes.tax_price_#i#") gt 0)
						{
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,evaluate("attributes.debt_account_id3_#i#"),",");	
							str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,wrk_round(evaluate("attributes.tax_price_#i#")*dovizli_islem_multiplier),",");
							str_borclu_other_tutar = ListAppend(str_borclu_other_tutar,evaluate("attributes.tax_price_#i#"),",");
							str_borclu_other_currency = ListAppend(str_borclu_other_currency,GET_ACCOUNTS.ACCOUNT_CURRENCY_ID,",");
						}
					}
					if(len(attributes.delay_expense_id) and attributes.delay_price gt 0)
					{
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,attributes.debt_account_id4,",");	
						str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,wrk_round(attributes.delay_price*dovizli_islem_multiplier),",");
						str_borclu_other_tutar = ListAppend(str_borclu_other_tutar,attributes.delay_price,",");
						str_borclu_other_currency = ListAppend(str_borclu_other_currency,GET_ACCOUNTS.ACCOUNT_CURRENCY_ID,",");
					}
					muhasebeci (
						action_id : attributes.credit_contract_payment_id,
						workcube_process_type : process_type,
						workcube_old_process_type :form.old_process_type,
						workcube_process_cat:form.process_cat,		
						account_card_type:13,
						company_id : attributes.company_id,
						islem_tarihi : attributes.revenue_date,
						belge_no : attributes.document_no,
						fis_satir_detay : detail_,
						borc_hesaplar : str_borclu_hesaplar,
						borc_tutarlar : str_borclu_tutarlar,
						other_amount_borc : str_borclu_other_tutar,
						other_currency_borc : str_borclu_other_currency,
						alacak_hesaplar : str_alacakli_hesaplar,
						alacak_tutarlar : str_alacakli_tutarlar,
						other_amount_alacak : str_alacakli_other_tutar,
						other_currency_alacak : str_alacakli_other_currency,
						currency_multiplier : currency_multiplier,
						is_account_group : is_account_group,
						fis_detay:detail_,
						to_branch_id : branch_id,
						muhasebe_db:attributes.temp_dsn,
						dept_round_account :str_fark_gider,
						claim_round_account : str_fark_gelir,
						max_round_amount :str_max_round,
						round_row_detail:str_round_detail,
						acc_project_id: attributes.project_id
					);
				}
			}
			else
				muhasebe_sil(action_id:attributes.credit_contract_payment_id,process_type:form.old_process_type,muhasebe_db:attributes.temp_dsn);
				
			f_kur_ekle_action(action_id:attributes.credit_contract_payment_id,process_type:1,action_table_name:'CREDIT_CONTRACT_PAYMENT_INCOME_MONEY',action_table_dsn:'#attributes.temp_dsn#');
		</cfscript>	
		<cfif len(get_process_type.action_file_name)> <!--- secilen islem kategorisine bir action file eklenmisse --->
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = #attributes.credit_contract_payment_id#
				is_action_file = 1
				action_file_name='#get_process_type.action_file_name#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		</cfif>	
	</cftransaction>
</cflock>
<script language="javascript">
	wrk_opener_reload();
	window.close();
</script>
