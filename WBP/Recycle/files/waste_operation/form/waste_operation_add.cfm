<cf_xml_page_edit>

<cfquery name = "get_waste_product_cat" datasource="#dsn3#">
    SELECT HIERARCHY, PRODUCT_CAT FROM PRODUCT_CAT WHERE HIERARCHY = '#waste_product_cat_code#'
</cfquery>

<cfparam name="attributes.car_entry_time" default="">
<cfparam name="attributes.car_exit_time" default="">

<cf_papers paper_type="waste_operation">

<cfinclude template="../../header.cfm">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform name="waste_operation_form" id="waste_operation_form" enctype="multipart/form-data">
        <cf_box>
            <input type="hidden" name="dsn" id="dsn" value="<cfoutput>#dsn#</cfoutput>">
            <cfoutput>
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process_type">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_workcube_process is_upd='0' process_cat_width='250' is_detail='0'></div>
                        </div>
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">İşlem Kategorisi</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_workcube_process_cat is_upd='0' process_cat_width='250' is_detail='0' module_id='92'></div>
                        </div>
                        <div class="form-group" id="item-general_paper_no">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="57880.Belge No">*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text" name="general_paper_no" id="general_paper_no" value="#paper_full#"></div>
                        </div>
                        <div class="form-group" id="item-department_location">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30031.Location'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">  
                                <cf_wrkdepartmentlocation
                                    returninputvalue="location_id,department_name,department_id,branch_id"
                                    returninputquery="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                    fieldname="department_name"
                                    fieldid="location_id"
                                    department_fldid="department_id"
                                    branch_fldid="branch_id"
                                    user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                    width="135">
                            </div>
                        </div>
                        <div class="form-group" id="item-bo_number">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62116.BO Numarası'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text" value="" name="bo_number" id="bo_number"></div>
                        </div>
                        <div class="form-group" id="item-product_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no ='245.Ürün'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="stock_id"  id="stock_id">
                                    <input type="hidden" name="main_unit_id"  id="main_unit_id">
                                    <input type="hidden" name="product_id"  id="product_id">
                                    <input type="text" name="product_name" id="product_name" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','form','3','200');" style="width:100px;">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=waste_operation_form.product_id&field_id=waste_operation_form.stock_id&field_main_unit=waste_operation_form.main_unit_id&field_name=waste_operation_form.product_name&product_cat_code=#get_waste_product_cat.hierarchy#&product_cat=#get_waste_product_cat.product_cat#','list');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-carNumber">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62118.Çekici Plaka'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text" value="" name="carNumber" id="carNumber"></div>
                        </div>
                        <div class="form-group" id="item-dorse_plaka">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62130.Dorse Plaka'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text" value="" name="dorse_plaka" id="dorse_plaka"></div>
                        </div>
                        <div class="form-group" id="item-member_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34578.Firma Adı'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="consumer_id" id="consumer_id">
                                    <input type="hidden" name="company_id" id="company_id">
                                    <input type="hidden" name="member_type" id="member_type">
                                    <input name="member_name" type="text" id="member_name" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" autocomplete="off">
                                    <cfset str_linke_ait="&field_consumer=waste_operation_form.consumer_id&field_comp_id=waste_operation_form.company_id&field_member_name=waste_operation_form.member_name&field_type=waste_operation_form.member_type">
                                    <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput>&select_list=7,8&keyword='+encodeURIComponent(document.waste_operation_form.member_name.value),'list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-carrier_member_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='39248.Taşıyıcı Firma'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="carrier_consumer_id" id="carrier_consumer_id">
                                    <input type="hidden" name="carrier_company_id" id="carrier_company_id">
                                    <input type="hidden" name="carrier_member_type" id="carrier_member_type">
                                    <input name="carrier_member_name" type="text" id="carrier_member_name" onFocus="AutoComplete_Create('carrier_member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','carrier_consumer_id,carrier_company_id,carrier_member_type','','3','250');" value="<cfif isdefined("attributes.carrier_member_name") and len(attributes.carrier_member_name)><cfoutput>#attributes.carrier_member_name#</cfoutput></cfif>" autocomplete="off">
                                    <cfset str_linke_ait2="&field_consumer=waste_operation_form.carrier_consumer_id&field_comp_id=waste_operation_form.carrier_company_id&field_member_name=waste_operation_form.carrier_member_name&field_type=waste_operation_form.carrier_member_type">
                                    <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait2#</cfoutput>&select_list=7,8&keyword='+encodeURIComponent(document.waste_operation_form.carrier_member_name.value)+'&function_name=getCompanyEmployees','list');"></span>
                                    <span class="input-group-addon btnPointer" onclick="getMemberDocuments();"><i class="fa fa-search"></i></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-driver_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='60933.Şoför'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <select name="driver_id" id="driver_id">
                                        <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    </select>
                                    <span class="input-group-addon btnPointer" onclick="getDriverDocuments();"><i class="fa fa-search"></i></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-driver_yrd_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62117.Yardımcı Şoför'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="yrd_driver_id" id="yrd_driver_id">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-car_entry_time">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30961.Başlangıç Saati'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="car_entry_time" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10" message="" readonly>
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="car_entry_time"></span>
                                </div>
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <cf_wrkTimeFormat name="car_entry_hour" value="#hour(now())#">
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <select name="car_entry_minute" id="car_entry_minute">
                                    <cfloop from="0" to="59" index="a">
                                        <cfoutput><option value="#Numberformat(a,00)#" #Numberformat(a,00) eq minute(now()) ? 'selected' : ''#>#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-car_entry_kg">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58548.İlk'><cf_get_lang dictionary_id='29784.Ağırlık'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='1738.Geçerli Tutar Girmelisiniz!'></cfsavecontent>
                                    <cfinput type="text" name="car_entry_kg" id="car_entry_kg" class="moneybox" value="" style="width:120px;" required="yes" message="#message#" onkeyup="return(FormatCurrency(this,event));">
                                    <span class="input-group-addon icon-refresh btnPointer" onclick="getWeighbridge('car_entry_kg')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-car_exit_time">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30959.Bitiş Saati'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="car_exit_time" value="#dateformat(attributes.car_exit_time,dateformat_style)#" validate="#validate_style#" maxlength="10" message="">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="car_exit_time"></span>
                                </div>
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <cf_wrkTimeFormat name="car_exit_hour">
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <select name="car_exit_minute" id="car_exit_minute">
                                    <cfloop from="0" to="59" index="a">
                                        <cfoutput><option value="#Numberformat(a,00)#">#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-car_exit_kg">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29398.Son'><cf_get_lang dictionary_id='29784.Ağırlık'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='1738.Geçerli Tutar Girmelisiniz!'></cfsavecontent>
                                    <cfinput type="text" name="car_exit_kg" id="car_exit_kg" class="moneybox" value="" style="width:120px;" message="#message#" onkeyup="return(FormatCurrency(this,event));">
                                    <span class="input-group-addon icon-refresh btnPointer" onclick="getWeighbridge('car_exit_kg')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-property_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='655.Döküman Tipi'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_wrk_selectlang
                                    name="property_id"
                                    width="250"
                                    table_name="CONTENT_PROPERTY"
                                    option_name="NAME"
                                    value=""
                                    option_value="CONTENT_PROPERTY_ID">
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons add_function="kontrol()">
                </cf_box_footer>
            </cfoutput>
        </cf_box>
        <div id = "waste_operation_documents"></div>
    </cfform>
