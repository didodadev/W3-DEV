<link rel="stylesheet" href="/css/assets/template/workdev/animate.css">
<link rel="stylesheet" href="/css/assets/template/workdev/workdev.min.css">

<cfif attributes.mode eq "upd">
    <cfset bestpractice_query = get_bp( attributes.id )>
</cfif>

<cfquery name="GET_SECTOR_CATS" datasource="#dsn#">
	SELECT * FROM SETUP_SECTOR_CATS ORDER BY SECTOR_CAT
</cfquery>
<cf_catalystHeader>
<cf_box title="Best Practice" id="best_practice" closable="0">
    <cfform name="BPForm" id="BPForm" method="post" action="">
        <cfinput type="hidden" name="mode" value="save">
        <cfif attributes.mode eq "upd"><cfinput type="hidden" name="id" value="#attributes.id#"></cfif>
        <div class="row">
            <div class="col col-4 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-bpname">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51038.Best Practice'>*</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput><input type="text" name="bpname" id="bestpractice_bpname" value="#iif(isDefined("bestpractice_query"), "bestpractice_query.BESTPRACTICE_NAME", DE(''))#" required></cfoutput>
                    </div>
                </div>
                <div class="form-group" id="item-authorid">
                    <label class="col col-4 col-xs-12">Author / Partner ID *</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput><input type="text" name="authorid" id="bestpractice_authorid" value="#iif(isDefined("bestpractice_query"), "bestpractice_query.BESTPRACTICE_AUTHORID", DE(''))#" required></cfoutput>
                    </div>
                </div>
                <div class="form-group" id="item-author">
                    <label class="col col-4 col-xs-12">Author / Partner Name *</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput><input type="text" name="author" id="bestpractice_author" value="#iif(isDefined("bestpractice_query"), "bestpractice_query.BESTPRACTICE_AUTHOR", DE(''))#" required></cfoutput>
                    </div>
                </div>
                <div class="form-group" id="item-product">
                    <label class="col col-4 col-xs-12">Workcube Product ID *</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput><input type="text" name="product_id" id="product_id" value="#iif(isDefined("bestpractice_query") and isdefined("bestpractice_query.BESTPRACTICE_PRODUCT_ID"), "bestpractice_query.BESTPRACTICE_PRODUCT_ID", DE(''))#" required></cfoutput>
                    </div>
                </div>
                <div class="form-group"  id="item-file_path">
                    <label class="col col-4 col-xs-12">File Path</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfoutput><input type="text" name="file_path" id="file_path" value="#iif(isDefined("bestpractice_query") and isdefined("bestpractice_query.BESTPRACTICE_FILE_PATH"), "bestpractice_query.BESTPRACTICE_FILE_PATH", DE(''))#"></cfoutput>
                            <span class="input-group-addon icon-search" onclick="getBpComponent()" style="cursor:pointer;"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-licensetype">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42197.Lisans'>*</label>
                    <div class="col col-8 col-xs-12">
                        <cfset licensetype_defaultValue = iif(isDefined("bestpractice_query"), "bestpractice_query.BESTPRACTICE_LICENSE", DE(''))>
                        <select name="license" id="bestpractice_license" required>
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
                        <input type="checkbox" name="is_active" id="is_active" value="1" <cfoutput>#iif((isDefined("bestpractice_query") and isdefined("bestpractice_query.BESTPRACTICE_IS_ACTIVE") and len(bestpractice_query.BESTPRACTICE_IS_ACTIVE) and bestpractice_query.BESTPRACTICE_IS_ACTIVE), DE('checked'), DE(''))#</cfoutput>>
                    </div>
                </div>
                <div class="form-group" id="item-stage">
                    <label class="col col-4 col-xs-12">Stage*</label>
                    <div class="col col-8 col-xs-12">
                        <cf_workcube_process is_upd='0' process_stage="#iif((isDefined("bestpractice_query")) and isdefined("bestpractice_query.BESTPRACTICE_STAGE"), "bestpractice_query.BESTPRACTICE_STAGE", DE(''))#" process_cat_width='150' is_detail="0" fusepath="dev.bestpractice">
                    </div>
                </div>
                <div class="form-group" id="item-sector_cats">
                    <label class="col col-4"><cf_get_lang_main no='167.Sektör'>*</label>
                    <div class="col col-8">
                        <select name="sector_cats" id="sector_cats" multiple required>
                            <cfoutput query="get_sector_cats">
                                <option value="#sector_cat_id#" #iif((isDefined("bestpractice_query") and isdefined("bestpractice_query.BESTPRACTICE_SECTORS") and ListContains(bestpractice_query.BESTPRACTICE_SECTORS,sector_cat_id)), DE('selected'), DE(''))#>#sector_cat#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-icon_path">
                    <label class="col col-4 col-xs-12">Icon/Image Path *</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput><input type="text" name="icon_path" id="icon_path" value="#iif(isDefined("bestpractice_query") and isdefined("bestpractice_query.BESTPRACTICE_ICON_PATH"), "bestpractice_query.BESTPRACTICE_ICON_PATH", DE(''))#" required></cfoutput>
                    </div>
                </div>
                <div class="form-group" id="item-workcube_product_code">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52102.Kodu'>*</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput><input type="text" name="workcube_product_code" id="bestpractice_workcube_product_code" value="#iif(isDefined("bestpractice_query") and isdefined("bestpractice_query.BESTPRACTICE_PRODUCT_CODE"), "bestpractice_query.BESTPRACTICE_PRODUCT_CODE", DE(''))#" required></cfoutput>
                    </div>
                </div>
                <div class="form-group" id="item-publish_date">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31639.Yayın Tarihi'>*</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="text" name="publish_date" id="publish_date" maxlength="10" value="<cfoutput>#iif((isDefined("bestpractice_query") and isdefined("bestpractice_query.BESTPRACTICE_PUBLISH_DATE")and len(bestpractice_query.BESTPRACTICE_PUBLISH_DATE)), "dateformat(bestpractice_query.BESTPRACTICE_PUBLISH_DATE,dateformat_style)", DE(''))#</cfoutput>" required>
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
                            value="#iif(isDefined("bestpractice_query"), "bestpractice_query.BESTPRACTICE_DETAIL", DE(''))#"
                            width="100%"
                            height="180">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row formContentFooter">
            <div class="col col-12 col-xs-12">
                <cfif isdefined("bestpractice_query")>
                    <cf_record_info
                    query_name="bestpractice_query"
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
<cf_box title="#getLang('','',48653)#" id="best_practice_components" closable="0" box_page="#(isDefined('bestpractice_query') and isdefined("bestpractice_query.BESTPRACTICE_FILE_PATH") and len(bestpractice_query.BESTPRACTICE_FILE_PATH)) ? 'index.cfm?fuseaction=dev.bestpractice&mode=get&method=get_bp_component&file_path=' & Replace(bestpractice_query.BESTPRACTICE_FILE_PATH, "\", "/") : ''#" add_href="#(isDefined('bestpractice_query') and not len(bestpractice_query.BESTPRACTICE_FILE_PATH)) ? 'javascript:addComponentFile()' : ''#">
</cf_box>

<script type="text/javascript">

    function getBpComponent(){
        let file_path = $('input[name = file_path]').val().replace('\\', '/');
        if( file_path != '' ) AjaxPageLoad('index.cfm?fuseaction=dev.bestpractice&mode=get&method=get_bp_component&file_path=' + file_path, 'body_best_practice_components');
    }

    <cfif isDefined('bestpractice_query')>
    function addComponentFile() {
        cfmodal('<cfoutput>#request.self#</cfoutput>?fuseaction=dev.bestpractice&mode=get&method=get_add_component_form&id=<cfoutput>#attributes.id#</cfoutput>', 'warning_modal')
    }
    </cfif>
    
</script>