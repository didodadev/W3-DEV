<cfscript> 
	if(isdefined('attributes.branch_id') and len(attributes.branch_id) )
		to_branch_id = attributes.branch_id;
	else
		to_branch_id = ListGetAt(session.ep.user_location,2,"-");
	if(is_account eq 1)  //fatura muhasebe
	{	
		DETAIL_1 = 'Z RAPORU GİRİŞ İŞLEMİ';
		genel_fis_satir_detay = '#form.invoice_number# Z RAPORU';
		satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar. satir_detay_list[1]'a  borc yazan satırların acıklamaları, satir_detay_list[2]'a alacak yazan satırların acıklamaları set edilir. 
		str_borclu_hesaplar = '' ;
		str_borclu_tutarlar = '' ;
		str_dovizli_borclar = '' ;
		str_alacakli_hesaplar = '' ;
		str_alacakli_tutarlar = '' ;
		str_dovizli_alacaklar = '' ;
		str_other_currency_alacak = '';
		str_other_currency_borc = '';
		str_alacak_miktar = ArrayNew(1);
		str_alacak_tutar = ArrayNew(1) ;
		product_account_code ='';	
		if((form.basket_gross_total-(form.basket_discount_total-form.genel_indirim)) neq 0)
			genel_indirim_yuzdesi = form.genel_indirim / (form.basket_gross_total-(form.basket_discount_total-form.genel_indirim));
		else
			genel_indirim_yuzdesi = 0;
		for(i=1;i lte attributes.rows_;i=i+1){
			product_account_codes = get_product_account(prod_id:evaluate("attributes.product_id#i#"));
			urun_toplam_indirim = (evaluate("attributes.row_total#i#")-evaluate("attributes.row_nettotal#i#"));
			product_account_code = product_account_codes.ACCOUNT_CODE ;
			str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,product_account_code,",");
			str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,evaluate("attributes.row_total#i#"),",");
			if( urun_toplam_indirim gt 0 and len(form.basket_money))
			{
				str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,(evaluate("attributes.row_total#i#")*form.basket_rate1/form.basket_rate2),",");
				str_other_currency_alacak = ListAppend(str_other_currency_alacak,form.basket_money,",");
			}
			else if( isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#")) )
			{
				str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,evaluate("attributes.other_money_value_#i#"),",");
				str_other_currency_alacak = ListAppend(str_other_currency_alacak,evaluate("attributes.other_money_#i#"),",");
			}
			else
			{
				str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,evaluate("attributes.row_total#i#"),",");
				str_other_currency_alacak = ListAppend(str_other_currency_alacak,session.ep.money,",");
			}
			str_alacak_miktar[listlen(str_alacakli_tutarlar)] = '#evaluate("attributes.amount#i#")#';
			str_alacak_tutar[listlen(str_alacakli_tutarlar)] = '#evaluate("attributes.price#i#")#'; 
			if(is_account_group neq 1) //hesap bazında gruplama yapılıyorsa satır acıklamalarını degil genel fis bilgisini yazıyoruz
				satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#evaluate("attributes.product_name#i#")#';
			else
				satir_detay_list[2][listlen(str_alacakli_tutarlar)]=genel_fis_satir_detay;
			if(form.genel_indirim gt 0) //genel indirim 0 dan farkli ise indirim duzeltmesi
				urun_toplam_indirim = urun_toplam_indirim + (evaluate("attributes.row_nettotal#i#") * genel_indirim_yuzdesi);
			if(urun_toplam_indirim gt 0)
				{ //urune ait satis indirim hesabina
				if(len(product_account_codes.ACCOUNT_DISCOUNT))
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,product_account_codes.ACCOUNT_DISCOUNT,",");
				else
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,GET_NO_.A_DISC,",");					
				str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,urun_toplam_indirim,",");
				str_dovizli_borclar = ListAppend(str_dovizli_borclar,urun_toplam_indirim,",");
				str_other_currency_borc = ListAppend(str_other_currency_borc,session.ep.money,",");
				satir_detay_list[1][listlen(str_borclu_tutarlar)]=genel_fis_satir_detay;
				}
			}
		for (i=1;i lte form.basket_tax_count;i=i+1){
			for (j=1;j lte get_taxes.recordcount;j=j+1){
				if(get_taxes.tax[j] eq evaluate("form.basket_tax_#i#"))
				{
					if(evaluate("form.basket_tax_value_#i#") neq 0)
					{
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, get_taxes.sale_code[j], ",");
						str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar, evaluate("form.basket_tax_value_#i#"), ",");
						str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar, (evaluate("form.basket_tax_value_#i#")*form.basket_rate1/form.basket_rate2), ",");
						str_other_currency_alacak = ListAppend(str_other_currency_alacak,form.basket_money,",");
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]=genel_fis_satir_detay;
					}
				}
			}
		}
		if(isdefined("attributes.is_cash") and (form.is_cash eq 1))
		{
			for (k=1;k lte kur_say;k=k+1)
			{
			  if(isdefined("kasa#k#") and isdefined("cash_amount#k#") and (evaluate('cash_amount#k#') gt 0))
				{
					GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"SELECT CASH_ACC_CODE FROM CASH WHERE CASH_ID=#evaluate('kasa#k#')#");
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,GET_ACC_CODE.CASH_ACC_CODE,",");
					str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,evaluate('system_cash_amount#k#'),",");
					str_dovizli_borclar = ListAppend(str_dovizli_borclar,(evaluate('system_cash_amount#k#')*form.basket_rate1/form.basket_rate2),",");
					str_other_currency_borc = ListAppend(str_other_currency_borc,form.basket_money,",");
					satir_detay_list[1][listlen(str_borclu_tutarlar)]=genel_fis_satir_detay;
				}
			}
		 }
		 if(isdefined("attributes.is_pos") and len(attributes.is_pos) and isdefined("attributes.record_num2"))
		{
			for (k=1;k lte attributes.record_num2;k=k+1)
			{
			  if(evaluate('attributes.row_kontrol_2#k#') and evaluate('attributes.pos_amount_#k#') gt 0)
				{
					GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"SELECT ACCOUNT_CODE FROM #dsn3_alias#.CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID=#listgetat(evaluate('attributes.POS_#k#'),3,';')#");
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,GET_ACC_CODE.ACCOUNT_CODE,",");
					str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,evaluate('system_pos_amount_#k#'),",");
					str_dovizli_borclar = ListAppend(str_dovizli_borclar,(evaluate('system_pos_amount_#k#')*form.basket_rate1/form.basket_rate2),",");
					str_other_currency_borc = ListAppend(str_other_currency_borc,form.basket_money,",");
					satir_detay_list[1][listlen(str_borclu_tutarlar)]=genel_fis_satir_detay;
				}
			}
		 }
		if(attributes.total_diff_amount neq 0 and isdefined("attributes.expense_item_id") and Len(attributes.expense_item_id))
		 {	
		 	GET_ITEM_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID=#attributes.expense_item_id#");
			if(attributes.total_diff_amount gt 0)
			{
				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,GET_ITEM_ACC_CODE.ACCOUNT_CODE,",");
				str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,abs(attributes.total_diff_amount),",");
				str_dovizli_borclar = ListAppend(str_dovizli_borclar,(abs(attributes.total_diff_amount)*form.basket_rate1/form.basket_rate2),",");
				str_other_currency_borc = ListAppend(str_other_currency_borc,form.basket_money,",");
				satir_detay_list[1][listlen(str_borclu_tutarlar)]=genel_fis_satir_detay;
			}
			else
			{
				str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,GET_ITEM_ACC_CODE.ACCOUNT_CODE, ",");
				str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,abs(attributes.total_diff_amount), ",");
				str_dovizli_alacaklar = ListAppend(str_dovizli_alacaklar,(abs(attributes.total_diff_amount)*form.basket_rate1/form.basket_rate2), ",");
				str_other_currency_alacak = ListAppend(str_other_currency_alacak,form.basket_money,",");
				satir_detay_list[2][listlen(str_alacakli_tutarlar)]=genel_fis_satir_detay;
			}
		 }
		//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
		str_fark_gelir =GET_NO_.FARK_GELIR;
		str_fark_gider =GET_NO_.FARK_GIDER;
		str_max_round = 0.09;
		str_round_detail = genel_fis_satir_detay;
		muhasebeci(
			wrk_id='#wrk_id#',
			action_id : get_invoice_id.max_id,
			workcube_process_type : INVOICE_CAT,
			workcube_process_cat: process_cat,
			account_card_type : 13,
			islem_tarihi : attributes.invoice_date,
			borc_hesaplar : str_borclu_hesaplar,
			borc_tutarlar : str_borclu_tutarlar,
			other_amount_borc : str_dovizli_borclar,
			other_currency_borc : str_other_currency_borc,
			alacak_hesaplar : str_alacakli_hesaplar,
			alacak_tutarlar : str_alacakli_tutarlar,
			other_amount_alacak : str_dovizli_alacaklar,
			other_currency_alacak :str_other_currency_alacak,
			alacak_miktarlar : str_alacak_miktar,
			alacak_birim_tutar : str_alacak_tutar,
			to_branch_id :iif(len(to_branch_id),de('#to_branch_id#'),de('')),
			fis_detay : "#DETAIL_1#",
			fis_satir_detay : satir_detay_list,
			belge_no : form.invoice_number,
			is_account_group : is_account_group,
			dept_round_account :str_fark_gider,
			claim_round_account : str_fark_gelir,
			max_round_amount :str_max_round,
			round_row_detail:str_round_detail,
			currency_multiplier : attributes.currency_multiplier
		);
	}
	if(is_budget eq 1)
	{
		if(attributes.total_diff_amount lt 0)
		{
			butceci(
				action_id : get_invoice_id.max_id,
				muhasebe_db : dsn2,
				is_income_expense : true,
				process_type : INVOICE_CAT,
				nettotal : abs(attributes.total_diff_amount),
				other_money_value : abs(attributes.total_diff_amount)*form.basket_rate1/form.basket_rate2,
				action_currency : form.basket_money,
				currency_multiplier : attributes.currency_multiplier,
				expense_date : attributes.invoice_date,
				expense_center_id : attributes.expense_center_id,
				expense_item_id : attributes.expense_item_id,
				detail : '#form.invoice_number# - Z RAPORU KASA FAZLASI',
				paper_no : form.invoice_number,
				branch_id : to_branch_id,
				insert_type : 1
			);
		}
		else if(attributes.total_diff_amount gt 0)
		{
			butceci(
				action_id : get_invoice_id.max_id,
				muhasebe_db : dsn2,
				is_income_expense : false,
				process_type : INVOICE_CAT,
				nettotal : abs(attributes.total_diff_amount),
				other_money_value : abs(attributes.total_diff_amount)*form.basket_rate1/form.basket_rate2,
				action_currency : form.basket_money,
				currency_multiplier : attributes.currency_multiplier,
				expense_date : attributes.invoice_date,
				expense_center_id : attributes.expense_center_id,
				expense_item_id : attributes.expense_item_id,
				detail : '#form.invoice_number# - Z RAPORU KASA EKSİĞİ',
				paper_no : form.invoice_number,
				branch_id : to_branch_id,
				insert_type : 1
			);
		}
	}
</cfscript>
<cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
	UPDATE INVOICE SET IS_PROCESSED = #is_account# WHERE INVOICE_ID = #get_invoice_id.max_id#
</cfquery>
