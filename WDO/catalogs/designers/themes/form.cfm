<link rel="stylesheet" href="/css/assets/template/workdev/animate.css">
<link rel="stylesheet" href="/css/assets/template/workdev/workdev.min.css">
<link rel="stylesheet" type="text/css" href="JS/assets/lib/slick/slick.css"/>
<link rel="stylesheet" type="text/css" href="JS/assets/lib/slick/slick-theme.css"/>

<script type="text/javascript" src="JS/assets/lib/slick/slick.min.js"></script>

<cfif attributes.mode eq "upd">
    <cfset theme_query = get_theme( attributes.id )>
</cfif>

<cfquery name="GET_SECTOR_CATS" datasource="#dsn#">
	SELECT * FROM SETUP_SECTOR_CATS ORDER BY SECTOR_CAT
</cfquery>


<cf_catalystHeader>
<cf_box title="Theme" id="theme" closable="0">
    <cfform name="ThemeForm" id="ThemeForm" method="post" action="">
        <cfinput type="hidden" name="mode" value="save">
        <cfif attributes.mode eq "upd"><cfinput type="hidden" name="id" value="#attributes.id#"></cfif>
        <div class="row">
            <div class="col col-4 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-name">
                    <label class="col col-4 col-xs-12">Tema Adı*</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput><input type="text" name="theme_name" id="theme_name" value="#iif(isDefined("theme_query"), "theme_query.theme_NAME", DE(''))#" required></cfoutput>
                    </div>
                </div>
                <div class="form-group" id="item-authorid">
                    <label class="col col-4 col-xs-12">Author / Partner ID *</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput><input type="text" name="authorid" id="theme_authorid" value="#iif(isDefined("theme_query"), "theme_query.theme_AUTHORID", DE(''))#" required></cfoutput>
                    </div>
                </div>
                <div class="form-group" id="item-author">
                    <label class="col col-4 col-xs-12">Author / Partner Name *</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput><input type="text" name="author" id="theme_author" value="#iif(isDefined("theme_query"), "theme_query.theme_AUTHOR", DE(''))#" required></cfoutput>
                    </div>
                </div>
                <div class="form-group" id="item-product">
                    <label class="col col-4 col-xs-12">Workcube Product ID *</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput><input type="text" name="product_id" id="product_id" value="#iif(isDefined("theme_query") and isdefined("theme_query.theme_PRODUCT_ID"), "theme_query.theme_PRODUCT_ID", DE(''))#" required></cfoutput>
                    </div>
                </div>
                <div class="form-group"  id="item-file_path">
                    <label class="col col-4 col-xs-12">File Path</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfoutput><input type="text" name="file_path" id="file_path" value="#iif(isDefined("theme_query") and isdefined("theme_query.theme_FILE_PATH"), "theme_query.theme_FILE_PATH", DE(''))#"></cfoutput>
                            <span class="input-group-addon icon-search" onclick="getWPTComponent()" style="cursor:pointer;"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-licensetype">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42197.Lisans'>*</label>
                    <div class="col col-8 col-xs-12">
                        <cfset licensetype_defaultValue = iif(isDefined("theme_query"), "theme_query.theme_LICENSE", DE(''))>
                        <select name="license" id="theme_license" required>
                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                            <option value="1" <cfoutput>#iif(licensetype_defaultValue eq "1",de('selected'),de(''))#</cfoutput>>Standart</option>
                            <option value="2" <cfoutput>#iif(licensetype_defaultValue eq "2",de('selected'),de(''))#</cfoutput>>Add-On</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="col col-4 col-xs-12" type="column" index="2" sort="true">                       
                <div class="form-group" id="item-stage">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id = '57493.Aktif'></label>
                    <div class="col col-8 col-xs-12">
                        <input type="checkbox" name="is_active" id="is_active" value="1" <cfoutput>#iif((isDefined("theme_query") and isdefined("theme_query.theme_IS_ACTIVE") and len(theme_query.theme_IS_ACTIVE) and theme_query.theme_IS_ACTIVE), DE('checked'), DE(''))#</cfoutput>>
                    </div>
                </div>
                <div class="form-group" id="item-stage">
                    <label class="col col-4 col-xs-12">Stage*</label>
                    <div class="col col-8 col-xs-12">
                        <cf_workcube_process is_upd='0' process_stage="#iif((isDefined("theme_query")) and isdefined("theme_query.theme_STAGE"), "theme_query.theme_STAGE", DE(''))#" process_cat_width='150' is_detail="0" fusepath="dev.themes">
                    </div>
                </div>
                <div class="form-group" id="item-sector_cats">
                    <label class="col col-4"><cf_get_lang_main no='167.Sektör'>*</label>
                    <div class="col col-8">
                        <select name="sector_cats" id="sector_cats" multiple required>
                            <cfoutput query="get_sector_cats">
                                <option value="#sector_cat_id#" #iif((isDefined("theme_query") and isdefined("theme_query.theme_SECTORS") and ListContains(theme_query.theme_SECTORS,sector_cat_id)), DE('selected'), DE(''))#>#sector_cat#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-PREVIEW_PATH">
                    <label class="col col-4 col-xs-12">Previw Path *</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput><input type="text" name="PREVIEW_PATH" id="PREVIEW_PATH" value="#iif(isDefined("theme_query") and isdefined("theme_query.theme_PREVIEW_PATH"), "theme_query.theme_PREVIEW_PATH", DE(''))#" required></cfoutput>
                    </div>
                </div>
                <div class="form-group" id="item-workcube_product_code">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52102.Kodu'>*</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput><input type="text" name="workcube_product_code" id="theme_workcube_product_code" value="#iif(isDefined("theme_query") and isdefined("theme_query.theme_PRODUCT_CODE"), "theme_query.theme_PRODUCT_CODE", DE(''))#" required></cfoutput>
                    </div>
                </div>
                <div class="form-group" id="item-publish_date">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31639.Yayın Tarihi'>*</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="text" name="publish_date" id="publish_date" maxlength="10" value="<cfoutput>#iif((isDefined("theme_query") and isdefined("theme_query.theme_PUBLISH_DATE")and len(theme_query.theme_PUBLISH_DATE)), "dateformat(theme_query.theme_PUBLISH_DATE,dateformat_style)", DE(''))#</cfoutput>" required>
                            <span class="input-group-addon"><cf_wrk_date_image date_field="publish_date"></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-12 col-xs-12 mt-4">
                <div class="catalyst-seperator"><label onclick="slideBoxToggle(this)"><i class="icon-angle-right"></i> Detail</label></div>
                <div class="col col-12">
                    <div class="form-group" id="item-bpdetail">
                        <div class="col col-12 col-xs-12">
                            <cfmodule template="/fckeditor/fckeditor.cfm"
                            toolbarset="Basic"
                            basepath="/fckeditor/"
                            instancename="bpdetail"
                            valign="top"
                            value="#iif(isDefined("theme_query"), "theme_query.theme_DETAIL", DE(''))#"
                            width="100%"
                            height="180">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row formContentFooter">
            <div class="col col-12">
                <cfif isdefined("theme_query")>
                    <cf_record_info
                    query_name="theme_query"
                    record_emp="record_emp" 
                    record_date="record_date"
                    update_emp="update_emp"
                    update_date="update_date">
                    <cf_workcube_buttons is_upd='1' is_delete="0">
                <cfelse>
                    <cf_workcube_buttons is_upd='0'>
                </cfif>
            </div>            
        </div>
    </cfform>
</cf_box>
<cf_box title="#getLang('','',48653)#" id="theme_components" closable="0" box_page="#(isDefined('theme_query') and isdefined("theme_query.theme_FILE_PATH") and len(theme_query.theme_FILE_PATH)) ? 'index.cfm?fuseaction=dev.themes&mode=get&method=get_theme_component&file_path=' & Replace(theme_query.theme_FILE_PATH, "\", "/") : ''#" add_href="#(isDefined('theme_query') and not len(theme_query.theme_FILE_PATH)) ? 'javascript:addComponentFile()' : ''#">
</cf_box>

<script type="text/javascript">

    function getWPTComponent(){
        let file_path = $('input[name = file_path]').val().replace('\\', '/');
        if( file_path != '' ) AjaxPageLoad('index.cfm?fuseaction=dev.themes&mode=get&method=get_theme_component&file_path=' + file_path, 'body_theme_components');
    }

    <cfif isDefined('theme_query')>
    function addComponentFile() {
        cfmodal('<cfoutput>#request.self#</cfoutput>?fuseaction=dev.themes&mode=get&method=get_add_component_form&id=<cfoutput>#attributes.id#</cfoutput>', 'warning_modal')
    }
    </cfif>
    
</script>