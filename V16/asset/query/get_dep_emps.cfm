<cfquery name="GET_DEP_EMPS" datasource="#dsn#">
	SELECT 
		ZONE_ID, 
		BRANCH_ID, 
		DEPARTMENT_ID, 
		EMPLOYEE_ID,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
	FROM 
		EMPLOYEES
	WHERE 
		DEPARTMENT_ID=#attributes.DEPARTMENT_ID#
</cfquery>

