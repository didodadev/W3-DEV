<cfquery name="EMPLOYEE_NAME" datasource="#dsn#">
	SELECT
		EMPLOYEE_ID,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		EMPLOYEE_USERNAME		
	FROM
		EMPLOYEES
	<cfif isdefined('attributes.EMP_ID') and len('attributes.EMP_ID')>
		WHERE
			EMPLOYEE_ID = #attributes.EMP_ID#
		
	</cfif>
</cfquery>	
	

