<!---<cfsetting showdebugoutput="no">--->
<cfoutput>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="57515.Dosya Ekle"></cfsavecontent>
	<cf_box title="#message#" style="width:280px;" body_style="width:280px;height:200px" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<table border="0" align="left">
			<tr>
				<td nowrap><cf_get_lang dictionary_id='57468.Belge'> *</td>
				<td>
					<input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;">
				</td>
			</tr>
			<tr>
				<td></td>
				<td style="text-align:right;">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58715.Listele'></cfsavecontent>
					<cf_workcube_buttons insert_info='#message#' add_function='ekle_form_action()' is_cancel='0'>
				</td>
			</tr>
			<tr>
				<td colspan="2">
				<b><cf_get_lang dictionary_id="58594.Format"></b><br/>
				<cf_get_lang dictionary_id="44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır. Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır.">
				<cf_get_lang dictionary_id="35628.Belgede toplam 2 alan olacaktır alanlar sırası ile">;<br/>
				</td>
			</tr>
			<tr>
				<td colspan="2">1 - <cf_get_lang dictionary_id="58025.Tc Kimlik No"></td>
			</tr>
			<tr>
				<td colspan="2">2 - <cf_get_lang dictionary_id="57673.Tutar"></td>
			</tr>
		</table>
	</cf_box>
</cfoutput>
<script type="text/javascript">
	function ekle_form_action()
	{
		if(document.getElementById('uploaded_file').value == "")
		{
			alert("<cf_get_lang dictionary_id='54246.Belge Seçmelisiniz'> !");
			return false;
		}
		add_payment_request.action = "<cfoutput>#request.self#?fuseaction=ehesap.popup_add_payment_request&is_from_file=1&is_submit=0</cfoutput>";
	}
</script>


