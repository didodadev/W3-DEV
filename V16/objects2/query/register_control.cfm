<cfset response = structNew() />

<cfif attributes.register_type eq 1>

    <cfif isDefined("attributes.mail") and len(attributes.mail)>
        <cfquery name="CHECK_NAME" datasource="#dsn#">
            SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.mail)#">
        </cfquery>
        <cfif check_name.recordcount>
            <cfset response = { status: false, message: "#getLang('','Aynı mail adresi daha önce kaydedilmiştir',63790)#! #getLang('','Lütfen farklı bir mail adresi giriniz',63791)#." } />
        <cfelse>
            <cfset response = { status: true } />
        </cfif>
    <cfelse>
        <cfset response = { status: false, message: "#getLang('','E-mail adresini girmelisiniz',55803)#" } />
    </cfif>

<cfelseif attributes.register_type eq 3>

    <cfif isDefined("attributes.username") and len(attributes.username) and isDefined("attributes.register_password") and len(attributes.register_password)>
    
        <cfset response.status = true />
        
        <cfif reFindNoCase("^[\w-\.@]+$", attributes.username) eq 0>
            <cfset response = { status: false, message: 'Username is mistake' } />
        </cfif>
        <cfif reFindNoCase('javascript\s*:|vbscript\s*:|<InvalidTag|<scr|documents\s*\.|<ifr|<for|@import|<met|onerror=|string\.|fromchar|%3C%73%63%72%69%70%74|%3C%69%66%72%61%6D%65|XMLHttp|eval\s*\(|style\s*=\s*"width\s*:\s*expression\(|' & "'\s*or\s*[']*|\w+[']*=[']*\w+|union\s+all", attributes.register_password) gt 0>
            <cfset response = { status: false, message: 'Dangerous content found' } />
        </cfif>
        <cfif reFindNoCase('drop\s+(table|view|procedure)', attributes.register_password) gt 0>
            <cfset response = { status: false, message: 'Dangerous content found' } />
        </cfif>
        <cfif reFindNoCase('create\s+(table|view|procedure)', attributes.register_password) gt 0>
            <cfset response = { status: false, message: 'Dangerous content found' } />
        </cfif>
        <cfif reFindNoCase('exec\s+sp_', attributes.register_password) gt 0>
            <cfset response = { status: false, message: 'Dangerous content found' } />
        </cfif>
        <cfif reFindNoCase('%3Cattributes|\\u\d+|\\x\d+|&##\d+|charset\s*=[\s"]*UTF-7|<base\s+href\s*=\s*"javascript|style\s*=\s*"javascript|<link\s+href\s*=\s*"javascript|list-style-image\s*:\s*url\s*\(\s*"javascript|input\s+type\s*=\s*"image"\s+src\s*=\s*"javascript', attributes.register_password) gt 0>
            <cfset response = { status: false, message: 'Dangerous content found' } />
        </cfif>

        <cfif response.status>
            <cfquery name="CHECK_NAME" datasource="#dsn#">
                SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.username)#">
            </cfquery>

            <cfif check_name.recordcount>
                <cfset response = { status: false, message: "#getLang('','Aynı kullanıcı adı ve şifre ile kayıtlı bir kişi var lütfen kontrol ediniz',52464)#!" } />
            <cfelse>
                <cfscript>
                    try {
                        gopcha_code = int(rand() * 1000000);
                        inst_sms = createObject('component', 'WEX.sitetour.hooks.sms');
                        session.gopcha_code = gopcha_code;
                        inst_sms.send_sms({comp_id: 1, tel: attributes.tel, message: "Workcube Erişimi PIN Kodu: " & gopcha_code});
                        response = { status: true };
                    } catch (any e) {
                        response = { status: false, message: "#getLang('','SMS gönderilirken bir hata oluştu',64123)#!"};
                    }
                </cfscript>
            </cfif>
        </cfif>

    <cfelse>
        <cfset response = { status: false, message: "#getLang('','Kullanıcı Adı ve Şifre alanlarını doldurunuz',63977)#" } />
    </cfif>

<cfelseif attributes.register_type eq 4>

    <cfif isDefined("attributes.mfacode") and len(attributes.mfacode)>
        <cfif IsDefined("session.gopcha_code")>
            <cfif session.gopcha_code eq attributes.mfacode>
                <cfset response = { status: true } />
            <cfelse>
                <cfset response = { status: false, message: 'PIN Code is wrong! Please try again!' } />
            </cfif>
        <cfelse>
                <cfset response = { status: false, message: 'PIN Code is wrong! Please try again!' } />
        </cfif>
    <cfelse>
        <cfset response = { status: false, message: 'Plase enter PIN Code' } />
    </cfif>

