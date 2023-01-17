<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
    <tr>
        <td height="35">
            <table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td class="headbold"><cf_get_lang no ='718.KM Giriş'></td>
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
                                            <img src="/images/plus_thin.gif" alt="<cf_get_lang_main no ='243.Başlama Tarihi'>" align="absmiddle" border="0"></a></td>
                                            <td width="90"><cf_get_lang_main no ='243.Başlama Tarihi'></td>
                                            <td width="130"><input type="text" name="textfield" id="textfield" style="width:110px;" ></td>
                                            <td width="60"><cf_get_lang_main no ='57.Son Kayıt'></td>
                                            <td><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_assetp.position_code&field_name=add_assetp.position</cfoutput>','list')"></a>
                                            <input type="text" name="textfield223" id="textfield223" style="width:130px;" ></td>
                                        </tr>
                                        <tr>
                                            <td><cf_get_lang_main no='132.Sorumlu'></td>
                                            <td><input type="hidden" name="position_code" id="position_code" value="">
                                            <input type="Text" name="position" id="position" value="" readonly style="width:175px;">
                                            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_assetp.position_code&field_name=add_assetp.position</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='132.Sorumlu'>" align="absmiddle" border="0"></a></td>
                                            <td><cf_get_lang_main no ='288.Bitiş Tarihi'></td>
                                            <td><input type="text" name="textfield2" id="textfield2" style="width:110px;" ></td>
                                            <td><cf_get_lang no ='719.Son Kullanan'></td>
                                            <td><input type="text" name="textfield22322" id="textfield22322" style="width:130px;" ></td>
                                        </tr>
                                        <tr>
                                            <td><cf_get_lang no ='30.Kullanım Amacı'></td>
                                            <td>
                                            	<select name="department_id" id="department_id"  style="width:175px;">
                                                	<option value=""><cf_get_lang no='71.Department Seçiniz'></option>
                                                </select>
                                            </td>
                                            <td><cf_get_lang no ='219.Son KM'></td>
                                            <td><input type="text" name="textfield22" id="textfield22" style="width:110px;" ></td>
                                            <td><cf_get_lang no ='357.Önceki KM'></td>
                                            <td><input type="text" name="textfield2232" id="textfield2232" style="width:130px;" ></td>
                                        </tr>
                                       	<tr>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td></td>
                                            <td></td>
                                            <td>&nbsp;</td>
                                            <td><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
                                        </tr>
                                        </cfform>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
