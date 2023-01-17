<cfset xml_page_control_list = 'is_conscat_segmentation,is_conscat_premium'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="0" fuseact="product.form_upd_prom">
<cfparam name="attributes.prom_type" default="">
<cfinclude template="../query/get_prom.cfm">
<cfinclude template="../query/get_money.cfm">
<cfset getComponent = createObject('component','V16.objects.cfc.promotions')>
<cf_catalystHeader>

<cfset str_link=""><cfif isdefined("attributes.from_promotion")><cfset str_link="&from_promotion=1"></cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box id="FormUpdProm">
    <cf_box_data asname="get_roundnum" function="V16.objects.cfc.promotions:get_roundnum">
    <cf_box_data asname="PRICE_CATS" function="V16.objects.cfc.promotions:PRICE_CATS">
    <cf_box_data asname="get_card_types" function="V16.objects.cfc.promotions:get_card_types">
    <cfset roundnum=get_roundnum.sales_price_round_num>
    <cfset stock_id = get_prom.stock_id>
    <cfform name="upd_prom" method="post" action="#request.self#?fuseaction=product.emptypopup_upd_prom">
        <cfoutput>
            <cfloop query="GET_MONEY">
                <input type="hidden" name="money_#money#" id="money_#money#" value="#wrk_round(GET_MONEY.rate2/GET_MONEY.rate1,4)#">
            </cfloop>
           
            <cf_duxi name="PROM_ID" type="hidden" data="attributes.PROM_ID">
            <input type="hidden" name="pageDelEvent" id="pageDelEvent" value="del" />
            <cf_box_elements vertical="1">
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                    <cf_duxi name="prom_status" type="checkbox"  data="data_promotions.prom_status" value="1" label="57493">
                    <cf_duxi name="prom_head" type="text" id="prom_head" data="data_promotions.prom_head"  hint="Başlık"  label="57480">  
                    <cf_duxi name="prom_no" type="text" data="data_promotions.prom_no"  hint="No"  label="57487" >  
                    <div class="form-group" id="item-process">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' select_value='#get_prom.prom_stage#' process_cat_width='160' is_detail='1'>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                    <div class="form-group" id="item-supplier_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif len(get_prom.supplier_id)>
                                    <cfset get_company = getComponent.GET_COMPANY(company_id : get_prom.supplier_id)>
                                </cfif>
                                <input type="hidden" name="supplier_id" id="supplier_id" value="#get_prom.supplier_id#">
                                <input type="text" name="supplier_name" id="supplier_name" value="<cfif len(get_prom.supplier_id)>#get_company.nickname#</cfif>" >
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=upd_prom.supplier_name&field_comp_id=upd_prom.supplier_id&select_list=2&keyword='+encodeURIComponent(document.upd_prom.supplier_name.value));"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-camp_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif len(get_prom.camp_id)>
                                    <cfset get_camp_name = getComponent.get_camp_name(camp_id : get_prom.camp_id)>
                                    <cfset camp_start_date=dateformat(date_add("H",session.ep.time_zone,get_camp_name.camp_startdate),dateformat_style)>
                                    <cfset camp_finish_date=dateformat(date_add("H",session.ep.time_zone,get_camp_name.camp_finishdate),dateformat_style)>
                                </cfif>
                                <input type="hidden" name="camp_id" id="camp_id" value="<cfif len(get_prom.camp_id)>#get_prom.camp_id#</cfif>">
                                <input type="text" name="camp_name" id="camp_name" value="<cfif len(get_prom.camp_id)>#get_camp_name.camp_head#(#camp_start_date#-#camp_finish_date#)</cfif>" >
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_campaigns&field_id=upd_prom.camp_id&field_name=upd_prom.camp_name&field_start_date=upd_prom.startdate&field_finish_date=upd_prom.finishdate&call_function=add_camp_date');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-catalog">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59154.Katalog'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="catalog_id" id="catalog_id" value="#get_prom.catalog_id#">
                                <input type="text" name="catalog_head" id="catalog_head" value="#get_prom.catalog_head#">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.widget_loader&widget_load=catalogList&isbox=1&is_submitted=1&field_id=upd_prom.catalog_id&field_name=upd_prom.catalog_head')"></span>
                            </div>
                        </div>
                    </div>
                    <cf_duxi name="prom_detail" type="text" data="data_promotions.prom_detail"  hint="Açıklama"  label="57629" >
                </div>
                   
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
                      
                        <div class="form-group" id="item-TOTAL_AMOUNT">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37487.Satış Limiti/Hedef'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="TOTAL_AMOUNT" id="TOTAL_AMOUNT" value="#TLFormat(get_prom.total_amount,roundnum)#"  onkeyup="return(FormatCurrency(this,event,#roundnum#));" class="moneybox" >
                                <!---  BK kaldirdi 20130831 6 aya kaldirilsin
                                <td><cf_get_lang dictionary_id='57759.Başlıgı Göster'></td>
                                <td><input type="checkbox" name="is_viewed" id="is_viewed" value="1"  <cfif get_prom.is_viewed eq 1>checked</cfif>></td> --->
                            </div>
                        </div>
                        <div class="form-group" id="item-banner_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32248.Banner'><cf_get_lang dictionary_id='58527.ID'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="banner_id" value="#get_prom.banner_id#">
                                    <a class="input-group-addon" href="#request.self#?fuseaction=content.list_banners&event=upd&banner_id=#get_prom.banner_id#"><i class="fa fa-link"></i></a>
                                </div>
                            </div>
                        </div>
                        <!--- <cf_duxi name="banner_id" id="banner_id" type="text" data="data_promotions.banner_id" hint="Banner" label="32248+58527"> --->
                        <cf_duxi name="promotion_code" id="promotion_code" type="text" data="data_promotions.promotion_code" hint="Promosyon Kodu" label="62823">
                        <div class="form-group" id="item-user_friendly_url" >
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='38023.Kullanıcı Dostu Url'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cf_publishing_settings fuseaction="product.list_promotions" event="upd" action_type="PROM_ID" action_id="#attributes.PROM_ID#">
                                    <input type="hidden" name="is_autofill" id="is_autofill" value="<cfif isdefined("x_is_auto_fill_user_friendly") and x_is_auto_fill_user_friendly eq 1>1<cfelse>0</cfif>">
                                    <div class="input-group">
                                        <input type="text" name="user_friendly_url" id="user_friendly_url"  value="<cfoutput>#decodeForHTML(get_prom.user_friendly_url)#</cfoutput>">
                                        <span class="input-group-addon">Legacy</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>                
                    <div class="col col-4 col-md-4 col-sm-12 col-xs-12" type="column" sort="true" index="4">                        
                        <cfsavecontent  variable="head"><cf_get_lang dictionary_id='37382.Koşullar'></cfsavecontent>
                        <cf_seperator title="#head#" id="kosul">
                        <div id="kosul">
                            <cf_box_elements>
                                <div class="form-group" id="item-startdate">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlama Tarihi'>*</label>
                                    <div class="col col-4 col-xs-12">
                                        <div class="input-group">
                                            <cfset startdate = get_prom.startdate>
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Baslangiç Tarihi Girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="startdate" required="Yes" validate="#validate_style#" message="#message#" value="#dateformat(startdate,dateformat_style)#" >
                                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
                                            <cfset start_clock = timeformat(startdate,"HH")>
                                            <cfset start_minute = timeformat(startdate,"mm")>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-xs-12">        
                                        <cf_wrkTimeFormat name="start_clock" value="#timeformat(startdate,"HH")#">
                                    </div>    
                                    <div class="col col-2 col-xs-12">   
                                        <select name="start_minute" id="start_minute" >
                                            <cfloop from="0" to="55" index="i" step="5"> 
                                                <option value="#numberformat(i,00)#" <cfif len(start_minute) and start_minute is i>selected</cfif>>#numberformat(i,00)#</option>
                                            </cfloop> 
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-finishdate">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'> *</label>
                                    <div class="col col-4 col-xs-12">
                                        <div class="input-group">
                                            <cfset finishdate = get_prom.finishdate>
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="finishdate" required="Yes" validate="#validate_style#" message="#message#" value="#dateformat(finishdate,dateformat_style)#" >
                                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
                                            <cfset finish_clock = timeformat(finishdate,"HH")>
                                            <cfset finish_minute = timeformat(finishdate,"mm")>
                                        </div> 
                                    </div>  
                                    <div class="col col-2 col-xs-12"> 
                                            <cf_wrkTimeFormat name="finish_clock" value="#timeformat(finishdate,"HH")#">
                                    </div>
                                    <div class="col col-2 col-xs-12"> 
                                        <select name="finish_minute" id="finish_minute" >
                                            <cfloop from="0" to="55" index="i" step="5"> 
                                                <option value="#numberformat(i,00)#" <cfif len(finish_minute) and finish_minute is i>selected</cfif>>#numberformat(i,00)#</option>
                                            </cfloop> 
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-prom_type">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37488.Promosyon Tipi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="prom_type" id="prom_type">
                                            <option value="1" <cfif get_prom.prom_type eq 1>selected</cfif>><cf_get_lang dictionary_id='37586.Satıra Uygulanır'></option>
                                            <option value="0" <cfif get_prom.prom_type eq 0>selected</cfif>><cf_get_lang dictionary_id='37587.Toplama Uygulanır'></option>
                                            <option value="2" <cfif get_prom.prom_type eq 2>selected</cfif>><cf_get_lang dictionary_id='37588.Dönemsel Uygulanır'></option>
                                        </select>	
                                    </div>
                                </div>
                                <div class="form-group" id="item-limit_type">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58775.Alışveriş Miktarı'> *</label>
                                    <div class="col col-4 col-xs-12">
                                        <select name="limit_type" id="limit_type"  onChange="degistir();">
                                            <option value="1" <cfif get_prom.limit_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57636.Birim'></option>
                                            <option value="2" <cfif get_prom.limit_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57673.Tutar'></option>
                                            <option value="3" <cfif get_prom.limit_type eq 3>selected</cfif>><cf_get_lang dictionary_id='37845.Çeşit'></option>
                                        </select>
                                    </div>    
                                    <div class="col col-4 col-xs-12">
                                        <div class="input-group"> 
                                            <input type="text" name="limit_value" id="limit_value" class="moneybox" value="#TLFormat(get_prom.limit_value,roundnum)#" onkeyup="return(FormatCurrency(this,event,#roundnum#));" >
                                            <span class="input-group-addon width" id="currency_change" style="<cfif get_prom.limit_type neq 2 >display:none;</cfif>">
                                                <select name="limit_currency" id="limit_currency" >
                                                    <cfloop query="get_money">
                                                        <option value="#get_money.money#" <cfif get_prom.limit_currency eq get_money.money>selected</cfif>>#get_money.money#</option>
                                                    </cfloop>
                                                </select>
                                            </span>  
                                        </div>                                          
                                    </div>
                                </div>
                                <div class="form-group" id="item-price_catid">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58964.Fiyat Listesi'> *</label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="price_catid" id="price_catid">
                                            <option value="-2" <cfif get_prom.price_catid eq '-2'>selected</cfif>><cf_get_lang dictionary_id='58721.Standart Satış'></option>
                                            <cfloop query="price_cats"> 
                                                <option value="#price_catid#" <cfif get_prom.price_catid eq price_catid>selected</cfif>>#price_cat#</option>
                                            </cfloop>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-card-type">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30363.Card Type'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="card_type" id="card_type">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfloop query="get_card_types">
                                                <option value="#type_id#" <cfif get_prom.card_type eq type_id>selected</cfif>>#type_name#</option>
                                            </cfloop>
                                        </select>			
                                    </div>
                                </div>
                                <div class="form-group" id="item-product_cat">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="product_catid" id="product_catid" value="#get_prom.product_catid#">
                                            <cfif len(get_prom.product_catid)>
                                                <cfset attributes.product_catid = get_prom.product_catid>
                                                <cfset get_product_cat = getComponent.GET_PRODUCT_CAT(product_catid : attributes.product_catid)>
                                                <input type="text" name="product_cat" id="product_cat" value="#get_product_cat.product_cat#">
                                            <cfelse>
                                                <input type="text" name="product_cat" id="product_cat" value="">
                                            </cfif>
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_cat_names&field_code=upd_prom.product_catid&field_name=upd_prom.product_cat');"></span>
                                        </div>
                                    </div>
                                </div>
                                <cf_duxi name="brand_id" type="hidden" data="data_promotions.brand_id">  
                                <cf_duxi name="brand_name" type="text" data="data_promotions.brand_name" hint="Marka" label="58847" threepoint="#request.self#?fuseaction=objects.popup_product_brands&brand_id=upd_prom.brand_id&brand_name=upd_prom.brand_name"> 
                                <div class="form-group" id="item-product_name">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfif len(get_prom.stock_id)>
                                                <cfset PRODUCT_NAME = getComponent.PRODUCT_NAME(stock_id : get_prom.stock_id)>
                                                <cfset attributes.stock_id = get_prom.stock_id>
                                                <cfset attributes.product_id = product_name.product_id>
                                            </cfif>
                                            <cfif len(get_prom.stock_id)>
                                                <input type="hidden" name="product_id" id="product_id" value="#product_name.product_id#">
                                                <input type="text" name="product_name" id="product_name" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','2','200');" autocomplete="off" value="#product_name.product_name#&nbsp;#product_name.property#">
                                            <cfelse>
                                                <input type="hidden" name="product_id" id="product_id" value="">
                                                <input type="text" name="product_name" id="product_name" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','2','200');" autocomplete="off" value="" onchange="empty_product_brand();" >
                                            </cfif>
                                            <input type="hidden" name="stock_id" id="stock_id" value="#get_prom.stock_id#">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names#str_link#&field_id=upd_prom.stock_id&field_name=upd_prom.product_name&product_id=upd_prom.product_id&run_function=empty_product_brand()');"></span>
                                        </div>
                                    </div>
                                </div>
                                <cf_duxi name="is_all_products" id="is_all_products" type="checkbox" data="data_promotions.is_all_products" value="1" label="30167">
                            </cf_box_elements>
                        </div>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-12 col-xs-12" type="column" sort="true" index="5">
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cfsavecontent  variable="head"><cf_get_lang dictionary_id='63960.Anında kazanımlar'></cfsavecontent>
                            <cf_seperator title="#head#" id="formul">
                            <div id="formul">
                                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63978.İndirim Oranı'></label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="text" id="discount_rate" name="discount_rate" class="moneybox" value="#get_prom.discount_rate#" onkeyup="return(FormatCurrency(this,event,#roundnum#));">
                                            <span class="input-group-addon">%</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63981.Aynı Üründen Kazan'></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                        <div class="input-group">
                                            <input type="text" id="number_gift_product" name="number_gift_product" class="moneybox" value="#get_prom.number_gift_product#" onkeyup="return(FormatCurrency(this,event,#roundnum#));">
                                            <span class="input-group-addon"><cf_get_lang dictionary_id='58082.Adet'></span>
                                        </div>
                                    </div>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                        <div class="input-group">
                                            <input type="text" id="number_gift_product_ratio" name="number_gift_product_ratio" class="moneybox" value="#get_prom.number_gift_product_ratio#" onkeyup="return(FormatCurrency(this,event,#roundnum#));">
                                            <span class="input-group-addon">%</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12"> &nbsp;&nbsp; <div class="col col-4 col-md-4 col-sm-4 col-xs-12"></div>
                                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                                <cf_duxi name="free_stock_id" type="hidden" id="free_stock_id" data="data_promotions.free_stock_id">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63965.Özel Ürün Kazan'></label>
                                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <div class="input-group">
                                                        <cfinput name="free_product" id="free_product" type="text" value="#data_promotions.product_name# #data_promotions.property#">
                                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names&run_function=hesapla()&field_product_cost=upd_prom.amount_1&field_id=upd_prom.free_stock_id&field_name=upd_prom.free_product')"></span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                        <div class="col col-2 col-md-2 col-sm-2 col-xs-12"><cf_get_lang dictionary_id='58258.Maliyet'>
                                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                                <input type="text" name="amount_1" id="amount_1" value="#TLFormat(get_prom.amount_1,roundnum)#" onkeyup="return(FormatCurrency(this,event,#roundnum#));" onBlur="hesapla();" class="moneybox">
                                                <cfif len(get_prom.amount_1_money)>
                                                <cfset get_prom_amount_1_money = get_prom.amount_1_money>
                                                <cfelse>
                                                    <cfset get_prom_amount_1_money = session.ep.money>
                                                </cfif>
                                            </div>
                                        </div>
                                        <div class="col col-2 col-md-2 col-sm-2 col-xs-12"><cf_get_lang dictionary_id ='57489.Para Br'>
                                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                                <select name="amount_1_money" id="amount_1_money" onBlur="hesapla();">
                                                    <cfloop query="get_money">
                                                    <option value="#money#" <cfif get_prom_amount_1_money eq money>selected</cfif>>#money#</option>
                                                    </cfloop>   
                                                </select> 
                                            </div>
                                        </div>
                                        <div class="col col-2 col-md-2 col-sm-2 col-xs-12"><cf_get_lang dictionary_id='58082.Adet'>
                                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">                                     
                                                                                
                                                <input type="text" name="free_stock_amount" id="free_stock_amount" value="#TLFormat(get_prom.free_stock_amount,roundnum)#" onkeyup="return(FormatCurrency(this,event,#roundnum#));" class="moneybox" >
                                            </div>
                                        </div>
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='63934.İndirim Oranı'>% 
                                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">                                                 
                                                <input type="text" name="special_product_discount_rate" id="special_product_discount_rate" value="#get_prom.special_product_discount_rate#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#roundnum#));">
                                            </div>
                                        </div>
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='37643.Fatura Fiyatı'> 
                                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">                                                                                      
                                                <input type="text" name="free_stock_price" id="free_stock_price" value="#TLFormat(get_prom.free_stock_price,roundnum)#" onkeyup="return(FormatCurrency(this,event,#roundnum#));"  onBlur="hesapla();" class="moneybox">
                                            </div>
                                        </div>	
                                    </div>
                                </div>
                                
                            </div>
                        </div>
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cfsavecontent  variable="head"><cf_get_lang dictionary_id='63968.Sonraki Alışverişlerde Kazanımlar'></cfsavecontent>
                            <cf_seperator title="#head#" id="earnings">
                            <div id="earnings">
                                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63969.Alışveriş Kuponu'></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                            <div class="input-group">
                                                <cfinput type="hidden" name="coupon_id" value="#data_promotions.coupon_id#">
                                                <cfinput type="text" name="coupon" value="#data_promotions.coupon_name#">
                                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=product.popup_coupons_list&field_id=upd_prom.coupon_id&field_name=upd_prom.coupon')"></span>
                                            </div>                                            
                                        </div>                                        
                                    </div>
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">  
                                            <input type="text" name="amount_discount_2" id="amount_discount_2" value="#TLFormat(get_prom.amount_discount_2,roundnum)#" onkeyup="return(FormatCurrency(this,event,#roundnum#));" onBlur="hesapla();" class="moneybox">
                                        </div>
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">    
                                            <cfif len(get_prom.amount_discount_money_2)>
                                                <cfset get_prom_amount_discount_money_2 = get_prom.amount_discount_money_2>
                                            <cfelse>
                                                <cfset get_prom_amount_discount_money_2 = session.ep.money>
                                            </cfif>
                                            <select name="amount_discount_money_2" id="amount_discount_money_2" onBlur="hesapla();">
                                                <cfloop query="get_money">
                                                    <option value="#get_money.money#" <cfif get_prom_amount_discount_money_2 eq get_money.money>selected</cfif>>#get_money.money#</option>
                                                </cfloop>   
                                            </select>  
                                        </div>   
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">  
                                        </div>
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">  
                                        </div>                                                 	
                                    </div>
                                </div>
                                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='34380.Para Puan'></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                            <cfinput type="text" name="prom_point" class="moneybox" value="#get_prom.prom_point#" validate="integer" message="Promosyon Puanı Sayısal Olmalıdır !" onkeyup="return(FormatCurrency(this,event));"  onBlur="hesapla();">
                                        </div>
                                    </div>
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                                            <input type="text" name="amount_3" id="amount_3" value="#TLFormat(get_prom.amount_3,roundnum)#" onkeyup="return(FormatCurrency(this,event,#roundnum#));" onBlur="hesapla();" class="moneybox">
                                        </div>
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                            <cfif len(get_prom.amount_3_money)>
                                                <cfset get_prom_amount_3_money = get_prom.amount_3_money>
                                            <cfelse>
                                                <cfset get_prom_amount_3_money = session.ep.money>
                                            </cfif>
                                            
                                            <select name="amount_3_money" id="amount_3_money" onBlur="hesapla();">
                                                <cfloop query="get_money">
                                                    <option value="#get_money.money#" <cfif get_prom_amount_3_money eq get_money.money>selected</cfif>>#get_money.money#</option>
                                                </cfloop>
                                            </select> 
                                        </div>
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">  
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                        <label class="pull-right"><cf_get_lang dictionary_id='57492.Toplam'></label>
                                    </div>
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57743.Dönem Primi girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="total_promotion_cost" class="moneybox" value="#TLFormat(get_prom.total_promotion_cost,roundnum)#" message="#message#">
                                        </div>
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                            <cfif len(get_prom.total_promotion_cost_money)>
                                                <cfset get_prom_total_promotion_cost_money = get_prom.total_promotion_cost_money>
                                            <cfelse>
                                                <cfset get_prom_total_promotion_cost_money = session.ep.money>
                                            </cfif>
                                            <select name="total_promotion_cost_money" id="total_promotion_cost_money" disabled>
                                                <cfloop query="get_money">
                                                    <option <cfif get_prom_total_promotion_cost_money is get_money.money>selected</cfif>>#money#</option>
                                                </cfloop>
                                            </select>
                                        </div>     
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12"></div>  
                                    </div>                                
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" sort="true" index="6">
                        <cfsavecontent  variable="head"><cf_get_lang dictionary_id='58029.İkon'></cfsavecontent>
                        <cf_seperator title="#head#" id="icon">
                        <div id="icon">
                            <label class="hide"><cf_get_lang dictionary_id='42231.İkonlar'></label>
                            <cf_box_data asname="get_icon" function="V16.objects.cfc.promotions:GET_ICON">
                            <a href="javascript:void(0)" class="margin-right-10">
                                <input type="radio" name="icon_id" id="icon_id" value="" <cfif len(get_prom.icon_id)>checked</cfif>>
                                <cf_get_lang dictionary_id='37653.Boş'>
                            </a>
                            <cfloop query="get_icon">
                                <a href="javascript:void(0)">
                                    <input type="radio" name="icon_id" id="icon_id" value="#icon_id#" <cfif get_prom.icon_id eq icon_id>checked</cfif>>
                                    <cfif len(icon_server_id)>
                                        <cf_get_server_file output_file="sales/#icon#" output_server="#icon_server_id#" output_type="0" image_height="25"> 
                                    <cfelse>
                                        <cf_get_lang dictionary_id='37653.Boş'>
                                    </cfif>
                                </a>                                   
                            </cfloop>
                        </div>
                    </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6 col-xs-12">
                    <cf_record_info query_name='get_prom'>
                </div>
                <div class="col col-6 col-xs-12">
                    <cf_workcube_buttons is_upd='1' extraButtonText="#getLang('','Aksiyon oluştur',64215)#" extraButton="1" extraButtonClass="ui-wrk-btn ui-wrk-btn-extra" extraFunction="kontrol()" delete_page_url='#request.self#?fuseaction=product.emptypopup_del_prom&prom_id=#get_prom.prom_id#&head=#get_prom.prom_head#' add_function='form_kontrol()'>
                </div>
            </cf_box_footer>
        </cfoutput>
    </cfform>
