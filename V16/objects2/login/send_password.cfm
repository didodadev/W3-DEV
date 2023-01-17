<cfparam name="attributes.is_register" default="">
<cfif attributes.is_register neq 2 and attributes.is_register neq 3>
    <div id="rememberPasswordDiv" style="display:none;"></div>
	<script type="text/javascript" src="JS/js_functions.js"></script>
    
    <cfsetting showdebugoutput="no">
    <!---"#lang_array_main.item[2036]#"Sifremi Unuttum--->	
</cfif>
<cfif attributes.is_register neq 1 and attributes.is_register neq 2 and attributes.is_register neq 3>
    <cfform name="arrange_password" action="#request.self#?fuseaction=home.popup_password_arrangement" method="post">
        <cfif isdefined("attributes.is_password_info")>
            <input type="hidden" name="is_password_info" id="is_password_info" value="<cfoutput>#attributes.is_password_info#</cfoutput>">
        </cfif>
        <cfif isdefined('attributes.is_intranet')>
            <input type="hidden" name="member_type" id="member_type" value="0">
        <cfelseif isdefined("attributes.is_consumer")>
            <input type="hidden" name="member_type" id="member_type" value="1">
        <cfelseif isdefined('attributes.is_extranet')>
            <input type="hidden" name="partner_login_url" id="partner_login_url" value="<cfif isdefined('attributes.partner_login_url') and len(attributes.partner_login_url)><cfoutput>#attributes.partner_login_url#</cfoutput></cfif>">
            <input type="hidden" name="member_type" id="member_type" value="2">
        <cfelse>
            <label style="float:left; color:#FFF;">
                <input type="radio" name="member_type" id="member_type" value="1" checked><cf_get_lang_main no='174.Bireysel Üye'>
            </label>
            <label style="float:left; color:#FFF;">
                <input type="radio" name="member_type" id="member_type" value="2"><cf_get_lang_main no='173.Kurumsal Üye'>
            </label>
        </cfif>
        <cfif isdefined('attributes.is_intranet')>
            <div class="form-group">
                <cfinput type="text" name="username" id="username" placeholder="#getLang('main',139)#" <!--- class="input_cont" ---> required="yes" message="#getLang('main',139)#" autocomplete="off">
            </div>              
            <div class="form-group">                        
                <cfsavecontent variable="msg"><cf_get_lang_main no="1910.Mail Adresinizi Giriniz!"></cfsavecontent>
                <cfinput type="text" name="mail_address" id="mail_address" placeholder="#getLang('main',16)#" <!--- class="input_cont" ---> required="yes" message="#msg#" validate="email" autocomplete="off">
            </div> 
            <div class="form-group">
                <button type="submit" id="buttonpassword" name="buttonpassword"/> <cf_get_lang_main no='1331.Gonder'> </button>
                <i class="catalyst-eye showPassword" id="login_password" onClick="showLoginPassword('password');"></i>
            </div>
            <div class="loginWarning"><cf_get_lang_main no="1909.Lütfen e-mail adresinizi yazarak gönderiniz yeni şifreniz e-mail adresinize gönderilecektir."></div>
            <div class="login_right_center_other">
                <a class="text_link" href="javascript:void(0)" id="rememberPassword" onClick="window.parent.togglePanel('firstLogin')"><cf_get_lang dictionary_id='57432.Geri'></a>							
            </div> 
        </cfif>
    </cfform>
