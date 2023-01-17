<!--- Kurumsal Üye Şube Importu hgul20111006 --->
<!--- Sirket Calisan Importu hgul20111006 --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Kurumsal Üye Şube Aktarımı','45171')#" closable="0">
        <cfform name="formimport" action="#request.self#?fuseaction=settings.emptypopup_add_company_branch_import" enctype="multipart/form-data" method="post">
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
                            <a href="/IEF/standarts/import_example_file/Kurumsal_uye_sube_Aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
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
                        <cf_get_lang dictionary_id='63168.Belgede toplam 20 sutun olacaktır. Alanlar sırasi ile;'>
                    </div>                                    
                    <div class="form-group" id="item-exp3">
                        1-<cf_get_lang dictionary_id='49909.Kurumsal Üye'> <cf_get_lang dictionary_id='58527.ID'>(*)<br/>
                        2-<cf_get_lang dictionary_id='29532.Şube Adı'>(*)<br/>
                        3-<cf_get_lang dictionary_id='63152.Şube Telefon Alan Kodu'><br/>
                        4-<cf_get_lang dictionary_id='63153.Şube Telefon'><br/>
                        5-<cf_get_lang dictionary_id='63153.Şube Telefon'>2<br/>
                        6-<cf_get_lang dictionary_id='63154.Şube Fax'><br/>
                        7-<cf_get_lang dictionary_id='63155.Şube Mobil Telefon Kodu'><br/>
                        8-<cf_get_lang dictionary_id='63156.Şube Mobil Telefon'><br/>
                        9-<cf_get_lang dictionary_id='63157.Şube E-mail'><br/>
                        10-<cf_get_lang dictionary_id='63158.Şube İnternet Adresi'><br/>
                        11-<cf_get_lang dictionary_id='57629.Açıklama'><br/>
                        12-<cf_get_lang dictionary_id='63159.Şube Yöneticisi'>(<cf_get_lang dictionary_id='63161.Kurumsal Çalışan ID si girilmeli'>)<br/>
                        13-<cf_get_lang dictionary_id='63160.Temsilcisi'>(<cf_get_lang dictionary_id='63162.Çalışan ID si girilmeli'>)<br/>
                        14-<cf_get_lang dictionary_id='58219.Ülke'>(<cf_get_lang dictionary_id='63163.Ülke ID si girilmeli'>)<br/>
                        15-<cf_get_lang dictionary_id='57971.Şehir'>(<cf_get_lang dictionary_id='63164.Şehir ID si girilmeli'>)<br/>
                        16-<cf_get_lang dictionary_id='58638.İlçe'>(<cf_get_lang dictionary_id='63165.İlçe ID si girilmeli'>)<br/>
                        17-<cf_get_lang dictionary_id='58132.Semt'><br/>
                        18-<cf_get_lang dictionary_id='57472.Posta Kodu'><br/>
                        19-<cf_get_lang dictionary_id='58723.Adres'><br/>
                        20-<cf_get_lang dictionary_id='57248.Sevk Adresi'>/<cf_get_lang dictionary_id='38731.Fatura Adresi'>(<cf_get_lang dictionary_id='63166.2 Yazılırsa Sevk adresi 3 Yazılırsa Fatura adresi'>)<br/>
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
		alert("<cf_get_lang no='1441.Belge Seçmelisiniz'>!");
		return false;
	}
		return true;
}
</script>
