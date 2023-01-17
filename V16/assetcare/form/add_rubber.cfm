<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" class="color-border"><table width="100%" height="100" border="0" cellpadding="2" cellspacing="1">
      <tr class="color-list">
        <td height="35"><cf_get_lang no ='725.Lastik Fiyat Ekleme'></td>
      </tr>
      <tr>
        <td class="color-row"><table>
          <tr>
            <td><cf_get_lang_main no ='1195.Firma'></td>
            <td width="175">
			 <cfinput type="text" name="assetp_name" style="width:150px;" readonly value="" maxlength="50" required="yes" message="#message1#">
			</td>
            <td><cf_get_lang_main no='672.Fiyat'></td>
            <td>
			 <cfinput type="text" name="assetp_name" style="width:150px;" readonly value="" maxlength="50" required="yes" message="#message1#">
			</td>
          </tr>
          <tr>
            <td><cf_get_lang_main no='1435.Marka'></td>
            <td>
              <cfinput type="text" name="assetp_name" style="width:150px;" readonly value="" maxlength="50" required="yes" message="#message1#">
              </td>
            <td><cf_get_lang_main no ='223.Miktar'> 1</td>
            <td>
			<cfinput type="text" name="assetp_name" style="width:150px;" readonly value="" maxlength="50" required="yes" message="#message1#">
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=add_kaza.assetp_id&field_name=add_kaza.assetp_name&list_select=2','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no ='223.Miktar'>" border="0" align="absmiddle"></a>
			</td>
          </tr>
          <tr>
            <td><cf_get_lang no ='512.Ebat'></td>
            <td> <cfinput type="text" name="assetp_name" style="width:150px;" readonly value="" maxlength="50" required="yes" message="#message1#"></td>
            <td><cf_get_lang_main no ='223.Miktar'> 2</td>
            <td>
			<cfinput type="text" name="assetp_name" style="width:150px;" readonly value="" maxlength="50" required="yes" message="#message1#">
			</td>
          </tr>
          <tr>
            <td><cf_get_lang no ='243.Başlama Tarihi'></td>
            <td>
			<cfinput type="text" name="assetp_name" style="width:150px;" readonly value="" maxlength="50" required="yes" message="#message1#">
            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=add_kaza.assetp_id&field_name=add_kaza.assetp_name&list_select=2','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no ='243.Başlama Tarihi'>" border="0" align="absmiddle"></a>

			</td>
            <td><cf_get_lang no ='376.Prim Oranı'></td>
            <td>
			<cfinput type="text" name="assetp_name" style="width:150px;" readonly value="" maxlength="50" required="yes" message="#message1#">
			</td>
          </tr>
          <tr>
            <td><cf_get_lang_main no ='288.Bitiş Tarihi'></td>
            <td>
				<cfinput type="text" name="assetp_name" style="width:150px;" readonly value="" maxlength="50" required="yes" message="#message1#">
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=add_kaza.assetp_id&field_name=add_kaza.assetp_name&list_select=2','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no ='288.Bitiş Tarihi'>" border="0" align="absmiddle"></a>

			</td>
            <td>&nbsp;</td>
            <td><cf_workcube_buttons is_upd='0' is_cancel='0'add_function='kontrol()'></td>
          </tr>
        </table></td>
      </tr>
    </table></td>
  </tr>
</table>

