<!--- 
weeks[i] ayin i. haftasi ;
	1 : hafta basi tarihi
	2 : hafta sonu tarihi
	3 : adam saat toplami
	4 : Ücretsiz İzin saat toplami
	13 : Ücretli İzin gun toplami
	5 : Hafta içi fazla mesai toplami
	6 : Hafta sonu fazla mesai toplami
	7 : Resmi tatil fazla mesai toplami
	------------------------------------- önceki ayin son haftasi özel hesabi için
	8 : ay basi önceki ay adam saat toplami
	9 : ay basi önceki ay Ücretsiz İzin saat toplami
	14 : ay basi önceki ay Ücretli İzin saat toplami
	10 : ay basi önceki ay Hafta içi fazla mesai toplami
	11 : ay basi önceki ay Hafta sonu fazla mesai toplami
	12 : ay basi önceki ay Resmi tatil fazla mesai toplami
 --->

 <cfscript>
	izin_sifirlandi = 0;
	ext_total_hours_0 = 0;  // hafta içi fala mesai toplami
	ext_total_hours_1 = 0;  // hafta sonu fazla mesai
	ext_total_hours_2 = 0;  // resmi tatil fazla mesaileri
	ext_total_hours_3 = 0;  // 45 saati asan kisimlar toplami
	ext_total_hours_4 = 0;  // 45 saatin altinda kalam kisimlar toplami
	ext_total_hours_5 = 0;  // gece calismasi

	ext_total_hours_9 = 0;  
	ext_total_hours_10 = 0;  
	ext_total_hours_11 = 0;  
	ext_total_hours_12 = 0;  
	ext_total_hours_8 = 0;  
	t_akdi_day=0;
	t_akdi_hour=0;
	t_akdi_tatil_amount=0;

	sunday_count = 0;
	izinli_sunday_count = 0;    	// ücretsiz izinli hafta sonlari toplami
	paid_izinli_sunday_count = 0;	// ücretli izinli hafta sonlari toplami
	izin_count = 0; // ücretsiz izin saat 
	izin_paid_count = 0; // ücretli izin saat 
	izin_paid = 0; // ücretli izin gün 
	arge_izin_gunu = 0;//argeye dahil izin gün 
	ext_salary = 0;//fazla mesai
	total_hours = 0;//toplam saat
	kısa_calisma_gun = 0;//kısa çalışma gün sayısı
	arada_kalan = 0;
    arada_kalan_sonraki = 0;
	oranli_gun = 0;
	kisa_calisma = 0;
	onceki_ay_cikarilacak = 0;
// şimdilik olmayanlar erk 20030913
	gocmen_indirimi = 0;
	cocuk_parasi = 0;
	vergi_iadesi = 0;
	vergi_iade_damga_vergisi = 0;
	toplam_yuvarlama = 0;
	aydaki_gun_sayisi = datediff('d',last_month_1_general,last_month_30_general) + 1;
	kisi_aydaki_gun_sayisi = datediff('d',last_month_1,last_month_30) + 1;
	toplam_calisma_gunu = 0;
	izin_date = arrayNew(1);
	izin_finish_date = arrayNew(1);
	gelen_saat = 0;
	kisa_calisma_type = 0;
	half_total_hour = 0;
	is_half_day = 0;
	
// toplam gün sayısı
	if((get_active_program_parameter.SSK_31_DAYS eq 1 and not(len(get_hr_ssk.finish_date) or datediff("h",last_month_1,get_hr_ssk.start_date) eq 0)) or ((len(get_hr_ssk.finish_date) or datediff("h",last_month_1,get_hr_ssk.start_date) eq 0) and get_hr_ssk.use_ssk eq 2 and get_active_program_parameter.SSK_31_DAYS eq 1))
	{
		ssk_full_days = aydaki_gun_sayisi;
	}
	else
		ssk_full_days = 30;
	
	if((get_hr_salary.salary_type eq 1 or get_hr_salary.salary_type eq 0) and not listfindnocase('0,1,2,3',get_hr_ssk.DUTY_TYPE))
		ssk_full_days = 30;
	if(isdefined("get_active_program_parameter.FIRST_DAY_MONTH") and len(get_active_program_parameter.FIRST_DAY_MONTH) and not(get_active_program_parameter.FIRST_DAY_MONTH eq 1 and get_active_program_parameter.LAST_DAY_MONTH eq 0))
	{
		work_days = datediff('d',last_month_1,last_month_30)+1;
	}
	else if ((day(last_month_1) neq 1) or (day(last_month_30) neq daysinmonth(last_month_30)) or (len(get_hr_ssk.finish_date) and datediff("d",get_hr_ssk.finish_date,last_month_30) eq 0)) // normal calisma veya ay ortasında işe girmiş ve/veya çıkmış
	{
		work_days = day(last_month_30) - day(last_month_1) + 1;
	}
	else 
	{
		if((get_hr_salary.salary_type eq 1 or get_hr_salary.salary_type eq 0) and listfindnocase('0,1,2,3',get_hr_ssk.DUTY_TYPE))
			work_days = aydaki_gun_sayisi;
		else
			work_days = ssk_full_days;
	}
	
	// sgk durumu hayır ise çalışma gününü fix 30 gün üzerinden alacak  SG 20150427 88302 id li iş
	if(get_active_program_parameter.IS_NOT_SGK_WORK_DAYS_30 eq 1)
	{
		if(use_ssk eq 0 and work_days+get_days.KUMULATIF_DAYS gt 30)
		{
			work_days = work_days-1;
		}
		else if(use_ssk eq 0 and daysinmonth(last_month_1_general) eq 28 and work_days+get_days.KUMULATIF_DAYS eq 28)
		{
			work_days = work_days+2;
		}
		else if(use_ssk eq 0 and daysinmonth(last_month_1_general) eq 29 and work_days+get_days.KUMULATIF_DAYS eq 29)
		{
			work_days = work_days+1;
		}
	}			

	//ay 31 gün ise, parametrelerden 31 hayır seçilmişse ve 31 de çıkış varsa
	if(get_active_program_parameter.SSK_31_DAYS eq 0 and work_days eq 31 and len(get_hr_ssk.finish_date) and day(get_hr_ssk.finish_date) eq 31 and get_hr_salary.salary_type eq 2)
		work_days = 30;

	ssk_days = work_days;
	if(get_hr_salary.salary_type eq 1 and ssk_days eq 31 and get_active_program_parameter.SSK_31_DAYS eq 0 and for_ssk_day eq 0 and datediff("h",last_month_1,get_hr_ssk.start_date) neq 0)
		ssk_days = 30;
	if(get_hr_salary.salary_type eq 1 and ssk_days eq aydaki_gun_sayisi and get_active_program_parameter.SSK_31_DAYS eq 0 and for_ssk_day eq 0 and datediff("h",last_month_1,get_hr_ssk.start_date) neq 0)
		ssk_days = 30;

	//saatlik çalışansa ve şubat ayıysa ve bordro akış parametresinden "Şubat Ayı Saatlik Çalışanın SGK Matrahı 30 Gün" evet seçilyse
	if(get_hr_salary.salary_type eq 0 and ssk_days eq aydaki_gun_sayisi and get_active_program_parameter.SSK_31_DAYS eq 0 and for_ssk_day eq 0 and get_active_program_parameter.HOURLY_EMPLOYEE_WORK_DAYS_30 eq 1 and attributes.sal_mon eq 2)
		ssk_days = 30;
	if(get_hr_salary.salary_type eq 1 and daysinmonth(last_month_1_general) eq 31 and ssk_days eq 30)
	{
		ssk_full_days = 31;
	}
	if(get_hr_salary.salary_type eq 1 and daysinmonth(last_month_1_general) eq 28 and ssk_days eq 30)
	{
		ssk_full_days = 28;
	}
		
	if(get_hr_salary.salary_type eq 1 and daysinmonth(last_month_1_general) eq 29 and ssk_days eq 30)
	{
		ssk_full_days = 29;
	}
		
	if(get_active_program_parameter.FULL_DAY eq 0 and daysinmonth(last_month_1_general) eq 31 and ssk_days eq 30)
	{
		ssk_full_days = 31;
	}
		
	if(get_active_program_parameter.FULL_DAY eq 0 and daysinmonth(last_month_1_general) eq 28 and ssk_days eq 30)
	{
		ssk_full_days = 28;
	}
		
	if(get_active_program_parameter.FULL_DAY eq 0 and daysinmonth(last_month_1_general) eq 29 and ssk_days eq 30)
	{
		ssk_full_days = 29;
	}
	
	// bu sistem yeni istihdam kanunu ile duzenlendi yo07082008
	sakat_carpan = 1;
	
	
// hafta sonu hesabi
	if(isdefined("get_active_program_parameter.FIRST_DAY_MONTH") and len(get_active_program_parameter.FIRST_DAY_MONTH) and not(get_active_program_parameter.FIRST_DAY_MONTH eq 1 and get_active_program_parameter.LAST_DAY_MONTH eq 0))
	{

		for (i = 0; i lte datediff('d',last_month_1,last_month_30)+1; i=i+1)
			if(dayofweek(date_add('d', i, last_month_1)) eq this_weekly_offday_)
				sunday_count = sunday_count + 1;
			else if(dayofweek(date_add('d', i, last_month_1)) eq 7 and this_weekly_offday_ neq 7 and this_saturday_work_hour_ eq 0)
				sunday_count = sunday_count + 1;
	}
	else
	{
		for (i = 0; i lte (day(last_month_30) - day(last_month_1)); i=i+1)
		if(dayofweek(date_add('d', i, last_month_1)) eq this_weekly_offday_)
			sunday_count = sunday_count + 1;
		else if(dayofweek(date_add('d', i, last_month_1)) eq 7 and this_weekly_offday_ neq 7 and this_saturday_work_hour_ eq 0)
			sunday_count = sunday_count + 1;
	}	

			
	//bes carpani		
	if(get_bes.recordcount and get_bes.rate_bes neq 0)
		bes_isci_carpan = get_bes.rate_bes;
	else
		bes_isci_carpan = 0;

</cfscript>

