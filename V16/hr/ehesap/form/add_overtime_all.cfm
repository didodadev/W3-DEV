<cfquery name="ALL_BRANCHES" datasource="#DSN#">
	SELECT 
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID,
		D.DEPARTMENT_HEAD,
		D.DEPARTMENT_ID
	FROM
		BRANCH,
		DEPARTMENT D
	WHERE
		D.BRANCH_ID = BRANCH.BRANCH_ID AND
		BRANCH.SSK_NO IS NOT NULL AND
		BRANCH.SSK_OFFICE IS NOT NULL AND
		BRANCH.SSK_BRANCH IS NOT NULL AND
		BRANCH.SSK_NO IS NOT NULL AND
		BRANCH.SSK_OFFICE IS NOT NULL AND
		BRANCH.SSK_BRANCH IS NOT NULL
	<cfif not session.ep.ehesap>
		AND BRANCH.BRANCH_ID IN 
		(
            SELECT
                BRANCH_ID
            FROM
                EMPLOYEE_POSITION_BRANCHES
            WHERE
                POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
		)
	</cfif>
	ORDER BY
		BRANCH.BRANCH_NAME
</cfquery>
<cfif isdefined("attributes.department_id")>
	<cfquery name="get_department_positions" datasource="#DSN#">
		SELECT
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			E.EMPLOYEE_ID,
			EIO.IN_OUT_ID,
			D.DEPARTMENT_HEAD,
			B.BRANCH_NAME
		FROM
			<cfif isdefined("attributes.collar_type") and len(attributes.collar_type)>
			EMPLOYEE_POSITIONS EP,
			</cfif>
			EMPLOYEES_IN_OUT EIO,
			EMPLOYEES E,
			DEPARTMENT D,
			BRANCH B
		WHERE
			<cfif isdefined("attributes.collar_type") and len(attributes.collar_type)>
			EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
			EP.IS_MASTER = 1 AND
			EP.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#"> AND
			</cfif>
			E.EMPLOYEE_ID=EIO.EMPLOYEE_ID AND
			D.DEPARTMENT_ID=EIO.DEPARTMENT_ID AND
			D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> AND
			D.BRANCH_ID=B.BRANCH_ID AND
			EIO.FINISH_DATE IS NULL
		ORDER BY
			E.EMPLOYEE_NAME
	</cfquery>
