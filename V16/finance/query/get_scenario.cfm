<!---<cfquery name="GET_SETUP_SCENARIO" datasource="#DSN#">
	SELECT * FROM SETUP_SCENARIO
</cfquery>---><!--- 91354 --->
<cfif (isDefined('attributes.start_date') and isdate(attributes.start_date)) and (isDefined('attributes.until_date') and isdate(attributes.until_date)) or attributes.is_month_based eq 2 or attributes.is_month_based eq 3>
	<!---  : Bu if kontrol normalde gerekmiyor ancak bu sayfa finance.welcome da da alttaki query ler sebebiyle kullanılıyor --->
	<cfquery name="GET_SCEN" datasource="#DSN2#">
		SELECT
			SUM(ALACAK_CHEQUE_TOTAL) ALACAK_CHEQUE_TOTAL,
			SUM(ALACAK_VOUCHER_TOTAL) ALACAK_VOUCHER_TOTAL,
			SUM(ALACAK_CC_TOTAL) ALACAK_CC_TOTAL,		
			SUM(ALACAK_BANK_ORDER_TOTAL) ALACAK_BANK_ORDER_TOTAL,
			SUM(ALACAK_CREDIT_CONTRACT_TOTAL) ALACAK_CREDIT_CONTRACT_TOTAL,
			SUM(ALACAK_SCEN_EXPENSE_TOTAL) ALACAK_SCEN_EXPENSE_TOTAL,
			SUM(BORC_CHEQUE_TOTAL) BORC_CHEQUE_TOTAL,
			SUM(BORC_VOUCHER_TOTAL) BORC_VOUCHER_TOTAL,
			SUM(BORC_CC_TOTAL) BORC_CC_TOTAL,		
			SUM(BORC_BANK_ORDER_TOTAL) BORC_BANK_ORDER_TOTAL,
			SUM(BORC_CREDIT_CONTRACT_TOTAL) BORC_CREDIT_CONTRACT_TOTAL,
			SUM(BORC_SCEN_EXPENSE_TOTAL) BORC_SCEN_EXPENSE_TOTAL,
			SUM(ALACAK_BUDGET_TOTAL) ALACAK_BUDGET_TOTAL,
			SUM(BORC_BUDGET_TOTAL) BORC_BUDGET_TOTAL,
			SUM(BORC) BORC,
			SUM(ALACAK) ALACAK,
			THEDATE
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT
				SUM(ALACAK_CHEQUE_TOTAL) ALACAK_CHEQUE_TOTAL,
				SUM(ALACAK_VOUCHER_TOTAL) ALACAK_VOUCHER_TOTAL,
				SUM(ALACAK_CC_TOTAL) ALACAK_CC_TOTAL,		
				SUM(ALACAK_BANK_ORDER_TOTAL) ALACAK_BANK_ORDER_TOTAL,
				SUM(ALACAK_CREDIT_CONTRACT_TOTAL) ALACAK_CREDIT_CONTRACT_TOTAL,
				SUM(ALACAK_SCEN_EXPENSE_TOTAL) ALACAK_SCEN_EXPENSE_TOTAL,
				SUM(BORC_CHEQUE_TOTAL) BORC_CHEQUE_TOTAL,
				SUM(BORC_VOUCHER_TOTAL) BORC_VOUCHER_TOTAL,
				SUM(BORC_CC_TOTAL) BORC_CC_TOTAL,		
				SUM(BORC_BANK_ORDER_TOTAL) BORC_BANK_ORDER_TOTAL,
				SUM(BORC_CREDIT_CONTRACT_TOTAL) BORC_CREDIT_CONTRACT_TOTAL,
				SUM(BORC_SCEN_EXPENSE_TOTAL) BORC_SCEN_EXPENSE_TOTAL,
				SUM(ALACAK_BUDGET_TOTAL) ALACAK_BUDGET_TOTAL,
				SUM(BORC_BUDGET_TOTAL) BORC_BUDGET_TOTAL,
				0 AS BORC,
				0 AS ALACAK,
				<cfif attributes.is_month_based eq 2>MONTH(THEDATE) THEDATE
				<cfelseif attributes.is_month_based eq 3>datePart(ISO_WEEK,THEDATE) THEDATE
				<cfelse>THEDATE</cfif>
			FROM
				#dsn#_#session.ep.period_year#_#comp_ii#.GET_SCEN_LAST GET_SCEN_LAST
			WHERE
				<cfif attributes.is_month_based eq 2 OR attributes.is_month_based eq 3>
					THEDATE IS NOT NULL AND
					YEAR(THEDATE) = #session.ep.period_year#
				</cfif>
				<cfif attributes.is_month_based neq 2 AND attributes.is_month_based neq 3>
					THEDATE >= #attributes.start_date# AND
					THEDATE <= #attributes.until_date#
				</cfif>
				<cfif isdefined("attributes.scenario") and len(attributes.scenario)> 
					AND (SCEN_TYPE_ID = #attributes.scenario# OR SCEN_TYPE_ID = -1)
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_name)>
				AND PROJECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
			GROUP BY
				<cfif attributes.is_month_based eq 2>MONTH(THEDATE)
				<cfelseif attributes.is_month_based eq 3>datePart(ISO_WEEK,THEDATE)
			<cfelse>THEDATE</cfif>
			<cfif session.ep.our_company_info.is_paper_closer eq 1>
				UNION ALL
				SELECT
					0 AS ALACAK_CHEQUE_TOTAL,
					0 AS ALACAK_VOUCHER_TOTAL,
					0 AS ALACAK_CC_TOTAL,	
					0 AS ALACAK_BANK_ORDER_TOTAL,	
					0 AS ALACAK_CREDIT_CONTRACT_TOTAL,
					0 AS ALACAK_SCEN_EXPENSE_TOTAL,
					0 AS BORC_CHEQUE_TOTAL,
					0 AS BORC_VOUCHER_TOTAL,
					0 AS BORC_CC_TOTAL,	
					0 AS BORC_BANK_ORDER_TOTAL,	
					0 AS BORC_CREDIT_CONTRACT_TOTAL,
					0 AS BORC_SCEN_EXPENSE_TOTAL,
					0 AS BORC_BUDGET_TOTAL,
					0 AS ALACAK_BUDGET_TOTAL,
					SUM(BORC) BORC,
					SUM(ALACAK) ALACAK,
				<cfif attributes.is_month_based eq 2>MONTH(DUE_DATE) THEDATE
				<cfelseif attributes.is_month_based eq 3>datePart(ISO_WEEK,DUE_DATE) THEDATE
				<cfelse>DUE_DATE THEDATE</cfif>
				FROM
					#dsn#_#session.ep.period_year#_#comp_ii#.DAILY_DUE_REMAINDER DAILY_DUE_REMAINDER
				WHERE
				<cfif attributes.is_month_based neq 2 AND attributes.is_month_based neq 3>
					DUE_DATE >= #attributes.start_date# AND
					DUE_DATE <= #attributes.until_date#
				<cfelse>
					DUE_DATE IS NOT NULL AND
					YEAR(DUE_DATE) = #session.ep.period_year#
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_name)>
				AND PROJECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				GROUP BY
				<cfif attributes.is_month_based eq 2>MONTH(DUE_DATE)
				<cfelseif attributes.is_month_based eq 3>datePart(ISO_WEEK,DUE_DATE)
				<cfelse>DUE_DATE</cfif>
			</cfif>
	<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
	</cfloop>
		) AS GET_SCEN_LAST2
		GROUP BY
			THEDATE
		ORDER BY
			THEDATE
	</cfquery>
