<cfquery name="Get_Our_Company" datasource="#dsn#">
	SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY WHERE COMP_STATUS = 1 ORDER BY COMPANY_NAME
</cfquery>
<cfquery name="Get_Standart_Departments" datasource="#dsn#">
	SELECT 
		POSITION_CODE, 
		OUR_COMPANY_ID, 
		BRANCH_ID, 
		DEPARTMENT_ID, 
		LOCATION_ID,
		RECORD_EMP, 
		RECORD_DATE, 
		RECORD_IP, 
		UPDATE_EMP, 
		UPDATE_DATE, 
		UPDATE_IP 
	FROM 
		EMPLOYEE_POSITION_DEPARTMENTS 
	WHERE 
		POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_position_detail.position_code#">
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cfform name="form_list" action="#request.self#?fuseaction=objects.emptypopup_employee_standart_departments" method="post">
	<cf_grid_list>
		<thead>
			<tr>
				<th colspan="5"><cf_get_lang dictionary_id='32469.Öncelikli Departman ve Lokasyon Yetkileri'></th>
			</tr>
		</thead>
		<input type="hidden" name="page_type" id="page_type" value="<cfif isdefined('attributes.type') and len(attributes.type)><cfoutput>#attributes.type#</cfoutput></cfif>">
		<input type="hidden" name="position_code" id="position_code" value="<cfoutput>#get_position_detail.position_code#</cfoutput>">
		<input type="hidden" name="position_id" id="position_id" value="<cfoutput>#attributes.position_id#</cfoutput>">
		<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
		<input type="hidden" name="from_sec" id="from_sec" value="<cfif isdefined('attributes.from_sec') and len(attributes.from_sec)>1<cfelse>0</cfif>">
		<input type="hidden" name="auth_emps_pos_codes" id="auth_emps_pos_codes" value="">
		<thead>
			<tr>
				<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='57574.Şirket'></th>
				<th width="200"><cf_get_lang dictionary_id='57453.Şube'></th>
				<th width="200"><cf_get_lang dictionary_id='57572.Departman'></th>
				<th width="200"><cf_get_lang dictionary_id='30031.Lokasyon'></th>
			</tr>
		</thead>
		<cfoutput query="Get_Our_Company">
			<cfset Branch_Name = "">
			<cfset Department_Name = "">
			<cfset Location_Name = "">
			<cfquery name="Get_Query" dbtype="query">
				SELECT * FROM Get_Standart_Departments WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Our_Company.Comp_Id#">
			</cfquery>
			<cfif Len(Get_Query.Branch_Id)>
				<cfquery name="Get_Branch" datasource="#dsn#">
					SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Query.Branch_Id#">
				</cfquery>
				<cfset Branch_Name = Get_Branch.Branch_Name>
				
				<cfif Len(Get_Query.Department_Id)>
					<cfquery name="Get_Department" datasource="#dsn#">
						SELECT DEPARTMENT_ID, DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Query.Department_Id#">
					</cfquery>
					<cfset Department_Name = Get_Department.Department_Head>
					
					<cfif Len(Get_Query.Location_Id)>
						<cfquery name="Get_Location" datasource="#dsn#">
							SELECT LOCATION_ID, COMMENT FROM STOCKS_LOCATION WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Query.Department_Id#"> AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Query.Location_Id#">
						</cfquery>
						<cfset Location_Name = Get_Location.Comment>
					</cfif>
				</cfif>
			</cfif>
			<tbody>
				<tr>
					<td>#CurrentRow#</td>
					<td>#Company_Name#</td>
					<td>
						<div class="form-group">
							<div class="input-group">
								<input type="hidden" name="branch_id_#comp_id#" id="branch_id_#comp_id#" value="#Get_Query.Branch_Id#">
								<input type="text" name="branch_name_#comp_id#" id="branch_name_#comp_id#" value="#Branch_Name#">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_branch(#comp_id#);"></span>
							</div>
						</div>
						
					</td>
					<td>
						<div class="form-group">
							<div class="input-group">
								<input type="hidden" name="department_id_#comp_id#" id="department_id_#comp_id#" value="#Get_Query.Department_Id#">
								<input type="text" name="department_name_#comp_id#" id="department_name_#comp_id#" value="#Department_Name#">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_department(#comp_id#);"></span>
							</div>
						</div>
					</td>
					<td>
						<div class="form-group">
							<div class="input-group">
								<input type="hidden" name="location_id_#comp_id#" id="location_id_#comp_id#" value="#Get_Query.Location_Id#">
								<input type="text" name="location_name_#comp_id#" id="location_name_#comp_id#" value="#Location_Name#">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_location(#comp_id#);"></span>
							</div>
						</div>
					</td>
				</tr>
			</tbody>
		</cfoutput>
	</cf_grid_list>
	<cf_box_footer>
		<cf_record_info query_name="Get_Standart_Departments">
		<cf_workcube_buttons is_upd="0" add_function="control()">
	</cf_box_footer>
</cfform>
<script language="javascript" type="text/javascript">
	function pencere_ac_branch(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_related_branches&branch_id=form_list.branch_id_'+no+'&branch_name=form_list.branch_name_'+no+'&search_our_company_id='+no);
		return false;
	}
	
	function pencere_ac_department(no)
	{
		if(document.getElementById("branch_id_"+no).value == "" || document.getElementById("branch_name_"+no).value == "")
		{
			alert("<cf_get_lang dictionary_id='32456.Departman Seçimi İçin Önce Şube Seçmelisiniz'>!");
			return false;
		}
		else
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=form_list.department_id_'+no+'&field_name=form_list.department_name_'+no+'&search_branch_id='+document.getElementById("branch_id_"+no).value);
	}
	
	function pencere_ac_location(no)
	{
		if(document.getElementById("department_id_"+no).value == "" || document.getElementById("department_name_"+no).value == "")
		{
			alert("<cf_get_lang dictionary_id='32464.Lokasyon Seçimi İçin Önce Departman Seçmelisiniz'>!");
			return false;
		}
		else
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stores_locations&form_name=form_list&system_company_id='+no+'&field_location=location_name_'+no+'&field_location_id=location_id_'+no+'&department_id_value='+document.getElementById("department_id_"+no).value);
	}
	function control() 
	{
		get_auth_emps(0,0,1);
		<cfif isdefined("attributes.draggable")>
			loadPopupBox('form_list' , <cfoutput>#attributes.modal_id#</cfoutput>)
		</cfif>
	}
</script>

