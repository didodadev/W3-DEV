<cfform name="add_class_join_request" method="post" action="#request.self#?fuseaction=training_management.emptypopup_add_class_personal_join_request">
  <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr class="color-border">
    <td>
  <table width="100%" height="100%" border="0" align="center" cellpadding="2" cellspacing="1">
    <tr>
      <td class="headbold" height="35" class="color-list"><cf_get_lang no='373.Eğitim Talebi Ekle'></td>
    </tr>
    <tr class="color-row">
      <td valign="top"><table  border="0" cellspacing="2" cellpadding="2">
        <tr>
          <td><cf_get_lang_main no='158.Ad Soyad'></td>
          <td>
            <input type="hidden" name="emp_id" id="emp_id" value=<cfoutput>#ep.employee.userid#</cfoutput>>
  		<input type="text" name="emp_par_name" id="emp_par_name" value="<cfoutput>#ep.employee.name#&nbsp;#ep.employee.surname#</cfoutput>" style="width:250px;" readonly="yes">
          </td>
        </tr>
        <tr>
          <td><cf_get_lang_main no='7.Eğitim'></td>
          <td>
            <input type="hidden" name="class_id" id="class_id" value="">
            <input type="text" name="class_name" id="class_name" value="" style="width:250px;" readonly="yes">
            <!--- class="label"  --->
          <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=training_management.popup_list_classes&field_id=add_class_join_request.class_id&field_name=add_class_join_request.class_name</cfoutput>','list');"> <img src="/images/plus_thin.gif"  border="0" align="absmiddle"> </a> </td>
        </tr>
        <tr>
          <td></td>
          <td colspan="2" height="35"> <cf_workcube_buttons is_upd='0' add_function='kontrol()'> </td>
        </tr>
      </table></td>
    </tr>
  </table>
  </td>
  </tr>
</table>
</cfform>
<script type="text/javascript">
function kontrol(){
		if (add_class_join_request.class_id.value == '')
		{
		alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='7.Eğitim !'>");
		return false;
		}
	else
		return true;
}
</script>
