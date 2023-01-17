<cf_xml_page_edit fuseact="settings.asset_cat">
<cfset url_str = "">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.startrow" default=1>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.assetcat_id" default="">
<cfparam name="attributes.assetcat_name" default="">
<cfparam name="attributes.bottomCat" default="">
<cfparam name="attributes.asset_cat_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_view" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.property_id" default="">
<cfparam name="attributes.record_par_id" default="">
<cfparam name="attributes.record_member" default="">
<cfparam name="attributes.record_date1" default="">
<cfparam name="attributes.record_date2" default="">
<cfparam name="attributes.sort_type" default="1">
<cfparam name="attributes.folderControl" default="">
<cfparam name="attributes.list_type" default="changeColumn">
<cfparam name="attributes.listTypeElement" default="box">
<cfparam name="attributes.x_show_by_digital_asset_group" default="#x_show_by_digital_asset_group#">
<cfparam name="attributes.x_dont_show_file_by_digital_asset_group" default="#x_dont_show_file_by_digital_asset_group#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1 >
<cfif not isdefined("attributes.is_submit")>
	<cfset attributes.is_active = 1>
	<cfset attributes.is_revision = 1>
</cfif>
<!--- Revizyon Olanları Getirme seçeneği revizyon görmüş belgelerin önceki revizyonlarının gösterilmemesini sağlar.
Liste görünümünde Geçerlilik Başlangıç Tarihi ve Revizyon tarihi alanı; Belge revizyon görmüş ise Geçerlilik Başlangıç tarihi ilk eklenen belgenin geçerlilik başlangıç tarihi,  Revizyon tarihinde ise son revize edilen belgenin geçerlilik başlangıç tarihi olarak gelecektir. --->
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.assetcat_id") and len(attributes.assetcat_id)>
	<cfset url_str = "#url_str#&assetcat_id=#attributes.assetcat_id#">
</cfif>
<cfif isdefined("attributes.property_id") and len(attributes.property_id)>
	<cfset url_str = "#url_str#&property_id=#attributes.property_id#">
</cfif>
<cfif isdefined("attributes.list")>
	<cfset url_str = "#url_str#&list=#attributes.list#">
</cfif>
<cfif isdefined("attributes.record_date1")>
	<cfset url_str = "#url_str#&record_date1=#attributes.record_date1#">
</cfif>
<cfif isdefined("attributes.record_date2")>
	<cfset url_str = "#url_str#&record_date2=#attributes.record_date2#">
</cfif>
<cfif isdefined("attributes.record_member")>
	<cfset url_str = "#url_str#&record_member=#attributes.record_member#">
</cfif>
<cfif isdefined("attributes.record_par_id")>
	<cfset url_str = "#url_str#&record_par_id=#attributes.record_par_id#">
</cfif>
<cfif isdefined("attributes.record_emp_id")>
	<cfset url_str = "#url_str#&record_emp_id=#attributes.record_emp_id#">
</cfif>
<cfif isdefined("attributes.our_company_id")>
	<cfset url_str = "#url_str#&our_company_id=#attributes.our_company_id#">
</cfif>
<cfif isdefined("attributes.sort_type")>
	<cfset url_str = "#url_str#&sort_type=#attributes.sort_type#">
</cfif>
<cfif isdefined("attributes.format")>
	<cfset url_str = "#url_str#&format=#attributes.format#">
</cfif>
<cfif isdefined("attributes.is_active")>
	<cfset url_str = "#url_str#&is_active=#attributes.is_active#">
</cfif>
<cfif isdefined("attributes.process_stage")>
	<cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
</cfif>
<cfif len(attributes.project_head) and len(attributes.project_id)>
	<cfset url_str = "#url_str#&project_head=#attributes.project_head#&project_id=#attributes.project_id#">
</cfif>
<cfif len(attributes.product_id) and len(attributes.product_name)>
	<cfset url_str = "#url_str#&product_id=#attributes.product_id#&product_name=#attributes.product_name#">
</cfif>
<cfif isdefined("attributes.employee_view")>
	<cfset url_str = "#url_str#&employee_view=#attributes.employee_view#">
</cfif>
<cfif isdefined("attributes.is_internet")>
	<cfset url_str = "#url_str#&is_internet=#attributes.is_internet#">
</cfif>
<cfif isdefined("attributes.is_extranet")>
	<cfset url_str = "#url_str#&is_extranet=#attributes.is_extranet#">
</cfif>
<cfif isdefined("attributes.is_special")>
	<cfset url_str = "#url_str#&is_special=#attributes.is_special#">
</cfif>
<cfif isdefined("attributes.featured")>
	<cfset url_str = "#url_str#&featured=#attributes.featured#">
