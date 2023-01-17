<cfif isdefined("attributes.old_process_type")>
    <cfquery name="get_cari_kontrol" datasource="#new_dsn2_group#">
        SELECT DISTINCT PROJECT_ID FROM CARI_ROWS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND ACTION_TYPE_ID = #attributes.old_process_type#
    </cfquery>
</cfif>
<cfscript>
if(isdefined("attributes.old_process_type") and is_row_project_based_cari eq 1 or (is_row_project_based_cari eq 0 and isdefined("get_cari_kontrol") and get_cari_kontrol.recordcount neq 1))
	cari_sil(action_id:attributes.invoice_id,process_type:form.old_process_type,cari_db : new_dsn2_group);
if(is_due_date_based_cari) //Vade ve Döviz Bazında Cari İşlem yapılıyorsa
{
	row_duedate_list='';
	if((form.basket_gross_total-(form.basket_discount_total-form.genel_indirim)) neq 0) //varsa fatura altı indirimin satırlara yansıma oranı bulunuyor
		genel_indirim_yuzdesi = form.genel_indirim / (form.basket_gross_total-(form.basket_discount_total-form.genel_indirim));
	else
		genel_indirim_yuzdesi = 0;

	for(i=1;i lte attributes.rows_;i=i+1)
	{
		if (isdefined("attributes.tevkifat_oran") and len(attributes.tevkifat_oran))
		{
			tmp_row_total_ = evaluate("attributes.row_lasttotal#i#")-(evaluate("attributes.row_taxtotal#i#")*(1-attributes.tevkifat_oran)); //satırdaki kdv nin tevkifat degeri satır toplamından cıkarılıyor
			if(evaluate("attributes.other_money_#i#") is session.ep.money)
				tmp_row_total_other_ = evaluate("attributes.other_money_gross_total#i#")-(evaluate("attributes.row_taxtotal#i#")*(1-attributes.tevkifat_oran));
			else
			{
				row_money_rate=1;
				if(isDefined('attributes.kur_say') and len(attributes.kur_say)) //satırdaki dovizin kur degeri basketten alınıp tevkifatın dovizli tutarı toplamdan cıkarılıyor
					for(tmp_mny=1;tmp_mny lte attributes.kur_say;tmp_mny=tmp_mny+1)
						if(evaluate("attributes.hidden_rd_money_#tmp_mny#") is evaluate("attributes.other_money_#i#"))
							row_money_rate = evaluate('attributes.txt_rate2_#tmp_mny#/attributes.txt_rate1_#tmp_mny#');
				tmp_row_total_other_ = evaluate("attributes.other_money_gross_total#i#")-(((evaluate("attributes.row_taxtotal#i#")*(1-attributes.tevkifat_oran)))/row_money_rate);
			}
		}
		else
		{
			tmp_row_total_ = evaluate("attributes.row_lasttotal#i#");
			tmp_row_total_other_ = evaluate("attributes.other_money_gross_total#i#");
		}
		
		if(len(evaluate("attributes.duedate#i#")) And evaluate("attributes.duedate#i#") Gt 0)
			row_duedate = '#evaluate("attributes.other_money_#i#")#_#evaluate("attributes.duedate#i#")#';
		else
			row_duedate = '#evaluate("attributes.other_money_#i#")#_0';
		if(not listfind(row_duedate_list,row_duedate))
			row_duedate_list = listappend(row_duedate_list,row_duedate);
			
		if(isdefined('duedate_amount_total_#row_duedate#'))
		{
			'duedate_amount_total_#row_duedate#' = evaluate('duedate_amount_total_#row_duedate#')+wrk_round((tmp_row_total_* (1-genel_indirim_yuzdesi)),attributes.basket_price_round_number);
			'duedate_other_amount_total_#row_duedate#' = evaluate('duedate_other_amount_total_#row_duedate#')+wrk_round((tmp_row_total_other_* (1-genel_indirim_yuzdesi)),attributes.basket_price_round_number);
		}
		else
		{
			'duedate_amount_total_#row_duedate#' = wrk_round((tmp_row_total_* (1-genel_indirim_yuzdesi)),attributes.basket_price_round_number);
			'duedate_other_amount_total_#row_duedate#' = wrk_round((tmp_row_total_other_* (1-genel_indirim_yuzdesi)),attributes.basket_price_round_number);
		}
	}
}
else if(is_paymethod_based_cari eq 1) //Ödeme Yöntemi Bazında Cari İşlem yapılıyorsa ve odeme yontemi secilmisse
{
	row_duedate_list='';
	total_cash_price=0;
	if((form.basket_gross_total-(form.basket_discount_total-form.genel_indirim)) neq 0) //varsa fatura altı indirimin satırlara yansıma oranı bulunuyor
		genel_indirim_yuzdesi = form.genel_indirim / (form.basket_gross_total-(form.basket_discount_total-form.genel_indirim));
	else
		genel_indirim_yuzdesi = 0;
	for(i=1;i lte attributes.rows_;i=i+1)
	{
		if(isdefined("attributes.row_paymethod_id#i#") and len(evaluate("attributes.row_paymethod_id#i#")))//satırda ödeme yöntemi varsa
		{
			get_row_paymethod_detail=cfquery(datasource:'#new_dsn2_group#',sqlstring:'SELECT SPD.FIXED_DATE FROM #dsn_alias#.SETUP_PAYMETHOD SP,#dsn_alias#.SETUP_PAYMETHOD_FIXED_DATE SPD WHERE SPD.FIXED_DATE IS NOT NULL AND SP.PAYMETHOD_ID = SPD.PAYMETHOD_ID AND SP.PAYMETHOD_ID =#evaluate("attributes.row_paymethod_id#i#")#');
			if(get_row_paymethod_detail.recordcount and evaluate("attributes.duedate#i#") gt 0)
			{
				for(kk=1;kk lte get_row_paymethod_detail.recordcount;kk=kk+1)
				{
					if (isdefined("attributes.tevkifat_oran") and len(attributes.tevkifat_oran))
					{
						tmp_row_total_ = evaluate("attributes.row_lasttotal#i#")-(evaluate("attributes.row_taxtotal#i#")-(evaluate("attributes.row_taxtotal#i#")*(1-attributes.tevkifat_oran))); //satırdaki kdv nin tevkifat degeri satır toplamından cıkarılıyor
						if(evaluate("attributes.other_money_#i#") is session.ep.money)
							tmp_row_total_other_ = evaluate("attributes.other_money_gross_total#i#")-(evaluate("attributes.row_taxtotal#i#")*(1-attributes.tevkifat_oran));
						else
						{
							row_money_rate=1;
							if(isDefined('attributes.kur_say') and len(attributes.kur_say)) //satırdaki dovizin kur degeri basketten alınıp tevkifatın dovizli tutarı toplamdan cıkarılıyor
								for(tmp_mny=1;tmp_mny lte attributes.kur_say;tmp_mny=tmp_mny+1)
									if(evaluate("attributes.hidden_rd_money_#tmp_mny#") is evaluate("attributes.other_money_#i#"))
										row_money_rate = evaluate('attributes.txt_rate2_#tmp_mny#/attributes.txt_rate1_#tmp_mny#');
							tmp_row_total_other_ = evaluate("attributes.other_money_gross_total#i#")-(((evaluate("attributes.row_taxtotal#i#")*(1-attributes.tevkifat_oran)))/row_money_rate);
						}
					}
					else
					{
						tmp_row_total_ = evaluate("attributes.row_lasttotal#i#");
						tmp_row_total_other_ = evaluate("attributes.other_money_gross_total#i#");
					}
					
					if(len(get_row_paymethod_detail.FIXED_DATE[kk]))
					{
						row_duedate = createodbcdatetime(get_row_paymethod_detail.FIXED_DATE[kk]);

						if(not listfind(row_duedate_list,row_duedate))
							row_duedate_list = listappend(row_duedate_list,row_duedate);
						row_no=listfind(row_duedate_list,row_duedate);
						total_cash_price=total_cash_price+wrk_round((tmp_row_total_* (1-genel_indirim_yuzdesi))/get_row_paymethod_detail.recordcount,attributes.basket_price_round_number);
						
						if(isdefined('row_amount_total_#row_no#'))
						{
							'row_amount_total_#row_no#' = evaluate('row_amount_total_#row_no#')+wrk_round((tmp_row_total_* (1-genel_indirim_yuzdesi))/get_row_paymethod_detail.recordcount,attributes.basket_price_round_number);
							'row_other_amount_total_#row_no#' = evaluate('row_other_amount_total_#row_no#')+wrk_round((tmp_row_total_other_* (1-genel_indirim_yuzdesi))/get_row_paymethod_detail.recordcount,attributes.basket_price_round_number);
						}
						else
						{
							'row_amount_total_#row_no#' = wrk_round((tmp_row_total_* (1-genel_indirim_yuzdesi))/get_row_paymethod_detail.recordcount,attributes.basket_price_round_number);
							'row_other_amount_total_#row_no#' = wrk_round((tmp_row_total_other_* (1-genel_indirim_yuzdesi))/get_row_paymethod_detail.recordcount,attributes.basket_price_round_number);
						}
					}
				}
			}
			else
			{
				get_row_paymethod_detail=cfquery(datasource:'#new_dsn2_group#',sqlstring:'SELECT SP.DUE_DAY FROM #dsn_alias#.SETUP_PAYMETHOD SP WHERE SP.PAYMETHOD_ID =#evaluate("attributes.row_paymethod_id#i#")#');
				if (isdefined("attributes.tevkifat_oran") and len(attributes.tevkifat_oran))
					{
						tmp_row_total_ = evaluate("attributes.row_lasttotal#i#")-(evaluate("attributes.row_taxtotal#i#")-(evaluate("attributes.row_taxtotal#i#")*(1-attributes.tevkifat_oran))); //satırdaki kdv nin tevkifat degeri satır toplamından cıkarılıyor
						if(evaluate("attributes.other_money_#i#") is session.ep.money)
							tmp_row_total_other_ = evaluate("attributes.other_money_gross_total#i#")-(evaluate("attributes.row_taxtotal#i#")-(evaluate("attributes.row_taxtotal#i#")*(1-attributes.tevkifat_oran)));
						else
						{
							row_money_rate=1;
							if(isDefined('attributes.kur_say') and len(attributes.kur_say)) //satırdaki dovizin kur degeri basketten alınıp tevkifatın dovizli tutarı toplamdan cıkarılıyor
								for(tmp_mny=1;tmp_mny lte attributes.kur_say;tmp_mny=tmp_mny+1)
									if(evaluate("attributes.hidden_rd_money_#tmp_mny#") is evaluate("attributes.other_money_#i#"))
										row_money_rate = evaluate('attributes.txt_rate2_#tmp_mny#/attributes.txt_rate1_#tmp_mny#');
							tmp_row_total_other_ = evaluate("attributes.other_money_gross_total#i#")-((evaluate("attributes.row_taxtotal#i#")-(evaluate("attributes.row_taxtotal#i#")*(1-attributes.tevkifat_oran)))/row_money_rate);
						}
					}
					else
					{
						tmp_row_total_ = evaluate("attributes.row_lasttotal#i#");
						tmp_row_total_other_ = evaluate("attributes.other_money_gross_total#i#");
					}
					
					if(len(get_row_paymethod_detail.DUE_DAY))
					{
						row_duedate=date_add("d",get_row_paymethod_detail.DUE_DAY,attributes.invoice_date);
						if(not listfind(row_duedate_list,row_duedate))
							row_duedate_list = listappend(row_duedate_list,row_duedate);
						row_no=listfind(row_duedate_list,row_duedate);
						total_cash_price=total_cash_price+wrk_round((tmp_row_total_* (1-genel_indirim_yuzdesi))/get_row_paymethod_detail.recordcount,attributes.basket_price_round_number);
						
						if(isdefined('row_amount_total_#row_no#'))
						{
							'row_amount_total_#row_no#' = evaluate('row_amount_total_#row_no#')+wrk_round((tmp_row_total_* (1-genel_indirim_yuzdesi))/get_row_paymethod_detail.recordcount,attributes.basket_price_round_number);
							'row_other_amount_total_#row_no#' = evaluate('row_other_amount_total_#row_no#')+wrk_round((tmp_row_total_other_* (1-genel_indirim_yuzdesi))/get_row_paymethod_detail.recordcount,attributes.basket_price_round_number);
						}
						else
						{
							'row_amount_total_#row_no#' = wrk_round((tmp_row_total_* (1-genel_indirim_yuzdesi))/get_row_paymethod_detail.recordcount,attributes.basket_price_round_number);
							'row_other_amount_total_#row_no#' = wrk_round((tmp_row_total_other_* (1-genel_indirim_yuzdesi))/get_row_paymethod_detail.recordcount,attributes.basket_price_round_number);
						}
					}
			}
		}
	}
	if(isdefined('attributes.paymethod_id') and len(attributes.paymethod_id))
	{
		get_paymethod_detail=cfquery(datasource:'#new_dsn2_group#',sqlstring:'SELECT DUE_MONTH,IN_ADVANCE,DUE_START_DAY FROM #dsn_alias#.SETUP_PAYMETHOD WHERE PAYMETHOD_ID =#attributes.paymethod_id#');
		if(get_paymethod_detail.recordcount neq 0)
		{
			if(len(get_paymethod_detail.IN_ADVANCE) and wrk_round((attributes.basket_net_total-total_cash_price),2) gt 0 and get_paymethod_detail.IN_ADVANCE gt 0)
			{
				row_duedate = date_add("d",0,invoice_due_date);
				row_duedate_list = listappend(row_duedate_list,row_duedate);
				total_cash_price_new = (((attributes.basket_net_total-total_cash_price)*get_paymethod_detail.IN_ADVANCE)/100);
				total_cash_price=total_cash_price+total_cash_price_new;
				row_no=listlen(row_duedate_list);
				'row_amount_total_#row_no#' = wrk_round(total_cash_price_new,attributes.basket_price_round_number); //pesinatta vade sıfır
				'row_other_amount_total_#row_no#' = wrk_round((total_cash_price_new/form.basket_rate2),attributes.basket_price_round_number);
			}
			if(wrk_round((attributes.basket_net_total-total_cash_price),2) gt 0) //peşinattan sonra kalan bakiye varsa
			{
				get_row_paymethod_detail_new=cfquery(datasource:'#new_dsn2_group#',sqlstring:'SELECT SPD.FIXED_DATE FROM #dsn_alias#.SETUP_PAYMETHOD SP,#dsn_alias#.SETUP_PAYMETHOD_FIXED_DATE SPD WHERE SPD.FIXED_DATE IS NOT NULL AND SP.PAYMETHOD_ID = SPD.PAYMETHOD_ID AND SP.PAYMETHOD_ID =#attributes.paymethod_id# ORDER BY FIXED_DATE');
				if(get_row_paymethod_detail_new.recordcount)
				{
					installment_price=wrk_round((attributes.basket_net_total-total_cash_price)/get_row_paymethod_detail_new.recordcount,attributes.basket_price_round_number);
					for(kk=1;kk lte get_row_paymethod_detail_new.recordcount;kk=kk+1)
					{
						row_duedate_list = listappend(row_duedate_list,createodbcdatetime(get_row_paymethod_detail_new.FIXED_DATE[kk]));
						row_no=listlen(row_duedate_list);
						'row_amount_total_#row_no#' = wrk_round(installment_price,attributes.basket_price_round_number);
						'row_other_amount_total_#row_no#' = wrk_round((installment_price/form.basket_rate2),attributes.basket_price_round_number);
					}
				}
				else if(len(get_paymethod_detail.DUE_MONTH) and get_paymethod_detail.DUE_MONTH neq 0) //odeme yonteminde taksit sayısı girilmisse
				{
					new_invoice_date=invoice_due_date;
					installment_price=wrk_round((attributes.basket_net_total-total_cash_price)/get_paymethod_detail.DUE_MONTH,attributes.basket_price_round_number);
					for(ind_m=1; ind_m lte get_paymethod_detail.DUE_MONTH; ind_m=ind_m+1)
					{
						if(ind_m eq 1 and len(get_paymethod_detail.DUE_START_DAY) and get_paymethod_detail.DUE_START_DAY neq 0)//vade baslangıc tarihi belirtilmisse ilk taksitte bu deger islem tarihine eklenir
							new_invoice_date=date_add("d",get_paymethod_detail.DUE_START_DAY,new_invoice_date);
						else if(ind_m neq 1) //vade başlangıc tarihi yoksa ilk taksit belgedeki vade başlangıc tarihine kesilir,diger taksitler için tarih birer ay arttırılır
							new_invoice_date=date_add("m",1,new_invoice_date);
							
						row_duedate_list = listappend(row_duedate_list,new_invoice_date);
						row_no=listlen(row_duedate_list);
						'row_amount_total_#row_no#' = wrk_round(installment_price,attributes.basket_price_round_number);
						'row_other_amount_total_#row_no#' = wrk_round((installment_price/form.basket_rate2),attributes.basket_price_round_number);
					}
				 }
			}
		}
	}
}
else if(is_row_project_based_cari eq 1)
{
	row_project_list='';
	total_cash_price=0;
	total_other_cash_price=0;
	row_number = 0;
	row_all_total = 0;
	for(j=1;j lte attributes.rows_;j=j+1)
	{
		row_all_total = row_all_total + evaluate("attributes.row_lasttotal#j#");
	}
	for(j=1;j lte attributes.rows_;j=j+1)
	{
		if(row_all_total gt 0)
			row_total_ = attributes.basket_net_total*evaluate("attributes.row_lasttotal#j#")/row_all_total;
		else
			row_total_ = 0;
		if(isdefined("attributes.row_project_id#j#") and len(evaluate("attributes.row_project_id#j#")) and len(evaluate("attributes.row_project_name#j#")))
		{
			row_number = row_number + 1;
			if(not listfind(row_project_list,evaluate("attributes.row_project_id#j#")))
			{
				row_project_list = listappend(row_project_list,evaluate("attributes.row_project_id#j#"));
				'row_amount_total_#row_number#' = row_total_;
			}
			else
			{
				row_number = listfind(row_project_list,evaluate("attributes.row_project_id#j#"));
				'row_amount_total_#row_number#' = evaluate("row_amount_total_#row_number#")+row_total_;
			}
		}
		else
		{
			total_cash_price = total_cash_price + row_total_;
			total_other_cash_price = total_other_cash_price + evaluate("attributes.other_money_gross_total#j#");
		}	
	}
	for(ind_t=1;ind_t lte listlen(row_project_list); ind_t=ind_t+1)
	{
		cari_row_project=listgetat(row_project_list,ind_t);
		if(isdefined("from_branch_id"))
		{
			carici(
				action_id : attributes.invoice_id,  
				action_table : 'INVOICE',
				workcube_process_type : INVOICE_CAT,
				account_card_type : 13,
				islem_tarihi : attributes.invoice_date,
				due_date : invoice_due_date,
				islem_tutari : evaluate('row_amount_total_#ind_t#'),
				islem_belge_no : FORM.INVOICE_NUMBER,
				from_cmp_id : attributes.company_id,
				from_consumer_id : attributes.consumer_id,
				from_employee_id : attributes.employee_id,
				from_branch_id : from_branch_id,
				islem_detay : DETAIL_,
				acc_type_id : attributes.acc_type_id,
				action_detail : note,
				other_money_value : evaluate('row_amount_total_#ind_t#')/form.basket_rate2,
				other_money : form.basket_money,
				action_currency : iif((isdefined("to_action_currency") and len(to_action_currency)),'to_action_currency','SESSION.EP.MONEY'),//grup ici islemlerde gonderiliyor silmeyiniz
				action_currency_2 : iif(isdefined("to_action_currency_2") and len(to_action_currency_2),'to_action_currency_2','SESSION.EP.MONEY2'),//grup ici islemlerde gonderiliyor silmeyiniz
				currency_multiplier : iif(isdefined("newRateToCompany") and len(newRateToCompany),'newRateToCompany','attributes.currency_multiplier'),//grup ici islemlerde gonderiliyor silmeyiniz
				process_cat : form.process_cat,
				project_id : cari_row_project,
				assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
				rate2:paper_currency_multiplier,
				cari_db : new_dsn2_group
				);
		}
		else
		{
			carici(
				action_id : attributes.invoice_id,
				action_table : 'INVOICE',
				workcube_process_type : INVOICE_CAT,
				account_card_type : 13,
				islem_tarihi : attributes.invoice_date,
				due_date : invoice_due_date,
				islem_tutari : evaluate('row_amount_total_#ind_t#'),
				islem_belge_no : form.invoice_number,
				to_cmp_id : attributes.company_id,
				to_consumer_id : attributes.consumer_id,
				to_employee_id : attributes.employee_id,
				islem_detay : DETAIL_,
				acc_type_id : attributes.acc_type_id,
				action_detail : note,
				to_branch_id : to_branch_id,
				other_money_value : evaluate('row_amount_total_#ind_t#')/form.basket_rate2,
				other_money : form.basket_money,
				action_currency : iif((isdefined("to_action_currency") and len(to_action_currency)),'to_action_currency','SESSION.EP.MONEY'),//grup ici islemlerde gonderiliyor silmeyiniz
				action_currency_2 : iif(isdefined("to_action_currency_2") and len(to_action_currency_2),'to_action_currency_2','SESSION.EP.MONEY2'),//grup ici islemlerde gonderiliyor silmeyiniz
				currency_multiplier : iif(isdefined("newRateToCompany") and len(newRateToCompany),'newRateToCompany','attributes.currency_multiplier'),//grup ici islemlerde gonderiliyor silmeyiniz
				process_cat : form.process_cat,
				project_id : cari_row_project,
				assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
				rate2:paper_currency_multiplier,
				cari_db : new_dsn2_group
				);
		}
	}
	if(total_cash_price gt 0)
	{
		if(isdefined("from_branch_id"))
		{
			carici(
				action_id : attributes.invoice_id,  
				action_table : 'INVOICE',
				workcube_process_type : INVOICE_CAT,
				account_card_type : 13,
				islem_tarihi : attributes.invoice_date,
				due_date : invoice_due_date,
				islem_tutari : total_cash_price,
				islem_belge_no : FORM.INVOICE_NUMBER,
				from_cmp_id : attributes.company_id,
				from_consumer_id : attributes.consumer_id,
				from_employee_id : attributes.employee_id,
				from_branch_id : from_branch_id,
				islem_detay : DETAIL_,
				acc_type_id : attributes.acc_type_id,
				action_detail : note,
				other_money_value : total_cash_price/form.basket_rate2,
				other_money : form.basket_money,
				action_currency : iif((isdefined("to_action_currency") and len(to_action_currency)),'to_action_currency','SESSION.EP.MONEY'),//grup ici islemlerde gonderiliyor silmeyiniz
				action_currency_2 : iif(isdefined("to_action_currency_2") and len(to_action_currency_2),'to_action_currency_2','SESSION.EP.MONEY2'),//grup ici islemlerde gonderiliyor silmeyiniz
				currency_multiplier : iif(isdefined("newRateToCompany") and len(newRateToCompany),'newRateToCompany','attributes.currency_multiplier'),//grup ici islemlerde gonderiliyor silmeyiniz
				process_cat : form.process_cat,
				project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)),'attributes.project_id',de('')),
				assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
				rate2:paper_currency_multiplier,
				cari_db : new_dsn2_group
			);
		}
		else
		{
			carici(
				action_id : attributes.invoice_id,
				action_table : 'INVOICE',
				workcube_process_type : INVOICE_CAT,
				account_card_type : 13,
				islem_tarihi : attributes.invoice_date,
				due_date : invoice_due_date,
				islem_tutari : total_cash_price,
				islem_belge_no : form.invoice_number,
				to_cmp_id : attributes.company_id,
				to_consumer_id : attributes.consumer_id,
				to_employee_id : attributes.employee_id,
				islem_detay : DETAIL_,
				acc_type_id : attributes.acc_type_id,
				action_detail : note,
				to_branch_id : to_branch_id,
				other_money_value : total_cash_price/form.basket_rate2,
				other_money : form.basket_money,
				action_currency : iif((isdefined("to_action_currency") and len(to_action_currency)),'to_action_currency','SESSION.EP.MONEY'),//grup ici islemlerde gonderiliyor silmeyiniz
				action_currency_2 : iif(isdefined("to_action_currency_2") and len(to_action_currency_2),'to_action_currency_2','SESSION.EP.MONEY2'),//grup ici islemlerde gonderiliyor silmeyiniz
				currency_multiplier : iif(isdefined("newRateToCompany") and len(newRateToCompany),'newRateToCompany','attributes.currency_multiplier'),//grup ici islemlerde gonderiliyor silmeyiniz
				process_cat : form.process_cat,
				project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)),'attributes.project_id',de('')),
				assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
				rate2:paper_currency_multiplier,
				cari_db : new_dsn2_group
			);
		}
	}
}
</cfscript>
