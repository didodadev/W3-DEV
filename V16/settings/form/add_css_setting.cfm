<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
    <tr>
        <td class="headbold"><cf_get_lang no='2431.Css Ayarları'></td>
        </td>
    </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
    <cfform action="#request.self#?fuseaction=settings.emptypopup_add_css_setting" method="post" name="user_group"> 
        <tr class="color-row" valign="top">
            <td>
                <table>
                    <tr>
                        <td><cf_get_lang_main no='81.Aktif'></td>
                        <td width="130"><input name="is_active" id="is_active" type="checkbox" value="1" checked></td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td><cf_get_lang no='2432.Css Adı'> </td>
                        <td colspan="3">
                        <cfsavecontent variable="message"><cf_get_lang no='1330.Css Adı Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="css_name" value="" style="width:150px;" required="yes" message="#message#" maxlength="100"></td>
                    </tr>
                    <tr>
                        <td height="35" colspan="4" align="right" style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
                    </tr>
                </table>			
            </td>
        </tr>
    </cfform>
</table>			    

