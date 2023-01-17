<cfquery name="get_process" datasource="#dsn#">
	SELECT CORRESPONDENCE_NUMBER,COR_STAGE FROM CORRESPONDENCE WHERE ID=#attributes.id#
</cfquery>
<cfquery name="DEL_CORRESPONDENCE" datasource="#DSN#">
	DELETE FROM CORRESPONDENCE WHERE ID = #attributes.id#
</cfquery>
<cf_add_log log_type="-1" action_id="#attributes.id#" action_name="#attributes.head#" paper_no="#get_process.correspondence_number#" process_stage="#get_process.cor_stage#">
<cflocation url="#request.self#?fuseaction=correspondence.list_correspondence" addtoken="no">
