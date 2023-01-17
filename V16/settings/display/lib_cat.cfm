<cfquery name="LIB_CATS" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		LIBRARY_CAT
</cfquery>	

<table width="135" cellpadding="0" cellspacing="0" border="0">
  <tr> 
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang_main no='285.Kütüphane'></td>
  </tr>
<cfif LIB_CATS.recordcount>
	<cfoutput query="LIB_CATS">
  <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
      <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_library_set&ID=#LIBRARY_CAT_ID#" class="tableyazi">#LIBRARY_CAT#</a></td>
  </tr>
  </cfoutput>
<cfelse>
 <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
  </tr>
 </cfif>
</table>

