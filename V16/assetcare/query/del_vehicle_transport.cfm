<cfquery name="del_transport" datasource="#dsn#">
	DELETE 
	FROM 
		ASSET_P_TRANSPORT 
	WHERE 
		SHIP_ID = #attributes.ship_id#
</cfquery>
<cf_add_log log_type="-1" action_id="#attributes.ship_id#" action_name="#attributes.head#" paper_no="#attributes.head#">

<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=assetcare.list_vehicles&event=tr</cfoutput>';
</script>
