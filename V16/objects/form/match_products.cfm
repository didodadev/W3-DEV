<!--- Buraya iki yerden kayıt gelir.
	1-Stock code ifadesi bizim product db de yoktur.
	2-Stock code belgede boş gelmiştir.
 --->
<cfquery name="GET_NOT_IMPORTED" datasource="#DSN2#">
	SELECT
		IRPP.STOCK_CODE,
		IRPP.BARCODE,
		IRPP.PRICE,
		IRPP.INVOICE_ROW_ID
	FROM
		FILE_IMPORTS FI,
		INVOICE_ROW_POS_PROBLEM IRPP
	WHERE
		FI.I_ID = #attributes.i_id# AND
		FI.INVOICE_ID = IRPP.INVOICE_ID
</cfquery>
<cfform name="match_products" method="post" action="#request.self#?fuseaction=objects.emptypopup_import_match_products">
<input type="hidden" name="i_id" id="i_id" value="<cfoutput>#attributes.i_id#</cfoutput>">
<input type="hidden" name="line_count" id="line_count" value="<cfoutput>#get_not_imported.recordcount#</cfoutput>">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr>
	<td valign="top">
    <table width="98%" align="center" cellpadding="0" cellspacing="0">
	  <tr>
		<td class="headbold" height="35">Alınamayan Satış İmportları Tekrar İmport</td>
	  </tr>
	</table>
	<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
	  <tr class="color-border">
		<td>
		<table cellpadding="2" cellspacing="1" border="0" width="100%">
		  <tr class="color-header" height="22">
			<td class="form-title"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
			<td class="form-title"><cf_get_lang dictionary_id='57633.Barkod'></td>
			<td class="form-title"><cf_get_lang dictionary_id='57673.Tutar'></td>
			<td class="form-title"><cf_get_lang dictionary_id='33075.Olması Gereken Ürün'></td>
		  </tr> 
		  <cfoutput query="get_not_imported">
		  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
			<td><cfif stock_code eq 'NULL'><cf_get_lang dictionary_id='46489.Dosya Bulunmadı'><cfelse>#stock_code#</cfif></td>
			<td>#barcode#</td>
			<td  style="text-align:right;">#TLFormat(price)#</td>
			<td width="220">
			  <input type="hidden" name="invoice_row_id_#currentrow#" id="invoice_row_id_#currentrow#" value="#invoice_row_id#">
			  <input type="hidden" name="stock_id_#currentrow#" id="stock_id_#currentrow#" value="">
			  <input type="hidden" name="product_id_#currentrow#" id="product_id_#currentrow#" value="">			  
			  <input type="text" name="product_name_#currentrow#" id="product_name_#currentrow#" value="" readonly style="width:200px;">
			  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_product_names&field_id=match_products.stock_id_#currentrow#&field_name=match_products.product_name_#currentrow#&product_id=match_products.product_id_#currentrow#','list');"><img src="/images/plus_list.gif" border="0"></a>
			</td>
		  </tr>
		  </cfoutput>
		</table>
        </td>
	  </tr>
      <tr>
		<td style="text-align:right;"><br/><cf_workcube_buttons is_upd='0'></td>
	  </tr>
	</table>
	<br/>    
    </td>
  </tr>
</table>
</cfform>
