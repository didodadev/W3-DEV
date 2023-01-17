<cfif not isdefined("x_company_logo")>
	<cf_xml_page_edit fuseact="ehesap.list_icmal">
</cfif>
<cf_get_lang_set module_name="ehesap">
<cfparam name="attributes.is_virtual_puantaj" default="0">
<cfparam name="attributes.show_detail" default="0">
<cfparam name="x_view_ext_workday" default="0">
<cfset main_puantaj_table = "EMPLOYEES_PUANTAJ">
<cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS">
<cfset add_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_ADD">
<cfset maas_puantaj_table = "EMPLOYEES_SALARY">
<cfparam name="icmal_border" default="0">

<!--Muzaffer Bas-->
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset Akdi_Gun = get_fuseaction_property.get_fuseaction_property(
	company_id : session.ep.company_id,
	fuseaction_name : 'ehesap.form_upd_program_parameters',
	property_name : 'x_Akdi_Gun'  
)>
<cfset x_Akdi_Gun = Akdi_Gun.PROPERTY_VALUE>
<cfset Akdi_Gun_FM = get_fuseaction_property.get_fuseaction_property(
	company_id : session.ep.company_id,
	fuseaction_name : 'ehesap.form_upd_program_parameters',
	property_name : 'x_akdi_day_work'
)>
<cfset x_akdi_day_work = Akdi_Gun_FM.PROPERTY_VALUE>

<cfset Hafta_tatili_FM = get_fuseaction_property.get_fuseaction_property(
	company_id : session.ep.company_id,
	fuseaction_name : 'ehesap.form_upd_program_parameters',
	property_name : 'x_weekly_day_work'
)>
<cfset x_weekly_day_work = Hafta_tatili_FM.PROPERTY_VALUE>

<cfset Resmi_Tatil_Gun = get_fuseaction_property.get_fuseaction_property(
	company_id : session.ep.company_id,
	fuseaction_name : 'ehesap.form_upd_program_parameters',
	property_name : 'x_official_day_work'
)>
<cfset x_official_day_work = Resmi_Tatil_Gun.PROPERTY_VALUE>

<cfset Arefe_Gun_FM = get_fuseaction_property.get_fuseaction_property(
	company_id : session.ep.company_id,
	fuseaction_name : 'ehesap.form_upd_program_parameters',
	property_name : 'x_Arefe_day_work'
)>
<cfset x_Arefe_day_work = Arefe_Gun_FM.PROPERTY_VALUE>

<cfset Dini_Gun_FM = get_fuseaction_property.get_fuseaction_property(
	company_id : session.ep.company_id,
	fuseaction_name : 'ehesap.form_upd_program_parameters',
	property_name : 'x_Dini_day_work'
)>
<cfset x_Dini_day_work = Dini_Gun_FM.PROPERTY_VALUE>

<cfset temptaily_hour=0>
<cfif x_view_ext_workday eq 0>
	<cfset get_comp_hours = createObject("component","V16.myhome.cfc.free_time")>
	<cfset comp_hours = get_comp_hours.GET_HOURS_FNC(company_id: session.ep.company_id)>
	<cfset temptaily_hour = comp_hours.DAILY_WORK_HOURS>
</cfif>
<!---Muzaffer Bitis---->

<cfif x_view_ext_workday eq 1>
	<cfset get_comp_hours = createObject("component","V16.myhome.cfc.free_time")>
	<cfset comp_hours = get_comp_hours.GET_HOURS_FNC(company_id: session.ep.company_id)>
	<cfset daily_workhour = comp_hours.DAILY_WORK_HOURS>
</cfif>
<cfinclude template="../query/get_hours.cfm">
<!--- Ayın ilk ve son günü --->
<cfset start_month = CreateDateTime(attributes.sal_year,attributes.sal_mon,1,0,0,0)>
<cfset end_month = CreateDateTime(attributes.sal_year,attributes.sal_mon,daysinmonth(createdate(attributes.sal_year,attributes.sal_mon,1)),0,0,0)>

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


	t_health_insurance_premium_worker = 0; //Hastalık Sigorta Primi İşçi
	t_health_insurance_premium_employer = 0; //Hastalık Sigorta Primi İşveren
	t_death_insurance_premium_worker = 0;//Malülük, Yaşlılık, Ölüm Sigorta Primi İşçi
	t_death_insurance_premium_employer = 0;//Malülük, Yaşlılık, Ölüm Sigorta Primi İşveren
	t_short_term_premium_employer = 0;//Kısa Vadeli Sigorta Kolları Prim 

	//---Muzaffer Bas---
	t_ext_work_hours_8 = 0;
	t_ext_work_hours_9 = 0;
	t_ext_work_hours_10 = 0;
	t_ext_work_hours_11 = 0;
	t_ext_work_hours_12 = 0;

	t_ext_salary_8 = 0;
	t_ext_salary_9 = 0 ;
	t_ext_salary_10 = 0 ;
	t_ext_salary_11 = 0 ;
	t_ext_salary_12 = 0 ;

	fmesai_sayac_8 = 0;
	fmesai_sayac_9 = 0;
	fmesai_sayac_10 = 0;
	fmesai_sayac_11 = 0;
	fmesai_sayac_12 = 0;	
	t_akdi_tatil = 0;
	t_akdi_tatil_hours = 0;
	t_akdi_tatil_amount = 0;

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
	t_income_tax_temp = 0;
	t_damga_vergisi = 0;
	t_stamp_tax_temp = 0;

	t_daily_minimum_wage_base_cumulate = 0;
	t_minimum_wage_cumulative  = 0;
	t_daily_minimum_income_tax = 0;
	t_daily_minimum_wage_stamp_tax = 0;
	t_daily_minimum_wage = 0;

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
	t_ssk_isveren_hissesi_3294 = 0;
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
	
	t_kum_gelir_vergisi_matrahi_icmal = 0;
		
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
	ssk_isveren_hissesi_control = 0;
	t_indirimsiz_damga_vergisi = 0;
	t_gelir_vergisi_hesaplanan = 0;
	t_ssk_transfer_amount = 0;
