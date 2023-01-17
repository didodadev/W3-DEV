<cfparam name="attributes.modal_id" default="">
<cfquery name="get_byproducts" datasource="#dsn3#">
	SELECT 
        *
    FROM 
        PRODUCT_TREE_BY_PRODUCT
    WHERE
        BY_PRODUCT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cf_box title="#getlang('','Yan Ürün','64086')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="upd_byproduct" action="#request.self#?fuseaction=product.emptypopup_upd_byproducts" method="post">
        <input type="hidden" name="byproduct_id" id="byproduct_id" value="<cfoutput>#attributes.id#</cfoutput>">
        <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
        <input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
        <cf_box_elements>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="form-group" id="item-component">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='63535.Bileşen'>- <cf_get_lang dictionary_id="58577.Sıra">/ <cf_get_lang dictionary_id="57692.İşlem"></label>
                    <div class="col col-8 col-xs-12">
                        <select name="component" id="component">
                            <option value=""><cf_get_lang dictionary_id="64095.İşlem Seçiniz"></option>
                            <option value="1" <cfif get_byproducts.COMPONENT eq 1>selected</cfif>><cf_get_lang dictionary_id="64083.Bekletme"></option>
                            <option value="2" <cfif get_byproducts.COMPONENT eq 2>selected</cfif>><cf_get_lang dictionary_id="63507.Ayrıştırma"></option>
                            <option value="3" <cfif get_byproducts.COMPONENT eq 3>selected</cfif>><cf_get_lang dictionary_id="64084.Süzme"></option>
                    </select> 
                    </div>
                </div>
                <cfif len(get_byproducts.related_stock_id)>
                <cfquery name="get_stocks" datasource="#dsn3#">
                    SELECT 
                        S.PRODUCT_NAME,
                        S.PROPERTY,
                        PU.MAIN_UNIT,
                        PU.ADD_UNIT
                    FROM 
                        STOCKS S,
                        PRODUCT_UNIT PU
                    WHERE
                        PU.PRODUCT_ID=S.PRODUCT_ID AND
                        S.STOCK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_byproducts.related_stock_id#"> AND
                        PU.IS_MAIN != 0
                </cfquery>
                </cfif>
                <div class="form-group" id="item-product">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'>- <cf_get_lang dictionary_id="57452.Stok"></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="related_stock_id" id="related_stock_id" value="<cfif len("get_byproducts.related_stock_id")><cfoutput>#get_byproducts.related_stock_id#</cfoutput></cfif>">
                            <input type="hidden" name="related_product_id" id="related_product_id" value="<cfif len("get_byproducts.related_product_id")><cfoutput>#get_byproducts.related_product_id#</cfoutput></cfif>">
                                <input type="text" name="product_name" id="product_name" value="<cfif len(get_byproducts.related_stock_id)><cfoutput>#get_stocks.PRODUCT_NAME#-#get_stocks.PROPERTY#</cfoutput></cfif>">
                            <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&stock_and_spect=1&field_spect_main_id=upd_byproduct.spect_main_id&field_spect_main_name=upd_byproduct.spect_main_name&field_id=upd_byproduct.related_stock_id&field_name=upd_byproduct.product_name&field_unit_name=unit&field_unit2=unit2&from_byprodcts=1&product_id=upd_byproduct.related_product_id')"></span>
                        </div>	
                    </div>
                </div>
                <div class="form-group" id="item-spec">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57647.Spec'>- <cf_get_lang dictionary_id='45880.Etiket'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="hidden" name="spect_main_name" id="spect_main_name" readonly="yes">
                                <input type="text" name="spect_main_id" id="spect_main_id" value="<cfif len("get_byproducts.spect_id")><cfoutput>#get_byproducts.spect_id#</cfoutput></cfif>" readonly>
                            <span class="input-group-addon icon-ellipsis btnPoniter" onclick="open_spec2();"></span>
                        </div>						
                    </div>
                </div>
                <div class="form-group" id="item-amount">
                    <label class="col col-4 col-xs-12">1.<cf_get_lang dictionary_id='57635.Miktar'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                    <input type="text" name="amount" id="amount" value="<cfif len("get_byproducts.amount")><cfoutput>#get_byproducts.amount#</cfoutput></cfif>">		
                    <span name="unit" id="unit" class="input-group-addon"><cfif len(get_byproducts.related_stock_id)><cfoutput>#get_stocks.MAIN_UNIT#</cfoutput></cfif></span>		
                    </div>
                </div>	
                </div>
                <div class="form-group" id="item-amount2">
                    <label class="col col-4 col-xs-12">2.<cf_get_lang dictionary_id='57635.Miktar'></label>
                    <div class="col col-8 col-xs-12">	
                        <div class="input-group">
                    <input type="text" name="amount2" id="amount2" value="<cfif len("get_byproducts.amount2")><cfoutput>#get_byproducts.amount2#</cfoutput></cfif>">		
                    <span name="unit2" id="unit2" class="input-group-addon"><cfif len(get_byproducts.related_stock_id)><cfoutput>#get_stocks.ADD_UNIT#</cfoutput></cfif></span>						
                    </div>
                </div>	
                </div>
                <div class="form-group" id="item-abh">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42999.A*b*h'></label>
                    <div class="col col-8 col-xs-12">                                        
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <input type="text" id="width" name="width" value="<cfif len("get_byproducts.width")><cfoutput>#get_byproducts.width#</cfoutput></cfif>">
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <input type="text" id="height" name="height" value="<cfif len("get_byproducts.height")><cfoutput>#get_byproducts.height#</cfoutput></cfif>">
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <input type="text" id="length" name="length" value="<cfif len("get_byproducts.length")><cfoutput>#get_byproducts.length#</cfoutput></cfif>">
                        </div>                                   					
                    </div>
                </div>
                <div class="form-group" id="item-detail">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57629.Açıklama"><cf_get_lang dictionary_id="57989.Ve"><cf_get_lang dictionary_id="52563.Detaylar"></label>
                    <div class="col col-8 col-xs-12">
                        <textarea style="height:50px;" name="detail" id="detail" maxlength="250"><cfif len("get_byproducts.detail")><cfoutput>#get_byproducts.detail#</cfoutput></cfif></textarea>
                    </div>
                </div>
            </div>
            </cf_box_elements>    
        <cf_box_footer>
            <cf_workcube_buttons is_upd='1' add_function="kontrol3()" is_delete="0">
        </cf_box_footer>
    </cfform>
