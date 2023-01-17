<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" class="color-border"><table width="100%" height="100" border="0" cellpadding="2" cellspacing="1">
      <tr class="color-list">
        <td height="35"><cf_get_lang no ='714.Personel Ehliyet Bilgileri'></td>
      </tr>
      <tr>
        <td class="color-row"><table>
          <tr>
            <td><cf_get_lang_main no ='160.Departman'></td>
            <td width="175">
			 <select name="select" id="select" style="width:150"></select>
			</td>
            <td><cf_get_lang no ='715.Ehliyet Sınıfı'></td>
            <td>
			 <select name="select" id="select" style="width:150"></select>
			</td>
          </tr>
          <tr>
            <td><cf_get_lang_main no='1592.Pozisyon Tipi'></td>
            <td>
              <select name="select" id="select" style="width:150"></select>
              </td>
            <td><cf_get_lang no ='716.Ehliyet Tarihi'></td>
            <td>
			<cfinput type="text" name="assetp_name" style="width:150px;" readonly value="" maxlength="50" required="yes" message="#message1#">
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=add_kaza.assetp_id&field_name=add_kaza.assetp_name&list_select=2','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no ='716.Ehliyet Tarihi'>" border="0" align="absmiddle"></a>
			</td>
          </tr>
          <tr>
            <td><cf_get_lang_main no ='1085.Pozisyon'></td>
            <td> <select name="select" id="select" style="width:150"></select></td>
            <td><cf_get_lang no ='717.Verildiği Yer'></td>
            <td>
			<cfinput type="text" name="assetp_name" style="width:150px;" readonly value="" maxlength="50" required="yes" message="#message1#">
			</td>
          </tr>
          <tr>
            <td><cf_get_lang no ='311.Ehliyet No'></td>
            <td><cfinput type="text" name="assetp_name" style="width:150px;" readonly value="" maxlength="50" required="yes" message="#message1#"></td>
            <td><cf_get_lang_main no='1029.Kan Grubu'></td>
            <td>
			<cfinput type="text" name="assetp_name" style="width:150px;" readonly value="" maxlength="50" required="yes" message="#message1#">
			</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td><cf_workcube_buttons is_upd='0' is_cancel='0'add_function='kontrol()'></td>
          </tr>
        </table></td>
      </tr>
    </table></td>
  </tr>
</table>

