<cfif isdefined("attributes.partner_login_url") and len(attributes.partner_login_url)>
	<cfset url_ = "#attributes.partner_login_url#">
	<cfset url_ = "#attributes.partner_login_url#/#request.self#?fuseaction=home.act_login">
<cfelse>
	<cfset this_partner_url_ = listfindnocase(partner_companies,default_company_id_,';')>
	<cfset this_partner_url_ = listgetat(partner_url,this_partner_url_,';')>
	<cfset url_ = "http://#this_partner_url_#/#request.self#?fuseaction=home.act_login">
</cfif>
<table width="98%">
	<cfform action="#url_#" method="post" name="login">
		<input type="hidden" name="referer" id="referer" value="<cfif isdefined('attributes.login_address_url') and len(attributes.login_address_url)><cfoutput>#attributes.login_address_url#</cfoutput><cfelseif isdefined('attributes.fuseaction') and len(attributes.fuseaction) and attributes.fuseaction neq 'home.login' and attributes.fuseaction neq 'objects2.user_friendly'><cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput></cfif><cfif isdefined('attributes.stock_id')>&sid=<cfoutput>#attributes.stock_id#</cfoutput></cfif><cfif isdefined('attributes.product_id')>&product_id=<cfoutput>#attributes.product_id#</cfoutput></cfif>">
		<tr>
			<td><cf_get_lang_main no ='146.Üye No'> *</td>
			<td><cfsavecontent variable="message"><cf_get_lang no ='127.Üye No Girmelisiniz'>!</cfsavecontent>
				<cfinput type="text" name="member_code" id="member_code" required="yes" style="width:100px;" message="#message#" passthrough="autocomplete=off" maxlength="20" value="">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no ='518.Kullanıcı'> *</td>
			<td><cfsavecontent variable="message"><cf_get_lang no ='6.Kullanıcı Adı Girmelisiniz'>!</cfsavecontent>
				<cfinput type="text" name="username" style="width:100px;" required="yes" message="#message#">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no ='140.Şifre'> *</td>
			<td><cfsavecontent variable="message"><cf_get_lang no ='7.Şifre Girmelisiniz'>!</cfsavecontent>
				<cfinput type="password" name="password" style="width:100px;" required="yes" message="#message#">
			</td>
		</tr>
		<tr>
			<td></td>
			<td>
				<cfsavecontent variable="message"><cf_get_lang_main no ='142.Giriş'></cfsavecontent>
				<cf_workcube_buttons is_upd='0' insert_info='#message#' is_cancel='0' insert_alert=''>
			</td>
		</tr>
		<cfif isDefined("session.error_text_pp")>
			<tr>
				<td colspan="2"><font color="#FF0000"><cfoutput>#session.error_text_pp#</cfoutput></font></td>
			</tr>
			<cfscript>
				if (isdefined("session.error_text_pp")) 
				{
					structdelete(session,"error_text_pp");
				}
			</cfscript>
		</cfif>
		<tr>
			<td colspan="2"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=home.popup_send_password&is_extranet=1<cfif isdefined('attributes.partner_login_url') and len(attributes.partner_login_url)>&partner_login_url=<cfoutput>#attributes.partner_login_url#</cfoutput></cfif>','small');">>><cf_get_lang_main no='2036.Şifremi Unuttum'></a></td>
		</tr>
		<cfif isdefined('attributes.partner_add_member') and attributes.partner_add_member eq 1>
			<tr>
				<td colspan="2"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.add_member_company">>><cf_get_lang no ='126.Üye Olmak İstiyorum'></a></td>
			</tr>
		</cfif>
	</cfform>
</table>
