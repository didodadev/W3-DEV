<cfinclude template="../../config.cfm">
<cfset cmp = createObject("component","#addonNS#.components.common.asset") />
<cfset getAssetFolder = cmp.getAssetFolder(asset_cat_id:attributes.asset_cat_id)>
<cfif attributes.asset_cat_id lt 0>
	<cfset upload_folder = "#upload_folder##getAssetFolder.assetcat_path##dir_seperator#">
<cfelse>
	<cfset upload_folder = "#upload_folder#asset#dir_seperator##getAssetFolder.assetcat_path##dir_seperator#">
</cfif>

<cfobject name="fileHelper" component="#addonNS#.components.common.filehelper">
<cfif (isdefined('attributes.is_del') and attributes.is_del eq 1) and (isdefined('attributes.asset_id') and len(attributes.asset_id))>
	<cfif len(attributes.old_file_name) and attributes.old_file_name neq ''>
		<cf_del_server_file output_file="#upload_folder##attributes.old_file_name#" output_server="#attributes.old_file_server_id#">
	</cfif>
	<cfset delAsset = cmp.delAsset(asset_id:attributes.asset_id)>
<cfelseif isdefined('attributes.asset_id') and len(attributes.asset_id)>
	<cfif len(attributes.old_file_name) and attributes.old_file_name neq ''>
		<cf_del_server_file output_file="#upload_folder##attributes.old_file_name#" output_server="#attributes.old_file_server_id#">
	</cfif>
	<cfif attributes.asset_file neq ''>
		<cftry>
			<cfset file_name = fileHelper.save_uploaded_file('asset_file', '#upload_folder#')>
			<cfset file_real_name = filehelper.processedfile.serverfile>
			<cfcatch>
				<script type="text/javascript">
				alert(<cfoutput>'#cfcatch#'</cfoutput>);
				</script>
				<cfabort>
			</cfcatch>
		</cftry>
	<cfelse>
		<cfset file_name = ''>
		<cfset file_real_name = ''>
	</cfif>
	
	<cfset cmp.updAsset(
			asset_id:attributes.asset_id,
			action_id:attributes.action_id,
			action_section:attributes.action_section,
			asset_cat_id:attributes.asset_cat_id,
			file_name:file_name,
			file_real_name:file_real_name,
			asset_name:attributes.asset_name,
			detail:attributes.detail,
			property_id:attributes.property_id
		) />
	
<cfelse>
	<cftry>
		<cfset file_name = fileHelper.save_uploaded_file('asset_file', '#upload_folder#')>
		<cfcatch>
			<script type="text/javascript">
			alert(<cfoutput>'#catch#'</cfoutput>);
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
	<cfset cmp.addAsset(
			action_id:attributes.action_id,
			action_section:attributes.action_section,
			asset_cat_id:attributes.asset_cat_id,
			file_name:file_name,
			file_real_name:cffile.serverfile,
			asset_name:attributes.asset_name,
			detail:attributes.detail,
			property_id:attributes.property_id
		) />
</cfif>
<script type="text/javascript">
	window.top.reload_this_asset();
</script>

