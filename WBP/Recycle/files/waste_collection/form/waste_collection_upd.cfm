<cf_xml_page_edit>

<cfquery name = "get_service_cat" datasource="#dsn#">
    SELECT * FROM #dsn3_alias#.SERVICE_APPCAT WHERE SERVICECAT = '#waste_product_cat_code#'
</cfquery>

<cfif isnumeric(attributes.waste_collection_id)>
    <cfset waste_collection = createObject("component","WBP/Recycle/files/waste_collection/cfc/waste_collection") />
    <cfset getWasteCollection = waste_collection.getWasteCollection( attributes.waste_collection_id ) />
    <cfset getWasteCollectionRows = waste_collection.getWasteCollectionRows( waste_collection_id : attributes.waste_collection_id ) />
</cfif>
<cfparam name="attributes.expedition_entry_time" default="">
<cfparam name="attributes.expedition_exit_time" default="">

<cfinclude template="../../header.cfm">
<cf_catalystHeader>
<cfoutput query="getWasteCollection">
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cfform name="UpdWasteCollection" id="UpdWasteCollection">
            <cf_box>
                <cfinput type="hidden" name="waste_collection_id" id="waste_collection_id" value="#attributes.waste_collection_id#">
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_workcube_process is_upd='0' select_value='#PROCESS_STAGE#' process_cat_width='250' is_detail='1'></div>
                        </div>
                        <div class="form-group" id="item-ats_no">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62082.ATS No'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text" name="ats_no" id="ats_no" value="#ATS_NO#" readonly></div>
                        </div>
                        <div class="form-group" id="item-driver_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='60933.Şoför'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="driver_id" id="driver_id" value="#getWasteCollection.DRIVER_ID#">
                                    <cfinput type="text" name="driver_name" id="driver_name" onFocus="AutoComplete_Create('driver_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3,0,0,0,2,1,0,0,1','EMPLOYEE_ID','driver_id','UpdWasteCollection','3','135');" value="#getWasteCollection.DRIVER_EMPLOYEE_NAME# #getWasteCollection.DRIVER_EMPLOYEE_SURNAME#">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=UpdWasteCollection.driver_id&field_name=UpdWasteCollection.driver_name&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.UpdWasteCollection.driver_name.value),'list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-driver_yrd_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62117.Yardımcı Şoför'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="driver_yrd_id" id="driver_yrd_id" value="#getWasteCollection.YRD_DRIVER_ID#">
                                    <cfinput type="text" name="driver_yrd_name" id="driver_yrd_name" onFocus="AutoComplete_Create('driver_yrd_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3,0,0,0,2,1,0,0,1','EMPLOYEE_ID','driver_yrd_id','UpdWasteCollection','3','135');" value="#getWasteCollection.YRD_EMPLOYEE_NAME# #getWasteCollection.YRD_EMPLOYEE_SURNAME#">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=UpdWasteCollection.driver_yrd_id&field_name=UpdWasteCollection.driver_yrd_name&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.UpdWasteCollection.driver_yrd_name.value),'list');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-assetp_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62118.Çekici Plaka'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="assetp_id" id="assetp_id" value="#getWasteCollection.ASSETP_ID#">
                                    <input type="text" name="assetp_name" id="assetp_name" readonly value="#getWasteCollection.ASSETP_NAME#">
                                    <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=UpdWasteCollection.assetp_id&field_name=UpdWasteCollection.assetp_name&list_select=2&is_active=1','list','popup_list_ship_vehicles');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-assetp_dorse_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62130.Dorse Plaka'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="assetp_dorse_id" id="assetp_dorse_id" value="#getWasteCollection.ASSETP_DORSE_ID#">
                                    <input type="text" name="assetp_dorse_name" id="assetp_dorse_name" readonly value="#getWasteCollection.ASSETP_DORSE_NAME#">
                                    <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=UpdWasteCollection.assetp_dorse_id&field_name=UpdWasteCollection.assetp_dorse_name&list_select=2&is_active=1','list','popup_list_ship_vehicles');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-expedition_entry_time">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62085.Sefer Başlangıç Zamanı'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="expedition_entry_time" value="#dateformat(getWasteCollection.EXPEDITION_ENTRY_TIME,dateformat_style)#" validate="#validate_style#" maxlength="10" message="" readonly>
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="expedition_entry_time"></span>
                                </div>
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <cf_wrkTimeFormat name="expedition_entry_hour" value="#hour(getWasteCollection.EXPEDITION_ENTRY_TIME)#">
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <select name="expedition_entry_minute" id="expedition_entry_minute">
                                    <cfloop from="0" to="59" index="a">
                                        <cfoutput><option value="#Numberformat(a,00)#" #Numberformat(a,00) eq minute(getWasteCollection.EXPEDITION_ENTRY_TIME) ? 'selected' : ''#>#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-expedition_exit_time">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62084.Sefer Bitiş Zamanı'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="expedition_exit_time" value="#dateformat(getWasteCollection.EXPEDITION_EXIT_TIME,dateformat_style)#" validate="#validate_style#" maxlength="10" message="" readonly>
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="expedition_exit_time"></span>
                                </div>
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <cf_wrkTimeFormat name="expedition_exit_hour" value="#hour(getWasteCollection.EXPEDITION_EXIT_TIME)#">
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <select name="expedition_exit_minute" id="expedition_exit_minute">
                                    <cfloop from="0" to="59" index="a">
                                        <cfoutput><option value="#Numberformat(a,00)#" #Numberformat(a,00) eq minute(getWasteCollection.EXPEDITION_EXIT_TIME) ? 'selected' : ''#>#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <div class="col col-6">
                    <cf_record_info query_name="getWasteCollection" margintop="1">
                </div>
                <div class="col col-6">
					<cf_workcube_buttons add_function="control()" is_upd="1" delete_page_url='#request.self#?fuseaction=recycle.waste_collection&event=del&id=#attributes.waste_collection_id#'>
                </div>
            </cf_box>
            <cf_box title="Rota" >
                <input type="hidden" name="rowCountSave" id="rowCountSave" value="<cfoutput>#isDefined("getWasteCollectionRows") ? getWasteCollectionRows.recordCount : '0'#</cfoutput>" />
                <cf_grid_list sort="0">
                    <thead>
                        <tr>
                            <th width="20"><a href="javascript://" onclick="addRow()"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                            <th width="100"><cf_get_lang dictionary_id = '62175.Atık Toplama Talebi'></th>
                            <th width="auto"><cf_get_lang dictionary_id = '62179.Alım Adresi'></th>
                            <th width="auto"><cf_get_lang dictionary_id = '41807.Teslim Adresi'></th>
                            <th width="100"><cf_get_lang dictionary_id = '32823.Toplam Miktar'></th>
                        </tr>
                    </thead>
                    <tbody id="service_rows">
                        <cfif getWasteCollectionRows.recordCount>
                            <cfloop query="getWasteCollectionRows">
                                <tr id="row_#currentrow#">
                                    <td>
                                        <a href="javascript://"onclick="removeItem('row_#currentrow#')"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
                                        <input type="hidden" name="rowDeleted#currentrow#" id="rowDeleted#currentrow#" class="deleted" value="0">
                                        <input type="hidden" name="service_row_id#currentrow#" id="service_row_id#currentrow#" value="#EXPEDITIONS_ROW_ID#">
                                    </td>
                                    <td>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <input type="hidden" name="service_id#currentrow#" id="service_id#currentrow#" value="#SERVICE_ID#">
                                                <input type="text" name="service_no#currentrow#" id="service_no#currentrow#" value="#SERVICE_NO#">
                                                <span id='service_no_popup#currentrow#' class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_service&field_id=UpdWasteCollection.service_id#currentrow#&field_no=UpdWasteCollection.service_no#currentrow#&call_function=getItem&call_function_param=#currentrow#&service_cat_id=#get_service_Cat.servicecat_id#&keyword='+encodeURIComponent(document.UpdWasteCollection.service_no#currentrow#.value),'list')"></span>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <label id="from_service_address#currentrow#">
                                            <cfif len(company_partner_address)>#company_partner_address#</cfif><cfif len(p_semt)> #p_semt#</cfif>
                                            <cfif len(company_partner_postcode)>#company_partner_postcode#</cfif>
                                            <cfif len(p_county_name)>#p_county_name#</cfif>
                                            <cfif len(p_city_name)><cfif len(p_county_name)> / </cfif>#p_city_name#</cfif>
                                            <cfif len(p_country_name)><cfif len(p_city_name)> / </cfif>#p_country_name#</cfif>
                                        </label>
                                    </td>
                                    <td>
                                        <label id="to_service_address#currentrow#">
                                            <cfif len(address)>#address#</cfif><cfif len(semt)> #semt#</cfif>
                                            <cfif len(postcode)>#postcode#</cfif>
                                            <cfif len(county)>#county_name#</cfif>
                                            <cfif len(city)><cfif len(county)> / </cfif>#city_name#</cfif>
                                            <cfif len(country)><cfif len(city)> / </cfif>#country_name#</cfif>
                                        </label>
                                    </td>
                                    <td class="text-right"><label id="amount#currentrow#">#TLFormat(AMOUNT)#</label></td>
                                </tr>
                            </cfloop>
                        </cfif>
                    </tbody>
                </cf_grid_list>
            </cf_box>
        </cfform>
    </div>
