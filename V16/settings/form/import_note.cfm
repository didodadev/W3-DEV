<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box title="#getLang('','Not Aktarım','43530')#">
    <cfform name="formexport" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=settings.emptypopup_import_note">
    <input type="hidden" name="action_type" id="action_type" value="0"><!--- simdilik bu parametrenin 1 olma kosuluna gore yazılmadı oralrdada gerekiyorsa buda action_section a gore ayarlanmalı --->
    <cf_box_elements>
        <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
            <div class="form-group" item="file_format">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                    <select name="file_format" id="file_format" style="width:200px;">
                        <option value="utf-8"><cf_get_lang dictionary_id='55929.UTF-8'></option>
                        <option value="iso-8859-9"><cf_get_lang dictionary_id='53845.ISO-8859-9 (Türkçe)'></option>
                    </select>
                </div>    
            </div>
            <div class="form-group" item="item-upload_file">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                    <input type="file" name="uploaded_file" id="uploaded_file">  
                </div>
            </div>
            <div class="form-group" item="note_type">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56236.Kayıt Tipi'></label>
                <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                    <select name="note_type" id="note_type" style="width:200px;">
                        <option value="1"><cf_get_lang dictionary_id='57789.Özel Kod'></option>
                        <option value="0"><cf_get_lang dictionary_id='58527.ID'></option>
                    </select>
                </div>
            </div>
            <div class="form-group" item="action_section">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58528.Not Tipi'></label>
                <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                    <select name="action_section" id="action_section" style="width:200px;">
                        <option value="COMPANY_ID"><cf_get_lang dictionary_id='49909.Kurumsal Üye'></option>
                        <option value="CONSUMER_ID"><cf_get_lang dictionary_id='57586.Bireysel Üye'></option>
                    </select>
                </div>
            </div>
            <div class="form-group" item="item-upload_file">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'>*</label>
                <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                    <a  href="/IEF/standarts/import_example_file/not_aktarım.csv"><strong><cf_get_lang no='1692.İndir'></strong></a>   
                </div>
            </div>
        </div>
        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
            <div class="form-group" id="item-format">
                <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>                    
            </div>
            <div class="form-group" id="item-exp1">
                <ul style="list-style:none; padding:0;">
                    <li><cf_get_lang dictionary_id='44338.Belgede toplam 5 alan olacaktır. Alanlar sırasıyla'></li>
                    <li><cf_get_lang dictionary_id='44339.Kod veya ID'></li>
                    <li><cf_get_lang dictionary_id='57480.Konu'></li>
                    <li><cf_get_lang dictionary_id='57467.Not'></li>
                    <li><cf_get_lang dictionary_id='44340.Özel Mesaj'></li>
                    <li><cf_get_lang dictionary_id='44341.Uyarı Notu'></li>
                    <li><cf_get_lang dictionary_id='44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır . Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır .'></li>
                    <li><cf_get_lang dictionary_id='44247.Ayıraç noktalı virgul olduğundan notlar içinde olmaması gerekmektedir'></li>
                </ul>
            </div>
        </div>         
    </cf_box_elements>
    <cf_box_footer>
        <cf_workcube_buttons is_upd='0'>
    </cf_box_footer>
    </cfform>
</cf_box>
</div>
