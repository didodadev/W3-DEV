<cfsetting showdebugoutput="no">
<script type="text/javascript">
	function mail_control(){
		 var email = document.getElementById('email').value;	
		 var host = "";
		 var username = "";
		 if(email.indexOf("@") != -1)
		 	host = email.substring(email.indexOf("@") + 1,email.length);
		 if(email.indexOf("@") != -1)
		 	username = email.substring(0,email.indexOf("@"));			
		 if ((email == "") || (email.length < 6) || (email.indexOf("@") == -1) || (email.indexOf(".") == -1) || (host.length < 4) || (username.length < 1)){
			 alert("<cf_get_lang no='104.Yazdığınız mail,mail standartlarına uymuyor!'>");
			 return false;
			 }	
			var get_mail_account = wrk_safe_query('corr_get_mail_account','dsn',0,email);
			if(get_mail_account.recordcount>0)
				{
				alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no='16.E-mail'> <cf_get_lang_main no='781.tekrarı'>.<cf_get_lang no ='195.Aynı mail adresi ile başka bir kullanıcı ekleyemezsiniz'>!");
				return false;
				}
			  
			if(document.getElementById('account').value == "")
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='81.Hesap Adı'>");
					return false;
				}
			if(document.getElementById('password').value == "")
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='83.Parola'>");
					return false;
				}
			if(document.getElementById('pop').value == "")
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='107.Gelen Posta Sunucu Adı'>");
					return false;
				}

			if(document.getElementById('smtp').value == "")
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='108.Giden Posta Sunucu Adı'>");
					return false;
				}
		return true;
	}
</script>
<cfsavecontent variable="Addaccount"><cf_get_lang no ='80.Add Account'></cfsavecontent>
<cf_box title="#Addaccount#" collapsable="0" style="position:absolute; width:400px;">
    <cfform action="#request.self#?fuseaction=correspondence.emptypopup_add_new_mail_setting" method="post" name="employee_mail">
<table>
    <cfinput type="Hidden" name="employee_id" value="#attributes.employee_id#">
    <tr>
        <td></td>
		<td colspan="2">
		<table>
        <td align="left"><input type="checkbox" name="isactive" id="isactive"><cf_get_lang_main no='81.Active'></td>
		<td align="left"><input type="checkbox" name="present_isactive" id="present_isactive"><cf_get_lang no='239.Sunucuda Birak'></td>
 	</table>  
	 </td> 
   </tr>
    <tr>
        <td ><cf_get_lang_main no='16.E-mail Adres'></td>
        <td colspan="2"><cfinput type="text" name="email" style="width:200px;"></td>
    </tr>
    <tr>
        <td><cf_get_lang no='81.Account Name'></td>
        <td colspan="2"><cfinput type="text" name="account" style="width:200px;"></td>
    </tr>
    <tr>
        <td><cf_get_lang no='83.Password'></td>
        <td colspan="2"><cfinput type="password" name="password" style="width:200px;"></td>
    </tr>
    <tr>
        <td><cf_get_lang no='100.POP3 Server'></td>
        <td><cfinput type="text" name="pop" style="width:160px;"></td>
		<td><cfinput type="text" name="pop_port" style="width:36px"  onkeyup="isNumber(this)" maxlength="3"></td>
    </tr>
    <tr>
        <td><cf_get_lang no='84.SMTP Server'></td>
        <td><cfinput type="text" name="smtp" style="width:160px;"></td>
		<td><cfinput type="text" name="smtp_port" style="width:36px" onkeyup="isNumber(this)" maxlength="3"></td>
    </tr>
	<tr>
		<td><cf_get_lang_main no="73.Öncelik"></td>
		<td colspan="2">
			<select name="priority" id="priority">
                <option value="0"><cf_get_lang_main no="322.Seçiniz"></option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
                <option value="6">6</option>
                <option value="7">7</option>
                <option value="8">8</option>
                <option value="9">9</option>
                <option value="10">10</option>
			</select>
		</td>
	</tr>
    <tr height="35">
        <td></td>
        <td colspan="2"  style="text-align:right;">
	<!---<input type="submit" name="gonder" value="Kaydet">--->
<cf_workcube_buttons is_upd='0'  is_cancel="0" add_function="mail_control()">
</td>
    </tr>
</table>
</cfform>
</cf_box>		

