<cfquery name="GET_SERVICE" datasource="#dsn#">
	SELECT * FROM COMPANY_CARGO_INFO WHERE COMPANY_ID = #attributes.cpid#
</cfquery>
<cfset satir_row = get_service.recordcount>
<cf_box title="#getLang('','',51619)#">
<cfform name="add_cargo" action="#request.self#?fuseaction=crm.emptypopup_add_company_service_info" method="post">
	<input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
	<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#attributes.cpid#</cfoutput>">
    <cf_grid_list id="info_list">
        <thead>
            <tr>
                <th width="15" class="text-center"><input name="record_num" id="record_num" type="hidden" value="<cfoutput>#satir_row#</cfoutput>"><a href="javascript://" onClick="add_row();"><i class="fa fa-plus"></i></a></th>
                <th width="100"><cf_get_lang dictionary_id='57574.Şirket'>*</th>
                <th width="150"><cf_get_lang dictionary_id='51768.Kargo Kodu'>*</th>
            </tr>
        </thead>
		<tbody>
			<cfoutput query="get_service">
                <tr id="frm_row#currentrow#"> 
                    <td><input  type="hidden"  value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
                        <a style="cursor:pointer" onClick="sil('#currentrow#');"  ><i class="fa fa-minus"></i></a>
                    </td>
                    <td>
						<div class="form-group">
							<div class="input-group">
								<input type="hidden" name="company_id#currentrow#" id="row_kontrol#currentrow#" value="#get_service.cargo_comp_id#">
								<input type="text" name="company_name#currentrow#" id="company_name#currentrow#" style="width:200px;" value="#get_par_info(get_service.cargo_comp_id,1,0,0)#">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac('#currentrow#');"></span>
							</div>
						</div>
                    </td>
                    <td><input type="text" name="cargo_code#currentrow#" id="cargo_code#currentrow#" style="width:150px;" maxlength="100" value="#get_service.cargo_code#"></td>
                </tr>
            </cfoutput>
		</tbody>
        <tbody  id="table1"></tbody>
    </cf_grid_list>
	<div class="ui-info-bottom flex-end">
		<cf_workcube_buttons is_upd='0' type_format="1" add_function="kontrol()">
	</div>
</cfform>
</cf_box>
<script type="text/javascript">
	row_count=<cfoutput>#satir_row#</cfoutput>;

	function sil(sy)
	{
		var my_element=eval("add_cargo.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		$(my_element).remove();
	}
	
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
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		document.add_cargo.record_num.value=row_count;
		newCell = newRow.insertCell();
		newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><i class="fa fa-minus"></i></a>';
		newCell = newRow.insertCell();
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'"><input type="text" name="company_name' + row_count +'" id="company_name' + row_count +'" style="width:200px;"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac('+ row_count +');"></span></div></div>';
		newCell = newRow.insertCell();
		newCell.innerHTML = '<input type="text" name="cargo_code' + row_count +'" id="cargo_code' + row_count +'" style="width:150px;" maxlength="100">';
	}
	function kontrol() {
		counter = $("#info_list tbody tr").length;
		for(r=1; r<=counter; r++){
			if($("#cargo_code"+r).val() == ''){
				alert(r+".<cf_get_lang dictionary_id='63352.Satırda zorunlu alanlar eksik.'>!");
				return false;
			}
			if($("#company_name"+r).val() == ''){
				alert(r+".<cf_get_lang dictionary_id='63352.Satırda zorunlu alanlar eksik.'>!");
				return false;
			}
		}
	}
	function pencere_ac(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=add_cargo.company_id'+ no +'&field_comp_name=add_cargo.company_name'+ no +'&is_crm_module=1&select_list=2,5');
	}
</script>
