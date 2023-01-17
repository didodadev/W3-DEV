<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.asset_cat" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.record_par_id" default="">
<cfparam name="attributes.assetcat_id" default="">
<cfparam name="attributes.PROCESS_STAGE" default="">
<cfparam name="attributes.FORMAT" default="">
<cfparam name="attributes.IS_VIEW" default="">  
<cfparam name="attributes.EMPLOYEE_VIEW" default=""> 
<cfparam name="attributes.IS_INTERNET" default="">
<cfparam name="attributes.IS_EXTRANET" default="">
<cfparam name="attributes.OUR_COMPANY_ID" default="">
<cfparam name="attributes.assetcat_name" default="">
<cfparam name="attributes.record_date1" default="">
<cfparam name="attributes.record_date2" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.is_excel" default="0">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset uploadFolder = application.systemParam.systemParam().upload_folder />
<cfset fileSystem = CreateObject("component","V16.asset.cfc.file_system")>

<cfif not isdefined("attributes.is_form_submitted")>
	<cfset attributes.is_active = 1>
</cfif>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
	SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT ORDER BY ASSETP_CAT
</cfquery>
<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%asset.list_asset%">
	ORDER BY 
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="FORMAT" datasource="#dsn#">
	SELECT FORMAT_SYMBOL FROM SETUP_FILE_FORMAT ORDER BY FORMAT_SYMBOL
</cfquery>
<cfquery name="GET_POSITION_COMPANIES" datasource="#DSN#">
    SELECT DISTINCT
        SP.OUR_COMPANY_ID,
        O.NICK_NAME
    FROM
        EMPLOYEE_POSITIONS EP,
        SETUP_PERIOD SP,
        EMPLOYEE_POSITION_PERIODS EPP,
        OUR_COMPANY O
    WHERE 
        SP.OUR_COMPANY_ID = O.COMP_ID AND
        SP.PERIOD_ID = EPP.PERIOD_ID AND
        EP.POSITION_ID = EPP.POSITION_ID AND
        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	ORDER BY
		O.NICK_NAME
</cfquery>
<cfif isdefined("is_form_submitted")>
	<cfinclude template="../../asset/query/get_assets.cfm">
	<cfparam name='attributes.totalrecords' default="#get_assets.QUERY_COUNT#">
