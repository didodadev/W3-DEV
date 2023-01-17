<cfquery name="del_km" datasource="#dsn#">
	DELETE FROM ASSET_P_KM_CONTROL WHERE KM_CONTROL_ID = #attributes.km_control_id#
</cfquery>
<cf_add_log log_type="-1" action_id="#attributes.km_control_id#" action_name="#attributes.plaka#">
<script type="text/javascript">
	 window.location.href='<cfoutput>#request.self#?fuseaction=assetcare.list_vehicles&event=add_km&assetp_id=#attributes.assetp_id#</cfoutput>';
</script>
