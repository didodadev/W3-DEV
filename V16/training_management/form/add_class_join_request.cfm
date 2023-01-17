<cfform name="add_class_join_request" method="post" action="#request.self#?fuseaction=training_management.emptypopup_add_class_join_request">
<cf_popup_box title="#getLang('training_management',373)#">
    <table>
        <tr>
            <td><cf_get_lang_main no='158.Ad Soyad'></td>
            <td>
            <input type="hidden" name="emp_id" id="emp_id" value="">
            <input type="hidden" name="par_id" id="par_id" value="">
            <input type="hidden" name="member_type" id="member_type" value="">
            <input type="text" name="emp_par_name" id="emp_par_name" value="" style="width:250px;" readonly="yes">
            <!--- class="label"  --->
            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_class_join_request.emp_id&field_name=add_class_join_request.emp_par_name&field_type=add_class_join_request.member_type&field_partner=add_class_join_request.par_id&select_list=1</cfoutput>','list');"> <img src="/images/plus_thin.gif"  border="0" align="absmiddle"> </a> </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='7.Eğitim'></td>
            <td>
            <input type="hidden" name="class_id" id="class_id" value="">
            <input type="text" name="class_name" id="class_name" value="" style="width:250px;" readonly="yes">
            <!--- class="label"  --->
            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=training_management.popup_list_classes&field_id=add_class_join_request.class_id&field_name=add_class_join_request.class_name</cfoutput>','list');"> <img src="/images/plus_thin.gif" border="0" align="absmiddle"> </a> </td>
        </tr>
    </table>
    <cf_popup_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()' type_format="1"></cf_popup_box_footer>
</cf_popup_box>
</cfform>
<script type="text/javascript">
function kontrol(){
	if (add_class_join_request.emp_id.value == '' && add_class_join_request.par_id.value == '')
		{
		alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='219.Ad !'>");
		return false;
		}
	else if (add_class_join_request.class_id.value == '')
		{
		alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='7.eğitim !'>");
		return false;
		}
	else
		return true;
}
</script>
