<cfsavecontent variable="message"><cf_get_lang dictionary_id ='37765.Katalog Sayfa Tipi'> <cf_get_lang dictionary_id='57582.Ekle'>!</cfsavecontent>
<cf_popup_box title="#message#">
	<cfform name="add_page_type" method="post" action="#request.self#?fuseaction=product.emptypopup_add_catalog_page_type">
		<table>
			<tr>
				<td><cf_get_lang dictionary_id='58069.Sayfa Tipi'>*
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='37766.Sayfa Tipi Eklemelisiniz'>!</cfsavecontent>
					<cfinput type="text" name="page_type" value="" message="#message#" required="yes" maxlength="50" style="width:200px;">
				</td>
			</tr>
			<tr>
				<td>
					<input type="checkbox" value="1" name="is_standart" id="is_standart">
				<cf_get_lang dictionary_id ='43115.Standart Seçenek Olarak Gelsin'>
				</td>
			</tr>
		</table>
		<cf_popup_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0'>
		</cf_popup_box_footer>
	</cfform>
</cf_popup_box>

