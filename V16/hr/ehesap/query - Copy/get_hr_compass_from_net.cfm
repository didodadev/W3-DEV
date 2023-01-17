<cfscript>
	//Totali yakalamak için
	if(isdefined("salary_ilk") and is_net_payment eq 1)
	{
		if(isDefined("is_mesai_") and is_mesai_ eq 1)
			base_control_val = salary + net_payment_temp;
		else
			base_control_val = net_payment_temp;		
	}
	// bu sayfa commentleri gorulen luzum uzerine temizlenmistir... ilgili sayfayla ilgili degisiklik yapacaksaniz bilinen son yedek 28022006 tarihlidir YO01032006
	ssk_matrah_salary = salary ; // çıkışta kullanılıyor erk 20030922
	if(not isdefined("salary_ilk"))
		salary_ilk = salary;

	if ((salary gt ssk_matrah_taban) and (salary lt ssk_matrah_tavan))
		
	{
		SSK_MATRAH = salary;
	}
	else if(salary lte ssk_matrah_taban)
	{
		SSK_MATRAH = ssk_matrah_taban;
	}
		
	else if(salary gte ssk_matrah_tavan)
	{
		SSK_MATRAH = ssk_matrah_tavan;
	}
		
	
	if (get_hr_ssk.SSK_STATUTE eq 2 or get_hr_ssk.SSK_STATUTE eq 18)//emekli ise-Yeraltı Emekli
		{
		ssk_isveren_hissesi = 0;
		ssk_isci_hissesi = 0;
		issizlik_isci_hissesi = 0;
		issizlik_isveren_hissesi = 0;
		if (ssk_matrah gt salary)
		{
			extra = ((ssk_matrah - salary)/100) * ssk_isci_carpan;
			ssdf_isveren_hissesi = wrk_round(extra + ((ssk_matrah/100) * ssk_isveren_carpan));
			ssdf_isci_hissesi = wrk_round((salary/100) * ssk_isci_carpan);
			ssk_matrah_ekran = salary; // ekledi sadece arayuzde matrah olarak adamin maasi gozuksun diye deniyor?
			
			bes_isci_hissesi = fix((extra + (ssk_matrah/100)) * bes_isci_carpan);
		}
		else
		{
			ssdf_isveren_hissesi = wrk_round( (ssk_matrah/100) * ssk_isveren_carpan );
			ssdf_isci_hissesi = wrk_round((ssk_matrah/100) * ssk_isci_carpan);
			
			bes_isci_hissesi = fix((ssk_matrah/100) * bes_isci_carpan);
		}
	}
	else if (get_hr_ssk.SSK_STATUTE eq 3 or get_hr_ssk.SSK_STATUTE eq 4 or get_hr_ssk.SSK_STATUTE eq 75)//stajyer öğrenci / cirak ve mesleki stajyere ssk yok
		{
		ssdf_isci_hissesi = 0;
		ssdf_isveren_hissesi = 0;
		ssk_isci_hissesi = 0;
		issizlik_isci_hissesi = 0; 
		ssk_isveren_hissesi = 0;
		issizlik_isveren_hissesi = 0;
		ssk_matrah_ekran = 0; 
		
		bes_isci_hissesi = 0;
		}
	else //diğer herhangi türden ssk lı ise
	{
		ssdf_isci_hissesi = 0;
		ssdf_isveren_hissesi = 0;
		//writeoutput('#count#-ssk_matrah:#ssk_matrah# #count#-salary:#salary#');
		if (ssk_matrah gt salary)
		{
			extra = ((ssk_matrah - salary)/100) * ssk_isci_carpan;

			extra_health = ((ssk_matrah - salary)/100) * health_insurance_premium_employer_ratio;
			extra_death = ((ssk_matrah - salary)/100) * death_insurance_premium_employer_ratio;
			extra_short = ((ssk_matrah - salary)/100) * short_term_premium_ratio;

			ssk_isveren_hissesi = wrk_round(extra + ((ssk_matrah/100) * ssk_isveren_carpan));
			ssk_isci_hissesi = wrk_round((salary/100) * ssk_isci_carpan);
			issizlik_isveren_hissesi = wrk_round( ((salary/100) * issizlik_isveren_carpan) + (((ssk_matrah-salary)/100) * issizlik_isci_carpan) );
			issizlik_isci_hissesi = wrk_round((salary/100) * issizlik_isci_carpan);
			ssk_matrah_ekran = salary; // ekledi deniyor?
			
			bes_isci_hissesi = fix((salary/100) * bes_isci_carpan);

			health_insurance_premium_worker = wrk_round((salary/100) * health_insurance_premium_worker_ratio); //Hastalık Sigorta Primi İşçi
			death_insurance_premium_worker = wrk_round((salary/100) * death_insurance_premium_worker_ratio);//Malülük, Yaşlılık, Ölüm Sigorta Primi İşçi

			health_insurance_premium_employer = wrk_round(extra_health + ((ssk_matrah/100) * health_insurance_premium_employer_ratio)) ; //Hastalık Sigorta Primi İşveren
			death_insurance_premium_employer =  wrk_round(extra_death + ((ssk_matrah/100) * death_insurance_premium_employer_ratio));//Malülük, Yaşlılık, Ölüm Sigorta Primi İşveren
			short_term_premium_employer = wrk_round(extra_short + ((ssk_matrah/100) * short_term_premium_ratio));//Kısa Vadeli Sigorta Kolları Prim
		}
		else
		{
			ssk_isveren_hissesi = wrk_round( (ssk_matrah/100) * ssk_isveren_carpan );
			ssk_isci_hissesi = wrk_round((ssk_matrah/100) * ssk_isci_carpan);
			issizlik_isveren_hissesi = wrk_round( (ssk_matrah/100) * issizlik_isveren_carpan );
			issizlik_isci_hissesi = wrk_round((ssk_matrah/100) * issizlik_isci_carpan);
			
			bes_isci_hissesi = fix((ssk_matrah/100) * bes_isci_carpan);

			health_insurance_premium_worker = wrk_round((ssk_matrah/100) * health_insurance_premium_worker_ratio); //Hastalık Sigorta Primi İşçi
			death_insurance_premium_worker =  wrk_round((ssk_matrah/100) * death_insurance_premium_worker_ratio);//Malülük, Yaşlılık, Ölüm Sigorta Primi İşçi

			health_insurance_premium_employer = wrk_round( (ssk_matrah/100) * health_insurance_premium_employer_ratio); //Hastalık Sigorta Primi İşveren
			death_insurance_premium_employer = wrk_round( (ssk_matrah/100) * death_insurance_premium_employer_ratio );//Malülük, Yaşlılık, Ölüm Sigorta Primi İşveren
			short_term_premium_employer = wrk_round( (ssk_matrah/100) * short_term_premium_ratio );//Kısa Vadeli Sigorta Kolları Prim
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
		issizlik_isveren_hissesi = 0;
		
		bes_isci_hissesi = 0; 

		
		health_insurance_premium_worker = 0; //Hastalık Sigorta Primi İşçi
		death_insurance_premium_worker = 0; //Malülük, Yaşlılık, Ölüm Sigorta Primi İşçi

		health_insurance_premium_employer = 0; //Hastalık Sigorta Primi İşveren
		death_insurance_premium_employer = 0; //Malülük, Yaşlılık, Ölüm Sigorta Primi İşveren
		short_term_premium_employer = 0; //Kısa Vadeli Sigorta Kolları Prim
	}

	haric_matrah_sifirla = 0;
	if(isdefined("is_from_odenek") and is_from_odenek eq 1)
	{
		haric_matrah_tutar = (ssk_matraha_dahil_olmayan_odenek_tutar*15/100);
		if(salary lte ssk_matraha_dahil_olmayan_odenek_tutar)
		{
			ssdf_isci_hissesi = 0;
			ssdf_isveren_hissesi = 0;
			ssk_isci_hissesi = 0;
			issizlik_isci_hissesi = 0; 
			ssk_isveren_hissesi = 0;
			issizlik_isveren_hissesi = 0;
			
			bes_isci_hissesi = 0;
			haric_matrah_tutar = 0;
			haric_matrah_sifirla = 1;

			health_insurance_premium_worker =0; //Hastalık Sigorta Primi İşçi
			death_insurance_premium_worker = 0; //Malülük, Yaşlılık, Ölüm Sigorta Primi İşçi
	
			health_insurance_premium_employer = 0; //Hastalık Sigorta Primi İşveren
			death_insurance_premium_employer = 0; //Malülük, Yaşlılık, Ölüm Sigorta Primi İşveren
			short_term_premium_employer = 0; //Kısa Vadeli Sigorta Kolları Prim

			gelir_vergisi_matrah = salary - (wrk_round(ssdf_isci_hissesi) + wrk_round(ssk_isci_hissesi) + wrk_round(issizlik_isci_hissesi) + wrk_round(vergi_istisna) + wrk_round(sendika_indirimi));
		}
		else 
		{
			gelir_vergisi_matrah = salary - (wrk_round(ssdf_isci_hissesi) + wrk_round(ssk_isci_hissesi) + wrk_round(issizlik_isci_hissesi) + wrk_round(vergi_istisna) + wrk_round(sendika_indirimi))+ssk_matraha_dahil_olmayan_odenek_tutar*15/100;	
		}
	}	
	else
		gelir_vergisi_matrah = salary - (wrk_round(ssdf_isci_hissesi) + wrk_round(ssk_isci_hissesi) + wrk_round(issizlik_isci_hissesi) + wrk_round(vergi_istisna) + wrk_round(sendika_indirimi));

		include 'get_hr_compass_tax.cfm';//bu dosyadan gelir_vergisi ve tax_ratio sonucu donuyor
	
	temp_stamp_tax_base = salary;
	damga_vergisi = ((salary) * get_active_program_parameter.STAMP_TAX_BINDE ) / 1000;
	
	if(use_minimum_wage neq 1 and get_active_program_parameter.is_use_minimum_wage neq 1 and year(last_month_1) gte 2022)
	{
		stamp_tax_temp = damga_vergisi;

		if(wrk_round(damga_vergisi) gte wrk_round(daily_minimum_wage_stamp_tax) and use_ssk neq 2 and use_ssk neq 2)
		{
			damga_vergisi = damga_vergisi - daily_minimum_wage_stamp_tax;
			
		}
		else if((wrk_round(salary) lte wrk_round(daily_minimum_wage) and (is_net_payment neq 1 or (net_total_brut gt 0 and net_total_brut lte wrk_round(daily_minimum_wage) and is_net_payment eq 1))) or (is_net_payment eq 1 and is_tax_free_from_payment gt 0 and damga_vergisi lte daily_minimum_wage_stamp_tax))
		{
			damga_vergisi = 0;
		}
		if(stamp_tax_temp gte temp_daily_minimum_wage_stamp_tax  and use_ssk neq 2)
			stamp_tax_temp = temp_daily_minimum_wage_stamp_tax;
		
		if((get_hr_ssk.IS_DAMGA_FREE eq 1  and is_yearly_offtime eq 0 and (is_net_payment eq 0 or (is_net_payment eq 1 and is_mesai_ eq 1))) or is_not_stamp eq 1)// damga vergisinden muaf
		{
			damga_vergisi = 0;
			stamp_tax_temp = 0;
			daily_minimum_wage_stamp_tax = 0;
			if((is_net_payment eq 1 and is_mesai_ eq 1) or is_salary eq 1 or is_not_stamp eq 1)
			{
				damga_vergisi_matrah = 0;
				temp_stamp_tax_base = 0;
			}
		}	

	}
	
	
	if(isdefined("is_from_odenek") and is_from_odenek eq 1)
	{
		toplam_kesinti = wrk_round(ssdf_isci_hissesi) + wrk_round(ssk_isci_hissesi) + wrk_round(issizlik_isci_hissesi) + wrk_round(gelir_vergisi) + wrk_round(damga_vergisi)-haric_matrah_tutar-(vergi_matraha_dahil_olmayan_odenek_tutar*tax_carpan);
	}
	else
		toplam_kesinti = wrk_round(ssdf_isci_hissesi) + wrk_round(ssk_isci_hissesi) + wrk_round(issizlik_isci_hissesi) + wrk_round(gelir_vergisi) + wrk_round(damga_vergisi);
	
	net_ucret = salary - wrk_round(toplam_kesinti); 
		//if(isdefined("is_from_odenek") and is_from_odenek eq 1)
/* 	{
		writeoutput("<br>salary:#salary#<br>");
		writeoutput("ssdf_isci_hissesi:#ssdf_isci_hissesi#<br>");
		writeoutput("ssk_isci_hissesi:#ssk_isci_hissesi#<br>");
		writeoutput("issizlik_isci_hissesi:#issizlik_isci_hissesi#<br>");
		writeoutput("gelir_vergisi:#gelir_vergisi#<br>");
		writeoutput("damga_vergisi:#damga_vergisi#<br>");
		writeoutput("ssk_matraha_dahil_olmayan_odenek_tutar:#ssk_matraha_dahil_olmayan_odenek_tutar*15/100#<br>");
		writeoutput("toplam_kesinti:#toplam_kesinti#<br>");writeoutput("net_ucret:#net_ucret#<br><br>");
	} */
</cfscript>
