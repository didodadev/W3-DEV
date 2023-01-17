<cfparam name="attributes.modal_id" default="">
<cf_box title="#getlang('','Yan Ürün','64086')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="add_byproduct" action="#request.self#?fuseaction=product.emptypopup_add_byproducts" method="post">
        <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
        <input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
        <cf_box_elements>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="form-group" id="item-component">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='63535.Bileşen'>- <cf_get_lang dictionary_id="58577.Sıra">/ <cf_get_lang dictionary_id="57692.İşlem"></label>
                    <div class="col col-8 col-xs-12">
                        <select name="component" id="component">
                            <option value=""><cf_get_lang dictionary_id="64095.İşlem Seçiniz"></option>
                            <option value="1"><cf_get_lang dictionary_id="64083.Bekletme"></option>
                            <option value="2"><cf_get_lang dictionary_id="63507.Ayrıştırma"></option>
                            <option value="3"><cf_get_lang dictionary_id="64084.Süzme"></option>
                    </select> 
                    </div>
                </div>
                <div class="form-group" id="item-product">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'>- <cf_get_lang dictionary_id="57452.Stok"></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="related_stock_id" id="related_stock_id" value="">
                            <input type="hidden" name="related_product_id" id="related_product_id" value="">
                                <input type="text" name="product_name" id="product_name">
                            <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&stock_and_spect=1&field_spect_main_id=add_byproduct.spect_main_id&field_spect_main_name=add_byproduct.spect_main_name&field_id=add_byproduct.related_stock_id&field_name=add_byproduct.product_name&field_unit_name=unit&field_unit2=unit2&from_byprodcts=1&product_id=add_byproduct.related_product_id')"></span>
                        </div>	
                    </div>
                </div>
                <div class="form-group" id="item-spec">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57647.Spec'>- <cf_get_lang dictionary_id='45880.Etiket'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="hidden" name="spect_main_name" id="spect_main_name" readonly="yes">
                                <input type="text" name="spect_main_id" id="spect_main_id" readonly>
                            <span class="input-group-addon icon-ellipsis btnPoniter" onclick="open_spec2();"></span>
                        </div>						
                    </div>
                </div>
                <div class="form-group" id="item-amount">
                    <label class="col col-4 col-xs-12">1.<cf_get_lang dictionary_id='57635.Miktar'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                    <input type="text" name="amount" id="amount" value="1">		
                    <span name="unit" id="unit" class="input-group-addon"></span>		
                    </div>
                </div>	
                </div>
                <div class="form-group" id="item-amount2">
                    <label class="col col-4 col-xs-12">2.<cf_get_lang dictionary_id='57635.Miktar'></label>
                    <div class="col col-8 col-xs-12">	
                        <div class="input-group">
                    <input type="text" name="amount2" id="amount2" value="1">		
                    <span name="unit2" id="unit2" class="input-group-addon"></span>						
                    </div>
                </div>	
                </div>
                <div class="form-group" id="item-abh">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42999.A*b*h'></label>
                    <div class="col col-8 col-xs-12">                                        
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <input type="text" id="width" name="width">
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <input type="text" id="height" name="height">
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <input type="text" id="length" name="length">
                        </div>                                   					
                    </div>
                </div>
                <div class="form-group" id="item-detail">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57629.Açıklama"><cf_get_lang dictionary_id="57989.Ve"><cf_get_lang dictionary_id="52563.Detaylar"></label>
                    <div class="col col-8 col-xs-12">
                        <textarea style="height:50px;" name="detail" id="detail" maxlength="250"></textarea>
                    </div>
                </div>
            </div>
            </cf_box_elements>    
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function="kontrol2()">
        </cf_box_footer>
    </cfform>
</cf_box>
<script>
  function kontrol2()
	{
        if(add_byproduct.related_stock_id.value!='' && add_byproduct.related_product_id.value!='' && add_byproduct.product_name.value!='')
         {
            if(filterNum(add_byproduct.amount.value)>0 && filterNum(add_byproduct.amount2.value)>0)
            {
                add_byproduct.amount.value = filterNum(add_byproduct.amount.value);
            add_byproduct.amount2.value = filterNum(add_byproduct.amount2.value);
                <cfoutput>#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_byproduct' , #attributes.modal_id#);"),DE(""))#</cfoutput>
            }
          else
            {
            alert("<cf_get_lang dictionary_id='64094.Miktar 1 ve Miktar 2 Değerleri 0 dan Büyük Olmalı'>!");
            }
        }
        else
        {
            alert("<cf_get_lang dictionary_id='45986.Ürün Girmelisiniz'>!");
        }
        return false;
    }
    function open_spec2()
	{
		if(add_byproduct.related_stock_id.value!='' && add_byproduct.product_name.value!='')
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_name=add_byproduct.spect_main_name&field_main_id=add_byproduct.spect_main_id&stock_id='+add_byproduct.related_stock_id.value,'list')
		else
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57657.Ürün'>");
	}
</script>
    