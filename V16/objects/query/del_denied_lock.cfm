<cfquery name="del_denied" datasource="#dsn#">
	DELETE FROM DENIED_PAGES_LOCK WHERE DENIED_PAGE_ID = #attributes.denied_page_id#
</cfquery>
<cf_add_log  log_type="-1" action_id="#attributes.denied_page_id#" action_name="#attributes.head#">
<script type="text/javascript">
	<cfif isdefined("attributes.draggable")>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif>
</script>
