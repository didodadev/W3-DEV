<!--- üretim sonucu için muhasebe fişi oluşturuluyor ozden20060420 --->
<cfscript>
	str_borclu_hesaplar = '' ;
	str_alacakli_hesaplar = '' ;
	str_borc_tutar = '' ;
	str_alacak_tutar = '' ;
	str_alacak_dovizli = '' ;
	str_borc_dovizli = '' ;
	str_other_currency_borc = '' ;
	str_other_currency_alacak = '';
	if(isdefined('attributes.production_department_id') and len(attributes.production_department_id) and isdefined('attributes.production_department') and len(attributes.production_department) and isdefined('attributes.production_branch_id') and len(attributes.production_branch_id))
		to_branch_id=attributes.production_branch_id;
	else
		to_branch_id=listgetat(session.ep.user_location,2,'-');
	//sarf urunleri
	if( len(attributes.record_num_exit) ) 
		for(i=1;i lte attributes.record_num_exit; i=i+1) 
			if(evaluate("row_kontrol_exit#i#") eq 1)
			{	
				if( len(evaluate("attributes.cost_price_system_exit#i#")) )
					temp_cost_price_system_exit=evaluate("attributes.cost_price_system_exit#i#");
				else
					temp_cost_price_system_exit=0;
				if( len(evaluate("attributes.purchase_extra_cost_system_exit#i#")) ) 
					temp_cost_price_system_exit=temp_cost_price_system_exit+evaluate("attributes.purchase_extra_cost_system_exit#i#");
				if( len(evaluate("attributes.cost_price_exit#i#")) )
					temp_cost_price_exit=evaluate("attributes.cost_price_exit#i#");
				else
					temp_cost_price_exit=0;
				if( len(evaluate("attributes.purchase_extra_cost_exit#i#") ) )
					temp_cost_price_exit = temp_cost_price_exit + filterNum(evaluate("attributes.purchase_extra_cost_exit#i#"));
				
				if(is_dept_based_acc eq 1)
				{
					dept_id = attributes.exit_department_id;
					loc_id = attributes.exit_location_id;
				}
				else
				{
					dept_id = 0;
					loc_id = 0;
				}
				sarf_account_codes = get_product_account(prod_id:evaluate("attributes.product_id_exit#i#"),period_id:session.ep.period_id,product_account_db:dsn3,product_alias_db:dsn3_alias,department_id:dept_id,location_id:loc_id);
				
				if(wrk_round(temp_cost_price_system_exit*evaluate("amount_exit#i#")) neq 0)
				{
					if(len(sarf_account_codes.ACCOUNT_EXPENDITURE))
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, sarf_account_codes.ACCOUNT_EXPENDITURE, ",");	 //urunun sarf hesabına borc yazılır
					else
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, ' ', ",");	 //urunun sarf hesabına borc yazılır
					str_borc_tutar = ListAppend(str_borc_tutar, wrk_round(temp_cost_price_system_exit*evaluate("amount_exit#i#")),",");	
					str_borc_dovizli = ListAppend(str_borc_dovizli, wrk_round(temp_cost_price_exit*evaluate("amount_exit#i#")),",");
					str_other_currency_borc = ListAppend(str_other_currency_borc,evaluate("money_exit#i#"),",");
					
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, sarf_account_codes.MATERIAL_CODE, ",");	// urunun hammadde hesabı alacakli
					str_alacak_tutar = ListAppend(str_alacak_tutar, wrk_round(temp_cost_price_system_exit*evaluate("amount_exit#i#")),",");	
					str_alacak_dovizli = ListAppend(str_alacak_dovizli, wrk_round(temp_cost_price_exit*evaluate("amount_exit#i#")),",");
					str_other_currency_alacak = ListAppend(str_other_currency_alacak,evaluate("money_exit#i#"),",");
				}
			}
	//fire urunler
	if( len(attributes.record_num_outage) )
		{
			for(tt=1;tt lte attributes.record_num_outage; tt=tt+1) 
				if(evaluate("attributes.row_kontrol_outage#tt#"))
				{
					if( len(evaluate("attributes.cost_price_system_outage#tt#")) )
						temp_cost_price_system_outage=evaluate("attributes.cost_price_system_outage#tt#");
					else
						temp_cost_price_system_outage=0;
						
					if( len(evaluate("attributes.purchase_extra_cost_system_outage#tt#") ) )
						temp_cost_price_system_outage=temp_cost_price_system_outage+evaluate("attributes.purchase_extra_cost_system_outage#tt#");
					
					if( len(evaluate("attributes.cost_price_outage#tt#")) )
						temp_cost_price_outage=evaluate("attributes.cost_price_outage#tt#");
					else
						temp_cost_price_outage=0;
						
					if(len(evaluate("attributes.purchase_extra_cost_outage#tt#") ))
						temp_cost_price_outage=temp_cost_price_outage+evaluate("attributes.purchase_extra_cost_outage#tt#");
					if(is_dept_based_acc eq 1)
					{
						dept_id = attributes.exit_department_id;
						loc_id = attributes.exit_location_id;
					}
					else
					{
						dept_id = 0;
						loc_id = 0;
					}
					fire_account_codes = get_product_account(prod_id:evaluate("attributes.product_id_outage#tt#"),period_id:session.ep.period_id,product_account_db:dsn3,product_alias_db:dsn3_alias,department_id:dept_id,location_id:loc_id);
					
					if(wrk_round(temp_cost_price_system_outage*evaluate("amount_outage#tt#")) gt 0)
					{
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, fire_account_codes.ACCOUNT_LOSS, ",");//urunun fire hesabı borclu
						str_borc_tutar = ListAppend(str_borc_tutar, wrk_round(temp_cost_price_system_outage*evaluate("amount_outage#tt#")),",");	
						str_borc_dovizli = ListAppend(str_borc_dovizli, wrk_round(temp_cost_price_outage*evaluate("amount_outage#tt#")),",");
						str_other_currency_borc = ListAppend(str_other_currency_borc,evaluate("attributes.money_outage#tt#"),",");
	
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, fire_account_codes.MATERIAL_CODE, ",");	// urunun hammadde hesabı alacakli
						str_alacak_tutar = ListAppend(str_alacak_tutar, wrk_round(temp_cost_price_system_outage*evaluate("amount_outage#tt#")),",");	
						str_alacak_dovizli = ListAppend(str_alacak_dovizli, wrk_round(temp_cost_price_outage*evaluate("amount_outage#tt#")),",");
						str_other_currency_alacak = ListAppend(str_other_currency_alacak,evaluate("money_outage#tt#"),",");
					}
				}
		}
	//1-9 kurus icin yuvarlama islemi yapılıyor
	if(len(str_alacak_tutar) and len(str_borc_tutar))
	{
		temp_total_alacak = evaluate(ListChangeDelims(str_alacak_tutar,'+',','));
		temp_total_borc = evaluate(ListChangeDelims(str_borc_tutar,'+',','));
		temp_fark = round((temp_total_alacak-temp_total_borc)*100);
	}
	else
		temp_fark = 0;
	if( temp_fark gte -9 and temp_fark lt 0 )
		{
		fark_account = cfquery(datasource:"#dsn3#",sqlstring:"SELECT FARK_GELIR FROM SETUP_INVOICE");
		str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, fark_account.FARK_GELIR, ",");
		str_alacak_tutar = ListAppend(str_alacak_tutar, abs(temp_fark/100), ",");
		str_alacak_dovizli = ListAppend(str_alacak_dovizli, abs(temp_fark/100),",");
		str_other_currency_alacak = ListAppend(str_other_currency_alacak,session.ep.money,",");
		}
	else if( temp_fark lte 9 and temp_fark gt 0 )
		{
		fark_account = cfquery(datasource:"#dsn3#",sqlstring:"SELECT FARK_GIDER FROM SETUP_INVOICE");
		str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, fark_account.FARK_GIDER, ",");
		str_borc_tutar = ListAppend(str_borc_tutar, abs(temp_fark/100), ",");
		str_borc_dovizli = ListAppend(str_borc_dovizli, abs(temp_fark/100),",");
		str_other_currency_borc = ListAppend(str_other_currency_borc,session.ep.money,",");
		}
</cfscript>
