<!--- <cfinclude template="../query/get_catalog_promotion_products.cfm"> --->
<cf_grid_list>
<thead>
	<tr>
		<th></th>
		<th></th>
		<th nowrap width="50"></th>
		<th align="center" colspan="3"><cf_get_lang dictionary_id='29411.fiyatlar'></th>
		<th align="center" colspan="10"><cf_get_lang dictionary_id='57641.indirim'></th>
		<th align="center" colspan="2"><cf_get_lang dictionary_id='58258.Maliyet'></th>
		<th align="center" colspan="2"><cf_get_lang dictionary_id='57639.KDV'></th>
		<th align="center" colspan="5"><cf_get_lang dictionary_id='37210.Aksiyon'></th>	
	</tr>
	<tr>
		<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
		<th width="30"><cf_get_lang dictionary_id='57636.Birim'></th>
		<th nowrap width="50"><cf_get_lang dictionary_id='57489.Para Br'></th>
		<th width="70" align="right" style="text-align:right;"><cf_get_lang dictionary_id='37041.Alış Fiyatı'></th>
		<th width="70" align="right" style="text-align:right;"><cf_get_lang dictionary_id='37042.Satış Fiyatı'></th>
		<th width="30"><cf_get_lang dictionary_id='37045.Kar Marjı'></th>
		<th width="20" align="center">1</th>
		<th width="20" align="center">2</th>
		<th width="20" align="center">3</th>
		<th width="20" align="center">4</th>
		<th width="20" align="center">5</th>
		<th width="20" align="center">6</th>
		<th width="20" align="center">7</th>
		<th width="20" align="center">8</th>
		<th width="20" align="center">9</th>
		<th width="20" align="center">10</th>
		<th width="70" align="right" style="text-align:right;"><cf_get_lang dictionary_id='37358.Net Maliyet'></th>
		<th align="right" style="text-align:right;"><cf_get_lang dictionary_id='37411.KDV li Maliyet'></th>
		<th width="30"><cf_get_lang dictionary_id='58176.alış'></th>
		<th width="30"><cf_get_lang dictionary_id='57448.satış'></th>
		<th width="40"><cf_get_lang dictionary_id='37045.Kar Marjı'></th>
		<th width="70" align="right" style="text-align:right;"><cf_get_lang dictionary_id='58084.Fiyat'></th>
		<th width="70" align="right" style="text-align:right;"><cf_get_lang dictionary_id='57749.Dönüş Fiyatı'></th>
		<th nowrap><cf_get_lang dictionary_id='57640.Vade'></th>
		<th nowrap><cf_get_lang dictionary_id='37024.Raf'></th>
	</tr>
	</thead>
	<tbody>
<cfoutput query="get_catalog_product">
	<cfif len(shelf_id)>
		<cfquery name="GET_SHELF_NAME" datasource="#DSN#">
			SELECT SHELF_NAME FROM SHELF WHERE SHELF_MAIN_ID = #shelf_id#
		</cfquery>
	</cfif>
	<tr>
		<td><!--- #get_product_name.product_name# --->#product_name#</td>
		<td>#unit#</td>
		<td>#money#</td>
		<td align="right" style="text-align:right;">#TLFormat(purchase_price,session.ep.our_company_info.purchase_price_round_num)#</td>
		<td align="right" style="text-align:right;">#TLFormat(sales_price,session.ep.our_company_info.sales_price_round_num)#</td>
		<td align="right" style="text-align:right;">#TLFormat(profit_margin)#</td>
		<td align="center">#TLFormat(discount1)#</td>
		<td align="center">#TLFormat(discount2)#</td>
		<td align="center">#TLFormat(discount3)#</td>
		<td align="center">#TLFormat(discount4)#</td>
		<td align="center">#TLFormat(discount5)#</td>
		<td align="center">#TLFormat(discount6)#</td>
		<td align="center">#TLFormat(discount7)#</td>
		<td align="center">#TLFormat(discount8)#</td>
		<td align="center">#TLFormat(discount9)#</td>
		<td align="center">#TLFormat(discount10)#</td>
		<td align="right" style="text-align:right;">#TLFormat(row_nettotal,session.ep.our_company_info.sales_price_round_num)#</td>
		<td align="right" style="text-align:right;">#TLFormat(row_total,session.ep.our_company_info.sales_price_round_num)#</td>
		<td>% #TLFormat(tax_purchase,0)#</td>
		<td>% #TLFormat(tax,0)#</td>
		<td>#TLFormat(action_profit_margin)#</td>
		<td align="right" style="text-align:right;">#TLFormat(action_price,session.ep.our_company_info.sales_price_round_num)#</td>
		<td align="right" style="text-align:right;">#TLFormat(returning_price,session.ep.our_company_info.sales_price_round_num)#</td>
		<td>#duedate#</td>
		<td><cfif len(shelf_id)>#get_shelf_name.shelf_name#</cfif></td>
	</tr>
</cfoutput>
</tbody>
</cf_grid_list>
