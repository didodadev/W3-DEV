<cfquery name="get_pcs" datasource="#dsn#">
	SELECT UNIT_ID, UNIT_NAME FROM SETUP_PC_NUMBER ORDER BY UNIT_ID
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
  <tr> 
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='915.Bilgisayar Sayısı'></td>
  </tr>
<cfif get_pcs.recordcount>
	<cfoutput query="get_pcs">
  <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
      <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_pc_number&u_id=#unit_id#" class="tableyazi">#unit_name#</a></td>
  </tr>
  </cfoutput>
<cfelse>
 <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
  </tr>
 </cfif>
</table>