<cfelse>
	<cfparam name='attributes.totalrecords' default="0">
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="31476.Dijital Varlıklarım"></cfsavecontent>
<cf_big_list_search export="0" title="#message#">
    <cfform name="search_asset" action="#request.self#?fuseaction=myhome.digital_assets" method="post">
        <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
        <cf_big_list_search_area>
			<div class="row"> 
				<div class="col col-12 form-inline">
					<div class="form-group" id="item-keyword">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='48.main'></label>
					</div>
					<div class="form-group" id="item-keyword">
						<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50">
					</div>
					<div class="form-group">
						<label><cf_get_lang dictionary_id='58594.Format'></label>
					</div>
					<div class="form-group" id="item-format">
						<select name="format" id="format">
							<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
							<cfoutput query="format">
								<option value=".#format_symbol#"<cfif isdefined("attributes.format") and attributes.format is '.#format_symbol#'>selected</cfif>>#format_symbol#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group">
						<label><cf_get_lang dictionary_id='29536.Tüm Kategoriler'></label>
					</div>
					<div class="form-group" id="item-assetcat_id">
						<!---
						<cf_wrk_selectlang
						name="assetcat_id"
						option_name="assetcat"
						option_value="assetcat_id"
						table_name="ASSET_CAT"
						value="#attributes.assetcat_id#"
						sort_type="assetcat"
						width="250">
						---->
						<div class="input-group">
							<input type="hidden" name="assetcat_id" id="assetcat_id" <cfif len(attributes.assetcat_id) and len(attributes.assetcat_id)> value="<cfoutput>#attributes.assetcat_id#</cfoutput>"</cfif>>
							<input type="text" name="assetcat_name" id="assetcat_name" value="<cfoutput>#attributes.assetcat_name#</cfoutput>" onfocus="AutoComplete_Create('assetcat_name','ASSETCAT','ASSETCAT_PATH','get_asset_cat','0','ASSETCAT_ID','assetcat_id','','3','130');" autocomplete="off">
							<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_asset_cat&chooseCat=1&form_name=search_asset&field_id=assetcat_id&field_name=assetcat_name','list');"></span>			
						</div>
					</div>
					<div class="form-group x-3_5">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</div>
					<div class="form-group">
						<cf_wrk_search_button><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
					</div>
				</div>
			</div>
        </cf_big_list_search_area>
        <cf_big_list_search_detail_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-4 col-xs-12">
								<div class="form-group" id="item-process_stage">
									<label class="col col-4 col-xs-12 text-right"><cf_get_lang dictionary_id='58859.Süreç'></label>
									<div class="col col-8 col-xs-12">
										<select name="process_stage" id="process_stage">
											<option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
											<cfoutput query="get_process_stage">
												<option value="#process_row_id#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq process_row_id)>selected</cfif> >#stage#</option>
											</cfoutput>
											<option value="" <cfif isdefined("attributes.process_stage") and (attributes.process_stage is 'null')>selected</cfif> ><cf_get_lang dictionary_id= '29815.Aşamasız'></option>
										</select>
									</div>
								</div>
								<div class="form-group" id="item-project_head">
									<label class="col col-4 col-xs-12 text-right"><cf_get_lang dictionary_id='57416.Proje'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="project_id" id="project_id" value="<cfif len(attributes.project_head)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
											<input type="text" name="project_head" id="project_head" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','125');" value="<cfoutput>#attributes.project_head#</cfoutput>" autocomplete="off">
											<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=frm_search.project_head&project_id=frm_search.project_id</cfoutput>');"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-property_id">
									<label class="col col-4 col-xs-12 text-right"><cf_get_lang dictionary_id='58067.Döküman Tipi'></label>
									<div class="col col-8 col-xs-12">
										<cfif not isdefined("attributes.property_id")><cfset attributes.property_id = ""></cfif>
											<cf_wrk_combo 
												name="property_id"
												query_name="GET_CONTENT_PROPERTY"
												value="#attributes.property_id#"
												option_name="name"
												option_value="content_property_id"
												width="250">	
									</div>
								</div>
								<div class="form-group" id="item-project_head">
									<label class="col col-4 col-xs-12 text-right"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
									<div class="col col-8 col-xs-12">
										<input type="hidden" name="record_par_id" id="record_par_id" value="<cfoutput>#attributes.record_par_id#</cfoutput>">
										<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif isdefined("attributes.record_emp_id")><cfoutput>#attributes.record_emp_id#</cfoutput><cfelse><cfoutput>#session.ep.userid#</cfoutput></cfif>">
										<input type="text" name="record_member"  value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>" readonly>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-xs-12">
								<div class="form-group" id="item-is_view">
									<label class="col col-4 col-xs-12 text-right"><cf_get_lang dictionary_id='29452.Varlık'> <cf_get_lang dictionary_id='30111.Durumu'></label>
									<div class="col col-8 col-xs-12">
										<select name="is_view" id="is_view">
											<option value=""><cf_get_lang dictionary_id='42258.Varlık Durumu'></option>
											<option value="1"<cfif isdefined("attributes.is_view") and (attributes.is_view eq 1)>selected</cfif>><cf_get_lang dictionary_id ='58079.İnternet'></option>
											<option value="0"<cfif isdefined("attributes.is_view") and (attributes.is_view eq 0)>selected</cfif>><cf_get_lang dictionary_id='47864.Normal'></option>
										</select>
									</div>
								</div>
								<div class="form-group" id="item-product_name">
									<label class="col col-4 col-xs-12 text-right"><cf_get_lang dictionary_id='57657.Ürün'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_id) and len(attributes.product_name)> value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
											<input type="text" name="product_name" id="product_name" style="width:125px;" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','130');" value="<cfif len(attributes.product_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" autocomplete="off">
											<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=search_asset.product_id&field_name=search_asset.product_name&keyword='+encodeURIComponent(document.getElementById('product_name').value),'list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-our_company_id">
									<label class="col col-4 col-xs-12 text-right"><cf_get_lang dictionary_id='57574.Sirket'></label>
									<div class="col col-8 col-xs-12">
										<select name="our_company_id" id="our_company_id">
											<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
											<cfoutput query="get_position_companies">
												<option value="#our_company_id#" <cfif isdefined("attributes.our_company_id") and attributes.our_company_id eq our_company_id>selected</cfif>>#nick_name#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group" id="item-record_date">
									<label class="col col-4 col-xs-12 text-right"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
									<div class="col col-4 col-xs-6">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='47709.Kayıt Tarihini Kontrol Ediniz!'>!</cfsavecontent> 
											<cfinput type="text" name="record_date1" id="record_date1" value="#dateformat(attributes.record_date1,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
											<span class="input-group-addon"><cf_wrk_date_image date_field="record_date1"></span>
										</div>
									</div>
									<div class="col col-4 col-xs-6">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='47709.Kayıt Tarihini Kontrol Ediniz!'>!</cfsavecontent> 
											<cfinput type="text" name="record_date2" id="record_date2" value="#dateformat(attributes.record_date2,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
											<span class="input-group-addon"><cf_wrk_date_image date_field="record_date2"></span>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-xs-12">
								<div class="form-group col-xs-12" id="item-active">
									<label class="container"><cf_get_lang dictionary_id='57493.Aktif'>
									<input type="checkbox" name="is_active" id="is_active" value="1" <cfif isdefined("attributes.is_active")>checked</cfif>>
									<span class="checkmark"></span>
									</label>
								</div>

								<div class="form-group col-xs-12" id="item-is_special">
									<label class="container"><cf_get_lang dictionary_id='47857.Özel Belge'>
									<input type="checkbox" name="is_special" id="is_special" value="1" <cfif isdefined("attributes.is_special")>checked</cfif>>
									<span class="checkmark"></span>
									</label>
								</div>

								<div class="form-group col-xs-12" id="item-featured">
									<label class="container"><cf_get_lang dictionary_id='47868.Önem Derecesi Yüksek'>
									<input type="checkbox" name="featured" id="featured" value="1" <cfif isdefined("attributes.featured")>checked</cfif>>
									<span class="checkmark"></span>
									</label>
								</div>	
								<div class="form-group col-xs-12" id="item-intranet">
									<label class="container"><cf_get_lang dictionary_id='48223.İntranette paylaşılanlarda ara'>
									<input type="checkbox" name="employee_view" id="employee_view" value="1" <cfif isdefined("attributes.employee_view") and attributes.employee_view is 1>checked</cfif>>
									<span class="checkmark"></span>
									</label>
								</div>

								<div class="form-group col-xs-12" id="item-internet">
									<label class="container"><cf_get_lang dictionary_id='48235.İnternette Paylaşılanda ara'>
									<input type="checkbox" name="is_internet" id="is_internet" value="1" <cfif isdefined("attributes.is_internet") and attributes.is_internet is 1>checked</cfif>>
									<span class="checkmark"></span>
									</label>
								</div>

								<div class="form-group col-xs-12" id="item-extranet">
									<label class="container"><cf_get_lang dictionary_id='48236.Extranette paylaşılanlarda ara'>
									<input type="checkbox" name="is_extranet" id="is_extranet" value="1" <cfif isdefined("attributes.is_extranet") and attributes.is_extranet is 1>checked</cfif>>
									<span class="checkmark"></span>
									</label>
								</div>	
							</div>
						</div>
					</div>
				</div>
			</div>
        </cf_big_list_search_detail_area>
    </cfform>
