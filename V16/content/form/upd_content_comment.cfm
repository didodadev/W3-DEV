<cfquery name="GET_COMMENT" datasource="#DSN#">
	SELECT 
		NAME, 
		SURNAME, 
		MAIL_ADDRESS,
		CONTENT_COMMENT_POINT,
		CONTENT_COMMENT,
		STAGE_ID
	FROM 
		CONTENT_COMMENT 
	WHERE	
		CONTENT_COMMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.content_comment_id#">
</cfquery>
<cf_popup_box title="#getLang('content',124)#"><!---Yorum Düzenle'--->
<cfform name="employe_detail" method="post" action="#request.self#?fuseaction=content.emptypopup_upd_content_comment">
<input type="hidden" name="content_id" id="content_id" value="<cfoutput>#attributes.content_id#</cfoutput>">
<input type="hidden" name="content_comment_id" id="content_comment_id" value="<cfoutput>#attributes.content_comment_id#</cfoutput>">
    <table>
        <tr>
            <td style="width:75px;"><cf_get_lang_main no='219.Ad'>*</td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='219.Ad'></cfsavecontent>
                <cfinput type="text" name="name" id="name" style="width:150px;" maxlength="50" required="Yes" message="#message#" value="#get_comment.name#">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='1314.Soyad'>*</td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1314.Soyad  !'></cfsavecontent>
                <cfinput type="text" name="surname" id="surname" style="width:150px;" maxlength="50" required="Yes" message="#message#" value="#get_comment.surname#">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='16.Email'>*</td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='16.Email!'></cfsavecontent>
                <cfinput type="text" name="mail_address" id="mail_address" style="width:150px;" maxlength="100" required="yes" message="#message#" value="#get_comment.mail_address#">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='1572.Puan'></td>
            <td>
                <input name="content_comment_point" id="content_comment_point" type="radio" value="1" <cfif get_comment.content_comment_point eq 1>checked</cfif>>1
                <input name="content_comment_point" id="content_comment_point" type="radio" value="2" <cfif get_comment.content_comment_point eq 2>checked</cfif>>2
                <input name="content_comment_point" id="content_comment_point" type="radio" value="3" <cfif get_comment.content_comment_point eq 3>checked</cfif>>3
                <input name="content_comment_point" id="content_comment_point" type="radio" value="4" <cfif get_comment.content_comment_point eq 4>checked</cfif>>4
                <input name="content_comment_point" id="content_comment_point" type="radio" value="5" <cfif get_comment.content_comment_point eq 5>checked</cfif>>5 
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='70.Aşama'></td>
            <td><select name="stage_id" id="stage_id" style="width:156px;">
					<option value="-1" <cfif get_comment.stage_id eq -1>selected</cfif>><cf_get_lang no='77.Hazırlık'>
					<option value="-2" <cfif get_comment.stage_id eq -2>selected</cfif>><cf_get_lang_main no='1682.Yayın'>
					<option value="0" <cfif get_comment.stage_id eq 0>selected</cfif>><cf_get_lang_main no='1740.Red'>
				</select>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <cfmodule
                    template="/fckeditor/fckeditor.cfm"
                    toolbarset="WRKContent"
                    basepath="/fckeditor/"
                    instancename="CONTENT_COMMENT"
                    value="#get_comment.CONTENT_COMMENT#"
                    width="580"
                    height="325">
            </td>
        </tr>
    </table>
    <cf_popup_box_footer>
		<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=content.emptypopup_del_content_comment&id=#attributes.content_comment_id#&head=#get_comment.name##get_comment.surname#&cat=#get_comment.stage_id#'>
    </cf_popup_box_footer>
</cfform>
</cf_popup_box>

