<cfquery name="GET_CONTENT" datasource="#DSN#">
	SELECT NAME, CONTENT_PROPERTY_ID FROM CONTENT_PROPERTY ORDER BY NAME
</cfquery>

<cfform name="add_digital_asset_group" action="#request.self#?fuseaction=settings.emptypopup_add_digital_asset_group" method="post">
    <cf_box_elements>
        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
            <div class="form-group" id="item-name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45131.Dijital Varlık Grup Adı'>*</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfinput type="Text" name="asset_group" id="asset_group" value=""  required="yes" message="Dijital Varlık Grup Adı Giriniz!" maxlength="50">
                </div>
            </div>

            <div class="form-group">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <textarea name="detail" id="detail" value=""> </textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58067.Döküman Tipi'></label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <select name="get_content_property" id="get_content_property" multiple="multiple" >
                        <cfoutput query="get_content">
                            <option value="#content_property_id#">#name#</option>
                        </cfoutput>
                    </select>  
                </div>
            </div>
        </div>
        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2" type="column" sort="true">
            <div class="form-group">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12" style="display:none!important"><cf_get_lang
                    dictionary_id='36167.Yetkili Pozisyonlar'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12" id="gizli1">
                    <cfsavecontent variable="txt_1"><cf_get_lang dictionary_id='36167.Yetkili Pozisyonlar'></cfsavecontent>
                    <cf_workcube_to_cc  is_update="0"  to_dsp_name="#txt_1#" form_name="add_digital_asset_group"  str_list_param="1">
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12" style="display:none!important"><cf_get_lang dictionary_id='38005.Yetkili Pozisyon Tipleri'></label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12" id="gizli1">
                    <cf_flat_list>
                        <thead>
                            <tr>
                                <th width="20"> 
                                    <input type="hidden" name="position_cats" id="position_cats" value="">
                                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_position_cats&field_id=add_digital_asset_group.position_cats&field_td=td_yetkili2</cfoutput>','list');"><i class="icon-pluss"></i></a>        
                                </th>
                                <th><cf_get_lang dictionary_id='38005.Yetkili Pozisyon Tipleri'></th>
                            </tr>
                        </thead>
                        <tbody id="td_yetkili2"> </tbody>        
                    </cf_flat_list>
                </div>
            </div>
        </div>
    </cf_box_elements>
    <cf_box_footer>
        <cf_workcube_buttons is_upd='0'>
    </cf_box_footer>
</cfform>