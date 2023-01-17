<cfinclude template="../query/get_shelf.cfm">
<table width="200" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td class="txtbold" colspan="2" height="20">&nbsp;&nbsp;<cf_get_lang no='174.Raf Kategorileri'></td>	
	</tr>
	<cfif get_shelf.recordcount>
	<cfoutput query="get_shelf">
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" border="0" align="absmiddle"></td>
			<td width="180"><a href="#request.self#?fuseaction=settings.form_upd_shelf&s_id=#SHELF_MAIN_ID#" class="tableyazi">#SHELF_NAME#</a></td>
		</tr>
	</cfoutput>
	<cfelse>
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" border="0" align="absmiddle"></td>
			<td width="180"><cf_get_lang_main no='72.kayıt yok'></td>
		</tr>
	</cfif> 
</table>
