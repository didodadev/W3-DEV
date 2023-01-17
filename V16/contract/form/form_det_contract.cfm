<cf_xml_page_edit fuseact="contract.popup_add_contract">
    <cfparam name="attributes.start_date" default="#dateformat(now(),dateformat_style)#">
<cf_catalystHeader>
    <cfparam name="attributes.count" default="0">
<cfset get_contract= createObject("component","V16.contract.cfc.contract") />
<cfset get_contact_detail=get_contract.get_contact_detail(contract_id:attributes.contract_id)/>    
 <!--- alış satış koşulları --->
<cfset getPurchaseDiscount=get_contract.getPurchaseDiscount(contract_id:attributes.contract_id)/> 
<cfset getSaleDiscount=get_contract.getSaleDiscount(contract_id:attributes.contract_id)/> 
<!--- Ödeme planı veri çekiş --->
<cfset contract_cmp= createObject("component","V16.contract.cfc.contract") />
<cfset GET_PAYMENT = contract_cmp.GET_PAYMENT(contract_id: get_contact_detail.contract_id)>
<cfset GET_CAMPAIGN = contract_cmp.GET_CAMPAIGN(subscription_id: get_contact_detail.contract_id)>
<cfset contract_cmp_2 = createObject("component","V16.sales.cfc.subscription_contract")>
<cfset GET_BASKET_AMOUNT = contract_cmp_2.GET_BASKET_AMOUNT()>
<cfset GET_MONEY_MAIN = contract_cmp_2.GET_MONEY_MAIN()>
<cfset GET_MONEY = contract_cmp_2.GET_MONEY()>

<cfset GET_PAYMENT_ROWS = contract_cmp.GET_PAYMENT_ROWS(contract_id : get_contact_detail.contract_id)>   
<cfscript>
    if (isDefined('get_contact_detail.company_id') and len(get_contact_detail.company_id))
        comp_id = "#get_contact_detail.company_id#";
    else
        comp_id = "#get_contact_detail.consumer_id#";                       
</cfscript>
<cfif xml_control_payment_rows eq 1><!--- xml den ödeme planı satırları kontrol edilsin mi seçeneği seçilmişse --->
    <cfquery name="CONTROL_PROV_ROWS" dbtype="query">
        SELECT CONTRACT_ID FROM GET_PAYMENT_ROWS WHERE IS_COLLECTED_PROVISION = 1 AND IS_PAID = 0
    </cfquery>
</cfif>
<cfif get_payment_rows.recordcount>
    
    <cfquery name="GET_PAYMENT_ROWS_INVOICE" dbtype="query">
        SELECT * FROM GET_PAYMENT_ROWS WHERE IS_BILLED = 0
    </cfquery>			
</cfif>
<cfif GET_BASKET_AMOUNT.recordcount>
    <cfoutput query="GET_BASKET_AMOUNT">
        <cfset PRICE_ROUND_NUMBER = GET_BASKET_AMOUNT.PRICE_ROUND_NUMBER>
    </cfoutput>
<cfelse>
    <cfset PRICE_ROUND_NUMBER = session.ep.our_company_info.sales_price_round_num>
</cfif>
<cfset GET_POWER_USER_INFO = contract_cmp_2.GET_POWER_USER_INFO()>
<cfif len(GET_POWER_USER_INFO.POWER_USER_LEVEL_ID)>
    <cfset power_user_info = ListGetAt(GET_POWER_USER_INFO.POWER_USER_LEVEL_ID,11)><!--- satış modülü yetkisi --->
<cfelse>
    <cfset power_user_info = "">
