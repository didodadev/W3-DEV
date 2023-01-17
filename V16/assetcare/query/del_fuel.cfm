<cfquery name="del_fuel" datasource="#dsn#">
	DELETE
	FROM 
		ASSET_P_FUEL
	WHERE 
		FUEL_ID = #attributes.fuel_id#
</cfquery>
<cf_add_log  log_type="-1" action_id="#attributes.fuel_id#" action_name="#attributes.plaka#" paper_no="attributes.fuel_num" >
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=assetcare.list_vehicles&event=add_fuel</cfoutput>';
</script>


