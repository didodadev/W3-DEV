<cfset certificates= createObject("component","V16.training_management.cfc.certificates") />
<cfset get_certificates =certificates.get_certificates() />
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
<cf_box>
    <cfform name="add_certificate" id="add_certificate" method="post" action="V16/training_management/cfc/certificates.cfc?method=ADD_TRAINING_CERTIFICATE">
        <cf_box_elements>
            <div class="col col-6 col-xs-12">
            <div class="form-group">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46604.Sertifika'>*</label>
                <div class="col col-8 col-xs-12">
                    <select id="certificate_id" name="certificate_id">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_certificates">
                        <option value="#certificate_id#">#certificate_name#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
            <div class="form-group" id="form_ul_employee_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46604.Sertifika'><cf_get_lang dictionary_id='57662.Alan'>*</label>
                    <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <cfoutput>
                            <input type="hidden" name="employee_id" id="employee_id" value="">
                            <input type="hidden" name="consumer_id" id="consumer_id" value="">
                            <input type="hidden" name="partner_id" id="partner_id" value="">
                            <input type="text" name="employee_name" id="employee_name" value="" passthrough="readonly">
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&is_period_kontrol=0&field_location=service&field_emp_id=add_certificate.employee_id&field_partner=add_certificate.partner_id&field_consumer=add_certificate.consumer_id&field_name=add_certificate.employee_name&select_list=1,2,3</cfoutput>');"></span>
                        </cfoutput>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-prepared_by">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29775.Hazırlayan'></label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="input-group">
                        <cfoutput>
                            <input type="hidden" name="prepared_by" id="prepared_by" value="">
                            <input type="text" name="prepared_name" id="prepared_name" value="" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','consumer_id,PARTNER_ID,EMPLOYEE_ID','consumer_id,partner_id,employee_id','','3','200','get_company()');" passthrough="readonly">
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_certificate.prepared_by&field_name=add_certificate.prepared_name&select_list=1,2</cfoutput>');"></span>
                        </cfoutput>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-approved_by">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'> -1</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="input-group">
                        <cfoutput>
                            <input type="hidden" name="approved_by" id="approved_by" value="">
                            <input type="text" name="approved_name" id="approved_name" value="" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','consumer_id,PARTNER_ID,EMPLOYEE_ID','consumer_id,partner_id,employee_id','','3','200','get_company()');" passthrough="readonly">
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_certificate.approved_by&field_name=add_certificate.approved_name&select_list=1,2</cfoutput>');"></span>
                        </cfoutput>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-approved_by2">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'> -2</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="input-group">
                        <cfoutput>
                            <input type="hidden" name="approved_by_2" id="approved_by_2" value="">
                            <input type="text" name="approved_name_2" id="approved_name_2" value="" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','consumer_id,PARTNER_ID,EMPLOYEE_ID','consumer_id,partner_id,employee_id','','3','200','get_company()');" passthrough="readonly">
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_certificate.approved_by_2&field_name=add_certificate.approved_name_2&select_list=1,2</cfoutput>');"></span>
                        </cfoutput>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-process">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"> *</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cf_workcube_process is_upd='0' process_cat_width='140' is_detail='0'>
                    <input type="hidden" name="process_stage" id="process_stage" value="">
                </div>
            </div>
            <div class="form-group" id="form_ul_prepared_date">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62548.Hazırlanma Tarihi'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Lütfen Tarih Değerini Kontrol Ediniz'> !</cfsavecontent>
                            <cfinput type="text" name="prepared_date" id="prepared_date" value="" validate="#validate_style#" message="#message#" maxlength="10">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="prepared_date"></span>                 
                        </div>
                    </div>
            </div>
            <div class="form-group" id="form_ul_get_date">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32619.Alım Tarihi'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Lütfen Tarih Değerini Kontrol Ediniz'> !</cfsavecontent>
                            <cfinput type="text" name="get_date" id="get_date" value="" validate="#validate_style#" message="#message#" maxlength="10">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="get_date"></span>                 
                        </div>
                    </div>
            </div>
            <div class="form-group" id="form_ul_validity">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Lütfen Tarih Değerini Kontrol Ediniz'> !</cfsavecontent>
                        <cfinput type="text" name="date_of_validity" id="date_of_validity" value="" validate="#validate_style#" message="#message#" maxlength="10"  >
                        <span class="input-group-addon"><cf_wrk_date_image date_field="date_of_validity"></span>                 
                    </div>
                </div>
            </div>
            <div class="form-group" id="form_ul_detail">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                <div class="col col-8 col-xs-12">
                  <textarea id="detail" name="detail"></textarea>
                </div>
            </div>
        </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd="0"   add_function='save_form()'>
        </cf_box_footer>
    </cfform>
</cf_box>
</div>
<script>
      function save_form(){    
        if (document.getElementById('certificate_id').value == '') {
                alert("<cfoutput><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='46604.Sertifika'></cfoutput>"); 
                return false;
            }
        if ((document.getElementById('employee_id').value == '' || document.getElementById('partner_id').value == '' || document.getElementById('consumer_id').value == '' ) && document.getElementById('employee_name').value == '') {
            alert("<cfoutput><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='46604.Sertifika'><cf_get_lang dictionary_id='57662.Alan'></cfoutput>"); 
            return false;
        }
        if(datediff(document.getElementById('get_date').value,document.getElementById('date_of_validity').value,0)<0)
        {
            alert("<cf_get_lang dictionary_id='48144.Alım Tarihi'><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'>den<cf_get_lang dictionary_id='60593.büyük olamaz'> !");
            return false;
        }  

       /*  certificate_id_ = document.getElementById("certificate_id").value;
        employee_id_ = document.getElementById("employee_id").value;
        consumer_id_ = document.getElementById("consumer_id").value;
        partner_id_ = document.getElementById("partner_id").value;
        get_date_ = document.getElementById("get_date").value;
        date_of_validity_ = document.getElementById("date_of_validity").value;
        detail_ =  document.getElementById("detail").value;
        prepared_by_ =  document.getElementById("prepared_by").value;
        approved_by_ =  document.getElementById("approved_by").value;
        approved_by_2_ =  document.getElementById("approved_by_2").value;
        prepared_date_ =  document.getElementById("prepared_date").value;
        process_stage_ = document.getElementById("process_stage").value;
        
        $.ajax({ 
            type:'POST',  
            url:'/V16/training_management/cfc/certificates.cfc?method=ADD_TRAINING_CERTIFICATE',
            data: { 
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
                id = JSON.parse(returnData);
                window.location.href='<cfoutput>#request.self#?fuseaction=training_management.certificates&event=upd&training_certificate_id=</cfoutput>id';
                return true;
            },
            error: function () 
            {
                console.log('CODE:8 please, try again..');
                return false; 
            }
        }); 
         return false;       	         */
    }
</script>