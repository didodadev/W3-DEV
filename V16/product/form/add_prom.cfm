<cfif isdefined("attributes.prom_id") and Len(attributes.prom_id)>
	<cfinclude template="../query/get_prom.cfm">
	<cfset attributes.prom_head = get_prom.prom_head>
	<cfset attributes.camp_id = get_prom.camp_id>
	<cfset attributes.stock_id = get_prom.stock_id>
	<cfset attributes.target_due_date = dateformat(get_prom.target_due_date,dateformat_style)>
<cfelse>
	<cfset attributes.prom_head = "">
	<cfset attributes.target_due_date = "">
</cfif>
<cfquery name="PRICE_CATS" datasource="#DSN3#">
	SELECT
		PRICE_CATID,
		PRICE_CAT
	FROM
		PRICE_CAT
	WHERE
		PRICE_CAT_STATUS = 1
	<cfif isdefined("attributes.var_") and (session.ep.isBranchAuthorization)>
		AND PRICE_CAT.BRANCH LIKE '%,#listgetat(session.ep.user_location,2,"-")#,%'
	</cfif>
	ORDER BY
		PRICE_CAT
</cfquery>
<cfquery name="get_roundnum" datasource="#dsn#">
	SELECT SALES_PRICE_ROUND_NUM FROM OUR_COMPANY_INFO WHERE COMP_ID=#session.ep.company_id#
</cfquery>
<cfset roundnum=get_roundnum.sales_price_round_num>
<!--- <cfinclude template="../query/get_discount_types.cfm"> --->
<cfinclude template="../query/get_money.cfm">
<cf_box_data asname="get_card_types" function="V16.objects.cfc.promotions:get_card_types">
<cfif isdefined("attributes.camp_id") and len(attributes.camp_id)>
	<cfquery name="get_camp_info" datasource="#dsn3#">
		SELECT CAMP_ID,CAMP_STARTDATE,CAMP_FINISHDATE,CAMP_HEAD FROM CAMPAIGNS WHERE CAMP_ID = #attributes.camp_id#
	</cfquery>
</cfif>
<cfif isdefined("attributes.prom_id") and Len(attributes.prom_id)>
	<cfset start_date_ = get_prom.startdate>
	<cfset finish_date_ = get_prom.finishdate>
	<cfset camp_id = get_prom.camp_id>
	<cfif Len(camp_id)>
		<cfset camp_head = '#get_camp_info.camp_head#(#dateformat(date_add("H",session.ep.time_zone,start_date_),dateformat_style)#-#dateformat(date_add("H",session.ep.time_zone,finish_date_),dateformat_style)#)'>
	<cfelse>
		<cfset camp_head = "">
	</cfif>
<cfelseif isdefined("attributes.camp_id") and len(attributes.camp_id)>
	<c  <cfset start_date_ = date_add("H",session.ep.time_zone,get_camp_info.camp_startdate)>
        <cfset finish_date_ = date_add("H",session.ep.time_zone,get_camp_info.camp_finishdate)>
	<cfset camp_id = get_camp_info.camp_id>
	<cfset camp_head = "#get_camp_info.camp_head#(#dateformat(date_add("H",session.ep.time_zone,start_date_),dateformat_style)#-#dateformat(date_add("H",session.ep.time_zone,finish_date_),dateformat_style)#)">
<cfelse>
	<cfset start_date_ = "">
	<cfset finish_date_ = "">
	<cfset camp_id = "">
	<cfset camp_head = "">
</cfif>
<cfif len(start_date_)>
	<cfset start_hour_ = datepart("H",start_date_)>
	<cfset start_minute_ = datepart("N",start_date_)>
<cfelse>
	<cfset start_date_ = "">
	<cfset start_hour_ = "">
	<cfset start_minute_ = "">
</cfif>
<cfif Len(finish_date_)>
	<cfset finish_hour_ = datepart("H",finish_date_)>
	<cfset finish_minute_ = datepart("N",finish_date_)>
