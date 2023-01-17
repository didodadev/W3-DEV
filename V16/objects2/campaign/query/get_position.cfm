<cfquery name="GET_POSITION" datasource="#DSN#">
	SELECT
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		POSITION_NAME,
		EMPLOYEE_ID,
		DEPARTMENT_ID,
		POSITION_CODE
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#"> AND
		POSITION_STATUS = 1
</cfquery>
