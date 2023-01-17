<cfquery name="GET_EMP" datasource="#DSN#">
	SELECT 
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
	FROM 
		EMPLOYEES
	<cfif isdefined('attributes.EMPLOYEE_ID') and LEN(attributes.EMPLOYEE_ID)>
	WHERE 
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
	</cfif>
</cfquery>
