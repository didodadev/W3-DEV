<cfscript>
if(is_paymethod_based_cari eq 1 and isdefined('attributes.paymethod_id') and len(attributes.paymethod_id)) //Ödeme Yöntemi Bazında Cari İşlem yapılıyorsa ve odeme yontemi secilmisse
{
	row_duedate_list='';
	total_cash_price=0;
	get_paymethod_detail=cfquery(datasource:'#dsn2#',sqlstring:'SELECT DUE_MONTH,IN_ADVANCE,DUE_START_DAY,DUE_START_MONTH FROM #dsn_alias#.SETUP_PAYMETHOD WHERE PAYMETHOD_ID =#attributes.paymethod_id#');
	if(get_paymethod_detail.recordcount neq 0)
	{
		if(len(get_paymethod_detail.IN_ADVANCE))
		{
			row_duedate = date_add("d",0,invoice_due_date);
			row_duedate_list = listappend(row_duedate_list,row_duedate);
			total_cash_price=((attributes.net_total_amount*get_paymethod_detail.IN_ADVANCE)/100);
			row_no=listlen(row_duedate_list);
			'row_amount_total_#row_no#' = wrk_round(total_cash_price); //pesinatta vade sıfır
			'row_other_amount_total_#row_no#' = wrk_round(total_cash_price/paper_currency_multiplier);
		}
		if(wrk_round(attributes.net_total_amount-total_cash_price) gt 0) //peşinattan sonra kalan bakiye varsa
		{
			 if(len(get_paymethod_detail.DUE_MONTH) and get_paymethod_detail.DUE_MONTH neq 0) //odeme yonteminde taksit sayısı girilmisse
			 {
				if(len(invoice_due_date))
					new_invoice_date=invoice_due_date;
				else
					new_invoice_date=attributes.invoice_date;
				installment_price=wrk_round((attributes.net_total_amount-total_cash_price)/get_paymethod_detail.DUE_MONTH);
			 	for(ind_m=1; ind_m lte get_paymethod_detail.DUE_MONTH; ind_m=ind_m+1)
				{
					if(ind_m eq 1 and len(get_paymethod_detail.DUE_START_DAY) and get_paymethod_detail.DUE_START_DAY neq 0)//vade baslangıc tarihi belirtilmisse ilk taksitte bu deger islem tarihine eklenir
						new_invoice_date=date_add("d",get_paymethod_detail.DUE_START_DAY,new_invoice_date);
					else if(ind_m neq 1)//vade başlangıc tarihi yoksa ilk taksit belgedeki vade başlangıc tarihine kesilir,diger taksitler için tarih birer ay arttırılır
						new_invoice_date=date_add("m",1,new_invoice_date);
						
					row_duedate_list = listappend(row_duedate_list,new_invoice_date);
					row_no=listlen(row_duedate_list);
					'row_amount_total_#row_no#' = wrk_round(installment_price);
					'row_other_amount_total_#row_no#' = wrk_round(installment_price/paper_currency_multiplier);
				}
			 }
		}
	}
}
</cfscript>

