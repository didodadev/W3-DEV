<!--- basket al ---> 
<cfset basket_data = cmp_basket.get_basket(attributes.basket_id)>
<cfset get_basket = basket_data>
<cfset sale_product = basket_data.PURCHASE_SALES>

<!--- tanımlar --->
<cfset numeric_columns = 'amount,amount2,amount_other,list_price,list_price_discount,tax_price,price,price_other,price_net,price_net_doviz,tax,OTV,duedate,number_of_installment,iskonto_tutar,ek_tutar,ek_tutar_price,ek_tutar_other_total,ek_tutar_cost,ek_tutar_marj,disc_ount,disc_ount2_,disc_ount3_,disc_ount4_,disc_ount5_,disc_ount6_,disc_ount7_,disc_ount8_,disc_ount9_,disc_ount10_,row_total,row_nettotal,row_taxtotal,row_otvtotal,row_lasttotal,other_money_value,other_money_gross_total,net_maliyet,extra_cost,extra_cost_rate,row_cost_total,marj,dara,darali,promosyon_yuzde,promosyon_maliyet,row_width,row_depth,row_height,row_bsmv_rate,row_bsmv_amount,row_bsmv_currency,row_oiv_rate,row_oiv_amount,row_tevkifat_rate,row_tevkifat_amount,otv_discount,row_specific_weight,row_volume'>
<cfset selectbox_columns = 'other_money,order_currency,reserve_type,basket_extra_info,select_info_extra,reason_code,unit2,delivery_condition,container_type,delivery_type,row_activity_id,row_tevkifat_id,otv_type'>
<cfset popup_columns = 'product_name,basket_acc_code,basket_exp_item,lot_no,price,deliver_dept,basket_row_departman,basket_exp_center,row_subscription_name,row_assetp_name,basket_project,basket_work,basket_employee,reserve_date,deliver_date,spec,shelf_number_txt,to_shelf_number_txt'>
<cfset non_inputs = 'is_promotion,is_price_total_other_money,is_amount_total,is_paper_discount,basket_cursor,barcode_price_list,barcode_amount,barcode_amount_2,barcode_stock_code,barcode_barcode,barcode_serial_no,barcode_lot_no,barcode_choose_row,is_member_selected,is_project_not_change,is_use_add_unit,is_member_not_change,is_project_selected,use_project_discount_,check_row_discounts,zero_stock_status,zero_stock_control_date,is_serialno_guaranty,is_risc,is_cash_pos,is_installment,price_total,Kdv,oiv,bsmv,otv_from_tax_price,is_specific_weight,use_configurator'>
<cfset hidden_column_list = "">
<cfif session.ep.price_display_valid eq 1>
    <cfset hidden_column_list = "Tax,OTV,tax_price,price_other,price_net,tax_price,price_net_doviz,price_total,other_money,List_price,Price,iskonto_tutar,ek_tutar,ek_tutar_other_total,disc_ount,disc_ount2_,disc_ount3_,disc_ount4_,disc_ount5_,disc_ount6_,disc_ount7_,disc_ount8_,disc_ount9_,disc_ount10_,row_total,row_taxtotal,row_nettotal,row_otvtotal,row_lasttotal,other_money_value,other_money_gross_total,marj,genel_indirim_">
</cfif>
<cfif session.ep.cost_display_valid eq 1>
    <cfset hidden_column_list = listAppend(hidden_column_list, 'net_maliyet,extra_cost')>
</cfif>
<cfset price_round_number = basket_data.price_round_number>
<cfset basket_data_hidden_column = cmp_basket.get_basket_visiblity(basket_data, hidden_column_list, 0)>
<cfset basket_data_display_column = cmp_basket.get_basket_visiblity(basket_data, hidden_column_list, 1)>
<cfset hidden_list = valueList(basket_data_hidden_column.title)>
<cfset display_list = valueList(basket_data_display_column.title)>
<cfset amount_list = "amount,amount_other">
<cfif len(basket_data.basket_total_round_number)>
    <cfset basket_total_round_number = basket_data.basket_total_round_number>
<cfelse>
    <cfset basket_total_round_number = session.ep.our_company_info.rate_round_num>
</cfif>
<cfif len(basket_data.basket_rate_round_number)>
    <cfset basket_rate_round_number = basket_data.basket_rate_round_number>
<cfelse>
    <cfset basket_rate_round_number = session.ep.our_company_info.rate_round_num>
</cfif>
<cfif len(basket_data.amount_round)>
    <cfset amount_round = basket_data.amount_round>
<cfelse>
    <cfset amount_round = session.ep.our_company_info.rate_round_num>
</cfif>
<cfif session.ep.DISCOUNT_VALID eq 1>
    <cfset basket_read_only_discount_list = "iskonto_tutar,disc_ount,disc_ount2_,disc_ount3_,disc_ount4_,disc_ount5_,disc_ount6_,disc_ount7_,disc_ount8_,disc_ount9_,disc_ount10_,genel_indirim">
<cfelse>
    <cfset basket_read_only_discount_list = "">
</cfif>
<cfset price_columns = "tax,OTV,tax_price,price,list_price_discount,set_row_duedate,price_other,ek_tutar,ek_tutar_price,ek_tutar_cost,ek_tutar_marj,ek_tutar_other_total,row_total,row_taxtotal,row_otvtotal,row_lasttotal,other_money_value,extra_cost_rate,row_cost_total,marj">
<cfset hesapla_columns = "amount,amount2,amount_other,price,price_other,price_net_doviz,tax,indirim1,indirim2,indirim3,indirim4,indirim5,indirim6,indirim7,indirim8,indirim9,indirim10,iskonto_tutar,other_money,otv,row_otvtotal,row_total,row_taxtotal,other_money_value,duedate,ek_tutar,ek_tutar_price,promosyon_yuzde,row_bsmv_rate,row_bsmv_amount,row_bsmv_currency,row_oiv_rate,row_oiv_amount,row_tevkifat_rate,row_tevkifat_amount,list_price_discount,disc_ount,disc_ount2_,disc_ount3_,disc_ount4_,disc_ount5_,disc_ount6_,disc_ount7_,disc_ount8_,disc_ount9_,disc_ount10_,row_specific_weight,row_volume,row_width,row_height,row_depth">
<!--- 1305.Acik, 1948.Tedarik, 1949.Kapatıldı, 1950.Kısmi Üretim, 44.Üretim, 1349.Sevk, 1951.Eksik Teslimat, 1952.Fazla Teslimat, 1094.İptal, 1211.Kapatıldı(Manuel) --->
<cfset order_currency_list = "#getLang('main',1305)#,#getLang('main',1948)#,#getLang('main',1949)#,#getLang('main',1950)#,#getLang('main',44)#,#getLang('main',1349)#,#getLang('main',1951)#,#getLang('main',1952)#,#getLang('main',1094)#,#getLang('main',1211)#">
<!--- 1953.Rezerve, 1954.Kısmi Rezerve, 1955.Rezerve Degil, 1956.Rezerve Kapatıldı --->
<cfset reserve_type_list = "#getLang('main',1953)#,#getLang('main',1954)#,#getLang('main',1955)#,#getLang('main',1956)#">

