<cfprocessingdirective suppresswhitespace="true">
<cfif isdefined("session.ep") and session.ep.LANGUAGE is 'tr'>
	<cfinclude template="dsp_basket_js_functions_tr.cfm">
<cfelse>
	<cfinclude template="dsp_basket_js_functions.cfm">
</cfif>
<input type="hidden" id="control_field_value" name="control_field_value" value="">
<!--- hesaplama fonskiyonunun calısmasını kontrol etmek icin eklenmiştir. --->
<input type="hidden" id="today_date_" name="today_date_" value="<cfoutput>#now()#</cfoutput>">
<input type="hidden" id="rows_" name="rows_" value="<cfoutput>#ArrayLen(sepet.satir)#</cfoutput>">
<input type="hidden" id="basket_id" name="basket_id" value="<cfoutput>#attributes.basket_id#</cfoutput>">
<input type="hidden" id="sale_product" name="sale_product" value="<cfoutput>#sale_product#</cfoutput>">
<input type="hidden" id="use_basket_project_discount_" name="use_basket_project_discount_" value="<cfoutput>#use_basket_project_discount_#</cfoutput>">
<input type="hidden" id="basket_otv_from_tax_price" name="basket_otv_from_tax_price" value="<cfif listfind(display_list,'otv_from_tax_price')>1<cfelse>0</cfif>">
<input type="hidden" id="basket_price_round_number" name="basket_price_round_number" value="<cfoutput>#price_round_number#</cfoutput>">
<input type="hidden" id="basket_total_round_number_" name="basket_total_round_number_" value="<cfoutput>#basket_total_round_number#</cfoutput>">
<input type="hidden" id="basket_rate_round_number_" name="basket_rate_round_number_" value="<cfoutput>#basket_rate_round_number#</cfoutput>">
<input type="hidden" id="basket_spect_type" name="basket_spect_type" value="<cfif Listfind(display_list,'spec_product_cat_property')>7<cfelse>0</cfif>">
<!--- 7 Numaralı Spect Kullanıyorsa Spect'i satırda seçtiriyoruz,bu değişken onu kontrol ediyor. --->
<input type="hidden" id="is_general_prom" name="is_general_prom" value="<cfif StructKeyExists(sepet,'general_prom_id') or StructKeyExists(sepet,'free_prom_id')>1<cfelse>0</cfif>">
<!--- belge toplamina yapilan promosyon olup olmadigini kontrol ediyoruz --->
<input type="hidden" id="old_general_prom_amount" name="old_general_prom_amount" value="<cfif StructKeyExists(sepet,'general_prom_id') and StructKeyExists(sepet,'general_prom_amount')><cfoutput>#sepet.general_prom_amount#</cfoutput></cfif>">
<!--- genel promosyon indirimi ve fatura indirimi degerlerinin kontrolu için kullanılıyor --->
<cfquery name="basket_info_" datasource="#dsn3#">
SELECT BASKET_INFO_TYPE_ID,BASKET_INFO_TYPE FROM SETUP_BASKET_INFO_TYPES WHERE ','+BASKET_ID+',' LIKE ',%#attributes.basket_id#%,' ORDER BY BASKET_INFO_TYPE
</cfquery>
<cfoutput query="basket_info_">
  <cfset basket_info_list = listappend(basket_info_list,'#BASKET_INFO_TYPE_ID#;#BASKET_INFO_TYPE#')>
</cfoutput>
<cfif fusebox.circuit eq "invoice" or listfind("1,2,3,4,10,14,18,20,21,33,38,42,43,46,51,52",attributes.basket_id,",")>
  <!---sepet.satir altı indirimde kullanılıyor,dikkat : bu satir dsp_basket_total_js.cfm de genel_indirim_ inputu ile iliskili 20040121--->
  <input type="hidden" id="genel_indirim" name="genel_indirim" value="<cfif StructKeyExists(sepet,'genel_indirim')><cfoutput>#sepet.genel_indirim#</cfoutput></cfif>">
</cfif>
<input type="hidden" id="basket_member_pricecat" name="basket_member_pricecat" value="">
<!--- uye fiyat listesini tutar. check_member_price_cat fonksiyonu alanı guncelliyor OZDEN20071018 --->
<cfif listfindnocase(display_list,'shelf_number')>
  <!--- basket satırlarındaki raf bilgilerini getirmek icin eklendiOZDEN20070926 --->
  <cf_wrk_location_shelves form_name='form_basket' shelf_basket_id='#attributes.basket_id#' shelf_field_name="shelf_number_txt" shelf_field_id="shelf_number">
