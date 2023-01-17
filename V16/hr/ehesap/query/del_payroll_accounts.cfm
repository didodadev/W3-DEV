<cfquery name="upd_payroll_accounts" datasource="#dsn#">
	DELETE FROM SETUP_SALARY_PAYROLL_ACCOUNTS WHERE PAYROLL_ID = #attributes.PAYROLL_ID#
</cfquery>
<cf_add_log  log_type="-1" action_id="#attributes.PAYROLL_ID# " action_name="MUHASEBE TANIMI Sil : #attributes.PAYROLL_ID#">
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
