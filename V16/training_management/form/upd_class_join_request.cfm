<cfinclude template="../query/get_trainin_join_request.cfm">
<cfsavecontent variable="right_">
	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=training_management.popup_form_add_class_join_request</cfoutput>','page');"><img src="/images/plus1.gif" title="<cf_get_lang_main no='170.Ekle'>"></a>
</cfsavecontent>
<cf_popup_box title="#getLang('training_management',384)#" right_images="#right_#">
    <cfform name="upd_class_join_request" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_class_join_request">
    <input type="hidden" name="REQUEST_ID" id="REQUEST_ID" value="<cfoutput>#get_trainin_join_request.TRAINING_JOIN_REQUEST_ID#</cfoutput>">
    <table>
        <tr> 
            <td><cf_get_lang_main no='158.Ad Soyad'></td>
            <td>
            	<input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#get_trainin_join_request.EMPLOYEE_ID#</cfoutput>"> 
                <input type="hidden" name="par_id" id="par_id" value=""> <input type="hidden" name="member_type" id="member_type" value=""> 
                <cfset attributes.EMPLOYEE_ID = get_trainin_join_request.EMPLOYEE_ID> 
                <cfinclude template="../query/get_employee.cfm"> <input type="text" name="emp_par_name" id="emp_par_name" value="<cfoutput>#get_employee.EMPLOYEE_NAME# #get_employee.EMPLOYEE_SURNAME#</cfoutput>" style="width:250px;" readonly="yes">
                <!--- class="label"  --->
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_class_join_request.emp_id&field_name=upd_class_join_request.emp_par_name&field_type=upd_class_join_request.member_type&field_partner=upd_class_join_request.par_id&select_list=1</cfoutput>','list');"> 
               		<img src="/images/plus_thin.gif"  border="0" align="absmiddle"> 
                </a> 
            </td>
        </tr>
        <tr> 
            <td><cf_get_lang_main no='7.Eğitim'></td>
            <td>
            	<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#get_trainin_join_request.CLASS_ID#</cfoutput>"> 
				<cfset attributes.CLASS_ID = get_trainin_join_request.CLASS_ID> 
                <cfinclude template="../query/get_class.cfm"> <input type="text" name="class_name" id="class_name" value="<cfoutput>#get_class.class_name#</cfoutput>" style="width:250px;" readonly="yes">
                <!--- class="label"  --->
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=training_management.popup_list_classes&field_id=upd_class_join_request.class_id&field_name=upd_class_join_request.class_name</cfoutput>','list');"> 
                	<img src="/images/plus_thin.gif"  border="0" align="absmiddle"> 
                </a> 
            </td>
        </tr>
    </table>
    <cf_popup_box_footer>
    	<cf_workcube_buttons is_upd='1' add_function='kontrol()'  delete_page_url='#request.self#?fuseaction=training_management.emptypopup_del_class_join_request&request_id=#get_trainin_join_request.TRAINING_JOIN_REQUEST_ID#'>
    </cf_popup_box_footer>
    </cfform>
</cf_popup_box>
<script type="text/javascript">
function kontrol(){
	if (upd_class_join_request.emp_id.value == '' && upd_class_join_request.par_id.value == '')
		{
		alert ('Kişi seçmelisiniz !');
		return false;
		}
	else if (upd_class_join_request.class_id.value == '')
		{
		alert ('Eğitim seçmelisiniz !');
		return false;
		}
	else
		return true;
}
</script>
