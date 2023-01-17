<!--- Proje İmport --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Proje Aktarım','45169')#">
        <cfform name="formimport" action="#request.self#?fuseaction=settings.emptypopup_add_project_import" enctype="multipart/form-data" method="post">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format">
                                <option value="utf-8"><cf_get_lang dictionary_id='32802.UTF-8'></option>
                            </select>
                        </div>
                    </div> 
                    <div class="form-group" id="item-file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file">
                        </div>
                    </div>   
                    <div class="form-group" id="item-example_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <a href="/IEF/standarts/import_example_file/Proje_Aktarim.csv"><strong><cf_get_lang no='1692.İndir'></strong></a>
                        </div>
                    </div>    
                    <div class="form-group" id="item-report_type">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36085.Aktarım Tipi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="report_type" id="report_type" onchange="rep_type();">
                                <option value="2"><cf_get_lang dictionary_id='63361.Üye No ya göre'></option>
                                <option value="1"><cf_get_lang dictionary_id='34702.ID ye göre'></option>
                            </select>
                        </div>
                    </div>                                                                   
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                    </div>   
                    <div class="form-group" id="item-exp1">
                        <cf_get_lang dictionary_id='36199.Açıklama'>:
                    </div> 
                    <div class="form-group" id="item-exp2">
                        <cf_get_lang dictionary_id='44342.Dosya uzantısı csv olmalı,alan araları noktalı virgül (;) ile ayrılmalı ve kaydedilirken karakter desteği olarak UTF-8 seçilmelidir'>
                    </div>  
                    <div class="form-group" id="item-exp3">
                        <cf_get_lang dictionary_id='54238.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır.'>
                    </div>    
                    <div class="form-group" id="item-exp4">
                        <cf_get_lang dictionary_id='44951.Bu belgede olması gereken alan sayısı'> : 22
                    </div>        
                    <div class="form-group" id="item-exp5">
                        <cf_get_lang dictionary_id='44197.Alanlar sırasıyla'>;
                    </div>  
                    <div class="form-group" id="item-exp6">
                        1-<cf_get_lang dictionary_id='31027.Proje Adı'> * : <cf_get_lang dictionary_id='63362.Proje adı bu alana yazılır'>.</br>
                        2-<cf_get_lang dictionary_id='57486.Kategori'> * : <cf_get_lang dictionary_id='63363.Proje kategori IDsini tutar'>.</br>
                        3-<cf_get_lang dictionary_id='57485.Öncelik'> * : <cf_get_lang dictionary_id='63364.Projenin öncelik IDsini tutar.'></br>
                        4-<cf_get_lang dictionary_id='58140.İş Grubu'> : <cf_get_lang dictionary_id='63365.İş grubu IDsini (work group _id) tutar'></br>
                        5-<cf_get_lang dictionary_id='30886.Proje No'> : <cf_get_lang dictionary_id='63366.Proje numarası text alana girilir.'></br>
                        6-<cf_get_lang dictionary_id='30044.Sözleşme No'> : <cf_get_lang dictionary_id='63367.Sözleşme numarası text alana girilir'>.</br>
                        7-<cf_get_lang dictionary_id='57574.Şirket'> * : <cf_get_lang dictionary_id='63368.Kurumsal çalışan ID veya Üye no girilir'>.(<cf_get_lang dictionary_id='63369.Bu alana değer girildiyse 8. alan boş bırakılmalıdır'>).</br>
                        8-<cf_get_lang dictionary_id='57574.Şirket'> * : <cf_get_lang dictionary_id='63371.Bireysel üye ID veya Üye no girilir.'>(<cf_get_lang dictionary_id='63372.Bu alana değer girildiyse 7. alan boş bırakılmalıdır'>.)</br>
                        9-<cf_get_lang dictionary_id='36199.Açıklama'> : <cf_get_lang dictionary_id='63374.Projenin açıklama alanı text olarak girilir'>.</br>
                        10-<cf_get_lang dictionary_id='57951.Hedef'> : <cf_get_lang dictionary_id='63375.Projenin hedef alanı text olarak girilir'></br>
                        11-<cf_get_lang dictionary_id='38175.Tahmini Bütçe'> :<cf_get_lang dictionary_id='63376.Tahmini bütçe bu alana girilir.'></br>
                        12-<cf_get_lang dictionary_id='63377.Tahmini Bütçe Para Birimi ID'> : <cf_get_lang dictionary_id='63378.Tahmini bütçenin para birimi IDsini tutar'>.</br>
                        13-<cf_get_lang dictionary_id='34752.Tahmini Maliyet'> : <cf_get_lang dictionary_id='63379.Tahmini maliyet bu alana girilir'>.</br>
                        14-<cf_get_lang dictionary_id='34752.Tahmini Maliyet'> <cf_get_lang dictionary_id='57489.Para Birimi'> <cf_get_lang dictionary_id='58527.ID'> : <cf_get_lang dictionary_id='63380.tahmini maliyetin para birimi IDsini tutar'></br>
                        15-<cf_get_lang dictionary_id='58930.Masraf'>/<cf_get_lang dictionary_id='58172.Gelir Merkezi'> : <cf_get_lang dictionary_id='63381.Projenin masraf ve gelir merkezi IDsini tutar. (expense_id)'></br>
                        16-<cf_get_lang dictionary_id='34997.İlişkili Proje'> : <cf_get_lang dictionary_id='63382.İlişkili Projenin IDsini tutar.'></br>
                        17-<cf_get_lang dictionary_id='58053.Başlangıç Tarihi'> * : <cf_get_lang dictionary_id='63383.Projenin başlangıç tarihini tutar'>.  (GG.AA.YYYY)</br>
                        18-<cf_get_lang dictionary_id='30961.Başlangıç Saati'> * : <cf_get_lang dictionary_id='63384.Projenin başlangıç saatini tutar'>. (SS:DD)</br>
                        19-<cf_get_lang dictionary_id='57700.Bitiş Tarihi'> * : <cf_get_lang dictionary_id='63385.Projenin bitiş tarihini tutar'>. (GG.AA.YYYY)</br>
                        20-<cf_get_lang dictionary_id='30959.Bitiş Saati'> * : <cf_get_lang dictionary_id='63386.Projenin bitiş saatini tutar.'> (SS:DD) </br>
                        21-<cf_get_lang dictionary_id='44021.Görevli'> * : <cf_get_lang dictionary_id='63387.Proje görevlisinin IDsi tutulur'>.</br>
                        22-<cf_get_lang dictionary_id='57482.Aşama'> * : <cf_get_lang dictionary_id='63388.Projenin Aşamasının IDsi tutulur.'></br>
                        <cf_get_lang dictionary_id='63343.NOT : (*) Yıldızlı Olanlar Zorunlu Alanlardır.'>
              
                    </div>                                               
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0'<!---  add_function='kontrol()' --->>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function rep_type()
	{
		if(document.formimport.report_type.value == 2){
			form_ul_id.style.display = 'none';
			form_ul_member_no.style.display = '';
		}
		else{
			form_ul_id.style.display = '';
			form_ul_member_no.style.display = 'none';
		}
	}
</script>
