<cfquery name="DEL_QUALITY_CONTROL" datasource="#dsn3#">
	DELETE 
		FROM
		QUALITY_CONTROL_DETAIL
	WHERE 
		CONTROL_ID = #URL.ID#
</cfquery>
<cf_add_log employee_id="#session.ep.userid#" log_type="-1" action_id="#attributes.ID#" action_name="#attributes.head# " period_id="#session.ep.period_id#">
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
