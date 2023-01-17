<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3="#dsn#_#session.ep.company_id#">
	<cfset dsn3_alias=dsn3>
    <cffunction name="get_budget_plan" access="public">
        <cfargument name="budget_plan_id" default="">
        <cfquery name="get_budget_plan" datasource="#dsn#">
            SELECT
                BP.BUDGET_PLAN_ID,
                BP.BUDGET_ID,
                BP.PROCESS_STAGE,
                BP.PROCESS_TYPE,
                BP.PROCESS_CAT,
                BP.PAPER_NO,
                BP.BUDGET_PLAN_DATE,
                BP.BUDGET_PLANNER_EMP_ID,
                BP.DETAIL,
                BP.INCOME_TOTAL,
                BP.EXPENSE_TOTAL,
                BP.DIFF_TOTAL,
                BP.OTHER_INCOME_TOTAL,
                BP.OTHER_EXPENSE_TOTAL,
                BP.OTHER_DIFF_TOTAL,
                BP.OTHER_MONEY,
                BP.IS_SCENARIO,
                BP.RECORD_EMP,
                BP.RECORD_DATE,
                BP.UPDATE_EMP,
                BP.UPDATE_DATE,
                BP.ACC_DEPARTMENT_ID,
                BP.BRANCH_ID,
                BP.PERIOD_ID,
                BP.OUR_COMPANY_ID,
                BP.UPD_STATUS,
                BP.DOCUMENT_TYPE,
                BP.PAYMENT_METHOD,
                BP.DUE_DATE,
                I.INVOICE_ID,
                I.INVOICE_NUMBER
            FROM
                BUDGET_PLAN BP
                    LEFT JOIN #dsn2#.INVOICE I ON I.INVOICE_ID = BP.INVOICE_ID
            WHERE
                BP.BUDGET_PLAN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.budget_plan_id#">
        </cfquery>
        <cfreturn get_budget_plan>
    </cffunction>
    <cffunction name="get_branches" access="public">
        <cfquery name="get_branches" datasource="#dsn#">
            SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_STATUS = 1 AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> ORDER BY BRANCH_NAME
        </cfquery>
        <cfreturn get_branches>
    </cffunction>
    <cffunction name="GET_DEPARTMENT" access="public">
        <cfquery name="GET_DEPARTMENT" datasource="#dsn#">
            SELECT
                DEPARTMENT_HEAD,
                DEPARTMENT_ID,
                BRANCH_ID,
                (SELECT BRANCH_NAME FROM BRANCH WHERE DEPARTMENT_ID = BRANCH_ID)
            FROM
                DEPARTMENT
            WHERE
                DEPARTMENT_STATUS = 1
                AND BRANCH_ID IN(SELECT BRANCH_ID FROM BRANCH WHERE COMPANY_ID=#session.ep.company_id#)
            ORDER BY
                DEPARTMENT_HEAD
        </cfquery>
        <cfreturn GET_DEPARTMENT>
    </cffunction>
    <cffunction name="get_company_period_control" access="public">
        <cfargument name="budget_plan_id" default="">
        <cfquery name="get_company_period_control" datasource="#dsn#">
            SELECT PERIOD_ID,OUR_COMPANY_ID FROM BUDGET_PLAN WHERE BUDGET_PLAN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.budget_plan_id#">
        </cfquery>
        <cfreturn get_company_period_control>
    </cffunction>
    <cffunction name="get_budget_plan_row" access="public">
        <cfargument name="budget_plan_id" default="">
        <cfquery name="get_budget_plan_row" datasource="#dsn#">
            SELECT
                BUDGET_PLAN_ROW_ID,
                BUDGET_PLAN_ID,
                PLAN_DATE,
                DETAIL,
                EXP_INC_CENTER_ID,
                BUDGET_ITEM_ID,
                BUDGET_ACCOUNT_CODE,
                ACTIVITY_TYPE_ID,
                RELATED_EMP_ID,
                RELATED_EMP_TYPE,
                RELATED_ACCOUNT_CODE,
                ROW_TOTAL_INCOME,
                ROW_TOTAL_EXPENSE,
                ROW_TOTAL_DIFF,
                OTHER_ROW_TOTAL_INCOME,
                OTHER_ROW_TOTAL_EXPENSE,
                OTHER_ROW_TOTAL_DIFF,
                IS_PAYMENT,
                WORKGROUP_ID,
                PROJECT_ID,
                ACC_TYPE_ID,
                ASSETP_ID
            FROM
                BUDGET_PLAN_ROW
            WHERE
                BUDGET_PLAN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.budget_plan_id#">
            ORDER BY
                BUDGET_PLAN_ROW_ID
        </cfquery>
        <cfreturn get_budget_plan_row>
    </cffunction>
    <cffunction name="get_budget_plan_money" access="public">
        <cfargument name="budget_plan_id" default="">
        <cfquery name="get_budget_plan_money" datasource="#dsn#">
            SELECT MONEY_TYPE AS MONEY,* FROM BUDGET_PLAN_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.budget_plan_id#">
        </cfquery>
        <cfif not get_budget_plan_money.recordcount>
            <cfquery name="get_budget_plan_money" datasource="#dsn2#">
                SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY ORDER BY MONEY_ID
            </cfquery>
        </cfif>
        <cfreturn get_budget_plan_money>
    </cffunction>
    <cffunction name="get_expense_center" access="public">
        <cfquery name="get_expense_center" datasource="#dsn2#">
            SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
        </cfquery>
        <cfreturn get_expense_center>
    </cffunction>
    <cffunction name="get_activity_types" access="public">
        <cfquery name="get_activity_types" datasource="#dsn#">
            SELECT ACTIVITY_ID,ACTIVITY_NAME FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
        </cfquery>
        <cfreturn get_activity_types>
    </cffunction>
    <cffunction name="get_workgroups" access="public">
        <cfquery name="get_workgroups" datasource="#dsn#">
            SELECT WORKGROUP_ID,WORKGROUP_NAME FROM WORK_GROUP WHERE STATUS = 1 AND IS_BUDGET = 1 ORDER BY HIERARCHY
        </cfquery>
        <cfreturn get_workgroups>
    </cffunction>
</cfcomponent>