<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getCompenentFunction">
        <cfquery name="getAccounts_" datasource="#dsn#_#session.ep.company_id#">
			SELECT
				ACCOUNTS.ACCOUNT_STATUS,
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
				AND (ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn#_#session.ep.period_year#_#session.ep.company_id#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')  
				<cfif arguments.is_system_money eq 1>AND ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL'</cfif>
			<cfelse>
				AND ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn#_#session.ep.period_year#_#session.ep.company_id#.SETUP_MONEY) 
				<cfif arguments.is_system_money eq 1>AND ACCOUNTS.ACCOUNT_CURRENCY_ID = '#session.ep.money#'</cfif>
			</cfif>
			<cfif arguments.is_branch_control eq 1>
				AND ACCOUNTS.ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#)
			</cfif>
			<cfif arguments.is_open_accounts eq 1>
				AND ACCOUNTS.ACCOUNT_ID NOT IN (SELECT ACCOUNT_ID FROM ACCOUNTS_OPEN_CONTROL WHERE IS_OPEN = 1 AND PERIOD_ID = #session.ep.period_id#)
			</cfif>
			<cfif arguments.money_type_control eq 1>
				AND ACCOUNTS.ACCOUNT_CURRENCY_ID = '#session.ep.money#'
			<cfelseif arguments.money_type_control eq 2>
				AND ACCOUNTS.ACCOUNT_CURRENCY_ID <> '#session.ep.money#'
			</cfif>
			<cfif len(arguments.currency_id_info)>
				AND ACCOUNTS.ACCOUNT_CURRENCY_ID = '#arguments.currency_id_info#'
			</cfif>	
			<cfif isdefined("arguments.account_type")>
				AND ACCOUNTS.ACCOUNT_TYPE = #arguments.account_type#
			</cfif>	
			ORDER BY
				BANK_BRANCH.BANK_NAME,
				ACCOUNTS.ACCOUNT_NAME
        </cfquery>
        <cfreturn getAccounts_>
    </cffunction>
</cfcomponent>

