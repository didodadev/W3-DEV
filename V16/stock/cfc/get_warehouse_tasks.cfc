<cffunction name="get_warehouse_tasks_fnc" returntype="query">
	<cfargument name="ship_number" default="">
	<cfargument name="keyword" default="">
	<cfargument name="process_stage_type" default="">
	<cfargument name="start_date" default="">
	<cfargument name="finish_date" default="">
	<cfargument name="department_id" default="">
	<cfargument name="department_name" default="">
	<cfargument name="employee_id" default="">
	<cfargument name="employee_name" default="">
	<cfargument name="company_id" default="">
	<cfargument name="company" default="">
	<cfargument name="service_type" default="">
	<cfargument name="consumer_id" default="">
	<cfargument name="project_head" default="">
	<cfargument name="task_status" default="1">
	<cfquery name="get_warehouse_tasks" datasource="#this.DSN3#">
		SELECT 
			WT.*,
			ISNULL((SELECT SUM(WTP.AMOUNT) FROM WAREHOUSE_TASKS_PRODUCTS WTP WHERE WTP.TASK_ID = WT.TASK_ID),0) AS TOTAL_QUANTITY,
			ISNULL((SELECT SUM(CEILING(CAST(WTP.AMOUNT AS FLOAT) / WTP.PALLET_AMOUNT)) FROM WAREHOUSE_TASKS_PRODUCTS WTP WHERE WTP.TASK_ID = WT.TASK_ID AND WTP.TOTAL_UNIT_TYPE = 'Pallet' AND WTP.AMOUNT <> 0 AND WTP.PALLET_AMOUNT <> 0),0) AS TOTAL_PALLETS,
			ISNULL((SELECT COUNT(DISTINCT WTP.PALLET_CODE) FROM WAREHOUSE_TASKS_PRODUCTS WTP WHERE WTP.TASK_ID = WT.TASK_ID AND WTP.TOTAL_UNIT_TYPE <> 'Pallet' AND WTP.AMOUNT <> 0 AND WTP.PALLET_CODE IS NOT NULL AND WTP.PALLET_CODE <> ''),0) AS TOTAL_ADD_PALLETS,
            PP.PROJECT_HEAD,
			C.NICKNAME,
			C.FULLNAME,
			C.MEMBER_CODE,
			D.DEPARTMENT_HEAD,
			E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS ACTION_MAN
		FROM
			WAREHOUSE_TASKS WT
				LEFT JOIN  #this.dsn_alias#.PRO_PROJECTS PP ON WT.PROJECT_ID=PP.PROJECT_ID
				LEFT JOIN  #this.dsn_alias#.COMPANY C ON WT.COMPANY_ID=C.COMPANY_ID
				LEFT JOIN  #this.dsn_alias#.DEPARTMENT D ON WT.DEPARTMENT_ID=D.DEPARTMENT_ID
				LEFT JOIN  #this.dsn_alias#.EMPLOYEES E ON WT.EMPLOYEE_ID=E.EMPLOYEE_ID
		WHERE
			WT.TASK_ID IS NOT NULL
		  <cfif len(arguments.keyword)>
			AND (
				WT.TASK_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#"> OR 
				WT.CARGO_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR 
				WT.DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR 
				WT.CONTAINER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
				WT.BL_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
				C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%"> OR
				C.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%"> OR
				WT.CARRIER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%">  OR
				WT.TASK_ID IN (SELECT TASK_ID FROM WAREHOUSE_TASKS_ACTIONS WHERE ACTION_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#">)
				)
		  </cfif>
		  <cfif len(arguments.task_status)>
		  	AND WT.IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.task_status#">
		  </cfif>
		  <cfif len(arguments.service_type)>
		  	AND WT.WAREHOUSE_IN_OUT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_type#">
		  </cfif>
		  <cfif len(arguments.process_stage_type)>
		    AND WT.TASK_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage_type#"></cfif>
		  <cfif len(arguments.start_date)>
			AND WT.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
		  </cfif>
		  <cfif len(arguments.finish_date)>
		  	AND WT.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
		  </cfif>
		  <cfif len(arguments.department_id) and len(arguments.department_name)>
		  	AND WT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
		  </cfif>
		  <cfif len(arguments.company_id) and len(arguments.company)>
		  	AND WT.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
		 <cfelseif len(arguments.consumer_id) and len(arguments.company)>
		  	AND WT.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
		  </cfif>
		ORDER BY 
			WT.TASK_ID DESC
	</cfquery>
	<cfreturn get_warehouse_tasks>
</cffunction>
<cffunction name="get_warehouse_task_fnc" returntype="query">
	<cfargument name="task_id" default="">
	<cfquery name="get_warehouse_task" datasource="#this.DSN3#">
		SELECT 
			WT.*,
			CASE WHEN (C.NICKNAME IS NOT NULL AND C.NICKNAME <> '') THEN C.NICKNAME ELSE C.FULLNAME END AS COMPANY,
            PP.PROJECT_HEAD,
			C.NICKNAME,
			C.FULLNAME,
			C.COMPANY_ADDRESS,
			C.COMPANY_POSTCODE,
			(SELECT SC.COUNTY_NAME FROM #this.dsn_alias#.SETUP_COUNTY SC WHERE SC.COUNTY_ID = C.COUNTY) AS C_CITY,
/* 			 (SELECT SC.SHORT_CODE FROM #this.dsn_alias#.SETUP_CITY SC WHERE SC.CITY_ID = C.CITY) AS C_STATE, */
			C.MEMBER_CODE,
			C.ASSET_FILE_NAME2,
			D.DEPARTMENT_HEAD,
			E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS ACTION_MAN
		FROM
			WAREHOUSE_TASKS WT
				LEFT JOIN  #this.dsn_alias#.PRO_PROJECTS PP ON WT.PROJECT_ID=PP.PROJECT_ID
				LEFT JOIN  #this.dsn_alias#.COMPANY C ON WT.COMPANY_ID=C.COMPANY_ID
				LEFT JOIN  #this.dsn_alias#.DEPARTMENT D ON WT.DEPARTMENT_ID=D.DEPARTMENT_ID
				LEFT JOIN  #this.dsn_alias#.EMPLOYEES E ON WT.EMPLOYEE_ID=E.EMPLOYEE_ID
		WHERE
			WT.TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.task_id#">
		ORDER BY 
			WT.TASK_ID DESC
	</cfquery>
	<cfreturn get_warehouse_task>
</cffunction>
