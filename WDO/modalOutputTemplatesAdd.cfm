<cf_catalystHeader>
<cfset cfc= createObject("component","workdata.get_print_files_cats")>
<cfset get_print_cats=cfc.GetPrintCats()>
<cfset getComponent = createObject('component','WDO.development.cfc.output_template')>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="Output Templates">
        <cfform name="add_output_templates" method="post" action="#request.self#?fuseaction=dev.emptypopup_add_output_templates">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                    <div class="form-group" id="item-output-template">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Name *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="text" name="output_template_name" id="output_template_name" value="" required>
                                    <input type="hidden" name="dictionary_id"  id="dictionary_id" value="">
                                    <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_list_lang_settings&is_use_send&lang_dictionary_id=add_output_templates.dictionary_id&lang_item_name=add_output_templates.output_template_name');return false"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-template-path">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Template Path</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" id="template_path" name="template_path" value="">
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
                            <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0' fusepath="dev.output_templates">
                        </div>
                    </div>
                    <div class="form-group" id="item-print-type">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='388.İşlem Tipi'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="print_type" id="print_type">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_print_cats">
                                    <option value="#print_type#">#print_namenew#&nbsp;(#print_type#)</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div> 
                    <div class="form-group" id="item-view-path">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">View Path</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" id="view_path" name="view_path" value="">
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
                    <div class="form-group" id="item-schema-markup">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Schema Markup</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                            <select name="schema_markup" id="schema_markup">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="EventReservation">Ticket</option>
                                <option value="product">Product</option>
                                <option value="article">Article</option>
                                <option value="educationalOccupationalProgram">Educational Occupational Program</option>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_seperator title="Page Specifications" id="Page_Specifications_seperator">
                <div style="display:none;" id="Page_Specifications_seperator">
                    <cf_box_elements vertical="1">
                        <div class="col col-2 col-md-2 col-sm-3 col-xs-12" index="4" type="column" sort="true">
                            <div class="form-group" id="item-rule_unit">
                                <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Rule Unit </label>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">    
                                    <select name="rule_unit" id="rule_unit"  required>
                                        <option value="1">Milimeter</option>
                                        <option value="2"> Inch</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-page_width">
                                <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Width</label>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                    <input type="text" id="page_width" name="page_width" value="" onKeyUp="isNumber(this)">
                                </div>
                            </div>
                            <div class="form-group" id="item-page_height">
                                <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Height</label>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                    <input type="text" id="page_height" name="page_height" value="" onKeyUp="isNumber(this)">
                                </div>
                            </div>
                        </div>
                        <div class="col col-2 col-md-2 col-sm-3 col-xs-12" index="5" type="column" sort="true">
                            <div class="form-group" id="item-page_margin_left">
                                <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Margin Left</label>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                    <input type="text" id="page_margin_left" name="page_margin_left" value="" onKeyUp="isNumber(this)">
                                </div>
                            </div>
                            <div class="form-group" id="item-page_margin_right">
                                <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Margin Right</label>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                    <input type="text" id="page_margin_right" name="page_margin_right" value="" onKeyUp="isNumber(this)">
                                </div>
                            </div>
                            <div class="form-group" id="item-page_margin_top">
                                <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Margin Top</label>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                    <input type="text" id="page_margin_top" name="page_margin_top" value="" onKeyUp="isNumber(this)">
                                </div>
                            </div>
                            <div class="form-group" id="item-page_margin_bottom">
                                <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Margin Bottom</label>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                    <input type="text" id="page_margin_bottom" name="page_margin_bottom" value="" onKeyUp="isNumber(this)">
                                </div>
                            </div>
                        </div>
                        <div class="col col-2 col-md-2 col-sm-3 col-xs-12" index="6" type="column" sort="true">
                            <div class="form-group" id="item-page_header_height">
                                <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Header Height</label>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                    <input type="text" id="page_header_height" name="page_header_height" value="" onKeyUp="isNumber(this)">
                                </div>
                            </div>
                            <div class="form-group" id="item-page_footer_height">
                                <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Footer Height</label>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                    <input type="text" id="page_footer_height" name="page_footer_height" value="" onKeyUp="isNumber(this)">
                                </div>
                            </div>
                            <div class="form-group" id="item-logo-width">
                                <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Logo Height</label>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                    <input type="text" id="logo_height" name="logo_height" value="" onKeyUp="isNumber(this)">
                                </div>
                            </div>
                            <div class="form-group" id="item-logo-width">
                                <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Logo Width</label>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                    <input type="text" id="logo_width" name="logo_width" value="" onKeyUp="isNumber(this)">
                                </div>
                            </div>
                        </div>
                        <div class="col col-2 col-md-2 col-sm-3 col-xs-12" index="7" type="column" sort="true">
                            <div class="form-group" id="item-use_logo">
                                <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                    Use Logo
                                    <input type="checkbox" id="use_logo" name="use_logo">
                                </label>
                            </div>
                            <div class="form-group" id="item-use_adress">
                                <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                    Use Adress
                                    <input type="checkbox" id="use_adress" name="use_adress">
                                </label>
                            </div>                            
                        </div>
                    </cf_box_elements>
                </div>
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
                            instancename="output_template_detail"
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
            windowopen('<cfoutput>#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=add_output_templates.related_wo&is_upd=0</cfoutput>','list');
        else
            windowopen('<cfoutput>#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=add_output_templates.related_wo&is_upd=1</cfoutput>','list');
    }
</script>
    