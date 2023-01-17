<cfparam name="attributes.action_type" default="0">
<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border">
  	<tr class="color-list">
		<td height="35" class="headbold"><cf_get_lang_main no="1744.Cevapla"></td>
	</tr>
<tr class="color-row" valign="top">
	<td>
	<table align="center" width="98%" cellpadding="2" cellspacing="1" border="0">
	<cfform name="add_comment" method="post" action="#request.self#?fuseaction=worknet.emptypopup_add_social_media_comment">
	<input type="hidden" name="action_section" id="action_section" value="social_media">
	<input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.sid#</cfoutput>">
	<input type="hidden" name="action_id_2" id="action_id_2" value="<cfif isdefined("attributes.action_id_2")><cfoutput>#attributes.action_id_2#</cfoutput></cfif>">
	<input type="hidden" name="action_type" id="action_type" value="<cfoutput>#attributes.action_type#</cfoutput>">					  					  					  
		<tr>
			<td>&nbsp;</td>

		</tr>
		<tr>
			<td width="75"><cf_get_lang_main no='68.konu'> *</td>
			<td>
				<cfsavecontent variable="message"><cf_get_lang_main no='647.Baslik girmelisiniz'></cfsavecontent>
				<cfinput type="text" style="width:250px;" name="note_head" required="yes" message="#message#" maxlength="75">
			</td>
		</tr>
		<tr>
			<td valign="top"><cf_get_lang_main no='55.Not'></td>
			<td valign="bottom"><textarea name="note_body" id="note_body" style="width:250px;" rows="5"></textarea></td>
		</tr>
		<tr height="35">
			<td>&nbsp;</td>
			<td><input type="submit" value="<cf_get_lang_main no='1744.Cevapla'>" /></td>
		</tr>
	</cfform>
	</table>
	</td>
</tr>
</table>
