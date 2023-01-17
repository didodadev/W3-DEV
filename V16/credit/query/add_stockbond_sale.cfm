<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT PROCESS_TYPE,IS_CARI,IS_ACCOUNT,IS_ACCOUNT_GROUP,IS_BUDGET,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_cari = get_process_type.IS_CARI;
	is_account = get_process_type.IS_ACCOUNT;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	is_budget = get_process_type.IS_BUDGET;
	action_from_account_id = listfirst(attributes.account_id,';');
	action_from_currency = listlast(attributes.account_id,';');
	currency_multiplier = 1;
	branch_id_info = listgetat(session.ep.user_location,2,'-');
		
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.rd_money)
				masraf_curr_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(isdefined('attributes.account_id') and evaluate("attributes.hidden_rd_money_#mon#") is ListLast(attributes.account_id,";"))
				currency_multiplier_banka = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}
</cfscript>
<cf_papers paper_type="SECURITIES_SALE">
<cf_date tarih='attributes.action_date'>
<cfif is_account eq 1 and len(attributes.company_id) and len(attributes.comp_name)>
		<cfset my_acc_result = get_company_period(attributes.company_id)>
	<cfif isdefined("my_acc_result") and not len(my_acc_result)>
		<script type="text/javascript">
			alert("Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş");
			history.back();	
		</script>
		<cfabort>
	</cfif>
