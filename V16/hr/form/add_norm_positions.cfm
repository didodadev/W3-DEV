<cfinclude template="../query/get_setup_moneys.cfm">
<cfinclude template="../query/get_norm_branches.cfm">
<cfsavecontent variable="txt"><cf_get_lang dictionary_id='55846.Norm Kadro Planı'> : <cfoutput>#get_branches.NICK_NAME#\#get_branches.BRANCH_NAME#</cfoutput></cfsavecontent>
<cf_catalystHeader>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box  scroll="1" collapsable="0" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform  name="add_norm" action="#request.self#?fuseaction=hr.emptypopup_add_norm_positions" method="post">
		<cf_box_elements>

        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-12 scrollContent scroll-x5">
                    	<cf_grid_list class="workDevList">
						<thead>
							<tr>
								<th valign="bottom"><input type="button"><a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
								<th nowrap="nowrap" valign="bottom" ><cf_get_lang dictionary_id='57572.Departman'></th>
								<th nowrap="nowrap" valign="bottom" ><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
								<th valign="bottom"><cf_get_lang dictionary_id='55843.Ort Maaş'></th>
								<th valign="bottom"><cf_get_lang dictionary_id='55842.Para'></th>
								<input name="record_num" id="record_num" type="hidden" value="">
								<input name="branch_id" id="branch_id" type="hidden" value="<cfoutput>#attributes.branch_id#</cfoutput>">
								<input name="norm_year" id="norm_year" type="hidden" value="<cfoutput>#attributes.norm_year#</cfoutput>">
								<cfloop from="1" to="12" index="i">
									<th style="text-align:right;" nowrap="nowrap"><span style="float:left; writing-mode:tb-rl; width:30px; "><cfoutput>#ListGetAt(ay_list(),i,",")#</cfoutput></span></th>
								</cfloop>
							</tr>
						</thead>
						<tbody id="table1">
						</tbody>
					</cf_grid_list>
                    </div>
    			</div>

    		</div>
    	</div>
	</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' type_format="1" add_function="kontrol_et()">
		</cf_box_footer>
	</cfform>
</cf_box>
</div>

<script type="text/javascript">
	function set_other_salaries(satir)
	{
		ilk_deger_ = '0';
		for(yerel_i=0;yerel_i<=11;yerel_i++)
		{
			var deger_ = eval("document.add_norm.count_"+satir+"_"+yerel_i)
			if(deger_.value == '' && ilk_deger_ != '')
			{
				deger_.value = ilk_deger_;
			}		
			else
			{
				ilk_deger_ = deger_.value;
			}
		}
	}	
	row_count=0;

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
			newCell.innerHTML = '<a style="javascript://" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="input-group"><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" ><input type="hidden" id="department_id' + row_count +'"  name="department_id' + row_count +'" ><input type="text" id="department_name' + row_count + '" name="department_name' + row_count + '"><span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac(' + row_count + ');"></span> </div> ';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="input-group"><input  type="hidden" id="position_cat_id' + row_count +'" name="position_cat_id' + row_count +'" ><input type="text" id="position_cat' + row_count + '" name="position_cat' + row_count + '" class="boxtext"> <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_pos(' + row_count + ');"></span></div> ';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" id="salary' + row_count + '" name="salary' + row_count + '" onkeyup="return(FormatCurrency(this,event));" class="moneybox" >';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="MONEY' + row_count + '" id="MONEY' + row_count + '"><cfoutput query="get_moneys"><option value="#MONEY#" <cfif get_moneys.MONEY eq session.ep.money>selected</cfif>>#money#</option></cfoutput></select>';

			for(k=0;k<=11;k++)
			{
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input id="count_'+ row_count + '_' +  k + '" name="count_'+ row_count + '_' +  k + '" onkeyup="isNumber(this);" onblur="isNumber(this);set_other_salaries(row_count);" type="text" style="width:40px">';
			}
			
	}		

	function pencere_ac(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_departments&field_id=add_norm.department_id' + no + '&field_name=add_norm.department_name' + no + '&branch_id=' + <cfoutput>#attributes.branch_id#</cfoutput>);	
	}
	
	function pencere_pos(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_cats&field_cat_id=add_norm.position_cat_id' + no + '&field_cat=add_norm.position_cat' + no);
	}
	
	function sil(sy)
	{
		/*document.all.table1.deleteRow(sy);*/
		var my_element=eval("document.getElementById('row_kontrol" + sy + "')");
		my_element.value=0;

		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	
	
	function UnformatFields()
	{
		for(yerel_i=0;yerel_i<=row_count;yerel_i++)
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
