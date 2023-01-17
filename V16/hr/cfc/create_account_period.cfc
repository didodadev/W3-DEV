<cfcomponent>
<cfset dsn = application.systemParam.systemParam().dsn>
<cffunction name="get_comp_period" access="public" returntype="query">
    <cfargument name="period_id" default="">
    <cfquery name="get_periods" datasource="#this.dsn#">
        SELECT 
            PERIOD_ID,
            PERIOD,
            PERIOD_YEAR 
        FROM 
            SETUP_PERIOD 
        <cfif isdefined('arguments.period_id') and len(arguments.period_id)> 
		WHERE
        	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
        </cfif>
        ORDER BY 
            PERIOD_YEAR        
     </cfquery>
<cfreturn get_periods>
</cffunction>
<cffunction name="get_acc_type" access="public" returntype="query">
    <cfquery name="get_acc" datasource="#this.dsn#">
        SELECT 
        	ACC_TYPE_ID,
            ACC_TYPE_NAME 
        FROM 
        	SETUP_ACC_TYPE 
        ORDER BY 
        	ACC_TYPE_ID DESC     
    </cfquery>
<cfreturn get_acc>
</cffunction>
<cffunction name="get_account_definition" access="public" returntype="query">
	<cfargument name="period_id" required="yes" type="numeric">
	<cfargument name="branch_id" default="">
	<cfargument name="department_id" default="">
    <cfquery name="get_definition" datasource="#this.dsn#">
        SELECT 
            ID,
            PERIOD_ID,
            ACCOUNT_BILL_TYPE,
            ACCOUNT_CODE,
            EXPENSE_CODE,
            EXPENSE_ITEM_ID,
            ACCOUNT_NAME,
            EXPENSE_CODE_NAME,
            EXPENSE_ITEM_NAME,
            RECORD_PERIOD_ID,
            PERIOD_YEAR,
            PERIOD_COMPANY_ID,
            EXPENSE_CENTER_ID,
            RECORD_EMP,
            RECORD_DATE,
            UPDATE_EMP,
            UPDATE_DATE
        FROM 
            SETUP_ACCOUNT_DEFINITION
        WHERE
        	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
            <cfif isdefined('arguments.branch_id') and len(arguments.branch_id)>
				AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
            </cfif>
            <cfif isdefined('arguments.department_id') and len(arguments.department_id)>
				AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
            <cfelse>
                AND DEPARTMENT_ID IS NULL
            </cfif>
    </cfquery>
    <cfreturn get_definition>
</cffunction>
<cffunction name="get_account_definiton_code_row" access="public" returntype="query">
    <cfargument name="account_definition_id" default="" required="yes" type="numeric">
	<cfquery name="get_acc_code_def_row" datasource="#this.dsn#">
		SELECT
        	DEF_ROW.ACCOUNT_BILL_TYPE,
            ACC_DEF.DEFINITION
        FROM
        	SETUP_ACCOUNT_DEFINITION_CODE_ROW DEF_ROW INNER JOIN SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF ACC_DEF
            ON DEF_ROW.ACCOUNT_BILL_TYPE = ACC_DEF.PAYROLL_ID
        WHERE
        	DEF_ROW.SETUP_ACCOUNT_DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.account_definition_id#">
    </cfquery>
     <cfreturn get_acc_code_def_row>
</cffunction>
<cffunction name="get_account_expense" access="public" returntype="query">
    <cfargument name="period_id" default="" required="yes" type="numeric">
    <cfargument name="branch_id" default="">
    <cfargument name="department_id" default="">
    <cfif application.systemParam.systemParam().fusebox.use_period eq true>
			<cfset dsn2 = "#this.dsn2_alias#">
		<cfelse>
			<cfset dsn2 = "#dsn#">
		</cfif>
    <cfquery name="get_expense" datasource="#this.dsn#">
		SELECT 
        	PR.EXPENSE_CENTER_ID,
            PR.RATE,
            EC.EXPENSE
         FROM 
         	SETUP_ACCOUNT_EXPENSE PR INNER JOIN #dsn2#.EXPENSE_CENTER EC
            ON EC.EXPENSE_ID = PR.EXPENSE_CENTER_ID
         WHERE 
            PR.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
            <cfif isdefined('arguments.branch_id') and len(arguments.branch_id)>
				AND PR.BRANCH_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
            </cfif>
            <cfif isdefined('arguments.department_id') and len(arguments.department_id)>
				AND PR.DEPARTMENT_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
            <cfelse>
                AND PR.DEPARTMENT_ID IS NULL
            </cfif>
    </cfquery>
    <cfreturn get_expense>
</cffunction>
<cffunction name="get_account_code_definition" access="public" returntype="query">
    <cfargument name="period_id" default="" required="yes" type="numeric">
	<cfargument name="branch_id" default="">
	<cfargument name="department_id" default="">
    <cfquery name="get_code_definition" datasource="#this.dsn#">
		SELECT 
        	CD.ACC_TYPE_ID,
            CD.ACCOUNT_CODE
         FROM 
         	SETUP_ACCOUNT_CODE_DEFINITION CD
         WHERE 
            CD.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#"> AND
            CD.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
            <cfif isdefined('arguments.department_id') and len(arguments.department_id)>
				AND CD.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
            <cfelse>
            	AND CD.DEPARTMENT_ID IS NULL
            </cfif>
    </cfquery>
    <cfreturn get_code_definition>
</cffunction>
</cfcomponent>
