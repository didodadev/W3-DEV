<cfquery name="GET_NOT_DEP_COST" datasource="#DSN#">
	SELECT DEPARTMENT_ID,LOCATION_ID FROM STOCKS_LOCATION STOCKS_LOCATION WHERE ISNULL(IS_COST_ACTION,0)=1
</cfquery>
<cfsavecontent variable="dep_list"><cfoutput><cfif GET_NOT_DEP_COST.RECORDCOUNT> AND( <cfset rw_count=0><cfloop query="GET_NOT_DEP_COST"><cfset rw_count=rw_count+1> NOT (LOCATION_ID =#GET_NOT_DEP_COST.LOCATION_ID# AND DEPARTMENT_ID =#GET_NOT_DEP_COST.DEPARTMENT_ID#) <cfif rw_count lt GET_NOT_DEP_COST.RECORDCOUNT>AND</cfif> </cfloop> )</cfif></cfoutput>
</cfsavecontent>
<cfif not len(dep_list)>
	<cfset dep_list = "AND 1=1">
</cfif>
<cfquery name="GET_INVOICE" datasource="#dsn2#">
	SELECT INVOICE_NUMBER,INVOICE_CAT FROM INVOICE WHERE INVOICE_ID=#attributes.invoice_id#
</cfquery>
<cfif not listfind('48,49,50,51,58,63',GET_INVOICE.INVOICE_CAT,',')>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='30549.Fatura Tipi Uygun Değil'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_PRODUCT_COST_INVOICE" datasource="#dsn2#">
	SELECT 
		PRODUCT_COST_INVOICE.PRODUCT_COST_INVOICE_ID, 
        PRODUCT_COST_INVOICE.INVOICE_ID, 
        PRODUCT_COST_INVOICE.PRODUCT_ID, 
        PRODUCT_COST_INVOICE.STOCK_ID,
        PRODUCT_COST_INVOICE.SPECT_MAIN_ID, 
        PRODUCT_COST_INVOICE.COST_DATE, 
        PRODUCT_COST_INVOICE.COST_TYPE_ID, 
        PRODUCT_COST_INVOICE.PRICE_PROTECTION_TYPE, 
        PRODUCT_COST_INVOICE.PRICE_PROTECTION, 
        PRODUCT_COST_INVOICE.PRICE_PROTECTION_MONEY,
        PRODUCT_COST_INVOICE.AMOUNT, 
        PRODUCT_COST_INVOICE.TOTAL_PRICE_PROTECTION, 
        PRODUCT_COST_INVOICE.RECORD_DATE, 
        PRODUCT_COST_INVOICE.RECORD_EMP, 
        PRODUCT_COST_INVOICE.RECORD_IP, 
        PRODUCT_COST_INVOICE.UPDATE_DATE, 
        PRODUCT_COST_INVOICE.UPDATE_EMP, 
        PRODUCT_COST_INVOICE.UPDATE_IP ,
		PRODUCT.PRODUCT_NAME,
        PRODUCT_COST_INVOICE.DEPARTMENT_ID,
        AMOUNT_CONSIGMENT
	FROM 
		PRODUCT_COST_INVOICE,
		#dsn3_alias#.PRODUCT PRODUCT
	WHERE 
		PRODUCT_COST_INVOICE.INVOICE_ID=#attributes.invoice_id# AND
		PRODUCT.PRODUCT_ID=PRODUCT_COST_INVOICE.PRODUCT_ID
</cfquery>
<cfquery name="GET_COST_TYPE" datasource="#DSN#">
	SELECT COST_TYPE_ID,COST_TYPE_NAME FROM SETUP_COST_TYPE 
</cfquery>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT 
        MONEY, 
        RATE1, 
        RATE2, 
        MONEY_STATUS, 
        PERIOD_ID, 
        COMPANY_ID, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_MONEY 
    WHERE 
    	PERIOD_ID = #session.ep.period_id# 
    AND 
	    MONEY_STATUS = 1 
    ORDER BY 
    	MONEY DESC
</cfquery>

<cfset cfc = CreateObject("component","/../workdata/get_department")>
<cfset stores = cfc.getDepartmentLocation()>
<cf_box title="#getLang('','Fiyat Farkı Dağılımı',32556)# : #GET_INVOICE.INVOICE_NUMBER#">
	<cfform name="price_protec_form" action="#request.self#?fuseaction=objects.emptypopup_add_product_cost_invoice">
		<input type="hidden" name="record_num" id="record_num" value="<cfif GET_PRODUCT_COST_INVOICE.RECORDCOUNT><cfoutput>#GET_PRODUCT_COST_INVOICE.RECORDCOUNT#</cfoutput><cfelse>1</cfif>">
		<input type="hidden" name="invoice_id" id="invoice_id" value="<cfoutput>#attributes.invoice_id#</cfoutput>">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><a onClick="add_row();"><i class="fa fa-plus" title="Ekle"></i></a></th>
					<th width="250"><cf_get_lang dictionary_id="57657.Ürün"></th>
					<th><cf_get_lang dictionary_id="57647.Spec"></th>
					<th><cf_get_lang dictionary_id="57742.Tarih"></th>
					<th width="125"><cf_get_lang dictionary_id="57630.Tip"></th>
					<th width="75"><cf_get_lang dictionary_id="29472.Yöntem"></th>
					<th><cf_get_lang dictionary_id="57638.Birim Fiyat"></th>				
					<th width="75"><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					<th width="250"><cf_get_lang dictionary_id='58763.Depo'></th>
					<th><cf_get_lang dictionary_id="57635.Miktar"></th>
					<th><cf_get_lang dictionary_id='45518.Konsinye'> <cf_get_lang dictionary_id="57635.Miktar"></th>
					<th><cf_get_lang dictionary_id="32823.Toplam Miktar"></th>
					<th><cf_get_lang dictionary_id="29534.Toplam Tutar"></th>
				</tr>
			</thead>
			<tbody id="table1">
				<cfif GET_PRODUCT_COST_INVOICE.RECORDCOUNT>
					<cfoutput query="GET_PRODUCT_COST_INVOICE">
						<tr id="frm_row_#currentrow#">
							<input type="hidden" name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#" value="1">
							<input type="hidden" name="product_cost_invoice_#currentrow#" id="product_cost_invoice_#currentrow#" value="#PRODUCT_COST_INVOICE_ID#">
							<td><a href="javascript://" onClick="sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td> 
							<td>
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="product_id_#currentrow#" id="product_id_#currentrow#" value="#PRODUCT_ID#">
										<input type="hidden" name="stock_id_#currentrow#" id="stock_id_#currentrow#" value="#STOCK_ID#">
										<input type="text" name="product_name_#currentrow#" id="product_name_#currentrow#" style="width:135px;" value="#PRODUCT_NAME#">
										<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_product_names&product_id=price_protec_form.product_id_#currentrow#&field_id=price_protec_form.stock_id_#currentrow#&field_name=price_protec_form.product_name_#currentrow#&run_function=stocks_row&run_function_param=#currentrow#&keyword='+encodeURIComponent(document.price_protec_form.product_name_#currentrow#.value),'list');"></span>
									</div>
								</div>
							</td>
							<td nowrap="nowrap">
								<cfif len(SPECT_MAIN_ID)>
									<cfquery name="GET_SPEC_NAME" datasource="#dsn3#">
										SELECT 
											SPECT_MAIN_NAME 
										FROM 
											SPECT_MAIN 
										WHERE 
											SPECT_MAIN_ID =#SPECT_MAIN_ID#
									</cfquery>
								</cfif>
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="spect_main_id_#currentrow#" id="spect_main_id_#currentrow#" value="#SPECT_MAIN_ID#">
										<input type="text" name="spect_main_name_#currentrow#" id="spect_main_name_#currentrow#" style="width:120px;" value="<cfif len(SPECT_MAIN_ID)>#GET_SPEC_NAME.SPECT_MAIN_NAME#</cfif>">
										<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="open_spec(#currentrow#)"></span>
									</div>
								</div>
							</td>
							<td nowrap="nowrap">
								<input type="text" name="start_date_#currentrow#" id="start_date_#currentrow#" value="#dateformat(COST_DATE, dateformat_style)#" style="width:65px;" readonly>
								<cf_wrk_date_image date_field="start_date_#currentrow#" call_function="stocks_row" call_parameter="#currentrow#">
							</td>
							<td>
								<div class="form-group">
									<select name="cost_type_#currentrow#" id="cost_type_#currentrow#">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="GET_COST_TYPE"><option value="#GET_COST_TYPE.COST_TYPE_ID#" <cfif GET_COST_TYPE.COST_TYPE_ID eq GET_PRODUCT_COST_INVOICE.COST_TYPE_ID>selected</cfif>>#GET_COST_TYPE.COST_TYPE_NAME#</option></cfloop>
									</select>
								</div>
							</td>
							<td>
								<div class="form-group">
									<select name="price_protection_type_#currentrow#" id="price_protection_type_#currentrow#" style="width:100px;">
										<option value="1" <cfif PRICE_PROTECTION_TYPE EQ 1>selected</cfif>><cf_get_lang dictionary_id='37622.Azalt'></option><!--- zaten hesaplamada cıkarma yaptığı için -1 artırda--->
										<option value="-1" <cfif PRICE_PROTECTION_TYPE EQ -1>selected</cfif>><cf_get_lang dictionary_id='37623.Artır'></option>
									</select>
								</div>
							</td>
							<td><div class="form-group"><input type="text" name="price_#currentrow#" id="price_#currentrow#" class="moneybox" value="#TLFormat(PRICE_PROTECTION,session.ep.our_company_info.purchase_price_round_num)#" onblur="hesapla(1);"></div></td>
							<td>
								<div class="form-group">
									<select name="price_protection_money_#currentrow#" id="price_protection_money_#currentrow#">
										<cfloop query="GET_MONEY"><option value="#GET_MONEY.MONEY#" <cfif GET_PRODUCT_COST_INVOICE.PRICE_PROTECTION_MONEY is GET_MONEY.MONEY>selected</cfif>>#GET_MONEY.MONEY#</option></cfloop>
									</select>
								</div>
							</td>
							<td>
								<div class="form-group">
									<select name="department_#currentrow#" id="department_#currentrow#" onchange="calc_dep(this.value,#currentrow#);">
										<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
										<cfloop query="stores">
											<option value="#ID#" <cfif GET_PRODUCT_COST_INVOICE.department_id eq stores.ID>selected</cfif>>#LOCATION_NAME#</option>
										</cfloop>
									</select>
								</div>
							</td>
							<td><div class="form-group"><input type="text" name="amount_#currentrow#" id="amount_#currentrow#" class="moneybox" value="#TLFormat(AMOUNT,4)#" onblur="hesapla(1);"></div></td>
							<td><div class="form-group"><input type="text" name="amount_consignment_#currentrow#" id="amount_consignment_#currentrow#" class="moneybox" value="#TLFormat(AMOUNT_CONSIGMENT,4)#" onblur="hesapla(1);"></div></td>
							<td><div class="form-group"><input type="text" name="amount_total_#currentrow#" id="amount_total_#currentrow#" class="moneybox" value="" onblur="hesapla(1);"></div></td>
							<td><div class="form-group"><input type="text" name="row_total_price_#currentrow#" id="row_total_price_#currentrow#" style="width:100px;" class="moneybox" value="#TLFormat(TOTAL_PRICE_PROTECTION,session.ep.our_company_info.purchase_price_round_num)#" onblur="hesapla(2);"></div></td>
						</tr>
					</cfoutput>
				<cfelse>
				<cfoutput>
				<tr id="frm_row_1">
					<input type="hidden" name="row_kontrol_1" id="row_kontrol_1" value="1">
					<input type="hidden" name="product_cost_invoice_1" id="product_cost_invoice_1" value="">
					<td><a href="javascript://" onClick="sil(1);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td> 
					<td>
						<div class="form-group">
							<div class="input-group">
								<input type="hidden" name="product_id_1" id="product_id_1" value="">
								<input type="hidden" name="stock_id_1" id="stock_id_1" value="">
								<input type="text" name="product_name_1" id="product_name_1" style="width:135px;" value="">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=price_protec_form.product_id_1&field_id=price_protec_form.stock_id_1&field_name=price_protec_form.product_name_1&run_function=stocks_row&run_function_param=1&keyword='+encodeURIComponent(document.price_protec_form.product_name_1.value),'list');"></span>
							</div>
						</div>
					</td>
					<td nowrap="nowrap">
						<div class="form-group">
							<div class="input-group">
								<input type="hidden" name="spect_main_id_1" id="spect_main_id_1" value="">
								<input type="text" name="spect_main_name_1" id="spect_main_name_1" value="">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="open_spec(1);"></span>
							</div>
						</div>
					</td>
					<td nowrap="nowrap">
						<input type="text" name="start_date_1" id="start_date_1" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>" style="width:65px;" readonly><cf_wrk_date_image date_field="start_date_1" call_function="stocks_row" call_parameter="1">
					</td>
					<td>
						<div class="form-group">
							<select name="cost_type_1" id="cost_type_1">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfloop query="GET_COST_TYPE"><option value="#COST_TYPE_ID#">#COST_TYPE_NAME#</option></cfloop>
							</select>
						</div>
					</td>
					<td>
						<div class="form-group">
							<select name="price_protection_type_1" id="price_protection_type_1">
								<option value="1"><cf_get_lang dictionary_id='37622.Azalt'></option><!--- zaten hesaplamada cıkarma yaptığı için -1 artırda--->
								<option value="-1"><cf_get_lang dictionary_id='37623.Artır'></option>
							</select>
						</div>
					</td>
					<td><div class="form-group"><input type="text" name="price_1" id="price_1" class="moneybox" value="<cfoutput>#TLFormat(0,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>" onblur="hesapla(1);"></div></td>
					<td>
						<div class="form-group">
							<select name="price_protection_money_1" id="price_protection_money_1">
								<cfloop query="GET_MONEY"><option value="#GET_MONEY.MONEY#">#GET_MONEY.MONEY#</option></cfloop>
							</select>
						</div>
					</td>
					<td>
						<div class="form-group">
							<select name="department_1" id="department_1" onchange="calc_dep(this.value,1);">
								<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<cfloop query="stores">
									<option value="#ID#">#LOCATION_NAME#</option>
								</cfloop>
							</select>
						</div>
					</td>
					<td><div class="form-group"><input type="text" name="amount_1" id="amount_1" class="moneybox" value="<cfoutput>#TLFormat(0,4)#</cfoutput>" onblur="hesapla(1);"></div></td>
					<td><div class="form-group"><input type="text" name="amount_consignment_1" id="amount_consignment_1" class="moneybox" value="" onblur="hesapla(1);"></div></td>
					<td><div class="form-group"><input type="text" name="amount_total_1" id="amount_total_1" class="moneybox" value="" onblur="hesapla(1);"></div></td>
					<td><div class="form-group"><input type="text" name="row_total_price_1" id="row_total_price_1" style="width:100px;" class="moneybox" value="<cfoutput>#TLFormat(0,session.ep.our_company_info.purchase_price_round_num)#</cfoutput>" onblur="hesapla(2);"></div></td>
				</tr>
				</cfoutput>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cf_box_footer>
			<cf_record_info query_name="GET_PRODUCT_COST_INVOICE">
			<cf_workcube_buttons is_upd='0' add_function='control()'>
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
	$(document).ready(function(){
		row_count=<cfif GET_PRODUCT_COST_INVOICE.RECORDCOUNT><cfoutput>#GET_PRODUCT_COST_INVOICE.RECORDCOUNT#</cfoutput><cfelse>1</cfif>;
		hesapla(1);
		<cfif not GET_PRODUCT_COST_INVOICE.RECORDCOUNT>
			stocks_row(1);
		</cfif>
	});
	function open_spec(row){
		if(eval("document.price_protec_form.stock_id_"+row).value !='' && eval("document.price_protec_form.product_name_"+row).value !='')
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=price_protec_form.spect_main_id_'+row+'&field_name=price_protec_form.spect_main_name_'+row+'&is_display=1&stock_id='+eval("document.price_protec_form.stock_id_"+row).value,'list');
		}else{
			alert("<cf_get_lang dictionary_id='57725.Ürün Seçiniz'>!");
		}
	}
	function sil(sy)
	{
		var my_element=eval("price_protec_form.row_kontrol_"+sy);
		my_element.value=0;
		var my_element=eval("frm_row_"+sy);
		my_element.style.display="none";
	}
	function add_row()
	{		
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row_" + row_count);
		newRow.setAttribute("id","frm_row_" + row_count);		
		newRow.setAttribute("NAME","frm_row_" + row_count);
		newRow.setAttribute("ID","frm_row_" + row_count);		
		newRow.setAttribute("className","color-list");
		document.price_protec_form.record_num.value=row_count;
		document.all.row_sayisi=row_count
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="Sil"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol_' + row_count + '" value="1"><input type="hidden" name="product_id_' + row_count + '" value=""><input type="hidden" name="stock_id_' + row_count + '" value=""><div class="form-group"><div class="input-group"><input type="text" name="product_name_' + row_count + '" value=""><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=price_protec_form.product_id_' + row_count + '&field_id=price_protec_form.stock_id_' + row_count + '&field_name=price_protec_form.product_name_' + row_count + '&run_function=stocks_row&run_function_param='+row_count+'&keyword=\'+document.price_protec_form.product_name_' + row_count + '.value,\'list\');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="spect_main_id_' + row_count + '" value=""><div class="form-group"><div class="input-group"><input type="text" name="spect_main_name_' + row_count + '" value=""><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="open_spec(' + row_count + ');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","start_date_" + row_count + "_td");
		newCell.innerHTML = '<input type="text" name="start_date_' + row_count +'" id="start_date_' + row_count +'" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>" style="width:65px;" readonly>'; wrk_date_image("start_date_" + row_count,"stocks_row("+row_count+")");
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="cost_type_' + row_count +'" style="width:100px;"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><cfoutput query="GET_COST_TYPE"><option value="#COST_TYPE_ID#">#COST_TYPE_NAME#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="price_protection_type_' + row_count +'" style="width:100px;"><option value="1">Azalt</option><option value="-1">Artır</option></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" id="price_' + row_count +'" name="price_' + row_count +'" class="moneybox" value="'+commaSplit(0,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>)+'" onblur="hesapla(1);"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select id="price_protection_money_' + row_count +'" name="price_protection_money_' + row_count +'"><cfoutput query="GET_MONEY"><option value="#MONEY#">#MONEY#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><cfoutput><select name="department_' + row_count +'" id="department_' + row_count +'" onchange="calc_dep(this.value,'  +row_count + ');"><option value=""><cf_get_lang_main no="322.Seçiniz"></option><cfloop query="stores"><option value="#LOCATION_ID#">#LOCATION_NAME#</option> </cfloop></select></cfoutput></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="amount_' + row_count +'"  name="amount_' + row_count +'" class="moneybox" value="'+commaSplit(0,4)+'" onblur="hesapla(1);">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text"  id="amount_consignment_' + row_count +'" name="amount_consignment_' + row_count +'" class="moneybox" value="'+commaSplit(0,4)+'" onblur="hesapla(1);"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text"  id="amount_total_' + row_count +'" name="amount_total_' + row_count +'" class="moneybox" value="'+commaSplit(0,4)+'" onblur="hesapla(1);"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text"  id="row_total_price_' + row_count +'" name="row_total_price_' + row_count +'" style="width:100px;" class="moneybox" value="'+commaSplit(0,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>)+'" onblur="hesapla(2);"></div>';
	}
	
	function hesapla(type)
	{
		var total_price=0;
		for(var i=1;i <= row_count;i++){
			if(eval('document.price_protec_form.row_kontrol_'+i).value == 1)
			{	
				if($('#amount_consignment_'+i).val() == '')
				$('#amount_consignment_'+i).val(0);
				price= filterNum($('#price_'+i).val(),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				row_total_price = filterNum($('#row_total_price_'+i).val(),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				$('#amount_total_'+i).val(parseFloat($('#amount_'+i).val()) + parseFloat($('#amount_consignment_'+i).val()));
				amount = filterNum($('#amount_total_'+i).val(),4);
				if(type == 1) row_total_price=parseFloat(amount*price);
				else if(type == 2) price=parseFloat(row_total_price/amount);
				$('#price_'+i).val(commaSplit(price,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));
				$('#amount_total_'+i).val(commaSplit(amount,4));
				$('#row_total_price_'+i).val(commaSplit(row_total_price,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));
				
			}
		}
	}
	function calc_dep(dep_id,row)
	{
		stock_id = $('#stock_id_'+row).val();
		product_id = $('#product_id_'+row).val();
		start_date = $('#start_date_'+row).val();
		start_date= js_date(start_date);
		dep_id = $('#department_'+row).val();
		if(dep_id!= '')
		{
			sql_str = "SELECT ISNULL(SUM(STOCK_IN-STOCK_OUT),0) AS DEPARTMENT_STOCK FROM STOCKS_ROW WHERE STOCK_ID ="+ stock_id +" AND STORE =" + dep_id + "AND PROCESS_DATE <="+ start_date;
			my_query = wrk_query(sql_str,'dsn2');
			if(my_query.recordcount)
			$('#amount_'+row).val(commaSplit(parseFloat(my_query.DEPARTMENT_STOCK),4));
			cons_str = "SELECT ISNULL(SUM(INVOICE_AMOUNT),0) AS TOTAL_KONSINYE FROM GET_CONSIGMENT_PRODUCT_SALE WHERE PRODUCT_ID = "+product_id+" AND ACTION_DATE <="+ start_date + "<cfoutput>#dep_list#</cfoutput>";
			cons_query = wrk_query(cons_str,'dsn2');
			if(cons_query.recordcount)
			$('#amount_consignment_'+row).val(commaSplit(parseFloat(cons_query.TOTAL_KONSINYE),4));
		}
		else
		{
			$('#amount_'+row).val(commaSplit(0,4));
			$('#amount_consignment_'+row).val(commaSplit(0,4));
		}
		amount_ = parseFloat(filterNum($('#amount_'+row).val(),4));
		cons_ = parseFloat(filterNum($('#amount_consignment_'+row).val(),4));
		total_amount =amount_ + cons_;	
		$('#amount_total_'+row).val(commaSplit(total_amount,4));
		total_calc = filterNum($('#amount_total_'+row).val(),4)*filterNum($('#price_'+row).val(),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		$('#row_total_price_'+row).val(commaSplit(parseFloat(total_calc),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));
	}
	
	
	function control(){
		for(var i=1;i <= row_count;i++){
			if(eval('document.price_protec_form.row_kontrol_'+i).value == 1)
			{
				if(parseFloat(filterNum(eval('document.price_protec_form.price_'+i).value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>))==0){
					alert("<cf_get_lang dictionary_id='30488.Fiyatları Kontrol Ediniz'>!");
					return false;
				}
				if(parseFloat(filterNum(eval('document.price_protec_form.amount_'+i).value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>))==0){
					alert("<cf_get_lang dictionary_id='38519.Miktarları Kontrol Ediniz'>!");
					return false;
				}
				if(eval("document.price_protec_form.stock_id_"+i).value =='' || eval("document.price_protec_form.product_name_"+i).value ==''){
					alert('Ürün Seçiniz!');
					return false;
				}
			}
		}
		pre_submit_clear();
		return true;
	}
	function pre_submit_clear(){
		for(var i=1;i <= row_count;i++){
			eval('document.price_protec_form.price_'+i).value = filterNum(eval('document.price_protec_form.price_'+i).value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			eval('document.price_protec_form.amount_'+i).value = filterNum(eval('document.price_protec_form.amount_'+i).value,4);
			eval('document.price_protec_form.amount_total_'+i).value = filterNum(eval('document.price_protec_form.amount_total_'+i).value,4);
			eval('document.price_protec_form.amount_consignment_'+i).value = filterNum(eval('document.price_protec_form.amount_consignment_'+i).value,4);
			eval('document.price_protec_form.row_total_price_'+i).value = filterNum(eval('document.price_protec_form.row_total_price_'+i).value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		}
	}
	function stocks_row(rw){
		if(eval('price_protec_form.spect_main_id_'+rw).value!="" && eval('price_protec_form.spect_main_name_'+rw).value!="")
		{
			var spec_query= "obj_gt_stoc_3";
			var listParam = eval("price_protec_form.product_id_"+rw).value + "*" + js_date(eval("price_protec_form.start_date_"+rw).value) + "*" + eval('price_protec_form.spect_main_id_'+rw).value;
		}
		else
		{
			var spec_query= "obj_gt_stoc_4";
			var listParam = eval("price_protec_form.product_id_"+rw).value + "*" + js_date(eval("price_protec_form.start_date_"+rw).value);
		}
		if(eval("price_protec_form.product_id_"+rw).value != '')
		{
			var gt_stoc=wrk_safe_query(spec_query,'dsn2',0,listParam);
			if(gt_stoc.recordcount)
				eval('price_protec_form.amount_'+rw).value = commaSplit(gt_stoc.PRODUCT_TOTAL_STOCK,4);
			else
				eval('price_protec_form.amount_'+rw).value = '<cfoutput>#tlformat(0,4)#</cfoutput>';
		}
	}
</script>