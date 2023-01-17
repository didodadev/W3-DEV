<!---
File: transfer_salary_scale.cfm
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date:24.09.2019
Controller: -
Description: İlgili pozisyon tipi için minimim ve maximum ücret tutarlarının import edildiği sayfadır.
--->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Temel Ücret Skalası Aktarım','51195')#">
        <cfform name="tax" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_transfer_salary_scale" enctype="multipart/form-data">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true"> 
                    <div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format">
                                <option value="utf-8"><cf_get_lang dictionary_id='43388.UTF-8'></option>
                                <option value="iso-8859-9"><cf_get_lang dictionary_id='43386.ISO-8859-9 (Türkçe)'></option>
                            </select>
                        </div>
                    </div>    
                    <div class="form-group" id="item-file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="salary_file" id="salary_file">
                        </div>
                    </div> 
                    <div class="form-group" id="item-example_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <a href="/IEF/standarts/import_example_file/transfer_salary_scale.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                        </div>
                    </div>                     
                </div> 
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">       
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                    </div> 
                    <div class="form-group" id="item-exp1">
                        <cf_get_lang dictionary_id='44984. Dosya uzantısı csv olmalı, kaydedilirken karakter desteği olarak UTF-8 seçilmelidir. Alan araları noktalı virgül (;) ile ayrılmalıdır. Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır. '>
                    </div> 
                    <div class="form-group" id="item-exp2">
                        <cf_get_lang dictionary_id='43796.İlk satır başlık satırları olmak üzere'> ;
                    </div>        
                    <div class="form-group" id="item-exp3">
                        1. <cf_get_lang dictionary_id='48171.sira no'> *</br>
                        2. <cf_get_lang dictionary_id='59004.Pozisyon Tipi'> *(<cf_get_lang dictionary_id='44330.Sayısal Olarak ID girilmelidir'>).</br>
                        3. <cf_get_lang dictionary_id='58455.Yıl'></br>
                        4. <cf_get_lang dictionary_id='51188.En Düşük Ücret'></br>
                        5. <cf_get_lang dictionary_id='51193.En Yüksek Ücret'></br>
                        6. <cf_get_lang dictionary_id='57489.Para birimi'> *</br>
                    </div>  
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' is_delete='0'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>