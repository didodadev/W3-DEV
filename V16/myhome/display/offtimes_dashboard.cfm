<!--- Çalışanın mutabakatı --->
<cfscript>
    cmp_eoc= createObject("component","V16.hr.cfc.get_employees_offtime_contract");
    cmp_eoc.dsn = dsn;
    get_contract_employees = cmp_eoc.get_contract_employees(
        employee_id : attributes.employee_id
    );
</cfscript>
<cfset free_time_cmp = createObject("component","V16.myhome.cfc.free_time")>
<cfset calc_var_query = free_time_cmp.CALC_FREE_TIME(employee_id : attributes.employee_id)>

<!--- Çalışanın mutabakatı varsa mutabakattan gelen değerleri alır --->
<cfsavecontent variable="izin_hesap"><cfinclude template="/V16/hr/display/list_offtime_emp.cfm"></cfsavecontent><!--- BK-29122020 --->
<cfoutput>
    <div class="ui-dashboard ui-dashboard_type3">
        <div class="ui-dashboard-item">
            <div class="ui-dashboard-item-title">
                <cf_get_lang dictionary_id='56636.Toplam Hakedilen İzin'> (<cf_get_lang dictionary_id='56871.Yıllık İzin'>)
            </div>
            <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
                <a href="javascript://">
                    #TlFormat(toplam_hakedilen_izin)#
                </a>
            </div>
        </div>
        <div class="ui-dashboard-item">
            <div class="ui-dashboard-item-title">
                <cf_get_lang dictionary_id='56637.Kullanılan İzin'>  (<cf_get_lang dictionary_id='43082.Yıllık İzin'>)
            </div>
            <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
                <a href="javascript://">
                    #TlFormat(genel_izin_toplam)#
                </a>
            </div>
        </div>
        <div class="ui-dashboard-item">
            <div class="ui-dashboard-item-title">
                <cf_get_lang dictionary_id='56638.Kalan İzin'>  (<cf_get_lang dictionary_id='43082.Yıllık İzin'>)
            </div>
            <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
                <a href="javascript://">
                    #TlFormat(toplam_hakedilen_izin - genel_izin_toplam - old_days)#
                </a>
            </div>
        </div>	
        <div class="ui-dashboard-item">
            <div class="ui-dashboard-item-title">
                <cf_get_lang dictionary_id='63582.Fazla Mesaiden Hakedilen İzin'> (<cf_get_lang dictionary_id='63585.Serbest Zaman'>)
            </div>
            <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
                <a href="javascript://">
                    #tlformat(wrk_round(calc_var_query.FM_DAY))#
                </a>
            </div>
        </div>
        <div class="ui-dashboard-item">
            <div class="ui-dashboard-item-title">
                <cf_get_lang dictionary_id='63583.Fazla Mesaiden Kullanılan İzin'> (<cf_get_lang dictionary_id='63585.Serbest Zaman'>)
            </div>
            <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
                <a href="javascript://">
                    #tlformat(wrk_round(calc_var_query.used_days))#
                </a>
            </div>
        </div>
        <div class="ui-dashboard-item">
            <div class="ui-dashboard-item-title">
                <cf_get_lang dictionary_id='63584.Fazla Mesaiden Kalan İzin'> (<cf_get_lang dictionary_id='63585.Serbest Zaman'>)
            </div>
            <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
                <a href="javascript://">
                    #tlformat(wrk_round(calc_var_query.unused_days))#
                </a>
            </div>
        </div>
    </div>
</cfoutput>
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
<cfquery name="get_offtime_show_entitlements" datasource = "#dsn#">
	SELECT 
		OFFTIMECAT_ID
		,OFFTIMECAT
		,IS_PAID
		,SHOW_ENTITLEMENTS
		,IS_PERMISSION_TYPE
		,WEEKING_WORKING_DAY
		,MAX_PERMISSION_TIME
	FROM 
		SETUP_OFFTIME
	WHERE 
		IS_ACTIVE = 1 
		AND SHOW_ENTITLEMENTS = 1
</cfquery>
<cfscript>
	toplam_hakedilen_izin = 0;
	genel_izin_toplam = 0;
	old_days = 0;
	genel_dk_toplam = 0;
	ext_worktime_day = 0;
	old_sgk_year = 0;
	tahmini_izin_yuku = 0;
	kalan_izin = 0;
</cfscript>
<cfset wdo = createObject("component","V16.myhome.cfc.offtimes")>
<cfset get_offtimes = WDO.GET_OFFTIMES(employee_id : attributes.employee_id,startdate: attributes.startdate, finishdate: attributes.finishdate)>

