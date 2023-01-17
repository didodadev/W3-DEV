<cfquery name="POSITIONCATEGORIES" datasource="#dsn#">
	SELECT * FROM SETUP_POSITION_CAT
	ORDER BY POSITION_CAT
</cfquery>
<table width="200" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang_main no='367.Pozisyon Kategorileri'></td>
  </tr>
<cfif positionCategories.recordcount>
	<cfoutput query="positionCategories">
  <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    <td><a href="#request.self#?fuseaction=settings.form_upd_position&ID=#POSITION_ID#" class="tableyazi">#position_cat#</a></td>
  </tr>
  </cfoutput>
<cfelse>
 <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    <td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
  </tr>
 </cfif>
</table>

