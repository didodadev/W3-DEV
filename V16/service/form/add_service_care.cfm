<cf_catalystHeader>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cfform name="service_care" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=service.emptypopup_add_service_care">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <cfif isdefined("attributes.max_id")>
                            <cf_duxi type="hidden" name="id" id="id" value="<cfoutput>#attributes.max_id#</cfoutput>">
                        </cfif>
                        <cf_duxi name="status" type="checkbox" id="status" value="1" hint="Aktif" label="57493">           
                        <cf_duxi name="care_description" type="text" id="care_description" hint="Başlık" value="" label="58820" maxlength="100">
                        <cf_duxi type="hidden" name="product_id" id="product_id" value="">
                        <cf_duxi name="product_name" type="text" id="product_name" hint="Ürün *" label="63258" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','200');" value="" threepoint= "#request.self#?fuseaction=objects.popup_product_names&product_id=service_care.product_id&field_name=service_care.product_name">
                        <cf_duxi name="serial_no" type="text" id="serial_no" hint="Seri No" value="" label="57637">      
                        <cf_duxi name="mark" type="text" id="mark" value="" label="58847" hint="Marka">
                        <cf_duxi type="hidden" name="member_id" id="member_id" value="">
                        <cf_duxi type="hidden" name="member_type" id="member_type" value="">
                        <cf_duxi name="company" type="text" id="company" value="" hint="Alıcı Firma *" label="63259" threepoint="#request.self#?fuseaction=objects.popup_list_pars&field_id=service_care.member_id&field_comp_name=service_care.company&field_name=service_care.member_name&field_type=service_care.member_type&select_list=2,3,5,6">
                        <cf_duxi name="member_name" type="text" id="member_name" value="" Hint="Yetkili *" label="63260" message="#getLang('service',296)#">
                        <cf_duxi name="employee_id" id="employee_id" type="hidden" value="">
                        <cf_duxi name="employee" type="text" id="employee" value="" hint="Servis Çalışanı 1" label="63262" threepoint= "#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=service_care.employee_id&field_name=service_care.employee&select_list=1">
                        <cf_duxi name="employee_id2" id="employee_id2" type="hidden" value="">
                        <cf_duxi name="employee2" type="text" id="employee2" value="" hint="Servis Çalışanı 2" label="63263" threepoint= "#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=service_care.employee_id2&field_name=service_care.employee2&select_list=1">
                        <cf_duxi type="hidden" name="service_member_id" id="service_member_id" value="">
                        <cf_duxi type="hidden" name="service_member_type" id="service_member_type" value="">
                        <cf_duxi name="service_company" type="text" id="service_company" value="" hint="Servis Firması" label="41958" threepoint= "#request.self#?fuseaction=objects.popup_list_pars&field_id=service_care.service_member_id&field_comp_name=service_care.service_company&field_name=service_care.service_member_name&field_type=service_care.service_member_type&select_list=2,3,5,6">                   
                        <cf_duxi name="service_member_name" type="text" id="service_member_name" value="" hint="Servis Yetkilisi" label="47897">         
                        <cf_duxi name="aim" type="textarea" id="aim" value="" hint="Kullanım Amacı" label="56925">
                        <cf_duxi name="sales_date" data_control="date" id="sales_date" type="text" hint="Satış Tarihi" validate="#validate_style#" label="41754">                                                         
                        <cf_duxi name="guaranty_start_date" data_control="date" id="guaranty_start_date" type="text" hint="Garanti Başlangıç Tarihi" label="63212">                                             
                        <cf_duxi name="guaranty_finish_date" data_control="date" id="guaranty_finish_date" type="text" hint="Garanti Bitiş Tarihi" label="35287">                                             
                        <cf_duxi name="start_date" data_control="date" id="start_date" type="text" hint="Bakım Başlangıç Tarihi *" label="63261">                                   
                        <cf_duxi name="finish_date" data_control="date" id="finish_date" type="text" hint="Bakım Bitiş Tarihi *" label="63349">                                
                        <cf_duxi name="document" type="upload" id="document" value="" hint="Kullanım Belgesi" label="41755">                                    
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons 
                    is_upd='0'
                    data_action='/V16/service/cfc/service_care:ADD_SERVICE_CARE'
                    next_page='#request.self#?fuseaction=service.list_care&event=upd&id='>
                </cf_box_footer>         
            </cfform>
        </cf_box>
    </div>
    <script type="text/javascript">
        function kontrol()
        {
        if(care_description.value == '')
        {
            alertObject({message: "<cf_get_lang dictionary_id='63344.Lütfen Başlığı Doldurunuz'>!"});
            return false;
        }
        if(product_name.value == '')
        {
            alertObject({message: "<cf_get_lang dictionary_id='63345.Lütfen Ürün Bilgisini doldurunuz'>!"});
            return false;
        }
        if(member_name.value == '')
        {
            alertObject({message: "<cf_get_lang dictionary_id='63346.Lütfen Yetkili Bilgisini doldurunuz'>!"});
            return false;
        }
        if(start_date.value == '')
        {
            alertObject({message: "<cf_get_lang dictionary_id='63347.Lütfen Bakım Başlangıç Tarihini doldurunuz'>!"});
            return false;
        }
        if(finish_date.value == '')
        {
            alertObject({message: "<cf_get_lang dictionary_id='63348.Lütfen Bakım Bitiş Tarihini doldurunuz'>!"});
            return false;
        }
            return true;
        }
    </script>
        