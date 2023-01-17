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
	product_currency_rate = 1;
	production_product_currency_rate =1 ;
	production_product_currency_rate =1;
	uretilen_toplam_miktar = 0;
	toplam_sarf_tutar = 0;
	toplam_fire_tutar = 0;
	GET_MONEYS=cfquery(datasource:"#dsn3#",sqlstring:"SELECT (RATE2/RATE1) AS RATE, MONEY FROM #dsn2_alias#.SETUP_MONEY ORDER BY MONEY");
	doviz_birimi = valuelist(GET_MONEYS.MONEY,',');
	doviz_rate= valuelist(GET_MONEYS.RATE,';');
	//sarf urunleri
	if( len(attributes.record_num_exit) ) 
		for(i=1;i lte attributes.record_num_exit; i=i+1) 
			if(evaluate("row_kontrol_exit#i#") eq 1)
			{	
				if( len(evaluate("attributes.cost_price_system_exit#i#")) )
					temp_cost_price_system_exit=evaluate("attributes.cost_price_system_exit#i#");
				else
					temp_cost_price_system_exit=0;
				if( len(evaluate("attributes.cost_price_exit#i#")) )
					temp_cost_price_exit=evaluate("attributes.cost_price_exit#i#");
				else
					temp_cost_price_exit=0;
				product_account_codes =  cfquery(datasource:'#dsn3#',sqlstring:'SELECT MATERIAL_CODE,DIMM_CODE,DIMM_YANS_CODE FROM PRODUCT_PERIOD WHERE PRODUCT_ID = #evaluate("attributes.product_id_exit#i#")# AND PERIOD_ID = #session.ep.period_id#');
				//product_currency_rate =listgetat(doviz_rate,listfind(doviz_birimi,evaluate("exit_money#i#")),';');
				str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.MATERIAL_CODE, ",");	// urunun hammadde hesabı alacakli
				str_alacak_tutar = ListAppend(str_alacak_tutar, wrk_round(temp_cost_price_system_exit*evaluate("amount_exit#i#")),",");	
				str_alacak_dovizli = ListAppend(str_alacak_dovizli, wrk_round(temp_cost_price_exit*evaluate("amount_exit#i#")),",");
				str_other_currency_alacak = ListAppend(str_other_currency_alacak,evaluate("money_exit#i#"),",");

				toplam_sarf_tutar = toplam_sarf_tutar + wrk_round(temp_cost_price_system_exit*evaluate("amount_exit#i#"));//toplam sarf_tutar uzerinden uretim malzemelerinin tutarı hesaplanacak
				str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.DIMM_YANS_CODE, ",");	// urunun Direkt İlk Mad.Mal. Yansıtma Hesabı alacakli
				str_alacak_tutar = ListAppend(str_alacak_tutar, wrk_round(temp_cost_price_system_exit*evaluate("amount_exit#i#")),",");	
				str_alacak_dovizli = ListAppend(str_alacak_dovizli, wrk_round(temp_cost_price_exit*evaluate("amount_exit#i#")),",");
				str_other_currency_alacak = ListAppend(str_other_currency_alacak,evaluate("money_exit#i#"),",");
				
				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.DIMM_CODE, ",");	 //urunun Direkt İlk. Mad. Mal. Hesabı borclanır
				str_borc_tutar = ListAppend(str_borc_tutar, wrk_round(temp_cost_price_system_exit*evaluate("amount_exit#i#")),",");	
				str_borc_dovizli = ListAppend(str_borc_dovizli, wrk_round(temp_cost_price_exit*evaluate("amount_exit#i#")),",");
				str_other_currency_borc = ListAppend(str_other_currency_borc,evaluate("money_exit#i#"),",");
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
					if( len(evaluate("attributes.cost_price_outage#tt#")) )
						temp_cost_price_outage=evaluate("attributes.cost_price_outage#tt#");
					else
						temp_cost_price_outage=0;
					product_account_codes =  cfquery(datasource:'#dsn3#',sqlstring:'SELECT ACCOUNT_CODE_PUR,ACCOUNT_LOSS FROM PRODUCT_PERIOD WHERE PRODUCT_ID =#evaluate("attributes.product_id_outage#tt#")# AND PERIOD_ID = #session.ep.period_id#');
					//outage_product_currency_rate =listgetat(doviz_rate,listfind(doviz_birimi,evaluate("outage_money#tt#")),';');
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.ACCOUNT_LOSS, ",");	//urunun fire hesabı alacaklı
					str_alacak_tutar = ListAppend(str_alacak_tutar, wrk_round(temp_cost_price_system_outage*evaluate("amount_outage#tt#")),",");	
					str_alacak_dovizli = ListAppend(str_alacak_dovizli, wrk_round(temp_cost_price_outage*evaluate("amount_outage#tt#")),",");
					str_other_currency_alacak = ListAppend(str_other_currency_alacak,evaluate("attributes.money_outage#tt#"),",");
					//fire tutarı (miktar* birim maliyet ) uretim sonucu urunlerinin maliyetini hesaplamada kullanılır.
					toplam_fire_tutar = toplam_fire_tutar + wrk_round(temp_cost_price_system_outage*evaluate("amount_outage#tt#"));
				}
		}
	//uretim sonucu olusan urunler
	if(len(attributes.record_num))
		for(k=1;k lte attributes.record_num; k=k+1) 
			if(evaluate("attributes.row_kontrol#k#"))
			{
				// uretim sonucu olusan urunlerin miktar*birim maliyetine baglı toplamları alınıyor,sarf tutarların uretim sonucu urunlerine dagıtımı bu tutar uzerinden hesaplanıyor 
				//production_product_currency_rate =listgetat(doviz_rate,listfind(doviz_birimi,evaluate("money_std#k#")),';');
				uretilen_toplam_miktar = uretilen_toplam_miktar + (evaluate("amount#k#")*evaluate("cost_price#k#"));
			}
		if ( len(listgetat(doviz_rate,listfind(doviz_birimi,session.ep.money2),';')) )
			product_currency_rate =listgetat(doviz_rate,listfind(doviz_birimi,session.ep.money2),';');
		else
			product_currency_rate =1;
		for(j=1;j lte attributes.record_num; j=j+1) 
			if(evaluate("attributes.row_kontrol#j#"))
			{
				//production_product_currency_rate =listgetat(doviz_rate,listfind(doviz_birimi,evaluate("money_std#j#")),';');
				product_account_codes =  cfquery(datasource:'#dsn3#',sqlstring:'SELECT ACCOUNT_CODE_PUR,HALF_PRODUCTION_COST,PRODUCTION_COST FROM PRODUCT_PERIOD WHERE PRODUCT_ID =#evaluate("attributes.product_id#j#")# AND PERIOD_ID = #session.ep.period_id#');
				if(uretilen_toplam_miktar neq 0)
					maliyet_oranı=uretilen_toplam_miktar;
				else
					maliyet_oranı=evaluate("amount#j#");

				str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.HALF_PRODUCTION_COST, ",");	// Yarı Mamul Hesabı alacakli
				str_alacak_tutar = ListAppend(str_alacak_tutar, wrk_round((toplam_sarf_tutar/maliyet_oranı)*evaluate("amount#j#") *evaluate("cost_price#j#")),",");	
				str_alacak_dovizli = ListAppend(str_alacak_dovizli, wrk_round( ((toplam_sarf_tutar/maliyet_oranı)*evaluate("amount#j#") *evaluate("cost_price#j#"))/product_currency_rate),",");
				str_other_currency_alacak = ListAppend(str_other_currency_alacak,iif(len(session.ep.money2),'session.ep.money2','session.ep.money'),",");

				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.HALF_PRODUCTION_COST, ",");	// Yarı Mamul Hesabı Borclanıyor
				str_borc_tutar = ListAppend(str_borc_tutar, wrk_round((toplam_sarf_tutar/maliyet_oranı)*evaluate("amount#j#") *evaluate("cost_price#j#")),",");	
				str_borc_dovizli = ListAppend(str_borc_dovizli, wrk_round( ((toplam_sarf_tutar/maliyet_oranı)*evaluate("amount#j#") *evaluate("cost_price#j#"))/product_currency_rate),",");
				str_other_currency_borc = ListAppend(str_other_currency_borc,iif(len(session.ep.money2),'session.ep.money2','session.ep.money'),",");
				
				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.PRODUCTION_COST, ",");	// Mamul Hesabı Borclanıyor
				str_borc_tutar = ListAppend(str_borc_tutar, wrk_round(((toplam_sarf_tutar+toplam_fire_tutar)/maliyet_oranı)*evaluate("amount#j#") *evaluate("cost_price#j#")),",");	
				str_borc_dovizli = ListAppend(str_borc_dovizli, wrk_round((((toplam_sarf_tutar+toplam_fire_tutar)/maliyet_oranı)*evaluate("amount#j#") *evaluate("cost_price#j#"))/product_currency_rate),",");
				str_other_currency_borc = ListAppend(str_other_currency_borc,iif(len(session.ep.money2),'session.ep.money2','session.ep.money'),",");
			}
	
	//1-3 kurus icin yuvarlama islemi yapılıyor
	temp_total_alacak = evaluate(ListChangeDelims(str_alacak_tutar,'+',','));
	temp_total_borc = evaluate(ListChangeDelims(str_borc_tutar,'+',','));
	temp_fark = round((temp_total_alacak-temp_total_borc)*100);
	if( temp_fark gte -3 and temp_fark lt 0 )
		{
		fark_account = cfquery(datasource:"#dsn3#",sqlstring:"SELECT FARK_GELIR FROM SETUP_INVOICE");
		str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, fark_account.FARK_GELIR, ",");
		str_alacak_tutar = ListAppend(str_alacak_tutar, abs(temp_fark/100), ",");
		str_alacak_dovizli = ListAppend(str_alacak_dovizli, abs(temp_fark/100),",");
		str_other_currency_alacak = ListAppend(str_other_currency_alacak,session.ep.money,",");
		}
	else if( temp_fark lte 3 and temp_fark gt 0 )
		{
		fark_account = cfquery(datasource:"#dsn3#",sqlstring:"SELECT FARK_GIDER FROM SETUP_INVOICE");
		str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, fark_account.FARK_GIDER, ",");
		str_borc_tutar = ListAppend(str_borc_tutar, abs(temp_fark/100), ",");
		str_borc_dovizli = ListAppend(str_borc_dovizli, abs(temp_fark/100),",");
		str_other_currency_borc = ListAppend(str_other_currency_borc,session.ep.money,",");
		}
		/*writeoutput('temp_total_alacak:#temp_total_alacak#---temp_total_borc:#temp_total_borc#<br/>');
		writeoutput('str_alacakli_hesaplar:#str_alacakli_hesaplar#<br/>str_alacak_tutar---#str_alacak_tutar#');
		writeoutput('str_borclu_hesaplar:#str_borclu_hesaplar#<br/>str_borc_tutar---#str_borc_tutar#');*/
</cfscript>
