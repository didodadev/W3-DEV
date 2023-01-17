
<cfset del_mail_server = createObject("component","V16.settings.cfc.mail_server_settings")>
<cfset Delete =del_mail_server.Delete(
server_name_id:attributes.cpid
)/>
<script type="text/javascript">
    <cfif not isdefined("attributes.draggable")>
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</cfif>
	window.location.href="<cfoutput>#request.self#?fuseaction=settings.list_mail_server_settings&is_form_submitted=1</cfoutput>";
</script>