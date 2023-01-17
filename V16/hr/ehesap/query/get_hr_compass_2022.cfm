<!--- 
    2022 den büyükse ve Asgari Ücret Vergi İndiriminden Yararlanıyorsa kullanılan vergi indiriminden ne kadar yararlanacağını hesaplıyor
	01022022ERU
	first_salary_temp : maaştan gelen değer
	temp_daily_minimum_wage : maaş matrahı
	is_included_in_tax_hour_paid : çalışan dv ve gvden muaf ücretli ve dv gv dahil izini varsa 
--->
<cfscript>
	if(use_minimum_wage neq 1 and get_active_program_parameter.is_use_minimum_wage neq 1 and year(last_month_1) gte 2022)
	{
        if(total_used_stamp_tax gte temp_stamp_tax_base  and wrk_round(total_used_stamp_tax-temp_stamp_tax_base) gt 0.01)
				total_used_stamp_tax = total_used_stamp_tax - temp_stamp_tax_base;
			else
				total_used_stamp_tax = 0;
        
        if(first_salary_temp lt temp_daily_minimum_wage or is_included_in_tax_hour_paid eq 1 or (get_hr_ssk.IS_DAMGA_FREE eq 1 and total_used_stamp_tax gte temp_stamp_tax_base))
		{
            //Eğer ilk defa giriyorsa max alabilceği gv indirim tutarı
			if(count_2022 eq 0)
			{
				if (isDefined("tax_ratio_daily") and len(tax_ratio_daily))
                {
                    tax_ratio_daily = tax_ratio_daily;
                }else
                {
                    tax_ratio_daily = tax_carpan;
                    v1 = tax_carpan;
                }
				max_daily_minimum_income_tax = temp_daily_minimum_wage_base * tax_ratio_daily;
                first_max_daily_minimum_income_tax = temp_daily_minimum_wage_base * tax_ratio_daily;
			}
			
			//Matrahtan ne kadar kullanıyorsa geriye kalan
			if((total_used_incoming_tax gte temp_gelir_vergisi_matrah and tax_carpan eq v1) or(total_used_incoming_tax gte temp_gelir_vergisi_matrah and tax_carpan gt v1 and gelir_vergisi eq 0) or max_daily_minimum_income_tax gt 0)
			{
                total_used_incoming_tax = (total_used_incoming_tax) - (temp_gelir_vergisi_matrah);
				if(first_max_daily_minimum_income_tax gte income_tax_temp)
                {
                    max_daily_minimum_income_tax = wrk_round(first_max_daily_minimum_income_tax - income_tax_temp);
				}
			}
			else
            {
                total_used_incoming_tax = 0;
				max_daily_minimum_income_tax = 0;
			}		
				
			//Matrahtan ne kadar kullanıyorsa geriye kalanı aktarıyor. Ama tamamnını kullanmışsa diğerlerinden düşmesin diye atandı
			if(first_exemption eq 0 and total_used_incoming_tax - sakatlik_indirimi gt 0)
			{
                if(daily_minimum_wage_base eq total_used_incoming_tax)
                    daily_minimum_wage_base = 0;
                else
                    daily_minimum_wage_base = wrk_round(total_used_incoming_tax - sakatlik_indirimi);
                
                if(daily_minimum_wage_base eq 0.01)
                    daily_minimum_wage_base = 0;
                
                   first_exemption = 1;
			}
			else if(first_exemption eq 0 and total_used_incoming_tax gt 0 and total_used_incoming_tax - sakatlik_indirimi lt 0 and sakatlik_indirimi gt 0 and salary gte daily_minimum_wage)
			{
				daily_minimum_wage_base = 0;
				first_exemption = 1;
			}
			else if(first_exemption eq 0 and total_used_incoming_tax gt 0 and total_used_incoming_tax - sakatlik_indirimi lt 0 and sakatlik_indirimi gt 0 and salary lt daily_minimum_wage)//ücret asgariden düşükse ve engelliliği varsa ve ek ödeneği varsa
			{
				daily_minimum_wage_base = total_used_incoming_tax;
				first_exemption = 1;
				used_daily_disabled = 1;
			}
			else if(first_exemption eq 1 and used_daily_disabled eq 1)//bütün indrim kullanıldıysa
			{
				daily_minimum_wage_base = 0;
			}
			else 
			{
				daily_minimum_wage_base = total_used_incoming_tax;
			}
			
			daily_minimum_wage_stamp_tax = (total_used_stamp_tax * get_active_program_parameter.STAMP_TAX_BINDE) / 1000; 
		}
		else if(is_yearly_offtime eq 0 and is_tax_free_from_payment eq 0) 
        {
			daily_minimum_wage_base = 0;
			daily_minimum_wage_stamp_tax = 0;
            max_daily_minimum_income_tax = 0;
		}

        daily_minimum_wage_base = wrk_round(daily_minimum_wage_base);
		count_2022++;
	}
    //abort("max_daily_minimum_income_tax: #max_daily_minimum_income_tax#");
</cfscript>
<!--- <cfoutput>
	<br><br>daily_minimum_wage_stamp_tax : #daily_minimum_wage_stamp_tax# <br>
	daily_minimum_wage_base : #daily_minimum_wage_base# <br>
	total_used_stamp_tax : #total_used_stamp_tax# <br>
	temp_gelir_vergisi_matrah : #temp_gelir_vergisi_matrah#<br>
	gelir_vergisi: #gelir_vergisi#<br>
	daily_minimum_income_tax : #daily_minimum_income_tax#<br>
	income_tax_temp : #income_tax_temp#<br>
	max_daily_minimum_income_tax : #max_daily_minimum_income_tax#<br>
	use_minimum_wage : #use_minimum_wage#<br>
	first_salary_temp : #first_salary_temp# <br>
	temp_daily_minimum_wage : #temp_daily_minimum_wage#<br>
	total_used_incoming_tax : #total_used_incoming_tax#<br><br>
</cfoutput> --->