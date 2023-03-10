<cfscript>   
	if(not isdefined("new_period_id")) new_period_id = session.ep.period_id;
	DETAIL_1 = attributes.comp_name & ' ' & UCase(DETAIL_ & "#getLang('main',2618)#");
	if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)) main_project_id = attributes.project_id; else main_project_id = 0;
	if(len(attributes.company_id)) comp_name_ = attributes.comp_name; else comp_name_ = attributes.partner_name;
	if(isDefined("note") and Len(note)) note_ = "- #note#"; else note_ = "";
	if(is_account_group neq 1)
		genel_fis_satir_detay = "#form.invoice_number#-#comp_name_#" & UCase("#getLang('main',29)#");
	else
		genel_fis_satir_detay = "#form.invoice_number#-#comp_name_#" & UCase("#getLang('main',29)#") & "#note_#"; //& iif(isDefined("note") and Len(note),de("-#note#"),de(""));
	satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar. satir_detay_list[1]'a  borc yazan satırların acıklamaları, satir_detay_list[2]'a alacak yazan satırların acıklamaları set edilir. 
	str_borclu_hesaplar = '' ;
	str_borclu_tutarlar = '' ;
	str_dovizli_borclar = '' ;
	str_other_currency_borc = '';
	str_alacakli_hesaplar = '' ;
	str_alacakli_tutarlar = '' ;
	str_dovizli_alacaklar = '' ;
	str_other_currency_alacak = '';	
	product_account_code = '';
	tevkifat_tax_list ='';
	acc_project_list_alacak='';
	acc_project_list_borc='';
	str_borclu_miktar = ArrayNew(1);
	str_borclu_tutar = ArrayNew(1) ;
	new_karma_prod_id_list_='';
	is_project_acc=0;
	if(isdefined('is_prod_cost_acc_action') and is_prod_cost_acc_action eq 1 and listfind("54,55",invoice_cat))//satılan malın maliyeti muhasebelestirilecekse satış iade faturası ise
	{
		str_karma_prods="SELECT KARMA_PRODUCT_ID,KP.PRODUCT_ID,PRODUCT_AMOUNT,P.PRODUCT_NAME FROM #dsn1_alias#.KARMA_PRODUCTS KP,#new_dsn3_group#.PRODUCT P WHERE P.PRODUCT_ID=KP.PRODUCT_ID AND P.IS_INVENTORY=1 AND KP.KARMA_PRODUCT_ID IN (#product_id_list#) ORDER BY KP.KARMA_PRODUCT_ID";		
		get_karma_prods_=cfquery(datasource:"#new_dsn2_group#",sqlstring:str_karma_prods);
		new_karma_prod_content_list_=valuelist(get_karma_prods_.PRODUCT_ID);
		new_karma_prod_id_list_=valuelist(get_karma_prods_.KARMA_PRODUCT_ID);
		check_prod_cost_list=product_id_list;
		if(len(new_karma_prod_content_list_))
			check_prod_cost_list=listappend(check_prod_cost_list,new_karma_prod_content_list_); //fatura satırlarındaki urunlere, karma koli urun icerikleri ekleniyor, böylece bütün ürünlerin maliyetleri birden çekilecek
		
		prod_cost_str="SELECT PRODUCT_ID,(PURCHASE_NET+PURCHASE_EXTRA_COST) AS PRODUCT_COST_AMOUNT, PURCHASE_NET_MONEY,(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM) AS PRODUCT_COST_SYSTEM_AMOUNT ,PURCHASE_NET_SYSTEM_MONEY ";
		prod_cost_str=prod_cost_str&" FROM #new_dsn3_group#.PRODUCT_COST WHERE PRODUCT_ID IN (#check_prod_cost_list#) AND START_DATE <= #attributes.invoice_date# AND PRODUCT_COST_ID=";   
		prod_cost_str=prod_cost_str&" (SELECT TOP 1 PC.PRODUCT_COST_ID FROM #new_dsn3_group#.PRODUCT_COST PC WHERE PC.PRODUCT_ID =PRODUCT_COST.PRODUCT_ID AND START_DATE <= #attributes.invoice_date# ORDER BY START_DATE DESC,PRODUCT_ID,RECORD_DATE DESC, PRODUCT_COST_ID DESC)";
		prod_cost_str=prod_cost_str&" ORDER BY PRODUCT_ID";	
		get_prod_cost_amounts=cfquery(datasource:"#new_dsn2_group#",sqlstring:prod_cost_str);
		product_cost_list_new=listdeleteduplicates(listsort(valuelist(get_prod_cost_amounts.PRODUCT_ID),'numeric','asc'));
	}
	if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and len(attributes.project_id) and len(attributes.project_head))	// proje bazlı muhasebe islemi yapılacaksa
	{
		// proje bazlı muhasebe yapılıyorsa bir kez proje muhasebe kodları cekilir ve satırlar döndürülerek bu kodlara gerekli degerler atılır.
		main_product_account_codes=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT ACCOUNT_PRICE_PUR,ACCOUNT_PRICE ACCOUNT_PRICE,ACCOUNT_IADE,SALE_PRODUCT_COST,ACCOUNT_YURTDISI_PUR,ACCOUNT_CODE_PUR,MATERIAL_CODE,PRODUCTION_COST,ACCOUNT_DISCOUNT_PUR,RECEIVED_PROGRESS_CODE,PROVIDED_PROGRESS_CODE FROM #new_dsn3_group#.PROJECT_PERIOD WHERE PROJECT_ID = #attributes.project_id# AND PERIOD_ID = #new_period_id# ");
	}

	if((attributes.basket_gross_total-(attributes.basket_discount_total-attributes.genel_indirim)) neq 0)
		genel_indirim_yuzdesi = attributes.genel_indirim / (attributes.basket_gross_total-(attributes.basket_discount_total-attributes.genel_indirim));
	else
		genel_indirim_yuzdesi = 0;
	for(i=1;i lte attributes.rows_;i=i+1)
	{
		urun_toplam_indirim = evaluate("attributes.row_total#i#")-evaluate("attributes.row_nettotal#i#");
		if(attributes.genel_indirim gt 0) //genel indirim 0 dan farkli ise indirim duzeltmesi
			urun_toplam_indirim = urun_toplam_indirim + (evaluate("attributes.row_nettotal#i#") * genel_indirim_yuzdesi);
		//urun_toplam_indirim = urun_toplam_indirim;
		
		if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))// proje bazlı muhasebe islemi yapılacaksa ve satırda proje seçili ise
		{//proje bazlı muhasebe yapılıyorsa ve satırda proje varsa
			product_account_codes=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT ACCOUNT_IADE,SALE_PRODUCT_COST,ACCOUNT_YURTDISI_PUR,ACCOUNT_CODE_PUR,MATERIAL_CODE,PRODUCTION_COST,ACCOUNT_DISCOUNT_PUR,ACCOUNT_PRICE_PUR,RECEIVED_PROGRESS_CODE,PROVIDED_PROGRESS_CODE,ACCOUNT_PRICE FROM #new_dsn3_group#.PROJECT_PERIOD WHERE PROJECT_ID = #evaluate("attributes.row_project_id#i#")# AND PERIOD_ID = #new_period_id# ");
			is_project_acc=1;
		}
		else if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and len(attributes.project_id) and len(attributes.project_head))	// proje bazlı muhasebe islemi yapılacaksa
		{//proje bazlı muhasebe yapılıyorsa ve belgede proje varsa
			product_account_codes=main_product_account_codes;
			is_project_acc=1;
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
			product_account_codes = get_product_account(prod_id:evaluate("attributes.product_id#i#"),period_id:new_period_id,product_account_db:new_dsn2_group,product_alias_db:"#new_dsn3_group#",department_id:dept_id,location_id:loc_id);
		}
		if(listfind('54,55',invoice_cat,',')) // Toptan Satis İade veya Perakende Satis İade oldugu icin Urunun Satis İade Hesabi Secilir
			product_account_code = product_account_codes.ACCOUNT_IADE ;
		else if (invoice_cat eq 591) //ithalat faturası ise
			product_account_code = product_account_codes.ACCOUNT_YURTDISI_PUR;
		else if (invoice_cat eq 601) //alınan hakediş faturası ise
			product_account_code = product_account_codes.RECEIVED_PROGRESS_CODE;
		else if (invoice_cat eq 63) //alinan fiyat farki faturası
		{
			//eğer fatura kontrol sayfasından geliyorsa , farkın oluştuğu faturanın tipine göre muhasebe kodu alnıyor
			if(isdefined("attributes.contract_row_ids") and len(attributes.contract_row_ids))
			{
				get_inv_type=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT I.PURCHASE_SALES FROM INVOICE I,INVOICE_CONTRACT_COMPARISON IC WHERE I.INVOICE_ID = IC.MAIN_INVOICE_ID AND IC.CONTRACT_COMPARISON_ROW_ID IN (#listlast(attributes.contract_row_ids)#)");
				if(get_inv_type.recordcount and get_inv_type.purchase_sales eq 1)
					product_account_code = product_account_codes.ACCOUNT_PRICE;	
				else
					product_account_code = product_account_codes.ACCOUNT_PRICE_PUR;	
			}
			else
				product_account_code = product_account_codes.ACCOUNT_PRICE_PUR;	
		}
		else if(evaluate("attributes.is_inventory#i#") eq 0)
			product_account_code = product_account_codes.ACCOUNT_CODE_PUR;		
		else if (location_type eq 1) //hammadde lokasyonu secilmisse
			product_account_code = product_account_codes.MATERIAL_CODE;
		else if (location_type eq 3)//mamul lokasyonu secilmisse
			product_account_code = product_account_codes.PRODUCTION_COST;
		else
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
					if(is_account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#comp_name_# - #evaluate("attributes.product_name#i#")#';
					else
						satir_detay_list[2][listlen(str_alacakli_tutarlar)] = genel_fis_satir_detay;
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
					if(is_account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#comp_name_# - #evaluate("attributes.product_name#i#")#';
					else
						satir_detay_list[2][listlen(str_alacakli_tutarlar)] = genel_fis_satir_detay;
					if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
						acc_project_list_alacak = ListAppend(acc_project_list_alacak,evaluate("attributes.row_project_id#i#"),",");
					else
						acc_project_list_alacak = ListAppend(acc_project_list_alacak,main_project_id,",");
				}
		}
		/*Satılan Malın Maliyeti Muhasebeleştiriliyor*/
		if(isdefined('is_prod_cost_acc_action') and is_prod_cost_acc_action eq 1 and listfind("54,55",invoice_cat))
		{
			temp_row_amount=0;
			if(len(new_karma_prod_id_list_) and listfind(new_karma_prod_id_list_,evaluate("attributes.product_id#i#"))) //satırdaki karma koli urunse, set icerigindeki urunlerin maliyet toplamı karmakoli urune yansıtılacak
			{
				row_prod_id=evaluate("attributes.product_id#i#");
				'temp_row_amount_#row_prod_id#'=0;
				for(kp=1;kp lte get_karma_prods_.recordcount;kp=kp+1)
				{
					if(row_prod_id eq get_karma_prods_.KARMA_PRODUCT_ID[kp] and listfind(product_cost_list_new,get_karma_prods_.PRODUCT_ID[kp]))
					{
						temp_karma_prod_amount=get_karma_prods_.PRODUCT_AMOUNT[kp];
						'temp_row_amount_#row_prod_id#'=evaluate('temp_row_amount_#row_prod_id#')+wrk_round(get_prod_cost_amounts.PRODUCT_COST_SYSTEM_AMOUNT[listfind(product_cost_list_new,get_karma_prods_.PRODUCT_ID[kp])]*get_karma_prods_.PRODUCT_AMOUNT[kp]);
					}
				}
				temp_row_amount=evaluate('temp_row_amount_#row_prod_id#')*evaluate("attributes.amount#i#");
				temp_row_other_amount=wrk_round(temp_row_amount*(attributes.basket_rate1/attributes.basket_rate2));
				temp_row_other_currency=form.basket_money;
			}
			else if(listfind(product_cost_list_new,evaluate("attributes.product_id#i#")))
			{
				rel_query = "SELECT SHIP_ID,SHIP_PERIOD FROM #new_dsn2_group#.SHIP_ROW_RELATION WHERE TO_SHIP_ID = (SELECT SHIP_ID from #new_dsn2_group#.SHIP_ROW_RELATION WHERE SHIP_PERIOD = #new_period_id# AND TO_INVOICE_ID = #attributes.invoice_id# AND  PRODUCT_ID = #evaluate('attributes.product_id#i#')#)";
				rel_query_result = cfquery(datasource:"#new_dsn2_group#",sqlstring:rel_query);
				if(rel_query_result.recordcount){
					get_per = cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM #DSN#.SETUP_PERIOD WHERE PERIOD_ID = #rel_query_result.SHIP_PERIOD#");
					rel_query2 = cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT SHIP_DATE FROM #DSN#_#get_per.PERIOD_YEAR#_#get_per..OUR_COMPANY_ID#.SHIP WHERE SHIP_ID = #rel_query_result.SHIP_ID#");
					if(rel_query2.recordcount and len(rel_query2.SHIP_DATE)){
						prod_cost_str="SELECT PRODUCT_ID,(PURCHASE_NET+PURCHASE_EXTRA_COST) AS PRODUCT_COST_AMOUNT, PURCHASE_NET_MONEY,(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM) AS PRODUCT_COST_SYSTEM_AMOUNT ,PURCHASE_NET_SYSTEM_MONEY ";
						prod_cost_str=prod_cost_str&" FROM #new_dsn3_group#.PRODUCT_COST WHERE PRODUCT_ID IN (#check_prod_cost_list#) AND START_DATE <= #createodbcdate(rel_query2.SHIP_DATE)# AND PRODUCT_COST_ID=";   
						prod_cost_str=prod_cost_str&" (SELECT TOP 1 PC.PRODUCT_COST_ID FROM #new_dsn3_group#.PRODUCT_COST PC WHERE PC.PRODUCT_ID =PRODUCT_COST.PRODUCT_ID AND START_DATE <= #createodbcdate(rel_query2.SHIP_DATE)# ORDER BY START_DATE DESC,PRODUCT_ID,RECORD_DATE DESC, PRODUCT_COST_ID DESC)";
						prod_cost_str=prod_cost_str&" ORDER BY PRODUCT_ID";	
						get_prod_cost_amounts=cfquery(datasource:"#new_dsn2_group#",sqlstring:prod_cost_str);
						
					}
				}
				
				temp_row_amount=(get_prod_cost_amounts.PRODUCT_COST_SYSTEM_AMOUNT[listfind(product_cost_list_new,evaluate("attributes.product_id#i#"))]*evaluate("attributes.amount#i#"));
				temp_row_other_amount=(get_prod_cost_amounts.PRODUCT_COST_AMOUNT[listfind(product_cost_list_new,evaluate("attributes.product_id#i#"))]*evaluate("attributes.amount#i#"));
				temp_row_other_currency=get_prod_cost_amounts.PURCHASE_NET_MONEY[listfind(product_cost_list_new,evaluate("attributes.product_id#i#"))];
			}
			if(temp_row_amount neq 0)
			{
				str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,product_account_codes.SALE_PRODUCT_COST,",");  //urunun satılan malın maliyeti hesabı alacaklı
				str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,temp_row_amount,",");
				str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,temp_row_other_amount,",");
				str_other_currency_alacak = ListAppend(str_other_currency_alacak,temp_row_other_currency,",");

				if(is_account_group neq 1)
					satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#comp_name_# - #evaluate("product_name#i#")#';
				else
					satir_detay_list[2][listlen(str_alacakli_tutarlar)] = genel_fis_satir_detay;
			
				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,product_account_codes.ACCOUNT_CODE_PUR,",");  //alıs hesabı borclu 
				str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,temp_row_amount,",");
				str_dovizli_borclar = ListAppend(str_dovizli_borclar,temp_row_other_amount,",");
				str_other_currency_borc = ListAppend(str_other_currency_borc,temp_row_other_currency,",");
				str_borclu_miktar[listlen(str_borclu_tutarlar)] = '#evaluate("attributes.amount#i#")#';
				str_borclu_tutar[listlen(str_borclu_tutarlar)] = '#evaluate("attributes.price#i#")#'; 
				if(is_account_group neq 1)
					satir_detay_list[1][listlen(str_borclu_tutarlar)]='#comp_name_# - #evaluate("product_name#i#")#';
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
		//otv bloğu
		if(evaluate("form.row_otvtotal#i#") neq 0 and len(evaluate("form.otv_oran#i#")))
		{
			get_otv_row=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT * FROM #new_dsn3_group#.SETUP_OTV WHERE TAX = #evaluate("form.otv_oran#i#")#  AND PERIOD_ID = #new_period_id#");
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

			if(evaluate("form.otv_discount#i#") neq 0) {
				str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, get_otv_row.account_code_p_discount, ",");
				str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,temp_otv_tutar, ",");
				str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar, (temp_otv_tutar*(form.basket_rate1/form.basket_rate2)), ",");
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
		// kdv bloğu
		if(evaluate("form.row_taxtotal#i#") gt 0)
		{
			temp_tax_tutar = evaluate("form.row_taxtotal#i#");
			temp_tax_tutar2 = evaluate("form.row_taxtotal#i#");
			if( isdefined("form.tevkifat_box") and isdefined('form.tevkifat_oran') and len(form.tevkifat_oran) and is_visible_tevkifat neq 1)
			{ 
				/*herbir kdv ye uygulanacak tevkşfat icin muhasebe hesapları cekiliyor*/
				tevkifat_acc_codes=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT 
										ST_ROW.TEVKIFAT_BEYAN_CODE_PUR,ST_ROW.TEVKIFAT_CODE_PUR,ST_ROW.TAX
									FROM 
										#new_dsn3_group#.SETUP_TEVKIFAT S_TEV,#new_dsn3_group#.SETUP_TEVKIFAT_ROW ST_ROW 
									WHERE
										S_TEV.TEVKIFAT_ID = ST_ROW.TEVKIFAT_ID
										AND S_TEV.TEVKIFAT_ID = #form.tevkifat_id#
										AND ST_ROW.TAX = #evaluate("form.tax#i#")#
										ORDER BY ST_ROW.TAX");
				temp_tax_tutar2 = wrk_round((temp_tax_tutar*form.tevkifat_oran),attributes.basket_price_round_number);
			}
			get_tax_row=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT * FROM SETUP_TAX WHERE TAX = #evaluate("form.tax#i#")#");
			if(genel_indirim_yuzdesi gt 0) //fatura altı indirim varsa, indirim kdv toplamlara da yansıtılır
			{
				temp_tax_tutar =  wrk_round((temp_tax_tutar-(temp_tax_tutar*genel_indirim_yuzdesi)),attributes.basket_price_round_number);
				temp_tax_tutar2 =  wrk_round((temp_tax_tutar2-(temp_tax_tutar2*genel_indirim_yuzdesi)),attributes.basket_price_round_number);
			}
			if( isdefined("form.tevkifat_box") and isdefined('form.tevkifat_oran') and len(form.tevkifat_oran) and is_visible_tevkifat neq 1)
			{
				temp_tax_tutar2 = wrk_round(temp_tax_tutar-temp_tax_tutar2,attributes.basket_price_round_number);
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
			else if(len(evaluate("attributes.row_tevkifat_rate#i#")) gt 0 and evaluate("attributes.row_tevkifat_rate#i#") gt 0 and is_visible_tevkifat neq 1) {
				/*herbir kdv ye uygulanacak tevkşfat icin muhasebe hesapları cekiliyor*/
				tevkifat_acc_codes=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT TOP 1
										ST_ROW.TEVKIFAT_BEYAN_CODE_PUR,ST_ROW.TEVKIFAT_CODE_PUR,ST_ROW.TAX
									FROM 
										#new_dsn3_group#.SETUP_TEVKIFAT S_TEV,#new_dsn3_group#.SETUP_TEVKIFAT_ROW ST_ROW 
									WHERE
										S_TEV.TEVKIFAT_ID = ST_ROW.TEVKIFAT_ID
										AND S_TEV.STATEMENT_RATE = #evaluate("attributes.row_tevkifat_rate#i#")#
										AND ST_ROW.TAX = #evaluate("form.tax#i#")#
										ORDER BY ST_ROW.TAX");
				temp_tax_tutar2 = wrk_round((temp_tax_tutar*evaluate("attributes.row_tevkifat_rate#i#")),attributes.basket_price_round_number);

				temp_tax_tutar2 = wrk_round(temp_tax_tutar-temp_tax_tutar2,attributes.basket_price_round_number);

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
					else
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, get_tax_row.purchase_code, ",");
				}
			}
			if( (isdefined("form.tevkifat_box") and isdefined('form.tevkifat_oran') and len(form.tevkifat_oran)) or (len(evaluate("attributes.row_tevkifat_rate#i#")) and evaluate("attributes.row_tevkifat_rate#i#") gt 0)) // 01.02.2019 - '1 No.lu KDV Beyannamesinde İndirimler Tablosunda Değişiklik' 
			{
				// tevkifatın muhasebeleşmeme durumları için kullanılan blok
				
				if( isdefined("form.tevkifat_box") and isdefined('form.tevkifat_oran') and len(form.tevkifat_oran)){ 
					tevkifat_acc_codes=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT 
										ST_ROW.TEVKIFAT_BEYAN_CODE_PUR,ST_ROW.TEVKIFAT_CODE_PUR,ST_ROW.TAX
									FROM 
										#new_dsn3_group#.SETUP_TEVKIFAT S_TEV,#new_dsn3_group#.SETUP_TEVKIFAT_ROW ST_ROW 
									WHERE
										S_TEV.TEVKIFAT_ID = ST_ROW.TEVKIFAT_ID
										AND S_TEV.TEVKIFAT_ID = #form.tevkifat_id#
										AND ST_ROW.TAX = #evaluate("form.tax#i#")#
										ORDER BY ST_ROW.TAX");
				temp_tax_tutar2 = wrk_round((temp_tax_tutar*form.tevkifat_oran),attributes.basket_price_round_number);
				temp_tax_tutar2 = wrk_round(temp_tax_tutar-temp_tax_tutar2,attributes.basket_price_round_number);

				}else if( (len(evaluate("attributes.row_tevkifat_rate#i#")) and evaluate("attributes.row_tevkifat_rate#i#") gt 0) ){
					tevkifat_acc_codes=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT TOP 1
										ST_ROW.TEVKIFAT_BEYAN_CODE_PUR,ST_ROW.TEVKIFAT_CODE_PUR,ST_ROW.TAX
									FROM 
										#new_dsn3_group#.SETUP_TEVKIFAT S_TEV,#new_dsn3_group#.SETUP_TEVKIFAT_ROW ST_ROW 
									WHERE
										S_TEV.TEVKIFAT_ID = ST_ROW.TEVKIFAT_ID
										AND S_TEV.STATEMENT_RATE = #evaluate("attributes.row_tevkifat_rate#i#")#
										AND ST_ROW.TAX = #evaluate("form.tax#i#")#
										ORDER BY ST_ROW.TAX");
				temp_tax_tutar2 = wrk_round((temp_tax_tutar*evaluate("attributes.row_tevkifat_rate#i#")),attributes.basket_price_round_number);
				temp_tax_tutar2 = wrk_round(temp_tax_tutar-temp_tax_tutar2,attributes.basket_price_round_number);

				}

				if(is_visible_tevkifat neq 1){	
					str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,temp_tax_tutar2, ",");
					str_dovizli_borclar = ListAppend(str_dovizli_borclar, (temp_tax_tutar2*(form.basket_rate1/form.basket_rate2)), ",");
				}else{
					str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,temp_tax_tutar-temp_tax_tutar2, ",");
					str_dovizli_borclar = ListAppend(str_dovizli_borclar, (temp_tax_tutar-temp_tax_tutar2*(form.basket_rate1/form.basket_rate2)), ",");
				}
				
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

				if(is_visible_tevkifat neq 1){	

					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, get_tax_row.purchase_code, ",");
					str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,(temp_tax_tutar-temp_tax_tutar2), ",");
					str_dovizli_borclar = ListAppend(str_dovizli_borclar, ((temp_tax_tutar-temp_tax_tutar2)*(form.basket_rate1/form.basket_rate2)), ",");
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
			else
			{
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

		// bsmv bloğu
		if(IsDefined("form.row_bsmv_amount#i#") and evaluate("form.row_bsmv_amount#i#") gt 0)
		{
			temp_bsmv_tutar = evaluate("form.row_bsmv_amount#i#");
			get_bsmv_row=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT * FROM #new_dsn3_group#.SETUP_BSMV WHERE TAX = #evaluate("form.row_bsmv_rate#i#")#");
			
			if( is_expensing_bsmv eq 1 ){//Bsmv'yi giderleştir
				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, get_bsmv_row.direct_expense_code, ",");
			}else{
				if(Listfind('54,55',invoice_cat)) //iade faturası
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, get_bsmv_row.account_code_iade, ",");
				/*else if(invoice_cat eq 58) //verilen fiyat farkı
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, get_bsmv_row.sale_price_diff_code, ",");*/
				else
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, get_bsmv_row.purchase_code, ",");
			}
			str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,temp_bsmv_tutar, ",");
			str_dovizli_borclar = ListAppend(str_dovizli_borclar, (temp_bsmv_tutar*(form.basket_rate1/form.basket_rate2)), ",");
			str_other_currency_borc = ListAppend(str_other_currency_borc,form.basket_money,",");
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

		// oiv bloğu
		if(IsDefined("form.row_oiv_amount#i#") and evaluate("form.row_oiv_amount#i#") gt 0)
		{
			temp_oiv_tutar = evaluate("form.row_oiv_amount#i#");
			get_oiv_row=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT * FROM #new_dsn3_group#.SETUP_OIV WHERE TAX = #evaluate("form.row_oiv_rate#i#")#");
			if(Listfind('54,55',invoice_cat)) //iade faturası
				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, get_oiv_row.account_code_iade, ",");
			/*else if(invoice_cat eq 58) //verilen fiyat farkı
				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, get_oiv_row.sale_price_diff_code, ",");*/
			else
				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, get_oiv_row.purchase_code, ",");
			str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,temp_oiv_tutar, ",");
			str_dovizli_borclar = ListAppend(str_dovizli_borclar, (temp_oiv_tutar*(form.basket_rate1/form.basket_rate2)), ",");
			str_other_currency_borc = ListAppend(str_other_currency_borc,form.basket_money,",");
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
	str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar, (attributes.basket_net_total), ",");//kdv dahil stopaj haric tutar
	str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,((attributes.basket_net_total)/form.basket_rate2),",");
	str_other_currency_alacak = ListAppend(str_other_currency_alacak,attributes.basket_money,",");
	satir_detay_list[2][listlen(str_alacakli_tutarlar)]=genel_fis_satir_detay;
	if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
		acc_project_list_alacak = ListAppend(acc_project_list_alacak,attributes.project_id,",");
	else
		acc_project_list_alacak = ListAppend(acc_project_list_alacak,0,",");
	// stopaj
	if(isdefined("form.stopaj") and len(form.stopaj) and form.stopaj gt 0)
	{
		str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, GET_SETUP_STOPPAGE_RATES.STOPPAGE_ACCOUNT_CODE, ",");
		str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar, form.stopaj, ",");
		str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,(form.stopaj/form.basket_rate2),",");
		str_other_currency_alacak = ListAppend(str_other_currency_alacak,form.basket_money,",");
		satir_detay_list[2][listlen(str_alacakli_tutarlar)]=genel_fis_satir_detay;
		if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
			acc_project_list_alacak = ListAppend(acc_project_list_alacak,attributes.project_id,",");
		else
			acc_project_list_alacak = ListAppend(acc_project_list_alacak,0,",");
	}
	if(len(attributes.yuvarlama) and attributes.yuvarlama lt 0)
	{
		str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, hesap_yuvarlama, ",");
		str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar, abs(attributes.yuvarlama), ",");
		str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,abs(attributes.yuvarlama), ",");
		str_other_currency_alacak = ListAppend(str_other_currency_alacak,session.ep.money, ",");
		satir_detay_list[2][listlen(str_alacakli_tutarlar)]=genel_fis_satir_detay;
		if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
			acc_project_list_alacak = ListAppend(acc_project_list_alacak,attributes.project_id,",");
		else
			acc_project_list_alacak = ListAppend(acc_project_list_alacak,0,",");
	}
	else if(len(attributes.yuvarlama) and attributes.yuvarlama gt 0)
	{
		str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, hesap_yuvarlama, ",");
		str_borclu_tutarlar = ListAppend(str_borclu_tutarlar, abs(attributes.yuvarlama), ",");
		str_dovizli_borclar = ListAppend(str_dovizli_borclar,abs(attributes.yuvarlama), ",");
		str_other_currency_borc = ListAppend(str_other_currency_borc,session.ep.money, ",");
		satir_detay_list[1][listlen(str_borclu_tutarlar)]=genel_fis_satir_detay;
		if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
			acc_project_list_borc = ListAppend(acc_project_list_borc,attributes.project_id,",");
		else
			acc_project_list_borc = ListAppend(acc_project_list_borc,0,",");
	}
	//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
	str_fark_gelir =GET_NO_.FARK_GELIR;
	str_fark_gider =GET_NO_.FARK_GIDER;
	str_max_round = 0.5;
	str_round_detail = genel_fis_satir_detay;
</cfscript>