</cfif>
<cfquery name="GET_CASH_TOTAL" datasource="#DSN2#">
	SELECT
		SUM(CASH_TOTAL) AS CASH_TOTAL
	FROM
	(
	<cfloop list="#attributes.our_company_ids#" index="comp_ii">
		SELECT 
			SUM(BAKIYE*(SM.RATE2/SM.RATE1)) AS CASH_TOTAL
		FROM
			#dsn#_#session.ep.period_year#_#comp_ii#.CASH_REMAINDER_LAST CRL,
			#dsn#_#session.ep.period_year#_#comp_ii#.CASH CASH,
			#dsn#_#session.ep.period_year#_#comp_ii#.SETUP_MONEY SM
		WHERE
			CASH.CASH_ID = CRL.CASH_ID AND
			SM.MONEY = CASH.CASH_CURRENCY_ID
	<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
	</cfloop>
	) AS CASH_TOTAL2
</cfquery>
<cfquery name="GET_BANK_TOTAL" datasource="#DSN2#">
	SELECT 
		SUM(BANK_TOTAL) AS BANK_TOTAL
	FROM
	(
	<cfloop list="#attributes.our_company_ids#" index="comp_ii">
		SELECT 
			SUM(BAKIYE *(SM.RATE2/SM.RATE1)) AS BANK_TOTAL
		FROM
			#dsn#_#session.ep.period_year#_#comp_ii#.ACCOUNT_REMAINDER_LAST ACCOUNT_REMAINDER_LAST,
			#dsn#_#session.ep.period_year#_#comp_ii#.SETUP_MONEY SM
		WHERE
			SM.MONEY = ACCOUNT_REMAINDER_LAST.ACCOUNT_CURRENCY_ID
			<cfif session.ep.period_year lt 2009>
				OR 
				(SM.MONEY = 'YTL' AND ACCOUNT_REMAINDER_LAST.ACCOUNT_CURRENCY_ID = 'TL')
			</cfif>
	<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
	</cfloop>
	) AS BANK_TOTAL2
