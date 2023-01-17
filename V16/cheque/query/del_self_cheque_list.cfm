<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="get_payroll" datasource="#dsn2#">
			SELECT CHEQUE_PAYROLL_ID FROM CHEQUE WHERE CHEQUE_ID = #ATTRIBUTES.ID#
		</cfquery>
		<cfquery name="control" datasource="#dsn2#">
			SELECT COUNT(CHEQUE_ID) AS COUNT FROM CHEQUE WHERE CHEQUE_PAYROLL_ID = #get_payroll.CHEQUE_PAYROLL_ID#
		</cfquery>
		<cfquery name="del_self_cheques" datasource="#dsn2#">
			DELETE FROM CHEQUE WHERE CHEQUE_ID = #ATTRIBUTES.ID#
		</cfquery>
		<cfquery name="del_self_cheque_history" datasource="#dsn2#">
			DELETE FROM CHEQUE_HISTORY WHERE CHEQUE_ID = #ATTRIBUTES.ID#
		</cfquery>
		<cfquery name="del_self_cheque_money" datasource="#dsn2#">
			DELETE FROM CHEQUE_MONEY WHERE ACTION_ID = #ATTRIBUTES.ID#
		</cfquery>
		<cfif control.count eq 1>
			<CFQUERY name="DEL_PAYROLL" datasource="#dsn2#">
				DELETE FROM PAYROLL WHERE ACTION_ID = #get_payroll.CHEQUE_PAYROLL_ID#
			</CFQUERY>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>