</cfif>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<!--- Banka kayıtları --->
		<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
			<cfquery name="GET_ACC_CODE" datasource="#dsn2#">
				SELECT ACCOUNT_ACC_CODE FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_ID = #listfirst(attributes.account_id,';')#
			</cfquery>
			<cfquery name="ADD_BANK_ACTION" datasource="#dsn2#" result="MAX_ID">
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
						IS_ACCOUNT,
						IS_ACCOUNT_TYPE,
						PAPER_NO,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE,
						SYSTEM_ACTION_VALUE,
						WITH_NEXT_ROW,
						SYSTEM_CURRENCY_ID
						<cfif len(session.ep.money2)>
							,ACTION_VALUE_2
							,ACTION_CURRENCY_ID_2
						</cfif>
					)
				VALUES
					(
						'MENKUL KIYMET SATIŞI',
						#form.process_cat#,
						#process_type#,
						#action_from_account_id#,
						<cfif len(company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
						#attributes.action_value/currency_multiplier_banka#,
						0,
						#attributes.action_date#,
						<cfif len(attributes.detail)>'#left(attributes.detail,100)#',<cfelse>NULL,</cfif>
						'#action_from_currency#',
						<cfif len(attributes.sale_other)>#attributes.sale_other#,<cfelse>NULL,</cfif>
						'#attributes.rd_money#',
						<cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
						<cfif isdefined("attributes.paper_no") and len(attributes.paper_no)>'#attributes.paper_no#',<cfelse>NULL,</cfif>
						#SESSION.EP.USERID#,
						'#CGI.REMOTE_ADDR#',
						#NOW()#,
						#attributes.action_value#,
						1,
						'#session.ep.money#'
						<cfif len(session.ep.money2)>
							,#wrk_round(attributes.action_value/currency_multiplier,4)#
							,'#session.ep.money2#'
						</cfif>
					)
			</cfquery>
			<cfif attributes.com_ytl gt 0>
				<cfquery name="ADD_BANK_ACTION" datasource="#dsn2#">
					INSERT INTO
						BANK_ACTIONS(
							ACTION_TYPE,
							PROCESS_CAT,
							ACTION_TYPE_ID,
							ACTION_FROM_ACCOUNT_ID,
							ACTION_VALUE,
							MASRAF,
							ACTION_DATE,
							ACTION_DETAIL,
							ACTION_CURRENCY_ID,
							OTHER_CASH_ACT_VALUE,
							OTHER_MONEY,
							IS_ACCOUNT,
							IS_ACCOUNT_TYPE,
							PAPER_NO,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE,
							SYSTEM_ACTION_VALUE,
							WITH_NEXT_ROW,
							SYSTEM_CURRENCY_ID
							<cfif len(session.ep.money2)>
								,ACTION_VALUE_2
								,ACTION_CURRENCY_ID_2
							</cfif>
						)
					VALUES(
							'MENKUL KIYMET SATIŞI - KOMİSYON',
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.process_cat#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#process_type#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#action_from_account_id#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.com_ytl/currency_multiplier_banka#">,
							0,
							<cfqueryparam cfsqltype="cf_sql_date" value="#attributes.action_date#">,
							<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#left(attributes.detail,100)#"><cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#action_from_currency#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.com_other#">,
							<cfif len(rd_money)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#rd_money#"><cfelse>NULL</cfif>,
							<cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
							<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.paper_no#">,
							#SESSION.EP.USERID#,
							'#CGI.REMOTE_ADDR#',
							#NOW()#,
							<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.com_ytl#">,
							0,
							'#session.ep.money#'
							<cfif len(session.ep.money2)>
								,<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(attributes.com_ytl/currency_multiplier,4)#">
								,'#session.ep.money2#'
							</cfif>
						)
				</cfquery>
			</cfif>

			<cfset GET_ACT_ID.MAX_ID = MAX_ID.IDENTITYCOL>
		</cfif>
		
		<cfquery name="ADD_STOCKBOND_PURCHASE" datasource="#dsn2#">
			INSERT INTO
				#dsn3_alias#.STOCKBONDS_SALEPURCHASE
				(
					IS_SALES_PURCHASE,
					PROCESS_CAT,
					PROCESS_TYPE,
					PAPER_NO,
					ACTION_DATE,
					BANK_ACC_ID,
					COMPANY_ID,
					PARTNER_ID,
					EMPLOYEE_ID,
					BROKER_COMPANY,
					REF_NO,
					DETAIL,
					OTHER_MONEY,
					NET_TOTAL,
					OTHER_MONEY_VALUE,
					COM_RATE,
					COM_TOTAL,
					OTHER_COM_TOTAL,
					TOTAL_INCOME,
					OTHER_TOTAL_INCOME,
					EXP_CENTER_ID,
					EXP_ITEM_ID,
					ACCOUNT_CODE,
					COM_EXP_CENTER_ID,
					COM_EXP_ITEM_ID,
					COM_ACCOUNT_CODE,
					TOTAL_INCOME_EXP_CENTER_ID,
					TOTAL_INCOME_EXP_ITEM_ID,
					TOTAL_INCOME_ACCOUNT_CODE,
					BANK_ACTION_ID,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
			VALUES
				(
					1,
					#form.process_cat#,
					#process_type#,
					'#attributes.paper_no#',
					#attributes.action_date#,
					<cfif listlen(attributes.account_id)>#listfirst(attributes.account_id,';')#,<cfelse>NULL,</cfif>
					<cfif len(attributes.company_id) and len(attributes.comp_name)>#attributes.company_id#,<cfelse>NULL,</cfif>
					<cfif len(attributes.partner_id) and len(attributes.partner_name)>#attributes.partner_id#,<cfelse>NULL,</cfif>
					<cfif len(attributes.employee_id) and len(attributes.employee)>#attributes.employee_id#,<cfelse>NULL,</cfif>
					<cfif len(attributes.broker_company)>'#attributes.broker_company#',<cfelse>NULL,</cfif>
					<cfif len(attributes.ref_no)>'#attributes.ref_no#',<cfelse>NULL,</cfif>
					<cfif len(detail)>'#attributes.detail#',<cfelse>NULL,</cfif>
					'#attributes.rd_money#',
					#attributes.action_value#,
					#attributes.sale_other#,
					#attributes.com_rate#,
					#attributes.com_ytl#,
					#attributes.com_other#,
					#attributes.total_income#,
					#attributes.total_income_other#,
					<cfif len(attributes.expense_center_id) and len(attributes.expense_center)>#attributes.expense_center_id#,<cfelse>NULL,</cfif>
					<cfif len(attributes.expense_item_id) and len(attributes.expense_item_name)>#attributes.expense_item_id#,<cfelse>NULL,</cfif>
					<cfif len(attributes.acc_id) and len(attributes.acc_name)>'#attributes.acc_id#',<cfelse>NULL,</cfif>
					<cfif len(attributes.com_exp_center_id) and len(attributes.com_exp_center)>#attributes.com_exp_center_id#,<cfelse>NULL,</cfif>
					<cfif len(attributes.com_exp_item_id) and len(attributes.com_exp_item_name)>#attributes.com_exp_item_id#,<cfelse>NULL,</cfif>
					<cfif len(attributes.com_acc_id) and len(attributes.com_acc_name)>'#attributes.com_acc_id#',<cfelse>NULL,</cfif>
					<cfif len(attributes.total_income_exp_center_id) and len(attributes.total_income_exp_center)>#attributes.total_income_exp_center_id#,<cfelse>NULL,</cfif>
					<cfif len(attributes.total_income_exp_item_id) and len(attributes.total_income_exp_item_name)>#attributes.total_income_exp_item_id#,<cfelse>NULL,</cfif>
					<cfif len(attributes.total_income_acc_id) and len(attributes.total_income_acc_name)>'#attributes.total_income_acc_id#',<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.account_id") and len(attributes.account_id)>#GET_ACT_ID.MAX_ID#<cfelse>NULL</cfif>,
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#'
				)
		</cfquery>
		<cfquery name="GET_ACTION_ID" datasource="#dsn2#">
			SELECT MAX(ACTION_ID) AS MAX_ID FROM #dsn3_alias#.STOCKBONDS_SALEPURCHASE
		</cfquery>
			
		<!--- Cari ve Muhase Kayitlari--->
		<cfscript>
			//sadece banka secili ise yapilacak muhasebe islemi
			if(is_account and isdefined("attributes.account_id") and len(attributes.account_id))
			{
				str_borclu_hesaplar='';
				str_alacakli_hesaplar='';
				str_borclu_tutarlar ='';
				str_alacakli_tutarlar = '';
				str_borclu_other_tutar = '';
				str_alacakli_other_tutar = '';
				str_other_borc_currency_list = '';
				str_other_alacak_currency_list = '';
				satir_detay_list = ArrayNew(2); 
				GET_NO_ = cfquery(datasource:"#dsn2#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
				//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
				str_fark_gelir =GET_NO_.FARK_GELIR;
				str_fark_gider =GET_NO_.FARK_GIDER;
				str_max_round = 0.1;
				str_round_detail = 'MENKUL KIYMET SATIŞ İŞLEMİ';
				
				if( isdefined("attributes.record_num") and attributes.record_num neq "")
				{
					for(j=1; j lte attributes.record_num; j=j+1)
					{
						if( isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#") eq 1)
						{
							//toplam nominal deger kadar,toplam satis gider kalemine ait muhasebe koduna alacak kaydeder
							str_alacakli_hesaplar = listappend(str_alacakli_hesaplar,attributes.acc_id);
							str_alacakli_tutarlar = listappend(str_alacakli_tutarlar,evaluate("attributes.nominal_value#j#")*evaluate("attributes.quantity#j#"));
							str_alacakli_other_tutar = listappend(str_alacakli_other_tutar,evaluate("attributes.other_nominal_value#j#")*evaluate("attributes.quantity#j#"));
							str_other_alacak_currency_list = listappend(str_other_alacak_currency_list,attributes.rd_money,',');
							if(is_account_group neq 1)
							{
								satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#evaluate("attributes.row_detail#j#")# - MENKUL KIYMET SATIŞ İŞLEMİ';
							}
							else
							{
								if (len(attributes.detail))
									satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#attributes.detail# - MENKUL KIYMET SATIŞ İŞLEMİ';
								else
									satir_detay_list[2][listlen(str_alacakli_tutarlar)]='MENKUL KIYMET SATIŞ İŞLEMİ';
							}
							//bankaya, komisyon tutari kadar alacak kaydeder
							str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,GET_ACC_CODE.ACCOUNT_ACC_CODE);
							str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,attributes.com_ytl);
							str_alacakli_other_tutar = ListAppend(str_alacakli_other_tutar,attributes.com_other);
							str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,attributes.rd_money);
							if(is_account_group neq 1)
							{
								satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#attributes.com_exp_item_name# - MENKUL KIYMET SATIŞ İŞLEMİ';
							}
							else
							{
								if (len(attributes.detail))
									satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#attributes.detail# - MENKUL KIYMET SATIŞ İŞLEMİ';
								else
									satir_detay_list[2][listlen(str_alacakli_tutarlar)]='MENKUL KIYMET SATIŞ İŞLEMİ';
							}
							//toplam gelir kadar, gelir kalemine ait muhasebe koduna alacak kaydeder
							if (evaluate("attributes.sale_value#j#")-evaluate("attributes.nominal_value#j#")<0)
							{
								str_borclu_hesaplar = listappend(str_borclu_hesaplar,attributes.total_income_acc_id);
								str_borclu_tutarlar = listappend(str_borclu_tutarlar,abs(evaluate("attributes.sale_value#j#")-evaluate("attributes.nominal_value#j#"))*evaluate("attributes.quantity#j#"));
								str_borclu_other_tutar = listappend(str_borclu_other_tutar,abs(evaluate("attributes.other_sale_value#j#")-evaluate("attributes.other_nominal_value#j#"))*evaluate("attributes.quantity#j#"));
								str_other_borc_currency_list = listappend(str_other_borc_currency_list,attributes.rd_money,',');
								
								if(is_account_group neq 1)
								{
									satir_detay_list[1][listlen(str_borclu_tutarlar)]='#evaluate("attributes.row_detail#j#")# - MENKUL KIYMET SATIŞ İŞLEMİ';
								}
								else
								{
									if (len(attributes.detail))
										satir_detay_list[1][listlen(str_borclu_tutarlar)]='#attributes.detail# - MENKUL KIYMET SATIŞ İŞLEMİ';
									else
										satir_detay_list[1][listlen(str_borclu_tutarlar)]='MENKUL KIYMET SATIŞ İŞLEMİ';
								}
							}
							else
							{
								//toplam gelir kadar, gelir kalemine ait muhasebe koduna alacak kaydeder
								str_alacakli_hesaplar = listappend(str_alacakli_hesaplar,attributes.total_income_acc_id);
								str_alacakli_tutarlar = listappend(str_alacakli_tutarlar,(evaluate("attributes.sale_value#j#")-evaluate("attributes.nominal_value#j#"))*evaluate("attributes.quantity#j#"));
								str_alacakli_other_tutar = listappend(str_alacakli_other_tutar,(evaluate("attributes.other_sale_value#j#")-evaluate("attributes.other_nominal_value#j#"))*evaluate("attributes.quantity#j#"));
								str_other_alacak_currency_list = listappend(str_other_alacak_currency_list,attributes.rd_money,',');
								
								if(is_account_group neq 1)
								{
									satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#evaluate("attributes.row_detail#j#")# - MENKUL KIYMET SATIŞ İŞLEMİ';
								}
								else
								{
									if (len(attributes.detail))
										satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#attributes.detail# - MENKUL KIYMET SATIŞ İŞLEMİ';
									else
										satir_detay_list[2][listlen(str_alacakli_tutarlar)]='MENKUL KIYMET SATIŞ İŞLEMİ';
								}
							}
						}
					}
				}
				//bankaya, toplam satis tutari kadar borc kaydeder
				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,GET_ACC_CODE.ACCOUNT_ACC_CODE);
				str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,attributes.action_value);
				str_borclu_other_tutar = ListAppend(str_borclu_other_tutar,attributes.sale_other);
				str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,attributes.rd_money);
				if (len(attributes.detail))
					satir_detay_list[1][listlen(str_borclu_tutarlar)]='#attributes.detail# - MENKUL KIYMET SATIŞ İŞLEMİ';
				else
					satir_detay_list[1][listlen(str_borclu_tutarlar)]='MENKUL KIYMET SATIŞ İŞLEMİ';
						
				//komisyon muhasebe koduna, komisyon toplami kadar borc kaydeder
				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,attributes.com_acc_id);
				str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,attributes.com_ytl);
				str_borclu_other_tutar = ListAppend(str_borclu_other_tutar,attributes.com_other);
				str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,attributes.rd_money);
				
				if(is_account_group neq 1)
				{
					satir_detay_list[1][listlen(str_borclu_hesaplar)]='#attributes.com_exp_item_name# - MENKUL KIYMET SATIŞ İŞLEMİ';
				}
				else
				{
					if (len(attributes.detail))
						satir_detay_list[1][listlen(str_borclu_hesaplar)]='#attributes.detail# - MENKUL KIYMET SATIŞ İŞLEMİ';
					else
						satir_detay_list[1][listlen(str_borclu_hesaplar)]='MENKUL KIYMET SATIŞ İŞLEMİ';
				}
					
				muhasebeci (
					action_id : get_action_id.max_id,
					workcube_process_type : process_type,
					workcube_process_cat : attributes.process_cat,
					account_card_type : 13,
					company_id :  attributes.company_id,
					from_branch_id : branch_id_info,
					islem_tarihi : attributes.action_date,
					alacak_hesaplar : str_alacakli_hesaplar,
					alacak_tutarlar : str_alacakli_tutarlar,
					borc_hesaplar : str_borclu_hesaplar,
					borc_tutarlar : str_borclu_tutarlar,
					fis_satir_detay: satir_detay_list,
					fis_detay : 'MENKUL KIYMET SATIŞ İŞLEMİ',
					belge_no : attributes.paper_no,
					other_amount_borc :  str_borclu_other_tutar,
					other_currency_borc : str_other_borc_currency_list,
					other_amount_alacak : str_alacakli_other_tutar,
					other_currency_alacak : str_other_alacak_currency_list,
					currency_multiplier : currency_multiplier,
					is_account_group : is_account_group,
					dept_round_account :str_fark_gider,
					claim_round_account : str_fark_gelir,
					max_round_amount :str_max_round,
					round_row_detail:str_round_detail
				);
			}
		</cfscript>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
				<cf_date tarih='attributes.due_date#i#'>
				<cfquery name="ADD_STOCKBOND_ROW" datasource="#dsn2#">
					INSERT INTO
						#dsn3_alias#.STOCKBONDS_SALEPURCHASE_ROW
						(
							IS_SALES_PURCHASE,
							SALES_PURCHASE_ID,
							STOCKBOND_ID,
							DESCRIPTION,
							NOMINAL_VALUE,
							OTHER_NOMINAL_VALUE,
							PRICE,
							OTHER_PRICE,
							QUANTITY,
							NET_TOTAL,
							OTHER_MONEY_VALUE,
							OTHER_MONEY,
							DUE_DATE,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP				
						)
					VALUES
						(
							1,
							#get_action_id.max_id#,
							#evaluate("attributes.stockbond_id#i#")#,
							'#wrk_eval("attributes.row_detail#i#")#',
							#evaluate("attributes.nominal_value#i#")#,
							#evaluate("attributes.other_nominal_value#i#")#,
							#evaluate("attributes.sale_value#i#")#,
							#evaluate("attributes.other_sale_value#i#")#,
							#evaluate("attributes.quantity#i#")#,
							#evaluate("attributes.total_sale#i#")#,
							#evaluate("attributes.other_total_sale#i#")#,
							'#attributes.rd_money#',
							<cfif len(evaluate("attributes.due_date#i#"))>#evaluate("attributes.due_date#i#")#,<cfelse>NULL,</cfif>
							#now()#,
							#session.ep.userid#,
							'#cgi.remote_addr#'
						)
				</cfquery>
				<cfquery name="ADD_STOCKBOND_ROW" datasource="#dsn2#">
					INSERT INTO
						#dsn3_alias#.STOCKBONDS_INOUT
						(
							STOCKBOND_ID,
							PERIOD_ID,
							ACTION_ID,
							PAPER_NO,
							PROCESS_TYPE,
							QUANTITY,
							STOCKBOND_OUT
						)
					VALUES
						(
							#evaluate("attributes.stockbond_id#i#")#,
							#session.ep.period_id#,
							#get_action_id.max_id#,
							'#attributes.paper_no#',
							#process_type#,
							#evaluate("attributes.quantity#i#")#,
							#evaluate("attributes.quantity#i#")#
						)
				</cfquery>
			</cfif>
		</cfloop>
		<!--- Cari - Bütçe kayıtları --->
		<cfinclude template="add_stockbond_sale_1.cfm">	 
		
		<!--- Money Kayıtları --->
		<cfloop from="1" to="#attributes.kur_say#" index="i">
			<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
				INSERT INTO
					#dsn3_alias#.STOCKBONDS_SALEPURCHASE_MONEY 
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					VALUES
					(
						#get_action_id.max_id#,
						'#wrk_eval("attributes.hidden_rd_money_#i#")#',
						#evaluate("attributes.txt_rate2_#i#")#,
						#evaluate("attributes.txt_rate1_#i#")#,
						<cfif evaluate("attributes.hidden_rd_money_#i#") is attributes.rd_money>1<cfelse>0</cfif>
					)
			</cfquery>
		</cfloop>
		<cfif len(get_process_type.action_file_name)> <!--- secilen islem kategorisine bir action file eklenmisse --->
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = #get_action_id.max_id#
				is_action_file = 1
				action_file_name='#get_process_type.action_file_name#'
				action_page='#request.self#?fuseaction=credit.add_stockbond_sale&event=upd&action_id=#get_action_id.max_id#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		</cfif>	
		<cfif isdefined("paper_number") and len(paper_number)>
			<!--- Belge No update ediliyor --->
			<cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
				UPDATE 
					#dsn3_alias#.GENERAL_PAPERS
				SET
					SECURITIES_SALE_NUMBER = #paper_number#
				WHERE
					SECURITIES_SALE_NUMBER IS NOT NULL
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<cfset attributes.actionId=get_action_id.max_id>
<script type="text/javascript">
window.location.href="<cfoutput>#request.self#?fuseaction=credit.add_stockbond_sale&event=upd&action_id=#get_action_id.max_id#</cfoutput>";
</script>
