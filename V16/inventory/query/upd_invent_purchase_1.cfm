<!--- cari muhasebe işlemleri --->
<cfscript>
	str_alacak_tutar_list="";
	str_alacak_kod_list="";
	str_borc_tutar_list="";
	str_borc_kod_list="";
	satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar
	if(isDefined("attributes.detail") and len(attributes.detail))
		genel_fis_satir_detay = '#form.invoice_number#-#attributes.comp_name#-DEMİRBAŞ ALIM-#attributes.detail#';
	else
		genel_fis_satir_detay = '#form.invoice_number#-#attributes.comp_name#-DEMİRBAŞ ALIM';
	str_other_alacak_tutar_list = "";
	str_other_borc_tutar_list = "";
	str_other_borc_currency_list = "";
	str_other_alacak_currency_list = "";
	str_borclu_miktar = ArrayNew(1);
	str_borclu_tutar = ArrayNew(1);
	money_value=1;
	
	if((isDefined("attributes.invoice_payment_plan") and attributes.invoice_payment_plan eq 1) or not isDefined("attributes.invoice_payment_plan"))//odeme planini guncellememesi icin eklendi
	{
		if(is_cari eq 1)
		{
			cari_sil(action_id:attributes.invoice_id,process_type:form.old_process_type);  //parçalı odeme yapılabilecegi icin herhalukarda cari_rows siliniyor
			if(is_paymethod_based_cari eq 1 and isdefined('attributes.paymethod_id') and len(attributes.paymethod_id) and len(attributes.paymethod))
			{
				include('paymethod_based_cari_process_info.cfm');
				for(ind_t=1;ind_t lte listlen(row_duedate_list); ind_t=ind_t+1)
				{
					cari_row_duedate=listgetat(row_duedate_list,ind_t);
					carici(
						action_id : attributes.invoice_id,
						action_table : 'INVOICE',
						workcube_process_type : process_type,
						//workcube_old_process_type : form.old_process_type,
						account_card_type : 13,
						acc_type_id : acc_type_id,
						due_date : cari_row_duedate,
						islem_tarihi : attributes.invoice_date,
						islem_tutari : evaluate('row_amount_total_#ind_t#'),
						islem_belge_no : FORM.INVOICE_NUMBER,
						from_cmp_id : attributes.company_id,
						from_consumer_id : attributes.consumer_id,
						from_employee_id : attributes.emp_id,
						from_branch_id :attributes.branch_id,
						islem_detay : 'DEMİRBAŞ ALIM FATURASI',
						action_detail : attributes.detail,
						other_money_value : attributes.other_net_total_amount,
						other_money : rd_money_value,
						action_currency : SESSION.EP.MONEY,
						process_cat : form.process_cat,
						currency_multiplier : currency_multiplier,
						project_id : attributes.project_id,
						rate2: paper_currency_multiplier
					);
				}
			}
			else
			{
				carici(
					action_id : attributes.invoice_id,
					action_table : 'INVOICE',
					acc_type_id : acc_type_id,
					workcube_process_type : process_type,
					workcube_old_process_type : form.old_process_type,
					account_card_type : 13,
					due_date : invoice_due_date,
					islem_tarihi : attributes.invoice_date,
					islem_tutari : attributes.net_total_amount,
					islem_belge_no : FORM.INVOICE_NUMBER,
					from_cmp_id : attributes.company_id,
					from_consumer_id : attributes.consumer_id,
					from_employee_id : attributes.emp_id,
					from_branch_id : attributes.branch_id,
					islem_detay : 'DEMİRBAŞ ALIM FATURASI',
					action_detail : attributes.detail,
					other_money_value : attributes.other_net_total_amount,
					other_money : rd_money_value,
					action_currency : SESSION.EP.MONEY,
					process_cat : form.process_cat,
					currency_multiplier : currency_multiplier,
					project_id : attributes.project_id,
					rate2: paper_currency_multiplier
				);
			}
		}
		else
			cari_sil(action_id:attributes.invoice_id, process_type:form.old_process_type);
	}

	if(is_account eq 1)
	{
		str_alacak_tutar_list = attributes.net_total_amount;
		str_alacak_kod_list = MY_ACC_RESULT;
		satir_detay_list[2][listlen(str_alacak_tutar_list)] = genel_fis_satir_detay;
		str_other_alacak_tutar_list = attributes.other_net_total_amount;
		str_other_alacak_currency_list = rd_money_value;
		if(attributes.total_amount gt 0)
			genel_indirim_yuzdesi = attributes.net_total_discount / attributes.total_amount;
	 	else
			genel_indirim_yuzdesi = 0;
	  
	for(j=1;j lte attributes.record_num;j=j+1)
	{
		if (isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#"))
			{
				str_borc_tutar_list = ListAppend(str_borc_tutar_list,(evaluate("attributes.row_total#j#")*evaluate("attributes.quantity#j#")),",");
				if (is_account_group neq 1)
				{
					satir_detay_list[1][listlen(str_borc_tutar_list)]='#attributes.comp_name#-#evaluate("attributes.invent_name#j#")#';
				}
				else
				{
					if(isDefined("attributes.detail") and len(attributes.detail))
						satir_detay_list[1][listlen(str_borc_tutar_list)]='#attributes.comp_name#-DEMİRBAŞ ALIM-#attributes.detail#';
					else
						satir_detay_list[1][listlen(str_borc_tutar_list)]='#attributes.comp_name#-DEMİRBAŞ ALIM';
				}
				str_borc_kod_list = ListAppend(str_borc_kod_list,evaluate("attributes.account_id#j#"),",");
				indirimli_kdv= evaluate("attributes.kdv_total#j#")-(evaluate("attributes.kdv_total#j#")*genel_indirim_yuzdesi);
				if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
				{
					if(evaluate("attributes.hidden_rd_money_#mon#") is listfirst(evaluate("attributes.money_id#j#")))
						satir_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				}
				str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list, wrk_round(((evaluate("attributes.row_total#j#")*evaluate("attributes.quantity#j#"))/satir_currency_multiplier),2),",");
				str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),",");
				indirimli_kdv_doviz= ((evaluate("attributes.kdv_total#j#")/satir_currency_multiplier)-((evaluate("attributes.kdv_total#j#")/satir_currency_multiplier)*genel_indirim_yuzdesi));
				if(indirimli_kdv_doviz gt 0)
				{
					if( isdefined("attributes.tevkifat_box") and len(attributes.tevkifat_id))
						str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,wrk_round((indirimli_kdv-(indirimli_kdv*attributes.tevkifat_oran))/satir_currency_multiplier),",");	
					else 
						str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,indirimli_kdv_doviz,",");
					str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),",");
				}
				//kdv
				get_tax_acc_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT INVENTORY_PURCHASE_CODE,PURCHASE_CODE FROM SETUP_TAX WHERE TAX = #evaluate("attributes.tax_rate#j#")#");
				
				//Tevkifat hesaplamaları yapılıyor
				if( isdefined("attributes.tevkifat_box") and len(attributes.tevkifat_id))
				{//tevkifat
					satir_tevk_tutar = (indirimli_kdv*attributes.tevkifat_oran);
					tevkifat_acc_codes=cfquery(datasource:"#dsn2#",sqlstring:"SELECT 
							ST_ROW.TEVKIFAT_CODE,ST_ROW.TEVKIFAT_BEYAN_CODE_PUR,ST_ROW.TEVKIFAT_CODE_PUR,ST_ROW.TAX
						FROM 
							#dsn3_alias#.SETUP_TEVKIFAT S_TEV,#dsn3_alias#.SETUP_TEVKIFAT_ROW ST_ROW 
						WHERE
							S_TEV.TEVKIFAT_ID = ST_ROW.TEVKIFAT_ID AND
							S_TEV.TEVKIFAT_ID = #form.tevkifat_id# AND
							ST_ROW.TAX = #evaluate("attributes.tax_rate#j#")#
						ORDER BY ST_ROW.TAX");
				}
				//otv
				if(isDefined("attributes.otv_rate#j#") and len(evaluate("attributes.otv_rate#j#")) and evaluate("attributes.otv_rate#j#") gt 0)//varsa ötv hesaplar çekiliyor
					get_otv_acc_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT PURCHASE_CODE FROM #dsn3_alias#.SETUP_OTV WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND TAX = #evaluate("attributes.otv_rate#j#")#");

				if( isdefined("attributes.tevkifat_box") and len(attributes.tevkifat_oran))//tevkifat hesapları
					{//sadece tevkifat için tevkifat tutarları alacak hesaplara ekleniyor,kdv ler gene borca ilave ediliyor
						str_alacak_kod_list = ListAppend(str_alacak_kod_list,tevkifat_acc_codes.tevkifat_beyan_code_pur,",");		
						str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,wrk_round(indirimli_kdv-satir_tevk_tutar),",");
						if(listgetat(evaluate("attributes.money_id#j#"), 1, ',') neq session.ep.money)
							str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list,wrk_round((indirimli_kdv-satir_tevk_tutar)/satir_currency_multiplier),",");
						else
							str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list,wrk_round((indirimli_kdv-satir_tevk_tutar)),",");
						str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),",");
						satir_detay_list[2][listlen(str_alacak_tutar_list)] = genel_fis_satir_detay;
						tax_acc = tevkifat_acc_codes.tevkifat_code_pur;
					}
					else
						tax_acc = get_tax_acc_code.INVENTORY_PURCHASE_CODE;	
				
				//KDV hesaplamaları yapılıyor
				if(indirimli_kdv gt 0)
				{	if( isdefined("attributes.tevkifat_box") and len(attributes.tevkifat_oran))			
						str_borc_tutar_list = ListAppend(str_borc_tutar_list,wrk_round(indirimli_kdv-satir_tevk_tutar),",");
					else 
						str_borc_tutar_list = ListAppend(str_borc_tutar_list,indirimli_kdv,",");
					str_borc_kod_list = ListAppend(str_borc_kod_list,tax_acc,",");
					if (is_account_group neq 1)
					{
						satir_detay_list[1][listlen(str_borc_tutar_list)]='#attributes.comp_name#-#evaluate("attributes.invent_name#j#")#';
					}
					else
					{
						if(isDefined("attributes.detail") and len(attributes.detail))
							satir_detay_list[1][listlen(str_borc_tutar_list)]='#attributes.comp_name#-DEMİRBAŞ ALIM-#attributes.detail#';
						else
							satir_detay_list[1][listlen(str_borc_tutar_list)]='#attributes.comp_name#-DEMİRBAŞ ALIM';
					}
				}
				//OTV hesaplamalari yapiliyor
				if(isDefined("attributes.otv_rate#j#") and len(evaluate("attributes.otv_rate#j#")) and evaluate("attributes.otv_rate#j#") gt 0)
				{
					str_borc_tutar_list = ListAppend(str_borc_tutar_list,wrk_round(evaluate("attributes.otv_total#j#")),",");
					str_borc_kod_list = ListAppend(str_borc_kod_list,get_otv_acc_code.purchase_code,",");
					str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,(evaluate("attributes.otv_total#j#")/satir_currency_multiplier),",");
					str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),",");
					if (is_account_group neq 1)
					{
						satir_detay_list[1][listlen(str_borc_tutar_list)]='#attributes.comp_name#-#evaluate("attributes.invent_name#j#")#';
					}
					else
					{
						if(isDefined("attributes.detail") and len(attributes.detail))
							satir_detay_list[1][listlen(str_borc_tutar_list)]='#attributes.comp_name#-DEMİRBAŞ ALIM-#attributes.detail#';
						else
							satir_detay_list[1][listlen(str_borc_tutar_list)]='#attributes.comp_name#-DEMİRBAŞ ALIM';
					}
				}
				if( isdefined("attributes.tevkifat_box") and len(attributes.tevkifat_id))//tevkifat hesapları
					{						
						str_borc_tutar_list = ListAppend(str_borc_tutar_list,wrk_round(satir_tevk_tutar),",");
						str_borc_kod_list = ListAppend(str_borc_kod_list,get_tax_acc_code.purchase_code,",");
						str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,wrk_round((satir_tevk_tutar)/satir_currency_multiplier),",");
						str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),",");

					}
				//Fatura altı indirim varsa , her satır için seçilen hesaba indirim oranında alacak hesabına da yazıyor
				if(attributes.net_total_discount neq 0)
				{
					demirbas_toplam_indirim = wrk_round(evaluate("attributes.row_total#j#") * genel_indirim_yuzdesi* evaluate("attributes.quantity#j#"));
					str_other_alacak_tutar_list = listappend(str_other_alacak_tutar_list,wrk_round(demirbas_toplam_indirim/paper_currency_multiplier),',');
					str_other_alacak_currency_list = listappend(str_other_alacak_currency_list,rd_money_value,',');
					str_alacak_tutar_list = listappend(str_alacak_tutar_list,demirbas_toplam_indirim,',');
					str_alacak_kod_list = listappend(str_alacak_kod_list,evaluate("attributes.account_id#j#"),',');
					satir_detay_list[2][listlen(str_alacak_tutar_list)] = genel_fis_satir_detay;
				}
			}
		}
		//stopaj hesaplamalari
		if (isDefined('attributes.stopaj_rate_id') and len(attributes.stopaj_rate_id))//stopaj popuptan seçilmişse
			GET_SETUP_STOPPAGE_RATES = cfquery(datasource:"#dsn2#", sqlstring:"SELECT * FROM SETUP_STOPPAGE_RATES WHERE STOPPAGE_RATE_ID = #attributes.stopaj_rate_id#");
		else if (isDefined('attributes.stopaj_yuzde') and len(attributes.stopaj_yuzde))//stopaj popuptan seçilmişse
			GET_SETUP_STOPPAGE_RATES = cfquery(datasource:"#dsn2#", sqlstring:"SELECT * FROM SETUP_STOPPAGE_RATES WHERE STOPPAGE_RATE = #attributes.stopaj_yuzde#");
		if(isdefined("GET_SETUP_STOPPAGE_RATES") and len(attributes.stopaj))
		{
			str_alacak_kod_list = ListAppend(str_alacak_kod_list, GET_SETUP_STOPPAGE_RATES.STOPPAGE_ACCOUNT_CODE, ",");
			str_alacak_tutar_list = ListAppend(str_alacak_tutar_list, attributes.stopaj, ",");
			str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list,(attributes.stopaj/paper_currency_multiplier),",");
			str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,rd_money_value,",");
			satir_detay_list[2][listlen(str_alacak_tutar_list)] = genel_fis_satir_detay;
		}
		
		FARK_HESAP = cfquery(datasource:"#dsn2#",sqlstring:"SELECT FARK_GELIR,FARK_GIDER FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
		//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
		str_fark_gelir =FARK_HESAP.FARK_GELIR;
		str_fark_gider =FARK_HESAP.FARK_GIDER;
		str_max_round = 0.09;
		str_round_detail = genel_fis_satir_detay;
		if(isdefined('attributes.branch_id') and len(attributes.branch_id) )
			from_branch_id = attributes.branch_id;
		else
			from_branch_id = ListGetAt(session.ep.user_location,2,"-");
		muhasebeci (
			wrk_id:get_invoice.wrk_id,
			action_id:attributes.invoice_id,
			workcube_process_type : process_type,
			workcube_old_process_type : form.old_process_type,
			account_card_type : 13,
			islem_tarihi : attributes.invoice_date,
			company_id : attributes.company_id,
			consumer_id : attributes.consumer_id,
			employee_id : attributes.emp_id,
			borc_hesaplar : str_borc_kod_list,
			borc_tutarlar : str_borc_tutar_list,
			alacak_hesaplar : str_alacak_kod_list,
			alacak_tutarlar : str_alacak_tutar_list,
			fis_satir_detay: satir_detay_list,
			fis_detay : 'DEMİRBAŞ ALIM FATURASI',
			belge_no : form.invoice_number,
			other_amount_borc : str_other_borc_tutar_list,
			other_currency_borc : str_other_borc_currency_list,
			other_amount_alacak : str_other_alacak_tutar_list,
			other_currency_alacak : str_other_alacak_currency_list,
			from_branch_id : from_branch_id,
			borc_miktarlar : str_borclu_miktar,
			borc_birim_tutar : str_borclu_tutar,
			is_account_group : is_account_group,
			currency_multiplier : currency_multiplier,
			dept_round_account :str_fark_gider,
			claim_round_account : str_fark_gelir,
			max_round_amount :str_max_round,
			round_row_detail:str_round_detail,
			acc_department_id : acc_department_id,
			workcube_process_cat : form.process_cat,
			acc_project_id : attributes.project_id
		);
	}
	else
		muhasebe_sil(action_id:form.invoice_id, process_type:form.old_process_type);
	
	//Önce bütün bütçe hareketleri siliniyor aşağıda yine eklenecek
	butce_sil (action_id:attributes.invoice_id,muhasebe_db:dsn2,process_type:old_process_type);
	if(is_budget eq 1)
	{
		for(tt=1;tt lte attributes.record_num;tt=tt+1)
		{
			if(isdefined("attributes.row_kontrol#tt#") and evaluate("attributes.row_kontrol#tt#") and len(evaluate("attributes.expense_item_id#tt#")) and len(evaluate("attributes.expense_item_name#tt#")) and len(evaluate("attributes.expense_center_id#tt#")))
			{
				butceci(
					action_id : attributes.invoice_id,
					muhasebe_db : dsn2,
					is_income_expense : false,
					process_type : process_type,
					product_tax: evaluate("attributes.tax_rate#tt#"),//kdv
					nettotal : (evaluate("attributes.row_total#tt#") * evaluate("attributes.quantity#tt#")),//kdvsiz tutar
					other_money_value : wrk_round(evaluate("attributes.row_other_total#tt#")/((evaluate("attributes.tax_rate#tt#")+100)/100)),//kdvsiz  döviz toplam
					action_currency : listgetat(evaluate("attributes.money_id#tt#"),1,','),
					currency_multiplier : currency_multiplier,
					expense_date : attributes.invoice_date,
					expense_center_id : evaluate("attributes.expense_center_id#tt#"),
					expense_item_id : evaluate("attributes.expense_item_id#tt#"),
					detail : 'SABİT KIYMET ALIM GİDERİ',
					paper_no : form.invoice_number,
					company_id : attributes.company_id,
					consumer_id : attributes.consumer_id,
					employee_id : attributes.emp_id,
					branch_id : ListGetAt(session.ep.user_location,2,"-"),
					insert_type : 1//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
				);
			}
		}
	}
