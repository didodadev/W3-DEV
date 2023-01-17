<cfscript>
	if(attributes.sal_year gte 2022 and attributes.statue_type_individual eq 0 and use_minimum_wage neq 1 and get_active_program_parameter.is_use_minimum_wage neq 1 and from_net eq 1){
		//aylık çalıştığı gün asgari ücret 
		daily_minimum_wage = ssk_asgari_ucret;		
		control_daily_minimum_wage = ssk_asgari_ucret;
		if(get_hr_ssk.use_ssk eq 2 )
		{
			dmw_employee_contribution = daily_minimum_wage * ssk_isci_carpan / 100;//Asgari sgk işçi primi
			dmw_unemployment_workers_premium =  daily_minimum_wage * issizlik_isci_carpan / 100;//Asgari sgk işsizlik işçi primi
			daily_minimum_wage_base = daily_minimum_wage - dmw_employee_contribution - dmw_unemployment_workers_premium;
		}
		else
		{
			daily_minimum_wage_base = daily_minimum_wage * 0.85;
		}
		
		daily_minimum_wage_stamp_tax = (daily_minimum_wage * get_active_program_parameter.STAMP_TAX_BINDE) / 1000;
		total_used_incoming_tax = wrk_round(daily_minimum_wage_base);
		total_used_stamp_tax = wrk_round(daily_minimum_wage);
	}
	if(duty_type eq 6)
		ssk_days = ceiling(ssk_days); // kismi istihdam saat te bucuklu gelen degerler nedeni ile yapıldı SG 20130919
	gelir_vergisi_fark = 0;
	
	vergi_istisna_ssk = 0;
	if((attributes.sal_year gt 2008 or (attributes.sal_year eq 2008 and attributes.sal_mon gt 9)))// 1 ekim 2008 den itibaren gecerli
	{
		if (ssk_days gt 0) // ssk günü sıfır olanın ek ödenek, kesinti, vergi istisnaları dikkate alınmaz
		{
			for (i=1; i lte get_tax_ssk.recordcount; i = i+1) 
			{				
				satir_ssk_tutari = 0;
				if (get_tax_ssk.calc_days[i] eq 1) // günlere göre
					satir_ssk_tutari = (get_tax_ssk.amount[i] * (ssk_days/ssk_full_days) );
				else // günlere göre değil
					satir_ssk_tutari = get_tax_ssk.amount[i];
					
				vergi_istisna_ssk = vergi_istisna_ssk + satir_ssk_tutari;
			}
		}
	}
	if(vergi_istisna_ssk gt 0)
	{
		asgari_ucret_orani_ = ssk_asgari_ucret * 30 /100;
			if(vergi_istisna_ssk gt asgari_ucret_orani_)
				vergi_istisna_ssk = vergi_istisna_ssk - asgari_ucret_orani_;
			else
				vergi_istisna_ssk = 0;
	}

	ssk_matrah_bu_ay_devreden = 0;
	ssk_matrah_devirden_gelen = 0;
	ssk_matrah_kullanilan = 0;
	ssk_isci_hissesi_dusulecek = 0;
	issizlik_isci_hissesi_dusulecek = 0;
	ssk_isci_hissesi_odenek_fark = 0;
	ssk_isveren_hissesi_isci_gelen = 0;
	ssk_isci_hissesi_6322 = 0; //6322 kapsamında isci hissesinden dusulecek hesaplama SG 20130916 
