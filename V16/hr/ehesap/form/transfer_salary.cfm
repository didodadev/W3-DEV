<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','Çalışan Maaş Aktarımı','43527')#">
            <cfform name="tax" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_transfer_salary" enctype="multipart/form-data"> 
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-file_format">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="file_format" id="file_format">
                                    <option value="utf-8"><cf_get_lang dictionary_id='32802.UTF-8'></option>
                                    <option value="iso-8859-9"><cf_get_lang dictionary_id='32979.ISO-8859-9 (Türkçe)'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-file">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="file" name="salary_file" id="salary_file">
                            </div>
                        </div>
                        <div class="form-group" id="item-file_example">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <a href="/IEF/standarts/import_example_file/calisan_maas_aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                            </div>
                        </div>    
                        <div class="form-group" id="item-file_example">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='43793.Maaş Alanı'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="salary_type" id="salary_type">
                                    <option value="1"><cf_get_lang dictionary_id ='43794.Gerçek Maaş'></option>
                                    <option value="2"><cf_get_lang dictionary_id ='43795.Planlanan Maaş'></option>
                                </select>
                            </div>
                        </div>                    
                    </div>  
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true"> 
                        <div class="form-group" id="item-format">
                            <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                        </div>  
                        <div class="form-group" id="item-exp1">
                            <cf_get_lang dictionary_id='43796.İlk satır başlık satırları olmak üzere'>;
                        </div>  
                        <div class="form-group" id="item-exp2">
                            1-<cf_get_lang dictionary_id='31253.Sıra No'> *</br>
                            2-<cf_get_lang dictionary_id='58025.TC Kimlik No'> *(<cf_get_lang dictionary_id='44690.Çalışanın TC Kimlik Numarası Girilmelidir'>.)</br>
                            3-<cf_get_lang dictionary_id='57570.Ad Soyad'> *(<cf_get_lang dictionary_id='54213.Çalışanın İsim ve Soyismi Girilmelidir'>.)</br>
                            4-<cf_get_lang dictionary_id='31579.Başlangıç Ay'> *(<cf_get_lang dictionary_id='59679.Çalışanın Maaş Planla Alanında Aylara Göre Maaş Başlangıç Aynı Belirtir. 1 – 12 Şeklinde Sayı Olarak Girilmelidir'>.)</br>
                            5-<cf_get_lang dictionary_id='39990.Bitiş Ay'> *(<cf_get_lang dictionary_id='59680.Çalışanın Maaş Planla Alanında Aylara Göre Maaş Bitiş Aynı Belirtir. 1 – 12 Şeklinde Sayı Olarak Girilmelidir'>. ) </br>
                            6-<cf_get_lang dictionary_id='58455.Yıl'> *(<cf_get_lang dictionary_id='59681.Maaş Aktarın Yapılacak Yıl Girilmelidir'>.  2013... )</br>
                            7-<cf_get_lang dictionary_id='40071.Maaş'> *(<cf_get_lang dictionary_id='59682.Çalışanın İlgili Dönemde ki Maaş Bilgisi Girilmelidir'>.)</br>
                            8-<cf_get_lang dictionary_id='57489.Para Birimi'>*</br>
                        </div>
                        <div class="form-group" id="item-exp3">
                            <cf_get_lang dictionary_id='43804.bu kolonlardan sıra no ve isim bilgi amaçlıdır'>.</br>
                            <cf_get_lang dictionary_id='30106.Dosya uzantısı csv olmalı, kaydedilirken karakter desteği olarak UTF-8 seçilmelidir. Alan araları noktalı virgül (;) ile ayrılmalıdır.'></br>
                            <cf_get_lang dictionary_id ='36511.Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır.'></br>
                        </div>
                    </div>               
                </cf_box_elements>    
                <cf_box_footer>
                    <cf_workcube_buttons is_upd='0' is_delete='0'>
                </cf_box_footer>                   
            </cfform>
        </cf_box>
    </div>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
    