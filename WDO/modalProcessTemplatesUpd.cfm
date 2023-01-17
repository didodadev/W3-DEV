<cfset getComponent = createObject('component','WDO.development.cfc.process_template')>
<cfset get_process_template = getComponent.get_process_template(process_template_id:attributes.id)>
<cfset cfc= createObject("component","workdata.get_print_files_cats")>
<cfset get_print_cats=cfc.GetPrintCats()>
<cf_catalystHeader>
<div style="display:none;z-index:999;" id="wo"></div>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="upd_process_templates" method="post" action="#request.self#?fuseaction=dev.emptypopup_upd_process_templates">
            <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
            <cf_box_elements>
                <cfoutput query="get_process_template">
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-process_template">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Name * </label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" id="process_template_name" name="process_template_name" value="#WRK_PROCESS_TEMPLATE_NAME#" required>
                            </div>
                        </div>                       
                        <div class="form-group" id="item-auhtor-name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Author Name</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" id="author" name="author" value="#author_name#">
                            </div>
                        </div>
                        <div class="form-group" id="item-author-partner">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Author Partner ID</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" id="author_partner_id" name="author_partner_id" value="#author_partner_id#" onKeyUp="isNumber(this)">
                            </div>
                        </div>
                        <div class="form-group" id="item-workcube-product">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Workcube Product ID</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" id="product_id" name="product_id" value="#workcube_product_id#" onKeyUp="isNumber(this)">
                            </div>
                        </div>
                        <div class="form-group" id="item-best-practice">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Best Practice Code</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" id="bp_code" name="bp_code" value="#best_practise_code#">
                            </div>
                        </div>
                        <div class="form-group" id="item-template-path">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Template Path</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" id="template_path" name="template_path" value="#PROCESS_TEMPLATE_PATH#">
                                    <span class="input-group-addon" onclick=""><i class="fa fa-code"></i></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="2" type="column" sort="true">
                        <div class="form-group" id="item-active">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                Aktif
                                <input type="checkbox" id="active" name="active" <cfif is_active eq 1>checked</cfif>>
                            </label>
                        </div>
                        <div class="form-group" id="item-licence">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Licence *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select id="licence" name="licence" required>
                                    <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                                    <option value="1" <cfif LICENCE_TYPE eq 1>selected</cfif>>Standard</option>
                                    <option value="2" <cfif LICENCE_TYPE eq 2>selected</cfif>>Add-On</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-stage">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Stage</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0' fusepath="dev.process_templates">
                            </div>
                        </div>
                        <div class="form-group" id="item-icon-path">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Icon Path</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" id="icon_path" name="icon_path" value="#PROCESS_TEMPLATE_ICON_PATH#">                                    
                            </div>
                        </div>
                        <div class="form-group" id="item-version">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Version</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" id="version" name="version" value="#PROCESS_TEMPLATE_VERSION#">
                            </div>
                        </div>               
                        <div class="form-group" id="item-place">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Place</label>
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                Main
                                <input type="checkbox" id="main" name="main" <cfif is_main eq 1>checked</cfif>>
                            </label>
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                Stage
                                <input type="checkbox" id="stage" name="stage" <cfif is_stage eq 1>checked</cfif>>
                            </label>
                        </div>
                        <div class="form-group" id="item-action">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Action</label>
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                Display
                                <input type="checkbox" id="display" name="display" <cfif is_main eq 1>checked</cfif>>
                            </label>
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                Action
                                <input type="checkbox" id="action" name="action" <cfif is_action eq 1>checked</cfif>>
                            </label>    
                        </div>    
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="3" type="column" sort="true">
                        <div class="form-group" id="item-module">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                Module
                            </label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="module" id="module">
                                    <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                                    <cfset get_modules=getComponent.get_modules()>
                                    <cfloop query="get_modules">
                                        <option value="#module_id#" <cfif module_id eq  get_process_template.module_id>selected</cfif>>#module#</option>
                                    </cfloop>                                
                                </select>
                            </div>
                        </div>         
                        <div class="form-group" id="item-related-wo">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                WO *
                                <a href="javascript://" onclick="gonder();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='36185.Fuseaction'> <cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                            </label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea name="related_wo" id="related_wo" rows="3" required><cfif len(related_wo) ><cfoutput>#related_wo#</cfoutput></cfif></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-related-sectors">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Sectors *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfset get_sector_cats=getComponent.get_sector_cats()>
                                <select name="related_sectors" id="related_sectors" multiple required>
                                    <cfloop query="get_sector_cats">
                                        <option value="#sector_cat_id#" #iif(len(get_process_template.process_template_sectors) and ListContains(get_process_template.process_template_sectors,sector_cat_id), DE('selected'), DE(''))#>#sector_cat#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                    </div>
                </cfoutput>
            </cf_box_elements>
            <cf_seperator title="Detail" id="detail_seperator">
            <div style="display:none;" id="detail_seperator">
                <cf_box_elements vertical="1">
                    <div class="form-group" id="item-editor">
                        <label style="display:none!important">Detail</label>
                        <div class="col col-12" id="editor_id">
                            <input type="hidden" name="detail_old_length" id="detail_old_length" value=""> 
                            <cfmodule template="/fckeditor/fckeditor.cfm"
                            toolbarset="Basic"
                            basepath="/fckeditor/"
                            instancename="process_template_detail"
                            valign="top"
                            value="#get_process_template.PROCESS_TEMPLATE_DETAIL#"
                            maxCharCount="400"
                            width="100%"
                            height="180"> 
                        </div>
                    </div>
                </cf_box_elements>
            
            </div>
            <cf_box_footer>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cf_record_info query_name="get_process_template">
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cf_workcube_buttons is_upd='1' delete_page_url="#request.self#?fuseaction=dev.emptypopup_upd_process_templates&is_del=1&process_template_id=#attributes.id#">
                </div>
            </cf_box_footer>
        </cfform>  
    </cf_box> 
</div>
<script>
    function gonder()
	{
        $('#wo').show();	
        $("#wo").css('width','500px');
		$("#wo").css('left','40%');
		$("#wo").css('margin-top','10%');
		$("#wo").css('position','absolute');	
       
		if(document.getElementById("related_wo").value=="")
            AjaxPageLoad('<cfoutput>#request.self#?fuseaction=process.popup_dsp_faction_list&draggable=1&field_name=upd_process_templates.related_wo&is_upd=0</cfoutput>','wo');
		else
            AjaxPageLoad('<cfoutput>#request.self#?fuseaction=process.popup_dsp_faction_list&draggable=1&field_name=upd_process_templates.related_wo&is_upd=1</cfoutput>','wo');
        return false;
	}
</script>