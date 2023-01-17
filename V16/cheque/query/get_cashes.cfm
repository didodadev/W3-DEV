<cfquery name="GET_CASHES" datasource="#dsn2#">
	SELECT 
		* 
	FROM 
		CASH 
	WHERE 
		1 = 1
		<cfif isdefined("cash_status") or not (isdefined("attributes.id") and isnumeric(attributes.id))>
			AND CASH_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
        <cfelseif isdefined("attributes.id") and isnumeric(attributes.id)>
        	AND (CASH_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> OR CASH_ID = #GET_ACTION_DETAIL.PAYROLL_CASH_ID#)
		</cfif>	
		<cfif session.ep.isBranchAuthorization>
			AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
		</cfif>
	ORDER BY	
		CASH_ID
</cfquery>

