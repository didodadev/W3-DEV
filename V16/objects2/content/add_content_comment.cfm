<cfform name="employe_detail" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_content_comment">
  	<input type="hidden" name="content_id" id="content_id" value="<cfoutput>#attributes.cid#</cfoutput>">
  	<table align="center" cellpadding="2" cellspacing="1" border="0" class="color-border" style="width:100%; height:100%;">
	  	<tr class="color-list" style="height:35px;">
			<td class="headbold">&nbsp;<cf_get_lang no='359.Yorum Ekle'></td>
	  	</tr>
        <tr class="color-row">
        	<td style="vertical-align:top;">
        		<table>
        			<tr>
        				<td style="width:90px;"><cf_get_lang_main no='219.Adınız'>*</td>
                        <td>
							<cfif isdefined("session.ww.name")>
                                <input type="text" name="name" id="name" value="<cfoutput>#session.ww.name#</cfoutput>" style="width:150px;" maxlength="50" readonly>
                            <cfelseif isdefined("session.pp.name")>
                                <input type="text" name="name" id="name" value="<cfoutput>#session.pp.name#</cfoutput>" style="width:150px;" maxlength="50" readonly>
                            <cfelse>
                                <cfsavecontent variable="alert"><cf_get_lang no ='219.İsim Giriniz'></cfsavecontent>
                                <cfinput type="text" name="name" id="name" style="width:150px;" maxlength="50" required="Yes" message="#alert#">
                            </cfif>
                        </td>
        			</tr>
                    <tr>
                        <td><cf_get_lang_main no='1314.Soyadınız'>*</td>
                        <td>
							<cfif isdefined("session.ww.surname")>
                            	<input type="text" name="surname" id="surname" style="width:150px;" maxlength="50" readonly value="<cfoutput>#session.ww.surname#</cfoutput>">
                            <cfelseif isdefined("session.pp.name")>
                            	<input type="text" name="surname" id="surname" style="width:150px;" maxlength="50" readonly value="<cfoutput>#session.pp.surname#</cfoutput>">
                            <cfelse>
                                <cfsavecontent variable="alert"><cf_get_lang no ='237.Soyad Giriniz'></cfsavecontent>
                                <cfinput type="text" name="surname" id="surname" style="width:150px;" maxlength="50" required="Yes" message="#alert#">
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                        <td><cf_get_lang_main no='16.e-mail'>*</td>
                        <cfsavecontent variable="alert"><cf_get_lang no ='29.Email Girmelisiniz'></cfsavecontent>
                        <td><cfinput type="text" name="mail_address" id="mail_address" style="width:150px;" maxlength="100" required="yes" message="#alert#"></td>
                	</tr>
                    <tr>
                        <td><cf_get_lang_main no='1572.Puan'></td>
                        <td>
                            <input type="radio" name="content_comment_point" id="content_comment_point" value="1">1
                            <input type="radio" name="content_comment_point" id="content_comment_point" value="2">2
                            <input type="radio" name="content_comment_point" id="content_comment_point" value="3">3
                            <input type="radio" name="content_comment_point" id="content_comment_point" value="4">4
                            <input type="radio" name="content_comment_point" id="content_comment_point" value="5" checked>5
                        </td>
                    </tr>
                </table>
                <table>
                    <tr>
                        <td colspan="2">
                            <cfmodule template="/fckeditor/fckeditor.cfm"
                                toolbarset="Basic"
                                basepath="/fckeditor/"
                                instancename="content_comment"
                                valign="top"
                                value=""
                                width="500"
                                height="300">
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2"><cf_wrk_captcha name="captcha" action="display"></td>
                    </tr>
                    <tr style="height:35px;">
                        <td style="text-align:right;" colspan="2">
                        	<cf_workcube_buttons is_upd='0' add_function='OnFormSubmit()'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</cfform>
