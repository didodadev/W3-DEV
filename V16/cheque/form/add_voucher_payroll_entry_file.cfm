<cfsetting showdebugoutput="no">
<cfoutput>
	<iframe src="" width="1" height="1" style="display:none;" name="import_file_frame" id="import_file_frame"></iframe>
	<cfform name="upload_form_page" enctype="multipart/form-data" action="#request.self#?fuseaction=cheque.emptypopup_get_voucher_payroll_entry_from_file" target="import_file_frame">
    	<input type="hidden" name="cash_currency" id="cash_currency" value="#listlast(attributes.cash_currency,';')#" />
		<cf_box title="Dosya Ekle" style="width:280px;" body_style="width:280px;height:330px">
			<table border="0" align="left">
				<tr>
					<td nowrap><cf_get_lang_main no='56.Belge'> *</td>
					<td>
						<input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;">
					</td>
				</tr>
				<tr>
					<td></td>
					<td style="text-align:right;">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<cfsavecontent variable="message"><cf_get_lang_main no ='1303.Listele'></cfsavecontent>
						<cf_workcube_buttons insert_info='#message#' add_function='ekle_form_action()' is_cancel='0'>
					</td>
				</tr>
				<tr>
					<td colspan="2">
					<b><cf_get_lang dictionary_id="58594.Format"></b><br/>
					<cf_get_lang dictionary_id="44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır. Aktarım işlemi dosyanın 2. satırından itibaren başlar, bu yüzden birinci satırda alan isimleri olmalıdır.">
					<cf_get_lang dictionary_id="56523.Belgede toplam 7 alan olacaktır. İşaretli alanlar zorunludur. Alanlar sırası ile şu şekilde olmalıdır">;<br/>
					</td>
				</tr>
				<tr>
					<td colspan="2">1 - <cf_get_lang dictionary_id="58502.Senet No"> *</td>
				</tr>
				<tr>
					<td colspan="2">2 - <cf_get_lang dictionary_id="50973.İşlem Para Birimi"> *</td>
				</tr>
				<tr>
					<td colspan="2">3 - <cf_get_lang dictionary_id="57881.Vade Tarihi"> *</td>
				</tr>
				<tr>
					<td colspan="2">4 - <cf_get_lang dictionary_id="56524.Müşteri Senedi"></td>
				</tr>
				<tr>
					<td colspan="2">5 - <cf_get_lang dictionary_id="57789.Özel Kod"></td>
				</tr>
				<tr>
					<td colspan="2">6 - <cf_get_lang dictionary_id="58181.Ödeme Yeri"></td>
				</tr>
				<tr>
					<td colspan="2">7 - <cf_get_lang dictionary_id="58180.Borçlu"></td>
				</tr>
			</table>
		</cf_box>
	</cfform>
</cfoutput>
<script type="text/javascript">
	function ekle_form_action()
	{
		if(document.getElementById('uploaded_file').value == "")
		{
			alert("<cf_get_lang dictionary_id='54246.Belge Seçmelisiniz'>!");
			return false;
		}
	}
</script>