<cfelse>
	<cfset finish_date_ = "">
	<cfset finish_hour_ = "">
	<cfset finish_minute_ = "">
</cfif>
<cf_papers paper_type="promotion">
 <cf_catalystHeader> 
<cfset str_link="&product_id=add_prom.pid"><cfif isdefined("attributes.from_promotion")><cfset str_link="&from_promotion=1"></cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_prom" method="post" action="#request.self#?fuseaction=product.emptypopup_add_prom">
            <cfoutput query="GET_MONEY">
                <input type="hidden" name="money_#money#" id="money_#money#" value="#wrk_round(rate2/rate1,4)#">
            </cfoutput>
            <cfoutput>
                <cf_box_elements>
                    <input type="hidden" name="BANNER_ID" id="BANNER_ID" >
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                        <div class="form-group" id="item-PROM_STATUS">
                            <label class="col col-12"><span class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></span><span class="col col-8 col-xs-12"><input type="checkbox" name="PROM_STATUS" id="PROM_STATUS" <cfif isdefined("attributes.prom_id") and Len(attributes.prom_id) and get_prom.prom_status eq 1>checked</cfif>></span></label>
                        </div>
                        <div class="form-group" id="item-prom_head">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Başlık'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'> !</cfsavecontent>
                                <cfinput type="text" name="prom_head" value="#attributes.prom_head#" maxlength="100" required="Yes" message="#message#">
                            </div>
                        </div>
                        <div class="form-group" id="item-process">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process is_upd='0' process_cat_width='160' is_detail='0'>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
                        <div class="form-group" id="item-supplier_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="supplier_id"  id="supplier_id" value="<cfif isDefined("attributes.prom_id") and Len(attributes.prom_id)>#get_prom.supplier_id#</cfif>">
                                    <input type="text" name="supplier_name" id="supplier_name" value="<cfif isDefined("attributes.prom_id") and Len(attributes.prom_id)>#Get_Par_Info(get_prom.supplier_id,1,1,0)#</cfif>">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=add_prom.supplier_name&field_comp_id=add_prom.supplier_id&select_list=2&keyword='+encodeURIComponent(document.add_prom.supplier_name.value));"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-camp_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="camp_id" id="camp_id" value="<cfif len(camp_id)>#camp_id#</cfif>">
                                    <input type="text" name="camp_name" id="camp_name" value="<cfif len(camp_head)>#camp_head#</cfif>">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_campaigns&field_id=add_prom.camp_id&field_name=add_prom.camp_name&field_start_date=add_prom.startdate&field_finish_date=add_prom.finishdate&call_function=add_camp_date');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-catalog">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59154.Katalog'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="catalog_id" id="catalog_id" value="">
                                    <input type="text" name="catalog_head" id="catalog_head" value="">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.widget_loader&widget_load=catalogList&isbox=1&is_submitted=1&field_id=add_prom.catalog_id&field_name=add_prom.catalog_head')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-prom_detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="prom_detail" id="prom_detail"><cfif isdefined("attributes.prom_id") and Len(attributes.prom_id)>#get_prom.prom_detail#</cfif></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
                        
                        <div class="form-group" id="item-TOTAL_AMOUNT">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37487.Satış Limiti/Hedef'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="TOTAL_AMOUNT" id="TOTAL_AMOUNT" class="moneybox" value="<cfif isDefined("attributes.prom_id") and Len(attributes.prom_id)>#TLFormat(get_prom.total_amount,roundnum)#</cfif>" onkeyup="return(FormatCurrency(this,event,#roundnum#));">
                                <!--- BK kaldirdi 20130831 6 aya kaldirilsin
                                <td><cf_get_lang dictionary_id='57759.Başlıgı Göster'></td>
                                <td><input type="checkbox" name="is_viewed" id="is_viewed" value="1" <cfif isdefined("attributes.prom_id") and Len(attributes.prom_id) and get_prom.is_viewed eq 1>checked</cfif>></td> --->
                            </div>
                        </div>
                        
                    
                        <div class="form-group" id="item-user_friendly_url">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='38023.Kullanıcı Dostu Url'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <input type="text" name="user_friendly_url" id="user_friendly_url" value="" maxlength="250">
                            </div>
                        </div>	
                        <div class="form-group" id="item-banner_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32248.Banner'><cf_get_lang dictionary_id='58527.ID'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="banner_id" value="">
                            </div>
                        </div>
                        <div class="form-group" id="item-PROMOTION_CODE">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62823.Promosyon Kodu'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <input type="text" name="PROMOTION_CODE" id="PROMOTION_CODE" value="" maxlength="250">
                                
                            </div>
                        </div>	
                    </div>                    
                </cf_box_elements>
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-12 col-xs-12" type="column" sort="true" index="4">
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cfsavecontent  variable="head"><cf_get_lang dictionary_id='37382.Koşullar'></cfsavecontent>
                            <cf_seperator title="#head#" id="kosul">
                            <div id="kosul">
                                <div class="form-group" id="item-startdate">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama'>*</label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Baslangiç Tarihi Girmelisiniz'> !</cfsavecontent>
                                                <cfinput type="text" name="startdate" required="Yes" validate="#validate_style#" message="#message#" value="#DateFormat(start_date_,dateformat_style)#">
                                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
                                            </div>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <cf_wrkTimeFormat name="start_clock" value="">
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <select name="start_minute" id="start_minute">
                                                <cfloop from="00" to="55" index="i" step="5">
                                                    <option value="#numberformat(i,00)#" <cfif start_minute_ eq i>selected</cfif>>#numberformat(i,00)#</option>
                                                </cfloop>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-finishdate">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'> *</label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'> !</cfsavecontent>
                                                <cfinput type="text" name="finishdate" value="#DateFormat(finish_date_,dateformat_style)#" required="Yes" validate="#validate_style#" message="#message#">
                                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
                                            </div>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <cf_wrkTimeFormat name="finish_clock" value="">
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <select name="finish_minute" id="finish_minute">
                                                <cfloop from="0" to="55" index="i" step="5">
                                                    <option value="#numberformat(i,00)#" <cfif finish_minute_ eq i>selected</cfif>>#numberformat(i,00)#</option>
                                                </cfloop>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-prom_type">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37488.Promosyon Tipi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="prom_type" id="prom_type">
                                            <option value="1" <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and get_prom.prom_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='37586.Satıra Uygulanır'></option>
                                            <option value="0" <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and get_prom.prom_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='37587.Toplama Uygulanır'></option>
                                            <option value="2" <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and get_prom.prom_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='37588.Dönemsel Uygulanır'></option>
                                        </select>			
                                    </div>
                                </div>
                                <div class="form-group" id="item-limit_type">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58775.Alışveriş Miktarı'> *</label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="col col-6 col-xs-12">
                                            <select name="limit_type" id="limit_type" onChange="degistir();">
                                                <option value="1" <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and get_prom.limit_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57636.Birim'></option>
                                                <option value="2" <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and get_prom.limit_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57673.Tutar'></option>
                                                <option value="3" <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and get_prom.limit_type eq 3>selected</cfif>><cf_get_lang dictionary_id='37845.Çeşit'></option>
                                            </select>
                                        </div>
                                        <div class="col col-6 col-xs-12">
                                            <input type="text" name="limit_value" id="limit_value" class="moneybox" value="<cfif isDefined("attributes.prom_id") and Len(attributes.prom_id)>#TLFormat(get_prom.limit_value,roundnum)#</cfif>" onkeyup="return(FormatCurrency(this,event,#roundnum#));">
                                            <!--- Buraya bir div eklenmiş ve bu div koşula bağlı olarak aşağıdaki select'i gösteriyordu. Javascript'i ile biraz değiştirdim. Yedeği mevcuttur M.E.Y 20120802--->
                                            <span class="input-group-addon" id="limit_currency" style="display:none">
                                                <select name="limit_currency">
                                                    <cfloop query="get_money">
                                                        <option value="#money#" <cfif (isDefined("attributes.prom_id") and Len(attributes.prom_id) and get_prom.limit_currency eq get_money.money) or (not isDefined("attributes.prom_id") and session.ep.money eq money)>selected</cfif>>#money#</option>
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
                                            <option value="-2" <cfif (isDefined("attributes.prom_id") and Len(attributes.prom_id) and get_prom.price_catid eq -2) or (not isDefined("attributes.prom_id"))>selected</cfif>><cf_get_lang dictionary_id='58721.Standart Satış'></option>
                                            <cfloop query="PRICE_CATS">
                                                <option value="#price_catid#" <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and get_prom.price_catid eq PRICE_CATS.price_catid>selected</cfif>>#price_cat#</option>
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
                                                <option value="#type_id#">#type_name#</option>
                                            </cfloop>
                                        </select>			
                                    </div>
                                </div>
                                <div class="form-group" id="item-product_cat">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="product_catid" id="product_catid" value="<cfif isDefined("attributes.prom_id") and Len(attributes.prom_id)>#get_prom.product_catid#</cfif>">
                                            <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and Len(get_prom.product_catid)>
                                                <cfquery name="Get_Product_Cat" datasource="#dsn3#">
                                                    SELECT PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID = #get_prom.product_catid#
                                                </cfquery>
                                            </cfif>
                                            <input type="text" name="product_cat" id="product_cat" value="<cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and Len(get_prom.product_catid)>#Get_Product_Cat.Product_cat#</cfif>">
                                
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_cat_names&field_id=add_prom.product_catid&field_name=add_prom.product_cat');"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-brand_name">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="brand_id" id="brand_id" value="<cfif isDefined("attributes.prom_id") and Len(attributes.prom_id)>#get_prom.brand_id#</cfif>">
                                            <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and Len(get_prom.brand_id)>
                                                <cfquery name="Get_Brand_Name" datasource="#dsn3#">
                                                    SELECT BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID = #get_prom.brand_id#
                                                </cfquery>
                                            </cfif>
                                            <input type="text" name="brand_name" id="brand_name" value="<cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and Len(get_prom.brand_id)>#Get_Brand_Name.Brand_Name#</cfif>">
                                            
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_brands&brand_id=add_prom.brand_id&brand_name=add_prom.brand_name');"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-product_name">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfif isDefined("attributes.stock_id") and Len(attributes.stock_id)>
                                                <cfquery name="PRODUCT_NAME" datasource="#DSN3#">
                                                    SELECT
                                                        STOCKS.STOCK_ID,
                                                        STOCKS.PRODUCT_ID,
                                                        PRODUCT.PRODUCT_NAME,
                                                        STOCKS.PROPERTY,
                                                        STOCKS.STOCK_CODE
                                                    FROM
                                                        PRODUCT,
                                                        STOCKS
                                                    WHERE
                                                        STOCKS.STOCK_ID = #attributes.stock_id# AND
                                                        STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID
                                                </cfquery>	
                                                <input type="hidden" name="stock_id" id="stock_id" value="#attributes.stock_id#">
                                                <input type="hidden" name="pid" id="pid" value="#product_name.product_id#">
                                            <cfelse>
                                                <input type="hidden" name="stock_id" id="stock_id" value="">
                                                <input type="hidden" name="pid" id="pid" value="">
                                            </cfif>
                                            <cfif isDefined("attributes.stock_id") and not isDefined("attributes.prom_id")>
                                                    <label>#product_name.product_name#&nbsp;#product_name.property#</label>
                                            <cfelse>
                                            <input type="text" name="product_name" id="product_name" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','pid,stock_id','','2','200');" autocomplete="off" value="<cfif isDefined("attributes.stock_id") and Len(attributes.stock_id)>#product_name.product_name#&nbsp;#product_name.property#</cfif>"> 
                                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names&field_id=add_prom.stock_id&field_name=add_prom.product_name&field_calistir=1#str_link#');"></span>
                                            </cfif>
                                        </div>
                                    </div>
                                </div>
                                <cf_duxi name="is_all_products" id="is_all_products" type="checkbox" value="1" label="30167">
                            </div>
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
                                            <input type="text" id="discount_rate" name="discount_rate" class="moneybox" onkeyup="return(FormatCurrency(this,event,#roundnum#));">
                                            <span class="input-group-addon">%</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63981.Aynı Üründen Kazan'></label>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                        <div class="input-group">
                                            <input type="text" id="number_gift_product" name="number_gift_product" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event,#roundnum#));">
                                            <span class="input-group-addon"><cf_get_lang dictionary_id='58082.Adet'></span>
                                        </div>
                                    </div>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                        <div class="input-group">
                                            <input type="text" id="number_gift_product_ratio" name="number_gift_product_ratio" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event,#roundnum#));">
                                            <span class="input-group-addon">%</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">  <div class="col col-4 col-md-4 col-sm-4 col-xs-12"></div><cf_get_lang dictionary_id='37490.Diğer Maliyetler'>
                                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63965.Özel Ürün Kazan'></label>
                                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <div class="input-group">
                                                        <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and Len(get_prom.free_stock_id)>
                                                            <cfquery name="GET_STOCK_FREE" datasource="#DSN3#">
                                                                SELECT
                                                                    P.PRODUCT_NAME,
                                                                    S.PROPERTY
                                                                FROM
                                                                    STOCKS S,
                                                                    PRODUCT P
                                                                WHERE
                                                                    S.PRODUCT_ID = P.PRODUCT_ID AND
                                                                    S.STOCK_ID = #get_prom.free_stock_id# 
                                                            </cfquery>
                                                            <cfset stock = "#get_stock_free.product_name# #get_stock_free.property#">
                                                        <cfelse>
                                                            <cfset stock = "">
                                                        </cfif>
                                                        <input type="hidden" name="free_stock_id" id="free_stock_id" value="<cfif isDefined("attributes.prom_id") and Len(attributes.prom_id)>#get_prom.free_stock_id#</cfif>">
                                                        <input type="text" name="free_product" id="free_product" value="#stock#" readonly>
                                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names&run_function=hesapla()&field_product_cost=add_prom.amount_1&field_id=add_prom.free_stock_id&field_name=add_prom.free_product');"></span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                        <div class="col col-2 col-md-2 col-sm-2 col-xs-12"><cf_get_lang dictionary_id='58258.Maliyet'>
                                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                                <input type="text" name="amount_1" id="amount_1" value="<cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and Len(get_prom.amount_1)>#TLFormat(get_prom.amount_1,roundnum)#</cfif>" class="moneybox" onkeyup="return(FormatCurrency(this,event,#roundnum#));" onBlur="hesapla();">  
                                            </div>
                                        </div>
                                        <div class="col col-2 col-md-2 col-sm-2 col-xs-12"><cf_get_lang dictionary_id ='57489.Para Br'>
                                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                                <select name="amount_1_money" id="amount_1_money" onBlur="hesapla();">
                                                    <cfloop query="get_money">
                                                        <option value="#money#" <cfif (isDefined("attributes.prom_id") and Len(attributes.prom_id) and get_prom.amount_1_money eq money) or (not isDefined("attributes.prom_id") and session.ep.money eq money)>selected</cfif>>#money#</option>
                                                    </cfloop>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col col-2 col-md-2 col-sm-2 col-xs-12"><cf_get_lang dictionary_id='58082.Adet'>
                                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">                                                    
                                                <input type="text" name="free_stock_amount" id="free_stock_amount" value="<cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and Len(get_prom.free_stock_amount)>#TLFormat(get_prom.free_stock_amount,roundnum)#</cfif>" onkeyup="return(FormatCurrency(this,event,#roundnum#));" class="moneybox">
                                            </div>
                                        </div>
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='63934.İndirim Oranı'>% 
                                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">                                                 
                                                <input type="text" name="special_product_discount_rate" id="special_product_discount_rate" value="" class="moneybox" onkeyup="return(FormatCurrency(this,event,#roundnum#));">
                                            </div>
                                        </div>
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='37643.Fatura Fiyatı'> 
                                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">                                                 
                                                <input type="text" name="free_stock_price" id="free_stock_price" value="<cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and Len(get_prom.free_stock_price)>#TLFormat(get_prom.free_stock_price,roundnum)#</cfif>" class="moneybox" onkeyup="return(FormatCurrency(this,event,#roundnum#));" onBlur="hesapla();">
                                            </div>
                                        </div>	
                                    </div>
                                </div>
                                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                        <label class="pull-right"><cf_get_lang dictionary_id='57492.Toplam'></label>
                                    </div>
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    
                                        <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id)>
                                            <cfset total_promotion_cost_ = TLFormat(get_prom.total_promotion_cost,roundnum)>
                                        <cfelse>
                                            <cfset total_promotion_cost_ = "">
                                        </cfif>
                                        <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57743.Dönem Primi girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="total_promotion_cost" class="moneybox" value="#total_promotion_cost_#" message="#message#"  onkeyup="return(FormatCurrency(this,event,#roundnum#));">
                                        </div>
                                        <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                            <select name="total_promotion_cost_money" id="total_promotion_cost_money" disabled>
                                                <cfloop query="get_money">
                                                    <option value="#money#" <cfif (isDefined("attributes.prom_id") and Len(attributes.prom_id) and get_prom.total_promotion_cost_money eq get_money.money) or (not isDefined("attributes.prom_id") and session.ep.money eq money)>selected</cfif>>#money#</option>
                                                </cfloop>
                                            </select>
                                        </div>     
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12"></div>  
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
                                        <div class="input-group">
                                            <input type="hidden" name="coupon_id" id="coupon_id" value="<cfif isDefined("attributes.prom_id") and Len(attributes.prom_id)>#get_prom.coupon_id#</cfif>">
                                            <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and Len(get_prom.coupon_id)>
                                                <cfquery name="get_coupon" datasource="#dsn3#">
                                                    SELECT COUPON_NAME FROM COUPONS WHERE COUPON_ID = #get_prom.coupon_id#
                                                </cfquery>
                                            </cfif>
                                            <input type="text" name="coupon" id="coupon" value="<cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and Len(get_prom.coupon_id)>#get_coupon.coupon_name#</cfif>" readonly>
                                            <span class="input-group-addon icon-ellipsis" href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=product.popup_coupons_list&field_id=add_prom.coupon_id&field_name=add_prom.coupon');"></span>
                                        </div>
                                    </div>
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">    
                                            <input type="text" name="amount_discount_2" id="amount_discount_2" value="<cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and len(get_prom.amount_discount_2)>#TLFormat(get_prom.amount_discount_2,roundnum)#</cfif>" class="moneybox" onkeyup="return(FormatCurrency(this,event,#roundnum#));" onBlur="hesapla();">                                        
                                        </div>
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">    
                                            <select name="amount_discount_money_2" id="amount_discount_money_2" onBlur="hesapla();">
                                                <cfloop query="get_money">
                                                    <option value="#money#" <cfif (isDefined("attributes.prom_id") and Len(attributes.prom_id) and get_prom.amount_discount_money_2 eq get_money.money) or (not isDefined("attributes.prom_id") and session.ep.money eq money)>selected</cfif>>#money#</option>
                                                </cfloop>
                                            </select>
                                        </div>   
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">  
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='34380.Para Puan'></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                            <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id)>
                                                <cfset prom_point_ = get_prom.prom_point>
                                            <cfelse>
                                                <cfset prom_point_ = "">
                                            </cfif>
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57745.Puan Girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="prom_point" class="moneybox" value="#prom_point_#" validate="integer" message="#message#">
                                        </div>
                                    </div>
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                                            <input type="text" name="amount_3" id="amount_3" value="<cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and Len(get_prom.amount_3)>#TLFormat(get_prom.amount_3,roundnum)#</cfif>" class="moneybox" onkeyup="return(FormatCurrency(this,event,#roundnum#));" onBlur="hesapla();">
                                        </div>
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">  
                                            <select name="amount_3_money" id="amount_3_money" onBlur="hesapla();">
                                                <cfloop query="get_money">
                                                    <option value="#money#" <cfif (isDefined("attributes.prom_id") and Len(attributes.prom_id) and get_prom.amount_3_money eq get_money.money) or (not isDefined("attributes.prom_id") and session.ep.money eq money)>selected</cfif>>#money#</option>
                                                </cfloop>
                                            </select>
                                        </div>
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">  
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>    
                    </div>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" sort="true" index="9">
                        <cfsavecontent  variable="head"><cf_get_lang dictionary_id='58029.İkon'></cfsavecontent>
                        <cf_seperator title="#head#" id="icon">
                        <div id="icon" id="item-icons">
                            <label class="hide"><cf_get_lang dictionary_id='42231.İkonlar'></label>
                            <cfquery name="GET_ICON" datasource="#DSN3#">
                                SELECT * FROM SETUP_PROMO_ICON
                            </cfquery>                                    
                            <a href="javascript:void(0)" class="margin-right-10">
                                <input type="radio" name="icon_id" id="icon_id" value="" <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and Len(get_prom.icon_id)>checked</cfif>>
                                <cf_get_lang dictionary_id='37653.Boş'>
                            </a>
                            <cfloop query="get_icon">
                                <a href="javascript:void(0)">                                        
                                    <input type="radio" name="icon_id" id="icon_id" value="#get_icon.icon_id#" <cfif isDefined("attributes.prom_id") and Len(attributes.prom_id) and get_prom.icon_id eq icon_id>checked</cfif>>
                                    <cfif len(get_icon.icon_server_id)>
                                        <cf_get_server_file output_file="sales/#get_icon.icon#" output_server="#get_icon.icon_server_id#" output_type="0" image_height="25"> 
                                    <cfelse>
                                        <cf_get_lang dictionary_id='37653.Boş'>
                                    </cfif>
                                </a>                                     
                            </cfloop>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <div class="col col-12">
                        <cf_workcube_buttons is_upd='0' add_function='form_kontrol()'>
                    </div>
                </cf_box_footer>
            </cfoutput>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
    $('#is_all_products').change(function(){
        if (this.checked) $('#product_cat, #product_catid, #brand_name, #brand_id, #product_name, #pid, #stock_id').val('');
    });
	function degistir()
	{
		if(document.add_prom.limit_type.value==2)
			document.getElementById('limit_currency').style.display = '';
		else
			document.getElementById('limit_currency').style.display = 'none';
	}
	function hesapla()
	{	
		var t1 = parseFloat(filterNum(add_prom.amount_discount_2.value,4));
		var t2 = parseFloat(filterNum(add_prom.amount_1.value,4));
		//var t3 = parseFloat(filterNum(add_prom.amount_2.value,4));
		var t4 = parseFloat(filterNum(add_prom.amount_3.value,4));
		//var t5 = parseFloat(filterNum(add_prom.amount_4.value,4));
		if (isNaN(t1)) {t1 = 0; add_prom.amount_discount_2.value = 0;}
		if (isNaN(t2)) {t2 = 0; add_prom.amount_1.value = 0;}
		//if (isNaN(t3)) {t3 = 0; add_prom.amount_2.value = 0;}
		if (isNaN(t4)) {t4 = 0; add_prom.amount_3.value = 0;}
		//if (isNaN(t5)) {t5 = 0; add_prom.amount_4.value = 0;}
		//if (isNaN(t6)) {t6 = 0; add_prom.amount_5.value = 0;}
        else {if ($('#prom_point').val()) t4 = $('#prom_point').val()*t4;}
		
		t1 = t1 * eval('add_prom.money_'+add_prom.amount_discount_money_2.value).value;
		t2 = t2 * eval('add_prom.money_'+add_prom.amount_1_money.value).value;
		//t3 = t3 * eval('add_prom.money_'+add_prom.amount_2_money.value).value;
		t4 = t4 * eval('add_prom.money_'+add_prom.amount_3_money.value).value;
		//t5 = t5 * eval('add_prom.money_'+add_prom.amount_4_money.value).value;
		//t6 = t6 * eval('add_prom.money_'+add_prom.amount_5_money.value).value;
		order_total = t2+t4-t1;
		add_prom.total_promotion_cost.value = commaSplit(order_total,4);
	}	
	function unformat_fields()
	{
		add_prom.limit_value.value = filterNum(add_prom.limit_value.value);
		add_prom.TOTAL_AMOUNT.value = filterNum(add_prom.TOTAL_AMOUNT.value);
		add_prom.amount_discount_2.value = filterNum(add_prom.amount_discount_2.value,4);
		add_prom.amount_1.value = filterNum(add_prom.amount_1.value);
		add_prom.amount_3.value = filterNum(add_prom.amount_3.value);
		add_prom.free_stock_price.value = filterNum(add_prom.free_stock_price.value);
		add_prom.free_stock_amount.value = filterNum(add_prom.free_stock_amount.value);
		add_prom.total_promotion_cost.value = filterNum(add_prom.total_promotion_cost.value);
		add_prom.total_promotion_cost_money.disabled = false;
	}	
	function form_kontrol()
	{
		if(
		    document.add_prom.free_stock_id.value == "" && 
			document.add_prom.prom_point.value == "" &&  document.add_prom.gift_head.value == "" && 
			document.add_prom.amount_discount_2.value == "")
		{ 
			alert ("<cf_get_lang dictionary_id ='37846.Hiçbir Promosyon Koşulu Girmediniz'> !");
			return false;
		}	
		if(document.add_prom.limit_value.value == "")
		{
			alert("<cf_get_lang dictionary_id='57744.Alışveriş Miktarı girmelisiniz'>!");
			return false;
		}	
		if('<cfoutput>#session.ep.our_company_info.workcube_sector#</cfoutput>' =='per')
		{
			if(document.add_prom.free_product.value == "" )
			{
				alert ("<cf_get_lang dictionary_id ='37847.Anında İndirim Bölümüne İndirim Yüzdesi yada Tutarı Girmelisiniz'> !");
				return false;	
			}
		}
        if ($('#is_all_products').is(':checked')) $('#product_cat, #product_catid, #brand_name, #brand_id, #product_name, #pid, #stock_id').val('');
		unformat_fields();		
		if(time_check(add_prom.startdate, add_prom.start_clock, add_prom.start_minute, add_prom.finishdate,  add_prom.finish_clock, add_prom.finish_minute, "<cf_get_lang dictionary_id ='37849.Promosyon Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'> !"))
			return process_cat_control();
		else
			return false;
		
	}	
	function butonlari_goster()
	{
		butonlar.style.display = '';
	}
