<cfquery name="get_boss" datasource="#dsn#">
  SELECT * FROM EMPLOYEE_PERFORMANCE_TARGET WHERE PER_ID=#attributes.per_id#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55270.Amir Listesi"></cfsavecontent>
<cf_popup_box title="#message#">
<cfform name="add_request_boss" method="post" action="#request.self#?fuseaction=hr.emptypopup_target_plan_boss">
<input type="hidden" name="per_id" id="per_id" value="<cfoutput>#attributes.per_id#</cfoutput>">
	<table>
		 <tr>
			<td><cf_get_lang dictionary_id="31612.Üst Amir"> 1</td>
			<td>
				<input type="hidden" name="amir_id_1" id="amir_id_1" value="<cfoutput>#get_boss.first_boss_id#</cfoutput>">
				<input type="hidden" name="amir_code_1" id="amir_code_1" value="<cfoutput>#get_boss.first_boss_code#</cfoutput>">
				<cfif get_boss.first_boss_valid eq 1><cfset AMIR_1_NAME=get_emp_info(get_boss.first_boss_id,0,0)><cfelse><cfset AMIR_1_NAME=get_emp_info(get_boss.first_boss_code,1,0)></cfif>
				<cfinput type="text" name="amir_name_1" value="#amir_1_name#" style="width:180px;" onBlur="temizle('amir_name_1','amir_id_1','amir_code_1')">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_request_boss.amir_id_1&field_name=add_request_boss.amir_name_1&field_code=add_request_boss.amir_code_1&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif"></a>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id="31612.Üst Amir"> 2</td>
			<td>
				<input type="hidden" name="amir_id_2" id="amir_id_2" value="<cfoutput>#get_boss.second_boss_id#</cfoutput>">
				<input type="hidden" name="amir_code_2" id="amir_code_2" value="<cfoutput>#get_boss.second_boss_code#</cfoutput>">
				<cfif get_boss.second_boss_valid eq 1><cfset AMIR_2_NAME=get_emp_info(get_boss.second_boss_id,0,0)><cfelse><cfset AMIR_2_NAME=get_emp_info(get_boss.second_boss_code,1,0)></cfif>
				<cfinput type="text" name="amir_name_2" value="#amir_2_name#" style="width:180px;" onBlur="temizle('amir_name_2','amir_id_2','amir_code_2')">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_request_boss.amir_id_2&field_name=add_request_boss.amir_name_2&field_code=add_request_boss.amir_code_2&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif"></a>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id="31612.Üst Amir"> 3</td>								
			<td>
				<input type="hidden" name="amir_id_3" id="amir_id_3" value="<cfoutput>#get_boss.third_boss_id#</cfoutput>">
				<input type="hidden" name="amir_code_3" id="amir_code_3" value="<cfoutput>#get_boss.third_boss_code#</cfoutput>">
				<cfif get_boss.third_boss_valid eq 1><cfset AMIR_3_NAME=get_emp_info(get_boss.third_boss_id,0,0)><cfelse><cfset AMIR_3_NAME=get_emp_info(get_boss.third_boss_code,1,0)></cfif>
				<cfinput type="text" name="amir_name_3" value="#amir_3_name#" style="width:180px;" onBlur="temizle('amir_name_3','amir_id_3','amir_code_3')">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_request_boss.amir_id_3&field_name=add_request_boss.amir_name_3&field_code=add_request_boss.amir_code_3&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif"></a>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id="31612.Üst Amir"> 4</td>								
			<td>
				<input type="hidden" name="amir_id_4" id="amir_id_4" value="<cfoutput>#get_boss.fourth_boss_id#</cfoutput>">
				<input type="hidden" name="amir_code_4" id="amir_code_4" value="<cfoutput>#get_boss.fourth_boss_code#</cfoutput>">
				<cfif get_boss.fourth_boss_valid eq 1><cfset AMIR_4_NAME=get_emp_info(get_boss.fourth_boss_id,0,0)><cfelse><cfset AMIR_4_NAME=get_emp_info(get_boss.fourth_boss_code,1,0)></cfif>
				<cfinput type="text" name="amir_name_4" value="#amir_4_name#" style="width:180px;" onBlur="temizle('amir_name_4','amir_id_4','amir_code_4')">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_request_boss.amir_id_4&field_name=add_request_boss.amir_name_4&field_code=add_request_boss.amir_code_4&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif"></a>
			</td>
	
	
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id="31612.Üst Amir"> 5</td>								
			<td>
				<input type="hidden" name="amir_id_5" id="amir_id_5" value="<cfoutput>#get_boss.fifth_boss_id#</cfoutput>">
				<input type="hidden" name="amir_code_5" id="amir_code_5" value="<cfoutput>#get_boss.fifth_boss_code#</cfoutput>">
				<cfif get_boss.fifth_boss_valid eq 1><cfset AMIR_5_NAME=get_emp_info(get_boss.fifth_boss_id,0,0)><cfelse><cfset AMIR_5_NAME=get_emp_info(get_boss.fifth_boss_code,1,0)></cfif>
				<cfinput type="text" name="amir_name_5" value="#amir_5_name#" style="width:180px;" onBlur="temizle('amir_name_5','amir_id_5','amir_code_5')">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_request_boss.amir_id_5&field_name=add_request_boss.amir_name_5&field_code=add_request_boss.amir_code_5&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif"></a>
			</td>
		</tr>
	</table>
	<cf_popup_box_footer>
		<cf_workcube_buttons is_upd='1' is_delete='0' type_format="1" add_function='kontrol()' insert_alert = 'Formun Onay Sürecleri Başa Alınacaktır. Güncellemek İstediğinizden Emin misiniz?'>
	</cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script type="text/javascript">
function temizle(alan,alan_id,alan_code)
{
	if(trim(eval('document.add_request_boss.'+alan).value).length==0)
	{
		eval('document.add_request_boss.'+alan_id).value='';
		eval('document.add_request_boss.'+alan_code).value='';
	}
}
function kontrol()
{
	if(document.add_request_boss.amir_name_1.value.length==0 || document.add_request_boss.amir_id_1.value.length==0 || document.add_request_boss.amir_code_1.value.length==0)
	{
		alert("<cf_get_lang dictionary_id='41513.İlk Amiri Seçmelisiniz!'>");
		return false;
	}
	return true;	
}
</script>
