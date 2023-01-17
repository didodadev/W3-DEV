<!---
File: get_offtime_calc_control.cfc
Author: Workcube-Botan Kayğan <botankaygan@workcube.com>
Date: 07.05.2021
Controller: -
Description: İzin raporunda talep tarihindeki kalan izin bilgisinin hesaplanması için oluşturulmuştur.
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset date_add = createObject("component","WMO.functions").date_add>
    <cfset cfquery = createObject("component","WMO.functions").cfquery>

    <cffunction name="get_hakedis" access="public" returntype="any">
        <cfargument name="employee_id" default="">
        <cfargument name="mutabakat_year" default="">
        <cfargument name="talep_tarihi" default="#now()#">
        <cfset arguments.talep_tarihi = createodbcdatetime(arguments.talep_tarihi)> 
        <cfquery name="get_emp" datasource="#dsn#">
            SELECT 
                E.EMPLOYEE_ID,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                E.KIDEM_DATE,
                E.IZIN_DATE,
                E.IZIN_DAYS,
                E.OLD_SGK_DAYS,
                EI.BIRTH_DATE,
                E.GROUP_STARTDATE,
                (SELECT TOP 1 PUANTAJ_GROUP_IDS FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.talep_tarihi#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.talep_tarihi#"> ORDER BY START_DATE DESC) AS PUANTAJ_GROUP_IDS,
                (SELECT TOP 1 FINISH_DATE FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.talep_tarihi#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.talep_tarihi#"> ORDER BY START_DATE DESC) AS FINISH_DATE
            FROM
                EMPLOYEES E
                INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
            WHERE 
                E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
        </cfquery>

        <cfquery name="get_progress_payment_outs" datasource="#dsn#">
            SELECT 
                START_DATE,FINISH_DATE 
            FROM 
                EMPLOYEE_PROGRESS_PAYMENT_OUT 
            WHERE 
                EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> AND 
                START_DATE IS NOT NULL AND FINISH_DATE IS NOT NULL AND IS_YEARLY = 1
            UNION ALL
            SELECT 
                STARTDATE AS START_DATE,
                FINISHDATE AS FINISH_DATE 
            FROM 
                OFFTIME,SETUP_OFFTIME 
            WHERE
                (
                    (
                    OFFTIME.SUB_OFFTIMECAT_ID = 0 AND
                    OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
                    )
                    OR
                    OFFTIME.SUB_OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
                ) AND
                OFFTIME.IS_PUANTAJ_OFF = 0 AND
                OFFTIME.VALID = 1 AND
                SETUP_OFFTIME.IS_OFFDAY_DELAY = 1 AND
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
        </cfquery>

        <cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
        <!--- İzin Süreleri XML'den ayarlanan 'Kaç yıldan itibaren geçmiş günün hesaba katılsın?' parametresi 20191030ERU --->
        <cfset get_offtime_old_sgk_year = get_fuseaction_property.get_fuseaction_property(
            company_id : session.ep.company_id,
            fuseaction_name : 'ehesap.offtime_limit',
            property_name : 'x_old_sgk_days'
            )
            >
        <cfif get_offtime_old_sgk_year.recordcount>
            <cfset calc_old_sgk_year = get_offtime_old_sgk_year.property_value>
            <cfif not len(calc_old_sgk_year)>
                <cfset calc_old_sgk_year = 0>
            </cfif>
        <cfelse>
            <cfset calc_old_sgk_year = 0>
        </cfif>

        <!--- E-Profilde 'Geçmiş SGK Günü Girilsin mi?' parametresi 20191030ERU --->
        <cfset get_old_sgk_year = get_fuseaction_property.get_fuseaction_property(
            company_id : session.ep.company_id,
            fuseaction_name : 'hr.form_upd_emp',
            property_name : 'xml_old_sgk_days'
        )>

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
            old_tck = 0;
            toplam_hakedilen_izin = 0;
            diff_ = 0;
            my_giris_date = get_emp.IZIN_DATE;
            flag = true;
            if(len(arguments.mutabakat_year)){
                mutabakat_date = CreateDateTime(arguments.mutabakat_year+1,DatePart('m', my_giris_date),DatePart('d', my_giris_date),00,00,00);
                baslangic_tarih_ = mutabakat_date;
                diff_ = datediff('yyyy',my_giris_date,mutabakat_date);
            }
            else{
                baslangic_tarih_ = my_giris_date;
            }
            my_baz_date = arguments.talep_tarihi;
            if(len(get_emp.FINISH_DATE))
            {
                finish_date = get_emp.FINISH_DATE;	
            }else{
                finish_date = '';
            }
            if(not len(baslangic_tarih_))
                baslangic_tarih_ = now();
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
                old_tck = datediff('yyyy',my_giris_date,my_baz_date) + 1;
                while(flag)
                {
                    bitis_tarihi_ = createodbcdatetime(date_add("m",get_def_type.limit_1,baslangic_tarih_));
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
                        eklenecek = get_def_type.limit_1_days;
                        if(len(get_emp.birth_date) and eklenecek lt get_def_type.min_max_days and (datediff("yyyy",get_emp.birth_date,kontrol_date) lt get_def_type.min_years or datediff("yyyy",get_emp.birth_date,kontrol_date) gt get_def_type.max_years))
                            eklenecek = get_def_type.min_max_days;
                        if(tck_ neq 1 and eklenecek neq 0) 
                        {
                            toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
                        }
                    }
                    ilk_tarih_ = baslangic_tarih_;
                    baslangic_tarih_ = bitis_tarihi_;
                    bitis_tarihi_ = date_add("m",get_def_type.limit_1,bitis_tarihi_);
                    if(datediff("d",baslangic_tarih_,arguments.talep_tarihi) lt 0)				
                        flag = false;
                }
            }
            else 
            {
                //xmlden geçmiş sgk günü gelsin işaretliyse ve izin süreleri xml'inden yıl bilgisi girildiyse ve Yıl bilgisi girilmişse 20191030ERU 
                if(get_offtime_old_sgk_year.recordcount and get_old_sgk_year.recordcount and get_old_sgk_year.property_value eq 1 and len(calc_old_sgk_year))
                {
                    old_sgk_year = 0;
                    if(len(get_emp.OLD_SGK_DAYS))
                        old_sgk_year = get_emp.OLD_SGK_DAYS / 360;//Geçmiş zaman sgk günü 360 gün üzerinden yılı hesaplanıyor.
                }
                total_row = 0;
                tck = tck + diff_;
                while(flag)
                {
                    bitis_tarihi_ = createodbcdatetime(date_add("yyyy",1,baslangic_tarih_));
                    baslangic_tarih_ = createodbcdatetime(baslangic_tarih_);
                    ilk_tarih_ = baslangic_tarih_;
                    baslangic_tarih_ = bitis_tarihi_;
                    get_bos_zaman_ = cfquery(
                            Datasource="#dsn#",
                            dbtype="query",
                            sqlstring="SELECT * FROM get_progress_payment_outs WHERE (START_DATE <= #ilk_tarih_# AND FINISH_DATE >= #bitis_tarihi_#) OR (START_DATE >= #ilk_tarih_# AND FINISH_DATE <= #bitis_tarihi_#) OR (START_DATE <= #ilk_tarih_# AND FINISH_DATE >= #ilk_tarih_#) OR (START_DATE <= #ilk_tarih_# AND FINISH_DATE >= #bitis_tarihi_#) OR ((START_DATE BETWEEN #ilk_tarih_# AND #bitis_tarihi_#) AND FINISH_DATE >= #bitis_tarihi_#)");	
                    if(get_bos_zaman_.recordcount eq 0)
                    {
                        //xmlden geçmiş sgk günü gelsin işaretliyse ve izin süreleri xml'inden yıl bilgisi girildiyse ve hesaplama yılı girilen yıla eşitse 20191030ERU 
                        if(get_offtime_old_sgk_year.recordcount and get_old_sgk_year.recordcount and get_old_sgk_year.property_value eq 1 and len(calc_old_sgk_year) and tck eq calc_old_sgk_year and old_tck eq 0)
                        {
                            tck  = tck + int(old_sgk_year);
                        }
                        tck = tck + 1 ; 
                        
                        old_tck = old_tck +1;
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
                                eklenecek = get_offtime_limit.min_max_days;
                                
                            toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
                            
                            //xmlden geçmiş sgk günü gelsin işaretliyse ve izin süreleri xml'inden yıl bilgisi girildiyse ve hesaplama yılı girilen yıla eşitse 20191030ERU 
                            if(get_offtime_old_sgk_year.recordcount and get_old_sgk_year.recordcount and get_old_sgk_year.property_value eq 1 and len(calc_old_sgk_year) and tck eq calc_old_sgk_year and old_tck neq 0)
                            {
                                tck  = tck + int(old_sgk_year);
                            }
                                
                        }
                        else
                        {
                            return "İzin limitleri girilmemiş!";
                        }
                    }
                    else
                    {	
                        eklenecek_gun = 0;	
                        
                        //Peşpeşe İzin ve Kıdemden Sayılmayacak Günler eklendiyse 210416ERU
                        bitis_tarihi__bos = bitis_tarihi_;
                        while(flag)
                        {
                            get_bos_zaman_ = cfquery(
                                Datasource="#dsn#",
                                dbtype="query",
                                sqlstring="SELECT * FROM get_progress_payment_outs WHERE (START_DATE <= #ilk_tarih_# AND FINISH_DATE >= #bitis_tarihi__bos#) OR (START_DATE >= #ilk_tarih_# AND FINISH_DATE <= #bitis_tarihi__bos#) OR (START_DATE <= #ilk_tarih_# AND FINISH_DATE >= #ilk_tarih_#) OR (START_DATE <= #ilk_tarih_# AND FINISH_DATE >= #bitis_tarihi__bos#) OR ((START_DATE BETWEEN #ilk_tarih_# AND #bitis_tarihi__bos#) AND FINISH_DATE >= #bitis_tarihi__bos#)");	

                            eklenecek_gun = 0;
                            for(izd = 1; izd lte get_bos_zaman_.recordcount; izd=izd+1)
                            {
                                if(datediff("d",get_bos_zaman_.start_date[izd],ilk_tarih_) gt 0)
                                {
                                    fark_ = datediff("d",ilk_tarih_,get_bos_zaman_.finish_date[izd]);
                                }
                                else if(datediff("d",get_bos_zaman_.start_date[izd],ilk_tarih_) lte 0)
                                {
                                    fark_ = datediff("d",get_bos_zaman_.start_date[izd],get_bos_zaman_.finish_date[izd]) + 1;
                                }
                                fark_ = datediff("d",get_bos_zaman_.start_date[izd],get_bos_zaman_.finish_date[izd]) + 1;
                                eklenecek_gun = eklenecek_gun + fark_;
                            }
                            
                            if((finish_date neq '' and datediff("yyyy",bitis_tarihi__bos,finish_date) lt 0) or (finish_date eq '' and datediff("yyyy",bitis_tarihi__bos,arguments.talep_tarihi) lt 0))			
                            {
                                flag = false;
                            }
                            else
                            {
                                bitis_tarihi__bos = date_add("d",eklenecek_gun,bitis_tarihi__bos);
                            }
                            
                            
                        }									
                        bitis_tarihi_ = date_add("d",eklenecek_gun,bitis_tarihi_);
                        tck = tck + 1; 
                        old_tck = old_tck + 1;
                        kontrol_date = bitis_tarihi_;
                        get_offtime_limit=cfquery(datasource="#dsn#",sqlstring="SELECT * FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= #bitis_tarihi_# AND FINISHDATE >= #bitis_tarihi_#"&tmp_group_id);	
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
                                eklenecek = get_offtime_limit.min_max_days;
                            //xmlden geçmiş sgk günü gelsin işaretliyse ve izin süreleri xml'inden yıl bilgisi girildiyse ve hesaplama yılı girilen yıla eşitse 20191030ERU 
                            if(get_offtime_old_sgk_year.recordcount and get_old_sgk_year.recordcount and get_old_sgk_year.property_value eq 1 and len(calc_old_sgk_year) and tck eq calc_old_sgk_year)
                            {
                                tck  = tck + int(old_sgk_year);
                            }
                            //if(tck neq 1 and eklenecek neq 0) 
                            {
                                toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
                            }
                        }
                        else
                        {
                            return "İzin limitleri girilmemiş!";
                        }
                    }	
                    ilk_tarih_ = baslangic_tarih_;
                    baslangic_tarih_ = bitis_tarihi_;
                    bitis_tarihi_ = date_add("yyyy",1,bitis_tarihi_);
                    
                    if((finish_date neq '' and datediff("yyyy",bitis_tarihi_,finish_date) lt 0) or (finish_date eq '' and datediff("yyyy",bitis_tarihi_,arguments.talep_tarihi) lt 0))			
                    {
                        flag = false;
                    }
                }
            }
        </cfscript>

        <cfreturn toplam_hakedilen_izin>
    </cffunction>

</cfcomponent>