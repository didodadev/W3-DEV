<cfquery name="get_lang" datasource="#dsn#">
	SELECT
       *
	FROM
		SETUP_LANGUAGES
	ORDER BY
		LANGUAGE_SET
</cfquery>
<table width="200" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='963.Diller'></td>
  </tr>
<cfif get_lang.recordcount>
	<cfoutput query="get_lang">
  <tr>
  <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
  <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_languages&ID=#language_id#" class="tableyazi">#language_set#</a></td>
  </tr>
  </cfoutput>
<cfelse>
 <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    <td width="180" valign="baseline"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
 </tr>
 </cfif>
</table>