</cfif>
<!--- /Ödeme planı veri çekiş --->
<div class="row">
    <div class="col col-12">
        <!--- ilişkili siparişler --->
        <cfset order_list = "" />
        <cfloop from="1" to="#listlen(get_contact_detail.order_id)#" index="sayac">
            <cfif len(ListGetAt(get_contact_detail.order_id,sayac,',')) and not listfind(order_list,ListGetAt(get_contact_detail.order_id,sayac,','),',')>
                <cfset order_list = Listappend(order_list,ListGetAt(get_contact_detail.order_id,sayac,','),',') />
            </cfif>
        </cfloop>
        <cfset order_list = ListSort(ListDeleteDuplicates(order_list),"numeric","asc",",") />
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='32837.ilişkili siparişler'></cfsavecontent>
        <cf_box
            id="ORDER_ID"
            closable="0"
            unload_body="1"
            box_page="#request.self#?fuseaction=sales.contract_orders&order_list=#order_list#"
            collapsed="1"
            title="#message#">
        </cf_box>
 <!--- Fiyat listeleri --->

    <cfsavecontent variable="message"><cf_get_lang dictionary_id='60280.Anlaşlmaya Özel Fiyatlar'></cfsavecontent>
        <cf_box 
            closable="0"
            id="row_id_"
            unload_body="1"
            box_page="#request.self#?fuseaction=contract.list_prices_contract&contract_id=#attributes.contract_id#&company_id=#get_contact_detail.company_id#"
            title="#message#">
        </cf_box>
   
 
     <!--- Alış Satış Koşulları --->
     <cfsavecontent variable="alis_kosullari"><cf_get_lang dictionary_id='50957.Alış Koşulları'></cfsavecontent>
        <cf_box closable="0" title="#alis_kosullari#" add_href="#request.self#?fuseaction=product.conditions&purchase_sales=1&contract_id=#attributes.contract_id#&company_id=#comp_id#">
            <cf_grid_list >
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                        <th><cf_get_lang dictionary_id='58722.Standart Alış'></th>
                        <th><cf_get_lang dictionary_id='58864.Para Br'></th>
                        <th>i.1</th>
                        <th>i.2</th>
                        <th>i.3</th>
                        <th>i.4</th>
                        <th>i.5</th>
                        <th><cf_get_lang dictionary_id="58053.Başlangıç Tarihi"></th>
                        <th><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="getPurchaseDiscount">
                        <cfquery name="getPricePurchase" datasource="#dsn3#">
                            SELECT MONEY, PRICE FROM PRICE_STANDART WHERE PRODUCT_ID = #getPurchaseDiscount.PRODUCT_ID# AND PURCHASESALES = 0 AND PRICESTANDART_STATUS = 1
                        </cfquery>
                    <tr>
                        <td>#PRODUCT_NAME#</td>
                        <td>#TLFormat(getPricePurchase.PRICE)#</td>
                        <td>#getPricePurchase.MONEY#</td>
                        <td>#TLFormat(DISCOUNT1)#</td>
                        <td>#TLFormat(DISCOUNT2)#</td>
                        <td>#TLFormat(DISCOUNT3)#</td>
                        <td>#TLFormat(DISCOUNT4)#</td>
                        <td>#TLFormat(DISCOUNT5)#</td>
                        <td>#dateformat(START_DATE,dateformat_style)#</td>
                        <td>#dateformat(FINISH_DATE,dateformat_style)#</td>
                    </tr>
                    </cfoutput>
                </tbody>
            </cf_grid_list>
        </cf_box>

        <!--- Satış Koşulları --->
        <cfsavecontent variable="satis_kosullari"><cf_get_lang dictionary_id='32018.Satış Koşulları'></cfsavecontent>
            <cf_box closable="0" title="#satis_kosullari#" add_href="#request.self#?fuseaction=product.conditions&purchase_sales=2&contract_id=#attributes.contract_id#&company_id=#comp_id#">
                <cf_grid_list>
                    <thead>
                        <tr>
                            <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                            <th><cf_get_lang dictionary_id='58721.Standart Satış'></th>
                            <th><cf_get_lang dictionary_id='58864.Para Br'></th>
                            <th>i.1</th>
                            <th>i.2</th>
                            <th>i.3</th>
                            <th>i.4</th>
                            <th>i.5</th>
                            <th><cf_get_lang dictionary_id="58053.Başlangıç Tarihi"></th>
                            <th><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="getSaleDiscount">
                            <cfquery name="getPriceSale" datasource="#dsn3#">
                                SELECT MONEY, PRICE FROM PRICE_STANDART WHERE PRODUCT_ID = #getSaleDiscount.PRODUCT_ID# AND PURCHASESALES = 1 AND PRICESTANDART_STATUS = 1
                            </cfquery>
                        <tr>
                            <td>#PRODUCT_NAME#</td>
                            <td>#TLFormat(getPriceSale.PRICE)#</td>
                            <td>#getPriceSale.MONEY#</td>
                            <td>#TLFormat(DISCOUNT1)#</td>
                            <td>#TLFormat(DISCOUNT2)#</td>
                            <td>#TLFormat(DISCOUNT3)#</td>
                            <td>#TLFormat(DISCOUNT4)#</td>
                            <td>#TLFormat(DISCOUNT5)#</td>
                            <td>#dateformat(START_DATE,dateformat_style)#</td>
                            <td>#dateformat(FINISH_DATE,dateformat_style)#</td>
                        </tr>
                        </cfoutput>
                    </tbody>
                </cf_grid_list>
            </cf_box>
            <cf_box title="#getLang('','Faturalama Satırları',64129)#"
            bill_href="#isdefined("get_payment_rows_invoice.recordcount") and len(get_payment_rows_invoice.recordcount) ? "javascript:fatura_kes()" : ""#" 
            add_href="javascript:openBoxDraggable('#request.self#?fuseaction=contract.popup_contract_payment_plan&contract_id=#attributes.contract_id#&xml_save_total_zero=#xml_save_total_zero#&x_control_camp_rules=#x_control_camp_rules#&x_control_camp_product=#x_control_camp_product#','','ui-draggable-box-large')"
            >
                <cfform name="show_pay_plan" action="#request.self#?fuseaction=contract.popup_det_contract" method="post">
                    <input type="hidden" name="list_payment_row_id" id="list_payment_row_id" value=""><!--- fatura kesilecek payment_idler burada --->
                    <input type="hidden" name="is_submitted" id="is_submitted" value="1" />
                    <input name="count" id="count" type="hidden" value="<cfif isdefined("attributes.count")><cfoutput>#attributes.count#</cfoutput></cfif>">
                    <input name="contract_id" id="contract_id" type="hidden" value="<cfoutput>#get_contact_detail.contract_id#</cfoutput>">
                    <input name="record_num" id="record_num" type="hidden" value="<cfoutput>#GET_PAYMENT_ROWS.recordcount#</cfoutput>">
                    <input type="hidden" name="xml_change_row" id="xml_change_row" value="<cfoutput>#xml_change_row#</cfoutput>" />
                    <input name="record" id="record" type="hidden" value="0">
                    <input name="unit" id="unit" type="hidden" value="">
                    <input name="amount" id="amount" type="hidden" value="">
                    <input name="quantity" id="quantity" type="hidden" value="">
                    <input name="start_date" id="start_date" type="hidden" value="">
                    <input name="product_id" id="product_id" type="hidden" value="">
                    <input name="stock_id" id="stock_id" type="hidden" value="">
                    <input name="unit_id" id="unit_id" type="hidden" value="">
                    <input name="money_type" id="money_type" type="hidden" value="">
                    <input name="period" id="period" type="hidden" value="">
                    <input name="card_paymethod_id" id="card_paymethod_id" type="hidden" value="">
                    <input name="paymethod_id" id="paymethod_id" type="hidden" value="">
                    <input name="process_stage" id="process_stage" type="hidden" value="">
                    <input name="count_camp" id="count_camp" type="hidden" value="0">
                        <cf_grid_list id="table_1">
                            <thead>
                                <tr>
                                    <cfif xml_change_row eq 1>
                                        <th><cf_get_lang dictionary_id='58693.Seç'></th>
                                    </cfif>
                                    <th width="20" class="text-center"><i class="fa fa-credit-card" title="<cf_get_lang dictionary_id='42352.Sanal POS'>"></i></th>
                                    <th width="20" class="text-center"><i class="fa fa-minus"></i></th>
                                    <th><cf_get_lang dictionary_id='57493.Aktif'></th>
                                    <th style="min-width:100px"><cf_get_lang dictionary_id='57742.Tarih'>*</th>
                                    <cfif xml_payment_finish_date eq 1>
                                        <th style="min-width:100px"><cf_get_lang dictionary_id='57700.Bitis Tarihi'>*</th>
                                    </cfif>
                                    <th style="min-width:100px"><cf_get_lang dictionary_id='57657.Urun'>*</th>
                                    <th style="min-width:100px"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
                                    <th><cf_get_lang dictionary_id='57636.Birim'>*</th>
                                    <cfif x_payment_plan_kdv>
                                        <th><cf_get_lang dictionary_id='57639.KDV'></th>
                                    </cfif>
                                    <cfif x_payment_plan_otv>
                                        <th><cf_get_lang dictionary_id='58021.ÖTV'></th>
                                    </cfif>
                                    <th style="min-width:40px"><cf_get_lang dictionary_id='57635.Miktar'></th>
                                    <th style="min-width:40px"><cf_get_lang dictionary_id='57673.Tutar'>*</th>
                                    <th style="min-width:50px"><cf_get_lang dictionary_id='57489.Para Br'>*</th>
                                    <th style="min-width:60px"><cf_get_lang dictionary_id='50923.Seç'> <cf_get_lang dictionary_id='58456'></th>
                                    <th style="display:none;min-width:60px"><cf_get_lang dictionary_id='50923.Seç'> <cf_get_lang dictionary_id='57673'></th>
                                    <!--- <th style="width:50px">BSMV <cf_get_lang dictionary_id='57677'></th> --->
                                    <th style="min-width:60px">OIV <cf_get_lang dictionary_id='58456'></th>
                                    <th style="display:none;min-width:60px">OIV <cf_get_lang dictionary_id='57673'></th>
                                        <cfif xml_tevkifat_rate>
                                    <th><cf_get_lang dictionary_id='57391'></th>
                                    <th style="display:none;min-width:60px"><cf_get_lang dictionary_id='58022'> <cf_get_lang dictionary_id='57673'></th>
                                    </cfif>
                                    <cfif xml_payment_rate>
                                        <th><cf_get_lang dictionary_id='57648.Kur'></th>
                                    </cfif>
                                    <th style="min-width:70px"><cf_get_lang dictionary_id='41113.Satır Toplamı'></th>
                                    <cfif x_payment_plan_isk_amount>
                                        <th><cf_get_lang dictionary_id='57641.İSK'> <cf_get_lang dictionary_id='57673.tutar'></th>
                                    </cfif>
                                    <th><cf_get_lang dictionary_id='57641.İSK'>(%)</th>
                                    <th style="min-width:100px"><cf_get_lang dictionary_id='41114.Net Satır Top'></th>
                                    <cfif x_payment_plan_kdv_amount>
                                        <th><cf_get_lang dictionary_id='58716.KDVli'> <cf_get_lang dictionary_id='41114.Net Satır Top'></th>
                                    </cfif>
                                    <th><cf_get_lang dictionary_id='41110.Toplu Fatr Dah'></th>
                                    <th><cf_get_lang dictionary_id ='41302.Grup Fatura Dah'></th>
                                    <th><cf_get_lang dictionary_id='41115.Faturalandı'></th>
                                    <th><cf_get_lang dictionary_id='41116.Fatura ID'></th>
                                    <th><cf_get_lang dictionary_id='48873.Toplu Provizyon'></th>
                                    <th><cf_get_lang dictionary_id='45459.Ödeme Durumu'></th>
                                    <th style="min-width:80px"><cf_get_lang dictionary_id='57845.Tahsilat'> <cf_get_lang dictionary_id='58527.ID'></th>
                                    <th><cf_get_lang dictionary_id='57483.Kayıt'></th>
                                    <th><cf_get_lang dictionary_id='57891.Güncelleyen'></th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfif xml_change_row eq 1>
                                    <tr class="headerColm">
                                        <td class="text-center"><cfif get_payment_rows.recordcount><input type="checkbox" name="is_change_main" id="is_change_main" checked onclick="wrk_select_change();"></cfif></td>
                                        <td></td>
                                        <td class="text-center"><cfif (not listfindnocase(denied_pages,"sales.emptypopup_del_subs_pay_plan_row"))><a href="javascript://" onclick="camp_control_row('','',1);"><img src="/images/delete_list.gif" border="0"></a></cfif></td>
    
                                        <td class="text-center">
                                            <input type="checkbox" name="main_status" id="main_status" onclick="apply_row(1);">
                                        </td>
                                        <td width="100" nowrap="nowrap">
                                            <div class="form-group"><div class="input-group"><cfsavecontent variable="message_main"><cf_get_lang dictionary_id ='41039.Lütfen Başlangıç Tarihi Kontrol Ediniz'>!</cfsavecontent>
                                            <cfinput type="text" readonly name="main_start_date" value="" validate="#validate_style#" maxlength="10" message="#message_main#" onBlur="apply_row(2);">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="main_start_date" call_function="apply_row" call_parameter="2"></span></div></div>
                                        </td>
                                        <cfif xml_payment_finish_date eq 1>
                                            <td width="100" nowrap="nowrap">
                                                <div class="form-group"><div class="input-group"><cfinput type="text" readonly name="main_finish_date" value="" validate="#validate_style#" maxlength="10" onBlur="apply_row(17);">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="main_finish_date" call_function="apply_row" call_parameter="17"></span></div></div>
                                            </td>
                                        </cfif>
                                        <td width="200" nowrap="nowrap">
                                            <input type="hidden" name="main_stock_id" id="main_stock_id" >
                                            <input type="hidden" name="main_unit" id="main_unit" >
                                            <input type="hidden" name="main_unit_id" id="main_unit_id" >
                                            <input type="hidden" name="main_product_id" id="main_product_id" >
                                            <div class="form-group">
                                                <div class="input-group">
                                                    <input name="main_product_name" type="text" id="main_product_name" autocomplete="off">
                                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=show_pay_plan.main_stock_id&field_unit_name=show_pay_plan.main_unit&field_main_unit=show_pay_plan.main_unit_id&run_function=apply_row&run_function_param=3&product_id=show_pay_plan.main_product_id&field_name=show_pay_plan.main_product_name');"></span>
                                                </div>
                                            </div>
                                        </td>
                                        <td width="100" nowrap="nowrap">
                                            <input type="hidden" name="main_card_paymethod_id" id="main_card_paymethod_id">
                                            <input type="hidden" name="main_paymethod_id" id="main_paymethod_id">
                                            <div class="form-group">
                                                <div class="input-group">
                                                    <input type="text" name="main_paymethod" id="main_paymethod" class="text">
                                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_paymethods&field_id=show_pay_plan.main_paymethod_id&field_name=show_pay_plan.main_paymethod&field_card_payment_id=show_pay_plan.main_card_paymethod_id&FUNCTION_NAME=apply_row&function_parameter=4&field_card_payment_name=show_pay_plan.main_paymethod');"></span>
                                                </div>
                                            </div>
                                        </td>
                                        <td></td>
                                        <cfif x_payment_plan_kdv>
                                            <td></td>
                                        </cfif>
                                        <cfif x_payment_plan_otv>
                                            <td></td>
                                        </cfif>
                                        <td>
                                            <div class="form-group">
                                                <input type="text" name="main_quantity" id="main_quantity" class="moneybox" onblur="apply_row(5);" onkeyup="return(FormatCurrency(this,event));"> 
                                            </div>
                                        </td>
                                        <td>
                                            <div class="form-group" style="width:150px;">
                                                <div class="col col-6">
                                                    <select name="main_amount_type" id="main_amount_type">
                                                        <option value=""><cf_get_lang dictionary_id='57630.Tip'></option>
                                                        <option value="3"><cf_get_lang dictionary_id='47334.Değiştir'></option>
                                                        <option value="2"><cf_get_lang dictionary_id='57582.Ekle'></option>
                                                        <option value="1"><cf_get_lang dictionary_id='49798.Çıkar'></option>
                                                    </select>
                                                </div>
                                                <div class="col col-6">
                                                    <input type="text" name="main_amount" id="main_amount" class="moneybox" onkeyup="return(FormatCurrency(this,event));" onblur="apply_row(6);">
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="form-group" style="width:100px;">
                                                <select name="main_money_type" id="main_money_type" onchange="apply_row(7);">
                                                    <option value=""><cf_get_lang dictionary_id='57489.Para Br'></option>
                                                    <cfoutput query="get_money_main">
                                                        <option value="#money#">#money#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </td>
                                        <td><div class="form-group"><input type="text" name="main_bsmv_rate" id="main_bsmv_rate" class="moneybox" onkeyup="return(FormatCurrency(this,event));" onblur="apply_row(21);"></div></td>
                                        <td style="display:none;"><div class="form-group"><input type="text" name="main_bsmv_amount" id="main_bsmv_amount" class="moneybox" onkeyup="return(FormatCurrency(this,event));" onblur="apply_row(22);"></div></td>
                                        <td><div class="form-group"><input type="text" name="main_bsmv_currency" id="main_bsmv_currency" class="moneybox" onkeyup="return(FormatCurrency(this,event));" onblur="apply_row(23);"></div></td>
                                        <td style="display:none;"><div class="form-group"><input type="text" name="main_oiv_rate" id="main_oiv_rate" class="moneybox" onkeyup="return(FormatCurrency(this,event));" onblur="apply_row(24);"></div></td>
                                        <td><div class="form-group"><input type="text" name="main_oiv_amount" id="main_oiv_amount" class="moneybox" onkeyup="return(FormatCurrency(this,event));" onblur="apply_row(25);"></div></td>
                                        <cfif xml_tevkifat_rate>
                                            <td style="display:none;">
                                                <div class="form-group">
                                                    <input type="text" name="main_tevkifat_rate" id="main_tevkifat_rate" class="moneybox" onkeyup="return(FormatCurrency(this,event));" onblur="apply_row(26);">
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <input type="text" name="main_tevkifat_amount" id="main_tevkifat_amount" class="moneybox" onkeyup="return(FormatCurrency(this,event));" onblur="apply_row(27);">
                                                </div>
                                            </td>
                                        </cfif>
                                        <cfif xml_payment_rate>
                                            <td><div class="form-group"><input type="text" name="main_rate" id="main_rate" class="moneybox" onblur="apply_row(18);" onkeyup="return(FormatCurrency(this,event,4));"></div></td>
                                        </cfif>
                                        <td></td>
                                        <cfif x_payment_plan_isk_amount>
                                            <td><div class="form-group"><input type="text" name="main_discount_amount" id="main_discount_amount" class="moneybox" onblur="apply_row(9);" onkeyup="return(FormatCurrency(this,event));"></div></td>
                                        </cfif>
                                        <td>
                                            <div class="form-group"><input type="text" name="main_discount" id="main_discount" class="moneybox" onblur="apply_row(8);" onkeyup="return(FormatCurrency(this,event));"></div> 
                                        </td>
                                        <cfif x_payment_plan_kdv_amount>
                                            <td></td>
                                        </cfif>
                                        <td class="text-center">
                                            <div class="form-group"><input type="checkbox" name="main_is_collected_inv" id="main_is_collected_inv" onclick="apply_row(10);"></div>
                                        </td>
                                        <td class="text-center"><div class="form-group"><input type="checkbox" name="main_is_group_inv" id="main_is_group_inv" onclick="apply_row(11);"></div></td>
                                        <td></td>
                                        <td></td>
                                        <td class="text-center"><div class="form-group"><input type="checkbox" name="main_is_collected_prov" id="main_is_collected_prov" onclick="apply_row(12);"></div></td>
                                        <td class="text-center"><div class="form-group"><input type="checkbox" name="main_is_paid" id="main_is_paid" onclick="<cfif power_user_info neq 1>cari_kontrol(this,0);<cfelse>apply_row(20);</cfif>"></div></td>
                                            <td>
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <input type="hidden" name="main_cari_act_type" id="main_cari_act_type" value="">
                                                        <input type="hidden" name="main_cari_act_table" id="main_cari_act_table" value="">
                                                        <input type="hidden" name="main_cari_act_id" id="main_cari_act_id" value="">
                                                        <input type="hidden" name="main_cari_period_id" id="main_cari_period_id" value="">
                                                        <input type="text" name="main_cari_action_id" id="main_cari_action_id" value="" readonly="yes">
                                                            <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_cari_actions&field_id=show_pay_plan.main_cari_action_id&field_act_id=show_pay_plan.main_cari_act_id&field_act_type=show_pay_plan.main_cari_act_type&field_period_id=show_pay_plan.main_cari_period_id&field_act_table=show_pay_plan.main_cari_act_table&call_function=apply_row&call_function_param=19</cfoutput>','list');"></span>
                                                    </div>
                                                </div>
                                            </td>
                                         <td></td>
                                            <td></td>
                                    </tr>
                                </cfif>
                                <cfif get_payment_rows.recordcount>
                                    <cfloop from="1" to="#GET_PAYMENT_ROWS.recordcount#" index="i">   
                                    <cfif GET_PAYMENT_ROWS.IS_PAID[i] eq 1 and (session.ep.admin neq 1 and power_user_info neq 1)> 
                                    <cfoutput>
                                    <tr>
                                        <cfif xml_change_row eq 1><td></td></cfif>
                                        <td align="center">
                                            <cfif len(GET_PAYMENT_ROWS.INVOICE_ID[i]) and GET_PAYMENT_ROWS.IS_PAID[i] eq 0 and GET_PAYMENT_ROWS.IS_COLLECTED_PROVISION[i] eq 0 and len(GET_PAYMENT_ROWS.CARD_PAYMETHOD_ID[i])>
                                                <cfset donem_db = "#dsn#_#GET_PAYMENT_ROWS.period_year[i]#_#session.ep.company_id#">
                                                <cfquery name="getInvoiceNettotal" datasource="#donem_db#">
                                                    SELECT NETTOTAL FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PAYMENT_ROWS.INVOICE_ID[i]#">
                                                </cfquery>							
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=bank.popup_add_online_pos&member_type=#MEMBER_TYPE#&member_id=#MEMBER_ID#&card_id_info=#MEMBER_CC_ID#&action_value=#getInvoiceNettotal.NETTOTAL#&invoice_id=#GET_PAYMENT_ROWS.INVOICE_ID[i]#&period_id=#GET_PAYMENT_ROWS.PERIOD_ID[i]#&paym_id=#GET_PAYMENT_ROWS.CARD_PAYMETHOD_ID[i]#','medium');"><img src="/images/pos_credit_sanal.gif" title="Sanal POS" border="0"></a>
                                            </cfif>
                                            
                                            <cfif len(GET_PAYMENT_ROWS.INVOICE_ID[i])>
                                                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_detail_invoice&id=#GET_PAYMENT_ROWS.INVOICE_ID[i]#&period_id=#GET_PAYMENT_ROWS.PERIOD_ID[i]#</cfoutput>','page');" class="tableyazi"><img src="/images/ship_list.gif" border="0" align="absmiddle"></a><cfif len(GET_PAYMENT_ROWS.IS_INVOICE_IPTAL[i])><font color="red" size="+1"><b>*</b></font></cfif>
                                            </cfif>
                                        </td>
                                        <td class="text-center" title="<cf_get_lang dictionary_id='57493.Aktif'>"><div class="form-group"><input type="checkbox" name="is_aktive#i#" id="is_aktive#i#" <cfif GET_PAYMENT_ROWS.IS_ACTIVE[i] eq 1>checked</cfif> disabled></div></td>
                                        <td nowrap title="<cf_get_lang dictionary_id='57742.Tarih'>">
                                            <div class="form-group">
                                                <div class="input-group">
                                                    <input type="hidden" name="is_disabled_#i#" id="is_disabled_#i#" value="2">
                                                    <input type="hidden" name="payment_row_id#i#" id="payment_row_id#i#" value="#GET_PAYMENT_ROWS.SUBSCRIPTION_PAYMENT_ROW_ID[i]#">
                                                    <input type="text" name="payment_date#i#" id="payment_date#i#" class="boxtext" value="#DateFormat(GET_PAYMENT_ROWS.PAYMENT_DATE[i],dateformat_style)#" validate="#validate_style#" maxlength="10" disabled readonly>
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="payment_date#i#"></div>
                                                </div>
                                            </div>
                                        </td>
                                        <cfif xml_payment_finish_date eq 1>
                                            <td nowrap="nowrap">
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <cfinput type="text" name="payment_finish_date#i#" class="boxtext" id="payment_finish_date" value="#DateFormat(GET_PAYMENT_ROWS.PAYMENT_FINISH_DATE[i],dateformat_style)#" validate="#validate_style#" maxlength="10">
                                                        <span class="input-group-addon"><cf_wrk_date_image date_field="payment_finish_date#i#"></div>
                                                    </div>
                                                </div>
                                            </td>
                                        </cfif>
                                            <input type="hidden" name="product_id#i#" id="product_id#i#" value="#GET_PAYMENT_ROWS.PRODUCT_ID[i]#">
                                            <input type="hidden" name="stock_id#i#" id="stock_id#i#" value="#GET_PAYMENT_ROWS.STOCK_ID[i]#">
                                            <input type="hidden" name="unit_id#i#" id="unit_id#i#" value="#GET_PAYMENT_ROWS.UNIT_ID[i]#">
                                        <td width="200" nowrap title="<cf_get_lang dictionary_id='57657.Urun'>">
                                            <div class="form-group">
                                                <div class="input-group">
                                                    <input type="text" name="detail#i#" id="detail#i#" class="boxtext" value="#GET_PAYMENT_ROWS.DETAIL[i]#" maxlength="50" disabled>
                                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_names&product_id=show_pay_plan.product_id#i#&field_id=show_pay_plan.stock_id#i#&field_unit_name=show_pay_plan.unit#i#&field_main_unit=show_pay_plan.unit_id#i#&field_name=show_pay_plan.detail#i#</cfoutput>');"></span>
                                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_detail_product&pid=#GET_PAYMENT_ROWS.PRODUCT_ID[i]#</cfoutput>');"></span>
                                                </div>
                                            </div>
                                        </td>
                                        <td nowrap title="<cf_get_lang dictionary_id='58516.Ödeme Yöntemi'>">
                                            <div class="form-group">
                                                <div class="input-group">
                                                    <input type="hidden" name="card_paymethod_id#i#" id="card_paymethod_id#i#" value="#GET_PAYMENT_ROWS.CARD_PAYMETHOD_ID[i]#">
                                                    <input type="hidden" name="paymethod_id#i#" id="paymethod_id#i#" value="#GET_PAYMENT_ROWS.PAYMETHOD_ID[i]#">
                                                    <input type="text" name="paymethod#i#" id="paymethod#i#" class="boxtext" value="<cfif len(GET_PAYMENT_ROWS.PAYMETHOD[i])>#GET_PAYMENT_ROWS.PAYMETHOD[i]#<cfelseif len(GET_PAYMENT_ROWS.CARD_PAYMETHOD_ID[i])>#GET_PAYMENT_ROWS.CARD_NO[i]#</cfif>" readonly="yes" maxlength="50" disabled>
                                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=show_pay_plan.paymethod_id#i#&field_name=show_pay_plan.paymethod#i#&field_card_payment_id=show_pay_plan.card_paymethod_id#i#&field_card_payment_name=show_pay_plan.paymethod#i#</cfoutput>');"></span>
                                                </div>
                                            </div>
                                        </td>
                                        <td title="<cf_get_lang dictionary_id='57636.Birim'>"><div class="form-group"><input type="text" name="unit#i#" id="unit#i#" maxlength="10" value="#GET_PAYMENT_ROWS.UNIT[i]#" readonly="yes" disabled></div></td>
                                        <cfif x_payment_plan_kdv>
                                            <td title="<cf_get_lang dictionary_id='57639.KDV'>"><div class="form-group"><input type="text" name="kdv_rate#i#" id="kdv_rate#i#" class="moneybox" maxlength="10" value="#get_payment_rows.tax[i]#" readonly="yes"></div></td>
                                        <cfelse>
                                            <input type="hidden" name="kdv_rate#i#" id="kdv_rate#i#" maxlength="10" value="#get_payment_rows.tax[i]#" readonly="yes">
                                        </cfif>
                                        <cfif x_payment_plan_otv>
                                            <td title="<cf_get_lang dictionary_id='58021.ÖTV'>"><div class="form-group"><input type="text" name="otv_rate#i#" id="otv_rate#i#" class="moneybox" maxlength="10" value="#get_payment_rows.otv[i]#" readonly="yes" disabled></div></td>
                                        <cfelse>
                                            <input type="hidden" name="otv_rate#i#" id="otv_rate#i#" maxlength="10" value="#get_payment_rows.otv[i]#" readonly="yes" disabled>
                                        </cfif>
                                        <td title="<cf_get_lang dictionary_id='57635.Miktar'>"><div class="form-group"><cfinput type="text" name="quantity#i#" class="box" value="#GET_PAYMENT_ROWS.QUANTITY[i]#" onChange="is_zero(#i#)" onBlur="return hesapla(#i#);" disabled></div></td>
                                        <td title="<cf_get_lang dictionary_id='57673.Tutar'>"><div class="form-group"><input type="text" name="amount#i#" id="amount#i#" class="moneybox" value="#TLFormat(GET_PAYMENT_ROWS.AMOUNT[i],price_round_number)#" onblur="hesapla(#i#);AmountRnd('amount#i#',<cfoutput>#price_round_number#</cfoutput>);" disabled></div></td>
                                        <td title="<cf_get_lang dictionary_id='57489.Para Br'>">		
                                            <div class="form-group" >			
                                                <select name="money_type_row#i#" id="money_type_row#i#" class="boxtext" disabled>
                                                    <cfloop query="GET_MONEY">
                                                        <option value="#MONEY#" <cfif GET_MONEY.MONEY eq GET_PAYMENT_ROWS.MONEY_TYPE[i]>selected</cfif>>#MONEY#</option>
                                                    </cfloop>
                                                </select>
                                            </div>
                                        </td>
                                        <cfif xml_payment_rate>
                                            <td title="<cf_get_lang dictionary_id='57648.Kur'>"><div class="form-group"><input type="text" name="row_rate#i#" id="row_rate#i#" class="moneybox" onkeyup="return(FormatCurrency(this,event,4));"></div></td>
                                        </cfif>
                                        <td title="<cf_get_lang dictionary_id='41113.Satır Toplamı'>"><div class="form-group"><input type="text" name="row_total#i#" id="row_total#i#" class="moneybox" value="#TLFormat(GET_PAYMENT_ROWS.ROW_TOTAL[i],price_round_number)#" onblur="AmountRnd('row_total#i#',<cfoutput>#price_round_number#</cfoutput>);" onkeyup="return(FormatCurrency(this,event));" disabled readonly="yes"></div></td>
                                        <cfif x_payment_plan_isk_amount>
                                            <td title="<cf_get_lang dictionary_id='57641.İSK'> <cf_get_lang dictionary_id='57673.Tutar'>"><div class="form-group"><input type="text" name="discount_amount#i#" id="discount_amount#i#" class="moneybox" value="#TLFormat(GET_PAYMENT_ROWS.DISCOUNT_AMOUNT[i])#" validate="float" onblur="return indirim_hesapla(#i#);" onkeyup="return(FormatCurrency(this,event));" disabled readonly="yes"></div></td>
                                        <cfelse>
                                            <input type="hidden" name="discount_amount#i#" id="discount_amount#i#" class="moneybox" value="#TLFormat(GET_PAYMENT_ROWS.DISCOUNT_AMOUNT[i])#" validate="float" onblur="return indirim_hesapla(#i#);" onkeyup="return(FormatCurrency(this,event));" disabled readonly="yes">
                                        </cfif>
                                        <td title="<cf_get_lang dictionary_id='57641.İSK'>(%)"><div class="form-group"><input type="text" name="discount#i#" id="discount#i#" class="moneybox" value="#TLFormat(GET_PAYMENT_ROWS.DISCOUNT[i])#" validate="integer" maxlength="3" onblur="return indirim_hesapla(#i#);" onkeyup="return(FormatCurrency(this,event));" disabled readonly="yes"></div></td>
                                        <td title="<cf_get_lang dictionary_id='41114.Net Satır Top'>"><div class="form-group"><input type="text" name="row_net_total#i#" id="row_net_total#i#" class="moneybox" disabled value="#TLFormat(GET_PAYMENT_ROWS.ROW_NET_TOTAL[i],session.ep.our_company_info.rate_round_num)#" onblur="return discount_hesapla(#i#);" onkeyup="return(FormatCurrency(this,event));" readonly="yes"></div></td>
                                        <cfif x_payment_plan_kdv_amount>
                                            <cfset nettotal_kdv = GET_PAYMENT_ROWS.ROW_NET_TOTAL[i]*GET_PAYMENT_ROWS.TAX[i]/100>
                                            <cfset nettotal_otv = GET_PAYMENT_ROWS.ROW_NET_TOTAL[i]*GET_PAYMENT_ROWS.OTV[i]/100>
                                            <td title="KDV'li <cf_get_lang dictionary_id='41114.Net Satır Top'>">
                                                <div class="form-group"><input type="text" name="row_last_net_total#i#" id="row_last_net_total#i#" class="moneybox" disabled value="#TLFormat(GET_PAYMENT_ROWS.ROW_NET_TOTAL[i]+nettotal_kdv+nettotal_otv)#" onblur="return discount_hesapla(#i#);" onkeyup="return(FormatCurrency(this,event));" readonly="yes"></div></td>
                                        </cfif>
                                        <td class="text-center" title="<cf_get_lang dictionary_id='41110.Toplu Fatr Dah'>"><div class="form-group"><input type="checkbox" name="is_collected_inv#i#" id="is_collected_inv#i#" <cfif GET_PAYMENT_ROWS.IS_COLLECTED_INVOICE[i] eq 1>checked</cfif> disabled onclick="select_row_bill_type(1,#i#);"></div></td>
                                        <td class="text-center" title="<cf_get_lang dictionary_id ='41302.Grup Fatura Dah'>"><div class="form-group"><input type="checkbox" name="is_group_inv#i#" id="is_group_inv#i#" <cfif GET_PAYMENT_ROWS.IS_GROUP_INVOICE[i] eq 1>checked</cfif> disabled onclick="select_row_bill_type(2,#i#);"></div></td>
                                        <td class="text-center" title="<cf_get_lang dictionary_id='41115.Faturalandı'>"><div class="form-group"><input type="checkbox" name="is_billed#i#" id="is_billed#i#" <cfif GET_PAYMENT_ROWS.IS_BILLED[i] eq 1>checked</cfif> disabled></div></td>
                                        <input type="hidden" name="period_id#i#" id="period_id#i#" value="#GET_PAYMENT_ROWS.PERIOD_ID[i]#">
                                        <td width="70" nowrap title="<cf_get_lang dictionary_id='41116.Fatura ID'>"><div class="form-group"><input type="text" name="invoice_id#i#" id="invoice_id#i#" value="#GET_PAYMENT_ROWS.INVOICE_ID[i]#" disabled><input type="hidden" name="bill_info#i#" id="bill_info#i#"></div></td>
                                        <td class="text-center" title="<cf_get_lang dictionary_id='41118.Toplu Prov Oluşturuldu'>"><div class="form-group"><input type="checkbox" name="is_collected_prov#i#" id="is_collected_prov#i#" <cfif GET_PAYMENT_ROWS.IS_COLLECTED_PROVISION[i] eq 1>checked</cfif> disabled></div></td>
                                        <td class="text-center" title="<cf_get_lang dictionary_id='41117.Ödendi'>">
                                            <input type="checkbox" name="is_paid#i#" id="is_paid#i#" <cfif GET_PAYMENT_ROWS.IS_PAID[i] eq 1>checked</cfif> disabled>
                                            <cfif len(GET_PAYMENT_ROWS.CARI_ACT_TYPE[i]) and GET_PAYMENT_ROWS.IS_PAID[i] eq 1>
                                                <cfswitch expression = "#GET_PAYMENT_ROWS.CARI_ACT_TYPE[i]#">
                                                    <cfcase value="24"><cfset type="ch.popup_dsp_gelenh&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                    <cfcase value="31"><cfset type="ch.popup_dsp_cash_revenue&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                    <cfcase value="42"><cfset type="ch.popup_print_upd_debit_claim_note&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                    <cfcase value="43"><cfset type="objects.popup_cari_action&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                    <cfcase value="90"><cfset type="ch.popup_dsp_payroll_entry&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                    <cfcase value="97"><cfset type="ch.popup_dsp_voucher_payroll_action&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                    <cfcase value="241"><cfset type="ch.popup_dsp_credit_card_payment_type"></cfcase>
                                                    <cfcase value="251"><cfset type="bank.popup_dsp_assign_order&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                </cfswitch>
                                                <cfif listfind('24,31,32,241,242,251,43',GET_PAYMENT_ROWS.CARI_ACT_TYPE[i],',')>
                                                    <cfset page_type = 'small'>
                                                <cfelse>
                                                    <cfset page_type = 'page'>
                                                </cfif>
                                                <cfif GET_PAYMENT_ROWS.CARI_ACT_TABLE[i] is 'CHEQUE'> 
                                                    <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_cheque_det&ID=#GET_PAYMENT_ROWS.CARI_ACT_ID[i]#&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#','small')">
                                                        <img src="/images/ship_list.gif" border="0" align="absmiddle">
                                                    </a>
                                                <cfelseif GET_PAYMENT_ROWS.CARI_ACT_TABLE[i] is 'VOUCHER'> 
                                                    <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_voucher_det&ID=#GET_PAYMENT_ROWS.CARI_ACT_ID[i]#&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#','small')">
                                                        <img src="/images/ship_list.gif" border="0" align="absmiddle">
                                                    </a>
                                                <cfelseif isdefined("type")>													
                                                    <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#GET_PAYMENT_ROWS.CARI_ACT_ID[i]#','#page_type#');" title="İşlem Detayı">
                                                        <img src="/images/ship_list.gif" border="0" align="absmiddle">
                                                    </a>
                                                </cfif>
                                            <cfelse>
                                                &nbsp;
                                            </cfif>
                                        </td>
                                            <td width="70" nowrap title="<cf_get_lang dictionary_id='41117.Ödendi'>">
                                                <div class="form-group">
                                                    <input type="hidden" name="cari_act_table#i#" id="cari_act_table#i#" value="#GET_PAYMENT_ROWS.CARI_ACT_TABLE[i]#">
                                                    <input type="hidden" name="cari_act_type#i#" id="cari_act_type#i#" value="#GET_PAYMENT_ROWS.CARI_ACT_TYPE[i]#">
                                                    <input type="hidden" name="cari_act_id#i#" id="cari_act_id#i#" value="#GET_PAYMENT_ROWS.CARI_ACT_ID[i]#">
                                                    <input type="hidden" name="cari_period_id#i#" id="cari_period_id#i#" value="#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#">
                                                    <input type="text" name="cari_action_id#i#" id="cari_action_id#i#" value="#GET_PAYMENT_ROWS.CARI_ACTION_ID[i]#" readonly="yes" disabled>
                                                </div>
                                            </td>
        
                                        <td nowrap="nowrap" title="<cf_get_lang dictionary_id='57483.Kayıt'>">
                                            <cfif len(GET_PAYMENT_ROWS.RECORD_EMP_NAME[i])>
                                                #GET_PAYMENT_ROWS.RECORD_EMP_NAME[i]# - <cfif len(GET_PAYMENT_ROWS.RECORD_DATE[i])> #dateformat(dateadd('h',session.ep.time_zone,GET_PAYMENT_ROWS.RECORD_DATE[i]),dateformat_style)# (#timeformat(GET_PAYMENT_ROWS.RECORD_DATE[i],timeformat_style)#)</cfif>
                                            </cfif>
                                            </td>
                                            <td nowrap="nowrap" title="<cf_get_lang dictionary_id='57891.Güncelleyen'>">
                                            <cfif len(GET_PAYMENT_ROWS.UPDATE_EMP_NAME[i])>
                                                #GET_PAYMENT_ROWS.UPDATE_EMP_NAME[i]# - #dateformat(dateadd('h',session.ep.time_zone,GET_PAYMENT_ROWS.UPDATE_DATE[i]),dateformat_style)# (#timeformat(GET_PAYMENT_ROWS.UPDATE_DATE[i],timeformat_style)#)
                                            </cfif>
                                            </td>
                                        </tr>
                                    </cfoutput>	
                                    <cfelseif GET_PAYMENT_ROWS.IS_BILLED[i] eq 1 and (session.ep.admin neq 1 and power_user_info neq 1)>
                                    <cfoutput>
                                    <tr onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row" height="22">
                                        <cfif xml_change_row eq 1><td></td></cfif>
                                        <td align="center" nowrap="nowrap">
                                            <cfif len(GET_PAYMENT_ROWS.INVOICE_ID[i]) and GET_PAYMENT_ROWS.IS_PAID[i] eq 0 and GET_PAYMENT_ROWS.IS_COLLECTED_PROVISION[i] eq 0 and len(GET_PAYMENT_ROWS.CARD_PAYMETHOD_ID[i])>
                                                <cfset donem_db = "#dsn#_#GET_PAYMENT_ROWS.period_year[i]#_#session.ep.company_id#">
                                                <cfquery name="getInvoiceNettotal" datasource="#donem_db#">
                                                    SELECT NETTOTAL FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PAYMENT_ROWS.INVOICE_ID[i]#">
                                                </cfquery>	
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=bank.popup_add_online_pos&member_type=#MEMBER_TYPE#&member_id=#MEMBER_ID#&card_id_info=#MEMBER_CC_ID#&action_value=#getInvoiceNettotal.NETTOTAL#&invoice_id=#GET_PAYMENT_ROWS.INVOICE_ID[i]#&period_id=#GET_PAYMENT_ROWS.PERIOD_ID[i]#&paym_id=#GET_PAYMENT_ROWS.CARD_PAYMETHOD_ID[i]#','medium');"><img src="/images/pos_credit_sanal.gif" title="Sanal POS" border="0"></a>
                                            </cfif>
                                            <cfif len(GET_PAYMENT_ROWS.INVOICE_ID[i])>
                                                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_detail_invoice&id=#GET_PAYMENT_ROWS.INVOICE_ID[i]#&period_id=#GET_PAYMENT_ROWS.PERIOD_ID[i]#</cfoutput>','page');" class="tableyazi"><img src="/images/ship_list.gif" border="0" align="absmiddle"></a><cfif len(GET_PAYMENT_ROWS.IS_INVOICE_IPTAL[i])><font color="red" size="+1"><b>*</b></font></cfif>
                                            </cfif>
                                        </td>
                                        <td class="text-center" title="<cf_get_lang dictionary_id='57493.Aktif'>"><div class="form-group"><input type="checkbox" name="is_active#i#" id="is_active#i#" <cfif GET_PAYMENT_ROWS.IS_ACTIVE[i] eq 1>checked</cfif> disabled></div></td>
                                        <td nowrap title="<cf_get_lang dictionary_id='57742.Tarih'>">
                                            <div class="form-group">
                                                <div class="input-group">
                                                    <input type="hidden" name="is_disabled_#i#" id="is_disabled_#i#" value="1">
                                                    <input type="hidden" name="payment_row_id#i#" id="payment_row_id#i#" value="#GET_PAYMENT_ROWS.SUBSCRIPTION_PAYMENT_ROW_ID[i]#">
                                                    <input type="text" name="payment_date#i#" id="payment_date#i#" class="boxtext" value="#DateFormat(GET_PAYMENT_ROWS.PAYMENT_DATE[i],dateformat_style)#" validate="#validate_style#" maxlength="10" disabled readonly>
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="payment_date#i#"></span>
                                                </div>
                                            </div>
                                        </td>
                                        <cfif xml_payment_finish_date eq 1>
                                            <td nowrap="nowrap">
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <cfinput type="text" name="payment_finish_date#i#" class="boxtext" value="#DateFormat(GET_PAYMENT_ROWS.PAYMENT_FINISH_DATE[i],dateformat_style)#" validate="#validate_style#" maxlength="10" style="width:67px;">
                                                        <span class="input-group-addon"><cf_wrk_date_image date_field="payment_finish_date#i#"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </cfif>
                                            <input type="hidden" name="product_id#i#" id="product_id#i#" value="#GET_PAYMENT_ROWS.PRODUCT_ID[i]#">
                                            <input type="hidden" name="stock_id#i#" id="stock_id#i#" value="#GET_PAYMENT_ROWS.STOCK_ID[i]#">
                                            <input type="hidden" name="unit_id#i#" id="unit_id#i#" value="#GET_PAYMENT_ROWS.UNIT_ID[i]#">
                                        <td width="200" nowrap title="<cf_get_lang dictionary_id='57657.Urun'>">
                                            <div class="form-group">
                                                <div class="input-group">
                                                    <input type="text" name="detail#i#" id="detail#i#" class="boxtext" value="#GET_PAYMENT_ROWS.DETAIL[i]#" maxlength="50" disabled>
                                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_names&product_id=show_pay_plan.product_id#i#&field_id=show_pay_plan.stock_id#i#&field_unit_name=show_pay_plan.unit#i#&field_main_unit=show_pay_plan.unit_id#i#&field_name=show_pay_plan.detail#i#</cfoutput>');"></span>
                                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_detail_product&pid=#GET_PAYMENT_ROWS.PRODUCT_ID[i]#</cfoutput>');"></span>
                                                </div>
                                            </div>
                                        </td>
                                        <td nowrap title="<cf_get_lang dictionary_id='58516.Ödeme Yöntemi'>">
                                            <div class="form-group">
                                                <div class="input-group">
                                                    <input type="hidden" name="card_paymethod_id#i#" id="card_paymethod_id#i#" value="#GET_PAYMENT_ROWS.CARD_PAYMETHOD_ID[i]#">
                                                    <input type="hidden" name="paymethod_id#i#" id="paymethod_id#i#" value="#GET_PAYMENT_ROWS.PAYMETHOD_ID[i]#">
                                                    <input type="text" name="paymethod#i#" id="paymethod#i#" class="boxtext" value="<cfif len(GET_PAYMENT_ROWS.PAYMETHOD[i])>#GET_PAYMENT_ROWS.PAYMETHOD[i]#<cfelseif len(GET_PAYMENT_ROWS.CARD_PAYMETHOD_ID[i])>#GET_PAYMENT_ROWS.CARD_NO[i]#</cfif>" readonly="yes" maxlength="50" disabled>
                                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=show_pay_plan.paymethod_id#i#&field_name=show_pay_plan.paymethod#i#&field_card_payment_id=show_pay_plan.card_paymethod_id#i#&field_card_payment_name=show_pay_plan.paymethod#i#</cfoutput>');"></span>
                                                </div>
                                            </div>
                                        </td>
                                        <td title="<cf_get_lang dictionary_id='57636.Birim'>"><div class="form-group"><input type="text" name="unit#i#" id="unit#i#" maxlength="10" value="#GET_PAYMENT_ROWS.UNIT[i]#" readonly="yes" disabled></div></td>
                                        <cfif x_payment_plan_kdv>
                                            <td title="<cf_get_lang dictionary_id='57639.KDV'>"><div class="form-group"><input type="text" name="kdv_rate#i#" id="kdv_rate#i#" class="moneybox" maxlength="10" value="#get_payment_rows.tax[i]#" readonly="yes"></div></td>
                                        <cfelse>
                                            <input type="hidden" name="kdv_rate#i#" id="kdv_rate#i#" maxlength="10" value="#get_payment_rows.tax[i]#" readonly="yes">
                                        </cfif>
                                        <cfif x_payment_plan_otv>
                                            <td title="<cf_get_lang dictionary_id='58021.ÖTV'>"><div class="form-group"><input type="text" name="otv_rate#i#" id="otv_rate#i#" class="moneybox" maxlength="10" value="#get_payment_rows.OTV[i]#" readonly="yes" disabled></div></td>
                                        <cfelse>
                                            <input type="hidden" name="otv_rate#i#" id="otv_rate#i#" maxlength="10" value="#get_payment_rows.OTV[i]#" readonly="yes" disabled>
                                        </cfif>
                                        <td title="<cf_get_lang dictionary_id='57635.Miktar'>"><div class="form-group"><cfinput type="text" name="quantity#i#" class="box" value="#GET_PAYMENT_ROWS.QUANTITY[i]#" onChange="is_zero(#i#)" onBlur="return hesapla(#i#);" disabled></div></td>
                                        <td title="<cf_get_lang dictionary_id='57673.Tutar'>"><div class="form-group"><input type="text" name="amount#i#" id="amount#i#" class="moneybox" value="#TLFormat(GET_PAYMENT_ROWS.AMOUNT[i],price_round_number)#" onblur="hesapla(#i#);AmountRnd('amount#i#',<cfoutput>#price_round_number#</cfoutput>);" disabled></div></td>
                                        <td title="<cf_get_lang dictionary_id='57489.Para Br'>">					
                                            <div class="form-group">
                                                <select name="money_type_row#i#" id="money_type_row#i#" class="boxtext" disabled>
                                                    <cfloop query="GET_MONEY">
                                                        <option value="#MONEY#" <cfif GET_MONEY.MONEY eq GET_PAYMENT_ROWS.MONEY_TYPE[i]>selected</cfif>>#MONEY#</option>
                                                    </cfloop>
                                                </select>			
                                            </div>
                                        </td>
                                        <cfif xml_payment_rate>
                                            <td title="<cf_get_lang dictionary_id='57648.Kur'>"><div class="form-group"><input type="text" name="row_rate#i#" id="row_rate#i#" value="#TLFormat(get_payment_rows.rate[i])#" class="moneybox" onkeyup="return(FormatCurrency(this,event,4));"></div></td>
                                        </cfif>
                                        <td title="<cf_get_lang dictionary_id='41113.Satır Toplamı'>"><div class="form-group"><input type="text" name="row_total#i#" id="row_total#i#" class="moneybox" value="#TLFormat(GET_PAYMENT_ROWS.ROW_TOTAL[i],price_round_number)#" onblur="AmountRnd('ROW_TOTAL#i#',<cfoutput>#price_round_number#</cfoutput>);" onkeyup="return(FormatCurrency(this,event));" disabled readonly="yes"></div></td>
                                        <cfif x_payment_plan_isk_amount>
                                            <td title="<cf_get_lang dictionary_id='57641.İSK'> <cf_get_lang dictionary_id='57673.Tutar'>"><div class="form-group"><input type="text" name="discount_amount#i#" id="discount_amount#i#" class="moneybox" value="#TLFormat(GET_PAYMENT_ROWS.DISCOUNT_AMOUNT[i])#" validate="float" onblur="return indirim_hesapla(#i#);" onkeyup="return(FormatCurrency(this,event));" disabled readonly="yes"></div></td>
                                        <cfelse>
                                            <input type="hidden" name="discount_amount#i#" id="discount_amount#i#" class="moneybox" value="#TLFormat(GET_PAYMENT_ROWS.DISCOUNT_AMOUNT[i])#" validate="float" onblur="return indirim_hesapla(#i#);" onkeyup="return(FormatCurrency(this,event));" disabled readonly="yes">
                                        </cfif>
                                        <td title="<cf_get_lang dictionary_id='57641.İSK'>(%)"><div class="form-group"><input type="text" name="discount#i#" id="discount#i#" class="moneybox" value="#TLFormat(GET_PAYMENT_ROWS.DISCOUNT[i])#" validate="integer" maxlength="3" onblur="return indirim_hesapla(#i#);" onkeyup="return(FormatCurrency(this,event));" disabled readonly="yes"></div></td>
                                        <td title="<cf_get_lang dictionary_id='41114.Net Satır Top'>"><div class="form-group"><input type="text" name="row_net_total#i#" id="row_net_total#i#" class="moneybox" disabled value="#TLFormat(GET_PAYMENT_ROWS.ROW_NET_TOTAL[i],session.ep.our_company_info.rate_round_num)#" onblur="return discount_hesapla(#i#);" onkeyup="return(FormatCurrency(this,event));" readonly="yes"></div></td>
                                        <cfif x_payment_plan_kdv_amount>
                                            <cfset nettotal_kdv = GET_PAYMENT_ROWS.ROW_NET_TOTAL[i]*GET_PAYMENT_ROWS.TAX[i]/100>
                                            <cfset nettotal_otv = GET_PAYMENT_ROWS.ROW_NET_TOTAL[i]*GET_PAYMENT_ROWS.OTV[i]/100>
                                            <td title="KDV'li <cf_get_lang dictionary_id='41114.Net Satır Top'>"><div class="form-group"><input type="text" name="row_last_net_total#i#" id="row_last_net_total#i#" class="moneybox" disabled value="#TLFormat(GET_PAYMENT_ROWS.ROW_NET_TOTAL[i]+nettotal_kdv+nettotal_otv)#" onblur="return discount_hesapla(#i#);" onkeyup="return(FormatCurrency(this,event));" readonly="yes"></div></td>
                                        </cfif>
                                        <td class="text-center" title="<cf_get_lang dictionary_id='41110.Toplu Fatr Dah'>"><div class="form-group"><input type="checkbox" name="is_collected_inv#i#" id="is_collected_inv#i#" <cfif GET_PAYMENT_ROWS.IS_COLLECTED_INVOICE[i] eq 1>checked</cfif> disabled onclick="select_row_bill_type(1,#i#);"></div></td>
                                        <td class="text-center" title="<cf_get_lang dictionary_id ='41302.Grup Fatura Dah'>"><div class="form-group"><input type="checkbox" name="is_group_inv#i#" id="is_group_inv#i#" <cfif GET_PAYMENT_ROWS.IS_GROUP_INVOICE[i] eq 1>checked</cfif> disabled onclick="select_row_bill_type(2,#i#);"></div></td>
                                        <td class="text-center" title="<cf_get_lang dictionary_id='41115.Faturalandı'>"><div class="form-group"><input type="checkbox" name="is_billed#i#" id="is_billed#i#" <cfif GET_PAYMENT_ROWS.IS_BILLED[i] eq 1>checked</cfif> disabled></div></td>
                                        <input type="hidden" name="period_id#i#" id="period_id#i#" value="#GET_PAYMENT_ROWS.PERIOD_ID[i]#">
                                        <td width="70" nowrap title="<cf_get_lang dictionary_id='41116.Fatura ID'>"><div class="form-group"><input type="text" name="invoice_id#i#" id="invoice_id#i#" class="box" value="#GET_PAYMENT_ROWS.INVOICE_ID[i]#" disabled><input type="hidden" name="bill_info#i#" id="bill_info#i#"></div></td>
                                        <td class="text-center" title="<cf_get_lang dictionary_id='41118.Toplu Prov Oluşturuldu'>"><div class="form-group"><input type="checkbox" name="is_collected_prov#i#" id="is_collected_prov#i#" <cfif GET_PAYMENT_ROWS.IS_COLLECTED_PROVISION[i] eq 1>checked</cfif>></div></td>
                                        <td class="text-center" title="<cf_get_lang dictionary_id='41117.Ödendi'>">
                                            <div class="form-group">
                                                <div class="input-group">
                                                    <input type="checkbox" name="is_paid#i#" id="is_paid#i#" <cfif GET_PAYMENT_ROWS.IS_PAID[i] eq 1>checked</cfif>>
                                                    <cfif  len(GET_PAYMENT_ROWS.CARI_ACT_TYPE[i]) and GET_PAYMENT_ROWS.IS_PAID[i] eq 1>
                                                        <cfswitch expression = "#GET_PAYMENT_ROWS.CARI_ACT_TYPE[i]#">
                                                            <cfcase value="24"><cfset type="ch.popup_dsp_gelenh&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                            <cfcase value="31"><cfset type="ch.popup_dsp_cash_revenue&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                            <cfcase value="42"><cfset type="ch.popup_print_upd_debit_claim_note&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                            <cfcase value="43"><cfset type="objects.popup_cari_action&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                            <cfcase value="90"><cfset type="ch.popup_dsp_payroll_entry&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                            <cfcase value="97"><cfset type="ch.popup_dsp_voucher_payroll_action&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                            <cfcase value="241"><cfset type="ch.popup_dsp_credit_card_payment_type"></cfcase>
                                                            <cfcase value="251"><cfset type="bank.popup_dsp_assign_order&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                        </cfswitch>
                                                        <cfif listfind('24,31,32,241,242,251,43',GET_PAYMENT_ROWS.CARI_ACT_TYPE[i],',')>
                                                            <cfset page_type = 'small'>
                                                        <cfelse>
                                                            <cfset page_type = 'page'>
                                                        </cfif>
                                                        <cfif GET_PAYMENT_ROWS.CARI_ACT_TABLE[i] is 'CHEQUE'> 
                                                            <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_cheque_det&ID=#GET_PAYMENT_ROWS.CARI_ACT_ID[i]#&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#','small')"></span>
                                                        <cfelseif GET_PAYMENT_ROWS.CARI_ACT_TABLE[i] is 'VOUCHER'> 
                                                            <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_voucher_det&ID=#GET_PAYMENT_ROWS.CARI_ACT_ID[i]#&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#','small')"></span>
                                                        <cfelse>													
                                                            <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#GET_PAYMENT_ROWS.CARI_ACT_ID[i]#','#page_type#');" title="<cf_get_lang dictionary_id='34326.Detaylar'>"></span>
                                                        </cfif>
                                                    <cfelse>
                                                        
                                                    </cfif>
                                                </div>
                                            </div>
                                        </td>
                                            <td width="70" nowrap title="<cf_get_lang dictionary_id='41117.Ödendi'>">
                                                <div class="form-group">
                                                    <input type="hidden" name="cari_act_table#i#" id="cari_act_table#i#" value="#GET_PAYMENT_ROWS.CARI_ACT_TABLE[i]#">
                                                    <input type="hidden" name="cari_act_type#i#" id="cari_act_type#i#" value="#GET_PAYMENT_ROWS.CARI_ACT_TYPE[i]#">
                                                    <input type="hidden" name="cari_act_id#i#" id="cari_act_id#i#" value="#GET_PAYMENT_ROWS.CARI_ACT_ID[i]#">
                                                    <input type="hidden" name="cari_period_id#i#" id="cari_period_id#i#" value="#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#">
                                                    <input type="text" name="cari_action_id#i#" id="cari_action_id#i#" value="#GET_PAYMENT_ROWS.CARI_ACTION_ID[i]#" readonly="yes" disabled>
                                                </div>
                                            </td>
                                        <td nowrap="nowrap" title="<cf_get_lang dictionary_id='57483.Kayıt'>">
                                            <cfif len(GET_PAYMENT_ROWS.RECORD_EMP_NAME[i])>
                                                #GET_PAYMENT_ROWS.RECORD_EMP_NAME[i]# - #dateformat(dateadd('h',session.ep.time_zone,GET_PAYMENT_ROWS.RECORD_DATE[i]),dateformat_style)# (#timeformat(GET_PAYMENT_ROWS.RECORD_DATE[i],timeformat_style)#)
                                            </cfif>
                                            </td>
                                            <td nowrap="nowrap" title="<cf_get_lang dictionary_id='57891.Güncelleyen'>">
                                            <cfif len(GET_PAYMENT_ROWS.UPDATE_EMP_NAME[i])>
                                                #GET_PAYMENT_ROWS.UPDATE_EMP_NAME[i]# - #dateformat(dateadd('h',session.ep.time_zone,GET_PAYMENT_ROWS.UPDATE_DATE[i]),dateformat_style)# (#timeformat(GET_PAYMENT_ROWS.UPDATE_DATE[i],timeformat_style)#)
                                            </cfif>
                                            </td>
                                        </tr>
                                    </cfoutput>
                                    <cfelse>
                                    <cfoutput>
                                    <tr>
                                        <cfif xml_change_row eq 1>
                                            <td class="text-center">
                                                <div class="form-group">
                                                    <input type="checkbox" name="is_change#i#" id="is_change#i#" value="<cfif GET_PAYMENT_ROWS.IS_BILLED[i] eq 0 and GET_PAYMENT_ROWS.IS_COLLECTED_PROVISION[i] eq 0 and GET_PAYMENT_ROWS.IS_PAID[i] eq 0>#i#,#GET_PAYMENT_ROWS.SUBSCRIPTION_PAYMENT_ROW_ID[i]#</cfif>" checked><!--- value kismi, toplu silme kontrolleri icin dolduruluyor --->
                                                </div>
                                            </td>
                                        </cfif>
                                        <td class="text-center">
                                            <cfif len(GET_PAYMENT_ROWS.INVOICE_ID[i]) and GET_PAYMENT_ROWS.IS_PAID[i] eq 0 and GET_PAYMENT_ROWS.IS_COLLECTED_PROVISION[i] eq 0 and len(GET_PAYMENT_ROWS.CARD_PAYMETHOD_ID[i])><!---&action_value=#GET_PAYMENT_ROWS.ROW_NET_TOTAL[i]#--->
                                                <cfset donem_db = "#dsn#_#GET_PAYMENT_ROWS.period_year[i]#_#session.ep.company_id#">
                                                <cfquery name="getInvoiceNettotal" datasource="#donem_db#">
                                                    SELECT NETTOTAL FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PAYMENT_ROWS.INVOICE_ID[i]#">
                                                </cfquery>
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=bank.popup_add_online_pos&member_type=#MEMBER_TYPE#&member_id=#MEMBER_ID#&card_id_info=#MEMBER_CC_ID#&action_value=#getInvoiceNettotal.NETTOTAL#&invoice_id=#GET_PAYMENT_ROWS.INVOICE_ID[i]#&period_id=#GET_PAYMENT_ROWS.PERIOD_ID[i]#&paym_id=#GET_PAYMENT_ROWS.CARD_PAYMETHOD_ID[i]#','medium');"></span>
                                                    </div>
                                                </div>
                                            </cfif>
                                        </td>
                                        <td>
                                            <cfif GET_PAYMENT_ROWS.IS_BILLED[i] eq 0 and GET_PAYMENT_ROWS.IS_COLLECTED_PROVISION[i] eq 0 and GET_PAYMENT_ROWS.IS_PAID[i] eq 0>
                                                <cfif (not listfindnocase(denied_pages,"sales.emptypopup_del_subs_pay_plan_row"))><!--- Butona kisit koyma FBS20140327 --->
                                                    <a href="javascript://" onclick="camp_control_row(#i#,#GET_PAYMENT_ROWS.SUBSCRIPTION_PAYMENT_ROW_ID[i]#,'');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
                                                </cfif>
                                            </cfif>
                                            <cfif len(GET_PAYMENT_ROWS.INVOICE_ID[i])>
                                                <a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_detail_invoice&id=#GET_PAYMENT_ROWS.INVOICE_ID[i]#&period_id=#GET_PAYMENT_ROWS.PERIOD_ID[i]#</cfoutput>','page');" class="tableyazi"><i class="fa fa-clipboard"></i></i></a><cfif len(GET_PAYMENT_ROWS.IS_INVOICE_IPTAL[i])><font color="red" size="+1"><b>*</b></font></cfif>
                                            </cfif>
                                        </td>
                                        <td class="text-center"><div class="form-group"><input type="checkbox" name="is_active#i#" id="is_active#i#" <cfif GET_PAYMENT_ROWS.IS_ACTIVE[i] eq 1>checked</cfif>></div></td>
                                        <td>
                                            <div class="form-group">
                                                <div class="input-group">
                                                    <input type="hidden" name="is_disabled_#i#" id="is_disabled_#i#" value="0">
                                                    <input type="hidden" name="payment_row_id#i#" id="payment_row_id#i#" value="#GET_PAYMENT_ROWS.SUBSCRIPTION_PAYMENT_ROW_ID[i]#">
                                                    <input type="text" name="payment_date#i#" id="payment_date#i#" value="#DateFormat(GET_PAYMENT_ROWS.PAYMENT_DATE[i],dateformat_style)#" class="boxtext" validate="#validate_style#" maxlength="10" readonly>
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="payment_date#i#"></span>
                                                </div>
                                            </div>
                                        </td>
                                        <cfif xml_payment_finish_date eq 1>
                                            <td>
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <cfinput type="text" name="payment_finish_date#i#" class="boxtext" value="#DateFormat(GET_PAYMENT_ROWS.PAYMENT_FINISH_DATE[i],dateformat_style)#" validate="#validate_style#" maxlength="10">
                                                        <span class="input-group-addon"><cf_wrk_date_image date_field="payment_finish_date#i#"></div>
                                                    </div>
                                                </div>
                                            </td>
                                        </cfif>
                                            <input type="hidden" name="product_id#i#" id="product_id#i#" value="#GET_PAYMENT_ROWS.PRODUCT_ID[i]#">
                                            <input type="hidden" name="stock_id#i#" id="stock_id#i#" value="#GET_PAYMENT_ROWS.STOCK_ID[i]#">
                                            <input type="hidden" name="unit_id#i#" id="unit_id#i#" value="#GET_PAYMENT_ROWS.UNIT_ID[i]#">
                                        <td width="200">
                                            <div class="form-group">
                                                <div class="input-group">
                                                    <input type="text" name="detail#i#" id="detail#i#" value="#GET_PAYMENT_ROWS.DETAIL[i]#" class="boxtext" maxlength="50">
                                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_names&product_id=show_pay_plan.product_id#i#&field_id=show_pay_plan.stock_id#i#&field_unit_name=show_pay_plan.unit#i#&field_main_unit=show_pay_plan.unit_id#i#&field_name=show_pay_plan.detail#i#</cfoutput>');"></span>
                                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_detail_product&pid=#GET_PAYMENT_ROWS.PRODUCT_ID[i]#</cfoutput>');"></span>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="form-group">
                                                <div class="input-group">
                                                    <input type="hidden" name="card_paymethod_id#i#" id="card_paymethod_id#i#" value="#GET_PAYMENT_ROWS.CARD_PAYMETHOD_ID[i]#">
                                                    <input type="hidden" name="paymethod_id#i#" id="paymethod_id#i#" value="#GET_PAYMENT_ROWS.PAYMETHOD_ID[i]#">
                                                    <input type="text" name="paymethod#i#" id="paymethod#i#" class="boxtext" value="<cfif len(GET_PAYMENT_ROWS.PAYMETHOD[i])>#GET_PAYMENT_ROWS.PAYMETHOD[i]#<cfelseif len(GET_PAYMENT_ROWS.CARD_PAYMETHOD_ID[i])>#GET_PAYMENT_ROWS.CARD_NO[i]#</cfif>" readonly="yes" maxlength="50" disabled>
                                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=show_pay_plan.paymethod_id#i#&field_name=show_pay_plan.paymethod#i#&field_card_payment_id=show_pay_plan.card_paymethod_id#i#&field_card_payment_name=show_pay_plan.paymethod#i#</cfoutput>');"></span>
                                                </div>
                                            </div>
                                        </td>
                                        <td><div class="form-group"><input type="text" name="unit#i#" id="unit#i#" class="box" maxlength="10" value="#GET_PAYMENT_ROWS.UNIT[i]#" readonly="yes"></div></td>
                                        <cfif x_payment_plan_kdv>
                                            <td><div class="form-group"><input type="text" name="kdv_rate#i#" id="kdv_rate#i#" class="moneybox" maxlength="10" value="#GET_PAYMENT_ROWS.TAX[i]#" readonly="yes"></div></td>
                                        <cfelse>
                                            <input type="hidden" name="kdv_rate#i#" id="kdv_rate#i#" maxlength="10" value="#GET_PAYMENT_ROWS.TAX[i]#" readonly="yes">
                                        </cfif>
                                        <cfif x_payment_plan_otv>
                                            <td><div class="form-group"><input type="text" name="otv_rate#i#" id="otv_rate#i#" class="moneybox" maxlength="10" value="#GET_PAYMENT_ROWS.OTV[i]#" readonly="yes" disabled></div></td>
                                        <cfelse>
                                            <input type="hidden" name="otv_rate#i#" id="otv_rate#i#" maxlength="10" value="#GET_PAYMENT_ROWS.OTV[i]#" readonly="yes" disabled>
                                        </cfif>
                                        <td title="<cf_get_lang dictionary_id='57635.Miktar'>"><div class="form-group"><cfinput type="text" name="quantity#i#" class="box" value="#GET_PAYMENT_ROWS.QUANTITY[i]#" onChange="is_zero(#i#)" onBlur="return hesapla(#i#);"></div></td>
                                        <td title="<cf_get_lang dictionary_id='57673.Tutar'>"><div class="form-group"><input type="text" name="amount#i#" id="amount#i#" class="moneybox" value="#TLFormat(GET_PAYMENT_ROWS.AMOUNT[i],price_round_number)#" onblur="hesapla(#i#);AmountRnd('amount#i#',<cfoutput>#price_round_number#</cfoutput>);"></div></td>
                                        <td title="<cf_get_lang dictionary_id='57489.Para Br'>">
                                            <div class="form-group">
                                                <select name="money_type_row#i#" id="money_type_row#i#" >
                                                    <cfloop query="GET_MONEY">
                                                        <option value="#MONEY#" <cfif GET_MONEY.MONEY eq GET_PAYMENT_ROWS.MONEY_TYPE[i]> selected </cfif>>#MONEY#</option>
                                                    </cfloop>
                                                </select>
                                            </div>
                                        </td>
                                        <td><div class="form-group"><input type="text" name="row_bsmv_rate#i#" id="row_bsmv_rate#i#" class="moneybox" readonly="yes" value="#TLFormat(GET_PAYMENT_ROWS.BSMV_RATE[i],price_round_number)#"></div></td>
                                        <td style="display:none;"><div class="form-group"><input type="text" name="row_bsmv_amount#i#" id="row_bsmv_amount#i#" class="boxtext" readonly="yes" value="#TLFormat(GET_PAYMENT_ROWS.BSMV_AMOUNT[i],price_round_number)#"></div></td>
                                        <td style="display:none;"><div class="form-group"><input type="text" name="row_reason_code#i#" id="row_reason_code#i#" class="boxtext" readonly="yes" value="#GET_PAYMENT_ROWS.REASON_CODE[i]#"></div></td>
                                        <td><div class="form-group"><input type="text" name="row_oiv_rate#i#" id="row_oiv_rate#i#" class="moneybox" readonly="yes" value="#TLFormat(GET_PAYMENT_ROWS.OIV_RATE[i],price_round_number)#"></div></td>
                                        <td style="display:none;"><div class="form-group"><input type="text" name="row_oiv_amount#i#" id="row_oiv_amount#i#" class="boxtext" readonly="yes" value="#TLFormat(GET_PAYMENT_ROWS.OIV_AMOUNT[i],price_round_number)#"></div></td>
                                        <cfif xml_tevkifat_rate>
                                            <td><div class="form-group"><input type="text" name="row_tevkifat_rate#i#" id="row_tevkifat_rate#i#" class="moneybox" readonly="yes" value="#TLFormat(GET_PAYMENT_ROWS.TEVKIFAT_RATE[i],price_round_number)#" onblur="hesapla(#i#,'row_tevkifat_rate');AmountRnd('row_tevkifat_rate#i#',<cfoutput>#price_round_number#</cfoutput>)"></div></td>
                                            <td style="display:none;"><div class="form-group"><input type="text" name="row_tevkifat_amount#i#" id="row_tevkifat_amount#i#" class="boxtext" readonly="yes" value="#TLFormat(GET_PAYMENT_ROWS.TEVKIFAT_AMOUNT[i],price_round_number)#" onblur="hesapla(#i#,'row_tevkifat_amount');AmountRnd('row_tevkifat_amount#i#',<cfoutput>#price_round_number#</cfoutput>)"></div></td>
                                        </cfif>
                                        <cfif xml_payment_rate>
                                            <td title="<cf_get_lang dictionary_id='57648.Kur'>"><div class="form-group"><input type="text" name="row_rate#i#" id="row_rate#i#" value="#TLFormat(get_payment_rows.rate[i])#" class="moneybox" onkeyup="return(FormatCurrency(this,event,4));"></div></td>
                                        </cfif>
                                        <td title="<cf_get_lang dictionary_id='41113.Satır Toplamı'>"><div class="form-group"><input type="text" name="row_total#i#" id="row_total#i#" class="moneybox" value="#TLFormat(GET_PAYMENT_ROWS.ROW_TOTAL[i],price_round_number)#" onblur="AmountRnd('ROW_TOTAL#i#',<cfoutput>#price_round_number#</cfoutput>);" onkeyup="return(FormatCurrency(this,event));" readonly="yes"></div></td>
                                         <cfif x_payment_plan_isk_amount>
                                            <td title="<cf_get_lang dictionary_id='57641.İSK'> <cf_get_lang dictionary_id='57673.Tutar'>"><div class="form-group"><input type="text" name="discount_amount#i#" id="discount_amount#i#" class="moneybox" value="#TLFormat(GET_PAYMENT_ROWS.DISCOUNT_AMOUNT[i])#" validate="float" onblur="return indirim_hesapla(#i#);" onkeyup="return(FormatCurrency(this,event));"></div></td>
                                        <cfelse>
                                            <input type="hidden" name="discount_amount#i#" id="discount_amount#i#" class="moneybox" value="#TLFormat(GET_PAYMENT_ROWS.DISCOUNT_AMOUNT[i])#" validate="float" onblur="return indirim_hesapla(#i#);" onkeyup="return(FormatCurrency(this,event));">
                                        </cfif>
                                        <td title="<cf_get_lang dictionary_id='57641.İSK'>(%)"><div class="form-group"><input type="text" name="discount#i#" id="discount#i#" class="moneybox" value="#TLFormat(GET_PAYMENT_ROWS.DISCOUNT[i])#" onblur="return indirim_hesapla(#i#);" onkeyup="return(FormatCurrency(this,event));"></div></td>
                                        <td title="<cf_get_lang dictionary_id='41114.Net Satır Top'>"><div class="form-group"><input type="text" name="row_net_total#i#" id="row_net_total#i#" class="moneybox" value="#TLFormat(GET_PAYMENT_ROWS.ROW_NET_TOTAL[i],session.ep.our_company_info.rate_round_num)#" onblur="return discount_hesapla(#i#);" onkeyup="return(FormatCurrency(this,event));"></div></td>
                                        <cfif x_payment_plan_kdv_amount>
                                            <cfset nettotal_kdv = GET_PAYMENT_ROWS.ROW_NET_TOTAL[i]*GET_PAYMENT_ROWS.TAX[i]/100>
                                            <cfset nettotal_otv = GET_PAYMENT_ROWS.ROW_NET_TOTAL[i]*GET_PAYMENT_ROWS.OTV[i]/100>
                                            <cfset nettotal_bsmv = GET_PAYMENT_ROWS.BSMV_AMOUNT[i]>
                                            <cfset nettotal_oiv = GET_PAYMENT_ROWS.OIV_AMOUNT[i]>
                                            <cfset nettotal_tevkifat = GET_PAYMENT_ROWS.TEVKIFAT_AMOUNT[i]>
                                            <td title="KDV'li <cf_get_lang dictionary_id='41114.Net Satır Top'>"><div class="form-group"><input type="text" name="row_last_net_total#i#" id="row_last_net_total#i#" class="moneybox" value="#TLFormat(GET_PAYMENT_ROWS.ROW_NET_TOTAL[i]+nettotal_kdv+nettotal_otv+nettotal_bsmv+nettotal_oiv-nettotal_tevkifat)#" onblur="return discount_hesapla(#i#);" onkeyup="return(FormatCurrency(this,event));" readonly="yes"></div></td>
                                        </cfif>
                                        <td class="text-center" title="<cf_get_lang dictionary_id='41110.Toplu Fatr Dah'>"><div class="form-group"><input type="checkbox" name="is_collected_inv#i#" id="is_collected_inv#i#" <cfif GET_PAYMENT_ROWS.IS_COLLECTED_INVOICE[i] eq 1>checked</cfif> onclick="select_row_bill_type(1,#i#);"></div></td>
                                        <td class="text-center" title="<cf_get_lang dictionary_id ='41302.Grup Fatura Dah'>"><div class="form-group"><input type="checkbox" name="is_group_inv#i#" id="is_group_inv#i#" <cfif GET_PAYMENT_ROWS.IS_GROUP_INVOICE[i] eq 1>checked</cfif> onclick="select_row_bill_type(2,#i#);"></div></td>
                                        <td class="text-center" title="<cf_get_lang dictionary_id='41115.Faturalandı'>"><div class="form-group"><input type="checkbox" name="is_billed#i#" id="is_billed#i#" <cfif GET_PAYMENT_ROWS.IS_BILLED[i] eq 1>checked</cfif> onclick="fatura_kontrol(this,#i#);"></div></td>
                                        <td title="<cf_get_lang dictionary_id='41116.Fatura ID'>">
                                            <div class="form-group">
                                                <div class="input-group">
                                                    <input type="hidden" name="period_id#i#" id="period_id#i#" value="#GET_PAYMENT_ROWS.PERIOD_ID[i]#">
                                                    <input type="text" name="invoice_id#i#" id="invoice_id#i#" value="#GET_PAYMENT_ROWS.INVOICE_ID[i]#" readonly="yes">
                                                    <input type="hidden" name="bill_info#i#" id="bill_info#i#">
                                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="javascript:openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_bills&field_name=show_pay_plan.bill_info#i#&field_id=show_pay_plan.invoice_id#i#&field_per_id=show_pay_plan.period_id#i#&cat=1&invoice_is_cash=0&field_is_billed=show_pay_plan.is_billed#i#&subscription_id=#attributes.contract_id#</cfoutput>');"></span>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-center" title="<cf_get_lang dictionary_id='41118.Toplu Prov Oluşturuldu'>"><div class="form-group"><input type="checkbox" name="is_collected_prov#i#" id="is_collected_prov#i#" <cfif GET_PAYMENT_ROWS.IS_COLLECTED_PROVISION[i] eq 1>checked</cfif>></div></td>
                                        <td class="text-center" title="<cf_get_lang dictionary_id='41117.Ödendi'>">
                                            <div class="form-group">
                                                <input type="checkbox" name="is_paid#i#" id="is_paid#i#" onclick="cari_kontrol(this,#i#);" <cfif GET_PAYMENT_ROWS.IS_PAID[i] eq 1>checked</cfif>>
                                                <cfif len(GET_PAYMENT_ROWS.CARI_ACT_TYPE[i]) and GET_PAYMENT_ROWS.IS_PAID[i] eq 1>
                                                    <cfset type = ''>
                                                    <cfswitch expression = "#GET_PAYMENT_ROWS.CARI_ACT_TYPE[i]#">
                                                        <cfcase value="24"><cfset type="ch.popup_dsp_gelenh&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                        <cfcase value="31"><cfset type="ch.popup_dsp_cash_revenue&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                        <cfcase value="42"><cfset type="ch.popup_print_upd_debit_claim_note&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                        <cfcase value="43"><cfset type="objects.popup_cari_action&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                        <cfcase value="90"><cfset type="ch.popup_dsp_payroll_entry&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                        <cfcase value="97"><cfset type="ch.popup_dsp_voucher_payroll_action&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                        <cfcase value="241"><cfset type="ch.popup_dsp_credit_card_payment_type"></cfcase>
                                                        <cfcase value="251"><cfset type="bank.popup_dsp_assign_order&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#"></cfcase>
                                                    </cfswitch>
                                                    <cfif listfind('24,31,32,241,242,251,43',GET_PAYMENT_ROWS.CARI_ACT_TYPE[i],',')>
                                                        <cfset page_type = 'small'>
                                                    <cfelse>
                                                        <cfset page_type = 'page'>
                                                    </cfif>
                                                    <cfif GET_PAYMENT_ROWS.CARI_ACT_TABLE[i] is 'CHEQUE'> 
                                                        <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_cheque_det&ID=#GET_PAYMENT_ROWS.CARI_ACT_ID[i]#&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#','small')">
                                                        <img src="/images/ship_list.gif" border="0" align="absmiddle">
                                                        </a>
                                                    <cfelseif GET_PAYMENT_ROWS.CARI_ACT_TABLE[i] is 'VOUCHER'> 
                                                        <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_voucher_det&ID=#GET_PAYMENT_ROWS.CARI_ACT_ID[i]#&period_id=#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#','small')">
                                                        <img src="/images/ship_list.gif" border="0" align="absmiddle">
                                                        </a>
                                                    <cfelse>													
                                                        <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#GET_PAYMENT_ROWS.CARI_ACT_ID[i]#','#page_type#');" title="İşlem Detayı">
                                                        <img src="/images/ship_list.gif" border="0" align="absmiddle">
                                                        </a>
                                                    </cfif>
                                                <cfelse>
                                                </cfif>
                                            </div>
                                        </td>
                                            <td title="<cf_get_lang dictionary_id='41117.Ödendi'>">
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <input type="hidden" name="cari_act_type#i#" id="cari_act_type#i#" value="#GET_PAYMENT_ROWS.CARI_ACT_TYPE[i]#">
                                                        <input type="hidden" name="cari_act_table#i#" id="cari_act_table#i#" value="#GET_PAYMENT_ROWS.CARI_ACT_TABLE[i]#">
                                                        <input type="hidden" name="cari_act_id#i#" id="cari_act_id#i#" value="#GET_PAYMENT_ROWS.CARI_ACT_ID[i]#">
                                                        <input type="hidden" name="cari_period_id#i#" id="cari_period_id#i#" value="#GET_PAYMENT_ROWS.CARI_PERIOD_ID[i]#">
                                                        <input type="text" name="cari_action_id#i#" id="cari_action_id#i#" value="#GET_PAYMENT_ROWS.CARI_ACTION_ID[i]#" readonly="yes">
                                                            <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="javascript:openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_cari_actions&is_paid=show_pay_plan.is_paid#i#&field_id=show_pay_plan.cari_action_id#i#&field_act_id=show_pay_plan.cari_act_id#i#&field_act_type=show_pay_plan.cari_act_type#i#&field_period_id=show_pay_plan.cari_period_id#i#&field_act_table=show_pay_plan.cari_act_table#i#</cfoutput>');"></span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td title="<cf_get_lang dictionary_id='57483.Kayıt'>">
                                            <cfif len(GET_PAYMENT_ROWS.RECORD_EMP_NAME[i])>
                                                #GET_PAYMENT_ROWS.RECORD_EMP_NAME[i]# -  <cfif len(GET_PAYMENT_ROWS.RECORD_DATE[i])> #dateformat(dateadd('h',session.ep.time_zone,GET_PAYMENT_ROWS.RECORD_DATE[i]),dateformat_style)# (#timeformat(GET_PAYMENT_ROWS.RECORD_DATE[i],timeformat_style)#)</cfif>
                                            </cfif>
                                            </td>
                                            <td title="<cf_get_lang dictionary_id='57891.Güncelleyen'>">
                                            <cfif len(GET_PAYMENT_ROWS.UPDATE_EMP_NAME[i])>
                                                #GET_PAYMENT_ROWS.UPDATE_EMP_NAME[i]# - #dateformat(dateadd('h',session.ep.time_zone,GET_PAYMENT_ROWS.UPDATE_DATE[i]),dateformat_style)# (#timeformat(GET_PAYMENT_ROWS.UPDATE_DATE[i],timeformat_style)#)
                                            </cfif>
                                            </td>
                                        </tr>
                                        </cfoutput>		
                                    </cfif>
                                    </cfloop>
                                <cfelse>
                                    <tr>
                                        <td colspan="40" id="kayit_yok"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
                                    </tr>
                                </cfif>
                            </tbody>
                        </cf_grid_list>
                        
                        <div class="ui-info-bottom flex-end">
                            <cfif isdefined("get_payment_rows_invoice.recordcount") and len(get_payment_rows_invoice.recordcount)>
                               <div id="workcube_button" class="pull-right">
                                   <input type="button" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left" onclick="fatura_kes()" value="<cf_get_lang dictionary_id='41175.Fatura Kes'>">
                               </div>
                           </cfif>
                           <cfif not(xml_control_payment_rows eq 1 and control_prov_rows.recordcount gt 0)>
                               <cf_workcube_buttons is_upd='0' add_function='control_input()'>
                           </cfif> 
                               
                        </div>
                </cfform> 
            </cf_box>
              <!--- cek ve senetler --->
              <cfsavecontent variable="message_work"><cf_get_lang dictionary_id='58007.Cek'>/<cf_get_lang dictionary_id='58008.Senet'></cfsavecontent>
                <cf_box 
                closable="0"
                box_page="#request.self#?fuseaction=contract.emptypopup_list_cheq_voucher&contract_id=#attributes.contract_id#"
                title="#message_work#"></cf_box>
            
        <!--- iliskili isler --->
        <cfsavecontent variable="message_work"><cf_get_lang dictionary_id='58020.İşler'></cfsavecontent>
            <cf_box 
            id="contract_works"
            closable="0"
            box_page="#request.self#?fuseaction=contract.emptypopup_list_contract_works&contract_id=#attributes.contract_id#&x_project_works=#x_project_works#&x_contract_work_budget=#x_contract_work_budget#&x_contract_work_price=#x_contract_work_price#&project_id=#get_contact_detail.project_id#"
            title="#message_work#"></cf_box>
           
    
          
          
            
           
                <!--- ÖDENE PLANI --->
                <cfform name="payment_plan_det">
                   
                    <input name="contract_id" id="contract_id" type="hidden" value="<cfoutput>#get_contact_detail.contract_id#</cfoutput>">
                    <input name="record_num" id="record_num" type="hidden" value="<cfoutput>#GET_PAYMENT_ROWS.recordcount#</cfoutput>">
                    <input name="record" id="record" type="hidden" value="0">
                    <input type="hidden" name="start_date" id="start_date" value="<cfoutput><cfif len(GET_PAYMENT.START_DATE)>#dateformat(GET_PAYMENT.START_DATE,dateformat_style)#<cfelseif isdefined("attributes.start_date")>#attributes.start_date#</cfif></cfoutput>">
                    <input name="count_camp" id="count_camp" type="hidden" value="0">
                    <input name="camp_id" id="camp_id" type="hidden">
                    <cfoutput>
                        <cfif len(GET_PAYMENT.STOCK_ID)>
                            <cfquery name="get_tax" datasource="#dsn3#">
                                SELECT TAX,OTV FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PAYMENT.STOCK_ID#">
                            </cfquery>
                            <cfset tax_info = get_tax.tax>
                            <cfset otv_info = get_tax.otv>
                        <cfelseif isdefined("attributes.stock_id") and len(attributes.stock_id)>
                            <cfquery name="get_tax" datasource="#dsn3#">
                                SELECT TAX,OTV FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
                            </cfquery>
                            <cfset tax_info = get_tax.tax>
                            <cfset otv_info = get_tax.otv>
                        <cfelse>
                            <cfset tax_info = ''>
                            <cfset otv_info = ''>
                        </cfif>
                            <input type="hidden" name="product_id" id="product_id" value="<cfif len(GET_PAYMENT.PRODUCT_ID)>#GET_PAYMENT.PRODUCT_ID#<cfelseif isdefined("attributes.product_id")>#attributes.product_id#</cfif>">
                            <input type="hidden" name="stock_id" id="stock_id" value="<cfif len(GET_PAYMENT.STOCK_ID)>#GET_PAYMENT.STOCK_ID#<cfelseif isdefined("attributes.stock_id")>#attributes.stock_id#</cfif>">
                            <input type="hidden" name="unit_id" id="unit_id" value="<cfif len(GET_PAYMENT.UNIT_ID)>#GET_PAYMENT.UNIT_ID#<cfelseif isdefined("attributes.unit_id")>#attributes.unit_id#</cfif>">
                            <input type="hidden" name="tax" id="tax" value="#tax_info#">
                            <input type="hidden" name="otv" id="otv" value="#otv_info#">
                            <input type="hidden" name="product_name" id="product_name" value="<cfif len(GET_PAYMENT.PRODUCT_ID)>#get_product_name(GET_PAYMENT.PRODUCT_ID)#<cfelseif isdefined("attributes.product_name")>#attributes.product_name#</cfif>" passthrough="readonly=yes">
                        <cfif len(GET_PAYMENT.QUANTITY)>
                            <input type="hidden" name="quantity" id="quantity" value="#GET_PAYMENT.QUANTITY#" validate="float">
                        <cfelse>
                            <input type="hidden" name="quantity" id="quantity" value="<cfif isdefined("attributes.quantity")>#attributes.quantity#</cfif>" validate="float" required="yes">
                        </cfif>	
                        <input type="hidden" name="unit" id="unit" value="<cfif len(GET_PAYMENT.UNIT)>#GET_PAYMENT.UNIT#<cfelseif isdefined("attributes.unit")>#attributes.unit#</cfif>" required="yes" message="#message#" maxlength="10">
                        <input type="hidden" name="amount" id="amount"  value="<cfif len(GET_PAYMENT.AMOUNT)>#TLFormat(GET_PAYMENT.AMOUNT,price_round_number)#<cfelseif isdefined("attributes.amount")>#TLFormat(attributes.amount,price_round_number)#</cfif>" >    
                        <input type="hidden" name="net_amount"  id="net_amount" onblur="hesapla_main(1);AmountRnd('net_amount',#price_round_number#);" value="<cfif len(GET_PAYMENT.AMOUNT)>#TLFormat(GET_PAYMENT.AMOUNT,price_round_number)#<cfelseif isdefined("attributes.net_amount")>#TLFormat(attributes.net_amount,price_round_number)#</cfif>">
                        <input type="hidden" name="discount"  id="discount" onblur="hesapla_main(2);" value="<cfif isdefined("attributes.discount")>#TLFormat(attributes.discount)#</cfif>" onkeyup="return(FormatCurrency(this,event));"> 
                        <input type="hidden" name="money_type"  id="money_type" value="#GET_PAYMENT.MONEY_TYPE#"> 
                        <input type="hidden" name="period"  id="period" value="#GET_PAYMENT.PERIOT#">
                        <cfif len(GET_PAYMENT.PAYMETHOD_ID)>
                            <cfquery name="GET_PAYMETHOD" datasource="#dsn#">
                                SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PAYMENT.PAYMETHOD_ID#">
                            </cfquery>
                        <cfelseif len(GET_PAYMENT.CARD_PAYMETHOD_ID)>
                            <cfquery name="GET_CARD_PAYMETHOD" datasource="#dsn3#">
                                SELECT CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PAYMENT.CARD_PAYMETHOD_ID#">
                            </cfquery>
                        </cfif>
                            <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="<cfif len(GET_PAYMENT.CARD_PAYMETHOD_ID)>#GET_PAYMENT.CARD_PAYMETHOD_ID#<cfelseif isdefined("attributes.card_paymethod_id")>#attributes.card_paymethod_id#</cfif>">
                            <input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfif len(GET_PAYMENT.PAYMETHOD_ID)>#GET_PAYMENT.PAYMETHOD_ID#<cfelseif isdefined("attributes.paymethod_id")>#attributes.paymethod_id#</cfif>">
                            <input type="hidden" name="paymethod" id="paymethod" value="<cfif len(GET_PAYMENT.PAYMETHOD_ID)>#GET_PAYMETHOD.PAYMETHOD#<cfelseif len(GET_PAYMENT.CARD_PAYMETHOD_ID)>#GET_CARD_PAYMETHOD.CARD_NO#<cfelseif isdefined("attributes.paymethod")>#attributes.paymethod#</cfif>">
                            <input type="hidden" name="count" id="count" validate="integer" value="<cfoutput>#attributes.count#</cfoutput>" maxlength="3">    
                            <input type="hidden" name="process_stage" id="process_stage" value="<cfoutput><cfif len(GET_PAYMENT.process_stage)>#GET_PAYMENT.process_stage#<cfelseif isdefined("attributes.process_stage")>#attributes.process_stage#</cfif></cfoutput>">
                            <input type="hidden" name="top_fat_dah" id="top_fat_dah">
                        </cfoutput>
                </cfform>
       
    </div>
