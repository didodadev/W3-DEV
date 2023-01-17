
<cfset get_project_detail = createObject('component','V16.project.cfc.get_project_detail')>

<cfset get_project_workgroup = get_project_detail.GET_PROJECT_WORKGROUP(project_id : attributes.project_id)>
<cfset get_project_head = get_project_detail.GET_PROJECT_HEAD(project_id : attributes.project_id)>
<cfif len(get_project_workgroup.WORKGROUP_ID)>
    <cfset GET_EMPS = get_project_detail.GET_EMPS(WORKGROUP_ID : get_project_workgroup.WORKGROUP_ID)>
<cfelse>
    <cfset GET_EMPS.recordcount = 0>
</cfif>
<cfset work_group_row = GET_EMPS.recordcount>
<cfset GET_ROLES = get_project_detail.GET_ROLES()>
<cfset GET_MONEY = get_project_detail.GET_MONEY()>

<cfsavecontent variable="header_"><cf_get_lang dictionary_id ='38227.Proje Grubu'>:<cfoutput>#get_project_head.PROJECT_HEAD#</cfoutput></cfsavecontent>


<!--- calisanlar --->
    <cfform name="add_workgroup"  method="post">
        <cfif isdefined("attributes.PROJECT_ID")>
            <input type="hidden" name="WORKGROUP_ID" id="WORKGROUP_ID" value="<cfif get_project_workgroup.recordcount><cfoutput>#get_project_workgroup.workgroup_id#</cfoutput></cfif>">
            <input type="hidden" name="project_head" id="project_head" value="<cfoutput>#get_project_head.PROJECT_HEAD#</cfoutput>">
            <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.PROJECT_ID")><cfoutput>#attributes.PROJECT_ID#</cfoutput></cfif>">
            <input type="hidden" name="is_project_team_price" id="is_project_team_price" value="<cfif isdefined("is_project_team_price")><cfoutput>#is_project_team_price#</cfoutput></cfif>">
        <cfelseif isDefined("attributes.action_id") and isDefined("attributes.action_field")>
            <input type="hidden" name="WORKGROUP_ID" id="WORKGROUP_ID" value="<cfif get_action_workgroup.recordcount><cfoutput>#get_action_workgroup.workgroup_id#</cfoutput></cfif>">
            <input type="hidden" name="action_field" id="action_field" value="<cfoutput>#attributes.action_field#</cfoutput>">
            <input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.action_id#</cfoutput>">
        </cfif>
        <div class="row ui-scroll" >
            <table>
                <thead>
                    <tr>
                        <th width="20" class="font-weight-bold"><a href="javascript://" onClick="add_row_team();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></th>
                        <th class="font-weight-bold"><cf_get_lang dictionary_id ='58585.Kod'>*</th>
                        <th class="font-weight-bold"><cf_get_lang dictionary_id ='57569.Görevli'> </th>
                        <th class="font-weight-bold"><cf_get_lang dictionary_id ='38182.Rol'></th>
                        <cfif isdefined('is_project_team_price') and (is_project_team_price eq 1)>
                            <th class="font-weight-bold"><cf_get_lang dictionary_id ='38408.Hizmet/Ürün'> </th>
                            <th class="font-weight-bold"><cf_get_lang dictionary_id ='57636.Birim'></th>
                            <th class="font-weight-bold"><cf_get_lang dictionary_id ='57638.Birim Fiyat'></th>
                            <th class="font-weight-bold"><cf_get_lang dictionary_id ='57489.Para Birimi'></th>
                        </cfif>
                        <th class="font-weight-bold"><cf_get_lang dictionary_id='57491.Saat'>/<cf_get_lang dictionary_id='55123.Ücret'></th>
                    </tr>
                </thead>
                <tbody name="table1_workgroup" id="table1_workgroup">
                    <cfif ((isDefined("get_project_workgroup") and get_project_workgroup.recordcount) OR (isDefined("get_action_workgroup") AND get_action_workgroup.recordcount)) and GET_EMPS.recordcount>
                        <cfoutput query="GET_EMPS">
                            <cfset this_role_id = role_id>
                            <tr id="workgroup_row#currentrow#">
                                <td><input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
                                    <a href="javascript://" onclick="remove_workgroup(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='57463.Sil'>"></i></a>
                                </td>
                                <td>
                                    <div class="form-group"> 
                                        <input type="text" name="code#currentrow#" id="code#currentrow#" value="#hierarchy#" class="form-control">
                                    </div>
                                </td>
                                <td nowrap="nowrap">
                                    <div class="form-group"> 
                                        <div class="input-group">
                                            <cfif len(EMPLOYEE_ID)>
                                                <input type="text" name="member_name#currentrow#" id="member_name#currentrow#" value="#get_emp_info(EMPLOYEE_ID,0,0)#" class="form-control">
                                                <input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="employee">
                                            <cfelseif len(CONSUMER_ID)>
                                                <input type="text" name="member_name#currentrow#" id="member_name#currentrow#" value="#get_cons_info(CONSUMER_ID,1,0)#" class="form-control">
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
                                                <input type="text" name="member_name#currentrow#" id="member_name#currentrow#" value="#member_name_#" class="form-control">
                                                <input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="partner">
                                            <cfelse>
                                                <input type="text" name="member_name#currentrow#" id="member_name#currentrow#" value="">
                                                <input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="" class="form-control">
                                            </cfif>
                                                <input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="#employee_id#">
                                                <input type="hidden" name="consumer_id#currentrow#" id="consumer_id#currentrow#" value="#consumer_id#">
                                                <input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#company_id#">
                                                <input type="hidden" name="partner_id#currentrow#" id="partner_id#currentrow#" value="#partner_id#">
                                            <div class="input-group-append">
                                                <span class="input-group-text btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac1(#currentrow#);"></span>
                                            </div>
                                        </div>
                                    </div>	
                                </td>
                                <td>
                                    <div class="form-group"> 
                                        <select name="role_id#currentrow#" id="role_id#currentrow#" class="form-control">
                                        <option value=""><cf_get_lang dictionary_id ='38216.Rol Seçiniz'></option>
                                            <cfif get_roles.recordcount>
                                            <cfloop query="get_roles">
                                                <option value="#get_roles.PROJECT_ROLES_ID#" <cfif this_role_id eq get_roles.PROJECT_ROLES_ID>selected</cfif>>#get_roles.PROJECT_ROLES#</option>
                                            </cfloop>
                                            </cfif>
                                        </select>
                                    </div>
                                </td>
                                <cfif isdefined('is_project_team_price') and  is_project_team_price eq 1>
                                    <td>
                                        <cfif len(product_id)>
                                            <div class="form-group"> 
                                                <div class="input-group">
                                                    <input type="text" value="#get_product_name(product_id)#" name="product#currentrow#" id="product#currentrow#" >
                                                    <input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#">
                                                    <input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">&nbsp;<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_product(#currentrow#);"></span>
                                                </div>
                                            </div>
                                        <cfelse>
                                            <div class="form-group"> 
                                                <div class="input-group">
                                                    <input type="text" value="" name="product#currentrow#" id="product#currentrow#" >
                                                    <input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#">
                                                    <input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">&nbsp;<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_product(#currentrow#);"></span>
                                                </div>
                                            </div>
                                        </cfif>
                                    </td>
                                    <td><input type="text" name="unit_name#currentrow#" id="unit_name#currentrow#" value="#PRODUCT_UNIT#" readonly></td>
                                    <td><input type="text" name="price#currentrow#" id="price#currentrow#" value="#TLFormat(product_unit_price)#"  onkeyup="return(FormatCurrency(this,event));" class="moneybox"></td>
                                    <td><select name="money_type#currentrow#" id="money_type#currentrow#">
                                            <cfloop query="get_money">
                                                <option value="#get_money.money#" <cfif get_money.money eq GET_EMPS.PRODUCT_MONEY>selected</cfif>>#get_money.money#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                <cfelse>
                                    <cfif len(product_id)>
                                        <input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#">
                                        <input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
                                    <cfelse>
                                        <input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#">
                                        <input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
                                    </cfif>
                                    <input type="hidden" name="unit_name#currentrow#" id="unit_name#currentrow#" value="#PRODUCT_UNIT#" readonly>
                                    <input type="hidden" name="price#currentrow#" id="price#currentrow#" value="#TLFormat(product_unit_price)#"  onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                                    <input type="hidden" name="money_type#currentrow#" id="money_type#currentrow#" value="#GET_EMPS.PRODUCT_MONEY#">
                                </cfif>
                                <td>
                                    <div class="form-group"> 
                                        <input type="text" class="form-control" name="per_hour_salary#currentrow#" id="per_hour_salary#currentrow#" value="#TLFormat(per_hour_salary,2)#" onkeyup="return(FormatCurrency(this,event));"  class="moneybox">
                                    </div>
                                </td>
                            </tr>
                        </cfoutput>
                    </cfif>
                <tbody>
            </table>
        </div>
        <div class="draggable-footer">
            <input type="hidden" name="record" id="record" value="<cfoutput>#work_group_row#</cfoutput>">
            <cfif ((isDefined("get_project_workgroup") and get_project_workgroup.recordcount) OR (isDefined("get_action_workgroup") AND get_action_workgroup.recordcount))>
                <cf_workcube_buttons is_insert="0" data_action="/V16/project/cfc/get_work:add_work_team" next_page="/projectDetail?id=" after_function="kontrol" >
            <cfelse>
                <cf_workcube_buttons is_insert="1" data_action="/V16/project/cfc/get_work:add_work_team" next_page="/projectDetail?id=" after_function="kontrol" >
            </cfif>	
        </div>
    </cfform>
