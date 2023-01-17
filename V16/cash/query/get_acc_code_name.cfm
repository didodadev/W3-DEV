<cfquery name="GET_CODE_NAME" datasource="#dsn2#">
	SELECT
		ACCOUNT_NAME
	FROM	
		ACCOUNT_PLAN
	WHERE
		ACCOUNT_CODE='#ACC_CODE#'
</cfquery>
