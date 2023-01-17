<cf_popup_box title="#getLang('training',75)#">
<cfform name="employe_detail" method="post" action="#request.self#?fuseaction=training.emptypopup_add_training_comment">
<input type="hidden" name="training_id" id="training_id" value="<cfoutput>#attributes.training_id#</cfoutput>">
    <table>
        <tr>
            <td width="90"><cf_get_lang_main no='219.Adınız'>*</td>
            <td width="200">
                <input type="text" name="name" id="name" style="width:155px;" maxlength="50" readonly value="<cfoutput>#session.ep.name#</cfoutput>">
            </td>
            <td><cf_get_lang_main no='1314.Soyadınız'>*</td>
            <td>
                <input type="text" name="surname" id="surname" style="width:155px;" maxlength="50" readonly value="<cfoutput>#session.ep.surname#</cfoutput>">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='16.email'></td>
            <td><input type="text" name="MAIL_ADDRESS" id="MAIL_ADDRESS"  style="width:155px;" maxlength="100" message="Email Girmelisiniz!">
            </td>
            <td><cf_get_lang_main no='1572.Puan'></td>
            <td>
                <input name="TRAINING_COMMENT_POINT" id="TRAINING_COMMENT_POINT" type="radio" value="1">
                1
                <input name="TRAINING_COMMENT_POINT" id="TRAINING_COMMENT_POINT" type="radio" value="2">
                2
                <input name="TRAINING_COMMENT_POINT" id="TRAINING_COMMENT_POINT" type="radio" value="3">
                3
                <input name="TRAINING_COMMENT_POINT" id="TRAINING_COMMENT_POINT" type="radio" value="4">
                4
                <input name="TRAINING_COMMENT_POINT" id="TRAINING_COMMENT_POINT" type="radio" value="5" checked>
                5 
           </td>
        </tr>
    </table>
              <table>
                <tr>
                  <td colspan="2"> 
					<cfmodule
						template="/fckeditor/fckeditor.cfm"
						toolbarSet="WRKContent"
						basePath="/fckeditor/"
						instanceName="TRAINING_COMMENT"
						value=""
						width="500"
						height="250">
				  </td>
                </tr>
              </table>
              <cf_popup_box_footer><cf_workcube_buttons type_format='1' is_upd='0'></cf_popup_box_footer>
</cfform>
</cf_popup_box>

