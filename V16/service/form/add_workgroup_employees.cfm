<cf_popup_box title="#getLang('main',728)#">
<cfform action="#request.self#?fuseaction=service.emptypopup_add_workgroup_employees&service_id=#attributes.service_id#" method="post" name="worker">
<table border="0">
	<tr>
		<td colspan="2" class="txtbold"><cf_get_lang_main no='164.Çalışan'></td>
	</tr>
    <cfloop index="i" from="1" to="10"> 
    <tr>
        <td></td>
        <td width="185">
        <cfoutput>
            <input type="hidden" name="POSITION_CODE#i#" id="POSITION_CODE#i#" value="">
            <input type="hidden" name="emp_id#i#" id="emp_id#i#" value="">
            <input type="text" name="emp_name#i#" id="emp_name#i#" value="" style="width:150px;">
        	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_emp_id=worker.emp_id#i#&field_code=worker.POSITION_CODE#i#&field_name=worker.emp_name#i#','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
        </cfoutput>
        </td>
    </tr>
    </cfloop>
</table>
  	<cf_popup_box_footer>
      <cf_workcube_buttons is_upd='0'>
	</cf_popup_box_footer>
</cfform>
</cf_popup_box>
