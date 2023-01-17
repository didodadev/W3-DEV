<cfquery name="get_mail_detail" datasource="#dsn#">
    SELECT 
        EMP_APP_MAIL_ID, 
        EMPAPP_ID, 
        APP_POS_ID, 
        LIST_ID, 
        LIST_ROW_ID, 
        MAIL_HEAD, 
        EMPAPP_MAIL, 
        MAIL_CONTENT, 
        CATEGORY, 
        RECORD_PAR, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE,
        UPDATE_PAR, 
        UPDATE_EMP,
        UPDATE_IP, 
        UPDATE_DATE
    FROM 
        EMPLOYEES_APP_MAILS 
    WHERE 
        EMP_APP_MAIL_ID = #attributes.EMP_APP_MAIL_ID#
</cfquery>
<cfquery name="get_emp_mail" datasource="#dsn#">
    SELECT EMAIL FROM EMPLOYEES_APP WHERE EMPAPP_ID = #attributes.empapp_id#
</cfquery>
<cfquery name="get_cat" datasource="#DSN#">
    SELECT CORRCAT_ID, DETAIL, CORRCAT FROM SETUP_CORR ORDER BY CORRCAT
</cfquery>
<cfsavecontent variable="txt">					
    <select name="CORRCAT" id="CORRCAT" style="width:150px;" onChange="cat_template(this.selectedIndex)">
        <option value="0" selected>  </option>
        <cfoutput query="get_cat">
            <option value="#CORRCAT_ID#"<cfif (get_mail_detail.CATEGORY eq CORRCAT_ID)> selected</cfif>>#CORRCAT# 
        </cfoutput>
    </select>
    <cfoutput><a href="#request.self#?fuseaction=hr.popup_app_add_mail"><img src="/images/plus1.gif" border="0" align="absmiddle" title="<cf_get_lang_main no='170.Ekle'>"></a></cfoutput>
</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="57475.Mail Gönder"></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" add_href="javascript:openBoxDraggable('#request.self#?fuseaction=hr.popup_app_add_mail')">
        <cfform name="add_app_mail" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=hr.emptypopup_upd_empapp_mail">
            <input type="hidden" id="corrcat_id" name="corrcat_id"/>
            <input type="hidden" name="EMP_APP_MAIL_ID" id="EMP_APP_MAIL_ID" value="<cfoutput>#attributes.EMP_APP_MAIL_ID#</cfoutput>">
            <input type="Hidden" ID="clicked" value="">
            <input type="hidden" name="empapp_id" id="empapp_id" value="<cfif isdefined("attributes.empapp_id") and len(attributes.empapp_id)><cfoutput>#attributes.empapp_id#</cfoutput></cfif>">
            <cf_box_elements>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="1">
                    <div class="form-group" id="item-EMPLOYEE_EMAIL">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57428.mail'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="EMPLOYEE_EMAIL" id="EMPLOYEE_EMAIL" value="#get_mail_detail.EMPAPP_MAIL#">
						</div>
					</div>
                    <div class="form-group" id="item-header">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'></cfsavecontent>
							<cfinput type="text" name="header"  value="#get_mail_detail.MAIL_HEAD#" required="yes" message="#message#">
                            <textarea name="corrcat" id="corrcat" style=" display:none;"></textarea>
						</div>
					</div>
                    <div class="form-group" id="item-editor">
						<div id="fckedit">
							<cfmodule
							template="/fckeditor/fckeditor.cfm"
							toolbarSet="WRKContent"
							basePath="/fckeditor/"
							instanceName="content"
							valign="top"
							value="#get_mail_detail.MAIL_CONTENT#"
							width="575"
							height="385">
						</div>
					</div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_record_info query_name="get_mail_detail">
                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_empapp_mail&EMP_APP_MAIL_ID=#get_mail_detail.EMP_APP_MAIL_ID#'>    
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function cat_template(template_no){
	if(CKEDITOR.instances.content)
		{
			var oEditor = CKEDITOR.instances.content ;
			var get_temp_ = wrk_safe_query('corr_get_temp_3','dsn',0,template_no);
			var temp = String (get_temp_.DETAIL);
			oEditor.insertHtml(temp);
		}
	else
		alert("<cf_get_lang dictionary_id='41120.HTML Editör Sorunlu'>!") ;
		//add_app_mail.action = '#request.self#?fuseaction=hr.popup_app_upd_mail'; 
		//add_app_mail.submit();
		}
</script>
