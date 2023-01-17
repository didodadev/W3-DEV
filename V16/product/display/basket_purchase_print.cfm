<cfset recordnumber = 0>
<cfif IsDefined("attributes.id")>
	<cfinclude template="../query/get_catalog_promotion_products.cfm">
	<cfset recordnumber = get_catalog_product.RecordCount>
</cfif>
<cfinclude template="../../contract/query/get_moneys.cfm">
<cfinclude template="../../contract/query/get_units.cfm">

<table cellpadding="2" cellspacing="1" border="0" name="table1" id="table1" class="color-border">
	<tr class="color-header" height="22">
		<td class="form-title" nowrap></td>
		<td class="form-title" nowrap>&nbsp;</td>
		<td class="form-title" nowrap>&nbsp;</td>
		<td class="form-title" nowrap>&nbsp;</td>
		<td class="form-title" colspan="2" align="center" nowrap><cf_get_lang dictionary_id='37227.standart'></td>
		<td class="form-title" nowrap>&nbsp;</td>
		<td class="form-title" colspan="6" align="center" nowrap><cf_get_lang dictionary_id='57641.iskont'></td>
		<td class="form-title" colspan="1" align="center"><cf_get_lang dictionary_id='58258.Maliyet'></td>
		<td class="form-title" colspan="1" align="center" nowrap><cf_get_lang dictionary_id='57639.kdv'></td>
		<td class="form-title" colspan="3" align="center" nowrap><cf_get_lang dictionary_id='37049.Aksiyon Fiyat'></td>
		<td class="form-title" colspan="2" nowrap align="center"><cf_get_lang dictionary_id='57749.Dönüş Fiyatı'></td>
	</tr>
	<tr class="color-list">
		<td class="txtboldblue" nowrap><cf_get_lang dictionary_id='57629.Açıklama'></td>
		<td class="txtboldblue" nowrap><cf_get_lang dictionary_id='57789.Özel Kod'></td>				
		<td class="txtboldblue" nowrap width="20"><cf_get_lang dictionary_id='57636.Birim'></td>
		<td class="txtboldblue" nowrap width="60"><cf_get_lang dictionary_id='57489.Para Br'></td>
		<td width="70" align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58176.alış'></td>
		<td width="70" align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='57448.satış'></td>
		<td class="txtboldblue" nowrap width="45"><cf_get_lang dictionary_id='37313.S Mrj'></td>
		<td class="txtboldblue" nowrap width="20" align="center">1</td>
		<td class="txtboldblue" nowrap width="20" align="center">2</td>
		<td class="txtboldblue" nowrap width="20" align="center">3</td>
		<td class="txtboldblue" nowrap width="20" align="center">4</td>
		<td class="txtboldblue" nowrap width="20" align="center">5</td>
		<td class="txtboldblue" nowrap width="20" align="center">6</td>
		<td align="right" nowrap class="txtboldblue" style="text-align:right;" ><cf_get_lang dictionary_id='58716.KDV li'></td>
		<td class="txtboldblue" nowrap width="30"><cf_get_lang dictionary_id='57448.satış'></td>
		<td class="txtboldblue" nowrap width="45"><cf_get_lang dictionary_id='37048.A Mrj'></td>
		<td align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='37365.KDV Dahil'></td>
		<td align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='37598.Tutar İndirimi'></td>
		<td align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='37365.KDV Dahil'></td>
		<td align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='37598.Tutar İndirimi'></td>
	</tr>
<cfif IsDefined("attributes.id") and recordnumber>
  <cfoutput query="get_catalog_product">
	<tr id="frm_row#currentrow#" height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
		<td nowrap>#get_catalog_product.product_name#</td>
		<td>#get_catalog_product.product_code_2#</td>
		<td>#unit#</td>
		<td align="right" style="text-align:right;">#money#</td>
		<td align="right" style="text-align:right;">#TLFormat(purchase_price,4)#</td>
		<td align="right" style="text-align:right;">#TLFormat(sales_price)#</td>
		<td align="right" style="text-align:right;">#TLFormat(profit_margin)#</td>
		<td align="right" style="text-align:right;">#TLFormat(discount1)#</td>
		<td align="right" style="text-align:right;">#TLFormat(discount2)#</td>
		<td align="right" style="text-align:right;">#TLFormat(discount3)#</td>
		<td align="right" style="text-align:right;">#TLFormat(discount4)#</td>
		<td align="right" style="text-align:right;">#TLFormat(discount5)#</td>
		<td align="right" style="text-align:right;">#TLFormat(discount6)#</td>
		<td align="right" style="text-align:right;">#TLFormat(row_total,4)#</td>
		<td align="right" style="text-align:right;">#tax#</td>
		<td align="right" style="text-align:right;">#TLFormat(action_profit_margin)#</td>
		<td align="right" style="text-align:right;">#TLFormat(action_price)#</td>
		<td align="right" style="text-align:right;">#TLFormat(action_price_discount)#</td>
		<td align="right" style="text-align:right;">#TLFormat(returning_price)#</td>
		<td align="right" style="text-align:right;">#TLFormat(returning_price_discount)#</td>
	</tr>
  </cfoutput>
</cfif>
</table>
