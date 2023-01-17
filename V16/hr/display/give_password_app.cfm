<cf_popup_box title="#getLang('hr',618)#">
<cfform name="start_work" action="#request.self#?fuseaction=hr.emptypopup_start_employee" method="post">
  <input type="hidden" name="empapp_id" id="empapp_id" value="<cfoutput>#attributes.empapp_id#</cfoutput>">
    &nbsp;<cf_get_lang dictionary_id='55704.Başvuru Yapanı İşe Alabilmek İçin Kullanıcı Adı ve Şifre Belirlemelisiniz.'>
    <table>
        <tr>
            <td width="75"><cf_get_lang dictionary_id='57551.Kullanıcı Adı'></td>
            <td>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='34327.Kullanıcı Adı girmelisiniz'></cfsavecontent>
            <cfinput type="text" name="EMPLOYEE_USERNAME" style="width:150px;" value="" message="#message#" required="yes">
            </td>
        </tr>
        <tr>
        <td><cf_get_lang dictionary_id='57552.Şifre'></td>
            <td>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='52873.Şifre girmelisiniz'></cfsavecontent>
            <cfinput type="text" name="employee_password" style="width:150px;" message="#message#" required="yes">
            </td>
        </tr>
    </table>
<cf_popup_box_footer><cf_workcube_buttons is_upd='0'></cf_popup_box_footer>
</cfform>
</cf_popup_box>
