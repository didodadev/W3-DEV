<!--- Cari ve Bütçe İşlemleri --->
<cfif len(attributes.company_id) and len(attributes.comp_name)>
	<cfscript>
		//Cari Islem
		if(is_cari eq 1 and len(attributes.company_id) and len(attributes.comp_name))
		{
			carici(
				action_id : get_action_id.max_id,
				action_table : 'STOCKBONDS_SALEPURCHASE',
				workcube_process_type : process_type,
				account_card_type : 13,
				islem_tarihi : attributes.action_date,
				islem_tutari : (attributes.action_value+attributes.com_ytl),
				islem_belge_no : FORM.paper_no,
				to_cmp_id : attributes.company_id,
				to_branch_id : ListGetAt(session.ep.user_location,2,"-"),
				islem_detay : 'MENKUL KIYMET SATIŞ',
				action_detail : attributes.detail,
				other_money_value : attributes.sale_other+attributes.com_other,
				other_money : attributes.rd_money,
				action_currency : SESSION.EP.MONEY,
				process_cat : form.process_cat,
				currency_multiplier : currency_multiplier,
				rate2:masraf_curr_multiplier
			);
		}
		//Muhasebe Hareketleri
		if(is_account and isdefined("my_acc_result"))
		{
			//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
			GET_NO_ = cfquery(datasource:"#dsn2#", sqlstring:"SELECT FARK_GELIR,FARK_GIDER FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
			satir_detay_list = ArrayNew(2);
			str_fark_gelir =GET_NO_.FARK_GELIR;
			str_fark_gider =GET_NO_.FARK_GIDER;
			str_max_round = 0.1;
			str_round_detail = '#attributes.comp_name#-#attributes.paper_no# MENKUL KIYMET';
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
					if( isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#") eq 1)
					{
						//toplam nominal deger kadar,toplam satis gider kalemine ait muhasebe koduna alacak kaydeder
						str_alacakli_hesaplar = listappend(str_alacakli_hesaplar,attributes.acc_id);
						str_alacakli_tutarlar = listappend(str_alacakli_tutarlar,evaluate("attributes.nominal_value#j#")*evaluate("attributes.quantity#j#"));
						str_alacakli_other_tutar = listappend(str_alacakli_other_tutar,evaluate("attributes.other_nominal_value#j#")*evaluate("attributes.quantity#j#"));
						str_other_alacak_currency_list = listappend(str_other_alacak_currency_list,attributes.rd_money,',');
						
						if(is_account_group neq 1)
						{
							satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#attributes.comp_name# - #evaluate("attributes.row_detail#j#")# - MENKUL KIYMET SATIŞ İŞLEMİ';
						}
						else
						{
							if (len(attributes.detail))
								satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#attributes.comp_name# - #attributes.detail# - MENKUL KIYMET SATIŞ İŞLEMİ';
							else
								satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#attributes.comp_name# - MENKUL KIYMET SATIŞ İŞLEMİ';
						}
						//cariye, komisyon tutari kadar alacak kaydeder
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,MY_ACC_RESULT);
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
						if ((evaluate("attributes.sale_value#j#")-evaluate("attributes.nominal_value#j#")) < 0)
						{
							str_borclu_hesaplar = listappend(str_borclu_hesaplar,attributes.total_income_acc_id);
							str_borclu_tutarlar = listappend(str_borclu_tutarlar,abs(evaluate("attributes.sale_value#j#")-evaluate("attributes.nominal_value#j#"))*evaluate("attributes.quantity#j#"));
							str_borclu_other_tutar = listappend(str_borclu_other_tutar,abs(evaluate("attributes.other_sale_value#j#")-evaluate("attributes.other_nominal_value#j#"))*evaluate("attributes.quantity#j#"));
							str_other_borc_currency_list = listappend(str_other_borc_currency_list,attributes.rd_money,',');
							
							if(is_account_group neq 1)
							{
								satir_detay_list[1][listlen(str_borclu_tutarlar)]='#attributes.comp_name# - #evaluate("attributes.row_detail#j#")# - MENKUL KIYMET SATIŞ İŞLEMİ';
							}
							else
							{
								if (len(attributes.detail))
									satir_detay_list[1][listlen(str_borclu_tutarlar)]='#attributes.comp_name# - #attributes.detail# - MENKUL KIYMET SATIŞ İŞLEMİ';
								else
									satir_detay_list[1][listlen(str_borclu_tutarlar)]='#attributes.comp_name# - MENKUL KIYMET SATIŞ İŞLEMİ';
							}
						}
						else if (0 < evaluate("attributes.sale_value#j#")-evaluate("attributes.nominal_value#j#"))
						{
							//toplam gelir kadar, gelir kalemine ait muhasebe koduna alacak kaydeder
							str_alacakli_hesaplar = listappend(str_alacakli_hesaplar,attributes.total_income_acc_id);
							str_alacakli_tutarlar = listappend(str_alacakli_tutarlar,(evaluate("attributes.sale_value#j#")-evaluate("attributes.nominal_value#j#"))*evaluate("attributes.quantity#j#"));
							str_alacakli_other_tutar = listappend(str_alacakli_other_tutar,(evaluate("attributes.other_sale_value#j#")-evaluate("attributes.other_nominal_value#j#"))*evaluate("attributes.quantity#j#"));
							str_other_alacak_currency_list = listappend(str_other_alacak_currency_list,attributes.rd_money,',');
							
							if(is_account_group neq 1)
							{
								satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#attributes.comp_name# - #evaluate("attributes.row_detail#j#")# - MENKUL KIYMET SATIŞ İŞLEMİ';
							}
							else
							{
								if (len(attributes.detail))
									satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#attributes.comp_name# - #attributes.detail# - MENKUL KIYMET SATIŞ İŞLEMİ';
								else
									satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#attributes.comp_name# - MENKUL KIYMET SATIŞ İŞLEMİ';
							}
						}
					}
				}
			}
			//cariye, toplam satis tutari kadar borc kaydeder
			str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,MY_ACC_RESULT);
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
				satir_detay_list[1][listlen(str_borclu_hesaplar)]='#attributes.comp_name# - #attributes.com_exp_item_name# - MENKUL KIYMET SATIŞ İŞLEMİ';
			}
			else
			{
				if (len(attributes.detail))
					satir_detay_list[1][listlen(str_borclu_hesaplar)]='#attributes.comp_name# - #attributes.detail# - MENKUL KIYMET SATIŞ İŞLEMİ';
				else
					satir_detay_list[1][listlen(str_borclu_hesaplar)]='#attributes.comp_name# - MENKUL KIYMET SATIŞ İŞLEMİ';
			}
	
			muhasebeci (
				action_id : GET_ACTION_ID.MAX_ID,
				workcube_process_type : process_type,
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
				fis_detay: 'MENKUL KIYMETLER SATIŞ FATURASI',
				from_branch_id : ListGetAt(session.ep.user_location,2,"-"),
				dept_round_account :str_fark_gider,
				claim_round_account : str_fark_gelir,
				max_round_amount :str_max_round,
				round_row_detail:str_round_detail
			);
		}
	</cfscript>
