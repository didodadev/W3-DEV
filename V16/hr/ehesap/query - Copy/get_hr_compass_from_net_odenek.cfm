<cfset is_from_odenek = 1>
<cfset temp_kazanca_dahil_olan_odenek_tutar_muaf = kazanca_dahil_olan_odenek_tutar_muaf>
<cfset kazanca_dahil_olan_odenek_tutar_muaf = 0>
<!----
<cfoutput>
	is_tax_ : #is_tax_# <br>
	is_ssk_ : #is_ssk_# <br>
	is_mesai_ : #is_mesai_# <br>
	is_izin_ : #is_izin_# <br>
	is_issizlik_ : #is_issizlik_# <br>
	<!--- is_damga_ : #is_damga_# <br>
	is_ssk_tax_net_odenek : #is_ssk_tax_net_odenek# --->
</cfoutput>
--->
<cfset is_net_payment = 1>
<cfset net_payment_temp = ilk_salary+ekten_gelen>
<cfset ilk_salary_temp = ilk_salary + temp_kazanca_dahil_olan_odenek_tutar_muaf><!---kazanca dahil olan ödeneklerin brüt tutarı brüt maaşa ekleniyor , ödeneklerin brütleşmesi doğru yapılsın diye--->
<cfset salary_ilk = ilk_salary>
<cfset net_total_brut = 0>
<cfif get_hr_ssk.IS_TAX_FREE eq 1 and get_hr_ssk.is_damga_free eq 1 and is_mesai_ neq 1>
	<cfset is_tax_free_from_payment = 1>
</cfif>

<cfif is_tax_ eq 0 and is_ssk_ eq 0>
	
	<cfscript>
	if(tutar_ gt 0){
		if(attributes.sal_year gte 2022 and use_minimum_wage neq 1 and get_active_program_parameter.is_use_minimum_wage neq 1 and use_ssk neq 2)
		{
			//total damga alınıyor
			net_payment_stamp_tax = (tutar_ * get_active_program_parameter.STAMP_TAX_BINDE) / 1000;
			temp_stamp_tax_base = wrk_round((tutar_*1000)/(1000-get_active_program_parameter.STAMP_TAX_BINDE));

			//eğer eski damga vergisi max alabilceğinden küçük fakat ek ödenekle bereaber geçiyorsa
			if(stamp_tax_temp lt temp_daily_minimum_wage_stamp_tax and stamp_tax_temp + net_payment_stamp_tax gt temp_daily_minimum_wage_stamp_tax )
			{
				//buraya tekrar bakılacak
				stamp_tax_temp = net_payment_stamp_tax;
			}else
				stamp_tax_temp = stamp_tax_temp + net_payment_stamp_tax;
				
			
			
			//DAMGA VERGİSİ KULLANILABİLECEĞİ GEÇİYORSA
			if(stamp_tax_temp gte temp_daily_minimum_wage_stamp_tax)
			{
				stamp_tax_temp = temp_daily_minimum_wage_stamp_tax;	
				
				tutar_ = wrk_round((tutar_*1000)/(1000-get_active_program_parameter.STAMP_TAX_BINDE) );
				for (i=1; i lte arraylen(puantaj_exts); i = i+1){
					if(puantaj_exts[i][6] eq 0 and puantaj_exts[i][9] eq 0)//net odenekler
						if(puantaj_exts[i][4] eq 1 and puantaj_exts[i][5] eq 1 and puantaj_exts[i][13] eq 1 and puantaj_exts[i][14] eq 0){
							//ssk da haric vergi de haric olanlar damga vergi carpani ile buyutulecek
							puantaj_exts[i][3] = wrk_round( (puantaj_exts[i][3]*1000)/(1000-get_active_program_parameter.STAMP_TAX_BINDE) );
							puantaj_exts[i][9] = 1;//artik brut oldu
					}
				}
				total_pay_d = total_pay_d + tutar_;
			}
			else
			{
				for (i=1; i lte arraylen(puantaj_exts); i = i+1){
					if(puantaj_exts[i][6] eq 0 and puantaj_exts[i][9] eq 0)//net odenekler
						if(puantaj_exts[i][4] eq 1 and puantaj_exts[i][5] eq 1 and puantaj_exts[i][13] eq 1 and puantaj_exts[i][14] eq 0){
							//ssk da haric vergi de haric olanlar damga vergi carpani ile buyutulecek
							puantaj_exts[i][3] = wrk_round( (puantaj_exts[i][3]));
							puantaj_exts[i][9] = 1;//artik brut oldu
					}
				}
				total_pay_d = total_pay_d + tutar_;
			}

			if(total_used_stamp_tax gte temp_stamp_tax_base  and wrk_round(total_used_stamp_tax-temp_stamp_tax_base) gt 0.01)
				total_used_stamp_tax = total_used_stamp_tax - temp_stamp_tax_base;
			else
				total_used_stamp_tax = 0;
			
			daily_minimum_wage_stamp_tax = (total_used_stamp_tax * get_active_program_parameter.STAMP_TAX_BINDE) / 1000; 
				
		}
		else {
			tutar_ = wrk_round((tutar_*1000)/(1000-get_active_program_parameter.STAMP_TAX_BINDE) );
			for (i=1; i lte arraylen(puantaj_exts); i = i+1){
				if(puantaj_exts[i][6] eq 0 and puantaj_exts[i][9] eq 0)//net odenekler
					if(puantaj_exts[i][4] eq 1 and puantaj_exts[i][5] eq 1 and puantaj_exts[i][13] eq 1 and puantaj_exts[i][14] eq 0){
						//ssk da haric vergi de haric olanlar damga vergi carpani ile buyutulecek
						puantaj_exts[i][3] = wrk_round( (puantaj_exts[i][3]*1000)/(1000-get_active_program_parameter.STAMP_TAX_BINDE) );
						puantaj_exts[i][9] = 1;//artik brut oldu
				}
			}
			total_pay_d = total_pay_d + tutar_;
		}
		
	}
	</cfscript>
