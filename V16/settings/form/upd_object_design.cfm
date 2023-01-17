<cfquery name="object_design_detail" datasource="#dsn#">
	SELECT 
	    DESIGN_ID, 
        DESIGN_NAME, 
        DESIGN_DETAIL, 
        DESIGN_PATH, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP 
    FROM 
    	MAIN_SITE_OBJECT_DESIGN 
    WHERE 
	    DESIGN_ID = #attributes.id#
</cfquery>
<div class="col col-2 col-md-2 col-sm-2 col-xs-12" type="column" index="1" sort="true">
    <cfinclude template="../display/list_object_design.cfm">
</div>
<div class="col col-10 col-md-10 col-sm-10 col-xs-12">
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='29792.Tasarım'></cfsavecontent>
    <cf_box title="#title#" add_href="#request.self#?fuseaction=settings.form_add_object_design" is_blank="0">
        <cfform name="upd_object_design" action="#request.self#?fuseaction=settings.emptypopup_upd_object_design" method="post">
            <input type="hidden" name="design_id" id="design_id" value="<cfoutput>#attributes.id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="2" sort="true">                        
                    <div class="form-group">
                        <label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43440.Tasarım Adı'>*</label>
                        <div class="col col-8 col-md-6 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='43441.Tasarım Adı Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="design_name" value="#object_design_detail.design_name#" maxlength="30" required="Yes" message="#message#">							
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43398.Tasarım Path'>*</label>
                        <div class="col col-8 col-md-6 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='43428.Path Girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" name="design_path" value="#object_design_detail.design_path#" maxlength="250" required="Yes" message="#message#">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                        <div class="col col-8 col-md-6 col-xs-12">
                            <textarea name="design_detail" id="design_detail" style="height:75px;"><cfoutput>#object_design_detail.design_detail#</cfoutput></textarea>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cfoutput>
                    <cfif len(get_object_design.RECORD_EMP)>                            
                        <cf_record_info query_name="get_object_design" update_date="get_object_design">
                    </cfif>
                </cfoutput>
                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_object_design&design_id=#attributes.id#'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>