</cfif>
<cfset url_str = "#url_str#&x_show_by_digital_asset_group=#attributes.x_show_by_digital_asset_group#">
<cfset url_str = "#url_str#&x_dont_show_file_by_digital_asset_group=#attributes.x_dont_show_file_by_digital_asset_group#">
<cfif isdefined("attributes.record_date1") and isdate(attributes.record_date1)><cf_date tarih = "attributes.record_date1"></cfif>
<cfif isdefined("attributes.record_date2") and isdate(attributes.record_date2)><cf_date tarih = "attributes.record_date2"></cfif>
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
<!---
<cfquery name="GET_COMPANY_SITES" datasource="#DSN#">
	SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN IS NOT NULL ORDER BY SITE_DOMAIN
</cfquery>
--->
<cfinclude template="../query/get_asset_cats.cfm">
<cfinclude template="../query/get_assets.cfm">

<cfparam name="attributes.totalrecords" default="#GET_ASSETS.recordcount#">

<cfquery name="FORMAT" datasource="#dsn#">
	SELECT FORMAT_SYMBOL FROM SETUP_FILE_FORMAT ORDER BY FORMAT_SYMBOL
</cfquery>
<style>
	.pageMainLayout{padding:0;}
</style>
<cfif isDefined("attributes.asset_archive")>
	<cfoutput>	
		<script type="text/javascript">
			function sendAsset(file,path,desc,asset_name,size,property)
			{	  
				document.asset_archive.filename.value = file;
				document.asset_archive.filepath.value = path;
				document.asset_archive.filesize.value = size;
				document.asset_archive.property_id.value = property;								
				document.asset_archive.module_id.value = <cfif isdefined("attributes.module_id")>#attributes.module_id#<cfelse>''</cfif>;
				document.asset_archive.action_id.value = <cfif isdefined("attributes.action_id")>#attributes.action_id#<cfelse>''</cfif>;
				document.asset_archive.action_type.value = <cfif isdefined("attributes.action_type")>#attributes.action_type#<cfelse>0</cfif>;
				document.asset_archive.action_section.value = <cfif isdefined("attributes.action")>'#attributes.action#'<cfelse>''</cfif>;
				document.asset_archive.asset_cat_id.value = <cfif isdefined("attributes.asset_cat_id")>#attributes.asset_cat_id#<cfelse>''</cfif>;								
				document.asset_archive.asset_name.value = asset_name;				
				document.asset_archive.keyword.value = desc;		
				document.asset_archive.submit();			
			}
		</script>
		<form name="asset_archive" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_all_asset&asset_archive=true">
			<input type="hidden" name="filename" id="filename" value="">
			<input type="hidden" name="filepath" id="filepath" value="">
			<input type="hidden" name="filesize" id="filesize" value="">
			<input type="hidden" name="property_id" id="property_id" value="">				
			<input type="hidden" name="module_id" id="module_id" value="">
			<input type="hidden" name="action_id" id="action_id" value="">
			<input type="hidden" name="action_type" id="action_type" value="">
			<input type="hidden" name="action_section" id="action_section" value="">
			<input type="hidden" name="asset_cat_id" id="asset_cat_id" value="">
			<input type="hidden" name="asset_name" id="asset_name" value="">						
			<input type="hidden" name="keyword" id="keyword" value="">
			<input type="hidden" name="module" id="#attributes.module#">
		</form>
	</cfoutput>
