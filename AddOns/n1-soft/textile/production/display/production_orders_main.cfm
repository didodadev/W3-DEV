    <div class="row" type="row">
        <div class="col col-3 col-sm-6 col-xs-12" type="column" index="1" sort="true">
           
            <div class="form-group" id="item-is_demand">
                <label class="col col-3 col-xs-12">Üretim Emri No</label>
                <div class="col col-9 col-xs-12">
                    <input type="hidden" name="is_demand" id="is_demand" value="0"><input type="text" name="p_order_no" id="p_order_no" value="<cfoutput>#get_det_po.party_no#</cfoutput>" style="width:120px;">
                </div>
            </div>
            <div class="form-group" id="item-order_id_">
                <label class="col col-3 col-xs-12"><cf_get_lang_main no='799.Siparis No'></label>
                <div class="col col-9 col-xs-12">
                    <input type="hidden" name="order_id" id="order_id" value="<cfoutput>#valuelist(get_order_row.order_id,',')#</cfoutput>">
                    <input type="hidden" name="order_row_id" id="order_row_id" value="<cfif isdefined('GET_ORDER_ROW_1')><cfoutput>#valuelist(GET_ORDER_ROW_1.order_row_id,',')#</cfoutput></cfif>">
                    <input type="text" name="order_id_" id="order_id_" style="width:120px;" readonly="" value="<cfoutput>#valuelist(get_order_row.order_number,',')#</cfoutput>">
                </div>
            </div>
            <div class="form-group" id="item-lot_no">
                <label class="col col-3 col-xs-12"><cf_get_lang no='385.Lot No'></label>
                <div class="col col-9 col-xs-12">
                    <input type="text" name="lot_no" id="lot_no" style="width:120px;" value="<cfoutput>#get_det_po.lot_no#</cfoutput>">
                </div>
            </div>
            <div class="form-group" id="item-station_name">
                <label class="col col-3 col-xs-12"><cf_get_lang_main no='1422.İstasyon'></label>
                <div class="col col-9 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="station_id_1_0" id="station_id_1_0" value="<cfoutput>#get_det_po.station_id#</cfoutput>">
                        <input type="hidden" name="function_value_station" id="function_value_station" value="">
                        <input type="hidden" name="station_id" id="station_id" <cfif len(get_det_po.station_id) >value="<cfoutput>#get_det_po.station_id#</cfoutput>"<cfelse>value=""</cfif>>
                        <input type="text" name="station_name" id="station_name" style="width:120px;" readonly <cfif len(get_det_po.station_id)> value="<cfoutput>#get_w.station_name#</cfoutput>"</cfif> >
                        <div id="show_station" style=" display:none; position:absolute; margin-left:-200; margin-top:20;z-index:11;"></div>
                        <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="station_stock_control();"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-reference_no">
                <label class="col col-3 col-xs-12"><cf_get_lang_main no='1372.Referans'></label>
                <div class="col col-9 col-xs-12">
                    <input type="text" name="reference_no" id="reference_no" value="<cfoutput>#get_det_po.REFERENCE_NO#</cfoutput>" style="width:120px;">
                </div>
            </div>
            <div class="form-group" id="item-quantity">
                <label class="col col-3 col-xs-12"><cf_get_lang_main no='223.Miktar'></label>
                <div class="col col-9 col-xs-12">
                    <input type="hidden" name="dp_order_id" id="dp_order_id" value="<cfoutput>#get_det_po.dp_order_id#</cfoutput>">
                    		 <input type="hidden" name="party_id" id="party_id" value="<cfoutput>#attributes.party_id#</cfoutput>">
                    <cfinput type="hidden" name="old_quantity" id="old_quantity" value="#get_det_po_party.quantity#">
                    <cfinput type="text" name="quantity" id="quantity" required="Yes" maxlength="100" value="#tlformat(get_det_po_party.quantity,8)#" onkeyup="return(formatcurrency(this,event,8));" onBlur="aktar();" style="width:120px;">
                    <cfinput type="hidden" name="quantity_" id="quantity_" required="Yes" maxlength="100" value="#tlformat(get_det_po_party.quantity,8)#" onkeyup="return(formatcurrency(this,event,8));" onBlur="aktar();" style="width:120px;">
                </div>
            </div>
        </div>
        <div class="col col-5 col-sm-9 col-xs-12" type="column" index="2" sort="true">
            <div class="form-group" id="item-start_date">
                    <label class="col col-3 col-xs-12"><cf_get_lang_main no='89.Başlama'></label>
                    <div class="col col-4 col-xs-12">
                        <div class="input-group ">
                            <input type="hidden" name="_popup" id="_popup" value="2">
                            <cfinput required="Yes" type="text" name="start_date" id="start_date" validate="eurodate" style="width:63px;" value="#dateformat(get_det_po.start_date,'dd/mm/yyyy')#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                        </div>
                    </div>
                    <div class="col col-5 col-xs-12">
                        <div class="input-group">
                             <cfoutput>
                            <select name="start_h" id="start_h" style="width:39px;">
                                <cfloop from="0" to="23" index="i">
                                    <option value="#i#" <cfif timeformat(get_det_po.start_date,'HH') eq i> selected</cfif>><cfif i lt 10>0</cfif>#I#</option>
                                </cfloop>
                            </select>
                            <span class="input-group-addon no-bg"></span>
                            <select name="start_m" id="start_m" style="width:39px;">
                                <cfloop from="0" to="59" index="i">
                                    <option value="#i#" <cfif timeformat(get_det_po.start_date,'mm') eq i>selected</cfif>><cfif i lt 10>0</cfif>#I#</option>
                                </cfloop>
                            </select>
                            <input type="hidden" name="old_start_date" id="old_start_date" value="#get_det_po.start_date#"><!--- Silmeyiniz, sureclerde kullaniliyor FBS 20100513 --->
                            </cfoutput>
                             <span class="input-group-addon no-bg" style="width:13px"></span>
                        </div>
                    </div>
                </div>
            <div class="form-group" id="item-finish_date">
                    <label class="col col-3 col-xs-12"><cf_get_lang_main no='90.Bitiş'></label>
                    <div class="col col-4 col-xs-12">
                        <div class="input-group " >
                            <cfinput required="yes" type="text" name="finish_date" id="finish_date" validate="eurodate" style="width:63px;" value="#dateformat(get_det_po.finish_date,'dd/mm/yyyy')#">
                            <cfoutput>
                            <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                        </div>
                    </div>
                    <div class="col col-5 col-xs-12">
                        <div class="input-group">
                           <select name="finish_h" id="finish_h" style="width:39px;">
                                <cfloop from="0" to="23" index="I">
                                        <option value="#i#" <cfif timeformat(get_det_po.finish_date,'HH') eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>    
                                </cfloop>
                            </select>
                            <span class="input-group-addon no-bg"></span>
                            <select name="finish_m" id="finish_m" style="width:39px;">
                                <cfloop from="0" to="59" index="i">
                                        <option value="#i#" <cfif timeformat(get_det_po.finish_date,'mm') eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                </cfloop>
                            </select>
                            <input type="hidden" name="old_finish_date" id="old_finish_date" value="#get_det_po.finish_date#"><!--- Silmeyiniz, sureclerde kullaniliyor FBS 20100513 --->
                            </cfoutput>
                            <span class="input-group-addon catalyst-calculator bold btnPointer" onclick="calc_deliver_date();" title="<cf_get_lang no='182.Tarih Hesapla'>"></span>
                            </div>
                        <div style="position:absolute;z-index:9999999" id="deliver_date_info"></div>
                    </div>
                </div>
            <div class="form-group" id="item-stock_code">
                <label class="col col-3 col-xs-12"><cf_get_lang_main no='106.Stok Kodu'></label>
                <div class="col col-9 col-xs-12">
                    <input type="text" readonly="yes" name="stock_code" id="stock_code" value="<cfoutput>#get_det_po.stock_code#</cfoutput>" style="width:168px;">
                </div>
            </div>
            <div class="form-group" id="item-product_name">
                <label class="col col-3 col-xs-12"><cf_get_lang_main no='245.Ürün'></label>
                <div class="col col-9 col-xs-12">
                    <cfif isdefined("attributes.order_id")>
                        <script type="text/javascript">
                            temp_var = <cfoutput>#get_det_po.stock_id#</cfoutput>;
                        </script>
                        <input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#get_det_po.stock_id#</cfoutput>">
                        <input type="text" name="product_name" id="product_name" value="<cfoutput>#get_product_name(stock_id:get_det_po.stock_id)#</cfoutput>" readonly style="width:140px;">
                    <cfelse>
                        <input type="hidden" name="stock_id" id="stock_id" <cfif isdefined("attributes.upd")>value="<cfoutput>#get_det_po.stock_id#</cfoutput>"<cfelse>value=""</cfif> >
                        <input type="text" name="product_name" id="product_name" style="width:168px;" readonly <cfif isdefined("attributes.upd")>value="<cfoutput>#get_det_po.product_name# #get_det_po.property#</cfoutput>"</cfif>>
                    </cfif>        
                </div>
            </div>
            <div class="form-group" id="item-spect_main_id" style="display:none;">
                <label class="col col-3 col-xs-12"><cf_get_lang_main no='235.Spec'></label>
                <div class="col col-9 col-xs-12">
                    <div class="input-group">
                        <input type="text" style="width:30px;" name="spect_main_id" id="spect_main_id" value="<cfoutput>#get_det_po.spec_main_id#</cfoutput>"readonly>
                        <input type="hidden" style="width:33px;" name="old_spect_var_id" id="old_spect_var_id" value="<cfoutput>#get_det_po.spect_var_id#</cfoutput>"readonly>
                        <span class="input-group-addon no-bg"></span>
                        <input type="text" style="width:33px;" name="spect_var_id" id="spect_var_id" value="<cfoutput>#get_det_po.spect_var_id#</cfoutput>"readonly>
                        <span class="input-group-addon no-bg"></span>
                        <input type="text" name="spect_var_name" id="spect_var_name" value="<cfoutput>#get_det_po.spect_var_name#</cfoutput>" style="width:98px;" readonly>
                    </div>
                </div>
            </div>
            <cfif isdefined("is_show_result_amount") and is_show_result_amount eq 1>
            <div class="form-group" id="item-result_amount">
                <label class="col col-3 col-xs-12"><cfoutput>#getLang('prod',295)#​</cfoutput></label>
                <div class="col col-4 col-xs-12">
                   <cfinput type="text" name="result_amount" id="result_amount" maxlength="100" value="#tlformat(get_det_po.row_result_amount)#" readonly style="width:65px;">
                </div>
                <label class="col col-2 col-xs-12"><cf_get_lang_main no='1032.Kalan'></label>
                <div class="col col-3 col-xs-12">
                    <cfinput type="text" name="result_amount" id="result_amount" maxlength="100" value="#tlformat(get_det_po.quantity-get_det_po.row_result_amount)#" readonly style="width:70px;"> 
                </div>
            </div> 
            </cfif>       
        </div>
        <div class="col col-4 col-sm-9 col-xs-12" type="column" index="3" sort="true">
            <div class="form-group" id="item-status">
                <label class="col col-3 col-xs-12 "><span class="hide"><cf_get_lang_main no='344.Durum'></span></label>
                <div class="col col-9 col-xs-12">
                    <label>
                        <input type="checkbox" name="status" id="status" value="1" <cfif get_det_po.status eq 1>checked</cfif>><cf_get_lang_main no='81.Aktif'>
                    </label>
                    <label>
                        <input type="checkbox" name="stock_reserved" id="stock_reserved" value="1" <cfif get_det_po.is_stock_reserved eq 1>checked</cfif>> <cf_get_lang no='72.Stok Rezerve Et'><a href="javascript://" onclick="sayfa_getir();" ><img src="/images/alternative_list.gif" title="<cf_get_lang no='27.Durum ve Stok Rezerve Et Güncelle'>"></a><div id="status_div" style="display:none;"></div>
                    </label>
                    <label>
                        <input type="checkbox" style="display:none;" name="is_demontaj" id="is_demontaj" value="1" <cfif get_det_po.IS_DEMONTAJ eq 1>checked</cfif>> <!---<cf_get_lang no='547.Demontaj'>--->
                    </label>
                </div>
            </div>
            <div class="form-group" id="item-process">
                <label class="col col-3 col-xs-12"><cf_get_lang_main no='1447.Süreç'></label>
                <div class="col col-9 col-xs-12">
                    <cf_workcube_process is_upd='0' select_value='#get_det_po.prod_order_stage#' process_cat_width='140' is_detail='1'>
                </div>
            </div>
            <div class="form-group" id="item-project_id">
                <label class="col col-3 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
                <div class="col col-9 col-xs-12">
                    <cf_wrkProject
                    project_Id="#get_det_po.project_id#"
                    width="140"
                    AgreementNo="1" Customer="2" Employee="3" Priority="4" Stage="5"
                    boxwidth="600"
                    boxheight="400">
                </div>
            </div>
            <div class="form-group" id="item-work_head" style="display:none;">
                <label class="col col-3 col-xs-12"><cf_get_lang_main no='1033.İş'></label>
                <div class="col col-9 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="work_id" id="work_id" value="<cfif len(get_det_po.work_id)><cfoutput>#get_det_po.work_id#</cfoutput></cfif>">
                        <input type="text" name="work_head" id="work_head" style="width:140px;" value="<cfoutput><cfif len(get_det_po.work_id) and isnumeric(get_det_po.work_id)>#get_work_name(get_det_po.work_id)#</cfif></cfoutput>" onfocus="AutoComplete_Create('work_head','WORK_HEAD','WORK_HEAD','get_work','','WORK_ID','work_id','','3','110')">
                        <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='1279.iş listesi'>" onClick="pencere_ac_work();"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-detail">
                <label class="col col-3 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                <div class="col col-9 col-xs-12">
                    <textarea name="detail" id="detail" maxlength="500" onkeyup="return ismaxlength(this)" onblur="return ismaxlength(this);" message="500 Karakterden Fazla Yazmayınız!" style="width:140px;height:45px;"><cfoutput>#get_det_po.detail#</cfoutput></textarea>
                </div>
            </div>
        </div>
    </div>

<script type="text/javascript">
	function sayfa_getir()
	{
		if(document.add_production_order.status.checked == true) status_info = 1; else status_info = 0;
		if(document.add_production_order.stock_reserved.checked == true) stock_reserved_info = 1; else stock_reserved_info = 0;
		if(confirm("Güncelleme Yapılacak. Emin misiniz ?"))
		;
			<!---AjaxPageLoad('<cfoutput>#request.self#?fuseaction=prod.emptypopup_upd_production_orders_status&upd=#attributes.upd#</cfoutput>&status='+status_info+'&stock_reserved='+stock_reserved_info,'status_div');--->
	}
	function pencere_ac_work()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=all.work_id&field_name=all.work_head','list');
	}
	function station_stock_control()
	{
		<cfif isdefined('is_product_station_relation') and is_product_station_relation eq 1>
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_list_workstation&field_name=add_production_order.station_name&field_id=add_production_order.station_id&c=1&stock_id='+document.getElementById('stock_id').value+'','list');
		<cfelse>
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_list_workstation&field_name=add_production_order.station_name&field_id=add_production_order.station_id&c=1','list');
		</cfif>
	}
</script>
