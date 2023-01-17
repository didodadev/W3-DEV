<cfquery name="GET_FILE_EXPORTS" datasource="#DSN2#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		FI.E_ID,
		FI.PRODUCT_COUNT,
		FI.TARGET_SYSTEM,
		FI.FILE_NAME,
		FI.FILE_SIZE,
		FI.STARTDATE,
		FI.FINISHDATE,
		FI.RECORD_DATE,
		FI.RECORD_EMP,
		FI.PRICE_RECORD_DATE,
		FI.PRODUCT_RECORD_DATE,
		FI.DEPARTMENT_ID,
		FI.IS_PHL,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
		FILE_EXPORTS FI,
		#dsn_alias#.EMPLOYEES E
	WHERE
		FI.RECORD_EMP = E.EMPLOYEE_ID AND
		FI.PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="-1">
	<cfif session.ep.isBranchAuthorization>
		AND FI.DEPARTMENT_ID IN (SELECT D.DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D WHERE D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">)
	</cfif>
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		AND FI.DEPARTMENT_ID IN (SELECT D.DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D WHERE D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">)
	</cfif>
	<cfif isdefined("attributes.target_pos") and len(attributes.target_pos)>
		AND FI.TARGET_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.target_pos#">
	</cfif>
		AND FI.RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
		AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATE_ADD("d",1,attributes.finish_date)#">
	ORDER BY
		FI.RECORD_DATE DESC
</cfquery>
