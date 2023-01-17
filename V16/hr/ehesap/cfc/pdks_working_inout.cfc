<!---
    File: V16\hr\ehesap\cfc\additional_course.cfc
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-11-1
    Description:  Çalışan pdks giriş çıkışlar
        
    History:
        
    To Do:
            company_id_par : len(arguments.company_id) ? arguments.company_id : '',
            consumer_id_par : len(arguments.consumer_id) ? arguments.consumer_id : '',
            employee_id_par : len(arguments.employee_id_par) ? arguments.employee_id_par : '',
            member_type : len(arguments.member_type) ? arguments.member_type : '',
            member_name : len(arguments.member_name) ? arguments.member_name : '',
            company_id : len(arguments.comp_id) ? arguments.comp_id : '',
            branch_id :  len(arguments.branch_id) ? arguments.branch_id : ''
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">

    <cfset dsn_alias = application.systemParam.systemParam().dsn>
    <cfset dsn2_alias = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3_alias = '#dsn#_#session.ep.company_id#'>

    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>
    <cfset fusebox.use_period = application.systemParam.systemParam().fusebox.use_period>
    <cfset fusebox.dynamic_hierarchy = application.systemParam.systemParam().fusebox.dynamic_hierarchy>
    <cfset fusebox.process_tree_control = application.systemParam.systemParam().fusebox.process_tree_control>
    <cfset action_id_list_cfc = ''>

    <cfset request.self = application.systemParam.systemParam().request.self />

    <!--- Filtreye göre çalışan kayıtları --->
    <cffunction name="GET_PDKS_WORKING_INOUT" access="public" returntype="any">

        <cfparam name="project_id" default="">
        <cfparam name="sal_mon" default = "">
        <cfparam name="sal_year" default = "">
        <cfparam name="in_out_id" default="">
        <cfparam name="employee_id" default = "">
        <cfparam name="employee_name" default = "">
        <cfparam name="department_id" default="">
        <cfparam name="company_id_par" default = "">
        <cfparam name="consumer_id_par" default="">
        <cfparam name="employee_id_par" default = "">
        <cfparam name="member_type" default = "">
        <cfparam name="member_name" default="">
        <cfparam name="branch_id" default = "">
        <cfparam name="company_id" default = "">

        <cfquery name="GET_PDKS_WORKING_INOUT" datasource="#dsn#">
            SELECT
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME EMP_NAME_SURNAME,
                EIO.IN_OUT_ID,
                EI.TC_IDENTY_NO,
                EP.POSITION_NAME,
                EIO.BRANCH_ID,
                E.EMPLOYEE_ID
            FROM 
                EMPLOYEES_IN_OUT EIO
                INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
                INNER JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID
                INNER JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND IS_MASTER = 1
                LEFT JOIN
                (
                    SELECT
                        BRANCH.BRANCH_NAME,
                        BRANCH.COMPANY_ID,
                        EMPLOYEES_IN_OUT.IN_OUT_ID,
                        EMPLOYEES_IN_OUT.BRANCH_ID,
                        DEPARTMENT.DEPARTMENT_HEAD
                    FROM
                        EMPLOYEES_IN_OUT 
                        INNER JOIN BRANCH ON EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
                        INNER JOIN DEPARTMENT ON EMPLOYEES_IN_OUT.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
                ) IN_OUT_TABLE ON EIO.IN_OUT_ID = IN_OUT_TABLE.IN_OUT_ID
                <cfif len(arguments.project_id)>
                    INNER JOIN WORKGROUP_EMP_PAR WGP ON WGP.EMPLOYEE_ID = EIO.EMPLOYEE_ID 
                </cfif>
            WHERE
                EIO.FINISH_DATE IS NULL
                <cfif len(arguments.company_id)>
                    AND IN_OUT_TABLE.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#" list="true">)
                </cfif> 
                <cfif len(arguments.branch_id)>
                    AND EIO.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
                </cfif> 
                <cfif len(arguments.department_id)>
                    AND EIO.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
                </cfif> 
                <cfif len(arguments.employee_name) and len(arguments.in_out_id)>
                    AND EIO.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">
                </cfif> 
                <cfif len(arguments.project_id)>
                    AND WGP.PROJECT_ID IN (<cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer" list="yes">)
                </cfif> 
            ORDER BY
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME
        </cfquery>
        <cfreturn GET_PDKS_WORKING_INOUT>
    </cffunction>

    <!--- Çalışanın gün içindeki pdk kayıtları ya da id listesine göre pdks kayıtları --->
    <cffunction name="GET_EMPLOYEE_DAILY_IN_OUT" access="public" returntype="query">
        <cfparam name="day_" default = "">
        <cfparam name="sal_mon" default="">
        <cfparam name="sal_year" default = "">
        <cfparam name="in_out_id" default = "">
        <cfparam name="row_id" default = "">
        <cfquery name="GET_EMPLOYEE_DAILY_IN_OUT" datasource="#dsn#">
            SELECT
                DAY_TYPE,
                COLOR_CODE,
                SWT.DETAIL,
                SWT.WORKING_ABBREVIATION,
                ROW_ID,
                START_DATE,
                FINISH_DATE,
                IN_OUT_ID,
                EMPLOYEE_ID
            FROM 
                EMPLOYEE_DAILY_IN_OUT 
                INNER JOIN SETUP_WORKING_TYPE SWT ON SWT.WORKING_TYPE = EMPLOYEE_DAILY_IN_OUT.DAY_TYPE
            WHERE
                <cfif isdefined("arguments.row_id") and len(arguments.row_id)> 
                    ROW_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.row_id#" list ="yes">)
                <cfelse>
                    IN_OUT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#" list="yes">) 
                    AND YEAR(START_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year#"> 
                    AND MONTH(START_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon#"> 
                    <cfif isdefined("arguments.day_") and len(arguments.day_)>
                        AND DAY(START_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.day_#"> 
                    </cfif>
                    AND DAY_TYPE IS NOT NULL
                </cfif>
        </cfquery>
        <cfreturn GET_EMPLOYEE_DAILY_IN_OUT>
    </cffunction>

    <!--- Seçilen ay içindeki çalışanların toplan dk ları --->
    <cffunction name="GET_EMPLOYEE_DAILY_IN_OUT_DIFF" access="public" returntype="query">
        <cfparam name="day_" default = "">
        <cfparam name="sal_mon" default="">
        <cfparam name="sal_year" default = "">
        <cfparam name="in_out_id" default = "">
        <cfparam name="day_type" default = "">
        <cfquery name="GET_EMPLOYEE_DAILY_IN_OUT_DIFF" datasource="#dsn#">
            SELECT
                SUM(DATEDIFF(MINUTE,START_DATE,FINISH_DATE)) MINUTE_
            FROM 
                EMPLOYEE_DAILY_IN_OUT 
            WHERE 
                IN_OUT_ID IN 
                (
                    SELECT
                        EIO.IN_OUT_ID
                    FROM 
                        EMPLOYEES_IN_OUT EIO
                        LEFT JOIN
                        (
                            SELECT
                                BRANCH.BRANCH_NAME,
                                BRANCH.COMPANY_ID,
                                EMPLOYEES_IN_OUT.IN_OUT_ID,
                                EMPLOYEES_IN_OUT.BRANCH_ID,
                                DEPARTMENT.DEPARTMENT_HEAD
                            FROM
                                EMPLOYEES_IN_OUT 
                                INNER JOIN BRANCH ON EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
                                INNER JOIN DEPARTMENT ON EMPLOYEES_IN_OUT.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
                        ) IN_OUT_TABLE ON EIO.IN_OUT_ID = IN_OUT_TABLE.IN_OUT_ID
                        <cfif isDefined("arguments.attr.project_id") and len(arguments.attr.project_id)>
                            INNER JOIN WORKGROUP_EMP_PAR WGP ON WGP.EMPLOYEE_ID = EIO.EMPLOYEE_ID 
                        </cfif>
                    WHERE
                        EIO.FINISH_DATE IS NULL
                        <cfif isDefined("arguments.attr.company_id") and len(arguments.attr.company_id)>
                            AND IN_OUT_TABLE.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.attr.company_id#" list="true">)
                        </cfif> 
                        <cfif isDefined("arguments.attr.branch_id") and len(arguments.attr.branch_id)>
                            AND EIO.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.attr.branch_id#">
                        </cfif> 
                        <cfif isDefined("arguments.attr.department_id") and len(arguments.attr.department_id)>
                            AND EIO.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.attr.department_id#">
                        </cfif> 
                        <cfif isDefined("arguments.attr.employee_name") and len(arguments.attr.employee_name) and isDefined("arguments.attr.in_out_id") and len(arguments.attr.in_out_id)>
                            AND EIO.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.attr.in_out_id#">
                        </cfif> 
                        <cfif isDefined("arguments.attr.project_id") and len(arguments.attr.project_id)>
                            AND WGP.PROJECT_ID IN (<cfqueryparam value = "#arguments.attr.project_id#" CFSQLType = "cf_sql_integer" list="yes">)
                        </cfif> 
                ) 
                AND YEAR(START_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year#"> 
                AND MONTH(START_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon#"> 
                <cfif isdefined("arguments.day_") and len(arguments.day_)>
                    AND DAY(START_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.day_#"> 
                </cfif>
                AND DAY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.day_type#">
        </cfquery>
        <cfreturn GET_EMPLOYEE_DAILY_IN_OUT_DIFF>
    </cffunction>

    <cffunction name="ADD_PDKS_WORKING_INOUT" access="public" returntype="any">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfset totalValues = structNew()>
            <cfset action_list_id = arguments.action_list>
            <cfset total_val_struct = {"day_type":"1"}>
            <cfset StructAppend(totalValues,total_val_struct,false)>

            <cfloop list = "#action_list_id#" index = "action_id">
                <cfset get_day_info = this.GET_EMPLOYEE_DAILY_IN_OUT(row_id: action_id)>

                <cfif get_day_info.recordcount>
                    <!--- Çalışma Günü, Hafta Tatili, Resmi Tatil, Gece çalışması--->
                    <cfif get_day_info.day_type eq -1 or get_day_info.day_type eq -2 or get_day_info.day_type eq -3 or get_day_info.day_type eq -4 or get_day_info.day_type eq -8 or get_day_info.day_type eq -9 or get_day_info.day_type eq -10 or get_day_info.day_type eq -11 or get_day_info.day_type eq -12 >
                        <cfset add_ext_worktime = this.add_ext_worktime(
                            working_type : get_day_info.day_type,
                            start_date   : get_day_info.start_date,
                            finish_date  : get_day_info.finish_date,
                            in_out_id    : get_day_info.in_out_id,
                            employee_id  : get_day_info.employee_id,
                            detail       : arguments.general_paper_notice,
                            ext_worktime_process : arguments.is_extworktime_process
                        )>
                    <cfelseif not(get_day_info.day_type eq -5 or get_day_info.day_type eq -6 or get_day_info.day_type eq -7 or get_day_info.day_type eq -13)>
                        <cfset add_offtime = this.add_offtime(
                            working_type : get_day_info.day_type,
                            start_date   : get_day_info.start_date,
                            finish_date  : get_day_info.finish_date,
                            in_out_id    : get_day_info.in_out_id,
                            employee_id  : get_day_info.employee_id,
                            detail       : arguments.general_paper_notice,
                            offtime_process : arguments.is_offtime_process
                        )>
                    </cfif>
                </cfif>
            </cfloop>
            <!--- General paper start--->
            <cfset attributes.fuseaction = '<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.working_inout'>

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
                action_page = '<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.working_inout'
                total_values = '#totalValues#'
                >
            <!--- General paper end--->
            <cfquery name="LAST_ID" datasource="#DSN#">
                SELECT MAX(ROW_ID) AS LATEST_RECORD_ID FROM EMPLOYEE_DAILY_IN_OUT
            </cfquery>
            <cf_wrk_get_history datasource="#dsn#" source_table="EMPLOYEE_DAILY_IN_OUT" target_table="EMPLOYEE_DAILY_IN_OUT_HISTORY" record_id= "#LAST_ID.LATEST_RECORD_ID#" record_name="ROW_ID">
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

    <!--- Çalışanın günlük pdks kaydı --->
    <cffunction name="ADD_PDKS_WORKING_INOUT_DAY" access="remote" returntype="any" returnformat="JSON">
        <cftry>
            <cfquery name="del_" datasource="#dsn#">
                DELETE FROM 
                    EMPLOYEE_DAILY_IN_OUT 
                WHERE 
                    IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#"> 
                    AND YEAR(START_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year#"> 
                    AND MONTH(START_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon#"> 
                    AND DAY(START_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.day_#"> 
                    AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"> 
            </cfquery>
            <cfloop from="1" to="#arguments.working_inout_day_count#" index="row_num">
                <cfif evaluate("arguments.row_#row_num#") eq 1>
                    <cfset day_type = evaluate("arguments.working_type_#row_num#")>
                    <cfset start_hour_  = evaluate("arguments.start_hour_#row_num#")>
                    <cfset start_min_   = evaluate("arguments.start_minute_#row_num#")>
                    <cfset finish_hour_ = evaluate("arguments.finish_hour_#row_num#")>
                    <cfset finish_min_  = evaluate("arguments.finish_minute_#row_num#")>
                   <cfif day_type eq '-1'>
                        <cfset temp_day_taype = 01>
                    <cfelseif day_type eq '-2'>
                        <cfset temp_day_taype = 02>
                    <cfelseif day_type eq '-3'>
                        <cfset temp_day_taype = 03>
                    <cfelseif day_type eq '-4'>
                        <cfset temp_day_taype = 04>
                    <cfelseif day_type eq '-5'>
                        <cfset temp_day_taype = 05>
                    <cfelseif day_type eq '-6'>
                        <cfset week_rest_day = 0>
                        <cfset temp_day_taype = 06>
                    <cfelseif day_type eq '-7'>
                        <cfset temp_day_taype = 07>
                        <cfset week_rest_day = 1>
                    <cfelseif day_type eq '-8'>
                        <cfset temp_day_taype = 08>
                    <cfelseif day_type eq '-9'>
                        <cfset temp_day_taype = 09>
                    <cfelseif day_type eq '-10'>
                        <cfset temp_day_taype = 10>
                    <cfelseif day_type eq '-11'>
                        <cfset temp_day_taype = 11>
                    <cfelseif day_type eq '-12'>
                        <cfset temp_day_taype = 12>
                    <cfelseif day_type eq '-13'>
                        <cfset temp_day_taype = 13>
                        <cfset is_akdi_day=1>
                    </cfif>

                    <cfquery name="add_emp_daily_in_out" datasource="#dsn#" result="MAX_ID">
                        INSERT INTO
                        EMPLOYEE_DAILY_IN_OUT
                        (
                            EMPLOYEE_ID,
                            IN_OUT_ID,
                            BRANCH_ID,
                            START_DATE,
                            FINISH_DATE,
                            SPECIAL_CODE,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP,
                            DAY_TYPE,
                            IS_WEEK_REST_DAY,
                            IS_AKDI_DAY
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(createdatetime(arguments.sal_year,arguments.sal_mon,arguments.day_,start_hour_,start_min_,0))#">,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(createdatetime(arguments.sal_year,arguments.sal_mon,arguments.day_,finish_hour_,finish_min_,0))#">,
                            <cfif isDefined("temp_day_taype") and len(temp_day_taype)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.special_code##arguments.employee_id##temp_day_taype#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.special_code##arguments.employee_id##day_type#"></cfif>,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value='#cgi.remote_addr#'>,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#day_type#">,
                            <cfif isdefined("week_rest_day") and len(week_rest_day)><cfqueryparam cfsqltype="cf_sql_bit" value="#week_rest_day#"><cfelse>NULL</cfif>,
                            <cfif isDefined("is_akdi_day")><cfqueryparam cfsqltype="cf_sql_bit" value="#is_akdi_day#"><cfelse>0</cfif>
                        )
                    </cfquery>
                    <cfset action_id_list_cfc = listAppend(action_id_list_cfc, MAX_ID.IDENTITYCOL)>
                </cfif>
            </cfloop>
            <cfquery name="LAST_ID" datasource="#DSN#">
                SELECT MAX(ROW_ID) AS LATEST_RECORD_ID FROM EMPLOYEE_DAILY_IN_OUT
            </cfquery>
            <cf_wrk_get_history datasource="#dsn#" source_table="EMPLOYEE_DAILY_IN_OUT" target_table="EMPLOYEE_DAILY_IN_OUT_HISTORY" record_id= "#LAST_ID.LATEST_RECORD_ID#" record_name="ROW_ID">
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = '#action_id_list_cfc#'>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(responseStruct),'//','')>
    </cffunction>

    <!--- ÇAlışanan fazla mesai ekleme --->
    <cffunction name="add_ext_worktime" access="public" returntype="any">
        <cftry>
           <cfif arguments.working_type eq '-1'> <!--- Çalışma Günü --->
                
                <cfset working_type_ = 0>
				<cfset temp_day_taype= 00>					  
            <cfelseif arguments.working_type eq '-2'> <!--- Hafta Tatili(Dini Bayram Mesaisi) --->
                <cfset working_type_ = 1>
                <cfset temp_day_taype= 01>
            <cfelseif arguments.working_type eq '-3'> <!--- Resmi Tatil (Dini Bayram Fazla Mesai--->
                <cfset working_type_ = 2>
                <cfset temp_day_taype= 02>
            <cfelseif arguments.working_type eq '-4'> <!--- Gece Çalışması --->
                <cfset working_type_ = 3>
                <cfset temp_day_taype= 03>
             <cfelseif arguments.working_type eq '-8'> <!--- Hafta Tatil Gün  --->
                    <cfset working_type_ = -8>
                    <cfset temp_day_taype= 08>
             <cfelseif arguments.working_type eq '-9'> <!--- Akdi Tatil Gün --->
                    <cfset working_type_ = -9>
                    <cfset temp_day_taype= 09>
             <cfelseif arguments.working_type eq '-10'> <!--- Resmi Tatil Gün --->
                    <cfset working_type_ = -10>
                    <cfset temp_day_taype= 10>
             <cfelseif arguments.working_type eq '-11'> <!--- Arefe Tatil Gün  --->
                    <cfset working_type_ = -11>
                    <cfset temp_day_taype= 11>
             <cfelseif arguments.working_type eq '-12'> <!--- Dini Bayram Gün --->
                    <cfset working_type_ = -12>
                    <cfset temp_day_taype= 12>
            <cfelseif arguments.working_type eq '-13'> <!--- Akdi Gün --->
                    <cfset working_type_ = -13>
                    <cfset temp_day_taype= 13>
                    <cfset is_akdi_day=1>
            </cfif>

            <cfquery name="del_ext_worktime" datasource="#dsn#">
                DELETE FROM 
                    EMPLOYEES_EXT_WORKTIMES 
                WHERE 
                    SPECIAL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.in_out_id##day(arguments.start_date)##month(arguments.start_date)##year(arguments.start_date)##arguments.employee_id##temp_day_taype#">
            </cfquery>

            <cfquery name="get_" datasource="#dsn#" maxrows="1">
                SELECT
                    EP.UPPER_POSITION_CODE,
                    EP.UPPER_POSITION_CODE2
                FROM
                    EMPLOYEE_POSITIONS EP
                WHERE
                    EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> AND
                    EP.IS_MASTER = 1
            </cfquery>
            <cfquery name="add_worktime" datasource="#dsn#" result="MAX_ID">
                INSERT INTO
                EMPLOYEES_EXT_WORKTIMES
                (
                    IS_PUANTAJ_OFF,
                    EMPLOYEE_ID,
                    WORK_START_TIME,
                    WORK_END_TIME,
                    START_TIME,
                    END_TIME,
                    DAY_TYPE,
                    VALIDATOR_POSITION_CODE_1,
                    VALIDATOR_POSITION_CODE_2,
                    VALID_DETAIL,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP,
                    IN_OUT_ID,
                    PROCESS_STAGE,
                    VALID, 
                    VALID_EMPLOYEE_ID, 
                    VALIDDATE,
                    WORKTIME_WAGE_STATU,
		            WORKING_SPACE,
                    SPECIAL_CODE
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#working_type_#">,
                    <cfif len(get_.upper_position_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_.upper_position_code#"><cfelse>NULL</cfif>,
                    <cfif len(get_.upper_position_code2)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_.upper_position_code2#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ext_worktime_process#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                    <cfif isDefined(#temp_day_taype#)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.in_out_id##day(arguments.start_date)##month(arguments.start_date)##year(arguments.start_date)##arguments.employee_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.in_out_id##day(arguments.start_date)##month(arguments.start_date)##year(arguments.start_date)##arguments.employee_id##temp_day_taype#"></cfif>
                 )
            </cfquery>

            <cfset attributes.fuseaction = '<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.working_inout'>
            <cf_workcube_process 
                is_upd='1' 
                data_source='#dsn#' 
                old_process_line='0'
                process_stage='#arguments.ext_worktime_process#' 
                record_member='#session.ep.userid#' 
                record_date='#now()#'
                action_table='EMPLOYEES_EXT_WORKTIMES'
                action_column='EWT_ID'
                action_id='#MAX_ID.IDENTITYCOL#'
                action_page='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_ext_worktimes&event=upd&EWT_ID=#MAX_ID.IDENTITYCOL#'
                warning_description='#arguments.detail#'>

            <cf_wrk_get_history datasource="#dsn#" source_table="EMPLOYEES_EXT_WORKTIMES" target_table="EMPLOYEES_EXT_WORKTIMES_HISTORY" record_id= "#MAX_ID.IDENTITYCOL#" record_name="EWT_ID">
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

    <!--- ÇAlışanan izin ekleme --->
    <cffunction name="add_offtime" access="public" returntype="any">
        <cftry>
            <cfquery name="del_offtime" datasource="#dsn#">
                DELETE FROM 
                    OFFTIME 
                WHERE 
                    SPECIAL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.in_out_id##day(arguments.start_date)##month(arguments.start_date)##year(arguments.start_date)##arguments.employee_id#">
            </cfquery>
            <cfset arguments.start_date = dateadd("h", -session.ep.time_zone, arguments.start_date)>
            <cfset arguments.finish_date = dateadd("h", -session.ep.time_zone, arguments.finish_date)>
            <cfquery name="add_offtime" datasource="#dsn#" result="MAX_ID">
                INSERT INTO
                OFFTIME
                (
                    IS_PUANTAJ_OFF,
                    RECORD_IP,
                    RECORD_EMP,
                    RECORD_DATE,
                    EMPLOYEE_ID,
                    IN_OUT_ID,
                    OFFTIMECAT_ID,
                    SUB_OFFTIMECAT_ID,
                    STARTDATE,
                    FINISHDATE,
                    WORK_STARTDATE,
                    TOTAL_HOURS,
                    DETAIL,
                    OFFTIME_STAGE,
                    SPECIAL_CODE
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.working_type#">,
                    <cfif isdefined("attributes.SUB_OFFTIMECAT_ID") and len(attributes.SUB_OFFTIMECAT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sub_offtimecat_id#"><cfelse>0</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,arguments.start_date)#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offtime_process#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.in_out_id##day(arguments.start_date)##month(arguments.start_date)##year(arguments.start_date)##arguments.employee_id#">
                )
            </cfquery>
            <cfset attributes.fuseaction = '<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.working_inout'>
            <cf_workcube_process 
                is_upd='1' 
                data_source='#dsn#' 
                old_process_line='0'
                process_stage='#arguments.offtime_process#' 
                record_member='#session.ep.userid#' 
                record_date='#now()#' 
                action_table='OFFTIME'
                action_column='OFFTIME_ID'
                action_id='#MAX_ID.IDENTITYCOL#'
                action_page='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.offtimes&event=upd&offtime_id=#MAX_ID.IDENTITYCOL#' 
                warning_description='#arguments.detail#'>

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

    <!--- İizin ve Fm sayfalarından kayıt --->
    <cffunction name="add_pdks_day" access="public" returntype="any">
        <cftry>
            <cfquery name="del_" datasource="#dsn#">
                DELETE
                FROM 
                    EMPLOYEE_DAILY_IN_OUT 
                WHERE 
                    IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#"> 
                    AND YEAR(START_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year#"> 
                    AND MONTH(START_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon#"> 
                    AND DAY(START_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.day_#">
            </cfquery>
            <cfif arguments.offtimecat_id eq '-6'>
                <cfset week_rest_day = 0>
            <cfelseif arguments.offtimecat_id eq '-7'>
                <cfset week_rest_day = 1>
            </cfif>
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
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP,
                    DAY_TYPE,
                    FILE_ID,
                    IS_WEEK_REST_DAY
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(createdatetime(arguments.sal_year,arguments.sal_mon,arguments.day_,arguments.start_hour,arguments.start_min,0))#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(createdatetime(arguments.sal_year,arguments.sal_mon,arguments.day_,arguments.finish_hour,arguments.finish_min,0))#">,
                    <cfif isDefined("attriributes.temp_day_taype")><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.in_out_id##arguments.day_##arguments.sal_mon##arguments.sal_year##arguments.employee_id##temp_day_taype#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.in_out_id##arguments.day_##arguments.sal_mon##arguments.sal_year##arguments.employee_id#"></cfif>,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value='#cgi.remote_addr#'>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offtimecat_id#">,
                    <cfif isdefined("arguments.file_id") and len(arguments.file_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.file_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("week_rest_day") and len(week_rest_day)><cfqueryparam cfsqltype="cf_sql_bit" value="#week_rest_day#"><cfelse>NULL</cfif>
                )
            </cfquery>
            <cfquery name="LAST_ID" datasource="#DSN#">
                SELECT MAX(ROW_ID) AS LATEST_RECORD_ID FROM EMPLOYEE_DAILY_IN_OUT
            </cfquery>
            <cf_wrk_get_history datasource="#dsn#" source_table="EMPLOYEE_DAILY_IN_OUT" target_table="EMPLOYEE_DAILY_IN_OUT_HISTORY" record_id= "#LAST_ID.LATEST_RECORD_ID#" record_name="ROW_ID">
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
</cfcomponent>
