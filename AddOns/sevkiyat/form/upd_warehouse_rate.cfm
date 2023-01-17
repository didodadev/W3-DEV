<cfif isdefined("attributes.is_dlt")>
	<cfinclude template="../query/del_warehouse_rate.cfm">
<cfelseif isdefined("attributes.is_copy")>
	<cfinclude template="../query/copy_warehouse_rate.cfm">	
<cfelseif isdefined("attributes.is_submit")>
	<cfinclude template="../query/upd_warehouse_rate.cfm">
<cfelse>
<cfscript>
	get_warehouse_rates_action = createObject("component", "V16.settings.cfc.get_warehouse_rates");
	get_warehouse_rates_action.dsn3 = dsn3;
	get_warehouse_rates_action.dsn_alias = dsn_alias;
	get_warehouse_rates_action.dsn = dsn;
	get_warehouse_rate = get_warehouse_rates_action.get_warehouse_rate_fnc(
		 rate_id : '#attributes.rate_id#'
	);
	
	get_warehouse_rate_rows = get_warehouse_rates_action.get_warehouse_rate_rows_fnc(
		 rate_id : '#attributes.rate_id#'
	);
	
	get_warehouse_task_types = get_warehouse_rates_action.get_warehouse_task_types_funcs();
	get_units = get_warehouse_rates_action.get_units_funcs();	
</cfscript>
	<cf_catalystHeader>
	<cf_form_box>
	<cfform name="add_packet_ship" method="post" action="#request.self#?fuseaction=settings.list_warehouse_rates&event=upd">
		<cfinput type="hidden" value="1" name="is_submit">
		<cfinput type="hidden" value="#attributes.rate_id#" name="rate_id">
		<cfinput type="hidden" name="rowcount" id="rowcount" value="#get_warehouse_rate_rows.recordcount#">
		<div class="row"> 
        <div class="col col-12 col-xs-12 uniqueRow"> 
            <div class="row formContent">
                <div class="row" type="row">
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-company">
							<label class="col col-3 col-xs-12"><cf_get_lang_main no='107.Cari Hesap'> *</label>
							<div class="col col-6 col-xs-12">
								<div class="input-group">
									<cfinput type="hidden" name="company_id" id="company_id" value="#get_warehouse_rate.company_id#">
									<cfinput type="text" name="company" id="company" value="#get_warehouse_rate.NICKNAME#" readonly style="width:170px;">
									<cfset str_linke_ait="&field_comp_id=add_packet_ship.company_id&field_comp_name=add_packet_ship.company">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput><cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=7','list');"></span>
								</div>							
							</div>
						</div>
						<div class="form-group" id="item-company">
							<label class="col col-3 col-xs-12">Bill To Company</label>
							<div class="col col-6 col-xs-12">
								<div class="input-group">
									<cfinput type="hidden" name="bill_to_company_id" id="bill_to_company_id" value="#get_warehouse_rate.bill_to_company_id#">
									<cfinput type="text" name="bill_to_company" id="bill_to_company" value="#get_warehouse_rate.BILL_TO_NICKNAME#" style="width:170px;">
									<cfset str_linke_ait="&field_comp_id=add_packet_ship.bill_to_company_id&field_comp_name=add_packet_ship.bill_to_company">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput><cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=7','list');"></span>
								</div>							
							</div>
						</div>
						<div class="form-group" id="item-action_date">
							<label class="col col-3 col-xs-12">Start Date</label>
							<div class="col col-6 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message">Start Date!</cfsavecontent>
									<cfinput type="text" name="action_date" id="action_date" validate="#validate_style#" required="Yes" message="#message#" style="width:65px;" value="#dateformat(get_warehouse_rate.action_date,dateformat_style)#">
									<cfoutput>
										<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="action_date"></span>
									</cfoutput>
								</div>
							</div>
						</div>
					</div>					
				</div>
			</div>
		</div>
		</div>	
		<div class="row" type="row">
			<div class="col col-8">
			<cf_ajax_list>
				<thead>
					<tr>
						<th><a href="javascript:add_row();"><img src="/images/plus_list.gif"></a></th>
						<th>Task Category</th>
						<th>Note</th>
						<th>Unit</th>
						<th>Price</th>
						<th>Currency</th>
						<!---
						<th>From</th>
						<th>To</th>
						<th>R Unit</th>
						--->
						<th>Billing</th>
					</tr>
				</thead>
				<tbody id="add_table">
					<cfoutput query="get_warehouse_rate_rows">
					<cfset sira_ = currentrow>
					<tr id="my_row_#currentrow#">
						<td>
						<input name="rate1_#currentrow#" type="hidden" style="width:100px;" class="moneybox" value="#tlformat(rate1)#" onkeyup="return(FormatCurrency(this,event,2));">
						<input name="rate2_#currentrow#" type="hidden" style="width:100px;" class="moneybox" value="#tlformat(rate2)#" onkeyup="return(FormatCurrency(this,event,2));">
						<input  type="hidden"  value="#rate_code#"  name="rate_code_#currentrow#">
						<input type="hidden" name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#" value="1">
						<select name="rate_unit_id_#currentrow#" id="rate_unit_id_#currentrow#" style="display:none;"><cfloop query="get_units"><option value="#unit_id#" <cfif get_warehouse_rate_rows.RATE_UNIT_ID[sira_] eq get_units.unit_id>selected</cfif>>#unit#</option></cfloop></select>
						<a href="javascript:sil('#currentrow#');"><img src="/images/delete_list.gif"></a>
						</td>
						<td><select name="warehouse_task_type_id_#currentrow#" id="warehouse_task_type_id_#currentrow#"><cfloop query="get_warehouse_task_types"><option value="#WAREHOUSE_TASK_TYPE_ID#" <cfif get_warehouse_task_types.WAREHOUSE_TASK_TYPE_ID eq get_warehouse_rate_rows.WAREHOUSE_TASK_TYPE_ID[sira_]>selected</cfif>>#WAREHOUSE_TASK_TYPE#</option></cfloop></select></td>
						<td><input  type="hidden"  value="1"  name="product_id_#currentrow#"><input  type="hidden"  value="Product"  name="product_name_#currentrow#"><input type="text"  value="#rate_info#"  name="rate_info_#currentrow#" style="width:150px;"></td>
						<td><select name="unit_id_#currentrow#" id="unit_id_#currentrow#"><cfloop query="get_units"><option value="#unit_id#" <cfif get_units.unit_id eq get_warehouse_rate_rows.unit_id[sira_]>selected</cfif>>#unit#</option></cfloop></select></td>
						<td><input name="price_#currentrow#" type="text" style="width:100px;" class="moneybox" value="#tlformat(price)#" onkeyup="return(FormatCurrency(this,event,2));"></td>
						<td><select name="price_money_#currentrow#" id="price_money_#currentrow#"><option value="USD">USD</option></select></td>
						<td><input  type="checkbox"  value="1"  name="is_bill_#currentrow#" <cfif is_bill eq 1>checked</cfif>></td>
						<td></td>
					</tr>
					</cfoutput>
				</tbody>
			</cf_ajax_list>
			</div>
		</div>
		<div class="row formContentFooter">
			<div class="col col-6">
				<cf_record_info 
					query_name="get_warehouse_rate"
					record_emp="record_emp" 
					record_date="record_date"
					update_emp="update_emp"
					update_date="update_date">
			</div>
			<div class="col col-6">
				<cf_workcube_buttons is_upd='1' add_function='control()' delete_page_url='#request.self#?fuseaction=settings.list_warehouse_rates&event=upd&is_dlt=1&rate_id=#attributes.rate_id#'>
			</div>
		</div> 
	</cfform>
	</cf_form_box>
