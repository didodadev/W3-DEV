<cfsetting showdebugoutput="no">
<script type="text/javascript">
	function mail_control(){
		 var email = employee_mail.email.value;	
		 var host = "";
		 var username = "";
		 var ext = "";
		 if(email.indexOf("@") != -1)
		 	host = email.substring(email.indexOf("@") + 1,email.length);
		 if(email.indexOf("@") != -1)
		 	username = email.substring(0,email.indexOf("@"));
		 if(email.indexOf(".") != -1)
		 	ext = email.substring(email.indexOf(".") + 1,email.length);		 				
		 if ((email == "") || (email.length < 6) || (email.indexOf("@") == -1) || (email.indexOf(".") == -1) || (host.length < 4) || (username.length < 1) || (ext.length < 2)){
			 alert("<cf_get_lang no='104.Yazdığınız mail,mail standartlarına uymuyor!'>");
			 return false;
		 }	 
		if(employee_mail.account.value == "")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='81.Hesap Adı'>'>");
				return false;
			}
		if(employee_mail.pop.value == "")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='107.Gelen Posta Sunucu Adı'>");
				return false;
			}

		if(employee_mail.smtp.value == "")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='108.Giden Posta Sunucu Adı'>");
				return false;
			}
			
			 return true;		 
	}
	function id_control()
	{
		var mailbox_id_control = wrk_safe_query('corr_mailbox_id_control','dsn',0,<cfoutput>#attributes.mailbox_id#</cfoutput>);
		if(mailbox_id_control.recordcount)
			{
				alert("<cf_get_lang no='243.Mail Hesabına Kayıtlı Mailler Var! Mailler Silinemez!'>");
				return false;
			}
		else
			{
				document.employee_mail.operation.value='del';
			}
	
	}
</script>
<cfsavecontent variable="mailaccount"><cf_get_lang no ='102.Mail Account'></cfsavecontent>
<cf_box title="#mailaccount#" style="position:absolute;width:400px;" collapsable="0">
<cfinclude template="../query/get_emp_mails.cfm">
<cfform action="#request.self#?fuseaction=correspondence.emptypopup_upd_mail_settings&mailbox_id=#attributes.mailbox_id#&employee_id=#attributes.employee_id#" method="post" name="employee_mail">
<input type="Hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
<input type="hidden" name="operation" id="operation" value="upd" />
	<cfoutput>
    <table>
        <tr>
            <td></td>
            <td colspan="2">
                <table>
                    <tr>
                        <td><input type="checkbox" name="isactive" id="isactive" <cfif Len(EMP_MAIL_LIST.ISACTIVE) and EMP_MAIL_LIST.ISACTIVE> checked</cfif>> <cf_get_lang_main no='81.Active'></td>
                        <td><input type="checkbox" name="present_isactive" id="present_isactive" <cfif EMP_MAIL_LIST.PRESENT_ISACTIVE eq 1> checked</cfif>><cf_get_lang no='239.Sunucuda Bırak'></td>
                        <td><input type="checkbox" name="temp_present_isactive" id="temp_present_isactive" <cfif EMP_MAIL_LIST.temp_present_isactive eq 1> checked</cfif>><cf_get_lang dictionary_id="30471.7 Gün Bırak"></td>
                    </tr>
                </table>  
            </td> 
        </tr>
        <tr>
            <td><cf_get_lang_main no='16.E-mail Adres'></td>
            <td colspan="2"><cfinput type="text" name="email" style="width:200px;" VALUE="#EMP_MAIL_LIST.EMAIL#"></td>
        </tr>
        <tr>
            <td><cf_get_lang no='81.Account Name'></td>
            <td colspan="2"><cfinput type="text" name="account" style="width:200px;"  VALUE="#EMP_MAIL_LIST.ACCOUNT#"></td>
        </tr>
        <tr>
            <td><cf_get_lang no='83.Password'></td>
            <td colspan="2">
				<cfif (EMP_MAIL_LIST.RecordCount) and Len(EMP_MAIL_LIST.PASSWORD)>
                    <cfinput type="password" name="password" style="width:200px;"  VALUE="">
                <cfelse>
                    <cfinput type="password" name="password" style="width:200px;"  VALUE="#EMP_MAIL_LIST.PASSWORD#">
                </cfif>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang no='100.POP3 Server'></td>
            <td><cfinput type="text" name="pop" style="width:160px;" VALUE="#EMP_MAIL_LIST.POP#"></td>
            <td><cfinput type="text" name="pop_port" style="width:36px" value="#EMP_MAIL_LIST.POP_PORT#" onkeyup="isNumber(this)" maxlength="3"></td>
        </tr>
        <tr>
            <td><cf_get_lang no='84.SMTP Server'></td>
            <td><cfinput type="text" name="smtp" style="width:160px;"  VALUE="#EMP_MAIL_LIST.SMTP#"></td>
            <td><cfinput type="text" name="smtp_port" style="width:36px" value="#EMP_MAIL_LIST.SMTP_PORT#" onkeyup="isNumber(this)" maxlength="3"></td>
        </tr>
        <tr>
            <td><cf_get_lang_main no="73.Öncelik"></td>
            <td colspan="2">
                <select name="priority" id="priority">
                    <option value="0"><cf_get_lang_main no="322.Seçiniz"></option>
                    <option value="1" <cfif EMP_MAIL_LIST.PRIORITY eq 1>selected</cfif>>1</option>
                    <option value="2" <cfif EMP_MAIL_LIST.PRIORITY eq 2>selected</cfif>>2</option>
                    <option value="3" <cfif EMP_MAIL_LIST.PRIORITY eq 3>selected</cfif>>3</option>
                    <option value="4" <cfif EMP_MAIL_LIST.PRIORITY eq 4>selected</cfif>>4</option>
                    <option value="5" <cfif EMP_MAIL_LIST.PRIORITY eq 5>selected</cfif>>5</option>
                    <option value="6" <cfif EMP_MAIL_LIST.PRIORITY eq 6>selected</cfif>>6</option>
                    <option value="7" <cfif EMP_MAIL_LIST.PRIORITY eq 7>selected</cfif>>7</option>
                    <option value="8" <cfif EMP_MAIL_LIST.PRIORITY eq 8>selected</cfif>>8</option>
                    <option value="9" <cfif EMP_MAIL_LIST.PRIORITY eq 9>selected</cfif>>9</option>
                    <option value="10"<cfif EMP_MAIL_LIST.PRIORITY eq 10>selected</cfif>>10</option>
                </select>
            </td>
        </tr>
        <tr height="35">
            <td></td>
            <td colspan="2"  style="text-align:right;"><cf_workcube_buttons is_upd='1' del_function="id_control()" is_cancel="0" add_function="mail_control()"></td>
        </tr>
    </table>
    </cfoutput>
</cfform>
</cf_box>

