<cf_get_lang_set module_name="ehesap">
<cfif not icmal_type is 'personal'>
	<cf_get_lang dictionary_id='65214.Bu Puantaj Kişi Bazlı Çalışmaktadır'>
	<cfexit method="exittemplate">
</cfif>

<cfparam name="attributes.is_virtual_puantaj" default="0">
<cfset main_puantaj_table = "EMPLOYEES_PUANTAJ">
<cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS">
<cfset add_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_ADD">
<cfset maas_puantaj_table = "EMPLOYEES_SALARY">
<cfparam name="icmal_border" default="0">
<!--- Ayın ilk ve son günü --->
<cfset start_month = CreateDateTime(attributes.sal_year,attributes.sal_mon,1,0,0,0)>
<cfset end_month = CreateDateTime(attributes.sal_year,attributes.sal_mon,daysinmonth(createdate(attributes.sal_year,attributes.sal_mon,1)),0,0,0)>
<!--- Aylık katsayı cmp --->
<cfset get_factor_definition_cmp = createObject('component','V16.hr.ehesap.cfc.payroll_job')>
<cfset get_title_cmp = createObject('component','V16.hr.cfc.add_rapid_emp')>
<cfset get_factor = get_factor_definition_cmp.get_factor_definition(
	start_month : start_month,
	end_month : end_month
)>
<!--- Memur göstergesi --->
<cfset cmp_grade_step_params = createObject('component','V16.hr.ehesap.cfc.grade_step_params')>
<cfif  len(GET_PUANTAJ_PERSONAL.normal_step) and len(GET_PUANTAJ_PERSONAL.NORMAL_GRADE)>
	<cfset get_grade_step_normal = cmp_grade_step_params.GET_EMPLOYEES_GRADE_STEP_PARAMS(
		start_month : start_month,
		end_month : end_month,
		grade : GET_PUANTAJ_PERSONAL.NORMAL_GRADE,
		step : GET_PUANTAJ_PERSONAL.normal_step
	)>
</cfif>
<cfif  len(GET_PUANTAJ_PERSONAL.step) and len(GET_PUANTAJ_PERSONAL.GRADE)>
	<cfset get_grade_step = cmp_grade_step_params.GET_EMPLOYEES_GRADE_STEP_PARAMS(
		start_month : start_month,
		end_month : end_month,
		grade : GET_PUANTAJ_PERSONAL.GRADE,
		step : GET_PUANTAJ_PERSONAL.step
	)>
