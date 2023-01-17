<cfoutput>
<cf_box title="Exchange Server Mail Ayarları" style="position:absolute; left:13px; width:300px;">
	<cfform name="exchange_settings_frm" action="#request.self#?fuseaction=correspondence.add_mail_settings_exchange">
		<table cellspacing="1" cellpadding="2" align="center">
			<tr>
				<td width="132"><cf_get_lang dictionary_id="30639.Server Adresi">*</td>
			  <td width="144"><cfinput type="text" name="SERVER_ADDRESS" maxlength="50"/></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id="31109.Mail Adresi">*</td>
				<td><cfinput type="text" name="USERNAME" maxlength="50"/></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id="57552.Şifre">*</td>
				<td><cfinput type="password" name="PASSWORD" maxlength="50"/></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id="54829.Protokol"></td>
				<td>
					<select name="PROTOCOL" id="PROTOCOL">
						<option value="HTTP">HTTP</option>
						<option value="HTTPS">HTTPS</option>
					</select>
				</td>
			</tr>		
			<tr>
				<td><cf_get_lang dictionary_id="54830.Port"></td>
				<td><cfinput type="text" name="PORT" maxlength="43"/></td>
			</tr>
			<tr>
				<td colspan="2"  style="text-align:right;">							
					<cf_workcube_buttons is_insert='1' add_function='kontrol()'>					
				</td>					
		</table>
	</cfform>
</cf_box>
</cfoutput>

<script type="text/javascript">
function kontrol()
{
	if(document.exchange_settings_frm.USERNAME.value==""){
		alert("<cf_get_lang dictionary_id='30486.Kullanıcı Adınızı Girmediniz'>!");
		return false;
	}
	
	if(document.exchange_settings_frm.USERNAME.value.length < 3){
		alert("<cf_get_lang dictionary_id='30484.Kullanıcı Adınızı Yanlış Girdiniz'>! <cf_get_lang dictionary_id='51678.En Az 3 Karakter Girmelisiniz'>..");
		return false;
	}
	
	if(document.exchange_settings_frm.PASSWORD.value==""){
		alert("<cf_get_lang dictionary_id='30481.Şifrenizi Girmediniz'>!");
		return false;
	}
	
	if(document.exchange_settings_frm.PASSWORD.value.length < 6){
		alert("<cf_get_lang dictionary_id='30475.Şifrenizi Yanlış Girdiniz'> ! <cf_get_lang dictionary_id='30473.En Az 6 Karakter Girmelisiniz'>..");
		return false;
	}	
}
</script>
