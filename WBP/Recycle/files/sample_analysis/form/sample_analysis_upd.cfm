<cfif isnumeric(attributes.refinery_lab_test_id)>
    <cfset sample_analysis = createObject("component","WBP/Recycle/files/sample_analysis/cfc/sample_analysis") />
    <cfset waste_operation = createObject("component","WBP/Recycle/files/waste_operation/cfc/waste_operation") />
    <cfset analysis_parameters = createObject("component","WBP/Recycle/files/sample_analysis/cfc/analysis_parameters") />
			
	
    <cfset getLabTestRow = sample_analysis.get_detail_lab_test(
		refinery_lab_test_id: attributes.refinery_lab_test_id
    ) />
   
    <cfset getWasteOperation = waste_operation.getWasteOperation(
        is_exit_date_null:1,
        is_analyzeLab:1,
        analyzeLabId:attributes.refinery_lab_test_id
    ) />

    <cfset getAnalysisCat = analysis_parameters.getAnalysisCat() />

</cfif>

<cfquery name="TEST_GROUPS" datasource="#DSN#">
	SELECT
		REFINERY_GROUP_ID,
		GROUP_NAME
	FROM
		REFINERY_GROUPS
	WHERE
		GROUP_STATUS = 1 AND OUR_COMPANY_ID = <cfqueryparam	cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY
		GROUP_NAME
</cfquery>
<cfquery name="TEST_UNITS" datasource="#DSN#">
	SELECT
		REFINERY_UNIT_ID,
		UNIT_NAME
	FROM
		REFINERY_TEST_UNITS
	WHERE
		UNIT_STATUS = 1 AND OUR_COMPANY_ID = <cfqueryparam	cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY
		UNIT_NAME
</cfquery>
<cfquery name="GET_TEST" datasource="#dsn#">
	SELECT
		REFINERY_TEST_ID,
		TEST_NAME,
		TEST_COMMENT
	FROM
		REFINERY_TEST
    WHERE
		OUR_COMPANY_ID = <cfqueryparam	cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY
		TEST_NAME
</cfquery>

<cfset sampling_points = createObject("component","WBP/Recycle/files/sample_analysis/cfc/sampling_points") />
<cfset getSamplingPoints = sampling_points.getSamplingPoints() />

