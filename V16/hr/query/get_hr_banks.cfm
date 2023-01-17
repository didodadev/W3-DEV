<cfquery name="GET_HR_BANKS" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES_BANK_ACCOUNTS
	WHERE
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>
