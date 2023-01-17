<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  	<tr>
    	<td class="headbold"><cf_get_lang no='693.Dil Aktarım'></td>
  	</tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
	<tr class="color-row">
		<td>
		<table border="0">
		<cfform name="lang_import" method="post" action="#request.self#?fuseaction=settings.emptypopup_import_lang">
			<tr>
				<td class="txtbold" colspan="2"><cf_get_lang_main no='1681.XML İmport Et'></td>
			</tr>
			<tr>
				<td height="35" colspan="2">
			  		<cfsavecontent variable="message"><cf_get_lang_main no='1681.XML İmport Et'></cfsavecontent>
			  		<cf_workcube_buttons is_upd='0' is_cancel='0'  insert_info='#message#'>
			  	</td>
			</tr>
			<tr>
				<td colspan="2" style="color:red">
					Bu İşlem Custom Tags Folder'ındaki language.xml dosyasını import eder ve özel olarak yapılandırılmış dil ayarlamalarını da geri yükler.
				</td>
			</tr>
		</cfform>
		  	<tr>
				<td colspan="2" height="75">&nbsp;</td>
		  	</tr>
		<cfform name="lang_import" method="post" action="#request.self#?fuseaction=settings.emptypopup_export_lang">
			<tr>
				<td class="txtbold" colspan="2"><cf_get_lang no='694.XML Belgesi Oluştur'></td>
			</tr>
			<tr>
				<td>
					<cfquery name="GET_LANG" datasource="#DSN#">
						SELECT LANGUAGE_SHORT FROM SETUP_LANGUAGE
					</cfquery>
					<input type="hidden" name="langs" id="langs" value="tr">
					<cfoutput query="get_lang">
						<input type="checkbox" name="langs" id="langs" value="#language_short#" checked<cfif language_short is 'tr'> disabled</cfif>>#language_short#<br/>
					</cfoutput>
				</td>
			</tr>
			<tr>
				<td height="35" class="headbig"  colspan="2">
					<cfsavecontent variable="message"><cf_get_lang no='694.XML Belgesi Oluştur'></cfsavecontent>
				  	<cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#message#'>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="color:red">Bu İşlem Custom Tags Folder'ındaki son language.xml'in yedeğini alarak yeni bir language.xml dosyası oluşturur.</td>
			</tr>
		  </cfform>
		</table>
	  	</td>
	</tr>
</table>
