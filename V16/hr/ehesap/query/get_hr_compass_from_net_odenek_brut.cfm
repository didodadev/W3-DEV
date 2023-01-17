<cfscript>
	/* 20050923
	damga vergi orani ssk ve vergi oncesi toplam gelirden oldugu icin ayrilan ssk ve vergiler oraninda damga vergisi oranida buyumeli ki
	bulunan brute (damga oncesi) eklenecek damga vergisinden sonra toplam brut ten standart damga orani ile hesap edilen dogru olsun.
	orn : binde 6 olan damga vergisinin sadece netten brute kisminda 8,3 gozukmesi gibi.
	*/
	
	if(total_pay_tax_net gt 0)
		{
		oran_damga_duzeltme = get_active_program_parameter.STAMP_TAX_BINDE / (1-tax_ratio);
		total_pay_tax_net = total_pay_tax_net/(1-tax_ratio);
		total_pay_tax_net = wrk_round( (total_pay_tax_net*1000)/(1000-oran_damga_duzeltme) );
		for (i=1; i lte arraylen(puantaj_exts); i = i+1)
			{
			if(puantaj_exts[i][6] eq 0 and puantaj_exts[i][9] eq 0)//net odenekler
				if(puantaj_exts[i][4] eq 1 and puantaj_exts[i][5] eq 2)
					{//sadece vergi dahil olanlar veri carpani ile buyutulecek
					puantaj_exts[i][3] = puantaj_exts[i][3]/(1-tax_ratio);
					puantaj_exts[i][3] = wrk_round( (puantaj_exts[i][3]*1000)/(1000-oran_damga_duzeltme) );
					puantaj_exts[i][9] = 1;//artik brut oldu
					}
			}
		}

	if(total_pay_net gt 0)
		{
		total_pay_net = wrk_round( (total_pay_net*1000)/(1000-get_active_program_parameter.STAMP_TAX_BINDE) );
		for (i=1; i lte arraylen(puantaj_exts); i = i+1)
			{
			if(puantaj_exts[i][6] eq 0 and puantaj_exts[i][9] eq 0)//net odenekler
				if(puantaj_exts[i][4] eq 1 and puantaj_exts[i][5] eq 1)
					{//ssk da haric vergi de haric olanlar damga vergi carpani ile buyutulecek
					puantaj_exts[i][3] = wrk_round( (puantaj_exts[i][3]*1000)/(1000-get_active_program_parameter.STAMP_TAX_BINDE) );
					puantaj_exts[i][9] = 1;//artik brut oldu
					}
			}
		}

	if(total_pay_ssk_net gt 0)
	{
		//brut_total_pay_ssk_tax_net = total_pay_ssk_tax_net * (sal_temp/salary);
		brut_total_pay_ssk_tax_net = total_pay_ssk_tax_net * (salary/sal_temp);
		if(salary gt ssk_matrah_tavan)
			{//brut ucret tavandan buyukse
			temp_total_pay_ssk_net = total_pay_ssk_net;
			total_pay_ssk_net = wrk_round((total_pay_ssk_net*1000)/(1000-get_active_program_parameter.STAMP_TAX_BINDE) );
			oran_total_pay_ssk_net = total_pay_ssk_net/temp_total_pay_ssk_net;
			for (i=1; i lte arraylen(puantaj_exts); i = i+1)
				{
				if(puantaj_exts[i][6] eq 0 and puantaj_exts[i][9] eq 0)//net odenekler
					if(puantaj_exts[i][4] eq 2 and puantaj_exts[i][5] eq 1)
						{//sadece ssk dahil olanlar ssk carpanlari ile buyutulecek
						puantaj_exts[i][3] = wrk_round(puantaj_exts[i][3]*oran_total_pay_ssk_net);
						puantaj_exts[i][9] = 1;//artik brut oldu
						}
				}
			}
		else if(salary+brut_total_pay_ssk_tax_net lte ssk_matrah_tavan)
			{//brut ucret ve sadece ssk dahil odenekler toplami tavandan kucukse
			temp_total_pay_ssk_net = total_pay_ssk_net;
			/* bir yontem alttaki gibi sigorta ve damga yi dusup, cikan sonucla basladimiz deger arasindaki farkin (vergi tutarini etkileyecegi icin)
			vergi kadar tutarini cikariyoruz ki kaybedilecek vergi tutari telafi edilebilsin. */
			/*
			total_pay_ssk_net = total_pay_ssk_net/( 1 - ((ssk_isci_carpan+issizlik_isci_carpan)/100) - (get_active_program_parameter.STAMP_TAX_BINDE/1000));
			total_pay_ssk_net = wrk_round( total_pay_ssk_net - (tax_ratio*(total_pay_ssk_net-temp_total_pay_ssk_net)) );
			*/
			//Bu da diger yol ve daha dogru gozukuyor, 1 krs lari yakaliyor
			total_pay_ssk_net = total_pay_ssk_net/( ( 1 - ((ssk_isci_carpan+issizlik_isci_carpan)/100) - (get_active_program_parameter.STAMP_TAX_BINDE/1000)) + (tax_ratio*((ssk_isci_carpan+issizlik_isci_carpan)/100)) );
			oran_total_pay_ssk_net = total_pay_ssk_net/temp_total_pay_ssk_net;
			for (i=1; i lte arraylen(puantaj_exts); i = i+1)
				{
				if(puantaj_exts[i][6] eq 0 and puantaj_exts[i][9] eq 0)//net odenekler
					if(puantaj_exts[i][4] eq 2 and puantaj_exts[i][5] eq 1)
						{//sadece ssk dahil olanlar ssk carpanlari ile buyutulecek
						puantaj_exts[i][3] = wrk_round( puantaj_exts[i][3]*oran_total_pay_ssk_net );
						puantaj_exts[i][9] = 1;//artik brut oldu
						}
				}
			}
		else if(salary+brut_total_pay_ssk_tax_net gt ssk_matrah_tavan)
			{//brut ucret ve sadece ssk dahil odenekler toplami tavandan buyukse
			brut_normal_total_pay_ssk_net = (ssk_matrah_tavan-salary);
			normal_total_pay_ssk_net = (brut_normal_total_pay_ssk_net*100)/(100 + ssk_isci_carpan +issizlik_isci_carpan);
			fazla_total_pay_ssk_net = total_pay_ssk_net - normal_total_pay_ssk_net;
			fazla_total_pay_ssk_net = wrk_round((fazla_total_pay_ssk_net*1000)/(1000-get_active_program_parameter.STAMP_TAX_BINDE) );
			oran_total_pay_ssk_net = (brut_normal_total_pay_ssk_net + fazla_total_pay_ssk_net)/total_pay_ssk_net;//yeni bulunan toplamin ilk degere orani
			total_pay_ssk_net = (brut_normal_total_pay_ssk_net + fazla_total_pay_ssk_net);
			for (i=1; i lte arraylen(puantaj_exts); i = i+1)
				{
				if(puantaj_exts[i][6] eq 0 and puantaj_exts[i][9] eq 0)//net odenekler
					if(puantaj_exts[i][4] eq 2 and puantaj_exts[i][5] eq 1)
						{//sadece ssk dahil olanlar ssk carpanlari ile buyutulecek
						puantaj_exts[i][3] = wrk_round(puantaj_exts[i][3]*oran_total_pay_ssk_net);
						puantaj_exts[i][9] = 1;//artik brut oldu
						}
				}
			}		
		}
	if(total_pay_ssk_tax_net gt 0)
		{
		//brut_total_pay_ssk_tax_net = total_pay_ssk_tax_net * (sal_temp/salary);
		if(ssk_days)
			brut_total_pay_ssk_tax_net = total_pay_ssk_tax_net * (salary/sal_temp);
		else
		{
			brut_total_pay_ssk_tax_net = total_pay_ssk_tax_net;
			ssk_matrah_taban = get_insurance.MIN_PAYMENT;
			//ssk_matrah_tavan = get_insurance.MAX_PAYMENT;
			if(get_hr_ssk.SSK_STATUTE eq 21 or ((get_hr_ssk.ssk_statute eq 2 or get_hr_ssk.ssk_statute eq 18) and get_hr_ssk.working_abroad eq 1)) 
			{
				ssk_matrah_tavan = get_insurance.MIN_PAYMENT*3;
			}
			else
			{
				ssk_matrah_tavan = get_insurance.MAX_PAYMENT;	
			}
			gelir_vergisi_matrah = brut_total_pay_ssk_tax_net;
			include 'get_hr_compass_tax.cfm';//tax_ratio geliyor
		}
		//writeoutput('___total_pay_ssk_tax_net:#total_pay_ssk_tax_net#___brut_total_pay_ssk_tax_net:#brut_total_pay_ssk_tax_net#__<br/>');
		if(salary gt ssk_matrah_tavan)
			{//brut ucret tavandan buyukse
			oran_damga_duzeltme = get_active_program_parameter.STAMP_TAX_BINDE/(1-tax_ratio);
			total_pay_ssk_tax_net = total_pay_ssk_tax_net/(1-tax_ratio);
			total_pay_ssk_tax_net = wrk_round( (total_pay_ssk_tax_net*1000)/(1000-oran_damga_duzeltme) );
			for (i=1; i lte arraylen(puantaj_exts); i = i+1){
				if(puantaj_exts[i][6] eq 0 and puantaj_exts[i][9] eq 0)//net odenekler
					if(puantaj_exts[i][4] eq 2 and puantaj_exts[i][5] eq 2){//sadece vergi dahil olanlar veri carpani ile buyutulecek
						puantaj_exts[i][3] = puantaj_exts[i][3]/(1-tax_ratio);
						puantaj_exts[i][3] = wrk_round( (puantaj_exts[i][3]*1000)/(1000-oran_damga_duzeltme) );
						puantaj_exts[i][9] = 1;//artik brut oldu
						}
				}
			}
		else if(salary+brut_total_pay_ssk_tax_net lte ssk_matrah_tavan)		
			{//brut ucret ve sadece hem ssk hem vergi dahil odenekler toplami tavandan kucukse
			oran_damga_duzeltme = (get_active_program_parameter.STAMP_TAX_BINDE*100)/( (1-tax_ratio) * (100-ssk_isci_carpan-issizlik_isci_carpan) );
			temp_total_pay_ssk_tax_net = total_pay_ssk_tax_net;
			total_pay_ssk_tax_net = total_pay_ssk_tax_net/(1-tax_ratio) ;
			total_pay_ssk_tax_net = (total_pay_ssk_tax_net*100)/(100-ssk_isci_carpan-issizlik_isci_carpan);
			total_pay_ssk_tax_net = wrk_round((total_pay_ssk_tax_net*1000)/(1000-oran_damga_duzeltme) );
			oran_total_pay_ssk_tax_net = total_pay_ssk_tax_net/temp_total_pay_ssk_tax_net;
			for (i=1; i lte arraylen(puantaj_exts); i = i+1)
				{
				if(puantaj_exts[i][6] eq 0 and puantaj_exts[i][9] eq 0)//net odenekler
					if(puantaj_exts[i][4] eq 2 and puantaj_exts[i][5] eq 2)
						{
						//ssk+vergi dahil olanlar bulunan carpanlari ile buyutulecek
						//writeoutput('olmasi gereken : 1.48360----oran_total_pay_ssk_tax_net:#oran_total_pay_ssk_tax_net#');
						puantaj_exts[i][3] = wrk_round(puantaj_exts[i][3]*oran_total_pay_ssk_tax_net);
						puantaj_exts[i][9] = 1;//artik brut oldu
						}
				}
			}
		else if(salary+brut_total_pay_ssk_tax_net gt ssk_matrah_tavan)	
			{//brut ucret ve hem ssk hem vergi dahil odenekler toplami tavandan buyukse
			oran_damga_duzeltme = get_active_program_parameter.STAMP_TAX_BINDE/(1-tax_ratio);
			
			brut_normal_total_pay_ssk_tax_net = (ssk_matrah_tavan-salary);
			normal_total_pay_ssk_tax_net = (brut_normal_total_pay_ssk_tax_net * (100 - ssk_isci_carpan - issizlik_isci_carpan)) / 100;
			normal_total_pay_ssk_tax_net = normal_total_pay_ssk_tax_net*(1-tax_ratio);
			normal_total_pay_ssk_tax_net = normal_total_pay_ssk_tax_net - (brut_normal_total_pay_ssk_tax_net * get_active_program_parameter.STAMP_TAX_BINDE / 1000);
			fazla_total_pay_ssk_tax_net = total_pay_ssk_tax_net - normal_total_pay_ssk_tax_net;
			
			
			fazla_total_pay_ssk_tax_net = fazla_total_pay_ssk_tax_net/(1-tax_ratio);
			brut_fazla_total_pay_ssk_tax_net = wrk_round((fazla_total_pay_ssk_tax_net*1000)/(1000-oran_damga_duzeltme));
			
			
			oran_total_pay_ssk_tax_net = (brut_normal_total_pay_ssk_tax_net + brut_fazla_total_pay_ssk_tax_net)/total_pay_ssk_tax_net;
			total_pay_ssk_tax_net = (brut_normal_total_pay_ssk_tax_net + brut_fazla_total_pay_ssk_tax_net);
			for (i=1; i lte arraylen(puantaj_exts); i = i+1)
				{
				if(puantaj_exts[i][6] eq 0 and puantaj_exts[i][9] eq 0)//net odenekler
					if(puantaj_exts[i][4] eq 2 and puantaj_exts[i][5] eq 2){//ssk+vergi dahil olanlar bulunan carpanlari ile buyutulecek
						puantaj_exts[i][3] = wrk_round(puantaj_exts[i][3]*oran_total_pay_ssk_tax_net);
						//puantaj_exts[i][3] = wrk_round(puantaj_exts[i][3]*(salary/sal_temp));
						puantaj_exts[i][9] = 1;//artik brut oldu
						}
				}
			}
		}
		/* for (i=1; i lte arraylen(puantaj_exts); i = i+1)
			{
				if(puantaj_exts[i][6] eq 0 and puantaj_exts[i][9] eq 1)//brut odenekler
					if(puantaj_exts[i][4] eq 2 and puantaj_exts[i][5] eq 2)
						{
						//ssk+vergi dahil olanlar bulunan carpanlari ile buyutulecek
						total_pay_ssk_tax = puantaj_exts[i][3]+total_pay_ssk_tax;
						}
			} 
		*/
	total_pay_ssk_tax = total_pay_ssk_tax + total_pay_ssk_tax_net;
	total_pay_ssk = total_pay_ssk + total_pay_ssk_net;
	total_pay_tax = total_pay_tax + total_pay_tax_net;
	total_pay = total_pay + total_pay_net;
</cfscript>