<cfelseif is_tax_ eq 1 and is_ssk_ eq 1 and isdefined("is_mesai_") and is_mesai_ eq 1>
	<cfscript>
		if(tutar_ gt 0)
		{
		//Ödenek fm varsa bozuyordu.
		include 'get_hr_compass_2022.cfm';
		is_from_odenek = 0; //90067 idli iş ödenek ile birlikte fazla mesai olduğunda get_hr_compass_from_net.cfm dosyasında if(isdefined("is_from_odenek") and is_from_odenek eq 1) kontrolune tekrar girmemesi isin eklendi 
		ilk_net = tutar_;
		brut_total_pay_ssk_tax_net = tutar_ * (ilk_salary_temp/ilk_sal_temp);
		salary_ilk = salary;
		net_total_brut = ilk_salary + brut_total_pay_ssk_tax_net + ekten_gelen;
		

		if(ilk_salary+ekten_gelen gt ssk_matrah_tavan) // dogrulandi
		{//brut ucret tavandan buyukse
				
			flag = true;
			count = 0;
			kumulatif_gelir = onceki_ay_kumulatif_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah;
			salary = tutar_;//20050925 simdilik bu sekilde, saatlik ve gunluk calisanlar icin bakilabilir
			salary_ilk = salary;
			sal_temp = salary;
			while(flag)
			{
				count = count + 1;
				kontrol = salary;
				gelir_vergisi_matrah = kontrol;
				//Damga vergisinden muafsa şartı get_hr_compass_tax.cfm dosyası içerisinde hesaplanıyor.+
				damga_vergisi_ = ((salary) * get_active_program_parameter.STAMP_TAX_BINDE ) / 1000;
				if(year(last_month_1) gte 2022 and (damga_vergisi_ gte daily_minimum_wage_stamp_tax) and use_ssk neq 2)
				{
					damga_vergisi_ = damga_vergisi_ - daily_minimum_wage_stamp_tax;
				}
				else if(year(last_month_1) gte 2022 and wrk_round(salary) lte wrk_round(daily_minimum_wage) and use_ssk neq 2)
					damga_vergisi_ = 0;		
				include 'get_hr_compass_tax.cfm';
				toplam_kesinti = gelir_vergisi + damga_vergisi_;
				net_ucret = salary - toplam_kesinti; 
				if (count gte 58 or sal_temp eq wrk_round(net_ucret) or sal_temp eq net_ucret)
					flag = false;
				else if (net_ucret gt sal_temp)
					salary = kontrol - (net_ucret - sal_temp);
				else if (net_ucret lt sal_temp)
					salary = kontrol + (sal_temp - net_ucret);
			}
			
				odenek_oncesi_gelir_vergisi_matrah = odenek_oncesi_gelir_vergisi_matrah + gelir_vergisi_matrah;
				odenek_oncesi_gelir_vergisi = odenek_oncesi_gelir_vergisi + gelir_vergisi;
				odenek_oncesi_damga_vergisi = odenek_oncesi_damga_vergisi + damga_vergisi;
				odenek_ssk_isveren_hissesi = wrk_round((salary/100) * ssk_isveren_carpan);
				this_ek_ucret_isveren = odenek_ssk_isveren_hissesi;
				eklenen = salary;
		}
		else if(ilk_salary+brut_total_pay_ssk_tax_net+ekten_gelen lte ssk_matrah_tavan)	  // dogrulandi
		{//brut ucret ve sadece hem ssk hem vergi dahil odenekler toplami tavandan kucukse
				flag = true;
			
				count = 0;
				kumulatif_gelir = onceki_ay_kumulatif_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah;
				salary = tutar_;//20050925 simdilik bu sekilde, saatlik ve gunluk calisanlar icin bakilabilir
				sal_temp = salary;
				salary_ilk = salary;
				while(flag)
				{
					count = count + 1;
					kontrol = salary;
					gelir_vergisi_matrah = kontrol;
					include 'get_hr_compass_tax.cfm';
					include 'get_hr_compass_formuls.cfm';
					include 'get_hr_compass_from_net.cfm';
					if (count gte 54 or sal_temp eq wrk_round(net_ucret) or sal_temp eq net_ucret)
						flag = false;
					else if (net_ucret gt sal_temp)
						salary = kontrol - (net_ucret - sal_temp);
					else if (net_ucret lt sal_temp)
						salary = kontrol + (sal_temp - net_ucret);
				}	
				odenek_oncesi_gelir_vergisi_matrah = odenek_oncesi_gelir_vergisi_matrah + gelir_vergisi_matrah;
				odenek_oncesi_gelir_vergisi = odenek_oncesi_gelir_vergisi + gelir_vergisi;
				odenek_oncesi_damga_vergisi = odenek_oncesi_damga_vergisi + damga_vergisi;
				odenek_ssk_isveren_hissesi = wrk_round((salary/100) * ssk_isveren_carpan);
				this_ek_ucret_isveren = odenek_ssk_isveren_hissesi;
				eklenen = salary;
		}
		else if(ilk_salary+brut_total_pay_ssk_tax_net+ekten_gelen gt ssk_matrah_tavan)	
		{
			first_brut = ssk_matrah_tavan - (ilk_salary+ekten_gelen);		
			first_eklenecek = first_brut;
			isci_payi = wrk_round(first_brut * (ssk_isci_carpan/100));
			issizlik_payi = wrk_round(first_brut * (issizlik_isci_carpan / 100));
			burada_gelir_vergisi_matrah = first_brut - isci_payi - issizlik_payi;
			first_brut = first_brut - isci_payi - issizlik_payi;
			if(get_hr_ssk.IS_TAX_FREE eq 1 and get_hr_ssk.use_ssk eq 3)//SGK'sız çalışansa ve gelir vergisinden muafsa (116442 ID'li iş için eklenmiştir. 23082019ERU)
			{
				burada_gelir_vergisi_matrah = 0;
			}
			this_kontrol = burada_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah + onceki_ay_kumulatif_gelir_vergisi_matrah;
			this_kontrol_2 = odenek_oncesi_gelir_vergisi_matrah + onceki_ay_kumulatif_gelir_vergisi_matrah;
			s1 = get_active_tax_slice.MAX_PAYMENT_1;	v1 = get_active_tax_slice.RATIO_1 / 100;
			s2 = get_active_tax_slice.MAX_PAYMENT_2;	v2 = get_active_tax_slice.RATIO_2 / 100;
			s3 = get_active_tax_slice.MAX_PAYMENT_3;	v3 = get_active_tax_slice.RATIO_3 / 100;
			s4 = get_active_tax_slice.MAX_PAYMENT_4;	v4 = get_active_tax_slice.RATIO_4 / 100;
			
				if(this_kontrol lt s1)
					{
					gelir_vergisi_dusen = burada_gelir_vergisi_matrah * tax_carpan;
					}
				else if(this_kontrol_2 lt s1 and this_kontrol gt s1 and this_kontrol lt s2)
					{
					ilk_kisim_ =  (burada_gelir_vergisi_matrah - (this_kontrol - s1)) * v1;
					ikinci_kisim_ = (this_kontrol - s1) * v2;
					gelir_vergisi_dusen = ilk_kisim_ + ikinci_kisim_;
					}
				else if(this_kontrol_2 lt s2 and this_kontrol gt s2 and this_kontrol lt s3)
					{
					ilk_kisim_ =  (burada_gelir_vergisi_matrah - (this_kontrol - s2)) * v2;
					ikinci_kisim_ = (this_kontrol - s2) * v3;
					gelir_vergisi_dusen = ilk_kisim_ + ikinci_kisim_;
					}
				else if(this_kontrol_2 lt s3 and this_kontrol gt s3 and this_kontrol lt s4)
					{
					ilk_kisim_ =  (burada_gelir_vergisi_matrah - (this_kontrol - s3)) * v3;
					ikinci_kisim_ = (this_kontrol - s3) * v4;
					gelir_vergisi_dusen = ilk_kisim_ + ikinci_kisim_;
					}
				else if(this_kontrol_2 lt s4 and this_kontrol gt s4)
					{
					ilk_kisim_ =  (burada_gelir_vergisi_matrah - (this_kontrol - s4)) * v4;
					ikinci_kisim_ = (this_kontrol - s4) * v5;
					gelir_vergisi_dusen = ilk_kisim_ + ikinci_kisim_;
					}
				else
					gelir_vergisi_dusen = burada_gelir_vergisi_matrah * tax_carpan;

				temp_gelir_vergisi_matrah = burada_gelir_vergisi_matrah;
				income_tax = gelir_vergisi_dusen;
				income_tax_base = burada_gelir_vergisi_matrah;
				include 'calc_tax_exemption.cfm';
				gelir_vergisi_dusen = income_tax;
		
			
			damga_vergisi_dusen = wrk_round(first_eklenecek * (get_active_program_parameter.STAMP_TAX_BINDE / 1000));

			if(year(last_month_1) gte 2022 and (damga_vergisi_dusen gte daily_minimum_wage_stamp_tax) and use_ssk neq 2)
			{
				damga_vergisi_dusen = damga_vergisi_dusen - daily_minimum_wage_stamp_tax;
				daily_minimum_wage_stamp_tax = 0;	
			}
			else if(year(last_month_1) gte 2022 and wrk_round(salary) lte wrk_round(daily_minimum_wage) and use_ssk neq 2)
				damga_vergisi_dusen = 0; 

			temp_stamp_tax_base = first_eklenecek;
			include 'get_hr_compass_2022.cfm';
			
			if(get_hr_ssk.is_damga_free eq 1){//SGK'sız çalışansa ve damga vergisinden muafsa (116442 ID'li iş için eklenmiştir. 23082019ERU)
				damga_vergisi_dusen = 0;
			}
			if(get_hr_ssk.is_tax_free eq 1){//SGK'sız çalışansa ve damga vergisinden muafsa (116442 ID'li iş için eklenmiştir. 23082019ERU)
				gelir_vergisi_dusen = 0;
			}

			first_net = first_brut - damga_vergisi_dusen - gelir_vergisi_dusen;
			ikinci_net = tutar_ - first_net;

				flag = true;
				count = 0;
				kumulatif_gelir = onceki_ay_kumulatif_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah + burada_gelir_vergisi_matrah;
				salary = ikinci_net;//20050925 simdilik bu sekilde, saatlik ve gunluk calisanlar icin bakilabilir
				sal_temp = salary;
				salary_ilk = salary;
				while(flag)
				{
					count = count + 1;
					kontrol = salary;
					gelir_vergisi_matrah = kontrol;
					if(get_hr_ssk.use_ssk eq 3){//SGK'sız çalışansa (116442 ID'li iş için eklenmiştir. 23082019ERU)
						damga_vergisi_ = ((salary) * get_active_program_parameter.STAMP_TAX_BINDE ) / 1000;		
						if(year(last_month_1) gte 2022 and (damga_vergisi_ gte daily_minimum_wage_stamp_tax) and use_ssk neq 2)
						{
							damga_vergisi_ = damga_vergisi_ - daily_minimum_wage_stamp_tax;
						}
						else if(year(last_month_1) gte 2022 and wrk_round(salary) lte wrk_round(daily_minimum_wage) and use_ssk neq 2)
							damga_vergisi = 0;			
						include 'get_hr_compass_tax.cfm';
					}
					else{
						include 'get_hr_compass_tax.cfm';
						damga_vergisi_ = ((salary) * get_active_program_parameter.STAMP_TAX_BINDE ) / 1000;	
						if(year(last_month_1) gte 2022 and (damga_vergisi_ gte daily_minimum_wage_stamp_tax) and use_ssk neq 2)
						{
							damga_vergisi_ = damga_vergisi_ - daily_minimum_wage_stamp_tax;
						}
						else if(year(last_month_1) gte 2022 and wrk_round(salary) lte wrk_round(daily_minimum_wage) and use_ssk neq 2)
							damga_vergisi_ = 0;		

						if(get_hr_ssk.is_damga_free eq 1){//SGK'sız çalışansa ve damga vergisinden muafsa (116442 ID'li iş için eklenmiştir. 23082019ERU)
							damga_vergisi_ = 0;
						}			
					}
					toplam_kesinti = gelir_vergisi + damga_vergisi_;
					net_ucret = salary - toplam_kesinti; 
					if (count gte 58 or sal_temp eq wrk_round(net_ucret) or sal_temp eq net_ucret)
						flag = false;
					else if (net_ucret gt sal_temp)
						salary = kontrol - (net_ucret - sal_temp);
					else if (net_ucret lt sal_temp)
						salary = kontrol + (sal_temp - net_ucret);
				}
				odenek_oncesi_gelir_vergisi_matrah = odenek_oncesi_gelir_vergisi_matrah + gelir_vergisi_matrah + burada_gelir_vergisi_matrah;
				odenek_oncesi_gelir_vergisi = odenek_oncesi_gelir_vergisi + gelir_vergisi + gelir_vergisi_dusen;
				odenek_oncesi_damga_vergisi = odenek_oncesi_damga_vergisi + damga_vergisi + damga_vergisi_dusen;
				odenek_ssk_isveren_hissesi = wrk_round((salary/100) * ssk_isveren_carpan);
				this_ek_ucret_isveren = odenek_ssk_isveren_hissesi;
				eklenen = salary + first_eklenecek;
			}
		}
	</cfscript>
