<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_name" default="">
<cf_box title="#getLang('','settings',45124)#">
    <cfform name="formimport" action="#request.self#?fuseaction=settings.emptypopup_company_stock_code_import" enctype="multipart/form-data" method="post">
       <cf_box_elements>
        <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
            <div class="form-group">
                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='55926.Belge Formatı'></label>
                <div class="col col-8 col-md-6 col-xs-12">
                    <select name="file_format" id="file_format">
                        <option value="UTF-8"><cf_get_lang dictionary_id='43388.UTF-8'></option>
                        <option value="iso-8859-9"><cf_get_lang dictionary_id='43386.ISO-8859-9 (Türkçe)'></option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                <div class="col col-8 col-md-6 col-xs-12">
                    <input type="file" name="uploaded_file" id="uploaded_file">
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                <div class="col col-8 col-md-6 col-xs-12">
                    <a  href="/IEF/standarts/import_example_file/uye_stok_kodu_aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58530.Aktarım Türü'></label>
                <div class="col col-8 col-md-6 col-xs-12">
                    <select name="transfer_type" id="transfer_type">
                        <option value="0"><cf_get_lang dictionary_id='57633.Barkod'></option>
                        <option value="1"><cf_get_lang dictionary_id='57789.Özel Kod'></option>
                        <option value="2"><cf_get_lang dictionary_id='57518.Stok Kodu'></option>
                    </select>
                </div>
            </div>
        </div>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
            <table>
                <tr>
                    <td class="headbold" valign="top"><cf_get_lang dictionary_id='58594.Format'></td>
                </tr>
                <tr>
                    <td valign="top">
                        <cf_get_lang dictionary_id='44683.Belgede toplam 3 alan olacaktır'>.<cf_get_lang dictionary_id='44197.Alanlar sırasıyla'><br/>
                        <cf_get_lang dictionary_id='45128.Üye Kodu'>;<br />
                        <cf_get_lang dictionary_id='57518.Stok Kodu'>;<cf_get_lang dictionary_id='57789.Özel Kod'>;<cf_get_lang dictionary_id='57633.Barkod'> (<cf_get_lang dictionary_id='44241.alanlarından biri'>)<br />
                        <cf_get_lang dictionary_id='45127.Üye Stok Kodu'><br /><br />
                        <cf_get_lang dictionary_id='44246.Dosya uzantısı csv veya txt olacak ve alan araları noktalı virgül (;) ile ayrılacaktır'>.<cf_get_lang dictionary_id='44193.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>.<cf_get_lang dictionary_id='44247.Ayıraç noktalı virgul olduğundan notlar içinde olmaması gerekmektedir'>.
                    </td>
                </tr>
            </table>
        </div>
    </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	if(formimport.uploaded_file.value.length==0)
	{
		alert("<cf_get_lang dictionary_id='43930.İmport Edilecek Belge Girmelisiniz'>!");
		return false;
	}
		return true;
}
</script>
