<cfinclude template="../query/get_branchs_deps.cfm">
<cfinclude template="../query/get_usage_purpose.cfm">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<form name="add_purchase_request" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.emptypopup_add_vehicle_purchase_request">
			<cf_basket_form id="purchase_request">
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-branch_id">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57453.Şube'> *</label>
							<div class="col col-8 col-sm-12">
								<div class="input-group">
									<input type="hidden" name="branch_id" id="branch_id" value="">
									<input type="text" name="branch" id="branch" value="" readonly>
									<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=add_purchase_request.branch&field_branch_id=add_purchase_request.branch_id');"></span>
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
									<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_purchase_request.employee_id&field_name=add_purchase_request.employee&select_list=1&branch_related</cfoutput>');"></span>
								</div>
							</div>                
						</div> 
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-request_date">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='47994.Talep Tarihi'> *</label>
							<div class="col col-8 col-sm-12">
								<div class="input-group">
									<input type="text" name="request_date" id="request_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>" maxlength="10"  required="yes">
									<span class="input-group-addon"><cf_wrk_date_image date_field="request_date"></span>
								</div>
							</div>                
						</div> 
						<div class="form-group" id="item-detail">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-sm-12">
								<textarea name="detail" id="detail" style="width:320px;height:70px;"></textarea>
							</div>                
						</div> 
					</div>
				</cf_box_elements>
			</cf_basket_form>
			<cf_basket id="purchase_request_bask">
				<cfinclude template="../form/add_purchase_row.cfm">
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
	var my_element=eval("add_purchase_request.row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
	kontrol_row_count++;
}
function pert()
{
	alert("<cf_get_lang dictionary_id='48455.Sadece Pertli Araçlar İçin Plaka Girişi Yapınız'>!");
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
				
	document.add_purchase_request.record_num.value=row_count;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onClick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.sil'>" alt="<cf_get_lang dictionary_id='57463.sil'>"></i></a>';							
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="hidden" value="1"  name="row_kontrol' + row_count +'"><select name="assetp_catid' + row_count +'"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_assetp_cats"><option value="#assetp_catid#">#assetp_cat#</option></cfoutput></select></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="usage_purpose_id' + row_count +'"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_usage_purpose"><option value="#usage_purpose_id#">#usage_purpose#</cfoutput></select></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="brand_type_id'+ row_count +'" value=""><input type="text" name="brand_name'+ row_count +'" value="" readonly="yes"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac('+ row_count +');"></span></div></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="make_year' + row_count +'"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")><cfoutput><cfloop from="#yil#" to="1970" index="i" step="-1"><option value="#i#">#i#</option></cfloop></cfoutput></select></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="assetp_id' + row_count + '" value=""><input type="text" name="assetp'+ row_count +'" readonly="yes"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="plaka_ac(' + row_count + ');"></span></div></div>';
	
}

function pencere_ac(no)
{
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_brand_type&field_brand_type_id=add_purchase_request.brand_type_id'+ no +'&field_brand_name=add_purchase_request.brand_name'+ no +'&select_list=2');
}

function plaka_ac(no)
{
	if(confirm("<cf_get_lang dictionary_id='48456.Sadece Pertli Araçlar İçin Bu Alanı Doldurunuz'>!"))
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=add_purchase_request.assetp_id'+ no +'&field_name=add_purchase_request.assetp'+ no +'&is_passive');
	}
}

function kontrol()
/* Zorunlu alan kontrolleri için yazılan scriptler...  */
{
	if(document.add_purchase_request.branch_id.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57453.Şube'>!");
		return false;
	}
	
	if(document.add_purchase_request.employee.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='47953.Talep Eden'>!");
		return false;
	}
	if(document.add_purchase_request.request_date.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='47994.Talep Tarihi'>!");
		return false;
	}
	
	if(!CheckEurodate(add_purchase_request.request_date.value,"<cf_get_lang dictionary_id='47994.Talep Tarihi'>")) 
	{
		return false;
	}
	
	if(document.add_purchase_request.detail.value.length > 250)
	{
		alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='48082.en fazla 250 karakter'>!");
		return false;
	}
	
	if(row_count == 0 || kontrol_row_count == 0)
	{
		alert("<cf_get_lang dictionary_id='48460.En Az Bir Satır Alış Kaydı Girmelisiniz'>!");
		return false;
	}
		
	if(document.add_purchase_request.record_num.value > 0)
	{
		for(r=1;r<=add_purchase_request.record_num.value;r++)
		{
			deger_row_kontrol = eval("document.add_purchase_request.row_kontrol"+r);
			deger_assetp_catid = eval("document.add_purchase_request.assetp_catid"+r);
			deger_assetp_group = eval("document.add_purchase_request.assetp_group"+r);
			deger_usage_purpose_id = eval("document.add_purchase_request.usage_purpose_id"+r);
			deger_make_year = eval("document.add_purchase_request.make_year"+r);
			if(deger_row_kontrol.value == 1)
			{
				x = deger_assetp_catid.selectedIndex;
				if (deger_assetp_catid[x].value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='47973.Araç Tipi'> !");
					return false;
				}
				y = deger_usage_purpose_id.selectedIndex;
				if (deger_usage_purpose_id[y].value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='47901.Kullanım Amacı'> !");
					return false;
				}
				if(eval("document.add_purchase_request.brand_name"+r).value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58847.Marka'> / <cf_get_lang dictionary_id='30041.Marka Tipi'> !");
					return false;
				}
				z = deger_make_year.selectedIndex;
				if (deger_make_year[z].value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58225.model'>!");
					return false;
				}
			}
		}
	}
	return process_cat_control();
}
</script>
