<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="DEL_STOPPAGE_RATE" datasource="#dsn2#">
			DELETE FROM SETUP_STOPPAGE_RATES WHERE STOPPAGE_RATE_ID=#STOPPAGE_RATE_ID#
		</cfquery>
		<cf_add_log  log_type="-1" action_id="#attributes.stoppage_rate_id#" action_name="#attributes.head#" data_source="#dsn2#">
		</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_stoppage_rate" addtoken="no">
