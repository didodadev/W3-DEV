<cfquery name="GET_TRAINING_COMMENT" datasource="#DSN#">
    SELECT 
    	TRAINING_ID, 
        TRAINING_COMMENT_ID, 
        TRAINING_COMMENT, 
        TRAINING_COMMENT_POINT, 
        EMPLOYEE_ID, 
        PARTNER_ID, 
        RECORD_DATE, 
        STAGE_ID, 
        NAME, 
        SURNAME, 
        MAIL_ADDRESS 
    FROM 
    	TRAINING_COMMENT 
    WHERE 
    	TRAINING_ID = #attributes.TRAINING_ID#
</cfquery>
<cfinclude template="../query/get_training_name.cfm">
<cf_popup_box title="#getLang('training_management',147)# : #get_training_name.train_head#">
    <table>
        <cfif GET_TRAINING_COMMENT.RECORDCOUNT>
            <cfoutput query="GET_TRAINING_COMMENT">
                <tr>
                    <td width="20"> <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_upd_training_comment&training_id=#attributes.training_id#&training_comment_id=#training_comment_id#','large');"> <img src="/images/update_list.gif" title="Yorum Düzenle" border="0"></a></td>
                    <td width="75" class="txtbold"><cf_get_lang_main no='158.Ad Soyad'></td>
                    <td>#name# #surname#</td>
                </tr>
                <tr>
                    <td></td>
                    <td class="txtbold"><cf_get_lang_main no='16.Email'></td>
                    <td><a href="mailto:#mail_address#" class="tableyazi">#mail_address#</a></td>
                </tr>
                <tr>
                    <td></td>
                    <td class="txtbold"><cf_get_lang_main no='1572.Puan'></td>
                    <td>#training_comment_point#</td>
                </tr>
                <tr>
                    <td></td>
                    <td class="txtbold" valign="top"><cf_get_lang_main no='773.Yorum'></td>
                    <td>#training_comment#</td>
                </tr>
                <tr>
                    <td></td>
                    <td colspan="2"><hr>
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td class="labelwhite"><cf_get_lang no='420.Yorum Eklenmemiş'></td>
            </tr>
        </cfif>
    </table>
</cf_popup_box>
