<cfquery name="GET_EMPLOYEE_NAME" datasource="#dsn#">
		SELECT 
			EMPLOYEE_NAME, 
			EMPLOYEE_SURNAME
		FROM 
			EMPLOYEES
		WHERE
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp#">
</cfquery>


