<cfset uploadFolder = application.systemParam.systemParam().upload_folder>
<cfset fileSystem = CreateObject("component","V16.asset.cfc.file_system")>
<cfset asset_component = CreateObject("component","V16.worknet.cfc.product")>

<cfset productInsert = createObject("component","V16.worknet.cfc.product")>
<cfparam name="attributes.product_stage" default="">
<cfparam name="attributes.action_id" default="">
<cfset response = productInsert.addProduct(
	product_stage      :   attributes.product_stage,
	product_name          :   attributes.product_name,
	product_keyword          :   attributes.product_keyword,
	brand_id          :   attributes.brand_id,
 	brand_name          :   attributes.brand_name,
 	product_code          :   attributes.product_code,
	description          :   attributes.description,
	product_detail          :   attributes.product_detail,
	product_catid          :   attributes.product_catid,
	company_id     :   attributes.company_id,
	partner_id     :   attributes.partner_id,
	r_product_multi_id	:		attributes.r_product_multi_id,
	<!--- related_product_id	:		attributes.related_product_id, --->
	watalogy_con_id	:		attributes.watalogy_con_id
)>
<cfif response.status>
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
						productInsert.addProductImage(
							product_id : response.result.IDENTITYCOL,
							path : "asset/watalogyImages/#assetInfo.fileFullName#",
							detail : attributes.description,
							server_path_id : fusebox.server_machine
						)
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
	
	</cfif>
	<script type="text/javascript">
		<cfoutput>
				window.location.href = '#request.self#?fuseaction=worknet.list_product&event=upd&pid=#response.result.IDENTITYCOL#';
		</cfoutput>
	</script>
<cfelse>
	 <script>
			 alert('<cf_get_lang dictionary_id = "48344">');
	 </script>
</cfif>