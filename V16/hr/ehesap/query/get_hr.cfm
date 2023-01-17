<cfquery name="GET_HR" datasource="#DSN#">
	SELECT 
		*
	FROM 
		EMPLOYEES
	WHERE 
		EMPLOYEE_ID=#attributes.EMPLOYEE_ID# 
</cfquery>
