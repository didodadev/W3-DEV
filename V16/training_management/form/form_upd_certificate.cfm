<cfset certificates= createObject("component","V16.training_management.cfc.certificates") />
<cfset get_certificates =certificates.get_certificates() />
<cfset get_list_certificates =certificates.get_list_certificates(training_certificate_id : attributes.training_certificate_id) />
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="upd_certificate" id="upd_certificate" method="post" action="">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-certificate">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46604.Sertifika'>*</label>
                        <div class="col col-8 col-xs-12">
                            <select id="certificate_id" name="certificate_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_certificates">
                                    <option value="#certificate_id#" <cfif get_list_certificates.certificate_id eq certificate_id>selected</cfif>>#certificate_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group large" id="form_ul_employee_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46604.Sertifika'><cf_get_lang dictionary_id='57662.Alan'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfif len(get_list_certificates.employee_id)>
                                <cfset employee_name= '#get_emp_info(get_list_certificates.employee_id,0,0)#'>
                            <cfelseif len(get_list_certificates.partner_id)>
                                <cfset employee_name= '#get_par_info(get_list_certificates.partner_id,1,1,0)#'>
                            <cfelseif len(get_list_certificates.consumer_id)>
                                <cfset employee_name= '#get_cons_info(get_list_certificates.consumer_id,0,0)#'>
                            </cfif>
                            <cfset approved_name ='#get_emp_info(get_list_certificates.approved_by,0,0)#'>
                            <cfset approved_name_2 ='#get_emp_info(get_list_certificates.approved_by_2,0,0)#'>
                            <cfset prepared_name ='#get_emp_info(get_list_certificates.prepared_by,0,0)#'>
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="employee_id" id="employee_id" value="<cfif len(get_list_certificates.employee_id)>#get_list_certificates.employee_id#</cfif>">
                                    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(get_list_certificates.consumer_id)>#get_list_certificates.consumer_id#</cfif>">
                                    <input type="hidden" name="partner_id" id="partner_id" value="<cfif len(get_list_certificates.partner_id)>#get_list_certificates.partner_id#</cfif>">
                                    <input type="text" name="employee_name" id="employee_name" value="#employee_name#" >
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_partner=upd_certificate.partner_id&field_emp_id=upd_certificate.employee_id&field_comp_id=upd_certificate.consumer_id&field_name=upd_certificate.employee_name&select_list=1,2,3</cfoutput>');"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-prepared_by">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29775.Hazırlayan'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="prepared_by" id="prepared_by" value="<cfif len(get_list_certificates.prepared_by)>#get_list_certificates.prepared_by#</cfif>">
                                    <input type="text" name="prepared_name" id="prepared_name" value="#prepared_name#" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','consumer_id,PARTNER_ID,EMPLOYEE_ID','consumer_id,partner_id,employee_id','','3','200','get_company()');" passthrough="readonly">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_certificate.prepared_by&field_name=upd_certificate.prepared_name&select_list=1,2</cfoutput>');"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-approved_by">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'> -1</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="approved_by" id="approved_by" value="<cfif len(get_list_certificates.approved_by)>#get_list_certificates.approved_by#</cfif>">
                                    <input type="text" name="approved_name" id="approved_name" value="#approved_name#" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','consumer_id,PARTNER_ID,EMPLOYEE_ID','consumer_id,partner_id,employee_id','','3','200','get_company()');" passthrough="readonly">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_certificate.approved_by&field_name=upd_certificate.approved_name&select_list=1,2</cfoutput>');"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-approved_by2">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'> -2</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="approved_by_2" id="approved_by_2" value="<cfif len(get_list_certificates.approved_by_2)>#get_list_certificates.approved_by_2#</cfif>">
                                    <input type="text" name="approved_name_2" id="approved_name_2" value="#approved_name_2#" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','consumer_id,PARTNER_ID,EMPLOYEE_ID','consumer_id,partner_id,employee_id','','3','200','get_company()');" passthrough="readonly">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_certificate.approved_by_2&field_name=upd_certificate.approved_name_2&select_list=1,2</cfoutput>');"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-process">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"> *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cf_workcube_process is_upd='0' select_value='#get_list_certificates.status_id#' process_cat_width='140' is_detail='1'>
                            <input type="hidden" name="process_stage" id="process_stage" value="<cfif len(get_list_certificates.status_id)>#get_list_certificates.status_id#</cfif>">
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_prepared_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62548.Hazırlanma Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Lütfen Tarih Değerini Kontrol Ediniz'> !</cfsavecontent>
                                <cfinput type="text" name="prepared_date" id="prepared_date" value="#dateformat(get_list_certificates.prepared_date,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="prepared_date"></span>                 
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_get_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32619.Alım Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Lütfen Tarih Değerini Kontrol Ediniz'> !</cfsavecontent>
                                    <cfinput type="text" name="get_date" id="get_date" value="#dateformat(get_list_certificates.get_date,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="get_date"></span>                 
                                </div>
                            </div>
                    </div>
                    <div class="form-group" id="form_ul_validity">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Lütfen Tarih Değerini Kontrol Ediniz'> !</cfsavecontent>
                                <cfinput type="text" name="date_of_validity" id="date_of_validity" value="#dateformat(get_list_certificates.date_of_validity,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10"  >
                                <span class="input-group-addon"><cf_wrk_date_image date_field="date_of_validity"></span>                 
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_validity">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <cfoutput><textarea id="detail" name="detail">#get_list_certificates.detail#</textarea></cfoutput>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_record_info query_name="get_list_certificates">
                <cf_workcube_buttons is_upd="1" add_function="upd_form()" delete_page_url="V16/training_management/cfc/certificates.cfc?method=DEL_TRAINING_CERTIFICATE&training_certificate_id=#attributes.training_certificate_id#">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script>