<cfelseif is_tax_ eq 1 and is_ssk_ eq 1 and isdefined("is_izin_") and is_izin_ eq 1>
	<cfscript>
        if(ssk_days gt 0)
            include 'get_hr_compass_2022.cfm';
		if(tutar_ gt 0)
		{
		ilk_net = tutar_;
		/* 
		if (ilk_salary_temp eq 0 and ilk_sal_temp eq 0)
			brut_total_pay_ssk_tax_net = tutar_;
		else if((daily_minimum_wage_base neq 0 and total_used_stamp_tax neq 0 and total_used_incoming_tax neq 0) or attributes.sal_year lt 2022)
			brut_total_pay_ssk_tax_net = tutar_ * ((ilk_salary_temp)/ilk_sal_temp);
		else
			brut_total_pay_ssk_tax_net = tutar_ * ((ssk_asgari_ucret)/old_wage);
 		*/	

		//tahmini brut_total_pay_ssk_tax_net'i  bulmak için eklendi.
		{	
			flag = true;
			count = 0;
			kumulatif_gelir = onceki_ay_kumulatif_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah;
			salary = tutar_;
			sal_temp = salary;
			salary_ilk = salary;
			while(flag)
			{
				count = count + 1;
				kontrol = salary;
				gelir_vergisi_matrah = kontrol;
				include 'get_hr_compass_tax.cfm';
				include 'get_hr_compass_formuls.cfm';
				include 'get_hr_compass_from_net.cfm';
				if (count gte 10 or sal_temp eq wrk_round(net_ucret) or sal_temp eq net_ucret)
				{
					flag = false;
				}
				else if (net_ucret gt sal_temp)
					salary = kontrol - (net_ucret - sal_temp);
				else if (net_ucret lt sal_temp)
					salary = kontrol + (sal_temp - net_ucret);
			}
			brut_total_pay_ssk_tax_net = salary;
		}
 
		net_total_brut = ilk_salary + brut_total_pay_ssk_tax_net + ekten_gelen;

		if(ilk_salary+ekten_gelen gt ssk_matrah_tavan) // dogrulandi
		{//brut ucret tavandan buyukse
			flag = true;
			count = 0;
			kumulatif_gelir = onceki_ay_kumulatif_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah;
			salary = tutar_;//20050925 simdilik bu sekilde, saatlik ve gunluk calisanlar icin bakilabilir
			sal_temp = salary;
			salary_ilk = salary;
			while(flag)
			{
				count = count + 1;
				kontrol = salary;
				gelir_vergisi_matrah = kontrol;
				include 'get_hr_compass_tax.cfm';
				damga_vergisi_ = ((salary) * get_active_program_parameter.STAMP_TAX_BINDE ) / 1000;
				if(year(last_month_1) gte 2022 and (damga_vergisi_ gte daily_minimum_wage_stamp_tax) and use_ssk neq 2)
				{
					damga_vergisi_ = damga_vergisi_ - daily_minimum_wage_stamp_tax;
				}
				else if(year(last_month_1) gte 2022 and wrk_round(salary) lte wrk_round(daily_minimum_wage) and use_ssk neq 2)
					damga_vergisi_ = 0;	
				toplam_kesinti = gelir_vergisi + damga_vergisi_;
				net_ucret = salary - toplam_kesinti; 
				if (count gte 58 or sal_temp eq wrk_round(net_ucret) or sal_temp eq net_ucret)
				{
					flag = false;
				}
				else if (net_ucret gt sal_temp)
					salary = kontrol - (net_ucret - sal_temp);
				else if (net_ucret lt sal_temp)
					salary = kontrol + (sal_temp - net_ucret);
			}
			odenek_oncesi_gelir_vergisi_matrah = odenek_oncesi_gelir_vergisi_matrah + gelir_vergisi_matrah;
			odenek_oncesi_gelir_vergisi = odenek_oncesi_gelir_vergisi + gelir_vergisi;
			odenek_oncesi_damga_vergisi = odenek_oncesi_damga_vergisi + damga_vergisi;
			eklenen = salary;
		}
		else if(ilk_salary+brut_total_pay_ssk_tax_net+ekten_gelen lte ssk_matrah_tavan)	  // dogrulandi
		{//brut ucret ve sadece hem ssk hem vergi dahil odenekler toplami tavandan kucukse
			flag = true;
			count = 0;
			kumulatif_gelir = onceki_ay_kumulatif_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah;
			salary = tutar_;//20050925 simdilik bu sekilde, saatlik ve gunluk calisanlar icin bakilabilir
			sal_temp = salary;
			salary_ilk = salary;
			while(flag)
			{
				count = count + 1;
				kontrol = salary;
				gelir_vergisi_matrah = kontrol;
				include 'get_hr_compass_tax.cfm';
				include 'get_hr_compass_formuls.cfm';
				include 'get_hr_compass_from_net.cfm';
				if (count gte 54 or sal_temp eq wrk_round(net_ucret) or sal_temp eq net_ucret)
				{
					flag = false;
				}
				else if (net_ucret gt sal_temp)
					salary = kontrol - (net_ucret - sal_temp);
				else if (net_ucret lt sal_temp)
					salary = kontrol + (sal_temp - net_ucret);
			}
			odenek_oncesi_gelir_vergisi_matrah = odenek_oncesi_gelir_vergisi_matrah + gelir_vergisi_matrah;
			odenek_oncesi_gelir_vergisi = odenek_oncesi_gelir_vergisi + gelir_vergisi;
			odenek_oncesi_damga_vergisi = odenek_oncesi_damga_vergisi + damga_vergisi;
			eklenen = salary;
		}
		else if(ilk_salary+brut_total_pay_ssk_tax_net+ekten_gelen+ssk_odenek_dahil_brut gt ssk_matrah_tavan)	
		{
			first_brut = ssk_matrah_tavan - (ilk_salary_temp+ekten_gelen+ssk_odenek_dahil_brut);
			first_eklenecek = first_brut;
			isci_payi = wrk_round(first_brut * (ssk_isci_carpan/100));
			issizlik_payi = wrk_round(first_brut * (issizlik_isci_carpan / 100));
			burada_gelir_vergisi_matrah = first_brut - isci_payi - issizlik_payi;
			first_brut = first_brut - isci_payi - issizlik_payi;
			this_kontrol = burada_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah + onceki_ay_kumulatif_gelir_vergisi_matrah;
			this_kontrol_2 = odenek_oncesi_gelir_vergisi_matrah + onceki_ay_kumulatif_gelir_vergisi_matrah;
			s1 = get_active_tax_slice.MAX_PAYMENT_1;	v1 = get_active_tax_slice.RATIO_1 / 100;
			s2 = get_active_tax_slice.MAX_PAYMENT_2;	v2 = get_active_tax_slice.RATIO_2 / 100;
			s3 = get_active_tax_slice.MAX_PAYMENT_3;	v3 = get_active_tax_slice.RATIO_3 / 100;
			s4 = get_active_tax_slice.MAX_PAYMENT_4;	v4 = get_active_tax_slice.RATIO_4 / 100;
			
				if(this_kontrol lt s1)
				{
					gelir_vergisi_dusen = burada_gelir_vergisi_matrah * tax_carpan;
				}
				else if(this_kontrol_2 lt s1 and this_kontrol gt s1 and this_kontrol lt s2)
				{
					ilk_kisim_ =  (burada_gelir_vergisi_matrah - (this_kontrol - s1)) * v1;
					ikinci_kisim_ = (this_kontrol - s1) * v2;
					gelir_vergisi_dusen = ilk_kisim_ + ikinci_kisim_;
				}
				else if(this_kontrol_2 lt s2 and this_kontrol gt s2 and this_kontrol lt s3)
				{
					ilk_kisim_ =  (burada_gelir_vergisi_matrah - (this_kontrol - s2)) * v2;
					ikinci_kisim_ = (this_kontrol - s2) * v3;
					gelir_vergisi_dusen = ilk_kisim_ + ikinci_kisim_;
				}
				else if(this_kontrol_2 lt s3 and this_kontrol gt s3 and this_kontrol lt s4)
				{
					ilk_kisim_ =  (burada_gelir_vergisi_matrah - (this_kontrol - s3)) * v3;
					ikinci_kisim_ = (this_kontrol - s3) * v4;
					gelir_vergisi_dusen = ilk_kisim_ + ikinci_kisim_;
				}
				else if(this_kontrol_2 lt s4 and this_kontrol gt s4)
				{
					ilk_kisim_ =  (burada_gelir_vergisi_matrah - (this_kontrol - s4)) * v4;
					ikinci_kisim_ = (this_kontrol - s4) * v5;
					gelir_vergisi_dusen = ilk_kisim_ + ikinci_kisim_;
				}
				else
					gelir_vergisi_dusen = burada_gelir_vergisi_matrah * tax_carpan;
				
				temp_gelir_vergisi_matrah = burada_gelir_vergisi_matrah;
				income_tax = gelir_vergisi_dusen;
				income_tax_base = burada_gelir_vergisi_matrah;
				include 'calc_tax_exemption.cfm';
				gelir_vergisi_dusen = income_tax;
				
				damga_vergisi_dusen = wrk_round(first_eklenecek * (get_active_program_parameter.STAMP_TAX_BINDE / 1000));
				
		 		if(year(last_month_1) gte 2022 and (damga_vergisi_dusen gte daily_minimum_wage_stamp_tax) and use_ssk neq 2)
				{
					damga_vergisi_dusen = damga_vergisi_dusen - daily_minimum_wage_stamp_tax;
					daily_minimum_wage_stamp_tax = 0;	
				}
				else if(year(last_month_1) gte 2022 and wrk_round(salary) lte wrk_round(daily_minimum_wage) and use_ssk neq 2)
					damga_vergisi_dusen = 0; 

				temp_stamp_tax_base = first_eklenecek;
				include 'get_hr_compass_2022.cfm';

				first_net = first_brut - damga_vergisi_dusen - gelir_vergisi_dusen;
				ikinci_net = tutar_ - first_net;
				flag = true;
				count = 0;
				kumulatif_gelir = onceki_ay_kumulatif_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah + burada_gelir_vergisi_matrah;
				salary = ikinci_net;//20050925 simdilik bu sekilde, saatlik ve gunluk calisanlar icin bakilabilir
				sal_temp = salary;
				salary_ilk = salary;
				while(flag)
				{
					count = count + 1;
					kontrol = salary;
					gelir_vergisi_matrah = kontrol;
					include 'get_hr_compass_tax.cfm';
					damga_vergisi_ = ((salary) * get_active_program_parameter.STAMP_TAX_BINDE ) / 1000;	
					if(year(last_month_1) gte 2022 and (damga_vergisi_ gte daily_minimum_wage_stamp_tax) and use_ssk neq 2)
					{
						damga_vergisi_ = damga_vergisi_ - daily_minimum_wage_stamp_tax;
					}
					else if(year(last_month_1) gte 2022 and wrk_round(salary) lte wrk_round(daily_minimum_wage) and use_ssk neq 2)
						damga_vergisi_ = 0;	
					toplam_kesinti = gelir_vergisi + damga_vergisi_;
					net_ucret = salary - toplam_kesinti; 
					if (count gte 58 or sal_temp eq wrk_round(net_ucret) or sal_temp eq net_ucret)
					{
						flag = false;
					}
					else if (net_ucret gt sal_temp)
						salary = kontrol - (net_ucret - sal_temp);
					else if (net_ucret lt sal_temp)
						salary = kontrol + (sal_temp - net_ucret);
				}
				odenek_oncesi_gelir_vergisi_matrah = odenek_oncesi_gelir_vergisi_matrah + gelir_vergisi_matrah + burada_gelir_vergisi_matrah;
				odenek_oncesi_gelir_vergisi = odenek_oncesi_gelir_vergisi + gelir_vergisi + gelir_vergisi_dusen;
				odenek_oncesi_damga_vergisi = odenek_oncesi_damga_vergisi + damga_vergisi_ + damga_vergisi_dusen;
				eklenen = salary + first_eklenecek;
			}
		}
	</cfscript>
