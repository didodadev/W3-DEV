<cfquery name="GET_REC_EMP" datasource="#dsn#">
	SELECT 
		EMPLOYEE_NAME,EMPLOYEE_SURNAME
	FROM 
		EMPLOYEES
	WHERE 
		EMPLOYEE_ID=#REC_EMP#
</cfquery>
