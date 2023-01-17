<cfset getComponent = createObject('component','WDO.development.cfc.extensions')>
<cfset get_extension = getComponent.get_extension(extension_id:attributes.id)>
<cfset get_components = getComponent.get_components(extension_id:attributes.id)>
<cf_catalystHeader>
<div style="display:none;z-index:999;" id="component_add"></div>
<div style="display:none;z-index:999;" id="component_upd"></div>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent  variable="head"><cf_get_lang dictionary_id='61331.Extension'> </cfsavecontent>
    <cf_box title="Extension">
        <cfform name="upd_extensions" method="post" action="#request.self#?fuseaction=dev.emptypopup_upd_extensions">
            <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
            <input type="hidden" name="wbo" id="wbo" value="1">
            <cf_box_elements>
                <cfoutput query="get_extension">
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-extension">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='61331.Extension'> * </label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" id="extension_name" name="extension_name" value="#wrk_extension_name#" required>
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
                                <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0' fusepath="dev.extensions">
                            </div>
                        </div>
                        <div class="form-group" id="item-icon-path">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Icon Path</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" id="icon_path" name="icon_path" value="#extension_icon_image_path#">
                            </div>
                        </div>
                        <div class="form-group" id="item-version">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Version</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" id="version" name="version" value="#extension_version#">
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="3" type="column" sort="true">
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
                                        <option value="#sector_cat_id#" #iif(len(get_extension.extension_sectors) and ListContains(get_extension.extension_sectors,sector_cat_id), DE('selected'), DE(''))#>#sector_cat#</option>
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
                            instancename="extension_detail"
                            valign="top"
                            value="#get_extension.extension_detail#"
                            maxCharCount="400"
                            width="100%"
                            height="180"> 
                        </div>
                    </div>
                </cf_box_elements>
            
            </div>
            <cf_box_footer>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cf_record_info query_name="get_extension">
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cf_workcube_buttons is_upd='1' delete_page_url="#request.self#?fuseaction=dev.emptypopup_upd_extensions&all_del=1&extension_id=<cfoutput>#attributes.id#"  add_function="control()">
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
    <div id="component_div">
        <cf_box title="Components" add_href="javascript:openComponent('WDO/modalExtensionsComponentsAdd.cfm?extensions_id=#attributes.id#','component_add')">
            <cf_flat_list sort="false">
                <thead>
                    <tr>
                        <th width="20"><a href="javascript://" onclick="openComponent('WDO/modalExtensionsComponentsAdd.cfm?extensions_id=<cfoutput>#attributes.id#</cfoutput>','component_add')"><i class="fa fa-plus"></i></a></th>
                        <th width="30">Sira</th>
                        <th>Component</th>
                        <th>File Path</th>
                        <th width="20"><i class="fa fa-code"></i></th>
                        <th>Place</th>
                        <th>Action</th>
                        <th width="20"><i class="fa fa-plus"></i></th>
                        <th width="20"><i class="fa fa-refresh"></i></th>
                        <th width="20"><i class="fa fa-cube"></i></th>
                        <th width="20"><i class="fa fa-list"></i></th>
                        <th width="20"><i class="fa fa-dashboard"></i></th>
                        <th width="20"><i class="fa fa-info"></i></th>
                        <th width="20"><a href="javascript://" onclick="openComponent('WDO/modalExtensionsComponentsAdd.cfm?extensions_id=<cfoutput>#attributes.id#</cfoutput>','component_add')"><i class="fa fa-plus"></i></a></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif len(get_components.recordcount)>
                        <cfoutput query="get_components">
                            <tr>
                                <td><a href="javascript://" onclick="delete_row(#wrk_component_id#)"><i class="fa fa-minus"></i></a></td>
                                <td>#WORKING_NUMBER#</td>
                                <td>#WRK_COMPONENT_NAME#</td>
                                <td>#COMPONENT_FILE_PATH#</td>
                                <td></td>
                                <td><cfif WORKING_PLACE eq 1>Display<cfelseif WORKING_PLACE eq 2>Action</cfif></td>
                                <td><cfif WORKING_ACTION eq 1>Before<cfelseif WORKING_PLACE eq 2>After</cfif></td>
                                <td><cfif IS_ADD_WORK eq 1><i class="fa fa-plus"></cfif></td>
                                <td><cfif IS_UPD_WORK eq 1><i class="fa fa-refresh"></cfif></td>
                                <td><cfif IS_DET_WORK eq 1><i class="fa fa-cube"></cfif></td>
                                <td><cfif IS_LIST_WORK eq 1><i class="fa fa-list"></cfif></td>
                                <td><cfif IS_DASHBOARD_WORK eq 1><i class="fa fa-dashboard"></cfif></td>
                                <td><cfif IS_INFO_WORK eq 1><i class="fa fa-info"></cfif></td>
                                <td><a href="javascript://" onclick="openComponent('WDO/modalExtensionsComponentsUpd.cfm?component_id=#wrk_component_id#','component_upd')"><i class="fa fa-pencil"></a></td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="14"><cf_get_lang dictionary_id='57484.No record'></td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_flat_list>
        </cf_box>
    </div>
</div>
<script>
    function delete_row(id){
        window.location.href="<cfoutput>#request.self#?fuseaction=dev.emptypopup_upd_extensions&is_del_comp=1&component_id=</cfoutput>"+id;      
    }
    function openComponent(url,id){
        document.getElementById(id).style.display ='';	
		document.getElementById(id).style.width ='500px';	
		$("#"+id).css('right','0');
		$("#"+id).css('top','50%');
		$("#"+id).css('position','absolute');	
		
		AjaxPageLoad(url,id);
		return false;
    }
    function gonder()
	{
		if(document.getElementById("related_wo").value=="")
			windowopen('<cfoutput>#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=upd_extensions.related_wo&is_upd=0</cfoutput>','list');
		else
			windowopen('<cfoutput>#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=upd_extensions.related_wo&is_upd=1</cfoutput>','list');
	}
</script>