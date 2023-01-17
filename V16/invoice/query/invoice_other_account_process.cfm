<cfscript>
	if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)) main_project_id = attributes.project_id; else main_project_id = 0;
	if(len(attributes.company_id)) comp_name_ = attributes.company; else comp_name_ = attributes.partner_name;
	if(isDefined("note") and Len(note)) note_ = "- #note#"; else note_ = "";
	if(is_account_group neq 1)
		genel_fis_satir_detay = "#form.invoice_number#-#comp_name_# FATURA";
	else
		genel_fis_satir_detay = "#form.invoice_number#-#comp_name_# FATURA#note_#"; // & iif(isDefined("note") and Len(note),de("-#note#"),de(""));
	satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar. satir_detay_list[1]'a  borc yazan satırların acıklamaları, satir_detay_list[2]'a alacak yazan satırların acıklamaları set edilir. 
	str_borclu_hesaplar = '' ;
	str_borclu_tutarlar = '' ;
	str_dovizli_borclar = '' ;
	str_other_currency_borc = '';
	str_alacakli_hesaplar = '' ;
	str_alacakli_tutarlar = '' ;
	str_dovizli_alacaklar = '' ;
	str_other_currency_alacak = '';
	product_account_code ='';
	tevkifat_tax_list='';	
	acc_project_list_alacak='';
	acc_project_list_borc='';
	str_borclu_miktar = ArrayNew(1);
	str_borclu_tutar = ArrayNew(1) ;
	if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and len(attributes.project_id) and len(attributes.project_head))	// proje bazlı muhasebe islemi yapılacaksa
	{
		main_product_account_codes=cfquery(datasource:"#dsn2#",sqlstring:"SELECT ACCOUNT_IADE,ACCOUNT_YURTDISI_PUR,ACCOUNT_CODE_PUR,MATERIAL_CODE,PRODUCTION_COST,ACCOUNT_DISCOUNT_PUR,ACCOUNT_PRICE_PUR FROM #dsn3_alias#.PROJECT_PERIOD WHERE PROJECT_ID = #attributes.project_id# AND PERIOD_ID = #session.ep.period_id# ");
	}

	if((form.basket_gross_total-(form.basket_discount_total-form.genel_indirim)) neq 0)
		genel_indirim_yuzdesi = form.genel_indirim / (form.basket_gross_total-(form.basket_discount_total-form.genel_indirim));
	else
		genel_indirim_yuzdesi = 0;
	for(i=1;i lte attributes.rows_;i=i+1)
	{
		urun_toplam_indirim = evaluate("attributes.row_total#i#")-evaluate("attributes.row_nettotal#i#");
		if(form.genel_indirim gt 0) //genel indirim 0 dan farkli ise indirim duzeltmesi
			urun_toplam_indirim = urun_toplam_indirim + (evaluate("attributes.row_nettotal#i#") * genel_indirim_yuzdesi);
		//urun_toplam_indirim = urun_toplam_indirim;
		
		if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and isdefined("row_project_id#i#") and len(evaluate("row_project_id#i#")) and len(evaluate("row_project_name#i#")))// proje bazlı muhasebe islemi yapılacaksa ve satırda proje seçili ise
		{//proje bazlı muhasebe yapılıyorsa ve satırda proje varsa
			product_account_codes=cfquery(datasource:"#dsn2#",sqlstring:"SELECT	ACCOUNT_IADE,ACCOUNT_YURTDISI_PUR,ACCOUNT_CODE_PUR,MATERIAL_CODE,PRODUCTION_COST,ACCOUNT_DISCOUNT_PUR,ACCOUNT_PRICE_PUR FROM #dsn3_alias#.PROJECT_PERIOD WHERE PROJECT_ID = #evaluate("row_project_id#i#")# AND PERIOD_ID = #session.ep.period_id# ");
		}
		else if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and len(attributes.project_id) and len(attributes.project_head))	// proje bazlı muhasebe islemi yapılacaksa
		{//proje bazlı muhasebe yapılıyorsa ve belgede proje varsa
			product_account_codes=main_product_account_codes;
		}
		else//proje yoksa üründen alır
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
		}
		
		if(isdefined("attributes.is_return") and attributes.is_return eq 1)
			product_account_code = product_account_codes.ACCOUNT_IADE;
		else if(evaluate("attributes.is_inventory#i#") eq 0)
			product_account_code = product_account_codes.ACCOUNT_CODE_PUR ;				
		else if(location_type eq 1)//hammadde lokasyonu secilmisse
			product_account_code = product_account_codes.MATERIAL_CODE;
		else if(location_type eq 3)//mamul lokasyonu secilmisse
			product_account_code = product_account_codes.PRODUCTION_COST;
		else if(location_type eq 2)//mal lokasyonu secilmisse
			product_account_code = product_account_codes.ACCOUNT_CODE_PUR;
		str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_code, ",");
		if(is_discount eq 1) /*20050606 eger fatura alis indirimlerini mushasebe fisinde gostermeyecekse bu tutarlar satir toplamindan dusulur */
		{
			str_borclu_tutarlar = ListAppend(str_borclu_tutarlar, (evaluate("attributes.row_total#i#")-urun_toplam_indirim), ",");
			//fatura altı indirim yoksa, row_totaldan indirimlerin cıkarılmıs degeri ile other_money_value aynıdır.
			if(genel_indirim_yuzdesi eq 0 and isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#")) ){
				str_dovizli_borclar = ListAppend(str_dovizli_borclar,evaluate("attributes.other_money_value_#i#"),",");
				str_other_currency_borc = ListAppend(str_other_currency_borc,evaluate("attributes.other_money_#i#"),",");
			}
			else
			{
				str_dovizli_borclar = ListAppend(str_dovizli_borclar,((evaluate("attributes.row_total#i#")-urun_toplam_indirim)*attributes.basket_rate1/attributes.basket_rate2),",");
				str_other_currency_borc = ListAppend(str_other_currency_borc,attributes.basket_money,",");
			}
		}	
		else
		{
			str_borclu_tutarlar = ListAppend(str_borclu_tutarlar, evaluate("attributes.row_total#i#"), ",");
			//other_money_value_ urun indirimlerinin dusulmus degerini tasır ve sadece indirimler 0 oladugunda veya muhasebe fisinde gosterilmeyecekse other_money_value_ ile row_total degerleri esit olur.
			if(urun_toplam_indirim eq 0 and isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#")) )
			{
				str_dovizli_borclar = ListAppend(str_dovizli_borclar,evaluate("attributes.other_money_value_#i#"),",");
				str_other_currency_borc = ListAppend(str_other_currency_borc,evaluate("attributes.other_money_#i#"),",");
			}
			else
			{
				str_dovizli_borclar = ListAppend(str_dovizli_borclar,(evaluate("attributes.row_total#i#")*attributes.basket_rate1/attributes.basket_rate2),",");
				str_other_currency_borc = ListAppend(str_other_currency_borc,attributes.basket_money,",");
			}
		}
		str_borclu_miktar[listlen(str_borclu_tutarlar)] = '#evaluate("attributes.amount#i#")#';
		str_borclu_tutar[listlen(str_borclu_tutarlar)] = '#evaluate("attributes.price#i#")#'; 
		if(is_account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
			satir_detay_list[1][listlen(str_borclu_tutarlar)]='#comp_name_# - #evaluate("attributes.product_name#i#")#'; //satır acıklamaları borc acıklama aray e set edilir.
		else
			satir_detay_list[1][listlen(str_borclu_tutarlar)]= genel_fis_satir_detay;
		if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
			acc_project_list_borc = ListAppend(acc_project_list_borc,evaluate("attributes.row_project_id#i#"),",");
		else
			acc_project_list_borc = ListAppend(acc_project_list_borc,main_project_id,",");
		if(is_discount neq 1) 
		{
			if(urun_toplam_indirim gt 0 and len(product_account_codes.ACCOUNT_DISCOUNT_PUR))
				{ //urune ait alis indirim hesabina
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.ACCOUNT_DISCOUNT_PUR, ",");
					str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar, urun_toplam_indirim, ",");
					str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar, (urun_toplam_indirim*attributes.basket_rate1/attributes.basket_rate2), ",");
					str_other_currency_alacak = ListAppend(str_other_currency_alacak,attributes.basket_money,",");
					satir_detay_list[2][listlen(str_alacakli_tutarlar)]=genel_fis_satir_detay; //indirim acıklamaları icin fis satırlarına fatura genel bilgileri set edilir.
					if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
						acc_project_list_alacak = ListAppend(acc_project_list_alacak,evaluate("attributes.row_project_id#i#"),",");
					else
						acc_project_list_alacak = ListAppend(acc_project_list_alacak,main_project_id,",");
				}
			else if(urun_toplam_indirim gt 0 and (not len(product_account_codes.ACCOUNT_DISCOUNT_PUR)))
				{ //urune ait indirim hesabi yoksa genel indirim hesabina
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, GET_NO_.A_DISC, ",");
					str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar, urun_toplam_indirim, ",");
					str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar, (urun_toplam_indirim*attributes.basket_rate1/attributes.basket_rate2), ",");
					str_other_currency_alacak = ListAppend(str_other_currency_alacak,attributes.basket_money,",");
					satir_detay_list[2][listlen(str_alacakli_tutarlar)]=genel_fis_satir_detay; //indirim acıklamaları icin fis satırlarına fatura genel bilgileri set edilir.
					if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
						acc_project_list_alacak = ListAppend(acc_project_list_alacak,evaluate("attributes.row_project_id#i#"),",");
					else
						acc_project_list_alacak = ListAppend(acc_project_list_alacak,main_project_id,",");
				}
		}
		//otv bloğu
		if(evaluate("form.row_otvtotal#i#") neq 0)
		{
			get_otv_row=cfquery(datasource:"#dsn2#",sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_OTV WHERE TAX = #evaluate("form.otv_oran#i#")#  AND PERIOD_ID = #session.ep.period_id#");
			temp_otv_tutar = evaluate("form.row_otvtotal#i#");
			if(genel_indirim_yuzdesi gt 0) //fatura altı indirim varsa, indirim kdv toplamlara da yansıtılır
				temp_otv_tutar =  wrk_round((temp_otv_tutar-(temp_otv_tutar*genel_indirim_yuzdesi)),attributes.basket_price_round_number);
			if(Listfind('54,55',invoice_cat))
				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, get_otv_row.account_code_iade, ",");
			else
				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, get_otv_row.purchase_code, ",");	
			
			str_borclu_tutarlar = ListAppend(str_borclu_tutarlar, temp_otv_tutar, ",");
			str_dovizli_borclar = ListAppend(str_dovizli_borclar, (temp_otv_tutar*attributes.basket_rate1/attributes.basket_rate2), ",");
			str_other_currency_borc = ListAppend(str_other_currency_borc,attributes.basket_money,",");
			str_borclu_tutar[listlen(str_borclu_tutarlar)] = '#evaluate("attributes.price#i#")#'; 
			str_borclu_miktar[listlen(str_borclu_tutarlar)] = '#evaluate("attributes.amount#i#")#';
			if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
				acc_project_list_borc = ListAppend(acc_project_list_borc,evaluate("attributes.row_project_id#i#"),",");
			else
				acc_project_list_borc = ListAppend(acc_project_list_borc,main_project_id,",");
			if(is_account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
				satir_detay_list[1][listlen(str_borclu_tutarlar)]='#comp_name_# - #evaluate("attributes.product_name#i#")#';
			else
				satir_detay_list[1][listlen(str_borclu_tutarlar)] = genel_fis_satir_detay;
		}
		// kdv bloğu
		if(evaluate("form.row_taxtotal#i#") gt 0)
		{
			temp_tax_tutar = evaluate("form.row_taxtotal#i#");
			temp_tax_tutar2 = evaluate("form.row_taxtotal#i#");
			if( isdefined("form.tevkifat_box") and isdefined('form.tevkifat_oran') and len(form.tevkifat_oran))
			{ /*herbir kdv ye uygulanacak tevkşfat icin muhasebe hesapları cekiliyor*/
				tevkifat_acc_codes=cfquery(datasource:"#dsn2#",sqlstring:"SELECT 
											ST_ROW.TEVKIFAT_BEYAN_CODE_PUR,ST_ROW.TEVKIFAT_CODE_PUR,ST_ROW.TAX
										FROM 
											#dsn3_alias#.SETUP_TEVKIFAT S_TEV,#dsn3_alias#.SETUP_TEVKIFAT_ROW ST_ROW 
										WHERE
											S_TEV.TEVKIFAT_ID = ST_ROW.TEVKIFAT_ID
											AND S_TEV.TEVKIFAT_ID = #form.tevkifat_id#
											AND ST_ROW.TAX = #evaluate("form.tax#i#")#
										ORDER BY ST_ROW.TAX");
				temp_tax_tutar2 = wrk_round((temp_tax_tutar*form.tevkifat_oran),attributes.basket_price_round_number);
			}
			get_tax_row=cfquery(datasource:"#dsn2#",sqlstring:"SELECT * FROM SETUP_TAX WHERE TAX = #evaluate("form.tax#i#")#");
			if(genel_indirim_yuzdesi gt 0) //fatura altı indirim varsa, indirim kdv toplamlara da yansıtılır
				temp_tax_tutar =  wrk_round((temp_tax_tutar-(temp_tax_tutar*genel_indirim_yuzdesi)),attributes.basket_price_round_number);
			if( isdefined("form.tevkifat_box") and isdefined('form.tevkifat_oran') and len(form.tevkifat_oran))
			{
				temp_tax_tutar2 = wrk_round(evaluate("form.row_taxtotal#i#")-temp_tax_tutar2,attributes.basket_price_round_number);
				str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,tevkifat_acc_codes.tevkifat_beyan_code_pur, ",");		
				str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar, temp_tax_tutar2,",");
				str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,(temp_tax_tutar2*attributes.basket_rate1/attributes.basket_rate2),",");
				str_other_currency_alacak = ListAppend(str_other_currency_alacak,attributes.basket_money,",");
				if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
					acc_project_list_alacak = ListAppend(acc_project_list_alacak,evaluate("attributes.row_project_id#i#"),",");
				else
					acc_project_list_alacak = ListAppend(acc_project_list_alacak,main_project_id,",");
				if(is_account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
					satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#comp_name_# - #evaluate("attributes.product_name#i#")#';
				else
					satir_detay_list[2][listlen(str_alacakli_tutarlar)] = genel_fis_satir_detay;
				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,tevkifat_acc_codes.tevkifat_code_pur, ",");
			}
			else
			{
				if( is_expensing_tax eq 1 ){
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, get_tax_row.direct_expense_code, ",");
				}else{
					if(Listfind('54,55',invoice_cat))
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, get_tax_row.sale_code_iade, ",");
					else if(invoice_cat eq 63) //alınan fiyat farkı
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, get_tax_row.purchase_price_diff_code, ",");
					else if(isDefined('attributes.is_return') and attributes.is_return eq 1)
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, get_tax_row.sale_code_iade, ",");
					else
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, get_tax_row.purchase_code, ",");
				}
			}
			str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,temp_tax_tutar, ",");
			str_dovizli_borclar = ListAppend(str_dovizli_borclar, (temp_tax_tutar*(form.basket_rate1/form.basket_rate2)), ",");
			str_other_currency_borc= ListAppend(str_other_currency_borc,form.basket_money,",");
			if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
				acc_project_list_borc = ListAppend(acc_project_list_borc,evaluate("attributes.row_project_id#i#"),",");
			else
				acc_project_list_borc = ListAppend(acc_project_list_borc,main_project_id,",");
			str_borclu_tutar[listlen(str_borclu_tutarlar)] = '#evaluate("attributes.price#i#")#'; 
			str_borclu_miktar[listlen(str_borclu_tutarlar)] = '#evaluate("attributes.amount#i#")#';
			if(is_account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
				satir_detay_list[1][listlen(str_borclu_tutarlar)]='#comp_name_# - #evaluate("attributes.product_name#i#")#';
			else
				satir_detay_list[1][listlen(str_borclu_tutarlar)] = genel_fis_satir_detay;
		}
	}
	str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, acc, ",");
	str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar, (attributes.basket_net_total-form.stopaj), ",");//kdv dahil stopaj haric tutar
	str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,((attributes.basket_net_total-form.stopaj)*attributes.basket_rate1/attributes.basket_rate2),",");
	str_other_currency_alacak = ListAppend(str_other_currency_alacak,form.basket_money,",");
	satir_detay_list[2][listlen(str_alacakli_tutarlar)]=genel_fis_satir_detay;
	if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
		acc_project_list_alacak = ListAppend(acc_project_list_alacak,attributes.project_id,",");
	else
		acc_project_list_alacak = ListAppend(acc_project_list_alacak,0,",");
	// stopaj
	str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, GET_SETUP_STOPPAGE_RATES.STOPPAGE_ACCOUNT_CODE, ",");
	str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar, form.stopaj, ",");
	str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,(form.stopaj*attributes.basket_rate1/attributes.basket_rate2),",");
	str_other_currency_alacak = ListAppend(str_other_currency_alacak,form.basket_money,",");
	satir_detay_list[2][listlen(str_alacakli_tutarlar)]=genel_fis_satir_detay;
	if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
		acc_project_list_alacak = ListAppend(acc_project_list_alacak,attributes.project_id,",");
	else
		acc_project_list_alacak = ListAppend(acc_project_list_alacak,0,",");
	
	//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
	str_fark_gelir =GET_NO_.FARK_GELIR;
	str_fark_gider =GET_NO_.FARK_GIDER;
	str_max_round = 0.5;
	str_round_detail = genel_fis_satir_detay;
</cfscript>