</div>
<script>
    $( document ).ready(function() {
        AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=recycle.waste_operation_documents&driver_id='+driver_id+'','waste_operation_documents');
    });

    function kontrol() {
        if(waste_operation_form.general_paper_no.value == "")
        {
            alert("<cf_get_lang dictionary_id="57880.Belge No"> <cf_get_lang dictionary_id='30941.Boş'>!");
            return false;
        }
        if(waste_operation_form.carNumber.value == "")
        {
            alert("<cf_get_lang dictionary_id='62118.Çekici Plaka'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if(waste_operation_form.dorse_plaka.value == "")
        {
            alert("<cf_get_lang dictionary_id='62130.Dorse Plaka'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if((waste_operation_form.consumer_id.value == "" || waste_operation_form.member_name.value == "") && (waste_operation_form.company_id.value == "" || waste_operation_form.member_name.value == ""))
        {
            alert("<cf_get_lang dictionary_id='38282.Cari Hesap Seçmelisiniz'>");	
            return false;
        }
        if((waste_operation_form.carrier_consumer_id.value == "" || waste_operation_form.carrier_member_name.value == "") && (waste_operation_form.carrier_company_id.value == "" || waste_operation_form.carrier_member_name.value == ""))
        {
            alert("<cf_get_lang dictionary_id='39248.Taşıyıcı Firma'> <cf_get_lang dictionary_id='30941.Boş'>!");
            return false;
        }
        if(waste_operation_form.product_id.value == "" || waste_operation_form.product_name.value == "")
        {
            alert("<cf_get_lang_main no ='245.Ürün'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if(waste_operation_form.property_id.value == ""){
            alert("<cf_get_lang_main no='655.Döküman Tipi'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if(waste_operation_form.driver_id.value != "" && waste_operation_form.yrd_driver_id.value != "" && waste_operation_form.driver_id.value == waste_operation_form.yrd_driver_id.value){
            alert('<cfoutput>#getLang(dictionary_id:62163)#</cfoutput>');
            return false;
        }
        /* paper_control(waste_operation_form.general_paper_no,'WASTE_ACCEPTANCE',true,'','','','','','',1); */
        unformat_fields();
        return true;
    }
    function unformat_fields()
    {
        if(document.waste_operation_form.car_entry_kg.value != "") document.waste_operation_form.car_entry_kg.value = filterNum(document.waste_operation_form.car_entry_kg.value);
        if(document.waste_operation_form.car_exit_kg.value != "") document.waste_operation_form.car_exit_kg.value = filterNum(document.waste_operation_form.car_exit_kg.value);
    }

    function getWeighbridge(element) {
        /*
        if( document.waste_operation_form.carNumber.value != ""){
            var data = new FormData();
            data.append("plaka", document.waste_operation_form.carNumber.value);
            AjaxControlPostDataJson('WBP/Recycle/files/cfc/refinery.cfc?method=getWasteOil_weighbridge', data, function(response) {
                if( element == 'car_entry_kg' ) document.waste_operation_form.car_entry_kg.value = commaSplit(response.TARTIM_1);
                else if( element == 'car_exit_kg' ) document.waste_operation_form.car_exit_kg.value = commaSplit(response.TARTIM_2);
            });
        }else alert("<cf_get_lang dictionary_id='62130.Dorse Plaka'> <cf_get_lang dictionary_id='30941.Boş'>!");
        */
       alert('Kantar entegrasyonu yapılmadan kullanılamaz.');
    }

    function getCompanyEmployees(id, empty_var) {

        setTimeout(function() { 
            member_type = $('#carrier_member_type').val();

            $('#driver_id').empty();
            $('#driver_id').append(new Option('<cf_get_lang dictionary_id="57734.Seçiniz">', ''));

            $('#yrd_driver_id').empty();
            $('#yrd_driver_id').append(new Option('<cf_get_lang dictionary_id="57734.Seçiniz">', ''));

            if(member_type == 'partner'){

                var cmp_partners = wrk_safe_query('get_company_partners','dsn',0,id);

                if(cmp_partners.recordcount){

                    for(i = 0; i < cmp_partners.recordcount; i++){

                        $('#driver_id').append(new Option(cmp_partners.COMPANY_PARTNER_NAME[i] + ' ' + cmp_partners.COMPANY_PARTNER_SURNAME[i], cmp_partners.PARTNER_ID[i]));
                    
                        $('#yrd_driver_id').append(new Option(cmp_partners.COMPANY_PARTNER_NAME[i] + ' ' + cmp_partners.COMPANY_PARTNER_SURNAME[i], cmp_partners.PARTNER_ID[i]));

                    }

                }

            }
        }, 500);
    }

    /*

    function getMemberDocuments() {
        dorse_plaka = '';
        member_type = '';
        if($('#dorse_plaka').val() == ''){
            alert("<cf_get_lang dictionary_id='62130.Dorse Plaka'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        else dorse_plaka = $('#dorse_plaka').val();

        if($('#carrier_member_type').val() == "" && ($('#carrier_consumer_id').val() == "" || $('#carrier_member_name').val() == "") && ($('#carrier_company_id').val() == "" || $('#carrier_member_name').val() == "")){
            alert("<cf_get_lang dictionary_id='39248.Taşıyıcı Firma'> <cf_get_lang dictionary_id='30941.Boş'>!");
            return false;
        }
        else{
            member_type = $('#carrier_member_type').val();
            if(member_type == 'partner') member_id = $('#carrier_company_id').val();
            else member_id = $('#carrier_consumer_id').val();
        }

        AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=recycle.company_assets&member_type='+member_type+'&member_id='+member_id+'&dorse_plaka='+dorse_plaka+'','body_carDorseRowDocs');
    }

    function getDriverDocuments() {
        driver_id = $('#driver_id').val();
        if(driver_id == ''){
            alert("<cf_get_lang dictionary_id='60933.Şoför'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }

        AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=recycle.staff_assets&driver_id='+driver_id+'','body_personelRowDocs');
    }

    */
</script>