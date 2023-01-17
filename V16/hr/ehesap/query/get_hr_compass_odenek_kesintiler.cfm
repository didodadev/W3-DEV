<!--- 
	[27] -> Damga vergisi
	[6]  -> 0 ödenek, 1 kesinti
	[9]  -> net, brüt
	[5]  -> vergi var mı yok mu

 --->
<cfscript>
	puantaj_exts = ArrayNew(2); // vergi istisnalari icinde de bu deger devam ediyor
	puantaj_exts_index = 0;//vergi istisnalari icinde de bu deger devam ediyor
	kisi_aydaki_gun_sayisi = datediff('d',last_month_1,last_month_30) + 1;
/* ek ödenek ve kesintiler */
	total_pay = 0;
	total_pay_net = 0;//ssk muaf+issizlik muaf+vergi muaf+damga muaf net odenek toplami,  ..from_brut.cfm den once total_pay e eklenir.
	
	total_pay_d = 0;
	total_pay_d_net = 0;//ssk muaf+issizlik muaf+vergi muaf+damga dahil net odenek toplami,  ..from_brut.cfm den once total_pay e eklenir.
	
	total_pay_ssk_tax = 0;//ssk+vergi dahil brut odenek toplami
	total_pay_ssk_tax_net = 0;//ssk+vergi net odenek toplami, ..from_brut.cfm den once total_pay_ssk_tax e eklenir.
	kazanc_tipli_odenek_tutar = 0;//ssk+vergi net odenek toplami, ..from_brut.cfm den once total_pay_ssk_tax e eklenir (kazanç tipinde olan ek ödenekler haric)
	
	total_pay_ssk_tax_noissizlik = 0;//ssk+vergi+damga var issizlik yok dahil brut odenek toplami
	total_pay_ssk_tax_net_noissizlik = 0;//ssk+vergi+damga var issizlik  net odenek toplami, ..from_brut.cfm den once total_pay_ssk_tax_noissizlik e eklenir.
	
	total_pay_tax = 0;
	total_pay_tax_net = 0;//yalniz vergi net odenek toplami,  ..from_brut.cfm den once total_pay_tax e eklenir.
	total_pay_tax_net_kazanc_haric = 0;//yalniz vergi net odenek toplami,  ..from_brut.cfm den once total_pay_tax e eklenir. (kazanç tipinde olan ek ödenekler haric)
	
	total_pay_ssk = 0;
	total_pay_ssk_net = 0;//yalniz ssk net odenek toplami,  ..from_brut.cfm den once total_pay_ssk e eklenir.
	
	total_pay_ssk_noissizlik = 0;
	total_pay_ssk_net_noissizlik = 0;//yalniz ssk net odenek toplami,  ..from_brut.cfm den once total_pay_ssk e eklenir.
	
	total_pay_tax_issizlik = 0;
	total_pay_tax_issizlik_net = 0;

	total_pay_ssk_tax_notstamp = 0; // ssk, işsizlik, vergi var, damga yok
	total_pay_ssk_tax_net_notstamp = 0;
	

	//total_pay_ssk_net_damgasiz -> ssk işsizlik var, damga ve vergi yok.

	ozel_kesinti = 0; // netden 
	
	ozel_kesinti_yuzdeler = 0; // netden % oran
	ozel_kesinti_yuzdeler_gun = 0; // netden % oran
	ozel_kesinti_yuzdeler_ay = 0; // netden % oran
	ozel_kesinti_yuzdeler_saat = 0; // netden % oran
	
	ozel_kesinti_yuzdeler_vergisiz = 0; // netden % oran
	ozel_kesinti_yuzdeler_gun_vergisiz = 0; // netden % oran
	ozel_kesinti_yuzdeler_ay_vergisiz = 0; // netden % oran
	ozel_kesinti_yuzdeler_saat_vergisiz = 0; // netden % oran
	
	ozel_kesinti_2 = 0; // brütden
	ozel_kesinti_2_net = 0;//brüt kesinti neti
	
	ssk_matraha_dahil_olmayan_odenek_tutar = 0;
	vergi_matraha_dahil_olmayan_odenek_tutar = 0;
	vergi_matraha_dahil_olmayan_kesinti_tutar = 0;
	damga_matraha_dahil_olmayan_kesinti_tutar = 0;
	
	vergi_matraha_dahil_olmayan_net_odenek_tutar = 0;

	rd_dahil_olmayan_ssk_matrah = 0;
	rd_dahil_olmayan_vergi_matrah = 0;
	
	rd_dahil_olmayan_gelir_vergisi = 0;	
	rd_dahil_olmayan_damga_vergisi = 0;
	rd_dahil_olmayan_ssk_isveren_hissesi = 0;
	
	rd_dahil_olan_gelir_vergisi = 0;	
	rd_dahil_olan_damga_vergisi = 0;
	rd_dahil_olan_ssk_isveren_hissesi = 0;
	
	kazanca_dahil_olan_odenek_tutar = 0;
	kazanca_dahil_olan_odenek_tutar_muaf = 0;
	
	if(ssk_full_days lt aydaki_gun_sayisi)
		fiili_gun_ = ssk_full_days - izin_paid - sunday_count - offdays_count + paid_izinli_sunday_count + offdays_sunday_count - izin + izinli_sunday_count;
	else
		fiili_gun_ = kisi_aydaki_gun_sayisi - izin_paid - sunday_count - offdays_count + paid_izinli_sunday_count + offdays_sunday_count - izin + izinli_sunday_count;
	//abort('ssk_days:#ssk_days# izin:#izin# offdays_count:#offdays_count# offdays_sunday_count:#offdays_sunday_count# fiili_gun_:#fiili_gun_#');
	//abort('total_hours:#total_hours#');
	// ek ödenek
	// if(ssk_days gt 0) // ssk günü sıfır olanın ek ödenek, kesinti, vergi istisnaları dikkate alınmaz
	// yukaridaki satir iptal cunku adamin gunu 0 olsa dahi yillik yapilan ve gune bakmayan odenekleri almali



	
	for (i=1; i lte get_pay_salary.recordcount; i = i+1)
	{
		if(ssk_days eq 0) 
			day_info = 0; 
		else if(ssk_days eq 30 and get_pay_salary.calc_days[i] eq 1) // Tutar günü = Gün ise
			day_info = (ssk_full_days-izin)/ssk_days;  //ucretsiz izin oldugunda tam calisanlarda ucretsiz izni dusmeli 31-izin olmalı SG 20130918
		else if(ssk_days eq 30)
			day_info = (ssk_full_days-izin);  //ucretsiz izin oldugunda tam calisanlarda ucretsiz izni dusmeli 31-izin olmalı SG 20130918
		else if(get_pay_salary.calc_days[i] eq 1) // Tutar günü = Gün ise
			day_info = ssk_days/30;
		else
			day_info = ssk_days;

		flag_pay = 0;
		if (get_pay_salary.period_pay[i] eq 1) // ayda 1
			flag_pay = 1;
		else if ( (get_pay_salary.period_pay[i] eq 2) and (( (month(last_month_1) - get_pay_salary.START_SAL_MON[i] +1) mod 3) eq 0) )// 3 ayda 1
			flag_pay = 1;
		else if ( (get_pay_salary.period_pay[i] eq 3) and (( (month(last_month_1) - get_pay_salary.START_SAL_MON[i] +1) mod 6) eq 0) )// 6 ayda 1
			flag_pay = 1;
		else if ( (get_pay_salary.period_pay[i] eq 4) and ( month(last_month_1) eq get_pay_salary.START_SAL_MON[i] ) ) // yılda 1
			flag_pay = 1;
		if (flag_pay eq 1)
		{
			if (get_pay_salary.method_pay[i] eq 1 or get_pay_salary.method_pay[i] eq 5 or get_pay_salary.method_pay[i] eq 6 or get_pay_salary.method_pay[i] eq 7 or get_pay_salary.method_pay[i] eq 8) // +
			{
				if ((get_pay_salary.ssk[i] eq 1) and (get_pay_salary.tax[i] eq 1) and (get_pay_salary.IS_DAMGA[i] eq 0) and (get_pay_salary.IS_ISSIZLIK[i] eq 0) ) // ssk,vergi,damga,issizlik yok 
				{
					puantaj_exts_index = puantaj_exts_index + 1;
					puantaj_exts[puantaj_exts_index][1] = get_pay_salary.comment_PAY[i];
					puantaj_exts[puantaj_exts_index][2] = 1;
					puantaj_exts[puantaj_exts_index][4] = 1;/*ssk var mi 1-yok 2-var*/
					puantaj_exts[puantaj_exts_index][5] = 1;/*vergi var mi 1-yok 2-var*/
					puantaj_exts[puantaj_exts_index][6] = 0;
					puantaj_exts[puantaj_exts_index][7] = get_pay_salary.calc_days[i];
					puantaj_exts[puantaj_exts_index][8] = 0;
					puantaj_exts[puantaj_exts_index][9] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][33] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][10] = get_pay_salary.is_kidem[i];
					puantaj_exts[puantaj_exts_index][11] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/
					puantaj_exts[puantaj_exts_index][12] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/	
					puantaj_exts[puantaj_exts_index][13] = 0;/*damga var mi 1-var 0-yok */	
					puantaj_exts[puantaj_exts_index][14] = 0;/*issizlik var mi 1-var 0-yok */
					//SG 20140210 gune gore net odenegin net tutarini dogru gostermesi icin eklendi. 
					if (get_pay_salary.from_salary[i] eq 0 ) //ödenek net ise 
					{
						if (get_pay_salary.calc_days[i] eq 1)
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * (day_info));	
						}
						else if (get_pay_salary.calc_days[i] eq 2) //fili gün
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * fiili_gun_/30); 		
						}	
						else
						{
							if(for_ssk_day eq 0)
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];/*net ödenecek*/	
							else
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i] / 30 * day_info;/*net ödenecek*/
						}
					}
					else
					{
						if(for_ssk_day eq 0)
							puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];/*net ödenecek*/	
						else
							puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i] / 30 * day_info;/*net ödenecek*/
					}
					puantaj_exts[puantaj_exts_index][16] = get_pay_salary.comment_pay_id[i];/*ödenek id*/
					puantaj_exts[puantaj_exts_index][17] = '';
					puantaj_exts[puantaj_exts_index][18] = '';
					puantaj_exts[puantaj_exts_index][19] = '';
					puantaj_exts[puantaj_exts_index][20] = '';
					puantaj_exts[puantaj_exts_index][21] = '';
					puantaj_exts[puantaj_exts_index][22] = '';
					puantaj_exts[puantaj_exts_index][23] = '';
					puantaj_exts[puantaj_exts_index][24] = '';
					puantaj_exts[puantaj_exts_index][25] = '';
					puantaj_exts[puantaj_exts_index][26] = '';
					puantaj_exts[puantaj_exts_index][27] = '';
					puantaj_exts[puantaj_exts_index][28] = get_pay_salary.is_income[i];
					puantaj_exts[puantaj_exts_index][29] = '';
					puantaj_exts[puantaj_exts_index][30] = '';
					puantaj_exts[puantaj_exts_index][31] = get_pay_salary.factor_type[i];
					puantaj_exts[puantaj_exts_index][32] = get_pay_salary.comment_type[i];
					puantaj_exts[puantaj_exts_index][34] = get_pay_salary.is_not_execution[i];
					puantaj_exts[puantaj_exts_index][35] = '';
					puantaj_exts[puantaj_exts_index][36] = get_pay_salary.ssk_exemption_rate[i];
					puantaj_exts[puantaj_exts_index][37] = get_pay_salary.ssk_exemption_type[i];
					puantaj_exts[puantaj_exts_index][38] = '';
					puantaj_exts[puantaj_exts_index][39] = '';
					puantaj_exts[puantaj_exts_index][40] = '';
					puantaj_exts[puantaj_exts_index][41] = 0;

					puantaj_exts[puantaj_exts_index][42] = get_pay_salary.is_rd_damga[i];
					puantaj_exts[puantaj_exts_index][43] = get_pay_salary.is_rd_gelir[i];
					puantaj_exts[puantaj_exts_index][44] = get_pay_salary.is_rd_ssk[i];
					
					puantaj_exts[puantaj_exts_index][45] = 0;
					puantaj_exts[puantaj_exts_index][46] = 0;
					puantaj_exts[puantaj_exts_index][47] = 0;
					puantaj_exts[puantaj_exts_index][48] = get_pay_salary.total_hour[i];//varsa total saat
					puantaj_exts[puantaj_exts_index][49] = '';

					
					if (get_pay_salary.calc_days[i] eq 1)
					{
						// son ayın çalışma gününe bakarak ödeme yapılır
						puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i] * (day_info));
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_net = total_pay_net + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay = total_pay + puantaj_exts[puantaj_exts_index][3];
					}
					else if(get_pay_salary.calc_days[i] eq 2)
					{
						// son ayın çalışma gününe bakarak ödeme yapılır
						puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i] * fiili_gun_);
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_net = total_pay_net + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay = total_pay + puantaj_exts[puantaj_exts_index][3];
					}
					else
					{
						if(for_ssk_day eq 0)
							puantaj_exts[puantaj_exts_index][3] = get_pay_salary.amount_pay[i];
						else
							puantaj_exts[puantaj_exts_index][3] = get_pay_salary.amount_pay[i] / 30 * day_info;
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_net = total_pay_net + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay = total_pay + puantaj_exts[puantaj_exts_index][3];
					}
					if(get_pay_salary.is_income[i] eq 1)
					{
						kazanca_dahil_olan_odenek_tutar = kazanca_dahil_olan_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
						if(get_pay_salary.tax[i] eq 1)
							kazanca_dahil_olan_odenek_tutar_muaf = kazanca_dahil_olan_odenek_tutar_muaf + puantaj_exts[puantaj_exts_index][3];	
					}
					if(get_pay_salary.comment_type[i] eq 2)
					{
						kazanc_tipli_odenek_tutar = kazanc_tipli_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
					}
					
				}
				else if ((get_pay_salary.ssk[i] eq 1) and (get_pay_salary.tax[i] eq 1) and (get_pay_salary.IS_DAMGA[i] eq 1) and (get_pay_salary.IS_ISSIZLIK[i] eq 0) ) // ssk,vergi,issizlik yok damga var 
				{
					puantaj_exts_index = puantaj_exts_index + 1;
					puantaj_exts[puantaj_exts_index][1] = get_pay_salary.comment_PAY[i];
					puantaj_exts[puantaj_exts_index][2] = 1;
					puantaj_exts[puantaj_exts_index][4] = 1;/*ssk var mi 1-yok 2-var*/
					puantaj_exts[puantaj_exts_index][5] = 1;/*vergi var mi 1-yok 2-var*/
					puantaj_exts[puantaj_exts_index][6] = 0;
					puantaj_exts[puantaj_exts_index][7] = get_pay_salary.calc_days[i];
					puantaj_exts[puantaj_exts_index][8] = 0;
					puantaj_exts[puantaj_exts_index][9] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][33] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][10] = get_pay_salary.is_kidem[i];
					puantaj_exts[puantaj_exts_index][11] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/
					puantaj_exts[puantaj_exts_index][12] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/	
					puantaj_exts[puantaj_exts_index][13] = 1;/*damga var mi 1-var 0-yok */	
					puantaj_exts[puantaj_exts_index][14] = 0;/*issizlik var mi 1-var 0-yok */
					//SG 20140210 gune gore net odenegin net tutarini dogru gostermesi icin eklendi. 
					if (get_pay_salary.from_salary[i] eq 0 ) //ödenek net ise 
					{
						if (get_pay_salary.calc_days[i] eq 1)
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * (day_info));	
						}
						else if (get_pay_salary.calc_days[i] eq 2) //fili gün
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * fiili_gun_/30); 		
						}	
						else
						{
							if(for_ssk_day eq 0)
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];/*net ödenecek*/	
							else
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i] / 30 * day_info;/*net ödenecek*/
						}
					}
					else
					{
						if(for_ssk_day eq 0)
							puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];/*net ödenecek*/	
						else
							puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i] /  30 * day_info;/*net ödenecek*/
					}
					
					puantaj_exts[puantaj_exts_index][16] = get_pay_salary.comment_pay_id[i];/*ödenek id*/
					puantaj_exts[puantaj_exts_index][17] = '';
					puantaj_exts[puantaj_exts_index][18] = '';
					puantaj_exts[puantaj_exts_index][19] = '';
					puantaj_exts[puantaj_exts_index][20] = '';
					puantaj_exts[puantaj_exts_index][21] = '';
					puantaj_exts[puantaj_exts_index][22] = '';
					puantaj_exts[puantaj_exts_index][23] = '';
					puantaj_exts[puantaj_exts_index][24] = '';
					puantaj_exts[puantaj_exts_index][25] = '';
					puantaj_exts[puantaj_exts_index][26] = '';
					puantaj_exts[puantaj_exts_index][27] = '';
					puantaj_exts[puantaj_exts_index][28] = get_pay_salary.is_income[i];
					puantaj_exts[puantaj_exts_index][29] = '';
					puantaj_exts[puantaj_exts_index][30] = '';
					puantaj_exts[puantaj_exts_index][31] = get_pay_salary.factor_type[i];
					puantaj_exts[puantaj_exts_index][32] = get_pay_salary.comment_type[i];
					puantaj_exts[puantaj_exts_index][34] = get_pay_salary.is_not_execution[i];
					puantaj_exts[puantaj_exts_index][35] = '';
					puantaj_exts[puantaj_exts_index][36] = get_pay_salary.ssk_exemption_rate[i];
					puantaj_exts[puantaj_exts_index][37] = get_pay_salary.ssk_exemption_type[i];
					puantaj_exts[puantaj_exts_index][38] = '';
					puantaj_exts[puantaj_exts_index][39] = '';
					puantaj_exts[puantaj_exts_index][40] = '';
					puantaj_exts[puantaj_exts_index][41] = 0;

					puantaj_exts[puantaj_exts_index][42] = get_pay_salary.is_rd_damga[i];
					puantaj_exts[puantaj_exts_index][43] = get_pay_salary.is_rd_gelir[i];
					puantaj_exts[puantaj_exts_index][44] = get_pay_salary.is_rd_ssk[i];
					
					puantaj_exts[puantaj_exts_index][45] = 0;
					puantaj_exts[puantaj_exts_index][46] = 0;
					puantaj_exts[puantaj_exts_index][47] = 0;
					puantaj_exts[puantaj_exts_index][48] = get_pay_salary.total_hour[i];//varsa total saat
					puantaj_exts[puantaj_exts_index][49] = '';
			
					if (get_pay_salary.calc_days[i] eq 1)
					{
						// son ayın çalışma gününe bakarak ödeme yapılır
						puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i] * (day_info));
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_d_net = total_pay_d_net + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay_d = total_pay_d + puantaj_exts[puantaj_exts_index][3];
					}
					else if (get_pay_salary.calc_days[i] eq 2)
					{
						// son ayın çalışma gününe bakarak ödeme yapılır
						puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i] * fiili_gun_);
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_d_net = total_pay_d_net + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay_d = total_pay_d + puantaj_exts[puantaj_exts_index][3];
					}
					else
					{
						if(for_ssk_day eq 0)
							puantaj_exts[puantaj_exts_index][3] = get_pay_salary.amount_pay[i];
						else
							puantaj_exts[puantaj_exts_index][3] = get_pay_salary.amount_pay[i] / 30 * day_info;
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_d_net = total_pay_d_net + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay_d = total_pay_d + puantaj_exts[puantaj_exts_index][3];
					}

					if(get_pay_salary.is_income[i] eq 1)
					{
						kazanca_dahil_olan_odenek_tutar = kazanca_dahil_olan_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
						if(get_pay_salary.tax[i] eq 1)
							kazanca_dahil_olan_odenek_tutar_muaf = kazanca_dahil_olan_odenek_tutar_muaf + puantaj_exts[puantaj_exts_index][3];	
					}
					if(get_pay_salary.comment_type[i] eq 2)
					{
						kazanc_tipli_odenek_tutar = kazanc_tipli_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
					}
					
				}	
				else if((get_pay_salary.ssk[i] eq 2) and (get_pay_salary.tax[i] eq 2) and (get_pay_salary.IS_DAMGA[i] eq 1) and (get_pay_salary.IS_ISSIZLIK[i] eq 1)) // hersey dahil 
				{ 
					puantaj_exts_index = puantaj_exts_index + 1;
					puantaj_exts[puantaj_exts_index][1] = get_pay_salary.comment_PAY[i];
					puantaj_exts[puantaj_exts_index][2] = 1;
					if (get_pay_salary.calc_days[i] eq 1)
					{
						// son ayın çalışma gününe bakarak ödeme yapılır
						puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i] * (day_info));
						if(get_pay_salary.from_salary[i] eq 0)//net
						{
							total_pay_ssk_tax_net = total_pay_ssk_tax_net + puantaj_exts[puantaj_exts_index][3];
						}
						else //brüt
							total_pay_ssk_tax = total_pay_ssk_tax + puantaj_exts[puantaj_exts_index][3];
					}
					else if (get_pay_salary.calc_days[i] eq 2) //fili gün
					{		
						// son ayın çalışma gününe bakarak ödeme yapılır
						puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i] * fiili_gun_); //puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i] * fiili_gun_);
						if(get_pay_salary.from_salary[i] eq 0)//net
						{
							total_pay_ssk_tax_net = total_pay_ssk_tax_net + puantaj_exts[puantaj_exts_index][3];
						}
						else //brüt
							total_pay_ssk_tax = total_pay_ssk_tax + puantaj_exts[puantaj_exts_index][3];
					}
					else
					{
						if(for_ssk_day eq 0)
							puantaj_exts[puantaj_exts_index][3] = get_pay_salary.amount_pay[i];
						else
							puantaj_exts[puantaj_exts_index][3] = get_pay_salary.amount_pay[i] / 30 * day_info;
						if(get_pay_salary.from_salary[i] eq 0)//net
						{
							total_pay_ssk_tax_net = total_pay_ssk_tax_net + puantaj_exts[puantaj_exts_index][3];
						}
						else //brüt
							total_pay_ssk_tax = total_pay_ssk_tax + puantaj_exts[puantaj_exts_index][3];
					}
					puantaj_exts[puantaj_exts_index][4] = 2;
					puantaj_exts[puantaj_exts_index][5] = 2;
					puantaj_exts[puantaj_exts_index][6] = 0;
					puantaj_exts[puantaj_exts_index][7] = get_pay_salary.calc_days[i];
					puantaj_exts[puantaj_exts_index][8] = 0;
					puantaj_exts[puantaj_exts_index][9] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][33] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][10] = get_pay_salary.is_kidem[i];
					puantaj_exts[puantaj_exts_index][11] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/
					puantaj_exts[puantaj_exts_index][12] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/	
					puantaj_exts[puantaj_exts_index][13] = 1;/*damga var mi 1-var 0-yok */	
					puantaj_exts[puantaj_exts_index][14] = 1;/*issizlik var mi 1-var 0-yok */
					//SG 20140210 gune gore net odenegin net tutarini dogru gostermesi icin eklendi. 
					if (get_pay_salary.from_salary[i] eq 0 ) //ödenek net ise 
					{
						if (get_pay_salary.calc_days[i] eq 1)
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * (day_info));	
						}
						else if (get_pay_salary.calc_days[i] eq 2) //fili gün
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * fiili_gun_); 		
						}	
						else
						{
							if(for_ssk_day eq 0)
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];/*net ödenecek*/	
							else
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i]	/ 30 * day_info;
						}
					}
					else
					{
						//puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];/*net ödenecek*/
						puantaj_exts[puantaj_exts_index][15] = puantaj_exts[puantaj_exts_index][3];
					}
					puantaj_exts[puantaj_exts_index][16] = get_pay_salary.comment_pay_id[i];/*ödenek id*/
					puantaj_exts[puantaj_exts_index][17] = '';
					puantaj_exts[puantaj_exts_index][18] = '';
					puantaj_exts[puantaj_exts_index][19] = '';
					puantaj_exts[puantaj_exts_index][20] = '';
					puantaj_exts[puantaj_exts_index][21] = '';
					puantaj_exts[puantaj_exts_index][22] = '';
					puantaj_exts[puantaj_exts_index][23] = '';
					puantaj_exts[puantaj_exts_index][24] = '';
					puantaj_exts[puantaj_exts_index][25] = '';
					puantaj_exts[puantaj_exts_index][26] = '';
					puantaj_exts[puantaj_exts_index][27] = '';
					puantaj_exts[puantaj_exts_index][28] = get_pay_salary.is_income[i];
					puantaj_exts[puantaj_exts_index][29] = '';
					puantaj_exts[puantaj_exts_index][30] = '';
					puantaj_exts[puantaj_exts_index][31] = get_pay_salary.factor_type[i];
					puantaj_exts[puantaj_exts_index][32] = get_pay_salary.comment_type[i];
					puantaj_exts[puantaj_exts_index][34] = get_pay_salary.is_not_execution[i];
					puantaj_exts[puantaj_exts_index][35] = '';
					puantaj_exts[puantaj_exts_index][36] = get_pay_salary.ssk_exemption_rate[i];
					puantaj_exts[puantaj_exts_index][37] = get_pay_salary.ssk_exemption_type[i];
					
					puantaj_exts[puantaj_exts_index][38] = get_pay_salary.TAX_EXEMPTION_VALUE[i];
					puantaj_exts[puantaj_exts_index][39] = get_pay_salary.TAX_EXEMPTION_RATE[i];
					puantaj_exts[puantaj_exts_index][40] = '';
					puantaj_exts[puantaj_exts_index][41] = 0;

					puantaj_exts[puantaj_exts_index][42] = get_pay_salary.is_rd_damga[i];
					puantaj_exts[puantaj_exts_index][43] = get_pay_salary.is_rd_gelir[i];
					puantaj_exts[puantaj_exts_index][44] = get_pay_salary.is_rd_ssk[i];
					
					puantaj_exts[puantaj_exts_index][45] = 0;
					puantaj_exts[puantaj_exts_index][46] = 0;
					puantaj_exts[puantaj_exts_index][47] = 0;
					puantaj_exts[puantaj_exts_index][48] = get_pay_salary.total_hour[i];//varsa total saat
					puantaj_exts[puantaj_exts_index][49] = '';
					
					//ssk matraha dahil olmayan odenek tutari
					if(len(get_pay_salary.ssk_exemption_rate[i]) and len(get_pay_salary.ssk_exemption_type[i]))
					{
						if(get_pay_salary.ssk_exemption_type[i] eq 0)
							{
							tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL * get_pay_salary.ssk_exemption_rate[i] / 100;
								if(tutar_ gt puantaj_exts[puantaj_exts_index][3])
								{
									if(get_pay_salary.from_salary[i] eq 0)
									{
										/*
										baz_ = puantaj_exts[puantaj_exts_index][3] * 100 / 85;
										if(tutar_ gt baz_)
										{
											tutar_ = baz_;
										}
										*/
									}
									else 
									{
										tutar_ = puantaj_exts[puantaj_exts_index][3];
									}									
								}
							}
						else if(get_pay_salary.ssk_exemption_type[i] eq 1)
							tutar_ = puantaj_exts[puantaj_exts_index][3] * get_pay_salary.ssk_exemption_rate[i] / 100;
						else if(get_pay_salary.ssk_exemption_type[i] eq 2)
						{
							if(get_pay_salary.calc_days[i] eq 1)//güne göre
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * ssk_days;
							else if(get_pay_salary.calc_days[i] eq 2)//fiili güne göre
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * fiili_gun_;
							else
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * get_pay_salary.ASIL_TUTAR[i];
						}
						if(tutar_ gt puantaj_exts[puantaj_exts_index][15])
						{
							if(get_pay_salary.from_salary[i] neq 0)
							{
								tutar_ = puantaj_exts[puantaj_exts_index][15];
							}								
						}
						ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + tutar_;
						puantaj_exts[puantaj_exts_index][40] = tutar_;
						
					}
					if(len(get_pay_salary.TAX_EXEMPTION_VALUE[i]))
					{
						tutar_ = get_pay_salary.ASIL_TUTAR[i] * get_pay_salary.TAX_EXEMPTION_VALUE[i];
						vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + tutar_;
					}
					if(len(get_pay_salary.TAX_EXEMPTION_RATE[i]))
					{
						tutar_ =  get_pay_salary.TAX_EXEMPTION_RATE[i];
						if(tutar_ gt puantaj_exts[puantaj_exts_index][15])
						{
							tutar_ = puantaj_exts[puantaj_exts_index][15];
						}
						vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + tutar_;
						
						
						puantaj_exts[puantaj_exts_index][41] = tutar_;
					}
					if(get_pay_salary.is_income[i] eq 1)
					{
						kazanca_dahil_olan_odenek_tutar = kazanca_dahil_olan_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
						if(get_pay_salary.tax[i] eq 1)
							kazanca_dahil_olan_odenek_tutar_muaf = kazanca_dahil_olan_odenek_tutar_muaf + puantaj_exts[puantaj_exts_index][3];	
					}
					if(get_pay_salary.comment_type[i] eq 2)
					{
						kazanc_tipli_odenek_tutar = kazanc_tipli_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
					}
					
					if(puantaj_exts[puantaj_exts_index][15] gt puantaj_exts[puantaj_exts_index][39])
						puantaj_exts[puantaj_exts_index][39] = puantaj_exts[puantaj_exts_index][15];
					
				}
				else if ( (get_pay_salary.ssk[i] eq 1) and (get_pay_salary.tax[i] eq 2) and (get_pay_salary.IS_DAMGA[i] eq 1) and (get_pay_salary.IS_ISSIZLIK[i] eq 0)) // damga gelir var issizlik ssk yok 
				{
					puantaj_exts_index = puantaj_exts_index + 1;
					puantaj_exts[puantaj_exts_index][1] = get_pay_salary.comment_PAY[i];
					puantaj_exts[puantaj_exts_index][2] = 1;
					if (get_pay_salary.calc_days[i] eq 1)
					{
						puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i] * (day_info));
						if(get_pay_salary.from_salary[i] eq 0)//net
						{
							total_pay_tax_net = total_pay_tax_net + puantaj_exts[puantaj_exts_index][3];
						}
						else //brüt
							total_pay_tax = total_pay_tax + puantaj_exts[puantaj_exts_index][3];
					}
					else if (get_pay_salary.calc_days[i] eq 2)
					{
						puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i] * fiili_gun_);
						if(get_pay_salary.from_salary[i] eq 0)//net
						{
							total_pay_tax_net = total_pay_tax_net + puantaj_exts[puantaj_exts_index][3];
						}
						else //brüt
							total_pay_tax = total_pay_tax + puantaj_exts[puantaj_exts_index][3];
					}	
					else
					{
						if(for_ssk_day eq 0)
							puantaj_exts[puantaj_exts_index][3] = get_pay_salary.amount_pay[i];
						else
							puantaj_exts[puantaj_exts_index][3] = get_pay_salary.amount_pay[i] / 30 * day_info;
						if(get_pay_salary.from_salary[i] eq 0)//net
						{
							total_pay_tax_net = total_pay_tax_net + puantaj_exts[puantaj_exts_index][3];
						}
						else //brüt
							total_pay_tax = total_pay_tax + puantaj_exts[puantaj_exts_index][3];
					}
					puantaj_exts[puantaj_exts_index][4] = 1;
					puantaj_exts[puantaj_exts_index][5] = 2;
					puantaj_exts[puantaj_exts_index][6] = 0;
					puantaj_exts[puantaj_exts_index][7] = get_pay_salary.calc_days[i];
					puantaj_exts[puantaj_exts_index][8] = 0;
					puantaj_exts[puantaj_exts_index][9] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][33] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][10] = get_pay_salary.is_kidem[i];
					puantaj_exts[puantaj_exts_index][11] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/
					puantaj_exts[puantaj_exts_index][12] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/	
					puantaj_exts[puantaj_exts_index][13] = 1;/*damga var mi 1-var 0-yok */	
					puantaj_exts[puantaj_exts_index][14] = 0;/*issizlik var mi 1-var 0-yok */
					//SG 20140210 gune gore net odenegin net tutarini dogru gostermesi icin eklendi. 
					if (get_pay_salary.from_salary[i] eq 0 ) //ödenek net ise 
					{
						if (get_pay_salary.calc_days[i] eq 1)
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * (day_info));	
						}
						else if (get_pay_salary.calc_days[i] eq 2) //fili gün
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * fiili_gun_); 		
						}	
						else
						{
							if(for_ssk_day eq 0)
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];/*net ödenecek*/	
							else
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i] / 30 * day_info;/*net ödenecek*/
						}
					}
					else
					{
						if(for_ssk_day eq 0)
							puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];/*net ödenecek*/	
						else
							puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i] / 30 * day_info;/*net ödenecek*/
					}
					puantaj_exts[puantaj_exts_index][16] = get_pay_salary.comment_pay_id[i];/*ödenek id*/
					puantaj_exts[puantaj_exts_index][17] = '';
					puantaj_exts[puantaj_exts_index][18] = '';
					puantaj_exts[puantaj_exts_index][19] = '';
					puantaj_exts[puantaj_exts_index][20] = '';
					puantaj_exts[puantaj_exts_index][21] = '';
					puantaj_exts[puantaj_exts_index][22] = '';
					puantaj_exts[puantaj_exts_index][23] = '';
					puantaj_exts[puantaj_exts_index][24] = '';
					puantaj_exts[puantaj_exts_index][25] = '';
					puantaj_exts[puantaj_exts_index][26] = '';
					puantaj_exts[puantaj_exts_index][27] = '';
					puantaj_exts[puantaj_exts_index][28] = get_pay_salary.is_income[i];
					puantaj_exts[puantaj_exts_index][29] = '';
					puantaj_exts[puantaj_exts_index][30] = '';
					puantaj_exts[puantaj_exts_index][31] = get_pay_salary.factor_type[i];
					puantaj_exts[puantaj_exts_index][32] = get_pay_salary.comment_type[i];
					puantaj_exts[puantaj_exts_index][34] = get_pay_salary.is_not_execution[i];
					puantaj_exts[puantaj_exts_index][35] = '';
					puantaj_exts[puantaj_exts_index][36] = get_pay_salary.ssk_exemption_rate[i];
					puantaj_exts[puantaj_exts_index][37] = get_pay_salary.ssk_exemption_type[i];
					puantaj_exts[puantaj_exts_index][38] = '';
					puantaj_exts[puantaj_exts_index][39] = '';
					puantaj_exts[puantaj_exts_index][40] = '';
					puantaj_exts[puantaj_exts_index][41] = 0;

					puantaj_exts[puantaj_exts_index][42] = get_pay_salary.is_rd_damga[i];
					puantaj_exts[puantaj_exts_index][43] = get_pay_salary.is_rd_gelir[i];
					puantaj_exts[puantaj_exts_index][44] = get_pay_salary.is_rd_ssk[i];
					
					puantaj_exts[puantaj_exts_index][45] = 0;
					puantaj_exts[puantaj_exts_index][46] = 0;
					puantaj_exts[puantaj_exts_index][47] = 0;
					puantaj_exts[puantaj_exts_index][48] = get_pay_salary.total_hour[i];//varsa total saat
					puantaj_exts[puantaj_exts_index][49] = '';
						
					if(len(get_pay_salary.TAX_EXEMPTION_VALUE[i]))
					{
						tutar_ = get_pay_salary.ASIL_TUTAR[i] * get_pay_salary.TAX_EXEMPTION_VALUE[i];
						vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + tutar_;
						puantaj_exts[puantaj_exts_index][41] = tutar_;
					}
					if(len(get_pay_salary.TAX_EXEMPTION_RATE[i]))
					{
						tutar_ =  get_pay_salary.TAX_EXEMPTION_RATE[i];
						if(tutar_ gt get_pay_salary.ASIL_TUTAR[i]){
							tutar_ = get_pay_salary.ASIL_TUTAR[i];
						}
						vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + tutar_;
						puantaj_exts[puantaj_exts_index][41] = tutar_;
					}
					if(get_pay_salary.is_income[i] eq 1)
					{
						kazanca_dahil_olan_odenek_tutar = kazanca_dahil_olan_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
						if(get_pay_salary.tax[i] eq 1)
							kazanca_dahil_olan_odenek_tutar_muaf = kazanca_dahil_olan_odenek_tutar_muaf + puantaj_exts[puantaj_exts_index][3];	
					}
					if(get_pay_salary.comment_type[i] eq 2)
					{
						kazanc_tipli_odenek_tutar = kazanc_tipli_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
					}
					
				}
				else if ((get_pay_salary.ssk[i] eq 2) and (get_pay_salary.tax[i] eq 2) and (get_pay_salary.IS_DAMGA[i] eq 1) and (get_pay_salary.IS_ISSIZLIK[i] eq 0)) // sadece issizlik yok 
				{
					puantaj_exts_index = puantaj_exts_index + 1;
					puantaj_exts[puantaj_exts_index][1] = get_pay_salary.comment_PAY[i];
					puantaj_exts[puantaj_exts_index][2] = 1;
					if (get_pay_salary.calc_days[i] eq 1)
					{
						puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i] * (day_info));
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_ssk_tax_net_noissizlik = total_pay_ssk_tax_net_noissizlik + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay_ssk_tax_noissizlik = total_pay_ssk_tax_noissizlik + puantaj_exts[puantaj_exts_index][3];
					}
					else if(get_pay_salary.calc_days[i] eq 2)
					{
						puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i] * fiili_gun_);
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_ssk_tax_net_noissizlik = total_pay_ssk_tax_net_noissizlik + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay_ssk_tax_noissizlik = total_pay_ssk_tax_noissizlik + puantaj_exts[puantaj_exts_index][3];
					}
					else
					{
						if(for_ssk_day eq 0)
							puantaj_exts[puantaj_exts_index][3] = get_pay_salary.amount_pay[i];
						else
							puantaj_exts[puantaj_exts_index][3] = get_pay_salary.amount_pay[i] / 30 * day_info;
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_ssk_tax_net_noissizlik = total_pay_ssk_tax_net_noissizlik + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay_ssk_tax_noissizlik = total_pay_ssk_tax_noissizlik + puantaj_exts[puantaj_exts_index][3];
					}
					puantaj_exts[puantaj_exts_index][4] = 2;
					puantaj_exts[puantaj_exts_index][5] = 2;
					puantaj_exts[puantaj_exts_index][6] = 0;
					puantaj_exts[puantaj_exts_index][7] = get_pay_salary.calc_days[i];
					puantaj_exts[puantaj_exts_index][8] = 0;
					puantaj_exts[puantaj_exts_index][9] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][33] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][10] = get_pay_salary.is_kidem[i];
					puantaj_exts[puantaj_exts_index][11] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/
					puantaj_exts[puantaj_exts_index][12] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/	
					puantaj_exts[puantaj_exts_index][13] = 1;/*damga var mi 1-var 0-yok */	
					puantaj_exts[puantaj_exts_index][14] = 0;/*issizlik var mi 1-var 0-yok */
					//SG 20140210 gune gore net odenegin net tutarini dogru gostermesi icin eklendi. 
					if (get_pay_salary.from_salary[i] eq 0 ) //ödenek net ise 
					{
						if (get_pay_salary.calc_days[i] eq 1)
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * (day_info));	
						}
						else if (get_pay_salary.calc_days[i] eq 2) //fili gün
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * fiili_gun_); 		
						}	
						else
						{	
							if(for_ssk_day eq 0)
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];/*net ödenecek*/	
							else
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i] / 30 * day_info;/*net ödenecek*/
						}
					}
					else
					{
						if(for_ssk_day eq 0)
							puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];/*net ödenecek*/	
						else
							puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i] / 30 * day_info;/*net ödenecek*/
					}
					puantaj_exts[puantaj_exts_index][16] = get_pay_salary.comment_pay_id[i];/*ödenek id*/
					puantaj_exts[puantaj_exts_index][17] = '';
					puantaj_exts[puantaj_exts_index][18] = '';
					puantaj_exts[puantaj_exts_index][19] = '';
					puantaj_exts[puantaj_exts_index][20] = '';
					puantaj_exts[puantaj_exts_index][21] = '';
					puantaj_exts[puantaj_exts_index][22] = '';
					puantaj_exts[puantaj_exts_index][23] = '';
					puantaj_exts[puantaj_exts_index][24] = '';
					puantaj_exts[puantaj_exts_index][25] = '';
					puantaj_exts[puantaj_exts_index][26] = '';
					puantaj_exts[puantaj_exts_index][27] = '';
					puantaj_exts[puantaj_exts_index][28] = get_pay_salary.is_income[i];
					puantaj_exts[puantaj_exts_index][29] = '';
					puantaj_exts[puantaj_exts_index][30] = '';
					puantaj_exts[puantaj_exts_index][31] = get_pay_salary.factor_type[i];
					puantaj_exts[puantaj_exts_index][32] = get_pay_salary.comment_type[i];
					puantaj_exts[puantaj_exts_index][34] = get_pay_salary.is_not_execution[i];
					puantaj_exts[puantaj_exts_index][35] = '';
					puantaj_exts[puantaj_exts_index][36] = get_pay_salary.ssk_exemption_rate[i];
					puantaj_exts[puantaj_exts_index][37] = get_pay_salary.ssk_exemption_type[i];
					puantaj_exts[puantaj_exts_index][38] = '';
					puantaj_exts[puantaj_exts_index][39] = '';
					puantaj_exts[puantaj_exts_index][40] = '';
					puantaj_exts[puantaj_exts_index][41] = 0;

					puantaj_exts[puantaj_exts_index][42] = get_pay_salary.is_rd_damga[i];
					puantaj_exts[puantaj_exts_index][43] = get_pay_salary.is_rd_gelir[i];
					puantaj_exts[puantaj_exts_index][44] = get_pay_salary.is_rd_ssk[i];
					
					puantaj_exts[puantaj_exts_index][45] = 0;
					puantaj_exts[puantaj_exts_index][46] = 0;
					puantaj_exts[puantaj_exts_index][47] = 0;
					puantaj_exts[puantaj_exts_index][48] = get_pay_salary.total_hour[i];//varsa total saat
					puantaj_exts[puantaj_exts_index][49] = '';
					
					//ssk matraha dahil olmayan odenek tutari
					if(len(get_pay_salary.ssk_exemption_rate[i]) and len(get_pay_salary.ssk_exemption_type[i]))
					{
						if(get_pay_salary.ssk_exemption_type[i] eq 0)
							{
							tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL * get_pay_salary.ssk_exemption_rate[i] / 100;
							if(tutar_ gt puantaj_exts[puantaj_exts_index][3])
								tutar_ = puantaj_exts[puantaj_exts_index][3];
							}
						else if(get_pay_salary.ssk_exemption_type[i] eq 1)
							tutar_ = puantaj_exts[puantaj_exts_index][3] * get_pay_salary.ssk_exemption_rate[i] / 100;
						else if(get_pay_salary.ssk_exemption_type[i] eq 2)
						{
							if(get_pay_salary.calc_days[i] eq 1)//güne göre
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * ssk_days;
							else if(get_pay_salary.calc_days[i] eq 2)//fiili güne göre
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * fiili_gun_;
							else
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * get_pay_salary.ASIL_TUTAR[i];
						}
						if(tutar_ gt get_pay_salary.ASIL_TUTAR[i]){
							tutar_ = get_pay_salary.ASIL_TUTAR[i];
						}
						if(get_pay_salary.from_salary[i] eq 1)//brüt ödenek ise 
						{
							ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + tutar_;
						}
					}
						
					if(len(get_pay_salary.TAX_EXEMPTION_VALUE[i]))
					{
						tutar_ = get_pay_salary.ASIL_TUTAR[i] * get_pay_salary.TAX_EXEMPTION_VALUE[i];
						vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + tutar_;
					}
					if(len(get_pay_salary.TAX_EXEMPTION_RATE[i]))
					{
						tutar_ =  get_pay_salary.TAX_EXEMPTION_RATE[i];
						if(tutar_ gt get_pay_salary.ASIL_TUTAR[i]){
							tutar_ = get_pay_salary.ASIL_TUTAR[i];
						}
						vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + tutar_;
					}
					if(get_pay_salary.is_income[i] eq 1)
					{
						kazanca_dahil_olan_odenek_tutar = kazanca_dahil_olan_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
						if(get_pay_salary.tax[i] eq 1)
							kazanca_dahil_olan_odenek_tutar_muaf = kazanca_dahil_olan_odenek_tutar_muaf + puantaj_exts[puantaj_exts_index][3];	
					}
					if(get_pay_salary.comment_type[i] eq 2)
					{
						kazanc_tipli_odenek_tutar = kazanc_tipli_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
					}
				}
				else if ((get_pay_salary.ssk[i] eq 2) and (get_pay_salary.tax[i] eq 1) and (get_pay_salary.IS_DAMGA[i] eq 0) and (get_pay_salary.IS_ISSIZLIK[i] eq 0)) // sadece ssk var 
				{
					puantaj_exts_index = puantaj_exts_index + 1;
					puantaj_exts[puantaj_exts_index][1] = get_pay_salary.comment_PAY[i];
					puantaj_exts[puantaj_exts_index][2] = 1;
					if (get_pay_salary.calc_days[i] eq 1)
					{
						puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i] * (day_info));
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_ssk_net_noissizlik = total_pay_ssk_net_noissizlik + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay_ssk_noissizlik = total_pay_ssk_noissizlik + puantaj_exts[puantaj_exts_index][3];
					}
					else if (get_pay_salary.calc_days[i] eq 2)
					{
						puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i] * fiili_gun_);
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_ssk_net_noissizlik = total_pay_ssk_net_noissizlik + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay_ssk_noissizlik = total_pay_ssk_noissizlik + puantaj_exts[puantaj_exts_index][3];
					}	
					else
					{
						if(for_ssk_day eq 0)	
							puantaj_exts[puantaj_exts_index][3] = get_pay_salary.amount_pay[i];
						else
							puantaj_exts[puantaj_exts_index][3] = get_pay_salary.amount_pay[i] / 30 * day_info;
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_ssk_net_noissizlik = total_pay_ssk_net_noissizlik + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay_ssk_noissizlik = total_pay_ssk_noissizlik + puantaj_exts[puantaj_exts_index][3];
					}
					puantaj_exts[puantaj_exts_index][4] = 2;
					puantaj_exts[puantaj_exts_index][5] = 1;
					puantaj_exts[puantaj_exts_index][6] = 0;
					puantaj_exts[puantaj_exts_index][7] = get_pay_salary.calc_days[i];
					puantaj_exts[puantaj_exts_index][8] = 0;
					puantaj_exts[puantaj_exts_index][9] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][33] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][10] = get_pay_salary.is_kidem[i];
					puantaj_exts[puantaj_exts_index][11] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/
					puantaj_exts[puantaj_exts_index][12] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/	
					puantaj_exts[puantaj_exts_index][13] = 0;/*damga var mi 1-var 0-yok */	
					puantaj_exts[puantaj_exts_index][14] = 0;/*issizlik var mi 1-var 0-yok */
					//SG 20140210 gune gore net odenegin net tutarini dogru gostermesi icin eklendi. 
					if (get_pay_salary.from_salary[i] eq 0 ) //ödenek net ise 
					{
						if (get_pay_salary.calc_days[i] eq 1)
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * (day_info));	
						}
						else if (get_pay_salary.calc_days[i] eq 2) //fili gün
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * fiili_gun_); 		
						}	
						else
						{
							if(for_ssk_day eq 0)
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];/*net ödenecek*/	
							else
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i] / 30 * day_info;/*net ödenecek*/
						}
					}
					else
					{
						if(for_ssk_day eq 0)
							puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];/*net ödenecek*/	
						else
							puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i] / 30 * day_info;/*net ödenecek*/
					}
					puantaj_exts[puantaj_exts_index][16] = get_pay_salary.comment_pay_id[i];/*ödenek id*/
					puantaj_exts[puantaj_exts_index][17] = '';
					puantaj_exts[puantaj_exts_index][18] = '';
					puantaj_exts[puantaj_exts_index][19] = '';
					puantaj_exts[puantaj_exts_index][20] = '';
					puantaj_exts[puantaj_exts_index][21] = '';
					puantaj_exts[puantaj_exts_index][22] = '';
					puantaj_exts[puantaj_exts_index][23] = '';
					puantaj_exts[puantaj_exts_index][24] = '';
					puantaj_exts[puantaj_exts_index][25] = '';
					puantaj_exts[puantaj_exts_index][26] = '';
					puantaj_exts[puantaj_exts_index][27] = '';
					puantaj_exts[puantaj_exts_index][28] = get_pay_salary.is_income[i];
					puantaj_exts[puantaj_exts_index][29] = '';
					puantaj_exts[puantaj_exts_index][30] = '';
					puantaj_exts[puantaj_exts_index][31] = get_pay_salary.factor_type[i];
					puantaj_exts[puantaj_exts_index][32] = get_pay_salary.comment_type[i];
					puantaj_exts[puantaj_exts_index][34] = get_pay_salary.is_not_execution[i];
					puantaj_exts[puantaj_exts_index][35] = '';
					puantaj_exts[puantaj_exts_index][36] = get_pay_salary.ssk_exemption_rate[i];
					puantaj_exts[puantaj_exts_index][37] = get_pay_salary.ssk_exemption_type[i];
					puantaj_exts[puantaj_exts_index][38] = '';
					puantaj_exts[puantaj_exts_index][39] = '';
					puantaj_exts[puantaj_exts_index][40] = '';
					puantaj_exts[puantaj_exts_index][41] = 0;

					puantaj_exts[puantaj_exts_index][42] = get_pay_salary.is_rd_damga[i];
					puantaj_exts[puantaj_exts_index][43] = get_pay_salary.is_rd_gelir[i];
					puantaj_exts[puantaj_exts_index][44] = get_pay_salary.is_rd_ssk[i];
					
					puantaj_exts[puantaj_exts_index][45] = 0;
					puantaj_exts[puantaj_exts_index][46] = 0;
					puantaj_exts[puantaj_exts_index][47] = 0;
					puantaj_exts[puantaj_exts_index][48] = get_pay_salary.total_hour[i];//varsa total saat
					puantaj_exts[puantaj_exts_index][49] = '';
					
					//ssk matraha dahil olmayan odenek tutari
					if(len(get_pay_salary.ssk_exemption_rate[i]) and len(get_pay_salary.ssk_exemption_type[i]))
					{
						if(get_pay_salary.ssk_exemption_type[i] eq 0)
							{
							tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL * get_pay_salary.ssk_exemption_rate[i] / 100;
							if(tutar_ gt puantaj_exts[puantaj_exts_index][3])
								tutar_ = puantaj_exts[puantaj_exts_index][3];
							}
						else if(get_pay_salary.ssk_exemption_type[i] eq 1)
							tutar_ = puantaj_exts[puantaj_exts_index][3] * get_pay_salary.ssk_exemption_rate[i] / 100;
						else if(get_pay_salary.ssk_exemption_type[i] eq 2)
						{
							if(get_pay_salary.calc_days[i] eq 1)//güne göre
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * ssk_days;
							else if(get_pay_salary.calc_days[i] eq 2)//fiili güne göre
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * fiili_gun_;
							else
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * get_pay_salary.ASIL_TUTAR[i];
						}
						if(tutar_ gt get_pay_salary.ASIL_TUTAR[i]){
							tutar_ = get_pay_salary.ASIL_TUTAR[i];
						}
						if(get_pay_salary.from_salary[i] eq 1)//brüt ödenek ise 
						{
							ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + tutar_;
						}
					}
					if(get_pay_salary.is_income[i] eq 1)
					{
						kazanca_dahil_olan_odenek_tutar = kazanca_dahil_olan_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
						if(get_pay_salary.tax[i] eq 1)
							kazanca_dahil_olan_odenek_tutar_muaf = kazanca_dahil_olan_odenek_tutar_muaf + puantaj_exts[puantaj_exts_index][3];	
					}
					if(get_pay_salary.comment_type[i] eq 2)
					{
						kazanc_tipli_odenek_tutar = kazanc_tipli_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
					}
				}
				else if ((get_pay_salary.ssk[i] eq 2) and (get_pay_salary.tax[i] eq 1) and (get_pay_salary.IS_DAMGA[i] eq 1) and (get_pay_salary.IS_ISSIZLIK[i] eq 1)) // ssk 
				{
					puantaj_exts_index = puantaj_exts_index + 1;
					puantaj_exts[puantaj_exts_index][1] = get_pay_salary.comment_PAY[i];
					puantaj_exts[puantaj_exts_index][2] = 1;					
					puantaj_exts[puantaj_exts_index][4] = 2;
					puantaj_exts[puantaj_exts_index][5] = 1;
					puantaj_exts[puantaj_exts_index][6] = 0;
					puantaj_exts[puantaj_exts_index][7] = get_pay_salary.calc_days[i];
					puantaj_exts[puantaj_exts_index][8] = 0;
					puantaj_exts[puantaj_exts_index][9] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][33] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][10] = get_pay_salary.is_kidem[i];
					puantaj_exts[puantaj_exts_index][11] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/
					puantaj_exts[puantaj_exts_index][12] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/	
					puantaj_exts[puantaj_exts_index][13] = 1;/*damga var mi 1-var 0-yok */	
					puantaj_exts[puantaj_exts_index][14] = 1;/*issizlik var mi 1-var 0-yok */
					//SG 20140210 gune gore net odenegin net tutarini dogru gostermesi icin eklendi. 
					if (get_pay_salary.from_salary[i] eq 0 ) //ödenek net ise 
					{
						if (get_pay_salary.calc_days[i] eq 1)
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * (day_info));	
						}
						else if (get_pay_salary.calc_days[i] eq 2) //fili gün
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * fiili_gun_); 		
						}	
						else
						{
							if(for_ssk_day eq 0)
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];/*net ödenecek*/	
							else
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i] / 30 * day_info;/*net ödenecek*/
						}
					}
					else
					{
						if(for_ssk_day eq 0)
							puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];/*net ödenecek*/	
						else
							puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i] / 30 * day_info;/*net ödenecek*/
					}
					puantaj_exts[puantaj_exts_index][16] = get_pay_salary.comment_pay_id[i];/*ödenek id*/
					puantaj_exts[puantaj_exts_index][17] = '';
					puantaj_exts[puantaj_exts_index][18] = '';
					puantaj_exts[puantaj_exts_index][19] = '';
					puantaj_exts[puantaj_exts_index][20] = '';
					puantaj_exts[puantaj_exts_index][21] = '';
					puantaj_exts[puantaj_exts_index][22] = '';
					puantaj_exts[puantaj_exts_index][23] = '';
					puantaj_exts[puantaj_exts_index][24] = '';
					puantaj_exts[puantaj_exts_index][25] = '';
					puantaj_exts[puantaj_exts_index][26] = '';
					puantaj_exts[puantaj_exts_index][27] = '';
					puantaj_exts[puantaj_exts_index][28] = get_pay_salary.is_income[i];
					puantaj_exts[puantaj_exts_index][29] = '';
					puantaj_exts[puantaj_exts_index][30] = '';
					puantaj_exts[puantaj_exts_index][31] = get_pay_salary.factor_type[i];
					puantaj_exts[puantaj_exts_index][32] = get_pay_salary.comment_type[i];
					puantaj_exts[puantaj_exts_index][34] = get_pay_salary.is_not_execution[i];
					puantaj_exts[puantaj_exts_index][35] = '';
					puantaj_exts[puantaj_exts_index][36] = get_pay_salary.ssk_exemption_rate[i];
					puantaj_exts[puantaj_exts_index][37] = get_pay_salary.ssk_exemption_type[i];					
					puantaj_exts[puantaj_exts_index][38] = '';
					puantaj_exts[puantaj_exts_index][39] = '';		
					puantaj_exts[puantaj_exts_index][40] = '';
					puantaj_exts[puantaj_exts_index][41] = 0;

					puantaj_exts[puantaj_exts_index][42] = get_pay_salary.is_rd_damga[i];
					puantaj_exts[puantaj_exts_index][43] = get_pay_salary.is_rd_gelir[i];
					puantaj_exts[puantaj_exts_index][44] = get_pay_salary.is_rd_ssk[i];
					
					puantaj_exts[puantaj_exts_index][45] = 0;
					puantaj_exts[puantaj_exts_index][46] = 0;
					puantaj_exts[puantaj_exts_index][47] = 0;
					puantaj_exts[puantaj_exts_index][48] = get_pay_salary.total_hour[i];//varsa total saat
					puantaj_exts[puantaj_exts_index][49] = '';								
					
					if (get_pay_salary.calc_days[i] eq 1)
					{
						puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i]) * (day_info);
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_ssk_net = total_pay_ssk_net + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay_ssk = total_pay_ssk + puantaj_exts[puantaj_exts_index][3];
					}
					else if (get_pay_salary.calc_days[i] eq 2)
					{
						puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i]) * fiili_gun_;
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_ssk_net = total_pay_ssk_net + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay_ssk = total_pay_ssk + puantaj_exts[puantaj_exts_index][3];
					}	
					else
					{
						if(for_ssk_day eq 0)
							puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i]);
						else
							puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i]) / 30 * day_info;

						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_ssk_net = total_pay_ssk_net + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay_ssk = total_pay_ssk + puantaj_exts[puantaj_exts_index][8];
					}
					
					//ssk matraha dahil olmayan odenek tutari
					if(len(get_pay_salary.ssk_exemption_rate[i]) and len(get_pay_salary.ssk_exemption_type[i]))
					{
						if(get_pay_salary.ssk_exemption_type[i] eq 0)
							{
							tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL * get_pay_salary.ssk_exemption_rate[i] / 100;
								if(tutar_ gt puantaj_exts[puantaj_exts_index][3])
								{
									if(get_pay_salary.from_salary[i] eq 0)
									{
										//
									}
									else 
									{
										tutar_ = puantaj_exts[puantaj_exts_index][3];
									}									
								}
							}
						else if(get_pay_salary.ssk_exemption_type[i] eq 1)
							tutar_ = puantaj_exts[puantaj_exts_index][3] * get_pay_salary.ssk_exemption_rate[i] / 100;
						else if(get_pay_salary.ssk_exemption_type[i] eq 2)
						{
							if(get_pay_salary.calc_days[i] eq 1)//güne göre
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * ssk_days;
							else if(get_pay_salary.calc_days[i] eq 2)//fiili güne göre
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * fiili_gun_;
							else
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * get_pay_salary.ASIL_TUTAR[i];
						}				
						if(tutar_ gt puantaj_exts[puantaj_exts_index][15])
						{
							if(get_pay_salary.from_salary[i] neq 0)
							{
								tutar_ = puantaj_exts[puantaj_exts_index][15];

							}								
						}
						ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + tutar_;
						 
						puantaj_exts[puantaj_exts_index][40] = tutar_;
						
					}					
					if(get_pay_salary.is_income[i] eq 1)
					{
						if(puantaj_exts[puantaj_exts_index][8] gt 0)
						{
							kazanca_dahil_olan_odenek_tutar = kazanca_dahil_olan_odenek_tutar + puantaj_exts[puantaj_exts_index][8];
							if(get_pay_salary.tax[i] eq 1)
								kazanca_dahil_olan_odenek_tutar_muaf = kazanca_dahil_olan_odenek_tutar_muaf + puantaj_exts[puantaj_exts_index][8];	
						}
						else
						{
							kazanca_dahil_olan_odenek_tutar = kazanca_dahil_olan_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
							if(get_pay_salary.tax[i] eq 1)
								kazanca_dahil_olan_odenek_tutar_muaf = kazanca_dahil_olan_odenek_tutar_muaf + puantaj_exts[puantaj_exts_index][3];	
						}
					}
					if(get_pay_salary.comment_type[i] eq 2)
					{
						if(puantaj_exts[puantaj_exts_index][8] gt 0)
						{
							kazanc_tipli_odenek_tutar = kazanc_tipli_odenek_tutar + puantaj_exts[puantaj_exts_index][8];
						}
						else
						{
							kazanc_tipli_odenek_tutar = kazanc_tipli_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
						}
					}
				}
				else if ((get_pay_salary.ssk[i] eq 1) and (get_pay_salary.tax[i] eq 2) and (get_pay_salary.IS_DAMGA[i] eq 0) and (get_pay_salary.IS_ISSIZLIK[i] eq 0) ) // ssk,vergi,damga,issizlik yok 
				{
					puantaj_exts_index = puantaj_exts_index + 1;
					puantaj_exts[puantaj_exts_index][1] = get_pay_salary.comment_PAY[i];
					puantaj_exts[puantaj_exts_index][2] = 1;
					puantaj_exts[puantaj_exts_index][4] = 1;/*ssk var mi 1-yok 2-var*/
					puantaj_exts[puantaj_exts_index][5] = 2;/*vergi var mi 1-yok 2-var*/
					puantaj_exts[puantaj_exts_index][6] = 0;
					puantaj_exts[puantaj_exts_index][7] = get_pay_salary.calc_days[i];
					puantaj_exts[puantaj_exts_index][8] = 0;
					puantaj_exts[puantaj_exts_index][9] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][33] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][10] = get_pay_salary.is_kidem[i];
					puantaj_exts[puantaj_exts_index][11] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/
					puantaj_exts[puantaj_exts_index][12] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/	
					puantaj_exts[puantaj_exts_index][13] = 0;/*damga var mi 1-var 0-yok */	
					puantaj_exts[puantaj_exts_index][14] = 0;/*issizlik var mi 1-var 0-yok */
					
					//SG 20140210 gune gore net odenegin net tutarini dogru gostermesi icin eklendi. 
					if (get_pay_salary.from_salary[i] eq 0 ) //ödenek net ise 
					{
						if (get_pay_salary.calc_days[i] eq 1)
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * (day_info));	
						}
						else if (get_pay_salary.calc_days[i] eq 2) //fili gün
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * fiili_gun_/30); 		
						}	
						else
						{
							if(for_ssk_day eq 0)
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];/*net ödenecek*/	
							else
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i] / 30 * day_info;/*net ödenecek*/
						}
					}
					else
					{
						if(for_ssk_day eq 0)
							puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];/*net ödenecek*/	
						else
							puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i] / 30 * day_info;/*net ödenecek*/
					}
					puantaj_exts[puantaj_exts_index][16] = get_pay_salary.comment_pay_id[i];/*ödenek id*/
					puantaj_exts[puantaj_exts_index][17] = '';
					puantaj_exts[puantaj_exts_index][18] = '';
					puantaj_exts[puantaj_exts_index][19] = '';
					puantaj_exts[puantaj_exts_index][20] = '';
					puantaj_exts[puantaj_exts_index][21] = '';
					puantaj_exts[puantaj_exts_index][22] = '';
					puantaj_exts[puantaj_exts_index][23] = '';
					puantaj_exts[puantaj_exts_index][24] = '';
					puantaj_exts[puantaj_exts_index][25] = '';
					puantaj_exts[puantaj_exts_index][26] = '';
					puantaj_exts[puantaj_exts_index][27] = '';
					puantaj_exts[puantaj_exts_index][28] = get_pay_salary.is_income[i];
					puantaj_exts[puantaj_exts_index][29] = '';
					puantaj_exts[puantaj_exts_index][30] = '';
					puantaj_exts[puantaj_exts_index][31] = get_pay_salary.factor_type[i];
					puantaj_exts[puantaj_exts_index][32] = get_pay_salary.comment_type[i];
					puantaj_exts[puantaj_exts_index][34] = get_pay_salary.is_not_execution[i];
					puantaj_exts[puantaj_exts_index][35] = '';
					puantaj_exts[puantaj_exts_index][36] = get_pay_salary.ssk_exemption_rate[i];
					puantaj_exts[puantaj_exts_index][37] = get_pay_salary.ssk_exemption_type[i];
					puantaj_exts[puantaj_exts_index][38] = '';
					puantaj_exts[puantaj_exts_index][39] = '';
					puantaj_exts[puantaj_exts_index][40] = '';
					puantaj_exts[puantaj_exts_index][41] = 0;

					puantaj_exts[puantaj_exts_index][42] = get_pay_salary.is_rd_damga[i];
					puantaj_exts[puantaj_exts_index][43] = get_pay_salary.is_rd_gelir[i];
					puantaj_exts[puantaj_exts_index][44] = get_pay_salary.is_rd_ssk[i];
					
					puantaj_exts[puantaj_exts_index][45] = 0;
					puantaj_exts[puantaj_exts_index][46] = 0;
					puantaj_exts[puantaj_exts_index][47] = 0;
					puantaj_exts[puantaj_exts_index][48] = get_pay_salary.total_hour[i];//varsa total saat
					puantaj_exts[puantaj_exts_index][49] = '';

					
					if (get_pay_salary.calc_days[i] eq 1)
					{
						// son ayın çalışma gününe bakarak ödeme yapılır
						puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i] * (day_info));
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_net = total_pay_net + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay = total_pay + puantaj_exts[puantaj_exts_index][3];
					}
					else if(get_pay_salary.calc_days[i] eq 2)
					{
						// son ayın çalışma gününe bakarak ödeme yapılır
						puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i] * fiili_gun_);
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_net = total_pay_net + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay = total_pay + puantaj_exts[puantaj_exts_index][3];
					}
					else
					{
						if(for_ssk_day eq 0)
							puantaj_exts[puantaj_exts_index][3] = get_pay_salary.amount_pay[i];
						else
							puantaj_exts[puantaj_exts_index][3] = get_pay_salary.amount_pay[i] / 30 * day_info; 
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_net = total_pay_net + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay = total_pay + puantaj_exts[puantaj_exts_index][3];
					}
					if(get_pay_salary.is_income[i] eq 1)
					{
						kazanca_dahil_olan_odenek_tutar = kazanca_dahil_olan_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
						if(get_pay_salary.tax[i] eq 1)
							kazanca_dahil_olan_odenek_tutar_muaf = kazanca_dahil_olan_odenek_tutar_muaf + puantaj_exts[puantaj_exts_index][3];	
					}
					if(get_pay_salary.comment_type[i] eq 2)
					{
						kazanc_tipli_odenek_tutar = kazanc_tipli_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
					}
					
				}
				else if ((get_pay_salary.ssk[i] eq 2) and (get_pay_salary.tax[i] eq 1) and (get_pay_salary.IS_DAMGA[i] eq 0) and (get_pay_salary.IS_ISSIZLIK[i] eq 1) )// dv ve vergi yok 03032022ERU
				{
					
					puantaj_exts_index = puantaj_exts_index + 1;
					puantaj_exts[puantaj_exts_index][1] = get_pay_salary.comment_PAY[i];
					puantaj_exts[puantaj_exts_index][2] = 1;					
					puantaj_exts[puantaj_exts_index][4] = 2;
					puantaj_exts[puantaj_exts_index][5] = 1;
					puantaj_exts[puantaj_exts_index][6] = 0;
					puantaj_exts[puantaj_exts_index][7] = get_pay_salary.calc_days[i];
					puantaj_exts[puantaj_exts_index][8] = 0;
					puantaj_exts[puantaj_exts_index][9] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][33] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][10] = get_pay_salary.is_kidem[i];
					puantaj_exts[puantaj_exts_index][11] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/
					puantaj_exts[puantaj_exts_index][12] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/	
					puantaj_exts[puantaj_exts_index][13] = 0;/*damga var mi 1-var 0-yok */	
					puantaj_exts[puantaj_exts_index][14] = 1;/*issizlik var mi 1-var 0-yok */
					
					puantaj_exts[puantaj_exts_index][16] = get_pay_salary.comment_pay_id[i];/*ödenek id*/
					puantaj_exts[puantaj_exts_index][17] = '';
					puantaj_exts[puantaj_exts_index][18] = '';
					puantaj_exts[puantaj_exts_index][19] = '';
					puantaj_exts[puantaj_exts_index][20] = '';
					puantaj_exts[puantaj_exts_index][21] = '';
					puantaj_exts[puantaj_exts_index][22] = '';
					puantaj_exts[puantaj_exts_index][23] = '';
					puantaj_exts[puantaj_exts_index][24] = '';
					puantaj_exts[puantaj_exts_index][25] = '';
					puantaj_exts[puantaj_exts_index][26] = '';
					puantaj_exts[puantaj_exts_index][27] = '';
					puantaj_exts[puantaj_exts_index][28] = get_pay_salary.is_income[i];
					puantaj_exts[puantaj_exts_index][29] = '';
					puantaj_exts[puantaj_exts_index][30] = '';
					puantaj_exts[puantaj_exts_index][31] = get_pay_salary.factor_type[i];
					puantaj_exts[puantaj_exts_index][32] = get_pay_salary.comment_type[i];
					puantaj_exts[puantaj_exts_index][34] = get_pay_salary.is_not_execution[i];
					puantaj_exts[puantaj_exts_index][35] = '';
					puantaj_exts[puantaj_exts_index][36] = get_pay_salary.ssk_exemption_rate[i];
					puantaj_exts[puantaj_exts_index][37] = get_pay_salary.ssk_exemption_type[i];					
					puantaj_exts[puantaj_exts_index][38] = '';
					puantaj_exts[puantaj_exts_index][39] = '';		
					puantaj_exts[puantaj_exts_index][40] = '';
					puantaj_exts[puantaj_exts_index][41] = 0;

					puantaj_exts[puantaj_exts_index][42] = get_pay_salary.is_rd_damga[i];
					puantaj_exts[puantaj_exts_index][43] = get_pay_salary.is_rd_gelir[i];
					puantaj_exts[puantaj_exts_index][44] = get_pay_salary.is_rd_ssk[i];
					
					puantaj_exts[puantaj_exts_index][45] = 0;
					puantaj_exts[puantaj_exts_index][46] = 0;
					puantaj_exts[puantaj_exts_index][47] = 0;
					puantaj_exts[puantaj_exts_index][48] = get_pay_salary.total_hour[i];//varsa total saat		
					puantaj_exts[puantaj_exts_index][49] = '';						
					
					if (get_pay_salary.calc_days[i] eq 1)
					{
						puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i]) * (day_info);
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_ssk_net_damgasiz = total_pay_ssk_net_damgasiz + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay_ssk_damgasiz = total_pay_ssk_damgasiz + puantaj_exts[puantaj_exts_index][3];
					}
					else if (get_pay_salary.calc_days[i] eq 2)
					{
						puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i]) * fiili_gun_;
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_ssk_net_damgasiz = total_pay_ssk_net_damgasiz + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay_ssk_damgasiz = total_pay_ssk_damgasiz + puantaj_exts[puantaj_exts_index][3];
					}	
					else
					{
						if(for_ssk_day eq 0)
							puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i]);
						else
							puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i]) / 30 * day_info;

						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_ssk_net_damgasiz = total_pay_ssk_net_damgasiz + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay_ssk_damgasiz = total_pay_ssk_damgasiz + puantaj_exts[puantaj_exts_index][8];
					}
					if (get_pay_salary.from_salary[i] eq 0 ) //ödenek net ise 
					{
						if (get_pay_salary.calc_days[i] eq 1)
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * (day_info));	
						}
						else if (get_pay_salary.calc_days[i] eq 2) //fili gün
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * fiili_gun_); 		
						}	
						else
						{
							if(for_ssk_day eq 0)
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];/*net ödenecek*/	
							else
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i] / 30 * day_info;/*net ödenecek*/
						}
					}
					else
					{
						if(for_ssk_day eq 0)
						{
							if (get_pay_salary.calc_days[i] eq 2) //fili gün
								puantaj_exts[puantaj_exts_index][15] =  puantaj_exts[puantaj_exts_index][3];/*net ödenecek*/
							else
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];
						}
						else
							puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i] / 30 * day_info;/*net ödenecek*/
					}
					//ssk matraha dahil olmayan odenek tutari
					if(len(get_pay_salary.ssk_exemption_rate[i]) and len(get_pay_salary.ssk_exemption_type[i]))
					{
						if(get_pay_salary.ssk_exemption_type[i] eq 0)
						{
							tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL * get_pay_salary.ssk_exemption_rate[i] / 100;
								if(tutar_ gt puantaj_exts[puantaj_exts_index][3])
								{
									if(get_pay_salary.from_salary[i] neq 0)
									{
										tutar_ = puantaj_exts[puantaj_exts_index][3];
									}									
								}
						}
						else if(get_pay_salary.ssk_exemption_type[i] eq 1)
							tutar_ = puantaj_exts[puantaj_exts_index][3] * get_pay_salary.ssk_exemption_rate[i] / 100;
						else if(get_pay_salary.ssk_exemption_type[i] eq 2)
						{
							if(get_pay_salary.calc_days[i] eq 1)//güne göre
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * ssk_days;
							else if(get_pay_salary.calc_days[i] eq 2)//fiili güne göre
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * fiili_gun_;
							else
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * get_pay_salary.ASIL_TUTAR[i];
						}		
						if(tutar_ gt puantaj_exts[puantaj_exts_index][15])
						{
							if(get_pay_salary.from_salary[i] neq 0)
							{
								tutar_ = puantaj_exts[puantaj_exts_index][15];
							}
															
						}
						ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + tutar_;
						 
						puantaj_exts[puantaj_exts_index][40] = tutar_;
						
					}			
					if(get_pay_salary.is_income[i] eq 1)
					{
						if(puantaj_exts[puantaj_exts_index][8] gt 0)
						{
							kazanca_dahil_olan_odenek_tutar = kazanca_dahil_olan_odenek_tutar + puantaj_exts[puantaj_exts_index][8];
							if(get_pay_salary.tax[i] eq 1)
								kazanca_dahil_olan_odenek_tutar_muaf = kazanca_dahil_olan_odenek_tutar_muaf + puantaj_exts[puantaj_exts_index][8];	
						}
						else
						{
							kazanca_dahil_olan_odenek_tutar = kazanca_dahil_olan_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
							if(get_pay_salary.tax[i] eq 1)
								kazanca_dahil_olan_odenek_tutar_muaf = kazanca_dahil_olan_odenek_tutar_muaf + puantaj_exts[puantaj_exts_index][3];	
						}
					}
					if(get_pay_salary.comment_type[i] eq 2)
					{
						if(puantaj_exts[puantaj_exts_index][8] gt 0)
						{
							kazanc_tipli_odenek_tutar = kazanc_tipli_odenek_tutar + puantaj_exts[puantaj_exts_index][8];
						}
						else
						{
							kazanc_tipli_odenek_tutar = kazanc_tipli_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
						}
					}
				}
				else if ((get_pay_salary.ssk[i] eq 2) and (get_pay_salary.tax[i] eq 2) and (get_pay_salary.IS_DAMGA[i] eq 0) and (get_pay_salary.IS_ISSIZLIK[i] eq 1) )// dv yok 22062022ERU (Son iş)
				{
					
					puantaj_exts_index = puantaj_exts_index + 1;
					puantaj_exts[puantaj_exts_index][1] = get_pay_salary.comment_PAY[i];
					puantaj_exts[puantaj_exts_index][2] = 1;					
					puantaj_exts[puantaj_exts_index][4] = 2;
					puantaj_exts[puantaj_exts_index][5] = 2;
					puantaj_exts[puantaj_exts_index][6] = 0;
					puantaj_exts[puantaj_exts_index][7] = get_pay_salary.calc_days[i];
					puantaj_exts[puantaj_exts_index][8] = 0;
					puantaj_exts[puantaj_exts_index][9] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][33] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][10] = get_pay_salary.is_kidem[i];
					puantaj_exts[puantaj_exts_index][11] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/
					puantaj_exts[puantaj_exts_index][12] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/	
					puantaj_exts[puantaj_exts_index][13] = 0;/*damga var mi 1-var 0-yok */	
					puantaj_exts[puantaj_exts_index][14] = 1;/*issizlik var mi 1-var 0-yok */
					
					puantaj_exts[puantaj_exts_index][16] = get_pay_salary.comment_pay_id[i];/*ödenek id*/
					puantaj_exts[puantaj_exts_index][17] = '';
					puantaj_exts[puantaj_exts_index][18] = '';
					puantaj_exts[puantaj_exts_index][19] = '';
					puantaj_exts[puantaj_exts_index][20] = '';
					puantaj_exts[puantaj_exts_index][21] = '';
					puantaj_exts[puantaj_exts_index][22] = '';
					puantaj_exts[puantaj_exts_index][23] = '';
					puantaj_exts[puantaj_exts_index][24] = '';
					puantaj_exts[puantaj_exts_index][25] = '';
					puantaj_exts[puantaj_exts_index][26] = '';
					puantaj_exts[puantaj_exts_index][27] = '';
					puantaj_exts[puantaj_exts_index][28] = get_pay_salary.is_income[i];
					puantaj_exts[puantaj_exts_index][29] = '';
					puantaj_exts[puantaj_exts_index][30] = '';
					puantaj_exts[puantaj_exts_index][31] = get_pay_salary.factor_type[i];
					puantaj_exts[puantaj_exts_index][32] = get_pay_salary.comment_type[i];
					puantaj_exts[puantaj_exts_index][34] = get_pay_salary.is_not_execution[i];
					puantaj_exts[puantaj_exts_index][35] = '';
					puantaj_exts[puantaj_exts_index][36] = get_pay_salary.ssk_exemption_rate[i];
					puantaj_exts[puantaj_exts_index][37] = get_pay_salary.ssk_exemption_type[i];					
					puantaj_exts[puantaj_exts_index][38] = get_pay_salary.TAX_EXEMPTION_VALUE[i];
					puantaj_exts[puantaj_exts_index][39] = get_pay_salary.TAX_EXEMPTION_RATE[i];	
					puantaj_exts[puantaj_exts_index][40] = '';
					puantaj_exts[puantaj_exts_index][41] = 0;

					puantaj_exts[puantaj_exts_index][42] = get_pay_salary.is_rd_damga[i];
					puantaj_exts[puantaj_exts_index][43] = get_pay_salary.is_rd_gelir[i];
					puantaj_exts[puantaj_exts_index][44] = get_pay_salary.is_rd_ssk[i];
					
					puantaj_exts[puantaj_exts_index][45] = 0;
					puantaj_exts[puantaj_exts_index][46] = 0;
					puantaj_exts[puantaj_exts_index][47] = 0;
					puantaj_exts[puantaj_exts_index][48] = get_pay_salary.total_hour[i];//varsa total saat		
					puantaj_exts[puantaj_exts_index][49] = '';						
					
					if (get_pay_salary.calc_days[i] eq 1)
					{
						puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i]) * (day_info);
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_ssk_tax_net_notstamp = total_pay_ssk_tax_net_notstamp + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay_ssk_tax_notstamp = total_pay_ssk_tax_notstamp + puantaj_exts[puantaj_exts_index][3];
					}
					else if (get_pay_salary.calc_days[i] eq 2)
					{
						puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i]) * fiili_gun_;
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_ssk_tax_net_notstamp = total_pay_ssk_tax_net_notstamp + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay_ssk_tax_notstamp = total_pay_ssk_tax_notstamp + puantaj_exts[puantaj_exts_index][3];
					}	
					else
					{
						if(for_ssk_day eq 0)
							puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i]);
						else
							puantaj_exts[puantaj_exts_index][3] = (get_pay_salary.amount_pay[i]) / 30 * day_info;

						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_ssk_tax_net_notstamp = total_pay_ssk_tax_net_notstamp + puantaj_exts[puantaj_exts_index][3];
						else //brüt
							total_pay_ssk_tax_notstamp = total_pay_ssk_tax_notstamp + puantaj_exts[puantaj_exts_index][8];

							
					}
					if (get_pay_salary.from_salary[i] eq 0 ) //ödenek net ise 
					{
						if (get_pay_salary.calc_days[i] eq 1)
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * (day_info));	
						}
						else if (get_pay_salary.calc_days[i] eq 2) //fili gün
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * fiili_gun_); 		
						}	
						else
						{
							if(for_ssk_day eq 0)
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];/*net ödenecek*/	
							else
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i] / 30 * day_info;/*net ödenecek*/
						}
					}
					else
					{
						if(for_ssk_day eq 0)
						{
							if (get_pay_salary.calc_days[i] eq 2) //fili gün
								puantaj_exts[puantaj_exts_index][15] =  puantaj_exts[puantaj_exts_index][3];/*net ödenecek*/
							else
								puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];
						}
						else
							puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i] / 30 * day_info;/*net ödenecek*/
					}
					//ssk matraha dahil olmayan odenek tutari
					if(len(get_pay_salary.ssk_exemption_rate[i]) and len(get_pay_salary.ssk_exemption_type[i]))
					{
						if(get_pay_salary.ssk_exemption_type[i] eq 0)
						{
							tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL * get_pay_salary.ssk_exemption_rate[i] / 100;
								if(tutar_ gt puantaj_exts[puantaj_exts_index][3])
								{
									if(get_pay_salary.from_salary[i] neq 0)
									{
										tutar_ = puantaj_exts[puantaj_exts_index][3];
									}									
								}
						}
						else if(get_pay_salary.ssk_exemption_type[i] eq 1)
							tutar_ = puantaj_exts[puantaj_exts_index][3] * get_pay_salary.ssk_exemption_rate[i] / 100;
						else if(get_pay_salary.ssk_exemption_type[i] eq 2)
						{
							if(get_pay_salary.calc_days[i] eq 1)//güne göre
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * ssk_days;
							else if(get_pay_salary.calc_days[i] eq 2)//fiili güne göre
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * fiili_gun_;
							else
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * get_pay_salary.ASIL_TUTAR[i];
						}		
						if(tutar_ gt puantaj_exts[puantaj_exts_index][15])
						{
							if(get_pay_salary.from_salary[i] neq 0)
							{
								tutar_ = puantaj_exts[puantaj_exts_index][15];
							}
															
						}
						ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + tutar_;
						 
						puantaj_exts[puantaj_exts_index][40] = tutar_;
						
					}			
					if(get_pay_salary.is_income[i] eq 1)
					{
						if(puantaj_exts[puantaj_exts_index][8] gt 0)
						{
							kazanca_dahil_olan_odenek_tutar = kazanca_dahil_olan_odenek_tutar + puantaj_exts[puantaj_exts_index][8];
							if(get_pay_salary.tax[i] eq 1)
								kazanca_dahil_olan_odenek_tutar_muaf = kazanca_dahil_olan_odenek_tutar_muaf + puantaj_exts[puantaj_exts_index][8];	
						}
						else
						{
							kazanca_dahil_olan_odenek_tutar = kazanca_dahil_olan_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
							if(get_pay_salary.tax[i] eq 1)
								kazanca_dahil_olan_odenek_tutar_muaf = kazanca_dahil_olan_odenek_tutar_muaf + puantaj_exts[puantaj_exts_index][3];	
						}
					}
					if(get_pay_salary.comment_type[i] eq 2)
					{
						if(puantaj_exts[puantaj_exts_index][8] gt 0)
						{
							kazanc_tipli_odenek_tutar = kazanc_tipli_odenek_tutar + puantaj_exts[puantaj_exts_index][8];
						}
						else
						{
							kazanc_tipli_odenek_tutar = kazanc_tipli_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
						}
					}
				}
				
			}
			else if (listfindnocase('2,3,4',get_pay_salary.method_pay[i])) // %
			{
				ek_odenek_baz_ucret = get_hr_salary.salary;
				if(get_hr_salary.salary_type eq 0)
				{
					ek_odenek_ucret_saat_ = get_hr_salary.salary;
					ek_odenek_ucret_gun_ = get_hr_salary.salary * 7.5;
					ek_odenek_ucret_ay_ = get_hr_salary.salary * 225;
					
					//ek_odenek_ucret_ay_ = get_hr_salary.salary * total_hours; //SG 20131231 % aylık ödenekte yukarıdaki ek_odenek_ucret_ay_ tutarını kullanması gerkmektedir
					//abort('get_hr_salary.salary:#get_hr_salary.salary# ssk_days:#ssk_days#');
				}
				else if(get_hr_salary.salary_type eq 1)
				{
					ek_odenek_ucret_saat_ = get_hr_salary.salary / 7.5;
					ek_odenek_ucret_gun_ = get_hr_salary.salary;
					ek_odenek_ucret_ay_ = get_hr_salary.salary * 30;
				}
				else if(get_hr_salary.salary_type eq 2)
				{
					ek_odenek_ucret_saat_ = get_hr_salary.salary / 225;
					ek_odenek_ucret_gun_ = get_hr_salary.salary / 30;
					ek_odenek_ucret_ay_ = get_hr_salary.salary;
				}
				
				if(get_pay_salary.method_pay[i] eq 2)
					ek_odenek_baz_ucret_ = ek_odenek_ucret_ay_;
				else if(get_pay_salary.method_pay[i] eq 3)
					ek_odenek_baz_ucret_ = ek_odenek_ucret_gun_;
				else
					ek_odenek_baz_ucret_ = ek_odenek_ucret_saat_;
				
				if ((get_pay_salary.ssk[i] eq 2) and (get_pay_salary.tax[i] eq 2) ) // ssk ve vergi
				{
					puantaj_exts_index = puantaj_exts_index + 1;
					if (get_pay_salary.calc_days[i] eq 1)
					{
						puantaj_exts[puantaj_exts_index][8] = (((ek_odenek_baz_ucret_/100) * get_pay_salary.amount_pay[i]) * (day_info));
						if(get_pay_salary.from_salary[i] eq 0)//net
						{
							total_pay_ssk_tax_net = total_pay_ssk_tax_net + puantaj_exts[puantaj_exts_index][8];
						}
						else //brüt
							total_pay_ssk_tax = total_pay_ssk_tax + puantaj_exts[puantaj_exts_index][8];
					}
					else if(get_pay_salary.calc_days[i] eq 2)
					{
						puantaj_exts[puantaj_exts_index][8] = (((ek_odenek_baz_ucret_/100) * get_pay_salary.amount_pay[i]) * fiili_gun_);
						if(get_pay_salary.from_salary[i] eq 0)//net
						{
							total_pay_ssk_tax_net = total_pay_ssk_tax_net + puantaj_exts[puantaj_exts_index][8];
						}
						else //brüt
							total_pay_ssk_tax = total_pay_ssk_tax + puantaj_exts[puantaj_exts_index][8];
					}
					else
					{
						if(get_pay_salary.METHOD_PAY[i] eq 2 and (get_pay_salary.FROM_SALARY[i] eq 0 or get_pay_salary.FROM_SALARY[i] eq 1) and len(get_pay_salary.MULTIPLIER[i]) and get_pay_salary.MULTIPLIER[i] neq 0 and get_pay_salary.amount_pay[i] eq 0)
							
						{
							puantaj_exts[puantaj_exts_index][8] = ek_odenek_baz_ucret_* get_pay_salary.MULTIPLIER[i];
						}
						else if(get_pay_salary.METHOD_PAY[i] eq 4 and get_pay_salary.calc_days[i] eq 3)
						{
							puantaj_exts[puantaj_exts_index][8] = (ek_odenek_baz_ucret_ * get_pay_salary.amount_pay[i] / 100) * total_hours ; 
						}
						else
						{
							puantaj_exts[puantaj_exts_index][8] = ( (ek_odenek_baz_ucret_/100) * get_pay_salary.amount_pay[i] );

						}
						
						if(get_pay_salary.from_salary[i] eq 0)//net
						{
							total_pay_ssk_tax_net = total_pay_ssk_tax_net + puantaj_exts[puantaj_exts_index][8];
						}
						else //brüt
							total_pay_ssk_tax = total_pay_ssk_tax + puantaj_exts[puantaj_exts_index][8];
					}
					
					puantaj_exts[puantaj_exts_index][1] = get_pay_salary.comment_PAY[i];
					puantaj_exts[puantaj_exts_index][2] = 2;

					//Çalışan net ücretliyse, ek ödenek aylık üzerindense ve çarpanı varsa
					if(get_pay_salary.METHOD_PAY[i] eq 2 and (get_pay_salary.FROM_SALARY[i] eq 0 or get_pay_salary.FROM_SALARY[i] eq 1) and len(get_pay_salary.MULTIPLIER[i]) and get_pay_salary.MULTIPLIER[i] neq 0 and get_hr_salary.gross_net eq 1 and get_pay_salary.amount_pay[i] eq 0)		
					{
						puantaj_exts[puantaj_exts_index][3] = ek_odenek_baz_ucret_* get_pay_salary.MULTIPLIER[i];
					}
					else
						puantaj_exts[puantaj_exts_index][3] = get_pay_salary.amount_pay[i];
					puantaj_exts[puantaj_exts_index][4] = 2;
					puantaj_exts[puantaj_exts_index][5] = 2;
					puantaj_exts[puantaj_exts_index][6] = 0;
					puantaj_exts[puantaj_exts_index][7] = get_pay_salary.calc_days[i];
					puantaj_exts[puantaj_exts_index][9] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][33] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][10] = get_pay_salary.is_kidem[i];
					puantaj_exts[puantaj_exts_index][11] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/
					puantaj_exts[puantaj_exts_index][12] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/	
					puantaj_exts[puantaj_exts_index][13] = 1;/*damga var mi 1-var 0-yok */	
					puantaj_exts[puantaj_exts_index][14] = 1;/*issizlik var mi 1-var 0-yok */
					//SG 20140210 gune gore net odenegin net tutarini dogru gostermesi icin eklendi. 
					if (get_pay_salary.from_salary[i] eq 0 ) //ödenek net ise 
					{
						if (get_pay_salary.calc_days[i] eq 1)
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * (day_info));	
						}
						else if (get_pay_salary.calc_days[i] eq 2) //fili gün
						{
							puantaj_exts[puantaj_exts_index][15] = (get_pay_salary.ASIL_TUTAR[i] * fiili_gun_); 		
						}	
						else
						{
							puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];/*net ödenecek*/	
						}
					}
					else
					{
						puantaj_exts[puantaj_exts_index][15] = get_pay_salary.ASIL_TUTAR[i];/*net ödenecek*/
					}
					puantaj_exts[puantaj_exts_index][16] = get_pay_salary.comment_pay_id[i];/*ödenek id*/
					puantaj_exts[puantaj_exts_index][17] = '';
					puantaj_exts[puantaj_exts_index][18] = '';
					puantaj_exts[puantaj_exts_index][19] = '';
					puantaj_exts[puantaj_exts_index][20] = '';
					puantaj_exts[puantaj_exts_index][21] = '';
					puantaj_exts[puantaj_exts_index][22] = '';
					puantaj_exts[puantaj_exts_index][23] = '';
					puantaj_exts[puantaj_exts_index][24] = '';
					puantaj_exts[puantaj_exts_index][25] = '';
					puantaj_exts[puantaj_exts_index][26] = '';
					puantaj_exts[puantaj_exts_index][27] = '';
					puantaj_exts[puantaj_exts_index][28] = get_pay_salary.is_income[i];
					puantaj_exts[puantaj_exts_index][29] = '';
					puantaj_exts[puantaj_exts_index][30] = '';
					puantaj_exts[puantaj_exts_index][31] = get_pay_salary.factor_type[i];
					puantaj_exts[puantaj_exts_index][32] = get_pay_salary.comment_type[i];	
					puantaj_exts[puantaj_exts_index][34] = get_pay_salary.is_not_execution[i];
					puantaj_exts[puantaj_exts_index][35] = '';
					puantaj_exts[puantaj_exts_index][36] = get_pay_salary.ssk_exemption_rate[i];
					puantaj_exts[puantaj_exts_index][37] = get_pay_salary.ssk_exemption_type[i];
					puantaj_exts[puantaj_exts_index][38] = '';
					puantaj_exts[puantaj_exts_index][39] = '';
					puantaj_exts[puantaj_exts_index][40] = '';
					puantaj_exts[puantaj_exts_index][41] = 0;

					puantaj_exts[puantaj_exts_index][42] = get_pay_salary.is_rd_damga[i];
					puantaj_exts[puantaj_exts_index][43] = get_pay_salary.is_rd_gelir[i];
					puantaj_exts[puantaj_exts_index][44] = get_pay_salary.is_rd_ssk[i];
					
					puantaj_exts[puantaj_exts_index][45] = 0;
					puantaj_exts[puantaj_exts_index][46] = 0;
					puantaj_exts[puantaj_exts_index][47] = 0;
					puantaj_exts[puantaj_exts_index][48] = get_pay_salary.total_hour[i];//varsa total saat
					puantaj_exts[puantaj_exts_index][49] = '';
					
					//ssk matraha dahil olmayan odenek tutari
					if(len(get_pay_salary.ssk_exemption_rate[i]) and len(get_pay_salary.ssk_exemption_type[i]))
					{
						if(get_pay_salary.ssk_exemption_type[i] eq 0)
							{
							tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL * get_pay_salary.ssk_exemption_rate[i] / 100;
							if(tutar_ gt puantaj_exts[puantaj_exts_index][8])
								tutar_ = puantaj_exts[puantaj_exts_index][8];
							}
						else if(get_pay_salary.ssk_exemption_type[i] eq 1)
							tutar_ = puantaj_exts[puantaj_exts_index][8] * get_pay_salary.ssk_exemption_rate[i] / 100;
						else if(get_pay_salary.ssk_exemption_type[i] eq 2)
						{
							if(get_pay_salary.calc_days[i] eq 1)//güne göre
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * ssk_days;
							else if(get_pay_salary.calc_days[i] eq 2)//fiili güne göre
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * fiili_gun_;
							else
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * get_pay_salary.ASIL_TUTAR[i];
						}
						if(tutar_ gt get_pay_salary.ASIL_TUTAR[i]){
							tutar_ = get_pay_salary.ASIL_TUTAR[i];
						}
						if(get_pay_salary.from_salary[i] eq 1)//brüt ödenek ise 
						{
							ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + tutar_;
						}
					}
					if(get_pay_salary.is_income[i] eq 1)
					{
						kazanca_dahil_olan_odenek_tutar = kazanca_dahil_olan_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
						if(get_pay_salary.tax[i] eq 1)
							kazanca_dahil_olan_odenek_tutar_muaf = kazanca_dahil_olan_odenek_tutar_muaf + puantaj_exts[puantaj_exts_index][3];	
					}
					if(get_pay_salary.comment_type[i] eq 2)
					{
						kazanc_tipli_odenek_tutar = kazanc_tipli_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
					}
				}
				else if ((get_pay_salary.ssk[i] eq 1) and (get_pay_salary.tax[i] eq 2) ) // vergi
				{
					puantaj_exts_index = puantaj_exts_index + 1;
					if (get_pay_salary.calc_days[i] eq 1)
					{
						puantaj_exts[puantaj_exts_index][8] = (((ek_odenek_baz_ucret_/100) * get_pay_salary.amount_pay[i]) * (day_info));
						if(get_pay_salary.from_salary[i] eq 0)//net
						{
							total_pay_tax_net = total_pay_tax_net + puantaj_exts[puantaj_exts_index][8];
						}
						else //brüt
							total_pay_tax = total_pay_tax + puantaj_exts[puantaj_exts_index][8];
					}
					else if(get_pay_salary.calc_days[i] eq 2)
					{
						puantaj_exts[puantaj_exts_index][8] = (((ek_odenek_baz_ucret_/100)*get_pay_salary.amount_pay[i]) * fiili_gun_);
						if(get_pay_salary.from_salary[i] eq 0)//net
						{
							total_pay_tax_net = total_pay_tax_net + puantaj_exts[puantaj_exts_index][8];
						}
						else //brüt
							total_pay_tax = total_pay_tax + puantaj_exts[puantaj_exts_index][8];
					}
					else
					{
						if(get_pay_salary.METHOD_PAY[i] eq 4 and get_pay_salary.calc_days[i] eq 3)
							puantaj_exts[puantaj_exts_index][8] = (ek_odenek_baz_ucret_ * get_pay_salary.amount_pay[i] / 100) * total_hours ; 
						else
							puantaj_exts[puantaj_exts_index][8] = ( (ek_odenek_baz_ucret_/100)*get_pay_salary.amount_pay[i]);
						if(get_pay_salary.from_salary[i] eq 0)//net
						{
							total_pay_tax_net = total_pay_tax_net + puantaj_exts[puantaj_exts_index][8];
						}
						else //brüt
							total_pay_tax = total_pay_tax + puantaj_exts[puantaj_exts_index][8];
					}
					puantaj_exts[puantaj_exts_index][1] = get_pay_salary.comment_PAY[i];
					puantaj_exts[puantaj_exts_index][2] = 2;
					puantaj_exts[puantaj_exts_index][3] = get_pay_salary.amount_pay[i];
					puantaj_exts[puantaj_exts_index][4] = 1;
					puantaj_exts[puantaj_exts_index][5] = 2;
					puantaj_exts[puantaj_exts_index][6] = 0;
					puantaj_exts[puantaj_exts_index][7] = get_pay_salary.calc_days[i];
					puantaj_exts[puantaj_exts_index][9] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][33] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][10] = get_pay_salary.is_kidem[i];
					puantaj_exts[puantaj_exts_index][11] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/
					puantaj_exts[puantaj_exts_index][12] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/	
					puantaj_exts[puantaj_exts_index][13] = 1;/*damga var mi 1-var 0-yok */	
					puantaj_exts[puantaj_exts_index][14] = 0;/*issizlik var mi 1-var 0-yok */
					puantaj_exts[puantaj_exts_index][15] = puantaj_exts[puantaj_exts_index][8];/*net ödenecek*/
					puantaj_exts[puantaj_exts_index][16] = get_pay_salary.comment_pay_id[i];/*ödenek id*/
					puantaj_exts[puantaj_exts_index][17] = '';
					puantaj_exts[puantaj_exts_index][18] = '';
					puantaj_exts[puantaj_exts_index][19] = '';
					puantaj_exts[puantaj_exts_index][20] = '';
					puantaj_exts[puantaj_exts_index][21] = '';
					puantaj_exts[puantaj_exts_index][22] = '';
					puantaj_exts[puantaj_exts_index][23] = '';
					puantaj_exts[puantaj_exts_index][24] = '';
					puantaj_exts[puantaj_exts_index][25] = '';
					puantaj_exts[puantaj_exts_index][26] = '';
					puantaj_exts[puantaj_exts_index][27] = '';
					puantaj_exts[puantaj_exts_index][28] = get_pay_salary.is_income[i];
					puantaj_exts[puantaj_exts_index][29] = '';
					puantaj_exts[puantaj_exts_index][30] = '';
					puantaj_exts[puantaj_exts_index][31] = get_pay_salary.factor_type[i];
					puantaj_exts[puantaj_exts_index][32] = get_pay_salary.comment_type[i];
					puantaj_exts[puantaj_exts_index][34] = get_pay_salary.is_not_execution[i];
					puantaj_exts[puantaj_exts_index][35] = '';
					puantaj_exts[puantaj_exts_index][36] = get_pay_salary.ssk_exemption_rate[i];
					puantaj_exts[puantaj_exts_index][37] = get_pay_salary.ssk_exemption_type[i];
					puantaj_exts[puantaj_exts_index][38] = '';
					puantaj_exts[puantaj_exts_index][39] = '';
					puantaj_exts[puantaj_exts_index][40] = '';
					puantaj_exts[puantaj_exts_index][41] = 0;

					puantaj_exts[puantaj_exts_index][42] = get_pay_salary.is_rd_damga[i];
					puantaj_exts[puantaj_exts_index][43] = get_pay_salary.is_rd_gelir[i];
					puantaj_exts[puantaj_exts_index][44] = get_pay_salary.is_rd_ssk[i];
					
					puantaj_exts[puantaj_exts_index][45] = 0;
					puantaj_exts[puantaj_exts_index][46] = 0;
					puantaj_exts[puantaj_exts_index][47] = 0;
					puantaj_exts[puantaj_exts_index][48] = get_pay_salary.total_hour[i];//varsa total saat
					puantaj_exts[puantaj_exts_index][49] = '';
					
					if(get_pay_salary.is_income[i] eq 1)
					{
						kazanca_dahil_olan_odenek_tutar = kazanca_dahil_olan_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
						if(get_pay_salary.tax[i] eq 1)
							kazanca_dahil_olan_odenek_tutar_muaf = kazanca_dahil_olan_odenek_tutar_muaf + puantaj_exts[puantaj_exts_index][3];	
					}
					if(get_pay_salary.comment_type[i] eq 2)
					{
						kazanc_tipli_odenek_tutar = kazanc_tipli_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
					}
				}
				else if ( (get_pay_salary.ssk[i] eq 2) and (get_pay_salary.tax[i] eq 1) ) // ssk
				{
					puantaj_exts_index = puantaj_exts_index + 1;
					if (get_pay_salary.calc_days[i] eq 1)
					{
						puantaj_exts[puantaj_exts_index][8] = ( ((ek_odenek_baz_ucret_/100)*get_pay_salary.amount_pay[i]) * (day_info));
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_ssk_net = total_pay_ssk_net + puantaj_exts[puantaj_exts_index][8];
						else //brüt
							total_pay_ssk = total_pay_ssk + puantaj_exts[puantaj_exts_index][8];
					}
					else if (get_pay_salary.calc_days[i] eq 2)
					{
						puantaj_exts[puantaj_exts_index][8] = ( ((ek_odenek_baz_ucret_/100)*get_pay_salary.amount_pay[i]) * fiili_gun_ );
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_ssk_net = total_pay_ssk_net + puantaj_exts[puantaj_exts_index][8];
						else //brüt
							total_pay_ssk = total_pay_ssk + puantaj_exts[puantaj_exts_index][8];
					}
					else
					{
						if(get_pay_salary.METHOD_PAY[i] eq 4 and get_pay_salary.calc_days[i] eq 3)
							puantaj_exts[puantaj_exts_index][8] = (ek_odenek_baz_ucret_ * get_pay_salary.amount_pay[i] / 100) * total_hours ; 
						else
							puantaj_exts[puantaj_exts_index][8] = ( (ek_odenek_baz_ucret_/100)*get_pay_salary.amount_pay[i]);
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_ssk_net = total_pay_ssk_net + puantaj_exts[puantaj_exts_index][8];
						else //brüt
							total_pay_ssk = total_pay_ssk + puantaj_exts[puantaj_exts_index][8];
					}
					puantaj_exts[puantaj_exts_index][1] = get_pay_salary.comment_PAY[i];
					puantaj_exts[puantaj_exts_index][2] = 2;
					puantaj_exts[puantaj_exts_index][3] = get_pay_salary.amount_pay[i];
					puantaj_exts[puantaj_exts_index][4] = 2;
					puantaj_exts[puantaj_exts_index][5] = 1;
					puantaj_exts[puantaj_exts_index][6] = 0;
					puantaj_exts[puantaj_exts_index][7] = get_pay_salary.calc_days[i];
					puantaj_exts[puantaj_exts_index][9] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][33] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][10] = get_pay_salary.is_kidem[i];
					puantaj_exts[puantaj_exts_index][11] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/
					puantaj_exts[puantaj_exts_index][12] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/	
					puantaj_exts[puantaj_exts_index][13] = 1;/*damga var mi 1-var 0-yok */	
					puantaj_exts[puantaj_exts_index][14] = 1;/*issizlik var mi 1-var 0-yok */
					puantaj_exts[puantaj_exts_index][15] = puantaj_exts[puantaj_exts_index][8];/*net ödenecek*/
					puantaj_exts[puantaj_exts_index][16] = get_pay_salary.comment_pay_id[i];/*ödenek id*/
					puantaj_exts[puantaj_exts_index][17] = '';
					puantaj_exts[puantaj_exts_index][18] = '';
					puantaj_exts[puantaj_exts_index][19] = '';
					puantaj_exts[puantaj_exts_index][20] = '';
					puantaj_exts[puantaj_exts_index][21] = '';
					puantaj_exts[puantaj_exts_index][22] = '';
					puantaj_exts[puantaj_exts_index][23] = '';
					puantaj_exts[puantaj_exts_index][24] = '';
					puantaj_exts[puantaj_exts_index][25] = '';
					puantaj_exts[puantaj_exts_index][26] = '';
					puantaj_exts[puantaj_exts_index][27] = '';
					puantaj_exts[puantaj_exts_index][28] = get_pay_salary.is_income[i];
					puantaj_exts[puantaj_exts_index][29] = '';
					puantaj_exts[puantaj_exts_index][30] = '';
					puantaj_exts[puantaj_exts_index][31] = get_pay_salary.factor_type[i];
					puantaj_exts[puantaj_exts_index][32] = get_pay_salary.comment_type[i];
					puantaj_exts[puantaj_exts_index][34] = get_pay_salary.is_not_execution[i];
					puantaj_exts[puantaj_exts_index][35] = '';
					puantaj_exts[puantaj_exts_index][36] = get_pay_salary.ssk_exemption_rate[i];
					puantaj_exts[puantaj_exts_index][37] = get_pay_salary.ssk_exemption_type[i];
					puantaj_exts[puantaj_exts_index][38] = '';
					puantaj_exts[puantaj_exts_index][39] = '';
					puantaj_exts[puantaj_exts_index][40] = '';
					puantaj_exts[puantaj_exts_index][41] = 0;

					puantaj_exts[puantaj_exts_index][42] = get_pay_salary.is_rd_damga[i];
					puantaj_exts[puantaj_exts_index][43] = get_pay_salary.is_rd_gelir[i];
					puantaj_exts[puantaj_exts_index][44] = get_pay_salary.is_rd_ssk[i];
					
					puantaj_exts[puantaj_exts_index][45] = 0;
					puantaj_exts[puantaj_exts_index][46] = 0;
					puantaj_exts[puantaj_exts_index][47] = 0;
					puantaj_exts[puantaj_exts_index][48] = get_pay_salary.total_hour[i];//varsa total saat
					puantaj_exts[puantaj_exts_index][49] = '';
					
					//ssk matraha dahil olmayan odenek tutari
					if(len(get_pay_salary.ssk_exemption_rate[i]) and len(get_pay_salary.ssk_exemption_type[i]))
					{
						if(get_pay_salary.ssk_exemption_type[i] eq 0)
							{
							tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL * get_pay_salary.ssk_exemption_rate[i] / 100;
							if(tutar_ gt puantaj_exts[puantaj_exts_index][8])
								tutar_ = puantaj_exts[puantaj_exts_index][8];
							}
						else if(get_pay_salary.ssk_exemption_type[i] eq 1)
							tutar_ = puantaj_exts[puantaj_exts_index][8] * get_pay_salary.ssk_exemption_rate[i] / 100;
						else if(get_pay_salary.ssk_exemption_type[i] eq 2)
						{
							if(get_pay_salary.calc_days[i] eq 1)//güne göre
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * ssk_days;
							else if(get_pay_salary.calc_days[i] eq 2)//fiili güne göre
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * fiili_gun_;
							else
								tutar_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * get_pay_salary.ssk_exemption_rate[i] / 100 * get_pay_salary.ASIL_TUTAR[i];
						}
						if(tutar_ gt get_pay_salary.ASIL_TUTAR[i]){
							tutar_ = get_pay_salary.ASIL_TUTAR[i];
						}
						if(get_pay_salary.from_salary[i] eq 1)//brüt ödenek ise 
						{
							ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + tutar_;
						}
					}
					if(get_pay_salary.is_income[i] eq 1)
					{
						kazanca_dahil_olan_odenek_tutar = kazanca_dahil_olan_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
						if(get_pay_salary.tax[i] eq 1)
							kazanca_dahil_olan_odenek_tutar_muaf = kazanca_dahil_olan_odenek_tutar_muaf + puantaj_exts[puantaj_exts_index][3];	
					}
					if(get_pay_salary.comment_type[i] eq 2)
					{
						kazanc_tipli_odenek_tutar = kazanc_tipli_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
					}
				}
				else if ( (get_pay_salary.ssk[i] eq 1) and (get_pay_salary.tax[i] eq 1) ) // free
				{
					puantaj_exts_index = puantaj_exts_index + 1;
					if (get_pay_salary.calc_days[i] eq 1)
					{
						puantaj_exts[puantaj_exts_index][8] = ( ((ek_odenek_baz_ucret_/100)*get_pay_salary.amount_pay[i]) * (day_info));
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_net = total_pay_net + puantaj_exts[puantaj_exts_index][8];
						else //brüt
							total_pay = total_pay + puantaj_exts[puantaj_exts_index][8];
					}
					else if (get_pay_salary.calc_days[i] eq 1)
					{
						puantaj_exts[puantaj_exts_index][8] = ( ((ek_odenek_baz_ucret_/100)*get_pay_salary.amount_pay[i]) * fiili_gun_);
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_net = total_pay_net + puantaj_exts[puantaj_exts_index][8];
						else //brüt
							total_pay = total_pay + puantaj_exts[puantaj_exts_index][8];
					}
					else
					{
						if(get_pay_salary.METHOD_PAY[i] eq 4 and get_pay_salary.calc_days[i] eq 3)
							puantaj_exts[puantaj_exts_index][8] = (ek_odenek_baz_ucret_ * get_pay_salary.amount_pay[i] / 100) * total_hours ; 
						else
							puantaj_exts[puantaj_exts_index][8] = ( (ek_odenek_baz_ucret_/100)*get_pay_salary.amount_pay[i]);
						if(get_pay_salary.from_salary[i] eq 0)//net
							total_pay_net = total_pay_net + puantaj_exts[puantaj_exts_index][8];
						else //brüt
							total_pay = total_pay + puantaj_exts[puantaj_exts_index][8];
					}
					puantaj_exts[puantaj_exts_index][1] = get_pay_salary.comment_PAY[i];
					puantaj_exts[puantaj_exts_index][2] = 2;
					puantaj_exts[puantaj_exts_index][3] = get_pay_salary.amount_pay[i];
					puantaj_exts[puantaj_exts_index][4] = 1;
					puantaj_exts[puantaj_exts_index][5] = 1;
					puantaj_exts[puantaj_exts_index][6] = 0;
					puantaj_exts[puantaj_exts_index][7] = get_pay_salary.calc_days[i];
					puantaj_exts[puantaj_exts_index][9] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][33] = get_pay_salary.from_salary[i];
					puantaj_exts[puantaj_exts_index][10] = get_pay_salary.is_kidem[i];
					puantaj_exts[puantaj_exts_index][11] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/
					puantaj_exts[puantaj_exts_index][12] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/	
					puantaj_exts[puantaj_exts_index][13] = 1;/*damga var mi 1-var 0-yok */	
					puantaj_exts[puantaj_exts_index][14] = 0;/*issizlik var mi 1-var 0-yok */
					puantaj_exts[puantaj_exts_index][15] = puantaj_exts[puantaj_exts_index][8];/*net ödenecek*/
					puantaj_exts[puantaj_exts_index][16] = get_pay_salary.comment_pay_id[i];/*ödenek id*/
					puantaj_exts[puantaj_exts_index][17] = '';
					puantaj_exts[puantaj_exts_index][18] = '';
					puantaj_exts[puantaj_exts_index][19] = '';
					puantaj_exts[puantaj_exts_index][20] = '';
					puantaj_exts[puantaj_exts_index][21] = '';
					puantaj_exts[puantaj_exts_index][22] = '';
					puantaj_exts[puantaj_exts_index][23] = '';
					puantaj_exts[puantaj_exts_index][24] = '';
					puantaj_exts[puantaj_exts_index][25] = '';
					puantaj_exts[puantaj_exts_index][26] = '';
					puantaj_exts[puantaj_exts_index][27] = '';
					puantaj_exts[puantaj_exts_index][28] = get_pay_salary.is_income[i];
					puantaj_exts[puantaj_exts_index][29] = '';
					puantaj_exts[puantaj_exts_index][30] = '';
					puantaj_exts[puantaj_exts_index][31] = get_pay_salary.factor_type[i];
					puantaj_exts[puantaj_exts_index][32] = get_pay_salary.comment_type[i];
					puantaj_exts[puantaj_exts_index][34] = get_pay_salary.is_not_execution[i];
					puantaj_exts[puantaj_exts_index][35] = '';
					puantaj_exts[puantaj_exts_index][36] = get_pay_salary.ssk_exemption_rate[i];
					puantaj_exts[puantaj_exts_index][37] = get_pay_salary.ssk_exemption_type[i];
					puantaj_exts[puantaj_exts_index][38] = '';
					puantaj_exts[puantaj_exts_index][39] = '';
					puantaj_exts[puantaj_exts_index][40] = '';
					puantaj_exts[puantaj_exts_index][41] = 0;

					puantaj_exts[puantaj_exts_index][42] = get_pay_salary.is_rd_damga[i];
					puantaj_exts[puantaj_exts_index][43] = get_pay_salary.is_rd_gelir[i];
					puantaj_exts[puantaj_exts_index][44] = get_pay_salary.is_rd_ssk[i];
					
					puantaj_exts[puantaj_exts_index][45] = 0;
					puantaj_exts[puantaj_exts_index][46] = 0;
					puantaj_exts[puantaj_exts_index][47] = 0;
					puantaj_exts[puantaj_exts_index][48] = get_pay_salary.total_hour[i];//varsa total saat
					puantaj_exts[puantaj_exts_index][49] = '';
					
					if(get_pay_salary.is_income[i] eq 1)
					{
						kazanca_dahil_olan_odenek_tutar = kazanca_dahil_olan_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
						if(get_pay_salary.tax[i] eq 1)
							kazanca_dahil_olan_odenek_tutar_muaf = kazanca_dahil_olan_odenek_tutar_muaf + puantaj_exts[puantaj_exts_index][3];	
					}
					if(get_pay_salary.comment_type[i] eq 2)
					{
						kazanc_tipli_odenek_tutar = kazanc_tipli_odenek_tutar + puantaj_exts[puantaj_exts_index][3];
					}
				}
			}
		}
	}
	// kesinti
	if(use_ssk neq 2 or (use_ssk eq 2 and IsDefined("officer_total_salary") and unpaid_offtime eq 0))
	{
		if(ssk_days eq 0) 
			day_info = 0; 
		else if(ssk_days eq 30 and get_get_salary.calc_days[i] eq 1) // Tutar günü = Gün ise
			day_info = (ssk_full_days-izin)/ssk_days;  //ucretsiz izin oldugunda tam calisanlarda ucretsiz izni dusmeli 31-izin olmalı SG 20130918
		else if(ssk_days eq 30)
			day_info = (ssk_full_days-izin);  //ucretsiz izin oldugunda tam calisanlarda ucretsiz izni dusmeli 31-izin olmalı SG 20130918
		else if(get_get_salary.calc_days[i] eq 1) // Tutar günü = Gün ise
			day_info = ssk_days/30;
		else
			day_info = ssk_days;
		for (i=1; i lte get_get_salary.recordcount; i = i+1)
		{
			flag_get = 0;
			if (get_get_salary.period_get[i] eq 1) // ayda 1
				flag_get = 1;
			else if ( (get_get_salary.period_get[i] eq 2) and (( (month(last_month_1) - get_get_salary.START_SAL_MON[i] +1) mod 3) eq 0) )// 3 ayda 1
				flag_get = 1;
			else if ( (get_get_salary.period_get[i] eq 3) and (( (month(last_month_1) - get_get_salary.START_SAL_MON[i] +1) mod 6) eq 0) )// 6 ayda 1
				flag_get = 1;
			else if ( (get_get_salary.period_get[i] eq 4) and ( month(last_month_1) eq get_get_salary.START_SAL_MON[i] ) ) // yılda 1
				flag_get = 1;
			if (flag_get eq 1)
			{
				if (get_get_salary.method_get[i] eq 1) // -
				{
					puantaj_exts_index = puantaj_exts_index + 1;
					puantaj_exts[puantaj_exts_index][1] = get_get_salary.comment_get[i];
					puantaj_exts[puantaj_exts_index][2] = 1;
					if (get_get_salary.calc_days[i] eq 1)
					{
						puantaj_exts[puantaj_exts_index][3] = (get_get_salary.amount_get[i] * (ssk_days/ssk_full_days));
						if (get_get_salary.from_salary[i] eq 0) // net den 
							ozel_kesinti = ozel_kesinti + puantaj_exts[puantaj_exts_index][3];
						else if (get_get_salary.from_salary[i] eq 1) // brüt den
							ozel_kesinti_2 = ozel_kesinti_2 + puantaj_exts[puantaj_exts_index][3];
					}
					else if (get_get_salary.calc_days[i] eq 2)
					{
						puantaj_exts[puantaj_exts_index][3] = (get_get_salary.amount_get[i] * fiili_gun_);
						if (get_get_salary.from_salary[i] eq 0) // net den 
							ozel_kesinti = ozel_kesinti + puantaj_exts[puantaj_exts_index][3];
						else if (get_get_salary.from_salary[i] eq 1) // brüt den
							ozel_kesinti_2 = ozel_kesinti_2 + puantaj_exts[puantaj_exts_index][3];
					}	
					else
					{
						if(for_ssk_day eq 0)
							puantaj_exts[puantaj_exts_index][3] = get_get_salary.amount_get[i];
						else
							puantaj_exts[puantaj_exts_index][3] = get_get_salary.amount_get[i] / 30 * day_info;

						if (get_get_salary.from_salary[i] eq 0) // net den
							ozel_kesinti = ozel_kesinti + puantaj_exts[puantaj_exts_index][3];
						else if (get_get_salary.from_salary[i] eq 1) // brüt den
							ozel_kesinti_2 = ozel_kesinti_2 + puantaj_exts[puantaj_exts_index][3];
					}
					/* Disiplin cezası varsa ve memursa */
					if(len(get_get_salary.CAUTION_ID[i]) and get_get_salary.CAUTION_ID[i] gt 0 and IsDefined("officer_total_salary") and unpaid_offtime eq 0)
					{
						get_disciplinary = new Query(datasource="#dsn#", sql="SELECT INTERRUPTION_DIVIDEND, INTERRUPTION_DENOMINATOR FROM EMPLOYEES_CAUTION WHERE CAUTION_TO = #get_hr_ssk.employee_id# AND CAUTION_ID = #get_get_salary.CAUTION_ID[i]#").execute().getResult();
						/* Memurda disiplin cezası =  (kazanç - ( Eş Yardımı, Çocuk Yardımı, Akademik teşvik Ödeneği!, Arazi Tazminatı?)) /  (disipline girilen oranlar) */
						if(len(get_disciplinary.INTERRUPTION_DIVIDEND) and len(get_disciplinary.INTERRUPTION_DENOMINATOR))
							puantaj_exts[puantaj_exts_index][3] = (officer_total_salary - (family_assistance + child_assistance + academic_incentive_allowance_amount)) * (get_disciplinary.INTERRUPTION_DIVIDEND / get_disciplinary.INTERRUPTION_DENOMINATOR);
					}
					else if(len(get_get_salary.CAUTION_ID[i]) and get_get_salary.CAUTION_ID[i] gt 0 and use_ssk neq 2)//disiplin cezası varsa
					{
						get_disciplinary = new Query(datasource="#dsn#", sql="SELECT INTERRUPTION_DIVIDEND, INTERRUPTION_DENOMINATOR FROM EMPLOYEES_CAUTION WHERE CAUTION_TO = #get_hr_ssk.employee_id# AND CAUTION_ID = #get_get_salary.CAUTION_ID[i]#").execute().getResult();
						puantaj_exts[puantaj_exts_index][3] = puantaj_exts[puantaj_exts_index][3] * (get_disciplinary.INTERRUPTION_DIVIDEND / get_disciplinary.INTERRUPTION_DENOMINATOR);
					}
					puantaj_exts[puantaj_exts_index][4] = 0;
					puantaj_exts[puantaj_exts_index][5] = 0;
					puantaj_exts[puantaj_exts_index][6] = 1;
					puantaj_exts[puantaj_exts_index][7] = get_get_salary.calc_days[i];
					puantaj_exts[puantaj_exts_index][8] = 0;
					puantaj_exts[puantaj_exts_index][9] = get_get_salary.from_salary[i];   //  0 net 1 brüt
					puantaj_exts[puantaj_exts_index][33] = get_get_salary.from_salary[i];   //  0 net 1 brüt
					puantaj_exts[puantaj_exts_index][10] = '';/*kideme dahil mi ek odenekler icin kullaniliyor*/
					puantaj_exts[puantaj_exts_index][11] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/
					puantaj_exts[puantaj_exts_index][12] = '';
					puantaj_exts[puantaj_exts_index][13] = '';
					puantaj_exts[puantaj_exts_index][14] = '';
						//SG 20140210 gune gore net odenegin net tutarini dogru gostermesi icin eklendi. 
						if (get_get_salary.from_salary[i] eq 0 ) //ödenek net ise 
						{
							if (get_get_salary.calc_days[i] eq 1)
							{
								puantaj_exts[puantaj_exts_index][15] = (get_get_salary.ASIL_TUTAR[i] * (day_info));	
							}
							else if (get_get_salary.calc_days[i] eq 2) //fili gün
							{
								puantaj_exts[puantaj_exts_index][15] = (get_get_salary.ASIL_TUTAR[i] * fiili_gun_); 		
							}	
							else
							{
								if(for_ssk_day eq 0)
									puantaj_exts[puantaj_exts_index][15] = get_get_salary.ASIL_TUTAR[i];/*net ödenecek*/
								else
									puantaj_exts[puantaj_exts_index][15] = get_get_salary.ASIL_TUTAR[i] / 30 * day_info;
							}
						}
						else
						{
							if(for_ssk_day eq 0)
								puantaj_exts[puantaj_exts_index][15] = get_get_salary.ASIL_TUTAR[i];/*net ödenecek*/
							else
								puantaj_exts[puantaj_exts_index][15] = get_get_salary.ASIL_TUTAR[i] / 30 * day_info;
						}
					puantaj_exts[puantaj_exts_index][16] = '';
					puantaj_exts[puantaj_exts_index][17] = get_get_salary.company_id[i];
					puantaj_exts[puantaj_exts_index][18] = get_get_salary.account_code[i];
					puantaj_exts[puantaj_exts_index][19] = get_get_salary.account_name[i];
					puantaj_exts[puantaj_exts_index][20] = get_get_salary.consumer_id[i];
					puantaj_exts[puantaj_exts_index][21] = get_get_salary.acc_type_id[i];
					puantaj_exts[puantaj_exts_index][22] = '';
					puantaj_exts[puantaj_exts_index][23] = '';
					puantaj_exts[puantaj_exts_index][24] = '';
					puantaj_exts[puantaj_exts_index][25] = '';
					puantaj_exts[puantaj_exts_index][26] = '';
					puantaj_exts[puantaj_exts_index][27] = '';
					puantaj_exts[puantaj_exts_index][28] = '';
					puantaj_exts[puantaj_exts_index][29] = '';
					puantaj_exts[puantaj_exts_index][30] = '';
					puantaj_exts[puantaj_exts_index][31] = '';
					puantaj_exts[puantaj_exts_index][32] = '';
					puantaj_exts[puantaj_exts_index][34] = '';
					puantaj_exts[puantaj_exts_index][35] = get_get_salary.detail[i];
					puantaj_exts[puantaj_exts_index][36] = '';
					puantaj_exts[puantaj_exts_index][37] = '';
					puantaj_exts[puantaj_exts_index][38] = '';
					puantaj_exts[puantaj_exts_index][39] = '';
					puantaj_exts[puantaj_exts_index][40] = '';
					puantaj_exts[puantaj_exts_index][41] = 0;

					puantaj_exts[puantaj_exts_index][42] = '';
					puantaj_exts[puantaj_exts_index][43] = '';
					puantaj_exts[puantaj_exts_index][44] = '';
					
					puantaj_exts[puantaj_exts_index][45] = 0;
					puantaj_exts[puantaj_exts_index][46] = 0;
					puantaj_exts[puantaj_exts_index][47] = 0;
					puantaj_exts[puantaj_exts_index][48] = 0;//varsa total saat
					puantaj_exts[puantaj_exts_index][49] = get_get_salary.is_net_to_gross[i];
					
					
					if(get_get_salary.tax[i] eq 1)
						{
							vergi_matraha_dahil_olmayan_kesinti_tutar = vergi_matraha_dahil_olmayan_kesinti_tutar + puantaj_exts[puantaj_exts_index][3];
							damga_matraha_dahil_olmayan_kesinti_tutar = damga_matraha_dahil_olmayan_kesinti_tutar + puantaj_exts[puantaj_exts_index][3];
							if(get_get_salary.from_salary[i] eq 1) // brüt den
							{
								ozel_kesinti_damga_dahil_olmayan_tutar = ozel_kesinti_damga_dahil_olmayan_tutar + damga_matraha_dahil_olmayan_kesinti_tutar;
								ozel_kesinti_gelir_dahil_olmayan_tutar = ozel_kesinti_gelir_dahil_olmayan_tutar + vergi_matraha_dahil_olmayan_kesinti_tutar;
							}
							
						}
						
					if(get_get_salary.tax[i] eq 3)
						{
							vergi_matraha_dahil_olmayan_kesinti_tutar = vergi_matraha_dahil_olmayan_kesinti_tutar + puantaj_exts[puantaj_exts_index][3];
							if(get_get_salary.from_salary[i] eq 1) // brüt den
							{
								ozel_kesinti_gelir_dahil_olmayan_tutar = ozel_kesinti_gelir_dahil_olmayan_tutar + vergi_matraha_dahil_olmayan_kesinti_tutar;
							}
						}
				}
				else if (listfindnocase('2,3,4,5',get_get_salary.method_get[i])) // %
				{
					kesinti_baz_ucret = get_hr_salary.salary;
					if(get_hr_salary.salary_type eq 0)
					{
						kesinti_ucret_saat_ = get_hr_salary.salary;
						kesinti_ucret_gun_ = get_hr_salary.salary * 7.5;
						kesinti_ucret_ay_ = get_hr_salary.salary * 225;
					}
					else if(get_hr_salary.salary_type eq 1)
					{
						kesinti_ucret_saat_ = get_hr_salary.salary / 7.5;
						kesinti_ucret_gun_ = get_hr_salary.salary;
						kesinti_ucret_ay_ = get_hr_salary.salary * 30;
					}
					else if(get_hr_salary.salary_type eq 2)
					{
						kesinti_ucret_saat_ = get_hr_salary.salary / 225;
						kesinti_ucret_gun_ = get_hr_salary.salary / 30;
						kesinti_ucret_ay_ = get_hr_salary.salary;
					}
					if(get_get_salary.method_get[i] eq 5)
						kesinti_baz_ucret = kesinti_ucret_ay_;
					else if(get_get_salary.method_get[i] eq 3)
						kesinti_baz_ucret = kesinti_ucret_gun_;
					else if(get_get_salary.method_get[i] eq 4)
						kesinti_baz_ucret = kesinti_ucret_saat_;
					else
						kesinti_baz_ucret = kesinti_ucret_ay_;
					
							

					puantaj_exts_index = puantaj_exts_index + 1;
					
					if (get_get_salary.calc_days[i] eq 1)
					{
						puantaj_exts[puantaj_exts_index][8] = ( ((kesinti_baz_ucret/100)*get_get_salary.amount_get[i]) * (ssk_days/ssk_full_days) );
						if (get_get_salary.from_salary[i] eq 0) // net den
							{
								if(get_get_salary.method_get[i] eq 5)
								{
									ozel_kesinti_yuzdeler = ozel_kesinti_yuzdeler + (get_get_salary.amount_get[i] * (ssk_days/ssk_full_days));
								}
								else if(get_get_salary.method_get[i] eq 3)
								{
									ozel_kesinti_yuzdeler_gun = ozel_kesinti_yuzdeler_gun + (get_get_salary.amount_get[i] * (ssk_days/ssk_full_days));
								}
								else if(get_get_salary.method_get[i] eq 4)
								{
									ozel_kesinti_yuzdeler_saat = ozel_kesinti_yuzdeler_saat + (get_get_salary.amount_get[i] * (ssk_days/ssk_full_days));
								}
								else if(get_get_salary.method_get[i] eq 2)
								{
									ozel_kesinti_yuzdeler_ay = ozel_kesinti_yuzdeler_ay + (get_get_salary.amount_get[i] * (ssk_days/ssk_full_days));
								}
									
								if(get_get_salary.tax[i] eq 1 or get_get_salary.tax[i] eq 3)
								{
									if(get_get_salary.method_get[i] eq 5)
									{
										tutar_ = kesinti_ucret_ay_ * get_get_salary.amount_get[i] / 100;
									}
									else if(get_get_salary.method_get[i] eq 3)
									{
											tutar_ = kesinti_ucret_gun_ * get_get_salary.amount_get[i] / 100 * (ssk_days/ssk_full_days);
										}
									else if(get_get_salary.method_get[i] eq 4)
									{
											tutar_ = kesinti_ucret_saat_ * get_get_salary.amount_get[i] / 100 * (ssk_days/ssk_full_days);
									}
									else if(get_get_salary.method_get[i] eq 2)
									{
											tutar_ = kesinti_ucret_ay_ * get_get_salary.amount_get[i] / 100 * (ssk_days/ssk_full_days);
									}
									if(get_get_salary.tax[i] eq 1)
									{
										vergi_matraha_dahil_olmayan_kesinti_tutar = vergi_matraha_dahil_olmayan_kesinti_tutar + tutar_;
										damga_matraha_dahil_olmayan_kesinti_tutar = damga_matraha_dahil_olmayan_kesinti_tutar + tutar_;
										if (get_get_salary.from_salary[i] eq 1) // brüt den
										{
											ozel_kesinti_damga_dahil_olmayan_tutar = ozel_kesinti_damga_dahil_olmayan_tutar + damga_matraha_dahil_olmayan_kesinti_tutar;
											ozel_kesinti_gelir_dahil_olmayan_tutar = ozel_kesinti_gelir_dahil_olmayan_tutar + vergi_matraha_dahil_olmayan_kesinti_tutar;
										}
									}
									else
									{
										vergi_matraha_dahil_olmayan_kesinti_tutar = vergi_matraha_dahil_olmayan_kesinti_tutar + tutar_;
										if (get_get_salary.from_salary[i] eq 1) // brüt den
										{
											ozel_kesinti_damga_dahil_olmayan_tutar = ozel_kesinti_damga_dahil_olmayan_tutar + damga_matraha_dahil_olmayan_kesinti_tutar;
										}
									}
								}
							}
						else if (get_get_salary.from_salary[i] eq 1) // brüt den
							{
							ozel_kesinti_2 = ozel_kesinti_2 + puantaj_exts[puantaj_exts_index][8];
							}
					}
					else if (get_get_salary.calc_days[i] eq 2)
					{
						puantaj_exts[puantaj_exts_index][8] = ( ((kesinti_baz_ucret/100)*get_get_salary.amount_get[i]) * fiili_gun_);
						if (get_get_salary.from_salary[i] eq 0) // net den
							{
								if(get_get_salary.method_get[i] eq 5)
									{
										ozel_kesinti_yuzdeler = ozel_kesinti_yuzdeler + (get_get_salary.amount_get[i] * fiili_gun_);
									}
								else if(get_get_salary.method_get[i] eq 3)
									{
										ozel_kesinti_yuzdeler_gun = ozel_kesinti_yuzdeler_gun + (get_get_salary.amount_get[i] * fiili_gun_);
									}
								else if(get_get_salary.method_get[i] eq 4)
									{
										ozel_kesinti_yuzdeler_saat = ozel_kesinti_yuzdeler_saat + (get_get_salary.amount_get[i] * fiili_gun_);
									}
								else if(get_get_salary.method_get[i] eq 2)
									{
										ozel_kesinti_yuzdeler_ay = ozel_kesinti_yuzdeler_ay + (get_get_salary.amount_get[i] * fiili_gun_);
									}
									
								if(get_get_salary.tax[i] eq 1 or get_get_salary.tax[i] eq 3)
								{
									if(get_get_salary.method_get[i] eq 5)
									{
										tutar_ = kesinti_ucret_ay_ * get_get_salary.amount_get[i] / 100;
									}
									else 
									if(get_get_salary.method_get[i] eq 3)
									{
										tutar_ = kesinti_ucret_gun_ * get_get_salary.amount_get[i] / 100 * fiili_gun_;
									}
									else if(get_get_salary.method_get[i] eq 4)
									{
										tutar_ = kesinti_ucret_saat_ * get_get_salary.amount_get[i] / 100 * fiili_gun_;
									}
									else if(get_get_salary.method_get[i] eq 2)
									{
										tutar_ = kesinti_ucret_ay_ * get_get_salary.amount_get[i] / 100 * fiili_gun_;
									}
									if(get_get_salary.tax[i] eq 1)
									{
										vergi_matraha_dahil_olmayan_kesinti_tutar = vergi_matraha_dahil_olmayan_kesinti_tutar + tutar_;
										damga_matraha_dahil_olmayan_kesinti_tutar = damga_matraha_dahil_olmayan_kesinti_tutar + tutar_;
										if (get_get_salary.from_salary[i] eq 1) // brüt den
										{
											ozel_kesinti_damga_dahil_olmayan_tutar = ozel_kesinti_damga_dahil_olmayan_tutar + damga_matraha_dahil_olmayan_kesinti_tutar;
											ozel_kesinti_gelir_dahil_olmayan_tutar = ozel_kesinti_gelir_dahil_olmayan_tutar + vergi_matraha_dahil_olmayan_kesinti_tutar;
										}
									}
									else
									{
										vergi_matraha_dahil_olmayan_kesinti_tutar = vergi_matraha_dahil_olmayan_kesinti_tutar + tutar_;
										if (get_get_salary.from_salary[i] eq 1) // brüt den
										{
											ozel_kesinti_gelir_dahil_olmayan_tutar = ozel_kesinti_gelir_dahil_olmayan_tutar + vergi_matraha_dahil_olmayan_kesinti_tutar;
										}
									}
								}	
							}
						else if (get_get_salary.from_salary[i] eq 1) // brüt den
							ozel_kesinti_2 = ozel_kesinti_2 + puantaj_exts[puantaj_exts_index][8];
					}
					else
					{
						puantaj_exts[puantaj_exts_index][8] = ((kesinti_baz_ucret/100)*get_get_salary.amount_get[i]);
						if (get_get_salary.from_salary[i] eq 0) // net den
							{
								if(get_get_salary.method_get[i] eq 5)
									{
									ozel_kesinti_yuzdeler = ozel_kesinti_yuzdeler + (get_get_salary.amount_get[i]);
									}
								else if(get_get_salary.method_get[i] eq 3)
									{
									ozel_kesinti_yuzdeler_gun = ozel_kesinti_yuzdeler_gun + ((kesinti_baz_ucret/100)*get_get_salary.amount_get[i]);								
									}
								else if(get_get_salary.method_get[i] eq 4)
									{
									ozel_kesinti_yuzdeler_saat = ozel_kesinti_yuzdeler_saat + ((kesinti_baz_ucret/100)*get_get_salary.amount_get[i]);
									}
								else if(get_get_salary.method_get[i] eq 2)
									{
									ozel_kesinti_yuzdeler_ay = ozel_kesinti_yuzdeler_ay + ((kesinti_baz_ucret/100)*get_get_salary.amount_get[i]);
									}
									
								if(get_get_salary.tax[i] eq 1 or get_get_salary.tax[i] eq 3)
								{
									if(get_get_salary.method_get[i] eq 5)
									{
										tutar_ = kesinti_ucret_ay_ * get_get_salary.amount_get[i] / 100;
									}
									else 
									if(get_get_salary.method_get[i] eq 3)
									{
										tutar_ = kesinti_ucret_gun_ * get_get_salary.amount_get[i] / 100;
									}
									else if(get_get_salary.method_get[i] eq 4)
									{
										tutar_ = kesinti_ucret_saat_ * get_get_salary.amount_get[i] / 100;
									}
									else if(get_get_salary.method_get[i] eq 2)
									{
										tutar_ = kesinti_ucret_ay_ * get_get_salary.amount_get[i] / 100;
									}
									if(get_get_salary.tax[i] eq 1)
									{
										vergi_matraha_dahil_olmayan_kesinti_tutar = vergi_matraha_dahil_olmayan_kesinti_tutar + tutar_;
										damga_matraha_dahil_olmayan_kesinti_tutar = damga_matraha_dahil_olmayan_kesinti_tutar + tutar_;
										if (get_get_salary.from_salary[i] eq 1) // brüt den
										{
											ozel_kesinti_damga_dahil_olmayan_tutar = ozel_kesinti_damga_dahil_olmayan_tutar + damga_matraha_dahil_olmayan_kesinti_tutar;
											ozel_kesinti_gelir_dahil_olmayan_tutar = ozel_kesinti_gelir_dahil_olmayan_tutar + vergi_matraha_dahil_olmayan_kesinti_tutar;
										}
									}
									else
									{
										vergi_matraha_dahil_olmayan_kesinti_tutar = vergi_matraha_dahil_olmayan_kesinti_tutar + tutar_;
										
									}
								}
							}
						else if (get_get_salary.from_salary[i] eq 1) // brüt den
							ozel_kesinti_2 = ozel_kesinti_2 + puantaj_exts[puantaj_exts_index][8];
					}
					puantaj_exts[puantaj_exts_index][1] = get_get_salary.comment_get[i];
					puantaj_exts[puantaj_exts_index][2] = get_get_salary.method_get[i];
					puantaj_exts[puantaj_exts_index][3] = get_get_salary.amount_get[i];
					puantaj_exts[puantaj_exts_index][4] = 0;
					puantaj_exts[puantaj_exts_index][5] = 0;
					puantaj_exts[puantaj_exts_index][6] = 1;
					puantaj_exts[puantaj_exts_index][7] = get_get_salary.calc_days[i];
					puantaj_exts[puantaj_exts_index][9] = get_get_salary.from_salary[i];   //  0 net 1 brüt
					puantaj_exts[puantaj_exts_index][33] = get_get_salary.from_salary[i];   //  0 net 1 brüt
					puantaj_exts[puantaj_exts_index][10] = '';/*kideme dahil mi ek odenekler icin kullaniliyor*/
					puantaj_exts[puantaj_exts_index][11] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/
					puantaj_exts[puantaj_exts_index][12] = '';
					puantaj_exts[puantaj_exts_index][13] = '';
					puantaj_exts[puantaj_exts_index][14] = '';
					//SG 20140210 gune gore net odenegin net tutarini dogru gostermesi icin eklendi. 
					if (get_get_salary.from_salary[i] eq 0 ) //ödenek net ise 
					{
						if (get_get_salary.calc_days[i] eq 1)
						{
							puantaj_exts[puantaj_exts_index][15] = (get_get_salary.ASIL_TUTAR[i] * (day_info));	
						}
						else if (get_get_salary.calc_days[i] eq 2) //fili gün
						{
							puantaj_exts[puantaj_exts_index][15] = (get_get_salary.ASIL_TUTAR[i] * fiili_gun_); 		
						}	
						else
						{
							puantaj_exts[puantaj_exts_index][15] = get_get_salary.ASIL_TUTAR[i];/*net ödenecek*/	
						}
					}
					else
					{
						puantaj_exts[puantaj_exts_index][15] = get_get_salary.ASIL_TUTAR[i];/*net ödenecek*/
					}
					puantaj_exts[puantaj_exts_index][16] = '';
					puantaj_exts[puantaj_exts_index][17] = get_get_salary.company_id[i];
					puantaj_exts[puantaj_exts_index][18] = get_get_salary.account_code[i];
					puantaj_exts[puantaj_exts_index][19] = get_get_salary.account_name[i];
					puantaj_exts[puantaj_exts_index][20] = get_get_salary.consumer_id[i];
					puantaj_exts[puantaj_exts_index][21] = get_get_salary.acc_type_id[i];
					puantaj_exts[puantaj_exts_index][22] = '';
					puantaj_exts[puantaj_exts_index][23] = '';
					puantaj_exts[puantaj_exts_index][24] = '';
					puantaj_exts[puantaj_exts_index][25] = '';
					puantaj_exts[puantaj_exts_index][26] = '';
					puantaj_exts[puantaj_exts_index][27] = '';
					puantaj_exts[puantaj_exts_index][28] = '';
					puantaj_exts[puantaj_exts_index][29] = '';
					puantaj_exts[puantaj_exts_index][30] = '';
					puantaj_exts[puantaj_exts_index][31] = '';
					puantaj_exts[puantaj_exts_index][32] = '';
					puantaj_exts[puantaj_exts_index][34] = '';
					puantaj_exts[puantaj_exts_index][35] = get_get_salary.detail[i];
					puantaj_exts[puantaj_exts_index][36] = '';
					puantaj_exts[puantaj_exts_index][37] = '';
					puantaj_exts[puantaj_exts_index][38] = '';
					puantaj_exts[puantaj_exts_index][39] = '';
					puantaj_exts[puantaj_exts_index][40] = '';
					puantaj_exts[puantaj_exts_index][41] = 0;

					puantaj_exts[puantaj_exts_index][42] = '';
					puantaj_exts[puantaj_exts_index][43] = '';
					puantaj_exts[puantaj_exts_index][44] = '';
					
					puantaj_exts[puantaj_exts_index][45] = 0;
					puantaj_exts[puantaj_exts_index][46] = 0;
					puantaj_exts[puantaj_exts_index][47] = 0;
					puantaj_exts[puantaj_exts_index][48] = 0;//varsa total saat
					puantaj_exts[puantaj_exts_index][49] = get_get_salary.is_net_to_gross[i];
					
				}
			}
		}
	}
	
/* // ek ödenek ve kesintiler */
</cfscript>
<cfif ssk_days eq 0><cfset kazanca_dahil_olan_odenek_tutar = 0><cfset kazanca_dahil_olan_odenek_tutar_muaf = 0><cfset kazanc_tipli_odenek_tutar = 0></cfif>