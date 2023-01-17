<cfset uploadFolder = application.systemParam.systemParam().upload_folder />
<cfset fileSystem = CreateObject("component","V16.asset.cfc.file_system")>
<cfset DSN3 = #DSN# & '_' & session.ep.company_id>
<cfinclude template="../query/get_asset.cfm">
 
<cfif get_asset.is_special eq 1>
	<cfif isdefined("session.ep.userid")>
		<cfif not (get_asset.RECORD_EMP eq session.ep.userid or get_asset.UPDATE_EMP eq session.ep.userid)>
			<script type="text/javascript">
				alert('<cf_get_lang dictionary_id = "48537">');
				<cfif fuseaction contains 'popup'>
					window.close();
				</cfif>
				history.back();
			</script>
			<cfabort>
		</cfif>
	<cfelseif isdefined("session.pp.userid")>
		<cfif not (get_asset.RECORD_EMP eq session.pp.userid or get_asset.UPDATE_EMP eq session.pp.userid)>
			<script type="text/javascript">
				alert('<cf_get_lang dictionary_id = "48537">');
				<cfif fuseaction contains 'popup'>
					window.close();
				</cfif>
				history.back();
			</script>
			<cfabort>
		</cfif>
	</cfif>
</cfif>

<cfquery name="GET_ASSET_RELATEDS" datasource="#DSN#">
	SELECT 
	    ASSET_ID,
        USER_GROUP_ID,
        DIGITAL_ASSET_GROUP_ID,
        COMPANY_CAT_ID,
        CONSUMER_CAT_ID,
        POSITION_CAT_ID,
        ALL_EMPLOYEE,
        ALL_CAREER,
        ALL_INTERNET,
        ALL_PEOPLE
	FROM 
		ASSET_RELATED 
    WHERE 
    	ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
</cfquery>
<cfset foldername = createUUID()>
<cfif fusebox.use_period>
    <cfquery name="DPL_DETAIL" datasource="#DSN3#">
        SELECT COUNT(DRAWING_PART_ROW.DPL_ID) COUNT_ FROM DRAWING_PART,DRAWING_PART_ROW WHERE DRAWING_PART.DPL_ID = DRAWING_PART_ROW.DPL_ID AND DPL_NO = '#get_asset.asset_no# - #get_asset.revision_no#'
    </cfquery>
<cfelse>
	<cfset DPL_DETAIL.COUNT_ = 0>
