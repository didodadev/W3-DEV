<cf_xml_page_edit>

<cfif isnumeric(attributes.waste_operation_id)>
    <cfset waste_operation = createObject("component","WBP/Recycle/files/waste_operation/cfc/waste_operation") />
    <cfset getWasteOperation = waste_operation.getWasteOperation( attributes.waste_operation_id ) />
    <cfset getWasteOperationRow = waste_operation.getWasteOperationRow( waste_operation_id: attributes.waste_operation_id ) /> 
    <cfset getDrivers = waste_operation.getDrivers( company_id : getWasteOperation.CARRIER_COMPANY_ID ) />
</cfif>
<cfparam name="attributes.car_entry_time" default="">

<cfinclude template="../../header.cfm">
<cf_catalystHeader>

<cfoutput query="getWasteOperation">
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cfform name="wasteOilForm" id="wasteOilForm">
            <cf_box>
                <cfinput type="hidden" name="waste_operation_id" id="waste_operation_id" value="#attributes.waste_operation_id#">
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_workcube_process is_upd='0' select_value='#PROCESS_STAGE#' process_cat_width='250' is_detail='1'></div>
                        </div>
                        <div class="form-group" id="item-general_paper_no">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="57880.Belge No">*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text" name="general_paper_no" id="general_paper_no" value="#GENERAL_PAPER_NO#"></div>
                        </div>
                        <div class="form-group" id="item-department_location">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="62161.Kabul Tankı">*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">  
                                <cfif len(DEPARTMENT_ID)>
                                    <cfset location_info_ = get_location_info(DEPARTMENT_ID,LOCATION_ID,1,1)>
                                    <cfset attributes.department_ID = DEPARTMENT_ID>
                                    <cfset attributes.location_id = LOCATION_ID>
                                <cfelse>
                                    <cfset location_info_ = ''>
                                    <cfset attributes.department_ID = ''>
                                    <cfset attributes.location_id = ''>
                                </cfif>
                                <cf_wrkdepartmentlocation
                                    returninputvalue="location_id,department_name,department_id,branch_id"
                                    returninputquery="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                    fieldname="department_name"
                                    fieldid="location_id"
                                    department_fldid="department_id"
                                    branch_fldid="branch_id"
                                    branch_id="#listlast(location_info_,',')#"
                                    department_id="#attributes.department_ID#"
                                    location_id="#attributes.location_id#"
                                    location_name="#listfirst(location_info_,',')#"
                                    user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                    width="135">
                            </div>
                        </div>
                        <div class="form-group" id="item-bo_number">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62116.BO Numarası'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text"  value="#BO_NUMBER#" name="bo_number" id="bo_number"></div>
                        </div>
                        <div class="form-group" id="item-product_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no ='245.Ürün'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="stock_id" id="stock_id" value="#PRODUCT_STOCK_ID#">
                                    <cfinput type="hidden" name="main_unit_id" id="main_unit_id" value="#PRODUCT_MAIN_UNIT_ID#">
                                    <cfinput type="hidden" name="product_id" id="product_id" value="#PRODUCT_ID#">
                                    <cfinput type="text" name="product_name" id="product_name" value="#PRODUCT_NAME#" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','form','3','200');" style="width:100px;">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=wasteOilForm.product_id&field_id=wasteOilForm.stock_id&field_main_unit=wasteOilForm.main_unit_id&field_name=wasteOilForm.product_name&product_cat_code=10.01&product_cat=Bakım','list');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-carNumber">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62118.Çekici Plaka'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text" value="#CAR_NUMBER#" name="carNumber" id="carNumber"></div>
                        </div>
                        <div class="form-group" id="item-dorse_plaka">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62130.Dorse Plaka'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text" value="#DORSE_PLAKA#" name="dorse_plaka" id="dorse_plaka"></div>
                        </div>
                        <div class="form-group" id="item-member_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34578.Firma Adı'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="consumer_id" id="consumer_id" value="#CONSUMER_ID#">
                                    <cfinput type="hidden" name="company_id" id="company_id" value="#COMPANY_ID#">
                                    <cfinput type="hidden" name="member_type" id="member_type" value="#MEMBER_TYPE#">
                                    <cfinput name="member_name" type="text" id="member_name" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="#(Len(FULLNAME) ? FULLNAME : CONSUMER_NAME & ' ' & CONSUMER_SURNAME)#" autocomplete="off">
                                    <cfset str_linke_ait="&field_consumer=wasteOilForm.consumer_id&field_comp_id=wasteOilForm.company_id&field_member_name=wasteOilForm.member_name&field_type=wasteOilForm.member_type">
                                    <span class="input-group-addon icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_all_pars#str_linke_ait#&select_list=7,8&keyword='+encodeURIComponent(document.wasteOilForm.member_name.value),'list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-carrier_member_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='39248.Taşıyıcı Firma'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="carrier_consumer_id" id="carrier_consumer_id" value="#CARRIER_CONSUMER_ID#">
                                    <cfinput type="hidden" name="carrier_company_id" id="carrier_company_id" value="#CARRIER_COMPANY_ID#">
                                    <cfinput type="hidden" name="carrier_member_type" id="carrier_member_type" value="#CARRIER_MEMBER_TYPE#">
                                    <cfinput name="carrier_member_name" type="text" id="carrier_member_name" onFocus="AutoComplete_Create('carrier_member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','carrier_consumer_id,carrier_company_id,carrier_member_type','','3','250');" value="#(Len(CARRIER_FULLNAME) ? CARRIER_FULLNAME : CARRIER_CONSUMER_NAME & ' ' & CARRIER_CONSUMER_SURNAME)#" autocomplete="off">
                                    <cfset str_linke_ait2="&field_consumer=wasteOilForm.carrier_consumer_id&field_comp_id=wasteOilForm.carrier_company_id&field_member_name=wasteOilForm.carrier_member_name&field_type=wasteOilForm.carrier_member_type">
                                    <span class="input-group-addon icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_all_pars#str_linke_ait2#&select_list=7,8&keyword='+encodeURIComponent(document.wasteOilForm.carrier_member_name.value)+'&function_name=getCompanyEmployees','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-driver_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='60933.Şoför'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="driver_id" id="driver_id">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfloop query="getDrivers">
                                        <option value="#PARTNER_ID#" <cfif PARTNER_ID eq getWasteOperation.DRIVER_PARTNER_ID>selected</cfif>>#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-driver_yrd_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62117.Yardımcı Şoför'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="yrd_driver_id" id="yrd_driver_id">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfloop query="getDrivers">
                                        <option value="#PARTNER_ID#" <cfif PARTNER_ID eq getWasteOperation.DRIVER_YRD_PARTNER_ID>selected</cfif>>#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-car_entry_time">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62129.Araç Giriş Zamanı'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="car_entry_time" value="#len(CAR_ENTRY_TIME) ? dateformat(CAR_ENTRY_TIME,dateformat_style) : ''#" maxlength="10" message="" readonly>
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="car_entry_time"></span>
                                </div>
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <cf_wrkTimeFormat name="car_entry_hour" value="#len(CAR_ENTRY_TIME) ? hour(CAR_ENTRY_TIME) : ''#">
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <select name="car_entry_minute" id="car_entry_minute">
                                    <cfloop from="0" to="59" index="a">
                                        <cfoutput><option value="#Numberformat(a,00)#" #(len(CAR_ENTRY_TIME) and Numberformat(a,00) eq minute(CAR_ENTRY_TIME)) ? 'selected' : ''#>#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-car_entry_kg">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62128.Araç Giriş Ağırlığı'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='1738.Geçerli Tutar Girmelisiniz!'></cfsavecontent>
                                    <cfinput type="text" name="car_entry_kg" id="car_entry_kg" class="moneybox" value="#TLFORMAT(CAR_ENTRY_KG)#" style="width:120px;" message="#message#" onkeyup="return(FormatCurrency(this,event));">
                                    <span class="input-group-addon icon-refresh btnPointer" onclick="getWeighbridge('car_entry_kg')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-car_exit_time">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62127.Araç Çıkış Zamanı'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="car_exit_time" value="#dateformat(CAR_EXIT_TIME,dateformat_style)#" maxlength="10" message="" readonly>
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="car_exit_time"></span>
                                </div>
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <cf_wrkTimeFormat name="car_exit_hour" value="#len(CAR_EXIT_TIME) ? hour(CAR_EXIT_TIME) : ''#">
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <select name="car_exit_minute" id="car_exit_minute">
                                    <cfloop from="0" to="59" index="a">
                                        <cfoutput><option value="#Numberformat(a,00)#" #(len(CAR_EXIT_TIME) and Numberformat(a,00) eq minute(CAR_EXIT_TIME)) ? 'selected' : ''#>#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-car_exit_kg">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62126.Araç Çıkış Ağırlığı'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='1738.Geçerli Tutar Girmelisiniz!'></cfsavecontent>
                                    <cfinput type="text" name="car_exit_kg" id="car_exit_kg" class="moneybox" value="#TLFORMAT(CAR_EXIT_KG)#" style="width:120px;" message="#message#" onkeyup="return(FormatCurrency(this,event));">
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
                                    value="#PROPERTY_ID#"
                                    option_value="CONTENT_PROPERTY_ID"
                                    onchange="sel_digital_asset_group();">
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <div class="col col-6">
                        <cf_record_info query_name="getWasteOperationRow" margintop="1">
                    </div>
                    <div class="col col-6">
                        <cf_workcube_buttons is_upd="1" delete_page_url='#request.self#?fuseaction=recycle.waste_operation&event=del&id=#attributes.waste_operation_id#' add_function="kontrol()">
                    </div>
                </cf_box_footer>
            </cf_box>
            <div id = "waste_operation_documents"></div>
        </cfform>
    </div>
