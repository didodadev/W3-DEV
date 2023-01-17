<!--- <cfquery name="upd_" datasource="#dsn#">UPDATE EMPLOYEES_PUANTAJ_ROWS SET SSK_ISVEREN_HISSESI_GOV = 0 WHERE SSK_ISVEREN_HISSESI_GOV IS NULL</cfquery> --->
<cfparam name="attributes.is_virtual_puantaj" default="0">
<cfset main_puantaj_table = "EMPLOYEES_PUANTAJ">
<cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS">
<cfset ext_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_EXT">
<cfset add_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_ADD">
<cfset maas_puantaj_table = "EMPLOYEES_SALARY">
<cfparam name="icmal_border" default="1">
<cfif not evaluate("#query_name#.recordcount")>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='58486.Kayıt bulunamadı'>!");
		history.back();
	</script>
	<cfexit method="exittemplate">
</cfif>

<cfscript>
	if (get_program_parameters.SSK_31_DAYS eq 1)
		all_days = daysinmonth(bu_ay_sonu);
	else
		all_days = 30;

	t_ssk_matrahi = 0;
	t_sgdp_devir = 0; // Sosyal güvenlik destek primi 
	t_ssk_matrahi_devirsiz = 0;
	t_devreden = 0;
	t_devirden_gelen = 0;
	t_toplam_kazanc = 0;
	t_vergi_indirimi = 0;
	t_vergi_iadesi = 0;
	t_vergi_iadesi_alan = 0;
	t_vergi_indirimi_5084 = 0;
	t_vergi_indirimi_5746 = 0;
	t_mahsup_g_vergisi = 0;
	t_kum_gelir_vergisi_matrahi = 0;
	t_gelir_vergisi_matrahi = 0;
	t_gelir_vergisi = 0;
	t_damga_vergisi = 0;
	t_damga_vergisi_matrahi = 0;
	t_kesinti = 0;
	t_net_ucret = 0;
	t_ssk_primi_isci = 0;
	t_ssk_primi_isci_devirsiz = 0;
	t_ssk_primi_isveren_hesaplanan = 0;
	t_ssk_primi_isveren = 0;
	t_ssk_primi_isveren_gov = 0;
	t_ssk_primi_isveren_5510 = 0;
	t_ssk_primi_isveren_5084 = 0;
	t_ssk_primi_isveren_5921 = 0;
	t_ssk_primi_isveren_5746 = 0;
	t_ssk_primi_isveren_6111 = 0;
	t_issizlik_isci_hissesi = 0;
	t_issizlik_isci_hissesi_devirsiz = 0;
	t_issizlik_isveren_hissesi = 0;
	t_ozel_kesinti = 0;
	t_ssk_days = 0;
	t_ssk_ssk_days = 0;
	t_ext_work_days = 0;
	t_ext_work_days_2 = 0;
	t_ext_work_hours_0 = 0;
	t_ext_work_hours_1 = 0;
	t_ext_work_hours_2 = 0;
	t_ext_work_hours_5 = 0;
	t_ext_work_hours_8 = 0;
	t_ext_work_hours_9 = 0;
	t_ext_work_hours_10 = 0;
	t_ext_work_hours_11 = 0;
	t_ext_work_hours_12 = 0;
	t_sundays = 0;
	t_offdays = 0;
	t_offdays_amount = 0;
	t_offdays_sundays = 0;
	t_paid_izinli_sundays = 0;
	t_izinli_sundays = 0;
	t_izin = 0;
	t_izin_amount = 0;
	t_paid_izin = 0;
	t_ssk_paid_izin = 0;
	t_ssdf_paid_izin = 0;
	t_ssk_paid_izin_amount = 0;
	t_ssdf_paid_izin_amount = 0;
	ssk_count = 0;
	t_ssdf_ssk_days = 0;
	t_ssdf_days = 0;
	t_ssdf_izin_days = 0;
	t_ssdf_izin_amount = 0;
	t_ssdf_matrah = 0;
	t_ssdf_isci_hissesi = 0;
	t_ssdf_isveren_hissesi = 0;
	t_sakatlik = 0;
	t_gocmen_indirimi = 0;
	t_ext_salary = 0;
	t_ext_salary_0 = 0;
	t_ext_salary_1 = 0;
	t_ext_salary_2 = 0;
	t_ext_salary_3 = 0;
	t_ext_salary_5 = 0;
	t_avans = 0;
	ssdf_say = 0;
	ssk_say = 0;
	sakat_say = 0;
	gocmen_say = 0;
	if (isnumeric(get_kumulatif_gelir_vergisi.TOPLAM))
		t_kum_gelir_vergisi = get_kumulatif_gelir_vergisi.TOPLAM;
	else
		t_kum_gelir_vergisi = 0;
	t_total_pay_ssk_tax = 0;
	t_total_pay_ssk = 0;
	t_total_pay_tax = 0;
	t_total_pay = 0;
	
	t_ssdf_mesai_amount = 0;
	t_ssdf_sunday_amount = 0;
	t_ssk_mesai_amount = 0;
	T_SSK_SUNDAY_AMOUNT = 0;
	
	
	t_kidem_amount = 0;
	t_ihbar_amount = 0;
	t_yillik_izin_amount = 0;
	
	t_normal_gun = 0;
	t_haftalik_tatil = 0;
	
	eksi_ssk = 0;
	eksi_ssk_paid_izin = 0;
	t_vergi_istisna_yaz = 0;
	t_vergi_istisna_net_yaz = 0;
	t_vergi_istisna_tutar = 0;
	
	t_total_saat = 0;
	
	t_yillik_izin = 0;

	/* 20040824 simdilik yok bkz satir 119
	t_kidem_isci_payi = 0;
	t_kidem_isveren_payi = 0;
	*/
