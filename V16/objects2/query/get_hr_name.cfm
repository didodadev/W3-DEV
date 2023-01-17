<cfquery name="GET_HR_NAME" datasource="#dsn#">
	SELECT 
		EMPLOYEE_ID,
		EMPLOYEE_USERNAME,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
	FROM 
		EMPLOYEES
	WHERE 
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>
