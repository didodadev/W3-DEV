<cfinclude template="../query/get_discipline_event.cfm">
<cfinclude template="../query/get_branches.cfm">
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform  name="add_event" action="#request.self#?fuseaction=ehesap.emptypopup_upd_event" method="post">
            <input type="hidden" name="event_id" id="event_id" value="<cfoutput>#attributes.EVENT_ID#</cfoutput>">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-branch.nick_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Firma'></label>
                        <div class="col col-8 col-xs-12">
                            <cfset my_comp_branch_id=get_event.branch_id>
                            <cfinclude template="../query/get_our_comp_and_branch_name.cfm">
                            <cfoutput>#get_com_branch.nick_name#</cfoutput>
                        </div>
                    </div>
                    <div class="form-group" id="item-BRANCH_ID">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="BRANCH_ID" id="BRANCH_ID" style="width:150px;">
                                <cfoutput query="BRANCHES">
                                    <option  value="#BRANCH_ID#" <cfif get_event.BRANCH_ID eq BRANCH_ID>Selected</cfif> >#BRANCH_NAME#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-event_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53088.Olay Türü'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="event_type" id="event_type">
                                <option  value="">Seçiniz</option>
                                <option  value="1"  <cfif get_event.event_type eq 1>Selected</cfif> >Olay Tutanağı</option>
                                <option  value="2"  <cfif get_event.event_type eq 2>Selected</cfif> >İş Kazası Tutanağı</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-caution_to">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53324.İhmal Eden'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfset EMP_ID=get_event.TO_CAUTION>
                                <cfif len(EMP_ID)>
                                    <cfinclude template="../query/get_action_emp.cfm">
                                    <cfset emp_name="#get_emp.EMPLOYEE_NAME# #get_emp.EMPLOYEE_SURNAME#">
                                <cfelse>
                                    <cfset emp_name="">
                                </cfif> 				  
                                <input type="hidden" name="caution_to_id" id="caution_to_id"  value="<cfoutput>#get_event.TO_CAUTION#</cfoutput>">
                                <input type="text" name="caution_to" id="caution_to" value="<cfoutput>#emp_name#</cfoutput>">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_event.caution_to_id&field_emp_name=add_event.caution_to','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-SIGN_DATE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53476.Onay Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput validate="#validate_style#" type="text" name="SIGN_DATE" value="#dateformat(get_event.SIGN_DATE,dateformat_style)#"> 
                                <span class="input-group-addon"><cf_wrk_date_image date_field="SIGN_DATE"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-event_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61146.Olay Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput validate="#validate_style#" type="text" name="event_date_" value="#dateformat(get_event.event_date,dateformat_style)#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="event_date_"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-witness2_to">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53325.Tanık'> 1 *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfset EMP_ID=get_event.WITNESS_1>
                                <cfif len(EMP_ID)>
                                    <cfinclude template="../query/get_action_emp.cfm">
                                    <cfset emp_name="#get_emp.EMPLOYEE_NAME# #get_emp.EMPLOYEE_SURNAME#">
                                <cfelse>
                                    <cfset emp_name="">
                                </cfif> 				  
                                <input type="hidden" name="witness1_id" id="witness1_id" value="<cfoutput>#get_event.WITNESS_1#</cfoutput>">
                                <input type="text" name="witness1_to" id="witness1_to"  value="<cfoutput>#emp_name#</cfoutput>" style="width:150px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_event.witness1_id&field_emp_name=add_event.witness1_to','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-witness1_to">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53325.Tanık'> 2 *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfset EMP_ID=get_event.WITNESS_2>
                                <cfif len(EMP_ID)>
                                    <cfinclude template="../query/get_action_emp.cfm">
                                    <cfset emp_name="#get_emp.EMPLOYEE_NAME# #get_emp.EMPLOYEE_SURNAME#">
                                <cfelse>
                                    <cfset emp_name="">
                                </cfif> 				  
                                <input type="hidden" name="witness2_id" id="witness2_id" value="<cfoutput>#get_event.WITNESS_2#</cfoutput>">
                                <input type="text" name="witness2_to" id="witness2_to"   value="<cfoutput>#emp_name#</cfoutput>" style="width:150px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_event.witness2_id&field_emp_name=add_event.witness2_to','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-witness3_to">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53325.Tanık'> 3 *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfset EMP_ID=get_event.WITNESS_3>
                                <cfif len(EMP_ID)>
                                    <cfinclude template="../query/get_action_emp.cfm">
                                    <cfset emp_name="#get_emp.EMPLOYEE_NAME# #get_emp.EMPLOYEE_SURNAME#">
                                <cfelse>
                                    <cfset emp_name="">
                                </cfif> 				  
                                <input type="hidden" name="witness3_id" id="witness3_id"  value="<cfoutput>#get_event.WITNESS_3#</cfoutput>">
                                <input type="text" name="witness3_to" id="witness3_to"  value="<cfoutput>#emp_name#</cfoutput>" style="width:150px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_event.witness3_id&field_emp_name=add_event.witness3_to','list');return false"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_elements vertical="1">
                <div class="col col-12 col-xs-12" type="column" index="3" sort="false">
                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="form-group" id="item-detail">
                        <div class="col col-12 col-xs-12">
                            <cfmodule
                            template="/fckeditor/fckeditor.cfm"
                            toolbarSet="WRKContent"
                            basePath="/fckeditor/"
                            instanceName="detail"
                            valign="top"
                            value="#get_event.DETAIL#"
                            width="500"
                            height="300">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6 col-xs-6">
                    <cf_record_info query_name="get_event">
                </div>
                <div class="col col-6 col-xs-6">
                    <cf_workcube_buttons is_upd='1'  delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_upd_event&is_del=1&event_id=#get_event.EVENT_ID#'>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
