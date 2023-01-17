<cfinclude template="../wocial_app.cfm">

<cfset getPlatform = getData.getPlatform() />

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform name="form_brand" id="form_brand">
        <cf_box title="BRAND-ACCOUNT" scroll="0">
            <cf_box_elements>
                <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61436.Platform'>*</label>
                        <div class="col col-8 col-sm-12">
                            <select name="platform_id" id="platform_id" required>
                                <option value="" ><cf_get_lang dictionary_id ="57734.Seçiniz"></option>
                                <cfloop query="getPlatform">
                                    <cfoutput><option value="#PLATFORM_ID#">#PLATFORM_NAME#</option></cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-brand">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57930.Kullanıcı'>-<cf_get_lang dictionary_id='58847.Marka'>*</label>
                        <div class="col col-8 col-sm-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id='57930.Kullanıcı'> <cf_get_lang dictionary_id='58847.Marka'></div>
                                <input type="text" name="brand_name" id="brand_name" required>
                                <span class="input-group-addon icon-question input-group-tooltip btnPointer"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-link_media">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='42371.Link'>-<cf_get_lang dictionary_id='29529.Sosyal Medya'>*</label>
                        <div class="col col-8 col-sm-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id='42371.Link'>-<cf_get_lang dictionary_id='29529.Sosyal Medya'></div>
                                <input type="text" name="social_media_url" id="social_media_url" required>
                                <span class="input-group-addon icon-question input-group-tooltip btnPointer"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-link_site">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='42371.Link'>-<cf_get_lang dictionary_id='61437.İlişkili Website'></label>
                        <div class="col col-8 col-sm-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id='42371.Link'>-<cf_get_lang dictionary_id='61437.İlişkili Website'></div>
                                <input type="text" name="website_url" id="website_url">
                                <span class="input-group-addon icon-question input-group-tooltip btnPointer"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-manager">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30367.Yönetici'>*</label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <input type="hidden" name="brand_manager_position_code" id="brand_manager_position_code">
                                <input type="hidden" name="brand_manager_id" id="brand_manager_id">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id='30367.Yönetici'></div>
                                <input type="text" name="brand_manager_name" id="brand_manager_name" required onfocus="AutoComplete_Create('brand_manager_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID,POSITION_CODE','brand_manager_id,brand_manager_position_code','3','135');">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=form_brand.brand_manager_name&field_emp_id=form_brand.brand_manager_id&field_code=form_brand.brand_manager_position_code&select_list=1</cfoutput>','list');"></span>
                                <span class="input-group-addon icon-question input-group-tooltip btnPointer"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-is_active">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                        <div class="col col-8 col-xs-12"> 
                            <input type="checkbox" name="brand_status" id="brand_status" value="1" checked>
                        </div>
                    </div> 
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57771.Detay'></label>
                        <div class="col col-8 col-xs-12"> 
                            <textarea name="brand_description" id="brand_description"></textarea>
                        </div>
                    </div> 
                    <div class="form-group" id="item-keyword">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47046.Keyword'></label>
                        <div class="col col-8 col-xs-12"> 
                            <textarea name="brand_keyword" id="brand_keyword"></textarea>
                        </div>
                    </div> 
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons>
            </cf_box_footer>
        </cf_box>
    </cfform>
</div>