</cfquery>
<cfquery name="GET_VADELI_BANK_TOTAL" datasource="#DSN2#">
	SELECT 
		SUM(BANK_TOTAL) AS BANK_TOTAL
	FROM
	(
	<cfloop list="#attributes.our_company_ids#" index="comp_ii">
		SELECT 
			SUM(BAKIYE *(SM.RATE2/SM.RATE1)) AS BANK_TOTAL
		FROM
			#dsn#_#session.ep.period_year#_#comp_ii#.ACCOUNT_REMAINDER_LAST ACCOUNT_REMAINDER_LAST,
			#dsn#_#comp_ii#.ACCOUNTS ACC,
			#dsn#_#session.ep.period_year#_#comp_ii#.SETUP_MONEY SM
		WHERE
			SM.MONEY = ACCOUNT_REMAINDER_LAST.ACCOUNT_CURRENCY_ID AND
			ACC.ACCOUNT_ID = ACCOUNT_REMAINDER_LAST.ACCOUNT_ID
			<cfif session.ep.period_year lt 2009>
				OR 
				(SM.MONEY = 'YTL' AND ACCOUNT_REMAINDER_LAST.ACCOUNT_CURRENCY_ID = 'TL')
			</cfif>
			AND ACC.ACCOUNT_TYPE = 3
	<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
	</cfloop>
	) AS BANK_TOTAL2