<cfelseif is_tax_ eq 1 and is_ssk_ eq 1 and isdefined("is_issizlik_") and is_issizlik_ eq 1 and isdefined("is_ssk_tax_net_odenek") and is_ssk_tax_net_odenek eq 1>
	<cfscript>
		if((is_tax_free_from_payment eq 1 and count_2022 gt 0) or is_tax_free_from_payment eq 0)
			include 'get_hr_compass_2022.cfm';
		if(tutar_ gt 0)
		{
		ilk_net = tutar_;
		
		
		if(get_hr_salary.gross_net eq 0 and total_pay_ssk_tax gt 0)
			baz_deger_ = ilk_salary + total_pay_ssk_tax + onceki_ssk_tax_net_odenek;
		else
			baz_deger_ = ilk_salary + onceki_ssk_tax_net_odenek;

		baz_deger_ = ilk_salary + total_pay_ssk;

		/*
			2022 verigi indirimlerinden dolayı kapatıldı. 
			//ilk salary içerisine nceki ssk tax net odenek dahil geldiği için kapatıldı
			baz_deger_ = ilk_salary + total_pay_ssk + onceki_ssk_tax_net_odenek;//20140422 77702 id li iş için eklendi , vergiden muaf olan ödeneklerin brüt tutarları da sgk matrahı kontrolüne ekleniyor
			if(get_hr_salary.gross_net eq 0)
			{
				ilk_sal_temp = ilk_salary - (ilk_salary * 30 /100);
			}
		
			if(ssk_days and baz_deger_) 
				brut_tutar_ = tutar_ * wrk_round(ilk_salary/ilk_sal_temp,5);
			else
				brut_tutar_ = tutar_;
		*/

		if (ilk_salary_temp eq 0 and ilk_sal_temp eq 0)
		{
			brut_tutar_ = tutar_;
		}
		else if((daily_minimum_wage_base neq 0 and total_used_stamp_tax neq 0 and total_used_incoming_tax neq 0) or attributes.sal_year lt 2022)
		{
			brut_tutar_ = tutar_ * ((ilk_salary_temp)/ilk_sal_temp);
		}
		else
		{
			brut_tutar_ = tutar_ * ((ssk_asgari_ucret)/old_wage);
		}
			
		net_total_brut = brut_tutar_ + baz_deger_;
		if(baz_deger_ gt ssk_matrah_tavan) // dogrulandi
		{
			//brut ucret tavandan buyukse
			//writedump(puantaj_exts);
			//abort('baz_deger_:#baz_deger_# #tutar_# #onceki_ssk_tax_net_odenek#');
			flag = true;
			count = 0;
			kumulatif_gelir = onceki_ay_kumulatif_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah;
			salary = tutar_;//20050925 simdilik bu sekilde, saatlik ve gunluk calisanlar icin bakilabilir
			sal_temp = salary;
			salary_ilk = salary;
			while(flag)
			{
				count = count + 1;
				kontrol = salary;
				gelir_vergisi_matrah = kontrol;
				include 'get_hr_compass_tax.cfm';
				
				damga_vergisi_ = ((salary) * get_active_program_parameter.STAMP_TAX_BINDE ) / 1000;
				if(year(last_month_1) gte 2022 and (damga_vergisi_ gte daily_minimum_wage_stamp_tax) and use_ssk neq 2)
				{
					damga_vergisi_ = damga_vergisi_ - daily_minimum_wage_stamp_tax;
				}
				else if(year(last_month_1) gte 2022 and wrk_round(salary) lte wrk_round(daily_minimum_wage) and use_ssk neq 2)
					damga_vergisi_ = 0;	
				toplam_kesinti = (gelir_vergisi-(vergi_matraha_dahil_olmayan_odenek_tutar*tax_carpan)) + damga_vergisi_;
				net_ucret = salary - toplam_kesinti; 
				if (count gte 58 or sal_temp eq wrk_round(net_ucret) or sal_temp eq net_ucret)
					flag = false;
				else if (net_ucret gt sal_temp)
					salary = kontrol - (net_ucret - sal_temp);
				else if (net_ucret lt sal_temp)
					salary = kontrol + (sal_temp - net_ucret);
			}
			odenek_ssk_isveren_hissesi = wrk_round((salary/100) * ssk_isveren_carpan);
			odenek_oncesi_gelir_vergisi_matrah = odenek_oncesi_gelir_vergisi_matrah + gelir_vergisi_matrah;
			odenek_oncesi_gelir_vergisi = odenek_oncesi_gelir_vergisi + gelir_vergisi;
			odenek_oncesi_damga_vergisi = odenek_oncesi_damga_vergisi + damga_vergisi;
			total_pay_ssk_tax = total_pay_ssk_tax + salary;
			eklenen = salary;
			this_ek_ucret_gelir = gelir_vergisi;
			this_ek_ucret_damga = damga_vergisi;
			this_ek_ucret_isveren = odenek_ssk_isveren_hissesi;
		}
		else if(baz_deger_+brut_tutar_ lte ssk_matrah_tavan)	  // dogrulandi
		{
			//brut ucret ve sadece hem ssk hem vergi dahil odenekler toplami tavandan kucukse
			flag = true;
			count = 0;
			kumulatif_gelir = onceki_ay_kumulatif_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah;
			salary = brut_tutar_;//20050925 simdilik bu sekilde, saatlik ve gunluk calisanlar icin bakilabilir
			sal_temp = tutar_;			
			is_from_odenek = 1;
			salary_ilk = salary;
			while(flag)
			{
				count = count + 1;
				kontrol = salary;
				gelir_vergisi_matrah = kontrol;
				
				include 'get_hr_compass_tax.cfm';
				include 'get_hr_compass_formuls.cfm';
				include 'get_hr_compass_from_net.cfm';
				
				if (count gte 60 or sal_temp eq wrk_round(net_ucret) or sal_temp eq net_ucret)
					flag = false;
				else if (net_ucret gt sal_temp)
					salary = kontrol - (net_ucret - sal_temp);
				else if (net_ucret lt sal_temp)
					salary = kontrol + (sal_temp - net_ucret);
			}
			odenek_ssk_isveren_hissesi = wrk_round((salary/100) * ssk_isveren_carpan);
			odenek_oncesi_gelir_vergisi_matrah = odenek_oncesi_gelir_vergisi_matrah + gelir_vergisi_matrah;
			odenek_oncesi_gelir_vergisi = odenek_oncesi_gelir_vergisi + gelir_vergisi;
			odenek_oncesi_damga_vergisi = odenek_oncesi_damga_vergisi + damga_vergisi;
			total_pay_ssk_tax = total_pay_ssk_tax + salary;	
			
			this_ek_ucret_gelir = gelir_vergisi;
			this_ek_ucret_damga = damga_vergisi;
			this_ek_ucret_isveren = odenek_ssk_isveren_hissesi;
			eklenen = salary;
		}
		else if(baz_deger_+brut_tutar_ gt ssk_matrah_tavan)	
		{
			first_brut = ssk_matrah_tavan - baz_deger_;
			first_eklenecek = first_brut;
			isci_payi = wrk_round(first_brut *  (ssk_isci_carpan/100));
			isveren_payi_dusen = wrk_round(first_brut *  (ssk_isveren_carpan/100));
			issizlik_payi = wrk_round(first_brut * (issizlik_isci_carpan / 100));
			burada_gelir_vergisi_matrah = first_brut - isci_payi - issizlik_payi;
			first_brut = first_brut - isci_payi - issizlik_payi;	
			
			this_kontrol = burada_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah + onceki_ay_kumulatif_gelir_vergisi_matrah;
			this_kontrol_2 = odenek_oncesi_gelir_vergisi_matrah + onceki_ay_kumulatif_gelir_vergisi_matrah;
			s1 = get_active_tax_slice.MAX_PAYMENT_1;	v1 = get_active_tax_slice.RATIO_1 / 100;
			s2 = get_active_tax_slice.MAX_PAYMENT_2;	v2 = get_active_tax_slice.RATIO_2 / 100;
			s3 = get_active_tax_slice.MAX_PAYMENT_3;	v3 = get_active_tax_slice.RATIO_3 / 100;
			s4 = get_active_tax_slice.MAX_PAYMENT_4;	v4 = get_active_tax_slice.RATIO_4 / 100;
			s5 = get_active_tax_slice.MAX_PAYMENT_5;	v5 = get_active_tax_slice.RATIO_5 / 100;
			s6 = get_active_tax_slice.MAX_PAYMENT_6;	v6 = get_active_tax_slice.RATIO_6 / 100;
			if(this_kontrol lt s1)
			{
				gelir_vergisi_dusen = burada_gelir_vergisi_matrah * tax_carpan;
			}
			else if(this_kontrol_2 lt s1 and this_kontrol gt s1 and this_kontrol lt s2)
			{
				ilk_kisim_ =  (burada_gelir_vergisi_matrah - (this_kontrol - s1)) * v1;
				ikinci_kisim_ = (this_kontrol - s1) * v2;
				gelir_vergisi_dusen = ilk_kisim_ + ikinci_kisim_;
			}
			else if(this_kontrol_2 lt s2 and this_kontrol gt s2 and this_kontrol lt s3)
			{
				ilk_kisim_ =  (burada_gelir_vergisi_matrah - (this_kontrol - s2)) * v2;
				ikinci_kisim_ = (this_kontrol - s2) * v3;
				gelir_vergisi_dusen = ilk_kisim_ + ikinci_kisim_;
			}
			else if(this_kontrol_2 lt s3 and this_kontrol gt s3 and this_kontrol lt s4)
			{
				ilk_kisim_ =  (burada_gelir_vergisi_matrah - (this_kontrol - s3)) * v3;
				ikinci_kisim_ = (this_kontrol - s3) * v4;
				gelir_vergisi_dusen = ilk_kisim_ + ikinci_kisim_;
			}
			else if(this_kontrol_2 lt s4 and this_kontrol gt s4)
			{
				ilk_kisim_ =  (burada_gelir_vergisi_matrah - (this_kontrol - s4)) * v4;
				ikinci_kisim_ = (this_kontrol - s4) * v5;
				gelir_vergisi_dusen = ilk_kisim_ + ikinci_kisim_;
			}
			else
				gelir_vergisi_dusen = burada_gelir_vergisi_matrah * tax_carpan;
				
			temp_gelir_vergisi_matrah = burada_gelir_vergisi_matrah;

			income_tax = gelir_vergisi_dusen;
			income_tax_base = burada_gelir_vergisi_matrah;
			include 'calc_tax_exemption.cfm';
			gelir_vergisi_dusen = income_tax;

			damga_vergisi_dusen = wrk_round(first_eklenecek * (get_active_program_parameter.STAMP_TAX_BINDE / 1000));

			if(year(last_month_1) gte 2022 and (damga_vergisi_dusen gte daily_minimum_wage_stamp_tax) and use_ssk neq 2)
			{
				damga_vergisi_dusen = damga_vergisi_dusen - daily_minimum_wage_stamp_tax;
			}
			else if(year(last_month_1) gte 2022 and wrk_round(first_eklenecek) lte wrk_round(daily_minimum_wage) and use_ssk neq 2)
				damga_vergisi_dusen = 0; 
				
			temp_stamp_tax_base = first_eklenecek;

			include 'get_hr_compass_2022.cfm';
			first_net = first_brut - damga_vergisi_dusen - gelir_vergisi_dusen;
			
			
			if(first_net gt tutar_  or (first_net eq 0 and tutar_ gt 0 and ssk_matrah_tavan eq 0) )
			{
				flag = true;
				count = 0;
				kumulatif_gelir = onceki_ay_kumulatif_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah;
				salary = tutar_;//20050925 simdilik bu sekilde, saatlik ve gunluk calisanlar icin bakilabilir
				sal_temp = tutar_;			
				salary_ilk = salary;
				while(flag)
				{
					count = count + 1;
					kontrol = salary;
					gelir_vergisi_matrah = kontrol;
					include 'get_hr_compass_tax.cfm';
					include 'get_hr_compass_formuls.cfm';
					include 'get_hr_compass_from_net.cfm';
					if (count gte 60 or sal_temp eq wrk_round(net_ucret) or sal_temp eq net_ucret)
						flag = false;
					else if (net_ucret gt sal_temp)
						salary = kontrol - (net_ucret - sal_temp);
					else if (net_ucret lt sal_temp)
						salary = kontrol + (sal_temp - net_ucret);
				}
				odenek_ssk_isveren_hissesi = wrk_round((salary/100) * ssk_isveren_carpan);
				odenek_oncesi_gelir_vergisi_matrah = odenek_oncesi_gelir_vergisi_matrah + gelir_vergisi_matrah;
				odenek_oncesi_gelir_vergisi = odenek_oncesi_gelir_vergisi + gelir_vergisi;
				odenek_oncesi_damga_vergisi = odenek_oncesi_damga_vergisi + damga_vergisi;
				
				this_ek_ucret_gelir = gelir_vergisi;
				this_ek_ucret_damga = damga_vergisi;
				this_ek_ucret_isveren = odenek_ssk_isveren_hissesi;
				
				total_pay_ssk_tax = total_pay_ssk_tax + salary;	
				eklenen = salary;
			}
			else
			{
				if(first_net lt 0) first_net = 0;
				ikinci_net = tutar_ - first_net;
							
				flag = true;
				count = 0;
				kumulatif_gelir = onceki_ay_kumulatif_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah + burada_gelir_vergisi_matrah;
				salary = ikinci_net;//20050925 simdilik bu sekilde, saatlik ve gunluk calisanlar icin bakilabilir
				sal_temp = salary;
				salary_ilk = salary;
				while(flag)
				{
					count = count + 1;
					kontrol = salary;
					gelir_vergisi_matrah = kontrol;
					include 'get_hr_compass_tax.cfm';
					damga_vergisi_ = ((salary) * get_active_program_parameter.STAMP_TAX_BINDE ) / 1000;
					if(year(last_month_1) gte 2022 and (damga_vergisi_ gte daily_minimum_wage_stamp_tax) and use_ssk neq 2)
					{
						damga_vergisi_ = damga_vergisi_ - daily_minimum_wage_stamp_tax;
					}
					else if(year(last_month_1) gte 2022 and wrk_round(salary) lte wrk_round(daily_minimum_wage) and use_ssk neq 2)
						damga_vergisi_ = 0;	
					toplam_kesinti = (gelir_vergisi-(vergi_matraha_dahil_olmayan_odenek_tutar*tax_carpan)) + damga_vergisi_;
					net_ucret = salary - toplam_kesinti; 
					if(count gte 58 or sal_temp eq wrk_round(net_ucret) or sal_temp eq net_ucret)
						flag = false;
					else if (net_ucret gt sal_temp)
						salary = kontrol - (net_ucret - sal_temp);
					else if (net_ucret lt sal_temp)
						salary = kontrol + (sal_temp - net_ucret);
						
				}
				odenek_oncesi_gelir_vergisi_matrah = odenek_oncesi_gelir_vergisi_matrah + gelir_vergisi_matrah + burada_gelir_vergisi_matrah;
				odenek_oncesi_gelir_vergisi = odenek_oncesi_gelir_vergisi + gelir_vergisi + gelir_vergisi_dusen;
				odenek_oncesi_damga_vergisi = odenek_oncesi_damga_vergisi + damga_vergisi + damga_vergisi_dusen;
				total_pay_ssk_tax = total_pay_ssk_tax + salary + first_eklenecek;
				eklenen = salary + first_eklenecek;
				
				this_ek_ucret_gelir = gelir_vergisi + gelir_vergisi_dusen;
				this_ek_ucret_damga = damga_vergisi + damga_vergisi_dusen;
				this_ek_ucret_isveren = isveren_payi_dusen;
			}
		}	
			//net_odenek_aylik olduğunda zaten tutar orantılanmış şekilde geliyor.
			if(not(isDefined("net_odenek_aylik") and net_odenek_aylik eq 1))
				this_oran = eklenen  / ilk_net;
			else
				this_oran = 1;
			for (i=1; i lte arraylen(puantaj_exts); i = i+1)
			{
				if(i eq odenek_sira)
				{
					if(puantaj_exts[i][6] eq 0 and puantaj_exts[i][9] eq 0)//net odenekler
						if(puantaj_exts[i][4] eq 2 and puantaj_exts[i][5] eq 2 and puantaj_exts[i][13] eq 1 and puantaj_exts[i][14] eq 1){//sadece vergi dahil olanlar veri carpani ile buyutulecek
							puantaj_exts[i][3] = puantaj_exts[i][3] * this_oran;
							puantaj_exts[i][8] = puantaj_exts[i][8] * this_oran;
							if((isDefined("net_odenek_aylik") and net_odenek_aylik eq 1) or (isdefined("from_net_wage") and len("from_net_wage")))
								puantaj_exts[i][15] = ilk_net;
							//sgk muafiyeti var ise  //SG 20151222
							if(len(puantaj_exts[i][36]) and len(puantaj_exts[i][37])) //sgk muafiyet oranı ve sgk muafiyet tipi
							{
								if(puantaj_exts[i][37] eq 0) //muafiyet tipi Asgari Ücrete Göre
									{
									_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL * puantaj_exts[i][36] / 100;
									if(_tutar gt puantaj_exts[i][3])
										_tutar = puantaj_exts[i][3];
									}
								else if(puantaj_exts[i][37] eq 1) // muafiyet tipi Tutara Göre
									_tutar = puantaj_exts[i][3] * puantaj_exts[i][36] / 100;
								else if(puantaj_exts[i][37] eq 2) //muafiyet tipi Günlük Asgari Ücrete Göre
								{
									if(puantaj_exts[i][7] eq 1)//güne göre
										_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * ssk_days;
									else if(get_pay_salary.calc_days[i] eq 2)//fiili güne göre
										_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * fiili_gun_;
									else
										_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * puantaj_exts[i][15];
								}
								ssk_matraha_dahil_olmayan_net_odenek_tutar = ssk_matraha_dahil_olmayan_net_odenek_tutar + _tutar;
								
								if(arraylen(puantaj_exts[i]) gte 40 and len(puantaj_exts[i][40]))
								{
									if(puantaj_exts[i][40] gt puantaj_exts[i][3])
									puantaj_exts[i][40] = puantaj_exts[i][3];
									
									eski_tutar_ = puantaj_exts[i][40];
									if(_tutar gt eski_tutar_)
										ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + (_tutar - eski_tutar_);

									if(eski_tutar_ gt eklenen)
									puantaj_exts[i][40] = eklenen;
								}
							}
							

							
							
							if(arraylen(puantaj_exts[i]) gte 38 and len(puantaj_exts[i][38]))
							{
								_tutar = puantaj_exts[i][8] * puantaj_exts[i][38];
								vergi_matraha_dahil_olmayan_net_odenek_tutar = vergi_matraha_dahil_olmayan_net_odenek_tutar + _tutar;
							}
							
							if(arraylen(puantaj_exts[i]) gte 39 and len(puantaj_exts[i][39]))
							{
								_tutar =  puantaj_exts[i][39];
								if(_tutar gt puantaj_exts[i][3])
								{
									_tutar = puantaj_exts[i][3];
								}
								
								eski_tutar_ = puantaj_exts[i][41];
								
								if(_tutar gt eski_tutar_)
									vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + (_tutar - eski_tutar_);
								
								vergi_matraha_dahil_olmayan_net_odenek_tutar = vergi_matraha_dahil_olmayan_net_odenek_tutar + _tutar;
							}
							
							
							puantaj_exts[i][9] = 1;//artik brut oldu
						

							aktif_ek_odenek_brut_hal = puantaj_exts[i][3];
							onceki_ssk_tax_net_odenek = onceki_ssk_tax_net_odenek + aktif_ek_odenek_brut_hal;
						}
					}
				}				
		}
	</cfscript>
	<cfset net_odenek_ssk_isci_hissesi = net_odenek_ssk_isci_hissesi + ssk_isci_hissesi>
	<cfset net_odenek_ssk_issizlik_hissesi =  net_odenek_ssk_issizlik_hissesi + issizlik_isci_hissesi>
	<cfset net_odenek_ssdf_isci_hissesi = net_odenek_ssdf_isci_hissesi + ssdf_isci_hissesi>
	<cfset net_odenek_ssdf_isveren_hissesi =  net_odenek_ssdf_isveren_hissesi + ssdf_isveren_hissesi>
