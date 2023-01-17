<!--- <cfdump var="#attributes#"><cfabort>  --->
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT PROCESS_TYPE,IS_CARI,NEXT_PERIODS_ACCRUAL_ACTION,IS_ACCOUNT,IS_ACCOUNT_GROUP,IS_BUDGET,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	process_cat = form.PROCESS_CAT;
	is_cari = get_process_type.IS_CARI;
	is_account = get_process_type.IS_ACCOUNT;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	is_budget = get_process_type.IS_BUDGET;
	is_next_periods_accrual_action = get_process_type.NEXT_PERIODS_ACCRUAL_ACTION;
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
		<cfquery name="GET_BANK_ID" datasource="#dsn2#">
			SELECT BANK_ACTION_ID FROM #dsn3_alias#.STOCKBONDS_SALEPURCHASE WHERE ACTION_ID = #attributes.action_id#
		</cfquery>
		<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
			<cfquery name="GET_ACC_CODE" datasource="#dsn2#">
				SELECT ACCOUNT_ACC_CODE FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_ID = #listfirst(attributes.account_id,';')#
			</cfquery>
			<cfif len(get_bank_id.BANK_ACTION_ID)>
				<cfquery name="UPD_BANK_ACTION" datasource="#dsn2#">
					UPDATE 
						BANK_ACTIONS 
					SET
						PROCESS_CAT = #form.process_cat#,
						ACTION_TYPE = 'MENKUL KIYMET ALIMI',
						ACTION_TYPE_ID = #process_type#,
						ACTION_DETAIL = <cfif len(attributes.detail)>'#left(attributes.detail,100)#',<cfelse>NULL,</cfif>
						ACTION_VALUE = #(attributes.action_value+attributes.com_ytl)/currency_multiplier_banka#,
						MASRAF = #attributes.com_ytl/currency_multiplier_banka#,
						ACTION_CURRENCY_ID='#action_from_currency#',
						ACTION_DATE=#attributes.action_date#,
						OTHER_CASH_ACT_VALUE=<cfif len(attributes.purchase_other)>#attributes.purchase_other+attributes.com_other#,<cfelse>NULL,</cfif>
						OTHER_MONEY=<cfif len(rd_money)>'#rd_money#',<cfelse>NULL,</cfif>
						UPDATE_DATE=#now()#,
						UPDATE_EMP=#session.ep.userid#,
						UPDATE_IP='#cgi.REMOTE_ADDR#',
						IS_ACCOUNT=<cfif is_account eq 1>1,<cfelse>0,</cfif>
						IS_ACCOUNT_TYPE=13,
						PAPER_NO='#attributes.paper_no#',
						ACTION_FROM_ACCOUNT_ID=#action_from_account_id#,
						ACTION_TO_COMPANY_ID= <cfif len(company_id) and len(attributes.comp_name)>#attributes.company_id#<cfelse>NULL</cfif>,
						SYSTEM_ACTION_VALUE = #attributes.action_value#,
						SYSTEM_CURRENCY_ID = '#session.ep.money#'
						<cfif len(session.ep.money2)>
							,ACTION_VALUE_2 = #wrk_round(attributes.action_value/currency_multiplier,4)#
							,ACTION_CURRENCY_ID_2 = '#session.ep.money2#'
						</cfif>
					WHERE
						ACTION_ID=#get_bank_id.BANK_ACTION_ID#
				</cfquery>
				<cfset bank_action_id = get_bank_id.bank_action_id>
			<cfelse>
				<cfquery name="ADD_BANK_ACTION" datasource="#dsn2#">
					INSERT INTO
						BANK_ACTIONS
						(
							ACTION_TYPE,
							PROCESS_CAT,
							ACTION_TYPE_ID,
							ACTION_FROM_ACCOUNT_ID,
							ACTION_TO_COMPANY_ID,
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
							SYSTEM_CURRENCY_ID
							<cfif len(session.ep.money2)>
								,ACTION_VALUE_2
								,ACTION_CURRENCY_ID_2
							</cfif>
						)
					VALUES
						(
							'MENKUL KIYMET ALIMI',
							#form.process_cat#,
							#process_type#,
							#action_from_account_id#,
							<cfif len(company_id) and len(attributes.comp_name)>#attributes.company_id#<cfelse>NULL</cfif>,
							#(attributes.action_value+attributes.com_ytl)/currency_multiplier_banka#,
							#attributes.com_ytl/currency_multiplier_banka#,
							#attributes.action_date#,
							<cfif len(attributes.detail)>'#left(attributes.detail,100)#',<cfelse>NULL,</cfif>
							'#action_from_currency#',
							<cfif len(attributes.purchase_other)>#attributes.purchase_other+attributes.com_other#,<cfelse>NULL,</cfif>
							'#attributes.rd_money#',
							<cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
							<cfif isdefined("attributes.paper_no") and len(attributes.paper_no)>'#attributes.paper_no#',<cfelse>NULL,</cfif>
							#SESSION.EP.USERID#,
							'#CGI.REMOTE_ADDR#',
							#NOW()#,
							#attributes.action_value#,
							'#session.ep.money#'
							<cfif len(session.ep.money2)>
								,#wrk_round(attributes.action_value/currency_multiplier,4)#
								,'#session.ep.money2#'
							</cfif>
						)
				</cfquery>
				<cfquery name="GET_ACT_ID" datasource="#dsn2#">
					SELECT MAX(ACTION_ID) AS MAX_ID FROM BANK_ACTIONS
				</cfquery>
				<cfset bank_action_id = get_act_id.max_id>
			</cfif>
			<!--- Banka Muhasebe Kaydi--->
			<cfscript>
				//sadece banka secili ise yapilacak muhasebe islemi
				if(is_account)
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
						
					if( isdefined("attributes.record_num") and attributes.record_num neq "")
					{
						for(j=1; j lte attributes.record_num; j=j+1)
						{
							//toplam alis gider kalemine ait muhasebe koduna borc kaydeder (satir bazinda)
							if( isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#") eq 1)
							{
								str_borclu_hesaplar = listappend(str_borclu_hesaplar,attributes.acc_id);
								str_borclu_tutarlar = listappend(str_borclu_tutarlar,evaluate("attributes.total_purchase#j#"));
								str_borclu_other_tutar = listappend(str_borclu_other_tutar,evaluate("attributes.other_total_purchase#j#"));
								str_other_borc_currency_list = listappend(str_other_borc_currency_list,attributes.rd_money,',');
								
								if(is_account_group neq 1)
								{
									satir_detay_list[1][listlen(str_borclu_tutarlar)]='#evaluate("attributes.row_detail#j#")# - MENKUL KIYMET ALIŞ İŞLEMİ';
								}
								else
								{
									if (len(attributes.detail))
										satir_detay_list[1][listlen(str_borclu_tutarlar)]='#attributes.detail# - MENKUL KIYMET ALIŞ İŞLEMİ';
									else
										satir_detay_list[1][listlen(str_borclu_tutarlar)]='MENKUL KIYMET ALIŞ İŞLEMİ';
								}
							}
						}
					}
					//komisyon gider kalemine ait muhasebe koduna borc kaydeder
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,attributes.com_acc_id);
					str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,attributes.com_ytl);
					str_borclu_other_tutar = ListAppend(str_borclu_other_tutar,attributes.com_other);
					str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,attributes.rd_money);
					if(is_account_group neq 1)
					{
						satir_detay_list[1][listlen(str_borclu_tutarlar)]='#attributes.com_exp_item_name# - MENKUL KIYMET ALIŞ İŞLEMİ';
					}
					else
					{
						if (len(attributes.detail))
							satir_detay_list[1][listlen(str_borclu_tutarlar)]='#attributes.detail# - MENKUL KIYMET ALIŞ İŞLEMİ';
						else
							satir_detay_list[1][listlen(str_borclu_tutarlar)]='MENKUL KIYMET ALIŞ İŞLEMİ';
					}
					
					//bankaya alis tutari toplami kadar alacak kaydeder
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,GET_ACC_CODE.ACCOUNT_ACC_CODE);
					str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,attributes.action_value);
					str_alacakli_other_tutar = ListAppend(str_alacakli_other_tutar,attributes.purchase_other);
					str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,attributes.rd_money);
					
					if(is_account_group neq 1)
					{
						get_item_name = cfquery(datasource:"#dsn2#", sqlstring:"SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.expense_item_id1#");
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#get_item_name.EXPENSE_ITEM_NAME# - MENKUL KIYMET ALIŞ İŞLEMİ';
					}
					else
					{
						if (len(attributes.detail))
							satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#attributes.detail# - MENKUL KIYMET ALIŞ İŞLEMİ';
						else
							satir_detay_list[2][listlen(str_alacakli_tutarlar)]='MENKUL KIYMET ALIŞ İŞLEMİ';
					}
					
					//bankaya komisyon tutari toplami kadar alacak kaydeder	
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,GET_ACC_CODE.ACCOUNT_ACC_CODE);
					str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,attributes.com_ytl);
					str_alacakli_other_tutar = ListAppend(str_alacakli_other_tutar,attributes.com_other);
					str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,attributes.rd_money);
					
					if(is_account_group neq 1)
					{
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#attributes.com_exp_item_name# - MENKUL KIYMET ALIŞ İŞLEMİ';
					}
					else
					{
						if (len(attributes.detail))
							satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#attributes.detail# - MENKUL KIYMET ALIŞ İŞLEMİ';
						else
							satir_detay_list[2][listlen(str_alacakli_tutarlar)]='MENKUL KIYMET ALIŞ İŞLEMİ';
					}

					if(is_next_periods_accrual_action)
						{
							for(k=1; k lte attributes.record_num; k=k+1){
								if( isdefined("attributes.getiri_type#k#") and ( evaluate("attributes.getiri_type#k#") eq 1 or evaluate("attributes.getiri_type#k#") eq 3 )){
									for(l=0; l lte evaluate("attributes.getiri_tahsil_sayisi#k#"); l=l+1){
		
										acc_code_expense_tahakkuk_item = cfquery(datasource:"#dsn2#", sqlstring:"SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #evaluate('attributes.expense_item_tahakkuk_id#k#')# ");
		
										str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,acc_code_expense_tahakkuk_item.ACCOUNT_CODE);
		
										if(attributes.rd_money is session.ep.money)
										{
											str_borclu_tutarlar = ListAppend(str_borclu_tutarlar, evaluate("attributes.getiri_tahsil_tutari#k#"));
										}
										else
										{
											getiri_doviz = wrk_round( evaluate("attributes.getiri_tahsil_tutari#k#",",") * masraf_curr_multiplier);
											str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,getiri_doviz,",");
										}
		
										str_borclu_other_tutar = listappend(str_borclu_other_tutar, evaluate("attributes.getiri_tahsil_tutari#k#") * masraf_curr_multiplier );
										str_other_borc_currency_list = listappend(str_other_borc_currency_list,attributes.rd_money,',');
		
										satir_detay_list[1][listlen(str_borclu_tutarlar)]= '#l+1#. GETİRİ' ;
		
										
									}
		
									acc_code_expense_tahsilat_item = cfquery(datasource:"#dsn2#", sqlstring:"SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #evaluate('attributes.expense_item_id#k#')# ");
		
									str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,acc_code_expense_tahsilat_item.ACCOUNT_CODE);
		
									if(attributes.rd_money is session.ep.money)
									{
										str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,evaluate("attributes.getiri_tutari#k#"));
									}
									else
									{
										getiri_alacakli_doviz = wrk_round( evaluate("attributes.getiri_tutari#k#") * masraf_curr_multiplier);
										str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,getiri_alacakli_doviz,",");
									}
						
									satir_detay_list[2][listlen(str_alacakli_tutarlar)]= 'TAHSİL';
		
									str_alacakli_other_tutar = ListAppend(str_alacakli_other_tutar, evaluate("attributes.getiri_tutari#k#")* masraf_curr_multiplier );
									str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,attributes.rd_money);
		
								}
						}
					} 

					muhasebeci (
						action_id : attributes.action_id,
						workcube_process_type : process_type,
						workcube_old_process_type : attributes.old_process_type,
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
						fis_detay : 'MENKUL KIYMET ALIŞ İŞLEMİ',
						belge_no : attributes.paper_no,
						other_amount_borc :  str_borclu_other_tutar,
						other_currency_borc : str_other_borc_currency_list,
						other_amount_alacak : str_alacakli_other_tutar,
						other_currency_alacak : str_other_alacak_currency_list,
						currency_multiplier : currency_multiplier,
						is_account_group : is_account_group
					);
				}
				else 
					muhasebe_sil(action_id:attributes.action_id, process_type:attributes.old_process_type);
			</cfscript>
		<cfelseif len(get_bank_id.BANK_ACTION_ID)>
			<cfscript>
				cari_sil(action_id:attributes.action_id,process_type:attributes.old_process_type);
				muhasebe_sil(action_id:attributes.action_id,process_type:attributes.old_process_type);
			</cfscript>		
			<cfquery name="DEL_BANK_ACTIONS" datasource="#dsn2#">
				DELETE FROM BANK_ACTIONS WHERE ACTION_ID = #get_bank_id.BANK_ACTION_ID#
			</cfquery>	
		</cfif>
		<cfquery name="UPD_SALEPURCHASE" datasource="#dsn2#">
			UPDATE 
				#dsn3_alias#.STOCKBONDS_SALEPURCHASE
			SET
				PROCESS_CAT = #form.process_cat#,
				PROCESS_TYPE = #process_type#,
				PAPER_NO = '#attributes.paper_no#',
				ACTION_DATE = #attributes.action_date#,
				BANK_ACC_ID = <cfif listlen(attributes.account_id)>#listfirst(attributes.account_id,';')#,<cfelse>NULL,</cfif>
				COMPANY_ID = <cfif len(attributes.company_id) and len(attributes.comp_name)>#attributes.company_id#,<cfelse>NULL,</cfif>
				PARTNER_ID = <cfif len(attributes.partner_id) and len(attributes.partner_name)>#attributes.partner_id#,<cfelse>NULL,</cfif>
				EMPLOYEE_ID = <cfif len(attributes.employee_id) and len(attributes.employee)>#attributes.employee_id#,<cfelse>NULL,</cfif>
				BROKER_COMPANY = <cfif len(attributes.broker_company)>'#attributes.broker_company#',<cfelse>NULL,</cfif>
				REF_NO = <cfif len(attributes.ref_no)>'#attributes.ref_no#',<cfelse>NULL,</cfif>
				DETAIL = <cfif len(detail)>'#left(attributes.detail,200)#',<cfelse>NULL,</cfif>
				OTHER_MONEY = '#attributes.rd_money#',
				NET_TOTAL = #attributes.action_value#,
				OTHER_MONEY_VALUE = #attributes.purchase_other#,
				COM_RATE = #attributes.com_rate#,
				COM_TOTAL = #attributes.com_ytl#,
				OTHER_COM_TOTAL = #attributes.com_other#,
				EXP_CENTER_ID = <cfif len(attributes.expense_center_id1)>#attributes.expense_center_id1#,<cfelse>NULL,</cfif>
				EXP_ITEM_ID = <cfif len(attributes.expense_item_id1)>#attributes.expense_item_id1#,<cfelse>NULL,</cfif>
				ACCOUNT_CODE = <cfif len(attributes.acc_id) and len(attributes.acc_name)>'#attributes.acc_id#',<cfelse>NULL,</cfif>
				COM_EXP_CENTER_ID = <cfif len(attributes.com_exp_center_id) and len(attributes.com_exp_center)>#attributes.com_exp_center_id#,<cfelse>NULL,</cfif>
				COM_EXP_ITEM_ID = <cfif len(attributes.com_exp_item_id) and len(attributes.com_exp_item_name)>#attributes.com_exp_item_id#,<cfelse>NULL,</cfif>
				COM_ACCOUNT_CODE = <cfif len(attributes.com_acc_id) and len(attributes.com_acc_name)>'#attributes.com_acc_id#',<cfelse>NULL,</cfif>
				BANK_ACTION_ID = <cfif isdefined("attributes.account_id") and len(attributes.account_id)>#bank_action_id#<cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE 
				ACTION_ID = #attributes.action_id#
		</cfquery>
		<cfquery name="DEL_STOCKBOND_MONEY" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.STOCKBONDS_SALEPURCHASE_MONEY WHERE ACTION_ID =  #attributes.action_id#
		</cfquery>
		<cfquery name="DEL_STOCKBOND_INOUT" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.STOCKBONDS_INOUT WHERE ACTION_ID = #attributes.action_id# AND PROCESS_TYPE = #process_type#
		</cfquery>
		<cfquery name="DEL_STOCKBOND_ROW" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.STOCKBONDS_SALEPURCHASE_ROW WHERE SALES_PURCHASE_ID = #attributes.action_id#
		</cfquery>
		<cfloop from="1" to="#attributes.record_num#" index="i">  
			<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
				<cf_date tarih='attributes.due_date#i#'>
				<cfif isDefined("attributes.stockbond_id#i#") and len(evaluate("attributes.stockbond_id#i#"))>
					<cfquery name="UPD_STOCKBOND" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.STOCKBONDS
						SET
							STOCKBOND_TYPE = <cfif len(evaluate("attributes.bond_type#i#"))>#evaluate("attributes.bond_type#i#")#,<cfelse>NULL,</cfif>
							STOCKBOND_CODE = <cfif len(evaluate("attributes.bond_code#i#"))>'#wrk_eval("attributes.bond_code#i#")#',<cfelse>NULL,</cfif>
							DETAIL = <cfif len(evaluate("attributes.row_detail#i#"))>'#wrk_eval("attributes.row_detail#i#")#',<cfelse>NULL,</cfif>
							NOMINAL_VALUE = #evaluate("attributes.nominal_value#i#")#,
							OTHER_NOMINAL_VALUE	 = #evaluate("attributes.other_nominal_value#i#")#,
							PURCHASE_VALUE = #evaluate("attributes.purchase_value#i#")#,
							OTHER_PURCHASE_VALUE = #evaluate("attributes.other_purchase_value#i#")#,
							QUANTITY = #evaluate("attributes.quantity#i#")#,
							TOTAL_PURCHASE = #evaluate("attributes.total_purchase#i#")#,
							OTHER_TOTAL_PURCHASE = #evaluate("attributes.other_total_purchase#i#")#,  
							ROW_EXP_CENTER_ID = <cfif len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#,<cfelse>NULL,</cfif>
							ROW_EXP_ITEM_ID = <cfif len(evaluate("attributes.expense_item_id#i#"))>#evaluate("attributes.expense_item_id#i#")#,<cfelse>NULL,</cfif>
							DUE_DATE = <cfif len(evaluate("attributes.due_date#i#"))>#evaluate("attributes.due_date#i#")#,<cfelse>NULL,</cfif>
							BANK_ACTION_ID = <cfif isdefined("attributes.account_id") and len(attributes.account_id)>#bank_action_id#<cfelse>NULL</cfif>,
							YIELD_TYPE = <cfif len(evaluate("attributes.getiri_type#i#"))>#evaluate("attributes.getiri_type#i#")#<cfelse>NULL</cfif>,
							<cfif evaluate("attributes.getiri_type#i#") eq 1 or evaluate("attributes.getiri_type#i#") eq 3>
								ROW_EXP_TAHAKKUK_ITEM_ID = #evaluate("attributes.expense_item_tahakkuk_id#i#")#, <!--- bütçe tahakkuk --->
								YIELD_RATE = #evaluate("attributes.getiri_orani#i#")#, <!--- getiri oranı --->
								YIELD_PAYMENT_PERIOD = #evaluate("attributes.getiri_payment_period#i#")#, <!--- getiri ödeme periyodu --->
								START_PAYMENT_DATE = #attributes.action_date#, <!--- ödeme başlangıç tarihi --->
								DUE_VALUE = #evaluate("attributes.due_value#i#")#, <!--- vade / gün --->
								YIELD_AMOUNT_TOTAL = #evaluate("attributes.getiri_tutari#i#")#, <!--- getiri tutarı --->
								NUMBER_YIELD_COLLECTION = #evaluate("attributes.getiri_tahsil_sayisi#i#")#, <!--- tahsilyat sayısı --->
								YIELD_AMOUNT = #evaluate("attributes.getiri_tahsil_tutari#i#")#, <!--- getiri tahsil tutarı --->
								YGS = #evaluate("attributes.ygs#i#")#,
							</cfif>
							UPDATE_DATE = #now()#,
							UPDATE_EMP = #session.ep.userid#,
							UPDATE_IP = '#cgi.remote_addr#',
							ACTUAL_VALUE = #evaluate("attributes.purchase_value#i#")#,
							OTHER_ACTUAL_VALUE = #evaluate("attributes.other_purchase_value#i#")#
						WHERE 
							STOCKBOND_ID = #evaluate("attributes.stockbond_id#i#")#			
					</cfquery>
					<cfset stockbond_id_info = evaluate("attributes.stockbond_id#i#")>
				<cfelse>
					<cfquery name="ADD_STOCKBOND" datasource="#dsn2#">
						INSERT INTO
							#dsn3_alias#.STOCKBONDS
							(
								STOCKBOND_TYPE,
								STOCKBOND_CODE,
								DETAIL,
								NOMINAL_VALUE,
								OTHER_NOMINAL_VALUE,
								PURCHASE_VALUE,
								OTHER_PURCHASE_VALUE,
								QUANTITY,
								TOTAL_PURCHASE,
								OTHER_TOTAL_PURCHASE,
								ROW_EXP_CENTER_ID,
								ROW_EXP_ITEM_ID,
								DUE_DATE,
								BANK_ACTION_DATE,
								YIELD_TYPE,
								<cfif evaluate("attributes.getiri_type#i#") eq 1 or evaluate("attributes.getiri_type#i#") eq 3>
									ROW_EXP_TAHAKKUK_ITEM_ID, <!--- bütçe tahakkuk --->
									YIELD_RATE, <!--- getiri oranı --->
									YIELD_PAYMENT_PERIOD, <!--- getiri ödeme periyodu --->
									START_PAYMENT_DATE, <!--- ödeme başlangıç tarihi --->
									DUE_VALUE, <!--- vade / gün --->
									YIELD_AMOUNT_TOTAL, <!--- getiri tutarı --->
									NUMBER_YIELD_COLLECTION, <!--- tahsilyat sayısı --->
									YIELD_AMOUNT, <!--- getiri tahsil tutarı --->
									YGS,
								</cfif>
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP,
								ACTUAL_VALUE,
								OTHER_ACTUAL_VALUE	
							)
						VALUES
							(
								<cfif len(evaluate("attributes.bond_type#i#"))>#evaluate("attributes.bond_type#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.bond_code#i#"))>'#wrk_eval("attributes.bond_code#i#")#',<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.row_detail#i#"))>'#wrk_eval("attributes.row_detail#i#")#',<cfelse>NULL,</cfif>
								#evaluate("attributes.nominal_value#i#")#,
								#evaluate("attributes.other_nominal_value#i#")#,
								#evaluate("attributes.purchase_value#i#")#,
								#evaluate("attributes.other_purchase_value#i#")#,
								#evaluate("attributes.quantity#i#")#,
								#evaluate("attributes.total_purchase#i#")#,
								#evaluate("attributes.other_total_purchase#i#")#,
								<cfif len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.expense_item_id#i#"))>#evaluate("attributes.expense_item_id#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.due_date#i#"))>#evaluate("attributes.due_date#i#")#,<cfelse>NULL,</cfif>
								<cfif isdefined("attributes.account_id") and len(attributes.account_id)>#GET_ACT_ID.MAX_ID#<cfelse>NULL</cfif>,
								<cfif len(evaluate("attributes.getiri_type#i#"))>#evaluate("attributes.getiri_type#i#")#,<cfelse>NULL,</cfif>
								<cfif evaluate("attributes.getiri_type#i#") eq 1 or evaluate("attributes.getiri_type#i#") eq 3>
									#evaluate("attributes.expense_item_tahakkuk_id#i#")#,
									#evaluate("attributes.getiri_orani#i#")#,
									#evaluate("attributes.getiri_payment_period#i#")#,
									#attributes.action_date#,
									#evaluate("attributes.due_value#i#")#,
									#evaluate("attributes.getiri_tutari#i#")#,
									#evaluate("attributes.getiri_tahsil_sayisi#i#")#,
									#evaluate("attributes.getiri_tahsil_tutari#i#")#,
									#evaluate("attributes.ygs#i#")#,
								</cfif>
								#now()#,
								#session.ep.userid#,
								'#cgi.remote_addr#',
								#evaluate("attributes.purchase_value#i#")#,
								#evaluate("attributes.other_purchase_value#i#")#
							)
					</cfquery>
					<cfquery name="GET_STOCKBOND_ID" datasource="#dsn2#">
						SELECT MAX(STOCKBOND_ID) AS MAX_ID FROM #dsn3_alias#.STOCKBONDS
					</cfquery>
					<cfset stockbond_id_info = GET_STOCKBOND_ID.MAX_ID>		
				</cfif>
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
							YIELD_TYPE,
							<cfif evaluate("attributes.getiri_type#i#") eq 1 or evaluate("attributes.getiri_type#i#") eq 3>
								ROW_EXP_TAHAKKUK_ITEM_ID, <!--- bütçe tahakkuk --->
								YIELD_RATE, <!--- getiri oranı --->
								YIELD_PAYMENT_PERIOD, <!--- getiri ödeme periyodu --->
								START_PAYMENT_DATE, <!--- ödeme başlangıç tarihi --->
								DUE_VALUE, <!--- vade / gün --->
								YIELD_AMOUNT_TOTAL, <!--- getiri tutarı --->
								NUMBER_YIELD_COLLECTION, <!--- tahsilyat sayısı --->
								YIELD_AMOUNT, <!--- getiri tahsil tutarı --->
								YGS,
							</cfif>
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP				
						)
					VALUES
						(
							0,
							#attributes.action_id#,
							#stockbond_id_info#,
							'#wrk_eval("attributes.row_detail#i#")#',
							#evaluate("attributes.nominal_value#i#")#,
							#evaluate("attributes.other_nominal_value#i#")#,
							#evaluate("attributes.purchase_value#i#")#,
							#evaluate("attributes.other_purchase_value#i#")#,
							#evaluate("attributes.quantity#i#")#,
							#evaluate("attributes.total_purchase#i#")#,
							#evaluate("attributes.other_total_purchase#i#")#,
							'#attributes.rd_money#',
							<cfif len(evaluate("attributes.due_date#i#"))>#evaluate("attributes.due_date#i#")#,<cfelse>NULL,</cfif>
							<cfif len(evaluate("attributes.getiri_type#i#"))>#evaluate("attributes.getiri_type#i#")#,<cfelse>NULL,</cfif>
							<cfif evaluate("attributes.getiri_type#i#") eq 1 or evaluate("attributes.getiri_type#i#") eq 3>
								#evaluate("attributes.expense_item_tahakkuk_id#i#")#,
								#evaluate("attributes.getiri_orani#i#")#,
								#evaluate("attributes.getiri_payment_period#i#")#,
								#attributes.action_date#,
								#evaluate("attributes.due_value#i#")#,
								#evaluate("attributes.getiri_tutari#i#")#,
								#evaluate("attributes.getiri_tahsil_sayisi#i#")#,
								#evaluate("attributes.getiri_tahsil_tutari#i#")#,
								#evaluate("attributes.ygs#i#")#,
							</cfif>
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
							STOCKBOND_IN
						)
					VALUES
						(
							#stockbond_id_info#,
							#session.ep.period_id#,
							#attributes.action_id#,
							'#attributes.paper_no#',
							#process_type#,
							#evaluate("attributes.quantity#i#")#,
							#evaluate("attributes.quantity#i#")#
						)
				</cfquery>
			</cfif>

			<!--- EK TABLOYA GETİRİLER YAZILIR --->
			<cfquery name="get_budget_id" datasource="#dsn2#">
				select BUDGET_PLAN_ID, START_PAYMENT_DATE FROM #dsn3_alias#.STOCKBONDS where STOCKBOND_ID = #evaluate("attributes.stockbond_id#i#")#
			</cfquery>

			<cfquery name="DEL_INTEREST_YIELD_ROWS" datasource="#dsn2#">
				DELETE FROM #dsn3_alias#.STOCKBONDS_YIELD_PLAN_ROWS WHERE STOCKBOND_ID = #stockbond_id_info#
			</cfquery>
			
			<cfif evaluate("attributes.getiri_type#i#") eq 1 or evaluate("attributes.getiri_type#i#") eq 3>

				<cfset attributes.getiri_payment_period = evaluate("attributes.getiri_payment_period#i#")>
				<cfset attributes.expense_center_id = evaluate("attributes.expense_center_id#i#")>
				<cfset attributes.expense_item_tahakkuk_id = evaluate("attributes.expense_item_tahakkuk_id#i#")>
				<cfset attributes.getiri_tahsil_tutari = evaluate("attributes.getiri_tahsil_tutari#i#")>

				<cfloop from="1" to="#evaluate('attributes.getiri_tahsil_sayisi#i#')#" index="i">
					<cf_date tarih='attributes.bnk_action_date#i#'>

					<cfquery name="ADD_INTEREST_YIELD_ROWS" datasource="#dsn2#">
						INSERT INTO #dsn3_alias#.STOCKBONDS_YIELD_PLAN_ROWS
						(
							STOCKBOND_ID,
							OPERATION_NAME,
							IS_PAYMENT,
							BANK_ACTION_DATE,
							AMOUNT,
							EXPENSE_ITEM_TAHAKKUK_ID
						)
						VALUES (
							<cfqueryparam cfsqltype="cf_sql_integer" value="#stockbond_id_info#">,
							<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#i#. Getiri">,
							0,
							<cfqueryparam cfsqltype="cf_sql_date"  value="#evaluate('attributes.bnk_action_date#i#')#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.getiri_tutari_row#i#')#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.expense_item_tahakkuk_id#">
						)
					</cfquery>
				</cfloop>

			</cfif>
		</cfloop>
		
		<!--- Cari - Bütçe kayıtları --->
		<cfinclude template="upd_stockbond_purchase_1.cfm">	 
		
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
						#attributes.action_id#,
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
				action_id = #attributes.action_id#
				is_action_file = 1
				action_file_name='#get_process_type.action_file_name#'
				action_page='#request.self#?fuseaction=credit.add_stockbond_purchase&event=upd&action_id=#attributes.action_id#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		</cfif>	
	</cftransaction>
</cflock>

<script type="text/javascript">
window.location.href="<cfoutput>#request.self#?fuseaction=credit.add_stockbond_purchase&event=upd&action_id=#attributes.action_id#</cfoutput>";
</script>
