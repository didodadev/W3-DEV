<cfif isnumeric(attributes.refinery_visitor_register_id)>
    <cfset facility_visitor = createObject("component","WBP/Recycle/files/recycle_facility_tools/cfc/facility_visitor") />
			
	<cfset getFacilityVisitor = facility_visitor.getFacilityVisitor(
		refinery_visitor_register_id: attributes.refinery_visitor_register_id
    ) />
</cfif>

<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.isg_entry_time" default="">
<cfparam name="attributes.isg_exit_time" default="">
<cfinclude template="../../header.cfm">
<cf_catalystHeader>
<cfif getFacilityVisitor.recordcount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cfform name="saveProductOffFunction" id="saveProductOffFunction">
                <cfinput type="hidden" name="refinery_visitor_register_id" id="refinery_visitor_register_id" value="#attributes.refinery_visitor_register_id#">
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_workcube_process is_upd='0' select_value='#getFacilityVisitor.PROCESS_STAGE#' process_cat_width='250' is_detail='1'></div>
                        </div>
                        <div class="form-group" id="item-visitorName">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37187.Ziyaretçi'> <cf_get_lang dictionary_id='32370.Adı Soyadı'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text" name="visitorName" id="visitorName" value="#getFacilityVisitor.VISITOR_NAME#"></div>
                        </div>
                        <div class="form-group" id="item-tcIdentityNumber">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62119.Ziyaretçi TCKN'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text" name="tcIdentityNumber" id="tcIdentityNumber" value="#getFacilityVisitor.TC_IDENTITY_NUMBER#" maxlength="11"></div>
                        </div>
                        <div class="form-group" id="item-special_code">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62114.Hes Kodu'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text" name="special_code" id="special_code" value="#getFacilityVisitor.SPECIAL_CODE#"></div>
                        </div>
                        <div class="form-group" id="item-phoneNumber">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57220.Telefon Numarası'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text" name="phoneNumber" id="phoneNumber" value="#getFacilityVisitor.PHONE_NUMBER#" maxlength="11"></div>
                        </div>
                        <div class="form-group" id="item-emailAddress">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32508.E-mail'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text" name="emailAddress" id="emailAddress" value="#getFacilityVisitor.EMAIL_ADDRESS#"></div>
                        </div>
                        <div class="form-group" id="item-analyze_company_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58607.Firma'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="consumer_id" id="consumer_id" value="#getFacilityVisitor.CONSUMER_ID#">
                                    <cfinput type="hidden" name="company_id" id="company_id" value="#getFacilityVisitor.COMPANY_ID#">
                                    <cfinput type="hidden" name="member_type" id="member_type" value="#getFacilityVisitor.MEMBER_TYPE#">
                                    <cfinput name="analyze_company_name" type="text" id="analyze_company_name" onFocus="AutoComplete_Create('analyze_company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="#(Len(getFacilityVisitor.FULLNAME) ? getFacilityVisitor.FULLNAME : getFacilityVisitor.CONSUMER_NAME & ' ' & getFacilityVisitor.CONSUMER_SURNAME)#" autocomplete="off">
                                    <cfset str_linke_ait="&field_consumer=saveProductOffFunction.consumer_id&field_comp_id=saveProductOffFunction.company_id&field_member_name=saveProductOffFunction.analyze_company_name&field_type=saveProductOffFunction.member_type">
                                    <cfoutput><span class="input-group-addon icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_all_pars#str_linke_ait#&select_list=7,8&keyword='+encodeURIComponent(document.saveProductOffFunction.analyze_company_name.value),'list');"></span></cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-car_number">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='60932.Araç Plaka Numarası'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text" name="car_number" id="car_number" value="#getFacilityVisitor.CAR_NUMBER#"></div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-employeeName">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51923.Ziyaret Edilen'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="employeeId" id="employeeId"  value="#getFacilityVisitor.EMPLOYEE_ID#">
                                    <cfinput type="text" name="employeeName" id="employeeName" onFocus="AutoComplete_Create('employeeName','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3,0,0,0,2,1,0,0,1','EMPLOYEE_ID','employeeId','saveProductOffFunction','3','135');" value="#getFacilityVisitor.EMPLOYEE_NAME# #getFacilityVisitor.EMPLOYEE_SURNAME#">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=saveProductOffFunction.employeeId&field_name=saveProductOffFunction.employeeName&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.saveProductOffFunction.employeeName.value),'list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-visitTime">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62110.Ziyaret Zamanı Giriş'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <cfinput type="text" name="visitTime" id="visitTime" value="#len(getFacilityVisitor.VISIT_TIME) ? dateformat(getFacilityVisitor.VISIT_TIME,dateformat_style) : ''#" validate="#validate_style#" maxlength="10" readonly>
                                <!--- <span class="input-group-addon"><cf_wrk_date_image date_field="visitTime"></span> --->
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <cf_wrkTimeFormat name="visit_entry_hour" value="#len(getFacilityVisitor.VISIT_TIME) ? hour(getFacilityVisitor.VISIT_TIME) : ''#" disable="disabled">
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <select name="visit_entry_minute" id="visit_entry_minute" disabled>
                                    <cfloop from="0" to="59" index="a">
                                        <cfoutput><option value="#Numberformat(a,00)#" #(len(getFacilityVisitor.VISIT_TIME) and Numberformat(a,00) eq minute(getFacilityVisitor.VISIT_TIME)) ? 'selected' : ''#>#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-visitTime_exit">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62109.Ziyaret Zamanı Çıkış'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <cfinput type="text" name="visitTime_exit" id="visitTime_exit" value="#dateformat(getFacilityVisitor.VISIT_TIME_EXIT,dateformat_style)#" validate="#validate_style#" maxlength="10" readonly>
                                <!--- <span class="input-group-addon"><cf_wrk_date_image date_field="visitTime_exit"></span> --->
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <cf_wrkTimeFormat name="visit_exit_hour" value="#len(getFacilityVisitor.VISIT_TIME_EXIT) ? hour(getFacilityVisitor.VISIT_TIME_EXIT) : ''#" disable="disabled">
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <select name="visit_exit_minute" id="visit_exit_minute" disabled>
                                    <cfloop from="0" to="59" index="a">
                                        <cfoutput><option value="#Numberformat(a,00)#" #(len(getFacilityVisitor.VISIT_TIME_EXIT) and Numberformat(a,00) eq minute(getFacilityVisitor.VISIT_TIME_EXIT)) ? 'selected' : ''#>#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-visitorCartnumber">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62115.Ziyaretçi Kartı Numarası'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text" name="visitorCartnumber" id="visitorCartnumber" value="#getFacilityVisitor.VISITOR_CART_NUMBER#"></div>
                        </div>
                        <div class="form-group" id="item-visitorPurpose">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62113.Ziyaret Amacı'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text" name="visitorPurpose" id="visitorPurpose" value="#getFacilityVisitor.VISITOR_PURPOSE#"></div>
                        </div>
                        <div class="form-group" id="item-note">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea name="note" id="note" style="width:140px;height:45px;"><cfoutput>#getFacilityVisitor.NOTE#</cfoutput></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-isg_entry_time">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62112.ISG Eğitim Veriliş Tarihi'></label>
                            <div class="col col-8 col-md-3 col-sm-3 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="isg_entry_time" value="#dateformat(getFacilityVisitor.ISG_ENTRY_TIME,dateformat_style)#" validate="#validate_style#" maxlength="10" message="" readonly>
                                    <!--- <span class="input-group-addon"><cf_wrk_date_image date_field="isg_entry_time"></span> --->
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-isg_exit_time">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62111.ISG Eğitim Geçerlilik Tarihi'></label>
                            <div class="col col-8 col-md-3 col-sm-3 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="isg_exit_time" value="#dateformat(getFacilityVisitor.ISG_EXIT_TIME,dateformat_style)#" validate="#validate_style#" maxlength="10" message="" readonly>
                                    <!--- <span class="input-group-addon"><cf_wrk_date_image date_field="isg_exit_time"></span> --->
                                </div>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <div class="col col-6">
                        <cf_record_info query_name="getFacilityVisitor" margintop="1">
                    </div>
                    <div class="col col-6">
                        <cf_workcube_buttons is_upd="1" delete_page_url='#request.self#?fuseaction=recycle.facility_visitor&event=del&id=#attributes.refinery_visitor_register_id#' add_function="kontrol()">
                    </div>
                </cf_box_footer>
            </cfform>
        </cf_box>
    </div>
    <script>
        function kontrol() {
            if(saveProductOffFunction.visitorName.value.length == "")
            {
                alert("<cf_get_lang dictionary_id='53168.Ad Soyad Girmelisiniz'> !");	
                return false;
            }
            if(saveProductOffFunction.tcIdentityNumber.value == "")
            {
                alert("<cf_get_lang dictionary_id='62119.Ziyaretçi TCKN'> <cf_get_lang dictionary_id='30941.Boş'>!");	
                return false;
            }
            if(saveProductOffFunction.employeeName.value.length == "")
            {
                alert("<cf_get_lang dictionary_id='51923.Ziyaret Edilen'> <cf_get_lang dictionary_id='30941.Boş'>");	
                return false;
            }
            if(saveProductOffFunction.visitorPurpose.value == "")
            {
                alert("<cf_get_lang dictionary_id='62113.Ziyaret Amacı'> <cf_get_lang dictionary_id='30941.Boş'>!");	
                return false;
            }
            return true;
        }
    </script>
</cfif>