<cfelseif is_tax_ eq 1 and is_ssk_ eq 1 and isdefined("is_issizlik_") and is_issizlik_ eq 1>
	<cfscript>
		include 'get_hr_compass_2022.cfm';
		if(total_pay_ssk_tax_net gt 0)
		{
		ilk_net = total_pay_ssk_tax_net;
		
		if(get_hr_salary.gross_net eq 0 and total_pay_ssk_tax gt 0)
			baz_deger_ = ilk_salary + total_pay_ssk_tax;
		else
			baz_deger_ = ilk_salary;
		baz_deger_ = ilk_salary + total_pay_ssk;//20140422 77702 id li iş için eklendi , vergiden muaf olan ödeneklerin brüt tutarları da sgk matrahı kontrolüne ekleniyor
		if(get_hr_salary.gross_net eq 0)
			{
				ilk_sal_temp = ilk_salary - (ilk_salary * 30 /100);
			}
		
		if(ssk_days and baz_deger_) 
			brut_total_pay_ssk_tax_net = total_pay_ssk_tax_net * wrk_round(ilk_salary/ilk_sal_temp,5);
		else
			brut_total_pay_ssk_tax_net = total_pay_ssk_tax_net;

		net_total_brut = baz_deger_ + brut_total_pay_ssk_tax_net;
				
		if(baz_deger_ gt ssk_matrah_tavan) // dogrulandi
			{//brut ucret tavandan buyukse
				flag = true;
				count = 0;
				kumulatif_gelir = onceki_ay_kumulatif_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah;
				salary = tutar_;//20050925 simdilik bu sekilde, saatlik ve gunluk calisanlar icin bakilabilir
				sal_temp = salary;
				salary_ilk = salary;
				while(flag)
					{
					count = count + 1;
					kontrol = salary;
					gelir_vergisi_matrah = kontrol;
					include 'get_hr_compass_tax.cfm';
					
					damga_vergisi_ = ((salary) * get_active_program_parameter.STAMP_TAX_BINDE ) / 1000;
					toplam_kesinti = (gelir_vergisi-(vergi_matraha_dahil_olmayan_odenek_tutar*tax_carpan)) + damga_vergisi_;
					net_ucret = salary - toplam_kesinti; 
					if (count gte 58 or sal_temp eq wrk_round(net_ucret) or sal_temp eq net_ucret)
						flag = false;
					else if (net_ucret gt sal_temp)
						salary = kontrol - (net_ucret - sal_temp);
					else if (net_ucret lt sal_temp)
						salary = kontrol + (sal_temp - net_ucret);
					}
					odenek_oncesi_gelir_vergisi_matrah = odenek_oncesi_gelir_vergisi_matrah + gelir_vergisi_matrah;
					odenek_oncesi_gelir_vergisi = odenek_oncesi_gelir_vergisi + gelir_vergisi;
					odenek_oncesi_damga_vergisi = odenek_oncesi_damga_vergisi + damga_vergisi;
					total_pay_ssk_tax = total_pay_ssk_tax + salary;
					eklenen = salary;
			}
		else if(baz_deger_+brut_total_pay_ssk_tax_net lte ssk_matrah_tavan)	  // dogrulandi
			{//brut ucret ve sadece hem ssk hem vergi dahil odenekler toplami tavandan kucukse
				flag = true;
				count = 0;
				kumulatif_gelir = onceki_ay_kumulatif_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah;
				salary = brut_total_pay_ssk_tax_net;//20050925 simdilik bu sekilde, saatlik ve gunluk calisanlar icin bakilabilir
				sal_temp = tutar_;			
				is_from_odenek = 1;
				salary_ilk = salary;
				while(flag)
					{
					count = count + 1;
					kontrol = salary;
					gelir_vergisi_matrah = kontrol;
					
					include 'get_hr_compass_tax.cfm';
					include 'get_hr_compass_formuls.cfm';
					include 'get_hr_compass_from_net.cfm';
					
					if (count gte 60 or sal_temp eq wrk_round(net_ucret) or sal_temp eq net_ucret)
						flag = false;
					else if (net_ucret gt sal_temp)
						salary = kontrol - (net_ucret - sal_temp);
					else if (net_ucret lt sal_temp)
						salary = kontrol + (sal_temp - net_ucret);
					}
				if(isdefined("haric_matrah_sifirla") and haric_matrah_sifirla eq 1)
					ssk_matraha_dahil_olmayan_odenek_tutar = salary;

				if(ssk_matraha_dahil_olmayan_odenek_tutar gt salary)
					ssk_matraha_dahil_olmayan_odenek_tutar = salary;

				odenek_oncesi_gelir_vergisi_matrah = odenek_oncesi_gelir_vergisi_matrah + gelir_vergisi_matrah;
				odenek_oncesi_gelir_vergisi = odenek_oncesi_gelir_vergisi + gelir_vergisi;
				odenek_oncesi_damga_vergisi = odenek_oncesi_damga_vergisi + damga_vergisi;
				total_pay_ssk_tax = total_pay_ssk_tax + salary;	
				eklenen = salary;
			}
		else if(baz_deger_+brut_total_pay_ssk_tax_net gt ssk_matrah_tavan)	
		{
			first_brut = ssk_matrah_tavan - ilk_salary;
			first_eklenecek = first_brut;
			isci_payi = wrk_round(first_brut *  (ssk_isci_carpan/100));
			issizlik_payi = wrk_round(first_brut * (issizlik_isci_carpan / 100));
			burada_gelir_vergisi_matrah = first_brut - isci_payi - issizlik_payi;
			first_brut = first_brut - isci_payi - issizlik_payi;	
			
			this_kontrol = burada_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah + onceki_ay_kumulatif_gelir_vergisi_matrah;
			this_kontrol_2 = odenek_oncesi_gelir_vergisi_matrah + onceki_ay_kumulatif_gelir_vergisi_matrah;
			s1 = get_active_tax_slice.MAX_PAYMENT_1;	v1 = get_active_tax_slice.RATIO_1 / 100;
			s2 = get_active_tax_slice.MAX_PAYMENT_2;	v2 = get_active_tax_slice.RATIO_2 / 100;
			s3 = get_active_tax_slice.MAX_PAYMENT_3;	v3 = get_active_tax_slice.RATIO_3 / 100;
			s4 = get_active_tax_slice.MAX_PAYMENT_4;	v4 = get_active_tax_slice.RATIO_4 / 100;
			
				if(this_kontrol lt s1)
					{
					gelir_vergisi_dusen = burada_gelir_vergisi_matrah * tax_carpan;
					}
				else if(this_kontrol_2 lt s1 and this_kontrol gt s1 and this_kontrol lt s2)
					{
					ilk_kisim_ =  (burada_gelir_vergisi_matrah - (this_kontrol - s1)) * v1;
					ikinci_kisim_ = (this_kontrol - s1) * v2;
					gelir_vergisi_dusen = ilk_kisim_ + ikinci_kisim_;
					}
				else if(this_kontrol_2 lt s2 and this_kontrol gt s2 and this_kontrol lt s3)
					{
					ilk_kisim_ =  (burada_gelir_vergisi_matrah - (this_kontrol - s2)) * v2;
					ikinci_kisim_ = (this_kontrol - s2) * v3;
					gelir_vergisi_dusen = ilk_kisim_ + ikinci_kisim_;
					}
				else if(this_kontrol_2 lt s3 and this_kontrol gt s3 and this_kontrol lt s4)
					{
					ilk_kisim_ =  (burada_gelir_vergisi_matrah - (this_kontrol - s3)) * v3;
					ikinci_kisim_ = (this_kontrol - s3) * v4;
					gelir_vergisi_dusen = ilk_kisim_ + ikinci_kisim_;
					}
				else if(this_kontrol_2 lt s4 and this_kontrol gt s4)
					{
					ilk_kisim_ =  (burada_gelir_vergisi_matrah - (this_kontrol - s4)) * v4;
					ikinci_kisim_ = (this_kontrol - s4) * v5;
					gelir_vergisi_dusen = ilk_kisim_ + ikinci_kisim_;
					}
				else
					gelir_vergisi_dusen = burada_gelir_vergisi_matrah * tax_carpan;
			
			damga_vergisi_dusen = wrk_round(first_eklenecek * (get_active_program_parameter.STAMP_TAX_BINDE / 1000));
			first_net = first_brut - damga_vergisi_dusen - gelir_vergisi_dusen;
			if(first_net gt tutar_)
			{
				flag = true;
				count = 0;
				kumulatif_gelir = onceki_ay_kumulatif_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah;
				salary = brut_total_pay_ssk_tax_net;//20050925 simdilik bu sekilde, saatlik ve gunluk calisanlar icin bakilabilir
				sal_temp = tutar_;			
				salary_ilk = salary;
				while(flag)
					{
					count = count + 1;
					kontrol = salary;
					gelir_vergisi_matrah = kontrol;
					include 'get_hr_compass_tax.cfm';
					include 'get_hr_compass_formuls.cfm';
					include 'get_hr_compass_from_net.cfm';
					if (count gte 60 or sal_temp eq wrk_round(net_ucret) or sal_temp eq net_ucret)
						flag = false;
					else if (net_ucret gt sal_temp)
						salary = kontrol - (net_ucret - sal_temp);
					else if (net_ucret lt sal_temp)
						salary = kontrol + (sal_temp - net_ucret);
					}
				//abort('salary:#salary# net_ucret:#net_ucret#-- ilk_salary/ilk_sal_temp :#ilk_salary#-#ilk_sal_temp# - brut_total_pay_ssk_tax_net:#brut_total_pay_ssk_tax_net#');
				odenek_oncesi_gelir_vergisi_matrah = odenek_oncesi_gelir_vergisi_matrah + gelir_vergisi_matrah;
				odenek_oncesi_gelir_vergisi = odenek_oncesi_gelir_vergisi + gelir_vergisi;
				odenek_oncesi_damga_vergisi = odenek_oncesi_damga_vergisi + damga_vergisi;
				total_pay_ssk_tax = total_pay_ssk_tax + salary;	
				eklenen = salary;
			}
			else
			{
				if(first_net lt 0) first_net = 0;
				ikinci_net = tutar_ - first_net;
							
				flag = true;
				count = 0;
				kumulatif_gelir = onceki_ay_kumulatif_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah + burada_gelir_vergisi_matrah;
				salary = ikinci_net;//20050925 simdilik bu sekilde, saatlik ve gunluk calisanlar icin bakilabilir
				sal_temp = salary;
				salary_ilk = salary;
				while(flag)
					{
					count = count + 1;
					kontrol = salary;
					gelir_vergisi_matrah = kontrol;
					include 'get_hr_compass_tax.cfm';
					damga_vergisi_ = ((salary) * get_active_program_parameter.STAMP_TAX_BINDE ) / 1000;
					toplam_kesinti = (gelir_vergisi-(vergi_matraha_dahil_olmayan_odenek_tutar*tax_carpan)) + damga_vergisi_;
					net_ucret = salary - toplam_kesinti; 
					if (count gte 58 or sal_temp eq wrk_round(net_ucret) or sal_temp eq net_ucret)
						flag = false;
					else if (net_ucret gt sal_temp)
						salary = kontrol - (net_ucret - sal_temp);
					else if (net_ucret lt sal_temp)
						salary = kontrol + (sal_temp - net_ucret);
						
					}
				odenek_oncesi_gelir_vergisi_matrah = odenek_oncesi_gelir_vergisi_matrah + gelir_vergisi_matrah + burada_gelir_vergisi_matrah;
				odenek_oncesi_gelir_vergisi = odenek_oncesi_gelir_vergisi + gelir_vergisi + gelir_vergisi_dusen;
				odenek_oncesi_damga_vergisi = odenek_oncesi_damga_vergisi + damga_vergisi + damga_vergisi_dusen;
				total_pay_ssk_tax = total_pay_ssk_tax + salary + first_eklenecek;
				eklenen = salary + first_eklenecek;
			}
		}
			this_oran = eklenen  / ilk_net;
			for (i=1; i lte arraylen(puantaj_exts); i = i+1){
				if(puantaj_exts[i][6] eq 0 and puantaj_exts[i][9] eq 0)//net odenekler
					if(puantaj_exts[i][4] eq 2 and puantaj_exts[i][5] eq 2 and (puantaj_exts[i][13] eq 1 or (is_not_stamp eq 1 and puantaj_exts[i][13] eq 0)) and puantaj_exts[i][14] eq 1){//sadece vergi dahil olanlar veri carpani ile buyutulecek
						puantaj_exts[i][3] = puantaj_exts[i][3] * this_oran;
						puantaj_exts[i][8] = puantaj_exts[i][8] * this_oran;
						//sgk muafiyeti var ise  //SG 20151222
						if(len(puantaj_exts[i][36]) and len(puantaj_exts[i][37])) //sgk muafiyet oranı ve sgk muafiyet tipi
						{
							if(puantaj_exts[i][37] eq 0) //muafiyet tipi Asgari Ücrete Göre
								{
								_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL * puantaj_exts[i][36] / 100;
								if(_tutar gt puantaj_exts[i][3])
									_tutar = puantaj_exts[i][3];
								}
							else if(puantaj_exts[i][37] eq 1) // muafiyet tipi Tutara Göre
								_tutar = puantaj_exts[i][3] * puantaj_exts[i][36] / 100;
							else if(puantaj_exts[i][37] eq 2) //muafiyet tipi Günlük Asgari Ücrete Göre
							{
								if(puantaj_exts[i][7] eq 1)//güne göre
									_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * ssk_days;
								else if(get_pay_salary.calc_days[i] eq 2)//fiili güne göre
									_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * fiili_gun_;
								else
									_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * puantaj_exts[i][15];
							}
							ssk_matraha_dahil_olmayan_net_odenek_tutar = ssk_matraha_dahil_olmayan_net_odenek_tutar + _tutar;
							
							if(arraylen(puantaj_exts[i]) gte 40 and len(puantaj_exts[i][40]))
							{
								if(puantaj_exts[i][40] gt puantaj_exts[i][3])
								puantaj_exts[i][40] = puantaj_exts[i][3];
								
								eski_tutar_ = puantaj_exts[i][40];
								if(_tutar gt eski_tutar_)
									ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + (_tutar - eski_tutar_);

								if(eski_tutar_ gt eklenen)
								puantaj_exts[i][40] = eklenen;
							}
						}
						

						
						
						if(arraylen(puantaj_exts[i]) gte 38 and len(puantaj_exts[i][38]))
						{
							_tutar = puantaj_exts[i][8] * puantaj_exts[i][38];
							vergi_matraha_dahil_olmayan_net_odenek_tutar = vergi_matraha_dahil_olmayan_net_odenek_tutar + _tutar;
						}
						
						if(arraylen(puantaj_exts[i]) gte 39 and len(puantaj_exts[i][39]))
						{
							_tutar =  puantaj_exts[i][39];
							if(_tutar gt puantaj_exts[i][3])
							{
								_tutar = puantaj_exts[i][3];
							}
							
							eski_tutar_ = puantaj_exts[i][41];
							
							if(_tutar gt eski_tutar_)
								vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + (_tutar - eski_tutar_);
							
							vergi_matraha_dahil_olmayan_net_odenek_tutar = vergi_matraha_dahil_olmayan_net_odenek_tutar + _tutar;
						}
						
						
						puantaj_exts[i][9] = 1;//artik brut oldu

						/*
						if(puantaj_exts[i][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i][3];
						}
						*/
					}
				}				
		}
	</cfscript>
