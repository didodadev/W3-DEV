<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="DEL_STOPPAGE_RATE" datasource="#dsn#">
			DELETE FROM SETUP_STOCKBOND_TYPE WHERE STOCKBOND_TYPE_ID=#stockbond_type_id#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_stockbond_type" addtoken="no">
