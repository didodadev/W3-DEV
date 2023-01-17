<cf_papers paper_type="ASSET">
<cfset system_paper_no=paper_code & '-' & paper_number>
<cfset system_paper_no_add=paper_number>
<cfif len(paper_number)>
	<cfset asset_no = system_paper_no>
<cfelse>
	<cfset asset_no = ''>
</cfif>
<cfif isdefined("attributes.revision")>
	<cfset asset_no = attributes.asset_no>
    <cfquery name="GET_ASSET_NO" datasource="#DSN#">
	    SELECT ISNULL(MAX(REVISION_NO),0) REVISION_NO FROM ASSET WHERE ASSET_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.asset_no#">
    </cfquery>
    <cfset attributes.revision_no = (get_asset_no.revision_no+1)>
	<cfset attributes.related_asset_id = attributes.asset_id>
<cfelseif isdefined("attributes.asset_id") and len(attributes.asset_id)>
	<cfinclude template="../query/get_asset.cfm">
    <cfset attributes.product_id = get_asset.product_id>
	<cfset attributes.asset_name = get_asset.asset_name>
	<cfset attributes.stream_name = ''>
    <cfset attributes.assetcat_id = get_asset.assetcat_id>
	<cfset attributes.asset_description = get_asset.asset_description>
    <cfset attributes.asset_detail = get_asset.asset_detail>
	<cfset attributes.project_id = get_asset.project_id>
    <cfset attributes.property_id = get_asset.property_id>
    <cfset attributes.revision_no = get_asset.revision_no>
    <cfset attributes.related_asset_id = get_asset.related_asset_id>
    <cfset attributes.validate_start_date = get_asset.validate_start_date>
    <cfset attributes.validate_finish_date = get_asset.validate_finish_date>
	<cfset attributes.mail_receiver_partner_id = ''>
    <cfset attributes.mail_receiver_emp_id = ''>
    <cfset attributes.mail_receiver = ''>
	<cfset attributes.mail_cc_partner_id = ''>
    <cfset attributes.mail_cc_emp_id = ''>
    <cfset attributes.mail_cc = ''>
<cfelse>
	<cfset attributes.product_id = ''>
    <cfif not isdefined("attributes.asset_cat_id")>
		<cfset attributes.assetcat_id = "">
	<cfelse>
		<cfquery name="get_asset_cat" datasource="#dsn#">
			SELECT ASSETCAT_ID,ASSETCAT FROM ASSET_CAT WHERE ASSETCAT_ID = <cfqueryparam value = "#attributes.asset_cat_id#" CFSQLType = "cf_sql_integer">
		</cfquery>
		<cfset attributes.assetcat_id = get_asset_cat.assetcat_id>
		<cfset attributes.assetcat_name = get_asset_cat.assetcat>	
    </cfif>
	<cfset attributes.asset_name = ''>
	<cfset attributes.stream_name = ''>
	<cfset attributes.asset_description = ''>
    <cfset attributes.asset_detail = ''>
	<cfset attributes.project_id = ''>
    <cfset attributes.project_head = ''>
	<cfset attributes.mail_receiver_partner_id = ''>
    <cfset attributes.mail_receiver_emp_id = ''>
    <cfset attributes.mail_receiver = ''>
	<cfset attributes.mail_cc_partner_id = ''>
    <cfset attributes.mail_cc_emp_id = ''>
    <cfset attributes.mail_cc = ''>
    <cfset attributes.revision_no = '0'>
    <cfset attributes.related_asset_id = ''>
    <cfset attributes.validate_start_date = ''>
    <cfset attributes.validate_finish_date = ''>
</cfif>
<cfparam name="attributes.stream_name" default="#createUUID()#"/>
<cfset foldername = createUUID()>
<cfinclude template="../query/get_asset_cats.cfm">
<cfinclude template="../../objects/display/imageprocess/imcontrol.cfm">
<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_customer_cat_add.cfm">
<cfquery name="GET_COMPANY_SITES" datasource="#DSN#">
	SELECT 
		MENU_ID,
		SITE_DOMAIN,
		OUR_COMPANY_ID 	
	FROM 
		MAIN_MENU_SETTINGS 
	WHERE 
		SITE_DOMAIN IS NOT NULL
