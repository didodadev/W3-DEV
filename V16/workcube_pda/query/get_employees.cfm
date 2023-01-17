<cfquery name="GET_EMPLOYEES" datasource="#dsn#">
	SELECT 
		EMPLOYEE_ID,
		EMPLOYEE_NAME, 
		EMPLOYEE_SURNAME
	FROM 
		EMPLOYEES
	WHERE
		EMPLOYEE_ID <> 0
	<cfif isDefined("attributes.EMPLOYEE_IDS")>
		<cfif len(attributes.EMPLOYEE_IDS)>
		AND
		EMPLOYEE_ID IN (#attributes.EMPLOYEE_IDS#)
		</cfif>
	</cfif>
	<cfif isDefined("attributes.DEPARTMENT_ID")>
		AND
		DEPARTMENT_ID = #attributes.DEPARTMENT_ID#
	</cfif>
</cfquery>


