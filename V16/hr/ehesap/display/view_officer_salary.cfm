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
	
	t_income_tax_temp = 0;
	t_damga_vergisi = 0;
	t_stamp_tax_temp = 0;

	t_daily_minimum_wage_base_cumulate = 0;
	t_minimum_wage_cumulative  = 0;
	t_daily_minimum_income_tax = 0;
	t_daily_minimum_wage_stamp_tax = 0;
	t_daily_minimum_wage = 0;
	
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
	
	t_business_risk = 0;
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

<cfif not isdefined("temp_query_1")>
	<cfset temp_query_1 = get_puantaj_rows>
</cfif>
<cfquery name="get_personal" dbtype="query">
	SELECT * FROM temp_query_1 WHERE STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.STATUE_TYPE#">
</cfquery>
<cfoutput query="get_personal">
	<cfset attributes.employee_id = get_personal.employee_id>
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

		t_additional_indicators = t_additional_indicators + additional_indicators; //ek gösterge puanı
		t_university_allowance = t_university_allowance + university_allowance;//üniversite ödeneği
		t_private_service_compensation = t_private_service_compensation + private_service_compensation;//Özel hizmet tazminatı
		t_family_assistance = t_family_assistance +family_assistance;//Eş YArdımı
		t_child_assistance = t_child_assistance + child_assistance;//Çocuk yardımı;
		t_severance_pension = t_severance_pension + severance_pension;//Kıdem aylığı
		t_language_allowance = language_allowance + t_language_allowance;//Dil tazminatı
		if(len(academic_incentive_allowance_amount))
			t_academic_incentive_allowance_amount = t_academic_incentive_allowance_amount + academic_incentive_allowance_amount;//Akademik teşvik ödeneği
		t_executive_indicator_compensation = t_executive_indicator_compensation + executive_indicator_compensation;//Makam tazminatı
		t_administrative_duty_allowance = t_administrative_duty_allowance + administrative_duty_allowance;//idari görev tazminatı
		t_education_allowance = t_education_allowance + education_allowance;//eğitim öğretim ödeneği
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
		
		if(len(income_tax_temp))
			t_income_tax_temp = t_income_tax_temp + income_tax_temp;
			
		if(len(stamp_tax_temp))
			t_stamp_tax_temp = t_stamp_tax_temp + stamp_tax_temp;

		if(len(daily_minimum_wage_base_cumulate))
			t_daily_minimum_wage_base_cumulate = t_daily_minimum_wage_base_cumulate + daily_minimum_wage_base_cumulate;
		if(len(minimum_wage_cumulative ))
			t_minimum_wage_cumulative  = t_minimum_wage_cumulative  + minimum_wage_cumulative ;
		if(len(daily_minimum_income_tax))
			t_daily_minimum_income_tax = t_daily_minimum_income_tax + daily_minimum_income_tax;
		if(len(daily_minimum_wage_stamp_tax))
			t_daily_minimum_wage_stamp_tax = t_daily_minimum_wage_stamp_tax + daily_minimum_wage_stamp_tax;
		if(len(daily_minimum_wage))
			t_daily_minimum_wage = t_daily_minimum_wage + daily_minimum_wage;

		
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
		if(ssk_statute eq 2 or ssk_statute eq 18) //Yeraltı Emekli
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

		t_business_risk = t_business_risk + business_risk;
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

<cfset puantaj_action = createObject("component", "V16.hr.ehesap.cfc.create_puantaj")>
<cfset puantaj_action.dsn = dsn />
<cfset get_relatives = puantaj_action.get_relatives(attributes.EMPLOYEE_ID,attributes.sal_mon,attributes.sal_year)/>
<!--- Eş Durumu (Eşi Çalışmıyorsa) --->
<cfquery name="get_emp_family" dbtype="query">
	SELECT * FROM get_relatives WHERE RELATIVE_LEVEL = '3'
</cfquery>

