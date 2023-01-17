<cfset xml_page_control_list = 'is_conscat_segmentation,is_conscat_premium,is_product_code_2,other_price_cat'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="0" fuseact="product.form_upd_detail_prom">
<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_price_cats.cfm">
<cfinclude template="../../member/query/get_member_add_options.cfm">
<!--- Sadece aktif kategorilerin gelmesi için --->
<cfset attributes.is_active_consumer_cat = 1>
<cfinclude template="../query/get_consumer_cat.cfm">
<cfif isdefined("other_price_cat") and len(other_price_cat)>
	<cfquery name="GET_PRICECAT_NAME" dbtype="query">
		SELECT PRICE_CAT FROM GET_PRICE_CATS WHERE PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#other_price_cat#">
	</cfquery>
<cfelse>
	<cfset get_pricecat_name.recordcount = 0>
</cfif>
<cfif isdefined("attributes.camp_id")>
	<cfquery name="GET_CAMP_INFO" datasource="#DSN3#">
		SELECT CAMP_HEAD,CAMP_ID,CAMP_STARTDATE,CAMP_FINISHDATE FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#">
	</cfquery>
	<cfset camp_start = date_add("H",session.ep.time_zone,get_camp_info.camp_startdate)>
	<cfset camp_finish = date_add("H",session.ep.time_zone,get_camp_info.camp_finishdate)>
	<cfset camp_start_date=date_add("H",session.ep.time_zone,get_camp_info.camp_startdate)>
	<cfset camp_start_hour=datepart("H",camp_start_date)>
	<cfset camp_start_minute=datepart("N",camp_start_date)>
	<cfset camp_finish_date=date_add("H",session.ep.time_zone,get_camp_info.camp_finishdate)>
	<cfset camp_finish_hour=datepart("H",camp_finish_date)>
	<cfset camp_finish_minute=datepart("N",camp_finish_date)>
	<cfset camp_id = get_camp_info.camp_id>
	<cfset camp_head = '#get_camp_info.camp_head#(#dateformat(camp_start,dateformat_style)#-#dateformat(camp_finish,dateformat_style)#)'>
<cfelse>
	<cfset camp_start = ''>
	<cfset camp_finish = ''>
	<cfset camp_id = ''>
	<cfset camp_head = ''>
	<cfset camp_start_date=''>
	<cfset camp_start_hour=''>
	<cfset camp_start_minute=''>
	<cfset camp_finish_date=''>
	<cfset camp_finish_hour=''>
	<cfset camp_finish_minute=''>
</cfif>
<cfquery name="GET_CREDIT_TYPES" datasource="#DSN3#">
	SELECT PAYMENT_TYPE_ID,CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE ISNULL(IS_PROM_CONTROL,0) = 1
</cfquery>
<cfquery name="get_category" datasource="#dsn#">
	SELECT MEMBER_ADD_OPTION_ID,MEMBER_ADD_OPTION_NAME FROM SETUP_MEMBER_ADD_OPTIONS ORDER BY MEMBER_ADD_OPTION_NAME
