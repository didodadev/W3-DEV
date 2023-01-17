<!--- Sirket Calisan Importu hgul20111006 --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Kurumsal Çalışan Aktarımı','45170')#" closable="0">
        <cfform name="formimport" action="#request.self#?fuseaction=settings.emptypopup_add_company_partner_import" enctype="multipart/form-data" method="post">
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
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <a href="/IEF/standarts/import_example_file/Kurumsal_calisan_Aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                        </div>
                    </div>
                </div> 
                <div class="col col-6 col-md-6 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                    </div>                    
                    <div class="form-group" id="item-exp1">
                        <cf_get_lang dictionary_id='63167.Mail Hesabı Ayarları . Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır.'>                  
                    </div>                    
                    <div class="form-group" id="item-exp2">
                        <cf_get_lang dictionary_id='63190.Belgede toplam 19 sütun olacaktır. Alanlar sırası ile'>;
                    </div>           
                    <div class="form-group" id="item-exp3">
                        1-<cf_get_lang dictionary_id='49909.Kurumsal Üye'> <cf_get_lang dictionary_id='58527.ID'>(*)<br/>
                        2-<cf_get_lang dictionary_id='57897.Adı'>(*)<br/>
                        3-<cf_get_lang dictionary_id='58550.Soyadı'>(*)<br/>
                        4-<cf_get_lang dictionary_id='58727.Doğum Tarihi'>(<cf_get_lang dictionary_id='63189.Örnek : 21/09/2011'>)<br/>
                        5-<cf_get_lang dictionary_id='58025.TC Kimlik No'><br/>
                        6-<cf_get_lang dictionary_id='57571.Ünvan'><br/>
                        7-<cf_get_lang dictionary_id='57573.Görev/Pozisyon'><cf_get_lang dictionary_id='58527.ID'><br/>
                        8-<cf_get_lang dictionary_id='57453.Şube'><cf_get_lang dictionary_id='58527.ID'><br/>
                        9-<cf_get_lang dictionary_id='57572.Departman'><cf_get_lang dictionary_id='58527.ID'><br/>
                        10-<cf_get_lang dictionary_id='57764.Cinsiyet'>(1:<cf_get_lang dictionary_id='58959.Erkek'>,2:<cf_get_lang dictionary_id='58958.Kadın'>)<br/>
                        11-<cf_get_lang dictionary_id='46566.Dahili'><br/>
                        12-<cf_get_lang dictionary_id='55484.E-Mail'><br/>
                        13-<cf_get_lang dictionary_id='58723.Adres'>(<cf_get_lang dictionary_id='42783.Kişisel Adresi'>)<br/>
                        14-<cf_get_lang dictionary_id='58219.Ülke'>(<cf_get_lang dictionary_id='58527.ID'>)<br/>
                        15-<cf_get_lang dictionary_id='57971.Şehir'>(<cf_get_lang dictionary_id='58527.ID'>)<br/>
                        16-<cf_get_lang dictionary_id='58638.İlçe'>(<cf_get_lang dictionary_id='58527.ID'>)<br/>
                        17-<cf_get_lang dictionary_id='58132.Semt'>(<cf_get_lang dictionary_id='42783.Kişisel Adresi'>)<br/>
                        18-<cf_get_lang dictionary_id='57472.Posta Kodu'>(<cf_get_lang dictionary_id='42783.Kişisel Adresi'>)<br/>
                        19-<cf_get_lang dictionary_id='58996.Dil'>(<cf_get_lang dictionary_id='58527.ID'>)<br/>
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