</cfif>
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
	t_general_health_insurance = 0;
	t_sgk_base = 0;
	t_additional_indicator_compensation = 0;
	t_extra_pay = 0;
	t_additional_score = 0;
	t_normal_additional_score = 0;
	t_audit_compensation_amount = 0;

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
	t_retired_academic = 0;
	
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
	t_land_compensation_amount = 0;//arazi tazminatı
	
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
<cfoutput query="#query_name#">
	<cfscript>
		//Gün toplamları
		//normal gün
		t_normal_gun = t_normal_gun + weekly_day;
		t_normal_hours = t_normal_hours + weekly_hour;
		
		if(len(ADDITIONAL_SCORE))
			t_additional_score =  t_additional_score + ADDITIONAL_SCORE;
		if(len(NORMAL_ADDITIONAL_SCORE))
			t_normal_additional_score =  t_normal_additional_score + NORMAL_ADDITIONAL_SCORE;
		if(len(audit_compensation_amount))
			t_audit_compensation_amount = t_audit_compensation_amount + audit_compensation_amount;
		if(len(RETIRED_ACADEMIC) and RETIRED_ACADEMIC gt 0)
			t_retired_academic = t_retired_academic + retired_academic;
		
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

		//Aylık tutar
		t_salary = t_salary + salary;
		//Taban aylık
		if(len(base_salary))
			t_base_salary = t_base_salary + base_salary;
		if(len(retirement_allowance))
			t_retirement_allowance = t_retirement_allowance + retirement_allowance;
		if(len(retirement_allowance_personal))
			t_retirement_allowance_personal = t_retirement_allowance_personal + retirement_allowance_personal;
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
		if(len(land_compensation_amount))
			t_land_compensation_amount = t_land_compensation_amount + land_compensation_amount;//Arazi tazminatı
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
	<div class="col col-12">
		<div class="col col-9">
			<div class="col col-1 col-md-2 col-sm-3 col-xs-3">
				<img src="<cfoutput>documents/settings/<cfif len(GET_PUANTAJ_PERSONAL.asset_file_name1)>#GET_PUANTAJ_PERSONAL.asset_file_name1#<cfelseif len(GET_PUANTAJ_PERSONAL.asset_file_name2)>#GET_PUANTAJ_PERSONAL.asset_file_name2#<cfelse>#GET_PUANTAJ_PERSONAL.asset_file_name3#</cfif></cfoutput>" id="bordrologo" style="width: 50px;margin: 0 15px;"/>
			</div>
			<div class="col col-11 col-md-10 col-sm-9 col-xs-9">
				<cfoutput>
					<div class="col col-12">
						<div class="col col-4">
							<h2>
								<b>
									#listgetat(ay_list(),attributes.sal_mon)# / #attributes.sal_year#
									<cfif not (isdefined("attributes.view_type") and attributes.view_type eq 1)>
										&nbsp;
										<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_year_end) and ((attributes.sal_year_end eq attributes.sal_year and attributes.sal_mon_end neq attributes.sal_mon) or attributes.sal_year_end neq attributes.sal_year)> - #listgetat(ay_list(),attributes.sal_mon_end)# / #attributes.sal_year_end#</cfif>&nbsp; 
									</cfif>
								</b>
							</h2>
						</div>
						<div class="col col-6">
							<h2><b><cf_get_lang dictionary_id='64102.Maaş Bordrosu Dökümü'></b></h2>
						</div>
					</div>
					<div class="col col-12">
						<div class="col col-12">
							<b><cf_get_lang dictionary_id='64103.VKN ve Birim Adı'> : &nbsp; 
							<cfoutput>#BRANCH_TAX_NO# &nbsp; #GET_PUANTAJ_PERSONAL.COMP_FULL_NAME# - #GET_PUANTAJ_PERSONAL.PUANTAJ_BRANCH_FULL_NAME#</cfoutput></b>
						</div>
					</div>
				</cfoutput>
			</div>
		</div>
		<div class="col col-3">
			<cfoutput>
				<div class="col col-12">
					<label class="col col-6"><cf_get_lang dictionary_id='59313.Aylık Katsayı'></label>
					<label class="col col-6">: #replace(get_factor.salary_factor,".",",")#</label>
				</div>
				<div class="col col-12">
					<label class="col col-6"><cf_get_lang dictionary_id='59315.Yan Ödeme Katsayısı'></label>
					<label class="col col-6">: #replace(get_factor.benefit_factor,".",",")#</label>
				</div>
				<div class="col col-12">
					<label class="col col-6"><cf_get_lang dictionary_id='59313.Aylık Katsayı'></label>
					<label class="col col-6">: #replace(get_factor.base_salary_factor,".",",")#</label>
				</div>
			</cfoutput>
		</div>
	</div>
	<div class="col col-12" style="margin-top:20px">
		<cf_grid_list>
			<thead>
				<tr>
					<th nowrap align = "left">
						<p><cf_get_lang dictionary_id='55657.Sıra No'> </p>
						<p><cf_get_lang dictionary_id='63668.Personel No'> - <cf_get_lang dictionary_id='58025.TC Kimlik No'></p>
						<p><cf_get_lang dictionary_id='32370.Adı Soyadı'></p>
						<p><cf_get_lang dictionary_id='64104.Hizmet Sınıfı'> - <cf_get_lang dictionary_id='57571.Ünvan'></p>
						<p>ÖD.Es.D.-K.Em.Es.D.-K.</p>
					</th>
					<th nowrap align = "left">
						<p><cf_get_lang dictionary_id='63979.Emekliye Esas'> <cf_get_lang dictionary_id='62877.Ek Gösterge Puanı'></p>
						<p><cf_get_lang dictionary_id='63980.Esas Ek Gösterge Tutarı'></p>
						<p><cf_get_lang dictionary_id='46602.Medeni Hali'> - <cf_get_lang dictionary_id='46572.Çocuk Sayısı'></p>
						<p><cf_get_lang dictionary_id='32329.Kurum Sicil No'> - <cf_get_lang dictionary_id='63673.Emekli Sicil No'></p>
						<p><cf_get_lang no='695.Kıdem Baz Tarihi'> - <cf_get_lang dictionary_id='56292.Kıdem Yıl'></p>
						<p><cf_get_lang dictionary_id='53659.Asgari Geçim İndirimi'>
					</th>
					<th nowrap align = "left">
						<p><cf_get_lang dictionary_id='63662.Aylık Tutar'></p>
						<p><cf_get_lang dictionary_id='63277.Taban Aylığı'></p>
						<p><cf_get_lang dictionary_id='32589.Ek'> <cf_get_lang dictionary_id='63272.Gösterge Tutarı'></p>
						<p><cf_get_lang dictionary_id='63275.Yan Ödeme'></p>
						<p><cf_get_lang dictionary_id='63278.Kıdem Aylığı'></p>
					</th>
					<th nowrap align = "left">
						<p><cf_get_lang dictionary_id='63664.Eş Yardımı'></p>
						<p><cf_get_lang dictionary_id='46080.Çocuk Yardımı'></p>
						<cfif t_retirement_allowance gt 0>
							<p><cf_get_lang dictionary_id='63273.Emekli Keseneği'> <cf_get_lang dictionary_id='44806.Devlet'></p>
						</cfif>
						<cfif t_retirement_allowance_5510 gt 0>
							<p><cf_get_lang dictionary_id='63273.Emekli Keseneği'> / <cf_get_lang dictionary_id='63844.Malul Yaşlı'>(<cf_get_lang dictionary_id='44806.Devlet'>) 5510
							</p>
						</cfif>
						<p><cf_get_lang dictionary_id='57554.Giriş'> %25</p>
							<p><cf_get_lang dictionary_id='48315.Artış'> %100</p>
					</th>
					<th nowrap align = "left">
						<p><cf_get_lang dictionary_id='63274.Özel Hizmet Tazminatı'></p>
						<p><cf_get_lang dictionary_id='63280.Makam Tazminatı'></p>
						<p><cf_get_lang dictionary_id='62883.Dil Tazminatı'></p>
						<p><cf_get_lang dictionary_id='63284.Toplu Sözleşme İkramiyesi'></p>
					</th>
					<th nowrap align = "left">
						<p><cf_get_lang dictionary_id='62884.Üniversite Ödeneği'></p>
						<p><cf_get_lang dictionary_id='63281.İdari Görev Tazminatı'></p>
						<p><cf_get_lang dictionary_id='63282.Eğitim Öğretim Ödeneği'></p>
						<p><cf_get_lang dictionary_id='63283.Görev Tazminatı'></p>
						<p><cf_get_lang dictionary_id='63949.Ek Ödeme (666 KHK)'></p>                               
					</th>
					<th nowrap align = "left">
						<p><cf_get_lang dictionary_id='62937.Yüksek Öğretim Tazminatı'></p>
						<p><cf_get_lang dictionary_id='62936.Akademik Teşvik Ödeneği'></p>
						<p><cf_get_lang dictionary_id='64569.Arazi Tazminatı'></p>
						<cfif t_retired_academic gt 0><p><cf_get_lang dictionary_id='64629.Brüt Maaş'></p></cfif>
					</th>
					<th nowrap align = "left">
						<!--- Todo: Kesinleşince dile alıncak --->
						<p>Döner Sermaye Matrahı</p>
						<p>Ek Ders Matrahı</p>
						<p>BAP Projeler Matrahı</p>
						<p>Maaş Matrahı Toplam</p>
					</th>
					<th nowrap align = "left">
						<p><cf_get_lang dictionary_id='40452.Gelir vergisi'></p>
						<p><cf_get_lang dictionary_id='41439.Damga Vergisi'></p>
						<p><cf_get_lang dictionary_id='29831.Kişi'> <cf_get_lang dictionary_id='44806.Devlet'> %100</p>
					</th>
					<th nowrap align = "left">
						<cfif t_retirement_allowance_personal gt 0>
							<p><cf_get_lang dictionary_id='63273.Emekli Keseneği'> <cf_get_lang dictionary_id='29831.Kişi'></p>
						</cfif>
						<cfif t_retirement_allowance_personal_5510 gt 0>
							<p><cf_get_lang dictionary_id='63273.Emekli Keseneği'> / <cf_get_lang dictionary_id='63844.Malul Yaşlı'>(<cf_get_lang dictionary_id='29831.Kişi'>) 5510</p>
						</cfif>
						<cfif t_general_health_insurance gt 0>
							<p><cf_get_lang dictionary_id='53191.Genel Sağlık Sigortası'></p>
						</cfif>
						<cfif t_health_insurance_premium_5510 gt 0>
							<p><cf_get_lang dictionary_id='63279.Sağlık Sigortası Primi'>(<cf_get_lang dictionary_id='44806.Devlet'>) 5510</p>
						</cfif>
						<cfif t_health_insurance_premium_personal_5510 gt 0>
							<p><cf_get_lang dictionary_id='63279.Sağlık Sigortası Primi'>(<cf_get_lang dictionary_id='29831.Kişi'>) 5510</p>
						</cfif>
						<p><cf_get_lang dictionary_id='64057.Kefaret Kesintisi'></p>
					</th>
					<cfif get_kesintis.recordcount or t_ozel_kesinti_2 or get_vergi_istisnas.recordcount>
						<th nowrap align = "left">
							<cfif get_kesintis.recordcount>
								<cfset say_kesinti_kisi = 0>
								<cfoutput query="get_kesintis" group="COMMENT_PAY">
									<p>#comment_pay#</p>
									<cfif t_avans gt 0 and not isdefined("is_avans_")>
										<p><cf_get_lang_main no="792.Avans"></p>
									</cfif>
								</cfoutput>
							</cfif>
							<cfoutput query="get_kesintis_brut" group="COMMENT_PAY">
								<p>#comment_pay#</p>									
							</cfoutput>
							<cfif get_vergi_istisnas.recordcount>
								<cfoutput query="get_vergi_istisnas" group="COMMENT_PAY">
									<p>#comment_pay#</p>
								</cfoutput>
							</cfif>
						</th>
					</cfif>
					<th nowrap align = "left">
						<p><cf_get_lang dictionary_id='64106.Aylık Vergi Matrahı'></p>
						<p><cf_get_lang dictionary_id='64107.Yıllık Gelir Vergisi Matrahı Toplamı'></p>
						<p><cf_get_lang dictionary_id='63289.Hakedişler Toplamı'></p>
						<p><cf_get_lang dictionary_id='63290.Kesintiler Toplamı'></p>
						<p><cf_get_lang dictionary_id='40400.Net Ödeme'></p>
					</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<cfoutput>
						<td>
							<cfif isdefined("attributes.currentrow")><p>#attributes.currentrow#</p></cfif>
							<p>#EMPLOYEE_NO# - #GET_PUANTAJ_PERSONAL.tc_identy_no#</p>
							<p>#employee_name# #employee_surname#</p>
							<p>
								<cfset get_title = get_title_cmp.get_titles(title_id: GET_PUANTAJ_PERSONAL.TITLE_ID)>
								#get_title.title# - #get_title.hierarchy#
							</p>
							<p>#GET_PUANTAJ_PERSONAL.NORMAL_GRADE# / #GET_PUANTAJ_PERSONAL.normal_step# <cfif isdefined("get_grade_step_normal")>#evaluate("get_grade_step_normal.step_#GET_PUANTAJ_PERSONAL.normal_step#")#</cfif> - #GET_PUANTAJ_PERSONAL.GRADE# / #GET_PUANTAJ_PERSONAL.step# <cfif isdefined("get_grade_step_normal.step_")>#evaluate("get_grade_step_normal.step_#GET_PUANTAJ_PERSONAL.step#")#</cfif></p>						
						</td>
						<td>
							<p>#tlformat(t_additional_score)#</p>
							<p>#tlformat(t_normal_additional_score)#</p>
							<p><cfif get_emp_family.recordcount gt 0><cf_get_lang dictionary_id='44602.Evli'><cfelse><cf_get_lang dictionary_id='44603.Bekar'></cfif> - #get_emp_child.recordcount#</p>
							<p>#GET_PUANTAJ_PERSONAL.REGISTRY_NO# - #GET_PUANTAJ_PERSONAL.RETIRED_REGISTRY_NO#</p>
							<p>#dateformat(KIDEM_DATE,dateformat_style)# - <cfif len(KIDEM_DATE)>#dateDiff('yyyy',KIDEM_DATE,now())#</cfif></p>
							<p>#TLFormat(t_vergi_iadesi)#</p>
						</td>
						<td style="text-align:right">
							<p>#tlformat(t_salary)#</p>
							<p>#tlformat(t_base_salary)#</p>
							<p>#TLFormat(t_additional_indicators)#</p>
							<p>#tlformat(business_risk)#</p>
							<p>#tlformat(t_severance_pension)#</p>
						</td>
						<td style="text-align:right">
							<p>#tlformat(t_family_assistance)#</p>
							<p>#tlformat(t_child_assistance)#</p>
							<p><cfif t_retirement_allowance gt 0>#tlformat(t_retirement_allowance)#</cfif>
							<p><cfif t_retirement_allowance_5510 gt 0>#TLFormat(t_retirement_allowance_5510)#</cfif></p>
							<!--- todo giriş %25 sorulacak --->
							<p>#TLFormat(0)#</p>
							<p>#TLFormat(t_plus_retired)#</p>
						</td>
						<td style="text-align:right">
							#tlformat(t_private_service_compensation)#</p>
							#tlformat(t_executive_indicator_compensation)#</p>
							#tlformat(t_language_allowance)#</p>
							#tlformat(t_collective_agreement_bonus)#
						</td>
						<td style="text-align:right">
							<p>#TLFormat(t_university_allowance)#</p>
							<p>#TLFormat(t_administrative_duty_allowance)#</p>
							<p>#TLFormat(t_education_allowance)#</p>
							<p>#tlformat(t_administrative_compensation)#</p>
							<p>#tlformat(t_additional_indicator_compensation)#
						</td>
						<td style="text-align:right">
							<p>#tlformat(t_high_education_compensation)#</p>
							<p>#tlformat(t_academic_incentive_allowance_amount)#</p>
							<p>#tlformat(t_land_compensation_amount)#</p>
							<cfif t_retired_academic gt 0><p>#tlformat(t_retired_academic)#</p></cfif>
						</td>
						<td style="text-align:right">
							<p>?</p>
							<p>?</p>
							<p>?</p>
							<p>?</p>
						</td>
						<td style="text-align:right">
							<p>#TLFormat(t_gelir_vergisi)#</p>
							<p>#TLFormat(t_damga_vergisi)#</p>
							<p>#TLFormat(t_plus_retired_person)#</p>
						</td>
						<td style="text-align:right">
							<cfif t_retirement_allowance_personal gt 0><p>#tlformat(t_retirement_allowance_personal)#</p></cfif>
							<cfif t_retirement_allowance_personal_5510 gt 0><p>#TLFormat(t_retirement_allowance_personal_5510)#</p></cfif>
							<cfif t_general_health_insurance gt 0><p>#tlformat(t_general_health_insurance)#</p></cfif>
							<cfif t_health_insurance_premium_5510 gt 0><p>#TLFormat(t_health_insurance_premium_5510)#</p></cfif>
							<cfif t_health_insurance_premium_personal_5510 gt 0><p>#TLFormat(t_health_insurance_premium_personal_5510)#</p></cfif>
							<p>#TLFormat(t_penance_deduction)#</p>
						</td>
					</cfoutput>
					<cfif get_kesintis.recordcount or t_ozel_kesinti_2 or get_vergi_istisnas.recordcount>
						<td style="text-align:right">
							<cfif get_kesintis.recordcount>
								<cfset say_kesinti_kisi = 0>
								<cfoutput query="get_kesintis" group="COMMENT_PAY">
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
									<cfif comment_pay is 'Avans' and t_avans gt 0><p>#TLFormat(tmp_total + t_avans)#</p><cfset is_avans_ = 1><cfelse><p>#TLFormat(tmp_total)#</p></cfif>
									<cfif t_avans gt 0 and not isdefined("is_avans_")>
										<p>#TLFormat(t_avans)#</p>
									</cfif>
								</cfoutput>
							</cfif>
							<cfif t_ozel_kesinti_2 gt 0>
								<cfset say_kesinti_kisi = 0>
								<cfoutput query="get_kesintis_brut" group="COMMENT_PAY">
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
									<cfif comment_pay is 'Avans' and t_avans gt 0><p>#TLFormat(tmp_total + t_avans)#</p><cfset is_avans_ = 1><cfelse><p>#TLFormat(tmp_total)#</p></cfif>										
								</cfoutput>
							</cfif>	
							<cfif get_vergi_istisnas.recordcount>
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
									<p>#TLFormat(tmp_total)#</p>
								</cfoutput>
							</cfif>
						</td>
					</cfif>
					<cfoutput>
						<td style="text-align:right">
							<p>#tlformat(t_gelir_vergisi_matrahi)#</p>
							<p>#TLFormat(t_kum_gelir_vergisi_matrahi)#</p>
							<p>#TLFormat(t_toplam_kazanc)#</p>
							<p>#TLFormat(t_toplam_kazanc - t_net_ucret)#</p>
							<p>#TLFormat(t_net_ucret)#
						</td>
					</cfoutput>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<cfoutput>
						<td colspan="2">
							<cf_get_lang dictionary_id='64108.Sınıf Toplamı'>
						</td>
						<td style="text-align:right">
							<p>#tlformat(t_salary)#</p>
							<p>#tlformat(t_base_salary)#</p>
							<p>#TLFormat(t_additional_indicators)#</p>
							<p>#tlformat(business_risk)#</p>
							<p>#tlformat(t_severance_pension)#</p>
						</td>
						<td style="text-align:right">
							<p>#tlformat(t_family_assistance)#</p>
							<p>#tlformat(t_child_assistance)#</p>
							<p><cfif t_retirement_allowance gt 0>#tlformat(t_retirement_allowance)#</cfif>
							<p><cfif t_retirement_allowance_5510 gt 0>#TLFormat(t_retirement_allowance_5510)#</cfif></p>
							<!--- todo giriş %25 sorulacak --->
							<p>#TLFormat(0)#</p>
							<p>#TLFormat(t_plus_retired)#</p>
						</td>
						<td style="text-align:right">
							#tlformat(t_private_service_compensation)#</p>
							#tlformat(t_executive_indicator_compensation)#</p>
							#tlformat(t_language_allowance)#</p>
							#tlformat(t_collective_agreement_bonus)#
						</td>
						<td style="text-align:right">
							<p>#TLFormat(t_university_allowance)#</p>
							<p>#TLFormat(t_administrative_duty_allowance)#</p>
							<p>#TLFormat(t_education_allowance)#</p>
							<p>#tlformat(t_administrative_compensation)#</p>
							<p>#tlformat(t_additional_indicator_compensation)#
						</td>
						<td style="text-align:right">
							<p>#tlformat(t_high_education_compensation)#</p>
							<p>#tlformat(t_academic_incentive_allowance_amount)#</p>
							<p>#tlformat(t_land_compensation_amount)#</p>
							<cfif t_retired_academic gt 0><p>#tlformat(t_retired_academic)#</p></cfif>
						</td>
						<td style="text-align:right">
						</td>
						<td style="text-align:right">
							<p>#TLFormat(t_gelir_vergisi)#</p>
							<p>#TLFormat(t_damga_vergisi)#</p>
							<p>#TLFormat(t_plus_retired_person)#</p>
						</td>
						<td style="text-align:right">
							<cfif t_retirement_allowance_personal gt 0><p>#tlformat(t_retirement_allowance_personal)#</p></cfif>
							<cfif t_retirement_allowance_personal_5510 gt 0><p>#TLFormat(t_retirement_allowance_personal_5510)#</p></cfif>
							<cfif t_general_health_insurance gt 0><p>#tlformat(t_general_health_insurance)#</p></cfif>
							<cfif t_health_insurance_premium_5510 gt 0><p>#TLFormat(t_health_insurance_premium_5510)#</p></cfif>
							<cfif t_health_insurance_premium_personal_5510 gt 0><p>#TLFormat(t_health_insurance_premium_personal_5510)#</p></cfif>
							<p>#TLFormat(t_penance_deduction)#</p>
						</td>
					</cfoutput>
					<cfif get_kesintis.recordcount or t_ozel_kesinti_2 or get_vergi_istisnas.recordcount>
						<td style="text-align:right">
							<cfif get_kesintis.recordcount>
								<cfset say_kesinti_kisi = 0>
								<cfoutput query="get_kesintis" group="COMMENT_PAY">
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
									<cfif comment_pay is 'Avans' and t_avans gt 0><p>#TLFormat(tmp_total + t_avans)#</p><cfset is_avans_ = 1><cfelse><p>#TLFormat(tmp_total)#</p></cfif>
									<cfif t_avans gt 0 and not isdefined("is_avans_")>
										<p>#TLFormat(t_avans)#</p>
									</cfif>
								</cfoutput>
							</cfif>
							<cfif t_ozel_kesinti_2 gt 0>
								<cfset say_kesinti_kisi = 0>
								<cfoutput query="get_kesintis_brut" group="COMMENT_PAY">
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
									<cfif comment_pay is 'Avans' and t_avans gt 0><p>#TLFormat(tmp_total + t_avans)#</p><cfset is_avans_ = 1><cfelse><p>#TLFormat(tmp_total)#</p></cfif>										
								</cfoutput>
							</cfif>	
							<cfif get_vergi_istisnas.recordcount>
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
									<p>#TLFormat(tmp_total)#</p>
								</cfoutput>
							</cfif>
						</td>
					</cfif>
					<cfoutput>
						<td style="text-align:right">
							<p></p>
							<p></p>
							<p>#TLFormat(t_toplam_kazanc)#</p>
							<p>#TLFormat(t_toplam_kazanc - t_net_ucret)#</p>
							<p>#TLFormat(t_net_ucret)#
						</td>
					</cfoutput>
				</tr>
			</tfoot>
		</cf_grid_list>
	</div>

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