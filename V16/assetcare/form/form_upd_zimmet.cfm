<cfsetting showdebugoutput="yes">
<cfquery name="get_zimmet" datasource="#dsn#">
	SELECT 
	    ZIMMET_ID, 
        COMPANY_ID, 
        EMPLOYEE_ID, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP,
        PROCESS_STAGE
    FROM 
    	EMPLOYEES_INVENT_ZIMMET 
    WHERE 
    	ZIMMET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zimmet_id#">
</cfquery>
<cfquery name="get_employee_name" datasource="#dsn#">
	SELECT 
		EMPLOYEE_ID,
		EMPLOYEE_NAME,
		EMPLOYEE_NO,
		EMPLOYEE_SURNAME 
	FROM 
		EMPLOYEES		
	WHERE 
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_zimmet.employee_id#">
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box title="#getLang('assetcare',661)# :#attributes.ZIMMET_ID#" popup_box="1"  print_href="#request.self#?fuseaction=objects.popup_print_files&print_type=252&action_id=#attributes.zimmet_id#">
<cfform  name="upd_inventory_zimmet" action="#request.self#?fuseaction=assetcare.emptypopup_upd_inventory_zimmet" method="post">
	<cf_box_elements>
		<input type="hidden" name="position_code" id="position_code" value="">
		<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_zimmet.employee_id#</cfoutput>">
		<input type="hidden" name="zimmet_id" id="zimmet_id" value="<cfoutput>#attributes.zimmet_id#</cfoutput>">
				
		<div class="col col-6 col-md-4 col-sm-12 col-xs-12 " type="column" index="1" sort="true">
			<div class="form-group" id="item-employee_name">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='158.Ad Soyad'></label>  
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="input-group">
						<cfset attributes.employee_id = get_zimmet.employee_id>
						<input name="employee_name" id="employee_name"  value="<cfoutput>#get_employee_name.employee_name# #get_employee_name.employee_surname#</cfoutput>"type="text" readonly>
						<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_inventory_zimmet.employee_id&field_code=upd_inventory_zimmet.position_code&field_name=upd_inventory_zimmet.employee_name&select_list=1&call_function=bilgi_al()&branch_related')"></span>
					</div>
				</div>
			</div>
			<div class="form-group" id="item-process">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no="70.Aşama"></label>  
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cf_workcube_process is_upd='0' process_cat_width='150'  is_detail='1' select_value='#get_zimmet.process_stage#'>
				</div>
			</div>
			<div class="form-group" id="item-company_id">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='162.Şirket'></label>  
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfquery name="get_our_comp" datasource="#DSN#">
						SELECT NICK_NAME,COMP_ID FROM OUR_COMPANY
					</cfquery>
					<select name="company_id" id="company_id">
						<cfoutput query="get_our_comp">
							<option value="#COMP_ID#" <cfif get_zimmet.company_id eq COMP_ID >selected</cfif>>#NICK_NAME#</option>
						</cfoutput>
					</select>
				</div>
			</div>
		</div>
	</cf_box_elements>
		<cf_grid_list >
			<thead>
				<tr>
					<th colspan="6"><cf_get_lang_main no='1190.Demirbaş'></th>
				</tr>
				<tr>
					<th width="15" class="headbold"><input type="button" class="eklebuton" title="" onClick="add_row_();"></th>
					<th style="width:100px;"><cf_get_lang_main no='519.Cins'></th>
					<th style="width:55px;"><cf_get_lang_main no='75.No'></th>
					<th style="width:100px;"><cf_get_lang_main no='220.Özellikler'></th>
					<th><cf_get_lang_main no='330.Tarih'></th>
					<th style="width:150px;"><cf_get_lang no='662.Teslim Eden'></th>
				</tr>
			</thead>
			<tbody name="table1" id="table1">
				<cfquery name="get_zimmet_row" datasource="#dsn#">
					SELECT * FROM EMPLOYEES_INVENT_ZIMMET_ROWS WHERE ZIMMET_ID = #attributes.zimmet_id#
				</cfquery>
				<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_zimmet_row.recordcount#</cfoutput>">
				<cfoutput query="get_zimmet_row">
				<cfset i = currentrow>
				<tr id="frm_row#currentrow#">
					<td><input type="hidden" value="1" name="row_kontrol#i#" id="row_kontrol#i#"><a href="javascript://" onClick="sil(#i#);"><img src="images/delete_list.gif" alt="" border="0"></a></td>
					<td><input type="text" name="device_name#i#" id="device_name#i#" value="#DEVICE_NAME#" style="width:100px;"></td>
					<td><input type="text"  name="inventory_no_#i#" id="inventory_no_#i#"  value="#INVENTORY_NO#" style="width:55px;"></td>
					<td><input type="text"  name="property_#i#" id="property_#i#"  value="#PROPERTY#" style="width:100px;"></td>
						<input type="hidden"  name="asset_id_#i#" id="asset_id_#i#" value="#asset_id#">
					<td><cfinput  type="text" validate="#validate_style#" name="tarih#i#" id="tarih#i#" value="#dateformat(ZIMMET_DATE,dateformat_style)#" >
						<cf_wrk_date_image date_field="tarih#i#">
					</td>
					<td><cfinput  type="hidden"  name="given_id_#i#" value="#GIVEN_EMP_ID#">
						<cfset attributes.employee_id = GIVEN_EMP_ID>
						<cfinclude template="../query/get_employee_name.cfm">
						<cfinput type="text" name="given_name_#i#"  value="#get_employee_name.employee_name# #get_employee_name.employee_surname#"  required="yes" message="Teslim Eden Girmelisiniz!">
						<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_inventory_zimmet.given_id_#i#&field_name=upd_inventory_zimmet.given_name_#i#&select_list=1');return false"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
					</td>                       
				</tr>
				</cfoutput>
			</tbody>
		</cf_grid_list>
	
		<cf_box_footer>
			<cf_record_info query_name="get_zimmet">
			<cf_workcube_buttons is_upd='1' add_function="control()" del_function='control2()'>
		</cf_box_footer>
	</cfform>
