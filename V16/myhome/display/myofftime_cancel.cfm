<!---
File: myofftime_cancel.cfm
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Controller: myOfftimesApproveController.cfm
Description: Offday Cancellation Requests Listing Page
Date: 23/10/2019
--->
<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
	<cfparam name="attributes.employee_id" default="#attributes.employee_id#">
<cfelse>
	<cfparam name="attributes.employee_id" default="#session.ep.userid#">
</cfif>
<cfparam name="attributes.emp_name" default="get_emp_info(session.ep.userid,0,0)">
<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
<cfelse>
	<cfparam name="attributes.startdate" default="">
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
<cfelse>
	<cfparam name="attributes.finishdate" default="">
</cfif>
<cfif isdefined("attributes.startdate_cancel") and len(attributes.startdate_cancel)>
	<cf_date tarih="attributes.startdate_cancel">
<cfelse>
	<cfparam name="attributes.startdate_cancel" default="">
</cfif>
<cfif isdefined("attributes.finishdate_cancel") and len(attributes.finishdate_cancel)>
	<cf_date tarih="attributes.finishdate_cancel">
<cfelse>
	<cfparam name="attributes.finishdate_cancel" default="">
</cfif>
<cfset genel_izin_toplam = 0>
<cfset toplam_saat = 0>
<cfquery name="GET_EMP" datasource="#DSN#">
	SELECT 
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.GROUP_STARTDATE,
		E.IZIN_DATE,
		E.IZIN_DAYS,
		EI.BIRTH_DATE,
		(SELECT TOP 1 PUANTAJ_GROUP_IDS FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ORDER BY START_DATE DESC) AS PUANTAJ_GROUP_IDS
	FROM
		EMPLOYEES E
		INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
	WHERE 
		E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>
<cfif len(get_emp.izin_days)>
	<cfset old_days = get_emp.izin_days>
<cfelse>
	<cfset old_days = 0>
</cfif>
<cfquery name="GET_OFFTIME_CATS" datasource="#dsn#">
	SELECT * FROM SETUP_OFFTIME
</cfquery>
<cfinclude template="../query/get_offtimes.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_offtimes.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<!--- izin hesaplama --->
<cfset toplam_hakedilen_izin = 0>
<cfquery name="get_progress_payment_outs" datasource="#dsn#">
	SELECT * FROM EMPLOYEE_PROGRESS_PAYMENT_OUT WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND START_DATE IS NOT NULL AND FINISH_DATE IS NOT NULL AND IS_YEARLY = 1
</cfquery>
<!--- çalışma saati başlangıç ve bitişleri al--->
<cfquery name="get_work_time" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="ehesap.form_add_offtime_popup"> AND
		(PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="start_hour_info"> OR
		PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="start_min_info"> OR
		PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="finish_hour_info"> OR
		PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="finish_min_info">
		)	
</cfquery>
<cfif get_work_time.recordcount>
<cfloop query="get_work_time">	
	<cfif property_name eq 'start_hour_info'>
		<cfset start_hour = property_value>
	<cfelseif property_name eq 'start_min_info'>
		<cfset start_min = property_value>
	<cfelseif property_name eq 'finish_hour_info'>
		<cfset finish_hour = property_value>
	<cfelseif property_name eq 'finish_min_info'>
		<cfset finish_min = property_value>
	</cfif>
</cfloop>
<cfelse>
	<cfset start_hour = '00'>
	<cfset start_min = '00'>
	<cfset finish_hour = '00'>
	<cfset finish_min = '00'>
</cfif>	
<cfquery name="get_hours" datasource="#dsn#">
    SELECT		
        OUR_COMPANY_HOURS.WEEKLY_OFFDAY,
        OUR_COMPANY_HOURS.DAILY_WORK_HOURS
    FROM
        OUR_COMPANY_HOURS
    WHERE
        OUR_COMPANY_HOURS.DAILY_WORK_HOURS   > 0 AND
        OUR_COMPANY_HOURS.SSK_MONTHLY_WORK_HOURS > 0 AND
        OUR_COMPANY_HOURS.SSK_WORK_HOURS > 0 AND
        OUR_COMPANY_HOURS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfset daily_work_hours = get_hours.DAILY_WORK_HOURS>
<cfif len(get_hours.recordcount) and len(get_hours.WEEKLY_OFFDAY)>
    <cfset this_week_rest_day_ = get_hours.WEEKLY_OFFDAY>
<cfelse>
    <cfset this_week_rest_day_ = 1>
</cfif>
<cfquery name="GET_GENERAL_OFFTIMES" datasource="#DSN#">
	SELECT START_DATE,FINISH_DATE,IS_HALFOFFTIME FROM SETUP_GENERAL_OFFTIMES
