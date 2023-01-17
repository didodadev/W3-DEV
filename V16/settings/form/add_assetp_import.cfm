<!--- Fiziki Varlık İmport --->
<div class="col col-12 col-xs-12">
    <cfif isDefined("attributes.control_fus") and attributes.control_fus eq 1>
       <cfset x = 1>
   <cfelse>
        <cfset x = 0>
   </cfif>
    <cf_box title="#getLang('settings',3123)#" draggable="#x#" closable="#x#">
        <cfform name="formimport" action="#request.self#?fuseaction=settings.emptypopup_assetp_import" enctype="multipart/form-data" method="post">
            <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-comp_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='1402.Belge Formatı'></label>
                            <div class="col col-8 col-xs-12"> 
                                <select name="file_format" id="file_format">
                                    <option value="utf-8"><cf_get_lang no='1405.UTF-8'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-comp_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='56.Belge'>*</label>
                            <div class="col col-8 col-xs-12"> 
                                <input type="file" name="uploaded_file" id="uploaded_file">
                            </div>
                        </div>
                        <div class="form-group" id="item-comp_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='1688.Örnek Ürün Dosyası'></label>
                            <div class="col col-8 col-xs-12"> 
                                <a  href="/IEF/standarts/import_example_file/Fiziki_Varlik_Aktarim.csv"><strong><cf_get_lang no='1692.İndir'></strong></a>
                            </div>
                        </div>
                        <div class="form-group" id="item-comp_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç"></label>
                            <div class="col col-8 col-xs-12"> 
                                <cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'>
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="false">
                        <div class="form-group">
                            <label class="col col-12 bold"><cf_get_lang dictionary_id='58594.Format'></label>
                        </div>
                        <div class="form-group" id="item-format">
                            <div class="col col-12"> 
                                <p><cf_get_lang dictionary_id='35657.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır'>. <cf_get_lang no ='2210.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır'>.<br>
                                    <cf_get_lang no='2968.Bu belgede olması gereken alan sayısı'> : 30.<br/>
                                        <cf_get_lang no='2214.Alanlar sırasıyla'>;<br>
                                    1-<cf_get_lang no='2793.Mülkiyet'> * (1:<cf_get_lang_main no='37.Satın Alma'>, 2:<cf_get_lang no='2796.Kiralama'>, 3:<cf_get_lang no='2799.Leasing'>, 4:<cf_get_lang no='2800.Sözleşme'>)<br/>
                                        2-<cf_get_lang_main no ='221.Barkod'><br/>
                                        3-<cf_get_lang_main no ='1655.Varlık'>/<cf_get_lang_main no ='1656.Plaka'> *<br/>
                                        4-<cf_get_lang no ='2784.Alınan Şirket'>(<cf_get_lang no='3124.Kurumsal Çalışan'> ID) * (<cf_get_lang dictionary_id='64282.Kurumsal Çalışan ID Girildiyse 5. alan Boş Bırakılmalıdır'>)<br/>
                                        5-<cf_get_lang no ='2784.Alınan Şirket'> (<cf_get_lang_main no='174.Bireysel Üye'> ID) * (<cf_get_lang dictionary_id='64283.Bireysel ID Girildiyse 4. alan Boş Bırakılmalıdır'>)<br/>
                                        6-<cf_get_lang no ='2785.Varlık Tipi'> ID *<br/>
                                        7-<cf_get_lang no ='773.Varlık Alt Kategorisi'> ID <br/>
                                        8-<cf_get_lang no ='2786.Kayıtlı Departman'> ID *<br/>
                                        9-<cf_get_lang no ='2787.Kullanıcı Departman'> ID<br/>
                                        10-<cf_get_lang_main no ='1718.Pozisyon Kodu'> * (<cf_get_lang dictionary_id='64284.Sorumlu Kişinin Pozisyon Kodu'>)<br/>
                                        11-<cf_get_lang no ='2789.Alış Tarihi'> *<br/>
                                        12-<cf_get_lang_main no ='1466.Demirbaş No'>(<cf_get_lang dictionary_id ='58602.Demirbaş'> <cf_get_lang dictionary_id ='63297.Id Girilmelidir'>) <br/>
                                        13-<cf_get_lang_main no ='225.Seri No'><br/>
                                        14-<cf_get_lang_main no ='377.Özel Kod'><br/>
                                        15-<cf_get_lang no ='2791.Servis Çalışanı'> ID<br/>
                                        16-<cf_get_lang_main no ='2316.Yakıt Tipi'> ID<br/>
                                        17-<cf_get_lang_main no ='344.Durum'> ID *<br/>
                                        18-<cf_get_lang_main no='728.İş Grubu'> ID<br/>
                                        19-<cf_get_lang no ='878.Kullanım Amacı'> ID<br/>
                                        20- <cf_get_lang dictionary_id='30040.Marka Tip Kategorisi'><cf_get_lang dictionary_id='58527.ID'>*<br/>
                                        21-<cf_get_lang_main no ='813.Model'> * (<cf_get_lang dictionary_id='58967.Örnek'>:2012)<br/>
                                        22-<cf_get_lang no ='3126.Renk'> (<cf_get_lang dictionary_id='64285.Araç Rengi'>)<br/>
                                        23-<cf_get_lang_main no ='1657.Motor No'><br/>
                                        24-<cf_get_lang_main no ='1658.Şase No'><br/>
                                        25-<cf_get_lang_main no ='217.Açıklama'><br/>
                                        26-<cf_get_lang no ='435.Değer'><br/>
                                        27-<cf_get_lang_main no ='77.Para Birimi'><br/>
                                        28-<cf_get_lang no ='2794.Ortak kullanım'> (<cf_get_lang dictionary_id='64286.Evet ise 1 yazılmalıdır'>)<br/>
                                        29-<cf_get_lang no ='3127.İlk KM'><br/>
                                        30-<cf_get_lang no ='3128.İlk Km Tarihi'><br/><br />
                                        <cf_get_lang_main no='55.NOT'>: (*) <cf_get_lang no ='3129.Yıldızlı Olanlar Zorunlu Alanlardır'>.                           
                            </div>
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
		return process_cat_control();
	}
</script>