</cfif>
<link rel="stylesheet" href="/css/assets/template/w3-intranet/intranet.css" type="text/css">
<script type="text/javascript" src="/JS/intranet.js"></script>
<cfinclude template="../../rules/display/rule_menu.cfm">
<cfset Assetcfc= createObject("component","V16.objects.cfc.get_ajax_asset_cat")>
<cfset GET_ASSET_CAT = Assetcfc.GetAssetCat( bottomCat: len(attributes.bottomCat) ? attributes.bottomCat : "" ) />  
<div class="wrapper" id="archive">
	<div class="search_group">    
		<cf_box>
			<cfform name="search_asset" id="search_asset" action="#request.self#?fuseaction=asset.list_asset" method="post">
				<input type="hidden" name="is_submit" id="is_submit" value="1">
				<input type="hidden" name="list_type" id="list_type" value="<cfif isdefined("attributes.list_type")><cfoutput>#attributes.list_type#</cfoutput></cfif>">
				<input type="hidden" name="listTypeElement" id="listTypeElement" value="<cfif isdefined("attributes.listTypeElement")><cfoutput>#attributes.listTypeElement#</cfoutput></cfif>">
				<input type="hidden" name="folderControl" id="folderControl" value="<cfif isdefined("attributes.folderControl")><cfoutput>#attributes.folderControl#</cfoutput></cfif>">
				<input type="hidden" name="bottomCat" id="bottomCat" value="<cfif isdefined("attributes.bottomCat")><cfoutput>#attributes.bottomCat#</cfoutput></cfif>">
				<cf_box_search id="list_asset" plus="0">
					<div class="blog_title" style="margin:5px;">
						<cfif attributes.fuseaction eq 'asset.list_asset'>
							<i class="wrk-uF0144"></i>
							<cf_get_lang dictionary_id='47626.Digital Archive'>
						<cfelseif attributes.fuseaction eq 'asset.tv'>
							<i class="wrk-uF0175"></i>
							<cf_get_lang dictionary_id='47626.Digital Archive'> - <cf_get_lang dictionary_id='58153.TV'>
						</cfif>
					</div>
					<div class="form-group xxxlarge" id="item-keyword">
						<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','What are you looking for?',54983)#">
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4" search_function='submitControl()'>
					</div>
					<div class="blog_title" style="margin:5px -5px;">
						<ul>
							<li id="type-folder-add"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_asset_cat','list');"> <i class="wrk-uF0137"></i><span><cf_get_lang dictionary_id="29481.Kategori Ekle"></span></a></li>
							<li><a href="<cfoutput>#request.self#?fuseaction=asset.list_asset&event=add<cfif isdefined('attributes.assetcat_id') and len(attributes.assetcat_id)>&asset_cat_id=#attributes.assetcat_id#</cfif></cfoutput>"><i class="wrk-uF0166"></i> <span><cf_get_lang dictionary_id='48868.Upload'></span></a></li>
							<li><a id="folder_layout" href="javascript://"><i class="wrk-uF0144"></i><span><cf_get_lang dictionary_id="52819.Klasör"></span></a></li>
							<li><a id="card_layout" href="javascript://"><i class="wrk-uF0081"></i><span><cf_get_lang dictionary_id="35463.Card"></span></a></li>
							<li><a id="table_layout" href="javascript://"><i class="wrk-uF0083"></i><span><cf_get_lang dictionary_id="57509.Liste"></span></a></li>
							<li><cfoutput><a href="javascript://"><i class="wrk-uF0095"></i> <cfif get_assets.QUERY_COUNT gt attributes.maxrows><cfelse>#get_assets.QUERY_COUNT#</cfif> / #get_assets.QUERY_COUNT#</a></cfoutput></li>
							<input type="hidden" name="baseUrl" value="<cfoutput>#request.self#</cfoutput>">
						</ul>
					</div>
				</cf_box_search>
				<cf_box_search_detail>
					<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-process_stage">
						<label><cf_get_lang dictionary_id='58859.Süreç'></label>
							<select name="process_stage" id="process_stage">
							<option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
							<cfoutput query="get_process_stage">
								<option value="#process_row_id#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq process_row_id)>selected</cfif> >#stage#</option>
							</cfoutput>
							<option value="" <cfif isdefined("attributes.process_stage") and (attributes.process_stage is 'null')>selected</cfif> ><cf_get_lang dictionary_id='29815.Aşamasız'></option>
						</select>
					</div>
					<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-format">
						<label><cf_get_lang dictionary_id='58594.Format'></label>
						<select name="format" id="format">
							<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
							<cfoutput query="format">
								<option value=".#format_symbol#"<cfif isdefined("attributes.format") and attributes.format is '.#format_symbol#'>selected</cfif>>#format_symbol#</option>
							</cfoutput>
							<option value="video"<cfif isdefined("attributes.format") and attributes.format is "video">selected</cfif>><cf_get_lang dictionary_id='46931.Video'></option>
						</select>
					</div>
					<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-maxrows">
						<label><cf_get_lang dictionary_id='58082.Adet'></label>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,999" maxlength="3" onKeyUp="isNumber(this)">
					</div>
					<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-project_head">
						<label><cf_get_lang dictionary_id='57416.Proje'></label>
						<div class="input-group">
							<input type="hidden" name="project_id" id="project_id" value="<cfif len(attributes.project_head)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
							<input type="text" name="project_head" id="project_head" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','125');" value="<cfoutput>#attributes.project_head#</cfoutput>" autocomplete="off">
							<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=frm_search.project_head&project_id=frm_search.project_id</cfoutput>');"></span>
						</div>
					</div>
					<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-property_id">
						<label><cf_get_lang dictionary_id='58067.Döküman Tipi'></label>
							<cfif not isdefined("attributes.property_id")><cfset attributes.property_id = ""></cfif>
							<cf_wrk_combo 
									name="property_id"
									query_name="GET_CONTENT_PROPERTY"
									value="#attributes.property_id#"
									option_name="name"
									option_value="content_property_id"
									width="250">
					</div>
					<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-project_head">
						<label><cf_get_lang dictionary_id='57899.Kaydeden'></label>
						<div class="input-group">
							<input type="hidden" name="record_par_id" id="record_par_id" value="<cfoutput>#attributes.record_par_id#</cfoutput>">
							<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfoutput>#attributes.record_emp_id#</cfoutput>">
							<cfinput type="text" name="record_member" value="#attributes.record_member#" onFocus="AutoComplete_Create('record_member','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0,0','PARTNER_ID,EMPLOYEE_ID','record_par_id,record_emp_id','search_asset','3','250');">
							<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_asset.record_emp_id&field_name=search_asset.record_member&field_partner=search_asset.record_par_id&select_list=1,2');"></span>
						</div>
					</div>
					<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-is_view">
						<label><cf_get_lang dictionary_id='29452.Varlık'> <cf_get_lang dictionary_id='30111.Durumu'></label>
						<select name="is_view" id="is_view">
							<option value=""><cf_get_lang dictionary_id='29452.Varlık'> <cf_get_lang dictionary_id='30111.Durumu'></option>
							<option value="1"<cfif isdefined("attributes.is_view") and (attributes.is_view eq 1)>selected</cfif>><cf_get_lang dictionary_id ='58079.İnternet'></option>
							<option value="0"<cfif isdefined("attributes.is_view") and (attributes.is_view eq 0)>selected</cfif>><cf_get_lang dictionary_id='47864.Normal'></option>
						</select>
					</div>
					<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-product_name">
						<label><cf_get_lang dictionary_id='57657.Ürün'></label>
						<div class="input-group">
							<input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_id) and len(attributes.product_name)> value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
							<input type="text" name="product_name" id="product_name" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','130');" value="<cfif len(attributes.product_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" autocomplete="off">
							<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=search_asset.product_id&field_name=search_asset.product_name&keyword='+encodeURIComponent(document.getElementById('product_name').value));"></span>
						</div>
					</div>
					<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-assetcat_id">
						<label><cf_get_lang dictionary_id='29536.Tüm Kategoriler'></label>
						<div class="input-group">
							<input type="hidden" name="assetcat_id" id="assetcat_id" <cfif len(attributes.assetcat_id) and len(attributes.assetcat_id)> value="<cfoutput>#attributes.assetcat_id#</cfoutput>"</cfif>>
							<input type="text" name="assetcat_name" id="assetcat_name" value="<cfoutput>#attributes.assetcat_name#</cfoutput>" onfocus="AutoComplete_Create('assetcat_name','ASSETCAT','ASSETCAT_PATH','get_asset_cat','0','ASSETCAT_ID','assetcat_id','','3','130');" autocomplete="off">
							<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_asset_cat&chooseCat=1&form_name=search_asset&field_id=assetcat_id&field_name=assetcat_name','list');"></span>			
						</div>
					</div>
					<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-our_company_id">
						<label><cf_get_lang dictionary_id='57574.Sirket'></label>
						<select name="our_company_id" id="our_company_id">
							<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
							<cfoutput query="get_position_companies">
								<option value="#our_company_id#" <cfif isdefined("attributes.our_company_id") and attributes.our_company_id eq our_company_id>selected</cfif>>#nick_name#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-record_date">
						<label><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12 pl">
							<div class="input-group">
								<cfinput type="text" name="record_date1" id="record_date1" value="#dateformat(attributes.record_date1,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getLang('','Kayıt Tarihini Kontrol Ediniz',47709)#!">
								<span class="input-group-addon"><cf_wrk_date_image date_field="record_date1"></span>
							</div>
						</div>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12 pr">
							<div class="input-group">
								<cfinput type="text" name="record_date2" id="record_date2" value="#dateformat(attributes.record_date2,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getLang('','Kayıt Tarihini Kontrol Ediniz',47709)#!">
								<span class="input-group-addon"><cf_wrk_date_image date_field="record_date2"></span>
							</div>
						</div>
					</div>
					<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-active">
						<input type="checkbox" name="is_active" id="is_active" value="1" <cfif isdefined("attributes.is_active")>checked</cfif>>
						<label><cfoutput>#getLang('main','Aktif',57493)#</cfoutput></label>
					</div>
			
					<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-is_special">
						<input type="checkbox" name="is_special" id="is_special" value="1" <cfif isdefined("attributes.is_special")>checked</cfif>>
						<label><cfoutput>#getLang('asset','Özel Belge',47857)#</cfoutput></label>
					</div>
			
					<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-featured">
						<input type="checkbox" name="featured" id="featured" value="1" <cfif isdefined("attributes.featured")>checked</cfif>>
						<label><cfoutput>#getLang('asset','Önem Derecesi Yüksek',47868)#</cfoutput></label>
					</div>
			
					<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-intranet">
						<input type="checkbox" name="employee_view" id="employee_view" value="1" <cfif isdefined("attributes.employee_view") and attributes.employee_view is 1>checked</cfif>>
						<label><cfoutput>#getLang('assetcare',352)#</cfoutput></label>
					</div>
			
					<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-internet">
						<input type="checkbox" name="is_internet" id="is_internet" value="1" <cfif isdefined("attributes.is_internet") and attributes.is_internet is 1>checked</cfif>>
						<label><cfoutput>#getLang('assetcare',364)#</cfoutput></label>
					</div>
			
					<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-extranet">
						<input type="checkbox" name="is_extranet" id="is_extranet" value="1" <cfif isdefined("attributes.is_extranet") and attributes.is_extranet is 1>checked</cfif>>
						<label><cfoutput>#getLang('assetcare',365)#</cfoutput></label>
					</div>	
					
					<div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-extranet">
						<input type="checkbox" name="is_revision" id="is_revision" value="1" <cfif isdefined("attributes.is_revision") and attributes.is_revision is 1>checked</cfif>>
						<label><cf_get_lang dictionary_id='60393.Revizyon Olanları Getirme'></label>
					</div>
				</cf_box_search_detail>
			</cfform>
		</cf_box>
	</div>
		
		<div id="folder_list" class="archive_list"></div>
		<div class="archive_list">
			<cfif len(attributes.bottomCat)>
				<div class="ui-row">
					<cfoutput query = "GET_ASSET_CAT">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<div id="cat_#ASSETCAT_ID#" class="folder_item">
								<cfset get_asset_cat_file = Assetcfc.get_asset_cat_file( assetcat_id: ASSETCAT_ID ) /> 
								<div class="folder_item_text">
									<a href="javascript://" onclick="chooseCat(#ASSETCAT_ID#,'#ASSETCAT#')"><i class="wrk-uF0144"></i> #ASSETCAT#</a>
								</div>
								<div class="folder_item_size">
									<ul>
										<li>
											<a href="javascript://">#get_asset_cat_file.ASSET_NO_COUNT#/<cfif len(get_asset_cat_file.SUM_FILE_SIZE)>#get_asset_cat_file.SUM_FILE_SIZE#<cfelse>0</cfif> KB</a>
										</li>
										<!--- <li>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_add_asset_cat&mainCat=#ASSETCAT_ID#&mainCatName=#ASSETCAT#','list');"><i class="wrk-uF0158"></i></a>
										</li>
										<li>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_upd_asset_cat&ID=#ASSETCAT_ID#&mainCatName=#ASSETCAT#','list');"><i class="wrk-uF0221"></i></a>
										</li> --->
									</ul>
								</div>
							</div>
						</div>
					</cfoutput>
				</div>
			</cfif>
			<cfif get_assets.recordcount neq 0 >
				<cfinclude template="list.cfm">
			<cfelse>
				<cf_box>
					<div class="ui-info-bottom">
						<cf_get_lang dictionary_id='57484.No record'>
					</div>
				</cf_box>
			</cfif>			  
		</div>
	
