<cfquery name="GET_EMP_NAME" datasource="#dsn#">
	SELECT 
		EMPLOYEE_ID,
		EMPLOYEE_NAME ,
		EMPLOYEE_SURNAME		
	FROM 
		EMPLOYEES		
	WHERE 
		EMPLOYEE_ID = #attributes.employee_id#
</cfquery>