<!--- calisanlar --->
<script type="text/javascript">
	row_count=<cfoutput>#work_group_row#</cfoutput>;
	function add_row_team(code)
	{
		if(code == undefined) code ="";
		row_count++;
		var newRow;
		var newCell;
		
		document.add_workgroup.record.value=row_count;

		newRow = document.getElementById("table1_workgroup").insertRow(document.getElementById("table1_workgroup").rows.length);
		newRow.setAttribute("name","workgroup_row" + row_count);
		newRow.setAttribute("id","workgroup_row" + row_count);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count + '"><a  href="javascript://" onclick="remove_workgroup(' + row_count + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ="57463.Sil">" title="<cf_get_lang dictionary_id ="57463.Sil">"></i></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"> <input type="text" name="code'+ row_count +'" value="'+code+'" class="form-control"></div>';
				
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" class="form-control" name="member_name'+ row_count +'" value="" readonly="yes" ><input type="hidden" name="consumer_id'+ row_count +'" value=""><input type="hidden" name="company_id'+ row_count +'" value=""><input type="hidden" name="partner_id'+ row_count +'" value=""><input type="hidden" name="member_type'+ row_count +'" value=""><input type="hidden" name="employee_id'+ row_count +'" value=""><div class="input-group-append"><span class="input-group-text btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac1('+ row_count +');"></span></div></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"> <select name="role_id'+ row_count +'"  class="form-control"><option value=""><cf_get_lang dictionary_id ="38216.Rol Seçiniz"></option><cfoutput query="get_roles"><option value="#get_roles.PROJECT_ROLES_ID#">#PROJECT_ROLES#</option></cfoutput></select></div>';
		
		<cfif isdefined('is_project_team_price') and is_project_team_price eq 1>
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" value="" class="form-control" name="product' + row_count +'" ><input type="hidden" name="stock_id' + row_count +'"><input type="hidden" name="product_id' + row_count +'">&nbsp;<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_product(' + row_count + ');"></span></div></div>';
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="unit_name' + row_count +'" value="" readonly class="form-control">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="price' + row_count +'" value="" onkeyup="return(FormatCurrency(this,event));" class="form-control" >';
					
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="money_type' + row_count +'" class="form-control"><cfoutput query="get_money"><option value="#get_money.money#">#get_money.money#</option></cfoutput></select>';
		
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"> <input type="text" class="moneybox form-control"  name="per_hour_salary'+ row_count +'" id="per_hour_salary'+ row_count +'" value="" onkeyup="return(FormatCurrency(this,event));" ></div>';
	}
	function pencere_ac1(no)
	{
        openBoxDraggable('widgetloader?widget_load=listPos&isbox=1&draggable=1&field_consumer=add_workgroup.consumer_id'+no+'&field_comp_id=add_workgroup.company_id'+no+'&field_partner=add_workgroup.partner_id'+no+'&field_name=add_workgroup.member_name'+no+'&field_emp_id=add_workgroup.employee_id'+no+'&field_type=add_workgroup.member_type'+no+'&select_list=1,2,3');
	}

	function pencere_ac_product(no)
	{
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_price_unit&field_stock_id=add_workgroup.stock_id'+ no +'&field_id=add_workgroup.product_id'+ no +'&field_name=add_workgroup.product'+ no +'&field_unit=add_workgroup.unit_name'+ no+'&field_price=add_workgroup.price'+ no+'&field_money=add_workgroup.money_type'+ no +''</cfoutput>);
	}
		function remove_workgroup(no)
		{
			var my_element=eval("add_workgroup.row_kontrol"+no);		
			my_element.value=0;
			
			var my_element=document.getElementById("workgroup_row"+no);
			my_element.style.display="none";
		}

	function kontrol()
	{
	    if(row_count==0)
		{
			alert("<cf_get_lang dictionary_id ='38410.En Az Bir Grup Çalışan Kaydı Giriniz'>!");
			return false;
		}
        $(".moneybox").each(function(){
            $(this).val(filterNum($(this).val()))
        });
		for(row_=1;row_<=row_count;row_++)
		{
			if(eval("document.add_workgroup.row_kontrol"+row_).value == 1)
			{
				_member_name=eval("document.add_workgroup.member_name"+row_);
				_code_ = eval("document.add_workgroup.code"+row_);
				<cfif isdefined('is_project_team_price') and is_project_team_price eq 1>
					_product=eval("document.add_workgroup.product"+row_);
				</cfif>
				
				_role_id=eval("document.add_workgroup.role_id"+row_);
					
				if(_member_name.value=="")
				{
					alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='57569.Görevli'>");
					return false;
				}
				if(_code_.value == ""){
					alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='58585.Kod'>	");
					return false;
				}
				<cfif isdefined('is_required_project_roles') and is_required_project_roles eq 1>
					if(_role_id.value == "")
					{
						alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='38182.Rol'>");
						return false;
					}
				</cfif>
				<cfif isdefined('is_project_team_price') and (is_project_team_price eq 1)>
					if(_product.value=="" && eval("document.add_workgroup.member_type"+row_).value == 'employee')
					{
						alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='38408.Hizmet Ürün'>");
						return false;
					}
				</cfif>
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
