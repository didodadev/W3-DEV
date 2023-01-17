<cfset recordnumber = 0>
<cfif IsDefined("attributes.id")>
	<cfinclude template="../query/get_catalog_promotion_products.cfm">	
	<cfset recordnumber = get_catalog_product.recordcount>
</cfif>
<cfinclude template="../../contract/query/get_moneys.cfm">
<cfinclude template="../../contract/query/get_units.cfm">
<cfquery name="GET_PAGE_TYPES" datasource="#DSN3#">
	SELECT PAGE_TYPE_ID,PAGE_TYPE,IS_DEFAULT FROM CATALOG_PAGE_TYPES ORDER BY PAGE_TYPE
</cfquery>
<cfset col_span_inf = 1>
<cfif (isdefined("is_manufact_code") and is_manufact_code eq 1) or (not isdefined("is_manufact_code"))>
	<cfset col_span_inf = col_span_inf + 1>
</cfif>
<cfif (isdefined("is_stock_code") and is_stock_code eq 1) or (not isdefined("is_stock_code"))>
	<cfset col_span_inf = col_span_inf + 1>
</cfif>
<cfif (isdefined("is_stock_code_2") and is_stock_code_2 eq 1) or (not isdefined("is_stock_code_2"))>
	<cfset col_span_inf = col_span_inf + 1>
</cfif>
<cfif (isdefined("is_barcod") and is_barcod eq 1) or (not isdefined("is_barcod"))>
	<cfset col_span_inf = col_span_inf + 1>
</cfif>
<cfif (isdefined("is_unit") and is_unit eq 1) or (not isdefined("is_unit"))>
	<cfset col_span_inf = col_span_inf + 1>
