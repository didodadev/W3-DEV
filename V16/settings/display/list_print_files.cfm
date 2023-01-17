<cfset cfc= createObject("component","workdata.get_print_files_cats")>
<cfset get_files=cfc.GetListPrintFiles(use_period : fusebox.use_period)> 
<table width="400" cellpadding="0" cellspacing="0" border="0">
	<tr> 
		<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='956.Sistem İçin Print Dosyaları'></td>
	</tr>
<cfif get_files.recordcount>
<cfoutput query="get_files">
	<tr>	
		<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
		<td width="380"><a href="#request.self#?fuseaction=settings.form_upd_print_files&form_id=#form_id#" class="tableyazi">#print_namenew# - #name#</a></td>
	</tr>
</cfoutput>
<cfelse>
	<tr>
		<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
		<td width="380"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
	</tr>
</cfif>
</table>
