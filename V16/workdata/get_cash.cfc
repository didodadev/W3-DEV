<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn2="#dsn#_#dateformat(now(),'yyyy')#_1">
    <cffunction name="getComponentFunction">
		<cfargument name="cash_status">
		<cfargument name="is_all_branch">
		<cfargument name="is_virman">
		<cfargument name="is_store">
		<cfargument name="branch_id">
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
				<cfif len(arguments.branch_id)>
					AND BRANCH_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
				</cfif>
				<cfif arguments.cash_status eq 1>
					AND	CASH_STATUS = 1
				<cfelseif arguments.cash_status eq 0>
					AND CASH_STATUS = 0
				</cfif>
				<cfif arguments.is_all_branch eq 0>
					AND IS_ALL_BRANCH = 0
				<cfelseif arguments.is_all_branch eq 1>
					AND IS_ALL_BRANCH = 1
				<cfelseif arguments.is_all_branch eq 2>
					AND IS_ALL_BRANCH = NULL
				</cfif>
				<cfif arguments.is_store eq 1>
					<cfif arguments.is_virman eq 1>
						AND	(BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#"> OR IS_ALL_BRANCH = 1)
					<cfelse>
						AND	BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
					</cfif>
				</cfif>
			ORDER BY 
				CASH_NAME
            </cfquery>
        <cfreturn GET_CASHES>
    </cffunction>
</cfcomponent>

