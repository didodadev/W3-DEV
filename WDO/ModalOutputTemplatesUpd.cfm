<cfset getComponent = createObject('component','WDO.development.cfc.output_template')>
<cfset get_output_template = getComponent.get_output_template(output_template_id:attributes.id)>
<cfset cfc= createObject("component","workdata.get_print_files_cats")>
<cfset get_print_cats=cfc.GetPrintCats()>
<!--- <cfquery name="a" datasource="#dsn#">
  ALTER TABLE  WRK_OUTPUT_TEMPLATES ADD LOGO_WIDTH FLOAT NULL;
  ALTER TABLE  WRK_OUTPUT_TEMPLATES ADD LOGO_HEIGHT FLOAT NULL;
</cfquery> --->
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="upd_output_templates" method="post" action="#request.self#?fuseaction=dev.emptypopup_upd_output_templates">
            <input type="hidden" name="output_template_id" id="output_template_id" value="<cfoutput>#attributes.id#</cfoutput>">
            <cf_box_elements>
                <cfoutput query="get_output_template">
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-output_template">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='44592.İsim'> * </label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfoutput>
                                        <input type="text" name="output_template_name" id="output_template_name" value="#WRK_OUTPUT_TEMPLATE_NAME#" required>
                                        <input type="hidden" name="dictionary_id"  id="dictionary_id" value="#dictionary_id#">
                                        <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_list_lang_settings&is_use_send&lang_dictionary_id=upd_output_templates.dictionary_id&lang_item_name=upd_output_templates.output_template_name');return false"></span>
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-template-path">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58640.Template'><cf_get_lang dictionary_id='62300.Path'> </label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" id="template_path" name="template_path" value="#OUTPUT_TEMPLATE_PATH#">
                            </div>
                        </div>
                        <div class="form-group" id="item-auhtor-name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59109.Oluşturan Kullanıcı'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" id="author" name="author" value="#author_name#">
                            </div>
                        </div>
                        <div class="form-group" id="item-author-partner">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59109.Oluşturan Kullanıcı'> <cf_get_lang dictionary_id='58885.Partner'> ID</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" id="author_partner_id" name="author_partner_id" value="#author_partner_id#" onKeyUp="isNumber(this)">
                            </div>
                        </div>
                        <div class="form-group" id="item-workcube-product">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Workcube <cf_get_lang dictionary_id='57657.Ürün'> ID</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" id="product_id" name="product_id" value="#workcube_product_id#" onKeyUp="isNumber(this)">
                            </div>
                        </div>
                        <div class="form-group" id="item-best-practice">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Best Practice <cf_get_lang dictionary_id='54257.Kodu'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" id="bp_code" name="bp_code" value="#best_practise_code#">
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="2" type="column" sort="true">
                        <div class="form-group" id="item-active">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                <cf_get_lang dictionary_id='57493.Aktif'>
                                <input type="checkbox" id="active" name="active" <cfif is_active eq 1>checked</cfif>>
                            </label>
                        </div>
                        <div class="form-group" id="item-licence">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42197.Lisans'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select id="licence" name="licence" required>
                                    <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                                    <option value="1" <cfif LICENCE_TYPE eq 1>selected</cfif>>Standard</option>
                                    <option value="2" <cfif LICENCE_TYPE eq 2>selected</cfif>>Add-On</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-stage">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0' fusepath="dev.output_templates">
                            </div>
                        </div>
                        <div class="form-group" id="item-print-type">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='388.İşlem Tipi'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="print_type" id="print_type">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfloop query="get_print_cats">
                                        <option value="#print_type#" <cfif print_type eq get_output_template.print_type>selected</cfif>>#print_namenew#&nbsp;(#print_type#)</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-view-path">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52532.	İzleme'> <cf_get_lang dictionary_id='62300.	Yol'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" id="view_path" name="view_path" value="#OUTPUT_TEMPLATE_VIEW_PATH#">
                                    <span class="input-group-addon" onClick="windowopen('#OUTPUT_TEMPLATE_VIEW_PATH#','page');"><i class="fa fa-file-image-o"></i></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-version">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50660.	Versiyon'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" id="version" name="version" value="#OUTPUT_TEMPLATE_VERSION#">
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
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='35400.	Sector'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfset get_sector_cats=getComponent.get_sector_cats()>
                                <select name="related_sectors" id="related_sectors" multiple required>
                                    <cfloop query="get_sector_cats">
                                        <option value="#sector_cat_id#" #iif(len(get_output_template.output_template_sectors) and ListContains(get_output_template.output_template_sectors,sector_cat_id), DE('selected'), DE(''))#>#sector_cat#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-schema-markup">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63246.Şema'> <cf_get_lang dictionary_id='64289.İşaretleme'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <select name="schema_markup" id="schema_markup">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="EventReservation" #iif(len(schema_markup) and schema_markup eq 'EventReservation',DE('selected'), DE(''))#><cf_get_lang dictionary_id='57657.Product'><cf_get_lang dictionary_id='64290.Flight Reservation'></option>
                                    <option value="product" #iif(len(schema_markup) and schema_markup eq 'product',DE('selected'), DE(''))#><cf_get_lang dictionary_id='57657.Product'></option>
                                    <option value="article" #iif(len(schema_markup) and schema_markup eq 'article',DE('selected'), DE(''))#><cf_get_lang dictionary_id='60108.Article'></option>
                                    <option value="educationalOccupationalProgram" #iif(len(schema_markup) and schema_markup eq 'educationalOccupationalProgram',DE('selected'), DE(''))#><cf_get_lang dictionary_id='64292.Educational Occupational Program'></option>
                                    <option value="order" #iif(len(schema_markup) and schema_markup eq 'order',DE('selected'), DE(''))#><cf_get_lang dictionary_id='57611.Order'></option>
                                    <option value="invoice" #iif(len(schema_markup) and schema_markup eq 'invoice',DE('selected'), DE(''))#><cf_get_lang dictionary_id='57441.Fatura'></option>
                                    <option value="ParcelDelivery" #iif(len(schema_markup) and schema_markup eq 'ParcelDelivery',DE('selected'), DE(''))#><cf_get_lang dictionary_id='64291.Parcel Delivery'></option>
                                </select>
                            </div>
                        </div>
                    </div>
                </cfoutput>
            </cf_box_elements>
            <cf_seperator title="Page Specifications" id="Page_Specifications_seperator">
            <div style="display:none;" id="Page_Specifications_seperator">
                <cf_box_elements vertical="1">  <cfoutput query="get_output_template">
                    <div class="col col-2 col-md-2 col-sm-3 col-xs-12" index="4" type="column" sort="true">
                        <div class="form-group" id="item-rule_unit">
                            <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Rule Unit </label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">    
                                <select name="rule_unit" id="rule_unit"  >
                                    <option value="1"<cfif Rule_Unit eq 1 >selected</cfif>>Milimeter</option>
                                    <option value="2" <cfif Rule_Unit eq 2>selected</cfif>>Inch </option>
                                </select>
                            </div>
                        </div> 
                        <div class="form-group" id="item-page_width">
                            <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Width</label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                <input type="text" id="page_width" name="page_width" value="#page_width#" onKeyUp="isNumber(this)">
                            </div>
                        </div>
                        <div class="form-group" id="item-page_height">
                            <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Height</label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                <input type="text" id="page_height" name="page_height" value="#page_height#" onKeyUp="isNumber(this)">
                            </div>
                        </div>
                    </div>
                    <div class="col col-2 col-md-2 col-sm-3 col-xs-12" index="5" type="column" sort="true" onKeyUp="isNumber(this)">
                        <div class="form-group" id="item-page_margin_left">
                            <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Margin Left</label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                <input type="text" id="page_margin_left" name="page_margin_left" value="#page_margin_left#" onKeyUp="isNumber(this)">
                            </div>
                        </div>
                        <div class="form-group" id="item-page_margin_right">
                            <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Margin Right</label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                <input type="text" id="page_margin_right" name="page_margin_right" value="#page_margin_right#" onKeyUp="isNumber(this)">
                            </div>
                        </div>
                        <div class="form-group" id="item-page_margin_top">
                            <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Margin Top</label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                <input type="text" id="page_margin_top" name="page_margin_top" value="#page_margin_top#" onKeyUp="isNumber(this)">
                            </div>
                        </div>
                        <div class="form-group" id="item-page_margin_bottom">
                            <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Margin Bottom</label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                <input type="text" id="page_margin_bottom" name="page_margin_bottom" value="#page_margin_bottom#" onKeyUp="isNumber(this)">
                            </div>
                        </div>
                    </div>
                    <div class="col col-2 col-md-2 col-sm-3 col-xs-12" index="6" type="column" sort="true">
                        <div class="form-group" id="item-page_header_height">
                            <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Header Height</label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                <input type="text" id="page_header_height" name="page_header_height" value="#page_header_height#" onKeyUp="isNumber(this)">
                            </div>
                        </div>
                        <div class="form-group" id="item-page_footer_height">
                            <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Footer Height</label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                <input type="text" id="page_footer_height" name="page_footer_height" value="#page_footer_Height#" onKeyUp="isNumber(this)">
                            </div>
                        </div>
                        <div class="form-group" id="item-logo-width">
                            <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Logo Height</label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                <input type="text" id="logo_height" name="logo_height" value="#logo_height#" onKeyUp="isNumber(this)">
                            </div>
                        </div>
                        <div class="form-group" id="item-logo-width">
                            <label class="col col-6 col-md-6 col-sm-6 col-xs-12">Logo Width</label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                <input type="text" id="logo_width" name="logo_width" value="#logo_width#" onKeyUp="isNumber(this)">
                            </div>
                        </div>                        
                    </div>
                    <div class="col col-2 col-md-2 col-sm-3 col-xs-12" index="7" type="column" sort="true">
                        <div class="form-group" id="item-use_logo">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                Logo <cf_get_lang dictionary_id='64293.Use'>
                                <input type="checkbox" id="use_logo" name="use_logo" <cfif USE_LOGO eq 1>checked</cfif>>
                            </label>
                        </div>
                        <div class="form-group" id="item-use_adress">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                #getLang('','Adres',58723)# <cf_get_lang dictionary_id='64293.Use'>
                                <input type="checkbox" id="use_adress" name="use_adress" <cfif USE_ADRESS eq 1>checked</cfif>>
                            </label>
                        </div>
                    </div>
                    </cfoutput>
                </cf_box_elements> 
            </div>
            <cf_seperator title="Detail" id="detail_seperator">
            <div style="display:none;" id="detail_seperator">
                <cf_box_elements vertical="1">
                    <div class="form-group" id="item-editor">
                        <label style="display:none!important"><cf_get_lang dictionary_id='42009.Detail'></label>
                        <div class="col col-12" id="editor_id">
                            <input type="hidden" name="detail_old_length" id="detail_old_length" value=""> 
                            <cfmodule template="/fckeditor/fckeditor.cfm"
                            toolbarset="Basic"
                            basepath="/fckeditor/"
                            instancename="output_template_detail"
                            valign="top"
                            value="#get_output_template.OUTPUT_TEMPLATE_DETAIL#"
                            maxCharCount="400"
                            width="100%"
                            height="180"> 
                        </div>
                    </div>
                </cf_box_elements>
            </div>
            <cf_box_footer>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cf_record_info query_name="get_output_template">
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cf_workcube_buttons is_upd='1' delete_page_url="#request.self#?fuseaction=dev.emptypopup_upd_output_templates&is_del=1&output_template_id=#attributes.id#"  add_function="control()">
                </div>
            </cf_box_footer>
        </cfform>  
    </cf_box> 
</div>
<script>
    function gonder()
	{
		if(document.getElementById("related_wo").value=="")
			windowopen('<cfoutput>#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=upd_output_templates.related_wo&is_upd=0</cfoutput>','list');
		else
			windowopen('<cfoutput>#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=upd_output_templates.related_wo&is_upd=1</cfoutput>','list');
	}
</script>