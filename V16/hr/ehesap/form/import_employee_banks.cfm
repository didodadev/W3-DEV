<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Çalışan Banka Bilgileri Aktarım','44671')#">
        <cfform name="formimport" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_import_employee_banks">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format">
                                <option value="utf-8"><cf_get_lang dictionary_id='43388.UTF-8'></option>
                                <option value="iso-8859-9"><cf_get_lang dictionary_id='43386.ISO-8859-9 (Türkçe)'></option>
                            </select>
                        </div>
                    </div>  
					<div class="form-group" id="item-file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file">
                        </div>
                    </div>   
					<div class="form-group" id="item-example_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <a  href="/IEF/standarts/import_example_file/calisan_banka_bilgileri_aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                        </div>
                    </div>                                                                                 
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-format">
						<label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
					</div>     
					<div class="form-group" id="item-exp1">
                        <cf_get_lang dictionary_id='44135.İmport İşlemi 2 satırdan başlar.'> <cf_get_lang dictionary_id='44707.İlk satır başlıklardan oluşur.'>
                    </div>  
					<div class="form-group" id="item-exp2">
                        <cf_get_lang dictionary_id='44720.İmport Dosyası Kolonları'> (;) <cf_get_lang dictionary_id='44721.ile ayrılmış csv uzantılı olmalıdır.'>
                    </div>  
					<div class="form-group" id="item-exp3">
                        1-<cf_get_lang dictionary_id='44267.Sıra No'></br>
                        2-<cf_get_lang dictionary_id='57570.Adı Soyadı'></br>
                        3-<cf_get_lang dictionary_id='58025.TC Kimlik No'>*</br>
                        4-<cf_get_lang dictionary_id='44711.Banka IDsi'>* --> <cf_get_lang dictionary_id='44712.Bu bilgiyi finans - banka tanımlarından öğrenebilir ve/veya tanımlayabilirsiniz.'></br>
                        5-<cf_get_lang dictionary_id='44713.Banka Adı'></br>
                        6-<cf_get_lang dictionary_id='44714.Banka Şube Adı'></br>
                        7-<cf_get_lang dictionary_id='43744.Banka Şube Kodu'></br>
                        8-<cf_get_lang dictionary_id='44715.Banka Hesap No'>**</br>
                        9-<cf_get_lang dictionary_id='44716.Hesap Para Birimi'></br>
                        10-<cf_get_lang dictionary_id="54332.IBAN No"> **</br>
                        11-<cf_get_lang dictionary_id="29530.Swift Kodu"></br>
                        12-(<cf_get_lang dictionary_id="59612.Ortak Hesap">) <cf_get_lang dictionary_id="57631.Ad"> </br>
                        13-(<cf_get_lang dictionary_id="59612.Ortak Hesap">) <cf_get_lang dictionary_id="58726.Soyad"></br>
                        14-<cf_get_lang dictionary_id='44717.Banka Hesabını Standart Yap'>* --> <cf_get_lang dictionary_id='44718.Bu seçenek 0 veya 1 olarak doldurulmalıdır.'> <cf_get_lang dictionary_id='44719.1 seçilir ise hesap standart hesap olur ve puantaj hesaplamalarında kullanılır.'></br>                      
                    </div>     
                    <div class="form-group" id="item-exp4">
                        * <cf_get_lang dictionary_id="35867.Doldurulması zorunlu alanlar"></br>
                        ** <cf_get_lang dictionary_id="59613.Banka Hesap No ve IBAN No alanlarından en az biri doldurulmalıdır">.</br>
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
		alert("<cf_get_lang dictionary_id ='43930.İmport Edilecek Belge Girmelisiniz'>!");
		return false;
	}
	return true;
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
