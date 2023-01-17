<cfquery name="DEL_ACTION_PLAN" datasource="#dsn#">
	DELETE FROM COMPANY_ACTION_PLAN_NOTES WHERE ACTION_PLAN_ID = #attributes.action_plan_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
