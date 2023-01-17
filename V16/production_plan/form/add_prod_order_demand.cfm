<cf_xml_page_edit fuseact="prod.add_prod_order_demand">
<cfif isdefined("form.internal_row_info")>
	<cfset internal_row_id_list = ''>
	<cfloop list="#form.internal_row_info#" index="id">
		<cfset internal_row_id_list = ListAppend(internal_row_id_list,listlast(id,';'))>
	</cfloop>
	<cfquery name="get_internaldemand" datasource="#dsn3#">
		SELECT
			I_ROW.STOCK_ID,
			I_ROW.QUANTITY,
			I_ROW.PRODUCT_NAME,
			I_ROW.UNIT,
			I_ROW.SPECT_VAR_ID,
			S.IS_PRODUCTION,
			WRK_ROW_ID,
			I.INTERNAL_NUMBER,
			I.TARGET_DATE,
			I.INTERNAL_ID,
			I_ROW.I_ROW_ID
		FROM
			INTERNALDEMAND I,
			INTERNALDEMAND_ROW I_ROW,
			STOCKS S
		WHERE
			S.STOCK_ID = I_ROW.STOCK_ID AND
			I.INTERNAL_ID = I_ROW.I_ID AND
			I_ROW.I_ROW_ID IN (#internal_row_id_list#)
	</cfquery>
</cfif>
<cf_catalystHeader>
<cf_box> 
	<div id="demand_file" style="margin-left:850px; margin-top:15px; position:absolute;display:none;z-index:9999;"></div>
	<cfform name="add_collacted_demand" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_production_order_all_sub" enctype="multipart/form-data">
		<input type="hidden" name="is_manuel" id="is_manuel" value="1">
		<input type="hidden" name="record_num" id="record_num" value="0">
		<input type="hidden" name="is_demand" id="is_demand" value="<cfif isdefined("attributes.is_demand")><cfoutput>#attributes.is_demand#</cfoutput><cfelse>0</cfif>">
		<cfif isdefined('is_line_number')><input type="hidden" name="is_line_number_1" id="is_line_number_1" value="<cfoutput>#is_line_number#</cfoutput>"></cfif>
		<cfif isdefined('attributes.is_collacted')><input type="hidden" name="is_collacted" id="is_collacted" value="<cfoutput>#attributes.is_collacted#</cfoutput>"></cfif>
		<cf_basket id="prod_order_bask">
			<cf_grid_list>
				<thead>
					<tr>
						<th width="35"><a href="javascript://" onClick="pencere_ac_product();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>" style="cursor:pointer;" border="0"></i></a></th>
						<th width="100"  nowrap="nowrap">
							<cf_get_lang dictionary_id='36438.Talep Numarası'><cfif isdefined("attributes.is_demand") and attributes.is_demand eq 1>*</cfif>
							<cfinput type="text" name="temp_demand_no" id="temp_demand_no" value="" class="boxlist" onBlur="change_demand_no()">
						</th>
						<th><cf_get_lang dictionary_id='57657.Ürün'> *</th>
						<th style="max-width:40px;"><cf_get_lang dictionary_id='57647.Spec'></th>
						<th><cf_get_lang dictionary_id='57635.Miktar'> *</th>
						<th><cf_get_lang dictionary_id='57636.Birim'> *</th>
						<th style="min-width:100px"><cf_get_lang dictionary_id='58834.İstasyon'> *</th>
						<th style="max-width:330px" colspan="2" nowrap="nowrap">
							<div class="ui-form-list">
							<div class="form-group">
								<div class="col col-4" style="color:rgb(68,182,174)"><cf_get_lang dictionary_id='36604.Hedef Başlangıç'> *</div>
								<div class="col col-5">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57742.Tarih'></cfsavecontent>
											<cfinput type="text" name="temp_date" id="temp_date" value="#dateformat(now(),dateformat_style)#"  class="box" onchange="change_date_info(1);" validate="#validate_style#" message="#message#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="temp_date"></span>
									</div>
								</div>
								<div class="col col-3">
								<div class="col col-6">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57491.Saat'></cfsavecontent>
										<cfinput type="text" name="temp_hour" id="temp_hour" value="00" style="width:30px;" class="box" onKeyUp="isNumber(this);" onBlur="change_date_info(1);" validate="integer" message="#message#">								</div>
								<div class="col col-6">
									<cfinput type="text" name="temp_min" id="temp_min" value="00" style="width:30px;" class="box" onKeyUp="isNumber(this);" onBlur="change_date_info(1);" validate="integer" message="#message#">
								</div>
							</div>
							</div>
						</div>
						</th>
						<th colspan="2" nowrap="nowrap" style="max-width:330px">
							<div class="ui-form-list">
								<div class="form-group">
									<div class="col col-4" style="color:rgb(68,182,174)"><cf_get_lang dictionary_id='36606.Hedef Bitiş'> *</div>
									<div class="col col-5">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57742.Tarih'></cfsavecontent>
												<cfinput type="text" name="temp_date_2" id="temp_date_2" value="#dateformat(now(),dateformat_style)#" style="width:70px;" class="box" onchange="change_date_info(2);" validate="#validate_style#" message="#message#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="temp_date_2"></span>
										</div>
									</div>
									<div class="col col-3">
									<div class="col col-6">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57491.Saat'></cfsavecontent>
											<cfinput type="text" name="temp_hour_2" id="temp_hour_2" value="00" style="width:30px;" class="box" onKeyUp="isNumber(this);" onBlur="change_date_info(2);" validate="integer" message="#message#">
									</div>
									<div class="col col-6">
										<cfinput type="text" name="temp_min_2" id="temp_min_2" value="00" style="width:30px;" class="box" onKeyUp="isNumber(this);" onBlur="change_date_info(2);" validate="integer" message="#message#">
									</div>
								</div>
								</div>
							</div>
						</th>
					</tr>
				</thead>
				<tbody name="table1" id="table1"></tbody>
			</cf_grid_list>
		</cf_basket>
		<br/>
		<cf_basket_form id="prod_order">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
						</div>
					</div>
					<div class="form-group" id="item-project_head">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfoutput>
									<cfif isdefined('is_generate_serial_nos') and is_generate_serial_nos eq 1>
										<input type="hidden" name="is_generate_serial_nos" id="is_generate_serial_nos" value="1">
									</cfif>
									<input type="hidden" name="is_select_sub_product" id="is_select_sub_product" value="#is_select_sub_product#" />
									<input type="hidden" name="project_id" id="project_id" value="">
									<input type="text" name="project_head" id="project_head" value="" style="width:150px;"onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','135')"autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_collacted_demand.project_id&project_head=add_collacted_demand.project_head');"></span>
								</cfoutput>
							</div>
						</div>
					</div>
					<cfif show_level_input>
					<div class="form-group" id="item-stage_info" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36466.Seviye'></label>
						<div class="col col-8 col-xs-12">
							<input name="stage_info" id="stage_info" type="text" onkeyup="return(FormatCurrency(this,event,8))" style="width:50px;" title="<cf_get_lang dictionary_id='60573.Seviye alanına değer girilirse o kadar kırılım için kayıt açılır'>">
						</div>
						
					</div>
				</cfif>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-12">
					<cf_workcube_buttons is_upd='0' add_function='kontrol_row()'>
				</div>
			</cf_box_footer>
		</cf_basket_form>
	</cfform>