</cfquery>
<cfset offday_list = ''>
<cfset offday_list_ = ''>
<cfset halfofftime_list = ''><!--- yarım gunluk izin kayıtları--->
<cfset halfofftime_list2 = ''>
<cfoutput query="GET_GENERAL_OFFTIMES">
	<cfscript>
		offday_gun = datediff('d',get_general_offtimes.start_date,get_general_offtimes.finish_date)+1;
		offday_startdate = date_add("h", session.ep.time_zone, get_general_offtimes.start_date); 
		offday_finishdate = date_add("h", session.ep.time_zone, get_general_offtimes.finish_date);
		for (mck=0; mck lt offday_gun; mck=mck+1)
		{
			temp_izin_gunu = date_add("d",mck,offday_startdate);
			daycode = '#dateformat(temp_izin_gunu,dateformat_style)#';
			if(not listfindnocase(offday_list,'#daycode#'))
				offday_list = listappend(offday_list,'#daycode#');
			if(GET_GENERAL_OFFTIMES.is_halfofftime is 1 and dayofweek(temp_izin_gunu) neq 1) //pazar haricindeki yarım günlük izin günleri sayılsın
			{
				halfofftime_list = listappend(halfofftime_list,'#daycode#');
			}
		}
	</cfscript>
</cfoutput>
<cfif len(get_emp.IZIN_DATE)>
	<cfset employee_id_ = attributes.employee_id>
	<cfif get_offtime.recordcount>
		<cfoutput query="get_offtime">
				<cfquery name="get_pre_offtime" dbtype="query">
					SELECT
						STARTDATE
					FROM
						get_offtime
					WHERE
						STARTDATE < '#get_offtime.startdate#'
					ORDER BY 
						STARTDATE DESC
				</cfquery>
				<cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
					SELECT * FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value = '#get_offtime.startdate#'> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value = '#get_offtime.startdate#'> AND
                    <cfif len(get_emp.PUANTAJ_GROUP_IDS)>
                    (
                    	<cfloop from="1" to="#listlen(get_emp.PUANTAJ_GROUP_IDS)#" index="i">
                        	','+PUANTAJ_GROUP_IDS+',' LIKE '%,#listgetat(get_emp.PUANTAJ_GROUP_IDS,i,',')#,%' <cfif listlen(get_emp.PUANTAJ_GROUP_IDS) neq i>OR</cfif> 
                     	</cfloop>
                 	)
                  	<cfelse>
                    	PUANTAJ_GROUP_IDS IS NULL
                 	</cfif>	
				</cfquery>
				<cfscript>
					if (get_offtime_cat.recordcount and len(get_offtime_cat.sunday_on))
						sunday_on = get_offtime_cat.sunday_on;
					else
						sunday_on = 0;
					if (get_offtime_cat.recordcount and len(get_offtime_cat.public_holiday_on))
						public_holiday_on = get_offtime_cat.public_holiday_on;
					else
						public_holiday_on = 0;
					
					if (get_offtime_cat.recordcount and len(get_offtime_cat.saturday_on))
						saturday_on = get_offtime_cat.saturday_on;
					else
						saturday_on = 1;
						
					if (get_offtime_cat.recordcount and len(get_offtime_cat.day_control))
						day_control_ = get_offtime_cat.day_control;
					else
						day_control_ = 0;
					if (len(get_emp.izin_date))
						kidem = datediff('d',get_emp.izin_date,get_offtime.startdate);
					else
						kidem = 0;
					kidem_yil = kidem/365;
					
					add_sunday_total = 0;
					
					temporary_sunday_total_ = 0;
					temporary_offday_total_ = 0;
					temporary_halfday_total = 0;
					temporary_halfofftime = 0;
					izin_start_hour_ = "";
					izin_finish_hour_ = "";
					temp_finishdate = CreateDateTime(year(get_offtime.finishdate),month(get_offtime.finishdate),day(get_offtime.finishdate),0,0,0);
					temp_startdate = CreateDateTime(year(get_offtime.startdate),month(get_offtime.startdate),day(get_offtime.startdate),0,0,0);
	                total_izin_ = fix(temp_finishdate-temp_startdate)+1;
					izin_startdate_ = date_add("h", session.ep.time_zone, get_offtime.startdate); 
					izin_finishdate_ = date_add("h", session.ep.time_zone, get_offtime.finishdate);
					fark = 0;
					fark2 = 0;
					if(timeformat(izin_startdate_,timeformat_style) lt timeformat('#start_hour#:#start_min#',timeformat_style))
					{
						izin_start_hour_ = timeformat('#start_hour#:#start_min#',timeformat_style);
					}
					else
					{
						izin_start_hour_ = 	timeformat(izin_startdate_,timeformat_style);
					}
					if(timeformat(izin_finishdate_,timeformat_style) gt timeformat('#finish_hour#:#finish_min#',timeformat_style))
					{
						izin_finish_hour_ = timeformat('#finish_hour#:#finish_min#',timeformat_style);
					}
					else
					{
						izin_finish_hour_ = timeformat(izin_finishdate_,timeformat_style);
					}
					
					if(izin_start_hour_ gt timeformat('#start_hour#:#start_min#',timeformat_style))
					{
						fark = fark+datediff("n",izin_start_hour_,timeformat('#finish_hour#:#finish_min#',timeformat_style));
						fark = fark/60;
					}
					else
					{
						fark = fark+datediff("n",izin_start_hour_,timeformat('#start_hour#:#start_min#',timeformat_style));
						fark = fark/60;
					}
					fark2 = fark2+datediff("n",timeformat('#start_hour#:#start_min#',timeformat_style),izin_finish_hour_);
					fark2 = fark2/60;
					if(fark gt 0 and fark lte day_control_)
					{
						if(not listfind(halfofftime_list,'#dateformat(startdate,dateformat_style)#')) //saatten oluşan yarım günlük izine yarım günlük genel tatil gunune denk gelmiyorsa girecek
						temporary_halfday_total = temporary_halfday_total + 1;
						halfofftime_list2 = listappend(halfofftime_list2,'#dateformat(startdate,dateformat_style)#');
					}
					if(fark2 gt 0 and fark2 lte day_control_)
					{
						if(not listfind(halfofftime_list,'#dateformat(finishdate,dateformat_style)#')) //saatten oluşan yarım günlük izine yarım günlük genel tatil gunune denk gelmiyorsa girecek
						temporary_halfday_total = temporary_halfday_total + 1;
						halfofftime_list2 = listappend(halfofftime_list2,'#dateformat(finishdate,dateformat_style)#');
					}
					for (mck_=0; mck_ lt total_izin_; mck_=mck_+1)
					{
						temp_izin_gunu_ = date_add("d",mck_,izin_startdate_);
						daycode_ = '#dateformat(temp_izin_gunu_,dateformat_style)#';
						if (dayofweek(temp_izin_gunu_) eq this_week_rest_day_)
							temporary_sunday_total_ = temporary_sunday_total_ + 1;
						else if (dayofweek(temp_izin_gunu_) eq 7 and saturday_on eq 0)
							temporary_sunday_total_ = temporary_sunday_total_ + 1;
						else if(listlen(offday_list) and listfindnocase(offday_list,'#daycode_#'))
							if(listfind(halfofftime_list2,'#daycode_#') or (listlen(halfofftime_list) and listfind(halfofftime_list,'#daycode_#')))
								temporary_offday_total_ = temporary_offday_total_ + 0.5;
							else 
								temporary_offday_total_ = temporary_offday_total_ +1;
						else if(listlen(halfofftime_list) and listfind(halfofftime_list,'#daycode_#')) //yarım günlük genel tatiller
							temporary_halfofftime = temporary_halfofftime + 1; 
							
							
						if (dayofweek(temp_izin_gunu_) eq 1 and sunday_on eq 1)//pazar gunu ise ve pazar gunleri dahil edilsin secili ise
						{
							add_sunday_total = add_sunday_total+1;	
						}
					}
					if(get_offtime.is_paid neq 1 and get_offtime.ebildirge_type_id neq 21) // ucretli isaretli degilse ve bildirge karşılığı diger ücretsiz izinden farklı ise genel tatil ve hafta tatili dusulmez
					{
						izin_gun = total_izin_ - (0.5 * temporary_halfday_total) ; //+ (0.5 * temporary_halfofftime)
					}
					else
					{
						izin_gun = total_izin_ - temporary_sunday_total_ - temporary_offday_total_ - (0.5 * temporary_halfday_total) + (0.5 * temporary_halfofftime)+add_sunday_total;
					}
					genel_izin_toplam = genel_izin_toplam+izin_gun;
				</cfscript>
		</cfoutput>
	</cfif>
	<cfscript>
		tmp_group_id = "";
		tmp_def_type = 1;
		if(len(get_emp.puantaj_group_ids))
		{
			tmp_group_id = " AND (";
			for(i=1;i lte listlen(get_emp.puantaj_group_ids,',');i=i+1)
			{
				tmp_group_id = tmp_group_id & "','+PUANTAJ_GROUP_IDS+',' LIKE '%,"&listgetat(get_emp.puantaj_group_ids,i,',')&",%' ";
				if (i neq listlen(get_emp.puantaj_group_ids,','))
					tmp_group_id = tmp_group_id & 'OR ';
			}
			tmp_group_id = tmp_group_id & ' OR PUANTAJ_GROUP_IDS IS NULL) ORDER BY PUANTAJ_GROUP_IDS DESC';
		}
		tck = 0;
		tck_ = 0;
		toplam_hakedilen_izin = 0;
		my_giris_date = get_emp.IZIN_DATE;
		flag = true;
		baslangic_tarih_ = my_giris_date;
		my_baz_date = now();
		tmp_baslangic_tarih_ = createodbcdatetime(baslangic_tarih_);
		get_def_type = cfquery(Datasource="#dsn#",sqlstring="SELECT TOP 1 DEFINITION_TYPE,LIMIT_1,ISNULL(LIMIT_1_DAYS,0) LIMIT_1_DAYS,MIN_MAX_DAYS,MIN_YEARS,MAX_YEARS FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= #tmp_baslangic_tarih_# AND FINISHDATE >= #my_baz_date# "&tmp_group_id);
		if(get_def_type.recordcount)
		{
			tmp_def_type = get_def_type.definition_type;
			eklenecek = get_def_type.limit_1_days;
		}
		if(tmp_def_type eq 0)
		{
			tck = datediff('yyyy',my_giris_date,my_baz_date) + 1;
				
			while(flag)
			{
				bitis_tarihi_ = createodbcdatetime(date_add("m",get_def_type.LIMIT_1,baslangic_tarih_));
				baslangic_tarih_ = createodbcdatetime(baslangic_tarih_);
				get_bos_zaman_ = cfquery(Datasource="#dsn#",dbtype="query",sqlstring="SELECT * FROM get_progress_payment_outs WHERE (START_DATE <= #baslangic_tarih_# AND FINISH_DATE >= #baslangic_tarih_#) OR (START_DATE >= #baslangic_tarih_# AND FINISH_DATE <= #bitis_tarihi_#) OR ((START_DATE BETWEEN #baslangic_tarih_# AND #bitis_tarihi_#) AND FINISH_DATE >= #bitis_tarihi_#)");
				
				if(get_bos_zaman_.recordcount eq 0)
				{
					tck_ = tck_ + 1; 
					kontrol_date = bitis_tarihi_;
					eklenecek = get_def_type.limit_1_days;
					if(len(get_emp.birth_date) and eklenecek lt get_def_type.min_max_days and (datediff("yyyy",get_emp.birth_date,kontrol_date) lt get_def_type.min_years or datediff("yyyy",get_emp.birth_date,kontrol_date) gt get_def_type.max_years))
						eklenecek = get_def_type.min_max_days;
					if(tck_ neq 1 and eklenecek neq 0)
					{
						toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
					}
				}
				else
				{
					eklenecek_gun = 0;
					for(izd = 1; izd lte get_bos_zaman_.recordcount; izd=izd+1)
					{
						if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) gt 0)
						{
							fark_ = datediff("d",baslangic_tarih_,get_bos_zaman_.finish_date[izd]);
						}
						else if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) lte 0)
						{
							fark_ = datediff("d",get_bos_zaman_.start_date[izd],get_bos_zaman_.finish_date[izd]);
						}
						eklenecek_gun = eklenecek_gun + fark_;
					}
					bitis_tarihi_ = date_add("d",eklenecek_gun,bitis_tarihi_);
			
					tck_ = tck_ + 1; 
					kontrol_date = bitis_tarihi_;
					eklenecek = get_def_type.LIMIT_1_DAYS;
					if(len(get_emp.BIRTH_DATE) and eklenecek lt get_def_type.MIN_MAX_DAYS and (datediff("yyyy",get_emp.BIRTH_DATE,kontrol_date) lt get_def_type.MIN_YEARS or datediff("yyyy",get_emp.BIRTH_DATE,kontrol_date) gt get_def_type.MAX_YEARS) )
					eklenecek = get_def_type.MIN_MAX_DAYS;
					if(tck_ neq 1 and eklenecek neq 0) 
					{
						toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
					}
				}
				ilk_tarih_ = baslangic_tarih_;
				baslangic_tarih_ = bitis_tarihi_;
				if(datediff("d",baslangic_tarih_,now()) lt 0)				
				{
					flag = false;
				}
				bitis_tarihi_ = date_add("m",get_def_type.LIMIT_1,bitis_tarihi_);
			}
		}
		else 
		{
			while(flag)
			{
				bitis_tarihi_ = createodbcdatetime(date_add("yyyy",1,baslangic_tarih_));
				baslangic_tarih_ = createodbcdatetime(baslangic_tarih_);
				get_bos_zaman_ = cfquery(Datasource="#dsn#",dbtype="query",sqlstring="SELECT * FROM get_progress_payment_outs WHERE (START_DATE <= #baslangic_tarih_# AND FINISH_DATE >= #baslangic_tarih_#) OR (START_DATE >= #baslangic_tarih_# AND FINISH_DATE <= #bitis_tarihi_#) OR ((START_DATE BETWEEN #baslangic_tarih_# AND #bitis_tarihi_#) AND FINISH_DATE >= #bitis_tarihi_#)");	
				
				if(get_bos_zaman_.recordcount eq 0)
				{
					tck = tck + 1; 
					kontrol_date = bitis_tarihi_;
					get_offtime_limit=cfquery(datasource="#dsn#",sqlstring="SELECT TOP 1 ISNULL(LIMIT_1_DAYS,0) LIMIT_1_DAYS, ISNULL(LIMIT_2_DAYS,0) LIMIT_2_DAYS, ISNULL(LIMIT_3_DAYS,0) LIMIT_3_DAYS, ISNULL(LIMIT_4_DAYS,0) LIMIT_4_DAYS,ISNULL(LIMIT_5_DAYS,0) LIMIT_5_DAYS,MIN_MAX_DAYS,MIN_YEARS,MAX_YEARS,LIMIT_1,LIMIT_2,LIMIT_3,LIMIT_4,LIMIT_5,LIMIT_ID FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= #baslangic_tarih_# AND FINISHDATE >= #baslangic_tarih_#"&tmp_group_id);	
					
					if(get_offtime_limit.recordcount)
					{
						if(tck lte get_offtime_limit.limit_1)
							eklenecek = get_offtime_limit.limit_1_days;
						else if(tck gt get_offtime_limit.limit_1 and tck lte get_offtime_limit.limit_2)
							eklenecek = get_offtime_limit.limit_2_days;
						else if(tck gt get_offtime_limit.limit_2 and tck lte get_offtime_limit.limit_3)
							eklenecek = get_offtime_limit.limit_3_days;
						else if(tck gt get_offtime_limit.limit_3 and tck lte get_offtime_limit.limit_4)
							eklenecek = get_offtime_limit.limit_4_days;
						else
							eklenecek = get_offtime_limit.limit_5_days;
						
						if(len(get_emp.birth_date) and eklenecek lt get_offtime_limit.min_max_days and (datediff("yyyy",get_emp.birth_date,kontrol_date) lt get_offtime_limit.min_years or datediff("yyyy",get_emp.birth_date,kontrol_date) gt get_offtime_limit.max_years) and tck gt 1)
						{
							eklenecek = get_offtime_limit.min_max_days;
						}
						if(eklenecek neq 0)  //if(tck neq 1 and eklenecek neq 0) 
						{
							toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
						}
					}
				}
				else
				{												
					eklenecek_gun = 0;
					for(izd = 1; izd lte get_bos_zaman_.recordcount; izd=izd+1)
					{
						if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) gt 0)
						{
							fark_ = datediff("d",baslangic_tarih_,get_bos_zaman_.finish_date[izd]);
						}
						else if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) lte 0)
						{
							fark_ = datediff("d",get_bos_zaman_.start_date[izd],get_bos_zaman_.finish_date[izd]);
						}
						eklenecek_gun = eklenecek_gun + fark_;
					}
					bitis_tarihi_ = date_add("d",eklenecek_gun,bitis_tarihi_);
	
					tck = tck + 1; 
					kontrol_date = bitis_tarihi_;
					get_offtime_limit=cfquery(datasource="#dsn#",sqlstring="SELECT * FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= #bitis_tarihi_# AND FINISHDATE >= #bitis_tarihi_#"&tmp_group_id);	
					if(get_offtime_limit.recordcount)
					{
						if(tck lte get_offtime_limit.limit_1)
							eklenecek = get_offtime_limit.LIMIT_1_DAYS;
						else if(tck gt get_offtime_limit.limit_1 and tck lte get_offtime_limit.limit_2)
							eklenecek = get_offtime_limit.LIMIT_2_DAYS;
						else if(tck gt get_offtime_limit.limit_2 and tck lte get_offtime_limit.limit_3)
							eklenecek = get_offtime_limit.LIMIT_3_DAYS;
						else if(tck gt get_offtime_limit.limit_3 and tck lte get_offtime_limit.limit_4)
							eklenecek = get_offtime_limit.LIMIT_4_DAYS;
						else	
							eklenecek = get_offtime_limit.LIMIT_5_DAYS;
						
						if(len(get_emp.BIRTH_DATE) and eklenecek lt get_offtime_limit.MIN_MAX_DAYS and (datediff("yyyy",get_emp.BIRTH_DATE,kontrol_date) lt get_offtime_limit.MIN_YEARS or datediff("yyyy",get_emp.BIRTH_DATE,kontrol_date) gt get_offtime_limit.MAX_YEARS) )
							eklenecek = get_offtime_limit.MIN_MAX_DAYS;
						if(tck neq 1 and eklenecek neq 0) 
						{
							toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
						}
					}
				}	
				ilk_tarih_ = baslangic_tarih_;
				baslangic_tarih_ = bitis_tarihi_;
				bitis_tarihi_ = date_add("yyyy",1,bitis_tarihi_);
				if(datediff("yyyy",bitis_tarihi_,now()) lt 0)				
				{
					flag = false;
				}
			}
		}
		kalan_izin = toplam_hakedilen_izin - genel_izin_toplam - old_days;
	</cfscript>    
