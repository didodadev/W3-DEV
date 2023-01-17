<cflock timeout="60">
	<cftransaction>
	<cfquery name="DEL_PAYMETHOD" datasource="#dsn#">
		DELETE FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID=#PAYMETHOD_ID#
	</cfquery>
	<cf_add_log log_type="-1" action_id="#attributes.PAYMETHOD_ID#" action_name="#attributes.head#">
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_paymethod" addtoken="no">