<cfif isDefined("attributes.stock_id")>
	function sayfa_ac(sayfa_type)
	{
		<cfoutput>
			pid = document.getElementById('pid').value;
			if(pid != '')
			{
				if(sayfa_type==1)
					windowopen('#request.self#?fuseaction=product.popup_product_contract&pid='+pid,'project');
				else
					windowopen('#request.self#?fuseaction=product.popup_product_cost&pid='+pid,'list');
			}
		</cfoutput>
	}
</cfif>
	
	function empty_target_due_date(deger)
	{
		if (deger==1)
			document.add_prom.target_due_date.value='';
		else
			document.add_prom.due_day.value='';
	}
	function add_camp_date(start_hour,start_minute,finish_hour,finish_minute)
	{
		count = 0;
		for(kk=1;kk<=24;kk++)
		{
			if(start_hour == kk)
				document.add_prom.start_clock.options[count].selected = true;
			if(finish_hour == kk)
				document.add_prom.finish_clock.options[count].selected = true;
			count++;
		}
		count = 0;
		for(jj=00;jj<=55;jj=jj+5)
		{
			if(start_minute == jj)
				document.add_prom.start_minute.options[count].selected = true;
			if(finish_minute == jj)
				document.add_prom.finish_minute.options[count].selected = true;
			count++;
		}
	}
</script>
