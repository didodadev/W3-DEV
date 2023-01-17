<cffunction name="get_warehouse_rates_fnc" returntype="query">
	<cfargument name="keyword" default="">
	<cfargument name="start_date" default="">
	<cfargument name="finish_date" default="">
	<cfargument name="company_id" default="">
	<cfargument name="company" default="">
	<cfargument name="consumer_id" default="">
	<cfquery name="get_warehouse_rates" datasource="#this.DSN3#">
		SELECT 
			WT.*,
			C.NICKNAME,
			E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS ACTION_MAN
		FROM
			WAREHOUSE_RATES WT
				LEFT JOIN  #this.dsn_alias#.COMPANY C ON WT.COMPANY_ID=C.COMPANY_ID
				LEFT JOIN  #this.dsn_alias#.EMPLOYEES E ON WT.RECORD_EMP=E.EMPLOYEE_ID
		WHERE 
			WT.RATE_ID IS NOT NULL	  
		  <cfif len(arguments.keyword)>
			AND C.NICKNAME LIKE '%#arguments.keyword#%'
		  </cfif>
		  <cfif len(arguments.start_date)>
			AND WT.ACTION_DATE >= #arguments.start_date#
		  </cfif>
		  <cfif len(arguments.finish_date)>
		  	AND WT.ACTION_DATE <= #arguments.finish_date#
		  </cfif>
		  <cfif len(arguments.company_id) and len(arguments.company)>
		  	AND WT.COMPANY_ID = #arguments.company_id#
		 <cfelseif len(arguments.consumer_id) and len(arguments.company)>
		  	AND WT.CONSUMER_ID = #arguments.consumer_id#
		  </cfif>
		ORDER BY 
			WT.RATE_ID DESC
	</cfquery>
	<cfreturn get_warehouse_rates>
</cffunction>

<cffunction name="get_warehouse_rate_fnc" returntype="query">
	<cfargument name="rate_id" default="">
	<cfquery name="get_warehouse_rates" datasource="#this.DSN3#">
		SELECT 
			WT.*,
			C.NICKNAME,
			E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS ACTION_MAN
		FROM
			WAREHOUSE_RATES WT
				LEFT JOIN  #this.dsn_alias#.COMPANY C ON WT.COMPANY_ID=C.COMPANY_ID
				LEFT JOIN  #this.dsn_alias#.EMPLOYEES E ON WT.RECORD_EMP=E.EMPLOYEE_ID
		WHERE 
			WT.RATE_ID = #arguments.rate_id#
	</cfquery>
	<cfreturn get_warehouse_rates>
</cffunction>

<cffunction name="get_warehouse_rate_rows_fnc" returntype="query">
	<cfargument name="rate_id" default="">
	<cfquery name="get_warehouse_rates" datasource="#this.DSN3#">
		SELECT 
			WT.*,
			P.PRODUCT_NAME,
			SU.UNIT,
			SU2.UNIT AS RATE_UNIT,
			WTT.WAREHOUSE_TASK_TYPE
		FROM
			WAREHOUSE_RATES_ROWS WT
				LEFT JOIN #this.dsn_alias#.WAREHOUSE_TASK_TYPES WTT ON WT.WAREHOUSE_TASK_TYPE_ID = WTT.WAREHOUSE_TASK_TYPE_ID
				LEFT JOIN PRODUCT P ON WT.PRODUCT_ID = P.PRODUCT_ID
				LEFT JOIN #this.dsn_alias#.SETUP_UNIT SU ON SU.UNIT_ID = WT.UNIT_ID
				LEFT JOIN #this.dsn_alias#.SETUP_UNIT SU2 ON SU2.UNIT_ID = WT.RATE_UNIT_ID
		WHERE 
			WT.RATE_ID = #arguments.rate_id#
		ORDER BY
			WTT.WAREHOUSE_TASK_TYPE_ORDER ASC
	</cfquery>
	<cfreturn get_warehouse_rates>
</cffunction>

<cffunction name="get_warehouse_task_types_funcs" returntype="query">
	<cfquery name="get_warehouse_rates" datasource="#this.DSN#">
		SELECT 
			*
		FROM
			WAREHOUSE_TASK_TYPES
		ORDER BY
			WAREHOUSE_TASK_TYPE_ORDER ASC
	</cfquery>
	<cfreturn get_warehouse_rates>
</cffunction>

<cffunction name="get_units_funcs" returntype="query">
	<cfquery name="get_units" datasource="#this.DSN#">
		SELECT 
			*
		FROM
			SETUP_UNIT
		ORDER BY
			UNIT ASC
	</cfquery>
	<cfreturn get_units>
</cffunction>



