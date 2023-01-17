<!---E.A 09.07.2012 --->
<cfparam name="attributes.price_catid" default = "-1">
<cfparam name="attributes.consumer_id" default = "">
<cfparam name="attributes.company_id" default = "">
<cfparam name="attributes.int_basket_id" default = "">
<cfparam name="attributes.keyword" default = "">
<cfparam name="attributes.manufact_code" default = "">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.get_company_id" default="">
<cfparam name="attributes.get_company" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="0">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.stock_code" default="">
<cfparam name="attributes.stock_code2" default="">
<cfparam name="attributes.barcod" default="">
<cfif isdefined("xml_sort_type")>
	<cfparam name="attributes.sort_type" default="#xml_sort_type#">
<cfelse>
	<cfparam name="attributes.sort_type" default="0">
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif not (isDefined('attributes.amount_multiplier') and isnumeric(attributes.amount_multiplier) and attributes.amount_multiplier gt 0)>
	<cfset attributes.amount_multiplier = 1>
</cfif>
<cfif not len(attributes.get_company_id) and len(attributes.company_id) and not isdefined("attributes.form_submitted")>
	<cfset attributes.get_company_id = attributes.company_id> <!--- islemde secilen cari tedarikci olarak atanıyor, boylece sadece secilen carinin urunleri getiriliyor --->
	<cfset attributes.get_company =get_par_info(attributes.company_id,1,1,0)>
</cfif>
<cfinclude template="../query/get_moneys.cfm">
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_products_strategy.cfm">
<cfelse>
	<cfset products.recordcount = 0 >
</cfif>
<cfinclude template="../query/get_default_money.cfm">
<cfinclude template="../query/get_price_cats.cfm">
<cfif products.recordcount>
<cfparam name="attributes.totalrecords" default="#products.query_count#">
<cfelse>
<cfparam name="attributes.totalrecords" default="#products.recordcount#">
</cfif>
<cfset url_str = "">
<cfif isdefined("attributes.update_product_row_id")>
	<cfset url_str = "#url_str#&update_product_row_id=#attributes.update_product_row_id#">
</cfif>
<cfif isdefined("module_name")>
	<cfset url_str = "#url_str#&module_name=#module_name#">
</cfif>
<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>
<cfif isdefined("attributes.int_basket_id")>
	<cfset url_str = "#url_str#&int_basket_id=#attributes.int_basket_id#">
</cfif>
<cfif isDefined("attributes.company_id")>
	<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
</cfif>
<cfif isDefined("attributes.consumer_id")>
	<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
</cfif>
<cfif isdefined("sepet_process_type")>
	<cfset url_str = "#url_str#&sepet_process_type=#sepet_process_type#">
</cfif>
<cfif isdefined("attributes.is_cost")>
	<cfset url_str = "#url_str#&is_cost=#attributes.is_cost#">
</cfif>
<cfif isdefined("sepet_process_type") and sepet_process_type neq 140>
	<cfset url_str = "#url_str#&sepet_process_type=#sepet_process_type#">
</cfif>
<cfif isdefined("attributes.is_store_module")>
	<cfset url_str = "#url_str#&is_store_module=#attributes.is_store_module#">
</cfif>
<cfif isdefined('attributes.department_out') and len(attributes.department_out)>
	<cfset url_str = "#url_str#&department_out=#attributes.department_out#">
</cfif>
<cfif isdefined('attributes.location_out') and len(attributes.location_out)>
	<cfset url_str = "#url_str#&location_out=#attributes.location_out#">
</cfif>
<cfif isdefined('attributes.department_in') and len(attributes.department_in)>
	<cfset url_str = "#url_str#&department_in=#attributes.department_in#">
</cfif>
<cfif isdefined('attributes.location_in') and len(attributes.location_in)>
	<cfset url_str = "#url_str#&location_in=#attributes.location_in#">
</cfif>
<cfif isDefined('attributes.search_process_date') and len(attributes.search_process_date)>
	<cfset url_str = "#url_str#&search_process_date=#attributes.search_process_date#">
</cfif>
<cfif isDefined('attributes.is_condition_sale_or_purchase') and len(attributes.is_condition_sale_or_purchase)>
	<cfset url_str = "#url_str#&is_condition_sale_or_purchase=#attributes.is_condition_sale_or_purchase#">