<div class="ui-dashboard ui-dashboard_type3">
    <cfoutput query = "get_offtime_show_entitlements">
        <cfset get_offtime_cfc = WDO.GET_OFFTIMES_(employee_id : attributes.employee_id,offtimecat_id : OFFTIMECAT_ID)>
        <cfset used_izin_gun = 0>
        <cfif IS_PERMISSION_TYPE eq 2><!--- gün cinsindense --->
            <cfsavecontent variable ="type_name">
                <cf_get_lang dictionary_id="57490.Gün">
            </cfsavecontent>
            <cfloop query="get_offtime_cfc">
                <cfscript>
                    day_total_ = 0;
                    temp_finishdate = CreateDateTime(year(get_offtime_cfc.finishdate),month(get_offtime_cfc.finishdate),day(get_offtime_cfc.finishdate),0,0,0);
                    temp_startdate = CreateDateTime(year(get_offtime_cfc.startdate),month(get_offtime_cfc.startdate),day(get_offtime_cfc.startdate),0,0,0);
                    total_izin_ = fix(temp_finishdate-temp_startdate)+1;
                    izin_startdate_ = date_add("h", session.ep.time_zone, startdate);
                    izin_finishdate_ = date_add("h", session.ep.time_zone, finishdate);
                    if (get_offtime_show_entitlements.WEEKING_WORKING_DAY eq 5)
                        day_total_ = day_total_;
                    else if (get_offtime_show_entitlements.WEEKING_WORKING_DAY eq 6)
                        {
                            for (mck_=0; mck_ lt total_izin_; mck_=mck_+1)
                                {
                                    temp_izin_gunu_ = date_add("d",mck_,izin_startdate_);
                                    if (dayofweek(temp_izin_gunu_) eq 1)
                                        day_total_ = day_total_ + 1;
                                }
                        }	
                    else if (get_offtime_show_entitlements.WEEKING_WORKING_DAY eq 7)
                        {
                            for (mck_=0; mck_ lt total_izin_; mck_=mck_+1)
                                {
                                    temp_izin_gunu_ = date_add("d",mck_,izin_startdate_);
                                    if (dayofweek(temp_izin_gunu_) eq 7)
                                        day_total_ = day_total_ + 2;
                                }									}						
                    used_izin_gun = used_izin_gun + total_izin_ - day_total_;
                </cfscript>
            </cfloop>
        </cfif>
        <cfif IS_PERMISSION_TYPE eq 1><!--- saaat/dk cinsindense --->
            <cfsavecontent variable ="type_name">
                <cf_get_lang dictionary_id="57491.Saat">-<cf_get_lang dictionary_id="58127.Minute">
            </cfsavecontent>
            <cfloop query="get_offtime_cfc">
                <cfscript>
                    izin_start_hour_ = "";
                    izin_finish_hour_ = "";
                    toplam_saat = 0;
                    temp_finishdate = CreateDateTime(year(finishdate),month(finishdate),day(finishdate),0,0,0);
                    temp_startdate = CreateDateTime(year(startdate),month(startdate),day(startdate),0,0,0);
                    total_izin_ = fix(temp_finishdate-temp_startdate)+1;
                    izin_startdate_ = date_add("h", session.ep.time_zone, startdate);
                    izin_finishdate_ = date_add("h", session.ep.time_zone, finishdate);
                    fark = 0;
                    fark2 = 0;
                    if(timeformat(izin_startdate_,timeformat_style) lt timeformat('#start_hour#:#start_min#',timeformat_style) and not len(get_shift.shift_id))//)
                    {
                        izin_start_hour_ = timeformat('#start_hour#:#start_min#',timeformat_style);
                    }
                    else
                    {
                        izin_start_hour_ = 	timeformat(izin_startdate_,timeformat_style);
                    }
                    if(timeformat(izin_finishdate_,timeformat_style) gt timeformat('#finish_hour#:#finish_min#',timeformat_style) and not len(get_shift.shift_id))//)
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
                    fark3 = 0;
                    total_hour = 0;
                    for (mck_=0; mck_ lt total_izin_; mck_=mck_+1)
                    {
                        temp_izin_gunu_ = date_add("d",mck_,izin_startdate_);
                        /* Saatlik izin hesaplama */
                        temp_izin_gunu = CreateDateTime(year(temp_izin_gunu_),month(temp_izin_gunu_),day(temp_izin_gunu_),0,0,0);
                        izin_startdate = CreateDateTime(year(izin_startdate_),month(izin_startdate_),day(izin_startdate_),0,0,0);
                        izin_finishdate = CreateDateTime(year(izin_finishdate_),month(izin_finishdate_),day(izin_finishdate_),0,0,0);
                        if(temp_izin_gunu eq izin_startdate)
                        {
                            izin_start_hour	= timeformat(izin_startdate_,timeformat_style);
                        }
                        else
                        {
                            izin_start_hour = timeformat('#start_hour#:#start_min#',timeformat_style);
                        }
                        if(temp_izin_gunu eq izin_finishdate)
                        {
                            izin_finish_hour = timeformat(izin_finishdate_,timeformat_style);
                        }
                        else
                        {
                            izin_finish_hour = timeformat('#finish_hour#:#finish_min#',timeformat_style);
                        }
                        if(izin_start_hour lte timeformat('12:00',timeformat_style) and izin_finish_hour gte timeformat('13:00',timeformat_style))
                        {
                            izin_finish_hour =timeformat(DateAdd("h",-1,izin_finish_hour),timeformat_style);
                        }
                        fark3 = datediff("n",izin_start_hour,izin_finish_hour);
                        fark3 = fark3/60;
                        if(fark3 gte get_hours.daily_work_hours)
                        {
                            fark3 = get_hours.daily_work_hours;
                        }
                        if(not len(fark3))fark3 = 0;
                        
                        total_hour = total_hour + fark3;
                    }							
                    /* Saatlik izin hesaplama  */
                    used_izin_gun = used_izin_gun + total_hour;
                    toplam_saat = toplam_saat + total_hour;
                </cfscript>
            </cfloop>
        </cfif>
        <cfif IS_PERMISSION_TYPE eq 3><!--- yıl cinsindense --->
            <cfsavecontent variable ="type_name">
                <cf_get_lang dictionary_id="58455.Yıl">
            </cfsavecontent>
            <cfloop query="get_offtime_cfc">
                <cfset temp_finishdate = CreateDateTime(year(finishdate),month(finishdate),day(finishdate),0,0,0)>
                <cfset temp_startdate = CreateDateTime(year(startdate),month(startdate),day(startdate),0,0,0)>						
                <cfset 	used_izin_gun = fix(temp_finishdate-temp_startdate)>
            </cfloop>
        </cfif>
        <div class="ui-dashboard-item">
            <div class="ui-dashboard-item-title">
                <cf_get_lang dictionary_id='64549.Hakedilen izin'> (#OFFTIMECAT#) - (#type_name#)
            </div>
            <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
                <a href="javascript://">
                    <cfif len(MAX_PERMISSION_TIME)>
                        <cfset kalan_izin = MAX_PERMISSION_TIME - used_izin_gun>
                    <cfelse>
                        <cfset kalan_izin = 0>
                    </cfif>
                    <cfif len(MAX_PERMISSION_TIME)>#tlformat(MAX_PERMISSION_TIME)#</cfif>
                </a>
            </div>
        </div>
        <cfif IS_PERMISSION_TYPE eq 1><!--- saaat/dk cinsindense --->
            <cfsavecontent variable ="type_name">
                <cf_get_lang dictionary_id="57491.Saat">-<cf_get_lang dictionary_id="58127.Minute">
            </cfsavecontent>
            <cfset total_min_emp = 0>
            <cfset use_hour = 1>
            <cfloop query="get_offtime_cfc">
                <cfif get_shift.recordcount>
                    <cfinclude template="/V16/hr/ehesap/display/offtime_calc_shift.cfm">
                <cfelse>
                    <cfinclude template="/V16/hr/ehesap/display/offtime_calc.cfm">
                </cfif>
            </cfloop>
            <cfset use_hour = 0>
            <cfif len(MAX_PERMISSION_TIME)>
                <cfset max_per_hour = listfirst(MAX_PERMISSION_TIME,".")*60 + listlast(MAX_PERMISSION_TIME,".")>
                <cfset kalan_izin = max_per_hour - total_min_emp>
            <cfelse>
                <cfset kalan_izin = 0>
            </cfif>
        </cfif>
        <div class="ui-dashboard-item">
            <div class="ui-dashboard-item-title">
                <cf_get_lang dictionary_id='56637.Kullanılan İzin'> (#OFFTIMECAT#)
            </div>
            <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
                <a href="javascript://">
                    #int(total_min_emp / 60)#,#total_min_emp mod 60#
                </a>
            </div>
        </div>
        <div class="ui-dashboard-item">
            <div class="ui-dashboard-item-title">
                <cf_get_lang dictionary_id='31407.Kalan İzin'> (#OFFTIMECAT#)
            </div>
            <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
                <a href="javascript://">
                   #int(kalan_izin / 60)#,#kalan_izin mod 60#
                </a>
            </div>
        </div>
    </cfoutput>
</div>