</cf_box>
<script type="text/javascript">
	$(document).ready(function(){
		row_count_demand = 0;
		row_date = "<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>";
		});
	function open_file()
	{
		document.getElementById('demand_file').style.display='';
		<cfif isdefined("attributes.is_demand") and attributes.is_demand eq 1>
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_add_demand_file&is_demand=1');
		<cfelse>
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_add_demand_file');
		</cfif>
		
	}
	function kontrol_row()
	{
		for(r=1;r<=document.all.record_num.value;r++)
		{
			if(eval("document.all.row_kontrol"+r).value==1)
			{ 
				<cfif isdefined("attributes.is_demand") and attributes.is_demand eq 1>
					if(document.getElementById('demand_no'+r).value == "")
					{
						alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='36438.Talep Numarası'>");
						return false;
					}
				</cfif>
				if(document.getElementById('stock_id'+r).value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='57657.Ürün'>");
					return false;
				}
				if(document.getElementById('quantity'+r).value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='57635.Miktar'>");
					return false;
				}
				if(document.getElementById('start_date'+r).value == "")
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'>");
					return false;
				}
				if(document.getElementById('finish_date'+r).value == "")
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='57700.Bitiş Tarihi'>");
					return false;
				}
				if(eval('document.all.station_id_'+r+'_0').value == "")
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='58834.İstasyon'>");
					return false;
				}
			}
		}
		if(date_control_2()&& process_cat_control()){
			unformat_fields();
		}
		else{
			return false;
		}
	}
	function date_control_2()
	{
		<cfif is_time_calculation eq 0 and not (isdefined('attributes.is_demand') and attributes.is_demand eq 1)>
		for(r=1;r<=document.all.record_num.value;r++)
				{
					if(eval("document.all.row_kontrol"+r).value==1)
					{
						if((document.getElementById('start_date'+r).value != "") && (document.getElementById('finish_date'+r).value != ""))
						return time_check(document.getElementById('start_date'+r), document.getElementById('start_h'+r), document.getElementById('start_m'+r), document.getElementById('finish_date'+r),  document.getElementById('finish_h'+r), document.getElementById('finish_m'+r), "<cf_get_lang dictionary_id ='36918.Üretim Başlama Tarihi,Bitiş Tarihinden Önce Olmalıdır'> !");
						else if((document.getElementById('start_date'+r).value == ""))
						{
							alert("<cf_get_lang dictionary_id='58194.Zorunlu alan'> : <cf_get_lang dictionary_id='57501.başlangıç'>  <cf_get_lang dictionary_id ='58593.tarihi'>");
						return false;
						}
						else if((document.getElementById('finish_date'+r).value == ""))
						{
							alert("<cf_get_lang dictionary_id='58194.Zorunlu alan'> : <cf_get_lang dictionary_id='57502.Bitiş'> <cf_get_lang dictionary_id ='58593.tarihi'>");
							return false;
						}
					}
				}
		</cfif>
		return true;
	}
	function change_demand_no()
	{
		if(document.all.record_num.value > 0)
		{
			for(var k=1;k<=document.all.record_num.value;k++)
				if(eval("document.all.row_kontrol"+k).value==1)
					eval("document.all.demand_no"+k).value = document.all.temp_demand_no.value;
		}
	}
	function change_date_info(type)
	{
		if(type == 1)//hedef başlangıç
		{
			if(document.getElementById('temp_hour').value == '' || document.getElementById('temp_hour').value > 23)
				document.getElementById('temp_hour').value = '00';
			if(document.getElementById('temp_min').value == '' || document.getElementById('temp_min').value > 59)
				document.getElementById('temp_min').value = '00';
			if(document.getElementById('temp_date').value!= '')
				for(r=1;r<=document.all.record_num.value;r++)
				{
					if(eval("document.all.row_kontrol"+r).value==1)
					{
						document.getElementById('start_date'+r).value = document.getElementById('temp_date').value;
						document.getElementById('start_h'+r).value = parseFloat(document.getElementById('temp_hour').value);
						document.getElementById('start_m'+r).value = parseFloat(document.getElementById('temp_min').value);
					}
				}
		}
		else//hedef bitiş
		{
			if(document.getElementById('temp_hour_2').value == '' || document.getElementById('temp_hour_2').value > 23)
				document.getElementById('temp_hour_2').value = '00';
			if(document.getElementById('temp_min_2').value == '' || document.getElementById('temp_min_2').value > 59)
				document.getElementById('temp_min_2').value = '00';
			if(document.getElementById('temp_date_2').value!= '')
				for(r=1;r<=document.all.record_num.value;r++)
				{
					if(eval("document.all.row_kontrol"+r).value==1)
					{
						document.getElementById('finish_date'+r).value = document.getElementById('temp_date_2').value;
						document.getElementById('finish_h'+r).value = parseFloat(document.getElementById('temp_hour_2').value);
						document.getElementById('finish_m'+r).value = parseFloat(document.getElementById('temp_min_2').value);
					}
				}
		}
	}
	function unformat_fields()
	{
		
		for(r=1;r<=document.all.record_num.value;r++)
		{
			if(eval("document.all.row_kontrol"+r).value==1)
			{
				document.getElementById("quantity"+r).value = filterNum(document.getElementById("quantity"+r).value);	
			}
		}
		return true;
	}
	function sil(sy)
	{
		var my_element=eval("document.all.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	row_count_demand = 0;
	function add_row(stock_id,product_name,amount,unit,date1,date2,order_id,order_row_id,spect_main_id,demand_no,wrk_row_relation_id)
	{
		form_name = "add_collacted_demand";
		row_date = "<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>";
		if(stock_id == undefined) stock_id='';
		if(product_name == undefined) product_name='';
		if(amount == undefined) amount='';
		if(unit == undefined) unit='';
		if(date1 == undefined) date1=row_date;
		if(date2 == undefined) date2=row_date;
		if(date1 == ' ') date1=row_date;
		if(date2 == ' ') date2=row_date;
		if(order_id == undefined) order_id='';
		if(order_row_id == undefined) order_row_id='';
		if(spect_main_id == undefined) spect_main_id='';
		if(demand_no == undefined) demand_no='';
		if(wrk_row_relation_id == undefined) wrk_row_relation_id='';
		row_count_demand++;
		var newRow;
		var newCell;
		document.all.record_num.value=row_count_demand;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count_demand);
		newRow.setAttribute("id","frm_row" + row_count_demand);		
		newRow.setAttribute("NAME","frm_row" + row_count_demand);
		newRow.setAttribute("ID","frm_row" + row_count_demand);		
		newRow.className = 'color-row';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count_demand +'" ><input type="hidden" value="'+order_id+'" name="order_id' + row_count_demand +'" ><input type="hidden" value="'+wrk_row_relation_id+'" name="wrk_row_relation_id' + row_count_demand +'" ><input type="hidden" value="'+order_row_id+'" name="order_row_id' + row_count_demand +'" ><a href="javascript://" onclick="sil(' + row_count_demand + ');"><i class="fa fa-minus" border="0" align="top"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="demand_no' + row_count_demand +'" id="demand_no' + row_count_demand +'" value="'+demand_no+'">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" name="stock_id'+ row_count_demand +'" id="stock_id'+ row_count_demand +'" value="'+stock_id+'"><input type="text" style="width:130px;" name="product_name'+ row_count_demand +'" id="product_name'+ row_count_demand +'" value="'+product_name+'" onFocus="autocomp_product('+row_count_demand+');" autocomplete="off"><a href="javascript://" onClick="pencere_ac_product('+ row_count_demand +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang dictionary_id="57734.Seçiniz">"></a>';
		newCell = newRow.insertCell(newRow.cells.length);   
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" name="spect_main_id'+ row_count_demand +'" id="spect_main_id'+ row_count_demand +'" value="" readonly"><input type="hidden" name="spect_var_id'+ row_count_demand +'" id="spect_var_id'+ row_count_demand +'" value="" readonly ><input style="width:50px;" type="text" name="spect_var_name'+ row_count_demand +'" id="spect_var_name'+ row_count_demand +'" value="" readonly><a href="javascript://" onClick="open_spec('+ row_count_demand +','+form_name+');"><img src="/images/plus_thin.gif"  align="top" border="0" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="quantity'+ row_count_demand +'" id="quantity'+ row_count_demand +'" value="'+amount+'"  passThrough="onkeyup=""return(FormatCurrency(this,event));""" style="width:100px;" class="moneybox">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="unit'+ row_count_demand +'" name="unit'+ row_count_demand +'" style="width:98px;" readonly value="'+unit+'">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="station_id_'+ row_count_demand +'_0" id="station_id_'+ row_count_demand +'_0" style="width:158px;"><option value="">Seçiniz</option></select><input type="hidden" name="station_name'+ row_count_demand +'" id="station_name'+ row_count_demand +'" value=""></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","start_date" + row_count_demand + "_td");
		newCell.innerHTML = '<input type="text" name="start_date'+ row_count_demand +'" id="start_date'+ row_count_demand +'" value="'+add_collacted_demand.temp_date.value+'" style="width:65px;">';
		wrk_date_image('start_date' + row_count_demand);
		<cfoutput>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="col col-6"><div class="form-group"><select name="start_h'+ row_count_demand +'" id="start_h'+ row_count_demand +'"><cfloop from="0" to="23" index="i"><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfloop></select></div></div><div class="col col-6"><div class="form-group"><select name="start_m'+ row_count_demand +'" id="start_m'+ row_count_demand +'"><cfloop from="0" to="59" index="i"><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfloop></select></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","finish_date" + row_count_demand + "_td");
		newCell.innerHTML = '<input type="text" name="finish_date'+ row_count_demand +'" id="finish_date'+ row_count_demand +'" value="'+add_collacted_demand.temp_date_2.value+'" style="width:65px;">';
		wrk_date_image('finish_date' + row_count_demand);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="col col-6"><div class="form-group"><select name="finish_h'+ row_count_demand +'" id="finish_h'+ row_count_demand +'"><cfloop from="0" to="23" index="i"><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfloop></select></div></div><div class="col col-6"><div class="form-group"><select name="finish_m'+ row_count_demand +'" id="finish_m'+ row_count_demand +'"><cfloop from="0" to="59" index="i"><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfloop></select></div></div>';
		get_product_main_spec_row(row_count_demand,spect_main_id);
		</cfoutput>
	}
	function autocomp_product(no)
	{
		AutoComplete_Create("product_name"+no,"PRODUCT_NAME","PRODUCT_NAME,STOCK_CODE","get_product","0","STOCK_ID","stock_id"+no,"",2,200,'get_product_main_spec_row('+row_count_demand+',0)');
	}
	function pencere_ac_product(no)
	{
		<cfoutput>
		if(no == undefined)
		{
			no = row_count_demand + 1;
			row_count_demand_new = row_count_demand + 1;
			openBoxDraggable('#request.self#?fuseaction=prod.popup_add_product&field_amount=add_collacted_demand.quantity' + no +'&is_production=1&call_function_first_prod=add_row&call_function_first_parameter='+row_count_demand_new+'&call_function=get_product_main_spec_row&call_function_parameter='+row_count_demand_new+'&field_unit_name=add_collacted_demand.unit' + no +'&spec_field_id=add_collacted_demand.spect_main_id' + no +'&field_name=add_collacted_demand.product_name' + no +'&field_id=add_collacted_demand.stock_id' + no);
		}
		else
		{
			openBoxDraggable('#request.self#?fuseaction=prod.popup_add_product&field_amount=add_collacted_demand.quantity' + no +'&is_production=1&call_function=get_product_main_spec_row&call_function_parameter='+row_count_demand+'&field_unit_name=add_collacted_demand.unit' + no +'&spec_field_id=add_collacted_demand.spect_main_id' + no +'&field_name=add_collacted_demand.product_name' + no +'&field_id=add_collacted_demand.stock_id' + no);
		}
		</cfoutput>
	}
	function station_stock_control_row(row_info)
	{
		var ws_id_len = eval('document.all.station_id_'+row_info+'_0').options.length;
		for(j=ws_id_len;j>=0;j--)
			eval('document.all.station_id_'+row_info+'_0').options[j] = null;	

		eval('document.all.station_id_'+row_info+'_0').options[0] = new Option('Seçiniz','');
		if(document.getElementById('stock_id'+row_info) != undefined && document.getElementById('stock_id'+row_info).value != '')
		{
			<cfif isdefined('is_product_station_relation') and is_product_station_relation eq 1>
				var get_ws = wrk_safe_query('prdp_get_ws','dsn3',0,document.getElementById('stock_id'+row_info).value);
				for(var jj=0;jj < get_ws.recordcount;jj++)
					eval('document.all.station_id_'+row_info+'_0').options[jj+1]=new Option(get_ws.STATION_NAME[jj],get_ws.STATION_ID[jj]);
				var get_product_station = wrk_safe_query('prdp_get_product_station','dsn3',0,document.getElementById('stock_id'+row_info).value);
			<cfelse>
			var get_ws = wrk_safe_query('prdp_get_ws_all','dsn3',0,'<cfoutput>#dsn_alias#</cfoutput>');
				for(var jj=0;jj < get_ws.recordcount;jj++)
					eval('document.all.station_id_'+row_info+'_0').options[jj+1]=new Option(get_ws.STATION_NAME[jj],get_ws.STATION_ID[jj]);
				var get_product_station = wrk_safe_query('prdp_get_product_station','dsn3',0,0);
			</cfif>
			if(get_product_station.recordcount)
			{
				eval('document.all.station_id_'+row_info+'_0').value = get_product_station.STATION_ID ;
			}
			else
			{
				eval('document.all.station_id_'+row_info+'_0').value = "" ;
			}
		}
	}
	function get_product_main_spec_row(row_info,spect_main_id)
	{
		if(document.getElementById('stock_id'+row_info).value != "" && document.getElementById('product_name'+row_info).value != "")
		{
			//spec_main_id de düştüğü için bu bloğa sokmuyoruz sadece istasyonunu seçili getiriyoruz.
			if(spect_main_id != undefined && spect_main_id != '' && spect_main_id != 0)
			{
				var listParam = spect_main_id + "*" + document.getElementById('stock_id'+row_info).value;
				QueryTextSpec = 'prdp_get_main_spec_id_2';
			}
			else
			{
				var listParam = document.getElementById('stock_id'+row_info).value;
				QueryTextSpec = 'prdp_get_main_spec_id_3';
			}
			var get_main_spec_id = wrk_safe_query(QueryTextSpec,'dsn3',0,listParam);
			if(get_main_spec_id.recordcount){
				document.getElementById('spect_main_id'+row_info).value = get_main_spec_id.SPECT_MAIN_ID ;
				document.getElementById('spect_var_name'+row_info).value = get_main_spec_id.SPECT_MAIN_NAME ;
			}
			else{
				document.getElementById('spect_main_id'+row_info).value = "";
				document.getElementById('spect_var_name'+row_info).value = "";
			}
			station_stock_control_row(row_info);
		}	
		else
			alert('<cf_get_lang dictionary_id="36831.Önce Ürün Seçiniz">');
	}
	<cfif isdefined('frm_prod_report')>/*sayfa rapordan cagrılmıssa secilen satırları toplu talep sayfasına ekliyor*/
		function add_row_from_production_trace_report()
		{
			<cfif isdefined("attributes.report_row_stock_id_") and len(report_row_stock_id_)>
				<cfloop list="<cfoutput>#attributes.report_row_stock_id_#</cfoutput>" index="r_stock_id">
					<cfif isdefined('stock_last_amount_#r_stock_id#') and filterNum(evaluate("stock_last_amount_#r_stock_id#")) gt 0>
						r_stock_id_info='<cfoutput>#listfirst(r_stock_id,"_")#</cfoutput>';
						row_amount_info_='<cfoutput>#evaluate("stock_last_amount_#r_stock_id#")#</cfoutput>';
						row_stock_unit_info_='<cfoutput>#evaluate("row_stock_unit_#r_stock_id#")#</cfoutput>';
						row_prod_name_info_='<cfoutput>#evaluate("row_stock_name_#r_stock_id#")#</cfoutput>';
						row_date1="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>";
						<cfif isdefined("row_wrk_row_id_#r_stock_id#")>
							row_wrk_row_id_ = '<cfoutput>#listfirst(evaluate("row_wrk_row_id_#r_stock_id#"))#</cfoutput>';
						<cfelse>
							row_wrk_row_id_ = '';
						</cfif>
						//row_unit_info='row_stock_unit_'
						if(row_prod_name_info_!='' && row_stock_unit_info_!='' && row_amount_info_!='' && row_wrk_row_id_!='')
							add_row(r_stock_id_info,row_prod_name_info_,row_amount_info_,row_stock_unit_info_,row_date1,row_date1,'','','','',row_wrk_row_id_)
						else
							add_row(r_stock_id_info,row_prod_name_info_,row_amount_info_,row_stock_unit_info_)
					</cfif>
				</cfloop>
			</cfif>
		}
		add_row_from_production_trace_report();
	</cfif>
	<cfif isdefined('form.internal_row_info') and get_internaldemand.recordcount>/*sayfaya iç talep listeleme sayfasından  secilen satırları toplu talep sayfasına ekliyor*/
		function add_row_from_internal_row_info()
		{
			<cfoutput>
			<cfloop query="get_internaldemand">
				r_stock_id_info='#STOCK_ID#';
				row_amount_info_='#evaluate("attributes.ADD_STOCK_AMOUNT_#INTERNAL_ID#_#I_ROW_ID#")#';
				row_stock_unit_info_='#UNIT#';
				row_prod_name_info_='#PRODUCT_NAME#';
				row_production_info_='#IS_PRODUCTION#';
				row_wrk_row_id_='#WRK_ROW_ID#';
				row_number_='#INTERNAL_NUMBER#';
				row_date1="#dateformat(now(),dateformat_style)#";
				//row_unit_info='row_stock_unit_'
				if(row_prod_name_info_!='' && row_stock_unit_info_!='' & row_amount_info_!='' & row_production_info_ != 0)
				{
					add_row(r_stock_id_info,row_prod_name_info_,row_amount_info_,row_stock_unit_info_,row_date1,row_date1,'','','',row_number_,row_wrk_row_id_)
				}
			</cfloop>
			</cfoutput>
		}
		add_row_from_internal_row_info();
	</cfif>
</script>
<cfif isdefined("attributes.is_from_file")>
	<cfinclude template="../query/get_demand_row_from_file.cfm">
</cfif>
