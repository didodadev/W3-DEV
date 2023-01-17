<cfquery name="get_payroll" datasource="#dsn2#">
	SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_NO = '-2'
</cfquery>
<cfquery name="control" datasource="#dsn2#">
	SELECT COUNT(VOUCHER_ID) AS COUNT FROM VOUCHER WHERE VOUCHER_PAYROLL_ID = #get_payroll.ACTION_ID#
</cfquery>
<cfquery name="del_self_vouchers" datasource="#dsn2#">
	DELETE FROM VOUCHER WHERE VOUCHER_ID = #ATTRIBUTES.ID#
</cfquery>
<cfif control.count eq 1>
	<CFQUERY name="DEL_PAYROLL" datasource="#DSN2#">
		DELETE FROM VOUCHER_PAYROLL WHERE ACTION_ID = #get_payroll.ACTION_ID#
	</CFQUERY>
</cfif>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>


