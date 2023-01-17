<cfquery name="GET_ACTION_ACCOUNT" datasource="#dsn3#">
	SELECT 
		*
	FROM
		ACCOUNTS
	WHERE
		ACCOUNT_ID=#ACCOUNT_ID#
</cfquery>

