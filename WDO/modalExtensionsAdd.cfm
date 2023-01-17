<cf_catalystHeader>
<cfset getComponent = createObject('component','WDO.development.cfc.extensions')>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent  variable="head"><cf_get_lang dictionary_id='61331.Extension'> </cfsavecontent>
    <cf_box title="Extension">
        <cfform name="add_extensions" method="post" action="#request.self#?fuseaction=dev.emptypopup_add_extensions">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                    <div class="form-group" id="item-extension">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='61331.Extension'> *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" id="extension_name" name="extension_name" value="" required>
                        </div>
                    </div>
                    <div class="form-group" id="item-auhtor-name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Author Name</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" id="author" name="author" value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-author-partner">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Author Partner ID</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" id="author_partner_id" name="author_partner_id" value="" onKeyUp="isNumber(this)">
                        </div>
                    </div>
                    <div class="form-group" id="item-workcube-product">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Workcube Product ID</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" id="product_id" name="product_id" value="" onKeyUp="isNumber(this)">
                        </div>
                    </div>
                    <div class="form-group" id="item-best-practice">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Best Practice Code</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" id="bp_code" name="bp_code" value="">
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="2" type="column" sort="true">
                    <div class="form-group" id="item-active">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            Aktif
                            <input type="checkbox" id="active" name="active">
                        </label>
                    </div>
                    <div class="form-group" id="item-licence">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Licence *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select id="licence" name="licence" required>
                                <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                                <option value="1">Standard</option>
                                <option value="2">Add-On</option>
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
                            <input type="text" id="icon_path" name="icon_path" value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-version">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Version</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" id="version" name="version" value="">
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
                            <textarea name="related_wo" id="related_wo" rows="3" required><cfif isdefined("attributes.fuseact") and len(attributes.fuseact)><cfoutput>#attributes.fuseact#</cfoutput></cfif></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-related-sectors">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Sectors * </label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfset get_sector_cats=getComponent.get_sector_cats()>
                            <select name="related_sectors" id="related_sectors" multiple required>
                                <cfoutput query="get_sector_cats">
                                    <option value="#sector_cat_id#">#sector_cat#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
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
                            value=""
                            maxCharCount="400"
                            width="100%"
                            height="180"> 
                        </div>
                    </div>
                </cf_box_elements>
            
            </div>
            <cf_box_footer>
                <cf_workcube_buttons>
            </cf_box_footer>
        </cfform>
    </cf_box>
   
</div>
<script>
    function gonder()
	{
		if(document.getElementById("related_wo").value=="")
			windowopen('<cfoutput>#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=add_extensions.related_wo&is_upd=0</cfoutput>','list');
		else
			windowopen('<cfoutput>#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=add_extensions.related_wo&is_upd=1</cfoutput>','list');
	}
</script>
