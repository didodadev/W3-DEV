<cfquery name="GET_POSITION" datasource="#DSN#">
	SELECT
		EMPLOYEE_POSITIONS.DEPARTMENT_ID,
		EMPLOYEE_POSITIONS.POSITION_ID,
		EMPLOYEE_POSITIONS.POSITION_CODE,
		EMPLOYEE_POSITIONS.POSITION_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
		EMPLOYEES.EMPLOYEE_EMAIL
	FROM
		EMPLOYEE_POSITIONS,
		EMPLOYEES
	WHERE
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
		EMPLOYEE_POSITIONS.POSITION_STATUS = 1
		<cfif isDefined("attributes.employee_id") and len(attributes.employee_id)>
            AND EMPLOYEES.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
        </cfif>
		<cfif isDefined("attributes.position_code") and len(attributes.position_code)>
            AND EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
		</cfif>
</cfquery>