</cfscript>
<cfif icmal_type is 'genel' and (not isdefined("attributes.func_id") or (isdefined("attributes.func_id") and not len(attributes.func_id)))>
	<cfquery name="GET_OLD_PUANTAJ" datasource="#dsn#" maxrows="1">
		SELECT
			PUANTAJ_ID
		FROM
			#main_puantaj_table# EP,
			BRANCH B
		WHERE
			<cfif isdefined("attributes.branch_id") and listlen(attributes.branch_id)>
			B.BRANCH_ID IN (#attributes.branch_id#) AND
			</cfif>
			EP.SAL_MON < #attributes.SAL_MON# AND
			EP.SAL_YEAR = <cfif isdefined("attributes.sal_year") and isnumeric(attributes.sal_year)>#attributes.sal_year#<cfelse>#session.ep.period_year#</cfif> AND
			EP.SSK_OFFICE = B.SSK_OFFICE AND
			EP.SSK_OFFICE_NO = B.SSK_NO
		ORDER BY SAL_MON DESC
	</cfquery>
	<cfif GET_OLD_PUANTAJ.recordcount>
		<cfquery name="GET_OLD_PUANTAJ_ROWS" datasource="#dsn#">
			SELECT
				SUM(EPR.KUMULATIF_GELIR_MATRAH) AS KUM_TOPLAM,
				SUM(EPR.GELIR_VERGISI) AS GELIR_TOPLAM
			FROM
				#row_puantaj_table# EPR
			WHERE
				EPR.PUANTAJ_ID = #GET_OLD_PUANTAJ.PUANTAJ_ID#
		</cfquery>
		<cfif GET_OLD_PUANTAJ_ROWS.RECORDCOUNT and len(GET_OLD_PUANTAJ_ROWS.KUM_TOPLAM)>
			<cfset onceki_donem_kum_gelir_vergisi_matrahi = GET_OLD_PUANTAJ_ROWS.KUM_TOPLAM>
			<cfset onceki_donem_kum_gelir_vergisi = GET_OLD_PUANTAJ_ROWS.GELIR_TOPLAM>
		</cfif>
	</cfif>
</cfif>

<cfset bu_ay_basi = createdate(attributes.sal_year,attributes.sal_mon, 1)>
<cfset bu_ay_sonu = date_add('s',-1,date_add('m',1,bu_ay_basi))>

<cfquery name="get_izins" datasource="#dsn#">
	SELECT
		OFFTIME.EMPLOYEE_ID,
		OFFTIME.STARTDATE,
		OFFTIME.FINISHDATE,
		SETUP_OFFTIME.EBILDIRGE_TYPE_ID,
		SETUP_OFFTIME.IS_YEARLY,
		SETUP_OFFTIME.SIRKET_GUN,
		SETUP_OFFTIME.IS_PAID
	FROM
		OFFTIME,SETUP_OFFTIME
	WHERE
		SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID AND
		OFFTIME.VALID = 1 AND
		OFFTIME.STARTDATE <= #bu_ay_sonu# AND
		OFFTIME.FINISHDATE >= #bu_ay_basi# AND 
		OFFTIME.IS_PUANTAJ_OFF = 0
	ORDER BY
		OFFTIME.EMPLOYEE_ID
</cfquery>

<cfoutput query="#query_name#">
	<cfscript>
	fazla_mesai_resmi_tatil = 0;
	fazla_mesai_hafta_ici = 0;
	fazla_mesai_hafta_sonu = 0;
	fazla_mesai_gece_calismasi = 0;
	fazla_mesai_hafta_sonu_gun=0;
	fazla_mesai_arafe_gun=0;
	fazla_mesai_akdi_gun=0;
	fazla_mesai_resmi_tatil_gun=0;
	fazla_mesai_dini_gun=0;
	//if(total_days gt 0)
	{
		if(salary_type eq 0)
		{
			ucret = TOTAL_SALARY - TOTAL_PAY_SSK_TAX - TOTAL_PAY_SSK - TOTAL_PAY_TAX - TOTAL_PAY - ext_salary - IHBAR_AMOUNT - KIDEM_AMOUNT - YILLIK_IZIN_AMOUNT + ozel_kesinti_2;
			ucret_bas = salary;
			if(total_days gt 0)
				ucret = ucret / total_days * all_days;
			t_total_saat = t_total_saat + total_hours;

		}
		else if(salary_type eq 1)
		{
			ucret = TOTAL_SALARY - TOTAL_PAY_SSK_TAX - TOTAL_PAY_SSK - TOTAL_PAY_TAX - TOTAL_PAY - ext_salary - IHBAR_AMOUNT - KIDEM_AMOUNT - YILLIK_IZIN_AMOUNT + ozel_kesinti_2;
			ucret_bas = salary;
			if(total_days gt 0)
				ucret = ucret / total_days * all_days;
			else
				ucret = 0;
		}
		else if(salary_type eq 2)
		{
			ucret = TOTAL_SALARY - TOTAL_PAY_SSK_TAX - TOTAL_PAY_SSK - TOTAL_PAY_TAX - TOTAL_PAY - ext_salary - IHBAR_AMOUNT - KIDEM_AMOUNT - YILLIK_IZIN_AMOUNT + ozel_kesinti_2;
			if(total_days gt 0)
				ucret = wrk_round((ucret/total_days)*all_days,2);
			else
				ucret = 0;
			ucret_bas = salary;
		}

		t_vergi_istisna_net_yaz = t_vergi_istisna_net_yaz + VERGI_ISTISNA_TOTAL;
		t_vergi_istisna_tutar = t_vergi_istisna_tutar + VERGI_ISTISNA_DAMGA_NET;
		t_vergi_istisna_yaz = t_vergi_istisna_yaz + VERGI_ISTISNA_SSK + VERGI_ISTISNA_VERGI + VERGI_ISTISNA_DAMGA;
		t_kidem_amount = t_kidem_amount + KIDEM_AMOUNT;
		t_ihbar_amount = t_ihbar_amount + IHBAR_AMOUNT;
		t_yillik_izin_amount = t_yillik_izin_amount + YILLIK_IZIN_AMOUNT;
		total_salary_ = TOTAL_SALARY - (EXT_SALARY + total_pay_ssk_tax + total_pay_tax + total_pay_ssk + total_pay);
		t_toplam_kazanc = t_toplam_kazanc + total_salary_;
		t_vergi_indirimi = t_vergi_indirimi + vergi_indirimi;
		t_vergi_indirimi_5084 = t_vergi_indirimi_5084 + vergi_indirimi_5084;
		t_vergi_indirimi_5746 = t_vergi_indirimi_5746 + gelir_vergisi_indirimi_5746;
		t_kum_gelir_vergisi_matrahi = t_kum_gelir_vergisi_matrahi + KUMULATIF_GELIR_MATRAH - gelir_vergisi_matrah;
		if(IS_START_CUMULATIVE_TAX eq 1 and isnumeric(START_CUMULATIVE_TAX))
			t_kum_gelir_vergisi = t_kum_gelir_vergisi + START_CUMULATIVE_TAX;
		t_gelir_vergisi_matrahi = t_gelir_vergisi_matrahi + gelir_vergisi_matrah;
		t_gelir_vergisi = t_gelir_vergisi + gelir_vergisi;
		t_damga_vergisi = t_damga_vergisi + damga_vergisi;
		t_kesinti = t_kesinti + ssk_isci_hissesi + ssdf_isci_hissesi + issizlik_isci_hissesi + damga_vergisi;
		t_net_ucret = t_net_ucret + net_ucret;
		if(len(mahsup_g_vergisi))
			t_mahsup_g_vergisi = t_mahsup_g_vergisi + mahsup_g_vergisi;
		else
			mahsup_g_vergisi = 0;
		t_vergi_iadesi = t_vergi_iadesi + vergi_iadesi;
		if(len(vergi_iadesi))
			t_vergi_iadesi_alan = t_vergi_iadesi_alan + 1;
		/* 20040824 simdilik yok (kidem_boss ve kidem_worker kolonlari db de puantaj_row da var) bkz satir 81
		t_kidem_isveren_payi = t_kidem_isveren_payi + kidem_boss;
		t_kidem_isci_payi = t_kidem_isci_payi + kidem_worker;
		*/
		t_ozel_kesinti = t_ozel_kesinti + ozel_kesinti + ozel_kesinti_2;
		if (SAKATLIK_INDIRIMI gt 0)
		{
			t_sakatlik = t_sakatlik + SAKATLIK_INDIRIMI;
			sakat_say = sakat_say + 1;
		}
		if (GOCMEN_INDIRIMI gt 0)
		{
			t_gocmen_indirimi = t_gocmen_indirimi + GOCMEN_INDIRIMI;
			gocmen_say = gocmen_say + 1;
		}
		t_damga_vergisi_matrahi = t_damga_vergisi_matrahi + DAMGA_VERGISI_MATRAH ;//+ total_pay
		// fazle mesai özel
		/*c1 = (get_program_parameters.EX_TIME_PERCENT);
		c2 = (get_program_parameters.EX_TIME_PERCENT_HIGH);*/
		fazla_mesai_hafta_ici = (EXT_TOTAL_HOURS_0-EXT_TOTAL_HOURS_3) * get_program_parameters.EX_TIME_PERCENT / 100;
		
		if(len(get_program_parameters.WEEKEND_MULTIPLIER)) // Hafta Tatili
			fazla_mesai_hafta_sonu = (EXT_TOTAL_HOURS_1 * get_program_parameters.WEEKEND_MULTIPLIER);
		else
			fazla_mesai_hafta_sonu = (EXT_TOTAL_HOURS_1 * get_program_parameters.EX_TIME_PERCENT / 100);

//		if(len(get_program_parameters.WEEKEND_MULTIPLIER)) // Gece Çalışması
//			fazla_mesai_gece_calismasi = (EXT_TOTAL_HOURS_5 * get_program_parameters.WEEKEND_MULTIPLIER);
//		else
//			fazla_mesai_gece_calismasi = (EXT_TOTAL_HOURS_5 * get_program_parameters.EX_TIME_PERCENT / 100);

		fazla_mesai_gece_calismasi = (EXT_TOTAL_HOURS_5 * 10 / 100);
		
		if(len(get_program_parameters.OFFICIAL_MULTIPLIER))	
			fazla_mesai_resmi_tatil = EXT_TOTAL_HOURS_2 * get_program_parameters.OFFICIAL_MULTIPLIER; // resmi tatil
		else
			fazla_mesai_resmi_tatil = EXT_TOTAL_HOURS_2 * 100 / 100; // resmi tatil

				//----Muzaffer Bas---

		if(len(get_program_parameter.WEEKEND_DAY_MULTIPLIER))
		   fazla_mesai_hafta_sonu_gun=EXT_TOTAL_HOURS_8 * get_program_parameter.WEEKEND_DAY_MULTIPLIER;  //Hafta sonu Fazla Mesai Gün
		else 
		   fazla_mesai_hafta_sonu_gun=EXT_TOTAL_HOURS_8 * EX_TIME_PERCENT/100;                            //Hafta sonu Fazla Mesai Gün

		 if(len(get_program_parameter.AKDI_DAY_MULTIPLIER))
		   fazla_mesai_akdi_gun=EXT_TOTAL_HOURS_9 * get_program_parameter.AKDI_DAY_MULTIPLIER;   //Akdi Fazla Mesai Gün
		else 
		   fazla_mesai_akdi_gun=EXT_TOTAL_HOURS_9 * EX_TIME_PERCENT/100;                         //Akdi Fazla Mesai Gün	
		   
		if(len(get_program_parameter.OFFICIAL_DAY_MULTIPLIER))
		   fazla_mesai_resmi_tatil_gun=EXT_TOTAL_HOURS_10 * get_program_parameter.OFFICIAL_DAY_MULTIPLIER;  //Resmi Fazla Mesai Gün
		else 
		   fazla_mesai_resmi_tatil_gun=EXT_TOTAL_HOURS_10 * EX_TIME_PERCENT/100;                            //Resmi Fazla Mesai Gün	

		if(len(get_program_parameter.ARAFE_DAY_MULTIPLIER))
		   fazla_mesai_arafe_gun=EXT_TOTAL_HOURS_11 * get_program_parameter.ARAFE_DAY_MULTIPLIER;     //Arafe Fazla Mesai Gün
		else 
		   fazla_mesai_arafe_gun=EXT_TOTAL_HOURS_11 * EX_TIME_PERCENT/100;                            //Arafe Fazla Mesai Gün

		if(len(get_program_parameter.DINI_DAY_MULTIPLIER))
		   fazla_mesai_dini_gun=EXT_TOTAL_HOURS_12 * get_program_parameter.DINI_DAY_MULTIPLIER;       //Dini Bayram Fazla Mesai Gün
		else 
		   fazla_mesai_dini_gun=EXT_TOTAL_HOURS_12 * EX_TIME_PERCENT/100;                             //Dini Bayram Fazla Mesai Gün
		
		fazla_mesai_45 = EXT_TOTAL_HOURS_3 * get_program_parameters.EX_TIME_PERCENT_HIGH / 100;// 45 saati asan kisim
		fazla_mesai_toplam =fazla_mesai_hafta_sonu_gun + fazla_mesai_akdi_gun + fazla_mesai_resmi_tatil_gun  + fazla_mesai_arafe_gun + fazla_mesai_dini_gun + fazla_mesai_hafta_ici + fazla_mesai_hafta_sonu + fazla_mesai_resmi_tatil + fazla_mesai_45 + fazla_mesai_gece_calismasi;

	  //----Muzaffer Bitiş---

			
		fazla_mesai_45 = EXT_TOTAL_HOURS_3 * get_program_parameters.EX_TIME_PERCENT_HIGH / 100;// 45 saati asan kisim
		fazla_mesai_toplam = fazla_mesai_hafta_ici + fazla_mesai_hafta_sonu + fazla_mesai_resmi_tatil + fazla_mesai_45 + fazla_mesai_gece_calismasi;
		if (fazla_mesai_toplam neq 0)
		{
			t_ext_salary_0 = t_ext_salary_0 + ((EXT_SALARY/fazla_mesai_toplam) * (fazla_mesai_hafta_ici + fazla_mesai_45));
			t_ext_salary_1 = t_ext_salary_1 + ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_hafta_sonu);
			t_ext_salary_2 = t_ext_salary_2 + ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_resmi_tatil);
			t_ext_salary_5 = t_ext_salary_5 + ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_gece_calismasi); // Gece Çalışması Ücreti
		}
		t_ext_Salary = t_ext_salary_0 + t_ext_salary_1 + t_ext_salary_2 + t_ext_salary_5;
		t_avans = t_avans + AVANS;
		t_ext_work_days_1 = t_ext_work_days + ((EXT_TOTAL_HOURS_0 + EXT_TOTAL_HOURS_1) / SSK_WORK_HOURS);
		t_ext_work_days_2 = t_ext_work_days_2 + ((EXT_TOTAL_HOURS_2) / SSK_WORK_HOURS);
		t_ext_work_hours_0 = t_ext_work_hours_0 + EXT_TOTAL_HOURS_0;
		t_ext_work_hours_1 = t_ext_work_hours_1 + EXT_TOTAL_HOURS_1;
		t_ext_work_hours_2 = t_ext_work_hours_2 + EXT_TOTAL_HOURS_2;
		t_ext_work_hours_5 = t_ext_work_hours_5 + EXT_TOTAL_HOURS_5;

		//---Muzaffer Bas---
		
		if(len(EXT_TOTAL_HOURS_8))t_ext_work_hours_8 = t_ext_work_hours_8 + EXT_TOTAL_HOURS_8;		
		if(len(EXT_TOTAL_HOURS_9))t_ext_work_hours_9 = t_ext_work_hours_9 + EXT_TOTAL_HOURS_9;
		if(len(EXT_TOTAL_HOURS_10))t_ext_work_hours_10 = t_ext_work_hours_10 + EXT_TOTAL_HOURS_10;
		if(len(EXT_TOTAL_HOURS_11))t_ext_work_hours_11 = t_ext_work_hours_11 + EXT_TOTAL_HOURS_11;
		if(len(EXT_TOTAL_HOURS_12))t_ext_work_hours_12 = t_ext_work_hours_12 + EXT_TOTAL_HOURS_12;
		
		//---Muzaffer Bitis---

		t_ext_work_days = t_ext_work_days_1 + t_ext_work_days_2;
		t_sundays = t_sundays + SUNDAY_COUNT;
		t_offdays = t_offdays + OFFDAYS_COUNT;
		t_offdays_sundays = t_offdays_sundays + OFFDAYS_SUNDAY_COUNT;
		if (isnumeric(PAID_IZINLI_SUNDAY_COUNT))
			t_paid_izinli_sundays = t_paid_izinli_sundays + PAID_IZINLI_SUNDAY_COUNT;
		else
			PAID_IZINLI_SUNDAY_COUNT = 0;
			
		if (isnumeric(IZINLI_SUNDAY_COUNT))
			t_izinli_sundays = t_izinli_sundays + IZINLI_SUNDAY_COUNT;
		else
			IZINLI_SUNDAY_COUNT = 0;
		
		ssk_devir_toplam = 0;
	
		if(len(ssk_devir))
		{
			ssk_devir_toplam = ssk_devir_toplam + ssk_devir;
			t_devirden_gelen = t_devirden_gelen + ssk_devir;
		}
			
		if(len(ssk_devir_last))
		{
			ssk_devir_toplam = ssk_devir_toplam + ssk_devir_last;
			t_devirden_gelen = t_devirden_gelen + ssk_devir_last;
		}
	
		kisi_yillik_izin_gunu = 0;
		
		if(izin_paid gt 0)
		{
			if(isdefined("attributes.employee_id"))
				get_emp_izins_yillik = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID,STARTDATE,FINISHDATE FROM get_izins WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND IS_YEARLY = 1");
			else
				get_emp_izins_yillik = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID,STARTDATE,FINISHDATE FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND IS_YEARLY = 1");
		
			if(get_emp_izins_yillik.recordcount)
			{
				for(k=1; k lte get_emp_izins_yillik.recordcount; k=k+1)
				{
					yillik_gun_farki = datediff('d',get_emp_izins_yillik.STARTDATE[k],get_emp_izins_yillik.FINISHDATE[k]);
					kisi_yillik_izin_gunu = kisi_yillik_izin_gunu + yillik_gun_farki + 1;
				}
			}
		}
		t_yillik_izin = t_yillik_izin + kisi_yillik_izin_gunu;
			
		if(izin_paid gt 0)
		{
			/*
			if(isdefined("attributes.employee_id"))
				get_emp_rapors = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID,STARTDATE,FINISHDATE FROM get_izins WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND SIRKET_GUN > 0");
			else
				get_emp_rapors = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID,STARTDATE,FINISHDATE FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
			
			active_report_izins = 0;
			
			for(emp_rapor=1;emp_rapor lte get_emp_rapors.recordcount;emp_rapor=emp_rapor+1)			
				{
				if(datediff("d",bu_ay_basi,get_emp_rapors.STARTDATE[emp_rapor]) gte 0)
					{
					if(datediff("d",get_emp_rapors.STARTDATE[emp_rapor],get_emp_rapors.FINISHDATE[emp_rapor]) gt 0)
						{
							if(day(get_emp_rapors.STARTDATE[emp_rapor]) eq day(bu_ay_sonu) and month(get_emp_rapors.STARTDATE[emp_rapor]) eq month(bu_ay_sonu))
							{
								active_report_izins = active_report_izins + 0.5;
							}
							else if(month(get_emp_rapors.STARTDATE[emp_rapor]) lt month(bu_ay_basi) and datediff("d",get_emp_rapors.STARTDATE[emp_rapor],bu_ay_basi) gte 1)
							{
								//
							}
							else if(month(get_emp_rapors.STARTDATE[emp_rapor]) lt month(bu_ay_basi) and datediff("d",get_emp_rapors.STARTDATE[emp_rapor],bu_ay_basi) eq 0)
							{
								active_report_izins = active_report_izins + 0.5;
							}
							else
							{
								active_report_izins = active_report_izins + 1;
							}
						}
					else
						{
						active_report_izins = active_report_izins + 0.5;
						}
					}
				}
			*/
			ucretli_izin_gunu = izin_paid;	
		}
		else
		{
			ucretli_izin_gunu = 0;
		}
			
		if(ucretli_izin_gunu lt 0)
			ucretli_izin_gunu = 0;
			
		
		if (ssdf_isveren_hissesi gt 0)/* ssk li emekliler icin*/
		{
			ssdf_say = ssdf_say + 1;
			t_ssdf_izin_days = t_ssdf_izin_days + izin;
			t_ssdf_paid_izin = t_ssdf_paid_izin + ucretli_izin_gunu ;
			t_ssdf_izin_amount = t_ssdf_izin_amount + (ucret * (izin/all_days));
			t_ssdf_paid_izin_amount = t_ssdf_paid_izin_amount + ((ucretli_izin_gunu/all_days) * ucret);
			
			
			haftalik_tatil_ = sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count;
			t_haftalik_tatil = t_haftalik_tatil + haftalik_tatil_;
			t_ssdf_sunday_amount = t_ssdf_sunday_amount + ((haftalik_tatil_ / all_days) * ucret);
			
			normal_gun_ = total_days - haftalik_tatil_ - ucretli_izin_gunu - OFFDAYS_COUNT;
			t_normal_gun = t_normal_gun + normal_gun_;
			t_ssdf_mesai_amount = t_ssdf_mesai_amount + ((normal_gun_ / all_days) * ucret);
			
			t_offdays_amount = t_offdays_amount + ((OFFDAYS_COUNT/all_days)*ucret);
			t_ssdf_ssk_days = t_ssdf_ssk_days + total_days;
			t_ssdf_days = t_ssdf_days + total_days - sunday_count;
			t_ssdf_matrah = t_ssdf_matrah + SSK_MATRAH;
			t_ssdf_isci_hissesi = t_ssdf_isci_hissesi + ssdf_isci_hissesi;
			t_ssdf_isveren_hissesi = t_ssdf_isveren_hissesi + ssdf_isveren_hissesi;
			if(len(SSK_ISCI_HISSESI_DUSULECEK))
			t_sgdp_devir = t_sgdp_devir + SSK_ISCI_HISSESI_DUSULECEK;
			//if(session.ep.admin eq 1) writeoutput('Emekli:#employee_name# #employee_surname#-t_ssdf_mesai_amount:#( ((total_days-(sunday_count-OFFDAYS_SUNDAY_COUNT)-offdays_count+paid_izinli_sunday_count-ucretli_izin_gunu) / all_days) * ucret )#,t_ssdf_sunday_amount:#( ((sunday_count-paid_izinli_sunday_count-offdays_sunday_count) / all_days) * ucret )#,ucret:#ucret#<br/>');
		}
		else
		{/* emekli olmayan ama kazanci olan kisiler gelsin (ssk li veya degil), ucretlere ait bilgiler hesaplansin*/
			t_izin = t_izin + izin;
			t_ssk_paid_izin = t_ssk_paid_izin + ucretli_izin_gunu ;
			t_izin_amount = t_izin_amount + (ucret * (izin/all_days));
			t_ssk_paid_izin_amount = t_ssk_paid_izin_amount + ((ucretli_izin_gunu/all_days) * ucret); 
			
			haftalik_tatil_ = sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count;
			t_haftalik_tatil = t_haftalik_tatil + haftalik_tatil_;
			t_ssk_sunday_amount = t_ssk_sunday_amount + ((haftalik_tatil_ / all_days) * ucret);
			
			normal_gun_ = total_days - haftalik_tatil_ - ucretli_izin_gunu - OFFDAYS_COUNT;
			t_normal_gun = t_normal_gun + normal_gun_;
			t_ssk_mesai_amount = t_ssk_mesai_amount + ((normal_gun_/ all_days) * ucret);
			
			t_offdays_amount = t_offdays_amount + ((OFFDAYS_COUNT/all_days)*ucret);
			t_ssk_ssk_days = t_ssk_ssk_days + total_days;
			t_ssk_days = t_ssk_days + total_days - sunday_count;
			
			if (use_ssk eq 1)
			{
				ssk_say = ssk_say + 1;
				t_ssk_matrahi = t_ssk_matrahi + SSK_MATRAH;
				t_ssk_matrahi_devirsiz = t_ssk_matrahi_devirsiz + SSK_MATRAH - ssk_devir_toplam;		
				t_ssk_primi_isci = t_ssk_primi_isci + ssk_isci_hissesi;
				t_ssk_primi_isveren = t_ssk_primi_isveren + ssk_isveren_hissesi;
				
				isveren_hesaplanan = ssk_isveren_hissesi + ssk_isveren_hissesi_5510 + ssk_isveren_hissesi_5084;
				t_ssk_primi_isveren_hesaplanan = t_ssk_primi_isveren_hesaplanan + isveren_hesaplanan;
				
				t_ssk_primi_isveren_5510 = t_ssk_primi_isveren_5510 + ssk_isveren_hissesi_5510;
				t_ssk_primi_isveren_5084 = t_ssk_primi_isveren_5084 + ssk_isveren_hissesi_5084;
							
				t_ssk_primi_isveren_5921 = t_ssk_primi_isveren_5921 + ssk_isveren_hissesi_5921;
				t_ssk_primi_isveren_5746 = t_ssk_primi_isveren_5746 + ssk_isveren_hissesi_5746;
	
				if(len(ssk_isveren_hissesi_gov))
					t_ssk_primi_isveren_gov = t_ssk_primi_isveren_gov + ssk_isveren_hissesi_gov;
				else
					t_ssk_primi_isveren_gov = t_ssk_primi_isveren_gov + 0;
	
				
				t_issizlik_isci_hissesi = t_issizlik_isci_hissesi + issizlik_isci_hissesi;
				
				if(issizlik_isci_hissesi gt 0 and ssk_devir_toplam gt 0)
					t_issizlik_isci_hissesi_devirsiz = t_issizlik_isci_hissesi_devirsiz + wrk_round((SSK_MATRAH - ssk_devir_toplam) * 1 / 100);
				else
					t_issizlik_isci_hissesi_devirsiz = t_issizlik_isci_hissesi_devirsiz + issizlik_isci_hissesi;

				if(ssk_isci_hissesi gt 0 and ssk_devir_toplam gt 0)
					t_ssk_primi_isci_devirsiz = t_ssk_primi_isci_devirsiz + wrk_round((SSK_MATRAH - ssk_devir_toplam) * 14 / 100);
				else
					t_ssk_primi_isci_devirsiz = t_ssk_primi_isci_devirsiz + ssk_isci_hissesi;
					
	
				t_issizlik_isveren_hissesi = t_issizlik_isveren_hissesi + issizlik_isveren_hissesi;
				//if(session.ep.admin eq 1) writeoutput('SSKli:#employee_name# #employee_surname#-t_ssk_mesai_amount:#( ((total_days-(sunday_count-OFFDAYS_SUNDAY_COUNT)-offdays_count+paid_izinli_sunday_count-ucretli_izin_gunu) / all_days) * ucret )#,t_ssk_sunday_amount:#( ((sunday_count-paid_izinli_sunday_count-offdays_sunday_count) / all_days) * ucret )#,ucret:#ucret#<br/>');
			}
			else
			{/*ssk li olmayan diger sosyal guvenlik kurumuna tabi ise asagida toplam gunden cikacak gun sayisi bulunuyor*/
				eksi_ssk = eksi_ssk + total_days;
				eksi_ssk_paid_izin = eksi_ssk_paid_izin + ucretli_izin_gunu;
				//if(session.ep.admin eq 1) writeoutput('Diğer:#employee_name# #employee_surname#-t_ssk_mesai_amount:#( ((total_days-(sunday_count-OFFDAYS_SUNDAY_COUNT)-offdays_count+paid_izinli_sunday_count-ucretli_izin_gunu) / all_days) * ucret )#,t_ssk_sunday_amount:#( ((sunday_count-paid_izinli_sunday_count-offdays_sunday_count) / all_days) * ucret )#,ucret:#ucret#<br/>');
			}
		}
		t_total_pay_ssk_tax = t_total_pay_ssk_tax + total_pay_ssk_tax;
		t_total_pay_ssk = t_total_pay_ssk + total_pay_ssk;
		t_total_pay_tax = t_total_pay_tax + total_pay_tax;
		t_total_pay = t_total_pay + total_pay;
	}
	</cfscript>
	<cfquery name="get_devreden" datasource="#dsn#">
		SELECT 
			AMOUNT 
		FROM 
			EMPLOYEES_PUANTAJ_ROWS_ADD 
		WHERE 
			EMPLOYEE_PUANTAJ_ID = #EMPLOYEE_PUANTAJ_ID# AND 
			SAL_MON = #attributes.sal_mon# AND 
			SAL_YEAR = #attributes.sal_year#
	</cfquery>
	<cfif get_devreden.recordcount>
		<cfset t_devreden = t_devreden + get_devreden.AMOUNT>
	</cfif>