</div>
    <!--- Fatura Ekleme icin eklenen form--->
    <form name="add_invoice" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=invoice.form_add_bill">
        <cfif len(get_contact_detail.company_id)>
            <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_contact_detail.company_id#</cfoutput>">
            <input type="hidden" name="comp_name" id="comp_name" value="<cfoutput>#get_par_info(get_contact_detail.company_id,1,1,0)#</cfoutput>">
            <input type="hidden" name="consumer_id" id="consumer_id" value="">
            <input type="hidden" name="partner_name" id="partner_name" value="<cfoutput>#get_par_info(get_contact_detail.employee,0,-1,0)#</cfoutput>">
            <input type="hidden" name="member_account_code" id="member_account_code" value="<cfoutput>#get_company_period(get_contact_detail.company_id)#</cfoutput>">
        <cfelse>
            <input type="hidden" name="company_id" id="company_id" value="">
            <input type="hidden" name="comp_name" id="comp_name" value="">
            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_contact_detail.consumer_id#</cfoutput>">
            <input type="hidden" name="partner_name" id="partner_name" value="<cfoutput>#get_cons_info(get_contact_detail.consumer_id,0,0)#</cfoutput>">
            <input type="hidden" name="member_account_code" id="member_account_code" value="<cfoutput>#get_consumer_period(get_contact_detail.consumer_id)#</cfoutput>">
        </cfif>
        <input type="hidden" name="list_payment_row_id" id="list_payment_row_id" value="">
        <input type="hidden" name="contract_id" id="contract_id" value="<cfoutput>#get_contact_detail.contract_id#</cfoutput>">
      
        <!--- faturalanmamis satirlarin tek tek faturalanması icin --->
    </form>