</cf_big_list_search>
<cfset colspan = 11>
<cfset property_list = ''>
<cfset mediaplayer_extensions = ".asf,.wma,.avi,.mp3,.mp2,.mpa,.mid,.midi,.rmi,.aif,.aifc,aiff,.au,.snd,.wav,.cda,.wmv,.wm,.dvr-ms,.mpe,.mpeg,.mpg,.m1v,.vob" />
<cfset icon = false>
<cfset fileType = "">
<cfset imagePath = "">
<cfset get_emp_list = ''>
<cfset get_emp_list_2 = ''>

<cffunction name="infoFileType">
	<cfargument name="file_path" type="string" required="true">
	<cfargument name="ext" type="string" required="true">
		
	<cfif FileExists(file_path)>
		
		<cfset fileSysType = fileSystem.fileType(ext)>
		<cfset fileType = fileSysType["fileType"]>
		<cfif fileSysType["fileType"] eq "document" or fileSysType["fileType"] eq "other"> 

			<cfset imagePath = "/images/intranet/#ext#.png">
			<cfset icon = true>

		<cfelseif fileSysType["fileType"] eq "video">
					
			<cfset imagePath = url_ & asset_file_name>
			<cfset icon = false>

		<cfelseif fileSysType["fileType"] eq "audio">

			<cfset imagePath = url_ & asset_file_name>
			<cfset icon = false>

		<cfelseif fileSysType["fileType"] eq "image">
				
			<cfif FileExists("#uploadFolder#thumbnails/middle/#asset_file_name#")>

				<cfset imagePath = "documents/thumbnails/middle/#asset_file_name#">
				<cfset icon = false>

			<cfelse>
				
				<cfset fileSystem.newFolder("#uploadFolder#","thumbnails") /> <!---upload folder --- /documents klasörü ---->
				<cfset fileSystem.newFolder("#uploadFolder#thumbnails","icon") />
				<cfset fileSystem.newFolder("#uploadFolder#thumbnails","middle") />

				<cfset imageOperations = CreateObject("Component","cfc.image_operations") />

				<cfloop from="1" to="#imageSettings.count()#" index="row">
					
					<cfset imageOperations.imageCrop(
										imagePath : "#file_path#",
										imageThumbPath : "#uploadFolder#thumbnails/" & imageSettings[row]["folderName"] &"/#asset_file_name#",
										imageCropType	:	1, <!--- Orantılı boyutlandır --->
										newWidth : #imageSettings[row]["newWidth"]#,
										newHeight : #imageSettings[row]["newHeight"]#
										) />

				</cfloop>
				
				<cfset imagePath = "documents/thumbnails/middle/#asset_file_name#" />
				<cfset icon = false>

			</cfif>

		<cfelse>

			<cfset imagePath = "images/intranet/no-preview.png">
			<cfset icon = true>

		</cfif>
	<cfelseif isdefined("get_assets.EMBEDCODE_URL") and len(get_assets.EMBEDCODE_URL)>
			<cfset imagePath = '#get_assets.EMBEDCODE_URL#'>
			<cfset icon = false>
	
	<cfelse>

		<cfset imagePath = "images/intranet/no-image.png">
		<cfset icon = true>

	</cfif>	

