<!---
    File: project_accounts_graph_report.cfc
    Author: Melek KOCABEY <melekkocabey@workcube.com>
    Date: 22.07.2021
    Description: Proje İcmal Raporu Tahsiat-Ödeme Box'ı fonk.
        
    History:
        
    To Do:

--->
 
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn_alias = application.systemParam.systemParam().dsn>
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>

    <cffunction name="get_project_accounts" access="public" returntype="any">
        <cfparam name="project_id" default="">
        <cfparam name="codes" default="">
        <cfparam name="type" default="">
        <cfparam name="dsn2" default="">
        <cfparam name="start_date" default="">
        <cfparam name="finish_date" default="">
        <cfparam name="alacakli_project" default="">
        
        <cfquery name="get_project_accounts" datasource="#arguments.dsn2#">
            SELECT
                TYPE,
				ISNULL(SUM(TOTAL_VALUE),0) TOTAL_VALUE,
				ACTION_CURRENCY_ID
			FROM
            (
                    SELECT 
                        1 TYPE,
                        ISNULL(SUM(ACTION_VALUE),0) TOTAL_VALUE,
                        ACTION_CURRENCY_ID 
                    FROM 
                        BANK_ACTIONS 
                    WHERE 
                        PROJECT_ID IN (<cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer" list="yes">)
                        <cfif isdefined('arguments.from_to_id') and len(arguments.from_to_id) and arguments.from_to_id eq 1>
                            AND (ACTION_FROM_ACCOUNT_ID IS NOT NULL OR ACTION_FROM_COMPANY_ID IS NOT NULL OR ACTION_FROM_EMPLOYEE_ID IS NOT NULL OR ACTION_FROM_CONSUMER_ID IS NOT NULL OR ACTION_FROM_CASH_ID IS NOT NULL)
                        <cfelseif isdefined('arguments.from_to_id') and len(arguments.from_to_id) and arguments.from_to_id eq 0>
                            AND (ACTION_TO_ACCOUNT_ID IS NOT NULL OR ACTION_TO_COMPANY_ID IS NOT NULL OR ACTION_TO_EMPLOYEE_ID IS NOT NULL OR ACTION_TO_CONSUMER_ID IS NOT NULL OR ACTION_TO_CASH_ID IS NOT NULL)
                        </cfif>
                        <cfif isdefined('arguments.codes') and len(arguments.codes)> AND ACTION_TYPE_ID IN (<cfqueryparam value="#arguments.codes#" CFSQLType = "cf_sql_nvarchar" list="yes">)</cfif>
                        <cfif isdefined('arguments.start_date') and len(arguments.start_date)>
                            AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                        </cfif>
                        <cfif isdefined('arguments.finish_date') and len(arguments.finish_date)>
                            AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                        </cfif>
                    GROUP BY
                        ACTION_CURRENCY_ID
                UNION ALL
                    SELECT 
                        2 TYPE,
                        ISNULL(SUM(ACTION_VALUE),0) TOTAL_VALUE,
                        ISNULL(ACTION_CURRENCY_ID,CASH_ACTION_CURRENCY_ID) AS ACTION_CURRENCY_ID
                    FROM 
                        CASH_ACTIONS 
                    WHERE 
                        PROJECT_ID IN (<cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer" list="yes">)
                        <cfif isdefined('arguments.from_to_id') and len(arguments.from_to_id) and arguments.from_to_id eq 1>
                            AND (CASH_ACTION_FROM_CASH_ID IS NOT NULL OR CASH_ACTION_FROM_COMPANY_ID IS NOT NULL OR CASH_ACTION_FROM_EMPLOYEE_ID IS NOT NULL OR CASH_ACTION_FROM_CONSUMER_ID IS NOT NULL OR CASH_ACTION_FROM_CASH_ID IS NOT NULL)
                        <cfelseif isdefined('arguments.from_to_id') and len(arguments.from_to_id) and arguments.from_to_id eq 0>
                            AND (CASH_ACTION_TO_CASH_ID IS NOT NULL OR CASH_ACTION_TO_COMPANY_ID IS NOT NULL OR CASH_ACTION_TO_EMPLOYEE_ID IS NOT NULL OR CASH_ACTION_TO_CONSUMER_ID IS NOT NULL OR CASH_ACTION_TO_CASH_ID IS NOT NULL)
                        </cfif>
                        <cfif isdefined('arguments.codes') and len(arguments.codes)>AND ACTION_TYPE_ID IN (<cfqueryparam value="#arguments.codes#" CFSQLType = "cf_sql_nvarchar" list="yes">)</cfif>
                        <cfif isdefined('arguments.start_date') and len(arguments.start_date)>
                            AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                        </cfif>
                        <cfif isdefined('arguments.finish_date') and len(arguments.finish_date)>
                            AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                        </cfif>
                    GROUP BY
                        ISNULL(ACTION_CURRENCY_ID,CASH_ACTION_CURRENCY_ID)
                UNION ALL
                    SELECT
                        3 TYPE, 
                        ISNULL(SUM(ACTION_VALUE),0) TOTAL_VALUE,
                        ACTION_CURRENCY_ID 
                    FROM 
                        CARI_ACTIONS 
                    WHERE 
                        <cfif isdefined('arguments.codes') and len(arguments.codes)> ACTION_TYPE_ID IN (<cfqueryparam value="#arguments.codes#" CFSQLType = "cf_sql_nvarchar" list="yes">)</cfif>
                        <cfif isdefined('arguments.alacakli_project') and len(arguments.alacakli_project) and arguments.alacakli_project eq 1>
                            AND PROJECT_ID_2 IN (<cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer" list="yes">)
                        <cfelseif isdefined('arguments.alacakli_project') and len(arguments.alacakli_project) and arguments.alacakli_project eq 0>
                            AND PROJECT_ID IN (<cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer" list="yes">)
                        </cfif>                        
                        <cfif isdefined('arguments.start_date') and len(arguments.start_date)>
                            AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                        </cfif>
                        <cfif isdefined('arguments.finish_date') and len(arguments.finish_date)>
                            AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                        </cfif>
                    GROUP BY
                        ACTION_CURRENCY_ID
                UNION ALL
                    SELECT
                        4 TYPE, 
                        ISNULL(SUM(PAYROLL_TOTAL_VALUE),0) TOTAL_VALUE,
                        CURRENCY_ID ACTION_CURRENCY_ID  
                    FROM 
                        PAYROLL 
                    WHERE 
                        PROJECT_ID IN (<cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer" list="yes">)
                        <cfif isdefined('arguments.codes') and len(arguments.codes)>AND PAYROLL_TYPE IN (<cfqueryparam value="#arguments.codes#" CFSQLType = "cf_sql_nvarchar" list="yes">)</cfif>
                        <cfif isdefined('arguments.start_date') and len(arguments.start_date)>
                            AND PAYROLL_RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                        </cfif>
                        <cfif isdefined('arguments.finish_date') and len(arguments.finish_date)>
                            AND PAYROLL_RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                        </cfif>
                    GROUP BY
                    CURRENCY_ID
                UNION ALL
                    SELECT 
                        5 TYPE,
                        ISNULL(SUM(PAYROLL_TOTAL_VALUE),0) TOTAL_VALUE,
                        CURRENCY_ID ACTION_CURRENCY_ID 
                    FROM 
                        VOUCHER_PAYROLL 
                    WHERE 
                        PROJECT_ID IN (<cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer" list="yes">)
                        <cfif isdefined('arguments.codes') and len(arguments.codes)>AND PAYROLL_TYPE IN (<cfqueryparam value="#arguments.codes#" CFSQLType = "cf_sql_nvarchar" list="yes">)</cfif>
                        <cfif isdefined('arguments.start_date') and len(arguments.start_date)>
                            AND PAYROLL_REVENUE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                        </cfif>
                        <cfif isdefined('arguments.finish_date') and len(arguments.finish_date)>
                            AND PAYROLL_REVENUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                        </cfif>
                    GROUP BY
                        CURRENCY_ID
                UNION ALL
                    SELECT 
                        6 TYPE,
                        ISNULL(SUM(SALES_CREDIT),0) TOTAL_VALUE,
                        ACTION_CURRENCY_ID 
                    FROM 
                        #dsn3#.CREDIT_CARD_BANK_PAYMENTS 
                    WHERE
                        PROJECT_ID IN (<cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer" list="yes">)
                        <cfif isdefined('arguments.codes') and len(arguments.codes)>AND ACTION_TYPE_ID IN (<cfqueryparam value="#arguments.codes#" CFSQLType = "cf_sql_nvarchar" list="yes">)</cfif>
                        <cfif isdefined('arguments.start_date') and len(arguments.start_date)>
                            AND STORE_REPORT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                        </cfif>
                        <cfif isdefined('arguments.finish_date') and len(arguments.finish_date)>
                            AND STORE_REPORT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                        </cfif>
                    GROUP BY
                    ACTION_CURRENCY_ID
                UNION ALL
                    SELECT 
                        7 TYPE,
                        ISNULL(SUM(ACTION_VALUE),0) TOTAL_VALUE,
                        MONEY_CAT ACTION_CURRENCY_ID 
                    FROM 
                        #dsn#.COMPANY_SECUREFUND 
                    WHERE 
                        PROJECT_ID IN (<cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer" list="yes">)
                        <cfif isdefined('arguments.codes') and len(arguments.codes)>AND ACTION_TYPE_ID IN (<cfqueryparam value="#arguments.codes#" CFSQLType = "cf_sql_nvarchar" list="yes">)</cfif>
                        <cfif isdefined('arguments.start_date') and len(arguments.start_date)>
                            AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                        </cfif>
                        <cfif isdefined('arguments.finish_date') and len(arguments.finish_date)>
                            AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                        </cfif>
                    GROUP BY
                        MONEY_CAT
            )MAIN_QUERY
			GROUP BY
            ACTION_CURRENCY_ID,TYPE
        </cfquery>
    <cfif isdefined('arguments.type') and len(arguments.type)>
        <cfquery name="get_project_cost" dbtype="query">
            SELECT * FROM get_project_accounts WHERE TYPE = <cfqueryparam value = "#arguments.type#" CFSQLType = "cf_sql_integer">
        </cfquery>
        <cfreturn get_project_cost>
        <cfelse>
            <cfreturn get_project_accounts>
    </cfif>
        
    </cffunction>
    <cffunction  name="GET_MONEY_RATE" access="public" returntype="any">
        <cfparam name="dsn2" default="">
        <cfquery name="GET_MONEY_RATE" datasource="#arguments.dsn2#">
			SELECT
                MONEY
			FROM
				SETUP_MONEY
			WHERE
				MONEY_STATUS = <cfqueryparam value = "1" CFSQLType = "cf_sql_integer">
        </cfquery>
        <cfreturn GET_MONEY_RATE>
    </cffunction>
    <cffunction  name="get_works" access="public" returntype="any">
        <cfparam name="project_id" default="">
        <cfparam name="cat_works" default="">
        <cfparam name="stage_works" default="">
        <cfparam name="active_passive" default="">
        <cfparam name="emp_id" default="">
        <cfquery name="get_works" datasource="#dsn#">
            SELECT 
                COUNT(PW.WORK_ID) WORK_COUNT
                <cfif isdefined("arguments.cat_works") and len(arguments.cat_works)>
                    ,PWC.WORK_CAT  WORK_CAT
                <cfelseif isdefined("arguments.stage_works") and len(arguments.stage_works)>
                    ,PTR.STAGE AS STAGE
                </cfif>
            FROM 
                PRO_WORKS PW
                <cfif isdefined("arguments.cat_works") and len(arguments.cat_works)>
                    JOIN PRO_WORK_CAT AS PWC ON PW.WORK_CAT_ID = PWC.WORK_CAT_ID
                <cfelseif isdefined("arguments.stage_works") and len(arguments.stage_works)>
                    JOIN PROCESS_TYPE_ROWS AS PTR ON PW.WORK_CURRENCY_ID = PTR.PROCESS_ROW_ID
                </cfif>                
            WHERE 
                PW.PROJECT_ID IN (<cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer" list="yes">) 
                <cfif isdefined("arguments.emp_id") and len(arguments.emp_id)>
                    AND PW.PROJECT_EMP_ID = <cfqueryparam value = "#arguments.emp_id#" CFSQLType = "cf_sql_integer">
                </cfif>
                <cfif isdefined("arguments.active_passive") and len(arguments.active_passive) and arguments.active_passive eq 1>
                    AND PW.WORK_STATUS = 1
                <cfelseif isdefined("arguments.active_passive") and len(arguments.active_passive) and arguments.active_passive eq 0>
                    AND PW.WORK_STATUS = 0
                </cfif>
            GROUP BY
                <cfif isdefined("arguments.cat_works") and len(arguments.cat_works)>
                    PWC.WORK_CAT
                <cfelseif isdefined("arguments.stage_works") and len(arguments.stage_works)>
                    PTR.STAGE
                <cfelse>
                    PW.WORK_ID
                </cfif>	
        </cfquery>
        <cfreturn get_works>
    </cffunction>
</cfcomponent>