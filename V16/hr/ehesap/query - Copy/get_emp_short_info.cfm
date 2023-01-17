<cfquery name="get_emp_short_info" datasource="#DSN#">
	SELECT 	
		MEMBER_CODE,
		PHOTO,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		GROUP_STARTDATE,
		PHOTO_SERVER_ID
	FROM 
		EMPLOYEES
	WHERE 
		EMPLOYEE_ID = #attributes.employee_id#
</cfquery>
