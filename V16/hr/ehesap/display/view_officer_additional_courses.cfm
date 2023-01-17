<cf_get_lang_set module_name="ehesap">
<cfparam name="attributes.is_virtual_puantaj" default="0">
<cfset main_puantaj_table = "EMPLOYEES_PUANTAJ">
<cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS">
<cfset add_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_ADD">
<cfset maas_puantaj_table = "EMPLOYEES_SALARY">
<cfparam name="icmal_border" default="0">

<cfif not evaluate("#query_name#.recordcount")>
	<script type="text/javascript">
		alert("Kayıt bulunamadı!");
		history.back();
	</script>
	<cfexit method="exittemplate">
</cfif>
<cfscript>
	//Gün Toplamları
	t_paid_izin = 0;
	t_paid_izin_hours = 0;
	t_haftalik_tatil = 0;
	t_haftalik_tatil_hours = 0;
	t_normal_gun = 0;
	t_normal_hours = 0;
	t_paid_izinli_sundays = 0;
	t_paid_izinli_sundays_hours = 0;
	t_izin = 0;
	t_izin_hours = 0;
	t_total_days = 0;
	t_total_hours = 0;
	t_offdays = 0;
	t_offdays_hours = 0;
	t_ext_work_hours_0 = 0;
	t_ext_work_hours_1 = 0;
	t_ext_work_hours_2 = 0;
	t_ext_work_hours_5 = 0;
	//tutar toplamları
	t_normal_amount = 0;
	t_haftalik_tatil_amount = 0;
	t_offdays_amount = 0;
	t_izin_amount = 0;
	t_izin_paid_amount = 0;
	t_izin_paid_amount_ht = 0;
	t_kidem_amount = 0;
	t_ihbar_amount = 0;
	t_yillik_izin_amount = 0;
	t_ext_salary_0 = 0;
	t_ext_salary_1 = 0;
	t_ext_salary_2 = 0;
	t_ext_salary_5 = 0;
	
	t_reel_ssk_days = 0;
	t_ssdf_ssk_days = 0;
	t_ssk_matrahi = 0;
	t_sgdp_devir = 0; 
	t_devreden = 0;
	t_devirden_gelen = 0;
	t_toplam_kazanc = 0;
	t_vergi_iadesi = 0;
	t_vergi_iadesi_alan = 0;
	t_vergi_indirimi_5084 = 0;
	t_vergi_indirimi_5746_days = 0;
	t_vergi_indirimi_5746 = 0;
	t_vergi_indirimi_5746_all = 0;
	t_vergi_indirimi_4691 = 0;
	t_vergi_indirimi_4691_all = 0;
	t_kum_gelir_vergisi_matrahi = 0;
	t_gelir_vergisi_matrahi = 0;
	t_gelir_vergisi = 0;
	t_damga_vergisi = 0;
	t_damga_vergisi_matrahi = 0;
	t_kesinti = 0;
	t_net_ucret = 0;
	t_ssk_primi_isci = 0;
	t_bes_primi_isci = 0;
	t_ssk_primi_isci_devirsiz = 0;
	t_ssk_primi_isveren_hesaplanan = 0;
	t_ssk_primi_isveren = 0;
	t_ssk_primi_isveren_gov = 0;
	t_ssk_primi_isveren_5510 = 0;
	t_ssk_primi_isveren_5084 = 0;
	t_ssk_primi_isveren_5921 = 0;
	t_ssk_primi_isveren_5746 = 0;
	t_ssk_days_5746 = 0;
	t_istisna_odenek = 0;
	t_istisna_odenek_net = 0;
	t_istisna_kesinti = 0;
	
	t_damga_vergisi_indirimi_5746 = 0;
	t_damga_vergisi_indirimi_5746_all = 0;
	t_stampduty_5746 = 0;

	t_ssk_primi_isveren_4691 = 0;
	t_ssk_primi_isveren_6111 = 0;
	t_ssk_primi_isveren_6486 = 0;
	t_ssk_primi_isveren_6322 = 0;
	t_ssk_primi_isci_6322 = 0;
	t_ssk_primi_isveren_25510 = 0;
	t_ssk_primi_isveren_14857 = 0;
	t_ssk_primi_isveren_6645 = 0;
	t_ssk_primi_isveren_46486 = 0;
	t_ssk_primi_isveren_56486 = 0;
	t_ssk_primi_isveren_66486 = 0;
	
	t_ssk_primi_687 = 0;
	t_isveren_primi_687 = 0;
	t_issizlik_primi_687 = 0;
	t_issizlik_isveren_hissesi_687 = 0;
	t_issizlik_isci_hissesi_687 = 0;
	t_gelir_vergisi_primi_687 = 0;
	t_damga_vergisi_primi_687 = 0;
	toplam_indirim_687 = 0;
	
	t_ssk_primi_7103 = 0;
	t_isveren_primi_7103 = 0;
	t_issizlik_primi_7103 = 0;
	t_gelir_vergisi_primi_7103 = 0;
	t_damga_vergisi_primi_7103 = 0;
	toplam_indirim_7103 = 0;
	ssk_isveren_hissesi_7103 = 0;
	t_ssk_isveren_hissesi_7103 = 0;
	t_ssk_isci_hissesi_7103 = 0;
	t_issizlik_isci_hissesi_7103 = 0;
	t_issizlik_isveren_hissesi_7103 = 0; 
	
	//7252 KÇÖ indirim kanunu Esma R. Uysal
	t_ssk_isveren_hissesi_7252 = 0;
	t_ssk_isci_hissesi_7252 = 0;
	t_issizlik_isci_hissesi_7252 = 0;
	t_issizlik_isveren_hissesi_7252 = 0;
	t_ssk_days_7252 = 0;
	t_toplam_indirim_7252 = 0;
	t_ssk_primi_7252 = 0;
	
	//7256 İstihdama Dönüş Kanunu Esma R. Uysal 
	t_ssk_isveren_hissesi_7256 = 0;
	t_ssk_isci_hissesi_7256 = 0;
	t_issizlik_isci_hissesi_7256 = 0;
	t_issizlik_isveren_hissesi_7256 = 0;
	t_toplam_indirim_7256 = 0;
	t_ssk_primi_7256 = 0;
	t_base_amount_7256 = 0;

	t_issizlik_isci_hissesi = 0;
	t_issizlik_isci_hissesi_devirsiz = 0;
	t_issizlik_isveren_hissesi = 0;
	t_ozel_kesinti = 0;
	t_ozel_kesinti_2 = 0;
	t_ozel_kesinti_2_net = 0;
	t_ozel_kesinti_2_net_fark = 0;
	ssk_count = 0;
	t_ssdf_days = 0;
	t_ssdf_matrah = 0;
	t_ssdf_isci_hissesi = 0;
	t_ssdf_isveren_hissesi = 0;
	t_sakatlik = 0;
	t_gocmen_indirimi = 0;
	t_ext_salary = 0;
	t_ext_salary_net = 0;
	t_ssk_matrah_muafiyet = 0;
	t_vergi_matrah_muafiyet = 0;
	t_avans = 0;
	ssdf_say = 0;
	ssk_say = 0;
	sakat_say = 0;
	t_short_working_calc = 0;//kısa çalışma ödeneği
	t_isci_primi_indirimli = 0;
	t_issizlik_isci_primi_indirimli = 0;
	t_issizlik_isveren_primi_indirimli = 0;

	if (isnumeric(get_kumulatif_gelir_vergisi.toplam))
		t_kum_gelir_vergisi = get_kumulatif_gelir_vergisi.toplam;
	else
		t_kum_gelir_vergisi = 0;

	if (isdefined("get_kumulatif_gelir_vergisi.toplam_matrah") and isnumeric(get_kumulatif_gelir_vergisi.toplam_matrah))
		t_kum_gelir_vergisi_matrahi = get_kumulatif_gelir_vergisi.toplam_matrah;
	else
		t_kum_gelir_vergisi_matrahi = 0;
		
	t_total_pay_ssk_tax = 0;
	t_total_pay_ssk = 0;
	t_total_pay_tax = 0;
	t_total_pay = 0;
	t_vergi_istisna_yaz = 0;
	t_vergi_istisna_net_yaz = 0;
	t_vergi_istisna_tutar = 0;
	fmesai_sayac_1 = 0;
	fmesai_sayac_2 = 0;
	fmesai_sayac_3 = 0;
	fmesai_sayac_4 = 0;	
	T_VERGI_ISTISNA_DAMGA = 0;
	T_VERGI_ISTISNA_VERGI = 0;
	fazla_mesai_toplam = 0;

    t_additional_indicators = 0; //ek gösterge puanı
    t_university_allowance = 0;//üniversite ödeneği
    t_private_service_compensation = 0;//Özel Hizmet tazminatı
    t_family_assistance = 0;//Eş YArdımı
    t_child_assistance = 0;//Çocuk yardımı;
    t_severance_pension = 0;//Kıdem Aylığı
    t_language_allowance = 0;//dil tazminatı
    t_academic_incentive_allowance = 0;//akademik teşvik ödeneği
    t_executive_indicator_compensation = 0;//Makam tazminatı
    t_administrative_duty_allowance = 0;//idari görev tazminatı
    t_education_allowance = 0;//eğitim öğretim ödeneği
    t_administrative_compensation = 0;//Görev tazminatı
