<table width="200" cellpadding="0" cellspacing="0" border="0">
  <tr> 
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='141.Şirket Çalışan Sayısı'></td>
  </tr>
<cfif get_company_size_cats.recordcount>
	<cfoutput query="get_company_size_cats">
  <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
      <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_company_size_cat&company_size_cat_id=#company_size_cat_id#" class="tableyazi">#company_size_cat#</a></td>
  </tr>
  </cfoutput>
<cfelse>
 <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    <td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
  </tr>
 </cfif>
</table>


