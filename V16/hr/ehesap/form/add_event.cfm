<cfinclude template="../query/get_branches.cfm">
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform name="add_event" action="#request.self#?fuseaction=ehesap.emptypopup_add_event" method="post">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-event_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53088.Olay Türü'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="event_type" id="event_type">
                                    <option  value="">Seçiniz</option>
                                    <option  value="1">Olay Tutanağı</option>
                                    <option  value="2">İş Kazası Tutanağı</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-BRANCH_ID">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="BRANCH_ID" id="BRANCH_ID">
                                <cfoutput query="BRANCHES">
                                    <option  value="#BRANCH_ID#">#BRANCH_NAME#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-caution_to">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53324.İhmal Eden'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="caution_to_id" id="caution_to_id">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='53326.İhmal Eden girmelisiniz'></cfsavecontent>
                                <cfinput required="yes" message="#message#" type="text" name="caution_to">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_event.caution_to_id&field_emp_name=add_event.caution_to','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-SIGN_DATE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53476.Onay Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput validate="#validate_style#" type="text" name="SIGN_DATE" value="">
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
                                <cfinput validate="#validate_style#" type="text" name="event_date_" value="">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="event_date_"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-witness2_to">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53325.Tanık'> 1 *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="witness2_id" id="witness2_id">
                                <input type="text" name="witness2_to" id="witness2_to">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_event.witness2_id&field_emp_name=add_event.witness2_to','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-witness1_to">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53325.Tanık'> 2 *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="witness1_id" id="witness1_id">
                                <input type="text" name="witness1_to" id="witness1_to">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_event.witness1_id&field_emp_name=add_event.witness1_to','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-witness3_to">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53325.Tanık'> 3 *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="witness3_id" id="witness3_id">
                                <input type="text" name="witness3_to" id="witness3_to">
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
                            value=""
                            width="475"
                            height="300">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-12">
                    <cf_workcube_buttons is_upd='0'>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>

