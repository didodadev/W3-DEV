<div class="col col-12 col-md-12 col-sm-12 col-xs-12 ">
<cf_box title="#getLang('assetcare',661)# #getLang('main',170)#" popup_box="1">
	<cfform name="add_inventory_zimmet" action="#request.self#?fuseaction=assetcare.emptypopup_add_inventory_zimmet" method="post" >
		<cf_box_elements>
			<div class="col col-6 col-md-4 col-sm-12 col-xs-12 " type="column" index="1" sort="true">
				<div class="form-group" id="item-employee_name">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='158.Ad Soyad'></label>  
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
						<input type="hidden" name="position_code" id="position_code" value="">
						<input type="hidden" name="employee_id" id="employee_id" value="">
						<cfsavecontent variable="message1"><cf_get_lang no='606.Zimmet Alan Girmelisiniz'> !</cfsavecontent>
						<cfinput name="employee_name" id="employee_name" type="text" readonly required="yes" message="#message1#" style="width:150px;">
						<span class="input-group-addon btnPointer icon-ellipsis"onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_inventory_zimmet.employee_id&field_emp_name=add_inventory_zimmet.employee_name&field_code=add_inventory_zimmet.position_code&call_function=bilgi_al()');return false"></span>
					</div>
				</div>
			</div>
			<div class="form-group" id="item-process">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no="70.Aşama"></label>  
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cf_workcube_process is_upd='0' process_cat_width='150'  is_detail='0'> 
					</div>
				</div>
				<div class="form-group" id="item-employee">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='662.Teslim Eden'>*</label>  
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
						<input type="hidden" name="given_emp_id" id="given_emp_id" value="">
						<cfsavecontent variable="message"><cf_get_lang no='662.Teslim Eden'><cf_get_lang_main no='201.Girmelisiniz'> !</cfsavecontent>
						<cfinput name="given_emp_name" id="given_emp_name" type="text" readonly="yes" required="yes" message="#message#" style="width:150px;">
						<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_inventory_zimmet.given_emp_id&field_emp_name=add_inventory_zimmet.given_emp_name');"></span>
					</div>
				</div>
			</div>
			<div class="form-group" id="item-company_id">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='162.Şirket'></label>  
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfquery name="get_our_comp" datasource="#DSN#">
							SELECT NICK_NAME, COMP_ID FROM OUR_COMPANY
						</cfquery>
						<select name="company_id" id="company_id" style="width:150px;">
							<cfoutput query="get_our_comp">
								<option value="#COMP_ID#">#NICK_NAME#</option>
							</cfoutput>
						</select>
						<input type="hidden" name="record_num" id="record_num" value="0">
					</div>
				</div>
			</div>
		</cf_box_elements>	
		<cf_grid_list> 
			<thead>
				<tr>
					<th colspan="5"><cf_get_lang_main no='1190.Demirbaş'></th>
				</tr>
				<tr>
					<th width="15"><input type="button" class="eklebuton" title="<cf_get_lang_main no='170.Ekle'>" width="15" height="15" border="0" onClick="add_row();"></th> 
					<th width="100"><cf_get_lang_main no='519.Cins'></th>
					<th width="100"><cf_get_lang_main no='75.No'></th>
					<th width="100"><cf_get_lang_main no='220.Özellikler'></th>
					<th><cf_get_lang_main no='330.Tarih'></th>
				</tr>
			</thead>
			<tbody name="table1" id="table1"></tbody>
		</cf_grid_list>
	
		<cf_box_footer><cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'></cf_box_footer>
	</cfform>
</cf_box>
</div>

<script language="JavaScript">
	row_count=0;
	function sil(sy)
	{
		var my_element=eval("add_inventory_zimmet.row_kontrol"+sy);
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
		document.add_inventory_zimmet.record_num.value=row_count;
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);	
		newCell = newRow.insertCell(newRow.cells.length);	
		newCell.innerHTML = '<a style="cursor:hand" onclick="sil('+ row_count +');"><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" value="1" id="row_kontrol' + row_count +'" name="row_kontrol' + row_count +'" ><input type="text" name="device_name' + row_count + '" style="width:100px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="inventory_no_' + row_count + '"style="width:100px;"><input  type="hidden" name="asset_id_' + row_count +'" value="0">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="property_' + row_count + '"style="width:200px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","tarih" + row_count + "_td");
		newCell.innerHTML = '<input type="text" name="tarih' + row_count +'" id="tarih' + row_count +'" class="text" maxlength="10" value="">&nbsp;';
		wrk_date_image('tarih' + row_count);
	}
	function kontrol()
	{
		record_exist=0;
		for(r=1;r<=add_inventory_zimmet.record_num.value;r++)
		{
			deger_row_kontrol = eval("document.add_inventory_zimmet.row_kontrol"+r);
			if(deger_row_kontrol.value == 1)
			{
				record_exist=1;
			}
		}
		if (record_exist == 0) 
		{
			alert("<cf_get_lang no='607.Lütfen Satır Ekleyiniz' >!");
			return false;
		}
		for(i=1;i<=document.add_inventory_zimmet.record_num.value;i++)
		{
			if(document.getElementById('tarih'+i).value == '' && document.getElementById('row_kontrol'+i).value == 1)
			{
				alert('<cf_get_lang_main no="1096.Satır">: '+i+' <cf_get_lang_main no="531.Tarih Giriniz">!');	
				return false;
			}	
		}
		return true;	
	}
	function bilgi_al()
	{
		for(var i=1;i<=row_count;i++)
		{
			var my_element=eval("add_inventory_zimmet.row_kontrol"+i);
			my_element.value=0;
			var my_element=eval("frm_row"+i);
			my_element.style.display="none";	
		}
		
		var get_emp_asset = wrk_safe_query('ascr_get_emp_asset','dsn',0,document.add_inventory_zimmet.position_code.value);
		for(var j=0;j<get_emp_asset.recordcount;j++)
		{
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			document.add_inventory_zimmet.record_num.value=row_count;
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);
			newCell = newRow.insertCell(newRow.cells.length);	
			newCell.innerHTML = '<a style="cursor:hand" onclick="sil('+ row_count +');"><img  src="images/delete_list.gif" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden" value="1" id="row_kontrol' + row_count +'"  name="row_kontrol' + row_count +'"><input  type="hidden" name="asset_id_' + row_count +'" value="'+get_emp_asset.ASSETP_ID[j]+'"><input type="text" name="device_name' + row_count + '"style="width:100px;" value="'+get_emp_asset.ASSETP[j]+'">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="inventory_no_' + row_count + '"style="width:100px;" value="'+get_emp_asset.ASSETP_ID[j]+'">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="property_' + row_count + '"style="width:100px;" value="'+get_emp_asset.ASSETP_CAT[j]+'">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","tarih" + row_count + "_td");
			newCell.innerHTML = '<input type="text" name="tarih' + row_count +'" id="tarih' + row_count +'" class="text" maxlength="10" style="width:100px;" value="">&nbsp;';
			wrk_date_image('tarih' + row_count);
			//newCell = newRow.insertCell(newRow.cells.length);
//			newCell.setAttribute("id","tarih" + row_count + "_td");
//			newCell.innerHTML = '<input type="text" name="tarih' + row_count +'" class="text" maxlength="10" style="width:100px;" value="">';
//			wrk_date_image('tarih' + row_count);
		}
	}
</script>