</div>
	<input type="hidden" name="dataCount" value="<cfoutput>#attributes.maxrows + 1#</cfoutput>"> 

<script type="text/javascript">

	$(function(){
		$('#table_layout').click(function(){
			$('#type-box').fadeOut();
			$('#type-folder').fadeOut();
			$('#type-list').fadeIn();
		})
		$('#card_layout').click(function(){
			$('#type-list').fadeOut();
			$('#type-folder').fadeOut();
			$('#type-box').fadeIn();
		})
		$('#folder_layout').click(function(){
			<cfif isdefined("attributes.assetcat_id") and len(attributes.assetcat_id)>
				document.search_asset.assetcat_name.value ='';
				document.search_asset.assetcat_id.value = '';
				document.search_asset.bottomCat.value = '';
				document.search_asset.folderControl.value = 1;
				document.search_asset.submit();
				$('#type-folder').fadeIn();
			</cfif>
			$('#type-list').fadeOut();
			$('#type-box').fadeOut();
			$('#type-paging').fadeOut();
			$('#type-folder').fadeIn();
			$('#type-folder-add').fadeIn();
			
		})
		<cfif len(attributes.folderControl)>
			$('#type-list').fadeOut();
			$('#type-box').fadeOut();
			$('#type-paging').fadeOut();
			$('#type-folder').fadeIn();
			$('#type-folder-add').fadeIn();
		</cfif>
		<cfif attributes.listTypeElement eq 'list'>
			$('#type-box').fadeOut();
			$('#type-folder').fadeOut();
			$('#type-list').fadeIn();
		</cfif>
	})


	function chooseCat(assetCat_id,assetCat_name){
		document.search_asset.assetcat_name.value = assetCat_name;
		document.search_asset.assetcat_id.value = assetCat_id;
		document.search_asset.bottomCat.value = assetCat_id;
		document.search_asset.folderControl.value = '';
		document.search_asset.submit();
	}

	function submitControl(){

		if(document.getElementById('maxrows').value == "" || document.getElementById('maxrows').value <= 0){
			alertObject({message:"<cfoutput>#getLang('main',125)#</cfoutput>"});
			return false;
		}

		date1 = document.getElementById('record_date1');
		date2 = document.getElementById('record_date2');
		if(date1.value != "" || date2.value != ""){
			
			if(date_check(date1,date2,"<cfoutput>#getLang('asset',96)#</cfoutput>",1)) return true;
			else return false;

		}
		
		return true;
	}

