<cfsavecontent variable="message"><cf_get_lang dictionary_id="30965.Toplu Fazla Mesai"></cfsavecontent>
<cf_popup_box title="#message#">
<cfform name="add_overtime" action="#request.self#?fuseaction=ehesap.emptypopup_add_all_overtime" method="post">
	<table>
		<tr>
			<td width="75"><cf_get_lang dictionary_id='57576.Çalışan'>*</td>
			<td>
				<cfif isDefined("attributes.employee_id") and isdefined("attributes.in_out_id")>
					<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
					<input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#attributes.in_out_id#</cfoutput>">
					<cfinclude template="../query/get_hr_name.cfm">
					<input type="hidden" name="EMPLOYEE" id="EMPLOYEE" value="<cfoutput>#get_hr_name.employee_name# #get_hr_name.employee_surname#</cfoutput>">
					<cfoutput><b>#get_hr_name.employee_name# #get_hr_name.employee_surname#</b></cfoutput>
				<cfelse>
					<input type="hidden" name="employee_id" id="employee_id" value="">
					<input type="hidden" name="in_out_id" id="in_out_id" value="">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57576.Çalışan'></cfsavecontent>
					<cfinput name="EMPLOYEE" id="EMPLOYEE" type="text" style="width:150px;" required="yes" message="#message#" readonly="yes">
					<a href="javascript:windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=add_overtime.in_out_id&field_emp_name=add_overtime.EMPLOYEE&field_emp_id=add_overtime.employee_id','list');"><img src="/images/plus_thin.gif" border="0"></a>
				</cfif>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='58472.Dönem'></td>
			<td>
                <select name="term" id="term" style="width:80px;">
                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="j">
                        <option value="<cfoutput>#j#</cfoutput>"><cfoutput>#j#</cfoutput></option>
                    </cfloop>
                </select>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='58724.Ay'></td>
			<td>
                <select name="start_mon" id="start_mon" style="width:80px;">
                   	<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfloop from="1" to="12" index="j">
                        <option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option>
                    </cfloop>
                </select>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='53014.Normal Gün'></td>
            <td><input type="text" name="overtime_value0" id="overtime_value0" style="width:80px;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));"></td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='53015.Hafta Sonu'></td>
            <td><input type="text" name="overtime_value1" id="overtime_value1" style="width:80px;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));"></td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='53016.Resmi Tatil'></td>
            <td><input type="text" name="overtime_value2" id="overtime_value2" style="width:80px;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));"></td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='54251.Gece Çalışması'></td>
            <td><input type="text" name="overtime_value3" id="overtime_value3" style="width:80px;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));"></td>
		</tr>
	</table>
	<cf_popup_box_footer>
		<cf_workcube_buttons is_upd='0' add_function='check_()'>
	</cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script type="text/javascript">
function check_()
{
	if(document.getElementById('term').value == "")
	{
		alert('<cf_get_lang dictionary_id="58472.Dönem">');
		return false;
	}
	if(document.getElementById('start_mon').value == "")
	{
		alert('<cf_get_lang dictionary_id="58724.Ay">');
		return false;
	}
	document.getElementById('overtime_value0').value = filterNum(document.getElementById('overtime_value0').value,4);
	document.getElementById('overtime_value1').value = filterNum(document.getElementById('overtime_value1').value,4);
	document.getElementById('overtime_value2').value = filterNum(document.getElementById('overtime_value2').value,4);
	document.getElementById('overtime_value3').value = filterNum(document.getElementById('overtime_value3').value,4);
	return true;
}
</script>
