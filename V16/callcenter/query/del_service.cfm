<cfquery name="GET_SERVICE" datasource="#DSN#">
	SELECT SERVICE_NO,SERVICE_STATUS_ID,SERVICE_HEAD FROM G_SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
</cfquery>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="DEL_" datasource="#DSN#">
			DELETE FROM G_SERVICE_HISTORY WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
		</cfquery>
		<cfquery name="DEL_" datasource="#DSN#">
			DELETE FROM G_SERVICE_APP_ROWS WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
		</cfquery>
		<cfquery name="DEL_" datasource="#DSN#">
			DELETE FROM G_SERVICE_APP_ROWS_HIST WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
		</cfquery>
		<cfquery name="DEL_" datasource="#DSN#">
			DELETE FROM G_SERVICE_PLUS WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
		</cfquery>
		<cfquery name="DEL_" datasource="#DSN#">
			DELETE FROM G_SERVICE_REPLY WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
		</cfquery>
		<cfquery name="DEL_" datasource="#DSN#">
			DELETE FROM G_SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
		</cfquery>
		<cf_add_log log_type="-1" action_id="#attributes.service_id#" action_name="#get_service.service_head#" paper_no="#get_service.service_no#" process_stage="#get_service.service_status_id#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=call.list_service";
</script>
