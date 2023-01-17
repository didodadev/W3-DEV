<!--- Departman Import --->

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Departman Aktarım','64633')#">
        <cfform name="formimport" action="V16/settings/cfc/department_import.cfc?method=add_department" enctype="multipart/form-data" method="post">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format">
                                <option value="UTF-8"><cf_get_lang dictionary_id='55929.UTF-8'></option>
                            </select>
                        </div>
                    </div>                   
                    <div class="form-group" id="item-uploaded_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file">
                        </div>
                    </div>                   
                    <div class="form-group" id="item-download-link">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='44335.Örnek Dosya Formatı'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <a href="/IEF/standarts/import_example_file/Departman_Aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                        </div>
                    </div>
                </div> 
                <div class="col col-6 col-md-6 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                    </div>  
                    <div class="form-group" id="item-exp1">
                        <cf_get_lang dictionary_id='44960.Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır .'>
                    </div>  
                    <div class="form-group" id="item-exp2">
                        <cf_get_lang dictionary_id='221.Belgede toplam 17 alan olacaktır.'><cf_get_lang dictionary_id='53860.Alanlar sırasıyla'>:
                    </div>                                    
                    <div class="form-group" id="item-exp3">
                        1-<cf_get_lang dictionary_id='42424.Department Name'>(*)<br/>
                        2-<cf_get_lang dictionary_id='57453.Şube'><cf_get_lang dictionary_id='58527.ID'>(*)<br/>
                        3-<cf_get_lang dictionary_id='57630.Tip'>(<cf_get_lang dictionary_id='64635.Depo ise 1, Departman ise 2 Depo ve Departman ise 3 yazılmalıdır.'>)<br/>
                        4-<cf_get_lang dictionary_id='64604.Departman Kategorisi'><cf_get_lang dictionary_id='58527.ID'><br/>
                        5-<cf_get_lang dictionary_id='64601.Departman Türü'><cf_get_lang dictionary_id='58527.ID'><br/>
                        6-<cf_get_lang dictionary_id='42335.Üst Departman'><cf_get_lang dictionary_id='58527.ID'><br/>
                        7-<cf_get_lang dictionary_id='42613.Çalışan Sayısı'><br/>
                        8-<cf_get_lang dictionary_id="57428.Email"><br/>
                        9-<cf_get_lang dictionary_id='42009.Ayrıntı'><br/>
                        10-<cf_get_lang dictionary_id='29511.Yönetici'> 1 (<cf_get_lang dictionary_id='63162.Çalışan ID si girilmeli'>)<br/>
                        11-<cf_get_lang dictionary_id='29511.Yönetici'> 2 (<cf_get_lang dictionary_id='63162.Çalışan ID si girilmeli'>)<br/>
                        12-<cf_get_lang dictionary_id='43091.Kademe Numarası'><br/>
                        13-<cf_get_lang dictionary_id='57761.Hiyerarşi'><br/>
                        14-<cf_get_lang dictionary_id='57789.Özel Kod'> 1<br/>
                        15-<cf_get_lang dictionary_id='57789.Özel Kod'> 2<br/>
                        16-<cf_get_lang dictionary_id='42058.Üretim Yapılıyor'> (<cf_get_lang dictionary_id='64637.Üretim Yapılıyor seçeneği için 1, aksi durum için 0 yazılmalıdır.'>)<br/>
                        17-<cf_get_lang dictionary_id='42936.Org Şemada Göster'> (<cf_get_lang dictionary_id='64636.Organizasyon Şemada Göster seçeneği için 1, aksi durum için 0 yazılmalıdır.'>)<br/>
                    </div> 
                    <div class="form-group" id="item-exp4">
                        <b><cf_get_lang dictionary_id='63343.NOT : (*) Yıldızlı Olanlar Zorunlu Alanlardır.'></b>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>

<script type="text/javascript">
	function kontrol()
	{
		if(formimport.uploaded_file.value.length==0)
		{
			alert("<cf_get_lang dictionary_id='43424.Belge Seçiniz'>!");
			return false;
		}
		return process_cat_control();
	}
</script>