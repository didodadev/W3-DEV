<cfquery name="ADD_RELATED_PRODUCT" datasource="#dsn3#">
	DELETE FROM PRODUCT_VISION WHERE VISION_ID = #attributes.vision_id#
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
		location.reload();
	</cfif>
</script>
