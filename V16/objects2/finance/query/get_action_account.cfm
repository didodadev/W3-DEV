<cfquery name="GET_ACTION_ACCOUNT" datasource="#DSN3#">
	SELECT 
		ACCOUNT_NAME,
        ACCOUNT_CURRENCY_ID
	FROM
		ACCOUNTS
		<cfif isdefined("account_id") and len(account_id)>
			WHERE
				ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#account_id#">
		</cfif>
</cfquery>