</cfquery>
<cfquery name="GET_MK_TOTAL" datasource=#dsn2#>
	SELECT 
		SUM(MK_TOTAL) AS MK_TOTAL
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT 
				SUM(SS.ACTUAL_VALUE*SS.QUANTITY*(SM.RATE2/SM.RATE1)) AS MK_TOTAL
			FROM
				#dsn#_#comp_ii#.STOCKBONDS_SALEPURCHASE_ROW AS SSR
				JOIN #dsn#_#comp_ii#.STOCKBONDS_SALEPURCHASE AS SSP ON SSP.ACTION_ID = SSR.SALES_PURCHASE_ID
				JOIN #dsn#_#comp_ii#.STOCKBONDS AS SS ON SS.STOCKBOND_ID = SSR.STOCKBOND_ID
				LEFT JOIN #dsn#_#session.ep.period_year#_#comp_ii#.SETUP_MONEY SM ON SM.MONEY = SSR.OTHER_MONEY
				WHERE SSP.IS_SALES_PURCHASE = 0 AND (SELECT SUM(ISNULL(STOCKBOND_IN,0))-SUM(ISNULL(STOCKBOND_OUT,0)) FROM #dsn#_#comp_ii#.STOCKBONDS_INOUT WHERE STOCKBONDS_INOUT.STOCKBOND_ID = SS.STOCKBOND_ID) > 0
			<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS MK_TOTAL2
</cfquery>
<cfquery name="GET_COMP_DEBT" datasource="#DSN2#">
	SELECT
		SUM(TOTAL_COMP_DEBT) AS TOTAL_COMP_DEBT
	FROM
	(
	<cfloop list="#attributes.our_company_ids#" index="comp_ii">
		SELECT 
			SUM(BAKIYE) AS TOTAL_COMP_DEBT
		FROM
			#dsn#_#session.ep.period_year#_#comp_ii#.COMPANY_REMAINDER
		WHERE
			BAKIYE < 0
	<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
	</cfloop>
	) AS TOTAL_COMP_DEBT2
</cfquery>
<cfset TOTAL_COMP_DEBT=get_comp_debt.TOTAL_COMP_DEBT>
<cfif not len(get_comp_debt.TOTAL_COMP_DEBT)>
	<cfset TOTAL_COMP_DEBT=0>
</cfif>
<cfquery name="GET_COMP_CLAIM" datasource="#DSN2#">
	SELECT
		SUM(TOTAL_COMP_CLAIM) AS TOTAL_COMP_CLAIM
	FROM
	(
	<cfloop list="#attributes.our_company_ids#" index="comp_ii">
		SELECT 
			SUM(BAKIYE) AS TOTAL_COMP_CLAIM
		FROM
			#dsn#_#session.ep.period_year#_#comp_ii#.COMPANY_REMAINDER
		WHERE
			BAKIYE >= 0
	<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
	</cfloop>
	) AS TOTAL_COMP_CLAIM2
</cfquery>
<cfset TOTAL_COMP_CLAIM=get_comp_claim.TOTAL_COMP_CLAIM>
<cfif not len(get_comp_claim.TOTAL_COMP_CLAIM)>
	<cfset TOTAL_COMP_CLAIM=0>
</cfif>
<cfquery name="GET_CONS_DEBT" datasource="#DSN2#">
	SELECT
		SUM(TOTAL_CONS_DEBT) AS TOTAL_CONS_DEBT
	FROM
	(
	<cfloop list="#attributes.our_company_ids#" index="comp_ii">
		SELECT 
			SUM(BAKIYE) AS TOTAL_CONS_DEBT
		FROM
			#dsn#_#session.ep.period_year#_#comp_ii#.CONSUMER_REMAINDER
		WHERE
			BAKIYE < 0
	<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
	</cfloop>
	) AS TOTAL_CONS_DEBT2
</cfquery>
<cfset TOTAL_CONS_DEBT=get_cons_debt.TOTAL_CONS_DEBT>
<cfif not len(get_cons_debt.TOTAL_CONS_DEBT)>
	<cfset TOTAL_CONS_DEBT=0>
</cfif>
<cfquery name="GET_CONS_CLAIM" datasource="#DSN2#">
	SELECT
		SUM(TOTAL_CONS_CLAIM) AS TOTAL_CONS_CLAIM
	FROM
	(
	<cfloop list="#attributes.our_company_ids#" index="comp_ii">
		SELECT 
			SUM(BAKIYE) AS TOTAL_CONS_CLAIM
		FROM
			#dsn#_#session.ep.period_year#_#comp_ii#.CONSUMER_REMAINDER
		WHERE
			BAKIYE >= 0
	<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
	</cfloop>
	) AS TOTAL_CONS_CLAIM2
</cfquery>
<cfset TOTAL_CONS_CLAIM=get_cons_claim.TOTAL_CONS_CLAIM>
<cfif not len(get_cons_claim.TOTAL_CONS_CLAIM)>
	<cfset TOTAL_CONS_CLAIM=0>
</cfif>
<cfquery name="GET_EMP_DEBT" datasource="#DSN2#">
	SELECT
		SUM(TOTAL_EMP_DEBT) AS TOTAL_EMP_DEBT
	FROM
	(
	<cfloop list="#attributes.our_company_ids#" index="comp_ii">
		SELECT 
			SUM(BAKIYE) AS TOTAL_EMP_DEBT
		FROM
			#dsn#_#session.ep.period_year#_#comp_ii#.EMPLOYEE_REMAINDER
		WHERE
			BAKIYE < 0
	<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
	</cfloop>
	) AS TOTAL_EMP_DEBT2
</cfquery>
<cfset TOTAL_EMP_DEBT=GET_EMP_DEBT.TOTAL_EMP_DEBT>
<cfif not len(GET_EMP_DEBT.TOTAL_EMP_DEBT)>
	<cfset TOTAL_EMP_DEBT=0>
</cfif>
<cfquery name="GET_EMP_CLAIM" datasource="#DSN2#">
	SELECT
		SUM(TOTAL_EMP_CLAIM) AS TOTAL_EMP_CLAIM
	FROM
	(
	<cfloop list="#attributes.our_company_ids#" index="comp_ii">
		SELECT 
			SUM(BAKIYE) AS TOTAL_EMP_CLAIM
		FROM
			#dsn#_#session.ep.period_year#_#comp_ii#.EMPLOYEE_REMAINDER
		WHERE
			BAKIYE >= 0
	<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
	</cfloop>
	) AS TOTAL_EMP_CLAIM2
</cfquery>
<cfset TOTAL_EMP_CLAIM=GET_EMP_CLAIM.TOTAL_EMP_CLAIM>
<cfif not len(GET_EMP_CLAIM.TOTAL_EMP_CLAIM)>
	<cfset TOTAL_EMP_CLAIM=0>
</cfif>
<cfset total_debt = TOTAL_COMP_DEBT + TOTAL_CONS_DEBT + TOTAL_EMP_DEBT>
<cfset total_claim = TOTAL_COMP_CLAIM + TOTAL_CONS_CLAIM + TOTAL_EMP_CLAIM>
<cfquery name="GET_CREDIT_CARD_PAYMENTS" datasource="#dsn3#">
SELECT SUM(CASE WHEN ACTION_TYPE_ID IN (52,69,241,2410) THEN AMOUNT WHEN ACTION_TYPE_ID=245 THEN -AMOUNT END) AS VALUE
FROM (
		SELECT 
			CREDIT_CARD_BANK_PAYMENTS_ROWS.AMOUNT,
			CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID,
			CREDIT_CARD_BANK_PAYMENTS.ACTION_FROM_COMPANY_ID,
			CREDIT_CARD_BANK_PAYMENTS.CONSUMER_ID,
			CREDIT_CARD_BANK_PAYMENTS.STORE_REPORT_DATE,
			CREDIT_CARD_BANK_PAYMENTS.SALES_CREDIT,
			CREDIT_CARD_BANK_PAYMENTS.TO_BRANCH_ID,
			ACCOUNTS.ACCOUNT_NAME AS ACCOUNT_BRANCH,
			ACCOUNTS.ACCOUNT_ID,
			CREDITCARD_PAYMENT_TYPE.CARD_NO,
			CREDIT_CARD_BANK_PAYMENTS.ACTION_TYPE,
			CREDIT_CARD_BANK_PAYMENTS.ACTION_TYPE_ID
		FROM
			CREDIT_CARD_BANK_PAYMENTS_ROWS,
			CREDIT_CARD_BANK_PAYMENTS,
			ACCOUNTS,
			CREDITCARD_PAYMENT_TYPE
		WHERE
			CREDIT_CARD_BANK_PAYMENTS_ROWS.CREDITCARD_PAYMENT_ID = CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID AND
			CREDIT_CARD_BANK_PAYMENTS.PAYMENT_TYPE_ID = CREDITCARD_PAYMENT_TYPE.PAYMENT_TYPE_ID AND
			CREDIT_CARD_BANK_PAYMENTS.ACTION_TO_ACCOUNT_ID = ACCOUNTS.ACCOUNT_ID AND
			CREDIT_CARD_BANK_PAYMENTS.STORE_REPORT_ID IS NULL AND
			CREDIT_CARD_BANK_PAYMENTS_ROWS.AMOUNT > 0  AND 
			ISNULL(CREDIT_CARD_BANK_PAYMENTS.IS_VOID,0) <> 1 AND	
			ISNULL(CREDIT_CARD_BANK_PAYMENTS.RELATION_CREDITCARD_PAYMENT_ID,0) NOT IN (SELECT CCBP.CREDITCARD_PAYMENT_ID FROM CREDIT_CARD_BANK_PAYMENTS CCBP WHERE ISNULL(CCBP.IS_VOID,0) = 1)
 			AND CREDIT_CARD_BANK_PAYMENTS_ROWS.BANK_ACTION_ID IS NULL 
			) AS VALUE2
</cfquery>
<cfquery name="GET_PAYMENTS_WITH_CC" datasource="#dsn3#">
	SELECT
		SUM(VALUE) AS VALUE
	FROM
	(
	<cfloop list="#attributes.our_company_ids#" index="comp_ii">
		SELECT
			(INSTALLMENT_AMOUNT*(CCBM.RATE2/CCBM.RATE1))-(ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CREDIT_CARD_BANK_EXPENSE_RELATIONS WHERE CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CREDIT_CARD_BANK_EXPENSE_ROWS.CC_BANK_EXPENSE_ROWS_ID),0)) VALUE
		FROM			
			#dsn#_#comp_ii#.CREDIT_CARD_BANK_EXPENSE_ROWS CREDIT_CARD_BANK_EXPENSE_ROWS,
			#dsn#_#comp_ii#.CREDIT_CARD_BANK_EXPENSE CBE,
			#dsn#_#comp_ii#.CREDIT_CARD_BANK_EXPENSE_MONEY CCBM
		WHERE
			CREDIT_CARD_BANK_EXPENSE_ROWS.CREDITCARD_EXPENSE_ID = CBE.CREDITCARD_EXPENSE_ID AND
			CCBM.ACTION_ID =  CBE.CREDITCARD_EXPENSE_ID AND 
			CCBM.MONEY_TYPE = CBE.ACTION_CURRENCY_ID AND
			ROUND((INSTALLMENT_AMOUNT-(ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CREDIT_CARD_BANK_EXPENSE_RELATIONS WHERE CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CREDIT_CARD_BANK_EXPENSE_ROWS.CC_BANK_EXPENSE_ROWS_ID),0))),2) > 0 AND
			CBE.PROCESS_TYPE = 242 <!--- kredi kartı ile odemeler (iptaller dahil değil) --->
	<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')>UNION ALL </cfif>
	</cfloop>
	) AS VALUE2
