<cfinclude template="../query/get_branchs_deps.cfm">
<cfinclude template="../query/get_assetp_cats.cfm">
<table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="headbold"><cf_get_lang no='83.Fiziki Varlık Ekle'></td>
  </tr>
</table>
        <table width="98%" align="center" cellpadding="2" cellspacing="1" border="0" class="color-border">
		  <cfform method="post" name="add_assetp" action="#xfa.add#">
          <tr class="color-row">
            <td>
              <table border="0">
                <tr>
				<td width="100">Demirbaş No *</td>
				<td><cfsavecontent variable="message">Demirbaş No Giriniz !</cfsavecontent>
				<cfinput type="text" name="inventory_number" required="yes" message="#message#" style="width:250px;" maxlength="50"></td>
				</tr>
				<tr>
                  <td><cf_get_lang_main no='1655.Varlık'> *</td>
                  <td><cfinput type="text" name="assetp" style="width:250px;" value="" maxlength="50"></td>
                </tr>
				<tr>
                  <td width="100"><cf_get_lang_main no='74.Kategori'>*</td>
                  <td><select name="assetp_catid" id="assetp_catid" style="width:250px;">
                      <cfoutput query="get_assetp_cats">
                        <option value="#assetp_catid#">#assetp_cat#</option>
                      </cfoutput>
                    </select></td>
                </tr>
                <tr>
                  <td height="30"><cf_get_lang_main no='160.Departman'> *</td>
                  <td><select name="department_id" id="department_id" style="width:250px;">
                      <option value=""><cf_get_lang no='121.Department Seçiniz'></option>
                      <cfoutput query="get_branchs_deps">
                        <option value="#department_id#">#branch_name#-#department_head#</option>
                      </cfoutput>
                    </select></td>
                </tr><input type="hidden" name="position_code" id="position_code" value="">
                <tr>
                  <td><cf_get_lang_main no='132.Sorumlu'> *</td>
                  <td><input type="text" name="position" id="position" value="" readonly style="width:250px;">
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_assetp.position_code&field_name=add_assetp.position</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='132.Sorumlu'>" align="absmiddle" border="0"></a></td>
                </tr>
				<tr>
				<td><cf_get_lang_main no='132.Sorumlu'> 2</td>
                  <td><input type="hidden" name="position_code2" id="position_code2" value="">
				  	<input type="text" name="position2" id="position2" value="" readonly style="width:250px;">
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_assetp.position_code2&field_name=add_assetp.position2</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='132.Sorumlu'>" align="absmiddle" border="0"></a></td>
				</tr>
                <tr>
                  <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                  <td><textarea name="assetp_detail" id="assetp_detail" style="width:250px;height:60px;"></textarea></td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td height="35" style="text-align:right;"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
                </tr>
              </table>
      </td>
    </tr>
  </cfform>
</table>
<script type="text/javascript">
	function kontrol()
	{
		x = document.add_assetp.department_id.selectedIndex;
		if (document.add_assetp.department_id[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='160.Departman !'>");
			return false;
		}
		if ( (document.add_assetp.position_code.value == "") || ((document.add_assetp.position.value == "")) )
		{ 
			alert ("<cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='132.Sorumlu !'>");
			return false;
		}
		if (document.add_assetp.assetp.value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik veri'>:<cf_get_lang no='35.Varlık Adı !'>");
			return false;
		}
		return true;
	}
</script>
