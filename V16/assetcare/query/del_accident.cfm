<cfquery name="DEL_ACCIDENT" datasource="#dsn#">
	DELETE FROM 
		ASSET_P_ACCIDENT
	WHERE 
		ACCIDENT_ID = #attributes.accident_id#
</cfquery>
<cfif isdefined("attributes.is_detail")>
	<script type="text/javascript">
		wrk_opener_reload(); 
		self.close();
	</script>
<cfelse>
	<script type="text/javascript">
		window.parent.frame_accident_list.location.reload();
		window.parent.frame_accident.location.href='<cfoutput>#request.self#?fuseaction=assetcare.popup_add_accident</cfoutput>&iframe=1';
	</script>
</cfif>
