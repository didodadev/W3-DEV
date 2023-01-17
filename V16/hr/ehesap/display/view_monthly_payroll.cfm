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
	t_salary = 0;
	t_base_salary = 0;
	t_retirement_allowance = 0;
	t_retirement_allowance_personal = 0;
	t_retirement_allowance_personal_interruption = 0;
	t_general_health_insurance = 0;
	t_sgk_base = 0;
	t_additional_indicator_compensation = 0;
	t_extra_pay = 0;
	t_additional_score = 0;
	t_normal_additional_score = 0;
	t_audit_compensation_amount = 0;
	t_retired_academic = 0;

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
	t_collective_agreement_bonus = 0;
	t_high_education_compensation = 0;
	t_land_compensation_amount = 0;
    t_tazminatlar = 0;
	
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
	t_istisna = 0;
	
	
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
	t_plus_retired = 0;//Artış %100
    t_plus_retired_person = 0;//Kişi Devlet %100
	t_penance_deduction = 0;//Kefaret kesintisi

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
    t_academic_incentive_allowance_amount = 0;//akademik teşvik ödeneği
    t_executive_indicator_compensation = 0;//Makam tazminatı
    t_administrative_duty_allowance = 0;//idari görev tazminatı
    t_education_allowance = 0;//eğitim öğretim ödeneği
    t_administrative_compensation = 0;//Görev tazminatı
	
	t_retirement_allowance_5510 = 0;
	t_retirement_allowance_personal_5510 = 0;
	t_health_insurance_premium_5510 = 0;
	t_health_insurance_premium_personal_5510 = 0;
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

<cfquery name="get_personal" dbtype="query">
	SELECT * FROM get_puantaj_personal WHERE STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.STATUE_TYPE#">