<cfelseif is_tax_ eq 1 and is_ssk_ eq 0>
	<cfscript>
		include 'get_hr_compass_2022.cfm';
		flag = true;
		count = 0;
		kumulatif_gelir = onceki_ay_kumulatif_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah;
		salary = tutar_;//20050925 simdilik bu sekilde, saatlik ve gunluk calisanlar icin bakilabilir
		sal_temp = salary;
		salary_ilk = salary;
		net_total_brut = salary;
		while(flag)
		{
			count = count + 1;
			kontrol = salary;
			gelir_vergisi_matrah = kontrol;
			include 'get_hr_compass_tax.cfm';
			damga_vergisi_ = ((salary) * get_active_program_parameter.STAMP_TAX_BINDE ) / 1000;
			
			if(year(last_month_1) gte 2022 and (damga_vergisi_ gte daily_minimum_wage_stamp_tax) and use_ssk neq 2)
			{
				damga_vergisi_ = damga_vergisi_ - daily_minimum_wage_stamp_tax;
			}
			else if(year(last_month_1) gte 2022 and wrk_round(salary) lte wrk_round(daily_minimum_wage) and use_ssk neq 2)
				damga_vergisi_ = 0;	
				
			toplam_kesinti = gelir_vergisi + damga_vergisi_;
			net_ucret = salary - toplam_kesinti; 
			
			if (count gte 60 or sal_temp eq wrk_round(net_ucret) or sal_temp eq net_ucret)
				flag = false;
			else if (net_ucret gt sal_temp)
				salary = kontrol - (net_ucret - sal_temp);
			else if (net_ucret lt sal_temp)
				salary = kontrol + (sal_temp - net_ucret);
		}
			
		if(wrk_round(sal_temp,8) gt wrk_round(net_ucret,8))
		{
			salary = wrk_round(salary + 0.01);
		}
		//abort('salary:#salary# sal-temp.#sal_temp# salary:#salary# #net_ucret# #wrk_round(sal_temp - net_ucret)# #wrk_round(net_ucret)#');
		
		odenek_oncesi_gelir_vergisi_matrah = odenek_oncesi_gelir_vergisi_matrah + gelir_vergisi_matrah;
		odenek_oncesi_gelir_vergisi = odenek_oncesi_gelir_vergisi + gelir_vergisi;
		odenek_oncesi_damga_vergisi = odenek_oncesi_damga_vergisi + damga_vergisi_;
		total_pay_tax = total_pay_tax + salary;
		this_ek_ucret_gelir = gelir_vergisi;
		this_ek_ucret_damga = damga_vergisi_;
		
		THIS_EK_UCRET_ISVEREN = 0;
		eklenen = salary;
		this_oran = salary / tutar_;
		for (i=1; i lte arraylen(puantaj_exts); i = i+1){
			if(puantaj_exts[i][6] eq 0 and puantaj_exts[i][9] eq 0)//net odenekler
			{
				if(puantaj_exts[i][4] eq 1 and puantaj_exts[i][5] eq 2 and puantaj_exts[i][13] eq 1 and puantaj_exts[i][14] eq 0){//sadece vergi dahil olanlar veri carpani ile buyutulecek
					puantaj_exts[i][3] = wrk_round(puantaj_exts[i][3] * this_oran);
					//sgk muafiyeti var ise  //SG 20151222
					if(len(puantaj_exts[i][36]) and len(puantaj_exts[i][37])) //sgk muafiyet oranı ve sgk muafiyet tipi
					{
						if(puantaj_exts[i][37] eq 0) //muafiyet tipi Asgari Ücrete Göre
							{
							_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL * puantaj_exts[i][36] / 100;
							if(_tutar gt puantaj_exts[i][3])
								_tutar = puantaj_exts[i][3];
							}
						else if(puantaj_exts[i][37] eq 1) // muafiyet tipi Tutara Göre
							_tutar = puantaj_exts[i][3] * puantaj_exts[i][36] / 100;
						else if(puantaj_exts[i][37] eq 2) //muafiyet tipi Günlük Asgari Ücrete Göre
						{
							if(puantaj_exts[i][7] eq 1)//güne göre
								_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * ssk_days;
							else if(get_pay_salary.calc_days[i] eq 2)//fiili güne göre
								_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * fiili_gun_;
							else
								_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * puantaj_exts[i][15];
						}
						ssk_matraha_dahil_olmayan_net_odenek_tutar = ssk_matraha_dahil_olmayan_net_odenek_tutar + _tutar;
					}
					puantaj_exts[i][9] = 1;//artik brut oldu
					
					if(puantaj_exts[i][43] eq 1)
					{
						rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
						
						if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
						{
							puantaj_exts[i][46] = this_ek_ucret_gelir * 80 / 100;
						}
						if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
						{
							puantaj_exts[i][46] = this_ek_ucret_gelir * 90 / 100;
						}
						if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
						{
							puantaj_exts[i][46] = this_ek_ucret_gelir * 95 / 100;
						}
						if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
						{
							puantaj_exts[i][46] = this_ek_ucret_gelir;
						}
					}
					else
					{
						rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
					}
					if(puantaj_exts[i][42] eq 1)
					{
						rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
						
						if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
						{
							puantaj_exts[i][45] = this_ek_ucret_damga * 80 / 100;
						}
						if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
						{
							puantaj_exts[i][45] = this_ek_ucret_damga * 90 / 100;
						}
						if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
						{
							puantaj_exts[i][45] = this_ek_ucret_damga * 95 / 100;
						}
						if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
						{
							puantaj_exts[i][45] = this_ek_ucret_damga;
						}
					}
					else
					{
						rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
					}
					
					if(puantaj_exts[i][44] eq 1)
					{
						rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
						if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
						{
							puantaj_exts[i][47] = this_ek_ucret_isveren * 80 / 100;
						}
						if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
						{
							puantaj_exts[i][47] = this_ek_ucret_isveren * 90 / 100;
						}
						if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
						{
							puantaj_exts[i][47] = this_ek_ucret_isveren * 95 / 100;
						}
						if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
						{
							puantaj_exts[i][47] = this_ek_ucret_isveren;
						}
					}
					else
					{
						rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
						if(this_ek_ucret_isveren gt 0)
							rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i][3];
					}
				}
			}
		}
	</cfscript>
