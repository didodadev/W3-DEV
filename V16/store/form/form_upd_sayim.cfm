<cfquery name="get_sayim_satirlar" datasource="#dsn2#">
	SELECT 
		SS.*,
		S.STOCK_CODE,
		P.MANUFACT_CODE,
		PU.ADD_UNIT
	FROM 
		SAYIM_SATIRLAR SS,
		#dsn3_alias#.PRODUCT P,
		#dsn3_alias#.STOCKS AS S,
		#dsn3_alias#.PRODUCT_UNIT AS PU
	WHERE 
		SAYIM_ID = #attributes.file_id# AND
		S.STOCK_ID = SS.STOCK_ID AND
		P.PRODUCT_ID = SS.PRODUCT_ID AND
		PU.IS_MAIN = 1 AND
		P.PRODUCT_ID = S.PRODUCT_ID AND
		PU.PRODUCT_ID = P.PRODUCT_ID
	ORDER BY
		S.STOCK_CODE
</cfquery>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr>
		<td width="100%" height="35" class="headbold">PHL Dökümanı İçeriği</td>
		<!-- sil -->
		<td width="100" style="text-align:right;">&nbsp;</td>
		<cf_workcube_file_action pdf='0' mail='0' doc='1' print='1'>
		<!-- sil -->
	</tr>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
<form action="<cfoutput>#request.self#?fuseaction=store.emptypopup_write_document</cfoutput>" method="post" name="add_ship_file">
<input type="hidden" name="file_id" id="file_id" value="<cfoutput>#attributes.file_id#</cfoutput>">
<input type="hidden" name="line_count" id="line_count" value="<cfoutput>#get_sayim_satirlar.recordcount#</cfoutput>">
  <tr class="color-border">
	<td>
	  <table width="100%" cellpadding="2" cellspacing="1">
		<tr class="color-header" height="22">
			<td class="form-title" width="20">Satır</td>
			<td class="form-title" width="70"><cf_get_lang_main no='221.Barkod'></td>
			<td class="form-title"><cf_get_lang_main no='106.Stok Kodu'></td>
			<td class="form-title"><cf_get_lang_main no='245.Ürün'></td>
			<td class="form-title"><cf_get_lang_main no='222.Üretici Kodu'></td>			
			<td class="form-title">Birim</td>
			<td class="form-title"><cf_get_lang_main no='223.Miktar'></td>
			<td class="form-title" style="text-align:right;">Toplam Maliyet</td>
		</tr>
		<cfset net_total = 0>
		<cfset net_money = "">
			<cfoutput query="get_sayim_satirlar">
				<cfset satir_toplam = MIKTAR * STANDART_ALIS>
				<input type="hidden" name="barcode_#currentrow#" id="barcode_#currentrow#" value="#BARCODE#">
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				  <td align="center">#currentrow#</td>
				  <td>#BARCODE#</td>
				  <td>#STOCK_CODE#</td>
				  <td>#PRODUCT_NAME# #STOCK_PROPERTY#</td>
				  <td>#MANUFACT_CODE#</td>
				  <td>#ADD_UNIT#</td>
				  <td>
				  	<cfif ADD_UNIT is 'Kg'>
						<input type="text" name="miktar_#currentrow#" id="miktar_#currentrow#" maxlength="10" style="width:50;" value="#MIKTAR*1000#">
					<cfelse>
						<input type="text" name="miktar_#currentrow#" id="miktar_#currentrow#" maxlength="10" style="width:50;" value="#MIKTAR#">
					</cfif>
				  </td>
				  <td style="text-align:right;">#TLFormat(satir_toplam)# #other_money#</td>
				</tr>
				<cfif len(money_rate)><cfset satir_toplam=satir_toplam*money_rate></cfif>
				<cfset net_total = net_total + satir_toplam>
			</cfoutput>
			<cfoutput>
			<tr class="color-list" height="22">
			  <td colspan="7" class="formbold" style="text-align:right;">Toplam Maliyet</td>
			  <td class="txtbold" style="text-align:right;">#TLFormat(net_total)# #session.ep.money#</td>
			</tr>
			</cfoutput>
	  </table>
	</td>
  </tr>
  <tr>
   <td height="50" valign="middle" style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
  </tr>
</form>
</table>

