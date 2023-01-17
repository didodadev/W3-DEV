<cfquery name="VOCATION_TYPES" datasource="#dsn#">
	SELECT
       *
	FROM
		SETUP_VOCATION_TYPE
	ORDER BY
		VOCATION_TYPE
</cfquery>
<table width="200" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='1199.Meslek Tipleri'></td>
  </tr>
<cfif VOCATION_TYPES.recordcount>
	<cfoutput query="VOCATION_TYPES">
	  <tr>
		  <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
		  <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_vocation_type&ID=#VOCATION_TYPES.VOCATION_TYPE_ID#" class="tableyazi">#VOCATION_TYPE#</a></td>
	  </tr>
  </cfoutput>
<cfelse>
	<tr>
		<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
		<td width="180" valign="baseline"><font class="tableyazi"><cf_get_lang_main no='1074.Kayıt Bulunamadı'>!</font></td>
	</tr>
 </cfif>
</table>