<cfelseif attributes.register_type eq 5>

    <cftransaction>

		<cfset register = createObject("component","V16.objects2.cfc.w3DemoRegister")>
		<cfset wsResponse = register.w3DemoRegister(
			member_name:attributes.name,
			member_surname:attributes.surname,
			telno:attributes.tel,
			email:attributes.mail,
			fullname:attributes.company,
			position_cat_id: attributes.position_cat_id,
			sector_cat_id: attributes.sector_cat_id,
			employee_username:attributes.username,
			employee_password:attributes.register_password,
			employee_password1:attributes.register_password,
			firm_type_id: attributes.firm_type_id,
			user_group_id: attributes.user_group_id,
			where_did_you_hear:1,
			is_mail:1,
			lang:attributes.lang,
            interface_id: default_menu?:1
		) />
		<cfset wsResult = xmlParse(wsResponse).Records.Record.Result.XmlText>
		<cfset wsResultDetail = xmlParse(wsResponse).Records.Record.ResultDescription.XmlText>
		<cfif wsResult is 'Success'>
			<cfset workcube_license = createObject("V16.settings.cfc.workcube_license").get_license_information() />
			
			<cfhttp url="https://networg.workcube.com/wex.cfm/iam/ADD_IAM" result="resp" charset="utf-8">
				<cfhttpparam name="company_id" type="formfield" value="5">
				<cfhttpparam name="subscription_no" type="formfield" value="#workcube_license.WORKCUBE_ID#">
				<cfhttpparam name="iam_user_active" type="formfield" value="1">
				<cfhttpparam name="iam_user_username" type="formfield" value="#attributes.username#">
				<cfhttpparam name="iam_user_name" type="formfield" value="#attributes.name#">
				<cfhttpparam name="iam_user_surname" type="formfield" value="#attributes.surname#">
				<cfhttpparam name="iam_user_password" type="formfield" value="#attributes.register_password#">
				<cfhttpparam name="iam_user_first_email" type="formfield" value="#attributes.mail#">
				<cfhttpparam name="iam_user_second_email" type="formfield" value="#attributes.mail#">
				<cfhttpparam name="iam_user_mobile_code" type="formfield" value="#len(attributes.tel) eq 11 ? left(attributes.tel,4) : left(attributes.tel,3)#">
				<cfhttpparam name="iam_user_mobile_tel" type="formfield" value="#Right(attributes.tel,7)#">
                <cfhttpparam name="user_comp_name" type="formfield" value="#attributes.company#">
				<cfhttpparam name="domain" type="formfield" value="#cgi.server_name#">
			</cfhttp>

			<cfif resp.Statuscode eq '200 OK'>
				<cfset responseWexJson = resp.FileContent />
				<cfset responseWex = deserializeJson(responseWexJson) />
				<cfif responseWex.status>
					
                    <cfsavecontent variable="topicContent">
                        <cfoutput>
                            #attributes.name# #attributes.surname# "#attributes.company#" demo sisteme kayıt gerçekleştirmiştir.
                            <cfif len(attributes.company)>
                                Firma: #attributes.company#
                            </cfif>
                            Ad: #attributes.name#
                            Soyad: #attributes.surname#
                            Telefon: #attributes.tel#
                            E Mail: #attributes.mail#
                            </br></br> <em>Holistic Demo Girişi.</em>
                        </cfoutput>
                    </cfsavecontent>

                    <cfhttp url="https://networg.workcube.com/wex.cfm/helpdesk/add_customer_help" result="respHelpDesk" charset="utf-8">
                        <cfhttpparam name="partner_id" type="formfield" value="38261">
                        <cfhttpparam name="company_id" type="formfield" value="18538">
                        <cfhttpparam name="consumer_id" type="formfield" value="">
                        <cfhttpparam name="app_cat" type="formfield" value="12">
                        <cfhttpparam name="interaction_cat" type="formfield" value="1">
                        <cfhttpparam name="interaction_date" type="formfield" value="#now()#">
                        <cfhttpparam name="subject" type="formfield" value="#topicContent#">
                        <cfhttpparam name="process_stage" type="formfield" value="29">
                        <cfhttpparam name="detail" type="formfield" value="#attributes.name# #attributes.surname# - #attributes.company#">
                        <cfhttpparam name="applicant_name" type="formfield" value="#attributes.name# #attributes.surname#">
                        <cfhttpparam name="applicant_mail" type="formfield" value="#attributes.mail#">
                        <cfhttpparam name="is_reply_mail" type="formfield" value="0">
                        <cfhttpparam name="is_reply" type="formfield" value="0">
                        <cfhttpparam name="tel_code" type="formfield" value="#len(attributes.tel) eq 11 ? left(attributes.tel,4) : left(attributes.tel,3)#">
				        <cfhttpparam name="tel_no" type="formfield" value="#Right(attributes.tel,7)#">
                        <cfhttpparam name="record_emp" type="formfield" value="1">
                        <cfhttpparam name="record_date" type="formfield" value="#now()#">
                        <cfhttpparam name="record_ip" type="formfield" value="#cgi.remote_addr#">
                    </cfhttp>

                    <cfif respHelpDesk.Statuscode eq '200 OK'>
                        <cfset respHelpDeskWexJson = respHelpDesk.FileContent />
                        <cfset respHelpDeskWex = deserializeJson(respHelpDeskWexJson) />
                        <cfif respHelpDeskWex.status>
                            <cfset response = { status: true } />
                        <cfelse>
                            <cftransaction action="rollback"/>
                            <cfset response = { status: false, message: "There was an error when creating new user! Please try again later." } />
                        </cfif>
                    <cfelse>
                        <cftransaction action="rollback"/>
                        <cfset response = { status: false, message: "There was an error when creating new user! Please try again later." } />
                    </cfif>

				<cfelse>
					<cftransaction action="rollback"/>
					<cfset response = responseWex />
				</cfif>
			<cfelse>
				<cftransaction action="rollback"/>
				<cfset response = { status: false, message: "There was an error when creating new user! Please try again later." } />
			</cfif>

		<cfelse>
			<cfset response = { status: false, message: wsResultDetail } />
		</cfif>
	</cftransaction>

</cfif>

<cfoutput>#replace(SerializeJson( response ), '//', '')#</cfoutput>
<cfabort>