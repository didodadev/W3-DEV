<!--- Cari ve Bütçe İşlemleri --->
<cfif len(attributes.company_id) and len(attributes.comp_name)>
	<cfscript>
		if(is_cari eq 1 and len(attributes.company_id) and len(attributes.comp_name))
		{
			carici(
				action_id : attributes.action_id,
				action_table : 'STOCKBONDS_SALEPURCHASE',
				workcube_process_type : process_type,
				workcube_old_process_type : attributes.old_process_type,
				account_card_type : 13,
				islem_tarihi : attributes.action_date,
				islem_tutari : (attributes.action_value+attributes.com_ytl),
				islem_belge_no : form.paper_no,
				from_cmp_id : attributes.company_id,
				from_branch_id : ListGetAt(session.ep.user_location,2,"-"),
				islem_detay : 'MENKUL KIYMET ALIŞ',
				action_detail : attributes.detail,
				other_money_value : attributes.purchase_other+attributes.com_other,
				other_money : attributes.rd_money,
				action_currency : SESSION.EP.MONEY,
				process_cat : form.process_cat,
				currency_multiplier : currency_multiplier,
				rate2:masraf_curr_multiplier
			);
		}
		else
			cari_sil(action_id:attributes.action_id, process_type:attributes.old_process_type);
		
		//Muhasebe Hareketleri
		if(is_account and isdefined("my_acc_result"))
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
			GET_NO_ = cfquery(datasource:"#dsn2#", sqlstring:"SELECT FARK_GELIR,FARK_GIDER FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
			//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
			str_fark_gelir =GET_NO_.FARK_GELIR;
			str_fark_gider =GET_NO_.FARK_GIDER;
			str_max_round = 0.1;
			str_round_detail = '#attributes.comp_name#-#attributes.paper_no# MENKUL KIYMET';
				
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
							satir_detay_list[1][listlen(str_borclu_tutarlar)]='#attributes.comp_name# - #evaluate("attributes.row_detail#j#")# - MENKUL KIYMET ALIŞ İŞLEMİ';
						}
						else
						{
							if (len(attributes.detail))
								satir_detay_list[1][listlen(str_borclu_tutarlar)]='#attributes.comp_name# - #attributes.detail# - MENKUL KIYMET ALIŞ İŞLEMİ';
							else
								satir_detay_list[1][listlen(str_borclu_tutarlar)]='#attributes.comp_name# - MENKUL KIYMET ALIŞ İŞLEMİ';
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
				satir_detay_list[1][listlen(str_borclu_tutarlar)]='#attributes.comp_name# - #attributes.com_exp_item_name# - MENKUL KIYMET ALIŞ İŞLEMİ';
			}
			else
			{
				if (len(attributes.detail))
					satir_detay_list[1][listlen(str_borclu_tutarlar)]='#attributes.comp_name# - #attributes.detail# - MENKUL KIYMET ALIŞ İŞLEMİ';
				else
					satir_detay_list[1][listlen(str_borclu_tutarlar)]='#attributes.comp_name# - MENKUL KIYMET ALIŞ İŞLEMİ';
			}
			
			//bankaya alis tutari toplami kadar alacak kaydeder
			str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,MY_ACC_RESULT);
			str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,attributes.action_value);
			str_alacakli_other_tutar = ListAppend(str_alacakli_other_tutar,attributes.purchase_other);
			str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,attributes.rd_money);
			
			if(is_account_group neq 1)
			{
				get_item_name = cfquery(datasource:"#dsn2#", sqlstring:"SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.expense_item_id1#");
				satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#attributes.comp_name# - #get_item_name.expense_item_name# - MENKUL KIYMET ALIŞ İŞLEMİ';
			}
			else
			{
				if (len(attributes.detail))
					satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#attributes.comp_name# - #attributes.detail# - MENKUL KIYMET ALIŞ İŞLEMİ';
				else
					satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#attributes.comp_name# - MENKUL KIYMET ALIŞ İŞLEMİ';
			}
			
			//bankaya komisyon tutari toplami kadar alacak kaydeder	
			str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,MY_ACC_RESULT);
			str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,attributes.com_ytl);
			str_alacakli_other_tutar = ListAppend(str_alacakli_other_tutar,attributes.com_other);
			str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,attributes.rd_money);
			
			if(is_account_group neq 1)
			{
				satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#attributes.comp_name# - #attributes.com_exp_item_name# - MENKUL KIYMET ALIŞ İŞLEMİ';
			}
			else
			{
				if (len(attributes.detail))
					satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#attributes.comp_name# - #attributes.detail# - MENKUL KIYMET ALIŞ İŞLEMİ';
				else
					satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#attributes.comp_name# - MENKUL KIYMET ALIŞ İŞLEMİ';
			}

			/* for(k=1; k lte attributes.record_num; k=k+1){
				if( isdefined("attributes.getiri_type#k#") and evaluate("attributes.getiri_type#k#") eq 1){
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
			} */
		
			muhasebeci (
				action_id : attributes.action_id,
				workcube_process_type : process_type,
				workcube_old_process_type : form.old_process_type,
				workcube_process_cat : form.process_cat,
				account_card_type : 13,
				company_id : attributes.company_id,
				islem_tarihi : attributes.action_date,
				belge_no : attributes.paper_no,
				fis_satir_detay : satir_detay_list,
				borc_hesaplar : str_borclu_hesaplar,
				borc_tutarlar : str_borclu_tutarlar,
				other_amount_borc : str_borclu_other_tutar,
				other_currency_borc : str_other_borc_currency_list,
				alacak_hesaplar : str_alacakli_hesaplar,
				alacak_tutarlar : str_alacakli_tutarlar,
				other_amount_alacak : str_alacakli_other_tutar,
				other_currency_alacak : str_other_alacak_currency_list,
				currency_multiplier : currency_multiplier,
				is_account_group : is_account_group,
				fis_detay: 'MENKUL KIYMET ALIŞ İŞLEMİ',
				from_branch_id : ListGetAt(session.ep.user_location,2,"-"),
				dept_round_account :str_fark_gider,
				claim_round_account : str_fark_gelir,
				max_round_amount :str_max_round,
				round_row_detail:str_round_detail
			);
		}
		else
			muhasebe_sil(action_id:attributes.action_id, process_type:form.old_process_type);
	</cfscript>
