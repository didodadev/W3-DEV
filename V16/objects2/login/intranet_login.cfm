<!--- inranet Giriş Bölümü --->
<cfif isdefined("attributes.intranet_login_url") and len(attributes.intranet_login_url)>
	<cfset url_ = "#attributes.intranet_login_url#">
<cfelse>
	<cfset this_intranet_url_ = listfindnocase(server_companies,default_company_id_,';')>
	<cfset this_intranet_url_ = listgetat(employee_url,this_intranet_url_,';')>
	<cfset url_ = "http://#this_intranet_url_#/#request.self#?fuseaction=home.act_login">
</cfif>
<cfif not isdefined("session.ep.userid")>
	<table>
	<cfform action="#url_#" method="post" name="login_">
	  <tr>
		<td><cf_get_lang_main no='518.Kullanıcı'>*</td>
		<td>
			<cfsavecontent variable="message"><cf_get_lang no='6.Kullanıcı Adı Girmelisiniz'></cfsavecontent>
			<cfinput type="text" name="username" style="width:100px;" required="yes" message="#message#!">
		</td>
	  </tr>
	  <tr>
		<td><cf_get_lang_main no='140.Şifre'>*</td>
		<td>
			<cfsavecontent variable="message"><cf_get_lang no='7.Şifre Girmelisiniz'></cfsavecontent>
			<cfinput type="password" name="password" style="width:100px;" required="yes" message="#message#!">
		</td>
	  </tr>
	  <tr>
		<td></td>
		<td>
			<cf_workcube_buttons 
				is_upd='0' 
				insert_info='Giriş'
				is_cancel='0'
				insert_alert=''>
		</td>
	  </tr>
	  <cfif isDefined("session.error_text")>
		<tr>
		  <td colspan="2"><font color="FF0000"><cfoutput>#session.error_text#</cfoutput></font></td>
		</tr>
		<cfscript>
			if (isdefined("session.error_text")) 
				{
				structdelete(session,"error_text");
				}
		</cfscript>
	  </cfif>
	<tr>
		<td colspan="2"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_send_password&is_intranet=1&<cfif isdefined("attributes.is_password_info") and attributes.is_password_info eq 1>&is_password_info=1</cfif>','small');">>> <cf_get_lang no="9.Şifremi Unuttum"></a></td>
	</tr>
	</cfform>
	</table>
</cfif>
<br/>

