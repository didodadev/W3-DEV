<cfscript>
	// vergi istisnaları
	vergi_istisna = 0;
	vergi_istisna_kesintisiz = 0;
	vergi_brut_toplam_tutari = salary+total_pay_tax+total_pay_ssk_tax+total_pay+total_pay_ssk+ext_salary;//YO20060104
	/* vergi istisnalari tum ek odenek ve kesintilerden sonra olusan brut maas uzerinden hesaplanir... 20060104 tarihinden once ise direk
	brut maas uzerinden hesaplanmaktaydi.bu tarihten itibaren mgocen ve karari ile tekrardan total brutten hesaplanmaya baslandi.burada dikkat 
	edilmesi gereken konu vergi istisnalarinda hem istisna tutari hemde yuzde degeri var... istisna tutari ne kadar olursa olsun brut toplamin verilen
	yuzde degerini gecemez.fazla oldugu durumlarda yuzde degere esitlenir.
	ornegin 480 YTL brut kazanci olan kisiye 100 YTL %10 vergi istisnasi girilirse 100 YTL degil 480YTL nin %10 degeri olan 48 YTL vergi istisna uygulanir.*/
	/* vergi_brut_toplam_tutari = salary; */
	if (ssk_days gt 0) // ssk günü sıfır olanın ek ödenek, kesinti, vergi istisnaları dikkate alınmaz
	{
	for (i=1; i lte get_tax_exception.recordcount; i = i+1) 
		{
			istisna_sifirlandi = 0;

			//memursa gelir vergisi matrahı üzerinden hesaplamalar yapılır
			if(use_ssk eq 2)
			{
				toplam_vergi_istisna_siniri = (gelir_vergisi_matrah / 100) * 15; //toplam_vergi_istisna_siniri = (gelir_vergisi_matrah / 100) * 10 SG 20130130
				toplam_vergi_istisna_siniri_osi = (gelir_vergisi_matrah / 100) * 15; //toplam_vergi_istisna_siniri_osi = (gelir_vergisi_matrah / 100) * 5;
				toplam_vergi_istisna_siniri_bei = (gelir_vergisi_matrah / 100) * 15;
			}
			else
			{
				toplam_vergi_istisna_siniri = (vergi_brut_toplam_tutari / 100) * 15; //toplam_vergi_istisna_siniri = (vergi_brut_toplam_tutari / 100) * 10 SG 20130130
				toplam_vergi_istisna_siniri_osi = (vergi_brut_toplam_tutari / 100) * 15; //toplam_vergi_istisna_siniri_osi = (vergi_brut_toplam_tutari / 100) * 5;
				toplam_vergi_istisna_siniri_bei = (vergi_brut_toplam_tutari / 100) * 15;
			}		
			// vergi istisna toplami asgari ücreti geçemez erk 20040407
			if ((get_tax_exception.is_all_pay[i] neq 1 or len(get_tax_exception.EXCEPTION_TYPE[i])) and vergi_istisna lt get_insurance.MIN_GROSS_PAYMENT_NORMAL)
				{
				
				toplam_vergi_istisna_siniri = (vergi_brut_toplam_tutari / 100) * 15; //toplam_vergi_istisna_siniri = (vergi_brut_toplam_tutari / 100) * 10 SG 20130130_
				
				satir_vergi_istisna_tutari = 0;
				if (get_tax_exception.calc_days[i] eq 1) // günlere göre 
					satir_vergi_istisna_tutari = get_tax_exception.amount[i] * (ssk_days/ssk_full_days);
				else // günlere göre değil
					satir_vergi_istisna_tutari = get_tax_exception.amount[i];
		
				
				//abort('toplam_vergi_istisna_siniri:#toplam_vergi_istisna_siniri# satir_vergi_istisna_tutari:#satir_vergi_istisna_tutari#');
				
				if(toplam_vergi_istisna_siniri lt (vergi_istisna_osi + vergi_istisna_bei))
					satir_vergi_istisna_tutari = 0;
				else if(toplam_vergi_istisna_siniri lt (vergi_istisna_osi + vergi_istisna_bei + satir_vergi_istisna_tutari))
					satir_vergi_istisna_tutari = toplam_vergi_istisna_siniri - (vergi_istisna_osi + vergi_istisna_bei);	
				
				if(get_tax_exception.EXCEPTION_TYPE[i] eq 4)
					{
					if(toplam_vergi_istisna_siniri_osi lt vergi_istisna_osi)
						{
						satir_vergi_istisna_tutari = 0;
						}
					else if(toplam_vergi_istisna_siniri_osi lt (vergi_istisna_osi + satir_vergi_istisna_tutari))
						{
						satir_vergi_istisna_tutari = toplam_vergi_istisna_siniri_osi - vergi_istisna_osi;	
						}						
					}
				
				if(get_tax_exception.EXCEPTION_TYPE[i] eq 2)
					{
					if(toplam_vergi_istisna_siniri_bei lt vergi_istisna_bei)
						{
						satir_vergi_istisna_tutari = 0;
						}
					else if(toplam_vergi_istisna_siniri_bei lt (vergi_istisna_bei + satir_vergi_istisna_tutari))
						{
						satir_vergi_istisna_tutari = toplam_vergi_istisna_siniri_bei - vergi_istisna_bei;	
						}						
					}
				
				// vergi istisnası toplam brut ücretin belirtilen yuzdesinden fazlasını almaz erk 20040407
				if(get_tax_exception.EXCEPTION_TYPE[i] eq 2)
					yuzde_sinir_ = 10;////
				else if(get_tax_exception.EXCEPTION_TYPE[i] eq 4)
					yuzde_sinir_ = 15; //yuzde_sinir_ = 5  //SG 20130130 oran degistirildi
				else
					yuzde_sinir_ = get_tax_exception.yuzde_sinir[i];
				if(not len(vergi_brut_toplam_tutari)) vergi_brut_toplam_tutari = 0;
				if(not len(yuzde_sinir_)) yuzde_sinir_ = 0;
					satir_vergi_istisna_siniri = (vergi_brut_toplam_tutari / 100) * yuzde_sinir_;
					
				if (satir_vergi_istisna_tutari gt satir_vergi_istisna_siniri) 
					satir_vergi_istisna_tutari = satir_vergi_istisna_siniri;
					
				if(toplam_vergi_istisna_siniri lt (vergi_istisna_osi + vergi_istisna_bei + vergi_istisna))
					satir_vergi_istisna_tutari = 0;
				else if(toplam_vergi_istisna_siniri lt (vergi_istisna_osi + vergi_istisna_bei + vergi_istisna + satir_vergi_istisna_tutari))
					satir_vergi_istisna_tutari = toplam_vergi_istisna_siniri - (vergi_istisna_osi + vergi_istisna_bei + vergi_istisna);	
					
				if(old_except lt yillik_toplam_asgari_ucret)
					{
					if(old_except gt 0)
						{
						if((old_except + vergi_istisna_osi + vergi_istisna_bei + vergi_istisna + satir_vergi_istisna_tutari) gt yillik_toplam_asgari_ucret)
							{
							satir_vergi_istisna_tutari = yillik_toplam_asgari_ucret - (old_except + vergi_istisna_osi + vergi_istisna_bei + vergi_istisna);
							if(satir_vergi_istisna_tutari lt 0)
								{
								satir_vergi_istisna_tutari = 0;
								}
							}
						}
					}
				else
					{
					satir_vergi_istisna_tutari = 0;	
					satir_vergi_istisna_tutari_ilk = 0;
					}
					
				if(satir_vergi_istisna_tutari gt 0)
					{
						puantaj_exts_index = puantaj_exts_index + 1;
						puantaj_exts[puantaj_exts_index][1] = get_tax_exception.TAX_EXCEPTION[i];
						puantaj_exts[puantaj_exts_index][2] = 1;
						puantaj_exts[puantaj_exts_index][4] = 0;
						puantaj_exts[puantaj_exts_index][5] = 0;
						puantaj_exts[puantaj_exts_index][6] = 2;
						puantaj_exts[puantaj_exts_index][7] = get_tax_exception.calc_days[i];
						puantaj_exts[puantaj_exts_index][8] = 0;
						puantaj_exts[puantaj_exts_index][9] = '';/*odenek veya kesintinin net/brüt oldugu icin, istisna ile ilgisi yok*/
						puantaj_exts[puantaj_exts_index][10] = '';/*kideme dahil mi ek odenekler icin kullaniliyor*/
						puantaj_exts[puantaj_exts_index][11] = yuzde_sinir_;
						puantaj_exts[puantaj_exts_index][12] = 0;
						if ((vergi_istisna + satir_vergi_istisna_tutari) lt get_insurance.MIN_GROSS_PAYMENT_NORMAL)
							{
							puantaj_exts[puantaj_exts_index][3] = satir_vergi_istisna_tutari;
							vergi_istisna = vergi_istisna + satir_vergi_istisna_tutari;
							}
						else
							{
							puantaj_exts[puantaj_exts_index][3] = get_insurance.MIN_GROSS_PAYMENT_NORMAL - vergi_istisna;
							vergi_istisna = get_insurance.MIN_GROSS_PAYMENT_NORMAL;
							}
					}
				}
			else if(get_tax_exception.is_all_pay[i] eq 1 and not len(get_tax_exception.EXCEPTION_TYPE[i]))
				{
				satir_vergi_istisna_tutari = 0;
				if (get_tax_exception.calc_days[i] eq 1) // günlere göre
					satir_vergi_istisna_tutari = (get_tax_exception.amount[i] * (ssk_days/ssk_full_days) );
				else // günlere göre değil
					satir_vergi_istisna_tutari = get_tax_exception.amount[i];
					
					puantaj_exts_index = puantaj_exts_index + 1;
					puantaj_exts[puantaj_exts_index][1] = get_tax_exception.TAX_EXCEPTION[i];
					puantaj_exts[puantaj_exts_index][2] = 1;
					puantaj_exts[puantaj_exts_index][4] = 0;
					puantaj_exts[puantaj_exts_index][5] = 0;
					puantaj_exts[puantaj_exts_index][6] = 2;
					puantaj_exts[puantaj_exts_index][7] = get_tax_exception.calc_days[i];
					puantaj_exts[puantaj_exts_index][8] = 0;
					puantaj_exts[puantaj_exts_index][9] = '';/*odenek veya kesintinin net/brüt oldugu icin, istisna ile ilgisi yok*/
					puantaj_exts[puantaj_exts_index][10] = '';/*kideme dahil mi ek odenekler icin kullaniliyor*/
					puantaj_exts[puantaj_exts_index][11] = get_tax_exception.yuzde_sinir[i];
					puantaj_exts[puantaj_exts_index][12] = 1;
					
					puantaj_exts[puantaj_exts_index][3] = satir_vergi_istisna_tutari;
					
					vergi_istisna_kesintisiz = vergi_istisna_kesintisiz + satir_vergi_istisna_tutari;
				}
		}
	}
	vergi_istisna = vergi_istisna + vergi_istisna_kesintisiz;
</cfscript>
