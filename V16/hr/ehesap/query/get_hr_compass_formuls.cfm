<cfscript>
if(get_hr_ssk.IS_DAMGA_FREE eq 1 and is_yearly_offtime eq 0 and is_net_payment eq 0)// damga vergisinden muaf ve yıllık izin vergisinden muafsa
	damga_carpani = 0;
else
	damga_carpani = get_active_program_parameter.STAMP_TAX_BINDE;

if (get_hr_ssk.SSK_STATUTE eq 2 || get_hr_ssk.SSK_STATUTE eq 18) // emekli ise
{
	ssk_isci_hissesi = 0;
	issizlik_isci_hissesi = 0;
	
	// ucretin brutunun sskmatrahla karsilastiralbilmesi icin oncelikle ucretin direk brutu bulunup bir tempe atilir ve bulunan temp_brut ssk matrahlar ile karsilastirilir. YO15122005
	temp_brut = sal_temp - ((sakatlik_indirimi + vergi_istisna) * tax_ratio);
	temp_a = 1 - (ssk_isci_carpan/100);
	salary_brut_temp = temp_brut / (temp_a - (temp_a*tax_ratio) - (damga_carpani / 1000));
	

	if (salary_brut_temp gt ssk_matrah_tavan)
		{
		ssdf_isci_hissesi = wrk_round((ssk_matrah_tavan/100) * ssk_isci_carpan);
		brut = salary + ssdf_isci_hissesi - ((ssdf_isci_hissesi) * tax_ratio) - ((sakatlik_indirimi + vergi_istisna) * tax_ratio);
		salary = brut / (1 - (damga_carpani / 1000) - tax_ratio);
		
		bes_isci_hissesi = fix((ssk_matrah_tavan/100) * bes_isci_carpan);
		}
	else if (salary_brut_temp lt ssk_matrah_taban)
	{
		ssdf_isci_hissesi = wrk_round((ssk_matrah_taban/100) * ssk_isci_carpan);
		brut = salary + ssdf_isci_hissesi - ((ssdf_isci_hissesi + (sakatlik_indirimi + vergi_istisna)) * tax_ratio);
		a = 1 - (ssk_isci_carpan/100);
		salary = brut / (a - (damga_carpani / 1000));
		
		bes_isci_hissesi = fix((ssk_matrah_taban/100) * bes_isci_carpan);
	}
	else
	{
		ssdf_isci_hissesi = wrk_round((salary/100) * ssk_isci_carpan);
		brut = salary - ((sakatlik_indirimi + vergi_istisna) * tax_ratio);
		a = 1 - (ssk_isci_carpan/100);
		salary = brut / (a - (a*tax_ratio) - (damga_carpani / 1000));
		
		bes_isci_hissesi = fix((salary/100) * bes_isci_carpan);
	}

}
else // emekli değil ise
	// ucretin brutunun sskmatrahla karsilastiralbilmesi icin oncelikle ucretin direk brutu bulunup bir tempe atilir ve bulunan temp_brut ssk matrahlar ile karsilastirilir. YO15122005
{
	temp_brut = sal_temp - ((sakatlik_indirimi + vergi_istisna) * tax_ratio);
	temp_a = 1 - ((issizlik_isci_carpan + ssk_isci_carpan)/100);
	salary_brut_temp = temp_brut / (temp_a - (temp_a*tax_ratio) - (damga_carpani / 1000));
	if ((salary_brut_temp + devir_matrah_) gt ssk_matrah_tavan)
	{
		bes_isci_hissesi = fix((ssk_matrah_tavan/100) * bes_isci_carpan);
		ssk_isci_hissesi = wrk_round((ssk_matrah_tavan/100) * ssk_isci_carpan);
		issizlik_isci_hissesi = wrk_round((ssk_matrah_tavan/100) * issizlik_isci_carpan);
		brut = salary + (bes_isci_hissesi+ssk_isci_hissesi+issizlik_isci_hissesi) - ((bes_isci_hissesi+ssk_isci_hissesi+issizlik_isci_hissesi) * tax_ratio) - ((sakatlik_indirimi + vergi_istisna) * tax_ratio);
		salary = brut / (1 - (damga_carpani / 1000) - tax_ratio);
	}
	else if((salary_brut_temp + devir_matrah_) lt ssk_matrah_taban)
	{
		bes_isci_hissesi = fix((ssk_matrah_taban/100) * bes_isci_carpan);
		ssk_isci_hissesi = wrk_round((ssk_matrah_taban/100) * ssk_isci_carpan);
		issizlik_isci_hissesi = wrk_round((ssk_matrah_taban/100) * issizlik_isci_carpan);
		brut = salary + (bes_isci_hissesi + ssk_isci_hissesi+issizlik_isci_hissesi) - ((bes_isci_hissesi + ssk_isci_hissesi + issizlik_isci_hissesi + sakatlik_indirimi + vergi_istisna) * tax_ratio);
		a = 1 - ((issizlik_isci_carpan + ssk_isci_carpan)/100);
		salary = brut / (a - (damga_carpani / 1000));
	}
	else
	{
		ssk_isci_hissesi = wrk_round((salary/100) * ssk_isci_carpan);
		issizlik_isci_hissesi = wrk_round((salary/100) * issizlik_isci_carpan);
		brut = salary - ((sakatlik_indirimi + vergi_istisna) * tax_ratio);
		a = 1 - ((issizlik_isci_carpan + ssk_isci_carpan)/100);
		/*
		writeoutput("<br><br>#ssk_isci_hissesi# = wrk_round((#salary#/100) * #ssk_isci_carpan#)<br>");
		writeoutput("#issizlik_isci_hissesi# = wrk_round((#salary#/100) * #issizlik_isci_carpan#) <br>");
		writeoutput("#brut# = #salary# - ((#sakatlik_indirimi# + #vergi_istisna#) * #tax_ratio#) <br>");
		writeoutput("#a# = 1 - ((#issizlik_isci_carpan# + #ssk_isci_carpan#)/100)<br>");
		
		writeoutput("salary_brut_temp:#salary_brut_temp#<br>");
		writeoutput("brut:#brut#<br>");
		writeoutput("a:#a#<br>");
		writeoutput("damga_carpani:#damga_carpani#<br>");
		writeoutput("tax_ratio:#tax_ratio#<br>");
		writeoutput("salary:#salary#<br>");
		*/
		salary = brut / (a - (a*tax_ratio) - (damga_carpani / 1000));		
		bes_isci_hissesi = fix((salary/100) * bes_isci_carpan);
	}
	salary = wrk_round(salary);
}
</cfscript>