<!--- Çocuk Sayısı --->
<cfquery name="get_emp_child" dbtype="query">
	SELECT * FROM get_relatives WHERE  (RELATIVE_LEVEL = '5' OR RELATIVE_LEVEL = '4') AND WORK_STATUS = 0
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
									<cf_get_lang no="823.Adı Soyadı"> : #employee_name# #employee_surname#<br/>
									<cf_get_lang dictionary_id='63668.Personel No'> : #EMPLOYEE_NO#
									<cfset attributes.branch_id = GET_PUANTAJ_PERSONAL.branch_id></br>
									<cfif x_get_sgkno eq 1><cf_get_lang no="291.SGK No"> : #GET_PUANTAJ_PERSONAL.SOCIALSECURITY_NO#<br/></cfif>
									<cf_get_lang no='1319.TC No'> : #GET_PUANTAJ_PERSONAL.tc_identy_no#<br>
									<cf_get_lang dictionary_id='32329.Kurum Sicil No'> : #GET_PUANTAJ_PERSONAL.REGISTRY_NO#<br>
									<cf_get_lang dictionary_id='63673.Emekli Sicil No'> : #GET_PUANTAJ_PERSONAL.RETIRED_REGISTRY_NO#<br>
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
										<b><cf_get_lang_main no="1126.Görev Tipi"> : </b> #duty_type_name#
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
									<b><cf_get_lang no="824.Kişi Sayısı">  :</b>#kisi_say#
								<cfelse>
									<cfif isdefined("attributes.currentrow")>
										<cf_get_lang dictionary_id='31253.Sıra No'>:#attributes.currentrow#
									</cfif>
									<cfif x_get_groupdate eq 1>&nbsp;<cf_get_lang no='758.Gruba Giriş'> : #dateformat(GROUP_STARTDATE,dateformat_style)#</cfif><br/>
									<cfif x_get_kidemdate eq 1><cf_get_lang no='695.Kıdem Baz Tarihi'> : #dateformat(KIDEM_DATE,dateformat_style)#</cfif><br/>
									<cfif x_get_kidemdate eq 1><cf_get_lang dictionary_id='56292.Kıdem Yıl'> : #dateDiff('yyyy',KIDEM_DATE,now())#</cfif><br/>
									<cf_get_lang no="756.İşe Giriş"> : #dateformat(GET_PUANTAJ_PERSONAL.START_DATE,dateformat_style)#
									<cfif len(GET_PUANTAJ_PERSONAL.FINISH_DATE) and (month(FINISH_DATE) eq attributes.sal_mon and year(FINISH_DATE) eq attributes.sal_year)>- <cf_get_lang_main no="19.Çıkış"> : #dateformat(GET_PUANTAJ_PERSONAL.FINISH_DATE,dateformat_style)#</cfif></br>
									<cf_get_lang dictionary_id='46602.Medeni Hali'> : <cfif get_emp_family.recordcount gt 0><cf_get_lang dictionary_id='44602.Evli'><cfelse><cf_get_lang dictionary_id='44603.Bekar'></cfif><br>
									<cf_get_lang dictionary_id='46572.Çocuk Sayısı'> : #get_emp_child.recordcount#<br>
									<cf_get_lang dictionary_id='63979.Emekliye Esas'> <cf_get_lang dictionary_id='62877.Ek Gösterge Puanı'> : #tlformat(t_additional_score)#<br>
									<cf_get_lang dictionary_id='63980.Esas Ek Gösterge Tutarı'> : #tlformat(t_normal_additional_score)#<br>
									<cf_get_lang dictionary_id='63272.Gösterge Tutarı'> : #tlformat(indicator_score)#
								</cfif>
							</td>
						</tr>
					</cfoutput>
				</cf_grid_list>
			</div>
		</div>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
				<cf_grid_list align="center">  
					<cfoutput>
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='63979.Emekliye Esas'> <cf_get_lang dictionary_id='37566.Derece / Kademe'>
							</td>
							<td style="text-align:center">#GET_PUANTAJ_PERSONAL.GRADE# / #GET_PUANTAJ_PERSONAL.step#</td>
						</tr>
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='37566.Derece / Kademe'>
							</td>
							<td style="text-align:center">#GET_PUANTAJ_PERSONAL.NORMAL_GRADE# / #GET_PUANTAJ_PERSONAL.normal_step#</td>
						</tr>
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='64051.Geçen Aylar Vergi Matrahı Toplam'>
							</td>
							<td style="text-align:right">#TLFormat(t_kum_gelir_vergisi_matrahi)#<!--- #TLFormat(t_kum_gelir_vergisi_matrahi+t_gelir_vergisi_matrahi)# ---></td>
						</tr> 
					</cfoutput>
				</cf_grid_list>
			</div>
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
				<cf_grid_list align="center">  
					<cfoutput>
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='63270.Raporlu Gün Sayısı'>
							</td>
							<td width="300px">#t_izin#</td>
						</tr>
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='53249.Gelir Vergisi Matrahı'>
							</td>
							<td style="text-align:right">#tlformat(t_gelir_vergisi_matrahi)#</td>
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
								<cf_get_lang dictionary_id='63271.Sözleşme Tazminatı'>
							</td>
							<td style="text-align:right">?</td>
						</tr>
						<tr>
							<td width="300px">&nbsp;
							</td>
							<td style="text-align:right"></td>
						</tr>
						<tr>
							<td width="300px">&nbsp;
							</td>
							<td style="text-align:right"></td>
						</tr>
					</cfoutput>
				</cf_grid_list>         
			</div>
		</div>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
				<cf_grid_list align="center">  
					<cfset t_istisna = 0>
					<!--- Toplam vergi indirimi --->
					<cfoutput query="get_vergi_istisnas" group="COMMENT_PAY">
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
					</cfoutput>
					<cfoutput>
						<cfif temp_query_1.statue_type eq 8>
							<cfset get_salary = createObject("component", "V16.hr.ehesap.cfc.payroll_job")>
							<cfset get_salary_info = get_salary.get_salary_history(start_month: bu_ay_basi,in_out_id : temp_query_1.in_out_id)>
							<td width="300px">
								<cf_get_lang dictionary_id='52994.Monthly Salary'>
							</td>
							<td style="text-align:right">#tlformat(evaluate("get_salary_info.M#month(bu_ay_basi)#"))#</td>
						</cfif>
						<cfif t_retired_academic gt 0 or temp_query_1.statue_type eq 8 >
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='64629.Brüt Maaş'>
								</td>
								<td style="text-align:right">
									<cfif t_retired_academic gt 0 >
										#tlformat(t_retired_academic)#
									<cfelse>
										#tlformat(temp_query_1.TOTAL_AMOUNT)#
									</cfif>
								</td>
							</tr>
						</cfif>
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='63662.Aylık Tutar'>
							</td>
							<td style="text-align:right">#tlformat(t_salary)#</td>
						</tr>
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='32589.Ek'> <cf_get_lang dictionary_id='63272.Gösterge Tutarı'>
							</td>
							<td style="text-align:right">#TLFormat(t_additional_indicators)#</td>
						</tr> 
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='38971.Vergi İndirimi'>
							</td>
							<td style="text-align:right">#TLFormat(t_istisna + t_vergi_matrah_muafiyet)#</td>
						</tr>
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='62884.Üniversite Ödeneği'>
							</td>
							<td style="text-align:right">#TLFormat(t_university_allowance)#</td>
						</tr>
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='63274.Özel Hizmet Tazminatı'>
							</td>
							<td style="text-align:right">#tlformat(t_private_service_compensation)#</td>
						</tr>
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='63275.Yan Ödeme'>
							</td>
							<td style="text-align:right">#tlformat(t_business_risk)#</td>
						</tr>
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='63664.Eş Yardımı'>
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
								<cf_get_lang dictionary_id='63277.Taban Aylığı'>
							</td>
							<td style="text-align:right">#tlformat(t_base_salary)#</td>
						</tr>
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='63278.Kıdem Aylığı'>
							</td>
							<td style="text-align:right">#tlformat(t_severance_pension)#</td>
						</tr>
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='62883.Dil Tazminatı'>
							</td>
							<td style="text-align:right">#tlformat(t_language_allowance)#</td>
						</tr>
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='62936.Akademik Teşvik Ödeneği'>
							</td>
							<td style="text-align:right">#tlformat(t_academic_incentive_allowance_amount)#</td>
						</tr>
					</cfoutput>
				</cf_grid_list>
			</div>
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
				<cf_grid_list align="center">  
					<cfoutput>
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='63280.Makam Tazminatı'>
							</td>
							<td style="text-align:right">#tlformat(t_executive_indicator_compensation)#</td>
						</tr>
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='63281.İdari Görev Tazminatı'>
							</td>
							<td style="text-align:right">#TLFormat(t_administrative_duty_allowance)#</td>
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
								<cf_get_lang dictionary_id='63283.Görev Tazminatı'>
							</td>
							<td style="text-align:right">#tlformat(t_administrative_compensation)#</td>
						</tr>
					</cfoutput>
					<!------ All ---->
					<cfset t_istisna_odenek = 0>
					<cfset t_istisna_odenek_net = 0>
					<cfoutput query="get_vergi_istisnas" group="COMMENT_PAY">
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
					</cfoutput>
					<cfset genel_odenek_total = t_istisna_odenek>
					<cfset genel_odenek_total_net = t_istisna_odenek_net>
					<cfset odenek_say = 0>
					<cfquery name="get_odeneks_" dbtype="query">
						SELECT * FROM get_odeneks WHERE COMMENT_TYPE <> 2
					</cfquery>
					<cfoutput query="get_odeneks_" group="COMMENT_PAY">
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
							<!--- <cfif is_view_net eq 1>
								<td style="text-align:right">#TLFormat(amount_pay_total)#</td>
							</cfif> --->
						</tr>
						<cfif not (len(is_income) and is_income eq 1)>
							<cfset genel_odenek_total = genel_odenek_total + tmp_total>
							<cfset genel_odenek_total_net = genel_odenek_total_net + amount_pay_total>
						</cfif>
					</cfoutput>
					<!------ All ---->
					<cfoutput>
						<!--- <tr>
							<td width="300px">
								<cf_get_lang dictionary_id='31283.Ek Ödemeler'>
							</td>
							<td style="text-align:right">
								
								#tlformat(genel_odenek_total)#
							</td>
						</tr> --->
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='63949.Ek Ödeme (666 KHK)'>
							</td>
							<td style="text-align:right">
								#tlformat(t_additional_indicator_compensation)#
							</td>
						</tr>
						<!--- <tr>
							<td width="300px">
								<cf_get_lang dictionary_id='63949.Ek Ödeme (666 KHK)'>
							</td>
							<td style="text-align:right">
								#tlformat(t_extra_pay)#
							</td>
						</tr> --->
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='62937.Yüksek Öğretim Tazminatı'>
							</td>
							<td style="text-align:right">#tlformat(t_high_education_compensation)#</td>
						</tr>
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='64569.Arazi Tazminatı'>
							</td>
							<td style="text-align:right">#tlformat(t_land_compensation_amount)#</td>
						</tr>
						<cfif t_audit_compensation_amount gt 0>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='64065.Denetim Tazminatı'>
								</td>
								<td style="text-align:right">#tlformat(t_audit_compensation_amount)#</td>
							</tr>
						</cfif>
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='63284.Toplu Sözleşme İkramiyesi'>
							</td>
							<td style="text-align:right">#tlformat(t_collective_agreement_bonus)#</td>
						</tr>
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='59344.Otomatik Bes'>
							</td>
							<td style="text-align:right">#tlformat(t_bes_primi_isci)#</td>
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
						<cfif t_general_health_insurance gt 0>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='53191.Genel Sağlık Sigortası'>
								</td>
								<td style="text-align:right">#tlformat(t_general_health_insurance)#</td>
							</tr>
						</cfif>
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='53245.SGK Matrahı'>
							</td>
							<td style="text-align:right">#tlformat(t_sgk_base)#</td>
						</tr>
					</cfoutput>
				</cf_grid_list>
			</div>
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
				<cf_grid_list align="center">  
					<cfoutput>
						<tr>
							<td class="icmal_border_without_top"><cf_get_lang dictionary_id='64700.Asgari Ücrete Göre Gelir Vergi Matrahı'></td>
							<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_daily_minimum_wage_base_cumulate)#</td>
						</tr>
						<tr>
							<td class="icmal_border_without_top"><cf_get_lang no='743.Gelir Vergisi Hesaplanan'></td>
							<td class="icmal_border_without_top" style="text-align:right">
								<cfif attributes.sal_year lte 2021>
									#TLFormat(t_gelir_vergisi + t_vergi_indirimi_5084 + t_vergi_iadesi + t_vergi_indirimi_5746_all + t_vergi_indirimi_4691_all)#
								<cfelseif t_gelir_vergisi-t_gelir_vergisi_primi_687-t_gelir_vergisi_primi_7103 gt 0>
									#TLFormat(t_gelir_vergisi-t_gelir_vergisi_primi_687-t_gelir_vergisi_primi_7103 + t_daily_minimum_income_tax)#
								<cfelseif t_gelir_vergisi eq 0 and t_income_tax_temp gt 0>
									#TLFormat(t_income_tax_temp)#
								<cfelse>
									#TLFormat(0)#
								</cfif>
							</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='64702.Asgari Ücret Gelir Vergisi'></td>
							<td style="text-align:right">#TLFormat(t_daily_minimum_income_tax)#</td>
						</tr>
						<tr>
							<td><cf_get_lang no='304.Gelir Vergisi'></td>
							<td style="text-align:right">#TLFormat(t_gelir_vergisi-t_gelir_vergisi_primi_687-t_gelir_vergisi_primi_7103)#</td>
						</tr>
						<tr>
							<td width="300px"><cf_get_lang dictionary_id='64703.Asgari Ücret Damga Vergisi Matrahı'></td>
							<td style="text-align:right">#TLFormat(t_daily_minimum_wage)#</td>
						</tr>
						<tr>
							<td width="300px"><cf_get_lang dictionary_id='64704.Asgari Ücret Damga Vergisi'></td>
							<td style="text-align:right">#TLFormat(t_daily_minimum_wage_stamp_tax)#</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='30887.İndirimsiz'> <cf_get_lang no='306.Damga Vergisi'></td>
							<td style="text-align:right">
								<cfif attributes.sal_year lte 2021>
									#tlformat(t_damga_vergisi)#
								<cfelseif t_damga_vergisi gt 0>
									#TLFormat(t_damga_vergisi + t_daily_minimum_wage_stamp_tax)#
								<cfelseif t_damga_vergisi eq 0 and t_stamp_tax_temp gt 0>
									#TLFormat(t_stamp_tax_temp)#
								<cfelse>
									#TLFormat(0)#
								</cfif>
							</td>
						</tr>
						<tr>
							<td width="300px"><cf_get_lang dictionary_id='64769.Asgari Ücret Faydalanılan Damga Vergisi'></td>
							<td style="text-align:right">#TLFormat(t_stamp_tax_temp)#</td>
						</tr>						
						<tr>
							<td width="300px">
								<cf_get_lang dictionary_id='41439.Damga Vergisi'>
							</td>
							<td style="text-align:right">#TLFormat(t_damga_vergisi-t_damga_vergisi_primi_687-t_damga_vergisi_primi_7103)#</td>
						</tr> 
						<cfif t_penance_deduction gt 0>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='64057.Kefaret Kesintisi'>
								</td>
								<td style="text-align:right">#TLFormat(t_penance_deduction)#</td>
							</tr> 
						</cfif>
						<cfif t_retirement_allowance_5510 gt 0>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='63273.Emekli Keseneği'> / <cf_get_lang dictionary_id='63844.Malul Yaşlı'>(<cf_get_lang dictionary_id='44806.Devlet'>) 5510
								</td>
								<td style="text-align:right">#TLFormat(t_retirement_allowance_5510)#</td>
							</tr> 
						</cfif>
						<cfif t_retirement_allowance_personal_5510 gt 0>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='63273.Emekli Keseneği'> / <cf_get_lang dictionary_id='63844.Malul Yaşlı'>(<cf_get_lang dictionary_id='29831.Kişi'>) 5510
								</td>
								<td style="text-align:right">#TLFormat(t_retirement_allowance_personal_5510)#</td>
							</tr> 
						</cfif>
						<cfif t_health_insurance_premium_5510 gt 0 or (GET_PUANTAJ_PERSONAL.is_veteran eq 1 and t_health_insurance_premium_5510 eq 0)>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='63279.Sağlık Sigortası Primi'>(<cf_get_lang dictionary_id='44806.Devlet'>) 5510
								</td>
								<td style="text-align:right">#TLFormat(t_health_insurance_premium_5510)#</td>
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
						<cfif t_plus_retired gt 0>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='48315.Artış'> %100
								</td>
								<td style="text-align:right">#TLFormat(t_plus_retired)#</td>
							</tr> 
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='29831.Kişi'> <cf_get_lang dictionary_id='44806.Devlet'> %100
								</td>
								<td style="text-align:right">#TLFormat(t_plus_retired_person)#</td>
							</tr> 
						</cfif>
						<cfif t_retirement_allowance_5510 gt 0>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='63273.Emekli Keseneği'> / <cf_get_lang dictionary_id='63844.Malul Yaşlı'>(<cf_get_lang dictionary_id='44806.Devlet'>) 5510 (-)
								</td>
								<td style="text-align:right">#TLFormat(t_retirement_allowance_5510)#</td>
							</tr> 
						</cfif>
						<cfif t_health_insurance_premium_5510 gt 0 or (GET_PUANTAJ_PERSONAL.is_veteran eq 1 and t_health_insurance_premium_5510 eq 0)>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='63279.Sağlık Sigortası Primi'>(<cf_get_lang dictionary_id='44806.Devlet'>) 5510 (-)
								</td>
								<td style="text-align:right">#TLFormat(t_health_insurance_premium_5510)#</td>
							</tr> 
						</cfif>
						<cfif t_retirement_allowance gt 0>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='63273.Emekli Keseneği'> <cf_get_lang dictionary_id='44806.Devlet'> (-)
								</td>
								<td style="text-align:right">#tlformat(t_retirement_allowance)#</td>
							</tr>
						</cfif>
						<cfif t_retirement_allowance_personal_interruption gt 0>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='63273.Emekli Keseneği'> <cf_get_lang dictionary_id='29831.Kişi'> (-)
								</td>
								<td style="text-align:right">#tlformat(t_retirement_allowance_personal_interruption)#</td>
							</tr>
						</cfif>
						<cfif t_general_health_insurance gt 0>
							<tr>
								<td width="300px">
									<cf_get_lang dictionary_id='53191.Genel Sağlık Sigortası'> (-)
								</td>
								<td style="text-align:right">#tlformat(t_general_health_insurance)#</td>
							</tr>
						</cfif>
					</cfoutput>
					<!------ All ---->
					<cfset t_istisna_kesinti = 0>
					<cfoutput query="get_vergi_istisnas" group="COMMENT_PAY">
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
					</cfoutput>
					<cfset say_kesinti_kisi = 0>
					<cfoutput query="get_kesintis" group="COMMENT_PAY">
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
					</cfoutput>
					<cfif t_ozel_kesinti_2 gt 0>
						<cfset say_kesinti_kisi = 0>
						<cfoutput query="get_kesintis_brut" group="COMMENT_PAY">
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
						</cfoutput>
					</cfif>	
					<cfoutput query="get_vergi_istisnas" group="COMMENT_PAY">
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
					</cfoutput>
					<!------ All ---->
				</cf_grid_list>
			</div>
		</div>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<cf_grid_list align="center">  
					<cfoutput>
						<tr>
							<td width="300px"><cf_get_lang dictionary_id='63289.Hakedişler Toplamı'></td>
							<td width="300px">#TLFormat(t_toplam_kazanc)#</td>
						</tr>
						<tr>
							<td width="300px"><cf_get_lang dictionary_id='63290.Kesintiler Toplamı'></td>
							<td width="300px">#TLFormat(t_toplam_kazanc - t_net_ucret)#</td>
						</tr>
					</cfoutput>
				</cf_grid_list>
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<cf_grid_list align="center">  
					<cfoutput>
						<tr>
							<td width="300px"><cf_get_lang dictionary_id='40400.Net Ödeme'></td>
							<td width="300px">#TLFormat(t_net_ucret)#</td>
						</tr>
					</cfoutput>
				</cf_grid_list>
			</div>
		</div>
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