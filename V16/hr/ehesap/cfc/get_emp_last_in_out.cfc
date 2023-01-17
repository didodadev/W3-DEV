<cfcomponent>
	<cffunction name="get_emp_last_in_out" access="public" returntype="query">
		<cfargument name="employee_id" default="" required="true">
		<cfargument name="date_" default="now()">
		<cfquery name="get_in_out" datasource="#this.dsn#">
			SELECT
				EIO.IN_OUT_ID,
				EIO.USE_SSK,
				EIO.SOCIALSECURITY_NO,
				EIO.GROSS_NET,
				EIO.SALARY_TYPE,
				EIO.BUSINESS_CODE_ID,
				SBC.BUSINESS_CODE_NAME,
				SBC.BUSINESS_CODE
			FROM
				EMPLOYEES_IN_OUT EIO
				LEFT JOIN SETUP_BUSINESS_CODES SBC ON EIO.BUSINESS_CODE_ID = SBC.BUSINESS_CODE_ID
			WHERE
				EIO.IN_OUT_ID = (SELECT TOP 1
				ISNULL((SELECT
					TOP 1 IN_OUT_ID
				FROM
					EMPLOYEES_IN_OUT
				WHERE
					START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateformat(arguments.date_,session.ep.dateformat_style)#"> AND
					(FINISH_DATE IS NULL
					OR FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateformat(arguments.date_,session.ep.dateformat_style)#">)
					AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
				ORDER BY
					START_DATE DESC, IN_OUT_ID DESC),
					(SELECT
					TOP 1 IN_OUT_ID
				FROM
					EMPLOYEES_IN_OUT
				WHERE
					EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
				ORDER BY
					START_DATE DESC,FINISH_DATE DESC, IN_OUT_ID DESC)) IN_OUT_ID
			FROM
				EMPLOYEES_IN_OUT EIO)
		</cfquery>
		<cfreturn get_in_out>
	</cffunction>
</cfcomponent>
