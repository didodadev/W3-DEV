<cfquery name="GET_EMPLOYEE" datasource="#dsn#">
	SELECT 
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		MEMBER_CODE
	FROM 
		EMPLOYEES 
	WHERE 
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>
