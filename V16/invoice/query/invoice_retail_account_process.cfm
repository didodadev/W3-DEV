<cfinclude template = "../../objects/query/session_base.cfm">
<cfscript>
	if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)) main_project_id = attributes.project_id; else main_project_id = 0;
	DETAIL_1 = attributes.comp_name & ' ' & DETAIL_ & ' GİRİŞ İŞLEMİ';
	if(len(attributes.company_id)) comp_name_ = attributes.comp_name; else comp_name_ = "#attributes.member_name# #attributes.member_surname#";
	if(isDefined("note") and Len(note)) note_ = "- #note#"; else note_ = "";
	if(is_account_group neq 1)
		genel_fis_satir_detay = "#form.invoice_number#-#comp_name_# FATURA";
	else
		genel_fis_satir_detay = "#form.invoice_number#-#comp_name_# FATURA#note_#"; // & iif(isDefined("note") and Len(note),de("-#note#"),de(""));
	satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar. satir_detay_list[1]'a  borc yazan satırların acıklamaları, satir_detay_list[2]'a alacak yazan satırların acıklamaları set edilir. 
	str_borclu_hesaplar = '' ;
	str_borclu_tutarlar = '' ;
	str_dovizli_borclar = '' ;
	str_alacakli_hesaplar = '' ;
	str_alacakli_tutarlar = '' ;
	str_dovizli_alacaklar = '' ;
	str_other_currency_alacak = '';
	str_other_currency_borc = '';
	acc_project_list_alacak='';
	acc_project_list_borc='';
	str_alacak_miktar = ArrayNew(1);
	str_alacak_tutar = ArrayNew(1) ;
	product_account_code ='';	
	new_karma_prod_id_list_='';
	
	if(isdefined('is_prod_cost_acc_action') and is_prod_cost_acc_action eq 1 and invoice_cat eq 52)//satılan malın maliyeti muhasebelestirilecekse alış iade değilse
	{
		str_karma_prods="SELECT KARMA_PRODUCT_ID,KP.PRODUCT_ID,PRODUCT_AMOUNT,P.PRODUCT_NAME FROM #dsn1_alias#.KARMA_PRODUCTS KP,#dsn3_alias#.PRODUCT P WHERE P.PRODUCT_ID=KP.PRODUCT_ID AND P.IS_INVENTORY=1 AND KP.KARMA_PRODUCT_ID IN (#product_id_list#) ORDER BY KP.KARMA_PRODUCT_ID";		
		get_karma_prods_=cfquery(datasource:"#dsn2#",sqlstring:str_karma_prods);
		new_karma_prod_content_list_=valuelist(get_karma_prods_.PRODUCT_ID);
		new_karma_prod_id_list_=valuelist(get_karma_prods_.KARMA_PRODUCT_ID);
		check_prod_cost_list=product_id_list;
		if(len(new_karma_prod_content_list_))
			check_prod_cost_list=listappend(check_prod_cost_list,new_karma_prod_content_list_); //fatura satırlarındaki urunlere, karma koli urun icerikleri ekleniyor, böylece bütün ürünlerin maliyetleri birden çekilecek
		
		prod_cost_str="SELECT PRODUCT_ID,(PURCHASE_NET+PURCHASE_EXTRA_COST) AS PRODUCT_COST_AMOUNT, PURCHASE_NET_MONEY,(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM) AS PRODUCT_COST_SYSTEM_AMOUNT ,PURCHASE_NET_SYSTEM_MONEY ";
		prod_cost_str=prod_cost_str&" FROM #dsn3_alias#.PRODUCT_COST WHERE PRODUCT_ID IN (#karma_product_list#) AND START_DATE <= #attributes.invoice_date# AND PRODUCT_COST_ID=";   
		prod_cost_str=prod_cost_str&" (SELECT TOP 1 PC.PRODUCT_COST_ID FROM #dsn3_alias#.PRODUCT_COST PC WHERE PC.PRODUCT_ID =PRODUCT_COST.PRODUCT_ID AND START_DATE <= #attributes.invoice_date# ORDER BY PRODUCT_ID,RECORD_DATE DESC, START_DATE DESC,PRODUCT_COST_ID DESC)";
		prod_cost_str=prod_cost_str&" ORDER BY PRODUCT_ID,RECORD_DATE DESC, START_DATE DESC,PRODUCT_COST_ID DESC";	
		get_prod_cost_amounts=cfquery(datasource:"#dsn2#",sqlstring:prod_cost_str);
		product_cost_list_new=listdeleteduplicates(listsort(valuelist(get_prod_cost_amounts.PRODUCT_ID),'numeric','asc'));
	}
	if((form.basket_gross_total-(form.basket_discount_total-form.genel_indirim)) neq 0)
		genel_indirim_yuzdesi = form.genel_indirim / (form.basket_gross_total-(form.basket_discount_total-form.genel_indirim));
	else
		genel_indirim_yuzdesi = 0;
	if(is_project_based_acc eq 1 and session_base.our_company_info.project_followup eq 1 and len(attributes.project_id) and len(attributes.project_head))	// proje bazlı muhasebe islemi yapılacaksa
	{
		// proje bazlı muhasebe yapılıyorsa bir kez proje muhasebe kodları cekilir ve satırlar döndürülerek bu kodlara gerekli degerler atılır.
		main_product_account_codes=cfquery(datasource:"#dsn2#",sqlstring:"SELECT ACCOUNT_DISCOUNT_PUR,ACCOUNT_CODE,ACCOUNT_PRICE,ACCOUNT_PRICE_PUR,SALE_PRODUCT_COST,ACCOUNT_DISCOUNT,ACCOUNT_YURTDISI,ACCOUNT_PUR_IADE,ACCOUNT_IADE,ACCOUNT_CODE_PUR,RECEIVED_PROGRESS_CODE,PROVIDED_PROGRESS_CODE,KONSINYE_SALE_CODE,SCRAP_CODE_SALE,MATERIAL_CODE_SALE,PRODUCTION_COST_SALE FROM #dsn3_alias#.PROJECT_PERIOD WHERE PROJECT_ID = #attributes.project_id# AND PERIOD_ID = #session_base.period_id# ");
	}
	for(i=1;i lte attributes.rows_;i=i+1)
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
		if(is_project_based_acc eq 1 and session_base.our_company_info.project_followup eq 1 and isdefined("row_project_id#i#") and len(evaluate("row_project_id#i#")) and len(evaluate("row_project_name#i#")))// proje bazlı muhasebe islemi yapılacaksa ve satırda proje seçili ise
		{//proje bazlı muhasebe yapılıyorsa ve satırda proje varsa
			product_account_codes=cfquery(datasource:"#dsn2#",sqlstring:"SELECT ACCOUNT_DISCOUNT_PUR,ACCOUNT_CODE,ACCOUNT_PRICE,ACCOUNT_PRICE_PUR,SALE_PRODUCT_COST,ACCOUNT_DISCOUNT,ACCOUNT_YURTDISI,ACCOUNT_PUR_IADE,ACCOUNT_IADE,ACCOUNT_CODE_PUR,RECEIVED_PROGRESS_CODE,PROVIDED_PROGRESS_CODE,KONSINYE_SALE_CODE,SCRAP_CODE_SALE,MATERIAL_CODE_SALE,PRODUCTION_COST_SALE FROM #dsn3_alias#.PROJECT_PERIOD WHERE PROJECT_ID = #evaluate("row_project_id#i#")# AND PERIOD_ID = #session_base.period_id# ");
		}
		else if(is_project_based_acc eq 1 and session_base.our_company_info.project_followup eq 1 and len(attributes.project_id) and len(attributes.project_head))	// proje bazlı muhasebe islemi yapılacaksa
		{//proje bazlı muhasebe yapılıyorsa ve belgede proje varsa
			product_account_codes=main_product_account_codes;
		}
		else
			product_account_codes = get_product_account(prod_id:evaluate("attributes.product_id#i#"),period_id:session_base.period_id,product_account_db:dsn2,product_alias_db:dsn3_alias,department_id:dept_id,location_id:loc_id);
		urun_toplam_indirim = (evaluate("attributes.row_total#i#")-evaluate("attributes.row_nettotal#i#"));
		if(form.genel_indirim gt 0) //genel indirim 0 dan farkli ise indirim duzeltmesi
			urun_toplam_indirim = urun_toplam_indirim + (evaluate("attributes.row_nettotal#i#") * genel_indirim_yuzdesi);
		if(invoice_cat is '62') //Alim İade Faturasi ise
			product_account_code = product_account_codes.ACCOUNT_PUR_IADE ;
		else // 52 veya 53 Toptan veya Perakende Satış Faturasi ise
			product_account_code = product_account_codes.ACCOUNT_CODE ;
		str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,product_account_code,",");
		
		
		if(is_discount eq 1)//indirimler muhasebe fisinde gosterilmeyecekse satır toplamından dusurulur
		{
			str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,(evaluate("attributes.row_total#i#")-urun_toplam_indirim),",");
			//other_money_value_ urun indirimlerinin dusulmus degerini tasır ve sadece indirimler 0 oladugunda veya muhasebe fisinde gosterilmeyecekse other_money_value_ ile row_total degerleri esit olur.
			if(genel_indirim_yuzdesi eq 0 and isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#")) )
			{
				str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,evaluate("attributes.other_money_value_#i#"),",");
				str_other_currency_alacak = ListAppend(str_other_currency_alacak,evaluate("attributes.other_money_#i#"),",");
			}
			else
			{
				str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,((evaluate("attributes.row_total#i#")-urun_toplam_indirim)*form.basket_rate1/form.basket_rate2),",");
				str_other_currency_alacak = ListAppend(str_other_currency_alacak,form.basket_money,",");
			}
		}
		else
		{
			str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,evaluate("attributes.row_total#i#"),",");
			//other_money_value_ urun indirimlerinin dusulmus degerini tasır ve sadece indirimler 0 oladugunda veya muhasebe fisinde gosterilmeyecekse other_money_value_ ile row_total degerleri esit olur.
			if(urun_toplam_indirim eq 0 and isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#")) )
			{
				str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,evaluate("attributes.other_money_value_#i#"),",");
				str_other_currency_alacak = ListAppend(str_other_currency_alacak,evaluate("attributes.other_money_#i#"),",");
			}
			else
			{
				str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,(evaluate("attributes.row_total#i#")*form.basket_rate1/form.basket_rate2),",");
				str_other_currency_alacak = ListAppend(str_other_currency_alacak,form.basket_money,",");
			}
		}
		
		str_alacak_miktar[listlen(str_alacakli_tutarlar)] = '#evaluate("attributes.amount#i#")#';
		str_alacak_tutar[listlen(str_alacakli_tutarlar)] = '#evaluate("attributes.price#i#")#'; 
		if(is_account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
			satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#evaluate("attributes.product_name#i#")#';
		else
			satir_detay_list[2][listlen(str_alacakli_tutarlar)]=genel_fis_satir_detay;
		if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
			acc_project_list_alacak = ListAppend(acc_project_list_alacak,evaluate("attributes.row_project_id#i#"),",");
		else
			acc_project_list_alacak = ListAppend(acc_project_list_alacak,main_project_id,",");
		if (is_discount neq 1)
		{
			if(urun_toplam_indirim gt 0)
			{ //urune ait satis indirim hesabina
				if(len(product_account_codes.ACCOUNT_DISCOUNT))
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,product_account_codes.ACCOUNT_DISCOUNT,",");
				else
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,GET_NO_.A_DISC,",");					
				str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,urun_toplam_indirim,",");
				str_dovizli_borclar = ListAppend(str_dovizli_borclar,urun_toplam_indirim,",");
				str_other_currency_borc = ListAppend(str_other_currency_borc,session_base.money,",");
				satir_detay_list[1][listlen(str_borclu_tutarlar)]=genel_fis_satir_detay;
				if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
					acc_project_list_borc = ListAppend(acc_project_list_borc,evaluate("attributes.row_project_id#i#"),",");
				else
					acc_project_list_borc = ListAppend(acc_project_list_borc,main_project_id,",");
			}
		}
		if(isdefined('is_prod_cost_acc_action') and is_prod_cost_acc_action eq 1 and invoice_cat eq 52)
		{
			temp_row_amount=0;
			if(len(new_karma_prod_id_list_) and listfind(new_karma_prod_id_list_,evaluate("attributes.product_id#i#")) neq 0) //satırdaki karma koli urunse, set icerigindeki urunlerin maliyet toplamı karmakoli urune yansıtılacak
			{
				row_prod_id=evaluate("attributes.product_id#i#");
				'temp_row_amount_#row_prod_id#'=0;
				for(kp=1;kp lte get_karma_prods_.recordcount;kp=kp+1)
				{
					if(row_prod_id eq get_karma_prods_.KARMA_PRODUCT_ID[kp])
					{
						if(listfind(product_cost_list_new,get_karma_prods_.PRODUCT_ID[kp]))
						{
							temp_karma_prod_amount=get_karma_prods_.PRODUCT_AMOUNT[kp];
							'temp_row_amount_#row_prod_id#'=evaluate('temp_row_amount_#row_prod_id#')+wrk_round(get_prod_cost_amounts.PRODUCT_COST_SYSTEM_AMOUNT[listfind(product_cost_list_new,get_karma_prods_.PRODUCT_ID[kp])]*get_karma_prods_.PRODUCT_AMOUNT[kp]);
						}
					}
				}
				temp_row_amount=evaluate('temp_row_amount_#row_prod_id#')*evaluate("attributes.amount#i#");
				temp_row_other_amount=wrk_round(temp_row_amount*(form.basket_rate1/form.basket_rate2));
				temp_row_other_currency=form.basket_money;
			}
			else if(listfind(product_cost_list_new,evaluate("attributes.product_id#i#")))
			{
				temp_row_amount=(get_prod_cost_amounts.PRODUCT_COST_SYSTEM_AMOUNT[listfind(product_cost_list_new,evaluate("attributes.product_id#i#"))]*evaluate("attributes.amount#i#"));
				temp_row_other_amount=(get_prod_cost_amounts.PRODUCT_COST_AMOUNT[listfind(product_cost_list_new,evaluate("attributes.product_id#i#"))]*evaluate("attributes.amount#i#"));
				temp_row_other_currency=get_prod_cost_amounts.PURCHASE_NET_MONEY[listfind(product_cost_list_new,evaluate("attributes.product_id#i#"))];
			}
			if(temp_row_amount neq 0)
			{
				str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,product_account_codes.ACCOUNT_CODE_PUR,",");  //alıs hesabı alacaklı
				str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,temp_row_amount,",");
				str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,temp_row_other_amount,",");
				str_other_currency_alacak = ListAppend(str_other_currency_alacak,temp_row_other_currency,",");
				str_alacak_miktar[listlen(str_alacakli_tutarlar)] = '#evaluate("attributes.amount#i#")#';
				str_alacak_tutar[listlen(str_alacakli_tutarlar)] = '#evaluate("attributes.price#i#")#'; 

				if(is_account_group neq 1)
					satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#evaluate("attributes.product_name#i#")#';
				else
					satir_detay_list[2][listlen(str_alacakli_tutarlar)] = genel_fis_satir_detay;
			
				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,product_account_codes.SALE_PRODUCT_COST,",");  //satılan malın maliyeti hesabı borclu
				str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,temp_row_amount,",");
				str_dovizli_borclar = ListAppend(str_dovizli_borclar,temp_row_other_amount,",");
				str_other_currency_borc = ListAppend(str_other_currency_borc,temp_row_other_currency,",");
				if(is_account_group neq 1)
					satir_detay_list[1][listlen(str_borclu_tutarlar)]='#evaluate("attributes.product_name#i#")#';
				else
					satir_detay_list[1][listlen(str_borclu_tutarlar)]=genel_fis_satir_detay;
				if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
				{
					acc_project_list_borc = ListAppend(acc_project_list_borc,evaluate("attributes.row_project_id#i#"),",");
					acc_project_list_alacak = ListAppend(acc_project_list_alacak,evaluate("attributes.row_project_id#i#"),",");
				}
				else
				{
					acc_project_list_borc = ListAppend(acc_project_list_borc,main_project_id,",");
					acc_project_list_alacak = ListAppend(acc_project_list_alacak,main_project_id,",");
				}
			}
		}
		// kdv bloğu
		if(evaluate("form.row_taxtotal#i#") gt 0)
		{
			temp_tax_tutar = evaluate("form.row_taxtotal#i#");
			if( isdefined("form.tevkifat_box") and isdefined('form.tevkifat_oran') and len(form.tevkifat_oran))
			{ /*herbir kdv ye uygulanacak tevkşfat icin muhasebe hesapları cekiliyor*/
				tevkifat_acc_codes=cfquery(datasource:"#dsn2#",sqlstring:"SELECT 
											ST_ROW.TEVKIFAT_BEYAN_CODE,ST_ROW.TAX
										FROM 
											#dsn3_alias#.SETUP_TEVKIFAT S_TEV,#dsn3_alias#.SETUP_TEVKIFAT_ROW ST_ROW 
										WHERE
											S_TEV.TEVKIFAT_ID = ST_ROW.TEVKIFAT_ID
											AND S_TEV.TEVKIFAT_ID = #form.tevkifat_id#
											AND ST_ROW.TAX = #evaluate("form.tax#i#")#
										ORDER BY ST_ROW.TAX");
				temp_tax_tutar = wrk_round((temp_tax_tutar*form.tevkifat_oran),attributes.basket_price_round_number);
			}
			get_tax_row=cfquery(datasource:"#dsn2#",sqlstring:"SELECT * FROM SETUP_TAX WHERE TAX = #evaluate("form.tax#i#")#");
			if(genel_indirim_yuzdesi gt 0) //fatura altı indirim varsa, indirim kdv toplamlara da yansıtılır
				temp_tax_tutar =  wrk_round((temp_tax_tutar-(temp_tax_tutar*genel_indirim_yuzdesi)),attributes.basket_price_round_number);
			if( isdefined("form.tevkifat_box") and isdefined('form.tevkifat_oran') and len(form.tevkifat_oran))
				str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,tevkifat_acc_codes.tevkifat_beyan_code, ",");
			else
			{
				if(invoice_cat eq 62) //iade faturası
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, get_tax_row.purchase_code_iade, ",");
				else if(invoice_cat eq 58) //verilen fiyat farkı
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, get_tax_row.sale_price_diff_code, ",");
				else
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, get_tax_row.sale_code, ",");
			}
			str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,temp_tax_tutar, ",");
			str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar, (temp_tax_tutar*(form.basket_rate1/form.basket_rate2)), ",");
			str_other_currency_alacak = ListAppend(str_other_currency_alacak,form.basket_money,",");
			if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
				acc_project_list_alacak = ListAppend(acc_project_list_alacak,evaluate("attributes.row_project_id#i#"),",");
			else
				acc_project_list_alacak = ListAppend(acc_project_list_alacak,main_project_id,",");
			str_alacak_tutar[listlen(str_alacakli_tutarlar)] = '#evaluate("attributes.price#i#")#'; 
			str_alacak_miktar[listlen(str_alacakli_tutarlar)] = '#evaluate("attributes.amount#i#")#';
			if(is_account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
				satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#comp_name_# - #evaluate("attributes.product_name#i#")#';
			else
				satir_detay_list[2][listlen(str_alacakli_tutarlar)] = genel_fis_satir_detay;
		}
	}
	str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,ACC,",");
	str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,form.basket_net_total,",");
	str_dovizli_borclar = ListAppend(str_dovizli_borclar,(form.basket_net_total*form.basket_rate1/form.basket_rate2),",");
	str_other_currency_borc = ListAppend(str_other_currency_borc,form.basket_money,",");
	satir_detay_list[1][listlen(str_borclu_tutarlar)]=genel_fis_satir_detay;
	if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
		acc_project_list_borc = ListAppend(acc_project_list_borc,attributes.project_id,",");
	else
		acc_project_list_borc = ListAppend(acc_project_list_borc,0,",");
	//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
	str_fark_gelir =GET_NO_.FARK_GELIR;
	str_fark_gider =GET_NO_.FARK_GIDER;
	str_max_round = 0.5;
	str_round_detail = genel_fis_satir_detay;	
</cfscript>