</cfscript>
<cfif icmal_type is 'genel' and (not isdefined("attributes.func_id") or (isdefined("attributes.func_id") and not len(attributes.func_id)))>
	<!---<cfquery name="GET_OLD_PUANTAJ" datasource="#dsn#" maxrows="1">
		SELECT
			PUANTAJ_ID
		FROM
			#main_puantaj_table# EP,
			BRANCH B
		WHERE
			<cfif isdefined("attributes.branch_id") and listlen(attributes.branch_id)>
			B.BRANCH_ID IN (#attributes.branch_id#) AND
			</cfif>
			EP.SSK_BRANCH_ID = B.BRANCH_ID AND
			EP.SAL_MON < #attributes.SAL_MON# AND
			EP.SAL_YEAR = <cfif isdefined("attributes.sal_year") and isnumeric(attributes.sal_year)>#attributes.sal_year#<cfelse>#session.ep.period_year#</cfif>
		ORDER BY 
			PUANTAJ_ID DESC,
			SAL_MON DESC
	</cfquery>
	<cfif GET_OLD_PUANTAJ.recordcount>
		<cfquery name="GET_OLD_PUANTAJ_ROWS" datasource="#dsn#">
			SELECT
				SUM(EPR.KUMULATIF_GELIR_MATRAH) AS KUM_TOPLAM,
				SUM(EPR.GELIR_VERGISI) AS GELIR_TOPLAM
			FROM
				#row_puantaj_table# EPR
			WHERE
				EPR.PUANTAJ_ID = #GET_OLD_PUANTAJ.PUANTAJ_ID# AND 
				EPR.EMPLOYEE_ID IN(#evaluate('valueList(#query_name#.EMPLOYEE_ID)')#)
		</cfquery>
		<cfif GET_OLD_PUANTAJ_ROWS.RECORDCOUNT and len(GET_OLD_PUANTAJ_ROWS.KUM_TOPLAM)>
			<cfset onceki_donem_kum_gelir_vergisi_matrahi = GET_OLD_PUANTAJ_ROWS.KUM_TOPLAM>
			<cfset onceki_donem_kum_gelir_vergisi = GET_OLD_PUANTAJ_ROWS.GELIR_TOPLAM>
		</cfif>
	</cfif>--->
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
<cfif x_Offtime_Detail eq 1>
	<cfquery name="get_izins" datasource="#dsn#">
		SELECT
		SETUP_OFFTIME.EBILDIRGE_TYPE_ID as IzınID,SETUP_OFFTIME.OFFTIMECAT as IZIN, 
		sum(DATEDIFF(DAY,OFFTIME.STARTDATE,OFFTIME.FINISHDATE)+1) AS Gun
		FROM
			OFFTIME,SETUP_OFFTIME
		WHERE
			SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID AND
			OFFTIME.VALID = 1 AND
			OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND
			OFFTIME.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#"> AND 
			OFFTIME.IS_PUANTAJ_OFF = 0  AND 
			OFFTIME.EMPLOYEE_ID IN (#evaluate('valueList(#query_name#.EMPLOYEE_ID)')#) 
		
			group by SETUP_OFFTIME.EBILDIRGE_TYPE_ID,SETUP_OFFTIME.OFFTIMECAT
	</cfquery>

	<cfquery name="TBI_get_izins_Ucretli" dbtype="query">
		SELECT
			IZIN,Gun
		FROM
			get_izins
		WHERE
			IzınID = 13 
			
	</cfquery>

	<cfquery name="TBI_get_izins_Ucretsiz" dbtype="query">
		SELECT
			IZIN,Gun
		FROM
			get_izins
		WHERE
			IzınID IN(21,15,3,1,16,20)  
	</cfquery>
	<cfdump var="#TBI_get_izins_Ucretsiz#">
	<cfquery name="TBI_get_izins_UcretliHS" dbtype="query">
		SELECT
			IZIN,Gun
		FROM
			get_izins
		WHERE
			IzınID = 1
	</cfquery>
<cfelse>
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
</cfif>
<cfoutput query="#query_name#">
	<cfscript>
		//Gün toplamları
		//normal gün
        t_normal_gun = t_normal_gun + weekly_day;
        t_normal_hours = t_normal_hours + weekly_hour;

		//Akdi Gün Tatili ---Muzaffer Buraya Yazman lazım----
		if(len(akdi_day))t_akdi_tatil = t_akdi_tatil + akdi_day;
		if(len(akdi_hour))t_akdi_tatil_hours=t_akdi_tatil_hours +akdi_hour;	
	
		
		//haftalık tatil
		t_haftalik_tatil = t_haftalik_tatil + weekend_day;
		t_haftalik_tatil_hours = t_haftalik_tatil_hours + weekend_hour;
		
		//ucretsiz izin gün ve saat
		t_izin = t_izin + izin;
		t_izin_hours = t_izin_hours + izin_count;

		t_kum_gelir_vergisi_matrahi_icmal = t_kum_gelir_vergisi_matrahi_icmal + KUMULATIF_GELIR_MATRAH;
	
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

		//Muzaffer-- Akdi Gün Toplamları
		if(len(akdi_amount))t_akdi_tatil_amount=t_akdi_tatil_amount+akdi_amount;
		
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

		//---Muzaffer Bas----		
		if(len(EXT_TOTAL_HOURS_8))t_ext_work_hours_8 = t_ext_work_hours_8 + EXT_TOTAL_HOURS_8;
		if(len(EXT_TOTAL_HOURS_9))t_ext_work_hours_9 = t_ext_work_hours_9 + EXT_TOTAL_HOURS_9;
		if(len(EXT_TOTAL_HOURS_10))t_ext_work_hours_10 =t_ext_work_hours_10 + EXT_TOTAL_HOURS_10;
		if(len(EXT_TOTAL_HOURS_11))t_ext_work_hours_11= t_ext_work_hours_11 + EXT_TOTAL_HOURS_11;
		if(len(EXT_TOTAL_HOURS_12))t_ext_work_hours_12= t_ext_work_hours_12 + EXT_TOTAL_HOURS_12;

		if(len(EXT_TOTAL_HOURS_8_AMOUNT))t_ext_salary_8  = t_ext_salary_8 + EXT_TOTAL_HOURS_8_AMOUNT;
		if(len(EXT_TOTAL_HOURS_9_AMOUNT))t_ext_salary_9  = t_ext_salary_9 + EXT_TOTAL_HOURS_9_AMOUNT;
		if(len(EXT_TOTAL_HOURS_10_AMOUNT))t_ext_salary_10 = t_ext_salary_10 + EXT_TOTAL_HOURS_10_AMOUNT;
		if(len(EXT_TOTAL_HOURS_11_AMOUNT))t_ext_salary_11 = t_ext_salary_11 + EXT_TOTAL_HOURS_11_AMOUNT;
		if(len(EXT_TOTAL_HOURS_12_AMOUNT))t_ext_salary_12 = t_ext_salary_12 + EXT_TOTAL_HOURS_12_AMOUNT;
		//---Muzaffer Bitis----

		t_ext_Salary = t_ext_salary_0 + t_ext_salary_1 + t_ext_salary_2 + t_ext_salary_5+ t_ext_salary_8 + t_ext_salary_9 + t_ext_salary_10 + t_ext_salary_11 + t_ext_salary_12;

		if(EXT_TOTAL_HOURS_0 gt 0)fmesai_sayac_1 = fmesai_sayac_1 + 1;
		if(EXT_TOTAL_HOURS_1 gt 0)fmesai_sayac_2 = fmesai_sayac_2 + 1;
		if(EXT_TOTAL_HOURS_2 gt 0)fmesai_sayac_3 = fmesai_sayac_3 + 1;
		if(EXT_TOTAL_HOURS_5 gt 0)fmesai_sayac_4 = fmesai_sayac_4 + 1;

		if(EXT_TOTAL_HOURS_8 gt 0)fmesai_sayac_8 = fmesai_sayac_8 + 1;
		if(EXT_TOTAL_HOURS_9 gt 0)fmesai_sayac_9 = fmesai_sayac_9 + 1;
		if(EXT_TOTAL_HOURS_10 gt 0)fmesai_sayac_10 = fmesai_sayac_10 + 1;
		if(EXT_TOTAL_HOURS_11 gt 0)fmesai_sayac_11 = fmesai_sayac_11+ 1;
		if(EXT_TOTAL_HOURS_12 gt 0)fmesai_sayac_12 = fmesai_sayac_12+ 1;

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
		if(IS_START_CUMULATIVE_TAX eq 1 and isnumeric(START_CUMULATIVE_TAX) and sal_year eq year(START_DATE))
			t_kum_gelir_vergisi = t_kum_gelir_vergisi + START_CUMULATIVE_TAX;
		//Ücret kartından Dönem Başı Kümüle Vergi Matrahı geliyorsa e bordroya yansıtılıyorsa
		if(len(CUMULATIVE_TAX_TOTAL) and  isnumeric(START_CUMULATIVE_TAX) and sal_year eq year(START_DATE))
			t_kum_gelir_vergisi_matrahi = t_kum_gelir_vergisi_matrahi + CUMULATIVE_TAX_TOTAL;
		t_gelir_vergisi_matrahi = t_gelir_vergisi_matrahi + gelir_vergisi_matrah;
		t_gelir_vergisi = t_gelir_vergisi + gelir_vergisi;

		if(len(income_tax_temp))
			t_income_tax_temp = t_income_tax_temp + income_tax_temp;
		t_damga_vergisi = t_damga_vergisi + damga_vergisi;

		if(attributes.sal_year lte 2021)
			t_indirimsiz_damga_vergisi = t_damga_vergisi;
		else if(damga_vergisi gt 0)
			t_indirimsiz_damga_vergisi = t_indirimsiz_damga_vergisi + damga_vergisi + daily_minimum_wage_stamp_tax;
		else if(damga_vergisi eq 0 and stamp_tax_temp gt 0)
			t_indirimsiz_damga_vergisi = t_indirimsiz_damga_vergisi + stamp_tax_temp;

		if(len(stamp_tax_temp))
			t_stamp_tax_temp = t_stamp_tax_temp + stamp_tax_temp;

		if(len(daily_minimum_wage_base_cumulate))
            t_daily_minimum_wage_base_cumulate = t_daily_minimum_wage_base_cumulate + daily_minimum_wage_base_cumulate;

		if(len(minimum_wage_cumulative ))
            t_minimum_wage_cumulative = t_minimum_wage_cumulative  + minimum_wage_cumulative;
            
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
		t_ssk_transfer_amount = t_ssk_transfer_amount + iIf(len(ssk_transfer_amount), ssk_transfer_amount, 0);
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
		if(ssk_statute eq 2 or ssk_statute eq 18) //Yeraltı Emekli Gurubu için
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
				if(ssk_isveren_hissesi lt 0)
				{
					ssk_isveren_hissesi_control = 0;
				}
					
				else
					ssk_isveren_hissesi_control = ssk_isveren_hissesi;
					
				t_ssk_primi_isveren = t_ssk_primi_isveren + ssk_isveren_hissesi_control;
                isveren_hesaplanan = ssk_isveren_hissesi_control + ssk_isveren_hissesi_5510 + ssk_isveren_hissesi_5084;
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
				if(len(ssk_isveren_hissesi_3294))
					t_ssk_isveren_hissesi_3294 = t_ssk_isveren_hissesi_3294 + ssk_isveren_hissesi_3294;
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

		if(len(health_insurance_premium_worker))
			t_health_insurance_premium_worker += health_insurance_premium_worker; //Hastalık Sigorta Primi İşçi
		if(len(health_insurance_premium_employer))
			t_health_insurance_premium_employer += health_insurance_premium_employer; //Hastalık Sigorta Primi İşveren
		if(len(death_insurance_premium_worker))
			t_death_insurance_premium_worker += death_insurance_premium_worker;//Malülük, Yaşlılık, Ölüm Sigorta Primi İşçi
		if(len(death_insurance_premium_employer))
			t_death_insurance_premium_employer += death_insurance_premium_employer;//Malülük, Yaşlılık, Ölüm Sigorta Primi İşveren
		if(len(short_term_premium_employer))
			t_short_term_premium_employer += short_term_premium_employer;//Kısa Vadeli Sigorta Kolları Prim 

		if(attributes.sal_year lte 2021)
			t_gelir_vergisi_hesaplanan = t_gelir_vergisi + t_vergi_indirimi_5084 + t_vergi_iadesi + t_vergi_indirimi_5746_all + t_vergi_indirimi_4691_all;
		else if(gelir_vergisi - gelir_vergisi_indirimi_687 - gelir_vergisi_indirimi_7103 gt 0)
			t_gelir_vergisi_hesaplanan = t_gelir_vergisi_hesaplanan + gelir_vergisi - gelir_vergisi_indirimi_687 - gelir_vergisi_indirimi_7103 + daily_minimum_income_tax;
		else if(gelir_vergisi eq 0 and income_tax_temp gt 0)
			t_gelir_vergisi_hesaplanan = t_gelir_vergisi_hesaplanan + income_tax_temp;
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

<cfif attributes.fuseaction neq "ehesap.list_icmal" and x_Offtime_Detail eq 1>
	<cfset TBI_salary=salary>
	<cfset TBI_salary_type=salary_type>
</cfif>

<cfif isdefined("url.fuseaction") and url.fuseaction eq 'ehesap.popupflush_view_puantaj_print_pdf'>
	<cfset uidrop_value="0">
	<cfset title="">
<cfelse>
	<cfset uidrop_value="1">
	<cfset title="#getLang('','Bordro','53179')#">
</cfif>
<cfquery name="GET_PROTESTS" datasource="#DSN#" maxrows="1">
	SELECT * FROM EMPLOYEES_PUANTAJ_PROTESTS WHERE SAL_MON=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND SAL_YEAR=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EMPLOYEE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> ORDER BY PROTEST_ID DESC
</cfquery>

<cf_box title="#title#" closable="0" uidrop="1">
	<div id="printBordro">
		<style>
			#bordrologo{ display:none; width: 145px;margin: 0 15px;}
			@media print {
			div#printBordro td {
						padding: 0px !important;
						font-size:10px !important;
				}
				#bordrologo{ display:block !important;}
			}
		</style>
		<cfif icmal_type is 'personal' and x_company_logo eq 1>
			<img src="<cfoutput>documents/settings/#GET_PUANTAJ_PERSONAL.asset_file_name2#</cfoutput>" id="bordrologo"/>
		<cfelseif x_company_logo eq 1>
			<img src="<cfoutput>documents/settings/#get_puantaj_rows.asset_file_name2#</cfoutput>" id="bordrologo"/>
		</cfif>
		<div <cfif icmal_type is 'personal' and listFirst(attributes.fuseaction,".") is 'myhome'>class="col col-10"<cfelse>class="col col-12"</cfif>>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12 ">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<cf_grid_list sort="0" cellspacing="0" cellpadding="2" align="center">  
							<tbody>
								<cfoutput>
									<tr>
										<td width="50%" colspan="2" class="icmal_border_last_td">
											<b><cf_get_lang dictionary_id="58485.Şirket Adı"> :</b>
											<cfif icmal_type is 'personal'>
												<cfoutput>#GET_PUANTAJ_PERSONAL.COMP_FULL_NAME# - #GET_PUANTAJ_PERSONAL.PUANTAJ_BRANCH_FULL_NAME#<br />
												<b><cf_get_lang dictionary_id='58079.İnternet'> :</b> #WEB#<br />
												<b><cf_get_lang dictionary_id="58723.Adres"> :</b> #ADDRESS#<br />
												<cfif len(mersis_no)>
												<b><cf_get_lang dictionary_id='43035.Mersis No'> :</b> #mersis_no#
												<cfelse>
												<b><cf_get_lang dictionary_id='53495.Ticaret Sicil No'> :</b> #T_NO#
												</cfif>
												</cfoutput>
											<cfelseif icmal_type is 'genel'>
												<cfset o_comp_list = listdeleteduplicates(valuelist(get_puantaj_rows.COMP_FULL_NAME))>
												<cfoutput>#o_comp_list#</cfoutput><br />
												<cfset b_list = listdeleteduplicates(valuelist(get_puantaj_rows.PUANTAJ_BRANCH_FULL_NAME))>
												<cfoutput>#b_list#</cfoutput>
												<cfif listlen(o_comp_list) eq 1><!--- isdefined("attributes.branch_id") and listlen(attributes.branch_id) eq 1--->
													<br /><cfset web_list = listdeleteduplicates(valuelist(get_puantaj_rows.WEB))>
													<cfoutput><b><cf_get_lang dictionary_id='58079.İnternet'> :</b> #web_list#</cfoutput><br />
													<cfif isdefined("attributes.branch_id") and listlen(attributes.branch_id) and listlen(b_list) eq 1>
														<cfoutput><b><cf_get_lang dictionary_id="58723.Adres"> :</b> #get_puantaj_rows.BRANCH_ADDRESS# #get_puantaj_rows.BRANCH_COUNTY# #get_puantaj_rows.BRANCH_CITY#</cfoutput><br />
													<cfelse>
														<cfset o_comp_address_list = listdeleteduplicates(valuelist(get_puantaj_rows.ADDRESS))>
														<cfoutput><b><cf_get_lang dictionary_id="58723.Adres"> :</b> #o_comp_address_list#</cfoutput><br />
													</cfif>
													<cfset o_mersis_list = listdeleteduplicates(valuelist(get_puantaj_rows.mersis_no))>
													<cfset o_tno_list = listdeleteduplicates(valuelist(get_puantaj_rows.T_NO))>
													<cfoutput>
														<cfif len(o_mersis_list)><b><cf_get_lang dictionary_id='43035.Mersis No'> :</b> #o_mersis_list#<cfelse><b><cf_get_lang dictionary_id='53495.Ticaret Sicil No'> :</b> #o_tno_list#</cfif>
													</cfoutput>
												</cfif>
											<cfelseif icmal_type is 'masraf merkezi'>
												<cfif Len(attributes.ssk_office)>
													<cfoutput>#ListLast(attributes.ssk_office, '-')# - #ListGetAt(attributes.ssk_office, 3, '-')#</cfoutput>
												</cfif>
											</cfif>
											<cfif isdefined("attributes.department") and listlen(attributes.department)>
												<br><b><cf_get_lang dictionary_id="57572.Departman">:</b>
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
														<cfif not attributes.fuseaction contains "popup_view_price_compass"><cf_get_lang dictionary_id="58584.İcmal"><cfelse><cf_get_lang dictionary_id="52975.Ücret Pusulası"></cfif>
													</td>
													<td style="text-align:right" class="txtbold">
														<cfif icmal_type is "personal">
															<cf_get_lang dictionary_id="57572.Departman"> : #GET_PUANTAJ_PERSONAL.ROW_DEPARTMENT_HEAD#
														</cfif>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="2" class="icmal_border_without_top">
											<cfif icmal_type is "genel">
												<b><cf_get_lang dictionary_id="53725.Şube SGK">:</b> 
												<cfset s_info_list = listdeleteduplicates(valuelist(get_puantaj_rows.SUBE_SSK_INFO))>
												#s_info_list#
											</cfif>
											<cfif icmal_type is "personal">
												<cf_get_lang dictionary_id="53725.Şube SGK"> : #ssk_m##SSK_JOB##SSK_BRANCH##SSK_BRANCH_OLD##B_SSK_NO##SSK_CITY##SSK_COUNTRY##SSK_CD##SSK_AGENT#<br/>
												<cf_get_lang dictionary_id='58762.Vergi Dairesi'> : #GET_PUANTAJ_PERSONAL.BRANCH_TAX_OFFICE#<br>
												<cf_get_lang dictionary_id='56085.Vergi Numarası'> : #GET_PUANTAJ_PERSONAL.BRANCH_TAX_NO#<br/>
												<cf_get_lang dictionary_id="53769.Adı Soyadı"> :#employee_name# #employee_surname#<br/>
												<cf_get_lang dictionary_id="58487.Çalışan No"> :#EMPLOYEE_NO#<br>
											</cfif>
											<cfif isdefined("attributes.ssk_statute") and listlen(attributes.ssk_statute)>
												<br><b><cf_get_lang dictionary_id="53553.SGK Statüleri"> :</b>
												<cfset s_list = attributes.ssk_statute>
												<cfloop list="#s_list#" index="ccc">
													<cfoutput>#listgetat(list_ucret_names(),listfindnocase(list_ucret(),ccc,','),'*')#</cfoutput><cfif ccc - 1 neq ListLen(s_list) AND ccc gt 1>,</cfif>
												</cfloop>
											</cfif>
											<cfif icmal_type is "genel">
												<cfif isdefined("attributes.EXPENSE_CENTER") and len(attributes.EXPENSE_CENTER)>
													<br>
												<cfset exp_code_list = listdeleteduplicates(valuelist(get_puantaj_rows.EXP_NAME))>
													<b><cf_get_lang dictionary_id="58460.Masraf Merkezi">:</b> #exp_code_list#
												</cfif>
												<cfif isdefined('attributes.duty_type') and len(attributes.duty_type)>
													<br />
													<cfset duty_type_name = "">
													<cfset duty_type_list = listdeleteduplicates(valuelist(get_puantaj_rows.duty_type))>
													<cfif len(duty_type_list)>
													<cfloop list="#duty_type_list#" delimiters="," index="t">
														<cfif t eq 2>
															<cfsavecontent variable="message"><cf_get_lang dictionary_id="57576.Çalışan"></cfsavecontent>
														<cfelseif t eq 1>
															<cfsavecontent variable="message"><cf_get_lang dictionary_id="53140.İşveren Vekili"></cfsavecontent>
														<cfelseif t eq 0>
															<cfsavecontent variable="message"><cf_get_lang dictionary_id='53550.İşveren'></cfsavecontent>
														<cfelseif t eq 3>
															<cfsavecontent variable="message"><cf_get_lang dictionary_id="53152.Sendikalı"></cfsavecontent>
														<cfelseif t eq 4>
															<cfsavecontent variable="message"><cf_get_lang dictionary_id="53178.Sözleşmeli"></cfsavecontent>
														<cfelseif t eq 5>
															<cfsavecontent variable="message"><cf_get_lang dictionary_id="53169.Kapsam Dışı"></cfsavecontent>
														<cfelseif t eq 6>
															<cfsavecontent variable="message"><cf_get_lang dictionary_id="53182.Kısmi İstihdam"></cfsavecontent>
														<cfelseif t eq 7>
															<cfsavecontent variable="message"><cf_get_lang dictionary_id="53199.Taşeron"></cfsavecontent>
														</cfif>
														<cfset duty_type_name = listappend(duty_type_name,"#message#",',')>						
													</cfloop>
													</cfif>
													<b><cf_get_lang dictionary_id="58538.Görev Tipi">:</b> #duty_type_name#
												</cfif>
												<cfif isdefined('attributes.period_code_cat') and len(attributes.period_code_cat)>				
													<br />
													<cfset account_code_list = listdeleteduplicates(valuelist(get_puantaj_rows.definition))>
													<b><cf_get_lang dictionary_id='54117.Muhasebe Kod Grubu'>:</b> #account_code_list#
												</cfif>
											</cfif>
										</td>
										<td colspan="2" class="icmal_border_last_td_without_top">
											<cfif icmal_type is not "personal">
												<b><cf_get_lang dictionary_id="53770.Kişi Sayısı">:</b>#kisi_say#
											<cfelse>
												<cfset attributes.branch_id = GET_PUANTAJ_PERSONAL.branch_id>
												<cfif x_get_sgkno eq 1><cf_get_lang dictionary_id="53237.SGK No">:#GET_PUANTAJ_PERSONAL.SOCIALSECURITY_NO#<br/></cfif>
												<cf_get_lang dictionary_id='54265.TC No'>:#GET_PUANTAJ_PERSONAL.tc_identy_no#
												<cfif x_get_groupdate eq 1>&nbsp;<cf_get_lang dictionary_id='53704.Gruba Giriş'>:#dateformat(GROUP_STARTDATE,dateformat_style)#</cfif><br/>
												<cfif x_get_kidemdate eq 1><cf_get_lang dictionary_id='53641.Kıdem Baz Tarihi'>:#dateformat(KIDEM_DATE,dateformat_style)#</cfif><br/>
												<cf_get_lang dictionary_id="53702.İşe Giriş">:#dateformat(GET_PUANTAJ_PERSONAL.START_DATE,dateformat_style)#
												<cfif len(GET_PUANTAJ_PERSONAL.FINISH_DATE) and (month(FINISH_DATE) eq attributes.sal_mon and year(FINISH_DATE) eq attributes.sal_year)>- <cf_get_lang dictionary_id="57431.Çıkış">:#dateformat(GET_PUANTAJ_PERSONAL.FINISH_DATE,dateformat_style)#</cfif>
											</cfif>
										</td>
									</tr>
								</cfoutput>
								<tr>
									<td width="25%" valign="top" class="icmal_border_without_top">
										<table width="100%" cellspacing="0" cellpadding="0" align="center">
											<tr class="txtbold">
												<td class="icmal_border_last_td"><cf_get_lang dictionary_id="53777.Kazançlar"></td>
												<cfif is_day_info neq 1>
													<td class="icmal_border_last_td"><cf_get_lang dictionary_id="57490.Gün"></td>
												</cfif>
												<cfif is_day_info neq 0>
													<td class="icmal_border_last_td"><cf_get_lang dictionary_id="57491.saat"></td>
												</cfif>
												<td class="icmal_border_last_td"><cf_get_lang dictionary_id="57673.Tutar"></td>
											</tr>
											<cfif icmal_type is "personal">
												<cfif gross_net eq 1>
													<cfquery name="get_kisi_maas" datasource="#dsn#">
														SELECT M#int(attributes.sal_mon)# AS AY_MAAS FROM #maas_puantaj_table# WHERE PERIOD_YEAR = #attributes.sal_year# AND IN_OUT_ID = #in_out_id#
													</cfquery>
												</cfif>
												<cfoutput>
													<tr>
														<td class="icmal_border_without_top"><cfif salary_type eq 1><cf_get_lang dictionary_id="58457.Günlük"><cfelseif salary_type eq 0><cf_get_lang dictionary_id="53260.Saatlik"></cfif> <cfif gross_net eq 1><cf_get_lang dictionary_id="58083.Net"><cfelse><cf_get_lang dictionary_id="53131.Brüt"></cfif><cf_get_lang dictionary_id="53127.Ücret"> (#money#)</td>
														<cfif is_day_info eq 2>
															<td class="icmal_border_without_top">&nbsp;</td>
														</cfif>
														<td class="icmal_border_without_top">&nbsp;</td>
														<cfif gross_net neq 1>
															<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(salary)#</td>
														<cfelse>
															<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(get_kisi_maas.AY_MAAS)#</td>
														</cfif>
													</tr>
												</cfoutput>
											</cfif>
											<cfoutput>
											<tr>
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id="53014.Normal Gün"></td>
												<cfif is_day_info neq 1>
													<td class="icmal_border_without_top" style="text-align:right"><cfif isDefined("ssk_days") and len(ssk_days) and ssk_days eq 0>#int(ssk_days)#<cfelse>#int(t_normal_gun)#</cfif></td>
												</cfif>
												<cfif is_day_info neq 0>
													<td class="icmal_border_without_top" style="text-align:right"><cfif isDefined("ssk_days") and len(ssk_days) and ssk_days eq 0>0<cfelse>#t_normal_hours#</cfif></td>
												</cfif>
												<td class="icmal_border_last_td_without_top" style="text-align:right"><cfif t_normal_amount lt 0>#TLFormat(0)#<cfelse>#TLFormat(t_normal_amount)#</cfif></td>
											</tr>
											<cfif x_Akdi_Gun eq 1>
												<tr>
													<td class="icmal_border_without_top"><cf_get_lang dictionary_id='65397.Akdi Gün'></td>
													<cfif is_day_info neq 1>
														<td class="icmal_border_without_top" style="text-align:right">#t_akdi_tatil#</td>
													</cfif>
													<cfif is_day_info neq 0>
														<td class="icmal_border_without_top" style="text-align:right">#t_akdi_tatil_hours#</td>
													</cfif>
													<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_akdi_tatil_amount)#</td>
												</tr>
											</cfif>
											<tr>
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id="58956.Haftalık Tatil"></td>
												<cfif is_day_info neq 1>
													<td class="icmal_border_without_top" style="text-align:right">#t_haftalik_tatil#</td>
												</cfif>
												<cfif is_day_info neq 0>
													<td class="icmal_border_without_top" style="text-align:right">#t_haftalik_tatil_hours#</td>
												</cfif>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_haftalik_tatil_amount)#</td>
											</tr>
											<cfif t_offdays gt 0>
												<tr>
													<td class="icmal_border_without_top"><cf_get_lang dictionary_id="29482.Genel Tatil"></td>
													<cfif is_day_info neq 1>
														<td class="icmal_border_without_top" style="text-align:right">#ceiling(t_offdays)#</td>
													</cfif>
													<cfif is_day_info neq 0>
														<td class="icmal_border_without_top" style="text-align:right">#t_offdays_hours#</td>
													</cfif>
													<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_offdays_amount)#</td>
												</tr>
											</cfif>
											<cfif x_Offtime_Detail eq 1>
												<cfloop query="TBI_get_izins_Ucretsiz">
													<cfif t_izin neq 0 or t_izin_hours neq 0>
														 <tr>
															 <td class="icmal_border_without_top">#TBI_get_izins_Ucretsiz.IZIN#</td>
															<cfif is_day_info neq 1>
															  <td class="icmal_border_without_top" style="text-align:right">#TBI_get_izins_Ucretsiz.Gun#</td>
															</cfif>
															<cfif is_day_info neq 0>
																<td class="icmal_border_without_top" style="text-align:right"></td>
															</cfif>
															<cfif attributes.fuseaction neq "ehesap.list_icmal">
																<td class="icmal_border_last_td_without_top" style="text-align:right"></td>
															</cfif>
														 </tr>
													</cfif>
												</cfloop>    
                                                <cfloop query="TBI_get_izins_Ucretli">
                                                    <cfif t_paid_izin gt 0>
														<tr>
															<td class="icmal_border_without_top">#TBI_get_izins_Ucretli.IZIN#</td>
															<cfif is_day_info neq 1>
																<td class="icmal_border_without_top" style="text-align:right">#TBI_get_izins_Ucretli.Gun#</td>
															</cfif>
															<cfif is_day_info neq 0>
																<td class="icmal_border_without_top" style="text-align:right">#t_paid_izin_hours#</td>
															</cfif>
															<cfif attributes.fuseaction neq "ehesap.list_icmal">
																<td class="icmal_border_last_td_without_top" style="text-align:right"><cfif #TBI_salary_type# eq 2>#TLFormat(TBI_get_izins_Ucretli.Gun*(TBI_salary/30))#<cfelseif #TBI_salary_type# eq 1>#TLFormat(TBI_get_izins_Ucretli.Gun*(TBI_salary))#</cfif></td>
															</cfif>
														</tr>
													</cfif>                                                
												</cfloop>
												<cfloop query="TBI_get_izins_UcretliHS">
													<cfif t_paid_izinli_sundays gt 0>
														<tr>
															<td class="icmal_border_without_top">#TBI_get_izins_UcretliHS.IZIN#</td>
															<cfif is_day_info neq 1>
																<td class="icmal_border_without_top" style="text-align:right">#TBI_get_izins_UcretliHS.Gun#</td>
															</cfif>
															<cfif is_day_info neq 0>
																<td class="icmal_border_without_top" style="text-align:right">#t_paid_izinli_sundays_hours#</td>
															</cfif>
															<td class="icmal_border_last_td_without_top" style="text-align:right"><cfif #TBI_salary_type# eq 2>#TLFormat(TBI_get_izins_UcretliHS.Gun*(TBI_salary/30))#<cfelseif #TBI_salary_type# eq 1>#TLFormat(TBI_get_izins_UcretliHS.Gun*(TBI_salary))#</cfif></td>
																
														</tr>
														
													</cfif>
												</cfloop>
											<cfelse>
												<tr>
												<cfif t_izin neq 0 or t_izin_hours neq 0>
													<tr>
														<td class="icmal_border_without_top"><cf_get_lang dictionary_id="53688.Ücretsiz İzin"></td>
														<cfif is_day_info neq 1>
															<td class="icmal_border_without_top" style="text-align:right">#ceiling(t_izin)#</td>
														</cfif>
														<cfif is_day_info neq 0>
															<td class="icmal_border_without_top" style="text-align:right">#t_izin_hours#</td>
														</cfif>
														<td class="icmal_border_last_td_without_top" style="text-align:right"><cfif t_normal_amount lt 0>#TLFormat(0)#<cfelse>#TLFormat(t_izin_amount)#</cfif></td>
													</tr>
												</cfif>
												<cfif t_paid_izin gt 0>
													<tr>
														<td class="icmal_border_without_top"><cf_get_lang dictionary_id="53686.Ücretli İzin"></td>
														<cfif is_day_info neq 1>
															<td class="icmal_border_without_top" style="text-align:right">#t_paid_izin#</td>
														</cfif>
														<cfif is_day_info neq 0>
															<td class="icmal_border_without_top" style="text-align:right">#t_paid_izin_hours#</td>
														</cfif>
														<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_izin_paid_amount)#</td>
													</tr>
												</cfif>
												<cfif t_paid_izinli_sundays gt 0>
													<tr>
														<td class="icmal_border_without_top"><cf_get_lang dictionary_id="53778.Ücretli İzin HT"></td>
														<cfif is_day_info neq 1>
															<td class="icmal_border_without_top" style="text-align:right">#t_paid_izinli_sundays#</td>
														</cfif>
														<cfif is_day_info neq 0>
															<td class="icmal_border_without_top" style="text-align:right">#t_paid_izinli_sundays_hours#</td>
														</cfif>
														<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_izin_paid_amount_ht)#</td>
													</tr>	
												</cfif>
											</cfif>
											<tr class="txtbold">
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id="53815.Toplam Çalışma"></td>
												<cfif is_day_info neq 1>
													<td class="icmal_border_without_top" style="text-align:right"><cfif isDefined("ssk_days") and len(ssk_days) and ssk_days eq 0>#ssk_days#<cfelse>#TLFormat(int(t_normal_gun+t_haftalik_tatil+t_offdays+t_paid_izin+t_paid_izinli_sundays+t_akdi_tatil))#</cfif></td>
												</cfif>
												<cfif is_day_info neq 0>
													<td class="icmal_border_without_top" style="text-align:right"><cfif isDefined("ssk_days") and len(ssk_days) and ssk_days eq 0>#ssk_days#<cfelse>#TLFormat(t_normal_hours+t_haftalik_tatil_hours+t_offdays_hours+t_paid_izin_hours+t_paid_izinli_sundays_hours+t_akdi_tatil_hours)#</cfif></td>
												</cfif>
												<td class="icmal_border_last_td_without_top" style="text-align:right"><cfif t_normal_amount lt 0>#TLFormat(0)#<cfelse>#TLFormat(t_normal_amount+t_haftalik_tatil_amount+t_offdays_amount+t_izin_paid_amount+t_izin_paid_amount_ht+t_akdi_tatil_amount)#</cfif></td>
											</tr>
											<cfif t_kidem_amount gt 0>
												<tr>
													<td class="icmal_border_without_top"><cf_get_lang dictionary_id="52991.Kıdem Tazminatı"></td>
													<cfif is_day_info neq 1>
														<td class="icmal_border_without_top" style="text-align:right">&nbsp;</td>
													</cfif>
													<cfif is_day_info neq 0>
														<td class="icmal_border_without_top" style="text-align:right">&nbsp;</td>
													</cfif>
													<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_kidem_amount)#</td>
												</tr>
											</cfif>
											<cfif t_ihbar_amount gt 0>
												<tr>
													<td class="icmal_border_without_top"><cf_get_lang dictionary_id="52992.İhbar Tazminatı"></td>
													<cfif is_day_info neq 1>
														<td class="icmal_border_without_top" style="text-align:right">&nbsp;</td>
													</cfif>
													<cfif is_day_info neq 0>
														<td class="icmal_border_without_top" style="text-align:right">&nbsp;</td>
													</cfif>
													<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_ihbar_amount)#</td>
												</tr>
											</cfif>
											<cfif t_yillik_izin_amount gt 0>
												<tr>
													<td class="icmal_border_without_top"><cf_get_lang dictionary_id="53393.Yıllık İzin Tutarı"></td>
													<cfif is_day_info neq 1>
														<td class="icmal_border_without_top" style="text-align:right">&nbsp;</td>
													</cfif>
													<cfif is_day_info neq 0>
														<td class="icmal_border_without_top" style="text-align:right">&nbsp;</td>
													</cfif>
													<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_yillik_izin_amount)#</td>
												</tr>
											</cfif>
											</cfoutput>
											<!--- kazanc tipli odenekler kazanclar bolumunda gosterilecek SG20140129 --->
											<cfset odenek_say = 0>
											<cfquery name="get_odeneks_kazanc" dbtype="query">
												SELECT * FROM get_odeneks WHERE COMMENT_TYPE =2 <cfif icmal_type is not 'genel'>AND EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_puantaj_id#"></cfif>
											</cfquery>
											<cfoutput query="get_odeneks_kazanc" group="COMMENT_PAY">
												<cfquery name="get_odenek_say" dbtype="query">
													SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_odeneks_kazanc WHERE COMMENT_PAY = '#comment_pay#'
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
													<td class="icmal_border_without_top">#comment_pay# <cfif icmal_type is 'genel'>(#odenek_say#)</cfif></td>
													<td class="icmal_border_without_top">&nbsp;</td>
													<td class="icmal_border_without_top" style="text-align:right">#TLFormat(tmp_total)# <cfif is_view_net eq 1>(#TLFormat(amount_pay_total)#)</cfif></td>
													<!---<cfif is_view_net eq 1>
														<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(amount_pay_total)#</td>
													</cfif>--->
												</tr>
											</cfoutput>
											<cfoutput>
											<tr class="txtbold">
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id="52970.Fazla Mesailer"></td>
												<cfif is_day_info eq 2>
													<td class="icmal_border_without_top" style="text-align:right"></td>
												</cfif>
												<td class="icmal_border_without_top">
													<cfif x_view_ext_workday eq 0>
														<cf_get_lang dictionary_id="57491.Saat">
													<cfelse>
														<cf_get_lang dictionary_id='57490.Gün'>
													</cfif>
												</td>
												<td class="icmal_border_last_td_without_top"><cf_get_lang dictionary_id="57673.Tutar"></td>
											</tr>
											<tr>
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id="53822.FMesai (Normal)"> <cfif icmal_type eq 'genel'>(#fmesai_sayac_1#)</cfif></td>
												<cfif is_day_info eq 2>
													<td class="icmal_border_without_top" style="text-align:right"></td>
												</cfif>
												<td class="icmal_border_without_top" style="text-align:right">
													<cfif x_view_ext_workday eq 0>
														#t_ext_work_hours_0#
													<cfelseif x_view_ext_workday eq 1 and t_ext_work_hours_0 gt 0>
														#wrk_round(t_ext_work_hours_0/daily_workhour)#
													<cfelse>
														0
													</cfif>
												</td>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_ext_salary_0)#</td>
											</tr>
											<tr>
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id="53831.FMesai (HTatili)"> <cfif icmal_type eq 'genel'>(#fmesai_sayac_2#)</cfif></td>
												<cfif is_day_info eq 2>
													<td class="icmal_border_without_top" style="text-align:right"></td>
												</cfif>
												<td class="icmal_border_without_top" style="text-align:right">
													<cfif x_view_ext_workday eq 0>
														#t_ext_work_hours_1#
													<cfelseif x_view_ext_workday eq 1 and t_ext_work_hours_1 gt 0>
														#wrk_round(t_ext_work_hours_1/daily_workhour)#
													<cfelse>
														0
													</cfif>
												</td>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_ext_salary_1)#</td>
											</tr>
											<tr>
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id="53834.FMesai (GTatil)"> <cfif icmal_type eq 'genel'>(#fmesai_sayac_3#)</cfif></td>
												<cfif is_day_info eq 2>
													<td class="icmal_border_without_top" style="text-align:right"></td>
												</cfif>
												<td class="icmal_border_without_top" style="text-align:right">
													<cfif x_view_ext_workday eq 0>
														#t_ext_work_hours_2#
													<cfelseif x_view_ext_workday eq 1 and t_ext_work_hours_2 gt 0>
														#wrk_round(t_ext_work_hours_2/daily_workhour)#
													<cfelse>
														0
													</cfif>
												</td>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_ext_salary_2)#</td>
											</tr>
											<cfif isdefined("x_night_work") and x_night_work>
												<tr>
													<td class="icmal_border_without_top"><cf_get_lang dictionary_id="54251.Gece Çalışması"> <cfif icmal_type eq 'genel'>(#fmesai_sayac_3#)</cfif></td>
													<cfif is_day_info eq 2>
														<td class="icmal_border_without_top" style="text-align:right"></td>
													</cfif>
													<td class="icmal_border_without_top" style="text-align:right">
														<cfif x_view_ext_workday eq 0>
															#t_ext_work_hours_5#
														<cfelseif x_view_ext_workday eq 1 and t_ext_work_hours_5 gt 0>
															#wrk_round(t_ext_work_hours_5/daily_workhour)#
														<cfelse>
															0
														</cfif>
													</td>
													<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_ext_salary_5)#</td>
												</tr>
											</cfif>

											<cfif isdefined("x_weekly_day_work") and x_weekly_day_work gt 0>
												<tr>
													<td class="icmal_border_without_top"><cf_get_lang dictionary_id='65398.F.Mesai (H.Tatili - Gün)'><cfif icmal_type eq 'genel'>(#fmesai_sayac_8#)</cfif></td>
													<cfif is_day_info eq 2>
														<td class="icmal_border_without_top" style="text-align:right">#wrk_round(t_ext_work_hours_8/temptaily_hour)#</td>
													</cfif>
													<td class="icmal_border_without_top" style="text-align:right">
														<cfif x_view_ext_workday eq 0>
															#t_ext_work_hours_8#
														<cfelseif x_view_ext_workday eq 1 and t_ext_work_hours_8 gt 0>
															#wrk_round(t_ext_work_hours_8/daily_workhour)#
														<cfelse>
															0
														</cfif>
													</td>
													<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_ext_salary_8)#</td>
												</tr>
											</cfif>

											<cfif isdefined("x_akdi_day_work") and x_akdi_day_work gt 0>
												<tr>
													<td class="icmal_border_without_top"><cf_get_lang dictionary_id='65399.F.Mesai (Akdi Tatil - Gün)'><cfif icmal_type eq 'genel'>(#fmesai_sayac_9#)</cfif></td>
													<cfif is_day_info eq 2>
														<td class="icmal_border_without_top" style="text-align:right">#wrk_round(t_ext_work_hours_9/temptaily_hour)#</td>
													</cfif>
													<td class="icmal_border_without_top" style="text-align:right">
														<cfif x_view_ext_workday eq 0>
															#t_ext_work_hours_9#
														<cfelseif x_view_ext_workday eq 1 and t_ext_work_hours_9 gt 0>
															#wrk_round(t_ext_work_hours_9/daily_workhour)#
														<cfelse>
															0
														</cfif>
													</td>
													<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_ext_salary_9)#</td>
												</tr>
											</cfif>

											<cfif isdefined("x_official_day_work") and x_official_day_work gt 0>
												<tr>
													<td class="icmal_border_without_top"><cf_get_lang dictionary_id='65400.F.Mesai (Resmi Tatil - Gün)'><cfif icmal_type eq 'genel'>(#fmesai_sayac_10#)</cfif></td>
													<cfif is_day_info eq 2>
														<td class="icmal_border_without_top" style="text-align:right">#wrk_round(t_ext_work_hours_10/temptaily_hour)#</td>
													</cfif>
													<td class="icmal_border_without_top" style="text-align:right">
														<cfif x_view_ext_workday eq 0>
															#t_ext_work_hours_10#
														<cfelseif x_view_ext_workday eq 1 and t_ext_work_hours_10 gt 0>
															#wrk_round(t_ext_work_hours_10/daily_workhour)#
														<cfelse>
															0
														</cfif>
													</td>
													<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_ext_salary_10)#</td>
												</tr>
											</cfif>

											<cfif isdefined("x_Arefe_day_work") and x_Arefe_day_work gt 0>
												<tr>
													<td class="icmal_border_without_top"><cf_get_lang dictionary_id='65401.F.Mesai(Arefe Tatil - Gün)'><cfif icmal_type eq 'genel'>(#fmesai_sayac_11#)</cfif></td>
													<cfif is_day_info eq 2>
														<td class="icmal_border_without_top" style="text-align:right">#wrk_round(t_ext_work_hours_11/temptaily_hour)#</td>
													</cfif>
													<td class="icmal_border_without_top" style="text-align:right">
														<cfif x_view_ext_workday eq 0>
															#t_ext_work_hours_11#
														<cfelseif x_view_ext_workday eq 1 and t_ext_work_hours_11 gt 0>
															#wrk_round(t_ext_work_hours_11/daily_workhour)#
														<cfelse>
															0
														</cfif>
													</td>
													<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_ext_salary_11)#</td>
												</tr>
											</cfif>

											<cfif isdefined("x_Dini_day_work") and x_Dini_day_work gt 0>
												<tr>
													<td class="icmal_border_without_top"><cf_get_lang dictionary_id='65402.DF.Mesai (Dini Tatil - Gün)'><cfif icmal_type eq 'genel'>(#fmesai_sayac_12#)</cfif></td>
													<cfif is_day_info eq 2>
														<td class="icmal_border_without_top" style="text-align:right">#wrk_round(t_ext_work_hours_12/temptaily_hour)#</td>
													</cfif>
													<td class="icmal_border_without_top" style="text-align:right">
														<cfif x_view_ext_workday eq 0>
															#t_ext_work_hours_12#
														<cfelseif x_view_ext_workday eq 1 and t_ext_work_hours_12 gt 0>
															#wrk_round(t_ext_work_hours_12/daily_workhour)#
														<cfelse>
															0
														</cfif>
													</td>
													<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_ext_salary_12)#</td>
												</tr>
											</cfif>

											<tr class="txtbold">
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id="53836.FMesai (Toplam)"></td>
												<cfif is_day_info eq 2>
													<td class="icmal_border_without_top" style="text-align:right"></td>
												</cfif>
												<td class="icmal_border_without_top" style="text-align:right">
													<cfif x_view_ext_workday eq 0>
														#wrk_round(t_ext_work_hours_0 + t_ext_work_hours_1 + t_ext_work_hours_2 + t_ext_work_hours_5 + t_ext_work_hours_8 + t_ext_work_hours_9+ t_ext_work_hours_10 + t_ext_work_hours_11 + t_ext_work_hours_12,2)#
													<cfelseif x_view_ext_workday eq 1 and t_ext_work_hours_0 + t_ext_work_hours_1 + t_ext_work_hours_2 + t_ext_work_hours_5 + t_ext_work_hours_5 + t_ext_work_hours_8 + t_ext_work_hours_9+ t_ext_work_hours_10 + t_ext_work_hours_11 + t_ext_work_hours_12 gt 0>
														#wrk_round((t_ext_work_hours_0 + t_ext_work_hours_1 + t_ext_work_hours_2 + t_ext_work_hours_5 + t_ext_work_hours_8 + t_ext_work_hours_9+ t_ext_work_hours_10 + t_ext_work_hours_11 + t_ext_work_hours_12)/daily_workhour)#
													<cfelse>
														0
													</cfif>
												</td>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_ext_Salary)#</td>
											</tr>
											<cfif is_view_net eq 1>
											<tr class="txtbold">
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id="53836.FMesai (Toplam)"> <cf_get_lang dictionary_id='58083.Net'></td>
												<cfif is_day_info eq 2>
													<td class="icmal_border_without_top" style="text-align:right"></td>
												</cfif>
												<td class="icmal_border_without_top" style="text-align:right"></td>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_ext_Salary_net)#</td>
											</tr>
											</cfif>
										</cfoutput>
										</table>
									</td>
									<td width="25%" valign="top" class="icmal_border_without_top">
										<table width="100%" cellspacing="0" cellpadding="0" align="center">
											<tr class="txtbold">
												<td class="icmal_border_last_td"><cf_get_lang dictionary_id="53837.Ücret Dışı Ödemeler"></td>
												<td class="icmal_border_last_td" style="text-align:right"><cf_get_lang dictionary_id="57673.Tutar"></td>
												<cfif is_view_net eq 1>
													<td class="icmal_border_last_td" style="text-align:right"><cf_get_lang dictionary_id="57673.Tutar"> <cf_get_lang dictionary_id='58083.Net'></td>
												</cfif>
											</tr>
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
														<td class="icmal_border_without_top">#comment_pay#</td>
														<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(tmp_total)#</td>
														<cfif is_view_net eq 1>
															<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(tmp_total2)#</td>
														</cfif>
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
													<td class="icmal_border_without_top">#comment_pay# <cfif icmal_type is 'genel'>(#odenek_say#)</cfif></td>
													<td class="icmal_border_without_top" style="text-align:right">#TLFormat(tmp_total)#</td>
													<cfif is_view_net eq 1>
														<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(amount_pay_total)#</td>
													</cfif>
												</tr>
												<cfif not (len(is_income) and is_income eq 1)>
													<cfset genel_odenek_total = genel_odenek_total + tmp_total>
													<cfset genel_odenek_total_net = genel_odenek_total_net + amount_pay_total>
												</cfif>
											</cfoutput>
										</table>
									</td>
									<td width="25%" valign="top" class="icmal_border_without_top">
										<table width="100%" cellspacing="0" cellpadding="0" align="center">
											<tr class="txtbold">
												<td class="icmal_border_last_td"><cf_get_lang dictionary_id="53273.Kesintiler"></td>
												<td class="icmal_border_last_td"><cf_get_lang dictionary_id="57673.Tutar"></td>
											</tr>
											<cfset t_istisna_kesinti = 0>
											<cfoutput query="get_vergi_istisnas" group="COMMENT_PAY">
												<cfset tmp_total = 0>
												<cfoutput><!--- 20040824 ellemeyin yanlis kullanim degil --->
													<cfif len(VERGI_ISTISNA_TOTAL)>
														<cfset tmp_total = tmp_total + VERGI_ISTISNA_TOTAL>
														<cfset t_istisna_kesinti = t_istisna_kesinti + VERGI_ISTISNA_TOTAL>
													</cfif>
												</cfoutput>
												<cfif tmp_total gt 0>
													<tr>
														<td class="icmal_border_without_top">#comment_pay#</td>
														<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(tmp_total)#</td>
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
													<td class="icmal_border_without_top">#comment_pay# <cfif icmal_type is 'genel'>(#say_kesinti_kisi#)</cfif></td>
													<td class="icmal_border_last_td_without_top" style="text-align:right"><cfif comment_pay is 'Avans' and t_avans gt 0>#TLFormat(tmp_total + t_avans)#<cfset is_avans_ = 1><cfelse>#TLFormat(tmp_total)#</cfif></td>
												</tr>
												<cfif t_avans gt 0 and not isdefined("is_avans_")>
													<tr>
														<td class="icmal_border_without_top"><cf_get_lang dictionary_id="58204.Avans"></td>
														<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_avans)#</td>
													</tr>
												</cfif>
											</cfoutput>
												<cfif t_ozel_kesinti_2 gt 0>
													<tr class="txtbold">
														<td class="icmal_border_last_td"><b><cf_get_lang dictionary_id='63501.Brüt Kesintiler'></b></td>
														<td class="icmal_border_last_td"><cf_get_lang dictionary_id="57673.Tutar"></td>
													</tr>
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
															<td class="icmal_border_without_top">#comment_pay# <cfif icmal_type is 'genel'>(#say_kesinti_kisi#)</cfif></td>
															<td class="icmal_border_last_td_without_top" style="text-align:right"><cfif comment_pay is 'Avans' and t_avans gt 0>#TLFormat(tmp_total + t_avans)#<cfset is_avans_ = 1><cfelse>#TLFormat(tmp_total)#</cfif></td>
														</tr>												
													</cfoutput>
													<tr>	
														<td class="icmal_border_without_top"><cf_get_lang dictionary_id='63456.Toplam Brüt Kesinti Neti'></td>
														<td class="icmal_border_last_td_without_top" style="text-align:right"><cfoutput>#TLFormat(t_ozel_kesinti_2_net)#</cfoutput></td>
													</tr>
												</cfif>	
										</table>
									</td>
									<td width="25%" valign="top" class="icmal_border_last_td_without_top">
										<table width="100%" cellspacing="0" cellpadding="0" align="center">
											<tr class="txtbold">
												<td class="icmal_border_last_td"><cf_get_lang dictionary_id='53838.Vergi Muafiyetleri'></td>
												<td class="icmal_border_last_td"><cf_get_lang dictionary_id='57673.Tutar'></td>
											</tr>
											<cfset t_istisna = 0>
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
													<td class="icmal_border_without_top">#comment_pay#</td>
													<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(tmp_total)#</td>
												</tr>
											</cfoutput>
										</table>
									</td>
								</tr>
								<cfoutput>
									<tr class="txtbold">
										<td valign="top" class="icmal_border_without_top">
											<table width="99%" cellpadding="0" cellspacing="0">
												<tr>
													<td><cf_get_lang dictionary_id='57492.TOPLAM'></td>
													<cfif is_day_info eq 2>
														<td>&nbsp;</td>
													</cfif>
													<td style="text-align:right">#TLFormat(t_toplam_kazanc-genel_odenek_total+t_istisna_odenek+t_ozel_kesinti_2)#</td>
												</tr>
											</table>
										</td>
										<td valign="top" class="icmal_border_without_top">
											<table width="100%" cellpadding="0" cellspacing="0">
												<tr>
													<td><cf_get_lang dictionary_id='57492.TOPLAM'></td>
													<td style="text-align:right">#TLFormat(genel_odenek_total)#</td>
													<cfif is_view_net eq 1>
														<td style="text-align:right">#TLFormat(genel_odenek_total_net)#</td>
													</cfif>
												</tr>
											</table>
										</td>
										<td valign="top" class="icmal_border_without_top">
											<table width="100%" cellpadding="0" cellspacing="0">
												<tr>
													<td><cf_get_lang dictionary_id='57492.TOPLAM'></td>
													<td style="text-align:right">#TLFormat(t_avans+t_ozel_kesinti_2_net+t_ozel_kesinti+t_vergi_istisna_net_yaz)#</td>
												</tr>
											</table>
										</td>
										<td valign="top" class="icmal_border_last_td_without_top">
											<table width="100%" cellpadding="0" cellspacing="0">
												<tr>
													<td><cf_get_lang dictionary_id='57492.TOPLAM'></td>
													<td style="text-align:right">#TLFormat(t_istisna)#</td>
												</tr>
											</table>
										</td>
									</tr>
								</cfoutput>
								<cfoutput>
									<tr>
										<td class="icmal_border_last_td" width="35%"><cf_get_lang dictionary_id='58714.SGK'> <cf_get_lang dictionary_id='53014.Normal Gün'></td>
										<td class="icmal_border_last_td" width="15%" nowrap style="text-align:right">#t_reel_ssk_days #</td>
										<td class="icmal_border_last_td" width="35%"><cf_get_lang dictionary_id='54283.İşsizlik Sigortası Matrahı'></td>
										<td class="icmal_border_last_td" width="15%" style="text-align:right">#TLFormat(t_ssk_matrahi)#</td>
									</tr>
									<cfif len(t_short_working_calc) and t_short_working_calc gt 0>
										<tr>
											<td class="icmal_border_without_top"><cf_get_lang dictionary_id='65220.Kısa Çalışma Ödeneği SGK Matrahı'></td>
											<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_short_working_calc)#</td>
											<td></td>
											<td></td>
										</tr>
									</cfif>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53245.SGK Matrahı'> (#ssk_say#)</td>
										<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_ssk_matrahi)#</td>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54275.İşsizlik Sigortası İşçi'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_issizlik_isci_hissesi)#</td>
									</tr>
									<cfif (isdefined("x_view_ssk_detail") and x_view_ssk_detail eq 1)>
										<cfquery name="get_insurance_ratio" datasource="#dsn#">
											SELECT
												MOM_INSURANCE_PREMIUM_WORKER, MOM_INSURANCE_PREMIUM_BOSS, 
												PAT_INS_PREMIUM_WORKER, PAT_INS_PREMIUM_BOSS, 
												PAT_INS_PREMIUM_WORKER_2, PAT_INS_PREMIUM_BOSS_2, 
												DEATH_INSURANCE_PREMIUM_WORKER, DEATH_INSURANCE_PREMIUM_BOSS, 
												DEATH_INSURANCE_WORKER, DEATH_INSURANCE_BOSS, 
												SOC_SEC_INSURANCE_WORKER, SOC_SEC_INSURANCE_BOSS 
											FROM 
												INSURANCE_RATIO
											WHERE 
												STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#">
										</cfquery>
										<cfif t_health_insurance_premium_worker gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='58714.SGK'> <cf_get_lang dictionary_id='53191.genel sağlık sigortası'> <cf_get_lang dictionary_id='45049.İşçi'> %#get_insurance_ratio.PAT_INS_PREMIUM_WORKER#</td>
												<td class="icmal_border_without_top" style="text-align:right">#tlformat(t_health_insurance_premium_worker)#</td>
												<td></td>
												<td></td>
											</tr>
										</cfif>
										<cfif t_death_insurance_premium_worker gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='58714.SGK'> <cf_get_lang dictionary_id='65181.Uzun Vadeli Sigorta Primi'> <cf_get_lang dictionary_id='45049.İşçi'> %#get_insurance_ratio.DEATH_INSURANCE_PREMIUM_WORKER#</td>
												<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_death_insurance_premium_worker)#</td>
												<td></td>
												<td></td>
											</tr>
										</cfif>
									<cfelse>
										<tr>
											<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53719.SGK İşçi Primi'></td>
											<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_ssk_primi_isci)#</td>
											<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53196.İşsizlik Sigortası'> <cf_get_lang dictionary_id='53550.İşveren'></td>
											<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_issizlik_isveren_hissesi)#</td>
										</tr>
									</cfif>
									<tr>
										<td class="icmal_border_without_top">
											<cfset this_devam_ = attributes.sal_mon+1>
											<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_year_end)>
												<cfset this_devam_2 = attributes.sal_mon_end+2>
											<cfelse>
												<cfset this_devam_2 = attributes.sal_mon+2>
											</cfif>
											<cfif this_devam_ gt 12>
												<cfset this_devam_ = this_devam_ - 12>
											</cfif>
											<cfif this_devam_2 gt 12>
												<cfset this_devam_2 = this_devam_2 - 12>
											</cfif>
											#listgetat(ay_list(),this_devam_)# - #listgetat(ay_list(),this_devam_2)# Dev. <cf_get_lang dictionary_id='53245.SGK Matrahı'>
										</td>
										<td class="icmal_border_without_top" style="text-align:right">#tlformat(t_devreden)#</td>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='53196.Toplam İşsizlik Sigortası'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_issizlik_isveren_hissesi+t_issizlik_isci_hissesi-t_issizlik_primi_687-t_issizlik_primi_7103)#</td>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54267.Önceki Ayd Dev SGK Matrahı'></td>
										<td class="icmal_border_without_top" style="text-align:right"><cfif t_ssk_transfer_amount gt 0>#tlformat(t_ssk_transfer_amount)#<cfelse>#tlformat(t_devirden_gelen)#</cfif></td>
										<td class="icmal_border_last_td_without_top" colspan="2"><strong><cf_get_lang dictionary_id='53777.Kazançlar'> <cf_get_lang dictionary_id='57989.ve'> <cf_get_lang dictionary_id='53273.Kesintiler'></strong></td>
									</tr>
									<cfif (isdefined("x_view_ssk_detail") and x_view_ssk_detail eq 1)>
										<cfif t_health_insurance_premium_employer gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='58714.SGK'> <cf_get_lang dictionary_id='53191.genel sağlık sigortası'> <cf_get_lang dictionary_id='56406.İşveren'> %#get_insurance_ratio.PAT_INS_PREMIUM_BOSS#</td>
												<td class="icmal_border_without_top" style="text-align:right">#tlformat(t_health_insurance_premium_employer)#</td>
												<td></td>
												<td></td>
											</tr>
										</cfif>
										<cfif t_death_insurance_premium_employer gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='58714.SGK'> <cf_get_lang dictionary_id='65181.Uzun Vadeli Sigorta Primi'> <cf_get_lang dictionary_id='56406.İşveren'> %#get_insurance_ratio.death_insurance_premium_boss#</td>
												<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_death_insurance_premium_employer)#</td>
												<td></td>
												<td></td>
											</tr>
										</cfif>
										<cfif t_short_term_premium_employer gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='58714.SGK'> <cf_get_lang dictionary_id='65166.Kısa Vadeli Sigorta Primi'> %#GET_PUANTAJ_PERSONAL.DANGER_DEGREE_NO#</td>
												<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_short_term_premium_employer)#</td>
												<td></td>
												<td></td>
											</tr>
										</cfif>
									<cfelse>
										<tr>
											<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53698.SGK İşveren Primi Hesaplanan'></td>
											<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_ssk_primi_isveren_hesaplanan)#</td>
											<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54277.SGK Devir Isci Hissesi Fark'></td>
											<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_ssk_primi_isci - t_ssk_primi_isci_devirsiz)#</td>
										</tr>
									</cfif>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54271.İndirimli'> <cf_get_lang dictionary_id='53256.SGK İşveren Primi'></td>
										<cfset new_value = wrk_round(t_ssk_primi_isveren - t_ssk_primi_isveren_gov - t_ssk_primi_isveren_5921 - t_ssk_primi_isveren_5746 - t_ssk_primi_isveren_4691 - t_ssk_primi_isveren_6111 - t_ssk_primi_isveren_6486 - t_ssk_primi_isveren_6322 - t_ssk_primi_isveren_25510 - t_ssk_primi_isveren_14857 - t_ssk_isveren_hissesi_3294 - t_ssk_primi_isveren_6645 - t_ssk_primi_isveren_46486 - t_ssk_primi_isveren_56486 - t_ssk_primi_isveren_66486 - t_isveren_primi_687- t_isveren_primi_7103 - t_ssk_isveren_hissesi_7252 - t_ssk_isveren_hissesi_7256,8)>
										<cfif new_value lt 0><cfset new_value = 0></cfif>
										<td class="icmal_border_without_top" style="text-align:right">#TLFormat(new_value)#</td>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54280.SGK Devir Issizlik Hissesi Fark'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_issizlik_isci_hissesi - t_issizlik_isci_hissesi_devirsiz)#</td>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id = "54271.İndirimli"> <cf_get_lang dictionary_id='53719.SGK İşçi Primi'></td>
										<td class="icmal_border_without_top" style="text-align:right"><cfif t_isci_primi_indirimli gt 0>#TLFormat(t_isci_primi_indirimli)#<cfelse>#TLFormat(0)#</cfif></td>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54302.SGDP İşçi Primi Fark'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#tlformat(t_sgdp_devir)#</td>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54304.Ödenecek Toplam SGK Primi'></td>
										<cfset new_value_2 = wrk_round((t_ssk_primi_isveren - t_ssk_primi_isveren_gov - t_ssk_primi_isveren_5921 - t_ssk_primi_isveren_5746 - t_ssk_primi_isveren_4691 - t_ssk_primi_isveren_6111-t_ssk_primi_isveren_6486-(wrk_round(t_ssk_primi_isveren_6322+t_ssk_primi_isci_6322))-t_ssk_primi_isveren_25510-t_ssk_primi_isveren_14857-t_ssk_isveren_hissesi_3294-t_ssk_primi_isveren_6645 - t_ssk_primi_isveren_46486 - t_ssk_primi_isveren_56486 - t_ssk_primi_isveren_66486) + t_ssk_primi_isci - t_ssk_primi_687- (t_ssk_primi_7103) - t_ssk_primi_7252 - t_ssk_primi_7256,8)>
										<cfif new_value_2 lt 0><cfset new_value_2 = 0></cfif>
										<td class="icmal_border_without_top" style="text-align:right">#TLFormat(new_value_2)#</td>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54286.SGK Matrah Muafiyeti'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#tlformat(t_ssk_matrah_muafiyet)#</td>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54305.İndirimsiz Toplam SGK Primi'></td>
										<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_ssk_primi_isci+t_ssk_primi_isveren_hesaplanan)#</td>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='59535.Otomatik BES Katılım Payı'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#tlformat(t_bes_primi_isci)#</td>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54306.SGDP Normal Gün'></td>
										<td class="icmal_border_without_top" style="text-align:right">#t_ssdf_ssk_days#</td>		
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54271.İndirimli'> <cf_get_lang dictionary_id='54275.İşsizlik Sigortası İşçi'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#tlformat(t_issizlik_isci_primi_indirimli)#</td>					
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54307.SGDP Matrahı'> (#ssdf_say#)</td>
										<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_ssdf_matrah)#</td>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54271.İndirimli'> <cf_get_lang dictionary_id='53196.İşsizlik Sigortası'> <cf_get_lang dictionary_id='53550.İşveren'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#tlformat(t_issizlik_isveren_primi_indirimli)#</td>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54308.SGDP İşçi Primi'></td>
										<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_ssdf_isci_hissesi)#</td>	
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53043.Normal'> <cf_get_lang dictionary_id='53971.Kazanç'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_toplam_kazanc-genel_odenek_total-t_ext_Salary+t_istisna_odenek)#</td>							
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54311.SGDP İşveren Primi'></td>
										<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_ssdf_isveren_hissesi)#</td>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53841.Ek'> <cf_get_lang dictionary_id='53971.Kazanç'> <cf_get_lang dictionary_id='57492.Toplam'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_ext_salary_0+t_ext_salary_1+t_ext_salary_2 + t_ext_salary_5)#</td>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54312.Toplam SGDP Primi'></td>
										<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_ssdf_isci_hissesi+t_ssdf_isveren_hissesi)#</td>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54303.Sosyal Yardımlar'> <cf_get_lang dictionary_id='57492.Toplam'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(genel_odenek_total)#</td>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54314.Gayri Safi Kazanç'></td>
										<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_toplam_kazanc-t_ssk_primi_isci-t_issizlik_isci_hissesi-t_ssdf_isci_hissesi)#</td>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='53971.Kazanç'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_toplam_kazanc+t_istisna_odenek)#</td>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54168.Sakatlık İndirimi'> (#sakat_say#)</td>
										<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_sakatlik)#</td>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53722.Toplam Yasal Kesinti'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_ssk_primi_isci + t_ssdf_isci_hissesi + t_gelir_vergisi + t_damga_vergisi + t_issizlik_isci_hissesi + t_bes_primi_isci)#</td>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54316.Diğer Muafiyet'></td>
										<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_istisna + t_vergi_matrah_muafiyet)#</td>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57979.Özel'> <cf_get_lang dictionary_id='53083.Kesinti'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_ozel_kesinti_2+t_ozel_kesinti+t_avans+t_istisna_kesinti)#</td>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54313.Kümülatif Vergi Matrahı'></td>
										<!---<cfif isdefined("onceki_donem_kum_gelir_vergisi_matrahi")>
											<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(onceki_donem_kum_gelir_vergisi_matrahi+t_gelir_vergisi_matrahi)#</td>
										<cfelse>--->
											<td class="icmal_border_last_td_without_top" style="text-align:right"> #TLFormat(t_kum_gelir_vergisi_matrahi_icmal)#</td>
										<!---</cfif>--->
										<td class="icmal_border_without_top">
											<cfif attributes.sal_year gte 2008 and attributes.sal_year lt 2022>
												<cf_get_lang dictionary_id='54310.Kesinti ve AGİ Öncesi Net'>
											<cfelseif attributes.sal_year gte 2022>
												<cf_get_lang dictionary_id='998.Kesinti Öncesi Net'>											
											<cfelse>
												<cf_get_lang dictionary_id='54309.Net Ödenecek'>
											</cfif>
										</td>
										<cfif attributes.sal_year gte 2008>
											<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_net_ucret-t_vergi_iadesi - t_stampduty_5746 + t_avans+t_ozel_kesinti+t_ozel_kesinti_2_net+t_bes_primi_isci)#</td>
										<cfelse>
											<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_net_ucret)#</td>
										</cfif>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='64701.Asgari Ücret KGVM'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_minimum_wage_cumulative)#</td>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='59363.Damga Vergisi Matrahı'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_damga_vergisi_matrahi)#</td>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54319.Kümüle Gelir Vergisi'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_kum_gelir_vergisi+t_gelir_vergisi)#</td>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='30887.İndirimsiz'> <cf_get_lang dictionary_id='53252.Damga Vergisi'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">
												#TLFormat(t_indirimsiz_damga_vergisi)#
										</td>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54297.Önceki Ay Dv Küm Matrah'></td>
										<!---<cfif isdefined("onceki_donem_kum_gelir_vergisi_matrahi")>
											<td class="icmal_border_without_top" style="text-align:right">#TLFormat(onceki_donem_kum_gelir_vergisi_matrahi)#</td>
										<cfelse>
											<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_kum_gelir_vergisi_matrahi)#</td>--->
											<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat( (t_kum_gelir_vergisi_matrahi_icmal-t_gelir_vergisi_matrahi))#</td>
										<!---</cfif>--->
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='64703.Asgari Ücret Damga Vergisi Matrahı'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_daily_minimum_wage)#</td>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='59543.Önceki Ay Dv. Km. Gelir V.'> </td>
										<!---<cfif isdefined("onceki_donem_kum_gelir_vergisi")>
											<td class="icmal_border_without_top" style="text-align:right">#TLFormat(onceki_donem_kum_gelir_vergisi)#</td>
										<cfelse>--->
											<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_kum_gelir_vergisi)#</td>
										<!---</cfif>--->
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='64704.Asgari Ücret Damga Vergisi'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_daily_minimum_wage_stamp_tax)#</td>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54321.Net Gelir Ver Matrahı'></td>
										<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_gelir_vergisi_matrahi)#</td>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='64769.Asgari Ücret Faydalanılan Damga Vergisi'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_stamp_tax_temp)#</td>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='64700.Asgari Ücrete Göre Gelir Vergi Matrahı'></td>
										<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_daily_minimum_wage_base_cumulate)#</td>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53252.Damga Vergisi'></td>
										<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_damga_vergisi-t_damga_vergisi_primi_687-t_damga_vergisi_primi_7103)#</td>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53689.Gelir Vergisi Hesaplanan'></td>
										<td class="icmal_border_without_top" style="text-align:right">
											#tlformat(t_gelir_vergisi_hesaplanan)#
										</td>
									</tr>
									<tr>
										<cfif attributes.sal_year lte 2021>
											<td class="icmal_border_without_top">
												<cfif attributes.sal_year gte 2008>
													<cf_get_lang dictionary_id='53659.Asgari Geçim İndirimi'>(#t_vergi_iadesi_alan#)
												<cfelse>
													<cf_get_lang dictionary_id='41873.Özel Gid İnd'> 
												</cfif>
											</td>
											<td></td>
											<cfif attributes.sal_year gte 2008>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_vergi_iadesi)#</td>
												<td></td>
											<cfelse>
												<cfif len(get_ogis.ogi_odenecek_toplam)>
													<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(get_ogis.ogi_odenecek_toplam)#</td>
													<td></td>
												<cfelse>
													<td class="icmal_border_last_td_without_top" style="text-align:right">0</td>
													<td></td>
												</cfif>
											</cfif>
										</cfif>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='64702.Asgari Ücret Gelir Vergisi'></td>
										<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_daily_minimum_income_tax)#</td>
										<td class="icmal_border_without_top">
											<cfif attributes.sal_year gte 2008>
												<cf_get_lang dictionary_id='53691.Toplam Net Ödenecek'>
											<cfelse>
												<cf_get_lang dictionary_id='41903.Ö.Gider İnd. Sonra GV.'>
											</cfif>
										</td>
										<cfif attributes.sal_year gte 2008>
											<td class="icmal_border_last_td_without_top" style="text-align:right">#tlformat(t_net_ucret)#</td>
										<cfelse>
											<cfif len(get_ogis.ogi_odenecek_toplam)>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_gelir_vergisi-get_ogis.ogi_odenecek_toplam-get_ogis.ogi_damga_toplam)#</td>
											<cfelse>
												<td class="icmal_border_last_td_without_top" style="text-align:right"> #TLFormat(t_gelir_vergisi)#</td>
											</cfif>
										</cfif>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53250.Gelir Vergisi'></td>
										<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_gelir_vergisi-t_gelir_vergisi_primi_687-t_gelir_vergisi_primi_7103)#</td>
										<cfif isdefined('x_total_employer_cost') and x_total_employer_cost eq 1>
											<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54320.Toplam İşveren M İndirimsiz'></td>
											<td class="icmal_border_last_td_without_top" style="text-align:right">
                                                #TLFormat(t_toplam_kazanc+t_istisna_odenek+t_issizlik_isveren_hissesi+t_ssk_primi_isveren_hesaplanan+t_ssdf_isveren_hissesi+t_ozel_kesinti_2_net_fark)#
                                            </td>
										</cfif>
									</tr>
									<tr>
										<td class="icmal_border_without_top"><cf_get_lang dictionary_id='64746.Asgari Ücret Faydalanılan'></td>
										<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_income_tax_temp)#</td>
										<cfif isdefined('x_total_employer_cost') and x_total_employer_cost eq 1>
											<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53708.Toplam İşveren Maliyeti'></td>
											<td class="icmal_border_last_td_without_top" style="text-align:right">
                                                #TLFormat((t_toplam_kazanc+t_istisna_odenek+t_issizlik_isveren_hissesi+t_ssk_primi_isveren_hesaplanan+t_ssdf_isveren_hissesi)-(t_ssk_primi_isveren_5510+t_ssk_primi_isveren_5084+t_ssk_primi_isveren_5921+t_ssk_primi_isveren_5746+t_ssk_primi_isveren_4691 +t_ssk_primi_isveren_6111+t_ssk_primi_isveren_6486+t_ssk_primi_isveren_6322+t_ssk_primi_isci_6322+t_ssk_primi_isveren_gov+t_ssk_primi_isveren_25510+t_ssk_primi_isveren_14857+t_ssk_isveren_hissesi_3294+t_ssk_primi_isveren_6645 + t_ssk_primi_isveren_46486 + t_ssk_primi_isveren_56486 + t_ssk_primi_isveren_66486 +toplam_indirim_687+toplam_indirim_7103+t_toplam_indirim_7252+t_toplam_indirim_7256)+t_ozel_kesinti_2_net_fark)#
                                            </td>
										</cfif>
									</tr>
								</cfoutput>
							</tbody>
						</cf_grid_list>
					</div>
				</div>
				<!--- Detay --->
				<cfif attributes.show_detail eq 1 or icmal_type is 'genel'>
					<cfoutput>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
								<cf_grid_list sort="0">
									<tbody>
										<cfif t_ssk_primi_isveren_5510 gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='53256.SGK İşveren Primi'> 5510 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_without_top" style="text-align:right">#tlformat(t_ssk_primi_isveren_5510)#</td>
											</tr>
										</cfif>
										<cfif t_ssk_primi_isveren_5084 gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='53256.SGK İşveren Primi'> 5084 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_without_top" style="text-align:right">#tlformat(t_ssk_primi_isveren_5084)#</td>
											</tr>
										</cfif>
										<cfif t_ssk_primi_isveren_gov gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='53256.SGK İşveren Primi'> 5763 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_ssk_primi_isveren_gov)#</td>
											</tr>
										</cfif>
										<cfif t_ssk_primi_isveren_5746 gt 0 or t_ssk_days_5746 gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='53256.SGK İşveren Primi'> 5746 <cf_get_lang dictionary_id='54268.İndirimi'> (#t_ssk_days_5746#)</td>
												<td class="icmal_border_without_top" style="text-align:right">#tlformat(t_ssk_primi_isveren_5746)#</td>
												
											</tr>
										</cfif>
										<cfif t_ssk_primi_isveren_4691 gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='53256.SGK İşveren Primi'> 4691 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_without_top" style="text-align:right">#tlformat(t_ssk_primi_isveren_4691)#</td>
											</tr>
										</cfif>
										<cfif t_ssk_primi_isveren_6111 gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='53256.SGK İşveren Primi'> 6111 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_without_top" style="text-align:right">#tlformat(t_ssk_primi_isveren_6111)#</td>
											</tr>
										</cfif>
										<cfif t_ssk_primi_isveren_5921 gt 0>
											<tr>
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53256.SGK İşveren Primi'> 5921 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_without_top" style="text-align:right">#TLFormat(t_ssk_primi_isveren_5921)#</td>
											</tr>
										</cfif>
										<cfif t_ssk_primi_isveren_6486 gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='53256.SGK İşveren Primi'> 6486 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_without_top" style="text-align:right">#tlformat(t_ssk_primi_isveren_6486)#</td>
											</tr>
										</cfif>
										<cfif t_ssk_primi_isveren_6322 gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='53256.SGK İşveren Primi'> 6322 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_without_top" style="text-align:right">#tlformat(t_ssk_primi_isveren_6322+t_ssk_primi_isci_6322)#</td>
											</tr>
										</cfif>
										<cfif t_ssk_primi_isveren_25510 gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='53256.SGK İşveren Primi'> 25510 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_without_top" style="text-align:right">#tlformat(t_ssk_primi_isveren_25510)#</td>
											</tr>
										</cfif>
										<cfif t_ssk_primi_isveren_14857 gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='53256.SGK İşveren Primi'> 14857 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_without_top" style="text-align:right">#tlformat(t_ssk_primi_isveren_14857)#</td>
											</tr>
										</cfif>
										<cfif t_ssk_isveren_hissesi_3294 gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='53256.SGK İşveren Primi'> 3294 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_without_top" style="text-align:right">#tlformat(t_ssk_isveren_hissesi_3294)#</td>
											</tr>
										</cfif>
										<cfif t_ssk_primi_isveren_6645 gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='53256.SGK İşveren Primi'> 6645 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_without_top" style="text-align:right">#tlformat(t_ssk_primi_isveren_6645)#</td>
											</tr>
										</cfif>
										<cfif t_ssk_primi_isveren_46486 gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='53256.SGK İşveren Primi'> 46486 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_without_top" style="text-align:right">#tlformat(t_ssk_primi_isveren_46486)#</td>
											</tr>
										</cfif>
										<cfif t_ssk_primi_isveren_56486 gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='53256.SGK İşveren Primi'> 56486 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_without_top" style="text-align:right">#tlformat(t_ssk_primi_isveren_56486)#</td>
											</tr>
										</cfif>
										<cfif t_ssk_primi_isveren_66486 gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='53256.SGK İşveren Primi'> 66486 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_without_top" style="text-align:right">#tlformat(t_ssk_primi_isveren_66486)#</td>
											</tr>
										</cfif>
										<cfif t_isveren_primi_7103 gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='53256.SGK İşveren Primi'> 7103 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_without_top" style="text-align:right">#tlformat(t_isveren_primi_7103)#</td>
											</tr>
										</cfif>
										<cfif t_ssk_isveren_hissesi_7252 gt 0 or t_ssk_days_7252 gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='53256.SGK İşveren Primi'> 7252 <cf_get_lang dictionary_id='54268.İndirimi'>(#t_ssk_days_7252#)</td>
												<td class="icmal_border_without_top" style="text-align:right">#tlformat(t_ssk_isveren_hissesi_7252)#</td>
											</tr>
										</cfif>
										<cfif t_ssk_isveren_hissesi_7256 gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap><cf_get_lang dictionary_id='53256.SGK İşveren Primi'> 7256 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_without_top" style="text-align:right">#tlformat(t_ssk_isveren_hissesi_7256)#</td>
											</tr>
										</cfif>
										<cfif t_base_amount_7256 gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap>7256 Toplam Hesaplanan</td>
												<td class="icmal_border_without_top" style="text-align:right"><cfif len(t_base_amount_7256)>#tlformat(t_base_amount_7256)#<cfelse>#tlformat(0)#</cfif></td>
											</tr>
										</cfif>
										<cfif t_toplam_indirim_7256 gt 0>
											<tr>
												<td class="icmal_border_without_top" nowrap>7256 Kullanılan</td>
												<td class="icmal_border_without_top" style="text-align:right"><cfif len(t_toplam_indirim_7256)>#tlformat(t_toplam_indirim_7256)#<cfelse>#tlformat(0)#</cfif></td>					
											</tr>
										</cfif>
									</tbody>
								</cf_grid_list>
							</div>	
							<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
								<cf_grid_list sort="0">
									<tbody>
										<cfif toplam_indirim_687 gt 0>
											<tr>
												<td class="icmal_border_last_td_without_top"><cf_get_lang dictionary_id='57492.Toplam'> 687/01687 <cf_get_lang dictionary_id='54268.İndirimi'> </td>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#tlformat(toplam_indirim_687)#</td>
											</tr>
										</cfif>
										<cfif t_ssk_primi_7103 gt 0 or t_ssk_isveren_hissesi_7103 gt 0>
											<tr>
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53719.SGK İşçi Primi'> 7103 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#tlformat(t_ssk_primi_7103 - t_ssk_isveren_hissesi_7103)#</td>
											</tr>
										</cfif>
										<cfif t_issizlik_primi_7103 gt 0>
											<tr>
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53196.İşsizlik Sigortası'> 7103 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#tlformat(t_issizlik_primi_7103)#</td>
											</tr>
										</cfif>
										<cfif t_gelir_vergisi_primi_7103 gt 0>
											<tr>
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53250.Gelir Vergisi'> 7103 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#tlformat(t_gelir_vergisi_primi_7103)#</td>
											</tr>
										</cfif>
										<cfif t_damga_vergisi_primi_7103 gt 0>
											<tr>
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53252.Damga Vergisi'> 7103 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#tlformat(t_damga_vergisi_primi_7103)#</td>
											</tr>
										</cfif>
										<cfif t_ssk_isci_hissesi_7252 gt 0>
											<tr>
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53719.SGK İşçi Primi'> 7252 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#tlformat(t_ssk_isci_hissesi_7252,2)#</td>
											</tr>
										</cfif>
										<cfif t_issizlik_isveren_hissesi_7252 gt 0>
											<tr>
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53196.İşsizlik Sigortası'> 7252 <cf_get_lang dictionary_id='53550.İşveren'></td>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#tlformat(t_issizlik_isveren_hissesi_7252,2)#</td>
											</tr>
										</cfif>
										<cfif t_issizlik_isci_hissesi_7252 gt 0>
											<tr>
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53196.İşsizlik Sigortası'> 7252 <cf_get_lang dictionary_id='45049.İşçi'></td>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#tlformat(t_issizlik_isci_hissesi_7252,2)#</td>
											</tr>
										</cfif>
										<cfif t_ssk_isci_hissesi_7256 gt 0>
											<tr>
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53719.SGK İşçi Primi'> 7256 <cf_get_lang dictionary_id='54268.İndirimi'></td>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#tlformat(t_ssk_isci_hissesi_7256,2)#</td>
											</tr>
										</cfif>
										<cfif t_issizlik_isveren_hissesi_7256 gt 0>
											<tr>							
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53196.İşsizlik Sigortası'> 7256 <cf_get_lang dictionary_id='53550.İşveren'></td>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#tlformat(t_issizlik_isveren_hissesi_7256,2)#</td>
											</tr>
										</cfif>
										<cfif t_issizlik_isci_hissesi_7256 gt 0>
											<tr>
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53196.İşsizlik Sigortası'> 7256 <cf_get_lang dictionary_id='45049.İşçi'></td>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#tlformat(t_issizlik_isci_hissesi_7256,2)#</td>
											</tr>
										</cfif>
										<cfif t_vergi_indirimi_5084 gt 0>
											<tr>
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id='53690.Vergi İndirimi'><cfif (attributes.sal_year eq 2007 and attributes.sal_mon gt 6) or attributes.sal_year gte 2008>5084 (5615)<cfelse>5084</cfif></td>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_vergi_indirimi_5084)#</td>
											</tr>
										</cfif>
										<cfif t_damga_vergisi_indirimi_5746 gt 0>
											<tr>
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id='59370.Damga Vergisi İndirimi'> 5746</td>
												<td class="icmal_border_last_td_without_top" style="text-align:right">#TLFormat(t_damga_vergisi_indirimi_5746)#</td>
											</tr>
										</cfif>
										<cfset arge_indirimi = t_vergi_indirimi_5746+t_vergi_indirimi_4691>
										<cfif arge_indirimi gt 0>
											<tr>
												<td class="icmal_border_without_top"><cf_get_lang dictionary_id='54317.Arge İndirimi'> (#t_vergi_indirimi_5746_days#)</td>
												<td class="icmal_border_last_td_without_top" style="text-align:right">
													
													<cfif arge_indirimi lt 0>
														#TLFormat(0)#
													<cfelse>
														#TLFormat(t_vergi_indirimi_5746+t_vergi_indirimi_4691)#
													</cfif>
												</td>
											</tr>
										</cfif>
									<tbody>
								</cf_grid_list>
							</div>
						</div>
					</cfoutput>	
				</cfif>
			</div>
			<cfif not isdefined("attributes.page_dept")>
				<cfif icmal_type is "personal">
					<cfif isdefined("GET_PUANTAJ_PERSONAL.emp_bank_id") and len(GET_PUANTAJ_PERSONAL.emp_bank_id)>
						<cfquery name="get_bank_" datasource="#dsn#">
						SELECT 
							BA.BANK_BRANCH_CODE,
							BA.BANK_ACCOUNT_NO,
							BA.IBAN_NO,
							B.BANK_NAME
						FROM
							EMPLOYEES_BANK_ACCOUNTS BA,
							SETUP_BANK_TYPES B
						WHERE
							BA.BANK_ID = B.BANK_ID AND
							BA.DEFAULT_ACCOUNT = 1 AND
							BA.EMP_BANK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.emp_bank_id#">
						</cfquery>
						<cfset str = '<b>#get_bank_.BANK_NAME# (#get_bank_.BANK_BRANCH_CODE#-#get_bank_.BANK_ACCOUNT_NO#)'>
						<cfif len(get_bank_.IBAN_NO)>
							<cfset str = str & '(#get_bank_.IBAN_NO#)'>
						</cfif>
						<cfset a= #getLang('','Nolu Hesabımdan','59544')#>
						<cfset str = "#str# & #a#">
					<cfelse>
						<cfset get_bank_.recordcount = 0>
						<cfset str = ''>
					</cfif>
					<cfquery name="get_apply_date" datasource="#dsn#">
						SELECT 
							APPLY_DATE
						FROM 
							EMPLOYEES_PUANTAJ_MAILS 
						WHERE 
							EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.employee_id#"> AND
							BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.branch_id#"> AND 
							<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_year_end)>
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
								SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
								SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
							</cfif>
					</cfquery>
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<cf_grid_list sort="0">
								<cfif len(get_apply_date.apply_date)>
									<tr>
										<td height="30" colspan="4" style="text-align:right" class="txtbold"><cfoutput><cf_get_lang dictionary_id='59540.İşbu Bordro'> #dateformat(get_apply_date.APPLY_DATE,dateformat_style)# <cf_get_lang dictionary_id='59541.tarihinde'>  #GET_PUANTAJ_PERSONAL.EMPLOYEE_name#  #GET_PUANTAJ_PERSONAL.EMPLOYEE_surname# <cf_get_lang dictionary_id='59542.tarafından onaylanmıştır'>.</cfoutput></td>
									</tr>
								</cfif>
							</cf_grid_list>
						</div>
					</div>
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<cf_grid_list sort="0">
								<tbody>					
									<tr>
										<td colspan="4" class="icmal_border_last_td_without_top"><cf_get_lang dictionary_id="59536.Bu Ücret Pusulasıyla Tahakkuku Yapılan Ödemelerin Fiili Çalışmama Uygun Olduğunu">, 
											<cfif t_ext_Salary eq 0 and x_ext_salary eq 1><cf_get_lang dictionary_id="59537.Fazla Mesai Yapmadığımı,">, </cfif><cf_get_lang dictionary_id="59538.Ücretlerimi"> 
											<cfoutput>#str#</cfoutput> <cf_get_lang dictionary_id="59539.Aldığımı , Ücret Alacağımın kalmadığını Kabul Ve Beyan Ederim">.</td>
									</tr>
								</tbody>
							</cf_grid_list>
						</div>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<cf_grid_list sort="0">
								<tbody>
									<tr>
										<td class="icmal_border_without_top" valign="top" rowspan="2"><cf_get_lang dictionary_id='58957.İmza'></td>
										<td class="icmal_border_last_td_without_top" rowspan="2" style="text-align:right">&nbsp;</td>
									</tr>
								</tbody>
							</cf_grid_list>
						</div>
					</div>		
				</div>
				</cfif>
			</cfif>
			
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
	</div>	
</cf_box>

<cf_get_lang_set module_name="#fusebox.circuit#">
<script type="text/javascript">
	$( document ).ready(function() {
		<cfif icmal_type is "personal" and IsDefined("GET_PUANTAJ_PERSONAL.DEFECTION_LEVEL") and len(GET_PUANTAJ_PERSONAL.DEFECTION_LEVEL) and GET_PUANTAJ_PERSONAL.DEFECTION_LEVEL gt 0 
			and not( 
			isdefined("GET_PUANTAJ_PERSONAL.DEFECTION_STARTDATE") and GET_PUANTAJ_PERSONAL.DEFECTION_STARTDATE lte end_month and 
			isdefined("GET_PUANTAJ_PERSONAL.DEFECTION_FINISHDATE") and GET_PUANTAJ_PERSONAL.DEFECTION_FINISHDATE gte start_month
			)>
			alert("<cf_get_lang dictionary_id='64171.Bu çalışanın engellilik geçerlik tarihi dolmuştur!'>");
		</cfif>
	});
	
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