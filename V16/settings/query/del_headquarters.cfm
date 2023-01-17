<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="Del_HeadQuarters" datasource="#dsn#">
			DELETE FROM SETUP_HEADQUARTERS WHERE HEADQUARTERS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.head_id#">
		</cfquery>
		<cfquery name="Del_HeadQuarters_History" datasource="#dsn#">
			DELETE FROM SETUP_HEADQ_HISTORY WHERE HEADQUARTERS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.head_id#">
		</cfquery>
		<cf_add_log  log_type="-1" action_id="#attributes.head_id#" action_name="#attributes.head#">
	</cftransaction>
</cflock>
<cfif isdefined("attributes.is_hr") and attributes.is_hr eq 1>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#?fuseaction=hr.list_headquarters&hr=1</cfoutput>';
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#?fuseaction=settingshr.list_headquarters</cfoutput>';
	</script>
</cfif>
