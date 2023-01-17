<cfquery name="GET_CASH_TOTAL" datasource="#DSN#">
	SELECT
		SUM(BAKIYE*(SM.RATE2/SM.RATE1)) AS CASH_TOTAL
	FROM 
		#dsn2_alias#.CASH_REMAINDER_LAST CRL,
		#dsn2_alias#.CASH,
		#dsn2_alias#.SETUP_MONEY SM
	WHERE
		CASH.CASH_ID = CRL.CASH_ID AND
		SM.MONEY = CASH.CASH_CURRENCY_ID
</cfquery>

<cfquery name="GET_ACCOUNT_BAKIYE" datasource="#DSN#">
	SELECT 
		SUM(BAKIYE *(SM.RATE2/SM.RATE1)) AS BAKIYE
	FROM
		#dsn2_alias#.ACCOUNT_REMAINDER_LAST,
		#dsn2_alias#.SETUP_MONEY SM
	WHERE
		((SM.MONEY = ACCOUNT_REMAINDER_LAST.ACCOUNT_CURRENCY_ID)
		<cfif session.ep.period_year lt 2009>
			OR (SM.MONEY = 'YTL' AND ACCOUNT_REMAINDER_LAST.ACCOUNT_CURRENCY_ID = 'TL')
		</cfif>)
</cfquery>
<cfif len(get_account_bakiye.bakiye)>
	<cfset account_bakiye=get_account_bakiye.bakiye>
<cfelse>
	<cfset account_bakiye=0>
</cfif>


<cfquery name="GET_CHEQUE_IN_CASH" datasource="#DSN#">
	SELECT 
		SUM(BAKIYE) AS BAKIYE
	FROM
		#dsn2_alias#.CHEQUE_IN_CASH_TOTAL
</cfquery>

<cfquery name="GET_CHEQUE_IN_BANK" datasource="#DSN#">
	SELECT
		SUM(BORC-ALACAK) AS BAKIYE
	FROM
		#dsn2_alias#.CHEQUE_IN_BANK
</cfquery>
<cfquery name="GET_CHEQUE_TO_PAY" datasource="#DSN#">
	SELECT
		SUM(BORC-ALACAK) AS BAKIYE
	FROM
		#dsn2_alias#.CHEQUE_TO_PAY
</cfquery>
<!--- bakiye 0 dan büyük-küçük kısmı ters gelmesin, yöneticicye özet olarak bakıldıgında, şirketin borcu alacağı manasndandır --->
<cfquery name="GET_COMP_DEBT" datasource="#DSN#">
	SELECT
		SUM(BAKIYE) AS TOTAL_COMP_DEBT
	FROM
		#dsn2_alias#.COMPANY_REMAINDER WHERE BAKIYE < 0
</cfquery>
<cfif len(get_comp_debt.total_comp_debt)>
	<cfset total_comp_debt=get_comp_debt.total_comp_debt>
<cfelse>
	<cfset total_comp_debt=0>
</cfif>


<cfquery name="GET_COMP_CLAIM" datasource="#DSN#">
	SELECT
		SUM(BAKIYE) AS TOTAL_COMP_CLAIM
	FROM
		#dsn2_alias#.COMPANY_REMAINDER WHERE BAKIYE >= 0
</cfquery>
<cfif len(get_comp_claim.total_comp_claim)>
	<cfset total_comp_claim = get_comp_claim.total_comp_claim>
<cfelse>
	<cfset total_comp_claim = 0>
</cfif>


<cfquery name="GET_CONS_DEBT" datasource="#DSN#">
	SELECT
		SUM(BAKIYE) AS TOTAL_CONS_DEBT
	FROM
		#dsn2_alias#.CONSUMER_REMAINDER WHERE BAKIYE < 0
</cfquery>
<cfif len(get_cons_debt.total_cons_debt)>
	<cfset total_cons_debt = get_cons_debt.total_cons_debt>
<cfelse>
	<cfset total_cons_debt = 0>
</cfif>


<cfquery name="GET_CONS_CLAIM" datasource="#DSN#">
	SELECT
		SUM(BAKIYE) AS TOTAL_CONS_CLAIM
	FROM
		#dsn2_alias#.CONSUMER_REMAINDER WHERE BAKIYE >= 0
</cfquery>
<cfif len(get_cons_claim.total_cons_claim)>
	<cfset total_cons_claim=get_cons_claim.total_cons_claim>
<cfelse>
	<cfset total_cons_claim=0>
</cfif>
<cfset total_debt=TOTAL_COMP_DEBT + TOTAL_CONS_DEBT>
<cfset total_claim=TOTAL_COMP_CLAIM + TOTAL_CONS_CLAIM>


<cfquery name="GET_VOUCHER_TO_PAY" datasource="#DSN#">
	SELECT
		SUM(BORC) AS BORC
	FROM
		#dsn2_alias#.VOUCHER_TO_PAY
</cfquery>
<cfif len(get_voucher_to_pay.borc)>
    <cfset voucher_pay = get_voucher_to_pay.borc>
<cfelse>
	<cfset voucher_pay = 0>
