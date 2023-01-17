<cfscript>
	// hayat sigortası- vergi istisnaları
	this_vergi_istisna_vergi_tutar = 0;
	total_vergi_istisna_ssk_tutar_hs = 0;
	vergi_brut_toplam_tutari = salary+total_pay_tax+total_pay_ssk_tax+total_pay+total_pay_ssk+ext_salary;//YO20060104
	if (ssk_days gt 0) // ssk günü sıfır olanın ek ödenek, kesinti, vergi istisnaları dikkate alınmaz
	{
		for (i=1; i lte get_tax_exception_hs.recordcount; i = i+1) 
		{
			istisna_sifirlandi = 0;
			toplam_vergi_istisna_siniri = (vergi_brut_toplam_tutari / 100) * 15;
			vergi_istisna_ssk_tutar_hs=0;
			vergi_istisna_ssk_tutar_ = 0;
			satir_vergi_istisna_tutari = 0;
			satir_vergi_istisna_tutari = get_tax_exception_hs.amount[i]/2;
			satir_vergi_istisna_tutari_ilk = get_tax_exception_hs.amount[i]/2;
			
			vergi_istisna_total = vergi_istisna_total + get_tax_exception_hs.amount[i];
			
			asgari_ssk_ = get_insurance.MIN_GROSS_PAYMENT_NORMAL * 30 /100;
			satir_vergi_istisna_siniri = (vergi_brut_toplam_tutari / 100) * 15; 
			
			if(satir_vergi_istisna_tutari gt satir_vergi_istisna_siniri) 
				satir_vergi_istisna_tutari = satir_vergi_istisna_siniri;
			
			temp_satir_vergi_istisna_tutari = satir_vergi_istisna_tutari;
			if(toplam_vergi_istisna_siniri lte (vergi_istisna_osi + vergi_istisna_bei +vergi_istisna_hs))
			{
				satir_vergi_istisna_tutari = 0;
				satir_vergi_istisna_tutari_ilk = 0;
				vergi_istisna_ssk_tutar = vergi_istisna_ssk_tutar + get_tax_exception_hs.amount[i];
				vergi_istisna_ssk_tutar_ = vergi_istisna_ssk_tutar_ + get_tax_exception_hs.amount[i];
			}
			else if(toplam_vergi_istisna_siniri lt ((vergi_istisna_osi + vergi_istisna_bei +vergi_istisna_hs)  + satir_vergi_istisna_tutari))
			{
				satir_vergi_istisna_tutari = toplam_vergi_istisna_siniri - ((vergi_istisna_osi + vergi_istisna_bei +vergi_istisna_hs));
				if(temp_satir_vergi_istisna_tutari gt satir_vergi_istisna_tutari)
				{
					satir_vergi_istisna_tutari_ilk = 0;
					vergi_istisna_ssk_tutar = vergi_istisna_ssk_tutar + get_tax_exception_hs.amount[i]-satir_vergi_istisna_tutari;
					vergi_istisna_ssk_tutar_ = vergi_istisna_ssk_tutar_+get_tax_exception_hs.amount[i]-satir_vergi_istisna_tutari;
				}
				else
				{
					vergi_istisna_ssk_tutar = vergi_istisna_ssk_tutar + get_tax_exception_hs.amount[i]/2;
					vergi_istisna_ssk_tutar_ = vergi_istisna_ssk_tutar_+get_tax_exception_hs.amount[i]/2;
					vergi_istisna_ssk_tutar_hs = vergi_istisna_ssk_tutar_hs + get_tax_exception_hs.amount[i]/2;
				}
			}
			else
			{
				vergi_istisna_ssk_tutar = vergi_istisna_ssk_tutar + get_tax_exception_hs.amount[i]/2;
				vergi_istisna_ssk_tutar_ = vergi_istisna_ssk_tutar_+get_tax_exception_hs.amount[i]/2;
				vergi_istisna_ssk_tutar_hs = vergi_istisna_ssk_tutar_hs + get_tax_exception_hs.amount[i]/2;
			}
			
			if(old_except lt yillik_toplam_asgari_ucret)
			{
				if(old_except gt 0)
				{
					if((old_except + (vergi_istisna_osi + vergi_istisna_bei +vergi_istisna_hs) + satir_vergi_istisna_tutari) gt yillik_toplam_asgari_ucret)
					{
						satir_vergi_istisna_tutari = yillik_toplam_asgari_ucret - (old_except + (vergi_istisna_osi + vergi_istisna_bei +vergi_istisna_hs));
						if(satir_vergi_istisna_tutari lt 0)
						{
							satir_vergi_istisna_tutari = 0;
						}
					}
				}
			}
			else
			{
				istisna_sifirlandi = 1;
				satir_vergi_istisna_tutari = 0;	
				satir_vergi_istisna_tutari_ilk = 0;
			}
				
			if(satir_vergi_istisna_tutari_ilk gt satir_vergi_istisna_tutari and satir_vergi_istisna_tutari_ilk gt asgari_ssk_ and (satir_vergi_istisna_tutari_ilk - satir_vergi_istisna_tutari) gt asgari_ssk_)
				this_vergi_istisna_vergi_tutar = this_vergi_istisna_vergi_tutar + asgari_ssk_ - satir_vergi_istisna_tutari;
			else if(satir_vergi_istisna_tutari_ilk gt satir_vergi_istisna_tutari and satir_vergi_istisna_tutari lt asgari_ssk_)
				this_vergi_istisna_vergi_tutar = this_vergi_istisna_vergi_tutar + satir_vergi_istisna_tutari_ilk - satir_vergi_istisna_tutari;
			else if(satir_vergi_istisna_tutari gt satir_vergi_istisna_siniri and satir_vergi_istisna_tutari lt asgari_ssk_)
				this_vergi_istisna_vergi_tutar = this_vergi_istisna_vergi_tutar + satir_vergi_istisna_tutari - satir_vergi_istisna_siniri;
			else if(satir_vergi_istisna_tutari gt satir_vergi_istisna_siniri and satir_vergi_istisna_tutari gt asgari_ssk_)
				this_vergi_istisna_vergi_tutar = this_vergi_istisna_vergi_tutar + asgari_ssk_ - satir_vergi_istisna_siniri;
				
			if(istisna_sifirlandi eq 1)
			{
				this_vergi_istisna_vergi_tutar = asgari_ssk_;
			}
			vergi_istisna_vergi_tutar = vergi_istisna_vergi_tutar + this_vergi_istisna_vergi_tutar;
			if((this_vergi_istisna_vergi_tutar + satir_vergi_istisna_tutari) lte asgari_ssk_ and satir_vergi_istisna_tutari_ilk gt asgari_ssk_)
			{
				vergi_istisna_ssk_tutar = vergi_istisna_ssk_tutar + (satir_vergi_istisna_tutari_ilk - asgari_ssk_);
				vergi_istisna_ssk_tutar_ = vergi_istisna_ssk_tutar_ + (satir_vergi_istisna_tutari_ilk - asgari_ssk_);
			}
			
			//damga eklenmiş hali	
			total_vergi_istisna_amount = 0;
			oran_damga_duzeltme = get_active_program_parameter.STAMP_TAX_BINDE/(1-0);
			vergi_istisna_damga_tutar_ = satir_vergi_istisna_tutari/(1-0);
			vergi_istisna_damga_tutar_ = wrk_round((vergi_istisna_damga_tutar_*1000)/(1000-oran_damga_duzeltme));
			//total_vergi_istisna_amount = total_vergi_istisna_amount + vergi_istisna_damga_tutar_;
			
			//damga , vergi , ssk ekleniş hali
			vergi_istisna_ssk_tutar_net = vergi_istisna_ssk_tutar;
			if(isdefined("ekten_gelen"))
				ekten_gelen_ = ekten_gelen;
			else
				ekten_gelen_ = 0;
			if(vergi_istisna_ssk_tutar_ gt 0)
			{
				sal_temp = salary;//from_net_odenek de oranlamak icin kullaniliyor
				gelir_vergisi_matrah = salary;
				include 'get_hr_compass_tax.cfm';//tax_ratio geliyor
		
				if(ssk_days)
					brut_total_pay_ssk_tax_net = vergi_istisna_ssk_tutar_ * (salary/sal_temp);
				else
				{
					brut_total_pay_ssk_tax_net = vergi_istisna_ssk_tutar_;
					ssk_matrah_taban = get_insurance.MIN_PAYMENT;
					//ssk_matrah_tavan = get_insurance.MAX_PAYMENT;
						if(get_hr_ssk.SSK_STATUTE eq 21 or ((get_hr_ssk.ssk_statute eq 2 or get_hr_ssk.ssk_statute eq 18) and get_hr_ssk.working_abroad eq 1)) //sozlesmesiz ulkelere goturulecek calisanlar
					{
						ssk_matrah_tavan = get_insurance.MIN_PAYMENT*3;
					}
					else
					{
						ssk_matrah_tavan = get_insurance.MAX_PAYMENT;	
					}
					gelir_vergisi_matrah = brut_total_pay_ssk_tax_net;
					include 'get_hr_compass_tax.cfm';
				}
				if(salary+ekten_gelen_ gt ssk_matrah_tavan)
				{
					oran_damga_duzeltme = get_active_program_parameter.STAMP_TAX_BINDE/(1-tax_carpan);
					vergi_istisna_ssk_tutar_ = vergi_istisna_ssk_tutar_/(1-tax_carpan);
					vergi_istisna_ssk_tutar_ = wrk_round( (vergi_istisna_ssk_tutar_*1000)/(1000-oran_damga_duzeltme) );
				}
				else if(salary+brut_total_pay_ssk_tax_net+ekten_gelen_ lte ssk_matrah_tavan)		
				{//brut ucret ve sadece hem ssk hem vergi dahil odenekler toplami tavandan kucukse
					oran_damga_duzeltme = (get_active_program_parameter.STAMP_TAX_BINDE*100)/( (1-tax_carpan) * (100-ssk_isci_carpan-issizlik_isci_carpan) );
					temp_total_pay_ssk_tax_net = vergi_istisna_ssk_tutar_;
					total_pay_ssk_tax_net = vergi_istisna_ssk_tutar_/(1-tax_carpan) ;
					total_pay_ssk_tax_net = (total_pay_ssk_tax_net*100)/(100-ssk_isci_carpan-issizlik_isci_carpan);
					vergi_istisna_ssk_tutar_ = wrk_round((total_pay_ssk_tax_net*1000)/(1000-oran_damga_duzeltme) );
				}
				else if(salary+brut_total_pay_ssk_tax_net+ekten_gelen_ gt ssk_matrah_tavan)	
				{//brut ucret ve hem ssk hem vergi dahil odenekler toplami tavandan buyukse
					oran_damga_duzeltme = get_active_program_parameter.STAMP_TAX_BINDE/(1-tax_carpan);
					
					brut_normal_total_pay_ssk_tax_net = (ssk_matrah_tavan-(salary+ekten_gelen_));
					normal_total_pay_ssk_tax_net = (brut_normal_total_pay_ssk_tax_net * (100 - ssk_isci_carpan - issizlik_isci_carpan)) / 100;
					normal_total_pay_ssk_tax_net = normal_total_pay_ssk_tax_net*(1-tax_carpan);
					normal_total_pay_ssk_tax_net = normal_total_pay_ssk_tax_net - (brut_normal_total_pay_ssk_tax_net * get_active_program_parameter.STAMP_TAX_BINDE / 1000);
					ekten_gelen_ = ekten_gelen_ + brut_normal_total_pay_ssk_tax_net;
					fazla_total_pay_ssk_tax_net = vergi_istisna_ssk_tutar_ - normal_total_pay_ssk_tax_net;
					fazla_total_pay_ssk_tax_net = fazla_total_pay_ssk_tax_net/(1-tax_carpan);
					brut_fazla_total_pay_ssk_tax_net = wrk_round((fazla_total_pay_ssk_tax_net*1000)/(1000-oran_damga_duzeltme));
					
					vergi_istisna_ssk_tutar_ = (brut_normal_total_pay_ssk_tax_net + brut_fazla_total_pay_ssk_tax_net);
				}
				//writeoutput("total_vergi_istisna_amount:#total_vergi_istisna_amount#<br>");
				//writeoutput("vergi_istisna_ssk_tutar_:#vergi_istisna_ssk_tutar_#<br>");
				total_vergi_istisna_amount = total_vergi_istisna_amount + vergi_istisna_ssk_tutar_;
			}
			vergi_istisna_ssk_tutar_hs_ = vergi_istisna_ssk_tutar_hs;
			if(vergi_istisna_ssk_tutar_hs_ gt 0)
			{
				sal_temp = salary;//from_net_odenek de oranlamak icin kullaniliyor
				gelir_vergisi_matrah = salary;
				include 'get_hr_compass_tax.cfm';//tax_ratio geliyor

				if(salary+ekten_gelen_ gt ssk_matrah_tavan)
				{
					oran_damga_duzeltme = get_active_program_parameter.STAMP_TAX_BINDE;
					vergi_istisna_ssk_tutar_hs = vergi_istisna_ssk_tutar_hs_;
					vergi_istisna_ssk_tutar_hs_ = wrk_round( (vergi_istisna_ssk_tutar_hs_*1000)/(1000-oran_damga_duzeltme));
				}
				else if(salary+brut_total_pay_ssk_tax_net+ekten_gelen_ lte ssk_matrah_tavan)		
				{
					//brut ucret ve sadece hem ssk hem vergi dahil odenekler toplami tavandan kucukse
					oran_damga_duzeltme = (get_active_program_parameter.STAMP_TAX_BINDE*100)/((100-ssk_isci_carpan-issizlik_isci_carpan) );
					temp_total_pay_ssk_tax_net = vergi_istisna_ssk_tutar_hs_;
					total_pay_ssk_tax_net = (temp_total_pay_ssk_tax_net*100)/(100-ssk_isci_carpan-issizlik_isci_carpan);
					vergi_istisna_ssk_tutar_hs_ = ((total_pay_ssk_tax_net*1000)/(1000-oran_damga_duzeltme) );
				}
				else if(salary+brut_total_pay_ssk_tax_net+ekten_gelen_ gt ssk_matrah_tavan)	
				{
					//brut ucret ve hem ssk hem vergi dahil odenekler toplami tavandan buyukse
					oran_damga_duzeltme = get_active_program_parameter.STAMP_TAX_BINDE;
					brut_normal_total_pay_ssk_tax_net = (ssk_matrah_tavan-(salary+ekten_gelen_));
					normal_total_pay_ssk_tax_net = (brut_normal_total_pay_ssk_tax_net * (100 - ssk_isci_carpan - issizlik_isci_carpan)) / 100;
					normal_total_pay_ssk_tax_net = normal_total_pay_ssk_tax_net;
					normal_total_pay_ssk_tax_net = normal_total_pay_ssk_tax_net - (brut_normal_total_pay_ssk_tax_net * get_active_program_parameter.STAMP_TAX_BINDE / 1000);
					fazla_total_pay_ssk_tax_net = vergi_istisna_ssk_tutar_hs - normal_total_pay_ssk_tax_net;
					fazla_total_pay_ssk_tax_net = fazla_total_pay_ssk_tax_net;
					brut_fazla_total_pay_ssk_tax_net = wrk_round((fazla_total_pay_ssk_tax_net*1000)/(1000-oran_damga_duzeltme));
					vergi_istisna_ssk_tutar_hs_ = (brut_normal_total_pay_ssk_tax_net + brut_fazla_total_pay_ssk_tax_net);
				}
				total_vergi_istisna_amount = total_vergi_istisna_amount + vergi_istisna_ssk_tutar_hs_;
				//writeoutput("total_vergi_istisna_amount:#total_vergi_istisna_amount#<br>");
				//writeoutput("vergi_istisna_ssk_tutar_hs_:#vergi_istisna_ssk_tutar_hs_#<br>");
			}
			
			//ssk eklenmiş hali
			if(this_vergi_istisna_vergi_tutar gt 0)
			{
				gelir_vergisi_matrah = salary;
				include 'get_hr_compass_tax.cfm';
				vergi_istisna_vergi_tutar_net = this_vergi_istisna_vergi_tutar;
				oran_damga_duzeltme = get_active_program_parameter.STAMP_TAX_BINDE/(1-tax_carpan);
				vergi_istisna_vergi_tutar_ = this_vergi_istisna_vergi_tutar/(1-tax_carpan);
				vergi_istisna_vergi_tutar_ = wrk_round((vergi_istisna_vergi_tutar_*1000)/(1000-oran_damga_duzeltme));
				total_vergi_istisna_amount = total_vergi_istisna_amount + vergi_istisna_vergi_tutar_;
			}
			
			puantaj_exts_index = puantaj_exts_index + 1;
			puantaj_exts[puantaj_exts_index][1] = get_tax_exception_hs.TAX_EXCEPTION[i];
			puantaj_exts[puantaj_exts_index][2] = 1;
			puantaj_exts[puantaj_exts_index][4] = 0;
			puantaj_exts[puantaj_exts_index][5] = 0;
			puantaj_exts[puantaj_exts_index][6] = 2;
			puantaj_exts[puantaj_exts_index][7] = get_tax_exception_hs.calc_days[i];
			puantaj_exts[puantaj_exts_index][8] = 0;
			puantaj_exts[puantaj_exts_index][9] = '';/*odenek veya kesintinin net/brüt oldugu icin, istisna ile ilgisi yok*/
			puantaj_exts[puantaj_exts_index][10] = '';/*kideme dahil mi ek odenekler icin kullaniliyor*/
			puantaj_exts[puantaj_exts_index][11] = get_tax_exception.yuzde_sinir[i];
			puantaj_exts[puantaj_exts_index][12] = 0;
			puantaj_exts[puantaj_exts_index][3] = satir_vergi_istisna_tutari;
			puantaj_exts[puantaj_exts_index][13] = 0;/*damga var mi 1-var 0-yok */	
			puantaj_exts[puantaj_exts_index][14] = '';
			puantaj_exts[puantaj_exts_index][15] = '';
			puantaj_exts[puantaj_exts_index][16] = '';
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
			puantaj_exts[puantaj_exts_index][28] = '';
			puantaj_exts[puantaj_exts_index][29] = total_vergi_istisna_amount;
			puantaj_exts[puantaj_exts_index][30] = get_tax_exception_hs.amount[i];
			vergi_istisna_hs = vergi_istisna_hs + satir_vergi_istisna_tutari;
			total_vergi_istisna_ssk_tutar_hs = total_vergi_istisna_ssk_tutar_hs + vergi_istisna_ssk_tutar_hs;
		}
	}
	vergi_istisna_hs = vergi_istisna_hs;
</cfscript>
