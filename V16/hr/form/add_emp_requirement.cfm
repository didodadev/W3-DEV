<cfquery name="GET_EMP_REQ" datasource="#DSN#">
  SELECT 
    ER.*,
	E.EMPLOYEE_NAME,
	E.EMPLOYEE_SURNAME
  FROM 
    EMPLOYEE_REQUIREMENTS ER,
	EMPLOYEES E
  WHERE 
	ER.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
	AND
	E.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>
<cfquery name="pos_req_types" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		POSITION_REQ_TYPE
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55471.Yeterlilik"></cfsavecontent>
<cf_box id="req_box" title="#message# : <cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput>" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform  name="add_pos_requirement" action="#request.self#?fuseaction=hr.emptypopup_add_emp_requirement" method="post">
	<input type="hidden" name="record_num" id="record_num" value="">
	<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#URL.EMPLOYEE_ID#</cfoutput>">
		<cf_grid_list>
			<thead>
					<tr>
						<th width="15">
							<cfif GET_EMP_REQ.RECORDCOUNT neq pos_req_types.recordcount><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_pos_req_types&EMPLOYEE_ID=#attributes.EMPLOYEE_ID#</cfoutput>');"> <i class="fa fa-plus" title="<cf_get_lang no='118.Yeterlilik Ekle'>"></i></a></cfif> 
						</th> 
						<th><cf_get_lang dictionary_id='55306.Yeterlilik Tipi'></th>
						<th width="50"><cf_get_lang dictionary_id='58456.Oran'></th>
					</tr>
			</thead>
			<tbody>		
				<cfif GET_EMP_REQ.RECORDCOUNT>
					<cfoutput query="GET_EMP_REQ">
						<cfquery name="GET_REQ_TYPE" datasource="#DSN#">
							SELECT REQ_TYPE FROM POSITION_REQ_TYPE WHERE REQ_TYPE_ID = #REQ_TYPE_ID#
						</cfquery>
						<tr>
							<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=hr.emptypopup_del_emp_req&req_id=#REQ_ID#&employee_id=#attributes.employee_id#');"> <i class="fa fa-minus" title="<cf_get_lang no='1533.Yeterlilik Sil'>"></i></a></td>
							<td><input type="hidden" name="req_type_id" id="req_type_id" value="#REQ_TYPE_ID#">
								<input type="text" name="req_type" id="req_type" value="#GET_REQ_TYPE.REQ_TYPE#">
							</td>
							<td><div class="form-group"><input type="text" name="coefficient" id="coefficient" value="#COEFFICIENT#"></div></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt yok'> !</td>
					</tr>
				</cfif> 
			</tbody>
		</cf_grid_list>
		<cf_box_footer>
			<cf_workcube_buttons type_format="1"is_upd='0'>
		</cf_box_footer>	
	</cfform>
</cf_box>
<script type="text/javascript">
	row_count=0;
	function kontrol_et()
	{
		if(row_count ==0)
			return false;
		else
			return true;
	}

	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		document.add_pos_requirement.record_num.value=row_count;			
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="req_type_id_' + row_count + '"><input type="text" name="req_type_' + row_count + '" id="req_type' + row_count + '" style="width:170px;"  class="formfieldright"><a onclick="javascript:opage(' + row_count +');"><img src="/images/plus_list.gif" border="0" align="absmiddle" style="cursor:pointer;"></a>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="coefficient_' + row_count + '" id="coefficient' + row_count + '" style="width:50px;"   value="" class="formfieldright">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '';
	}		

	function opage(deger)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_pos_req_types&field_id=add_pos_requirement.req_type_id_' + deger + '&field_name=add_pos_requirement.req_type_' + deger,'list');
	}	
	
</script>
