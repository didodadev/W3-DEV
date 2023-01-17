<cf_xml_page_edit fuseact="hr.popup_add_inventory_zimmet">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_inventory_zimmet" action="#request.self#?fuseaction=hr.emptypopup_add_inventory_zimmet" method="post">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
					<div class="form-group" id="item-employee">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57570.Ad Soyadı'> *</label>
						<div class="col col-9 col-xs-12">
							<div class="input-group">
								<input type="hidden" id="employee_id" name="employee_id" value="">
								<input name="employee_name" id="employee_name"  style="width:150px;" type="text" readonly>
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_inventory_zimmet.employee_id&field_emp_name=add_inventory_zimmet.employee_name','list');return false"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57482.Aşama"></label>
						<div class="col col-9 col-xs-12"><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'></div>
					</div>
					<div class="form-group" id="item-company">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'> *</label>
						<div class="col col-9 col-xs-12">
							<cfquery name="get_our_comp" datasource="#DSN#">
								SELECT NICK_NAME, COMP_ID FROM OUR_COMPANY
								WHERE
                                COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = #session.ep.position_code#)
							</cfquery>
							<select name="company_id" id="company_id" style="width:150px;">
								<cfoutput query="get_our_comp">
									<option value="#COMP_ID#">#NICK_NAME#</option>
								</cfoutput>
							</select>
							<input type="hidden" id="record_num" name="record_num" value="0">
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cfsavecontent variable="head"><cf_get_lang dictionary_id='30004.Fiziki Varlıklar'></cfsavecontent>
				<cf_seperator id="sep1" header="#head#">
					<div id="sep1" class="col-12">
			<cf_grid_list>
				<thead>
					<tr>
						<th width="15"><a href="javascript://"  onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang_main no='170.Ekle'>" alt="<cf_get_lang_main no='170.Ekle'>"></i></a></th> 
						<th width="100"><cf_get_lang dictionary_id='57931.Cins'></th>
						<th width="100"><cf_get_lang dictionary_id='57487.No'></th>
						<th width="100"><cf_get_lang dictionary_id='57632.Özellikler'></th>
						<th width="120"><cf_get_lang dictionary_id='57742.Tarih'></th>
						<th width="175"><cf_get_lang dictionary_id="33211.Teslim Eden"></th>
							<cfif x_use_pam eq 1>
						<th width="175"><cf_get_lang dictionary_id='48445.İlişkili Fiziki Varlık'></th>
						</cfif>
					</tr>
				</thead>
				<tbody id="table1"></tbody>
			</cf_grid_list>
		</div>
			<cf_box_footer>
				<div class="col col-12">
					<cf_workcube_buttons is_upd='0' add_function="kontrol()">
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
row_count=0;
function sil(sy)
{
	var my_element=eval("add_inventory_zimmet.row_kontrol"+sy);
	my_element.value=0;
	//var my_element=eval("frm_row"+sy);
	//my_element.style.display="none";	
	var my_elementx = document.getElementById('frm_row' + sy);
	my_elementx.parentNode.removeChild(my_elementx);
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
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil('+ row_count +');"><i class="fa fa-minus" border="0"></i></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden" value="1"  name="row_kontrol' + row_count +'" ><input type="text" name="device_name' + row_count + '">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="inventory_no_' + row_count + '">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="property_' + row_count + '">';
	newCell = newRow.insertCell(newRow.cells.length);
	
	newCell.setAttribute("id","tarih_" + row_count + "_td");
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="tarih' + row_count +'" id="tarih' + row_count +'" class="text" maxlength="10"  value=""><span class="input-group-addon" id="tarih'+row_count + '_td'+'"></span></div></div>';
	wrk_date_image('tarih' + row_count);
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML =	'<div class="form-group"><div class="input-group"><input type="hidden" name="given_id_' + row_count +'" id="given_id_' + row_count +'"><input type="text" id="given_name_' + row_count  +'" name="given_name_' + row_count  +'" style="width:130px;"> <span class="input-group-addon btnPointer icon-ellipsis no-bg" onClick="opage('+ row_count +');"></span><input type="hidden" name="is_active_' + row_count +'"></div></div>';
<cfif x_use_pam eq 1>
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="input-group"><input type="hidden"  id="relation_asset_id' + row_count + '" name="relation_asset_id' + row_count + '">'+
	'<input type="text" name="relation_asset' + row_count + '" id="relation_asset' + row_count + '" onfocus="'+"AutoComplete_Create('relation_asset" + row_count + "','ASSETP','ASSETP','get_assetp_autocomplete','','ASSETP_ID,ASSETP','relation_asset_id" + row_count + ",relation_asset" + row_count + "','','3','135');"+'">'+
	'<span class="input-group-addon icon-ellipsis btn" onclick="'+"openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=add_inventory_zimmet.relation_asset_id" + row_count + "&field_name=add_inventory_zimmet.relation_asset" + row_count + "&event_id=0&motorized_vehicle=0');"+'"></span></div>';
</cfif>
}
function opage(deger)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_inventory_zimmet.given_id_' + deger + '&field_emp_name=add_inventory_zimmet.given_name_' + deger,'list');
}


 function kontrol()
{
	if(row_count == 0)
	{
		alert("<cf_get_lang dictionary_id='48478.Lütfen Satır Ekleyiniz'>");
		return false;
	}
	var hata_list = '';
	if(row_count>0)
	{
	   if(document.getElementById('employee_id').value == '')
	   {
		  alert("<cf_get_lang dictionary_id='43281.Çalışan Seçmelisiniz'>"); 
		  return false;
		}
		var satir=0;
		for(var i=1; i<=row_count; i++)
		{	
			if(document.getElementById('frm_row'+i)!=undefined && document.getElementById('frm_row'+i)!=null)	
			{
				satir=satir+1;
				given_name = document.getElementById('given_name_'+i).value;
				given_id = document.getElementById('given_id_'+i).value;
				if(given_name == '' || given_id == '')
				{
					if(hata_list!='') 
						hata_list = hata_list+','+satir;
					else 
						hata_list = satir;
				}
			}
		}
		var satir=0;
		for(var i=1; i<=row_count; i++)
		{	
			if(document.getElementById('frm_row'+i)!=undefined && document.getElementById('frm_row'+i)!=null)	
			{	satir=satir+1;	
				date_kontrol = document.getElementById('tarih'+i).value;
				if(date_kontrol == '')
				{
					alert("<cf_get_lang dictionary_id='38380.Tarih Girmediniz!'> <cf_get_lang dictionary_id='58230.Satır No'>:" +satir);
					return false;
				}
			}
		}
	}
	if(hata_list!='')
	{
		alert("<cf_get_lang dictionary_id='38461.Teslim Eden Girmelisiniz!'> <cf_get_lang dictionary_id='58230.Satır No'>:" +hata_list);
		return false;
	}
	return true;
}
</script>
