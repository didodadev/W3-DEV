<!---
    File: free_time.cfc
    Author: Esma R. UYSAL
    Date: 10/01/2020
    Description:
       Onaylı mesai karşılığı serbest zaman olan Fazla mesailerden İzinlerde serbest zaman hakedişinin hesaplandığı cfc'dir.
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <!--- İzin hesabının yapıldığı fonksiyondur --->
    <cffunction name="CALC_FREE_TIME" access="public" returnFormat="json" returntype="any">
		<cfargument name="employee_id" type="numeric" default="4">
		<cfset get_employee_shift = createObject("component","V16.hr.cfc.get_employee_shift")>
        <cfset total_minute = 0>
        <cfset sal_mon = month(now())>
        <cfset sal_year = year(now())>
        <cfset parameter_last_month_1 = CreateDateTime(sal_year,sal_mon,1,0,0,0)><!---bordro akış parametresi başlangıç ---->
        <cfset parameter_last_month_30 = CreateDateTime(sal_year,sal_mon,daysinmonth(createdate(sal_year,sal_mon,1)),23,59,59)><!--- bordro akış parametresi bitiş --->
        <cfset genel_dk_toplam = 0>
		<cfset genel_izin_toplam = 0>	
		<!--- Var olan Esnek çalışma cfc'sinden Çalışan Master Pozisyonundaki Branch_id çekilmiştir --->
        <cfset get_emp_branch_department_cmp = createObject("component","V16.myhome.cfc.flexible_worktime") />
        <cfset get_employee  = get_emp_branch_department_cmp.GET_EMLOYEE_BRANCH_DEPARTMENT_FROM_IS_MASTER(employee_id : arguments.employee_id)><!---Çalışanın is master branch ve departmanı --->
        <cfif get_employee.recordcount><!---Ücret kartında departman ve şube varsa --->
            <cfset emp_branch_id = get_employee.branch_id><!--- Ücret kartında bulunan şube --->
			<cfset emp_company_id = get_employee.company_id>
        <cfelse>   
            <cfset emp_in_out_branch = GET_IN_OUT_BRANCH(employee_id : arguments.employee_id)><!---Ücret kartındakine bakıyor--->
            <cfif emp_in_out_branch.recordcount>
                <cfset emp_branch_id = emp_in_out_branch.branch_id>
				<cfset emp_company_id = emp_in_out_branch.company_id>
            <cfelse>
                Çalışan Bilgilerini Düzenleyin !!
                <cfabort>
            </cfif>
        </cfif>
		<cfif isdefined("arguments.branch_id")>
			<cfset emp_branch_id = arguments.branch_id> 
		</cfif>
		
		<cfquery name="get_emp_info" datasource="#dsn#">
			SELECT
				E.EMPLOYEE_ID,
				E.EXT_OFFTIME_MINUTES,
				E.EXT_OFFTIME_DATE,
				(SELECT TOP 1 PUANTAJ_GROUP_IDS FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ORDER BY START_DATE DESC) AS PUANTAJ_GROUP_IDS
			FROM
				EMPLOYEES E
			WHERE
				E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.employee_id#">
		</cfquery>
		
		<cfset get_work_time = get_work_info_func(emp_company_id)>
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
				<cfelseif PROPERTY_NAME eq 'finish_am_hour_info'>
					<cfset finish_am_hour = PROPERTY_VALUE>
				<cfelseif PROPERTY_NAME eq 'finish_am_min_info'>
					<cfset finish_am_min = PROPERTY_VALUE>
				<cfelseif PROPERTY_NAME eq 'start_pm_hour_info'>
					<cfset start_pm_hour = PROPERTY_VALUE>
				<cfelseif PROPERTY_NAME eq 'start_pm_min_info'>
					<cfset start_pm_min = PROPERTY_VALUE>
				<cfelseif PROPERTY_NAME eq 'x_min_control'>
					<cfset x_min_control = PROPERTY_VALUE>
				</cfif>
			</cfloop>
		<cfelse>
			<cfset start_hour = '00'>
			<cfset start_min = '00'>
			<cfset finish_hour = '00'>
			<cfset finish_min = '00'>
			<cfset finish_am_hour = '00'>
			<cfset finish_am_min = '00'>
			<cfset start_pm_hour = '00'>
			<cfset start_pm_min = '00'>
			<cfset x_min_control = 0>
		</cfif>
		<cfif not(isdefined("finish_am_min") or isdefined("finish_am_hour") or isdefined("start_pm_hour") or isdefined("start_pm_min"))>
			<cfset finish_am_min = '00'>
			<cfset finish_am_hour = '00'>
			<cfset start_pm_hour = '00'>
			<cfset start_pm_min = '00'>
		</cfif>
		<cfif not isdefined("x_min_control")>
			<cfset x_min_control = 0>
		</cfif>
		<cfquery name="GET_GENERAL_OFFTIMES" datasource="#dsn#">
			SELECT START_DATE,FINISH_DATE,IS_HALFOFFTIME FROM SETUP_GENERAL_OFFTIMES
		</cfquery>
		<cfset offday_list_ = ''>
		<cfset halfofftime_list = ''><!--- yarım gunluk izin kayıtları--->
        <cfset halfofftime_list2 = ''>
		<cfset halfofftime_list3 = ''> 
		<cfloop query="GET_GENERAL_OFFTIMES">
			<cfscript>
				offday_gun = datediff('d',GET_GENERAL_OFFTIMES.start_date,GET_GENERAL_OFFTIMES.finish_date)+1;
				offday_startdate = dateadd("h", session.ep.time_zone, GET_GENERAL_OFFTIMES.start_date); 
				offday_finishdate = dateadd("h", session.ep.time_zone, GET_GENERAL_OFFTIMES.finish_date);
				for (mck=0; mck lt offday_gun; mck=mck+1)
				{
					temp_izin_gunu = dateadd("d",mck,offday_startdate);
					daycode = '#dateformat(temp_izin_gunu,"dd/mm/yyyy")#';
					if(not listfindnocase(offday_list_,'#daycode#'))
					offday_list_ = listappend(offday_list_,'#daycode#');
					if(GET_GENERAL_OFFTIMES.is_halfofftime is 1 and dayofweek(temp_izin_gunu) neq 1) //pazar haricindeki yarım günlük izin günleri sayılsın
					{
						halfofftime_list = listappend(halfofftime_list,'#daycode#');
					}
				}
				
			</cfscript>
		</cfloop>
		
		<cfset get_hours = GET_HOURS_FNC(emp_company_id)>
		<cfif not len(get_hours.start_hour)>
            <cf_get_lang dictionary_id = "60603.Şirket İçin SGK İşyeri Çalışma Saati Tanımlarınız Eksik!">
            <cfabort>
        </cfif>
		<cfscript>
			baslangic_saat_dk = timeformat('#get_hours.start_hour#:#get_hours.start_min#','HH:mm');// mesai başlangıç 
			bitis_saat_dk = timeformat('#get_hours.end_hour#:#get_hours.end_min#','HH:mm');// mesai bitiş 
			sabah_bitis = timeformat('#finish_am_hour#:#finish_am_min#','HH:mm');// sabah mesaisi bitiş 
			oglen_baslangic = timeformat('#start_pm_hour#:#start_pm_min#','HH:mm');// Öğle mesaisi Başlangıç 
			mesai_saati_dk = datediff("n",baslangic_saat_dk,bitis_saat_dk);// Günlük mesai dk 
			ogle_arasi_dk = datediff("n",sabah_bitis,oglen_baslangic);// öğle arası dk 
			gunluk_calisma_dk = mesai_saati_dk - ogle_arasi_dk;//günlük çalışma dk sı
		</cfscript>
		
		<cfif len(get_hours.recordcount) and len(get_hours.weekly_offday)>
			<cfset this_week_rest_day_ = get_hours.weekly_offday>
		<cfelse>
			<cfset this_week_rest_day_ = 1>
		</cfif>
		
		
        <!--- Çalışanın Bordro akış parametresindeki FM Çarpanları ---->
        <cfset multiplier_values = GET_SETUP_PARAMETER(
                                start_:parameter_last_month_1,
                                finish_:parameter_last_month_30,
                                branch_id:emp_branch_id
                            )>
        <cfif multiplier_values.recordcount>
            <cfset night_multiplier = multiplier_values.night_multiplier><!---gece çalışması--->
            <cfset official_multiplier = multiplier_values.official_multiplier><!--- Resmi tatil --->
            <cfset weekend_multiplier = multiplier_values.weekend_multiplier><!--- Hafta sonu --->
			<cfset standart_multiplier = multiplier_values.EX_TIME_PERCENT_HIGH / 100><!--- normal gün --->
		    <cfset weekend_day_multiplier=multiplier_values.WEEKEND_DAY_MULTIPLIER> <!---Haftalı Tatil Gün--->
			<cfset akdi_day_multiplier=multiplier_values.AKDI_DAY_MULTIPLIER> <!---Akdi Day Tatil Gün--->
			<cfset official_day_multiplier=multiplier_values.OFFICIAL_DAY_MULTIPLIER><!---Resmi Tatil Gün --->
			<cfset arafe_day_multiplier=multiplier_values.ARAFE_DAY_MULTIPLIER><!---Arafe Günü Tatil Mesaisi--->
			<cfset dini_day_multiplier=multiplier_values.DINI_DAY_MULTIPLIER><!---Dini Bayram Tatili Gün--->
        <cfelse>
            Bordro Akış Parametresi Tanımlayın !!
            <cfabort>
        </cfif>
        <!---Çalışanın Fazla Mesaileri --->
        <cfset get_ext_worktimes = GET_EMPLOYEE_EXT_WORKTIMES(employee_id : arguments.employee_id)>
		<cfif get_ext_worktimes.recordcount>
            <cfoutput query="get_ext_worktimes">
                <cfscript>
                    if(day_type eq 0)
                        multiplier = standart_multiplier;
                    else if(day_type eq 1)
                        multiplier = weekend_multiplier;
                    else if(day_type eq 2)
                        multiplier = official_multiplier;
                    else if(day_type eq 3)
                        multiplier = night_multiplier;
					else if(day_type eq -8)
                        multiplier = weekend_day_multiplier;
					else if(day_type eq -9)
                        multiplier = akdi_day_multiplier;
					else if(day_type eq -10)
                        multiplier = official_day_multiplier;
					else if(day_type eq -11)
                        multiplier = arafe_day_multiplier;
					else if(day_type eq -12)
                        multiplier = dini_day_multiplier;
                    start_hour_mesai_ = timeformat(work_start_time,'HH:mm');
                    finish_hour_mesai_ = timeformat(work_end_time,'HH:mm');
                    work_minute = datediff("n",start_hour_mesai_,finish_hour_mesai_);
                    multiplier_min = work_minute * multiplier;
                    total_minute = total_minute + multiplier_min;
                </cfscript>
            </cfoutput>
        </cfif>
		<cfif len(get_emp_info.EXT_OFFTIME_MINUTES) and len(get_emp_info.EXT_OFFTIME_DATE)>
			<cfset total_minute = total_minute + get_emp_info.EXT_OFFTIME_MINUTES>
		</cfif>
		
		<cfquery name="get_puantaj_group_id" dbtype="query">
			SELECT PUANTAJ_GROUP_IDS FROM get_emp_info WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
		</cfquery>
				
		<cfset get_offtimes = GET_EMPLOYEE_OFFTIMES(employee_id:arguments.employee_id)>
		<cfset used_days = 0>
		<cfset used_mins = 0>
		<cfset waiting_used_mins = 0>
		<cfset waiting_used_days = 0>
		<cfset active_year_used_days = 0>
		<cfset active_year_used_mins = 0>
		<cfset total_day_calc = 0>
		<cfset total_dk = 0>
		<cfset genel_izin_toplam = 0>
		<cfset genel_dk_toplam = 0>
		<cfset kisi_izin_toplam = 0>
		<cfset kisi_izin_sayilmayan = 0>
		<cfset izin_sayilmayan = 0>
		<cfif get_offtimes.recordcount>
			<cfoutput query="get_offtimes">
				<cfset get_shift = get_employee_shift.get_emp_shift(employee_id : employee_id, start_date : startdate, finish_date : finishdate)>

				<cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
					SELECT LIMIT_ID,SATURDAY_ON,DAY_CONTROL,DAY_CONTROL_AFTERNOON,SUNDAY_ON,PUBLIC_HOLIDAY_ON FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> AND
					<cfif len(get_puantaj_group_id.PUANTAJ_GROUP_IDS)>
					 (
						<cfloop from="1" to="#listlen(get_puantaj_group_id.puantaj_group_ids)#" index="i">
							','+PUANTAJ_GROUP_IDS+',' LIKE '%,#listgetat(get_puantaj_group_id.PUANTAJ_GROUP_IDS,i,',')#,%' <cfif listlen(get_puantaj_group_id.PUANTAJ_GROUP_IDS) neq i>OR</cfif> 
						</cfloop>
					)
					<cfelse>
						PUANTAJ_GROUP_IDS IS NULL
					</cfif>
				</cfquery>
				<cfif get_offtime_cat.recordcount and len(get_offtime_cat.saturday_on)>
					<cfset saturday_on = get_offtime_cat.saturday_on>
				<cfelse>
					<cfset saturday_on = 1>
				</cfif>
				<cfif get_offtime_cat.recordcount and len(get_offtime_cat.day_control)>
					<cfset day_control_ = get_offtime_cat.day_control>
				<cfelse>
					<cfset day_control_ = 0>
				</cfif>
				<cfif  get_offtime_cat.recordcount and len(get_offtime_cat.day_control)>
					<cfset day_control_afternoon = get_offtime_cat.day_control_afternoon>
				<cfelse>
					<cfset day_control_afternoon = 0>
				</cfif>
				<cfif  get_offtime_cat.recordcount and len(get_offtime_cat.day_control)>
					<cfset day_control = get_offtime_cat.day_control>
				<cfelse>
					<cfset day_control = 0>
				</cfif>
				<cfif get_offtime_cat.recordcount and len(get_offtime_cat.sunday_on)>
					<cfset sunday_on = get_offtime_cat.sunday_on>
				<cfelse>
					<cfset sunday_on = 0>
				</cfif>
				<cfif get_offtime_cat.recordcount and len(get_offtime_cat.public_holiday_on)>
					<cfset public_holiday_on = get_offtime_cat.public_holiday_on>
				<cfelse>
					<cfset public_holiday_on = 0>
				</cfif>
				<cfset dateformat_style = "dd/mm/yyyy">
				<cfset timeformat_style = "HH:mm">
				<cfinclude  template="../../hr/ehesap/display/offtime_calc.cfm">
				<cfscript>
					if(valid eq 1)
					{
						used_days = used_days + total_day_calc;
						used_mins = used_mins + total_dk;
						
						if(year(get_offtimes.finishdate) eq year(now()))
						{
							active_year_used_days = active_year_used_days + total_day_calc;
							active_year_used_mins = active_year_used_mins + used_mins;
						}
					}
					else
					{
						waiting_used_days = waiting_used_days + total_day_calc;
						waiting_used_mins = waiting_used_mins + total_dk;
					}
				</cfscript>
			</cfoutput>
		</cfif>
		
		<cfquery name="get_fm_days" datasource="#dsn#">
			SELECT
				#total_minute# AS total_minute,
				#gunluk_calisma_dk# AS daily_minute,
				#(total_minute/gunluk_calisma_dk)# AS fm_day,
				#used_days# AS used_days,
				#used_mins# AS used_mins,
				#active_year_used_days# AS active_year_used_days,
				#active_year_used_mins# AS active_year_used_mins,
				#(total_minute/gunluk_calisma_dk) - used_days# AS unused_days,
				#total_minute - used_mins# AS unused_mins,
				#waiting_used_mins# AS waiting_used_mins,
				#(waiting_used_mins/gunluk_calisma_dk)# AS waiting_used_days
		</cfquery>
		<cfreturn get_fm_days>
    </cffunction>
    <!--- Çalışanın Fazla Mesai Query'sidir. --->
    <cffunction name="GET_EMPLOYEE_EXT_WORKTIMES" access="remote" returntype="any">
        <cfargument name="employee_id" type="numeric" required="true">
        <!----<cfargument name="period_date" type="date" required="true">--->
        <cfquery name="get_ext_worktime" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                EMPLOYEES_EXT_WORKTIMES
            WHERE
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                AND VALID =  <cfqueryparam cfsqltype="cf_sql_integer" value="1"><!---Onaylı--->
                AND WORKTIME_WAGE_STATU = <cfqueryparam cfsqltype="cf_sql_integer" value="1"><!---Serbest zaman --->
        </cfquery>
        <cfreturn get_ext_worktime>
    </cffunction>
	<cffunction name="GET_EMPLOYEE_OFFTIMES" access="remote" returntype="any">
        <cfargument name="employee_id" type="numeric" required="true">
        <cfquery name="get_offtimes" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                OFFTIME O,
				SETUP_OFFTIME SO
            WHERE
                SO.IS_FREE_TIME = 1 AND
				O.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
				AND
				(
					(
					O.SUB_OFFTIMECAT_ID = 0 AND
					O.OFFTIMECAT_ID = SO.OFFTIMECAT_ID
					)
					OR
					O.SUB_OFFTIMECAT_ID = SO.OFFTIMECAT_ID
				)
				AND (O.VALID = 1 OR O.VALID IS NULL)
        </cfquery>
        <cfreturn get_offtimes>
    </cffunction>
    <!--- Bordro Akış Parametreleri FM Katsayıları --->
    <cffunction name="GET_PAYROLL_PARAMETER" access="remote"  returntype="any">
        <cfargument name="employee_id" type="numeric" required="true">
        <cfquery name="GET_PAYROLL_PARAMETER" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                EMPLOYEES_EXT_WORKTIMES
            WHERE
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                AND VALID =  <cfqueryparam cfsqltype="cf_sql_integer" value="1"><!---Onaylı--->
                AND WORKTIME_WAGE_STATU = <cfqueryparam cfsqltype="cf_sql_integer" value="1"><!---Serbest zaman --->
        </cfquery>
        <cfreturn GET_EMPLOYEE_OFFTIME>
    </cffunction>
    <!--- Bordro Akış parametresindeki FM Çarpanları --->
    <cffunction name="GET_SETUP_PARAMETER" access="remote" returntype="query">
		<cfargument name="start_" type="date" default="">
		<cfargument name="finish_" type="date" default="">
		<cfargument name="branch_id" type="string">
		<cfquery name="GET_SETUP_PARAMETER" datasource="#dsn#">
			SELECT
				OFFICIAL_MULTIPLIER,
				NIGHT_MULTIPLIER,
				WEEKEND_MULTIPLIER,
				WEEKEND_DAY_MULTIPLIER,
				AKDI_DAY_MULTIPLIER,
				OFFICIAL_DAY_MULTIPLIER,
				ARAFE_DAY_MULTIPLIER,
				DINI_DAY_MULTIPLIER,
				EX_TIME_PERCENT_HIGH
			FROM
				SETUP_PROGRAM_PARAMETERS
			WHERE
				PARAMETER_ID IS NOT NULL
				<cfif isdefined('arguments.start_') and len(arguments.start_)>
					AND STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_#">  
				</cfif>
				<cfif isdefined('arguments.finish_') and len(arguments.finish_)>
					AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_#"> 			
                </cfif>
                <cfif isdefined('arguments.branch_id') and len(arguments.branch_id)>
					AND (','+BRANCH_IDS+',' LIKE '%,#arguments.branch_id#,%')
                </cfif>
			ORDER BY
				PARAMETER_ID DESC
		</cfquery>
		<cfreturn GET_SETUP_PARAMETER>
	</cffunction>
    <cffunction name="GET_IN_OUT_BRANCH" access="remote"  returntype="any"><!--- Ücret kartındaki branch --->
        <cfargument name="employee_id" default=""> 
        <cfquery name="GET_IN_OUT_BRANCH" datasource="#dsn#">
            SELECT
                B.BRANCH_ID,
				B.COMPANY_ID
            FROM
                EMPLOYEES_IN_OUT EIO,
				BRANCH B
            WHERE
                EIO.BRANCH_ID = B.BRANCH_ID AND
				EIO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
        </cfquery>
        <cfreturn GET_IN_OUT_BRANCH>
    </cffunction>
	<cffunction name="GET_HOURS_FNC" access="remote" returntype="any"><!--- sirket calisma saatleri --->
        <cfargument name="company_id" default=""> 
        <cfquery name="get_hours" datasource="#dsn#">
			SELECT		
				OUR_COMPANY_HOURS.*
			FROM
				OUR_COMPANY_HOURS
			WHERE
				OUR_COMPANY_HOURS.DAILY_WORK_HOURS > 0 AND
				OUR_COMPANY_HOURS.SSK_MONTHLY_WORK_HOURS > 0 AND
				OUR_COMPANY_HOURS.SSK_WORK_HOURS > 0 AND
				OUR_COMPANY_HOURS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"><!---Çalışan kartındaki son şirkete göre---->
		</cfquery>
        <cfreturn get_hours>
    </cffunction>
	<cffunction name="get_work_info_func" access="remote"  returntype="any"><!--- sirket calisma saatleri --->
		<cfargument name="company_id" default=""> 
        <cfquery name="get_work_time" datasource="#dsn#">
			SELECT 
				PROPERTY_VALUE,
				PROPERTY_NAME
			FROM
				FUSEACTION_PROPERTY
			WHERE
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND
				FUSEACTION_NAME = 'ehesap.form_add_offtime_popup' AND
				(PROPERTY_NAME = 'start_hour_info' OR
				PROPERTY_NAME = 'start_min_info' OR
				PROPERTY_NAME = 'finish_hour_info' OR
				PROPERTY_NAME = 'finish_min_info' OR
				PROPERTY_NAME = 'finish_am_hour_info' OR
				PROPERTY_NAME = 'finish_am_min_info' OR
				PROPERTY_NAME = 'start_pm_hour_info' OR
				PROPERTY_NAME = 'start_pm_min_info' OR
				PROPERTY_NAME = 'x_min_control'
				)	
		</cfquery>
        <cfreturn get_work_time>
    </cffunction>	
</cfcomponent>