<cfif not isdefined("db_adres")>
	<cfset db_adres="#dsn2#">
</cfif>
<cfquery name="GET_CASHES" datasource="#db_adres#">
	SELECT 
		* 
	FROM 
		CASH 
	WHERE
		A_VOUCHER_ACC_CODE IS NOT NULL
		AND V_VOUCHER_ACC_CODE IS NOT NULL
        <cfif not (isdefined("attributes.id") and isnumeric(attributes.id))>
        	AND CASH_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        <cfelseif isdefined("attributes.id") and isnumeric(attributes.id)>
        	AND (CASH_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> OR CASH_ID = #GET_ACTION_DETAIL.PAYROLL_CASH_ID#)
        </cfif>
		<cfif session.ep.isBranchAuthorization>
			AND CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#))
		</cfif>
	ORDER BY	
		CASH_ID
</cfquery>

