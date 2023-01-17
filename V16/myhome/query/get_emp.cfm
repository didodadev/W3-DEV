<cfquery name="GET_EMP" datasource="#DSN#">
	SELECT 
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME 
	FROM 
		EMPLOYEES
	WHERE 
	<cfif isdefined("attributes.employee_id")>
		EMPLOYEE_ID = #attributes.employee_id#
	<cfelse>
		EMPLOYEE_ID = #SESSION.EP.USERID#
	</cfif>
</cfquery>


