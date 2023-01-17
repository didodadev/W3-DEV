	<cfquery name="DEL_SALES_PROD_DISCOUNT" datasource="#dsn3#">
	DELETE FROM
		CONTRACT_SALES_PROD_DISCOUNT
	WHERE
		C_S_PROD_DISCOUNT_ID=#attributes.DISCOUNT_ID#
	</cfquery>
<cf_add_log employee_id="#session.ep.userid#" log_type="-1" action_id="#attributes.DISCOUNT_ID#" action_name="#attributes.head# " period_id="#session.ep.period_id#">
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
