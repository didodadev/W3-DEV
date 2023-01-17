<cfquery name="GET_COMMENT" datasource="#DSN3#">
	SELECT * FROM PRODUCT_COMMENT WHERE	PRODUCT_COMMENT_ID = #attributes.PRODUCT_COMMENT_ID#
</cfquery>

<cfform name="employe_detail" method="post" action="#request.self#?fuseaction=product.emptypopup_upd_product_comment">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37130.Yorum Düzenle'></cfsavecontent>
<cf_popup_box title="#message#">
	<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
	<input type="hidden" name="PRODUCT_COMMENT_ID" id="PRODUCT_COMMENT_ID" value="<cfoutput>#attributes.PRODUCT_COMMENT_ID#</cfoutput>">
    <table>
        <tr>
            <td width="75"><cf_get_lang dictionary_id='57631.Ad'>*</td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58939.Ad girmelisiniz'></cfsavecontent>
                <cfinput type="text" name="name" style="width:150px;" maxlength="50" required="Yes" message="#message#" value="#get_comment.name#">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='58726.Soyad'>*</td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='29503.Soyad girmelisiniz'></cfsavecontent>
                <cfinput type="text" name="surname" style="width:150px;" maxlength="50" required="Yes" message="#message#" value="#get_comment.surname#">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='57428.e-mail'>*</td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='35907.e-mail girmelisiniz'></cfsavecontent>
                <cfinput type="text" name="MAIL_ADDRESS" style="width:150px;" maxlength="100" required="yes" message="#message#" value="#get_comment.mail_address#">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='58984.Puan'></td>
            <td><input name="PRODUCT_COMMENT_POINT" id="PRODUCT_COMMENT_POINT" type="radio" value="1" <cfif get_comment.PRODUCT_COMMENT_POINT eq 1>checked</cfif>>
                1
                <input name="PRODUCT_COMMENT_POINT" id="PRODUCT_COMMENT_POINT" type="radio" value="2" <cfif get_comment.PRODUCT_COMMENT_POINT eq 2>checked</cfif>>
                2
                <input name="PRODUCT_COMMENT_POINT" id="PRODUCT_COMMENT_POINT" type="radio" value="3" <cfif get_comment.PRODUCT_COMMENT_POINT eq 3>checked</cfif>>
                3
                <input name="PRODUCT_COMMENT_POINT" id="PRODUCT_COMMENT_POINT" type="radio" value="4" <cfif get_comment.PRODUCT_COMMENT_POINT eq 4>checked</cfif>>
                4
                <input name="PRODUCT_COMMENT_POINT" id="PRODUCT_COMMENT_POINT" type="radio" value="5" <cfif get_comment.PRODUCT_COMMENT_POINT eq 5>checked</cfif>>
                5
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='57482.Aşama'></td>
            <td><select name="STAGE_ID" id="STAGE_ID" style="width:150px;">
					<option value="-1" <cfif get_comment.stage_id eq -1>selected</cfif>><cf_get_lang dictionary_id='37255.Hazırlık'>
					<option value="-2" <cfif get_comment.stage_id eq -2>selected</cfif>><cf_get_lang dictionary_id='29479.Yayın'>
					<option value="0" <cfif get_comment.stage_id eq 0>selected</cfif>><cf_get_lang dictionary_id='29537.Red'>
                </select>
            </td>
        </tr>
    </table>
    <table>
        <tr>
            <td align="right" height="35">
                <cfmodule
                    template="/fckeditor/fckeditor.cfm"
                    toolbarSet="WRKContent"
                    basePath="/fckeditor/"
                    instanceName="PRODUCT_COMMENT"
                    valign="top"
                    value="#get_comment.PRODUCT_COMMENT#"
                    width="545"
                    height="325">
            </td>
        </tr>
    </table>
<cf_popup_box_footer>
	<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=product.emptypopup_del_product_comment&product_comment_id=#attributes.product_comment_id#'>
</cf_popup_box_footer>
</cf_popup_box>
</cfform>

