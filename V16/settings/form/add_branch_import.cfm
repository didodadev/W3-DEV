<!--- Branch Import --->

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Şube Aktarım','65007')#">
        <cfform name="formimport" action="V16/settings/cfc/branch_import.cfc?method=add_branch" enctype="multipart/form-data" method="post">
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
                            <a href="/IEF/standarts/import_example_file/Sube_Aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
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
                        <cf_get_lang dictionary_id='44250.Belgede toplam 33 alan olacaktır alanlar sırasi ile'>:
                    </div>                                    
                    <div class="form-group" id="item-exp3">
                        1-<cf_get_lang dictionary_id='29532.Şube Adı'>(*)<br/>
                        2-<cf_get_lang dictionary_id='42672.Şube Kısa Adı'>(*)<br/>
                        3-<cf_get_lang dictionary_id='29511.Yönetici'> 1 (<cf_get_lang dictionary_id='63162.Çalışan ID si girilmeli'>)<br/>
                        4-<cf_get_lang dictionary_id='29511.Yönetici'> 2 (<cf_get_lang dictionary_id='63162.Çalışan ID si girilmeli'>)<br/>
                        5-<cf_get_lang dictionary_id='57761.Hiyerarşi'>1<br/>
                        6-<cf_get_lang dictionary_id='57761.Hiyerarşi'>2<br/>
                        7-<cf_get_lang dictionary_id='58219.Ülke'><br/>
                        8-<cf_get_lang dictionary_id='57971.Şehir'><br/>
                        9-<cf_get_lang dictionary_id='63898.İlçe'><br/>
                        10-<cf_get_lang dictionary_id='63897.Posta Kodu'><br/>
                        11-<cf_get_lang dictionary_id='56392.İlgili Şirket'><br/>                            
                        12-<cf_get_lang dictionary_id='57789.Özel Kod'><br/>
                        13-<cf_get_lang dictionary_id='39733.İlişkili Şube'><cf_get_lang dictionary_id='58527.ID'><br/>
                        14-<cf_get_lang dictionary_id='63893.Şirket'><cf_get_lang dictionary_id='58527.ID'><br/>
                        15-<cf_get_lang dictionary_id='32407.Tel Kod'><br/>
                        16-<cf_get_lang dictionary_id='49272.Tel'>1<br/>
                        17-<cf_get_lang dictionary_id='49272.Tel'>2<br/>
                        18-<cf_get_lang dictionary_id='49272.Tel'>3<br/>
                        19-<cf_get_lang dictionary_id='57488.Fax'><br/>
                        20-<cf_get_lang dictionary_id='57428.E-posta'><br/>
                        21-<cf_get_lang dictionary_id='58762.Vergi Dairesi'><br/>
                        22-<cf_get_lang dictionary_id='57752.Vergi No'><br/>
                        23-<cf_get_lang dictionary_id='63895.Adres'><br/>
                        24-<cf_get_lang dictionary_id='52480.Şube Tipi'><cf_get_lang dictionary_id='58527.ID'><br/>
                        25-<cf_get_lang dictionary_id='42058.Üretim Yapılıyor'> (<cf_get_lang dictionary_id='64637.Üretim Yapılıyor seçeneği için 1, aksi durum için 0 yazılmalıdır.'>)<br/>
                        26-<cf_get_lang dictionary_id='42936.Org Şemada Göster'> (<cf_get_lang dictionary_id='64636.Organizasyon Şemada Göster seçeneği için 1, aksi durum için 0 yazılmalıdır.'>)<br/>
                        27-<cf_get_lang dictionary_id='57992.Bölge'> ID<br/>
                        28-<cf_get_lang dictionary_id='42750.Çalışma Böl. Müd. Adı'><br/>
                        29-<cf_get_lang dictionary_id='42752.İşyerinde Yapılan İş'><br/>
                        30-<cf_get_lang dictionary_id='42358.İş Kolu'> ID<br/>
                        31-<cf_get_lang dictionary_id='43488.Kısa Vadeli Sigorta Kolları Prim Oranı'><br/>
                        32-<cf_get_lang dictionary_id='43307.Sakat Kontrol'> (<cf_get_lang dictionary_id='65073.Sakat Kontrol seçeneği için 1, aksi durum için 0 yazılmalıdır.'>)<br/>
                        33-<cf_get_lang dictionary_id='50431.Dosya No'><br/>
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