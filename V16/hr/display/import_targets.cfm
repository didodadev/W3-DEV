<cfparam name="attributes.process_type" default="1">
<cf_form_box title="#getLang('hr',669)#">
<cfform action="" name="import_worktimes" method="post" enctype="multipart/form-data">
	<table border="0" width="100%">
		<tr>
			<td width="100"><cf_get_lang dictionary_id='57800.İşlem Tipi'>*</td>
			<td width="200">
				<select name="process_type" id="process_type" style="width:200px;" onChange="formatGoster(this.value, this.options[this.selectedIndex].text);">
					<option value="1"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					<option value="2"><cf_get_lang dictionary_id="55935.Hedef İmport"></option>
				</select>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td width="140"><cf_get_lang dictionary_id='55926.Belge Formatı'></td>
			<td><select name="file_format" id="file_format" style="width:200px;">
					<option value="UTF-8"><cf_get_lang dictionary_id='55929.UTF-8'></option>
				</select>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='57468.Belge'> *</td>
			<td><input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;;"></td>
			<td>&nbsp;</td>
		</tr>
	</table>
	<br />
	<div id="tdImport"></div>
	<cf_form_box_footer>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='56790.İmport Et'></cfsavecontent>
		<cf_workcube_buttons is_upd='0'insert_info='#message#' is_cancel='0' add_function='import_et()'>
	</cf_form_box_footer>
</cfform>
</cf_form_box>
<div id="tanimlar" style="display:none;">
	<div id="td7">
        <strong><cf_get_lang dictionary_id="55935.Hedef İmport"></strong><br /><br />
        <cf_get_lang dictionary_id="44951.Bu belgede olması gereken alan sayısı">:16 <br />
        <cf_get_lang dictionary_id="44197.Alanlar sırasıyla">; <br/>
        1_<cf_get_lang dictionary_id="31253.Sıra No">(<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
        2_<cf_get_lang dictionary_id="58025.Tc Kimlik No">(<cf_get_lang dictionary_id='29801.Zorunlu'>) <br />
        3_<cf_get_lang dictionary_id="57570.Ad Soyad"> (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
        4_<cf_get_lang dictionary_id="58053.Başlangıç Tarihi"> (<cf_get_lang dictionary_id='29801.Zorunlu'>)(gg.aa.yyyy)<br/>
        5_<cf_get_lang dictionary_id="57700.Bitiş Tarihi"> (<cf_get_lang dictionary_id='29801.Zorunlu'>)(gg.aa.yyyy)<br/>
        6_<cf_get_lang dictionary_id="43422.Kategori Id"> (<cf_get_lang dictionary_id='29801.Zorunlu'>)(id girilmelidir)<br/>
        7_<cf_get_lang dictionary_id="57951.Hedef">(<cf_get_lang dictionary_id='29801.Zorunlu'>) <br/>
        8_<cf_get_lang dictionary_id="30402.Rakam"> <br/>
        9_<cf_get_lang dictionary_id="33723.Rakam Tipi"> (1- (+) <cf_get_lang dictionary_id="56010.Artış Hedefi"> 2- (-) <cf_get_lang dictionary_id="31143.Düşüş Hedefi"> 3- (+%) <cf_get_lang dictionary_id="31144.Yüzde Artış Hedefi"> 4- (-%) <cf_get_lang dictionary_id="31145.Yüzde Düşüş Hedefi"> 5- (=) <cf_get_lang dictionary_id="31146.Hedeflenen Rakam">) <br/>
        10_<cf_get_lang dictionary_id="31141.Ayrılan Bütçe"> <br/>
        11_<cf_get_lang dictionary_id="33721.Ayrılan Bütçe Döviz"> <br/>
        12_<cf_get_lang dictionary_id="29784.Ağırlık">(<cf_get_lang dictionary_id='2004.Zorunlu'>) <br/>
        13_<cf_get_lang dictionary_id="31152.Hedef Veren"> (<cf_get_lang dictionary_id="33720.Hedef Verenin Tc Kimlik Nosu girilmelidir">.)<br/>
        14_<cf_get_lang dictionary_id="31940.Görüşme Tarihi">1 <br/>
        15_<cf_get_lang dictionary_id="31940.Görüşme Tarihi">2 <br/>
        16_<cf_get_lang dictionary_id="57629.Açıklama"> <br/>
        <br/>
        <cf_get_lang dictionary_id="33719.NOT:Dosya uzantısı csv olacak ve alan araları noktalı virgül (;) ile ayrılacaktır.Format UTF-8 <br/>
        Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır."><br/>
    </div>
</div>	
<script type="text/javascript">
function import_et()
{
	if(document.getElementById('uploaded_file').value == "")
	{
		alert("<cf_get_lang dictionary_id ='55934.Lütfen İmport Edilecek Belge Giriniz'> !");
		return false;
	}
	
	//windowopen('','small','cc_paym');
	 if (document.getElementById('process_type').value == 2)
	{
		import_worktimes.action='<cfoutput>#request.self#?fuseaction=hr.emptypopup_add_import_target</cfoutput>';}
	return true;
}
function formatGoster(type,text)
{
	document.getElementById('tdImport').innerHTML = "";
	document.getElementById('tdImport').innerHTML = "<strong>" + text + ":</strong><br /><br />";

	if (type == "")
		document.getElementById('tdImport').innerHTML = "";
	else if (type == 2)
		document.getElementById('tdImport').innerHTML += document.getElementById('td7').innerHTML;
}
</script>
