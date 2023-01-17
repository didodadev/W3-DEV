<cfquery name="GET_FILE_EXPORT_PROMOTIONS" datasource="#DSN2#">
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
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
		FILE_EXPORTS FI,
		#dsn_alias#.EMPLOYEES E
	WHERE
		FI.RECORD_EMP = E.EMPLOYEE_ID AND
		FI.PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="-4">
	  <cfif isdefined("attributes.target_pos") and len(attributes.target_pos)>
		AND FI.TARGET_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.target_pos#">
	  </cfif>
		AND FI.RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.finish_date)#">
	ORDER BY
		FI.RECORD_DATE DESC
</cfquery>