</cfif>
<cfset col_span_inf = col_span_inf + 1>
<cfif isdefined("extra_price_list") and len(extra_price_list)>
	<cfquery name="get_price_cat_row" datasource="#dsn3#" maxrows="3">
		SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT WHERE PRICE_CATID IN(#extra_price_list#)
	</cfquery>
	<input type="hidden" name="extra_price_list" id="extra_price_list" value="<cfoutput>#valuelist(get_price_cat_row.price_catid)#</cfoutput>">
</cfif>
<cfif not isdefined("discount_count")>
	<cfset discount_count = 10>
</cfif>
<input name="record_num" id="record_num" type="hidden" value="<cfoutput>#recordnumber#</cfoutput>">
	<cf_grid_list name="table1" id="table1">
		<thead>
		<tr>
			<th>&nbsp;</th>
			<th><cf_get_lang dictionary_id='57487.No'></th>
			<th colspan="<cfoutput>#col_span_inf#</cfoutput>"><cf_get_lang dictionary_id='57657.Ürün'></th>			
			<cfif (isdefined("is_row_price") and is_row_price eq 1) or (not isdefined("is_row_price"))>
				<th <cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")><cfif isdefined("is_price_kdv") and is_price_kdv eq 1>colspan="4"<cfelse>colspan="3"</cfif><cfelse>colspan="1"</cfif>><cf_get_lang dictionary_id='37227.standart'></th>
			</cfif>
			<cfif isdefined("extra_price_list") and len(extra_price_list) and get_price_cat_row.recordcount>
				<cfoutput query="get_price_cat_row">
					<th>#get_price_cat_row.price_cat#</th>
					<cfif get_price_cat_row.currentrow eq 1>
						<th><cf_get_lang dictionary_id='58258.Maliyet'></th>
					<cfelseif get_price_cat_row.currentrow eq 2>
						<th><cf_get_lang dictionary_id ='37045.Marj'></th>
					</cfif> 
				</cfoutput>
			</cfif>
			<cfif (isdefined("is_row_discount") and is_row_discount eq 1) or (not isdefined("is_row_discount"))>
				<th colspan="<cfoutput>#discount_count#</cfoutput>"><cf_get_lang dictionary_id='57641.iskonto'>%</th>
			</cfif>
			<cfif (isdefined("is_row_cost") and is_row_cost eq 1) or (not isdefined("is_row_cost"))>
				<th colspan="2"><cf_get_lang dictionary_id='58258.Maliyet'></th>
			</cfif>
			<cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
				<th colspan="4"><cf_get_lang dictionary_id='37049.Aksiyon Fiyat'></th>
			</cfif>
			<cfif isdefined("is_money_type") and is_money_type eq 1>
				<th><cf_get_lang dictionary_id='57489.Para Br'></th>
			</cfif>
			<cfif (isdefined("is_row_return_price") and is_row_return_price eq 1) or (not isdefined("is_row_return_price"))>
				<th colspan="3"><cf_get_lang dictionary_id='57749.Dönüş Fiyatı'></th>
			</cfif>
			<cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
				<th colspan="2"><cf_get_lang dictionary_id='57639.Kdv'></th>
			</cfif>
			<cfif (isdefined("is_row_due") and is_row_due eq 1) or (not isdefined("is_row_due"))>
				<th colspan="2">&nbsp;</th>
			</cfif>
			<cfif (isdefined("is_row_condition") and is_row_condition eq 1) or (not isdefined("is_row_condition"))>
				<th colspan="5" id='main_all_cond'><cf_get_lang dictionary_id ='37537.Tüm Koşullar'></th>
			</cfif>
			<cfif isdefined("is_extra_definition") and is_extra_definition eq 1>
				<th colspan="2"><cf_get_lang dictionary_id ='37076.Ek Tanım'></th>
			</cfif>
			<cfif isdefined("is_sale_target") and is_sale_target eq 1>
				<th colspan="4"><cf_get_lang dictionary_id='57951.Hedef'></th>
			</cfif>
			<cfif isdefined("limit_type") and limit_type eq 1>
				<th colspan="5" id='limit_type_cond'><cf_get_lang dictionary_id='32744.Promotion'></th>
				<th colspan="3" id='limit_type_cond'><cf_get_lang dictionary_id='64112.?'></th>
			</cfif>
			<cfif isdefined("is_row_page_type") and is_row_page_type eq 1>
				<th colspan="3" id='main_all_cond'><cf_get_lang dictionary_id ='57581.Sayfa'> <cf_get_lang dictionary_id ='58639.Tipleri'> </th>
			</cfif>
		</tr>
		<tr>
			<th>
				<cfif not IsDefined("attributes.id") or get_catalog_product.is_applied neq 1><a href="javascript://" onclick="openProducts();"><i class="fa fa-plus"></i></a></cfif>
			</th> 
			<th style="min-width:50px"><cf_get_lang dictionary_id='57487.No'></th>
			<th style="min-width:175px"><cf_get_lang dictionary_id='57629.Açıklama'></th>
			<cfif (isdefined("is_manufact_code") and is_manufact_code eq 1) or (not isdefined("is_manufact_code"))>
				<th><cf_get_lang dictionary_id='37481.Ürt Kodu'></th>
			</cfif>
			<cfif (isdefined("is_stock_code") and is_stock_code eq 1) or (not isdefined("is_stock_code"))>
				<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
			</cfif>
			<cfif (isdefined("is_stock_code_2") and is_stock_code_2 eq 1) or (not isdefined("is_stock_code_2"))>
				<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
			</cfif>
			<cfif (isdefined("is_barcod") and is_barcod eq 1) or (not isdefined("is_barcod"))>
				<th style="min-width:100px"><cf_get_lang dictionary_id='57633.Barkod'></th>
			</cfif>
			<cfif (isdefined("is_unit") and is_unit eq 1) or (not isdefined("is_unit"))>
				<th style="min-width:50px"><cf_get_lang dictionary_id='57636.Birim'></th>
			</cfif>
			<th style="min-width:40px"><cf_get_lang dictionary_id='57489.Para Br'></th>			
			<cfif (isdefined("is_row_price") and is_row_price eq 1) or (not isdefined("is_row_price"))>
				<cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
					<th style="min-width:40px" align="right" style="text-align:right;"><cf_get_lang dictionary_id='58176.alis'><br/><cf_get_lang dictionary_id='30024.KDV siz'></th>
				<cfif isdefined("is_price_kdv") and is_price_kdv eq 1>
					<th style="min-width:40px" align="right" style="text-align:right;"><cf_get_lang dictionary_id='58176.alis'><br/><cf_get_lang dictionary_id='58716.KDV li'></th>
				</cfif>
				</cfif>
				<th style="min-width:40px" align="right" style="text-align:right;"><cf_get_lang dictionary_id='57448.satis'><br/><cf_get_lang dictionary_id='58716.KDV li'></th>
				<cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
					<th style="min-width:45px"><cf_get_lang dictionary_id='37313.S Mrj'></th>
				</cfif>
			</cfif>
			<cfif isdefined("extra_price_list") and len(extra_price_list)>
				<cfoutput query="get_price_cat_row">
					<th style="min-width:80px" align="right" style="text-align:right;"><cf_get_lang dictionary_id='37365.KDV Dahil'></th>
					<cfif get_price_cat_row.currentrow eq 1>
						<th align="right" style="text-align:right;"><cf_get_lang dictionary_id='58258.Maliyet'></th>
					<cfelseif get_price_cat_row.currentrow eq 2>
						<th align="right" style="text-align:right;"><cf_get_lang dictionary_id='37045.Marj'></th>
					</cfif> 
				</cfoutput>
			</cfif>
			<cfif (isdefined("is_row_discount") and is_row_discount eq 1) or (not isdefined("is_row_discount"))>
				<cfloop from="1" to="#discount_count#" index="kk">
					<cfoutput>
						<th style="min-width:40px">#kk#</th>
					</cfoutput>
				</cfloop>
			</cfif>
			<cfif (isdefined("is_row_cost") and is_row_cost eq 1) or (not isdefined("is_row_cost"))>
				<th style="min-width:40px" align="right" style="text-align:right;"><cf_get_lang dictionary_id='58083.Net'></th>
				<th style="min-width:40px" align="right" style="text-align:right;"><cf_get_lang dictionary_id='58716.KDV li'></th>
			</cfif>
			<cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
				<th style="min-width:45px"><cf_get_lang dictionary_id='37048.A Mrj'></th>
				<th style="min-width:80px" align="right" style="text-align:right;"><cf_get_lang dictionary_id ='37753.Kdv Hariç'></th>
				<th style="min-width:80px" align="right" style="text-align:right;"><cf_get_lang dictionary_id='37365.KDV Dahil'></th>
				<th style="min-width:80px" align="right" style="text-align:right;"><cf_get_lang dictionary_id='37482.Tutar Ind'></th>
			</cfif>
			<cfif isdefined("is_money_type") and is_money_type eq 1>
				<th style="min-width:100px"><cf_get_lang dictionary_id='57489.Para Birimi'></th>
			</cfif>
			<cfif (isdefined("is_row_return_price") and is_row_return_price eq 1) or (not isdefined("is_row_return_price"))>
				<th style="min-width:80px" align="right" style="text-align:right;"><cf_get_lang dictionary_id='37753.Kdv Hariç'></th>
				<th style="min-width:80px" align="right" style="text-align:right;"><cf_get_lang dictionary_id='37365.KDV Dahil'></th>
				<th style="min-width:80px" align="right" style="text-align:right;"><cf_get_lang dictionary_id='37482.Tutar Ind'></th>
			</cfif>
			<cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
				<th style="min-width:50px"><cf_get_lang dictionary_id='58176.alış'></th> 
				<th style="min-width:50px"><cf_get_lang dictionary_id='57448.satış'></th>
			</cfif>
			<cfif (isdefined("is_row_due") and is_row_due eq 1) or (not isdefined("is_row_due"))>
				<th style="min-width:50px"><cf_get_lang dictionary_id='57640.Vade'></th>
				<th style="min-width:80px"><cf_get_lang dictionary_id='37110.Raf Tipi'></th>
			</cfif>
			<cfif (isdefined("is_row_condition") and is_row_condition eq 1) or (not isdefined("is_row_condition"))>
				<th style="min-width:80px" id='back_end_rebate'><cf_get_lang dictionary_id='37755.Back End Rebate'></th>
				<th style="min-width:80px" id='back_end_rebate_rate'><cf_get_lang dictionary_id ='57378.Back End Rebate Oran'></th>
				<th style="min-width:80px" id='extra_product'><cf_get_lang dictionary_id ='37660.Mal Fazlası'></th>
				<th style="min-width:80px" id='return_day_rate'><cf_get_lang dictionary_id ='37662.İade Gün'> -<cf_get_lang dictionary_id ='58456.Oran'> </th>
				<th style="min-width:45px" id='price_protection_day'><cf_get_lang dictionary_id ='37661.Fiyat Koruma Gün'></th>
			</cfif>
			<cfif isdefined("is_extra_definition") and is_extra_definition eq 1>
				<th style="min-width:80px"><cf_get_lang dictionary_id ='57629.Açıklama'>/<cf_get_lang dictionary_id ='57467.Not'></th>
				<th style="min-width:80px"><cf_get_lang dictionary_id ='37134.Referans Kod'></th>
			</cfif>
			<cfif isdefined("is_sale_target") and is_sale_target eq 1>
				<th style="min-width:80px"><cf_get_lang dictionary_id ='37168.Müşteri Sayısı'></th>
				<th style="min-width:80px"><cf_get_lang dictionary_id ='37150.Birim Satış'></th>
				<th style="min-width:120px"><cf_get_lang dictionary_id ='37151.Toplam Satış Miktarı'></th>
				<th style="min-width:80px"><cf_get_lang dictionary_id ='37215.Satış Tipi'></th>
			</cfif>
			<cfif isdefined("limit_type") and limit_type eq 1>
				<th style="min-width:200px"><cf_get_lang dictionary_id='62823.Promotion code'></th>
				<th style="min-width:200px"><cf_get_lang dictionary_id='63960.Anında kazanımlar'></th>
				<th style="min-width:100px"><cf_get_lang dictionary_id='63960.Anında kazanımlar'> <cf_get_lang dictionary_id='58258.Maliyet'></th>
				<th style="min-width:200px"><cf_get_lang dictionary_id='63968.Sonraki Alışverişlerde Kazanımlar'></th>
				<th style="min-width:100px"><cf_get_lang dictionary_id='56864.Toplam Maliyet'></th>
				<th style="min-width:100px"><cf_get_lang dictionary_id='33950.Min Marj'></th>
				<th style="min-width:100px"><cf_get_lang dictionary_id='33951.Max Marj'></th>
				<th style="min-width:100px"><cf_get_lang dictionary_id='52255.Karlılık'></th>
			</cfif>
			<cfif isdefined("is_row_page_type") and is_row_page_type eq 1>
				<th style="min-width:80px" id='page_type'><cf_get_lang dictionary_id ='57581.Sayfa'><cf_get_lang dictionary_id ='57487.No'></th>
				<th style="min-width:80px" id='page_type'><cf_get_lang dictionary_id ='58069.Sayfa Tipi'></th>
				<th id='page_type'><cf_get_lang dictionary_id ='58067.Döküman Tipi'></th>
			</cfif>
		</tr>
		</thead>
		<tbody>
		<cfif isDefined("attributes.id") and recordnumber>
			<cfoutput query="get_catalog_product">
			<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
			<input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
			<input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#stock_id#">
			<input type="hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="#product_unit_id#">
			<tr id="frm_row#currentrow#" title="#get_catalog_product.product_name#">
				<cfsavecontent variable="delete_message"><cf_get_lang dictionary_id='57533.Silmek Istediginizden Emin Misiniz'></cfsavecontent>
				<td><cfif get_catalog_product.is_applied neq 1><a style="cursor:pointer" onClick="if (confirm('#delete_message#')) sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='37781.Ürünü Sil'>"></i></a></cfif></td>
				<td>#currentrow#</td>
				<td><div class="form-group"><div class="input-group"><input type="text" name="product_name#currentrow#" id="product_name#currentrow#" title="" value="#get_catalog_product.product_name#" readonly><span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','medium');" title="#get_catalog_product.product_name#"></span></div></div></td>
				<cfif (isdefined("is_manufact_code") and is_manufact_code eq 1) or (not isdefined("is_manufact_code"))>
					<td title="Ürt. Kodu/ #get_catalog_product.product_name#">#get_catalog_product.manufact_code#</td>
				</cfif>
				<cfif (isdefined("is_stock_code") and is_stock_code eq 1) or (not isdefined("is_stock_code"))>
					<td title="Stok Kodu/ #get_catalog_product.product_name#">#get_catalog_product.product_code#</td>
				</cfif>
				<cfif (isdefined("is_stock_code_2") and is_stock_code_2 eq 1) or (not isdefined("is_stock_code_2"))>
					<td title="Özel Kod/ #get_catalog_product.product_name#">#get_catalog_product.product_code_2#</td>
				</cfif>
				<cfif (isdefined("is_barcod") and is_barcod eq 1) or (not isdefined("is_barcod"))>
					<td title="Barkod/ #get_catalog_product.product_name#">#get_catalog_product.barcod#</td>
				</cfif>
				<cfif (isdefined("is_unit") and is_unit eq 1) or (not isdefined("is_unit"))>
					<td title="Birim/ #get_catalog_product.product_name#"><div class="form-group"><input type="text" name="unit#currentrow#" id="unit#currentrow#" value="#unit#" readonly></div></td>
				</cfif>
				<td title="P. Br/ #get_catalog_product.product_name#"><div class="form-group"><input type="text" name="money#currentrow#" id="money#currentrow#" value="#money#" readonly></div></td>
				
				<cfif (isdefined("is_row_price") and is_row_price eq 1) or (not isdefined("is_row_price"))>
					<cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
						<td title="Alis KDV siz/ #get_catalog_product.product_name#"><div class="form-group"><input type="text" name="p_price#currentrow#" id="p_price#currentrow#" value="#TLFormat(PURCHASE_PRICE,session.ep.our_company_info.purchase_price_round_num)#" class="moneybox" onBlur="pPriceChanged(#currentrow#);" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));"></div></td>
					<cfif isdefined("is_price_kdv") and is_price_kdv eq 1>
						<td title="Alis KDV li/ #get_catalog_product.product_name#"><div class="form-group"><input type="text" name="p_price_kdv#currentrow#" id="p_price_kdv#currentrow#" value="#TLFormat(PURCHASE_PRICE_KDV,session.ep.our_company_info.purchase_price_round_num)#" class="moneybox" onBlur="pPriceChanged2(#currentrow#);" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));"></div></td>
					</cfif>
					</cfif>
					<td title="Satis/ #get_catalog_product.product_name#"><div class="form-group"><input type="text" name="s_price#currentrow#" id="s_price#currentrow#" value="#TLFormat(SALES_PRICE,session.ep.our_company_info.sales_price_round_num)#" class="moneybox" readonly></div></td>
					<cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
						<td title="S.Marj/ #get_catalog_product.product_name#"><div class="form-group"><input type="text" name="profit_margin#currentrow#" id="profit_margin#currentrow#" value="#TLFormat(profit_margin)#" class="moneybox" readonly></div></td>
					</cfif>
				</cfif>
				<cfif isdefined("extra_price_list") and len(extra_price_list)>
					<cfloop query="get_price_cat_row">
						<td><div class="form-group"><input type="text" name="new_price_kdv#get_price_cat_row.price_catid##get_catalog_product.currentrow#" id="new_price_kdv#get_price_cat_row.price_catid##get_catalog_product.currentrow#"  value="<cfif len(evaluate("get_catalog_product.EXTRA_PRICEKDV_#get_price_cat_row.currentrow#"))>#tlformat(evaluate("get_catalog_product.EXTRA_PRICEKDV_#get_price_cat_row.currentrow#"),session.ep.our_company_info.sales_price_round_num)#<cfelse>#tlformat(0)#</cfif>" class="moneybox" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" <cfif get_price_cat_row.currentrow eq 2>onBlur="hesapla_row_marj(#get_price_cat_row.price_catid#,#get_catalog_product.currentrow#);"</cfif>></div></td>
						<cfif get_price_cat_row.currentrow eq 1>
							<td><div class="form-group"><input type="text" name="new_cost#get_catalog_product.currentrow#" id="new_cost#get_catalog_product.currentrow#" value="<cfif len(get_catalog_product.EXTRA_PRODUCT_COST)>#tlformat(get_catalog_product.EXTRA_PRODUCT_COST,session.ep.our_company_info.sales_price_round_num)#<cfelse>#tlformat(0)#</cfif>" readonly class="moneybox" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));"></div></td>
						<cfelseif get_price_cat_row.currentrow eq 2>
							<td><div class="form-group"><input type="text" name="new_marj#get_catalog_product.currentrow#" id="new_marj#get_catalog_product.currentrow#" value="<cfif len(get_catalog_product.EXTRA_PRODUCT_MARJ)>#tlformat(get_catalog_product.EXTRA_PRODUCT_MARJ)#<cfelse>#tlformat(0)#</cfif>" readonly class="moneybox"></div></td>
						</cfif> 
					</cfloop>
				</cfif>
				<cfif (isdefined("is_row_discount") and is_row_discount eq 1) or (not isdefined("is_row_discount"))>
					<cfloop from="1" to="#discount_count#" index="kk">
						<td title="İsk.#kk# / #get_catalog_product.product_name#"><div class="form-group"><input type="text" name="disc_ount#kk##currentrow#" id="disc_ount#kk##currentrow#" value="#TLFormat(evaluate("DISCOUNT#kk#"))#" class="moneybox" onBlur="discChanged(#currentrow#);" onKeyUp="return(FormatCurrency(this,event));"></div></td>
					</cfloop>
				</cfif>
				<cfif (isdefined("is_row_cost") and is_row_cost eq 1) or (not isdefined("is_row_cost"))>
					<td title="Net Maliyet/ #get_catalog_product.product_name#"><div class="form-group"><input type="text" name="row_nettotal#currentrow#" id="row_nettotal#currentrow#" value="#TLFormat(row_nettotal,session.ep.our_company_info.purchase_price_round_num)#" class="moneybox" readonly></div></td>
					<td title="KDV li Maliyet/ #get_catalog_product.product_name#"><div class="form-group"><input type="text" name="row_lasttotal#currentrow#" id="row_lasttotal#currentrow#" value="#TLFormat(row_total,session.ep.our_company_info.purchase_price_round_num)#" class="moneybox" readonly></div></td>
				</cfif>
				<cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
					<td title="A. Marj/ #get_catalog_product.product_name#"><div class="form-group"><input type="text" name="action_profit_margin#currentrow#" id="action_profit_margin#currentrow#" value="#TLFormat(action_profit_margin)#" class="moneybox" onBlur="actProfMargChanged(#currentrow#);" onKeyUp="return(FormatCurrency(this,event));"></div></td>
					<td title="KDV Hariç/ #get_catalog_product.product_name#">
						<div class="form-group">
							<div class="input-group">
								<input type="text" name="action_price_kdvsiz#currentrow#" id="action_price_kdvsiz#currentrow#" value="#TLFormat(action_price_kdvsiz,session.ep.our_company_info.sales_price_round_num)#" class="moneybox" onBlur="actPriceChanged(#currentrow#,#session.ep.our_company_info.sales_price_round_num#);" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));">
								<cfif get_catalog_product.is_applied neq 1>
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="getPrices(#currentrow#,1);" title="<cf_get_lang dictionary_id ='37780.Fiyat Seç'>"></span>
								</cfif>
							</div>
						</div>
					</td>
					<td title="KDV Dahil/ #get_catalog_product.product_name#"><div class="form-group"><input type="text" name="action_price#currentrow#" id="action_price#currentrow#" value="#TLFormat(action_price,session.ep.our_company_info.sales_price_round_num)#" class="moneybox" onBlur="actPriceChanged(#currentrow#,1);" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));"></div></td>
					<td title="Tutar İnd./ #get_catalog_product.product_name#"><div class="form-group"><input type="text" name="action_price_disc#currentrow#" id="action_price_disc#currentrow#" value="#TLFormat(ACTION_PRICE_DISCOUNT,session.ep.our_company_info.sales_price_round_num)#" class="moneybox" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));"></div></td>
				</cfif>
				<cfif isdefined("is_money_type") and is_money_type eq 1>
					<td title="Para Birimi/ #get_catalog_product.product_name#">
						<div class="form-group">
							<select name="sale_money_type#currentrow#" id="sale_money_type#currentrow#">
								<cfloop query="get_moneys">
									<option value="#money#" <cfif money eq get_catalog_product.sale_money_type>selected</cfif>>#money#</option>
								</cfloop>							
							</select>
						</div>
					</td>
				</cfif>
				<cfif (isdefined("is_row_return_price") and is_row_return_price eq 1) or (not isdefined("is_row_return_price"))>
					<td title="KDV Hariç/ #get_catalog_product.product_name#"><div class="form-group"><input type="text" name="returning_price_kdvsiz#currentrow#" id="returning_price_kdvsiz#currentrow#" value="#TLFormat(returning_price_kdvsiz,session.ep.our_company_info.sales_price_round_num)#" onBlur="actPriceChangedReturn(#currentrow#,2);" class="moneybox" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));" <cfif get_catalog_product.is_applied eq 1>readonly</cfif>></div></td>
					<td title="KDV Dahil/ #get_catalog_product.product_name#">
						<div class="form-group">
							<div class="input-group">
								<input type="text" name="returning_price#currentrow#" id="returning_price#currentrow#" value="#TLFormat(returning_price,session.ep.our_company_info.sales_price_round_num)#" class="moneybox" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));" onBlur="actPriceChangedReturn(#currentrow#,1);" <cfif get_catalog_product.is_applied eq 1>readonly</cfif>>
								<cfif get_catalog_product.is_applied neq 1><span class="input-group-addon icon-ellipsis btnPointer" onClick="getPrices(#currentrow#,2);" title="<cf_get_lang dictionary_id ='37780.Fiyat Seç'>"></span></cfif>
							</div>
						</div>
					</td>
					<td title="Tutar İnd./ #get_catalog_product.product_name#"><div class="form-group"><input type="text" name="returning_price_disc#currentrow#" id="returning_price_disc#currentrow#" value="#TLFormat(RETURNING_PRICE_DISCOUNT,session.ep.our_company_info.sales_price_round_num)#" class="moneybox" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));"></div></td>
				</cfif>
				<cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
					<td title="Alıs/ #get_catalog_product.product_name#"><div class="form-group"><input type="text" name="tax_purchase#currentrow#" id="tax_purchase#currentrow#" value="#TLFormat(tax_purchase,0)#" class="moneybox" readonly></div></td>
					<td title="Satıs/ #get_catalog_product.product_name#"><div class="form-group"><input type="text" name="tax#currentrow#" id="tax#currentrow#" value="#TLFormat(tax,0)#" class="moneybox" readonly></div></td>
				<cfelse>
					<input type="hidden" name="tax_purchase#currentrow#" id="tax_purchase#currentrow#" value="#TLFormat(tax_purchase,0)#" class="moneybox" readonly>
					<input type="hidden" name="tax#currentrow#" id="tax#currentrow#" value="#TLFormat(tax,0)#" class="moneybox" readonly>
				</cfif>
				<cfif (isdefined("is_row_due") and is_row_due eq 1) or (not isdefined("is_row_due"))>
					<td title="Vade/ #get_catalog_product.product_name#"><div class="form-group"><input type="text" name="duedate#currentrow#" id="duedate#currentrow#" class="moneybox" value="#duedate#"></div></td>
					<cfif len(shelf_id)>
						<cfquery name="GET_SHELF_NAME" datasource="#DSN#">
						SELECT
							SHELF_NAME
						FROM 
							SHELF
						WHERE
							SHELF_MAIN_ID = #shelf_id#
						</cfquery>
					</cfif>
					<td title="Raf Tipi/ #get_catalog_product.product_name#">
						<div class="form-group">
							<div class="input-group">
								<input  type="hidden"  name="shelf_id#currentrow#" id="shelf_id#currentrow#" value="#shelf_id#">
								<input type="text" name="shelf_name#currentrow#" id="shelf_name#currentrow#" value="<cfif len(shelf_id)>#GET_SHELF_NAME.SHELF_NAME#</cfif>">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="getShelf(#currentrow#);" title="<cf_get_lang dictionary_id ='37782.Raf Seç'>"></span>
							</div>
						</div>
					</td>
				</cfif>
				<cfif (isdefined("is_row_condition") and is_row_condition eq 1) or (not isdefined("is_row_condition"))>
					<td title="Back End Rebate/ #get_catalog_product.product_name#">
						<div class="form-group"><input type="text" name="rebate_cash_1#currentrow#" id="rebate_cash_1#currentrow#" value="#TLFormat(REBATE_CASH_1)#" class="moneybox" onKeyUp="return(FormatCurrency(this,event));"></div>
					</td>
					<td title="Back End Rebate Oran/ #get_catalog_product.product_name#">
						<div class="form-group"><input type="text" name="rebate_rate#currentrow#" id="rebate_rate#currentrow#" value="#TLFormat(REBATE_RATE)#" class="moneybox" onKeyUp="return(FormatCurrency(this,event));"></div>
					</td>
					<td title="Mal Fazlası/ #get_catalog_product.product_name#">
						<div class="form-group">
							<div class="col col-6">
								<input type="text" name="extra_product_1#currentrow#" id="extra_product_1#currentrow#" value="#TLFormat(EXTRA_PRODUCT_1)#" class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
							</div>
							<div class="col col-6">
								<input type="text" name="extra_product_2#currentrow#" id="extra_product_2#currentrow#" value="#TLFormat(EXTRA_PRODUCT_2)#" class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
							</div>
						</div>
					</td>
					<td title="İade Gün - Oran/ #get_catalog_product.product_name#">
						<div class="form-group">
							<div class="col col-6">
								<input type="text" name="return_day#currentrow#" id="return_day#currentrow#" value="#TLFormat(RETURN_DAY)#" class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
							</div>
							<div class="col col-6">
								<input type="text" name="return_rate#currentrow#" id="return_rate#currentrow#" value="#TLFormat(RETURN_RATE)#" class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
							</div>
						</div>
					</td>
					<td title="Fiyat Koruma Gün/ #get_catalog_product.product_name#">
						<div class="form-group"><input type="text" name="price_protection_day#currentrow#" id="price_protection_day#currentrow#" value="#TLFormat(PRICE_PROTECTION_DAY)#" class="moneybox" onKeyUp="return(FormatCurrency(this,event));"></div>
					</td>
				</cfif>
				<cfif isdefined("is_extra_definition") and is_extra_definition eq 1>
					<td><div class="form-group"><input type="text" name="detail_info#currentrow#" id="detail_info#currentrow#" value="#DETAIL_INFO#"></div></td>
					<td><div class="form-group"><input type="text" name="ref_code#currentrow#" id="ref_code#currentrow#" value="#REFERENCE_CODE#"></div></td>
				</cfif>
				<cfif isdefined("is_sale_target") and is_sale_target eq 1>
					<td><div class="form-group"><input type="text" name="customer_num#currentrow#" id="customer_num#currentrow#" class="moneybox" value="<cfif len(unit_sale)>#customer_number#<cfelse>0</cfif>" onKeyUp="isNumber(this);" onBlur="hesapla_sale(#currentrow#);"></div></td>
					<td><div class="form-group"><input type="text" name="unit_sale#currentrow#" id="unit_sale#currentrow#" class="moneybox" value="<cfif len(unit_sale)>#tlformat(unit_sale)#<cfelse>#tlformat(0)#</cfif>" onKeyUp="return(FormatCurrency(this,event));" onBlur="hesapla_sale(#currentrow#);"></div></td>
					<td><div class="form-group"><input type="text" name="total_sale#currentrow#" id="total_sale#currentrow#" class="moneybox" value="<cfif len(total_sale)>#tlformat(total_sale)#<cfelse>#tlformat(0)#</cfif>" readonly></div></td>
					<td>
						<div class="form-group">
							<select name="sale_type_info#currentrow#" id="sale_type_info#currentrow#">
								<option value="1" <cfif sale_type_info eq 1>selected</cfif>><cf_get_lang dictionary_id ='37239.Normal Satış'></option>
								<option value="2" <cfif sale_type_info eq 2>selected</cfif>><cf_get_lang dictionary_id ='37241.Set Bileşeni'></option>
								<option value="3" <cfif sale_type_info eq 3>selected</cfif>><cf_get_lang dictionary_id ='37242.Promosyon Faydası'></option>
								<option value="4" <cfif sale_type_info eq 4>selected</cfif>><cf_get_lang dictionary_id ='37265.Promosyon Koşulu'></option>
								<option value="5" <cfif sale_type_info eq 5>selected</cfif>><cf_get_lang dictionary_id ='37269.Set Ana Ürünü'></option>
							</select>
						</div>
					</td>
				</cfif>
				<cfif isdefined("limit_type") and limit_type eq 1>
					<td>
						<div class="form-group">
							<input type="hidden" name="prom_id#currentrow#" value="#promotion_id#">
							<input type="text" name="promotion_code#currentrow#" onKeyUp="isNumber(this);" class="moneybox" value="#promotion_code#">
						</div>
					</td>
					<td>
												
					</td>
					<td>						
						<div class="form-group"><input type="text" name="amount_1#currentrow#" id="amount_1#currentrow#" value="#amount_1#" onKeyUp="isNumber(this);" class="moneybox"></div>
					</td>
					<td>						
						<div class="form-group"><div class="col col-6"><div class="input-group"><input type="text" name="amount_discount_2_#currentrow#" onKeyUp="isNumber(this);" class="moneybox" value="#TLFormat(amount_discount_2)#" readonly><span class="input-group-addon" title="<cf_get_lang dictionary_id='63969.Alışveriş Kuponu'>"><i class="fa fa-info"></i></span></div></div><div class="col col-6"><div class="input-group"><input type="text" name="prom_point#currentrow#" onKeyUp="isNumber(this);" class="moneybox" value="#TLFormat(prom_point)#" readonly><span class="input-group-addon" title="<cf_get_lang dictionary_id='34380.Para Puan'>"><i class="fa fa-info"></i></span></div></div></div>
					</td>
					<td>						
						<div class="form-group"><input type="text" name="total_promotion_cost#currentrow#" id="total_promotion_cost#currentrow#" value="#TLFormat(total_promotion_cost)#" onKeyUp="isNumber(this);" class="moneybox"></div>
					</td>
					<td>						
						<div class="form-group"><input type="text" name="min_margin#currentrow#" id="min_margin#currentrow#" value="#TLFormat(min_margin)#" onKeyUp="isNumber(this);" class="moneybox"></div>
					</td>
					<td>						
						<div class="form-group"><input type="text" name="max_margin#currentrow#" id="max_margin#currentrow#" value="#TLFormat(max_margin)#" onKeyUp="isNumber(this);" class="moneybox"></div>
					</td>
					<td>						
						<div class="form-group"><input type="text" name="profitability#currentrow#" id="profitability#currentrow#" value="#TLFormat(profitability)#" onKeyUp="isNumber(this);" class="moneybox"></div>
					</td>
				</cfif>
				<cfif isdefined("is_row_page_type") and is_row_page_type eq 1>
					<td title="Sayfa No/ #get_catalog_product.product_name#">
						<div class="form-group"><input type="text" name="page_no#currentrow#" id="page_no#currentrow#" value="<cfif len(page_no)>#page_no#</cfif>" onKeyUp="isNumber(this);" class="moneybox"></div>
					</td>
					<td title="Sayfa Tipi/ #get_catalog_product.product_name#">
						<div class="form-group">
							<select name="page_type#currentrow#" id="page_type#currentrow#">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfloop query="get_page_types">
									<option value="#get_page_types.page_type_id#" <cfif get_page_types.page_type_id eq get_catalog_product.page_type_id>selected</cfif>>#get_page_types.page_type#</option>
								</cfloop>
							</select>
						</div>
					</td>
					<td title="Döküman Tipi/ #get_catalog_product.product_name#">
						<div class="form-group">
							<select name="paper_type#currentrow#" id="paper_type#currentrow#">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="1" <cfif paper_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='37216.Katalog'></option>
								<option value="2" <cfif paper_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='44844.Insert'></option>
							</select>
						</div>
					</td>
				</cfif>
			</tr>
		</cfoutput>
		</cfif>
		</tbody>
	</cf_grid_list>
