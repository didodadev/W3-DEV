<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  	<tr>
    	<td class="headbold"><cf_get_lang no="266.Database aktarımı"></td>
  	</tr>
</table>


<table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
	<tr class="color-row">
		<td>
		<table border="0">
		<cfform name="db_import" method="post" action="#request.self#?fuseaction=settings.emptypopup_import_table_column">
			<tr>
				<td class="txtbold" colspan="2"><cf_get_lang_main no='1681.XML İmport Et'></td>
			</tr>
			<tr>
				<td height="35" colspan="2">
			  		<cfsavecontent variable="message">csv import et</cfsavecontent>
			  		<cf_workcube_buttons is_upd='0' insert_info='#message#'>
			  	</td>
			</tr>
			<tr>
				<td colspan="2" style="color:red">
					Bu İşlem custom tag xml tablo ve kolon  dosyalarını import eder ve wrk_object_information ve wrk_column_information tablolarını yedekler.
				</td>
			</tr>
		</cfform>
		  	<tr>
				<td colspan="2" height="75">&nbsp;</td>
		  	</tr>
		<cfif cgi.http_host eq 'ep.workcube'>
		<cfform name="db_import" method="post" action="#request.self#?fuseaction=settings.emptypopup_export_table_column">
			<tr>
				<td class="txtbold" colspan="2"><cf_get_lang no='694.XML Belgesi Oluştur'></td>
			</tr>
			<tr>
				<td>
					<input type="checkbox" name="main" id="main" value="<cfoutput>#dsn#</cfoutput>" checked="checked" disabled="disabled" />Main <br />
					<input  type="checkbox" name="product" id="product" value="<cfoutput>#dsn1#</cfoutput>" checked="checked" disabled="disabled" />Product<br />
					<input type="checkbox" name="donem_db" id="donem_db" checked="checked" value="<cfoutput>#dsn2#</cfoutput>" />Dönem <br />	
					<input type="checkbox" name="sirket_db" id="sirket_db" checked="checked" value="<cfoutput>#dsn2#</cfoutput>"  />Şirket <br />
					
				</td>
			</tr>
			<tr>
				<td height="35" class="headbig"  colspan="2">
					<cfsavecontent variable="message">csv dosyası oluştur.</cfsavecontent>
				  	<cf_workcube_buttons is_upd='0' insert_info='#message#'>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="color:red">Bu İşlem custom tag xml deki tablo ve kolon  dosyalarını yedekler yenisini oluşturur. </td>
			</tr>
		  </cfform>
		</cfif>
		</table>
	  	</td>
	</tr>
</table>

