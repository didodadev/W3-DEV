<cfquery name="UPD_SCENARIO" datasource="#DSN#">
	DELETE
	FROM
		SETUP_SCENARIO
	WHERE
		SCENARIO_ID=#attributes.ID#
</cfquery>
<cf_add_log log_type="-1" action_id="#attributes.id#" action_name="#attributes.detail#" >
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=budget.list_scenarios</cfoutput>";
</script>
