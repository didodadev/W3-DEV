<cfparam name="attributes.mailbox_id" default="">
<cfset ID = "">
<cfset SERVER_ADDRESS = "">
<cfset USERNAME = "">
<cfset PASSWORD = "">
<cfset PORT = "">
<cfset PROTOCOL = "">

<cfif attributes.mailbox_id is "">
	<cfabort>
</cfif>

<cfquery name="exchange_settings" datasource="#dsn#">
	SELECT
		SETTING_ID,
		SERVER_ADDRESS,
		USERNAME,
		PASSWORD,
		PORT,
		PROTOCOL
	FROM
		EXCHANGE_SETTINGS
	WHERE 
		SETTING_ID = #attributes.mailbox_id#
</cfquery>
<cfif exchange_settings.recordcount gt 0>
	<cfloop query="exchange_settings">
		<cfset ID = "#SETTING_ID#">
		<cfset SERVER_ADDRESS = "#SERVER_ADDRESS#">
		<cfset USERNAME = "#USERNAME#">
		<cfset PASSWORD = "#PASSWORD#">
		<cfset PORT = "#PORT#">
		<cfset PROTOCOL = "#PROTOCOL#">
	</cfloop> 
</cfif>
<cfoutput>
	<cf_box title="Exchange Server Mail Ayarları" id="upd_exchange_settings_" style="position:absolute; width:300px; left:13px;">   
		<cfform name="exchange_settings_frm" action="#request.self#?fuseaction=correspondence.upd_mail_settings_exchange">	
			 <input type="hidden" name="mailbox_id" id="mailbox_id" value="#attributes.mailbox_id#" />
			 <table cellspacing="1" cellpadding="2">
				<tr>
					<td width="132"><cf_get_lang dictionary_id="30639.Server Adresi">*</td>
				  <td width="144">
				  <cfinput type="text" name="SERVER_ADDRESS" value="#SERVER_ADDRESS#"  maxlength="50"/></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="31109.Mail Adresi">*</td>
					<td><cfinput type="text" name="USERNAME" value="#USERNAME#"  maxlength="50"/></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="57552.Şifre">*</td>
					<td><cfinput type="password" name="PASSWORD" value="#PASSWORD#"  maxlength="50"/></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="54829.Protokol"></td>
					<td>
						<select name="PROTOCOL" id="PROTOCOL">
							<option value="HTTP" <cfif PROTOCOL is "HTTP">selected="selected"</cfif>>HTTP</option>
							<option value="HTTPS" <cfif PROTOCOL is "HTTPS">selected="selected"</cfif>>HTTPS</option>
						</select>
					</td>
				</tr>		
				<tr>
					<td>Port</td>
					<td><cfinput type="text" name="PORT" value="#PORT#"  maxlength="43"/></td>
				</tr>
				<tr>
					<td colspan="2" style="text-align:right;">							
						<cf_workcube_buttons is_upd='1' is_del='1' add_function='kontrol()' delete_page_url="#request.self#?fuseaction=correspondence.del_mail_settings_exchange&mailbox_id=#ID#">
					</td>					
			</table>
			</div>
		</cfform>
	</cf_box>
</cfoutput>
<script type="text/javascript">
function kontrol()
{
	if(document.exchange_settings_frm.USERNAME.value==""){
		alert("<cf_get_lang dictionary_id='30486.Kullanıcı Adınızı Girmediniz'>!");
		return false;
	}
	
	if(document.exchange_settings_frm.USERNAME.value.length < 3){
		alert("<cf_get_lang dictionary_id='30484.Kullanıcı Adınızı Yanlış Girdiniz'> <cf_get_lang dictionary_id='51678.En Az 3 Karakter Girmelisiniz'>..");
		return false;
	}
	
	if(document.exchange_settings_frm.PASSWORD.value==""){
		alert("<cf_get_lang dictionary_id='30481.Şifrenizi Girmediniz'>!");
		return false;
	}
	
	if(document.exchange_settings_frm.PASSWORD.value.length < 6){
		alert("<cf_get_lang dictionary_id='30475.Şifrenizi Yanlış Girdiniz'>!<cf_get_lang dictionary_id='30473.En Az 6 Karakter Girmelisiniz'>...");
		return false;
	}	
}
</script>
