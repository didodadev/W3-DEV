<cfinclude template="../../header.cfm">
<cf_catalystHeader>

<cf_xml_page_edit>

<cfparam name = "attributes.sampling_time" default="#now()#">
<cfparam name = "attributes.sample_analysis_id" default="">

<cfif len(attributes.sample_analysis_id)>
    <cfquery name = "get_sample_analysis" datasource="#dsn#">
        SELECT
            REFINERY_LAB_TEST_ID,
            LAB_REPORT_NO
        FROM
            #dsn#.REFINERY_LAB_TESTS
        WHERE
            REFINERY_LAB_TEST_ID = #attributes.sample_analysis_id#
    </cfquery>
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfoutput>
        <cfform name="samplingForm" id="samplingForm">
            <input type="hidden" name="sample_analysis_id" id="sample_analysis_id" value="#attributes.sample_analysis_id#">
            <cf_box>
                <cf_box_elements id="samplingFormModal">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">                       
                        <div class="form-group">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61806.işlem tipi'></label>
                            <div class="col col-8 col-sm-12"><cf_workcube_process_cat slct_width="140" module_id = "92"></div>
                        </div>                        
                        <div class="form-group">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'></label>
                            <div class="col col-8 col-sm-12"><cf_wrkdepartmentlocation 
                                returnInputValue="location_id,department,department_id"
                                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                                fieldName="department"
                                fieldid="location_id"
                                department_fldId="department_id"
                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                width="250">
                            </div>
                        </div>                       
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="64425.Numune Alım Zamanı"></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="sampling_time" id="sampling_time" maxlength="10" value="#dateFormat(attributes.sampling_time,dateformat_style)#" required="yes" validate="#validate_style#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="sampling_time"></span>
                                </div>
                            </div>	
                            <cfoutput>
                                <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                    <cf_wrkTimeFormat name="sampling_time_h" value = "#hour(attributes.sampling_time)#">
                                </div>
                                <div class="col col-2 col-md-2 col-sm-2 col-xs-12">									
                                    <select name="sampling_time_m" id="sampling_time_m">
                                        <cfloop from="0" to="59" index="i">
                                            <option value="#NumberFormat(i)#" <cfif i eq minute(attributes.sampling_time)>selected</cfif>><cfif i lt 10>0</cfif>#NumberFormat(i)# </option>
                                        </cfloop>
                                    </select>														
                                </div>
                            </cfoutput>					
                        </div>                            
                    </div>
                   <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">                                 
                        <div class="form-group" id="form_ul_product_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                            <div class="col col-8 col-sm-12">
                                <div class="input-group">
                                    <input type="hidden" name="stock_code_search" id="stock_code_search" value="">
                                    <input type="hidden" name="stock_unit_id_search" id="stock_unit_id_search" value="">
                                    <input type="hidden" name="stock_unit_search" id="stock_unit_search" value="">
                                    <input type="hidden" name="stock_id_search" id="stock_id_search" value="">
                                    <input type="hidden" name="product_id_search" id="product_id_search" value="">
                                    <input type="text"   name="product_name_search"  id="product_name_search" style="width:140px;"  value="" onfocus="AutoComplete_Create('product_name_search','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','product_id_search,stock_id_search','','3','225');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onclick="open_product_popup_search()"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-spect_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57647.Spekt'></label>
                            <div class="col col-8 col-sm-12">
                                <div class="input-group">
                                    <input type="hidden" name="spect_main_id_search" id="spect_main_id_search" value="">
                                    <input type="text" name="spect_name_search" id="spect_name_search" style="width:150px;" value="">
                                    <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="product_control_search();"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Lot</label>
                            <div class="col col-8 col-sm-12">
                                <cfinput type="text" name="lot_no_search" value="">
                            </div>
                        </div> 
                    </div>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57637.Seri No'></label>
                            <div class="col col-8 col-sm-12"><cfinput type="text" name="serial_no_search" value=""></div>
                        </div> 
                        <div class="form-group">
                            <cfif isDefined('get_sample_analysis') and get_sample_analysis.recordCount>
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"> <cf_get_lang dictionary_id="64426.Laboratuvar İşlemi"> :  </label>
                                <div class="col col-8 col-sm-12"><a href = "index.cfm?fuseaction=lab.sample_analysis&event=upd&refinery_lab_test_id=#get_sample_analysis.refinery_lab_test_id#" target = "_blank">#get_sample_analysis.lab_report_no#</a></div>
                            </cfif>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer><input class=" ui-wrk-btn ui-wrk-btn-success" type="button" value="#getLang('','',57582)#" onclick="addRowSearch();"></cf_box_footer>
            </cf_box>
            <cf_box box_page="#request.self#?fuseaction=lab.sampling_row" id="row"></cf_box>
            <cf_box>
                <cf_box_footer>
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </cf_box_footer>
            </cf_box>
    </cfform>
    </cfoutput>
</div>

<script type = "text/javascript">
    function product_control_search(){/*Ürün seçmeden spec seçemesin.*/
        if(document.getElementById('product_id_search').value=="" || document.getElementById('product_name_search').value == "" ){
            alert("<cf_get_lang dictionary_id ='36828.Spect Seçmek için öncelikle ürün seçmeniz gerekmektedir'>");
            return false;
        }
        else
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=samplingForm.spect_main_id_search&field_name=samplingForm.spect_name_search&is_display=1&product_id='+document.getElementById('product_id_search').value,'list');
    }

    function open_product_popup_search() {
        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=samplingForm.stock_id_search&field_code=samplingForm.stock_code_search&field_unit=samplingForm.stock_unit_id_search&field_unit_name=samplingForm.stock_unit_search&product_id=samplingForm.product_id_search&field_name=samplingForm.product_name_search<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+encodeURIComponent(document.samplingForm.product_name_search.value),'list');
    }

    function addRowSearch() {
        //addRow( + ',' + $('#product_id_search').val() + ',' + $('#product_name_search').val() + ','','',' + $('#spect_var_id_search').val() + ',' + $('#spect_name_search').val() + ',' + $('#serial_no_search').val() + ',0,' + $('#stock_unit_search').val() + ',0);
        addSamplingRow($('#stock_id_search').val(),$('#stock_unit_id_search').val(),$('#stock_code_search').val(),$('#product_id_search').val(),$('#product_name_search').val(),'',$('#lot_no_search').val(),$('#spect_var_id_search').val(),$('#spect_name_search').val(),$('#serial_no_search').val(),0,$('#stock_unit_search').val(),0);
        get_product_stock(document.getElementById("samplingRowCount").value);
    }

    function kontrol() {
        if($("#process_cat").val() == '') {
            alert('İşlem Kategorisi seçmelisiniz!');
            return false;
        }
        if($("#department").val() == '' || $("#department_id").val() == '' || $("#location_id").val() == '') {
            alert('Depo-lokasyon seçmelisiniz!');
            return false;
        }
        if($("#sampling_time").val() == '') {
            alert('Numune alım zamanı boş olamaz!');
            return false;
        }
        if($("#samplingRowCount").val() == 0) {
            alert('Numune alınan ürünleri seçmelisiniz!');
            return false;
        } else {
            for(i = 1; i <= $("#samplingRowCount").val(); i++) {
                if($("#stock_code" + i).val() == '' || $("#product_id" + i).val() == '' || $("#stock_id" + i).val() == '') {
                    alert(i + ". satırda ürün seçmelisiniz!");
                    return false;
                }
            }
        }
        
        return true;
    }
</script>