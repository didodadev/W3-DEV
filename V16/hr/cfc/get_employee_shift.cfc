<!---
File: get_employee_shift.cfc
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date: 07.04.2020
Controller: -
Description: Çalışanın vardiyalı çalışma saatlerinin, vardiya tanımlarının bulunduğu cfc dosyasıdır.
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get_emp_shift" access="public">
		<cfargument name="employee_id" default="">
        <cfargument name="in_out_id" default="">
		<cfargument name="eio_finish_date" default="#now()#"><!--- Çalışaının Çıkış tarihi --->
		<cfargument name="eio_start_date" default="#now()#"><!--- Çalışaının Giriş tarihi --->
		<cfargument name="finish_date" default="#now()#"><!--- Vardiya bitiş tarihi--->
        <cfargument name="start_date" default="#now()#"><!---Vardiya başlangıç tarihi --->
        <cfargument name="control" default="1"><!---Vardiya başlangıç tarihi --->
        <cfset arguments.start_date = CreateDateTime(year(start_date),month(start_date),day(start_date),0,0,0)>
        <cfset arguments.finish_date = CreateDateTime(year(finish_date),month(finish_date),day(finish_date),0,0,0)>
		<cfquery name="get_emp_shift" datasource="#dsn#">
            SELECT
                SS.*,
				SS.IS_ARA_MESAI_DUS,
                SSE.START_DATE,
				SSE.FINISH_DATE
            FROM
                EMPLOYEES_IN_OUT EIO
				LEFT JOIN SETUP_SHIFT_EMPLOYEE SSE ON SSE.IN_OUT_ID = EIO.IN_OUT_ID
                LEFT JOIN SETUP_SHIFTS SS ON SSE.SHIFT_ID = SS.SHIFT_ID
            WHERE
                SSE.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                <cfif len(arguments.in_out_id)>
                    SSE.EMPLOYEE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">
                </cfif>
                AND (EIO.FINISH_DATE IS NULL OR EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.eio_finish_date#">)
				AND 
				(
                    (
                    SSE.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
                    SSE.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                    )
                    OR
                    (
                    SSE.START_DATE  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
                    SSE.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                    )
				)
                AND 
				(
                    (
                    EIO.STARTDATE_SHIFT >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
                    EIO.STARTDATE_SHIFT < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                    )
                    OR
                    (
                    EIO.STARTDATE_SHIFT  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
                    EIO.FINISHDATE_SHIFT >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                    )
				)
                <cfif arguments.control eq 1>
				    AND SS.IS_ARA_MESAI_DUS = 1
                </cfif>
            ORDER BY
                START_DATE,
                FINISH_DATE
        </cfquery>
        <cfreturn get_emp_shift>
	</cffunction>

    <!--- Vardiyalar Query'si --->
    <cffunction name="GET_SHIFTS" access="public">
        <cfargument name="shift_id" default="">
        <cfquery name="GET_SHIFTS" datasource="#dsn#">
            SELECT 
                SHIFT_ID, 
                SHIFT_NAME, 
                START_HOUR, 
                END_HOUR, 
                START_MIN, 
                END_MIN, 
                RECORD_EMP, 
                RECORD_DATE, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP, 
                BRANCH_ID, 
                DEPARTMENT_ID
            FROM 
                SETUP_SHIFTS 
            <cfif len(arguments.shift_id)>
                WHERE 
                    SHIFT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.shift_id#">
            </cfif>
            ORDER BY 
                SHIFT_ID
        </cfquery>
        <cfreturn GET_SHIFTS>
    </cffunction>

    <!--- Vardiya çalışan Filtresi --->
    <cffunction name="GET_SHIF_EMPLOYEES" access="public">
        <cfargument name="employee_id" default="">
        <cfargument name="employee_name" default="">
        <cfargument name="department_id" default="">
        <cfargument name="department_name" default="">
        <cfargument name="branch_id" default="">
        <cfargument name="shift_id" default="">
        <cfargument name="in_out_id" default="">
        <cfargument name="is_shift" default="">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="">
        <cfargument name="is_dep_power_control" default="0">
        <cfargument name="is_myshift" default="0">
        <cfargument name="branch_name" default="">
        <cfquery name="GET_SHIF_EMPLOYEES" datasource="#dsn#">
           SELECT 
                <cfif len(arguments.start_date) and len(arguments.finish_date) and len(arguments.department_id) and len(arguments.department_name) and len(arguments.branch_name) and len(arguments.branch_id)>
                    EIO.EMPLOYEE_ID,
                    EIO.IN_OUT_ID,
                    SSE.SHIFT_ID,
                    SSE.SETUP_SHIFT_EMPLOYEE_ID,
                    SSE.START_DATE,
                    SSE.FINISH_DATE
                <cfelse>
                    SSE.*
                </cfif>
            FROM
                <cfif len(arguments.start_date) and len(arguments.finish_date) and len(arguments.department_id) and len(arguments.department_name) and len(arguments.branch_name) and len(arguments.branch_id)>
                    EMPLOYEES E
                    LEFT JOIN EMPLOYEES_IN_OUT EIO ON EIO.EMPLOYEE_ID = E.EMPLOYEE_ID
                    LEFT JOIN DEPARTMENT DP ON DP.DEPARTMENT_ID = EIO.DEPARTMENT_ID
                    LEFT JOIN BRANCH B ON B.BRANCH_ID = DP.BRANCH_ID
                    LEFT JOIN SETUP_SHIFT_EMPLOYEE SSE ON SSE.EMPLOYEE_ID = E.EMPLOYEE_ID
                <cfelse>
                    SETUP_SHIFT_EMPLOYEE SSE
                    LEFT JOIN EMPLOYEES_IN_OUT EIO ON EIO.IN_OUT_ID = SSE.IN_OUT_ID
                    LEFT JOIN DEPARTMENT DP ON DP.DEPARTMENT_ID = EIO.DEPARTMENT_ID
                    LEFT JOIN BRANCH B ON B.BRANCH_ID = DP.BRANCH_ID
                    INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
                </cfif>
            WHERE
                1 = 1
                <cfif len(arguments.employee_id) and len(arguments.employee_name)>
                    AND E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                </cfif>
                <cfif len(arguments.department_id) and len(arguments.department_name)>
                    AND DP.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
                </cfif>
                <cfif len(arguments.branch_name) and len(arguments.branch_id)>
                    AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
                </cfif>
                <cfif len(arguments.shift_id)>
                    AND SSE.SHIFT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.shift_id#">
                </cfif>
                <cfif len(arguments.in_out_id)>
                    AND EIO.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">
                </cfif>
                <cfif len(arguments.start_date) and len(arguments.finish_date) and len(arguments.department_id) and len(arguments.department_name) and len(arguments.branch_name) and len(arguments.branch_id) >
                    AND 
                    (
                        (
                            STARTDATE_SHIFT >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
                            STARTDATE_SHIFT < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                        )
                        OR
                        (
                            STARTDATE_SHIFT  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
                            FINISHDATE_SHIFT >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                        )
                    )
                </cfif> 
                <cfif arguments.is_myshift eq 1 and len(arguments.start_date) and len(arguments.finish_date)>
                    AND 
                    (
                        (
                        SSE.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
                        SSE.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                        )
                        OR
                        (
                        SSE.START_DATE  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
                        SSE.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                        )
                    )
                <cfelseif not (len(arguments.start_date) and len(arguments.finish_date) and len(arguments.department_id) and len(arguments.department_name) and len(arguments.branch_name) and len(arguments.branch_id))>
                    <cfif len(arguments.start_date)>AND SSE.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"></cfif>
                    <cfif len(arguments.finish_date)>AND SSE.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#"></cfif>
                </cfif>
                <cfif isdefined("arguments.is_dep_power_control") and len(arguments.is_dep_power_control) and arguments.is_dep_power_control eq 1>
                    AND 
                    (
                        (EIO.DEPARTMENT_ID IN(SELECT EP.DEPARTMENT_ID FROM EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) )
                        OR
                        (
                            (
                                DP.HIERARCHY_DEP_ID LIKE  CONCAT('%.',(select D.DEPARTMENT_ID from DEPARTMENT D LEFT JOIN DEPARTMENT as D2 ON D.HIERARCHY_DEP_ID  = CONCAT(D2.HIERARCHY_DEP_ID,'.',D.DEPARTMENT_ID) where d.DEPARTMENT_ID = (SELECT EP.DEPARTMENT_ID FROM EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)),'.%')
                                OR
                                DP.HIERARCHY_DEP_ID LIKE  CONCAT((select D.DEPARTMENT_ID from DEPARTMENT D LEFT JOIN DEPARTMENT as D2 ON D.HIERARCHY_DEP_ID  = CONCAT(D2.HIERARCHY_DEP_ID,'.',D.DEPARTMENT_ID) where d.DEPARTMENT_ID = (SELECT EP.DEPARTMENT_ID FROM EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)),'.%')
                            )
                        )
                    )
                </cfif>
            ORDER BY  
                E.EMPLOYEE_NAME,
                SSE.START_DATE,
                SSE.FINISH_DATE
        </cfquery>
        <cfreturn GET_SHIF_EMPLOYEES>
    </cffunction>
    <cffunction name="ADD_SHIFT" access="remote" returnFormat="json" returntype="any">
        <cfargument name="employee_id" default="">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="">
        <cfargument name="shift_id" default="">
        <cfargument name="in_out_id" default="">
        <cf_date tarih = "arguments.start_date">
        <cf_date tarih = "arguments.finish_date">
        <cfquery name="ADD_SHIFT" datasource="#dsn#" result="MAX_ID">
            INSERT INTO
                SETUP_SHIFT_EMPLOYEE
                (
                    EMPLOYEE_ID,
                    SHIFT_ID,
                    START_DATE,
                    FINISH_DATE,
                    IN_OUT_ID
                ) 
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.shift_id#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">
                )
        </cfquery>
        <cfreturn  Replace( serializeJSON(MAX_ID.IDENTITYCOL), "//", "" )>
    </cffunction>
    <cffunction name="UPD_SHIFT" access="remote">
        <cfargument name="employee_id" default="">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="">
        <cfargument name="setup_shift_employee_id" default="">
        <cfargument name="shift_id" default="">
        <cfargument name="in_out_id" default="">
        <cf_date tarih = "arguments.start_date">
        <cf_date tarih = "arguments.finish_date">
        <cfquery name="UPD_SHIFT" datasource="#dsn#">
            UPDATE
                SETUP_SHIFT_EMPLOYEE
            SET
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
                SHIFT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.shift_id#">,
                START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">,
                FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">,
                IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">
            WHERE  
                SETUP_SHIFT_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.setup_shift_employee_id#">
        </cfquery>
        <cfreturn 'Güncellendi'>
    </cffunction>
    <cffunction name="DEL_SHIFT" access="remote">
        <cfargument name="setup_shift_employee_id" default="">
        <cfquery name="DEL_SHIFT" datasource="#dsn#">
            DELETE
                SETUP_SHIFT_EMPLOYEE
            WHERE  
                SETUP_SHIFT_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.setup_shift_employee_id#">
        </cfquery>
        <cfreturn 'silindi'>
    </cffunction>
    <!--- Vardiya çalışan Filtresi --->
    <cffunction name="GET_SHIF_EMPLOYEES_IN_OUT" access="public">
        <cfargument name="employee_id" default="">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="">
        <cfquery name="GET_SHIF_EMPLOYEES_IN_OUT" datasource="#dsn#">
           SELECT 
                EMPLOYEE_ID
            FROM
                EMPLOYEES_IN_OUT 
            WHERE
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                <cfif len(arguments.start_date)>
                    AND 
                    (
                        (
                            STARTDATE_SHIFT >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
                            STARTDATE_SHIFT < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                        )
                        OR
                        (
                            STARTDATE_SHIFT  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
                            FINISHDATE_SHIFT >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                        )
                    )
                </cfif>
        </cfquery>
        <cfreturn GET_SHIF_EMPLOYEES_IN_OUT>
    </cffunction>
    <cffunction name="GET_SHIF_EMPLOYEES_IN_OUT_JSON" access="remote" returntype="string" returnFormat="json">
        <cfargument name="employee_id" default="">
        <cfquery name="GET_SHIF_EMPLOYEES_IN_OUT_JSON" datasource="#dsn#">
           SELECT 
                EMPLOYEE_ID
            FROM
                EMPLOYEES_IN_OUT 
            WHERE
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                AND 
                    (
                        IS_VARDIYA = 1
                        OR
                        IS_VARDIYA = 2
                    )
        </cfquery>
         <cfreturn Replace(serializeJSON(GET_SHIF_EMPLOYEES_IN_OUT_JSON.recordcount),'//','')>
    </cffunction>
    <cffunction name="get_emp_shift_json" access="remote" returntype="string" returnFormat="json">
        <cfargument name="employee_id" default="">
        <cfargument name="eio_finish_date" default="#now()#"><!--- Çalışaının Çıkış tarihi --->
        <cfargument name="eio_start_date" default="#now()#"><!--- Çalışaının Giriş tarihi --->
        <cfargument name="finish_date" default="#now()#"><!--- Vardiya bitiş tarihi--->
        <cfargument name="start_date" default="#now()#"><!---Vardiya başlangıç tarihi --->
        <cfargument name="control" default="1"><!---Vardiya başlangıç tarihi --->
        <cf_date tarih = "arguments.start_date">
        <cf_date tarih = "arguments.finish_date">
        <cfquery name="get_emp_shift_json" datasource="#dsn#">
            SELECT
                SS.START_HOUR,
                SS.END_HOUR,
                SS.START_MIN,
                SS.END_MIN
            FROM
                SETUP_SHIFT_EMPLOYEE SSE 
                LEFT JOIN SETUP_SHIFTS SS ON SSE.SHIFT_ID = SS.SHIFT_ID
            WHERE
                SSE.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                AND 
                (
                    (
                    SSE.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
                    SSE.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                    )
                    OR
                    (
                    SSE.START_DATE  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
                    SSE.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                    )
                )
        </cfquery>
        <cfreturn Replace(serializeJSON(get_emp_shift_json),'//','')>
    </cffunction>

     <!--- Buton Yetkileri --->
    <cffunction name="GET_BUTTONS_INFO" access="public">
        <cfargument name="fuseaction" default="">
        <cfquery name="GET_BUTTONS_INFO" datasource="#dsn#">
            SELECT
               U.*
            FROM
                EMPLOYEE_POSITIONS AS E
                LEFT JOIN USER_GROUP_OBJECT AS U ON E.USER_GROUP_ID = U.USER_GROUP_ID
            WHERE
                E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                AND U.OBJECT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fuseaction#">
        </cfquery>
        <cfreturn GET_BUTTONS_INFO>
    </cffunction>
</cfcomponent>

