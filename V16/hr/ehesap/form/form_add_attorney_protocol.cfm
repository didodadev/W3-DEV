<cfquery NAME="GET_EMPLOYEE_EVENT_ATTORNEY_PROTOCOL" DATASOURCE="#DSN#">
	SELECT
		*
	FROM
		EMPLOYEE_EVENT_ATTORNEY_PROTOCOL
	WHERE
		EVENT_ID=#attributes.EVENT_ID#
</cfquery>
<cfif GET_EMPLOYEE_EVENT_ATTORNEY_PROTOCOL.RECORDCOUNT>
    <cflocation url="#request.self#?fuseaction=ehesap.popup_form_upd_attorney_protocol&attorney_protocol_id=#get_employee_event_attorney_protocol.attorney_protocol_id#&event_id=#attributes.event_id#" addtoken="no">
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Savcılığa Bildirim Yazısı',53183)#">
        <cfform name="add_attorney_protocol" action="#request.self#?fuseaction=ehesap.emptypopup_add_attorney_protocol" method="post">
            <cf_box_elements>
                <div class="col col-12 col-md-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-IS_ATTORNEY">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='32164.Olay Tutanağı Ekle'></label>
                        <label class="col col-9 col-xs-12">
                            <input type="checkbox" name="IS_ATTORNEY" id="IS_ATTORNEY" checked>
                        </label>
                    </div>
                    <div class="form-group" id="item-PROTOCOL_HEAD">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57480.Başlık'>*</label>
                        <div class="col col-9 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.başlık girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="PROTOCOL_HEAD" value="" style="width:150px;" required="yes" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-PROTOCOL_DATE">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="event_id" id="event_id" value="<cfoutput>#attributes.event_id#</cfoutput>">
                                <cfinput validate="#validate_style#" type="text" name="PROTOCOL_DATE"  value="" style="width:150px;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="PROTOCOL_DATE"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
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

