<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border" align="center">
    <tr class="color-list" valign="middle">
        <td height="35">
            <table width="98%" align="center">
                <tr>
                    <td valign="bottom" class="headbold"><cf_get_lang no='1385.Sosyal Güvenlik Kurumu Ekle'></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr class="color-row" valign="top">
        <td>
            <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                <td colspan="2"><table border="0">
                    <cfform name="add_society" method="POST" enctype="multipart/form-data" action="#request.self#?fuseaction=settings.emptypopup_add_social_society">
                    <input name="is_detail" id="is_detail" type="hidden" value="1">
                        <tr>
                            <td><cf_get_lang no='1123.Kurum Adı'>*</td>
                            <td>
                                <cfsavecontent variable="message"><cf_get_lang no='1371.Kurum Adı Girmelisiniz'>!</cfsavecontent>
                                <cfinput type="text" style="width:180px;" name="society" maxlength="50" required="yes" message="#message#">
                            </td>
                        </tr>
                        <tr>
                            <td><cf_get_lang_main no='217.Açıklama'></td>
                            <td><textarea name="society_detail" id="society_detail" style="width:180px;height=60px;"></textarea></td>
                        </tr>
                        <tr height="35">
                        	<td colspan="2" align="right" style="text-align:right;"><cf_workcube_buttons is_upd='0'> </td>
                        </tr>
                    </cfform>
            </table>
        </td>
    </tr>
</table>
</td>
</tr>
</table>
