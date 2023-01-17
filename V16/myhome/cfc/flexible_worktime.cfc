<!---
    File: flexible_worktime.cfc
    Controller: fuseaction is myhome = FlexibleWorkTimeController.cfm, fuseaction is hr = hrFlexibleWorkTimeController.cfm
    Author: Esma R. UYSAL
    Date: 07/12/2019 
    Description:
        Esnek çalışma saatleri cfc lerinin bulunduğu dosyadır.
        Ekleme, Güncelleme, Listeleme ve silme fonksiyonları bulunur. 
--->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="ADD_FLEXIBLE_WORKTIME" access="public" returnFormat="json" returntype="any">
        <cfargument name = "employee_id">
        <cfargument name = "position_id">
        <cfargument name = "department_id">
        <cfargument name = "branch_id">
        <cfargument name = "request_date">
        <cfargument name = "stage_id">
        <cfargument name = "worktime_flexible_notice">
		<cfquery name="ADD_FLEXIBLE_WORKTIME" datasource="#dsn#" result="MAX_ID">
            INSERT INTO
                WORKTIME_FLEXIBLE
            (
                EMPLOYEE_ID,
                POSITION_ID,
                DEPARTMENT_ID,
                BRANCH_ID,
                REQUEST_DATE,
                STAGE_ID,
                WORKTIME_FLEXIBLE_NOTICE,
                RECORD_EMP,
                RECORD_IP,
                RECORD_DATE
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.request_date#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stage_id#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.worktime_flexible_notice#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            )
		</cfquery>
		<cfreturn Replace( serializeJSON(MAX_ID.IDENTITYCOL), "//", "" ) />
	</cffunction>
    <cffunction name="UPD_FLEXIBLE_WORKTIME" access="public" returnFormat="json" returntype="any">
        <cfargument name = "employee_id">
        <cfargument name = "flexible_id">
        <cfargument name = "position_id">
        <cfargument name = "department_id">
        <cfargument name = "branch_id">
        <cfargument name = "request_date">
        <cfargument name = "stage_id">
        <cfargument name = "worktime_flexible_notice">
        
		<cfquery name="UPD_FLEXIBLE_WORKTIME" datasource="#dsn#" result="MAX_ID">
            UPDATE
                WORKTIME_FLEXIBLE
            SET
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
                POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_id#">,
                DEPARTMENT_ID = <cfif len(arguments.department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#"><cfelse>NULL</cfif>,
                BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">,
                REQUEST_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.request_date#">,
                STAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stage_id#">,
                WORKTIME_FLEXIBLE_NOTICE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.worktime_flexible_notice#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            WHERE
                WORKTIME_FLEXIBLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.flexible_id#">
		</cfquery>
		<cfreturn 1>
	</cffunction>
    <cffunction name="ADD_FLEXIBLE_WORKTIME_ROWS" access="public" returnFormat="json" returntype="any">
        <cfargument name = "worktime_flexible_id">
        <cfargument name = "flexible_start_hour">
        <cfargument name = "flexible_start_min" default = "0">
        <cfargument name = "flexible_finish_hour">
        <cfargument name = "flexible_finish_min" default = "0">
        <cfargument name = "flexible_month">
        <cfargument name = "flexible_day">
        <cfargument name = "flexible_date">
        <cfargument name = "flexible_year">
        <cfargument name = "is_approve" default = "0">
		<cfquery name="ADD_FLEXIBLE_WORKTIME_ROWS" datasource="#dsn#" result="MAX_ID">
            INSERT INTO
                WORKTIME_FLEXIBLE_ROW
            (
                WORKTIME_FLEXIBLE_ID,
                FLEXIBLE_START_HOUR,
                FLEXIBLE_START_MINUTE,
                FLEXIBLE_FINISH_HOUR,
                FLEXIBLE_FINISH_MINUTE,
                FLEXIBLE_MONTH,
                FLEXIBLE_DAY,
                FLEXIBLE_DATE,
                FLEXIBLE_YEAR,
                IS_APPROVE
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.worktime_flexible_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.flexible_start_hour#">,
                <cfif len(arguments.flexible_start_min)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.flexible_start_min#"><cfelse>0</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.flexible_finish_hour#">,
                <cfif len(arguments.flexible_finish_min)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.flexible_finish_min#"><cfelse>0</cfif>,
                <cfif len(arguments.flexible_month)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.flexible_month#"><cfelse>NULL</cfif>,
                <cfif len(arguments.flexible_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.flexible_day#"><cfelse>NULL</cfif>,
                <cfif len(arguments.flexible_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.flexible_date#"><cfelse>NULL</cfif>,
                <cfif len(arguments.flexible_year)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.flexible_year#"><cfelse>NULL</cfif>,
                <cfif len(arguments.is_approve)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_approve#"><cfelse>NULL</cfif>
            )
		</cfquery>
		<cfreturn Replace( serializeJSON(MAX_ID.IDENTITYCOL), "//", "" ) />
	</cffunction>
    <cffunction name="UPD_FLEXIBLE_WORKTIME_ROW" access="public" returnFormat="json" returntype="any">
        <cfargument name = "worktime_flexible_id">
        <cfargument name = "flexible_start_hour">
        <cfargument name = "flexible_start_min" default = "0">
        <cfargument name = "flexible_finish_hour">
        <cfargument name = "flexible_finish_min" default="0">
        <cfargument name = "flexible_month">
        <cfargument name = "flexible_day">
        <cfargument name = "flexible_date">
        <cfargument name = "flexible_year">
        <cfargument name = "is_approve">
        <cfargument name = "is_del" default = "0">
        <cfif arguments.is_del neq 1>
            <cfquery name="INS_FLEXIBLE_WORKTIME_ROWS" datasource="#dsn#">
                INSERT INTO
                    WORKTIME_FLEXIBLE_ROW
                (
                    WORKTIME_FLEXIBLE_ID,
                    FLEXIBLE_START_HOUR,
                    FLEXIBLE_START_MINUTE,
                    FLEXIBLE_FINISH_HOUR,
                    FLEXIBLE_FINISH_MINUTE,
                    FLEXIBLE_MONTH,
                    FLEXIBLE_DAY,
                    FLEXIBLE_DATE,
                    FLEXIBLE_YEAR,
                    IS_APPROVE
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.worktime_flexible_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.flexible_start_hour#">,
                    <cfif len(arguments.flexible_start_min)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.flexible_start_min#"><cfelse>0</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.flexible_finish_hour#">,
                    <cfif len(arguments.flexible_finish_min)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.flexible_finish_min#"><cfelse>0</cfif>,
                    <cfif len(arguments.flexible_month)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.flexible_month#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.flexible_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.flexible_day#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.flexible_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.flexible_date#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.flexible_year)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.flexible_year#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.is_approve)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_approve#"><cfelse>NULL</cfif>
                )
            </cfquery>
        </cfif>
		<cfreturn 1>
	</cffunction>
    <cffunction name="GET_WORKTIME_FLEXIBLE" access="remote"  returntype="any">
        <cfargument name="flexible_id" default=""> 
        <cfargument name="employee_id" default=""> 
        <cfargument name="start_flexible_date" default=""> 
        <cfargument name="finish_flexible_date" default=""> 
        <cfquery name="GET_WORKTIME_FLEXIBLE" datasource="#dsn#">
            SELECT
                *
            FROM   
                WORKTIME_FLEXIBLE 
            WHERE
                1 = 1
                <cfif isdefined("arguments.flexible_id") and len(arguments.flexible_id)>
                    AND WORKTIME_FLEXIBLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.flexible_id#">
                </cfif>
                <cfif isdefined("arguments.employee_id") and len(arguments.employee_id)>
                    AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                </cfif>
             <cfif len(arguments.finish_flexible_date) AND len(arguments.start_flexible_date)>
                    AND REQUEST_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_flexible_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_flexible_date#">
            <cfelseif len(arguments.finish_flexible_date)>
                AND REQUEST_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_flexible_date#">
                <cfelseif len(arguments.start_flexible_date)>
                AND REQUEST_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_flexible_date#">
            </cfif>
        </cfquery>
        <cfreturn GET_WORKTIME_FLEXIBLE>
    </cffunction>
    <cffunction name="GET_WORKTIME_FLEXIBLE_ROW" access="remote"  returntype="any">
        <cfargument name="flexible_id" default=""> 
        <cfargument name="is_period" default=""> 
        <cfargument name="startdate" default=""> 
        <cfargument name="finishdate" default=""> 
        <cfquery name="GET_WORKTIME_FLEXIBLE_ROW" datasource="#dsn#">
            SELECT
                *,
                D.HIERARCHY_DEP_ID AS HIERARCHY_DEP_ID1,
                CASE 
                    WHEN E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE START_DATE <= GETDATE() AND (FINISH_DATE >= GETDATE() OR FINISH_DATE IS NULL))
                THEN	
                    D.HIERARCHY_DEP_ID
                ELSE 
                    CASE WHEN 
                        D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID))
                    THEN
                        (SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D.DEPARTMENT_ID AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC)
                    ELSE
                        D.HIERARCHY_DEP_ID
                    END
                END AS HIERARCHY_DEP_ID
            FROM   
                WORKTIME_FLEXIBLE_ROW WFR
                    INNER JOIN WORKTIME_FLEXIBLE WF ON WF.WORKTIME_FLEXIBLE_ID = WFR.WORKTIME_FLEXIBLE_ID
                    INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = WF.EMPLOYEE_ID
                    INNER JOIN DEPARTMENT D ON D.DEPARTMENT_ID = WF.DEPARTMENT_ID
            WHERE
                WFR.WORKTIME_FLEXIBLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.flexible_id#">
                <cfif len(arguments.is_period) and arguments.is_period eq  1>
                    AND  WFR.FLEXIBLE_MONTH IS NOT NULL
                </cfif>
                <cfif len(arguments.is_period) and arguments.is_period eq  0>
                    AND  WFR.FLEXIBLE_MONTH IS NULL
                </cfif>
                <cfif len(arguments.startdate)>
                    AND 
                    (
                        WFR.FLEXIBLE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#">
                        OR 
                        WFR.FLEXIBLE_MONTH >=  <cfqueryparam cfsqltype="cf_sql_integer" value="#month(arguments.startdate)#"> AND FLEXIBLE_YEAR >=  <cfqueryparam cfsqltype="cf_sql_integer" value="#year(arguments.startdate)#">
                    )
                </cfif>
                 <cfif len(arguments.finishdate)>
                    AND 
                    (
                        WFR.FLEXIBLE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">
                        OR 
                        WFR.FLEXIBLE_MONTH <=  <cfqueryparam cfsqltype="cf_sql_integer" value="#month(arguments.finishdate)#"> AND FLEXIBLE_YEAR <=  <cfqueryparam cfsqltype="cf_sql_integer" value="#year(arguments.finishdate)#">
                    )
                </cfif>
        </cfquery>
        <cfreturn GET_WORKTIME_FLEXIBLE_ROW>
    </cffunction>
    <cffunction name="DEL_FLEXIBLE_ROW" access="remote"  returntype="any">
        <cfargument name="worktime_flexible_id" default=""> 
       <cfquery name="DEL_FLEXIBLE_ROW" datasource="#dsn#">
                DELETE FROM WORKTIME_FLEXIBLE_ROW WHERE WORKTIME_FLEXIBLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.worktime_flexible_id#">
        </cfquery>
        <cfreturn 1>
    </cffunction>
    <cffunction name="GET_WORKTIME_FLEXIBLE_LIST" access="public"  returntype="any">
        <cfargument name="startrow" default="1">
        <cfargument name="maxrows" default="20">
        <cfargument name="flexible_id" default=""> 
        <cfargument name="employee_id" default=""> 
        <cfargument name="position_id" default=""> 
        <cfargument name="department_id" default=""> 
        <cfargument name="branch_id" default=""> 
        <cfargument name="stage_id" default=""> 
        <cfargument name="process_status" default=""> 
        <cfargument name="startdate" default=""> 
        <cfargument name="finishdate" default=""> 
        <cfquery name="GET_WORKTIME_FLEXIBLE_LIST" datasource="#dsn#">
            SELECT
                WF.*,
                PTR.STAGE,
                PW.W_ID
            FROM   
                PAGE_WARNINGS PW
                LEFT JOIN PAGE_WARNINGS_ACTIONS AS PWA ON PW.W_ID = PWA.WARNING_ID
                INNER JOIN WORKTIME_FLEXIBLE AS WF ON PW.ACTION_ID = WF.WORKTIME_FLEXIBLE_ID
                INNER JOIN PROCESS_TYPE_ROWS PTR  ON PTR.PROCESS_ROW_ID =  WF.STAGE_ID     
            WHERE
                PW.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
		        AND PW.ACTION_TABLE = 'WORKTIME_FLEXIBLE'
                <cfif len(arguments.employee_id)>
                    <cfif listLen( arguments.employee_id )>
                        AND EMPLOYEE_ID IN(#arguments.employee_id#)
                    <cfelse>
                        AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                    </cfif>
                </cfif>
                <cfif len(arguments.position_id)>
                    AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_id#">
                </cfif>
                <cfif len(arguments.branch_id)>
                    AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
                </cfif>  
                <cfif len(arguments.stage_id)>
                    AND PW.ACTION_STAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stage_id#">
                    AND PWA.ACTION_STAGE_ID IS NULL
                </cfif>
                <cfif len(arguments.process_status) and (arguments.process_status eq 1 OR arguments.process_status eq 0)>
                    AND IS_APPROVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_status#">
                <cfelseif len(arguments.process_status) and arguments.process_status eq 2>
                    AND IS_APPROVE IS NULL
                </cfif>
                <cfif len(arguments.startdate)>
                    AND REQUEST_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#">
                </cfif>
                 <cfif len(arguments.finishdate)>
                    AND REQUEST_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">
                </cfif>
            </cfquery>
        <cfreturn GET_WORKTIME_FLEXIBLE_LIST>
    </cffunction>
	<cffunction name="GET_WORKTIME_FLEXIBLE_LIST_HR" access="public"  returntype="any">
        <cfargument name="startrow" default="1">
        <cfargument name="maxrows" default="20">
        <cfargument name="flexible_id" default=""> 
        <cfargument name="employee_id" default=""> 
        <cfargument name="position_id" default=""> 
        <cfargument name="department_id" default=""> 
        <cfargument name="branch_id" default=""> 
        <cfargument name="stage_id" default=""> 
        <cfargument name="process_status" default=""> 
        <cfargument name="startdate" default=""> 
        <cfargument name="finishdate" default=""> 
        <cfargument name="group_paper_no" default="">
        <cfquery name="GET_WORKTIME_FLEXIBLE_LIST_HR" datasource="#dsn#">
			SELECT
                WF.*,
                PTR.STAGE,
                D.HIERARCHY_DEP_ID AS HIERARCHY_DEP_ID1,
                CASE 
                    WHEN E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE START_DATE <= GETDATE() AND (FINISH_DATE >= GETDATE() OR FINISH_DATE IS NULL))
                THEN	
                    D.HIERARCHY_DEP_ID
                ELSE 
                    CASE WHEN 
                        D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID))
                    THEN
                        (SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D.DEPARTMENT_ID AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC)
                    ELSE
                        D.HIERARCHY_DEP_ID
                    END
                END AS HIERARCHY_DEP_ID
            FROM   
                WORKTIME_FLEXIBLE WF
                    INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = WF.EMPLOYEE_ID
                    INNER JOIN DEPARTMENT D ON D.DEPARTMENT_ID = WF.DEPARTMENT_ID
                    LEFT JOIN PROCESS_TYPE_ROWS PTR  ON PTR.PROCESS_ROW_ID =  WF.STAGE_ID     
            WHERE
                1 = 1
                <cfif len(arguments.employee_id)>
                    <cfif listLen( arguments.employee_id )>
                        AND WF.EMPLOYEE_ID IN(#arguments.employee_id#)
                    <cfelse>
                        AND WF.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                    </cfif>
                </cfif>
                <cfif len(arguments.position_id)>
                    AND WF.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_id#">
                </cfif>
                <cfif len(arguments.branch_id)>
                    AND WF.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
                </cfif>  
                <cfif len(arguments.stage_id)>
                    AND WF.STAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stage_id#">
                </cfif>
                <cfif len(arguments.process_status) and (arguments.process_status eq 1 OR arguments.process_status eq 0)>
                    AND WF.IS_APPROVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_status#">
                <cfelseif len(arguments.process_status) and arguments.process_status eq 2>
                    AND WF.IS_APPROVE IS NULL
                </cfif>
                <cfif len(arguments.startdate)>
                    AND WF.REQUEST_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#">
                </cfif>
                <cfif len(arguments.finishdate)>
                    AND WF.REQUEST_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">
                </cfif>
                <cfif len(arguments.group_paper_no)>
                    AND WF.WORKTIME_FLEXIBLE_ID IN (SELECT * FROM #dsn#.fnSplit((SELECT TOP 1 ACTION_LIST_ID FROM #dsn#.GENERAL_PAPER WHERE GENERAL_PAPER_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.group_paper_no#"> AND STAGE_ID = WF.STAGE_ID), ','))
                </cfif>
                <cfif not session.ep.ehesap>
                    AND WF.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
                </cfif>
            </cfquery>
        <cfreturn GET_WORKTIME_FLEXIBLE_LIST_HR>
    </cffunction>
    <cffunction name="APPROVE_FLEXIBLE" access="public" returnFormat="json" returntype="any">
        <cfargument name = "valid_type">
        <cfargument name = "approve_id">
		<cfquery name="APPROVE_FLEXIBLE" datasource="#dsn#" result="MAX_ID">
            UPDATE
                WORKTIME_FLEXIBLE_ROW
            SET
                IS_APPROVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.valid_type#">,
                APPROVE_HR_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            WHERE
                WORKTIME_FLEXIBLE_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.approve_id#">
		</cfquery>
		<cfreturn 1>
	</cffunction>
    <cffunction name="GET_EMLOYEE_BRANCH_DEPARTMENT_FROM_IS_MASTER" access="remote"  returntype="any"><!---Master branhındaki çalışanın departman ve şubesi --->
        <cfargument name="employee_id" default=""> 
        <cfquery name="GET_EMLOYEE_BRANCH_DEPARTMENT_FROM_IS_MASTER" datasource="#dsn#">
            SELECT
                D.DEPARTMENT_ID,
                B.BRANCH_ID,
				B.COMPANY_ID
            FROM
                EMPLOYEE_POSITIONS EP
                LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
            WHERE
                EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                AND EP.IS_MASTER = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        </cfquery>
        <cfreturn GET_EMLOYEE_BRANCH_DEPARTMENT_FROM_IS_MASTER>
    </cffunction>
    <cffunction name="DEL_FLEXIBLE" access="remote"  returntype="any">
        <cfargument name="worktime_flexible_id" default=""> 
       <cfquery name="DEL_FLEXIBLE" datasource="#dsn#">
                DELETE FROM WORKTIME_FLEXIBLE WHERE WORKTIME_FLEXIBLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.worktime_flexible_id#">
        </cfquery>
        <cfreturn 1>
    </cffunction>
    <!--- Esnek Çalışma Tarih Kontrolleri---->
    <cffunction name="GET_WORKTIME_FLEXIBLE_ROW_DATE_CONTROL" access="remote"  returntype="any">
        <cfargument name="employee_id" default=""> 
        <cfargument name="startdate" default=""> 
        <cfif dayOfWeek(arguments.startdate) eq 1>
            <cfset day_number = 7>
        <cfelse>
            <cfset day_number = dayOfWeek(arguments.startdate) - 1>
        </cfif>
        <cfquery name="GET_WORKTIME_FLEXIBLE_ROW_DATE_CONTROL" datasource="#dsn#">
            SELECT
                WFR.FLEXIBLE_DATE,
                WFR.FLEXIBLE_YEAR,
                WFR.FLEXIBLE_MONTH,
                WFR.FLEXIBLE_DAY,
                WFR.FLEXIBLE_START_HOUR,
                WFR.FLEXIBLE_START_MINUTE,
                WFR.FLEXIBLE_FINISH_HOUR,
                WFR.FLEXIBLE_FINISH_MINUTE
            FROM
                WORKTIME_FLEXIBLE WF
                LEFT JOIN WORKTIME_FLEXIBLE_ROW WFR ON WF.WORKTIME_FLEXIBLE_ID = WFR.WORKTIME_FLEXIBLE_ID
            WHERE
                WF.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EMPLOYEE_ID#">
                AND WFR.IS_APPROVE = 1
                <cfif len(arguments.startdate)>
                    AND
                    (
                        (
                            YEAR(WFR.FLEXIBLE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(arguments.startdate)#"> AND
                            MONTH(WFR.FLEXIBLE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#month(arguments.startdate)#"> AND
                            DAY(WFR.FLEXIBLE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#day(arguments.startdate)#">
                        )
                        OR
                        (
                            WFR.FLEXIBLE_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(arguments.startdate)#"> AND
                            WFR.FLEXIBLE_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#month(arguments.startdate)#"> AND
                            WFR.FLEXIBLE_DAY = <cfqueryparam cfsqltype="cf_sql_integer" value="#day_number#">
                        )
                    )
                </cfif>
        </cfquery>
        <cfreturn GET_WORKTIME_FLEXIBLE_ROW_DATE_CONTROL>
    </cffunction>
</cfcomponent>