</cfscript>
<cfif icmal_type is 'genel' and (not isdefined("attributes.func_id") or (isdefined("attributes.func_id") and not len(attributes.func_id)))>
	<!--- önceki aydan devreden kümülatif matrah calisanların bir onceki aydaki en son puantajındaki kumulatif degerlere bakmalı.sube --->
	<cfquery name="get_old_puantaj_rows" datasource="#dsn#">
		SELECT
			SUM(EPR.KUMULATIF_GELIR_MATRAH) AS KUM_TOPLAM,
			SUM(EPR.GELIR_VERGISI) AS GELIR_TOPLAM
		FROM
			EMPLOYEES_PUANTAJ_ROWS EPR INNER JOIN
			(SELECT 
				EPR.EMPLOYEE_ID,
				MAX(EPR.EMPLOYEE_PUANTAJ_ID) AS EMPLOYEE_PUANTAJ_ID
			FROM 
				EMPLOYEES_PUANTAJ_ROWS EPR INNER JOIN EMPLOYEES_PUANTAJ EP
				ON EPR.PUANTAJ_ID = EP.PUANTAJ_ID
			WHERE 
				EP.SAL_YEAR = <cfif isdefined("attributes.sal_year") and isnumeric(attributes.sal_year)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#"></cfif> AND
				EP.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SAL_MON-1#"> AND
				EPR.EMPLOYEE_ID IN (#evaluate('valueList(#query_name#.EMPLOYEE_ID)')#) 
			GROUP BY
				EPR.EMPLOYEE_ID
				) AS ROW_TABLE ON EPR.EMPLOYEE_PUANTAJ_ID = ROW_TABLE.EMPLOYEE_PUANTAJ_ID	
	</cfquery>
	<cfif get_old_puantaj_rows.recordcount and len(get_old_puantaj_rows.kum_toplam)>
		<cfset onceki_donem_kum_gelir_vergisi_matrahi = get_old_puantaj_rows.kum_toplam>
		<cfset onceki_donem_kum_gelir_vergisi = get_old_puantaj_rows.gelir_toplam>
	</cfif>
</cfif>
<cfset bu_ay_basi = createdate(attributes.sal_year,attributes.sal_mon, 1)>
<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_year_end)>
	<cfset temp_ay_basi = createdate(attributes.sal_year_end,attributes.sal_mon_end, 1)>
	<cfset bu_ay_sonu = date_add('s',-1,date_add('m',1,temp_ay_basi))>
<cfelse>
	<cfset bu_ay_sonu = date_add('s',-1,date_add('m',1,bu_ay_basi))>
</cfif>
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
		OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND
		OFFTIME.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#"> AND 
		OFFTIME.IS_PUANTAJ_OFF = 0
	ORDER BY
		OFFTIME.EMPLOYEE_ID
