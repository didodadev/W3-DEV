<cflock timeout="60">
	<cftransaction>
	<cfquery name="DEL_COMPUTER_INFO" datasource="#dsn#">
		DELETE FROM SETUP_PDKS_TYPES WHERE PDKS_TYPE_ID = #attributes.PDKS_type_id#
	</cfquery>
	<cf_add_log  log_type="-1" action_id="#attributes.PDKS_type_id#" action_name="pdks TİPİ">
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_pdks_type" addtoken="no">