</cfscript>
<cfif is_devir_matrah_off eq 0>
	<cfif ((attributes.sal_year gt 2008 or (attributes.sal_year eq 2008 and attributes.sal_mon gt 10)))> <!--- 1 kasim 2008 den itibaren gecerli --->
		<cfquery name="get_devir_mahrah" datasource="#dsn#">
			SELECT
				EPRA.*
			FROM 
				EMPLOYEES_PUANTAJ_ROWS_ADD EPRA 
				INNER JOIN EMPLOYEES_PUANTAJ EP ON EPRA.PUANTAJ_ID = EP.PUANTAJ_ID 
				INNER JOIN BRANCH B ON B.BRANCH_ID = EP.SSK_BRANCH_ID
			WHERE
				B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hr_ssk.company_id#"> AND
				EP.PUANTAJ_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_type#"> AND
				<cfif attributes.sal_mon gt 2>
					(
						EPRA.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
						(EPRA.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon - 1#"> OR EPRA.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon - 2#">) 
					)
				<cfelseif attributes.sal_mon eq 1>
					(
						EPRA.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year-1#"> AND
						(EPRA.SAL_MON = 11 OR EPRA.SAL_MON = 12) 
					)
				<cfelseif attributes.sal_mon eq 2>
					(
						(EPRA.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year-1#"> AND EPRA.SAL_MON = 12)
						OR
						(EPRA.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EPRA.SAL_MON = 1)
					)
				</cfif>
				AND
				EPRA.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		UNION ALL
			SELECT
				EPRA.*
			FROM 
				EMPLOYEES_PUANTAJ_ROWS_ADD EPRA
			WHERE
				EPRA.PUANTAJ_ID IS NULL AND
				<cfif attributes.sal_mon gt 2>
					(
						EPRA.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
						(EPRA.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon - 1#"> OR EPRA.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon - 2#">) 
					)
				<cfelseif attributes.sal_mon eq 1>
					(
						EPRA.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year-1#"> AND
						(EPRA.SAL_MON = 11 OR EPRA.SAL_MON = 12) 
					)
				<cfelseif attributes.sal_mon eq 2>
					(
						(EPRA.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year-1#"> AND EPRA.SAL_MON = 12)
						OR
						(EPRA.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EPRA.SAL_MON = 1)
					)
				</cfif>
				AND
				EPRA.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		</cfquery> 
		
		<cfif get_devir_mahrah.recordcount>
			<cfoutput query="get_devir_mahrah">
				<cfset ssk_matrah_devirden_gelen = ssk_matrah_devirden_gelen + (amount - amount_used)>
			</cfoutput>
			<cfif isdefined("kontrol_matrah_") and kontrol_matrah_ eq 1><!--- get_hr_compass dosyasından geliyor , eğer %20 eklendiğinde tavanı aşıyorsa  --->
				<cfset ssk_matrah_devirden_gelen = ssk_matrah_devirden_gelen + (ssk_matrah_devirden_gelen*20/100)>
			</cfif>
		</cfif>
	</cfif>
</cfif>

<cfscript>
// kıdem tazminatı fonları hesabı
	if(get_hr_ssk.IS_DAMGA_FREE eq 1 and get_hr_ssk.is_tax_free eq 1)
	{
		ext_salary_diff = ext_salary_net;
		ext_salary_gross = ext_salary;
	}
	else
	{
		ext_salary_diff = 0;
		ext_salary_gross = 0;
	}
		
	kidem_brut = salary + ext_salary  + total_pay_ssk_tax + total_pay_tax + total_pay + total_pay_d + total_pay_ssk_tax_noissizlik + total_pay_ssk + total_pay_ssk_noissizlik + total_pay_ssk_tax_notstamp_base;
	
	//kidem_isci_payi = kidem_brut * (get_insurance.KIDEM_WORKER_PERCENT / 100);
	//kidem_isveren_payi = kidem_brut * (get_insurance.KIDEM_BOSS_PERCENT / 100);
	kidem_isci_payi = 0;
	kidem_isveren_payi = 0;

	mahsup_edilecek_gelir_vergisi_ = 0;
	matrah_farki_ = 0;
// ssk matrahı bulunur
	gelen_salary = salary;
	salary_taban_fark_ = 0;
	
	salary = salary + ext_salary + attributes.yillik_izin_amount + vergi_istisna_ssk + vergi_istisna_ssk_tutar;  // kullanmadigi yillik izin tutari brüte

	if(get_hr_ssk.use_ssk eq 1 and get_active_program_parameter.is_sgk_kontrol eq 1 and get_hr_ssk.IS_TAX_FREE neq 1)
	{
		if(salary lt ssk_matrah_taban)
			salary_taban_fark_ = ssk_matrah_taban - salary;
	}

	salary = salary  + total_pay_ssk_tax  + total_pay_ssk_tax_noissizlik + total_pay_ssk + salary_taban_fark_ - (ssk_matraha_dahil_olmayan_odenek_tutar) - kazanca_dahil_olan_odenek_tutar + total_pay_ssk_tax_notstamp_base;  // kullanmadigi yillik izin tutari brüte
	
	if(salary lt 0) salary = 0;

	if(is_included_in_tax eq 1)
	{
		salary = salary + included_in_tax_paid_amount;
	}
	/*if(get_active_program_parameter.is_sgk_control_ext_salary eq 1) // 87285 idli iş SG 20150311 //devreden kontrolünde fazla mesai dahil edilmemesi için düzenleme yapılmıştır
	{
		ilk_ssk_matrah = salary-ext_salary;
	}
	else
	{*/
		ilk_ssk_matrah = salary;	
	//}
	matrah_salary = salary;
	
	if(is_devir_matrah_off eq 0 and salary gt ssk_matrah_tavan and ozel_kesinti_2 gt 0)
	{
		matrah_fark_ozel_kesinti_2 = ssk_matrah_tavan - (salary - ozel_kesinti_2);
		if(matrah_fark_ozel_kesinti_2 lt 0)
			matrah_fark_ozel_kesinti_2 = 0;
	}
	else if(is_devir_matrah_off eq 0 and ozel_kesinti_2 gt 0)
	{
		matrah_fark_ozel_kesinti_2 = ozel_kesinti_2;
	}

	salary = salary + ssk_matrah_devirden_gelen;
	if(get_active_program_parameter.is_sgk_kontrol eq 1)
	{
		matrah_salary = salary;
		
		if(is_devir_matrah_off eq 0 and salary gt ssk_matrah_tavan and ozel_kesinti_2 gt 0)
		{
			matrah_fark_ozel_kesinti_2 = ssk_matrah_tavan - (salary - ozel_kesinti_2);
			if(matrah_fark_ozel_kesinti_2 lt 0)
				matrah_fark_ozel_kesinti_2 = 0;
		}
		else if(is_devir_matrah_off eq 0 and ozel_kesinti_2 gt 0)
		{
			matrah_fark_ozel_kesinti_2 = ozel_kesinti_2;
		}
		//Kısa Çalışma Matrah hesabı Esma R. Uysal
		if(isdefined("toplam_calisma_gunu") and len(toplam_calisma_gunu) and toplam_calisma_gunu neq 0 and isdefined("kisa_calisma_type") and kisa_calisma_type neq 0 and ((isdefined("arada_kalan") and arada_kalan neq 0) or (isdefined("arada_kalan_sonraki") or arada_kalan_sonraki neq 0)))
		{
			if(get_hr_salary.gross_net eq 0)
			{
				yedi_gunde_tam_gun = 0;
				yedi_gunde_yarim_gun = 0;
				yedi_gunluk_sgk = 0;
				gecici_sgk = 0;
				
				if(isdefined("oran_tipi") and oran_tipi eq 1)
				{
					yedi_gun_oran = ceiling(gelen_saat * 6 / 45);//7 gümlü süreçteki çalışma oranı 6 gün üzerinden oranlanıp bir virgül bir üse yuvarlandı
					yedi_gun_kalan_oran = 7 - yedi_gun_oran;
					if(gelen_saat eq 45)//3/3 kapatılmışsa
					{
						if(isdefined("arada_kalan"))
						{
							gecici_sgk = (get_hr_salary.salary / 30) * (toplam_calisma_gunu - arada_kalan);
							yedi_gunluk_sgk = get_insurance.MIN_PAYMENT / 30 * arada_kalan;// 3 / 3
						}
						else if(isdefined("arada_kalan_sonraki"))
						{
							gecici_sgk = (get_hr_salary.salary / 30) * (toplam_calisma_gunu - arada_kalan_sonraki);
							yedi_gunluk_sgk = get_insurance.MIN_PAYMENT / 30 * arada_kalan_sonraki;// 3 / 3
						}
						
					}else{
						if(isdefined("arada_kalan") and arada_kalan gte yedi_gun_oran)//eğer önündeki aya 4 günden fazla sarkarsa
						{
							//7 günden önceki tam hesaplama
							yedi_gunde_yarim_gun = arada_kalan - yedi_gun_oran ;
							gecici_sgk = (get_hr_salary.salary / 30) * (toplam_calisma_gunu - yedi_gunde_yarim_gun);
							yedi_gunluk_sgk = get_insurance.MIN_PAYMENT / 30 * yedi_gunde_yarim_gun;
						}
						else if(isdefined("arada_kalan_sonraki") and arada_kalan_sonraki gte 3){
							//7 günden önceki tam hesaplama
							gecici_sgk = (get_hr_salary.salary / 30) * (toplam_calisma_gunu - yedi_gun_kalan_oran);
							yedi_gunluk_sgk = get_insurance.MIN_PAYMENT / 30 * yedi_gunde_tam_gun;
						}
						else
						{
							gecici_sgk = (get_hr_salary.salary / 30) * (toplam_calisma_gunu);
						}
					}
				}else if(isdefined("oran_tipi") and oran_tipi eq 0){
					if(kisa_calisma_type eq 1) gelen_saat = 30;
					else if(kisa_calisma_type eq 2) gelen_saat = 15;
					else if(kisa_calisma_type eq 3) gelen_saat = 45;
					else if(kisa_calisma_type eq 4) gelen_saat = 22.5;
					yedi_gun_oran = ceiling(gelen_saat * 6 / 45);//7 gümlü süreçteki çalışma oranı 6 gün üzerinden oranlanıp bir virgül bir üse yuvarlandı
					yedi_gun_kalan_oran = 7 - yedi_gun_oran;
					if(gelen_saat eq 45)//3/3 kapatılmışsa
					{
						if(isdefined("arada_kalan") and arada_kalan neq 0)
						{
							gecici_sgk = (get_hr_salary.salary / 30) * (toplam_calisma_gunu - arada_kalan);
							yedi_gunluk_sgk = get_insurance.MIN_PAYMENT / 30 * arada_kalan;// 3 / 3
						}
						else if(isdefined("arada_kalan_sonraki") and arada_kalan_sonraki neq 0)
						{
							gecici_sgk = (get_hr_salary.salary / 30) * (toplam_calisma_gunu - arada_kalan_sonraki);
							yedi_gunluk_sgk = get_insurance.MIN_PAYMENT / 30 * arada_kalan_sonraki;// 3 / 3
						}
						
					}else{
						if(isdefined("arada_kalan") and arada_kalan gte yedi_gun_oran)//eğer önündeki aya 4 günden fazla sarkarsa
						{
							//7 günden önceki tam hesaplama
							yedi_gunde_yarim_gun = arada_kalan - yedi_gun_oran ;
							gecici_sgk = (get_hr_salary.salary / 30) * (toplam_calisma_gunu - yedi_gunde_yarim_gun);
							yedi_gunluk_sgk = get_insurance.MIN_PAYMENT / 30 * yedi_gunde_yarim_gun;
						}
						else if(isdefined("arada_kalan_sonraki") and arada_kalan_sonraki gte yedi_gun_kalan_oran){
							//7 günden önceki tam hesaplama
							gecici_sgk = (get_hr_salary.salary / 30) * (toplam_calisma_gunu - yedi_gun_kalan_oran);
							yedi_gunluk_sgk = get_insurance.MIN_PAYMENT / 30 * yedi_gunde_tam_gun;
						}
						else
						{
							gecici_sgk = (get_hr_salary.salary / 30) * (toplam_calisma_gunu);
						}
					}
				}else if(isdefined("oran_tipi") and oran_tipi eq 0){
					if(isdefined("arada_kalan") and arada_kalan neq 0)//eğer önündeki aya 3 günden fazla sarkarsa
					{
						gecici_sgk = (brut_salary / (toplam_calisma_gunu - arada_kalan/2) * (toplam_calisma_gunu - arada_kalan) + get_insurance.MIN_PAYMENT / 30 * arada_kalan);
						toplam_matrah = gecici_sgk;
					}else if(isdefined("arada_kalan_sonraki") and arada_kalan_sonraki neq 0){
						gecici_sgk = (brut_salary / (toplam_calisma_gunu - arada_kalan_sonraki/2) * (toplam_calisma_gunu - arada_kalan_sonraki) + get_insurance.MIN_PAYMENT / 30 * arada_kalan_sonraki);
						toplam_matrah = gecici_sgk;
					}
				}
				toplam_matrah = gecici_sgk + yedi_gunluk_sgk;
			}
			else
			{
				if(isdefined("oran_tipi") and oran_tipi eq 0)
				{
					
					if(kisa_calisma_type eq 1) gelen_saat = 30;
					else if(kisa_calisma_type eq 2) gelen_saat = 15;
					else if(kisa_calisma_type eq 3) gelen_saat = 0;
					else if(kisa_calisma_type eq 4) gelen_saat = 22.5;
					yedi_gun_oran = ceiling(gelen_saat * 6 / 45);//7 gümlü süreçteki çalışma oranı 6 gün üzerinden oranlanıp bir virgül bir üse yuvarlandı
					yedi_gun_kalan_oran = 7 - yedi_gun_oran;
					if(isdefined("arada_kalan") and arada_kalan gte yedi_gun_oran)//eğer önündeki aya 3 günden fazla sarkarsa
					{
						gecici_sgk = brut_salary / ((toplam_calisma_gunu - arada_kalan+yedi_gun_oran) + (arada_kalan - yedi_gun_oran)/2) * (toplam_calisma_gunu - arada_kalan + yedi_gun_oran) +  get_insurance.MIN_PAYMENT / 30 * (arada_kalan - yedi_gun_oran);//* get_insurance.MIN_PAYMENT / 30 * (arada_kalan - yedi_gun_oran);
						toplam_matrah = gecici_sgk;
					}else if(isdefined("arada_kalan_sonraki") and arada_kalan_sonraki gte yedi_gun_kalan_oran){
						gecici_sgk = (brut_salary / (toplam_calisma_gunu - arada_kalan_sonraki) + (arada_kalan_sonraki-yedi_gun_oran)/2 * (toplam_calisma_gunu - arada_kalan_sonraki) + get_insurance.MIN_PAYMENT / 30 * arada_kalan_sonraki);
						toplam_matrah = gecici_sgk;
					}
				}else if(isdefined("oran_tipi") and oran_tipi eq 1 and ((isdefined("tam_odeme") and tam_odeme eq 0) or not isdefined("tam_odeme")))
				{
					if(isdefined("arada_kalan") and arada_kalan gte yedi_gun_oran)//eğer önündeki aya 3 günden fazla sarkarsa
					{
						gecici_sgk = brut_salary / ((toplam_calisma_gunu - arada_kalan+yedi_gun_oran) + (arada_kalan - yedi_gun_oran)/2) * (toplam_calisma_gunu - arada_kalan + yedi_gun_oran) +  get_insurance.MIN_PAYMENT / 30 * (arada_kalan - yedi_gun_oran);//* get_insurance.MIN_PAYMENT / 30 * (arada_kalan - yedi_gun_oran);
					//	abort("#gecici_sgk# = #brut_salary# / ((#toplam_calisma_gunu #- #arada_kalan#+#yedi_gun_oran#) + (#arada_kalan# - #yedi_gun_oran#)/2) * (#toplam_calisma_gunu #- #arada_kalan #+ #yedi_gun_oran#)  + #get_insurance.MIN_PAYMENT# / 30 * (#arada_kalan #- #yedi_gun_oran#)");
					}else if(isdefined("arada_kalan_sonraki") and arada_kalan_sonraki gte yedi_gun_kalan_oran){
						gecici_sgk = (brut_salary / (toplam_calisma_gunu - arada_kalan_sonraki) + (arada_kalan_sonraki-yedi_gun_oran)/2 * (toplam_calisma_gunu - arada_kalan_sonraki) + get_insurance.MIN_PAYMENT / 30 * arada_kalan_sonraki);
					}
					toplam_matrah = gecici_sgk;
				}
			}
			if(isdefined("toplam_matrah") and len(toplam_matrah))
				toplam_matrah = toplam_matrah + total_pay_ssk_tax  + total_pay_ssk_tax_noissizlik + total_pay_ssk - (ssk_matraha_dahil_olmayan_odenek_tutar) - kazanca_dahil_olan_odenek_tutar + total_pay_ssk_tax_notstamp_base;	
		}
		if (isdefined("toplam_matrah") and (salary gt toplam_matrah) and (salary lt ssk_matrah_tavan))
			SSK_MATRAH = salary;
		else if(isdefined("toplam_matrah") and (salary lte toplam_matrah))
			SSK_MATRAH = toplam_matrah;
		else if ((salary gt ssk_matrah_taban) and (salary lt ssk_matrah_tavan))
			SSK_MATRAH = salary;
		else if(salary lte ssk_matrah_taban)
			SSK_MATRAH = ssk_matrah_taban;
		else if(salary gte ssk_matrah_tavan)
			SSK_MATRAH = ssk_matrah_tavan;

		if ((gelen_salary gt ssk_matrah_taban) and (gelen_salary lt ssk_matrah_tavan))
			SSK_MATRAH_GELEN = gelen_salary;
		else if(gelen_salary lte ssk_matrah_taban)
			SSK_MATRAH_GELEN = ssk_matrah_taban;
		else if(gelen_salary gte ssk_matrah_tavan)
			SSK_MATRAH_GELEN = ssk_matrah_tavan;
	}
	else	
	{
		if (salary lt ssk_matrah_tavan)
			SSK_MATRAH = salary;
		else if(salary gte ssk_matrah_tavan)
			SSK_MATRAH = ssk_matrah_tavan;

		if (gelen_salary lt ssk_matrah_tavan)
			SSK_MATRAH_GELEN = salary;
		else if(gelen_salary gte ssk_matrah_tavan)
			SSK_MATRAH_GELEN = ssk_matrah_tavan;
	}
	
	
	//abort("aa");
	/*if(get_active_program_parameter.is_sgk_control_ext_salary eq 1 and (gelen_salary+ext_salary) gt ssk_matrah_tavan) // parametre seçili ise ücret+fazla mesai tavanı aşıyor ise ödenek olsa bile devreden oluşmayacak 
	{
		ssk_matrah_bu_ay_devreden = 0;	
	}*/
	if(ssk_matrah_devirden_gelen gt 0) // devreden matrah varsa
	{
		if(ilk_ssk_matrah gt ssk_matrah_tavan)
		{
			ssk_matrah_kullanilan = 0;
			ssk_matrah_kullanilan_ =  0;
		}
		else if(ilk_ssk_matrah lt ssk_matrah_tavan and salary gte ssk_matrah_tavan)
		{
			ssk_matrah_kullanilan = ssk_matrah_tavan - ilk_ssk_matrah;
			ssk_matrah_kullanilan_ = ssk_matrah_tavan - (ilk_ssk_matrah - ext_salary);
		}
		else if(ilk_ssk_matrah lt ssk_matrah_tavan and salary lt ssk_matrah_tavan)
		{
			ssk_matrah_kullanilan = ssk_matrah_devirden_gelen;
			ssk_matrah_kullanilan_ = ssk_matrah_devirden_gelen;
		}
	
	}
	//writeoutput("ssk_matrah_kullanilan_ : #ssk_matrah_kullanilan_# #ssk_matrah_tavan# #ssk_matrah_devirden_gelen#<br>")
	
    if(ilk_ssk_matrah+ssk_matrah_devirden_gelen gt SSK_MATRAH)
    {
        ssk_matrah_bu_ay_devreden = ilk_ssk_matrah+ssk_matrah_devirden_gelen - SSK_MATRAH + devir_matrah_eklentisi;
       
        if(ilk_ssk_matrah gt (gelen_salary+kazanc_tipli_odenek_tutar) and ssk_matrah_bu_ay_devreden gte (ilk_ssk_matrah - (gelen_salary+kazanc_tipli_odenek_tutar)))  
              ssk_matrah_bu_ay_devreden = ilk_ssk_matrah - (gelen_salary+kazanc_tipli_odenek_tutar);
        else if(ilk_ssk_matrah eq (gelen_salary+kazanc_tipli_odenek_tutar))
              ssk_matrah_bu_ay_devreden = 0;
    }

	ssk_matrah_salary = ssk_matrah - (salary - attributes.yillik_izin_amount); // cikista kullaniliyor erk 20030922
	if (ssk_matrah_salary lt 0)	ssk_matrah_salary = 0;

// ssk miktarlari hesaplanir
if(get_hr_ssk.SSK_STATUTE eq 70 or use_ssk eq 2) //bagkur
{
	ssk_isveren_hissesi = 0;
	ssk_isci_hissesi = 0;
	issizlik_isci_hissesi = 0;
	issizlik_isveren_hissesi = 0;
	bes_isci_hissesi =  0;
}	
else if (get_hr_ssk.SSK_STATUTE eq 2 or get_hr_ssk.SSK_STATUTE eq 18) //Yeraltı emekli ise
{
	ssk_isveren_hissesi = 0;
	ssk_isci_hissesi = 0;
	issizlik_isci_hissesi = 0;
	issizlik_isveren_hissesi = 0;
	if (ssk_matrah gt salary)
	{
		extra = ((ssk_matrah - salary)/100) * ssk_isci_carpan;
		ssdf_isveren_hissesi = wrk_round( extra + ( (ssk_matrah/100) * ssk_isveren_carpan) );
		ssdf_isci_hissesi = wrk_round((salary/100) * ssk_isci_carpan);
		ssk_matrah_ekran = salary; // ekledi sadece arayuzde matrah olarak adamin maasi gozuksun diye deniyor?
		
		bes_isci_hissesi = fix(extra + ((ssk_matrah/100) * bes_isci_carpan));
	}
	else
	{
		if(salary_taban_fark_ gt 0)
		{
			extra = (salary_taban_fark_)/100 * ssk_isci_carpan;
			extra_2 = (salary_taban_fark_)/100 * issizlik_isci_carpan;
		}
		else
		{
			extra = 0;
			extra_2 = 0;
		}
		/*ssdf_isveren_hissesi = wrk_round( (ssk_matrah/100) * ssk_isveren_carpan );
		ssdf_isci_hissesi = wrk_round((ssk_matrah/100) * ssk_isci_carpan);*/
		ssdf_isveren_hissesi = extra +wrk_round( (ssk_matrah/100) * ssk_isveren_carpan );
		ssdf_isci_hissesi = wrk_round((ssk_matrah/100) * ssk_isci_carpan);
		
		issizlik_isveren_hissesi = extra_2 + wrk_round( ((ssk_matrah)/100) * issizlik_isveren_carpan );		
		ssk_isveren_hissesi_isci_gelen = extra; //SG ekledi 20130430
		ssdf_isci_hissesi = ssdf_isci_hissesi - ssk_isveren_hissesi_isci_gelen;
		
		bes_isci_hissesi =  fix((extra +wrk_round(ssk_matrah/100)) * bes_isci_carpan );
		//abort('extra_2:#extra_2#');
		//abort('ssk_isveren_hissesi_isci_gelen:#ssk_isveren_hissesi_isci_gelen#<br>issizlik_isveren_hissesi:#issizlik_isveren_hissesi#<br>ssdf_isveren_hissesi:#ssdf_isveren_hissesi#ssdf_isci_hissesi:#ssdf_isci_hissesi#');
	}
	if(total_pay_ssk gt 0)
	{
		if(isdefined("ilk_salary_temp"))
			temp_salary_ = ilk_salary_temp;
		else if(isdefined("ilk_salary"))
			temp_salary_ = ilk_salary;
		if(isdefined("temp_salary_"))//net ücretse çalışacak
		{
			if(temp_salary_ gt ssk_matrah_tavan) // normal kazanç tavandan büyükse
				total_pay_ssk_ = 0;
			else if(temp_salary_+total_pay_ssk gt ssk_matrah_tavan)	//normal kazanç ve ödeneklerin toplamı tavandan büyükse
				total_pay_ssk_ = ssk_matrah_tavan - temp_salary_;
			else
				total_pay_ssk_ = total_pay_ssk;
		}
		else
			total_pay_ssk_ = total_pay_ssk;
		//ssk_isci_hissesi_odenek_fark = wrk_round((total_pay_ssk_/100) * ssk_isci_carpan); //20150817 91285 idli işe istinaden kapatılmıştır
	}
}
else // emekli değil ise
{

	ssdf_isci_hissesi = 0;
	ssdf_isveren_hissesi = 0;
	if (ssk_matrah gt salary)
	{
		/* extra = ((ssk_matrah - (salary - salary_taban_fark_))/100) * ssk_isci_carpan;
		extra_2 = ((ssk_matrah - (salary - salary_taban_fark_))/100) * issizlik_isci_carpan; SG kapattı 20130430--->*/
		if(salary_taban_fark_ gt 0)
		{
			extra = (salary_taban_fark_)/100 * ssk_isci_carpan;
			extra_2 = (salary_taban_fark_)/100 * issizlik_isci_carpan;

			extra_health = (salary_taban_fark_)/100 * health_insurance_premium_employer_ratio;
			extra_death = (salary_taban_fark_)/100 * death_insurance_premium_employer_ratio;
			extra_short = (salary_taban_fark_)/100 * short_term_premium_ratio;
		}
		else
		{
			extra = 0;
			extra_2 = 0;

			extra_health = 0;
			extra_death = 0;
			extra_short = 0;
		}		

		ssk_isci_hissesi = wrk_round(((salary - salary_taban_fark_)/100) * ssk_isci_carpan);
		ssk_isveren_hissesi = extra + (ssk_matrah/100) * ssk_isveren_carpan;

		health_insurance_premium_worker = wrk_round(((salary - salary_taban_fark_)/100) * health_insurance_premium_worker_ratio); //Hastalık Sigorta Primi İşçi
		death_insurance_premium_worker = wrk_round(((salary - salary_taban_fark_)/100) * death_insurance_premium_worker_ratio);//Malülük, Yaşlılık, Ölüm Sigorta Primi İşçi

		health_insurance_premium_employer = extra_health + (ssk_matrah/100) * health_insurance_premium_employer_ratio; //Hastalık Sigorta Primi İşveren
		death_insurance_premium_employer = extra_death + (ssk_matrah/100) * death_insurance_premium_employer_ratio;//Malülük, Yaşlılık, Ölüm Sigorta Primi İşveren
		short_term_premium_employer =  short_term_premium_ratio + (ssk_matrah/100) * short_term_premium_ratio;//Kısa Vadeli Sigorta Kolları Prim


		issizlik_isci_hissesi = wrk_round(((salary - salary_taban_fark_)/100) * issizlik_isci_carpan);
		issizlik_isveren_hissesi = wrk_round(extra_2 + ( (ssk_matrah/100) * issizlik_isveren_carpan) );
		ssk_matrah_ekran = salary; // ekledi sadece arayuzde matrah olarak adamin maasi gozuksun diye deniyor?
		ssk_isveren_hissesi_isci_gelen = extra; //SG ekledi 20130430
		
		if((isdefined("kisa_calisma") and kisa_calisma eq 1) or (isdefined("short_working_calc") and len(short_working_calc)))
		{
			bes_isci_hissesi = fix((salary)/100 * bes_isci_carpan);
		}
		else
			bes_isci_hissesi = fix((salary - salary_taban_fark_)/100 * bes_isci_carpan);
	}
	else
	{
        
		/*<!--- ssk_isveren_hissesi = wrk_round((ssk_matrah/100) * ssk_isveren_carpan );
		ssk_isci_hissesi = wrk_round((ssk_matrah/100) * ssk_isci_carpan);
		issizlik_isveren_hissesi = wrk_round( (ssk_matrah/100) * issizlik_isveren_carpan );
		issizlik_isci_hissesi = wrk_round((ssk_matrah/100) * issizlik_isci_carpan); --->*/
		if(salary_taban_fark_ gt 0)
		{
			extra = (salary_taban_fark_)/100 * ssk_isci_carpan;
			extra_2 = (salary_taban_fark_)/100 * issizlik_isci_carpan;

			extra_health = (salary_taban_fark_)/100 * health_insurance_premium_employer_ratio;
			extra_death = (salary_taban_fark_)/100 * death_insurance_premium_employer_ratio;
			extra_short = (salary_taban_fark_)/100 * short_term_premium_ratio;
		}
		else
		{
			extra = 0;
			extra_2 = 0;

			extra_health = 0;
			extra_death = 0;
			extra_short = 0;
		}
		ssk_isveren_hissesi_isci_gelen = extra;
		ssk_isveren_hissesi = extra + wrk_round(((ssk_matrah)/100) * ssk_isveren_carpan);
		ssk_isveren_hissesi_gelen = extra + wrk_round(((SSK_MATRAH_GELEN)/100) * ssk_isveren_carpan);
		ssk_isci_hissesi = wrk_round(((ssk_matrah - salary_taban_fark_)/100) * ssk_isci_carpan);
		issizlik_isveren_hissesi = extra_2 + wrk_round( ((ssk_matrah)/100) * issizlik_isveren_carpan );
		issizlik_isci_hissesi = wrk_round(((ssk_matrah - salary_taban_fark_)/100) * issizlik_isci_carpan);
		if((isdefined("kisa_calisma") and kisa_calisma eq 1) or (isdefined("short_working_calc") and len(short_working_calc)))
		{
			bes_isci_hissesi = fix((ssk_matrah)/100 * bes_isci_carpan);
		}
		else
			bes_isci_hissesi = fix((ssk_matrah - salary_taban_fark_)/100 * bes_isci_carpan);

		health_insurance_premium_worker = wrk_round(((ssk_matrah - salary_taban_fark_)/100) * health_insurance_premium_worker_ratio); //Hastalık Sigorta Primi İşçi
		death_insurance_premium_worker =wrk_round(((ssk_matrah - salary_taban_fark_)/100) * death_insurance_premium_worker_ratio);//Malülük, Yaşlılık, Ölüm Sigorta Primi İşçi

		health_insurance_premium_employer = extra_health + wrk_round(((ssk_matrah)/100) * health_insurance_premium_employer_ratio) ; //Hastalık Sigorta Primi İşveren
		death_insurance_premium_employer = extra_death + wrk_round(((ssk_matrah)/100) * death_insurance_premium_employer_ratio);//Malülük, Yaşlılık, Ölüm Sigorta Primi İşveren
		short_term_premium_employer = extra_short + wrk_round(((ssk_matrah)/100) * short_term_premium_ratio) ;//Kısa Vadeli Sigorta Kolları Prim
	}
	
	if(total_pay_ssk_tax_noissizlik gt 0)
	{
		issizlik_isci_hissesi_fark = wrk_round((total_pay_ssk_tax_noissizlik/100) * issizlik_isci_carpan);
		issizlik_isci_hissesi = issizlik_isci_hissesi - issizlik_isci_hissesi_fark;
	}
    

	if(total_pay_ssk gt 0)
	{
		if(isdefined("ilk_salary_temp"))
			temp_salary_ = ilk_salary_temp;
		else if(isdefined("ilk_salary"))
			temp_salary_ = ilk_salary;
		if(isdefined("temp_salary_"))//net ücretse çalışacak
		{
			if(temp_salary_ gt ssk_matrah_tavan) // normal kazanç tavandan büyükse
				total_pay_ssk_ = 0;
			else if(temp_salary_+total_pay_ssk gt ssk_matrah_tavan)	//normal kazanç ve ödeneklerin toplamı tavandan büyükse
				total_pay_ssk_ = ssk_matrah_tavan - temp_salary_;
			else
				total_pay_ssk_ = total_pay_ssk;
		}
		else
			total_pay_ssk_ = total_pay_ssk;
		ssk_isci_hissesi_odenek_fark = wrk_round((total_pay_ssk_/100) * ssk_isci_carpan);
		ssk_isci_hissesi_odenek_fark = ssk_isci_hissesi_odenek_fark + (wrk_round((total_pay_ssk_/100) * issizlik_isci_carpan));
	}
}
	
if (get_hr_ssk.SSK_STATUTE neq 2 and total_pay_ssk_noissizlik gt 0)
{
	ssk_isveren_hissesi = ssk_isveren_hissesi ; //+ total_pay_ssk_noissizlik_ssk_isveren_pay // bu hicbiryerden set edilmiyor 
	ssk_isveren_hissesi_gelen = ssk_isveren_hissesi_gelen;
	ssk_issizlik_isveren_hissesi = ssk_isci_hissesi + total_pay_ssk_noissizlik_ssk_isci_pay;
	SSK_MATRAH = SSK_MATRAH + total_pay_ssk_noissizlik;
}

if(get_hr_ssk.use_ssk eq 3)
{
	issizlik_isci_hissesi = 0;
	ssk_isveren_hissesi = 0;	
	ssk_isveren_hissesi_gelen = 0;
}
//brut ucretten kesinti
if(is_devir_matrah_off eq 0 and ozel_kesinti_2 gt 0)
{
	salary = salary - ozel_kesinti_2;
}
	
if(matrah_fark_ozel_kesinti_2 gt 0)
{
	net_fark_ozel_kesinti_2 = wrk_round(matrah_fark_ozel_kesinti_2 * (ssk_isci_carpan + issizlik_isci_carpan) / 100); 
	bes_isci_hissesi_net_fark = fix(matrah_fark_ozel_kesinti_2 /100 * bes_isci_carpan);
	isveren_fark_ozel_kesinti_2 = wrk_round(matrah_fark_ozel_kesinti_2 * ssk_isveren_carpan / 100);
	
	net_fark_ozel_kesinti_2 = net_fark_ozel_kesinti_2 + bes_isci_hissesi_net_fark;
}
else
{
	isveren_fark_ozel_kesinti_2 = 0;
}

// 5084 lü şube ise ssk_isci_hisseleri değişir
if (get_hr_salary.salary_type eq 2)
	gun = ssk_days;
else
	gun = work_days;
		
ssk_isveren_hissesi_pay = 0;

	if(not listfindnocase(get_hr_ssk.LAW_NUMBERS,'5921'))// 5921 den yararlanmiyor ise bu oran düser
	{
		if (get_hr_ssk.is_5084 eq 1) // çalışan da 5084 e dahil olmalı
		{
			if(ssk_matrah gt salary)
			{
				/*<!--- extra = ((ssk_matrah - salary)/100) * ssk_isci_carpan; SG kapattı 20130430--->*/
				
				if(salary_taban_fark_ gt 0)
				{
					extra = (salary_taban_fark_)/100 * ssk_isci_carpan;
					extra_2 = (salary_taban_fark_)/100 * issizlik_isci_carpan;
				}
				else
				{
					extra = 0;
					extra_2 = 0;
				}
				ssk_isveren_hissesi = wrk_round( extra + ((ssk_matrah/100) * ssk_isveren_carpan) );
				if(gun gt ssk_full_days)
					ssk_isveren_hissesi_pay = ssk_asgari_ucret * (ssk_isveren_carpan / 100) * (get_hr_ssk.KANUN_5084_ORAN / 100);
				else
					ssk_isveren_hissesi_pay = (ssk_asgari_ucret * gun/ssk_full_days) * (ssk_isveren_carpan / 100) * (get_hr_ssk.KANUN_5084_ORAN / 100);

				ssk_isveren_hissesi = (ssk_isveren_hissesi - ssk_isveren_hissesi_pay);
			}
			else
			{
				if(salary_taban_fark_ gt 0)
				{
					extra = (salary_taban_fark_)/100 * ssk_isci_carpan;
					extra_2 = (salary_taban_fark_)/100 * issizlik_isci_carpan;
				}
				else
				{
					extra = 0;
					extra_2 = 0;
				}
				ssk_isveren_hissesi = extra + (SSK_MATRAH/100) * ssk_isveren_carpan;			
				/*<!--- ssk_isveren_hissesi = (SSK_MATRAH/100) * ssk_isveren_carpan; SG kapattı 20130430--->*/
				if(gun gt ssk_full_days)
					ssk_isveren_hissesi_pay = ssk_asgari_ucret * (ssk_isveren_carpan / 100) * (get_hr_ssk.KANUN_5084_ORAN / 100);
				else
					ssk_isveren_hissesi_pay = (ssk_asgari_ucret * gun/ssk_full_days) * (ssk_isveren_carpan / 100) * (get_hr_ssk.KANUN_5084_ORAN / 100);
	
				ssk_isveren_hissesi = (ssk_isveren_hissesi - ssk_isveren_hissesi_pay);
			}
		}
		else
		{
			ssk_isveren_hissesi_pay  = 0;
		}
	}

// ssk kullanmıyor ise ssk ödemeleri sıfırlanır
	if (get_hr_ssk.use_ssk eq 3) 
	{
		ssdf_isci_hissesi = 0;
		ssdf_isveren_hissesi = 0;
		ssk_isci_hissesi = 0;
		issizlik_isci_hissesi = 0; 
		ssk_isveren_hissesi = 0;
		ssk_isveren_hissesi_gelen = 0;
		issizlik_isveren_hissesi = 0; 
		SSK_MATRAH = 0;
		ssk_matrah_ekran = 0;
		
		bes_isci_hissesi = 0;

		health_insurance_premium_worker = 0; //Hastalık Sigorta Primi İşçi
		death_insurance_premium_worker = 0;//Malülük, Yaşlılık, Ölüm Sigorta Primi İşçi

		health_insurance_premium_employer = 0; //Hastalık Sigorta Primi İşveren
		hort_term_premium_employer = 0;//Kısa Vadeli Sigorta Kolları Prim İşveren
		death_insurance_premium_employer = 0;//Malülük, Yaşlılık, Ölüm Sigorta Primi İşveren
	}
	if(ssk_matrah_kullanilan gt 0 and get_hr_ssk.gross_net eq 1 and ssk_matrah gt 0)
	{
	if(get_hr_ssk.SSK_STATUTE eq 2 or get_hr_ssk.SSK_STATUTE eq 18)
		{
			ssk_isci_hissesi_dusulecek = ssdf_isci_hissesi / ssk_matrah * ssk_matrah_kullanilan;
			ssdf_isci_hissesi = ssdf_isci_hissesi - ssk_isci_hissesi_dusulecek;
		}
		else
		{	
			ssk_isci_hissesi_dusulecek = ssk_isci_hissesi / ssk_matrah * ssk_matrah_kullanilan;
			issizlik_isci_hissesi_dusulecek = issizlik_isci_hissesi / ssk_matrah * ssk_matrah_kullanilan;
			ssk_isci_hissesi = ssk_isci_hissesi - ssk_isci_hissesi_dusulecek;
			issizlik_isci_hissesi = issizlik_isci_hissesi - issizlik_isci_hissesi_dusulecek;
		}
	}
	//6322 kanun kapsamında isci_hissesinden dusulecek tutar SG 20130916
	//6.bölge
	if(ssk_days gt 0 and len(get_hr_ssk.KANUN_6322) and get_hr_ssk.KANUN_6322 eq 2 and get_hr_ssk.IS_6322 eq 1 and get_hr_ssk.SSK_STATUTE neq 2 and get_hr_ssk.SSK_STATUTE neq 3 and get_hr_ssk.SUBE_IS_5510 eq 1)
	{
		ssk_isci_hissesi_6322 = (get_insurance.MIN_GROSS_PAYMENT_NORMAL * ssk_isci_carpan / 100);
		if(ssk_days eq 31)
			ssk_isci_hissesi_6322 = ssk_isci_hissesi_6322;
		else
			ssk_isci_hissesi_6322 = ssk_isci_hissesi_6322 * ceiling(ssk_days) / 30;
	}
	else // 1-5 bölgelerde bu deger 0 hesaplanmaz
	{
		ssk_isci_hissesi_6322 = 0;
	}
	
	bes_isci_hissesi =  bes_isci_hissesi;
	//ssk_isci_hissesi = ssk_isci_hissesi - ssk_isci_hissesi_dusulecek_; // 6322 kanun kapsamında isci hissesinden dusulecek
	ssk_isci_hissesi =  ssk_isci_hissesi;
	salary =  salary - matrah_farki_;  /*<!--- SG 20130430--->	*/
	salary = salary - vergi_istisna_ssk - salary_taban_fark_ + (ssk_matraha_dahil_olmayan_odenek_tutar) - ssk_matrah_devirden_gelen; // ozel saglik ve bireysel emeklilik icin ve ssk devir matrahdan dolayi eklenen tutar burada geri dusulur....

	gecen_aydan_dusulecek = 0;
	onceki_aydan_dusulecek = 0;
// gelir vergisi matrahı hesaplanır
	if(get_hr_ssk.IS_TAX_FREE eq 1 and is_included_in_tax eq 0 and included_in_tax_paid_amount_brut eq 0 and total_pay_ssk_tax eq 0)
	{
		gelir_vergisi_matrah = 0;
		gelir_vergisi = 0;
		vergi_indirim_5084 = 0;
		tax_ratio = 0;
		v1 = 0; // gelir vergisi 0 oldugu icin gelir vergisi birinci carpani 0 olmalidir
		salary = salary + total_pay_tax + attributes.ihbar_amount + vergi_istisna_vergi_tutar;
	}	
	else
	{
		// ssk ödeneği vergi hesabına dahil edilmez vergi kesintisi sonrası tekrar eklenir erk 20030911
		salary = salary + total_pay_tax + attributes.ihbar_amount + vergi_istisna_vergi_tutar;
		if(use_ssk neq 2 or (use_ssk eq 2 and (attributes.statue_type eq 6 or attributes.statue_type eq 7 or attributes.statue_type eq 9 or attributes.statue_type eq 10)))
		{
			if(get_hr_ssk.IS_TAX_FREE eq 1 and (get_hr_salary.gross_net eq 1 or (get_hr_salary.gross_net eq 0 and is_included_in_tax eq 0)))
			{
				if(isdefined("is_gov_payroll") and is_gov_payroll eq 1)
				{
					ssk_isci_hissesi_odenek_fark = 0;
					gelir_vergisi_matrah = salary + net_fark_ozel_kesinti_2 - ext_salary_gross - (vergi_istisna_damga_tutar-vergi_istisna_damga_tutar_net) - (temp_vergi_istisna_damga_tutar_hs-((vergi_istisna_damga_tutar-temp_vergi_istisna_damga_tutar_hs)-(vergi_istisna_damga_tutar_net-temp_vergi_istisna_damga_tutar_hs_net))+ssdf_isci_hissesi + ssk_isci_hissesi + issizlik_isci_hissesi + sakatlik_indirimi  + sendika_indirimi + total_pay_ssk - ssk_isci_hissesi_odenek_fark + (vergi_matraha_dahil_olmayan_odenek_tutar - ozel_kesinti_gelir_dahil_olmayan_tutar) + vergi_matraha_dahil_olmayan_kesinti_tutar + ((kazanca_dahil_olan_odenek_tutar_muaf) * 15 /100));
				}
				else
				{
					//Çalışan gv den muaf fakat muaf olmayan ek ödeneği varsa ödeneğin işçi işsizliğini bulur
					if(is_payment_exemption eq 1)
					{
						net_odenek_ssk_isci_hissesi = net_odenek_ssk_isci_hissesi + ssk_isci_hissesi - maas_ssk_isci_hissesi_ - onceki_odenek_isci_toplam;
						net_odenek_ssk_issizlik_hissesi = net_odenek_ssk_issizlik_hissesi + issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - onceki_odenek_isci_issizlik_toplam;
					}
					gelir_vergisi_matrah = salary - brut_salary + net_fark_ozel_kesinti_2  - ext_salary_gross - (vergi_istisna_damga_tutar-vergi_istisna_damga_tutar_net) - (temp_vergi_istisna_damga_tutar_hs-((vergi_istisna_damga_tutar-temp_vergi_istisna_damga_tutar_hs)-(vergi_istisna_damga_tutar_net-temp_vergi_istisna_damga_tutar_hs_net)) + sakatlik_indirimi  + sendika_indirimi + total_pay_ssk + (vergi_matraha_dahil_olmayan_odenek_tutar - ozel_kesinti_gelir_dahil_olmayan_tutar) + vergi_matraha_dahil_olmayan_kesinti_tutar)+kazanca_dahil_olan_odenek_tutar_muaf - (net_odenek_ssk_isci_hissesi + net_odenek_ssk_issizlik_hissesi + net_odenek_ssdf_isci_hissesi ) + included_in_tax_paid_amount_brut_base + gelir_vergisi_matrah_include_tax;				
					
    writeoutput("salary: #salary# gelir_vergisi_matrah: #gelir_vergisi_matrah# vergi_istisna: #vergi_istisna#<br>")

					//writeOutput("gelir_vergisi_matrah: #gelir_vergisi_matrah# = #salary# - #brut_salary# + #net_fark_ozel_kesinti_2#  - (vergi_istisna_damga_tutar-vergi_istisna_damga_tutar_net)  - (#temp_vergi_istisna_damga_tutar_hs#-((#vergi_istisna_damga_tutar#-#temp_vergi_istisna_damga_tutar_hs#)-(#vergi_istisna_damga_tutar_net#-#temp_vergi_istisna_damga_tutar_hs_net#))+#ssdf_isci_hissesi# + #ssk_isci_hissesi# + #issizlik_isci_hissesi# + #sakatlik_indirimi#  + #sendika_indirimi# + #total_pay_ssk# - #total_pay_ssk_untax_diff# + (#vergi_matraha_dahil_olmayan_odenek_tutar# - #ozel_kesinti_gelir_dahil_olmayan_tutar#) + #vergi_matraha_dahil_olmayan_kesinti_tutar#)+#kazanca_dahil_olan_odenek_tutar_muaf#;- (#net_odenek_ssk_isci_hissesi# + #net_odenek_ssk_issizlik_hissesi# + #net_odenek_ssdf_isci_hissesi# + #net_odenek_ssdf_isveren_hissesi#) + #included_in_tax_paid_amount_brut_base#<br>");

					//QuerySetCell(get_hr_ssk,'IS_TAX_FREE','0');
				}
			}
			else
			{
				//gelir_vergisi_matrah = salary - (vergi_istisna_damga_tutar-vergi_istisna_damga_tutar_net) - (temp_vergi_istisna_damga_tutar_hs-((vergi_istisna_damga_tutar-temp_vergi_istisna_damga_tutar_hs)-(vergi_istisna_damga_tutar_net-temp_vergi_istisna_damga_tutar_hs_net))+ssdf_isci_hissesi + ssk_isci_hissesi + issizlik_isci_hissesi + sakatlik_indirimi  + sendika_indirimi + total_pay_ssk + vergi_matraha_dahil_olmayan_odenek_tutar + vergi_matraha_dahil_olmayan_kesinti_tutar)+kazanca_dahil_olan_odenek_tutar_muaf;
				if(salary eq ssk_asgari_ucret and sakatlik_indirimi gt 0)
					gelir_vergisi_matrah = salary + net_fark_ozel_kesinti_2  - (vergi_istisna_damga_tutar-vergi_istisna_damga_tutar_net)  - (temp_vergi_istisna_damga_tutar_hs-((vergi_istisna_damga_tutar-temp_vergi_istisna_damga_tutar_hs)-(vergi_istisna_damga_tutar_net-temp_vergi_istisna_damga_tutar_hs_net))+ssdf_isci_hissesi + ssk_isci_hissesi + issizlik_isci_hissesi  + sendika_indirimi + (total_pay_ssk - total_pay_ssk_untax_diff) + (vergi_matraha_dahil_olmayan_odenek_tutar - ozel_kesinti_gelir_dahil_olmayan_tutar) + vergi_matraha_dahil_olmayan_kesinti_tutar + ext_salary_diff)+kazanca_dahil_olan_odenek_tutar_muaf + gelir_vergisi_matrah_include_tax;
				else
					gelir_vergisi_matrah = salary + net_fark_ozel_kesinti_2  - (vergi_istisna_damga_tutar-vergi_istisna_damga_tutar_net) - (temp_vergi_istisna_damga_tutar_hs-((vergi_istisna_damga_tutar-temp_vergi_istisna_damga_tutar_hs)-(vergi_istisna_damga_tutar_net-temp_vergi_istisna_damga_tutar_hs_net))+ssdf_isci_hissesi + ssk_isci_hissesi + issizlik_isci_hissesi + sakatlik_indirimi  + sendika_indirimi + (total_pay_ssk - total_pay_ssk_untax_diff) + (vergi_matraha_dahil_olmayan_odenek_tutar - ozel_kesinti_gelir_dahil_olmayan_tutar) + vergi_matraha_dahil_olmayan_kesinti_tutar + ext_salary_diff)+kazanca_dahil_olan_odenek_tutar_muaf + gelir_vergisi_matrah_include_tax;
					//writeOutput("gelir_vergisi_matrah: #gelir_vergisi_matrah# = #salary#  + #net_fark_ozel_kesinti_2#  - (vergi_istisna_damga_tutar-vergi_istisna_damga_tutar_net)  - (#temp_vergi_istisna_damga_tutar_hs#-((#vergi_istisna_damga_tutar#-#temp_vergi_istisna_damga_tutar_hs#)-(#vergi_istisna_damga_tutar_net#-#temp_vergi_istisna_damga_tutar_hs_net#))+#ssdf_isci_hissesi# + #ssk_isci_hissesi# + #issizlik_isci_hissesi# + #sakatlik_indirimi#  + #sendika_indirimi# + #total_pay_ssk# - #total_pay_ssk_untax_diff# + (#vergi_matraha_dahil_olmayan_odenek_tutar# - #ozel_kesinti_gelir_dahil_olmayan_tutar#) + #vergi_matraha_dahil_olmayan_kesinti_tutar#)+#kazanca_dahil_olan_odenek_tutar_muaf#;<br>");
                    
			}

			
		}
		else if(use_ssk eq 2 and get_hr_ssk.administrative_academic eq 2)
		{
			//Tüm ay ücretsiz izinliyse
			if(isdefined("unpaid_offtime") and unpaid_offtime gt 0 and unpaid_offtime / get_hours.ssk_work_hours eq aydaki_gun_sayisi)
				gelir_vergisi_matrah = 0;
			else
				gelir_vergisi_matrah =  retired_academic;
		}
		else{
			//Tüm ay ücretsiz izinliyse
			if(isdefined("unpaid_offtime") and unpaid_offtime gt 0 and unpaid_offtime / get_hours.ssk_work_hours eq aydaki_gun_sayisi)
				gelir_vergisi_matrah = 0;
			else if(get_hr_ssk.duty_type eq 4 and get_hr_ssk.administrative_academic eq 1)//Memur ve sözleşmeliyse
			{
				//(aylık ücret + taban aylık + ek gösterge + kıdem aylık - Emekli keseneği kişi)
				gelir_vergisi_matrah = officer_salary + base_salary + severance_pension + additional_indicators - retirement_allowance_personal - retirement_allowance_personal_5510;
			}
			else
			{
				/* Aylık Tutar + Ek Gösterge +Taban Aylık + Kıdem Aylığı + Yan Ödeme + İdari Görev Ödeneği– Emekli Keseneği Malul Yaşlı Kişi Payı (%16 veya %9) - Sağlık Sigortası Primi Kişi %5 –Emekli Sandığı Hizmet Borçlanması - Özel Sigorta - Engellilik İndirimi - Toplu Sözleşme İkramiyesi) x Gelir Vergisi Oranı  */
				gelir_vergisi_matrah = officer_salary +  additional_indicators + base_salary + business_risk + severance_pension + administrative_duty_allowance - retirement_allowance_personal_5510 - retirement_allowance_personal - health_insurance_premium_personal_5510 - net_fark_ozel_kesinti_2 - collective_agreement_bonus - (vergi_istisna_damga_tutar-vergi_istisna_damga_tutar_net);
			}
			if(len(get_hr_ssk.finish_date))
				gelir_vergisi_matrah = gelir_vergisi_matrah * work_days / ssk_full_days;
		}
		gelir_vergisi_matrah = gelir_vergisi_matrah - ssk_matrah_devirden_gelen_ssk;
		if(total_pay_ssk_noissizlik gt 0)
			gelir_vergisi_matrah =  gelir_vergisi_matrah + total_pay_ssk_noissizlik_ssk_isci_pay;
		}
	// özel indirim tutarı vergi matrahını geçemez erk 20040420
	if (gelir_vergisi_matrah lt 0) 
	{
		sakatlik_indirimi = salary - (ssdf_isci_hissesi + ssk_isci_hissesi + issizlik_isci_hissesi + sendika_indirimi + vergi_istisna);
		gelir_vergisi_matrah = salary - (ssdf_isci_hissesi + ssk_isci_hissesi + issizlik_isci_hissesi + sendika_indirimi  + vergi_istisna + sakatlik_indirimi + total_pay_ssk - ssk_isci_hissesi_odenek_fark);
		//gelir_vergisi_matrah = gelir_vergisi_matrah - ssk_matrah_devirden_gelen_ssk;
	}
	
	// işten çıkarmada kullanılıyor erk 20030922	
	gvm_ihbar = attributes.ihbar_amount; 
	if (ssk_matrah_salary neq 0 and ssk_matrah neq 0)
	{
		if (SSDF_ISCI_HISSESI neq 0) // emekli ise
			gvm_izin = attributes.yillik_izin_amount - (SSDF_ISCI_HISSESI * (ssk_matrah_salary / ssk_matrah));
		else if (SSK_ISCI_HISSESI neq 0)
			gvm_izin = attributes.yillik_izin_amount - (SSK_ISCI_HISSESI * (ssk_matrah_salary / ssk_matrah));
		else
			gvm_izin = attributes.yillik_izin_amount;
	}
	else
		gvm_izin = attributes.yillik_izin_amount;
	
	// gelir vergisi hesaplanır	
	if((get_hr_ssk.SSK_STATUTE eq 4 or get_hr_ssk.SSK_STATUTE eq 75) and ((get_hr_ssk.is_tax_free neq 1 and get_hr_ssk.IS_DAMGA_FREE neq 1) or is_included_in_tax eq 1))
	{
		asgari_ucret_orani_ = ssk_asgari_ucret;
		if(salary gt asgari_ucret_orani_)
		{
			if(get_hr_ssk.gross_net eq 0)
			{
				damga_vergisi = 0;
				gelir_vergisi = 0;
				tax_ratio = 0.15;
			}
			salary = salary - damga_vergisi - gelir_vergisi;		
			gelir_vergisi_matrah = salary - asgari_ucret_orani_;				
			is_damga_zero = 0;				
			gelir_vergisi =  gelir_vergisi_matrah * tax_ratio;
			damga_vergisi = (gelir_vergisi_matrah * get_active_program_parameter.STAMP_TAX_BINDE) / 1000;
			if(year(last_month_1) gte 2022 and damga_vergisi gt 0)
				damga_vergisi = damga_vergisi - daily_minimum_wage_stamp_tax;
			salary = salary + gelir_vergisi + damga_vergisi;
		}
		else
		{
			gelir_vergisi_matrah = 0;
			damga_vergisi_matrah = 0;
			salary = salary - wrk_round(gelir_vergisi) - wrk_round(damga_vergisi);
			is_damga_zero = 1;
		}
	}
	else
	{
		is_damga_zero = 0;		
	}

	vergi_indirim_5084 = 0;
	//if (attributes.sal_year lt 2022 or get_hr_ssk.SSK_STATUTE eq 2) // stajyer-cirak ise vergi yok // herkese hesaplaniyor 05102009 yo
	{	
		gelir_vergisi_matrah = gelir_vergisi_matrah - vergi_istisna;
		temp_gelir_vergisi_matrah = gelir_vergisi_matrah;
		gelir_vergisi = 0;
		tax_ratio = get_active_tax_slice.RATIO_1;
		s1 = get_active_tax_slice.MAX_PAYMENT_1;	v1 = get_active_tax_slice.RATIO_1 / 100;
		s2 = get_active_tax_slice.MAX_PAYMENT_2;	v2 = get_active_tax_slice.RATIO_2 / 100;
		s3 = get_active_tax_slice.MAX_PAYMENT_3;	v3 = get_active_tax_slice.RATIO_3 / 100;
		s4 = get_active_tax_slice.MAX_PAYMENT_4;	v4 = get_active_tax_slice.RATIO_4 / 100;
		s5 = get_active_tax_slice.MAX_PAYMENT_5;	v5 = get_active_tax_slice.RATIO_5 / 100;
		s6 = get_active_tax_slice.MAX_PAYMENT_6;	v6 = get_active_tax_slice.RATIO_6 / 100;

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
				gelir_vergisi = gelir_vergisi + ((gelir_vergisi_matrah) * v4);
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
			{//buraya giriyor
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
		if (gelir_vergisi_matrah)
			tax_ratio = (gelir_vergisi / gelir_vergisi_matrah);
		else
			tax_ratio = 0;
		if (gelir_vergisi_matrah lt 0) gelir_vergisi_matrah = 0;

		//2022
		if(attributes.sal_year gte 2022 and use_ssk neq 2 and use_minimum_wage neq 1 and daily_minimum_wage_base gt 0)
		{
			income_tax_temp = gelir_vergisi;
			if(wrk_round(salary) eq wrk_round(control_daily_minimum_wage) and not(get_hr_ssk.SSK_STATUTE eq 2 or get_hr_ssk.SSK_STATUTE eq 18) and tax_carpan eq v1)
			{
				if(wrk_round(gelir_vergisi_matrah)-wrk_round(temp_daily_minimum_wage_base) lte 0 and temp_daily_minimum_wage_base eq daily_minimum_wage_base)
					gelir_vergisi_matrah_temp = gelir_vergisi_matrah;
				gelir_vergisi = 0;
				gelir_vergisi_matrah = 0;
			}

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

			if(gelir_vergisi gte daily_minimum_income_tax)
				gelir_vergisi = gelir_vergisi - daily_minimum_income_tax;
			else
				gelir_vergisi = 0;

			if(daily_minimum_wage_base eq temp_daily_minimum_wage_base)
				temp_first_min_wage = daily_minimum_income_tax;

			if(income_tax_temp gte daily_minimum_income_tax)
				income_tax_temp = daily_minimum_income_tax;
				
        } 
        writeoutput("gelir_vergisi_matrah: #gelir_vergisi_matrah# daily_minimum_income_tax: #daily_minimum_income_tax# income_tax_temp: #income_tax_temp#<br>");

	
		if(is_included_in_tax eq 1){
			gelir_vergisi_matrah_include_tax = gelir_vergisi_matrah;
		}
		if(not isdefined("maas_tax_carpan")) maas_tax_carpan= tax_carpan;
		get_tax_carpan=cfquery(datasource:"#DSN#",sqlstring:"SELECT TOP 1 EPR2.TAX_RATIO FROM EMPLOYEES_PUANTAJ_ROWS EPR2,EMPLOYEES_PUANTAJ EP2 WHERE EP2.PUANTAJ_TYPE = #attributes.puantaj_type# AND EP2.PUANTAJ_ID = EPR2.PUANTAJ_ID AND EPR2.IN_OUT_ID = #attributes.in_out_id# AND (EP2.SAL_YEAR = #attributes.sal_year# AND EP2.SAL_MON < #attributes.sal_mon#) ORDER BY EP2.SAL_MON DESC");
		if(get_tax_carpan.recordcount) maas_tax_carpan = get_tax_carpan.TAX_RATIO; else maas_tax_carpan = 0.15;//Eğer mevcut aydan önce çalışanın puantajı varsa o ayın oranını , yoksa default 0.15 atıyor
		//gelir_vergisi = gelir_vergisi - (vergi_istisna * maas_tax_carpan);	
		/* 
		if(vergi_istisna_vergi_tutar gt 0)
		{
			gelir_vergisi_fark = gelir_vergisi - gelir_vergisi_ozel;
			gelir_vergisi_matrah = gelir_vergisi_matrah_ozel;
			gelir_vergisi = gelir_vergisi_ozel;
		}
		 */
		if ((get_hr_ssk.IS_5615 eq 1 or get_hr_ssk.is_5084 eq 1) and get_hr_ssk.SSK_STATUTE eq 1 and get_hr_ssk.USE_SSK eq 1)
		{
			/*20050110 asgari ucrete ait vergi matrahindan ve ilk vergi diliminden hesaplaniyor*/
			asgari_ucret_vergi = v1*((ssk_asgari_ucret*(100-ssk_isci_carpan-issizlik_isci_carpan))/100);
			vergi_indirim_5084 = (gun/ssk_full_days)*asgari_ucret_vergi*(get_hr_ssk.KANUN_5084_ORAN/100);
			/*vergi_indirim_5084 = (gelir_vergisi * get_hr_ssk.KANUN_5084_ORAN/100);*/
		}

		if(vergi_indirim_5084 gt 0 and get_hr_ssk.IS_5615_TAX_OFF eq 1) // vergi indirimi kapalı
			vergi_indirim_5084 = 0;
		
		gelir_vergisi_ilk_gelen = gelir_vergisi;
		
		if(get_hr_ssk.is_discount_off neq 1)
		{
			if(asgari_gecim_max_tutar_ gt gelir_vergisi_ilk_gelen)
				asgari_gecim_max_tutar_ = gelir_vergisi_ilk_gelen;
		}
		//if(get_hr_ssk.is_5084 eq 1) -- eskiden calisana bakiyordu simdi subeye bakiyor
		if (get_hr_ssk.IS_5615 eq 1 and get_hr_ssk.SSK_STATUTE eq 1 and get_hr_ssk.USE_SSK eq 1)
		{
			gelir_vergisi = gelir_vergisi - vergi_indirim_5084;
			if(gelir_vergisi lt 0)
			{
				gelir_vergisi = gelir_vergisi +	vergi_indirim_5084;
				gelir_vergisi_vergi = v1*((gelir_vergisi*(100-ssk_isci_carpan-issizlik_isci_carpan))/100);
				vergi_indirim_5084 = (gun/ssk_full_days)*gelir_vergisi*(get_hr_ssk.KANUN_5084_ORAN/100);
				gelir_vergisi = gelir_vergisi - vergi_indirim_5084;
			}
		}
		if(get_hr_ssk.is_discount_off eq 1 or (isdefined("attributes.statue_type") and attributes.statue_type eq 9))
		{
			asgari_gecim_indirimi_ilk_ = 0;
			asgari_gecim_indirimi_ = 0;
			//asgari gecimden yararlanmayacaklara simdilik bisiy yapmiyoruz
		}
		else
		{
			if((this_cast_style_ eq 1 or this_cast_style_ eq 2) and get_hr_ssk.administrative_academic neq 2)
			{ 
				asgari_gecim_indirimi_ilk_ = (asgari_ucret_ * asgari_gecim_indirimi_yuzdesi_ / 100) * v1;
				kisi_maximum_agi_tutari_ = asgari_gecim_indirimi_ilk_;
				kisi_maximum_agi_tutari_ = kisi_maximum_agi_tutari_ - dusulecek_agi_;
				if(isdefined("asgari_gecim_indirimi_yuzdesi_") and asgari_gecim_indirimi_yuzdesi_ gt 0)
				{
					asgari_gecim_indirimi_ = (asgari_ucret_ * asgari_gecim_indirimi_yuzdesi_ / 100) * v1;				
					if(asgari_gecim_indirimi_ gt gelir_vergisi_ilk_gelen)
						asgari_gecim_indirimi_ = gelir_vergisi_ilk_gelen;
					
					if(asgari_gecim_indirimi_ gt kisi_maximum_agi_tutari_)
						asgari_gecim_indirimi_ = kisi_maximum_agi_tutari_;
					
					if(for_ssk_day eq 1)
						asgari_gecim_indirimi_ = asgari_gecim_indirimi_ / 30 * ssk_days;
					//Çalışanın eski çalıştığı yerden agisi yatırıldıysa.(ücret kartından giriliyor)

					if(len(vergi_iadesi) and len(get_hr_ssk.PAST_AGI_DAY)){
						past_agi_control = new Query(datasource="#dsn#", sql="SELECT EMPLOYEE_PUANTAJ_ID FROM EMPLOYEES_PUANTAJ_ROWS WHERE EMPLOYEE_ID = #get_hr_ssk.employee_id# AND IN_OUT_ID = #get_hr_ssk.in_out_id#").execute().getResult();
						if(past_agi_control.recordcount eq 0)//yapılan ilk bordroysa
						{
							asgari_gecim_indirimi_ = asgari_gecim_indirimi_ - get_hr_ssk.PAST_AGI_DAY;
							past_agi_day_payroll = get_hr_ssk.PAST_AGI_DAY;
						}
					}
					
					if(asgari_gecim_indirimi_ gt gelir_vergisi)
					{
						mahsup_edilecek_gelir_vergisi_ = asgari_gecim_indirimi_ - gelir_vergisi;
						gelir_vergisi = 0;
						vergi_iadesi = asgari_gecim_indirimi_;
					}
					else
					{
						gelir_vergisi = wrk_round(gelir_vergisi) - wrk_round(asgari_gecim_indirimi_);//;
						vergi_iadesi = asgari_gecim_indirimi_;
					}
				
				}
			}		
		}		
		if(gelir_vergisi lt 0)
			gelir_vergisi = 0;
	}	
	
	if(get_hr_ssk.is_discount_off neq 1 and isdefined("asgari_gecim_max_tutar_") and   isdefined("asgari_gecim_indirimi_") and (asgari_gecim_indirimi_ + vergi_indirim_5084) gt asgari_gecim_max_tutar_ and (get_hr_ssk.IS_5615 eq 1 or get_hr_ssk.is_5084 eq 1))
	{	 
		vergi_indirim_5084 = asgari_gecim_max_tutar_ - asgari_gecim_indirimi_;
		mahsup_edilecek_gelir_vergisi_ = (asgari_gecim_indirimi_ + vergi_indirim_5084) - asgari_gecim_max_tutar_;
		if(gelir_vergisi_ilk_gelen gt asgari_gecim_max_tutar_)
		{
			gelir_vergisi = gelir_vergisi_ilk_gelen - asgari_gecim_max_tutar_;
		}
	}
	
	if(isdefined("asgari_gecim_indirimi_") and asgari_gecim_indirimi_ gte gelir_vergisi_ilk_gelen and gelir_vergisi eq 0)
	{
		mahsup_edilecek_gelir_vergisi_ = 0;
		vergi_indirim_5084 = 0;
	}
		
	//if(is_devir_matrah_off eq 0)		
		salary = salary + attributes.kidem_amount  + total_pay_d;
	/*else
		salary = salary;*/
	if(use_ssk neq 2 or (use_ssk eq 2 and (attributes.statue_type eq 6 or attributes.statue_type eq 7 or attributes.statue_type eq 9 or attributes.statue_type eq 10)))
	{
		damga_vergisi_matrah = salary-temp_vergi_istisna_damga_tutar_hs + vergi_istisna_damga_tutar - (damga_matraha_dahil_olmayan_kesinti_tutar - ozel_kesinti_damga_dahil_olmayan_tutar) - total_pay_unstamped - ext_salary_gross - total_pay_ssk_tax_notstamp_base + damga_off_paidofftime_damga_matrah;

     
	//	writeOutput("damga_vergisi_matrah #damga_vergisi_matrah#= #salary#-#temp_vergi_istisna_damga_tutar_hs# + #vergi_istisna_damga_tutar# - (#damga_matraha_dahil_olmayan_kesinti_tutar# - #ozel_kesinti_damga_dahil_olmayan_tutar#) - #total_pay_unstamped# - #ext_salary_gross#;")
	//	writeoutput("#damga_vergisi_matrah# - #brut_salary# + #included_in_tax_paid_amount_brut#<br>")
		if(get_hr_ssk.is_damga_free eq 1 and get_hr_salary.gross_net eq 1)
        {
			damga_vergisi_matrah = damga_vergisi_matrah - brut_salary + included_in_tax_paid_amount_brut;
		}
		else if(get_hr_ssk.is_damga_free eq 1 and damga_vergisi_matrah gt brut_salary)
        {
			damga_vergisi_matrah = damga_vergisi_matrah - brut_salary;
		}

	

	/* 	if(included_in_tax_paid_amount_brut eq 0)
			damga_vergisi_matrah = salary-temp_vergi_istisna_damga_tutar_hs + vergi_istisna_damga_tutar - (damga_matraha_dahil_olmayan_kesinti_tutar - ozel_kesinti_damga_dahil_olmayan_tutar) - total_pay_unstamped - ext_salary_gross;
		else
			damga_vergisi_matrah = included_in_tax_paid_amount_brut; */

		
	}
	else if(use_ssk eq 2 and get_hr_ssk.administrative_academic eq 2)
	{
		damga_vergisi_matrah = retired_academic;
	}
	else
	{
		if(isdefined("unpaid_offtime") and unpaid_offtime gt 0 and unpaid_offtime / get_hours.ssk_work_hours eq aydaki_gun_sayisi)
			damga_vergisi_matrah = 0;
		else if(get_hr_ssk.duty_type eq 4 and get_hr_ssk.administrative_academic eq 1)//Memur, akademik ve sözleşmeliyse
		{
			//toplam kazanç – emekli keseneği kişi – genel sağlık sigortası;
			damga_vergisi_matrah = officer_total_salary - retirement_allowance_personal - general_health_insurance - retirement_allowance_personal_5510 - health_insurance_premium_personal_5510;
		}
		else
		{
			/* Aylık Tutar + Ek Gösterge + Taban Aylık + Kıdem Aylığı + Özel Hizmet Tazminatı + Yan Ödeme Tazminatı + Ek Ödeme Tazminatı + Denetim Tazminatı! + Makam Tazminatı + 
			Görev/Temsil Tazminatı + Üniversite Ödeneği + Eğitim Öğretim Ödeneği + Yabancı Dil Tazminatı +Yüksek Öğrenim Tazminatı + 
			İdari Görev Ödeneği +  ? Geliştirme Ödeneği + ? İkinci Görev Ödeneği + !Akademik Teşvik Ödeneği + ? Sendika Ödeneği  + Arazi Tazminatı*/
			damga_vergisi_matrah = officer_salary +  additional_indicators + base_salary + severance_pension + private_service_compensation + business_risk + additional_indicator_compensation_ + audit_compensation_amount + executive_indicator_compensation +
			administrative_compensation + university_allowance_payroll + education_allowance + language_allowance + high_education_compensation_payroll + administrative_duty_allowance + vergi_istisna_damga_tutar + academic_incentive_allowance_amount + collective_agreement_bonus + land_compensation_amount;
			if(len(get_hr_ssk.finish_date))
				damga_vergisi_matrah = damga_vergisi_matrah * work_days / ssk_full_days;
		}
	}

	damga_vergisi = ((damga_vergisi_matrah) * get_active_program_parameter.STAMP_TAX_BINDE) / 1000;

   
	
	//if(from_net eq 1)
		temp_stamp_tax_base = damga_vergisi_matrah;
	if(attributes.sal_year gte 2022 and use_ssk neq 2 and use_minimum_wage neq 1 and get_active_program_parameter.is_use_minimum_wage neq 1){
		stamp_tax_temp = damga_vergisi;
        /* if ( is_devir_matrah_off eq 0 )
            abort("damga_vergisi: #damga_vergisi# stamp_tax_temp: #stamp_tax_temp#"); */
		if(year(last_month_1) gte 2022 and wrk_round(salary) gte wrk_round(daily_minimum_wage) and use_ssk neq 2 and get_hr_salary.gross_net eq 1 and wrk_round(damga_vergisi_matrah) gte wrk_round(daily_minimum_wage))
		{
			damga_vergisi = (damga_vergisi_matrah - daily_minimum_wage) * get_active_program_parameter.STAMP_TAX_BINDE / 1000;
		}
		else if(year(last_month_1) gte 2022 and wrk_round(salary) gte wrk_round(daily_minimum_wage) and use_ssk neq 2 and wrk_round(damga_vergisi_matrah) gte wrk_round(daily_minimum_wage))
			damga_vergisi = damga_vergisi - daily_minimum_wage_stamp_tax;
		else if(is_included_in_tax eq 1 and damga_vergisi gt daily_minimum_wage_stamp_tax)
			damga_vergisi = damga_vergisi - daily_minimum_wage_stamp_tax;
		else if(year(last_month_1) gte 2022 and wrk_round(salary) lte wrk_round(daily_minimum_wage) and use_ssk neq 2)
		{
			/*Not : netten geldiğinde zaten çıkarma işlemi yaptığı için hata veriyor. Başka durum olursa bu göz önüne alıncak */
			/*
				if(total_used_stamp_tax gt damga_vergisi_matrah)
					total_used_stamp_tax = total_used_stamp_tax - damga_vergisi_matrah;
			*/
		
			damga_vergisi = 0;
		}
		else if(year(last_month_1) gte 2022 and wrk_round(damga_vergisi_matrah) lte wrk_round(daily_minimum_wage) and use_ssk neq 2)
		{
			damga_vergisi = 0;
		}
		else if(year(last_month_1) gte 2022 and wrk_round(salary) eq wrk_round(daily_minimum_wage) and use_ssk neq 2)
		{
			damga_vergisi_matrah = 0;
			damga_vergisi = 0;
			daily_minimum_wage_base = 0;
			all_basic_wage = 0;
			daily_minimum_income_tax = 0;
			daily_minimum_wage_stamp_tax = 0;
			daily_minimum_wage = 0;
		}
		
		if(stamp_tax_temp gte daily_minimum_wage_stamp_tax and use_ssk neq 2)
			stamp_tax_temp = daily_minimum_wage_stamp_tax;
			
	}
	//abort(daily_minimum_wage_stamp_tax);
	//neti bulurken eklenmesi için
	if(len(damga_matraha_dahil_olmayan_kesinti_tutar))
		damga_dahil_olmayan =  (damga_matraha_dahil_olmayan_kesinti_tutar * get_active_program_parameter.STAMP_TAX_BINDE) / 1000;
	
	if((get_hr_ssk.SSK_STATUTE eq 4 or get_hr_ssk.SSK_STATUTE eq 75) and is_damga_zero eq 1)
	{
		damga_vergisi_matrah = 0;
		damga_vergisi = 0;
	}
	else if((get_hr_ssk.SSK_STATUTE eq 4 or get_hr_ssk.SSK_STATUTE eq 75) and is_damga_zero eq 0)
	{
		damga_vergisi_matrah = gelir_vergisi_matrah;
		damga_vergisi = ((damga_vergisi_matrah) * get_active_program_parameter.STAMP_TAX_BINDE) / 1000;
	}


	if(is_included_in_tax eq 1)
	{
        temp_income_tax_temp = income_tax_temp; 
		//temp_stamp_tax_temp = stamp_tax_temp;
		//temp_daily_minimum_wage_stamp_tax = daily_minimum_wage_stamp_tax;
		//temp_damga_vergisi_matrah = damga_vergisi_matrah;
        damga_off_paidofftime_damga_matrah = damga_vergisi_matrah;
	}
	
	if(get_hr_ssk.is_damga_free eq 1 and is_included_in_tax eq 0 and is_included_in_tax eq 0 and is_yearly_offtime eq 0 and included_in_tax_paid_amount_brut eq 0 and total_pay_ssk_tax eq 0 and total_pay_ssk_tax_net eq 0)
	{
        damga_vergisi = 0;
        if ( is_devir_matrah_off eq 0 and not (total_pay_d gt 0 and wrk_round(damga_off_total_pay_damga) eq wrk_round(stamp_tax_temp)) )
        {
            damga_vergisi_matrah = 0;
            stamp_tax_temp = 0;
        }else{
            damga_vergisi_matrah = damga_vergisi_matrah; // brüt olması için  + stamp_tax_temp eklenmeli
        }
        
		//brütse ya da net ve ücretli vergilere dahil izini yoksa(yeraltı)
		if(get_hr_salary.gross_net eq 0 or (get_hr_salary.gross_net eq 1 and included_in_tax_hour_paid eq 0) and is_devir_matrah_off eq 0 and not (total_pay_d gt 0 and wrk_round(damga_off_total_pay_damga) eq wrk_round(stamp_tax_temp)) )
			daily_minimum_wage_stamp_tax = 0;
	}	
	if((get_hr_ssk.SSK_STATUTE eq 4 or get_hr_ssk.SSK_STATUTE eq 75) and is_damga_zero eq 1)
	{
		damga_vergisi_matrah = 0;
		damga_vergisi = 0;
	}
	
	salary = salary + total_pay_ssk_noissizlik;
	
	toplam_kesinti = 0;
	
	toplam_kesinti = wrk_round(ssdf_isci_hissesi) + wrk_round(ssk_isci_hissesi) + wrk_round(issizlik_isci_hissesi) + wrk_round(gelir_vergisi) + wrk_round(vergi_indirim_5084) + wrk_round(damga_vergisi) + wrk_round(damga_dahil_olmayan) - wrk_round(vergi_istisna_damga_vergisi);
	net_ucret = wrk_round(salary)-(temp_vergi_istisna_damga_tutar_hs-temp_vergi_istisna_damga_tutar_hs_net) - wrk_round(toplam_kesinti);
	if(included_in_tax_paid_amount gt 0 or is_yearly_offtime eq 1)
	{
		net_ucret = net_ucret - included_in_tax_paid_amount_stamp_tax;
		net_ucret = net_ucret - included_in_tax_paid_amount_income_tax;
	}
	if(isdefined("gelir_vergisi_fark") and gelir_vergisi_fark gt 0)
	{
		net_ucret = wrk_round(net_ucret) - wrk_round(gelir_vergisi_fark);
	}

	if(is_devir_matrah_off eq 0 and ozel_kesinti_yuzdeler gt 0)
	{
		//Ödenek İcraya dahil değilse 
		total_not_execution = 0; 
		if(arraylen(puantaj_exts))
		{
			for(nex=1; nex lte arraylen(puantaj_exts); nex=nex+1)
			{
				if(puantaj_exts[nex][6] eq 0) // ödenekler
				{
					if(puantaj_exts[nex][34] eq 1)
					{
						total_not_execution = total_not_execution + puantaj_exts[nex][15];
					}
				}
			}
		} 
		ozel_kesinti_temp = ozel_kesinti;
		
		total_icra = 0;
		if(use_ssk eq 2)
			ozel_kesinti_net_ucreti = maas_net_ucreti_ - nafaka_tutar - total_not_execution;
		else
			ozel_kesinti_net_ucreti = net_ucret - nafaka_tutar - total_not_execution + wrk_round(total_pay);
		if(get_active_program_parameter.interruption_type eq 0 and use_ssk neq 2) // akış parametreleri icra kesinti tipi agi hariçse
		{
			if(isdefined("asgari_gecim_indirimi_") and asgari_gecim_indirimi_ gt 0)
				ozel_kesinti_net_ucreti = net_ucret - nafaka_tutar - asgari_gecim_indirimi_ - wrk_round(total_not_execution) + wrk_round(total_pay);
		}
		if((isdefined("is_total_calc") and is_total_calc eq 1) and use_ssk neq 2)
			ozel_kesinti = ozel_kesinti + ((ozel_kesinti_net_ucreti / 100) * ozel_kesinti_yuzdeler);
		else if(use_ssk eq 2)
			ozel_kesinti = ozel_kesinti + (((ozel_kesinti_net_ucreti - asgari_gecim_indirimi_) / 100) * ozel_kesinti_yuzdeler);


		if(StructCount(icra_type_id) gt 0 and StructCount(icra_id) gt 0 and (isdefined("is_total_calc") and is_total_calc eq 1))
		{
			for (ai = 1; ai lte ArrayLen(puantaj_exts); ai=ai+1)
			{

				if(listfindnocase('0,1,2,3',puantaj_exts[ai][6]))
				{
					for (icr in icra_type_id)
					{
						if(arraylen(puantaj_exts[ai]) gte 35 and len(puantaj_exts[ai][35]) and listfindnocase(icra_type_id["#icr#"],listFirst(puantaj_exts[ai][35],'-')) and listfindnocase(icra_id["#icr#"],listLast(puantaj_exts[ai][35],'-')))
						{
							icra_rakam_ilk = (ozel_kesinti_net_ucreti / 100) * maksimum_icra_yuzdesi['#listLast(puantaj_exts[ai][35],'-')#'] ;

							if(not isdefined("max_commandment"))
								max_commandment = icra_rakam_ilk;
							if(max_commandment gt 0)
							{
								if(icra_add_payment_type['#listLast(puantaj_exts[ai][35],'-')#'] eq 0)//0: İcra oranı, 1: Tam
								{
									if(use_ssk eq 2)
									{
										icra_rakam['#listLast(puantaj_exts[ai][35],'-')#'] = ((maas_net_ucreti_ - nafaka_tutar - asgari_gecim_indirimi_) / 100 * maksimum_icra_yuzdesi['#listLast(puantaj_exts[ai][35],'-')#']);
									}else
										icra_rakam['#listLast(puantaj_exts[ai][35],'-')#'] = ((ozel_kesinti_net_ucreti) / 100) * maksimum_icra_yuzdesi['#listLast(puantaj_exts[ai][35],'-')#'];
								}
								else if((maas_net_ucreti_ - asgari_gecim_indirimi_) gt (ozel_kesinti_net_ucreti + nafaka_tutar))
								{
									if(use_ssk eq 2)
									{
										icra_rakam['#listLast(puantaj_exts[ai][35],'-')#'] = ((maas_net_ucreti_ - nafaka_tutar - asgari_gecim_indirimi_) / 100 * maksimum_icra_yuzdesi['#listLast(puantaj_exts[ai][35],'-')#']);
										
									}else
										icra_rakam['#listLast(puantaj_exts[ai][35],'-')#'] = (((ozel_kesinti_net_ucreti) / 100) * maksimum_icra_yuzdesi['#listLast(puantaj_exts[ai][35],'-')#']);
								}
								else
								{
									//Çalışan memursa
									if(use_ssk eq 2)
									{
										if(get_active_program_parameter.interruption_type eq 0) // akış parametreleri icra kesinti tipi agi hariçse
										{
											icra_rakam['#listLast(puantaj_exts[ai][35],'-')#'] = ((maas_net_ucreti_ - nafaka_tutar - asgari_gecim_indirimi_ ) / 100 * maksimum_icra_yuzdesi['#listLast(puantaj_exts[ai][35],'-')#']);
										}
										else
										{
											icra_rakam['#listLast(puantaj_exts[ai][35],'-')#'] = (((maas_net_ucreti_ - nafaka_tutar - asgari_gecim_indirimi_) / 100) * maksimum_icra_yuzdesi['#listLast(puantaj_exts[ai][35],'-')#']);
										}
									}
									else{
										if(get_active_program_parameter.interruption_type eq 0) // akış parametreleri icra kesinti tipi agi hariçse
										{
											icra_rakam['#listLast(puantaj_exts[ai][35],'-')#'] = ((maas_net_ucreti_ - nafaka_tutar - asgari_gecim_indirimi_) / 100 * maksimum_icra_yuzdesi['#listLast(puantaj_exts[ai][35],'-')#']) + ((ozel_kesinti_net_ucreti + nafaka_tutar) + asgari_gecim_indirimi_ - maas_net_ucreti_);
										}
										else
										{
											icra_rakam['#listLast(puantaj_exts[ai][35],'-')#'] = (((maas_net_ucreti_ - nafaka_tutar) / 100) * maksimum_icra_yuzdesi['#listLast(puantaj_exts[ai][35],'-')#']) + ((ozel_kesinti_net_ucreti + nafaka_tutar) - maas_net_ucreti_);
										}
									}
								}
								

								if(icra_rakam['#listLast(puantaj_exts[ai][35],'-')#'] gt maksimum_icra_tutar['#listLast(puantaj_exts[ai][35],'-')#'])
								{
									fark = icra_rakam['#listLast(puantaj_exts[ai][35],'-')#'] - maksimum_icra_tutar['#listLast(puantaj_exts[ai][35],'-')#'];
									if(ozel_kesinti gt 0)
										ozel_kesinti = ozel_kesinti - fark;
									if(max_commandment lt maksimum_icra_tutar['#listLast(puantaj_exts[ai][35],'-')#'] and is_emp_approve['#listLast(puantaj_exts[ai][35],'-')#'] eq 0 and max_commandment gte 0 and fark gte max_commandment)
									{
										icra_rakam['#listLast(puantaj_exts[ai][35],'-')#'] = max_commandment;
										max_commandment = 0;
									}
									else if(max_commandment gt maksimum_icra_tutar['#listLast(puantaj_exts[ai][35],'-')#'])
									{
										icra_rakam['#listLast(puantaj_exts[ai][35],'-')#'] = maksimum_icra_tutar['#listLast(puantaj_exts[ai][35],'-')#'];
										max_commandment = max_commandment - maksimum_icra_tutar['#listLast(puantaj_exts[ai][35],'-')#'];
									}else{
										icra_rakam['#listLast(puantaj_exts[ai][35],'-')#'] = max_commandment;
										max_commandment = 0;
										
									}
									
								}
								else if(is_emp_approve['#listLast(puantaj_exts[ai][35],'-')#'] eq 0 and max_commandment gt 0)
								{
									icra_rakam['#listLast(puantaj_exts[ai][35],'-')#'] = max_commandment;
									max_commandment = max_commandment - icra_rakam['#listLast(puantaj_exts[ai][35],'-')#'] ;
									
								}
								if(icra_rakam['#listLast(puantaj_exts[ai][35],'-')#'] gt icra_rakam_ilk)
									if((isdefined("is_total_calc") and is_total_calc eq 1))
										ozel_kesinti = ozel_kesinti + (icra_rakam['#listLast(puantaj_exts[ai][35],'-')#'] - icra_rakam_ilk);
							}
							else
							{
								icra_rakam['#listLast(puantaj_exts[ai][35],'-')#'] = 0;
								
							}
							total_icra = total_icra + icra_rakam['#listLast(puantaj_exts[ai][35],'-')#'];
						}
						
					}
				}	
			}
			if(ozel_kesinti_temp eq 0)
			{
				ozel_kesinti = total_icra;
			}
			if(ozel_kesinti neq total_icra and ozel_kesinti_temp gt 0)
			{
				ozel_kesinti = ozel_kesinti_temp + total_icra;
			}
		}
		
	}	
	StructDelete(Variables, "max_commandment");
	
	if(ozel_kesinti_yuzdeler_ay gt 0)
	{
		ozel_kesinti_net_ucreti_ay = kesinti_ucret_ay_;
		if((isdefined("is_total_calc") and is_total_calc eq 1))ozel_kesinti = ozel_kesinti + ozel_kesinti_yuzdeler_ay;
	}
	if(ozel_kesinti_yuzdeler_gun gt 0)
	{
		ozel_kesinti_net_ucreti_gun = kesinti_ucret_gun_;
		if((isdefined("is_total_calc") and is_total_calc eq 1))ozel_kesinti = ozel_kesinti + ozel_kesinti_yuzdeler_gun;
	}
	if(ozel_kesinti_yuzdeler_saat gt 0)
	{
		ozel_kesinti_net_ucreti_saat = kesinti_ucret_saat_;
		if((isdefined("is_total_calc") and is_total_calc eq 1))ozel_kesinti = ozel_kesinti + ozel_kesinti_yuzdeler_saat;
	}
	if(isdefined("net_ucret_kontrol") and net_ucret_kontrol eq 1) ozel_kesinti = 0;
	salary = salary + wrk_round(total_pay);
	net_ucret_kesintisiz = net_ucret;
	net_ucret = net_ucret - wrk_round(ozel_kesinti) - wrk_round(avans) + wrk_round(mahsup_edilecek_gelir_vergisi_) + wrk_round(total_pay);
	net_ucret = net_ucret + (wrk_round(vergi_istisna_damga_tutar) - wrk_round(vergi_istisna_damga_tutar_net)) - wrk_round(vergi_istisna_damga_vergisi);
	net_ucret = net_ucret - wrk_round(vergi_istisna_ssk_tutar_net) - wrk_round(vergi_istisna_vergi_tutar_net);
	net_ucret = net_ucret - ozel_kesinti_2_brut;

	net_ucret = net_ucret - ssk_matrah_devirden_gelen_ssk;
	
	if(ssk_matrah_kullanilan gt 0)
	{
		if(get_hr_ssk.SSK_STATUTE eq 2 or get_hr_ssk.SSK_STATUTE eq 18)//Muzaffer Yeraltı emekli 
		{		
			ssdf_isci_hissesi = ssdf_isci_hissesi + ssk_isci_hissesi_dusulecek;
		}
		else
		{
			ssk_isci_hissesi = ssk_isci_hissesi + ssk_isci_hissesi_dusulecek;
			issizlik_isci_hissesi = issizlik_isci_hissesi + issizlik_isci_hissesi_dusulecek;
		}	
	}
	
	/*20050915 buradaki avans net/brut hesaplari ile ilgili degildir, biz verilen bir brut ucretin teorik
	net karsiligini istersek avansi dusmemeliyiz.
	*/
	if(not isdefined("is_devir_matrah_off") or is_devir_matrah_off eq 0)
	{
		if(get_active_program_parameter.FULL_DAY eq 0 and ssk_days eq 31)
		{
			ssk_days = ssk_days - 1;
		}
		
		if(get_hr_salary.salary_type eq 1 and work_days eq 28 and izin eq 1)
		{
			work_days = work_days + 1;
		}
		
		if(get_hr_salary.salary_type eq 1 and work_days lt 0)
			work_days = 0;
	}
//if(get_active_program_parameter.UNPAID_PERMISSION_TODROP_THIRTY eq 1  and get_hr_ssk.duty_type neq 3)
if(get_active_program_parameter.UNPAID_PERMISSION_TODROP_THIRTY eq 1  and get_hr_ssk.duty_type neq 3 and not (isdefined("toplam_calisma_gunu") and len(toplam_calisma_gunu) and toplam_calisma_gunu neq 0 and isdefined("kisa_calisma_type") and kisa_calisma_type neq 0))
{
	if((ssk_days + izin) eq 31)
	{
		ssk_days = 30 - izin;
		work_days = 30 - izin;
	}
}

if(ssk_days lt 0)
{
	ssk_days = 0;
	work_days = 0;
}

ssk_isveren_hissesi_gov = 0;
ssk_isveren_hissesi_gov_100 = 0;
ssk_isveren_hissesi_gov_80 = 0;
ssk_isveren_hissesi_gov_60 = 0;
ssk_isveren_hissesi_gov_40 = 0;
ssk_isveren_hissesi_gov_20 = 0;
ssk_isveren_hissesi_gov_100_day = 0;
ssk_isveren_hissesi_gov_80_day = 0;
ssk_isveren_hissesi_gov_60_day = 0;
ssk_isveren_hissesi_gov_40_day = 0;
ssk_isveren_hissesi_gov_20_day = 0;
ssk_isveren_hissesi_5921 = 0;
ssk_isveren_hissesi_5921_day = 0;
ssk_isveren_hissesi_5084 = 0;
ssk_isveren_hissesi_5510 = 0;
ssk_isveren_hissesi_5746 = 0;
ssk_isveren_hissesi_6486 = 0;
ssk_isveren_hissesi_6322 = 0;
ssk_isveren_hissesi_25510 = 0;
ssk_isveren_hissesi_14857 = 0;
ssk_isveren_hissesi_3294 = 0;
ssk_isveren_hissesi_6645 = 0;
gelir_vergisi_indirimi_5746 = 0;
ssk_isveren_hissesi_4691 = 0;
gelir_vergisi_indirimi_4691 = 0;
ssk_isveren_hissesi_46486 = 0;
ssk_isveren_hissesi_56486 = 0;
ssk_isveren_hissesi_66486 = 0;

	if(ssk_days)
	{
		ssk_isveren_dusulebilecek_max_tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL * ssk_isveren_carpan_tam / 100;
		if(ssk_days eq 31)
			ssk_isveren_dusulebilecek_max_tutar_ = ssk_isveren_dusulebilecek_max_tutar_;
		else
			ssk_isveren_dusulebilecek_max_tutar_ = ssk_isveren_dusulebilecek_max_tutar_ * ceiling(ssk_days) / 30;
		if(len(get_hr_ssk.DEFECTION_LEVEL) and get_hr_ssk.DEFECTION_LEVEL neq 0 and defection_date_control eq 1)
			ssk_isveren_dusulebilecek_max_tutar_ = ssk_isveren_dusulebilecek_max_tutar_;
		else
			ssk_isveren_dusulebilecek_max_tutar_ = ssk_isveren_dusulebilecek_max_tutar_ * (ssk_days - izin_paid) / ssk_days;
		
		if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'5921') and datediff("m",get_hr_ssk.start_date,last_month_30) lte 6)// ilk once 5921 dusulur
		{
			ssk_isveren_hissesi_5921 = ssk_isveren_dusulebilecek_max_tutar_;
			if(aydaki_gun_sayisi lt ssk_days)
				kanun_5921_esas_gun = ssk_days;
			else
				kanun_5921_esas_gun = ssk_days;
			
			ssk_isveren_hissesi_5921_day = (kanun_5921_esas_gun - izin_paid);
			
			if(datediff("m",get_hr_ssk.start_date,last_month_30) eq 6)
			{
				if(day(last_month_30) eq 31)
					gun_farki_5921 = 30 - (30 - day(get_hr_ssk.start_date));
				else
					gun_farki_5921 = day(last_month_30) - (day(last_month_30) - day(get_hr_ssk.start_date));
				
				if(gun_farki_5921 gte 1 and ssk_isveren_hissesi_5921_day gt gun_farki_5921)
					ssk_isveren_hissesi_5921_day = gun_farki_5921;
					
				ssk_isveren_dusulebilecek_max_tutar_ = ssk_isveren_dusulebilecek_max_tutar_ / (kanun_5921_esas_gun - izin_paid) * 	kanun_5921_esas_gun;
				ssk_isveren_hissesi_5921 = ssk_isveren_dusulebilecek_max_tutar_ * ssk_isveren_hissesi_5921_day / kanun_5921_esas_gun;
			}

			if((attributes.sal_year gt 2011 or (attributes.sal_year eq 2011 and attributes.sal_mon gt 4)))		
			{
				ssk_isveren_dusulebilecek_max_tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL * ssk_isveren_carpan / 100;
				ssk_isveren_dusulebilecek_max_tutar_ = ssk_isveren_dusulebilecek_max_tutar_ * (ssk_days - ssk_isveren_hissesi_5921_day) / 30;
			}
			else
			{
				ssk_isveren_dusulebilecek_max_tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL * ssk_isveren_carpan_tam / 100;
				ssk_isveren_dusulebilecek_max_tutar_ = ssk_isveren_dusulebilecek_max_tutar_ * (ssk_days - ssk_isveren_hissesi_5921_day) / 30;
			}
		}

		if((attributes.sal_year gt 2008 or (attributes.sal_year eq 2008 and attributes.sal_mon gt 6)) and ssk_isveren_dusulebilecek_max_tutar_ gt 0) //sube istihdam kanununa tabii ise
		{
			if(len(get_hr_ssk.DEFECTION_LEVEL) and get_hr_ssk.DEFECTION_LEVEL neq 0 and defection_date_control eq 1 and get_hr_ssk.DEFECTION_STARTDATE lte parameter_last_month_30 and get_hr_ssk.DEFECTION_FINISHDATE gte parameter_last_month_1 and get_hr_ssk.is_5084 neq 1 and get_hr_ssk.SSK_STATUTE eq 1 and get_hr_ssk.is_5510 eq 1) //normal bir sakat varsa. su an icin ekstra sakatla aynı oranda ama ayirmakta yarar var...
			{
				ssk_isveren_hissesi_gov = ssk_isveren_dusulebilecek_max_tutar_; //ssk_isveren_hissesinin asgari gecim oranlamasinin tamamini devlet karsilar
			}
			else if(get_hr_ssk.sube_is_5510 eq 1 and get_hr_ssk.is_5510 eq 1 and get_hr_ssk.SEX eq 0 and get_hr_ssk.is_5084 neq 1 and get_hr_ssk.SSK_STATUTE eq 1) // istihdamdan yararlanan kadin ise
			{
				if(len(get_hr_ssk.DATE_5763))
					d_5763_date = get_hr_ssk.DATE_5763;
				else
					d_5763_date = get_hr_ssk.start_date;
					
				calisma_yili_ = datediff("yyyy",d_5763_date,last_month_1);
				
				if(calisma_yili_ eq 0)
				{
					if(year(last_month_1) gt year(d_5763_date) and month(last_month_1) eq month(d_5763_date))
					{
						ssk_isveren_hissesi_gov_80 = ssk_isveren_dusulebilecek_max_tutar_ * 80 / 100;
						ssk_isveren_hissesi_gov_80_day = ssk_days;
					}
					else
					{
						ssk_isveren_hissesi_gov_100 = ssk_isveren_dusulebilecek_max_tutar_;
						ssk_isveren_hissesi_gov_100_day = ssk_days;
					}
				}
				else if(calisma_yili_ eq 1)
				{
					ssk_isveren_hissesi_gov_80 = ssk_isveren_dusulebilecek_max_tutar_ * 80 / 100;
					ssk_isveren_hissesi_gov_80_day = ssk_days;
				}
				else if(calisma_yili_ eq 2)
				{
					ssk_isveren_hissesi_gov_60 = ssk_isveren_dusulebilecek_max_tutar_ * 60 / 100;
					ssk_isveren_hissesi_gov_60_day = ssk_days;
				}
				else if(calisma_yili_ eq 3)
				{
					ssk_isveren_hissesi_gov_40 = ssk_isveren_dusulebilecek_max_tutar_ * 40 / 100;
					ssk_isveren_hissesi_gov_40_day = ssk_days;
				}
				else if(calisma_yili_ eq 4)
				{
					ssk_isveren_hissesi_gov_20 = ssk_isveren_dusulebilecek_max_tutar_ * 20 / 100;
					ssk_isveren_hissesi_gov_20_day = ssk_days;
				}
				else
					ssk_isveren_hissesi_gov = 0;
			}
			else if(get_hr_ssk.sube_is_5510 eq 1 and get_hr_ssk.is_5510 eq 1 and get_hr_ssk.SEX eq 1 and len(get_hr_ssk.birth_date) and get_hr_ssk.is_5084 neq 1 and get_hr_ssk.SSK_STATUTE eq 1) // istihdamdan yararlanan erkek ise
			{
				if(len(get_hr_ssk.DATE_5763))
					d_5763_date = get_hr_ssk.DATE_5763;
				else
					d_5763_date = get_hr_ssk.start_date;
				
				calisma_yili_ = datediff("yyyy",d_5763_date,last_month_1);
				//kanundan yararlanmaya basladıgı tarihteki yaşı alındı SG 20130906
				//yas_ = datediff("yyyy",get_hr_ssk.birth_date,last_month_1);
				yas_ = datediff("yyyy",get_hr_ssk.birth_date,d_5763_date);
				if(yas_ gte 18 and yas_ lt 29)
				{
					if(calisma_yili_ eq 0)
					{
						if(year(last_month_1) gt year(d_5763_date) and month(last_month_1) eq month(d_5763_date))
						{
							ssk_isveren_hissesi_gov_80 = ssk_isveren_dusulebilecek_max_tutar_ * 80 / 100;
							ssk_isveren_hissesi_gov_80_day = ssk_days;
						}
						else
						{
							ssk_isveren_hissesi_gov_100 = ssk_isveren_dusulebilecek_max_tutar_;
							ssk_isveren_hissesi_gov_100_day = ssk_days;
						}
					}
					else if(calisma_yili_ eq 1)
					{
						ssk_isveren_hissesi_gov_80 = ssk_isveren_dusulebilecek_max_tutar_ * 80 / 100;
						ssk_isveren_hissesi_gov_80_day = ssk_days;
					}
					else if(calisma_yili_ eq 2)
					{
						ssk_isveren_hissesi_gov_60 = ssk_isveren_dusulebilecek_max_tutar_ * 60 / 100;
						ssk_isveren_hissesi_gov_60_day = ssk_days;
					}
					else if(calisma_yili_ eq 3)
					{
						ssk_isveren_hissesi_gov_40 = ssk_isveren_dusulebilecek_max_tutar_ * 40 / 100;
						ssk_isveren_hissesi_gov_40_day = ssk_days;
					}
					else if(calisma_yili_ eq 4)
					{
						ssk_isveren_hissesi_gov_20 = ssk_isveren_dusulebilecek_max_tutar_ * 20 / 100;
						ssk_isveren_hissesi_gov_20_day = ssk_days;
					}
					else
						ssk_isveren_hissesi_gov = 0;
				}
			}
			else
			{
				ssk_isveren_hissesi_gov = 0;
			}
		}
		else
		{
			ssk_isveren_hissesi_gov = 0;
		}
	}
	ssk_isveren_hissesi_gov = ssk_isveren_hissesi_gov + ssk_isveren_hissesi_gov_100 + ssk_isveren_hissesi_gov_80 + ssk_isveren_hissesi_gov_60 + ssk_isveren_hissesi_gov_40 + ssk_isveren_hissesi_gov_20;
	if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'5921'))// 5921 den yararlaniyor ise
	{
		if (get_hr_ssk.is_5084 eq 1 and (ssk_isveren_hissesi - ssk_isveren_hissesi_5921) gt 0) // çalışan da 5084 e dahil olmalı
		{
			ssk_isveren_hissesi_pay = (ssk_asgari_ucret * (ssk_days - ssk_isveren_hissesi_5921_day) /ssk_full_days) * (ssk_isveren_carpan / 100) * (get_hr_ssk.KANUN_5084_ORAN / 100);
			if(ssk_isveren_hissesi_pay gt (ssk_isveren_hissesi - ssk_isveren_hissesi_5921))
				ssk_isveren_hissesi_pay = ssk_isveren_hissesi - ssk_isveren_hissesi_5921;
				
			ssk_isveren_hissesi = ssk_isveren_hissesi - ssk_isveren_hissesi_pay;
		}
	}

	if((attributes.sal_year gt 2008 or (attributes.sal_year eq 2008 and attributes.sal_mon gt 9))) //1 ekim 2008 den itibaren 5510 sayili kanun cercevesinde 
	{
		if(get_hr_ssk.sube_is_5510 eq 1 and get_hr_ssk.is_5510 neq 1 and get_hr_ssk.is_5084 neq 1)//sube 5510 dan yararlaniyor ama kisi yararlanmiyor ise
		{
			if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'5921') and (ssk_isveren_hissesi - ssk_isveren_hissesi_5921) gt 0)// 5921 den yararlaniyor ise
			{
				ssk_isveren_hissesi_5510_1 = ((SSK_MATRAH * (ssk_days - ssk_isveren_hissesi_5921_day) / ssk_days)) * (ssk_isveren_carpan - 5) / 100;
				ssk_isveren_hissesi_5510_2 = ((SSK_MATRAH * (ssk_days - ssk_isveren_hissesi_5921_day) / ssk_days)) * (ssk_isveren_carpan) / 100;
				ssk_isveren_hissesi_5510 = ssk_isveren_hissesi_5510_2 - ssk_isveren_hissesi_5510_1;
				ssk_isveren_hissesi = ssk_isveren_hissesi - ssk_isveren_hissesi_5510;
			}
		}
	}
		
	if(ssk_isveren_hissesi_pay gt ssk_isveren_hissesi_gov)
		ssk_isveren_hissesi_gov = 0;	
		
	if(is_used_5510 eq 1)
	{
		//ssk_isveren_hissesi_5510 = (SSK_MATRAH * (ssk_isveren_carpan + 5) / 100) - (SSK_MATRAH * ssk_isveren_carpan / 100); //SG degistirdi 20130430
		ssk_isveren_hissesi_5510 = (SSK_MATRAH * (ssk_isveren_carpan + 5) / 100) - ssk_isveren_hissesi + ssk_isveren_hissesi_isci_gelen;
	}
		
	if(ssk_isveren_hissesi_pay gt 0)
		ssk_isveren_hissesi_5084 = ssk_isveren_hissesi_pay;
	if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'574680'))
	{
		if(gelir_vergisi gt 0)
		{
			gelir_vergisi_indirimi_5746 = (gelir_vergisi * 80 / 100);
			if(get_active_program_parameter.is_add_5746_control eq 0) //5746 isverene yansıtılsın işaretli ise arge indirimi gelir vergisinden düsülmeyecek SG 20140305
			{
				gelir_vergisi = gelir_vergisi - gelir_vergisi_indirimi_5746;
				net_ucret = wrk_round(net_ucret) + wrk_round(gelir_vergisi_indirimi_5746);
			}
		}
		if(ssk_isveren_hissesi gt 0)
		{
			ssk_isveren_hissesi_5746 = ssk_isveren_hissesi * 50 / 100;
		}
	}
	else if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'574690'))
	{
		if(gelir_vergisi gt 0)
		{
			gelir_vergisi_indirimi_5746 = (gelir_vergisi * 90 / 100);
			if(get_active_program_parameter.is_add_5746_control eq 0) //5746 isverene yansıtılsın işaretli ise arge indirimi gelir vergisinden düsülmeyecek SG 20140305
			{				
				gelir_vergisi = gelir_vergisi - gelir_vergisi_indirimi_5746;
				net_ucret = wrk_round(net_ucret) + wrk_round(gelir_vergisi_indirimi_5746);
			}
		}
		if(ssk_isveren_hissesi gt 0)
		{
			ssk_isveren_hissesi_5746 = ssk_isveren_hissesi * 50 / 100;
		}
	}
	else if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'5746100'))
	{
		if(gelir_vergisi gt 0)
		{
			gelir_vergisi_indirimi_5746 = gelir_vergisi;
			if(get_active_program_parameter.is_add_5746_control eq 0) //5746 isverene yansıtılsın işaretli ise arge indirimi gelir vergisinden düsülmeyecek SG 20140305
			{	
				gelir_vergisi = gelir_vergisi - gelir_vergisi_indirimi_5746;
				net_ucret = wrk_round(net_ucret) + wrk_round(gelir_vergisi_indirimi_5746);
			}
		}
		if(ssk_isveren_hissesi gt 0)
		{
			ssk_isveren_hissesi_5746 = ssk_isveren_hissesi * 50 / 100;
		}
	}
	else if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'574695'))
	{
		if(gelir_vergisi gt 0)
		{
			gelir_vergisi_indirimi_5746 = (gelir_vergisi * 95 / 100);
			if(get_active_program_parameter.is_add_5746_control eq 0)
			{				
				gelir_vergisi = gelir_vergisi - gelir_vergisi_indirimi_5746;
				net_ucret = wrk_round(net_ucret) + wrk_round(gelir_vergisi_indirimi_5746);
			}
		}
		if(ssk_isveren_hissesi gt 0)
		{
			ssk_isveren_hissesi_5746 = ssk_isveren_hissesi * 50 / 100;
		}
	}
	if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'574680') or listfindnocase(get_hr_ssk.LAW_NUMBERS,'574690') or listfindnocase(get_hr_ssk.LAW_NUMBERS,'5746100') or listfindnocase(get_hr_ssk.LAW_NUMBERS,'574695'))
	{
		damga_vergisi_matrah_5746 = damga_vergisi_matrah;
		damga_vergisi_indirimi_5746 = wrk_round(damga_vergisi - rd_dahil_olmayan_damga_vergisi - rd_dahil_olan_damga_vergisi - rd_dahil_olmayan_extsalary_damga_vergisi);
	}


	if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80') or listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90') or listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95') or listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
		{
			if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
				carpan = 80;
			else if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
				carpan = 90;
			else if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
				carpan = 95;
			else
				carpan = 100;
			
			
			if(gelir_vergisi gt 0 and arge_gunu_tax gt 0)
			{
				if(get_active_program_parameter.is_5746_salaryparam_pay eq 0)
				{
					if(get_active_program_parameter.IS_5746_WITH_AGI eq 1)
						hesaba_dahil_maas_gelir_vergisi = (gelir_vergisi  - rd_dahil_olan_gelir_vergisi - rd_dahil_olmayan_gelir_vergisi - rd_dahil_olmayan_extsalary_gelir_vergisi) / ssk_days * arge_gunu_tax;
					else
						hesaba_dahil_maas_gelir_vergisi = (gelir_vergisi + asgari_gecim_indirimi_ - rd_dahil_olan_gelir_vergisi - rd_dahil_olmayan_gelir_vergisi - rd_dahil_olmayan_extsalary_gelir_vergisi) / ssk_days * arge_gunu_tax;

					maas_gelir_vergisi_indirimi_5746 = hesaba_dahil_maas_gelir_vergisi;
					
					if(get_active_program_parameter.IS_5746_WITH_AGI eq 1)
						gelir_vergisi_matrah_5746 = (maas_gelir_vergisi_indirimi_5746 + rd_dahil_olan_gelir_vergisi);
					else
						gelir_vergisi_matrah_5746 = (maas_gelir_vergisi_indirimi_5746 + rd_dahil_olan_gelir_vergisi - asgari_gecim_indirimi_);
					gelir_vergisi_indirimi_5746 =  gelir_vergisi_matrah_5746 * carpan / 100;

					hesaba_dahil_maas_damga_vergisi = (damga_vergisi - rd_dahil_olmayan_damga_vergisi - rd_dahil_olan_damga_vergisi - rd_dahil_olmayan_extsalary_damga_vergisi) / ssk_days * arge_gunu_tax;
					hesaba_dahil_ek_damga_vergisi = rd_dahil_olan_damga_vergisi;
					
					damga_vergisi_matrah_5746 = damga_vergisi_matrah;
					damga_vergisi_indirimi_5746 = wrk_round(hesaba_dahil_maas_damga_vergisi + hesaba_dahil_ek_damga_vergisi);
				}
				else
				{
					if(is_devir_matrah_off eq 0)
					{
						gvm_matrah_5746 = gelir_vergisi_matrah;
						if(ext_salary gt 0 and isdefined("ext_salary_isci"))
							gvm_matrah_5746 = gvm_matrah_5746 - (ext_salary - ext_salary_isci_issizlik - ext_salary_isci);
							
						for (i_ek_od=1; i_ek_od lte arraylen(puantaj_exts); i_ek_od = i_ek_od+1)
						{
							if(ArrayIsDefined(puantaj_exts[i_ek_od],6) and puantaj_exts[i_ek_od][6] eq 0 and puantaj_exts[i_ek_od][9] eq 1)//brut odenekler net karşılıklarını bul
							{
								if(puantaj_exts[i_ek_od][5] eq 2 and puantaj_exts[i_ek_od][26] gt 0 and puantaj_exts[i_ek_od][43] neq 1)
								{
									rd_dahil_olmayan_vergi_matrah =  rd_dahil_olmayan_vergi_matrah + (puantaj_exts[i_ek_od][3] - puantaj_exts[i_ek_od][24] - puantaj_exts[i_ek_od][25]);
								}
							}
						}
						
						gvm_matrah_5746 = gvm_matrah_5746 - rd_dahil_olmayan_vergi_matrah;
						gvm_matrah_5746 = gvm_matrah_5746 / ssk_days * arge_gunu_tax;
					}	
					if(get_active_program_parameter.IS_5746_WITH_AGI eq 1)
						hesaba_dahil_maas_gelir_vergisi_matrah = (gelir_vergisi - rd_dahil_olmayan_gelir_vergisi - rd_dahil_olmayan_extsalary_gelir_vergisi);
					else
						hesaba_dahil_maas_gelir_vergisi_matrah = (gelir_vergisi + asgari_gecim_indirimi_ - rd_dahil_olmayan_gelir_vergisi - rd_dahil_olmayan_extsalary_gelir_vergisi);
					hesaba_dahil_maas_gelir_vergisi =  hesaba_dahil_maas_gelir_vergisi_matrah / ssk_days * arge_gunu_tax;
					
					//gvm_matrah_5746 = hesaba_dahil_maas_gelir_vergisi_matrah;
					
					maas_gelir_vergisi_indirimi_5746 = hesaba_dahil_maas_gelir_vergisi;
					if(get_active_program_parameter.IS_5746_WITH_AGI eq 1)
						gelir_vergisi_matrah_5746 = (maas_gelir_vergisi_indirimi_5746);
					else
						gelir_vergisi_matrah_5746 = (maas_gelir_vergisi_indirimi_5746 - asgari_gecim_indirimi_);

					gelir_vergisi_indirimi_5746 =  gelir_vergisi_matrah_5746 * carpan / 100;				
					
					
					hesaba_dahil_maas_damga_vergisi = (damga_vergisi - rd_dahil_olmayan_damga_vergisi - rd_dahil_olmayan_extsalary_damga_vergisi) / ssk_days * arge_gunu_tax;
					damga_vergisi_matrah_5746 = damga_vergisi_matrah;
					damga_vergisi_indirimi_5746 = wrk_round(hesaba_dahil_maas_damga_vergisi);
					if(is_devir_matrah_off eq 0)
					{
					//abort('damga_vergisi_indirimi_5746:#damga_vergisi_indirimi_5746# rd_dahil_olmayan_damga_vergisi:#rd_dahil_olmayan_damga_vergisi# damga_vergisi:#damga_vergisi#');
					}
				}
				
				if(get_active_program_parameter.is_add_5746_control eq 0) //5746 isverene yansıtılsın işaretli değil ise arge indirimi gelir vergisinden düsülür ve nete eklenir YO 20191201
				{
					gelir_vergisi = gelir_vergisi - gelir_vergisi_indirimi_5746;
					net_ucret = wrk_round(net_ucret) + wrk_round(gelir_vergisi_indirimi_5746);
				}
				
				if(gelir_vergisi_indirimi_5746 lt 0)
				{
					gelir_vergisi_indirimi_5746 = 0;
				}
			}
			
			
			if(ssk_isveren_hissesi gt 0 and arge_gunu gt 0)
			{	
				if ((salary gt ssk_matrah_taban) and (salary lt ssk_matrah_tavan))
					ssk_isveren_hissesi_gelen = (ssk_matrah - ssk_matrah_kullanilan) * ssk_isveren_carpan / 100;
				else if(salary lte ssk_matrah_taban)
					ssk_isveren_hissesi_gelen = (ssk_matrah) * ssk_isveren_carpan / 100;
				else if(salary gte ssk_matrah_tavan)
					ssk_isveren_hissesi_gelen = (ssk_matrah) * ssk_isveren_carpan / 100;
				
				if(ssk_matrah_kullanilan gt 0)
				{
					rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + (ssk_matrah_kullanilan * ssk_isveren_carpan /100);
				}
				
				if(get_active_program_parameter.is_5746_salaryparam_pay eq 0)
				{			
					maas_hesaba_dahil_isveren_hissesi = (ssk_isveren_hissesi_gelen - rd_dahil_olmayan_ssk_isveren_hissesi - rd_dahil_olan_ssk_isveren_hissesi - rd_dahil_olmayan_extsalary_ssk_isveren_hissesi) / ssk_days * arge_gunu;
					ek_hesaba_dahil_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi;
					ssk_matrah_5746 = maas_hesaba_dahil_isveren_hissesi + ek_hesaba_dahil_isveren_hissesi;
					ssk_isveren_hissesi_5746 = ssk_matrah_5746 * 50 / 100;
					//writeoutput("#ssk_isveren_hissesi_gelen# - #rd_dahil_olmayan_ssk_isveren_hissesi# - #rd_dahil_olan_ssk_isveren_hissesi# - #rd_dahil_olmayan_extsalary_ssk_isveren_hissesi# <br>")
				}
				else
				{		
					if(ozel_kesinti_2 gt 0)
						brut_kesinti_fark = isveren_fark_ozel_kesinti_2;
					else
						brut_kesinti_fark = 0;
					
					
					
					if((brut_maas - ext_salary) + ssk_matrah_kullanilan gt ssk_matrah_tavan)
					{
						m_5746 = (ssk_isveren_hissesi_gelen - rd_dahil_olmayan_ssk_isveren_hissesi);
						maas_hesaba_dahil_isveren_hissesi = m_5746 / ssk_days * arge_gunu;
					}
					else
					{
						m_5746 = (ssk_isveren_hissesi_gelen - rd_dahil_olmayan_ssk_isveren_hissesi - rd_dahil_olmayan_extsalary_ssk_isveren_hissesi);
						m_5746 = m_5746 + (ssk_matrah_kullanilan * ssk_isveren_carpan / 100);
						maas_hesaba_dahil_isveren_hissesi = m_5746 / ssk_days * arge_gunu;
					}
					
					ssk_matrah_5746 = maas_hesaba_dahil_isveren_hissesi;
					ssk_isveren_hissesi_5746 = ssk_matrah_5746 * 50 / 100;
									
				}
			}
		}

	//4691 kanunu düzenlemesi SG20151009
	if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'4691'))
	{
		if(gelir_vergisi gt 0)
		{
			gelir_vergisi_indirimi_4691 = gelir_vergisi;
			if(get_active_program_parameter.is_add_4691_control eq 0) //4691 isverene yansıtılsın işaretli ise arge indirimi gelir vergisinden düsülmeyecek SG 20151009
			{	
				gelir_vergisi = gelir_vergisi - gelir_vergisi_indirimi_4691;
				net_ucret = wrk_round(net_ucret) + wrk_round(gelir_vergisi_indirimi_4691);
			}
		}
		if(ssk_isveren_hissesi gt 0)
		{
			ssk_isveren_hissesi_4691 = ssk_isveren_hissesi * 50 / 100;
		}
	}
	if(
		listfindnocase(get_hr_ssk.LAW_NUMBERS,'6111') and
		isdate(get_hr_ssk.DATE_6111) and 
		len(get_hr_ssk.DATE_6111_SELECT) and 
		datediff("d",get_hr_ssk.DATE_6111,last_month_30) gt 0 and
		get_hr_ssk.DATE_6111_SELECT gt get_hr_ssk.SSK_ISVEREN_HISSESI_6111_COUNT
	 )//6111 kanunda tarih doluysa da boş ise de islem yapacak
		
	{
		ssk_isveren_hissesi_6111 = SSK_MATRAH * ssk_isveren_carpan / 100;
	}
	else
	{		
		ssk_isveren_hissesi_6111 = 0;
	}
	
	if (get_hr_ssk.SSK_STATUTE eq 2 or get_hr_ssk.SSK_STATUTE eq 18)//Muzaffer Yerlatı Emekli
		ssk_isveren_hissesi_5510 = 0;

	if (get_hr_ssk.SSK_STATUTE eq 5) // Anlaşmaya Tabi Olmayan Yabancı'lar için
		ssk_isveren_hissesi_5510 = 0;

	if((attributes.sal_year lt 2011 or (attributes.sal_year eq 2011 and attributes.sal_mon lt 5)))
	{
		if(ssk_isveren_hissesi_5921 gt 0) // 5921 kullanıyorsa
			ssk_isveren_hissesi_5510 = 0;
	}
	if(get_hr_ssk.SSK_STATUTE eq 21 or ((get_hr_ssk.ssk_statute eq 2 or get_hr_ssk.SSK_STATUTE eq 18) and get_hr_ssk.working_abroad eq 1))//Muzaffer Yeraltı
	{
		ssk_isveren_hissesi = ssk_isveren_hissesi + ssk_isveren_hissesi_5510;
		ssk_isveren_hissesi_5510 = 0;
		ssk_isveren_hissesi_5746 = 0;
		ssk_isveren_hissesi_5921 = 0;
		ssk_isveren_hissesi_5921_day = 0;
	}

	if(get_hr_ssk.SSK_STATUTE eq 12)
		ssk_isveren_hissesi_5510 = 0;
	if(ssk_isveren_hissesi_5746 gt 0)
		vergi_indirim_5084 = 0;
	//6486 kanun kontrolu SG 20130724
	if(ssk_days gt 0 and (listfind('21,4,5,6,13,29,30,32,33,35,36,1',get_hr_ssk.SSK_STATUTE,',') or ((get_hr_ssk.ssk_statute eq 2 or get_hr_ssk.SSK_STATUTE eq 18) and get_hr_ssk.working_abroad eq 1)) and get_hr_ssk.IS_6486 eq 1 and not len(get_hr_ssk.KANUN_6486)) //6486 seçili ve ssk statüsü sözleşmesiz ülkelere götürülecek çalışanlar
	{
		ssk_isveren_hissesi_6486 = ssk_matrah*5/100;
	}
	else if(ssk_days gt 0 and len(get_hr_ssk.KANUN_6486) and get_hr_ssk.IS_6486 eq 1 and get_hr_ssk.SSK_STATUTE neq 2 and get_hr_ssk.SSK_STATUTE neq 3 and ssk_isveren_hissesi_5510 gt 0)
	{
		ssk_isveren_hissesi_6486 = ceiling(ssk_days)*(ssk_asgari_ucret/30)*6/100;
	}
	//6322 kanun SG 20130916 6.bölge /1-5 bölgeler veya gemi inşaatı yatırımı
	//revize SG 20140129
	if(ssk_days gt 0 and len(get_hr_ssk.KANUN_6322) and get_hr_ssk.IS_6322 eq 1 and get_hr_ssk.SSK_STATUTE neq 2 and get_hr_ssk.SSK_STATUTE neq 3 and ssk_isveren_hissesi_5510 gt 0 and get_hr_ssk.SUBE_IS_5510 eq 1)
	{	
		ssk_isveren_hissesi_6322 = (get_insurance.MIN_GROSS_PAYMENT_NORMAL * ssk_isveren_carpan_tam / 100)* ceiling(ssk_days) / 30;	
	}
	//SG 20140219
	if(ssk_days gt 0 and get_hr_ssk.SUBE_IS_5510 eq 1 and get_hr_ssk.IS_25510 eq 1 and not listfind('2,3',get_hr_ssk.SSK_STATUTE,',') and ssk_isveren_hissesi_5510 gt 0)
	{
		ssk_isveren_hissesi_25510 = (get_insurance.MIN_GROSS_PAYMENT_NORMAL * ssk_isveren_carpan_tam / 100)* ceiling(ssk_days) / 30;	
	}
	if(ssk_days gt 0 and get_hr_ssk.IS_14857 eq 1 and listfind('1,3,32',get_hr_ssk.SSK_STATUTE,','))
	{
		ssk_isveren_hissesi_14857 = (ssk_asgari_ucret * ssk_isveren_carpan_tam / 100) * ceiling(ssk_days) / 30;
	}
	//3294 Sosyal yardım kanunu Esma R. Uysal 16082021
	if(ssk_days gt 0 and (listfindnocase(get_hr_ssk.LAW_NUMBERS,'3294') and listfind('1,3,32',get_hr_ssk.SSK_STATUTE,',')))
	{
		ssk_isveren_hissesi_3294 = (ssk_asgari_ucret * ssk_isveren_carpan_tam / 100) * ceiling(ssk_days) / 30;
	}
	if(get_hr_ssk.SUBE_IS_5510 eq 1 and ssk_days gt 0 and get_hr_ssk.IS_6645 eq 1 and (attributes.sal_year gt get_hr_ssk.start_year_6645 or (attributes.sal_year eq get_hr_ssk.start_year_6645 and attributes.sal_mon gte get_hr_ssk.start_mon_6645)) and (attributes.sal_year lt get_hr_ssk.end_year_6645 or (attributes.sal_year eq get_hr_ssk.end_year_6645 and attributes.sal_mon lte get_hr_ssk.end_mon_6645)) and listfind('1,8,9,10,32',get_hr_ssk.SSK_STATUTE,','))
	{
		ssk_isveren_hissesi_6645 = wrk_round((ssk_asgari_ucret * ssk_isveren_carpan_tam / 100) * ceiling(ssk_days) / 30);
	}
	
	if(ssk_days gt 0 and get_hr_ssk.IS_46486 eq 1 and listfind('1,2',get_hr_ssk.SSK_STATUTE,','))
	{
		ssk_isveren_hissesi_46486 = (ssk_asgari_ucret * 6 / 100) * ceiling(ssk_days) / 30;
	}
	if(ssk_days gt 0 and get_hr_ssk.IS_56486 eq 1 and listfind('1,2',get_hr_ssk.SSK_STATUTE,','))
	{
		ssk_isveren_hissesi_56486 = (ssk_asgari_ucret * 6 / 100) * ceiling(ssk_days) / 30;
	}
	if(ssk_days gt 0 and get_hr_ssk.IS_66486 eq 1 and listfind('1,2',get_hr_ssk.SSK_STATUTE,','))
	{
		ssk_isveren_hissesi_66486 = (ssk_asgari_ucret * 6 / 100) * ceiling(ssk_days) / 30;
	}
	
	//687 tesvigi hesaplamalari
	if(ssk_days gt 0 and ssk_carpan_687 gt 0)
	{
		// sgk gunu 30 dan buyuk ise 30 kabul edilir
		if(ceiling(ssk_days) gt 30)days_687 = 30; else days_687 = ceiling(ssk_days);
			
		toplam_prim_oran = ssk_isci_carpan + ssk_isveren_carpan + issizlik_isci_carpan + issizlik_isveren_carpan;
		ssk_isci_hissesi_687 = wrk_round((ssk_carpan_687 * days_687) / toplam_prim_oran * ssk_isci_carpan);
		ssk_isveren_hissesi_687 = wrk_round((ssk_carpan_687 * days_687) / toplam_prim_oran * ssk_isveren_carpan);
		issizlik_isci_hissesi_687 = wrk_round((ssk_carpan_687 * days_687) / toplam_prim_oran * issizlik_isci_carpan);
		issizlik_isveren_hissesi_687 = wrk_round((ssk_carpan_687 * days_687) / toplam_prim_oran * issizlik_isveren_carpan);

		gelir_vergisi_indirimi_687 = wrk_round((((ssk_asgari_ucret / 30 * days_687) - ((ssk_asgari_ucret / 30 * days_687) * 15 / 100)) * 15 / 100) - vergi_iadesi);		
		if(gelir_vergisi_indirimi_687 lt 0 or get_hr_ssk.IS_TAX_FREE eq 1 or get_hr_ssk.IS_TAX_FREE_687 eq 1)//gelir vergisinden muaf durumunda 0 kabul edilir 687 den yararlanip gelir ve damga vergisinden yararlanmiyor ise
			gelir_vergisi_indirimi_687 = 0;
		
		
		damga_vergisi_indirimi_687 = wrk_round(ssk_asgari_ucret / 30 * days_687 * get_active_program_parameter.STAMP_TAX_BINDE / 1000);
		if(damga_vergisi_indirimi_687 lt 0 or get_hr_ssk.IS_DAMGA_FREE eq 1 or get_hr_ssk.IS_TAX_FREE_687 eq 1)//damga vergisinden muaf durumunda 0 kabul edilir 687 den yararlanip gelir ve damga vergisinden yararlanmiyor ise
			damga_vergisi_indirimi_687 = 0;	
	}
	
	if(get_active_program_parameter.is_add_5746_control eq 0 )//5746 isverene yansıtılsın işaretli değil ise arge indirimi gelir vergisinden düsülür ve nete eklenir YO 20191201
	{
		damga_vergisi = damga_vergisi - damga_vergisi_indirimi_5746;
		net_ucret = net_ucret + damga_vergisi_indirimi_5746;
	}
	

	//7103 tesvigi hesaplamalari
	if(ssk_days gt 0 and law_number_7103 neq 0)
	{
		if(ceiling(ssk_days) gt 30)days_7103 = 30; else days_7103 = ceiling(ssk_days);
		toplam_prim_oran = ssk_isci_carpan + ssk_isveren_carpan + issizlik_isci_carpan + issizlik_isveren_carpan;
		temp_ssk_asgari_ucret = ssk_asgari_ucret;
		if(isdefined("toplam_calisma_gunu") and len(toplam_calisma_gunu) and toplam_calisma_gunu neq 0 and isdefined("kisa_calisma_type") and kisa_calisma_type neq 0)
		{
			if(salary lt ssk_asgari_ucret and get_hr_salary.gross_net eq 0)
			{
				ssk_asgari_ucret = salary;
			}
		}
		if(law_number_7103 eq 17103)
		{
			carpan_7103 = ssk_asgari_ucret/30;
		}
		else if(law_number_7103 eq 27103)
		{
			carpan_7103 = wrk_round(ssk_asgari_ucret*toplam_prim_oran/100,2)/30;
		}
		
		ssk_isci_hissesi_7103 = wrk_round((carpan_7103 * days_7103) / toplam_prim_oran * ssk_isci_carpan);
		if(ssk_isci_hissesi lte ssk_isci_hissesi_7103)ssk_isci_hissesi_7103= ssk_isci_hissesi;
		ssk_isveren_hissesi_7103 = wrk_round((carpan_7103 * days_7103) / toplam_prim_oran * ssk_isveren_carpan);
		if(ssk_isveren_hissesi lte ssk_isveren_hissesi_7103)ssk_isveren_hissesi_7103= ssk_isveren_hissesi;
		issizlik_isci_hissesi_7103 = wrk_round((carpan_7103 * days_7103) / toplam_prim_oran * issizlik_isci_carpan);
		if(issizlik_isci_hissesi lte issizlik_isci_hissesi_7103)issizlik_isci_hissesi_7103= issizlik_isci_hissesi;
		issizlik_isveren_hissesi_7103 = wrk_round((carpan_7103 * days_7103) / toplam_prim_oran * issizlik_isveren_carpan);
		if(issizlik_isveren_hissesi lte issizlik_isveren_hissesi_7103)issizlik_isveren_hissesi_7103= issizlik_isveren_hissesi;
		
		
		if(get_hr_ssk.is_discount_off eq 1)
		{
			vergi_iadesi = 0;
			if(this_cast_style_ eq 1 or this_cast_style_ eq 2)
			{ 
				asgari_gecim_indirimi_ilk_ = (asgari_ucret_ * asgari_gecim_indirimi_yuzdesi_ / 100) * v1;
				kisi_maximum_agi_tutari_ = asgari_gecim_indirimi_ilk_;
				kisi_maximum_agi_tutari_ = kisi_maximum_agi_tutari_ - dusulecek_agi_;
				if(isdefined("asgari_gecim_indirimi_yuzdesi_") and asgari_gecim_indirimi_yuzdesi_ gt 0)
				{
					asgari_gecim_indirimi_ = (asgari_ucret_ * asgari_gecim_indirimi_yuzdesi_ / 100) * v1;				
					if(asgari_gecim_indirimi_ gt gelir_vergisi_ilk_gelen)
						asgari_gecim_indirimi_ = gelir_vergisi_ilk_gelen;
					
					if(asgari_gecim_indirimi_ gt kisi_maximum_agi_tutari_)
						asgari_gecim_indirimi_ = kisi_maximum_agi_tutari_;
					
					if(asgari_gecim_indirimi_ gt gelir_vergisi)
					{
						vergi_iadesi_ = asgari_gecim_indirimi_;
					}
					else
					{
						vergi_iadesi_ = asgari_gecim_indirimi_;
					}
				}
			}
		}
		else
			vergi_iadesi_ = vergi_iadesi;

		gelir_vergisi_indirimi_7103 = wrk_round((((ssk_asgari_ucret / 30 * days_7103) - ((ssk_asgari_ucret / 30 * days_7103) * 15 / 100)) * 15 / 100) - vergi_iadesi_);
		
		if((gelir_vergisi-gelir_vergisi_indirimi_7103) lt 0)
			gelir_vergisi_indirimi_7103 = gelir_vergisi_indirimi_7103+(gelir_vergisi-gelir_vergisi_indirimi_7103);
		
		if(gelir_vergisi_indirimi_7103 lt 0 or get_hr_ssk.IS_TAX_FREE eq 1)//gelir vergisinden muaf durumunda 0 kabul edilir
			gelir_vergisi_indirimi_7103 = 0;
		
		if(attributes.sal_year gte 2022 and use_minimum_wage neq 1 and get_active_program_parameter.is_use_minimum_wage neq 1)
			gelir_vergisi_indirimi_7103 = 0;

		damga_vergisi_indirimi_7103 = wrk_round(((ssk_asgari_ucret / 30) * days_7103) * (get_active_program_parameter.STAMP_TAX_BINDE / 1000));
		
		if(attributes.sal_year gte 2022 and use_minimum_wage neq 1 and get_active_program_parameter.is_use_minimum_wage neq 1)
			damga_vergisi_indirimi_7103 = 0;
			
		if(damga_vergisi_indirimi_7103 lt 0 or get_hr_ssk.IS_DAMGA_FREE eq 1)//damga vergisinden muaf durumunda 0 kabul edilir 
			damga_vergisi_indirimi_7103 = 0;
		ssk_asgari_ucret = temp_ssk_asgari_ucret;
	}
	//7252 teşvik hesaplamaları Esma R. Uysal
	if(ssk_days gt 0 and is_7252_control eq 1 and ssk_days_7252 neq 0)
	{
		if(ssk_days lt ssk_days_7252)
			ssk_days_7252 = ssk_days;

		rate_7252 = ssk_asgari_ucret / 30; //günlük asgari ücret

		ssk_isveren_hissesi_7252_oran = rate_7252 * ssk_isveren_carpan / 100;//7252 sgk işveren indirimi oranı
		ssk_isveren_hissesi_7252 = ssk_isveren_hissesi_7252_oran * ssk_days_7252; // 7252 İşveren indirimi

		ssk_isci_hissesi_7252_oran = rate_7252 * ssk_isci_carpan / 100;//7252 sgk işçi indirimi oranı
		ssk_isci_hissesi_7252 = ssk_isci_hissesi_7252_oran * ssk_days_7252;//7252 sgk işçi indirimi

		issizlik_isci_hissesi_7252_oran = rate_7252 * issizlik_isci_carpan / 100;//7255 İşçi İşsizlik İndirimi oranı
		issizlik_isci_hissesi_7252 = issizlik_isci_hissesi_7252_oran * ssk_days_7252;//7255 İşçi İşsizlik İndirimi 

		issizlik_isveren_hissesi_7252_oran = rate_7252 * issizlik_isveren_carpan/100;//7254 İşveren İşsizlik İndirimi oranı
		issizlik_isveren_hissesi_7252 = issizlik_isveren_hissesi_7252_oran * ssk_days_7252;//7254 İşveren İşsizlik İndirimi
	}
	//7256 İstihdama Dönüş Kanunu Esma R. Uysal
	if(ssk_days gt 0 and is_7256_control eq 1 and attributes.sal_year lte 2021)
	{
		daily_salary_7256 = 0;
		if(attributes.sal_year eq 2020)
			daily_salary_7256 = 44.15;//7256 günlük ücreti
		else if(attributes.sal_year eq 2021)
			daily_salary_7256 = 53.67;//7256 günlük ücreti
		base_amount_7256 = ssk_days * daily_salary_7256;//7256 SGK matrahı
		base_amount_7256_temp = base_amount_7256;
		rate_7256 = base_amount_7256 / ((ssk_isveren_carpan / 100) + (issizlik_isveren_carpan/100) + (ssk_isci_carpan / 100) + (issizlik_isci_carpan / 100));//Oranı (0.375)
		ssk_isveren_hissesi_7256 = rate_7256 * ssk_isveren_carpan / 100; // 7256 İşveren indirimi
		if(ssk_isveren_hissesi_7256 gt ssk_isveren_hissesi)
		{
			ssk_isveren_hissesi_7256 = ssk_isveren_hissesi;
			base_amount_7256 = ssk_isveren_hissesi / (ssk_isveren_carpan / 100);		issizlik_isveren_hissesi_7256 = base_amount_7256 * issizlik_isveren_carpan/100;//7256 İşveren İşsizlik İndirimi
			ssk_isci_hissesi_7256 = base_amount_7256 * ssk_isci_carpan / 100;//7256 sgk işçi indirimi 
			issizlik_isci_hissesi_7256 = base_amount_7256 * issizlik_isci_carpan / 100;//7256 İşçi İşsizlik İndirimi
		}
		else
		{
			is_7256_plus = 1;
			get_json = new Query(datasource="#dsn#", sql="SELECT JSON_7256_LIST FROM EMPLOYEES_PUANTAJ WHERE PUANTAJ_ID  = #puantaj_id#").execute().getResult();
			if(len(get_json.JSON_7256_LIST) gt 0)
			{
				get_7256_json.in_out=deserializeJSON(get_json.JSON_7256_LIST);
				if(StructCount(get_7256_json.in_out) gt 0)
				{
					if(len(evaluate('get_7256_json.in_out.#attributes.in_out_id#')) and evaluate('get_7256_json.in_out.#attributes.in_out_id#') gt 0)
					{
						extra = filternum(evaluate('get_7256_json.in_out.#attributes.in_out_id#'));
						rate_7256 = (base_amount_7256+extra) / ((ssk_isveren_carpan / 100) + (issizlik_isveren_carpan/100) + (ssk_isci_carpan / 100) + (issizlik_isci_carpan / 100));//Oranı (0.375)
						ssk_isveren_hissesi_7256 = rate_7256 * ssk_isveren_carpan / 100; // 7256 İşveren indirimi
					}
				}
			}
			issizlik_isveren_hissesi_7256 = rate_7256 * issizlik_isveren_carpan/100;//7256 İşveren İşsizlik İndirimi
			ssk_isci_hissesi_7256 = rate_7256 * ssk_isci_carpan / 100;//7256 sgk işçi indirimi 
			issizlik_isci_hissesi_7256 = rate_7256 * issizlik_isci_carpan / 100;//7256 İşçi İşsizlik İndirimi
		}
	}
	net_ucret = net_ucret + net_fark_ozel_kesinti_2;
</cfscript>