</cfif>
<script>
function control()
{
	if(document.getElementById('company_id').value == '' || document.getElementById('company_name').value == '')
	{
		alert('Choose Customer!');
		return false;
	}
	return true;
}

function sil(sy)
{
	var my_element=eval("add_packet_ship.row_kontrol_"+sy);
	my_element.value=0;

	var my_element=eval("my_row_"+sy);
	my_element.style.display="none";
}

rowCount = <cfoutput>#get_warehouse_rate_rows.recordcount#</cfoutput>;
function add_row()
{
	rowCount++;
	var newRow;
	var newCell;
	newRow = add_table.insertRow();
	newRow.setAttribute("name","my_row_" + rowCount);
	newRow.setAttribute("id","my_row_" + rowCount);		
	newRow.setAttribute("NAME","my_row_" + rowCount);
	newRow.setAttribute("ID","my_row_" + rowCount);	
	
	document.getElementById('rowcount').value = rowCount;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<cfoutput><select style="display:none;" name="rate_unit_id_' + rowCount +'" id="rate_unit_id_' + rowCount +'"><cfloop query="get_units"><option value="#unit_id#">#unit#</option></cfloop></select></cfoutput><input name="rate2_' + rowCount +'" type="hidden" style="width:100px;" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event,2));"><input name="rate1_' + rowCount +'" type="hidden" style="width:100px;" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event,2));"><input  type="hidden"  value="1"  name="row_kontrol_' + rowCount +'"><a style="cursor:pointer;" onClick="sil(' + rowCount + ');"><img src="/images/delete_list.gif" border="0"></a>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<cfoutput><select name="warehouse_task_type_id_' + rowCount +'" id="warehouse_task_type_id_' + rowCount +'"><cfloop query="get_warehouse_task_types"><option value="#WAREHOUSE_TASK_TYPE_ID#">#WAREHOUSE_TASK_TYPE#</option></cfloop></select></cfoutput>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden"  value="" name="rate_code_' + rowCount +'"><input  type="hidden"  value="1"  name="product_id_' + rowCount +'"><input  type="hidden"  value="Product"  name="product_name_' + rowCount +'"><input type="text"  value=""  name="rate_info_' + rowCount +'" style="width:150px;">';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<cfoutput><select name="unit_id_' + rowCount +'" id="unit_id_' + rowCount +'"><cfloop query="get_units"><option value="#unit_id#">#unit#</option></cfloop></select></cfoutput>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input name="price_' + rowCount +'" type="text" style="width:100px;" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event,2));">';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<cfoutput><select name="price_money_' + rowCount +'" id="price_money_' + rowCount +'"><option value="USD">USD</option></select></cfoutput>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="checkbox"  value="1"  name="is_bill_' + rowCount +'">';
}
</script>