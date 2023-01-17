<cfinclude template="../query/get_branchs_deps.cfm">
<cfinclude template="../query/get_usage_purpose.cfm">

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<form name="add_sales_request" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.emptypopup_add_vehicle_sales_request">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-branch_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57453.Şube'>*</label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="hidden" name="branch_id" id="branch_id" value="">
								<input type="text" name="branch" id="branch" value="" readonly>
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=add_sales_request.branch&field_branch_id=add_sales_request.branch_id');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
						<div class="col col-8 col-sm-12">
							<cf_workcube_process 
								is_upd='0' 
								process_cat_width='180' 
								is_detail='0'>
						</div>
					</div>
					<div class="form-group" id="item-employee_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='47953.Talep Eden'> *</label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="hidden" name="employee_id" id="employee_id" value="">
								<input type="text" name="employee" id="employee" value="" readonly="yes">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_sales_request.employee_id&field_name=add_sales_request.employee&select_list=1&branch_related</cfoutput>')"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-request_date">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='47994.Talep Tarihi'> *</label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="text" name="request_date" id="request_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="request_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-detail">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-sm-12">
							<textarea name="detail" id="detail" style="width:140px;height:70px;"></textarea>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_basket id="sales_request_bask">
				<cfinclude template="../form/add_sales_row.cfm">
			</cf_basket>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' is_reset='0' add_function='kontrol()'>
			</cf_box_footer>
		</form>
	</cf_box>
</div>
<script type="text/javascript">
row_count=0;
kontrol_row_count=0;
function sil(sy)
{
	var my_element=eval("document.add_sales_request.row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
	kontrol_row_count--;
}
function add_row()
{
	row_count++;
	kontrol_row_count++;	
	var newRow;
	var newCell;
	
	newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);		
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);		
				
	document.add_sales_request.record_num.value=row_count;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a href="javascript://" style="cursor:pointer" onClick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.sil'>" alt="<cf_get_lang dictionary_id='57463.sil'>"></i></a>';							
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" value="1"  name="row_kontrol' + row_count +'"><input type="hidden" name="assetp_id'+ row_count +'" value=""><input type="text" name="assetp'+ row_count+'" value="" readonly><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="plaka_ac(' + row_count + ');"></span></div></div>';
		
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input  type="hidden" name="brand_type_id'+ row_count +'" value=""><input type="text" name="brand_name'+ row_count +'" value="" readonly="yes"></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="make_year' + row_count +'"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")><cfoutput><cfloop from="#yil#" to="1970" index="i" step="-1"><option value="#i#">#i#</option></cfloop></cfoutput></select></div>';
				
}
function plaka_ac(no1)
{
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&is_active&field_id=add_sales_request.assetp_id'+ no1 +'&field_name=add_sales_request.assetp'+ no1 +'&field_brand_type_id=add_sales_request.brand_type_id'+ no1 +'&field_brand_name=add_sales_request.brand_name'+ no1 +'&field_make_year=add_sales_request.make_year'+ no1 +'&satinalma=1');
}		
function kontrol()
/* Zorunlu alan kontrolleri için yazılan scriptler... Onur 01112004*/
{
	if(document.add_sales_request.detail.value.length > 250)
	{
		alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='48082.en fazla 250 karakter'>!");
		return false;
	}
	if(document.add_sales_request.branch_id.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57453.Şube'>!");
		return false;
	}
	if(document.add_sales_request.employee.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='47953.Talep Eden'>!");
		return false;
	}
	if(!CheckEurodate(add_sales_request.request_date.value,'Talep Tarihi') || !add_sales_request.request_date.value.length) 
	{
		alert("<cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='47994.Talep Tarihi'>!");
		return false;
	}
	
	if(row_count == 0 || kontrol_row_count == 0)
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48094.En Az Bir Satır Talep Kaydı'>!");
		return false;
	}

	for(r=1;r<=add_sales_request.record_num.value;r++)
	{
		deger_row_kontrol = eval("document.add_sales_request.row_kontrol"+r);
		if(deger_row_kontrol.value == 1)
		{
			if(eval("document.add_sales_request.assetp"+r).value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29453.Plaka'>!");
				return false;
			}
		}
		eval("document.add_sales_request.make_year"+r).disabled = false
	}
	return process_cat_control();
}
</script>
