<cfcomponent>
	<cfsetting requesttimeout="2000">    
    <cffunction name="CONTROL_TIME_COST" output="false">
    	<cfargument name="fuseaction" required="yes">
        <cfargument name="dsn" required="yes">
        <cfset returnValue = 0>
        <cfset freeFuseactionList = 'myhome.upd_myweek,myhome.my_offtimes,myhome.add_my_week_timecost,objects.popup_list_projects,objects.popup_list_all_pars,objects.popup_add_work,objects.popup_expense_center,myhome.popup_add_crm,objects.popup_list_events,objects.popup_list_subscription,myhome.popup_list_training_classes'>
		<cfif not listFindNoCase(freeFuseactionList,arguments.fuseaction,',')>
            <cfset Now_ = DateAdd('d',0,now())>
            <cfset Now_Date = CreateOdbcDateTime(CreateDateTime(Year(Now_),Month(Now_),Day(Now_),0,0,0))>
            <cfset Old_Date = CreateOdbcDateTime(CreateDateTime(Year(Now_),Month(Now_),Day(Now_),0,0,0)-1)>
        
            <cfif not isdefined("session.ep.time_cost_control")>
                <cfquery name="GET_OUR_COMPANY_CONTROL" datasource="#arguments.DSN#">
                    SELECT IS_TIME,ISNULL(IS_TIME_STYLE,1) IS_TIME_STYLE, TIME_CONTROL_DATE FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                </cfquery>
                <cfset session.ep.time_cost_control = get_our_company_control.is_time>
                <cfset session.ep.time_cost_control_type = get_our_company_control.is_time_style>
                <cfset session.ep.time_cost_control_date = get_our_company_control.time_control_date>
            </cfif>
        
            <!--- Zaman Harcamasi Kontrolu Yapilacaksa ve Kontrol Tipi Secilmisse --->
            <cfif session.ep.time_cost_control eq 1 and ListFind("1,2",session.ep.time_cost_control_type,",")>
                <cfquery name="GET_EMPLOYEE_HOUR_CONTROL" datasource="#arguments.DSN#">
                    SELECT ISNULL(TIME_COST_CONTROL,0) TIME_COST_CONTROL,ISNULL(ON_HOUR,0) ON_HOUR,ISNULL(ON_HOUR_DAILY,0) ON_HOUR_DAILY, ISNULL((SELECT TOP 1 RECORD_DATE FROM EMPLOYEE_POSITIONS_HISTORY WHERE POSITION_ID = EMPLOYEE_POSITIONS.POSITION_ID ORDER BY HISTORY_ID DESC),UPDATE_DATE) POSITION_STARTDATE FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                </cfquery>
                <cfif GET_EMPLOYEE_HOUR_CONTROL.TIME_COST_CONTROL eq 0><!--- Eğer pozisyon detayda zaman harcaması kontrolü yapılmasın seçili ise kontrol yapılacak --->
                    <!--- Eger Sirket Akis Parametrelerinde Zaman Harcamasi Kontrol Baslangic Tarihi Var Ise O Tarihten Itıbaren Alinir, Yoksa Calisan Ise Baslama Tarihinden Itıbaren Alinir --->
                    <cfif isDefined("session.ep.time_cost_control_date") and isDate(session.ep.time_cost_control_date)>
                        <cfset WStart = session.ep.time_cost_control_date>
                    <cfelse>
                        <cfset WStart = get_employee_hour_control.position_startdate>
                    </cfif>
                    <cfset Employee_WorkStart_Day = CreateOdbcDateTime(CreateDateTime(Year(WStart),Month(WStart),Day(WStart),0,0,0))>
                    
                    <!--- Aylik Calisma Saati Zorunlu Oldugundan Oncelikle Bu Deger Girilmis Mi Diye Kontrol Ediliyor --->
                    <cfif Get_Employee_Hour_Control.On_Hour gt 0 and len(Get_Employee_Hour_Control.On_Hour_Daily)>
                        <!--- Kontrol Tipi : Gunluk --->
                        <cfif session.ep.time_cost_control_type eq 2>
                            <!--- Gunluk Zaman Harcamasi Girilmisse Gunluk Kontrol Yapilir --->
                            <cfif Get_Employee_Hour_Control.On_Hour_Daily gt 0>
                                <cfset Daily_Minute_Limit = Get_Employee_Hour_Control.On_Hour_Daily*60>
                                
                                <cfset All_WorkDay_List= "">
                                <cfset All_Old_WorkDay_List= "">
                                <cfset Full_WorkDay_List = "">
                                <cfset InComplete_WorkDay_List = "">
                                <cfscript>
                                    //Bu Ay Icerisindeki Is Gunleri
                                    if(Day(Now_Date) gt 1)
                                    {
                                        for(x=1;x<Day(Now_Date);x++)
                                        {
                                            MonthDays = CreateOdbcDateTime(CreateDateTime(Year(Now_Date),Month(Now_Date),x,0,0,0));
                                            if(not ListFind("1,7",DayofWeek(MonthDays),',') and DateDiff('d',Employee_WorkStart_Day,MonthDays) gte 1)
                                                All_WorkDay_List = ListAppend(All_WorkDay_List,x,",");
                                        }
                                        InComplete_WorkDay_List = All_WorkDay_List;
                                    }
                                    //Aysonu Ise, Onceki Aya Bakmasi Lazim, Gun Kacmasin Aradan
                                    if(not Len(All_WorkDay_List))
                                    {
                                        for(x=1;x<=Day(Old_Date);x++)
                                        {
                                            MonthDaysOld = CreateOdbcDateTime(CreateDateTime(Year(Old_Date),Month(Old_Date),x,0,0,0));
                                            if(not ListFind("1,7",DayofWeek(MonthDaysOld),',') and DateDiff('d',Employee_WorkStart_Day,MonthDaysOld) gte 1)
                                                All_Old_WorkDay_List = ListAppend(All_Old_WorkDay_List,x,",");
                                        }
                                        InComplete_WorkDay_List = All_Old_WorkDay_List;
                                    }
                                </cfscript>
                                
                                <!--- Bu Ay Icerisinde, Tamamlanmis Harcamalar --->
                                <cfif Len(All_WorkDay_List)>
                                    <cfquery name="GET_FULL_TIME_COST_WORKDAY" datasource="#arguments.DSN#">
                                        SELECT
                                            ISNULL(SUM(EXPENSED_MINUTE),0) AS TOTAL_MINUTE,
                                            DAY(EVENT_DATE) EVENT_DAY
                                        FROM
                                            TIME_COST
                                        WHERE
                                            EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
                                            YEAR(EVENT_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#Year(Now_Date)#"> AND
                                            MONTH(EVENT_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#Month(Now_Date)#"> AND
                                            DAY(EVENT_DATE) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#All_WorkDay_List#" list="yes">)
                                        GROUP BY
                                            DAY(EVENT_DATE)
                                        HAVING
                                            ISNULL(SUM(EXPENSED_MINUTE),0) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#Daily_Minute_Limit#">
                                    </cfquery>
                                    <cfset Full_WorkDay_List = ValueList(Get_Full_Time_Cost_WorkDay.Event_Day,",")>
                                </cfif>
                                
                                <!--- Bu Ay Icin Sorun Yoksa Onceki Ay Icerisinde, Tamamlanmis Harcamalar --->
                                <cfif not Len(All_WorkDay_List) and Len(All_Old_WorkDay_List)>
                                    <cfquery name="GET_FULL_TIME_COST_WORKDAY" datasource="#arguments.DSN#">
                                        SELECT
                                            ISNULL(SUM(EXPENSED_MINUTE),0) AS TOTAL_MINUTE,
                                            DAY(EVENT_DATE) EVENT_DAY
                                        FROM
                                            TIME_COST
                                        WHERE
                                            EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
                                            YEAR(EVENT_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#Year(Old_Date)#"> AND
                                            MONTH(EVENT_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#Month(Old_Date)#"> AND
                                            DAY(EVENT_DATE) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#All_Old_WorkDay_List#" list="yes">)
                                        GROUP BY
                                            DAY(EVENT_DATE)
                                        HAVING
                                            ISNULL(SUM(EXPENSED_MINUTE),0) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#Daily_Minute_Limit#">
                                    </cfquery>
                                    <cfset Full_WorkDay_List = ValueList(Get_Full_Time_Cost_WorkDay.Event_Day,",")>
                                </cfif>
                                
                                <cfif ListLen(Full_WorkDay_List)>
                                    <cfloop list="#Full_WorkDay_List#" index="wdl">
                                        <cfset InComplete_WorkDay_List = ListDeleteAt(InComplete_WorkDay_List,ListFind(InComplete_WorkDay_List,wdl,","),",")>
                                    </cfloop>
                                </cfif>
                                <cfif ListLen(InComplete_WorkDay_List)>
                                	<cfset returnValue = 2351><!--- Gün bazında zaman harcamanızda eksik saatler bulunmaktadır. --->
                                <cfelse>
                                    <cfset session.ep.time_cost_control = 0>
                                </cfif>
                            </cfif>
                        <!--- Kontrol Tipi : Haftalik --->
                        <cfelse>
                            <cfscript>
                                limit = Get_Employee_Hour_Control.On_Hour;
                                control_time = (limit/4) * 60;
                                tarih = dateformat(now(),'yyyy-mm-dd');
                                fark = (-1)*(dayofweek(tarih)-2);
                                if (fark eq 1) fark = -6;
                                last_week_start = application.functions.date_add('d',fark-7,tarih);
                                first_day = application.functions.date_add('d',fark,tarih);
                            </cfscript>
                            <cfquery name="GET_TIME" datasource="#arguments.DSN#">
                                SELECT 
                                    SUM(EXPENSED_MINUTE) AS TOTAL
                                FROM
                                    TIME_COST
                                WHERE
                                    EVENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_week_start#"> AND
                                    EVENT_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#first_day#"> AND
                                    EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                            </cfquery>
                            <cfif get_time.recordcount and len(get_time.total)>
                                <cfset total_calisma = get_time.total>
                            <cfelse>
                                <cfset total_calisma = 0>
                            </cfif>
                            <cfif total_calisma lt control_time>
                            	<cfset returnValue = 2350><!--- Haftalık Zaman Harcamasını Doldurmadınız! Sistem İşlem Yapmanıza İzin Vermeyecektir. --->
                            <cfelse>
                                <cfset session.ep.time_cost_control = 0>
                            </cfif>
                        </cfif>
                        <!--- //Kontrol Tipi --->
                    </cfif>
                </cfif>
                <!--- //Aylik Calisma Saati Zorunlu Oldugundan Oncelikle Bu Deger Girilmis Mi Diye Kontrol Ediliyor --->
            </cfif>
            <!--- //Zaman Harcamasi Kontrolu Yapilacaksa ve Kontrol Tipi Secilmisse --->
        </cfif>
        <cfreturn returnValue>
    </cffunction>
	
</cfcomponent>