</cf_box>
</div>
<script type="text/javascript">

	function control()
	{
		for(i=1;i<=document.upd_inventory_zimmet.record_num.value;i++)
		{
			if(document.getElementById('tarih'+i).value == '' && document.getElementById('row_kontrol'+i).value == 1)
			{
				alert('<cf_get_lang_main no="1096.Satır">: '+i+' <cf_get_lang_main no="531.Tarih Giriniz">!');	
				return false;
			}	
		}
	return process_cat_control();	
	}
	function control2()
	{
		if(document.getElementById('process_stage').value=='')
		{
			alert("<cf_get_lang_main no='1430.Süreç Seçiniz'>");
			return false;	
		} 
		else{
		upd_inventory_zimmet.action = "<cfoutput>#request.self#?fuseaction=assetcare.emptypopup_del_zimmet_rows&zimmet_id=#attributes.zimmet_id#</cfoutput>";
		upd_inventory_zimmet.submit();
		}
	}
	row_count=<cfoutput>#get_zimmet_row.recordcount#</cfoutput>;
	
	function sil(sy)
	{
		var my_element=eval("upd_inventory_zimmet.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";	
	}
	function add_row_()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		document.upd_inventory_zimmet.record_num.value=row_count;
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');	
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil('+ row_count +');"><img  src="images/delete_list.gif" alt="" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input  type="hidden" value="1" id="row_kontrol' + row_count +'"  name="row_kontrol' + row_count +'" ><input type="text" name="device_name' + row_count + '"style="width:100px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="inventory_no_' + row_count + '"style="width:55px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="property_' + row_count + '"style="width:100px;"><input  type="hidden" name="asset_id_' + row_count +'" value="0">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.setAttribute("id","tarih" + row_count + "_td");
		newCell.innerHTML = '<input type="text" name="tarih' + row_count +'" id="tarih' + row_count +'" class="text" maxlength="10"value="">';
		wrk_date_image('tarih' + row_count);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML =	'<input type="hidden" name="given_id_' + row_count +'"><input type="text" name="given_name_' + row_count  +'> <a href="javascript://" onClick="opage('+ row_count +');"><img src="/images/plus_thin.gif" alt="" align="absmiddle" border="0"></a><input type="hidden" name="is_active_' + row_count +'">';
	}
	function opage(deger)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_inventory_zimmet.given_id_' + deger + '&select_list=1&field_name=upd_inventory_zimmet.given_name_' + deger,'list');
	}
	function opage2(deger)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_inventory_zimmet.taken_id_' + deger + '&select_list=1&field_name=upd_inventory_zimmet.taken_name_' + deger,'list');
	}		

	function bilgi_al()
	{
		var get_emp_asset = wrk_safe_query('ascr_get_emp_asset','dsn',0,document.add_inventory_zimmet.position_code.value);
		for(var j=0;j<get_emp_asset.recordcount;j++)
		{
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			document.upd_inventory_zimmet.record_num.value=row_count;
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);
			newCell = newRow.insertCell();	
			newCell.innerHTML = '<a style="cursor:pointer" onclick="sil('+ row_count +');"><img  src="images/delete_list.gif" border="0" alt=""></a>';
			newCell = newRow.insertCell();
			newCell.innerHTML = '<input  type="hidden" value="1" id="row_kontrol' + row_count +'" name="row_kontrol' + row_count +'"><input  type="hidden" name="asset_id_' + row_count +'" value="'+get_emp_asset.ASSETP_ID[j]+'"><input type="text" name="device_name' + row_count + '"style="width:100px;" value="'+get_emp_asset.ASSETP[j]+'">';
			newCell = newRow.insertCell();
			newCell.innerHTML = '<input type="text" name="inventory_no_' + row_count + '"style="width:55PX;" value="'+get_emp_asset.ASSETP_ID[j]+'">';
			newCell = newRow.insertCell();
			newCell.innerHTML = '<input type="text" name="property_' + row_count + '"style="width:100px;" value="'+get_emp_asset.ASSETP_CAT[j]+'">';
			newCell = newRow.insertCell();
			newCell.setAttribute("id","tarih" + row_count + "_td");
			newCell.innerHTML = '<input type="text" name="tarih' + row_count +'" id="tarih' + row_count +'" class="text" maxlength="10"  value="">';
			wrk_date_image('tarih' + row_count);
			newCell = newRow.insertCell();
			newCell.innerHTML =	'<input type="hidden" name="given_id_' + row_count +'"><input type="text" name="given_name_' + row_count  +'" > <a href="javascript://" onClick="opage('+ row_count +');"><img src="/images/plus_thin.gif"  alt="" align="absmiddle" border="0"></a><input type="hidden" name="is_active_' + row_count +'">';
		}
	}
</script>
