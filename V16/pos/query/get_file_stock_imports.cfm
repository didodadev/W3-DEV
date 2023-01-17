<cfquery name="GET_STOCK_IMPORTS" datasource="#DSN#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		FI.I_ID,
		FI.PRODUCT_COUNT,
		FI.PROBLEMS_COUNT,
		FI.PROBLEMS_FILE_NAME,
		FI.FILE_NAME,
		FI.FILE_SIZE,
		FI.STARTDATE,
		FI.FINISHDATE,
		FI.SOURCE_SYSTEM,
		FI.INVOICE_ID,
		FI.IMPORTED,
		FI.IS_MUHASEBE,
		FI.IMPORT_DETAIL,
		FI.RECORD_DATE,
		FI.RECORD_EMP,
		FI.DEPARTMENT_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
		#dsn2_alias#.FILE_IMPORTS FI,
		EMPLOYEES E
	WHERE
		FI.PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="-9"> AND <!--- stock import --->
		<cfif len(attributes.start_date) and (not len(attributes.finish_date))>
			FI.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
		<cfelseif len(attributes.finish_date) and (not len(attributes.start_date))>
			FI.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> AND
		<cfelseif len(attributes.start_date) and len(attributes.finish_date)>
			FI.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
			FI.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> AND
		</cfif>
		<cfif session.ep.isBranchAuthorization>
			FI.DEPARTMENT_ID IN (SELECT D.DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D WHERE D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">) AND
		</cfif>
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			FI.DEPARTMENT_ID IN (SELECT D.DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D WHERE D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">) AND
		</cfif>
		FI.RECORD_EMP = E.EMPLOYEE_ID
	ORDER BY
		FI.IMPORTED,
		FI.RECORD_DATE DESC
</cfquery>