</cfif>

<cfscript>
	//nominal degere bagli elde edilen gelir
	if(is_budget eq 1 and len(attributes.expense_item_id) and len(attributes.expense_item_name) and (attributes.nominal_total_amount gt 0) and len(attributes.expense_center_id) and len(attributes.expense_center))
	{
		butceci(
			action_id : get_action_id.max_id,
			muhasebe_db : dsn2,
			is_income_expense : true,
			process_type : process_type,
			nettotal : attributes.nominal_total_amount,
			other_money_value :  wrk_round(attributes.nominal_total_amount/masraf_curr_multiplier),
			action_currency : attributes.rd_money,
			currency_multiplier : currency_multiplier,
			expense_date : attributes.action_date,
			expense_center_id : attributes.expense_center_id,
			expense_item_id : attributes.expense_item_id,
			detail : 'MENKUL KIYMET SATIŞ GELİRİ',
			paper_no : attributes.paper_no,
			company_id : attributes.company_id,
			branch_id : ListGetAt(session.ep.user_location,2,"-"),
			insert_type : 1
		);
	}
	//toplam gelir pozitif ise butceye gelir olarak kaydedilir
    if(is_budget eq 1 and len(attributes.total_income_exp_item_id) and len(attributes.total_income_exp_item_name) and (attributes.total_income gt 0) and len(attributes.total_income_exp_center_id) and len(attributes.total_income_exp_center))
	{
		butceci(
			action_id : get_action_id.max_id,
			muhasebe_db : dsn2,
			is_income_expense : true,
			process_type : process_type,
			nettotal : attributes.total_income,
			other_money_value :  wrk_round(attributes.total_income/masraf_curr_multiplier),
			action_currency : attributes.rd_money,
			currency_multiplier : currency_multiplier,
			expense_date : attributes.action_date,
			expense_center_id : attributes.total_income_exp_center_id,
			expense_item_id : attributes.total_income_exp_item_id,
			detail : 'MENKUL KIYMET SATIŞ GELİRİ',
			paper_no : attributes.paper_no,
			company_id : attributes.company_id,
			branch_id : ListGetAt(session.ep.user_location,2,"-"),
			insert_type : 1
		);
	}
	//toplam gelir negatif ise butceye gider olarak kaydedilir
	else if(is_budget eq 1 and len(attributes.total_income_exp_item_id) and len(attributes.total_income_exp_item_name) and (attributes.total_income lt 0) and len(attributes.total_income_exp_center_id) and len(attributes.total_income_exp_center))
	{
		butceci(
			action_id : get_action_id.max_id,
			muhasebe_db : dsn2,
			is_income_expense : false,
			process_type : process_type,
			nettotal : abs(attributes.total_income),
			other_money_value :  wrk_round(abs(attributes.total_income)/masraf_curr_multiplier),
			action_currency : attributes.rd_money,
			currency_multiplier : currency_multiplier,
			expense_date : attributes.action_date,
			expense_center_id : attributes.total_income_exp_center_id,
			expense_item_id : attributes.total_income_exp_item_id,
			detail : 'MENKUL KIYMET SATIŞ GİDERİ',
			paper_no : attributes.paper_no,
			company_id : attributes.company_id,
			branch_id : ListGetAt(session.ep.user_location,2,"-"),
			insert_type : 1
		);
	}
	//komisyon gideri
	if(is_budget eq 1 and len(attributes.com_exp_item_id) and len(attributes.com_exp_item_name) and (attributes.com_ytl gt 0) and len(attributes.com_exp_center_id) and len(attributes.com_exp_center))
	{
		butceci(
			action_id : get_action_id.max_id,
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
			detail : 'MENKUL KIYMET SATIŞ GİDERİ',
			paper_no : attributes.paper_no,
			company_id : attributes.company_id,
			branch_id : ListGetAt(session.ep.user_location,2,"-"),
			insert_type : 1
		);
	}
</cfscript>
