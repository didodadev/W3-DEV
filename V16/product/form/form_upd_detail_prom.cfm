<cfset xml_page_control_list = 'is_conscat_segmentation,is_conscat_premium,is_product_code_2,other_price_cat'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="0" fuseact="product.form_upd_detail_prom">
<cfinclude template="../query/get_consumer_cat.cfm">
<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_price_cats.cfm">
<cfinclude template="../../member/query/get_member_add_options.cfm">
<cfif isdefined("other_price_cat") and len(other_price_cat)>
	<cfquery name="GET_PRICECAT_NAME" dbtype="query">
		SELECT PRICE_CAT FROM GET_PRICE_CATS WHERE PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#other_price_cat#">
	</cfquery>
<cfelse>
	<cfset get_pricecat_name.recordcount = 0>
</cfif>
<cfquery name="GET_PROM" datasource="#DSN3#">
	SELECT * FROM PROMOTIONS WHERE PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_id#">
</cfquery>
<cfquery name="get_prom_products" datasource="#dsn3#">
	SELECT 
		PP.*,
		<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>P.PRODUCT_CODE_2 AS PRODUCT_CODE<cfelse>P.PRODUCT_CODE</cfif>,
		P.PRODUCT_NAME 
	FROM 
		PROMOTION_PRODUCTS PP,
		PRODUCT P
	WHERE 
		PP.PROMOTION_ID = #attributes.prom_id# AND 
		P.PRODUCT_ID = PP.PRODUCT_ID
</cfquery>

<cfquery name="get_prom_conditions" datasource="#dsn3#">
	SELECT * FROM PROMOTION_CONDITIONS WHERE PROMOTION_ID = #attributes.prom_id# ORDER BY PROM_CONDITION_ID
</cfquery>
<cfquery name="get_prom_related" datasource="#dsn3#">
	SELECT PROMOTION_RELATED_PROMOTIONS.*,PROM_HEAD,PROM_NO FROM PROMOTION_RELATED_PROMOTIONS,PROMOTIONS WHERE PROMOTION_RELATED_PROMOTIONS.PROMOTION_ID = #attributes.prom_id# AND PROMOTION_RELATED_PROMOTIONS.RELATED_PROM_ID = PROMOTIONS.PROM_ID ORDER BY PROM_RELATED_ID
</cfquery>
<cfif isdefined("is_copy")>
	<cf_papers paper_type="promotion">
	<cfset action_ = "emptypopup_add_detail_prom">
	<cfset system_paper_no = paper_code & '-' & paper_number>
	<cfset system_paper_no_add = paper_number>
<cfelse>
	<cfset action_ = "emptypopup_upd_detail_prom">
</cfif>
<cfquery name="get_credit_types" datasource="#dsn3#">
	SELECT PAYMENT_TYPE_ID,CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE ISNULL(IS_PROM_CONTROL,0) = 1
</cfquery>
<cfsavecontent variable="title_">
	<cfif isdefined("is_copy")>
		<cfset pageHead = #getLang('main',1373)# & " " & #getLang('product',543)#>
    <cfelse>
        <cfset pageHead = #getLang('main',1373)# & " " & #getLang('product',232)# & " " & #getLang('main',52)# & " : " & #attributes.prom_id#>
    </cfif>
</cfsavecontent>


