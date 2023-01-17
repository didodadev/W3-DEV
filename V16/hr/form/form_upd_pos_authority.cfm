<cfquery name="get_authority" datasource="#dsn#">
    SELECT 
    	AUTHORITY_ID, 
        AUTHORITY_HEAD, 
        AUTHORITY_DETAIL, 
        RECORD_DATE, 
        RECORD_MEMBER, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_MEMBER,
        UPDATE_IP
    FROM 
	    EMPLOYEE_AUTHORITY 
    WHERE 
    	AUTHORITY_ID = #attributes.authority_id#
</cfquery>

<cf_box title="#getLang('','Yetki ve Sorumluluk Güncelle',55732)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="position" action="#request.self#?fuseaction=hr.emptypopup_upd_content&authority_id=#url.authority_id#&position_id=#url.position_id#" method="post">
        <input type="hidden" name="popup" id="popup" value="1">
        <cf_box_elements>
            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58820.Başlık'></label>
                    <div class="col col-8 col-sm-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'></cfsavecontent>
                        <cfinput type="text" name="CONTENT_HEAD" value="#get_authority.AUTHORITY_HEAD#" required="Yes" message="#message#" maxlength="100">
                    </div>                
                </div> 
            </div>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group require" id="item-process_stage">
                    <cfmodule
                        template="/fckeditor/fckeditor.cfm"
                        toolbarSet="WRKContent"
                        basePath="/fckeditor/"
                        instanceName="CONTENT_DETAIL"
                        valign="top"
                        value="#get_authority.AUTHORITY_DETAIL#"
                        width="500"
                        height="300"> 
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_record_info query_name="get_authority" record_emp="record_member" update_emp="update_member">
            <cf_workcube_buttons type_format="1" is_upd='0'>
        </cf_box_footer>
    </cfform>
</cf_box>
