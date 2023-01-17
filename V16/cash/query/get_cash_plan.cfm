<cfset sayi=100>
<cfquery name="GET_CASH_PLAN" datasource="#dsn2#">
	SELECT
		ACCOUNT_CODE,
		ACCOUNT_NAME
	FROM
		ACCOUNT_PLAN
	WHERE
		SUB_ACCOUNT=0
	<cfif isdefined('attributes.cash_acc')>
		AND ACCOUNT_CODE='#attributes.cash_acc#'
	<cfelse>
		AND ACCOUNT_CODE like '#sayi#%'
	</cfif>
</cfquery>