</cfquery>
<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
	SELECT 
	POSITION_CAT_ID,
	#dsn#.Get_Dynamic_Language(POSITION_CAT_ID,'#session.ep.language#','SETUP_POSITION_CAT','POSITION_CAT',NULL,NULL,SETUP_POSITION_CAT.POSITION_CAT ) AS POSITION_CAT 
	 
	FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<cfquery name="GET_USER_GROUPS" datasource="#DSN#">
	SELECT 
	USER_GROUP_ID,
	#dsn#.Get_Dynamic_Language(USER_GROUP_ID,'#session.ep.language#','USER_GROUP','USER_GROUP_NAME',NULL,NULL,USER_GROUP.USER_GROUP_NAME ) AS USER_GROUP_NAME 
	
	FROM USER_GROUP
	 ORDER BY USER_GROUP_NAME
</cfquery>
<cfquery name="GET_DIGITAL_ASSET" datasource="#DSN#">
	SELECT 
	GROUP_ID,
	#dsn#.Get_Dynamic_Language(GROUP_ID,'#session.ep.language#','DIGITAL_ASSET_GROUP','GROUP_NAME',NULL,NULL,DIGITAL_ASSET_GROUP.GROUP_NAME ) AS GROUP_NAME 

	FROM 
	DIGITAL_ASSET_GROUP ORDER BY GROUP_NAME
</cfquery>

<!--- Proje Iliskileri --->
<cfif isdefined("attributes.action") and attributes.action eq "PROJECT_ID" and isdefined("attributes.action_id") and len(attributes.action_id)><cfset attributes.project_id = attributes.action_id></cfif>
<cfif isdefined("attributes.project_multi_id") and len(attributes.project_multi_id)><cfset attributes.project_id = attributes.project_multi_id></cfif>
<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
    <cfquery name="GET_PROJECT" datasource="#dsn#">
        SELECT PROJECT_HEAD,PROJECT_ID,COMPANY_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#attributes.project_id#)
    </cfquery>
</cfif>

<style>
	.pageMainLayout{padding:0;}