</cfif>
<!--- <div id="sepetim_head"></div> --->
<cfparam name="basket_height" default="250px">
<table id="sepet_table" align="center" cellpadding="0" cellspacing="0" style="table-layout:fixed; width:99%;" <cfif isdefined("attributes.is_basket_hidden") and attributes.is_basket_hidden eq 1>style="display:none;"</cfif>>
	<cfif isdefined('attributes.is_retail') or ListFindNoCase(display_list, "basket_cursor")>
	<tr valign="top" class="sepetim_search" id="sepetim_search">
		<td height="30">
			<iframe name="_add_prod_" id="_add_prod_" frameborder="0" vspace="0" hspace="0" scrolling="no" src="<cfoutput>#request.self#?fuseaction=objects.popup_add_basket_row_from_barcod&amount_round_number=#amount_round#&is_sale_product=#sale_product#&int_basket_id=#attributes.basket_id#<cfloop query="get_money_bskt">&#money_type#=#rate2/rate1#</cfloop></cfoutput>&iframe=1<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>" width="100%" height="30"></iframe>
		</td>
	</tr>
	</cfif>
	<tr valign="top" id="basket_tr"><!--- id surec icin eklendi. Silmeyiniz --->
		<td class="sepetim_td">
           <div id="sepetim"><!--- style koymayiniz --->
                <table id="table_list" class="basket_list" cellpadding="0" cellspacing="0">
                <cfsavecontent variable="basket_headers_clear">
                      <tr height="25"> <cfoutput>
                          <th width="15" id="hidden_fields">&nbsp;</th>
                          <th nowrap width="40" id="basket_header_add" style="text-align:center"><cfif isDefined("session.ep")>
                              <a href="javascript://" onclick="control_comp_selected(0);"><img src="/images/plus_list.gif" border="0" id="basket_header_add_2" title="<cf_get_lang dictionary_id='29410.Ürün Ekle'>"></a>
                              <cfif isdefined("attributes.basket_id") and listfindnocase('7,8',attributes.basket_id)>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_speed_basket','list',basket_unique_code);"><img src="/images/plus_list.gif" border="0" title="<cf_get_lang dictionary_id='52116.Sepete Ekle'>" id="basket_add_product"></a>
                               </cfif>
                            </cfif>
                          </th>
                <cfloop from="1" to="#listlen(display_list,",")#" index="dli">
                <cfset element = ListGetAt(display_list,dli,",")>
                <cfswitch expression="#element#">
                <cfcase value="stock_code">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="pbs_code">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="special_code">
                <th  width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="barcod">
                <th  width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="manufact_code">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="product_name">
                <th  width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="amount">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="unit">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="product_name2">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="amount2">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="unit2">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="spec">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="price">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="list_price">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="list_price_discount">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="tax_price">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="price_other">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="price_net">
                <th  width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="price_net_doviz">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="tax">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="OTV">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="duedate">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#&nbsp;&nbsp;
                <cfif session.ep.duedate_valid eq 0>
                <input type="text" id="set_row_duedate" name="set_row_duedate" value="" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" <cfif listfindnocase(basket_read_only_price_list,'set_row_duedate')>readonly='yes'<cfelse>onBlur="if(this.value.length) apply_duedate(2);"onkeyup="return(FormatCurrency(this,event,0));" onFocus="this.value='';" </cfif> >
                </cfif>
                </th>
                </cfcase>
                <cfcase value="number_of_installment">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="iskonto_tutar">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="ek_tutar">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="ek_tutar_price">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="ek_tutar_cost">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="ek_tutar_marj">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="ek_tutar_other_total">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="disc_ount">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;" title="#ListGetAt(display_field_name_list, dli, ',')#"><input id="set_row_disc_ount1" name="set_row_disc_ount1" type="text" class="boxtext" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" onfocus="this.value='';" onblur="if(this.value.length && filterNumBasket(this.value) <= 100) apply_discount(1);" onkeyup="return(FormatCurrency(this,event,2));" value="0,00" <cfif listfindnocase(basket_read_only_discount_list,'disc_ount')>readonly</cfif> autocomplete="off"></th>
                </cfcase>
                <cfcase value="disc_ount2_">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;" title="#ListGetAt(display_field_name_list, dli, ',')#"><input id="set_row_disc_ount2" name="set_row_disc_ount2" type="text" class="boxtext" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" onfocus="this.value='';" onblur="if(this.value.length && filterNumBasket(this.value) <= 100) apply_discount(2);" onkeyup="return(FormatCurrency(this,event,2));" value="0,00" <cfif listfindnocase(basket_read_only_discount_list,'disc_ount2_')>readonly</cfif> autocomplete="off"></th>
                </cfcase>
                <cfcase value="disc_ount3_">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;" title="#ListGetAt(display_field_name_list, dli, ',')#"><input id="set_row_disc_ount3" name="set_row_disc_ount3" type="text" class="boxtext" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" onfocus="this.value='';" onblur="if(this.value.length && filterNumBasket(this.value) <= 100) apply_discount(3);" onkeyup="return(FormatCurrency(this,event,2));" value="0,00" <cfif listfindnocase(basket_read_only_discount_list,'disc_ount3_')>readonly</cfif> autocomplete="off"></th>
                </cfcase>
                <cfcase value="disc_ount4_">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;" title="#ListGetAt(display_field_name_list, dli, ',')#"><input id="set_row_disc_ount4" name="set_row_disc_ount4" type="text" class="boxtext" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" onfocus="this.value='';" onblur="if(this.value.length && filterNumBasket(this.value) <= 100) apply_discount(4);" onkeyup="return(FormatCurrency(this,event,2));" value="0,00" <cfif listfindnocase(basket_read_only_discount_list,'disc_ount4_')>readonly</cfif> autocomplete="off"></th>
                </cfcase>
                <cfcase value="disc_ount5_">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;" title="#ListGetAt(display_field_name_list, dli, ',')#"><input id="set_row_disc_ount5" name="set_row_disc_ount5" type="text" class="boxtext" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" onfocus="this.value='';" onblur="if(this.value.length && filterNumBasket(this.value) <= 100) apply_discount(5);" onkeyup="return(FormatCurrency(this,event,2));" value="0,00" <cfif listfindnocase(basket_read_only_discount_list,'disc_ount5_')>readonly</cfif> autocomplete="off"></th>
                </cfcase>
                <cfcase value="disc_ount6_">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;" title="#ListGetAt(display_field_name_list, dli, ',')#"><input id="set_row_disc_ount6" name="set_row_disc_ount6" type="text" class="boxtext" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" onfocus="this.value='';" onblur="if(this.value.length && filterNumBasket(this.value) <= 100) apply_discount(6);" onkeyup="return(FormatCurrency(this,event,2));" value="0,00" <cfif listfindnocase(basket_read_only_discount_list,'disc_ount6_')>readonly</cfif> autocomplete="off"></th>
                </cfcase>
                <cfcase value="disc_ount7_">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;" title="#ListGetAt(display_field_name_list, dli, ',')#"><input id="set_row_disc_ount7" name="set_row_disc_ount7" type="text" class="boxtext" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" onfocus="this.value='';" onblur="if(this.value.length && filterNumBasket(this.value) <= 100) apply_discount(7);" onkeyup="return(FormatCurrency(this,event,2));" value="0,00" <cfif listfindnocase(basket_read_only_discount_list,'disc_ount7_')>readonly</cfif> autocomplete="off"></th>
                </cfcase>
                <cfcase value="disc_ount8_">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;" title="#ListGetAt(display_field_name_list, dli, ',')#"><input id="set_row_disc_ount8" name="set_row_disc_ount8" type="text" class="boxtext" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" onfocus="this.value='';" onblur="if(this.value.length && filterNumBasket(this.value) <= 100) apply_discount(8);" onkeyup="return(FormatCurrency(this,event,2));" value="0,00" <cfif listfindnocase(basket_read_only_discount_list,'disc_ount8_')>readonly</cfif> autocomplete="off"></th>
                </cfcase>
                <cfcase value="disc_ount9_">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;" title="#ListGetAt(display_field_name_list, dli, ',')#"><input id="set_row_disc_ount9" name="set_row_disc_ount9" type="text" class="boxtext" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" onfocus="this.value='';" onblur="if(this.value.length && filterNumBasket(this.value) <= 100) apply_discount(9);" onkeyup="return(FormatCurrency(this,event,2));" value="0,00" <cfif listfindnocase(basket_read_only_discount_list,'disc_ount9_')>readonly</cfif> autocomplete="off"></th>
                </cfcase>
                <cfcase value="disc_ount10_">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;" title="#ListGetAt(display_field_name_list, dli, ',')#"><input id="set_row_disc_ount10" name="set_row_disc_ount10" type="text" class="boxtext" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" onfocus="this.value='';" onblur="if(this.value.length && filterNumBasket(this.value) <= 100) apply_discount(10);" onkeyup="return(FormatCurrency(this,event,2));" value="0,00" <cfif listfindnocase(basket_read_only_discount_list,'disc_ount10_')>readonly</cfif> autocomplete="off"></th>
                </cfcase>
                <cfcase value="row_total">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="row_nettotal">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="row_taxtotal">
                <th  width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="row_otvtotal">
                <th  width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="row_lasttotal">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="other_money">
                <th  width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="other_money_value">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="other_money_gross_total">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="deliver_date">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="reserve_date">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="deliver_dept">
                <th  width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="deliver_dept_assortment">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="shelf_number">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="shelf_number_2">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="is_parse">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="lot_no">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="net_maliyet">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="extra_cost">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="extra_cost_rate">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="row_cost_total">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="marj">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px"  nowrap style="text-align:right;">#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="dara">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="darali">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="promosyon_yuzde">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="promosyon_maliyet">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="order_currency">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="reserve_type">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="basket_extra_info">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="select_info_extra">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="detail_info_extra">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="basket_employee">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="row_width">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="row_depth">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="row_height">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="basket_project">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="basket_work">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="basket_exp_center">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="basket_exp_item">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                <cfcase value="basket_acc_code">
                <th width="#ListGetAt(display_field_width_list, dli, ",")#px" nowrap>#ListGetAt(display_field_name_list, dli, ",")#</th>
                </cfcase>
                </cfswitch>
                </cfloop>
                </cfoutput>
                </tr>
                </cfsavecontent>
                <cfset CRLF = Chr(13) & Chr(10)>
                <cfoutput>#replace(basket_headers_clear,'#CRLF##CRLF#','','all')#</cfoutput>
                <cfloop from="1" to="#ArrayLen(sepet.satir)#" index="i">
                <cfsavecontent variable="basket_rows_clear">
                <cfoutput>
				<cfif sepet.satir[i].amount eq 0><cfset sepet.satir[i].amount = 1></cfif><!--- eleganda hata olustugu icin eklendi MA --->
                <cfif session.ep.period_year gte 2009 and len(sepet.satir[i].other_money) and sepet.satir[i].other_money is 'YTL'>
                <cfset sepet.satir[i].other_money= session.ep.money>
                <cfelseif session.ep.period_year lt 2009 and len(sepet.satir[i].other_money) and sepet.satir[i].other_money is 'TL'>
                <cfset sepet.satir[i].other_money= session.ep.money>
                </cfif>

                <tr height="20" id="tr_#i#">
                <td id="row_no_#i#">#i#</td>
                <td nowrap id="basket_row_add_#i#">
                    <input type="hidden" id="wrk_row_id" name="wrk_row_id" value="<cfif StructKeyExists(sepet.satir[i],'wrk_row_id')>#sepet.satir[i].wrk_row_id#</cfif>">
                    <!--- belgenin satır unique id sini tutar, farklı belgeye dönüştürülürken bu alan taşınır --->
                    <input type="hidden" id="wrk_row_relation_id" name="wrk_row_relation_id" value="<cfif StructKeyExists(sepet.satir[i],'wrk_row_relation_id')>#sepet.satir[i].wrk_row_relation_id#</cfif>">
                    <!--- belgeye farklı belgeden cekilmiş satırlarda dolu olur ve cekilen satırların wrk_row_id sini tutar --->
                    <input type="hidden" id="action_row_id" name="action_row_id" value="<cfif StructKeyExists(sepet.satir[i],'action_row_id')>#sepet.satir[i].action_row_id#</cfif>">
                    <input type="hidden" id="product_id" name="product_id" value="#sepet.satir[i].product_id#">
                    <input type="hidden" id="karma_product_id" name="karma_product_id" value="<cfif StructKeyExists(sepet.satir[i],'karma_product_id') and len(sepet.satir[i].karma_product_id)>#sepet.satir[i].karma_product_id#</cfif>">
                    <input type="hidden" id="is_inventory" name="is_inventory" value="#sepet.satir[i].is_inventory#">
                    <input type="hidden" id="is_production" name="is_production" value="<cfif StructKeyExists(sepet.satir[i],'is_production')>#sepet.satir[i].is_production#</cfif>">
                    <!--- <input type="hidden" name="product_account_code" value="<cfif listfind('1,2,18,20,33,42,43,52',attributes.basket_id,',')>#sepet.satir[i].product_account_code#</cfif>"> diger dosyalardaki product_account_code temizlenecek OZDEN20090218--->
                    <input type="hidden" id="stock_id" name="stock_id" value="#sepet.satir[i].stock_id#">
                    <input type="hidden" id="unit_id" name="unit_id" value="#sepet.satir[i].unit_id#">
                    <input type="hidden" id="row_ship_id" name="row_ship_id" value="<cfif StructKeyExists(sepet.satir[i],'row_ship_id')>#sepet.satir[i].row_ship_id#<cfelse>0</cfif>">
                    <input type="hidden" id="is_promotion" name="is_promotion" value="<cfif StructKeyExists(sepet.satir[i],'is_promotion')>#sepet.satir[i].is_promotion#<cfelse>0</cfif>">
                    <input type="hidden" id="prom_stock_id" name="prom_stock_id" value="<cfif StructKeyExists(sepet.satir[i],'prom_stock_id')>#sepet.satir[i].prom_stock_id#</cfif>">
                    <!--- <cfelse>0 --->
                    <input type="hidden" id="row_paymethod_id" name="row_paymethod_id" value="<cfif StructKeyExists(sepet.satir[i],'row_paymethod_id')>#sepet.satir[i].row_paymethod_id#</cfif>">
                    <input type="hidden" id="row_promotion_id" name="row_promotion_id" value="<cfif StructKeyExists(sepet.satir[i],'row_promotion_id')>#sepet.satir[i].row_promotion_id#</cfif>">
                    <input type="hidden" id="row_unique_relation_id" name="row_unique_relation_id" value="<cfif StructKeyExists(sepet.satir[i],'row_unique_relation_id')>#sepet.satir[i].row_unique_relation_id#</cfif>">
                    <input type="hidden" id="prom_relation_id" name="prom_relation_id" value="<cfif StructKeyExists(sepet.satir[i],'prom_relation_id')>#sepet.satir[i].prom_relation_id#</cfif>">
                    <input type="hidden" id="indirim_total" name="indirim_total" value="#sepet.satir[i].indirim_carpan#">
                    <input type="hidden" id="ek_tutar_total" name="ek_tutar_total" value="<cfif StructKeyExists(sepet.satir[i],'ek_tutar_total')>#sepet.satir[i].ek_tutar_total#<cfelse>0</cfif>" >
                    <input type="hidden" id="price_cat" name="price_cat" value="<cfif StructKeyExists(sepet.satir[i],'price_cat')>#sepet.satir[i].price_cat#</cfif>">
                    <input type="hidden" id="row_catalog_id" name="row_catalog_id" value="<cfif StructKeyExists(sepet.satir[i],'row_catalog_id') and len(sepet.satir[i].row_catalog_id)>#sepet.satir[i].row_catalog_id#</cfif>">
                    <!--- satır aksiyon idsi --->
                    <input type="hidden" id="row_service_id" name="row_service_id" value="<cfif StructKeyExists(sepet.satir[i],'row_service_id') and len(sepet.satir[i].row_service_id)>#sepet.satir[i].row_service_id#</cfif>">
                    <input type="hidden" id="is_commission" name="is_commission" value="<cfif StructKeyExists(sepet.satir[i],'is_commission')>#sepet.satir[i].is_commission#<cfelse>0</cfif>">
                    <input type="hidden" id="related_action_id" name="related_action_id" value="<cfif StructKeyExists(sepet.satir[i],'related_action_id')>#sepet.satir[i].related_action_id#</cfif>">
                    <!--- satırın geldigi ilişkili belge id --->
                    <input type="hidden" id="related_action_table" name="related_action_table" value="<cfif StructKeyExists(sepet.satir[i],'related_action_table')>#sepet.satir[i].related_action_table#</cfif>">
                    <!--- satırın ilişkili oldugu belgenin tablosu --->
                    <cfif session.ep.admin eq 1 or not (listfind('4,6',attributes.basket_id) and StructKeyExists(sepet.satir[i],'order_currency') and len(sepet.satir[i].order_currency) and ( listfind('-3,-8',sepet.satir[i].order_currency) or (sepet.satir[i].order_currency eq -5 and isdefined('is_basket_readonly')) ) )>
                    <!---siparis asaması kapatıldı veya fazla teslimatsa o satır silinemez, güncellenemez, kopyalanamaz --->
                    <cfsavecontent variable="delete_product"><cf_get_lang_main no='271.Ürünü Silmek İstediğinizden Emin misiniz'></cfsavecontent>
                    <!--- <cfif (not workcube_mode) and StructKeyExists(sepet.satir[i],'row_ship_id')>
                    _#sepet.satir[i].row_ship_id#_
                    </cfif> --->
                    <a href="javascript://" id="basket_delete_list_href" name="basket_delete_list_href" onclick="if (confirm('#delete_product#')) clear_related_rows(this.parentNode.parentNode.rowIndex); else return;"><img src="/images/delete_list.gif" title="<cf_get_lang_main no='270.Ürünü Sil'>" border="0" id="basket_delete_list"></a>
                    <cfsavecontent variable="messages"><cf_get_lang_main no="1326.Karma Koli İçeriğindeki Ürünler Tek Olarak Güncellenemez"></cfsavecontent>
                    <cfif ListFindNoCase(display_list, "product_name") and not len(sepet.satir[i].wrk_row_relation_id)>
                    <!--- eğer bir işlemle ilişkili olan bir satırsa ürün değiştirelimesin --->
                    <a href="javascript://" onclick="<cfif StructKeyExists(sepet.satir[i],'row_unique_relation_id') and len(sepet.satir[i].row_unique_relation_id)>alert('#messages#');<cfelse>control_comp_selected(this.parentNode.parentNode.rowIndex);</cfif>"><img src="/images/update_list.gif" title="<cf_get_lang_main no='307.Farklı Ürün Seçmek İçin Tıklayınız'>" border="0" id="basket_update_list"></a>
                    </cfif>
                    <a href="javascript://" onclick="copy_basket_row(this.parentNode.parentNode.rowIndex-1);"><img src="/images/copy_list.gif" title="<cf_get_lang_main no='1011.Aynı Ürünü Eklemek İçin Tıklayınız'>" border="0" name="basket_copy" id="basket_copy"></a>
                    </cfif>
					<cfif listfind("11,14",attributes.basket_id,",") and (attributes.fuseaction contains 'add' or (isdefined("attributes.event") and attributes.event is 'add'))><!--- seri no ekleme sayfası açılacak --->
                    	<cfquery name="is_serial" datasource="#dsn3#">
                        	SELECT IS_SERIAL_NO FROM PRODUCT WHERE PRODUCT_ID = #sepet.satir[i].product_id#
                        </cfquery>
                        <cfif is_serial.IS_SERIAL_NO eq 1>
                            <a href="javascript://" onclick="add_seri_no(this.parentNode.parentNode.rowIndex);"><img src="/images/barcode2.gif" border="0" alt="Seri No Eklemek İçin Tıklayınız"></a>
						</cfif>
                    </cfif>
                </td>
                <cfset fl_total_2 = 1>
                <cfset fl_total = 1>
                <cfloop query="get_money_bskt">
                <cfif sepet.satir[i].other_money eq money_type>
                <cfset fl_total_2 = rate1>
                <cfset fl_total = rate2>
                </cfif>
                </cfloop>
                <cfinclude template="dsp_basket_js_hiddens.cfm">
                <!---20060228 Tikkat --->
                <cfloop from="1" to="#listlen(display_list,",")#" index="dli">
                <cfset element = ListGetAt(display_list,dli,",")>
                <cfif listlen(display_field_name_list) gte dli>
                <!--- gecici olarak bu sekilde duzeltildi ozden16092005 --->
                <cfset title_content = "#ListGetAt(display_field_name_list, dli, ',')#">
                <cfelse>
                <cfset title_content = ''>
                </cfif>
                <cfif (listlen(display_field_name_list) gte dli) and element is 'list_price' and len(basket_price_cat_id_list_) and StructKeyExists(sepet.satir[i],'price_cat') and len(sepet.satir[i].price_cat)>
                <cfif sepet.satir[i].price_cat eq '-1'>
                <cfset row_price_cat_name_='Standart Alış'>
                <cfelseif sepet.satir[i].price_cat eq '-2'>
                <cfset row_price_cat_name_='Standart Satış'>
                <cfelseif listfind(basket_price_cat_id_list_,sepet.satir[i].price_cat)>
                <cfset row_price_cat_name_=get_basket_price_cat_list.PRICE_CAT[listfind(basket_price_cat_id_list_,sepet.satir[i].price_cat)]>
                <cfelse>
                <cfset row_price_cat_name_=''>
                </cfif>
                <cfset title_content = "#title_content#:#row_price_cat_name_#">
                </cfif>
                <cfset title_content = "#title_content##Chr(13)##Chr(10)##sepet.satir[i].product_name#">
                <!--- satırlar 2 bloktan oluşuyor. 1-standart olanlar 2-siparişlerdeki kapatılmış ve fazla teslimat satırlarının readonly geldigi bolum 
                is_basket_readonly parametresi sipariş için üretim emri set edilmişse, sipariş detay sayfasında tanımlanıyor--->
                <cfif session.ep.admin eq 1 or not (listfind('4,6',attributes.basket_id) and StructKeyExists(sepet.satir[i],'order_currency') and len(sepet.satir[i].order_currency) and ( listfind('-3,-8',sepet.satir[i].order_currency) or (sepet.satir[i].order_currency eq -5 and isdefined('is_basket_readonly')) ) )>
                <cfswitch expression="#element#">
                <cfcase value="stock_code">
                <td nowrap style="text-align:right;" title="#title_content#"><input type="text" id="stock_code" name="stock_code" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" value="#sepet.satir[i].stock_code#" readonly=yes></td>
                </cfcase>
                <cfcase value="barcod">
                <td nowrap style="text-align:right;" title="#title_content#"><input type="text" id="barcod" name="barcod" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" value="#sepet.satir[i].barcode#" readonly=yes></td>
                </cfcase>
                <cfcase value="special_code">
                <td nowrap style="text-align:right;" title="#title_content#"><input type="text" id="special_code" name="special_code" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" value="#sepet.satir[i].special_code#" readonly=yes></td>
                </cfcase>
                <cfcase value="manufact_code">
                <td nowrap style="text-align:right;" title="#title_content#"><input type="text" id="manufact_code" name="manufact_code" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" value="#sepet.satir[i].manufact_code#"></td>
                </cfcase>
                <cfcase value="product_name">
                <td nowrap style="text-align:right;" title="#title_content#" id="td_#i#">
					<input type="text" id="product_name" name="product_name" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" value="#sepet.satir[i].product_name#" <cfif ListGetAt(display_field_readonly_list,dli,",") eq 1>readonly="yes"</cfif>>
					<a href="javascript://" id="product_popup_#i#" onclick="open_product_popup(this.parentNode.parentNode.rowIndex);"><img src="/images/plus_thin.gif" title="<cf_get_lang_main no='308.Ürün Detayları İçin Tıklayınız'>" border="0" align="absmiddle"></a>
					<cfif get_module_user(5)>
						<a href="javascript://" id="product_price_history_#i#" onclick="open_product_price_history(this.parentNode.parentNode.rowIndex);"><img src="/images/plus_thin_p.gif" title="<cf_get_lang_main no='309.Ürün Fiyat Tarihçe'>" border="0" align="absmiddle"></a>
					</cfif>
                </td>
                </cfcase>
                <cfcase value="amount">
                <td nowrap title="#title_content#"><input id="amount" name="amount" type="text" class="box" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" onfocus="form_basket.control_field_value.value=filterNumBasket(this.value,amount_round);this.select();" onblur="if(this.value.length==0 || filterNum(this.value,amount_round)==0) this.value = '1';<cfif ListFindNoCase(display_list, "darali") and ListFindNoCase(display_list, "dara")>dara_miktar_hesabi(this.parentNode.parentNode.rowIndex,3);<cfelse>hesapla('amount',this.parentNode.parentNode.rowIndex);</cfif>"  onkeyup="return(FormatCurrency(this,event,amount_round));" value="#AmountFormat(sepet.satir[i].amount,amount_round)#" autocomplete="off"></td>
                </cfcase>
                <cfcase value="unit">
                <td nowrap title="#title_content#"><input type="Text" id="unit" name="unit" value="#sepet.satir[i].unit#" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" readonly=yes></td>
                </cfcase>
                <cfcase value="product_name2">
                	<cfif StructKeyExists(sepet.satir[i],'product_name_other') and (sepet.satir[i].product_name_other contains "'" or sepet.satir[i].product_name_other contains '"')>
                    	<cfset product_name_other_control = replace(replace(sepet.satir[i].product_name_other,"'","",'all'),'"','','all')>
                    <cfelseif StructKeyExists(sepet.satir[i],'product_name_other')>
                    	<cfset product_name_other_control = sepet.satir[i].product_name_other>
                    </cfif>
                	<td nowrap style="text-align:right;" title="#title_content#"><input type="text" id="product_name_other" name="product_name_other" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" value="<cfif StructKeyExists(sepet.satir[i],'product_name_other') and len(sepet.satir[i].product_name_other)>#product_name_other_control#</cfif>"></td>
                </cfcase>
                <cfcase value="amount2">
                <!--- iscilik birim ucreti seciliyse, amount_other bu degerin carpanı olarak kullanılır --->
                <td nowrap title="#title_content#"><input type="text" id="amount_other" name="amount_other" value="<cfif StructKeyExists(sepet.satir[i],'amount_other') and len(sepet.satir[i].amount_other)>#TLFormat(sepet.satir[i].amount_other,price_round_number)#</cfif>" onkeyup="return(FormatCurrency(this,event,price_round_number));" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="box" onblur="if(this.value.length == 0) this.value = '0,0000';hesapla('amount_other',this.parentNode.parentNode.rowIndex);ek_tutar_hesapla(this.parentNode.parentNode.rowIndex,'amount_other');"></td>
                </cfcase>
                <cfcase value="unit2">
				<cfif ListFindNoCase(display_list, "is_use_add_unit")>
					<cfset attributes.pid = sepet.satir[i].product_id>
					<cfinclude template="../query/get_product_unit.cfm">
					<td nowrap title="#title_content#"><select name="unit_other" id="unit_other" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" onchange="hesapla('amount_other',this.parentNode.parentNode.rowIndex);"><cfloop query="get_product_unit"><option value="#add_unit#" <cfif StructKeyExists(sepet.satir[i],'unit_other') and len(sepet.satir[i].unit_other) and sepet.satir[i].unit_other eq add_unit>selected</cfif>>#add_unit#</option></cfloop></select></td>
				<cfelse>
					<td nowrap title="#title_content#"><input type="Text" id="unit_other" name="unit_other" maxlength="5" value="<cfif StructKeyExists(sepet.satir[i],'unit_other') and len(sepet.satir[i].unit_other)>#sepet.satir[i].unit_other#</cfif>" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext"></td>
				</cfif>
                </cfcase>
                <cfcase value="spec">
                <td nowrap title="#title_content#"><!--- spec kategori özelliklerine göre secili ve akış parametrelerinden spec de o ise satırda kategori özellikleri gelir --->
					<input type="hidden" id="spect_id" name="spect_id" value="#sepet.satir[i].spect_id#">
					<cfif StructKeyExists(sepet.satir[i],'is_production') and sepet.satir[i].is_production eq 1 and Listfind(display_list,'spec_product_cat_property',",")>
                        <cfset div_ayarla = 1>
                        <input type="hidden" id="spect_name" name="spect_name" value="#sepet.satir[i].spect_name#">
                        <cfquery name="GET_PROD_CAT_PROPERTY" datasource="#dsn1#">
                            SELECT PP.PROPERTY_ID, PP.PROPERTY FROM PRODUCT_PROPERTY PP WHERE PP.PROPERTY_ID IN (SELECT PRODUCT_CAT_PROPERTY.PROPERTY_ID FROM PRODUCT_CAT_PROPERTY, PRODUCT WHERE PRODUCT_ID=#sepet.satir[i].product_id# AND PRODUCT_CAT_PROPERTY.PRODUCT_CAT_ID = PRODUCT.PRODUCT_CATID ) ORDER BY PP.PROPERTY
                        </cfquery>
                        <cfif len(sepet.satir[i].spect_id)>
                            <cfquery name="GET_SPEC_ROW" datasource="#dsn1#">
                                SELECT VARIATION_ID, PROPERTY_ID, PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL PPD, #dsn3_alias#.SPECTS_ROW SP WHERE SP.PROPERTY_ID = PPD.PRPT_ID AND SP.VARIATION_ID = PROPERTY_DETAIL_ID AND SPECT_ID = #sepet.satir[i].spect_id#
                            </cfquery>
                            <cfset spec_property_list = valuelist(GET_SPEC_ROW.PROPERTY_ID,'*║*')>
                            <cfset spec_variation_list = valuelist(GET_SPEC_ROW.VARIATION_ID,'*║*')>
                            <cfset spec_variation_detail_list = valuelist(GET_SPEC_ROW.PROPERTY_DETAIL,'*║*')>
                        <cfelse>
                            <cfset spec_variation_list=''>
                        </cfif>
                        <table>
                            <tr>
                                <input type="hidden" id="spec_cat_property_recordcount#i#" name="spec_cat_property_recordcount#i#" value="#GET_PROD_CAT_PROPERTY.RECORDCOUNT#">
                                <cfloop from="1" to="#GET_PROD_CAT_PROPERTY.RECORDCOUNT#" index="property_ind">
                                    <td>
                                        <cfif isdefined('spec_property_list') and ListFind(spec_property_list,GET_PROD_CAT_PROPERTY.PROPERTY_ID[property_ind],'*║*')>
                                            <cfset liste_sira = ListFind(spec_property_list,GET_PROD_CAT_PROPERTY.PROPERTY_ID[property_ind],'*║*') >
                                            <cfset 'property_name_#i#_#property_ind#' = ListGetAt(spec_variation_detail_list,liste_sira,'*║*')>
                                            <cfset 'spec_cat_property_#i#_#property_ind#' = ListGetAt(spec_variation_list,liste_sira,'*║*')>
                                        </cfif>
                                        <input type="hidden" id="spec_cat_property_#i#_#property_ind-1#" name="spec_cat_property_#i#_#property_ind-1#" value="<cfif isdefined('spec_cat_property_#i#_#property_ind#')>#GET_PROD_CAT_PROPERTY.PROPERTY_ID[property_ind]#-#Evaluate('spec_cat_property_#i#_#property_ind#')#</cfif>">
                                        <div id="spect_property_info#i#_#property_ind#" style="display:none"></div>
                                            <input type="text" id="property_name_#i#_#property_ind#" name="property_name_#i#_#property_ind#" value="<cfif isdefined('property_name_#i#_#property_ind#')>#Evaluate('property_name_#i#_#property_ind#')#<cfelse>#GET_PROD_CAT_PROPERTY.PROPERTY[property_ind]#</cfif>" style="width:#ListGetAt(display_field_width_list, dli, ',')#px;" onkeyup="AjaxPageLoad('#request.self#?fuseaction=objects.popup_ajax_spect_property_cats&form_name=form_basket&field_id=spec_cat_property_#i#_#property_ind-1#&field_name=property_name_#i#_#property_ind#&is_multi_no=#i#_#property_ind#&property_id=#GET_PROD_CAT_PROPERTY.PROPERTY_ID[property_ind]#&default_property_name=#GET_PROD_CAT_PROPERTY.PROPERTY[property_ind]#','spect_property_info#i#_#property_ind#',1)">
                                            <div id="spect_cat_prpty_#i#_#property_ind#" style=" display:none; width:10px; position:absolute; margin-left:-#ListGetAt(display_field_width_list, dli, ',')#; margin-top:20; border: none; z-index:1000;">
                                            <table class="color-border" cellpadding="2" cellspacing="1" width="100%">
                                                <tr height="18" class="color-row"><td id="property_td_#i#_#property_ind#"></td></tr>
                                            </table>
                                        </div>
                                    </td>
                                </cfloop>
                            </tr>
                        </table>
                    <cfelse>
                        <input type="Text" id="spect_name" name="spect_name" value="#sepet.satir[i].spect_name#" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" readonly=yes>
                    </cfif>
                    <a href="javascript://" onclick="open_spec(this.parentNode.parentNode.rowIndex);">
                        <cfif isdefined('div_ayarla')><div style="position:absolute;margin-left:-3; cursor:pointer; margin-top:-23;"></cfif>
                            <img src="/images/plus_thin.gif" align="absmiddle" border="0">
                        <cfif isdefined('div_ayarla')></div></cfif>
                    </a>
                </td>
                </cfcase>
                <cfcase value="list_price">
                	<td nowrap title="#title_content#"><input type="text" id="list_price" name="list_price" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'list_price')>#TLFormat(sepet.satir[i].list_price,price_round_number)#</cfif>" class="box" readonly="yes"></td>
                </cfcase>
                <cfcase value="list_price_discount">
					<!--- liste fiyatı uzerinden net maliyeti hesaplamak ıcın kullanılır --->
                    <cfif StructKeyExists(sepet.satir[i],'list_price') and len(sepet.satir[i].list_price) and sepet.satir[i].list_price neq 0 and StructKeyExists(sepet.satir[i],'net_maliyet') and len(sepet.satir[i].net_maliyet)>
                        <cfset list_price_discount=100-((sepet.satir[i].net_maliyet*100)/sepet.satir[i].list_price)>
                    <cfelse>
                        <cfset list_price_discount=0>
                    </cfif>
                    <td nowrap title="#title_content#"><input type="text" id="list_price_discount" name="list_price_discount" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(list_price_discount)#" class="box"  <cfif listfindnocase(basket_read_only_discount_list,'list_price_discount')> readonly='yes'<cfelse>onBlur="if(this.value.length == 0) this.value = '0,00';marj_maliyet_hesabi(this.parentNode.parentNode.rowIndex,1,'list_price_discount');" onkeyup="return(FormatCurrency(this,event));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif> ></td>
                </cfcase>
                <cfcase value="tax_price">
                	<td nowrap title="#title_content#"><input type="text" id="tax_price" name="tax_price" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].row_lasttotal/sepet.satir[i].amount,price_round_number)#" class="box" <cfif listfindnocase(basket_read_only_price_list,'tax_price')> readonly='yes'<cfelse>onBlur="if(this.value.length == 0) this.value = '0';kdvdahildenhesapla(this.parentNode.parentNode.rowIndex,'tax_price');" onkeyup="return(FormatCurrency(this,event,price_round_number));"  onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();" </cfif>></td>
                </cfcase>
                <cfcase value="price">
                	<td nowrap title="#title_content#"><input type="text" id="price" name="price" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].price,price_round_number)#" class="box" <cfif listfindnocase(basket_read_only_price_list,'price') or ( StructKeyExists(sepet.satir[i],'row_unique_relation_id') and len(sepet.satir[i].row_unique_relation_id) )> readonly='yes'<cfelse>onBlur="if(this.value.length == 0) this.value = '0';<cfif ListFindNoCase(display_list, "net_maliyet") and ListFindNoCase(display_list, "marj")>marj_maliyet_hesabi(this.parentNode.parentNode.rowIndex,4);<cfelse>hesapla('price',this.parentNode.parentNode.rowIndex);</cfif>" onkeyup="return(FormatCurrency(this,event,price_round_number));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();" </cfif> >
						<cfif not (listfindnocase(basket_read_only_price_list,'price') or (StructKeyExists(sepet.satir[i],'row_unique_relation_id') and len(sepet.satir[i].row_unique_relation_id) ) )>
                            <a href="javascript://" onclick="open_price(this.parentNode.parentNode.rowIndex);"><img src="/images/plus_thin.gif" align="absmiddle" title="<cf_get_lang_main no='310.Farklı Ürün Fiyatı Seçmek İçin Tıklayınız'>" border="0" id="price_list_image"></a>
                        </cfif>
                    </td>
                </cfcase>
                <cfcase value="price_other">
                	<td nowrap title="#title_content#"><input type="text" id="price_other" name="price_other" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].price_other,price_round_number)#" class="box"  <cfif listfindnocase(basket_read_only_price_list,'price_other')> readonly='yes'<cfelse>onBlur="if(this.value.length == 0) this.value = '0,0000';<cfif ListFindNoCase(display_list, "net_maliyet") and ListFindNoCase(display_list, "marj")>marj_maliyet_hesabi(this.parentNode.parentNode.rowIndex,5);<cfelse>hesapla('price_other',this.parentNode.parentNode.rowIndex);</cfif>" onkeyup="return(FormatCurrency(this,event,price_round_number));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif> ></td>
                </cfcase>
                <cfcase value="price_net">
                    <td nowrap title="#title_content#">
                        <cfset float_price_net = sepet.satir[i].row_nettotal/sepet.satir[i].amount>
                        <input type="text" id="price_net" name="price_net" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(float_price_net,price_round_number)#" class="box" readonly=yes>
                    </td>
                </cfcase>
                <cfcase value="price_net_doviz">
                	<td nowrap title="#title_content#"><cfset float_price_net_doviz = (sepet.satir[i].row_nettotal/sepet.satir[i].amount)*fl_total_2/fl_total><input type="text" id="price_net_doviz" name="price_net_doviz" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(float_price_net_doviz,price_round_number)#" class="box" readonly=yes></td>
                </cfcase>
                <cfcase value="tax">
                	<td nowrap title="#title_content#"><input type="text" id="tax" name="tax" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].tax_percent,0)#" class="box"  <cfif listfindnocase(basket_read_only_price_list,'tax')> readonly='yes'<cfelse>onBlur="if(this.value.length == 0) this.value = '0';hesapla('tax',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,0));"  onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>></td>
                </cfcase>
                <cfcase value="OTV">
                	<td nowrap title="#title_content#"><input type="text" id="otv_oran" name="otv_oran" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'otv_oran')>#TLFormat(sepet.satir[i].otv_oran,0)#</cfif>" class="box" <cfif listfindnocase(basket_read_only_price_list,'OTV')> readonly='yes'<cfelse> onBlur="if(this.value.length == 0) this.value = '0';hesapla('otv_oran',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,0));"  onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>></td>
                </cfcase>
                <cfcase value="duedate">
                	<td nowrap title="#title_content#"><input type="text" id="duedate" name="duedate" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#sepet.satir[i].duedate#" class="box" <cfif session.ep.duedate_valid eq 1>readonly="yes" <cfelse>onBlur="<cfif not listfindnocase(display_list,'number_of_installment')>set_basket_duedate_price(this.parentNode.parentNode.rowIndex-1);</cfif> hesapla('duedate',this.parentNode.parentNode.rowIndex);" onKeyUp="return(FormatCurrency(this,event,0));"  onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>></td>
                </cfcase>
                <cfcase value="number_of_installment">
                	<td nowrap title="#title_content#"><input id="number_of_installment" name="number_of_installment" type="text" class="box" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" onfocus="if(this.value == '0') this.value = '';" onblur="if(this.value.length == 0) this.value = '0';basket_taksit_hesapla(this.parentNode.parentNode.rowIndex-1);" onkeyup="return(FormatCurrency(this,event,0));" value="<cfif StructKeyExists(sepet.satir[i],'number_of_installment')>#sepet.satir[i].number_of_installment#</cfif>" autocomplete="off" ></td>
                </cfcase>
                <!--- alt satırlardaki attributes.basket_id sonradan database den gelecek --->
                <cfcase value="iskonto_tutar">
                	<td nowrap title="#title_content#"><input type="text" id="iskonto_tutar" name="iskonto_tutar" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'iskonto_tutar')>#TLFormat(sepet.satir[i].iskonto_tutar,price_round_number)#</cfif>" class="box" <cfif listfindnocase(basket_read_only_discount_list,'iskonto_tutar')> readonly='yes'<cfelse>onBlur="if(this.value.length == 0) this.value = '0,0000';hesapla('iskonto_tutar',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,price_round_number));"  onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif> ></td>
                </cfcase>
                <cfcase value="ek_tutar">
                	<td nowrap title="#title_content#"><input type="text" id="ek_tutar" name="ek_tutar" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'ek_tutar')>#TLFormat(sepet.satir[i].ek_tutar,price_round_number)#</cfif>" class="box" <cfif listfindnocase(basket_read_only_price_list,'ek_tutar')> readonly='yes'<cfelse>onBlur="if(this.value.length == 0) this.value = '0,0000';ek_tutar_hesapla(this.parentNode.parentNode.rowIndex,'ek_tutar');hesapla('ek_tutar',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,price_round_number));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif> ></td>
                </cfcase>
                <cfcase value="ek_tutar_price">
                <td nowrap title="#title_content#"><input type="text" id="ek_tutar_price" name="ek_tutar_price" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'ek_tutar_price')>#TLFormat(sepet.satir[i].ek_tutar_price,price_round_number)#</cfif>" class="box" <cfif listfindnocase(basket_read_only_price_list,'ek_tutar_price')> readonly='yes'<cfelse>onBlur="if(this.value.length == 0) this.value = '0,0000';ek_tutar_hesapla(this.parentNode.parentNode.rowIndex,'ek_tutar_price');" onkeyup="return(FormatCurrency(this,event,price_round_number));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>></td>
                </cfcase>
                <cfcase value="ek_tutar_other_total">
                <td nowrap title="#title_content#"><input type="text" id="ek_tutar_other_total" name="ek_tutar_other_total" value="<cfif StructKeyExists(sepet.satir[i],'ek_tutar_other_total') and len(sepet.satir[i].ek_tutar_other_total)>#TLFormat(sepet.satir[i].ek_tutar_other_total,price_round_number)#</cfif>" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="box" <cfif listfindnocase(basket_read_only_price_list,'ek_tutar_other_total')> readonly='yes'<cfelse> onkeyup="return(FormatCurrency(this,event,price_round_number));" onBlur="if(this.value.length == 0) this.value = '0,0000';hesapla('ek_tutar_other_total',this.parentNode.parentNode.rowIndex);ek_tutar_hesapla(this.parentNode.parentNode.rowIndex,'ek_tutar');" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>></td>
                </cfcase>
                <cfcase value="ek_tutar_cost">
                <td nowrap title="#title_content#"><input type="text" id="ek_tutar_cost" name="ek_tutar_cost" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'ek_tutar_cost')>#TLFormat(sepet.satir[i].ek_tutar_cost,price_round_number)#</cfif>" class="box" <cfif listfindnocase(basket_read_only_price_list,'ek_tutar_cost')> readonly='yes'<cfelse>onBlur="if(this.value.length == 0) this.value = '0,0000';ek_tutar_hesapla(this.parentNode.parentNode.rowIndex,'ek_tutar_price');" onkeyup="return(FormatCurrency(this,event,price_round_number));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif> ></td>
                </cfcase>
                <cfcase value="ek_tutar_marj">
                <td nowrap title="#title_content#"><input type="text" id="ek_tutar_marj" name="ek_tutar_marj" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'ek_tutar_marj')>#TLFormat(sepet.satir[i].ek_tutar_marj,2)#</cfif>" class="box" <cfif listfindnocase(basket_read_only_price_list,'ek_tutar_marj')> readonly='yes'<cfelse>onBlur="if(this.value.length == 0) this.value = '0,00';ek_tutar_hesapla(this.parentNode.parentNode.rowIndex,'ek_tutar_marj');" onkeyup="return(FormatCurrency(this,event));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>></td>
                </cfcase>
                <cfcase value="disc_ount">
                <td nowrap title="#title_content#"><input type="text" id="indirim1" name="indirim1" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].indirim1)#" class="box"  <cfif listfindnocase(basket_read_only_discount_list,'disc_ount')> readonly='yes'<cfelse>onBlur="if(this.value.length == 0) this.value = '0,00';<cfif attributes.basket_id is 51> control_prod_discount(this.parentNode.parentNode.rowIndex-1);</cfif>hesapla('indirim1',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif> ></td>
                </cfcase>
                <cfcase value="disc_ount2_">
                <td nowrap title="#title_content#"><input type="text" id="indirim2" name="indirim2" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].indirim2)#" class="box" <cfif listfindnocase(basket_read_only_discount_list,'disc_ount2_')> readonly='yes'<cfelse>onBlur="if(this.value.length == 0) this.value = '0,00';hesapla('indirim2',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>></td>
                </cfcase>
                <cfcase value="disc_ount3_">
                <td nowrap title="#title_content#"><input type="text" id="indirim3" name="indirim3" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].indirim3)#" class="box" <cfif listfindnocase(basket_read_only_discount_list,'disc_ount3_')> readonly='yes'<cfelse> onBlur="if(this.value.length == 0) this.value = '0,00';hesapla('indirim3',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>></td>
                </cfcase>
                <cfcase value="disc_ount4_">
                <td nowrap title="#title_content#"><input type="text" id="indirim4" name="indirim4" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].indirim4)#" class="box"<cfif listfindnocase(basket_read_only_discount_list,'disc_ount4_')> readonly='yes'<cfelse> onBlur="if(this.value.length == 0) this.value = '0,00';hesapla('indirim4',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>></td>
                </cfcase>
                <cfcase value="disc_ount5_">
                <td nowrap title="#title_content#"><input type="text" id="indirim5" name="indirim5" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].indirim5)#" class="box" <cfif listfindnocase(basket_read_only_discount_list,'disc_ount5_')> readonly='yes'<cfelse> onBlur="if(this.value.length == 0) this.value = '0,00';hesapla('indirim5',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>></td>
                </cfcase>
                <cfcase value="disc_ount6_">
                <td nowrap title="#title_content#"><input type="text" id="indirim6" name="indirim6" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].indirim6)#" class="box" <cfif listfindnocase(basket_read_only_discount_list,'disc_ount6_')> readonly='yes'<cfelse>onBlur="if(this.value.length == 0) this.value = '0,00';hesapla('indirim6',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>></td>
                </cfcase>
                <cfcase value="disc_ount7_">
                <td nowrap title="#title_content#"><input type="text" id="indirim7" name="indirim7" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].indirim7)#" class="box" <cfif listfindnocase(basket_read_only_discount_list,'disc_ount7_')> readonly='yes'<cfelse> onBlur="if(this.value.length == 0) this.value = '0,00';hesapla('indirim7',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>></td>
                </cfcase>
                <cfcase value="disc_ount8_">
                <td nowrap title="#title_content#"><input type="text" id="indirim8" name="indirim8" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].indirim8)#" class="box" <cfif listfindnocase(basket_read_only_discount_list,'disc_ount8_')> readonly='yes'<cfelse> onBlur="if(this.value.length == 0) this.value = '0,00';hesapla('indirim8',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>></td>
                </cfcase>
                <cfcase value="disc_ount9_">
                <td nowrap title="#title_content#"><input type="text" id="indirim9" name="indirim9" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].indirim9)#" class="box" <cfif listfindnocase(basket_read_only_discount_list,'disc_ount9_')> readonly='yes'<cfelse>onBlur="if(this.value.length == 0) this.value = '0,00';hesapla('indirim9',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>></td>
                </cfcase>
                <cfcase value="disc_ount10_">
                <td nowrap title="#title_content#"><input type="text" id="indirim10" name="indirim10" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].indirim10)#" class="box" <cfif listfindnocase(basket_read_only_discount_list,'disc_ount10_')> readonly='yes'<cfelse>onBlur="if(this.value.length == 0) this.value = '0,00';hesapla('indirim10',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>></td>
                </cfcase>
                <cfcase value="row_total">
                <td nowrap title="#title_content#"><input type="text" id="row_total" name="row_total" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].row_total,price_round_number)#" class="box" <cfif attributes.basket_id is 31  or listfindnocase(basket_read_only_price_list,'row_total')> readonly='yes'<cfelse>onBlur="if(this.value.length == 0) this.value = '0,00';hesapla('row_total',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,price_round_number));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif> ></td>
                </cfcase>
                <cfcase value="row_nettotal">
                <td nowrap title="#title_content#"><input type="text" id="row_nettotal" name="row_nettotal" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].row_nettotal,price_round_number)#" class="box" readonly=yes></td>
                </cfcase>
                <cfcase value="row_taxtotal">
                <td nowrap title="#title_content#"><input type="text" id="row_taxtotal" name="row_taxtotal" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].row_taxtotal,price_round_number)#" class="box" <cfif listfindnocase(basket_read_only_price_list,'row_taxtotal')> readonly='yes'<cfelse>onBlur="if(this.value.length == 0) this.value = '0,0000';hesapla('row_taxtotal',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,price_round_number));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>></td>
                </cfcase>
                <cfcase value="row_otvtotal">
                <td nowrap title="#title_content#"><input type="text" id="row_otvtotal" name="row_otvtotal" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_otvtotal')>#TLFormat(sepet.satir[i].row_otvtotal,price_round_number)#</cfif>" class="box"  <cfif listfindnocase(basket_read_only_price_list,'row_otvtotal')> readonly='yes'<cfelse>onBlur="if(this.value.length == 0) this.value = '0,0000';hesapla('row_otvtotal',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,price_round_number));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>></td>
                </cfcase>
                <cfcase value="row_lasttotal">
                <td nowrap title="#title_content#"><input type="text" id="row_lasttotal" name="row_lasttotal" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].row_lasttotal,price_round_number)#" class="box" <cfif listfindnocase(basket_read_only_price_list,'row_lasttotal')> readonly='yes'<cfelse> onBlur="if(this.value.length == 0) this.value = '0,00';kdvdahildenhesapla(this.parentNode.parentNode.rowIndex,'row_lasttotal');" onkeyup="return(FormatCurrency(this,event,price_round_number));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();" </cfif>></td>
                </cfcase>
                <cfcase value="other_money">
                <td  nowrap style="text-align:right;" title="#title_content#">
                <select id="other_money_" name="other_money_" style="width:50px;" onchange="hesapla('other_money_',this.parentNode.parentNode.rowIndex);">
                <cfloop query="get_money_bskt">
                <option value="#money_type#"<cfif sepet.satir[i].other_money eq money_type> selected</cfif>>#money_type#</option>
                </cfloop>
                </select>
                </td>
                </cfcase>
                <cfcase value="other_money_value">
                <td  nowrap style="text-align:right;" title="#title_content#"><cfif isdefined("fl_total")>
                <cfset fl_other_money = sepet.satir[i].row_nettotal*fl_total_2/fl_total>
                <cfelse>
                <cfset fl_other_money = sepet.satir[i].other_money_value>
                </cfif>
                <!--- önceden sepet şablonunda olmayan yerlerde sonradan şablondan seçilme sorununa karşı --->
                <cfif fl_other_money is "">
                <cfset fl_other_money = sepet.satir[i].price>
                </cfif>
                <cfif StructKeyExists(sepet.satir[i],'otv_oran')>
                <cfif ListFindNoCase(display_list, "otv_from_tax_price")>
                <!--- kdv matrahına otv toplam ekleniyor --->
                <cfset sepet.satir[i].other_money_grosstotal = (fl_other_money*((sepet.satir[i].tax_percent + (sepet.satir[i].otv_oran*(sepet.satir[i].tax_percent/100)))+sepet.satir[i].otv_oran+100))/100>
                <cfelse>
                <cfset sepet.satir[i].other_money_grosstotal = (fl_other_money*(sepet.satir[i].tax_percent+sepet.satir[i].otv_oran+100))/100>
                </cfif>
                <cfelse>
                <cfset sepet.satir[i].other_money_grosstotal = (fl_other_money*(sepet.satir[i].tax_percent+100))/100>
                </cfif>
                <input type="text" id="other_money_value_" name="other_money_value_" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].other_money_value,price_round_number)#" class="box" <cfif listfindnocase(basket_read_only_price_list,'other_money_value')> readonly='yes'<cfelse> onBlur="if(this.value.length == 0) this.value = '0,0000';hesapla('other_money_value_',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,price_round_number));"  onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>
                </td>
                </cfcase>
                <cfcase value="other_money_gross_total">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="other_money_gross_total" name="other_money_gross_total" value="<cfif StructKeyExists(sepet.satir[i],'other_money_grosstotal')>#TLFormat(sepet.satir[i].other_money_grosstotal,price_round_number)#</cfif>" class="box" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" readonly=yes></td>
                </cfcase>
                <cfcase value="deliver_date">
                <td  nowrap id="deliver_date_td" style="text-align:right;" title="#title_content#">
                    <input type="text" id="deliver_date" name="deliver_date" value="#sepet.satir[i].deliver_date#" class="boxtext" maxlength="10" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;">
                    <a href="javascript://" onclick="get_basket_date('deliver_date',(this.parentNode.parentNode.rowIndex-1));"><img src="/images/plus_thin.gif" id="deliver_date_image" align="absbottom" border="0"></a>
                </td>
                </cfcase>
                <cfcase value="reserve_date">
                <td  nowrap id="td_reserve_date" style="text-align:right;" title="#title_content#">
                    <input type="text" id="reserve_date" name="reserve_date" value="<cfif StructKeyExists(sepet.satir[i],'reserve_date')>#sepet.satir[i].reserve_date#</cfif>" class="boxtext" maxlength="10" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;">
                    <a href="javascript://" onclick="get_basket_date('reserve_date',(this.parentNode.parentNode.rowIndex-1));"><img src="/images/plus_thin.gif" id="reserve_date_image" align="absbottom" border="0"></a>
                </td>
                </cfcase>
                <cfcase value="deliver_dept">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="hidden" id="deliver_dept" name="deliver_dept" value="<cfif len(sepet.satir[i].deliver_dept)>#sepet.satir[i].deliver_dept#</cfif>">
					<cfif len(listsort(sepet.satir[i].deliver_dept,"Text","asc","-")) and listlen(sepet.satir[i].deliver_dept,'-') eq 2>
                    <cfset attributes.department_id = listgetat(sepet.satir[i].deliver_dept,1,'-')>
                    <cfinclude template="../query/get_department.cfm">
                    <cfset department_head = get_department.DEPARTMENT_HEAD>
                    <!--- Gonderilen location degerinde eksiklikler oldugundan asagidaki sekilde location_id gonderildi FBS 20110914
                        <cfset attributes.department_location = sepet.satir[i].deliver_dept>
                     --->
                    <cfset attributes.location_id = listgetat(sepet.satir[i].deliver_dept,2,'-')>
                    <cfinclude template="../query/get_department_location.cfm">
                    <cfset department_head = "#department_head#-#get_department_location.comment#">
                    <cfelse>
                    <cfset department_head = ''>
                    </cfif>
                    <input type="text" id="basket_row_departman" name="basket_row_departman" value="#DEPARTMENT_HEAD#" class="boxtext" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;">
                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_name=basket_row_departman&field_id=deliver_dept&row_id='+this.parentNode.parentNode.rowIndex,'list')" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                </td>
                </cfcase>
                <cfcase value="deliver_dept_assortment">
                <td  nowrap style="text-align:right;" title="#title_content#"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_department_products&form_name=form_basket&field_name=basket_row_departman&field_id=deliver_dept&row_id='+this.parentNode.parentNode.rowIndex + '&rowCount=' + rowCount+ '&stock_id=#sepet.satir[i].stock_id#','list')" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a> </td>
                </cfcase>
                <cfcase value="shelf_number">
                <cfif StructKeyExists(sepet.satir[i],'shelf_number') and len(sepet.satir[i].shelf_number)>
                    <cfquery name="get_shelf_name" datasource="#dsn3#">
                        SELECT SHELF_CODE,SHELF_TYPE FROM PRODUCT_PLACE WHERE PLACE_STATUS=1 AND PRODUCT_PLACE_ID=#sepet.satir[i].shelf_number#
                    </cfquery>
                    <cfif len(get_shelf_name.SHELF_CODE)>
						<cfif len(get_shelf_name.SHELF_TYPE)>
                            <cfquery name="get_shelf_type" datasource="#DSN#">
                                SELECT * FROM SHELF WHERE SHELF_ID = #get_shelf_name.SHELF_TYPE#
                            </cfquery>
                        </cfif>
                        <cfset temp_shelf_number_ = "#get_shelf_name.SHELF_CODE# - #get_shelf_type.SHELF_NAME#">
                	<cfelse>
                		<cfset temp_shelf_number_ = ''>
                	</cfif>
                <cfelse>
                	<cfset temp_shelf_number_ = ''>
                </cfif>
                <td nowrap title="#title_content#">
                <input type="hidden" id="shelf_number" name="shelf_number" value="<cfif StructKeyExists(sepet.satir[i],'shelf_number')>#sepet.satir[i].shelf_number#</cfif>">
                <input type="text" id="shelf_number_txt" name="shelf_number_txt" onkeyup="get_wrk_shelf(#i-1#, rowCount,'shelf_number','shelf_number_txt');" onfocus="AutoComplete_Create('shelf_number_txt','NAME','NAME','get_shelf_autocomplete','','NAME','shelf_number_txt','form_basket','','');" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#temp_shelf_number_#" class="boxtext">
                <a href="javascript://" onclick="open_shelf_list(this.parentNode.parentNode.rowIndex,rowCount,0,'shelf_number','shelf_number_txt');" ><img src="/images/plus_thin_m.gif" title="<cf_get_lang_main no ='2204.Raf Bilgisi'>" border="0" align="absmiddle"></a> <a href="javascript://" onclick="open_shelf_list(this.parentNode.parentNode.rowIndex,rowCount,1,'shelf_number','shelf_number_txt');"><img src="/images/plus_thin.gif" title="<cf_get_lang_main no ='2205.Raf Dağılım'>" border="0" align="absmiddle"></a></td>
                </cfcase>
                <cfcase value="pbs_code">
                    <cfif StructKeyExists(sepet.satir[i],'pbs_id') and len(sepet.satir[i].pbs_id)>
                        <cfquery name="get_pbs_code" datasource="#dsn3#">
                            SELECT PBS_ID,PBS_CODE FROM SETUP_PBS_CODE WHERE PBS_ID=#sepet.satir[i].pbs_id#
                        </cfquery>
                        <cfset temp_pbs_code = get_pbs_code.pbs_code>
                    <cfelse>
                        <cfset temp_pbs_code = ''>
                    </cfif>
                    <td nowrap title="#title_content#">
                        <input type="hidden" id="pbs_id" name="pbs_id" value="<cfif StructKeyExists(sepet.satir[i],'pbs_id')>#sepet.satir[i].pbs_id#</cfif>">
                        <input type="text" id="pbs_code" name="pbs_code" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#temp_pbs_code#" class="boxtext">
                        <a href="javascript://" onclick="open_pbs_list(this.parentNode.parentNode.rowIndex,rowCount,0,'pbs_id','pbs_code');" ><img src="/images/plus_thin_m.gif" title="PBS" border="0" align="absmiddle"></a>
                    </td>
                </cfcase>
                <cfcase value="shelf_number_2">
                <cfif StructKeyExists(sepet.satir[i],'to_shelf_number') and len(sepet.satir[i].to_shelf_number)>
                <cfquery name="get_shelf_name" datasource="#dsn3#">
                SELECT SHELF_CODE,SHELF_TYPE FROM PRODUCT_PLACE WHERE PLACE_STATUS=1 AND PRODUCT_PLACE_ID=#sepet.satir[i].to_shelf_number#
                </cfquery>
                <cfif len(get_shelf_name.SHELF_CODE)>
                <cfif len(get_shelf_name.SHELF_TYPE)>
                <cfquery name="get_shelf_type" datasource="#DSN#">
                SELECT * FROM SHELF WHERE SHELF_ID = #get_shelf_name.SHELF_TYPE#
                </cfquery>
                </cfif>
                <cfset temp_shelf_number_ = "#get_shelf_name.SHELF_CODE# - #get_shelf_type.SHELF_NAME#">
                <cfelse>
                <cfset temp_shelf_number_ = ''>
                </cfif>
                <cfelse>
                <cfset temp_shelf_number_ = ''>
                </cfif>
                <td nowrap title="#title_content#"><input type="hidden" id="to_shelf_number" name="to_shelf_number" value="<cfif StructKeyExists(sepet.satir[i],'to_shelf_number')>#sepet.satir[i].to_shelf_number#</cfif>">
                <input type="text" id="to_shelf_number_txt" name="to_shelf_number_txt" onkeyup="get_wrk_shelf(#i-1#, rowCount,'to_shelf_number','to_shelf_number_txt');" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#temp_shelf_number_#" class="boxtext">
                <a href="javascript://" onclick="open_shelf_list(this.parentNode.parentNode.rowIndex,rowCount,0,'to_shelf_number','to_shelf_number_txt');" ><img src="/images/plus_thin_m.gif" title="<cf_get_lang_main no ='2204.Raf Bilgisi'>" border="0" align="absmiddle"></a> </td>
                </cfcase>
                <cfcase value="is_parse">
                <td nowrap title="#title_content#"><a href="javascript://" onclick="open_assort(this.parentNode.parentNode.rowIndex-1);"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></td>
                </cfcase>
                <cfcase value="lot_no">
                <td  nowrap style="text-align:right;" title="#title_content#">
                	<input type="text" id="lot_no" name="lot_no" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#sepet.satir[i].lot_no#" onKeyup="lotno_control(#i-1#);" class="boxtext">
                    <a href="javascript://" onclick="open_lot_no_list(this.parentNode.parentNode.rowIndex,rowCount,0,'lot_no');"><img src="/images/plus_thin.gif" style="cursor:pointer;" align="absbottom" border="0"></a>
                </td>
                </cfcase>
                <cfcase value="net_maliyet">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="net_maliyet" name="net_maliyet" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'net_maliyet')>#TLFormat(sepet.satir[i].net_maliyet,price_round_number)#</cfif>" class="box" <cfif listfindnocase(basket_read_only_price_list,'net_maliyet')> readonly='yes'<cfelse> onBlur="if(this.value.length==0) this.value='0,0000';marj_maliyet_hesabi(this.parentNode.parentNode.rowIndex,1,'net_maliyet');" onkeyup="return(FormatCurrency(this,event,price_round_number));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>></td>
                </cfcase>
                <cfcase value="extra_cost">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="extra_cost" name="extra_cost" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'extra_cost')>#TLFormat(wrk_round(sepet.satir[i].extra_cost,price_round_number,1),price_round_number)#</cfif>" class="box" <cfif listfindnocase(basket_read_only_price_list,'extra_cost')> readonly='yes'<cfelse>onBlur="if(this.value.length==0) this.value='0,0000';marj_maliyet_hesabi(this.parentNode.parentNode.rowIndex,1,'extra_cost');" onkeyup="return(FormatCurrency(this,event,price_round_number));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>></td>
                </cfcase>
                <cfcase value="extra_cost_rate">
                <cfif StructKeyExists(sepet.satir[i],'net_maliyet') and len(sepet.satir[i].net_maliyet) and sepet.satir[i].net_maliyet neq 0 and StructKeyExists(sepet.satir[i],'extra_cost') and len(sepet.satir[i].extra_cost)>
                <cfset extra_cost_rate_= (sepet.satir[i].extra_cost/sepet.satir[i].net_maliyet)*100>
                <cfelse>
                <cfset extra_cost_rate_= 0>
                </cfif>
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="extra_cost_rate" name="extra_cost_rate" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(extra_cost_rate_)#" class="box" <cfif listfindnocase(basket_read_only_price_list,'extra_cost_rate')> readonly='yes'<cfelse>onBlur="if(this.value.length==0) this.value='0,00';<cfif ListFindNoCase(display_list,"net_maliyet") and  ListFindNoCase(display_list, "extra_cost")>marj_maliyet_hesabi(this.parentNode.parentNode.rowIndex,1,'extra_cost_rate')</cfif>" onkeyup="return(FormatCurrency(this,event));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>></td>
                </cfcase>
                <cfcase value="row_cost_total">
                <cfset row_cost_total=0>
                <cfif StructKeyExists(sepet.satir[i],'net_maliyet') and len(sepet.satir[i].net_maliyet) and sepet.satir[i].net_maliyet neq 0>
                <cfset row_cost_total=row_cost_total+sepet.satir[i].net_maliyet>
                </cfif>
                <cfif StructKeyExists(sepet.satir[i],'extra_cost') and len(sepet.satir[i].extra_cost) and sepet.satir[i].extra_cost neq 0>
                <cfset row_cost_total=row_cost_total+sepet.satir[i].extra_cost>
                </cfif>
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="row_cost_total" name="row_cost_total" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(row_cost_total,price_round_number)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="marj">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="marj" name="marj" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'marj')>#TLFormat(sepet.satir[i].marj)#</cfif>"class="box" <cfif listfindnocase(basket_read_only_price_list,'marj')> readonly='yes'<cfelse> onBlur="if(this.value.length==0) this.value='0,00';<cfif ListFindNoCase(display_list,"net_maliyet")>marj_maliyet_hesabi(this.parentNode.parentNode.rowIndex,2);</cfif>" onkeyup="return(FormatCurrency(this,event));"</cfif>></td>
                </cfcase>
                <cfcase value="dara">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="dara" name="dara" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'dara')>#AmountFormat(sepet.satir[i].dara,amount_round)#</cfif>" onblur="if(this.value.length==0) this.value='0,00';<cfif ListFindNoCase(display_list,"darali")>dara_miktar_hesabi(this.parentNode.parentNode.rowIndex,2);</cfif>" onkeyup="return(FormatCurrency(this,event,amount_round));" class="box"></td>
                </cfcase>
                <cfcase value="darali">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="darali" name="darali" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'darali')>#AmountFormat(sepet.satir[i].darali,amount_round)#</cfif>" onblur="if(this.value.length==0) this.value='0,00';<cfif ListFindNoCase(display_list,"dara")>dara_miktar_hesabi(this.parentNode.parentNode.rowIndex,1);</cfif>" onkeyup="return(FormatCurrency(this,event,amount_round));" class="box"></td>
                </cfcase>
                <cfcase value="promosyon_yuzde">
                <td  nowrap style="text-align:right;" title="#title_content#"><input id="promosyon_yuzde" name="promosyon_yuzde" type="text" class="box" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" onblur="if(this.value.length==0) this.value='0,00';else if(this.value.length && filterNumBasket(this.value) >= 100) this.value='0,00';hesapla('promosyon_yuzde',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event));" value="<cfif StructKeyExists(sepet.satir[i],'promosyon_yuzde')>#TLFormat(sepet.satir[i].promosyon_yuzde)#</cfif>" onfocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();" autocomplete="off"></td><!---  fbs 20120203 onFocus="if(this.value == '0,00') this.value = '';" --->
                </cfcase>
                <cfcase value="promosyon_maliyet">
                <td   nowrap style="text-align:right;" title="#title_content#"><input id="promosyon_maliyet" name="promosyon_maliyet" type="text" class="box" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" onfocus="if(this.value == '0,0000') this.value = '';" onblur="if(this.value.length==0) this.value='0,0000';" onkeyup="return(FormatCurrency(this,event,price_round_number));" value="<cfif StructKeyExists(sepet.satir[i],'promosyon_maliyet')>#TLFormat(sepet.satir[i].promosyon_maliyet,price_round_number)#</cfif>" autocomplete="off"></td>
                </cfcase>
                <cfcase value="order_currency">
                <td  nowrap style="text-align:right;" title="#title_content#"><select id="order_currency" name="order_currency" style="width:100px;">
                <cfloop from="1" to="#listlen(order_currency_list)#" index="cur_list">
                <option value="#-1*cur_list#" <cfif StructKeyExists(sepet.satir[i],'order_currency') and sepet.satir[i].order_currency eq (-1*cur_list)>selected</cfif>>#ListGetAt(order_currency_list,cur_list,",")#</option>
                </cfloop>
                </select>
                </td>
                </cfcase>
                <cfcase value="reserve_type">
                <td  nowrap style="text-align:right;" title="#title_content#"><select id="reserve_type" name="reserve_type" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;">
                <cfloop from="1" to="#listlen(reserve_type_list)#" index="rsv_i">
                <option value="#-1*rsv_i#" <cfif StructKeyExists(sepet.satir[i],'reserve_type') and sepet.satir[i].reserve_type eq (-1*rsv_i)>selected</cfif>>#ListGetAt(reserve_type_list,rsv_i,",")#</option>
                </cfloop>
                </select>
                </td>
                </cfcase>
                <cfcase value="basket_extra_info">
                <td  nowrap style="text-align:right;" title="#title_content#"><select id="basket_extra_info" name="basket_extra_info" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;">
                <cfloop list="#basket_info_list#" index="info_list">
                <option value="#listfirst(info_list,';')#" <cfif StructKeyExists(sepet.satir[i],'basket_extra_info') and sepet.satir[i].basket_extra_info eq listfirst(info_list,';')>selected</cfif>>#listlast(info_list,";")#</option>
                </cfloop>
                </select>
                </td>
                </cfcase>
                <cfcase value="select_info_extra">
                    <td  nowrap style="text-align:right;" title="#title_content#"><select id="select_info_extra" name="select_info_extra" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;">
                    <cfloop list="#select_info_extra_list#" index="extra_list">
                        <option value="#listfirst(extra_list,';')#" <cfif StructKeyExists(sepet.satir[i],'select_info_extra') and sepet.satir[i].select_info_extra eq listfirst(extra_list,';')>selected</cfif>>#listlast(extra_list,";")#</option>
                    </cfloop>
                    </select>
                    </td>
                </cfcase>
                <cfcase value="detail_info_extra">
                	<cfif StructKeyExists(sepet.satir[i],'detail_info_extra') and (sepet.satir[i].detail_info_extra contains "'" or sepet.satir[i].detail_info_extra contains '"')>
                    	<cfset detail_info_extra_control = replace(replace(sepet.satir[i].detail_info_extra,"'","",'all'),'"','','all')>
                    <cfelseif StructKeyExists(sepet.satir[i],'detail_info_extra')>
                    	<cfset detail_info_extra_control = sepet.satir[i].detail_info_extra>
                    </cfif>
                	<td nowrap style="text-align:right;" title="#title_content#"><input type="text" id="detail_info_extra" name="detail_info_extra" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" value="<cfif StructKeyExists(sepet.satir[i],'detail_info_extra') and len(sepet.satir[i].detail_info_extra)>#detail_info_extra_control#</cfif>"></td>
                </cfcase>

                <cfcase value="basket_employee">
                <td  nowrap style="text-align:right;" title="#title_content#">
                <input type="hidden" id="basket_employee_id" name="basket_employee_id" value="<cfif StructKeyExists(sepet.satir[i],'basket_employee_id') and len(sepet.satir[i].basket_employee_id)>#sepet.satir[i].basket_employee_id#</cfif>">
                <input type="text" id="basket_employee" name="basket_employee" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" value="<cfif StructKeyExists(sepet.satir[i],'basket_employee') and len(sepet.satir[i].basket_employee)>#sepet.satir[i].basket_employee#</cfif>">
                <a href="javascript://" onclick="open_basket_employee_popup(this.parentNode.parentNode.rowIndex-1);"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                </td>
                </cfcase>
                <cfcase value="row_width">
                <td nowrap title="#title_content#"><input type="text" id="row_width" name="row_width" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_width') and len(sepet.satir[i].row_width)>#TLFormat(sepet.satir[i].row_width,2)#</cfif>" class="box"  <cfif listfindnocase(basket_read_only_price_list,'row_width')> readonly='readonly'<cfelse>onkeyup="return(FormatCurrency(this,event,2));"</cfif>></td>
                </cfcase>
                <cfcase value="row_depth">
                <td nowrap title="#title_content#"><input type="text" id="row_depth" name="row_depth" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_depth') and len(sepet.satir[i].row_depth)>#TLFormat(sepet.satir[i].row_depth,2)#</cfif>" class="box" <cfif listfindnocase(basket_read_only_price_list,'row_depth')> readonly='readonly'<cfelse>onkeyup="return(FormatCurrency(this,event,2));"</cfif>></td>
                </cfcase>
                <cfcase value="row_height">
                <td nowrap title="#title_content#"><input type="text" id="row_height" name="row_height" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_height') and len(sepet.satir[i].row_height)>#TLFormat(sepet.satir[i].row_height,2)#</cfif>" class="box" <cfif listfindnocase(basket_read_only_price_list,'row_height')> readonly='readonly'<cfelse>onkeyup="return(FormatCurrency(this,event,2));"</cfif>></td>
                </cfcase>
                <cfcase value="basket_project">
                <td nowrap title="#title_content#"><input type="hidden" id="row_project_id" name="row_project_id" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_project_id') and len(sepet.satir[i].row_project_id)>#sepet.satir[i].row_project_id#</cfif>" >
                <input type="text" id="row_project_name" name="row_project_name" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_project_name') and len(sepet.satir[i].row_project_name)>#sepet.satir[i].row_project_name#</cfif>" class="boxtext" <cfif listfindnocase(basket_read_only_price_list,'row_project_name')> readonly='yes'</cfif>>
                <a href="javascript://" onclick="open_basket_project_popup(this.parentNode.parentNode.rowIndex-1);"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                </td>
                </cfcase>
                <cfcase value="basket_work">
                    <td nowrap title="#title_content#">
                    <input type="hidden" id="row_work_id" name="row_work_id" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_work_id') and len(sepet.satir[i].row_work_id)>#sepet.satir[i].row_work_id#</cfif>" >
                    <input type="text" id="row_work_name" name="row_work_name" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_work_name') and len(sepet.satir[i].row_work_name)>#sepet.satir[i].row_work_name#</cfif>" class="boxtext" <cfif listfindnocase(basket_read_only_price_list,'row_work_name')> readonly='yes'</cfif>>
                    <a href="javascript://" onclick="open_basket_work_popup(this.parentNode.parentNode.rowIndex-1);"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                    </td>
                </cfcase>
                <!--- alis faturalari masraf merkezi, butce kalemi ve muhasebe kodu eklendi --->
                <cfcase value="basket_exp_center">
                    <td nowrap title="#title_content#">
                    <input type="hidden" id="row_exp_center_id" name="row_exp_center_id" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_exp_center_id') and len(sepet.satir[i].row_exp_center_id)>#sepet.satir[i].row_exp_center_id#</cfif>" >
                    <input type="text" id="row_exp_center_name" name="row_exp_center_name" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_exp_center_name') and len(sepet.satir[i].row_exp_center_name)>#sepet.satir[i].row_exp_center_name#</cfif>" class="boxtext" <cfif listfindnocase(basket_read_only_price_list,'row_exp_center_name')> readonly='yes'</cfif>>
                    <a href="javascript://" onclick="open_basket_exp_center_popup(this.parentNode.parentNode.rowIndex-1);"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                    </td>
                </cfcase>
                <cfcase value="basket_exp_item">
                    <td nowrap title="#title_content#">
                    <input type="hidden" id="row_exp_item_id" name="row_exp_item_id" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_exp_item_id') and len(sepet.satir[i].row_exp_item_id)>#sepet.satir[i].row_exp_item_id#</cfif>" >
                    <input type="text" id="row_exp_item_name" name="row_exp_item_name" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_exp_item_name') and len(sepet.satir[i].row_exp_item_name)>#sepet.satir[i].row_exp_item_name#</cfif>" class="box" <cfif listfindnocase(basket_read_only_price_list,'row_exp_item_name')> readonly='yes'</cfif>>
                    <a href="javascript://" onclick="open_basket_exp_item_popup(this.parentNode.parentNode.rowIndex-1);"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                    </td>
                </cfcase>
                <cfcase value="basket_acc_code">
                    <td nowrap title="#title_content#">
                    <input type="text" id="row_acc_code" name="row_acc_code" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_acc_code') and len(sepet.satir[i].row_acc_code)>#sepet.satir[i].row_acc_code#</cfif>" class="boxtext" <cfif listfindnocase(basket_read_only_price_list,'row_acc_code')> readonly='yes'</cfif>>
                    <a href="javascript://" onclick="open_basket_acc_code_popup(this.parentNode.parentNode.rowIndex-1);"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                    </td>
                </cfcase>
                </cfswitch>
                <cfelse>
                <!--- sadece readonly gorunen satırlar --->
                <cfswitch expression="#element#">
                <cfcase value="stock_code">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="stock_code" name="stock_code" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" value="#sepet.satir[i].stock_code#"  readonly='yes'></td>
                </cfcase>
                <cfcase value="barcod">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="barcod" name="barcod" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" value="#sepet.satir[i].barcode#"  readonly='yes'></td>
                </cfcase>
                <cfcase value="special_code">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="special_code" name="special_code" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" value="#sepet.satir[i].special_code#"  readonly='yes'></td>
                </cfcase>
                <cfcase value="manufact_code">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="manufact_code" name="manufact_code" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" value="#sepet.satir[i].manufact_code#"  readonly='yes'></td>
                </cfcase>
                <cfcase value="product_name">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="product_name" name="product_name" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" value="#sepet.satir[i].product_name#"  readonly='yes'>
                <a href="javascript://" id="product_popup_#i#" onclick="open_product_popup(this.parentNode.parentNode.rowIndex);"><img src="/images/plus_thin.gif" title="<cf_get_lang_main no='308.Ürün Detayları İçin Tıklayınız'>" border="0" align="absmiddle"></a>
                <cfif get_module_user(5)>
                <a href="javascript://" id="product_price_history_#i#" onclick="open_product_price_history(this.parentNode.parentNode.rowIndex);"><img src="/images/plus_thin_p.gif" title="<cf_get_lang_main no='309.Ürün Fiyat Tarihçe'>" border="0" align="absmiddle"></a>
                </cfif>
                </td>
                </cfcase>
                <cfcase value="amount">
                <td nowrap title="#title_content#"><input type="text" id="amount" name="amount" <cfif StructKeyExists(sepet.satir[i],'row_unique_relation_id') and len(sepet.satir[i].row_unique_relation_id)>readonly="yes"</cfif> value="#AmountFormat(sepet.satir[i].amount,amount_round)#" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="unit">
                <td nowrap title="#title_content#"><input type="Text" id="unit" name="unit" value="#sepet.satir[i].unit#" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext"  readonly='yes'></td>
                </cfcase>
                <cfcase value="product_name2">
                <td nowrap style="text-align:right;" title="#title_content#"><input type="text" id="product_name_other" name="product_name_other" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" value="<cfif StructKeyExists(sepet.satir[i],'product_name_other') and len(sepet.satir[i].product_name_other)>#sepet.satir[i].product_name_other#</cfif>" readonly='yes'></td>
                </cfcase>
                <cfcase value="amount2">
                <td nowrap title="#title_content#"><input type="text" id="amount_other" name="amount_other" value="<cfif StructKeyExists(sepet.satir[i],'amount_other') and len(sepet.satir[i].amount_other)>#TLFormat(sepet.satir[i].amount_other,price_round_number)#</cfif>" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="unit2">
                <td nowrap title="#title_content#"><input type="Text" id="unit_other" name="unit_other" maxlength="5" value="<cfif StructKeyExists(sepet.satir[i],'unit_other') and len(sepet.satir[i].unit_other)>#sepet.satir[i].unit_other#</cfif>" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" readonly='yes'></td>
                </cfcase>
                <cfcase value="spec">
                <input type="hidden" id="spect_id" name="spect_id" value="#sepet.satir[i].spect_id#">
                <td nowrap title="#title_content#"><input type="Text" id="spect_name" name="spect_name" value="#sepet.satir[i].spect_name#" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" readonly=yes>
                <cfif len(sepet.satir[i].spect_id)>
                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_spec&is_spec=1&id=#sepet.satir[i].spect_id#','medium');"><img src="/images/plus_thin_p.gif" align="absmiddle" border="0" title="#sepet.satir[i].spect_id#"></a>
                </cfif>
                </td>
                </cfcase>
                <cfcase value="list_price">
                <td nowrap title="#title_content#"><input type="text" id="list_price" name="list_price" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'list_price')>#TLFormat(sepet.satir[i].list_price,price_round_number)#</cfif>" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="list_price_discount">
                <!--- liste fiyatı uzerinden net maliyeti hesaplamak ıcın kullanılır --->
                <cfif StructKeyExists(sepet.satir[i],'list_price') and len(sepet.satir[i].list_price) and sepet.satir[i].list_price neq 0 and StructKeyExists(sepet.satir[i],'net_maliyet') and len(sepet.satir[i].net_maliyet)>
                <cfset list_price_discount=100-((sepet.satir[i].net_maliyet*100)/sepet.satir[i].list_price)>
                <cfelse>
                <cfset list_price_discount=0>
                </cfif>
                <td nowrap title="#title_content#"><input type="text" id="list_price_discount" name="list_price_discount" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(list_price_discount)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="tax_price">
                <td nowrap title="#title_content#"><input type="text" id="tax_price" name="tax_price" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].row_lasttotal/sepet.satir[i].amount,price_round_number)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="price">
                <td nowrap title="#title_content#"><input type="text" id="price" name="price" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].price,price_round_number)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="price_other">
                <td nowrap title="#title_content#"><input type="text" id="price_other" name="price_other" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].price_other,price_round_number)#" class="box"  readonly='yes'></td>
                </cfcase>
                <cfcase value="price_net">
                <td nowrap title="#title_content#"><cfset float_price_net = sepet.satir[i].row_nettotal/sepet.satir[i].amount>
                <input type="text" id="price_net" name="price_net" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(float_price_net,price_round_number)#" class="box" readonly=yes></td>
                </cfcase>
                <cfcase value="price_net_doviz">
                <td nowrap title="#title_content#"><cfset float_price_net_doviz = (sepet.satir[i].row_nettotal/sepet.satir[i].amount)*fl_total_2/fl_total>
                <input type="text" id="price_net_doviz" name="price_net_doviz" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(float_price_net_doviz,price_round_number)#" class="box" readonly=yes>
                </td>
                </cfcase>
                <cfcase value="tax">
                <td nowrap title="#title_content#"><input type="text" id="tax" name="tax" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].tax_percent,0)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="OTV">
                <td nowrap title="#title_content#"><input type="text" id="otv_oran" name="otv_oran" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'otv_oran')>#TLFormat(sepet.satir[i].otv_oran,0)#</cfif>" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="duedate">
                <td nowrap title="#title_content#"><input type="text" id="duedate" name="duedate" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#sepet.satir[i].duedate#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="number_of_installment">
                <td nowrap title="#title_content#"><input type="text" id="number_of_installment" name="number_of_installment" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyexists(sepet.satir[i],'number_of_installment')>#sepet.satir[i].number_of_installment#</cfif>" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="iskonto_tutar">
                <td nowrap title="#title_content#"><input type="text" id="iskonto_tutar" name="iskonto_tutar" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'iskonto_tutar')>#TLFormat(sepet.satir[i].iskonto_tutar,price_round_number)#</cfif>" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="ek_tutar">
                <td nowrap title="#title_content#"><input type="text" id="ek_tutar" name="ek_tutar" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'ek_tutar')>#TLFormat(sepet.satir[i].ek_tutar,price_round_number)#</cfif>" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="ek_tutar_price">
                <td nowrap title="#title_content#"><input type="text" id="ek_tutar_price" name="ek_tutar_price" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'ek_tutar_price')>#TLFormat(sepet.satir[i].ek_tutar_price,price_round_number)#</cfif>" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="ek_tutar_other_total">
                <td nowrap title="#title_content#"><input type="text" id="ek_tutar_other_total" name="ek_tutar_other_total" value="<cfif StructKeyExists(sepet.satir[i],'ek_tutar_other_total') and len(sepet.satir[i].ek_tutar_other_total)>#TLFormat(sepet.satir[i].ek_tutar_other_total,price_round_number)#</cfif>" class="box"  readonly='yes'></td>
                </cfcase>
                <cfcase value="ek_tutar_cost">
                <td nowrap title="#title_content#"><input type="text" id="ek_tutar_cost" name="ek_tutar_cost" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'ek_tutar_cost')>#TLFormat(sepet.satir[i].ek_tutar_cost,price_round_number)#</cfif>" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="ek_tutar_marj">
                <td nowrap title="#title_content#"><input type="text" id="ek_tutar_marj" name="ek_tutar_marj" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'ek_tutar_marj')>#TLFormat(sepet.satir[i].ek_tutar_marj,2)#</cfif>" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="disc_ount">
                <td nowrap title="#title_content#"><input type="text" id="indirim1" name="indirim1" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].indirim1)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="disc_ount2_">
                <td nowrap title="#title_content#"><input type="text" id="indirim2" name="indirim2" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].indirim2)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="disc_ount3_">
                <td nowrap title="#title_content#"><input type="text" id="indirim3" name="indirim3" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].indirim3)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="disc_ount4_">
                <td nowrap title="#title_content#"><input type="text" id="indirim4" name="indirim4" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].indirim4)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="disc_ount5_">
                <td nowrap title="#title_content#"><input type="text" id="indirim5" name="indirim5" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].indirim5)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="disc_ount6_">
                <td nowrap title="#title_content#"><input type="text" id="indirim6" name="indirim6" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].indirim6)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="disc_ount7_">
                <td nowrap title="#title_content#"><input type="text" id="indirim7" name="indirim7" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].indirim7)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="disc_ount8_">
                <td nowrap title="#title_content#"><input type="text" id="indirim8" name="indirim8" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].indirim8)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="disc_ount9_">
                <td nowrap title="#title_content#"><input type="text" id="indirim9" name="indirim9" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].indirim9)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="disc_ount10_">
                <td nowrap title="#title_content#"><input type="text" id="indirim10" name="indirim10" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].indirim10)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="row_total">
                <td nowrap title="#title_content#"><input type="text" id="row_total" name="row_total" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].row_total,price_round_number)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="row_nettotal">
                <td nowrap title="#title_content#"><input type="text" id="row_nettotal" name="row_nettotal" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].row_nettotal,price_round_number)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="row_taxtotal">
                <td nowrap title="#title_content#"><input type="text" id="row_taxtotal" name="row_taxtotal" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].row_taxtotal,price_round_number)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="row_otvtotal">
                <td nowrap title="#title_content#"><input type="text" id="row_otvtotal" name="row_otvtotal" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_otvtotal')>#TLFormat(sepet.satir[i].row_otvtotal,price_round_number)#</cfif>" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="row_lasttotal">
                <td nowrap title="#title_content#"><input type="text" id="row_lasttotal" name="row_lasttotal" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].row_lasttotal,price_round_number)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="other_money">
                <td  nowrap style="text-align:right;" title="#title_content#">
                <select id="other_money_" name="other_money_" style="width:50px;" onchange="hesapla('other_money_',this.parentNode.parentNode.rowIndex);">
                <cfloop query="get_money_bskt">
                <option value="#money_type#"<cfif sepet.satir[i].other_money eq money_type> selected</cfif>>#money_type#</option>
                </cfloop>
                </select>
                <!---<select id="other_money_" name="other_money_" style="width:50px;">
                <option value="#sepet.satir[i].other_money#">#sepet.satir[i].other_money#</option>
                </select>---> <!--- Admin yetkisi olmayan kullanicilarda hataya sebep oluyordu diye kapatildi . E.Y 20130107 --->
                </td>
                </cfcase>
                <cfcase value="other_money_value">
                <td  nowrap style="text-align:right;" title="#title_content#"><cfif isdefined("fl_total")>
                <cfset fl_other_money = sepet.satir[i].row_nettotal*fl_total_2/fl_total>
                <cfelse>
                <cfset fl_other_money = sepet.satir[i].other_money_value>
                </cfif>
                <cfif fl_other_money is "">
                <cfset fl_other_money = sepet.satir[i].price>
                </cfif>
                <cfif StructKeyExists(sepet.satir[i],'otv_oran')>
                <cfif ListFindNoCase(display_list, "otv_from_tax_price")>
                <!---otv kdv matrahına ekleniyorsa --->
                <cfset sepet.satir[i].other_money_grosstotal = (fl_other_money*((sepet.satir[i].tax_percent + (sepet.satir[i].otv_oran*(sepet.satir[i].tax_percent/100)))+sepet.satir[i].otv_oran+100))/100>
                <cfelse>
                <cfset sepet.satir[i].other_money_grosstotal = (fl_other_money*(sepet.satir[i].tax_percent+sepet.satir[i].otv_oran+100))/100>
                </cfif>
                <cfelse>
                <cfset sepet.satir[i].other_money_grosstotal = (fl_other_money*(sepet.satir[i].tax_percent+100))/100>
                </cfif>
                <input type="text" id="other_money_value_" name="other_money_value_" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(sepet.satir[i].other_money_value,price_round_number)#" class="box" readonly='yes'>
                </td>
                </cfcase>
                <cfcase value="other_money_gross_total">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="other_money_gross_total" name="other_money_gross_total" value="<cfif StructKeyExists(sepet.satir[i],'other_money_grosstotal')>#TLFormat(sepet.satir[i].other_money_grosstotal,price_round_number)#</cfif>" class="box" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" readonly=yes></td>
                </cfcase>
                <cfcase value="deliver_date">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="deliver_date" name="deliver_date" value="#sepet.satir[i].deliver_date#" class="boxtext" maxlength="10" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" readonly='yes'>
                </td>
                </cfcase>
                <cfcase value="reserve_date">
                <td  nowrap id="reserve_date_td" style="text-align:right;" title="#title_content#"><input type="text" id="reserve_date" name="reserve_date" value="<cfif StructKeyExists(sepet.satir[i],'reserve_date')>#sepet.satir[i].reserve_date#</cfif>" class="boxtext" maxlength="10" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" readonly='yes'>
                </td>
                </cfcase>
                <cfcase value="deliver_dept">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="hidden" id="deliver_dept" name="deliver_dept" value="<cfif len(sepet.satir[i].deliver_dept)>#sepet.satir[i].deliver_dept#</cfif>">
                <cfif len(listsort(sepet.satir[i].deliver_dept,"Text","asc","-"))>
                <cfset attributes.department_id = listgetat(sepet.satir[i].deliver_dept,1,"-")>
                <cfif len(trim(attributes.department_id))>
                <cfif listlen(attributes.department_id,"-") eq 2>
                <!--- sepet.satir[i].deliver_dept --->
                <cfset attributes.department_location = attributes.department_id>
                <!--- sepet.satir[i].deliver_dept --->
                <cfinclude template="../query/get_department_location.cfm">
                <cfset department_head = "#department_head#-#get_department_location.comment#">
                <cfelse>
                <cfinclude template="../query/get_department.cfm">
                <cfset department_head = get_department.DEPARTMENT_HEAD>
                </cfif>
                <cfelse>
                <cfset department_head = ''>
                </cfif>
                <cfelse>
                <cfset department_head = ''>
                </cfif>
                <input type="text" id="basket_row_departman" name="basket_row_departman" value="#DEPARTMENT_HEAD#" class="boxtext" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" readonly='yes'>
                </td>
                </cfcase>
                <cfcase value="shelf_number">
                <cfif StructKeyExists(sepet.satir[i],'shelf_number') and len(sepet.satir[i].shelf_number)>
                <cfquery name="get_shelf_name" datasource="#dsn3#">
                SELECT SHELF_CODE FROM PRODUCT_PLACE WHERE PLACE_STATUS=1 AND PRODUCT_PLACE_ID=#sepet.satir[i].shelf_number#
                </cfquery>
                <cfif len(get_shelf_name.SHELF_CODE)>
                <cfset temp_shelf_number_ = get_shelf_name.SHELF_CODE>
                <cfelse>
                <cfset temp_shelf_number_ = ''>
                </cfif>
                <cfelse>
                <cfset temp_shelf_number_ = ''>
                </cfif>
                <td nowrap title="#title_content#"><input type="hidden" id="shelf_number" name="shelf_number" value="<cfif StructKeyExists(sepet.satir[i],'shelf_number')>#sepet.satir[i].shelf_number#</cfif>">
                <input type="text" id="shelf_number_txt" name="shelf_number_txt" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#temp_shelf_number_#" class="boxtext" readonly='yes'>
                </td>
                </cfcase>
                <cfcase value="pbs_code">
                    <cfif StructKeyExists(sepet.satir[i],'pbs_id') and len(sepet.satir[i].pbs_id)>
                        <cfquery name="get_pbs_code" datasource="#dsn3#">
                            SELECT PBS_ID,PBS_CODE FROM SETUP_PBS_CODE WHERE PBS_ID=#sepet.satir[i].pbs_id#
                        </cfquery>
                        <cfset temp_pbs_code = get_pbs_code.pbs_code>
                    <cfelse>
                        <cfset temp_pbs_code = ''>
                    </cfif>
                    <td nowrap title="#title_content#">
                        <input type="hidden" id="pbs_id" name="pbs_id" value="<cfif StructKeyExists(sepet.satir[i],'pbs_id')>#sepet.satir[i].pbs_id#</cfif>">
                        <input type="text" id="pbs_code" name="pbs_code" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#temp_pbs_code#" class="boxtext">
                        <a href="javascript://" onclick="open_pbs_list(this.parentNode.parentNode.rowIndex,rowCount,0,'pbs_id','pbs_code');" ><img src="/images/plus_thin_m.gif" title="PBS" border="0" align="absmiddle"></a>
                    </td>
                </cfcase>
                <cfcase value="shelf_number_2">
                <cfif StructKeyExists(sepet.satir[i],'to_shelf_number') and len(sepet.satir[i].to_shelf_number)>
                <cfquery name="get_shelf_name" datasource="#dsn3#">
                SELECT SHELF_CODE FROM PRODUCT_PLACE WHERE PLACE_STATUS=1 AND PRODUCT_PLACE_ID=#sepet.satir[i].to_shelf_number#
                </cfquery>
                <cfif len(get_shelf_name.SHELF_CODE)>
                <cfset to_shelf_number_ = get_shelf_name.SHELF_CODE>
                <cfelse>
                <cfset to_shelf_number_ = ''>
                </cfif>
                <cfelse>
                <cfset to_shelf_number_ = ''>
                </cfif>
                <td nowrap title="#title_content#"><input type="hidden" id="to_shelf_number" name="to_shelf_number" value="<cfif StructKeyExists(sepet.satir[i],'to_shelf_number')>#sepet.satir[i].to_shelf_number#</cfif>">
                <input type="text" id="to_shelf_number_txt" name="to_shelf_number_txt" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#to_shelf_number_#" class="boxtext" readonly="yes">
                </td>
                </cfcase>
                <cfcase value="lot_no">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" maxlength="150" id="lot_no" name="lot_no" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#sepet.satir[i].lot_no#" class="boxtext" readonly='yes'></td>
                </cfcase>
                <cfcase value="net_maliyet">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="net_maliyet" name="net_maliyet" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'net_maliyet')>#TLFormat(sepet.satir[i].net_maliyet,price_round_number)#</cfif>" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="extra_cost">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="extra_cost" name="extra_cost" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'extra_cost')>#TLFormat(wrk_round(sepet.satir[i].extra_cost,price_round_number,1),price_round_number)#</cfif>" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="extra_cost_rate">
                <cfif StructKeyExists(sepet.satir[i],'net_maliyet') and len(sepet.satir[i].net_maliyet) and sepet.satir[i].net_maliyet neq 0 and StructKeyExists(sepet.satir[i],'extra_cost') and len(sepet.satir[i].extra_cost)>
                <cfset extra_cost_rate_= (sepet.satir[i].extra_cost/sepet.satir[i].net_maliyet)*100>
                <cfelse>
                <cfset extra_cost_rate_= 0>
                </cfif>
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="extra_cost_rate" name="extra_cost_rate" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(extra_cost_rate_)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="row_cost_total">
                <cfset row_cost_total=0>
                <cfif StructKeyExists(sepet.satir[i],'net_maliyet') and len(sepet.satir[i].net_maliyet) and sepet.satir[i].net_maliyet neq 0>
                <cfset row_cost_total=row_cost_total+sepet.satir[i].net_maliyet>
                </cfif>
                <cfif StructKeyExists(sepet.satir[i],'extra_cost') and len(sepet.satir[i].extra_cost) and sepet.satir[i].extra_cost neq 0>
                <cfset row_cost_total=row_cost_total+sepet.satir[i].extra_cost>
                </cfif>
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="row_cost_total" name="row_cost_total" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="#TLFormat(row_cost_total,price_round_number)#" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="marj">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="marj" name="marj" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'marj')>#TLFormat(sepet.satir[i].marj)#</cfif>" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="dara">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="dara" name="dara" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'dara')>#AmountFormat(sepet.satir[i].dara,amount_round)#</cfif>" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="darali">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="darali" name="darali" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'darali')>#AmountFormat(sepet.satir[i].darali,amount_round)#</cfif>" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="promosyon_yuzde">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="promosyon_yuzde" name="promosyon_yuzde" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'promosyon_yuzde')>#TLFormat(sepet.satir[i].promosyon_yuzde)#</cfif>" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="promosyon_maliyet">
                <td  nowrap style="text-align:right;" title="#title_content#"><input type="text" id="promosyon_maliyet" name="promosyon_maliyet" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'promosyon_maliyet')>#TLFormat(sepet.satir[i].promosyon_maliyet,price_round_number)#</cfif>" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="order_currency">
                <td nowrap title="#title_content#"><select id="order_currency" name="order_currency" style="width:100px;">
                <cfif StructKeyExists(sepet.satir[i],'order_currency') and len(sepet.satir[i].order_currency) and sepet.satir[i].order_currency eq -5 >
                <cfloop from="1" to="#listlen(order_currency_list)#" index="cur_list">
                <option value="#-1*cur_list#" <cfif StructKeyExists(sepet.satir[i],'order_currency') and sepet.satir[i].order_currency eq (-1*cur_list)>selected</cfif>>#ListGetAt(order_currency_list,cur_list,",")#</option>
                </cfloop>
                <cfelse>
                <option value="#sepet.satir[i].order_currency#">#ListGetAt(order_currency_list,(-1*sepet.satir[i].order_currency),",")#</option>
                </cfif>
                </select>
                </td>
                </cfcase>
                <cfcase value="reserve_type">
                <td nowrap title="#title_content#"><select id="reserve_type" name="reserve_type" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;">
                <cfif StructKeyExists(sepet.satir[i],'reserve_type')>
                <option value="#sepet.satir[i].reserve_type#">#ListGetAt(reserve_type_list,(-1*sepet.satir[i].reserve_type),",")#</option>
                </cfif>
                </select>
                </td>
                </cfcase>
                <cfcase value="basket_extra_info">
                <td nowrap title="#title_content#"><select id="basket_extra_info" name="basket_extra_info" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;">
                <cfloop list="#basket_info_list#" index="info_list">
                <option value="#listfirst(info_list,';')#" <cfif StructKeyExists(sepet.satir[i],'basket_extra_info') and sepet.satir[i].basket_extra_info eq listfirst(info_list,';')>selected</cfif>>#listlast(info_list,";")#</option>
                </cfloop>
                </select>
                </td>
                </cfcase>
                <cfcase value="select_info_extra">
                    <td nowrap title="#title_content#"><select id="select_info_extra" name="select_info_extra" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;">
                    <cfloop list="#select_info_extra_list#" index="extra_list">
                        <option value="#listfirst(extra_list,';')#" <cfif StructKeyExists(sepet.satir[i],'select_info_extra') and sepet.satir[i].select_info_extra eq listfirst(extra_list,';')>selected</cfif>>#listlast(extra_list,";")#</option>
                    </cfloop>
                    </select>
                    </td>
                </cfcase>
                <cfcase value="detail_info_extra">
                    <td nowrap style="text-align:right;" title="#title_content#"><input type="text" id="detail_info_extra" name="detail_info_extra" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" value="<cfif StructKeyExists(sepet.satir[i],'detail_info_extra') and len(sepet.satir[i].detail_info_extra)>#sepet.satir[i].detail_info_extra#</cfif>" readonly='yes'></td>
                </cfcase>
                <cfcase value="basket_employee">
                <td nowrap title="#title_content#"><input type="hidden" id="basket_employee_id" name="basket_employee_id" value="<cfif StructKeyExists(sepet.satir[i],'basket_employee_id') and len(sepet.satir[i].basket_employee_id)>#sepet.satir[i].basket_employee_id#</cfif>">
                <input type="text" id="basket_employee" name="basket_employee" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" value="<cfif StructKeyExists(sepet.satir[i],'basket_employee') and len(sepet.satir[i].basket_employee)>#sepet.satir[i].basket_employee#</cfif>" readonly='yes'>
                </td>
                </cfcase>
                <cfcase value="row_width">
                <td nowrap title="#title_content#"><input type="text" id="row_width" name="row_width" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_width') and len(sepet.satir[i].row_width)>#TLFormat(sepet.satir[i].row_width,2)#</cfif>" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="row_depth">
                <td nowrap title="#title_content#"><input type="text" id="row_depth" name="row_depth" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_depth') and len(sepet.satir[i].row_depth)>#TLFormat(sepet.satir[i].row_depth,2)#</cfif>" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="row_height">
                <td nowrap title="#title_content#"><input type="text" id="row_height" name="row_height" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_height') and len(sepet.satir[i].row_height)>#TLFormat(sepet.satir[i].row_height,2)#</cfif>" class="box" readonly='yes'></td>
                </cfcase>
                <cfcase value="basket_project">
                <td nowrap title="#title_content#"><input type="hidden" id="row_project_id" name="row_project_id" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_project_id') and len(sepet.satir[i].row_project_id)>#sepet.satir[i].row_project_id#</cfif>" >
                <input type="text" id="row_project_name" name="row_project_name" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_project_name') and len(sepet.satir[i].row_project_name)>#sepet.satir[i].row_project_name#</cfif>" class="box" readonly='yes'>
                </td>
                </cfcase>
                <cfcase value="basket_work">
                    <td nowrap title="#title_content#">
                    <input type="hidden" id="row_work_id" name="row_work_id" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_work_id') and len(sepet.satir[i].row_work_id)>#sepet.satir[i].row_work_id#</cfif>" >
                    <input type="text" id="row_work_name" name="row_work_name" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="<cfif StructKeyExists(sepet.satir[i],'row_work_name') and len(sepet.satir[i].row_work_name)>#sepet.satir[i].row_work_name#</cfif>" class="box"readonly='yes'>
                    </td>
                </cfcase>
                </cfswitch>
                </cfif>
                </cfloop>
                </tr>
                </cfoutput>
                </cfsavecontent>
                <cfoutput>#replace(basket_rows_clear,'#CRLF##CRLF#','','all')#</cfoutput>
                </cfloop>
            </table>
           </div>
		</td>
	</tr>
<cfif not ListFindNoCase(display_list, "price_total")>
	<cfset total_table_display_ = "none">
<cfelse>
	<cfset total_table_display_ = "">
</cfif>
	<tr id="sepetim_total_table_tutar_tr" style="display:<cfoutput>#total_table_display_#</cfoutput>;">
		<td><cfinclude template="dsp_basket_total_js_view.cfm"></td>
	</tr>
</table>
<script>
function basket_set_height()
{
	h1 = AutoComplete_GetTop(document.getElementById('sepetim'));
	h2 = document.body.clientHeight;
<cfif not ListFindNoCase(display_list, "price_total")>
	b_special_height = h2 - h1 - 45;
<cfelse>
	b_special_height = h2 - h1 - 144;
</cfif>
	if(b_special_height < 100)
		b_special_height = 100;
	document.getElementById('sepetim').style.height = b_special_height + 'px';
}
basket_set_height();
</script>
</cfprocessingdirective>