</cfoutput>
<cfscript>
	t_paid_izin = t_ssk_paid_izin + t_ssdf_paid_izin;
	toplam_gun = t_ssk_days + t_ssdf_days + t_sundays;
	normal_gun = t_normal_gun;
	normal_amount = t_ssk_mesai_amount + t_ssdf_mesai_amount;
	haftalik_tatil = t_haftalik_tatil;
	haftalik_tatil_amount = t_ssdf_sunday_amount + t_ssk_sunday_amount;
	if(haftalik_tatil lt 0)
	{
		haftalik_tatil = 0;
		haftalik_tatil_amount = 0;
	}
	/*
	if(normal_gun eq (t_ssk_days + t_ssdf_days))
		{
		genel_tatil = 0;
		genel_tatil_amount = 0;
		}
	else
	*/		
	{
		genel_tatil = t_offdays;
		genel_tatil_amount = t_offdays_amount;
	}
	if(normal_gun lt 0)
	{
		genel_tatil = 0;
		normal_gun = 0;
	}
</cfscript>

<table width="700" border="<cfoutput>#icmal_border#</cfoutput>" cellspacing="0" cellpadding="0" align="center" bordercolor="#CCCCCC"> 
  <tr>
    <td width="50%">
	<b><cf_get_lang dictionary_id="58485.Şirket Adı"> :</b>
	<cfif icmal_type is 'personal'>
		<cfoutput>#GET_PUANTAJ_PERSONAL.COMP_NICK_NAME# - #GET_PUANTAJ_PERSONAL.PUANTAJ_BRANCH_FULL_NAME#</cfoutput>
	<cfelseif icmal_type is 'genel'>
		<cfset o_comp_list = listdeleteduplicates(valuelist(get_puantaj_rows.COMP_NICK_NAME))>
		<cfoutput>#o_comp_list#</cfoutput><br />
		<cfset b_list = listdeleteduplicates(valuelist(get_puantaj_rows.PUANTAJ_BRANCH_FULL_NAME))>
		<cfoutput>#b_list#</cfoutput>
	<cfelseif icmal_type is 'masraf merkezi'>
		<cfif Len(attributes.ssk_office)>
			<cfoutput>#ListLast(attributes.ssk_office, '-')# - #ListGetAt(attributes.ssk_office, 3, '-')#</cfoutput>
		</cfif>
	</cfif>
	<cfif isdefined("attributes.department") and listlen(attributes.department)>
		<br />
		<b><cf_get_lang dictionary_id="57572.Departman"> :</b>
		<cfset d_list = listdeleteduplicates(valuelist(get_puantaj_rows.ROW_DEPARTMENT_HEAD))>
		<cfoutput>#d_list#</cfoutput><br />
	</cfif>
	<cfif isdefined("attributes.ssk_statute") and listlen(attributes.ssk_statute)>
		<br />
		<b><cf_get_lang dictionary_id="56407.SGK Statüleri"> :</b>
		<cfset s_list = attributes.ssk_statute>
		<cfloop list="#s_list#" index="ccc">
			<cfoutput>#listgetat(list_ucret_names(),listfindnocase(list_ucret(),ccc,','),'*')#</cfoutput><cfif ccc - 1 neq ListLen(s_list) AND ccc gt 1>,</cfif>
		</cfloop>
	</cfif>
	</td>
    <td width="50%">
	<table cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td>
			<cfoutput>#listgetat(AY_LIST(),attributes.SAL_MON)# #session.ep.period_year#</cfoutput>&nbsp; 
			<cfif not attributes.fuseaction contains "popup_view_price_compass"><cf_get_lang dictionary_id="58584.İcmal"><cfelse><cf_get_lang dictionary_id="52975.Ücret Pusulası"></cfif>
			</td>
			<td  class="txtbold" style="text-align:right;">
			<cfif icmal_type is "personal">
				<cf_get_lang dictionary_id="57572.Departman"> : <cfoutput>#GET_PUANTAJ_PERSONAL.ROW_DEPARTMENT_HEAD#</cfoutput>
			</cfif>
			</td>
		</tr>
	</table>	
	</td>
  </tr>
  <tr>
	<td>
		<cfif icmal_type is "genel">
			<b><cf_get_lang dictionary_id="53725.Şube SGK"> :</b> 
			<cfset s_info_list = listdeleteduplicates(valuelist(get_puantaj_rows.SUBE_SSK_INFO))>
			<cfoutput>#s_info_list#</cfoutput>
		</cfif>
		<cfif icmal_type is "personal">
			<cf_get_lang dictionary_id="53725.Şube SGK"> : <cfoutput>#ssk_m##SSK_JOB##SSK_BRANCH##SSK_BRANCH_OLD##B_SSK_NO##SSK_CITY##SSK_COUNTRY##SSK_CD##SSK_AGENT#</cfoutput><br/>
			<cf_get_lang dictionary_id="32370.Adı Soyadı"> :<cfoutput>#employee_name# #employee_surname#</cfoutput><br/>
			<cf_get_lang dictionary_id="58487.Çalışan No"> :<cfoutput>#EMPLOYEE_NO#</cfoutput>
		</cfif>
		<cfif icmal_type is "genel">
			<br />
			<cfset exp_code_list = listdeleteduplicates(valuelist(get_puantaj_rows.EXP_NAME))>
			<b><cf_get_lang dictionary_id="58460.Masraf Merkezi">:</b> <cfoutput>#exp_code_list#</cfoutput>
		</cfif>
	</td>
    <td>
		<cfif icmal_type is not "personal">
			<b><cf_get_lang dictionary_id="53770.Kişi Sayısı">:</b><cfoutput>#kisi_say#</cfoutput>
		<cfelse>
			<cfset attributes.branch_id = GET_PUANTAJ_PERSONAL.branch_id>
			<cfoutput><cf_get_lang dictionary_id="54265.TC.No">:#GET_PUANTAJ_PERSONAL.tc_identy_no#&nbsp;-&nbsp;&nbsp;<cf_get_lang dictionary_id="55738.Gruba Giriş">:#dateformat(GET_PUANTAJ_PERSONAL.GROUP_STARTDATE,dateformat_style)#<br/>
				-<cf_get_lang dictionary_id="55663.SGK No">:#GET_PUANTAJ_PERSONAL.SOCIALSECURITY_NO#&nbsp;-&nbsp;&nbsp;<cf_get_lang dictionary_id="55098.İşe Giriş">:#dateformat(GET_PUANTAJ_PERSONAL.START_DATE,dateformat_style)#
				<cfif len(GET_PUANTAJ_PERSONAL.FINISH_DATE)>- <cf_get_lang dictionary_id="57431.Çıkış">:#dateformat(GET_PUANTAJ_PERSONAL.FINISH_DATE,dateformat_style)#</cfif>
			</cfoutput>
		</cfif>
	</td>
  </tr>