</cfif>


<cfquery name="GET_VOUCHER_CASH" datasource="#DSN#">
	SELECT
		SUM(BORC) AS BORC
	FROM
		#dsn2_alias#.VOUCHER_IN_CASH
</cfquery>
<cfif len(GET_VOUCHER_CASH.BORC)>
    <cfset voucher_cash = get_voucher_cash.borc>
<cfelse>
	<cfset voucher_cash = 0>
</cfif>


<cfquery name="GET_VOUCHER_BANK" datasource="#DSN#">
	SELECT
		SUM(BORC) AS BORC
	FROM
		#dsn2_alias#.VOUCHER_IN_BANK
</cfquery>
<cfif len(get_voucher_bank.borc)>
  <cfset voucher_bank = get_voucher_bank.borc>
<cfelse>
  <cfset voucher_bank = 0>
</cfif>

<cfquery name="GET_CHEQUE_IN_GUARANTEE" datasource="#DSN#">
	SELECT
		SUM(TEMINAT_CEKLER) AS TEMINAT_CEKLER
	FROM
		#dsn2_alias#.CHEQUE_IN_GUARANTEE
</cfquery>
<cfquery name="GET_VOUCHER_IN_GUARANTEE" datasource="#DSN#">
	SELECT
		SUM(TEMINAT_SENET) AS TEMINAT_SENETLER
	FROM
		#dsn2_alias#.VOUCHER_IN_GUARANTEE
</cfquery>
<cfquery name="GET_SCN_REV" datasource="#dsn#">
	SELECT
		SUM(VALUE) AS VALUE
	FROM
	(
		SELECT
			SUM(VALUE1-VALUE2) VALUE
		FROM
		(
			SELECT
				SUM(TOTAL_PRICE * (SM.RATE2 / SM.RATE1)) AS VALUE1,
				0 VALUE2
			FROM
				#dsn3_alias#.CREDIT_CONTRACT_ROW CC,
				#dsn3_alias#.CREDIT_CONTRACT C,
				#dsn2_alias#.SETUP_MONEY SM
			WHERE
				C.CREDIT_CONTRACT_ID = CC.CREDIT_CONTRACT_ID AND
				C.IS_SCENARIO = 1 AND
				CREDIT_CONTRACT_TYPE = 2 AND
				TOTAL_PRICE > 0 AND
				SM.MONEY = CC.OTHER_MONEY AND
				CC.IS_PAID = 0
		UNION ALL
			SELECT
				0 VALUE1,
				SUM(TOTAL_PRICE * (SM.RATE2 / SM.RATE1)) AS VALUE2
			FROM
				#dsn3_alias#.CREDIT_CONTRACT_ROW CC,
				#dsn3_alias#.CREDIT_CONTRACT C,
				#dsn2_alias#.SETUP_MONEY SM
			WHERE
				C.CREDIT_CONTRACT_ID = CC.CREDIT_CONTRACT_ID AND
				C.IS_SCENARIO = 1 AND
				CREDIT_CONTRACT_TYPE = 2 AND
				TOTAL_PRICE > 0 AND
				SM.MONEY = CC.OTHER_MONEY AND
				CC.IS_PAID = 1
		) GET_SCN_REV_VALUE
	) AS VALUE2
</cfquery>
<cfquery name="GET_SCN_PAYM" datasource="#dsn#">
	SELECT
		SUM(VALUE) AS VALUE
	FROM
	(
		SELECT
			SUM(VALUE2-VALUE1) VALUE
		FROM
		(
			SELECT
				SUM(TOTAL_PRICE * (SM.RATE2 / SM.RATE1)) AS VALUE1,
				0 VALUE2
			FROM
				#dsn3_alias#.CREDIT_CONTRACT_ROW CC,
				#dsn3_alias#.CREDIT_CONTRACT C,
				#dsn2_alias#.SETUP_MONEY SM
			WHERE
				C.CREDIT_CONTRACT_ID = CC.CREDIT_CONTRACT_ID AND
				C.IS_SCENARIO = 1 AND
				CREDIT_CONTRACT_TYPE = 1 AND
				TOTAL_PRICE > 0 AND
				SM.MONEY = CC.OTHER_MONEY AND
				CC.IS_PAID = 0
		UNION ALL
			SELECT
				0 VALUE1,
				SUM(TOTAL_PRICE * (SM.RATE2 / SM.RATE1)) AS VALUE2
			FROM
				#dsn3_alias#.CREDIT_CONTRACT_ROW CC,
				#dsn3_alias#.CREDIT_CONTRACT C,
				#dsn2_alias#.SETUP_MONEY SM
			WHERE
				C.CREDIT_CONTRACT_ID = CC.CREDIT_CONTRACT_ID AND
				C.IS_SCENARIO = 1 AND
				CREDIT_CONTRACT_TYPE = 1 AND
				TOTAL_PRICE > 0 AND
				SM.MONEY = CC.OTHER_MONEY AND
				CC.IS_PAID = 1
		) GET_SCN_PAYM_VALUE
	) AS VALUE2
</cfquery>
