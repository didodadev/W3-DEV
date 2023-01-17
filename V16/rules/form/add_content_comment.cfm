<cfquery name="get_employee_email" datasource="#dsn#">
	SELECT EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cf_popup_box title="#getLang('content',158)#"><!---.Yorum Ekle'--->
    <cfform name="employe_detail" method="post" action="#request.self#?fuseaction=rule.emptypopup_add_content_comment">
        <input type="hidden" name="content_id" id="content_id" value="<cfoutput>#attributes.content_id#</cfoutput>">
        <div class="row">
            <div class="col col-12 col-xs-12 col-md-12 col-sm-12">
                <div class="form-group">
                    <div class="col col-4">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='219.Adınız'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="name" id="name" style="width:155px;" maxlength="50" readonly value="<cfoutput>#session.ep.name#</cfoutput>">
                        </div>
                    </div>
                    <div class="col col-4">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='16.email'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='16.E-mail !'></cfsavecontent>
                            <cfinput type="text" name="MAIL_ADDRESS" style="width:178px;" maxlength="100" value="#get_employee_email.employee_email#" required="yes" message="#MESSAGE#">
                        </div> 
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-4">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1314.Soyadınız'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="surname" id="surname" style="width:155px;" maxlength="50" readonly value="<cfoutput>#session.ep.surname#</cfoutput>">
                        </div>
                    </div> 
                    <div class="col col-4">
                        <label class="col col-4 col-xs-12"> <cf_get_lang_main no='1572.Puan'></label>
                        <div class="col col-8 col-xs-12">  
                            <label><input name="CONTENT_COMMENT_POINT" id="CONTENT_COMMENT_POINT" type="radio" value="1"> 1</label>
                            <label><input name="CONTENT_COMMENT_POINT" id="CONTENT_COMMENT_POINT" type="radio" value="2"> 2</label>
                            <label><input name="CONTENT_COMMENT_POINT" id="CONTENT_COMMENT_POINT" type="radio" value="3"> 3</label>
                            <label><input name="CONTENT_COMMENT_POINT" id="CONTENT_COMMENT_POINT" type="radio" value="4"> 4</label>
                            <label><input name="CONTENT_COMMENT_POINT" id="CONTENT_COMMENT_POINT" type="radio" value="5" checked> 5</label>
                        </div>
                    </div>   
                </div>
            </div>
        </div>    
            <div class="form-group">
                <cfmodule
                    template="/fckeditor/fckeditor.cfm"
                    toolbarset="WRKContent"
                    basepath="/fckeditor/"
                    instancename="CONTENT_COMMENT"
                    valign="top"
                    value=""
                    width="660"
                    height="270">	
            </div> 
        <cf_popup_box_footer>
            <cf_workcube_buttons is_upd='0'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
        </cf_popup_box_footer>
    </cfform>
</cf_popup_box>
