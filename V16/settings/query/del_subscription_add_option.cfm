<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="DEL_SUBS_ADD_OPTIONS" datasource="#dsn3#">
			DELETE FROM SETUP_SUBSCRIPTION_ADD_OPTIONS WHERE SUBSCRIPTION_ADD_OPTION_ID=#attributes.subs_option_id#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.add_subscription_add_option" addtoken="no">
