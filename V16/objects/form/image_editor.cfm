<script src="/JS/temp/image_editor/prototype.js" type="text/javascript"></script>   
<script src="/JS/temp/image_editor/scriptaculous.js?load=builder,dragdrop" type="text/javascript"></script>    
<script src="/JS/temp/image_editor/builder.js"	type="text/javascript" ></script>
<script src="/JS/temp/image_editor/dragdrop.js"	type="text/javascript" ></script>
<script src="/JS/temp/image_editor/cropper.js"	type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="/JS/temp/image_editor/cropper.css" media="screen">
<cfif isdefined("attributes.asset_id")>
	<cfinclude template="../../asset/query/get_asset.cfm">
	<cfset path=''>
	<cfquery name="GET_PATH" datasource="#DSN#">
		SELECT ASSETCAT_PATH FROM ASSET_CAT WHERE ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_asset.assetcat_id#">
	</cfquery>
	<cfset path = get_path.assetcat_path>
	<cfif len(get_asset.related_company_id)>
		<cfif get_asset.assetcat_id gte 0>
			<cfset folder="member_folders/company_#get_asset.related_company_id#/asset/#path#">
		<cfelse>
			<cfset folder="member_folders/company_#get_asset.related_company_id#/#path#">
		</cfif>
	<cfelseif len(get_asset.related_consumer_id)>
		<cfif get_asset.assetcat_id gte 0>
			<cfset folder="member_f	olders/consumer_#get_asset.related_consumer_id#/asset/#path#">
		<cfelse>
			<cfset folder="member_folders/consumer_#get_asset.related_consumer_id#/#path#">
		</cfif>
	<cfelse>
		<cfif get_asset.assetcat_id gte 0>
			<cfset folder="asset/#path#">
		<cfelse>
			<cfset folder="#path#">
		</cfif>
	</cfif>
	<cfset file_path = "#upload_folder##folder##dir_seperator#">
	<cfset file_path_iis = "/documents/#folder#">
	<cfset file_name = "#get_asset.asset_file_name#">
<cfelseif isdefined("attributes.asset_cat_id") and isdefined("attributes.old_file_name")>
	<cfquery name="find_folder" datasource="#dsn#">
    	SELECT ASSETCAT_ID,ASSETCAT_PATH FROM ASSET_CAT WHERE ASSETCAT_ID = #attributes.asset_cat_id#
    </cfquery>
    <cfset folder = find_folder.ASSETCAT_PATH>
	<cfset file_path = "#upload_folder##folder##dir_seperator#">
    <cfset file_name = attributes.old_file_name>
<cfelseif isdefined("attributes.product_id") and isdefined("attributes.product_image_path")>
	<cfset file_path = "#upload_folder#product#dir_seperator#">
    <cfset file_name = attributes.product_image_path>
</cfif>
<cfset file_match =  REMatch(".+?\.(jpg|bmp|jpeg|gif|png|JPG|PNG|BMP|JPEG|GIF)","#file_name#")>
<cfset file_name = ArrayToList(file_match)>
<cfif Len(file_name)>
	<cfinclude template="image_editor_in.cfm">
<cfelse>
	<cf_get_lang dictionary_id='38367.Dosya İmaj Editör İçin Uygun Değil'>!
</cfif>