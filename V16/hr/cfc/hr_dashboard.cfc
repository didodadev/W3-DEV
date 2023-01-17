<!---
    File: V16/hr/cfc/hr_dashboard.cfc
    Author: Workcube-Botan Kaygan <botankaygan@workcube.com>
    Date: 06.07.2020
    Controller: -
    Description: İK Dashboard component
--->

<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">

    <cffunction name="COUNT_DEPT_GROUP_BRANCHES" access="remote" returntype="any">
        <cfargument name="branch_id_list" default="">
        <cfquery name="COUNT_DEPT_GROUP_BRANCHES" datasource="#dsn#">
            SELECT
                B.BRANCH_ID,
                B.BRANCH_NAME,
                COUNT(D.DEPARTMENT_ID) AS COUNT_DEPT
            FROM
                BRANCH B 
                LEFT JOIN DEPARTMENT D ON B.BRANCH_ID = D.BRANCH_ID
            WHERE
                1 = 1
                <cfif len(arguments.branch_id_list)>
                    AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id_list#" list="true">)
                </cfif>
            GROUP BY
                B.BRANCH_ID,
                B.BRANCH_NAME
            ORDER BY
                B.BRANCH_ID
        </cfquery>
        <cfreturn COUNT_DEPT_GROUP_BRANCHES>
    </cffunction>
    <cffunction name="COUNT_EMP_GROUP_DEPT_BRANCHES" access="remote" returntype="any">
        <cfquery name="COUNT_EMP_GROUP_DEPT_BRANCHES" datasource="#dsn#">
            SELECT
                B.BRANCH_ID,
                B.BRANCH_NAME,
                COUNT(EP.POSITION_ID) AS COUNT_EMP
            FROM
                BRANCH B 
                LEFT JOIN DEPARTMENT D ON B.BRANCH_ID = D.BRANCH_ID
                LEFT JOIN EMPLOYEE_POSITIONS EP ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
            WHERE
                EP.IS_MASTER = 1 
                AND EP.POSITION_STATUS = 1
            GROUP BY
                B.BRANCH_ID,
                B.BRANCH_NAME
            ORDER BY
                B.BRANCH_ID
        </cfquery>
        <cfreturn COUNT_EMP_GROUP_DEPT_BRANCHES>
    </cffunction>
    <cffunction name="GET_PERIOD_YEARS" access="remote" returntype="any">
        <cfargument name="company_id" default="">
        <cfquery name="GET_PERIOD_YEARS" datasource="#dsn#">
            SELECT
                PERIOD_YEAR
            FROM
                SETUP_PERIOD
            WHERE
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>
        <cfreturn GET_PERIOD_YEARS>
    </cffunction>
    <cffunction name="GET_YEAR_SALARY" access="remote" returntype="any">
        <cfargument name="active_year" default="">
        <cfquery name="GET_YEAR_SALARY" datasource="#dsn#">
            WITH t1 AS(
                SELECT
                    B.BRANCH_ID,
                    B.BRANCH_NAME,
                    SUM(ISNULL(M1,0)) AS MAAS,
                    0 ODENEK,
                    0 KESINTI
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                    LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    B.BRANCH_ID,
                    B.BRANCH_NAME
                UNION ALL
                SELECT
                    B.BRANCH_ID,
                    B.BRANCH_NAME,
                    SUM(ISNULL(M2,0)) AS MAAS,
                    0 ODENEK,
                    0 KESINTI
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                    LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    B.BRANCH_ID,
                    B.BRANCH_NAME
                UNION ALL
                SELECT
                    B.BRANCH_ID,
                    B.BRANCH_NAME,
                    SUM(ISNULL(M3,0)) AS MAAS,
                    0 ODENEK,
                    0 KESINTI
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                    LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    B.BRANCH_ID,
                    B.BRANCH_NAME
                UNION ALL
                SELECT
                    B.BRANCH_ID,
                    B.BRANCH_NAME,
                    SUM(ISNULL(M4,0)) AS MAAS,
                    0 ODENEK,
                    0 KESINTI
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                    LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    B.BRANCH_ID,
                    B.BRANCH_NAME
                UNION ALL
                SELECT
                    B.BRANCH_ID,
                    B.BRANCH_NAME,
                    SUM(ISNULL(M5,0)) AS MAAS,
                    0 ODENEK,
                    0 KESINTI
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                    LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    B.BRANCH_ID,
                    B.BRANCH_NAME
                UNION ALL
                SELECT
                    B.BRANCH_ID,
                    B.BRANCH_NAME,
                    SUM(ISNULL(M6,0)) AS MAAS,
                    0 ODENEK,
                    0 KESINTI
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                    LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    B.BRANCH_ID,
                    B.BRANCH_NAME
                UNION ALL
                SELECT
                    B.BRANCH_ID,
                    B.BRANCH_NAME,
                    SUM(ISNULL(M7,0)) AS MAAS,
                    0 ODENEK,
                    0 KESINTI
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                    LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    B.BRANCH_ID,
                    B.BRANCH_NAME
                UNION ALL
                SELECT
                    B.BRANCH_ID,
                    B.BRANCH_NAME,
                    SUM(ISNULL(M8,0)) AS MAAS,
                    0 ODENEK,
                    0 KESINTI
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                    LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    B.BRANCH_ID,
                    B.BRANCH_NAME
                UNION ALL
                SELECT
                    B.BRANCH_ID,
                    B.BRANCH_NAME,
                    SUM(ISNULL(M9,0)) AS MAAS,
                    0 ODENEK,
                    0 KESINTI
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                    LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    B.BRANCH_ID,
                    B.BRANCH_NAME
                UNION ALL
                SELECT
                    B.BRANCH_ID,
                    B.BRANCH_NAME,
                    SUM(ISNULL(M10,0)) AS MAAS,
                    0 ODENEK,
                    0 KESINTI
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                    LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    B.BRANCH_ID,
                    B.BRANCH_NAME
                UNION ALL
                SELECT
                    B.BRANCH_ID,
                    B.BRANCH_NAME,
                    SUM(ISNULL(M11,0)) AS MAAS,
                    0 ODENEK,
                    0 KESINTI
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                    LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    B.BRANCH_ID,
                    B.BRANCH_NAME
                UNION ALL
                SELECT
                    B.BRANCH_ID,
                    B.BRANCH_NAME,
                    SUM(ISNULL(M12,0)) AS MAAS,
                    0 ODENEK,
                    0 KESINTI
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                    LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    B.BRANCH_ID,
                    B.BRANCH_NAME
                UNION ALL
                SELECT
                    B.BRANCH_ID,
                    B.BRANCH_NAME,
                    0 MAAS,
                    SUM(ISNULL(SP.AMOUNT_PAY,0)) AS ODENEK,
                    0 KESINTI
                FROM
                    SALARYPARAM_PAY SP
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = SP.EMPLOYEE_ID
                    LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                    LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
                WHERE
                    SP.TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    B.BRANCH_ID,
                    B.BRANCH_NAME
                UNION ALL
                SELECT
                    B.BRANCH_ID,
                    B.BRANCH_NAME,
                    0 MAAS,
                    0 ODENEK,
                    SUM(ISNULL(SPG.AMOUNT_GET,0)) AS KESINTI
                FROM
                    SALARYPARAM_GET SPG
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = SPG.EMPLOYEE_ID
                    LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                    LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
                WHERE
                    SPG.TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    B.BRANCH_ID,
                    B.BRANCH_NAME
            )
            SELECT
                BRANCH_ID,
                BRANCH_NAME,
                SUM(MAAS) AS MAAS,
                SUM(ODENEK) AS ODENEK,
                SUM(KESINTI) AS KESINTI
            FROM
                t1
            GROUP BY
                BRANCH_ID,
                BRANCH_NAME
        </cfquery>
        <cfreturn GET_YEAR_SALARY>
    </cffunction>
    <cffunction name="GET_POSITIONS_SALARY" access="remote" returntype="any">
        <cfargument name="active_year" default="">
        <cfquery name="GET_POSITIONS_SALARY" datasource="#dsn#">
            WITH t1 AS(
                SELECT
                    SPC.POSITION_CAT,
                    SUM(ISNULL(M1,0)) AS MAAS
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    SPC.POSITION_CAT
                UNION ALL
                SELECT
                    SPC.POSITION_CAT,
                    SUM(ISNULL(M2,0)) AS MAAS
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    SPC.POSITION_CAT
                UNION ALL
                SELECT
                    SPC.POSITION_CAT,
                    SUM(ISNULL(M3,0)) AS MAAS
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    SPC.POSITION_CAT
                UNION ALL
                SELECT
                    SPC.POSITION_CAT,
                    SUM(ISNULL(M4,0)) AS MAAS
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    SPC.POSITION_CAT
                UNION ALL
                SELECT
                    SPC.POSITION_CAT,
                    SUM(ISNULL(M5,0)) AS MAAS
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    SPC.POSITION_CAT
                UNION ALL
                SELECT
                    SPC.POSITION_CAT,
                    SUM(ISNULL(M6,0)) AS MAAS
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    SPC.POSITION_CAT
                UNION ALL
                SELECT
                    SPC.POSITION_CAT,
                    SUM(ISNULL(M7,0)) AS MAAS
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    SPC.POSITION_CAT
                UNION ALL
                SELECT
                    SPC.POSITION_CAT,
                    SUM(ISNULL(M8,0)) AS MAAS
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    SPC.POSITION_CAT
                UNION ALL
                SELECT
                    SPC.POSITION_CAT,
                    SUM(ISNULL(M9,0)) AS MAAS
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    SPC.POSITION_CAT
                UNION ALL
                SELECT
                    SPC.POSITION_CAT,
                    SUM(ISNULL(M10,0)) AS MAAS
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    SPC.POSITION_CAT
                UNION ALL
                SELECT
                    SPC.POSITION_CAT,
                    SUM(ISNULL(M11,0)) AS MAAS
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    SPC.POSITION_CAT
                UNION ALL
                SELECT
                    SPC.POSITION_CAT,
                    SUM(ISNULL(M12,0)) AS MAAS
                FROM
                    EMPLOYEES_SALARY ES
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ES.EMPLOYEE_ID
                    LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
                WHERE
                    ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    AND EP.IS_MASTER = 1
                    AND EP.POSITION_STATUS = 1
                GROUP BY
                    SPC.POSITION_CAT
            )
            SELECT
                POSITION_CAT,
                SUM(MAAS) AS MAAS
            FROM
                t1
            GROUP BY
                POSITION_CAT
        </cfquery>
        <cfreturn GET_POSITIONS_SALARY>
    </cffunction>
    <cffunction name="GET_USE_OFFTIME" access="remote" returntype="any">
        <cfargument name="active_year" default="">
        <cfquery name="GET_USE_OFFTIME" datasource="#dsn#">
            SELECT
                SO.OFFTIMECAT,
                COUNT(O.OFFTIME_ID) AS COUNT_OFFTIME
            FROM
                OFFTIME O
                INNER JOIN SETUP_OFFTIME SO ON SO.OFFTIMECAT_ID = O.OFFTIMECAT_ID
            WHERE
                O.VALID IS NOT NULL AND O.VALID = 1
                <cfif len(arguments.active_year)>
                    AND (
                        YEAR(O.STARTDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#active_year#">
                        OR
                        YEAR(O.FINISHDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#active_year#">
                    )
                </cfif>
            GROUP BY
                SO.OFFTIMECAT
        </cfquery>
        <cfreturn GET_USE_OFFTIME>
    </cffunction>
    <cffunction name="GET_EXT_WORKTIME" access="remote" returntype="any">
        <cfargument name="active_year" default="">
        <cfquery name="GET_EXT_WORKTIME" datasource="#dsn#">
            SELECT
                DAY_TYPE,
                SUM(DATEDIFF(minute,START_TIME,END_TIME)) AS TOTAL_MINUTE
            FROM
                EMPLOYEES_EXT_WORKTIMES
            WHERE
                VALID IS NOT NULL AND VALID = 1
                <cfif len(arguments.active_year)>
                    AND (
                        YEAR(START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#active_year#">
                        OR
                        YEAR(END_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#active_year#">
                    )
                </cfif>
            GROUP BY
                DAY_TYPE
            ORDER BY
                DAY_TYPE
        </cfquery>
        <cfreturn GET_EXT_WORKTIME>
    </cffunction>
    <cffunction name="GET_PAYMENTS" access="remote" returntype="any">
        <cfargument name="active_year" default="">
        <cfquery name="GET_PAYMENTS" datasource="#dsn#">
            SELECT
                SPI.COMMENT_PAY,
                SUM(ISNULL(SP.AMOUNT_PAY,0)) AS ODENEK
            FROM
                SALARYPARAM_PAY SP
                LEFT JOIN SETUP_PAYMENT_INTERRUPTION SPI ON SPI.ODKES_ID = SP.COMMENT_PAY_ID
            WHERE
                SP.TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
            GROUP BY
                SPI.COMMENT_PAY
        </cfquery>
        <cfreturn GET_PAYMENTS>
    </cffunction>
</cfcomponent>