<cfelseif is_tax_ eq 1 and is_ssk_ eq 1 and isdefined("is_issizlik_") and is_issizlik_ eq 0>
	<cfscript>
		include 'get_hr_compass_2022.cfm';
		issizlik_isci_carpan_ilk = issizlik_isci_carpan;
		issizlik_isci_carpan = 0;
		
		if(total_pay_ssk_tax_net_noissizlik gt 0)
		{
		ilk_net = total_pay_ssk_tax_net_noissizlik;
		if(ssk_days) 
			brut_total_pay_ssk_tax_net = total_pay_ssk_tax_net_noissizlik * (ilk_salary_temp/ilk_sal_temp);
		else
			brut_total_pay_ssk_tax_net = total_pay_ssk_tax_net_noissizlik;

		net_total_brut = ilk_salary + brut_total_pay_ssk_tax_net;
		if(ilk_salary gt ssk_matrah_tavan) // dogrulandi
			{//brut ucret tavandan buyukse
				flag = true;
				count = 0;
				kumulatif_gelir = onceki_ay_kumulatif_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah;
				salary = tutar_;//20050925 simdilik bu sekilde, saatlik ve gunluk calisanlar icin bakilabilir
				sal_temp = salary;
				salary_ilk = salary;
				while(flag)
					{
					count = count + 1;
					kontrol = salary;
					gelir_vergisi_matrah = kontrol;
					include 'get_hr_compass_tax.cfm';
					damga_vergisi_ = ((salary) * get_active_program_parameter.STAMP_TAX_BINDE ) / 1000;
					toplam_kesinti = gelir_vergisi + damga_vergisi_;
					net_ucret = salary - toplam_kesinti; 
					if (count gte 58 or sal_temp eq wrk_round(net_ucret) or sal_temp eq net_ucret)
						flag = false;
					else if (net_ucret gt sal_temp)
						salary = kontrol - (net_ucret - sal_temp);
					else if (net_ucret lt sal_temp)
						salary = kontrol + (sal_temp - net_ucret);
					}
					odenek_oncesi_gelir_vergisi_matrah = odenek_oncesi_gelir_vergisi_matrah + gelir_vergisi_matrah;
					odenek_oncesi_gelir_vergisi = odenek_oncesi_gelir_vergisi + gelir_vergisi;
					odenek_oncesi_damga_vergisi = odenek_oncesi_damga_vergisi + damga_vergisi;
					total_pay_ssk_tax_noissizlik = total_pay_ssk_tax_noissizlik + salary;
					eklenen = salary;
			}
		else if(ilk_salary+brut_total_pay_ssk_tax_net lte ssk_matrah_tavan)	  // dogrulandi
			{//brut ucret ve sadece hem ssk hem vergi dahil odenekler toplami tavandan kucukse
				flag = true;
				count = 0;
				kumulatif_gelir = onceki_ay_kumulatif_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah;
				salary = tutar_;//20050925 simdilik bu sekilde, saatlik ve gunluk calisanlar icin bakilabilir
				sal_temp = salary;
				salary_ilk = salary;
				while(flag)
					{
					count = count + 1;
					kontrol = salary;
					gelir_vergisi_matrah = kontrol;
					include 'get_hr_compass_tax.cfm';
					damga_vergisi_ = ((salary) * get_active_program_parameter.STAMP_TAX_BINDE ) / 1000;
					toplam_kesinti = gelir_vergisi + damga_vergisi_;
					net_ucret = salary - toplam_kesinti; 
					if (count gte 60 or sal_temp eq wrk_round(net_ucret) or sal_temp eq net_ucret)
						flag = false;
					else if (net_ucret gt sal_temp)
						salary = kontrol - (net_ucret - sal_temp);
					else if (net_ucret lt sal_temp)
						salary = kontrol + (sal_temp - net_ucret);
					}
				odenek_oncesi_gelir_vergisi_matrah = odenek_oncesi_gelir_vergisi_matrah + gelir_vergisi_matrah;
				odenek_oncesi_gelir_vergisi = odenek_oncesi_gelir_vergisi + gelir_vergisi;
				odenek_oncesi_damga_vergisi = odenek_oncesi_damga_vergisi + damga_vergisi;
				total_pay_ssk_tax_noissizlik = total_pay_ssk_tax_noissizlik + salary;	
				eklenen = salary;
			}
		else if(ilk_salary+brut_total_pay_ssk_tax_net gt ssk_matrah_tavan)	
			{
			first_brut = ssk_matrah_tavan - ilk_salary;
			first_eklenecek = first_brut;
			isci_payi = wrk_round(first_brut *  (ssk_isci_carpan/100));
			issizlik_payi = wrk_round(first_brut * (issizlik_isci_carpan / 100));
			burada_gelir_vergisi_matrah = first_brut - isci_payi - issizlik_payi;
			first_brut = first_brut - isci_payi - issizlik_payi;
			
			this_kontrol = burada_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah + onceki_ay_kumulatif_gelir_vergisi_matrah;
			this_kontrol_2 = odenek_oncesi_gelir_vergisi_matrah + onceki_ay_kumulatif_gelir_vergisi_matrah;
			s1 = get_active_tax_slice.MAX_PAYMENT_1;	v1 = get_active_tax_slice.RATIO_1 / 100;
			s2 = get_active_tax_slice.MAX_PAYMENT_2;	v2 = get_active_tax_slice.RATIO_2 / 100;
			s3 = get_active_tax_slice.MAX_PAYMENT_3;	v3 = get_active_tax_slice.RATIO_3 / 100;
			s4 = get_active_tax_slice.MAX_PAYMENT_4;	v4 = get_active_tax_slice.RATIO_4 / 100;
			
				if(this_kontrol lt s1)
					{
					gelir_vergisi_dusen = burada_gelir_vergisi_matrah * tax_carpan;
					}
				else if(this_kontrol_2 lt s1 and this_kontrol gt s1 and this_kontrol lt s2)
					{
					ilk_kisim_ =  (burada_gelir_vergisi_matrah - (this_kontrol - s1)) * v1;
					ikinci_kisim_ = (this_kontrol - s1) * v2;
					gelir_vergisi_dusen = ilk_kisim_ + ikinci_kisim_;
					}
				else if(this_kontrol_2 lt s2 and this_kontrol gt s2 and this_kontrol lt s3)
					{
					ilk_kisim_ =  (burada_gelir_vergisi_matrah - (this_kontrol - s2)) * v2;
					ikinci_kisim_ = (this_kontrol - s2) * v3;
					gelir_vergisi_dusen = ilk_kisim_ + ikinci_kisim_;
					}
				else if(this_kontrol_2 lt s3 and this_kontrol gt s3 and this_kontrol lt s4)
					{
					ilk_kisim_ =  (burada_gelir_vergisi_matrah - (this_kontrol - s3)) * v3;
					ikinci_kisim_ = (this_kontrol - s3) * v4;
					gelir_vergisi_dusen = ilk_kisim_ + ikinci_kisim_;
					}
				else if(this_kontrol_2 lt s4 and this_kontrol gt s4)
					{
					ilk_kisim_ =  (burada_gelir_vergisi_matrah - (this_kontrol - s4)) * v4;
					ikinci_kisim_ = (this_kontrol - s4) * v5;
					gelir_vergisi_dusen = ilk_kisim_ + ikinci_kisim_;
					}
				else
					gelir_vergisi_dusen = burada_gelir_vergisi_matrah * tax_carpan;
			
			damga_vergisi_dusen = wrk_round(first_eklenecek * (get_active_program_parameter.STAMP_TAX_BINDE / 1000));
			first_net = first_brut - damga_vergisi_dusen - gelir_vergisi_dusen;
			ikinci_net = tutar_ - first_net;
							
				flag = true;
				count = 0;
				kumulatif_gelir = onceki_ay_kumulatif_gelir_vergisi_matrah + odenek_oncesi_gelir_vergisi_matrah + burada_gelir_vergisi_matrah;
				salary = ikinci_net;//20050925 simdilik bu sekilde, saatlik ve gunluk calisanlar icin bakilabilir
				sal_temp = salary;
				salary_ilk = salary;
				while(flag)
					{
					count = count + 1;
					kontrol = salary;
					gelir_vergisi_matrah = kontrol;
					include 'get_hr_compass_tax.cfm';
					damga_vergisi_ = ((salary) * get_active_program_parameter.STAMP_TAX_BINDE ) / 1000;
					toplam_kesinti = gelir_vergisi + damga_vergisi_;
					net_ucret = salary - toplam_kesinti; 
					if (count gte 58 or sal_temp eq wrk_round(net_ucret) or sal_temp eq net_ucret)
						flag = false;
					else if (net_ucret gt sal_temp)
						salary = kontrol - (net_ucret - sal_temp);
					else if (net_ucret lt sal_temp)
						salary = kontrol + (sal_temp - net_ucret);
						
					}
				odenek_oncesi_gelir_vergisi_matrah = odenek_oncesi_gelir_vergisi_matrah + gelir_vergisi_matrah + burada_gelir_vergisi_matrah;
				odenek_oncesi_gelir_vergisi = odenek_oncesi_gelir_vergisi + gelir_vergisi + gelir_vergisi_dusen;
				odenek_oncesi_damga_vergisi = odenek_oncesi_damga_vergisi + damga_vergisi + damga_vergisi_dusen;
				total_pay_ssk_tax_noissizlik = total_pay_ssk_tax_noissizlik + salary + first_eklenecek;
				eklenen = salary + first_eklenecek;
			}
			this_oran = eklenen  / ilk_net;
			for (i=1; i lte arraylen(puantaj_exts); i = i+1){
				if(puantaj_exts[i][6] eq 0 and puantaj_exts[i][9] eq 0)//net odenekler
					if(puantaj_exts[i][4] eq 2 and puantaj_exts[i][5] eq 2 and puantaj_exts[i][13] eq 1 and puantaj_exts[i][14] eq 0){//sadece vergi dahil olanlar veri carpani ile buyutulecek
						puantaj_exts[i][3] = puantaj_exts[i][3] * this_oran;
						//sgk muafiyeti var ise  //SG 20151222
						if(len(puantaj_exts[i][36]) and len(puantaj_exts[i][37])) //sgk muafiyet oranı ve sgk muafiyet tipi
						{
							if(puantaj_exts[i][37] eq 0) //muafiyet tipi Asgari Ücrete Göre
								{
								_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL * puantaj_exts[i][36] / 100;
								if(_tutar gt puantaj_exts[i][3])
									_tutar = puantaj_exts[i][3];
								}
							else if(puantaj_exts[i][37] eq 1) // muafiyet tipi Tutara Göre
								_tutar = puantaj_exts[i][3] * puantaj_exts[i][36] / 100;
							else if(puantaj_exts[i][37] eq 2) //muafiyet tipi Günlük Asgari Ücrete Göre
							{
								if(puantaj_exts[i][7] eq 1)//güne göre
									_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * ssk_days;
								else if(get_pay_salary.calc_days[i] eq 2)//fiili güne göre
									_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * fiili_gun_;
								else
									_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * puantaj_exts[i][15];
							}
							ssk_matraha_dahil_olmayan_net_odenek_tutar = ssk_matraha_dahil_olmayan_net_odenek_tutar + _tutar;
						}
						puantaj_exts[i][9] = 1;//artik brut oldu
						}
				}
				
		}
		issizlik_isci_carpan = issizlik_isci_carpan_ilk;
	</cfscript>
<cfelseif is_tax_ eq 0 and is_ssk_ eq 1 and isdefined("is_issizlik_") and is_issizlik_ eq 0>
	<cfscript>
		include 'get_hr_compass_2022.cfm';
		total_pay_ssk_noissizlik_ssk_isci_pay = tutar_ * ssk_isci_carpan / 100;
		total_pay_ssk_noissizlik_eklenen = total_pay_ssk_noissizlik_ssk_isci_pay;
		eklenen = tutar_ + total_pay_ssk_noissizlik_eklenen;
		total_pay_ssk_noissizlik = total_pay_ssk_noissizlik + eklenen;
		
		this_oran = eklenen  / tutar_;
		
			for (i=1; i lte arraylen(puantaj_exts); i = i+1){
				if(puantaj_exts[i][6] eq 0 and puantaj_exts[i][9] eq 0)//net odenekler
					if(puantaj_exts[i][4] eq 2 and puantaj_exts[i][5] eq 1 and puantaj_exts[i][13] eq 0 and puantaj_exts[i][14] eq 0)
						{
						puantaj_exts[i][3] = puantaj_exts[i][3] * this_oran;
						//sgk muafiyeti var ise  //SG 20151222
						if(len(puantaj_exts[i][36]) and len(puantaj_exts[i][37])) //sgk muafiyet oranı ve sgk muafiyet tipi
						{
							if(puantaj_exts[i][37] eq 0) //muafiyet tipi Asgari Ücrete Göre
								{
								_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL * puantaj_exts[i][36] / 100;
								if(_tutar gt puantaj_exts[i][3])
									_tutar = puantaj_exts[i][3];
								}
							else if(puantaj_exts[i][37] eq 1) // muafiyet tipi Tutara Göre
								_tutar = puantaj_exts[i][3] * puantaj_exts[i][36] / 100;
							else if(puantaj_exts[i][37] eq 2) //muafiyet tipi Günlük Asgari Ücrete Göre
							{
								if(puantaj_exts[i][7] eq 1)//güne göre
									_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * ssk_days;
								else if(get_pay_salary.calc_days[i] eq 2)//fiili güne göre
									_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * fiili_gun_;
								else
									_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * puantaj_exts[i][15];
							}
							ssk_matraha_dahil_olmayan_net_odenek_tutar = ssk_matraha_dahil_olmayan_net_odenek_tutar + _tutar;
						}
						puantaj_exts[i][9] = 1;//artik brut oldu
						}
				}
	</cfscript>
