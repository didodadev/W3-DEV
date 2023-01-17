<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset use_period = application.systemParam.systemParam().fusebox.use_period>
	<cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cffunction name="getComponentFunction">
		<cfargument name="cash_status">
		<cfargument name="is_all_branch">
		<cfargument name="acc_code">
		<cfargument name="is_virman">
		<cfargument name="branch_id">
		<cfif isdefined("use_period") and use_period eq true>
			<cfset dsn2 = dsn2>
		<cfelse>
			<cfset dsn2 = dsn>
		</cfif>
            <cfquery name="GET_CASHES" datasource="#dsn2#">
            SELECT
			  	CASH_ID,
				CASH_NAME,
				CASH_CURRENCY_ID,
				BRANCH_ID
			FROM 
				CASH
			WHERE 
				1=1
								
				<cfif isdefined("arguments.branch_id") and len(arguments.branch_id)>
					AND BRANCH_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
				</cfif>
				<cfif not (isdefined("arguments.cash_status") and len(arguments.cash_status)) and isdefined("arguments.cash_id") and len(arguments.cash_id)>
					AND CASH_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cash_id#">
				</cfif>
				<cfif isdefined("arguments.acc_code") and len(arguments.acc_code) and arguments.acc_code eq 1>
					AND A_VOUCHER_ACC_CODE IS NOT NULL
					AND V_VOUCHER_ACC_CODE IS NOT NULL
				</cfif>
				<cfif isdefined("arguments.acc_code") and len(arguments.acc_code) and  arguments.acc_code eq 0>
					AND CASH_ACC_CODE IS NOT NULL
				</cfif>
				<cfif isdefined("arguments.cash_status") and len(arguments.cash_status) and arguments.cash_status eq 1 and isdefined("arguments.cash_id") and len(arguments.cash_id)>
					AND (
							CASH_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> 
							OR CASH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cash_id#">
						)
				<cfelseif isdefined("arguments.cash_status") and len(arguments.cash_status) and  arguments.cash_status eq 1>
					AND	CASH_STATUS = 1
				<cfelseif isdefined("arguments.cash_status") and len(arguments.cash_status) and arguments.cash_status eq 0>
					AND CASH_STATUS = 0
				</cfif>
				<cfif isdefined("arguments.is_all_branch") and len(arguments.is_all_branch) and arguments.is_all_branch eq 0>
					AND IS_ALL_BRANCH = 0
				<cfelseif isdefined("arguments.is_all_branch") and len(arguments.is_all_branch) and arguments.is_all_branch eq 1>
					AND IS_ALL_BRANCH = 1
				<cfelseif isdefined("arguments.is_all_branch") and len(arguments.is_all_branch) and arguments.is_all_branch eq 2>
					AND IS_ALL_BRANCH = NULL
				</cfif>
				<cfif session.ep.isBranchAuthorization>
					<cfif isdefined("arguments.is_virman") and len(arguments.is_virman) and arguments.is_virman eq 1>
						AND	(BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) OR IS_ALL_BRANCH = 1)
					<cfelse>
						AND	BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
					</cfif>
				</cfif>
			ORDER BY 
				CASH_NAME
            </cfquery>
        <cfreturn GET_CASHES>
    </cffunction>
</cfcomponent>