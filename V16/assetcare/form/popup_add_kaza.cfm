<cfquery name="get_accidents" datasource="#dsn#">
    SELECT ACCIDENT_ID, ACCIDENT_NAME FROM SETUP_ACCIDENT ORDER BY ACCIDENT_NAME</cfquery>
<cfinclude template="../query/get_assetp_cats.cfm">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
    <tr>
        <td height="35">
            <table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td class="headbold"><cf_get_lang no ='106.Kaza Kayıt'></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td valign="top">
            <table width="98%" height="100%" align="center" cellpadding="0" cellspacing="0" border="0">
                <cfform  method="post" name="add_kaza" action="#request.self#?fuseaction=assetcare.emptypopup_add_kaza">
                    <tr class="color-border">
                        <td>
                            <table width="100%" height="100%" align="center" cellpadding="2" cellspacing="1" border="0">
                                <tr class="color-row">
                                    <td valign="top" height="100">
                                        <table width="776" border="0">
                                            <tr>
                                                <td width="74"><cf_get_lang no='728.Varlık Adı Plaka'>&nbsp;<font color="red" >*</font></td>
                                                <td width="204">
                                                <cfsavecontent variable="message1"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1656.Plaka'>!</cfsavecontent>
                                                <cfinput type="text" name="assetp_name" style="width:175px;" value="" maxlength="50" required="yes" message="#message1#">
                                                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=add_kaza.assetp_id&field_name=add_kaza.assetp_name&list_select=2','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1656.Plaka'>" border="0" align="absmiddle"></a></td>
                                                <td width="67"><cf_get_lang no ='395.Kaza Tarihi'></td><input type="hidden" name="assetp_id" id="assetp_id" value="">
                                                <td width="171"><cfinput type="text" name="accident_date" maxlength="10" validate="#validate_style#"style="width:110px">
                                                <cf_wrk_date_image date_field="accident_date"></td>
                                                <td width="68"><cf_get_lang_main no ='217.Açıklama'></td>
                                                <td width="166" rowspan="4"><textarea name="description" id="description" style="width:150px;height:90px;"></textarea></td>
                                            </tr>
                                            <tr>
                                                <td><cf_get_lang_main no='132.Sorumlu'>&nbsp;<font color="red">*</font></td>
                                                <td><input type="hidden" name="position_code" id="position_code" value="">
                                                <cfsavecontent variable="message2"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='132.Sorumlu'>!</cfsavecontent>
                                                <cfinput type="Text" name="position" value="" readonly style="width:175px;" required="yes" message="#message2#">
                                                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_kaza.position_code&field_name=add_kaza.position&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='132.Sorumlu'>!" align="absmiddle" border="0"></a></td>
                                                <td><cf_get_lang no ='403.Evrak No'></td>
                                                <td><input name="document_num" type="text" id="document_num" style="width:110px;" ></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td><cf_get_lang no ='397.Kaza Tipi'></td>
                                                <td>
                                                <select name="accident_id" id="accident_id" style="width:175px;">
                                                    <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                                                    <cfoutput query="get_accidents">
                                                    	<option value="#accident_id#">#accident_name#</option>
                                                    </cfoutput>
                                                </select>
                                                </td>
                                                <td><cf_get_lang no ='398.Kusur Oranı'></td>
                                                <td><input name="fault_ratio" type="text" id="fault_ratio" style="width:110px;" ></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td><cf_get_lang no ='727.Sigorta Durumu'></td>
                                                <td><input name="insurance_status" type="text" id="insurace_status" style="width:175px;" ></td>
                                                <td><cf_get_lang no ='404.Cezai Madde'></td>
                                                <td><input name="penalty_item" type="text" id="penalty_item" style="width:110px;" ></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr class="color-row">
                                	<td>&nbsp;</td>
                                </tr>
                    		</table>
                    	</td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>
<script type="text/javascript">
	function kontrol()
	{
		x = document.add_kaza.accident_id.selectedIndex;
		if (document.add_kaza.accident_id[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='397.Kaza Tipi'>!");
			return false;
		}
		return true;
	}
</script>