function del_form(id) {
    document.upd_certificate.action="V16/training_management/cfc/certificates.cfc?method=DEL_TRAINING_CERTIFICATE&training_certificate_id="+id; 
    window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.certificates';
    return true;   
}
    function upd_form(){    

        if (document.getElementById('certificate_id').value == '') {
                alert("<cfoutput><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='46604.Sertifika'></cfoutput>"); 
                return false;
            }
        if ((document.getElementById('employee_id').value == '' || document.getElementById('partner_id').value == '' || document.getElementById('consumer_id').value == '') && document.getElementById('employee_name').value == '' ) {
            alert("<cfoutput><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='46604.Sertifika'><cf_get_lang dictionary_id='57662.Alan'></cfoutput>"); 
            return false;
        }
        if(datediff(document.getElementById('get_date').value,document.getElementById('date_of_validity').value,0)<0)
        {
            alert("<cf_get_lang dictionary_id='48144.Alım Tarihi'><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'>'nden <cf_get_lang dictionary_id='60593.büyük olamaz'> !");
            return false;
        }  
      certificate_id_ = document.getElementById("certificate_id").value;
      employee_id_ = document.getElementById("employee_id").value;
      consumer_id_ = document.getElementById("consumer_id").value;
      partner_id_ = document.getElementById("partner_id").value;
      get_date_ = document.getElementById("get_date").value;
      date_of_validity_ = document.getElementById("date_of_validity").value;
      detail_ =  document.getElementById("detail").value;
      training_certificate_id_ = <cfoutput>#attributes.training_certificate_id#</cfoutput>;
      prepared_by_ =  document.getElementById("prepared_by").value;
      approved_by_ =  document.getElementById("approved_by").value;
      approved_by_2_ =  document.getElementById("approved_by_2").value;
      prepared_date_ =  document.getElementById("prepared_date").value;
      process_stage_ = document.getElementById("process_stage").value;
      $.ajax({ 
          type:'POST',  
          url:'/V16/training_management/cfc/certificates.cfc?method=UPD_TRAINING_CERTIFICATE',
          data: { 
                training_certificate_id : training_certificate_id_,
              certificate_id : certificate_id_, 
              employee_id : employee_id_,
              consumer_id : consumer_id_,
              partner_id: partner_id_,
              get_date : get_date_,
              date_of_validity : date_of_validity_,
              detail : detail_,
              prepared_by:prepared_by_,
              approved_by:approved_by_,
              approved_by_2:approved_by_2_,
              prepared_date:prepared_date_,
              process_stage: process_stage_
          },
          success: function (returnData) {
              window.location.href='<cfoutput>#request.self#?fuseaction=training_management.certificates&event=upd&training_certificate_id=#attributes.training_certificate_id#</cfoutput>';
              return true;
          },
          error: function () 
          {
              console.log('CODE:8 please, try again..');
              return false; 
          }
      }); 
       return false;        	        
  }
</script>