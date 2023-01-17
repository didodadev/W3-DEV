<cfscript>
	gdpr_comp = new addons.devonomy.gdpr.cfc.data_officer_committee(data_officer_id:attributes.data_officer_id);
	get_commitee = gdpr_comp.get_data_officer_commitee();
	if (get_commitee.recordcount) {
		row_count=get_commitee.recordcount;
	}
	else {
		row_count=0;
	}
</cfscript>
<cfquery name="GET_ROLES" datasource="#dsn#">
	SELECT * FROM SETUP_PROJECT_ROLES ORDER BY PROJECT_ROLES
</cfquery>
<cfsavecontent variable="header_"><cf_get_lang dictionary_id='61749.Veri Sorumlusu'>: <cf_get_lang dictionary_id='31744.Kurul'></cfsavecontent>
<cfparam name="attributes.modal_id" default="">
<!--- calisanlar --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#header_#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_workgroup" action="AddOns/devonomy/gdpr/cfc/data_officer_committee.cfc?method=add_data_officer_commitee&data_officer_id=#attributes.data_officer_id#" method="post">
			<input type="hidden" name="data_officer_id" id="data_officer_id" value="<cfoutput>#attributes.data_officer_id#</cfoutput>">
			<cf_grid_list>
				<thead>
					<tr>
						<th width="20"><a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></th>
						<th><cf_get_lang dictionary_id ='57569.Görevli'> </th>
						<th><cf_get_lang dictionary_id ='38182.Rol'></th>
					</tr>
				</thead>
				<tbody name="table1_workgroup" id="table1_workgroup">
						<cfoutput query="get_commitee">
							<cfset this_role_id = role_id>
							<tr id="frm_row#currentrow#">
								<td><input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
									<a onclick="sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='57463.Sil'>"></i></a>
								</td>
								 <td nowrap="nowrap">
									<div class="form-group"> 
										<div class="input-group">
											<cfif len(EMPLOYEE_ID)>
												<input type="text" name="member_name#currentrow#" id="member_name#currentrow#" value="#get_emp_info(EMPLOYEE_ID,0,0)#">
												<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="employee">
											<cfelseif len(CONSUMER_ID)>
												<input type="text" name="member_name#currentrow#" id="member_name#currentrow#" value="#get_cons_info(CONSUMER_ID,1,0)#">
												<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="consumer">
											<cfelseif len(PARTNER_ID)>
												<cfquery name="get_comp_partner" datasource="#dsn#">
													SELECT 
														COMPANY_PARTNER_NAME,
														COMPANY_PARTNER_SURNAME,
														NICKNAME
													FROM
														COMPANY,
														COMPANY_PARTNER
													WHERE
														COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
														COMPANY_PARTNER.PARTNER_ID = #PARTNER_ID#
												</cfquery>
												<cfset member_name_ = '#get_comp_partner.COMPANY_PARTNER_NAME# #get_comp_partner.COMPANY_PARTNER_SURNAME#-#get_comp_partner.NICKNAME#'>
												<input type="text" name="member_name#currentrow#" id="member_name#currentrow#" value="#member_name_#">
												<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="partner">
											<cfelse>
												<input type="text" name="member_name#currentrow#" id="member_name#currentrow#" value="">
												<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="">
											</cfif>
												<input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="#employee_id#">
												<input type="hidden" name="consumer_id#currentrow#" id="consumer_id#currentrow#" value="#consumer_id#">
												<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#company_id#">
												<input type="hidden" name="partner_id#currentrow#" id="partner_id#currentrow#" value="#partner_id#">
											<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac1(#currentrow#);"></span>
										</div>
									</div>	
								</td>
								<td>
									<div class="form-group"> 
										<select name="role_id#currentrow#" id="role_id#currentrow#" >
										<option value=""><cf_get_lang dictionary_id ='38216.Rol Seçiniz'></option>
											<cfif get_roles.recordcount>
											<cfloop query="get_roles">
												<option value="#get_roles.PROJECT_ROLES_ID#" <cfif this_role_id eq get_roles.PROJECT_ROLES_ID>selected</cfif>>#get_roles.PROJECT_ROLES#</option>
											</cfloop>
											</cfif>
										</select>
									</div>
								</td>
							</tr>
						</cfoutput>
				<tbody>
			</cf_grid_list>
			<input type="hidden" name="record" id="record" value="<cfoutput>#row_count#</cfoutput>">
			<cf_box_footer>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
					<cfif isdefined("get_commitee")>
						<cf_record_info query_name="get_commitee">
					</cfif>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<cf_workcube_buttons is_upd='0' is_delete='0' add_function="kontrol()">
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>	
</div>
<!--- calisanlar --->
<script type="text/javascript">
	var row_count = <cfoutput>#row_count#</cfoutput>;
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		
		document.add_workgroup.record.value=row_count;

		newRow = document.getElementById("table1_workgroup").insertRow(document.getElementById("table1_workgroup").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count + '"><a onclick="sil(' + row_count + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ="57463.Sil">" title="<cf_get_lang dictionary_id ="57463.Sil">"></i></a>';
				
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="member_name'+ row_count +'" value="" readonly="yes" ><input type="hidden" name="consumer_id'+ row_count +'" value=""><input type="hidden" name="company_id'+ row_count +'" value=""><input type="hidden" name="partner_id'+ row_count +'" value=""><input type="hidden" name="member_type'+ row_count +'" value=""><input type="hidden" name="employee_id'+ row_count +'" value=""><span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac1('+ row_count +');"></span></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"> <select name="role_id'+ row_count +'" ><option value=""><cf_get_lang dictionary_id ="38216.Rol Seçiniz"></option><cfoutput query="get_roles"><option value="#get_roles.PROJECT_ROLES_ID#">#PROJECT_ROLES#</option></cfoutput></select></div>';
	}
	function sil(no)
	{
		var my_element=eval("add_workgroup.row_kontrol"+no);		
		my_element.value=0;
		
		var my_element=eval("frm_row"+no);
		my_element.style.display="none";
	}
	function pencere_ac1(no)
	{
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&is_period_kontrol=0&field_consumer=add_workgroup.consumer_id'+no+'&field_comp_id=add_workgroup.company_id'+no+'&field_partner=add_workgroup.partner_id'+no+'&field_name=add_workgroup.member_name'+no+'&field_emp_id=add_workgroup.employee_id'+no+'&field_type=add_workgroup.member_type'+no+'&select_list=1,2,3'</cfoutput>);
	}
	function kontrol()
	{
	if(row_count==0)
		{
			alert("<cf_get_lang no ='290.En Az Bir Grup Çalışan Kaydı Giriniz'>!");
			return false;
		}
		for(row_=1;row_<=row_count;row_++)
		{
			if(eval("document.add_workgroup.row_kontrol"+row_).value == 1)
			{
				_member_name=eval("document.add_workgroup.member_name"+row_);
					
				if(_member_name.value=="")
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no ='157.Görevli'>");
					return false;
				}
				
			
			}
			for(ic_row_=1;ic_row_<=row_count;ic_row_++)
			{
				if(row_ != ic_row_){	
					if(eval("document.add_workgroup.code"+row_).value == eval("document.add_workgroup.code"+ic_row_).value){
						alert(eval("document.add_workgroup.code"+row_).value+' - '+eval("document.add_workgroup.code"+ic_row_).value+" <cf_get_lang dictionary_id = '58585.Kod'> <cf_get_lang dictionary_id = '58564.Var'>!");
						return false;
					}
				}
			}
		}
	}
</script>
