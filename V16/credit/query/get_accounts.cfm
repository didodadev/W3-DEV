<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
	SELECT
		ACCOUNTS.ACCOUNT_ID,
		ACCOUNTS.ACCOUNT_NAME,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID
		</cfif>
	FROM
		ACCOUNTS,
		BANK_BRANCH
	WHERE
		ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID AND
		ACCOUNTS.ACCOUNT_STATUS = 1 AND
		<cfif session.ep.period_year lt 2009>
			(ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY)
		</cfif>
		<cfif session.ep.isBranchAuthorization>
			AND ACCOUNTS.ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#)
		</cfif>
	ORDER BY
		BANK_NAME,
		ACCOUNT_NAME
</cfquery>
