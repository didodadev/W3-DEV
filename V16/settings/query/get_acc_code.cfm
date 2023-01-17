<cfquery name="get_account_code" datasource="#dsn2#">
	SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#attributes.account_code#'
</cfquery>
