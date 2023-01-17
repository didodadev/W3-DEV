<cfquery name="GET_ACC_CODE" datasource="#dsn2#">
	SELECT
		ACCOUNT_NAME
	FROM
		ACCOUNT_PLAN
	WHERE
		ACCOUNT_CODE='#ACC_CODE#'
</cfquery>