</table>
<table width="700" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#CCCCCC"> 
  <tr class="txtbold">
    <td width="25%" valign="top"><table width="100%" border="<cfoutput>#icmal_border#</cfoutput>" cellspacing="0" cellpadding="0" align="center" bordercolor="#CCCCCC">
	  <tr class="txtbold" height="25">
		<td><cf_get_lang dictionary_id="53777.Kazançlar"></td>
		<td><cf_get_lang dictionary_id="57491.Saat"></td>
		<td><cf_get_lang dictionary_id="57673.Tutar"></td>
	  </tr>
	<cfscript>
		if (gross_net neq 1) // Brüt (0) ise
		{
			ucret_yaz = TLFormat(ucret_bas);
			normal_gun_ucret = work_day_hour * ucret_bas;
			ht_ucret = sunday_count_hour * ucret_bas;
			gt_ucret = offdays_count_hour * ucret_bas;
			izin_ucret = izin_count * ucret_bas;
			izin_paid_ucret = (izin_paid_count-paid_izinli_sunday_count_hour) * ucret_bas;
			paid_izin_ht_ucret = paid_izinli_sunday_count_hour * ucret_bas;
		}
		else
		{
			// Net olması halinde, Net ücretin Brüt e çevrilmesi gerekiyor. Melihle çalışma yapılacak.
			ucret_yaz = 0; //TLFormat(get_kisi_maas.AY_MAAS);
			normal_gun_ucret = 0;
			ht_ucret = 0;
			gt_ucret = 0;
			izin_ucret = 0;
			izin_paid_ucret = 0;
			paid_izin_ht_ucret = 0;
		}
		toplam_ucret = normal_gun_ucret + ht_ucret + gt_ucret + izin_paid_ucret;
	</cfscript>
	<cfif t_paid_izin gt 0>
		<cfset ucretli_izin_amount = t_ssdf_paid_izin_amount + t_ssk_paid_izin_amount>
	<cfelse>
		<cfset ucretli_izin_amount = 0>
	</cfif>
	<cfset toplam_salary = wrk_round(t_yillik_izin_amount) + wrk_round(t_kidem_amount) + wrk_round(t_ihbar_amount) + wrk_round(gt_ucret) + wrk_round(normal_gun_ucret) + wrk_round(ht_ucret) + wrk_round(izin_paid_ucret) + wrk_round(t_ext_salary_0) + wrk_round(t_ext_salary_1) + wrk_round(t_ext_salary_2) + wrk_round(t_ext_salary_5)>
	<cfif icmal_type is "personal">
	<cfif gross_net eq 1>
		<cfquery name="get_kisi_maas" datasource="#dsn#">
			SELECT M#attributes.sal_mon# AS AY_MAAS FROM EMPLOYEES_SALARY WHERE PERIOD_YEAR = #attributes.sal_year# AND IN_OUT_ID = #in_out_id#
		</cfquery>
	</cfif>
	  <tr>
	  	<td><cfif salary_type eq 1><cf_get_lang dictionary_id="58457.Günlük"><cfelseif salary_type eq 0><cf_get_lang dictionary_id="53260.Saatlik"></cfif> <cfif gross_net eq 1><cf_get_lang dictionary_id="58083.Net"><cfelse><cf_get_lang dictionary_id="56257.Brüt"></cfif><cf_get_lang dictionary_id="53127.Ücret"></td>
		<td>&nbsp;</td>
		<td  style="text-align:right;"><cfoutput>#ucret_yaz#</cfoutput></td>
	  </tr>
	  </cfif>
      <tr>
        <td><cf_get_lang dictionary_id="55715.Normal Gün"></td>
        <td  style="text-align:right;"><cfoutput>#work_day_hour#</cfoutput></td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(normal_gun_ucret)#</cfoutput></td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="58956.Haftalık Tatil"></td>
        <td  style="text-align:right;"><cfoutput>#sunday_count_hour#</cfoutput></td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(ht_ucret)#</cfoutput></td>
      </tr>
	  <cfif genel_tatil gt 0>
      <tr>
        <td><cf_get_lang dictionary_id="29482.Genel Tatil"></td>
        <td  style="text-align:right;"><cfoutput>#offdays_count_hour#</cfoutput></td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(gt_ucret)#</cfoutput></td>
      </tr>
	  </cfif>
	  <cfif (t_izin+t_ssdf_izin_days) gt 0>
		  <cfset ucretsiz_izin_amount = t_ssdf_izin_amount + t_izin_amount>
      <tr>
        <td><cf_get_lang dictionary_id="55756.Ücretsiz İzin"></td>
        <td  style="text-align:right;"><cfoutput>#izin_count#</cfoutput></td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(izin_ucret)#</cfoutput></td>
      </tr>
	  <cfelse>
		  <cfset ucretsiz_izin_amount = 0>
	  </cfif>
	  <cfif t_paid_izin gt 0>
		  <tr>
			<td><cf_get_lang dictionary_id="53686.Ücretli İzin"></td>
			<td  style="text-align:right;"><cfoutput>#izin_paid_count-paid_izinli_sunday_count_hour#</cfoutput></td>
			<td  style="text-align:right;"><cfoutput>#TLFormat(izin_paid_ucret)#</cfoutput></td>
		  </tr>
		  <cfif t_paid_izinli_sundays gt 0>
			  <tr>
				<td><cf_get_lang dictionary_id="53778.Ücretli İzin HT."></td>
				<td  style="text-align:right;"><cfoutput>#paid_izinli_sunday_count_hour#</cfoutput></td>
				<td  style="text-align:right;"><cfoutput>#TLFormat(paid_izin_ht_ucret)#</cfoutput></td>
			  </tr>	
		  </cfif>
	  <cfelse>
		  <cfset ucretli_izin_amount = 0>
	  </cfif>
	  <cfif t_total_saat gt 0>
	  	<tr>
			<td><cf_get_lang dictionary_id="57492.TOPLAM"></td>
			<td  style="text-align:right;"><cfoutput>#TLFormat(t_total_saat)#</cfoutput></td>
			<td  style="text-align:right;"><cfoutput>#TLFormat(toplam_ucret)#</cfoutput></td>
      </tr>
	  </cfif>
     <cfif t_kidem_amount gt 0>
	  <tr>
        <td><cf_get_lang dictionary_id="52991.Kıdem Tazminatı"></td>
        <td  style="text-align:right;">&nbsp;</td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(t_kidem_amount)#</cfoutput></td>
      </tr>
	  </cfif>
	  <cfif t_ihbar_amount gt 0>
      <tr>
        <td><cf_get_lang dictionary_id="52992.İhbar Tazminatı"></td>
        <td  style="text-align:right;">&nbsp;</td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(t_ihbar_amount)#</cfoutput></td>
      </tr>
	  </cfif>
	  <cfif t_yillik_izin_amount gt 0>
	  <tr>
        <td><cf_get_lang dictionary_id="53393.Yıllık İzin Tutarı"></td>
        <td  style="text-align:right;">&nbsp;</td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(t_yillik_izin_amount)#</cfoutput></td>
      </tr>
	 </cfif>
	  <tr class="txtbold" height="25">
		<td><cf_get_lang dictionary_id="56018.Fazla Mesailer"></td>
		<td><cf_get_lang dictionary_id="57491.Saat"></td>
		<td><cf_get_lang dictionary_id="57673.Tutar"></td>
	  </tr>
	  <tr>
        <td><cf_get_lang dictionary_id="40828.Hafta İçi"></td>
        <td  style="text-align:right;"><cfoutput>#t_ext_work_hours_0#</cfoutput></td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(t_ext_salary_0)#</cfoutput></td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="58867.Hafta Tatili"></td>
        <td  style="text-align:right;"><cfoutput>#t_ext_work_hours_1#</cfoutput></td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(t_ext_salary_1)#</cfoutput></td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="29482.Genel Tatil"></td>
        <td  style="text-align:right;"><cfoutput>#t_ext_work_hours_2#</cfoutput></td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(t_ext_salary_2)#</cfoutput></td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="54251.Gece Çalışması"></td>
        <td  style="text-align:right;"><cfoutput>#t_ext_work_hours_5#</cfoutput></td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(t_ext_salary_5)#</cfoutput></td>
      </tr>
	  <tr>
        <td><cf_get_lang dictionary_id="57492.TOPLAM"></td>
        <td  style="text-align:right;"><cfoutput>#t_ext_work_hours_0 + t_ext_work_hours_1 + t_ext_work_hours_2 + t_ext_work_hours_5#</cfoutput></td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(t_ext_salary_0 + t_ext_salary_1 + t_ext_salary_2 + t_ext_salary_5)#</cfoutput></td>
      </tr>
    </table>
	</td>
    <td width="25%" valign="top">
	<table width="100%" border="<cfoutput>#icmal_border#</cfoutput>" cellspacing="0" cellpadding="0" align="center" bordercolor="#CCCCCC">
      <tr class="txtbold" height="25">
        <td><cf_get_lang dictionary_id="53837.Ücret Dışı Ödemeler"></td>
        <td><cf_get_lang dictionary_id="57673.Tutar"></td>
      </tr>
	<cfif t_vergi_istisna_yaz gt 0>
	<tr>
		<td><cfoutput>#listdeleteduplicates(valuelist(get_vergi_istisnas.COMMENT_PAY))#</cfoutput></td>
		<td><cfoutput>#TLFormat(t_vergi_istisna_yaz)#</cfoutput></td>
	</tr>
	</cfif>
	<cfset genel_odenek_total = 0>
	<cfoutput query="get_odeneks" group="COMMENT_PAY">
		<cfset tmp_total = 0>
		<cfoutput>
			<cfif PAY_METHOD eq 2>
				<cfset tmp_total = tmp_total + amount_2>
			<cfelse>
				<cfset tmp_total = tmp_total + amount>
			</cfif>
		</cfoutput>
      <tr>
        <td>#comment_pay#</td>
        <td  style="text-align:right;">#TLFormat(tmp_total)#</td>
      </tr>
	  <cfset genel_odenek_total = genel_odenek_total + tmp_total>
	</cfoutput>
    </table>
	</td>
    <td width="25%" valign="top"><table width="100%" border="<cfoutput>#icmal_border#</cfoutput>" cellspacing="0" cellpadding="0" align="center" bordercolor="#CCCCCC">
      <tr class="txtbold" height="25">
        <td><cf_get_lang dictionary_id="38977.Kesintiler"></td>
        <td><cf_get_lang dictionary_id="57673.Tutar"></td>
      </tr>
	 <cfif t_vergi_istisna_net_yaz gt 0>
	<tr>
		<td><cfoutput>#listdeleteduplicates(valuelist(get_vergi_istisnas.COMMENT_PAY))#</cfoutput></td>
		<td><cfoutput>#TLFormat(t_vergi_istisna_net_yaz)#</cfoutput></td>
	</tr>
	</cfif>
	<cfoutput query="get_kesintis" group="COMMENT_PAY">
		<cfset tmp_total = 0>
		<cfoutput><!--- 20040824 ellemeyin yanlis kullanim degil --->
		<cfif PAY_METHOD eq 2>
			<cfset tmp_total = tmp_total + amount_2>
		<cfelse>
			<cfset tmp_total = tmp_total + amount>
		</cfif>
		</cfoutput>
      <tr>
        <td>#comment_pay#</td>
        <td  style="text-align:right;"><cfif comment_pay is 'Avans' and t_avans gt 0>#TLFormat(tmp_total + t_avans)#<cfset is_avans_ = 1><cfelse>#TLFormat(tmp_total)#</cfif></td>
      </tr>
	</cfoutput>
	 <cfif t_avans gt 0 and not isdefined("is_avans_")>
      <tr>
        <td><cf_get_lang dictionary_id="58204.Avans"></td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(t_avans)#</cfoutput></td>
      </tr>
	  </cfif>   
	</table>
	</td>
    <td width="25%" valign="top"><table width="100%" border="<cfoutput>#icmal_border#</cfoutput>" cellspacing="0" cellpadding="0" align="center" bordercolor="#CCCCCC">
      <tr class="txtbold" height="25">
        <td><cf_get_lang dictionary_id="53838.Vergi Muafiyetleri"></td>
        <td><cf_get_lang dictionary_id="57673.Tutar"></td>
      </tr>
	<cfset t_istisna = 0>
	<cfoutput query="get_vergi_istisnas" group="COMMENT_PAY">
		<cfset tmp_total = 0>
		<cfoutput><!--- 20040824 ellemeyin yanlis kullanim degil --->
			<cfif PAY_METHOD eq 2>
				<cfset tmp_total = tmp_total + amount_2>
				<cfset t_istisna = t_istisna + amount_2>
			<cfelse>
				<cfset tmp_total = tmp_total + amount>
				<cfset t_istisna = t_istisna + amount>
			</cfif>
		</cfoutput>
      <tr>
        <td>#comment_pay#</td>
        <td  style="text-align:right;">#TLFormat(tmp_total)#</td>
      </tr>
	</cfoutput>
	</table>
	</td>
  </tr>
  <tr class="txtbold" height="25">
    <td valign="top">
		<table width="99%" border="<cfoutput>#icmal_border#</cfoutput>" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC">
		  <tr>
			<td width="75%"><cf_get_lang dictionary_id="57680.GENEL TOPLAM"></td>
			<td  style="text-align:right;"><cfoutput>#TLFormat(toplam_salary)#</cfoutput></td>
		  </tr>
		</table>
	</td>
    <td valign="top">
		<table width="99%" border="<cfoutput>#icmal_border#</cfoutput>" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC">
		  <tr>
			<td width="75%"><cf_get_lang dictionary_id="57492.TOPLAM"></td>
			<td  style="text-align:right;"><cfoutput>#TLFormat(genel_odenek_total+t_vergi_istisna_yaz)#</cfoutput></td>
		  </tr>
		</table>
	</td>
    <td valign="top">
		<table width="99%" border="<cfoutput>#icmal_border#</cfoutput>" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC">
		  <tr>
			<td><cf_get_lang dictionary_id="57492.TOPLAM"></td>
			<td  style="text-align:right;"><cfoutput>#TLFormat(t_avans+t_ozel_kesinti+t_vergi_istisna_net_yaz)#</cfoutput></td>
		  </tr>
		</table>
	</td>
    <td valign="top">
	<table width="99%" border="<cfoutput>#icmal_border#</cfoutput>" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC">
      <tr>
        <td width="75%"><cf_get_lang dictionary_id="57492.TOPLAM"></td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(t_istisna)#</cfoutput></td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<br/>