</cfquery>
<cfoutput query="get_personal">
	<cfscript>
		//Gün toplamları
		//normal gün
		t_normal_gun = t_normal_gun + weekly_day;
		t_normal_hours = t_normal_hours + weekly_hour;
		if(len(RETIRED_ACADEMIC) and RETIRED_ACADEMIC gt 0)
			t_retired_academic = t_retired_academic + retired_academic;
		
		if(len(ADDITIONAL_SCORE))
			t_additional_score =  t_additional_score + ADDITIONAL_SCORE;
		if(len(NORMAL_ADDITIONAL_SCORE))
			t_normal_additional_score =  t_normal_additional_score + NORMAL_ADDITIONAL_SCORE;
		if(len(audit_compensation_amount))
			t_audit_compensation_amount = t_audit_compensation_amount + audit_compensation_amount;
		
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

		if(len(collective_agreement_bonus))
			t_collective_agreement_bonus = t_collective_agreement_bonus + collective_agreement_bonus;
		if(len(high_education_compensation_payroll))
			t_high_education_compensation = t_high_education_compensation + high_education_compensation_payroll;
		if(len(land_compensation_amount))
			t_land_compensation_amount = t_land_compensation_amount + land_compensation_amount;
		//Aylık tutar
		t_salary = t_salary + salary;
		//Taban aylık
		if(len(base_salary))
			t_base_salary = t_base_salary + base_salary;
		if(len(retirement_allowance))
			t_retirement_allowance = t_retirement_allowance + retirement_allowance;
		if(len(retirement_allowance_personal))
			t_retirement_allowance_personal = t_retirement_allowance_personal + retirement_allowance_personal;
		if(len(retirement_allowance_personal_interruption))
			t_retirement_allowance_personal_interruption = t_retirement_allowance_personal_interruption + retirement_allowance_personal_interruption;
		if(len(general_health_insurance))
			t_general_health_insurance = t_general_health_insurance + general_health_insurance;
		if(len(sgk_base))
			t_sgk_base = t_sgk_base + sgk_base;
		if(len(plus_retired))
			t_plus_retired = t_plus_retired + plus_retired;//Artış %100
		if(len(plus_retired_personal))
    		t_plus_retired_person = t_plus_retired_person + plus_retired_personal;//Kişi Devlet %100
		if(len(additional_indicator_compensation))
			t_additional_indicator_compensation = t_additional_indicator_compensation + additional_indicator_compensation;
		if(len(retirement_allowance_5510))
			t_retirement_allowance_5510 = t_retirement_allowance_5510 + retirement_allowance_5510;
		if(len(retirement_allowance_personal_5510))
			t_retirement_allowance_personal_5510 = t_retirement_allowance_personal_5510 + retirement_allowance_personal_5510;
		if(len(health_insurance_premium_5510))
			t_health_insurance_premium_5510 = t_health_insurance_premium_5510 + health_insurance_premium_5510;
		if(len(health_insurance_premium_personal_5510))
			t_health_insurance_premium_personal_5510 = t_health_insurance_premium_personal_5510 + health_insurance_premium_personal_5510;
		if(len(extra_pay))
			t_extra_pay = t_extra_pay + extra_pay; 

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
		if(len(academic_incentive_allowance_amount))
        	t_academic_incentive_allowance_amount = t_academic_incentive_allowance_amount + academic_incentive_allowance_amount;//Akademik teşvik ödeneği
        if(len(executive_indicator_compensation))
            t_executive_indicator_compensation = t_executive_indicator_compensation + executive_indicator_compensation;//Makam tazminatı
        if(len(administrative_duty_allowance))
            t_administrative_duty_allowance = t_administrative_duty_allowance + administrative_duty_allowance;//idari görev tazminatı
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
		t_toplam_kazanc = t_toplam_kazanc + TOTAL_SALARY;
		
		t_vergi_indirimi_5084 = t_vergi_indirimi_5084 + vergi_indirimi_5084;
		if(is_5746_control eq 0) //arge indiriminin gelir vergisinden düşülmemesi ile ilgili toplam icmal icin eklendi //SG 20140306
		{
			if(len(gelir_vergisi_indirimi_5746) and gelir_vergisi_indirimi_5746 gt 0)
			{
				t_vergi_indirimi_5746_all = t_vergi_indirimi_5746_all + gelir_vergisi_indirimi_5746;
			}
			if(len(damga_vergisi_indirimi_5746) and damga_vergisi_indirimi_5746 gt 0)
			{
				t_damga_vergisi_indirimi_5746_all = t_damga_vergisi_indirimi_5746_all + damga_vergisi_indirimi_5746;
			}
			if(len(stampduty_5746))
				t_stampduty_5746 = t_stampduty_5746 + stampduty_5746;
		}
		if(len(gelir_vergisi_indirimi_5746) and gelir_vergisi_indirimi_5746 gt 0)
		{
			t_vergi_indirimi_5746 = t_vergi_indirimi_5746 + gelir_vergisi_indirimi_5746;
		}
		if(len(damga_vergisi_indirimi_5746) and damga_vergisi_indirimi_5746 gt 0)
		{
			t_damga_vergisi_indirimi_5746 = t_damga_vergisi_indirimi_5746 + damga_vergisi_indirimi_5746;
		}
		
		
		if(len(tax_days_5746))
			t_vergi_indirimi_5746_days = t_vergi_indirimi_5746_days + tax_days_5746;
			
		if(len(ssk_days_5746))
			t_ssk_days_5746 = t_ssk_days_5746 + ssk_days_5746;
		
		
		if(is_4691_control eq 0)
		{
			t_vergi_indirimi_4691_all = t_vergi_indirimi_4691_all + gelir_vergisi_indirimi_4691;
			t_vergi_indirimi_4691 = t_vergi_indirimi_4691 + gelir_vergisi_indirimi_4691;
		}
		

		//t_kum_gelir_vergisi_matrahi = t_kum_gelir_vergisi_matrahi + KUMULATIF_GELIR_MATRAH - gelir_vergisi_matrah;
		//Ücret kartından Dönem Başı Kümüle Vergi Tutarı geliyorsa
		// todo : kapatılan alanlar test için kapatldı. Geri açılacak.
		if(IS_START_CUMULATIVE_TAX eq 1 and isnumeric(START_CUMULATIVE_TAX) /* and sal_year eq year(START_DATE) */)
			t_kum_gelir_vergisi = t_kum_gelir_vergisi + START_CUMULATIVE_TAX;
		//Ücret kartından Dönem Başı Kümüle Vergi Matrahı geliyorsa e bordroya yansıtılıyorsa
		if(len(CUMULATIVE_TAX_TOTAL) and  isnumeric(START_CUMULATIVE_TAX) /* and sal_year eq year(START_DATE) */)
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
		if(len(penance_deduction))
			t_penance_deduction = t_penance_deduction + penance_deduction;

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
		if(ssk_statute eq 2)
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
				isveren_hesaplanan = ssk_isveren_hissesi + ssk_isveren_hissesi_5510 + ssk_isveren_hissesi_5084;
				t_ssk_primi_isveren_hesaplanan = t_ssk_primi_isveren_hesaplanan + isveren_hesaplanan;
				t_ssk_primi_isveren_5510 = wrk_round(t_ssk_primi_isveren_5510,2) + ssk_isveren_hissesi_5510;
				t_ssk_primi_isveren_5084 = t_ssk_primi_isveren_5084 + ssk_isveren_hissesi_5084;
				t_ssk_primi_isveren_5921 = t_ssk_primi_isveren_5921 + ssk_isveren_hissesi_5921;
				t_ssk_primi_isveren_5746 = t_ssk_primi_isveren_5746 + ssk_isveren_hissesi_5746;
				if(len(ssk_isveren_hissesi_4691))
					t_ssk_primi_isveren_4691 = t_ssk_primi_isveren_4691 + ssk_isveren_hissesi_4691;
				if(len(ssk_isveren_hissesi_6111))
					t_ssk_primi_isveren_6111 = t_ssk_primi_isveren_6111 + ssk_isveren_hissesi_6111;
				if(len(ssk_isveren_hissesi_6486))
					t_ssk_primi_isveren_6486 = t_ssk_primi_isveren_6486 + ssk_isveren_hissesi_6486;
				if(len(ssk_isveren_hissesi_6322))
					t_ssk_primi_isveren_6322 = t_ssk_primi_isveren_6322 + ssk_isveren_hissesi_6322;
				if(len(ssk_isci_hissesi_6322))
					t_ssk_primi_isci_6322 = t_ssk_primi_isci_6322 + ssk_isci_hissesi_6322;
				if(len(ssk_isveren_hissesi_25510))
					t_ssk_primi_isveren_25510 = t_ssk_primi_isveren_25510 + ssk_isveren_hissesi_25510;
				if(len(ssk_isveren_hissesi_14857))
					t_ssk_primi_isveren_14857 = t_ssk_primi_isveren_14857 + ssk_isveren_hissesi_14857;
				if(len(ssk_isveren_hissesi_6645))
					t_ssk_primi_isveren_6645 = t_ssk_primi_isveren_6645 + ssk_isveren_hissesi_6645;
				if(len(ssk_isveren_hissesi_46486))
					t_ssk_primi_isveren_46486 = t_ssk_primi_isveren_46486 + ssk_isveren_hissesi_46486;
				if(len(ssk_isveren_hissesi_56486))
					t_ssk_primi_isveren_56486 = t_ssk_primi_isveren_56486 + ssk_isveren_hissesi_56486;
				if(len(ssk_isveren_hissesi_66486))
					t_ssk_primi_isveren_66486 = t_ssk_primi_isveren_66486 + ssk_isveren_hissesi_66486;
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
				
				if(len(ssk_isveren_hissesi_687))
					t_isveren_primi_687 = t_isveren_primi_687 + ssk_isveren_hissesi_687;
				
				if(len(ssk_isci_hissesi_687) or len(ssk_isveren_hissesi_687))
					t_ssk_primi_687 = t_ssk_primi_687 + ssk_isveren_hissesi_687 + ssk_isci_hissesi_687;
					
				if(len(issizlik_isci_hissesi_687) or len(issizlik_isveren_hissesi_687))
				{
					t_issizlik_primi_687 = t_issizlik_primi_687 + issizlik_isci_hissesi_687 + issizlik_isveren_hissesi_687;
					t_issizlik_isci_hissesi_687 = t_issizlik_isci_hissesi_687 + issizlik_isci_hissesi_687;
					t_issizlik_isveren_hissesi_687 = t_issizlik_isveren_hissesi_687 + issizlik_isveren_hissesi_687;
				}
					
				
				if(len(gelir_vergisi_indirimi_687))
					t_gelir_vergisi_primi_687 = t_gelir_vergisi_primi_687 + gelir_vergisi_indirimi_687;
					
				if(len(damga_vergisi_indirimi_687))
					t_damga_vergisi_primi_687 = t_damga_vergisi_primi_687 + damga_vergisi_indirimi_687;
				if(len(ssk_isveren_hissesi_687))
					toplam_indirim_687 =  toplam_indirim_687 + ssk_isveren_hissesi_687 + ssk_isci_hissesi_687 + issizlik_isveren_hissesi_687 + issizlik_isci_hissesi_687 + gelir_vergisi_indirimi_687 + damga_vergisi_indirimi_687;
				
				if(len(ssk_isveren_hissesi_7103))
				{
					t_isveren_primi_7103 = t_isveren_primi_7103 + ssk_isveren_hissesi_7103;
					t_ssk_primi_7103 = t_ssk_primi_7103 + ssk_isci_hissesi_7103 + ssk_isveren_hissesi_7103;
					t_ssk_isveren_hissesi_7103 = t_ssk_isveren_hissesi_7103 + ssk_isveren_hissesi_7103;
					t_issizlik_primi_7103 = t_issizlik_primi_7103 + issizlik_isci_hissesi_7103 + issizlik_isveren_hissesi_7103;
					if(len(gelir_vergisi_indirimi_7103))
					{
						t_gelir_vergisi_primi_7103 = t_gelir_vergisi_primi_7103 + gelir_vergisi_indirimi_7103;
						toplam_indirim_7103 = toplam_indirim_7103 +gelir_vergisi_indirimi_7103;
					}
					if(len(damga_vergisi_indirimi_7103))
					{
						t_damga_vergisi_primi_7103 = t_damga_vergisi_primi_7103 + damga_vergisi_indirimi_7103;
						toplam_indirim_7103 = toplam_indirim_7103 + damga_vergisi_indirimi_7103;
					}
					toplam_indirim_7103 =  toplam_indirim_7103 + ssk_isveren_hissesi_7103 + ssk_isci_hissesi_7103 + issizlik_isveren_hissesi_7103 + issizlik_isci_hissesi_7103 ;
					t_ssk_isci_hissesi_7103 = t_ssk_isci_hissesi_7103 + ssk_isci_hissesi_7103;
					t_issizlik_isci_hissesi_7103 = t_issizlik_isci_hissesi_7103 + issizlik_isci_hissesi_7103;
					t_issizlik_isveren_hissesi_7103 = t_issizlik_isveren_hissesi_7103 + issizlik_isveren_hissesi_7103;
				}
				
				if(len(SSK_ISVEREN_HISSESI_7252))
					t_ssk_isveren_hissesi_7252 = t_ssk_isveren_hissesi_7252 + SSK_ISVEREN_HISSESI_7252;
				if(len(ssk_isci_hissesi_7252))
					t_ssk_isci_hissesi_7252 = t_ssk_isci_hissesi_7252 + ssk_isci_hissesi_7252;
				if(len(issizlik_isci_hissesi_7252))
					t_issizlik_isci_hissesi_7252 = t_issizlik_isci_hissesi_7252 + issizlik_isci_hissesi_7252;
				if(len(issizlik_isci_hissesi_7252))
					t_issizlik_isveren_hissesi_7252 = t_issizlik_isveren_hissesi_7252 + issizlik_isveren_hissesi_7252;
				if(len(SSK_DAYS_7252))
				{
					t_ssk_days_7252 = t_ssk_days_7252 + ssk_days_7252;
					t_toplam_indirim_7252 = t_toplam_indirim_7252  + ssk_isci_hissesi_7252 + issizlik_isveren_hissesi_7252 + issizlik_isci_hissesi_7252 + ssk_isveren_hissesi_7252;
					t_ssk_primi_7252 = t_ssk_primi_7252 + ssk_isveren_hissesi_7252 + ssk_isci_hissesi_7252;
				}

				if(len(SSK_ISVEREN_HISSESI_7256))
				{
					t_ssk_isveren_hissesi_7256 = t_ssk_isveren_hissesi_7256 + SSK_ISVEREN_HISSESI_7256;
					t_toplam_indirim_7256 = t_toplam_indirim_7256 + SSK_ISVEREN_HISSESI_7256;
					t_ssk_primi_7256 = t_ssk_primi_7256 + ssk_isveren_hissesi_7256 + ssk_isci_hissesi_7252;
					if(len(base_amount_7256))
						t_base_amount_7256 = t_base_amount_7256 + base_amount_7256;
				}

				if(len(ssk_isci_hissesi_7256))
				{
					t_ssk_isci_hissesi_7256 = t_ssk_isci_hissesi_7256 + ssk_isci_hissesi_7256;
					t_toplam_indirim_7256 = t_toplam_indirim_7256 + ssk_isci_hissesi_7256;
					t_ssk_primi_7256 = t_ssk_primi_7256 + ssk_isci_hissesi_7256;
				}
				if(len(issizlik_isci_hissesi_7256))
				{
					t_issizlik_isci_hissesi_7256 = t_issizlik_isci_hissesi_7256 + issizlik_isci_hissesi_7256;
					t_toplam_indirim_7256 = t_toplam_indirim_7256 + issizlik_isci_hissesi_7256;
				}
				if(len(issizlik_isveren_hissesi_7256))
				{
					t_issizlik_isveren_hissesi_7256 = t_issizlik_isveren_hissesi_7256 + issizlik_isveren_hissesi_7256;
					t_toplam_indirim_7256 = t_toplam_indirim_7256 + issizlik_isveren_hissesi_7256;
				}
				
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
<cfset get_title_cmp = createObject('component','V16.hr.cfc.add_rapid_emp')>

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

