<cflock timeout="60">
	<cftransaction>
	<cfquery name="DEL_COMPUTER_INFO" datasource="#dsn#">
		DELETE FROM SETUP_TRANSPORT_TYPES WHERE TRANSPORT_TYPE_ID = #attributes.transport_type_id#
	</cfquery>
	<cf_add_log  log_type="-1" action_id="#attributes.transport_type_id#" action_name="ulaşım TİPİ" >
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_transport_type" addtoken="no">
