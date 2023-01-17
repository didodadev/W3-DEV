<cfscript>
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
</cfscript>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfloop from="1" to="#listlen(row_duedate_list)#" index="ind_t">
		<cfquery name="add_invoice_payment_plan" datasource="#dsn2#">
			INSERT INTO
				#dsn3_alias#.INVOICE_PAYMENT_PLAN
			(
				INVOICE_ID,
				PERIOD_ID,
				COMPANY_ID,
				INVOICE_NUMBER,
				ACTION_DETAIL,
				INVOICE_DATE,
				DUE_DATE,
				ACTION_VALUE,
				OTHER_ACTION_VALUE,
				PAYMENT_VALUE,
				OTHER_MONEY,
				PAYMENT_METHOD_ROW,
				IS_ACTIVE,
				IS_BANK,
				IS_BANK_IPTAL,
				IS_PAID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				#get_invoice_id.max_id#,
				#session.ep.period_id#,
				#attributes.company_id#,
				<cfif len(form.invoice_number)>'#form.invoice_number#'<cfelse>NULL</cfif>,
				<cfif len(form.invoice_number)>'#form.invoice_number#'<cfelse>NULL</cfif>,
				<cfif len(attributes.invoice_date)>#attributes.invoice_date#<cfelse>NULL</cfif>,
				<cfif len(listgetat(row_duedate_list,ind_t))>#listgetat(row_duedate_list,ind_t)#<cfelse>NULL</cfif>,
				#evaluate("row_amount_total_#ind_t#")#,
				#evaluate("row_other_amount_total_#ind_t#")#,
				#evaluate("row_other_amount_total_#ind_t#")#,
				'#form.basket_money#',
				<cfif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
				1,
				0,
				0,
				0,
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#'
			)
		</cfquery>
	</cfloop>
	<cfquery name="get_invoice_payment_rows" datasource="#dsn2#">
		SELECT DUE_DATE,ACTION_VALUE, datediff(d,getdate(),DUE_DATE) as VADE_FARKI FROM #dsn3_alias#.INVOICE_PAYMENT_PLAN WHERE INVOICE_ID = #get_invoice_id.max_id# AND PERIOD_ID = #session.ep.period_id#
	</cfquery>
	<cfif get_invoice_payment_rows.recordcount and is_paymethod_based_cari eq 0>
		<cfset total_day = 0>
		<cfset total_value = 0>
		<cfloop query="get_invoice_payment_rows">
			<cfset total_day = total_day + VADE_FARKI * ACTION_VALUE>
			<cfset total_value = total_value + ACTION_VALUE>
		</cfloop>
        <cfset avg_duedate_new = dateformat(dateadd('d',total_day/total_value,now()),dateformat_style)>
        <cf_date tarih='avg_duedate_new'>
		<cfquery name="upd_cari_rows" datasource="#dsn2#">
			UPDATE CARI_ROWS SET DUE_DATE = #avg_duedate_new# WHERE ACTION_ID = #get_invoice_id.max_id# AND PROCESS_CAT = #form.process_cat#
		</cfquery>
	</cfif>
</cfif>

