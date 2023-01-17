<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Ürün Ağacı İstasyon Tanımı Aktarım','44766')#">
        <cfform name="formimport" action="#request.self#?fuseaction=settings.emptypopup_add_workstation_import" enctype="multipart/form-data" method="post">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">                 
                    <div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format">
                                <option value="UTF-8"><cf_get_lang dictionary_id='32802.UTF-8'></option>
                            </select>
                        </div>
                    </div>              
                    <div class="form-group" id="item-file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file">
                        </div>
                    </div>
                    <div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <a href="/IEF/standarts/import_example_file/urun_agaci_istasyon_tanimi_aktarimi.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                        </div>
                    </div>                    
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">               
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                    </div> 
                    <div class="form-group" id="item-exp1">
                        <cf_get_lang dictionary_id='44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır . Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır .'>
                    </div>
                    <div class="form-group" id="item-exp2">
                        <cf_get_lang dictionary_id='44961.Belgede toplam 10 alan olacaktır alanlar sırasi ile;'>
                    </div>   
                    <div class="form-group" id="item-exp3">
                        1-<cf_get_lang dictionary_id='44964.Stok Kodu veya Özel Kod(Operasyon Kodu verilmezse zorunlu)'></br>
                        2-<cf_get_lang dictionary_id='44963.Operasyon Kodu(Stok KoduÖzel Kod verilmezse zorunlu)'></br>
                        3-<cf_get_lang dictionary_id='44985.Bağlı Olduğu Ürün İçin Stok Kodu veya Özel Kod'></br>
                        4-<cf_get_lang dictionary_id='44986.İstasyon: İstasyonun ID si girilmelidir. (Zorunlu)'></br>
                        5-<cf_get_lang dictionary_id='44987.Kapasite (Saat): Kapasite değeri saat cinsinden girilmelidir.(Zorunlu)'></br>
                        6-<cf_get_lang dictionary_id='44989.Setup(Dk.) : Setup değeri dakika cinsinden girilmelidir.(Zorunlu)'></br>
                        7-<cf_get_lang dictionary_id='44991.Üretim Zamanı(Dk.) * : Üretim Zamanı değeri dakika cinsinden girilmelidir.(Zorunlu)'></br>
                        8-<cf_get_lang dictionary_id='44992.Minimum Üretim Miktarı(Zorunlu)'></br>
                        9-<cf_get_lang dictionary_id='44983.Tip :Artarak Devam : 0, Katları Şeklinde : 1(Zorunlu)'></br>
                        10-<cf_get_lang dictionary_id='58833.Fiziki Varlık'> : <cf_get_lang dictionary_id='56661.Fiziki Varlık ID'></br>
                    </div>                 
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