</cfif>

<cfscript>
	//masraf kayıtlarını siler
	butce_sil(action_id:attributes.action_id,process_type:form.old_process_type);
	if(is_budget eq 1 and len(attributes.expense_item_id1) and (attributes.action_value gt 0) and len(attributes.expense_center_id1))
	{
		butceci(
			action_id : attributes.action_id,
			muhasebe_db : dsn2,
			is_income_expense : false,
			process_type : process_type,
			nettotal : attributes.action_value,
			other_money_value : wrk_round(attributes.action_value/masraf_curr_multiplier),
			action_currency : attributes.rd_money,
			currency_multiplier : currency_multiplier,
			expense_date : attributes.action_date,
			expense_center_id : attributes.expense_center_id1,
			expense_item_id : attributes.expense_item_id1,
			detail : 'MENKUL KIYMET ALIŞ MASRAFI',
			paper_no : attributes.paper_no,
			company_id : attributes.company_id,
			branch_id : ListGetAt(session.ep.user_location,2,"-"),
			insert_type : 1
		);
	}
	if(is_budget eq 1 and len(attributes.com_exp_item_id) and len(attributes.com_exp_item_name) and (attributes.com_ytl gt 0) and len(attributes.com_exp_center_id) and len(attributes.com_exp_center))
	{
		butceci(
			action_id : attributes.action_id,
			muhasebe_db : dsn2,
			is_income_expense : false,
			process_type : process_type,
			nettotal : attributes.com_ytl,
			other_money_value :  wrk_round(attributes.com_ytl/masraf_curr_multiplier),
			action_currency : attributes.rd_money,
			currency_multiplier : currency_multiplier,
			expense_date : attributes.action_date,
			expense_center_id : attributes.com_exp_center_id,
			expense_item_id : attributes.com_exp_item_id,
			detail : 'MENKUL KIYMET ALIŞ MASRAFI',
			paper_no : attributes.paper_no,
			company_id : attributes.company_id,
			branch_id : ListGetAt(session.ep.user_location,2,"-"),
			insert_type : 1
		);
	}
</cfscript>