</cfquery>
<cfoutput query="#query_name#">
	<cfscript>
		//Gün toplamları
		//normal gün
		t_normal_gun = t_normal_gun + weekly_day;
		t_normal_hours = t_normal_hours + weekly_hour;
		
		//haftalık tatil
		t_haftalik_tatil = t_haftalik_tatil + weekend_day;
		t_haftalik_tatil_hours = t_haftalik_tatil_hours + weekend_hour;
		
		//ucretsiz izin gün ve saat
		t_izin = t_izin + izin;
		t_izin_hours = t_izin_hours + izin_count;
	
		//ucretli izin gün ve saat
		t_paid_izin = t_paid_izin + (izin_paid-paid_izinli_sunday_count);
		t_paid_izin_hours = t_paid_izin_hours + (izin_paid_count-paid_izinli_sunday_count_hour);
		
		//genel tatil izin ve saat
		t_offdays = t_offdays + OFFDAYS_COUNT;
		t_offdays_hours = t_offdays_hours + OFFDAYS_COUNT_HOUR;
		
		//ücretli hafta sonu
		t_paid_izinli_sundays = t_paid_izinli_sundays + PAID_IZINLI_SUNDAY_COUNT;
		t_paid_izinli_sundays_hours = t_paid_izinli_sundays_hours + PAID_IZINLI_SUNDAY_COUNT_HOUR;

		
		//Ücret Toplamları
		//normal gün
		t_normal_amount = t_normal_amount + weekly_amount;
		
		//haftalık tatil
		t_haftalik_tatil_amount = t_haftalik_tatil_amount + weekend_amount;
		
		//genel tatil
		t_offdays_amount = t_offdays_amount + offdays_amount;
		
		//ücretsiz izin
		t_izin_amount = t_izin_amount + izin_amount;
		
		//ücretli izin
		t_izin_paid_amount = t_izin_paid_amount + izin_paid_amount - izin_sunday_paid_amount;
		
		//ücretli izin hafta sonu
		t_izin_paid_amount_ht = t_izin_paid_amount_ht + izin_sunday_paid_amount;

       	if(len(additional_indicators))
        	t_additional_indicators = t_additional_indicators + additional_indicators; //ek gösterge puanı
		if(len(university_allowance))
        	t_university_allowance = t_university_allowance + university_allowance;//üniversite ödeneği
		if(len(private_service_compensation))
        	t_private_service_compensation = t_private_service_compensation + private_service_compensation;//Özel hizmet tazminatı
		if(len(family_assistance))
        	t_family_assistance = t_family_assistance +family_assistance;//Eş YArdımı
		if(len(child_assistance))	
        	t_child_assistance = t_child_assistance + child_assistance;//Çocuk yardımı;
		if(len(severance_pension))
        	t_severance_pension = t_severance_pension + severance_pension;//Kıdem aylığı
		if(len(language_allowance))
       		t_language_allowance = language_allowance + t_language_allowance;//Dil tazminatı
		if(len(academic_incentive_allowance))
        		t_academic_incentive_allowance = t_academic_incentive_allowance + academic_incentive_allowance;//Akademik teşvik ödeneği
		if(len(executive_indicator_compensation))
        	t_executive_indicator_compensation = t_executive_indicator_compensation + executive_indicator_compensation;//Makam tazminatı
		if(len(administrative_duty_allowance ))
       		t_administrative_duty_allowance = t_administrative_duty_allowance + administrative_duty_allowance ;//idari görev tazminatı
		if(len(education_allowance))
        	t_education_allowance = t_education_allowance + education_allowance;//eğitim öğretim ödeneği
		if(len(administrative_compensation))
        	t_administrative_compensation = t_administrative_compensation + administrative_compensation;//Görev tazminatı
		
		//kıdem ihbar izin tutarları
		t_kidem_amount = t_kidem_amount + KIDEM_AMOUNT;
		t_ihbar_amount = t_ihbar_amount + IHBAR_AMOUNT;
		t_yillik_izin_amount = t_yillik_izin_amount + YILLIK_IZIN_AMOUNT;
		
		//mesai gün toplamları
		t_ext_work_hours_0 = t_ext_work_hours_0 + EXT_TOTAL_HOURS_0;
		t_ext_work_hours_1 = t_ext_work_hours_1 + EXT_TOTAL_HOURS_1;
		t_ext_work_hours_2 = t_ext_work_hours_2 + EXT_TOTAL_HOURS_2;
		t_ext_work_hours_5 = t_ext_work_hours_5 + EXT_TOTAL_HOURS_5;
		
		//mesai tutar toplamları			
		t_ext_salary_0 = t_ext_salary_0 + EXT_TOTAL_HOURS_0_AMOUNT;
		t_ext_salary_1 = t_ext_salary_1 + EXT_TOTAL_HOURS_1_AMOUNT;
		t_ext_salary_2 = t_ext_salary_2 + EXT_TOTAL_HOURS_2_AMOUNT;
		t_ext_salary_5 = t_ext_salary_5 + EXT_TOTAL_HOURS_5_AMOUNT;
		t_ext_Salary = t_ext_salary_0 + t_ext_salary_1 + t_ext_salary_2 + t_ext_salary_5;

		if(EXT_TOTAL_HOURS_0 gt 0)fmesai_sayac_1 = fmesai_sayac_1 + 1;
		if(EXT_TOTAL_HOURS_1 gt 0)fmesai_sayac_2 = fmesai_sayac_2 + 1;
		if(EXT_TOTAL_HOURS_2 gt 0)fmesai_sayac_3 = fmesai_sayac_3 + 1;
		if(EXT_TOTAL_HOURS_5 gt 0)fmesai_sayac_4 = fmesai_sayac_4 + 1;
		if(len(ext_salary_net))t_ext_Salary_net = t_ext_Salary_net + ext_salary_net;
		
		T_VERGI_ISTISNA_DAMGA = T_VERGI_ISTISNA_DAMGA +VERGI_ISTISNA_DAMGA;
		T_VERGI_ISTISNA_VERGI= T_VERGI_ISTISNA_VERGI +VERGI_ISTISNA_VERGI;
			
		if(len(SSK_MATRAH_EXEMPTION))
			SSK_MATRAH_EXEMPTION_ = SSK_MATRAH_EXEMPTION;
		else
			SSK_MATRAH_EXEMPTION_ = 0;
		
		if(len(TAX_MATRAH_EXEMPTION))
			TAX_MATRAH_EXEMPTION_ = TAX_MATRAH_EXEMPTION;
		else
			TAX_MATRAH_EXEMPTION_ = 0;	
			
		t_ssk_matrah_muafiyet = t_ssk_matrah_muafiyet + SSK_MATRAH_EXEMPTION_ + TOTAL_PAY + TOTAL_PAY_TAX;
		t_vergi_matrah_muafiyet = t_vergi_matrah_muafiyet + TAX_MATRAH_EXEMPTION_;
		
		if(len(VERGI_ISTISNA_TOTAL))
		t_vergi_istisna_net_yaz = t_vergi_istisna_net_yaz + VERGI_ISTISNA_TOTAL;
		
		t_vergi_istisna_tutar = t_vergi_istisna_tutar + VERGI_ISTISNA_DAMGA_NET;
		t_vergi_istisna_yaz = t_vergi_istisna_yaz + VERGI_ISTISNA_SSK + VERGI_ISTISNA_VERGI + VERGI_ISTISNA_DAMGA;
		t_toplam_kazanc = t_toplam_kazanc + TOTAL_SALARY -VERGI_ISTISNA_SSK-VERGI_ISTISNA_VERGI;
		t_vergi_indirimi_5084 = t_vergi_indirimi_5084 + vergi_indirimi_5084;
		

		//t_kum_gelir_vergisi_matrahi = t_kum_gelir_vergisi_matrahi + KUMULATIF_GELIR_MATRAH - gelir_vergisi_matrah;
		//Ücret kartından Dönem Başı Kümüle Vergi Tutarı geliyorsa
		if(IS_START_CUMULATIVE_TAX eq 1 and isnumeric(START_CUMULATIVE_TAX) and sal_year eq year(START_DATE))
			t_kum_gelir_vergisi = t_kum_gelir_vergisi + START_CUMULATIVE_TAX;
		//Ücret kartından Dönem Başı Kümüle Vergi Matrahı geliyorsa e bordroya yansıtılıyorsa
		if(len(CUMULATIVE_TAX_TOTAL) and  isnumeric(START_CUMULATIVE_TAX) and sal_year eq year(START_DATE))
			t_kum_gelir_vergisi_matrahi = t_kum_gelir_vergisi_matrahi + CUMULATIVE_TAX_TOTAL;
		t_gelir_vergisi_matrahi = t_gelir_vergisi_matrahi + gelir_vergisi_matrah;
		t_gelir_vergisi = t_gelir_vergisi + gelir_vergisi;
		t_damga_vergisi = t_damga_vergisi + damga_vergisi;
		t_kesinti = t_kesinti + ssk_isci_hissesi + ssdf_isci_hissesi + issizlik_isci_hissesi + damga_vergisi;
		t_net_ucret = t_net_ucret + net_ucret;
		t_vergi_iadesi = t_vergi_iadesi + vergi_iadesi;
		if(len(vergi_iadesi))
			t_vergi_iadesi_alan = t_vergi_iadesi_alan + 1;

		t_ozel_kesinti = t_ozel_kesinti + ozel_kesinti;
		t_ozel_kesinti_2 = t_ozel_kesinti_2 + ozel_kesinti_2;

		if(len(ozel_kesinti_2_net))
			t_ozel_kesinti_2_net = t_ozel_kesinti_2_net + ozel_kesinti_2_net;
		if(len(OZEL_KESINTI_2_NET_FARK))
			t_ozel_kesinti_2_net_fark = t_ozel_kesinti_2_net_fark + OZEL_KESINTI_2_NET_FARK;

		if (SAKATLIK_INDIRIMI gt 0)
		{
			t_sakatlik = t_sakatlik + SAKATLIK_INDIRIMI;
			sakat_say = sakat_say + 1;
		}
		if (GOCMEN_INDIRIMI gt 0)
		{
			t_gocmen_indirimi = t_gocmen_indirimi + GOCMEN_INDIRIMI;
		}
		t_damga_vergisi_matrahi = t_damga_vergisi_matrahi + DAMGA_VERGISI_MATRAH ;

		t_avans = t_avans + AVANS;
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
		if(ssk_statute eq 2 or ssk_statute eq 18) // Muzaffer Köse Yerltı Emekli Gurubu
		{
			ssdf_say = ssdf_say + 1;
		}
		else
		{
			ssk_say = ssk_say + 1;
		}
		if (ssdf_isveren_hissesi gt 0)
		{
			t_ssdf_ssk_days = t_ssdf_ssk_days + total_days;
			t_ssdf_days = t_ssdf_days + total_days - sunday_count;
			t_ssdf_matrah = t_ssdf_matrah + SSK_MATRAH;
			t_ssdf_isci_hissesi = t_ssdf_isci_hissesi + ssdf_isci_hissesi;
			t_ssdf_isveren_hissesi = t_ssdf_isveren_hissesi + ssdf_isveren_hissesi;
			if(len(SSK_ISCI_HISSESI_DUSULECEK))
				t_sgdp_devir = t_sgdp_devir + SSK_ISCI_HISSESI_DUSULECEK;
		}
		else
		{
			t_reel_ssk_days = t_reel_ssk_days + ssk_days;				
			if (use_ssk eq 1)
			{
				t_ssk_matrahi = t_ssk_matrahi + SSK_MATRAH;
				if(len(short_working_calc))t_short_working_calc = t_short_working_calc + short_working_calc;
				t_ssk_primi_isci = t_ssk_primi_isci + ssk_isci_hissesi;
				t_ssk_primi_isveren = t_ssk_primi_isveren + ssk_isveren_hissesi;
			}
		}
		t_bes_primi_isci = t_bes_primi_isci + bes_isci_hissesi;
		
		t_total_pay_ssk_tax = t_total_pay_ssk_tax + total_pay_ssk_tax;
		t_total_pay_ssk = t_total_pay_ssk + total_pay_ssk;
		t_total_pay_tax = t_total_pay_tax + total_pay_tax;
		t_total_pay = t_total_pay + total_pay;

		//ssk işçi primi indirimli
		t_isci_primi_indirimli = t_ssk_primi_isci - (t_ssk_primi_isci_6322 + t_ssk_isci_hissesi_7252 + t_ssk_isci_hissesi_7256 + t_ssk_isci_hissesi_7103);
		//ssk işsizlik işçi pirimi indirimli
		t_issizlik_isci_primi_indirimli = t_issizlik_isci_hissesi - (t_issizlik_isci_hissesi_7252 + t_issizlik_isci_hissesi_7256 + t_issizlik_isci_hissesi_687 + t_issizlik_isci_hissesi_7103 );
		//ssk işsizlik işveren primi indirimli
		t_issizlik_isveren_primi_indirimli = t_issizlik_isveren_hissesi - (t_issizlik_isveren_hissesi_687 + t_issizlik_isveren_hissesi_7103 + t_issizlik_isveren_hissesi_7252 + t_issizlik_isveren_hissesi_7256);

	</cfscript>
	<cfquery name="get_devreden" datasource="#dsn#">
		SELECT 
			AMOUNT 
		FROM 
			#add_puantaj_table# 
		WHERE 
			EMPLOYEE_PUANTAJ_ID = #EMPLOYEE_PUANTAJ_ID# AND 
			<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_mon_end)>
				(
					(SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
					OR
					(
						SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
						SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
						(
							SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">
							OR
							(SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
						)
					)
					OR
					(
						SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
						(
							SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">
							OR
							(SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
						)
					)
					OR
					(
						SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
						SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
						SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
					)
				)
			<cfelse>
				SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
				SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
			</cfif>
	</cfquery>
	<cfif get_devreden.recordcount>
		<cfset t_devreden = t_devreden + get_devreden.amount>
	</cfif>
</cfoutput>
<cfif icmal_type is 'personal'>
<!-- sil -->
</cfif>

<cfif isdefined("url.fuseaction") and url.fuseaction eq 'ehesap.popupflush_view_puantaj_print_pdf'>
	<cfset uidrop_value="0">
	<cfset title="">
<cfelse>
	<cfset uidrop_value="1">
	<cfset title="Bordro">
</cfif>
<cfquery name="GET_PROTESTS" datasource="#DSN#" maxrows="1">
	SELECT * FROM EMPLOYEES_PUANTAJ_PROTESTS WHERE SAL_MON=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND SAL_YEAR=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EMPLOYEE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> ORDER BY PROTEST_ID DESC
</cfquery>

<cf_box title="#title#" closable="0" uidrop="#uidrop_value#">
	<div <cfif icmal_type is 'personal' and listFirst(attributes.fuseaction,".") is 'myhome'>class="col col-10"<cfelse>class="col col-12"</cfif>>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cf_grid_list cellspacing="0" cellpadding="2" align="center" >  
                    <cfoutput>
                        <tr>
                            <td width="50%" colspan="2" class="icmal_border_last_td">
                                <b><cf_get_lang_main no="1073.Şirket Adı"> :</b>
                                <cfif icmal_type is 'personal'>
                                    <cfoutput>#GET_PUANTAJ_PERSONAL.COMP_FULL_NAME# - #GET_PUANTAJ_PERSONAL.PUANTAJ_BRANCH_FULL_NAME#<br />
                                    <b><cf_get_lang_main no='667.İnternet'> :</b> #WEB#<br />
                                    <b><cf_get_lang_main no="1311.Adres"> :</b> #ADDRESS#<br />
                                    <cfif len(mersis_no)>
                                    <b>Mersis No :</b> #mersis_no#
                                    <cfelse>
                                    <b><cf_get_lang no='549.Ticaret Sicil No'> :</b> #T_NO#
                                    </cfif>
                                    </cfoutput>
                                <cfelseif icmal_type is 'genel'>
                                    <cfset o_comp_list = listdeleteduplicates(valuelist(get_puantaj_rows.COMP_FULL_NAME))>
                                    <cfoutput>#o_comp_list#</cfoutput><br />
                                    <cfset b_list = listdeleteduplicates(valuelist(get_puantaj_rows.PUANTAJ_BRANCH_FULL_NAME))>
                                    <cfoutput>#b_list#</cfoutput>
                                    <cfif listlen(o_comp_list) eq 1><!--- isdefined("attributes.branch_id") and listlen(attributes.branch_id) eq 1--->
                                        <br /><cfset web_list = listdeleteduplicates(valuelist(get_puantaj_rows.WEB))>
                                        <cfoutput><b><cf_get_lang_main no='667.İnternet'> :</b> #web_list#</cfoutput><br />
                                        <cfif isdefined("attributes.branch_id") and listlen(attributes.branch_id) and listlen(b_list) eq 1>
                                            <cfoutput><b><cf_get_lang_main no="1311.Adres"> :</b> #get_puantaj_rows.BRANCH_ADDRESS# #get_puantaj_rows.BRANCH_COUNTY# #get_puantaj_rows.BRANCH_CITY#</cfoutput><br />
                                        <cfelse>
                                            <cfset o_comp_address_list = listdeleteduplicates(valuelist(get_puantaj_rows.ADDRESS))>
                                            <cfoutput><b><cf_get_lang_main no="1311.Adres"> :</b> #o_comp_address_list#</cfoutput><br />
                                        </cfif>
                                        <cfset o_mersis_list = listdeleteduplicates(valuelist(get_puantaj_rows.mersis_no))>
                                        <cfset o_tno_list = listdeleteduplicates(valuelist(get_puantaj_rows.T_NO))>
                                        <cfoutput>
                                            <cfif len(o_mersis_list)><b>Mersis No :</b> #o_mersis_list#<cfelse><b><cf_get_lang no='549.Ticaret Sicil No'> :</b> #o_tno_list#</cfif>
                                        </cfoutput>
                                    </cfif>
                                <cfelseif icmal_type is 'masraf merkezi'>
                                    <cfif Len(attributes.ssk_office)>
                                        <cfoutput>#ListLast(attributes.ssk_office, '-')# - #ListGetAt(attributes.ssk_office, 3, '-')#</cfoutput>
                                    </cfif>
                                </cfif>
                                <cfif isdefined("attributes.department") and listlen(attributes.department)>
                                    <br><b><cf_get_lang_main no="160.Departman">:</b>
                                    <cfset d_list = listdeleteduplicates(valuelist(get_puantaj_rows.ROW_DEPARTMENT_HEAD))>
                                    <cfoutput>#d_list#</cfoutput><br />
                                </cfif>
                            </td>
                            <td width="50%" colspan="2" class="icmal_border_last_td">
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td>
                                            #listgetat(ay_list(),attributes.sal_mon)# 
                                            #attributes.sal_year#
                                            <cfif not (isdefined("attributes.view_type") and attributes.view_type eq 1)>
                                                &nbsp;
                                                <cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_year_end) and ((attributes.sal_year_end eq attributes.sal_year and attributes.sal_mon_end neq attributes.sal_mon) or attributes.sal_year_end neq attributes.sal_year)> - #listgetat(ay_list(),attributes.sal_mon_end)# #attributes.sal_year_end#</cfif>&nbsp; 
                                            </cfif>
                                            <cfif not attributes.fuseaction contains "popup_view_price_compass"><cf_get_lang_main no="1172.İcmal"><cfelse><cf_get_lang no="29.Ücret Pusulası"></cfif>
                                        </td>
                                        <td style="text-align:right" class="txtbold">
                                            <cfif icmal_type is "personal">
                                                <cf_get_lang_main no="160.Departman"> : #GET_PUANTAJ_PERSONAL.ROW_DEPARTMENT_HEAD#
                                            </cfif>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" class="icmal_border_without_top">
                                <cfif icmal_type is "genel">
                                    <b><cf_get_lang no="779.Şube SGK">:</b> 
                                    <cfset s_info_list = listdeleteduplicates(valuelist(get_puantaj_rows.SUBE_SSK_INFO))>
                                    #s_info_list#
                                </cfif>
                                <cfif icmal_type is "personal">
                                    <cf_get_lang no="779.Şube SGK"> : #ssk_m##SSK_JOB##SSK_BRANCH##SSK_BRANCH_OLD##B_SSK_NO##SSK_CITY##SSK_COUNTRY##SSK_CD##SSK_AGENT#<br/>
                                    <cf_get_lang no="823.Adı Soyadı"> :#employee_name# #employee_surname#<br/>
                                    <cf_get_lang_main no="1075.Çalışan No"> :#EMPLOYEE_NO#
                                </cfif>
                                <cfif isdefined("attributes.ssk_statute") and listlen(attributes.ssk_statute)>
                                    <br><b><cf_get_lang no="607.SGK Statüleri"> :</b>
                                    <cfset s_list = attributes.ssk_statute>
                                    <cfloop list="#s_list#" index="ccc">
                                        <cfoutput>#listgetat(list_ucret_names(),listfindnocase(list_ucret(),ccc,','),'*')#</cfoutput><cfif ccc - 1 neq ListLen(s_list) AND ccc gt 1>,</cfif>
                                    </cfloop>
                                </cfif>
                                <cfif icmal_type is "genel">
                                    <cfif isdefined("attributes.EXPENSE_CENTER") and len(attributes.EXPENSE_CENTER)>
                                        <br>
                                    <cfset exp_code_list = listdeleteduplicates(valuelist(get_puantaj_rows.EXP_NAME))>
                                        <b><cf_get_lang_main no="1048.Masraf Merkezi">:</b> #exp_code_list#
                                    </cfif>
                                    <cfif isdefined('attributes.duty_type') and len(attributes.duty_type)>
                                        <br />
                                        <cfset duty_type_name = "">
                                        <cfset duty_type_list = listdeleteduplicates(valuelist(get_puantaj_rows.duty_type))>
                                        <cfif len(duty_type_list)>
                                        <cfloop list="#duty_type_list#" delimiters="," index="t">
                                            <cfif t eq 2>
                                                <cfsavecontent variable="message"><cf_get_lang_main no="164.Çalışan"></cfsavecontent>
                                            <cfelseif t eq 1>
                                                <cfsavecontent variable="message"><cf_get_lang no="194.İşveren Vekili"></cfsavecontent>
                                            <cfelseif t eq 0>
                                                <cfsavecontent variable="message"><cf_get_lang no='604.İşveren'></cfsavecontent>
                                            <cfelseif t eq 3>
                                                <cfsavecontent variable="message"><cf_get_lang no="206.Sendikalı"></cfsavecontent>
                                            <cfelseif t eq 4>
                                                <cfsavecontent variable="message"><cf_get_lang no="232.Sözleşmeli"></cfsavecontent>
                                            <cfelseif t eq 5>
                                                <cfsavecontent variable="message"><cf_get_lang no="223.Kapsam Dışı"></cfsavecontent>
                                            <cfelseif t eq 6>
                                                <cfsavecontent variable="message"><cf_get_lang no="236.Kısmi İstihdam"></cfsavecontent>
                                            <cfelseif t eq 7>
                                                <cfsavecontent variable="message"><cf_get_lang no="253.Taşeron"></cfsavecontent>
                                            </cfif>
                                            <cfset duty_type_name = listappend(duty_type_name,"#message#",',')>						
                                        </cfloop>
                                        </cfif>
                                        <b><cf_get_lang_main no="1126.Görev Tipi">:</b> #duty_type_name#
                                    </cfif>
                                    <cfif isdefined('attributes.period_code_cat') and len(attributes.period_code_cat)>				
                                        <br />
                                        <cfset account_code_list = listdeleteduplicates(valuelist(get_puantaj_rows.definition))>
                                        <b><cf_get_lang no='1171.Muhasebe Kod Grubu'>:</b> #account_code_list#
                                    </cfif>
                                </cfif>
                            </td>
                            <td colspan="2" class="icmal_border_last_td_without_top">
                                <cfif icmal_type is not "personal">
                                    <b><cf_get_lang no="824.Kişi Sayısı">:</b>#kisi_say#
                                <cfelse>
                                    <cfset attributes.branch_id = GET_PUANTAJ_PERSONAL.branch_id>
                                    <cfif x_get_sgkno eq 1><cf_get_lang no="291.SGK No">:#GET_PUANTAJ_PERSONAL.SOCIALSECURITY_NO#<br/></cfif>
                                    <cf_get_lang no='1319.TC No'>:#GET_PUANTAJ_PERSONAL.tc_identy_no#
                                    <cfif x_get_groupdate eq 1>&nbsp;<cf_get_lang no='758.Gruba Giriş'>:#dateformat(GROUP_STARTDATE,dateformat_style)#</cfif><br/>
                                    <cfif x_get_kidemdate eq 1><cf_get_lang no='695.Kıdem Baz Tarihi'>:#dateformat(KIDEM_DATE,dateformat_style)#</cfif><br/>
                                    <cf_get_lang no="756.İşe Giriş">:#dateformat(GET_PUANTAJ_PERSONAL.START_DATE,dateformat_style)#
                                    <cfif len(GET_PUANTAJ_PERSONAL.FINISH_DATE) and (month(FINISH_DATE) eq attributes.sal_mon and year(FINISH_DATE) eq attributes.sal_year)>- <cf_get_lang_main no="19.Çıkış">:#dateformat(GET_PUANTAJ_PERSONAL.FINISH_DATE,dateformat_style)#</cfif>
                                </cfif>
                            </td>
                        </tr>
                    </cfoutput>
                </cf_grid_list>
            </div>
        </div>
        <cfquery name="get_additional" dbtype="query">
            SELECT * FROM get_odeneks WHERE COMMENT_TYPE <> 2
        </cfquery> 
        <cfset add_total_hour = 0> 
		<cfset genel_odenek_total = 0> 
		<cfset genel_odenek_total_net = 0>
        <cfoutput query="get_additional" group="COMMENT_PAY">
            <cfquery name="get_odenek_say" dbtype="query">
                SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_additional WHERE COMMENT_PAY = '#comment_pay#'
            </cfquery>
            <cfif get_odenek_say.recordcount><cfset odenek_say = get_odenek_say.recordcount></cfif>
            <cfset tmp_total = 0>
            <cfset amount_pay_total = 0>
            
            <cfoutput>
                <cfif listfindnocase('2,3,4',PAY_METHOD)>
                    <cfset tmp_total = tmp_total + amount_2>
                <cfelse>
                    <cfset tmp_total = tmp_total + amount>
                </cfif>
                <cfif len(amount_pay)>
                    <cfset amount_pay_total = amount_pay_total+amount_pay>
                </cfif>
            </cfoutput>
            <cfset add_total_hour = add_total_hour + total_hour>
            <cfif not (len(is_income) and is_income eq 1)>
                <cfset genel_odenek_total = genel_odenek_total + tmp_total>
                <cfset genel_odenek_total_net = genel_odenek_total_net + amount_pay_total>
            </cfif>
        </cfoutput>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_grid_list align="center">  
                    <cfoutput>
                        <tr>
                            <tr>
                                <td width="300px">
                                    <cf_get_lang dictionary_id='53249.Gelir Vergisi Matrahı'>
                                </td>
                                <td style="text-align:right">#tlformat(t_gelir_vergisi_matrahi)#</td>
                            </tr>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='63269.Süregelen GV Matrahları Toplamı'>
                            </td>
                            <td style="text-align:right">#TLFormat(t_kum_gelir_vergisi_matrahi+t_gelir_vergisi_matrahi)#</td>
                        </tr> 
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='53659.Asgari Geçim İndirimi'>
                            </td>
                            <td style="text-align:right">#TLFormat(t_vergi_iadesi)#</td>
                        </tr>
                    </cfoutput>
                </cf_grid_list>
            </div>
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_grid_list align="center">  
                    <cfoutput>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='46377.Toplam Saat'>
                            </td>
                            <td style="text-align:center">
                                #tlformat(add_total_hour)#
                            </td>
                        </tr>
                        <tr>
                            <td width="300px">
                                <cf_get_lang dictionary_id='38990.Brüt'>
                            </td>
                            <td style="text-align:right">#tlformat(genel_odenek_total)#</td>
                        </tr>
                        <tr>
                            <td width="300px">
                                &nbsp;
                            </td>
                            <td style="text-align:right">&nbsp;</td>
                        </tr>
                    </cfoutput>
                </cf_grid_list>         
            </div>
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_grid_list align="center">  
                    <cfoutput>
                        <tr>
                            <td width="300px"><cf_get_lang dictionary_id='63289.Hakedişler Toplamı'></td>
                            <td width="300px" style="text-align:right">#TLFormat((t_toplam_kazanc+t_istisna_odenek+t_issizlik_isveren_hissesi+t_ssk_primi_isveren_hesaplanan+t_ssdf_isveren_hissesi)-(t_ssk_primi_isveren_5510+t_ssk_primi_isveren_5084+t_ssk_primi_isveren_5921+t_ssk_primi_isveren_5746+t_ssk_primi_isveren_4691 +t_ssk_primi_isveren_6111+t_ssk_primi_isveren_6486+t_ssk_primi_isveren_6322+t_ssk_primi_isci_6322+t_ssk_primi_isveren_gov+t_ssk_primi_isveren_25510+t_ssk_primi_isveren_14857+t_ssk_primi_isveren_6645 + t_ssk_primi_isveren_46486 + t_ssk_primi_isveren_56486 + t_ssk_primi_isveren_66486 +toplam_indirim_687+toplam_indirim_7103+t_toplam_indirim_7252+t_toplam_indirim_7256)+t_ozel_kesinti_2_net_fark)#</td>
                        </tr>
                        <tr>
                            <td width="300px"><cf_get_lang dictionary_id='63290.Kesintiler Toplamı'></td>
                            <td width="300px" style="text-align:right">#TLFormat(t_ssk_primi_isci + t_ssdf_isci_hissesi + t_gelir_vergisi + t_damga_vergisi + t_issizlik_isci_hissesi + t_bes_primi_isci + t_ozel_kesinti_2+t_ozel_kesinti+t_avans+t_istisna_kesinti)#</td>
                        </tr>
                        <tr>
                            <td width="300px"><cf_get_lang dictionary_id='40400.Net Ödeme'></td>
                            <td width="300px" style="text-align:right">#TLFormat(t_net_ucret-t_vergi_iadesi - t_stampduty_5746 + t_avans+t_ozel_kesinti+t_ozel_kesinti_2_net+t_bes_primi_isci)#</td>
                        </tr>
                    </cfoutput>
                </cf_grid_list>         
            </div>
        </div>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cf_grid_list align="center">  
                    <tbody>
                        <tr>
                            <td>
                                <cf_get_lang dictionary_id='40073.Ödenek'>
                            </td>
                            <td>
                                <cf_get_lang dictionary_id='57491.Saat'>
                            </td>
                            <td>
                                <cf_get_lang dictionary_id='40462.Birim Ücret'>
                            </td>
                            <td>
                                <cf_get_lang dictionary_id='31282.Ücret'>
                            </td>
                            <td>
                                <cf_get_lang dictionary_id='41439.Damga Vergisi'>
                            </td>
                            <td>
                                <cf_get_lang dictionary_id='40452.Gelir vergisi'>
                            </td>
                        </tr>
                        <cfoutput query="get_additional" group="COMMENT_PAY">
                            <cfquery name="get_odenek_say" dbtype="query">
                                SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_additional WHERE COMMENT_PAY = '#comment_pay#'
                            </cfquery>
                            <cfif get_odenek_say.recordcount><cfset odenek_say = get_odenek_say.recordcount></cfif>
                            <cfset tmp_total = 0>
                            <cfset amount_pay_total = 0>
                            <cfset hour = 0>
                            <cfset gelir_vergisi_ = 0>
                            <cfset damga_vergisi_ = 0>
                            <cfquery name="get_unit" datasource="#dsn#">
                                SELECT AMOUNT_PAY FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = #COMMENT_PAY_ID#
                            </cfquery>
                            <cfoutput>
                                <cfif listfindnocase('2,3,4',PAY_METHOD)>
                                    <cfset tmp_total = tmp_total + amount_2>
                                <cfelse>
                                    <cfset tmp_total = tmp_total + amount>
                                </cfif>
                                <cfif len(amount_pay)>
                                    <cfset amount_pay_total = amount_pay_total+amount_pay>
                                </cfif>
                                <cfif len(total_hour)>
                                    <cfset hour = hour + total_hour>
                                </cfif>
                                <cfset gelir_vergisi_ = gelir_vergisi_ + gelir_vergisi>
                                <cfset damga_vergisi_ = damga_vergisi_ + damga_vergisi>
                            </cfoutput>
                            <tr>
                                <td width="300px">#comment_pay# <cfif icmal_type is 'genel'>(#odenek_say#)</cfif></td>
                                <td style="text-align:center">#TLFormat(hour)#</td>
                                <td style="text-align:right">#TLFormat(get_unit.AMOUNT_PAY)#</td>
                                <td style="text-align:right">#TLFormat(tmp_total)#</td>
                                <td style="text-align:right">#TLFormat(damga_vergisi_)#</td>
                                <td style="text-align:right">#TLFormat(gelir_vergisi_)#</td>
                                <!--- <cfif is_view_net eq 1>
                                    <td style="text-align:right">#TLFormat(amount_pay_total)#</td>
                                </cfif> --->
                            </tr>
                            <cfif not (len(is_income) and is_income eq 1)>
                                <cfset genel_odenek_total = genel_odenek_total + tmp_total>
                                <cfset genel_odenek_total_net = genel_odenek_total_net + amount_pay_total>
                            </cfif>
                        </cfoutput>
                    </tbody>
                </cf_grid_list>
            </div>
        </div>
        <!--- <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                <cf_grid_list align="center">  
                    <cfoutput>
                        
                    </cfoutput>
                </cf_grid_list>
            </div>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                <cf_grid_list align="center">  
                    <cfoutput>
                        
                    </cfoutput>
                </cf_grid_list>
            </div>
        </div> --->
    </div>
	<cfif icmal_type is 'personal' and listFirst(attributes.fuseaction,".") is 'myhome'>
		<div class="col col-2">
			<ul class="ui-list padding-top-20">
				<li class="bold mb-0">
					<cf_get_lang dictionary_id ='31779.Puantaj Hazırlandı'>
				</li>
				<li class="bold mb-0">
					<cf_get_lang dictionary_id ='31780.Bordro Okundu'><cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>
				</li>
				<cfquery name="get_apply_status" datasource="#dsn#">
					SELECT 
						APPLY_DATE,
						ROW_ID
					FROM 
						EMPLOYEES_PUANTAJ_MAILS 
					WHERE 
						EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.employee_id#"> AND
						BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.branch_id#"> AND 
						SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.sal_mon#"> AND 
						SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.sal_year#">
				</cfquery>	
				<cfif get_apply_status.recordcount>
					<li class="bold mb-0">
						<p id="bordro_onay_td">
							<cfif len(get_apply_status.apply_date)>
								Bordro Onaylandı <cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>
							<cfelse>
								<span class="btnPointer" class="btnPointer" onclick="bordro_onayla('<cfoutput>#get_apply_status.ROW_ID#</cfoutput>');">Bordro Onayla</span>
							</cfif>
						</p>
					</li>
				</cfif>
				<cfoutput>
					<cfif get_protests.recordcount>
						<li class="bold mb-0">
							<span class="btnPointer" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_bordro_protests&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&emp_puantaj_id=#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#&puantaj_id=#GET_PUANTAJ_PERSONAL.PUANTAJ_ID#','list');"><cf_get_lang dictionary_id ='31784.İtirazlarım'></span>
						</li>
					</cfif>
					<cfif get_protests.recordcount and len(get_protests.answer_date)>
						<li class="bold mb-0">
							<span class="btnPointer" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_bordro_protests&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&emp_puantaj_id=#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#&puantaj_id=#GET_PUANTAJ_PERSONAL.PUANTAJ_ID#','list');"><cf_get_lang dictionary_id ='31785.İtirazlara Cevaplar'></span>
						</li>
					</cfif>
					<cfif not get_protests.recordcount>
						<li class="bold mb-0">
							<span class="btnPointer" onclick="windowopen('#request.self#?fuseaction=myhome.popup_add_puantaj_protest&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&emp_puantaj_id=#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#&puantaj_id=#GET_PUANTAJ_PERSONAL.PUANTAJ_ID#&branch_id=#GET_PUANTAJ_PERSONAL.branch_id#','small');"><cf_get_lang dictionary_id ='31715.İtiraz Et'></span>
						</li>
					</cfif>
				</cfoutput>
			</ul>
		</div>
	</cfif>
</cf_box>

<cf_get_lang_set module_name="#fusebox.circuit#">
	<script type="text/javascript">
		function bordro_onayla(row_id)
		{
			$.ajax({                
					url: '<cfoutput>#request.self#?fuseaction=myhome.emptypopup_apply_puantaj&row_id=</cfoutput>'+row_id,
					type: "GET",
					success: function (returnData) {
						document.getElementById('bordro_onay_td').innerHTML = 'Bordro Onaylandı <cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>';
					}
					
				});
		}
	</script>