<cfquery name="DEL_CREDIT_C_PAYMENT_TYPES" datasource="#dsn3#">
	DELETE FROM
		CREDIT_CARD_BANK_PAYMENTS
	WHERE
		STORE_REPORT_ID = #url.id# AND
		ACTION_PERIOD_ID = #session.ep.period_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
