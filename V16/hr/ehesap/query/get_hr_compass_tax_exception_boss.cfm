<cfscript>
	// vergi istisnaları
	vergi_istisna_boss = 0;
	vergi_istisna_kesintisiz_boss = 0;
	vergi_brut_toplam_tutari = salary+total_pay_tax+total_pay_ssk_tax+total_pay+total_pay_ssk+ext_salary;//YO20060104
	/* vergi istisnalari tum ek odenek ve kesintilerden sonra olusan brut maas uzerinden hesaplanir... 20060104 tarihinden once ise direk
	brut maas uzerinden hesaplanmaktaydi.bu tarihten itibaren mgocen ve karari ile tekrardan total brutten hesaplanmaya baslandi.burada dikkat 
	edilmesi gereken konu vergi istisnalarinda hem istisna tutari hemde yuzde degeri var... istisna tutari ne kadar olursa olsun brut toplamin verilen
	yuzde degerini gecemez.fazla oldugu durumlarda yuzde degere esitlenir.
	ornegin 480 YTL brut kazanci olan kisiye 100 YTL %10 vergi istisnasi girilirse 100 YTL degil 480YTL nin %10 degeri olan 48 YTL vergi istisna uygulanir.*/
	/* vergi_brut_toplam_tutari = salary; */
	if (ssk_days gt 0) // ssk günü sıfır olanın ek ödenek, kesinti, vergi istisnaları dikkate alınmaz
	{
	for (i=1; i lte get_tax_exception_boss.recordcount; i = i+1) 
		{
			// vergi istisna toplami asgari ücreti geçemez erk 20040407
			if (get_tax_exception_boss.is_all_pay[i] neq 1 and vergi_istisna_boss lt get_insurance.MIN_GROSS_PAYMENT_NORMAL)
				{
				satir_vergi_istisna_tutari = 0;
				if (get_tax_exception_boss.calc_days[i] eq 1) // günlere göre
					satir_vergi_istisna_tutari = (get_tax_exception_boss.amount[i] * (ssk_days/ssk_full_days) );
				else // günlere göre değil
					satir_vergi_istisna_tutari = get_tax_exception_boss.amount[i];
				
				vergi_istisna_ssk_tutar = vergi_istisna_ssk_tutar + satir_vergi_istisna_tutari;
					
				// vergi istisnası toplam brut ücretin belirtilen yuzdesinden fazlasını almaz erk 20040407
				satir_vergi_istisna_siniri = (vergi_brut_toplam_tutari / 100) * get_tax_exception_boss.yuzde_sinir[i];
				if (satir_vergi_istisna_tutari gt satir_vergi_istisna_siniri) 
					satir_vergi_istisna_tutari = satir_vergi_istisna_siniri;
		
				puantaj_exts_index = puantaj_exts_index + 1;
				puantaj_exts[puantaj_exts_index][1] = get_tax_exception_boss.TAX_EXCEPTION[i];
				puantaj_exts[puantaj_exts_index][2] = 1;
				puantaj_exts[puantaj_exts_index][4] = 0;
				puantaj_exts[puantaj_exts_index][5] = 0;
				puantaj_exts[puantaj_exts_index][6] = 2;
				puantaj_exts[puantaj_exts_index][7] = get_tax_exception_boss.calc_days[i];
				puantaj_exts[puantaj_exts_index][8] = 0;
				puantaj_exts[puantaj_exts_index][9] = '';/*odenek veya kesintinin net/brüt oldugu icin, istisna ile ilgisi yok*/
				puantaj_exts[puantaj_exts_index][10] = '';/*kideme dahil mi ek odenekler icin kullaniliyor*/
				puantaj_exts[puantaj_exts_index][11] = get_tax_exception_boss.yuzde_sinir[i];
				puantaj_exts[puantaj_exts_index][12] = 0;
				if ((vergi_istisna_boss + satir_vergi_istisna_tutari) lt get_insurance.MIN_GROSS_PAYMENT_NORMAL)
					{
					puantaj_exts[puantaj_exts_index][3] = satir_vergi_istisna_tutari;
					vergi_istisna_boss = vergi_istisna_boss + satir_vergi_istisna_tutari;
					}
				else
					{
					puantaj_exts[puantaj_exts_index][3] = get_insurance.MIN_GROSS_PAYMENT_NORMAL - vergi_istisna_boss;
					vergi_istisna_boss = get_insurance.MIN_GROSS_PAYMENT_NORMAL;
					}
				}
			else if(get_tax_exception_boss.is_all_pay[i] eq 1)
				{
				satir_vergi_istisna_tutari = 0;
				if (get_tax_exception_boss.calc_days[i] eq 1) // günlere göre
					satir_vergi_istisna_tutari = (get_tax_exception_boss.amount[i] * (ssk_days/ssk_full_days) );
				else // günlere göre değil
					satir_vergi_istisna_tutari = get_tax_exception_boss.amount[i];

				puantaj_exts_index = puantaj_exts_index + 1;
				puantaj_exts[puantaj_exts_index][1] = get_tax_exception_boss.TAX_EXCEPTION[i];
				puantaj_exts[puantaj_exts_index][2] = 1;
				puantaj_exts[puantaj_exts_index][4] = 0;
				puantaj_exts[puantaj_exts_index][5] = 0;
				puantaj_exts[puantaj_exts_index][6] = 2;
				puantaj_exts[puantaj_exts_index][7] = get_tax_exception_boss.calc_days[i];
				puantaj_exts[puantaj_exts_index][8] = 0;
				puantaj_exts[puantaj_exts_index][9] = '';/*odenek veya kesintinin net/brüt oldugu icin, istisna ile ilgisi yok*/
				puantaj_exts[puantaj_exts_index][10] = '';/*kideme dahil mi ek odenekler icin kullaniliyor*/
				puantaj_exts[puantaj_exts_index][11] = get_tax_exception_boss.yuzde_sinir[i];
				puantaj_exts[puantaj_exts_index][12] = 1;
				
				puantaj_exts[puantaj_exts_index][3] = satir_vergi_istisna_tutari;
				
				vergi_istisna_kesintisiz_boss = vergi_istisna_kesintisiz_boss + satir_vergi_istisna_tutari;
				}
		}
	}
	vergi_istisna_boss = vergi_istisna_boss + vergi_istisna_kesintisiz_boss;
</cfscript>
