<cfinclude template="../query/get_defence_detail.cfm">
<cfif get_defence.recordcount>
	<cflocation url="#request.self#?fuseaction=ehesap.popup_upd_defence_paper&defence_id=#get_defence.DEFENCE_ID#" addtoken="no">
</cfif>


<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Savunma Talep Yazısı',53295)#">
        <cfform name="add_defence" action="#request.self#?fuseaction=ehesap.emptypopup_add_defence_paper" method="post">
            <cf_box_elements>
                <div class="col col-12 col-md-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58183.Yazan'>*</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="event_id" id="event_id" value="<cfoutput>#attributes.event_id#</cfoutput>">
                                <input type="hidden" name="writer_id" id="writer_id">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='53298.Yazan girmelisiniz'></cfsavecontent>
                                <cfinput  required="yes" message="#message#" type="text" name="writer" style="width:150px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_defence.writer_id&field_emp_name=add_defence.writer','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53297.İmza Tarihi'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfinput validate="#validate_style#" type="text" name="PAPER_DATE" value="" style="width:150px;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="PAPER_DATE"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col col-12 col-xs-12">
                            <cfmodule
                                template="/fckeditor/fckeditor.cfm"
                                toolbarSet="WRKContent"
                                basePath="/fckeditor/"
                                instanceName="detail"
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
