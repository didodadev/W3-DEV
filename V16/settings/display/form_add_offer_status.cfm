<table border="0" cellpadding="2" cellspacing="0" width="100%">
<tr>
	<td height="1" bgcolor="#000000"></td>
</tr>
<tr>
	<td>
	<table border="0" cellspacing="0" cellpadding="2" width="100%">
	<tr>
		<td align="left" width="50%" class="altBaslik"><cf_get_lang no='49.Teklif Durumları'></td>
		<td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_offer_status"><cf_get_lang_main no='170.ekle'></a></td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td height="1" bgcolor="#000000"></td>
</tr>
<tr>
	<td>
	<table border="0" cellspacing="0" cellpadding="2" width="100%">
	<tr>
		<td align="left" valign="top" width="20%">
		<cfinclude template="list_offer_status.cfm">
		</td>
		<td align="left" valign="top">
			<table border="0" cellspacing="0" cellpadding="2" width="100%">
			<cfform action="#request.self#?fuseaction=settings.#XFA.submit_zone#" method="post" name="offer">
				<tr>
					<td align="left"><font color=red>*</font> 
					<cfsavecontent variable="message"><cf_get_lang no='714.Teklif Durumları girmelisiniz'></cfsavecontent>
					<cfinput type="Text" name="offerStatus" size="30" value="<cf_get_lang_main no='344.Durum'>" maxlength="20" required="Yes" message="#message#"></td>
				</tr>
				<tr>
					<td align="left">
					<cf_workcube_buttons is_upd='0'>
					</td>
				</tr>
			</cfform>
			</table>
		</td>
	</tr>
	</table>
	</td>
</tr>
</table>