</cfscript>
<cfif isdefined("form.cash")><!--- kasa seçili ise --->
	<cfif len(get_invoice.cash_id)>
		<cfquery name="UPD_ALISF_KAPA" datasource="#dsn2#">
			UPDATE CASH_ACTIONS
			SET
				CASH_ACTION_FROM_CASH_ID = #ListFirst(attributes.kasa,";")#,
				ACTION_TYPE_ID = 34,
				BILL_ID = #attributes.invoice_id#,
				CASH_ACTION_TO_COMPANY_ID = <cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
				CASH_ACTION_TO_CONSUMER_ID = <cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
                CASH_ACTION_TO_EMPLOYEE_ID = <cfif len(attributes.emp_id)>#attributes.emp_id#<cfelse>NULL</cfif>,
				CASH_ACTION_VALUE = #attributes.net_total_amount/currency_multiplier_kasa#,
				CASH_ACTION_CURRENCY_ID = '#ListLast(attributes.kasa,";")#',
				ACTION_DATE = #attributes.invoice_date#,
				IS_PROCESSED = 1,
				PAPER_NO = '#FORM.INVOICE_NUMBER#',
				IS_ACCOUNT = <cfif is_account>1,<cfelse>0,</cfif>
				IS_ACCOUNT_TYPE = 12,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_DATE = #now()#,
				PROCESS_CAT = #form.process_cat#,
				ACTION_VALUE = #attributes.net_total_amount#,
				ACTION_CURRENCY_ID = '#session.ep.money#'
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2 = #wrk_round(attributes.net_total_amount/currency_multiplier,4)#
					,ACTION_CURRENCY_ID_2 = '#session.ep.money2#'
				</cfif>
			WHERE
				ACTION_ID=#get_invoice.cash_id#
		</cfquery>
		<cfset act_id = get_invoice.cash_id>
	<cfelse>
		<cfquery name="ADD_ALISF_KAPA" datasource="#dsn2#">
			INSERT INTO 
				CASH_ACTIONS
				(
					CASH_ACTION_FROM_CASH_ID,		
					ACTION_TYPE,
					ACTION_TYPE_ID,
					BILL_ID,
					CASH_ACTION_TO_COMPANY_ID,
					CASH_ACTION_TO_CONSUMER_ID,
					CASH_ACTION_VALUE,
					CASH_ACTION_CURRENCY_ID,
					ACTION_DATE,
					ACTION_DETAIL,
					IS_PROCESSED,
					PAPER_NO,
					IS_ACCOUNT,
					IS_ACCOUNT_TYPE,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					PROCESS_CAT,
					ACTION_VALUE,
					ACTION_CURRENCY_ID
					<cfif len(session.ep.money2)>
						,ACTION_VALUE_2
						,ACTION_CURRENCY_ID_2
					</cfif>
				)
			VALUES
				(
					#ListFirst(attributes.kasa,";")#,
					'DEMİRBAŞ ALIM FATURASI KAPAMA İŞLEMİ',
					34,
					#attributes.invoice_id#,
					<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
					#attributes.net_total_amount/currency_multiplier_kasa#,
					'#ListLast(attributes.kasa,";")#',
					#attributes.invoice_date#,
					'DEMİRBAŞ ALIM FATURASI KAPAMA İŞLEMİ',
					1,
					'#FORM.INVOICE_NUMBER#',
					<cfif is_account>1,12,<cfelse>0,12,</cfif>
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					#NOW()#,
					#form.process_cat#,
					#attributes.net_total_amount#,
					'#session.ep.money#'
					<cfif len(session.ep.money2)>
						,#wrk_round(attributes.net_total_amount/currency_multiplier,4)#
						,'#session.ep.money2#'
					</cfif>
				)
		</cfquery>
		<cfquery name="GET_ACT_ID" datasource="#dsn2#">
			SELECT MAX(ACTION_ID) AS ACT_ID FROM CASH_ACTIONS
		</cfquery>
		<cfset act_id=get_act_id.ACT_ID>
		<cfloop from="1" to="#attributes.kur_say#" index="i">
			<cfif isdefined("form.cash")><!--- kasa seçili ise --->
				<cfquery name="ADD_MONEY_INFO_3" datasource="#dsn2#">
					INSERT INTO CASH_ACTION_MONEY 
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					VALUES
					(
						#GET_ACT_ID.ACT_ID#,
						'#wrk_eval("attributes.hidden_rd_money_#i#")#',
						#evaluate("attributes.txt_rate2_#i#")#,
						#evaluate("attributes.txt_rate1_#i#")#,
						<cfif evaluate("attributes.hidden_rd_money_#i#") is rd_money_value>1<cfelse>0</cfif>
					)
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>

	<cfscript>
		DETAIL_2 = "DEMİRBAŞ ALIM FATURASI" & " KAPAMA İŞLEMİ";
		if(is_cari)//kasa cari
			carici(
				action_id : act_id,  
				action_table : 'CASH_ACTIONS',
				workcube_process_type : 34,
				workcube_old_process_type : 34,
				account_card_type : 12,
				acc_type_id : acc_type_id,
				due_date : invoice_due_date,
				islem_tarihi : attributes.invoice_date,
				islem_tutari : attributes.net_total_amount,
				islem_belge_no : FORM.INVOICE_NUMBER,
				to_cmp_id : attributes.company_id,
				to_consumer_id : attributes.consumer_id,
				to_employee_id : attributes.emp_id,
				islem_detay : DETAIL_2,
				action_detail : attributes.detail,
				other_money_value : (attributes.net_total_amount/currency_multiplier_kasa),
				other_money : ListLast(attributes.kasa,";"),
				action_currency : SESSION.EP.MONEY,
				from_cash_id : ListFirst(attributes.kasa,";"),
				from_branch_id : ListGetAt(session.ep.user_location,2,"-"),
				process_cat : form.process_cat,
				currency_multiplier : currency_multiplier_kasa,
				rate2: currency_multiplier_kasa
				);
		else if(len(get_invoice.cash_id))
				cari_sil(action_id:get_invoice.cash_id, process_type:34);
	</cfscript>
	<cfif is_account><!--- kasa muhasebe --->
		<cfquery name="get_cash_code" datasource="#dsn2#">
			SELECT CASH_ACC_CODE FROM CASH WHERE CASH_ID = #ListFirst(attributes.kasa,";")#
		</cfquery>
		<cfscript>
			DETAIL_2 = attributes.comp_name & " " & "DEMİRBAŞ ALIM FATURASI"  & " KAPAMA İŞLEMİ";
			muhasebeci(
				action_id : act_id,
				workcube_process_type : 34,
				workcube_old_process_type : 34,
				account_card_type : 12,//0,
				islem_tarihi : attributes.invoice_date,
				borc_hesaplar : MY_ACC_RESULT,
				borc_tutarlar : wrk_round(attributes.net_total_amount),
				alacak_hesaplar : get_cash_code.CASH_ACC_CODE,
				alacak_tutarlar : wrk_round(attributes.net_total_amount),
				fis_detay : '#DETAIL_2#',
				fis_satir_detay : 'Fatura Kapama İşlemi',
				from_branch_id : ListGetAt(session.ep.user_location,2,"-"),
				belge_no : form.invoice_number,
				is_account_group : is_account_group,
				currency_multiplier : currency_multiplier_kasa,
				acc_department_id : acc_department_id,
				acc_project_id : attributes.project_id
			);
		</cfscript>
	<cfelse>									
		<cfscript>
			if(len(get_invoice.cash_id))
				muhasebe_sil(action_id:get_invoice.cash_id, process_type:34);
		</cfscript>	
	</cfif>
	<cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
		UPDATE 
			INVOICE
		SET
			CASH_ID=#act_id#,
			KASA_ID=#ListFirst(attributes.kasa,";")#,
			IS_CASH=1,
			IS_ACCOUNTED = #is_account#
		WHERE
			INVOICE_ID=#attributes.invoice_id#
	</cfquery>
<cfelse>
	<cfif len(get_invoice.cash_id)><!--- eski kasa hareketlerini siler --->
		<cfquery name="DEL_CASH" datasource="#dsn2#">
			DELETE FROM	CASH_ACTIONS WHERE ACTION_ID=#GET_INVOICE.CASH_ID#
		</cfquery>
		<cfquery name="DEL_CASH" datasource="#dsn2#">
			DELETE FROM	CASH_ACTION_MONEY WHERE ACTION_ID=#GET_INVOICE.CASH_ID#
		</cfquery>
		<cfscript>
			muhasebe_sil(action_id:get_invoice.cash_id, process_type:34);
			cari_sil(action_id:get_invoice.cash_id, process_type:34);
		</cfscript>
	</cfif>
	<cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
		UPDATE 
			INVOICE
		SET
			CASH_ID = NULL,
			KASA_ID = NULL,
			IS_CASH = 0,
			IS_ACCOUNTED = 0
		WHERE
			INVOICE_ID=#attributes.invoice_id#
	</cfquery>
</cfif>
