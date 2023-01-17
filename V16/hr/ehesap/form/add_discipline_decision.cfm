<cfinclude template="../query/get_discipline_decision.cfm">
<cfif get_discipline_detail.recordcount>
	<cflocation addtoken="no" url="#request.self#?fuseaction=ehesap.popup_upd_discipline_decision&discipline_id=#get_discipline_detail.DISCIPLINE_ID#">
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Disiplin Kurulu Kararı',53299)#">
        <cfform name="add_discipline" action="#request.self#?fuseaction=ehesap.emptypopup_add_discipline_decision" method="post">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-meeting_no">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53300.Toplantı No'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="meeting_no" id="meeting_no"  style="width:150px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-MEETING_DATE">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53301.Toplantı Tarihi'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfinput validate="#validate_style#" type="text" name="MEETING_DATE" value="" style="width:150px;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="MEETING_DATE"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-folder_no">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53302.Dosya No'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="folder_no" id="folder_no"  style="width:150px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-decision_no">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53303.Karar No'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="decision_no" id="decision_no"  style="width:150px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-DELIVER_DATE">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53304.Disiplin Kuruluna Sevk Tarihi'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfinput validate="#validate_style#" type="text" name="DELIVER_DATE" value="" style="width:150px;"> 
                                <span class="input-group-addon"><cf_wrk_date_image date_field="DELIVER_DATE"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-chairman">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53305.Baskan'>*</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="event_id" id="event_id" value="<cfoutput>#attributes.event_id#</cfoutput>">
                                <input type="hidden" name="chairman_id" id="chairman_id">
                                <input type="text" name="chairman" id="chairman" style="width:150px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_discipline.chairman_id&field_emp_name=add_discipline.chairman','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-member1">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57658.Üye'>*</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="member1_id" id="member1_id">
                                <input type="text" name="member1" id="member1" style="width:150px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_discipline.member1_id&field_emp_name=add_discipline.member1','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-member2">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57658.Üye'>*</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="member2_id" id="member2_id">
                                <input type="text" name="member2" id="member2" style="width:150px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_discipline.member2_id&field_emp_name=add_discipline.member2','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-DECISION_DATE">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53306.Karar Tarihi'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfinput validate="#validate_style#" type="text" name="DECISION_DATE" value="" style="width:150px;"> 
                                <span class="input-group-addon"><cf_wrk_date_image date_field="DECISION_DATE"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-12 col-xs-12" type="column" index="3" sort="false">
                    <div class="form-group" id="item-decision_detail">
                        <div class="col col-12 col-xs-12">
                            <cfmodule
                            template="/fckeditor/fckeditor.cfm"
                            toolbarSet="WRKContent"
                            basePath="/fckeditor/"
                            instanceName="decision_detail"
                            valign="top"
                            value=""
                            width="500"
                            height="300">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
