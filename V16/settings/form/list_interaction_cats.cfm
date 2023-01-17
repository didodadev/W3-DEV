<cfquery name="get_interaction_cat_all" datasource="#dsn#">
	SELECT INTERACTIONCAT_ID, INTERACTIONCAT FROM SETUP_INTERACTION_CAT
</cfquery>		
<table width="250" cellpadding="0" cellspacing="0" border="0">
	<tr> 
		<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='515.Etkileşim Kategorileri'></td>
	</tr>
	<cfif get_interaction_cat_all.recordcount>
		<cfoutput query="get_interaction_cat_all">
			<tr>
				<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
				<td width="180"><a href="#request.self#?fuseaction=settings.form_upd_g_service_app_cat&servicecat_id=#servicecat_id#" class="tableyazi">#servicecat#</a></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
			<td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
		</tr>
	</cfif>
</table>


