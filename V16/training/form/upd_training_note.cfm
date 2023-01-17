<cf_get_lang_set module_name="training">
<cfquery name="GET_NOTE" datasource="#DSN#">
	SELECT 
    	NOTE_ID, 
        EMPLOYEE_ID, 
        PARTNER_ID, 
        NOTE_HEAD, 
        NOTE_DETAIL, 
        RECORD_DATE, 
        RECORD_IP, 
        TRAINING_ID,
        CLASS_ID, 
        UPDATE_DATE, 
        UPDATE_IP 
    FROM 
    	TRAINING_NOTES 
    WHERE 
    	NOTE_ID = #attributes.NOTE_ID#
</cfquery>
<cfsavecontent variable="image">
	<cfoutput><a href="#request.self#?fuseaction=training.popup_form_add_training_note"><img src="/images/plus1.gif"  align="absbottom"  alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></a></cfoutput>
</cfsavecontent>
<cf_popup_box title="#getLang('training',30)#" right_images="#image#">
    <cfform name="employe_detail" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_training_note">
    <input type="hidden" name="note_id" id="note_id" value="<cfoutput>#attributes.note_id#</cfoutput>">
        <table>
            <tr>
                <td><cf_get_lang_main no='68.Başlık'>*</td>
                <td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1408.başlık'></cfsavecontent>
                    <cfinput type="text" name="note_head" style="width:510px;" maxlength="100" value="#GET_NOTE.NOTE_HEAD#" required="yes" message="#message#"></td>
                </tr>
            </tr>
            <tr>
                <td></td>
                <td>
                    <cfmodule
                    template="/fckeditor/fckeditor.cfm"
                    toolbarSet="WRKContent"
                    basePath="/fckeditor/"
                    instanceName="NOTE_DETAIL"
                    valign="top"
                    value="#GET_NOTE.NOTE_DETAIL#"
                    width="500"
                    height="250">
                </td>
            </tr>
        </table>
        <cf_popup_box_footer>
            <cf_workcube_buttons is_upd='0'>
        </cf_popup_box_footer>
    </cfform>
</cf_popup_box>
