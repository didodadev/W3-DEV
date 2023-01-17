<!---
    File: add_budget_file.cfm
    Folder: V16\budget\form\
	Controller:
    Author:
    Date:
    Description:
        Bütçe planlama fişi excel ile aktarım sayfası
    History:
		2019-12-24 17:34:31 Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com
		Proje ID alanı eklendi
    To Do:

--->

<cfsetting showdebugoutput="no">
<cfsavecontent variable="title">
	<cf_get_lang dictionary_id="57515.Dosya Ekle">
</cfsavecontent>
<cfoutput>
	<cf_box title="#title#" closable="1" draggable="1">
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
				<cf_get_lang dictionary_id="44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır .Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır"> .
				<cf_get_lang dictionary_id="56627.Belgede toplam 11 alan olacaktır alanlar sırası ile">;<br/>
				</td>
			</tr>
			<tr>
				<td colspan="2">1 - <cf_get_lang dictionary_id="57742.Tarih"></td>
			</tr>
			<tr>
				<td colspan="2">2 - <cf_get_lang dictionary_id="57629.Açıklama">*</td>
			</tr>
			<tr>
				<td colspan="2">3 - <cf_get_lang dictionary_id="56643.Masraf/Gelir Merkezi ID">*</td>
			</tr>
			<tr>
				<td colspan="2">4 - <cf_get_lang dictionary_id="56648.Bütçe Kalemi ID">*</td>
			</tr>
			<tr>
				<td colspan="2">5 - <cf_get_lang dictionary_id="58811.Muhasebe Kodu"></td>
			</tr>
			<tr>
				<td colspan="2">6 - <cf_get_lang dictionary_id="56657.Aktivite Tipi ID"> </td>
			</tr>
			<tr>
				<td colspan="2">7 - <cf_get_lang dictionary_id="56658.İş Grubu ID"> </td>
			</tr>
			<tr>
				<td colspan="2">8 - <cf_get_lang dictionary_id="56661.Fiziki Varlık ID"> </td>
			</tr>
			<tr>
				<td colspan="2">9 - <cf_get_lang dictionary_id="56662.Kurumsal Üye Kodu veya Özel Kod"></td>
			</tr>
			<tr>
				<td colspan="2">10 - <cf_get_lang dictionary_id="56665.Bireysel Üye Kodu veya Özel Kod"></td>
			</tr>
			<tr>
				<td colspan="2">11 - <cf_get_lang dictionary_id="58677.Gelir"></td>
			</tr>
			<tr>
				<td colspan="2">12 - <cf_get_lang dictionary_id="58678.Gider"></td>
			</tr>
			<tr>
				<td colspan="2">13 - <cf_get_lang dictionary_id="57416.Proje"> ID</td>
			</tr>
		</table>
	</cf_box>
</cfoutput>
<script type="text/javascript">
	function ekle_form_action()
	{
		if(document.getElementById('uploaded_file').value == "")
		{
			alert("<cf_get_lang dictionary_id='54246.Belge Seçmelisiniz'>!");
			return false;
		}
		add_budget_plan.action = "<cfoutput>#request.self#?fuseaction=budget.list_plan_rows&event=add&is_from_file=1<cfif isdefined("attributes.budget_id")>&budget_id=#attributes.budget_id#</cfif></cfoutput>";
	}
</script>