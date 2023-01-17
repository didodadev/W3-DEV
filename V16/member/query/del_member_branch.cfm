<cfquery name="de_branch_" datasource="#dsn#">
	DELETE FROM COMPANY_BRANCH_RELATED WHERE RELATED_ID = #attributes.id#
</cfquery>

<script type="text/javascript">
		<cfif not (isDefined('attributes.draggable') and len(attributes.draggable))>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
	</cfif>
</script>
