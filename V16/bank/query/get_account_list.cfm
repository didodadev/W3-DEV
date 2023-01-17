<cfquery name="GET_ACCOUNT_LIST" datasource="#dsn3#">
	SELECT
		<cfif attributes.is_bank_type eq 1 or attributes.is_bank_type eq 2>
			<cfif session.ep.period_year lt 2009>
				CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
			<cfelse>
				ACCOUNTS.ACCOUNT_CURRENCY_ID,
			</cfif>
			ACCOUNTS.ACCOUNT_ID,
			ACCOUNTS.ACCOUNT_TYPE,
			ACCOUNTS.ACCOUNT_NAME,
			ACCOUNTS.ACCOUNT_NO,
			ACCOUNTS.ACCOUNT_CREDIT_LIMIT,
			ACCOUNTS.ACCOUNT_BLOCKED_VALUE,
			BANK_BRANCH.BANK_BRANCH_ID,
			BANK_BRANCH.BANK_ID,
			BANK_BRANCH.BANK_BRANCH_NAME,
			BANK_BRANCH.BANK_NAME,
			ACCOUNTS.ACCOUNT_STATUS,
			ACCOUNTS.ACCOUNT_OWNER_CUSTOMER_NO,
			SETUP_BANK_TYPE_GROUPS.BANK_TYPE
		<cfelse>
			SBT.BANK_ID, 
			SBT.BANK_NAME,
			SUM(ARL.BAKIYE) AS BAKIYE,
			SUM(ARL.BAKIYE_SYSTEM) AS SYSTEM_BAKIYE
		</cfif>
	FROM
		<cfif attributes.is_bank_type eq 1 or attributes.is_bank_type eq 2>
			ACCOUNTS,
			BANK_BRANCH
			LEFT JOIN #dsn_alias#.SETUP_BANK_TYPES ON SETUP_BANK_TYPES.BANK_ID = BANK_BRANCH.BANK_ID
			LEFT JOIN #dsn_alias#.SETUP_BANK_TYPE_GROUPS ON SETUP_BANK_TYPE_GROUPS.BANK_TYPE_ID = SETUP_BANK_TYPES.BANK_TYPE_GROUP_ID
		<cfelse>
			#dsn_alias#.SETUP_BANK_TYPES AS SBT LEFT JOIN #dsn_alias#.SETUP_BANK_TYPE_GROUPS SBTG ON SBTG.BANK_TYPE_ID = SBT.BANK_TYPE_GROUP_ID
			JOIN BANK_BRANCH AS BB ON SBT.BANK_ID = BB.BANK_ID
			JOIN ACCOUNTS AS ACC ON ACC.ACCOUNT_BRANCH_ID = BB.BANK_BRANCH_ID
			JOIN #dsn2_alias#.ACCOUNT_REMAINDER_LAST AS ARL ON ACC.ACCOUNT_ID = ARL.ACCOUNT_ID
		</cfif>
	WHERE
	1=1
	<cfif attributes.is_bank_type eq 1 or attributes.is_bank_type eq 2>
		AND ACCOUNTS.ACCOUNT_BRANCH_ID=BANK_BRANCH.BANK_BRANCH_ID	
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND ACCOUNTS.ACCOUNT_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		</cfif>
		<cfif isdefined("attributes.acc_type") and len(attributes.acc_type)>
			AND ACCOUNTS.ACCOUNT_TYPE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_type#">
		</cfif>
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			AND BANK_BRANCH.BANK_BRANCH_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
		</cfif>
		<cfif isdefined("attributes.bank_id") and len(attributes.bank_id)>
			AND BANK_BRANCH.BANK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_id#">
		</cfif>
		<cfif (isDefined("attributes.account_status") and len(attributes.account_status))>
			AND ACCOUNT_STATUS =<cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.account_status#"> 
		</cfif>
		<cfif session.ep.isBranchAuthorization>
			AND ACCOUNTS.ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#)
		</cfif>
		<cfif isDefined("attributes.account_currency_id") and len(attributes.account_currency_id)>
			AND (ACCOUNTS.ACCOUNT_CURRENCY_ID='#attributes.account_currency_id#' OR ('#attributes.account_currency_id#' = 'YTL' AND ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL'))
		</cfif>
		<cfif session.ep.period_year lt 2009>
			AND (ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn_alias#.SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND COMPANY_ID=#SESSION.EP.COMPANY_ID#) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')
		<cfelse>
			AND ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn_alias#.SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND COMPANY_ID=#SESSION.EP.COMPANY_ID#)
		</cfif>
		<cfif isDefined("attributes.is_bakiye") and attributes.is_bakiye eq 1>
			AND ACCOUNTS.ACCOUNT_ID IN (SELECT ACCOUNT_ID FROM #dsn2_alias#.ACCOUNT_REMAINDER_LAST WHERE ROUND(BAKIYE,2) <> 0)
		</cfif>
		ORDER BY 
			ACCOUNTS.ACCOUNT_NAME
	</cfif>
	<cfif attributes.is_bank_type eq 3>
		GROUP BY SBT.BANK_ID, SBT.BANK_NAME
	</cfif>
</cfquery>