<div id="basket-container" basket-content>
    <div id="basketIframe">
        <iframe 
            name="_add_prod_" 
            id="_add_prod_" 
            frameborder="0" 
            vspace="0" 
            hspace="0" 
            scrolling="no" 
            src="<cfoutput>#request.self#?fuseaction=objects.add_basket_row_from_barcod&isAjax=1&amount_round_number=#amount_round#&is_sale_product=#sale_product#&int_basket_id=#attributes.basket_id#<cfloop query="get_money_bskt">&#money_type#=#rate2/rate1#</cfloop></cfoutput>&iframe=1<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>&is_store_module=1</cfif>&ajax_box_page=1"  
            width="100%"
            style="min-height:40px; height:40px;"></iframe>
    </div>		
    <input type="hidden" id="basket_id" name="basket_id" data-bind="value: window.basketService.get('basket_id')">
    <div id="sepet_table">
        <div class="row" id="basket_tr">
            <div id="basketBox" class="col-12 col-md-12 col-sm-12 col-xs-12">
                <div id="sepetim" style="width: 100%; overflow: visible;">
                    <div class="ui-scroll">
                        <table class="ui-table-list ui-form" id="tblBasket">
                            <thead>
                                <tr>
                                    <th style="width: 20px;"><cf_get_lang dictionary_id="57487.No"></th>
                                    <th style="width: 120px;">
                                        <ul class="ui-icon-list">
                                            <li><a href="javascript:void(0)" data-bind="click: function() { control_comp_selected(0,0); }"><i class="fa fa-plus"></i></a></li>
                                            <cfif listFindNoCase(display_list, "use_configurator")><li><a href="javascript:void(0)" data-bind="click: function() { control_comp_selected(0,0,1); }"><i class="fa fa-puzzle-piece"></i></a></li></cfif>
                                        </ul>
                                    </th>
                                    <!-- ko foreach: $root.basketHeadersForVisible -->
                                    <th data-bind="attr: { style: isNumeric == true ? 'text-align:right;min-width:'+width+'px' : 'min-width:' + width + 'px', class: isMobile == true ? 'is_mobile' : '' }" >
                                        <span>
                                            <span data-bind="text: title"></span>
                                            <!-- ko if: id.indexOf('duedate') >= 0 -->
                                            <input type="text" data-bind="value: $root.duedate, attr: { style: 'width: ' + width.toString() + 'px' }, readonly: isReadonly, event: { blur: $root.onDuedateBlur, focus: $root.onDuedateFocus }">
                                            <!-- /ko -->
                                            <!-- ko if: id.indexOf('disc_ount') >= 0 -->
                                                <input type="text" data-bind="tlValue: $root.discount[id], attr: { style: 'width: ' + width.toString() + 'px' }, event : { blur : function() { apply_discount( $data.id ) } } ">
                                            <!-- /ko -->
                                        </span>
                                    </th>
                                    <!-- /ko -->
                                </tr>
                            </thead>
                            <tbody>
                            <!-- ko foreach: $root.basketItemsView -->
                            <!-- ko if: $root.activeRowIndex() != index -->
                            <tr data-bind="event: { click: function(elm, ev) { $root.activeColIndex(ev.target.cellIndex === undefined ? ev.target.parentElement.cellIndex - 2 : ev.target.cellIndex - 2); $root.activeRowIndex(index); } }">
                                <td><span data-bind="text: index+1"></span></td>
                                <td>
                                    <ul class="ui-icon-list">
                                        <li><a href="javascript:void(0)" data-bind="click: function() { window.row_minus_cb(index); }"><i class="fa fa-minus"></i></a></li>
                                        <li><a href="javascript:void(0)" data-bind="click: function() { copy_row($data.items); }"><i class="fa fa-copy"></i></a></li>
                                        <li><a href="javascript:void(0)" data-bind="click: function() { control_comp_selected(index); }"><i class="fa fa-pencil"></i></a></li>
                                        <cfif listfind("11,12,47,48,1,20,2,18,31,32,11,15,17,47,49,10,14",attributes.basket_id,",") and (isdefined("attributes.event") and ( attributes.event is 'add' or attributes.event is 'upd'))>
                                            <!-- ko if: items.is_serial_no() == 1 -->
                                            <li><a href="javascript:void(0)" data-bind="click: function() { add_seri_no(index,'<cfoutput>#getlang('','Ürün İçin Seri No Takibi Yapılıyor','41874')# #getlang('','Seri no eklemeden önce belgeyi kaydedin','61117')#</cfoutput>'); }"><i class="fa fa-barcode"></i></a></li>
                                            <!-- /ko -->
                                        </cfif>
                                    </ul>
                                </td>
                                <!-- ko foreach: $root.basketHeadersForVisible -->
                                <!-- ko if: !$data.isLV -->
                                <td data-bind="attr: { class: isMobile == true ? 'is_mobile' : '' }" ><div data-bind="basketElement: $parent.items[$data.id], numeric: $data.isNumeric, required: $data.isRequired"></div></td>
                                <!-- /ko -->
                                <!-- ko if: $data.isLV -->
                                <td data-bind="attr: { class: isMobile == true ? 'is_mobile' : '' }" ><div data-bind="basketElement: $parent.items['displayfor_' + $data.id], numeric: $data.isNumeric"></div></td>
                                <!-- /ko -->
                                <!-- /ko -->
                            </tr>
                            <!-- /ko -->
                            <!-- ko if: $root.activeRowIndex() == index -->
                            <tr>
                                <td><span data-bind="text: index+1"></span></td>
                                <td>
                                    <ul class="ui-icon-list">
                                        <li><a href="javascript:void(0)" data-bind="click: function() { window.row_minus_cb(index); }"><i class="fa fa-minus"></i></a></li>
                                        <li><a href="javascript:void(0)" data-bind="click: function() { copy_row($data.items); }"><i class="fa fa-copy"></i></a></li>
                                        <li><a href="javascript:void(0)" data-bind="click: function() { control_comp_selected(index); }"><i class="fa fa-pencil"></i></a></li>
                                        <cfif listfind("11,12,47,48,1,20,2,18,31,32,11,15,17,47,49,10,14",attributes.basket_id,",") and (isdefined("attributes.event") and ( attributes.event is 'add' or attributes.event is 'upd'))>  
                                        <!-- ko if: items.is_serial_no() == 1 -->
                                        <li><a href="javascript:void(0)" data-bind="click: function() { add_seri_no(index,'<cfoutput>#getlang('','Ürün İçin Seri No Takibi Yapılıyor','41874')# #getlang('','Seri no eklemeden önce belgeyi kaydedin','61117')#</cfoutput>'); }"><i class="fa fa-barcode"></i></a></li>
                                        <!-- /ko -->
                                        </cfif>
                                    </ul>
                                </td>
                                <!-- ko foreach: $root.basketHeadersForVisible -->
                                <td data-bind="attr: { class: isMobile == true ? 'is_mobile' : '' }">
                                    <div class="form-group" >
                                        <!-- ko if: !$data.isLV && !$data.isPopup -->
                                        <input data-bind="basketValue: $parent.items[$data.id], readonly: $data.isReadonly, numeric: $data.isNumeric, required: $data.isRequired">
                                        <!-- /ko -->
                                        <!-- ko if: $data.isLV -->
                                        <div class="input-group widFull">
                                            <input type="text" data-bind="basketValue: $parent.items['displayfor_' + $data.id]" readonly>
                                            <span class="input-group-addon icon-ellipsis" style="padding-right:1px !important;padding-left:5px !important;" data-bind="click: function() { window.popup_factory($data.id, $parent.items[$data.id], $parent.items,$data.title); }"></span>
                                        </div>
                                        <!-- /ko -->
                                        <!-- ko if: $data.isPopup -->
                                        <div class="input-group widFull">
                                            <input type="text" data-bind="basketValue: $parent.items[$data.id], readonly: $data.isReadonly, numeric: $data.isNumeric, required: $data.isRequired">
                                            <!-- ko foreach: window.tripoint_factory($data.id, $parent.items) -->
                                            <span class="input-group-addon" style="padding-right:1px !important;padding-left:5px !important;" >
                                                <i data-bind="click: function() { window.popup_factory($data.name, $parents[1]) }, attr: { class: $data.icon }"></i>
                                            </span>
                                            <!-- /ko -->
                                        </div>
                                        <!-- /ko -->
                                    </div>
                                </td>
                                <!-- /ko -->
                            </tr>
                            <!-- /ko -->
                            <!-- /ko -->
                            </tbody>
                        </table>
                    </div>
                    <div class="ui-pagination basket_row_count" id="basket_money_totals_table">
                        <div class="pagi-left basket_row_button">
                            <ul data-bind="visible: NeedPaging">
                                <li class="pagesButtonPassive" data-bind="css: { disabled: !FirstPageActive() }, style: { cursor : 'pointer' }">
                                    <a data-bind="click: function() { GoToPage('first') }; "><i class="fa fa-angle-double-left"></i></a>
                                </li>
                                <li class="pagesButtonPassive" data-bind="css: { disabled: !PreviousPageActive() }, style: { cursor : 'pointer' }">
                                    <a data-bind="click: function() { GoToPage('prev') } "><i class="fa fa-angle-left"></i></a>
                                </li>
                                <!-- ko foreach: $root.GetPages -->
                                <li class="pagesButtonPassive" data-bind="css: { active: $root.CurrentPage() === $data }, style: { cursor : 'pointer' }">
                                    <a data-bind="click: $root.GoToPage, text: $data"></a>
                                </li>
                                <!-- /ko -->
                                <li class="pagesButtonActive" data-bind="css: { disabled: !NextPageActive() }, style: { cursor : 'pointer' }">
                                    <a data-bind="click: function() { GoToPage('next') } "><i class="fa fa-angle-right"></i></a>
                                </li>
                                <li data-bind="css: { disabled: !LastPageActive() }, style: { cursor : 'pointer' }">
                                    <a data-bind="click: function() { GoToPage('last') } "><i class="fa fa-angle-double-right"></i></a>
                                </li>
                            </ul>
                        </div>
                        <div class="rowCountText">
                          <span class="txtbold"><b><cf_get_lang dictionary_id="44423.Satır Sayısı"></b>: </span><span id="itemCount" class="txtbold" data-bind="text: basketManagerObject.basketItems().length"></span>
                          <span class="txtbold"><b><cf_get_lang dictionary_id="57581.Sayfa"></b>: </span><span id="itemPageCount" class="txtbold" data-bind="text: basketManagerObject.generateAllPages().length"></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="ui-row">
                <div id="sepetim_total_table_tutar_tr">
                    <div id="sepetim_total" class="padding-0">
                        <!-- ko if: basketService.get("wmo_module") == "invoice" && [1,2,3,4,10,14,18,20,21,33,42,43,51,52].indexOf(basketService.get("basket_id")) >= 0 -->
                        <!-- ko if: $root.basketFooter.general_prom_id() != '' || $root.basketFooter.free_prom_stock_id() != '' -->
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                            <div class="totalBox">
                                <table cellspacing="0">
                                    <tbody>
                                        <td valign="top">
                                            <!-- ko if: $root.basketFooter.general_prom_id() != '' -->
                                            <a href="#" data-bind="click: general_prom_detail_cb"><b><cf_get_lang dictionary_id="57492.Toplama"> <cf_get_lang dictionary_id="58560.İndirim"></b></a>
                                            <br/>
                                            <br/>
                                            <cf_get_lang dictionary_id ='58775.Alışveriş Miktarı'>
                                            <input type="text" data-bind="tlValue: $root.basketFooter.general_prom_limit" class="box" readonly>
                                            <br/>
                                            <cf_get_lang dictionary_id ='58560.İndirim '>
                                            %
                                            <input type="text" data-bind="tlValue: $root.basketFooter.general_prom_discount" class="box" readonly>
                                            <br/>
                                            <cf_get_lang dictionary_id ='57649.Toplam İndirim'>
                                            <input type="text" data-bind="tlValue: $root.basketFooter.general_prom_amount" class="box" readonly>
                                            <!-- /ko -->
                                            <!-- ko if: $root.basketFooter.free_prom_stock_id() != '' -->
                                            <a href="#" data-bind="click: free_prom_detail_cb"><b><cf_get_lang dictionary_id="58863.İndirim Bedava Ürün"></b></a>
                                            <br/>
                                            <br/>
                                            <cf_get_lang dictionary_id ='58775.Alışveriş Miktarı'>
                                            <input type="text" data-bind="tlValue: $root.basketFooter.free_prom_limit" class="box" readonly>
                                            <br/>
                                            <cf_get_lang dictionary_id ='58776.Kazanılan Ürün'>
                                            <cf_get_lang dictionary_id="58527.ID"> 
                                            <input type="text" data-bind="value: $root.basketFooter.free_prom_stock_id" class="box" readonly>
                                            <br/>
                                            <cf_get_lang dictionary_id ='58777.Ürün Miktarı'>
                                            <input type="text" data-bind="tlValue: $root.basketFooter.free_prom_amount" class="box" readonly>
                                            <br/>
                                            <cf_get_lang dictionary_id ='58778.Ürün Fiyatı'>
                                            <input type="text" data-bind="tlValue: $root.basketFooter.free_prom_stock_price" class="box" readonly>
                                            <input type="text" data-bind="value: $root.basketFooter.free_prom_stock_money" class="boxtext" readonly>
                                            <!-- /ko -->
                                        </td>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <!-- /ko -->
                        <!-- /ko -->
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                            <div class="totalBox">
                                <div class="totalBoxHead font-grey-mint">
                                    <span class="headText"><cf_get_lang dictionary_id='57677.Dövizler'></span>
                                    <div class="collapse">
                                        <span class="icon-minus"></span>
                                    </div>
                                </div>
                                <div class="totalBoxBody">
                                    <input type="hidden" id="kur_say" name="kur_say" data-bind="value: $root.basketFooter.kur_say">
                                    <table cellspacing="0">
                                        <tbody>
                                            <!-- ko foreach: window.basketService.get("basket_money_list") -->
                                            <tr>
                                                <input type="hidden" data-bind="attr:{'id':'hidden_rd_money_'+($index()+1),'name':'hidden_rd_money_'+($index()+1)}, value: MONEY_TYPE">
                                                <input type="hidden" data-bind="attr:{'id':'txt_rate1_'+($index()+1),'name':'txt_rate1_'+($index()+1)}, value: RATE1">
                                                <td nowrap="nowrap">
                                                    <input type="radio" name="basket_money_item" data-bind="checkedValue: MONEY_TYPE, checked: $root.basketFooter.basket_money">
                                                </td>
                                                <td nowrap="nowrap" data-bind="text: MONEY_TYPE()"></td>
                                                <td nowrap="nowrap" data-bind="text: RATE1() + ' /'"></td>
                                                <td nowrap="nowrap">
                                                    <input type="text" class="box" style="width: 100%" data-bind="attr:{'id':'txt_rate2_'+($index()+1),'name':'txt_rate2_'+($index()+1)}, tlValue: RATE2">
                                                </td>
                                            </tr>
                                            <!-- /ko -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                            <div class="totalBox">
                                <div class="totalBoxHead font-grey-mint">
                                    <span class="headText"> <cf_get_lang dictionary_id='57492.Toplam'> </span>
                                    <div class="collapse">
                                        <span class="icon-minus"></span>
                                    </div>
                                </div>
                                <div class="totalBoxBody">
                                    <table cellspacing="0">
                                        <tbody>
                                            <tr>
                                                <td class="txtbold" style="width: 40%;"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                                <td style="width: 30%; text-align: right;"><span data-bind="basketFooterTotalElement: $root.basketFooter.basket_gross_total"></span></td>
                                                <td style="width: 30%; text-align: right;"><span data-bind="basketFooterTotalElement: $root.basketFooter.total_wanted"></span></td>
                                            </tr>
                                            <!-- ko if: window.basketService.get("wmo_module") == "invoice" && [1,2,3,4,5,10,14,18,20,21,33,38,42,43,46,51,52].indexOf(window.basketService.get("basket_id")) >= 0 -->
                                                <!-- ko if: window.basketService.get("display_list").indexOf('is_paper_discount') >= 0 -->
                                                    <tr>
                                                        <td nowrap="nowrap" class="txtbold" style="width: 40%;"><cf_get_lang dictionary_id='57678.Fatura Altı İndirim'> <cf_get_lang dictionary_id="58716.KDV'li"></td>
                                                        <td style="width: 30%; text-align: right;">
                                                            <input class="box" type="text" style="width: 70%" data-bind="tlValue: $root.basketFooter.genel_indirim_kdvli_hesap, basketFormula: window.kdvli_net_indirim_hesapla"><a href="javascript://" onclick="alert('Bu alana yazılan tutar döviz kuruna oranlanarak fatura altı indirim alanının hesaplama yapmasını sağlar.');"><i class="fa fa-question"></i></a>
                                                        </td>
                                                        <td style="width: 30%; text-align: right;">
                                                            <input class="box" type="text" style="width: 70%" data-bind="tlValue: $root.basketFooter.genel_indirim_doviz_net_hesap, basketFormula: window.kdvli_doviz_indirim_hesapla"><a href="javascript://" onclick="alert('Bu alana yazılan tutar döviz kuruna oranlanarak fatura altı indirim alanının hesaplama yapmasını sağlar.');"><i class="fa fa-question"></i></a>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td nowrap="nowrap" class="txtbold" style="width: 40%"><cf_get_lang dictionary_id='57678.Fatura Altı İndirim'></td>
                                                        <td style="width: 30%; text-align: right;">
                                                            <input class="box" type="text" style="width:70%" data-bind="tlValue: $root.basketFooter.genel_indirim, basketFormula: genelIndirimHesapla, enabled: window.basketService.get('basket_read_only_discount_list').indexOf('genel_indirim') >= 0">
                                                        </td>
                                                        <td style="width: 30%; text-align: right;">
                                                            <input class="box" type="text" style="width:70%" data-bind="tlValue: $root.basketFooter.genel_indirim_doviz_brut_hesap, basketFormula: genelIndirimHesapla">
                                                        </td>
                                                    </tr>
                                                <!-- /ko -->
                                            <!-- /ko -->
                                            <!-- ko if: [1,20,42,43].indexOf(window.basketService.get("basket_id")) >= 0 -->
                                            <tr>
                                                <td class="txtbold" style="width: 40%;"><cf_get_lang dictionary_id='57710.Yuvarlama'></td>
                                                <td style="text-align: right; width: 30%;">
                                                    <input type="text" class="box" style="width: 100%;" data-bind="tlValue: $root.basketFooter.yuvarlama, basketFormula: window.yuvarlama">
                                                </td>
                                                <td style="text-align: right; width: 30%;">
                                                    <input type="text" class="box" data-bind="tlValue: $root.basketFooter.yuvarlama_doviz, basketFormula: window.yuvarlama_doviz_hesapla" style="width: 70%;">
                                                    <a href="javascript://" onclick="alert('Bu alana yazılan tutar döviz kuruna oranlanarak yuvarlama alanının hesaplama yapmasını sağlar');"><i class="fa fa-question"></i></a>
                                                </td>
                                            </tr>
                                            <!-- /ko -->
                                            <tr>
                                                <td class="txtbold" style="width: 40%;"><cf_get_lang dictionary_id='57649.Toplam İndirim'></td>
                                                <td style="width: 30%; text-align: right;"><span data-bind="basketFooterTotalElement: $root.basketFooter.basket_discount_total"></span></td>
                                                <td style="width: 30%; text-align: right;"><span data-bind="basketFooterTotalElement: $root.basketFooter.total_discount_wanted"></span></td>
                                            </tr>
                                            <tr>
                                                <td class="txtbold" style="width: 40%;"><cf_get_lang dictionary_id="30024.KDVsiz"> <cf_get_lang dictionary_id="57492.Toplam"></td>
                                                <td style="width: 30%; text-align: right;"><span data-bind="basketFooterTotalElement: $root.basketFooter.brut_total_default"></span></td>
                                                <td style="width: 30%; text-align: right;"><span data-bind="basketFooterTotalElement: $root.basketFooter.brut_total_wanted"></span></td>
                                            </tr>
                                            <tr>
                                                <td class="txtbold" style="width: 40%;"><cf_get_lang dictionary_id='57643.Toplam KDV'></td>
                                                <td style="width: 30%; text-align: right;"><span data-bind="basketFooterTotalElement: $root.basketFooter.basket_tax_total"></span></td>
                                                <td style="width: 30%; text-align: right;"><span data-bind="basketFooterTotalElement: $root.basketFooter.total_tax_wanted"></span></td>
                                            </tr>
                                            <!-- ko if: window.basketManager.hasShownItem("otv") -->
                                            <tr>
                                                <td class="txtbold" style="width: 40%;"><cf_get_lang dictionary_id='58021.ÖTV'></td>
                                                    <td style="width: 30%; text-align: right;"><span data-bind="basketFooterTotalElement: $root.basketFooter.basket_otv_total"></span></td>
                                                    <td style="width: 30%; text-align: right;"><span data-bind="basketFooterTotalElement: $root.basketFooter.total_otv_wanted"></span></td>
                                            </tr>
                                            <!-- /ko -->
                                            <!-- ko if: window.basketManager.hasShownItem("row_oiv_rate") -->
                                            <tr>
                                                <td class="txtbold" style="width: 40%;"><cf_get_lang dictionary_id="50982.öiv"></td>
                                                    <td style="width: 30%; text-align: right;"><span data-bind="basketFooterTotalElement: $root.basketFooter.total_oiv"></span></td>
                                                    <td style="width: 30%; text-align: right;"><span data-bind="basketFooterTotalElement: $root.basketFooter.total_oiv_wanted"></span></td>
                                            </tr>
                                            <!-- /ko -->
                                            <!-- ko if: window.basketManager.hasShownItem("row_bsmv_rate") -->
                                            <tr>
                                                <td class="txtbold" style="width: 40%;"><cf_get_lang dictionary_id="50923.BSMV"></td>
                                                    <td style="width: 30%; text-align: right;"><span data-bind="basketFooterTotalElement: $root.basketFooter.total_bsmv"></span></td>
                                                    <td style="width: 30%; text-align: right;"><span data-bind="basketFooterTotalElement: $root.basketFooter.total_bsmv_wanted"></span></td>
                                            </tr>
                                            <!-- /ko -->
                                            <tr style="height: 20px;"><td colspan="3">&nbsp;</td></tr>
                                            <tr>
                                                <td class="txtbold" style="width: 40%;"><cf_get_lang dictionary_id='51316.KDVli Toplam'></td>
                                                <td style="width: 30%; text-align: right;"><span data-bind="basketFooterTotalElement: $root.basketFooter.basket_net_total"></span></td>
                                                <td style="width: 30%; text-align: right;"><span data-bind="basketFooterTotalElement: $root.basketFooter.net_total_wanted"></span></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                            <div class="totalBox">
                                <div class="totalBoxHead font-grey-mint">
                                    <span class="headText"> <cf_get_lang dictionary_id='59181.Vergi'></span>
                                    <div class="collapse">
                                        <span class="icon-minus"></span>
                                    </div>
                                </div>
                                <div class="totalBoxBody">
                                    <table cellspacing="0">
                                        <tbody>
                                            <tr>
                                                <td colspan="3">
                                                    <!-- ko foreach: $root.basketFooter.general_taxs -->
                                                   <cf_get_lang dictionary_id="57639.KDV">  %<span data-bind="text: rate"></span> <span data-bind="basketFooterTotalElement: total"></span>
                                                    <!-- /ko -->
                                                </td>
                                            </tr>
                                            <!-- ko if: $root.basketFooter.general_otv().length > 0 -->
                                            <tr>
                                                <td colspan="3">
                                                    <!-- ko if: basketService.get("otv_calc_type") == '' -->
                                                    <cf_get_lang dictionary_id="58021.ÖTV"> 
                                                        <!-- ko foreach: $root.basketFooter.general_otv -->
                                                        % <span data-bind="text: rate"></span> <span data-bind="basketFooterTotalElement: total"></span>
                                                        <!-- /ko -->
                                                    <!-- /ko -->
                                                    <!-- ko if: basketService.get("otv_calc_type") == 1 -->
                                                    <cf_get_lang dictionary_id="58021.ÖTV"> 
                                                        <!-- ko foreach: $root.basketFooter.general_otv -->
                                                        <span data-bind="text: rate"></span> <span data-bind="basketFooterTotalElement: total"></span>
                                                        <!-- /ko -->
                                                    <!-- /ko -->
                                                </td>
                                            </tr>
                                            <!-- /ko -->
                                                <!-- ko if: $root.basketFooter.TotalOtvDiscount() != 0 -->
                                                <tr>
                                                <td colspan="3">
                                                    <cf_get_lang dictionary_id="62820.ÖTV indirimi">   : <span data-bind="text: $root.basketFooter.TotalOtvDiscount()"></span>
                                                </td>
                                            </tr>
                                            <!-- /ko -->
                                            <!-- ko if: $root.basketFooter.totalOivAmount().length > 0 -->
                                            <tr>
                                                <td colspan="3">
                                                    <!-- ko foreach: $root.basketFooter.totalOivAmount -->
                                                    <cf_get_lang dictionary_id="64355.OIV">   %<span data-bind="text: rate"></span> <span data-bind="basketFooterTotalElement: amount"></span>
                                                    <!-- /ko -->
                                                </td>
                                            </tr>
                                            <!-- /ko -->
                                            <!-- ko if: $root.basketFooter.totalBsmvAmount -->
                                            <tr>
                                                <td colspan="3">
                                                    <!-- ko foreach: $root.basketFooter.totalBsmvAmount -->
                                                    <cf_get_lang dictionary_id="50923.BSMV">  %<span data-bind="text: rate"></span> <span data-bind="basketFooterTotalElement: amount"></span>
                                                    <!-- /ko -->
                                                </td>
                                            </tr>
                                            <!-- /ko -->
                                            <!---
                                                <!-- ko if: [1,2,18,20,33,42,43].indexOf(basketService.get("basket_id")) >= 0 -->
                                                <tr>
                                                    <td>
                                                        <input type="hidden" id="tevkifat_id" name="tevkifat_id" value="">
                                                        <input type="checkbox" data-bind="checked: $root.basketFooter.tevkifat_box" onclick="gizle_goster(tevkifat_oran);gizle_goster(tevkifat_plus);">
                                                        <cfif not isdefined("attributes.is_retail")><cf_get_lang dictionary_id='58022.Tevkfat'></cfif>
                                                        <input type="text" data-bind="tlValue: $root.basketFooter.tevkifat_oran" id="tevkifat_oran" readonly class="box" style="display:none;">
                                                        <input type="hidden" id="temp_tevkifat_oran" value="">
                                                        <a style="display:none;cursor:pointer" id="tevkifat_plus" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_tevkifat_rates&field_tevkifat_rate_id=tevkifat_id&field_tevkifat_rate=temp_tevkifat_oran&call_function=tevkifat_hesapla()</cfoutput>','list')"> <i class="fa fa-plus"></i></a>
                                                    </td>
                                                </tr>      
                                                <!-- /ko -->
                                            --->
                                            <!-- ko if: ["form_copy_bill","form_add_bill","detail_invoice_sale","add_sale_invoice_from_order","form_add_bill_from_ship","form_add_bill_other","detail_invoice_other","form_add_bill_purchase","detail_invoice_purchase","form_copy_bill_purchase","add_purchase_invoice_from_order"].indexOf(basketService.get("wmo_action")) >= 0 -->
                                            <tr>
                                                <td class="txtbold" colspan="3">
                                                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stoppage_rates&field_stoppage_rate=form_basket.temp_stopaj_yuzde&field_stoppage_rate_id=form_basket.temp_stopaj_rate_id&field_decimal=#basket_data.basket_total_round_number#&call_function=stopaj_hesapla()</cfoutput>','list')"><i class="fa fa-plus" title="Stopaj Oranları"></i></a>
                                                    <cf_get_lang dictionary_id='57711.Stopaj'>%
                                                    <input type="text" data-bind="tlValue: $root.basketFooter.stopaj_yuzde" class="box" style="width: 75px;">
                                                    <input type="text" data-bind="tlValue: $root.basketFooter.stopaj" class="box" style="width: 75px;">
                                                    <input type="hidden" id="temp_stopaj_rate_id" value="">
                                                    <input type="hidden" id="temp_stopaj_yuzde" value="">
                                                </td>
                                            </tr>

                                            <tr>
                                                <td class="txtbold" colspan="3">
                                                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_exceptions&field_exc_id=form_basket.exc_id&field_exc_code=form_basket.temp_exc_code&field_exc_article=form_basket.temp_exc_article</cfoutput>&call_function=return_istisna()','list')"><i class="fa fa-plus"></i></a>
                                                    <cf_get_lang dictionary_id="60107.İstisnalar">
                                                    <input type="text" data-bind="value: $root.basketFooter.exc_code" class="box" style="width: 75px;" placeholder="Kod">
                                                    <input type="text" data-bind="value: $root.basketFooter.exc_article" class="box" style="width: 75px;" placeholder="Madde">
                                                    <input type="hidden" id="exc_id" name="exc_id" value="">
                                                    <input type="hidden" id="temp_exc_code" value="">
                                                    <input type="hidden" id="temp_exc_article" value="">
                                                </td>
                                            </tr>
                                            <!-- /ko -->
                                            <!-- ko if: $root.basketFooter.tev_kdv_list().length > 0 -->
                                            <tr>
                                                <td colspan="3">
                                                    <font class="txtbold"><cf_get_lang dictionary_id='58022.Tevkifat'>
                                                    <!-- ko foreach: $root.basketFooter.tev_kdv_list -->
                                                    <b data-bind="text: '%' + rate"></b>: <span data-bind="basketFooterTotalElement: total"></span>
                                                    <!-- /ko -->
                                                    </font>
                                                <td>
                                            </tr>
                                            <!-- /ko -->
                                            <!-- ko if: $root.basketFooter.bey_kdv_list().length > 0 -->
                                            <tr>
                                                <td colspan="3">
                                                    <font class="txtbold"><cf_get_lang dictionary_id='58024.Beyan Edilen'>
                                                    <!-- ko foreach: $root.basketFooter.bey_kdv_list -->
                                                    <b data-bind="text: '%' + rate"></b>: <span data-bind="basketFooterTotalElement: total"></span>
                                                    <!-- /ko -->
                                                    </font>
                                                <td>
                                            </tr>
                                            <!-- /ko -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- ko if: basketService.get("is_retail") > 0 -->
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" id="basket_money_totals_table">
                            <div class="totalBox">
                                <div class="totalBoxHead font-grey-mint">
                                    <span class="headText"><cf_get_lang dictionary_id='57673.Tutar'></span>
                                    <div class="collapse"><span class="icon-minus"></span></div>
                                </div>
                                <div class="totalBoxBody">
                                        <!-- ko if: $root.basketFooter.cash_list().length > 0 -->
                                            <div class="col col-4">
                                                <label class="col col-12 col-xs-12 txtbold text-center" style="margin-top: 10px;"><cf_get_lang dictionary_id='57673.Tutar'> - <cf_get_lang dictionary_id='58645.Nakit'></label>
                                            </div>
                                            <div class="col col-8">
                                                <label class="col col-12 col-xs-12 txtbold text-center" style="margin-top: 10px;"><cf_get_lang dictionary_id='57520.Kasa'></label>
                                            </div>
                                        <!-- /ko -->
                                        <!-- ko foreach: $root.basketFooter.cash_list -->
                                        <div class="col col-12">
                                            <div class="col col-4">
                                                <div class="form-group">
                                                    <input type="hidden" data-bind="value: $data.system_cash_amount, attr:{'id': 'system_cash_amount'+($index()+1), 'name': 'system_cash_amount'+($index()+1)}">
                                                    <input type="hidden" data-bind="value: $data.currency_type ,attr:{'id': 'currency_type'+($index()+1), 'name': 'currency_type'+($index()+1)}">
                                                    <input type="hidden" data-bind="value: $data.cash_action_id, attr:{'id': 'cash_action_id_'+($index()+1), 'name': 'cash_action_id_'+($index()+1)}">
                                                    <input type="text" data-bind="tlValue: $data.cash_amount, attr:{'id': 'cash_amount'+($index()+1), 'name': 'cash_amount'+($index()+1)}" class="moneybox">
                                                </div>
                                            </div>
                                            <div class="col col-8">
                                                <div class="form-group">
                                                    <select data-bind ="value: $data.kasa, attr:{'id': 'kasa'+($index()+1), 'name': 'kasa'+($index()+1)}, options: $data.items, optionsValue: 'ID', optionsText: 'TEXT'"></select>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- /ko -->
                                        <!-- ko if: $root.basketFooter.pos_list().length > 0 -->
                                                <div class="col col-4">
                                                    <label class="col col-12 col-xs-12 txtbold text-center" style="margin-top: 10px;"><cf_get_lang dictionary_id='57673.Tutar'> - <cf_get_lang dictionary_id='58199.Kredi Kartı'></label>
                                                </div>
                                                <div class="col col-8">
                                                    <label class="col col-12 col-xs-12 txtbold text-center" style="margin-top: 10px;"><cf_get_lang dictionary_id='57521.Banka'></label>
                                                </div>
                                        <!-- /ko -->
                                        <!-- ko foreach: $root.basketFooter.pos_list -->
                                        <div class="col col-12">
                                            <div class="col col-4">
                                                <div class="form-group">
                                                    <input type="hidden" data-bind="attr:{'id': 'pos_action_id_'+($index()+1), 'name': 'pos_action_id_'+($index()+1)}">
                                                    <input type="hidden" data-bind="attr:{'id': 'system_pos_amount_'+($index()+1), 'name': 'system_pos_amount_'+($index()+1)}">
                                                    <input type="text" data-bind="tlValue: $data.pos_amount, attr:{'id': 'pos_amount_'+($index()+1), 'name': 'pos_amount_'+($index()+1)}">
                                                </div>
                                            </div>	
                                            <div class="col col-8">
                                                <div class="form-group">
                                                    <select data-bind ="value: $data.pos, attr:{'id': 'pos'+($index()+1), 'name': 'pos'+($index()+1)}, options: $data.items, optionsValue: 'ID', optionsText: 'TEXT'" style="width:160px"></select>
                                                </div>
                                            </div>
                                        </div>
                                       <!-- /ko -->
                                       <!-- ko if: $root.basketFooter.pos_list || $root.basketFooter.cash_list -->
                                            <div class="col col-6">
                                                <label class="col col-12 col-xs-12 txtbold text-center" style="margin-top: 10px;"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57847.Ödeme'></label>
                                            </div>
                                            <div class="col col-6">
                                                <label class="col col-12 col-xs-12 txtbold text-center" style="margin-top: 10px;"><cf_get_lang dictionary_id='58583.Fark'></label>
                                            </div>
                                        <div class="col col-12">
                                            <div class="col col-6">
                                                <div class="form-group">
                                                    <input type="text" data-bind="tlValue: $root.basketFooter.total_cash_amount" style="width:100px;margin-bottom:5px;" class="moneybox" readonly="yes">
                                                </div>
                                            </div>
                                            <div class="col col-6">
                                                <div class="form-group">
                                                    <input type="text" data-bind="tlValue: $root.basketFooter.diff_amount" style="width:80px;" class="moneybox" readonly="yes">
                                                </div>
                                            </div>
                                        </div>
                                        <!-- /ko -->
                                </div>
                            </div>
                        </div>
                        <!-- /ko -->

                        <!-- ko if: window.basketService.get("display_list").indexOf('is_amount_total') >= 0 -->
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" id="basket_money_totals_table">
                            <div class="totalBox">
                                <div class="totalBoxHead font-grey-mint">
                                    <span class="headText"><cf_get_lang dictionary_id="32823.Toplam Miktar"></span><!--- Toplam Miktar --->
                                    <div class="collapse">
                                        <span class="icon-minus"></span>
                                    </div>
                                </div>
                                <div class="totalBoxBody" id="totalAmountList">  
                                    <table>
                                        <tbody>
                                        <!-- ko foreach: $root.basketFooter.totalAmount -->
                                        <tr>
                                            <td class="txtbold"><span data-bind="text: unit"></span></td>
                                            <td style="text-align: right"><span data-bind="basketFooterTotalElement: amount"></span></td>
                                        </tr>
                                        <!-- /ko -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <!-- /ko -->
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- ko if: $root.activePopupTemplate() != '' -->
    <div class="ui-draggable-box ui-draggable-box-small">
        <cf_box title="İşlem" data_bind="$root.activePopupHeaderName" id="box_fact" draggable="1" closable="1" close_href="##" call_function=""" data-bind=""click: function() { basketManager.setActivePopup('', null); }">
            <div data-bind="template: { name: $root.activePopupTemplate, data: $root.activePopupData, as: 'result' }"></div>
        </cf_box>
    </div>
    <!-- /ko -->
</div>
<script type="text/html" id="template_other_money">
    <table class="ajax_list">
        <tbody>
            <!-- ko foreach: basketService.get("money_bskt_money_types") -->
            <tr><td><a href="#" data-bind="text: $data, click: function() { result.other_money($data); basketManager.setActivePopup('', null); basketService.basketRowCalculate()('other_money', result); }"></a></td></tr>
            <!-- /ko -->
        </tbody>
    </table>
</script>
<script type="text/html" id="template_reason_code">
    <table class="ajax_list">
        <tbody>
            <!-- ko foreach: basketService.get("reason_code_list") -->
            <tr><td><a href="#" data-bind="text: $data, click: function() { result($data); basketManager.setActivePopup('', null); }"></a></td></tr>
            <!-- /ko -->
        </tbody>
    </table>
</script>
<script type="text/html" id="template_delivery_condition">
    <table class="ajax_list">
        <tbody>
            <!-- ko foreach: basketService.get("delivery_condition") -->
            <tr><td><a href="#" data-bind="text: $data.TEXT, click: function() { result($data.ID); basketManager.setActivePopup('', null); }"></a></td></tr>
            <!-- /ko -->
        </tbody>
    </table>
</script>
<script type="text/html" id="template_container_type">
    <table class="ajax_list">
        <tbody>
            <!-- ko foreach: basketService.get("container_type") -->
            <tr><td><a href="#" data-bind="text: $data.TEXT, click: function() { result($data.ID); basketManager.setActivePopup('', null); }"></a></td></tr>
            <!-- /ko -->
        </tbody>
    </table>
</script>
<script type="text/html" id="template_delivery_type">
    <table class="ajax_list">
        <tbody>
            <!-- ko foreach: basketService.get("delivery_type") -->
            <tr><td><a href="#" data-bind="text: $data.TEXT, click: function() { result($data.ID); basketManager.setActivePopup('', null); }"></a></td></tr>
            <!-- /ko -->
        </tbody>
    </table>
</script>
<script type="text/html" id="template_order_currency">
    <table class="ajax_list">
        <tbody>
            <!-- ko foreach: basketService.get("order_currency_list") -->
            <tr><td><a href="#" data-bind="text: $data.TEXT, click: function() { result($data.ID); basketManager.setActivePopup('', null); }"></a></td></tr>
            <!-- /ko -->
        </tbody>
    </table>
</script>
<script type="text/html" id="template_reserve_type">
    <table class="ajax_list">
        <tbody>
            <!-- ko foreach: basketService.get("reserve_type_list") -->
            <tr><td><a href="#" data-bind="text: $data.TEXT, click: function() { result($data.ID); basketManager.setActivePopup('', null); }"></a></td></tr>
            <!-- /ko -->
        </tbody>
    </table>
</script>
<script type="text/html" id="template_activity_id">
    <table class="ajax_list">
        <tbody>
            <!-- ko foreach: basketService.get("activity_types") -->
            <tr><td><a href="#" data-bind="text: $data.TEXT, click: function() { result($data.ID); basketManager.setActivePopup('', null); }"></a></td></tr>
            <!-- /ko -->
        </tbody>
    </table>
</script>
<script type="text/html" id="template_basket_extra_info">
    <table class="ajax_list">
        <tbody>
            <!-- ko foreach: basketService.get("basket_info_list") -->
            <tr><td><a href="#" data-bind="text: $data.TEXT, click: function() { result($data.ID); basketManager.setActivePopup('', null); }"></a></td></tr>
            <!-- /ko -->
        </tbody>
    </table>
</script>
<script type="text/html" id="template_select_info_extra">
    <table class="ajax_list">
        <tbody>
            <!-- ko foreach: basketService.get("select_info_extra_list") -->
            <tr><td><a href="#" data-bind="text: $data.TEXT, click: function() { result($data.ID); basketManager.setActivePopup('', null); }"></a></td></tr>
            <!-- /ko -->
        </tbody>
    </table>
</script>
<script type="text/html" id="template_otv_type">
    <table class="ajax_list">
        <tbody>
            <!-- ko foreach: basketService.get("otv_indirim_list") -->
            <tr><td><a href="#" data-bind="text: $data.TEXT, click: function() { result($data.ID); basketManager.setActivePopup('', null); satir_hesapla('price', $root.activeRowIndex() ); }"></a></td></tr>
            <!-- /ko -->
        </tbody>
    </table>
</script>
<script type="text/html" id="template_unit2">
    <table class="ajax_list">
        <tbody>
            <!-- ko foreach: $data.unit2_extra() -->
            <tr><td><a href="#" data-bind="text: $data, click: function() { result.unit2($data); basketManager.setActivePopup('', null); }"></a></td></tr>
            <!-- /ko -->
        </tbody>
    </table>
</script>
<script type="text/html" id="template_tevkifat_rates">
    <table class="ajax_list">
        <tbody>
            <!-- ko foreach: basketService.get("tevkifat_rates") -->
            <tr><td><a href="#" data-bind="text: $data.TITLE, click: function() { result.row_tevkifat_id($data.ID); result.row_tevkifat_rate(1-$data.RATE); basketManager.setActivePopup('', null); basketService.basketRowCalculate()('row_tevkifat_rate', result); };"></a></td></tr>
            <!-- /ko -->
        </tbody>
    </table>
</script>

<!--- basket kur ekleme ve moneyArray oluşturması --->
<cfif not isDefined("session_basket_kur_ekle")>
    <cfinclude template="../functions/get_basket_money_js.cfm">
    <cfset session_basket_kur_ekle(action_id:attributes.iid, table_type_id:1, process_type:1)>
</cfif>
<!--- basket info list --->
<cfset basket_info_list = '0;#getLang('main',322)#'>
<cfquery name="basket_info_" datasource="#dsn3#">
    SELECT BASKET_INFO_TYPE_ID,BASKET_INFO_TYPE FROM SETUP_BASKET_INFO_TYPES WHERE OPTION_NUMBER IN (1,3) AND ','+BASKET_ID+',' LIKE ',%#attributes.basket_id#%,' ORDER BY BASKET_INFO_TYPE
</cfquery>
<cfloop query="basket_info_">
    <cfset basket_info_list = listappend(basket_info_list,"#BASKET_INFO_TYPE_ID#;#BASKET_INFO_TYPE#")>
</cfloop>

<!--- bakset info ekstra --->
<cfquery name="getSelectInfoExtra" datasource="#dsn3#">
    SELECT BASKET_INFO_TYPE_ID,BASKET_INFO_TYPE FROM SETUP_BASKET_INFO_TYPES WHERE OPTION_NUMBER IN (2,3) AND ','+BASKET_ID+',' LIKE ',%#attributes.basket_id#%,' ORDER BY BASKET_INFO_TYPE
</cfquery>
<cfset select_info_extra_list = '0;#getLang('main',322)#'>
<cfloop query="getSelectInfoExtra">
    <cfset select_info_extra_list = listappend(select_info_extra_list,"#BASKET_INFO_TYPE_ID#;#BASKET_INFO_TYPE#")>
</cfloop>
<!--- ötv indirim list --->
<cfset otv_indirim_list = '0;İndirim Yok,1;Tam İndirim'>
<!--- reason list --->
<cffile action="read" file="#index_folder#admin_tools#dir_seperator#xml#dir_seperator#reason_codes.xml" variable="xmldosyam" charset = "UTF-8">
<cfset dosyam = XmlParse(xmldosyam)>
<cfset xml_dizi = dosyam.REASON_CODES.XmlChildren>
<cfset d_boyut = ArrayLen(xml_dizi)>
<cfset reason_code_list = "#getLang('main',322)#">
<cfloop index="abc" from="1" to="#d_boyut#">    	
    <cfset reason_code_list = listappend(reason_code_list,'#dosyam.REASON_CODES.REASONS[abc].REASONS_CODE.XmlText#--#dosyam.REASON_CODES.REASONS[abc].REASONS_NAME.XmlText#','*')>
</cfloop>
<!--- İhracat E-Fatura --->
<cfquery name="delivery_condition" datasource="#dsn#">
	SELECT * FROM DELIVERY_CONDITION
</cfquery>
<cfquery name="container_type" datasource="#dsn#">
	SELECT * FROM CONTAINER_TYPE
</cfquery>
<cfquery name="delivery_type" datasource="#dsn#">
	SELECT * FROM DELIVERY_TYPE
</cfquery>
<cfquery name="tevkifat_rates" datasource="#dsn3#">
    SELECT * FROM SETUP_TEVKIFAT WHERE IS_ACTIVE = 1
</cfquery>

<cfif isDefined("attributes.is_retail")>
    <cfset account_status = 1>
    <cfset cash_status = 1>
    <cfinclude template="../query/get_cashes.cfm">
    <cfinclude template="../query/get_pos_equipment_bank.cfm">
    
    <cfset cashList = arrayNew(1)>
    <cfset posList = arrayNew(1)>
    <cfset counter = 1 />
    <cfset counter2 = 1 />
    <cfoutput query="get_money_bskt">
        <cfquery name="get_money_cashes" dbtype="query">
            SELECT
                CASH_ID, CASH_NAME,
                CASH_CURRENCY_ID
            FROM 
                GET_CASHES
            WHERE 
                CASH_CURRENCY_ID='#money_type#'
        </cfquery>
        <cfif not arrayIsDefined(cashList, counter) and get_money_cashes.recordCount>
            <cfset cashList[counter] = structNew()>
            <cfset cashList[counter] = { currency_type: get_money_bskt.money_type, items: arrayNew(1) } />
        </cfif>
        <cfloop query="get_money_cashes">
            <cfset cashList[counter]["items"][currentRow] = { text: get_money_cashes.CASH_CURRENCY_ID  & " - " & get_money_cashes.CASH_NAME, id: get_money_cashes.CASH_ID } >
        </cfloop>
        <cfif not isdefined("attributes.form_add") and isdefined("url.iid") and isdefined("GET_SALE_DET") and (GET_SALE_DET.IS_CASH eq 1)>
            <cfquery name="control_cashes" datasource="#dsn2#">
                SELECT 
                    INVOICE_CASH_POS.KASA_ID,
                    CASH_ACTIONS.*
                FROM
                    INVOICE,
                    INVOICE_CASH_POS,
                    CASH_ACTIONS
                WHERE
                    CASH_ACTIONS.ACTION_ID=INVOICE_CASH_POS.CASH_ID
                    AND INVOICE_CASH_POS.INVOICE_ID=INVOICE.INVOICE_ID 
                    AND INVOICE.INVOICE_ID = #url.iid#
                    AND CASH_ACTION_CURRENCY_ID = '#get_money_bskt.MONEY_TYPE#'
                ORDER BY 
                    INVOICE_CASH_POS.KASA_ID DESC
            </cfquery>
            <cfif control_cashes.recordcount>
                <cfset cashList[counter]["KASA"] = control_cashes.KASA_ID />
                <cfset cashList[counter]["CASH_AMOUNT"] = control_cashes.CASH_ACTION_VALUE />
                <cfset cashList[counter]["CASH_ACTION_ID"] = control_cashes.ACTION_ID />
            </cfif>
        </cfif>
        <cfif get_money_cashes.recordCount>
            <cfset counter += 1 />
        </cfif>
    </cfoutput>
  
    <cfloop from="1" to="5" index="i">
        <cfif not arrayIsDefined(posList, counter2) and GET_POS_DETAIL.recordCount>
            <cfset posList[counter2] = structNew()>
            <cfset posList[counter2] = { items: arrayNew(1) } />
        </cfif>
        <cfset counter3 = 1>
        <cfloop query="GET_POS_DETAIL">
            <cfset posList[counter2]["items"][counter3] = { text: GET_POS_DETAIL.CARD_NO  & "/" & GET_POS_DETAIL.ACCOUNT_NAME, id: GET_POS_DETAIL.ACCOUNT_ID&";"&GET_POS_DETAIL.ACCOUNT_CURRENCY_ID&";"&GET_POS_DETAIL.PAYMENT_TYPE_ID } >
            <cfif GET_POS_DETAIL.recordCount>
                <cfset counter3 += 1 />
            </cfif>
        </cfloop>
        <cfif not isdefined("attributes.form_add") and isdefined("url.iid")>
            <cfquery name="CONTROL_POS_PAYMENT" datasource="#dsn2#" maxrows="5">
                SELECT 
                    INVOICE_CASH_POS.*,
                    CREDIT_CARD_BANK_PAYMENTS.*
                FROM
                    INVOICE,
                    INVOICE_CASH_POS,
                    #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CREDIT_CARD_BANK_PAYMENTS
                WHERE
                    INVOICE.INVOICE_ID=INVOICE_CASH_POS.INVOICE_ID
                    AND INVOICE_CASH_POS.POS_ACTION_ID=CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID
                    AND INVOICE.INVOICE_ID=#url.iid# AND
                    INVOICE_CASH_POS.POS_PERIOD_ID = #session_base.period_id#
                ORDER BY
                    INVOICE_CASH_POS.POS_ACTION_ID
            </cfquery>
            <cfif CONTROL_POS_PAYMENT.recordcount and len(CONTROL_POS_PAYMENT.SALES_CREDIT[i])>
                <cfset posList[counter2]["POS"] = '#CONTROL_POS_PAYMENT.ACTION_TO_ACCOUNT_ID[i]#;#CONTROL_POS_PAYMENT.ACTION_CURRENCY_ID[i]#;#CONTROL_POS_PAYMENT.PAYMENT_TYPE_ID[i]#' />
                <cfset posList[counter2]["POS_AMOUNT"] = CONTROL_POS_PAYMENT.SALES_CREDIT[i] />
                <cfset posList[counter2]["POS_ACTION_ID"] = CONTROL_POS_PAYMENT.CREDITCARD_PAYMENT_ID[i] />
            </cfif>
        </cfif>
        <cfset counter2++ />
    </cfloop>
</cfif>

<!--- veriler --->
<cfif isdefined('attributes.basket_related_action')>
    <cfinclude template="../query/get_basket_from_related_action.cfm">
<cfelseif not isdefined("attributes.form_add") or (isdefined("attributes.convert_products_id") and len(attributes.convert_products_id) and isdefined("attributes.convert_stocks_id") and len(attributes.convert_stocks_id)) or isdefined("internald_row_id_list") or (isdefined("attributes.id") and len(attributes.id)) or isdefined("attributes.st_id")>
    <cfif isdefined("attributes.basket_sub_id")><!--- alt sepet id erk 20040227 --->
        <cfinclude template="../query/get_basket_sub_contents.cfm">
    <cfelse>
        <cfinclude template="../query/get_basket_contents.cfm">
    </cfif>
<cfelse>
    <cfset sepet.satir = ArrayNew(2) >
    <cfset sepet.kdv_array = ArrayNew(2) >
    <cfset sepet.otv_array = ArrayNew(2) >
    <cfset sepet.total = 0 >
    <cfset sepet.total_other_money = 0 >
    <cfset sepet.total_other_money_tax = 0 >
    <cfset sepet.toplam_indirim = 0 >
    <cfset sepet.total_tax = 0 >
    <cfset sepet.total_otv = 0 >
    <cfset sepet.net_total = 0 >
    <cfset sepet.genel_indirim = 0 >
    <cfset sepet.stopaj = 0 >
    <cfset sepet.stopaj_yuzde = 0 >
    <cfset sepet.stopaj_rate_id = 0 >
</cfif>
<!--- Xml, Session değerleri JS değişkenlerine dolduruluyor. --->
<cfinclude template="basket2variables.cfm">
<cfset readOnlyInputList = 'stock_code,barcod,special_code,unit,list_price,price_net,price_net_doviz,row_nettotal,other_money_gross_total,row_cost_total'>
<!--- satır düzenlemeleri --->
<cfloop index="idx" from="1" to="#arrayLen(sepet.satir)#">
    <cfset sepet.satir[idx].tax = sepet.satir[idx].TAX_PERCENT>
    <cfset attributes.pid = sepet.satir[idx].product_id>
    <cfinclude template="../../objects/query/get_product_unit.cfm">
    <cfset sepet.satir[idx].unit2_extra = valueArray(get_product_unit, "add_unit")>
    <cfset sepet.satir[idx].promosyon_yuzde = structKeyExists(sepet.satir[idx], "promosyon_yuzde") ? sepet.satir[idx].promosyon_yuzde : 0>
    <cfset sepet.satir[idx].ISKONTO_TUTAR = structKeyExists(sepet.satir[idx], "ISKONTO_TUTAR") ? sepet.satir[idx].ISKONTO_TUTAR : 0>
    <cfif structKeyExists(sepet.satir[idx], "manufact_code")>
        <cfset sepet.satir[idx].manufact_code = sepet.satir[idx].manufact_code>
    </cfif>
    <cfif structKeyExists(sepet.satir[idx], "special_code")>
        <cfset sepet.satir[idx].special_code = sepet.satir[idx].special_code>
    </cfif>
    <cfset sepet.satir[idx].other_money_options = arrayNew(1)>
    <cfloop query="get_money_bskt">
        <cfif sepet.satir[idx].other_money eq get_money_bskt.MONEY_TYPE>
            <cfset sepet.satir[idx].fl_total_2 = get_money_bskt.rate1>
            <cfset sepet.satir[idx].fl_total = get_money_bskt.rate2>
            <cfset sepet.satir[idx].rate1 = get_money_bskt.rate1>
            <cfset sepet.satir[idx].rate2 = get_money_bskt.rate2>
        <cfelse>
            <cfset sepet.satir[idx].fl_total_2 = 1>
            <cfset sepet.satir[idx].fl_total = 1>
            <cfset sepet.satir[idx].rate1 = 1>
            <cfset sepet.satir[idx].rate2 = 1>
        </cfif>
        <cfset arrayAppend(sepet.satir[idx].other_money_options, get_money_bskt.MONEY_TYPE)>
    </cfloop>
    <!---Abone--->
    <cfset sepet.satir[idx].row_subscription_id = structKeyExists( sepet.satir[idx], "row_subscription_id" ) ? sepet.satir[idx].row_subscription_id : 0>
    <cfset sepet.satir[idx].row_subscription_name = structKeyExists( sepet.satir[idx], "row_subscription_name" ) ? sepet.satir[idx].row_subscription_name : ''>
    <!---Fiziki Varlık--->
    <cfset sepet.satir[idx].row_assetp_id = structKeyExists( sepet.satir[idx], "row_assetp_id" ) ? sepet.satir[idx].row_assetp_id : ''>
    <cfset sepet.satir[idx].row_assetp_name = structKeyExists( sepet.satir[idx], "row_assetp_name" ) ? sepet.satir[idx].row_assetp_name : ''>
    <!---BSMV Oran--->
    <cfset sepet.satir[idx].row_bsmv_rate = structKeyExists( sepet.satir[idx], "row_bsmv_rate" ) ? sepet.satir[idx].row_bsmv_rate : ''>
    <cfset sepet.satir[idx].row_bsmv_amount = structKeyExists( sepet.satir[idx], "row_bsmv_amount" ) ? sepet.satir[idx].row_bsmv_amount : ''>
    <cfset sepet.satir[idx].row_bsmv_currency = structKeyExists( sepet.satir[idx], "row_bsmv_currency" ) ? sepet.satir[idx].row_bsmv_currency : ''>
    <!---OİV Oran--->
    <cfset sepet.satir[idx].row_oiv_rate = structKeyExists( sepet.satir[idx], "row_oiv_rate" ) ? sepet.satir[idx].row_oiv_rate : ''>
    <cfset sepet.satir[idx].row_oiv_amount = structKeyExists( sepet.satir[idx], "row_oiv_amount" ) ? sepet.satir[idx].row_oiv_amount : ''>
    <!---Tevkifat Oran--->
    <cfset sepet.satir[idx].row_tevkifat_rate = structKeyExists( sepet.satir[idx], "row_tevkifat_rate" ) ? sepet.satir[idx].row_tevkifat_rate : ''>
    <cfset sepet.satir[idx].row_tevkifat_amount = structKeyExists( sepet.satir[idx], "row_tevkifat_amount" ) ? sepet.satir[idx].row_tevkifat_amount : ''>
    <cfset sepet.satir[idx].row_tevkifat_id = structKeyExists( sepet.satir[idx], "row_tevkifat_id" ) ? sepet.satir[idx].row_tevkifat_id : ''>
    
    <cfset sepet.satir[idx].container_number = structKeyExists( sepet.satir[idx], "container_number" ) ? sepet.satir[idx].row_tevkifat_amount : ''>
    <cfset sepet.satir[idx].container_quantity = structKeyExists( sepet.satir[idx], "container_quantity" ) ? sepet.satir[idx].container_quantity : ''>
    <cfset sepet.satir[idx].delivery_country = structKeyExists( sepet.satir[idx], "delivery_country" ) ? sepet.satir[idx].delivery_country : ''>
    <cfset sepet.satir[idx].delivery_city = structKeyExists( sepet.satir[idx], "delivery_city" ) ? sepet.satir[idx].delivery_city : ''>
    <cfset sepet.satir[idx].delivery_county = structKeyExists( sepet.satir[idx], "delivery_county" ) ? sepet.satir[idx].delivery_county : ''>
    <cfset sepet.satir[idx].gtip_number = structKeyExists( sepet.satir[idx], "gtip_number" ) ? sepet.satir[idx].gtip_number : ''>
    
    <cfset sepet.satir[idx].ROW_PROJECT_ID = structKeyExists( sepet.satir[idx], "ROW_PROJECT_ID" ) ? sepet.satir[idx].ROW_PROJECT_ID : ''>
    <cfset sepet.satir[idx].ROW_PROJECT_NAME = structKeyExists( sepet.satir[idx], "ROW_PROJECT_NAME" ) ? sepet.satir[idx].ROW_PROJECT_NAME : ''>
    
    <cfset sepet.satir[idx].ROW_WORK_ID = structKeyExists( sepet.satir[idx], "ROW_WORK_ID" ) ? sepet.satir[idx].ROW_WORK_ID : ''>
    <cfset sepet.satir[idx].ROW_WORK_NAME = structKeyExists( sepet.satir[idx], "ROW_WORK_NAME" ) ? sepet.satir[idx].ROW_WORK_NAME : ''>

    <cfset sepet.satir[idx].ROW_EXP_CENTER_ID = structKeyExists( sepet.satir[idx], "ROW_EXP_CENTER_ID" ) ? sepet.satir[idx].ROW_EXP_CENTER_ID : ''>
    <cfset sepet.satir[idx].ROW_EXP_CENTER_NAME = structKeyExists( sepet.satir[idx], "ROW_EXP_CENTER_NAME" ) ? sepet.satir[idx].ROW_EXP_CENTER_NAME : ''>

    <cfset sepet.satir[idx].ROW_EXP_ITEM_ID = structKeyExists( sepet.satir[idx], "ROW_EXP_ITEM_ID" ) ? sepet.satir[idx].ROW_EXP_ITEM_ID : ''>
    <cfset sepet.satir[idx].ROW_EXP_ITEM_NAME = structKeyExists( sepet.satir[idx], "ROW_EXP_ITEM_NAME" ) ? sepet.satir[idx].ROW_EXP_ITEM_NAME : ''>

    <cfset sepet.satir[idx].SPECT_ID = structKeyExists( sepet.satir[idx], "SPECT_ID" ) ? sepet.satir[idx].SPECT_ID : ''>
    <cfset sepet.satir[idx].SPECT_NAME = structKeyExists( sepet.satir[idx], "SPECT_NAME" ) ? sepet.satir[idx].SPECT_NAME : ''>
    
    <cfset sepet.satir[idx].ROW_ACC_CODE = structKeyExists( sepet.satir[idx], "ROW_ACC_CODE" ) ? sepet.satir[idx].ROW_ACC_CODE : ''>

    <cfset sepet.satir[idx].IS_SERIAL_NO = structKeyExists( sepet.satir[idx], "IS_SERIAL_NO" ) ? sepet.satir[idx].IS_SERIAL_NO : ''>

    <cfif sepet.satir[idx].amount neq 0>
        <cfset sepet.satir[idx].PRICE_NET = sepet.satir[idx].row_nettotal / sepet.satir[idx].amount>
    <cfelse>
        <cfset sepet.satir[idx].PRICE_NET = 0>
    </cfif>
    <cfif structKeyExists(sepet.satir[idx], "list_price") and len(sepet.satir[idx].list_price) and sepet.satir[idx].list_price neq 0 and structKeyExists(sepet.satir[idx], "net_maliyet") and len(sepet.satir[idx].net_maliyet)>
        <cfset sepet.satir[idx].list_price_discount = 100 - ((sepet.satir[idx].net_maliyet * 100) / sepet.satir[idx].list_price)>
    <cfelse>
        <cfset sepet.satir[idx].list_price_discount = 0>
    </cfif>
    <cfif sepet.satir[idx].amount neq 0>
        <cfset sepet.satir[idx].PRICE_NET_DOVIZ = sepet.satir[idx].ROW_NETTOTAL / sepet.satir[idx].amount * sepet.satir[idx].fl_total_2 / sepet.satir[idx].fl_total>
    <cfelse>
        <cfset sepet.satir[idx].PRICE_NET_DOVIZ = 0>
    </cfif>
    <cfif structKeyExists( sepet.satir[idx], "other_money_value")>
        <cfset fl_other_money = sepet.satir[idx].other_money_value>
    <cfelse>
        <cfset fl_other_money = sepet.satir[idx].row_nettotal * sepet.satir[idx].fl_total_2 / sepet.satir[idx].fl_total>
    </cfif>
    <cfif fl_other_money eq "">
        <cfset fl_other_money = sepet.satir[idx].price>
    </cfif>

    <cfif structKeyExists(sepet.satir[idx], "otv_oran")>
        <cfif listFindNoCase(display_list, "otv_from_tax_price")>
            <cfset sepet.satir[idx].other_money_gross_total = (fl_other_money * ((sepet.satir[idx].tax_percent + ( sepet.satir[idx].otv_oran * sepet.satir[idx].tax_percent / 100 )) + sepet.satir[idx].otv_oran + 100)) / 100>
        <cfelse>
            <cfset sepet.satir[idx].other_money_gross_total = (fl_other_money * (sepet.satir[idx].tax_percent + sepet.satir[idx].otv_oran + 100)) / 100>
        </cfif>
    <cfelse>
        <cfset sepet.satir[idx].other_money_gross_total = ( fl_other_money * (sepet.satir[idx].tax_percent + 1000) ) / 100>
    </cfif>

    <cfif not structKeyExists( sepet.satir[idx], "ROW_UNIQUE_RELATION_ID" )>
        <cfset sepet.satir[idx].ROW_UNIQUE_RELATION_ID = ''>
    </cfif>

    <cfif structKeyExists( sepet.satir[idx], "net_maliyet" ) and len(sepet.satir[idx].net_maliyet) and sepet.satir[idx].net_maliyet neq 0 and structKeyExists(sepet.satir[idx], "extra_cost") and len(sepet.satir[idx].extra_cost)>
        <cfset sepet.satir[idx].extra_cost_rate = (sepet.satir[idx].extra_cost / sepet.satir[idx].net_maliyet) * 100>
    <cfelse>
        <cfset sepet.satir[idx].extra_cost_rate = 0>
    </cfif>
    
    <cfset sepet.satir[idx].row_cost_total = structKeyExists(sepet.satir[idx], "row_cost_total") ? sepet.satir[idx].row_cost_total : 0>
    <cfif structKeyExists(sepet.satir[idx], "net_maliyet") and len(sepet.satir[idx].net_maliyet) and sepet.satir[idx].net_maliyet neq 0>
        <cfset sepet.satir[idx].row_cost_total = sepet.satir[idx].row_cost_total + sepet.satir[idx].net_maliyet>
    </cfif>
    <cfif structKeyExists(sepet.satir[idx], "extra_cost") and len(sepet.satir[idx].extra_cost) and sepet.satir[idx].extra_cost neq 0>
        <cfset sepet.satir[idx].row_cost_total = sepet.satir[idx].row_cost_total + sepet.satir[idx].extra_cost>
    </cfif>

    <cfset sepet.satir[idx].wrk_row_id = structKeyExists(sepet.satir[idx], "wrk_row_id") ? sepet.satir[idx].wrk_row_id : ''>
    <cfset sepet.satir[idx].wrk_row_relation_id = structKeyExists(sepet.satir[idx], "wrk_row_relation_id") ? sepet.satir[idx].wrk_row_relation_id : ''>
    <cfset sepet.satir[idx].action_row_id = structKeyExists(sepet.satir[idx], "action_row_id") ? sepet.satir[idx].action_row_id : ''>
    <cfset sepet.satir[idx].karma_product_id = structKeyExists(sepet.satir[idx], "karma_product_id") ? sepet.satir[idx].karma_product_id : ''>
    <cfset sepet.satir[idx].is_production = structKeyExists(sepet.satir[idx], "is_production") ? sepet.satir[idx].is_production : ''>
    <cfset sepet.satir[idx].row_ship_id = structKeyExists(sepet.satir[idx], "row_ship_id") ? sepet.satir[idx].row_ship_id : 0>
    <cfset sepet.satir[idx].is_promotion = structKeyExists(sepet.satir[idx], "is_promotion") ? sepet.satir[idx].is_promotion : 0>
    <cfset sepet.satir[idx].prom_stock_id = structKeyExists(sepet.satir[idx], "prom_stock_id") ? sepet.satir[idx].prom_stock_id : 0>
    <cfset sepet.satir[idx].row_paymethod_id = structKeyExists(sepet.satir[idx], "row_paymethod_id") ? sepet.satir[idx].row_paymethod_id : ''>
    <cfset sepet.satir[idx].prom_relation_id = structKeyExists(sepet.satir[idx], "prom_relation_id") ? sepet.satir[idx].prom_relation_id : ''>
    <cfset sepet.satir[idx].prom_relation_id = structKeyExists(sepet.satir[idx], "prom_relation_id") ? sepet.satir[idx].prom_relation_id : ''>
    <cfset sepet.satir[idx].INDIRIM_TOTAL = sepet.satir[idx].indirim_carpan>
    <cfset sepet.satir[idx].ek_tutar_total = structKeyExists(sepet.satir[idx], "ek_tutar_total") ? sepet.satir[idx].ek_tutar_total : 0>
    <cfset sepet.satir[idx].price_cat = structKeyExists(sepet.satir[idx], "price_cat") ? sepet.satir[idx].price_cat : ''>
    <cfset sepet.satir[idx].row_catalog_id = structKeyExists(sepet.satir[idx], "row_catalog_id") ? sepet.satir[idx].row_catalog_id : ''>
    <cfset sepet.satir[idx].row_service_id = structKeyExists(sepet.satir[idx], "row_service_id") ? sepet.satir[idx].row_service_id : ''>
    <cfset sepet.satir[idx].is_commission = structKeyExists(sepet.satir[idx], "is_commission") ? sepet.satir[idx].is_commission : 0>
    <cfset sepet.satir[idx].related_action_id = structKeyExists(sepet.satir[idx], "related_action_id") ? sepet.satir[idx].related_action_id : ''>
    <cfset sepet.satir[idx].related_action_table = structKeyExists(sepet.satir[idx], "related_action_table") ? sepet.satir[idx].related_action_table : ''>
    <cfif structKeyExists(sepet.satir[idx], "pbs_id") and len(sepet.satir[idx].pbs_id)>
        <cfquery name="get_pbs_code" datasource="#dsn3#">
            SELECT PBS_ID, PBS_CODE FROM SETUP_PBS_CODE WHERE PBS_ID = #sepet.satir[idx].pbs_id#
        </cfquery>
        <cfset sepet.satir[idx].pbs_code = get_pbs_code.PBS_CODE>
    <cfelse>
        <cfset sepet.satir[idx].pbs_id = ''>
        <cfset sepet.satir[idx].pbs_code = ''>
    </cfif>
    <cfif structKeyExists(sepet.satir[idx], "shelf_number") and len(sepet.satir[idx].shelf_number)>
        <cfquery name="get_shelf_name" datasource="#dsn3#">
            SELECT SHELF_CODE, SHELF_TYPE FROM PRODUCT_PLACE WHERE PLACE_STATUS = 1 AND PRODUCT_PLACE_ID = #sepet.satir[idx].shelf_number#
        </cfquery>
        <cfif len(get_shelf_name.SHELF_CODE)>
            <cfif len(get_shelf_name.SHELF_TYPE)>
                <cfquery name="get_shelf_type" datasource="#dsn#">
                    SELECT * FROM SHELF WHERE SHELF_ID = #get_shelf_name.SHELF_TYPE#
                </cfquery>
                <cfset temp_shelf_number = "#get_shelf_name.SHELF_CODE# - #get_shelf_type.SHELF_NAME#">
            </cfif>
        <cfelse>
            <cfset temp_shelf_number = "">
        </cfif>
    <cfelse>
        <cfset temp_shelf_number = "">
    </cfif>
    <cfif structKeyExists(sepet.satir[idx], "to_shelf_number") and len(sepet.satir[idx].to_shelf_number)>
        <cfquery name="get_shelf_name" datasource="#dsn3#">
            SELECT SHELF_CODE, SHELF_TYPE FROM PRODUCT_PLACE WHERE PLACE_STATUS = 1 AND PRODUCT_PLACE_ID = #sepet.satir[idx].to_shelf_number#
        </cfquery>
        <cfif len(get_shelf_name.SHELF_CODE)>
            <cfif len(get_shelf_name.SHELF_TYPE)>
                <cfquery name="get_shelf_type" datasource="#dsn#">
                    SELECT * FROM SHELF WHERE SHELF_ID = #get_shelf_name.SHELF_TYPE#
                </cfquery>
                <cfset to_temp_shelf_number = "#get_shelf_name.SHELF_CODE# - #get_shelf_type.SHELF_NAME#">
            </cfif>
        <cfelse>
            <cfset to_temp_shelf_number = "">
        </cfif>
    <cfelse>
        <cfset to_temp_shelf_number = "">
    </cfif>
    <cfset sepet.satir[idx].shelf_number_txt = temp_shelf_number>
    <cfset sepet.satir[idx].to_shelf_number_txt = to_temp_shelf_number>
    <cfif len(listsort(sepet.satir[idx].deliver_dept,"Text","asc","-")) and listlen(sepet.satir[idx].deliver_dept,'-') eq 2>
		<cfset attributes.department_id = listgetat(sepet.satir[idx].deliver_dept,1,'-')>
        <cfinclude template="../query/get_department.cfm">
        <cfset department_head = get_department.DEPARTMENT_HEAD>
        <cfset attributes.location_id = listgetat(sepet.satir[idx].deliver_dept,2,'-')>
        <cfinclude template="../query/get_department_location.cfm">
        <cfset department_head = "#department_head#-#get_department_location.comment#">
	<cfelse>
        <cfset department_head = ''>
    </cfif>
    <cfset sepet.satir[idx]['basket_row_departman'] = department_head>

    <cfset sepet.satir[idx].row_ship_id = structKeyExists(sepet.satir[idx], "row_ship_id") ? sepet.satir[idx].row_ship_id : ''>

    <cfif structKeyExists(sepet, "vat_exception_id") and len(sepet.vat_exception_id)>
        <cfquery name="get_vat_exc" datasource="#dsn#">
            SELECT * FROM VAT_EXCEPTION WHERE VAT_EXCEPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sepet.vat_exception_id#">
        </cfquery>
        <cfset vat_exc_code = get_vat_exc.VAT_EXCEPTION_CODE >
        <cfset vat_exc_art = get_vat_exc.VAT_EXCEPTION_ARTICLE >
    </cfif>

</cfloop>
<cfif not isDefined("default_basket_money_")>
    <cfif isQuery(get_standart_process_money) and len(get_standart_process_money.STANDART_PROCESS_MONEY)>
        <cfset default_basket_money_ = get_standart_process_money.STANDART_PROCESS_MONEY>
    <cfelseif len(session_base.money2)>
        <cfset default_basket_money_ = session_base.money2>
    <cfelse>
        <cfset default_basket_money_ = session_base.money>
    </cfif>
</cfif>

<!--- script verileri --->
<script type="text/javascript">
    
    var lng_indirim_degeri_hatali = "<cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'>";
    var lng_miktar_degeri_hatali = "<cf_get_lang dictionary_id='57728.Miktar Değeri Hatalı'>";
    var lng_fiyat_degeri_hatali = "<cf_get_lang dictionary_id='57729.Fiyat Değeri Hatalı'>";
    var lng_once_depo_sec = "<cf_get_lang dictionary_id='57723.Önce depo seçmelisiniz'>!";
    var lng_satinalma_indirimi_tarih_bilgisi = "<cf_get_lang dictionary_id='57714.Satınalma İndirimleri için Tarih Bilgisini Ekleyiniz'>!";
    var lng_once_islem_tipi_sec = "<cf_get_lang dictionary_id='57733.Önce İşlem Tipi Seçiniz'>!";
    var lng_once_uye_sec = "<cf_get_lang dictionary_id='57715.Önce Üye Seçiniz'>!";
    var lng_once_proje_sec = "<cf_get_lang dictionary_id='58848.Önce Proje Seçiniz'>!";
    var lng_odeme_yontemi_sec = "<cf_get_lang dictionary_id='58027.Ödeme Yöntemi Seçiniz!'>";
    var lng_cikis_loc_sec = "<cf_get_lang dictionary_id='58782.Çıkış Lokasyonu Seçiniz'>";
    var lng_standart_satis = "<cf_get_lang dictionary_id='58721.Standart Satış'>";
    var lng_standart_alis = "<cf_get_lang dictionary_id='58722.Standart Alış'>";
    var lng_seciniz = "<cf_get_lang dictionary_id='57734.Seçiniz'>";
</script>

<script type="text/javascript">
    console.log(<cfoutput>#replace(SerializeJSON(sepet.satir), "//", "")#</cfoutput>);
</script>
<!--- client app --->
<script type="text/javascript" src="/JS/assets/lib/knockout-3.4.2/knockout.js"></script>
<script type="text/javascript" src="/JS/assets/lib/knockout-3.4.2/knockout-mapping.js"></script>
<script type="text/javascript" src="/JS/browserStorage.js"></script>
<script type="text/javascript" src="/JS/basket/basket.service.js"></script>
<script type="text/javascript" src="/JS/basket/formulas/default.js"></script>
<script type="text/javascript" src="/JS/basket/basket.manager.js"></script>
<script type="text/javascript" src="/JS/basket/basket.config.js"></script>
<script type="text/javascript">
    $(document).ready(function() {
        basket = {};
        basket.hidden_values = {};
        basket.hidden_values.today_date = "<cfoutput>#dateadd('h',session.ep.time_zone,now())#</cfoutput>";
        basketService.set("price_round_number", <cfoutput>#price_round_number#</cfoutput>);
        basketService.set("basket_total_round_number",<cfoutput>#basket_total_round_number#</cfoutput>);
        basketService.set("otv_calc_type",<cfoutput>#(isDefined("get_basket.OTV_CALC_TYPE") and len(get_basket.OTV_CALC_TYPE))?1:0#</cfoutput>);
        basketService.set("amount_round", <cfoutput>#amount_round#</cfoutput>);
        basketService.set("period_year",<cfoutput>#session.ep.period_year#</cfoutput>);
        basketService.set("ep_money",'<cfoutput>#session.ep.money#</cfoutput>');
        basketService.set("default_money", '<cfoutput>#default_basket_money_#</cfoutput>');
        basketService.set("base_money", '<cfoutput>#session_base.money#</cfoutput>');
        basketService.set("basket_spect_type", '<cfoutput>#listFindNoCase(display_list,'spec_product_cat_property') != -1 ? 7 : 0#</cfoutput>');
        basketService.set("sale_product", '<cfoutput>#sale_product#</cfoutput>');
        basketService.set("line_number",'<cfoutput>#(isdefined("get_basket.line_number") and len(get_basket.line_number) ? get_basket.line_number : 10)#</cfoutput>');
        
        <cfif isDefined("basket_info_list")>
        <cfscript> 
            function basket_info_converter(elm) 
            {
                return { id: listFirst(elm, ";"), text: listLast(elm, ";") }; 
            }
        </cfscript>
        basketService.set( "basket_info_list", <cfoutput>#replace(serializeJSON(arrayMap(listToArray(basket_info_list), basket_info_converter)), "//", "")#</cfoutput> );
        </cfif>
        <cfif isDefined("select_info_extra_list")>
            <cfscript> 
                function select_info_converter(elm) 
                {
                    return { id: listFirst(elm, ";"), text: listLast(elm, ";") }; 
                }
            </cfscript>
            basketService.set( "select_info_extra_list", <cfoutput>#replace(serializeJSON(arrayMap(listToArray(select_info_extra_list), select_info_converter)), "//", "")#</cfoutput> );
        </cfif>
        <cfif isDefined("otv_indirim_list")>
            <cfscript> 
                
                function otv_disc_converter(elm) 
                {
                    return { id: listFirst(elm, ";"), text: listLast(elm, ";") }; 
                }
            </cfscript>
            basketService.set( "otv_indirim_list", <cfoutput>#replace(serializeJSON(arrayMap(listToArray(otv_indirim_list), otv_disc_converter)), "//", "")#</cfoutput> );
        </cfif>
        <cfif isDefined("reason_code_list")>
        basketService.set( "reason_code_list", <cfoutput>#replace(serializeJSON(listToArray(reason_code_list,"*")), "//", "")#</cfoutput> );
        </cfif>
        <cfif delivery_condition.recordCount>
        <cfscript>
            function delivery_condition_converter(elm, idx) { 
                return { id: elm, text: elm & "-" & delivery_condition["name"][idx] }; 
            }
        </cfscript>
        basketService.set( "delivery_condition", <cfoutput>#replace(serializeJSON(arrayMap(valueArray(delivery_condition, "code"), delivery_condition_converter )), "//", "" )#</cfoutput> );
        </cfif>
        <cfif container_type.recordCount>
        <cfscript>
            function container_type_converter(elm, idx) { 
                return { id: elm, text: elm & "-" & container_type["name"][idx] }; 
            }
        </cfscript>
        basketService.set( "container_type", <cfoutput>#replace(serializeJSON(arrayMap(valueArray(container_type, "code"), container_type_converter )), "//", "" )#</cfoutput> );
        </cfif>
        <cfif delivery_type.recordCount>
        <cfscript>
            function delivery_type_converter(elm, idx) { 
                return { id: elm, text: delivery_type["name"][idx] }; 
            }
        </cfscript>
        basketService.set( "delivery_type", <cfoutput>#replace(serializeJSON(arrayMap(valueArray(delivery_type, "code"), delivery_type_converter )), "//", "" )#</cfoutput> );
        </cfif>
        <cfif tevkifat_rates.recordCount>
        <cfscript>
            function tevkifat_rates_converter(elm, idx) {
                return { id: elm, rate: tevkifat_rates["STATEMENT_RATE"][idx], ratedisp: tevkifat_rates["STATEMENT_RATE_NUMERATOR"][idx] & "/" & tevkifat_rates["STATEMENT_RATE_DENOMINATOR"][idx], code: tevkifat_rates["TEVKIFAT_CODE"][idx], title: tevkifat_rates["TEVKIFAT_CODE_NAME"][idx] };
            }
        </cfscript>
        basketService.set( "tevkifat_rates", <cfoutput>#replace(serializeJSON(arrayMap(valueArray(tevkifat_rates, "TEVKIFAT_ID"), tevkifat_rates_converter )), "//", "" )#</cfoutput> );
        </cfif>
        <cfset getActivity = createobject("component","workdata.get_activity_types").getActivity()>
        <cfif getActivity.recordCount>
        <cfscript>
            function activity_converter(elm, idx) { 
                return { id: elm, text: getActivity["ACTIVITY_NAME"][idx] }; 
            }
        </cfscript>
        basketService.set( "activity_types", <cfoutput>#replace(serializeJSON(arrayMap(valueArray(getActivity, "ACTIVITY_ID"), activity_converter )), "//", "" )#</cfoutput> );
        </cfif>
        <cfif isDefined("reserve_type_list")>
        <cfscript>
            function reserve_type_converter(elm, idx) { 
                return { id: idx*-1, text: elm }; 
            }
        </cfscript>
            basketService.set( "reserve_type_list", <cfoutput>#replace(serializeJSON(arrayMap(listToArray(reserve_type_list), reserve_type_converter)), "//", "")#</cfoutput> );
        </cfif>
        <cfif isDefined("order_currency_list")>
        <cfscript>
            function order_currency_converter(elm, idx) { 
                return { id: idx*-1, text: elm }; 
            }
        </cfscript>
            basketService.set( "order_currency_list", <cfoutput>#replace(serializeJSON(arrayMap(listToArray(order_currency_list), order_currency_converter)), "//", "")#</cfoutput> );
        </cfif>
        <cfif get_money_bskt.recordCount>
        <cfscript>
            function money_basket_converter(elm, idx) { 
                return { money_type: elm, rate1: get_money_bskt["rate1"][idx], rate2: get_money_bskt["rate2"][idx], is_selected: get_money_bskt["IS_SELECTED"][idx] }; 
            }
        </cfscript>
        basketService.set( "basket_money_list", ko.mapping.fromJS( <cfoutput>#replace(serializeJSON(arrayMap( valueArray(get_money_bskt, "money_type"), money_basket_converter )), "//", "")#</cfoutput> ) );
        </cfif>
        basketService.set("wmo_fuseaction", '<cfoutput>#attributes.fuseaction#</cfoutput>');
        basketService.set("wmo_module", '<cfoutput>#listFirst(attributes.fuseaction, '.')#</cfoutput>');
        basketService.set("wmo_action", '<cfoutput>#listLast(attributes.fuseaction, '.')#</cfoutput>');
        basketService.set("basket_id", <cfoutput>#attributes.basket_id#</cfoutput>);
        basket.hidden_values.basket_id = <cfoutput>#attributes.basket_id#</cfoutput>;
        basketService.set("dsn2_alias", "<cfoutput>#dsn2_alias#</cfoutput>");
        basketService.set("basket_unique_code", 'window_' + js_create_unique_id());
        basketService.set("is_kontrol_from_update", <cfoutput>#isDefined("kontrol_form_update")?"true":"false"#</cfoutput>);
        basketService.set("kontrol_from_update", <cfoutput>#isDefined("kontrol_from_update")?kontrol_form_update:"0"#</cfoutput>);
        basketService.set("is_retail", <cfoutput>#isDefined("attributes.is_retail")?"true":"false"#</cfoutput>);
        basketService.set("generalTaxArray", []);
        basketService.set("generaltaxArrayTotal", []);
        basketService.set("generalotvArray", []);
        basketService.set("generalotvArrayTotal", []);
        basketService.set("changeable_value", []);
        basketService.set("money_bskt_money_types", <cfoutput>#replace(serializeJSON( get_money_bskt["MONEY_TYPE"] ), "//", "")#</cfoutput>);
        <cfif structKeyExists(sepet, "kdv_array") and isArray(sepet.kdv_array)>
        basketService.set("sepetTaxArray", <cfoutput>#replace(serializeJSON(sepet.kdv_array), "//", "")#</cfoutput>);
        </cfif>
        basketService.set("wmo_event", '<cfoutput>#iif(isDefined("attributes.event"), "attributes.event", de(""))#</cfoutput>');
        basketService.set("xml_delivery_date_calculated", <cfif isDefined("xml_delivery_date_calculated") and xml_delivery_date_calculated neq 1>0<cfelse>1</cfif>);
        basketService.set("basket_read_only_discount_list", <cfoutput>[#listQualify(basket_read_only_discount_list, '"')#]</cfoutput>);
        basketService.set("popup_fact_status", "empty");
        basketService.set("display_list", <cfoutput>[#listQualify(display_list, '"')#]</cfoutput>);
        basketManager.setBasketHeader(JSON.parse(`[
        <cfoutput>
        <cfset currentRow = 0>
        <cfloop query="basket_data">
        <cfset currentRow = currentRow + 1>
        <cfset qrow = queryGetRow(basket_data, currentRow)>
        <cfif listfind(basket_data.TITLE, 'product_name2')><cfset qrow.TITLE = replace(basket_data.TITLE,'product_name2','product_name_other')></cfif>
        <cfif listfind(basket_data.TITLE, 'shelf_number')><cfset qrow.TITLE = replace(basket_data.TITLE,'shelf_number','shelf_number_txt')></cfif>
        <cfif listfind(basket_data.TITLE, 'shelf_number_2')><cfset qrow.TITLE = replace(basket_data.TITLE,'shelf_number_2','to_shelf_number_txt')></cfif>
        <cfif listfind(basket_data.TITLE, 'deliver_dept')><cfset qrow.TITLE = replace(basket_data.TITLE,'deliver_dept','basket_row_departman')></cfif>
        <cfset qrow.IS_NUMERIC = (listFindNoCase(numeric_columns, qrow.TITLE) neq 0)>
        <cfset qrow.IS_SELECTED = (listFindNoCase(hidden_list, qrow.TITLE) eq 0 and listFindNoCase(non_inputs, qrow.TITLE) eq 0 ? (listFindNoCase(display_list, qrow.TITLE) eq 0 ? qrow.IS_SELECTED : 1) : 0)>
        <cfset qrow.IS_LV = listFindNoCase(selectbox_columns, qrow.TITLE) neq 0>
        <cfset qrow.IS_POPUP = listFindNoCase(popup_columns, qrow.TITLE) neq 0>
        <cfif session.ep.PRICE_VALID eq 1>
        <cfset qrow.IS_READONLY = (listFindNoCase(price_columns, qrow.TITLE) neq 0 or listFindNoCase(non_inputs, qrow.TITLE) neq 0 or listFindNoCase(readOnlyInputList, qrow.TITLE) neq 0 ? qrow.IS_READONLY : 1)>
        <cfelse>
        <cfset qrow.IS_READONLY = listFindNoCase(readOnlyInputList, qrow.TITLE) neq 0>
        </cfif>
        <cfset qrow.IS_AMOUNT = (listFindNoCase(amount_list, qrow.TITLE) neq 0)>
        <cfset qrow.IS_HESAPLA = (listFindNoCase(hesapla_columns, qrow.TITLE) neq 0)>
        #replace(serializeJSON( qrow ), "//", "")#
        <cfif currentRow lt basket_data.recordcount>
        ,
        </cfif>
        </cfloop>
        </cfoutput>
        ]`));
        <cfscript>
            for(i=1; i<=arrayLen(sepet.satir);i++) {
                sepet.satir[i].basket_exp_center = sepet.satir[i].ROW_EXP_CENTER_NAME;
                sepet.satir[i].basket_exp_item = sepet.satir[i].ROW_EXP_ITEM_NAME;
                sepet.satir[i].basket_acc_code = sepet.satir[i].ROW_ACC_CODE;
                sepet.satir[i].basket_project = sepet.satir[i].ROW_PROJECT_NAME;
                sepet.satir[i].basket_work = sepet.satir[i].ROW_WORK_NAME;
                sepet.satir[i].barcod = sepet.satir[i].BARCODE;
                sepet.satir[i].disc_ount = sepet.satir[i].INDIRIM1;
                sepet.satir[i].disc_ount2_ = sepet.satir[i].INDIRIM2;
                sepet.satir[i].disc_ount3_ = sepet.satir[i].INDIRIM3;
                sepet.satir[i].disc_ount4_ = sepet.satir[i].INDIRIM4;
                sepet.satir[i].disc_ount5_ = sepet.satir[i].INDIRIM5;
                sepet.satir[i].disc_ount6_ = sepet.satir[i].INDIRIM6;
                sepet.satir[i].disc_ount7_ = sepet.satir[i].INDIRIM7;
                sepet.satir[i].disc_ount8_ = sepet.satir[i].INDIRIM8;
                sepet.satir[i].disc_ount9_ = sepet.satir[i].INDIRIM9;
                sepet.satir[i].disc_ount10_ = sepet.satir[i].INDIRIM10;
                sepet.satir[i].spec = sepet.satir[i].SPECT_NAME;
                if( structKeyExists( sepet.satir[i], "AMOUNT_OTHER" ) ) sepet.satir[i].amount2 = sepet.satir[i].AMOUNT_OTHER;
                if( structKeyExists( sepet.satir[i], "OTV_ORAN" ) ) sepet.satir[i].otv = sepet.satir[i].OTV_ORAN;
                if( structKeyExists( sepet.satir[i], "UNIT_OTHER" ) ) sepet.satir[i].unit2 = sepet.satir[i].UNIT_OTHER;
                
            }
        </cfscript>
        basketManager.setBasketItems(
            <cfoutput>#replace(SerializeJSON(sepet.satir), "//", "")#</cfoutput>
        );
        <cfif structKeyExists( sepet, "total" )>
        basketManager.setBasketFooterItem( "basket_gross_total", <cfoutput>#wrk_round( sepet.total, basket_total_round_number )#</cfoutput> );
        </cfif>
        <cfif structKeyExists( sepet, "total_tax" )>
        basketManager.setBasketFooterItem( "basket_tax_total", <cfoutput>#wrk_round( sepet.total_tax, basket_total_round_number )#</cfoutput> );
        </cfif>
        <cfif structKeyExists( sepet, "total_otv" )>
        basketManager.setBasketFooterItem( "basket_otv_total", <cfoutput>#wrk_round( sepet.total_otv, basket_total_round_number )#</cfoutput> );
        </cfif>
        <cfif structKeyExists( sepet, "net_total" )>
        basketManager.setBasketFooterItem( "basket_net_total", <cfoutput>#wrk_round( sepet.net_total, basket_total_round_number )#</cfoutput> );
        </cfif>
        <cfif structKeyExists( sepet, "toplam_indirim" )>
        basketManager.setBasketFooterItem( "basket_discount_total", <cfoutput>#wrk_round( sepet.toplam_indirim, basket_total_round_number )#</cfoutput> );
        </cfif>
        
        <cfif isDefined("sepet_rate1")>
        basketManager.setBasketFooterItem( "basket_rate1", <cfoutput>#sepet_rate1#</cfoutput> );
        </cfif>
        <cfif structKeyExists( sepet, "genel_indirim" )>
        basketManager.setBasketFooterItem( "genel_indirim", <cfoutput>#sepet.genel_indirim#</cfoutput> );
        </cfif>
        <cfif get_money_bskt.recordcount>
        basketManager.setBasketFooterItem( "kur_say", <cfoutput>#get_money_bskt.recordcount#</cfoutput> );
        </cfif>
        <cfif get_money_bskt.recordCount>
        basketManager.setBasketFooterItem( "basket_money", '<cfoutput>#get_money_bskt["MONEY_TYPE"][ arrayFind(get_money_bskt["IS_SELECTED"], "1") ]#</cfoutput>' );
        <cfelseif isDefined("str_money_bskt")>
        basketManager.setBasketFooterItem( "basket_money", '<cfoutput>#str_money_bskt#</cfoutput>' );
        </cfif>
        <cfif structKeyExists(sepet, "tevkifat_box")>
        basketManager.setBasketFooterItem("is_tevkifat", 1);
        basketManager.setBasketFooterItem("tevkifat_oran", <cfoutput>#sepet.tevkifat_oran#</cfoutput>);
        </cfif>
        <cfif (listFirst(attributes.fuseaction, ".") eq "invoice" or (listFind("1,2,3,4,10,14,18,20,21,33,42,43,51,52",attributes.basket_id,","))) >
        basketManager.setBasketFooterItem("free_prom_stock_id", <cfoutput>#iif(isDefined("sepet.free_prom_stock_id"), "sepet.free_prom_stock_id", de("''"))#</cfoutput>);
        basketManager.setBasketFooterItem("free_prom_limit", <cfoutput>#iif(isDefined("sepet.free_prom_limit"), "sepet.free_prom_limit", de(0))#</cfoutput>);
        basketManager.setBasketFooterItem("general_prom_id", <cfoutput>#iif(isDefined("sepet.general_prom_id"), "sepet.general_prom_id", de("''"))#</cfoutput>);
        basketManager.setBasketFooterItem("general_prom_limit", <cfoutput>#iif(isDefined("sepet.general_prom_limit"), "sepet.general_prom_limit", de(0))#</cfoutput>);
        basketManager.setBasketFooterItem("general_prom_discount", <cfoutput>#iif(isDefined("sepet.general_prom_discount"),"sepet.general_prom_discount", de(0))#</cfoutput>);
        basketManager.setBasketFooterItem("general_prom_amount", <cfoutput>#iif(isDefined("sepet.general_prom_amount"),"sepet.general_prom_amount",de(0))#</cfoutput>);
        </cfif>
        <cfif structKeyExists(sepet, "vat_exception_id") and len(sepet.vat_exception_id)>
        basketManager.setBasketFooterItem("exc_id", <cfoutput>#sepet.vat_exception_id#</cfoutput>);
        basketManager.setBasketFooterItem("exc_code", <cfoutput>#vat_exc_code#</cfoutput>);
        basketManager.setBasketFooterItem("exc_article", <cfoutput>#vat_exc_art#</cfoutput>);
        </cfif>
        <cfif structKeyExists(sepet, "stopaj_yuzde")>
        basketManager.setBasketFooterItem("stopaj", <cfoutput>#wrk_round(sepet.stopaj)#</cfoutput>);
        basketManager.setBasketFooterItem("stopaj_rate_id", <cfoutput>#sepet.stopaj_rate_id#</cfoutput>);
        basketManager.setBasketFooterItem("stopaj_yuzde", <cfoutput>#wrk_round(sepet.stopaj_yuzde)#</cfoutput>);
        </cfif>
        basketManager.setBasketFooterItem("sale_product", <cfoutput>#sale_product#</cfoutput>);
        <cfif isdefined("attributes.is_retail") and isdefined("get_money_cashes") and get_money_cashes.recordcount>
            function mappingCashList(data){
                var elm = {
                    items: data.ITEMS,
                    currency_type: data.CURRENCY_TYPE,
                    kasa: ko.observable( data.KASA != undefined ? data.KASA : '' ),
                    cash_amount: ko.observable( data.CASH_AMOUNT != undefined ? data.CASH_AMOUNT : '' ),
                    cash_action_id: data.CASH_ACTION_ID != undefined ? data.CASH_ACTION_ID : ''
                }
                elm.system_cash_amount = ko.computed(function () {
                    var kasa_money_rate2 = 0, kasa_money_rate1 = 0;
                    moneyArray.forEach((item, index) => {
                        if(item == elm.currency_type){
                            kasa_money_rate2 = rate2Array[index];
                            kasa_money_rate1 = rate1Array[index];
                        }
                    });
                    return elm.cash_amount() * ( kasa_money_rate2 / kasa_money_rate1 );
                });
                return elm;
            }
            basketManager.setBasketFooterItem("cash_list", <cfoutput>#replace(serializeJSON(cashList), "//", "")#</cfoutput>.map((el) => mappingCashList(el)));
        </cfif>
        <cfif isdefined("attributes.is_retail") and isdefined("GET_POS_DETAIL") and GET_POS_DETAIL.recordcount>
            function mappingPosList(data){
                var elm = {
                    items: data.ITEMS,
                    pos: ko.observable( data.POS != undefined ? data.POS : '' ),
                    pos_amount: ko.observable( data.POS_AMOUNT != undefined ? data.POS_AMOUNT : '' ),
                    pos_action_id: data.POS_ACTION_ID != undefined ? data.POS_ACTION_ID : ''
                }
                elm.system_pos_amount = ko.computed(function () {
                    var kasa_money_rate2 = 0, kasa_money_rate1 = 0;
                    var money = elm.items.filter( (el) => { return el.ID == elm.pos() } );
                    if(money.length > 0){
                        var currency_type = money[0].ID.split(';')[1];
                        moneyArray.forEach((item, index) => {
                            if(item == currency_type){
                                kasa_money_rate2 = rate2Array[index];
                                kasa_money_rate1 = rate1Array[index];
                            }
                        });
                        return elm.pos_amount() * ( kasa_money_rate2 / kasa_money_rate1 );
                    }else return 0;
                });
                return elm;
            }
        basketManager.setBasketFooterItem("pos_list", <cfoutput>#replace(serializeJSON(posList), "//", "")#</cfoutput>.map((el) => mappingPosList(el)));   
        </cfif>

        basketManager.setPaging();
        basketManager.init();
        <cfif session.ep.SCREEN_WIDTH lt 767>$(".is_mobile").remove();</cfif>
    });
</script>