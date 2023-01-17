<table width="135" cellpadding="0" cellspacing="0" border="0">
  <tr> 
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang dictionary_id='38946.Ürün Hesap Kataloğu'></td>
  </tr>
<cfif get_product_cost_types.recordcount>
	<cfoutput query="get_product_cost_types">
  <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
      <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_product_cost_type&product_cost_type_id=#product_cost_type_id#" class="tableyazi">#product_cost_key#</a></td>
  </tr>
  </cfoutput>
<cfelse>
 <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    <td width="115"><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</font></td>
  </tr>
 </cfif>
</table>

