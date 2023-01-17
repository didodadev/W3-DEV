<cfquery name="ACCOUNT" datasource="#dsn2#">
	SELECT 
		* 
	FROM 
		ACCOUNT_PLAN
	WHERE
		ACCOUNT_ID = #attributes.account_id#
</cfquery>
<cfquery name="account_acc_code" datasource="#dsn3#">
	SELECT 
		ACCOUNT_ACC_CODE 
	FROM 
		ACCOUNTS
	WHERE
		ACCOUNT_ACC_CODE LIKE '#account.account_code#'
</cfquery>