<!--- Çalışanın İzinleri ve İzinlere bağlı İzin ve Mazeret Parametreleri--->
<cfquery name="get_emp_offtimes" datasource="#dsn#">
	SELECT
		OFFTIME.TOTAL_HOURS,
		OFFTIME.STARTDATE,
		OFFTIME.FINISHDATE,
		SETUP_OFFTIME.IS_PAID,
		SETUP_OFFTIME.IS_YEARLY,
		ISNULL(SETUP_OFFTIME.IS_RD_SSK,0) AS IS_RD_SSK,
		SETUP_OFFTIME.SIRKET_GUN,
		SETUP_OFFTIME.PAID_A_DAY,
		SETUP_OFFTIME.EBILDIRGE_TYPE_ID,
		OFFTIME.SHORT_WORKING_RATE,
		OFFTIME.SHORT_WORKING_HOURS,
		OFFTIME.FIRST_WEEK_CALCULATION,
		SUM(DATEDIFF(n,OFFTIME.STARTDATE,OFFTIME.FINISHDATE)) AS TOTAL_HOUR,
		ISNULL(INCLUDED_IN_TAX,0) INCLUDED_IN_TAX
	FROM
		OFFTIME,
		SETUP_OFFTIME
	WHERE
		ISNULL(SETUP_OFFTIME.IS_PUANTAJ_OFF,0) <> 1 AND
		OFFTIME.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#"> AND
		(
			(
			(OFFTIME.SUB_OFFTIMECAT_ID = 0 OR OFFTIME.SUB_OFFTIMECAT_ID IS NULL) AND
			OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
			)
			OR
			(OFFTIME.SUB_OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND SETUP_OFFTIME.OFFTIMECAT_ID <> 0)
		) AND
		OFFTIME.VALID = 1 AND
		<cfif get_active_program_parameter.offtime_count_type eq 1>
			(
			SETUP_OFFTIME.IS_PAID = 1
			OR
			(SETUP_OFFTIME.IS_PAID = 0 AND DATEDIFF(hh,OFFTIME.STARTDATE,OFFTIME.FINISHDATE) >= #get_hours.DAILY_WORK_HOURS#)
			) AND
		</cfif>
		<cfif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1 and get_active_program_parameter.is_add_virtual_all eq 1>
			(OFFTIME.IS_PUANTAJ_OFF = 0 OR OFFTIME.IS_PUANTAJ_OFF IS NULL OR OFFTIME.IS_PUANTAJ_OFF = 1)
		<cfelseif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1>
			(OFFTIME.IS_PUANTAJ_OFF = 1)
		<cfelse>
			(OFFTIME.IS_PUANTAJ_OFF = 0 OR OFFTIME.IS_PUANTAJ_OFF IS NULL)
		</cfif> AND
		OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('h',-session.ep.time_zone,last_month_30)#"> AND
		OFFTIME.FINISHDATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('h',-session.ep.time_zone,last_month_1)#"> AND
		OFFTIME.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
		<!---(
		OFFTIME.IN_OUT_ID IS NULL
		OR
			(
			OFFTIME.IN_OUT_ID = #attributes.in_out_id#
			AND
			SETUP_OFFTIME.EBILDIRGE_TYPE_ID = '06'
			)
		OR
			(
			OFFTIME.IN_OUT_ID = #attributes.in_out_id#
			AND
			OFFTIME.SPECIAL_CODE IS NOT NULL
			)
		)--->
	GROUP BY
		TOTAL_HOURS,
		STARTDATE,
		FINISHDATE,
		IS_PAID,
		IS_YEARLY,
		IS_RD_SSK,
		SIRKET_GUN,
		PAID_A_DAY,
		EBILDIRGE_TYPE_ID,
		SHORT_WORKING_RATE,
		SHORT_WORKING_HOURS,
		FIRST_WEEK_CALCULATION,
		INCLUDED_IN_TAX
	ORDER BY OFFTIME.STARTDATE ASC
</cfquery>
<cfquery name="get_emp_rapors" dbtype="query"><!--- izinler --->
	SELECT 
		* 
	FROM 
		get_emp_offtimes
	WHERE 
		SIRKET_GUN > 0
	ORDER BY 
		STARTDATE ASC
</cfquery>
<cfquery name="get_emp_paid" dbtype="query"><!--- izinler --->
	SELECT 
		* 
	FROM 
		get_emp_offtimes
	WHERE 
		PAID_A_DAY = 1
	ORDER BY 
		STARTDATE ASC
</cfquery>
<!--- Bildirge tipi 18 - kısa çalışma ödeneği seçilen izinler Esma R. Uysal--->
<cfquery name="get_kisa_calisma" dbtype="query">
	SELECT 
		* 
	FROM 
		get_emp_offtimes
	WHERE 
		EBILDIRGE_TYPE_ID = 18
		AND (SHORT_WORKING_RATE IS NOT NULL OR SHORT_WORKING_HOURS IS NOT NULL)
		AND FIRST_WEEK_CALCULATION IS NOT NULL
	ORDER BY 
		STARTDATE ASC
</cfquery>
<cfif get_active_program_parameter.offtime_count_type eq 1>
	<cfquery name="get_half_offtimes" datasource="#dsn#">
		SELECT
			SUM(DATEDIFF(n,OFFTIME.STARTDATE,OFFTIME.FINISHDATE)) AS TOTAL_HOUR,
			SETUP_OFFTIME.SIRKET_GUN,
			INCLUDED_IN_TAX
		FROM
			OFFTIME,
			SETUP_OFFTIME
		WHERE
			OFFTIME.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#"> AND
			OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
			OFFTIME.VALID = 1 AND
			SETUP_OFFTIME.IS_PAID = 0 AND 
			ISNULL(SETUP_OFFTIME.IS_PUANTAJ_OFF,0) <> 1 AND
			DATEDIFF(hh,OFFTIME.STARTDATE,OFFTIME.FINISHDATE) < #get_hours.DAILY_WORK_HOURS# AND
			<cfif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1 and get_active_program_parameter.is_add_virtual_all eq 1>
				(OFFTIME.IS_PUANTAJ_OFF = 0 OR OFFTIME.IS_PUANTAJ_OFF IS NULL OR OFFTIME.IS_PUANTAJ_OFF = 1)
			<cfelseif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1>
				(OFFTIME.IS_PUANTAJ_OFF = 1)
			<cfelse>
				(OFFTIME.IS_PUANTAJ_OFF = 0 OR OFFTIME.IS_PUANTAJ_OFF IS NULL)
			</cfif> AND
			OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('h',-session.ep.time_zone,last_month_30)#"> AND
			OFFTIME.FINISHDATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('h',-session.ep.time_zone,last_month_1)#"> AND
			OFFTIME.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
		GROUP BY
			SIRKET_GUN,
			INCLUDED_IN_TAX
			<!---(
			OFFTIME.IN_OUT_ID IS NULL
			OR
				(
				OFFTIME.IN_OUT_ID = #attributes.in_out_id#
				AND
				SETUP_OFFTIME.EBILDIRGE_TYPE_ID = '06'
				)
			OR
				(
				OFFTIME.IN_OUT_ID = #attributes.in_out_id#
				AND
				OFFTIME.SPECIAL_CODE IS NOT NULL
				)
			)--->
	</cfquery>
	<cfif not get_half_offtimes.recordcount or not len(get_half_offtimes.TOTAL_HOUR)>
		<cfset get_half_offtimes_total_hour = 0>
	<cfelse>
		<cfset get_half_offtimes_total_hour = (get_half_offtimes.TOTAL_HOUR/60)>
	</cfif>
	<!--- Yarım günlük raporluysa ve şirket 2 gününü karşılıyorsa günden düşmez --->
	<cfif get_emp_rapors.recordcount eq 0 and get_half_offtimes.sirket_gun eq 2 and get_half_offtimes_total_hour neq 0 >
		<cfset get_half_offtimes_total_hour = 0>
	<cfelseif get_emp_paid.recordcount eq 0 and get_emp_paid.paid_a_day eq 2 and get_half_offtimes_total_hour neq 0 >
		<cfset get_half_offtimes_total_hour = 0>
	</cfif>
<cfelse>
	<cfset get_half_offtimes.recordcount = 0>
	<cfset get_half_offtimes_total_hour = 0>
</cfif>
<cfif attributes.ssk_statue eq 1 or (isdefined("attributes.statue_type") and attributes.ssk_statue eq 2 and attributes.statue_type eq 9)>
	<!--- Toplu Fazla Mesai --->
	<cfquery name="get_emp_ext_worktimes2" datasource="#dsn#"><!--- fazla mesai toplam kayıtları--->
		SELECT
			OVERTIME_VALUE_0,
			OVERTIME_VALUE_1,
			OVERTIME_VALUE_2,
			OVERTIME_VALUE_3
		FROM
			EMPLOYEES_OVERTIME
		WHERE
			<cfif isdefined("attributes.in_out_id")>IN_OUT_ID = #attributes.in_out_id# AND</cfif>
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#"> AND 
			OVERTIME_PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
			OVERTIME_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
	</cfquery>
	<cfif get_emp_ext_worktimes2.recordcount>
		<cfset get_emp_ext_worktimes.recordcount = 0>
		<cfif get_active_program_parameter.extra_time_style eq 3>
			<cfset ext_total_hours_0 = get_emp_ext_worktimes2.overtime_value_0> <!--- normal calısma mesai saati--->
			<cfset ext_total_hours_3 = get_emp_ext_worktimes2.overtime_value_0> <!--- normal calısma mesai saati--->
			<cfset ext_total_hours_1 = get_emp_ext_worktimes2.overtime_value_1><!---hafta sonu fazla mesai--->
			<cfset ext_total_hours_2 = get_emp_ext_worktimes2.overtime_value_2><!---resmi tatil fazla mesai--->
			<cfset ext_total_hours_5 = get_emp_ext_worktimes2.overtime_value_3><!---gece çalışması fazla mesai--->
		<cfelse>
			<cfset ext_total_hours_0 = get_emp_ext_worktimes2.overtime_value_0*60> <!--- normal calısma mesai saati--->
			<cfset ext_total_hours_3 = get_emp_ext_worktimes2.overtime_value_0*60> <!--- normal calısma mesai saati--->
			<cfset ext_total_hours_1 = get_emp_ext_worktimes2.overtime_value_1*60><!---hafta sonu fazla mesai--->
			<cfset ext_total_hours_2 = get_emp_ext_worktimes2.overtime_value_2*60><!---resmi tatil fazla mesai--->
			<cfset ext_total_hours_5 = get_emp_ext_worktimes2.overtime_value_3*60><!---gece çalışması fazla mesai--->
		</cfif>
	</cfif>
	<!--- Fazla Mesai --->
	<cfquery name="get_emp_ext_worktimes" datasource="#dsn#">
		SELECT START_TIME, END_TIME, DAY_TYPE FROM EMPLOYEES_EXT_WORKTIMES 
		WHERE 
		<cfif isdefined("attributes.in_out_id")>IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND</cfif>
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#"> AND 
		START_TIME >= #DATEADD('ww',-1,last_month_1)# 
		AND END_TIME < #last_month_30# AND
		MONTH(START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
		(
			(IS_FROM_PDKS = 0 OR IS_FROM_PDKS IS NULL)
			OR
			(IS_FROM_PDKS = 1 AND VALID = 1)
		)
		AND VALID = 1
		<cfif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1 and get_active_program_parameter.is_add_virtual_all eq 1>
			AND (IS_PUANTAJ_OFF IS NULL OR IS_PUANTAJ_OFF = 0 OR IS_PUANTAJ_OFF = 1)
		<cfelseif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1>
			AND IS_PUANTAJ_OFF = 1
		<cfelse>
			AND (IS_PUANTAJ_OFF = 0 OR IS_PUANTAJ_OFF IS NULL)
		</cfif>
		ORDER BY START_TIME ASC
	</cfquery>
	<cfif isdefined("attributes.statue_type") and attributes.ssk_statue eq 2 and attributes.statue_type eq 9 and get_emp_ext_worktimes.recordcount eq 0>
		<cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: "#getLang('','Çalışanın Fazla Mesaisi Bulunmamaktadır','64850')#", in_out_id: attributes.in_out_id) />
		<cfabort>
	</cfif>
<cfelse>
	<cfset get_emp_ext_worktimes.recordcount = 0>
	<cfset get_emp_ext_worktimes2.recordcount = 0>
</cfif>
<cfscript>
	// 7 6 5 4 3 2 1 : Cts Cm Pr Çrş Sa Pts Pz
	if(dayofweek(last_month_1) eq 2 and daysinmonth(last_month_1) gt 28)
		total_weeks = 5;
	else if(dayofweek(last_month_1) eq 2 and daysinmonth(last_month_1) eq 28)
		total_weeks = 4;
	else if(listfind('3,4,5,6',dayofweek(last_month_1),','))
		total_weeks = 5;
	else if(dayofweek(last_month_1) eq 7)
		if(daysinmonth(last_month_1) lt 31)
			total_weeks = 5;
		else
			total_weeks = 6;
	else if(dayofweek(last_month_1) eq 1)
		if(daysinmonth(last_month_1) lt 30)
			total_weeks = 5;
		else
			total_weeks = 6;

	if(this_weekly_offday_ eq 7)
		sonraki_gun_ = 1;
	else
		sonraki_gun_ = this_weekly_offday_ + 1;
	
	if(this_weekly_offday_ eq 1)
	{
		if(dayofweek(last_month_1) eq 2)
			hafta_start = last_month_1;
		else if(dayofweek(last_month_1) eq 1)
			hafta_start = date_add('d',-6,last_month_1);
		else
			hafta_start = date_add('d',2-dayofweek(last_month_1),last_month_1);
	}
	else
	{
		if(dayofweek(last_month_1) eq sonraki_gun_)
			hafta_start = last_month_1;
		else if(dayofweek(last_month_1) eq this_weekly_offday_)
			hafta_start = date_add('d',-6,last_month_1);
		else
			hafta_start = date_add('d',2-dayofweek(last_month_1),last_month_1);
	}

	weeks = arrayNew(2);

	// haftalara göre mesailer hesaplanır
	/*
	if(get_hr_salary.use_pdks eq 1)
		get_emp_worktimes = cfquery(datasource : "#dsn#", sqlstring : "SELECT START_DATE AS START_TIME,FINISH_DATE AS END_TIME FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND IN_OUT_ID = #get_hr_ssk.in_out_id# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30# AND (IS_WEEK_REST_DAY = 0 OR IS_WEEK_REST_DAY IS NULL) AND (IS_OFF_DAY = 0 OR IS_OFF_DAY IS NULL) ORDER BY START_DATE ASC");
	*/
	for (i=1; i lte total_weeks; i=i+1)
	{
		weeks[i][1] = date_add("ww", i-1, hafta_start); // hafta başı
		weeks[i][2] = date_add("ww", 1, weeks[i][1]); // hafta sonu
		weeks[i][2] = date_add('s', -1, weeks[i][2]);
		if (weeks[i][1] lte last_month_30)
		{
			weeks[i][3] = 0; weeks[i][4] = 0; weeks[i][5] = 0; weeks[i][6] = 0; weeks[i][7] = 0; weeks[i][8] = 0; 
			weeks[i][9] = 0; weeks[i][10] = 0; weeks[i][11] = 0; weeks[i][12] = 0; weeks[i][13] = 0; weeks[i][14] = 0;

			// hafta içi fazla mesai toplamı
			for(j=1; j lte get_emp_ext_worktimes.recordcount; j=j+1)
			{
				if ((get_emp_ext_worktimes.day_type[j] eq 0) and (get_emp_ext_worktimes.START_TIME[j] gte weeks[i][1]) and (get_emp_ext_worktimes.END_TIME[j] lt weeks[i][2]))
				{
					// bu haftanın ve hafta içi
					if(get_emp_ext_worktimes.start_time[j] eq last_month_1)
					{
						temp_kontrol = dateDiff("h",dateadd("h",1,get_emp_ext_worktimes.start_time[j]), last_month_1);
					}
					else
					{
						temp_kontrol = dateDiff("h",get_emp_ext_worktimes.start_time[j], last_month_1);
					}
					//if ((i eq 1) and (dateDiff("h",get_emp_ext_worktimes.start_time[j], last_month_1) gte 0)) // ilk hafta ve bu ayın ilk haftasında
					//normal mesa ayın ilk günü saat 00 dan baslayan kayıt girildiginde bordroda gorunmedigi icin kontrol ekledi //SG 20130607
					if ((i eq 1) and (temp_kontrol gte 0) and month(get_emp_ext_worktimes.START_TIME[j]) neq month(last_month_1)) // ilk hafta ve bu ayın ilk haftasında
					{
						temp_calc_ext_time = dateDiff("n", get_emp_ext_worktimes.start_time[j], get_emp_ext_worktimes.end_time[j]);
						if(get_active_program_parameter.extra_time_style eq 0)
						{
							weeks[i][10] = weeks[i][10] + round(temp_calc_ext_time/60);
							if ((temp_calc_ext_time mod 60 lt 30) and (temp_calc_ext_time mod 60))
								weeks[i][10] = weeks[i][10] + 0.5;
						}
						else
							weeks[i][10] = weeks[i][10] + round(temp_calc_ext_time);
					}
					else
					{
						temp_calc_ext_time = dateDiff("n", get_emp_ext_worktimes.start_time[j], get_emp_ext_worktimes.end_time[j]);
						if(get_active_program_parameter.extra_time_style eq 0)
						{
							weeks[i][5] = weeks[i][5] + round(temp_calc_ext_time/60);
							if ((temp_calc_ext_time mod 60 lt 30) and (temp_calc_ext_time mod 60)) weeks[i][5] = weeks[i][5] + 0.5;
						}
						else
							weeks[i][5] = weeks[i][5] + round(temp_calc_ext_time);
					}
				}
			}
			// hafta sonu fazla mesai toplamı
			for(j=1; j lte get_emp_ext_worktimes.recordcount; j=j+1)
			{
				if ( (get_emp_ext_worktimes.day_type[j] eq 1) and (get_emp_ext_worktimes.START_TIME[j] gte weeks[i][1]) and (get_emp_ext_worktimes.END_TIME[j] lt weeks[i][2]) )
				{
					// bu haftanın ve hafta sonu
					if ( (i eq 1) and (dateDiff("h", get_emp_ext_worktimes.start_time[j], last_month_1) gte 0) and month(get_emp_ext_worktimes.START_TIME[j]) neq month(last_month_1)) // ilk hafta ve bu ayın ilk haftasında
					{
						temp_calc_ext_time = dateDiff("n", get_emp_ext_worktimes.start_time[j], get_emp_ext_worktimes.end_time[j]);
						if(get_active_program_parameter.extra_time_style eq 0)
						{
							weeks[i][11] = weeks[i][11] + round(temp_calc_ext_time/60);
							if ((temp_calc_ext_time mod 60 lt 30) and (temp_calc_ext_time mod 60))
								weeks[i][11] = weeks[i][11] + 0.5;
						}
						else
							weeks[i][11] = weeks[i][11] + round(temp_calc_ext_time);
					}
					else
					{
						temp_calc_ext_time = dateDiff("n", get_emp_ext_worktimes.start_time[j], get_emp_ext_worktimes.end_time[j]);
						if(get_active_program_parameter.extra_time_style eq 0)
						{
							weeks[i][6] = weeks[i][6] + round(temp_calc_ext_time/60);
							if ((temp_calc_ext_time mod 60 lt 30) and (temp_calc_ext_time mod 60))
								weeks[i][6] = weeks[i][6] + 0.5;
						}
						else
							weeks[i][6] = weeks[i][6] + round(temp_calc_ext_time);
					}
				}
			}

			// resmi tatil mesai toplamı
			for(j=1; j lte get_emp_ext_worktimes.recordcount; j=j+1)
			{
				if ((get_emp_ext_worktimes.day_type[j] eq 2) and (get_emp_ext_worktimes.START_TIME[j] gte weeks[i][1]) and (get_emp_ext_worktimes.END_TIME[j] lt weeks[i][2]) )
				{
					// bu haftanın ve resmi tatil
					if ((i eq 1) and (dateDiff("h", get_emp_ext_worktimes.start_time[j], last_month_1) gte 0)  and month(get_emp_ext_worktimes.START_TIME[j]) neq month(last_month_1)) // ilk hafta ve bu ayın ilk haftasında
					{
						temp_calc_ext_time = dateDiff("n", get_emp_ext_worktimes.start_time[j], get_emp_ext_worktimes.end_time[j]);
						if(get_active_program_parameter.extra_time_style eq 0)
						{
							weeks[i][12] = weeks[i][12] + round(temp_calc_ext_time/60);
							if ((temp_calc_ext_time mod 60) and (temp_calc_ext_time mod 60 lt 30))
								weeks[i][12] = weeks[i][12] + 0.5;
						}
						else
							weeks[i][12] = weeks[i][12] + round(temp_calc_ext_time);
					}
					else
					{
						temp_calc_ext_time = dateDiff("n", get_emp_ext_worktimes.start_time[j], get_emp_ext_worktimes.end_time[j]);
						if(get_active_program_parameter.extra_time_style eq 0)
						{
							weeks[i][7] = weeks[i][7] + round(temp_calc_ext_time/60);
							if ((temp_calc_ext_time mod 60) and (temp_calc_ext_time mod 60 lt 30))
								weeks[i][7] = weeks[i][7] + 0.5;
						}
						else
							weeks[i][7] = weeks[i][7] + round(temp_calc_ext_time);
					}
				}
			}
						
			if(get_active_program_parameter.extra_time_style eq 3)
			{
				deger_list = "5,6,7,10,11,12";
				
				for (day_sira=1; day_sira lte listlen(deger_list); day_sira=day_sira+1)
				{
					day_type = listgetat(deger_list,day_sira);
					'deger_#day_type#' = wrk_round(weeks[i][day_type]/60);
					if(listlen(evaluate("deger_#day_type#"),'.') eq 2)
					{
						'tam_deger_#day_type#' = listgetat(evaluate("deger_#day_type#"),1,'.');
						'ondalik_deger_#day_type#' = listgetat(evaluate("deger_#day_type#"),2,'.');
						if(len(evaluate("ondalik_deger_#day_type#")) eq 1)
							'ondalik_deger_#day_type#' = evaluate("ondalik_deger_#day_type#") * 10;
							
						if(evaluate("ondalik_deger_#day_type#") lte 50)
						{
							'ondalik_deger_#day_type#' = 0.50;
						}
						else
						{
							'ondalik_deger_#day_type#' = 0;
							'tam_deger_#day_type#' = evaluate('tam_deger_#day_type#') + 1;
						}
					}
					else
					{
						'tam_deger_#day_type#' = evaluate("deger_#day_type#");
						'ondalik_deger_#day_type#' = 0;
					}
				}
				
				weeks[i][5] = tam_deger_5 + ondalik_deger_5;
				weeks[i][6] = tam_deger_6 + ondalik_deger_6;
				weeks[i][7] = tam_deger_7 + ondalik_deger_7;
				
				weeks[i][10] = tam_deger_10 + ondalik_deger_10;
				weeks[i][11] = tam_deger_11 + ondalik_deger_11;
				weeks[i][12] = tam_deger_12 + ondalik_deger_12;
			}
			else
			{
				weeks[i][5] = round(weeks[i][5]);
				weeks[i][6] = round(weeks[i][6]);
				weeks[i][7] = round(weeks[i][7]);
			}
			
			ext_total_hours_0 = ext_total_hours_0 + weeks[i][5];
			ext_total_hours_1 = ext_total_hours_1 + weeks[i][6];
			ext_total_hours_2 = ext_total_hours_2 + weeks[i][7];

			if(get_active_program_parameter.extra_time_style eq 0)
			{
				ext_total_hours_8 = ext_total_hours_8 + weeks[i][8];
				ext_total_hours_9 = ext_total_hours_9 + weeks[i][9];
				ext_total_hours_10 = ext_total_hours_10 + weeks[i][10];
				ext_total_hours_11 = ext_total_hours_11 + weeks[i][11];
				ext_total_hours_12 = ext_total_hours_12 + weeks[i][12];
			}

			////////////////////// toplamlar hesaplandı, fazla mesai hesaplanır
			temp_total_limit_ = (get_hours.daily_work_hours * 5) + get_hours.saturday_work_hours; // 40
			temp_total_ext_time = weeks[i][5]; //+weeks[i][7]+weeks[i][6] 20040821 %25 lik farka sadece hafta ici normal mesailer dahil edilmeli, bu yorum bana ait dolayisiyle bu hesap degisebilir.
			percent_25 = get_active_program_parameter.EX_TIME_LIMIT - temp_total_limit_;
			if(percent_25 eq 0)
				ext_total_hours_3 = ext_total_hours_3 + weeks[i][5];
			else if(i eq 1)
			{
				/*20050925 ilk hafta geçen ay son hafta cikarimi: bu ayin ilk gununun denk geldigi haftada (gecen ayin da son haftasi)
				gecen aya ait fazla mesai var ve bu deger bu haftanin fazla mesai toplamindan kucukse get_active_program_parameter.EX_TIME_LIMIT e 
				bakarak ilk haftadan dusulecek*/
				
				if (weeks[i][10] gte percent_25)
					{ext_total_hours_3 = ext_total_hours_3 + weeks[i][5];
					}
				else if((weeks[i][10] + weeks[i][5]) gte percent_25)
				{
					ext_total_hours_3 = ext_total_hours_3 + (weeks[i][10] + weeks[i][5] - percent_25);
					ext_total_hours_4 = ext_total_hours_4 + (percent_25 - weeks[i][10]);//get_active_program_parameter.EX_TIME_LIMIT (45) saate kadar olan fazla mesai
				}
				else
					ext_total_hours_4 = ext_total_hours_4 + weeks[i][5];
			}
			else
			{
				//ayin 1 den sonraki haftalari 
				if(percent_25 gte weeks[i][5])
					ext_total_hours_4 = ext_total_hours_4 + weeks[i][5];//45 saat alti
				else
				{
					ext_total_hours_4 = ext_total_hours_4 + percent_25;//tam 45 saat
					ext_total_hours_3 = ext_total_hours_3 + (weeks[i][5]-percent_25);//45 saat ustu
				}
			}

			{
				// son hafta ay sonuna kadar alınır
				if (datediff("h",last_month_30,weeks[i][2]) gt 0) weeks[i][2] = last_month_30;
				
				if (not len(get_hr_salary.use_pdks) or get_hr_salary.use_pdks eq 0 or get_hr_salary.use_pdks eq 4)
				{
					// 7 6 5 4 3 2 1 : Cts Cm Pr Çrş Sa Pts Pz
					if(this_weekly_offday_ eq 1)
						{
							if (i eq 1 and dayOfWeek(last_month_1) neq 2) // ilk hafta için ay başı haftanın ilk günü veya pazar değilse
							{
								if(dayOfWeek(last_month_1) neq 1)
									for (day_i=0; day_i lte datediff("d",last_month_1,weeks[i][2]); day_i=day_i+1)
										if (datediff('s',date_add("d",day_i,last_month_1),last_month_30) gte 0)//20041008 second farki dogru dikkat...
											if (ListFindNoCase("3,4,5,6", dayofweek(date_add("d",day_i,last_month_1)), ","))
												weeks[i][3] = weeks[i][3] + get_hours.daily_work_hours;
											
											else if (dayofweek(date_add("d",day_i,last_month_1)) eq 7)
												weeks[i][3] = weeks[i][3] + get_hours.saturday_work_hours;
												
							}
							else if ( i eq total_weeks ) // son hafta
							{
								for (day_i=0; day_i lte datediff("d",weeks[i][1],last_month_30); day_i=day_i+1)
									if (datediff('s',date_add("d",day_i,weeks[i][1]),last_month_30) gte 0) //20041008 second farki dogru dikkat...
										if (ListFindNoCase("2,3,4,5,6", dayofweek(date_add("d",day_i,weeks[i][1])), ","))
											weeks[i][3] = weeks[i][3] + get_hours.daily_work_hours;
										else if (dayofweek(date_add("d",day_i,weeks[i][1])) eq 7)
											weeks[i][3] = weeks[i][3] + get_hours.saturday_work_hours;
							}
							else //aradaki haftalar
							{
								for (day_i=0; day_i lte datediff("d",weeks[i][1],weeks[i][2]); day_i=day_i+1)
									if (datediff('s',date_add("d",day_i,weeks[i][1]),last_month_30) gte 0)//20041008 second farki dogru dikkat...
										if (ListFindNoCase("2,3,4,5,6", dayofweek(date_add("d",day_i,weeks[i][1])), ","))
											weeks[i][3] = weeks[i][3] + get_hours.daily_work_hours;
										else if (dayofweek(date_add("d",day_i,weeks[i][1])) eq 7)
											weeks[i][3] = weeks[i][3] + get_hours.saturday_work_hours;
							}
						}
					else
						{						
							
							if (i eq 1 and dayOfWeek(last_month_1) neq sonraki_gun_) // ilk hafta için ay başı haftanın ilk günü veya ht değilse
							{
								if(dayOfWeek(last_month_1) neq this_weekly_offday_)
									for (day_i=0; day_i lte datediff("d",last_month_1,weeks[i][2]); day_i=day_i+1)
										if (datediff('s',date_add("d",day_i,last_month_1),last_month_30) gte 0)//20041008 second farki dogru dikkat...
											if (not ListFindNoCase("#this_weekly_offday_#,7", dayofweek(date_add("d",day_i,last_month_1)), ","))
												weeks[i][3] = weeks[i][3] + get_hours.daily_work_hours;
											else if (dayofweek(date_add("d",day_i,last_month_1)) eq 7 and this_weekly_offday_ neq 7)
												weeks[i][3] = weeks[i][3] + get_hours.saturday_work_hours;
							}
							else if ( i eq total_weeks ) // son hafta
							{
								for (day_i=0; day_i lte datediff("d",weeks[i][1],last_month_30); day_i=day_i+1)
									if (datediff('s',date_add("d",day_i,weeks[i][1]),last_month_30) gte 0) //20041008 second farki dogru dikkat...
										if (not ListFindNoCase("#this_weekly_offday_#,7", dayofweek(date_add("d",day_i,weeks[i][1])), ","))
											weeks[i][3] = weeks[i][3] + get_hours.daily_work_hours;
										else if (dayofweek(date_add("d",day_i,weeks[i][1])) eq 7 and this_weekly_offday_ neq 7)
											weeks[i][3] = weeks[i][3] + get_hours.saturday_work_hours;
							}
							else //aradaki haftalar
							{							
								for (day_i=0; day_i lte datediff("d",weeks[i][1],weeks[i][2]); day_i=day_i+1)
									if (datediff('s',date_add("d",day_i,weeks[i][1]),last_month_30) gte 0)//20041008 second farki dogru dikkat...
										if (not ListFindNoCase("#this_weekly_offday_#,7", dayofweek(date_add("d",day_i,weeks[i][1])), ","))
											weeks[i][3] = weeks[i][3] + get_hours.daily_work_hours;
										else if (dayofweek(date_add("d",day_i,weeks[i][1])) eq 7 and this_weekly_offday_ neq 7)
											weeks[i][3] = weeks[i][3] + get_hours.saturday_work_hours;
							}
						}						
					// ücretli / ücretsiz izin hesabı
					for(j=1; j lte get_emp_offtimes.recordcount; j=j+1)
					{
						izin_startdate = date_add("h", session.ep.time_zone, get_emp_offtimes.startdate[j]); 
						izin_finishdate = date_add("h", session.ep.time_zone, get_emp_offtimes.finishdate[j]);
						temp_offtime_start = izin_startdate;
						
						//Yarım günlük
						if(get_emp_offtimes.total_hour[j] lt (get_hours.DAILY_WORK_HOURS*60))
						{
							half_total_hour = ((get_emp_offtimes.total_hour[j]/60));
							is_half_day = 1;
						}
						else
							is_half_day = 0;
						if(not (len(get_emp_offtimes.SHORT_WORKING_RATE[j]) and len(get_emp_offtimes.SHORT_WORKING_HOURS[j]))) kosul = 1;
						if(len(get_emp_offtimes.SHORT_WORKING_RATE[j]) or len(get_emp_offtimes.SHORT_WORKING_HOURS[j])) kosul = 0;

						if(datediff("h",izin_startdate,last_month_1) gte 0) izin_startdate=last_month_1;
						if(datediff("h",last_month_30,izin_finishdate) gte 0) izin_finishdate=last_month_30;	

						if(isdefined("get_active_program_parameter.FIRST_DAY_MONTH") and len(get_active_program_parameter.FIRST_DAY_MONTH) and not(get_active_program_parameter.FIRST_DAY_MONTH eq 1 and get_program_parameters.LAST_DAY_MONTH eq 0))
						{
							month_first_day = CreateDateTime(year(izin_startdate), month(izin_startdate),day(last_month_1),0,0,0);//ayın ilk günü
							
							month_last_day = CreateDateTime(year(izin_startdate), month(izin_startdate),day(last_month_30),0,0,0);//ayın son günü
							month_last_day = dateadd("m",1,month_last_day);
						}
						else{
							month_first_day = CreateDateTime(year(izin_startdate), month(izin_startdate),1,0,0,0);//ayın ilk günü
							month_last_day = CreateDateTime(year(izin_startdate), month(izin_startdate),daysinmonth(last_month_1),0,0,0);//ayın son günü
						}
						
						if((kosul eq 0 and month(temp_offtime_start) neq month(month_first_day)) or kosul eq 1)
						{ 
							if(kosul eq 0)
							{//Kısa Çalışma ise
								bir_onceki_aydan_kalan =  0;
								month_last_day_old = CreateDateTime(year(temp_offtime_start), month(temp_offtime_start),daysinmonth(temp_offtime_start),hour(temp_offtime_start),0,0);//geçmiş ayın son günü

								if(datediff("d",temp_offtime_start,month_last_day_old)+1 lte 6 and month(temp_offtime_start) eq month(izin_startdate) - 1)
								{
									arada_kalan_bu_ay = datediff("d",temp_offtime_start,month_last_day_old)+1;
									bir_onceki_aydan_kalan = 7 - arada_kalan_bu_ay;
								}
								
									
								if(len(get_emp_offtimes.SHORT_WORKING_RATE[j]))
								{
									oranlanacak_gun_izin = datediff("d",izin_startdate,izin_finishdate);//Toplam izin günü
									if(bir_onceki_aydan_kalan neq 0)
										oranlanacak_gun_izin = oranlanacak_gun_izin - bir_onceki_aydan_kalan;
									oran_tipi = 0;
									kisa_calisma_type = get_emp_offtimes.SHORT_WORKING_RATE[j];
									if(get_emp_offtimes.SHORT_WORKING_RATE[j] eq 1){//eğer kısmen 1/3 kapatılmışsa
										oranli_gun = oranlanacak_gun_izin * 2 / 3;
									}else if(get_emp_offtimes.SHORT_WORKING_RATE[j] eq 2){//eğer kısmen 2/3 kapatılmışsa
										oranli_gun = oranlanacak_gun_izin * 1 / 3;
									}else if(get_emp_offtimes.SHORT_WORKING_RATE[j] eq 3){//eğer kısmen 3/3 kapatılmışsa
										oranli_gun = oranlanacak_gun_izin * 0;
									}else if(get_emp_offtimes.SHORT_WORKING_RATE[j] eq 4){//eğer kısmen 1/2 kapatılmışsa
										oranli_gun = oranlanacak_gun_izin * 1 / 2;
									}
									kisa_calisma = 1;
									if(bir_onceki_aydan_kalan neq 0)
									{
										izin_finishdate = date_add("d",-ceiling(bir_onceki_aydan_kalan),izin_finishdate);
										
										onceki_ay_cikarilacak = 0;
										arada_kalan_sonraki = bir_onceki_aydan_kalan;
										// / 3 kapatılmışsa 4 + 3 = 7 ( 3 / 2 = 1.5 )
										if(kisa_calisma_type eq 1)
										{
											if(bir_onceki_aydan_kalan gte 3)
											{
												onceki_ay_cikarilacak = bir_onceki_aydan_kalan - 3;
												onceki_ay_cikarilacak = onceki_ay_cikarilacak + ((bir_onceki_aydan_kalan - onceki_ay_cikarilacak) / 2);
												onceki_ay_cikarilacak = bir_onceki_aydan_kalan - onceki_ay_cikarilacak;
											}
											else
											{
												onceki_ay_cikarilacak = bir_onceki_aydan_kalan / 2;
											}
										}
										//eğer kısmen 2/3 kapatılmışsa (2 + 5 = 7 ( 5 / 2 = 2.5 ))
										else if(kisa_calisma_type eq 2)
										{
											if(bir_onceki_aydan_kalan gte 5)
											{
												onceki_ay_cikarilacak = bir_onceki_aydan_kalan - 5;
												onceki_ay_cikarilacak = onceki_ay_cikarilacak + ((bir_onceki_aydan_kalan - onceki_ay_cikarilacak) / 2);
												onceki_ay_cikarilacak = bir_onceki_aydan_kalan - onceki_ay_cikarilacak;
											}
											else
											{
												onceki_ay_cikarilacak = bir_onceki_aydan_kalan / 2;
											}
										}
										//eğer kısmen 3/3(tamamen) kapatılmışsa
										else if(kisa_calisma_type eq 3)
										{
											onceki_ay_cikarilacak = bir_onceki_aydan_kalan / 2;
										}
										//eğer kısmen 1/2 kapatılmışsa //3 + 4 = 7 (4 / 2 = 2 yarım ödenecek)
										else if(kisa_calisma_type eq 4)
										{
											if(bir_onceki_aydan_kalan gte 4)
											{
												onceki_ay_cikarilacak = bir_onceki_aydan_kalan - 4;
												onceki_ay_cikarilacak = onceki_ay_cikarilacak + ((bir_onceki_aydan_kalan - onceki_ay_cikarilacak) / 2);
												onceki_ay_cikarilacak = bir_onceki_aydan_kalan - onceki_ay_cikarilacak;
											}
											else
											{
												onceki_ay_cikarilacak = bir_onceki_aydan_kalan / 2;
											}
										}
										
										if(get_emp_offtimes.SHORT_WORKING_RATE[j] neq 3)
										{
											izin_finishdate = date_add("d",-ceiling(oranli_gun),izin_finishdate);
										}
									}
									else{
										if(get_emp_offtimes.SHORT_WORKING_RATE[j] eq 3 or get_emp_offtimes.SHORT_WORKING_RATE[j] eq 4)
											izin_finishdate = date_add("d",-ceiling(oranli_gun),izin_finishdate);
										else
											izin_finishdate = date_add("d",-ceiling(oranli_gun+1),izin_finishdate);
									}
								}
								else if(len(get_emp_offtimes.SHORT_WORKING_HOURS[j]))
								{
									oranlanacak_gun_izin = datediff("d",izin_startdate,izin_finishdate)+1;//Toplam izin günü
									if(bir_onceki_aydan_kalan neq 0)
										oranlanacak_gun_izin = oranlanacak_gun_izin - bir_onceki_aydan_kalan;
									oran_tipi = 1;
									if(get_emp_offtimes.first_week_calculation[j] eq 0)//maaşın tamamını ödemiyorsa
										tam_odeme = 0;
									else
										tam_odeme = 1;
									gelen_saat = get_emp_offtimes.SHORT_WORKING_HOURS[j];//sayfadan alınacak
									oranli_gun = oranlanacak_gun_izin * gelen_saat / 45;
									if(gelen_saat eq 45)//3/3 kapatılmışsa
										oranli_gun = oranlanacak_gun_izin * 0;
									//abort("oranli_gun : #oranli_gun# oranlanacak_gun_izin #oranlanacak_gun_izin# gelen #gelen_saat#");
									kisa_calisma = 1;
									if(bir_onceki_aydan_kalan neq 0)
									{
										izin_finishdate = date_add("d",-ceiling(bir_onceki_aydan_kalan),izin_finishdate);
										
										onceki_ay_cikarilacak = 0;
										arada_kalan_sonraki = bir_onceki_aydan_kalan;

										if(gelen_saat eq 45)
										{
											onceki_ay_cikarilacak = bir_onceki_aydan_kalan / 2;
										}else{
											yedi_gun_oran = 7 - ceiling(gelen_saat * 6 / 45);
											if(bir_onceki_aydan_kalan gte yedi_gun_oran)
											{
												onceki_ay_cikarilacak = bir_onceki_aydan_kalan - yedi_gun_oran;
												onceki_ay_cikarilacak = onceki_ay_cikarilacak + ((bir_onceki_aydan_kalan - onceki_ay_cikarilacak) / 2);
												if(get_emp_offtimes.first_week_calculation[j] eq 0)//maaşın tamamını ödemiyorsa
													onceki_ay_cikarilacak = bir_onceki_aydan_kalan - onceki_ay_cikarilacak;
												else
													onceki_ay_cikarilacak = 0;
											}
											else
											{
												if(get_emp_offtimes.first_week_calculation[j] eq 0)//maaşın tamamını ödemiyorsa
													onceki_ay_cikarilacak = bir_onceki_aydan_kalan / 2;
												else
													onceki_ay_cikarilacak = 0;
											}
										}
										
										if(get_emp_offtimes.SHORT_WORKING_RATE[j] neq 3)
										{
											izin_finishdate = date_add("d",-ceiling(oranli_gun-1),izin_finishdate);
										}
									}
									else{
										izin_finishdate = date_add("d",-ceiling(oranli_gun),izin_finishdate);
									}
								}
								
							}else{
								if(get_emp_offtimes.is_paid[j] eq 0)
								{
									izin_date[j] = izin_startdate;
									izin_finish_date[j] = izin_finishdate;
								}
							}
						if ((izin_startdate lte weeks[i][2]) and (izin_finishdate gt weeks[i][1]) )
						{
							// bu hafta gunlerinden en azindan bir gunu izin gunleri icinde
							temporary_izin_total = 0;
							temporary_sunday_total = 0;
							
							if ((datediff("h",izin_startdate,weeks[i][1]) gte 0) and (datediff("h",weeks[i][2],izin_finishdate) gte 0)) 
							{
								// bu hafta hafta basindan sonra baslayan izin var veya ise giris izin suresi icine denk geliyor
								if(datediff('d',weeks[i][1],last_month_1) gte 0) //haftabasi önceki aydaysa
								{
									/*
									izin baslangic last_month_1 -bu aybasi- olur (ki bu da ya gercekten aybasidir ya da
									ilgili isyerine ise giris tarihidir, bu deger daha yukarilarda uygun sekilde set ediliyor)
									*/
									izin_startdate = last_month_1;
									temp_temp = datediff("d",last_month_1,weeks[i][2]) + 1;
								}
								else //haftabasi bu aydaysa
								{
									izin_startdate = weeks[i][1];
									temp_temp = datediff("d",weeks[i][1],weeks[i][2]) + 1;
								}
								// ay sonu hafta içinde ve izin sonraki ay başında bittiği özel durum için gerekli
								//if (hour(weeks[i][2])) temp_temp = temp_temp + 1;
								// ay sonu hafta içinde ve izin sonraki ay başında bittiği özel durum için gerekli bitti
								if(is_half_day eq 1)
									temporary_izin_total = temporary_izin_total + (half_total_hour / get_hours.SSK_WORK_HOURS);
								else
									temporary_izin_total = temporary_izin_total + temp_temp;
								
								for (k=0; k lt temp_temp; k=k+1)
								{
									temp_izin_gunu = date_add("d", k, izin_startdate);
									if (dayofweek(temp_izin_gunu) eq this_weekly_offday_)
										temporary_sunday_total = temporary_sunday_total + 1;
									else if(dayofweek(temp_izin_gunu) eq 7 and this_weekly_offday_ neq 7 and this_saturday_work_hour_ eq 0)
										temporary_sunday_total = temporary_sunday_total + 1;
									if(get_emp_offtimes.is_paid[j] eq 0)
									{
										
										if(listfindnocase(offdays_day_list,'#dateformat(temp_izin_gunu,"ddmmyyyy")#'))
										{
											offdays_count = offdays_count-1;
											
											if(dayofweek(temp_izin_gunu) eq 7 and this_saturday_work_hour_ eq 0 and this_weekly_offday_ neq 7)
												{
												offdays_sunday_count = offdays_sunday_count - 1;
												}
											if(dayofweek(temp_izin_gunu) eq this_weekly_offday_)
												{
												offdays_sunday_count = offdays_sunday_count - 1;
												}
										}
										
									}
									
									if (get_emp_offtimes.is_paid[j] eq 1) // ücretli izin ise genel tatiller çıkarılır
									{
										for (ggotrc = 1; ggotrc lte get_GENERAL_OFFTIMES.recordcount; ggotrc=ggotrc+1)
											for (ijklmn = 0; ijklmn lte datediff("d", get_GENERAL_OFFTIMES.start_date[ggotrc], get_GENERAL_OFFTIMES.FINISH_DATE[ggotrc]); ijklmn=ijklmn+1)
											{
												tempo_day = date_add("d", ijklmn, get_GENERAL_OFFTIMES.start_date[ggotrc]);
												temp_izin_gunu = createodbcdatetime(createdate(year(temp_izin_gunu),month(temp_izin_gunu),day(temp_izin_gunu)));
												if (datediff("d", temp_izin_gunu, tempo_day) eq 0) //izin günü genel tatile geliyor
												{
													temporary_izin_total = temporary_izin_total-1;
													if (dayofweek(tempo_day) eq this_weekly_offday_)
														temporary_sunday_total = temporary_sunday_total-1;
													else if(dayofweek(tempo_day) eq 7 and this_weekly_offday_ neq 7 and this_saturday_work_hour_ eq 0)
														temporary_sunday_total = temporary_sunday_total - 1;
												}
											}
									}
								}		
							}
							else if (datediff("h",izin_startdate,weeks[i][1]) gt 0) 
							{					
								// bu haftadan önce başlamış bu bu hafta içinde bitiyor
								temp_day_diff = datediff("d",weeks[i][1],izin_finishdate) + 1;
								if(is_half_day eq 1)
									temporary_izin_total = temporary_izin_total + (half_total_hour / get_hours.SSK_WORK_HOURS);
								else	
									temporary_izin_total = temporary_izin_total + temp_day_diff;
	
								for (k=0; k lt temp_day_diff; k=k+1)
								{
									temp_izin_gunu = date_add("d", k, weeks[i][1]);
									if (dayofweek(temp_izin_gunu) eq this_weekly_offday_)
										temporary_sunday_total = temporary_sunday_total + 1;
									else if(dayofweek(temp_izin_gunu) eq 7 and this_weekly_offday_ neq 7 and this_saturday_work_hour_ eq 0)
										temporary_sunday_total = temporary_sunday_total + 1;
									if(get_emp_offtimes.is_paid[j] eq 0)
									{
										if(listfindnocase(offdays_day_list,'#dateformat(temp_izin_gunu,"ddmmyyyy")#'))
										{
											offdays_count = offdays_count-1;
											
											if(dayofweek(temp_izin_gunu) eq 7 and this_saturday_work_hour_ eq 0 and this_weekly_offday_ neq 7)
												{
												offdays_sunday_count = offdays_sunday_count - 1;
												}
											if(dayofweek(temp_izin_gunu) eq this_weekly_offday_)
												{
												offdays_sunday_count = offdays_sunday_count - 1;
												}
										}
									}
	
									if (get_emp_offtimes.is_paid[j] eq 1) // ücretli izin ise genel tatiller çıkarılır
										{
											for (ggotrc = 1; ggotrc lte get_GENERAL_OFFTIMES.recordcount; ggotrc=ggotrc+1)
												for (ijklmn = 0; ijklmn lte datediff("d", get_GENERAL_OFFTIMES.start_date[ggotrc], get_GENERAL_OFFTIMES.FINISH_DATE[ggotrc]); ijklmn=ijklmn+1)
												{
													tempo_day = date_add("d", ijklmn, get_GENERAL_OFFTIMES.start_date[ggotrc]);
													temp_izin_gunu = createodbcdatetime(createdate(year(temp_izin_gunu),month(temp_izin_gunu),day(temp_izin_gunu)));
													if (datediff("d", temp_izin_gunu, tempo_day) eq 0) //izin günü genel tatile geliyor
													{
														temporary_izin_total = temporary_izin_total-1;
														if (dayofweek(tempo_day) eq this_weekly_offday_)
															temporary_sunday_total = temporary_sunday_total-1;
														else if(dayofweek(tempo_day) eq 7 and this_weekly_offday_ neq 7 and this_saturday_work_hour_ eq 0)
															temporary_sunday_total = temporary_sunday_total - 1;
													}
												}
										}
								}
							}
							else if (datediff("h",weeks[i][2],izin_finishdate) gt 0) 
							{
								// bu hafta içinde başlamış haftaya bitiyor
								temp_day_diff = datediff("d",izin_startdate,weeks[i][2]) + 1;
								if(is_half_day eq 1)
									temporary_izin_total = temporary_izin_total + (half_total_hour / get_hours.SSK_WORK_HOURS);
								else
									temporary_izin_total = temporary_izin_total + temp_day_diff;
								
								for (k=0; k lt temp_day_diff; k=k+1)
								{
									temp_izin_gunu = date_add("d", k, izin_startdate);
									if (dayofweek(temp_izin_gunu) eq this_weekly_offday_)
										temporary_sunday_total = temporary_sunday_total + 1;
									else if(dayofweek(temp_izin_gunu) eq 7 and this_weekly_offday_ neq 7 and this_saturday_work_hour_ eq 0)
										temporary_sunday_total = temporary_sunday_total + 1;
									
									if(get_emp_offtimes.is_paid[j] eq 0)
									{
										if(listfindnocase(offdays_day_list,'#dateformat(temp_izin_gunu,"ddmmyyyy")#'))
										{
											offdays_count = offdays_count-1;
											
											if(dayofweek(temp_izin_gunu) eq 7 and this_saturday_work_hour_ eq 0 and this_weekly_offday_ neq 7)
												{
												offdays_sunday_count = offdays_sunday_count - 1;
												}
											if(dayofweek(temp_izin_gunu) eq this_weekly_offday_)
												{
												offdays_sunday_count = offdays_sunday_count - 1;
												}
										}
									}
									if (get_emp_offtimes.is_paid[j] eq 1) // ücretli izin ise genel tatiller çıkarılır
										{
											for (ggotrc = 1; ggotrc lte get_GENERAL_OFFTIMES.recordcount; ggotrc=ggotrc+1)
												for (ijklmn = 0; ijklmn lte datediff("d", get_GENERAL_OFFTIMES.start_date[ggotrc], get_GENERAL_OFFTIMES.FINISH_DATE[ggotrc]); ijklmn=ijklmn+1)
												{
													tempo_day = date_add("d", ijklmn, get_GENERAL_OFFTIMES.start_date[ggotrc]);
													temp_izin_gunu = createodbcdatetime(createdate(year(temp_izin_gunu),month(temp_izin_gunu),day(temp_izin_gunu)));
													if (datediff("d", temp_izin_gunu, tempo_day) eq 0) //izin günü genel tatile geliyor
													{
														temporary_izin_total = temporary_izin_total-1;
														if (dayofweek(tempo_day) eq this_weekly_offday_)
															temporary_sunday_total = temporary_sunday_total-1;
														else if(dayofweek(tempo_day) eq 7 and this_weekly_offday_ neq 7 and this_saturday_work_hour_ eq 0)
															temporary_sunday_total = temporary_sunday_total-1;
													}
												}
										}
								}
							}
							else // hafta içinde başlamış bitmiş
							{
								temp_day_diff =datediff("d",izin_startdate,izin_finishdate) + 1;
								if(is_half_day eq 1)
									temporary_izin_total = temporary_izin_total + (half_total_hour / get_hours.SSK_WORK_HOURS);
								else
									temporary_izin_total = temporary_izin_total + temp_day_diff;
								for (k=0; k lt temp_day_diff; k=k+1)
								{
									temp_izin_gunu = date_add("d", k, izin_startdate);
									if (dayofweek(temp_izin_gunu) eq this_weekly_offday_)
										temporary_sunday_total = temporary_sunday_total + 1;
									else if(dayofweek(temp_izin_gunu) eq 7 and this_weekly_offday_ neq 7 and this_saturday_work_hour_ eq 0)
										temporary_sunday_total = temporary_sunday_total + 1;
									if(get_emp_offtimes.is_paid[j] eq 0)
									{
										if(listfindnocase(offdays_day_list,'#dateformat(temp_izin_gunu,"ddmmyyyy")#'))
										{
											offdays_count = offdays_count-1;
											
											if(dayofweek(temp_izin_gunu) eq 7 and this_saturday_work_hour_ eq 0 and this_weekly_offday_ neq 7)
												{
												offdays_sunday_count = offdays_sunday_count - 1;
												}
											if(dayofweek(temp_izin_gunu) eq this_weekly_offday_)
												{
												offdays_sunday_count = offdays_sunday_count - 1;
												}
										}
									}
									
									if(get_emp_offtimes.is_paid[j] eq 1) // ücretli izin ise genel tatiller çıkarılır
										{
											for (ggotrc = 1; ggotrc lte get_GENERAL_OFFTIMES.recordcount; ggotrc=ggotrc+1)
												for (ijklmn = 0; ijklmn lte datediff("d", get_GENERAL_OFFTIMES.start_date[ggotrc], get_GENERAL_OFFTIMES.FINISH_DATE[ggotrc]); ijklmn=ijklmn+1)
												{
													tempo_day = date_add("d", ijklmn, get_GENERAL_OFFTIMES.start_date[ggotrc]);
													temp_izin_gunu = createodbcdatetime(createdate(year(temp_izin_gunu),month(temp_izin_gunu),day(temp_izin_gunu)));
													if (datediff("d", temp_izin_gunu, tempo_day) eq 0) //izin günü genel tatile geliyor
													{
														temporary_izin_total = temporary_izin_total-1;
														if (dayofweek(tempo_day) eq this_weekly_offday_)
															temporary_sunday_total = temporary_sunday_total-1;
														else if(dayofweek(tempo_day) eq 7 and this_weekly_offday_ neq 7 and this_saturday_work_hour_ eq 0)
															temporary_sunday_total = temporary_sunday_total-1;
													}
												}
										}
								}
							}
								//}
							if (get_emp_offtimes.is_paid[j]) 
							{
								// ücretli izin ise
								weeks[i][13] = weeks[i][13] + temporary_izin_total; 
								paid_izinli_sunday_count = paid_izinli_sunday_count + temporary_sunday_total;
								is_general_offtime = 1;

								//İzin ve mazeret kategorisinden vergiye dahil seçiliyse
								if(get_emp_offtimes.included_in_tax[j] eq 1)
									included_in_tax_day_paid ++;
								else
									unincluded_in_tax_day_paid = unincluded_in_tax_day_paid + temporary_izin_total;

							}
							else
							{// ücretsiz izin ise
								weeks[i][4] = weeks[i][4] + (temporary_izin_total * get_hours.SSK_WORK_HOURS);
								izinli_sunday_count = izinli_sunday_count + temporary_sunday_total;
								if(get_emp_offtimes.ebildirge_type_id eq 1 and isdefined("attributes.ssk_statue") and attributes.ssk_statue eq 2)
								{
									report_day = report_day + weeks[i][4];
								}else if(get_emp_offtimes.ebildirge_type_id eq 21 and isdefined("attributes.ssk_statue") and attributes.ssk_statue eq 2)
								{
									unpaid_offtime = unpaid_offtime + weeks[i][4];
								}
							}
						}
						}
					}
				}
				total_hours = total_hours + weeks[i][3];
				izin_count = izin_count + weeks[i][4];
				izin_paid_count = izin_paid_count + (weeks[i][13] * get_hours.ssk_work_hours);
				//İzin ve mazeret kategorisinden vergiye dahil seçiliyse
				if(included_in_tax_day_paid gt 0)
					included_in_tax_hour_paid = included_in_tax_hour_paid + ((weeks[i][13] - unincluded_in_tax_day_paid) * get_hours.ssk_work_hours);
			}
		} 

		//izinlerden bir tanesi tum aylik izinse
		for(j=1; j lte get_emp_offtimes.recordcount; j=j+1)
		{
			izin_startdate = date_add("h", session.ep.time_zone, get_emp_offtimes.startdate[j]); 
			izin_finishdate = date_add("h", session.ep.time_zone, get_emp_offtimes.finishdate[j]);
			if((datediff("d",izin_startdate,izin_finishdate)+1) eq kisi_aydaki_gun_sayisi)
			{
				if (get_emp_offtimes.is_paid[j] eq 0) 
				{
					izin_count = kisi_aydaki_gun_sayisi * get_hours.SSK_WORK_HOURS;
					izin_paid_count = 0;
					paid_izinli_sunday_count_hour = 0;
					izinli_sunday_count_hour = 0;
					paid_izinli_sunday_count = 0;
					total_hours = 0;
					sunday_count = 0;
					offdays_count_hour = 0;
					offdays_sunday_count_hour = 0;
					offdays_count = 0;
					offdays_sunday_count = 0;
				}
				else
				{
					izin_count = 0;
					izin_paid_count = kisi_aydaki_gun_sayisi * get_hours.SSK_WORK_HOURS;
					paid_izinli_sunday_count_hour = 0;
					izinli_sunday_count_hour = 0;
					paid_izinli_sunday_count = 0;
					total_hours = 0;
					sunday_count = 0;
					offdays_count_hour = 0;
					offdays_sunday_count_hour = 0;
					offdays_count = 0;
					offdays_sunday_count = 0;
				}
			}
		}
		for(j=1; j lte get_emp_offtimes.recordcount; j=j+1)
		{
			if (get_emp_offtimes.is_paid[j] eq 0) 
			{
				if(daysinmonth(last_month_1_general) eq 28 and izin_count eq 28)
				{
					izin_count = 30;
					izin_paid_count = 0;
					paid_izinli_sunday_count_hour = 0;
					izinli_sunday_count_hour = 0;
					paid_izinli_sunday_count = 0;
					total_hours = 0;
					sunday_count = 0;
					offdays_count_hour = 0;
					offdays_sunday_count_hour = 0;
					offdays_count = 0;
					offdays_sunday_count = 0;
				}
				if(daysinmonth(last_month_1_general) eq 29 and izin_count eq 29)
				{
					izin_count = 30;
					izin_paid_count = 0;
					paid_izinli_sunday_count_hour = 0;
					izinli_sunday_count_hour = 0;
					paid_izinli_sunday_count = 0;
					total_hours = 0;
					sunday_count = 0;
					offdays_count_hour = 0;
					offdays_sunday_count_hour = 0;
					offdays_count = 0;
					offdays_sunday_count = 0;
				}
			}
			else
			{
				if(daysinmonth(last_month_1_general) eq 28 and izin_count eq 28)
				{
					izin_paid_count = 30;
					izin_count = 0;
					paid_izinli_sunday_count_hour = 0;
					izinli_sunday_count_hour = 0;
					paid_izinli_sunday_count = 0;
					total_hours = 0;
					sunday_count = 0;
					offdays_count_hour = 0;
					offdays_sunday_count_hour = 0;
					offdays_count = 0;
					offdays_sunday_count = 0;
				}
				if(daysinmonth(last_month_1_general) eq 29 and izin_count eq 29)
				{
					izin_paid_count = 30;
					izin_count = 0;
					paid_izinli_sunday_count_hour = 0;
					izinli_sunday_count_hour = 0;
					paid_izinli_sunday_count = 0;
					total_hours = 0;
					sunday_count = 0;
					offdays_count_hour = 0;
					offdays_sunday_count_hour = 0;
					offdays_count = 0;
					offdays_sunday_count = 0;
				}
			}
		}
		//izinlerden bir tanesi tum aylik izinse
	}
	
	//arge gunune dahil izinler saptanır
	for(j=1; j lte get_emp_offtimes.recordcount; j=j+1)
	{
		if(get_emp_offtimes.is_rd_ssk[j] eq 1)
		{
			izin_startdate = date_add("h", session.ep.time_zone, get_emp_offtimes.startdate[j]); 
			izin_finishdate = date_add("h", session.ep.time_zone, get_emp_offtimes.finishdate[j]);
			if(datediff("h",izin_startdate,last_month_1) gte 0) izin_startdate=last_month_1;
			if(datediff("h",last_month_30,izin_finishdate) gte 0) izin_finishdate=last_month_30;
			
			fark_ = datediff("d",izin_startdate,izin_finishdate) + 1;
			arge_izin_gunu = arge_izin_gunu + fark_;	
			if(daysinmonth(last_month_1_general) eq 28 and izin_count eq 28)
			{
				arge_izin_gunu = 30;	
			}
			if(daysinmonth(last_month_1_general) eq 29 and izin_count eq 29)
			{
				arge_izin_gunu = 30;	
			}
		}
	}
	//arge gunune dahil izinler saptanır

for(j=1; j lte get_emp_ext_worktimes.recordcount; j=j+1)// gece çalışmaları
	{
		temp_calc_ext_time = dateDiff("n",get_emp_ext_worktimes.start_time[j],get_emp_ext_worktimes.end_time[j]);
		if(get_active_program_parameter.extra_time_style eq 0)
		{
			temp_calc_ext_time = round(temp_calc_ext_time/60);
		}
		else
		{
			temp_calc_ext_time = round(temp_calc_ext_time);
		}
		
		if(get_emp_ext_worktimes.day_type[j] eq 3)
			if(month(get_emp_ext_worktimes.start_time[j]) eq month(last_month_30))/* SG 20130227  sadece ilgili aya ait gece mesaisi kayıtlarını alması icin bu kontrol eklendi*/
			ext_total_hours_5 = ext_total_hours_5 + temp_calc_ext_time;
	}
	
	// rapor izinleri
	if(get_emp_rapors.recordcount)
	{// ilk iki günü bu ay içinde ise
		active_report_izins = 0;
		
		for(emp_rapor=1;emp_rapor lte get_emp_rapors.recordcount;emp_rapor=emp_rapor+1)			
		{
			if(datediff("d",last_month_1,get_emp_rapors.STARTDATE[emp_rapor]) gte 0)
			{
				if(datediff("d",get_emp_rapors.STARTDATE[emp_rapor],get_emp_rapors.FINISHDATE[emp_rapor]) gt 0)
				{
					if(day(get_emp_rapors.STARTDATE[emp_rapor]) eq day(last_month_30_general) and month(get_emp_rapors.STARTDATE[emp_rapor]) eq month(last_month_30_general))
					{
						izin_paid_count = izin_paid_count+(get_hours.ssk_work_hours);
						active_report_izins = active_report_izins + 0.5;
					}
					else if(month(get_emp_rapors.STARTDATE[emp_rapor]) lt month(last_month_1_general) and datediff("d",get_emp_rapors.STARTDATE[emp_rapor],last_month_1_general) gte 1)
					{
						//
					}
					else if((month(get_emp_rapors.STARTDATE[emp_rapor]) neq 12 and (month(get_emp_rapors.STARTDATE[emp_rapor]) lt month(last_month_1_general)) or (month(get_emp_rapors.STARTDATE[emp_rapor]) eq 12 and get_emp_rapors.STARTDATE[emp_rapor] lt last_month_1_general)) and datediff("d",get_emp_rapors.STARTDATE[emp_rapor],last_month_1_general) eq 0)
					{
						izin_paid_count = izin_paid_count+(get_hours.ssk_work_hours);
						active_report_izins = active_report_izins + 0.5;
					}
					else
					{
						izin_paid_count = izin_paid_count+(get_hours.ssk_work_hours*2);
						active_report_izins = active_report_izins + 1;
					}
				}
				else
				{
					izin_paid_count = izin_paid_count+(get_hours.ssk_work_hours);
					active_report_izins = active_report_izins + 0.5;
				}
			}
		}
		izin_count = izin_count - (active_report_izins*2*get_hours.ssk_work_hours);
	}
	//İstirahart izinlerinde ilk gününü şirket öder seçiliyse Esma R. Uysal 10.08.2020
	if(get_emp_paid.recordcount)
	{// ilk iki günü bu ay içinde ise
		active_report_izins = 0;
		
		for(emp_rapor=1;emp_rapor lte get_emp_paid.recordcount;emp_rapor=emp_rapor+1)			
		{
			if(datediff("d",last_month_1,get_emp_paid.STARTDATE[emp_rapor]) gte 0)
			{
				if(datediff("d",get_emp_paid.STARTDATE[emp_rapor],get_emp_paid.FINISHDATE[emp_rapor]) gt 0)
				{
					if(day(get_emp_paid.STARTDATE[emp_rapor]) eq day(last_month_30_general) and month(get_emp_paid.STARTDATE[emp_rapor]) eq month(last_month_30_general))
					{
						izin_paid_count = izin_paid_count+(get_hours.ssk_work_hours);
						active_report_izins = active_report_izins + 0.5;
					}
					else if(month(get_emp_paid.STARTDATE[emp_rapor]) lt month(last_month_1_general) and datediff("d",get_emp_paid.STARTDATE[emp_rapor],last_month_1_general) gte 1)
					{
						//
					}
					else if((month(get_emp_paid.STARTDATE[emp_rapor]) neq 12 and (month(get_emp_paid.STARTDATE[emp_rapor]) lt month(last_month_1_general)) or (month(get_emp_paid.STARTDATE[emp_rapor]) eq 12 and get_emp_rapors.STARTDATE[emp_rapor] lt last_month_1_general)) and datediff("d",get_emp_rapors.STARTDATE[emp_rapor],last_month_1_general) eq 0)
					{
						izin_paid_count = izin_paid_count+(get_hours.ssk_work_hours);
						active_report_izins = active_report_izins + 0.5;
					}
					else
					{
						izin_paid_count = izin_paid_count+(get_hours.ssk_work_hours*2);
						active_report_izins = active_report_izins + 1;
					}
				}
				else
				{
					izin_paid_count = izin_paid_count+(get_hours.ssk_work_hours);
					active_report_izins = active_report_izins + 0.5;
				}
			}
		}
		izin_count = izin_count - (active_report_izins*get_hours.ssk_work_hours);
	}
	if(izin_paid_count and ssk_days lt (izin_paid_count/get_hours.ssk_work_hours)) 
		izin_paid_count = ssk_days*get_hours.ssk_work_hours; //ücretli izin bitim gününden önce calisan isten ayrilmis veya atilmissa ücretli izin günü ssk günüden fazla olmamalı	
</cfscript>

<cfif (get_hr_salary.salary_type eq 1 or get_hr_salary.salary_type eq 0) and get_hr_salary.use_pdks eq 1>
	<cfquery name="get_emp_worktimes" datasource="#dsn#">
		SELECT
		<cfif database_type is "MSSQL">
			SUM(DATEDIFF(HOUR,START_DATE,FINISH_DATE)) AS EMPLOYEES_WORKTIMES
		<cfelseif database_type is "DB2">
			SUM(SECONDSDIFF(FINISH_DATE,START_DATE)/3600) AS EMPLOYEES_WORKTIMES 
		</cfif>
		FROM EMPLOYEE_DAILY_IN_OUT
		WHERE 
			EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND 
			START_DATE >= #LAST_MONTH_1# AND 
			FINISH_DATE <= #LAST_MONTH_30# AND
			(IS_PUANTAJ_OFF IS NULL OR IS_PUANTAJ_OFF = 0) AND
			(IS_WEEK_REST_DAY = 0 OR IS_WEEK_REST_DAY IS NULL) AND 
			(IS_OFF_DAY = 0 OR IS_OFF_DAY IS NULL)
			AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0
	</cfquery>
</cfif>
<cfscript>
	if(get_hr_salary.salary_type eq 0 and get_hr_salary.use_pdks eq 1) // saatlik maaş
	{
		if (isDefined("get_emp_worktimes.recordcount") and get_emp_worktimes.recordcount gt 0)
		{
			for (i=1; i <= get_emp_worktimes.recordcount; i++)
			{
				if (isnumeric(get_emp_worktimes.EMPLOYEES_WORKTIMES[i]))
					total_hours = total_hours + get_emp_worktimes.EMPLOYEES_WORKTIMES[i];
			}

			//calisma gunu sayisi saatlik veya gunlukcunun saatlerinden alinir yoksa yukaridan default deger kalir..
			work_days = ceiling(total_hours / get_hours.ssk_work_hours);
		}
	}
	
	if(get_hr_ssk.duty_type eq 6)
	{
		if(get_hr_ssk.kismi_istihdam_gun gt 0)
		{				
			if(daysinmonth(last_month_1) eq 28)
			{
				izin_ilk = 28 - get_hr_ssk.kismi_istihdam_gun;	
			}
			else if(daysinmonth(last_month_1) eq 29)
			{
				izin_ilk = 29 - get_hr_ssk.kismi_istihdam_gun;
			}
			else
			{
				izin_ilk = ssk_days - get_hr_ssk.kismi_istihdam_gun;	
			}		

			ssk_days = (get_hr_ssk.kismi_istihdam_gun - ceiling(izin_count / get_hours.ssk_work_hours));
			work_days = ssk_days;
			//ssk_full_days = ssk_days;
			sunday_count = 0;
			offdays_count = 0;
			offdays_sunday_count = 0;
			paid_offdays_count = 0;
			izinli_sunday_count = 0;
			paid_izinli_sunday_count = 0;
			izin = ceiling(izin_count / get_hours.ssk_work_hours) + izin_ilk;
			izin_count = izin_count + (izin_ilk * get_hours.ssk_work_hours);
			izin_paid = 0;
			izin_paid_count = 0;
		}
		//SG 20130919 eklendi
		else if(get_hr_ssk.kismi_istihdam_saat gt 0)
		{				
			if(daysinmonth(last_month_1) eq 28)
			{
				izin_ilk = 28 - (get_hr_ssk.kismi_istihdam_saat / get_hours.ssk_work_hours);
			}
			else if(daysinmonth(last_month_1) eq 29)
			{
				izin_ilk = 29 - (get_hr_ssk.kismi_istihdam_saat / get_hours.ssk_work_hours);
			}
			else	
			{
				izin_ilk = ssk_days - (get_hr_ssk.kismi_istihdam_saat / get_hours.ssk_work_hours);
			}
			ssk_days = ((get_hr_ssk.kismi_istihdam_saat / get_hours.ssk_work_hours) - ceiling(izin_count / get_hours.ssk_work_hours));
			work_days = ssk_days;
			//ssk_full_days = ssk_days;
			sunday_count = 0;
			offdays_count = 0;
			offdays_sunday_count = 0;
			paid_offdays_count = 0;
			izinli_sunday_count = 0;
			paid_izinli_sunday_count = 0;
			izin = ceiling(izin_count / get_hours.ssk_work_hours) + izin_ilk;
			izin_count = izin_count + (izin_ilk * get_hours.ssk_work_hours);
			izin_paid = 0;
			izin_paid_count = 0;
			
		}
		else
		{
			izin_ilk = 0;
			ssk_days = 0;
			work_days = 0;
			ssk_full_days = 0;
			sunday_count = 0;
			izinli_sunday_count = 0;
			paid_izinli_sunday_count = 0;
			izin = 0;
			izin_count = 0;
			izin_paid = 0;
			izin_paid_count = 0;
		}
	}
// toplam saat ve izin hesaplanır
	if (izinli_sunday_count gt sunday_count)
		izinli_sunday_count = sunday_count;
	
	if (izinli_sunday_count){
		total_hours = total_hours - (izin_count - (izinli_sunday_count * get_hours.ssk_work_hours));
		//izin_count = izin_count - (izinli_sunday_count * get_hours.SSK_WORK_HOURS); Haftasonu izni
	}
	else
		total_hours = total_hours - izin_count;
	
	/*
	if(get_hr_salary.salary_type eq 0 and get_hr_salary.use_pdks neq 1) // saatlik
		{
			if(offdays_count)
				total_hours = total_hours - (offdays_count * get_hours.ssk_work_hours);
				
			if(izinli_sunday_count)
				total_hours = total_hours - (izinli_sunday_count * get_hours.ssk_work_hours);
		}
	*/
	if(get_hr_ssk.duty_type neq 6)
	{
		izin = (izin_count / get_hours.ssk_work_hours);
		izin_paid = (izin_paid_count / get_hours.ssk_work_hours);

	}

	if (izin gte aydaki_gun_sayisi)
	{
		if(get_hr_ssk.duty_type eq 6 and daysinmonth(last_month_1) eq 28 and get_hr_ssk.kismi_istihdam_gun eq 2)
		{
			izin = 26;
		}
		else if(get_hr_ssk.duty_type eq 6 and daysinmonth(last_month_1) eq 29 and get_hr_ssk.kismi_istihdam_gun eq 1)
		{
			izin = 28;
		}
		else
		{
			if(ssk_full_days eq aydaki_gun_sayisi and ssk_full_days gte 28 and ssk_full_days lt 31)
			{
				izin = 30;
			}
			else 
			{
				izin = 	ssk_full_days;
			}
			izin_count = izin * get_hours.ssk_work_hours;
			izin_sifirlandi = 1;
		}
	}
	
	if (get_hr_salary.salary_type eq 2 and get_hr_ssk.duty_type neq 6) // aylık
	{
		if(get_active_program_parameter.FULL_DAY eq 0 and daysinmonth(last_month_1_general) eq 31 and ssk_days eq 30)
		{
			total_hours = total_hours + 7.5;
		}
		//work_days = round(total_hours / get_hours.ssk_work_hours); //25052012 tekrar acildi niye kapatildigi belli degil

		work_days = work_days - izin;
		/*
		if (day(last_month_30) eq 31 and day(last_month_1) eq 1 and (not izin))
		{
			work_days = work_days - 1;
		}
		*/
		if (daysinmonth(last_month_30) lt 30 and (day(last_month_30) eq daysinmonth(last_month_30)) and day(last_month_1) eq 1 and (not izin) and work_days neq 30)
		{
			if(daysinmonth(last_month_30) lt 29) 
				work_days = work_days+2;
			else 
				work_days = work_days+1;
		}		

		//SG 20131125
		if(day(last_month_1) eq 1 and daysinmonth(last_month_1_general) eq 31 and ssk_days eq 30 and work_days eq 0 and izin gt 0 and kisa_calisma_type eq 0 and gelen_saat eq 0) // 31 ceken aylarda izin 30 gun oldugunda ssk_days in 0 olarak gelmemesi icin eklendi
		{	
			work_days = work_days + 1;
		}
		
		if (day(last_month_30) eq 31 and day(last_month_1) eq 1 and ((kisa_calisma_type neq 0 and (kisa_calisma_type neq 3 )) or (gelen_saat neq 0 and gelen_saat neq 45)))
		{
			work_days = work_days + 1;			
		}
		ssk_days = work_days;
		toplam_calisma_gunu = ssk_days;
		if(onceki_ay_cikarilacak neq 0)
			ssk_days = ssk_days - onceki_ay_cikarilacak;
			
		
	}	
	else if(get_hr_ssk.duty_type neq 6)// sendikali degilse
	{
		if(get_active_program_parameter.FULL_DAY eq 0 and get_hr_salary.salary_type eq 1 and daysinmonth(last_month_1_general) eq 28 and ssk_days eq 30)
		{
			work_days = ssk_days - 2;
		}
		if(get_active_program_parameter.FULL_DAY eq 0 and get_hr_salary.salary_type eq 1 and daysinmonth(last_month_1_general) eq 29 and ssk_days eq 30)
		{
			work_days = ssk_days - 1;
		}
		
		if(daysinmonth(last_month_1_general) eq 31 and ssk_days eq 30 and work_days eq 30 and izin gt 0)
			work_days = work_days - izin + 1;
		else if(daysinmonth(last_month_1_general) lt 30 and ssk_days eq 30 and work_days eq 30 and izin gt 0 and get_hr_ssk.duty_type eq 3)
			work_days = daysinmonth(last_month_1_general) - izin;
		else if(daysinmonth(last_month_1_general) lt 30 and ssk_days eq 30 and work_days eq 30 and izin gt 0)
			work_days = 30 - izin;
		else if (daysinmonth(last_month_1_general) eq 30 and ssk_days eq 30 and work_days eq 30 and izin gt 0)
			work_days = work_days - izin;
		else
			work_days = work_days - izin;
			
		if(work_days neq aydaki_gun_sayisi)
			ssk_days = work_days;
	}

	// avanslar hesaplanır
	if(is_avans_off_ eq 1) //akis parametrelerinden avanslar puantaja yansimasin secilirse avanslar puantaja 0 olarak yansir
	{
			avans = 0;
	}
	else
	{
		/*if ((GET_AVANS_VER.recordcount) and isnumeric(GET_AVANS_VER.AVANS_VERILEN) )
			avans = GET_AVANS_VER.AVANS_VERILEN;
		else*/
			avans = 0;
	}
	
	// sendika indirimi
	if (len(get_hr_ssk.TRADE_UNION_DEDUCTION))
		sendika_indirimi = get_hr_ssk.TRADE_UNION_DEDUCTION;
	else
		sendika_indirimi = 0;

	is_used_5510 = 0;

	// ssk işçi ve işveren yüzdeler toplanır
	if (get_hr_ssk.use_ssk eq 3) /// yabancı veya ssk kullanmıyor
	{
		ssk_isci_carpan = 0;
		ssk_isveren_carpan = 0;
		issizlik_isci_carpan = 0;
		issizlik_isveren_carpan = 0;
		hastalik_carpan = 0;
	}
	else if (get_hr_ssk.SSK_STATUTE eq 70) /// bagkur ssk kullanmıyor
	{
		ssk_isci_carpan = 0;
		ssk_isveren_carpan = 0;
		issizlik_isci_carpan = 0;
		issizlik_isveren_carpan = 0;
		hastalik_carpan = 0;
	}
	else
	{
		ssk_isveren_carpan = 0;
		hastalik_carpan = 0;
		ssk_isci_carpan = 0 + get_insurance_ratio.MOM_INSURANCE_PREMIUM_WORKER; // 0 YERİNE get_insurance_ratio.JOB_PATIENCE_PREMIUM_WORKER
		
/*		if((attributes.sal_year gt 2008 or (attributes.sal_year eq 2008 and attributes.sal_mon gt 9)))//1 ekim 2008 den itibaren 5510 sayili kanun cercevesinde 
		{
			if(len(get_hr_ssk.DANGER_DEGREE_NO))
				hastalik_carpan = (get_hr_ssk.DANGER_DEGREE_NO / 2) + 0.5; // silmeyin başka yerlerde lazım   yo 20081018
			else
				hastalik_carpan = 0;
			if(get_hr_ssk.DANGER_DEGREE eq 0) hastalik_carpan = hastalik_carpan + 0.2;
			if(get_hr_ssk.DANGER_DEGREE eq 2) hastalik_carpan = hastalik_carpan - 0.2;
			if(hastalik_carpan gt 6.5)
				hastalik_carpan = 6.5;
			if(hastalik_carpan lt 1)
				hastalik_carpan = 1;
		}
		else
		{
			hastalik_carpan = (get_hr_ssk.DANGER_DEGREE_NO / 2) + 1; // silmeyin başka yerlerde lazım   erk 20030915
			if (get_hr_ssk.DANGER_DEGREE eq 0) hastalik_carpan = hastalik_carpan + 0.2;
			if (get_hr_ssk.DANGER_DEGREE eq 2) hastalik_carpan = hastalik_carpan - 0.2;
			// isveren ücretli izin günleri icin (2 gune sirket karsilar tipteki raporlarda bu iki gunler haric) hastalık yardımı ödemez
		} 20160418 97495 id'li is MA */
		
		if(len(get_hr_ssk.DANGER_DEGREE_NO))
			hastalik_carpan = get_hr_ssk.DANGER_DEGREE_NO;
		else
			hastalik_carpan = 0;
		
		hastalik_carpan_tam = hastalik_carpan;

		if (ssk_days neq 0)
		{
			if (izin_paid gt 0)
			{
				// 20040729 eklendi : isveren hastalik kaza hesabedilirken toplam gunden dusulecek izin gunu sayisi bulunuyor (toplam ucretli izin gunlerinden raporlu -ki bu da ucretlidir- izin gunlerinin cikarilmasi durumu)
				if(get_emp_rapors.recordcount and izin_paid gte (2*get_emp_rapors.recordcount)) 
					izin_paid_ssk_isverenden_dusulecek = izin_paid - (2*get_emp_rapors.recordcount);
				else if(get_emp_paid.recordcount and izin_paid gte (get_emp_paid.recordcount))
					izin_paid_ssk_isverenden_dusulecek = izin_paid - (2*get_emp_rapors.recordcount);
				else 
					izin_paid_ssk_isverenden_dusulecek = izin_paid;
				
				izin_paid_ssk_isverenden_dusulecek = 0;
				//izin_paid_ssk_isverenden_dusulecek = izin_paid_ssk_isverenden_dusulecek  - paid_izinli_sunday_count;
				hastalik_carpan = hastalik_carpan * ((ssk_days - izin_paid_ssk_isverenden_dusulecek)/ssk_days);
				ssk_isveren_carpan = hastalik_carpan + get_insurance_ratio.MOM_INSURANCE_PREMIUM_BOSS;
			}
			else
				ssk_isveren_carpan = hastalik_carpan + get_insurance_ratio.MOM_INSURANCE_PREMIUM_BOSS;

			if((attributes.sal_year gt 2008 or (attributes.sal_year eq 2008 and attributes.sal_mon gt 9))) //1 ekim 2008 den itibaren 5510 sayili kanun cercevesinde 
			{
				if((attributes.sal_year gt 2011 or (attributes.sal_year eq 2011 and attributes.sal_mon gt 4)))
				{
					if(get_hr_ssk.sube_is_5510 eq 1 and is_687 eq 0 and law_number_7103 eq 0 and is_7252_control eq 0 and is_7256_control eq 0)//sube 5510 dan yararlaniyor fakat 687 den faydalanmıyor ise ve 7252 den yararlanmıyorsa
					{
						if(get_hr_ssk.is_5084 neq 1)
						{
							ssk_isveren_carpan = ssk_isveren_carpan - 5;// ssk isveren payi 5 puan düsülür
							is_used_5510 = 1; 
						}

						if(get_hr_ssk.SSK_STATUTE eq 5)
						{
							ssk_isveren_carpan = ssk_isveren_carpan + 5;
							is_used_5510 = 1; 
						}
					}
					if(get_hr_ssk.sube_is_5510 neq 1 and ((ssk_days gt 0 and get_hr_ssk.IS_14857 eq 1 and listfind('1,3,32',get_hr_ssk.SSK_STATUTE,',')) or (ssk_days gt 0 and (listfindnocase(get_hr_ssk.LAW_NUMBERS,'3294') and listfind('1,3,32',get_hr_ssk.SSK_STATUTE,',')))))
					{
						ssk_isveren_carpan = ssk_isveren_carpan - 5;// ssk isveren payi 5 puan düsülür
					}
				}
				else
				{
					if(get_hr_ssk.sube_is_5510 eq 1 and get_hr_ssk.is_5510 neq 1 and get_hr_ssk.is_5084 neq 1)//sube 5510 dan yararlaniyor ama kisi yararlanmiyor ise
					{
						if(not listfindnocase(get_hr_ssk.LAW_NUMBERS,'5921'))// 5921 den yararlanmiyor ise bu oran düser
						{
							ssk_isveren_carpan = ssk_isveren_carpan - 5;// ssk isveren payi 5 puan düsülür
							is_used_5510 = 1; 
						}
							
						if(get_hr_ssk.SSK_STATUTE eq 5)
						{
							ssk_isveren_carpan = ssk_isveren_carpan + 5;
							is_used_5510 = 1; 
						}
					}
				}
			}
		}
		else
			ssk_isveren_carpan = 0;
				
		if (get_hr_ssk.SSK_STATUTE neq 2 and get_hr_ssk.SSK_STATUTE neq 18) // emekli değilse işsizlik hissesi çarpanı
		{
			issizlik_isveren_carpan = get_insurance_ratio.death_insurance_boss;
			issizlik_isci_carpan = get_insurance_ratio.death_insurance_worker;
		}

		// diğer çarpanlar eklenir
		if (listfind('1,6,8,9,10,19,32',get_hr_ssk.SSK_STATUTE)) /// normal
		{
			ssk_isci_carpan = ssk_isci_carpan + get_insurance_ratio.PAT_INS_PREMIUM_WORKER + get_insurance_ratio.DEATH_INSURANCE_PREMIUM_WORKER;

			if(listfind('8,9,10,19',get_hr_ssk.SSK_STATUTE))
				malulluk_ = get_insurance_ratio.DEATH_INSURANCE_PREMIUM_BOSS_MADEN;
			else
			{
				malulluk_ = get_insurance_ratio.DEATH_INSURANCE_PREMIUM_BOSS;
				if(get_hr_ssk.SSK_STATUTE eq 32)
					malulluk_ = malulluk_ + 1.5;
				//SSK statüsü Yeraltı Sürekli ya da  Yeraltı Gruplu 
				if(get_hr_ssk.SSK_STATUTE eq 8 or get_hr_ssk.SSK_STATUTE eq 9)
					malulluk_ = malulluk_ + 3;
			}

			if((attributes.sal_year gt 2008 or (attributes.sal_year eq 2008 and attributes.sal_mon gt 9))) //1 ekim 2008 den itibaren 5510 sayili kanun cercevesinde
			{
				if(get_hr_ssk.IS_USE_506 eq 1 and len(get_hr_ssk.days_506))
				{
					malulluk_ = malulluk_ + (get_hr_ssk.days_506/60);
					ssk_isveren_carpan = ssk_isveren_carpan + get_insurance_ratio.PAT_INS_PREMIUM_BOSS + malulluk_;
				}
				else
				{
					ssk_isveren_carpan = ssk_isveren_carpan + get_insurance_ratio.PAT_INS_PREMIUM_BOSS + malulluk_;
				}
			}
			else
			{
				if(get_hr_ssk.IS_USE_506 eq 1 and len(get_hr_ssk.days_506))
				{
					malulluk_ = malulluk_ + 2;
					ssk_isveren_carpan = ssk_isveren_carpan + get_insurance_ratio.PAT_INS_PREMIUM_BOSS + malulluk_;
				}
				else
				{
					ssk_isveren_carpan = ssk_isveren_carpan + get_insurance_ratio.PAT_INS_PREMIUM_BOSS + malulluk_;
				}
			}	

			health_insurance_premium_worker_ratio = get_insurance_ratio.PAT_INS_PREMIUM_WORKER; //Hastalık Sigorta Primi İşçi Payı
			health_insurance_premium_employer_ratio = get_insurance_ratio.PAT_INS_PREMIUM_BOSS; //Hastalık Sigorta Primi İşveren Payı
			death_insurance_premium_worker_ratio = get_insurance_ratio.DEATH_INSURANCE_PREMIUM_WORKER;//Malülük, Yaşlılık, Ölüm Sigorta Primi İşçi Payı
			death_insurance_premium_employer_ratio = malulluk_;//Malülük, Yaşlılık, Ölüm Sigorta Primi İşveren Payı
		}
		else if (get_hr_ssk.SSK_STATUTE eq 2 or get_hr_ssk.SSK_STATUTE eq 18) /// emekli
		{
			issizlik_isci_carpan = 0;
			issizlik_isveren_carpan = 0;
			ssk_isci_carpan = get_insurance_ratio.SOC_SEC_INSURANCE_WORKER;
			ssk_isveren_carpan = get_insurance_ratio.SOC_SEC_INSURANCE_BOSS;
			if((attributes.sal_year gt 2008 or (attributes.sal_year eq 2008 and attributes.sal_mon gt 9))) //1 ekim 2008 den itibaren 5510 sayili kanun cercevesinde
			{
				ssk_isveren_carpan = ssk_isveren_carpan + hastalik_carpan;
			}			
		}
		else if (get_hr_ssk.SSK_STATUTE eq 5 or get_hr_ssk.SSK_STATUTE eq 12) /// yabanci veya Tüm Sigorta Kolları İşsizlik Hariç
		{
			issizlik_isci_carpan = 0;
			issizlik_isveren_carpan = 0;
			ssk_isci_carpan = ssk_isci_carpan + get_insurance_ratio.PAT_INS_PREMIUM_WORKER + get_insurance_ratio.DEATH_INSURANCE_PREMIUM_WORKER;
			malulluk_ = get_insurance_ratio.DEATH_INSURANCE_PREMIUM_BOSS;
			if((attributes.sal_year gt 2008 or (attributes.sal_year eq 2008 and attributes.sal_mon gt 9))) //1 ekim 2008 den itibaren 5510 sayili kanun cercevesinde
			{
				if(get_hr_ssk.IS_USE_506 eq 1 and len(get_hr_ssk.days_506))
				{
					malulluk_ = malulluk_ + (get_hr_ssk.days_506/60);
					ssk_isveren_carpan = ssk_isveren_carpan + get_insurance_ratio.PAT_INS_PREMIUM_BOSS + malulluk_;
				}
				else
				{
					ssk_isveren_carpan = ssk_isveren_carpan + get_insurance_ratio.PAT_INS_PREMIUM_BOSS + malulluk_;
				}
			}
			else
			{
				if(get_hr_ssk.IS_USE_506 eq 1 and len(get_hr_ssk.days_506))
				{
					malulluk_ = malulluk_ + 2;
					ssk_isveren_carpan = ssk_isveren_carpan + get_insurance_ratio.PAT_INS_PREMIUM_BOSS + malulluk_;
				}
				else
				{
					ssk_isveren_carpan = ssk_isveren_carpan + get_insurance_ratio.PAT_INS_PREMIUM_BOSS + malulluk_;
				}
			}

			health_insurance_premium_worker_ratio = get_insurance_ratio.PAT_INS_PREMIUM_WORKER; //Hastalık Sigorta Primi İşçi Payı
			health_insurance_premium_employer_ratio = get_insurance_ratio.PAT_INS_PREMIUM_BOSS; //Hastalık Sigorta Primi İşveren Payı
			death_insurance_premium_worker_ratio = get_insurance_ratio.DEATH_INSURANCE_PREMIUM_WORKER;//Malülük, Yaşlılık, Ölüm Sigorta Primi İşçi Payı
			death_insurance_premium_employer_ratio = malulluk_;//Malülük, Yaşlılık, Ölüm Sigorta Primi İşveren Payı
		}
		else if(get_hr_ssk.SSK_STATUTE eq 3 or get_hr_ssk.SSK_STATUTE eq 4 or get_hr_ssk.SSK_STATUTE eq 75) //stajyer öğrenci - çırak - mesleki stajyer ---> ssk hesaplanmaz
		{
			issizlik_isci_carpan = 0;
			issizlik_isveren_carpan = 0;

			ssk_isci_carpan = get_insurance_ratio.PAT_INS_PREMIUM_WORKER_2;
			ssk_isveren_carpan = get_insurance_ratio.PAT_INS_PREMIUM_BOSS_2;
			health_insurance_premium_worker_ratio = get_insurance_ratio.PAT_INS_PREMIUM_WORKER_2; //Hastalık Sigorta Primi İşçi Payı
			health_insurance_premium_employer_ratio = get_insurance_ratio.PAT_INS_PREMIUM_BOSS_2; //Hastalık Sigorta Primi İşveren Payı
		}
		else if (get_hr_ssk.SSK_STATUTE eq 71) /// Yabancı Uyruk Özel Anlaşma
		{
			ssk_isci_carpan = ssk_isci_carpan + get_insurance_ratio.PAT_INS_PREMIUM_WORKER + get_insurance_ratio.DEATH_INSURANCE_PREMIUM_WORKER;
			malulluk_ = get_insurance_ratio.DEATH_INSURANCE_PREMIUM_BOSS;
			if((attributes.sal_year gt 2008 or (attributes.sal_year eq 2008 and attributes.sal_mon gt 9))) //1 ekim 2008 den itibaren 5510 sayili kanun cercevesinde
			{
				if(get_hr_ssk.IS_USE_506 eq 1 and len(get_hr_ssk.days_506))
				{
					malulluk_ = malulluk_ + (get_hr_ssk.days_506/60);
					ssk_isveren_carpan = ssk_isveren_carpan + get_insurance_ratio.PAT_INS_PREMIUM_BOSS + malulluk_;
				}
				else
				{
					ssk_isveren_carpan = ssk_isveren_carpan + get_insurance_ratio.PAT_INS_PREMIUM_BOSS + malulluk_;
				}
			}
			else
			{
				if(get_hr_ssk.IS_USE_506 eq 1 and len(get_hr_ssk.days_506))
				{
					malulluk_ = malulluk_ + 2;
					ssk_isveren_carpan = ssk_isveren_carpan + get_insurance_ratio.PAT_INS_PREMIUM_BOSS + malulluk_;
				}
				else
				{
					ssk_isveren_carpan = ssk_isveren_carpan + get_insurance_ratio.PAT_INS_PREMIUM_BOSS + malulluk_;
				}
			}

			health_insurance_premium_worker_ratio = get_insurance_ratio.PAT_INS_PREMIUM_WORKER; //Hastalık Sigorta Primi İşçi Payı
			health_insurance_premium_employer_ratio = get_insurance_ratio.PAT_INS_PREMIUM_BOSS; //Hastalık Sigorta Primi İşveren Payı
			death_insurance_premium_worker_ratio = get_insurance_ratio.DEATH_INSURANCE_PREMIUM_WORKER;//Malülük, Yaşlılık, Ölüm Sigorta Primi İşçi Payı
			death_insurance_premium_employer_ratio = malulluk_;//Malülük, Yaşlılık, Ölüm Sigorta Primi İşveren Payı
		}
		else if(get_hr_ssk.SSK_STATUTE eq 21) //sozlesmesiz ulkelere goturulecek calisanlar
		{
			ssk_isci_carpan = ssk_isci_carpan + get_insurance_ratio.PAT_INS_PREMIUM_WORKER;
			ssk_isveren_carpan = ssk_isveren_carpan + get_insurance_ratio.PAT_INS_PREMIUM_BOSS;
			issizlik_isci_carpan = 0;
			issizlik_isveren_carpan = 0;

			health_insurance_premium_worker_ratio = get_insurance_ratio.PAT_INS_PREMIUM_WORKER; //Hastalık Sigorta Primi İşçi Payı
			health_insurance_premium_employer_ratio = get_insurance_ratio.PAT_INS_PREMIUM_BOSS; //Hastalık Sigorta Primi İşveren Payı
		}
	}
	short_term_premium_ratio = hastalik_carpan;
	 // bu sistem yeni istihdam kanunu ile yeniden duzenlendi yo07082008
	// YO20041015 iskurdan ozel izinle fazladan calistirilan sakatlar icin ssk isveren hisselerinin %50 si odenir, sakat_carpan 1 veya daha kucuk bir deger alir.
	if(ssk_isveren_carpan gt 0)
		ssk_isveren_carpan_tam = ssk_isveren_carpan;
	else
		ssk_isveren_carpan_tam = 0;
		
		
	ssk_isveren_carpan = ssk_isveren_carpan * sakat_carpan;
	issizlik_isveren_carpan = issizlik_isveren_carpan * sakat_carpan;

	// kümülatif gelir vergisi matrahı hesaplanır
	if (kontrol_kumulative eq 1 and kontrol_matrah neq 0)
		kumulatif_gelir = kontrol_matrah;
	else if(len(get_hr_salary.CUMULATIVE_TAX_TOTAL) and (year(get_hr_ssk.start_date) eq attributes.sal_year or get_old_payroll_count.count eq 0))
		kumulatif_gelir = get_hr_salary.CUMULATIVE_TAX_TOTAL;
	else
		kumulatif_gelir = 0;
		
		
	// varsa ihbar alınır
	if (get_last_in_out.recordcount and len(get_last_in_out.ihbar_amount) and isnumeric(get_last_in_out.ihbar_amount))
		attributes.ihbar_amount = get_last_in_out.ihbar_amount;
	else
		attributes.ihbar_amount = 0;
	// varsa kidem alınır
	if (get_last_in_out.recordcount and len(get_last_in_out.kidem_amount) and isnumeric(get_last_in_out.kidem_amount))
		attributes.kidem_amount = get_last_in_out.kidem_amount;
	else
		attributes.kidem_amount = 0;
	
	izin_netten_hesaplama = 0;
	// varsa kullanmadığı yılık izinler tutarı alınır
	if (get_last_in_out.recordcount and len(get_last_in_out.KULLANILMAYAN_IZIN_AMOUNT) and isnumeric(get_last_in_out.KULLANILMAYAN_IZIN_AMOUNT))
		if(get_last_in_out.GROSS_COUNT_TYPE eq 1)
			{
			izin_netten_hesaplama = 1;
			attributes.yillik_izin_amount = get_last_in_out.KULLANILMAYAN_IZIN_AMOUNT;
			}
		else
			{
			izin_netten_hesaplama = 0;
			attributes.yillik_izin_amount = get_last_in_out.KULLANILMAYAN_IZIN_AMOUNT;
			}
	else
		attributes.yillik_izin_amount = 0;
		




if(get_active_program_parameter.extra_time_style eq 1)
{
	if((ext_total_hours_0/60) eq (int(ext_total_hours_0/60)))
		ext_total_hours_0 = ext_total_hours_0 / 60;
	else
		{
		kalan_dakika_ = ext_total_hours_0 - (int(ext_total_hours_0/60) * 60);
		gecen_saat_ = int(ext_total_hours_0/60);
		if(kalan_dakika_ lte 15 and kalan_dakika_ gte 10)
			{kalan_dakika_ = 15;ext_total_hours_0 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lte 30 and kalan_dakika_ gte 25)
			{kalan_dakika_ = 30;ext_total_hours_0 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lte 45 and kalan_dakika_ gte 40)
			{kalan_dakika_ = 45;ext_total_hours_0 = gecen_saat_ + 0.75;}
		else if(kalan_dakika_ lte 59 and kalan_dakika_ gte 50)
			{kalan_dakika_ = 0;ext_total_hours_0 = gecen_saat_ + 1;}
		else if(kalan_dakika_ lt 15)
			{kalan_dakika_ = 0;ext_total_hours_0 = gecen_saat_;}
		else if(kalan_dakika_ lt 30)
			{kalan_dakika_ = 15;ext_total_hours_0 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lt 45)
			{kalan_dakika_ = 30;ext_total_hours_0 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lt 59)
			{kalan_dakika_ = 45;ext_total_hours_0 = gecen_saat_ + 0.75;}
		}	
	
	if((ext_total_hours_1/60) eq (int(ext_total_hours_1/60)))
		ext_total_hours_1 = ext_total_hours_1 / 60;
	else
		{
		kalan_dakika_ = ext_total_hours_1 - (int(ext_total_hours_1/60) * 60);
		gecen_saat_ = int(ext_total_hours_1/60);
		if(kalan_dakika_ lte 15 and kalan_dakika_ gte 10)
			{kalan_dakika_ = 15;ext_total_hours_1 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lte 30 and kalan_dakika_ gte 25)
			{kalan_dakika_ = 30;ext_total_hours_1 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lte 45 and kalan_dakika_ gte 40)
			{kalan_dakika_ = 45;ext_total_hours_1 = gecen_saat_ + 0.75;}
		else if(kalan_dakika_ lte 59 and kalan_dakika_ gte 50)
			{kalan_dakika_ = 0;ext_total_hours_1 = gecen_saat_ + 1;}
		else if(kalan_dakika_ lt 15)
			{kalan_dakika_ = 0;ext_total_hours_1 = gecen_saat_;}
		else if(kalan_dakika_ lt 30)
			{kalan_dakika_ = 15;ext_total_hours_1 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lt 45)
			{kalan_dakika_ = 30;ext_total_hours_1 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lt 59)
			{kalan_dakika_ = 45;ext_total_hours_1 = gecen_saat_ + 0.75;}
		}
		
	if((ext_total_hours_2/60) eq (int(ext_total_hours_2/60)))
		ext_total_hours_2 = ext_total_hours_2 / 60;
	else
		{
		kalan_dakika_ = ext_total_hours_2 - (int(ext_total_hours_2/60) * 60);
		gecen_saat_ = int(ext_total_hours_2/60);
		if(kalan_dakika_ lte 15 and kalan_dakika_ gte 10)
			{kalan_dakika_ = 15;ext_total_hours_2 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lte 30 and kalan_dakika_ gte 25)
			{kalan_dakika_ = 30;ext_total_hours_2 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lte 45 and kalan_dakika_ gte 40)
			{kalan_dakika_ = 45;ext_total_hours_2 = gecen_saat_ + 0.75;}
		else if(kalan_dakika_ lte 59 and kalan_dakika_ gte 50)
			{kalan_dakika_ = 0;ext_total_hours_2 = gecen_saat_ + 1;}
		else if(kalan_dakika_ lt 15)
			{kalan_dakika_ = 0;ext_total_hours_2 = gecen_saat_;}
		else if(kalan_dakika_ lt 30)
			{kalan_dakika_ = 15;ext_total_hours_2 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lt 45)
			{kalan_dakika_ = 30;ext_total_hours_2 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lt 59)
			{kalan_dakika_ = 45;ext_total_hours_2 = gecen_saat_ + 0.75;}
		}
	
	if((ext_total_hours_3/60) eq (int(ext_total_hours_3/60)))
		ext_total_hours_3 = ext_total_hours_3 / 60;
	else
		{
		kalan_dakika_ = ext_total_hours_3 - (int(ext_total_hours_3/60) * 60);
		gecen_saat_ = int(ext_total_hours_3/60);
		if(kalan_dakika_ lte 15 and kalan_dakika_ gte 10)
			{kalan_dakika_ = 15;ext_total_hours_3 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lte 30 and kalan_dakika_ gte 25)
			{kalan_dakika_ = 30;ext_total_hours_3 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lte 45 and kalan_dakika_ gte 40)
			{kalan_dakika_ = 45;ext_total_hours_3 = gecen_saat_ + 0.75;}
		else if(kalan_dakika_ lte 59 and kalan_dakika_ gte 50)
			{kalan_dakika_ = 0;ext_total_hours_3 = gecen_saat_ + 1;}
		else if(kalan_dakika_ lt 15)
			{kalan_dakika_ = 0;ext_total_hours_3 = gecen_saat_;}
		else if(kalan_dakika_ lt 30)
			{kalan_dakika_ = 15;ext_total_hours_3 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lt 45)
			{kalan_dakika_ = 30;ext_total_hours_3 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lt 59)
			{kalan_dakika_ = 45;ext_total_hours_3 = gecen_saat_ + 0.75;}
		}
	
	if((ext_total_hours_4/60) eq (int(ext_total_hours_4/60)))
		ext_total_hours_4 = ext_total_hours_4 / 60;
	else
		{
		kalan_dakika_ = ext_total_hours_4 - (int(ext_total_hours_4/60) * 60);
		gecen_saat_ = int(ext_total_hours_4/60);
		if(kalan_dakika_ lte 15 and kalan_dakika_ gte 10)
			{kalan_dakika_ = 15;ext_total_hours_4 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lte 30 and kalan_dakika_ gte 25)
			{kalan_dakika_ = 30;ext_total_hours_4 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lte 45 and kalan_dakika_ gte 40)
			{kalan_dakika_ = 45;ext_total_hours_4 = gecen_saat_ + 0.75;}
		else if(kalan_dakika_ lte 59 and kalan_dakika_ gte 50)
			{kalan_dakika_ = 0;ext_total_hours_4 = gecen_saat_ + 1;}
		else if(kalan_dakika_ lt 15)
			{kalan_dakika_ = 0;ext_total_hours_4 = gecen_saat_;}
		else if(kalan_dakika_ lt 30)
			{kalan_dakika_ = 15;ext_total_hours_4 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lt 45)
			{kalan_dakika_ = 30;ext_total_hours_4 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lt 59)
			{kalan_dakika_ = 45;ext_total_hours_4 = gecen_saat_ + 0.75;}
		}
		
	if((ext_total_hours_5/60) eq (int(ext_total_hours_5/60)))
		ext_total_hours_5 = ext_total_hours_5 / 60;
	else
		{
		kalan_dakika_ = ext_total_hours_5 - (int(ext_total_hours_5/60) * 60);
		gecen_saat_ = int(ext_total_hours_5/60);
		if(kalan_dakika_ lte 15 and kalan_dakika_ gte 10)
			{kalan_dakika_ = 15;ext_total_hours_5 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lte 30 and kalan_dakika_ gte 25)
			{kalan_dakika_ = 30;ext_total_hours_5 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lte 45 and kalan_dakika_ gte 40)
			{kalan_dakika_ = 45;ext_total_hours_5 = gecen_saat_ + 0.75;}
		else if(kalan_dakika_ lte 59 and kalan_dakika_ gte 50)
			{kalan_dakika_ = 0;ext_total_hours_5 = gecen_saat_ + 1;}
		else if(kalan_dakika_ lt 15)
			{kalan_dakika_ = 0;ext_total_hours_5 = gecen_saat_;}
		else if(kalan_dakika_ lt 30)
			{kalan_dakika_ = 15;ext_total_hours_5 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lt 45)
			{kalan_dakika_ = 30;ext_total_hours_5 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lt 59)
			{kalan_dakika_ = 45;ext_total_hours_5 = gecen_saat_ + 0.75;}
		}
		//---Muzaffer Bas---
	if((ext_total_hours_8/60) eq (int(ext_total_hours_8/60)))
		ext_total_hours_8 = ext_total_hours_8 / 60;
	else
		{
		kalan_dakika_ = ext_total_hours_8 - (int(ext_total_hours_8/60) * 60);
		gecen_saat_ = int(ext_total_hours_8/60);
		if(kalan_dakika_ lte 15 and kalan_dakika_ gte 10)
			{kalan_dakika_ = 15;ext_total_hours_8 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lte 30 and kalan_dakika_ gte 25)
			{kalan_dakika_ = 30;ext_total_hours_8 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lte 45 and kalan_dakika_ gte 40)
			{kalan_dakika_ = 45;ext_total_hours_8 = gecen_saat_ + 0.75;}
		else if(kalan_dakika_ lte 59 and kalan_dakika_ gte 50)
			{kalan_dakika_ = 0;ext_total_hours_8 = gecen_saat_ + 1;}
		else if(kalan_dakika_ lt 15)
			{kalan_dakika_ = 0;ext_total_hours_8 = gecen_saat_;}
		else if(kalan_dakika_ lt 30)
			{kalan_dakika_ = 15;ext_total_hours_8 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lt 45)
			{kalan_dakika_ = 30;ext_total_hours_8 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lt 59)
			{kalan_dakika_ = 45;ext_total_hours_8 = gecen_saat_ + 0.75;}
		}

	if((ext_total_hours_9/60) eq (int(ext_total_hours_9/60)))
		ext_total_hours_9 = ext_total_hours_9 / 60;
	else
		{
		kalan_dakika_ = ext_total_hours_9 - (int(ext_total_hours_9/60) * 60);
		gecen_saat_ = int(ext_total_hours_9/60);
		if(kalan_dakika_ lte 15 and kalan_dakika_ gte 10)
			{kalan_dakika_ = 15;ext_total_hours_9 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lte 30 and kalan_dakika_ gte 25)
			{kalan_dakika_ = 30;ext_total_hours_9 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lte 45 and kalan_dakika_ gte 40)
			{kalan_dakika_ = 45;ext_total_hours_9 = gecen_saat_ + 0.75;}
		else if(kalan_dakika_ lte 59 and kalan_dakika_ gte 50)
			{kalan_dakika_ = 0;ext_total_hours_9 = gecen_saat_ + 1;}
		else if(kalan_dakika_ lt 15)
			{kalan_dakika_ = 0;ext_total_hours_9 = gecen_saat_;}
		else if(kalan_dakika_ lt 30)
			{kalan_dakika_ = 15;ext_total_hours_9 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lt 45)
			{kalan_dakika_ = 30;ext_total_hours_9 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lt 59)
			{kalan_dakika_ = 45;ext_total_hours_9 = gecen_saat_ + 0.75;}
		}

	if((ext_total_hours_10/60) eq (int(ext_total_hours_10/60)))
		ext_total_hours_10 = ext_total_hours_10 / 60;
	else
		{
		kalan_dakika_ = ext_total_hours_10 - (int(ext_total_hours_10/60) * 60);
		gecen_saat_ = int(ext_total_hours_10/60);
		if(kalan_dakika_ lte 15 and kalan_dakika_ gte 10)
			{kalan_dakika_ = 15;ext_total_hours_10 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lte 30 and kalan_dakika_ gte 25)
			{kalan_dakika_ = 30;ext_total_hours_10 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lte 45 and kalan_dakika_ gte 40)
			{kalan_dakika_ = 45;ext_total_hours_10 = gecen_saat_ + 0.75;}
		else if(kalan_dakika_ lte 59 and kalan_dakika_ gte 50)
			{kalan_dakika_ = 0;ext_total_hours_10 = gecen_saat_ + 1;}
		else if(kalan_dakika_ lt 15)
			{kalan_dakika_ = 0;ext_total_hours_10 = gecen_saat_;}
		else if(kalan_dakika_ lt 30)
			{kalan_dakika_ = 15;ext_total_hours_10 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lt 45)
			{kalan_dakika_ = 30;ext_total_hours_10 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lt 59)
			{kalan_dakika_ = 45;ext_total_hours_10 = gecen_saat_ + 0.75;}
		}

	if((ext_total_hours_11/60) eq (int(ext_total_hours_11/60)))
		ext_total_hours_11 = ext_total_hours_11 / 60;
	else
		{
		kalan_dakika_ = ext_total_hours_11 - (int(ext_total_hours_11/60) * 60);
		gecen_saat_ = int(ext_total_hours_11/60);
		if(kalan_dakika_ lte 15 and kalan_dakika_ gte 10)
			{kalan_dakika_ = 15;ext_total_hours_11 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lte 30 and kalan_dakika_ gte 25)
			{kalan_dakika_ = 30;ext_total_hours_11 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lte 45 and kalan_dakika_ gte 40)
			{kalan_dakika_ = 45;ext_total_hours_11 = gecen_saat_ + 0.75;}
		else if(kalan_dakika_ lte 59 and kalan_dakika_ gte 50)
			{kalan_dakika_ = 0;ext_total_hours_11 = gecen_saat_ + 1;}
		else if(kalan_dakika_ lt 15)
			{kalan_dakika_ = 0;ext_total_hours_11 = gecen_saat_;}
		else if(kalan_dakika_ lt 30)
			{kalan_dakika_ = 15;ext_total_hours_11 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lt 45)
			{kalan_dakika_ = 30;ext_total_hours_11 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lt 59)
			{kalan_dakika_ = 45;ext_total_hours_11 = gecen_saat_ + 0.75;}
		}

	if((ext_total_hours_12/60) eq (int(ext_total_hours_12/60)))
		ext_total_hours_12 = ext_total_hours_12 / 60;
	else
		{
		kalan_dakika_ = ext_total_hours_12 - (int(ext_total_hours_12/60) * 60);
		gecen_saat_ = int(ext_total_hours_12/60);
		if(kalan_dakika_ lte 15 and kalan_dakika_ gte 10)
			{kalan_dakika_ = 15;ext_total_hours_12 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lte 30 and kalan_dakika_ gte 25)
			{kalan_dakika_ = 30;ext_total_hours_12 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lte 45 and kalan_dakika_ gte 40)
			{kalan_dakika_ = 45;ext_total_hours_12 = gecen_saat_ + 0.75;}
		else if(kalan_dakika_ lte 59 and kalan_dakika_ gte 50)
			{kalan_dakika_ = 0;ext_total_hours_12 = gecen_saat_ + 1;}
		else if(kalan_dakika_ lt 15)
			{kalan_dakika_ = 0;ext_total_hours_12 = gecen_saat_;}
		else if(kalan_dakika_ lt 30)
			{kalan_dakika_ = 15;ext_total_hours_12 = gecen_saat_ + 0.25;}
		else if(kalan_dakika_ lt 45)
			{kalan_dakika_ = 30;ext_total_hours_12 = gecen_saat_ + 0.50;}
		else if(kalan_dakika_ lt 59)
			{kalan_dakika_ = 45;ext_total_hours_12 = gecen_saat_ + 0.75;}
		}
		//---Muzaffer Bitiş---
}
else if(get_active_program_parameter.extra_time_style eq 2)
{
	ext_total_hours_0 = wrk_round(ext_total_hours_0 / 60);
	ext_total_hours_1 = wrk_round(ext_total_hours_1 / 60);
	ext_total_hours_2 = wrk_round(ext_total_hours_2 / 60);
	ext_total_hours_3 = wrk_round(ext_total_hours_3 / 60);
	ext_total_hours_4 = wrk_round(ext_total_hours_4 / 60);
	ext_total_hours_5 = wrk_round(ext_total_hours_5 / 60);
	//---Muzaffer baş---
	ext_total_hours_8 = wrk_round(ext_total_hours_8 / 60);
	ext_total_hours_9 = wrk_round(ext_total_hours_9 / 60);
	ext_total_hours_10 = wrk_round(ext_total_hours_10 / 60);
	ext_total_hours_11 = wrk_round(ext_total_hours_11 / 60);
	ext_total_hours_12 = wrk_round(ext_total_hours_12 / 60);
	//---Muzaffer Bitiş---
}
	

	if(get_hr_ssk.duty_type neq 6)
		{
		if(izin gt 0)
			if(ssk_days+izin-IZINLI_SUNDAY_COUNT gt daysinmonth(last_month_30))
			{
				fark_ = (ssk_days+izin-IZINLI_SUNDAY_COUNT) - ssk_full_days;
				ssk_days = ssk_days - fark_;
			}
		if(use_ssk neq 0) //sadece ssk lı olanlarda şubat ayında aydaki gün sayısına göre hesaplama yapmalı 90749 idli is kaydı.   
		{
			if(izin gt 0 and aydaki_gun_sayisi lt 30 and (ssk_days + izin) gte aydaki_gun_sayisi) //(ssk_days + izin-IZINLI_SUNDAY_COUNT) SG 20140217
			{
				ssk_days = aydaki_gun_sayisi - izin;
			}
		}
			if(izin gt 0 and aydaki_gun_sayisi eq 31 and ssk_days + izin lt 31 and kisi_aydaki_gun_sayisi eq aydaki_gun_sayisi)
			{
				if(((kisa_calisma_type neq 0 and kisa_calisma_type neq 3) or (gelen_saat neq 0 and gelen_saat neq 45)) or not (kisa_calisma_type neq 0 or gelen_saat neq 0))
					ssk_days = aydaki_gun_sayisi - izin;
				if(onceki_ay_cikarilacak neq 0 and ssk_days neq 0)
					ssk_days = ssk_days - onceki_ay_cikarilacak;
				if(onceki_ay_cikarilacak neq 0 and ssk_days eq 0)
					ssk_days = ssk_days + onceki_ay_cikarilacak;
			}
				
		}	
	if(((get_active_program_parameter.UNPAID_PERMISSION_TODROP_THIRTY eq 1 and get_hr_ssk.duty_type neq 3) or (get_last_in_out.recordcount AND get_active_program_parameter.UNPAID_PERMISSION_TODROP_THIRTY) or (get_last_in_out.recordcount and izin eq 30)) and (ssk_days + izin) eq 31)
	{
		ssk_days = 30 - izin;
		work_days = ssk_days;
			
		/* Senay kapattı 20130417
		27.05. tarihinde işten çıkmış birinde ssk günü 26 olarak yansıtıyor bu nedenle kapatıldı
		if(kisi_aydaki_gun_sayisi lt aydaki_gun_sayisi and aydaki_gun_sayisi eq 31 and (ssk_days + izin) eq kisi_aydaki_gun_sayisi and get_hr_ssk.duty_type neq 6)
			{
				ssk_days = ssk_days - 1;
				work_days = ssk_days;
			}
		*/	
		
	}
	if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80') or listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90') or listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95') or listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
	{	
		arge_off = 0;
		
		get_emp_arge_offdays = cfquery(datasource : "#dsn#", sqlstring : "SELECT SUM(DATEDIFF(day,START_DATE,FINISH_DATE) + 1) AS TOTAL FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30# AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0");
		if(get_emp_arge_offdays.recordcount gt 0 and len(get_emp_arge_offdays.TOTAL))
			arge_off = get_emp_arge_offdays.TOTAL;
		
		
		if(kisi_aydaki_gun_sayisi eq aydaki_gun_sayisi and (aydaki_gun_sayisi eq 28 or aydaki_gun_sayisi eq 29) and (izin_paid gt 0 or izin gt 0 or arge_off gt 0))
		{
			arge_gunu = aydaki_gun_sayisi - izin_paid - izin - arge_off + arge_izin_gunu;
		}
		else if(kisi_aydaki_gun_sayisi eq aydaki_gun_sayisi and aydaki_gun_sayisi eq 31 and (izin_paid gt 0 or izin gt 0 or arge_off gt 0))
		{
			arge_gunu = kisi_aydaki_gun_sayisi - izin_paid - izin - arge_off + arge_izin_gunu;
		}
		else
		{
			arge_gunu = ssk_days - izin_paid - izin - arge_off + arge_izin_gunu;
		}

		
		arge_gunu = 0;
		get_emp_arge_timecost = cfquery(datasource : "#dsn#", sqlstring : "SELECT RD_TIMECOST_DAY,TAX_TIMECOST_DAY FROM EMPLOYEES_PUANTAJ_TIMECOST_MONTHLY WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND SAL_MON = #attributes.sal_mon# AND SAL_YEAR = #attributes.sal_year#");
		if(get_emp_arge_timecost.recordcount)
		{
			arge_gunu = get_emp_arge_timecost.RD_TIMECOST_DAY;
			arge_gunu_tax = get_emp_arge_timecost.TAX_TIMECOST_DAY;
		}
		
		
		if(arge_gunu gt ssk_days)
			arge_gunu = ssk_days;
			
		if(arge_gunu lt 0)
			arge_gunu = 0;
			
			
		if(arge_gunu_tax gt ssk_days)
			arge_gunu_tax = ssk_days;
			
		if(arge_gunu_tax lt 0)
			arge_gunu_tax = 0;
			
		
	}
	
	if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80') or listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90') or listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95') or listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
		{
			/* kanun tam uygulamaya alininca buradaki gun degil tam gun kurali gecerli
			ssk_days = ssk_days + izin;
			izin = 0;
			
			if(len(get_hr_ssk.DAYS_5746) and ssk_days gt get_hr_ssk.DAYS_5746)
			{
				absent_days = ssk_days - get_hr_ssk.DAYS_5746 + izin;
				ssk_days = get_hr_ssk.DAYS_5746;
				work_days = get_hr_ssk.DAYS_5746;
			}
			*/
			absent_days = ssk_days - arge_gunu;
			if(absent_days lt 0)
				absent_days = 0;
		}

	if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'574690') or listfindnocase(get_hr_ssk.LAW_NUMBERS,'574680') or listfindnocase(get_hr_ssk.LAW_NUMBERS,'5746100') or listfindnocase(get_hr_ssk.LAW_NUMBERS,'574695'))
		{
			ssk_days = ssk_days + izin;
			izin = 0;
			arge_off = 0;
			get_emp_arge_offdays = cfquery(datasource : "#dsn#", sqlstring : "SELECT SUM(DATEDIFF(day,START_DATE,FINISH_DATE) + 1) AS TOTAL FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30# AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0");
			if(get_emp_arge_offdays.recordcount gt 0 and len(get_emp_arge_offdays.TOTAL))
				arge_off = get_emp_arge_offdays.TOTAL;
			
			get_emp_arge_timecost = cfquery(datasource : "#dsn#", sqlstring : "SELECT DAYS_5746 FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = #attributes.in_out_id# ");
		
			if(get_emp_arge_timecost.recordcount)
			{
				arge_gunu = get_emp_arge_timecost.DAYS_5746;
			}
			
			if(kisi_aydaki_gun_sayisi eq aydaki_gun_sayisi and (aydaki_gun_sayisi eq 28 or aydaki_gun_sayisi eq 29) and (izin_paid gt 0 or izin gt 0 or arge_off gt 0))
			{
				arge_gunu = aydaki_gun_sayisi - izin_paid - izin - arge_off + arge_izin_gunu;
			}
			else if(kisi_aydaki_gun_sayisi eq aydaki_gun_sayisi and aydaki_gun_sayisi eq 31 and (izin_paid gt 0 or izin gt 0 or arge_off gt 0))
			{
				arge_gunu = kisi_aydaki_gun_sayisi - izin_paid - izin - arge_off + arge_izin_gunu;
			}

			
			
			
			if(arge_gunu gt ssk_days)
				arge_gunu = ssk_days;
				
			if(arge_gunu lt 0)
				arge_gunu = 0;
				
			if(len(get_hr_ssk.DAYS_5746) and ssk_days gt get_hr_ssk.DAYS_5746)
			{
				absent_days = ssk_days - get_hr_ssk.DAYS_5746 + izin;
				ssk_days = get_hr_ssk.DAYS_5746;
				work_days = get_hr_ssk.DAYS_5746;
			}
		}	
	if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'4691')) //SG20151009
	{
		ssk_days = ssk_days + izin;
		izin = 0;
		if(len(get_hr_ssk.DAYS_4691) and ssk_days gt get_hr_ssk.DAYS_4691)
			{
				ssk_days = get_hr_ssk.DAYS_4691;
				work_days = get_hr_ssk.DAYS_4691;
			}
	}
	

