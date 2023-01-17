<cfquery name="GET_QUALITY_CONTROL" datasource="#dsn3#">
	SELECT
		*
	FROM
		QUALITY_CONTROL_TYPE
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
  <tr> 
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang dictionary_id='60263.Kalite Kontrol Kataloğu'></td>
  </tr>
<cfif GET_QUALITY_CONTROL.recordcount>
	<cfoutput query="GET_QUALITY_CONTROL">
  <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
      <td width="115"><a href="#request.self#?fuseaction=settings.upd_quality_control_type&id=#type_id#" class="tableyazi">#QUALITY_CONTROL_TYPE#</a></td>
  </tr>
  </cfoutput>
<cfelse>
 <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    <td><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</font></td>
  </tr>
 </cfif>
</table>
