<!---abone import --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Abone Aktarım','42021')#">
        <cfform name="formimport" action="#request.self#?fuseaction=settings.emptypopup_add_subscription_import" enctype="multipart/form-data" method="post">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">   
                    <div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format">
                                <option value="utf-8"><cf_get_lang no='1405.UTF-8'></option>
                            </select>
                        </div>
                    </div> 
                    <div class="form-group" id="item-file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file">
                        </div>
                    </div>         
                    <div class="form-group" id="item-file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <a href="/IEF/standarts/import_example_file/abone_aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                        </div>
                    </div>                
                </div>     
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">               
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                    </div> 
                    <div class="form-group" id="item-exp1">
                        <cf_get_lang dictionary_id='35657.Dosya uzantısı csv olmalı ve alan araları virgül (;) ile ayrılmalıdır'>
                    </div>
                    <div class="form-group" id="item-exp2">
                        <cf_get_lang dictionary_id='44195.Belgede toplam'> 28 <cf_get_lang dictionary_id='44196.alan olacaktır'>.
                    </div>
                    <div class="form-group" id="item-exp3">
                        <cf_get_lang dictionary_id='44197.Alanlar sırasıyla'>;
                    </div>
                    <div class="form-group" id="item-exp4">
                        1-<cf_get_lang dictionary_id='57493.Aktif'>(<cf_get_lang dictionary_id='57493.Aktif'>:1 <cf_get_lang dictionary_id='57494.Pasif'>:0)*</br>
                        2-<cf_get_lang dictionary_id='29502.Abone No'>*</br>
                        3-<cf_get_lang dictionary_id='63446.Bireysel Müşteri'><cf_get_lang dictionary_id='58527.ID'>*</br>
                        4-<cf_get_lang dictionary_id='63447.Kurumsal Müşteri'><cf_get_lang dictionary_id='58527.ID'>*</br>
                        5-<cf_get_lang dictionary_id='58233.Tanım'>*</br>
                        6-<cf_get_lang dictionary_id='57482.Aşama'><cf_get_lang dictionary_id='58527.ID'>*</br>
                        7-<cf_get_lang dictionary_id='43422.Kategori ID'>*</br>
                        8-<cf_get_lang dictionary_id='57747.Sözleşme Tarihi'>*</br>
                        9-<cf_get_lang dictionary_id='41071.Montaj Tarihi'></br>
                        10-<cf_get_lang dictionary_id='57789.Özel Kod'></br>
                        11-<cf_get_lang dictionary_id='39160.Fatura Şirketi'><cf_get_lang dictionary_id='63446.Bireysel Müşteri'><cf_get_lang dictionary_id='58527.ID'></br>
                        12-<cf_get_lang dictionary_id='39160.Fatura Şirketi'><cf_get_lang dictionary_id='63447.Kurumsal Müşteri'><cf_get_lang dictionary_id='58527.ID'></br>
                        13-<cf_get_lang dictionary_id='34780.Satış Temsilcisi'><cf_get_lang dictionary_id='58527.ID'></br>
                        14-<cf_get_lang dictionary_id='34167.Satış Ortağı'><cf_get_lang dictionary_id='63446.Bireysel Müşteri'><cf_get_lang dictionary_id='58527.ID'></br>
                        15-<cf_get_lang dictionary_id='34167.Satış Ortağı'><cf_get_lang dictionary_id='63447.Kurumsal Müşteri'><cf_get_lang dictionary_id='58527.ID'></br>
                        16-<cf_get_lang dictionary_id='40544.Satış Ortağı Komisyonu'></br>
                        17-<cf_get_lang dictionary_id='58474.P.Birimi'></br>
                        18-<cf_get_lang dictionary_id='34779.Referans Müşteri'><cf_get_lang dictionary_id='30368.Çalışan'><cf_get_lang dictionary_id='58527.ID'></br>
                        19-<cf_get_lang dictionary_id='34779.Referans Müşteri'><cf_get_lang dictionary_id='63446.Bireysel Müşteri'><cf_get_lang dictionary_id='58527.ID'></br>                            
                        20-<cf_get_lang dictionary_id='34779.Referans Müşteri'><cf_get_lang dictionary_id='63447.Kurumsal Müşteri'><cf_get_lang dictionary_id='58527.ID'></br>
                        21-<cf_get_lang dictionary_id='44019.Ürün'><cf_get_lang dictionary_id='63432.Stok Kodu veya Özel Kod'></br>
                        22-<cf_get_lang dictionary_id='30044.Sözleşme No'><cf_get_lang dictionary_id='58527.ID'></br>
                        23-<cf_get_lang dictionary_id='40084.Abone Özel Tanım'><cf_get_lang dictionary_id='58527.ID'></br>
                        24-<cf_get_lang dictionary_id='59029.Servis Özel Tanım'><cf_get_lang dictionary_id='58527.ID'></br>
                        25-<cf_get_lang dictionary_id='58516.Ödeme Yöntemi'><cf_get_lang dictionary_id='58527.ID'></br>
                        26-<cf_get_lang dictionary_id='57416.Proje'><cf_get_lang dictionary_id='58527.ID'></br>
                        27-<cf_get_lang dictionary_id='58833.Fiziki Varlık'><cf_get_lang dictionary_id='58527.ID'></br>
                        28-<cf_get_lang dictionary_id='57453.Şube'><cf_get_lang dictionary_id='58527.ID'></br>
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
		alert("<cf_get_lang dictionary_id='54246.Belge Seçmelisiniz'>!");
		return false;
	}
		return true;
}
</script>
