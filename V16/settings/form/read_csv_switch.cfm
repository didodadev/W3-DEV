<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  	<tr>
    	<td class="headbold"><cf_get_lang no='143.Fuseaction Export Import'></td>
  	</tr>
</table>
<cfif cgi.http_host eq 'ep.workcube'>
<table width="98%" align="center" cellpadding="2" cellspacing="1" border="0" class="color-border">
<cfform name="formupdate" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_switch_version">
<input type="hidden" name="is_submitted" id="is_submitted" value="1" />
	<tr>
		<td valign="top" class="color-row">
			<table>
				<tr>
					<td><b>Versiyon Bilgisi Güncelle</b></td>
				</tr>
				<tr></tr>
				<tr>
					<td height="35"><cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='Güncelle'></td>
				</tr>
				<tr>
					<td>Bu İşlem Databasedeki aktif fuseactionların versiyonunu <cfoutput>#workcube_version#</cfoutput> olarak günceller</td>
				</tr>
			</table>
			<br />
			<br />
		</td>
	</tr>
</cfform>
</table>
<br />
</cfif>

<table width="98%" align="center" cellpadding="2" cellspacing="1" border="0" class="color-border">
<cfform name="formexport" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=settings.emptypopup_export_switch">
	<input type="hidden" name="is_submitted" id="is_submitted" value="1" />
	<tr>
		<td valign="top" class="color-row">
			<table>
				<tr>
					<td><b>Switch Export</b></td>
				</tr>
				<tr></tr>
				<tr>
					<td height="35"><cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='Export'> </td>
				</tr>
				<tr>
					<td>Bu İşlem Custom Tags Folder'ındaki son wrk_switchs.csv'in yedeğini alarak yeni bir wrk_switchs.csv dosyası oluşturur.</td>
				</tr>
			</table>
			<br />
			<br />
		</td>
	</tr>
</cfform>
</table>
<br />
<!--- EP de pasif switchlerin silinmemesi için eklendi. Pasif Fuseactionlar Ep de olmalı LS 20110423
<cfif cgi.http_host neq 'ep.workcube'> --->
	<table width="98%" align="center" cellpadding="2" cellspacing="1" border="0" class="color-border">
	<cfform name="formimport" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=settings.emptypopup_import_switch">
	<input type="hidden" name="is_submitted" id="is_submitted" value="1" />
		<tr>
			<td valign="top" class="color-row">
				<table>
					<tr>
						<td><b>Switch Import</b></td>
					</tr>
					<tr></tr>
					<tr>
						<td height="35"><cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='Import'></td>
					</tr>
					<tr>
						<td>Bu İşlem Custom Tags Folder'ındaki wrk_switchs.csv dosyasını Database import eder</td>
					</tr>
				</table>
				<br />
				<br />
			</td>
		</tr>
	</cfform>
	</table>
<!--- </cfif> --->
