<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Eğitim Aktarımı	','45163')#" closable="0">
        <cfform name="formimport" action="#request.self#?fuseaction=settings.emptypopup_add_edu_import" enctype="multipart/form-data" method="post">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" item="file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>            
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">            
                            <select name="file_format" id="file_format">            
                                <option value="utf-8"><cf_get_lang dictionary_id='55929.UTF-8'></option>            
                            </select>            
                        </div>    
                    </div> 
                    <div class="form-group" item="item-upload_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>            
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">            
                            <input type="file" name="uploaded_file" id="uploaded_file">              
                        </div>           
                    </div> 
                    <div class="form-group" item="example_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>            
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">            
                            <a  href="/IEF/standarts/import_example_file/egitim_aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>              
                        </div>            
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>                
                    </div>
                    <div class="form-group" id="item-exp1">
                        <cf_get_lang dictionary_id='33719.NOT: Dosya uzantısı csv olacak ve alan araları noktalı virgül (;) ile ayrılacaktır. Format UTF-8 Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır.'>
                    </div>
                    <div class="form-group" id="item-exp2">
                    <cf_get_lang dictionary_id='63190.Belgede toplam 19 sütun olacaktır. Alanlar sırası ile'> 
                    </div>                
                    <div class="form-group" id="item-exp3">
                        1-<cf_get_lang dictionary_id='31090.Eğitimin Adı'><br/>
                        2-<cf_get_lang dictionary_id='39091.Kategorisi'>(ID)<br/>
                        3-<cf_get_lang dictionary_id='57995.Bölüm'>(ID)<br/>    
                        4-<cf_get_lang dictionary_id='33521.Eğitim Şekli'>(ID)<br/>    
                        5-<cf_get_lang dictionary_id='36004.Toplam Gün'><br/>
                        6-<cf_get_lang dictionary_id='46377.Toplam Saat'><br/>
                        7-<cf_get_lang dictionary_id='30916.Eğitim Yeri'><br/>
                        8-<cf_get_lang dictionary_id='63461.Eğitimci Çalışan ID'><br/>
                        9-<cf_get_lang dictionary_id='63462.Eğitimci Kurumsal Üye Çalışan ID'><br/>    
                        10-<cf_get_lang dictionary_id='63463.Eğitimci Bireysel Üye Çalışan ID'><br/>    
                        11-<cf_get_lang dictionary_id='46180.Eğitim Yeri Sorumlusu'>(<cf_get_lang dictionary_id='63464.Manuel Girilebilir'>)<br/>
                        12-<cf_get_lang dictionary_id='46178.Eğitim Yeri Adresi'><br/>
                        13-<cf_get_lang dictionary_id='46179.Eğitim Yeri Telefonu'><br/>    
                        14-<cf_get_lang dictionary_id='57416.Proje'>(ID)<br/>    
                        15-<cf_get_lang dictionary_id='63465.Eğitim Başlangıç Tarihi'><br/>
                        16-<cf_get_lang dictionary_id='63466.Eğitim Başlangıç Saati'>(<cf_get_lang dictionary_id='58967.Örnek'>=08:30)<br/>
                        17-<cf_get_lang dictionary_id='63467.Eğitim Bitiş Tarihi'><br/>
                        18-<cf_get_lang dictionary_id='63468.Eğitim Bitiş Saati'>(<cf_get_lang dictionary_id='58967.Örnek'>=08:30)<br/>
                        19-<cf_get_lang dictionary_id='63469.Eğitimi Görecekler'>(1:<cf_get_lang dictionary_id='33164.Bu Olayı Herkes Görsün'>,2:<cf_get_lang dictionary_id='57914.Şubemdeki Herkes Görsün'>,3:<cf_get_lang dictionary_id='57915.Departmanımdaki Herkes Görsün'>,0:<cf_get_lang dictionary_id='63470.Kimse Görmesin'>)<br/>    
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