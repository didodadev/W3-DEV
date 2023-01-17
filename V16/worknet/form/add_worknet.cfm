<cf_catalystHeader>
<cfsavecontent variable="message"><cf_get_lang_main no='746.Pazaryeri'>:<cf_get_lang_main no='2352.Yeni Kayıt'></cfsavecontent>
<cf_box id="formAddMarketplace" closable="0" collapsable="0" title="#message#">
  <cfform name="form_add_worknet" method="post" action="" enctype="multipart/form-data">     
    <cf_box_elements>
      <!--- Left --->
      <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
        <div class="form-group" id="item-marketplace">
          <label class="col col-3 col-xs-12"><cf_get_lang_main no='746.Pazaryeri'> *</label>
          <div class='col col-6 col-xs-12'>
            <input type='text' name='worknet' id="worknet"/>
          </div>
        </div>
        <div class="form-group" id="item-website">
          <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='47050.Web Site'> *</label>
          <div class='col col-6 col-xs-12'>
            <input type='text' name='website' id="website"/>
          </div>
        </div>
        <div class="form-group" id="item-path">
          <label class="col col-3 col-xs-12" style="display:none;"><cf_get_lang dictionary_id='50663'></label>
          <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58637.Logo'> *</label>
          <div class='col col-6 col-xs-12'>
            <input type='file' name='upload_file' id="upload_file" style="width:200px;" required/>
          </div>
        </div>
        <div class="form-group" id="item-detail">
          <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57771.Detay'> *</label>
          <div class='col col-6 col-xs-12'>
            <textarea type='text' name='detail' id="detail" style="width:150px;height:60px;"></textarea>
          </div>
        </div>
        <div class="form-group" id="item-company">
          <label class="col col-3 col-xs-12"><cf_get_lang_main no='162.Şirket'> *</label>
          <div class='col col-6 col-xs-12'>
            <div class="input-group">
              <input type="hidden" name="company_id" id="company_id" value="">
              <input type="text" name="company_name" id="company_name" value="" readonly>
              <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=form_add_worknet.company_id&is_period_kontrol=0&field_comp_name=form_add_worknet.company_name&field_partner=form_add_worknet.partner_id&field_name=form_add_worknet.partner_name&par_con=1&select_list=2,3</cfoutput>','list')"></span>
            </div>
          </div>
        </div>
        <div class="form-group" id="item-partner">
          <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58885.Partner'> *</label>
          <div class='col col-6 col-xs-12'>
            <input type="hidden" name="partner_id" id="partner_id" value="">
            <input type="text" name="partner_name" id="partner_name" value="" readonly>
          </div>
        </div>
      </div>
      <!--- --->
      <!--- Right --->
      <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
        <div class="form-group" id="item-active">
          <label class="col col-3 col-xs-12"><cf_get_lang_main dictionary_id='57493.Aktif'></label>
          <div class='col-6 col-xs-12'>
            <div class="col-6 col-xs-12 checkbox checbox-switch">
              <label>
                  <input type="checkbox" name="is_active" checked="checked" />
                  <span></span>
              </label>
            </div>
          </div>
        </div>
        <div class="form-group" id="item-process_stage">
          <label class="col col-3 col-xs-12"><cf_get_lang_main no="1447.Süreç"> *</label>
          <div class="col col-6 col-xs-12">
            <cf_workcube_process is_upd='0' is_detail='0'>
          </div>
        </div>
        <div class="form-group" id="item-director">
          <label class="col col-3 col-xs-12"><cf_get_lang_main no='1714.Yönetici'> *</label>
          <div class='col col-6 col-xs-12'>
            <div class="input-group">
              <input type="hidden" name="emp_id" id="emp_id" value="">
              <input type='text' name='emp_name' id="emp_name" value="" readonly/>
              <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form_add_worknet.emp_id&field_name=form_add_worknet.emp_name&field_emp_mail=form_add_worknet.emp_email&select_list=1</cfoutput>','list');"></span>
            </div>
          </div>
        </div>
        <div class="form-group" id="item-director-email">
          <label class="col col-3 col-xs-12"><cf_get_lang no='22.Yönetici E-mail'> *</label>
          <div class='col col-6 col-xs-12'>
            <input type='text' name='emp_email' id="emp_email" value=""/>
          </div>
        </div>
      </div>
      <!--- --->
    </cf_box_elements>
    <!--- Button --->
        <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
    <!--- --->
  </cfform>
</cf_box>

<script type="text/javascript">
  function kontrol()
  {
    if(worknet.value == ''){
      alertObject({message: "Pazaryeri alanı boş gecilemez!"});
      return false;
    }
    if(website.value == ''){
      alertObject({message: "Website alanı boş gecilemez!"});
      return false;
    }
    if(detail.value == ''){
      alertObject({message: "Detay alanı boş gecilemez!"});
      return false;
    }
    if(company_id.value == '' || company_name.value == '' || partner_id.value == '' || partner_name.value == ''){
      alertObject({message: "Şirket ve partner alanları boş gecilemez!"});
      return false;
    }
    if(emp_id.value == '' || emp_name.value == '' || emp_email.value == ''){
      alertObject({message: "Yönetici alanları boş gecilemez!"});
      return false;
    }
    var photo = document.getElementById('upload_file');
    var photoSize = photo.files[0].size;
    if(photoSize > 51200){
        alert("<cf_get_lang dictionary_id='48411'>");
        return false;
    }
    var obj =  photo.value.toUpperCase();
    var obj_ = list_len(obj,'.');
    var uzanti_ = list_getat(obj,list_len(obj,'.'),'.');
    if(obj!='' && uzanti_!='GIF' && uzanti_!='PNG' && uzanti_!='JPG' && uzanti_!='JPEG') 
    {
      alert("<cf_get_lang dictionary_id='56078.Lütfen bir resim dosyası(gif,jpg,jpeg veya png) giriniz'>!");        
      return false;
    }
    return true;
    //return process_cat_control();
  }

  /*function bs_input_file() {
    $(".input-file").before(
      function() {
        if ( ! $(this).prev().hasClass('input-ghost') ) {
          var element = $("<input type='file' class='input-ghost' style='visibility:hidden; height:0'>");
          element.attr("name",$(this).attr("name"));
          element.change(function(){
            element.next(element).find('input').val((element.val()).split('\\').pop());
          });
          $(this).find("button.btn-choose").click(function(){
            element.click();
          });
          $(this).find("button.btn-reset").click(function(){
            element.val(null);
            $(this).parents(".input-file").find('input').val('');
          });
          $(this).find('input').css("cursor","pointer");
          $(this).find('input').mousedown(function() {
            $(this).parents('.input-file').prev().click();
            return false;
          });
          return element;
        }
      }
    );
  }
  $(function() {
    bs_input_file();
  });*/

</script>
