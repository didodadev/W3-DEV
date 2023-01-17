<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->
<cfsavecontent variable="message"><cf_get_lang dictionary_id='63062.Uzaktan Çalışma Aktarımı'></cfsavecontent>
<cf_form_box title="#message#">
    <cfform name="tax" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_transfer_remote" enctype="multipart/form-data">
        <cf_area width="300">
            <table>
                <tr>
                    <td><cf_get_lang dictionary_id='43385.Belge Formatı'></td>
                    <td>
                        <select name="file_format" id="file_format" style="width:200px;">
                            <option value="utf-8"><cf_get_lang dictionary_id='43388.UTF-8'></option>
                            <option value="iso-8859-9"><cf_get_lang dictionary_id='43386.ISO-8859-9 (Türkçe)'></option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id='57468.Belge'>*</td>
                    <td><input type="file" name="remote_file" id="remote_file" style="width:200px;"></td>
                </tr>
                <!--- <tr>
                    <td><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></td>
                    <td><a  href="/documents/settings/calisan_maas_aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a></td>
                </tr> --->
            </table>
        </cf_area>
        <cf_area>
            <table>
                <tr height="30">
                    <td class="headbold" valign="top"><cf_get_lang dictionary_id='58594.Format'></td>
                </tr>
                <tr>
                    <td valign="top">
                        <cf_get_lang dictionary_id='43796.İlk satır başlık satırları olmak üzere'> ;<br />
                        1. <cf_get_lang dictionary_id='43797.kolon sira no'> *<br />
                        2. <cf_get_lang dictionary_id='43798.kolon tc kimlik no'> *(<cf_get_lang dictionary_id='44690.Çalışanın TC Kimlik Numarası Girilmelidir'>.)<br />
                        3. <cf_get_lang dictionary_id='43799.kolon isim soyisim'> *(<cf_get_lang dictionary_id='54213.Çalışanın İsim ve Soyismi Girilmelidir'>.)<br />
                        4. <cf_get_lang dictionary_id='43800.kolon başlangıç ay'> *(<cf_get_lang dictionary_id='63064.Uzaktan Çalışma Planı Alanında Aylara Göre Başlangıç Ayını Belirtir. 1 – 12 Şeklinde Sayı Olarak Girilmelidir'>. )<br />
                        5. <cf_get_lang dictionary_id='43801.kolon bitiş ay'> *(<cf_get_lang dictionary_id='63065.Uzaktan Çalışma Planı Alanında Aylara Göre Bitiş Ayını Belirtir. 1 – 12 Şeklinde Sayı Olarak Girilmelidir'>. ) <br />
                        6. <cf_get_lang dictionary_id='43802.kolon yıl'> *(<cf_get_lang dictionary_id='63066.Gün Aktarım Yapılacak Yıl Girilmelidir . 2013...'>. )<br />
                        7. <cf_get_lang dictionary_id='38751.Kolon'> <cf_get_lang dictionary_id='57490.Gün'> *(<cf_get_lang dictionary_id='63067.Çalışanın İlgili Dönemde ki Uzaktan Çalışma Gün Bilgisi Girilmelidir'>.)<br />
                        <cf_get_lang dictionary_id='43804.bu kolonlardan sıra no ve isim bilgi amaçlıdır'>.<br />
                        <cf_get_lang dictionary_id='30106.Dosya uzantısı csv olmalı, kaydedilirken karakter desteği olarak UTF-8 seçilmelidir. Alan araları noktalı virgül (;) ile ayrılmalıdır.'> <cf_get_lang dictionary_id ='36511.Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır.'>
                    </td>
                </tr>
            </table>
        </cf_area>
        <cf_form_box_footer>
            <cf_workcube_buttons is_upd='0' is_delete='0'>
        </cf_form_box_footer>
    </cfform>
</cf_form_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->