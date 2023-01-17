<cf_get_lang_set module_name="myhome">
<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')>
    <cf_xml_page_edit fuseact="myhome.my_offtimes">
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
    <cfinclude template="../myhome/query/get_offtimes.cfm">
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
        <cfif PROPERTY_NAME eq 'start_hour_info'>
            <cfset start_hour = PROPERTY_VALUE>
        <cfelseif PROPERTY_NAME eq 'start_min_info'>
            <cfset start_min = PROPERTY_VALUE>
        <cfelseif PROPERTY_NAME eq 'finish_hour_info'>
            <cfset finish_hour = PROPERTY_VALUE>
        <cfelseif PROPERTY_NAME eq 'finish_min_info'>
            <cfset finish_min = PROPERTY_VALUE>
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
                    daycode = '#dateformat(temp_izin_gunu,'dd/mm/yyyy')#';
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
                        SELECT * FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= '#get_offtime.startdate#' AND FINISHDATE >= '#get_offtime.startdate#'
                    </cfquery>
                    <cfif get_offtime_cat.recordcount and len(get_offtime_cat.SATURDAY_ON)>
                        <cfset saturday_on = get_offtime_cat.SATURDAY_ON>
                    <cfelse>
                        <cfset saturday_on = 1>
                    </cfif>
                    <cfif get_offtime_cat.recordcount and len(get_offtime_cat.DAY_CONTROL)>
                        <cfset day_control_ = get_offtime_cat.DAY_CONTROL>
                    <cfelse>
                        <cfset day_control_ = 0>
                    </cfif>
                    <cfif len(get_emp.IZIN_DATE)>
                        <cfset kidem=datediff('d',get_emp.IZIN_DATE,get_offtime.startdate)>
                    <cfelse>
                        <cfset kidem=0>
                    </cfif>
                    <cfset kidem_yil=kidem/365>
                    <cfscript>
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
                        if(timeformat(izin_startdate_,'HH:MM') lt timeformat('#start_hour#:#start_min#','HH:MM'))
                        {
                            izin_start_hour_ = timeformat('#start_hour#:#start_min#','HH:MM');
                        }
                        else
                        {
                            izin_start_hour_ = 	timeformat(izin_startdate_,'HH:MM');
                        }
                        if(timeformat(izin_finishdate_,'HH:MM') gt timeformat('#finish_hour#:#finish_min#','HH:MM'))
                        {
                            izin_finish_hour_ = timeformat('#finish_hour#:#finish_min#','HH:MM');
                        }
                        else
                        {
                            izin_finish_hour_ = timeformat(izin_finishdate_,'HH:MM');
                        }
                        
                        if(izin_start_hour_ gt timeformat('#start_hour#:#start_min#','HH:MM'))
                        {
                            fark = fark+datediff("n",izin_start_hour_,timeformat('#finish_hour#:#finish_min#','HH:MM'));
                            fark = fark/60;
                        }
                        else
                        {
                            fark = fark+datediff("n",izin_start_hour_,timeformat('#start_hour#:#start_min#','HH:MM'));
                            fark = fark/60;
                        }
                        fark2 = fark2+datediff("n",timeformat('#start_hour#:#start_min#','HH:MM'),izin_finish_hour_);
                        fark2 = fark2/60;
                        if(fark gt 0 and fark lte day_control_)
                        {
                            if(not listfind(halfofftime_list,'#dateformat(startdate,"dd/mm/yyyy")#')) //saatten oluşan yarım günlük izine yarım günlük genel tatil gunune denk gelmiyorsa girecek
                            temporary_halfday_total = temporary_halfday_total + 1;
                            halfofftime_list2 = listappend(halfofftime_list2,'#dateformat(startdate,"dd/mm/yyyy")#');
                        }
                        if(fark2 gt 0 and fark2 lte day_control_)
                        {
                            if(not listfind(halfofftime_list,'#dateformat(finishdate,"dd/mm/yyyy")#')) //saatten oluşan yarım günlük izine yarım günlük genel tatil gunune denk gelmiyorsa girecek
                            temporary_halfday_total = temporary_halfday_total + 1;
                            halfofftime_list2 = listappend(halfofftime_list2,'#dateformat(finishdate,"dd/mm/yyyy")#');
                        }
                        for (mck_=0; mck_ lt total_izin_; mck_=mck_+1)
                        {
                            temp_izin_gunu_ = date_add("d",mck_,izin_startdate_);
                            daycode_ = '#dateformat(temp_izin_gunu_,"dd/mm/yyyy")#';
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
                        }
                        if(get_offtime.is_paid neq 1 and get_offtime.ebildirge_type_id neq 21) // ucretli isaretli degilse ve bildirge karşılığı diger ücretsiz izinden farklı ise genel tatil ve hafta tatili dusulmez
                        {
                            izin_gun = total_izin_ - (0.5 * temporary_halfday_total) ; //+ (0.5 * temporary_halfofftime)
                        }
                        else
                        {
                            izin_gun = total_izin_ - temporary_sunday_total_ - temporary_offday_total_ - (0.5 * temporary_halfday_total) + (0.5 * temporary_halfofftime);
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
                    if(datediff("m",bitis_tarihi_,now()) lt 0)				
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
                        get_offtime_limit=cfquery(datasource="#dsn#",sqlstring="SELECT TOP 1 ISNULL(LIMIT_1_DAYS,0) LIMIT_1_DAYS, ISNULL(LIMIT_2_DAYS,0) LIMIT_2_DAYS, ISNULL(LIMIT_3_DAYS,0) LIMIT_3_DAYS, ISNULL(LIMIT_4_DAYS,0) LIMIT_4_DAYS,MIN_MAX_DAYS,MIN_YEARS,MAX_YEARS,LIMIT_1,LIMIT_2,LIMIT_3,LIMIT_ID FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= #baslangic_tarih_# AND FINISHDATE >= #baslangic_tarih_#"&tmp_group_id);	
                        
                        if(get_offtime_limit.recordcount)
                        {
                            if(tck lte get_offtime_limit.limit_1)
                                eklenecek = get_offtime_limit.limit_1_days;
                            else if(tck gt get_offtime_limit.limit_1 and tck lte get_offtime_limit.limit_2)
                                eklenecek = get_offtime_limit.limit_2_days;
                            else if(tck gt get_offtime_limit.limit_2 and tck lte get_offtime_limit.limit_3)
                                eklenecek = get_offtime_limit.limit_3_days;
                            else 
                                eklenecek = get_offtime_limit.limit_4_days;
                            
                            if(len(get_emp.birth_date) and eklenecek lt get_offtime_limit.min_max_days and (datediff("yyyy",get_emp.birth_date,kontrol_date) lt get_offtime_limit.min_years or datediff("yyyy",get_emp.birth_date,kontrol_date) gt get_offtime_limit.max_years))
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
                            else 
                                eklenecek = get_offtime_limit.LIMIT_4_DAYS;
                            
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
        </cfscript>    
        <cfset kalan_izin = toplam_hakedilen_izin - genel_izin_toplam - old_days>
    <cfelse>
        <cfset kalan_izin = 0>
    </cfif>
    <cfquery name="get_position_code" datasource="#dsn#">
        SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND IS_MASTER = 1
    </cfquery>
    <!-- sil -->
    <cfif attributes.maxrows lt attributes.totalrecords>
		<cfset url_str = "">
        <cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.emp_name') and len(attributes.emp_name)>
            <cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
        </cfif>
        <cfif isdefined('attributes.offtimecat_id') and len(attributes.offtimecat_id)>
            <cfset url_str = "#url_str#&offtimecat_id=#attributes.offtimecat_id#">
        </cfif>
        <cfif isdefined('attributes.startdate') and len(attributes.startdate)>
            <cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#">
        </cfif>
        <cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
            <cfset url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#">
        </cfif>
    </cfif>
    <!-- sil -->
	<cfset employee_list=''>
    <cfinclude template="../myhome/query/get_other_offtimes.cfm">
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
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cf_xml_page_edit fuseact="ehesap.form_add_offtime_popup">
    <cfquery name="get_position_detail" datasource="#dsn#">
        SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2 FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.EMPLOYEE_ID = #attributes.employee_id# AND IS_MASTER = 1
    </cfquery>
    <cfquery name="GET_OFFTIME_CATS" datasource="#dsn#">
        SELECT * FROM SETUP_OFFTIME WHERE IS_ACTIVE = 1 AND IS_REQUESTED = 1 ORDER BY OFFTIMECAT
    </cfquery>
    <cfquery name="get_in_out" datasource="#dsn#">
        SELECT MAX(IN_OUT_ID) AS IN_OUT_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfset attributes.offtime_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.offtime_id,accountKey:'wrk') />
    <cfif (isDefined('attributes.offtime_id') and (not len(attributes.offtime_id)))>
        <script type="text/javascript">
            alert("<cf_get_lang_main no='1531.Boyle Bir Kayıt Bulunmamaktadir'>!");
            window.close(); 
        </script>
        <cfabort>
    </cfif>
    <cfinclude template="../myhome/query/get_offtime.cfm">
    <cfif len(get_offtime.startdate)>
		<cfset start_=date_add('h',session.ep.time_zone,get_offtime.startdate)>
    <cfelse>
        <cfset start_="">
    </cfif>
    <cfif len(get_offtime.finishdate)>
        <cfset end_=date_add('h',session.ep.time_zone,get_offtime.finishdate)>
    <cfelse>
        <cfset end_="">
    </cfif>
    <cfif len(get_offtime.work_startdate)>
        <cfset work_startdate=date_add('h',session.ep.time_zone,get_offtime.work_startdate)>
    <cfelse>
        <cfset work_startdate="">
    </cfif>
    <cfinclude template="../myhome/query/get_offtime_cats.cfm">
<cfelseif isdefined("attributes.event") and attributes.event is 'list_emp'>
	<cf_get_lang_set module_name="hr">
    <cfquery name="GET_GENERAL_OFFTIMES" datasource="#DSN#">
        SELECT START_DATE,FINISH_DATE,IS_HALFOFFTIME FROM SETUP_GENERAL_OFFTIMES
    </cfquery>
    <cfset attributes.employee_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.employee_id,accountKey:'wrk') />
    <cfif (isDefined('attributes.employee_id') and (not len(attributes.employee_id) or not isnumeric(attributes.employee_id)))>
        <script type="text/javascript">
            alert("<cf_get_lang_main no='1531.Boyle Bir Kayit Bulunmamaktadir'>!");
            window.close(); 
        </script>
        <cfabort>
    </cfif>
    <cfquery name="get_emp" datasource="#dsn#">
        SELECT 
            E.EMPLOYEE_ID,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            E.KIDEM_DATE,
            E.IZIN_DATE,
            E.IZIN_DAYS,
            EI.BIRTH_DATE,
            E.GROUP_STARTDATE,
            (SELECT TOP 1 PUANTAJ_GROUP_IDS FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ORDER BY START_DATE DESC) AS PUANTAJ_GROUP_IDS
        FROM
            EMPLOYEES E
            INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
        WHERE 
            E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
    </cfquery>
    
    <cfif len(get_emp.IZIN_DATE)>
        <!--- Izin baz tarihinden Onceki Izinler --->						
        <cfquery name="get_offtime_old" datasource="#dsn#">
            SELECT 
                OFFTIME.*,
                SETUP_OFFTIME.OFFTIMECAT_ID,
                SETUP_OFFTIME.OFFTIMECAT,
                SETUP_OFFTIME.IS_PAID
            FROM 
                OFFTIME,
                SETUP_OFFTIME
            WHERE
                SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID AND
                OFFTIME.IS_PUANTAJ_OFF = 0 AND
                OFFTIME.VALID = 1 AND
                SETUP_OFFTIME.IS_PAID = 1 AND
                SETUP_OFFTIME.IS_YEARLY = 1	AND
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
                OFFTIME.FINISHDATE < <cfqueryparam cfsqltype="cf_sql_date" value="#get_emp.izin_date#">
            ORDER BY
                STARTDATE DESC
        </cfquery>
        <!--- // İZİN BAZ TARİHİNDEN ÖNCEKİ İZİNLER --->
    </cfif>
    
    <cfquery name="get_offtime" datasource="#dsn#">
        SELECT 
            OFFTIME.*,
            SETUP_OFFTIME.OFFTIMECAT_ID,
            SETUP_OFFTIME.OFFTIMECAT,
            SETUP_OFFTIME.IS_PAID
        FROM 
            OFFTIME,
            SETUP_OFFTIME
        WHERE
            <cfif len(get_emp.IZIN_DATE)>
                OFFTIME.STARTDATE > <cfqueryparam cfsqltype="cf_sql_date" value="#get_emp.IZIN_DATE#"> AND
            </cfif>
            SETUP_OFFTIME.OFFTIMECAT_ID=OFFTIME.OFFTIMECAT_ID AND
            OFFTIME.IS_PUANTAJ_OFF = 0 AND
            OFFTIME.VALID = 1 AND
            SETUP_OFFTIME.IS_PAID = 1 AND
            SETUP_OFFTIME.IS_YEARLY = 1 AND
            EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
        ORDER BY
            STARTDATE DESC
    </cfquery>
    <cfquery name="get_contract" datasource="#dsn#">
        SELECT * FROM EMPLOYEES_OFFTIME_CONTRACT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> ORDER BY SAL_YEAR DESC
    </cfquery>
    <cfquery name="get_progress_payment_outs" datasource="#dsn#">
        SELECT * FROM EMPLOYEE_PROGRESS_PAYMENT_OUT WHERE EMP_ID = #attributes.employee_id# AND START_DATE IS NOT NULL AND FINISH_DATE IS NOT NULL AND IS_YEARLY = 1
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'dsp'>
	<cfset attributes.offtime_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.offtime_id,accountKey:'wrk') />
    <cfif (isDefined('attributes.offtime_id') and (not len(attributes.offtime_id) or not isnumeric(attributes.offtime_id)))>
        <script type="text/javascript">
            alert("<cf_get_lang_main no='1531.Boyle Bir Kayit Bulunmamaktadir'>!");
            window.close(); 
        </script>
        <cfabort>
    </cfif>
    <cfinclude template="../myhome/query/get_offtime.cfm">
    <cfif len(get_offtime.startdate)>
      <cfset start_=date_add('h',session.ep.time_zone,get_offtime.startdate)>
    <cfelse>
        <cfset start_="">
    </cfif>
    <cfif len(get_offtime.finishdate)>
      <cfset end_=date_add('h',session.ep.time_zone,get_offtime.finishdate)>
    <cfelse>
        <cfset end_="">
    </cfif>
    <cfif len(get_offtime.work_startdate)>
      <cfset work_startdate=date_add('h',session.ep.time_zone,get_offtime.work_startdate)>
    <cfelse>
         <cfset work_startdate="">
    </cfif>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')>
		function kontrol()
		{
			if(!date_check(document.list_offtimes.startdate, document.list_offtimes.finishdate, "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz!'>") )
				return false;
			else
				return true;
		}	
		function open_graph()
		{
			<cfoutput>
				list_offtimes.action = '#request.self#?fuseaction=myhome.offtime_graph&startdate=#dateformat((date_add("m",-1,CreateDate(year(now()),month(now()),1))))#&finishdate=#dateformat((Createdate(year(CreateDate(year(now()),month(now()),1)),month(CreateDate(year(now()),month(now()),1)),DaysInMonth(CreateDate(year(now()),month(now()),1)))),'dd/mm/yyyy')#';
				list_offtimes.submit();
			</cfoutput>
		}
	
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
		function check()
		{	
			<cfif attributes.event is 'add'>
				if (offtime_request.employee_id.value.length == 0)
				{
					alert("<cf_get_lang no='426.Çalışan Seçiniz'>!");
					return false;
				}
				if (offtime_request.validator_position_code_1.value.length == 0)
				{
					alert("<cf_get_lang no='427.Onaylayacak Seçiniz'>!");
					return false;
				}
				function change_upper_pos_codes()
				{
					var emp_upper_pos_code = wrk_query('SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2,POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = '+document.offtime_request.employee_id.value,'dsn');
					var emp_upper_pos_name = wrk_query('SELECT E.EMPLOYEE_NAME FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE,'dsn');
					var emp_upper_pos_surname = wrk_query('SELECT E.EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE,'dsn');
					var emp_upper_pos_name2 = wrk_query('SELECT E.EMPLOYEE_NAME  FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE2,'dsn');
					var emp_upper_pos_surname2 = wrk_query('SELECT E.EMPLOYEE_SURNAME  FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE2,'dsn');
				
					if(<cfoutput>#session.ep.userid#</cfoutput> != document.offtime_request.employee_id.value)
					{
						if(emp_upper_pos_code.UPPER_POSITION_CODE)
							document.getElementById('validator_position_code_1').value = emp_upper_pos_code.UPPER_POSITION_CODE;
						else
							document.getElementById('validator_position_code_1').value = '';
						if(emp_upper_pos_name.EMPLOYEE_NAME)
							document.getElementById('validator_position_1').value = emp_upper_pos_name.EMPLOYEE_NAME;
						else
							document.getElementById('validator_position_1').value = '';
						if(emp_upper_pos_surname.EMPLOYEE_SURNAME)
							document.getElementById('validator_position_1').value += ' ' + emp_upper_pos_surname.EMPLOYEE_SURNAME;
						else
							document.getElementById('validator_position_1').value = '';
						if(emp_upper_pos_code.UPPER_POSITION_CODE2)
							document.getElementById('validator_position_code_2').value = emp_upper_pos_code.UPPER_POSITION_CODE2;
						else
							document.getElementById('validator_position_code_2').value = '';
						if(emp_upper_pos_name2.EMPLOYEE_NAME)
							document.getElementById('validator_position_2').value = emp_upper_pos_name2.EMPLOYEE_NAME;
						else
							document.getElementById('validator_position_2').value = '';
						if(emp_upper_pos_surname2.EMPLOYEE_SURNAME)
							document.getElementById('validator_position_2').value += ' ' + emp_upper_pos_surname2.EMPLOYEE_SURNAME;
						else
							document.getElementById('validator_position_2').value = '';
					}
				}
			</cfif>
			if ($('#offtimecat_id').val().length == 0)
			{
				alert("<cf_get_lang_main no='1535.Kategori Seçmelisiniz'>!");
				return false;
			}
			if ((offtime_request.startdate.value.length != 0) && (offtime_request.finishdate.value.length != 0))
				if(!time_check(offtime_request.startdate,offtime_request.start_clock,offtime_request.start_minute,offtime_request.finishdate,offtime_request.finish_clock,offtime_request.finish_minute,"<cf_get_lang no ='1166.Başlangıç Tarihi Bitiş Tarihinden Küçük olmalıdır'> !")) return false;
			if ((offtime_request.work_startdate.value.length != 0) && (offtime_request.finishdate.value.length != 0))
			{
			
				tarih1_ = offtime_request.finishdate.value.substr(6,4) + offtime_request.finishdate.value.substr(3,2) + offtime_request.finishdate.value.substr(0,2);
				tarih2_ = offtime_request.work_startdate.value.substr(6,4) + offtime_request.work_startdate.value.substr(3,2) + offtime_request.work_startdate.value.substr(0,2);
				
				if (offtime_request.finish_clock.value.length < 2) saat1_ = '0' + offtime_request.finish_clock.value; else saat1_ = offtime_request.finish_clock.value;
				if (offtime_request.finish_minute.value.length < 2) dakika1_ = '0' + offtime_request.finish_minute.value; else dakika1_ = offtime_request.finish_minute.value;
				if (offtime_request.work_start_clock.value.length < 2) saat2_ = '0' + offtime_request.work_start_clock.value; else saat2_ = offtime_request.work_start_clock.value;
				if (offtime_request.work_start_minute.value.length < 2) dakika2_ = '0' + offtime_request.work_start_minute.value; else dakika2_ = offtime_request.work_start_minute.value;
			
				tarih1_ = tarih1_ + saat1_ + dakika1_;
				tarih2_ = tarih2_ + saat2_ + dakika2_;
				
				if (tarih1_ > tarih2_) 
				{			

					alert("İşe Başlama Tarihi İzin Bitiş Tarihinden Küçük olmamalıdır !");
					offtime_request.work_startdate.focus();
					return false;
				}
				/*return false;*/
			}
			return process_cat_control();
		}
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.my_offtimes';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/my_offtimes.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.form_add_offtime_popup';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'myhome/form/form_add_offtime.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'myhome/query/add_offtime.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.my_offtimes';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.form_upd_offtime_popup';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'myhome/form/form_upd_offtime.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'myhome/query/upd_offtime_emp.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'myhome.my_offtimes';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'offtime_id=##get_offtime.offtime_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_offtime.offtime_id##';
	
	WOStruct['#attributes.fuseaction#']['list_emp'] = structNew();
	WOStruct['#attributes.fuseaction#']['list_emp']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['list_emp']['fuseaction'] = 'myhome.popup_list_offtime';
	WOStruct['#attributes.fuseaction#']['list_emp']['filePath'] = 'myhome/display/list_offtime_emp.cfm';
	
	WOStruct['#attributes.fuseaction#']['dsp'] = structNew();
	WOStruct['#attributes.fuseaction#']['dsp']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['dsp']['fuseaction'] = 'myhome.popup_dsp_my_offtime';
	WOStruct['#attributes.fuseaction#']['dsp']['filePath'] = 'myhome/display/dsp_my_offtime.cfm';


	if(IsDefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_offtime&OFFTIME_ID=#get_offtime.OFFTIME_ID#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'myhome/query/del_offtime.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'myhome/query/del_offtime.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'myhome.my_offtimes';
	}
	if(IsDefined("attributes.event") and attributes.event is 'list')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['text'] = '#lang_array.item[1384]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['onClick'] = "open_graph()";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	if(IsDefined("attributes.event") and attributes.event is 'upd')
	{		

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&iid=#get_offtime.offtime_id#&print_type=175</cfoutput>','page')";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
