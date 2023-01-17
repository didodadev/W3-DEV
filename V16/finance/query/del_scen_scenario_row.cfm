<cfquery name="DEL_SCEN_SCENARIO_ROWS" datasource="#DSN3#">
	DELETE FROM
		SCEN_EXPENSE_PERIOD_ROWS
	WHERE
		PERIOD_ROW_ID = #attributes.id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
