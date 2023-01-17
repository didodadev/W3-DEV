<cfsetting showdebugoutput="no">
<cf_box title="Cubemail Arama" closable="0" collapsable="0">
<table>
	<cfform name="search_form" method="post" action="">
	<tr>
		<td><cf_get_lang dictionary_id="46789.Kimden"></td>
		<td><input type="text" name="mail_from" id="mail_from" value="" style="width:180px;"></td>
		<td width="50"  style="text-align:right;"><cf_get_lang dictionary_id="57924.Kime"></td>
		<td><input type="text" name="mail_to" id="mail_to" value="" style="width:180px;"></td>
		<td><cf_get_lang dictionary_id="30643.Tarihten Sonra"></td>
		<td>
			<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='330.Tarih'>!</cfsavecontent>
			<cfinput type="text" name="startdate" maxlength="10" style="width:65px;" value="" validate="#validate_style#" message="#message#">
			<cf_wrk_date_image date_field="startdate">
		</td>
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id="57480.Konu"></td>
		<td colspan="3"><input type="text" name="mail_subject" id="mail_subject" value="" style="width:440px;"></td>
		<td><cf_get_lang dictionary_id="30640.Tarihten Önce"></td>
		<td>
			<cfinput type="text" name="finishdate" maxlength="10" style="width:65px;" value="" validate="#validate_style#" message="#message#">
			<cf_wrk_date_image date_field="finishdate">
		</td>
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id="57771.Detay"></td>
		<td colspan="3"><input type="text" name="mail_body" id="mail_body" value="" style="width:440px;"></td>
		<td colspan="2"><input type="checkbox" name="mail_file" id="mail_file" value="1"> Dosya Eki Var</td>
	</tr>
	<tr>
		<td colspan="6"  style="text-align:right;"><input type="button" onClick="search_mails();" value=" Ara "></td>
	</tr>
	</cfform>
</table>
</cf_box>
<script type="text/javascript">
function search_mails()
{
	s_mail_from = document.search_form.mail_from.value;
	s_mail_to = document.search_form.mail_to.value;
	s_startdate = document.search_form.startdate.value;
	s_finishdate = document.search_form.finishdate.value;
	s_mail_subject = document.search_form.mail_subject.value;
	s_mail_body = document.search_form.mail_body.value;
	if(document.search_form.mail_file.checked==true)
		s_mail_file = 1;
	else
		s_mail_file = 0;
	list_mail('-10',0,'1',s_mail_from,s_mail_to,s_startdate,s_finishdate,s_mail_subject,s_mail_body,s_mail_file);
}
</script>
