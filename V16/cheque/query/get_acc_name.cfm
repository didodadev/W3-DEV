<cfquery   name="GET_ACCOUNT_CODE"datasource="#DSN2#">
	SELECT
		ACCOUNT_CODE
	FROM
		ACCOUNT_PLAN
	WHERE
		ACCOUNT_CODE = '#acc_code#'
</cfquery>
