<cfquery name="UNITCATEGORIES" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_UNIT
</cfquery>	
<table width="135" cellpadding="0" cellspacing="0" border="0">
  <tr> 
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='162.Birim Kategorileri'></td>
  </tr>
<cfif unitCategories.recordcount>
	<cfoutput query="UNITCATEGORIES">
  <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
      <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_unit&ID=#unit_ID#" class="tableyazi">#unit#</a></td>
  </tr>
  </cfoutput>
<cfelse>
 <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    <td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
  </tr>
 </cfif>
</table>