</cfquery>
<cf_papers paper_type="promotion">
<cfset system_paper_no = paper_code & '-' & paper_number>
<cfset system_paper_no_add = paper_number>
<cfset pageHead = #getLang('main',1373)# & " " & #getLang('product',543)#>
<cf_catalystHeader>
<cfform name="add_prom" method="post" action="#request.self#?fuseaction=product.emptypopup_add_detail_prom">
    <div class="row">
    	<div class="col col-12 uniqueRow">
    		<div class="row formContent">
    			<div class="row" type="row">
    				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                    	<div class="form-group" id="item-prom_head">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58820.Başlık'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58059.Başlık Girmelisiniz'> !</cfsavecontent>
                                <cfinput type="text" name="prom_head" id="prom_head" value="" maxlength="100" required="yes" message="#message#" style="width:160px;">
                            </div>
                        </div>
                        <div class="form-group" id="item-system_paper_no">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57487.No'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="system_paper_no" id="system_paper_no" style="width:160px;" value="<cfoutput>#system_paper_no#</cfoutput>" maxlength="50">
                                <input type="hidden" name="system_paper_no_add" id="system_paper_no_add" value="<cfoutput>#system_paper_no_add#</cfoutput>" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-detail_prom_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37488.Promosyon Tipi'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="detail_prom_type" id="detail_prom_type" style="width:160px;">
                                    <option value="1"><cf_get_lang dictionary_id ='37286.Katalog Promosyonu'></option>
                                    <option value="2"><cf_get_lang dictionary_id ='37287.Temsilci Programı'></option>
                                    <option value="3"><cf_get_lang dictionary_id ="37211.Kredi Kartı Promosyonu"></option>
                                    <option value="4"><cf_get_lang dictionary_id ="37212.Kargo Promosyonu"></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-process">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process is_upd='0' process_cat_width='160' is_detail='0'>
                            </div>
                        </div>
                        <div class="form-group" id="item-price_catid">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37303.Geçerli Fiyat Listesi'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="price_catid" id="price_catid" style="width:160px;">
									<cfoutput query="get_price_cats">
                                        <option value='#price_catid#'>#price_cat#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-condition_price_catid">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37338.Hesaplanacak Fiyat Listesi'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="condition_price_catid" id="condition_price_catid" style="width:160px;">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_price_cats">
                                        <option value='#price_catid#'>#price_cat#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-reference_code">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37361.Referans Kodu'></label>
                            <div class="col col-8 col-xs-12">
								<input type="text" name="reference_code" id="reference_code" style="width:160px;" maxlength="150">
                            </div>
                        </div>
                        <div class="form-group" id="item-control_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37385.Bekleyen Sipariş Kontrol Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='37389.Kontrol Tarihi Girmelisiniz'> !</cfsavecontent>
                                    <cfinput type="text" name="control_date" id="control_date" validate="#validate_style#" message="#message#" style="width:65px;">
                                    <span class="input-group-addon btnPointer" onclick=""><cf_wrk_date_image date_field="control_date"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
                        <div class="form-group" id="item-startdate">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57501.Başlangıç"> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Baslangiç Tarihi Girmelisiniz'> !</cfsavecontent>
									<cfif len(camp_start_date)>
                                        <cfinput type="text" name="startdate" id="startdate" required="Yes" validate="#validate_style#" message="#message#" style="width:65px;" value="#dateformat(camp_start_date,dateformat_style)#">
                                    <cfelse>
                                        <cfinput type="text" name="startdate" id="startdate" required="Yes" validate="#validate_style#" message="#message#" style="width:65px;">
                                    </cfif>
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
                                    <span class="input-group-addon">
                                    <cf_wrkTimeFormat name="start_clock" value="00">	
                                    </span>
                                    <span class="input-group-addon">
                                        <select name="start_minute" id="start_minute">
                                            <cfloop from="00" to="55" index="i" step="5">
                                                <option value="<cfoutput>#numberformat(i,00)#</cfoutput>" <cfif camp_start_minute eq i>selected</cfif>><cfoutput>#numberformat(i,00)#</cfoutput></option>
                                            </cfloop>
                                        </select>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-finishdate">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'> !</cfsavecontent>
									<cfif len(camp_finish_date)>
                                        <cfinput type="text" name="finishdate" id="finishdate" required="Yes" validate="#validate_style#" message="#message#" style="width:65px;" value="#dateformat(camp_finish_date,dateformat_style)#">
                                    <cfelse>
                                        <cfinput type="text" name="finishdate" id="finishdate" required="Yes" validate="#validate_style#" message="#message#" style="width:65px;">
                                    </cfif>
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
                                    <span class="input-group-addon">
                                         <cf_wrkTimeFormat name="finish_clock" value="#numberformat(camp_finish_hour,00)#">
                                    </span>
                                    <span class="input-group-addon">
                                        <select name="finish_minute" id="finish_minute">
                                            <cfloop from="0" to="55" index="i" step="5">
                                                <option value="<cfoutput>#numberformat(i,00)#</cfoutput>" <cfif camp_finish_minute eq i>selected</cfif>><cfoutput>#numberformat(i,00)#</cfoutput></option>
                                            </cfloop>
                                        </select>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-prom_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37488.Promosyon Tipi'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="prom_type" id="prom_type" style="width:169px;">
                                    <option value="0"><cf_get_lang dictionary_id ='57611.Sipariş'></option>
                                    <option value="2"><cf_get_lang dictionary_id ='37301.Dönemsel'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-camp_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="camp_id" id="camp_id" value="<cfif len(camp_id)><cfoutput>#camp_id#</cfoutput></cfif>">
                                    <input type="text" name="camp_name" id="camp_name" value="<cfif len(camp_head)><cfoutput>#camp_head#</cfoutput></cfif>" style="width:169px;">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_campaigns</cfoutput>&field_id=add_prom.camp_id&field_name=add_prom.camp_name&field_start_date=add_prom.startdate&field_finish_date=add_prom.finishdate&call_function=add_camp_date','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-work_hierarchy">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37909.Çalışma Sırası'></label>
                            <div class="col col-3 col-xs-12">
                                    <input type="text" name="work_hierarchy" id="work_hierarchy" value="0" onkeyup="isNumber(this);" style="width:50px;" class="moneybox">
                            </div>
                            <div class="col col-5 col-xs-12">
                            	<label>
                                    <input type="checkbox" name="is_prom_warning" id="is_prom_warning" value="1" />
                                    <cf_get_lang dictionary_id ='37308.Promosyon Uyarı Versin'>
                                </label>
                            </div>
                        </div>
                        <div class="form-group" id="item-prom_count">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37339.Çalışma Sayısı'></label>
                            <div class="col col-3 col-xs-12">
								<input type="text" name="prom_count" id="prom_count" onkeyup="isNumber(this);" style="width:50px;" class="moneybox">
							</div>        
                            <label class="col col-5 col-xs-12">(<cf_get_lang dictionary_id ='37340.Boş Girilirse Sonsuz Sayıda Çalışır'>)</label>
                        </div>
                        <div class="form-group" id="item-consumer_ref_prom">
                            <label class="col col-12">
                            	<cf_get_lang dictionary_id ='37366.Temsilci Öner Programı'>
                            	<input type="checkbox" name="consumer_ref_prom" id="consumer_ref_prom" value="1" onclick="control_member();">
							</label>
                            <div class="col col-12" style="display:none;" id="member_td_1">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37367.Temsilci Sipariş Sayısı'></label>
								<div class="col col-8 col-xs-12"><input type="text" name="member_order_count" id="member_order_count" style="width:50px;" onkeyup="isNumber(this);" class="moneybox"></div>
                            </div>       
                            <div class="col col-12" style="display:none;" id="member_td_2">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37421.Temsilci Kayıt Sırası'></label>
                                <div class="col col-8 col-xs-12"><input type="text" name="member_line_order" id="member_line_order" style="width:50px;" onkeyup="isNumber(this);" class="moneybox"></div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
                    	<div class="form-group" id="item-prom_detail">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                            	<textarea name="prom_detail" id="prom_detail" style="width:228px;height:42px;"></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-kamp_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
                            <div class="col col-8 col-xs-12">
								<cfoutput>
                                    <select name="kamp_type" id="kamp_type" multiple style="width:228px;">
                                        <cfloop from="1" to="10" index="kk">
                                            <option value="#kk#">#kk#.<cf_get_lang dictionary_id='57446.Kampanya'></option>
                                        </cfloop>								
                                    </select>
                                </cfoutput>
                            </div>
                        </div>
                        <div class="form-group" id="item-checkboxes">
                        	<div class="col col-12">
                                <label>
                                    <cf_get_lang dictionary_id ='37310.Zorunlu Promosyon'>
                                    <input type="checkbox" name="is_required_prom" id="is_required_prom" value="1">
                                </label>
                                <label>
                                    <cf_get_lang dictionary_id ='37322.Sadece İlk Siparişte Çalışsın'>
                                    <input type="checkbox" name="first_order" id="first_order" value="1">
                                </label>
                                <label>
                                    <cf_get_lang dictionary_id ='58515.Aktif/Pasif'>
                                    <input type="checkbox" name="prom_status" id="prom_status" value="1" checked>
                                </label>
                                <label>
                                    <cf_get_lang dictionary_id ='37359.İnternette Göster'>
                                    <input type="checkbox" name="is_internet" id="is_internet" value="1">
                                </label>
                                <label>
                                    <cf_get_lang dictionary_id ='37371.Bekleyen Siparişe Alınan Ürünler Promosyona Dahil Olsun'>
                                    <input type="checkbox" name="is_demand_products" id="is_demand_products" value="1">
                                </label>
                                <label>
                                    <cf_get_lang dictionary_id ='37437.Bekleyen Siparişten Gelen Ürünler Promosyona Dahil Olsun'>
                                    <input type="checkbox" name="is_demand_order_products" id="is_demand_order_products" value="1">
                                </label>
                                <label>
                                    <cf_get_lang dictionary_id="37214.İadeler Promosyondan Düşülsün">
                                    <input type="checkbox" name="drp_rtr_from_prom" id="drp_rtr_from_prom"value="1">
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='37448.Koşullar ve Kazanç'></cfsavecontent>
                <cf_seperator title="#message#" id="kosullar_ve_kazanc_">
                <div class="row" id="kosullar_ve_kazanc_" type="row">
                	<div class="col col-12" type="column" sort="false" index="4">
                    	<div class="row">
                        	<div class="col col-6 col-xs-12">
                                <div id="table2">
                                	<div class="row" id="table1">
                                    	<div class="col col-12 bg-yellow-saffron font-white padding-bottom-5">
                                        	<div class="form-group" id="item-kosullar_baslik">
                                            	<label class="hide"><cf_get_lang dictionary_id='37382.Koşullar'> <cf_get_lang dictionary_id='58820.Başlık'></label>
                                                <a onclick="add_condition();" style="cursor:pointer;"><img src="images/plus_list.gif" title="<cf_get_lang dictionary_id ='37460.Koşul Ekle'>" align="absmiddle" style="cursor:hand;"></a>&nbsp;<label for="" class="bold" ><cf_get_lang dictionary_id ='37382.Koşullar'></label>
                                            </div>
                                        </div>
                                        <div class="col col-12">
                                        	<div class="form-group" id="item-prom_condition_status">
                                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37509.Koşul Çalışma Şekli'></label>
                                                <div class="col col-8 col-xs-12">
                                                    <label><input type="checkbox" name="prom_condition_status_and" id="prom_condition_status_and" value="1" onclick="check_condition_status(1);" checked><cf_get_lang dictionary_id='57989.Ve'></label>
                                                    <label><input type="checkbox" name="prom_condition_status_or" id="prom_condition_status_or" value="1" onclick="check_condition_status(2);"><cf_get_lang dictionary_id ='57998.Veya'></label>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-is_prom">
                                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37519.Promosyon Çalışma Şekli'></label>
                                                <div class="col col-8 col-xs-12">
                                                    <label><input type="checkbox" name="is_prom_and" id="is_prom_and" value="1" onclick="check_prom(1);" checked> <cf_get_lang dictionary_id ='57989.Ve'></label>
                                                    <label><input type="checkbox" name="is_prom_or" id="is_prom_or" value="1" onclick="check_prom(2);"><cf_get_lang dictionary_id ='57998.Veya'></label>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-consumer_category" param="settings.form_add_consumer_categories">
                                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></label>
                                                <div class="col col-8 col-xs-12">
                                                    <select name="consumer_category" id="consumer_category" style="width:150px;height:80px;" multiple>
														<cfoutput query="get_consumer_cat">
                                                            <option value="#conscat_id#">#conscat#</option>
                                                        </cfoutput>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-member_add_option">
                                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="37329.Üye Özel Tanımı"></label>
                                                <div class="col col-8 col-xs-12">
                                                    <select name="member_add_option" id="member_add_option" style="width:150px;height:80px;" multiple>
														<cfoutput query="get_member_add_options">
                                                            <option value="#member_add_option_id#">#member_add_option_name#</option>
                                                        </cfoutput>
                                                    </select>
                                                </div>
                                            </div>
                                            <input type="hidden" name="record_num" id="record_num" value="0">
											<div id="condition" style="display:none;"></div>
                                        </div>
                                    </div>
                                </div>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='37520.Promosyon Listesi'></cfsavecontent>
                                <cf_seperator title="#message#" id="promosyon_listesi_">
                                <div class="form-group" id="item-promotion_list">
                                	<label class="hide"><cf_get_lang dictionary_id='37520.Promosyon Listesi'></label>
                                	<div class="col col-8">
                                        <div id="promosyon_listesi_">
                                            <div id="promotion">
                                                <table class="workDevList">
                                                    <thead>
                                                        <tr>
                                                            <input type="hidden" name="record_num3" id="record_num3" value="0">
                                                            <th style="width:10px;"><a style="cursor:pointer" onclick="add_row3();"><img src="images/plus_list.gif" border="0"></a></th>
                                                            <th style="width:60px;" nowrap class="txtbold"><cf_get_lang dictionary_id="57487.No"></th>
                                                            <th style="width:160px;" nowrap class="txtbold"><cf_get_lang dictionary_id ='37592.Promosyon Başlığı'></th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="table3" name="table3"></tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                            </div>
                            <div class="col col-6 col-xs-12">
                            	<div class="row">
                                	<div class="col col-12 bg-yellow-saffron font-white padding-bottom-5">
                                    	<div class="form-group" id="item-kazanc_baslik">
                                            <label class="hide"><cf_get_lang dictionary_id='37521.Kazanç'> <cf_get_lang dictionary_id='58820.Başlık'></label>
                                            <label class="bold"><cf_get_lang dictionary_id ='37521.Kazanç'></label>
                                        </div>
                                    </div>
                                    <div class="col col-12">
                                    	<div class="form-group" id="item-catalog_id">
                                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37216.Katalog'></label>
                                            <div class="col col-8 col-xs-12">
                                                <div class="input-group">
                                                    <input type="hidden" name="catalog_id" id="catalog_id" value="">
                                                    <input type="text" name="catalog_name" id="catalog_name" value="" style="width:120px;">
                                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_catalog_promotion&is_applied_info=1</cfoutput>&field_id=add_prom.catalog_id&field_name=add_prom.catalog_name','list');"></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-product_benefit_count">
                                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37533.Toplam Adet'></label>
                                            <div class="col col-8 col-xs-12">
                                            	<input type="text" name="product_benefit_count" id="product_benefit_count" onkeyup="isNumber(this);" style="width:120px;" class="moneybox">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-prom_action_type">
                                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37534.Hareket Tipi'></label>
                                            <div class="col col-8 col-xs-12">
                                            	<select name="prom_action_type" id="prom_action_type" style="width:120px;">
                                                    <option value="1"><cf_get_lang dictionary_id ='57582.Ekle'></option>
                                                    <option value="2"><cf_get_lang dictionary_id ='37535.Değiştir'></option>
                                                    <option value="3"><cf_get_lang dictionary_id ='37546.Ekle veya Değiştir'></option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-parapuan_percent">
                                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='40902.Parapuan Yüzdesi'></label>
                                            <div class="col col-8 col-xs-12">
                                            	<cfinput type="text" name="parapuan_percent" id="parapuan_percent" onKeyUp="isNumber(this);" value="" style="width:40px;" class="moneybox">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-valid_day">
                                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='40905.Parapuan Geçerlilik Tarihi'></label>
                                            <div class="col col-8 col-xs-12">
												<cfsavecontent variable="message"><cf_get_lang dictionary_id='60480.Lütfen Parapuan Geçerlilik Günü Giriniz'> !</cfsavecontent>																				
												<cfinput type="text" name="valid_day" id="valid_day" message="#message#" style="width:40px;" onKeyUp="isNumber(this);" class="moneybox">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-is_other_prom_act">
                                        	<label class="col col-12"><input type="checkbox" name="is_other_prom_act" id="is_other_prom_act" value="1"><cf_get_lang dictionary_id ='37553.Bu Ürünler Diğer Promosyonları Etkilemez'></label>
                                            <label class="col col-12"><input type="checkbox" name="is_only_same_product" id="is_only_same_product" value="1"><cf_get_lang dictionary_id ='37584.Sadece Aynı Ürünü Ekle'></label>
                                        </div>
                                        <div class="form-group" id="item-prom_benefit_status">
                                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37640.Liste Çalışma Şekli'></label>
                                            <div class="col col-8 col-xs-12">
                                            	<label><input type="checkbox" name="prom_benefit_status_and" id="prom_benefit_status_and" value="1" onclick="check_benefit_status(1);" checked><cf_get_lang dictionary_id ='37669.Listedeki Tüm Ürünler'></label>
                                                <label><input type="checkbox" name="prom_benefit_status_or" id="prom_benefit_status_or" value="1" onclick="check_benefit_status(2);"><cf_get_lang dictionary_id ='37670.Ürünlerden Herhangi Biri'> </label>
                                            </div>
                                        </div>
                                    </div>
                                    
                                </div>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58942.Ürün Listesi'></cfsavecontent>
                                <cf_seperator title="#message#" id="urun_liste2_">
                                <div style="position:absolute; margin-left:5px; margin-top:25px;" id="open_process"></div>
                                <div class="form-group" id="item-urun-list">
                                	<table class="workDevList" id="urun_liste2_">
                                    <thead>
                                        <tr>
                                            <th style=" width: 10px; ">
                                                <a onclick="open_process_row();"><img src="images/plus_list.gif" title="<cf_get_lang dictionary_id ='37697.Hızlı Ürün Ekle'>" align="absmiddle" style="cursor:pointer;"></a>&nbsp;
                                            </th>
                                            <th style=" width: 10px; ">
                                                <input type="hidden" name="record_num1" id="record_num1" value="0">
                                                <a onclick="add_product();"><img src="images/plus_list.gif" title="<cf_get_lang dictionary_id='29410.Ürün Ekle'>" align="absmiddle" style="cursor:pointer;"></a>&nbsp;
                                            </th>
                                            <th class="txtbold" width="60"><cfif isdefined("is_product_code_2") and is_product_code_2 eq 1><cf_get_lang dictionary_id='57789.Özel Kod'><cfelse><cf_get_lang dictionary_id='57518.Stok Kodu'></cfif></th>
                                            <th class="txtbold" width="80"><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
                                            <th class="txtbold"><cf_get_lang dictionary_id='58258.Maliyet'></th>
                                            <th class="txtbold" width="50"><cf_get_lang dictionary_id='58082.Adet'></th>
                                            <cfif get_pricecat_name.recordcount>	
                                                <th class="txtbold" width="90"><cfoutput>#get_pricecat_name.price_cat#</cfoutput></th>
                                                <th class="txtbold" width="60" align="center"><cf_get_lang dictionary_id ='58456.Oran'>(-)<br/><input name="set_marj" id="set_marj" type="text" class="box" style="width:30px;" onfocus="this.value='';" onblur="if(this.value.length && filterNum(this.value) > 100) this.value=commaSplit(0);apply_marj();" onkeyup="return(FormatCurrency(this,event,2));" value="0,00" autocomplete="off"></th>
                                            </cfif>
                                            <th class="txtbold" width="50"><cf_get_lang dictionary_id ='58084.Fiyat'></th>
                                            <th class="txtbold" width="50"><cf_get_lang dictionary_id ='37720.Silinemez'></th>
                                        </tr>
                                    </thead>
                                    <tbody id="table_product"></tbody>
                                </table>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 bold"><cf_get_lang dictionary_id="37485.Ödeme Yöntemleri"></label>
                                    <div class="col col-12">
                                        <select name="credit_pay_types" id="credit_pay_types" multiple style="width:150px;height:80px;">
                                            <cfoutput query="get_credit_types">
                                                <option value="#payment_type_id#">#card_no#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58029.İkon'></cfsavecontent>
                <cf_seperator title="#message#" id="ikon_">
                <div class="row" type="row">
                	<div class="col col-12" type="column" sort="false" index="5">
                    	<div class="form-group" id="ikon_">
                        	<label class="hide"><cf_get_lang dictionary_id='42231.İkonlar'></label>
                            <cfquery name="GET_ICON" datasource="#DSN3#">
                                SELECT ICON, ICON_ID, ICON_SERVER_ID FROM SETUP_PROMO_ICON
                            </cfquery>
                            <label class="col col-12">
                                <input type="radio" name="icon_id" id="icon_id" value="" checked>
                                <cf_get_lang dictionary_id='37653.Boş'>
                            </label>
							<cfoutput query="get_icon">
                                <label class="col col-12">
                                    <input type="radio" name="icon_id" id="icon_id" value="#get_icon.icon_id#">
                                    <cfif len(get_icon.icon_server_id)>
                                        <cf_get_server_file output_file="sales/#get_icon.icon#" output_server="#get_icon.icon_server_id#" output_type="0" image_width="65" image_height="20"><br/>
                                    <cfelse>
                                        <cf_get_lang dictionary_id='37653.Boş'><br/>
                                    </cfif>
                                </label>
                            </cfoutput>
                        </div>
                    </div>
                </div>
                <div class="row formContentFooter">
                	<div class="col col-12">
                    	<cf_workcube_buttons is_upd='0' add_function='form_kontrol()'>
                    </div>
                </div>
    		</div>
    	</div>
    </div>