<cfelse>
	<cfset kalan_izin = 0>
</cfif>
<cfset employee_list=''>
<cfinclude template="../query/get_other_offtimes.cfm">
<cfif get_other_offtimes.recordcount>
    <cfoutput query="get_other_offtimes">
        <cfif len(employee_id) and not listfind(employee_list,employee_id)>
            <cfset employee_list=listappend(employee_list,employee_id)>
        </cfif>
    </cfoutput>
    <cfset employee_list=listsort(listdeleteduplicates(employee_list,','),'numeric','ASC',',')>
</cfif>
<cfif listlen(employee_list)>
    <cfquery name="GET_EMPLOYEE" datasource="#DSN#">
        SELECT
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            E.EMPLOYEE_ID,
            (SELECT TOP 1 PUANTAJ_GROUP_IDS FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ORDER BY START_DATE DESC) AS PUANTAJ_GROUP_IDS
        FROM 
            EMPLOYEES E
        WHERE
            E.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#listsort(listdeleteduplicates(valuelist(get_other_offtimes.employee_id),','),'numeric','ASC',',')#">)
        ORDER BY
            E.EMPLOYEE_ID
    </cfquery>
</cfif>
<cfsavecontent variable="title"><cf_get_lang dictionary_id ="51691.Yıllık İzin İptal Talepleri"></cfsavecontent>
	<cf_box title="#title#" closable="0" collapsable="0">
		<cf_ajax_list>
			<div class="extra_list">
					<thead>
						<tr>
							<th height="22"><cf_get_lang dictionary_id='57487.No'></th>
							<th width="120"><cf_get_lang dictionary_id='57486.Kategori'></th>
							<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
							<th width="220"><cf_get_lang dictionary_id='31111.Tarihler'></th>
							<th width="100"><cf_get_lang dictionary_id='57490.Gün'></th>
							<th width="150"><cf_get_lang dictionary_id='57500.Onay'></th>
							<th width="60"><cf_get_lang dictionary_id="31407.Kalan İzin"></th>
							<th class="header_icn_none"></th>
						</tr>
					</thead>
					<tbody>
						<cfif get_other_offtimes.recordcount>
							<cfoutput query="get_other_offtimes">
								<tr>
									<td width="25"><a onClick="windowopen('#request.self#?fuseaction=myhome.my_offtimes&event=info&offtime_id=#contentEncryptingandDecodingAES(isEncode:1,content:offtime_id,accountKey:'wrk')#','medium');" href="javascript://" class="tableyazi">#offtime_id#</a></td>
									<td><a onClick="windowopen('#request.self#?fuseaction=myhome.my_offtimes&event=info&offtime_id=#contentEncryptingandDecodingAES(isEncode:1,content:offtime_id,accountKey:'wrk')#','medium');" href="javascript://" class="tableyazi">#offtimecat#</a></td>
									<td width="500">
										<cfif len(employee_id)>
											#get_employee.employee_name[listfind(employee_list,employee_id,',')]# #get_employee.employee_surname[listfind(employee_list,employee_id,',')]#
										</cfif>
									</td>
									<td width="300">#dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)# ( #timeformat(date_add('h',session.ep.time_zone,startdate),timeformat_style)# ) - #dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)# ( #timeformat(date_add('h',session.ep.time_zone,finishdate),timeformat_style)# )</td>
									<td>
										<cfquery name="get_puantaj_group_id" dbtype="query">
											SELECT PUANTAJ_GROUP_IDS FROM get_employee WHERE EMPLOYEE_ID = #employee_id#
										</cfquery>
										<cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
											SELECT SATURDAY_ON,DAY_CONTROL,SUNDAY_ON,PUBLIC_HOLIDAY_ON FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> AND
											<cfif len(get_puantaj_group_id.puantaj_group_ids)>
											(
												<cfloop from="1" to="#listlen(get_puantaj_group_id.puantaj_group_ids)#" index="i">
													','+PUANTAJ_GROUP_IDS+',' LIKE '%,#listgetat(get_puantaj_group_id.puantaj_group_ids,i,",")#,%' <cfif listlen(get_puantaj_group_id.puantaj_group_ids) neq i>OR</cfif> 
												</cfloop>
											)
											<cfelse>
												PUANTAJ_GROUP_IDS IS NULL
											</cfif>	
										</cfquery>
										<cfscript>
											if (get_offtime_cat.recordcount and len(get_offtime_cat.saturday_on))
												saturday_on = get_offtime_cat.saturday_on;
											else
												saturday_on = 1;
											if (get_offtime_cat.recordcount and len(get_offtime_cat.sunday_on))
												sunday_on = get_offtime_cat.sunday_on;
											else
												sunday_on = 0;
											if (get_offtime_cat.recordcount and len(get_offtime_cat.public_holiday_on))
												public_holiday_on = get_offtime_cat.public_holiday_on;
											else
												public_holiday_on = 0;
											if (get_offtime_cat.recordcount and len(get_offtime_cat.day_control))
												day_control_ = get_offtime_cat.day_control;
											else
												day_control_ = 0;
											add_sunday_total = 0;
											temporary_sunday_total_ = 0;
											temporary_offday_total_ = 0;
											temporary_halfday_total = 0;
											temporary_halfofftime = 0;
											izin_start_hour_ = "";
											izin_finish_hour_ = "";
											temp_finishdate = CreateDateTime(year(finishdate),month(finishdate),day(finishdate),0,0,0);
											temp_startdate = CreateDateTime(year(startdate),month(startdate),day(startdate),0,0,0);
											total_izin_ = fix(temp_finishdate-temp_startdate)+1;
											izin_startdate_ = date_add("h", session.ep.time_zone, startdate);
											izin_finishdate_ = date_add("h", session.ep.time_zone, finishdate);
											fark = 0;
											fark2 = 0;
											if(timeformat(izin_startdate_,timeformat_style) lt timeformat('#start_hour#:#start_min#',timeformat_style))
											{
												izin_start_hour_ = timeformat('#start_hour#:#start_min#',timeformat_style);
											}
											else
											{
												izin_start_hour_ = 	timeformat(izin_startdate_,timeformat_style);
											}
											if(timeformat(izin_finishdate_,timeformat_style) gt timeformat('#finish_hour#:#finish_min#',timeformat_style))
											{
												izin_finish_hour_ = timeformat('#finish_hour#:#finish_min#',timeformat_style);
											}
											else
											{
												izin_finish_hour_ = timeformat(izin_finishdate_,timeformat_style);
											}
											
											if(izin_start_hour_ gt timeformat('#start_hour#:#start_min#',timeformat_style))
											{
												fark = fark+datediff("n",izin_start_hour_,timeformat('#finish_hour#:#finish_min#',timeformat_style));
												fark = fark/60;
											}
											else
											{
												fark = fark+datediff("n",izin_start_hour_,timeformat('#start_hour#:#start_min#',timeformat_style));
												fark = fark/60;
											}
											fark2 = fark2+datediff("n",timeformat('#start_hour#:#start_min#',timeformat_style),izin_finish_hour_);
											fark2 = fark2/60;
											if(fark gt 0 and fark lte day_control_)
											{
												if(not listfind(halfofftime_list,'#dateformat(startdate,dateformat_style)#') or (listfind(halfofftime_list,'#dateformat(startdate,dateformat_style)#') and public_holiday_on eq 1)) //saatten oluşan yarım günlük izine yarım günlük genel tatil gunune denk gelmiyorsa girecek
												temporary_halfday_total = temporary_halfday_total + 1;
												halfofftime_list2 = listappend(halfofftime_list2,'#dateformat(startdate,dateformat_style)#');
											}
											if(fark2 gt 0 and fark2 lte day_control_)
											{
												if(not listfind(halfofftime_list,'#dateformat(finishdate,dateformat_style)#') or (listfind(halfofftime_list,'#dateformat(finishdate,dateformat_style)#') and public_holiday_on eq 1)) //saatten oluşan yarım günlük izine yarım günlük genel tatil gunune denk gelmiyorsa girecek
												temporary_halfday_total = temporary_halfday_total + 1;
												halfofftime_list2 = listappend(halfofftime_list2,'#dateformat(finishdate,dateformat_style)#');
											}
											for (mck_=0; mck_ lt total_izin_; mck_=mck_+1)
											{
												temp_izin_gunu_ = date_add("d",mck_,izin_startdate_);
												daycode_ = '#dateformat(temp_izin_gunu_,dateformat_style)#';
												
												if (dayofweek(temp_izin_gunu_) eq this_week_rest_day_)
													temporary_sunday_total_ = temporary_sunday_total_ + 1;
												else if (dayofweek(temp_izin_gunu_) eq 7 and saturday_on eq 0)
													temporary_sunday_total_ = temporary_sunday_total_ + 1;
												else if(listlen(offday_list) and listfindnocase(offday_list,'#daycode_#') and public_holiday_on eq 0)
													if(listfind(halfofftime_list2,'#daycode_#') or (listlen(halfofftime_list) and listfind(halfofftime_list,'#daycode_#')))
														temporary_offday_total_ = temporary_offday_total_ + 0.5;
													else 
														temporary_offday_total_ = temporary_offday_total_ +1;
												else if(listlen(halfofftime_list) and listfind(halfofftime_list,'#daycode_#') and public_holiday_on eq 0) //yarım günlük genel tatiller
													temporary_halfofftime = temporary_halfofftime + 1; 
												if (dayofweek(temp_izin_gunu_) eq 1 and sunday_on eq 1)//pazar gunu ise ve pazar gunleri dahil edilsin secili ise
												{
													add_sunday_total = add_sunday_total+1;	
												}
											}
											if(is_paid neq 1 and ebildirge_type_id neq 21) // ucretli isaretli degilse ve bildirge karşılığı diger ücretsiz izinden farklı ise genel tatil ve hafta tatili dusulmez
											{
												izin_gun = total_izin_ - (0.5 * temporary_halfday_total);
											}
											else
											{
												izin_gun = total_izin_ - temporary_sunday_total_ - temporary_offday_total_ - (0.5 * temporary_halfday_total) + (0.5 * temporary_halfofftime)+add_sunday_total;
											}
										</cfscript>
										#izin_gun#
									</td>
									<td><cf_get_lang dictionary_id='31112.Bekliyor'></td>
									<td>
										<!---calisanin kalan izin bilgisi SG 20130227 --->
										<cfset attributes.employee_id = employee_id>
										<cfinclude template="emp_offtime_remaining.cfm">
									</td>
									<td class="text-right"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.offtimes&event=upd&offtime_id=#offtime_id#','medium');"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='30923.İzin Güncelle'>"></a></td>
								</tr>
							</cfoutput>
						<cfelse>
							<tr height="20">
								<td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
							</tr>
						</cfif>
					</tbody>
			</div>
		</cf_ajax_list>
	</cf_box>
