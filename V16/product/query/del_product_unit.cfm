<cfquery name="DEL_UNIT" datasource="#dsn1#">
	DELETE FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_ID=#UNIT_ID#
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_product_unit_detail');
	</cfif>
</script>