</cfform>
<script type="text/javascript">
	var row_count= 0;
	var row_count1 = 0;
	function control_member()
	{
		if(document.getElementById('consumer_ref_prom').checked == true)
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
		// $('#row_control_prom_'+row_id).val()=0
		document.getElementById('row_control_prom_'+row_id).value=0;
	}
	function add_condition(prom_condition_id)
	{	
		if(prom_condition_id == undefined)
			prom_condition_id = 0;
		row_count+=1;
		$('#record_num').val(row_count);
		//document.getElementById('record_num').value = row_count;
		var my_obj = document.createElement('div');
		my_obj.innerHTML='<tr height="25"><td colspan="6"><div id="condition'+row_count+'"></div></td></tr>';
		document.getElementById('table2').appendChild(my_obj);
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=product.emptypopup_form_add_prom_condition&row_id='+row_count+'&prom_condition_id='+prom_condition_id+'</cfoutput><cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>&is_product_code_2=1</cfif>','condition'+row_count+'');
	}
	function sil1(sy)
	{
		var my_element=eval("document.getElementById('row_kontrol1" + sy + "')");
		my_element.value=0;
		var my_element=eval("frm_row_product"+sy);
		my_element.style.display="none";
	}
	function add_product(product_id,stock_id,product_name,stock_code,page_no,profit_margin)
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
		if(profit_margin == undefined)
			profit_margin = 0;
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
		newCell.innerHTML = '<input type="hidden" name="row_kontrol1'+row_count1+'" id="row_kontrol1'+row_count1+'" value="1"><a style="cursor:pointer" onclick="sil1(' + row_count1 + ');"><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="stock_code' + row_count1 +'" id="stock_code' + row_count1 +'" class="text" style="width:60px;" readonly value='+stock_code+'>';
		newCell.innerHTML = '<input type="text" name="stock_code' + row_count1 +'" id="stock_code' + row_count1 +'" class="text" style="width:60px;" readonly value=' + stock_code + '>';
		newCell = newRow.insertCell(newRow.cells.length);	
		newCell.setAttribute('nowrap','nowrap');																																																										
		newCell.innerHTML = '<div class="input-group"><input  type="hidden" name="product_id' + row_count1 +'" id="product_id' + row_count1 +'"  value="'+product_id+'"><input  type="hidden" name="stock_id' + row_count1 +'" id="stock_id' + row_count1 +'" value="'+stock_id+'"><input type="text" name="product_name' + row_count1 +'" id="product_name' + row_count1 +'" class="text" style="width:100px;" value="'+product_name+'" onFocus="AutoComplete_Create(\'product_name' + row_count1 +'\',\'<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>STOCK_CODE_2<cfelse>STOCK_CODE</cfif>,PRODUCT_NAME\',\'<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>STOCK_CODE_2<cfelse>STOCK_CODE</cfif>,PRODUCT_NAME\',\'get_product_autocomplete\',0,\'PRODUCT_ID,STOCK_ID,PRODUCT_NAME<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>,STOCK_CODE_2<cfelse>,STOCK_CODE</cfif>,PRODUCT_COST<cfif get_pricecat_name.recordcount>,PROFIT_MARGIN</cfif>\',\'product_id' + row_count1 +',stock_id' + row_count1 +',product_name' + row_count1 +',stock_code' + row_count1 +',product_cost' + row_count1 +'<cfif get_pricecat_name.recordcount>,marj_value' + row_count1 +'</cfif>\',\'add_prom\',3,270,\'change_cost('+row_count1+')\');">'
						+' '+'<span class="input-group-addon btnPointer icon-ellipsis no-bg" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=add_prom.product_id" + row_count1 + "<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>&field_code2=add_prom.stock_code" + row_count1 + "<cfelse>&field_code=add_prom.stock_code" + row_count1 + "</cfif>&field_id=add_prom.stock_id" + row_count1 + "&field_name=add_prom.product_name" + row_count1 + "&field_product_cost=add_prom.product_cost" + row_count1 + "<cfif get_pricecat_name.recordcount>&field_profit_margin=add_prom.marj_value" + row_count1 + "</cfif>','list');"+'"></span></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="product_cost' + row_count1 +'" id="product_cost' + row_count1 +'" class="moneybox" style="width:40px;" readonly>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="product_amount' + row_count1 +'" id="product_amount' + row_count1 +'" class="moneybox" style="width:40px;" value="1" onKeyup="isNumber(this);">';
		<cfif get_pricecat_name.recordcount>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="product_price_other' + row_count1 +'" id="product_price_other' + row_count1 +'" class="moneybox" style="width:85px;" value="0" onkeyup="return(FormatCurrency(this,event));" onblur="hesapla(' + row_count1 + ',1);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="marj_value' + row_count1 +'" id="marj_value' + row_count1 +'" class="moneybox" style="width:60px;" value="'+profit_margin+'" onkeyup="return(FormatCurrency(this,event));" onblur="if(this.value.length && filterNum(this.value) > 100) this.value=commaSplit(0);hesapla(' + row_count1 + ',1);">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="product_price' + row_count1 +'" id="product_price' + row_count1 +'" class="moneybox" style="width:50px;" value="0" onkeyup="return(FormatCurrency(this,event));" onblur="hesapla(' + row_count1 + ',2);">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="checkbox" name="is_nondelete' + row_count1 +'" id="is_nondelete' + row_count1 +'" value="1">';
		newCell = newRow.style.textAlign="center";
	}
	function hesapla(row_id,type)
	{
		if(eval('document.getElementById("product_price_other'+row_id+'")') != undefined)
		{
			if(type == 1)
			{
				satir_deger = filterNum(eval('document.getElementById("product_price_other'+row_id+'")').value);
				satir_marj = commaSplit((100+filterNum(eval('document.getElementById("marj_value'+row_id+'"').value))/100);
				if(satir_deger == '') satir_deger = 0;
				eval('document.getElementById("product_price'+row_id+'")').value = commaSplit(parseFloat(satir_deger) / parseFloat(filterNum(satir_marj)));
			}
			else if(type == 2)
			{
				satir_deger = filterNum(eval('document.getElementById("product_price' + row_id + '")').value);
				satir_deger_other = filterNum(eval('document.getElementById("product_price_other' + row_id + '")').value);
				if(satir_deger == '') satir_deger = 0;
				if(satir_deger_other == '') satir_deger_other = 0;
				if(satir_deger != 0)
					marj_value = commaSplit(parseFloat(satir_deger_other) / parseFloat(satir_deger));
				else
					marj_value = 0;
				eval('document.getElementById("marj_value'+row_id+'"').value = commaSplit(parseFloat(filterNum(marj_value))*100-100);
			}
		}
	}
	function apply_marj()
	{
		for(j=1;j<=add_prom.record_num1.value;j++)
			if(eval("document.getElementById('row_kontrol1" + j + "')").value==1)	
			{
				eval('document.getElementById("marj_value'+j+'"').value = commaSplit(filterNum(document.getElementById('set_marj').value));
				hesapla(j,1);
			}
	}
	function open_process_row()
	{
		document.getElementById('open_process').style.display ='';
		document.getElementById('open_process').style.visibility ='';
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=product.emptypopup_form_add_prom_benefit_product<cfif isdefined("is_product_code_2") and is_product_code_2 eq 1>&is_product_code_2=1</cfif>&catalog_id='+document.getElementById('catalog_id').value+'</cfoutput>','open_process',1);
	}
	function change_cost(row_id)
	{
		if(eval('document.getElementById("product_cost'+row_id+'")').value != "")
			eval('document.getElementById("product_cost'+row_id+'")').value = commaSplit(eval('document.getElementById("product_cost'+row_id+'")').value);
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
		/*for(r=1;r<=document.getElementById('record_num').value;r++)
		{    
			eval('document.getElementById("product_amount_'+r+'")').value = filterNum(eval('document.getElementById("product_amount_'+r+'")').value);
			if(eval('document.getElementById("total_product_amount_2_'+r+'")') != undefined)
			eval('document.getElementById("total_product_amount_2_'+r+'")').value = filterNum(eval('document.getElementById("total_product_amount_2_'+r+'")').value);
		}*/
		
		
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
		if(document.getElementById('is_only_same_product').checked == true && document.getElementById('prom_benefit_status_or').checked == true)
		{
			alert("<cf_get_lang dictionary_id ='37762.Kazanç Bölümünde Sadece Aynı Ürünü Ekle ve Veya Seçeneklerini Birlikte Seçemezsiniz'> !");
			return false;
		}
		if($('#condition_price_catid').val() != '' && $('#prom_type').val() == 2)
		{
			alert("<cf_get_lang dictionary_id ='37777.Çalışma Şekli Dönemsel İse Hesaplanacak Fiyat Listesi Seçemezsiniz'> !");
			return false;
		}
		if($('#condition_price_catid').val() == '' && $('#prom_type').val() == 0)
		{
			alert("<cf_get_lang dictionary_id ='37791.Çalışma Şekli Sipariş İse Hesaplanacak Fiyat Listesi Seçmelisiniz'> !");
			return false;
		}
		unformat_fields();
		if(time_check(add_prom.startdate, add_prom.start_clock, add_prom.start_minute, add_prom.finishdate,  add_prom.finish_clock, add_prom.finish_minute, "<cf_get_lang dictionary_id ='37849.Promosyon Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'> !"))
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
	var row_count3= 0;
	function sil3(sy)
	{
		var my_element=eval("document.getElementById('row_kontrol3" + sy + "')");
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
		newCell.innerHTML = '<input type="hidden" name="row_kontrol3'+row_count3+'" id="row_kontrol3'+row_count3+'" value="1"><a style="cursor:pointer" onclick="sil3(' + row_count3 + ');"><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="prom_no' + row_count3 +'" id="prom_no' + row_count3 +'" class="text" style="width:55px;" readonly>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="input-group"><input  type="hidden" name="promotion_id' + row_count3 +'" id="promotion_id' + row_count3 +'" ><input type="text" name="promotion_name' + row_count3 +'" id="promotion_name' + row_count3 +'" class="text" style="width:125px;" readonly>'
						+' '+'<span class="input-group-addon btnPointer icon-ellipsis no-bg" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_list_promotions&prom_id=add_prom.promotion_id" + row_count3 + "&prom_head=add_prom.promotion_name" + row_count3 + "&prom_no=add_prom.prom_no" + row_count3 + "</cfoutput>','small');"+'"></span></div>';
	}
	function check_prom(kont)
	{
		if(kont==1)
		{
			if(document.getElementById('is_prom_and').checked == true)
				document.getElementById('is_prom_or').checked = false;
		}
		else
		{
			if(document.getElementById('is_prom_or').checked == true)
				document.getElementById('is_prom_and').checked = false;
		}
	}
	add_condition();
</script>
