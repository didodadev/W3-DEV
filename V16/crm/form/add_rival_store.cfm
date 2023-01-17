<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr class="color-border">
<td>
<table width="100%" height="100%" border="0" cellpadding="2" cellspacing="1">
  <tr class="color-list">
    <td height="35"  class="headbold"><cf_get_lang dictionary_id="31681.Rakip Tercih Etme Nedenleri"></td>
  </tr>
  <tr>
    <td valign="top" class="color-row"><table>
      <tr>
        <td><cf_get_lang dictionary_id="31668.Eczanenin Rakip Depoları"></td>
        <td width="200"><input type="text" name="textfield" id="textfield" style="width:176"></td>
        </tr>
      <tr>
        <td><cf_get_lang dictionary_id="31637.Eczanenin Çalıştığı Depoları Tercih Etme Nedeni"></td>
        <td rowspan="3">
		<table>
					<tr>
					<td><select name="hobby" id="hobby" style="width:176px;height:75px" multiple></select></td>
					<td valign="top">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_hobby_detail&field_name=add_company_assistance_info.hobby','medium');"><img src="/images/plus_list.gif" border="0" align="top"></a><br/>
					<a href="javascript://" onClick="kaldir();"><img src="/images/delete_list.gif" border="0" title="Sil" style="cursor=hand" align="top"></a>
					</td>
					</tr>
			</table>
		</td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td><cf_workcube_buttons is_upd='0' add_function="kontrol()"></td>
        </tr>
    </table></td>
  </tr>
</table>
</td>
</tr>
</table>
