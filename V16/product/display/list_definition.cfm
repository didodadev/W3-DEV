
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">
    <tr>
<cfinclude template="../../objects/display/tree_back.cfm">
<td <cfoutput>#td_back#</cfoutput>>
      <table cellpadding="0" cellspacing="0" border="0" width="135">
        <tr> 
      <td class="txtbold" colspan="2" height="20">&nbsp;&nbsp;<cf_get_lang dictionary_id='57529.Tanımlar'></td>
     </tr>
	   <tr>
          <td width="20" align="right" style="text-align:right;"><img src="/images/tree_1.gif" width="13" height="17" align="absmiddle"></td>
  		 <td><a href="<cfoutput>#request.self#?fuseaction=product.list_price_cat</cfoutput>" class="tableyazi"><cf_get_lang dictionary_id='37028.Fiyat Listeleri'></a></td>
       </tr>
	   <tr>
	      <td align="right" style="text-align:right;"><img src="/images/tree_1.gif" width="13" height="17" align="absmiddle"></td>
		 <td><a href="<cfoutput>#request.self#?fuseaction=product.form_add_pricecat</cfoutput>" class="tableyazi"><cf_get_lang dictionary_id='37029.Fiyat Listesi Ekle'></a></td>
		 <!---<br/>
 		  &nbsp;<img src="/images/tree_2.gif" width="13" height="17" align="absmiddle"><a href="<cfoutput>#request.self#?fuseaction=product.list_product_cat</cfoutput>" class="tableyazi">Ürün Kategorileri</a><br/>
		  &nbsp;<img src="/images/tree_2.gif" width="13" height="17" align="absmiddle"><a href="<cfoutput>#request.self#?fuseaction=product.form_add_product_cat</cfoutput>" class="tableyazi">Ürün Kategorisi Ekle</a> --->
        </tr>
		<tr>
		  <td align="right" style="text-align:right;"><img src="/images/tree_1.gif" width="13" height="17" align="absmiddle"></td>
		 <td><a href="<cfoutput>#request.self#?fuseaction=product.list_unit</cfoutput>" class="tableyazi"><cf_get_lang dictionary_id='37031.Birimler'></a></td>
		</tr>
		<tr>
		  <td align="right" style="text-align:right;"><img src="/images/tree_1.gif" width="13" height="17" align="absmiddle"></td>
		 <td><a href="<cfoutput>#request.self#?fuseaction=product.form_add_unit</cfoutput>" class="tableyazi"><cf_get_lang dictionary_id='37032.Birim Ekle'></a></td>
		</tr>
		<tr> 
		  <td align="right" style="text-align:right;"><img src="/images/tree_1.gif" width="13" height="17" align="absmiddle"></td>
		 <td><a href="<cfoutput>#request.self#?fuseaction=product.list_product_cat</cfoutput>" class="tableyazi"><cf_get_lang dictionary_id='57567.Ürün Kategorileri'></a></td>
	     </tr>
		 	<tr> 
		  <td align="right" style="text-align:right;"><img src="/images/tree_1.gif" width="13" height="17" align="absmiddle"></td>
		 <td><a href="<cfoutput>#request.self#?fuseaction=product.form_add_product_cat</cfoutput>" class="tableyazi"><cf_get_lang dictionary_id='37157.Ürün Kategorisi Ekle'></a></td>
	     </tr>
		

  </table>
	</td>
    <td valign="top">&nbsp; </td>
  </tr>
</table>

