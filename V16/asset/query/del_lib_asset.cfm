<cfquery name="get_assetno" datasource="#dsn#">
	SELECT BARCODE_NO FROM LIBRARY_ASSET WHERE LIB_ASSET_ID =#attributes.lib_asset_id#
</cfquery> 
<cfquery name="DEL_LIB_ASSSET" datasource="#dsn#">
	DELETE 
		FROM
	LIBRARY_ASSET
		WHERE 
	LIB_ASSET_ID = #URL.lib_asset_id#
</cfquery>
<cf_add_log  log_type="-1" action_id="#attributes.lib_asset_id#" action_name="#attributes.head#" paper_no="#get_assetno.barcode_no#">
<script type="text/javascript">
 location.href = document.referrer;
</script>