<cfelseif attributes.is_register eq 1>
    <!--- <cfif cgi.HTTP_HOST is 'catalyst.workcube.com'> --->
        <cfquery name="get_setup_position_cat" datasource="#dsn#">
            SELECT POSITION_CAT_ID, POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_STATUS = 1
        </cfquery>
        <cfquery name="get_setup_sector_cat" datasource="#dsn#">
            SELECT SECTOR_CAT_ID, SECTOR_CAT FROM SETUP_SECTOR_CATS
        </cfquery>
        <cfquery name="get_setup_firm_type" datasource="#dsn#">
            SELECT FIRM_TYPE_ID, FIRM_TYPE FROM SETUP_FIRM_TYPE
        </cfquery>
        <cfquery name="get_user_group" datasource="#dsn#">
            SELECT USER_GROUP_ID, USER_GROUP_NAME FROM USER_GROUP
        </cfquery>
		<cfquery name = "password_settings_count" datasource = "#dsn#">
			SELECT TOP 1 PASSWORD_ID FROM PASSWORD_CONTROL ORDER BY PASSWORD_ID DESC
		</cfquery>
		<cfif password_settings_count.recordCount eq 0>
			<cfquery datasource="#dsn#" name="add_password_inf" result="result">
				INSERT INTO PASSWORD_CONTROL
				(
					PASSWORD_LENGTH,
					PASSWORD_LOWERCASE_LENGTH,
					PASSWORD_UPPERCASE_LENGTH,
					PASSWORD_NUMBER_LENGTH,
					PASSWORD_SPECIAL_LENGTH,
					PASSWORD_HISTORY_CONTROL,
					PASSWORD_CHANGE_INTERVAL,
					PASSWORD_NAME,
					PASSWORD_STATUS
				)
				VALUES
				(
					6,
					1,
					1,
					1,
					1,
					0,
					0,
					'Standart',
					1
				)
			</cfquery>
			<cfset queryid = result.IDENTITYCOL>
		<cfelse>
			<cfset queryid = password_settings_count.PASSWORD_ID>
		</cfif>
		<cfquery name = "password_settings" datasource = "#dsn#">
			SELECT 
				PASSWORD_LENGTH,
				PASSWORD_LOWERCASE_LENGTH,
				PASSWORD_UPPERCASE_LENGTH,
				PASSWORD_NUMBER_LENGTH,
				PASSWORD_SPECIAL_LENGTH
			FROM 
				PASSWORD_CONTROL
			WHERE PASSWORD_ID = #queryid#
		</cfquery>
        
        <script src="https://www.google.com/recaptcha/api.js" async defer></script>
        <!---<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js" async defer></script>--->
        <script src="../../../JS/assets/lib/jquery/jquery-min.js" async defer></script>
        <div id="returnData"></div>
        <form name="registerForm" id="registerForm" method="POST">
            <input type="hidden" name="lang" id="lang" value="<cfoutput>#session.ep.language#</cfoutput>">
            <div class="register_step" id="register_1">
                <div class="login_right_center_title"><cf_get_lang dictionary_id='63782.Yeni bir kullanıcı açmak için birkaç bilgiye ihtiyacımız var'>:)</div>
                <div class="form-group">
                    <input name="name" id="name" type="text" placeholder="<cf_get_lang dictionary_id='63785.Adınız'>" required autocomplete="off"/>
                </div>
                <div class="form-group">
                    <input name="surname" id="surname" type="text" placeholder="<cf_get_lang dictionary_id='35630.Soyadınız'>" required autocomplete="off"/>
                </div>
                <div class="form-group">
                    <input name="tel" id="tel" type="tel" placeholder="<cf_get_lang dictionary_id='58482.Mobil Tel'>" required autocomplete="off"/>
                </div>
                <div class="form-group">
                    <i class="catalyst-envelope"></i> 
                    <input name="mail" id="mail" type="email" placeholder="<cf_get_lang dictionary_id='55484.E-Mail'>" required autocomplete="off"/>
                </div>
                <cfif cgi.HTTP_REFERER is 'https://www.workcube.com/' OR cgi.HTTP_REFERER is 'https://www.workcube.com/en'>
                    <div class="login-links"> 
                        <a href="javascript:void(0)" id="rememberPassword" onClick="window.parent.togglePanel('register')"><cf_get_lang dictionary_id='57432.Geri'></a>
                    </div>
                </cfif>
                <div class="form-group">
                    <button type="submit"><cfoutput>#getLang('','İlerle',63784)#</cfoutput></button>
                </div>
                <div class="login_right_center_other">
                    <a class="text_link" href="javascript:void(0)" id="userLogin" onClick="window.parent.togglePanel('firstLogin')"><cfoutput>#getLang('','Kullanıcım Var',63783)#</cfoutput></a>
                </div>
            </div>
            <div class="register_step" id="register_2" style="display:none;">
                <div class="login_right_center_title"><cf_get_lang dictionary_id='63786.Şirketiniz ve sektörünüzü bilmek size daha iyi bir demo ortamı yaratmamıza yardım edecek'>:)</div>
                <div class="form-group">
                    <input name="company" id="company" type="text" placeholder="<cf_get_lang dictionary_id='63787.İşletmenizin Ünvanı'>" autocomplete="off">
                </div>
                <div class="form-group">
                    <select name="position_cat_id" id="position_cat_id">
                        <option value=""><cf_get_lang dictionary_id='35675.Göreviniz'></option>
                        <cfif get_setup_position_cat.recordCount>
                            <cfoutput query="get_setup_position_cat">
                                <option value="#POSITION_CAT_ID#">#POSITION_CAT#</option>
                            </cfoutput>
                        </cfif>
                    </select>
                </div>
                <div class="form-group">
                    <select name="sector_cat_id" id="sector_cat_id">
                        <option value=""><cf_get_lang dictionary_id='35400.Sektörünüz'></option>
                        <cfif get_setup_sector_cat.recordCount>
                            <cfoutput query="get_setup_sector_cat">
                                <option value="#SECTOR_CAT_ID#">#SECTOR_CAT#</option>
                            </cfoutput>
                        </cfif>
                    </select>
                </div>
                <div class="form-group">
                    <button type="submit"><cfoutput>#getLang('','İlerle',63784)#</cfoutput></button>
                </div>
                <div class="login_right_center_other">
                    <a class="text_link" href="javascript:void(0)" onclick="goPrev()"><cf_get_lang dictionary_id='57432.Geri'></a>
                </div>
            </div>
            <div class="register_step" id="register_3" style="display:none;">
                <div class="login_right_center_title"><cf_get_lang dictionary_id='63788.Size bir kullanıcı ve güçlü bir şifre yaratalım'>!</div>
                <div class="form-group">
                    <input name="username" id="username" type="text" placeholder="<cfoutput>#getLang('main',139)#</cfoutput>" maxlength="50" autocomplete="off" autocomplete="off"/>
                </div>
                <div class="form-group">
                    <input name="register_password" id="register_password" type="password" placeholder="<cfoutput>#getLang('main',140)#</cfoutput>" maxlength="50" autocomplete="off" onkeyup="passwordControl()"/>
                    <i class="fa fa-eye showPassword" id="login_password" onClick="showLoginPassword('register_password');"></i>
                </div>
                <div class="form-group">
                    <button type="submit"><cfoutput>#getLang('','İlerle',63784)#</cfoutput></button>
                </div>
                <div class="login_right_center_other">
                    <div id="password_message" class="text_message"></div>
                </div>
                <div class="login_right_center_other">
                    <a class="text_link" href="javascript:void(0)" onclick="goPrev()"><cf_get_lang dictionary_id='57432.Geri'></a>
                </div>
            </div>
            <div class="register_step" id="register_4" style="display:none;">
                <div class="form-group">
                    <p class="p_message" id="phone_number"></p>
                    <p class="p_message">
                        <cf_get_lang dictionary_id="63789.Telefonunuza gönderdiğimiz PIN'i lütfen giriniz">
                    </p>
                </div>
                <div class="form-group">
                    <input name="mfacode" id="mfacode" type="text" maxlength="6" autocomplete="off"  />
                </div>
                <div class="form-group">
                    <button type="submit"><cfoutput>#getLang('','İlerle',63784)#</cfoutput></button>
                </div>
                <div class="login_right_center_other">
                    <a class="text_link" href="javascript:void(0)" onclick="goPrev()"><cf_get_lang dictionary_id='57432.Geri'></a>
                </div>
            </div>
            <div class="register_step" id="register_5" style="display:none;">
                <div class="form-group">
                    <p class="p_message"><cf_get_lang dictionary_id='63793.Seçeceğiniz işletme tipine uygun demo ortamı yaratılacaktır'></p>
                </div>
                <div class="form-group">
                    <select name="firm_type_id" id="firm_type_id">
                        <option value=""><cf_get_lang dictionary_id='63792.İşletme Tipi'></option>
                        <cfif get_setup_firm_type.recordCount>
                            <cfoutput query="get_setup_firm_type">
                                <option value="#FIRM_TYPE_ID#">#FIRM_TYPE#</option>
                            </cfoutput>
                        </cfif>
                    </select>
                </div>
                <div class="form-group">
                    <p class="p_message"><cf_get_lang dictionary_id='63795.Belirlediğiniz yetki grubuna göre size özel konfigürasyonlar yapılacaktır'></p>
                </div>
                <div class="form-group">
                    <select name="user_group_id" id="user_group_id">
                        <option value=""><cf_get_lang dictionary_id='63794.Rol ve Yetki Grubu'></option>
                        <cfif get_user_group.recordCount>
                            <cfoutput query="get_user_group">
                                <option value="#USER_GROUP_ID#">#USER_GROUP_NAME#</option>
                            </cfoutput>
                        </cfif>
                    </select>
                </div>
                <div class="form-group">
                    <button type="submit"><cfoutput>#getLang('','Deneyim Başlasın',63796)#</cfoutput></button>
                </div>
                <div class="login_right_center_other">
                    <a class="text_link" href="javascript:void(0)" onclick="goPrev()"><cf_get_lang dictionary_id='57432.Geri'></a>
                </div>
            </div>
            <div class="register_step" id="register_6" style="display:none;">
                <div class="login_right_center_title" style="padding:25px;"><cf_get_lang dictionary_id='64125.Workcube Holistic deneyimi için yönlendiriliyor'>!</div>
                <div style="text-align: center;">
                    <svg width="32px" height="32px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" preserveAspectRatio="xMidYMid" class="uil-ring-alt"><rect x="0" y="0" width="100" height="100" fill="none" class="bk"></rect><circle cx="50" cy="50" r="40" stroke="rgba(255,255,255,0)" fill="none" stroke-width="10" stroke-linecap="round"></circle><circle cx="50" cy="50" r="40" stroke="#ff8a00" fill="none" stroke-width="6" stroke-linecap="round"><animate attributeName="stroke-dashoffset" dur="2s" repeatCount="indefinite" from="0" to="502"></animate><animate attributeName="stroke-dasharray" dur="2s" repeatCount="indefinite" values="150.6 100.4;1 250;150.6 100.4"></animate></circle></svg>
                </div>
            </div>
        </form>
        <div class="register_step" id="register_7" style="display:none;">
            <cfform name="loginForm" id="loginForm" action="#request.self#?fuseaction=home.login" method="POST">
                <input type="hidden" name="username" id="username">
                <input type="hidden" name="password" id="password">
                <div class="login_right_center_title" style="padding:25px;"><cf_get_lang dictionary_id='64119.Demo ortamınız başarıyla oluşturuldu'>!</div>
                <div class="form-group">
                    <button type="submit"><cf_get_lang dictionary_id='58843.İleri'></button>
                </div>
            </cfform>
        </div>
        <script>
            let register_type = 1;

            function goPrev() {

                $("#register_" + register_type).find('input, select').each(function() {
                    $(this).prop('required',false);
                });

                register_type--;

                $(".register_step").hide();
                $("#register_" + register_type).show();
            }

            function goNext() {
                register_type++;

                $("#register_" + register_type).find('input, select').each(function() {
                    $(this).prop('required',true);
                });

                $(".register_step").hide();
                $("#register_" + register_type).show();
            }

            function passwordControl(){

                function contains(deger,validChars)						
                {
                    var sayac=0;				             
                    for (i = 0; i < deger.length; i++)
                    {
                        var char = deger.charAt(i);
                        if (validChars.indexOf(char) > -1)    
                            sayac++;
                    }
                    return(sayac);				
                }

                function alertMessage(message){
                    $("#password_message").text(message);
                    document.getElementById('register_password').focus();
                    document.querySelector("#register_3 button[type = submit]").disabled = true;
                }

                if ($('#register_password').val() != "")
                {
                    var number="0123456789";
                    var lowercase = "abcdefghijklmnopqrstuvwxyz";
                    var uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                    var ozel="!]'^%&([=?_<£)#$½{\|.:,;/*-+}>";
                    
                    var control_ifade_ = $('#register_password').val();
                    var containsNumberCase = contains(control_ifade_,number);
                    var containsLowerCase = contains(control_ifade_,lowercase);
                    var containsUpperCase = contains(control_ifade_,uppercase);
                    var ozl = contains(control_ifade_,ozel);
                    
                    $("#password_message").text("");

                    if(control_ifade_.length < <cfoutput>#password_settings.PASSWORD_LENGTH#</cfoutput>)
                    {
                        alertMessage("<cf_get_lang dictionary_id='64114.Şifrede bulunması gereken minimum karakter sayısı'>: <cfoutput>#password_settings.PASSWORD_LENGTH#</cfoutput>");
                        return false;
                    }
                    
                    if(<cfoutput>#password_settings.PASSWORD_NUMBER_LENGTH#</cfoutput> > containsNumberCase)
                    {
                        alertMessage("<cf_get_lang dictionary_id='64115.Şifrede bulunması gereken minimum sayı'>: <cfoutput>#password_settings.PASSWORD_NUMBER_LENGTH#</cfoutput>");
                        return false;
                    }
                    
                    if(<cfoutput>#password_settings.PASSWORD_LOWERCASE_LENGTH#</cfoutput> > containsLowerCase)
                    {
                        alertMessage("<cf_get_lang dictionary_id='64116.Şifrede bulunması gereken minimum büyük harf sayısı'>: <cfoutput>#password_settings.PASSWORD_LOWERCASE_LENGTH#</cfoutput>");
                        return false;
                    }
                    
                    if(<cfoutput>#password_settings.PASSWORD_UPPERCASE_LENGTH#</cfoutput> > containsUpperCase)
                    {
                        alertMessage("<cf_get_lang dictionary_id='64117.Şifrede bulunması gereken minimum küçük harf sayısı'>: <cfoutput>#password_settings.PASSWORD_UPPERCASE_LENGTH#</cfoutput>");
                        return false;
                    }
                    
                    if(<cfoutput>#password_settings.PASSWORD_SPECIAL_LENGTH#</cfoutput> > ozl)
                    {
                        alertMessage("<cf_get_lang dictionary_id='64118.Şifrede bulunması gereken minimum özel karakter sayısı'>: <cfoutput>#password_settings.PASSWORD_SPECIAL_LENGTH#</cfoutput>");
                        return false;
                    }
                    document.querySelector("#register_3 button[type = submit]").disabled = false;
                }
                return true;
            }

            function setRequest( data ) {

                if( register_type != 2 ){
                    
                    if( register_type == 5 ){
                        goNext();
                        register_type--;
                    }

                    $.ajax({             
                        url: '<cfoutput>#request.self#</cfoutput>?fuseaction=home.popup_password_arrangement&register_type=' + register_type,
                        type: "POST",
                        dataType:"JSON",
                        data: data,
                        success: function (response) {
                            if( response.STATUS ){
                                if( register_type == 3 ){
                                    if(passwordControl()){
                                        $("#phone_number").text( document.getElementById('tel').value );
                                    }else return false;
                                }
                                if( register_type != 5 ) goNext();
                                else{
                                    setTimeout(() => {
                                        document.querySelector('div#register_7 #username').value = document.querySelector('div#register_3 #username').value;
                                        document.querySelector('div#register_7 #password').value = document.querySelector('div#register_3 #register_password').value;
                                        register_type++;
                                        goNext();
                                    }, 3000);
                                }
                            }
                            else alert(response.MESSAGE);
                        }
                    });

                }else goNext();

            }

            $("#registerForm").submit(function(){
                setRequest( $(this).serialize() );
                return false;
            });

            $("#register_4").on("keyup keydown","#mfacode",function(event){
                if( $(this).val().length == 6 ){
                    $("#register_4").find('button[type = submit]').click();
                }
            });
           
        </script>

<cfelse>
	<cfset recaptcha = #attributes.response#>
	<cfif len(recaptcha)>
		
		<cfset googleUrl = "https://www.google.com/recaptcha/api/siteverify">
		<cfset secret = "6LcDexwUAAAAAJE2Qkrj8hSyAKj4OMgZ1_A58yEF">
		<cfset ipaddr = CGI.REMOTE_ADDR>
		<cfset request_url = googleUrl & "?secret=" & secret & "&response=" & recaptcha & "&remoteip" & ipaddr>
		
		<cfhttp url="#request_url#" method="get" timeout="10">
		
		<cfset response = deserializeJSON(cfhttp.filecontent)>
		<cfif response.success eq "YES">YES</cfif>	
	</cfif>
</cfif>
<script type="text/javascript" src="/JS/assets/lib/jquery/jquery-min.js"></script>

<script>
    function showLoginPassword(inputid){
        var input = document.getElementById(inputid);
        var eyeicon = document.querySelector("#" + inputid + " + i");
        var type = input.getAttribute("type");
        if(type == "password"){
            input.setAttribute("type","text");
            eyeicon.setAttribute("class","fa fa-lock");
        }else{
            input.setAttribute("type","password");
            eyeicon.setAttribute("class","fa fa-eye");
        }
    }
</script>