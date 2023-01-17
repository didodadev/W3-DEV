<cf_popup_box title="#getLang('main',63)#">
<cfform name="form_add_result_send" action="#request.self#?fuseaction=assetcare.emptypopup_add_assetp_result_send&request_id=#request_id#" method="post">
<input type="hidden" name="request_id" id="request_id" value="<cfoutput>#attributes.request_id#</cfoutput>">
	<table>
		<tr>
			<td ><cf_get_lang no='205.Gönderilen'></td>
			<td>
				<cfsavecontent variable="message"><cf_get_lang no='206.Gönderilen Girmelisiniz'>!</cfsavecontent>
				<input type="hidden" name="emp_id" id="emp_id">
				<cfinput type="text" name="mail_to" style="width:270px;" required="Yes" message="#message#" readonly>
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_mail&mail_id=form_add_result_send.emp_id&names=form_add_result_send.mail_to','list')"><img src="/images/plus_thin.gif" alt="Kişi Ekle" title="Kişi Ekle" border="0" align="absmiddle"></a>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='68.Konu'></td>
			<td><cfsavecontent variable="message1"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='68.Konu'> !</cfsavecontent>
				<input type="hidden" name="emp_id_cc" id="emp_id_cc">
				<cfinput type="text" name="subject" value="Fiziki Varlık Talep Sonucu"  style="width:270px;" required="yes" message="#message1#">
			</td>
		</tr>
		<tr>
			<td colspan="2" class="txtbold">
		</tr>
	</table>
	<cf_popup_box_footer>
		<cfsavecontent variable="button_name"><cf_get_lang_main no ='63.Mail Gönder'></cfsavecontent>
		<cf_workcube_buttons type_format="1" is_upd='0' is_delete='0' insert_info='#button_name#' insert_alert='Göndermek İstediğinizden Emin Misiniz ?' >
	</cf_popup_box_footer>
</cfform>
</cf_popup_box>
