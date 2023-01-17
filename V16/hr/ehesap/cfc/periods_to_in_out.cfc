<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="setup_acc_type" access="public" returntype="query">
	<cfquery name="acc_type" datasource="#dsn#">
		SELECT    
		#dsn#.Get_Dynamic_Language(ACC_TYPE_ID,'#session.ep.language#','SETUP_ACC_TYPE','acc_type_name',NULL,NULL,acc_type_name) AS acc_type_name
		,* 
		FROM SETUP_ACC_TYPE ORDER BY ACC_TYPE_ID
	</cfquery>
	<cfreturn acc_type>
	</cffunction>
	<cffunction name="get_period_control" access="public" returntype="query">
		<cfargument name="in_out_id" type="numeric" required="yes">
		<cfargument name="period_id" type="numeric" required="yes">
		<cfquery name="get_control" datasource="#dsn#">
			SELECT
				IN_OUT_ID
			FROM
				EMPLOYEES_IN_OUT_PERIOD
			WHERE
				IN_OUT_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#"> AND
				PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
		</cfquery>
		<cfreturn get_control>
	</cffunction>
	<cffunction name="get_in_out_periods" access="public" returntype="query">
		<cfargument name="in_out_id" type="numeric" required="yes">
		<cfargument name="period_id" type="numeric" required="yes">
		<cfquery name="get_period" datasource="#dsn#">
			SELECT
				*
			FROM
				EMPLOYEES_IN_OUT_PERIOD
			WHERE
				IN_OUT_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#"> AND
				PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
		</cfquery>
		<cfreturn get_period>
	</cffunction>
	
	<cffunction name="add_inout_period" access="public" returntype="any">
		<cfargument name="period_code_cat" type="string" required="no">
		<cfargument name="expense_item_id" type="string" required="no">
		<cfargument name="expense_item_name" type="string" required="no">
		<cfargument name="expense_center_id" type="string" required="no">
		<cfargument name="expense_code" type="string" required="no">
		<cfargument name="expense_code_name" type="string" required="no">
		<cfargument name="activity_type_id" type="numeric" required="no">
		<cfargument name="account_code" type="string" required="no" default="">
		<cfargument name="account_name" type="string" required="no" default="">
		<cfargument name="period_id" type="numeric" required="yes">
		<cfargument name="in_out_id" type="numeric" required="yes">
		<cfquery name="insert_inout_period" datasource="#dsn#" result="XX">
			INSERT INTO
				EMPLOYEES_IN_OUT_PERIOD
				(
				ACCOUNT_BILL_TYPE,
				EXPENSE_ITEM_ID,
				EXPENSE_ITEM_NAME,
				EXPENSE_CENTER_ID,
				EXPENSE_CODE,
				EXPENSE_CODE_NAME,
				ACTIVITY_TYPE_ID,
                ACCOUNT_CODE,
                ACCOUNT_NAME,
				PERIOD_COMPANY_ID,
				PERIOD_YEAR,
				IN_OUT_ID,
				PERIOD_ID,
				RECORD_IP,
				RECORD_DATE,
				RECORD_EMP
				)
			VALUES
				(
				<cfif len(arguments.period_code_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_code_cat#">,<cfelse>NULL,</cfif>
				<cfif len(arguments.expense_item_id) and len(arguments.expense_item_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_item_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.expense_item_id) and len(arguments.expense_item_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_item_name#"><cfelse>NULL</cfif>,
				<cfif len(arguments.expense_center_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_center_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.expense_code) and len(arguments.expense_code_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_code#"><cfelse>NULL</cfif>,
				<cfif len(arguments.expense_code) and len(arguments.expense_code_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_code_name#"><cfelse>NULL</cfif>,
				<cfif isdefined("arguments.activity_type_id") and len(arguments.activity_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.activity_type_id#"><cfelse>NULL</cfif>,
				<cfif isdefined("arguments.account_name") and len(arguments.account_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.account_code#"><cfelse>NULL</cfif>,
				<cfif isdefined("arguments.account_code") and len(arguments.account_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.account_name#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
				)
		</cfquery>
         <cfquery name="get_per" datasource="#dsn#">
        	SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
        </cfquery>
		<cfif application.systemParam.systemParam().fusebox.use_period eq true>
			<cfset dsn2_expense = "#DSN#_#get_per.PERIOD_YEAR#_#get_per.OUR_COMPANY_ID#">
		<cfelse>
			<cfset dsn2_expense = "#dsn#">
		</cfif>
        <cfquery name="update_inout_period" datasource="#dsn#">
			UPDATE
				EMPLOYEES_IN_OUT_PERIOD
			SET
				EXPENSE_CODE_NAME = (SELECT TOP 1 EXPENSE_CODE + '-' + EXPENSE FROM  #dsn2_expense#.EXPENSE_CENTER WHERE EXPENSE_CODE = EMPLOYEES_IN_OUT_PERIOD.EXPENSE_CODE),
				EXPENSE_ITEM_NAME = (SELECT TOP 1 ACCOUNT_CODE + '-' + EXPENSE_ITEM_NAME FROM #dsn2_expense#.EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = EMPLOYEES_IN_OUT_PERIOD.EXPENSE_ITEM_ID)
			WHERE 
            	IN_OUT_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#XX.IDENTITYCOL#">
        </cfquery>
	</cffunction>
	
	<cffunction name="upd_inout_period" access="public" returntype="any">
		<cfargument name="period_code_cat" type="string" required="no">
		<cfargument name="expense_item_id" type="string" required="no">
		<cfargument name="expense_item_name" type="string" required="no">
		<cfargument name="expense_center_id" type="string" required="no">
		<cfargument name="expense_code" type="string" required="no">
		<cfargument name="expense_code_name" type="string" required="no">
		<cfargument name="activity_type_id" type="numeric" required="no">
		<cfargument name="period_id" type="numeric" required="yes">
		<cfargument name="in_out_id" type="numeric" required="yes">
		<cfquery name="update_inout_period" datasource="#dsn#">
			UPDATE
				EMPLOYEES_IN_OUT_PERIOD
			SET
				ACCOUNT_BILL_TYPE = <cfif len(arguments.period_code_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_code_cat#">,<cfelse>NULL,</cfif>
				EXPENSE_ITEM_ID = <cfif len(arguments.expense_item_id) and len(arguments.expense_item_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_item_id#"><cfelse>NULL</cfif>,
				EXPENSE_ITEM_NAME = <cfif len(arguments.expense_item_id) and len(arguments.expense_item_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_item_name#"><cfelse>NULL</cfif>,
				EXPENSE_CENTER_ID = <cfif len(arguments.expense_center_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_center_id#"><cfelse>NULL</cfif>,
				EXPENSE_CODE = <cfif len(arguments.expense_code) and len(arguments.expense_code_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_code#"><cfelse>NULL</cfif>,
				EXPENSE_CODE_NAME = <cfif len(arguments.expense_code) and len(arguments.expense_code_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_code_name#"><cfelse>NULL</cfif>,
				ACTIVITY_TYPE_ID = <cfif isdefined("arguments.activity_type_id") and len(arguments.activity_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.activity_type_id#"><cfelse>NULL</cfif>,
				PERIOD_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
				PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#">,
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			WHERE
				IN_OUT_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#"> AND
				PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
		</cfquery>
        <cfquery name="get_per" datasource="#dsn#">
        	SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
        </cfquery>
		<cfif application.systemParam.systemParam().fusebox.use_period eq true>
			<cfset dsn3 = "#DSN#_#get_per.PERIOD_YEAR#_#get_per.OUR_COMPANY_ID#">
		<cfelse>
			<cfset dsn3 = "#dsn#">
		</cfif>
        <cfquery name="update_inout_period" datasource="#dsn#">
			UPDATE
				EMPLOYEES_IN_OUT_PERIOD
			SET
				EXPENSE_CODE_NAME = (SELECT TOP 1 EXPENSE_CODE + '-' + EXPENSE FROM  #dsn3#.EXPENSE_CENTER WHERE EXPENSE_CODE = EMPLOYEES_IN_OUT_PERIOD.EXPENSE_CODE),
				EXPENSE_ITEM_NAME = (SELECT TOP 1 ACCOUNT_CODE + '-' + EXPENSE_ITEM_NAME FROM #dsn3#.EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = EMPLOYEES_IN_OUT_PERIOD.EXPENSE_ITEM_ID)
			WHERE 
            	IN_OUT_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">
        </cfquery>
	</cffunction>
	
	<cffunction name="upd_inout_period_acc_code" access="public" returntype="any">
		<cfargument name="acc_code" type="string" required="no">
		<cfargument name="period_id" type="numeric" required="yes">
		<cfargument name="in_out_id" type="numeric" required="yes">
		<cfquery name="update_inout_period" datasource="#dsn#">
			UPDATE
				EMPLOYEES_IN_OUT_PERIOD
			SET
				ACCOUNT_CODE = <cfif len(arguments.acc_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.acc_code#"><cfelse>NULL</cfif>
			WHERE
				IN_OUT_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#"> AND
				PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
		</cfquery>
	</cffunction>
	
	<!---iliskili hesaplar --->
	<cffunction name="get_employees_account" access="public" returntype="query">
		<cfargument name="in_out_id" type="numeric" required="yes">
		<cfargument name="period_id" type="numeric" required="yes">
		<cfargument name="employee_id" type="numeric" required="yes">
		<cfargument name="acc_type_id" type="numeric" required="no">
		<cfquery name="get_emp_account" datasource="#dsn#">
			SELECT
				*
			FROM
				EMPLOYEES_ACCOUNTS
			WHERE
				IN_OUT_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#"> AND
				PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#"> AND
				EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> AND
				ACC_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.acc_type_id#">
		</cfquery>
		<cfreturn get_emp_account>
	</cffunction>
	
	<cffunction name="add_emp_accounts" access="public" returntype="any">
		<cfargument name="acc_type_id" type="string" required="yes">
		<cfargument name="account_code" type="string" required="yes">
		<cfargument name="period_id" type="string" required="yes">
		<cfargument name="in_out_id" type="string" required="yes">
		<cfargument name="employee_id" type="string" required="yes">
		<cfquery name="add_row" datasource="#dsn#">
			INSERT INTO EMPLOYEES_ACCOUNTS 
			(
				ACC_TYPE_ID,
				ACCOUNT_CODE,
				PERIOD_ID,
				IN_OUT_ID,
				EMPLOYEE_ID
			)
			VALUES
			(	
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.acc_type_id#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.account_code#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="del_emp_accounts" access="public" returntype="any">
		<cfargument name="employee_id" type="string" required="yes">
		<cfargument name="in_out_id" type="string" required="yes">
		<cfargument name="period_id" type="string" required="yes">
		<cfquery name="del_rows" datasource="#dsn#">
			DELETE 
			FROM 
				EMPLOYEES_ACCOUNTS 
			WHERE 
				EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> AND 
				IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#"> AND 
				PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
		</cfquery>
	</cffunction>
	
	<cffunction name="add_employees_period_row" access="public" returntype="any">
		<cfargument name="period_id" type="string" required="yes">
		<cfargument name="in_out_id" type="string" required="yes">
		<cfargument name="employee_id" type="string" required="yes">
		<cfargument name="rate" required="yes">
		<cfargument name="expense_center_id" required="yes">
		<cfquery name="add_period_row" datasource="#dsn#">
			INSERT INTO
            	EMPLOYEES_IN_OUT_PERIOD_ROW
                (
                	PERIOD_ID,
                    IN_OUT_ID,
                    EXPENSE_CENTER_ID,
                    RATE
                )
              VALUES
              	(
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_center_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.rate#">
                )
        </cfquery>	
    </cffunction>
</cfcomponent>
