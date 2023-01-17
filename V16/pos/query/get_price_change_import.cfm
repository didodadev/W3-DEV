<cfquery name="get_stock_imports" datasource="#dsn#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		FI.I_ID,
		FI.PRODUCT_COUNT,
		FI.PROBLEMS_COUNT,
		FI.FILE_NAME,
		FI.FILE_SIZE,
		FI.STARTDATE,
		FI.FINISHDATE,
		FI.SOURCE_SYSTEM,
		FI.INVOICE_ID,
		FI.IMPORTED,
		FI.PROBLEMS_FILE_NAME,
		FI.IMPORT_DETAIL,
		FI.RECORD_DATE,
		FI.RECORD_EMP,
		FI.DEPARTMENT_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
		#dsn2_alias#.FILE_IMPORTS AS FI,
		EMPLOYEES E
	WHERE
		FI.PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="-10"> AND <!--- fiyat degisim import --->
		<cfif len(attributes.start_date) and (not len(attributes.finish_date))>
			FI.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
		<cfelseif len(attributes.finish_date)  and (not len(attributes.start_date))>
			FI.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> AND
		<cfelseif len(attributes.start_date) and len(attributes.finish_date)>
			FI.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
			FI.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> AND
		</cfif>
		<cfif session.ep.isBranchAuthorization>
			AND FI.DEPARTMENT_ID IN (SELECT D.DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D WHERE D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">)
		</cfif>
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			AND FI.DEPARTMENT_ID IN (SELECT D.DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D WHERE D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">)
		</cfif>
		FI.RECORD_EMP = E.EMPLOYEE_ID
	ORDER BY
		FI.IMPORTED,
		FI.RECORD_DATE DESC
</cfquery>
