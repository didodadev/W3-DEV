<cfif not isdefined('session.pp') and not isdefined('session.ww.userid')>
	<cfif use_https><cfset url_link = https_domain><cfelse><cfset url_link = ""></cfif>
    
	<cfif attributes.fuseaction contains 'popup'>
		<script type="text/javascript" charset="utf-8" src="/documents/templates/worknet/js/icerik.js"></script>
	</cfif>
	<div class="haber_liste">
		<div class="member_login_1" style="width: 100%;border-bottom: solid 4px #438AAD;height: 31px;">
			<ul>
				<li style="float:left;"><a id="kurumsal_tab" style="height: 16px;float: left;margin-top: 0px;" class="view_member_login aktif" onclick="loginTab('kurumsal')" href="javascript:void(0);"><cf_get_lang no='285.Kurumsal Üye Girişi'></a></li>
				<li style="float:left;"><a id="bireysel_tab" style="height: 16px;float: left;margin-top: 0px;" class="view_member_login" onclick="loginTab('bireysel')" href="javascript:void(0);"><cf_get_lang no='286.İHKİB Akademi Girişi'></a></li>
			</ul>
		</div>
		<cf_get_lang_set module_name="objects2"><!--- sayfanin en altinda kapanisi var --->
		<div class="member_login_2" style="background-color:##333333;width: 878px;padding: 15px;border: solid 1px #CCC;border-top: none;height: 178px;">
			<div id="kurumsal" class="member_login_21">
				<!--- kurumsal --->
				<cfform action="#url_link##request.self#?fuseaction=home.act_login" method="post" name="login_">
					<cfif url.fuseaction contains 'member_login'>
						<input type="hidden" name="referer" id="referer" value="<cfoutput>#request.self#?fuseaction=worknet.dashboard</cfoutput>" />
					<cfelse>
						<cfset urlVars = ''>
						<cfloop collection='#url#' item='k'>
							<cfif (k neq 'FUSEACTION') and (k neq 'setLang')>
								<cfset urlVars = urlVars & "&" & k & "=" & URLEncodedFormat(url[k])>
							</cfif>
						</cfloop>
						<input type="hidden" name="referer" id="referer" value="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction##urlVars#</cfoutput>" />
					</cfif>
					<div class="uyegirisi" style="width:910px;">
						<div class="uyegirisi_" style="width:500px;">
							<div class="uyegirisi_1">
								<span style="float:left;display:table-cell;width: 106px;" id="userNameContainer"><cf_get_lang_main no='16.E-Posta'></span>
								<cfsavecontent variable="message"><cf_get_lang no="6.Kullanıcı Adı Girmelisiniz">!</cfsavecontent>
								<span style="display:table-cell;">
									<cfif isdefined('cookie.username')>
										<cfinput type="text" name="username" value="#cookie.username#" required="yes" message="#message#" autocomplete="off" class="txt_1">
									<cfelse>
										<cfinput type="text" name="username" value="" required="yes" message="#message#" autocomplete="off" class="txt_1">
									</cfif>
								</span>
							</div>
							<div class="uyegirisi_1">
								<span style="float:left;width: 106px;" id="passwordContainer"><cf_get_lang_main no='140.Sifre'></span>
								<cfsavecontent variable="message"><cf_get_lang no="7.Şifre Girmelisiniz">!</cfsavecontent>
								<span style="display:table-cell;">
									<cfif isdefined('cookie.password')>
										<cfinput type="password" name="password" value="#cookie.password#" required="yes" message="#message#" autocomplete="off" class="txt_1">
									<cfelse>
										<cfinput type="password" name="password" value="" required="yes" message="#message#" autocomplete="off" class="txt_1">
									</cfif>
								</span>
							</div>
							<div class="uyegirisi_1" id="rememberMeContainer">
								<span>
									<input type="checkbox" name="remember_me" id="remember_me" value="1" checked="checked" style="float:left;">
								<samp style="margin-left:5px; margin-top:1px;font-size: 16px;"><cf_get_lang no="104.Beni Hatırla"></samp></span>
							</div>	
							<div class="uyegirisi_1">
								<cfsavecontent variable="message"><cf_get_lang_main no="142.Giriş"></cfsavecontent>
								<input class="btn_1" type="submit" value="<cfoutput>#message#</cfoutput>"/>
								<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=home.popup_send_password&is_extranet=1','small');"><cf_get_lang_main no ='2036.Şifremi Unuttum'></a>
							</div>	
							<div class="uyegirisi_1">
								<cfif session_base.language is 'tr'>
									<a href="<cfoutput>#url_link#</cfoutput>/add_member" style="padding-right:98px;"><cf_get_lang no="126.Üye Olmak İstiyorum"></a>
								<cfelse>
									<a href="<cfoutput>#url_link#</cfoutput>/form_add_member" style="padding-right:98px;"><cf_get_lang no="126.Üye Olmak İstiyorum"></a>
								</cfif>
							</div>					
							<cfif isDefined("session.error_text_wp")>
								<div class="uyegirisi_1" style="text-align:center;"><font color="FF0000"><cfoutput>#session.error_text_wp#</cfoutput></font></div>
								<cfscript>
									if (isdefined("session.error_text_wp")) 
									{
										structdelete(session,"error_text_wp");
									}
								</cfscript>
							</cfif>
						</div>
					</div>
				</cfform>
			</div>
			<div id="bireysel" class="member_login_21" style="display: none">
				<!--- bireysel --->
				<cfform action="#url_link##request.self#?fuseaction=home.act_login" method="post" name="login_">
					<input type="hidden" value="1" name="consumer_login" id="consumer_login" />
					<cfif url.fuseaction contains 'member_login'>
						<input type="hidden" name="referer" id="referer" value="<cfoutput>#request.self#?fuseaction=worknet.list_training</cfoutput>" />
					<cfelse>
						<cfset urlVars = ''>
						<cfloop collection='#url#' item='k'>
							<cfif (k neq 'FUSEACTION') and (k neq 'setLang')>
								<cfset urlVars = urlVars & "&" & k & "=" & URLEncodedFormat(url[k])>
							</cfif>
						</cfloop>
						<input type="hidden" name="referer" id="referer" value="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction##urlVars#</cfoutput>" />
					</cfif>
					<div class="uyegirisi" style="width:910px;">
						<div class="uyegirisi_" style="width:500px;">
							<div class="uyegirisi_1">
								<span style="float:left;display:table-cell;width:106px;font-size: 14px;"><cf_get_lang_main no='16.E-Posta'></span>
								<cfsavecontent variable="message"><cf_get_lang no="6.Kullanıcı Adı Girmelisiniz">!</cfsavecontent>
								<span style="display:table-cell;">
									<cfif isdefined('cookie.username_consumer')>
										<cfinput type="text" name="username" value="#cookie.username_consumer#" required="yes" message="#message#" autocomplete="off" class="txt_1">
									<cfelse>
										<cfinput type="text" name="username"  required="yes" message="#message#" autocomplete="off" class="txt_1">
									</cfif>
								</span>
							</div>
							<div class="uyegirisi_1">
								<span style="float:left;width:106px;font-size: 14px;"><cf_get_lang_main no='140.Sifre'></span>
								<cfsavecontent variable="message"><cf_get_lang no="7.Şifre Girmelisiniz">!</cfsavecontent>
								<span style="display:table-cell;">
									<cfif isdefined('cookie.password_consumer')>
										<cfinput type="password" name="password" value="#cookie.password_consumer#" required="yes" message="#message#" autocomplete="off" class="txt_1">
									<cfelse>
										<cfinput type="password" name="password" required="yes" message="#message#" autocomplete="off" class="txt_1">
									</cfif>
								</span>
							</div>
							<div class="uyegirisi_1" id="rememberMeContainer">
								<span><input type="checkbox" name="remember_me_consumer" id="remember_me_consumer" value="1" checked="checked" style="float:left;">
								<samp style="margin-left:5px; margin-top:1px;font-size: 16px;"><cf_get_lang no="104.Beni Hatırla"></samp></span>
							</div>	
							<div class="uyegirisi_1">
								<cfsavecontent variable="message"><cf_get_lang_main no="142.Giriş"></cfsavecontent>
								<input class="btn_1" type="submit" value="<cfoutput>#message#</cfoutput>"/>
								<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=home.popup_send_password&is_extranet=1','small');"><cf_get_lang_main no ='2036.Şifremi Unuttum'></a>
							</div>
							<div class="uyegirisi_1">
								<a href="<cfoutput>#url_link##request.self#</cfoutput>?fuseaction=worknet.add_consumer" style="padding-right:98px;"><cf_get_lang no="126.Üye Olmak İstiyorum"></a>
							</div>				
							<cfif isDefined("session.error_text_wp")>
								<div class="uyegirisi_1" style="text-align:center;"><font color="FF0000"><cfoutput>#session.error_text_wp#</cfoutput></font></div>
								<cfscript>
									if (isdefined("session.error_text_wp")) 
									{
										structdelete(session,"error_text_wp");
									}
								</cfscript>
							</cfif>
						</div>
					</div>
				</cfform>
			</div>
		</div>
	</div>
</cfif>
<cfif isdefined("session.ep.userid")>
	<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>
<cfelseif isdefined("session.pp.userid")>
    <cfoutput><a href="#request.self#?fuseaction=worknet.detail_company&cpid=#session.pp.company_id#">#session.pp.company_nick# - #session.pp.name# #session.pp.surname#</a></cfoutput>
<cfelseif isdefined("session.ww.userid")>
    <cfoutput>
		<b><a href="#request.self#?fuseaction=worknet.detail_consumer&consumer_id=#session.ww.userid#" style="float:none !important;">#session.ww.name# #session.ww.surname#</a><b><br />
		Bu sayfaya erişmek için firma çalışanı olarak giriş yapmanız gerekmektedir!
	</cfoutput>
	<cfif isdefined("session.error_text_wp")>
		<br />
		<cfoutput>#session.error_text_wp#</cfoutput>
		<cfscript>
			structdelete(session,"error_text_wp");
		</cfscript>
	</cfif>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
