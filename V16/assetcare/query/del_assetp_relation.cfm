<!---fiziki varligin iliski kaydi bosaltilir --->
<cfquery name="upd_asset_relation" datasource="#dsn#">
	UPDATE
		ASSET_P
	SET 
		RELATION_PHYSICAL_ASSET_ID = NULL
	WHERE
		ASSETP_ID = #attributes.assetp_id#
</cfquery>
<script type="text/javascript">
<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','list_member_rel');</cfif>
</script>

