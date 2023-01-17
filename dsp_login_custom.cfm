<!---
*************************************************************************
	Description : Giriş Ekranının Özelleştirmek İçin Bu Dosya Edit Edilir.
*************************************************************************
--->
<cfsetting showdebugoutput="no"><!---Debug kapalı olmasının sebebi, giriş ekranında bulunan background sabitliği ile ilgilidir. bu sayfada işlem yapmak için kaldırınız sonra tekrar açınız.--->
<!DOCTYPE html>
<html lang="tr">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
		<title><cfif IsDefined("default_menu") and default_menu eq 2>Atomic<cfelse>Holistic</cfif></title>
		<cfparam name="attributes.lang" default="">
		<cfif isdefined('attributes.lang') and len(attributes.lang) and attributes.lang neq 'tr'>
			<cfset session.ep.language='eng'>
		</cfif>
		<!-- Login Tempalte -->
		<!---<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">--->
		<link rel="stylesheet" href="css/assets/template/login/css/login.css" type="text/css" />
	</head>
    <body class="login" <cfif isdefined("attributes.is_req")>style="align-items: end;"</cfif>>
		<cfif IsDefined("default_menu") and default_menu eq 2>
			<style>
				body{background: url(css/assets/template/login/img/watom.png) no-repeat center;}
				@media screen and (max-width: 1199px) {
					body {
						background-color: #fafafa;
						background-image: inherit;
						width: inherit;
						height: inherit;
						overflow-y:scroll;
					}
				}
			</style>
		</cfif>
		<div id="IE_compatibility" style="display:none" align="center"><cf_get_lang_main no='2140.IE Uyumluluk Modunu Kontrol Ediniz.'></div>
		<noscript>
			<div align="center" style="margin-top:30px;">
				<div style="font-size:15px; font-weight:bold;"><cfoutput>#getLang('objects',1074)#</cfoutput></div>
				<div>
					<font color="white" style="font-size:12px;">
						<cf_get_lang_main no='1606.Lütfen Javascript ayarlarınızı tamamlayınız'>...<br />
						<cf_get_lang_main no='1607.Tarayıcı Ayarlarından Javascript ayarlarınızı aktif hale getiriniz.'>
					</font>
				</div>
			</div>
		</noscript>
		<cfif isDefined("error") and error eq 1>
			<cfif not isdefined("session.error_text")>
				<cfsavecontent variable="session.error_text"><cf_get_lang_main no='126.session_error'></cfsavecontent>
			</cfif>
		</cfif>
		<!-- Login Box -->	
		<cfif isdefined("attributes.is_req")>
			<div class="login">  
				<div class="login_left"></div>
				<div class="login_right">
					<div class="login_right_top">
						<cfif IsDefined("default_menu") and default_menu eq 2>
							<a href="https://www.workcube.com/watom" target="_blank" style="color:#cccccc;">Watom Powered by Workcube</a> <img src="css/assets/template/login/img/workcube_logo2.png"/>
						<cfelse>
							workcube.com  <img src="css/assets/template/login/img/workcube_logo2.png"/>
						</cfif>
					</div>
					<div class="login_right_center_panel">
						<cfset get_lang = createObject("component","cfc.right_menu_fnc").getLangs('#dsn#') />
						<cfif get_lang.recordcount>
							<div class="login_language">
								<div class="form-group">
									<select class="form-control" name="login_language" id="login_language">
										<cfoutput query="get_lang">
											<option value="#get_lang.language_short#" <cfif (IsDefined("session.ep.language") and get_lang.language_short eq session.ep.language)>selected</cfif>>#get_lang.language_set#</option>
										</cfoutput>
									</select>
								</div>
							</div>
						</cfif>
						<div id="firstLogin" class="login_content login_right_center">
							<cfform id="form_login" name="form_login" action="#xfa.submit#" method="post">
								<input type="hidden" name="screen_width" id="screen_width" value="-1" />
								<input type="hidden" name="screen_height" id="screen_height" value="-1" />
								<cf_logintoken>
								<div class="form-group">
									<cfinput name="username" id="username" type="text" value="#(isdefined('attributes.username') and len(attributes.username)) ? attributes.username : ''#" placeholder="#getLang('main',139)#" required="yes" maxlength="50" message="#getLang('main',139)#" autocomplete="off"  />
								</div>
								<div class="form-group">
									<cfinput name="password" id="password" type="password" value="#(isdefined('attributes.password') and len(attributes.password)) ? attributes.password : ''#" placeholder="#getLang('main',140)#" required="yes" maxlength="50" message="#getLang('main',140)#" autocomplete="off" />
									<i class="fa fa-eye showPassword" id="login_password" onClick="showLoginPassword('password');"></i>
								</div>
								<div class="form-group">
									<input type="hidden" name="lang" id="lang" value="<cfoutput>#session.ep.language#</cfoutput>">     
									<button type="submit" id="login_button"> <cf_get_lang_main no='142.login'></button> 
								</div>
								<cfif isDefined("session.error_text")>
									<div class="loginError">
										<cfoutput>#session.error_text#</cfoutput> 
										<a href="javascript:void(0)" onclick="togglePanel('sessionControl')" >
											<cf_get_lang_main no='1605.Sistemde asılı kaldıysanız oturumunuzu kurtarmak için tıklayınız'>
										</a>
									</div>
								</cfif> 
								<!--- <cf_wrk_recaptcha submit_id="login_button"> --->
							</cfform>
							<div class="login_right_center_other">
								<cfif isdefined("use_active_directory") and use_active_directory neq 3> 
									<cfif isdefined("use_password_reminder") and use_password_reminder>
										<a class="password_change" href="javascript:void(0)" onClick="togglePanel('remember')"><cf_get_lang_main no='2036.Şifremi Unuttum'></a>
									</cfif>
									<cfif structKeyExists(application.systemParam.systemParam(), 'google_auth_login') and application.systemParam.systemParam().google_auth_login eq true>
										<a class="google_account" href="javascript://"><img src="css/assets/template/login/img/google_icon.png">Google Hesabıyla Giriş</a>
									</cfif>
									<cfif cgi.HTTP_HOST is 'holistic.workcube.com' or cgi.HTTP_HOST is 'watom.workcube.com'>
										<a href="javascript:void(0)" class="registerDemo" onClick="togglePanel('register')">
											<cfif IsDefined("default_menu") and default_menu eq 2>
												<cf_get_lang dictionary_id='64744.Watom deneyimi için yeni bir kullanıcı yaratın'>!
											<cfelse>
												<cf_get_lang dictionary_id='64743.Holistic deneyimi için yeni bir kullanıcı yaratın'>!
											</cfif>
										</a>
									</cfif>
								</cfif>								
							</div>       
						</div>
						<div id="remember" class="login_content login_right_center"></div>	
						<div id="sessionControl" class="login_content login_right_center"></div> 
						<div id="register" class="login_content login_right_center"></div>
					</div>
					<div class="login_right_bottom">
		
						<ul>
							<li class="linkedin">
								<a href="https://www.linkedin.com/company/workcube">
									<i class="fab fa-linkedin-in"></i>
								</a>
							</li>
							<li class="instagram">
								<a href="javascript://">
									<i class="fab fa-instagram"></i>
								</a>
							</li>
							<li class="facebook">
								<a href="https://www.facebook.com/Workcube.ERP">
									<i class="fab fa-facebook-f"></i>
								</a>
							</li>
							<li class="twitter">
								<a href="https://twitter.com/workcube">
									<i class="fab fa-twitter"></i>
								</a>
							</li>
							<li class="youtube">
								<a href="https://www.youtube.com/user/workcubecom">
									<i class="fab fa-youtube"></i>
								</a>
							</li>
						</ul>
			
						<p> © 2021 <a href="http://www.workcube.com/" target="_blank" title="Workcube E-Business System">Workcube Community Cooperation</a></p>
						
					</div>	
				</div>
			</div> 
		<cfelseif isDefined("attributes.mfa") and isDefined("session.ep.gopcha_verify")>
			<div class="login">  
				<div class="login_left"></div>
    				<div class="login_right">
						<div class="login_right_top">
							<cfif IsDefined("default_menu") and default_menu eq 2>
								<a href="https://www.workcube.com/watom" target="_blank" style="color:#cccccc;">Watom Powered by Workcube</a> <img src="css/assets/template/login/img/workcube_logo2.png"/>
							<cfelse>
								workcube.com  <img src="css/assets/template/login/img/workcube_logo2.png"/>
							</cfif>
						</div>
						<div class="login_right_center_panel">
							<cfset get_lang = createObject("component","cfc.right_menu_fnc").getLangs('#dsn#') />
							<cfif get_lang.recordcount>
								<div class="login_language">
									<div class="form-group">
										<select class="form-control" name="login_language" id="login_language">
											<cfoutput query="get_lang">
												<option value="#get_lang.language_short#" <cfif (IsDefined("session.ep.language") and get_lang.language_short eq session.ep.language)>selected</cfif>>#get_lang.language_set#</option>
											</cfoutput>
										</select>
									</div>
								</div>
							</cfif>
							<div id="mfaLogin" class="login_content login_right_center">
								<cfform id="form_mfa" name="form_mfa" action="#xfa.submit#" method="post">
									<input type="hidden" name="mfasubmit" value="1" />
									<cf_logintoken>
									<div class="form-group">
										<p>
										Lütfen <cfoutput>#mid(session.ep.gopcha_verify.address, 1, 4)#***#mid(session.ep.gopcha_verify.address, len(session.ep.gopcha_verify.address)-3, 4)#</cfoutput> numaralı telefonunuza gönderilen 6 haneli kodu girin.
										</p>
									</div>
									<div class="form-group">
										<cfinput name="mfacode" id="mfacode" type="text" placeholder="MFA CODE" required="yes" maxlength="50" message="#getLang('main',139)#" autocomplete="off"  />
									</div>
									<div class="form-group">
										<input type="hidden" name="lang" id="lang" value="<cfoutput>#session.ep.language#</cfoutput>">     
										<button type="submit" id="mfa_button"> <cf_get_lang_main no='142.login'></button> 
									</div>
									<cfif isDefined("session.error_text")>
										<div class="loginError">
											<cfoutput>#session.error_text#</cfoutput> 
											<a href="javascript:void(0)" onclick="togglePanel('sessionControl')" >
												<cf_get_lang_main no='1605.Sistemde asılı kaldıysanız oturumunuzu kurtarmak için tıklayınız'>
											</a>
										</div>
									</cfif> 
									<!--- <cf_wrk_recaptcha submit_id="login_button"> --->
								</cfform>
									
							</div>
							<div id="remember" class="login_content login_right_center"></div>	
							<div id="sessionControl" class="login_content login_right_center"></div> 
							<div id="register" class="login_content login_right_center"></div>
						</div>
						<div class="login_right_bottom">
            
							<ul>
								<li class="linkedin">
									<a href="https://www.linkedin.com/company/workcube">
										<i class="fab fa-linkedin-in"></i>
									</a>
								</li>
								<li class="instagram">
									<a href="javascript://">
										<i class="fab fa-instagram"></i>
									</a>
								</li>
								<li class="facebook">
									<a href="https://www.facebook.com/Workcube.ERP">
										<i class="fab fa-facebook-f"></i>
									</a>
								</li>
								<li class="twitter">
									<a href="https://twitter.com/workcube">
										<i class="fab fa-twitter"></i>
									</a>
								</li>
								<li class="youtube">
									<a href="https://www.youtube.com/user/workcubecom">
										<i class="fab fa-youtube"></i>
									</a>
								</li>
							</ul>
				
							<p> © 2021 <a href="http://www.workcube.com/" target="_blank" title="Workcube E-Business System">Workcube Community Cooperation</a></p>
							
						</div>	
					</div>
					
					
				</div>
			</div> 
		<cfelse>
			<div class="login">  
				<div class="login_left">					
					<cftry>						
						<cfset get_params = application.systemParam.systemParam() />
						<cfif structKeyExists(get_params, 'login_content')>
							<cfquery name="LOGIN_SPECIAL" datasource="#DSN#">
								SELECT CONT_BODY FROM CONTENT WHERE CONTENT_ID = #get_params.login_content#
							</cfquery>											
							<cfif LOGIN_SPECIAL.recordcount>
								<style>body {background: none !important;}</style>
								<cfoutput>#LOGIN_SPECIAL.CONT_BODY#</cfoutput>
							</cfif>
						</cfif>	
						<cfcatch>
						</cfcatch>
					</cftry>
				</div>
				<div class="login_right">
					<div class="login_right_top">
						<cfif IsDefined("default_menu") and default_menu eq 2>
							<a href="https://www.workcube.com/watom" target="_blank" style="color:#cccccc;">Watom Powered by Workcube</a> <img src="css/assets/template/login/img/workcube_logo2.png"/>
						<cfelse>
							workcube.com  <img src="css/assets/template/login/img/workcube_logo2.png"/>
						</cfif>
					</div>
					<div class="login_right_center_panel">
						<cfset get_lang = createObject("component","cfc.right_menu_fnc").getLangs('#dsn#') />
						<cfif get_lang.recordcount>
							<div class="login_language">
								<div class="form-group">
									<select class="form-control" name="login_language" id="login_language">
										<cfoutput query="get_lang">
											<option value="#get_lang.language_short#" <cfif (IsDefined("session.ep.language") and get_lang.language_short eq session.ep.language)>selected</cfif>>#get_lang.language_set#</option>
										</cfoutput>
									</select>
								</div>
							</div>
						</cfif>
						<div id="firstLogin" class="login_content login_right_center">
							<cfform id="form_login" name="form_login" action="#xfa.submit#" method="post">
								<input type="hidden" name="screen_width" id="screen_width" value="-1" />
								<input type="hidden" name="screen_height" id="screen_height" value="-1" />
								<cf_logintoken>
								<div class="form-group">
									<cfinput name="username" id="username" type="text" value="#(isdefined('attributes.username') and len(attributes.username)) ? attributes.username : ''#" placeholder="#getLang('main',139)#" required="yes" maxlength="50" message="#getLang('main',139)#" autocomplete="off"  />
								</div>
								<div class="form-group">
									<cfinput name="password" id="password" type="password" value="#(isdefined('attributes.password') and len(attributes.password)) ? attributes.password : ''#" placeholder="#getLang('main',140)#" required="yes" maxlength="50" message="#getLang('main',140)#" autocomplete="off" />
									<i class="fa fa-eye showPassword" id="login_password" onClick="showLoginPassword('password');"></i>
								</div>
								<div class="form-group">
									<input type="hidden" name="lang" id="lang" value="<cfoutput>#session.ep.language#</cfoutput>">     
									<button type="submit" id="login_button"> <cf_get_lang_main no='142.login'></button> 
								</div>
								<cfif isDefined("session.error_text")>
									<div class="loginError">
										<cfoutput>#session.error_text#</cfoutput> 
										<!--- <a href="javascript:void(0)" onclick="togglePanel('sessionControl')" >
											<cf_get_lang_main no='1605.Sistemde asılı kaldıysanız oturumunuzu kurtarmak için tıklayınız'>
										</a> --->
									</div>
								</cfif> 
								<!--- <cf_wrk_recaptcha submit_id="login_button"> --->
							</cfform>
							<div class="login_right_center_other">
								<cfif isdefined("use_active_directory") and use_active_directory neq 3> 
									<cfif isdefined("use_password_reminder") and use_password_reminder>
										<a class="text_link" href="javascript:void(0)" onClick="togglePanel('remember')"><cf_get_lang_main no='2036.Şifremi Unuttum'></a>
									</cfif>
									<cfif structKeyExists(application.systemParam.systemParam(), 'google_auth_login') and application.systemParam.systemParam().google_auth_login eq true>
										<a class="google_account" href="javascript://"><img src="css/assets/template/login/img/google_icon.png">Google Hesabıyla Giriş</a>
									</cfif>
									<cfif cgi.HTTP_HOST is 'holistic.workcube.com' or cgi.HTTP_HOST is 'watom.workcube.com'>
										<a href="javascript:void(0)" class="registerDemo" onClick="togglePanel('register')">
											<cfif IsDefined("default_menu") and default_menu eq 2>
												<cf_get_lang dictionary_id='64744.Watom deneyimi için yeni bir kullanıcı yaratın'>!
											<cfelse>
												<cf_get_lang dictionary_id='64743.Holistic deneyimi için yeni bir kullanıcı yaratın'>!
											</cfif>
										</a>
									</cfif>
								</cfif>								
							</div>       
						</div>
						<div id="remember" class="login_content login_right_center"></div>	
						<div id="sessionControl" class="login_content login_right_center"></div> 
						<div id="register" class="login_content login_right_center"></div>
					</div>
					<div class="login_right_bottom">
		
						<ul>
							<li class="linkedin">
								<a href="https://www.linkedin.com/company/workcube">
									<i class="fab fa-linkedin-in"></i>
								</a>
							</li>
							<li class="instagram">
								<a href="javascript://">
									<i class="fab fa-instagram"></i>
								</a>
							</li>
							<li class="facebook">
								<a href="https://www.facebook.com/Workcube.ERP">
									<i class="fab fa-facebook-f"></i>
								</a>
							</li>
							<li class="twitter">
								<a href="https://twitter.com/workcube">
									<i class="fab fa-twitter"></i>
								</a>
							</li>
							<li class="youtube">
								<a href="https://www.youtube.com/user/workcubecom">
									<i class="fab fa-youtube"></i>
								</a>
							</li>
						</ul>
			
						<p> © 2021 <a href="http://www.workcube.com/" target="_blank" title="Workcube E-Business System">Workcube Community Cooperation</a></p>
						
					</div>	
				</div>
			</div>  
		</cfif>
		<cfif cgi.HTTP_HOST is 'catalyst.workcube.com'>
			<!-- The Modal -->
			<div id="modal_ok_demo" class="modal">
				<!-- Modal content -->
				<div class="modal-content">
					<div class="modal-header">
					<span class="close" onClick="$('#modal_ok_demo').hide();">&times;</span>
					<h2>W3 Catalyst Demo</h2>
					</div>
					<div class="modal-body">
					<p><cfoutput>#getLang('objects',1075)#</cfoutput></p>
					</div>
					<div class="modal-footer">
					<h3>catalyst.workcube.com</h3>
					</div>
				</div>
			</div>
		</cfif>
		<cfif isDefined("attributes.ex")>
			<link rel="stylesheet" href="css/assets/template/plevne/dialog.css" type="text/css" />
			<div class="plevne-popup">
				<div class="plevne-popup-box">
					<div class="logo">
						<img src="css/assets/icons/catalyst-icon-svg/plevne_was_logo.svg" width="50px" height="80px">
					</div>
					<div class="body">
						<h2>Opss :(</h2>
						Plevne WAS Warning:<br>
						<cfif attributes.ex eq "notoken">
							Login Token not found
						<cfelseif attributes.ex eq "username">
							Username is mistake
						<cfelseif attributes.ex eq "notfound">
							Request not found
						<cfelse>
							Dangerous content found
						</cfif>
						<p>The system administrator has been notified!</p>
						<p><cfset writeOutput(cgi.REMOTE_ADDR)></p>
					</div>
				</div>
			</div>
		</cfif>
    <!-- jQuery  -->
   	<script type="text/javascript" src="/JS/assets/lib/jquery/jquery-min.js"></script>
	<script type="text/javascript" src="JS/temp/login.reveal.js"></script>
	<!---Uyumluluk modu ile ilgili js--->
	<script type="text/javascript" src="JS/IEVersion_compatibility.js"></script>
	<script type="text/javascript" src="JS/js_functions.js"></script>
	<cfif isDefined("attributes.ex")>
		<script type="text/javascript" src="css/assets/template/plevne/dialog.js" />
	</cfif>
	<!---//Uyumluluk modu ile ilgili js--->
	<script>
	/* console.log(document.referrer); */
	$("#form_login").submit(function(){
		if($('#password').val() == "" && $('#username').val() == ""){
			alert("Kullanıcı Adı ve Şifre alanlarını doldurunuz.");
			return false;
		}
	});

	function setUserLanguage( login_language ){
		$.ajax({             
			url: '<cfoutput>#request.self#</cfoutput>?fuseaction=home.popup_password_arrangement',
			type: "POST",
			dataType:"JSON",
			data: { login_language: login_language },
			success: function (response) {
				if( response.STATUS ) location.reload();
				else alert(response.MESSAGE);
			}
		});
	}

	$('#register, #remember, #sessionControl').hide();
	function togglePanel ( frame ){

		var el = $('#'+frame);
		
		if(frame === 'firstLogin'){
			$('#remember, #register, #sessionControl').empty().hide();
			el.show();
		}
		else if(frame === 'register'){
			$('#firstLogin').hide();
			$('#remember, #sessionControl').empty().hide();
			el.show();
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=home.popup_send_password&is_register=1</cfoutput>', 'register', 1);
		}
		else if(frame === 'remember'){
			$('#firstLogin').hide();
			$('#register, #sessionControl').empty().hide();
			el.show();
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=home.popup_send_password&is_intranet=1</cfoutput>', 'remember', 1);
		}
		else if(frame === 'sessionControl'){
			$('#firstLogin').hide();
			$('#remember, #register').empty().hide();
			el.show();
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=home.popup_clear_session&user_type=0</cfoutput>', 'sessionControl', 1);
		}
		
		if(frame === 'register')
		{
			$('#info').show();
	
		}
	};//togglePanel
	
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

	$(function(){

		$('input').keydown(function(){
			$(this).parent().addClass("focus");
		});
		$('input').focusin(function(){
			$(this).parent().addClass("focus");
		});

		$('input').focusout(function(){
			if($(this).val() == ""){
				$(this).parent().removeClass("focus");
			}
		});

		$("select[name = login_language]").change(function(){
			setUserLanguage( $(this).val() );
		});

		<cfif isDefined("setLanguage") and setLanguage>
		var  languageShorts = { tr: 'tr', en: 'eng', de: 'de', ar: 'arb', ru: 'rus', uk: 'ukr', es: 'es', fr: 'fr' };
		
		if( ('language' in navigator) || ('userLanguage' in navigator) ){
			var userLang = navigator.language || navigator.userLanguage;
			if( userLang != '' ){
				var userLangKey = userLang.includes('-') ? userLang.split('-')[0] : userLang;
				if( languageShorts.hasOwnProperty( userLangKey ) ){
					var userLangVal = languageShorts[userLangKey];
					$("select[name = login_language]").val( userLangVal );
					setUserLanguage( userLangVal );	
				}else setUserLanguage( "eng" );
			}else setUserLanguage( "eng" );
		}
		</cfif>

	})

	</script>  

  </body>
</html>