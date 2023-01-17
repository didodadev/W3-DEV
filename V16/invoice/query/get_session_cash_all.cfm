<cfquery name="KASA" datasource="#dsn2#">
	SELECT 
		CASH_ID,
		CASH_CURRENCY_ID,
		CASH_NAME 
	FROM 
		CASH 
	WHERE 
		CASH_ACC_CODE IS NOT NULL 
		<cfif isdefined("kontrol_status")>
			AND CASH_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> 
		</cfif>
		<cfif session.ep.isBranchAuthorization>
			AND BRANCH_ID IN(
							SELECT 
								BRANCH_ID 
							FROM 
								#dsn_alias#.EMPLOYEE_POSITION_BRANCHES 
							WHERE 
								POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
							)
		</cfif>
	ORDER BY 
		CASH_NAME
</cfquery>
