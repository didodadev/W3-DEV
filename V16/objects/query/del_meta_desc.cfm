<cfquery name="del_meta_desc" datasource="#dsn#">
	DELETE FROM 
		META_DESCRIPTIONS
	WHERE
		META_DESC_ID = #attributes.meta_desc_id#
</cfquery>

<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_get_meta_desc_');
	</cfif>
</script>