<cfelseif is_tax_ eq 0 and is_ssk_ eq 1 and isdefined("is_issizlik_") and is_issizlik_ eq 1 and isdefined("is_damga_") and is_damga_ eq 0>
	<cfscript>
		include 'get_hr_compass_2022.cfm';
        salary = wrk_round(tutar_);//20050925 simdilik bu sekilde, saatlik ve gunluk calisanlar icin bakilabilir
        sal_temp = salary;
        salary_brut_temp = sal_temp;
        this_tax_ratio = 0;
        {
        if(devir_matrah_ gt ssk_matrah_tavan)
            {
            brut = salary;
            salary = brut / (1 - (get_active_program_parameter.STAMP_TAX_BINDE / 1000));
            }
        else if((salary_brut_temp + devir_matrah_) gt ssk_matrah_tavan)
        {
           /*  ssk_isci_hissesi = wrk_round((ssk_matrah_tavan/100) * ssk_isci_carpan);
            issizlik_isci_hissesi = wrk_round((ssk_matrah_tavan/100) * issizlik_isci_carpan);
            brut = salary + (ssk_isci_hissesi+issizlik_isci_hissesi) - ((ssk_isci_hissesi+issizlik_isci_hissesi) * this_tax_ratio) - ((sakatlik_indirimi + vergi_istisna) * this_tax_ratio);
            salary = brut / (1 - (get_active_program_parameter.STAMP_TAX_BINDE / 1000) - this_tax_ratio);
            
            bes_isci_hissesi = fix((ssk_matrah_tavan/100) * bes_isci_carpan); */
			first_brut = ssk_matrah_tavan - ilk_salary;
			first_eklenecek = first_brut;
			isci_payi = wrk_round(first_brut *  (ssk_isci_carpan/100));
			issizlik_payi = wrk_round(first_brut * (issizlik_isci_carpan / 100));
			first_brut = first_brut - isci_payi - issizlik_payi;
			first_net = first_brut;
			if(first_net gt tutar_)
			{
				ssk_isci_hissesi = wrk_round((tutar_/100) * ssk_isci_carpan);
				bes_isci_hissesi = fix((tutar_/100) * bes_isci_carpan);
				issizlik_isci_hissesi = wrk_round((tutar_/100) * issizlik_isci_carpan);
				salary = tutar_ + (ssk_isci_hissesi+issizlik_isci_hissesi);
				eklenen = salary;
			}
			else
			{
				ikinci_net = tutar_ - first_net;
				ssk_isci_hissesi = wrk_round((ikinci_net/100) * ssk_isci_carpan);
				bes_isci_hissesi = fix((ikinci_net/100) * bes_isci_carpan);
				issizlik_isci_hissesi = wrk_round((ikinci_net/100) * issizlik_isci_carpan);
				salary = ikinci_net;
				salary = salary + first_eklenecek;
				eklenen = salary;
			}
        }
        else if((salary_brut_temp + devir_matrah_) lt ssk_matrah_taban)
            {
            ssk_isci_hissesi = wrk_round((ssk_matrah_taban/100) * ssk_isci_carpan);
            issizlik_isci_hissesi = wrk_round((ssk_matrah_taban/100) * issizlik_isci_carpan);
            brut = salary + (ssk_isci_hissesi+issizlik_isci_hissesi) - ((ssk_isci_hissesi + issizlik_isci_hissesi + sakatlik_indirimi + vergi_istisna) * this_tax_ratio);
            a = 1 - ((issizlik_isci_carpan + ssk_isci_carpan)/100);
            salary = brut / (a - (get_active_program_parameter.STAMP_TAX_BINDE / 1000));
            
            bes_isci_hissesi = fix((ssk_matrah_taban/100) * bes_isci_carpan);
            }
        else
            {
            ssk_isci_hissesi = (salary/100) * ssk_isci_carpan;
            issizlik_isci_hissesi = (salary/100) * issizlik_isci_carpan;
            brut = salary;
            a = 1 - ((issizlik_isci_carpan + ssk_isci_carpan)/100);	
            salary = brut / (a);
            
            bes_isci_hissesi = fix((salary/100) * bes_isci_carpan);
            }
        }
        
        eklenen = salary;
        /*
        if(eklenen gt 25)
            eklenen = eklenen + 0.04 + (((eklenen / 25) - 1) * 0.03);
        else
            eklenen = eklenen + 0.03;
        */		
        //total_pay_ssk = 26.81;
        total_pay_ssk = eklenen;
		total_pay_unstamped = total_pay_unstamped + total_pay_ssk;
        this_oran = eklenen / tutar_;
            
                for (i=1; i lte arraylen(puantaj_exts); i = i+1){
                    if(puantaj_exts[i][6] eq 0 and puantaj_exts[i][9] eq 0)//net odenekler
                        if(puantaj_exts[i][4] eq 2 and puantaj_exts[i][5] eq 1 and puantaj_exts[i][13] eq 0 and puantaj_exts[i][14] eq 1)
                            {
                            puantaj_exts[i][3] = puantaj_exts[i][3] * this_oran;
                            //sgk muafiyeti var ise  //SG 20151222
                            if(len(puantaj_exts[i][36]) and len(puantaj_exts[i][37])) //sgk muafiyet oranı ve sgk muafiyet tipi
							{
								if(puantaj_exts[i][37] eq 0) //muafiyet tipi Asgari Ücrete Göre
               					{
                                    _tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL * puantaj_exts[i][36] / 100;
                                    if(_tutar gt puantaj_exts[i][3])
                                        _tutar = puantaj_exts[i][3];
                                    }
                                else if(puantaj_exts[i][37] eq 1) // muafiyet tipi Tutara Göre
                                    _tutar = puantaj_exts[i][3] * puantaj_exts[i][36] / 100;
                                else if(puantaj_exts[i][37] eq 2) //muafiyet tipi Günlük Asgari Ücrete Göre
                                {
                                    if(puantaj_exts[i][7] eq 1)//güne göre
                                        _tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * ssk_days;
                                    else if(get_pay_salary.calc_days[i] eq 2)//fiili güne göre
                                        _tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * fiili_gun_;
                                    else
                                        _tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * puantaj_exts[i][15];
                                }
                                ssk_matraha_dahil_olmayan_net_odenek_tutar = ssk_matraha_dahil_olmayan_net_odenek_tutar + _tutar;
                            }
							puantaj_exts[i][9] = 1;//artik brut oldu
							}
						}
    </cfscript>
<cfelseif is_tax_ eq 0 and is_ssk_ eq 1 and isdefined("is_issizlik_") and is_issizlik_ eq 1>
	<cfscript>
		include 'get_hr_compass_2022.cfm';
		if(tutar_ gt 0)
		{
			ilk_net = tutar_;
			if(get_hr_salary.gross_net eq 0 and total_pay_ssk_tax gt 0)
				baz_deger_ = ilk_salary + total_pay_ssk_tax;
			else
				baz_deger_ = ilk_salary;
				
			if(get_hr_salary.gross_net eq 0)
				{
					ilk_sal_temp = ilk_salary - (ilk_salary * 30 /100);
				}
			
			if(ssk_days and baz_deger_) 
				brut_total_pay_ssk_tax_net_ = tutar_ * wrk_round(ilk_salary/ilk_sal_temp,5);
			else
				brut_total_pay_ssk_tax_net_ = tutar_;
			if(baz_deger_ gt ssk_matrah_tavan) // dogrulandi
			{//brut ucret tavandan buyukse
				salary = tutar_ / (1 - (get_active_program_parameter.STAMP_TAX_BINDE / 1000));
				eklenen = salary;
			}
			else if(baz_deger_+brut_total_pay_ssk_tax_net_ lte ssk_matrah_tavan)	  // dogrulandi
			{//brut ucret ve sadece hem ssk hem vergi dahil odenekler toplami tavandan kucukse
				salary = tutar_;//20050925 simdilik bu sekilde, saatlik ve gunluk calisanlar icin bakilabilir
				sal_temp = salary;
				flag = true;
				count = 0;
				while(flag)
					{
					count = count + 1;
					kontrol = salary;
					damga_vergisi_ = ((salary) * get_active_program_parameter.STAMP_TAX_BINDE ) / 1000;
					isci_payi = wrk_round(salary *  (ssk_isci_carpan/100));
					issizlik_payi = wrk_round(salary * (issizlik_isci_carpan / 100));
					net_ucret = salary - damga_vergisi_ - issizlik_payi - isci_payi; 
					if (count gte 60 or sal_temp eq wrk_round(net_ucret) or sal_temp eq net_ucret)
						flag = false;
					else if (net_ucret gt sal_temp)
						salary = kontrol - (net_ucret - sal_temp);
					else if (net_ucret lt sal_temp)
						salary = kontrol + (sal_temp - net_ucret);
					}
				eklenen = salary;
			}
			else if(baz_deger_+brut_total_pay_ssk_tax_net_ gt ssk_matrah_tavan)	
			{
				first_brut = ssk_matrah_tavan - ilk_salary;
				first_eklenecek = first_brut;
				isci_payi = wrk_round(first_brut *  (ssk_isci_carpan/100));
				issizlik_payi = wrk_round(first_brut * (issizlik_isci_carpan / 100));
				first_brut = first_brut - isci_payi - issizlik_payi;
				damga_vergisi_dusen = wrk_round(first_eklenecek * (get_active_program_parameter.STAMP_TAX_BINDE / 1000));
				first_net = first_brut - damga_vergisi_dusen;
				if(first_net gt tutar_)
				{
					ssk_isci_hissesi = wrk_round((tutar_/100) * ssk_isci_carpan);
					bes_isci_hissesi = fix((tutar_/100) * bes_isci_carpan);
					issizlik_isci_hissesi = wrk_round((tutar_/100) * issizlik_isci_carpan);
					salary = tutar_ + (ssk_isci_hissesi+issizlik_isci_hissesi);
					eklenen = salary;
				}
				else
				{
					ikinci_net = tutar_ - first_net;
					ssk_isci_hissesi = wrk_round((ikinci_net/100) * ssk_isci_carpan);
					bes_isci_hissesi = fix((ikinci_net/100) * bes_isci_carpan);
					issizlik_isci_hissesi = wrk_round((ikinci_net/100) * issizlik_isci_carpan);
					salary = ikinci_net;
					salary = salary / (1 - (get_active_program_parameter.STAMP_TAX_BINDE / 1000));
					salary = salary + first_eklenecek;
					eklenen = salary;
				}
			}
			total_pay_ssk = eklenen;
			this_oran = eklenen  / ilk_net;
			for (i=1; i lte arraylen(puantaj_exts); i = i+1)
			{
				if(puantaj_exts[i][6] eq 0 and puantaj_exts[i][9] eq 0)//net odenekler
					if(puantaj_exts[i][4] eq 2 and puantaj_exts[i][5] eq 1 and puantaj_exts[i][13] eq 1 and puantaj_exts[i][14] eq 1)
						{
						puantaj_exts[i][3] = puantaj_exts[i][3] * this_oran;
						//sgk muafiyeti var ise  //SG 20151222
						if(len(puantaj_exts[i][36]) and len(puantaj_exts[i][37])) //sgk muafiyet oranı ve sgk muafiyet tipi
						{
							if(puantaj_exts[i][37] eq 0) //muafiyet tipi Asgari Ücrete Göre
								{
								_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL * puantaj_exts[i][36] / 100;
								if(_tutar gt puantaj_exts[i][3])
									_tutar = puantaj_exts[i][3];
								}
							else if(puantaj_exts[i][37] eq 1) // muafiyet tipi Tutara Göre
								_tutar = puantaj_exts[i][3] * puantaj_exts[i][36] / 100;
							else if(puantaj_exts[i][37] eq 2) //muafiyet tipi Günlük Asgari Ücrete Göre
							{
								if(puantaj_exts[i][7] eq 1)//güne göre
									_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * ssk_days;
								else if(get_pay_salary.calc_days[i] eq 2)//fiili güne göre
									_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * fiili_gun_;
								else
									_tutar = get_insurance.MIN_GROSS_PAYMENT_NORMAL / 30 * puantaj_exts[i][36] / 100 * puantaj_exts[i][15];
							}
							ssk_matraha_dahil_olmayan_net_odenek_tutar = ssk_matraha_dahil_olmayan_net_odenek_tutar + _tutar;
						}
 						puantaj_exts[i][9] = 1;//artik brut oldu
						}
				}
		}
	</cfscript>
</cfif>
<cfset kazanca_dahil_olan_odenek_tutar_muaf = temp_kazanca_dahil_olan_odenek_tutar_muaf>
<cfset is_net_payment = 0>
<cfset net_payment_temp = 0>
<cfif get_hr_ssk.IS_TAX_FREE eq 1 and get_hr_ssk.is_damga_free eq 1>
	<cfset is_tax_free_from_payment = 0>
</cfif>
