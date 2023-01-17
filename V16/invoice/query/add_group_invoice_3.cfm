<cfquery name="get_inv_note_" datasource="#DSN2#">
    SELECT NOTE FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_id.max_id#">
</cfquery>
<cfscript>
	if(isdefined('attributes.branch_id') and len(attributes.branch_id) )
		to_branch_id = attributes.branch_id;
	else
		to_branch_id = ListGetAt(session.ep.user_location,2,"-");

	GET_INV_ROWS = cfquery(datasource:"#dsn2#",sqlstring:"SELECT * FROM INVOICE_ROW WHERE INVOICE_ID = #get_invoice_id.max_id#");
</cfscript>

<cfscript>
	if(is_cari) // fatura cari
	{
		carici(
			action_id : get_invoice_id.max_id,
			action_table : 'INVOICE',
			workcube_process_type : INVOICE_CAT,
			due_date : due_date,
			account_card_type : 12,
			islem_tarihi : attributes.invoice_date,
			islem_tutari : kdvli_toplam_main,
			islem_belge_no : attributes.INVOICE_NUMBER,
			to_cmp_id : invoice_comp_id,
			to_consumer_id : invoice_cons_id,
			to_branch_id : iif(len(to_branch_id),de('#to_branch_id#'),de('')),
			islem_detay : DETAIL_,
			action_detail : attributes.invoice_number,
			other_money_value : other_money_tutar_main,
			other_money : invoice_other_money,
			action_currency : SESSION.EP.MONEY,
			process_cat : form.process_cat,
			currency_multiplier : attributes.currency_multiplier,
			rate2 : attributes.currency_multiplier
		);
	}

	if(is_account)  //fatura muhasebe
	{	
		DETAIL_1 = evaluate("attributes.subs_name#i#") & ' ' & DETAIL_ & ' GİRİŞ İŞLEMİ(#member_code_info#)';
		str_borclu_hesaplar = '' ;
		str_borclu_tutarlar = '' ;
		str_alacakli_hesaplar = '' ;
		str_alacakli_tutarlar = '' ;
		str_dovizli_borclar = '' ;
		str_other_currency_borc = '';
		str_dovizli_alacaklar = '' ;
		str_other_currency_alacak = '';
		genel_indirim_yuzdesi = 0; //  fat alt ind yok   form.genel_indirim / (form.basket_gross_total-(form.basket_discount_total-form.genel_indirim));
		//standart aciklama olmasi saglandi.
		genel_fis_satir_detay = "#attributes.invoice_number#-#evaluate("attributes.subs_name#i#")# FATURA" & iif(isDefined("get_inv_note_.note") and Len(get_inv_note_.note),de("-#get_inv_note_.note#"),de(""));
		satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar. satir_detay_list[1]'a  borc yazan satırların acıklamaları, satir_detay_list[2]'a alacak yazan satırların acıklamaları set edilir. 
		str_alacak_miktar = ArrayNew(1);
		str_alacak_tutar = ArrayNew(1);

		for(t=1;t lte GET_INV_ROWS.recordcount;t=t+1)
		{
			product_account_codes = get_product_account(prod_id:GET_INV_ROWS.PRODUCT_ID[t]);
			if(len(product_account_codes.ACCOUNT_CODE))
			{
				product_account_code = product_account_codes.ACCOUNT_CODE ;
				str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,product_account_code,",");
				if(is_discount eq 0){
					str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,wrk_round(GET_INV_ROWS.NETTOTAL[t]+GET_INV_ROWS.DISCOUNTTOTAL[t],round_num),",");
					//str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,wrk_round(GET_INV_ROWS.OTHER_MONEY_VALUE[t],round_num),",");
					str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,wrk_round((GET_INV_ROWS.PRICE_OTHER[t]*GET_INV_ROWS.AMOUNT[t]),round_num),",");
				}
				else{
					str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,wrk_round(GET_INV_ROWS.NETTOTAL[t],round_num),",");
					if(isDefined("attributes.currency_rate_#GET_INV_ROWS.OTHER_MONEY[t]#"))
						row_rate=#evaluate("attributes.currency_rate_#GET_INV_ROWS.OTHER_MONEY[t]#")#;
					else 
						row_rate=attributes.islem_currency_multiplier_2;
					
					str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,wrk_round((GET_INV_ROWS.NETTOTAL[t] / row_rate),round_num),",");

				}
				str_alacak_miktar[listlen(str_alacakli_tutarlar)] = '#GET_INV_ROWS.AMOUNT[t]#';
				str_alacak_tutar[listlen(str_alacakli_tutarlar)] = '#GET_INV_ROWS.PRICE[t]#'; 
				satir_detay_list[2][listlen(str_alacakli_tutarlar)] = '#GET_INV_ROWS.NAME_PRODUCT[t]#';
				
				str_other_currency_alacak = ListAppend(str_other_currency_alacak,GET_INV_ROWS.OTHER_MONEY[t],",");
			}
			if(is_discount eq 0)
				{
					urun_toplam_indirim = wrk_round(GET_INV_ROWS.DISCOUNTTOTAL[t],round_num);
					/* fatura alti indirim yok
					if(form.genel_indirim gt 0) //genel indirim 0 dan farkli ise indirim duzeltmesi
						urun_toplam_indirim = urun_toplam_indirim + wrk_round(evaluate("attributes.row_nettotal#i#") * genel_indirim_yuzdesi);*/
					if(urun_toplam_indirim gt 0 and len(product_account_codes.ACCOUNT_DISCOUNT))
						{ //urune ait satis indirim hesabina
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,product_account_codes.ACCOUNT_DISCOUNT,",");
							str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,urun_toplam_indirim,",");
							satir_detay_list[1][listlen(str_borclu_tutarlar)]=genel_fis_satir_detay; 
							str_dovizli_borclar = ListAppend(str_dovizli_borclar,wrk_round(urun_toplam_indirim*attributes.islem_currency_multiplier_for_account,round_num),",");
							str_other_currency_borc = ListAppend(str_other_currency_borc,'#session.ep.money2#',",");
						}
					else if(urun_toplam_indirim gt 0 and (not len(product_account_codes.ACCOUNT_DISCOUNT)))
						{ //urune ait indirim hesabi yoksa genel indirim hesabina
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,GET_NO_.A_DISC,",");
							str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,urun_toplam_indirim,",");
							satir_detay_list[1][listlen(str_borclu_tutarlar)] = genel_fis_satir_detay; 
							str_dovizli_borclar = ListAppend(str_dovizli_borclar,wrk_round(urun_toplam_indirim*attributes.islem_currency_multiplier_for_account,round_num),",");
							str_other_currency_borc = ListAppend(str_other_currency_borc,'#session.ep.money2#',",");
						}
				}
			for (aa=1;aa lte get_taxes.recordcount;aa=aa+1)
			{
				if(get_taxes.tax[aa] eq GET_INV_ROWS.TAX[t])
				{
					if( is_expensing_tax eq 1 ) // kdv giderleştirme
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, get_taxes.direct_expense_code[aa], ",");
					else
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, get_taxes.sale_code[aa], ",");
					str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar, wrk_round(GET_INV_ROWS.TAXTOTAL[t],round_num), ",");
					str_alacak_miktar[listlen(str_alacakli_tutarlar)] = ''; //muhasebeciye gönderilen miktar-tutar array i icin eklendi OZDEN20060922
					str_alacak_tutar[listlen(str_alacakli_tutarlar)] = ''; 
					satir_detay_list[2][listlen(str_alacakli_tutarlar)] = genel_fis_satir_detay;
					str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar, wrk_round(GET_INV_ROWS.TAXTOTAL[t]*attributes.islem_currency_multiplier_for_account,round_num),",");
					//str_other_currency_alacak = ListAppend(str_other_currency_alacak,'#session.ep.money2#',",");
					str_other_currency_alacak = ListAppend(str_other_currency_alacak,invoice_other_money,",");
				}
			}
			for (kk=1;kk lte get_otv.recordcount;kk=kk+1){
				if(get_otv.tax[kk] eq GET_INV_ROWS.OTV_ORAN[t])
				{
					if(GET_INV_ROWS.OTV_ORAN[t] neq 0)
					{
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, get_otv.account_code[kk], ",");
						str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,wrk_round(GET_INV_ROWS.OTVTOTAL[t],round_num), ",");
						str_alacak_miktar[listlen(str_alacakli_tutarlar)] = ''; //muhasebeciye gönderilen miktar-tutar array i icin eklendi OZDEN20060922
						str_alacak_tutar[listlen(str_alacakli_tutarlar)] = ''; 
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]=genel_fis_satir_detay; //otv acıklamaları icin fis satırlarına fatura genel bilgileri set edilir.
						str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar, wrk_round(GET_INV_ROWS.OTVTOTAL[t]*attributes.islem_currency_multiplier_for_account,round_num),",");
						//str_other_currency_alacak = ListAppend(str_other_currency_alacak,'#session.ep.money2#',",");
						str_other_currency_alacak = ListAppend(str_other_currency_alacak,invoice_other_money,",");
					}
				}
			}


			// bsmv bloğu
			for (bs=1;bs lte get_bsmv.recordcount;bs=bs+1){
				if(get_bsmv.tax[bs] eq GET_INV_ROWS.BSMV_RATE[t])
				{
					
					if(GET_INV_ROWS.BSMV_RATE[t] neq 0)
					{
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, get_bsmv.account_code[bs], ",");
						str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,wrk_round(GET_INV_ROWS.BSMV_AMOUNT[t],round_num), ",");
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]=genel_fis_satir_detay; 
						str_alacak_miktar[listlen(str_alacakli_tutarlar)] = ''; 
						str_alacak_tutar[listlen(str_alacakli_tutarlar)] = ''; 
						if(GET_INV_ROWS.BSMV_AMOUNT[t] gt 0)
							str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,wrk_round(GET_INV_ROWS.BSMV_AMOUNT[t]*attributes.islem_currency_multiplier_for_account,round_num), ",");
						else 
							str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,0, ",");
						//if(GET_INV_ROWS.OTHER_MONEY[t] is not session.ep.money)
						//	str_other_currency_alacak = ListAppend(str_other_currency_alacak,GET_INV_ROWS.OTHER_MONEY[t],",");
						//else
						//	str_other_currency_alacak = ListAppend(str_other_currency_alacak,'#session.ep.money2#',",");
						str_other_currency_alacak = ListAppend(str_other_currency_alacak,invoice_other_money,",");
					}
				}
			}

			// bsmv giderleştirme
			for (bs=1;bs lte get_bsmv.recordcount;bs=bs+1){
				if(get_bsmv.tax[bs] eq GET_INV_ROWS.BSMV_RATE[t])
				{
					
					if(is_expensing_bsmv eq 1 and GET_INV_ROWS.BSMV_RATE[t] neq 0)
					{
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, get_bsmv.direct_expense_code[bs], ",");
						str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,wrk_round(GET_INV_ROWS.BSMV_AMOUNT[t],round_num), ",");
						satir_detay_list[2][listlen(str_borclu_tutarlar)]=genel_fis_satir_detay; 
						if(GET_INV_ROWS.BSMV_AMOUNT[t] gt 0)
							str_dovizli_borclar = ListAppend(str_dovizli_borclar,wrk_round(GET_INV_ROWS.BSMV_AMOUNT[t]*attributes.islem_currency_multiplier_for_account,round_num), ",");
						else 
							str_dovizli_borclar = ListAppend(str_dovizli_borclar,0, ",");								
						str_other_currency_borc = ListAppend(str_other_currency_borc,invoice_other_money,",");
					}
				}
			}

			// oiv bloğu
			for (ov=1;ov lte get_oiv.recordcount;ov=ov+1){
				if(get_oiv.tax[ov] eq GET_INV_ROWS.OIV_RATE[t])
				{
					if(GET_INV_ROWS.OIV_RATE[t] neq 0)
					{
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, get_oiv.account_code[ov], ",");
						str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,wrk_round(GET_INV_ROWS.OIV_AMOUNT[t],round_num), ",");
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]=genel_fis_satir_detay; 
						str_alacak_miktar[listlen(str_alacakli_tutarlar)] = ''; 
						str_alacak_tutar[listlen(str_alacakli_tutarlar)] = '';
						if(GET_INV_ROWS.OIV_AMOUNT[t] gt 0)
							str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,wrk_round(GET_INV_ROWS.OIV_AMOUNT[t]*attributes.islem_currency_multiplier_for_account,round_num), ",");
						else 
							str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,0, ",");
						//if(GET_INV_ROWS.OTHER_MONEY[t] is not session.ep.money)
						//	str_other_currency_alacak = ListAppend(str_other_currency_alacak,GET_INV_ROWS.OTHER_MONEY[t],",");
						//else
						//	str_other_currency_alacak = ListAppend(str_other_currency_alacak,'#session.ep.money2#',",");
						str_other_currency_alacak = ListAppend(str_other_currency_alacak,invoice_other_money,",");
					}
				}
			}


		}
				
			str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,ACC,",");
			str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,wrk_round(kdvli_toplam_main,round_num),",");
			satir_detay_list[1][listlen(str_borclu_tutarlar)] = genel_fis_satir_detay; 
			//str_dovizli_borclar = ListAppend(str_dovizli_borclar,wrk_round(kdvli_toplam_main/attributes.currency_multiplier,round_num),",");
			str_dovizli_borclar = ListAppend(str_dovizli_borclar,wrk_round(kdvli_toplam_main*attributes.islem_currency_multiplier_for_account,round_num),",");
			
			//	str_other_currency_borc = ListAppend(str_other_currency_borc,'#session.ep.money2#',",");
			str_other_currency_borc = ListAppend(str_other_currency_borc,invoice_other_money,",");

			/*
			// 20050825 1-3 kurus icin tutmayan fis e gelir veya gider fark satiri ekleme 
			temp_total_alacak = evaluate(ListChangeDelims(str_alacakli_tutarlar,'+',','));// alacakli hesaplar toplam degeri 
			temp_total_borc = evaluate(ListChangeDelims(str_borclu_tutarlar,'+',','));// borclu hesaplar toplam degeri 
			temp_fark = round((temp_total_alacak-temp_total_borc)*100);
			if( temp_fark gte -3 and temp_fark lt 0 )
				{// gelir hesabi alacaklilara eklenmeli, borc bakiye gelmis 
				str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, GET_NO_.FARK_GELIR, ",");
				str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar, abs(temp_fark/100), ",");
				satir_detay_list[2][listlen(str_alacakli_tutarlar)] = genel_fis_satir_detay;
				str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,abs(temp_fark/100),",");
				str_other_currency_alacak = ListAppend(str_other_currency_alacak,session.ep.money,",");
				}
			else if( temp_fark lte 3 and temp_fark gt 0 )
				{// gider hesabi borclulara eklenmeli, alacak bakiye gelmis 
				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, GET_NO_.FARK_GIDER, ",");
				str_borclu_tutarlar = ListAppend(str_borclu_tutarlar, abs(temp_fark/100), ",");
				satir_detay_list[1][listlen(str_borclu_tutarlar)] = genel_fis_satir_detay; 
				str_dovizli_borclar = ListAppend(str_dovizli_borclar,abs(temp_fark/100),",");
				str_other_currency_borc = ListAppend(str_other_currency_borc,session.ep.money,",");
				}
			*/
			str_fark_gelir =GET_NO_.FARK_GELIR;
			str_fark_gider =GET_NO_.FARK_GIDER;
			str_max_round = 0.15;
			str_round_detail = genel_fis_satir_detay;

		muhasebeci(
			wrk_id : wrk_id,
			action_id : get_invoice_id.max_id,
			workcube_process_type : INVOICE_CAT,
			workcube_process_cat : process_cat,
			account_card_type : 13,
			company_id :  invoice_comp_id,
			consumer_id :  invoice_cons_id,
			islem_tarihi : attributes.invoice_date,
			borc_hesaplar : str_borclu_hesaplar,
			borc_tutarlar : str_borclu_tutarlar,
			alacak_hesaplar : str_alacakli_hesaplar,
			alacak_tutarlar : str_alacakli_tutarlar,
			alacak_miktarlar : str_alacak_miktar,
			alacak_birim_tutar : str_alacak_tutar,
			to_branch_id : iif(len(to_branch_id),de('#to_branch_id#'),de('')),
			fis_detay : DETAIL_1,
			fis_satir_detay : satir_detay_list,
			belge_no : attributes.invoice_number,
			is_account_group : is_account_group,
			other_amount_borc : str_dovizli_borclar,
			other_currency_borc : str_other_currency_borc,
			other_amount_alacak : str_dovizli_alacaklar,
			other_currency_alacak : str_other_currency_alacak,
			currency_multiplier : attributes.currency_multiplier,
			dept_round_account :str_fark_gider,
			claim_round_account : str_fark_gelir,
			max_round_amount :str_max_round,
			round_row_detail:str_round_detail
			);

	}
	if(is_budget)
	{ //butce
		for(bt=1;bt lte GET_INV_ROWS.recordcount;bt=bt+1)
		{
			dagilim=false;
			//GET_MAX_INV_ROW = cfquery(datasource : "#dsn2#", sqlstring : "SELECT MAX(INVOICE_ROW_ID) ROW_MAX_ID FROM INVOICE_ROW WHERE INVOICE_ID=#get_invoice_id.max_id#");
			net_tutar=GET_INV_ROWS.NETTOTAL[bt];
			if(not isnumeric(net_tutar)) net_tutar=0;
			other_money_value=GET_INV_ROWS.OTHER_MONEY_VALUE[bt];
			if(not isnumeric(other_money_value)) other_money_value=0;
			butce=butceci(
				action_id:get_invoice_id.max_id,
				muhasebe_db:dsn2,
				stock_id: GET_INV_ROWS.STOCK_ID[bt],
				product_id:GET_INV_ROWS.PRODUCT_ID[bt],
				product_tax:GET_INV_ROWS.TAX[bt],
				product_otv: iif((len(GET_INV_ROWS.OTV_ORAN[bt])),GET_INV_ROWS.OTV_ORAN[bt],0),
				product_bsmv: iif((len(GET_INV_ROWS.BSMV_RATE[bt])),GET_INV_ROWS.BSMV_RATE[bt],0),
				product_oiv: iif((len(GET_INV_ROWS.OIV_RATE[bt])),GET_INV_ROWS.OIV_RATE[bt],0),
				tevkifat_rate: iif((len(GET_INV_ROWS.TEVKIFAT_RATE[bt])),GET_INV_ROWS.TEVKIFAT_RATE[bt],0),
				subscription_id: iif((len(GET_INV_ROWS.SUBSCRIPTION_ID[bt])),GET_INV_ROWS.SUBSCRIPTION_ID[bt],0),
				invoice_row_id:GET_INV_ROWS.INVOICE_ROW_ID,
				paper_no:attributes.invoice_number,
				detail : '#attributes.invoice_number# Nolu Fatura',
				is_income_expense: 'true',
				process_type:INVOICE_CAT,
				nettotal:net_tutar,
				other_money_value:other_money_value,
				action_currency:GET_INV_ROWS.OTHER_MONEY[bt],
				expense_date:attributes.invoice_date,
				department_id:attributes.department_id,
				branch_id :iif(len(to_branch_id),de('#to_branch_id#'),de('')),
				currency_multiplier : attributes.currency_multiplier
				);
			if(butce) dagilim=true;//bir satır bile dagilim yapıldığında is_cost alanını 1 set etmek için dagilim true set ediliyor
			if(dagilim) upd_invoice_cost = cfquery(datasource : "#dsn2#", is_select: false,sqlstring : "UPDATE INVOICE SET IS_COST=1 WHERE INVOICE_ID=#get_invoice_id.max_id#");
		}
	}