</cfoutput>
<script>
    $( document ).ready(function() {
        AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=recycle.waste_operation_documents&waste_operation_id='+<cfoutput>#attributes.waste_operation_id#</cfoutput>+'','waste_operation_documents');
    });

    function kontrol() {
        if(wasteOilForm.general_paper_no.value == "")
        {
            alert("<cf_get_lang dictionary_id="57880.Belge No"> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if(wasteOilForm.carNumber.value == "")
        {
            alert("<cf_get_lang dictionary_id='62118.Çekici Plaka'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if(wasteOilForm.dorse_plaka.value == "")
        {
            alert("<cf_get_lang dictionary_id='62130.Dorse Plaka'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if((wasteOilForm.consumer_id.value == "" || wasteOilForm.member_name.value == "") && (wasteOilForm.company_id.value == "" || wasteOilForm.member_name.value == ""))
        {
            alert("<cf_get_lang dictionary_id='38282.Cari Hesap Seçmelisiniz'>");	
            return false;
        }
        if((wasteOilForm.carrier_consumer_id.value == "" || wasteOilForm.carrier_member_name.value == "") && (wasteOilForm.carrier_company_id.value == "" || wasteOilForm.carrier_member_name.value == ""))
        {
            alert("<cf_get_lang dictionary_id='39248.Taşıyıcı Firma'> <cf_get_lang dictionary_id='30941.Boş'>!");
            return false;
        }
        if(wasteOilForm.product_id.value == "" || wasteOilForm.product_name.value == "")
        {
            alert("<cf_get_lang_main no ='245.Ürün'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if(wasteOilForm.property_id.value == ""){
            alert("<cf_get_lang_main no='655.Döküman Tipi'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if(wasteOilForm.driver_id.value != "" && wasteOilForm.yrd_driver_id.value != "" && wasteOilForm.driver_id.value == wasteOilForm.yrd_driver_id.value){
            alert('<cfoutput>#getLang(dictionary_id:62163)#</cfoutput>');
            return false;
        }
        unformat_fields();
        return true;
    }
    function unformat_fields()
    {
        if(document.wasteOilForm.car_entry_kg.value != "") document.wasteOilForm.car_entry_kg.value = filterNum(document.wasteOilForm.car_entry_kg.value);
        if(document.wasteOilForm.car_exit_kg.value != "") document.wasteOilForm.car_exit_kg.value = filterNum(document.wasteOilForm.car_exit_kg.value);
    }

    function getWeighbridge(element) {
        if( document.wasteOilForm.carNumber.value != ""){
            var data = new FormData();
            data.append("plaka", document.wasteOilForm.carNumber.value);
            AjaxControlPostDataJson('WBP/Recycle/files/cfc/refinery.cfc?method=getWasteOperation_weighbridge', data, function(response) {
                if( element == 'car_entry_kg' ) document.wasteOilForm.car_entry_kg.value = commaSplit(response.TARTIM_1);
                else if( element == 'car_exit_kg' ) document.wasteOilForm.car_exit_kg.value = commaSplit(response.TARTIM_2);
            });
        }else alert("<cf_get_lang dictionary_id='62130.Dorse Plaka'> <cf_get_lang dictionary_id='30941.Boş'>!");
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
</script>