</cf_box>
</div>
<script type="text/javascript">
    $('#is_all_products').change(function(){
        if (this.checked) $('#product_cat, #product_catid, #brand_name, #brand_id, #product_name, #product_id, #stock_id').val('');
    });
	function degistir()
	{
		if(document.upd_prom.limit_type.value==2)
			goster(currency_change);
		else
			gizle(currency_change);
	}
	function hesapla()
	{	
		var t1 = parseFloat(filterNum(upd_prom.amount_discount_2.value,4));
		var t2 = parseFloat(filterNum(upd_prom.amount_1.value,4));
		//var t3 = parseFloat(filterNum(upd_prom.amount_2.value,4));
		var t4 = parseFloat(filterNum(upd_prom.amount_3.value,4));         
		//var t5 = parseFloat(filterNum(upd_prom.amount_4.value,4));
		//var t6 = parseFloat(filterNum(upd_prom.amount_5.value,4));
		if (isNaN(t1)) {t1 = 0; upd_prom.amount_discount_2.value = 0;}
		if (isNaN(t2)) {t2 = 0; upd_prom.amount_1.value = 0;}
		//if (isNaN(t3)) {t3 = 0; upd_prom.amount_2.value = 0;}
		if (isNaN(t4)) {t4 = 0; upd_prom.amount_3.value = 0;}
        else {if ($('#prom_point').val()) t4 = $('#prom_point').val()*t4;}
		//if (isNaN(t5)) {t5 = 0; upd_prom.amount_4.value = 0;}
		//if (isNaN(t6)) {t6 = 0; upd_prom.amount_5.value = 0;}
		t1 = t1 * eval('upd_prom.money_'+upd_prom.amount_discount_money_2.value).value;
		t2 = t2 * eval('upd_prom.money_'+upd_prom.amount_1_money.value).value;
		//t3 = t3 * eval('upd_prom.money_'+upd_prom.amount_2_money.value).value;
		t4 = t4 * eval('upd_prom.money_'+upd_prom.amount_3_money.value).value;
		//t5 = t5 * eval('upd_prom.money_'+upd_prom.amount_4_money.value).value;
		//t6 = t6 * eval('upd_prom.money_'+upd_prom.amount_5_money.value).value;
		order_total = t2+t4-t1;
		upd_prom.total_promotion_cost.value = commaSplit(order_total,4);
	}
	function unformat_fields()
	{
		upd_prom.limit_value.value = filterNum(upd_prom.limit_value.value);
		upd_prom.TOTAL_AMOUNT.value = filterNum(upd_prom.TOTAL_AMOUNT.value);
		upd_prom.amount_discount_2.value = filterNum(upd_prom.amount_discount_2.value,4);
		upd_prom.amount_1.value = filterNum(upd_prom.amount_1.value);
		upd_prom.amount_3.value = filterNum(upd_prom.amount_3.value);
		upd_prom.free_stock_price.value = filterNum(upd_prom.free_stock_price.value);
		upd_prom.free_stock_amount.value = filterNum(upd_prom.free_stock_amount.value);
		upd_prom.total_promotion_cost.value = filterNum(upd_prom.total_promotion_cost.value);
		upd_prom.total_promotion_cost_money.disabled = false;
	}
	function form_kontrol()
	{
		if(	document.upd_prom.free_stock_id.value == "" &&
			document.upd_prom.prom_point.value == "" &&	document.upd_prom.gift_head.value == "" && document.upd_prom.amount_discount_2.value == "")
		{ 
			alert ("<cf_get_lang dictionary_id ='37846.Hiçbir Promosyon Koşulu Girmediniz'> !");
			return false;
		}
        
		//Tüm ürünler seçilebilir bu yüzden silindi.
		/* if(document.upd_prom.product_id.value=='' || document.upd_prom.product.value=='')
		{
			alert("<cf_get_lang dictionary_id ='37858.Tutar İndirimi Uygulanacak Ürünü Seçiniz'>!");
			return false;
		} */
      
        
        if (document.upd_prom.prom_head.value.length > 100)
			{
				alert("<cf_get_lang dictionary_id='57480.Konu'><cf_get_lang dictionary_id='41141.Alanına 100 Karakterden Fazla Girmeyiniz. Fazla Karakter Sayısı:'>!");
				return false;
			}
            if (document.upd_prom.prom_no.value.length > 100)
			{
				alert("<cf_get_lang dictionary_id='57487.No'> 50 <cf_get_lang dictionary_id='58997.Karakterden Fazla Yazmayınız'>!");
				return false;
			}
            if(document.upd_prom.prom_head.value == '')
        {
            alert ("<cf_get_lang dictionary_id='58059.Başlık girmelisiniz'>");
            return false;
        }
		if(document.upd_prom.limit_value.value == "")
		{
			alert("<cf_get_lang dictionary_id='57744.Alışveriş Miktarı girmelisiniz'>!");
			return false;
		}
		
		if('<cfoutput>#session.ep.our_company_info.workcube_sector#</cfoutput>' =='per')
		{
			if(document.upd_prom.free_product.value == "")
			{
				alert ("<cf_get_lang dictionary_id ='37847.Anında İndirim Bölümüne İndirim Yüzdesi yada Tutarı Girmelisiniz'> !");
				return false;	
			}	
		}
        if ($('#is_all_products').is(':checked')) $('#product_cat, #product_catid, #brand_name, #brand_id, #product_name, #product_id, #stock_id').val('');
		unformat_fields();
		if(time_check(upd_prom.startdate, upd_prom.start_clock, upd_prom.start_minute, upd_prom.finishdate,  upd_prom.finish_clock, upd_prom.finish_minute, "<cf_get_lang dictionary_id ='37849.Promosyon Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'> !"))
			return process_cat_control();
		else
			return false;	
           
			
	}
	function sayfa_ac(sayfa_type)
	{
		<cfoutput>
		pid = upd_prom.product_id.value;
		if(pid != '')
			if(sayfa_type==1)
				openBoxDraggable('#request.self#?fuseaction=product.popup_product_contract&pid='+pid);
	   </cfoutput>
	}
	function empty_target_due_date(deger)
	{
		if (deger==1)
			document.upd_prom.target_due_date.value='';
		else
			document.upd_prom.due_day.value='';
	}
	function empty_product_brand()
	{	
		document.upd_prom.brand_name.value='';
		document.upd_prom.product_catid.value='';
		document.upd_prom.brand_id.value='';
		document.upd_prom.product_cat.value='';
	} 	
	function add_camp_date(start_hour,start_minute,finish_hour,finish_minute)
	{
		count = 0;
		for(kk=1;kk<=24;kk++)
		{
			if(start_hour == kk)
				document.upd_prom.start_clock.options[count].selected = true;
			if(finish_hour == kk)
				document.upd_prom.finish_clock.options[count].selected = true;
			count++;
		}
		count = 0;
		for(jj=00;jj<=55;jj=jj+5)
		{
			if(start_minute == jj)
				document.upd_prom.start_minute.options[count].selected = true;
			if(finish_minute == jj)
				document.upd_prom.finish_minute.options[count].selected = true;
			count++;
		}
	}
    function add_action(url) {
        $( ".ui-cfmodal-close" ).trigger( "click" );
        window.open(url);
    }
    function kontrol(){
        $('.ui-cfmodal__alert .required_list li, .ui-cfmodal__alert .ui-form-list-btn').remove();
        $('.ui-cfmodal .portBox').attr('style','box-shadow:none!important');
        $('.ui-cfmodal__alert:first ').attr('style','box-shadow: 0 0 15px 15px rgba(0,0,0,.2)!important');
        var data = new FormData();
        data.append('brand_id', $("input#brand_id").val());
        data.append('brand_name', $("input#brand_name").val());
        data.append('cat', $("input#product_catid").val());
        data.append('category_name', $("input#product_cat").val());
        data.append('company_id', $("input#supplier_id").val());
        data.append('company', $("input#supplier_name").val());
        data.append('product_id', $("input#product_id").val());
        data.append('product_name', $("input#product_name").val());
        AjaxControlPostData('/V16/product/cfc/product_proms.cfc?method=getProductsCount', data, function(response) {
            response = JSON.parse(response);
            if(response.STATUS){
                if ($('#prom_point').val()) prom_point = $('#prom_point').val()*parseFloat(filterNum($("#amount_3").val(),4));
                else prom_point = parseFloat(filterNum($("#amount_3").val(),4));
                if($('#supplier_id').val() && $('#supplier_name').val()) supplier_count = 1;
                else supplier_count= response.SUPPLIER_COUNT;
                if($('#product_catid').val() && $('#product_cat').val()) product_cat_count = 1;
                else product_cat_count= response.PRODUCTCAT_COUNT;
                if($('#brand_id').val() && $('#brand_name').val()) brand_count = 1;
                else brand_count= response.BRAND_COUNT;
                if($('#product_id').val() && $('#product_name').val()) {product_count = 1; prod_id_list = $('#product_id').val()}
                else {product_count= response.IDENTITY; prod_id_list = response.PROD_ID_LIST}
                $('.ui-cfmodal__alert .required_list').append('<li class="required"><i class="fa fa-terminal"></i>Toplam Ürün Sayısı : ' + product_count + '</li>');
                $('.ui-cfmodal__alert .required_list').append('<li class="required"><i class="fa fa-terminal"></i>Marka Sayısı : ' + brand_count + '</li>');
                $('.ui-cfmodal__alert .required_list').append('<li class="required"><i class="fa fa-terminal"></i>Alt Kategori Sayısı : ' + product_cat_count + '</li>');
                $('.ui-cfmodal__alert .required_list').append('<li class="required"><i class="fa fa-terminal"></i>Tedarikçi Sayısı : ' + supplier_count + '</li>');
                $('.ui-cfmodal__alert .required_list').after('<div class="ui-form-list-btn"><div><a href="javascript://" onclick="add_action('+"'"+'<cfoutput>#request.self#</cfoutput>?fuseaction=product.list_catalog_promotion&event=add&is_promotion=1&prod_id_list='+ prod_id_list +'&price_list='+$("#price_catid").val()+'&related_catalog_id='+$("input#catalog_id").val()+'&related_catalog_head='+$("input#catalog_head").val()+'&camp_name='+$("input#camp_name").val()+'&camp_id='+$("input#camp_id").val()+'&prom_id='+$("input#PROM_ID").val()+'&prom_head='+$("input#prom_head").val()+'&promotion_code='+$("input#promotion_code").val()+'&startdate='+$("input#startdate").val()+'&finishdate='+$("input#finishdate").val()+'&limit_type='+$("#limit_type").val()+'&number_gift_product='+$("#number_gift_product").val()+'&number_gift_product_ratio='+$("#number_gift_product_ratio").val()+'&free_product='+$("#free_product").val()+'&free_stock_id='+$("#free_stock_id").val()+'&free_stock_amount='+filterNum($("#free_stock_amount").val())+'&special_product_discount_rate='+$("#special_product_discount_rate").val()+'&total_promotion_cost='+filterNum($("#total_promotion_cost").val())+'&amount_1='+parseFloat(filterNum($("#amount_1").val(),4))+'&prom_point='+prom_point+'&amount_discount_2='+filterNum($("#amount_discount_2").val())+"'"+')" class="ui-wrk-btn ui-wrk-btn-success">Aksiyon Ekle</a></div></div>');
            }else{
                $('.ui-cfmodal__alert .required_list').append('<li class="required"><i class="fa fa-terminal"></i>Hata : ' + response.MESSAGE + '</li>');
            }
        });
        $('.ui-cfmodal__alert').fadeIn();

    }
</script>
