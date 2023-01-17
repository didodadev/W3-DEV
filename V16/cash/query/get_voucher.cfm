<cfquery datasource="#DSN2#" name="get_voucher">
	SELECT
		ACCOUNT_CODE,
		ACCOUNT_NAME
	FROM
		ACCOUNT_PLAN
	WHERE
		ACCOUNT_CODE LIKE '#voucher_kodu#%'
	<cfif isdefined("voucher_kodu_") and len(voucher_kodu_)>
		OR
		ACCOUNT_CODE LIKE '#voucher_kodu_#%'
	</cfif>
</cfquery>

