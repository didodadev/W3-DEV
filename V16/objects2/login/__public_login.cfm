<cfsetting showdebugoutput="no">
<!--- Üye Giriş Bölümü --->
<cfif isdefined("attributes.public_login_url") and len(attributes.public_login_url)>
	<cfset url_ = "#attributes.public_login_url#">
<cfelse>
	<cfset url_ = "#request.self#?fuseaction=home.act_login">
</cfif>
<cfif not isdefined("session.ww.userid")>
	<table border="0" style="width:100%;">
		<cfform action="#url_#" method="post" name="login_">
			<input type="hidden" name="referer" id="referer" value="<cfif isdefined('url.fuseaction') and len(url.fuseaction) and url.fuseaction neq 'home.login'><cfoutput>#request.self#?fuseaction=#url.fuseaction##page_code#</cfoutput><cfelse><cfoutput>#request.self#?fuseaction=objects2.welcome</cfoutput></cfif>">
			<input type="hidden" name="page_url" id="page_url" value="<cfif isdefined('attributes.public_page_url') and len(attributes.public_page_url)><cfoutput>#attributes.public_page_url#</cfoutput></cfif>">
			<cfif isdefined('attributes.public_block_url') and len(attributes.public_block_url)>
				<input type="hidden" name="block_referer_page" id="block_referer_page" value="<cfoutput>#attributes.public_block_url#</cfoutput>">
			</cfif>
			<tr>
				<td colspan="2" align="center">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2" style="text-align:center"><SPAN id="ctl00">Aşağıdaki kutulara <STRONG>e-mail adresinizi/ kullanıcı adınızı ve şifrenizi </STRONG>yazarak giriş yapabilirsiniz.</SPAN> </td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td style="width:100px;"><cf_get_lang no="1.Kullanıcı"> :</td>
				<td><cfsavecontent variable="message"><cf_get_lang no="6.Kullanıcı Adı Girmelisiniz">!</cfsavecontent>
					<cfinput type="text" name="username" id="username" style="width:130px;" required="yes" message="#message#" autocomplete="off">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no="140.Şifre"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no="7.Şifre Girmelisiniz">!</cfsavecontent>
					<cfinput type="password" name="password" style="width:130px;" required="yes" message="#message#" autocomplete="off">
				</td>
			</tr>
			<tr>
				<td></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no="142.Giriş"></cfsavecontent>
					<cf_workcube_buttons 
						is_upd='0' 
						insert_info='#message#'
						is_cancel='0'
						insert_alert=''>
				</td>
			</tr>
			<cfif isDefined("session.error_text_ww")>
				<tr>
					<td colspan="2"><font color="FF0000"><cfoutput>#session.error_text_ww#</cfoutput></font></td>
				</tr>
				<!------<cfscript>
					if (isdefined("session.error_text_ww")) 
					{
						structdelete(session,"error_text_ww");
					}
					
				</cfscript>--->
			</cfif>
			<tr>
				<td colspan="2"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_send_password&is_consumer=1<cfif isdefined("attributes.is_password_info") and attributes.is_password_info eq 1>&is_password_info=1</cfif>','small');">>> <cf_get_lang no="9.Şifremi Unuttum"></a></td>
			</tr>
			<tr>
				<td colspan="2"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.add_member">>> <cf_get_lang no="126.Üye Olmak İstiyorum"></a></td>
			</tr>
		</cfform>
	</table>
    <br/>
	<script>
        document.getElementById('username').focus()
    </script>
<cfelse>
	<cfif isdefined("session.ww.userkey")>
		<table align="center">
			<tr>
				<td align="center"><b><cf_get_lang no="1.Kullanıcı"> :</b>
					<cfoutput><a href="#request.self#?fuseaction=objects2.me" class="tableyazi">#session.ww.name# #session.ww.surname#</a></cfoutput>
				</td>
			</tr>
		</table>
	</cfif>
</cfif>


