<!--- varolan fiziki varlık iliskilendirme--->
<cfquery name="upd_assetp" datasource="#dsn#">
	UPDATE 
		ASSET_P 
	SET
		RELATION_PHYSICAL_ASSET_ID  = #attributes.row_assetp_id#
	WHERE
		ASSETP_ID = #attributes.asset_id#
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','list_member_rel');</cfif>
</script>
