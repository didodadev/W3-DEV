<cf_popup_box title="#getLang('settings',337)# #getLang('main',170)#">
	<cfform name="add_impropriety_source" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_impropriety_source">
	<table>
		<tr>
			<td style="width:75px;"><cf_get_lang_main no='81.Aktif'></td>
			<td><input type="checkbox" name="is_active" id="is_active" value="1" checked></td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='219.Ad'>*</td>
			<td><cfinput type="text" name="imp_source_name" id="imp_source_name" value="" maxlength="100" style="width:250px;"></td>
		</tr>
		<tr valign="top">
			<td><cf_get_lang_main no='217.Açıklama'></td>
			<td><textarea name="imp_source_detail" id="imp_source_detail" maxlength="250" onkeyup="return ismaxlength(this);" style="width:250px;height:75px;"></textarea></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="checkbox" name="is_default" id="is_default" value="1"><cf_get_lang no='1132.Standart Seçenek Olarak Gelsin'></td>
		</tr>
	</table>
	<cf_popup_box_footer>
		<cf_workcube_buttons is_upd='0' type_format="1">
	</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