<script type="text/javascript">
	row_count=<cfoutput>#recordnumber#</cfoutput>;
	function sil(sy)
	{
		var my_element=eval("form_basket.row_kontrol"+sy);
		my_element.value=0;
	
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	function add_row(sirano,product_id,stock_id,product_name,manufact_code,tax,tax_purchase,add_unit,product_unit_id,money,discount1,discount2,discount3,discount4,discount5,discount6,discount7,discount8,discount9,discount10,p_price,s_price,returning_price,returning_price_disc,back_end_rebate,rebate_rate,return_day,return_rate,price_protection_day,extra_product_1,extra_product_2,stock_code,barcod,stock_code_2,product_cost,profit_margin,p_price_kdv,page_no,page_type,paper_type,new_price_kdv1,new_price_kdv2,detail_info,ref_info,cons_count,unit_sale,sale_type_info,min_margin,max_margin)
	{
		if(page_no == undefined)
			page_no = '';
		if(page_type == undefined)
			page_type = '';
		if(paper_type == undefined)
			paper_type = '';
		if(new_price_kdv1 == undefined)
			new_price_kdv1 = '0';
		if(new_price_kdv2 == undefined)
			new_price_kdv2 = '0';
		if(detail_info == undefined)
			detail_info = '';
		if(ref_info == undefined)
			ref_info = '';
		if(sale_type_info == undefined)
			sale_type_info = '';
		if(cons_count == undefined)
			cons_count = '0';
		if(unit_sale == undefined)
			unit_sale = '0';
		var returning_price_kdvsiz=parseFloat((returning_price*100)/(100+parseFloat(tax)));
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.className = 'color-row';
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		newRow.setAttribute("title",product_name);
		document.getElementById('record_num').value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML='<a style="cursor:pointer" onclick="if (confirm(\'<cf_get_lang dictionary_id="57533.Silmek Istediginizden Emin Misiniz">\')) sil('+row_count+');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ="37781.Ürünü Sil">"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML='<div class="form-group"><div class="input-group"><input type="hidden" value="1" name="row_kontrol'+row_count+'"> <input type="hidden" name="product_id'+row_count+'" id="product_id'+row_count+'" value="'+product_id+'"><input type="hidden" name="stock_id'+row_count+'" id="stock_id'+row_count+'" value="'+stock_id+'"><input type="hidden" name="unit_id'+row_count+'" value="'+product_unit_id+'"><input type="text" name="product_name' + row_count + '" value="'+product_name+'"><span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_ac('+product_id+');"></span></div></div>';
		<cfif (isdefined("is_manufact_code") and is_manufact_code eq 1) or (not isdefined("is_manufact_code"))>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" title="<cf_get_lang dictionary_id ='37481.Ürt Kodu'>\n '+ product_name+'" name="manufact_code' + row_count + '" value="'+manufact_code+'"></div>';
		</cfif>
		<cfif (isdefined("is_stock_code") and is_stock_code eq 1) or (not isdefined("is_stock_code"))>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" title="<cf_get_lang dictionary_id ='57518.Stok Kodu'>\n '+ product_name+'" name="stock_code' + row_count + '" value="'+stock_code+'"></div>';
		</cfif>
		<cfif (isdefined("is_stock_code_2") and is_stock_code_2 eq 1) or (not isdefined("is_stock_code_2"))>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" title="<cf_get_lang dictionary_id ='57789.Özel Kod'>\n '+ product_name+'" name="stock_code_2' + row_count + '" value="'+stock_code_2+'"></div>';
		</cfif>
		<cfif (isdefined("is_barcod") and is_barcod eq 1) or (not isdefined("is_barcod"))>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" title="<cf_get_lang dictionary_id ='57633.Barkod'>\n '+ product_name+'" name="barcod' + row_count + '" value="'+barcod+'"></div>';
		</cfif>
		<cfif (isdefined("is_unit") and is_unit eq 1) or (not isdefined("is_unit"))>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" title ="<cf_get_lang dictionary_id ='57636.Birim'>\n '+ product_name+'"  name="unit' + row_count + '" readonly value="' + add_unit + '"></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" title ="<cf_get_lang dictionary_id ='57489.Para Br'>\n '+ product_name+'"  name="money' + row_count + '" readonly value="' + money + '"></div>';		

		<cfif (isdefined("is_row_price") and is_row_price eq 1) or (not isdefined("is_row_price"))>
			<cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" title ="<cf_get_lang dictionary_id ='37270.Alis KDV siz'>\n '+ product_name+'" name="p_price' + row_count + '"  value="' + commaSplit(p_price,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>) + '" class="moneybox" onBlur="pPriceChanged(' + row_count + ');" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));"></div>';
		  	  <cfif isdefined("is_price_kdv") and is_price_kdv eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("nowrap","nowrap");
				newCell.innerHTML = '<div class="form-group"><input type="text" title ="<cf_get_lang dictionary_id ='37271.Alis KDV li'>\n '+ product_name+'" name="p_price_kdv' + row_count + '"  value="' + commaSplit(p_price_kdv,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>) + '" class="moneybox" onBlur="pPriceChanged2(' + row_count + ');" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));"></div>'; 
		  	  </cfif>
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" title ="<cf_get_lang dictionary_id ='57448.Satis'>\n '+ product_name+'" name="s_price' + row_count + '"  value="' + commaSplit(s_price,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '" class="moneybox" readonly="yes" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>));"></div>';
			<cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("nowrap","nowrap");
				newCell.innerHTML = '<div class="form-group"><input type="text" title ="<cf_get_lang dictionary_id ='37313.S Marj'>\n '+ product_name+'" name="profit_margin' + row_count + '"  class="moneybox" readonly="yes" onkeyup="return(FormatCurrency(this,event));"></div>';
			</cfif>
		</cfif>

		<cfif isdefined("extra_price_list") and len(extra_price_list)>
			<cfoutput query="get_price_cat_row">
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="new_price_kdv#get_price_cat_row.price_catid#' + row_count + '"  value="' + commaSplit(new_price_kdv#get_price_cat_row.currentrow#,#session.ep.our_company_info.sales_price_round_num#) + '" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));" <cfif get_price_cat_row.currentrow eq 2>onBlur="hesapla_row_marj(#get_price_cat_row.price_catid#,' + row_count + ');"</cfif>><cfif get_price_cat_row.currentrow eq 1><input type="hidden" title ="<cf_get_lang dictionary_id ='37281.KDV Alis'>\n '+ product_name+'" name="tax_purchase' + row_count + '"  value="' + commaSplit(tax_purchase,0) + '" class="moneybox" readonly="yes"><input type="hidden" title ="<cf_get_lang dictionary_id ='37284.KDV Satis'>\n '+ product_name+'"  name="tax' + row_count + '"  value="' + commaSplit(tax,0) + '" class="moneybox" readonly="yes"></cfif></div>';
				<cfif get_price_cat_row.currentrow eq 1>
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<div class="form-group"><input type="text" name="new_cost' + row_count + '"  value="' + commaSplit(product_cost,#session.ep.our_company_info.sales_price_round_num#) + '" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));" readonly></div>';
				<cfelseif get_price_cat_row.currentrow eq 2>
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="new_marj' + row_count + '"  value="' + commaSplit(profit_margin,2) + '" class="moneybox" onkeyup="return(FormatCurrency(this,event));" readonly></div>';
					hesapla_row_marj('#get_price_cat_row.price_catid#',row_count);
				</cfif>
			</cfoutput>
		</cfif>
		<cfif (isdefined("is_row_discount") and is_row_discount eq 1) or (not isdefined("is_row_discount"))>
			<cfloop from="1" to="#discount_count#" index="kk">
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" title ="<cf_get_lang dictionary_id ='57641.İsk'><cfoutput>#kk#</cfoutput>\n '+ product_name+'" name="disc_ount<cfoutput>#kk#</cfoutput>' + row_count + '"  value="' + commaSplit(discount<cfoutput>#kk#</cfoutput>) + '" class="moneybox" onBlur="discChanged(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));"></div>';
			</cfloop>
		</cfif>
		<cfif (isdefined("is_row_cost") and is_row_cost eq 1) or (not isdefined("is_row_cost"))>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" title ="<cf_get_lang dictionary_id ='37358.Net Maliyet'>\n '+ product_name+'" name="row_nettotal' + row_count + '"  class="moneybox" readonly="yes" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" title ="<cf_get_lang dictionary_id ='37411.KDV li Maliyet'>\n '+ product_name+'" name="row_lasttotal' + row_count + '"  class="moneybox" readonly="yes" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));"></div>';
		</cfif>
		<cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" title ="<cf_get_lang dictionary_id ='37048.A Marj'>\n '+ product_name+'" name="action_profit_margin' + row_count + '"  value="0" class="moneybox" onBlur="actProfMargChanged(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" title ="<cf_get_lang dictionary_id ='37753.KDV Hariç'>\n '+ product_name+'" name="action_price_kdvsiz' + row_count + '" class="moneybox" onBlur="actPriceChanged(' + row_count + ',2);" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>));"><span class="input-group-addon icon-ellipsis btnPointer" onClick="getPrices(' + row_count + ',1);" alt="<cf_get_lang dictionary_id ='37780.Fiyat Seç'>"></span></div></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" title ="<cf_get_lang dictionary_id ='37365.KDV Dahil'>\n '+ product_name+'" name="action_price' + row_count + '" value="' + commaSplit(s_price,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '" class="moneybox" onBlur="actPriceChanged(' + row_count + ',1);" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>));"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" title ="<cf_get_lang dictionary_id ='37482.Tutar İnd'>\n '+ product_name+'" name="action_price_disc' + row_count + '" value="0" class="moneybox" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>));"></div>';
		</cfif>
		<cfif isdefined("is_money_type") and is_money_type eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><select title="<cf_get_lang dictionary_id ='57489.Para Birimi'>\n '+ product_name+'" name="sale_money_type' + row_count  +'"><cfoutput query="get_moneys"><option value="#money#" <cfif money eq session.ep.money>selected</cfif>>#money#</option></cfoutput></select></div>';
		</cfif>
		<cfif (isdefined("is_row_return_price") and is_row_return_price eq 1) or (not isdefined("is_row_return_price"))>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" title ="<cf_get_lang dictionary_id ='37753.KDV Hariç'>\n '+ product_name+'" name="returning_price_kdvsiz' + row_count + '"  class="moneybox" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>));" value="' + commaSplit(returning_price_kdvsiz,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '" onBlur="actPriceChangedReturn(' + row_count + ',2);"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" title ="<cf_get_lang dictionary_id ='37365.KDV Dahil'>\n '+ product_name+'" name="returning_price' + row_count + '"  class="moneybox" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>));" value="' + commaSplit(returning_price,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>) + '"  onBlur="actPriceChangedReturn(' + row_count + ',1);"><span class="input-group-addon icon-ellipsis btnPointer" onClick="getPrices(' + row_count + ',2);" alt="<cf_get_lang dictionary_id ='37780.Fiyat Seç'>"></span></div></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" title ="<cf_get_lang dictionary_id ='37482.Tutar İnd'>\n '+ product_name+'" name="returning_price_disc' + row_count + '" value="' + commaSplit(returning_price_disc,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '" class="moneybox" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>));"></div>';
		</cfif>
		<cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" title ="<cf_get_lang dictionary_id ='37281.KDV Alis'>\n '+ product_name+'" name="tax_purchase' + row_count + '"  value="' + commaSplit(tax_purchase,0) + '" class="moneybox" readonly="yes" onkeyup="return(FormatCurrency(this,event));"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" title ="<cf_get_lang dictionary_id ='37284.KDV Satis'>\n '+ product_name+'"  name="tax' + row_count + '"  value="' + commaSplit(tax,0) + '" class="moneybox" readonly="yes" onkeyup="return(FormatCurrency(this,event));"></div>';
		</cfif>
		<cfif (isdefined("is_row_due") and is_row_due eq 1) or (not isdefined("is_row_due"))>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" title ="<cf_get_lang dictionary_id ='57640.Vade'>\n '+ product_name+'" name="duedate' + row_count + '"  value="0" class="moneybox"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" title ="<cf_get_lang dictionary_id ='37110.Raf Tipi'>\n '+ product_name+'" name="shelf_id' + row_count + '" ><input type="text" name="shelf_name' + row_count + '" value=""><span class="input-group-addon icon-ellipsis btnPointer" onClick="getShelf(' + row_count + ');" alt="<cf_get_lang dictionary_id ='37105.Raf Seç'>"></span></div></div>';
		</cfif>
		<cfif (isdefined("is_row_condition") and is_row_condition eq 1) or (not isdefined("is_row_condition"))>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input  type="text" title ="Back End Rebate\n '+ product_name+'" name="rebate_cash_1' + row_count + '" value="' + commaSplit(back_end_rebate) + '" class="moneybox" onKeyUp="return(FormatCurrency(this,event));"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input  type="text" title ="<cf_get_lang dictionary_id ='37856.Back End Rebate Oran'>\n '+ product_name+'" name="rebate_rate' + row_count + '" value="' + commaSplit(rebate_rate) + '" class="moneybox" onKeyUp="return(FormatCurrency(this,event));"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><div class="col col-6"><input  type="text" title ="<cf_get_lang dictionary_id ='37660.Mal Fazlası'>\n '+ product_name+'" name="extra_product_1' + row_count + '" value="' + commaSplit(extra_product_1) + '" class="moneybox" onKeyUp="return(FormatCurrency(this,event));"></div><div class="col col-6"><input  type="text" title ="<cf_get_lang dictionary_id ='37660.Mal Fazlası'>\n '+ product_name+'" name="extra_product_2' + row_count + '" value="' + commaSplit(extra_product_2) + '" class="moneybox" onKeyUp="return(FormatCurrency(this,event));"></div></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><div class="col col-6"><input  type="text" title ="<cf_get_lang dictionary_id ='37662.İade Gün'>- <cf_get_lang dictionary_id ='58456.Oran'>\n '+ product_name+'" name="return_day' + row_count + '" value="' + commaSplit(return_day) + '" class="moneybox" onKeyUp="return(FormatCurrency(this,event));"></div><div class="col col-6"><input  type="text" title ="<cf_get_lang dictionary_id ='37662.İade Gün'>-<cf_get_lang dictionary_id ='58456.Oran'> \n '+ product_name+'" name="return_rate' + row_count + '" value="' + commaSplit(return_rate) + '" class="moneybox" onKeyUp="return(FormatCurrency(this,event));"></div></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input  type="text" title ="<cf_get_lang dictionary_id ='37661.Fiyat Koruma Gün'>\n '+ product_name+'" name="price_protection_day' + row_count + '" value="' + commaSplit(price_protection_day) + '" class="moneybox" onKeyUp="return(FormatCurrency(this,event));"></div>';
		</cfif>
		<cfif isdefined("is_extra_definition") and is_extra_definition eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" name="detail_info' + row_count + '" title ="<cf_get_lang dictionary_id ='57629.Açıklama'>\n '+ product_name+'" value="'+detail_info+'" maxlength="250"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" name="ref_code' + row_count + '" title ="<cf_get_lang dictionary_id ='37134.Referans Kod'>\n '+ product_name+'" value="'+ref_info+'" maxlength="50"></div>';
		</cfif>
		<cfif isdefined("is_sale_target") and is_sale_target eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" name="customer_num' + row_count + '" title ="<cf_get_lang dictionary_id ='37168.Müşteri Sayısı'>\n '+ product_name+'" class="moneybox" value="'+cons_count+'" onKeyUp="isNumber(this);" onBlur="hesapla_sale(' + row_count + ');"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" name="unit_sale' + row_count + '" title ="<cf_get_lang dictionary_id ='37150.Birim Satış'>\n '+ product_name+'" class="moneybox" value="'+commaSplit(unit_sale)+'" onKeyUp="return(FormatCurrency(this,event));" onBlur="hesapla_sale(' + row_count + ');"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" name="total_sale' + row_count + '" title ="<cf_get_lang dictionary_id ='54587.Toplam Satış'>\n '+ product_name+'" class="moneybox" value="'+commaSplit(0)+'" readonly></div>';
			
			newCell = newRow.insertCell(newRow.cells.length);			
			c = '<div class="form-group"><select name="sale_type_info' + row_count  +'" class="text" title ="<cf_get_lang dictionary_id ='37215.Satış Tipi'>\n '+ product_name+'">';
			if(sale_type_info == 1)
				c += '<option value="1" selected><cf_get_lang dictionary_id ='37239.Normal Satış'></option>';
			else
				c += '<option value="1"><cf_get_lang dictionary_id ='37239.Normal Satış'></option>';
				
			if(sale_type_info == 2)
				c += '<option value="2" selected><cf_get_lang dictionary_id ='37241.Set Bileşeni'></option>';
			else
				c += '<option value="2"><cf_get_lang dictionary_id ='37241.Set Bileşeni'></option>';
				
			if(sale_type_info == 3)
				c += '<option value="3" selected><cf_get_lang dictionary_id ='37242.Promosyon Faydası'></option>';
			else
				c += '<option value="3"><cf_get_lang dictionary_id ='37242.Promosyon Faydası'></option>';
				
			if(sale_type_info == 4)
				c += '<option value="4" selected><cf_get_lang dictionary_id ='37265.Promosyon Koşulu'></option>';
			else
				c += '<option value="4"><cf_get_lang dictionary_id ='37265.Promosyon Koşulu'></option>';
				
			if(sale_type_info == 5)
				c += '<option value="5" selected><cf_get_lang dictionary_id ='37269.Set Ana Ürünü'></option>';
			else
				c += '<option value="5"><cf_get_lang dictionary_id ='37269.Set Ana Ürünü'></option>';
			newCell.innerHTML =c+ '</select></div>';
			<cfif isdefined("limit_type") and limit_type eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="hidden" name="prom_id' + row_count + '" value="<cfoutput>#attributes.prom_id#</cfoutput>"><input type="text" name="promotion_code' + row_count + '" onKeyUp="isNumber(this);" class="moneybox" value="<cfoutput>#attributes.promotion_code#</cfoutput>"></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<cfoutput><cfif (isdefined("attributes.number_gift_product") and len(attributes.number_gift_product)) or (isdefined("attributes.number_gift_product_ratio") and len(attributes.number_gift_product_ratio))>Aynı Üründen <cfif isdefined("attributes.number_gift_product") and len(attributes.number_gift_product)><input type="hidden" name="number_gift_product' + row_count + '" value="#attributes.number_gift_product#">#attributes.number_gift_product# Adet</cfif> <cfif isdefined("attributes.number_gift_product_ratio") and len(attributes.number_gift_product_ratio)><input type="hidden" name="number_gift_product_ratio' + row_count + '" value="#attributes.number_gift_product_ratio#">%#attributes.number_gift_product_ratio# İndirim</cfif></br></cfif><cfif isdefined("attributes.free_product") and len(attributes.free_product)><input type="hidden" value="#attributes.free_stock_id#" name="free_stock_id' + row_count + '">Özel Üründen (#attributes.free_product#) <cfif isdefined("attributes.free_stock_amount") and len(attributes.free_stock_amount)><input type="hidden" value="#attributes.free_stock_amount#" name="free_stock_amount' + row_count + '">#attributes.free_stock_amount# Adet </cfif><cfif isdefined("attributes.special_product_discount_rate") and len(attributes.special_product_discount_rate)><input type="hidden" name="special_product_discount_rate' + row_count + '" value="#attributes.special_product_discount_rate#"> %#attributes.special_product_discount_rate# İndirim</cfif></cfif></cfoutput>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="amount_1_' + row_count + '" onKeyUp="isNumber(this);" class="moneybox" value="' + commaSplit(<cfoutput>#attributes.amount_1#</cfoutput>,4) + '" readonly></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><div class="col col-6"><div class="input-group"><input type="text" name="amount_discount_2_' + row_count + '" onKeyUp="isNumber(this);" class="moneybox" value="' + commaSplit(<cfoutput>#attributes.amount_discount_2#</cfoutput>,4) + '" readonly><span class="input-group-addon" title="<cf_get_lang dictionary_id='63969.Alışveriş Kuponu'>"><i class="fa fa-info"></i></span></div></div><div class="col col-6"><div class="input-group"><input type="text" name="prom_point' + row_count + '" onKeyUp="isNumber(this);" class="moneybox" value="' + commaSplit(<cfoutput>#attributes.prom_point#</cfoutput>,4) + '" readonly><span class="input-group-addon" title="<cf_get_lang dictionary_id='34380.Para Puan'>"><i class="fa fa-info"></i></span></div></div></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="total_promotion_cost' + row_count + '" onKeyUp="isNumber(this);" class="moneybox" value="' + commaSplit(<cfoutput>#attributes.total_promotion_cost#</cfoutput>,4) + '" readonly></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="min_margin' + row_count + '" onKeyUp="isNumber(this);" class="moneybox" value="' + commaSplit(min_margin,4) + '" readonly></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="max_margin' + row_count + '" onKeyUp="isNumber(this);" class="moneybox" value="' + commaSplit(max_margin,4) + '" readonly></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="profitability' + row_count + '" onKeyUp="isNumber(this);" class="moneybox" readonly></div>';				
			</cfif>
			<cfif isdefined("is_row_page_type") and is_row_page_type eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" name="page_no' + row_count + '" title ="<cf_get_lang dictionary_id ='53685.Sayfa No'>\n '+ product_name+'" onKeyUp="isNumber(this);" class="moneybox" value="'+page_no+'"></div>';
			newCell = newRow.insertCell(newRow.cells.length);;
			newCell.setAttribute("nowrap","nowrap");
			a = '<div class="form-group"><select name="page_type' + row_count  +'"title ="<cf_get_lang dictionary_id ='58069.Sayfa Tipi'>\n '+ product_name+'" class="text"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>';
			<cfoutput query="get_page_types">
				if('#page_type_id#' == page_type)
					a += '<option value="#page_type_id#" selected>#page_type#</option>';
				else if('#is_default#' == 1)
					a += '<option value="#page_type_id#" selected>#page_type#</option>';
				else
					a += '<option value="#page_type_id#">#page_type#</option>';
			</cfoutput>
			newCell.innerHTML =a+ '</select></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			b = '<div class="form-group"><select name="paper_type' + row_count  +'" class="text" title ="<cf_get_lang dictionary_id ='58067.Döküman Tipi'>\n '+ product_name+'><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>';
			if(paper_type == 1)
				b += '<option value="1" selected><cf_get_lang dictionary_id ='37216.Katalog'></option>';
			else
				b += '<option value="1"><cf_get_lang dictionary_id ='37216.Katalog'></option>';
			if(paper_type == 2)
				b += '<option value="2" selected>İnsert</option>';
			else
				b += '<option value="2">İnsert</option>';
			newCell.innerHTML =b+ '</select></div>';
		</cfif>
			hesapla_sale(row_count);
		</cfif>
		//S. Marj hesaplaniyor
		if (p_price == 0)
			var profit_margin = 100;
		else
			var profit_margin = wrk_round(( (s_price - p_price) / p_price ) * 100);
		if(eval("form_basket.profit_margin"+row_count) != undefined)
			eval("form_basket.profit_margin"+row_count).value = commaSplit(profit_margin);
	
		//Net Maliyet hesaplaniyor
		if(eval("form_basket.row_nettotal"+row_count) != undefined)
			eval("form_basket.row_nettotal"+row_count).value = commaSplit( (p_price/10000000000) * ((100-discount1) * (100-discount2) * (100-discount3) * (100-discount4) * (100-discount5)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput> );
		
		//KDV li maliyet hesaplaniyor
		if(eval("form_basket.row_lasttotal"+row_count) != undefined)
			eval("form_basket.row_lasttotal"+row_count).value = commaSplit( (filterNum(eval("form_basket.row_nettotal"+row_count).value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>) * (Number(filterNum(eval("form_basket.tax_purchase"+row_count).value),4)+100) ) /100 ,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);  
		
		//Aksiyon Fiyat KDV Dahil hesaplaniyor
		if(eval("form_basket.action_price_kdvsiz"+row_count) != undefined && eval("form_basket.tax"+row_count) != undefined){
			eval("form_basket.action_price_kdvsiz"+row_count).value = commaSplit( (s_price*100)/(Number(filterNum(eval("form_basket.tax"+row_count).value)) + 100),<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
			eval("form_basket.profitability"+row_count).value = commaSplit((filterNum(eval('form_basket.action_price_kdvsiz'+row_count).value)-(<cfif isdefined("attributes.total_promotion_cost")>parseFloat(<cfoutput>#attributes.total_promotion_cost#</cfoutput>)<cfelse>0</cfif> + filterNum(eval('form_basket.row_nettotal'+row_count).value))+filterNum(eval('form_basket.rebate_cash_1'+row_count).value)));
			if($("input[name=profitability"+row_count+"]").val()<$("input[name=min_margin"+row_count+"]").val()) newRow.setAttribute("style","background-color:rgb(255 0 0 / 50%)");
			
		}
	}	
	function hesapla_row_marj(price_cat_id,row_info)
	{
		satir_deger_1 = filterNum(eval('form_basket.new_price_kdv'+price_cat_id+''+row_info).value);
		satir_deger_2 = filterNum(eval('form_basket.new_cost'+row_info).value);
		satir_tax = filterNum(eval('form_basket.tax'+row_info).value);
		satir_kdvsiz = parseFloat(satir_deger_1/((satir_tax/100)+1));
		eval('form_basket.new_marj'+row_info).value = commaSplit(parseFloat((satir_deger_2/satir_kdvsiz)*100-100));
	}
	function hesapla_sale(row_info)
	{
		satir_deger_1 = filterNum(eval('form_basket.customer_num'+row_info).value);
		satir_deger_2 = filterNum(eval('form_basket.unit_sale'+row_info).value);
		eval('form_basket.total_sale'+row_info).value = commaSplit(parseFloat(satir_deger_1*satir_deger_2));
	}
	function pencere_ac(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&draggable=1&is_sub_category=1&pid='+no);
	}
	
	function getShelf(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_list_shelf&draggable=1&shelf_id=form_basket.shelf_id'+no+'&shelf_name=form_basket.shelf_name'+no);
	}
	
	function getPrices(no,type)
	{
		checkedValues_b = $("#PRICE_CATS").multiselect("getChecked");
		var price_lists='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(price_lists == '')
				price_lists = checkedValues_b[kk].value;
			else
				price_lists = price_lists + ',' + checkedValues_b[kk].value;
		}
		if(type== undefined || type==2)
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_list_prices<cfif isdefined("attributes.compid")>&compid=<cfoutput>#attributes.compid#</cfoutput></cfif>&field_price_kdv=form_basket.returning_price'+no+'&field_price=form_basket.returning_price_kdvsiz'+no+'&field_discount=form_basket.returning_price_disc'+no+'&pid='+eval('form_basket.product_id'+no).value+'&finishdate='+document.all.finishdate.value+'&price_lists='+price_lists+'&tax='+eval("form_basket.tax"+no).value,'medium');
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_list_prices<cfif isdefined("attributes.compid")>&compid=<cfoutput>#attributes.compid#</cfoutput></cfif>&field_price_kdv=form_basket.action_price'+no+'&field_price=form_basket.action_price_kdvsiz'+no+'&field_discount=form_basket.action_price_disc'+no+'&pid='+eval('form_basket.product_id'+no).value+'&finishdate='+document.all.finishdate.value+'&price_lists='+price_lists+'&tax='+eval("form_basket.tax"+no).value,'medium');
		
	}
	function pPriceChanged2(rowcnt)
	{
		//BK ekledi 20080501 Standart Alis Kdv li fiyat sutunu gelirse. Hazır fonksiyonlarda kullaniliyor
		p_price_kdv = parseFloat(filterNum(eval("form_basket.p_price_kdv"+rowcnt).value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));
		eval("form_basket.p_price"+rowcnt).value = commaSplit( (p_price_kdv*100)/(Number(filterNum(eval("form_basket.tax"+row_count).value)) + 100),<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
		return pPriceChanged(row_count);
	}
	
	function pPriceChanged(rowcnt)
	{
		p_price = parseFloat(filterNum(eval("form_basket.p_price"+rowcnt).value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));
		s_price = filterNum(eval("form_basket.s_price"+rowcnt).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
		if (isNaN(p_price)) 
			p_price=0;
		//Standart Alis KDV li fiyati hesaplaniyor
		<cfif isdefined("is_price_kdv") and is_price_kdv eq 1>
			eval("form_basket.p_price_kdv"+rowcnt).value = commaSplit(p_price * (Number(filterNum(eval("form_basket.tax_purchase"+rowcnt).value))+100)  /100 ,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		</cfif>

		eval("form_basket.p_price"+rowcnt).value = commaSplit(p_price,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		
		//S. Marj hesaplaniyor
		if (p_price == 0)
			var profit_margin = 100;
		else
			var profit_margin = wrk_round(( (s_price - p_price) / p_price ) * 100);
		eval("form_basket.profit_margin"+rowcnt).value = commaSplit(profit_margin);
		return discChanged(rowcnt);
	}
	
	function discChanged(rowcnt)
	{
		if(eval("form_basket.disc_ount1"+rowcnt) != undefined)
		{
			indirim1 = filterNum(eval("form_basket.disc_ount1"+rowcnt).value); 
			if(indirim1 < 0 || indirim1 > 100) {alert(rowcnt + "<cf_get_lang dictionary_id ='37803.no lu satırdaki İskonto 1 alanındaki değer 0 ile 100 arasında olmalı'>  !"); return false;}
		}
		else
			indirim1 = 0;

		if(eval("form_basket.disc_ount2"+rowcnt) != undefined)
		{
			indirim2 = filterNum(eval("form_basket.disc_ount2"+rowcnt).value);
			if(indirim2 < 0 || indirim2 > 100) {alert(rowcnt + "<cf_get_lang dictionary_id ='37804.no lu satırdaki İskonto 2 alanındaki değer 0 ile 100 arasında olmalı'>  !"); return false;}
		}
		else
			indirim2 = 0;

		if(eval("form_basket.disc_ount3"+rowcnt) != undefined)
		{
			indirim3 = filterNum(eval("form_basket.disc_ount3"+rowcnt).value);
			if(indirim3 < 0 || indirim3 > 100) {alert(rowcnt + "<cf_get_lang dictionary_id ='37805.no lu satırdaki İskonto 3 alanındaki değer 0 ile 100 arasında olmalı'>  !"); return false;}
		}
		else
			indirim3 = 0;

		if(eval("form_basket.disc_ount4"+rowcnt) != undefined)
		{
			indirim4 = filterNum(eval("form_basket.disc_ount4"+rowcnt).value);
			if(indirim4 < 0 || indirim4 > 100) {alert(rowcnt + "<cf_get_lang dictionary_id ='37806.no lu satırdaki İskonto 4 alanındaki değer 0 ile 100 arasında olmalı'> !"); return false;}
		}
		else
			indirim4 = 0;

		if(eval("form_basket.disc_ount5"+rowcnt) != undefined)
		{
			indirim5 = filterNum(eval("form_basket.disc_ount5"+rowcnt).value);
			if(indirim5 < 0 || indirim5 > 100) {alert(rowcnt + "<cf_get_lang dictionary_id ='37807.no lu satırdaki İskonto 5 alanındaki değer 0 ile 100 arasında olmalı'>  !"); return false;}
		}
		else
			indirim5 = 0;

		if(eval("form_basket.disc_ount6"+rowcnt) != undefined)
		{
			indirim6 = filterNum(eval("form_basket.disc_ount6"+rowcnt).value); 
			if(indirim6 < 0 || indirim6 > 100) {alert(rowcnt + "<cf_get_lang dictionary_id ='37808.no lu satırdaki İskonto 6 alanındaki değer 0 ile 100 arasında olmalı'>  !"); return false;}
		}
		else
			indirim6 = 0;

		if(eval("form_basket.disc_ount7"+rowcnt) != undefined)
		{
			indirim7 = filterNum(eval("form_basket.disc_ount7"+rowcnt).value);
			if(indirim7 < 0 || indirim7 > 100) {alert(rowcnt + "<cf_get_lang dictionary_id ='37809.no lu satırdaki İskonto 7 alanındaki değer 0 ile 100 arasında olmalı'>  !"); return false;}
		}
		else
			indirim7 = 0;

		if(eval("form_basket.disc_ount8"+rowcnt) != undefined)
		{
			indirim8 = filterNum(eval("form_basket.disc_ount8"+rowcnt).value);
			if(indirim8 < 0 || indirim8 > 100) {alert(rowcnt + "<cf_get_lang dictionary_id ='37810.no lu satırdaki İskonto 8 alanındaki değer 0 ile 100 arasında olmalı'>  !"); return false;}
		}
		else
			indirim8 = 0;

		if(eval("form_basket.disc_ount9"+rowcnt) != undefined)
		{
			indirim9 = filterNum(eval("form_basket.disc_ount9"+rowcnt).value);
			if(indirim9 < 0 || indirim9 > 100) {alert(rowcnt + "<cf_get_lang dictionary_id ='37811.no lu satırdaki İskonto 9 alanındaki değer 0 ile 100 arasında olmalı'>  !"); return false;}
		}
		else
			indirim9 = 0;

		if(eval("form_basket.disc_ount10"+rowcnt) != undefined)
		{
			indirim10 = filterNum(eval("form_basket.disc_ount10"+rowcnt).value);
			if(indirim10 < 0 || indirim10 > 100) {alert(rowcnt + "<cf_get_lang dictionary_id ='37812.no lu satırdaki İskonto 10 alanındaki değer 0 ile 100 arasında olmalı'>  !"); return false;}
		}
		else
			indirim10 = 0;
		
		if (indirim1 == '' && eval("form_basket.disc_ount1"+rowcnt) != undefined) {eval("form_basket.disc_ount1"+rowcnt).value=0;indirim1 = 0;}
		if (indirim2 == '' && eval("form_basket.disc_ount2"+rowcnt) != undefined) {eval("form_basket.disc_ount2"+rowcnt).value=0;indirim2 = 0;}
		if (indirim3 == '' && eval("form_basket.disc_ount3"+rowcnt) != undefined) {eval("form_basket.disc_ount3"+rowcnt).value=0;indirim3 = 0;}
		if (indirim4 == '' && eval("form_basket.disc_ount4"+rowcnt) != undefined) {eval("form_basket.disc_ount4"+rowcnt).value=0;indirim4 = 0;}
		if (indirim5 == '' && eval("form_basket.disc_ount5"+rowcnt) != undefined) {eval("form_basket.disc_ount5"+rowcnt).value=0;indirim5 = 0;}
		if (indirim6 == '' && eval("form_basket.disc_ount6"+rowcnt) != undefined) {eval("form_basket.disc_ount6"+rowcnt).value=0;indirim6 = 0;}
		if (indirim7 == '' && eval("form_basket.disc_ount7"+rowcnt) != undefined) {eval("form_basket.disc_ount7"+rowcnt).value=0;indirim7 = 0;}
		if (indirim8 == '' && eval("form_basket.disc_ount8"+rowcnt) != undefined) {eval("form_basket.disc_ount8"+rowcnt).value=0;indirim8 = 0;}
		if (indirim9 == '' && eval("form_basket.disc_ount9"+rowcnt) != undefined) {eval("form_basket.disc_ount9"+rowcnt).value=0;indirim9 = 0;}
		if (indirim10 == '' && eval("form_basket.disc_ount10"+rowcnt) != undefined) {eval("form_basket.disc_ount10"+rowcnt).value=0;indirim10 = 0;}
		
		if(eval("form_basket.action_profit_margin"+rowcnt) != undefined)
			actProfMarg = filterNum(eval("form_basket.action_profit_margin"+rowcnt).value);
		else
			actProfMarg = 0;
		if (actProfMarg == '' && eval("form_basket.action_profit_margin"+rowcnt) != undefined) {eval("form_basket.action_profit_margin"+rowcnt).value=0;actProfMarg = 0;}
	
		//Net Maliyet hesaplaniyor
		if(eval("form_basket.row_nettotal"+row_count) != undefined && eval("form_basket.p_price"+rowcnt) != undefined)
			eval("form_basket.row_nettotal"+rowcnt).value = commaSplit( (filterNum(eval("form_basket.p_price"+rowcnt).value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>)/100000000000000000000) * ( (100-indirim1) * (100-indirim2) * (100-indirim3) * (100-indirim4) * (100-indirim5) * (100-indirim6) * (100-indirim7) * (100-indirim8) * (100-indirim9) * (100-indirim10) ) ,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		//KDV li maliyet hesaplaniyor
		if(eval("form_basket.row_lasttotal"+row_count) != undefined)
			eval("form_basket.row_lasttotal"+rowcnt).value = commaSplit( (filterNum(eval("form_basket.row_nettotal"+rowcnt).value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>) * (Number(filterNum(eval("form_basket.tax_purchase"+rowcnt).value))+100) ) /100 ,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);  
	
		if(eval("form_basket.row_nettotal"+row_count) != undefined && filterNum(eval("form_basket.row_nettotal"+rowcnt).value) > 0)
		{
			//Aksiyon Fiyat KDV Dahil hesaplaniyor
			eval("form_basket.action_price"+rowcnt).value = commaSplit( ( (filterNum(eval("form_basket.row_nettotal"+rowcnt).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>)*(Number(actProfMarg) + 100))*(Number(filterNum(eval("form_basket.tax"+rowcnt).value)) + 100) ) / 10000,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
			//Aksiyon Fiyat KDV Haric hesaplaniyor
			if(eval("form_basket.action_price_kdvsiz"+row_count) != undefined)
				eval("form_basket.action_price_kdvsiz"+rowcnt).value = commaSplit( (filterNum(eval("form_basket.action_price"+rowcnt).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>)*100)/(Number(filterNum(eval("form_basket.tax"+rowcnt).value)) + 100),<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
		}else
		{
			//Aksiyon Fiyat KDV Dahil hesaplaniyor
			if(eval("form_basket.action_price_kdvsiz"+row_count) != undefined)
			{
				eval("form_basket.action_price_kdvsiz"+rowcnt).value = commaSplit(actProfMarg,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
				//Aksiyon Fiyat KDV Haric hesaplaniyor
				eval("form_basket.action_price"+rowcnt).value = commaSplit( (filterNum(eval("form_basket.action_price_kdvsiz"+rowcnt).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>)*(Number(filterNum(eval("form_basket.tax"+rowcnt).value)) + 100))/100,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);	
			}
		}	
	}
	
	function actProfMargChanged(rowcnt)
	{
		if(eval("form_basket.action_profit_margin"+rowcnt) != undefined)
			actProfMarg = filterNum(eval("form_basket.action_profit_margin"+rowcnt).value);
		else
			actProfMarg = 0;
		if (actProfMarg == '' && eval("form_basket.action_profit_margin"+rowcnt) != undefined) 
		{
			eval("form_basket.action_profit_margin"+rowcnt).value = 0;
			actProfMarg = 0;
		}
		if(eval("form_basket.row_nettotal"+row_count) != undefined && filterNum(eval("form_basket.row_nettotal"+rowcnt).value) > 0)
		{
			//KDV li maliyet hesaplaniyor
			eval("form_basket.row_lasttotal"+rowcnt).value = commaSplit( (filterNum(eval("form_basket.row_nettotal"+rowcnt).value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>) * (Number(filterNum(eval("form_basket.tax_purchase"+rowcnt).value))+100) ) /100,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput> );  
			if(eval("form_basket.action_price_kdvsiz"+row_count) != undefined)
			{
				//Aksiyon Fiyat KDV Dahil hesaplaniyor
				eval("form_basket.action_price"+rowcnt).value = commaSplit( ( (filterNum(eval("form_basket.row_nettotal"+rowcnt).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>)*(Number(actProfMarg) + 100))*(Number(filterNum(eval("form_basket.tax"+rowcnt).value)) + 100) ) / 10000,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
				//Aksiyon Fiyat KDV Haric hesaplaniyor
				eval("form_basket.action_price_kdvsiz"+rowcnt).value = commaSplit( (filterNum(eval("form_basket.action_price"+rowcnt).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>)*100)/(Number(filterNum(eval("form_basket.tax"+rowcnt).value)) + 100),<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);		
			}
		}
		else
		{
			if(eval("form_basket.action_price_kdvsiz"+row_count) != undefined)
			{
				//Aksiyon Fiyat KDV Dahil hesaplaniyor
				eval("form_basket.action_price_kdvsiz"+rowcnt).value = commaSplit(actProfMarg,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
				//Aksiyon Fiyat KDV Haric hesaplaniyor
				eval("form_basket.action_price"+rowcnt).value = commaSplit( (filterNum(eval("form_basket.action_price_kdvsiz"+rowcnt).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>)*(Number(filterNum(eval("form_basket.tax"+rowcnt).value)) + 100))/100,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);	
			}
		}
	}
	
	function actPriceChangedReturn(rowcnt,type)
	{
			actPrice = filterNum(eval("form_basket.returning_price"+rowcnt).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
			actPriceKdvsiz = filterNum(eval("form_basket.returning_price_kdvsiz"+rowcnt).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
	
			if (actPrice == '' || actPriceKdvsiz == '')
			{
				if(eval("form_basket.action_price_kdvsiz"+row_count) != undefined)
				{
					eval("form_basket.action_price"+rowcnt).value=0;
					eval("form_basket.action_price_kdvsiz"+rowcnt).value=0;
				}
				actPrice = 0;
				actPriceKdvsiz = 0 ;
			}
			
			//Donus Fiyat KDV Dahil hesaplaniyor
			if(type ==1)
				eval("form_basket.returning_price_kdvsiz"+rowcnt).value = commaSplit((actPrice/(100 +(Number(filterNum(eval("form_basket.tax"+rowcnt).value))))*100),<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
			else
				eval("form_basket.returning_price"+rowcnt).value = commaSplit((actPriceKdvsiz*(100+filterNum(eval("form_basket.tax"+rowcnt).value)))/100,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
	}
	
	function actPriceChanged(rowcnt,type)
	{
		if(eval("form_basket.action_price_kdvsiz"+row_count) != undefined)
		{
			actPrice = filterNum(eval("form_basket.action_price"+rowcnt).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
			actPriceKdvsiz = filterNum(eval("form_basket.action_price_kdvsiz"+rowcnt).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
		}
		else
		{
			actPrice = 0;
			actPriceKdvsiz = 0 ;
		}
		if (actPrice == '' || actPriceKdvsiz == '')
		{
			eval("form_basket.action_price"+rowcnt).value=0;
			eval("form_basket.action_price_kdvsiz"+rowcnt).value=0;
			actPrice = 0;
			actPriceKdvsiz = 0 ;
		}
		
		//Aksiyon Fiyat KDV Dahil hesaplaniyor
		if(type ==1)
		{
			eval("form_basket.action_price_kdvsiz"+rowcnt).value = commaSplit((actPrice/(100 +(Number(filterNum(eval("form_basket.tax"+rowcnt).value))))*100),<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
			if (eval("form_basket.row_nettotal"+row_count) != undefined && filterNum(eval("form_basket.row_nettotal"+rowcnt).value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>) != 0)
				eval("form_basket.action_profit_margin"+rowcnt).value = commaSplit( ((( ((actPrice*100)/(Number(filterNum(eval("form_basket.tax"+rowcnt).value)) + 100)) - filterNum(eval("form_basket.row_nettotal"+rowcnt).value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>))*100)/filterNum(eval("form_basket.row_nettotal"+rowcnt).value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>)));
			else if(eval("form_basket.action_profit_margin"+rowcnt) != undefined)
				eval("form_basket.action_profit_margin"+rowcnt).value = 100;
		}
		else
		{
			eval("form_basket.action_price"+rowcnt).value = commaSplit((parseFloat(actPriceKdvsiz)+parseFloat(((actPriceKdvsiz/100)*filterNum(eval("form_basket.tax"+rowcnt).value)))),<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
			if (eval("form_basket.row_nettotal"+row_count) != undefined && filterNum(eval("form_basket.row_nettotal"+rowcnt).value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>) != 0)
				eval("form_basket.action_profit_margin"+rowcnt).value = commaSplit( ((( ((actPriceKdvsiz)) - filterNum(eval("form_basket.row_nettotal"+rowcnt).value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>))*100)/filterNum(eval("form_basket.row_nettotal"+rowcnt).value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>)));
			else if(eval("form_basket.action_profit_margin"+rowcnt) != undefined)
				eval("form_basket.action_profit_margin"+rowcnt).value =100;
		}
		<cfif isdefined("limit_type") and limit_type eq 1>
			eval("form_basket.profitability"+row_count).value = commaSplit((filterNum(eval('form_basket.action_price_kdvsiz'+row_count).value)-(<cfif isdefined("attributes.total_promotion_cost")>parseFloat(<cfoutput>#attributes.total_promotion_cost#</cfoutput>)<cfelse>0</cfif> + filterNum(eval('form_basket.row_nettotal'+row_count).value))+filterNum(eval('form_basket.rebate_cash_1'+row_count).value)));
			if($("input[name=profitability"+row_count+"]").val()<$("input[name=min_margin"+row_count+"]").val()) $('#frm_row'+row_count).css("background-color","rgb(255 0 0 / 50%)");
			else $('#frm_row'+row_count).css("background-color","#fff");
		</cfif>
	}
	
	function openProducts()
	{
		flag1 = false;
		if(document.all.startdate.value != '') 
		{
			flag1 = true;
		}
		
		flag3 = false;
		if(document.all.finishdate.value != '')
		{
			flag3 = true;
		}
		
		flag4 = false;
		if(document.all.kondusyon_date == undefined ||  (document.all.kondusyon_date != undefined && document.all.kondusyon_date.value != ''))
		{
			flag4 = true;
		}
		
		flag5 = false;
		if(document.all.kondusyon_finish_date == undefined || (document.all.kondusyon_finish_date != undefined && document.all.kondusyon_finish_date.value != ''))
		{
			flag5 = true;
		}
		
		flag2 = false;
		
		/*if(document.getElementById('PRICE_CATS') != undefined)
			price_lists = document.form_basket.PRICE_CATS.value;
		else
			price_lists = '';*/
		let price= document.getElementById("PRICE_CATS");			
		checkedValues_b_ = price.selectedOptions;
		var price_lists='';
		for(tt=0;tt<checkedValues_b_.length; tt++)
		{
			if(price_lists == '')
				price_lists = checkedValues_b_[tt].value;
			else
				price_lists = price_lists + ',' + checkedValues_b_[tt].value;
		}
		
		if(price_lists == '')
		{
			<cfif isdefined("extra_price_list") and len(extra_price_list)>
				flag2 = true;
			<cfelse>		
				flag2 = false;
			</cfif>
		}
		else
		{
			flag2 = true;
		}
		
		<cfif get_price_cats.recordcount>
		if (!flag1)
		{
			alert("<cf_get_lang dictionary_id ='37838.Geçerlilik Başlama Tarihini Giriniz'> !");
			//document.all.startdate.focus();
		}
		else if (!flag3)
		{
			alert("<cf_get_lang dictionary_id ='37839.Geçerlilik Bitiş Tarihini Giriniz'> !");
			//document.all.finishdate.focus();
		}
		else if (!flag4)
		{
			alert("<cf_get_lang dictionary_id ='37840.Kondüsyon Başlama Tarihini Giriniz'> !");
			//document.all.kondusyon_date.focus();
		}
		else if (!flag5)
		{
			alert("<cf_get_lang dictionary_id ='37841.Kondüsyon Bitiş Tarihini Giriniz'> !");
			//document.all.kondusyon_finish_date.focus();
		}
		else if (!flag2)
			alert("<cf_get_lang dictionary_id ='37842.En Az Bir Fiyat Listesi Seçmelisiniz'> !");
		else
			windowopen('<cfoutput>#request.self#?fuseaction=product.popup_products2<cfif isdefined("attributes.compid")>&compid=#attributes.compid#</cfif>&module_name=product&var_=#var_#&is_action=1&startdate='+document.all.startdate.value+'&finishdate='+document.all.finishdate.value+'<cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>&price_lists='+price_lists+'</cfif><cfif isdefined("is_condition_date") and is_condition_date eq 1>&check_kondusyon=<cfoutput>#is_condition_date#</cfoutput></cfif><cfif (isdefined("is_condition_date") and is_condition_date eq 1) or not isdefined("is_condition_date")>&kondusyon_date='+document.all.kondusyon_date.value+'&kondusyon_finish_date='+document.all.kondusyon_finish_date.value+'</cfif></cfoutput><cfif isdefined("is_promotion") and isdefined("prod_id_list")>&is_submitted=1&is_promotion=1&prod_id_list=<cfoutput>#prod_id_list#</cfoutput></cfif>','page');	
			// <cfif isdefined("attributes.catalog_id")>+'&catalog_id='+document.all.catalog_id.value</cfif>
		<cfelse>
			alert("<cf_get_lang dictionary_id='60383.Fiyat Listesi Tanımlamalısınız'> !");
		</cfif>	
	}
</script>
<cfif isdefined("attributes.is_from_file")>
	<cfinclude template="../query/add_basket_from_file.cfm">
</cfif>