$(function(){
	
	///Modal panel yüksekliğini çözünürlüğe göre ayarlar
	function modalPanelHeight(){

		var screenWidth = $(window).width();
		
		if(screenWidth <= 415){
			
			var screenHeight = $(window).height();
			var pageHeader = $(".page-header").height();
			var bottomControlPanel = $(".mbl-button-panel").height();
			var modalHeight = screenHeight - pageHeader - bottomControlPanel;
			$(".wrk-modal-panel").height(modalHeight);

		}else{

			$(".wrk-modal-panel").css({"height":"auto"});

		}

	}

	modalPanelHeight();

	$(window).resize(function(){
		modalPanelHeight();
	});

	///last upd : 29.09.2018
	///description: Aşağı scroll işlemi sonrasında 'list_asset_ajax' sayfasına giderek json verileri alır ve tasarıma giydirir.

	var page = 2;//sayfalama işlemine göre sıradaki sayfa numarası
	var maxrows = $("input[name = maxrows]").val();
	var oldHeight = 0;
	var url = "";
	var _complete = 0, _on = 0;
	var pageEnd = false;
	var message = "";

	///Veri çekme ve giydirme
	function dataTemplate(){

		url = 'V16/objects/display/list_asset_ajax.cfm?<cfoutput>#url_str#&fuseaction=#attributes.fuseaction#&page='+page+'&maxrows='+maxrows+'</cfoutput>';
		
		function incr(){ 
			_on++;
			document.getElementById("loading-area").innerHTML = '<div id="divPageLoad"><?xml version="1.0" encoding="utf-8"?><svg width="32px" height="32px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" preserveAspectRatio="xMidYMid" class="uil-ring-alt"><rect x="0" y="0" width="100" height="100" fill="none" class="bk"></rect><circle cx="50" cy="50" r="40" stroke="rgba(255,255,255,0)" fill="none" stroke-width="10" stroke-linecap="round"></circle><circle cx="50" cy="50" r="40" stroke="#ff8a00" fill="none" stroke-width="6" stroke-linecap="round"><animate attributeName="stroke-dashoffset" dur="2s" repeatCount="indefinite" from="0" to="502"></animate><animate attributeName="stroke-dasharray" dur="2s" repeatCount="indefinite" values="150.6 100.4;1 250;150.6 100.4"></animate></circle></svg></div>';
			oldHeight = document.documentElement.scrollHeight - document.documentElement.clientHeight;
		}
		function comp(){ 
			_complete++; 
			if(_complete==_on) document.getElementById("loading-area").innerHTML = '<div class="showMoreButton"><cfoutput>#getLang('assetcare',513)#</cfoutput></div>';

		}

		if(!pageEnd){
			myRatingSubmit();
			incr();
		}else{
			document.getElementById("loading-area").innerHTML = '<div class="pageEnd">'+message+'</div>';
		}
		var dataCounter = $("input[name = dataCount]").val(); // Ekranda basılı olan toplam veriyi sayar.

		function writeContent(responseData){//Scroll işlemi sonrası json olarak dönen verilerin tasarıma giydirilmesi //responseData -> JSON
			
			var totalColumns = 12;
			var halfColumns = 6;
			var quarterColumns = 4;
			var box = ".box-list";
			var listDiv = (listType == "changeColumn") ? $("#type-box") : $("#type-list"); //listeleme alanı alındı
			var listType = $("li.lst-active").attr("type");	//Seçili olan listeleme tipi alındı.
			var listTypeElement = $("li.lst-active").attr("list-type"); //Seçili olan listeleme türü alındı //folder, list, box
			var columnCount = $("li.lst-active").attr("column-count");	//Listeleme tipi box ise yanyana görülecek kolon sayısı alındı.
			var columnClassNumber = totalColumns / columnCount;
			var columnClass = "col col-" + columnClassNumber + " col-md-" + quarterColumns + " col-sm-" + halfColumns + " col-xs-" + totalColumns;
			var boxType = "box-list-small";
			var ImageContentType = "box-list-image-small";

			if(columnCount == 4 || listTypeElement == "folder"){
				boxType = "box-list-small";
				ImageContentType = "box-list-image-small";
			}
			else if(columnCount == 3){
				boxType = "box-list-big";
				ImageContentType = "box-list-image-big";
			}
			
			for(var i = 0; i < (responseData.length); i++){//Json tipindeki veriyi sırasıyla işleme sokar.
				
				//Hem kutular için hem de liste için yüklenmesi gerekir. Aksi durumda listeleme tipi değişimlerinde önceki listeleme tipi alanına veri yüklenmez.
				fncBoxContent();
				fncListContent();
				//Kutular için tasarım oluşturur.
				function fncBoxContent(){
					
					var showFile; //Dosyanın video, ses ya da fotoğraf olma durumuna göre video, ses ya da img etiketini kurar.
					
					if(responseData[i].FILE.FILETYPE == "video"){
						showFile = $("<video>")
										.attr({
											"src"			:	responseData[i].FILE.IMAGE,
											"width"			:	"100%",
											"controls"		:	"",
											"controlsList"	:	"nodownload",
											"type"			:	responseData[i].FILE.MIMETYPE
										});
					}else if(responseData[i].FILE.FILETYPE == "audio"){
						
						showFile = $("<audio>")
										.attr({
											"src"			:	responseData[i].FILE.IMAGE,
											"controls"		:	"",
											"controlsList"	:	"nodownload",
											"type"			:	responseData[i].FILE.MIMETYPE
										})
										.css({
											"width" : "250px"
										});

					}else if(responseData[i].FILE.FILETYPE == "embed"){
						showFile = $("<span>").html(responseData[i].FILE.IMAGE)
					}

					else{
						
						
						//Fotoğraf ikon değilse fotoğrafa büyük gösterim için tıklama özelliği verir.
						if(responseData[i].ICON){
							
							showFile = $("<img>")
													.attr({
														"src"		:	responseData[i].FILE.IMAGE,
														"style"		:	(responseData[i].ICON) ? 'margin: 20px; width:70px' : ''
													});

						}else{
							
							if(responseData[i].FILE.FILEPATH.includes('youtube.com') || responseData[i].FILE.FILEPATH.includes('loom.com') || responseData[i].FILE.FILEPATH.includes('vimeo')){
								var play = $("<a>")
												.attr({
													"href"		:	responseData[i].FILE.FILEPATH,
													"target"	:	"_blank",
													"class"		:	"ui-cards-img-play"
												})
												.append(
													$("<i>")
														.attr({
															"class"		:	"fa fa-youtube-play play-icon"
														})
												);
							}
								
							showFile = $("<a>")
											.attr({
												"href"		:	"javascript://",
												"onclick"	:	"windowopen('"+responseData[i].FILE.FILEPATH+"','"+responseData[i].FILE.FILEPOPTYPE+"')"
											})
											.append(
												$("<img>")
													.attr({
														"src"		:	responseData[i].FILE.IMAGE
													})
											);
						}
						
					}
					var kolon = $("<div>");
						kolon.addClass("col col-3 col-md-4 col-sm-6 col-xs-12");

					var kolon_wrapper = $("<div>");
						kolon_wrapper.addClass("archive_list_item");

					var kolon_img = $("<div>");
						kolon_img.addClass("archive_list_item_image");
						if(play)
							kolon_img.append(play);
						kolon_img.append(showFile);	

					var kolon_text = $("<div>");
						kolon_text.addClass("archive_list_item_text");

					var kolon_text_top = $("<div>");
						kolon_text_top.addClass("archive_list_item_text_top");
						kolon_text_top.append("<a href='<cfoutput>#request.self#</cfoutput>?fuseaction=asset.list_asset&event=upd&asset_id="+responseData[i].ASSETID+"&assetcat_id="+responseData[i].ASSETCATID+"'>"+responseData[i].FILE.ASSET_NAME+"</a>");


					var kolon_text_bottom = $("<div>");
						kolon_text_bottom.addClass("archive_list_item_text_bottom");	

						var kolon_text_bottom_list = $("<ul>");
							kolon_text_bottom_list.append("<li><i class='fa fa-calendar-o'></i>"+responseData[i].DATE+"</li><li><i class='fa fa-folder-o'></i>"+responseData[i].FILE.FILESIZE+"</li><li><i class='fa fa-user-o'></i>"+responseData[i].USER.USERNAME+"<br></li><li><a target='_blank' href='"+responseData[i].FILE.FILEPATH+"','"+responseData[i].FILE.FILEPOPTYPE+"'>"+responseData[i].FILE_ICON+"</a></li>");
					
					kolon_text_bottom.append(kolon_text_bottom_list);

					kolon_text.append(kolon_text_top);
					kolon_text.append(kolon_text_bottom);

					kolon_wrapper.append(kolon_img);
					kolon_wrapper.append(kolon_text);

					kolon.append(kolon_wrapper);

					$("#type-box-content").append(kolon);	

				}
				//Liste için tasarım oluşturur.
				function fncListContent(){

					$("<tr>")
					.append(
							$("<td>")
								.html(dataCounter++),
							$("<td>")
								.append(
									$("<a>")
										.attr({

											"href"		:	"javascript://",
											"onclick"	:	"windowopen('"+responseData[i].FILE.FILEPATH+"','"+responseData[i].FILE.FILEPOPTYPE+"')"
											
										})
										.append(
											$("<i>")
												.addClass("catalyst-cloud-download")
												.attr({
													"title"	:	"<cfoutput>#getLang('asset',6)#</cfoutput>"
												})
										)
								),
							$("<td>") 
								.html(responseData[i].ASSETNO),
							$("<td>")
								.append(
									$("<a>")
										
										.attr({
											"href"		:	"javascript://",
											"onclick"	:	"windowopen('"+responseData[i].FILE.FILEPATH+"','"+responseData[i].FILE.FILEPOPTYPE+"')",
										})
										.html(responseData[i].FILE.ASSET_NAME)
								),
							$("<td>")
								.html(responseData[i].ASSETCAT),
							$("<td>")
								.html(responseData[i].DOCTYPE),
							$("<td>")
								.html(responseData[i].VALIDITY_DATE),
							$("<td>")
								.html(responseData[i].REVISION_DATE),
							$("<td>")
								.html("." + responseData[i].FILE.EXT.toUpperCase() + " (" + responseData[i].FILE.FILESIZE + ")"),
							$("<td>")
								.append(
									$("<a>")
										
										.attr({
											"href"		:	"javascript://",
											"onclick"	:	"nModal({head:	'Profil',page:'"+responseData[i].USER.USERLINK+"'})"
										})
										.html(responseData[i].USER.USERNAME)				
								),
							$("<td>")
								.html(responseData[i].DATE),
							$("<td>")
								.append(
									$("<a>")
										.attr({
											"href"		:	"<cfoutput>#request.self#</cfoutput>?fuseaction=asset.list_asset&event=upd&asset_id="+responseData[i].ASSETID+"&assetcat_id="+responseData[i].ASSETCATID+""
										})
										.append(
											$("<i>")
											.addClass("fa fa-cube")	
										)
								)
								
					)
					.appendTo($("#type-list #assetList"));

				}

				$("input[name = dataCount]").val(dataCounter);
				$("ul.button-panel li.paging span").text(dataCounter-1);

			}
			
		}

		//Ajax bağlantısı ve veri isteme işlemi (Request)
		var ajaxConn;
		function myRatingResult() {
			if (ajaxConn.readyState == 4 && ajaxConn.status == 200)
			{
				var response = JSON.parse(ajaxConn.responseText);
				if(response.MESSAGE) 
				{
					pageEnd = true;
					message = response.MESSAGE;
				}
				if(!pageEnd){

					comp();
					writeContent(response);

				}else{
					
					document.getElementById("loading-area").innerHTML = '<div class="ui-row"><div class="col col-12"><div class="pageEnd">'+message+'</div></div></div>';

				}
				
			}
		}
		function myRatingSubmit() {
			
			ajaxConn = GetAjaxConnector();
			AjaxRequest(ajaxConn, url, 'GET', '', myRatingResult);
			return false;
			
		}
		
		page++;

	}
	
	//Daha fazla göster butonu tıklama sonrasında yapılacaklar.
	$(".loading-area").delegate("div.showMoreButton","click",function(){
		dataTemplate();
	});

	//Aşağı scroll işlemi sonrasında yapılacaklar.
	window.onscroll = function(){
		
		var winScroll = document.body.scrollTop || document.documentElement.scrollTop;
		var height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
    	
		if((winScroll == height) && (oldHeight != height)){
				
				dataTemplate();
				
		}
		
	}
	
	$.intranet.changeListType(); //listeleme tipini değiştirme.
	$.intranet.openModal();	//Yükleme ya da arama butonlarına tıklandığında modalların açılması.
	$.intranet.justClick();	//Modallar ve butonlar dışında sayfanın herhangi bir yerine tıklandığında modalların kapanması.
				
});
function getBottomCat(catid,element,form,chooseCat){
	
	form = "";
   
   chooseCat = "";
   var url = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.ajax_get_asset_cat&bottomCat="+catid;
   if($(element).hasClass("fa-caret-right")){
	   $(element).removeClass("fa-caret-right").addClass("fa-caret-down");
	   $("<div>").addClass("col col-12").attr({"id":"catbottom_"+catid+""}).appendTo("#cat_"+catid);
	   AjaxPageLoad(url,"catbottom_"+catid+"");
   }else {
	   $(element).removeClass("fa-caret-down").addClass("fa-caret-right");
	   $("div#catbottom_"+catid+"").remove();
   }
}
/* When the user clicks on the button, 
toggle between hiding and showing the dropdown content */
function dropFunction(dropid) {
   document.getElementById(dropid).classList.toggle("cat-dropDown-show");
}

// Close the dropdown if the user clicks outside of it
window.onclick = function(event) {
   if (!event.target.matches('.dropbtn')) {
	   var dropdowns = document.getElementsByClassName("cat-dropdown-content");
	   var i;
	   for (i = 0; i < dropdowns.length; i++) {
		   var openDropdown = dropdowns[i];
		   if (openDropdown.classList.contains('cat-dropDown-show')) {
			   openDropdown.classList.remove('cat-dropDown-show');
		   }
	   }
   }
}
    
</script>