<cfinclude template="../query/get_file_format.cfm">
<table>
<cfif format.recordcount>
  <cfoutput query="FORMAT">
	<tr>
		<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
		<td width="380"><a href="#request.self#?fuseaction=settings.form_upd_del_file_format&file_format_id=#format_id#" class="tableyazi">#format_symbol#</a><a href="#request.self#?fuseaction=settings.form_upd_del_file_format&file_format_id=#format_id#" class="tableyazi"> - #format_description#</a></td>
	</tr>
  </cfoutput>
<cfelse>
	<tr>
    	<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
    </tr>
</cfif>
</table>