<script>

     function apply_row(type)
    {
        toplam = parseFloat(document.payment_plan_det.count_camp.value) + parseFloat(document.payment_plan_det.count.value) + parseFloat(document.payment_plan_det.record_num.value);
        for(var zz=1; zz<=toplam; zz++)
        {
            if(document.getElementById("is_change"+zz) != undefined && document.getElementById("is_change"+zz).checked == true)
            {
                if(type == 1)//aktif pasif
                {
                    if(document.getElementById('main_status').checked == true)
                        document.getElementById('is_active'+zz).checked = true;
                    else
                        document.getElementById('is_active'+zz).checked = false;
                }
                else if(type == 2)//start date
                {
                    
                    if(document.getElementById('main_start_date').value != '')
                        
                        document.getElementById('payment_date'+zz).value = document.getElementById('main_start_date').value;
                        
                }
                else if(type == 3)//ürün
                {
                    if(document.getElementById('main_product_id').value != '' && document.getElementById('main_product_name').value != '')
                    {
                        document.getElementById('product_id'+zz).value = document.getElementById('main_product_id').value;
                        document.getElementById('stock_id'+zz).value = document.getElementById('main_stock_id').value;
                        document.getElementById('unit_id'+zz).value = document.getElementById('main_unit_id').value;
                        document.getElementById('unit'+zz).value = document.getElementById('main_unit').value;
                        document.getElementById('detail'+zz).value = document.getElementById('main_product_name').value;
                    }
                }
                else if(type == 4)//ödeme yöntemi
                {
                    if(document.getElementById('main_paymethod').value != '')
                    {
                        document.getElementById('card_paymethod_id'+zz).value = document.getElementById('main_card_paymethod_id').value;
                        document.getElementById('paymethod_id'+zz).value = document.getElementById('main_paymethod_id').value;
                        document.getElementById('paymethod'+zz).value = document.getElementById('main_paymethod').value;
                    }
                }
                else if(type == 5)//miktar
                {
                    if(document.getElementById('main_quantity').value != '')
                    {
                        document.getElementById('quantity'+zz).value = document.getElementById('main_quantity').value;
                        hesapla(zz);
                    }
                }
                else if(type == 6)//tutar
                {
                    if(document.getElementById('main_amount_type').value == 3)
                        document.getElementById('amount'+zz).value = commaSplit(filterNum(document.getElementById('main_amount').value));
                    else if(document.getElementById('main_amount_type').value == 1)
                        document.getElementById('amount'+zz).value = commaSplit(parseFloat(filterNum(document.getElementById('amount'+zz).value)-filterNum(document.getElementById('main_amount').value)));
                    else if(document.getElementById('main_amount_type').value == 2)
                        document.getElementById('amount'+zz).value = commaSplit(parseFloat(filterNum(document.getElementById('amount'+zz).value))+parseFloat(filterNum(document.getElementById('main_amount').value)));
                    hesapla(zz);
                }
                else if(type == 7)//para birimi
                {
                    if(document.getElementById('main_money_type').value != '')
                        document.getElementById('money_type_row'+zz).value = document.getElementById('main_money_type').value;
                }
                else if(type == 8)//iskonto
                {
                    if(document.getElementById('main_discount').value != '')
                    {
                        document.getElementById('discount'+zz).value = document.getElementById('main_discount').value;
                        hesapla(zz);
                    }
                }
                else if(type == 9)//iskonto tutar
                {
                    if(document.getElementById('main_discount_amount').value != '')
                    {
                        document.getElementById('discount_amount'+zz).value = document.getElementById('main_discount_amount').value;
                        hesapla(zz);
                    }
                }
                else if(type == 10)//toplu fatura
                {
                    if(document.getElementById('main_is_collected_inv').checked == true)
                    {
                        document.getElementById('is_collected_inv'+zz).checked = true;
                        document.getElementById('is_group_inv'+zz).checked = false;
                    }
                    else
                        document.getElementById('is_collected_inv'+zz).checked = false;
                }
                else if(type == 11)//grup fatura
                {
                    if(document.getElementById('main_is_group_inv').checked == true)
                    {
                        document.getElementById('is_group_inv'+zz).checked = true;
                        document.getElementById('is_collected_inv'+zz).checked = false;
                    }
                    else
                        document.getElementById('is_group_inv'+zz).checked = false;
                }
                else if(type == 12)//toplu provizyon
                {
                    if(document.getElementById('main_is_collected_prov').checked == true)
                        document.getElementById('is_collected_prov'+zz).checked = true;
                    else
                        document.getElementById('is_collected_prov'+zz).checked = false;
                }
                else if(type == 13)//kampanya
                {
                    if(document.getElementById('main_camp_id') != undefined && document.getElementById('main_camp_id').value != '' && document.getElementById('main_camp_name').value != '')
                    {
                        if(document.getElementById('camp_id'+zz) != undefined)
                        {
                            document.getElementById('camp_id'+zz).value = document.getElementById('main_camp_id').value;
                            document.getElementById('camp_name'+zz).value = document.getElementById('main_camp_name').value;
                        }
                    }
                }
                else if(type == 14)//referans
                {
                    if(document.getElementById('main_subs_ref_id').value != '' && document.getElementById('main_subs_ref_name').value != '')
                    {
                        document.getElementById('subs_ref_id'+zz).value = document.getElementById('main_subs_ref_id').value;
                        document.getElementById('subs_ref_name'+zz).value = document.getElementById('main_subs_ref_name').value;
                    }
                }
                else if(type == 15)//servis
                {
                    if(document.show_pay_plan.main_service_id.value != '' && document.show_pay_plan.main_service_no.value != '')
                    {
                        document.getElementById('service_id'+zz).value = document.show_pay_plan.main_service_id.value;
                        document.getElementById('service_no'+zz).value = document.show_pay_plan.main_service_no.value;
                    }
                }
                else if(type == 16)//call center
                {
                    if(document.show_pay_plan.main_call_id.value != '' && document.show_pay_plan.main_call_no.value != '')
                    {
                        document.getElementById('call_id'+zz).value = document.show_pay_plan.main_call_id.value;
                        document.getElementById('call_no'+zz).value = document.show_pay_plan.main_call_no.value;
                    }
                }
                else if(type == 17)//finish date
                {
                    if(document.show_pay_plan.main_finish_date.value != '')
                        document.getElementById('payment_finish_date'+zz).value = document.show_pay_plan.main_finish_date.value;
                }
                else if(type == 18)//satirda kur bilgisi
                {
                    if(document.getElementById("main_rate").value != '')
                        document.getElementById("row_rate"+zz).value = document.getElementById("main_rate").value;
                }
                else if(type == 19)//tahsilat bilgisi
                {
                    if(document.getElementById("main_cari_act_type").value != '')
                        document.getElementById("cari_act_type"+zz).value = document.getElementById("main_cari_act_type").value;
                    else
                        document.getElementById("cari_act_type"+zz).value = '';
                    if(document.getElementById("main_cari_act_table").value != '')
                        document.getElementById("cari_act_table"+zz).value = document.getElementById("main_cari_act_table").value;
                    else
                        document.getElementById("cari_act_table"+zz).value = '';
                    if(document.getElementById("main_cari_act_id").value != '')
                        document.getElementById("cari_act_id"+zz).value = document.getElementById("main_cari_act_id").value;
                    else
                        document.getElementById("cari_act_id"+zz).value = '';
                    if(document.getElementById("main_cari_period_id").value != '')
                        document.getElementById("cari_period_id"+zz).value = document.getElementById("main_cari_period_id").value;
                    else
                        document.getElementById("cari_period_id"+zz).value = '';
                    if(document.getElementById("main_cari_action_id").value != '')
                        document.getElementById("cari_action_id"+zz).value = document.getElementById("main_cari_action_id").value;
                    else
                        document.getElementById("cari_action_id"+zz).value = '';
                }
                else if(type == 20)//ödendi
                {
                    if(document.getElementById('main_is_paid').checked == true)
                        document.getElementById('is_paid'+zz).checked = true;
                    else
                        document.getElementById('is_paid'+zz).checked = false;
                }
            }
        }
    }
    function add_row(sayi,period,row_product_id,row_stock_id,row_product_name,row_unit_id,row_unit,row_paymethod,row_card_paymethod,row_paymethod_name,row_amount,row_price,row_currency,row_camp_id,row_camp_name,row_discount,row_k_discount,row_repeat_number,row_free_repeat_number,kontrol_row_info,row_tax,row_otv,row_discount_amount,row_k_discount_amount,row_rate,row_bsmv_rate,row_bsmv_amount,row_bsmv_currency,row_oiv_rate,row_oiv_amount,row_tevkifat_rate,row_tevkifat_amount,row_reason_code)
    { 
        
        var yeni_tarih = document.payment_plan_det.start_date.value;
        var kayit = parseFloat(document.payment_plan_det.record_num.value);
        var satir = document.payment_plan_det.record.value;
          
        if(kontrol_row_info == undefined) kontrol_row_info = 0;
        if(kontrol_row_info == 0)
        {
            if (kayit==0)
                a=parseFloat(satir)+1;
            else
                a=parseFloat(satir)+kayit+1;
            all_count = a + parseFloat(sayi);
        }
        else
        {
            a=parseFloat(satir)+1+kayit;
            all_count = a + parseFloat(sayi);
        }
        var row_count,money_row,newRow,newCell;
        if(kontrol_row_info == 0)
        for(i=1; i<=all_count; i++)
        {
            if(eval("show_pay_plan.row_control"+i) != undefined && document.getElementById("frm_row"+i) != undefined)
            {
                var my_element=eval("show_pay_plan.row_control"+i);
                my_element.value=0;
                var my_element=eval("frm_row"+i);
                my_element.style.display="none";
            }
        }
        if(row_product_id == undefined) row_product_id = document.payment_plan.product_id.value;
        if(row_stock_id == undefined) row_stock_id = document.payment_plan.stock_id.value;
        if(row_product_name == undefined) row_product_name = document.payment_plan.product_name.value;
        if(row_unit_id == undefined) row_unit_id = document.payment_plan.unit_id.value;
        if(row_tax == undefined) row_tax = document.payment_plan.tax.value;
        if(row_otv == undefined) row_otv = document.payment_plan.otv.value;
        if(row_paymethod == undefined) row_paymethod = document.payment_plan.paymethod_id.value;
        if(row_card_paymethod == undefined) row_card_paymethod = document.payment_plan.card_paymethod_id.value;
        if(row_paymethod_name == undefined) row_paymethod_name = document.payment_plan.paymethod.value;
        if(row_unit == undefined) row_unit = document.payment_plan.unit.value;
        if(row_amount == undefined) row_amount = document.payment_plan.quantity.value;
        if(row_price == undefined) row_price = filterNum(document.payment_plan.amount.value,<cfoutput>#price_round_number#</cfoutput>);
        if(row_currency == undefined) row_currency = '';
        if(row_discount == undefined) row_discount = filterNum(document.payment_plan.discount.value);
        if(row_k_discount == undefined) row_k_discount = 0;
        if(row_discount_amount == undefined) row_discount_amount = 0;
        if(row_k_discount_amount == undefined) row_k_discount_amount = 0;
        if(row_repeat_number == undefined) row_repeat_number = 0;
        if(row_free_repeat_number == undefined) row_free_repeat_number = 0;
        if(row_camp_id == undefined) row_camp_id = '';
        if(row_camp_name == undefined) row_camp_name = '';	
        if(row_rate == undefined) row_rate = '';	
        if(row_bsmv_rate == undefined) row_bsmv_rate = 0;
        if(row_bsmv_amount == undefined) row_bsmv_amount = 0;
        if(row_bsmv_currency == undefined) row_bsmv_currency = 0;
        if(row_oiv_rate == undefined) row_oiv_rate = 0;
        if(row_oiv_amount == undefined ) row_oiv_amount = 0;
        if(row_tevkifat_rate == undefined) row_tevkifat_rate = 0;
        if(row_tevkifat_amount == undefined ) row_tevkifat_amount = 0;
        if(row_reason_code == undefined) row_reason_code = 0;
    
        if(document.payment_plan.product_id != undefined && document.payment_plan.product_id.value != ''){
            
            get_prod_info = wrk_query('SELECT BSMV, OIV FROM PRODUCT WHERE PRODUCT_ID='+document.payment_plan.product_id.value,'dsn3');
            row_bsmv_rate = get_prod_info.BSMV;
            row_oiv_rate = get_prod_info.OIV;
            get_prod_reason_code = wrk_query('SELECT REASON_CODE FROM PRODUCT_PERIOD WHERE PRODUCT_ID='+document.payment_plan.product_id.value + ' AND PERIOD_ID='+<cfoutput>#session.ep.period_id#</cfoutput>,'dsn3');
            row_reason_code = get_prod_reason_code.REASON_CODE;
                     
        }
        if(document.payment_plan.camp_id != undefined && document.payment_plan.camp_id.value != '' && document.payment_plan.is_camp_rules.checked == false)
        {
            get_camp_info=wrk_query('SELECT C.CAMP_ID,C.CAMP_HEAD FROM CAMPAIGNS C WHERE CAMP_ID='+document.all.camp_id.value,'dsn3');
            row_camp_id = get_camp_info.CAMP_ID;
            row_camp_name = get_camp_info.CAMP_HEAD;	
        }
        discount_info = 0;
        count_info = 0;
        
        for(row_count=a; row_count<all_count; row_count++)
        {
            kontrol_price = 0;
            var net_satir_toplam = row_price * row_amount;
            var satir_toplam = row_price * row_amount;
            count_info = count_info+1;
            if(document.payment_plan.camp_id != undefined)
                if(count_info > row_repeat_number && document.payment_plan.is_camp_rules.checked == true)
                {
                    row_camp_id = '';
                    row_camp_name = '';
                }
            if(count_info > row_free_repeat_number)
            {
                discount_info = row_discount;
                discount_amount_info = row_discount_amount;
            }
            else
            {
                discount_info = row_k_discount;
                discount_amount_info = row_k_discount_amount;
            }
            var satir_toplam = satir_toplam-(satir_toplam*discount_info/100);
            var satir_toplam = satir_toplam-discount_amount_info;
            if(row_count>a)//İlk Satırda tarih artmasın diye
            {
              
                if(period == 1)
                    yeni_tarih = date_add('m',+period,yeni_tarih,document.payment_plan.start_date.value);
                else
                    yeni_tarih = date_add('m',+period,yeni_tarih);
            }
            newRow = document.getElementById("table_1").insertRow(document.getElementById("table_1").rows.length);
            newRow.className = 'color-row';
            newRow.setAttribute("name","frm_row" + row_count);
            newRow.setAttribute("id","frm_row" + row_count);		
            newRow.setAttribute("NAME","frm_row" + row_count);
            newRow.setAttribute("ID","frm_row" + row_count);		
            newCell = newRow.insertCell(newRow.cells.length);
            
            <cfif xml_change_row eq 1>
                newCell = newRow.insertCell(newRow.cells.length);
            </cfif>
            newCell = newRow.insertCell(newRow.cells.length);
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute("class","text-center");
            newCell.innerHTML = '<div class="form-group"><input type="hidden" name="row_control' + row_count +'" id="row_control' + row_count +'" value="1"><input type="hidden" name="cari_act_table' + row_count +'" id="cari_act_table' + row_count +'" value=""><input type="hidden" name="cari_period_id' + row_count +'" id="cari_period_id' + row_count +'" value=""><input type="hidden" name="cari_act_id' + row_count +'" id="cari_act_id' + row_count +'" value=""><input type="hidden" name="cari_act_type' + row_count +'" id="cari_act_type' + row_count +'" value=""><input type="checkbox" name="is_active' + row_count +'" id="is_active' + row_count +'" checked></div>';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute('nowrap','nowrap');
            <cfif x_payment_plan_kdv eq 0>
                newCell.innerHTML = '<div class="form-group"><input type="hidden" name="kdv_rate' + row_count +'" id="kdv_rate' + row_count +'" class=""moneybox"" maxlength="10" value="'+row_tax+'" readonly="yes"></div>';
            </cfif>
            <cfif x_payment_plan_otv eq 0>
                newCell.innerHTML = '<div class="form-group"><input type="hidden" name="otv_rate' + row_count +'" class="moneybox" maxlength="10" value="'+row_otv+'" readonly="yes"></div>';
            </cfif>
            newCell.setAttribute('nowrap','nowrap');
            newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="payment_date' + row_count +'" id="payment_date' + row_count +'" class="boxtext" readonly maxlength="10" validate="<cfoutput>#validate_style#</cfoutput>" value="'+yeni_tarih+'"><input type="hidden" name="product_id' + row_count +'" value="'+row_product_id+'"><span class="input-group-addon" id="payment_date'+row_count+'_td"></span></div></div>';
            wrk_date_image('payment_date' + row_count);
    
            <cfif xml_payment_finish_date eq 1>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.setAttribute('nowrap','nowrap');
                newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="payment_finish_date' + row_count +'" id="payment_finish_date' + row_count +'" class="boxtext" readonly="yes"maxlength="10" validate="<cfoutput>#validate_style#</cfoutput>" value="'+yeni_tarih+'"><span class="input-group-addon" id="payment_finish_date'+row_count+'_td"></span></div></div>';
                wrk_date_image('payment_finish_date' + row_count);
            </cfif>
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute('nowrap','nowrap'); 
            newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="stock_id' + row_count +'" value="'+row_stock_id+'"><input type="hidden" name="unit_id' + row_count +'" value="'+row_unit_id+'"><input type="text" name="detail' + row_count +'" class="moneybox" maxlength="50" value="'+row_product_name+'"><span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=show_pay_plan.product_id" + row_count + "&field_id=show_pay_plan.stock_id" + row_count + "&field_unit_name=show_pay_plan.unit" + row_count + "&field_main_unit=show_pay_plan.unit_id" + row_count + "&field_name=show_pay_plan.detail" + row_count + "');"+'"></span><span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('+"'<cfoutput>#request.self#?fuseaction=objects.popup_detail_product</cfoutput>&pid=" + document.payment_plan.product_id.value + "');"+'"></span></div></div>';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute('nowrap','nowrap');
            newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="card_paymethod_id' + row_count +'" value="'+row_card_paymethod+'"><input type="hidden" name="paymethod_id' + row_count +'" value="'+row_paymethod+'"><input type="text" name="paymethod' + row_count +'" readonly="yes" class="moneybox" maxlength="50" value="'+row_paymethod_name+'"><span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('+"'<cfoutput>#request.self#?fuseaction=objects.popup_paymethods</cfoutput>&field_id=show_pay_plan.paymethod_id" + row_count + "&field_name=show_pay_plan.paymethod" + row_count + "&field_card_payment_id=show_pay_plan.card_paymethod_id" + row_count + "&field_card_payment_name=show_pay_plan.paymethod" + row_count + "');"+'"></span></div></div>';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<div class="form-group"><input type="text" name="unit' + row_count +'" class="moneybox" maxlength="10" value="'+row_unit+'" readonly="yes"></div>';
            
            <cfif x_payment_plan_kdv>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<div class="form-group"><input type="text" name="kdv_rate' + row_count +'" id="kdv_rate'+row_count+'" class="moneybox" maxlength="10" value="'+row_tax+'" readonly="yes"></div>';
            </cfif>
            <cfif x_payment_plan_otv>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<div class="form-group"><input type="text" name="otv_rate' + row_count +'" class="moneybox" maxlength="10" value="'+row_otv+'" readonly="yes"></div>';
            </cfif>
        
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<div class="form-group"><input type="text" name="quantity' + row_count +'" id="quantity' + row_count +'" onChange="is_zero(' + row_count + ')" class="box" value="'+row_amount+'" onBlur="return hesapla('+row_count+');"></div>';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<div class="form-group"><input type="text" name="amount' + row_count +'" id="amount' + row_count +'" class="moneybox" value="'+commaSplit(row_price,<cfoutput>#price_round_number#</cfoutput>)+'" onBlur="hesapla('+row_count+');AmountRnd(\'amount'+row_count+'\',<cfoutput>#price_round_number#</cfoutput>);"></div>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            c = '<div class="form-group"><select name="money_type_row' + row_count  +'" id="money_type_row' + row_count  +'" >';
            <cfoutput query="get_money">
            if('#money#' == row_currency)
                c += '<option value="#money#" selected>#money#</option>';
            else
                c += '<option value="#money#">#money#</option>';
            </cfoutput>
            newCell.innerHTML =c+ '</select></div>';
        
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<div class="form-group"><input type="text" name="row_bsmv_rate' + row_count +'" id="row_bsmv_rate' + row_count +'" class="moneybox" readonly="yes" value="'+commaSplit(row_bsmv_rate,<cfoutput>#price_round_number#</cfoutput>)+'"></div>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.style.display = 'none';
            newCell.innerHTML = '<div class="form-group"><input type="text" name="row_bsmv_amount' + row_count +'" id="row_bsmv_amount' + row_count +'" class="moneybox" readonly="yes" value="'+commaSplit(row_bsmv_amount,<cfoutput>#price_round_number#</cfoutput>)+'"></div>'; 
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.style.display = 'none';
            newCell.innerHTML = '<div class="form-group"><input type="text" name="row_reason_code' + row_count +'" id="row_reason_code' + row_count +'" style="display:none;" class="moneybox" readonly="yes" value="'+row_reason_code+'"></div>';
            
            <!--- newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="row_bsmv_currency' + row_count +'" id="row_bsmv_currency' + row_count +'" class="box" onkeyup="return(FormatCurrency(this,event));" value="'+commaSplit(row_bsmv_currency)+'" onBlur="hesapla('+row_count+',\'row_bsmv_currency\')">'; 
             --->
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<div class="form-group"><input type="text" name="row_oiv_rate' + row_count +'" id="row_oiv_rate' + row_count +'" class="moneybox" readonly="yes" onkeyup="return(FormatCurrency(this,event));" value="'+commaSplit(row_oiv_rate,<cfoutput>#price_round_number#</cfoutput>)+'" onBlur="hesapla('+row_count+',\'row_oiv_rate\');AmountRnd(\'row_oiv_rate'+row_count+'\',<cfoutput>#price_round_number#</cfoutput>);"></div>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.style.display = 'none';
            newCell.innerHTML = '<div class="form-group"><input type="text" name="row_oiv_amount' + row_count +'" id="row_oiv_amount' + row_count +'" class="moneybox" readonly="yes" onkeyup="return(FormatCurrency(this,event));" value="'+commaSplit(row_oiv_amount)+'" onBlur="hesapla('+row_count+',\'row_oiv_amount\');AmountRnd(\'row_oiv_amount'+row_count+'\',<cfoutput>#price_round_number#</cfoutput>);"></div>';
            <cfif xml_tevkifat_rate>
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<div class="form-group"><input type="text" name="row_tevkifat_rate' + row_count +'" id="row_tevkifat_rate' + row_count +'" class="moneybox" onkeyup="return(FormatCurrency(this,event));" value="'+commaSplit(row_tevkifat_rate)+'" onBlur="hesapla('+row_count+',\'row_tevkifat_rate\');AmountRnd(\'row_tevkifat_rate'+row_count+'\',<cfoutput>#price_round_number#</cfoutput>);"></div>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.style.display = 'none';
            newCell.innerHTML = '<div class="form-group"><input type="text" name="row_tevkifat_amount' + row_count +'" id="row_tevkifat_amount' + row_count +'" class="moneybox" onkeyup="return(FormatCurrency(this,event));" value="'+commaSplit(row_tevkifat_amount)+'" onBlur="hesapla('+row_count+',\'row_tevkifat_amount\');AmountRnd(\'row_tevkifat_amount'+row_count+'\',<cfoutput>#price_round_number#</cfoutput>);"></div>';
            </cfif>
            <cfif xml_payment_rate>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<div class="form-group"><input type="text" name="row_rate' + row_count +'" id="row_rate' + row_count +'" class="moneybox" onkeyup="return(FormatCurrency(this,event,4));" value="'+commaSplit(row_rate)+'"></div>';
            </cfif>
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<div class="form-group"><input type="text" name="row_total' + row_count +'" id="row_total' + row_count +'" class="moneybox" onkeyup="return(FormatCurrency(this,event));" value="'+commaSplit(net_satir_toplam,<cfoutput>#price_round_number#</cfoutput>)+'"  onBlur="indirim_hesapla('+row_count+');AmountRnd(\'row_total'+row_count+'\',<cfoutput>#price_round_number#</cfoutput>);" readonly="yes"></div>';
            
            <cfif x_payment_plan_isk_amount>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<div class="form-group"><input type="text" name="discount_amount' + row_count +'" id="discount_amount' + row_count +'" class="moneybox" onkeyup="return(FormatCurrency(this,event));" value="'+commaSplit(discount_amount_info)+'" onBlur="return indirim_hesapla('+row_count+');"></div>';
            </cfif>
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<div class="form-group"><input type="text" name="discount' + row_count +'" id="discount' + row_count +'" class="moneybox" onkeyup="return(FormatCurrency(this,event));" value="'+commaSplit(discount_info)+'" onBlur="return indirim_hesapla('+row_count+');"></div>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<div class="form-group"><input type="text" name="row_net_total' + row_count +'" id="row_net_total' + row_count +'" class="moneybox" onBlur="return discount_hesapla('+row_count+');" value="'+commaSplit(satir_toplam,<cfoutput>#price_round_number#</cfoutput>)+'"></div>';
            
            <cfif x_payment_plan_kdv_amount>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<div class="form-group"><input type="text" name="row_last_net_total' + row_count +'" readonly="yes" class="moneybox" onBlur="return discount_hesapla('+row_count+');" onkeyup="return(FormatCurrency(this,event));" value=""></div>';
            </cfif>
            
            if (document.payment_plan.top_fat_dah.checked)
            {
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.setAttribute("class","text-center");
                newCell.innerHTML = '<div class="form-group"><input type="checkbox" name="is_collected_inv' + row_count +'" checked onClick="select_row_bill_type(1,' + row_count +');"></div>';
            }
            else
            {
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.setAttribute("class","text-center");
                newCell.innerHTML = '<div class="form-group"><input type="checkbox" name="is_collected_inv' + row_count +'" onClick="select_row_bill_type(1,' + row_count +');"></div>';
            }
        
            if (document.payment_plan.grup_fat_dah.checked)
            {
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.setAttribute("class","text-center");
                newCell.innerHTML = '<div class="form-group"><input type="checkbox" name="is_group_inv' + row_count +'" checked onClick="select_row_bill_type(2,' + row_count +');"></div>';
            }
            else
            {
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.setAttribute("class","text-center");
                newCell.innerHTML = '<div class="form-group"><input type="checkbox" name="is_group_inv' + row_count +'" onClick="select_row_bill_type(2,' + row_count +');"></div>';
            }
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute("class","text-center");
            newCell.innerHTML = '<div class="form-group"><input type="checkbox" name="is_billed' + row_count +'" onClick="fatura_kontrol(this,' + row_count +');"></div>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute('nowrap','nowrap'); 
            newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="period_id' + row_count +'"><input type="hidden" name="bill_info' + row_count +'"><input type="text" name="invoice_id' + row_count +'" readonly="yes"></div></div>';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute("class","text-center");
            newCell.innerHTML = '<div class="form-group"><input type="checkbox" name="is_paid' + row_count +'" onClick="cari_kontrol(this,' + row_count +');"></div>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute("class","text-center");
            newCell.innerHTML = '<div class="form-group"><input type="checkbox" name="is_collected_prov' + row_count +'"></div>';
            document.getElementById('quantity'+row_count).focus();
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.setAttribute('nowrap','nowrap'); 
                newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="cari_action_id' + row_count +'" readonly="yes"></div></div>';
                 newCell = newRow.insertCell(newRow.cells.length);
                newCell = newRow.insertCell(newRow.cells.length);
            if(!(document.payment_plan.camp_id != undefined && document.payment_plan.is_camp_rules.checked == true))
            {
                money_row = eval('document.show_pay_plan.money_type_row'+row_count);
                for(var j=0; j<money_row.length; j++)
                {
                    if(money_row[j].value == document.payment_plan.money_type[document.payment_plan.money_type.selectedIndex].value)
                    money_row[j].selected = true;
                }
            }
            indirim_hesapla(row_count,kontrol_price);
            hesapla(row_count);
            AmountRnd('row_bsmv_rate'+row_count,<cfoutput>#price_round_number#</cfoutput>);
            AmountRnd('row_oiv_rate'+row_count,<cfoutput>#price_round_number#</cfoutput>);
        }
        document.payment_plan.record.value=parseFloat(sayi)+ parseFloat(satir);
    }
    var is_add_pay_plan = 0;//çok fazla enter tuşuna basınca sorun oluyordu , o yüzden kontrol eklendi
    function control_input()
    {	
        if(is_add_pay_plan == 0)
        {
            is_add_pay_plan = 1;
            document.show_pay_plan.count.value=document.payment_plan_det.record.value;
            document.show_pay_plan.count_camp.value=document.payment_plan_det.count_camp.value;
            document.show_pay_plan.unit.value=document.payment_plan_det.unit.value;
            document.show_pay_plan.amount.value=document.payment_plan_det.amount.value;
            document.show_pay_plan.quantity.value=document.payment_plan_det.quantity.value;
            document.show_pay_plan.start_date.value=document.payment_plan_det.start_date.value;
            document.show_pay_plan.product_id.value=document.payment_plan_det.product_id.value;
            document.show_pay_plan.stock_id.value=document.payment_plan_det.stock_id.value;
            document.show_pay_plan.unit_id.value=document.payment_plan_det.unit_id.value;
            document.show_pay_plan.money_type.value=document.payment_plan_det.money_type.value;
            document.show_pay_plan.period.value=document.payment_plan_det.period.value;
            document.show_pay_plan.paymethod_id.value=document.payment_plan_det.paymethod_id.value;
            document.show_pay_plan.card_paymethod_id.value=document.payment_plan_det.card_paymethod_id.value;
            var toplam = parseFloat(document.payment_plan_det.count_camp.value) + parseFloat(document.payment_plan_det.record.value) + parseFloat(document.payment_plan_det.record_num.value);
            if(toplam == 0)
            {
                alert("<cf_get_lang dictionary_id ='41345.Lütfen Satır Ekleyiniz'>!");
                is_add_pay_plan = 0;
                return false;
            }
       
            count_row = 0;
            for(var zz=1; zz<=toplam; zz++)
            {
                if((eval("show_pay_plan.row_control"+zz) != undefined && eval("show_pay_plan.row_control"+zz).value == 1) || eval("show_pay_plan.row_control"+zz) == undefined)
                {
                    count_row = count_row+1;
                    if($('#payment_date'+zz) != undefined && $('#payment_date'+zz).val() == '')
                    {
                        alert("<cf_get_lang dictionary_id ='41309.Ödeme Tarihi Giriniz'>! <cf_get_lang dictionary_id='58508.Satır'>: "+count_row);
                        is_add_pay_plan = 0;
                        return false;
                    }
                    <cfif xml_save_total_zero eq 0>//FBS
                        if($('#amount'+zz) != undefined && parseFloat(filterNum($('#amount'+zz).val())) == 0)
                        {
                            alert("<cf_get_lang dictionary_id='62272.Tutar 0 dan farklı olmalıdır'>! <cf_get_lang dictionary_id='58508.Satır'>: "+count_row);
                            is_add_pay_plan = 0;
                            return false;
                        }
                    </cfif>
                    if($('#discount'+zz) != undefined && (filterNum($('#discount'+zz).val()) < 0 || filterNum($('#discount'+zz).val()) > 100))
                    {
                        alert("<cf_get_lang dictionary_id ='57727.İndirim Değeri Hatalı'> <cf_get_lang dictionary_id='58508.Satır'>:!"+count_row);
                        is_add_pay_plan = 0;
                        return false;
                    }
                }
            }
           
            document.show_pay_plan.process_stage.value=document.payment_plan_det.process_stage.value;
            if(document.payment_plan_det.process_stage.value == "")
            {
                alert("<cf_get_lang dictionary_id='57976.Lütfen Süreçlerinizi Tanimlayiniz ve/veya Tanimlanan Süreçler Üzerinde Yetkiniz Yok'> !");
                is_add_pay_plan = 0;
                return false;
            }
            else
                return process_cat_dsp_function();

            
        }
        else
            return false;


    }
    function hesapla_main(type)
    {
        if(type == 1)
        {
            var satir_total = filterNum(document.payment_plan.amount.value,<cfoutput>#price_round_number#</cfoutput>);
         
            if(satir_total != 0)
            {
                var satir_net_total = filterNum(document.payment_plan.net_amount.value,<cfoutput>#price_round_number#</cfoutput>);
                var discount_ = -1*(((satir_net_total*100)/satir_total)-100);
                document.payment_plan.discount.value=commaSplit(discount_);
            }
            else
            {
                var satir_net_total = filterNum(document.payment_plan.net_amount.value,<cfoutput>#price_round_number#</cfoutput>);
                document.payment_plan.amount.value=commaSplit(satir_net_total);
            }
        }
        else if(type == 0)
        {
            var satir_total = filterNum(document.payment_plan.amount.value,<cfoutput>#price_round_number#</cfoutput>);
            var satir_discount = filterNum(document.payment_plan.discount.value);
            var discount_ = (satir_total * satir_discount)/100;
            document.payment_plan.net_amount.value=commaSplit(satir_total-discount_,<cfoutput>#price_round_number#</cfoutput>);
            
        }
        else if(type == 2)
        {
            var satir_total = filterNum(document.payment_plan.amount.value,<cfoutput>#price_round_number#</cfoutput>);
            var satir_discount = filterNum(document.payment_plan.discount.value);
            var discount_ = (satir_total * satir_discount)/100;
            document.payment_plan.net_amount.value=commaSplit(satir_total-discount_,<cfoutput>#price_round_number#</cfoutput>);
        }
    }
    function AmountRnd(money,rnd){
            var element = document.getElementById(money);
            var money = element.value;
            money = money.replace(".","");
            money = money.replace(",",".");
            var tut = commaSplit(money,rnd);
            element.value = tut;
    }
    function is_zero(satir_no)
    {   
        if(isNaN(document.payment_plan.quantity.value) || document.payment_plan.quantity.value == 0 || document.payment_plan.quantity.value < 0)
        {
            document.payment_plan.quantity.value = 1;
            return false;
        }
        if(isNaN($("#payment_plan #quantity"+satir_no).val()) || $("#payment_plan #quantity"+satir_no).val() == 0 || $("#payment_plan #quantity"+satir_no).val() < 0)  
        {
            $("#payment_plan #quantity"+satir_no).val(1);
            return false;
        }
    }
    var row_bsmv_amount , row_bsmv_rate , row_oiv_amount , row_oiv_rate, row_tevkifat_amount , row_tevkifat_rate;
    function hesapla(satir_no,id)
    {
        
        
        document.getElementById('row_total'+satir_no).value=commaSplit(filterNum(document.getElementById('amount'+satir_no).value,<cfoutput>#price_round_number#</cfoutput>)*parseFloat(document.getElementById('quantity'+satir_no).value),<cfoutput>#price_round_number#</cfoutput>);
        indirim_hesapla(satir_no);
        
      
    }
    function indirim_hesapla(satir_no,kontrol_price)
    {
      //  alert("caller is " + arguments.callee.caller.toString());
       //alert(document.getElementById('row_total'+satir_no).value);
        if(kontrol_price == undefined) kontrol_price = 0;
        var row_quantity = parseFloat(document.getElementById('quantity'+satir_no).value);
        <cfif x_payment_plan_isk_amount>
            var disc_amount = filterNum(document.getElementById('discount_amount'+satir_no).value) * row_quantity;
        <cfelse>
            var disc_amount = 0;
        </cfif>
        
        var indirim = parseFloat(filterNum(document.getElementById('row_total'+satir_no).value,<cfoutput>#price_round_number#</cfoutput>)-disc_amount) * filterNum(document.getElementById('discount'+satir_no).value)/100;
        var indirim_rate = filterNum(document.getElementById('discount'+satir_no).value);
        var tutar = filterNum(document.getElementById('row_total'+satir_no).value,<cfoutput>#price_round_number#</cfoutput>);
        var row_net_total = filterNum(document.getElementById('row_net_total'+satir_no).value,<cfoutput>#price_round_number#</cfoutput>);
        
        if(kontrol_price == 0)
            document.getElementById('row_net_total'+satir_no).value=commaSplit((tutar - indirim - disc_amount),<cfoutput>#price_round_number#</cfoutput>);
        else
        {
            document.getElementById('row_total'+satir_no).value=commaSplit(row_net_total*100/(100-indirim_rate),<cfoutput>#price_round_number#</cfoutput>);
            document.getElementById('amount'+satir_no).value=commaSplit((row_net_total*100/(100-indirim_rate))/row_quantity,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
        }
        if(document.getElementById("kdv_rate"+satir_no) != undefined)
            new_price_kdv = (filterNum(document.getElementById("row_net_total"+satir_no).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>) * filterNum(document.getElementById("kdv_rate"+satir_no).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>) / 100);
        else
            new_price_kdv = 0 ;
        if(document.getElementById("otv_rate"+satir_no) != undefined)
            new_price_otv = (filterNum(document.getElementById("row_net_total"+satir_no).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>) * filterNum(document.getElementById("otv_rate"+satir_no).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>) / 100);
        else
            new_price_otv = 0 ;
        if(document.getElementById("row_bsmv_rate"+satir_no) != undefined)
            {new_bsmv_price = (filterNum(document.getElementById("row_bsmv_amount"+satir_no).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));
            }
        else
            new_bsmv_price = 0 ;
        if(document.getElementById("row_oiv_rate"+satir_no) != undefined)
        {
            new_oiv_price = (filterNum(document.getElementById("row_oiv_amount"+satir_no).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));
        }
        else
            new_oiv_price = 0 ;
        if(document.getElementById("row_tevkifat_rate"+satir_no) != undefined)
            new_tevkifat_price = (filterNum(document.getElementById("row_tevkifat_amount"+satir_no).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));
        else
            new_tevkifat_price = 0 ;
        if(document.getElementById("row_last_net_total"+satir_no) != undefined)
            document.getElementById("row_last_net_total" + satir_no).value = commaSplit(parseFloat(filterNum(document.getElementById("row_net_total"+satir_no).value))+parseFloat(new_price_kdv)+parseFloat(new_price_otv)+parseFloat(new_bsmv_price)+parseFloat(new_oiv_price)-parseFloat(new_tevkifat_price),<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
    
        
        if( document.getElementById('row_bsmv_amount'+satir_no) != undefined ){
            var row_net_total__ = filterNum(document.getElementById('row_net_total'+satir_no).value);
            row_bsmv_amount = (row_net_total__ * filterNum( document.getElementById('row_bsmv_rate'+satir_no).value))  / 100;

            document.getElementById('row_bsmv_amount'+satir_no).value = commaSplit(row_bsmv_amount,<cfoutput>#price_round_number#</cfoutput>);

        }
        if(document.getElementById('row_oiv_amount'+satir_no) != undefined){  
            var row_net_total__ = filterNum(document.getElementById('row_net_total'+satir_no).value); 
            row_oiv_amount = (row_net_total__ * filterNum( document.getElementById('row_oiv_rate'+satir_no).value))  / 100;
            
            document.getElementById('row_oiv_amount'+satir_no).value = commaSplit(row_oiv_amount,<cfoutput>#price_round_number#</cfoutput>);
            
        }
        <cfif xml_tevkifat_rate>
        if(document.getElementById('row_tevkifat_amount'+satir_no+'') != undefined) {
            row_tevkifat_amount = filterNum( document.getElementById('row_tevkifat_amount'+satir_no+'').value );
            row_tevkifat_rate = row_tevkifat_amount * 100 / document.getElementById('kdv_rate'+satir_no+'').value;
    
            document.getElementById('row_tevkifat_rate'+satir_no+'').value = ( row_tevkifat_rate > 0 ) ? commaSplit(row_tevkifat_rate,<cfoutput>#price_round_number#</cfoutput>) : commaSplit(0,<cfoutput>#price_round_number#</cfoutput>);
            document.getElementById('row_tevkifat_amount'+satir_no+'').value = ( row_tevkifat_amount > 0 ) ? commaSplit(row_tevkifat_amount,<cfoutput>#price_round_number#</cfoutput>) : commaSplit(0,<cfoutput>#price_round_number#</cfoutput>);
        }
        </cfif>
    }
    function camp_control_row(row_no,row_id,all_)
    {
        <cfoutput>
    
            //Toplu Silme İcin FBS20140327
            if(all_ != "" && row_id == "")
            {
            <cfloop from="1" to="#GET_PAYMENT_ROWS.recordcount#" index="xx">
                if(document.getElementById("is_change#xx#") != undefined && document.getElementById("is_change#xx#").checked)
                {
                    if(row_id != '')
                    {
                        var row_no = row_no + ',' + list_getat(document.getElementById("is_change#xx#").value,1);
                        var row_id = row_id + ',' + list_getat(document.getElementById("is_change#xx#").value,2);
                    }
                    else
                    {
                        var row_no = list_getat(document.getElementById("is_change#xx#").value,1);
                        var row_id = list_getat(document.getElementById("is_change#xx#").value,2);
                    }
                }
            </cfloop>
            }
                if(confirm('<cf_get_lang dictionary_id ="41386.Ödeme Planı Satırını Silmek İstediğinizden Emin misiniz">')) 
                    windowopen('#request.self#?fuseaction=contract.emptypopup_del_cont_pay_plan_row&payment_row_id='+row_id+'&contract_id=#attributes.contract_id#','small');
        </cfoutput>
    }
    function wrk_select_change()
    {
        new_toplam = parseFloat(document.payment_plan_det.count_camp.value) + parseFloat(document.payment_plan_det.count.value) + parseFloat(document.payment_plan_det.record_num.value);
       
        for(var zz=1; zz<=new_toplam; zz++)
        {
            if(document.getElementById("is_change"+zz) != undefined)
            {
                if(document.getElementById("is_change_main").checked == true)
                    document.getElementById("is_change"+zz).checked = true;
                else
                    document.getElementById("is_change"+zz).checked = false;
            }
        }
    }
    function camp_control()
    {
        <cfoutput>
                if(confirm('<cf_get_lang dictionary_id ="41307.Ödeme Planı Satırlarını Silmek İstediğinizden Emin misiniz">')) 
                 windowopen('#request.self#?fuseaction=contract.emptypopup_del_cont_pay_plan_row&del_all=1&contract_id=#attributes.contract_id#','small');
        </cfoutput>
    }
    function fatura_kes()
        { var endrow=<cfoutput>#GET_PAYMENT_ROWS.recordcount#</cfoutput>;
            var aktif_kontrol =1;
            var checked_kontrol = 0;
            document.show_pay_plan.list_payment_row_id.value ='';
            if(endrow >1){
                for(var i=1;i<=endrow;i++){
                    if(eval('document.show_pay_plan.is_change'+i).checked==true)
                    {
                        checked_kontrol = checked_kontrol + 1;
                        if(document.show_pay_plan.list_payment_row_id.value.length==0) ayirac=''; else ayirac=',';
                            document.show_pay_plan.list_payment_row_id.value = document.show_pay_plan.list_payment_row_id.value+ayirac+eval('document.show_pay_plan.payment_row_id'+i).value;
                    }
            }
        }else{
                if(document.show_pay_plan.is_change1.checked==true)
                {
                    checked_kontrol = checked_kontrol +1;
                    document.show_pay_plan.list_payment_row_id.value = document.show_pay_plan.payment_row_id1.value;				
                }
            }
            if(checked_kontrol==0)
            {
                alert("<cf_get_lang dictionary_id='41124.Ödeme Planı Şeçimi Yapınız'> !");
                return false;
            }
            else if(aktif_kontrol!=1){
                alert("<cf_get_lang dictionary_id='63034.Aktif Filtreleme Yapınız'> !");
                return false;
            }
            else
            {
                open_invoice();
            }
        }
        
        function open_invoice()
        {
            document.add_invoice.list_payment_row_id.value = document.show_pay_plan.list_payment_row_id.value;       
            document.add_invoice.submit();

        }
</script>
    
