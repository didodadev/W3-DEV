<cfscript>
	if(is_cari eq 1){ //fatura cari
		carici(
				action_id : get_invoice_id.max_id,  
				action_table : 'INVOICE',
				workcube_process_type : INVOICE_CAT,
				account_card_type : 13,
				islem_tarihi : attributes.invoice_date,
				islem_tutari : get_invoice.NETTOTAL ,
				islem_belge_no : get_invoice.INVOICE_NUMBER,
				from_cmp_id : attributes.company_id,
				from_branch_id : ListGetAt(session.ep.user_location,2,"-"),
				islem_detay : get_invoice.NOTE,
				action_detail : get_invoice.NOTE,
				other_money_value : get_invoice.NETTOTAL/get_invoice.OTHER_MONEY_VALUE,
				other_money : get_invoice.OTHER_MONEY,
				action_currency : SESSION.EP.MONEY,
				process_cat : form.process_cat,
				cari_db:new_dsn2,
				period_is_integrated:new_period_is_integrated
			);
		}

	if(is_account eq 1)  //fatura muhasebe
	{
		DETAIL_1 = DETAIL_ & ' GİRİŞ İŞLEMİ';
		str_borclu_hesaplar = '' ;
		str_borclu_tutarlar = '' ;
		str_alacakli_hesaplar = '' ;
		str_alacakli_tutarlar = '' ;
		genel_indirim_yuzdesi = 1 - (get_invoice.SA_DISCOUNT / (get_invoice.GROSSTOTAL-(attributes.basket_discount_total-get_invoice.SA_DISCOUNT)));
		for(i=1;i lte get_invoice_row.recordcount ;i=i+1){
			int_dis = (100-get_invoice_row.DISCOUNT1[i])*(100-get_invoice_row.DISCOUNT2[i])*(100-get_invoice_row.DISCOUNT3[i]);
			int_dis = int_dis*(100-get_invoice_row.DISCOUNT4[i])*(100-get_invoice_row.DISCOUNT5[i])*(100-get_invoice_row.DISCOUNT6[i]);
			int_dis = int_dis*(100-get_invoice_row.DISCOUNT7[i])*	(100-get_invoice_row.DISCOUNT8[i])*	(100-get_invoice_row.DISCOUNT9[i])*(100-get_invoice_row.DISCOUNT10[i]);
			if(100000000000000000000 neq int_dis)
				row_total = 100000000000000000000*get_invoice_row.NETTOTAL[i]/(100000000000000000000-int_dis);
			else
				row_total = get_invoice_row.NETTOTAL[i];
			product_account_codes = get_product_account(prod_id:get_invoice_row.product_id[i],product_alias_db:new_dsn3_alias,product_account_db:new_dsn2);
			if(len(product_account_codes.ACCOUNT_CODE_PUR)){
				if(listfind('54,55',invoice_cat,','))// Toptan Satis İade veya Perakende Satis İade oldugu icin Urunun Satis İade Hesabi Secilir
					product_account_code = product_account_codes.ACCOUNT_IADE ;
				else // 59 ise Mal Alim veya Hizmet Alim Faturasi ise
					product_account_code = product_account_codes.ACCOUNT_CODE_PUR ;
				str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_code, ",");
				str_borclu_tutarlar = ListAppend(str_borclu_tutarlar, wrk_round(row_total), ",");
				}
			urun_toplam_indirim = row_total-get_invoice_row.NETTOTAL[i];
			if(get_invoice.SA_DISCOUNT gt 0) //genel indirim 0 dan farkli ise indirim duzeltmesi
				urun_toplam_indirim = urun_toplam_indirim + (get_invoice_row.NETTOTAL[i]*(1-genel_indirim_yuzdesi));
			urun_toplam_indirim = wrk_round(urun_toplam_indirim);
			if(urun_toplam_indirim gt 0 and len(product_account_codes.ACCOUNT_DISCOUNT_PUR))
				{ //urune ait alis indirim hesabina
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.ACCOUNT_DISCOUNT_PUR, ",");
					str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar, urun_toplam_indirim, ",");
				}
			else if(urun_toplam_indirim gt 0 and (not len(product_account_codes.ACCOUNT_DISCOUNT_PUR)))
				{ //urune ait indirim hesabi yoksa genel indirim hesabina
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, GET_NO_.A_DISC, ",");
					str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar, urun_toplam_indirim, ",");
				}
			}
		for (i=1;i lte attributes.basket_tax_count;i=i+1){
			for (j=1;j lte get_taxes.recordcount;j=j+1){
				if(get_taxes.tax[j] eq get_invoice_row.TAX[i]){
					if(Listfind('54,55',invoice_cat))
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, get_taxes.sale_code_iade[j], ",");
					else
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, get_taxes.purchase_code[j], ",");
						str_borclu_tutarlar = ListAppend(str_borclu_tutarlar, wrk_round(get_invoice_row.TAXTOTAL[i]), ",");
					}
				}
			}
		str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, acc, ",");
		str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar, wrk_round(GET_INVOICE.NETTOTAL), ",");
		/*
		if(len(attributes.yuvarlama) and attributes.yuvarlama lt 0){
			str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, hesap_yuvarlama, ",");
			str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar, abs(attributes.yuvarlama), ",");
		}else if(len(attributes.yuvarlama) and attributes.yuvarlama gt 0){
			str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, hesap_yuvarlama, ",");
			str_borclu_tutarlar = ListAppend(str_borclu_tutarlar, abs(attributes.yuvarlama), ",");
		}*/
		muhasebeci(
			action_id : get_invoice_id.max_id,
			workcube_process_type : INVOICE_CAT,
			workcube_process_cat : form.process_cat,
			account_card_type : 13,
			islem_tarihi : attributes.invoice_date,
			borc_hesaplar : str_borclu_hesaplar,
			borc_tutarlar : str_borclu_tutarlar,
			alacak_hesaplar : str_alacakli_hesaplar,
			alacak_tutarlar : str_alacakli_tutarlar,
			fis_detay : '#DETAIL_1#',
			fis_satir_detay : '#dateformat(attributes.invoice_date,"dd/mm/yyyy")# TARİH #get_invoice.invoice_number# FATURA',
			belge_no : get_invoice.invoice_number,
			muhasebe_db:new_dsn2,
			is_account_group : is_account_group
		);
	}
</cfscript>

<cfquery name="UPD_INVOICE_ACC" datasource="#new_dsn2#">
	UPDATE INVOICE SET IS_PROCESSED = #is_account# WHERE INVOICE_ID=#get_invoice_id.max_id#
</cfquery>
