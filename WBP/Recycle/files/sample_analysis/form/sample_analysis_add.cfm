<cfinclude template="../../header.cfm">
<cfparam name="attributes.numune_date" default="">
<cfparam name="attributes.numune_accept_date" default="">
<cfparam name="attributes.analyse_date" default="">
<cfparam name="attributes.analyse_date_exit" default="">
<cfparam name="attributes.product_sample_id" default="">

<cf_papers paper_type="sample_analysis">
<cfif isdefined("paper_full") and len(paper_full)>
    <cfset paper_full = paper_full & '-#right(session.ep.period_year,2)#'>
    <cfset paper_full = listSetAt(paper_full,2,numberFormat(listGetAt(paper_full,2,'-'),'0000'),'-')>
<cfelse>
    <cfset paper_full = "">
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
<cfset analysis_parameters = createObject("component","WBP/Recycle/files/sample_analysis/cfc/analysis_parameters") />
<cfset waste_operation = createObject("component","WBP/Recycle/files/waste_operation/cfc/waste_operation") />
<cfset getWasteOperation = waste_operation.getWasteOperation(is_exit_date_null:1, is_analyzeLab:1) />
<cfset getSamplingPoints = sampling_points.getSamplingPoints() />
<cfset getAnalysisCat = analysis_parameters.getAnalysisCat() />
    
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfoutput>
        <cfform name="analyzeLabTest" id="analyzeLabTest">
            <cf_box>
                <cf_box_elements id="labTestAddModal">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_workcube_process is_upd='0' process_cat_width='250' is_detail='0'></div>
                        </div>
                        <div class="form-group" id="item-lab_report_no">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62139.Lab Rapor No'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="lab_report_no" id="lab_report_no" value="#paper_full#">
                            </div>
                        </div>
                        <div class="form-group" id="item-refinery_waste_oil_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62157.Atık Yağ Kabul'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="refinery_waste_oil_id" id="refinery_waste_oil_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="#getWasteOperation#">
                                        <option value="#REFINERY_WASTE_OIL_ID#">#DORSE_PLAKA# / #GENERAL_PAPER_NO#</option>
                                    </cfloop>
                                </select>
                            </div>
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
                        <div class="form-group" id="item-member_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34578.Firma Adı'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="consumer_id" id="consumer_id">
                                    <input type="hidden" name="company_id" id="company_id">
                                    <input type="hidden" name="member_type" id="member_type">
                                    <input name="member_name" type="text" id="member_name" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="" autocomplete="off">
                                    <cfset str_linke_ait="&field_consumer=analyzeLabTest.consumer_id&field_comp_id=analyzeLabTest.company_id&field_member_name=analyzeLabTest.member_name&field_type=analyzeLabTest.member_type">
                                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput>&select_list=7,8&keyword='+encodeURIComponent(document.analyzeLabTest.member_name.value));"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-get_sample">
                            <cfif isDefined("attributes.product_sample_id") and len(attributes.PRODUCT_SAMPLE_ID)>
                                <cfquery name="get_samp_detail" datasource="#dsn3#">
                                    SELECT PRODUCT_SAMPLE_NAME FROM PRODUCT_SAMPLE WHERE PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_sample_id#">
                                </cfquery>
                            <cfelse>
                                <cfset get_samp_detail.PRODUCT_SAMPLE_NAME=''>
                            </cfif>
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62603.Numune'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="p_sample_id" id="p_sample_id" value="#attributes.product_sample_id#">
                                    <input type="text" name="p_sample_name" id="p_sample_name" value="<cfif isDefined("attributes.product_sample_id") and len(attributes.PRODUCT_SAMPLE_ID)>#get_samp_detail.PRODUCT_SAMPLE_NAME#</cfif>">
                                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=product.list_product_samples&field_sample_name=analyzeLabTest.p_sample_name&field_sample_id=analyzeLabTest.p_sample_id')"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-numune_person">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62135.Numune Alan Kişi'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="sample_employee_id" id="sample_employee_id"><!--- çalışanlar için --->
                                    <input type="hidden" name="from_company_id" id="from_company_id"><!--- kurumsal üyeler için --->
                                    <input type="hidden" name="from_partner_id" id="from_partner_id"><!--- kurumsal üyeler için --->
                                    <input type="hidden" name="from_consumer_id" id="from_consumer_id"><!--- bireysel üyeler için --->              
                                    <input type="text" name="sample_employee_name" id="sample_employee_name" onfocus="AutoComplete_Create('sample_employee_name','MEMBER_PARTNER_NAME3','MEMBER_PARTNER_NAME3','get_member_autocomplete','','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID,PARTNER_ID','from_consumer_id,from_company_id,sample_employee_id,from_partner_id','','3','250');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=analyzeLabTest.sample_employee_id&field_name=analyzeLabTest.sample_employee_name&field_partner=analyzeLabTest.from_partner_id&field_consumer=analyzeLabTest.from_consumer_id&field_comp_id=analyzeLabTest.from_company_id&is_form_submitted=1&select_list=1,7,8');" title="<cf_get_lang dictionary_id='30829.Talep Eden'>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-numune_date">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62138.Numune Alım Tarihi'>*</label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="numune_date" id="numune_date" value="#dateformat(attributes.numune_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="numune_date"></span>
                                </div>
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <cf_wrkTimeFormat name="numune_hour" value="">
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <select name="numune_minute" id="numune_minute">
                                    <cfloop from="0" to="59" index="a">
                                        <cfoutput><option value="#Numberformat(a,00)#">#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-numune_accept_date">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62123.Numune Kabul Tarihi'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="numune_accept_date" id="numune_accept_date" value="#dateformat(attributes.numune_accept_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="numune_accept_date"></span>
                                </div>
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <cf_wrkTimeFormat name="numune_accept_hour">
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <select name="numune_accept_minute" id="numune_accept_minute">
                                    <cfloop from="0" to="59" index="a">
                                        <cfoutput><option value="#Numberformat(a,00)#">#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-numune_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62140.Numune Adı & Tarifi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea name="numune_name" id="numune_name" style="width:140px;height:60px;"></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-numune_place">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62133.Numune Alınan Yer'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="numune_place" id="numune_place" />
                            </div>
                        </div>
                        <div class="form-group" id="item-numune_point">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62132.Numune Alım Noktası'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="numune_point" id="numune_point">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="#getSamplingPoints#">
                                        <option value="#SAMPLING_ID#">#SAMPLING_POINTS_NAME#</option>
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
                                    <input type="hidden" name="requesting_employee_id" id="requesting_employee_id" value="#session.ep.userid#"><!--- çalışanlar için --->
                                    <input type="hidden" name="from_company_id" id="from_company_id"><!--- kurumsal üyeler için --->
                                    <input type="hidden" name="from_partner_id" id="from_partner_id"><!--- kurumsal üyeler için --->
                                    <input type="hidden" name="from_consumer_id" id="from_consumer_id"><!--- bireysel üyeler için --->              
                                    <input type="text" name="requesting_employee_name" id="requesting_employee_name" value="#session.ep.name# #session.ep.surname#" style="width:100px;" <!--- onfocus="AutoComplete_Create('requesting_employee_name','MEMBER_PARTNER_NAME3','MEMBER_PARTNER_NAME3','get_member_autocomplete','','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID,PARTNER_ID','from_consumer_id,from_company_id,requesting_employee_id,from_partner_id','','3','250');" ---> autocomplete="off" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=analyzeLabTest.requesting_employee_id&field_name=analyzeLabTest.requesting_employee_name&field_partner=analyzeLabTest.from_partner_id&field_consumer=analyzeLabTest.from_consumer_id&field_comp_id=analyzeLabTest.from_company_id&is_form_submitted=1&select_list=1,7,8');" title="<cf_get_lang dictionary_id='30829.Talep Eden'>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-analyse_date">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62122.Analiz Başlangıç Tarihi'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="analyse_date" id="analyse_date" value="#dateformat(attributes.analyse_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="analyse_date"></span>
                                </div>
                            </div>
                            <div class="col col-2 col-md-4 col-sm-4 col-xs-12">
                                <cf_wrkTimeFormat name="analyse_date_entry_hour" value="">
                            </div>
                            <div class="col col-2 col-md-4 col-sm-4 col-xs-12">
                                <select name="analyse_date_entry_minute" id="analyse_date_entry_minute">
                                    <cfloop from="0" to="59" index="a">
                                        <cfoutput><option value="#Numberformat(a,00)#">#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-analyse_date_exit">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62120.Analiz Bitiş Tarihi'></label>
                            <div class="col col-4 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="analyse_date_exit" id="analyse_date_exit" value="#dateformat(attributes.analyse_date_exit,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="analyse_date_exit"></span>
                                </div>
                            </div>
                            <div class="col col-2 col-md-4 col-sm-4 col-xs-12">
                                <cf_wrkTimeFormat name="analyse_date_exit_hour" value="">
                            </div>
                            <div class="col col-2 col-md-4 col-sm-4 col-xs-12">
                                <select name="analyse_date_exit_minute" id="analyse_date_exit_minute">
                                    <cfloop from="0" to="59" index="a">
                                        <cfoutput><option value="#Numberformat(a,00)#">#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='46408.Açıklamalar'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea name="detail" id="detail" style="width:140px;height:60px;"></textarea>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>    
                    <cf_workcube_buttons
                    add_function="kontrol()"
                    data_action ="WBP/Recycle/files/sample_analysis/cfc/sample_analysis:saveLabTestForm"
                    next_page="#request.self#?fuseaction=lab.sample_analysis&event=upd&refinery_lab_test_id=">
                </cf_box_footer>
            </cf_box>
            <cf_box box_page="#request.self#?fuseaction=lab.test_parameters&is_sample=#isDefined("attributes.PRODUCT_SAMPLE_ID") and len(attributes.PRODUCT_SAMPLE_ID) ? "1" : ''#&product_sample_id=#isDefined("attributes.PRODUCT_SAMPLE_ID") and len(attributes.PRODUCT_SAMPLE_ID) ? attributes.PRODUCT_SAMPLE_ID : ''#" id="test_rows"  title="#getLang('','Test İşlem ve Parametreleri',64138)#"></cf_box>
            <cf_box box_page="#request.self#?fuseaction=lab.sampling_row" id="sampling_rows" title="Stoklardan Numune Alımı"></cf_box>
    </cfform>
    </cfoutput>
</div>
<script>
    function kontrol() {
        if(analyzeLabTest.lab_report_no.value == "")
        {
            alert("<cf_get_lang dictionary_id='62139.Lab Rapor No'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if(analyzeLabTest.requesting_employee_name.value == "" || analyzeLabTest.requesting_employee_id.value == "")
        {
            alert("<cf_get_lang dictionary_id='62137.Analiz Talep Eden'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if (!(analyzeLabTest.sample_employee_id.value != "" || analyzeLabTest.from_company_id.value != "" || analyzeLabTest.from_partner_id.value != ""  || analyzeLabTest.from_consumer_id.value != ""))
        {
            alert("<cf_get_lang dictionary_id='62135.Numuneyi Alan Kişi'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if(analyzeLabTest.department_id.value == '' || analyzeLabTest.location_id.value == '' || analyzeLabTest.department_name.value == '') {
            alert('Depo seçmelisiniz!');
            return false;
        }
        if(analyzeLabTest.numune_date.value == '' || analyzeLabTest.numune_hour.value == '' || analyzeLabTest.numune_minute.value == '') {
            alert('Numune alım tarihi zorunludur!');
            return false;
        }
        return true;
    }
  

</script>