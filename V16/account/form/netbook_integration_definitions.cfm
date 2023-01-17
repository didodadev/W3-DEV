<cfif session.ep.our_company_info.is_edefter>
<cfscript>
	netbook = createObject("component","V16.e_government.cfc.netbook");
	netbook.dsn = dsn;
	get_integration_definitions = netbook.getIntegrationDefinitions();
</cfscript>
<cf_form_box title="#getLang('account',264)#">
	<cfform name="netbook_integration_definitions" action="#request.self#?fuseaction=account.emptypopup_upd_netbook_integration" enctype="multipart/form-data" method="post">
		<input type="hidden" name="netbook_integration_type" id="netbook_integration_type" value="1" />
        <cf_area>
            <table>
                <tr>
                    <td width="160"><cf_get_lang dictionary_id="30626.E-Defter Kullanılıyor mu?"></td>
                    <td><cf_get_lang_main no='83.Evet'></td>
                </tr>
                <tr id="is_use_netbook_webservice_style">
                   	<td colspan="2">
                        <table>
                            <tr>
                                <td width="160"><cf_get_lang_main no='1414.Test'></td>
                                <td><input type="checkbox" id="netbook_test_system" name="netbook_test_system" onclick="show_test();" <cfif get_integration_definitions.netbook_test_system eq 1>checked</cfif>/></td>
                            </tr>
                            <tr>
                                <td colspan="2" class="txtboldblue"><cf_get_lang dictionary_id="30616.Web Servis Bilgileri"></td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id="30614.Webservice URL">*</td>
                                <td id="label_netbook_webservice_url"<cfif get_integration_definitions.recordcount and get_integration_definitions.netbook_test_system eq 1>style="display:none;"</cfif>><input type="text" id="netbook_webservice_url" name="netbook_webservice_url" value="<cfoutput>#get_integration_definitions.netbook_webservice_url#</cfoutput>" maxlength="100" style="width:185px;"/></td>
                                <td id="label_netbook_test_webservice_url"<cfif get_integration_definitions.recordcount and get_integration_definitions.netbook_test_system neq 1>style="display:none;"</cfif>><input type="text" id="netbook_test_webservice_url" name="netbook_test_webservice_url" value="<cfoutput>#get_integration_definitions.netbook_test_webservice_url#</cfoutput>" maxlength="100" style="width:185px;"/></td>
                            </tr>
                            <tr>
                                <td><cf_get_lang no='306.Şirket Kodu'></td>
                                <td id="label_netbook_company_code"<cfif get_integration_definitions.recordcount and get_integration_definitions.netbook_test_system eq 1>style="display:none;"</cfif>><input type="text" id="netbook_company_code" name="netbook_company_code" value="<cfoutput>#get_integration_definitions.netbook_company_code#</cfoutput>" maxlength="50" style="width:185px;"/></td>
                                <td id="label_netbook_test_company_code"<cfif get_integration_definitions.recordcount and get_integration_definitions.netbook_test_system neq 1>style="display:none;"</cfif>><input type="text" id="netbook_test_company_code" name="netbook_test_company_code" value="<cfoutput>#get_integration_definitions.netbook_test_company_code#</cfoutput>" maxlength="50" style="width:185px;"/></td>
                            </tr>
                            <tr>
                                <td><cf_get_lang_main no='139.Kullanıcı Adı'> *</td>
                                <td id="label_netbook_username"<cfif get_integration_definitions.recordcount and get_integration_definitions.netbook_test_system eq 1>style="display:none;"</cfif>><input type="text" id="netbook_username" name="netbook_username" value="<cfoutput>#get_integration_definitions.netbook_username#</cfoutput>" maxlength="50" style="width:185px;"/></td>
                                <td id="label_netbook_test_username"<cfif get_integration_definitions.recordcount and get_integration_definitions.netbook_test_system neq 1>style="display:none;"</cfif>><input type="text" id="netbook_test_username" name="netbook_test_username" value="<cfoutput>#get_integration_definitions.netbook_test_username#</cfoutput>" maxlength="50" style="width:185px;"/></td>
                            </tr>
                            <tr>
                                <td><cf_get_lang_main no='140.Şifre'> *</td>
                                <td id="label_netbook_password"<cfif get_integration_definitions.recordcount and get_integration_definitions.netbook_test_system eq 1>style="display:none;"</cfif>><input type="password" id="netbook_password" name="netbook_password" value="<cfoutput>#get_integration_definitions.netbook_password#</cfoutput>" maxlength="50" style="width:185px;"/></td>
                                <td id="label_netbook_test_password"<cfif get_integration_definitions.recordcount and get_integration_definitions.netbook_test_system neq 1>style="display:none;"</cfif>><input type="password" id="netbook_test_password" name="netbook_test_password" value="<cfoutput>#get_integration_definitions.netbook_test_password#</cfoutput>" maxlength="50" style="width:185px;"/></td>
                            </tr>
                            
                            <tr>
                                <td colspan="2" class="txtboldblue"><cf_get_lang dictionary_id="30610.Cloud FTP Bilgileri"></td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id="30602.FTP Server"></td>
                                <td id="label_netbook_ftp_server"<cfif get_integration_definitions.recordcount and get_integration_definitions.netbook_test_system eq 1>style="display:none;"</cfif>><input type="text" name="netbook_ftp_server" id="netbook_ftp_server" value="<cfoutput>#get_integration_definitions.netbook_ftp_server#</cfoutput>" style="width:185px;" maxlength="100"></td>
                                <td id="label_netbook_test_ftp_server"<cfif get_integration_definitions.recordcount and get_integration_definitions.netbook_test_system neq 1>style="display:none;"</cfif>><input type="text" id="netbook_test_ftp_server" name="netbook_test_ftp_server" value="<cfoutput>#get_integration_definitions.netbook_test_ftp_server#</cfoutput>" maxlength="100" style="width:185px;"/></td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id="30601.FTP Port"></td>
                                <td id="label_netbook_ftp_port"<cfif get_integration_definitions.recordcount and get_integration_definitions.netbook_test_system eq 1>style="display:none;"</cfif>><input type="text" name="netbook_ftp_port" id="netbook_ftp_port" value="<cfoutput>#get_integration_definitions.netbook_ftp_port#</cfoutput>" style="width:185px;" maxlength="100"></td>
                                <td id="label_netbook_test_ftp_port"<cfif get_integration_definitions.recordcount and get_integration_definitions.netbook_test_system neq 1>style="display:none;"</cfif>><input type="text" id="netbook_test_ftp_port" name="netbook_test_ftp_port" value="<cfoutput>#get_integration_definitions.netbook_test_ftp_port#</cfoutput>" maxlength="100" style="width:185px;"/></td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id="29709.Kullanıcı Adı"></td>
                                <td id="label_netbook_ftp_username"<cfif get_integration_definitions.recordcount and get_integration_definitions.netbook_test_system eq 1>style="display:none;"</cfif>><input type="text" name="netbook_ftp_username" id="netbook_ftp_username" value="<cfoutput>#get_integration_definitions.netbook_ftp_username#</cfoutput>" style="width:185px;" maxlength="100"></td>
                                <td id="label_netbook_test_ftp_username"<cfif get_integration_definitions.recordcount and get_integration_definitions.netbook_test_system neq 1>style="display:none;"</cfif>><input type="text" id="netbook_test_ftp_username" name="netbook_test_ftp_username" value="<cfoutput>#get_integration_definitions.netbook_test_ftp_username#</cfoutput>" maxlength="100" style="width:185px;"/></td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id="57552.Şifre"></td>
                                <td id="label_netbook_ftp_password"<cfif get_integration_definitions.recordcount and get_integration_definitions.netbook_test_system eq 1>style="display:none;"</cfif>><input type="password" name="netbook_ftp_password" id="netbook_ftp_password" value="<cfoutput>#get_integration_definitions.netbook_ftp_password#</cfoutput>" style="width:185px;" maxlength="100"></td>
                                <td id="label_netbook_test_ftp_password"<cfif get_integration_definitions.recordcount and get_integration_definitions.netbook_test_system neq 1>style="display:none;"</cfif>><input type="password" id="netbook_test_ftp_password" name="netbook_test_ftp_password" value="<cfoutput>#get_integration_definitions.netbook_test_ftp_password#</cfoutput>" maxlength="100" style="width:185px;"/></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </cf_area>
		<cf_form_box_footer>
			<cf_record_info query_name="get_integration_definitions" record_emp="record_emp" update_emp="update_emp" is_partner="1">
			<cf_workcube_buttons is_upd='1' is_delete='0' add_function="upd_control()">
		</cf_form_box_footer>
    </cfform>
