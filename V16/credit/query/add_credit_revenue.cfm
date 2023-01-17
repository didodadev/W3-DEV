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
	SELECT 
		<cfif session.ep.period_year lt 2009>
			CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID,
		</cfif>
		ACCOUNT_ACC_CODE 
	FROM 
		ACCOUNTS 
	WHERE 
		ACCOUNT_ID = #listfirst(attributes.action_from_account_id,';')#
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
<cf_papers paper_type="credit_revenue">
<cfset full_paper_no = paper_code & '-' & paper_number>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_BANK_ACTION" datasource="#dsn2#">
			INSERT INTO
				BANK_ACTIONS
				(
					ACTION_TYPE,
					PROCESS_CAT,
					ACTION_TYPE_ID,
					ACTION_TO_ACCOUNT_ID,
					ACTION_FROM_COMPANY_ID,
					ACTION_VALUE,
					MASRAF,
					ACTION_DATE,
					ACTION_DETAIL,
					ACTION_CURRENCY_ID,
					OTHER_CASH_ACT_VALUE,
					OTHER_MONEY,
                    PROJECT_ID,
					IS_ACCOUNT,
					IS_ACCOUNT_TYPE,
					PAPER_NO,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					SYSTEM_ACTION_VALUE,
					SYSTEM_CURRENCY_ID,
                    FROM_BRANCH_ID
					<cfif len(session.ep.money2)>
						,ACTION_VALUE_2
						,ACTION_CURRENCY_ID_2
					</cfif>				
				)
			VALUES
				(
					'KREDİ TAHSİLATI',
					#form.process_cat#,
					#process_type#,
					#action_from_account_id#,
					<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
					<cfif attributes.is_just_capital_price eq 1> <!--- sadece anapara banka işlemine yansır. --->
						#wrk_round(attributes.cash_action_value - attributes.interest_price - attributes.delay_price - total_tax_price)#,
						NULL,
					<cfelse>
						#attributes.cash_action_value#, <!--- anapara, faiz, gecikme, vergi-masraf banka işlemine yansır --->
						#total_tax_price#,
					</cfif>					
					#attributes.revenue_date#,
					<cfif len(attributes.details)>'#left(attributes.details,100)#',<cfelse>NULL,</cfif>
					'#GET_ACCOUNTS.ACCOUNT_CURRENCY_ID#',
					<cfif attributes.is_just_capital_price eq 1>
						<cfif len(attributes.other_cash_act_value)>#wrk_round(attributes.other_cash_act_value - attributes.interest_price_other - attributes.delay_price_other - total_tax_price_other)#,<cfelse>NULL,</cfif>
					<cfelse>
						<cfif len(attributes.other_cash_act_value)>#attributes.other_cash_act_value#,<cfelse>NULL,</cfif>
					</cfif>
					<cfif len(money_type)>'#money_type#',<cfelse>NULL,</cfif>
                    <cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#,<cfelse>NULL,</cfif>
					<cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
					<cfif len(full_paper_no)>'#full_paper_no#',<cfelse>NULL,</cfif>
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					#NOW()#,
					<cfif attributes.is_just_capital_price eq 1>
						#wrk_round(attributes.system_amount_value - attributes.interest_price - attributes.delay_price - total_tax_price)#,
					<cfelse>
						#attributes.system_amount_value#,
					</cfif>
					'#session.ep.money#',
                    #branch_id#
					<cfif len(session.ep.money2)>
						<cfif attributes.is_just_capital_price eq 1>
							,#wrk_round((attributes.system_amount_value - attributes.interest_price - attributes.delay_price - total_tax_price)/currency_multiplier,4)#
						<cfelse>
							,#wrk_round(attributes.system_amount_value/currency_multiplier,4)#
						</cfif>	
						,'#session.ep.money2#'
					</cfif>					
				)
		</cfquery>
		<cfquery name="GET_ACT_ID" datasource="#dsn2#">
			SELECT MAX(ACTION_ID) AS MAX_ID FROM BANK_ACTIONS
		</cfquery>
		<cfquery name="ADD_CREDIT_PAYMENT" datasource="#DSN2#">
			INSERT INTO
				CREDIT_CONTRACT_PAYMENT_INCOME
			(
				CREDIT_CONTRACT_ID,
				CREDIT_CONTRACT_ROW_ID,
				BANK_ACTION_ID,
				PROCESS_CAT,
				PROCESS_TYPE,
				DOCUMENT_NO,
				DETAIL,
				COMPANY_ID,
				PARTNER_ID,
				BANK_ACCOUNT_ID,
				ACTION_CURRENCY_ID,
				EXPENSE_CENTER_ID,
				PROCESS_DATE,
				CAPITAL_EXPENSE_ITEM_ID,
				INTEREST_EXPENSE_ITEM_ID,
				DELAY_EXPENSE_ITEM_ID,		
				CAPITAL_PRICE,
				INTEREST_PRICE,
				TAX_PRICE,
				DELAY_PRICE,
				TOTAL_PRICE,
				OTHER_TOTAL_PRICE,
				OTHER_MONEY,
				CAPITAL_EXPENSE_ITEM_ID_ACC,
				INTEREST_EXPENSE_ITEM_ID_ACC,
				DELAY_EXPENSE_ITEM_ID_ACC,	
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE
			)
			VALUES
			(
				#attributes.credit_contract_id#,
				<cfif isdefined("attributes.credit_contract_row_id")>#attributes.credit_contract_row_id#<cfelse>NULL</cfif>,
				#GET_ACT_ID.MAX_ID#,
				#form.process_cat#,
				#process_type#,
				<cfif len(full_paper_no)>'#full_paper_no#',<cfelse>NULL,</cfif>
				<cfif len(attributes.details)>'#left(attributes.details,100)#',<cfelse>NULL,</cfif>
				<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
				#action_from_account_id#,
				'#GET_ACCOUNTS.ACCOUNT_CURRENCY_ID#',
				<cfif len(attributes.expense_center_id)>#attributes.expense_center_id#<cfelse>NULL</cfif>,
				#attributes.revenue_date#,
				<cfif isdefined("attributes.capital_expense_id") and len(attributes.capital_expense_id) and len(attributes.capital_expense)>#attributes.capital_expense_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.interest_expense_id) and len(attributes.interest_expense)>#attributes.interest_expense_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.delay_expense_id) and len(attributes.delay_expense)>#attributes.delay_expense_id#<cfelse>NULL</cfif>,
				#attributes.capital_price#,
				<cfif len(attributes.interest_price)>#attributes.interest_price#<cfelse>0</cfif>,
				#total_tax_price#,
				<cfif len(attributes.delay_price)>#attributes.delay_price#<cfelse>0</cfif>,
				#attributes.cash_action_value#,
				<cfif len(attributes.other_cash_act_value)>#attributes.other_cash_act_value#,<cfelse>NULL,</cfif>
				<cfif len(money_type)>'#money_type#'<cfelse>NULL</cfif>,
				<cfif len(attributes.debt_account_id) and len(attributes.debt_account_code)>'#attributes.debt_account_id#'<cfelse>NULL</cfif>,
				<cfif len(attributes.debt_account_id2) and len(attributes.debt_account_code2)>'#attributes.debt_account_id2#'<cfelse>NULL</cfif>,
				<cfif len(attributes.debt_account_id4) and len(attributes.debt_account_code4)>'#attributes.debt_account_id4#'<cfelse>NULL</cfif>,
				#session.ep.userid#,
				'#cgi.remote_addr#',
				#now()#
			)
		</cfquery>
		<cfquery name="GET_PAYMENT_ID" datasource="#DSN2#">
			SELECT MAX(CREDIT_CONTRACT_PAYMENT_ID) MAX_ID FROM CREDIT_CONTRACT_PAYMENT_INCOME
		</cfquery>
		<cfif isdefined("attributes.credit_contract_row_id")>
			<cfquery name="UPD_CONTRACT_ROW" datasource="#DSN2#">
				UPDATE
					#dsn3_alias#.CREDIT_CONTRACT_ROW
				SET
					IS_PAID_ROW = 1
				WHERE
					CREDIT_CONTRACT_ROW_ID = #attributes.credit_contract_row_id#
			</cfquery>
		</cfif>
		<cfquery name="UPD_CREDIT_CONTRACT_ROW" datasource="#DSN2#">		
				INSERT INTO
					#dsn3_alias#.CREDIT_CONTRACT_ROW
				(
					CREDIT_CONTRACT_TYPE,
					CREDIT_CONTRACT_ID,	
					PROCESS_DATE,
					CAPITAL_PRICE,						
					INTEREST_PRICE,
					TAX_PRICE,
					DELAY_PRICE,
					TOTAL_PRICE,
					OTHER_MONEY,						
					IS_PAID,
					OUR_COMPANY_ID,
					PERIOD_ID,
					PROCESS_TYPE,
					ACTION_ID
				)
				VALUES
				(
					2,<!--- tahsilat --->
					#attributes.credit_contract_id#,
					#attributes.revenue_date#,
					#attributes.capital_price#,
					<cfif len(attributes.interest_price)>#attributes.interest_price#<cfelse>0</cfif>,
					#total_tax_price#,
					<cfif len(attributes.delay_price)>#attributes.delay_price#<cfelse>0</cfif>,
					#attributes.other_cash_act_value#,
					'#money_type#',
					1,
					#session.ep.company_id#,
					#session.ep.period_id#,
					#process_type#,
					#GET_PAYMENT_ID.MAX_ID#
				)
		</cfquery>
		<!--- Vergi masraf satırları yazılıyor --->
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#") and len(evaluate("attributes.tax_price_#i#"))>
				<cfquery name="add_row" datasource="#dsn2#">
					INSERT INTO
						CREDIT_CONTRACT_PAYMENT_INCOME_TAX
					(
						CREDIT_CONTRACT_PAYMENT_ID,
						TAX_PRICE,
						TAX_EXPENSE_ITEM_ID,
						TAX_EXPENSE_ITEM_ID_ACC
					)
					VALUES
					(
						#GET_PAYMENT_ID.MAX_ID#,
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
				include('add_revenue_budget_actions.cfm');//bütçe hareketleri
			if(is_cari)
				if(GET_ACCOUNTS.ACCOUNT_CURRENCY_ID is session.ep.money)
				{
					new_action_value = attributes.system_amount_value;
					new_oher_action_value = attributes.other_cash_act_value;
					carici (
						action_id : GET_PAYMENT_ID.MAX_ID,
						action_table : 'CREDIT_CONTRACT_PAYMENT_INCOME',
						islem_belge_no : full_paper_no,
						workcube_process_type : process_type,		
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
						action_id : GET_PAYMENT_ID.MAX_ID,
						action_table : 'CREDIT_CONTRACT_PAYMENT_INCOME',
						islem_belge_no : full_paper_no,
						workcube_process_type :process_type,		
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
	
			if(is_account)
				if(GET_ACCOUNTS.ACCOUNT_CURRENCY_ID is session.ep.money)
				{
					GET_NO_ = cfquery(datasource:"#dsn2#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
					//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
					str_fark_gelir =GET_NO_.FARK_GELIR;
					str_fark_gider =GET_NO_.FARK_GIDER;
					str_max_round = 0.1;
					str_round_detail = 'KREDİ TAHSİLATI İŞLEMİ';

					str_alacakli_hesaplar = attributes.debt_account_id;
					str_alacakli_tutarlar = attributes.system_amount;
					str_alacakli_other_tutar =attributes.other_cash_act_value;
					str_alacakli_other_currency = form.money_type;

					str_borclu_hesaplar = GET_ACCOUNTS.ACCOUNT_ACC_CODE;
					str_borclu_tutarlar = attributes.capital_price;
					str_borclu_other_tutar = attributes.capital_price;
					str_borclu_other_currency = session.ep.money;
					if(len(attributes.details))
						detail_ = "#get_credit_number.credit_no# - #attributes.details#";
					else
						detail_ = "#get_credit_number.credit_no# - KREDİ TAHSİLATI İŞLEMİ";
					if(len(attributes.interest_expense_id) and attributes.interest_price gt 0)
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
						action_id : GET_PAYMENT_ID.MAX_ID,
						workcube_process_type : process_type,
						workcube_process_cat:form.process_cat,
						account_card_type:13,
						company_id : attributes.company_id,
						islem_tarihi : attributes.revenue_date,
						belge_no : full_paper_no,
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
						dept_round_account :str_fark_gider,
						claim_round_account : str_fark_gelir,
						max_round_amount :str_max_round,
						round_row_detail:str_round_detail,
                        acc_project_id: attributes.project_id
					);
				}
				else
				{
					GET_NO_ = cfquery(datasource:"#dsn2#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
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
					str_alacakli_tutarlar =attributes.system_amount;
					str_alacakli_other_tutar =attributes.other_cash_act_value;
					str_alacakli_other_currency = GET_ACCOUNTS.ACCOUNT_CURRENCY_ID;

					str_borclu_hesaplar = GET_ACCOUNTS.ACCOUNT_ACC_CODE;
					str_borclu_tutarlar = wrk_round(attributes.capital_price*dovizli_islem_multiplier);
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
						action_id : GET_PAYMENT_ID.MAX_ID,
						workcube_process_type : process_type,
						workcube_process_cat:form.process_cat,
						account_card_type:13,
						company_id : attributes.company_id,
						islem_tarihi : attributes.revenue_date,
						belge_no : full_paper_no,
						fis_satir_detay : detail_,
						borc_hesaplar :str_borclu_hesaplar,
						borc_tutarlar :str_borclu_tutarlar,
						other_amount_borc : str_borclu_other_tutar,
						other_currency_borc : str_borclu_other_currency,
						alacak_hesaplar : str_alacakli_hesaplar,
						alacak_tutarlar : str_alacakli_tutarlar,
						other_amount_alacak :str_alacakli_other_tutar,
						other_currency_alacak :str_alacakli_other_currency,
						currency_multiplier : currency_multiplier,
						is_account_group : is_account_group,
						fis_detay:detail_,
						to_branch_id : branch_id,
						dept_round_account :str_fark_gider,
						claim_round_account : str_fark_gelir,
						max_round_amount :str_max_round,
						round_row_detail:str_round_detail,
						acc_project_id: attributes.project_id
					);
				}
			f_kur_ekle_action(action_id:get_payment_id.max_id,process_type:0,action_table_name:'CREDIT_CONTRACT_PAYMENT_INCOME_MONEY',action_table_dsn:'#dsn2#');
		</cfscript>
		<cfif len(paper_number)>
			<!--- Belge numarasi update ediliyor. --->
			<cfquery name="UPD_GEN_PAP" datasource="#DSN2#">
				UPDATE 
					#dsn3_alias#.GENERAL_PAPERS
				SET
					CREDIT_REVENUE_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#paper_number#">
				WHERE
					CREDIT_REVENUE_NUMBER IS NOT NULL
			</cfquery>
		</cfif>
		<cfif len(get_process_type.action_file_name)>
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = #GET_PAYMENT_ID.MAX_ID#
				is_action_file = 1
				action_file_name='#get_process_type.action_file_name#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		</cfif>	
  </cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=credit.list_credit_contract</cfoutput>"
	window.close();
</script>