</cfif>
<cfif get_asset_relateds.recordcount>
	<cfquery name="GET_EMP_ALL" dbtype="query">
		SELECT ASSET_ID FROM GET_ASSET_RELATEDS WHERE ALL_EMPLOYEE = 1 OR ALL_PEOPLE = 1
	</cfquery>
	<cfif not get_emp_all.recordcount>
		<cfquery name="GET_USER_CAT" datasource="#DSN#">
			SELECT USER_GROUP_ID,POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
		</cfquery>
        <cfquery name="GET_DIGITAL_GROUPS" datasource="#DSN#">     	
            SELECT 
                DAG.GROUP_ID 
            FROM 
                DIGITAL_ASSET_GROUP DAG,
                DIGITAL_ASSET_GROUP_PERM DAGP
            WHERE 
                DAGP.GROUP_ID = DAG.GROUP_ID AND
                DAGP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
        </cfquery>
        <cfquery name="control_user_cat" dbtype="query">
			SELECT ASSET_ID FROM get_asset_relateds WHERE <cfif get_digital_groups.recordcount>DIGITAL_ASSET_GROUP_ID IN (#ValueList(get_digital_groups.group_id)#) OR</cfif> <cfif len(get_user_cat.USER_GROUP_ID)>USER_GROUP_ID = #get_user_cat.USER_GROUP_ID# OR</cfif> POSITION_CAT_ID = #get_user_cat.POSITION_CAT_ID#
		</cfquery>
        <cfif isdefined("session.ep.userid")>
        	<cfset check_emp = "EMPLOYEE#session.ep.userid#">
        <cfelseif isdefined("session.pp.userid")>
        	<cfset check_emp = "PARTNER#session.pp.userid#">
        </cfif>
		<cfif not control_user_cat.recordcount and session.ep.userid neq get_asset.record_emp>
			<script type="text/javascript">
				alert('<cf_get_lang dictionary_id = "48537">');
				<cfif fuseaction contains 'popup'>
					window.close();
				</cfif>
				history.back();
			</script>
			<cfabort>
		</cfif>
	</cfif>
</cfif>
<cfinclude template="../query/get_asset_cats.cfm">
<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_customer_cat.cfm">

<!--- tv yayın kategorisi --->
<cfquery name="GET_COMPANY_SITE" datasource="#DSN#">
	SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN IS NOT NULL
</cfquery>

<cfquery name="GET_SITE_DOMAIN" datasource="#DSN#">
	SELECT ASSET_ID,SITE_DOMAIN FROM ASSET_SITE_DOMAIN WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
</cfquery>

<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>

<cfquery name="GET_USER_GROUPS" datasource="#DSN#">
	SELECT USER_GROUP_ID,USER_GROUP_NAME FROM USER_GROUP ORDER BY USER_GROUP_NAME
</cfquery>

<cfquery name="GET_DIGITAL_ASSET" datasource="#DSN#">
	SELECT GROUP_NAME,GROUP_ID FROM DIGITAL_ASSET_GROUP ORDER BY GROUP_NAME
</cfquery>

<cfquery name="GET_INTERNET" dbtype="query">
	SELECT ALL_INTERNET FROM GET_ASSET_RELATEDS WHERE ALL_INTERNET = 1
</cfquery>

<cfquery name="GET_CAREER" dbtype="query">
	SELECT ALL_CAREER FROM GET_ASSET_RELATEDS WHERE ALL_CAREER = 1
</cfquery>

<cfquery name="GET_ALL_PEOPLE" dbtype="query">
	SELECT ALL_PEOPLE FROM GET_ASSET_RELATEDS WHERE ALL_PEOPLE = 1
</cfquery>

<cfquery name="GET_ALL_EMPLOYEE" dbtype="query">
	SELECT ALL_EMPLOYEE FROM GET_ASSET_RELATEDS WHERE ALL_EMPLOYEE = 1
</cfquery>

<cfquery name="GET_COMPANY_CATS" dbtype="query">
	SELECT COMPANY_CAT_ID FROM GET_ASSET_RELATEDS WHERE COMPANY_CAT_ID IS NOT NULL
</cfquery>
<cfif get_company_cats.recordcount>
	<cfset company_cat_id_list = valuelist(get_company_cats.company_cat_id)>
</cfif>

<cfquery name="GET_CONSCAT" dbtype="query">
	SELECT CONSUMER_CAT_ID FROM GET_ASSET_RELATEDS WHERE CONSUMER_CAT_ID IS NOT NULL
</cfquery>
<cfif get_conscat.recordcount>
	<cfset conscat_id_list = valuelist(get_conscat.consumer_cat_id)>
</cfif>

<cfquery name="GET_POSITION_CAT" dbtype="query">
	SELECT POSITION_CAT_ID FROM GET_ASSET_RELATEDS WHERE POSITION_CAT_ID IS NOT NULL
</cfquery>
<cfif get_position_cat.recordcount>
	<cfset get_position_cat_list=valuelist(get_position_cat.position_cat_id)>
</cfif>

<cfquery name="GET_USER_GROUP" dbtype="query">
	SELECT USER_GROUP_ID FROM GET_ASSET_RELATEDS WHERE USER_GROUP_ID IS NOT NULL
</cfquery>
<cfif get_user_group.recordcount>
	<cfset get_user_group_list=valuelist(get_user_group.user_group_id)>
</cfif>

<cfquery name="GET_DIGITAL_ASSETS" dbtype="query">
	SELECT DIGITAL_ASSET_GROUP_ID FROM GET_ASSET_RELATEDS WHERE DIGITAL_ASSET_GROUP_ID IS NOT NULL
</cfquery>
<cfif GET_DIGITAL_ASSETS.recordcount>
	<cfset get_digital_asset_group_list=valuelist(GET_DIGITAL_ASSETS.DIGITAL_ASSET_GROUP_ID)>
</cfif>

<cfif len(get_asset.project_multi_id)>
	<cfset project_multi_id_ = mid(get_asset.project_multi_id,2,len(get_asset.project_multi_id)-2)>
</cfif>
<cfif isdefined("project_multi_id_") and len(project_multi_id_)>
	<cfquery name="GET_PROJECT" datasource="#DSN#">
		SELECT PROJECT_HEAD,PROJECT_ID,PROJECT_NUMBER FROM PRO_PROJECTS WHERE PROJECT_ID 
		<cfif len(get_asset.project_multi_id)>
			IN (#project_multi_id_#)
		<cfelse>
			=#project_multi_id_#
		</cfif>
	</cfquery>
<cfelse>    
	<cfset get_project.recordcount = 0>
</cfif>

<cfif find(get_asset.asset_file_name, ".flv")>
	<cfset attributes.stream_name = Replace(get_asset.asset_file_name, ".flv", "") />
	<cfset attributes.is_stream = 1 />
<cfelse>
	<cfset attributes.stream_name = createUUID() />
	<cfset attributes.is_stream = 0 />
</cfif>
<cfset session.resim = 4>
<cfset session.module = "asset">
<style>
	.pageMainLayout{padding:0;}
</style>
<link rel="stylesheet" href="/css/assets/template/w3-intranet/intranet.css" type="text/css">
<script type="text/javascript" src="/JS/intranet.js"></script>
<cfinclude template="../../rules/display/rule_menu.cfm">

	<div id="archive" class="wrapper">
		<div class="blog_title">
			<cfoutput>#get_asset.asset_name#</cfoutput>
			<ul>
				<li><a id="folder_layout" href="<cfoutput>#request.self#?fuseaction=asset.list_asset&folderControl=1</cfoutput>"><i class="wrk-uF0144"></i> folder</a></li>
				<li><a href="<cfoutput>#request.self#?fuseaction=asset.list_asset&event=add</cfoutput>"><i class="wrk-uF0166"></i> <cf_get_lang dictionary_id='48868.Upload'></a></li>
				<li><a id="table_layout" href="<cfoutput>#request.self#?fuseaction=asset.list_asset&listTypeElement=list</cfoutput>"><i class="wrk-uF0083"></i> liste</a></li>
				<li><a id="table_layout" href="<cfoutput>#request.self#?fuseaction=asset.list_asset</cfoutput>"><i class="wrk-uF0081"></i> card</a></li>
			</ul>
		</div>

		<cfform name="upd_asset" method="post" action="#request.self#?fuseaction=asset.upd_asset" enctype="multipart/form-data">
			<input type="hidden" name="asset_id"  id="asset_id" value="<cfoutput>#attributes.asset_id#</cfoutput>">
			<input type="hidden" name="old_asset_catid" id="old_asset_catid" value="<cfoutput>#get_asset.assetcat_id#</cfoutput>">
			<input type="hidden" name="related_company_id" id="related_company_id" value="<cfoutput>#get_asset.related_company_id#</cfoutput>">
			<input type="hidden" name="related_consumer_id" id="related_consumer_id" value="<cfoutput>#get_asset.related_consumer_id#</cfoutput>">
			<input type="hidden" name="asset_old_file" id="asset_old_file" value="<cfoutput>#get_asset.asset_file_name#</cfoutput>">
			<input type="hidden" name="asset_file_server_id" id="asset_file_server_id" value="<cfoutput>#get_asset.asset_file_server_id#</cfoutput>">
			<input type="hidden" name="stream_name" id="stream_name" value="">
			<input type="hidden" name="action_section" id="action_section" value="<cfif isdefined('attributes.action') and len(attributes.action)><cfoutput>#attributes.action#</cfoutput></cfif>">
			<input type="hidden" name="action_id" id="action_id" value="<cfif isdefined('attributes.action_id') and len(attributes.action_id)><cfoutput>#attributes.action_id#</cfoutput></cfif>">
			<input type="hidden" name="change_revision" id="change_revision" value="0">                    

		
			<div class="archive_form">
				<div class="archive_form_step">
					<!--- <div class="sub_title">
						<cf_get_lang dictionary_id = "48364.Dosya yükle">
					</div> --->
					<div class="ui-form-list ui-form-block" style="justify-content:center;">
						<cfset path=''>
						<cfquery name="GET_PATH" datasource="#DSN#">
							SELECT ASSETCAT_PATH,ASSETCAT_ID,ASSETCAT FROM ASSET_CAT WHERE ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_asset.assetcat_id#">
						</cfquery>									
						<cfset path = "#get_path.assetcat_path#">
						<cfif not len(get_asset.asset_file_path_name)>
							<cfif company_asset_relation eq 1>
								<cfif len(get_asset.related_asset_id)>
									<cfquery name="getAssetRelated" datasource="#dsn#">
										SELECT ACTION_ID,RECORD_DATE FROM ASSET WHERE ASSET_ID = #get_asset.related_asset_id#
									</cfquery>
								<cfif len(getAssetRelated.action_id)>
									<cfset folder="#path#/#year(getAssetRelated.record_date)#/#getAssetRelated.action_id#">
								<cfelse>
									<cfset folder="#path#/#year(get_asset.record_date)#">
								</cfif>
								<cfelseif len(get_asset.action_id)>
									<cfset folder="#path#/#year(get_asset.record_date)#/#get_asset.action_id#">
								<cfelse>
									<cfset folder="#path#/#year(get_asset.record_date)#">
								</cfif>
							<cfelse>
								<cfif get_asset.assetcat_id gte 0>
									<cfset folder="asset/#path#">
								<cfelse>
									<cfset folder="#path#">
								</cfif>
							</cfif>

							<cfset file_path = "#uploadFolder#" & folder & "/" & get_asset.asset_file_name />
							<cfset ext = lcase(listlast(get_asset.asset_file_name, '.')) />
							<cfset fileType = "">
							<cfset downloadType = 7>
							<cfoutput>
								<cfif FileExists(file_path)>

									<cfset fileSysType = fileSystem.fileType(ext)>
									<cfset fileType = fileSysType["fileType"]>
									<cfif fileSysType["fileType"] eq "document" or fileSysType["fileType"] eq "other">	
										<cfset imagePath = "/images/intranet/#ext#.png">
										<cfset filePrevWidth = 100 />
										<cfif ext eq "pdf">
											<cfset downloadType = 7>
										<cfelse>
											<cfset downloadType = 6>	
										</cfif>
									<cfelseif fileSysType["fileType"] eq "video">
										<cfset imagePath = "documents/" & folder & "/" & get_asset.asset_file_name>
										<cfset filePrevWidth = 300 />
										<cfset downloadType = 6>					
									<cfelseif fileSysType["fileType"] eq "audio">
										<cfset imagePath = "documents/" & folder & "/" & get_asset.asset_file_name>
										<cfset fileType = "audio">
										<cfset filePrevWidth = 250 />
										<cfset downloadType = 6>
									<cfelseif fileSysType["fileType"] eq "image">
										<cfset imagePath = "documents/thumbnails/middle/#get_asset.asset_file_name#">
										<cfset filePrevWidth = 200 />
										<cfset downloadType = 7>
									<cfelse>
										<cfset imagePath = "images/intranet/no-preview.png">
										<cfset downloadType = 6>
									</cfif>
									<cfif fileType eq "video">
										<cfif (ext eq "mp4")>
											<cfset type = "video/mp4">
										<cfelseif (ext eq "mpeg")>
											<cfset type = "video/mpeg">
										</cfif>
										<div class="media">
											<video width="#filePrevWidth#" controls>
												<source src="#imagePath###t=0.1" type="#type#">
												<p>Your browser doesn't support HTML5 video.</p>
											</video>
										</div>		
									<cfelseif fileType eq "audio">
										<cfif (ext eq "ogg")>
											<cfset type = "audio/ogg">
										<cfelseif (ext eq "mp3")>
											<cfset type = "audio/mpeg">
										<cfelseif (ext eq "wav")>
											<cfset type = "audio/wav">
										</cfif>
										<audio style="width:#filePrevWidth#px;" controls controlsList="nodownload">
											<source src="#imagePath#" type="#type#">
											Your browser does not support the HTML5 audio element.
										</audio>
									<cfelseif fileType eq "document" or fileType eq "other" or fileType eq "image">
										<div class="media">
											<img src="#imagePath#" width="#filePrevWidth#">
										</div>	
									<cfelse>
										<cfset imagePath = "images/intranet/no-preview.png">
										<div class="media">
											<img src="#imagePath#" width="100">
										</div>
									</cfif>
									<div class="content">
										<b><label>
											<cfif downloadType eq 7>
												<cfoutput>#getLang('asset',68)#</cfoutput>:
											<cfelse>
												<cfoutput>#getLang('settings',1692)#</cfoutput>:
											</cfif>
										</b>
										<cf_get_server_file output_file="#folder#/#get_asset.asset_file_name#" output_server="#get_asset.asset_file_server_id#" output_type="#downloadType#" image_link="1">
									</div>
								<cfelseif isdefined("get_asset.EMBEDCODE_URL") AND len(get_asset.EMBEDCODE_URL)>
									<cfif get_asset.EMBEDCODE_URL contains 'docs.google.com/spreadsheets'>
										<img src="css/assets/icons/catalyst-icon-svg/XLS.svg" width="10%">
									<cfelseif get_asset.EMBEDCODE_URL contains 'docs.google.com/document'>
										<img src="css/assets/icons/catalyst-icon-svg/DOC.svg" width="10%">
									<cfelseif get_asset.EMBEDCODE_URL contains 'docs.google.com/forms'>
										<img src="css/assets/icons/catalyst-icon-svg/RTF.svg" width="10%">
									<cfelseif get_asset.EMBEDCODE_URL contains 'docs.google.com/presentation'>
										<img src="css/assets/icons/catalyst-icon-svg/PPT.svg" width="10%">
									<cfelseif get_asset.EMBEDCODE_URL contains 'iframe'>
										#get_asset.EMBEDCODE_URL#
									<cfelseif get_asset.EMBEDCODE_URL contains 'www.youtube.com' or get_asset.EMBEDCODE_URL contains 'youtu.be'>
										<cfif get_asset.EMBEDCODE_URL contains 'youtu.be'>
											<cfset str = listlast(get_asset.EMBEDCODE_URL, '/')>
										<cfelse>
											<cfset str = listfirst(listrest(get_asset.EMBEDCODE_URL, '='),'&')>
										</cfif>
										<div class="col col-5 col-md-5 col-sm-6 col-xs-12">
											<iframe width="100%" height="100%" src="https://www.youtube.com/embed/#str#"  allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowFullScreen ></iframe>
											
										</div>
									<cfelse>
										<img src="css/assets/icons/catalyst-icon-svg/UNKOWN.svg" width="10%">
									</cfif>
								<cfelse>
									<cfset imagePath = "images/intranet/no-image.png">
									<div class="media">
										<img src="#imagePath#">
									</div>
									<div class="content">
										<b>#file_path#</b>
									</div>
								</cfif>	
								<cfif FileExists(file_path) >
									<div class="dropzone" <cfif fileType eq "image" and isdefined("imagePath") and len(imagePath)>style="background-image:url('#imagePath#')"</cfif>>
										<div class="dz-default dz-message">
											<input class="input-file" id="asset" name="asset" type="file">
											<i><cf_get_lang dictionary_id = "48605"></i>
											<a href="javascript://"><span class="catalyst-doc"></span> #ext# #get_asset.asset_file_size# KB</a>
											<cf_get_server_file output_file="#folder#/#get_asset.asset_file_name#" output_server="#get_asset.asset_file_server_id#" output_type="#downloadType#" image_link="1" dam="1">
										</div>
									</div>	
								<cfelse>
									<div class="form-group">
										<div class="dropzone" style="background:none;height:10px;justify-content:center">
											<div class="clever">
												<input class="input-file" id="asset" name="asset" type="file">
												<div class="process" style="background-color:##fff4de;color:##ffa800;">
													<i class="catalyst-cloud-upload margin-right-10"></i><cf_get_lang dictionary_id='37135.Add Image'>
												</div>
											</div>
										</div>	
									</div>			
								</cfif>		
							
								<div class="form-group">
									<label>Url</label>
									<cfif len(get_asset.EMBEDCODE_URL)><span style="display:none!important">#get_asset.EMBEDCODE_URL#</span></cfif>									
									<div <cfif len(get_asset.EMBEDCODE_URL)>class="input-group"</cfif>id="item-embcode">
										<input type="hidden" name="srcembcode" id="srcembcode" value="">
										<input type="text" name="embcode" id="embcode" value="">
									</div>
								</div>
									
								<p class="file-return"></p>
							</cfoutput>
						<cfelse>
							<cfset folder="">
						</cfif>
						<cfif use_https eq 1>
							<cfset http_kontrol = 'https://'>
						<cfelse>
							<cfset http_kontrol = 'http://'>
						</cfif>								
					</div>
				</div>
			</div>		
			<div class="archive_form">
				<div class="archive_form_step">
					<div class="sub_title">
						Genel Bilgiler
					</div>
					<div class="ui-row">
						<div class="ui-form-list ui-form-block" type="row">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12" index="1" type="column" sort="true">
								<div class="form-group" id="item-asset_name_">
									<label><cfoutput>#getLang('settings',283)#</cfoutput>*</label>
									<cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik veri'>:<cf_get_lang no='35.Varlık Adı !'></cfsavecontent>
									<cfinput type="text" name="asset_name" id="asset_name" value="#get_asset.asset_name#" required="Yes" message="#message#">
								</div>
								<div class="form-group" id="item-asset_stage_">
									<label><cf_get_lang_main no='1447.Süreç'></label>
									<cf_workcube_process is_upd='0' select_value='#get_asset.asset_stage#' process_cat_width='250' is_detail='1'>
								</div>
								<div class="form-group" id="item-product_name_">
									<label><cf_get_lang_main no='245.Ürün'></label>
									<div class="input-group">
										<input type="hidden" name="product_id" id="product_id" <cfif len(get_asset.product_id)>value="<cfoutput>#get_asset.product_id#</cfoutput>"</cfif>>
										<input type="text" name="product_name"  id="product_name" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','100');" value="<cfif len(get_asset.product_id)><cfoutput>#get_asset.product_name#</cfoutput></cfif>" autocomplete="off">
										<span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=upd_asset.product_id&field_name=upd_asset.product_name&keyword='+encodeURIComponent(document.upd_asset.product_name.value),'list');"></span>
									</div>
								</div>
								<cfoutput>
									<div class="form-group" id="item-validate_start_date_">
										<label><cf_get_lang no='31.Geçerlilik Başlangıç Tarihi'></label>
										<div class="input-group">
											<cfinput type="text" name="validate_start_date" id="validate_start_date" value="#DateFormat(get_asset.validate_start_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon btn_Pointer"><cf_wrk_date_image date_field="validate_start_date"></span>
										</div>
									</div>
								</cfoutput>
								<div class="form-group" id="item-asset_description_">
									<label><cf_get_lang_main no='217.Aciklama'></label>
									<cfsavecontent variable="textmessage"><cf_get_lang_main no='1687.Fazla karakter sayısı'></cfsavecontent>
									<textarea name="asset_description" id="asset_description" message="<cfoutput>#textmessage#</cfoutput>" rows="5" maxlength="1000" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"><cfoutput>#get_asset.asset_description#</cfoutput></textarea>	
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12" index="2" type="column" sort="true">
								<div class="form-group" id="item-asset_no_">
									<label><cf_get_lang_main no ='468.Belge No'>*</label>
									<input type="text" name="asset_no" id="asset_no" value="<cfoutput>#get_asset.asset_no#</cfoutput>" <cfif session.ep.our_company_info.workcube_sector eq 'tersane'>readonly</cfif>>
								</div>
								<div class="form-group" id="item-assetcat_id_">
									<label><cf_get_lang_main no='74.Kategori'>*</label>
									<div class="input-group">
										<input type="hidden" name="assetcat_id" id="assetcat_id" <cfif isdefined('attributes.assetcat_id') and len(attributes.assetcat_id)> value="<cfoutput>#attributes.assetcat_id#</cfoutput>"</cfif>>
										<input type="text" name="assetcat_name" id="assetcat_name" style="width:125px;" value="<cfoutput>#get_path.assetcat_path#</cfoutput>" onfocus="AutoComplete_Create('assetcat_name','ASSETCAT','ASSETCAT_PATH','get_asset_cat','0','ASSETCAT_ID','assetcat_id','','3','130');" autocomplete="off">
										<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_asset_cat&chooseCat=1&form_name=upd_asset&field_id=assetcat_id&field_name=assetcat_name','list');"></span>			
									</div>
								</div>
								<div class="form-group" id="item-mail_receiver_">
									<label><cfoutput>#getLang('main',512)#</cfoutput></label>
									<div class="input-group">
										<cfif get_asset.mail_receiver_is_emp eq 1 and isDefined('get_asset.mail_receiver_id')>
											<cfset temp_mail_receiver_emp_id = get_asset.mail_receiver_id>
											<cfset temp_mail_receiver_partner_id = "">
											<cfquery name="GET_MAIL_RECEIVER" datasource="#DSN#">
												SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#temp_mail_receiver_emp_id#">
											</cfquery>
											<cfset temp_mail_receiver = "#get_mail_receiver.employee_name# #get_mail_receiver.employee_surname#">
										<cfelseif get_asset.mail_receiver_is_emp eq 0 and isdefined('get_asset.mail_receiver_id')>
											<cfset temp_mail_receiver_emp_id = "">
											<cfset temp_mail_receiver_partner_id = get_asset.mail_receiver_id>
											<cfquery name="GET_MAIL_RECEIVER" datasource="#DSN#">
												SELECT COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#temp_mail_receiver_partner_id#">
											</cfquery>
											<cfset temp_mail_receiver = "#get_mail_receiver.company_partner_name# #get_mail_receiver.company_partner_surname#">
										<cfelse>
											<cfset temp_mail_receiver_emp_id = "">
											<cfset temp_mail_receiver_partner_id = "">
											<cfset temp_mail_receiver = "">
										</cfif>
										<input type="hidden" name="mail_receiver_partner_id" id="mail_receiver_partner_id" value="<cfoutput>#temp_mail_receiver_partner_id#</cfoutput>">
										<input type="hidden" name="mail_receiver_emp_id" id="mail_receiver_emp_id" value="<cfoutput>#temp_mail_receiver_emp_id#</cfoutput>">
										<input type="hidden" name="old_mail_receiver" id="old_mail_receiver" value="<cfoutput>#temp_mail_receiver#</cfoutput>">
										<cfinput type="text" name="mail_receiver" id="mail_receiver" value="#temp_mail_receiver#" onFocus="AutoComplete_Create('mail_receiver','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','PARTNER_ID,EMPLOYEE_ID','mail_receiver_partner_id,mail_receiver_emp_id','','3','200');">
										<span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_partner=upd_asset.mail_receiver_partner_id&field_emp_id=upd_asset.mail_receiver_emp_id&field_name=upd_asset.mail_receiver&select_list=1,2,3</cfoutput>','list');"></span>
									</div>
								</div>
								<cfoutput>
									<div class="form-group" id="item-validate_finish_date_">
										<label><cf_get_lang no='42.Geçerlilik Bitiş Tarihi'></label>
										<div class="input-group">
											<cfinput type="text" name="validate_finish_date" id="validate_finish_date" value="#dateformat(get_asset.validate_finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon btn_Pointer"><cf_wrk_date_image date_field="validate_finish_date"></span>
										</div>
									</div>
								</cfoutput>
								<div class="form-group" id="item-asset_detail_">
									<label><cf_get_lang no='70.Anahtar Kelimeler'></label>
									<textarea name="asset_detail" id="asset_detail" message="<cfoutput>#textmessage#</cfoutput>" maxlength="100" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);" rows="5"><cfoutput>#get_asset.asset_detail#</cfoutput></textarea>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12" index="3" type="column" sort="true">
								<cfif not len(get_asset.EMBEDCODE_URL)>
									<div class="form-group" id="item-revision_">
										<label><cf_get_lang no="199.Revizyon"></label>
										<div class="input-group">
											<input type="text" name="revision_no" id="revision_no" value="<cfoutput>#get_asset.revision_no#</cfoutput>" readonly="readonly">
											<span class="input-group-addon btnPointer" name="revision_button" id="revision_button" onclick="revision_control();" title="<cf_get_lang no="199.Revizyon">"><i class="fa fa-plus"></i></span>
											<span class="input-group-addon btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=asset.popup_history_list&asset_id=<cfoutput>#attributes.asset_id#</cfoutput>','list');" title="<cf_get_lang_main no="61.Tarihçe">"><i class="fa fa-history"></i></span>
										</div>
									</div>
								</cfif>
								<div class="form-group" id="item-property_id_">
									<label><cf_get_lang_main no='655.Döküman Tipi'>*</label>
									<cf_wrk_selectlang
										name="property_id"
										width="250"
										table_name="CONTENT_PROPERTY"
										option_name="NAME"
										value="#get_asset.property_id#"
										option_value="CONTENT_PROPERTY_ID"
										required="true"
										onchange="sel_digital_asset_group();">
								</div>
								<div class="form-group" id="item-mail_cc_">
									<label><cf_get_lang no='189.CC'></label>
									<div class="input-group">
										<cfif get_asset.mail_cc_is_emp eq 1 and isdefined('get_asset.mail_cc_id')>
											<cfset temp_mail_cc_emp_id = get_asset.mail_cc_id>
											<cfset temp_mail_cc_partner_id = "">
											<cfquery name="GET_MAIL_CC" datasource="#DSN#">
												SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#temp_mail_cc_emp_id#">
											</cfquery>
											<cfset temp_mail_cc = "#get_mail_cc.employee_name# #get_mail_cc.employee_surname#">
										<cfelseif get_asset.mail_cc_is_emp eq 0 and isDefined('get_asset.mail_cc_id')>
											<cfset temp_mail_cc_emp_id = "">
											<cfset temp_mail_cc_partner_id = get_asset.MAIL_CC_ID>
											<cfquery name="GET_MAIL_CC" datasource="#DSN#">
												SELECT COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#temp_mail_cc_partner_id#">
											</cfquery>
											<cfset temp_mail_cc= "#get_mail_cc.company_partner_name# #get_mail_cc.company_partner_surname#">
										<cfelse>
											<cfset temp_mail_cc_emp_id = "">
											<cfset temp_mail_cc_partner_id = "">
											<cfset temp_mail_cc = "">
											</cfif>
										<input type="hidden" name="mail_cc_partner_id" id="mail_cc_partner_id" value="<cfoutput>#temp_mail_cc_partner_id#</cfoutput>">
										<input type="hidden" name="mail_cc_emp_id" id="mail_cc_emp_id" value="<cfoutput>#temp_mail_cc_emp_id#</cfoutput>">
										<input type="hidden" name="old_mail_cc" id="old_mail_cc" value="<cfoutput>#temp_mail_cc#</cfoutput>">
										<cfinput type="text" name="mail_cc" id="mail_cc" value="#temp_mail_cc#" onFocus="AutoComplete_Create('mail_cc','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','PARTNER_ID,EMPLOYEE_ID','mail_cc_partner_id,mail_cc_emp_id','','3','200');">
										<span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_partner=upd_asset.mail_cc_partner_id&field_emp_id=upd_asset.mail_cc_emp_id&field_name=upd_asset.mail_cc&select_list=1,2,3</cfoutput>','list');"></span>
									</div>
								</div>
								<div class="form-group" id="item-project_multi_id_">
									<label><cf_get_lang_main no='4.Proje'></label>
									<select name="project_multi_id" id="project_multi_id" multiple>
										<cfif len(get_asset.project_multi_id)>
											<cfoutput query="get_project">
												<option value="#get_project.project_id#">#get_project.project_number# - #get_project.project_head#</option>
											</cfoutput>
										</cfif>
									</select>
									<span class="btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_head=upd_asset.project_multi_id&project_id=upd_asset.project_multi_id&form_varmi=1&multi=1');"><i class="fa fa-plus" alt="<cf_get_lang_main no='4.Proje'>"></i></span>
									<cfif dpl_detail.count_ eq 0>
										<span class="btnPointer" onClick="project_remove();"><i class="fa fa-minus" id="img_delete_list" title="<cf_get_lang_main no ='51.Sil'>"></i></span>
									</cfif>
								</div>
							</div>	
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12" index="4" type="column" sort="true">
								<div class="form-group col col-2 col-xs-12" id="item-is_active_">									
									<label><input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_asset.is_active eq 1>checked="checked"</cfif>><cfoutput>#getLang('main',81)#</cfoutput></label>
								</div>
					
								<div class="form-group col col-2 col-xs-12" id="item-is_special_">									
									<label><input type="checkbox" name="is_special" id="is_special" value="1" <cfif (get_asset.is_special eq 1)>checked</cfif>><cfoutput>#getLang('asset',186)#</cfoutput></label>
								</div>
					
								<div class="form-group col col-2 col-xs-12" id="item-featured_">
									<label><input type="checkbox" name="featured" id="featured" value="1" <cfif (get_asset.featured eq 1)>checked</cfif>><cfoutput>#getLang('asset',197)#</cfoutput></label>
								</div>
								<cfif session.ep.our_company_info.workcube_sector eq 'tersane'>
									<div class="form-group col col-2 col-xs-12" id="item-is_dpl_">
										<label><input type="checkbox" name="is_dpl" id="is_dpl" value="1" onclick="check_yrm();" <cfif isdefined("attributes.is_dpl")>checked="checked"</cfif>><cf_get_lang no="10.DPL"></label>
									</div>
								</cfif>
		
								<div class="form-group col col-2 col-xs-12" id="item-employee_view1_">
									<label><input type="checkbox" name="employee_view" id="employee_view" value="1" <cfif (get_asset_relateds.recordcount and GET_EMP_ALL.recordcount)> checked="checked"</cfif>><cfoutput>#getLang('assetcare',287)#</cfoutput></label>	
								</div>
		
								<div class="form-group col col-2 col-xs-12" id="item-is_internet_">									
									<label><input type="checkbox" name="is_internet" id="is_internet" value="1" <cfif len(get_asset.IS_INTERNET) and get_asset.IS_INTERNET>checked</cfif> onclick="checkedElement('internet-panel','is_internet');">	<cfoutput>#getLang('asset',59)#</cfoutput></label>
								</div>
		
								<div class="form-group col col-2 col-xs-12" id="item-is_extranet_">
									<label><input type="checkbox" name="is_extranet" id="is_extranet" value="1" <cfif get_company_cats.recordcount>checked</cfif> onclick="checkedElement('item-comp_cat_all','is_extranet');"><cfoutput>#getLang('assetcare',295)#</cfoutput></label>
								</div>	
							</div>		
						</div>
					</div>
						
				</div>
			</div>

			<div class="archive_form">
				<div class="archive_form_step">
					<div class="sub_title" id="user_power">
						<span class="btnPointer"><cf_get_lang dictionary_id='61348.?'><i class='fa fa-angle-down bold'></i></span>
					</div>
					<div class="flex-row" style="display:none" type="row">
						<div class="archive_form_list" index="5" type="column" sort="true">
							<div class="form-group" id="item-doc-group">
								<label style="display:none;"><cfoutput>#getLang('assetcare',296)#</cfoutput></label>
								<div class="archive_form_list_title">
									<i class="fa fa-angle-down"></i>
									<cfoutput>#getLang('assetcare',296)#</cfoutput>
								</div>
	
								<div class="archive_form_list_item" id="item-portaller">
						
									<div id="partner">
										<div id="internet-panel">
											<div class="ui-form-list ui-form-block">
												<cfset my_asset_list = valuelist(get_site_domain.site_domain)>
												<cfoutput query="get_company_site">
													<div class="form-group">
														<input type="checkbox" name="menu_#menu_id#" id="menu_#menu_id#" value="#site_domain#" <cfif len(my_asset_list) and ListFindNoCase(my_asset_list,site_domain,',')>checked</cfif>>
														<label>#site_domain#</label>
													</div>
												</cfoutput>
												<div class="form-group">
													<input type="checkbox" name="career_view" id="career_view" <cfif get_career.recordcount>checked</cfif>>
													<label><cf_get_lang no='164.Kariyer Portal'></label>
												</div>
											</div>
										</div>
									</div>
	
								</div>	
							</div>
							
						</div>	
						
						<div class="archive_form_list" index="6" type="column" sort="true">
							<div class="form-group" id="item-partner-group">
								<label style="display:none"><cf_get_lang no="165.Partner Portal"></label>
								<div class="archive_form_list_title">
									<i class="fa fa-angle-down"></i>
									<cf_get_lang no='165.Partner Portal'>
								</div>
								<div class="archive_form_list_item">
									<div class="ui-form-list ui-form-block">
										<cfoutput query="get_company_cat">
											<div class="form-group" id="item-comp_cat_all">
												<input type="checkbox" name="comp_cat" id="comp_cat" value="#companycat_id#" <cfif isdefined("company_cat_id_list") and listfindnocase(company_cat_id_list,companycat_id)>checked</cfif>>
												<label>#companycat#</label>
											</div>
										</cfoutput>
									</div>
								</div>
							</div>
						</div>	

						<div class="archive_form_list" index="7" type="column" sort="true">
							<div class="form-group" id="item-public-group">
								<label style="display:none"><cf_get_lang no="169.Public Portal"></label>
								<div class="archive_form_list_title">
									<i class="fa fa-angle-down"></i>
									<cf_get_lang no='169.Public Portal'>
								</div>
								<div class="archive_form_list_item">
									<div class="ui-form-list ui-form-block">
										<cfoutput query="get_customer_cat">
											<div class="form-group">
												<input type="checkbox" name="customer_cat" id="customer_cat" value="#conscat_id#" <cfif isdefined("conscat_id_list") and listfindnocase(conscat_id_list,conscat_id)>checked</cfif>>
												<label>#conscat#</label>
											</div>
										</cfoutput>
									</div>
								</div>
							</div>
							
						</div>

						<div class="archive_form_list" index="8" type="column" sort="true">
							<div class="form-group" id="item-position-group">
								<label style="display:none"><cf_get_lang_main no='367.Pozisyon Tipleri'></label>
								<div class="archive_form_list_title">
									<i class="fa fa-angle-down"></i>
									<cf_get_lang_main no='367.Pozisyon Tipleri'>
								</div>
								<div class="archive_form_list_item">
									<div class="ui-form-list ui-form-block">
										<cfoutput query="get_position_cats">
											<div class="form-group">
												<input type="checkbox" name="position_cat_ids" id="position_cat_ids" value="#position_cat_id#" <cfif isdefined("get_position_cat_list") and listfindnocase(get_position_cat_list,position_cat_id)>checked</cfif>>
												<label>#position_cat#</label>
											</div>
										</cfoutput>
									</div>
								</div>
							</div>
						</div>

						<div class="archive_form_list" index="9" type="column" sort="true">
							<div class="form-group" id="item-user-group">
								<label style="display:none"><cf_get_lang no="172.Yetki Grupları"></label>
								<div class="archive_form_list_title">									
									<i class="fa fa-angle-down"></i>
									<cf_get_lang no='172.Yetki Grupları'>
								</div>
								<div class="archive_form_list_item">
									<div class="ui-form-list ui-form-block">
										<cfoutput query="get_user_groups">
											<div class="form-group">
												<input type="checkbox" name="user_group_ids" id="user_group_ids" value="#user_group_id#" <cfif isdefined("get_user_group_list") and listfindnocase(get_user_group_list,user_group_id)>checked</cfif>>
												<label>#user_group_name#</label>
											</div>
										</cfoutput>
									</div>
								</div>
							</div>
						</div>

						<div class="archive_form_list" index="10" type="column" sort="true">
							<div class="form-group" id="item-digital-group">
								<label style="display:none"><cf_get_lang no="22.Dijital Varlık Grupları"></label>
								<div class="archive_form_list_title">
									<i class="fa fa-angle-down"></i>
									<cf_get_lang no="22.Dijital Varlık Grupları">
								</div>
								<div class="archive_form_list_item">
									<div class="ui-form-list ui-form-block">
										<cfoutput query="get_digital_asset">
											<div class="form-group">
												<input type="checkbox" name="digital_assets" id="digital_assets" value="#group_id#" <cfif isdefined("get_digital_asset_group_list") and listfindnocase(get_digital_asset_group_list,group_id)>checked="checked"</cfif>>
												<label>#group_name#</label>
											</div>
										</cfoutput>
									</div>
								</div>
							</div>
						</div>
					</div>	
				</div>	
				<div class="ui-form-list-btn">
					<cf_record_info query_name="get_asset">
					<div>
						<cfif (get_asset.RECORD_EMP eq session.ep.userid)>
							<cf_workcube_buttons type_format="1"  is_authority_passive='1' is_upd='1' delete_page_url='#request.self#?fuseaction=asset.del_asset&assetcat_id=#get_asset.assetcat_id#&asset_id=#attributes.asset_id#&head=#get_asset.asset_name#' add_function='control()' del_function_for_submit='check_delete_dpl()'>
						<cfelse>
							<cf_workcube_buttons type_format="1" is_upd='1' delete_page_url='#request.self#?fuseaction=asset.del_asset&assetcat_id=#get_asset.assetcat_id#&asset_id=#attributes.asset_id#&head=#get_asset.asset_name#' add_function='control()' del_function_for_submit='check_delete_dpl()'>
						</cfif>
					</div>
				</div>
			</div>				

			<!--- <div class="row" type="row" id="meta_tanimlari">
			<cf_meta_descriptions action_id = '#attributes.asset_id#' action_type ='ASSET_ID' faction_type='#listgetat(attributes.fuseaction,1,"&")#'> 
			</div> --->				

		
		</cfform>
	</div>

<script type="text/javascript">
	$("#user_power").click(function(){
		$(".flex-row").stop().slideToggle(); 
		$(this).toggleClass("flex-row-open");
	});
	$(window).load(function(){
		<cfif len(get_asset.EMBEDCODE_URL)>		
			var pattern = new RegExp('^(https?:\\/\\/)?'+ // protocol
			'((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'+ // domain name
			'((\\d{1,3}\\.){3}\\d{1,3}))'+ // OR ip (v4) address
			'(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*'+ // port and path
			'(\\?[;&a-z\\d%_.~+=-]*)?'+ // query string
			'(\\#[-a-z\\d_]*)?$','i'); // fragment locator
			
			<cfif get_asset.EMBEDCODE_URL contains 'iframe'>
				str  = $('iframe').attr('src');
			<cfelse>
				str  = "<cfoutput>#get_asset.EMBEDCODE_URL#</cfoutput>";
			</cfif>
			$('#embcode').val(str);
			$('#srcembcode').val(str);
			if(!!pattern.test(str)){
                    var btn = $('<a>');
                    btn.attr({
                        "id":"go-url",
                        "href":str,
						"class":"input-group-addon",
						"target":"_blank"
                    });

                    var icon = "<i class='fa fa-link'></i>";

                    btn.append(icon);
                    $("#item-embcode").append(btn);
					
			}
				
		</cfif>
    });
	
	<cfif not isdefined("get_asset.EMBEDCODE_URL") AND not len(get_asset.EMBEDCODE_URL)>
	var fileInput  = document.querySelector( ".input-file" ),  
		button     = document.querySelector( ".input-trigger" ),
		the_return = document.querySelector(".file-return");
		
	button.addEventListener( "keydown", function( event ) {  
		if ( event.keyCode == 13 || event.keyCode == 32 ) {  
			fileInput.focus();  
		}  
	});
	button.addEventListener( "click", function( event ) {
	fileInput.focus();
	return false;
	});  
	fileInput.addEventListener( "change", function( event ) {  
		the_return.innerHTML = this.value;  
	});  
	</cfif>

	/*
	function attachStream(streamName)
	{
		document.getElementById("asset_file").disabled = "true";
		document.getElementById("stream_name").value = streamName;
	}
	function detach(streamName)
	{
		document.getElementById("asset_file").disabled = "false";
		document.getElementById("asset_file").value = "";
		document.getElementById("stream_name").value = "";
	}
	*/
	function control()
	{
		if ($('#upd_asset #asset_name').val()  == '')
		{
			alert("<cf_get_lang_main no='59.eksik veri'>: <cf_get_lang dictionary_id='42266.Document Name'> !");
			return false;
		}
		if ($('#upd_asset #assetcat_id').val()  == '')
		{
			alert("<cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='74.Kategori'> !");
			return false;
		}
	
		if ($('#upd_asset #property_id').val() == '')
		{
			alert("<cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='655.Döküman Tipi'> !");
			return false;
		}

		if($('#upd_asset #asset_description').val().length >1000)
		{
			alert("<cf_get_lang_main no='65.Hatalı veri'>:En Fazla 1000 Karakter!");
			return false;
		}
	
		if($('#upd_asset #asset_detail').val().length >100)
		{
			alert("<cf_get_lang_main no='65.Hatalı veri'>:<cf_get_lang no ='174.En fazla 100 Karakter'> !");
			return false;
		}
		
		if($('#upd_asset #asset_no').val() == '')
		{
			alert("<cf_get_lang_main no='468.Belge No'>!");
			return false;
		}
		
		var obj =  $('#asset').val();
		var restrictedFormat = new Array('php','jsp','asp','cfm','cfml');
		for(i=0;i<restrictedFormat.length;i++){

			if(obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == restrictedFormat[i])
			{
				alert("<cf_get_lang no='133.php,jsp,asp,cfm,cfml Formatlarda Dosya Girmeyiniz'>");        										
				return false;										
			}
			else if((obj.length == (obj.indexOf('.') + 5)) && (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 5).toLowerCase() == restrictedFormat[i]))
			{
				alert("<cf_get_lang no='133.php,jsp,asp,cfm,cfml Formatlarda Dosya Girmeyiniz'>");        										
				return false;										
			}
			
		}

		if(document.getElementById('project_multi_id')!= undefined)
		{
			select_all('project_multi_id');
			
		}
			
		return true;
	 }

	function digital_assets_hepsi()
	{
		/*
		if (document.getElementById('digital_assets_all').checked)
		{	
			for(say=0;say<document.getElementsByName('digital_assets').length;say++)
				document.getElementsByName('digital_assets')[say].checked = true;
		}
		else
		{*/
			for(say=0;say<document.getElementsByName('digital_assets').length;say++)
				document.getElementsByName('digital_assets')[say].checked = false;
		/*}*/
		return false;
	}

	function sel_digital_asset_group()
	{
		digital_assets_hepsi(); //Kosullara uygun kayit yoksa tumunu sec/kaldir calismis olur
		var GET_ASSET_GROUP = wrk_safe_query('ascr_get_emp_asset_group','dsn',0,document.getElementById('property_id').value);
		if(GET_ASSET_GROUP.recordcount)
		{
			var group_list = '0';
			for(say=0;say<GET_ASSET_GROUP.recordcount;say++)
				group_list = group_list+','+GET_ASSET_GROUP.GROUP_ID;
			for(say=1;say<=document.getElementsByName("digital_assets").length;say++)
			{
				if(list_find(group_list,document.getElementsByName("digital_assets")[say-1].value))
					document.getElementsByName("digital_assets")[say-1].checked = true;
				else
					document.getElementsByName("digital_assets")[say-1].checked = false;
			}
		}
	}

	function revision()
	{
		document.getElementById('revision_no').disabled = false;
		document.upd_asset.action='<cfoutput>#request.self#?fuseaction=asset.form_add_asset&revision=1&asset_cat_id=#attributes.assetcat_id#</cfoutput>';
		if(document.getElementById('project_multi_id')!= undefined)
		{
			select_all('project_multi_id');
		}
		upd_asset.submit();
	}
	function copy_asset()
	{
		document.getElementById('revision_no').disabled = false;
		document.upd_asset.action='<cfoutput>#request.self#?fuseaction=asset.form_add_asset&asset_id=#attributes.asset_id#</cfoutput>';
		if(document.getElementById('project_multi_id')!= undefined)
		{
			select_all('project_multi_id');
		}
		upd_asset.submit();
	}
	function project_remove()
	{
		for (i=document.getElementById('project_multi_id').options.length-1;i>-1;i--)
		{
			if (document.getElementById('project_multi_id').options[i].selected==true)
			{
				document.getElementById('project_multi_id').options.remove(i);
			}	
		}
	}
	function select_all(selected_field)
	{
		var m = document.getElementById(selected_field).options.length;
		for(i=0;i<m;i++)
		{
			document.getElementById(selected_field)[i].selected=true;
		}
	}	
	function dpl_yrm()
	{
	<cfif session.ep.our_company_info.workcube_sector eq 'tersane'>
		if(document.getElementById('featured').checked == true && document.getElementById('is_dpl').checked == false)
		{
			document.getElementById('featured').checked = false;
			alert('Yarı Mamül Seçmek İçin Önce DPL Seçmelisiniz !')
			return false;
		}
	</cfif>
	}
	
	function check_delete_dpl()
	{
		var sql_dpl = "SELECT DPL_ID FROM DRAWING_PART WHERE ASSET_ID ="+document.getElementById('asset_id').value;
		GET_DPL_COUNT = wrk_query(sql_dpl,'dsn3');
		if(GET_DPL_COUNT.recordcount != 0)
		{
			alert("İlişkili DPL'i Olan Bir Belgeyi Silemezsiniz !");	
			return false;
		}
		else
			return true;
	}

	function check_yrm()
	{
		<cfif session.ep.our_company_info.workcube_sector eq 'tersane'>
		if(document.getElementById('is_dpl').checked == false)
		{
			document.getElementById('featured').checked = false;
		}
		</cfif>
	}

	var is_internet = "is_internet";
	var is_extranet = "is_extranet";
	var domaincheckedCounter = 0;
	var partnercheckedCounter = 0;
	var domainsCount = checkboxCount("#internet-panel input[type = checkbox]");
	var partnersCount = checkboxCount("#item-comp_cat_all input[type = checkbox]");

	function checkboxCount(element){

		var counter = 0;

		$(element).each(function(){
			
			counter++;

		});

		return counter;

	}
	
	function checkedElement(panelid,checkedName)
	{
		$("#"+panelid + " input[type = checkbox]").each(function(){
			
			if($("input[name = "+checkedName+"]").is(":checked")){

				this.checked = true;
				if(checkedName == is_internet) domaincheckedCounter++;
				else if(checkedName == is_extranet) partnercheckedCounter++;
				
			}else {

				this.checked = false;
				if(checkedName == is_internet) domaincheckedCounter--;
				else if(checkedName == is_extranet) partnercheckedCounter--;

			}

		});
	}
	
	$("#internet-panel input[type = checkbox]").click(function(){
		
		var id = $(this).attr("id");

		if($(this).is(":checked")){

			this.checked = true;
			domaincheckedCounter++;
			
		}else {

			this.checked = false;
			domaincheckedCounter--;

		}

		if(domaincheckedCounter == 0) $("input[name = is_internet]").prop("checked",false);
		else if(domaincheckedCounter > 0) $("input[name = is_internet]").prop("checked",true);
	
	});


	$("#item-comp_cat_all input[type = checkbox]").click(function(){
		
		if($(this).is(":checked")){

			this.checked = true;
			partnercheckedCounter++;
			
		}else {

			this.checked = false;
			partnercheckedCounter--;

		}

		if(partnercheckedCounter == 0) $("input[name = is_extranet]").prop("checked",false);
		else if(partnercheckedCounter > 0) $("input[name = is_extranet]").prop("checked",true);
	
	});
	var revStatus = false;
	function revision_control(){
        if(!revStatus){
			revision_number = document.getElementById('revision_no').value;
			revision_number++;
			document.getElementById('revision_no').value = revision_number;
			document.getElementById('change_revision').value = 1;
			revStatus = true;
		}
    }

	$("iframe").height(277);

	$("input[name=embcode]").on("keyup keydown", function(){
		
		if($(this).val() != "")
		{
			$("input[name=asset]").val("1");		
			var valembcode = document.getElementById('embcode').value;
			var parser = document.createElement('a');
			parser.href = valembcode;
			var hostname = parser.hostname;
			var str = "";			
			document.getElementById('srcembcode').value = document.getElementById('embcode').value;
			
		}
		else{
			document.getElementById('srcembcode').value = document.getElementById('embcode').value;
		}
	});
	
	
		
</script>