<cfparam name="attributes.start_date" default="">
<cfinclude template="../../header.cfm">
<cf_catalystHeader>
<cfif getLabTestRow.recordCount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cfform name="analyzeLabTest" id="analyzeLabTest">
            <cf_box>
                <cfinput type="hidden" name="refinery_lab_test_id" id="refinery_lab_test_id" value="#attributes.refinery_lab_test_id#">
                <cf_box_elements id="labTestAddModal">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_workcube_process is_upd='0' select_value='#getLabTestRow.PROCESS_STAGE#' process_cat_width='250' is_detail='1'></div>
                        </div>
                        <div class="form-group" id="item-lab_report_no">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62139.Lab Rapor No'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" value="#getLabTestRow.LAB_REPORT_NO#" name="lab_report_no" id="lab_report_no" />
                            </div>
                        </div>
                        <div class="form-group" id="item-refinery_waste_oil_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62157.Atık Yağ Kabul'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="refinery_waste_oil_id" id="refinery_waste_oil_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="#getWasteOperation#">
                                        <cfoutput><option value="#REFINERY_WASTE_OIL_ID#" #REFINERY_WASTE_OIL_ID eq getLabTestRow.REFINERY_WASTE_OIL_ID ? 'selected' : ''#>#DORSE_PLAKA# / #CAR_NUMBER#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-department_location">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30031.Location'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">  
                                <cfif len(getLabTestRow.DEPARTMENT_ID)>
                                    <cfset location_info_ = get_location_info(getLabTestRow.DEPARTMENT_ID,getLabTestRow.LOCATION_ID,1,1)>
                                    <cfset attributes.department_ID = getLabTestRow.DEPARTMENT_ID>
                                    <cfset attributes.location_id = getLabTestRow.LOCATION_ID>
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
                        <div class="form-group" id="item-member_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34578.Firma Adı'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="consumer_id" id="consumer_id" value="#getLabTestRow.CONSUMER_ID#">
                                    <cfinput type="hidden" name="company_id" id="company_id" value="#getLabTestRow.COMPANY_ID#">
                                    <cfinput type="hidden" name="member_type" id="member_type" value="#getLabTestRow.MEMBER_TYPE#">
                                    <cfinput name="member_name" type="text" id="member_name" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="#get_cons_info(getLabTestRow.CONSUMER_ID,0,0)#" autocomplete="off">
                                    <cfset str_linke_ait="&field_consumer=analyzeLabTest.consumer_id&field_comp_id=analyzeLabTest.company_id&field_member_name=analyzeLabTest.member_name&field_type=analyzeLabTest.member_type">
                                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput>&select_list=7,8&keyword='+encodeURIComponent(document.analyzeLabTest.member_name.value));"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-get_sample">
                            <cfset prod_sample_id =''>
                            <cfif len(getLabTestRow.PRODUCT_SAMPLE_ID)>
                                <cfquery name="get_samp_detail" datasource="#dsn3#">
                                    SELECT PRODUCT_SAMPLE_NAME FROM PRODUCT_SAMPLE WHERE PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getLabTestRow.product_sample_id#">
                                </cfquery>
                                <cfset prod_sample_id= get_samp_detail.PRODUCT_SAMPLE_NAME>
                            </cfif>
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62603.Numune'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="p_sample_id" id="p_sample_id" value="#getLabTestRow.PRODUCT_SAMPLE_ID#">
                                    <cfinput type="text" name="p_sample_name" id="p_sample_name" value="#prod_sample_id#">
                                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=product.list_product_samples&field_sample_name=analyzeLabTest.p_sample_name&field_sample_id=analyzeLabTest.p_sample_id')"></span>
                                </div>
                            </div>
                        </div>
                        
                    </div>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-sample_employee_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62135.Numuneyi Alan Kişi'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="sample_employee_id" id="sample_employee_id" value="#getLabTestRow.SAMPLE_EMPLOYEE_ID#"><!--- çalışanlar için --->
                                    <cfinput type="hidden" name="from_company_id" id="from_company_id"><!--- kurumsal üyeler için --->
                                    <cfinput type="hidden" name="from_partner_id" id="from_partner_id"><!--- kurumsal üyeler için --->
                                    <cfinput type="hidden" name="from_consumer_id" id="from_consumer_id"><!--- bireysel üyeler için --->              
                                    <cfinput type="text" name="sample_employee_name" id="sample_employee_name" value="#get_emp_info(getLabTestRow.SAMPLE_EMPLOYEE_ID,0,0)#" onfocus="AutoComplete_Create('sample_employee_name','MEMBER_PARTNER_NAME3','MEMBER_PARTNER_NAME3','get_member_autocomplete','','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID,PARTNER_ID','from_consumer_id,from_company_id,sample_employee_id,from_partner_id','','3','250');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=analyzeLabTest.sample_employee_id&field_name=analyzeLabTest.sample_employee_name&field_partner=analyzeLabTest.from_partner_id&field_consumer=analyzeLabTest.from_consumer_id&field_comp_id=analyzeLabTest.from_company_id&is_form_submitted=1&select_list=1,7,8');" title="<cf_get_lang dictionary_id='30829.Talep Eden'>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-numune_date">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62138.Numune Alım Tarihi'>*</label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="numune_date" id="numune_date" value="#len(getLabTestRow.NUMUNE_DATE) ? dateformat(getLabTestRow.NUMUNE_DATE,dateformat_style) : ''#" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="numune_date"></span>
                                </div>
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <cf_wrkTimeFormat name="numune_hour" value="#len(getLabTestRow.NUMUNE_DATE) ? hour(getLabTestRow.NUMUNE_DATE) : ''#">
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <select name="numune_minute" id="numune_minute">
                                    <cfloop from="0" to="59" index="a">
                                        <cfoutput><option value="#Numberformat(a,00)#" #(len(getLabTestRow.NUMUNE_DATE) and Numberformat(a,00) eq minute(getLabTestRow.NUMUNE_DATE)) ? 'selected' : ''#>#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-numune_accept_date">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62123.Numune Kabul Tarihi'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="numune_accept_date" id="numune_accept_date" value="#len(getLabTestRow.NUMUNE_ACCEPT_DATE) ? dateformat(getLabTestRow.NUMUNE_ACCEPT_DATE,dateformat_style) : ''#" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="numune_accept_date"></span>
                                </div>
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <cf_wrkTimeFormat name="numune_accept_hour" value="#len(getLabTestRow.NUMUNE_ACCEPT_DATE) ? hour(getLabTestRow.NUMUNE_ACCEPT_DATE) : ''#">
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <select name="numune_accept_minute" id="numune_accept_minute">
                                    <cfloop from="0" to="59" index="a">
                                        <cfoutput><option value="#Numberformat(a,00)#" #(len(getLabTestRow.NUMUNE_ACCEPT_DATE) and Numberformat(a,00) eq minute(getLabTestRow.NUMUNE_ACCEPT_DATE)) ? 'selected' : ''#>#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-numune_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62140.Numune Adı & Tarifi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea name="numune_name" id="numune_name" style="width:140px;height:60px;"><cfoutput>#getLabTestRow.NUMUNE_NAME#</cfoutput></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-numune_place">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62133.Numune Alınan Yer'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" value="#getLabTestRow.NUMUNE_PLACE#" name="numune_place" id="numune_place" />
                            </div>
                        </div>
                        <div class="form-group" id="item-numune_point">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62132.Numunenin Alım Noktası'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="numune_point" id="numune_point">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="#getSamplingPoints#">
                                        <cfoutput><option value="#SAMPLING_ID#" #SAMPLING_ID eq getLabTestRow.NUMUNE_POINT ? 'selected' : ''#>#SAMPLING_POINTS_NAME#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>  
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-requesting_employee_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62137.Analiz Talep Eden'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="requesting_employee_id" id="requesting_employee_id" value="#getLabTestRow.REQUESTING_EMPLOYE_ID#"><!--- çalışanlar için --->
                                    <cfinput type="hidden" name="from_company_id" id="from_company_id"><!--- kurumsal üyeler için --->
                                    <cfinput type="hidden" name="from_partner_id" id="from_partner_id"><!--- kurumsal üyeler için --->
                                    <cfinput type="hidden" name="from_consumer_id" id="from_consumer_id"><!--- bireysel üyeler için --->              
                                    <cfinput type="text" name="requesting_employee_name" id="requesting_employee_name" value="#get_emp_info(getLabTestRow.REQUESTING_EMPLOYE_ID,0,0)#" onfocus="AutoComplete_Create('requesting_employee_name','MEMBER_PARTNER_NAME3','MEMBER_PARTNER_NAME3','get_member_autocomplete','','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID,PARTNER_ID','from_consumer_id,from_company_id,requesting_employee_id,from_partner_id','','3','250');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=analyzeLabTest.requesting_employee_id&field_name=analyzeLabTest.requesting_employee_name&field_partner=analyzeLabTest.from_partner_id&field_consumer=analyzeLabTest.from_consumer_id&field_comp_id=analyzeLabTest.from_company_id&is_form_submitted=1&select_list=1,7,8');" title="<cf_get_lang dictionary_id='30829.Talep Eden'>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-analyse_date">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62122.Analizin Başlangıç Tarihi'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="analyse_date" id="analyse_date" value="#len(getLabTestRow.ANALYSE_DATE) ? dateformat(getLabTestRow.ANALYSE_DATE,dateformat_style) : ''#" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="analyse_date"></span>
                                </div>
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <cf_wrkTimeFormat name="analyse_date_entry_hour" value="#len(getLabTestRow.ANALYSE_DATE) ? hour(getLabTestRow.ANALYSE_DATE) : ''#">
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <select name="analyse_date_entry_minute" id="analyse_date_entry_minute">
                                    <cfloop from="0" to="59" index="a">
                                        <cfoutput><option value="#Numberformat(a,00)#" #(len(getLabTestRow.ANALYSE_DATE) and Numberformat(a,00) eq minute(getLabTestRow.ANALYSE_DATE)) ? 'selected' : ''#>#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-analyse_date_exit">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62120.Analizin Bitiş Tarihi'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="analyse_date_exit" id="analyse_date_exit" value="#len(getLabTestRow.ANALYSE_DATE_EXIT) ? dateformat(getLabTestRow.ANALYSE_DATE_EXIT,dateformat_style) : ''#" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="analyse_date_exit"></span>
                                </div>
                            </div>
                            <div class="col col-2 col-md-4 col-sm-4 col-xs-12">
                                <cf_wrkTimeFormat name="analyse_date_exit_hour" value="#len(getLabTestRow.ANALYSE_DATE_EXIT) ? hour(getLabTestRow.ANALYSE_DATE_EXIT) : ''#">
                            </div>
                            <div class="col col-2 col-md-4 col-sm-4 col-xs-12">
                                <select name="analyse_date_exit_minute" id="analyse_date_exit_minute">
                                    <cfloop from="0" to="59" index="a">
                                        <cfoutput><option value="#Numberformat(a,00)#" #(len(getLabTestRow.ANALYSE_DATE_EXIT) and Numberformat(a,00) eq minute(getLabTestRow.ANALYSE_DATE_EXIT)) ? 'selected' : ''#>#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='46408.Açıklamalar'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea name="detail" id="detail" style="width:140px;height:60px;"><cfoutput>#getLabTestRow.DETAIL#</cfoutput></textarea>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <div class="col col-6">
                        <cf_record_info query_name="getLabTestRow" margintop="1">
                    </div>
                    <div class="col col-6">
                        <cf_workcube_buttons
                        is_upd="1"
                        delete_page_url='#request.self#?fuseaction=lab.sample_analysis&event=del&id=#attributes.refinery_lab_test_id#'
                        add_function="kontrol()"
                        data_action ="WBP/Recycle/files/sample_analysis/cfc/sample_analysis:updLabTestForm"
                        next_page="#request.self#?fuseaction=lab.sample_analysis&event=upd&refinery_lab_test_id=">
                    </div>
                </cf_box_footer>
            </cf_box>
            <cf_box box_page="#request.self#?fuseaction=lab.test_parameters&is_sample=#len(getLabTestRow.PRODUCT_SAMPLE_ID) ? '1' : ''#&is_upd=1&refinery_lab_test_id=#attributes.refinery_lab_test_id#&product_sample_id=#len(getLabTestRow.PRODUCT_SAMPLE_ID) ? getLabTestRow.PRODUCT_SAMPLE_ID : ''#" id="test_rows"  title="#getLang('','Test İşlem ve Parametreleri',64138)#"></cf_box>
            <cfif len(getLabTestRow.sampling_id)>
                <cf_box box_page="#request.self#?fuseaction=lab.sampling_row&sampling_id=#getLabTestRow.sampling_id#" id="sampling_rows" title="#getLang('','',64055)#"></cf_box>
            <cfelse>
                <cf_box box_page="#request.self#?fuseaction=lab.sampling_row" id="sampling_rows" title="#getLang('','',64055)#"></cf_box>
            </cfif>
        </cfform>
    </div>