</cfscript>

<cfif next_periods_accrual_action eq 1>
	<cfscript>
		if(isDefined('form.invoice_id')) {
			accrual_invoice_id = form.invoice_id;
		} else if(isDefined('get_invoice_id.max_id')) {
			accrual_invoice_id = get_invoice_id.max_id;
		}

		//form.process_cat = process_cat;
		form.invoice_number = attributes.invoice_number;
		form.basket_money = invoice_other_money;
		form.basket_rate2 = invoice_rate2;
		form.basket_rate1 = invoice_rate1;
		attributes.rd_money = invoice_other_money;
		attributes.basket_money = invoice_other_money;
		attributes.subscription_id_ = GET_BILLED_INFO.SUBSCRIPTION_ID;
		attributes.basket_price_round_number = round_num;
		attributes.company_id = GET_BILLED_INFO.INVOICE_COMPANY_ID;
		attributes.consumer_id = GET_BILLED_INFO.INVOICE_CONSUMER_ID;
		attributes.employee_id = "";
		OTHER_MONEY = invoice_other_money;
		INV_PROJECT_ID=GET_BILLED_INFO.PROJECT_ID;
		BUDGET_BRANCH_ID = attributes.branch_id;
		COMP_NAME_ = '';//evaluate("attributes.subs_name#i#"); ismi çekmek lazım alamıyoruz şuan
		
		MAIN_PROJECT_ID = GET_BILLED_INFO.PROJECT_ID;
		SALES_EMP_ID = GET_BILLED_INFO.SALES_EMP_ID;
		ACC_DEPARTMENT_ID = "";//???
		ACC_PROJECT_LIST_BORC ="";
			
		/*daha önceki bloklard tanımlı 
		//attributes.invoice_date 
		//attributes.kur_say = 
		//attributes.invoice_date 
		//attributes.department_id = 
		//attributes.currency_multiplier
		*/

		/*toplu fatuada alt tevkifat yok
		//form.tevkifat_box
		//form.tevkifat_id 
		//form.tevkifat_oran
		*/

		/*kurlardan aldım add_sale_multi_2 de
		attributes.hidden_rd_money_#kk# =  GET_RATE_INFO.MONEY[kk];
			attributes.txt_rate2_#kk# = GET_RATE_INFO.RATE_INFO[kk];
			attributes.txt_rate1_#kk# = GET_RATE_INFO.RATE1[kk];
		*/

		attributes.rows_ = GET_INV_ROWS.recordcount;
		for(bt=1;bt lte GET_INV_ROWS.recordcount;bt=bt+1)
			{
				urun_toplam_indirim = GET_INV_ROWS.DISCOUNTTOTAL[bt];//bu bölüm bence hatalı ama invoice_accrual_action.cfm dosyasında bu değeri arıyor
	
				evaluate("form.row_deliver_date#bt# = dateformat(GET_INV_ROWS.DELIVER_DATE[bt],dateformat_style)");
				evaluate("form.deliver_date#bt# = dateformat(GET_INV_ROWS.DELIVER_DATE[bt],dateformat_style)");
				evaluate("attributes.deliver_date#bt# = CreateODBCDateTime(GET_INV_ROWS.DELIVER_DATE[bt])");//tahakkuk işleminde kullanıldığı için OBCDdate ile yapıldı
				evaluate("form.row_otvtotal#bt# = GET_INV_ROWS.OTVTOTAL[bt]");
				evaluate("form.otv_oran#bt# = GET_INV_ROWS.OTV_ORAN[bt]");
				evaluate("form.row_taxtotal#bt# = GET_INV_ROWS.TAXTOTAL[bt]");
				evaluate("form.tax#bt# = GET_INV_ROWS.TAX[bt]");
				evaluate("attributes.tax#bt# = GET_INV_ROWS.TAX[bt]");
				evaluate("form.row_bsmv_amount#bt# = GET_INV_ROWS.BSMV_AMOUNT[bt]");
				evaluate("form.row_bsmv_rate#bt# = GET_INV_ROWS.BSMV_RATE[bt]");
				evaluate("attributes.row_bsmv_amount#bt# = GET_INV_ROWS.BSMV_AMOUNT[bt]");
				evaluate("attributes.row_bsmv_rate#bt# = GET_INV_ROWS.BSMV_RATE[bt]");
				evaluate("form.row_oiv_amount#bt# = GET_INV_ROWS.OIV_AMOUNT[bt]");
				evaluate("form.row_oiv_rate#bt# = GET_INV_ROWS.OIV_RATE[bt]");
				evaluate("attributes.row_oiv_amount#bt# = GET_INV_ROWS.OIV_AMOUNT[bt]");
				evaluate("attributes.row_oiv_rate#bt# = GET_INV_ROWS.OIV_RATE[bt]");
				evaluate("attributes.otv_oran#bt# = GET_INV_ROWS.OTV_ORAN[bt]");
				evaluate("attributes.product_id#bt# = GET_INV_ROWS.PRODUCT_ID[bt]");
				evaluate("attributes.row_exp_center_id#bt# = GET_INV_ROWS.ROW_EXP_CENTER_ID[bt]");
				evaluate("attributes.row_exp_item_id#bt# = GET_INV_ROWS.ROW_EXP_ITEM_ID[bt]");
				
				evaluate("attributes.row_nettotal#bt# = GET_INV_ROWS.NETTOTAL[bt]");
				evaluate("attributes.product_name#bt# = GET_INV_ROWS.NAME_PRODUCT[bt]");
				evaluate("attributes.stock_id#bt# = GET_INV_ROWS.STOCK_ID[bt]");
				evaluate("attributes.row_tevkifat_rate#bt# = GET_INV_ROWS.TEVKIFAT_RATE[bt]");
				evaluate("attributes.row_activity_id#bt# = GET_INV_ROWS.ACTIVITY_TYPE_ID[bt]");
				evaluate("attributes.row_subscription_id#bt# = GET_INV_ROWS.SUBSCRIPTION_ID[bt]");
				evaluate("attributes.row_subscription_name#bt# = GET_INV_ROWS.SUBSCRIPTION_ID[bt]");
				
				evaluate("attributes.row_total#bt# = GET_INV_ROWS.PRICE[bt]*GET_INV_ROWS.AMOUNT[bt]");
				evaluate("attributes.other_money_value_#bt# = GET_INV_ROWS.OTHER_MONEY_VALUE[bt]");
				evaluate("attributes.other_money_#bt# = GET_INV_ROWS.OTHER_MONEY[bt]");
				evaluate("attributes.row_project_id#bt#  = GET_INV_ROWS.ROW_PROJECT_ID[bt]");
				evaluate("attributes.row_project_name#bt# = GET_INV_ROWS.ROW_PROJECT_ID[bt]");
				evaluate("attributes.amount#bt# = GET_INV_ROWS.AMOUNT[bt]");
				evaluate("attributes.price#bt# = GET_INV_ROWS.PRICE[bt]");
			}
		
	</cfscript>
	<cfquery name = "get_budget_plan" datasource = "#new_dsn2_group#">
		SELECT * FROM #dsn#.BUDGET_PLAN WHERE INVOICE_ID = #accrual_invoice_id#
	</cfquery>
	<cfset temp_i = i>
	
	<cfinclude template = "invoice_accrual_action.cfm">
	<cfset i = temp_i>
</cfif>