</style>
<!--- <link rel="stylesheet" href="/css/assets/template/w3-intranet/intranet.css" type="text/css"> --->
<link rel="stylesheet" href="/css/assets/template/fileupload/dropzone.css" type="text/css">
<link rel="stylesheet" href="/css/assets/template/fileupload/fileupload-min.css" type="text/css">
<cfinclude template="../../rules/display/rule_menu.cfm">

	<div id="archive" class="wrapper">
		<div class="blog_title">
			<cfdump var = "#getLang('main',150)#">
			<ul>
				<li><a id="folder_layout" href="<cfoutput>#request.self#?fuseaction=asset.list_asset&folderControl=1</cfoutput>"><i class="wrk-uF0144"></i> <cf_get_lang dictionary_id="52819.Klasör"></a></li>
				<li><a id="table_layout" href="<cfoutput>#request.self#?fuseaction=asset.list_asset&listTypeElement=list</cfoutput>"><i class="wrk-uF0083"></i> <cf_get_lang dictionary_id="57509.Liste"></a></li>
				<li><a id="table_layout" href="<cfoutput>#request.self#?fuseaction=asset.list_asset</cfoutput>"><i class="wrk-uF0081"></i><cf_get_lang dictionary_id="35463.Card"></a></li>
			</ul>
		</div> 

	<cfform name="add_asset" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=asset.add_asset">
		<input type="hidden" name="is_image" id="is_image" value="<cfif isdefined('attributes.is_image')><cfoutput>#attributes.is_image#</cfoutput><cfelse>0</cfif>">
		<input type="hidden" name="module" id="module" value="<cfif isdefined('attributes.module') and len(attributes.module)><cfoutput>#attributes.module#</cfoutput></cfif>">
		<input type="hidden" name="module_id" id="module_id" value="<cfif isdefined('attributes.module_id') and len(attributes.module_id)><cfoutput>#attributes.module_id#</cfoutput></cfif>">
		<input type="hidden" name="action_section" id="action_section" value="<cfif isdefined('attributes.action') and len(attributes.action)><cfoutput>#attributes.action#</cfoutput></cfif>">
		<input type="hidden" name="action_id" id="action_id" value="<cfif isdefined('attributes.action_id') and len(attributes.action_id)><cfoutput>#attributes.action_id#</cfoutput></cfif>">
		<input type="hidden" name="action_id_2" id="action_id_2" value="<cfif isdefined("attributes.action_id_2")><cfoutput>#attributes.action_id_2#</cfoutput></cfif>">
		<input type="hidden" name="action_type" id="action_type" value="<cfif isdefined('attributes.action_type') and len(attributes.action_type)><cfoutput>#attributes.action_type#</cfoutput></cfif>">
			
		<div class="archive_form">
			<div class="archive_form_step">
				<div class="sub_title">
					<cf_get_lang dictionary_id = "48364.Dosya yükle">
				</div>
				<div class="ui-row">
					<div class="ui-form-list ui-form-block">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12 form-group">
							<div id="fileUpload" class="fileUpload">
								<cfoutput>
								<div class="fileupload-body">
									<input type="hidden" name="foldername" value="#foldername#">
									<input type="hidden" name="asset" id="asset" value="">
									<input type="hidden" name="asset_control" id="asset_control" value="">
									<input type="hidden" name="message_Del" id="message_Del" value="<cfoutput>#getLang('main',51)#</cfoutput>">
									<input type="hidden" name="message_Cancel" id="message_Cancel" value="<cfoutput>#getLang('crm',21)#</cfoutput>">
									<div class="dropzone dz-clickable dropzonescroll" id="file-dropzone">
										<div class="dz-default dz-message">
											<i><cf_get_lang dictionary_id='61360.?'></i>
											<a href="javascript://"><span class="catalyst-pin"></span>Max : 200 MB</a>
										</div>
									</div>				
								</div>  
								</cfoutput>      
							</div>
						</div>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12 form-group">
							<label>Url</label>
							<input type="hidden" name="srcembcode" id="srcembcode" value="">
							<input type="text" name="embcode" id="embcode" value="">
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="archive_form">
			<div class="archive_form_step">
				<div class="sub_title">
					<span><cf_get_lang dictionary_id="57980.Genel Bilgiler">
				</div>
				<div class="ui-row">
					<div class="ui-form-list ui-form-block" type="row">
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="1" type="column" sort="true">
							<div class="form-group" id="item-asset_name_">
								<label><cfoutput>#getLang('settings',283)#</cfoutput></label>
								<cfinput type="text" name="asset_name"  id="asset_name" required>
							</div>
							<div class="form-group" id="item-process_stage_">
								<label><cf_get_lang_main no='1447.Süreç'></label>
								<cfif isdefined('attributes.process_stage')>
									<cf_workcube_process is_upd='0' process_cat_width='250' select_value='#attributes.process_stage#' is_detail='0'>
								<cfelse>
									<cf_workcube_process is_upd='0' process_cat_width='250' is_detail='0'>               
								</cfif>
							</div>
							<div class="form-group" id="item-product_name_">
								<label><cf_get_lang_main no='245.Ürün'></label>
								<div class="input-group">
									<input type="hidden" name="product_id" id="product_id" value="<cfoutput><cfif isDefined("attributes.action") and attributes.action eq 'PRODUCT_ID' and len(attributes.action_id)>#attributes.action_id#<cfelseif len(attributes.product_id)>#attributes.product_id#</cfif></cfoutput>">
									<input type="text" name="product_name" id="product_name" style="width:250px;" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','100');" value="<cfoutput><cfif isDefined("attributes.action") and attributes.action eq 'PRODUCT_ID' and len(attributes.action_id)>#get_product_name(product_id:attributes.action_id)#<cfelseif len(attributes.product_id)>#get_asset.product_name#</cfif></cfoutput>" autocomplete="off">
									<span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=add_asset.product_id&field_name=add_asset.product_name&keyword='+encodeURIComponent(document.add_asset.product_name.value),'list');"></span>
								</div>
							</div>
							<cfoutput>
								<div class="form-group" id="item-validate_start_date_">
									<label><cf_get_lang no='31.Geçerlilik Başlangıç Tarihi'></label>
									<div class="input-group">
										<cfinput type="text" name="validate_start_date" id="validate_start_date" value="#dateformat(attributes.validate_start_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
										<span class="input-group-addon"><cf_wrk_date_image date_field="validate_start_date"></span>
									</div>
								</div>
							</cfoutput>
							<div class="form-group" id="item-asset_description_">
								<label><cf_get_lang_main no='217.Aciklama'></label>
								<cfsavecontent variable="textmessage"><cf_get_lang_main no='1687.Fazla karakter sayısı'></cfsavecontent>
								<textarea name="asset_description" id="asset_description" rows="5" message="<cfoutput>#textmessage#</cfoutput>" maxlength="1000" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"><cfoutput>#attributes.asset_description#</cfoutput></textarea>
							</div>
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="2" type="column" sort="true">
							<div class="form-group" id="item-asset_no_">
								<label><cf_get_lang_main no ='468.Belge No'>*</label>
								<input type="text" name="asset_no"  id="asset_no" <cfif isdefined("attributes.revision")>readonly="readonly"</cfif> value="<cfoutput>#asset_no#</cfoutput>">
							</div>
							<div class="form-group" id="item-assetcat_id_">
								<label><cf_get_lang_main no='1739.Tüm Kategoriler'> *</label>
								<div class="input-group">
									<input type="hidden" name="assetcat_id" id="assetcat_id" <cfif isdefined('attributes.assetcat_id') and len(attributes.assetcat_id)>value="<cfoutput>#attributes.assetcat_id#</cfoutput>"</cfif> required>
									<input type="text" name="assetcat_name" id="assetcat_name" <cfif isdefined('attributes.assetcat_name') and len(attributes.assetcat_name)>value="<cfoutput>#attributes.assetcat_name#</cfoutput>"</cfif> onfocus="AutoComplete_Create('assetcat_name','ASSETCAT','ASSETCAT_PATH','get_asset_cat','0','ASSETCAT_ID','assetcat_id','','3','130');" autocomplete="off" required>
									<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_asset_cat&chooseCat=1&form_name=add_asset&field_id=assetcat_id&field_name=assetcat_name','list');"></span>			
								</div>
								<input type="hidden" id="stream_name" name="stream_name" value="<cfoutput>#attributes.stream_name#</cfoutput>">
								<input type="hidden" id="is_stream" name="is_stream" value="<cfif isdefined("attributes.is_stream")><cfoutput>#attributes.is_stream#</cfoutput></cfif>">
							</div>
							<div class="form-group" id="item-mail_receiver_">
								<label><cfoutput>#getLang('main',512)#</cfoutput></label>
								<div class="input-group">
									<input type="hidden" name="mail_receiver_partner_id" id="mail_receiver_partner_id" value="<cfoutput>#attributes.mail_receiver_partner_id#</cfoutput>">
									<input type="hidden" name="mail_receiver_emp_id" id="mail_receiver_emp_id" value="<cfoutput>#attributes.mail_receiver_emp_id#</cfoutput>">
									<cfinput type="text" name="mail_receiver" id="mail_receiver" value="#attributes.mail_receiver#" onFocus="AutoComplete_Create('mail_receiver','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','PARTNER_ID,EMPLOYEE_ID','mail_receiver_partner_id,mail_receiver_emp_id','','3','200');" style="width:120px;">
									<span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_partner=add_asset.mail_receiver_partner_id&field_emp_id=add_asset.mail_receiver_emp_id&field_name=add_asset.mail_receiver&select_list=1,2,3</cfoutput>','list');"></span>
								</div>
							</div>
							<cfoutput>
								<div class="form-group" id="item-validate_finish_date_">
									<label><cf_get_lang no='42.Geçerlilik Bitiş Tarihi'></label>
									<div class="input-group">
										<cfinput type="text" name="validate_finish_date" id="validate_finish_date" value="#dateformat(attributes.validate_finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
										<span class="input-group-addon"><cf_wrk_date_image date_field="validate_finish_date"></span>
									</div>
								</div>
							</cfoutput>
							<div class="form-group" id="item-asset_detail_">
								<label><cf_get_lang no='70.Anahtar Kelimeler'></label>
								<textarea name="asset_detail" id="asset_detail" rows="5"  message="<cfoutput>#textmessage#</cfoutput>" maxlength="100" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"><cfoutput>#attributes.asset_detail#</cfoutput></textarea>
							</div>
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="3" type="column" sort="true">
							<div class="form-group" id="item-revision_">
								<label><cf_get_lang no="199.Revizyon"></label>
								<input type="text" name="revision_no" id="revision_no" value="<cfoutput>#attributes.revision_no#</cfoutput>" readonly="readonly">
							</div>
							<div class="form-group" id="item-property_id_1">
								<label><cf_get_lang_main no='655.Döküman Tipi'>*</label>
								<cfif not isdefined("attributes.property_id")><cfset attributes.property_id = ""></cfif>
								<cf_wrk_selectlang
									name="property_id"
									width="250"
									table_name="CONTENT_PROPERTY"
									option_name="NAME"
									value="#attributes.property_id#"
									option_value="CONTENT_PROPERTY_ID"
									required="true"
									onchange="sel_digital_asset_group();">
							</div>
							<div class="form-group" id="item-mail_cc_">
								<label><cf_get_lang no='189.CC'></label>
								<div class="input-group">
									<input type="hidden" name="mail_cc_partner_id" id="mail_cc_partner_id" value="<cfoutput>#attributes.mail_cc_partner_id#</cfoutput>">
									<input type="hidden" name="mail_cc_emp_id" id="mail_cc_emp_id" value="<cfoutput>#attributes.mail_cc_emp_id#</cfoutput>">
									<cfinput type="text" name="mail_cc" id="mail_cc" value="#attributes.mail_cc#" onFocus="AutoComplete_Create('mail_cc','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','PARTNER_ID,EMPLOYEE_ID','mail_cc_partner_id,mail_cc_emp_id','','3','200');" style="width:120px;">
									<span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_partner=add_asset.mail_cc_partner_id&field_emp_id=add_asset.mail_cc_emp_id&field_name=add_asset.mail_cc&select_list=1,2,3</cfoutput>','list');"></span>
								</div>
							</div>
							<div class="form-group" id="item-project_multi_id_">
								<label><cf_get_lang_main no='4.Proje'></label>
								<div>
									<select name="project_multi_id" id="project_multi_id" multiple>
										<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
											<cfoutput query="get_project">
												<option value="#get_project.project_id#">#get_project.project_head#</option>
											</cfoutput>
										</cfif>
									</select>
									<span onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_head=add_asset.project_multi_id&project_id=add_asset.project_multi_id&form_varmi=1&multi=1');"><i class="fa fa-plus" alt="<cf_get_lang_main no='4.Proje'>"></i></span>
									<span onclick="project_remove();"><i class="fa fa-minus" title="<cf_get_lang_main no ='51.Sil'>" style="cursor=hand" align="top"></i></span>
								</div>
							</div>
						</div>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12" index="4" type="column" sort="true">
							<div class="form-group col col-2 col-xs-12" id="item-is_active_">
								<label><input type="checkbox" name="is_active" id="is_active" value="1" checked="checked"><cfoutput>#getLang('main',81)#</cfoutput></label>
							</div>
							<div class="form-group col col-2 col-xs-12" id="item-is_special_">
								<label><input type="checkbox" name="is_special" id="is_special" value="1"><cfoutput>#getLang('asset',186)#</cfoutput></label>
							</div>
							<div class="form-group col col-2 col-xs-12" id="item-featured_">
								<label><input type="checkbox" name="featured" id="featured" value="1"><cfoutput>#getLang('asset',197)#</cfoutput></label>
							</div>
							<cfif session.ep.our_company_info.workcube_sector eq 'tersane'>
								<div class="form-group col col-2 col-xs-12" id="item-is_dpl_">
									<label><input type="checkbox" name="is_dpl" id="is_dpl" value="1" onclick="check_yrm();" <cfif isdefined("attributes.is_dpl")>checked="checked"</cfif>><cf_get_lang no="10.DPL"></label>
								</div>
							</cfif>
							<div class="form-group col col-2 col-xs-12" id="item-employee_view_1">
								<label><input type="checkbox" name="employee_view" id="employee_view" value="1" <cfif isdefined("attributes.employee_view")> checked="checked"</cfif>><cfoutput>#getLang('assetcare',287)#</cfoutput></label>
							</div>
							<div class="form-group col col-2 col-xs-12" id="item-is_internet_">
								<label><input type="checkbox" name="is_internet" id="is_internet" value="1" onclick="checkedElement('internet-panel','is_internet');"><cfoutput>#getLang('asset',59)#</cfoutput></label>
							</div>
							<div class="form-group col col-2 col-xs-12" id="item-is_extranet_">
								<label><input type="checkbox" name="is_extranet" id="is_extranet" value="1" onclick="checkedElement('item-comp_cat_all','is_extranet');"><cfoutput>#getLang('assetcare',295)#</cfoutput></label>
							</div>
						</div>	
					</div>
				</div>
			</div>
		</div>

		
		<div class="archive_form">
			<div class="archive_form_step">
				<div class="sub_title" id="user_power">
					<span class="btnPointer"><cf_get_lang dictionary_id='61348.Döküman Erişim İzinleri Detaylandırma'><i class='fa fa-angle-down bold'></i></span>
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
								
									<div id="internet-panel">
										<div class="ui-form-list ui-form-block">
											<cfoutput query="get_company_sites">
												<div class="form-group">
													<input type="checkbox" name="menu_#menu_id#" id="menu_#menu_id#" <cfif isdefined("attributes.menu_#menu_id#")>checked="checked"</cfif> value="#site_domain#">
													<label>#site_domain#</label>
												</div>
											</cfoutput>
											<div class="form-group">
												<input type="checkbox" name="career_view" id="career_view" <cfif isdefined("attributes.career_view")> checked="checked"</cfif>>
												<label><cf_get_lang no='164.Kariyer Portal'></label>
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
								<div id="item-comp_cat_all">
									<div class="ui-form-list ui-form-block">
										<cfoutput query="get_company_cat">
											<div class="form-group">
												<input type="checkbox" name="comp_cat" id="comp_cat" <cfif isdefined("attributes.comp_cat") and attributes.comp_cat eq COMPANYCAT_ID> checked="checked"</cfif> value="#COMPANYCAT_ID#">
												<label>#companycat#</label>
											</div>
										</cfoutput>
									</div>
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
											<input type="checkbox" name="customer_cat" id="customer_cat" value="#conscat_id#" <cfif isdefined("attributes.customer_cat") and isDefined('attributes.conscat_id')> checked="checked"</cfif>>
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
											<input type="checkbox" name="position_cat_ids" id="position_cat_ids" value="#position_cat_id#" <cfif isdefined("attributes.position_cat_ids") and get_position_cats.position_cat_id eq attributes.position_cat_ids> checked="checked"</cfif>>
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
											<input type="checkbox" name="user_group_ids" id="user_group_ids" value="#user_group_id#" <cfif isdefined("attributes.user_group_ids") and get_user_groups.user_group_id eq attributes.user_group_ids> checked="checked"</cfif>>
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
											<input type="checkbox" name="digital_assets" id="digital_assets" value="#group_id#" >
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
				<div>
					<cf_workcube_buttons is_upd='0'>
				</div>
			</div>
		</div>	
	</cfform>
