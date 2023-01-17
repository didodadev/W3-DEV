
<div class="col col-12 col-md-12 col-sm-12 col-xs-12" >
      <cf_box title="#getLang('','Norm Kadro Ciro Aktarımı','43276')#">
            <cfform name="export_form"  action="#request.self#?fuseaction=settings.emptypopup_norm_average" enctype="multipart/form-data">
                  <cf_box_elements>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                              <div class="form-group" id="item-norm_file">
                                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57691.Dosya'></label>
                                    <div class="col col-9 col-xs-12">  
                                          <input type="file" name="norm_file" id="norm_file">
                                    </div>
                              </div>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="1" sort="true">
                              <div class="form-group" id="item-norm_file">
                                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='1813.İlk satır başlık satırları olmak üzere'>;<br/>
                                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12"> 1.<cf_get_lang dictionary_id='44807.Kolon Tip (İlgili Şirket İçin 1 Şubeler için 2 Departmanlar için 3 yazılmalıdır)'>
                                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12">2.<cf_get_lang dictionary_id='44808.Kolon Organizasyon Adı / Numarası'></label>
                                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12">3.<cf_get_lang dictionary_id='43802.Kolon Yıl'>
                                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12">4.<cf_get_lang dictionary_id='44809.Kolon Ay'>
                                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12">5.<cf_get_lang dictionary_id='44810.Kolon Ciro'>
                                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12">6.<cf_get_lang dictionary_id='44811.Kolon Brüt Ücret'>
                                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12">7.<cf_get_lang dictionary_id='44812.Kolon Toplam Maliyet'>
                                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12">8.<cf_get_lang dictionary_id='44813.Kolon Para Birimi'></label>
                              </div>
                              <div class="form-group" id="item-norm_file">
                                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold"><cf_get_lang dictionary_id='57467.Not'> 1 : <cf_get_lang dictionary_id='62963.Lütfen sayısal değerleri nokta ile ayırınız'>.<cf_get_lang dictionary_id='58967.Örnek'> : 1215.38
                                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold"><cf_get_lang dictionary_id='57467.Not'> 2 : <cf_get_lang dictionary_id='62964.Toplam Maliyet ve Brüt Ücret Girmek İstemiyorsanız Kolonları Boş Bırakınız 0 (Sıfır) Dahil Hiçbir Değer Girmeyiniz'>!
                              </div>
                        </div>
                  </cf_box_elements>
                  <cf_box_footer>
                        <cf_workcube_buttons is_upd='0'>
                  </cf_box_footer>
		</cfform>
      </cf_box>
</div>