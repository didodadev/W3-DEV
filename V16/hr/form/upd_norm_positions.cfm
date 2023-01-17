<cfinclude template="../query/get_setup_moneys.cfm">
<cfquery name="get_norm" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		EMPLOYEE_NORM_POSITIONS 
	WHERE 
		BRANCH_ID=#BRANCH_ID#	
	AND
		NORM_YEAR=#attributes.NORM_YEAR#
</cfquery>
<cfinclude template="../query/get_norm_branches.cfm">
<cfsavecontent variable="txt"><cfoutput>#get_branches.NICK_NAME#\#get_branches.BRANCH_NAME#</cfoutput></cfsavecontent>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box  scroll="1" collapsable="0" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform name="upd_norm" action="#request.self#?fuseaction=hr.emptypopup_upd_norm_positions" method="post">
	<cf_box_elements>
    <div class="col col-12 uniqueRow">
        <div class="row formContent">
            <div class="row" type="row">
                <div class="col col-12 scrollContent scroll-x5">
                    <cf_grid_list class="workDevList">
                    	<thead>
							<tr>
								<th width="15" valign="bottom"><input type="button" ><a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
								<th width="80" nowrap="nowrap" valign="bottom"><cf_get_lang dictionary_id='57572.Departman'></th>
								<th width="80" nowrap="nowrap" valign="bottom"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
								<th valign="bottom"><cf_get_lang dictionary_id='55843.Ort Maaş'></th>
								<th valign="bottom"><cf_get_lang dictionary_id='55842.Para'></th>
								<input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_norm.recordcount#</cfoutput>">
								<input name="branch_id" id="branch_id" type="hidden" value="<cfoutput>#attributes.branch_id#</cfoutput>">
								<input name="norm_year" id="norm_year" type="hidden" value="<cfoutput>#attributes.norm_year#</cfoutput>">
								<cfloop from="1" to="12" index="i">
								<th style="text-align:right;" nowrap="nowrap"><span style="float:left; writing-mode:tb-rl; width:30px; height:55px;"><cfoutput>#ListGetAt(ay_list(),i,",")#</cfoutput></span></th>
								</cfloop>
							</tr>
						</thead>
    					<tbody id="table1">
							<cfoutput query="get_norm">
								<cfset dept_id_ = DEPARTMENT_ID>
								<tr id="frm_row#currentrow#" >
									<td><a style="cursor:pointer" onclick="sil(#currentrow#);" ><img  src="images/delete_list.gif" border="0" title="<cf_get_lang dictionary_id='57463.Sil'>"></a></td>
									<td nowrap="nowrap">
										<cfif len(dept_id_)>
											<cfquery name="get_dep_name" datasource="#DSN#">
												SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #dept_id_#
											</cfquery>
										</cfif>
                                        <div class="input-group ">
											<input type="hidden" value="#DEPARTMENT_ID#" name="department_id#currentrow#" id="department_id#currentrow#">
							                <input type="text"  value="<cfif len(dept_id_)>#get_dep_name.DEPARTMENT_HEAD#</cfif>"  name="department_name#currentrow#" id="department_name#currentrow#">
	                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac(#currentrow#);"></span>
                                        </div>
									</td>
									<td nowrap="nowrap">
										<cfquery name="get_pos_cat" datasource="#DSN#">
											SELECT POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID=#POSITION_CAT_ID#
										</cfquery>
                                        <div class="input-group ">
											<input  type="hidden" value="1"  name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
							                <input type="hidden" value="#POSITION_CAT_ID#" name="position_cat_id#currentrow#" id="position_cat_id#currentrow#">
							                <input type="text" value="#get_pos_cat.POSITION_CAT#" name="position_cat#currentrow#" id="position_cat#currentrow#">
	                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_pos(#currentrow#);"></span>
                                        </div>
									</td>
									<td width="100" nowrap="nowrap"><input type="text" name="salary#currentrow#" id="salary#currentrow#" class="moneybox"  onkeyup="return(FormatCurrency(this,event));"  value="#TLFormat(AVERAGE_SALARY)#" style="width:95px;"></td>
									<td><cfset money_selected=get_norm.MONEY>
										<select name="MONEY#currentrow#" id="MONEY#currentrow#">
											<cfloop query="get_moneys">
												<option value="#get_moneys.MONEY#" <cfif get_moneys.money eq money_selected >selected</cfif>>#get_moneys.money#</option>
											</cfloop>
										</select>
									</td>
									<cfloop from="0" to="11" index="i">
									<td width="25"><input type="text" onkeyup="isNumber(this);" onblur="isNumber(this);" name="count_#currentrow#_#i#" id="count_#currentrow#_#i#"  value="#evaluate("EMPLOYEE_COUNT#evaluate(i+1)#")#" style="width:44px; text-align:right;" maxlength="4"></td>
									</cfloop>
								</tr>
							</cfoutput>
							</tbody>
						</cf_grid_list>
				</div>
			</div>
      
		</div>
</cf_box_elements>
<cf_box_footer>
	<cf_workcube_buttons is_upd='1' type_format="1" is_delete='0' add_function="UnformatFields() && kontrol_et()">
</cf_box_footer>

</cfform>
</cf_box>
</div>

<script type="text/javascript">
	row_count=<cfoutput>#get_norm.recordcount#</cfoutput>;
	function sil(sy)
	{
		var my_element=eval("document.getElementById('row_kontrol" + sy + "')");
		my_element.value=0;

		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
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
					
		document.getElementById('record_num').value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0"></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group x-15"><input  type="hidden" value="1" name="row_kontrol' + row_count +'" ><input  type="hidden"  name="department_id' + row_count +'" id="department_id' + row_count +'" ><input type="text" name="department_name' + row_count + '" id="department_name' + row_count + '"> <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac(' + row_count + ');"> </div> ';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group x-15"><input  type="hidden" name="position_cat_id' + row_count +'" id="position_cat_id' + row_count +'" ><input type="text" name="position_cat' + row_count + '" id="position_cat' + row_count + '"> <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_pos(' + row_count + ');"> </div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="salary' + row_count + '" id="salary' + row_count + '" onkeyup="return(FormatCurrency(this,event));" class="moneybox">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="MONEY' + row_count + '" id="MONEY' + row_count + '"><cfoutput query="get_moneys"><option value="#MONEY#" <cfif get_moneys.MONEY eq session.ep.money>selected</cfif>>#money#</option></cfoutput></select>';
					
		for(k=0;k<=11;k++)
		{
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text"  onKeyPress="isNumber(this);" name="count_'+ row_count + '_' +  k + '" style="width:44px; text-align:right;" maxlength="4">';
		}
	}		

	function pencere_ac(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_departments&field_id=upd_norm.department_id' + no + '&field_name=upd_norm.department_name' + no + '&branch_id=' + <cfoutput>#attributes.branch_id#</cfoutput>);	
	}
	
	function pencere_pos(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_cats&field_cat_id=upd_norm.position_cat_id' + no + '&field_cat=upd_norm.position_cat' + no);
	}
	
	function UnformatFields()
	{
		for(yerel_i=1;yerel_i<=row_count;yerel_i++)
		{
			try{
				var str_me=eval("document.getElementById('salary" + yerel_i + "')");
				if(str_me != null)
				str_me.value = filterNum(str_me.value);
			}
			catch(e){}		
		}
	}
	
	function kontrol_et()
	{
		if(row_count ==0)
			return false;
			
		UnformatFields();
		return true;
	}
	
</script>