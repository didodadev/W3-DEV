<cfquery name="get_app" datasource="#dsn#" maxrows="1">
	SELECT EMPAPP_ID FROM EMPLOYEES_APP WHERE APP_COLOR_STATUS = #attributes.file_status_id#
</cfquery>
<cfquery name="GET_FORMAT" datasource="#dsn#">
	SELECT *,#dsn#.Get_Dynamic_Language(STATUS_ID,'#session.ep.language#','SETUP_CV_STATUS','STATUS',NULL,NULL,STATUS) AS dynamic_status FROM SETUP_CV_STATUS <cfif isDefined("attributes.file_status_id")>WHERE STATUS_ID = #attributes.file_status_id#</cfif>
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='44549.CV  Değerlendirme Kategorileri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.add_cv_color_format" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
            <cfinclude template="../display/list_cv_color_format.cfm">
        </div> 
        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform name="format" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_del_cv_color_format" enctype="multipart/form-data">
                <cfinput type="Hidden" name="file_status_id" id="file_status_id" value="#attributes.file_status_id#">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-status">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57736.Durum Adı Girmelisiniz'> !</cfsavecontent>
                                    <cfinput type="Text" name="status" value="#get_format.dynamic_status#" required="yes" message="#message#" maxlength="50">
                                    <span class="input-group-addon">
                                        <cf_language_info	
                                        table_name="SETUP_CV_STATUS"
                                        column_name="STATUS" 
                                        column_id_value="#attributes.file_status_id#" 
                                        maxlength="500" 
                                        datasource="#dsn#" 
                                        column_id="STATUS_ID" 
                                        control_type="0">
                                    </span>
                                </div>	
                            </div>	
                        </div>
                        <div class="form-group" id="item-image">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29762.İmaj'></label>
                            <input type="hidden" name="old_icon" id="old_icon" value="<cfoutput>#get_format.icon_name#</cfoutput>">
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="file" name="icon" id="icon" value="">
                                    <span class="input-group-addon"  href="javascript://" onClick="windowopen('<cfoutput>#file_web_path#hr/cv_image/#get_format.icon_name#</cfoutput> ','medium');"><i class="fa fa-image"></i>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea name="detail" id="detail" value="<cfoutput>#get_format.detail#</cfoutput>" maxlength="100"></textarea>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_record_info query_name="get_format">
                    <cfif get_app.recordcount>
                        <cf_workcube_buttons is_upd='1' is_delete='0'>
                    <cfelse>
                        <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_cv_color&file_status_id=#attributes.file_status_id#'>
                    </cfif>
                </cf_box_footer>
            </cfform>    
        </div>
  	</cf_box>
</div>
