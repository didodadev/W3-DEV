<cfquery name="GET_COMMENT" datasource="#DSN#">
	SELECT 
		TRAINING_ID, 
		TRAINING_COMMENT_ID, 
		TRAINING_COMMENT, 
		TRAINING_COMMENT_POINT, 
		RECORD_DATE, 
		RECORD_IP, 
		STAGE_ID, 
		GUEST, 
		NAME, 
		SURNAME, 
		MAIL_ADDRESS 
	FROM 
		TRAINING_COMMENT 
	WHERE 
		TRAINING_COMMENT_ID = #attributes.TRAINING_COMMENT_ID#
</cfquery>
<table align="center" width="100%" cellpadding="0" cellspacing="0" border="0" height="100%">
    <cfform name="employe_detail" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_training_comment">
    <input type="hidden" name="training_id" id="training_id" value="<cfoutput>#attributes.training_id#</cfoutput>">
    <input type="hidden" name="TRAINING_COMMENT_ID" id="TRAINING_COMMENT_ID" value="<cfoutput>#attributes.TRAINING_COMMENT_ID#</cfoutput>">    
        <tr class="color-border">
            <td>
                <table align="center" width="100%" cellpadding="2" cellspacing="1" border="0" height="100%">
                    <tr class="color-list">
                        <td height="35" class="headbold">&nbsp;<cf_get_lang no='409.Yorum Düzenle'></td>
                    </tr>
                    <tr class="color-row">
                        <td valign="top">
                            <table>
                                <tr>
                                <td width="75"><cf_get_lang_main no='219.Ad'>*</td>
                                <td>
                                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='219.Ad !'></cfsavecontent>
                                    <cfinput type="text" name="name" style="width:150px;" maxlength="50" required="Yes" message="#message#" value="#get_comment.name#">
                                </td>
                                </tr>
                                <tr>
                                    <td height="26"><cf_get_lang_main no='1314.Soyad'>*</td>
                                    <td>
                                        <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1314.Soyad !'></cfsavecontent>
                                        <cfinput type="text" name="surname" style="width:150px;" maxlength="50" required="Yes" message="#message#" value="#get_comment.surname#">
                                    </td>
                                </tr>
                                <tr>
                                    <td><cf_get_lang_main no='16.Email'>*</td>
                                    <td>
                                        <input type="text" name="MAIL_ADDRESS" id="MAIL_ADDRESS" style="width:150px;" maxlength="100" value="<cfoutput>#get_comment.mail_address#</cfoutput>">
                                    </td>
                                </tr>
                                <tr>
                                    <td><cf_get_lang no='87.Puan'></td>
                                    <td>
                                        <input name="TRAINING_COMMENT_POINT" id="TRAINING_COMMENT_POINT" type="radio" value="1" <cfif get_comment.TRAINING_COMMENT_POINT eq 1>checked</cfif>>1
                                        <input name="TRAINING_COMMENT_POINT" id="TRAINING_COMMENT_POINT" type="radio" value="2" <cfif get_comment.TRAINING_COMMENT_POINT eq 2>checked</cfif>>2
                                        <input name="TRAINING_COMMENT_POINT" id="TRAINING_COMMENT_POINT" type="radio" value="3" <cfif get_comment.TRAINING_COMMENT_POINT eq 3>checked</cfif>>3
                                        <input name="TRAINING_COMMENT_POINT" id="TRAINING_COMMENT_POINT" type="radio" value="4" <cfif get_comment.TRAINING_COMMENT_POINT eq 4>checked</cfif>>4
                                        <input name="TRAINING_COMMENT_POINT" id="TRAINING_COMMENT_POINT" type="radio" value="5" <cfif get_comment.TRAINING_COMMENT_POINT eq 5>checked</cfif>>5 
                                    </td>
                                </tr>
                                <tr>
                                    <td><cf_get_lang_main no='70.Aşama'></td>
                                    <td>
                                        <select name="STAGE_ID" id="STAGE_ID" style="width:150px;">
                                            <option value="-1" <cfif get_comment.STAGE_ID eq -1>selected</cfif>><cf_get_lang no='412.Hazırlık'>
                                            <option value="-2" <cfif get_comment.STAGE_ID eq -2>selected</cfif>><cf_get_lang_main no='1682.Yayın'>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                            <table>
                                <tr>
                                    <td>
										<!--- <cfset tr_topic = htmleditformat(get_comment.TRAINING_COMMENT)>--->
                                        <cfmodule
                                        template="/fckeditor/fckeditor.cfm"
                                        toolbarSet="WRKContent"
                                        basePath="/fckeditor/"
                                        instanceName="TRAINING_COMMENT"
                                        valign="top"
                                        value="#get_comment.TRAINING_COMMENT#"
                                        width="545"
                                        height="325">
                                    </tr>
                                    <tr>
                                        <td align="right"> <cf_workcube_buttons 
                                        is_upd='1' 
                                        delete_page_url='#request.self#?fuseaction=training_management.emptypopup_del_training_comment&training_comment_id=#attributes.training_comment_id#'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    </td>
                            </tr>
                        </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </cfform>
</table>
