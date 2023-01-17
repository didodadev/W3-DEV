<cfinclude template="../query/get_punishment_paper.cfm">
<cfif get_punishment_paper.recordcount>
	<cflocation addtoken="no" url="#request.self#?fuseaction=ehesap.popup_upd_punishment_paper&punishment_paper_id=#get_punishment_paper.PUNISHMENT_PAPER_ID#">
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Ceza Tebliğ Yazısı',53456)#">
        <cfform  name="add_punishment" action="#request.self#?fuseaction=ehesap.emptypopup_add_punishment_paper" method="post">
            <cf_box_elements>
                <div class="col col-6 col-md-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-PUNISHMENT_SUBJECT">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="PUNISHMENT_SUBJECT" id="PUNISHMENT_SUBJECT"  style="width:150px;"  >
                        </div>
                    </div>
                    <div class="form-group" id="item-MANAGER">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58183.Yazan'> *</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="event_id" id="event_id" value="<cfoutput>#attributes.event_id#</cfoutput>">
                                <input type="hidden" name="MANAGER_ID" id="MANAGER_ID">
                                <input type="text" name="MANAGER" id="MANAGER" style="width:150px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_punishment.MANAGER_ID&field_emp_name=add_punishment.MANAGER','list');return false"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-12 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-ABOLITION_SUBJECT">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53155.Kimden'></label>
                        <div class="col col-9 col-xs-12">
                            <input  type="text"  name="FROM_WHO" id="FROM_WHO" style="width:150px;"  value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-ABOLITION_DATE">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53157.Fesih Tarihi'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfinput validate="#validate_style#" type="text" name="PUNISHMENT_DATE" value="" style="width:150px;"> 
                                <span class="input-group-addon"><cf_wrk_date_image date_field="PUNISHMENT_DATE"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-12 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-PUNISHMENT_DETAIL">
                        <div class="col col-12 col-xs-12">
                            <cfmodule
                            template="/fckeditor/fckeditor.cfm"
                            toolbarSet="WRKContent"
                            basePath="/fckeditor/"
                            instanceName="PUNISHMENT_DETAIL"
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


