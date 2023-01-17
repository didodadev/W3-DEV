<cfset cmp = createObject("component","V16.worknet.query.worknet_asset") />
<cfset getAssetFolder = cmp.getAssetFolder(asset_cat_id:attributes.asset_cat_id)>
<cfif attributes.asset_cat_id lt 0>
	<cfset upload_folder = "#upload_folder##getAssetFolder.assetcat_path##dir_seperator#">
<cfelse>
	<cfset upload_folder = "#upload_folder#asset#dir_seperator##getAssetFolder.assetcat_path##dir_seperator#">
</cfif>

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
		<cffile action = "upload" fileField = "asset_file" destination = "#upload_folder#" nameConflict = "MakeUnique" mode="777">
		<cfset file_name = "#createUUID()#">
		<cfset file_name = "#file_name#.#cffile.serverfileext#">	
		<cfset file_real_name = cffile.serverfile>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder##file_name#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
			</script>
			<cfabort>
		</cfif>	
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
	<cffile action = "upload" fileField = "asset_file" destination = "#upload_folder#" nameConflict = "MakeUnique" mode="777" >
	<cfset filesize = cffile.filesize />
	<cfset file_name = "#createUUID()#">
	<cfset file_name = "#file_name#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">
	<!---Script dosyalarını engelle  02092010 FA-ND --->
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
	<cfif listfind(blackList,assetTypeName,',')>
		<cffile action="delete" file="#upload_folder##file_name#">
		<script type="text/javascript">
			alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
		</script>
		<cfabort>
	</cfif>
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

