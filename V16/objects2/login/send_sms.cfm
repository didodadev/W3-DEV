<cfinclude template="../../member/query/get_mobilcat.cfm">
<table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%" bgcolor="#FFFFFF">
	<tr hegiht="35">
		<td class="headbold">&nbsp;&nbsp;<cf_get_lang_main no='814.Şifre Hatırlatıcı'></td>
	</tr>
 	<tr>
		<td valign="top">
	  		<cfform name="arrange_sms_pass" action="#request.self#?fuseaction=objects2.popup_send_sms_arrangement" method="post">
				<table width="90%" align="center" border="0">
					<tr height="22">
						<td>TC Kimlik Numaranız *</td>
						<td><cf_wrkTcNumber fieldId="tc_identity_no" tc_identity_required="1" width_info='150'></td>
					</tr>
					<tr height="22">
						<td>Cep Telefonunuz *</td>
						<td>
							<select name="mobilcat_id" id="mobilcat_id" style="width:45px;" tabindex="2">
								<cfoutput query="get_mobilcat">
									<option value="#mobilcat#">#mobilcat#</option>
								</cfoutput>
							</select>
							<cfsavecontent variable="message">Lütfen Mobil Telefon Numaranızı Giriniz!</cfsavecontent>
							<cfinput type="text" name="mobile_phone" id="mobile_phone" maxlength="7" validate="integer" message="#message#" tabindex="2" onKeyUp="isNumber(this);" style="width:100px;" required="yes" value="">
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no='1331.Gonder'></cfsavecontent>
								<cf_workcube_buttons 
								is_upd='0' 
								insert_info='#message#' 
								is_cancel='0'
								insert_alert=''>
						</td>
					</tr>
				</table>
	  		</cfform>
		</td>
	</tr> 
</table>
