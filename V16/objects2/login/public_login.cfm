<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.public_login_url") and len(attributes.public_login_url)>
	<cfset url_ = "#attributes.public_login_url#">
<cfelse>
	<cfset url_ = "#request.self#?fuseaction=home.act_login">
</cfif>
<!--- Üye Giriş Bölümü --->
<cfif not isdefined("session.ww.userid")>
	<cfform action="#url_#" method="post" name="login_">
		<table border="0" style="width:100%;">
        	<cfif isDefined('attributes.referer_adress') and len(attributes.referer_adress)>
            	<cfset direct_page = 'fuseaction=#attributes.referer_adress#'>
            <cfelseif isdefined('attributes.public_page_url') and len(attributes.public_page_url)>
            	<cfset direct_page = 'fuseaction=#attributes.public_page_url#'>
			<cfelse>
				<cfset direct_page = '#cgi.query_string#'>
            </cfif>
			<input type="hidden" name="referer" id="referer" value="<cfoutput>#direct_page#</cfoutput>">
			<cfif isdefined('attributes.public_block_url') and len(attributes.public_block_url)>
				<input type="hidden" name="block_referer_page" id="block_referer_page" value="<cfoutput>#attributes.public_block_url#</cfoutput>">
			</cfif>
			<tr>
				<td colspan="2" align="center">&nbsp;</td>
			</tr>
			<cfif isdefined('attributes.is_alert_message') and attributes.is_alert_message eq 1>
				<tr>
					<td colspan="2" style="text-align:center"><span id="ctl00">Aşağıdaki kutulara <strong>e-mail adresinizi/ kullanıcı adınızı ve şifrenizi </strong>yazarak giriş yapabilirsiniz.</span> </td>
				</tr>
			</cfif>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td style="width:100px;" align="left"><cf_get_lang_main no='139.Kullanıcı Adi'> :</td>
				<td><cfsavecontent variable="message"><cf_get_lang no="6.Kullanıcı Adı Girmelisiniz">!</cfsavecontent>
					<cfif isdefined('cookie.cons_username')>
						<cfinput type="text" name="username" id="username" value="#cookie.cons_username#" style="width:130px;" required="yes" message="#message#" autocomplete="off">
					<cfelse>
						<cfinput type="text" name="username" id="username" value="" style="width:130px;" required="yes" message="#message#" autocomplete="off">
					</cfif>
				</td>
			</tr>
			<tr>
				<td align="left"><cf_get_lang_main no="140.Şifre"> :</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no="7.Şifre Girmelisiniz">!</cfsavecontent>
					<cfif isdefined('cookie.cons_password')>
						<cfinput type="password" name="password" id="password" value="#cookie.cons_password#" style="width:130px;" required="yes" message="#message#" autocomplete="off">
					<cfelse>
						<cfinput type="password" name="password" id="password" value="" style="width:130px;" required="yes" message="#message#" autocomplete="off">
					</cfif>
				</td>
			</tr>
			 <tr style="height:35px;">
				<td></td>
				<td>
					<input type="checkbox" name="remember_me" id="remember_me" value="1" checked="checked" style="float:left;margin-top:-3px;">
					Beni Hatırla
				</td>
			</tr>
			<tr>
				<td></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no="142.Giriş"></cfsavecontent>
					<!---<cf_workcube_buttons 
						is_upd='0' 
						insert_info='#message#'
						is_cancel='0'
                        class="button"
						insert_alert=''> --->
                    <input type="submit" name="submit" value="<cfoutput>#message#</cfoutput>">
				</td>
			</tr>
			<cfif isDefined("session.error_text_ww")>
				<tr>
					<td colspan="2"><font color="FF0000"><cfoutput>#session.error_text_ww#</cfoutput></font></td>
				</tr>
				<cfscript>
					if (isdefined("session.error_text_ww")) 
					{
						structdelete(session,"error_text_ww");
					}
				</cfscript>
			</cfif>
			<cfif isdefined('attributes.is_password_sms') and attributes.is_password_sms eq 1>
				<cfset fuseact = 'popup_send_sms'>
			<cfelse>
				<cfset fuseact = 'popup_send_password'>
			</cfif>
			<tr>
				<td></td>
				<td align="left"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=home.#fuseact#</cfoutput>&is_consumer=1<cfif isdefined("attributes.is_password_info") and attributes.is_password_info eq 1>&is_password_info=1</cfif>','small');">>> <cf_get_lang_main no="2036.Şifremi Unuttum"></a></td>
			</tr>
			<tr>
				<td></td>
				<td align="left"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.add_member">>> <cf_get_lang no="126.Üye Olmak İstiyorum"></a></td>
			</tr>
		</table>
    	<br/>
	</cfform>
	<script>
        document.getElementById('username').focus()
    </script>
<cfelse>
	<cfif isdefined("session.ww.userkey")>
		<table align="center">
			<tr>
				<td align="center"><b><cf_get_lang_main no='139.Kullanici Adi'> :</b>
					<cfoutput><a href="#request.self#?fuseaction=objects2.me" class="tableyazi">#session.ww.name# #session.ww.surname#</a></cfoutput>
				</td>
			</tr>
		</table>
	</cfif>
</cfif>
<br/>

