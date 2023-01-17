<cfquery name="get_code_cat" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF
	ORDER BY
		DEFINITION
</cfquery>