</cfquery>
<cfquery name="GET_GELEN_BANK_ORDERS" datasource="#dsn2#">
	SELECT
		SUM(ACTION_VALUE) AS ACTION_VALUE
	FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT
				SUM(VALUE1) ACTION_VALUE
			FROM
			(	
				SELECT
					SUM(BON.ACTION_VALUE*(SM.RATE2/SM.RATE1)) AS VALUE1
				FROM
					#dsn#_#session.ep.period_year#_#comp_ii#.BANK_ORDERS BON,
					#dsn#_#session.ep.period_year#_#comp_ii#.SETUP_MONEY SM
				WHERE
					(BON.IS_PAID = 0 OR BON.IS_PAID IS NULL)
					AND BON.ACTION_MONEY = SM.MONEY
					AND BANK_ORDER_TYPE = 251
			) GET_BANK_ORDERS
			<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS VALUE2
</cfquery>
<cfquery name="GET_GIDEN_BANK_ORDERS" datasource="#dsn2#">
	SELECT
		SUM(ACTION_VALUE) AS ACTION_VALUE
	FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT
				SUM(VALUE1) ACTION_VALUE
			FROM
			(	
				SELECT
					SUM(BON.ACTION_VALUE*(SM.RATE2/SM.RATE1)) AS VALUE1
				FROM
					#dsn#_#session.ep.period_year#_#comp_ii#.BANK_ORDERS BON,
					#dsn#_#session.ep.period_year#_#comp_ii#.SETUP_MONEY SM
				WHERE
					(BON.IS_PAID = 0 OR BON.IS_PAID IS NULL)
					AND BON.ACTION_MONEY = SM.MONEY
					AND BANK_ORDER_TYPE = 260
			) GET_BANK_ORDERS
			<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS VALUE2
