<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
    <tr>
        <td height="35">
            <table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td class="headbold"><cf_get_lang no ='150.Ceza Kayıt'></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td valign="top">
            <table width="98%" height="100%" align="center" cellpadding="0" cellspacing="0" border="0">
                <tr class="color-border">
                    <td>
                        <table width="100%" height="100%" align="center" cellpadding="2" cellspacing="1" border="0">
                            <tr class="color-row">
                                <td valign="top" height="100">
                                    <table border="0">
                                        <cfform>
                                        <tr>
                                            <td width="100"><cf_get_lang_main no='1656.Plaka'></td>
                                            <td width="210"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_assetp.position_code&field_name=add_assetp.position</cfoutput>','list')">
                                            <input type="text" name="textfield32" id="textfield32" style="width:175px;" >
                                            <img src="/images/plus_list.gif" align="absmiddle" alt="<cf_get_lang_main no='1656.Plaka'>" border="0"></a></td>
                                            <td width="90"><cf_get_lang no ='415.Makbuz No'></td>
                                            <td width="130"><input type="text" name="textfield" id="textfield" style="width:110px;" ></td>
                                            <td width="60"><cf_get_lang no ='185.Son Ödeme Tarihi'></td>
                                            <td><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_assetp.position_code&field_name=add_assetp.position</cfoutput>','list')"></a>
                                            <input type="text" name="textfield223" id="textfield223" style="width:110px;" ></td>
                                        </tr>
                                        <tr>
                                            <td><cf_get_lang_main no='132.Sorumlu'></td>
                                            <td><input type="hidden" name="position_code" id="position_code" value="">
                                            <input type="Text" name="position" id="position"  value="" readonly style="width:175px;">
                                            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_assetp.position_code&field_name=add_assetp.position</cfoutput>','list')"><img src="/images/plus_list.gif" alt="Sorumlu" align="absmiddle" border="0"></a></td>
                                            <td><cf_get_lang no ='414.Ceza Tipi'></td>
                                            <td><input type="text" name="textfield2" style="width:110px;" ></td>
                                            <td><cf_get_lang no ='448.Ödeme Makbuz No'></td>
                                            <td><input type="text" name="textfield22322" style="width:110px;" ></td>
                                        </tr>
                                        <tr>
                                            <td><cf_get_lang_main no ='160.Departman'></td>
                                            <td>
                                                <select name="department_id"  style="width:175px;">
                                                	<option value=""><cf_get_lang no='71.Department Seçiniz'></option>
                                                </select>
                                            </td>
                                            <td><cf_get_lang no ='416.Ceza Tarihi'></td>
                                            <td><input type="text" name="textfield22" style="width:110px;" ></td>
                                            <td><cf_get_lang no ='423.Ödenen Tarih'></td>
                                            <td><input type="text" name="textfield2232" style="width:110px;" ></td>
                                        </tr>
                                        <tr>
                                            <td><cf_get_lang_main no='1139.Gider Kalemi'></td>
                                            <td>
                                                <select name="select3"  style="width:175px;">
                                                	<option value=""><cf_get_lang no='71.Department Seçiniz'></option>
                                                </select>
                                            </td>
                                            <td><cf_get_lang no ='417.Ceza Tutarı'></td>
                                            <td>
                                                <input type="text" name="textfield222" style="width:110px;" >
                                                <select name="select2"  style="width:45px;">
                                                	<option value=""><cf_get_lang_main no ='77.Para Br'></option>
                                                </select>
                                            </td>
                                            <td><cf_get_lang no ='449.Ödenen Miktar'></td>
                                            <td>
                                                <input type="text" name="textfield2222" style="width:110px;" >
                                                <select name="select"  style="width:45px;">
                                                    <option value=""><cf_get_lang_main no ='77.Para Br'></option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td></td>
                                            <td></td>
                                            <td>&nbsp;</td>
                                            <td><cf_workcube_buttons is_upd='0' is_cancel='0' add_function='kontrol()'></td>
                                        </tr>
                                        </cfform>
                                    </table>
                                </td>
                            </tr>
                            <tr class="color-row">
                                <td><IFRAME frameborder="0" scrolling="auto" src="<cfoutput>#request.self#?fuseaction=assetcare.popup_list_ceza&style=one</cfoutput>&iframe=1" width="100%" height="100%"></IFRAME></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
