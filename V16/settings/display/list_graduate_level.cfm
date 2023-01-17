<cfquery name="GET_GRADUATE_LEVEL" datasource="#DSN#">
	SELECT GRADUATE_ID,GRADUATE_NAME FROM SETUP_GRADUATE_LEVEL ORDER BY GRADUATE_ID
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
  <tr> 
	<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no ='199.Egitim Durumları'></td>
  </tr>
<cfif get_graduate_level.recordcount>
<cfoutput query="get_graduate_level">
  <tr>
 	<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
	<td width="115"><a href="#request.self#?fuseaction=settings.form_upd_graduate_level&id=#graduate_id#" class="tableyazi">#graduate_name#</a></td>
  </tr>
</cfoutput>
<cfelse>
 <tr>
	<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</font></td>
  </tr>
</cfif>
</table>