</cfif>
<cfif isdefined("attributes.branch_id") and isdefined("attributes.startdate") and isdefined("attributes.finishdate")>
	<cf_date tarih="attributes.startdate">
	<cf_date tarih="attributes.finishdate">
	<cfquery name="get_department_positions" datasource="#DSN#">
		SELECT
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			E.EMPLOYEE_ID,
			EIO.IN_OUT_ID,
			D.DEPARTMENT_HEAD,
			B.BRANCH_NAME
		FROM
			EMPLOYEES_IN_OUT EIO,
			EMPLOYEES E,
			DEPARTMENT D,
			BRANCH B
		WHERE
			E.EMPLOYEE_ID=EIO.EMPLOYEE_ID AND
			D.DEPARTMENT_ID=EIO.DEPARTMENT_ID AND
			D.BRANCH_ID = #attributes.branch_id# AND
			D.BRANCH_ID=B.BRANCH_ID AND
			EIO.START_DATE <= #attributes.finishdate# AND
			(EIO.FINISH_DATE >= #attributes.startdate# OR EIO.FINISH_DATE IS NULL)
		ORDER BY
			E.EMPLOYEE_NAME
	</cfquery>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('ehesap','Fazla Mesai Toplu Giriş',53596)#">
		<cfform name="add_worktime" action="#request.self#?fuseaction=ehesap.emptypopup_add_overtime_all" method="post">
			<input name="record_num" id="record_num" type="hidden" value="1">
			<cf_grid_list id="link_table">
				<thead>
					<tr>
						<th width="20"></th>
						<th colspan="2"><cf_get_lang dictionary_id='53597.Şube ve Departman'></th>
						<th colspan="6">
							<div class="form-group">
								<div class="col col-6 col-xs-12">
									<select name="department_id" id="department_id" onchange="if (this.options[this.selectedIndex].value != 'null') { window.open(this.options[this.selectedIndex].value+'&collar_type='+document.add_worktime.collar_type.value,'_self')}">
										<option value="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_add_overtime_all"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfoutput query="ALL_BRANCHES">
											<option value="#request.self#?fuseaction=ehesap.popup_add_overtime_all&department_id=#department_id#"<cfif isdefined("attributes.department_id") and (department_id eq attributes.department_id)> selected</cfif>>#BRANCH_NAME# - #department_head#</option>
										</cfoutput>
									</select>
								</div>
								<div class="col col-6 col-xs-12">
									<select name="collar_type" id="collar_type">
										<option value=""><cf_get_lang dictionary_id ='56063.Yaka Tipi'></option>
											<option value="1" <cfif isdefined("attributes.collar_type") and attributes.collar_type eq 1> selected</cfif>><cf_get_lang dictionary_id ='56065.Mavi Yaka'></option> 
											<option value="2" <cfif isdefined("attributes.collar_type") and attributes.collar_type eq 2> selected</cfif>><cf_get_lang dictionary_id ='56066.Beyaz Yaka'></option>
									</select> 
								</div>
							</div>
						</th>
					</tr>
					<tr>
						<cfoutput>
							<th width="20"></th>
							<th colspan="2" ><cf_get_lang dictionary_id='55886.Toplu Ekleme'>
								<input  type="hidden" value="1" name="row_kontrol_0" id="row_kontrol_0">						
							</th>
							<th width="140">
								<div class="form-group">
									<select name="term0" id="term0" onChange="hepsi(row_count,'term');">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="j">
											<option value="#j#">#j#</option>
										</cfloop>
									</select>
								</div>
							</th>
							<th width="140">
								<div class="form-group">
									<select name="start_mon0" id="start_mon0" onChange="hepsi(row_count,'start_mon');">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop from="1" to="12" index="j">
											<option value="#j#">#listgetat(ay_list(),j,',')#</option>
										</cfloop>
									</select>
								</div>
							</th>
							<th width="80"><div class="form-group"><cfinput type="text" name="overtime_value0_0" id="overtime_value0_0" class="moneybox" value="0" onKeyup="if (FormatCurrency(this,event)) {return true;} else {upd_0(); return false;}"></div></th>
							<th width="80"><div class="form-group"><cfinput type="text" name="overtime_value1_0" id="overtime_value1_0" class="moneybox" value="0" onKeyup="if (FormatCurrency(this,event)) {return true;} else {upd_1(); return false;}"></div></th>
							<th width="80"><div class="form-group"><cfinput type="text" name="overtime_value2_0" id="overtime_value2_0" class="moneybox" value="0" onKeyup="if (FormatCurrency(this,event)) {return true;} else {upd_2(); return false;}"></div></th>
							<th width="80"><div class="form-group"><cfinput type="text" name="overtime_value3_0" id="overtime_value3_0" class="moneybox" value="0" onKeyup="if (FormatCurrency(this,event)) {return true;} else {upd_3(); return false;}"></div></th>                
						</cfoutput>
					</tr>
					<tr>
						<th width="20"><a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
						<th width="250"><cf_get_lang dictionary_id='57576.Çalışan'></th>
						<th width="250"><cf_get_lang dictionary_id='57453.Şube'>/<cf_get_lang dictionary_id='57572.Departman'></th>
						<th width="140"><cf_get_lang dictionary_id='58472.Dönem'></th>
						<th width="140"><cf_get_lang dictionary_id='58724.Ay'></th>
						<th width="80"><cf_get_lang dictionary_id='55715.Normal Gün'></th>
						<th width="80"><cf_get_lang dictionary_id='56021.Hafta Sonu'></th>
						<th width="80"><cf_get_lang dictionary_id='56022.Resmi Tatil'></th>
						<th width="80"><cf_get_lang dictionary_id='54251.Gece Çalışması'></th>
					</tr>
				</thead>
				<tbody>
					<cfif isdefined("get_department_positions") and (get_department_positions.recordcount)>
						<cfoutput query="get_department_positions">
						<tr id="my_row_#currentrow#">
							<td><a onclick="sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
							<td width="140">
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="#employee_id#">
										<input type="hidden" name="employee_in_out_id#currentrow#" id="employee_in_out_id#currentrow#" value="#in_out_id#">
										<input name="employee#currentrow#" id="employee#currentrow#" type="text" value="#employee_name# #employee_surname#" onFocus="AutoComplete_Create('employee#currentrow#','FULLNAME','FULLNAME,BRANCH_NAME','get_in_outs_autocomplete','','EMPLOYEE_ID,IN_OUT_ID,BRANS_NAME_DEP_HEAD','employee_id#currentrow#,employee_in_out_id#currentrow#,department#currentrow#','add_worktime','3','225');">
										<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=add_worktime.employee_in_out_id#currentrow#&field_emp_name=add_worktime.employee#currentrow#&field_emp_id=add_worktime.employee_id#currentrow#&field_branch_and_dep=add_worktime.department#currentrow#');"></span>
									</div>
								</div>
							</td>
							<td><input name="department#currentrow#" id="department#currentrow#" type="text" readonly value="#branch_name# / #department_head#"></td>
							<td>
								<input type="hidden"  value="1"  name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#">
								<select name="term#currentrow#" id="term#currentrow#">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="j">
									<option value="#j#">#j#</option>
								</cfloop>
								</select>
							</td>
							<td>
								<select name="start_mon#currentrow#" id="start_mon#currentrow#">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfloop from="1" to="12" index="j">
										<option value="#j#">#listgetat(ay_list(),j,',')#</option>
									</cfloop>
								</select>
							</td>
							<td><input type="text" name="overtime_value_0_#currentrow#" id="overtime_value_0_#currentrow#" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));"></td>
							<td><input type="text" name="overtime_value_1_#currentrow#" id="overtime_value_1_#currentrow#" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));"></td>
							<td><input type="text" name="overtime_value_2_#currentrow#" id="overtime_value_2_#currentrow#" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));"></td>
							<td><input type="text" name="overtime_value_3_#currentrow#" id="overtime_value_3_#currentrow#" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));"></td>                
						</tr>
						</cfoutput>
					<cfelse>
						<cfoutput>
							<tr id="my_row_1">
								<td><a onclick="sil(1);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
								<td width="140">
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="employee_id1" id="employee_id1" value="">
											<input type="hidden" name="employee_in_out_id1" id="employee_in_out_id1" value="">
											<input name="employee1" type="text" id="employee1" onFocus="AutoComplete_Create('employee1','FULLNAME','FULLNAME,BRANCH_NAME','get_in_outs_autocomplete','','EMPLOYEE_ID,IN_OUT_ID,BRANS_NAME_DEP_HEAD','employee_id1,employee_in_out_id1,department1','add_worktime','3','225');">
											<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=add_worktime.employee_in_out_id1&field_emp_name=add_worktime.employee1&field_emp_id=add_worktime.employee_id1&field_branch_and_dep=add_worktime.department1');"></span>
										</div>
									</div>
								</td>
								<td>
									<div class="form-group">
										<input name="department1" id="department1" type="text" readonly value="">
									</div>
								</td>
								<td>
									<div class="form-group">
										<input  type="hidden" value="1" name="row_kontrol_1" id="row_kontrol_1">		
										<select name="term1" id="term1">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="j">
												<option value="#j#">#j#</option>
											</cfloop>
										</select>
									</div>
								</td>
								<td>
									<div class="form-group">
										<select name="start_mon1" id="start_mon1">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfloop from="1" to="12" index="j">
												<option value="#j#">#listgetat(ay_list(),j,',')#</option>
											</cfloop>
										</select>
									</div>
								</td>
								<td><div class="form-group"><input type="text" name="overtime_value_0_1" id="overtime_value_0_1" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));"></div></td>
								<td><div class="form-group"><input type="text" name="overtime_value_1_1" id="overtime_value_1_1" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));"></div></td>
								<td><div class="form-group"><input type="text" name="overtime_value_2_1" id="overtime_value_2_1" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));"></div></td>
								<td><div class="form-group"><input type="text" name="overtime_value_3_1" id="overtime_value_3_1" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));"></div></td>                
							</tr>
						</cfoutput>
					</cfif>
				</tbody>
			</cf_grid_list>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	<cfif isdefined("get_department_positions") and get_department_positions.recordcount>
		row_count=<cfoutput>#get_department_positions.recordcount#</cfoutput>;
	<cfelse>
		row_count=1;
	</cfif>
	function hepsi(satir,nesne)
	{
		deger=eval("document.add_worktime."+nesne+"0");
		
		for(var i=1;i<=satir;i++)
		{
			nesne_tarih=eval("document.add_worktime."+nesne+i);
			nesne_tarih.value=deger.value;
		}
	}
	function upd_0()
	{	
		deger = eval("document.add_worktime.overtime_value0_0");	
		for(var i=1;i<=row_count;i++)
		{
			nesne_=eval("document.add_worktime.overtime_value_0_"+i);
			nesne_.value=deger.value;
		}
	}
	function upd_1()
	{	
		deger = eval("document.add_worktime.overtime_value1_0");	
		for(var i=1;i<=row_count;i++)
		{
			nesne_=eval("document.add_worktime.overtime_value_1_"+i);
			nesne_.value=deger.value;
		}
	}
	function upd_2()
	{	
		deger = eval("document.add_worktime.overtime_value2_0");	
		for(var i=1;i<=row_count;i++)
		{
			nesne_=eval("document.add_worktime.overtime_value_2_"+i);
			nesne_.value=deger.value;
		}
	}
	function upd_3()
	{	
		deger = eval("document.add_worktime.overtime_value3_0");	
		for(var i=1;i<=row_count;i++)
		{
			nesne_=eval("document.add_worktime.overtime_value_3_"+i);
			nesne_.value=deger.value;
		}
	}

	function sil(sy)
	{
		var my_element=eval("add_worktime.row_kontrol_"+sy);
		my_element.value=0;
		var my_element=eval("my_row_"+sy);
		my_element.style.display="none";
	}
	
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;		
		document.add_worktime.record_num.value=row_count;
		newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);	
		newRow.setAttribute("name","my_row_" + row_count);
		newRow.setAttribute("id","my_row_" + row_count);		
		newRow.setAttribute("NAME","my_row_" + row_count);
		newRow.setAttribute("ID","my_row_" + row_count);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';	
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" value="" name="row_kontrol_' + row_count +'"><input type="hidden" value="" name="employee_id' + row_count +'">';
		newCell.innerHTML += '<div class="form-group"><div class="input-group"><input type="hidden" value="" name="employee_in_out_id' + row_count +'"><input type="text" name="employee' + row_count +'" id="employee' + row_count +'" value="" onFocus="AutoComplete_Create(\'employee\' + row_count,\'FULLNAME\',\'FULLNAME,BRANCH_NAME\',\'get_in_outs_autocomplete\',\'\',\'EMPLOYEE_ID,IN_OUT_ID,BRANS_NAME_DEP_HEAD\',\'employee_id\' + row_count + \',employee_in_out_id\' + row_count + \',department\' + row_count,\'add_worktime\',\'3\',\'225\');"><span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable(\'<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_in_out</cfoutput>&field_in_out_id=add_worktime.employee_in_out_id'+ row_count + '&field_emp_name=add_worktime.employee'+ row_count + '&field_emp_id=add_worktime.employee_id'+ row_count + '&field_branch_and_dep=add_worktime.department'+ row_count + '\');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input name="department'+row_count+'" type="text" readonly value=""></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><cfoutput><select name="term'+row_count+'" id="term'+row_count+'"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="j"><option value="#j#">#j#</option></cfloop></select></cfoutput></div>'; 
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><cfoutput><select name="start_mon'+row_count+'" id="start_mon'+row_count+'"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><cfloop from="1" to="12" index="j"><option value="#j#">#listgetat(ay_list(),j,',')#</option></cfloop></select></cfoutput></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="overtime_value_0_'+row_count+'" id="overtime_value_0_'+row_count+'" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="overtime_value_1_'+row_count+'" id="overtime_value_1_'+row_count+'" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="overtime_value_2_'+row_count+'" id="overtime_value_2_'+row_count+'" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="overtime_value_3_'+row_count+'" id="overtime_value_3_'+row_count+'" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));"></div>';
	}

	function kontrol()
	{
		document.add_worktime.record_num.value=row_count;
		if(row_count == 0)
		{
			alert("<cf_get_lang dictionary_id='53600.Fazla Mesai Girişi Yapmadınız'>!");
			return false;
		}
		recordnum = document.add_worktime.record_num.value;
		for(i =1;i <= recordnum; i++)
		{
			if(document.getElementById('row_kontrol_'+i).value != 0)
			{
				if (document.getElementById('term'+i).value == '' || document.getElementById('term'+i).value == 'undefined' || document.getElementById('start_mon'+i).value == '' || document.getElementById('start_mon'+i).value == 'undefined')
				{
					alert("<cf_get_lang dictionary_id='54566.Satırlardaki Dönem ve Ay Verilerini Kontrol Ediniz'> !");
					return false;
				}
			}
		}
	return true;
	}		
</script>
