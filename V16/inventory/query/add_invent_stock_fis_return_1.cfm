<!--- Demirbaş stok fişi muhasebesi --->
<cfscript>
	// alacak ve borc tutar, aciklama vs muhasebeciye ters gonderilmistir.
	// alacak icin satir_detay_list[1]; borc icin satir_detay_list[2]
	str_alacak_tutar_list="";
	str_alacak_kod_list="";
	str_borc_tutar_list="";
	str_borc_kod_list="";
	satir_detay_list = "";
	str_other_alacak_tutar_list = "";
	str_other_borc_tutar_list = "";
	str_other_borc_currency_list = "";
	str_other_alacak_currency_list = "";
	if(isDefined('attributes.detail') and len(attributes.detail))
		genel_fis_satir_detay = '#attributes.fis_no# - #attributes.detail#';
	else
		genel_fis_satir_detay = '#attributes.fis_no# DEMİRBAŞ STOK İADE FİŞİ';
	satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar
	str_alacak_miktar = ArrayNew(1);
	str_alacak_tutar = ArrayNew(1) ;

	//Bütçe İşlemleri 
	if(is_budget eq 1)
	{
		for(j=1;j lte attributes.record_num;j=j+1)
		{
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
				{
					if(evaluate("attributes.hidden_rd_money_#mon#") is listfirst(evaluate("attributes.money_id#j#"),','))
						masraf_curr_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				}
			net_total=evaluate("attributes.row_total#j#")*evaluate("attributes.quantity#j#");//+evaluate("attributes.kdv_total#j#")
					temp_fis_date = CreateDateTime(year(attributes.start_date),month(attributes.start_date),day(attributes.start_date),0,0,0);
	 				temp_entry_date = CreateDateTime(year(evaluate("attributes.entry_date#j#")),month(evaluate("attributes.entry_date#j#")),day(evaluate("attributes.entry_date#j#")),0,0,0);					
					toplam_year = DateDiff("d",temp_entry_date,temp_fis_date)/360;
					if (toplam_year gte 1)
					{
						amor_net_total = net_total - (net_total * evaluate("attributes.amortization_rate#j#")/100);
						
					}
						
					else {
						amor_net_total = net_total;
					}
			if (len(evaluate("attributes.budget_item_name#j#")) and len(evaluate("attributes.budget_item_id#j#")) and len(evaluate("attributes.expense_center_id#j#")))
			butceci(
				action_id : GET_S_ID.max_id,
				muhasebe_db : dsn2,
				is_income_expense : false,
				process_type : attributes.process_type,
				product_tax: evaluate("attributes.tax_rate#j#"),//kdv
				nettotal : wrk_round(amor_net_total),
				other_money_value : wrk_round(amor_net_total/masraf_curr_multiplier),
				action_currency : listfirst(evaluate("attributes.money_id#j#"),','),
				currency_multiplier : currency_multiplier,
				expense_date : attributes.start_date,
				expense_center_id : evaluate("attributes.expense_center_id#j#"),
				expense_item_id : evaluate("attributes.budget_item_id#j#"),
				detail : '#evaluate("attributes.invent_name#j#")#',
				belge_no : attributes.FIS_NO,
				branch_id : ListGetAt(session.ep.user_location,2,"-"),
				insert_type :1
				);
		}
	}

	if(is_account eq 1)
	{
		for(j=1;j lte attributes.record_num;j=j+1)
		{
		 if (isDefined('attributes.row_kontrol#j#') and evaluate("attributes.row_kontrol#j#") eq 1)
		 {
		 	if(evaluate("attributes.last_diff_value#j#") eq 0)//Eğer karlı veya zararlı bir satışsa ilk değer üzerinden gideceke değilse son değer üzerinden gidecek
				value_new = evaluate("attributes.last_inventory_value#j#")/evaluate("attributes.quantity#j#");
			else
				value_new = evaluate("attributes.unit_first_value#j#");
				
			fis_satir_row_detail = '#attributes.fis_no# - DEMİRBAŞ STOK İADE FİŞİ';
			get_tax_acc_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT PURCHASE_CODE,SALE_CODE FROM #dsn2_alias#.SETUP_TAX WHERE TAX = #evaluate("attributes.tax_rate#j#")#");
			get_product_id = cfquery(datasource : "#dsn2#", sqlstring : "SELECT PRODUCT_ID FROM #dsn3_alias#.STOCKS WHERE STOCK_ID = #evaluate("attributes.stock_id#j#")#");
			str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,(evaluate("attributes.row_total#j#")*evaluate("attributes.quantity#j#")),",");
			if(is_account_group eq 1)
				satir_detay_list[1][listlen(str_alacak_tutar_list)] = genel_fis_satir_detay;	
			else
				satir_detay_list[1][listlen(str_alacak_tutar_list)] = '#evaluate("attributes.invent_name#j#")#';
			if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and len(attributes.project_id) and len(attributes.project_head))	// proje bazlı muhasebe islemi yapılacaksa
			{
				is_project_acc=1;
				product_account_codes=cfquery(datasource:"#dsn2#",sqlstring:"SELECT	ACCOUNT_CODE_PUR,MATERIAL_CODE,PRODUCTION_COST,SCRAP_CODE FROM #dsn3_alias#.PROJECT_PERIOD WHERE PROJECT_ID = #attributes.project_id# AND PERIOD_ID = #session.ep.period_id# ");
			}
			else
			{
				product_account_codes = get_product_account(prod_id:get_product_id.product_id);
			}
			if (location_type eq 1) //hammadde lokasyonu secilmisse
				product_account_code = product_account_codes.MATERIAL_CODE;
			else if (location_type eq 3)//mamul lokasyonu secilmisse
				product_account_code = product_account_codes.PRODUCTION_COST;
			else
				product_account_code = product_account_codes.ACCOUNT_CODE_PUR;
			str_alacak_kod_list = ListAppend(str_alacak_kod_list,product_account_code,",");
			str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,(evaluate("attributes.kdv_total#j#")),",");
			if(is_account_group eq 1)
				satir_detay_list[1][listlen(str_alacak_tutar_list)] = genel_fis_satir_detay;	
			else
				satir_detay_list[1][listlen(str_alacak_tutar_list)]='#evaluate("attributes.invent_name#j#")#';
			str_alacak_kod_list = ListAppend(str_alacak_kod_list,get_tax_acc_code.purchase_code,",");
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
				{
					if(evaluate("attributes.hidden_rd_money_#mon#") is listfirst(evaluate("attributes.money_id#j#")))
						satir_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				}
			str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list, wrk_round(((evaluate("attributes.row_total#j#")*evaluate("attributes.quantity#j#"))/satir_currency_multiplier),2),",");
			str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list,wrk_round((evaluate("attributes.kdv_total#j#")/satir_currency_multiplier),2),",");
			str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),",");
			str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),",");
			str_borc_tutar_list = ListAppend(str_borc_tutar_list,((evaluate("attributes.unit_first_value#j#")*evaluate("attributes.quantity#j#"))+evaluate("attributes.kdv_total#j#")),",");
			if(is_account_group eq 1)
				satir_detay_list[2][listlen(str_borc_tutar_list)] = genel_fis_satir_detay;	
			else
				satir_detay_list[2][listlen(str_borc_tutar_list)] = '#evaluate("attributes.invent_name#j#")#';
			str_borc_kod_list = ListAppend(str_borc_kod_list,evaluate("attributes.account_id#j#"),",");
			str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,(((evaluate("attributes.unit_first_value#j#")*evaluate("attributes.quantity#j#"))+evaluate("attributes.kdv_total#j#"))/satir_currency_multiplier),",");
			str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),",");
			str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),",");
			
			if(evaluate("attributes.last_diff_value#j#") gte 0)
			{
				if(evaluate("attributes.last_diff_value#j#") gt 0)
				{
					str_other_borc_tutar_list = listappend(str_other_borc_tutar_list,wrk_round(evaluate("attributes.last_diff_value#j#")/satir_currency_multiplier),',');
					str_other_borc_currency_list = listappend(str_other_borc_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),',');
					str_borc_tutar_list = listappend(str_borc_tutar_list,evaluate("attributes.last_diff_value#j#"),',');
					str_borc_kod_list = listappend(str_borc_kod_list,evaluate("attributes.budget_account_id#j#"),',');
					if(is_account_group eq 1)
						satir_detay_list[2][listlen(str_borc_tutar_list)] = genel_fis_satir_detay;	
					else
						satir_detay_list[2][listlen(str_borc_tutar_list)] = '#evaluate("attributes.invent_name#j#")#';
				}
				str_other_alacak_tutar_list = listappend(str_other_alacak_tutar_list,wrk_round(abs(evaluate("attributes.last_inventory_value#j#")-evaluate("attributes.total_first_value#j#"))/satir_currency_multiplier),',');
				str_other_alacak_currency_list = listappend(str_other_alacak_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),',');
				str_alacak_tutar_list = listappend(str_alacak_tutar_list,abs(evaluate("attributes.last_inventory_value#j#")-evaluate("attributes.total_first_value#j#")),',');
				str_alacak_kod_list = listappend(str_alacak_kod_list,evaluate("attributes.amort_account_id#j#"),',');
				if(is_account_group eq 1)
					satir_detay_list[1][listlen(str_alacak_tutar_list)] = genel_fis_satir_detay;	
				else
					satir_detay_list[1][listlen(str_alacak_tutar_list)] = '#evaluate("attributes.invent_name#j#")#';
			}
			else if(evaluate("attributes.last_diff_value#j#") lt 0)
			{
				str_other_alacak_tutar_list = listappend(str_other_alacak_tutar_list,wrk_round(abs(evaluate("attributes.last_diff_value#j#"))/satir_currency_multiplier),',');
				str_other_alacak_currency_list = listappend(str_other_alacak_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),',');
				str_alacak_tutar_list = listappend(str_alacak_tutar_list,abs(evaluate("attributes.last_diff_value#j#")),',');
				str_alacak_kod_list = listappend(str_alacak_kod_list,evaluate("attributes.budget_account_id#j#"),',');
				if(is_account_group eq 1)
					satir_detay_list[1][listlen(str_alacak_tutar_list)] = genel_fis_satir_detay;	
				else
					satir_detay_list[1][listlen(str_alacak_tutar_list)] = '#evaluate("attributes.invent_name#j#")#';
				
				str_other_alacak_tutar_list = listappend(str_other_alacak_tutar_list,wrk_round(abs(evaluate("attributes.last_inventory_value#j#")-evaluate("attributes.total_first_value#j#"))/satir_currency_multiplier),',');
				str_other_alacak_currency_list = listappend(str_other_alacak_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),',');
				str_alacak_tutar_list = listappend(str_alacak_tutar_list,abs(evaluate("attributes.last_inventory_value#j#")-evaluate("attributes.total_first_value#j#")),',');
				str_alacak_kod_list = listappend(str_alacak_kod_list,evaluate("attributes.amort_account_id#j#"),',');
				if(is_account_group eq 1)
					satir_detay_list[1][listlen(str_alacak_tutar_list)] = genel_fis_satir_detay;	
				else
					satir_detay_list[1][listlen(str_alacak_tutar_list)] = '#evaluate("attributes.invent_name#j#")#';
			}
		}
	   }
		//BORC-ALACAK FARKI ICIN YUVARLAMA TUTARLARI EKLENIYOR
		temp_total_alacak = evaluate(ListChangeDelims(str_alacak_tutar_list,'+',','));/* alacakli hesaplar toplam degeri */
		temp_total_borc = evaluate(ListChangeDelims(str_borc_tutar_list,'+',','));/* borclu hesaplar toplam degeri */
		temp_fark = round((temp_total_alacak-temp_total_borc)*100);
		if(temp_fark neq 0)
			FARK_HESAP = cfquery(datasource:"#dsn2#",sqlstring:"SELECT FARK_GELIR,FARK_GIDER FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
		
		if( temp_fark gte -3 and temp_fark lt 0 )
		{/* gelir hesabi alacaklilara eklenmeli, borc bakiye gelmis */
			str_alacak_kod_list = ListAppend(str_alacak_kod_list, FARK_HESAP.FARK_GELIR, ",");
			str_alacak_tutar_list = ListAppend(str_alacak_tutar_list, abs(temp_fark/100), ",");
			satir_detay_list[1][listlen(str_alacak_tutar_list)]=genel_fis_satir_detay;
			str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list, abs(temp_fark/100),",");
			str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,session.ep.money,",");
		}
		else if( temp_fark lte 3 and temp_fark gt 0 )
		{/* gider hesabi borclulara eklenmeli, alacak bakiye gelmis */
			str_borc_kod_list = ListAppend(str_borc_kod_list, FARK_HESAP.FARK_GIDER, ",");
			str_borc_tutar_list = ListAppend(str_borc_tutar_list, abs(temp_fark/100), ",");
			satir_detay_list[2][listlen(str_borc_tutar_list)]=genel_fis_satir_detay;
			str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list, abs(temp_fark/100),",");
			str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,session.ep.money,",");
		}
		if (isdefined("attributes.project_id") and len (attributes.project_id) and isDefined ("attributes.project_head"))
		{
			project_id_ = attributes.project_id;
		}
		else
		{
			project_id_ = '';
		}
		muhasebeci (
			wrk_id:wrk_id,
			action_id:GET_S_ID.max_id,
			workcube_process_type : attributes.process_type,
			account_card_type : 13,
			islem_tarihi : attributes.start_date,			
			alacak_hesaplar : str_borc_kod_list,
			alacak_tutarlar : str_borc_tutar_list,			
			borc_hesaplar : str_alacak_kod_list,
			borc_tutarlar : str_alacak_tutar_list,			
			fis_satir_detay: satir_detay_list,
			fis_detay : 'DEMİRBAŞ STOK İADE FİŞİ',
			belge_no : attributes.FIS_NO,			
			other_amount_alacak : str_other_borc_tutar_list,
			other_currency_alacak : str_other_borc_currency_list,			
			other_amount_borc : str_other_alacak_tutar_list,
			other_currency_borc : str_other_alacak_currency_list,			
			from_branch_id : branch_id_2, //CIKIS depo
			to_branch_id : branch_id, //giris depo
			is_account_group : is_account_group,
			currency_multiplier : currency_multiplier,
			workcube_process_cat : form.process_cat,
			acc_project_id :  project_id_
		);
	}
</cfscript>
