<cfscript>
	tck = datediff('yyyy',my_giris_date,my_baz_date) + 1;
	bitis_tarihi_ = createodbcdatetime(date_add("m",get_def_type.limit_1,baslangic_tarih_));
	while(flag)
	{
		baslangic_tarih_ = createodbcdatetime(baslangic_tarih_);
		get_bos_zaman_ = cfquery(Datasource="#dsn#",dbtype="query",sqlstring="SELECT * FROM get_progress_payment_outs WHERE EMP_ID = #employee_id_# AND ((START_DATE <= #baslangic_tarih_# AND FINISH_DATE >= #baslangic_tarih_#) OR (START_DATE >= #baslangic_tarih_# AND FINISH_DATE <= #bitis_tarihi_#) OR ((START_DATE BETWEEN #baslangic_tarih_# AND #bitis_tarihi_#) AND FINISH_DATE >= #bitis_tarihi_#))");
		if(get_bos_zaman_.recordcount eq 0)
		{
			kontrol_date = bitis_tarihi_;
			if(len(get_emp.birth_date) and eklenecek lt get_def_type.min_max_days and (datediff("yyyy",get_emp.birth_date,kontrol_date) lt get_def_type.min_years or datediff("yyyy",get_emp.birth_date,kontrol_date) gt get_def_type.max_years) )
				eklenecek = get_def_type.min_max_days;
			toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
			son_baslangic_ = baslangic_tarih_;
			son_bitis_ = bitis_tarihi_;
		}
		else
		{
			eklenecek_gun = 0;
			for(izd = 1; izd lte get_bos_zaman_.recordcount; izd=izd+1)
			{
				if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) gt 0 and len(get_bos_zaman_.finish_date[izd]))
				{
					fark_ = datediff("d",baslangic_tarih_,get_bos_zaman_.finish_date[izd]);
				}
				else if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) lte 0 and len(get_bos_zaman_.progress_time[izd]))
				{
					fark_ = get_bos_zaman_.progress_time[izd];
				}
				else if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) lte 0 and len(get_bos_zaman_.finish_date[izd]))
				{
					fark_ = datediff("d",get_bos_zaman_.start_date[izd],get_bos_zaman_.finish_date[izd]);
				}
				else
				{
					fark_ = 0;
				}
				eklenecek_gun = eklenecek_gun + fark_;
			}
			bitis_tarihi_ = date_add("d",eklenecek_gun,bitis_tarihi_);
			kontrol_date = bitis_tarihi_;
			if(len(get_emp.birth_date) and eklenecek lt get_def_type.min_max_days and (datediff("yyyy",get_emp.birth_date,kontrol_date) lt get_def_type.min_years or datediff("yyyy",get_emp.birth_date,kontrol_date) gt get_def_type.max_years))
				eklenecek = get_def_type.min_max_days;
			toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
			son_baslangic_ = baslangic_tarih_;
			son_bitis_ = bitis_tarihi_;
		}
		bitis_tarihi_ = date_add("m",get_def_type.limit_1,bitis_tarihi_);
		if(datediff("m",bitis_tarihi_,my_baz_date) lt 0)				
		{
			flag = false;
		}
	}
</cfscript>
