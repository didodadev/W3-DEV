<cflock timeout="60">
	<cftransaction>
		<cfquery name="del_param" datasource="#dsn#">
			DELETE FROM SETUP_PROGRAM_PARAMETERS WHERE PARAMETER_ID = #attributes.parameter_id#
		</cfquery>
		<cfquery name="del_param_history" datasource="#dsn#">
			DELETE FROM SETUP_PRG_PARAM_HIST WHERE PARAMETER_ID = #attributes.parameter_id#
		</cfquery>
		<cf_add_log  log_type="-1" action_id="#attributes.parameter_id#" action_name="Akış Parametresi Silindi.">
	</cftransaction>
</cflock>
<script>
	window.location.href="<cfoutput>#request.self#?fuseaction=ehesap.list_program_parameters</cfoutput>";
</script>
