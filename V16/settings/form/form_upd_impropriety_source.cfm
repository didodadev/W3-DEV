<cfset get_impropriety_source = createObject("component","V16.settings.cfc.setupImproprietySource").getImproprietySource(dsn3:dsn3,imp_source_id:attributes.imp_source_id)>
<cfsavecontent variable="image"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_add_impropriety_source"><img src="/images/plus1.gif" title="<cf_get_lang_main no='170.Ekle'>"></a></cfsavecontent>
<cf_popup_box title="#getLang('settings',337)# #getLang('main',52)#" right_images="#image#">
	<cfform name="add_impropriety_source" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_impropriety_source">
	<input type="hidden" name="imp_source_id" id="imp_source_id" value="<cfoutput>#attributes.imp_source_id#</cfoutput>">
	<table>
		<tr>
			<td style="width:75px;"><cf_get_lang_main no='81.Aktif'></td>
			<td><input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_impropriety_source.is_active eq 1>checked</cfif>></td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='219.Ad'></td>
			<td><cfinput type="text" name="imp_source_name" id="imp_source_name" value="#get_impropriety_source.imp_source_name#" maxlength="100" style="width:250px;"></td>
		</tr>
		<tr valign="top">
			<td><cf_get_lang_main no='217.Açıklama'></td>
			<td><textarea name="imp_source_detail" id="imp_source_detail" maxlength="250" onkeyup="return ismaxlength(this);" style="width:250px;height:75px;"><cfoutput>#get_impropriety_source.imp_source_detail#</cfoutput></textarea></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="checkbox" name="is_default" id="is_default" value="1" <cfif get_impropriety_source.is_default eq 1>checked</cfif>><cf_get_lang no='1132.Standart Seçenek Olarak Gelsin'></td>
		</tr>
	</table>
	<cf_popup_box_footer>
		<cf_record_info query_name="get_impropriety_source">
		<cf_workcube_buttons is_upd='1' is_delete="0" type_format="1">
	</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
