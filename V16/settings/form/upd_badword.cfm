<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='600.Yasak Kelime Güncelle'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_badword"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang no='318.Yasak Kelime Ekle'>"></a></td>
  </tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
    <tr class="color-row" valign="top">
        <td width="200"><cfinclude template="../display/list_badword.cfm">
        </td><td>
            <table>
                <cfform action="#request.self#?fuseaction=settings.emptypopup_badword_upd" method="post" name="upd_badword">
                    <cfquery name="CATEGORY" datasource="#dsn#">
                        SELECT 
                            * 
                        FROM 
                            SETUP_FORUM_FILTER 
                        WHERE 
                            WORD_ID=#URL.WORD_ID#
                    </cfquery>
                    <input type="Hidden" name="word_ID" id="word_ID" value="<cfoutput>#URL.word_ID#</cfoutput>">
                    <tr>
                        <td width="100"><cf_get_lang no='319.Kelime'>*</td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang no='724.Kelime girmelisiniz'>!</cfsavecontent>
                            <cfinput type="Text" name="word" size="40" value="#category.word#" maxlength="75" required="Yes" message="#message#" style="width:150px;">
                        </td>
                    </tr>
                    <tr height="35">
                        <td>&nbsp;</td>
                        <td>
                        	<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_badword_del&word_id=#URL.WORD_ID#'>
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>
