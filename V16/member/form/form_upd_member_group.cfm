<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfquery name="GET_WORKGROUP" datasource="#DSN#">
	SELECT
		WRK_ROW_ID,
		PARTNER_ID,
		POSITION_CODE,
		CONSUMER_ID,
		COMPANY_ID,
		OUR_COMPANY_ID,
		ROLE_ID,
		IS_MASTER,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE		
	FROM 
		WORKGROUP_EMP_PAR 
	WHERE 
		OUR_COMPANY_ID IS NOT NULL AND
		<cfif len(attributes.company_id)>
            COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
        <cfelse>
            CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
        </cfif>
</cfquery>
<cfquery name="GET_UPDATE_EMP" dbtype="query" maxrows="1">
	SELECT * FROM GET_WORKGROUP WHERE UPDATE_EMP IS NOT NULL AND UPDATE_DATE IS NOT NULL ORDER BY RECORD_DATE DESC
</cfquery>
<cfsavecontent variable="title">
	<cfif len(attributes.company_id)>
        <cf_get_lang dictionary_id='30199.Kurumsal Üye Ekibi'>
    <cfelseif len(attributes.consumer_id)>
        <cf_get_lang dictionary_id='30564.Bireysel Üye Ekibi'>
    </cfif>
</cfsavecontent>
<cf_box title="#title#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="worker" method="post" action="#request.self#?fuseaction=member.emptypopup_member_add">
	<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
	<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
	<cfquery name="GET_POS_ID" datasource="#DSN#">
		SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
	</cfquery>
	<input type="hidden" name="position_id" id="position_id" value="<cfoutput>#get_pos_id.position_id#</cfoutput>">
	<cfquery name="PERIODS" datasource="#DSN#">
		SELECT DISTINCT
			SP.OUR_COMPANY_ID
		FROM
			SETUP_PERIOD SP, 
			EMPLOYEE_POSITION_PERIODS EP
		WHERE 
			EP.PERIOD_ID = SP.PERIOD_ID AND 
			EP.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pos_id.position_id#">
	</cfquery>
	<cfset our_company_list =listsort(listdeleteduplicates(valuelist(periods.our_company_id,',')),'numeric','ASC',',')>
	<cfquery name="COMPANY_NAME" datasource="#DSN#">
		SELECT COMP_ID, NICK_NAME FROM OUR_COMPANY WHERE COMP_ID IN (#valuelist(periods.our_company_id,',')#)
	</cfquery>
	<cfquery name="GET_ALL_COMPANY" datasource="#DSN#">
		SELECT COMP_ID, NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME ASC
	</cfquery>
	<cfquery name="GET_ROL" datasource="#DSN#">
		SELECT PROJECT_ROLES_ID, PROJECT_ROLES FROM SETUP_PROJECT_ROLES ORDER BY PROJECT_ROLES	
	</cfquery>
    <cf_grid_list>
        <thead>
            <tr>
                <th style="width:20px;">
                    <input type="hidden" name="record_number" id="record_number" value="<cfoutput>#get_workgroup.recordcount#</cfoutput>">
                    <a href="javascript://" onClick="add_row();" title="<cf_get_lang dictionary_id ='57582.Ekle'>"><i class="fa fa-plus"></i></a>
                </th>
                <th><cf_get_lang dictionary_id='57574.Şirket'> *</th>
                <th><cf_get_lang dictionary_id='30395.Rol'></th>
                <th><cf_get_lang dictionary_id='57658.Üye'> *</th>
                <th><cf_get_lang dictionary_id='30562.Master'></th>
            </tr>
        </thead>
        <tbody name="table1" id="table1">
        <cfif get_workgroup.recordcount>
            <cfoutput query="get_workgroup">
                <cfset is_authorized = listfind(our_company_list,our_company_id,',')>
                <cfif is_authorized neq 0>
                    <cfset is_authorized = 1>
                </cfif>
                <tr id="frm_row#currentrow#">
                    <cfif is_authorized eq 0>
                        <td>&nbsp;</td>
                    <cfelse>
                        <td nowrap><a style="cursor:pointer" onClick="sil(#currentrow#);"><i class="fa fa-minus"></i></a></td>
                    </cfif>
                    <td>
                        <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                        <input type="hidden" name="authorized#currentrow#" id="authorized#currentrow#" value="#is_authorized#">
                        <input type="hidden" name="wrk_row_id#currentrow#" id="wrk_row_id#currentrow#" value="#wrk_row_id#">
                        <cfset our_company_id_ = get_workgroup.our_company_id>
                        <cfif is_authorized neq 0>
							<div class="form-group">
								<select name="our_company_id#currentrow#" id="our_company_id#currentrow#" style="width:140px;">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfloop query="company_name">
										<option value="#comp_id#" <cfif comp_id eq our_company_id_>selected</cfif>>#nick_name#</option>
									</cfloop>
								</select>
							</div>
                        <cfelse>
							<div class="form-group">
								<select name="our_company_id#currentrow#" id="our_company_id#currentrow#" style="width:140px;" disabled>
									<cfloop query="get_all_company">
										<option value="#comp_id#" <cfif comp_id eq our_company_id_>selected</cfif>>#nick_name#</option>
									</cfloop>	
								</select>
							</div>
                        </cfif>
                    </td>
                    <td>
						<div class="form-group">
							<select name="get_role#currentrow#" id="get_role#currentrow#" style="width:110px;" <cfif is_authorized eq 0>disabled</cfif>>
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
								<input type="hidden" name="partner_id#currentrow#" id="partner_id#currentrow#" value="#partner_id#">
								<input type="hidden" name="position_code#currentrow#" id="position_code#currentrow#" value="#position_code#">
								<input type="text" name="emp_par_name#currentrow#" id="emp_par_name#currentrow#" value="<cfif len(position_code)>#get_emp_info(position_code,1,0)#<cfelse>#get_par_info(partner_id,0,-1,0)#</cfif>" readonly="yes" style="width:160px;" <cfif is_authorized eq 0>disabled</cfif>>
								<cfif is_authorized eq 0>
									<span class="input-group-addon icon-ellipsis" title="<cf_get_lang dictionary_id='57785.Uye Secmelisiniz'>"></span>
								<cfelse>
									<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac1(#currentrow#);" title="<cf_get_lang dictionary_id='57785.Uye Secmelisiniz'>"></span>
								</cfif>
							</div>
						</div>
                    </td>
                    <td><input type="checkbox" name="is_master#currentrow#" id="is_master#currentrow#"  style="width:30px;" value="" <cfif is_master eq 1>checked</cfif> <cfif is_authorized eq 0>disabled</cfif>></td>
                </tr>
            </cfoutput>
        </cfif>
        </tbody>
    </cf_grid_list>
    <cf_box_footer>
		<cfif get_update_emp.recordcount gt 0>
            <cf_record_info query_name="get_update_emp">
        </cfif>
		<cfif get_workgroup.recordcount>
            <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
        <cfelse>
            <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
        </cfif>
    </cf_box_footer>
	</cfform>
</cf_box>


<script type="text/javascript">
	var is_master = new Array();
	<cfoutput query="company_name">
		is_master[#comp_id#] = 0;
	</cfoutput>
	function is_master_sifirla()
	{
		<cfoutput query="company_name">
			is_master[#comp_id#] = 0;
		</cfoutput>
	}
	row_count=<cfoutput>#get_workgroup.recordcount#</cfoutput>;
	function kontrol()
	{
		if(document.getElementById('record_number').value > 0)
		{
			for(r=1;r<=document.getElementById('record_number').value;r++)
			{
				if(eval("document.getElementById('authorized"+r+"')").value == 1)
				{
					if(eval("document.getElementById('row_kontrol"+r+"')").value == 1)
					{
						if(eval("document.getElementById('our_company_id"+r+"')").value == "")
						{
							alert("<cf_get_lang dictionary_id ='43432.Lütfen Şirket Seçiniz'>!");
							is_master_sifirla();
							return false;
						}
						if(eval("document.getElementById('is_master"+r+"')").checked == true)
						{
							var x = eval("document.getElementById('our_company_id"+r+"')").value;
							is_master[x] = is_master[x] + 1;
						}
	
						var get_master_control = wrk_query('SELECT COUNT(IS_MASTER) COUNT_MASTER FROM WORKGROUP_EMP_PAR WHERE OUR_COMPANY_ID = '+ eval("document.getElementById('our_company_id"+r+"')").value +' AND <cfoutput><cfif Len(attributes.company_id)>COMPANY_ID = #attributes.company_id#<cfelse>CONSUMER_ID = #attributes.consumer_id#</cfif></cfoutput> AND IS_MASTER = 1','dsn');
						if((is_master[x] > 1) || (get_master_control.recordcount && get_master_control.COUNT_MASTER > 1 && eval("document.getElementById('is_master"+r+"')").checked == true))
						{
							alert("<cf_get_lang dictionary_id ='30579.Aynı Şirket İçin Tek Master Alan Seçilebilir'>!");
							is_master_sifirla();
							return false;
						}
						
						if(eval("document.getElementById('position_code"+r+"')").value == "" && eval("document.getElementById('partner_id"+r+"')").value == "")
						{
							alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='57658.Üye'>!");
							is_master_sifirla();
							return false;
						}
						
						if(eval("document.getElementById('partner_id"+r+"')").value != "" && eval("document.getElementById('is_master"+r+"')").checked == true)
						{
							alert("<cf_get_lang dictionary_id ='30581.Sadece Çalışan Üye Master Olarak Seçiebilir'>!");
							eval("document.getElementById('is_master"+r+"')").checked == false;
							is_master_sifirla();
							return false;
						}
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
		
		document.getElementById('record_number').value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onClick="sil(' + row_count + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ='57463.sil'>"></i></a>';							
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><input type="hidden" name="authorized'+ row_count +'"id="authorized'+ row_count +'" value="1"><input type="hidden" name="wrk_row_id'+ row_count +'" id="wrk_row_id'+ row_count +'" value=""><select name="our_company_id'+ row_count +'" id="our_company_id'+ row_count +'" style="width:140px;"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="company_name"><option value="#comp_id#" <cfif comp_id eq session.ep.company_id>selected</cfif>>#nick_name#</option></cfoutput></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="get_role'+ row_count +'" id="get_role'+ row_count +'" style="width:110px;"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_rol"><option value="#project_roles_id#">#project_roles#</option></cfoutput></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="partner_id'+ row_count +'" id="partner_id'+ row_count +'" value=""><input type="hidden" name="position_code'+ row_count +'" id="position_code'+ row_count +'" value=""><input type="text" name="emp_par_name'+ row_count +'" id="emp_par_name'+ row_count +'" value="" readonly="yes" style="width:160px;">&nbsp;<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac1('+ row_count +');" alt="<cf_get_lang dictionary_id='57785.Uye Secmelisiniz'>"></span></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="checkbox" name="is_master'+ row_count +'" id="is_master'+ row_count +'" style="width:30px;" value="">';
	}
	
	function sil(sy)
	{
		var my_element=eval("worker.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		$("#record_number").val(row_count);
	}
	
	function pencere_ac1(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=worker.position_code'+ no +'&field_name=worker.emp_par_name'+ no +'&field_partner=worker.partner_id' + no + '&select_list=1,7');
	}
</script>
