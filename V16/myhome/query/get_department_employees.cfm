<cfquery name="GET_DEPARTMENT_EMPLOYEE" datasource="#dsn#">
	SELECT 
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		POSITION_CODE,
		EMPLOYEE_ID,
		POSITION_NAME
	FROM 
		EMPLOYEE_POSITIONS
	WHERE 
		DEPARTMENT_ID = #listfirst(SESSION.EP.USER_LOCATION,"-")#
	AND
		POSITION_STATUS = 1
	AND 
		EMPLOYEE_ID <> 0
	ORDER BY 
		EMPLOYEE_NAME
</cfquery>
