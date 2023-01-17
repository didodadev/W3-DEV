<cfscript>
	izin_sifirlandi = 0;
	ext_total_hours_0 = 0;  // hafta içi fazla mesai toplami
	ext_total_hours_1 = 0;  // hafta sonu fazla mesai
	ext_total_hours_2 = 0;  // resmi tatil fazla mesaileri
	ext_total_hours_3 = 0;  // 45 saati asan kisimlar toplami
	ext_total_hours_4 = 0;  // 45 saatin altinda kalam kisimlar toplami
	ext_total_hours_5 = 0;  // gece calismasi

	
    //Muzaffer ---Bas---
	ext_total_hours_8 = 0;  // 
	ext_total_hours_9 = 0;  // 
	ext_total_hours_10 = 0;  // 
	ext_total_hours_11 = 0;  // 
	ext_total_hours_12 = 0;  // 

	//Burası sonrdan sıfırlanacak!!!!!!!!!
	t_akdi_total=0;
	t_akdi_hour=0;
	t_akdi_day=0;
	//Muzaffer ---Bas---

	sunday_count = 0;
	izinli_sunday_count = 0;    	// ücretsiz izinli hafta sonlari toplami
	paid_izinli_sunday_count = 0;	// ücretli izinli hafta sonlari toplami
	izin_count = 0; // ücretsiz izin saat 
	izin_paid_count = 0; // ücretli izin saat 
	izin_paid = 0; // ücretli izin gün
	izin = 0; // ücretsiz izin gün
	ext_salary = 0;
	total_hours = 0;

// şimdilik olmayanlar erk 20030913
	gocmen_indirimi = 0;
	cocuk_parasi = 0;
	vergi_iadesi = 0;
	vergi_iade_damga_vergisi = 0;
	toplam_yuvarlama = 0;
	aydaki_gun_sayisi = datediff('d',last_month_1_general,last_month_30_general) + 1;
	kisi_aydaki_gun_sayisi = datediff('d',last_month_1,last_month_30) + 1;
	
	if (get_active_program_parameter.SSK_31_DAYS eq 1)
		{
		ssk_full_days = aydaki_gun_sayisi;
		}
	else
		ssk_full_days = 30;
		
	sakat_carpan = 1;
	
//bes carpani		
	if(get_bes.recordcount and get_bes.rate_bes neq 0)
		bes_isci_carpan = get_bes.rate_bes;
	else
		bes_isci_carpan = 0;
</cfscript>

<cfquery name="get_emp_offtimes" datasource="#dsn#">
	SELECT
		OFFTIME.TOTAL_HOURS,
		OFFTIME.STARTDATE,
		OFFTIME.FINISHDATE,
		SETUP_OFFTIME.IS_PAID,
		SETUP_OFFTIME.IS_YEARLY,
		SETUP_OFFTIME.SIRKET_GUN,
		ISNULL(INCLUDED_IN_TAX,0) INCLUDED_IN_TAX
	FROM
		OFFTIME,
		SETUP_OFFTIME
	WHERE
		OFFTIME.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
		OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
		OFFTIME.VALID = 1 AND
		OFFTIME.IS_PUANTAJ_OFF = 0 AND
		OFFTIME.STARTDATE <= #DATEADD('h',-session.ep.time_zone,last_month_30)# AND
		OFFTIME.FINISHDATE > #DATEADD('h',-session.ep.time_zone,last_month_1)# AND
		OFFTIME.IN_OUT_ID = #attributes.in_out_id#
		<!---(
			OFFTIME.IN_OUT_ID IS NULL
			OR
				(
					OFFTIME.IN_OUT_ID = #attributes.in_out_id# AND
					SETUP_OFFTIME.EBILDIRGE_TYPE_ID = '06'
				)
			OR
				(
					OFFTIME.IN_OUT_ID = #attributes.in_out_id# AND
					OFFTIME.SPECIAL_CODE IS NOT NULL
				)
		)--->
	ORDER BY
		OFFTIME.STARTDATE ASC