<cfset puantaj_action = createObject("component", "V16.hr.ehesap.cfc.create_puantaj")>
<cfset puantaj_action.dsn = dsn />

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

<cfquery name="get_kesintis_brut" datasource="#dsn#">
    SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE FROM_SALARY = 1 AND EMPLOYEE_PUANTAJ_ID IN (#VALUELIST(GET_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID)#) AND EXT_TYPE IN(1,3) ORDER BY COMMENT_PAY
</cfquery>

<cfif get_personal.recordCount eq 0>
    <cf_box title="Bordro"><cf_get_lang dictionary_id="57484.Kayıt Yok">!</cf_box>
    <cfabort>
<cfelse>
    <cfset title="#Ucase(getLang('','Aylık Bordro İcmal',64919))#">
</cfif>

<cfset page_max_row = 10>
<cfset all_total = 0>
<cfset total_page = (round(get_personal.recordCount/page_max_row) LT 1)?1:round(get_personal.recordCount/page_max_row)>

<cf_box title="#title#" closable="0" uidrop="1"> 
    <div class="printThis">
        <style>
            .printableArea{
                display: block;
                position: relative;
                page-break-after: always;
                width: 208mm;
                height: 295mm;
                margin: 0 auto;
                padding:10mm 5px 5px 5px;
            }    
        
            .printableArea * {
                font-family: Arial,Helvetica Neue,Helvetica,sans-serif; 
                -webkit-box-sizing: border-box;
                -moz-box-sizing: border-box;
                box-sizing: border-box;
                font-size: 12px;
            }
            .printableArea *:before,
            .printableArea *:after {
                -webkit-box-sizing: border-box;
                -moz-box-sizing: border-box;
                box-sizing: border-box;
            }
        
            <!--- SADECE DEVELOPER DA AÇ --->
                /* .printableArea div{border:1px solid red;}
                .printableArea{border: 1px solid #2196F3; } */
            <!--- SADECE DEVELOPER DA AÇ --->   
        
            .bold{font-weight: bold;}
            .underline{text-decoration:underline;}
            .left{text-align:left;}
            .center{text-align:center;}
            .right{text-align:right;}
            .no-border{border:0px;}
        
            table#tablo_ust_baslik {
                width: 100%;
                padding: 10px 200px;
                box-sizing: border-box;
                border-collapse: collapse;
                border: 0px;
            }
        
            table#tablo_ust_baslik th {
                border: 1px solid black;
            }

            table#tablo_alt_baslik {
                width: 100%;
                padding: 10px 200px;
                box-sizing: border-box;
                border-collapse: collapse;
                border: 0px;
                margin-top:3mm;
            }
        
            table#tablo_alt_baslik td {
                border: 1px solid black;
                padding: 3mm;
            }
        
            #bordrologo{
                width: 100px  !important;
                height: 50px  !important;
                display: block;
                margin-left: auto;
                margin-right: auto;
                width: 50%;
                -webkit-filter: grayscale(100%); /* Safari 6.0 - 9.0 */
                filter: grayscale(100%);
            }
            #paper_title{
                text-align: center;
                vertical-align: middle;
                line-height: 90px;
                font-size: 16pt;
            }
        
            table#tablo_ust_ekbilgi {
                min-width: 110mm;
                margin: 2mm 0mm;
            }

            table.tablo_ic {
                width: 100%;
                border-collapse: collapse;
            }
        
            table.tablo_ic td {
                border: 1px solid black;
                width: 50%;
            }

            table.tablo_ic{
                width: 90%;
            }
        
            table.table_orta{
                width: 100%;
                box-sizing: border-box;
                margin-top:3mm;
            }

            table.tablo_toplam_alan{
                border:1px solid black;
                border-collapse: collapse;
                margin-top:3mm;
                width:100%;
            }

            @media print      {
                .printableArea{
                    page-break-after:always;
                }
            }
        
        </style>
        <cfloop index="i" from="1" to="#total_page#">
            <cfset page_total = 0>
            <div class="printableArea" id="printBordro">
                <div id="logo">
                    <img src="https://ms.hmb.gov.tr/uploads/2018/12/logo.png" id="bordrologo"/>
                </div>
                <div id = "paper_title">
                    <cfoutput>#title#</cfoutput>
                </div>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <cfoutput>
                        <table style="width:100%">
                            <tr>
                                <th><cf_get_lang dictionary_id='64935.Muhasebe Birim Kodu'> - <cf_get_lang dictionary_id='57897.Adı'>: #get_personal.BRANCH_POSTCODE# - #get_personal.related_company#</th>
                                <th><cf_get_lang dictionary_id='58455.Yıl'> : <cfoutput>#attributes.sal_year#</cfoutput></th>
                            </tr>
                            <tr>
                                <th><cf_get_lang dictionary_id='51485.Kurum Kodu'> - <cf_get_lang dictionary_id='57897.Adı'>: #get_personal.BRANCH_ID# - #get_personal.related_company#</th>
                                <th><cf_get_lang dictionary_id='58724.Ay'> : <cfoutput>#attributes.sal_mon#</cfoutput></th>
                            </tr>
                            <tr>
                                <th><cf_get_lang dictionary_id='64936.VKN No'> / <cf_get_lang dictionary_id='64937.VKN Adı'> :#GET_PUANTAJ_PERSONAL.BRANCH_TAX_NO# / #GET_PUANTAJ_PERSONAL.branch_fullname#</th>
                                <th><cf_get_lang dictionary_id='64941.Maaş Belge No'> :?</th>
                            </tr>
                            <tr>
                                <th></th>
                                <th><cf_get_lang dictionary_id='64953.Talimat Onay No (Ödeme Kaydı No)'> :?</th>
                            </tr>
                            <tr>
                                <th class="pull-left"><b><cf_get_lang no="824.Kişi Sayısı">  :</b>#get_personal.recordcount#</th>
                                <th></th>
                            </tr>
                            <tr>
                                <th class="pull-left"><b><cf_get_lang dictionary_id='30925.Onay Durumu'> :</b>
                                    <cfif len(get_apply_status.apply_date)>
                                        <cf_get_lang dictionary_id='57616.Onaylı'> <cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>
                                    <cfelse>
                                        <span><cf_get_lang dictionary_id='32658.Onaysız'></span>
                                    </cfif>
                                </th>
                                <th></th>
                            </tr>
                        </table>
                    </cfoutput>
                    <table id="tablo_ust_baslik">
                        <tr style="border:1px solid #000;">
                            <td width="50%">
                                <cfoutput>
                                    <table class="tablo_ic">
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='63662.Aylık Tutar'>
                                            </td>
                                            <td style="text-align:right">#tlformat(t_salary)#</td>
                                        </tr>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='63277.Taban Aylığı'>
                                            </td>
                                            <td style="text-align:right">#tlformat(t_base_salary)#</td>
                                        </tr>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='63284.Toplu Sözleşme İkramiyesi'>
                                            </td>
                                            <td style="text-align:right">#tlformat(t_collective_agreement_bonus)#</td>
                                        </tr>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='63980.Esas Ek Gösterge Tutarı'>
                                            </td>
                                            <td style="text-align:right">#tlformat(t_additional_indicators)#</td>
                                        </tr>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='63278.Kıdem Aylığı'>
                                            </td>
                                            <td style="text-align:right">#tlformat(t_severance_pension)#</td>
                                        </tr>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='63275.Yan Ödeme'>
                                            </td>
                                            <td style="text-align:right">#tlformat(get_personal.business_risk)#</td>
                                        </tr>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='65092.Aile Yardım Tutarı'>
                                            </td>
                                            <td style="text-align:right">#tlformat(t_family_assistance)#</td>
                                        </tr>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='46080.Çocuk Yardımı'>
                                            </td>
                                            <td style="text-align:right">#tlformat(t_child_assistance)#</td>
                                        </tr>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='63274.Özel Hizmet Tazminatı'>
                                            </td>
                                            <td style="text-align:right">#tlformat(t_private_service_compensation)#</td>
                                        </tr>
                                            <!--- lojman tazminatı yok --->
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='63280.Makam Tazminatı'>
                                            </td>
                                            <td style="text-align:right">#tlformat(t_executive_indicator_compensation)#</td>
                                        </tr>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='62883.Dil Tazminatı'>
                                            </td>
                                            <td style="text-align:right">#tlformat(t_language_allowance)#</td>
                                        </tr>
                                        <cfif t_retirement_allowance gt 0>
                                            <tr>
                                                <td width="300px">
                                                    <cf_get_lang dictionary_id='63273.Emekli Keseneği'> <cf_get_lang dictionary_id='44806.Devlet'>
                                                </td>
                                                <td style="text-align:right">#tlformat(t_retirement_allowance)#</td>
                                            </tr>
                                        </cfif>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='57554.Giriş'><cf_get_lang dictionary_id='44806.Devlet'>
                                            </td>
                                            <td style="text-align:right">0</td>
                                        </tr>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='48315.Artış'><cf_get_lang dictionary_id='58583.Fark'> 100
                                            </td>
                                            <td style="text-align:right">
                                                <cfif get_personal.SSK_STATUTE eq 33> <!--- eğer çalışan 5434 sayılı kanuna tabi ise --->
                                                    #get_personal.INDICATOR_SCORE#
                                                <cfelse>
                                                    0
                                                </cfif>
                                            </td>
                                        </tr>
                                        <cfif t_retirement_allowance_5510 gt 0>
                                            <tr><!--- Emekli Keseneği/Malul Yaşlı (Devlet) (5510) --->
                                                <td width="300px">
                                                    <cf_get_lang dictionary_id='63844.Malul Yaşlı'><cf_get_lang dictionary_id='57989.ve'><cf_get_lang dictionary_id='40507.Ölüm'>
                                                </td>
                                                <td style="text-align:right">#tlformat(t_retirement_allowance_5510)#</td>
                                            </tr>
                                        </cfif>
                                        <cfif t_health_insurance_premium_5510 gt 0>
                                            <tr>
                                                <td width="300px">
                                                    <cf_get_lang dictionary_id='63279.Sağlık Sigortası Primi'>(<cf_get_lang dictionary_id='44806.Devlet'>)
                                                </td>
                                                <td style="text-align:right">#tlformat(t_health_insurance_premium_5510)#</td>
                                            </tr>
                                        </cfif>
                                    </table>
                                </cfoutput>
                            </td>
                            <td width="50%" style="vertical-align:top;">
                                <cfoutput>
                                    <table class="tablo_ic pull-right">
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='40452.Gelir vergisi'>
                                            </td>
                                            <td style="text-align:right">#TLFormat(t_gelir_vergisi)#</td>
                                        </tr>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='53249.Gelir Vergisi Matrahı'>
                                            </td>
                                            <td style="text-align:right">#tlformat(t_gelir_vergisi_matrahi)#</td>
                                        </tr>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='41439.Damga Vergisi'>
                                            </td>
                                            <td style="text-align:right">#TLFormat(t_damga_vergisi-t_damga_vergisi_primi_687-t_damga_vergisi_primi_7103)#</td>
                                        </tr>
                                        <cfif t_retirement_allowance gt 0>
                                            <tr>
                                                <td width="300px">
                                                    <cf_get_lang dictionary_id='63273.Emekli Keseneği'> <cf_get_lang dictionary_id='44806.Devlet'>
                                                </td>
                                                <td style="text-align:right">#tlformat(t_retirement_allowance)#</td>
                                            </tr>
                                        </cfif>
                                        <cfif t_retirement_allowance_personal gt 0>
                                            <tr>
                                                <td width="300px">
                                                    <cf_get_lang dictionary_id='63273.Emekli Keseneği'> <cf_get_lang dictionary_id='29831.Kişi'>
                                                </td>
                                                <td style="text-align:right">#tlformat(t_retirement_allowance_personal)#</td>
                                            </tr>
                                        </cfif>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='29831.Kişi'> <cf_get_lang dictionary_id='44806.Devlet'> %25
                                            </td>
                                            <td style="text-align:right">0</td>
                                        </tr>
                                        <cfif t_plus_retired gt 0>
                                            <tr>
                                                <td width="300px">
                                                    <cf_get_lang dictionary_id='29831.Kişi'> <cf_get_lang dictionary_id='44806.Devlet'> %100
                                                </td>
                                                <td style="text-align:right">#TLFormat(t_plus_retired_person)#</td>
                                            </tr>
                                        </cfif>
                                        <cfif t_retirement_allowance_5510 gt 0>
                                            <tr><!--- Emekli Keseneği/Malul Yaşlı (Devlet) (5510) --->
                                                <td width="300px">
                                                    <cf_get_lang dictionary_id='63844.Malul Yaşlı'><cf_get_lang dictionary_id='57989.ve'><cf_get_lang dictionary_id='40507.Ölüm'>
                                                </td>
                                                <td style="text-align:right">#tlformat(t_retirement_allowance_5510)#</td>
                                            </tr>
                                        </cfif>
                                        <cfif t_retirement_allowance_personal_5510 gt 0>
                                            <tr><!--- Emekli Keseneği/Malul Yaşlı (Kişi) (5510) --->
                                                <td width="300px">
                                                    <cf_get_lang dictionary_id='63844.Malul Yaşlı'><cf_get_lang dictionary_id='57989.ve'><cf_get_lang dictionary_id='40507.Ölüm'>(<cf_get_lang dictionary_id='29831.Kişi'>)
                                                </td>
                                                <td style="text-align:right">#tlformat(t_retirement_allowance_personal_5510)#</td>
                                            </tr>
                                        </cfif>
                                        <cfif t_health_insurance_premium_5510 gt 0>
                                            <tr>
                                                <td width="300px">
                                                    <cf_get_lang dictionary_id='63279.Sağlık Sigortası Primi'>(<cf_get_lang dictionary_id='44806.Devlet'>)
                                                </td>
                                                <td style="text-align:right">#tlformat(t_health_insurance_premium_5510)#</td>
                                            </tr>
                                        </cfif>
                                        <cfif t_health_insurance_premium_personal_5510 gt 0>
                                            <tr>
                                                <td width="300px">
                                                    <cf_get_lang dictionary_id='63279.Sağlık Sigortası Primi'>(<cf_get_lang dictionary_id='29831.Kişi'>) 5510
                                                </td>
                                                <td style="text-align:right">#TLFormat(t_health_insurance_premium_personal_5510)#</td>
                                            </tr>
                                        </cfif>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='53659.Asgari Geçim İndirimi'>
                                            </td>
                                            <td style="text-align:right">#TLFormat(t_vergi_iadesi)#</td>
                                        </tr>
                                    </table>
                                </cfoutput>
                            </td>
                        </tr>
                        <tr>
                            <td width="50%" style="vertical-align:top;">
                                <cfoutput>
                                    <table class="tablo_ic" style="margin-top:3mm;">
                                        <tr>
                                            <td colspan="2" class="center"><cfoutput>#uCase(getLang('','Tazminatlar',65184))#</cfoutput></td>
                                        </tr>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='63281.İdari Görev Tazminatı'>
                                            </td>
                                            <td style="text-align:right">#TLFormat(t_administrative_duty_allowance)#</td>
                                        </tr>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='62884.Üniversite Ödeneği'>
                                            </td>
                                            <td style="text-align:right">#TLFormat(t_university_allowance)#</td>
                                        </tr>
                                        <cfif t_education_allowance gt 0>
                                            <tr>
                                                <td width="300px">
                                                    <cf_get_lang dictionary_id='63282.Eğitim Öğretim Ödeneği'>
                                                </td>
                                                <td style="text-align:right">#TLFormat(t_education_allowance)#</td>
                                            </tr>
                                        </cfif>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='62937.Yüksek Öğretim Tazminatı'>
                                            </td>
                                            <td style="text-align:right">#tlformat(t_high_education_compensation)#</td>
                                        </tr>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='63949.Ek Ödeme (666 KHK)'>
                                            </td>
                                            <td style="text-align:right">
                                                #tlformat(t_additional_indicator_compensation)#
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='63283.Görev Tazminatı'>
                                            </td>
                                            <td style="text-align:right">#tlformat(t_administrative_compensation)#</td>
                                        </tr>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='62936.Akademik Teşvik Ödeneği'>
                                            </td>
                                            <td style="text-align:right">#tlformat(t_academic_incentive_allowance_amount)#</td>
                                        </tr>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='57492.Toplam'>
                                            </td>
                                            <cfscript>
                                                t_tazminatlar = t_administrative_duty_allowance+t_university_allowance+t_education_allowance+t_high_education_compensation+t_additional_indicator_compensation+t_administrative_compensation+t_academic_incentive_allowance_amount;
                                            </cfscript>
                                            <td style="text-align:right">#tlformat(t_tazminatlar)#</td>
                                        </tr>
                                    </table>
                                </cfoutput>
                            </td>
                            
                            <td width="50%" style="vertical-align:top;">
                                <cfoutput>
                                    <table class="tablo_ic pull-right" style="margin-top:3mm;">
                                        <tr>
                                            <td colspan="2" class="center"><cfoutput>#uCase(getLang('','Kesintiler',38977))#</cfoutput></td>
                                        </tr>
                                        <tr>
                                            <td width="300px">
                                                <cf_get_lang dictionary_id='63080.Bireysel Emeklilik'>
                                            </td>
                                            <td style="text-align:right">#tlformat(t_bes_primi_isci)#</td>
                                        </tr>
                                        <cfset t_istisna_odenek = 0>
                                        <cfset t_istisna_odenek_net = 0>
                                        <cfloop query="get_vergi_istisnas" group="COMMENT_PAY">
                                            <cfset tmp_total = 0>
                                            <cfset tmp_total2 = 0>
                                            <cfoutput><!--- 20040824 ellemeyin yanlis kullanim degil --->
                                                <cfif len(VERGI_ISTISNA_AMOUNT)>
                                                    <cfset tmp_total = tmp_total + VERGI_ISTISNA_AMOUNT>
                                                    <cfset t_istisna_odenek = t_istisna_odenek + VERGI_ISTISNA_AMOUNT>
                                                </cfif>
                                                <cfif len(VERGI_ISTISNA_TOTAL)>
                                                    <cfset tmp_total2 = tmp_total2 + VERGI_ISTISNA_TOTAL>
                                                    <cfset t_istisna_odenek_net = t_istisna_odenek_net + VERGI_ISTISNA_TOTAL>
                                                </cfif>
                                            </cfoutput>
                                            <cfif tmp_total gt 0>
                                                <tr>
                                                    <td width="300px">#comment_pay#</td>
                                                    <td style="text-align:right">#TLFormat(tmp_total)#
                                                    <cfif is_view_net eq 1>
                                                        (#TLFormat(tmp_total2)#)
                                                    </cfif>
                                                    </td>
                                                </tr>
                                            </cfif>
                                        </cfloop>
                                        <cfset genel_odenek_total = t_istisna_odenek>
                                        <cfset genel_odenek_total_net = t_istisna_odenek_net>
                                        <cfset odenek_say = 0>
                                        <cfquery name="get_odeneks_" dbtype="query">
                                            SELECT * FROM get_odeneks WHERE COMMENT_TYPE <> 2
                                        </cfquery>
                                        <cfloop query="get_odeneks_" group="COMMENT_PAY">
                                            <cfquery name="get_odenek_say" dbtype="query">
                                                SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_odeneks_ WHERE COMMENT_PAY = '#comment_pay#'
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
                                            <tr>
                                                <td width="300px">#comment_pay# <cfif icmal_type is 'genel'>(#odenek_say#)</cfif></td>
                                                <td style="text-align:right">#TLFormat(tmp_total)#</td>
                                            </tr>
                                            <cfif isDefined(is_income) and not (len(is_income) and is_income eq 1)>
                                                <cfset genel_odenek_total = genel_odenek_total + tmp_total>
                                                <cfset genel_odenek_total_net = genel_odenek_total_net + amount_pay_total>
                                            </cfif>
                                        </cfloop>
                                        <cfif t_penance_deduction gt 0>
                                            <tr>
                                                <td width="300px">
                                                    <cf_get_lang dictionary_id='64057.Kefaret Kesintisi'>
                                                </td>
                                                <td style="text-align:right">#TLFormat(t_penance_deduction)#</td>
                                            </tr>
                                        </cfif>
                                        <cfset t_istisna_kesinti = 0>
                                        <cfloop query="get_vergi_istisnas" group="COMMENT_PAY">
                                            <cfset tmp_total = 0>
                                            <cfoutput>
                                                <cfif len(VERGI_ISTISNA_TOTAL)>
                                                    <cfset tmp_total = tmp_total + VERGI_ISTISNA_TOTAL>
                                                    <cfset t_istisna_kesinti = t_istisna_kesinti + VERGI_ISTISNA_TOTAL>
                                                </cfif>
                                            </cfoutput>
                                            <cfif tmp_total gt 0>
                                                <tr>
                                                    <td width="300px">#comment_pay#</td>
                                                    <td style="text-align:right">#TLFormat(tmp_total)#</td>
                                                </tr>
                                            </cfif>
                                        </cfloop>
                                        <cfset say_kesinti_kisi = 0>
                                        <cfloop query="get_kesintis" group="COMMENT_PAY">
                                            <cfquery name="get_kesinti_say" dbtype="query">
                                                SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_kesintis WHERE COMMENT_PAY = '#comment_pay#'
                                            </cfquery>
                                            <cfif get_kesinti_say.recordcount><cfset say_kesinti_kisi = get_kesinti_say.recordcount></cfif>
                                            <cfset tmp_total = 0>
                                            <cfoutput>
                                                <cfif ext_type eq 1>
                                                    <cfif listfindnocase('2,3,4,5',PAY_METHOD)>
                                                        <cfset tmp_total = tmp_total + amount_2>
                                                    <cfelse>
                                                        <cfset tmp_total = tmp_total + amount>
                                                    </cfif>
                                                <cfelse> <!--- calisan icra kesintisinden geliyorsa--->
                                                    <cfif listfindnocase('1',PAY_METHOD)>
                                                        <cfset tmp_total = tmp_total + amount_2>
                                                    <cfelse>
                                                        <cfset tmp_total = tmp_total + amount>
                                                    </cfif>
                                                </cfif>
                                            </cfoutput>	
                                            <tr>	
                                                <td width="300px">#comment_pay# <cfif icmal_type is 'genel'>(#say_kesinti_kisi#)</cfif></td>
                                                <td style="text-align:right"><cfif comment_pay is 'Avans' and t_avans gt 0>#TLFormat(tmp_total + t_avans)#<cfset is_avans_ = 1><cfelse>#TLFormat(tmp_total)#</cfif></td>
                                            </tr>
                                            <cfif t_avans gt 0 and not isdefined("is_avans_")>
                                                <tr>
                                                    <td width="300px"><cf_get_lang_main no="792.Avans"></td>
                                                    <td style="text-align:right">#TLFormat(t_avans)#</td>
                                                </tr>
                                            </cfif>
                                        </cfloop>
                                        <cfif t_ozel_kesinti_2 gt 0>
                                            <cfset say_kesinti_kisi = 0>
                                            <cfloop query="get_kesintis_brut" group="COMMENT_PAY">
                                                <cfquery name="get_kesinti_say" dbtype="query">
                                                    SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_kesintis_brut WHERE COMMENT_PAY = '#comment_pay#'
                                                </cfquery>
                                                <cfif get_kesinti_say.recordcount><cfset say_kesinti_kisi = get_kesinti_say.recordcount></cfif>
                                                <cfset tmp_total = 0>
                                                <cfoutput>
                                                    <cfif ext_type eq 1>
                                                        <cfif listfindnocase('2,3,4,5',PAY_METHOD)>
                                                            <cfset tmp_total = tmp_total + amount_2>
                                                        <cfelse>
                                                            <cfset tmp_total = tmp_total + amount>
                                                        </cfif>
                                                    <cfelse> <!--- calisan icra kesintisinden geliyorsa--->
                                                        <cfif listfindnocase('1',PAY_METHOD)>
                                                            <cfset tmp_total = tmp_total + amount_2>
                                                        <cfelse>
                                                            <cfset tmp_total = tmp_total + amount>
                                                        </cfif>
                                                    </cfif>
                                                </cfoutput>	
                                                <tr>	
                                                    <td width="300px">#comment_pay# <cfif icmal_type is 'genel'>(#say_kesinti_kisi#)</cfif></td>
                                                    <td style="text-align:right"><cfif comment_pay is 'Avans' and t_avans gt 0>#TLFormat(tmp_total + t_avans)#<cfset is_avans_ = 1><cfelse>#TLFormat(tmp_total)#</cfif></td>
                                                </tr>												
                                            </cfloop>
                                        </cfif>	
                                        <cfloop query="get_vergi_istisnas" group="COMMENT_PAY">
                                            <cfset tmp_total = 0>
                                            <cfoutput>
                                            <cfif PAY_METHOD eq 2>
                                                <cfset tmp_total = tmp_total + amount_2>
                                                <cfset t_istisna = t_istisna + amount_2>
                                            <cfelse>
                                                <cfset tmp_total = tmp_total + amount>
                                                <cfset t_istisna = t_istisna + amount>
                                            </cfif>
                                            </cfoutput>
                                            <tr>
                                                <td width="300px">#comment_pay#</td>
                                                <td style="text-align:right">#TLFormat(tmp_total)#</td>
                                            </tr>
                                        </cfloop>
                                    </table>
                                </cfoutput>
                            </td>
                        </tr>
                    </table>
                    <cfoutput>
                        <table class="tablo_toplam_alan">
                            <tr>
                                <td class="pull-right right" style="margin-top:10px"><cf_get_lang dictionary_id='58677.Gelir'><cf_get_lang dictionary_id='58659.Toplamı'></td>
                                <td class="right"><p style="border:1px solid black;margin: 10px 10px 0 0;padding-left:60px;">#TLFormat(t_toplam_kazanc)#</p></td>
                                <td class="pull-right right" style="margin-top:10px"><cf_get_lang dictionary_id='32191.Kesinti'><cf_get_lang dictionary_id='58659.Toplamı'></td>
                                <td class="right"><p style="border:1px solid black;margin: 10px 10px 0 0;padding-left:60px;">#TLFormat(t_toplam_kazanc - t_net_ucret)#</p></td>
                                <td class="pull-right right"><cf_get_lang dictionary_id='40400.Net Ödeme'></td>
                                <td class="right"><p style="border:1px solid black;margin: 10px 10px 0 0;padding-left:60px;">#TLFormat(t_net_ucret)#</p></td>
                            </tr>
                            <tr>
                                <td class="pull-right right" style="margin-top:10px"><cf_get_lang dictionary_id='31444.Bordro'><cf_get_lang dictionary_id='44867.Numarası'></td>
                                <td class="right"><p style="border:1px solid black;margin: 10px 10px 10px 0;padding-left:60px;"><cfoutput>#attributes.sal_mon##attributes.sal_year#</cfoutput></p></td>
                            </tr>
                        </table>
                    </cfoutput>
                    <div class="bold" style="padding:10px;">
                        <cf_get_lang dictionary_id='64998.Bordro Kayıtlarına Uygundur, Kontrol Edilmiştir.'>
                    </div>
                    <cfoutput>
                        <table id="tablo_alt_baslik">
                            <tr>
                                <td class="no-border">&nbsp;</td>
                                <td><cf_get_lang dictionary_id='64961.Gerçekleştirme Görevlisi'> (<cf_get_lang dictionary_id='64962.Maaş Mutemedi'>)</td>
                                <td><cf_get_lang dictionary_id='64961.Gerçekleştirme Görevlisi'></td>
                                <td><cf_get_lang dictionary_id='62976.Harcama Yetkilisi'></td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id='32370.Adı Soyadı'></td>
                                <td><cfif len(GET_PUANTAJ_PERSONAL.SALARY_SYNDIC_POS_ID)>#get_emp_info(GET_PUANTAJ_PERSONAL.SALARY_SYNDIC_POS_ID,1,0)#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                                <td><cfif len(GET_PUANTAJ_PERSONAL.FULFILLMENT_OFFICER_POS_ID)>#get_emp_info(GET_PUANTAJ_PERSONAL.FULFILLMENT_OFFICER_POS_ID,1,0)#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                                <td><cfif len(GET_PUANTAJ_PERSONAL.EXPENSE_USER_POS_ID)>#get_emp_info(GET_PUANTAJ_PERSONAL.EXPENSE_USER_POS_ID,1,0)#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id='57571.Ünvan'></td>
                                <td><cfif len(GET_PUANTAJ_PERSONAL.SALARY_SYNDIC_POS_ID)>#get_title_cmp.get_titles(TITLE_ID: GET_PUANTAJ_PERSONAL.SALARY_SYNDIC_POS_ID).TITLE#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                                <td><cfif len(GET_PUANTAJ_PERSONAL.FULFILLMENT_OFFICER_POS_ID)>#get_title_cmp.get_titles(TITLE_ID: GET_PUANTAJ_PERSONAL.FULFILLMENT_OFFICER_POS_ID).TITLE#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                                <td><cfif len(GET_PUANTAJ_PERSONAL.EXPENSE_USER_POS_ID)>#get_title_cmp.get_titles(TITLE_ID: GET_PUANTAJ_PERSONAL.EXPENSE_USER_POS_ID).TITLE#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id='64960.Sistem Onay Tarih / Saati'></td>
                                <td>#dateFormat(now(),dateformat_style)# #timeFormat(now(),timeformat_style)#</td>
                                <td>#dateFormat(now(),dateformat_style)# #timeFormat(now(),timeformat_style)#</td>
                                <td>#dateFormat(now(),dateformat_style)# #timeFormat(now(),timeformat_style)#</td>
                            </tr>
                        </table>
                    </cfoutput>
                </div>
                <div style="position: absolute;bottom: 8mm;right: 8mm;"><cfoutput>#i#/#total_page#</cfoutput></div>
            </div>
        </cfloop>
    </div>
</cf_box>
<cfif icmal_type is 'personal' and listFirst(attributes.fuseaction,".") is 'myhome'>
    <div class="col col-2">
        <ul class="ui-list padding-top-20">
            <li class="bold mb-0">
                <cf_get_lang dictionary_id ='31779.Puantaj Hazırlandı'>
            </li>
            <li class="bold mb-0">
                <cf_get_lang dictionary_id ='31780.Bordro Okundu'><cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>
            </li>	
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