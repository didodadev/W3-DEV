<cfscript>
	if(is_account_premium eq 1)
	{
		GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.expense_item_id_2#");
		alacak_tutarlar = '';
		alacak_hesaplar = '';
		other_currency_alacak_list= '';
		other_amount_alacak_list= '';

		//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
		GET_NO_ = cfquery(datasource:"#dsn2#", sqlstring:"SELECT FARK_GELIR,FARK_GIDER FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
		str_fark_gelir = get_no_.fark_gelir;
		str_fark_gider = get_no_.fark_gider;
		str_max_round = 0.1;
		str_round_detail = 'PRİM ÖDEMESİ';
		
		for(i=1; i lte get_rows.recordcount; i=i+1)
		{
			my_acc_result = GET_CONSUMER_PERIOD(get_rows.consumer_id[i]);
			if(get_rows.PAY_AMOUNT[i] gt 0)
			{
				alacak_tutarlar=listappend(alacak_tutarlar,get_rows.pay_amount[i],',');
				other_currency_alacak_list = listappend(other_currency_alacak_list,session.ep.money,',');
				other_amount_alacak_list =  listappend(other_amount_alacak_list,get_rows.pay_amount[i],',');
				alacak_hesaplar=listappend(alacak_hesaplar,my_acc_result, ',');
			}			
			if(get_rows.stoppage_amount[i] gt 0)
			{
				GET_ACC_CODE_ROW=cfquery(datasource:"#dsn2#", sqlstring:"SELECT STOPPAGE_ACCOUNT_CODE FROM SETUP_STOPPAGE_RATES WHERE STOPPAGE_RATE_ID = #listlast(attributes.stoppage_rate,';')#");
				alacak_tutarlar = listappend(alacak_tutarlar,get_rows.stoppage_amount[i],',');
				other_currency_alacak_list = listappend(other_currency_alacak_list,session.ep.money,',');
				other_amount_alacak_list =  listappend(other_amount_alacak_list,get_rows.stoppage_amount[i],',');
				alacak_hesaplar=listappend(alacak_hesaplar,GET_ACC_CODE_ROW.STOPPAGE_ACCOUNT_CODE, ',');
			}
		}
		muhasebeci (
			action_id:get_max_id_pre.max_id,
			workcube_process_type:process_type_premium,
			account_card_type:13,
			action_table :'INVOICE_MULTILEVEL_PAYMENT',
			islem_tarihi:attributes.action_date,
			borc_hesaplar: GET_ACC_CODE.ACCOUNT_CODE,
			borc_tutarlar: total_amount,
			other_amount_borc : total_amount,
			other_currency_borc : session.ep.money,
			alacak_hesaplar: alacak_hesaplar,
			alacak_tutarlar: alacak_tutarlar,
			other_amount_alacak : other_amount_alacak_list,
			other_currency_alacak : other_currency_alacak_list,
			fis_detay:'PRİM ÖDEMESİ',
			fis_satir_detay:'PRİM ÖDEMESİ',
			to_branch_id : listgetat(session.ep.user_location,2,'-'),
			workcube_process_cat : form.process_cat,
			is_account_group : is_account_group_premium,
			dept_round_account :str_fark_gider,
			claim_round_account : str_fark_gelir,
			max_round_amount :str_max_round,
			round_row_detail:str_round_detail				
			);
	}
</cfscript>