<cfscript>
	sgk_normal_gun = normal_gun + haftalik_tatil + genel_tatil - t_ssdf_ssk_days - eksi_ssk + t_ssdf_paid_izin  + eksi_ssk_paid_izin;
	sgk_izin_gun = t_ssk_paid_izin-eksi_ssk_paid_izin;

/*
		SGK Toplam Gün = SGK Normal Gün + SGK İzin Gün
		SGK Toplam Gün 30'dan büyük çıkarsa 30'a eşitlemeliyiz.
		Müşteri, çıkan fazlalığın SGK Normal Günden düşülmesini talep etti.

	Parametrelerde 31 days Hayır seçili ise, DBye total_days olarak maks. 30 yazılıyor. Dolayısı ile aşağıdaki ifadeye gerek kalmadı.
	if ((sgk_normal_gun + sgk_izin_gun) gt 30) // SGK Toplam gün 30'dan büyükse
		sgk_normal_gun = sgk_normal_gun - (sgk_normal_gun + sgk_izin_gun - 30); // SGK Normal Günden fazlalığı çıkar
*/

	if (salary_type eq 0 and DaysInMonth(bu_ay_sonu) eq total_days)
		sgk_normal_gun = 30 - sgk_izin_gun;
</cfscript>
<table width="700" border="<cfoutput>#icmal_border#</cfoutput>" cellspacing="0" cellpadding="0" align="center" bordercolor="#CCCCCC">
  <tr>
    <td width="35%"><cf_get_lang dictionary_id="58714.SGK"> <cf_get_lang dictionary_id="55715.Normal Gün"></td>
    <td width="12%" nowrap style="text-align:right;"><cfoutput><cfif sgk_normal_gun gte 0>#sgk_normal_gun#<cfelse>0</cfif></cfoutput></td>
    <td width="35%">&nbsp;<cf_get_lang dictionary_id="54283.İşsizlik Sigortası Matrahı"></td>
    <td width="18%" style="text-align:right;"><cfoutput>#TLFormat(t_ssk_matrahi)#</cfoutput></td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="58714.SGK"> <cf_get_lang dictionary_id="54269.İzin Gün"> </td>
    <td  style="text-align:right;"><cfoutput>#sgk_izin_gun#</cfoutput></td>
    <td>&nbsp;<cf_get_lang dictionary_id="54275.İşsizlik Sigortası İşçi"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_issizlik_isci_hissesi)#</cfoutput></td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="53245.SGK Matrahı"> (<cfoutput>#ssk_say#</cfoutput>)</td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ssk_matrahi)#</cfoutput></td>
    <td>&nbsp;<cf_get_lang dictionary_id="53257.İşsizlik Sigortası İşveren"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_issizlik_isveren_hissesi)#</cfoutput></td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="53719.SGK İşçi Primi"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ssk_primi_isci)#</cfoutput></td>
    <td>&nbsp;<cf_get_lang dictionary_id="53196.İşsizlik Sigortası"> <cf_get_lang dictionary_id="58659.Toplamı"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_issizlik_isveren_hissesi+t_issizlik_isci_hissesi)#</cfoutput></td>
  </tr>
  <tr>
  	<td>
	<cfset this_devam_ = attributes.sal_mon+1>
	<cfset this_devam_2 = attributes.sal_mon+2>
	<cfif this_devam_ gt 12>
		<cfset this_devam_ = this_devam_ - 12>
	</cfif>
	<cfif this_devam_2 gt 12>
		<cfset this_devam_2 = this_devam_2 - 12>
	</cfif>
	<cfoutput>#listgetat(ay_list(),this_devam_)# - #listgetat(ay_list(),this_devam_2)#</cfoutput> <cf_get_lang dictionary_id="54267.Dev.SGK Matrahı"></td>
	<td  style="text-align:right;"><cfoutput>#tlformat(t_devreden)#</cfoutput></td>
	<td colspan="2"><strong><cf_get_lang dictionary_id="53777.Kazançlar"> <cf_get_lang dictionary_id="57989.ve"> <cf_get_lang dictionary_id="38977.Kesintiler"></strong></td>
  </tr>
  <tr>
  	<td><cf_get_lang dictionary_id="54267.Önceki Ayd.Dev.SGK Matrahı"></td>
	<td  style="text-align:right;"><cfoutput>#tlformat(t_devirden_gelen)#</cfoutput></td>
	<td><cf_get_lang dictionary_id="54300.SGK Devir Isci Hissesi Fark"></td>
	<td  style="text-align:right;"><cfoutput>#TLFormat(t_ssk_primi_isci - t_ssk_primi_isci_devirsiz)#</cfoutput></td>

  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="53698.SGK İşveren Primi Hesaplanan"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ssk_primi_isveren_hesaplanan)#</cfoutput></td>
   <td><cf_get_lang dictionary_id="54301.SGK Devir Issizlik Hissesi Fark"></td>
	<td  style="text-align:right;"><cfoutput>#TLFormat(t_issizlik_isci_hissesi - t_issizlik_isci_hissesi_devirsiz)#</cfoutput></td>
    </tr>
