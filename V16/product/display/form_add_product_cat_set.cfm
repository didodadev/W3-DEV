<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr>
<cfinclude template="../../objects/display/tree_back.cfm">
<td valign="top" <cfoutput>#td_back#</cfoutput>>
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
        <td><a href="<cfoutput>#request.self#?fuseaction=product.form_add_product_cat_st</cfoutput>" class="tableyazi"><cf_get_lang dictionary_id='37157.Ürün Kategorisi Ekle'></a></td>
      </tr>
    </table>
    </td>
    <td valign="top">
      <table border="0" cellspacing="0" cellpadding="0" width="97%" align="center">
        <tr>
          <td class="headbold" height="35"><cf_get_lang dictionary_id='37157.Ürün Kategorisi Ekle'></td>
        </tr>
      </table>
      <table border="0" width="97%" align="center" cellpadding="0" cellspacing="0">
        <tr class="color-border">
          <td>
            <table border="0" width="100%" cellpadding="2" cellspacing="1">
              <tr class="color-row">
                <td valign="top" width="150" class="txtbold">
                  <cfinclude template="tree_product_cat.cfm">
                </td>
                <td valign="top">
                  <table border="0">
                    <cfform action="#request.self#?fuseaction=product.#XFA.submit_zone#" method="post" name="product_cat">
                      <input type="Hidden" id="counter">
                      <tr>
                        <td width="100"><cf_get_lang dictionary_id='29736.Üst Kategori'></td>
                        <td>
                          <select name="HIERARCHY" id="hierarchy" onChange="document.product_cat.head_cat_code.value=document.product_cat.hierarchy[document.product_cat.hierarchy.selectedIndex].value;" style="width:150px;">
                            <option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'>
                            <cfoutput query="productCats">
                              <option value="#HIERARCHY#">
                              <cfif ListLen(HIERARCHY,".") neq 1>
                                <cfloop from="1" to="#ListLen(HIERARCHY,".")#" index="i">
&nbsp;
                                </cfloop>
                              </cfif>
                              #product_Cat# 
                            </cfoutput>
                          </select>
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang dictionary_id='37159.Kategori Kodu'><font color=red>*</font> </td>
                        <td>
                          <input type="Text" name="head_cat_code" id="head_cat_code" value="" disabled style="width:50px;">
                          <cfsavecontent variable="message"><cf_get_lang dictionary_id='44853.Kategori Kodu girmelisiniz'></cfsavecontent>
						  <cfinput type="Text" name="product_cat_code"  style="width:95px;" value="" maxlength="50" required="Yes" message="#message#">
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang dictionary_id='37163.Kategori Adı'><font color=red>*</font> </td>
                        <td>
                          <cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.Kategori Adı girmelisiniz'></cfsavecontent>
						  <cfinput type="Text" name="product_Cat" value="" maxlength="50" required="Yes" message="#message#" style="width:150px;">
                        </td>
                      </tr>
                      <tr>
                        <td valign="top"><cf_get_lang dictionary_id='57629.açıklama'></td>
                        <td>
						  <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                          <textarea name="detail" id="detail" maxlength="150" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>" style="width:250px;height:60px;"></textarea>
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang dictionary_id='58497.Pozisyon'></td>
                        <td>
                          <input type="hidden" name="position_id" id="position_id" value="">
                          <input type="hidden" name="position_code" id="position_code" value="">
                          <input type="text"   name="position_name" id="position_name" value="" style="width:230px;" maxlength="50"  >
                          <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_id=product_cat.position_id&field_name=product_cat.position_name&field_code=product_cat.position_code</cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a> </td>
                      </tr>
                      <tr>
                        <td align="right" colspan="2"> <cf_workcube_buttons is_upd='0'> </td>
                      </tr>
                    </cfform>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
function form_kontrol(alan,msg,min_n,max_n)
{
	if(!checkElementLengthRange(alan, '<cf_get_lang dictionary_id="37873.Mesaj bölümü max karakter sayısı">' +max_n+ , 1, max_n)) return false;
}

function checkElementLengthRange(target, msg, min_n, max_n) {	
	if (!(target.value.length>=min_n && target.value.length<=max_n)){
		alert(msg);
		target.focus();
		return false;
	}
	return true;
}
</script>

