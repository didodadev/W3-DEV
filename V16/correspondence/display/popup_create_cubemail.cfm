<cfsetting showdebugoutput="no">
<cf_box title='Posta Olustur' style="position:absolute;width:100%;height:60;">
<cfform name="mail_main_form" method="post" action="#request.self#?fuseaction=correspondence.emptypopup_cubemail_add" enctype="multipart/form-data">
<table cellspacing="1" cellpadding="2" border="1" width="100%" height="100%">
	<tr>
		<td valign="top" class="color-row" style="width:98%">
		<table border="0" style="width:98%">
			<tr>
				<td width="5%" valign="top"><cf_get_lang dictionary_id="57924.Kime"></td>
				<td width="90%" height="20" id="names"><input type="text" name="to_mail" id="to_mail" style="width:100%;height:40;"></td>
			</tr>
			<tr id="cc_input_id" style="display:none;">
				<td width="5%" id="cc_id_1"></td>
				<td width="5%" style="display:none" id="cc_id_2">Cc</td>
				<td width="90%"><input type="text" name="cc_adress" id="cc_adress" value="" style="width:100%;height:40;"></td>
			</tr>
			<tr id="bcc_input_id" style="display:none;">
				<td width="5%" id="bcc_id_1"></td>
				<td width="5%" style="display:none" id="bcc_id_2">Bcc</td>
				<td width="90%"><input type="text" name="bcc_adress" id="bcc_adress" value="" style="width:100%;height:40;"></td>
			</tr>
			<tr>
				<td></td>
				<td>
					<div id="cc_id"><a href="javascript://" onclick="gizle(cc_id);gizle(cc_id_1);goster(cc_id_2);goster(cc_input_id);"><font color="0099FF">To  |</font></a></div>
					<div id="bcc_id"><a href="javascript://" onclick="gizle(bcc_id);gizle(bcc_id_1);goster(bcc_input_id);goster(bcc_id_2);"><font color="0099FF">BCC </font></a></div>
				</td>
			</tr>
			<tr>
				<td width="5%">Konu</td>
				<td width="90%" class="txtbold"><input  style="width:100%" type="text" name="subject" id="subject" value=""></td>
			</tr>
 			  <tr>
			<td></td>
			<td><!--- Dosya Ekle --->
				<a href="javascript://" onclick="add_folder_box();"><img src="/images/attach_img.jpg" alt="" border="0"> <font color="0099FF"><cf_get_lang dictionary_id="57515.Dosya Ekle"></font></a>
				<div id="add_folder_div" style="position:absolute;width:20%;height:20%"></div>				
			</td>
			</tr>
			<tr>
				<td></td>
				<td class="txtbold">
			 <cfmodule
				template="/fckeditor/fckeditor.cfm"
				toolbarSet="WRKContent"
				basePath="/fckeditor/"
				instanceName="mail_body"
				valign="top"
				width="960"
				height="275">
				</td>
			</tr>
			<tr>
				<td></td>
				<td style="text-align:right;" class="txtbold" style="text-align:right;">
					 <input type="button" name="Gönder" value="Gönder" onclick="valid_control();">
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</cfform>
</cf_box>
<script type="text/javascript">
function valid_control()
{
	var mail_address_ = document.mail_main_form.to_mail.value;//mail formatı doğrulama
	if ((mail_address_.indexOf('@') < 1) || (mail_address_.indexOf('.') < 3) || (mail_address_.length < 6) || mail_address_.length < 1)
	{
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_errors_cubemail','message_div','1');
	}
	goster(message_div);
	var MyObject= new MyupdateClass(); // fck editör için
	MyObject.updateEditorFormValue(); // fck editör için
	AjaxFormSubmit("mail_main_form","message_div",0,"<cf_get_lang dictionary_id='54837.Gönderiliyor'> <cf_get_lang dictionary_id='54839.Mailiniz Gönderildi'>","<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_create_cubemail","action_div");	
	setTimeout("gizle(message_div);",2500);
} 
function add_folder_box()
{
	AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_add_folder_box','add_folder_div','1',"<cf_get_lang dictionary_id='58892.Lütfen Bekleyin.'>");
}
</script>