</cfoutput>

<script>

    function control() {
        if(UpdWasteCollection.ats_no.value == "")
        {
            alert("<cf_get_lang dictionary_id="57880.Belge No"> <cf_get_lang dictionary_id='30941.Boş'>!");
            $('#ats_no').focus();
            return false;
        }
        if(UpdWasteCollection.assetp_id.value == "" || UpdWasteCollection.assetp_name.value == "")
        {
            alert("<cf_get_lang dictionary_id='62118.Çekici Plaka'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            $('#assetp_name').focus();
            return false;
        }
        if(UpdWasteCollection.assetp_dorse_id.value == "" || UpdWasteCollection.assetp_dorse_name.value == "")
        {
            alert("<cf_get_lang dictionary_id='62130.Dorse Plaka'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            $('#assetp_dorse_name').focus();
            return false;
        }
        if(UpdWasteCollection.driver_id.value == "" || UpdWasteCollection.driver_name.value == "")
        {
            alert("<cf_get_lang dictionary_id='60933.Şoför'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            $('#driver_name').focus();
            return false;
        }
        if(UpdWasteCollection.driver_yrd_id.value == "" || UpdWasteCollection.driver_yrd_name.value == "")
        {
            alert("<cf_get_lang dictionary_id='62117.Yardımcı Şoför'> <cf_get_lang dictionary_id='30941.Boş'>!");
            $('#driver_yrd_name').focus();
            return false;
        }
        if(UpdWasteCollection.expedition_entry_time.value == "" || UpdWasteCollection.expedition_exit_time.value == "")
        {
            alert("Sefer Başlangıç-Bitiş zamanları boş olamaz!");
            return false;
        }
        return true;
    }

    var jsonArray = [{
        "remove" : "<a style='cursor:pointer' onclick=\"removeItem('row_###id###')\"><i class='fa fa-minus' title='<cf_get_lang dictionary_id='57463.Sil'>'></i></a><input type='hidden' name='rowDeleted###id###' id='rowDeleted###id###' class='deleted' value='0'><input type='hidden' name='service_row_id###id###' id='service_row_id###id###' value=''>",
        "service" : "<div class='form-group'><div class='input-group'><input type='hidden' name='service_id###id###' id='service_id###id###' value=''><input type='text' name='service_no###id###' id='service_no###id###' value=''><span id='service_no_popup###id###'' class='input-group-addon icon-ellipsis btnPointer'></span></div></div>",
        "from_service_address" : "<label id='from_service_address###id###'></label>",
        "to_service_address" : "<label id='to_service_address###id###'></label>",
        "amount" : "<label id='amount###id###'></label>"
    }];

    var row_count = <cfoutput>#isDefined("getWasteCollectionRows") ? getWasteCollectionRows.recordCount : 0#</cfoutput>;
    var row_ids_list = [];

    var url_link = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_service';

    function addRow(){
        row_count +=1;
        jsonArray.filter((a) => {
            var template="<tr id='row_"+row_count+"'><td>{remove}</td><td>{service}</td><td>{from_service_address}</td><td>{to_service_address}</td><td class='text-right'>{amount}</td></tr>";
            $("#service_rows").append(nano( template, a ).replace(/###id###/g,row_count));
            $("#service_no_popup"+row_count).attr("onclick","windowopen('"+url_link+"&field_id=UpdWasteCollection.service_id"+row_count+"&field_no=UpdWasteCollection.service_no"+row_count+"&call_function=getItem&call_function_param="+row_count+"&service_cat_id=<cfoutput>#get_service_cat.servicecat_id#</cfoutput>','list')");
        });
        $("#rowCountSave").val( parseInt($("#rowCountSave").val()) + 1 );
    }
    function removeItem(row_id) {
        if(confirm( "<cf_get_lang dictionary_id='62142.Silmek istediğinize emin misiniz?'>" )) $("tr#"+row_id+"").hide().find(".deleted").val(1);
    }
    function getItem(row_id) {
        $( "#from_service_address"+ row_id +", #to_service_address"+ row_id +", #amount"+ row_id + "" ).text('');
        var from_address = '';
        var to_address = '';

        if( $("#service_id"+row_id).val() != "" && $("#service_no"+row_id).val() != "" ){

            if( row_ids_list.indexOf( $("#service_id"+row_id).val() ) == -1 ){

                var data_control = new FormData();
                data_control.append("service_id", $("#service_id"+row_id).val());
                AjaxControlPostDataJson( 'WBP/Recycle/files/cfc/recycle_objects.cfc?method=getServiceControl', data_control, function(response_control) {
                    if( response_control.length > 0 ){
                        alert("Atık toplama talebi daha önce bir planlamaya dahil edilmiş!");
                        $("#service_id"+row_id).val("");
                        $("#service_no"+row_id).val("");
                        $("#from_service_address"+row_id).text("");
                        $("#to_service_address"+row_id).text("");
                        $("#amount"+row_id).text("");
                        return false;
                    }
                    else{
                        row_ids_list.push( $("#service_id"+row_id).val() );
                        var data = new FormData();
                        data.append("service_id", $("#service_id"+row_id).val());
                        AjaxControlPostDataJson( 'WBP/Recycle/files/cfc/recycle_objects.cfc?method=getServiceDetails', data, function(response) {
                            if( response.length > 0 ){
                                if(response[0].ADDRESS.length) from_address += response[0].ADDRESS;
                                if(response[0].SEMT.length) from_address += ' ' + response[0].SEMT;
                                if(response[0].POSTCODE.length) from_address += ' ' + response[0].POSTCODE;
                                if(response[0].COUNTY_NAME.length) from_address += ' ' + response[0].COUNTY_NAME;
                                if(response[0].CITY_NAME.length){
                                    if(response[0].COUNTY_NAME.length) from_address += ' /';
                                    from_address += ' ' + response[0].CITY_NAME;
                                }
                                if(response[0].COUNTRY_NAME.length){
                                    if(response[0].CITY_NAME.length) from_address += ' /';
                                    from_address += ' ' + response[0].COUNTRY_NAME;
                                }

                                if(response[0].COMPANY_PARTNER_ADDRESS.length) to_address += response[0].COMPANY_PARTNER_ADDRESS;
                                if(response[0].P_SEMT.length) to_address += ' ' + response[0].P_SEMT;
                                if(response[0].COMPANY_PARTNER_POSTCODE.length) to_address += ' ' + response[0].COMPANY_PARTNER_POSTCODE;
                                if(response[0].P_COUNTY_NAME.length) to_address += ' ' + response[0].P_COUNTY_NAME;
                                if(response[0].P_CITY_NAME.length){
                                    if(response[0].P_COUNTY_NAME.length) to_address += ' /';
                                    to_address += ' ' + response[0].P_CITY_NAME;
                                }
                                if(response[0].P_COUNTRY_NAME.length){
                                    if(response[0].P_CITY_NAME.length) to_address += ' /';
                                    to_address += ' ' + response[0].P_COUNTRY_NAME;
                                }

                                $( "#from_service_address"+ row_id +"" ).text(from_address);
                                $( "#to_service_address"+ row_id +"" ).text(to_address);
                                $( "#amount"+ row_id +"" ).text(commaSplit(response[0].AMOUNT));
                            }
                        } );
                    }
                });
            }
            else{
                alert("Belge içerisinde aynı atık toplama talebi birden çok seçilemez!");
                $("#service_id"+row_id).val("");
                $("#service_no"+row_id).val("");
                $("#from_service_address"+row_id).text("");
                $("#to_service_address"+row_id).text("");
                $("#amount"+row_id).text("");
                return false;
            }
        }
    }
</script>