if(get_hr_salary.use_pdks eq 1)
{	
	if(get_active_program_parameter.SSK_31_DAYS eq 0)
	{
		if(work_days gt ssk_full_days)
			work_days = ssk_full_days;
	}
	ssk_days = work_days;
}
	// sakatlık derecesine göre vergi indirimi hesaplanır
	if(get_hr_ssk.DEFECTION_STARTDATE lte parameter_last_month_30 and get_hr_ssk.DEFECTION_FINISHDATE gte parameter_last_month_1)
		defection_date_control = 1;
	else
		defection_date_control = 0;

	if (get_hr_ssk.use_tax eq 1 and defection_date_control eq 1) 
	{
		if (year(last_month_1) gte 2004)
			{// 2004 sonrası sabit miktar muhabbeti erk 20030925
				if(get_active_tax_slice.sakat_style eq 1)
				{
					if (get_hr_ssk.DEFECTION_LEVEL eq 1)
						sakatlik_indirimi = get_active_tax_slice.sakat1;
					else if (get_hr_ssk.DEFECTION_LEVEL eq 2)
						sakatlik_indirimi = get_active_tax_slice.sakat2;
					else if (get_hr_ssk.DEFECTION_LEVEL eq 3)
						sakatlik_indirimi = get_active_tax_slice.sakat3;
				}
				else
				{
					if (get_hr_ssk.DEFECTION_LEVEL eq 1)
						sakatlik_indirimi = get_active_tax_slice.sakat1 * ssk_days;
					else if (get_hr_ssk.DEFECTION_LEVEL eq 2)
						sakatlik_indirimi = get_active_tax_slice.sakat2 * ssk_days;
					else if (get_hr_ssk.DEFECTION_LEVEL eq 3)
						sakatlik_indirimi = get_active_tax_slice.sakat3 * ssk_days;
				}
			}
	}
	else
	{// doktor için sakatlik_indirimi yok
		sakatlik_indirimi = 0;
	}
		
	
	if(engelli_cocuk gt 0)
	{
		for(i=1;i lte engelli_cocuk; i=i+1)
		{
			derece_ = listgetat(engelli_cocuk_derece,i);
			indirim_ = listgetat(engelli_cocuk_indirim,i);
			
			if(indirim_ eq 1)
			{
				if(get_active_tax_slice.sakat_style eq 1)
					{
					if (derece_ eq 1)
						sakatlik_indirimi = sakatlik_indirimi + get_active_tax_slice.sakat1;
					else if (derece_ eq 2)
						sakatlik_indirimi = sakatlik_indirimi + get_active_tax_slice.sakat2;
					else if (derece_ eq 3)
						sakatlik_indirimi = sakatlik_indirimi + get_active_tax_slice.sakat3;
					}
				else
					{
					if (derece_ eq 1)
						sakatlik_indirimi = sakatlik_indirimi + (get_active_tax_slice.sakat1 * ssk_days);
					else if (derece_ eq 2)
						sakatlik_indirimi = sakatlik_indirimi + (get_active_tax_slice.sakat2 * ssk_days);
					else if (derece_ eq 3)
						sakatlik_indirimi = sakatlik_indirimi + (get_active_tax_slice.sakat3 * ssk_days);
					}
			}
		}
	}
		

	if (not listfind('1,2,3',get_hr_ssk.DEFECTION_LEVEL,',') and engelli_cocuk eq 0) 
		sakatlik_indirimi = 0;
	
	
	
	
	
	// stajyer öğrenci -cirak ise indirimler yok
	if (get_hr_ssk.SSK_STATUTE eq 3 or get_hr_ssk.SSK_STATUTE eq 4 or get_hr_ssk.SSK_STATUTE eq 75)
		{
		vergi_indirimi = 0;
		vergi_istisna = 0;
		sakatlik_indirimi = 0;
		//kumulatif_gelir = 0;
		}
		
	if(get_hr_ssk.IS_TAX_FREE eq 1)//calisan vergilerden muaf ise, bu olay yalnizca kar amaci gudulmeyen islerde calisanlar icin gecerli (bahcivan,bakici)
		{
		kumulatif_gelir = 0;
		vergi_indirimi = 0;
		vergi_istisna = 0;
		sakatlik_indirimi = 0;
		}
	
	sakatlik_indirimi_full = sakatlik_indirimi;
	
