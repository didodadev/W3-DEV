<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
    <tr>
        <td class="headbold"><cf_get_lang no='1421.Site Tasarımcısı'></td>
        </td>
    </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center">
    <cfform action="#request.self#?fuseaction=settings.emptypopup_add_site_layout" method="post" name="user_group"> 
        <tr>
            <td class="color-border">
                <table border="0" cellspacing="1" cellpadding="2" width="100%">
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
                                    <td><cf_get_lang no='1457.Tasarım Adı'> </td>
                                    <td colspan="3"><cfinput type="text" name="layout_name" value="" style="width:150px;" required="yes" message="Tasarım Adı Girmelisiniz!" maxlength="100"></td>
                                </tr>
                                <tr>
                                    <td height="35" colspan="4" align="right" style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
                                </tr>
                            </table>			
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </cfform>
</table>		    
