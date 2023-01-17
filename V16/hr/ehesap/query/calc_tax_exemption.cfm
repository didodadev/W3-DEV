<!---
    File: V16\hr\ehesap\query\calc_tax_exemption.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2022-12-05
    Description: 
    Vergi indirimleri hesaplanır
    income_tax = gelir_vergisi 
    income_tax_base = gelir_vergisi_matrah

--->
<cfscript>
    if(attributes.sal_year gte 2022 and use_ssk neq 2 and daily_minimum_wage_base gt 0 and use_minimum_wage neq 1 and get_active_program_parameter.is_use_minimum_wage neq 1)
    {
        temp_income_tax_base = income_tax_base;
        income_tax_temp = income_tax;
        //hesaplanacak gelir vergisi asgari ücret gelir vergisi matrahından güçükse gelirvergileri 0'lanır. Değilse hesaplanan matrah atanır
        all_basic_wage =  daily_minimum_wage_base ;

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

        if(max_daily_minimum_income_tax gt 0 and tax_carpan gt tax_carpan_daily)
			daily_minimum_income_tax = max_daily_minimum_income_tax;

        if(LSParseNumber(income_tax_base) gte LSParseNumber(daily_minimum_wage_base) and LSParseNumber(income_tax) gte LSParseNumber(daily_minimum_income_tax))
        {
            income_tax = LSParseNumber(income_tax) - LSParseNumber(daily_minimum_income_tax);
            income_tax_base = income_tax_base - daily_minimum_wage_base;
        }
        else if(((first_brut gt 0 and first_brut lte daily_minimum_wage) and is_net_payment eq 1) and income_tax_base lte daily_minimum_wage_base)
        {
            income_tax = 0;
            income_tax_base = 0;
        }
            
            
        if(daily_minimum_wage_base eq temp_daily_minimum_wage_base)
            temp_first_min_wage = daily_minimum_income_tax;

        if(income_tax_temp gte income_tax and (is_net_payment neq 1 or (((base_control_val gt 0 and base_control_val lte wrk_round(daily_minimum_wage_base)) or (net_total_brut gt 0 and net_total_brut lte daily_minimum_wage) ) and is_net_payment eq 1)) )
            income_tax_temp = (daily_minimum_income_tax);
    }
</cfscript>
<!--- <cfoutput>
    income_tax #income_tax#<br>
    daily_minimum_income_tax : #daily_minimum_income_tax#<br>
    income_tax_base : #income_tax_base#<br>
    temp_income_tax_base : #temp_income_tax_base#<br>
    income_tax_temp : #income_tax_temp#<br>
    daily_minimum_wage_base : #daily_minimum_wage_base#<br><br>
</cfoutput> --->