<tr>
    <td nowrap><cf_get_lang dictionary_id="53256.SGK İşveren Primi"> <cf_get_lang dictionary_id="54268.İndirimi"> 5510</td>
    <td  style="text-align:right;">
		<cfoutput>#tlformat(t_ssk_primi_isveren_5510)#</cfoutput>
	</td>
   <td><cf_get_lang dictionary_id="54302.SGDP İşçi Primi Fark"></td>
	 <td  style="text-align:right;"><cfoutput>#tlformat(t_sgdp_devir)#</cfoutput></td>
    </tr>
<tr>
    <td nowrap><cf_get_lang dictionary_id="53256.SGK İşveren Primi"> <cf_get_lang dictionary_id="54268.İndirimi"> 5084</td>
    <td  style="text-align:right;">
		<cfoutput>#tlformat(t_ssk_primi_isveren_5084)#</cfoutput>
	</td>
    <td>&nbsp;</td>
	<td>&nbsp;</td>
    </tr>
<tr>
    <td nowrap><cf_get_lang dictionary_id="53256.SGK İşveren Primi"> <cf_get_lang dictionary_id="54268.İndirimi"> 5763</td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ssk_primi_isveren_gov)#</cfoutput></td>
    <td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>
<tr>
    <td nowrap><cf_get_lang dictionary_id="53256.SGK İşveren Primi"> <cf_get_lang dictionary_id="54268.İndirimi"> 5746</td>
    <td style="text-align:right;">
		<cfoutput>#tlformat(t_ssk_primi_isveren_5746)#</cfoutput>
	</td>
    <td>&nbsp;</td>
	<td>&nbsp;</td>
    </tr>
