<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getCompenentFunction">
        <cfquery name="getCreditCards_" datasource="#dsn#_#session.ep.company_id#">
			SELECT
				ACCOUNTS.ACCOUNT_ID,
				ACCOUNTS.ACCOUNT_NAME,
				<cfif session.ep.period_year lt 2009>
					CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
				<cfelse>
					ACCOUNTS.ACCOUNT_CURRENCY_ID,
				</cfif>
				PAYMENT_RATE,
				PAYMENT_RATE_ACC,
				CPT.PAYMENT_TYPE_ID,
				CPT.CARD_NO
			FROM
				ACCOUNTS ACCOUNTS WITH (NOLOCK),
				CREDITCARD_PAYMENT_TYPE CPT WITH (NOLOCK)
			WHERE
				<cfif session.ep.period_year lt 2009>
					ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL' AND<!--- tüm pos işlemlerinde sadece ytl işlemler alınabiliyor sisteme --->
				<cfelse>
					ACCOUNTS.ACCOUNT_CURRENCY_ID = '#session.ep.money#' AND
				</cfif>
				ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT
				<cfif len(arguments.is_active) and arguments.is_active eq 1>
					AND CPT.IS_ACTIVE = 1
				</cfif>
				<cfif len(arguments.control_status) and arguments.control_status eq 1>
					AND ACCOUNT_STATUS = 1
				</cfif>
				<cfif arguments.is_branch_control eq 1>
					AND ACCOUNTS.ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#)
				</cfif>
			UNION ALL
				SELECT
					0 AS ACCOUNT_ID,
					'' AS ACCOUNT_NAME,
					'#session.ep.money#' AS ACCOUNT_CURRENCY_ID,
					PAYMENT_RATE,
					PAYMENT_RATE_ACC,
					CPT.PAYMENT_TYPE_ID,
					CPT.CARD_NO
				FROM
					CREDITCARD_PAYMENT_TYPE CPT WITH (NOLOCK)
				WHERE
					CPT.COMPANY_ID IS NOT NULL 
					<cfif len(arguments.is_active) and arguments.is_active eq 1>
						AND CPT.IS_ACTIVE = 1
					</cfif>
			ORDER BY
				ACCOUNTS.ACCOUNT_NAME
        </cfquery>
        <cfreturn getCreditCards_>
    </cffunction>
</cfcomponent>

