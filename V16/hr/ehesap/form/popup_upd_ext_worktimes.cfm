<cfparam name="attributes.related_year" default="#session.ep.period_year#">
<cfinclude template="../query/get_employees_overtime.cfm">

<cf_box title="#getLang('','Fazla Mesailer',52970)# : #get_emp_info(attributes.employee_id,0,0)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">	
	<cfform name="search_form" method="post" action="#request.self#?fuseaction=ehesap.popup_form_upd_ext_worktimes&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#">
		<cf_box_search more="0">
			<div class="form-group">
				<select name="related_year" id="related_year">
					<cfloop from="#year(now())+2#" to="2008" index="i" step="-1">
					<cfoutput>
						<option value="#i#"<cfif attributes.related_year eq i> selected</cfif>>#i#</option>
					</cfoutput>
					</cfloop>
				</select>
			</div>
			<div class="form-group">
				<!--- Ücret Odenek Ajaxından --->
				<cfif isdefined("attributes.from_upd_salary") and attributes.from_upd_salary eq 1>
					<input type="hidden" name="from_upd_salary" id="from_upd_salary" value="1">
					<label id="ajax_label" style="display:none!important;"></label>
					<cf_wrk_search_button button_type="4" search_function="ajax_function()">
				<cfelse>
					<cf_wrk_search_button button_type="4">
				</cfif>
			</div>
		</cf_box_search>
	</cfform>
	<cfform name="form_basket" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_upd_ext_worktimes">
		<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.EMPLOYEE_ID#</cfoutput>">
		<input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#attributes.in_out_id#</cfoutput>">
		<input type="hidden" name="rowCount" id="rowCount" value="">
		<input type="hidden" name="rowCount_sabit" id="rowCount_sabit" value="<cfoutput>#get_overtime.recordcount#</cfoutput>">
		<cfif isdefined("attributes.from_upd_salary") and attributes.from_upd_salary eq 1>
			<input type="hidden" name="from_upd_salary" id="from_upd_salary" value="1">
		</cfif>
		<cf_grid_list id="table_list">
				<thead>
					<tr>
						<th width="20"><a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
						<th width="70"><cf_get_lang dictionary_id='58472.Dönem'></th>
						<th width="65"><cf_get_lang dictionary_id='58724.Ay'></th>
						<th width="80"><cf_get_lang dictionary_id='53014.Normal Gün'></th>
						<th width="80"><cf_get_lang dictionary_id='53015.Hafta Sonu'></th>
						<th width="80"><cf_get_lang dictionary_id='53016.Resmi Tatil'></th>
						<th width="80"><cf_get_lang dictionary_id='54251.Gece Çalışması'></th>
					</tr>
				</thead>
				<cfoutput query="get_overtime" group="OVERTIME_PERIOD">
					<tbody id="my_div_#OVERTIME_PERIOD#">
						<cfoutput>
						<input type="hidden" name="sabit_worktimes_id#currentrow#" id="sabit_worktimes_id#currentrow#" value="#worktimes_id#">
						<input type="hidden" name="sabit_row_kontrol_#currentrow#" id="sabit_row_kontrol_#currentrow#" value="1">
						<tr id="sabit_my_row_#currentrow#" title="<cfif len(record_date)>Kayıt : #get_emp_info(record_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#)</cfif>  <cfif len(update_date)> &nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id='57703.Güncelleme'> : #get_emp_info(update_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,update_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#)</cfif>">
							<td><a style="cursor:pointer;" onClick="sabit_sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
							<td>
								<select name="sabit_term#currentrow#" id="sabit_term#currentrow#" style="width:70">
									<cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="j">
										<option value="#j#" <cfif get_overtime.overtime_period eq j>selected</cfif>>#j#</option>
									</cfloop>
								</select>
							</td>
							<td>
								<select name="sabit_start_mon#currentrow#" id="sabit_start_mon#currentrow#" style="width:65px;">
									<cfloop from="1" to="12" index="j">
										<option value="#j#"<cfif overtime_month eq j> selected</cfif>>#listgetat(ay_list(),j,',')#</option>
									</cfloop>
								</select>
							</td>
							<td><input type="text" name="sabit_value0_#currentrow#" id="sabit_value0_#currentrow#" style="width:80px;" class="moneybox" value="#TLFormat(OVERTIME_VALUE_0,2)#" onkeyup="return(FormatCurrency(this,event,2));"></td><!--- normal gün--->
							<td><input type="text" name="sabit_value1_#currentrow#" id="sabit_value1_#currentrow#" style="width:80px;" class="moneybox" value="#TLFormat(OVERTIME_VALUE_1,2)#" onkeyup="return(FormatCurrency(this,event,2));"></td><!---hafta sonu ---->
							<td><input type="text" name="sabit_value2_#currentrow#" id="sabit_value2_#currentrow#" style="width:80px;" class="moneybox" value="#TLFormat(OVERTIME_VALUE_2,2)#" onkeyup="return(FormatCurrency(this,event,2));"></td><!--- resmi tatil--->
							<td><input type="text" name="sabit_value3_#currentrow#" id="sabit_value3_#currentrow#" style="width:80px;" class="moneybox" value="#TLFormat(OVERTIME_VALUE_3,2)#" onkeyup="return(FormatCurrency(this,event,2));"></td><!---gece çalışması --->
						</tr>
						</cfoutput>
					</tbody>
				</cfoutput>
		</cf_grid_list>
		<cf_box_footer>
			<cf_record_info query_name="get_overtime">
			<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
	rowCount_sabit = <cfif get_overtime.recordcount><cfoutput>#get_overtime.recordcount#</cfoutput><cfelse>0</cfif>;
	rowCount = 0;
	function add_row()
	{
		rowCount++;
		var newRow;
		var newCell;
		newRow = table_list.insertRow();
		newRow.className = 'color-row';
		newRow.setAttribute("name","my_row_" + rowCount);
		newRow.setAttribute("id","my_row_" + rowCount);		
		newRow.setAttribute("NAME","my_row_" + rowCount);
		newRow.setAttribute("ID","my_row_" + rowCount);	
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a onClick="sil(' + rowCount + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol_' + rowCount +'"><select name="term' + rowCount +'" id="term' + rowCount +'" style="width:70"><cfoutput><cfloop from="#session.ep.period_year#" to="#session.ep.period_year+2#" index="j"><option value="#j#">#j#</option></cfloop></cfoutput></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="start_mon' + rowCount +'" id="start_mon' + rowCount +'" style="width:65px;"><cfoutput><cfloop from="1" to="12" index="j"><option value="#j#">#listgetat(ay_list(),j,',')#</option></cfloop></cfoutput></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="value0_' + rowCount +'" id="value0_' + rowCount +'" style="width:80px;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="value1_' + rowCount +'" id="value1_' + rowCount +'" style="width:80px;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="value2_' + rowCount +'" id="value2_' + rowCount +'" style="width:80px;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="value3_' + rowCount +'" id="value3_' + rowCount +'" style="width:80px;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));">';
	}
	function sil(sy)
	{
		var my_element=eval("form_basket.row_kontrol_"+sy);
		my_element.value=0;
	
		var my_element=eval("my_row_"+sy);
		my_element.style.display="none";
	}
	
	function sabit_sil(sy)
	{
		var my_element=eval("form_basket.sabit_row_kontrol_"+sy);
		my_element.value=0;
	
		var my_element=eval("sabit_my_row_"+sy);
		my_element.style.display="none";
	}	
	function kontrol()
	{	
		form_basket.rowCount.value = rowCount;
		for (m=0; m < rowCount; m++)
			{
				var c = m + 1;
				eval("form_basket.value0_" + c).value = filterNum(eval("form_basket.value0_" + c).value,4);
				eval("form_basket.value1_" + c).value = filterNum(eval("form_basket.value1_" + c).value,4);
				eval("form_basket.value2_" + c).value = filterNum(eval("form_basket.value2_" + c).value,4);
				eval("form_basket.value3_" + c).value = filterNum(eval("form_basket.value3_" + c).value,4);
			}
		for (i=0; i < rowCount; i++)
			{
				var k = i + 1;
				if(eval("form_basket.value0_" + k).value == 0 && eval("form_basket.value1_" + k).value == 0 && eval("form_basket.value2_" + k).value == 0 && eval("form_basket.value3_" + k).value == 0)
				{
					alert("<cf_get_lang dictionary_id='59673.Normal Gün,Hafta sonu,Resmi tatil veya Gece çalışması girmelisiniz'>!");
					return false;
				}				
			}
		for (m=0; m < rowCount_sabit; m++)
			{
				var c = m + 1;
				eval("form_basket.sabit_value0_" + c).value = filterNum(eval("form_basket.sabit_value0_" + c).value,4);
				eval("form_basket.sabit_value1_" + c).value = filterNum(eval("form_basket.sabit_value1_" + c).value,4);
				eval("form_basket.sabit_value2_" + c).value = filterNum(eval("form_basket.sabit_value2_" + c).value,4);
				eval("form_basket.sabit_value3_" + c).value = filterNum(eval("form_basket.sabit_value3_" + c).value,4);
			}
		for (i=0; i < rowCount_sabit; i++)
			{
				var k = i + 1;
				if(eval("form_basket.sabit_value0_" + k).value == 0 && eval("form_basket.sabit_value1_" + k).value == 0 && eval("form_basket.sabit_value2_" + k).value == 0 && eval("form_basket.sabit_value3_" + k).value == 0)
				{
					alert("<cf_get_lang dictionary_id='59673.Normal Gün,Hafta sonu,Resmi tatil veya Gece çalışması girmelisiniz'>!");
					return false;
				}				
			}
	}	
	function ajax_function()
	{
		related_year = $("#related_year").val();

		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_form_upd_ext_worktimes&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#</cfoutput>&from_upd_salary=1&related_year='+related_year,'ajax_right');

		return false;
	}
</script>
