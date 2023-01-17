<cfif isdefined('session.ep.userid')>
	<cfset our_comp_id = session.ep.company_id>
<cfelseif isdefined('session.pp.userid')>
	<cfset our_comp_id = session.pp.our_company_id>
</cfif>

<cfquery name="get_file_size_comp" datasource="#dsn#">
	SELECT FILE_SIZE,IS_FILE_SIZE FROM OUR_COMPANY_INFO WHERE COMP_ID=#our_comp_id#
</cfquery>
<cfset upload_folder = "#upload_folder#product#dir_seperator#">
<cfif isdefined('attributes.product_id') and len(attributes.product_id)>
	<!---image --->
	<cfif isDefined("attributes.product_image") and len(attributes.product_image)>
		<cftry>
			<cffile action="UPLOAD" filefield="product_image" destination="#upload_folder#" mode="777" nameconflict="MAKEUNIQUE" accept="image/*">
			<cfcatch type="Any">
				<script type="text/javascript">
					alert("<cf_get_lang_main no ='43.Dosyaniz Upload Edilemedi ! Dosyanizi Kontrol Ediniz'> !");
				</script>
			</cfcatch>  
		</cftry>
		<cfset product_image_file_name = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##product_image_file_name#.#cffile.serverfileext#">
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder##product_image_file_name#.#cffile.serverfileext#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarinda Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>	
		<cfset attributes.product_image = '#product_image_file_name#.#cffile.serverfileext#'>
		<!--- dosya boyutu kontrol --->
		<cfif get_file_size_comp.is_file_size>
			<cfquery name="get_file_size" datasource="#dsn#">
				SELECT FORMAT_SYMBOL,FORMAT_SIZE FROM SETUP_FILE_FORMAT WHERE FORMAT_SYMBOL='#assetTypeName#'
			</cfquery>
			<cfif get_file_size.recordcount and len(get_file_size.format_size)>
				<cfset dt_size=get_file_size.format_size * 1048576>
				<cfif INT(dt_size) lte INT(filesize)>
					<cfif FileExists("#upload_folder##attributes.product_image#")>
						<cffile action="delete" file="#upload_folder##attributes.product_image#">
					</cfif>
					 <script type="text/javascript">
						alert('Katalog imajı ' + <cfoutput>#get_file_size.format_size#</cfoutput> + ' MB dan fazla olmamalıdır.');
						history.back();
					</script>
					<cfabort>
				</cfif>
			</cfif>
		</cfif>
		<!--- dosya boyutu kontrol --->
		<cfif len(attributes.old_img_name)>
			<cf_del_server_file output_file="#upload_folder##attributes.old_img_name#" output_server="#attributes.old_img_server_id#">
			<cfset delProductImage = createObject("component","V16.worknet.query.worknet_product").delProductImage(product_image_id:attributes.product_image_id)>
		</cfif>
	<cfelse>
		<cfset attributes.product_image = ''>
	</cfif>
	
	<!--- asset --->
	<cfif isDefined("attributes.product_asset") and len(attributes.product_asset)>
		<cfif len(attributes.old_file_name)>
			<cf_del_server_file output_file="#upload_folder##attributes.old_file_name#" output_server="#attributes.old_file_server_id#">
			<cfset delAsset = createObject("component","V16.worknet.query.worknet_asset").delAsset(asset_id:attributes.asset_id)>
		</cfif>
		<cffile action = "upload" fileField = "product_asset" destination = "#upload_folder#" nameConflict = "MakeUnique" mode="777" >
		<cfset file_name = "#createUUID()#">
		<cfset product_asset_file_name = "#file_name#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##product_asset_file_name#">
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
		<cfset product_asset_real_name = cffile.serverfile>
		<cfset attributes.product_asset = product_asset_file_name>
		
		<!--- dosya boyutu kontrol --->
		<cfif get_file_size_comp.is_file_size>
			<cfquery name="get_file_size" datasource="#dsn#">
				SELECT FORMAT_SYMBOL,FORMAT_SIZE FROM SETUP_FILE_FORMAT WHERE FORMAT_SYMBOL='#assetTypeName#'
			</cfquery>
			<cfif get_file_size.recordcount and len(get_file_size.format_size)>
				<cfset dt_size=get_file_size.format_size * 1048576>
				<cfif INT(dt_size) lte INT(filesize)>
					<cfif FileExists("#upload_folder##attributes.product_asset#")>
						<cffile action="delete" file="#upload_folder##attributes.product_asset#">
					</cfif>
					 <script type="text/javascript">
						alert('Katalog belgesi ' + <cfoutput>#get_file_size.format_size#</cfoutput> + ' MB dan fazla olmamalıdır.');
						history.back();
					</script>
					<cfabort>
				</cfif>
			</cfif>
		</cfif>
		<!--- dosya boyutu kontrol --->
	<cfelse>
		<cfset attributes.product_asset = ''>
		<cfset product_asset_real_name =  ''>
	</cfif>
	
	<cfif isdefined('attributes.product_status')><cfset product_status = 1><cfelse><cfset product_status = 0></cfif>
		
	<cfset cmp = createObject("component","V16.worknet.query.worknet_product") />
    <cfset cmp.updProduct(
            company_id:attributes.company_id,
			partner_id:attributes.partner_id,
			product_id:attributes.product_id,
            product_catid:attributes.product_catid,
            product_stage:attributes.process_stage,
            product_name:attributes.product_name,
            productKeyword:attributes.product_keyword,
            product_brand:'',
            product_code:'',
            description:attributes.description,
            product_detail:attributes.product_name,
            product_status:product_status
        ) />
    
<cfelse>
	<cfif isDefined("attributes.product_image") and len(attributes.product_image)>
		<cftry>
			<cffile action="UPLOAD" filefield="product_image" destination="#upload_folder#" mode="777" nameconflict="MAKEUNIQUE" accept="image/*">
			<cfcatch type="Any">
				<script type="text/javascript">
					alert("<cf_get_lang_main no ='43.Dosyaniz Upload Edilemedi ! Dosyanizi Kontrol Ediniz'> !");
				</script>
			</cfcatch>  
		</cftry>
		<cfset product_image_file_name = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##product_image_file_name#.#cffile.serverfileext#">
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder##product_image_file_name#.#cffile.serverfileext#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarinda Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>	
		<cfset attributes.product_image = '#product_image_file_name#.#cffile.serverfileext#'>
		<!--- dosya boyutu kontrol --->
		<cfif get_file_size_comp.is_file_size>
			<cfquery name="get_file_size" datasource="#dsn#">
				SELECT FORMAT_SYMBOL,FORMAT_SIZE FROM SETUP_FILE_FORMAT WHERE FORMAT_SYMBOL='#assetTypeName#'
			</cfquery>
			<cfif get_file_size.recordcount and len(get_file_size.format_size)>
				<cfset dt_size=get_file_size.format_size * 1048576>
				<cfif INT(dt_size) lte INT(filesize)>
					<cfif FileExists("#upload_folder##attributes.product_image#")>
						<cffile action="delete" file="#upload_folder##attributes.product_image#">
					</cfif>
					 <script type="text/javascript">
						alert('Katalog imajı ' + <cfoutput>#get_file_size.format_size#</cfoutput> + ' MB dan fazla olmamalıdır.');
						history.back();
					</script>
					<cfabort>
				</cfif>
			</cfif>
		</cfif>
		<!--- dosya boyutu kontrol --->
	<cfelse>
		<cfset attributes.product_image = ''>
	</cfif>
	
	<cfif isDefined("attributes.product_asset") and len(attributes.product_asset)>
		<cffile action = "upload" fileField = "product_asset" destination = "#upload_folder#" nameConflict = "MakeUnique" mode="777" >
		<cfset file_name = "#createUUID()#">
		<cfset product_asset_file_name = "#file_name#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##product_asset_file_name#">
		
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder##file_name#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>	
		<cfset product_asset_real_name = cffile.serverfile>
		<cfset attributes.product_asset = product_asset_file_name>
		<!--- dosya boyutu kontrol --->
		<cfif get_file_size_comp.is_file_size>
			<cfquery name="get_file_size" datasource="#dsn#">
				SELECT FORMAT_SYMBOL,FORMAT_SIZE FROM SETUP_FILE_FORMAT WHERE FORMAT_SYMBOL='#assetTypeName#'
			</cfquery>
			<cfif get_file_size.recordcount and len(get_file_size.format_size)>
				<cfset dt_size=get_file_size.format_size * 1048576>
				<cfif INT(dt_size) lte INT(filesize)>
					<cfif FileExists("#upload_folder##attributes.product_asset#")>
						<cffile action="delete" file="#upload_folder##attributes.product_asset#">
					</cfif>
					 <script type="text/javascript">
						alert('Katalog belgesi ' + <cfoutput>#get_file_size.format_size#</cfoutput> + ' MB dan fazla olmamalıdır.');
						history.back();
					</script>
					<cfabort>
				</cfif>
			</cfif>
		</cfif>
		<!--- dosya boyutu kontrol --->
	<cfelse>
		<cfset attributes.product_asset = ''>
		<cfset product_asset_real_name =  ''>
	</cfif>

    <cfset cmp = createObject("component","V16.worknet.query.worknet_product") />
	<cfset cmp.addProduct(
            is_catalog:1,
			company_id:attributes.company_id,
            partner_id:attributes.partner_id,
            product_catid:attributes.product_catid,
            product_stage:attributes.process_stage,
            product_name:trim(attributes.product_name),
            productKeyword:trim(attributes.product_keyword),
            product_brand:'',
            product_code:'',
            product_image:'',
            description:trim(attributes.description),
            product_detail:trim(attributes.product_name)
        ) />
    
	<cfquery name="maxProduct" datasource="#dsn1#">
		SELECT MAX(PRODUCT_ID) AS MAX_ID FROM WORKNET_PRODUCT
	</cfquery>
	
	<cfset attributes.product_id = maxProduct.max_id>
</cfif>	

<cfif len(attributes.product_image)>
	<cfset createObject("component","V16.worknet.query.worknet_product").addProductImage(
			product_id:attributes.product_id,
			path:attributes.product_image,
			image_type:1,
			detail:attributes.product_name
		) />
</cfif>	

<cfif len(attributes.product_asset)>
	<cfset createObject("component","V16.worknet.query.worknet_asset").addAsset(
		action_id:attributes.product_id,
		action_section:'WORKNET_PRODUCT_ID',
		asset_cat_id:-25,
		file_name:attributes.product_asset,
		file_real_name:product_asset_real_name,
		asset_name:attributes.product_name
	) />
</cfif>	

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
	action_id='#attributes.product_id#'
	action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_product&pid=#attributes.product_id#' 
	warning_description = 'Ürün : #attributes.product_name#'>

<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_catalog&pid=#attributes.product_id#" addtoken="no">

