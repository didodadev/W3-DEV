<cfscript>
/*
if (get_hr_ssk.SSK_STATUTE eq 3 or get_hr_ssk.SSK_STATUTE eq 4 or get_hr_ssk.SSK_STATUTE eq 75)//stajyer
	{
	gelir_vergisi_matrah = 0;
	gelir_vergisi = 0;
	tax_ratio = 0;
	tax_carpan = 0;
	}
*/

//if (attributes.sal_year lt 2022 or (attributes.sal_year gte 2022 and wrk_round(salary_ilk) neq wrk_round(control_daily_minimum_wage)) or get_hr_ssk.SSK_STATUTE eq 2)
{
	
	gelir_vergisi = 0;
	tax_ratio = get_active_tax_slice.RATIO_1;
	s1 = get_active_tax_slice.MAX_PAYMENT_1;	v1 = get_active_tax_slice.RATIO_1 / 100;
	s2 = get_active_tax_slice.MAX_PAYMENT_2;	v2 = get_active_tax_slice.RATIO_2 / 100;
	s3 = get_active_tax_slice.MAX_PAYMENT_3;	v3 = get_active_tax_slice.RATIO_3 / 100;
	s4 = get_active_tax_slice.MAX_PAYMENT_4;	v4 = get_active_tax_slice.RATIO_4 / 100;
	s5 = get_active_tax_slice.MAX_PAYMENT_5;	v5 = get_active_tax_slice.RATIO_5 / 100;
	s6 = get_active_tax_slice.MAX_PAYMENT_6;	v6 = get_active_tax_slice.RATIO_6 / 100;
	gelir_vergisi_matrah = gelir_vergisi_matrah; //-kazanca_dahil_olan_odenek_tutar_muaf

	temp_gelir_vergisi_matrah = gelir_vergisi_matrah;

	all_ = kumulatif_gelir + gelir_vergisi_matrah;
	if (kumulatif_gelir gte s5)
	{
		gelir_vergisi = gelir_vergisi + ((gelir_vergisi_matrah) * v6);
		tax_carpan = v6;
	}
	else if (kumulatif_gelir gte s4)
	{
		if (all_ gte s5)
		{
			gelir_vergisi = gelir_vergisi + ((all_ - s5) * v6);
			gelir_vergisi = gelir_vergisi + ((s5 - kumulatif_gelir) * v5);
			tax_carpan = v6;
		}
		else
		{
			gelir_vergisi = gelir_vergisi + ((gelir_vergisi_matrah) * v5);
			tax_carpan = v5;
		}
	}
	else if (kumulatif_gelir gte s3)
	{
		if (all_ gte s5)
		{
			gelir_vergisi = gelir_vergisi + ((all_ - s5) * v6);
			gelir_vergisi = gelir_vergisi + ((s5 - s4) * v5);
			gelir_vergisi = gelir_vergisi + ((s4 - kumulatif_gelir) * v4);
			tax_carpan = v6;
		}
		else if (all_ gte s4)
		{
			gelir_vergisi = gelir_vergisi + ((all_ - s4) * v5);
			gelir_vergisi = gelir_vergisi + ((s4 - kumulatif_gelir) * v4);
			tax_carpan = v5;
		}
		else
		{
			gelir_vergisi = gelir_vergisi + ((gelir_vergisi_matrah ) * v4);
			tax_carpan = v4;
		}
	}
	else if (kumulatif_gelir gte s2)
	{
		if (all_ gte s5)
		{
			gelir_vergisi = gelir_vergisi + ((all_ - s5) * v6);
			gelir_vergisi = gelir_vergisi + ((s5 - s4) * v5);
			gelir_vergisi = gelir_vergisi + ((s4 - s3) * v4);
			gelir_vergisi = gelir_vergisi + ((s3 - kumulatif_gelir) * v3);
			tax_carpan = v6;
		}
		else if (all_ gte s4)
		{
			gelir_vergisi = gelir_vergisi + ((all_ - s4) * v5);
			gelir_vergisi = gelir_vergisi + ((s4 - s3) * v4);
			gelir_vergisi = gelir_vergisi + ((s3 - kumulatif_gelir) * v3);
			tax_carpan = v5;
		}
		else if (all_ gte s3)
		{
			gelir_vergisi = gelir_vergisi + ((all_ - s3) * v4);
			gelir_vergisi = gelir_vergisi + ((s3 - kumulatif_gelir) * v3);
			tax_carpan = v4;
		}
		else
		{
			gelir_vergisi = gelir_vergisi + ((gelir_vergisi_matrah) * v3);
			tax_carpan = v3;
		}
	}
	else if (kumulatif_gelir gte s1)
	{
		if (all_ gte s5)
		{
			gelir_vergisi = gelir_vergisi + ((all_ - s5) * v6);
			gelir_vergisi = gelir_vergisi + ((s5 - s4) * v5);
			gelir_vergisi = gelir_vergisi + ((s4 - s3) * v4);
			gelir_vergisi = gelir_vergisi + ((s3 - s2) * v3);
			gelir_vergisi = gelir_vergisi + ((s2 - kumulatif_gelir) * v2);
			tax_carpan = v6;
		}
		else if (all_ gte s4)
		{
			gelir_vergisi = gelir_vergisi + ((all_ - s4) * v5);
			gelir_vergisi = gelir_vergisi + ((s4 - s3) * v4);
			gelir_vergisi = gelir_vergisi + ((s3 - s2) * v3);
			gelir_vergisi = gelir_vergisi + ((s2 - kumulatif_gelir) * v2);
			tax_carpan = v5;
		}
		else if (all_ gte s3)
		{
			gelir_vergisi = gelir_vergisi + ((all_ - s3) * v4);
			gelir_vergisi = gelir_vergisi + ((s3 - s2) * v3);
			gelir_vergisi = gelir_vergisi + ((s2 - kumulatif_gelir) * v2);
			tax_carpan = v4;
		}
		else if (all_ gte s2)
		{
			gelir_vergisi = gelir_vergisi + ((all_ - s2) * v3);
			gelir_vergisi = gelir_vergisi + ((s2 - kumulatif_gelir) * v2);
			tax_carpan = v3;
		}
		else
		{
			gelir_vergisi = gelir_vergisi + ((gelir_vergisi_matrah) * v2);
			tax_carpan = v2;
		}
	}
	else
	{
		if (all_ gte s5)
		{
			gelir_vergisi = gelir_vergisi + ((all_ - s5) * v6);
			gelir_vergisi = gelir_vergisi + ((s5 - s4) * v5);
			gelir_vergisi = gelir_vergisi + ((s4 - s3) * v4);
			gelir_vergisi = gelir_vergisi + ((s3 - s2) * v3);
			gelir_vergisi = gelir_vergisi + ((s2 - s1) * v2);
			gelir_vergisi = gelir_vergisi + ((s1 - kumulatif_gelir) * v1);
			tax_carpan = v6;
		}
		else if (all_ gte s4)
		{
			gelir_vergisi = gelir_vergisi + ((all_ - s4) * v5);
			gelir_vergisi = gelir_vergisi + ((s4 - s3) * v4);
			gelir_vergisi = gelir_vergisi + ((s3 - s2) * v3);
			gelir_vergisi = gelir_vergisi + ((s2 - s1) * v2);
			gelir_vergisi = gelir_vergisi + ((s1 - kumulatif_gelir) * v1);
			tax_carpan = v5;
		}
		else if (all_ gte s3)
		{
			gelir_vergisi = gelir_vergisi + ((all_ - s3) * v4);
			gelir_vergisi = gelir_vergisi + ((s3 - s2) * v3);
			gelir_vergisi = gelir_vergisi + ((s2 - s1) * v2);
			gelir_vergisi = gelir_vergisi + ((s1 - kumulatif_gelir) * v1);
			tax_carpan = v4;
		}
		else if (all_ gte s2)
		{
			gelir_vergisi = gelir_vergisi + ((all_ - s2) * v3);
			gelir_vergisi = gelir_vergisi + ((s2 - s1) * v2);
			gelir_vergisi = gelir_vergisi + ((s1 - kumulatif_gelir) * v1);
			tax_carpan = v3;
		}
		else if (all_ gte s1)
		{
			gelir_vergisi = gelir_vergisi + ((all_ - s1) * v2);
			gelir_vergisi = gelir_vergisi + ((s1 - kumulatif_gelir) * v1);
			tax_carpan = v2;
		}
		else
		{
			gelir_vergisi = gelir_vergisi + ((gelir_vergisi_matrah) * v1);
			tax_carpan = v1;
		}
	}
	//2022 den sonra matrah hesplamaları değişti ERU
	
	if(attributes.sal_year gte 2022 and use_ssk neq 2 and daily_minimum_wage_base gt 0 and use_minimum_wage neq 1 and get_active_program_parameter.is_use_minimum_wage neq 1)
	{
		income_tax_temp = gelir_vergisi;
		//hesaplanacak gelir vergisi asgari ücret gelir vergisi matrahından güçükse gelirvergileri 0'lanır. Değilse hesaplanan matrah atanır
		if(attributes.sal_year gte 2022 and isdefined("salary_ilk") and (wrk_round(salary_ilk) lt wrk_round(daily_minimum_wage_base) and tax_carpan eq v1) 
			and 
		(is_net_payment neq 1 or (((base_control_val gt 0 and base_control_val lte wrk_round(daily_minimum_wage_base)) or (net_total_brut gt 0 and net_total_brut lte daily_minimum_wage)) and is_net_payment eq 1)))
		{
			gelir_vergisi = 0;
			gelir_vergisi_matrah = 0;
			tax_carpan_daily = 0;
		}else 	
			gelir_vergisi_matrah = temp_gelir_vergisi_matrah;

		all_basic_wage = daily_minimum_wage_base + daily_minimum_wage_base_cumulate;

		daily_minimum_income_tax = 0;
		if (all_basic_wage gte s5)
		{
			daily_minimum_income_tax = daily_minimum_income_tax + ((daily_minimum_wage_base) * v6);
			tax_carpan_daily = v6;
		}
		else if (daily_minimum_wage_base_cumulate gte s4)
		{
			if (all_basic_wage gte s5)
			{
				daily_minimum_income_tax = daily_minimum_income_tax + ((all_basic_wage - s5) * v6);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s5 - daily_minimum_wage_base_cumulate) * v5);
				tax_carpan_daily = v6;
			}
			else
			{
				daily_minimum_income_tax = daily_minimum_income_tax + ((daily_minimum_wage_base) * v5);
				tax_carpan_daily = v5;
			}
		}
		else if (daily_minimum_wage_base_cumulate gte s3)
		{
			if (all_basic_wage gte s5)
			{
				daily_minimum_income_tax = daily_minimum_income_tax + ((all_basic_wage - s5) * v6);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s5 - s4) * v5);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s4 - daily_minimum_wage_base_cumulate) * v4);
				tax_carpan_daily = v6;
			}
			else if (all_basic_wage gte s4)
			{
				daily_minimum_income_tax = daily_minimum_income_tax + ((all_basic_wage - s4) * v5);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s4 - daily_minimum_wage_base_cumulate) * v4);
				tax_carpan_daily = v5;
			}
			else
			{
				daily_minimum_income_tax = daily_minimum_income_tax + ((daily_minimum_wage_base) * v4);
				tax_carpan_daily = v4;
			}
		}
		else if (daily_minimum_wage_base_cumulate gte s2)
		{
			if (all_basic_wage gte s5)
			{
				daily_minimum_income_tax = daily_minimum_income_tax + ((all_basic_wage - s5) * v6);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s5 - s4) * v5);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s4 - s3) * v4);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s3 - daily_minimum_wage_base_cumulate) * v3);
				tax_carpan_daily = v6;
			}
			else if (all_basic_wage gte s4)
			{
				daily_minimum_income_tax = daily_minimum_income_tax + ((all_basic_wage - s4) * v5);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s4 - s3) * v4);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s3 - daily_minimum_wage_base_cumulate) * v3);
				tax_carpan_daily = v5;
			}
			else if (all_basic_wage gte s3)
			{
				daily_minimum_income_tax = daily_minimum_income_tax + ((all_basic_wage - s3) * v4);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s3 - daily_minimum_wage_base_cumulate) * v3);
				tax_carpan_daily = v4;
			}
			else
			{
				daily_minimum_income_tax = daily_minimum_income_tax + ((daily_minimum_wage_base) * v3);
				tax_carpan_daily = v3;
			}
		}
		else if (daily_minimum_wage_base_cumulate gte s1)
		{
			if (all_basic_wage gte s5)
			{
				daily_minimum_income_tax = daily_minimum_income_tax + ((all_basic_wage - s5) * v6);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s5 - s4) * v5);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s4 - s3) * v4);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s3 - s2) * v3);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s2 - daily_minimum_wage_base_cumulate) * v2);
				tax_carpan_daily = v6;
			}
			else if (all_basic_wage gte s4)
			{
				daily_minimum_income_tax = daily_minimum_income_tax + ((all_basic_wage - s4) * v5);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s4 - s3) * v4);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s3 - s2) * v3);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s2 - daily_minimum_wage_base_cumulate) * v2);
				tax_carpan_daily = v5;
			}
			else if (all_basic_wage gte s3)
			{
				daily_minimum_income_tax = daily_minimum_income_tax + ((all_basic_wage - s3) * v4);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s3 - s2) * v3);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s2 - daily_minimum_wage_base_cumulate) * v2);
				tax_carpan_daily = v4;
			}
			else if (all_basic_wage gte s2)
			{
				daily_minimum_income_tax = daily_minimum_income_tax + ((all_basic_wage - s2) * v3);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s2 - daily_minimum_wage_base_cumulate) * v2);
				tax_carpan_daily = v3;
			}
			else
			{
				daily_minimum_income_tax = daily_minimum_income_tax + ((daily_minimum_wage_base) * v2);
				tax_carpan_daily = v2;
			}
			
		}
		else
		{
			
			if (all_basic_wage gte s5)
			{
				daily_minimum_income_tax = daily_minimum_income_tax + ((daily_minimum_wage_base_cumulate - s5) * v6);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s5 - s4) * v5);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s4 - s3) * v4);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s3 - s2) * v3);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s2 - s1) * v2);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s1 - daily_minimum_wage_base) * v1);
				tax_carpan_daily = v6;
			}
			else if (all_basic_wage gte s4)
			{
				daily_minimum_income_tax = daily_minimum_income_tax + ((daily_minimum_wage_base_cumulate - s4) * v5);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s4 - s3) * v4);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s3 - s2) * v3);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s2 - s1) * v2);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s1 - daily_minimum_wage_base) * v1);
				tax_carpan_daily = v5;
			}
			else if (all_basic_wage gte s3)
			{
				daily_minimum_income_tax = daily_minimum_income_tax + ((daily_minimum_wage_base_cumulate - s3) * v4);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s3 - s2) * v3);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s2 - s1) * v2);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s1 - daily_minimum_wage_base) * v1);
				tax_carpan_daily = v4;
			}
			else if (all_basic_wage gte s2)
			{
				daily_minimum_income_tax = daily_minimum_income_tax + ((all_basic_wage - s2) * v3);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s2 - s1) * v2);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s1 - daily_minimum_wage_base_cumulate) * v1);
				tax_carpan_daily = v3;
			}
			else if (all_basic_wage gte s1)
			{
				daily_minimum_income_tax = daily_minimum_income_tax + ((all_basic_wage - s1) * v2);
				daily_minimum_income_tax = daily_minimum_income_tax + ((s1 - daily_minimum_wage_base_cumulate) * v1);
				tax_carpan_daily = v2;
			}
			else
			{
				daily_minimum_income_tax = daily_minimum_income_tax + ((daily_minimum_wage_base) * v1);
				tax_carpan_daily = v1;
			}
		}
		
		//Eğer ilk defa giriyorsa max alabilceği gv indirim tutarı
		if(count_2022 eq 0)
		{
			max_daily_minimum_income_tax = temp_daily_minimum_wage_base * tax_carpan_daily;
		}

		if(max_daily_minimum_income_tax gt 0 and tax_carpan gt tax_carpan_daily)
			daily_minimum_income_tax = max_daily_minimum_income_tax;
			
		if(LSParseNumber(gelir_vergisi) gte LSParseNumber(daily_minimum_income_tax))
		{
			gelir_vergisi = LSParseNumber(gelir_vergisi) - LSParseNumber(daily_minimum_income_tax);
		}
		//ek ödenek değilse ya da ek ödenekse ve total matrah kullanılandan küçükse ya da dv ve gv den muafsa sadece ödeneğin matrahı gerye kalan muafiyetten küçükse
		else if((is_net_payment neq 1 or ((((base_control_val gt 0 and base_control_val lte wrk_round(daily_minimum_wage_base)) or (net_total_brut gt 0 and net_total_brut lte daily_minimum_wage) ) and is_net_payment eq 1)) and gelir_vergisi_matrah lte daily_minimum_wage_base) or (is_net_payment eq 1 and is_tax_free_from_payment gt 0 and gelir_vergisi_matrah lte daily_minimum_wage_base and is_tax_free_from_payment eq 1))
		{
			gelir_vergisi = 0;
		}

		if(daily_minimum_wage_base eq temp_daily_minimum_wage_base)
			temp_first_min_wage = daily_minimum_income_tax;

		if(income_tax_temp gte gelir_vergisi and (is_net_payment neq 1 or (((base_control_val gt 0 and base_control_val lte wrk_round(daily_minimum_wage_base)) or (net_total_brut gt 0 and net_total_brut lte daily_minimum_wage) ) and is_net_payment eq 1)) and not(max_daily_minimum_income_tax gt 0 and tax_carpan gt tax_carpan_daily))
			income_tax_temp = (daily_minimum_income_tax);
	} 
	else 	
		gelir_vergisi_matrah = temp_gelir_vergisi_matrah;

 
}
	if (gelir_vergisi_matrah)
		tax_ratio = (gelir_vergisi / gelir_vergisi_matrah);
	else
		tax_ratio = 0; // AK20040806 30 gün ücretsiz izni var ise
		
	if(get_hr_ssk.IS_TAX_FREE eq 1 and is_yearly_offtime eq 0 and (is_net_payment eq 0 or (is_net_payment eq 1 and is_mesai_ eq 1)))//vergiden muafsa ve yıllık izin vergisinden muafsa
	{
		gelir_vergisi = 0;
		tax_carpan = 0;
		tax_ratio = 0;
		gelir_vergisi_matrah = 0;
		income_tax_temp = 0;
		if(is_net_payment eq 1 and is_mesai_ eq 1)
		{
			temp_gelir_vergisi_matrah = 0;
		}
		if(daily_minimum_wage_base eq temp_daily_minimum_wage_base)
			temp_first_min_wage = 0;
	}
	if(get_hr_ssk.is_damga_free eq 1  and is_yearly_offtime eq 0 and (is_net_payment eq 0 or (is_net_payment eq 1 and is_mesai_ eq 1))){//sgksız çalışansa ve damga vergisinden muafsa() 116442 ID'li iş için eklenmiştir. 23082019ERU)
		damga_vergisi_ = 0;
	}
</cfscript>
