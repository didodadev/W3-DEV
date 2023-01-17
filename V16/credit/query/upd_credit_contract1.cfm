<cfquery name="get_company_account" datasource="#DSN3#">
	SELECT ACCOUNT_CODE FROM #dsn_alias#.COMPANY_PERIOD  WHERE COMPANY_ID=#attributes.company_id# AND PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfscript>
	str_alacak_tutar_list="";
	str_alacak_kod_list="";
	str_borc_tutar_list="";
	str_borc_kod_list="";
	satir_detay_list = ArrayNew(2); 
	str_other_alacak_tutar_list = "";
	str_other_borc_tutar_list = "";
	str_other_borc_currency_list = "";
	str_other_alacak_currency_list = "";
	paper_currency_multiplier =1;
	currency_multiplier =1;
	if(isDefined('attributes.deger_get_money') and len(attributes.deger_get_money))
		for(mon=1;mon lte attributes.deger_get_money;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is rd_money_value)
				paper_currency_multiplier = wrk_round(evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#'),2);
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}
	for(j=1;j lte attributes.payment_record_num;j=j+1)
	{
		if (isdefined("attributes.payment_row_kontrol#j#") and evaluate("attributes.payment_row_kontrol#j#"))
		{
			//Ana Para tutarları finansal kiralama muhasebe koduna yazılıyor
			row_total_alacak = wrk_round((evaluate("attributes.payment_capital_price#j#"))+(evaluate("attributes.payment_interest_price#j#")));
			str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,row_total_alacak,",");
			str_alacak_kod_list = ListAppend(str_alacak_kod_list,'#evaluate("attributes.total_account_code#j#")#',",");
			str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list,row_total_alacak,",");
			str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,rd_money_value,",");
		
			
			//Faiz tutarları faiz muhasabe koduna yazılıyor
			row_total = wrk_round((evaluate("attributes.payment_interest_price#j#")),4);
			str_borc_tutar_list = ListAppend(str_borc_tutar_list,wrk_round((row_total),4),",");
			satir_detay_list[2][listlen(str_borc_tutar_list)]='#evaluate("attributes.payment_detail#j#")#';
			str_borc_kod_list = ListAppend(str_borc_kod_list,'#evaluate("attributes.borrow_code#j#")#',",");
			str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list, row_total,",");
			str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,rd_money_value,",");
			
			str_borc_tutar_list = ListAppend(str_borc_tutar_list,wrk_round((evaluate("attributes.payment_capital_price#j#"))),",");
			satir_detay_list[2][listlen(str_borc_tutar_list)]='#evaluate("attributes.payment_detail#j#")#';
			str_borc_kod_list = ListAppend(str_borc_kod_list,'#get_company_account.ACCOUNT_CODE#',",");
			str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list, wrk_round(evaluate("attributes.payment_capital_price#j#")),",");
			str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,rd_money_value,",");
		}
	}
	FARK_HESAP = cfquery(datasource:"#dsn3#",sqlstring:"SELECT FARK_GELIR,FARK_GIDER,YUVARLAMA_GELIR,YUVARLAMA_GIDER FROM SETUP_INVOICE_PURCHASE");
	str_fark_gelir =FARK_HESAP.FARK_GELIR;
	str_fark_gider =FARK_HESAP.FARK_GIDER;
	str_max_round = 0.1;
	str_round_detail = satir_detay_list;
	muhasebeci (
		action_id:attributes.credit_contract_id,
		workcube_process_type : process_type,
		workcube_old_process_type : form.old_process_type,
		muhasebe_db: dsn3,
		muhasebe_db_alias : dsn2_alias,
		account_card_type : 13,
		islem_tarihi : attributes.credit_date,
		company_id : attributes.company_id,
		borc_hesaplar : str_borc_kod_list,
		borc_tutarlar : str_borc_tutar_list,
		alacak_hesaplar : str_alacak_kod_list,
		alacak_tutarlar : str_alacak_tutar_list,
		fis_satir_detay: satir_detay_list,
		fis_detay : 'FİNANSAL KİRALAMA SÖZLEŞMESİ',
		from_branch_id : ListGetAt(session.ep.user_location,2,'-'),
		belge_no : full_paper_no,
		other_amount_borc : str_other_borc_tutar_list,
		other_currency_borc : str_other_borc_currency_list,
		other_amount_alacak : str_other_alacak_tutar_list,
		other_currency_alacak : str_other_alacak_currency_list,
		is_account_group : is_account_group,
		currency_multiplier : currency_multiplier,
		workcube_process_cat : form.process_cat,
		dept_round_account :str_fark_gider,
		claim_round_account : str_fark_gelir,
		max_round_amount :str_max_round,
		round_row_detail:str_round_detail,
		acc_project_id : iif((isdefined("attributes.related_project_id") and len(attributes.related_project_id) and isDefined("attributes.related_project_head") and len(attributes.related_project_head)),attributes.related_project_id,de(''))
	);
</cfscript>
