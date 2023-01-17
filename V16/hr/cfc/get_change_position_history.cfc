<cffunction name="get_change_history_fnc" returntype="query">
	<cfargument name="employee_id" type="numeric">
	<cfargument name="id" type="numeric">
	<cfquery name="get_change_positions" datasource="#this.dsn#">
		SELECT 
			EH.ID,
			E.EMPLOYEE_ID,
			EH.DEPARTMENT_ID,
			EH.POSITION_ID,
			EH.POSITION_NAME,
			EH.POSITION_CAT_ID,
			EH.TITLE_ID,
			EH.FUNC_ID,
			EH.ORGANIZATION_STEP_ID,
			EH.COLLAR_TYPE,
			EH.UPPER_POSITION_CODE,
			EH.UPPER_POSITION_CODE2,
			EH.START_DATE,
			EH.FINISH_DATE,
			EH.RECORD_EMP,
			EH.RECORD_DATE,
			EH.UPDATE_EMP,
			EH.UPDATE_DATE,
            EH.REASON_ID
		FROM
			EMPLOYEE_POSITIONS_CHANGE_HISTORY EH
				LEFT JOIN EMPLOYEES E ON EH.EMPLOYEE_ID = E.EMPLOYEE_ID
		WHERE 
			EH.ID IS NOT NULL
			<cfif isdefined("arguments.employee_id") and len(arguments.employee_id)>
			AND E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> 
			</cfif>
			<cfif isdefined("arguments.id") and len(arguments.id)>
			AND EH.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#"> 	
			</cfif>
		ORDER BY
			EH.START_DATE DESC
	</cfquery>
	<cfreturn get_change_positions>
</cffunction>

