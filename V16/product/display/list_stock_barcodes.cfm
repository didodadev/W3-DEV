<cfquery name="STOCKS_BARCODE" datasource="#dsn1#">
	SELECT BARCOD FROM STOCKS WHERE STOCK_ID=#attributes.STOCK_ID#
</cfquery>
<cfquery name="STOCKS_BARCODES" datasource="#dsn1#">
	SELECT BARCODE FROM STOCKS_BARCODES WHERE STOCK_ID=#attributes.STOCK_ID# AND BARCODE<>'#STOCKS_BARCODE.BARCOD#'
</cfquery>
<table width="130" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="txtbold" height="20" colspan="2">&nbsp;<cf_get_lang dictionary_id='37435.Stok Barkodları'></td>
  </tr>
  <cfif (STOCKS_BARCODES.recordcount) or (STOCKS_BARCODE.recordcount)>
    <cfoutput query="STOCKS_BARCODE">
      <tr>
        <td width="20" valign="baseline"><a href="#request.self#?fuseaction=objects.popup_barcode&barcod=#BARCOD#&is_terazi=#attributes.is_terazi#"><img src="/images/barcode.gif" border="0"></a></td>
        <td>#BARCOD#</td>
      </tr>
    </cfoutput>
	<cfoutput query="STOCKS_BARCODES">
		<tr>
			<td width="20" valign="baseline"><a href="#request.self#?fuseaction=objects.popup_barcode&barcod=#BARCODE#&is_terazi=#attributes.is_terazi#"><img src="/images/barcode.gif" border="0"></a></td>
			<td><a href="#request.self#?fuseaction=objects.popup_form_upd_stock_barcode&barcode=#BARCODE#&is_terazi=#attributes.is_terazi#" class="tableyazi">#BARCODE#</a></td>
		</tr>
    </cfoutput>		
   <cfelse>
    <tr>
      <td colspan="2"><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</font></td>
    </tr>
  </cfif>
</table>
