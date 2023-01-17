<cf_get_lang_set module_name="settings">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='42103.Ürün Ağacı'><cf_get_lang dictionary_id='52718.Import'></cfsavecontent>
<cf_box title="#title#">
<cfform name="formimport" action="#request.self#?fuseaction=settings.emptypopup_add_product_tree_import" enctype="multipart/form-data" method="post">
	<cf_box_elements>
        <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
            <div class="form-group">
                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='53723.Belge Formatı'></label>
                <div class="col col-8 col-md-6 col-xs-12">
                    <select name="file_format" id="file_format">
                        <option value="UTF-8"><cf_get_lang dictionary_id='55929.UTF-8'></option>
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
                    <a  href="/IEF/standarts/import_example_file/urun_agaci_aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                <div class="col col-8 col-md-6 col-xs-12">
                    <cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'>
                </div>
            </div>
        </div>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
            <table>
                <tr height="30">
                    <td class="headbold"><cf_get_lang dictionary_id='58594.Format'></td>
                </tr>
                <tr>
                    <td valign="top"> 
                        <cf_get_lang dictionary_id='30106.Dosya uzantısı csv olmalı kaydedilirken karakter desteği olarak UTF-8 seçilmelidir Alan araları noktalı virgül(;) ile ayrılmalı sayısal değerler için nokta(.) ayrac olarak kullanılmalıdır'> <cf_get_lang dictionary_id='44960.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>
                            <cf_get_lang dictionary_id="63295.Belgede toplam 11 alan olacaktır alanlar sırasi ile">;<br/>
                        1- <cf_get_lang dictionary_id='44962.Kırılım(Zorunlu)'><br/>
                        2- <cf_get_lang dictionary_id='44963.Operasyon Kodu(Stok Kodu\Özel Kod verilmezse zorunlu)'><br/>
                        3- <cf_get_lang dictionary_id='44964.Stok Kodu veya Özel Kod(Operasyon Kodu verilmezse zorunlu)'><br/>
                        4- <cf_get_lang dictionary_id='57647.Spec'> (<cf_get_lang dictionary_id='63296.Spec boş bırakılırsa, sistemde kayıtlı son spec i alır'>)<br/>
                        5- <cf_get_lang dictionary_id='44965.Miktar(Zorunlu)'><br/>
                        6- <cf_get_lang dictionary_id="36356.Fire Miktarı"></br>
                        7- <cf_get_lang dictionary_id="36357.Fire Oranı"></br>
                        8- <cf_get_lang dictionary_id='44267.Sıra No'><br/>
                        9- <cf_get_lang dictionary_id='44966.Alternatif Sorusu'> (<cf_get_lang dictionary_id='63297.Id Girilmelidir'>.)<br/>
                        10- <cf_get_lang dictionary_id='44967.Konfigure Edilebilir(0 veya 1 Verilmelidir)'>.<br/>
                        11- <cf_get_lang dictionary_id='44968.Sevkte Birleştir(0 veya 1 Verilmelidir)'>.<br/>
                        12- <cf_get_lang dictionary_id='44969.Fantom'> (<cf_get_lang dictionary_id='63298.Fantom ise 1 yazılmalıdır'>.)<br/>
                        13- <cf_get_lang dictionary_id="57629.Açıklama"> (<cf_get_lang dictionary_id='63299.En fazla 150 karakter yazılmalıdır'>.)<br /> 
                    </td>
                </tr>
            </table>
        </div>
</cf_box_elements>
    <cf_box_footer>
    	<cf_workcube_buttons is_upd='0' add_function='kontrol_process()'>
    </cf_box_footer>
</cfform>
</cf_box>
<script type="text/javascript">
function kontrol_process()
	{
		return process_cat_control();
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
