<!--- depo sevk ve ithal mal girisi icin; muhasebe tutar ve hesapları bu sayfada set ediliyor OZDEN03042006 --->
<cfquery name="GET_NO_" datasource="#dsn2#">
	SELECT 
		* 
	FROM
		#dsn3_alias#.SETUP_INVOICE_PURCHASE
</cfquery>
<cfscript>
	satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar. satir_detay_list[1]'a  borc yazan satırların acıklamaları, satir_detay_list[2]'a alacak yazan satırların acıklamaları set edilir. 
	if(get_process_type.process_type eq 81)
		genel_fis_satir_detay = 'DEPO SEVK İRSALİYESİ';
	else
		genel_fis_satir_detay = 'İTHAL MAL GİRİŞİ';
	str_borclu_hesaplar = '' ;
	str_alacakli_hesaplar = '' ;
	borc_alacak_tutar = '' ;
	str_dovizli_tutarlar = '' ;
	str_doviz_currency = '';
	str_miktar = ArrayNew(1);
	str_tutar = ArrayNew(1) ;
	acc_project_list_alacak='';
	acc_project_list_borc='';
	currency_multiplier = '';//basketin secili olan kurun degeri muh islemlerinde kullaniliyor
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');

	str_fark_gelir =GET_NO_.FARK_GELIR;
	str_fark_gider =GET_NO_.FARK_GIDER;
	str_max_round = 0.5;
	str_round_detail = genel_fis_satir_detay;
	for(i=1;i lte attributes.rows_;i=i+1){
		if(isdefined('location_type_in')) //depo sevk -ithal mal girişi icin
			{
				if(is_dept_based_acc eq 1)
				{
					dept_id = attributes.department_in_id;
					loc_id = attributes.location_in_id;
				}
				else
				{
					dept_id = 0;
					loc_id = 0;
				}
				product_account_codes = get_product_account(prod_id:evaluate("attributes.product_id#i#"),period_id:session.ep.period_id,product_account_db:dsn2,product_alias_db:dsn3_alias,department_id:dept_id,location_id:loc_id);

				if(is_scrap_in eq 1)
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.SCRAP_CODE, ",");
				else if(location_type_in eq 1) //giris depo hammadde depo ise
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.MATERIAL_CODE, ",");
				else if(location_type_in eq 3) //giris depo mamul depo ise
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.PRODUCTION_COST, ",");
				else //giris mal depo ise
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.ACCOUNT_CODE_PUR, ",");
			}
		if( isdefined('location_type_out'))	 //depo sevk icin location_type_out tanımlı geliyor
			{
				if(is_dept_based_acc eq 1)
				{
					dept_id = attributes.department_id;
					loc_id = attributes.location_id;
				}
				else
				{
					dept_id = 0;
					loc_id = 0;
				}
				product_account_codes = get_product_account(prod_id:evaluate("attributes.product_id#i#"),period_id:session.ep.period_id,product_account_db:dsn2,product_alias_db:dsn3_alias,department_id:dept_id,location_id:loc_id);
				if(is_scrap_out eq 1)
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.SCRAP_CODE, ",");
				else if(location_type_out eq 1) //cikis depo hammadde depo ise
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.MATERIAL_CODE, ",");		
				else if(location_type_out eq 3) //cikis depo mamul depo ise
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.PRODUCTION_COST, ",");		
				else //cikis mal depo ise
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.ACCOUNT_CODE_PUR, ",");		
			}
		else //ithal mal girisi icin
			{	
				if(get_process_type.is_project_based_acc eq 1 and isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))// proje bazlı muhasebe islemi yapılacaksa ve satırda proje seçili ise
				{//proje bazlı muhasebe yapılıyorsa ve satırda proje varsa
					project_acc_codes=cfquery(datasource:"#dsn2#",sqlstring:"SELECT ACCOUNT_YURTDISI_PUR FROM #dsn3_alias#.PROJECT_PERIOD WHERE PROJECT_ID = #evaluate("attributes.row_project_id#i#")# AND PERIOD_ID = #session.ep.period_id# ");
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, project_acc_codes.ACCOUNT_YURTDISI_PUR, ",");
				}
				else if(get_process_type.is_project_based_acc eq 1 and isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head))	// proje bazlı muhasebe islemi yapılacaksa
				{
					project_acc_codes=cfquery(datasource:"#dsn2#",sqlstring:"SELECT	ACCOUNT_YURTDISI_PUR FROM #dsn3_alias#.PROJECT_PERIOD WHERE PROJECT_ID = #attributes.project_id# AND PERIOD_ID = #session.ep.period_id# ");
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, project_acc_codes.ACCOUNT_YURTDISI_PUR, ",");
				}
				else
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.ACCOUNT_YURTDISI_PUR, ",");
			}
		if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
			acc_project_list_borc = ListAppend(acc_project_list_borc,evaluate("attributes.row_project_id#i#"),",");
		else if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
			acc_project_list_borc = ListAppend(acc_project_list_borc,attributes.project_id,",");
		else
			acc_project_list_borc = ListAppend(acc_project_list_borc,0,",");
			
		if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
			acc_project_list_alacak = ListAppend(acc_project_list_alacak,evaluate("attributes.row_project_id#i#"),",");
		else if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
			acc_project_list_alacak = ListAppend(acc_project_list_alacak,attributes.project_id,",");
		else
			acc_project_list_alacak = ListAppend(acc_project_list_alacak,0,",");
		borc_alacak_tutar = ListAppend(borc_alacak_tutar, (evaluate("attributes.row_nettotal#i#")), ","); 
		str_miktar[listlen(borc_alacak_tutar)] = '#evaluate("attributes.amount#i#")#';//satırdaki urun miktarı
		str_tutar[listlen(borc_alacak_tutar)] = '#evaluate("attributes.price#i#")#';//satırdaki urun fiyatı
		if(get_process_type.is_account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
		{
			satir_detay_list[1][listlen(borc_alacak_tutar)]='#evaluate("attributes.product_name#i#")#';
			satir_detay_list[2][listlen(borc_alacak_tutar)]='#evaluate("attributes.product_name#i#")#';
		}
		else
		{
			satir_detay_list[1][listlen(borc_alacak_tutar)]=genel_fis_satir_detay;
			satir_detay_list[2][listlen(borc_alacak_tutar)]=genel_fis_satir_detay;
		}
		if( isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#")) ){
			str_dovizli_tutarlar = ListAppend(str_dovizli_tutarlar,(evaluate("attributes.other_money_value_#i#")),",");
			str_doviz_currency = ListAppend(str_doviz_currency,evaluate("attributes.other_money_#i#"),",");
			}
		else{
			str_dovizli_tutarlar = ListAppend(str_dovizli_tutarlar,wrk_round(evaluate("attributes.row_nettotal#i#")*form.basket_rate1/form.basket_rate2),",");
			str_doviz_currency = ListAppend(str_doviz_currency,form.basket_money,",");
			}
	}
</cfscript>
