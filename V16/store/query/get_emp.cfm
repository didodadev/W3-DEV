<cfquery name="GET_EMP" datasource="#DSN#">
	SELECT 
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
	FROM 
		EMPLOYEE_POSITIONS
	<cfif isdefined('attributes.position_code')>
	WHERE 
		POSITION_CODE = #attributes.position_code#
	</cfif>
</cfquery>
