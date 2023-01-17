<!--- Demirbaş stok fişi muhasebesi --->
<cfscript>
	str_alacak_tutar_list="";
	str_alacak_kod_list="";
	str_borc_tutar_list="";
	str_borc_kod_list="";
	satir_detay_list = "";
	str_other_alacak_tutar_list = "";
	str_other_borc_tutar_list = "";
	str_other_borc_currency_list = "";
	str_other_alacak_currency_list = "";
	genel_fis_satir_detay = '#attributes.fis_no# DEMİRBAŞ STOK FİŞİ';
	satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar
	str_alacak_miktar = ArrayNew(1);
	str_alacak_tutar = ArrayNew(1) ;
	//Bütçe İşlemleri 
	if(is_budget eq 1)
	{
		//Önce bütün bütçe hareketleri siliniyor aşağıda yine eklenecek
		// add ve upd de ortak kullanılmış. O yüzden fis_id kontrolü koyuyorum.
		if( isDefined("attributes.fis_id") ){
			butce_sil(action_id:attributes.fis_id,process_type:form.old_process_type);
		}
		for(j=1;j lte attributes.record_num;j=j+1)
		{
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
				{
					if(evaluate("attributes.hidden_rd_money_#mon#") is listfirst(evaluate("attributes.money_id#j#"),','))
						masraf_curr_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				}
			net_total=evaluate("attributes.row_total#j#")*evaluate("attributes.quantity#j#");//+evaluate("attributes.kdv_total#j#")
			amor_net_total = net_total * evaluate("attributes.amortization_rate#j#")/100;
			if (len(evaluate("attributes.expense_item_name#j#")) and len(evaluate("attributes.expense_center_id#j#")))
			{
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
					expense_item_id : evaluate("attributes.expense_item_id#j#"),
					detail : '#evaluate("attributes.invent_name#j#")#',
					paper_no : attributes.FIS_NO,
					branch_id : ListGetAt(session.ep.user_location,2,"-"),
					insert_type :1,
					activity_type = evaluate("attributes.activity_type#j#")
				);
			}
		}
	}
	else if(isDefined("attributes.fis_id") and Len(attributes.fis_id))
		butce_sil(action_id:attributes.fis_id,process_type:form.old_process_type);

	if(is_account eq 1)
	{
		if( len(attributes.location_id_2) and len(attributes.department_id_2)) 
		{
			LOCATION_OUT=cfquery(datasource:"#dsn2#",sqlstring:"SELECT SL.LOCATION_TYPE,D.BRANCH_ID,IS_SCRAP FROM #dsn_alias#.STOCKS_LOCATION SL, #dsn_alias#.DEPARTMENT D WHERE D.DEPARTMENT_ID=SL.DEPARTMENT_ID AND SL.DEPARTMENT_ID=#attributes.department_id_2# AND SL.LOCATION_ID=#attributes.location_id_2#");
			location_type_out = LOCATION_OUT.LOCATION_TYPE;
			is_scrap_out = LOCATION_OUT.IS_SCRAP;
		}
		else
		{location_type_out ='';	is_scrap_out='';}
		for(j=1;j lte attributes.record_num;j=j+1)
		{
		 if (isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#"))
		 {
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
					for(mon=1;mon lte attributes.kur_say;mon=mon+1)
					{
						if(evaluate("attributes.hidden_rd_money_#mon#") is listfirst(evaluate("attributes.money_id#j#")))
							satir_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					}			
			//fis_satir_row_detail = '#attributes.fis_no# - DEMİRBAŞ STOK FİŞİ';
			get_tax_acc_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT PURCHASE_CODE,SALE_CODE FROM SETUP_TAX WHERE TAX = #evaluate("attributes.tax_rate#j#")#");
			str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,(evaluate("attributes.row_total#j#")*evaluate("attributes.quantity#j#")),",");
			if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and len(attributes.project_id) and len(attributes.project_head))	// proje bazlı muhasebe islemi yapılacaksa
			{
				is_project_acc=1;
				product_account_codes=cfquery(datasource:"#dsn2#",sqlstring:"SELECT	ACCOUNT_CODE_PUR,SCRAP_CODE,MATERIAL_CODE,PRODUCTION_COST FROM #dsn3_alias#.PROJECT_PERIOD WHERE PROJECT_ID = #attributes.project_id# AND PERIOD_ID = #session.ep.period_id# ");
			}
			else if(len(evaluate("attributes.product_id#j#")))
				product_account_codes = get_product_account(prod_id:evaluate("attributes.product_id#j#"));
			if(isdefined("product_account_codes.ACCOUNT_CODE_PUR"))
			{
				if(is_scrap_out eq 1)
					product_account_code = product_account_codes.SCRAP_CODE;
				else if(location_type_out eq 1) //cikis depo hammadde lokasyon 
					product_account_code = product_account_codes.MATERIAL_CODE;
				else if(location_type_out eq 3) //cikis depo mamul lokasyon 
					product_account_code = product_account_codes.PRODUCTION_COST;
				else //cikis depo mal lokasyon 
					product_account_code = product_account_codes.ACCOUNT_CODE_PUR;
			}
			else
				product_account_code = '';
			str_alacak_miktar[listlen(str_alacak_tutar_list)] = '#evaluate("attributes.quantity#j#")#';
			str_alacak_tutar[listlen(str_alacak_tutar_list)] = '#evaluate("attributes.row_total#j#")#'; 
			satir_detay_list[2][listlen(str_alacak_tutar_list)]='#evaluate("attributes.invent_name#j#")#';
			str_alacak_kod_list = ListAppend(str_alacak_kod_list,product_account_code,",");
			if(len(evaluate("attributes.tax_rate#j#")) and evaluate("attributes.tax_rate#j#") gt 0)
			{
				str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,(evaluate("attributes.kdv_total#j#")),",");
				str_alacak_kod_list = ListAppend(str_alacak_kod_list,get_tax_acc_code.purchase_code,",");
				str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list,(evaluate("attributes.kdv_total#j#")/satir_currency_multiplier),",");
				str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),",");
			}
			str_alacak_miktar[listlen(str_alacak_tutar_list)] = '';
			str_alacak_tutar[listlen(str_alacak_tutar_list)] = ''; 
			satir_detay_list[2][listlen(str_alacak_tutar_list)]=genel_fis_satir_detay;
			str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list,((evaluate("attributes.row_total#j#")*evaluate("attributes.quantity#j#"))/satir_currency_multiplier),",");
			str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),",");

			str_borc_tutar_list = ListAppend(str_borc_tutar_list,((evaluate("attributes.row_total#j#")*evaluate("attributes.quantity#j#"))+evaluate("attributes.kdv_total#j#")),",");
			str_borc_kod_list = ListAppend(str_borc_kod_list,evaluate("attributes.account_id#j#"),",");
			satir_detay_list[1][listlen(str_borc_tutar_list)] = genel_fis_satir_detay;
			str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,(((evaluate("attributes.row_total#j#")*evaluate("attributes.quantity#j#"))+evaluate("attributes.kdv_total#j#"))/satir_currency_multiplier),",");
			str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),",");
			str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,listgetat(evaluate("attributes.money_id#j#"), 1, ','),",");
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
			satir_detay_list[2][listlen(str_alacak_tutar_list)]=genel_fis_satir_detay;
			str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list, abs(temp_fark/100),",");
			str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,session.ep.money,",");
			}
		else if( temp_fark lte 3 and temp_fark gt 0 )
			{/* gider hesabi borclulara eklenmeli, alacak bakiye gelmis */
			str_borc_kod_list = ListAppend(str_borc_kod_list, FARK_HESAP.FARK_GIDER, ",");
			str_borc_tutar_list = ListAppend(str_borc_tutar_list, abs(temp_fark/100), ",");
			satir_detay_list[1][listlen(str_borc_tutar_list)]=genel_fis_satir_detay;
			str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list, abs(temp_fark/100),",");
			str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,session.ep.money,",");
			}
		if(not isdefined("old_process_type")) old_process_type = 0;
		if(isdefined("attributes.project_id") and len(attributes.project_id) and isDefined("attributes.project_head") and len(attributes.project_head))
			acc_project_id_ = attributes.project_id;
		else
			acc_project_id_ =  '';
		
		muhasebeci (
			wrk_id:wrk_id,
			action_id:GET_S_ID.max_id,
			workcube_process_type : attributes.process_type,
			workcube_old_process_type : old_process_type,
			account_card_type : 13,
			islem_tarihi : attributes.start_date,
			borc_hesaplar : str_borc_kod_list,
			borc_tutarlar : str_borc_tutar_list,
			alacak_hesaplar : str_alacak_kod_list,
			alacak_tutarlar : str_alacak_tutar_list,
			fis_satir_detay: satir_detay_list,
			fis_detay : 'DEMİRBAŞ STOK FİŞİ',
			belge_no : attributes.FIS_NO,
			from_branch_id : branch_id_2, //CIKIS depo
			to_branch_id : branch_id, //giris depo
			other_amount_borc : str_other_borc_tutar_list,
			other_currency_borc : str_other_borc_currency_list,
			other_amount_alacak : str_other_alacak_tutar_list,
			other_currency_alacak : str_other_alacak_currency_list,
			alacak_miktarlar : str_alacak_miktar,
			alacak_birim_tutar : str_alacak_tutar,
			is_account_group : is_account_group,
			currency_multiplier : currency_multiplier,
			workcube_process_cat : form.process_cat,
			acc_project_id : acc_project_id_
		);
	}
	else if(isDefined("attributes.fis_id") and Len(attributes.fis_id))
		muhasebe_sil(action_id:attributes.fis_id, process_type:form.old_process_type);
</cfscript>
