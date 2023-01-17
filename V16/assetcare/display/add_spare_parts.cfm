<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Yedek Parçalar','63950')#" popup_box="1" scroll="1" collapsable="1" resize="1">
        <cfform name="add_parts" action="V16/assetcare/cfc/assetp_spare_parts.cfc?method=add_parts" method="post">
            <cfinput type="hidden" name="asset_p_id" id="asset_p_id" value="#attributes.asset_p_id#">
            <cfinput type="hidden" name="modal_id" id="modal_id" value="#attributes.modal_id#">
            <cf_box_elements>
                <div class="col col-5 col-md-5 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item_product">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'>/ <cf_get_lang dictionary_id='57452.Stok'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <div class="input-group">
                                <cf_duxi name="product_id" id="product_id" type="hidden" value="">
                                <input type="hidden" name="add_stock_id" id="add_stock_id" value="">
                                <input type="text" name="product_name" id="product_name" required message="">
                                <span class="input-group-addon icon-ellipsis btnPoniter" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=add_parts.add_stock_id&field_name=add_parts.product_name&product_id=add_parts.product_id&field_unit=add_parts.unit_id&field_unit_name=add_parts.unit_name')"></span>
                            </div>						
                        </div>
                    </div>
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-period">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='63951.Değişim Periyodu'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="change_period">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="1"><cf_get_lang dictionary_id='63972.Çalışma Saatine Göre'></option>
                                    <option value="2"><cf_get_lang dictionary_id='63973.Güne Göre'></option>
                                    <option value="3"><cf_get_lang dictionary_id='63976.Sayaç'></option>
                                </select>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <input type="text" name="change_amount" id="change_amount">
                            </div>
                        </div>
                    </div>
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-risk_point">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='52224.Risk Puanı'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <select name="risk_point" id="risk_point">
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-5 col-md-5 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-spect_main_name">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57647.Spec'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <div class="input-group">
                                <cfinput type="hidden" name="spect_main_name" id="spect_main_name">
                                <input type="text" name="spect_main_id" id="spect_main_id" readonly>
                                <span class="input-group-addon icon-ellipsis btnPoniter" onclick="open_spec();"></span>
                            </div>						
                        </div>
                    </div>
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-quantity">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57635.Miktar'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="quantity" id="quantity" validate="integer" validateAt="onBlur,onSubmit" message = "#getLang('','Sayı Giriniz','55805')#!" >
                            </div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <input type="hidden" name="unit_id" id="unit_id">
                                <cfinput type="text" name="unit_name" id="unit_name" readonly placeholder="#getLang('','Birim','57636')#">
                            </div>
                        </div>
                    </div>
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-description">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <input type="text" name="detail" id="detail" maxlength="150">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons
                is_upd="0"
                add_function="loadPopupBox('add_parts','#attributes.modal_id#')">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script>
    $(document).attr("title", "<cf_get_lang dictionary_id='47149.Makine-Ekipman ve Binalar'>");
    function open_spec()
        {
        if(document.getElementById("add_stock_id").value!='' && document.getElementById("product_name").value!='')
            openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_name=spect_main_name&field_main_id=spect_main_id&stock_id='+document.getElementById("add_stock_id").value/*  */)
        else
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57657.Ürün'>");
        }
</script>