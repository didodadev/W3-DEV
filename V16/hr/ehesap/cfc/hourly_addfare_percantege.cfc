<!---
    File : V16\hr\ehesap\cfc\hourly_addfare_percantege.cfc
    Author : Workcube-Esma Uysal <esmauysal@workcube.com>
    Date : 02.10.2019
    Description : Çalışana bağlı ek ödenek fonksiyonlarını içerir.
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cfset fusebox.dynamic_hierarchy = application.systemParam.systemParam().fusebox.dynamic_hierarchy>
    <cfset fusebox.process_tree_control = application.systemParam.systemParam().fusebox.process_tree_control>
    <!--- Genel Tatil zamanları --->
    <cffunction name="GET_CALENDER_OFFTIMES" access="public" returntype="query">
        <cfquery name="GET_CALENDER_OFFTIMES" datasource="#DSN#">
            SELECT
                START_DATE,
                FINISH_DATE,
                OFFTIME_NAME
            FROM 
                SETUP_GENERAL_OFFTIMES
            ORDER BY
                START_DATE
        </cfquery>
        <cfreturn GET_CALENDER_OFFTIMES>
    </cffunction>
    
    <cffunction name="get_stage_name" access="public" returntype="query">
        <cfargument name="process_id" default="">
        <cfquery name="get_stage_name" datasource="#dsn#">
             SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_id#">
        </cfquery>
        <cfreturn get_stage_name>
    </cffunction>

    <!--- Genel BELGE NUMARASI --->
    <cffunction name="get_general_paper" access="public" returntype="query">
        <cfparam name="paper_id" default="">
        <cfquery name="get_general_paper" datasource="#DSN#">
            SELECT
                *
            FROM 
                GENERAL_PAPER
            WHERE
                GENERAL_PAPER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paper_id#">
        </cfquery>
        <cfreturn get_general_paper>
    </cffunction>

    <!--- Genel Liste--->
    <cffunction name="get_salaryparam_pay" access="public" returntype="query">
        <cfparam name="paper_no" default="">
        <cfquery name="get_salaryparam_pay" datasource="#DSN#">
            SELECT
                DISTINCT
                SP.EMPLOYEE_ID,
                TOTAL_WORK_HOUR,
                SP.AMOUNT_PAY,
                SP.MONEY,
                BRANCH_NAME,
                D.DEPARTMENT_HEAD,
                EI.TC_IDENTY_NO,
                START_SAL_MON,
                TERM,
                SP.COMMENT_PAY
            FROM 
                EMPLOYEE_DAILY_IN_OUT EDIO 
                INNER JOIN SALARYPARAM_PAY SP ON  EDIO.EMPLOYEE_ID = SP.EMPLOYEE_ID AND SP.PAPER_NO = EDIO.PAPER_NO AND SP.COMMENT_PAY_ID = EDIO.ALLOWANCE_ID 
                AND EDIO.TOTAL_WORK_HOUR =  SP.TOTAL_HOUR
                INNER JOIN EMPLOYEES_IDENTY EI ON  EI.EMPLOYEE_ID = EDIO.EMPLOYEE_ID
                INNER JOIN BRANCH B ON B.BRANCH_ID = EDIO.BRANCH_ID
                INNER JOIN EMPLOYEES_IN_OUT EIO ON EIO.IN_OUT_ID = EDIO.IN_OUT_ID
                INNER JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EIO.DEPARTMENT_ID
            WHERE
                EDIO.PAPER_NO =  <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.paper_no#">
        </cfquery>
        <cfreturn get_salaryparam_pay>
    </cffunction>

    <!--- Şirket Çalışma Saatleri --->
    <cffunction name="get_offday_info" access="public" returntype="query">
        <cfparam name="company_id" default="">
        <cfquery name="get_offday_info" datasource="#dsn#">
            SELECT WEEKLY_OFFDAY FROM OUR_COMPANY_HOURS WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>
        <cfreturn get_offday_info>
    </cffunction>

    <!--- Ödenek bilgileri --->
    <cffunction name="get_allowance" access="public" returntype="query">
        <cfparam name="statue_type" default="">
        <cfparam name="ssk_statue" default="">
        <cfparam name="odkes_id" default="">
        <cfquery name="get_allowance" datasource="#dsn#">
            SELECT 
                *
            FROM 
                SETUP_PAYMENT_INTERRUPTION 
            WHERE 
                <cfif isdefined("arguments.statue_type") and len(arguments.statue_type)>
                    SSK_STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ssk_statue#"> AND
                    STATUE_TYPE =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.statue_type#">
                </cfif>
                <cfif isdefined("arguments.odkes_id") and len(arguments.odkes_id)>
                    ODKES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.odkes_id#">
                </cfif>
        </cfquery>
        <cfreturn get_allowance>
    </cffunction>

    <!---  PDKS --->
    <cffunction name="get_all_ins" access="public" returntype="query">
        <cfparam name="last_month_30" default="">
        <cfparam name="last_month_1" default="">
        <cfparam name="ssk_statue" default = "">
        <cfparam name="statue_type" default = "">
        <cfquery name="get_all_ins" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                EMPLOYEE_DAILY_IN_OUT 
            WHERE 
                START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.last_month_1#"> 
                AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.last_month_30#">
                AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value='#arguments.SSK_OFFICE#'> 
                AND FROM_HOURLY_ADDFARE = <cfqueryparam cfsqltype="cf_sql_integer" value='1'> 
                AND SSK_STATUE =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ssk_statue#">
                AND STATUE_TYPE =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.statue_type#">
        </cfquery>
        <cfreturn get_all_ins>
    </cffunction>

    <!--- ÇAlışanlar --->
    <cffunction name="GET_SSK_EMPLOYEES" access="public" returntype="query">
        <cfparam name="SSK_OFFICE" default = "">
        <cfparam name="department_id" default = "0">
        <cfparam name="sal_mon" default = "">
        <cfparam name="emp_code_list" default = "">
        <cfparam name="ssk_statue" default = "">
        <cfparam name="statue_type" default = "">
        <cfparam name="in_out_id" default = "">
        <cfquery name="GET_SSK_EMPLOYEES" datasource="#DSN#">
            SELECT
                BRANCH.BRANCH_ID,
                BRANCH.COMPANY_ID,
                EMPLOYEES_IN_OUT.VALID,
                EMPLOYEES.EMPLOYEE_NAME,
                EMPLOYEES.EMPLOYEE_SURNAME,
                EMPLOYEES_IN_OUT.IN_OUT_ID,
                EMPLOYEES_IN_OUT.START_DATE,
                EMPLOYEES_IN_OUT.FINISH_DATE,
                EMPLOYEES_IN_OUT.EMPLOYEE_ID,
                EMPLOYEES_IDENTY.TC_IDENTY_NO,
                EMPLOYEES_IN_OUT.POSITION_CODE,
                EMPLOYEES_IN_OUT.IS_PUANTAJ_OFF,
                EMPLOYEES_IN_OUT.SOCIALSECURITY_NO,
                SETUP_PAYMENT_INTERRUPTION.PAY_ID,
                SETUP_PAYMENT_INTERRUPTION.ODKES_ID,
                EMPLOYEES_IN_OUT.MINIMUM_COURSE_HOURS,
                SETUP_PAYMENT_INTERRUPTION.AMOUNT_PAY,
                #dsn#.Get_Dynamic_Language(SETUP_PAYMENT_INTERRUPTION.PAY_ID,'#session.ep.language#','SETUP_PAYMENT_INTERRUPTION','COMMENT_PAY',NULL,NULL,SETUP_PAYMENT_INTERRUPTION.COMMENT_PAY) AS COMMENT_PAY
            FROM 
                BRANCH,
                EMPLOYEES,
                EMPLOYEES_IN_OUT,
                EMPLOYEES_IDENTY,
                SETUP_PAYMENT_INTERRUPTION
            WHERE
                BRANCH.BRANCH_STATUS = 1 AND
                EMPLOYEES.EMPLOYEE_STATUS = 1 AND
                BRANCH.BRANCH_ID = '#arguments.SSK_OFFICE#' AND
                EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID AND
                EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
            <cfif len(arguments.department_id) and arguments.department_id neq 0>
                EMPLOYEES_IN_OUT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">  AND
            </cfif>
                EMPLOYEES_IN_OUT.USE_SSK = #arguments.ssk_statue# AND
                SSK_STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ssk_statue#"> 
                <cfif isdefined("arguments.statue_type") and len("arguments.statue_type") and arguments.ssk_statue eq 2>AND STATUE_TYPE =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.statue_type#"></cfif>
            <cfif not session.ep.ehesap>
                AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# AND EMPLOYEE_POSITION_BRANCHES.DEPARTMENT_ID IS NULL)
            </cfif>
                AND
                EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdate(session.ep.period_year,arguments.sal_mon,daysinmonth(createdate(session.ep.period_year,arguments.sal_mon,1)))#">
                AND
                (
                    (EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdate(session.ep.period_year,arguments.sal_mon,1)#">)
                    OR
                    EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
                )
                AND BRANCH.BRANCH_ID = EMPLOYEES_IN_OUT.BRANCH_ID
                <cfif fusebox.dynamic_hierarchy>
                        <cfloop list="#arguments.emp_code_list#" delimiters="+" index="code_i">
                            <cfif database_type is "MSSQL">
                                AND 
                                ('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
                            <cfelseif database_type is "DB2">
                                AND 
                                ('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
                            </cfif>
                        </cfloop>
                <cfelse>
                        <cfloop list="#arguments.emp_code_list#" delimiters="+" index="code_i">
                                AND
                                (
                                    ('.' + EMPLOYEES.HIERARCHY + '.') LIKE '%.#code_i#.%' OR
                                    ('.' + EMPLOYEES.OZEL_KOD + '.') LIKE '%.#code_i#.%' OR
                                    ('.' + EMPLOYEES.OZEL_KOD2 + '.') LIKE '%.#code_i#.%'
                                )
                        </cfloop>
                </cfif>
            ORDER BY
                EMPLOYEES.EMPLOYEE_NAME,
                EMPLOYEES.EMPLOYEE_SURNAME,
                EMPLOYEES_IN_OUT.IN_OUT_ID ASC
        </cfquery>
        <cfreturn GET_SSK_EMPLOYEES>
    </cffunction>

    <!--- Çalışanın İzinleri --->
    <cffunction name="get_all_izin" access="public" returntype="query">
        <cfparam name="last_month_30" default="">
        <cfparam name="last_month_1" default="">
        <cfparam name="employee_id" default="">
        <cfparam name="branch_id" default="">
        <cfquery name="get_all_izin" datasource="#dsn#">
            SELECT 
                OFFTIME.STARTDATE,
                OFFTIME.FINISHDATE,
                OFFTIME.EMPLOYEE_ID,
                CASE
                    WHEN OFFTIME.IN_OUT_ID IS NOT NULL THEN OFFTIME.IN_OUT_ID
                    WHEN OFFTIME.IN_OUT_ID IS NULL THEN (
                        SELECT 
                            TOP 1 IN_OUT_ID 
                        FROM 
                            EMPLOYEES_IN_OUT EIO 
                        WHERE 
                            EIO.EMPLOYEE_ID = OFFTIME.EMPLOYEE_ID 
                            AND EIO.BRANCH_ID = #arguments.BRANCH_ID# 
                            AND EIO.START_DATE <= #DATEADD('h',-session.ep.time_zone,arguments.last_month_30)# 
                            AND (EIO.FINISH_DATE IS NULL OR EIO.FINISH_DATE > #DATEADD('h',-session.ep.time_zone,arguments.last_month_1)#)
                    )
                END
                    AS THIS_IN_OUT,
                OFFTIME.STARTDATE,
                SETUP_OFFTIME.IS_PAID,
                SETUP_OFFTIME.IS_YEARLY,
                SETUP_OFFTIME.EBILDIRGE_TYPE_ID,
                SETUP_OFFTIME.SIRKET_GUN
            FROM 
                OFFTIME
                INNER JOIN SETUP_OFFTIME ON OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
            WHERE 
                OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.last_month_30#"> AND
                OFFTIME.FINISHDATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.last_month_1#"> AND
                OFFTIME.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#" list = "yes">)
        </cfquery>

        <cfreturn get_all_izin>
    </cffunction>


    <cffunction name="add_hourly_addfare_percantege" access="public" returntype="any">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfset allowance_expense_cmp = createObject("component","V16.myhome.cfc.allowance_expense") /><!--- Ek Ödenek --->
            <cfquery name="get_comp" datasource="#dsn#">
                SELECT COMPANY_ID FROM BRANCH WHERE  BRANCH_ID = #arguments.branch_id#
            </cfquery>
            <CFSET arguments.our_company_id = get_comp.COMPANY_ID>
            <cfinclude template="../query/get_hours.cfm">
            <cfset baslangic_saat_ = 7>
            <cfset baslangic_dakika_ = 0>
            <cfif listlen(get_hours.SSK_WORK_HOURS,'.') eq 2>
                <cfset bitis_saat_ = listgetat(get_hours.SSK_WORK_HOURS,1,'.')>
                <cfset bitis_dakika_ = listgetat(get_hours.SSK_WORK_HOURS,2,'.')>
            <cfelse>
                <cfset bitis_saat_ = get_hours.SSK_WORK_HOURS>
                <cfset bitis_dakika_ = 0>
            </cfif>
            <cfset bitis_saat_ = bitis_saat_ + 7>
            <cfquery name="del_" datasource="#dsn#">
                DELETE FROM EMPLOYEE_DAILY_IN_OUT WHERE BRANCH_ID = #arguments.branch_id# AND SPECIAL_CODE = '#arguments.special_code#'
            </cfquery>
            <cfquery name="del_allowance" datasource="#dsn#">
                DELETE FROM SALARYPARAM_PAY WHERE SPECIAL_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.special_code#">
            </cfquery>
            <cfset action_list_id = "">
            <cfloop from="1" to="#arguments.kayit_sayisi#" index="kayit_no">
                <cfset totalValues = structNew()>
                <cfset in_out_id_ = evaluate("arguments.in_out_id_#kayit_no#")>
                <cfset action_list_id = listAppend(action_list_id, in_out_id_)>
                <cfset employee_id = evaluate("arguments.employee_id_#kayit_no#")>
                <cfset payment_hour = evaluate("arguments.total_work_hour_#in_out_id_#_#kayit_no#") - evaluate("arguments.min_work_hour_#in_out_id_#_#kayit_no#")>
                <cfloop from="1" to="#arguments.gun_sayisi#" index="gun_">
                    <cfquery name="add_emp_daily_in_out" datasource="#dsn#">
                        INSERT INTO
                            EMPLOYEE_DAILY_IN_OUT
                            (
                                EMPLOYEE_ID,
                                IN_OUT_ID,
                                BRANCH_ID,
                                START_DATE,
                                FINISH_DATE,
                                SPECIAL_CODE,
                                DAILY_WORKING_HOUR,
                                TOTAL_WORK_HOUR,
                                ALLOWANCE_ID,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP,
                                FROM_HOURLY_ADDFARE,
                                SSK_STATUE,
                                STATUE_TYPE,
                                PAPER_NO
                            )
                        VALUES
                            (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#in_out_id_#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(createdatetime(arguments.sal_year,arguments.sal_mon,gun_,baslangic_saat_,baslangic_dakika_,0))#">,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(createdatetime(arguments.sal_year,arguments.sal_mon,gun_,bitis_saat_,bitis_dakika_,0))#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.special_code#">,
                                <cfif len(evaluate("arguments.daily_working_hour_#in_out_id_#_#gun_#_#kayit_no#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.daily_working_hour_#in_out_id_#_#gun_#_#kayit_no#")#"><cfelse>0</cfif>,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.total_work_hour_#in_out_id_#_#kayit_no#")#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.allowance_#in_out_id_#_#kayit_no#")#">,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value='#cgi.remote_addr#'>,
                                <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                                <cfqueryparam CFSQLType = "cf_sql_integer" value = "#evaluate("arguments.ssk_statue")#">,
                                <cfif isdefined("arguments.statue_type") and len("arguments.statue_type") and arguments.ssk_statue eq 2><cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.statue_type#"><cfelse>0</cfif>,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value='#arguments.general_paper_no#'>
                            )
                    </cfquery>
                </cfloop>
                <!--- Add Allowance start --->
                <cfif payment_hour gt 0>
                    <cfset get_allowance_property = this.get_allowance(odkes_id: evaluate("arguments.allowance_#in_out_id_#_#kayit_no#"))>
                    <cfquery name="get_add_position" datasource="#dsn#">
                        SELECT ADDITIONAL_COURSE_POSITION FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#in_out_id_#">
                    </cfquery>
                    <cfset get_position_val = this.GET_ADDITIONAL_COURSE_TABLE(
                                                start_date: createodbcdatetime(createdatetime(arguments.sal_year,arguments.sal_mon,1,baslangic_saat_,baslangic_dakika_,0)),
                                                finish_date: createodbcdatetime(createdatetime(arguments.sal_year,arguments.sal_mon,1,bitis_saat_,bitis_dakika_,0))
                                            )>
                    <cfif get_allowance_property.method_pay eq 6><!--- N.Ö. Gündüz --->
                        <cfset value_day = evaluate("get_position_val.DAYTIME_EDUCATION_#get_add_position.ADDITIONAL_COURSE_POSITION#")>
                    <cfelseif get_allowance_property.method_pay eq 7><!--- N.Ö. Gece ve Tatillerde --->
                        <cfset value_day = evaluate("get_position_val.PUBLIC_HOLIDAY_#get_add_position.ADDITIONAL_COURSE_POSITION#")>
                    <cfelseif get_allowance_property.method_pay eq 8><!--- İ.Ö. Gece --->
                        <cfset value_day = evaluate("get_position_val.EVENING_EDUCATION_#get_add_position.ADDITIONAL_COURSE_POSITION#")>
                    </cfif>
                    <cfif get_allowance_property.method_pay eq 5>
                        <cfset total_val = payment_hour * get_allowance_property.AMOUNT_PAY>
                    <cfelseif get_allowance_property.method_pay eq 6 or get_allowance_property.method_pay eq 7 or get_allowance_property.method_pay eq 8>
                        <cfset total_val = payment_hour * value_day>
                    <cfelse>
                        <cfset total_val =  get_allowance_property.AMOUNT_PAY>
                    </cfif>
                    <cfset add_allowance_expense = allowance_expense_cmp.ADD_SALARYPARAM_PAY(
                        comment_pay :  get_allowance_property.comment_pay,<!--- Ödenek İsmi --->
                        comment_pay_id : get_allowance_property.odkes_id,<!---Ödenek Id --->
                        amount_pay : total_val,<!--- Ödenek (Kurum Payı) --->
                        ssk : get_allowance_property.ssk,<!--- ssk 1 : muaf, 2: muaf değil ---> 
                        tax : get_allowance_property.tax,<!--- vergi 1 : muaf, 2: muaf değil---> 
                        is_damga : get_allowance_property.is_damga,<!--- damga vergisi --->
                        is_issizlik : get_allowance_property.is_issizlik,<!--- işsizlik ---> 
                        show : get_allowance_property.show,<!--- bordroda görünsün ---> 
                        method_pay : get_allowance_property.method_pay,<!--- 1: artı, 2 : ay , 3 : gün, 4 : saat, 5: saat x ödenek tutarı---> 
                        period_pay : get_allowance_property.period_pay,<!--- 1: ayda 1, 2 : 3 ayda 1 , 3 : 6 ayda 1, 4 : yılda 1---> 
                        start_sal_mon : arguments.sal_mon,<!--- Başlangıç Ayı --->
                        end_sal_mon : arguments.sal_mon,<!--- Bitiş Ayı --->
                        employee_id : employee_id,<!--- çalışan id --->
                        term : arguments.sal_year,<!--- yıl --->
                        calc_days : get_allowance_property.calc_days,<!---tutar günü 0 : tümü, 1: gün,2 : fiili gün --->
                        is_kidem : get_allowance_property.is_kidem,<!--- kıdeme dahil 1:kıdeme ahil,0 kıdeme dahil değil ??? sorulacak--->
                        in_out_id : in_out_id_,<!--- Giriş çıkış id --->
                        from_salary : get_allowance_property.from_salary, <!--- 0 :net,1 : brüt --->
                        is_ehesap : get_allowance_property.is_ehesap,<!--- üst düzey ik yetkisi 1 : dahi, 0 :dahil değil--->
                        is_ayni_yardim : get_allowance_property.is_ayni_yardim,<!--- ayni yardım --->
                        tax_exemption_value : get_allowance_property.tax_exemption_value,<!--- Gelir Vergisi Muafiyet Tutarı --->
                        tax_exemption_rate : get_allowance_property.tax_exemption_rate,<!--- Gelir Vergisi Muafiyet Oranı--->
                        money : get_allowance_property.MONEY,<!--- Para birimi--->
                        is_income : get_allowance_property.is_income,<!--- kazançlara dahil--->
                        is_not_execution : get_allowance_property.is_not_execution,<!--- İcraya Dahil Değil --->
                        comment_type : get_allowance_property.comment_type,<!--- 1: ek ödenek, 2: kazanc --->
                        special_code : arguments.special_code,
                        total_hour : evaluate("arguments.total_work_hour_#in_out_id_#_#kayit_no#"),
                        paper_no : arguments.general_paper_no,
                        ssk_statue : arguments.ssk_statue,
                        statue_type : arguments.statue_type
                        ) />
                </cfif>
                <!--- Add Allowance end --->
            </cfloop>
            <!--- General paper start--->
            
            <cfset get_allowance_ = this.get_allowance(ssk_statue: arguments.ssk_statue, statue_type: isdefined("arguments.statue_type") ? arguments.statue_type : NULL)>
            <cfoutput query="get_allowance_">
                <cfif isdefined("arguments.allowance_expense_#odkes_id#") and len(evaluate("arguments.allowance_expense_#odkes_id#"))>
                    <cfset allowance_expense_list = {"ALLOWANCE_EXPENSE_#odkes_id#":"#evaluate('arguments.allowance_expense_#odkes_id#')#","BORDRO_TYPE":"#arguments.statue_type#","SSK_STATUE":"#arguments.ssk_statue#","BRANCH_ID":"#arguments.branch_id#","TOTAL_HOUR":"#arguments.total_hour#"}>
                    <cfset StructAppend(totalValues,allowance_expense_list,false)>
                </cfif>
            </cfoutput>
            <cfset attributes.fuseaction = 'index.cfm?fuseaction=ehesap.hourly_addfare_percantege'>
            <cf_workcube_general_process
                mode = "query"
                general_paper_parent_id = "#(isDefined("arguments.general_paper_parent_id") and len(arguments.general_paper_parent_id)) ? arguments.general_paper_parent_id : 0#"
                general_paper_no = "#arguments.general_paper_no#"
                general_paper_date = "#arguments.general_paper_date#"
                action_list_id = "#action_list_id#"
                process_stage = "#arguments.process_stage#"
                general_paper_notice = "#arguments.general_paper_notice#"
                responsible_employee_id = "#(isDefined("arguments.responsible_employee_id") and len(arguments.responsible_employee_id) and isDefined("arguments.responsible_employee") and len(arguments.responsible_employee)) ? arguments.responsible_employee_id : 0#"
                responsible_employee_pos = "#(isDefined("arguments.responsible_employee_pos") and len(arguments.responsible_employee_pos) and isDefined("arguments.responsible_employee") and len(arguments.responsible_employee)) ? arguments.responsible_employee_pos : 0#"
                action_table = 'EMPLOYEE_DAILY_IN_OUT'
                action_column = 'ROW_ID'
                action_page = 'index.cfm?fuseaction=ehesap.hourly_addfare_percantege'
                total_values = '#totalValues#'
                >
                    <!--- General paper end--->
            <cfquery name="LAST_ID" datasource="#DSN#">
                SELECT MAX(ROW_ID) AS LATEST_RECORD_ID FROM EMPLOYEE_DAILY_IN_OUT
            </cfquery>
            <cf_wrk_get_history datasource="#dsn#" source_table="EMPLOYEE_DAILY_IN_OUT" target_table="EMPLOYEE_DAILY_IN_OUT_HISTORY" record_id= "#LAST_ID.LATEST_RECORD_ID#" record_name="ROW_ID">
        <!--- General paper end--->
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>
    
    <!--- Ek ders ücret gösterge --->
    <cffunction name="GET_ADDITIONAL_COURSE_TABLE" access="public" returntype="query">
        <cfparam name="start_date" default="">
        <cfparam name="finish_date" default="">
        <cfquery name="GET_ADDITIONAL_COURSE_TABLE" datasource="#DSN#">
            SELECT
                *              
            FROM
                ADDITIONAL_COURSE_TABLE
            WHERE
                (START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.start_date)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.finish_date)#">) OR
                (FINISH_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.start_date)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.finish_date)#">) OR
                (START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.start_date)#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.finish_date)#">)
        </cfquery>
        <cfreturn GET_ADDITIONAL_COURSE_TABLE>
    </cffunction>
</cfcomponent>