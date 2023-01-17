<cfif len(get_voucher_history.PAYROLL_ID)>
	<cfquery name="GET_VOUCHER_PAYROLL" datasource="#dsn2#">
		SELECT 
			*
		FROM
			VOUCHER_PAYROLL
		WHERE
			ACTION_ID = #get_voucher_history.PAYROLL_ID#
	</cfquery>
<cfelse>
	<cfset get_voucher_payroll.recordcount = 0>
	<cfset GET_VOUCHER_PAYROLL.PAYROLL_CASH_ID = ''>
	<cfset GET_VOUCHER_PAYROLL.TRANSFER_CASH_ID = ''>
</cfif>
<cfset cash_name1=''>
<cfset cash_name2=''>
<cfif len(GET_VOUCHER_PAYROLL.PAYROLL_CASH_ID)>
	<cfquery name="get_cash_name1" datasource="#dsn2#">
		SELECT CASH_NAME FROM CASH WHERE CASH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_VOUCHER_PAYROLL.PAYROLL_CASH_ID#">
	</cfquery>
	<cfset cash_name1 = get_cash_name1.cash_name>
</cfif>
<cfif len(GET_VOUCHER_PAYROLL.TRANSFER_CASH_ID)>
	<cfquery name="get_cash_name2" datasource="#dsn2#">
		SELECT CASH_NAME FROM CASH WHERE CASH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_VOUCHER_PAYROLL.TRANSFER_CASH_ID#">
	</cfquery>
	<cfset cash_name2 = get_cash_name2.cash_name>
</cfif>
