<cfif not isDefined("attributes.is_month_based")>
	<cf_date tarih="attributes.action_date">
	<cf_date tarih="attributes.until_date">
</cfif>
<cfset bugun = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#') >
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
		THEDATE
	FROM
		GET_SCEN_LAST
	WHERE
			(
				<cfif len(attributes.project_id) and len(attributes.project_name)>
				 PROJECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND
				</cfif>
				<cfif isDefined("attributes.is_month_based") and attributes.is_month_based eq 2>
					MONTH(THEDATE) >= #attributes.until_date# AND
					YEAR(THEDATE) = #session.ep.period_year# AND
				<cfelseif isDefined("attributes.is_month_based") and attributes.is_month_based eq 3>
					datePart(ISO_WEEK,THEDATE) >= #attributes.until_date# AND
					YEAR(THEDATE) = #session.ep.period_year# AND
				<cfelse>
					THEDATE >= #attributes.until_date# AND 
				</cfif>
				SCEN_TYPE_ID IN (-1,-2,-3,-4,-5)
			)
		OR
			(
				<cfif len(attributes.project_id) and len(attributes.project_name)>
				 PROJECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND
				</cfif>
				<cfif isDefined("attributes.is_month_based") and attributes.is_month_based eq 2>
					MONTH(THEDATE) >= #attributes.until_date# AND
					YEAR(THEDATE) = #session.ep.period_year# AND
				<cfelseif isDefined("attributes.is_month_based") and attributes.is_month_based eq 3>
					YEAR(THEDATE) = #session.ep.period_year# AND
					datePart(ISO_WEEK,THEDATE) >= #attributes.until_date# AND
				<cfelse>
					THEDATE >= #attributes.until_date# AND 
				</cfif>
				(SCEN_TYPE_ID >= 0 <cfif isdefined("attributes.scenario") and len(attributes.scenario)> OR SCEN_TYPE_ID = #attributes.scenario#</cfif>)
			)
	GROUP BY
		THEDATE
	ORDER BY
		THEDATE
</cfquery>
<!--- Cekler --->
<cfquery name="GET_CHEQUES" datasource="#DSN2#">
	SELECT
		C.CHEQUE_ID,
		C.CHEQUE_NO,
		C.CHEQUE_STATUS_ID,
		C.CHEQUE_DUEDATE,
		(C.CHEQUE_VALUE*(SM.RATE2/SM.RATE1)) CHEQUE_VALUE,
		C.CHEQUE_VALUE ISLEM_TUTAR,
		C.CURRENCY_ID,
		CASE 
			WHEN C.COMPANY_ID IS NOT NULL THEN (SELECT FULLNAME FROM #dsn_alias#.COMPANY WHERE COMPANY.COMPANY_ID = C.COMPANY_ID)
		 	WHEN C.CONSUMER_ID IS NOT NULL THEN(SELECT CONSUMER_NAME +''+ CONSUMER_SURNAME FROM #dsn_alias#.CONSUMER WHERE CONSUMER.CONSUMER_ID = C.CONSUMER_ID)
			ELSE (SELECT EMPLOYEE_NAME +''+ EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES WHERE EMPLOYEES.EMPLOYEE_ID = C.EMPLOYEE_ID)
		END AS NAME
	FROM
		CHEQUE C,
		SETUP_MONEY	SM
	WHERE
		<cfif isDefined("attributes.is_month_based") and attributes.is_month_based eq 2>
			MONTH(C.CHEQUE_DUEDATE) = #attributes.action_date# AND 
			YEAR(C.CHEQUE_DUEDATE) = #session.ep.period_year# AND 
			<cfelseif isDefined("attributes.is_month_based") and attributes.is_month_based eq 3>
			datePart(ISO_WEEK,C.CHEQUE_DUEDATE) = #attributes.until_date# AND
			YEAR(C.CHEQUE_DUEDATE) = #session.ep.period_year# AND
		<cfelse>
			C.CHEQUE_DUEDATE = #attributes.action_date# AND 
		</cfif>
		C.CHEQUE_STATUS_ID IN (1,2,13,6) AND
		C.CURRENCY_ID = SM.MONEY
		<cfif len(attributes.project_id) and len(attributes.project_name)>
			AND (SELECT TOP 1 P.PROJECT_ID FROM CHEQUE_HISTORY CH,PAYROLL P WHERE CH.PAYROLL_ID=P.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID)=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		</cfif>
	ORDER BY
		C.CHEQUE_DUEDATE
</cfquery>
<!--- Senetler --->
<cfquery name="GET_VOUCHERS" datasource="#DSN2#">
	SELECT
		V.VOUCHER_ID,
		V.VOUCHER_NO,
		V.VOUCHER_STATUS_ID,
		V.VOUCHER_DUEDATE,
		(V.VOUCHER_VALUE*(SM.RATE2/SM.RATE1)) VOUCHER_VALUE,
		V.VOUCHER_VALUE ISLEM_TUTAR,
		V.CURRENCY_ID,
		CASE 
			WHEN V.COMPANY_ID IS NOT NULL THEN (SELECT FULLNAME FROM #dsn_alias#.COMPANY WHERE COMPANY.COMPANY_ID = V.COMPANY_ID)
		 	WHEN V.CONSUMER_ID IS NOT NULL THEN(SELECT CONSUMER_NAME +''+ CONSUMER_SURNAME FROM #dsn_alias#.CONSUMER WHERE CONSUMER.CONSUMER_ID = V.CONSUMER_ID)
			ELSE (SELECT EMPLOYEE_NAME +''+ EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES WHERE EMPLOYEES.EMPLOYEE_ID = V.EMPLOYEE_ID)
		END AS NAME
	FROM
		VOUCHER V,
		SETUP_MONEY	SM
	WHERE
	
		<cfif isDefined("attributes.is_month_based") and attributes.is_month_based eq 2>
			MONTH(V.VOUCHER_DUEDATE) = #attributes.action_date# AND 
			YEAR(V.VOUCHER_DUEDATE) = #session.ep.period_year# AND 
		<cfelseif isDefined("attributes.is_month_based") and attributes.is_month_based eq 3>
					datePart(ISO_WEEK,V.VOUCHER_DUEDATE) = #attributes.until_date# AND
					YEAR(V.VOUCHER_DUEDATE) = #session.ep.period_year# AND 
		<cfelse>
			V.VOUCHER_DUEDATE = #attributes.action_date# AND 
		</cfif>
		V.VOUCHER_STATUS_ID IN (1,2,13,6) AND
		V.CURRENCY_ID = SM.MONEY
		<cfif len(attributes.project_id) and len(attributes.project_name)>
			AND (SELECT TOP 1 VP.PROJECT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VH WHERE VH.PAYROLL_ID=VP.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID)=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		</cfif>
	ORDER BY
		V.VOUCHER_DUEDATE
</cfquery>
<!--- Kredi Karti Tahsilati --->
<cfquery name="GET_CREDIT_CARD_BANK_PAYMENT" datasource="#DSN2#">
	SELECT
		SUM(CCP.AMOUNT) AS BORC,
		0 AS ALACAK,
		CCP.BANK_ACTION_DATE,
		CC.ACTION_CURRENCY_ID,
		CC.CREDITCARD_PAYMENT_ID,
		COMPANY.FULLNAME NAME,
		CC.ACTION_TYPE_ID,
		CONSUMER.CONSUMER_NAME +''+ CONSUMER.CONSUMER_SURNAME NAME
	FROM
		#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS CCP,
		#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CC
		LEFT JOIN #dsn_alias#.COMPANY ON CC.ACTION_FROM_COMPANY_ID = COMPANY.COMPANY_ID
		LEFT JOIN #dsn_alias#.CONSUMER ON CC.CONSUMER_ID = CONSUMER.CONSUMER_ID
	WHERE
		CC.CREDITCARD_PAYMENT_ID = CCP.CREDITCARD_PAYMENT_ID AND
		ISNULL(CC.IS_VOID,0) <> 1 AND
		ISNULL(CC.RELATION_CREDITCARD_PAYMENT_ID,0) NOT IN (SELECT CCBP.CREDITCARD_PAYMENT_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CCBP WHERE ISNULL(CCBP.IS_VOID,0) = 1) AND
		<cfif len(attributes.project_id) and len(attributes.project_name)>
		CC.PROJECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND
		</cfif>
		<cfif isDefined("attributes.is_month_based") and attributes.is_month_based eq 2>
			MONTH(BANK_ACTION_DATE) = #attributes.action_date# AND 
			YEAR(BANK_ACTION_DATE) = #session.ep.period_year# AND 
		<cfelseif isDefined("attributes.is_month_based") and attributes.is_month_based eq 3>
			datePart(ISO_WEEK,BANK_ACTION_DATE) = #attributes.until_date# AND
			YEAR(BANK_ACTION_DATE) = #session.ep.period_year# AND 
		<cfelse>
			BANK_ACTION_DATE = #attributes.action_date# AND 
		</cfif>
		BANK_ACTION_ID IS NULL AND
		AMOUNT > 0
	GROUP BY
		CCP.BANK_ACTION_DATE,
		CC.ACTION_CURRENCY_ID,
		CC.ACTION_TYPE_ID,
		CC.CREDITCARD_PAYMENT_ID,
		COMPANY.FULLNAME,
		CONSUMER.CONSUMER_NAME +''+ CONSUMER.CONSUMER_SURNAME
	ORDER BY
		BANK_ACTION_DATE
</cfquery>
<!--- Kredi Tahsilatlari --->
<cfquery name="GET_CREDIT_CONTRACT_ROW" datasource="#DSN2#">
	SELECT
		(CC.TOTAL_PRICE*(SM.RATE2/SM.RATE1)) AS BORC,
		0 AS ALACAK,
		CC.PROCESS_DATE,
		CC.OTHER_MONEY,
		CC.CREDIT_CONTRACT_ID,
		CC.TOTAL_PRICE ISLEM_TUTAR,
		C.MONEY_TYPE,
		CASE 
			WHEN C.COMPANY_ID IS NOT NULL THEN (SELECT FULLNAME FROM #dsn_alias#.COMPANY WHERE COMPANY.COMPANY_ID = C.COMPANY_ID)
			ELSE (SELECT EMPLOYEE_NAME +''+ EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES WHERE EMPLOYEES.EMPLOYEE_ID = C.CREDIT_EMP_ID)
		END AS NAME
	FROM
		#dsn3_alias#.CREDIT_CONTRACT_ROW CC,
		#dsn3_alias#.CREDIT_CONTRACT C,
		SETUP_MONEY SM
	WHERE
		C.CREDIT_CONTRACT_ID = CC.CREDIT_CONTRACT_ID AND
		C.IS_SCENARIO = 1 AND
	<cfif session.ep.period_year lt 2009>
		((CC.OTHER_MONEY = 'TL' AND SM.MONEY = 'YTL') OR SM.MONEY = CC.OTHER_MONEY) AND
	<cfelse>
		((CC.OTHER_MONEY = 'YTL' AND SM.MONEY = 'TL') OR SM.MONEY = CC.OTHER_MONEY) AND
	</cfif>	
	<cfif len(attributes.project_id) and len(attributes.project_name)>
		C.PROJECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND
		</cfif>
		<cfif isDefined("attributes.is_month_based") and attributes.is_month_based eq 2>
			MONTH(PROCESS_DATE) = #attributes.action_date# AND 
			YEAR(PROCESS_DATE) = #session.ep.period_year# AND 
		<cfelseif isDefined("attributes.is_month_based") and attributes.is_month_based eq 3>
			datePart(ISO_WEEK,PROCESS_DATE) = #attributes.until_date# AND
			YEAR(PROCESS_DATE) = #session.ep.period_year# AND 
		<cfelse>
			PROCESS_DATE = #attributes.action_date# AND 
		</cfif>
		CREDIT_CONTRACT_TYPE = 2 AND
		TOTAL_PRICE > 0 AND
		CC.IS_PAID = 0
	ORDER BY
		CC.PROCESS_DATE
</cfquery>
<!--- Kredi Odemeleri --->
<cfquery name="GET_CREDIT_CONTRACT_PAYMENTS" datasource="#DSN2#">
	SELECT
		(CC.TOTAL_PRICE*(SM.RATE2/SM.RATE1)) AS ALACAK,
		0 AS BORC,
		CC.PROCESS_DATE,
		CC.OTHER_MONEY,
		CC.CREDIT_CONTRACT_ID,
		CC.TOTAL_PRICE ISLEM_TUTAR,
		C.MONEY_TYPE,
		CASE 
			WHEN C.COMPANY_ID IS NOT NULL THEN (SELECT FULLNAME FROM #dsn_alias#.COMPANY WHERE COMPANY.COMPANY_ID = C.COMPANY_ID)
			ELSE (SELECT EMPLOYEE_NAME +''+ EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES WHERE EMPLOYEES.EMPLOYEE_ID = C.CREDIT_EMP_ID)
		END AS NAME
	FROM
		#dsn3_alias#.CREDIT_CONTRACT_ROW CC,
		#dsn3_alias#.CREDIT_CONTRACT C,
		SETUP_MONEY SM
	WHERE
		C.CREDIT_CONTRACT_ID = CC.CREDIT_CONTRACT_ID AND
		C.IS_SCENARIO = 1 AND
	<cfif session.ep.period_year lt 2009>
		((CC.OTHER_MONEY = 'TL' AND SM.MONEY = 'YTL') OR SM.MONEY = CC.OTHER_MONEY) AND
	<cfelse>
		((CC.OTHER_MONEY = 'YTL' AND SM.MONEY = 'TL') OR SM.MONEY = CC.OTHER_MONEY) AND
	</cfif>	
	<cfif len(attributes.project_id) and len(attributes.project_name)>
		C.PROJECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND
		</cfif>
		<cfif isDefined("attributes.is_month_based") and attributes.is_month_based eq 2>
			MONTH(PROCESS_DATE) = #attributes.action_date# AND 
			YEAR(PROCESS_DATE) = #session.ep.period_year# AND 
		<cfelseif isDefined("attributes.is_month_based") and attributes.is_month_based eq 3>
			datePart(ISO_WEEK,PROCESS_DATE) = #attributes.until_date# AND
			YEAR(PROCESS_DATE) = #session.ep.period_year# AND 
		<cfelse>
			PROCESS_DATE = #attributes.action_date# AND 
		</cfif>
		CREDIT_CONTRACT_TYPE = 1 AND
		TOTAL_PRICE > 0 AND
		CC.IS_PAID = 0
	ORDER BY
		CC.PROCESS_DATE
</cfquery>
<!--- Gelir/Gider - cari hesabi yok --->
<cfquery name="GET_SCEN_ROW" datasource="#DSN3#">
	SELECT
		SEP.START_DATE,
		SEP.PERIOD_ROW_ID,
		SEP.PERIOD_DETAIL,
		(SEP.PERIOD_VALUE*(RATE2/RATE1)) PERIOD_VALUE,
		SEP.PERIOD_VALUE ISLEM_TUTAR,
		SEP.PERIOD_CURRENCY,
		SEP.TYPE,
		SC.SCENARIO
	FROM
		SCEN_EXPENSE_PERIOD_ROWS AS SEP,
		#dsn2_alias#.SETUP_MONEY AS SM,
		#dsn_alias#.SETUP_SCENARIO AS SC
	WHERE
		SEP.SCEN_EXPENSE_STATUS = 1 AND 
		SEP.SCENARIO_TYPE_ID = SC.SCENARIO_ID AND
		<cfif len(attributes.project_id) and len(attributes.project_name)>
			SEP.PROJECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND
		</cfif>
		<cfif isDefined("attributes.is_month_based") and attributes.is_month_based eq 2>
			MONTH(SEP.START_DATE) = #attributes.action_date# AND 
			YEAR(SEP.START_DATE) = #session.ep.period_year# AND 
		<cfelseif isDefined("attributes.is_month_based") and attributes.is_month_based eq 3>
			datePart(ISO_WEEK,SEP.START_DATE) = #attributes.until_date# AND
			YEAR(SEP.START_DATE) = #session.ep.period_year# AND 
		<cfelse>
			SEP.START_DATE = #attributes.ACTION_DATE# AND
		</cfif>
		SEP.PERIOD_CURRENCY = SM.MONEY
		<cfif isDefined('attributes.scenario') and len(attributes.scenario)>
			AND SEP.SCENARIO_TYPE_ID = #attributes.scenario#
		</cfif>
	UNION ALL
	SELECT
		SEP.START_DATE,
		SEP.PERIOD_ROW_ID,
		SEP.PERIOD_DETAIL,
		(SEP.PERIOD_VALUE*(RATE2/RATE1)) PERIOD_VALUE,
		SEP.PERIOD_VALUE ISLEM_TUTAR,
		SEP.PERIOD_CURRENCY,
		SEP.TYPE,
		'' SCENARIO
	FROM
		SCEN_EXPENSE_PERIOD_ROWS AS SEP,
		#dsn2_alias#.SETUP_MONEY AS SM
	WHERE
		SEP.SCEN_EXPENSE_STATUS = 1 AND 
		SEP.SCENARIO_TYPE_ID = 0 AND
		<cfif len(attributes.project_id) and len(attributes.project_name)>
			SEP.PROJECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND
		</cfif>
		<cfif isDefined("attributes.is_month_based") and attributes.is_month_based eq 2>
			MONTH(SEP.START_DATE) = #attributes.action_date# AND 
			YEAR(SEP.START_DATE) = #session.ep.period_year# AND 
		<cfelseif isDefined("attributes.is_month_based") and attributes.is_month_based eq 3>
					datePart(ISO_WEEK,SEP.START_DATE) = #attributes.until_date# AND
					YEAR(SEP.START_DATE) = #session.ep.period_year# AND 
		<cfelse>
			SEP.START_DATE = #attributes.ACTION_DATE# AND
		</cfif>
		SEP.PERIOD_CURRENCY = SM.MONEY
		<cfif isDefined('attributes.scenario') and len(attributes.scenario)>
			AND SEP.SCENARIO_TYPE_ID = #attributes.scenario#
		</cfif>
	ORDER BY
		SEP.START_DATE
</cfquery>
<!--- Kredi Kartiyla Odemeler --->
<cfquery name="get_cc_exp_row" datasource="#DSN3#">
	SELECT
		(INSTALLMENT_AMOUNT-(ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CREDIT_CARD_BANK_EXPENSE_RELATIONS WHERE CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CREDIT_CARD_BANK_EXPENSE_ROWS.CC_BANK_EXPENSE_ROWS_ID),0))) PERIOD_VALUE,
		(INSTALLMENT_AMOUNT-(ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CREDIT_CARD_BANK_EXPENSE_RELATIONS WHERE CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CREDIT_CARD_BANK_EXPENSE_ROWS.CC_BANK_EXPENSE_ROWS_ID),0)))*(CREDIT_CARD_BANK_EXPENSE_MONEY.RATE2/CREDIT_CARD_BANK_EXPENSE_MONEY.RATE1) PERIOD_VALUE_SYSTEM,
		dateadd(d,ISNULL(CREDIT_CARD.PAYMENT_DAY,0),CREDIT_CARD_BANK_EXPENSE_ROWS.ACC_ACTION_DATE) LAST_PAYMENT_DATE,
		CREDIT_CARD_BANK_EXPENSE.CREDITCARD_EXPENSE_ID,
		CREDIT_CARD_BANK_EXPENSE.ACTION_CURRENCY_ID,
		ACC_ACTION_DATE,
		CREDIT_CARD_BANK_EXPENSE.EXPENSE_ID,
		CASE 
			WHEN CREDIT_CARD_BANK_EXPENSE.ACTION_TO_COMPANY_ID IS NOT NULL THEN (SELECT FULLNAME FROM #dsn_alias#.COMPANY WHERE COMPANY.COMPANY_ID = CREDIT_CARD_BANK_EXPENSE.ACTION_TO_COMPANY_ID)
		 	WHEN CREDIT_CARD_BANK_EXPENSE.CONS_ID IS NOT NULL THEN(SELECT CONSUMER_NAME +''+ CONSUMER_SURNAME FROM #dsn_alias#.CONSUMER WHERE CONSUMER.CONSUMER_ID = CREDIT_CARD_BANK_EXPENSE.CONS_ID)
			ELSE (SELECT COMPANY_PARTNER_NAME +''+ COMPANY_PARTNER_SURNAME FROM #dsn_alias#.COMPANY_PARTNER WHERE COMPANY_PARTNER.PARTNER_ID = CREDIT_CARD_BANK_EXPENSE.PAR_ID)
		END AS NAME
	FROM
		CREDIT_CARD_BANK_EXPENSE_ROWS,
		CREDIT_CARD_BANK_EXPENSE,
		CREDIT_CARD,
		CREDIT_CARD_BANK_EXPENSE_MONEY
	WHERE
		CREDIT_CARD_BANK_EXPENSE.CREDITCARD_EXPENSE_ID = CREDIT_CARD_BANK_EXPENSE_ROWS.CREDITCARD_EXPENSE_ID AND
		CREDIT_CARD_BANK_EXPENSE.CREDITCARD_EXPENSE_ID = CREDIT_CARD_BANK_EXPENSE_MONEY.ACTION_ID AND
		CREDIT_CARD_BANK_EXPENSE_MONEY.MONEY_TYPE = CREDIT_CARD_BANK_EXPENSE.ACTION_CURRENCY_ID AND
		CREDIT_CARD_BANK_EXPENSE.CREDITCARD_ID = CREDIT_CARD.CREDITCARD_ID AND
		CREDIT_CARD_BANK_EXPENSE_ROWS.INSTALLMENT_AMOUNT > 0 AND
		<cfif len(attributes.project_id) and len(attributes.project_name)>
			CREDIT_CARD_BANK_EXPENSE.PROJECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND
		</cfif>
		<cfif isDefined("attributes.is_month_based") and attributes.is_month_based eq 2>
			MONTH(DATEADD(d,ISNULL(CREDIT_CARD.PAYMENT_DAY,0),CREDIT_CARD_BANK_EXPENSE_ROWS.ACC_ACTION_DATE)) = #attributes.action_date# AND
			YEAR(DATEADD(d,ISNULL(CREDIT_CARD.PAYMENT_DAY,0),CREDIT_CARD_BANK_EXPENSE_ROWS.ACC_ACTION_DATE)) = #session.ep.period_year#
		<cfelseif isDefined("attributes.is_month_based") and attributes.is_month_based eq 3>
			datePart(ISO_WEEK,DATEADD(d,ISNULL(CREDIT_CARD.PAYMENT_DAY,0),CREDIT_CARD_BANK_EXPENSE_ROWS.ACC_ACTION_DATE)) = #attributes.until_date# AND
			YEAR(DATEADD(d,ISNULL(CREDIT_CARD.PAYMENT_DAY,0),CREDIT_CARD_BANK_EXPENSE_ROWS.ACC_ACTION_DATE)) = #session.ep.period_year#
	<cfelse>
			DATEADD(d,ISNULL(CREDIT_CARD.PAYMENT_DAY,0),CREDIT_CARD_BANK_EXPENSE_ROWS.ACC_ACTION_DATE) = #attributes.action_date#
		</cfif>
	ORDER BY
		DATEADD(d,ISNULL(CREDIT_CARD.PAYMENT_DAY,0),CREDIT_CARD_BANK_EXPENSE_ROWS.ACC_ACTION_DATE)
</cfquery>
<!--- Gelen Banka Talimati --->
<cfquery name="GET_GELEN_BANK_ORDERS" datasource="#dsn2#">
	SELECT
		(BON.ACTION_VALUE*(SM.RATE2/SM.RATE1)) AS ALACAK,
		0 AS BORC,
		BON.PAYMENT_DATE,
		BON.ACTION_VALUE ISLEM_TUTAR,
		BON.ACTION_MONEY,
		BON.BANK_ORDER_ID,
		CASE 
			WHEN BON.COMPANY_ID IS NOT NULL THEN (SELECT FULLNAME FROM #dsn_alias#.COMPANY WHERE COMPANY.COMPANY_ID = BON.COMPANY_ID)
		 	WHEN BON.CONSUMER_ID IS NOT NULL THEN(SELECT CONSUMER_NAME +''+ CONSUMER_SURNAME FROM #dsn_alias#.CONSUMER WHERE CONSUMER.CONSUMER_ID = BON.CONSUMER_ID)
			ELSE (SELECT EMPLOYEE_NAME +''+ EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES WHERE EMPLOYEES.EMPLOYEE_ID = BON.EMPLOYEE_ID)
		END AS NAME
	FROM
		BANK_ORDERS BON,
		SETUP_MONEY SM
	WHERE
		(BON.IS_PAID = 0 OR BON.IS_PAID IS NULL)
		AND BON.ACTION_MONEY = SM.MONEY
		AND BANK_ORDER_TYPE = 251
		<cfif len(attributes.project_id) and len(attributes.project_name)>
			AND BON.PROJECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> 
		</cfif>
		<cfif isDefined("attributes.is_month_based") and attributes.is_month_based eq 2>
			AND MONTH(BON.PAYMENT_DATE) = #attributes.action_date#
			AND YEAR(BON.PAYMENT_DATE) = #session.ep.period_year#
		<cfelseif isDefined("attributes.is_month_based") and attributes.is_month_based eq 3>
			AND	datePart(ISO_WEEK,BON.PAYMENT_DATE) = #attributes.until_date#
			AND YEAR(BON.PAYMENT_DATE) = #session.ep.period_year#
		<cfelse>
			AND BON.PAYMENT_DATE = #attributes.action_date#
		</cfif>
	ORDER BY
		BON.PAYMENT_DATE
</cfquery>
<!--- Giden Banka Talimati --->
<cfquery name="GET_GIDEN_BANK_ORDERS" datasource="#dsn2#">
	SELECT
		0 AS ALACAK,		
		(BON.ACTION_VALUE*(SM.RATE2/SM.RATE1)) AS BORC,
		BON.PAYMENT_DATE,
		BON.ACTION_VALUE ISLEM_TUTAR,
		BON.ACTION_MONEY,
		BON.BANK_ORDER_ID,
		CASE 
			WHEN BON.COMPANY_ID IS NOT NULL THEN (SELECT FULLNAME FROM #dsn_alias#.COMPANY WHERE COMPANY.COMPANY_ID = BON.COMPANY_ID)
		 	WHEN BON.CONSUMER_ID IS NOT NULL THEN(SELECT CONSUMER_NAME +''+ CONSUMER_SURNAME FROM #dsn_alias#.CONSUMER WHERE CONSUMER.CONSUMER_ID = BON.CONSUMER_ID)
			ELSE (SELECT EMPLOYEE_NAME +''+ EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES WHERE EMPLOYEES.EMPLOYEE_ID = BON.EMPLOYEE_ID)
		END AS NAME
	FROM
		BANK_ORDERS BON,
		SETUP_MONEY SM
	WHERE
		(BON.IS_PAID = 0 OR BON.IS_PAID IS NULL)
		AND BON.ACTION_MONEY = SM.MONEY
		AND BANK_ORDER_TYPE = 260
		<cfif len(attributes.project_id) and len(attributes.project_name)>
			AND BON.PROJECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> 
		</cfif>
		<cfif isDefined("attributes.is_month_based") and attributes.is_month_based eq 2>
			AND MONTH(BON.PAYMENT_DATE) = #attributes.action_date#
			AND YEAR(BON.PAYMENT_DATE) = #session.ep.period_year#
		<cfelseif isDefined("attributes.is_month_based") and attributes.is_month_based eq 3>
			AND datePart(ISO_WEEK,BON.PAYMENT_DATE) = #attributes.until_date# 
			AND YEAR(BON.PAYMENT_DATE) = #session.ep.period_year#
		<cfelse>
			AND BON.PAYMENT_DATE = #attributes.action_date#
		</cfif>
	ORDER BY
		BON.PAYMENT_DATE
</cfquery>
<!--- Butce Gelirler --->
<cfquery name="GET_BUDGET_INCOME" datasource="#dsn2#">
	SELECT
		(BPR.OTHER_ROW_TOTAL_INCOME*(SM.RATE2/SM.RATE1))  AS ALACAK,
		0 AS BORC,
		BPR.PLAN_DATE PAYMENT_DATE,
		BP.OTHER_MONEY ACTION_MONEY,
		BPR.OTHER_ROW_TOTAL_INCOME ISLEM_TUTAR,
		BP.BUDGET_PLAN_ID,
		BPR.DETAIL,
		CASE 
			WHEN BPR.RELATED_EMP_TYPE = 'partner' THEN (SELECT FULLNAME FROM #dsn_alias#.COMPANY WHERE COMPANY.COMPANY_ID = BPR.RELATED_EMP_ID)
		 	WHEN BPR.RELATED_EMP_TYPE = 'consumer' THEN (SELECT CONSUMER_NAME +''+ CONSUMER_SURNAME FROM #dsn_alias#.CONSUMER WHERE CONSUMER.CONSUMER_ID = BPR.RELATED_EMP_ID)
			WHEN BPR.RELATED_EMP_TYPE = 'employee' THEN (SELECT EMPLOYEE_NAME +''+ EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES WHERE EMPLOYEES.EMPLOYEE_ID = BPR.RELATED_EMP_ID)		
		END AS NAME
	FROM
		#dsn_alias#.BUDGET_PLAN BP,
		#dsn_alias#.BUDGET_PLAN_ROW BPR,
		SETUP_MONEY SM
	WHERE
		BP.BUDGET_PLAN_ID = BPR.BUDGET_PLAN_ID 
		AND BP.OTHER_MONEY = SM.MONEY
		AND BP.IS_SCENARIO = 1
		<cfif len(attributes.project_id) and len(attributes.project_name)>
			AND BPR.PROJECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> 
		</cfif>
		<cfif isDefined("attributes.is_month_based") and attributes.is_month_based eq 2>
			AND MONTH(BPR.PLAN_DATE) = #attributes.action_date#
			AND YEAR(BPR.PLAN_DATE) = #session.ep.period_year#
		<cfelseif isDefined("attributes.is_month_based") and attributes.is_month_based eq 3>
			AND datePart(ISO_WEEK,BPR.PLAN_DATE) = #attributes.until_date#
			AND YEAR(BPR.PLAN_DATE) = #session.ep.period_year#
		<cfelse>
			AND BPR.PLAN_DATE = #attributes.action_date#
		</cfif>
		AND BPR.OTHER_ROW_TOTAL_INCOME > 0
	ORDER BY
		BPR.PLAN_DATE
</cfquery>
<!--- Butce Giderler --->
<cfquery name="GET_BUDGET_EXPENSE" datasource="#dsn2#">
	SELECT
		0 AS ALACAK,
		(BPR.OTHER_ROW_TOTAL_EXPENSE*(SM.RATE2/SM.RATE1)) AS BORC,
		BPR.PLAN_DATE PAYMENT_DATE,
		BP.OTHER_MONEY ACTION_MONEY,
		BPR.OTHER_ROW_TOTAL_EXPENSE ISLEM_TUTAR,
		BP.BUDGET_PLAN_ID,
		BPR.DETAIL,
		CASE 
			WHEN BPR.RELATED_EMP_TYPE = 'partner' THEN (SELECT FULLNAME FROM #dsn_alias#.COMPANY WHERE COMPANY.COMPANY_ID = BPR.RELATED_EMP_ID)
		 	WHEN BPR.RELATED_EMP_TYPE = 'consumer' THEN (SELECT CONSUMER_NAME +''+ CONSUMER_SURNAME FROM #dsn_alias#.CONSUMER WHERE CONSUMER.CONSUMER_ID = BPR.RELATED_EMP_ID)
			WHEN BPR.RELATED_EMP_TYPE = 'employee' THEN (SELECT EMPLOYEE_NAME +''+ EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES WHERE EMPLOYEES.EMPLOYEE_ID = BPR.RELATED_EMP_ID)		
		END AS NAME
	FROM
		#dsn_alias#.BUDGET_PLAN BP,
		#dsn_alias#.BUDGET_PLAN_ROW BPR,
		SETUP_MONEY SM
	WHERE
		BP.BUDGET_PLAN_ID = BPR.BUDGET_PLAN_ID 
		AND BP.OTHER_MONEY = SM.MONEY
		AND BP.IS_SCENARIO = 1
		AND BPR.OTHER_ROW_TOTAL_EXPENSE > 0
		<cfif len(attributes.project_id) and len(attributes.project_name)>
			AND BPR.PROJECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> 
		</cfif>
		<cfif isDefined("attributes.is_month_based") and attributes.is_month_based eq 2>
			AND MONTH(BPR.PLAN_DATE) = #attributes.action_date#
			AND YEAR(BPR.PLAN_DATE) = #session.ep.period_year#
		<cfelseif isDefined("attributes.is_month_based") and attributes.is_month_based eq 3>
			AND datePart(ISO_WEEK,BPR.PLAN_DATE) = #attributes.until_date# 
			AND YEAR(BPR.PLAN_DATE) = #session.ep.period_year#
		<cfelse>
			AND BPR.PLAN_DATE = #attributes.action_date#
		</cfif>
	ORDER BY
		BPR.PLAN_DATE
</cfquery>
<cfquery name="GET_CASH_TOTAL" datasource="#DSN2#">
	SELECT
		SUM(BAKIYE*(SM.RATE2/SM.RATE1)) AS CASH_TOTAL
	FROM 
		CASH_REMAINDER_LAST CRL,
		CASH,
		SETUP_MONEY SM
	WHERE
		CASH.CASH_ID = CRL.CASH_ID AND
		SM.MONEY = CASH.CASH_CURRENCY_ID
</cfquery>
<cfquery name="GET_BANK_TOTAL" datasource="#DSN2#">
	SELECT 
		SUM(BAKIYE *(SM.RATE2/SM.RATE1)) AS BANK_TOTAL
	FROM
		ACCOUNT_REMAINDER_LAST,
		SETUP_MONEY SM
	WHERE
		SM.MONEY = ACCOUNT_REMAINDER_LAST.ACCOUNT_CURRENCY_ID
		<cfif session.ep.period_year lt 2009>
			OR 
			(SM.MONEY = 'YTL' AND ACCOUNT_REMAINDER_LAST.ACCOUNT_CURRENCY_ID = 'TL')
		</cfif>
</cfquery>
<cfquery name="get_open_acc" datasource="#dsn2#">
	SELECT 
		SUM(BORC) BORC,
		SUM(ALACAK) ALACAK,
		SUM(BORC3) BORC3,
		SUM(ALACAK3) ALACAK3,
		DUE_DATE,
		ACTION_CURRENCY_ID,
		OTHER_MONEY,
		CASE 
			WHEN COMP_ID IS NOT NULL THEN (SELECT FULLNAME FROM #dsn_alias#.COMPANY WHERE COMPANY.COMPANY_ID = COMP_ID)
		 	WHEN CONS_ID IS NOT NULL THEN (SELECT CONSUMER_NAME +''+ CONSUMER_SURNAME FROM #dsn_alias#.CONSUMER WHERE CONSUMER.CONSUMER_ID = CONS_ID)
			ELSE (SELECT EMPLOYEE_NAME +''+ EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES WHERE EMPLOYEES.EMPLOYEE_ID = EMP_ID)
		END AS NAME
	FROM
		(SELECT
			CR.ACTION_VALUE AS BORC,
			CR.ACTION_VALUE_2 AS BORC2,
			CR.OTHER_CASH_ACT_VALUE BORC3,
			0 AS ALACAK,
			0 AS ALACAK2,
			0 AS ALACAK3,
			CR.DUE_DATE,
			CR.CARI_ACTION_ID,
			CR.ACTION_CURRENCY_ID,
			CR.OTHER_MONEY,
			CR.TO_CMP_ID COMP_ID,
			CR.TO_CONSUMER_ID CONS_ID,
			CR.TO_EMPLOYEE_ID EMP_ID
		FROM
			CARI_ROWS CR
		WHERE 
			(TO_CMP_ID IS NOT NULL
			OR TO_CONSUMER_ID IS NOT NULL
			OR TO_EMPLOYEE_ID IS NOT NULL)
			AND CR.ACTION_ID NOT IN 
				(
					SELECT 
						ICR.ACTION_ID 
					FROM 
						CARI_CLOSED_ROW ICR,
						CARI_CLOSED IC
					WHERE 
						ICR.CLOSED_ID = IC.CLOSED_ID 
						AND ICR.CLOSED_AMOUNT IS NOT NULL
						AND CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID
						AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS'))
						AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS'))
						AND CR.OTHER_MONEY = ICR.OTHER_MONEY	
				)
			AND CR.ACTION_TYPE_ID IN (40,50,52,53,56,57,58,62,66,531,561,48,121)
			<cfif len(attributes.project_id) and len(attributes.project_name)>
			AND CR.PROJECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> 
			</cfif>
		UNION ALL
			
		SELECT
			(CR.ACTION_VALUE-ROUND(SUM(ICR.CLOSED_AMOUNT),2)) AS BORC,
			(CR.ACTION_VALUE-ROUND(SUM(ICR.CLOSED_AMOUNT),2))/(CR.ACTION_VALUE/CR.ACTION_VALUE_2) AS BORC2,
			CR.OTHER_CASH_ACT_VALUE BORC3,
			0 AS ALACAK,
			0 AS ALACAK2,
			0 AS ALACAK3,
			CR.DUE_DATE,
			CR.CARI_ACTION_ID,
			CR.ACTION_CURRENCY_ID,
			CR.OTHER_MONEY,
			CR.TO_CMP_ID COMP_ID,
			CR.TO_CONSUMER_ID CONS_ID,
			CR.TO_EMPLOYEE_ID EMP_ID
		FROM
			CARI_ROWS CR,
			CARI_CLOSED_ROW ICR
		WHERE 
			CR.ACTION_ID = ICR.ACTION_ID
			AND CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID
			AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS'))
			AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS'))
			AND (TO_CMP_ID IS NOT NULL
			OR TO_CONSUMER_ID IS NOT NULL
			OR TO_EMPLOYEE_ID IS NOT NULL)	
			AND CR.ACTION_TYPE_ID IN (40,50,52,53,56,57,58,62,66,531,561,48,121)
			<cfif len(attributes.project_id) and len(attributes.project_name)>
			AND CR.PROJECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> 
			</cfif>
		GROUP BY
			CR.ACTION_VALUE,
			CR.ACTION_VALUE_2,
			CR.OTHER_CASH_ACT_VALUE,
			CR.DUE_DATE,
			CR.CARI_ACTION_ID,
			CR.ACTION_CURRENCY_ID,
			CR.OTHER_MONEY,
			CR.TO_CMP_ID,
			CR.TO_CONSUMER_ID,
			CR.TO_EMPLOYEE_ID	
		UNION ALL
		
		SELECT
			0 AS BORC,
			0 AS BORC2,
			0 AS BORC3,
			CR.ACTION_VALUE AS ALACAK,
			CR.ACTION_VALUE_2 AS ALACAK2,
			CR.OTHER_CASH_ACT_VALUE ALACAK3,
			CR.DUE_DATE,
			CR.CARI_ACTION_ID,
			CR.ACTION_CURRENCY_ID,
			CR.OTHER_MONEY,
			CR.FROM_CMP_ID COMP_ID,
			CR.FROM_CONSUMER_ID CONS_ID,
			CR.FROM_EMPLOYEE_ID EMP_ID
		FROM
			CARI_ROWS CR
		WHERE
			(FROM_CMP_ID IS NOT NULL
			OR FROM_CONSUMER_ID IS NOT NULL
			OR FROM_EMPLOYEE_ID IS NOT NULL	)
			AND CR.ACTION_ID NOT IN 
				(
					SELECT 
						ICR.ACTION_ID 
					FROM 
						CARI_CLOSED_ROW ICR,
						CARI_CLOSED IC
					WHERE 
						ICR.CLOSED_ID = IC.CLOSED_ID 
						AND ICR.CLOSED_AMOUNT IS NOT NULL
						AND CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID
						AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS'))
						AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS'))
						AND CR.OTHER_MONEY = ICR.OTHER_MONEY	
				)
			AND CR.ACTION_TYPE_ID IN (40,51,54,55,59,591,592,60,61,63,64,65,68,690,691,601,49,120,122)
			<cfif len(attributes.project_id) and len(attributes.project_name)>
			AND CR.PROJECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> 
			</cfif>
		UNION ALL
		
		SELECT
			0 AS BORC,
			0 AS BORC2,
			0 AS BORC3,
			(CR.ACTION_VALUE-ROUND(SUM(ICR.CLOSED_AMOUNT),2))AS ALACAK,
			(CR.ACTION_VALUE-ROUND(SUM(ICR.CLOSED_AMOUNT),2))/(CR.ACTION_VALUE/CR.ACTION_VALUE_2) AS ALACAK2,
			CR.OTHER_CASH_ACT_VALUE ALACAK3,
			CR.DUE_DATE,
			CR.CARI_ACTION_ID,
			CR.ACTION_CURRENCY_ID,
			CR.OTHER_MONEY,
			CR.FROM_CMP_ID COMP_ID,
			CR.FROM_CONSUMER_ID CONS_ID,
			CR.FROM_EMPLOYEE_ID EMP_ID
		FROM
			CARI_ROWS CR,
			CARI_CLOSED_ROW ICR
		WHERE
			CR.ACTION_ID = ICR.ACTION_ID
			AND CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID
			AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS'))
			AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS'))
			AND (FROM_CMP_ID IS NOT NULL
			OR FROM_CONSUMER_ID IS NOT NULL
			OR FROM_EMPLOYEE_ID IS NOT NULL)
			AND CR.ACTION_TYPE_ID IN (40,51,54,55,59,591,592,60,61,63,64,65,68,690,691,601,49,120,122)	
			<cfif len(attributes.project_id) and len(attributes.project_name)>
			AND CR.PROJECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> 
			</cfif>
		GROUP BY
			CR.ACTION_VALUE,
			CR.ACTION_VALUE_2,
			CR.OTHER_CASH_ACT_VALUE,
			CR.DUE_DATE,
			CR.CARI_ACTION_ID,
			CR.ACTION_CURRENCY_ID,
			CR.OTHER_MONEY,
			CR.FROM_CMP_ID,
			CR.FROM_CONSUMER_ID,
			CR.FROM_EMPLOYEE_ID
		)AS T1	
	WHERE 	
	<cfif isDefined("attributes.is_month_based") and attributes.is_month_based eq 2>
			MONTH(DUE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_date#">
			AND YEAR(DUE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#">
		<cfelseif isDefined("attributes.is_month_based") and attributes.is_month_based eq 3>
			datePart(ISO_WEEK,DUE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.until_date#">
			AND YEAR(DUE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#">
		<cfelse>
			DUE_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.action_date#">
		</cfif>
	GROUP BY
		DUE_DATE,
		COMP_ID,
		CONS_ID,
		EMP_ID,
		ACTION_CURRENCY_ID,
		OTHER_MONEY
</cfquery>
