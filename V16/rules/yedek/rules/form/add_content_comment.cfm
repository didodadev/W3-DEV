<cfquery name="get_employee_email" datasource="#dsn#">
	SELECT EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cf_popup_box title="#getLang('rule',28)#"><!---.Yorum Ekle'--->
<cfform name="employe_detail" method="post" action="#request.self#?fuseaction=rule.emptypopup_add_content_comment">
<input type="hidden" name="content_id" id="content_id" value="<cfoutput>#attributes.content_id#</cfoutput>">
    <table>
        <tr>
            <td width="90"><cf_get_lang_main no='219.Adınız'>*</td>
            <td width="210"><input type="text" name="name" id="name" style="width:155px;" maxlength="50" readonly value="<cfoutput>#session.ep.name#</cfoutput>"></td>
            <td nowrap="nowrap"><cf_get_lang_main no='16.email'>*</td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='16.E-mail !'></cfsavecontent>
                <cfinput type="text" name="MAIL_ADDRESS" style="width:178px;" maxlength="100" value="#get_employee_email.employee_email#" required="yes" message="#MESSAGE#">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='1314.Soyadınız'>*</td>
            <td><input type="text" name="surname" id="surname" style="width:155px;" maxlength="50" readonly value="<cfoutput>#session.ep.surname#</cfoutput>"></td>
            <td><cf_get_lang_main no='1572.Puan'></td>
            <td>
                <input name="CONTENT_COMMENT_POINT" id="CONTENT_COMMENT_POINT" type="radio" value="1"> 1
                <input name="CONTENT_COMMENT_POINT" id="CONTENT_COMMENT_POINT" type="radio" value="2"> 2
                <input name="CONTENT_COMMENT_POINT" id="CONTENT_COMMENT_POINT" type="radio" value="3"> 3
                <input name="CONTENT_COMMENT_POINT" id="CONTENT_COMMENT_POINT" type="radio" value="4"> 4
                <input name="CONTENT_COMMENT_POINT" id="CONTENT_COMMENT_POINT" type="radio" value="5" checked> 5
            </td>
        </tr>
        <tr>
            <td colspan="4"> 
                <cfmodule
                    template="/fckeditor/fckeditor.cfm"
                    toolbarset="WRKContent"
                    basepath="/fckeditor/"
                    instancename="CONTENT_COMMENT"
                    valign="top"
                    value=""
                    width="660"
                    height="270">	
            </td>
        </tr>
    </table>
    <cf_popup_box_footer>
		<cf_workcube_buttons is_upd='0'>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </cf_popup_box_footer>
</cfform>
</cf_popup_box>

