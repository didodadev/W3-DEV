<cfquery name="get_workgroup" datasource="#dsn#">
	SELECT
		WRK_ROW_ID,
		PARTNER_ID,
		POSITION_CODE,
		CONSUMER_ID,
		COMPANY_ID,
		OUR_COMPANY_ID,
		ROLE_ID,
		IS_MASTER,
		EMPLOYEE_ID,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE		
	FROM 
		WORKGROUP_EMP_PAR 
	WHERE 
		MAIN_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
		MAIN_EMPLOYEE_ID IS NOT NULL
</cfquery>
<cfparam name="attributes.modal_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="56347.İlişkili Çalışanlar"></cfsavecontent>
<cf_box title="#message#" popup_box="1">
    <cfform name="worker" method="post" action="#request.self#?fuseaction=hr.emptypopup_employee_add">
        <input type="hidden" name="main_employee_id" id="main_employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
        <cfquery name="get_rol" datasource="#dsn#">
            SELECT PROJECT_ROLES_ID, PROJECT_ROLES FROM SETUP_PROJECT_ROLES ORDER BY PROJECT_ROLES	
        </cfquery>
        <cf_grid_list>
        	<thead>
                <tr>
                    <th width="30">
                        <input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_workgroup.recordcount#</cfoutput>">
                        <input type="button" class="eklebuton" title="<cf_get_lang dictionary_id ='57582.Ekle'>" onClick="add_row();">
                    </th>
                    <th width="110"><cf_get_lang dictionary_id ='55478.Rol'></th>
                    <th width="200"><cf_get_lang dictionary_id ='57576.Çalışan'> *</th>
                </tr>
            </thead>
            <tbody name="table1" id="table1">
				<cfif get_workgroup.recordcount>
					<cfoutput query="get_workgroup">
					<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
					<input type="hidden" name="wrk_row_id#currentrow#" id="wrk_row_id#currentrow#" value="#wrk_row_id#">
						<tr id="frm_row#currentrow#">
							<td><a style="cursor:pointer" onClick="sil(#currentrow#);"><img  src="/images/delete_list.gif" border="0" align="absmiddle"></a></td>
							<td>
								<div class="form-group">
									<select name="get_role#currentrow#" id="get_role#currentrow#" >
										<cfset rol_ = get_workgroup.role_id>
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_rol">
											<option value="#project_roles_id#" <cfif rol_ eq project_roles_id>selected</cfif>>#project_roles#</option>
										</cfloop>
									</select>
								</div>
						
							</td>
							<td>
								<div class="form-group">
									<div class="input-group">
								<input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="#employee_id#">
								<input type="text" name="emp_par_name#currentrow#" id="emp_par_name#currentrow#" value="#get_emp_info(employee_id,0,0)#" readonly="yes">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id ='56649.Çalışan Seç'>" onClick="pencere_ac1(#currentrow#);"></span>
								</div>
							</div>
							</td>
						</tr>
					</cfoutput>
				</cfif>
            </tbody>
        </cf_grid_list>
		<cf_box_footer>
        	<cf_record_info query_name="get_workgroup">
			<cfif get_workgroup.recordcount>
                <cf_workcube_buttons is_upd='1' search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('worker' , #attributes.modal_id#)"),DE(""))#" is_delete='0' add_function='kontrol()'>
            <cfelse>
                <cf_workcube_buttons is_upd='0' search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('worker' , #attributes.modal_id#)"),DE(""))#" add_function='kontrol()'>
            </cfif>
        </cf_box_footer>
	</cfform>
</cf_box>
</div>

<script type="text/javascript">
	row_count=<cfoutput>#get_workgroup.recordcount#</cfoutput>;
	function kontrol()
	{
		if(document.worker.record_num.value > 0)
		{
			for(r=1;r<=worker.record_num.value;r++)
			{
				if(eval("document.worker.row_kontrol"+r).value == 1)
				{
					if(eval("document.worker.employee_id"+r).value == "")
					{
						alert("<cf_get_lang dictionary_id ='56353.Çalışan Seçmediniz, Lütfen Kontrol Ediniz'>!");
						return false;
					}
				}
			}
		}
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
		
		document.worker.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count +'"><input type="hidden" name="authorized'+ row_count +'" value="1"><input type="hidden" name="wrk_row_id'+ row_count +'" value=""><a style="cursor:pointer" onClick="sil(' + row_count + ');"><img src="/images/delete_list.gif" align="absmiddle" border="0" alt="<cf_get_lang_main no ='51.sil'>"></a>';							
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="get_role'+ row_count +'" ><option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option><cfoutput query="get_rol"><option value="#project_roles_id#">#project_roles#</option></cfoutput></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="employee_id'+ row_count +'" value=""><input type="text" name="emp_par_name'+ row_count +'" value="" readonly="yes"> <span class="input-group-addon btnPointer icon-ellipsis" onClick="pencere_ac1('+ row_count +');" alt="<cf_get_lang_main no='373.Uye Secmelisiniz'>"></span></div></div>';
	}
	
	function sil(sy)
	{
		var my_element=eval("worker.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	
	function pencere_ac1(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=worker.employee_id'+ no +'&field_name=worker.emp_par_name'+ no +'&select_list=1');
	}
</script>