</cfif>
<cfif isdefined("attributes.satir")>
	<cfset url_str = "#url_str#&satir=#attributes.satir#">
</cfif>
<cfloop query="moneys">
	<cfif isdefined("attributes.#money#")>
		<cfset url_str = "#url_str#&#money#=#evaluate("attributes.#money#")#">
	</cfif>
</cfloop>
<cfset url_str = '#url_str#&form_submitted=1'>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></cfsavecontent>
	<cf_box title="#message#">
		<cf_wrk_alphabet keyword="url_str" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"><!--- Harfler --->
		<cfform name="price_cat" action="#request.self#?fuseaction=objects.popup_products#url_str#&is_sale_product=#is_sale_product#" method="post">
			<input name="form_submitted" id="form_submitted" value="1" type="hidden">
			<input type="hidden" name="list_property_id" id="list_property_id" value="<cfif isdefined("attributes.list_property_id")><cfoutput>#attributes.list_property_id#</cfoutput></cfif>">
			<input type="hidden" name="list_variation_id" id="list_variation_id" value="<cfif isdefined("attributes.list_variation_id")><cfoutput>#attributes.list_variation_id#</cfoutput></cfif>">
			<cf_box_search more="0">
				<cfoutput>
					<div class="form-group" id="item-product_name">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
							<input name="product_name" type="text" id="product_name" placeholder="#message#" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_name','','3','100');" value="<cfif len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" autocomplete="off">
						</div>
					</div>
					<div class="form-group" id="item-barcod">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57633.Barkod'></cfsavecontent>
							<input type="text" name="barcod" id="barcod" placeholder="#message#" value="<cfoutput>#attributes.barcod#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-stock_code">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57518.Stok Kodu'></cfsavecontent>
							<input type="text" name="stock_code" id="stock_code" placeholder="#message#" value="<cfoutput>#attributes.stock_code#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-stock_code">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57634.Üretici Kodu'></cfsavecontent>
							<input type="text" name="manufact_code" id="manufact_code" placeholder="#message#" value="<cfoutput>#attributes.manufact_code#</cfoutput>">
						</div>
					</div>
				</cfoutput>	     
				<div class="form-group" id="item-brand_name">
					<div class="input-group">
						<cfif len(attributes.brand_id) and len(attributes.brand_name)>
							<cfquery name="get_brand_name" datasource="#dsn3#">
								SELECT BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID = #attributes.brand_id#
							</cfquery>
						</cfif>
						<input type="Hidden" name="brand_id" id="brand_id" value="<cfoutput>#attributes.brand_id#</cfoutput>">
						<cf_wrk_brands form_name='price_cat' brand_id='brand_id' brand_name='brand_name'>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58847.Marka'></cfsavecontent>
						<input type="Text" name="brand_name" id="brand_name" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.brand_name#</cfoutput>" onkeyup="get_brand();">
						<span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_brands&brand_id=price_cat.brand_id&brand_name=price_cat.brand_name</cfoutput>','medium');"></span>
					</div>
				</div>	
				<div class="form-group" id="item-product_cat">
					<div class="input-group">
						<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
						<cf_wrk_product_cat form_name='price_cat' hierarchy_code='product_catid' product_cat_name='product_cat'>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57486.Kategori'></cfsavecontent>
						<input type="text" name="product_cat" id="product_cat" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.product_cat#</cfoutput>" onkeyup="get_product_cat();">
						<span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://"onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=0&field_id=price_cat.product_catid&field_name=price_cat.product_cat&keyword='+encodeURIComponent(document.price_cat.product_cat.value)</cfoutput>);"></span>
					</div>
				</div>	
				<div class="form-group" id="item-get_company">
					<div class="input-group">
						<cfoutput>
							<input type="hidden" name="get_company_id" id="get_company_id" value="#attributes.get_company_id#">
							<cf_wrk_members form_name='price_cat' member_name='get_company' company_id='get_company_id' select_list='2'>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='29533.Tedarikçi'></cfsavecontent>
							<input type="text" name="get_company" id="get_company" placeholder="#message#" value="#attributes.get_company#" onkeyup="get_member();">
							<span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=price_cat.get_company&field_comp_id=price_cat.get_company_id&select_list=2,3&is_form_submitted=1&keyword='+encodeURIComponent(document.price_cat.get_company.value),'medium');"></span>
						</cfoutput>
					</div>
				</div>	
				
				<div class="form-group" id="item-sort_type">
					<select name="sort_type" id="sort_type">
						<option value="0" <cfif attributes.sort_type eq 0>selected</cfif>><cf_get_lang dictionary_id='34282.Ürün Adına Göre'></option>
						<option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cf_get_lang dictionary_id='32751.Stok Koduna Göre'></option>
						<option value="2" <cfif attributes.sort_type eq 2>selected</cfif>><cf_get_lang dictionary_id='32764.Özel Koda Göre'></option>
					</select>
				</div>
				<div class="form-group" id="item-employee">
					<div class="input-group">
						<input type="hidden" name="pos_code" id="pos_code" value="<cfoutput>#attributes.pos_code#</cfoutput>">
						<cf_wrk_employee_positions form_name='price_cat' pos_code='pos_code' emp_name='employee'>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57544.Sorumlu'></cfsavecontent>
						<input type="text" name="employee" id="employee" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.employee#</cfoutput>" maxlength="255"  onkeyup="get_emp_pos_1();">
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=price_cat.pos_code&field_name=price_cat.employee&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.price_cat.employee.value),'medium');"></span>
					</div>
				</div>
				<div class="form-group" id="item-stock_code2">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57518.Stok Kodu'></cfsavecontent>
					<input type="text" name="stock_code2" id="stock_code2" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.stock_code2#</cfoutput>">
				</div>
				<div class="form-group" id="item-price_catid">
					<select name="price_catid" id="price_catid" onchange="javascript:price_cat.submit();">
						<option value="-1" <cfif attributes.price_catid is '-1'> selected</cfif>><cf_get_lang dictionary_id='58722.Standart Alış'></option>
						<cfoutput query="price_cats"> 
							<option value="#price_catid#" <cfif price_cats.price_catid is attributes.price_catid> selected</cfif>>#price_cat#</option>
						</cfoutput> 
					</select>
				</div>	
				<div class="form-group" id="item-stock_strategy_type">
					<select name="stock_strategy_type" id="stock_strategy_type">
						<option value=""><cf_get_lang dictionary_id='32542.Stok Durumu'></option>
						<option value="1" <cfif isdefined('attributes.stock_strategy_type') and attributes.stock_strategy_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='58845.Tanımsız'></option>
						<option value="2" <cfif isdefined('attributes.stock_strategy_type') and attributes.stock_strategy_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='34086.Fazla Stok'></option>
						<option value="3" <cfif isdefined('attributes.stock_strategy_type') and attributes.stock_strategy_type eq 3>selected</cfif>><cf_get_lang dictionary_id ='34088.Sipariş Ver'></option>
						<option value="4" <cfif isdefined('attributes.stock_strategy_type') and attributes.stock_strategy_type eq 4>selected</cfif>><cf_get_lang dictionary_id ='34087.Yeterli Stok'></option>
						<option value="5" <cfif isdefined('attributes.stock_strategy_type') and attributes.stock_strategy_type eq 5>selected</cfif>><cf_get_lang dictionary_id ='34089.Yetersiz Stok'></option>
					</select>
				</div>
				<div class="form-group medium" id="item-amount_multiplier">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57635.Miktar'></cfsavecontent>
					<input type="text" name="amount_multiplier" id="amount_multiplier"  placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#amountformat(attributes.amount_multiplier,3)#</cfoutput>" onkeyup="return FormatCurrency(this,event,3);" class="moneybox">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>    
				<div class="form-group">
					<cf_wrk_search_button search_function='input_control()' button_type="4">
				</div>  
			</cf_box_search>
    		<cf_box_search_detail class="hide">
				<div id="detail_search">
					<cfinclude template="detailed_product_search.cfm" />
				</div>
			</cf_box_search_detail>
 		</cfform>
		<cf_grid_list>
			<thead>
				<tr> 
					<th width="70"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
					<cfif isdefined('xml_use_ozel_code') and xml_use_ozel_code eq 1>
					<th nowrap="nowrap"><cf_get_lang dictionary_id ='57789.Özel Kod'></th>
					</cfif>
					<th width="300"><cf_get_lang dictionary_id='57657.Ürün'></th>
					<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>
					<th width="30" style="text-align:right;"><cf_get_lang dictionary_id='57647.Spec'></th>
					</cfif>
					<th width="110" style="text-align:right;"><cf_get_lang dictionary_id='58084.Fiyat'></th>
					<th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='57452.Stok'></th>
					<th width="50" nowrap="nowrap"><cf_get_lang dictionary_id='57636.Birim'></th>
					<th width="85px;"><cf_get_lang dictionary_id='57756.Durum'></th>
					<th width="20"><a href="javascript://"><i class="icon-detail"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif products.recordcount>
				<cfquery name="GET_PRODUCT_UNITS" datasource="#DSN3#">
					SELECT ADD_UNIT,MAIN_UNIT,MULTIPLIER,PRODUCT_UNIT_ID,PRODUCT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID IN (#valuelist(products.product_id)#) AND PRODUCT_UNIT_STATUS = 1
				</cfquery>
				<cfoutput query="products">
					<cfif isDefined("money")>
						<cfset attributes.money = money>
					</cfif>
					<cfloop query="moneys">
						<cfif moneys.money is attributes.money>
							<cfset row_money = moneys.money>
							<cfset row_money_rate1 = moneys.rate1>
							<cfset row_money_rate2 = moneys.rate2>
						</cfif>
					</cfloop>
					<form name="product#currentrow#" method="post">
					<cfif isdefined("attributes.is_action")><!--- aksiyonlar için satınalma indirimi default alma için erk 20040112 --->
						<input type="hidden" name="is_action" id="is_action" value="1"><!--- arzu 16022004 ? --->
					</cfif>
					<cfif row_money is default_money.money>
						<cfset flag_prc_other=0>
						<cfset flt_price = products.price>
						<cfset flt_price_other = products.price>
						<cfset str_money = money>
					<cfelse>
						<cfset flag_prc_other=1>			
						<cfset flt_price = products.price*(row_money_rate2/row_money_rate1)>
						<cfset flt_price_other = products.price>
						<cfset str_money = row_money>
					</cfif>
					<tr>
						<td>#stock_code#</td>
						<cfif isdefined('xml_use_ozel_code') and xml_use_ozel_code eq 1>
						<td width="70">#product_code_2#</td>
						</cfif>
						<td style="cursor:pointer" >
						<a class="tableyazi" onclick="sepete_ekle(1,'#product_id#', '#stock_id#','#stock_code#','#barcod#','#MANUFACT_CODE#','#product_name# #products.property#','#products.product_unit_id#','#products.add_unit#','#products.PRODUCT_CODE#',1,'#products.IS_SERIAL_NO#','#flag_prc_other#','#is_sale_product#','#products.tax#','#products.otv#','#flt_price_other#','#row_money#','','','#IS_INVENTORY#','#MULTIPLIER#','','','',1,'',<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>'#products.spect_var_id#'<cfelse>''</cfif>,'#IS_PRODUCTION#','','',<cfif isdefined('attributes.price_catid')>'#attributes.price_catid#'<cfelse>''</cfif>,'','','','#flt_price_other#','','',<cfif len(CATALOG_ID)>'#CATALOG_ID#'<cfelse>''</cfif>);">
						#product_name#&nbsp;#property#
						</a>
						</td>
						<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>
						<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_spec&id=#products.SPECT_VAR_ID#','medium');" class="tableyazi">#products.SPECT_VAR_ID#</a></td>
						</cfif>
						<td style="text-align:right;">
						#TLFormat(products.price,session.ep.our_company_info.sales_price_round_num)#&nbsp;#money# (#products.add_unit#)
						</td>
						<td style="text-align:right; cursor:pointer;" nowrap  onClick="open_div_sales_purchase_info('#currentrow#','#stock_id#','#product_id#');">#TLFormat(PRODUCTS.PRODUCT_STOCK)# #PRODUCTS.MAIN_UNIT#</td>
						<cfquery name="GET_UNITS" dbtype="query">
							SELECT DISTINCT ADD_UNIT,PRODUCT_UNIT_ID,MULTIPLIER,MAIN_UNIT FROM get_product_units WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
						</cfquery>
						<td>
							<cfloop from="1" to="#get_units.recordcount#" index="unt_ind"><!---query="get_units">--->
							<!--- Urun birimleri --->
								<cfif get_units.add_unit[unt_ind] eq products.main_unit>
								<a class="tableyazi" onclick="sepete_ekle(1,'#product_id#', '#stock_id#','#stock_code#','#barcod#','#MANUFACT_CODE#','#product_name# #products.property#','#products.product_unit_id#','#products.add_unit#','#products.PRODUCT_CODE#',1,'#products.IS_SERIAL_NO#','#flag_prc_other#','#is_sale_product#','#products.tax#','#products.otv#','#flt_price_other#','#row_money#','','','#IS_INVENTORY#','#get_units.MULTIPLIER[unt_ind]#','','','','#get_units.MULTIPLIER[unt_ind]#','',<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>'#products.spect_var_id#'<cfelse>''</cfif>,'#IS_PRODUCTION#','','',<cfif isdefined('attributes.price_catid')>'#attributes.price_catid#'<cfelse>''</cfif>,'','','','#flt_price_other#','','',<cfif len(CATALOG_ID)>'#CATALOG_ID#'<cfelse>''</cfif>);">
										#get_units.add_unit[unt_ind]#
									</a>
								<cfelse>
									<a class="tableyazi" onclick="sepete_ekle(1,'#product_id#', '#stock_id#','#stock_code#','#barcod#','#MANUFACT_CODE#','#product_name# #products.property#','#products.product_unit_id#','#products.add_unit#','#products.PRODUCT_CODE#',1,'#products.IS_SERIAL_NO#','#flag_prc_other#','#is_sale_product#','#products.tax#','#products.otv#','#flt_price_other#','#row_money#','','','#IS_INVENTORY#','#get_units.MULTIPLIER[unt_ind]#','','','','#get_units.MULTIPLIER[unt_ind]#','',<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>'#products.spect_var_id#'<cfelse>''</cfif>,'#IS_PRODUCTION#','','#get_units.add_unit[unt_ind]#',<cfif isdefined('attributes.price_catid')>'#attributes.price_catid#'<cfelse>''</cfif>,'','','','#flt_price_other#','','',<cfif len(CATALOG_ID)>'#CATALOG_ID#'<cfelse>''</cfif>);">
										#get_units.add_unit[unt_ind]#
									</a>
								</cfif>
							</cfloop>
						</td>
						<td width="85px;">
						<cfif not (len(MAXIMUM_STOCK) and len(MAXIMUM_STOCK) and len(REPEAT_STOCK_VALUE))><cf_get_lang dictionary_id='58845.Tanımsız'> <!--- Strategy tanımlanmamıs --->
						<cfelseif PRODUCTS.PRODUCT_STOCK lte MINIMUM_STOCK><cf_get_lang dictionary_id ='34089.Yetersiz Stok'>
						<cfelseif PRODUCTS.PRODUCT_STOCK gte MAXIMUM_STOCK><cf_get_lang dictionary_id ='34086.Fazla Stok'>
						<cfelseif PRODUCTS.PRODUCT_STOCK lt MAXIMUM_STOCK and PRODUCTS.PRODUCT_STOCK gt REPEAT_STOCK_VALUE><cf_get_lang dictionary_id ='34087.Yeterli Stok'>
						<cfelseif PRODUCTS.PRODUCT_STOCK lte REPEAT_STOCK_VALUE and PRODUCTS.PRODUCT_STOCK gt MINIMUM_STOCK><cf_get_lang dictionary_id ='34088.Sipariş Ver'>
						</cfif>
						</td>
						<td width="15" align="center">
						<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCTS.PRODUCT_ID#&sid=#stock_id#','list')"><i class="icon-detail"></i></a> 
						</td>
					</tr>
				</form>
					<!--- stok alış-satış durumları --->
					<tr style="display:none;" id="sales_purchase_info_row#currentrow#" class="color-row">
						<td colspan="8" align="center">
							<table cellpadding="0" cellspacing="0" width="100%" border="0">
								<tr>
								<td valign="top">
									<div id="stock_sales_info#currentrow#" style="display:none; outset cccccc; width:100%;"></div>
								</td>
								</tr>
							</table>
						</td>
					</tr>
				</cfoutput>
				<cfelse>
					<cfif isdefined("attributes.form_submitted")>
						<tr>
						<td colspan="8" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'></td>
					</tr>
					<cfelse>
					<tr>
						<td colspan="8" height="20"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</td>
					</tr>
					</cfif>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres=attributes.fuseaction>
			<cfif len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isDefined('attributes.module_name') and len(attributes.module_name)>
				<cfset adres = "#adres#&module_name=#attributes.module_name#">
			</cfif>
			<cfif len(attributes.employee) and len(attributes.pos_code)>
				<cfset adres = "#adres#&employee=#attributes.employee#&pos_code=#attributes.pos_code#">
			</cfif>
			<cfif len(attributes.product_cat) and len(attributes.product_catid)>
				<cfset adres = "#adres#&product_cat=#attributes.product_cat#&product_catid=#attributes.product_catid#">
			</cfif>
			<cfif len(attributes.get_company_id) and len(attributes.get_company)>
				<cfset adres = "#adres#&get_company_id=#attributes.get_company_id#&get_company=#attributes.get_company#">
			</cfif>
			<cfif len(attributes.product_name)>
				<cfset adres = "#adres#&product_name=#attributes.product_name#">
			</cfif>
			<cfif len(attributes.stock_code)>
				<cfset adres = "#adres#&stock_code=#attributes.stock_code#">
			</cfif>
			<cfif len(attributes.stock_code2)>
				<cfset adres = "#adres#&stock_code2=#attributes.stock_code2#">
			</cfif>
			<cfif len(attributes.barcod)>
				<cfset adres = "#adres#&barcod=#attributes.barcod#">
			</cfif>
			<cfif len(attributes.brand_id) and len(attributes.brand_name)>
				<cfset adres = "#adres#&brand_id=#attributes.brand_id#&brand_name=#attributes.brand_name#">
			</cfif>
			<cfif isdefined('attributes.stock_strategy_type') and len(attributes.stock_strategy_type)>
				<cfset adres = "#adres#&stock_strategy_type=#attributes.stock_strategy_type#">
			</cfif>
			<cfif isdefined("attributes.amount_multiplier")>
				<cfset adres = "#adres#&amount_multiplier=#attributes.amount_multiplier#">
			</cfif>
			<cfif isdefined("attributes.sort_type") and len(attributes.sort_type)>
				<cfset adres = "#adres#&sort_type=#attributes.sort_type#">
			</cfif>
			<cfif isDefined('attributes.list_property_id') and len(attributes.list_property_id)>
				<cfset adres = '#adres#&list_property_id=#attributes.list_property_id#'>
			</cfif>	
			<cfif isDefined('attributes.list_variation_id') and len(attributes.list_variation_id)>
				<cfset adres = '#adres#&list_variation_id=#attributes.list_variation_id#'>
			</cfif>	
			<cfif isDefined('attributes.form_submitted') and len(attributes.form_submitted)>
				<cfset adres = '#adres#&form_submitted=#attributes.form_submitted#'>
			</cfif>	
			<cfif isDefined('attributes.manufact_code') and len(attributes.manufact_code)>
				<cfset adres = '#adres#&manufact_code=#attributes.manufact_code#'>
			</cfif>	
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#&is_sale_product=#is_sale_product##url_str#">
	
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function input_control()
{
	row_count=<cfoutput>#get_property_var.recordcount#</cfoutput>;
	for(r=1;r<=row_count;r++)
	{  
		deger_variation_id = eval("document.price_cat.variation_id"+r);
		if(deger_variation_id!=undefined && deger_variation_id.value != "")
		{
			deger_property_id = eval("document.price_cat.property_id"+r);
			if(document.price_cat.list_property_id.value.length==0) ayirac=''; else ayirac=',';
			document.price_cat.list_property_id.value=document.price_cat.list_property_id.value+ayirac+deger_property_id.value;
			document.price_cat.list_variation_id.value=document.price_cat.list_variation_id.value+ayirac+deger_variation_id.value;
		}
	}
	return true;
}
document.price_cat.list_property_id.value="";
document.price_cat.list_variation_id.value="";

function open_div_sales_purchase_info(no,stock_id,product_id)
{
	gizle_goster(eval("document.getElementById('sales_purchase_info_row" + no + "')"));
	gizle_goster(eval("document.getElementById('stock_sales_info" + no + "')"));
	AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_ajax_product_stock_info&purchase=1&sales=1&pid='+product_id+'&sid='+stock_id,'stock_sales_info'+no);
}
</script>