<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">    
    <cf_box>
        <cfform name="add_prom" method="post" action="#request.self#?fuseaction=product.#action_#" enctype="multipart/form-data">
            <input type="hidden" value="<cfoutput>#attributes.prom_id#</cfoutput>" name="prom_id" id="prom_id">
            <input type="hidden" name="pageDelEvent" id="pageDelEvent" value="delDetail">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                    <div class="form-group" id="item-prom_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58820.Başlık'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58059.Başlık Girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" name="prom_head" value="#get_prom.prom_head#" maxlength="100" required="Yes" message="#message#" >
                        </div>
                    </div>
                    <div class="form-group" id="item-system_paper_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57487.No'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif isdefined("is_copy")>
                                <input type="text" name="system_paper_no" id="system_paper_no"  value="<cfoutput>#system_paper_no#</cfoutput>" maxlength="50">
                                <input type="hidden" name="system_paper_no_add" id="system_paper_no_add" value="<cfoutput>#system_paper_no_add#</cfoutput>" maxlength="50">
                            <cfelse>
                                <input type="text" name="prom_no" id="prom_no"  value="<cfoutput>#get_prom.prom_no#</cfoutput>" maxlength="50">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail_prom_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37488.Promosyon Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="detail_prom_type" id="detail_prom_type" >
                                <option value="1" <cfif get_prom.detail_prom_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='37286.Katalog Promosyonu'></option>
                                <option value="2" <cfif get_prom.detail_prom_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='37287.Temsilci Programı'></option>
                                <option value="3" <cfif get_prom.detail_prom_type eq 3>selected</cfif>><cf_get_lang dictionary_id ='37211.Kredi Kartı Promosyonu'></option>
                                <option value="4" <cfif get_prom.detail_prom_type eq 4>selected</cfif>><cf_get_lang dictionary_id ='37212.Kargo Promosyonu'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-process">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' select_value='#get_prom.prom_stage#' process_cat_width='160' is_detail='1'>
                        </div>
                    </div>
                    <div class="form-group" id="item-price_catid">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37303.Geçerli Fiyat Listesi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="price_catid" id="price_catid" >
                                <cfoutput query="get_price_cats">
                                    <option value='#price_catid#' <cfif get_prom.price_catid eq price_catid>selected</cfif>>#price_cat#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-condition_price_catid">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37338.Hesaplanacak Fiyat Listesi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="condition_price_catid" id="condition_price_catid" >
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_price_cats">
                                    <option value="#price_catid#" <cfif get_prom.condition_price_catid eq price_catid>selected</cfif>>#price_cat#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-reference_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37361.Referans Kodu'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="reference_code" id="reference_code"  maxlength="150" value="<cfoutput>#get_prom.reference_code#</cfoutput>">
                        </div>
                    </div>
                    <div class="form-group" id="item-control_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37385.Bekleyen Sipariş Kontrol Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='37389.Kontrol Tarihi Girmelisiniz'>!</cfsavecontent>
                                <cfif len(get_prom.demand_control_date)>
                                    <cfinput type="text" name="control_date" validate="#validate_style#" value="#dateformat(get_prom.demand_control_date,dateformat_style)#" message="#message#" >
                                <cfelse>
                                    <cfinput type="text" name="control_date" validate="#validate_style#" value="" message="#message#" >
                                </cfif>
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="control_date"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
                    <div class="form-group" id="item-startdate">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ="57501.Başlangıç"> *</label>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <cfset startdate = date_add('h',session.ep.time_zone,get_prom.startdate)>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Baslangiç Tarihi Girmelisiniz'></cfsavecontent>
                                <cfinput type="text" name="startdate" required="Yes" validate="#validate_style#" message="#message#" value="#dateformat(startdate,dateformat_style)#" >
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
                                <cfset start_clock = timeformat(startdate,"HH")>
                                <cfset start_minute = timeformat(startdate,"mm")>
                            </div>
                        </div>
                        <div class="col col-2 col-xs-12">
                            <cfoutput>
                                <cfif len(start_clock) and start_clock is 0>
                                <cf_wrkTimeFormat name="start_clock" value="00">	
                                <cfelse>
                                    <cf_wrkTimeFormat name="start_clock" value="#numberformat("#start_clock#",00)#">	
                                </cfif> 
                            </cfoutput>
                        </div>
                        <div class="col col-2 col-xs-12">
                            <cfoutput>
                                <select name="start_minute" id="start_minute">
                                    <cfloop from="0" to="55" index="i" step="5"> 
                                        <option value="#numberformat(i,00)#" <cfif len(start_minute) and start_minute is i>selected</cfif>>#numberformat(i,00)#</option>
                                    </cfloop> 
                                </select>
                            </cfoutput>
                        </div>
                    </div>
                    <div class="form-group" id="item-finishdate">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'> *</label>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <cfset finishdate = date_add('h',session.ep.time_zone,get_prom.finishdate)>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi girmelisiniz'></cfsavecontent>
                                <cfinput type="text" name="finishdate" required="Yes" validate="#validate_style#" message="#message#" value="#dateformat(finishdate,dateformat_style)#" >
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
                                <cfset finish_clock = timeformat(finishdate,"HH")>
                                <cfset finish_minute = timeformat(finishdate,"mm")>
                            </div>
                        </div>
                        <div class="col col-2 col-xs-12">
                            <cfoutput>
                                <cfif len(finish_clock) and finish_clock is 0>
                                    <cf_wrkTimeFormat name="finish_clock" value="00">	
                                <cfelse>
                                    <cf_wrkTimeFormat name="finish_clock" value="#numberformat("#finish_clock#",00)#">	
                                </cfif>   
                            </cfoutput>
                        </div>
                        <div class="col col-2 col-xs-12">
                            <cfoutput>
                                <select name="finish_minute" id="finish_minute">
                                    <cfloop from="0" to="55" index="i" step="5"> 
                                        <option value="#numberformat(i,00)#" <cfif len(finish_minute) and finish_minute is i>selected</cfif>>#numberformat(i,00)#</option>
                                    </cfloop> 
                                </select>
                            </cfoutput>
                        </div>
                    </div>
                    <div class="form-group" id="item-prom_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37488.Promosyon Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="prom_type" id="prom_type">
                                <option value="0" <cfif get_prom.prom_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='57611.Sipariş'></option>
                                <option value="2" <cfif get_prom.prom_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='37301.Dönemsel'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-camp_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif len(get_prom.camp_id)>
                                    <cfquery name="get_camp_name" datasource="#dsn3#">
                                        SELECT CAMP_HEAD,CAMP_STARTDATE,CAMP_FINISHDATE FROM CAMPAIGNS WHERE CAMP_ID = #get_prom.camp_id#
                                    </cfquery>
                                </cfif>
                                <input type="hidden" name="camp_id" id="camp_id" value="<cfif len(get_prom.camp_id)><cfoutput>#get_prom.camp_id#</cfoutput></cfif>">
                                <input type="text" name="camp_name" id="camp_name" value="<cfif len(get_prom.camp_id)><cfoutput>#get_camp_name.camp_head#</cfoutput></cfif>">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_campaigns</cfoutput>&field_id=add_prom.camp_id&field_name=add_prom.camp_name&field_start_date=add_prom.startdate&field_finish_date=add_prom.finishdate&call_function=add_camp_date');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-work_hierarchy">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37909.Çalışma Sırası'></label>
                        <div class="col col-3 col-xs-12">
                                <input type="text" name="work_hierarchy" id="work_hierarchy" value="<cfoutput>#get_prom.prom_hierarchy#</cfoutput>" onkeyup="isNumber(this);"  class="moneybox">
                        </div>
                        <div class="col col-5 col-xs-12">
                            <label>
                                <input type="checkbox" name="is_prom_warning" id="is_prom_warning" value="1" <cfif get_prom.is_prom_warning eq 1>checked</cfif>/>
                                <cf_get_lang dictionary_id ='37308.Promosyon Uyarı Versin'>
                            </label>
                        </div>
                    </div>
                    <div class="form-group" id="item-prom_count">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37339.Çalışma Sayısı'></label>
                        <div class="col col-3 col-xs-12">
                            <input type="text" name="prom_count" id="prom_count" value="<cfoutput>#get_prom.prom_work_count#</cfoutput>" onkeyup="isNumber(this);"  class="moneybox">
                        </div>        
                        <label class="col col-5 col-xs-12">(<cf_get_lang dictionary_id ='37340.Boş Girilirse Sonsuz Sayıda Çalışır'>))</label>
                    </div>
                    <div class="form-group" <cfif get_prom.is_cons_ref_prom eq 0>style="display:none;"</cfif> id="member_td_2">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37421.Temsilci Kayıt Sırası'></label>
                        <div class="col col-3 col-xs-12">
                            <input type="text" name="member_line_order" id="member_line_order"  <cfif len(get_prom.member_record_line)>value="<cfoutput>#get_prom.member_record_line#</cfoutput>"</cfif> onkeyup="isNumber(this);" class="moneybox">
                        </div>
                    </div>
                    <div class="form-group"  <cfif get_prom.is_cons_ref_prom eq 0>style="display:none;"</cfif> id="member_td_1">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37367.Temsilci Sipariş Sayısı'></label>
                        <div class="col col-3 col-xs-12">
                            <input type="text" name="member_order_count" id="member_order_count" <cfif len(get_prom.member_order_count)>value="<cfoutput>#get_prom.member_order_count#</cfoutput>"</cfif>  onkeyup="isNumber(this);" class="moneybox">
                        </div>
                    </div>
                    <div class="form-group" id="item-consumer_ref_prom">
                        <label class="col col-12">
                            <cf_get_lang dictionary_id ='37366.Temsilci Öner Programı'>
                            <input type="checkbox" name="consumer_ref_prom" id="consumer_ref_prom" value="1" onclick="control_member();" <cfif get_prom.is_cons_ref_prom eq 1>checked</cfif>>
                        </label>
                            
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
                    <div class="form-group" id="item-prom_detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="prom_detail" id="prom_detail"><cfoutput>#get_prom.prom_detail#</cfoutput></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-kamp_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
                        <div class="col col-8 col-xs-12">
                            <cfoutput>
                                <select name="kamp_type" id="kamp_type" multiple >
                                    <cfloop from="1" to="10" index="kk">
                                        <option value="#kk#" <cfif listfind(get_prom.work_camp_type,kk)>selected</cfif>>#kk#.<cf_get_lang dictionary_id='57446.Kampanya'></option>
                                    </cfloop>								
                                </select>
                            </cfoutput>
                        </div>
                    </div>
                    <div class="form-group" id="item-checkboxes">
                        <div class="col col-12">
                            <label>
                                <cf_get_lang dictionary_id ='37310.Zorunlu Promosyon'>
                                <input type="checkbox" name="is_required_prom" id="is_required_prom" value="1" <cfif get_prom.is_required_prom eq 1>checked</cfif>>
                            </label>
                            <label>
                                <cf_get_lang dictionary_id ='37322.Sadece İlk Siparişte Çalışsın'>
                                <input type="checkbox" name="first_order" id="first_order" value="1" <cfif get_prom.is_only_first_order eq 1>checked</cfif>>
                            </label>
                            <label>
                                <cf_get_lang dictionary_id ='58515.Aktif/Pasif'>
                                <input type="checkbox" name="prom_status" id="prom_status" value="1" <cfif get_prom.prom_status>checked</cfif>>
                            </label>
                            <label>
                                <cf_get_lang dictionary_id ='37359.İnternette Göster'>
                                <input type="checkbox" name="is_internet" id="is_internet" value="1" <cfif get_prom.is_internet eq 1>checked</cfif>>
                            </label>
                            <label>
                                <cf_get_lang dictionary_id ='37371.Bekleyen Siparişe Alınan Urunler Promosyona Dahil Olsun'>
                                <input type="checkbox" name="is_demand_products" id="is_demand_products" value="1" <cfif get_prom.is_demand_products eq 1>checked</cfif>>
                            </label>
                            <label>
                                <cf_get_lang dictionary_id ='37437.Bekleyen Siparişten Gelen Urnler Promosyona Dahil Olsun'>
                                <input type="checkbox" name="is_demand_order_products" id="is_demand_order_products" value="1" <cfif get_prom.is_demand_order_products eq 1>checked="checked"</cfif>>
                            </label>
                            <label>
                                <cf_get_lang dictionary_id="37214.İadeler Promosyondan Düşülsün">
                                <input type="checkbox" name="drp_rtr_from_prom" id="drp_rtr_from_prom" value="1" <cfif get_prom.drp_rtr_from_prom eq 1>checked="checked"</cfif>>
                            </label>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='37448.Koşullar ve Kazanç'></cfsavecontent>
            <cf_seperator title="#message#" id="kosullar_ve_kazanc_">
            <div class="row" id="kosullar_ve_kazanc_" type="row">
                <cf_box_elements>
                    <div class="col col-12" type="column" sort="false" index="4">
                        <div class="row">
                            <div class="col col-6 col-xs-12">
                                <div id="table2">
                                    <div class="row" id="table1">
                                        <div class="col col-12">
                                            <div class="form-group" id="item-kosullar_baslik">
                                                <a onclick="add_condition();" style="cursor:pointer;"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='37460.Koşul Ekle'>" align="absmiddle"></i></a>&nbsp;<label for="" class="bold" ><cf_get_lang dictionary_id ='37382.Koşullar'></label>
                                            </div>
                                        </div>
                                        <div class="col col-12">
                                            <div class="form-group" id="item-prom_condition_status">
                                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37509.Koşul Çalışma Şekli'></label>
                                                <div class="col col-4 col-xs-12">
                                                    <label><input type="checkbox" name="prom_condition_status_and" id="prom_condition_status_and" value="1" onclick="check_condition_status(1);" <cfif get_prom.condition_list_work_type eq 1>checked</cfif>> <cf_get_lang dictionary_id ='57989.Ve'></label>
                                                </div>
                                                <div class="col col-4 col-xs-12">
                                                    <label><input type="checkbox" name="prom_condition_status_or" id="prom_condition_status_or" value="1" onclick="check_condition_status(2);" <cfif get_prom.condition_list_work_type eq 0>checked</cfif>> <cf_get_lang dictionary_id ='57998.Veya'></label>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-is_prom">
                                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37519.Promosyon Çalışma Şekli'></label>
                                                <div class="col col-4 col-xs-12">
                                                    <label><input type="checkbox" name="is_prom_and" id="is_prom_and" value="1" onclick="check_prom(1);" <cfif get_prom.prom_work_type eq 1>checked</cfif>> <cf_get_lang dictionary_id ='57989.Ve'></label>
                                                </div>
                                                <div class="col col-4 col-xs-12">
                                                    <label><input type="checkbox" name="is_prom_or" id="is_prom_or" value="1" onclick="check_prom(2);" <cfif get_prom.prom_work_type eq 0>checked</cfif>> <cf_get_lang dictionary_id ='57998.Veya'></label>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-consumer_category" param="settings.form_add_consumer_categories">
                                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></label>
                                                <div class="col col-8 col-xs-12">
                                                    <select name="consumer_category" id="consumer_category" multiple>
                                                        <cfoutput query="get_consumer_cat">
                                                            <option value="#conscat_id#" <cfif len(get_prom.consumercat_id) and listfind(get_prom.consumercat_id,conscat_id)>selected</cfif>>#conscat#</option>
                                                        </cfoutput>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-member_add_option">
                                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="37329.Üye Özel Tanımı"></label>
                                                <div class="col col-8 col-xs-12">
                                                    <select name="member_add_option" id="member_add_option" multiple>
                                                        <cfoutput query="get_member_add_options">
                                                            <option value="#member_add_option_id#" <cfif len(get_prom.member_add_option_id) and listfind(get_prom.member_add_option_id,member_add_option_id)>selected</cfif>>#member_add_option_name#</option>
                                                        </cfoutput>
                                                    </select>
                                                </div>
                                            </div>
                                            <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_prom_conditions.recordcount#</cfoutput>">
                                            <div id="condition" style="display:none;"></div>
                                            <cfoutput query="get_prom_conditions">
                                                <script type="text/javascript">
                                                    if (document.getElementById('form_complete_'))
                                                        add_condition(#prom_condition_id#);
                                                    else
                                                        setTimeout('add_condition(#prom_condition_id#)',250);
                                                </script>
                                            </cfoutput>
                                            <input type="hidden" name="form_complete_" id="form_complete_">
                                        </div>
                                    </div>
                                </div>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='37520.Promosyon Listesi'></cfsavecontent>
                                <cf_seperator title="#message#" id="promosyon_listesi_">
                                <div class="form-group" id="item-promotion_list">
                                    <div class="col col-8">
                                        <div id="promosyon_listesi_">
                                            <div id="promotion">
                                                <cf_grid_list class="workDevList">
                                                    <thead>
                                                        <tr>
                                                            <input type="hidden" name="record_num3" id="record_num3" value="<cfoutput>#get_prom_related.recordcount#</cfoutput>">
                                                            <th style="text-align:center; width:20px"><a style="cursor:pointer" onclick="add_row3();"><i class="fa fa-plus"></i></a></th>
                                                            <th nowrap class="txtbold"><cf_get_lang dictionary_id="57487.No"></th>
                                                            <th  nowrap class="txtbold"><cf_get_lang dictionary_id ='37592.Promosyon Başlığı'></th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="table3" name="table3"> 
                                                        <cfoutput query="get_prom_related">
                                                            <tr id="frm_row3#currentrow#">
                                                                <td style="text-align:center; width:20px">
                                                                    <input  type="hidden" value="1" name="row_kontrol3#currentrow#" id="row_kontrol3#currentrow#">
                                                                    <a href="javascript://" style="text-align:center; width:20px" onclick="sil3('#currentrow#');"><i class="fa fa-minus"></i></a>
                                                                </td>
                                                                <td><input type="text" name="prom_no#currentrow#" id="prom_no#currentrow#" class="text" readonly value="#prom_no#"></td>
                                                                <td nowrap="nowrap">
                                                                    <div class="input-group">
                                                                        <input type="hidden" name="promotion_id#currentrow#" id="promotion_id#currentrow#" value="#related_prom_id#">
                                                                        <input type="text" name="promotion_name#currentrow#" id="promotion_name#currentrow#" class="text"  readonly value="#prom_head#">
                                                                        <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_promotions&prom_id=add_prom.promotion_id#currentrow#&prom_head=add_prom.promotion_name#currentrow#&prom_no=add_prom.prom_no#currentrow#');"></span>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </cfoutput>
                                                    </tbody>
                                                </cf_grid_list>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-6 col-xs-12">
                                <div class="row">
                                    <div class="col col-12">
                                        <div class="form-group" id="item-kazanc_baslik">
                                            <label class="bold"><cf_get_lang dictionary_id='37521.Kazanç'></label>
                                        </div>
                                    </div>
                                    <div class="col col-12">
                                        <div class="form-group" id="item-catalog_id">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37216.Katalog'></label>
                                            <div class="col col-8 col-xs-12">
                                                <div class="input-group">
                                                    <cfif len(get_prom.catalog_id)>
                                                        <cfquery name="get_catalog" datasource="#DSN3#">
                                                            SELECT CATALOG_ID,CATALOG_HEAD FROM CATALOG_PROMOTION WHERE CATALOG_ID = #get_prom.catalog_id#
                                                        </cfquery>
                                                    </cfif>					
                                                    <input type="hidden" name="catalog_id" id="catalog_id" value="<cfif len(get_prom.catalog_id)><cfoutput>#get_prom.catalog_id#</cfoutput></cfif>">
                                                    <input type="text" name="catalog_name" id="catalog_name" value="<cfif len(get_prom.catalog_id)><cfoutput>#get_catalog.catalog_head#</cfoutput></cfif>" >
                                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_catalog_promotion</cfoutput>&field_id=add_prom.catalog_id&field_name=add_prom.catalog_name');"></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-product_benefit_count">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37533.Toplam Adet'></label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="text" name="product_benefit_count" id="product_benefit_count" value="<cfoutput>#get_prom.total_discount_amount#</cfoutput>" onkeyup="isNumber(this);"  class="moneybox">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-prom_action_type">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37534.Hareket Tipi'></label>
                                            <div class="col col-8 col-xs-12">
                                                <select name="prom_action_type" id="prom_action_type" >
                                                    <option value="1" <cfif get_prom.prom_action_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='57582.Ekle'></option>
                                                    <option value="2" <cfif get_prom.prom_action_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='37535.Değiştir'></option>
                                                    <option value="3" <cfif get_prom.prom_action_type eq 3>selected</cfif>><cf_get_lang dictionary_id ='37546.Ekle veya Değiştir'></option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-parapuan_percent">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='40902.Parapuan Yüzdesi'></label>
                                            <div class="col col-8 col-xs-12">
                                                <cfif len(get_prom.MONEY_CREDIT)>																					
                                                    <cfinput type="text" name="parapuan_percent" onKeyUp="isNumber(this);" value="#get_prom.MONEY_CREDIT#" class="moneybox">
                                                <cfelse>
                                                    <cfinput type="text" name="parapuan_percent" onKeyUp="isNumber(this);" value="" class="moneybox">
                                                </cfif>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-valid_day">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='40905.Parapuan Geçerlilik Tarihi'></label>
                                            <div class="col col-8 col-xs-12">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='60480.Lütfen Parapuan Geçerlilik Günü Giriniz'> !</cfsavecontent>																				
                                                <cfinput type="text" name="valid_day" message="#message#" value="#get_prom.valid_day#" onKeyUp="isNumber(this);" class="moneybox">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-prom_benefit_status">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37640.Liste Çalışma Şekli'></label>
                                            <div class="col col-4 col-xs-12">
                                                <label><input type="checkbox" name="prom_benefit_status_and" id="prom_benefit_status_and" value="1" onclick="check_benefit_status(1);" <cfif get_prom.list_work_type eq 1>checked</cfif>><cf_get_lang dictionary_id ='37669.Listedeki Tüm Ürünler'></label>
                                            </div>
                                            <div class="col col-4 col-xs-12">
                                                <label><input type="checkbox" name="prom_benefit_status_or" id="prom_benefit_status_or" value="1" onclick="check_benefit_status(2);" <cfif get_prom.list_work_type eq 0>checked</cfif>><cf_get_lang dictionary_id ='37670.Ürünlerden Herhangi Biri'></label>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-is_other_prom_act">
                                            <label class="col col-12"><input type="checkbox" name="is_other_prom_act" id="is_other_prom_act" value="1" <cfif get_prom.product_promotion_noneffect eq 1>checked</cfif>><cf_get_lang dictionary_id ='37553.Bu Ürünler Diğer Promosyonları Etkilemez'></label>
                                        </div>
                                        <div class="form-group" id="item-is_only_same_product">
                                            <label class="col col-12"><input type="checkbox" name="is_only_same_product" id="is_only_same_product" value="1" <cfif get_prom.only_same_product eq 1>checked</cfif>><cf_get_lang dictionary_id ='37584.Sadece Aynı Ürünü Ekle'></label>
                                        </div>
                                    </div>
                                </div>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58942.Ürün Listesi'></cfsavecontent>
                                <cf_seperator title="#message#" id="urun_liste2_">
                                <div style="position:absolute; margin-left:5px; margin-top:25px;" id="open_process"></div>
                                <div class="form-group" id="item-urun-list">
                                    <cf_grid_list class="workDevList" id="urun_liste2_">
                                        <thead>
                                            <tr>
                                                <th style="text-align:center; width:30px">
                                                    <a onclick="open_process_row();" style="cursor:pointer;"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='37697.Hızlı Ürün Ekle'>" align="absmiddle"></i></a>
                                                </th>
                                                <th style="text-align:center; width:30px">
                                                    <input type="hidden" name="record_num1" id="record_num1" value="<cfoutput>#get_prom_products.recordcount#</cfoutput>">
                                                    <a onclick="add_product();" style="cursor:pointer;"><i class="fa fa-plus"  title="<cf_get_lang dictionary_id='29410.Ürün Ekle'>" align="absmiddle"></i></a>
                                                </th>
                                                <th class="txtbold" width="60"><cfif isdefined("is_product_code_2") and is_product_code_2 eq 1><cf_get_lang dictionary_id='57789.Özel Kod'><cfelse><cf_get_lang dictionary_id='57518.Stok Kodu'></cfif></th>
                                                <th class="txtbold" width="120"><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
                                                <th class="txtbold"><cf_get_lang dictionary_id='58258.Maliyet'></th>
                                                <th class="txtbold" width="50"><cf_get_lang dictionary_id='58082.Adet'></th>
                                                <cfif get_pricecat_name.recordcount>
                                                    <th class="txtbold" width="90"><cfoutput>#get_pricecat_name.price_cat#</cfoutput></th>
                                                    <th class="txtbold" width="60" align="center"><cf_get_lang dictionary_id='58456.Oran'>(-)<br/><input name="set_marj" id="set_marj" type="text" class="box" onfocus="this.value='';" onblur="if(this.value.length && filterNum(this.value) > 100) this.value=commaSplit(0);apply_marj();" onkeyup="return(FormatCurrency(this,event,2));" value="0,00" autocomplete="off"></th>
                                                </cfif>
                                                <th class="txtbold" width="50"><cf_get_lang dictionary_id='58084.Fiyat'></th>
                                                <th class="txtbold" width="50"><cf_get_lang dictionary_id='37720.Silinemez'></th>
                                            </tr>
                                        </thead>
                                        <tbody id="table_product">
                                            <cfoutput query="get_prom_products">
                                                <tr id="frm_row_product#currentrow#">
                                                    <td></td>
                                                    <td>
                                                        <input  type="hidden" value="1" name="row_kontrol1#currentrow#" id="row_kontrol1#currentrow#"><a href="javascript://" style="text-align:center; width:20px"  onclick="sil1('#currentrow#');">
                                                        <i class="fa fa-minus"></i></a>
                                                    </td>
                                                    <td><input type="text" name="stock_code#currentrow#" id="stock_code#currentrow#" class="text" readonly value="#product_code#"></td>
                                                    <td><div class="input-group">
                                                        <input  type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
                                                        <input  type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#stock_id#">
                                                        <input name="product_name#currentrow#" id="product_name#currentrow#" type="text" class="text"  onfocus="AutoComplete_Create('product_name#currentrow#','<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>STOCK_CODE_2<cfelse>STOCK_CODE</cfif>,PRODUCT_NAME','<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>STOCK_CODE_2<cfelse>STOCK_CODE</cfif>,PRODUCT_NAME','get_product_autocomplete',0,'PRODUCT_ID,STOCK_ID,PRODUCT_NAME<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>,STOCK_CODE_2<cfelse>,STOCK_CODE</cfif>,PRODUCT_COST<cfif get_pricecat_name.recordcount>,PROFIT_MARGIN</cfif>','product_id#currentrow#,stock_id#currentrow#,product_name#currentrow#,stock_code#currentrow#,product_cost#currentrow#<cfif get_pricecat_name.recordcount>,marj_value#currentrow#</cfif>','add_prom',3,270,'change_cost(#currentrow#)');" value="#product_name#" autocomplete="off">
                                                        <span class="inğut-group-addon icon ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names&product_id=add_prom.product_id#currentrow#<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>&field_code2=add_prom.stock_code#currentrow#<cfelse>&field_code=add_prom.stock_code#currentrow#</cfif>&field_name=add_prom.product_name#currentrow#&field_product_cost=add_prom.product_cost#currentrow#&field_id=add_prom.stock_id#currentrow#<cfif get_pricecat_name.recordcount>&field_profit_margin=add_prom.marj_value#currentrow#</cfif>');"></a></div>
                                                    </td>
                                                    <td><input type="text" name="product_cost#currentrow#" id="product_cost#currentrow#" class="moneybox" readonly value="#tlformat(product_cost)#"></td>
                                                    <td><input type="text" name="product_amount#currentrow#" id="product_amount#currentrow#" class="moneybox" value="#product_amount#" onkeyup="isNumber(this);"></td>
                                                    <cfif get_pricecat_name.recordcount>
                                                        <td><input type="text" name="product_price_other#currentrow#" id="product_price_other#currentrow#" class="moneybox"  value="#tlformat(product_price_other_list)#" onkeyup="return(FormatCurrency(this,event));" onblur="hesapla(#currentrow#,1);"></td>
                                                        <td><input type="text" name="marj_value#currentrow#" id="marj_value#currentrow#" class="moneybox" value="<cfif len(margin)>#tlformat(margin)#<cfelse>#tlformat(0)#</cfif>" onkeyup="return(FormatCurrency(this,event));" onblur="if(this.value.length && filterNum(this.value) > 100) this.value=commaSplit(0);hesapla(#currentrow#,1);"></td>
                                                    </cfif>
                                                    <td><input type="text" name="product_price#currentrow#" id="product_price#currentrow#" class="moneybox"  value="#tlformat(product_price)#" onkeyup="return(FormatCurrency(this,event));" onblur="hesapla(#currentrow#,2);"></td>
                                                    <td align="center"><input type="checkbox" name="is_nondelete#currentrow#" id="is_nondelete#currentrow#" value="1" <cfif is_nondelete_product eq 1>checked</cfif>></td>
                                                </tr>
                                            </cfoutput>
                                        </tbody>
                                    </cf_grid_list>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 bold"><cf_get_lang dictionary_id="37485.Ödeme Yöntemleri"></label>
                                    <div class="col col-12">
                                        <select name="credit_pay_types" id="credit_pay_types" multiple >
                                            <cfoutput query="get_credit_types">
                                                <option value="#payment_type_id#" <cfif len(get_prom.credit_pay_types) and listfind(get_prom.credit_pay_types,payment_type_id)>selected</cfif>>#card_no#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
            </div> 
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58029.İkon'></cfsavecontent>
            <cf_seperator title="#message#" id="ikon_">                
            <div class="row" type="row">
                <div class="col col-12" type="column" sort="false" index="5">
                    <div class="form-group" id="ikon_">
                        <label class="hide"><cf_get_lang dictionary_id='42231.İkonlar'></label>
                        <cfquery name="GET_ICON" datasource="#DSN3#">
                            SELECT * FROM SETUP_PROMO_ICON 
                        </cfquery>
                        <input type="radio" name="icon_id" id="icon_id" value="" <cfif len(get_prom.icon_id)>checked</cfif>>
                        <cf_get_lang dictionary_id='37653.Boş'>
                        <cfoutput query="get_icon">
                            <input type="radio" name="icon_id" id="icon_id" value="#icon_id#" <cfif get_prom.icon_id eq icon_id>checked</cfif>>
                            <cfif len(get_icon.icon_server_id)>
                                <cf_get_server_file output_file="sales/#icon#" output_server="#icon_server_id#" output_type="0" image_height="25">
                            <cfelse>
                                <cf_get_lang dictionary_id='37653.Boş'>
                            </cfif>
                        </cfoutput>
                    </div>
                </div>
            </div>
            <cf_box_footer>
                <div class="col col-6 col-xs-12"><cf_record_info query_name="get_prom"></div>
                    <div class="col col-6 col-xs-12">
                        <cfif isdefined("is_copy")>
                            <cf_workcube_buttons is_upd='0' add_function='form_kontrol()'>
                        <cfelse>
                            <cf_workcube_buttons is_upd='1' add_function='form_kontrol()' delete_page_url='#request.self#?fuseaction=product.emptypopup_del_detail_prom&prom_id=#get_prom.prom_id#&head=#get_prom.prom_head#'>
                        </cfif>
                    </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	var row_count= 0;
	var row_count1 = <cfoutput>#get_prom_products.recordcount#</cfoutput>;
	function control_member()
	{
		if(document.add_prom.consumer_ref_prom.checked == true)
		{
			document.getElementById('member_td_1').style.display='';
			document.getElementById('member_td_2').style.display='';
		}
		else
		{
			document.getElementById('member_td_1').style.display='none';
			document.getElementById('member_td_2').style.display='none';
		}
	}
	function del_condition(row_id)
	{	
		document.getElementById('condition'+row_id).style.display = 'none';
		document.getElementById('row_control_prom_'+row_id).value=0;
	}
	function add_condition(prom_condition_id)
	{	
		if(prom_condition_id == undefined)
			prom_condition_id = 0;
		row_count+=1;
		$('#record_num').val(row_count);
		var my_obj = document.createElement('div');
		my_obj.innerHTML='<tr height="25"><td colspan="6"><div id="condition'+row_count+'"></div></td></tr>';
		document.getElementById('table2').appendChild(my_obj);
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=product.emptypopup_form_add_prom_condition&row_id='+row_count+'&prom_condition_id='+prom_condition_id+'</cfoutput><cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>&is_product_code_2=1</cfif>','condition'+row_count+'');
	}
	function sil1(sy)
	{
		var my_element=eval("add_prom.row_kontrol1"+sy);
		my_element.value=0;
		var my_element=eval("frm_row_product"+sy);
		my_element.style.display="none";
	}
	function add_product(product_id,stock_id,product_name,stock_code,page_no)
	{
		if(product_id == undefined)
			product_id = '';
		if(stock_id == undefined)
			stock_id = '';
		if(product_name == undefined)
			product_name = '';
		if(stock_code == undefined)
			stock_code = '';
		if(page_no == undefined)
			page_no = '';
		row_count1++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table_product").insertRow(document.getElementById("table_product").rows.length);
		newRow.setAttribute("name","frm_row_product" + row_count1);
		newRow.setAttribute("id","frm_row_product" + row_count1);
		document.add_prom.record_num1.value=row_count1;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol1'+row_count1+'" value="1"><a style="cursor:hand" style="text-align:center; width:20px"  onclick="sil1(' + row_count1 + ');"><i class="fa fa-minus"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="stock_code' + row_count1 +'" id="stock_code' + row_count1 +'" class="text" readonly value='+stock_code+'>';
		newCell = newRow.insertCell(newRow.cells.length);																																																											
		newCell.innerHTML = '<div class="input-group"><input  type="hidden" name="product_id' + row_count1 +'" id="product_id' + row_count1 +'" value="'+product_id+'"><input type="hidden" name="stock_id' + row_count1 +'" id="stock_id' + row_count1 +'" value="'+stock_id+'"><input type="text" name="product_name' + row_count1 +'" id="product_name' + row_count1 +'" class="text" value="'+product_name+'" onFocus="AutoComplete_Create(\'product_name' + row_count1 +'\',\'<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>STOCK_CODE_2<cfelse>STOCK_CODE</cfif>,PRODUCT_NAME\',\'<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>STOCK_CODE_2<cfelse>STOCK_CODE</cfif>,PRODUCT_NAME\',\'get_product_autocomplete\',0,\'PRODUCT_ID,STOCK_ID,PRODUCT_NAME<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>,STOCK_CODE_2<cfelse>,STOCK_CODE</cfif>,PRODUCT_COST<cfif get_pricecat_name.recordcount>,PROFIT_MARGIN</cfif>\',\'product_id' + row_count1 +',stock_id' + row_count1 +',product_name' + row_count1 +',stock_code' + row_count1 +',product_cost' + row_count1 +'<cfif get_pricecat_name.recordcount>,marj_value' + row_count1 +'</cfif>\',\'add_prom\',3,270,\'change_cost('+row_count1+')\');">'
						+' '+'<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=add_prom.product_id" + row_count1 + "<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>&field_code2=add_prom.stock_code" + row_count1 + "<cfelse>&field_code=add_prom.stock_code" + row_count1 + "</cfif>&field_id=add_prom.stock_id" + row_count1 + "&field_name=add_prom.product_name" + row_count1 + "&field_product_cost=add_prom.product_cost" + row_count1 + "<cfif get_pricecat_name.recordcount>&field_profit_margin=add_prom.marj_value" + row_count1 + "</cfif>');"+'"></span></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="product_cost' + row_count1 +'" id="product_cost' + row_count1 +'" class="moneybox" readonly>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="product_amount' + row_count1 +'" class="moneybox" value="1" onKeyup="isNumber(this);">';
		<cfif get_pricecat_name.recordcount>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="product_price_other' + row_count1 +'" class="moneybox"  value="0" onkeyup="return(FormatCurrency(this,event));" onblur="hesapla(' + row_count1 + ',1);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="marj_value' + row_count1 +'" id="marj_value' + row_count1 +'" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event));" onblur="if(this.value.length && filterNum(this.value) > 100) this.value=commaSplit(0);hesapla(' + row_count1 + ',1);">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="product_price' + row_count1 +'" class="moneybox"  value="0" onkeyup="return(FormatCurrency(this,event));" onblur="hesapla(' + row_count1 + ',2);">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="checkbox" name="is_nondelete' + row_count1 +'" value="1">';
		newCell = newRow.style.textAlign="center";
	}
	function hesapla(row_id,type)
	{
		if(eval('add_prom.product_price_other'+row_id) != undefined)
		{
			if(type == 1)
			{
				satir_deger = filterNum(eval('add_prom.product_price_other'+row_id).value);
				satir_marj = commaSplit((100+filterNum(eval('add_prom.marj_value'+row_id).value))/100);
				if(satir_deger == '') satir_deger = 0;
				eval('add_prom.product_price'+row_id).value = commaSplit(parseFloat(satir_deger) / parseFloat(filterNum(satir_marj)));
			}
			else if(type == 2)
			{
				satir_deger = filterNum(eval('add_prom.product_price'+row_id).value);
				satir_deger_other = filterNum(eval('add_prom.product_price_other'+row_id).value);
				if(satir_deger == '') satir_deger = 0;
				if(satir_deger_other == '') satir_deger_other = 0;
				if(satir_deger != 0)
					marj_value = commaSplit(parseFloat(satir_deger_other) / parseFloat(satir_deger));
				else
					marj_value = 0;
				eval('add_prom.marj_value'+row_id).value = commaSplit(parseFloat(filterNum(marj_value))*100-100);
			}
		}
	}
	function apply_marj()
	{
		for(j=1;j<=add_prom.record_num1.value;j++)
			if(eval("document.add_prom.row_kontrol1"+j).value==1)	
			{
				eval('add_prom.marj_value'+j).value = commaSplit(filterNum(add_prom.set_marj.value));
				hesapla(j,1);
			}
	}
	function open_process_row()
	{
		document.getElementById('open_process').style.display ='';
		document.getElementById('open_process').style.visibility ='';
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=product.emptypopup_form_add_prom_benefit_product&catalog_id='+document.add_prom.catalog_id.value+'</cfoutput><cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>&is_product_code_2=1</cfif>','open_process',1);
	}
	function change_cost(row_id)
	{
		if(eval('document.add_prom.product_cost'+row_id).value != "")
			eval('document.add_prom.product_cost'+row_id).value = commaSplit(eval('document.add_prom.product_cost'+row_id).value);
	}
	function check_condition_status(kont)
	{
		if(kont==1)
		{
			if(document.getElementById('prom_condition_status_and').checked == true)
				document.getElementById('prom_condition_status_or').checked = false;
		}
		else
		{
			if(document.getElementById('prom_condition_status_or').checked == true)
				document.getElementById('prom_condition_status_and').checked = false;
		}
	}
	function check_benefit_status(kont)
	{
		if(kont==1)
		{
			if(document.getElementById('prom_benefit_status_and').checked == true)
				document.getElementById('prom_benefit_status_or').checked = false;
		}
		else
		{
			if(document.getElementById('prom_benefit_status_or').checked == true)
				document.getElementById('prom_benefit_status_and').checked = false;
		}
	}
	function unformat_fields()
	{
		for(r=1;r<=add_prom.record_num.value;r++)
		{
			eval("document.getElementById('product_amount_"+r+"')").value = filterNum(eval("document.getElementById('product_amount_"+r+"')").value);
			//eval("document.getElementById('total_product_amount_2_"+r+"')").value = filterNum(eval("document.getElementById('total_product_amount_2_"+r+"')").value);
  		}
		
		for(r=1;r<=add_prom.record_num1.value;r++)
		{
			eval("document.add_prom.product_cost"+r).value = filterNum(eval("document.add_prom.product_cost"+r).value);
			eval("document.add_prom.product_price"+r).value = filterNum(eval("document.add_prom.product_price"+r).value);
			if(eval("document.add_prom.marj_value"+r) != undefined)
			{
				eval("document.add_prom.marj_value"+r).value = filterNum(eval("document.add_prom.marj_value"+r).value);
				eval("document.add_prom.product_price_other"+r).value = filterNum(eval("document.add_prom.product_price_other"+r).value);
			}
		}
	}	
	function form_kontrol()
	{
		if(add_prom.is_only_same_product.checked == true && add_prom.prom_benefit_status_or.checked == true)
		{
			alert("<cf_get_lang dictionary_id ='37762.Kazanç Bölümünde Sadece Aynı Ürünü Ekle ve Veya Seçeneklerini Birlikte Seçemezsiniz'>!");
			return false;
		}
		if(add_prom.condition_price_catid.value != '' && add_prom.prom_type.value == 2)
		{
			alert("<cf_get_lang dictionary_id ='37777.Çalışma Şekli Dönemsel İse Hesaplanacak Fiyat Listesi Seçemezsiniz'>!");
			return false;
		}
		if(add_prom.condition_price_catid.value == '' && add_prom.prom_type.value == 0)
		{
			alert("<cf_get_lang dictionary_id ='37791.Çalışma Şekli Sipariş İse Hesaplanacak Fiyat Listesi Seçmelisiniz'>!");
			return false;
		} 
		unformat_fields();
		if(time_check(add_prom.startdate, add_prom.start_clock, add_prom.start_minute, add_prom.finishdate,  add_prom.finish_clock, add_prom.finish_minute, "<cf_get_lang dictionary_id ='37849.Promosyon Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'>!"))
			return process_cat_control();
		else
			return false;
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
	var row_count3= <cfoutput>#get_prom_related.recordcount#</cfoutput>;
	function sil3(sy)
	{
		var my_element=eval("add_prom.row_kontrol3"+sy);
		my_element.value=0;
		var my_element=eval("frm_row3"+sy);
		my_element.style.display="none";
	}
	function add_row3()
	{
		row_count3++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table3").insertRow(document.getElementById("table3").rows.length);	
		newRow.setAttribute("name","frm_row3" + row_count3);
		newRow.setAttribute("id","frm_row3" + row_count3);
		document.add_prom.record_num3.value=row_count3;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol3'+row_count3+'" value="1"><a style="cursor:hand" style="text-align:center; width:20px" onclick="sil3(' + row_count3 + ');"><i class="fa fa-minus"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="prom_no' + row_count3 +'" class="text" readonly>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="input-group"><input  type="hidden" name="promotion_id' + row_count3 +'" ><input type="text" name="promotion_name' + row_count3 +'" class="text"  readonly>'
						+' '+'<span class="input-group-addon icon-ellipsis" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_list_promotions&prom_id=add_prom.promotion_id" + row_count3 + "&prom_head=add_prom.promotion_name" + row_count3 + "&prom_no=add_prom.prom_no" + row_count3 + "</cfoutput>','small');"+'"></span></div>';
	}
	function check_prom(kont)
	{
		if(kont==1)
		{
			if(document.add_prom.is_prom_and.checked == true)
				document.add_prom.is_prom_or.checked = false;
		}
		else
		{
			if(document.add_prom.is_prom_or.checked == true)
				document.add_prom.is_prom_and.checked = false;
		}
	}
</script>

