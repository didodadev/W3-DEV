<cfquery name="DEL_PROPERTY_DETAIL" datasource="#DSN1#">
	DELETE FROM
		PRODUCT_PROPERTY_DETAIL
	WHERE 
		PROPERTY_DETAIL_ID = #attributes.property_detail_id#
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</cfif>
</script>
