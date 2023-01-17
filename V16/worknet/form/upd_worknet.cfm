
<cf_box_data asname="data_worknet" function="V16.worknet.cfc.worknet:select" conditions="wid=url.wid">
<cfset get_worknet = data_worknet>
<cfset pageHead = "#getlang('main','Pazaryeri',58158)#: #get_worknet.WORKNET#">
<cf_catalystHeader>
<cf_box>
  <cfform method="post" name="upd_worknet">
    <cf_box_elements addcol="1">
            <cf_duxi name="wid" type="hidden" value="attributes.wid">
            <cf_duxi name="is_active" type="switch" label="57493" data="get_worknet.WORKNET_STATUS">
            <cf_duxi name="worknet" type="text" data="get_worknet.WORKNET" label="58158">
            <cf_duxi name="website" type="text" data="data_worknet.WEBSITE" label="47050">
            <cf_duxi name="application_web_adress" type="text" data="get_worknet.APPLICATION_WEB_ADRESS" label="994">
            <cf_duxi name="company_id" type="hidden" data="get_worknet.COMPANY_ID">
            <cf_duxi name="company_name" type="text" data="get_worknet.FULLNAME" threepoint="#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=form_upd_worknet.company_id&is_period_kontrol=0&field_comp_name=form_upd_worknet.company_name&field_partner=form_upd_worknet.partner_id&field_name=form_upd_worknet.partner_name&par_con=1&select_list=2,3" label="57574">
            <cf_duxi name="partner_id" type="hidden" data="get_worknet.PARTNER_ID">
            <cf_duxi name="partner_name" type="text" value="#get_worknet.COMPANY_PARTNER_NAME# #get_worknet.COMPANY_PARTNER_SURNAME#" label="58885">
            <cf_duxi name="emp_id" type="hidden" data="get_worknet.MANAGER_EMP">
            <cf_duxi name="emp_name" type="text" label="29511" data="get_worknet.MANAGER" threepoint="#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form_upd_worknet.emp_id&field_name=form_upd_worknet.emp_name&field_emp_mail=form_upd_worknet.emp_email&select_list=1">
            <cf_duxi name="emp_email" type="text" label="42782" data="get_worknet.MANAGER_EMAIL">
            <cf_duxi name="detail" type="textarea" label="57771" data="get_worknet.DETAIL">
            <div class="form-group" id="item-logo">
              <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58637.Logo'></label>
              <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <cf_duxi name="logo" type="image" path="/documents/asset/watalogyImages/" data="get_worknet.IMAGE_PATH" value="/images/no_photo.gif" class="">    
                <cf_duxi name="upload_file" type="upload" class="pl-0">
              </div>
            </div>
    </cf_box_elements>
    <cf_box_footer>
      <cf_record_info query_name="get_worknet" record_emp="RECORD_EMP" update_emp="UPDATE_EMP">
      <cf_workcube_buttons is_upd='1' add_function='kontrol()'>
    </cf_box_footer>
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
    
    if(photo.value != ""){
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
    }
    return true;
  }
</script>
