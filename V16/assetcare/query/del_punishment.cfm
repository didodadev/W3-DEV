<cfquery name="del_punishment" datasource="#dsn#">
	DELETE FROM 
		ASSET_P_PUNISHMENT
	WHERE 
		PUNISHMENT_ID = #attributes.punishment_id#
</cfquery>
<cf_add_log  log_type="-1" action_id="#attributes.punishment_id#" action_name="Ceza:#attributes.plaka#" paper_no="#attributes.plaka#">
<cfif isdefined("attributes.is_detail")>
	<script type="text/javascript">
		wrk_opener_reload(); 
		self.close();
	</script>
<cfelse>
	<script type="text/javascript">
		window.parent.frame_punishment_list.location.reload();
		window.parent.frame_punishment.location.href='<cfoutput>#request.self#?fuseaction=assetcare.popup_add_punishment</cfoutput>&iframe=1';
	</script>
</cfif>
