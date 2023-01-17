<cfset upd_mail_server = createObject("component","V16.settings.cfc.mail_server_settings")>
<cfset Update =upd_mail_server.Update(
server_name_id:attributes.cpid,
server_name:attributes.server_name
)/>
<script type="text/javascript">
    <cfif not isdefined("attributes.draggable")>
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</cfif>
	window.location.href="<cfoutput>#request.self#?fuseaction=settings.list_mail_server_settings&is_form_submitted=1</cfoutput>";
</script>