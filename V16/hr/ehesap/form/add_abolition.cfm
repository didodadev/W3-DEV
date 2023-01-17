<cfinclude template="../query/get_abolition.cfm">
<cfif get_abolition.recordcount>
	<cflocation addtoken="no" url="#request.self#?fuseaction=ehesap.popup_upd_abolition&abolition_id=#get_abolition.ABOLITION_ID#">
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Fesih Yazısı',53153)#">
        <cfform  name="add_abolition" action="#request.self#?fuseaction=ehesap.emptypopup_add_abolition" method="post">
            <cf_box_elements>
                <div class="col col-6 col-md-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-ABOLITION_SUBJECT">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="ABOLITION_SUBJECT" id="ABOLITION_SUBJECT"  style="width:150px;"  >
                        </div>
                    </div>
                    <div class="form-group" id="item-head_quater">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53154.Genel Müdür'>*</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="event_id" id="event_id" value="<cfoutput>#attributes.event_id#</cfoutput>">
                                <input type="hidden" name="head_quater_id" id="head_quater_id">
                                <input type="text" name="head_quater" id="head_quater" style="width:150px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_abolition.head_quater_id&field_emp_name=add_abolition.head_quater','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-FROM_WHO">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53155.Kimden'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="FROM_WHO" id="FROM_WHO"  style="width:150px;"  >
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-12 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-ABOLITION_SUBJECT">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53156.İlgi'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="INTEREST" id="INTEREST"  style="width:150px;"  value="<cfoutput>#get_abolition.INTEREST#</cfoutput>" >
                        </div>
                    </div>
                    <div class="form-group" id="item-ABOLITION_DATE">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53157.Fesih Tarihi'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfinput validate="#validate_style#" type="text" name="ABOLITION_DATE" value="" style="width:130px;"> 
                                <span class="input-group-addon"><cf_wrk_date_image date_field="ABOLITION_DATE"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-12 col-md-12 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-abolition_detail">
                        <div class="col col-12 col-xs-12">
                            <cfmodule
                            template="/fckeditor/fckeditor.cfm"
                            toolbarSet="WRKContent"
                            basePath="/fckeditor/"
                            instanceName="abolition_detail"
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


