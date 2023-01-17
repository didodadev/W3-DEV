<cfsetting showdebugoutput="no">
<cfoutput>
	<iframe src="" width="1" height="1" style="display:none;" name="import_file_frame" id="import_file_frame"></iframe>
	<cfform name="upload_form_page" enctype="multipart/form-data" action="#request.self#?fuseaction=cheque.emptypopup_get_payroll_bank_guaranty_from_file" target="import_file_frame">
        <input type="hidden" name="cheque_currency_id" id="cheque_currency_id" value="#attributes.cheque_currency_id#" />
		<cf_box title="Dosya Ekle" style="width:280px;" body_style="width:280px;height:330px" closable="1">
			<table border="0" align="left">
				<tr>
					<td nowrap><cf_get_lang_main no='56.Belge'> *</td>
					<td>
						<input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;" onClick="accountControl()">
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
					<cf_get_lang dictionary_id="56451.Belgede toplam 14 alan olacaktır">. <cf_get_lang dictionary_id="56452.İşaretli alanlar zorunludur. Alanlar sırası ile şu şekilde olmalıdır">;<br/>
					</td>
				</tr>
				<tr>
					<td colspan="2">1 - <cf_get_lang dictionary_id="58182.Portföy No"> *</td>
				</tr>
				<tr>
					<td colspan="2">2 - <cf_get_lang dictionary_id="50220.Çek No"> *</td>
				</tr>
				<tr>
					<td colspan="2">3 - <cf_box dictionary_id="50973.İşlem Para Birimi"> *</td>
				</tr>
				<tr>
					<td colspan="2">4 - <cf_get_lang dictionary_id="57881.Vade Tarihi"> *</td>
				</tr>
				<tr>
					<td colspan="2">5 - <cf_get_lang dictionary_id="50300.Cari Hesap Çeki"></td>
				</tr>
				<tr>
					<td colspan="2">6 - <cf_get_lang dictionary_id="57521.Banka"></td>
				</tr>
				<tr>
					<td colspan="2">7 - <cf_get_lang dictionary_id="58933.Banka Şubesi"></td>
				</tr>
				<tr>
					<td colspan="2">8 - <cf_get_lang dictionary_id="58178.Hesap No"></td>
				</tr>
				<tr>
					<td colspan="2">9 - <cf_get_lang dictionary_id="57789.Özel Kod"></td>
				</tr>
				<tr>
					<td colspan="2">10 - <cf_get_lang dictionary_id="58762.Vergi Dairesi"></td>
				</tr>
				<tr>
					<td colspan="2">11 - <cf_get_lang dictionary_id="57752.Vergi No"></td>
				</tr>
				<tr>
					<td colspan="2">12 - <cf_get_lang dictionary_id="58181.Ödeme Yeri"></td>
				</tr>
				<tr>
					<td colspan="2">13 - <cf_get_lang dictionary_id="58180.Borçlu"></td>
				</tr>
				<tr>
					<td colspan="2">14 - <cf_get_lang dictionary_id="58970.Ciro Eden"></td>
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
	function accountControl()
	{
		if(document.getElementById('account_id').value == "")
		{
			alert("<cf_get_lang dictionary_id='58940.Banka Seçiniz'>!");
			return false;
		}
	}
</script>