if (offdays_count lt 0)
	offdays_count = 0;
	
if(get_hr_salary.salary_type eq 0)
	{
	
		sunday_count = sunday_count - izinli_sunday_count - paid_izinli_sunday_count ;
		sunday_count_hour = sunday_count * get_hours.ssk_work_hours;
		offdays_count_hour = offdays_count * get_hours.ssk_work_hours;
		paid_izinli_sunday_count_hour = paid_izinli_sunday_count * get_hours.ssk_work_hours;

		if (work_days gt sunday_count)
			work_day_hour = (work_days - (sunday_count + paid_izinli_sunday_count)) * get_hours.ssk_work_hours; // Normal Gün Saat
		else
			work_day_hour = 0;

		if(get_hr_salary.use_pdks eq 0) //genel tatil normal gün degerinden dusulur
		{
			work_day_hour = work_day_hour -(offdays_count_hour);
		}
		work_day_hour = work_day_hour + paid_izinli_sunday_count_hour - izin_paid_count - get_half_offtimes_total_hour;
		
		
		if(izin_paid+offdays_count gte kisi_aydaki_gun_sayisi)
		{
			work_day_hour = 0;
		}
		total_hours = work_day_hour + sunday_count_hour + offdays_count_hour + izin_paid_count; // HT Saatleri
	}
	/*
		Bildirge tipi Kısa Çalışma Ödeneği İse 
		SHORT_WORKING_RATE : Haftalık çalışma saati
		FIRST_WEEK_CALCULATION : 1 => Evet, 0 => Hayır
		Not : Bu satırlar gözyaşlarıyla yazıldı...
		Esma R. Uysal 24.04.2020
	*/
	temp_ssk_days = ssk_days;
	if(get_kisa_calisma.recordcount){
		cikarilacak_gun = 0;
		for(emp_kisa=1;emp_kisa lte get_kisa_calisma.recordcount;emp_kisa=emp_kisa+1)			
		{
			if(len(get_kisa_calisma.SHORT_WORKING_RATE[emp_kisa]))
				kisa_calisma_type = get_kisa_calisma.SHORT_WORKING_RATE[emp_kisa];
			
			offtime_startdate = date_add("h", session.ep.time_zone, get_kisa_calisma.startdate[emp_kisa]); 
			offtime_finishdate = date_add("h", session.ep.time_zone, get_kisa_calisma.finishdate[emp_kisa]);
			temp_offtime_startdate = offtime_startdate;

			if(datediff("h",offtime_startdate,last_month_1) gte 0) offtime_startdate=last_month_1;
			if(datediff("h",last_month_30,offtime_finishdate) gte 0) offtime_finishdate=last_month_30;
			
			month_first_day = CreateDateTime(year(offtime_startdate), month(offtime_startdate),1,0,0,0);//ayın ilk günü
			month_last_day = CreateDateTime(year(offtime_startdate), month(offtime_startdate),daysinmonth(last_month_1),0,0,0);//ayın son günü

			//eğer çalışma ödeneğinin alındığı ilk hafta ise izin 7 günlük hesaplama
			if(month(temp_offtime_startdate) eq month(month_first_day))//İzinin ilk ayı ise
			{
				
				if(datediff("d",offtime_startdate,last_month_30)+1 lte 6)
					arada_kalan = datediff("d",offtime_startdate,offtime_finishdate)+1;
				else
					arada_kalan = 7;
				yedi_gunluk =  date_add("d", arada_kalan-1 , offtime_startdate);//7 gün sonrası 
				baslangic_izin = 0;
				bitis_izin = 0;
				if(isdefined("izin_date") and ArrayLen(izin_date))
				{
					for(izin_array=1;izin_array lte ArrayLen(izin_date);izin_array++)	
					{
						if(ArrayIsDefined(izin_date,izin_array) and len(izin_date[izin_array]) and izin_date[izin_array] gte month_first_day and izin_date[izin_array] lte offtime_startdate )
						{
							baslangic_izin = baslangic_izin + datediff("d",izin_date[izin_array],izin_finish_date[izin_array]) + 1;
						}
						if(ArrayIsDefined(izin_date,izin_array) and len(izin_date[izin_array]) and izin_date[izin_array] gte yedi_gunluk and izin_date[izin_array] lte offtime_finishdate){
							bitis_izin = bitis_izin + datediff("d",izin_date[izin_array],izin_finish_date[izin_array]) + 1;
						}
					}	

				}
				tam_gun_calisma_ilk = datediff("d",month_first_day,offtime_startdate) - baslangic_izin;//Ödeneğin başladığı gün ve ayın başlangıcı arasındaki gün farkı
				oranlanacak_gun = datediff("d", yedi_gunluk , offtime_finishdate) - bitis_izin;//bitiş tarihi ve 7 gün sonraki günün arasındaki oranlanacak fark
				gelen_saat = get_kisa_calisma.SHORT_WORKING_HOURS[emp_kisa];//sayfadan alınacak
				
				if(len(gelen_saat) AND gelen_saat NEQ 0)
				{
					oran_tipi = 1;
					if(gelen_saat eq 45)//3/3 kapatılmışsa
					{
						gelen_saat = 0;
						sunday_count = 0;
						sunday_count_hour = 0;
						offdays_count_hour = 0;
						work_day_hour = 0;
						offdays_sunday_count = 0;
					}
					calisma_oran = gelen_saat / 45; //çalışma oranı
					yedi_gun_oran = ceiling(gelen_saat * 6 / 45);//7 gümlü süreçteki çalışma oranı 6 gün üzerinden oranlanıp bir virgül bir üse yuvarlandı
					oranli_gun = oranlanacak_gun * calisma_oran;
					
					if(arada_kalan gte yedi_gun_oran)
					{
						cikarilacak_gun = arada_kalan - yedi_gun_oran;
						cikarilacak_gun = cikarilacak_gun / 2 ;//Yarım ödenecek gün sayısı
					}
					toplam_calisma_gunu = round(oranli_gun) + tam_gun_calisma_ilk + arada_kalan;

				}
				else if(len(get_kisa_calisma.SHORT_WORKING_RATE[emp_kisa]))
				{
					oran_tipi = 0;
					if(get_kisa_calisma.SHORT_WORKING_RATE[emp_kisa] eq 1){//eğer kısmen 1/3 kapatılmışsa
						oranli_gun = oranlanacak_gun * 2 / 3;
						//cikarilacak_gun = 1.5;//4 + 3 = 7 ( 3 / 2 = 1.5 )
						if(arada_kalan gte 4)
						{
							cikarilacak_gun = arada_kalan - 4;
							cikarilacak_gun = cikarilacak_gun / 2 ;
						}
					}else if(get_kisa_calisma.SHORT_WORKING_RATE[emp_kisa] eq 2){//eğer kısmen 2/3 kapatılmışsa
						oranli_gun = oranlanacak_gun * 1 / 3;
						//cikarilacak_gun = 2.5;//2 + 5 = 7 ( 5 / 2 = 2.5 )
						if(arada_kalan gte 2)
						{
							cikarilacak_gun = arada_kalan - 2;
							cikarilacak_gun = cikarilacak_gun / 2 ;
						}
					}else if(get_kisa_calisma.SHORT_WORKING_RATE[emp_kisa] eq 3){//eğer kısmen 3/3(tamamen) kapatılmışsa
						oranli_gun = oranlanacak_gun * 0;
						cikarilacak_gun = arada_kalan / 2;//3.5;//7 gun de yarım 7 / 2 = 3.5
						sunday_count = 0;
						sunday_count_hour = 0;
						offdays_count_hour = 0;
						work_day_hour = 0;
						offdays_sunday_count = 0;
					}else if(get_kisa_calisma.SHORT_WORKING_RATE[emp_kisa] eq 4){//eğer kısmen 1/2 kapatılmışsa
						oranli_gun = oranlanacak_gun * 1 / 2;
						//	cikarilacak_gun = 2;//3 + 4 = 7 (4 / 2 = 2 yarım ödenecek)
						if(arada_kalan gte 3)
						{
							cikarilacak_gun = arada_kalan - 3;
							cikarilacak_gun = cikarilacak_gun / 2 ;
						}
					}
					toplam_calisma_gunu = ceiling(oranli_gun) + tam_gun_calisma_ilk + arada_kalan;
				}
				
				//abort("#oranlanacak_gun# - #ceiling(oranli_gun)#) + #tam_gun_calisma_ilk# + #arada_kalan#");
				if(get_kisa_calisma.FIRST_WEEK_CALCULATION[emp_kisa] eq 0)//Eğer 7 günün hepsini işveren ödemezse
				{
					ssk_days = toplam_calisma_gunu - cikarilacak_gun;
					tam_odeme = 0;
				}
				else
				{
					ssk_days = toplam_calisma_gunu;
					tam_odeme = 1;
				}
				izin = izin + (aydaki_gun_sayisi- izin - toplam_calisma_gunu);
				
				izin_count = izin * get_hours.ssk_work_hours;
				kisa_calisma = 1;	
			}
		}
	}
	//16 yaşından kuçukler icin bu kontrol eklendi 20130816 SG
	if(len(get_hr_ssk.birth_date) and datediff("yyyy",get_hr_ssk.birth_date,now()) lt 16)
		{
			get_insurance.MIN_PAYMENT = get_insurance.MIN_GROSS_PAYMENT_16;
		}
	else 
		{
			get_insurance.MIN_PAYMENT = get_insurance.MIN_PAYMENT;
		}
	//SG 20141126 "83030 id li iş"  21 nolu sgk statüsüne sahip çalışanlarda sigorta matrah tavanı hesaplama  
	if(get_hr_ssk.SSK_STATUTE eq 21 or ((get_hr_ssk.ssk_statute eq 2 or get_hr_ssk.ssk_statute eq 18)  and get_hr_ssk.working_abroad eq 1)) // sozlesmesiz ulkelere goturulecek 
	{
		MAX_PAYMENT_ = get_insurance.MIN_PAYMENT*3;	
	}
	else
	{
		MAX_PAYMENT_ = get_insurance.MAX_PAYMENT;
	}
	if(get_hr_salary.salary_type eq 1 and ssk_days gte aydaki_gun_sayisi and for_ssk_day eq 0 and datediff("h",last_month_1,get_hr_ssk.start_date) neq 0)
	{
		ssk_matrah_taban = get_insurance.MIN_PAYMENT;
		ssk_matrah_tavan = MAX_PAYMENT_;
	}
	else if(get_hr_salary.salary_type eq 1 and ssk_days lt 30 and for_ssk_day eq 0)
	{
		ssk_matrah_taban = get_insurance.MIN_PAYMENT * ceiling(ssk_days) / 30;
		ssk_matrah_tavan = MAX_PAYMENT_ * ceiling(ssk_days) / 30;
		if(isdefined("toplam_calisma_gunu") and len(toplam_calisma_gunu) and toplam_calisma_gunu neq 0 and kisa_calisma_type neq 0)
		{
			ssk_matrah_taban = get_insurance.MIN_PAYMENT * ceiling(toplam_calisma_gunu) / 30;
			ssk_matrah_tavan = MAX_PAYMENT_ * ceiling(toplam_calisma_gunu) / 30;
		}

	}
	else if(get_hr_salary.salary_type eq 0 and ssk_days gt 30)
	{
		ssk_matrah_taban = get_insurance.MIN_PAYMENT;
		ssk_matrah_tavan = MAX_PAYMENT_;
	}
	else
	{
		if(ssk_full_days neq 0)
		{

			//122964 ID'li iş için eklenmiştir. ERU
			if(ssk_full_days gt 30)
				monthly_base = 30;
			else
				monthly_base = ssk_full_days;
			ssk_matrah_taban = (get_insurance.MIN_PAYMENT * ceiling(ssk_days)) / monthly_base;
			
			if(isdefined("toplam_calisma_gunu") and len(toplam_calisma_gunu) and toplam_calisma_gunu neq 0 and kisa_calisma_type neq 0)
			{
				ssk_matrah_taban = get_insurance.MIN_PAYMENT * ceiling(toplam_calisma_gunu) / monthly_base;
			}
			if(ssk_full_days eq 28 and get_active_program_parameter.ssk_days_work_days eq 1){//Şubatta (SGK gün)=(Çalışılan Gün) parametresine bağlandı.(29082019ERU)
				ssk_matrah_tavan = (MAX_PAYMENT_ * ceiling(ssk_days)) / 30;
				if(isdefined("toplam_calisma_gunu") and len(toplam_calisma_gunu) and toplam_calisma_gunu neq 0 and kisa_calisma_type neq 0)
				{
					ssk_matrah_tavan = (MAX_PAYMENT_ * ceiling(toplam_calisma_gunu)) / 30;
				}
			}
			else{
				ssk_matrah_tavan = (MAX_PAYMENT_ * ceiling(ssk_days)) / monthly_base;
				if(isdefined("toplam_calisma_gunu") and len(toplam_calisma_gunu) and toplam_calisma_gunu neq 0 and kisa_calisma_type neq 0)
				{
					ssk_matrah_tavan = (MAX_PAYMENT_ * ceiling(toplam_calisma_gunu)) / monthly_base;
				}
			}
		}
		else
		{
			ssk_matrah_taban = (get_insurance.MIN_PAYMENT * ceiling(ssk_days));
			ssk_matrah_tavan = (MAX_PAYMENT_ * ceiling(ssk_days));			
		}
	}
	if(ssk_full_days eq 31 and ssk_days eq 30)	
		ssk_matrah_tavan = MAX_PAYMENT_;
	
	if(izin_sifirlandi eq 1)
	{
		ssk_days = 0;
		work_days = 0;
		if(get_active_program_parameter.EMPLOYEES_BASE_CALC eq 0)
            ssk_matrah_tavan = MAX_PAYMENT_;
        else
            ssk_matrah_tavan = 0;
		ssk_matrah_taban = 0;
		offdays_count = 0;
		offdays_sunday_count = 0;
	}
	if(get_hr_ssk.use_ssk eq 1 and get_hr_ssk.DUTY_TYPE eq 4)//4B sözleşmeli kişilerde issizlik_isci_carpan 0 olarak uygulanıyor
	{
		issizlik_isci_carpan = 0;
		issizlik_isveren_carpan = 0;
	}
</cfscript>
<cfif (get_active_program_parameter.offtime_count_type eq 1 and get_half_offtimes.recordcount and len(get_half_offtimes_total_hour)) and get_hr_salary.salary_type neq 0>
	<cfset half_time_hour = get_half_offtimes_total_hour>
	<cfset half_time_hour_day = get_half_offtimes_total_hour / get_hours.ssk_work_hours>
<cfelse>
	<cfset half_time_hour = 0>
	<cfset half_time_hour_day = 0>
</cfif>