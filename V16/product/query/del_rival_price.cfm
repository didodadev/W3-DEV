<cfquery name="del_rival_prices" datasource="#dsn3#">
	DELETE FROM	PRICE_RIVAL WHERE PR_ID = #attributes.PR_ID#
</cfquery>
<cf_add_log  log_type="-1" action_id="#attributes.pr_id#" action_name="#attributes.head#" >
<script type="text/javascript">
	location.href = document.referrer;
	window.close();
</script>
