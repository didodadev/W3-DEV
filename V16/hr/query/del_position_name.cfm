<cfquery name="DELTITLE" datasource="#dsn#">
	DELETE FROM EMPLOYEE_POSITION_NAMES WHERE POS_NAME_ID=#attributes.id#
</cfquery>
<cf_add_log employee_id="#session.ep.userid#" log_type="-1" action_id="#attributes.id#" action_name="#attributes.head# " period_id="#session.ep.period_id#" >
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