<tr>
    <td nowrap><cf_get_lang dictionary_id="53256.SGK İşveren Primi"> <cf_get_lang dictionary_id="54268.İndirimi"> 5921</td>
    <td style="text-align:right;"><cfoutput>#TLFormat(t_ssk_primi_isveren_5921)#</cfoutput></td>
    <td>&nbsp;<cf_get_lang dictionary_id="41540.Normal Kazanç"></td>
    <td style="text-align:right;"><cfoutput>#TLFormat(toplam_ucret)#</cfoutput></td>
</tr>
  <tr>
    <td><cf_get_lang dictionary_id="53256.SGK İşveren Primi"> <cf_get_lang dictionary_id="54268.İndirimi"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ssk_primi_isveren - t_ssk_primi_isveren_gov - t_ssk_primi_isveren_5921 - t_ssk_primi_isveren_5746)#</cfoutput></td>
    <td>&nbsp;<cf_get_lang dictionary_id="41783.Ek Kazanç Top."></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ext_salary_0+t_ext_salary_1+t_ext_salary_2 + t_ext_salary_5)#</cfoutput></td>
    </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54304.Ödenecek Toplam SGK Primi"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat((t_ssk_primi_isveren - t_ssk_primi_isveren_gov - t_ssk_primi_isveren_5921 - t_ssk_primi_isveren_5746)+t_ssk_primi_isci)#</cfoutput></td>
    <td>&nbsp;<cf_get_lang dictionary_id="41785.Sosyal Yardımlar Top."></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(genel_odenek_total)#</cfoutput></td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54305.İndirimsiz Toplam SGK Primi"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ssk_primi_isci+t_ssk_primi_isveren_hesaplanan)#</cfoutput></td>
    <td>&nbsp;<cf_get_lang dictionary_id="53244.Toplam Kazanç"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(toplam_ucret+genel_odenek_total+t_ext_Salary)#</cfoutput></td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54306.SGDP Normal Gün"></td>
    <td  style="text-align:right;"><cfoutput>#t_ssdf_ssk_days - t_ssdf_paid_izin#</cfoutput></td>
    <td>&nbsp;<cf_get_lang dictionary_id="53722.Toplam Yasal Kesinti"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ssk_primi_isci + t_ssdf_isci_hissesi + t_gelir_vergisi + t_damga_vergisi + t_issizlik_isci_hissesi)#</cfoutput></td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="41782.SGDP İzin Gün"></td>
    <td  style="text-align:right;"><cfoutput>#t_ssdf_paid_izin#</cfoutput></td>
    <td>&nbsp;<cf_get_lang dictionary_id="41540.Vergi İndirimi"> <cfif (attributes.sal_year eq 2007 and attributes.sal_mon gt 6) or attributes.sal_year gte 2008>5084 (5615)<cfelse>5084</cfif></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_vergi_indirimi_5084)#</cfoutput></td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54307.SGDP Matrahı"> (<cfoutput>#ssdf_say#</cfoutput>)</td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ssdf_matrah)#</cfoutput></td>
    <td>&nbsp;<cf_get_lang dictionary_id="41743.Toplam Özel Kesinti"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ozel_kesinti+t_avans)#</cfoutput></td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54308.SGDP İşçi Primi"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ssdf_isci_hissesi)#</cfoutput></td>
    <td>&nbsp;
		<cfif this_cast_style_ eq 1 or this_cast_style_ eq 2>
			<cf_get_lang dictionary_id="54310.Kesinti ve AGİ Öncesi Net">
		<cfelse>
			<cf_get_lang dictionary_id="54309.Net Ödenecek">
		</cfif>
	</td>
    <td  style="text-align:right;">
		<cfif this_cast_style_ eq 1 or this_cast_style_ eq 2>
			<cfoutput>#TLFormat(t_net_ucret-t_vergi_iadesi+t_avans+t_ozel_kesinti)#</cfoutput>
		<cfelse>
			<cfoutput>#TLFormat(t_net_ucret)#</cfoutput>
		</cfif>
	</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54311.SGDP İşveren Primi"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ssdf_isveren_hissesi)#</cfoutput></td>
    <td>&nbsp;<cf_get_lang dictionary_id="53252.Damga Vergisi"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_damga_vergisi)#</cfoutput></td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54312.Toplam SGDP Primi"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ssdf_isci_hissesi+t_ssdf_isveren_hissesi)#</cfoutput></td>
    <td>&nbsp;<cf_get_lang dictionary_id="54313.Kümülatif Vergi Matrahı"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_kum_gelir_vergisi_matrahi+t_gelir_vergisi_matrahi)#</cfoutput></td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54314.Gayri Safi Kazanç"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(toplam_ucret+t_total_pay_ssk_tax+t_total_pay_ssk+t_total_pay_tax+t_total_pay+t_ext_Salary-t_ssk_primi_isci-t_issizlik_isci_hissesi-t_ssdf_isci_hissesi+t_vergi_istisna_tutar)#</cfoutput></td>
    <td>&nbsp;<cf_get_lang dictionary_id="41842.DV. Matrahı"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_damga_vergisi_matrahi)#</cfoutput></td>
  </tr>

  <tr>
    <td><cf_get_lang dictionary_id="41630.Özel İndirim"></td>
    <td  style="text-align:right;"><cfoutput>#tlformat(0)#</cfoutput></td>
    <td>&nbsp;<cf_get_lang dictionary_id="54319.Kümüle Gelir Vergisi"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_kum_gelir_vergisi+t_gelir_vergisi+t_vergi_iadesi)#</cfoutput></td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54168.Sakatlık İndirimi"> (<cfoutput>#sakat_say#</cfoutput>)</td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_sakatlik)#</cfoutput></td>
    <td>&nbsp;
		<cfif this_cast_style_ eq 1 or this_cast_style_ eq 2>
			<cf_get_lang dictionary_id="53659.Asgari Geçim İndirimi"><cfoutput>(#t_vergi_iadesi_alan#)</cfoutput>
		<cfelse>
			<cf_get_lang dictionary_id="41873.Özel Gid. İnd.">
		</cfif>
	</td>
    <td  style="text-align:right;">
		<cfif this_cast_style_ eq 1 or this_cast_style_ eq 2>
			<cfoutput>#TLFormat(t_vergi_iadesi)#</cfoutput>
		<cfelse>
			<cfif len(get_ogis.ogi_odenecek_toplam)>
				<cfoutput>#TLFormat(get_ogis.ogi_odenecek_toplam)#</cfoutput>
			<cfelse>
				0
			</cfif>
		</cfif>
	</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54315.Göçmen İndirimi"> (<cfoutput>#gocmen_say#</cfoutput>)</td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_gocmen_indirimi)#</cfoutput></td>
    <td>&nbsp;<cfif this_cast_style_ eq 1 or  this_cast_style_ eq 2><cf_get_lang dictionary_id="41540.Normal Kazanç">Mahsup Edilecek Gelir Vergisi<cfelse><cf_get_lang dictionary_id="41540.Normal Kazanç">Ö.Gider İnd. Damga Vergisi</cfif></td>
    <td  style="text-align:right;"><cfif this_cast_style_ eq 1 or  this_cast_style_ eq 2><cfoutput>#TLFormat(t_mahsup_g_vergisi)#</cfoutput><cfelse><cfif len(get_ogis.ogi_damga_toplam)><cfoutput>#TLFormat(get_ogis.ogi_damga_toplam)#</cfoutput><cfelse>0</cfif></cfif></td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54316.Diğer Muafiyet"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_istisna)#</cfoutput></td>
    <td>&nbsp;<cf_get_lang dictionary_id="54317.Arge İndirimi"></td>
	<td  style="text-align:right;"><cfoutput>#TLFormat(t_vergi_indirimi_5746)#</cfoutput></td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54297.Önceki Ay Dv. Küm. Matrah"></td>
    <td  style="text-align:right;"><cfif isdefined("onceki_donem_kum_gelir_vergisi_matrahi")><cfoutput>#TLFormat(onceki_donem_kum_gelir_vergisi_matrahi)#</cfoutput><cfelse><cfoutput>#TLFormat(t_kum_gelir_vergisi_matrahi)#</cfoutput></cfif></td>
    <td>&nbsp;
		<cfif this_cast_style_ eq 1 or this_cast_style_ eq 2>
			<cf_get_lang dictionary_id="53691.Toplam Net Ödenecek">
		<cfelse>
			<cf_get_lang dictionary_id="41903.Ö.Gider İnd. Sonra GV.">
		</cfif>
	</td>
    <td  style="text-align:right;">
		<cfif this_cast_style_ eq 1 or this_cast_style_ eq 2>
			<cfoutput>#tlformat(t_net_ucret)#</cfoutput>
		<cfelse>
			<cfoutput>
				<cfif len(get_ogis.ogi_odenecek_toplam)>
					#TLFormat(t_gelir_vergisi-get_ogis.ogi_odenecek_toplam-get_ogis.ogi_damga_toplam)#
				<cfelse>
					#TLFormat(t_gelir_vergisi)#
				</cfif>
			</cfoutput>
		</cfif>
	</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="59543.Önceki Ay Dv. Km. Gelir V."></td>
    <td  style="text-align:right;"><cfif isdefined("onceki_donem_kum_gelir_vergisi")><cfoutput>#TLFormat(onceki_donem_kum_gelir_vergisi)#</cfoutput><cfelse><cfoutput>#TLFormat(t_kum_gelir_vergisi)#</cfoutput></cfif></td>
    <td>&nbsp;<cf_get_lang dictionary_id="54320.Toplam İşveren M. İndirimsiz"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(toplam_ucret+t_ext_salary+t_issizlik_isveren_hissesi+t_ssk_primi_isveren_hesaplanan+t_ssdf_isveren_hissesi+genel_odenek_total+(t_ssk_primi_isci - t_ssk_primi_isci_devirsiz)+(t_issizlik_isci_hissesi - t_issizlik_isci_hissesi_devirsiz)+t_sgdp_devir)#</cfoutput></td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54321.Net Gelir Ver. Matrahı"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_gelir_vergisi_matrahi)#</cfoutput></td>
    <td>&nbsp;<cf_get_lang dictionary_id="53708.Toplam İşveren Maliyeti"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(toplam_ucret+t_ext_salary+t_issizlik_isveren_hissesi+t_ssk_primi_isveren+t_ssdf_isveren_hissesi+genel_odenek_total-t_ssk_primi_isveren_gov-t_ssk_primi_isveren_5921-t_ssk_primi_isveren_5746+(t_ssk_primi_isci - t_ssk_primi_isci_devirsiz)+(t_issizlik_isci_hissesi - t_issizlik_isci_hissesi_devirsiz)+t_sgdp_devir)#</cfoutput></td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="53689.Gelir Vergisi Hesaplanan"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_gelir_vergisi+t_vergi_indirimi_5084+t_vergi_iadesi-t_mahsup_g_vergisi+t_vergi_indirimi_5746)#</cfoutput></td>
    <td rowspan="2" valign="top">&nbsp;<cf_get_lang dictionary_id="58957.İmza"></td>
    <td rowspan="2"  style="text-align:right;">&nbsp;</td>
  </tr>
   <tr>
    <td><cf_get_lang dictionary_id="53250.Gelir Vergisi"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_gelir_vergisi)#</cfoutput></td>
  </tr>

