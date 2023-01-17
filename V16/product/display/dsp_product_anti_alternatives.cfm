<!---ürün detay alternatif ürün ilişkisi--->
<cfinclude template="../query/get_anti_alternate_product.cfm">
<table cellspacing="0" cellpadding="0" width="98%"  border="0">
  <tr class="color-border">
	<td>
	  <table cellspacing="1" cellpadding="2" width="100%" border="0">
		<tr class="color-header" height="22">
		  <td colspan="2">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
			  <tr class="color-header" >
				<td class="form-title"><cf_get_lang dictionary_id='37507.Uyumsuz Ürünler'></td>
				<td align="right" style="text-align:right;">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=product.popup_add_anative_product_except&pid=#attributes.pid#</cfoutput>','small');"><img src="/images/plus_square.gif" border="0" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a>
				</td>
			  </tr>
			</table>
		  </td>
		</tr>
		<cfoutput query="GET_ALTERNATE_PRODUCT_EXCEPT">
		  <tr class="color-row" height="22">
			<td width="1082"> 
				<a href="javascript://"  class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#','list');">#product_name#</a></td>
			<cfsavecontent variable="delete_pro"><cf_get_lang dictionary_id='37383.Alternatif Ürün Siliyorsunuz! Emin misiniz?'></cfsavecontent>
			<td width="15" align="right" style="text-align:right;"><a href="javascript://" onClick="javascript:if(confirm('#delete_pro#')) windowopen('#request.self#?fuseaction=product.emptypopup_del_anative_product_except&anative_id=#GET_ALTERNATE_PRODUCT_EXCEPT.alternative_id#','small'); else return false;"><img src="/images/delete_list.gif" border="0"></a></td>
		  </tr>
		</cfoutput>
	  </table>
	</td>
  </tr>
</table>
<!---ürün detay alternatif ürün ilişkisi Bitti--->
