<cfquery name="GET_CHEQUE_IN_CASH" datasource="#DSN2#">
 	SELECT 
		SUM(BAKIYE) AS BAKIYE
	FROM
	(
	<cfloop list="#attributes.our_company_ids#" index="comp_ii">
		SELECT 
			SUM(BAKIYE) AS BAKIYE
		FROM
			#dsn#_#session.ep.period_year#_#comp_ii#.CHEQUE_IN_CASH_TOTAL AS CHEQUE_IN_CASH_TOTAL			
		<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
	</cfloop>
	) AS CHEQUE_IN_CASH_TOTAL2
</cfquery>
<cfquery name="GET_CHEQUE_IN_BANK" datasource="#DSN2#">
	SELECT
		SUM(BORC) AS BORC
	FROM
	(
	<cfloop list="#attributes.our_company_ids#" index="comp_ii">
		SELECT 
			SUM(BORC) AS BORC
		FROM
			#dsn#_#session.ep.period_year#_#comp_ii#.CHEQUE_IN_BANK AS CHEQUE_IN_BANK			
		<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
	</cfloop>
	) AS CHEQUE_IN_BANK2
</cfquery>
<cfquery name="GET_CHEQUE_TO_PAY" datasource="#DSN2#">
	SELECT
		SUM(BORC) AS BORC
	FROM
	(
	<cfloop list="#attributes.our_company_ids#" index="comp_ii">
		SELECT 
			SUM(BORC) AS BORC
		FROM
			#dsn#_#session.ep.period_year#_#comp_ii#.CHEQUE_TO_PAY AS CHEQUE_TO_PAY			
		<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
	</cfloop>
	) AS CHEQUE_TO_PAY2
</cfquery>
<cfquery name="GET_VOUCHER_TO_PAY" datasource="#DSN2#">
	SELECT
		SUM(BORC) AS BORC
	FROM
	(
	<cfloop list="#attributes.our_company_ids#" index="comp_ii">
		SELECT 
			SUM(BORC) AS BORC
		FROM
			#dsn#_#session.ep.period_year#_#comp_ii#.VOUCHER_TO_PAY AS VOUCHER_TO_PAY			
		<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
	</cfloop>
	) AS VOUCHER_TO_PAY2
</cfquery>
<cfquery name="GET_VOUCHER_IN_BANK" datasource="#DSN2#">
	SELECT
		SUM(BORC) AS BORC
	FROM
	(
	<cfloop list="#attributes.our_company_ids#" index="comp_ii">
		SELECT 
			SUM(BORC) AS BORC
		FROM
			#dsn#_#session.ep.period_year#_#comp_ii#.VOUCHER_IN_BANK AS VOUCHER_IN_BANK			
		<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
	</cfloop>
	) AS VOUCHER_IN_BANK2
</cfquery>
<cfquery name="GET_VOUCHER_IN_CASH" datasource="#DSN2#">
	SELECT
		SUM(BORC) AS BORC
	FROM
	(
	<cfloop list="#attributes.our_company_ids#" index="comp_ii">
		SELECT 
			SUM(BORC) AS BORC
		FROM
			#dsn#_#session.ep.period_year#_#comp_ii#.VOUCHER_IN_CASH AS VOUCHER_IN_CASH			
		<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
	</cfloop>
	) AS VOUCHER_IN_CASH2
</cfquery>
<cfquery name="GET_CHEQUE_BANK_TEM" datasource="#DSN2#">
	SELECT
		SUM(BORC) AS BORC
	FROM
	(
	<cfloop list="#attributes.our_company_ids#" index="comp_ii">
		SELECT 
			SUM(OTHER_MONEY_VALUE) AS BORC
		FROM
			#dsn#_#session.ep.period_year#_#comp_ii#.CHEQUE
		WHERE
			CHEQUE_STATUS_ID = 13	
		<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
	</cfloop>
	) AS CHEQUE_IN_BANK2
</cfquery>
<cfquery name="GET_VOUCHER_BANK_TEM" datasource="#DSN2#">
	SELECT
		SUM(BORC) AS BORC
	FROM
	(
	<cfloop list="#attributes.our_company_ids#" index="comp_ii">
		SELECT 
			SUM(OTHER_MONEY_VALUE) AS BORC
		FROM
			#dsn#_#session.ep.period_year#_#comp_ii#.VOUCHER	
		WHERE
			VOUCHER_STATUS_ID = 13	
		<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
	</cfloop>
	) AS VOUCHER_TO_PAY2
</cfquery>