</div>
<!--- <div class="mbl-intranet-button-panel">

	<ul class="mbl-button-panel col col-12">
		<a href="<cfoutput>#request.self#?fuseaction=asset.list_asset</cfoutput>">
		<li class="mbl-wrk-nw-button modalButton col col-6">
			<i class="fa fa-align-justify"></i>
		</li>
		</a>
		<a href="<cfoutput>#request.self#?fuseaction=asset.list_asset&event=add</cfoutput>">
			<li class="mbl-wrk-nw-button modalButton col col-6">
				<i class="fa fa-upload"></i>
			</li>
		</a>
	</ul>

</div> --->

<script type="text/javascript" src="/JS/fileupload/dropzone.js"></script>
<script type="text/javascript" src="/JS/fileupload/fileupload-min.js"></script>

<script type="text/javascript">
	$("#user_power").click(function(){
	 	$(".flex-row").stop().slideToggle(); 
        $(this).toggleClass("flex-row-open");
	});
	$(function(){
		///for file upload area text
		

	});

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

	//revizyondan gelen varlıklar icin
	<cfif isdefined("attributes.revision") and (attributes.revision) >
	window.onload = revision_load_functions;
	function revision_load_functions()
	{
		gizle_goster(broadcast_area);
		<cfif isdefined("attributes.digital_assets_all") >digital_assets_hepsi();</cfif>
		<cfif isdefined("attributes.user_group_id_all") >usergroup_hepsi();</cfif>
		<cfif isdefined("attributes.position_cat_id_all") >position_hepsi();</cfif>
		<cfif isdefined("attributes.customer_cat_all") >public_hepsi();</cfif>
		<cfif isdefined("attributes.is_internet") >
			//gizle_goster(is_site);
			gizle_goster(is_site_2);
		</cfif>
	}
	</cfif>
	
	
	function check()
	{
		if ($('#add_asset #asset_name').val()  == '')
		{
			alert("<cf_get_lang_main no='59.eksik veri'>: <cf_get_lang dictionary_id='42266.Document Name'> !");
			return false;
		}
		if ($('#add_asset #assetcat_id').val()  == '')
		{
			alert("<cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='74.Kategori'> !");
			return false;
		}
		
		if ($('#add_asset #property_id').val() == '')
		{
			alert("<cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='655.Döküman Tipi'> !");
			return false;
		}

		if($('#add_asset #asset_description').val().length >1000)
		{
			alert("<cf_get_lang_main no='65.Hatalı veri'>:En Fazla 1000 Karakter!");
			return false;
		}
	
		if($('#add_asset #asset_detail').val().length >100)
		{
			alert("<cf_get_lang_main no='65.Hatalı veri'>:<cf_get_lang no ='174.En fazla 100 Karakter'> !");
			return false;
		}
		if($('#add_asset #asset').val() == 1){
			
			var restrictedFormat = new Array('php','jsp','asp','cfm','cfml');

			if($('#add_asset #asset_no').val() == '')
			{
				alert("<cf_get_lang_main no='468.Belge No'>!");
				return false;
			}

			
		
			if(document.getElementById('project_multi_id')!= undefined)
			{
				select_all('project_multi_id');
			}		
		
			if((document.getElementById('product_id').value == '' || document.getElementById('product_name').value =='') && document.getElementById('is_dpl') != undefined && document.getElementById('is_dpl').checked==true)
			{
				alert('Ürün Seçiniz !');
				return false;
			}
			
			<cfif session.ep.our_company_info.workcube_sector eq 'tersane'>
				<cfif isdefined("attributes.revision") and (attributes.revision) >
				if(document.add_asset.getElementById('is_dpl').checked)
				{
					if(confirm("İlişkili DPL Kopyalansın mı ?")==false)
					{
						document.add_asset.getElementById('is_copy_dpl').value = 0;
					}
					if(document.add_asset.getElementById('live').checked == true)	
					{
						if(confirm("Ana Üründe Bu Revizyon Geçerli Olacaktır !")==false)
							return false;
					}
				}
				</cfif>
			</cfif>

		}else{
			alert("<cfoutput>#getLang('dev',25)#</cfoutput>");
			return false;
		}
		
		<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>
			return process_cat_control();
		<cfelse>
			return true;
		</cfif>
	}

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


</script>
