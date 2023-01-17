<cf_date tarih="attributes.start_date">
<cfquery name="UPD_SCEN_SCENARIO_ROW" datasource="#DSN3#">
	UPDATE
		SCEN_EXPENSE_PERIOD_ROWS
	SET
		PERIOD_CURRENCY = '#attributes.currency#',
		PERIOD_VALUE = #attributes.period_value#,
		START_DATE = #attributes.start_date#,
		SCEN_EXPENSE_STATUS = <cfif isdefined("attributes.scen_expense_status")>1<cfelse>0</cfif>
	WHERE
		PERIOD_ROW_ID = #attributes.id#
</cfquery>
<cfquery name="UPD_SCEN_SCENARIO" datasource="#DSN3#">
	UPDATE
		SCEN_EXPENSE_PERIOD
	SET
		PERIOD_CURRENCY = '#attributes.currency#',
		PERIOD_VALUE = #attributes.period_value#,
		START_DATE = #attributes.start_date#,
		SCEN_EXPENSE_STATUS = <cfif isdefined("attributes.scen_expense_status")>1<cfelse>0</cfif>
	WHERE
		PERIOD_ID = #attributes.period_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
