<cfquery name="GET_CHEQUE_PAYROLL" datasource="#dsn2#">
	SELECT 
		*
	FROM
		PAYROLL
	WHERE
		ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PAYROLL_ID#">
</cfquery>
<cfset cash_name1=''>
<cfset cash_name2=''>
<cfif len(GET_CHEQUE_PAYROLL.PAYROLL_CASH_ID)>
	<cfquery name="get_cash_name1" datasource="#dsn2#">
		SELECT CASH_NAME FROM CASH WHERE CASH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CHEQUE_PAYROLL.PAYROLL_CASH_ID#">
	</cfquery>
	<cfset cash_name1 = get_cash_name1.cash_name>
</cfif>
<cfif len(GET_CHEQUE_PAYROLL.TRANSFER_CASH_ID)>
	<cfquery name="get_cash_name2" datasource="#dsn2#">
		SELECT CASH_NAME FROM CASH WHERE CASH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CHEQUE_PAYROLL.TRANSFER_CASH_ID#">
	</cfquery>
	<cfset cash_name2 = get_cash_name2.cash_name>
</cfif>
