<cfquery name="del_group_par" datasource="#DSN3#">
	DELETE FROM 
		CAMPAIGN_TEAM
	WHERE
		PARTNER_ID= #URL.partner_id#  	 
		AND CAMPAIGN_ID=#URL.CAMPAIGN_ID#
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_list_correspondence1_menu' );
	</cfif>
</script>
