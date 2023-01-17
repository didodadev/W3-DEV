<cf_catalystHeader>
    <cfform name="add_worknet" method="post">
      <div class="row">
        <div class="col col-12 uniqueRow">
          <div class="row formContent">
            <div class="row" type="row">
              <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-worknet">
                  <label class="col col-4 col-xs-12"><cf_get_lang no ='17.Worknet Adı'> *</label>
                  <div class="col col-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang no ='18.Worknet Adı Girmelisiniz'>!</cfsavecontent>
                    <cfinput type="text" name="worknet" required="yes" message="#message#" style="width:150px;" value="">
                  </div>
                </div>
                
                <div class="form-group" id="item-website">
                  <label class="col col-4 col-xs-12"><cf_get_lang no="302.Web Site"></label>
                  <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="website" maxlength="30" style="width:150px;" value="http://">
                  </div>
                </div>
                
                <div class="form-group" id="item-manager">
                  <label class="col col-4 col-xs-12"><cf_get_lang_main no='1714.Yönetici'></label>
                  <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="manager" value="" style="width:150px;">
                  </div>
                </div>
                <div class="form-group" id="item-manager_email">
                  <label class="col col-4 col-xs-12"><cf_get_lang no ='22.Yönetici E-mail'></label>
                  <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="manager_email" value="" style="width:150px;">
                  </div>
                </div>
                
              </div>
              <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-process_cat">
                  <label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç">*</label>
                  <div class="col col-8 col-xs-12">
                    <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                  </div>
                </div>
                <div class="form-group" id="item-worknet_status">
                  <label class="col col-4 col-xs-12"><cf_get_lang_main no ='81.Aktif'></label>
                  <div class="col col-8 col-xs-12">
                    <input type="checkbox" name="worknet_status" id="worknet_status" value="1">
                    
                  </div>
                </div>
                <div class="form-group" id="item-is_internet">
                  <label class="col col-4 col-xs-12"><cf_get_lang no ='25.İnternet Yayın'></label>
                  <div class="col col-8 col-xs-12">
                    <input type="checkbox" name="is_internet" id="is_internet" value="1">
                  </div>
                </div>
                <div class="form-group" id="item-detail">
                  <label class="col col-4 col-xs-12"><cf_get_lang_main no ='217.Açıklama'></label>
                  <div class="col col-8 col-xs-12">
                    <textarea name="detail" id="detail" style="width:150px;height:75px;"></textarea>
                  </div>
                </div>
              </div>
            </div>
            <div class="row" type="row">
              <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                <div class="form-group" id="item-domain">
                  <label class="col col-4 col-xs-12"><cf_get_lang_main no="480.Domain"> *</label>
                  <div class="col col-8 col-xs-12">
                    <select name="domain" id="domain" style="width:150px;">
                    <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                      <!---
                      <cfloop list="#worknet_url#" index="x" delimiters=";">
                          <cfoutput><option value="#x#">#x#</option></cfoutput>
                      </cfloop>
                    --->
                  </select>
                  </div>
                </div>
                <div class="form-group" id="item-sablon_file">
                  <label class="col col-4 col-xs-12"><cf_get_lang no="304.Genel Şablon Dosyası"></label>
                  <div class="col col-8 col-xs-12">
                    <input type="text" name="sablon_file" id="sablon_file" style="width:150px;" value="">
                  </div>
                </div>
                <div class="form-group" id="item-header_height">
                  <label class="col col-4 col-xs-12"><cf_get_lang_main no="573.Üst"> <cf_get_lang_main no="284.Yükseklik"></label>
                  <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="header_height" value="" onKeyUp="isNumber(this);" validate="integer" style="width:30px;" maxlength="4">
                  </div>
                </div>
              </div>
              <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                <div class="form-group" id="item-css_file">
                  <label class="col col-4 col-xs-12"><cf_get_lang no="306.CSS Dosyası"></label>
                  <div class="col col-8 col-xs-12">
                    <input type="text" name="css_file" id="css_file" style="width:150px;" value="">
                  </div>
                </div>
                <div class="form-group" id="item-general_width">
                  <label class="col col-4 col-xs-12"><cf_get_lang no="305.Sayfa Genişliği"></label>
                  <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="general_width" value="" onKeyUp="isNumber(this);" validate="integer" style="width:30px;" maxlength="4">
                  </div>
                </div>
              </div>
            </div>
            <div class="row formContentFooter">
              <div class="col col-12">
                <cf_workcube_buttons is_upd='0' add_function="kontrol()">
              </div>
            </div>
          </div>
        </div>
        
      </div>
    </cfform>
    
    <script type="text/javascript">
    function kontrol()
    {
        return process_cat_control();
    }
    </script>
    