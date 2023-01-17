<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3="#dsn#_#session.ep.company_id#">

    <cffunction name="GET_EXPENSE_COST" access="public" returntype="any">
        <cfargument name="action_id" default="">
        <cfargument name="action_table" default="">
        <cfargument name="is_income" default="">
        <cfargument name="exp_action_type" default="">

        <cfquery name="GET_EXPENSE_COST" datasource="#dsn2#">
            SELECT 
                EIR.*,
                EC.EXPENSE AS EXPENSE_CENTER_NAME,
                EI.EXPENSE_ITEM_NAME
            FROM 
                EXPENSE_ITEMS_ROWS EIR
                LEFT JOIN EXPENSE_CENTER EC ON EC.EXPENSE_ID = EIR.EXPENSE_CENTER_ID
                LEFT JOIN EXPENSE_ITEMS EI ON EI.EXPENSE_ITEM_ID = EIR.EXPENSE_ITEM_ID
            WHERE 
                1 = 1
                <cfif len(arguments.action_id)>
                    AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                </cfif>
                <cfif len(arguments.action_table)>
                    AND ACTION_TABLE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.action_table#">
                </cfif>
                <cfif len(arguments.is_income)>
                    AND IS_INCOME = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_income#">
                </cfif>
                <cfif len(arguments.exp_action_type)>
                    AND EXPENSE_COST_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.exp_action_type#"> 
                </cfif>
        </cfquery>

        <cfreturn GET_EXPENSE_COST>
    </cffunction>
</cfcomponent>