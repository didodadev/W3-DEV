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
<cfif isdefined("attributes.assetcat_name") and len(attributes.assetcat_name)>
	<cfset url_str = "#url_str#&assetcat_name=#attributes.assetcat_name#">
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
<cfinclude template="../../asset/query/get_asset_cats.cfm">
<cfinclude template="../../asset/query/get_assets.cfm">

<cfparam name="attributes.totalrecords" default="#GET_ASSETS.recordcount#">
<cfquery name="FORMAT" datasource="#dsn#">
	SELECT FORMAT_SYMBOL FROM SETUP_FILE_FORMAT ORDER BY FORMAT_SYMBOL
</cfquery>
<cfform name="search_asset_tv" id="search_asset_tv" action="#request.self#?fuseaction=asset.tv" method="post">
    <input type="hidden" name="is_submit" id="is_submit" value="1">
    <input type="hidden" name="list_type" id="list_type" value="<cfif isdefined("attributes.list_type")><cfoutput>#attributes.list_type#</cfoutput></cfif>">
    <input type="hidden" name="listTypeElement" id="listTypeElement" value="<cfif isdefined("attributes.listTypeElement")><cfoutput>#attributes.listTypeElement#</cfoutput></cfif>">
    <input type="hidden" name="folderControl" id="folderControl" value="<cfif isdefined("attributes.folderControl")><cfoutput>#attributes.folderControl#</cfoutput></cfif>">
    <input type="hidden" name="bottomCat" id="bottomCat" value="<cfif isdefined("attributes.bottomCat")><cfoutput>#attributes.bottomCat#</cfoutput></cfif>">
    <cf_box_search id="list_asset_tv" btn_id="asset_tv_btn" extra="1">
        <div class="form-group xxxlarge" id="item-keyword">
            <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','What are you looking for?',54983)#">
        </div>
        <div class="form-group" id="asset_tv_btn">
            <cf_wrk_search_button button_type="4" search_function='submitControl()'>
        </div>
        <div class="form-group">
            <a href="<cfoutput>#request.self#?fuseaction=asset.list_asset&event=add</cfoutput>" class="ui-btn ui-btn-gray"><i class="fa fa-plus"></i></a>
        </div>
    </cf_box_search>
    <cf_box_search_detail id="list_asset_tv_search_detail">
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
                <cfinput type="text" name="record_member" value="#attributes.record_member#" onFocus="AutoComplete_Create('record_member','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0,0','PARTNER_ID,EMPLOYEE_ID','record_par_id,record_emp_id','search_asset_tv','3','250');">
                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_asset_tv.record_emp_id&field_name=search_asset_tv.record_member&field_partner=search_asset_tv.record_par_id&select_list=1,2');"></span>
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
                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=search_asset_tv.product_id&field_name=search_asset_tv.product_name&keyword='+encodeURIComponent(document.getElementById('product_name').value));"></span>
            </div>
        </div>
        <div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12" id="item-assetcat_id">
            <label><cf_get_lang dictionary_id='29536.Tüm Kategoriler'></label>
            <div class="input-group">
                <input type="hidden" name="assetcat_id" id="assetcat_id" <cfif len(attributes.assetcat_id) and len(attributes.assetcat_id)> value="<cfoutput>#attributes.assetcat_id#</cfoutput>"</cfif>>
                <input type="text" name="assetcat_name" id="assetcat_name" value="<cfoutput>#attributes.assetcat_name#</cfoutput>" onfocus="AutoComplete_Create('assetcat_name','ASSETCAT','ASSETCAT_PATH','get_asset_cat','0','ASSETCAT_ID','assetcat_id','','3','130');" autocomplete="off">
                <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_asset_cat&chooseCat=1&form_name=search_asset_tv&field_id=assetcat_id&field_name=assetcat_name','list');"></span>			
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
<script>
    function submitControl(){

        if(document.getElementById('maxrows').value == "" || document.getElementById('maxrows').value <= 0){
            alertObject({message:"<cfoutput>#getLang('main','Kayıt Sayısı Hatalı!',57537)#</cfoutput>"});
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
</script>