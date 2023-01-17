<!--- sanal pos tan çalışıcak duruma gelince bu query de değişcek  AE--->
<cfset session_base = session_base?:session.ep />
<cfquery name="GET_POS_DETAIL" datasource="#dsn3#">
	SELECT
		ACCOUNTS.ACCOUNT_ID,
		ACCOUNTS.ACCOUNT_NAME,
		<cfif session_base.period_year lt 2009>
			CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID,
		</cfif>
		CPT.PAYMENT_TYPE_ID,
		CPT.CARD_NO
	FROM
		ACCOUNTS ACCOUNTS,
		CREDITCARD_PAYMENT_TYPE CPT
	WHERE
	<cfif isdefined("account_status")>
		ACCOUNTS.ACCOUNT_STATUS = 1 AND
	</cfif>
	<cfif isDefined("session.pp") or isDefined("session.ww")>
		<cfif session_base.period_year lt 2009>
			(ACCOUNTS.ACCOUNT_CURRENCY_ID = '#session_base.money#' OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') AND
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID = '#session_base.money#' AND
		</cfif>
	<cfelse>
		<cfif session_base.period_year lt 2009>
			(ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') AND
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) AND
		</cfif>
	</cfif>	
		ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
		CPT.IS_ACTIVE = 1
	<cfif attributes.fuseaction contains "invoice.whops">
		AND IS_CASH_REGISTER = 1
	</cfif>
	<cfif session_base.isBranchAuthorization and (attributes.fuseaction contains "detail_invoice_retail" or attributes.fuseaction contains "add_bill_retail")>
		AND ACCOUNTS.ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = #ListGetAt(session_base.user_location,2,"-")#)
	</cfif>
	ORDER BY
		ACCOUNTS.ACCOUNT_NAME
</cfquery>