</cf_form_box>
<script language="javascript">
	function upd_control()
	{
		if(document.getElementById('netbook_integration_type').value == '')
		{
			alert("<cf_get_lang dictionary_id='57262.Entegrasyon Yöntemi Seçiniz'>!");
			return false;
		}
		if(document.getElementById('netbook_test_system').checked == true)
		{
			if(document.getElementById('netbook_test_webservice_url').value == '')
			{
				alert("<cf_get_lang dictionary_id='30596.WebService URL Giriniz'>!");
				return false;
			}
			if(document.getElementById('netbook_test_username').value == '')
			{
				alert("<cf_get_lang dictionary_id='34327.Kullanıcı Adı Giriniz'>!");
				return false;
			}
			if(document.getElementById('netbook_test_password').value == '')
			{
				alert("<cf_get_lang dictionary_id='49039.Şifre Giriniz'>!");
				return false;
			}
		}
		else
		{
			if(document.getElementById('netbook_webservice_url').value == '')
			{
				alert("<cf_get_lang dictionary_id='30596.WebService URL Giriniz'>!");
				return false;
			}
			if(document.getElementById('netbook_username').value == '')
			{
				alert("<cf_get_lang dictionary_id='45139.Kullanıcı Adı Giriniz'>");
				return false;
			}
			if(document.getElementById('netbook_password').value == '')
			{
				alert("<cf_get_lang dictionary_id='49039.Şifre Giriniz'>!");
				return false;
			}
		}
	}

	function show_test()
	{
		if(document.getElementById('netbook_test_system').checked == true)
		{
			document.getElementById('label_netbook_webservice_url').style.display = 'none';
			document.getElementById('label_netbook_company_code').style.display = 'none';
			document.getElementById('label_netbook_username').style.display = 'none';
			document.getElementById('label_netbook_password').style.display = 'none';
			
			document.getElementById('label_netbook_ftp_server').style.display = 'none';
			document.getElementById('label_netbook_ftp_port').style.display = 'none';
			document.getElementById('label_netbook_ftp_username').style.display = 'none';
			document.getElementById('label_netbook_ftp_password').style.display = 'none';
			
			document.getElementById('label_netbook_test_webservice_url').style.display = '';
			document.getElementById('label_netbook_test_company_code').style.display = '';
			document.getElementById('label_netbook_test_username').style.display = '';
			document.getElementById('label_netbook_test_password').style.display = '';
			
			document.getElementById('label_netbook_test_ftp_server').style.display = '';
			document.getElementById('label_netbook_test_ftp_port').style.display = '';
			document.getElementById('label_netbook_test_ftp_username').style.display = '';
			document.getElementById('label_netbook_test_ftp_password').style.display = '';
		}
		else
		{
			document.getElementById('label_netbook_webservice_url').style.display = '';
			document.getElementById('label_netbook_company_code').style.display = '';
			document.getElementById('label_netbook_username').style.display = '';
			document.getElementById('label_netbook_password').style.display = '';
			
			document.getElementById('label_netbook_ftp_server').style.display = '';
			document.getElementById('label_netbook_ftp_port').style.display = '';
			document.getElementById('label_netbook_ftp_username').style.display = '';
			document.getElementById('label_netbook_ftp_password').style.display = '';
			
			document.getElementById('label_netbook_test_webservice_url').style.display = 'none';
			document.getElementById('label_netbook_test_company_code').style.display = 'none';
			document.getElementById('label_netbook_test_username').style.display = 'none';
			document.getElementById('label_netbook_test_password').style.display = 'none';
			
			document.getElementById('label_netbook_test_ftp_server').style.display = 'none';
			document.getElementById('label_netbook_test_ftp_port').style.display = 'none';
			document.getElementById('label_netbook_test_ftp_username').style.display = 'none';
			document.getElementById('label_netbook_test_ftp_password').style.display = 'none';
			
		}
	}
	show_test();
</script>
<cfelse>
	<cf_get_lang dictionary_id="52153.Sistem Yöneticinize Başvurun">!
</cfif>