</cfif>
<script>
    function getAnalyzeParameter(element) {
        var refinery_test_id = element.value;
        if( refinery_test_id != '' ){
            AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=recycle.analysis_template_rows&getResultLimit=1&refinery_test_id='+refinery_test_id+'','body_row');
        }
    }
    function kontrol() {
        if(analyzeLabTest.requesting_employee_id.value.length == 0 && analyzeLabTest.requesting_employee_name.value.length == 0 )
        {
            alert("<cf_get_lang dictionary_id='62137.Analiz Talep Eden'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if(analyzeLabTest.lab_report_no.value.length == "")
        {
            alert("<cf_get_lang dictionary_id='62139.Lab Rapor No'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if(analyzeLabTest.sample_employee_id.value == "" || analyzeLabTest.sample_employee_name.value == "")
        {
            alert("<cf_get_lang dictionary_id='62135.Numuneyi Alan Kişi'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if(analyzeLabTest.department_id.value == '' || analyzeLabTest.location_id.value == '' || analyzeLabTest.department_name.value == '') {
            alert('Depo seçmelisiniz!');
            return false;
        }
        if(analyzeLabTest.numune_date.value == '' || analyzeLabTest.numune_hour.value == '' || analyzeLabTest.numune_minute.value == '') {
            alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='62138.Numune Alım Tarihi'>");
            return false;
        }
        /*
        if((analyzeLabTest.consumer_id.value == "" || analyzeLabTest.member_name.value == "") && (analyzeLabTest.company_id.value == "" || analyzeLabTest.member_name.value == ""))
        {
            alert("<cf_get_lang dictionary_id='38282.Cari Hesap Seçmelisiniz'>");	
            return false;
        }
        */
        unformat_fields();
        return true;
    }
    function unformat_fields()
    {
        
        if( analyzeLabTest.parameterCountSave.value != '' && parseInt(analyzeLabTest.parameterCountSave.value) > 0 ){
            for (i = 1; i <= parseInt(analyzeLabTest.parameterCountSave.value); i++) {
                if( $("#minLimit"+i+"") != 'undefined' && $("#minLimit"+i+"").val() != '' ) $("#minLimit"+i+"").val( filterNum( $("#minLimit"+i+"").val() ) );
                if( $("#maxLimit"+i+"") != 'undefined' && $("#maxLimit"+i+"").val() != '' ) $("#maxLimit"+i+"").val( filterNum( $("#maxLimit"+i+"").val() ) );
            }
        }

    }
</script>