<script type="text/javascript">
	function kontrol()
	{
		if(!date_check(document.list_offtimes.startdate, document.list_offtimes.finishdate, "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz!'>") )
			return false;
		else
			return true;
	}	
	function kontrol2()
	{
		if(!date_check(document.list_cancel_offtimes.startdate_cancel, document.list_cancel_offtimes.finishdate_cancel, "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz!'>") )
			return false;
		else
			return true;
	}	
	function open_graph()
	{
		<cfoutput>
			list_offtimes.action = '#request.self#?fuseaction=myhome.offtime_graph&startdate=#dateformat((date_add("m",-1,CreateDate(year(now()),month(now()),1))))#&finishdate=#dateformat((Createdate(year(CreateDate(year(now()),month(now()),1)),month(CreateDate(year(now()),month(now()),1)),DaysInMonth(CreateDate(year(now()),month(now()),1)))),dateformat_style)#';
			list_offtimes.submit();
		</cfoutput>
	}
	function delete_offtime(offtime_id)//İzin İptal 20191023ERU
	{
		if (confirm("<cf_get_lang dictionary_id='51682.İzini iptal etmek istediğinize emin misiniz?'>")){
			$.ajax({ 
				type:'POST',  
				url:'V16/myhome/cfc/offtimes.cfc?method=UPDATE_OFFTIMES_CANCEL',
				data: {
					offtime_id : offtime_id
				},
				success: function (returnData) {  
					window.location.reload(); 
				},
				error: function () 
				{
					console.log('CODE:8 please, try again..');
					return false; 
				}
			});
		}
		else
			return false;
	}
</script>
