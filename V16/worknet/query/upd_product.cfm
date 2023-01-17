<cfset uploadFolder = application.systemParam.systemParam().upload_folder>
<cfset fileSystem = CreateObject("component","V16.asset.cfc.file_system")>
<cfparam name="attributes.is_active" default="0">
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>		
		<cfif isdefined('attributes.product_status')><cfset product_status = 1><cfelse><cfset product_status = 0></cfif>
		<cfparam name="attributes.product_stage" default="">
		<cfset cmp = createObject("component","V16.worknet.cfc.product") />
		<cfset cmp.updProduct(
			product_id:attributes.pid,
			product_stage:attributes.process_stage,
			product_name:attributes.product_name,
			productKeyword:attributes.product_keyword,
			product_brand:attributes.brand_id,
			brand_name:attributes.brand_name,
			product_code:attributes.product_code,
			description:attributes.description,
			product_detail:attributes.product_detail,
			product_catid:attributes.product_catid,
			company_id:attributes.company_id,
			partner_id:attributes.partner_id,
			r_product_multi_id:attributes.r_product_multi_id,
			<!--- product_status:product_status --->
			watalogy_con_id:attributes.watalogy_con_id,
			is_active:attributes.is_active
		) />
	</cftransaction>
</cflock>

<cfif isdefined('session.ep')>
	<cfset process_user_id = session.ep.userid>
<cfelseif  isdefined('session.pp')>
	<cfset process_user_id = session.pp.userid>
</cfif>

<cf_workcube_process
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#process_user_id#' 
	record_date='#now()#' 
	action_table='WORKNET_PRODUCT'
	action_column='PRODUCT_ID'
	action_id='#attributes.pid#'
	action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_product&event=upd&pid=#attributes.pid#' 
	warning_description = 'Worknet Ürün : #attributes.product_name#'>

<cfif ((isdefined("attributes.foldername") and len(attributes.foldername)) and (isdefined('attributes.asset') and len(attributes.asset)))>
	<cfscript>
		folder = "asset_preview\" & attributes.foldername;//dosyaların bulunduğu klasör
		if(directoryexists(uploadFolder & folder)){
			fileList = fileSystem.fileListinFolder(folderPath:folder);	
			if(fileList.recordCount gt 0){
				counter = 0;
				for (file in fileList) {
					assetInfo = structNew();
					assetInfo.fileFullName = createUUID() & "." & ucase(ListLast(file.name,"."));
					assetInfo.filePath = Replace(file.Directory,uploadFolder,"") & "/" & file.name;
					assetInfo.uploadFolder = "#uploadFolder#asset/watalogyImages/";
					fileSystem.rename(assetInfo.filePath,assetInfo.uploadFolder & assetInfo.fileFullName);
					if(isDefined("attributes.old_path") and len(attributes.old_path)){
						cmp.updProductImage(
							product_id : attributes.pid,
							path : "asset/watalogyImages/#assetInfo.fileFullName#",
							detail : attributes.description,
							server_path_id : fusebox.server_machine
						)
					}
					else{
						cmp.addProductImage(
							product_id : attributes.pid,
							path : "asset/watalogyImages/#assetInfo.fileFullName#",
							detail : attributes.description,
							server_path_id : fusebox.server_machine
						)
					}
				}
				counter++;
				try{
					if(fileList.recordCount eq counter) fileSystem.deleteFolder(folder);//dosyaların bulunduğu klasörü siler.
				}catch (any cfcatch) {
				}
			}else{
				WriteOutput('<script>alert("#getLang('assetcare',473)#!");</script>');
			}
		}
	</cfscript>
	<cfif len(attributes.old_path)>
		<cffile action="delete" file="#uploadFolder##attributes.old_path#">
    </cfif>
</cfif>
<script type="text/javascript">
	<cfoutput>
			window.location.href = '#request.self#?fuseaction=worknet.list_product&event=upd&pid=#attributes.pid#';
	</cfoutput>
</script>