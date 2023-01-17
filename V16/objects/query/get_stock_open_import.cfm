<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
	<cfset attributes.finish_date=date_add("h",23,attributes.finish_date)>
	<cfset attributes.finish_date=date_add("n",59,attributes.finish_date)>
	<cfset attributes.finish_date=date_add("s",59,attributes.finish_date)>
</cfif>
<cfquery name="get_stock_open_import" datasource="#DSN2#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		I_ID,
		FILE_NAME,
		FILE_SIZE,
		STARTDATE,
		FINISHDATE,
		SOURCE_SYSTEM,
		PRODUCT_COUNT,
		FILE_IMPORTS.RECORD_DATE,
		FILE_IMPORTS.RECORD_EMP,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		DEPARTMENT.DEPARTMENT_HEAD,
		STOCKS_LOCATION.COMMENT
	FROM
		FILE_IMPORTS,
		#DSN_ALIAS#.EMPLOYEES EMPLOYEES,
		#DSN_ALIAS#.DEPARTMENT DEPARTMENT,
		#DSN_ALIAS#.STOCKS_LOCATION STOCKS_LOCATION
	WHERE
		DEPARTMENT.DEPARTMENT_ID = FILE_IMPORTS.DEPARTMENT_ID AND
		FILE_IMPORTS.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID AND
		DEPARTMENT.DEPARTMENT_ID = STOCKS_LOCATION.DEPARTMENT_ID AND
		FILE_IMPORTS.DEPARTMENT_LOCATION = STOCKS_LOCATION.LOCATION_ID AND
		FILE_IMPORTS.PROCESS_TYPE = -5 <!--- Stok Sayım İmport --->
		<cfif isDefined("attributes.position_code") and len(attributes.position_code) and isDefined("attributes.position_name") and len(attributes.position_name)>
			AND FILE_IMPORTS.RECORD_EMP = #attributes.position_code#
		</cfif>
		<cfif isdefined("attributes.department_id") and listlen(attributes.department_id,'-') eq 1>
			AND FILE_IMPORTS.DEPARTMENT_ID = #attributes.department_id#
		<cfelseif isdefined("attributes.department_id") and listlen(attributes.department_id,'-') eq 2>
			AND FILE_IMPORTS.DEPARTMENT_ID = #listfirst(attributes.department_id,'-')#
			AND FILE_IMPORTS.DEPARTMENT_LOCATION = #listlast(attributes.department_id,'-')#
		<cfelse>
			<cfif session.ep.our_company_info.is_location_follow eq 1>
				AND
				(
					CAST(FILE_IMPORTS.DEPARTMENT_ID AS NVARCHAR) + '-' + CAST(FILE_IMPORTS.DEPARTMENT_LOCATION AS NVARCHAR) IN (SELECT LOCATION_CODE FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
					OR
					FILE_IMPORTS.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# AND LOCATION_ID IS NULL)
				)
			</cfif>
		</cfif>
		<cfif isdefined("attributes.start_date") and isdate(attributes.start_date) and isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
			AND FILE_IMPORTS.RECORD_DATE BETWEEN  #attributes.start_date# AND  #attributes.finish_date#
		</cfif>
	ORDER BY
		FILE_IMPORTS.RECORD_DATE DESC
</cfquery>

