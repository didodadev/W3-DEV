<cf_popup_box title="#getLang('training',137)#">
<cfform name="add_class_join_request" method="post" action="#request.self#?fuseaction=training.emptypopup_add_class_join_request">
    <table>
        <tr>
            <td><cf_get_lang_main no ='7.Eğitim'></td>
            <td>
                <input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                <input type="hidden" name="class_id" id="class_id" value="">
                <input type="text" name="class_name" id="class_name" value="" style="width:250px;" readonly="yes">
                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=training.popup_list_classes&field_id=add_class_join_request.class_id&field_name=add_class_join_request.class_name</cfoutput>','list');"> <img src="/images/plus_thin.gif" border="0" align="absmiddle"> </a> 
            </td>
        </tr>
    </table>
	<cf_popup_box_footer>
    	<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
    </cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script type="text/javascript">
function get_class_name(id)
{
	var get_class_name_ = wrk_safe_query('trn_get_class_name','dsn',0,id);
	document.add_class_join_request.class_name.value = get_class_name_.CLASS_NAME;
}	
function kontrol(){
	 if (add_class_join_request.class_id.value == '')
		{
		alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='7.Eğitim '>");
		return false;
		}
	else
		return true;
}
</script>
