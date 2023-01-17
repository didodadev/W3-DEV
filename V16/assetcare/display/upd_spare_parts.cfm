<cfset list_parts = createObject("component","V16.assetcare.cfc.assetp_spare_parts")>
<cfset list_parts.dsn = dsn>
<cfset get_parts = list_parts.get_parts( ASSET_P_PARTS_ID:attributes.asset_parts_id)>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Yedek Parçalar','63950')#" popup_box="1" scroll="1" collapsable="1" resize="1">
        <cfform name="upd_parts" action="V16/assetcare/cfc/assetp_spare_parts.cfc?method=upd_parts" method="post">
            <cfinput type="hidden" name="asset_p_id" id="asset_p_id" value="#attributes.asset_p_id#">
            <cfinput type="hidden" name="asset_parts_id" id="asset_parts_id" value="#attributes.asset_parts_id#">
            <cfinput type="hidden" name="modal_id" id="modal_id" value="#attributes.modal_id#">
            <cf_box_elements>
                <div class="col col-5 col-md-5 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item_product">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'>/ <cf_get_lang dictionary_id='57452.Stok'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <div class="input-group">
                                <cf_duxi name="product_id" id="product_id" type="hidden" value="#get_parts.product_id#">
                                <cfinput type="hidden" name="add_stock_id" id="add_stock_id" value="#get_parts.stock_id#">
                                <cfinput type="text" name="product_name" id="product_name" value="#get_parts.product_name#">
                                <span class="input-group-addon icon-ellipsis btnPoniter" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=upd_parts.add_stock_id&field_name=upd_parts.product_name&product_id=upd_parts.product_id&field_unit=upd_parts.unit_id&field_unit_name=upd_parts.unit_name')"></span>
                            </div>						
                        </div>
                    </div>
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-period">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='63951.Değişim Periyodu'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="change_period">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="1" <cfif get_parts.change_period eq 1>selected</cfif>><cf_get_lang dictionary_id='63972.Çalışma Saatine Göre'></option>
                                    <option value="2" <cfif get_parts.change_period eq 2>selected</cfif>><cf_get_lang dictionary_id='63973.Güne Göre'></option>
                                    <option value="3" <cfif get_parts.change_period eq 3>selected</cfif>><cf_get_lang dictionary_id='63976.Sayaç'></option>
                                </select>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <cfinput type="text" name="change_amount" id="change_amount" value="#get_parts.change_amount#" validate="integer" validateAt="onBlur,onSubmit" message = "#getLang('','Sayı Giriniz','55805')#!">
                            </div>
                        </div>
                    </div>
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-risk_point">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='52224.Risk Puanı'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <select name="risk_point" id="risk_point">
                                <option value="1" <cfif get_parts.risk_point eq 1>selected</cfif>>1</option>
                                <option value="2" <cfif get_parts.risk_point eq 2>selected</cfif>>2</option>
                                <option value="3" <cfif get_parts.risk_point eq 3>selected</cfif>>3</option>
                                <option value="4" <cfif get_parts.risk_point eq 4>selected</cfif>>4</option>
                                <option value="5" <cfif get_parts.risk_point eq 5>selected</cfif>>5</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-5 col-md-5 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-spect_main_name">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57647.Spec'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <div class="input-group">
                                <cfinput type="hidden" name="spect_main_id" id="spect_main_id" value="#get_parts.spect_id#">
                                <cfinput type="text" name="spect_main_name" id="spect_main_name" readonly value="#get_parts.spect_main_name#">
                                <span class="input-group-addon icon-ellipsis btnPoniter" onclick="open_spec();"></span>
                            </div>						
                        </div>
                    </div>
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-quantity">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57635.Miktar'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="quantity" id="quantity" value="#get_parts.QUANTIY#" validate="integer" validateAt="onBlur,onSubmit" message = "#getLang('','Sayı Giriniz','55805')#!">
                            </div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <cfinput type="hidden" name="unit_id" id="unit_id" value="#get_parts.product_unit_id#">
                                <cfinput type="text" name="unit_name" id="unit_name" readonly value="#get_parts.MAIN_UNIT#" placeholder="#getLang('','Birim','57636')#">
                            </div>
                        </div>
                    </div>
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-description">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <cfinput type="text" name="detail" id="detail" maxlength="150" value="#get_parts.detail#">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_record_info query_name="get_parts">
                <cf_workcube_buttons
                add_function="kontrol()"
                is_upd="1"
                del_action= 'V16/assetcare/cfc/assetp_spare_parts:del_parts:asset_parts_id=#attributes.asset_parts_id#'
                del_next_page = '#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#attributes.asset_p_id#'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script>
    function open_spec()
        {
        if(document.getElementById("add_stock_id").value!='' && document.getElementById("product_name").value!='')
            openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_name=spect_main_name&field_main_id=spect_main_id&stock_id='+document.getElementById("add_stock_id").value/*  */)
        else
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57657.Ürün'>");
        }
        function kontrol()
        {
            if($('#product_name').val()=='')
            {
                alert('<cf_get_lang dictionary_id='40069.Lütfen Ürün Seçiniz'>');
                return false;
            }
            loadPopupBox('upd_parts','<cfoutput>#attributes.modal_id#</cfoutput>');
        }
</script>