</cfquery>
<cfquery name="GET_GELEN_BANK_ORDERS_ALL" datasource="#dsn2#">
	SELECT
		SUM(ACTION_VALUE) AS ACTION_VALUE
	FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT
				SUM(VALUE1) ACTION_VALUE
			FROM
			(	
				SELECT
					SUM(BON.ACTION_VALUE*(SM.RATE2/SM.RATE1)) AS VALUE1
				FROM
					#dsn#_#session.ep.period_year#_#comp_ii#.BANK_ORDERS BON,
					#dsn#_#session.ep.period_year#_#comp_ii#.SETUP_MONEY SM
				WHERE
					(BON.IS_PAID = 0 OR BON.IS_PAID IS NULL)
					AND BON.ACTION_MONEY = SM.MONEY
					AND BANK_ORDER_TYPE = 251
					<cfif is_cari_bank_orders eq 1>
						AND BANK_ORDER_ID IN(SELECT CR.ACTION_ID FROM #dsn#_#session.ep.period_year#_#comp_ii#.CARI_ROWS CR WHERE CR.ACTION_TYPE_ID = 251 AND CR.ACTION_ID = BANK_ORDER_ID)
					</cfif>
			) GET_BANK_ORDERS
			<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS VALUE2
</cfquery>
<cfquery name="GET_GIDEN_BANK_ORDERS_ALL" datasource="#dsn2#">
	SELECT
		SUM(ACTION_VALUE) AS ACTION_VALUE
	FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT
				SUM(VALUE1) ACTION_VALUE
			FROM
			(	
				SELECT
					SUM(BON.ACTION_VALUE*(SM.RATE2/SM.RATE1)) AS VALUE1
				FROM
					#dsn#_#session.ep.period_year#_#comp_ii#.BANK_ORDERS BON,
					#dsn#_#session.ep.period_year#_#comp_ii#.SETUP_MONEY SM
				WHERE
					(BON.IS_PAID = 0 OR BON.IS_PAID IS NULL)
					AND BON.ACTION_MONEY = SM.MONEY
					AND BANK_ORDER_TYPE = 260
					<cfif is_cari_bank_orders eq 1>
						AND BANK_ORDER_ID IN(SELECT CR.ACTION_ID FROM #dsn#_#session.ep.period_year#_#comp_ii#.CARI_ROWS CR WHERE CR.ACTION_TYPE_ID = 260 AND CR.ACTION_ID = BANK_ORDER_ID)
					</cfif>
			) GET_BANK_ORDERS
			<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS VALUE2
</cfquery>
<cfscript>
	getCredit_ = createobject("component","V16.credit.cfc.credit");
	getCredit_.dsn3 = dsn3;
</cfscript>
<cfscript>
	getTotalCreditPayment = getCredit_.getTotalCreditPayment(
		listing_type : 1,
		is_active : 1,
		is_scenario_control : 1 
	);
</cfscript>
<cfset BORC_TUTAR = 0>
<cfset ALACAK_TUTAR = 0>
<cfloop query="getTotalCreditPayment">
    <cfquery name="GET_RATES" datasource="#dsn#">
        SELECT RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND COMPANY_ID = #session.ep.company_id# AND MONEY = '#PARA_BIRIMI#' 
    </cfquery>
    <cfset ALACAK_TUTAR = ALACAK_TUTAR + REMAINING_TOTAL_COLLECTION * GET_RATES.RATE2>
    <cfset BORC_TUTAR = BORC_TUTAR - REMAINING_TOTAL_PAYMENT * GET_RATES.RATE2> 
</cfloop>
<!--- bütçelenmeiş alacak-borçlar --->
<cfquery name="GET_LAST_SCEN_INFO" dbtype="query">
	SELECT SUM(ALACAK_SCEN_EXPENSE_TOTAL) ALACAK_SCEN_TOTAL,SUM(BORC_SCEN_EXPENSE_TOTAL) BORC_SCEN_TOTAL FROM GET_SCEN
</cfquery>
<cfquery name="GET_BUDGET_INFO" datasource="#dsn#">
	SELECT
		SUM(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME)INCOME_TOTAL,
		SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE) EXPENSE_TOTAL
	FROM
		BUDGET_PLAN,
		BUDGET_PLAN_ROW
	WHERE
		BUDGET_PLAN.BUDGET_PLAN_ID = BUDGET_PLAN_ROW.BUDGET_PLAN_ID AND
		BUDGET_PLAN.IS_SCENARIO = 1 AND
		BUDGET_PLAN_ROW.PLAN_DATE >= #attributes.start_date# AND
		BUDGET_PLAN_ROW.PLAN_DATE <= #attributes.until_date#
</cfquery>
<!--- bütçelenmemiş alacak-borçlar --->