</cfquery>
<cfquery name="get_emp_offtimes_unpaid" datasource="#dsn#">
	SELECT
		OFFTIME.TOTAL_HOURS,
		OFFTIME.STARTDATE,
		OFFTIME.FINISHDATE,
		SETUP_OFFTIME.IS_PAID,
		SETUP_OFFTIME.IS_YEARLY,
		SETUP_OFFTIME.SIRKET_GUN,
		ISNULL(INCLUDED_IN_TAX,0) INCLUDED_IN_TAX
	FROM
		OFFTIME,
		SETUP_OFFTIME
	WHERE
		OFFTIME.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
		OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
		OFFTIME.VALID = 1 AND
		OFFTIME.IS_PUANTAJ_OFF = 0 AND
		ISNULL(SETUP_OFFTIME.IS_PAID,0) = 0 AND
		OFFTIME.STARTDATE <= #DATEADD('h',-session.ep.time_zone,last_month_30)# AND
		OFFTIME.FINISHDATE > #DATEADD('h',-session.ep.time_zone,last_month_1)# AND
		DAY(OFFTIME.STARTDATE) NOT IN(SELECT DISTINCT DAY(START_DATE) FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = OFFTIME.EMPLOYEE_ID AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30# AND IS_WEEK_REST_DAY IS NULL AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0) AND
		DAY(OFFTIME.STARTDATE) NOT IN
		(
		SELECT
			DISTINCT DAY(OFFTIME.STARTDATE)
		FROM
			OFFTIME,
			SETUP_OFFTIME
		WHERE
			OFFTIME.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
			OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
			OFFTIME.VALID = 1 AND
			OFFTIME.IS_PUANTAJ_OFF = 0 AND
			ISNULL(SETUP_OFFTIME.IS_PAID,0) = 1 AND
			OFFTIME.STARTDATE <= #DATEADD('h',-session.ep.time_zone,last_month_30)# AND
			OFFTIME.FINISHDATE > #DATEADD('h',-session.ep.time_zone,last_month_1)# AND
			(
				OFFTIME.IN_OUT_ID IS NULL
				OR
					(
						OFFTIME.IN_OUT_ID = #attributes.in_out_id# AND
						SETUP_OFFTIME.EBILDIRGE_TYPE_ID = '06'
					)
				OR
					(
						OFFTIME.IN_OUT_ID = #attributes.in_out_id# AND
						OFFTIME.SPECIAL_CODE IS NOT NULL
					)
			)
		) AND
		(
			OFFTIME.IN_OUT_ID IS NULL
			OR
				(
					OFFTIME.IN_OUT_ID = #attributes.in_out_id# AND
					SETUP_OFFTIME.EBILDIRGE_TYPE_ID = '06'
				)
			OR
				(
					OFFTIME.IN_OUT_ID = #attributes.in_out_id# AND
					OFFTIME.SPECIAL_CODE IS NOT NULL
				)
		)
</cfquery>
<cfquery name="get_emp_offtimes_paid" datasource="#dsn#">
	SELECT
		OFFTIME.TOTAL_HOURS,
		OFFTIME.STARTDATE,
		OFFTIME.FINISHDATE,
		SETUP_OFFTIME.IS_PAID,
		SETUP_OFFTIME.IS_YEARLY,
		SETUP_OFFTIME.SIRKET_GUN,
		ISNULL(INCLUDED_IN_TAX,0) INCLUDED_IN_TAX
	FROM
		OFFTIME,
		SETUP_OFFTIME
	WHERE
		OFFTIME.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
		(
			(
			OFFTIME.SUB_OFFTIMECAT_ID = 0 AND
			OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
			)
			OR
			OFFTIME.SUB_OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
		) AND
		OFFTIME.VALID = 1 AND
		OFFTIME.IS_PUANTAJ_OFF = 0 AND
		ISNULL(SETUP_OFFTIME.IS_PAID,0) = 1 AND
		OFFTIME.STARTDATE <= #DATEADD('h',-session.ep.time_zone,last_month_30)# AND
		OFFTIME.FINISHDATE > #DATEADD('h',-session.ep.time_zone,last_month_1)# AND
		DAY(OFFTIME.STARTDATE) IN (SELECT DISTINCT DAY(START_DATE) FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = OFFTIME.EMPLOYEE_ID AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30# AND IS_WEEK_REST_DAY IS NULL AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0) AND
		(
			OFFTIME.IN_OUT_ID IS NULL
			OR
				(
					OFFTIME.IN_OUT_ID = #attributes.in_out_id# AND
					SETUP_OFFTIME.EBILDIRGE_TYPE_ID = '06'
				)
			OR
				(
					OFFTIME.IN_OUT_ID = #attributes.in_out_id# AND
					OFFTIME.SPECIAL_CODE IS NOT NULL
				)
		)
</cfquery>

<cfset get_half_offtimes.recordcount = 0>
<cfset get_half_offtimes_total_hour = 0>
<cfquery name="get_emp_rapors" dbtype="query">
	SELECT 
		* 
	FROM 
		get_emp_offtimes
	WHERE 
		SIRKET_GUN > 0
	ORDER BY 
		STARTDATE ASC
</cfquery>
<cfquery name="get_emp_ext_worktimes" datasource="#dsn#">
	SELECT START_TIME, END_TIME, DAY_TYPE FROM EMPLOYEES_EXT_WORKTIMES
	WHERE 
	<cfif isdefined("attributes.in_out_id")>IN_OUT_ID = #attributes.in_out_id# AND</cfif>
	EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND 
	START_TIME >= #DATEADD('ww',-1,last_month_1)# 
	AND END_TIME < #last_month_30# AND
	MONTH(START_TIME) = #attributes.sal_mon# AND
	(
	(IS_FROM_PDKS = 0 OR IS_FROM_PDKS IS NULL)
	OR
	(IS_FROM_PDKS = 1 AND VALID = 1)
	)
	<cfif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1>
		AND IS_PUANTAJ_OFF = 1
	<cfelse>
		AND (IS_PUANTAJ_OFF IS NULL OR IS_PUANTAJ_OFF = 0)
	</cfif>
	ORDER BY START_TIME ASC
</cfquery>
<cfscript>
		ucretli_izin_dakika = 0;
		ucretsiz_izin_dakika = 0;
		ucretli_izin_gun = 0;
		ucretsiz_izin_gun = 0;
		active_day_list = '';
		
		// Normal Çalışma Günleri
	/*get_emp_worktimes = cfquery(datasource : "#dsn#", sqlstring : "SELECT SUM(DATEDIFF(MINUTE,START_DATE,FINISH_DATE)) AS EMPLOYEES_WORKTIMES FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND IN_OUT_ID = #get_hr_ssk.in_out_id# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30# AND IS_WEEK_REST_DAY IS NULL AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0  AND DAY_TYPE = -5");*/
		get_emp_worktimes = cfquery(datasource : "#dsn#", sqlstring : "SELECT SUM(DATEDIFF(MINUTE,START_DATE,FINISH_DATE)) AS EMPLOYEES_WORKTIMES FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND IN_OUT_ID = #get_hr_ssk.in_out_id# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30#  AND  IS_AKDI_DAY NOT IN (1) AND DAY_TYPE=-5 AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0");
		
		total_hours = get_emp_worktimes.EMPLOYEES_WORKTIMES;
		/*
		get_emp_worktimes_days =  cfquery(datasource : "#dsn#", sqlstring : "SELECT DISTINCT DAY(START_DATE) AS GUN FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND IN_OUT_ID = #get_hr_ssk.in_out_id# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30# AND IS_WEEK_REST_DAY IS NULL AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0 AND DAY_TYPE = -5");
		get_emp_worktimes_days_ht =  cfquery(datasource : "#dsn#", sqlstring : "SELECT DISTINCT DAY(START_DATE) AS GUN FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND IN_OUT_ID = #get_hr_ssk.in_out_id# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30# AND IS_WEEK_REST_DAY IS NOT NULL AND IS_WEEK_REST_DAY = 0 AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0  AND DAY_TYPE = -6");
		get_emp_worktimes_days_gt =  cfquery(datasource : "#dsn#", sqlstring : "SELECT DISTINCT DAY(START_DATE) AS GUN FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND IN_OUT_ID = #get_hr_ssk.in_out_id# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30# AND IS_WEEK_REST_DAY IS NOT NULL AND IS_WEEK_REST_DAY = 1 AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0  AND DAY_TYPE = -7");
		*/
		get_emp_worktimes_days =  cfquery(datasource : "#dsn#", sqlstring : "SELECT DISTINCT DAY(START_DATE) AS GUN FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND IN_OUT_ID = #get_hr_ssk.in_out_id# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30# AND DAY_TYPE NOT IN(-6,-7) AND  IS_AKDI_DAY NOT IN (1)  AND DAY_TYPE=-5 AND  ISNULL(FROM_HOURLY_ADDFARE,0) = 0");
		get_emp_worktimes_days_ht =  cfquery(datasource : "#dsn#", sqlstring : "SELECT DISTINCT DAY(START_DATE) AS GUN FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND IN_OUT_ID = #get_hr_ssk.in_out_id# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30#  AND DAY_TYPE=-6  AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0 ");
		get_emp_worktimes_days_gt =  cfquery(datasource : "#dsn#", sqlstring : "SELECT DISTINCT DAY(START_DATE) AS GUN FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND IN_OUT_ID = #get_hr_ssk.in_out_id# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30#  AND DAY_TYPE=-7 AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0 ");		
		
		if(get_emp_worktimes_days.recordcount)
			active_day_list = valuelist(get_emp_worktimes_days.GUN);
		
		if(not isnumeric(total_hours)) 
			total_hours = 0;
		
		for(j=1; j lte get_emp_offtimes.recordcount; j=j+1)
		{
			izin_startdate = date_add("h", session.ep.time_zone, get_emp_offtimes.startdate[j]); 
			izin_finishdate = date_add("h", session.ep.time_zone, get_emp_offtimes.finishdate[j]);
			temp_day_diff = datediff("n",izin_startdate,izin_finishdate);

			if (get_emp_offtimes.is_paid[j] eq 1 or get_emp_offtimes.sirket_gun[j] gt 0)
			{
				ucretli_izin_dakika = ucretli_izin_dakika + temp_day_diff;
				if(not listfindnocase(active_day_list,day(get_emp_offtimes.startdate[j])))
				{
					ucretli_izin_gun = ucretli_izin_gun + 1;
					active_day_list = listappend(active_day_list,day(get_emp_offtimes.startdate[j]));
					if(get_emp_offtimes.included_in_tax[j] eq 1)
					{
						included_in_tax_day_paid = included_in_tax_day_paid + 1;
						
					}
						
				}
			}
			else
			{
				ucretsiz_izin_dakika = ucretsiz_izin_dakika + temp_day_diff;
				if(not listfindnocase(active_day_list,day(get_emp_offtimes.startdate[j])))
				{
					ucretsiz_izin_gun = ucretsiz_izin_gun + 1;
					active_day_list = listappend(active_day_list,day(get_emp_offtimes.startdate[j]));
				}
			}
		}
		if(included_in_tax_day_paid gt 0)
			included_in_tax_hour_paid = (included_in_tax_day_paid * get_hours.ssk_work_hours);
		if(total_hours gt 0)
		{
			total_hours = wrk_round(get_emp_worktimes.EMPLOYEES_WORKTIMES / 60,2);
			work_days = get_emp_worktimes_days.recordcount;
		}
		else
			work_days = 0;

		if(ucretli_izin_dakika gt 0)
		{
			izin_paid_count = wrk_round(ucretli_izin_dakika / 60,2);
			izin_paid = ucretli_izin_gun;
			if(get_emp_offtimes.included_in_tax[j] eq 1)
				included_in_tax_hour_paid = included_in_tax_hour_paid;
		}		
		else
			izin_paid = 0;
			
		if(ucretsiz_izin_dakika gt 0)
		{
			izin_count = wrk_round(ucretsiz_izin_dakika / 60,2);
			izin = ucretsiz_izin_gun;
		}		
		else
			izin = 0;
			
        /*
		// Hafta Tatilleri
		get_emp_worktimes = cfquery(datasource : "#dsn#", sqlstring : "SELECT START_DATE AS START_TIME,FINISH_DATE AS END_TIME FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND IN_OUT_ID = #get_hr_ssk.in_out_id# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30# AND IS_WEEK_REST_DAY = 0 AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0 ORDER BY START_DATE ASC");
		get_emp_worktimes_hours = cfquery(datasource : "#dsn#", sqlstring : "SELECT SUM(DATEDIFF(MINUTE,START_DATE,FINISH_DATE)) AS EMPLOYEES_WORKTIMES FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND IN_OUT_ID = #get_hr_ssk.in_out_id# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30# AND IS_WEEK_REST_DAY = 0 AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0");
		sunday_count = get_emp_worktimes.recordcount;
		if(len(get_emp_worktimes_hours.EMPLOYEES_WORKTIMES))
		sunday_count_hour = wrk_round(get_emp_worktimes_hours.EMPLOYEES_WORKTIMES / 60);
		
		// Genel Tatiller
		offdays_count_hour = 0;
		get_emp_worktimes = cfquery(datasource : "#dsn#", sqlstring : "SELECT START_DATE AS START_TIME,FINISH_DATE AS END_TIME FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND IN_OUT_ID = #get_hr_ssk.in_out_id# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30# AND IS_WEEK_REST_DAY = 1 AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0 ORDER BY START_DATE ASC");
		get_emp_worktimes_hours = cfquery(datasource : "#dsn#", sqlstring : "SELECT SUM(DATEDIFF(MINUTE,START_DATE,FINISH_DATE)) AS EMPLOYEES_WORKTIMES FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND IN_OUT_ID = #get_hr_ssk.in_out_id# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30# AND IS_WEEK_REST_DAY = 1 AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0");		
		*/
		// Hafta Tatilleri
		get_emp_worktimes = cfquery(datasource : "#dsn#", sqlstring : "SELECT START_DATE AS START_TIME,FINISH_DATE AS END_TIME FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND IN_OUT_ID = #get_hr_ssk.in_out_id# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30# AND DAY_TYPE=-6 AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0 ORDER BY START_DATE ASC");
		get_emp_worktimes_hours = cfquery(datasource : "#dsn#", sqlstring : "SELECT SUM(DATEDIFF(MINUTE,START_DATE,FINISH_DATE)) AS EMPLOYEES_WORKTIMES FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND IN_OUT_ID = #get_hr_ssk.in_out_id# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30# AND DAY_TYPE=-6 AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0");		

		if(len(get_emp_worktimes_hours.EMPLOYEES_WORKTIMES))
		sunday_count_hour = wrk_round(get_emp_worktimes_hours.EMPLOYEES_WORKTIMES / 60);
		sunday_count = get_emp_worktimes.recordcount;
	
		//---Akdi Gün Tatilleri muzaffer bas---
		get_emp_worktimes = cfquery(datasource : "#dsn#", sqlstring : "SELECT START_DATE AS START_TIME,FINISH_DATE AS END_TIME FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND IN_OUT_ID = #get_hr_ssk.in_out_id# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30# AND IS_AKDI_DAY = 1 AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0 ORDER BY START_DATE ASC");
		get_emp_worktimes_hours = cfquery(datasource : "#dsn#", sqlstring : "SELECT SUM(DATEDIFF(MINUTE,START_DATE,FINISH_DATE)) AS EMPLOYEES_WORKTIMES FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND IN_OUT_ID = #get_hr_ssk.in_out_id# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30# AND IS_AKDI_DAY = 1 AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0");
	
	 	if(len(get_emp_worktimes_hours.EMPLOYEES_WORKTIMES))
		t_akdi_hour=wrk_round(get_emp_worktimes_hours.EMPLOYEES_WORKTIMES/60);
        t_akdi_day=get_emp_worktimes.recordcount;
		
	    //muzaffer bit

		// Genel Tatiller
		offdays_count_hour = 0;
		get_emp_worktimes = cfquery(datasource : "#dsn#", sqlstring : "SELECT START_DATE AS START_TIME,FINISH_DATE AS END_TIME FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND IN_OUT_ID = #get_hr_ssk.in_out_id# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30# AND DAY_TYPE = -7 AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0 ORDER BY START_DATE ASC");
		get_emp_worktimes_hours = cfquery(datasource : "#dsn#", sqlstring : "SELECT SUM(DATEDIFF(MINUTE,START_DATE,FINISH_DATE)) AS EMPLOYEES_WORKTIMES FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND IN_OUT_ID = #get_hr_ssk.in_out_id# AND START_DATE >= #last_month_1# AND FINISH_DATE < #last_month_30# AND DAY_TYPE=-7 AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0");
		
		if(len(get_emp_worktimes_hours.EMPLOYEES_WORKTIMES))
			{
			offdays_count_hour = wrk_round(get_emp_worktimes_hours.EMPLOYEES_WORKTIMES / 60);		
			offdays_count = get_emp_worktimes.recordcount;
			}
		else
			{
			offdays_count_hour = 0;		
			offdays_count = 0;
			}

		
		offdays_sunday_count = 0;
		paid_izinli_sunday_count = 0;
		izinli_sunday_count = 0;
		
		izin = izin + izinli_sunday_count;
		izin_paid = izin_paid + paid_izinli_sunday_count;
		
		work_day_hour = total_hours; // Normal Gün Saat
		
		paid_izinli_sunday_count_hour = 0; // Ücretli Pazar İzni Saat
		izinli_sunday_count_hour = 0; // Ücretsiz Pazar İzni Saat
		
		total_hours = total_hours + paid_izinli_sunday_count_hour + izin_paid_count; // Ücretli İzin HT Saatleri + Ücretli İzin
		total_hours = total_hours + sunday_count_hour; // HT Saatleri
		total_hours = total_hours + offdays_count_hour; //Genel Tatil Saatleri
		total_hours = total_hours + offdays_sunday_count_hour; // Genel Tatilin HT rastladığı Saatleri
		//Akdi Gün saat Muzaffer
		total_hours = total_hours + t_akdi_hour;

		work_days = work_days + izin_paid;
		work_days = work_days + offdays_count;
		work_days = work_days + sunday_count;
		 //writeDump(work_days);
		work_days = work_days + t_akdi_day;
		
		
		if(get_active_program_parameter.SSK_31_DAYS eq 0)
		{
			if(work_days gt ssk_full_days)
			{
				ssk_days = ssk_full_days;
				work_days = ssk_full_days;
			}
			else
			{	/* SG 20130302 subat ayı tam calisma gunu 30 gun olarak duzeltildi. */
				if(aydaki_gun_sayisi gte 28 and aydaki_gun_sayisi eq work_days) 
				{
					ssk_days = 30;
				}
				else {ssk_days = work_days;}
			}
		}
		else
		{
			ssk_days = work_days;
		}
		
	for(j=1; j lte get_emp_ext_worktimes.recordcount; j=j+1)
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
		
		if(get_emp_ext_worktimes.day_type[j] eq 0)
		{
			ext_total_hours_0 = ext_total_hours_0 + temp_calc_ext_time;
			ext_total_hours_3 = ext_total_hours_3 + temp_calc_ext_time;
		}
		else if(get_emp_ext_worktimes.day_type[j] eq 1)
			ext_total_hours_1 = ext_total_hours_1 + temp_calc_ext_time;
		else if(get_emp_ext_worktimes.day_type[j] eq 2)
			ext_total_hours_2 = ext_total_hours_2 + temp_calc_ext_time;
		else if(get_emp_ext_worktimes.day_type[j] eq 3)
			ext_total_hours_5 = ext_total_hours_5 + temp_calc_ext_time;

			//Muzaffer ---Bas---
		else if(get_emp_ext_worktimes.day_type[j] eq -8)
			ext_total_hours_8 = ext_total_hours_8 + temp_calc_ext_time;
		else if(get_emp_ext_worktimes.day_type[j] eq -9)
			ext_total_hours_9 = ext_total_hours_9 + temp_calc_ext_time;
		else if(get_emp_ext_worktimes.day_type[j] eq -10)
			ext_total_hours_10 = ext_total_hours_10 + temp_calc_ext_time;
			else if(get_emp_ext_worktimes.day_type[j] eq -11)
			ext_total_hours_11 = ext_total_hours_11 + temp_calc_ext_time;
		else if(get_emp_ext_worktimes.day_type[j] eq -12)
			ext_total_hours_12 = ext_total_hours_12 + temp_calc_ext_time;
			//Muzaffer ---Bitis---
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
		ssk_isci_carpan = 0 + get_insurance_ratio.MOM_INSURANCE_PREMIUM_WORKER; // 0 YERİNE get_insurance_ratio.JOB_PATIENCE_PREMIUM_WORKER
		
		/*if((attributes.sal_year gt 2008 or (attributes.sal_year eq 2008 and attributes.sal_mon gt 9)))//1 ekim 2008 den itibaren 5510 sayili kanun cercevesinde 
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
			hastalik_carpan = get_hr_ssk.DANGER_DEGREE_NO; // silmeyin başka yerlerde lazım   yo 20081018
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
						if(get_hr_ssk.sube_is_5510 eq 1 and is_687 eq 0 and law_number_7103 eq 0)//sube 5510 dan yararlaniyor fakat 687 den faydalanmıyor ise
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
			
				
		if (get_hr_ssk.SSK_STATUTE neq 2 or get_hr_ssk.SSK_STATUTE neq 18) // emekli değilse işsizlik hissesi çarpanı
			{
			issizlik_isveren_carpan = get_insurance_ratio.death_insurance_boss;
			issizlik_isci_carpan = get_insurance_ratio.death_insurance_worker;
			}

		// diğer çarpanlar eklenir
		if(listfind('1,6,32,7,8,9',get_hr_ssk.SSK_STATUTE)) /// normal
		{
			ssk_isci_carpan = ssk_isci_carpan + get_insurance_ratio.PAT_INS_PREMIUM_WORKER + get_insurance_ratio.DEATH_INSURANCE_PREMIUM_WORKER;		
			malulluk_ = get_insurance_ratio.DEATH_INSURANCE_PREMIUM_BOSS;
				if(get_hr_ssk.SSK_STATUTE eq 32)
					malulluk_ = malulluk_ + 1.5;
				//SSK statüsü Yeraltı Sürekli ya da  Yeraltı Gruplu 
				if(get_hr_ssk.SSK_STATUTE eq 8 or get_hr_ssk.SSK_STATUTE eq 9)
					malulluk_ = malulluk_ + 3;
			
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
			}
			

			///Muzaffer KOSE BAS: Maden işletmesi için yapıldı
		else if (listfind('8,9,10,19',get_hr_ssk.SSK_STATUTE)) /// yeraltı sürekli: 8;yeraltı gruplu: 9;yerüstü gruplu: 10
		{
			
			ssk_isci_carpan = ssk_isci_carpan + get_insurance_ratio.PAT_INS_PREMIUM_WORKER + get_insurance_ratio.DEATH_INSURANCE_PREMIUM_WORKER_MADEN;
			//ssk_isveren_carpan= get_insurance_ratio.DEATH_INSURANCE_PREMIUM_BOSS_MADEN;
			malulluk_ = get_insurance_ratio.DEATH_INSURANCE_PREMIUM_BOSS_MADEN;
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
		}
		///Muzaffer KOSE BIT: Maden işletmesi için yapıldı
		else if (get_hr_ssk.SSK_STATUTE eq 2 or get_hr_ssk.SSK_STATUTE eq 18) /// emekli Muzaffer Köse Yeraltı emekli olanlar için /// emekli
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
		else if (get_hr_ssk.SSK_STATUTE eq 5) /// yabanci
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
			}
		else if(get_hr_ssk.SSK_STATUTE eq 3 or get_hr_ssk.SSK_STATUTE eq 4 or get_hr_ssk.SSK_STATUTE eq 75) //stajyer öğrenci - çırak - mesleki stajyer ---> ssk hesaplanmaz
			{
			issizlik_isci_carpan = 0;
			issizlik_isveren_carpan = 0;
			ssk_isci_carpan = 0;
			ssk_isveren_carpan = 0;
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
			}
		else if(get_hr_ssk.SSK_STATUTE eq 21)
			{
				ssk_isci_carpan = ssk_isci_carpan + get_insurance_ratio.PAT_INS_PREMIUM_WORKER;
				ssk_isveren_carpan = ssk_isveren_carpan + get_insurance_ratio.PAT_INS_PREMIUM_BOSS;
				issizlik_isci_carpan = 0;
				issizlik_isveren_carpan = 0;
			}
		}
	 // bu sistem yeni istihdam kanunu ile yeniden duzenlendi yo07082008
	// YO20041015 iskurdan ozel izinle fazladan calistirilan sakatlar icin ssk isveren hisselerinin %50 si odenir, sakat_carpan 1 veya daha kucuk bir deger alir.
	if(ssk_isveren_carpan gt 0)
		ssk_isveren_carpan_tam = ssk_isveren_carpan;
	else
		ssk_isveren_carpan_tam = 0;
		
	ssk_isveren_carpan = ssk_isveren_carpan * sakat_carpan;
	issizlik_isveren_carpan = issizlik_isveren_carpan * sakat_carpan;

	if(get_hr_ssk.DEFECTION_STARTDATE lte parameter_last_month_30 and get_hr_ssk.DEFECTION_FINISHDATE gte parameter_last_month_1)
		defection_date_control = 1;
	else
		defection_date_control = 0;

// sakatlık derecesine göre vergi indirimi hesaplanır
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

	if (not listfind('1,2,3',get_hr_ssk.DEFECTION_LEVEL,',')) 
		sakatlik_indirimi = 0;

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

	// kümülatif gelir vergisi matrahı hesaplanır
	if (get_kumulative.recordcount)
		kumulatif_gelir = get_kumulative.KUMULATIF_GELIR_MATRAH;
	else if(len(get_hr_salary.CUMULATIVE_TAX_TOTAL))
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



	if(get_active_program_parameter.UNPAID_PERMISSION_TODROP_THIRTY eq 1 and get_hr_salary.salary_type neq 1)
		{
		if((ssk_days + izin) eq 31)
			ssk_days = 30 - izin;
			if(get_hr_salary.salary_type eq 0 and (not len(get_hr_salary.is_kismi_istihdam) or get_hr_salary.is_kismi_istihdam eq 0))
				work_days = ssk_days;
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
	if(get_hr_salary.salary_type eq 1 and ssk_days eq aydaki_gun_sayisi)
	{
		ssk_matrah_taban = get_insurance.MIN_PAYMENT;
		ssk_matrah_tavan = MAX_PAYMENT_;
	}
	else if(get_hr_salary.salary_type eq 1 and ssk_days lt 30)
	{
		ssk_matrah_taban = get_insurance.MIN_PAYMENT * ceiling(ssk_days) / 30;
		ssk_matrah_tavan = MAX_PAYMENT_ * ssk_days / 30;
	}
	else
	{
		ssk_matrah_taban = (get_insurance.MIN_PAYMENT * ceiling(ssk_days)) / ssk_full_days;
		ssk_matrah_tavan = (MAX_PAYMENT_ * ssk_days) / ssk_full_days;
	}
	
	if ((izin gte aydaki_gun_sayisi) or (work_days eq 0 and ssk_days eq 0 and izin eq 0))
	{
		ssk_days = 0;
		work_days = 0;
		ssk_matrah_taban = 0;
		if(get_active_program_parameter.EMPLOYEES_BASE_CALC eq 0)
			ssk_matrah_tavan = MAX_PAYMENT_;
		else
			ssk_matrah_tavan = 0;
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

if (offdays_count lt 0)
	offdays_count = 0;
</cfscript>
