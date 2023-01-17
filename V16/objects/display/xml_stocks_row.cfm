<cfquery name="get_xml_stocks_row" datasource="#dsn2#">
	SELECT * FROM XML_STOCKS_ROW WHERE FILE_ID = #attributes.file_id#
</cfquery>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr height="35">
		<td class="headbold"><cf_get_lang dictionary_id="29766.XML"> <cf_get_lang dictionary_id="57452.Stok"></td>
	</tr>
</table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr class="color-border">
		<td>
		<table width="100%" border="0" cellspacing="1" cellpadding="2">
			<tr height="22" class="color-header">
				<td width="15"></td>
				<td class="form-title"><cf_get_lang dictionary_id="57657.Ürün"></td>
				<td class="form-title"><cf_get_lang dictionary_id="58847.Marka"></td>
				<td class="form-title"><cf_get_lang dictionary_id="57518.Stok Kod"></td>
				<td class="form-title"><cf_get_lang dictionary_id="45127.Üye Stok Kodu"></td>
				<td class="form-title"><cf_get_lang dictionary_id="57789.Özel Kod"></td>
				<td class="form-title"><cf_get_lang dictionary_id="57633.Barkod"></td>
				<td class="form-title"><cf_get_lang dictionary_id="33936.Stok Miktarı"></td>
				<td class="form-title"><cf_get_lang dictionary_id="33086.Özel Fiyat"> </td>
				<td class="form-title"><cf_get_lang dictionary_id="33087.Liste Fiyatı"></td>
				<td class="form-title"><cf_get_lang dictionary_id="58778.Ürün Fiyatı"></td>
				<td class="form-title"><cf_get_lang dictionary_id="42994.Satış KDV"></td>
				<td class="form-title"><cf_get_lang dictionary_id="42993.Alış KDV"></td>
				<td class="form-title"><cf_get_lang dictionary_id="57645.Teslim Tarihi"></td>
				<td class="form-title"><cf_get_lang dictionary_id="48313.Desi"></td>
				<td class="form-title"><cf_get_lang dictionary_id="57717.Garanti"></td>
				<td class="form-title"><cf_get_lang dictionary_id="57717.Garanti"> <cf_get_lang dictionary_id="57629.Açıklama"></td>
 			</tr>
	<cfif get_xml_stocks_row.recordcount>
		<cfoutput query="get_xml_stocks_row">
			<tr class="color-row">
				<td>#currentrow#</td>
				<td>#xml_product_name#</td>
				<td>#XML_BRAND_NAME#</td>
				<td>#XML_STOCK_CODE#</td>
				<td>#XML_MEMBER_STOCK_CODE#</td>
				<td>#XML_SPECIAL_CODE#</td>
				<td>#XML_BARCODE#</td>
				<td>#XML_STOCK_AMOUNT#</td>
				<td>#TLFormat(XML_SPECIAL_PRICES)# #xml_money_type#</td>
				<td>#TLFormat(XML_LIST_PRICES)# #xml_money_type#</td>
				<td>#TLFormat(XML_PRODUCT_PRICES)# #xml_money_type#</td>
				<td>#XML_SALES_TAX#</td>
				<td>#XML_PURCHASE_TAX#</td>
				<td>#dateformat(XML_DELIVER_DATE,dateformat_style)#</td>
				<td>#XML_DESI#</td>
				<td>#XML_GUARANTY#</td>
				<td>#XML_GUARANTY_DETAIL#</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row">
			<td colspan="17"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
		</tr>
	</cfif>
	</table>
	</td>
  </tr>
</table>
