<!--- Stok virman ekleme ve guncelleme sayfalari icin ortak muhasebe hareketi yapiliyor 20130819 EsraNur --->
<cfscript>
	str_alacakli_hesaplar = '';
	str_borclu_hesaplar = '';
	borc_alacak_tutarlar = '';
	borc_alacak_dovizli_tutarlar = '';
	borc_alacak_doviz_currency = '';
	currency_multiplier = '';
	
	for(i=1;i lte attributes.stock_record_num;i=i+1)
	{
		if(evaluate("attributes.row_kontrol#i#") and evaluate('attributes.row_kontrol#i#') eq 1)
		{			
			/* cikan stoktaki urun cikis depo */
			product_account_codes_out = get_product_account(prod_id:evaluate("attributes.exit_product_id#i#"),period_id:session.ep.period_id,product_account_db:dsn2,product_alias_db:dsn3_alias);
			if(is_scrap_out eq 1)
				str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes_out.SCRAP_CODE, ",");
			else if(location_type_out eq 1) //depo hammadde lokasyon 
				str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes_out.MATERIAL_CODE, ",");		
			else if(location_type_out eq 3) //depo mamul lokasyon 
				str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes_out.PRODUCTION_COST, ",");		
			else //mal lokasyon 
				str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes_out.ACCOUNT_CODE_PUR, ",");	
			
			/* giren stoktaki urun giris depo */
			product_account_codes_in = get_product_account(prod_id:evaluate("attributes.product_id#i#"),period_id:session.ep.period_id,product_account_db:dsn2,product_alias_db:dsn3_alias);
			if(is_scrap_in eq 1)
				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes_in.SCRAP_CODE, ",");
			else if(location_type_in eq 1) //depo hammadde lokasyon 
				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes_in.MATERIAL_CODE, ",");		
			else if(location_type_in eq 3) //depo mamul lokasyon 
				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes_in.PRODUCTION_COST, ",");		
			else //mal lokasyon 
				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes_in.ACCOUNT_CODE_PUR, ",");		
			
			// cikan stoktaki urun maliyet ve kur bilgisi, borc ve alacaga bunu yazacagiz*/
			get_prod_cost_amounts = cfquery(datasource:"#dsn2#",sqlstring:"SELECT TOP 1 PRODUCT_ID, ISNULL(PURCHASE_NET+PURCHASE_EXTRA_COST,0) PURCHASE_NET_ALL, ISNULL(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM,0) PURCHASE_NET_SYSTEM_ALL, PURCHASE_NET_MONEY, PURCHASE_NET_SYSTEM_MONEY_2 FROM #dsn3_alias#.PRODUCT_COST WHERE PRODUCT_ID = #evaluate("attributes.exit_product_id#i#")# AND START_DATE <= #attributes.process_date# ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC");
			if(get_prod_cost_amounts.recordcount)
			{
				net_system_all = get_prod_cost_amounts.PURCHASE_NET_SYSTEM_ALL;
				net_all = get_prod_cost_amounts.PURCHASE_NET_ALL;
				net_money = get_prod_cost_amounts.PURCHASE_NET_MONEY;
				cost_money = get_prod_cost_amounts.PURCHASE_NET_SYSTEM_MONEY_2;
			}
			else
			{
				net_system_all = 0;
				net_all = 0;
				net_money = '';
				cost_money = '';
			}
				
			borc_alacak_tutarlar = ListAppend(borc_alacak_tutarlar, net_system_all*evaluate("attributes.exit_amount#i#"), ","); 
			borc_alacak_dovizli_tutarlar = ListAppend(borc_alacak_dovizli_tutarlar, net_all*evaluate("attributes.exit_amount#i#"), ","); 
			borc_alacak_doviz_currency = ListAppend(borc_alacak_doviz_currency, net_money, ",");
			
			if(cost_money neq session.ep.money)
			{
				get_money = cfquery(datasource:"#dsn2#",sqlstring:"SELECT (RATE2/RATE1) AS RATE, MONEY FROM #dsn_alias#.MONEY_HISTORY WHERE VALIDATE_DATE <= #attributes.process_date# AND PERIOD_ID = #session.ep.period_id# AND MONEY = '#cost_money#' ORDER BY MONEY_HISTORY_ID DESC");
				if(get_money.recordcount and len(get_money.RATE))
				{
					currency_multiplier = get_money.RATE;
				}
				else
				{
					get_money_ = cfquery(datasource:"#dsn2#",sqlstring:"SELECT (RATE2/RATE1) AS RATE, MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY = '#cost_money#'");
					currency_multiplier = get_money_.RATE;
				}
			}
			else
			{
				currency_multiplier = 1;
			}
		}
	}
</cfscript>

