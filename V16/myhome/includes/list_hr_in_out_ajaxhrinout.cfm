<cf_get_lang_set module_name="hr">
<cfsetting showdebugoutput="no">
<cfparam name="attributes.in_out_selection" default="1">
<cfinclude template="../query/get_hr_in_out.cfm">
<div id="div_hr_in_out" style="width:100%;height:310;overflow:auto;">
	<div class="ui-form-list flex-end">
		<div class="form-group">
			<select name="in_out_selection" id="in_out_selection" onChange="change_in_out_det(this.value)">
				<option value="1" title="İlgili ay" <cfif attributes.in_out_selection eq 1>selected</cfif>><cf_get_lang_main no='1123.Girişler'></option>
				<option value="2" title="Son 10 gün" <cfif attributes.in_out_selection eq 2>selected</cfif> ><cf_get_lang_main no='1124.Çıkışlar'></option>
			</select> 
		</div>
	</div>
	<cf_flat_list>
		<tbody>
			<cfif get_in_out_det.recordcount>
				<cfoutput query="get_in_out_det">
					<tr id="hr_in_out_1" <cfif attributes.in_out_selection neq 1>style="display:none;"</cfif>>
						<td><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" class="tableyazi">#emp_name#</a> - #branch_name#</td>
						<td>#POSITION_NAME#
						</td>
						<td><cfif collar_type eq 1><cf_get_lang no='980.Mavi Yaka'><cfelseif collar_type eq 2><cf_get_lang no='981.Beyaz Yaka'><cfelse></cfif>
						</td>
						<td>#dateformat(START_DATE,'dd.mm.yyyy')#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr id="hr_in_out_1" <cfif attributes.in_out_selection neq 1>style="display:none;"</cfif>>
					<td><cf_get_lang_main no='72.Kayıt Yok'> !</td>
				</tr>
			</cfif>
			<cfif get_in_out_det.recordcount>
				<cfoutput query="get_in_out_det">
					<tr id="hr_in_out_2" <cfif attributes.in_out_selection neq 2>style="display:none;"</cfif>>
						<td><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" class="tableyazi">#emp_name#</a> - 
							#branch_name#
						</td>
						<td>
							#POSITION_NAME#
						</td>
						<td><cfif collar_type eq 1><cf_get_lang no='980.Mavi Yaka'><cfelseif collar_type eq 2><cf_get_lang no='981.Beyaz Yaka'><cfelse></cfif>
						</td>
						<td>
							#dateformat(FINISH_DATE,'dd.mm.yyyy')#
						</td>
						
						
					</tr>
				</cfoutput>
			<cfelse>
				<tr id="hr_in_out_2" <cfif attributes.in_out_selection neq 2>style="display:none;"</cfif>>
					<td><cf_get_lang_main no='72.Kayıt Yok'> !</td>
				</tr>
			</cfif> 
		</tbody>
	</cf_flat_list>
</div> 
 <script language="javascript">
	function change_in_out_det(in_out_selection1)
	{
		if(document.getElementById("in_out_selection").value == 1)
		{
			document.getElementById("hr_in_out_1").style.display = '';
		}
		else
		{
			document.getElementById("hr_in_out_1").style.display = 'none';
		}
		if(document.getElementById("in_out_selection").value == 2)
		{
			document.getElementById("hr_in_out_2").style.display = '';
		}
		else
		{
			document.getElementById("hr_in_out_2").style.display = 'none';
		}
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_list_hr_in_out_ajaxhrinout&in_out_selection='+in_out_selection1+'</cfoutput>','div_hr_in_out',1);
		return true;
	}
</script> 
