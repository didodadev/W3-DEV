<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
	SELECT
		ACCOUNTS.ACCOUNT_NAME,
	<cfif session.ep.period_year lt 2009>
		CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
	<cfelse>
		ACCOUNTS.ACCOUNT_CURRENCY_ID,
	</cfif>
		ACCOUNTS.ACCOUNT_ID,
		BANK_BRANCH.BANK_NAME
	FROM
		ACCOUNTS,
		BANK_BRANCH
	WHERE
		ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID
	<cfif session.ep.period_year lt 2009>
		AND (ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')  
		<cfif isDefined("system_money_info")>AND ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL'</cfif><!--- sadece sistem para birimi olanlarda --->
	<cfelse>
		AND ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) 
		<cfif isDefined("system_money_info")>AND ACCOUNTS.ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#"></cfif><!--- sadece sistem para birimi olanlarda --->
	</cfif>
	<cfif isdefined("account_status")>
		AND ACCOUNT_STATUS = 1
	</cfif>	
	<cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
		AND ACCOUNTS.ACCOUNT_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND ACCOUNTS.ACCOUNT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
	</cfif>
	<cfif isDefined("attributes.acc_type") and len(attributes.acc_type)>
		AND ACCOUNTS.ACCOUNT_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_type#">
	</cfif>
	<cfif isDefined("money_info") and len(money_info)>
		AND ACCOUNTS.ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#money_info#">
	</cfif>
	<cfif isDefined("attributes.account_id_") and len(attributes.account_id_)>
		AND ACCOUNTS.ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id_#">
	</cfif>
	<cfif session.ep.isBranchAuthorization>
		AND ACCOUNTS.ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,'-')#">) 
	</cfif>
	ORDER BY
		BANK_BRANCH.BANK_NAME,
		ACCOUNTS.ACCOUNT_NAME
</cfquery>