</cffunction>
<cf_big_list>
	<thead>
		<tr>
			<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
			<!-- sil --><th class="header_icn_none"></th><!-- sil -->
			<th><cf_get_lang dictionary_id='57880.Belge No'></th>
			<th><cf_get_lang dictionary_id='29452.Varlık'></th>
				<cfif isDefined("project_multi_id") and len(project_multi_id) or isdefined("project_id") and len(project_id)>
				<cfset colspan = colspan+2>
			<th><cf_get_lang dictionary_id='30886.Proje'></th>
			<th><cf_get_lang dictionary_id='47674.Proje Adı'></th>
				</cfif>   
				<cfif isdefined("product_code") and len(product_code)>
				<cfset ++colspan>
			<th><cf_get_lang dictionary_id='57518.Stok kodu'></th>
			<th><cf_get_lang dictionary_id='58221.Ürün adı'></th>
				</cfif>        
			<th><cf_get_lang dictionary_id='57486.Kategori'></th>
			<th><cf_get_lang dictionary_id='58067.Döküman Tipi'></th>
				<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
				<cfset ++colspan>
			<th><cf_get_lang dictionary_id='57482.Aşama'></th>
				</cfif>
			<th><cf_get_lang dictionary_id='58594.Format'></th>
			<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
			<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
			<th><i class="fa fa-edit"></i></th>
			
		</tr>
	</thead>
	<tbody>
		<cfif isDefined("attributes.is_form_submitted") and get_assets.recordcount>
			<cfset get_emp_list = ''>
			<cfset get_cons_list = ''>
			<cfset get_par_list = ''>
			<cfset get_emp_list_2 = ''>
			<cfset get_cons_list_2 = ''>
			<cfset get_par_list_2 = ''>
			<cfset property_list = ''>
			<cfset page_id_list = ''>
			<cfset project_list = ''>
			<cfoutput query="get_assets" maxrows=#attributes.maxrows# startrow=#attributes.startrow#>
				<cfif len(record_emp) and not listfind(get_emp_list,record_emp)>
					<cfset get_emp_list=listappend(get_emp_list,record_emp)>
				</cfif>
				<cfif len(record_pub) and not listfind(get_cons_list,record_pub)>
					<cfset get_cons_list=listappend(get_cons_list,record_pub)>
				</cfif>
				<cfif len(record_par) and not listfind(get_cons_list,record_par)>
					<cfset get_par_list=listappend(get_par_list,record_par)>
				</cfif>
				<cfif len(property_id) and not listfind(property_list,property_id)>
					<cfset property_list=listappend(property_list,property_id)>
				</cfif>
				<cfif isdefined("project_id") and len(project_id) and not listfind(project_list,project_id)>
					<cfset project_list=listappend(project_list,project_id)>
				</cfif>
				<cfif isdefined("project_multi_id") and len(project_multi_id) and not listfind(project_list,project_id)>
					<cfset project_list=listappend(project_list,mid(project_multi_id,2,len(project_multi_id)-2))>
				</cfif>
			</cfoutput>			
			<cfif len(get_emp_list)>
				<cfquery name="GET_EMP" datasource="#DSN#">
					SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#get_emp_list#) ORDER BY EMPLOYEE_ID
				</cfquery>
				<cfset get_emp_list_2 = listsort(listdeleteduplicates(valuelist(get_emp.employee_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(get_cons_list)>
				<cfquery name="GET_CONS" datasource="#DSN#">
					SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#get_cons_list#) ORDER BY CONSUMER_ID
				</cfquery>
				<cfset get_cons_list_2 = listsort(listdeleteduplicates(valuelist(get_cons.consumer_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(get_par_list)>
				<cfquery name="GET_PAR" datasource="#DSN#">
					SELECT PARTNER_ID, COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#get_par_list#) ORDER BY PARTNER_ID
				</cfquery>
				<cfset get_par_list_2 = listsort(listdeleteduplicates(valuelist(get_par.partner_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(property_list)>
				<cfquery name="GET_CONTENT_PROPERTY" datasource="#DSN#">
					SELECT CONTENT_PROPERTY_ID,NAME FROM CONTENT_PROPERTY WHERE CONTENT_PROPERTY_ID IN (#property_list#) ORDER BY CONTENT_PROPERTY_ID
				</cfquery> 
				<cfset property_list = listsort(listdeleteduplicates(valuelist(get_content_property.content_property_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(project_list)>
				<cfquery name="GET_PROJECT_NAME" datasource="#DSN#">
					SELECT PROJECT_NUMBER,PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_list#) ORDER BY PROJECT_ID
				</cfquery> 
				<cfset project_list = listsort(listdeleteduplicates(valuelist(get_project_name.project_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfoutput query="get_assets" maxrows=#attributes.maxrows# startrow=#attributes.startrow#>
				<cfif assetcat_id gte 0>
					<cfset path_ = "asset/#assetcat_path#">
				<cfelse>
					<cfset path_ = "#assetcat_path#">
				</cfif>
				<cfif company_asset_relation eq 1>
					<cfif len(get_assets.related_asset_id)>
						<cfquery name="getAssetRelated" datasource="#DSN#">
							SELECT ACTION_ID,RECORD_DATE FROM ASSET WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assets.related_asset_id#">
						</cfquery>
						<cfif len(getAssetRelated.action_id)>
							<cfset url_ = "#file_web_path#/#path_#/#year(getAssetRelated.record_date)#/#getAssetRelated.action_id#/">
							<cfset path = "#upload_folder##path_##dir_seperator##year(getAssetRelated.record_date)##dir_seperator##getAssetRelated.action_id##dir_seperator#">
						<cfelse>
							<cfset url_ = "#file_web_path#/#path_#/#year(get_assets.record_date)#/">
							<cfset path = "#upload_folder##path_##dir_seperator##year(get_assets.record_date)##dir_seperator#">
						</cfif>
					<cfelseif len(get_assets.action_id)>
						<cfset url_ = "#file_web_path#/#path_#/#year(get_assets.record_date)#/#get_assets.action_id#/">
						<cfset path = "#upload_folder##path_##dir_seperator##year(get_assets.record_date)##dir_seperator##get_assets.action_id##dir_seperator#">
					<cfelse>
						<cfset url_ = "#file_web_path#/#path_#/#year(get_assets.record_date)#/">
						<cfset path = "#upload_folder##path_##dir_seperator##year(get_assets.record_date)##dir_seperator#">
					</cfif>
				<cfelse>
					<cfset url_ = "#file_web_path#/#path_#/">
					<cfset path = "#upload_folder##path_##dir_seperator#">
				</cfif>

				<cfset file_path = '#path##asset_file_name#'>
				<cfset rm = '#chr(13)#'>
				<cfset desc = ReplaceList(description,rm,'')>
				<cfset rm = '#chr(10)#'>
				<cfset desc = ReplaceList(desc,rm,'')>
				<cfif desc is ''><cfset desc = 'image'></cfif>	
				<cfset ext=lcase(listlast(asset_file_name, '.')) />
				<cfset infoFileType(file_path,ext)>
				<tr>
					<td>#currentrow#</td>   
					<td>
						<cfif not isDefined("attributes.asset_archive")>
							<cfif assetcat_id gte 0>
								<cfset file_add_ = "asset/">
							<cfelse>
								<cfset file_add_ = "">
							</cfif>
							<cfif asset_file_server_id eq fusebox.server_machine>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&<cfif ext eq "jpg" or ext eq "jpeg" or ext eq "png" or ext eq "bmp" or ext eq "pdf" or ext eq "txt" or ext eq "gif">direct_show=1&</cfif>file_name=#url_##asset_file_name#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#','medium');return false;"><i class="fa fa-download"  title="<cf_get_lang dictionary_id='47677.Aç-Kaydet'>"></i></a>
							<cfelse>
								<cf_get_server_file output_file="#url_##asset_file_name#" output_server="#asset_file_server_id#" output_type="2" small_image="/images/download.gif" image_link="1">
							</cfif>
						</cfif>
					</td>
					<cfif live eq 1>
						<td><font color="CC0000"><b>(G) #asset_no# <cfif revision_no neq 0>- #revision_no#</cfif></b></font></td>
					<cfelse>
						<td>#asset_no# <cfif revision_no neq 0>- #revision_no#</cfif></td>
					</cfif>
					<td title="Orjinal Dosya Adı : #asset_file_real_name#">
					<cfset ext=lcase(listlast(asset_file_name, '.')) />
					<cfif filetype eq "video">
						<cfif len(asset_file_path_name)>
							<cfset my_video_file_path = #asset_file_path_name#>
						<cfelse>
							<cfset my_video_file_path = '/documents/#file_add_##assetcat_path#/#asset_file_name#'>
						</cfif>
						<!---#my_video_file_path#--->
						<a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_flvplayer&video=#my_video_file_path#&ext=#ext#&content_id=#asset_id#','video');" class="tableyazi">#asset_name#</a>
					<cfelseif listfind(mediaplayer_extensions, "."&ext)>
						<a href="#url_##asset_file_name#" class="tableyazi">#asset_name#</a>
					<cfelse>
						<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&<cfif ext eq "jpg" or ext eq "jpeg" or ext eq "png" or ext eq "bmp" or ext eq "pdf" or ext eq "txt" or ext eq "gif">direct_show=1&</cfif>file_name=#url_##asset_file_name#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#','medium');" class="tableyazi">#asset_name#</a>
					</cfif>
					</td>
					<cfif isDefined("project_multi_id") and len(project_multi_id) or isdefined("project_id") and len(project_id)>
						<td>
							<cfif isDefined("project_multi_id") and len(project_multi_id)>
								<cfloop list="#mid(project_multi_id,2,len(project_multi_id)-2)#" index="k">
								<a href="javascript://" onclick="window.open('index.cfm?fuseaction=project.projects&event=det&id=#k#');" class="tableyazi">#get_project_name.project_number[listfind(project_list,k,',')]#</a><br />
								</cfloop>
							<cfelseif isdefined("project_id") and len(project_id)>
								<a href="javascript://" onclick="window.open('index.cfm?fuseaction=project.projects&event=det&id=#project_id#');" class="tableyazi">#get_project_name.project_number[listfind(project_list,project_id,',')]#</a>
							</cfif>
						</td>
						<td>
							<cfif isDefined("project_multi_id") and len(project_multi_id)>
								<cfloop list="#mid(project_multi_id,2,len(project_multi_id)-2)#" index="k">
								<a href="javascript://" onclick="window.open('index.cfm?fuseaction=project.projects&event=det&id=#k#');" class="tableyazi">#get_project_name.project_head[listfind(project_list,k,',')]#</a><br />
								</cfloop>
							<cfelseif  isdefined("project_id") and len(project_id)>
								<a href="javascript://" onclick="window.open('index.cfm?fuseaction=project.projects&event=det&id=#project_id#');" class="tableyazi">#get_project_name.project_head[listfind(project_list,project_id,',')]#</a>
							</cfif>
						</td>
					</cfif>
					<cfif isdefined("product_code") and len(product_code)>
						<td>#product_code#</td>
						<td>#product_name#</td>
					</cfif>
					<td>#assetcat#</td>
					<td>
						<cfif len(property_list)>#get_content_property.name[listfind(property_list,property_id,',')]#</cfif>
					</td>
					<cfif FindNoCase(".",asset_file_name)>
						<cfset last_3 = '.' & listLast(asset_file_name, '.') />
					<cfelse>
						<cfset last_3 = "">
					</cfif>
					<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
						<td>#stage#</td>
					</cfif>
					<td>#last_3# (#asset_file_size# kb.)</td>
					<td>			  
						<cfif len(record_emp)>
							<a href="javascript://" onclick="nModal({head: 'Profil',page:'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_emp.employee_id[listfind(get_emp_list_2,record_emp,',')]#'});" class="tableyazi">#get_emp.employee_name[listfind(get_emp_list_2,record_emp,',')]# #get_emp.employee_surname[listfind(get_emp_list_2,record_emp,',')]#</a>
						<cfelseif len(record_pub)>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_cons.consumer_id[listfind(get_cons_list_2,record_pub,',')]#','medium')" class="tableyazi">#get_cons.consumer_name[listfind(get_cons_list_2,record_pub,',')]# #get_cons.consumer_surname[listfind(get_cons_list_2,record_pub,',')]#</a>
						<cfelseif len(record_par)>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_par.partner_id[listfind(get_par_list_2,record_par,',')]#','medium')" class="tableyazi">#get_par.company_partner_name[listfind(get_par_list_2,record_par,',')]# #get_par.company_partner_surname[listfind(get_par_list_2,record_par,',')]#</a>
						</cfif>
					</td>
					<td>&nbsp;#dateformat(record_date,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</td>
					<cfif (not listfindnocase(denied_pages,'asset.form_upd_asset') or session.ep.userid eq update_emp) and (attributes.fuseaction does not contain 'popup')>				    		    
						<!-- sil -->
						<td class="header_icn_none">
							<a href="#request.self#?fuseaction=asset.list_asset&event=upd&asset_id=#asset_id#&assetcat_id=#assetcat_id#" title="<cf_get_lang dictionary_id='57464.Güncelle'>"><i class="fa fa-edit"></i></a>
						</td>
						<!-- sil -->
					<cfelseif attributes.fuseaction does not contain 'popup'>
						#attributes.fuseaction#<td align="center" width="20">&nbsp;</td>
					</cfif>
				</tr>
			</cfoutput> 
		<cfelse>
			<tr> 
				<td colspan="<cfoutput>#colspan#</cfoutput>"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif> </td>
			</tr>
		</cfif>
	</tbody>  
</cf_big_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
	<cfif isdefined("attributes.is_form_submitted")>
		<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
	</cfif>
	<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif len(attributes.asset_cat)>
		<cfset url_str = "#url_str#&asset_cat=#attributes.asset_cat#">
	</cfif>
	<cfif len(attributes.process_stage)>
		<cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
	</cfif>
	<cfif len(attributes.format)>
		<cfset url_str = "#url_str#&format=#attributes.format#">
	</cfif>
	<cfif len(attributes.project_head)>
		<cfset url_str = "#url_str#&project_head=#attributes.project_head#">
	</cfif>
	<cfif len(attributes.is_view)>
		<cfset url_str = "#url_str#&is_view=#attributes.is_view#">
	</cfif>
	<cfif len(attributes.product_id)>
		<cfset url_str = "#url_str#&product_id=#attributes.product_id#">
	</cfif>
	<cfif len(attributes.our_company_id)>
		<cfset url_str = "#url_str#&our_company_id=#attributes.our_company_id#">
	</cfif>
	<cfif len(attributes.record_date1)>
		<cfset url_str = "#url_str#&record_date1=#attributes.record_date1#">
	</cfif>
	<cfif len(attributes.record_date2)>
		<cfset url_str = "#url_str#&record_date2=#attributes.record_date2#">
	</cfif>
	<cfif isDefined("attributes.is_active") and len(attributes.is_active)>
		<cfset url_str = "#url_str#&is_active=#attributes.is_active#">
	</cfif>
	<cfif isDefined("attributes.is_special") and len(attributes.is_special)>
		<cfset url_str = "#url_str#&is_special=#attributes.is_special#">
	</cfif>
	<cfif isDefined("attributes.featured") and len(attributes.featured)>
		<cfset url_str = "#url_str#&featured=#attributes.featured#">
	</cfif>
	<cfif len(attributes.employee_view)>
		<cfset url_str = "#url_str#&employee_view=#attributes.employee_view#">
	</cfif>
	<cfif len(attributes.is_internet)>
		<cfset url_str = "#url_str#&is_internet=#attributes.is_internet#">
	</cfif>
	<cfif len(attributes.is_extranet)>
		<cfset url_str = "#url_str#&is_extranet=#attributes.is_extranet#">
	</cfif>
	<cf_paging 
		page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="myhome.digital_assets#url_str#">
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>