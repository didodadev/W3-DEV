<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Abone Kategorileri','42255')#" add_href="#request.self#?fuseaction=settings.add_subscription_type" is_blank="0">
        <div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
            <cfinclude template="../display/list_subscription_type.cfm">
        </div>
        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform name="subs_type" id="subs_type" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_subscription_type" enctype="multipart/form-data">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-subscripton_type">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42003.Kategori Adı'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'>!</cfsavecontent>
                                <cfinput type="text" name="subscripton_type" id="subscripton_type" value="" maxlength="43" required="yes" message="#message#">
                            </div>
                        </div>
                        <div class="form-group" id="item-product_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <div class="input-group">
                                    <input type="hidden" name="product_id" id="product_id" value="">
                                    <input type="hidden" name="stock_id" id="stock_id" value="">
                                    <input type="text" name="product_name" id="product_name" value="" readonly="">
                                    <span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=subs_type.product_id&field_name=subs_type.product_name&field_id=subs_type.stock_id');"></span>			
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-system_icon_color">
                            <!--- Aboneler Haritasında gozuken ikonların rengini secmek icin konuldu --->
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45111.Renk'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <cf_workcube_color_picker name="system_icon_color">
                            </div>
                        </div>
                        <div class="form-group" id="item-subs_icon_file">
                            <!--- Aboneler haritasında gozuken ikonlar --->
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58029.İkon'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <input type="file" name="subs_icon_file" id="subs_icon_file">
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2" type="column" sort="true">
                        <div class="form-group col col-8" id="item-gizli1">
                            <cfsavecontent variable="txt_1"><cf_get_lang dictionary_id='42683.Yetkili Pozisyonlar'></cfsavecontent>
                            <cf_workcube_to_cc is_update="0" to_dsp_name="#txt_1#" form_name="subs_type" str_list_param="1">
                        </div>
                        <div class="form-group col col-8" id="item-gizli2">
                            <cf_flat_list>
                                <thead>
                                    <tr>
                                        <th width="20"> 
                                            <input type="hidden" name="position_cats" id="position_cats" value="">
                                            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_position_cats&field_id=subs_type.position_cats&field_td=td_yetkili2</cfoutput>','list');"><i class="icon-pluss"></i></a>        
                                        </th>
                                        <th><cf_get_lang dictionary_id='38005.Yetkili Pozisyon Tipleri'></th>
                                    </tr>
                                </thead>
                                <tbody id="td_yetkili2"> </tbody>        
                            </cf_flat_list>
                        </div>
                    </div>
                </cf_box_elements>
                <div class="col col-12">
                    <cf_box_footer>
                        <cf_workcube_buttons is_upd='0' add_function="kontrol()">
                    </cf_box_footer>
                </div>
            </cfform>
        </div>
    </cf_box>
</div>

      
