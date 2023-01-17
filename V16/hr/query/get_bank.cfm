<cfquery name="GET_BANK" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES_BANK_ACCOUNTS
	WHERE
		EMP_BANK_ID = #EMP_BANK_ID#
</cfquery>