<cfif not isdefined("attributes.page_dept")>
	<cfif icmal_type is "personal">
		<cfquery name="get_bank_" datasource="#dsn#">
			SELECT 
				BA.BANK_BRANCH_CODE,
				BA.BANK_ACCOUNT_NO,
				B.BANK_NAME
			FROM
				EMPLOYEES_BANK_ACCOUNTS BA,
				SETUP_BANK_TYPES B
			WHERE
				BA.BANK_ID = B.BANK_ID AND
				BA.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND 
				DEFAULT_ACCOUNT = 1
		</cfquery>
		<tr>
			<td colspan="4"><cf_get_lang dictionary_id="59536.Bu Ücret Pusulasıyla Tahakkuku Yapılan Ödemelerin Fiili Çalışmama Uygun Olduğunu">,
			<cfif fazla_mesai_toplam eq 0><cf_get_lang dictionary_id="59537.Fazla Mesai Yapmadığımı,"></cfif> <cf_get_lang dictionary_id="59538.Ücretlerimi"> <cfif get_bank_.recordcount><CFOUTPUT><b>#get_bank_.BANK_NAME# (#get_bank_.BANK_BRANCH_CODE#-#get_bank_.BANK_ACCOUNT_NO#)</b></CFOUTPUT> <cf_get_lang dictionary_id="59544.Nolu Hesabımdan"></cfif> <cf_get_lang dictionary_id="59539.Aldığımı , Ücret Alacağımın kalmadığını Kabul Ve Beyan Ederim">.</td>
		</tr>
			<cfquery name="get_apply_date" datasource="#dsn#">
				SELECT 
					APPLY_DATE
				FROM 
					EMPLOYEES_PUANTAJ_MAILS 
				WHERE 
					EMPLOYEE_ID = #GET_PUANTAJ_PERSONAL.EMPLOYEE_ID# AND
					BRANCH_ID = #GET_PUANTAJ_PERSONAL.branch_id# AND 
					SAL_MON = #attributes.sal_mon# AND 
					SAL_YEAR = #attributes.sal_year#
			</cfquery>
	
			<cfif len(get_apply_date.apply_date)>
				<tr>
					<td height="30" colspan="4"  class="txtbold" style="text-align:right;"><cfoutput><cf_get_lang dictionary_id="59540.İşbu Bordro"> #dateformat(get_apply_date.APPLY_DATE,dateformat_style)# <cf_get_lang dictionary_id="59541.tarihinde">  #GET_PUANTAJ_PERSONAL.EMPLOYEE_name#  #GET_PUANTAJ_PERSONAL.EMPLOYEE_surname# <cf_get_lang dictionary_id="59542.tarafından onaylanmıştır">.</cfoutput></td>
				</tr>
			</cfif>
	</cfif>
</cfif>
</table>
