<cfquery name="GET_ACCOUNT_NAME" datasource="#DSN2#">
	SELECT
		ACCOUNT_NAME
	FROM 
		ACCOUNT_PLAN
	WHERE 
		ACCOUNT_CODE = '#attributes.account_code#'
</cfquery>
