<cfinclude template="../query/get_sticker_temps.cfm">
<table width="135" cellpadding="0" cellspacing="0" border="0">
  <tr> 
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang dictionary_id='42153.Etiket Şablonları'></td>
  </tr>
	<cfif GET_STICKER.recordCount>
		<cfoutput query="GET_STICKER">
		  <tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
			<td width="380"><a href="#request.self#?fuseaction=settings.form_upd_sticker_template&upd_id=#STICKER_ID#" class="tableyazi">#STICKER_NAME#</a></td>
		  </tr>
	  </cfoutput>
	<cfelse>
	 <tr>
		<td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
		<td width="380"><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</font></td>
	  </tr>
	 </cfif>
</table>