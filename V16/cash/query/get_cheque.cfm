<cfset sayi=103>
<cfquery name="GET_cheque" datasource="#dsn2#">
	SELECT
		ACCOUNT_CODE,
		ACCOUNT_NAME
	FROM
		ACCOUNT_PLAN
	WHERE
	<cfif isdefined('attributes.v_acc_code')>
		ACCOUNT_CODE='#attributes.v_acc_code#'
	<cfelse>
		ACCOUNT_CODE like '#sayi#%'
	</cfif>
</cfquery>