</cf_box>
<script>
  function kontrol3()
	{
        if(upd_byproduct.related_stock_id.value!='' && upd_byproduct.related_product_id.value!='' && upd_byproduct.product_name.value!='')
            {
                if(filterNum(upd_byproduct.amount.value)>0 && filterNum(upd_byproduct.amount2.value)>0)
            {
                upd_byproduct.amount.value = filterNum(upd_byproduct.amount.value);
                upd_byproduct.amount2.value = filterNum(upd_byproduct.amount2.value);
                <cfoutput>#iif(isdefined("attributes.draggable"),DE("loadPopupBox('upd_byproduct' , #attributes.modal_id#);"),DE(""))#</cfoutput>
            }
                else
                {
                alert("<cf_get_lang dictionary_id='64094.Miktar 1 ve Miktar 2 Değerleri 0 dan Büyük Olmalı'>!");
                }
            }
        else{
            alert("<cf_get_lang dictionary_id='45986.Ürün Girmelisiniz'>!");
            }
        return false;
    }
    function open_spec2()
	{
		if(upd_byproduct.related_stock_id.value!='' && upd_byproduct.product_name.value!='')
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_name=upd_byproduct.spect_main_name&field_main_id=upd_byproduct.spect_main_id&stock_id='+upd_byproduct.related_stock_id.value,'list')
		else
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57657.Ürün'>");
	}
</script>
    