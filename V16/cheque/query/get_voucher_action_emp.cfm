<cfquery name="GET_ACTION_EMP" datasource="#dsn#">
	SELECT
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
	FROM
		EMPLOYEES
	<cfif isDefined("EMP_ID") and len(EMP_ID)> 
	WHERE
		EMPLOYEE_ID=#EMP_ID#
	</cfif>
</cfquery>
