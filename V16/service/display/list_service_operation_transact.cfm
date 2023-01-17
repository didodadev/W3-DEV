<cf_xml_page_edit fuseact="service.add_service">
<cfinclude template="../query/get_service_detail.cfm">
<cfif x_select_amount and len(get_service_detail.subscription_id)>
	<cfset subscription_id = get_service_detail.subscription_id>
<cfelse>
	<cfset subscription_id = "">
</cfif>
<cfquery name="GET_SERVICE_SPARE_PART" datasource="#DSN3#">
	SELECT SPARE_PART,SPARE_PART_ID FROM SERVICE_SPARE_PART
</cfquery>
<cfquery name="GET_OPERATION_ROW" datasource="#DSN3#">
	SELECT 
    	AMOUNT,
        PREDICTED_AMOUNT,
        WRK_ROW_ID,
        SPARE_PART_ID,
        SERVICE_EMP_ID,
        SERIAL_NO,
        STOCK_ID,
        PRODUCT_ID,
        DETAIL,
        UNIT_ID,
        UNIT,
        PRICE,
        TOTAL_PRICE,
        CURRENCY,
        IS_TOTAL,
        SERVICE_OPE_ID,
		TAX
    FROM 
    	SERVICE_OPERATION 
    WHERE 
    	SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfset operation_row = get_operation_row.recordcount>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT 
    	MONEY,RATE1,
        RATE2 
    FROM 
    	SETUP_MONEY 
    WHERE 
    	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY MONEY DESC
</cfquery>
<!--- Şirket Akış Parametreleri - Garanti Takip Tamir ve Seri No Uygulansın Mı Seçeneğine Bağlı Olarak Seri No Alanini Getirir --->
<cfquery name="GET_OUR_COMP_INFO" datasource="#DSN#">
	SELECT IS_GUARANTY_FOLLOWUP FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="Get_Invoice_Service" datasource="#dsn3#">
	SELECT INVOICE_ID FROM SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfform name="add_service" id="add_service" method="post" action="#request.self#?fuseaction=service.emptypopup_upd_service_operation">

	    <cfoutput>
        <input type="hidden" name="service_id" id="service_id" value="#url.service_id#">
        <input type="hidden" name="convert_service_id" id="convert_service_id" value="">
        <input type="hidden" name="convert_stocks_id" id="convert_stocks_id" value="">
        <input type="hidden" name="list_no" id="list_no" value="">
        <input type="hidden" name="convert_products_id" id="convert_products_id" value="">
        <input type="hidden" name="convert_spect_id" id="convert_spect_id" value="">
        <input type="hidden" name="convert_amount_stocks_id" id="convert_amount_stocks_id" value="">
        <input type="hidden" name="convert_price" id="convert_price" value="">
        <input type="hidden" name="convert_price_other" id="convert_price_other" value="">
        <input type="hidden" name="convert_money" id="convert_money" value="">
        <input type="hidden" name="convert_cost_price" id="convert_cost_price" value="" />
        <input type="hidden" name="convert_extra_cost" id="convert_extra_cost" value="" />
        <input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#" />
        <input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.member_id#" />
        </cfoutput>
        <!--- <input type="hidden" name="process_cat_id" id="process_cat_id" value="23" /> id gonderilir mi, sabit bir deger degilki??????? FBS20130322 --->
        <input type="hidden" name="record_num" id="record_num" value="0">
		<cf_grid_list>
			<thead>
				<tr>
					<cfset colspan="4">
					<th width="20"><a onclick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>			
					<th width="500"><cf_get_lang dictionary_id='57692.İşlem'>*</th>
					<cfif x_select_employee neq 0>
						<cfset colspan=colspan+1>
						<th width="200"><cf_get_lang dictionary_id='41644.İşlemi Yapan'><cfif x_select_employee eq 2>*</cfif></th>
					</cfif>
					<cfif get_our_comp_info.recordcount and get_our_comp_info.is_guaranty_followup eq 1>
						<cfset colspan=colspan+1>
						<th width="50"><cf_get_lang dictionary_id='57637.Seri No'></th>
					</cfif>
					<th width="300px"><cf_get_lang dictionary_id='57629.Açıklama'>/<cf_get_lang dictionary_id='57657.Ürün'></th>
					<cfif x_select_amount eq 1>
						<cfset colspan=colspan+2>
						<th width="50px"><cf_get_lang dictionary_id='41665.Öngörülen Miktar'></th>
						<th  width="70px"><cf_get_lang dictionary_id='57635.Miktar'></th>
					</cfif>
					<cfif x_select_unit eq 1>
						<cfset colspan=colspan+1>
						<th width="70px"><cf_get_lang dictionary_id='57636.Birim'></th>
					</cfif>
					<th width="70px"><cf_get_lang dictionary_id='58084.Fiyat'></th>
					<th ><cf_get_lang dictionary_id='57673.Tutar'></th>
					<th width="80px"><cf_get_lang dictionary_id='57489.Para Br'></th>
					<th><cf_get_lang dictionary_id='41649.Toplama Dahil'></th>
					<th><cf_get_lang dictionary_id='58676.Aktar'></th>
				</tr>	
			</thead>		
			<tbody id="table1">
				<cfif get_operation_row.recordcount>
					<cfoutput query="get_operation_row">
					<cfset get_setup_money_id = trim(get_operation_row.currency)>
					<cfquery name="Get_Money_Type" datasource="#DSN#">
						SELECT 
							MONEY 
						FROM 
							SETUP_MONEY 
						WHERE 
							PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> 
							AND MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> 
							AND MONEY = '#get_setup_money_id#'
						ORDER BY 
							MONEY DESC
					</cfquery>
					<tr id="frm_row#currentrow#">
						<td><cfset my_amount_ = replace(amount,'.',',')>
							<cfset my_total_price_ = replace(total_price,'.',',')>
							<cfset my_price_ = replace(price,'.',',')>
							<input type="hidden" name="wrk_row_id#currentrow#" id="wrk_row_id#currentrow#" value="#wrk_row_id#">
							<input type="hidden" name="wrk_row_id_#currentrow#" id="wrk_row_id_#currentrow#" value="#wrk_row_id#">
							<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
							<input type="hidden" name="related_action_id#currentrow#" id="related_action_id#currentrow#" value="#service_ope_id#">
							<input type="hidden" name="related_action_table#currentrow#" id="related_action_table#currentrow#" value="SERVICE_OPERATION">
							<input type="hidden" name="money_type_#currentrow#" id="money_type_#currentrow#" value="#Get_Money_Type.Money#"  onchange="toplam_kontrol(#currentrow#);" >
							<input type="hidden" name="product_id_#currentrow#" id="product_id_#currentrow#" value="#product_id#">
							<input type="hidden" name="stock_id_#currentrow#" id="stock_id_#currentrow#" value="#stock_id#">
							<input type="hidden" name="net_total_#currentrow#" id="net_total_#currentrow#" value="#my_total_price_#" onblur="return toplam_kontrol();" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly>
							<input type="hidden" name="price_#currentrow#" id="price_#currentrow#" value="#my_price_#" class="moneybox" onblur="fiyat_hesapla('#currentrow#');" <cfif x_change_price eq 1>readonly</cfif>>
							<input type="hidden" name="quantity_#currentrow#" id="quantity_#currentrow#" value="#my_amount_#" onblur="fiyat_hesapla('#currentrow#');" onkeyup="FormatCurrency(this,event);" class="moneybox">
							<input type="hidden" name="kdv_rate_#currentrow#" id="kdv_rate_#currentrow#" readonly="readonly" class="boxtext" value="#TAX#">
							<a onclick="sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
						</td>			
						<td>
							<div class="form-group">
								<cf_wrk_selectlang 
									name="spare_part_type#currentrow#"
									width="100"
									table_name="SERVICE_SPARE_PART"
									option_name="SPARE_PART"
									option_value="SPARE_PART_ID"
									data_source="#DSN3#"
									value="#spare_part_id#">
							</div>
						</td>
						<cfif x_select_employee neq 0>
							<td>
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="employee_id_#currentrow#" id="employee_id_#currentrow#" value="#service_emp_id#">
										<input type="text" name="employee_name_#currentrow#" id="employee_name_#currentrow#" value="#get_emp_info(service_emp_id,0,0)#" onfocus="autocomp_employee(#currentrow#);" class="text">
										<span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_employee1(#currentrow#);"></span>
									</div>
								</div>
							</td>
						</cfif>
						<cfif  get_our_comp_info.recordcount and get_our_comp_info.is_guaranty_followup eq 1>
							<td><div class="form-group"><input type="text" name="serial_no_#currentrow#" id="serial_no_#currentrow#" value="<cfif len(serial_no)>#serial_no#</cfif>" onkeydown="if(event.keyCode == 13) {get_product_detail(this.value,#currentrow#);return false;}" autocomplete="off"></div></td>
						</cfif>
						<td>
							<div class="form-group">
								<input type="hidden" name="product_catid#currentrow#" id="product_catid#currentrow#" value="" />
								<input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#stock_id#">
								<input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
								<div class="input-group">
									<input type="text" name="product#currentrow#" id="product#currentrow#" value="#detail#" onfocus="AutoComplete_Create('product#currentrow#','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0,0,-2','PRODUCT_ID,STOCK_ID,PRODUCT_UNIT_ID,MAIN_UNIT,PRODUCT_CATID,PRICE,PRICE,RATE2','product_id#currentrow#,stock_id#currentrow#,unit_id#currentrow#,unit_name#currentrow#,product_catid#currentrow#,price#currentrow#,total_price#currentrow#,money#currentrow#','add_services',1,'','get_service_cat(#currentrow#)');">
									<span class="input-group-addon icon-ellipsis font-blue btnPointer"  onclick="pencere_ac_product('#currentrow#');"></span>
									<span class="input-group-addon icon-ellipsis font-red-mint btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#&sid=#stock_id#','list');"></span>
								</div>
							</div>
						</td>
						<cfif x_select_amount eq 1>
							<td><div class="form-group"><cfset my_pred_amount_ = replace(predicted_amount,'.',',')>
								<input type="text" name="predicted_amount#currentrow#" id="predicted_amount#currentrow#" value="#my_pred_amount_#" onkeyup="same_amount('#currentrow#');FormatCurrency(this,event);" class="moneybox"></div>
							</td>
							<td><cfset my_amount_ = replace(amount,'.',',')>
								<div class="form-group"><input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#my_amount_#" onblur="fiyat_hesapla('#currentrow#');" onkeyup="FormatCurrency(this,event);" class="moneybox"></div>
							</td>
						</cfif>
						<cfif x_select_unit eq 1>
							<td><div class="form-group">
								<input type="hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="<cfif isdefined('unit_id')>#unit_id#</cfif>">
								<input type="text" name="unit_name#currentrow#" id="unit_name#currentrow#" value="#unit#" readonly></div>
							</td>
						</cfif>
						<td><div class="form-group"><input type="text" name="price#currentrow#" id="price#currentrow#" value="#tlformat(price)#" class="moneybox" onblur="fiyat_hesapla('#currentrow#');" <cfif x_change_price eq 1>readonly</cfif>></div></td>
						<td><div class="form-group"><input type="text" name="total_price#currentrow#" id="total_price#currentrow#" value="#tlformat(total_price)#" onblur="return toplam_kontrol();" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly></div></td>
						<td>
							<div class="form-group">
								<select name="money#currentrow#" id="money#currentrow#" onchange="toplam_kontrol(#currentrow#);">
									<cfset get_setup_money_id = trim(get_operation_row.currency)>
									<cfloop query="get_money">
										<option value="#money#;#rate1#;#rate2#" <cfif get_money.money eq get_setup_money_id>selected</cfif>>#get_money.money#</option>
									</cfloop>
								</select>
							</div>
						</td>
						<td class="text-center"><div class="form-group"><input type="checkbox" name="is_total#currentrow#" id="is_total#currentrow#" value="1" onclick=" fiyat_hesapla('#currentrow#');" <cfif is_total eq 1>checked</cfif>></div></td>
						<td class="text-center"><div class="form-group"><input type="checkbox" name="service_operation_id#currentrow#" id="service_operation_id#currentrow#" value="#service_ope_id#"></div></td>
					</tr>
					<tr id="frm_row_#currentrow#" style="display:none">
						<td colspan="3"></td>
						<td><div id="check_product_layer#currentrow#" style="position:absolute;"></div></td>
						<td colspan="8"></td>
					</tr>
					</cfoutput>
				</cfif>
			</tbody>
			<tfoot>							
				<tr>
					<td  colspan="<cfoutput>#colspan#</cfoutput>" class="moneybox bold" ><cf_get_lang dictionary_id='29534.Toplam Tutar'> :</td>
					<td ><input type="text" name="toplam_tutar"  id="toplam_tutar" value="" readonly="" class="moneybox"></td>
					<td><cfoutput>#session.ep.money#</cfoutput> </td>
					<td colspan="2"> </td>
				</tr>                          
			</tfoot>
		</cf_grid_list>
		<div class="ui-info-bottom flex-end">						
			<cf_workcube_buttons is_upd='1' is_cancel='0' is_delete='0' add_function='kontrol()' type_format="1">
			<cfif Get_Operation_Row.RecordCount>
				<cfif not len(Get_Invoice_Service.Invoice_Id)>
					<div class="margin-top-5"><input type="button" value="<cf_get_lang dictionary_id='45595.Fatura Kes'>" onclick="sendToInvoice();"/></div>
				</cfif>
				<cfif session.ep.our_company_info.subscription_contract eq 1 and x_send_to_subscription eq 1>
					<div class="margin-top-5"><input type="button" value="<cf_get_lang dictionary_id='41651.Sisteme Aktar'>" onclick="sendToSubscription();"/></div>
				</cfif>
				<div class="margin-top-5"><input type="button" value="<cf_get_lang dictionary_id='41654.İrsaliyeye Aktar'>" onclick="sendToShip();"/></div>
				<div class="margin-top-5"><input type="button" value="<cf_get_lang dictionary_id='64389.Sarf Fişi Oluştur'>" onclick="sendToFis();"/></div>
				<div class="margin-top-5"><input type="button" value="<cf_get_lang dictionary_id='32698.İç Talep Oluştur'>" onclick="addOrder();"/></div>
			</cfif>
		</div>
</cfform>
<script type="text/javascript">
	row_count=<cfoutput>#operation_row#</cfoutput>;
	kontrol_row_count=<cfoutput>#operation_row#</cfoutput>;
	document.getElementById('record_num').value = row_count;
	
	function pencere_ac_employee1(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_service.employee_id_' + no +'&field_name=add_service.employee_name_' + no +'&select_list=1,9');
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
	
		document.add_service.record_num.value=row_count;
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" id="kdv_rate_'+row_count+'" name="kdv_rate_'+row_count+'" value=""><input type="hidden" name="wrk_row_id'+row_count+'" value="'+js_create_unique_id()+'"><input type="hidden" value="1" name="row_kontrol' + row_count + '"><a onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';				

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select id="spare_part_type' + row_count + '" name="spare_part_type' + row_count + '"><option value="">Seçiniz</option><cfoutput query="GET_SERVICE_SPARE_PART" ><option value="#GET_SERVICE_SPARE_PART.SPARE_PART_ID#" >#GET_SERVICE_SPARE_PART.SPARE_PART#</option></cfoutput></select></div>';
	
		<cfif x_select_employee neq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('class', 'inputTd');
			newCell.innerHTML = '<div class="form-group"><input type="hidden" id="employee_id_' + row_count +'" name="employee_id_' + row_count +'" value="<cfoutput>#session.ep.userid#</cfoutput>"><div class="input-group"><input type="text" id="employee_name_' + row_count +'" name="employee_name_' + row_count +'" onFocus="autocomp_employee('+row_count+');"  value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>"><span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:pencere_ac_employee1(' + row_count + ');"></span></div></div>';
		</cfif>
		<cfif  get_our_comp_info.recordcount and get_our_comp_info.is_guaranty_followup eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="serial_no_' + row_count +'" id="serial_no_' + row_count +'" autocomplete="off" onkeydown="if(event.keyCode == 13) {get_product_detail(this.value,'+row_count+');return false;}"></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('class', 'inputTd');
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="product_catid' + row_count +'" id="product_catid' + row_count +'"><input type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'"><input type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'"><div class="input-group"><input type="text" name="product' + row_count +'" id="product' + row_count +'"  onFocus="autocomp_product('+row_count+');"><span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:pencere_ac_product(' + row_count + ');"></span></div></div>';
		
		<cfif x_select_amount eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="predicted_amount' + row_count +'" id="predicted_amount' + row_count +'" onkeyup="same_amount(' + row_count +');FormatCurrency(this,event);" value="1" class="moneybox"></div>';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="amount' + row_count +'" id="amount' + row_count +'" onkeyup="return(FormatCurrency(this,event));" value="1" class="moneybox" onBlur="fiyat_hesapla(' + row_count + ');"></div>';
		</cfif>
		
		<cfif x_select_unit eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="hidden" name="unit_id' + row_count +'" id="unit_id' + row_count +'"><input type="text" name="unit_name' + row_count +'" id="unit_name' + row_count +'" value="" readonly></div>';
		</cfif>
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="price' + row_count +'" id="price' + row_count +'" value="" <cfif x_change_price eq 1>readonly</cfif> onBlur="fiyat_hesapla(' + row_count + ');" class="moneybox"></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="total_price' + row_count +'" id="total_price' + row_count +'" value="" onBlur="toplam_kontrol(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="money' + row_count +'" id="money' + row_count +'" onchange="toplam_kontrol(' + row_count + ');"><cfoutput query="get_money"><option value="#get_money.money#;#rate1#;#rate2#">#get_money.money#</option></cfoutput></select></div>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="checkbox" value="1" name="is_total' + row_count + '" id="is_total' + row_count + '" onclick=" fiyat_hesapla(' + row_count + ');" checked></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="checkbox" value="1" name="service_operation_id' + row_count + '" id="service_operation_id' + row_count + '" checked></div>';
	
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row_" + row_count);
		newRow.setAttribute("id","frm_row_" + row_count);
		newRow.style.display = 'none';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('colSpan', '3');
		newCell.innerHTML = '&nbsp;';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div id="check_product_layer'+row_count+'" style="position:absolute;"></div>&nbsp;';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('colSpan', '8');
		newCell.innerHTML = '&nbsp;';
	
	}
	
	function sil(sy)
	{
		var my_element=eval("add_service.row_kontrol"+sy);		
		my_element.value=0;
		
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		toplam_kontrol()
	}
	
	function pencere_ac_product(no)
	{
		<cfif x_prod_calc_sub_contract and isdefined('attributes.subscription_id') and len(attributes.subscription_id)>
			SBR_VALUE = <cfoutput>#attributes.subscription_id#</cfoutput>;
			sbr = '&subscription_id='+SBR_VALUE;
		<cfelse>
			sbr = '';
		</cfif>
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_price_unit'+ sbr+'&company_id=#attributes.company_id#</cfoutput>&field_stock_id=add_service.stock_id'+ no +'&field_id=add_service.product_id'+ no +'&field_name=add_service.product'+ no +'&field_amount=add_service.amount'+ no +'&field_unit_id=add_service.unit_id'+ no+'&field_unit=add_service.unit_name'+ no+'&field_price=add_service.price'+ no+'&field_total_price=add_service.total_price'+ no+'&field_money_rate=add_service.money'+ no+'&field_product_catid=add_service.product_catid'+ no+'&count='+no+'&field_tax=add_service.kdv_rate_'+ no +'&fnk=1');
	}	
	
	function pencere_ac_date(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan=add_service.operation_date' + no,'date');
	}	
	
	function kontrol()
	{
		if(row_count == 0 || kontrol_row_count == 0)
		{
			alert("<cf_get_lang dictionary_id='54697.En Az Bir Servis İşlem Kaydı Girmelisiniz'> !");
			return false;
		}
		
		static_row=0;
		for(r=1;r<=row_count;r++)		
		{
			if(eval("document.add_service.row_kontrol"+r).value == 1)
			{	
				static_row++;
				deger_product_id = eval("document.add_service.product_id"+r);
				deger_spare_part_type = eval("document.add_service.spare_part_type"+r);
				if(deger_spare_part_type.value=="")
				{
					alert(static_row+".<cf_get_lang dictionary_id='64390.Satır İşlem Seçmelisiniz'> !");
					return false;
				}			
				<cfif x_select_employee eq 2>
					if(eval("document.add_service.employee_id_"+r).value=="" || eval("document.add_service.employee_name_"+r).value=="")
					{
						alert(static_row+".<cf_get_lang dictionary_id='64391.Satır İşlem Yapan Girmelisiniz'> !");
						return false;
					}
				</cfif>
				if(eval("document.add_service.product_id"+r).value=="" || eval("document.add_service.product"+r).value=="")
				{
					alert(static_row+".<cf_get_lang dictionary_id='54700.Satır Ürün Girmelisiniz'> !");
					return false;
				}
				<cfif x_select_amount>
				if(document.getElementById('amount'+r).value == 0)
                {
                    alert(static_row+".<cf_get_lang dictionary_id='64392.Satır İçin Geçerli Miktar Girmelisiniz'> !");
                    return false;    
                }
				</cfif>
				<cfif x_select_amount eq 1>
					deger_pred_amount = eval("document.add_service.predicted_amount"+r);
					if(deger_pred_amount.value=="")
					{
						alert(static_row+".<cf_get_lang dictionary_id='64393.Satır Öngörülen Miktar Girmelisiniz'> !");
						return false;
					}

					deger_amount = eval("document.add_service.amount"+r);
					if(deger_amount.value=="")
					{
						alert(static_row+".<cf_get_lang dictionary_id='54701.Satır Miktar Girmelisiniz'> !");
						return false;
					}
				</cfif>
			}
			
		}
		
		unformat_fields();
		return true;
	}
	
	function autocomp_employee(no)
	{
		AutoComplete_Create("employee_name_"+no,"MEMBER_NAME","MEMBER_NAME","get_member_autocomplete","3","EMPLOYEE_ID","employee_id_"+no,"",3,140);
	}
	
	function autocomp_product(no)
	{
		AutoComplete_Create("product"+no,"PRODUCT_NAME","PRODUCT_NAME,STOCK_CODE","get_product_autocomplete","0,0,-2","PRODUCT_ID,STOCK_ID,PRODUCT_UNIT_ID,MAIN_UNIT,PRODUCT_CATID,PRICE,PRICE,RATE2","product_id"+no+",stock_id"+no+",unit_id"+no+",unit_name"+no+",product_catid"+no+",price"+no+",total_price"+no+",money"+no,"add_services",1,"","get_service_cat("+no+")");
		
	}
	
	function fiyat_hesapla(satir)
	{
		<cfif x_select_amount eq 1>
			amount_ = parseFloat(filterNum(eval("add_service.amount"+satir).value));
		<cfelse>
			amount_ = 1;
		</cfif>
		if(eval("add_service.price"+satir).value.length != 0 && eval("add_service.is_total"+satir).checked==true)
		{
			eval("document.add_service.total_price" + satir).value =  parseFloat(filterNum(eval("document.add_service.price"+satir).value) * amount_);
			eval("add_service.total_price" + satir).value = commaSplit(eval("add_service.total_price" + satir).value);
			//eval("document.add_service.total_price" + satir).value =  parseFloat(filterNum(eval("document.add_service.price"+satir).value) * amount_);
			//eval("add_service.total_price" + satir).value = parseFloat(eval("add_service.total_price" + satir).value);
			if(document.getElementById('price_'+satir)!= null){
				eval("document.add_service.net_total_" + satir).value =  parseFloat(filterNum(eval("document.add_service.price_"+satir).value) * amount_);
				eval("add_service.net_total_" + satir).value = parseFloat(eval("add_service.net_total_" + satir).value);
			}
		}
		toplam_kontrol();
		return true;
	}
	
	function unformat_fields()
	{
		for(r=1;r<=row_count;r++)
		{
			if(eval("document.add_service.row_kontrol"+r).value == 1)
			{
				fiyat_hesapla(r);
				<cfif x_select_amount eq 1>
					eval("document.add_service.amount"+r).value = filterNum(eval("document.add_service.amount"+r).value);
					eval("document.add_service.predicted_amount"+r).value = parseFloat(filterNum(eval("document.add_service.predicted_amount"+r).value));
					//eval("document.add_service.amount"+r).value = parseFloat(filterNum(eval("document.add_service.amount"+r).value));
				</cfif>
			//	eval("document.add_service.price"+r).value = parseFloat(filterNum(eval("document.add_service.price"+r).value));
			//	eval("document.add_service.total_price"+r).value = parseFloat(filterNum(eval("document.add_service.total_price"+r).value));
				eval("document.add_service.price"+r).value = filterNum(eval("document.add_service.price"+r).value);
				eval("document.add_service.total_price"+r).value = filterNum(eval("document.add_service.total_price"+r).value);
				if(document.getElementById('price_'+r)!= null){
					eval("document.add_service.price_"+r).value = parseFloat(filterNum(eval("document.add_service.price_"+r).value));
					eval("document.add_service.net_total_"+r).value = parseFloat(filterNum(eval("document.add_service.net_total_"+r).value));
				}
			}
		}
	}
	
	function toplam_kontrol()
		{	
			var sira_no=0;
			sira_no=document.add_service.record_num.value;
			toplam_al(sira_no);
			return true;
		}
	
	function toplam_al(sira)
	{	
		document.add_service.toplam_tutar.value=0;
		var toplam_1=0;
		for(var i=1; i <= sira; i++)
			if(eval("add_service.row_kontrol"+i).value > 0 && eval("add_service.is_total"+i).checked==true)
				{
					if(eval("document.add_service.total_price"+i).value != '')
					{
						var ara_toplam=filterNum(eval("document.add_service.total_price"+i).value);
						if(ara_toplam!= null && ara_toplam.value != "")
						{
							deger_money = eval("document.add_service.money"+i);
							toplam_1 = parseFloat(toplam_1 + (parseFloat(ara_toplam) * (parseFloat(list_getat(deger_money.value,3,';')) / parseFloat(list_getat(deger_money.value,2,';')))));
							document.add_service.toplam_tutar.value=commaSplit(toplam_1);
						}
					}
				}
		
	}
	toplam_kontrol();
	
	function sendToSubscription()
	{
		if(document.getElementById('record_num').value > 1)
		{
			service_list_ = "";
			for (i=1; i <= document.getElementById('record_num').value; i++)
			{
				if(eval("document.getElementById('service_operation_id" + i + "')").checked == true)
				{
					service_list_ = service_list_ + eval("document.getElementById('service_operation_id" + i + "')").value + ',';
					if(eval("document.getElementById('spare_part_type" + i + "')").value=="")
					{
						alert(i+".<cf_get_lang dictionary_id='64390.Satır İşlem Seçmelisiniz'> !");
						return false;
					}	
					if(!eval("document.getElementById('related_action_id" + i + "')"))
					{
						alert(i+".<cf_get_lang dictionary_id='64402.Yeni eklenen satırlar olduğu için öncelikle ürün servis işlemlerini güncellemelisiniz!'>");
						return false;
					}	
				}
			}

			if(service_list_.length == 0)
			{
				alert('<cf_get_lang dictionary_id='64394.Sisteme Aktarılacak İşlem Seçmelisiniz'>!');
				return false;
			}		
		}
		else if(document.getElementById('record_num').value == 1)
		{
			if(document.getElementById('service_operation_id1').checked == false)
			{
				alert('<cf_get_lang dictionary_id='64394.Sisteme Aktarılacak İşlem Seçmelisiniz'>!');
				return false;
			}
		}
		if(document.upd_service.subscription_id != undefined && (document.upd_service.subscription_id.value == '' || document.upd_service.subscription_no.value == ''))
		{
			alert('<cf_get_lang dictionary_id='64395.Sistem Seçmelisiniz'>!');
			return false;
		}
		document.add_service.action='<cfoutput>#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id='+document.upd_service.subscription_id.value</cfoutput>;
		document.add_service.target='blank';
		document.add_service.submit();
	}
		
	function sendToShip()
	{
		<cfif not get_operation_row.recordcount>
			alert('<cf_get_lang dictionary_id='64396.İrsaliye Kesilecek İşlem Seçmelisiniz'>!');
			return false;
		</cfif>
		service_list_ = "";

		if(document.getElementById('record_num').value > 1)
		{
			
			for (i=1; i <= document.getElementById('record_num').value; i++)
			{
				if(eval("document.getElementById('service_operation_id" + i + "')").checked == true){
					if(service_list_ == '')
						service_list_ = service_list_ + eval("document.getElementById('service_operation_id" + i + "')").value;
					else
						service_list_ = service_list_ + ',' + eval("document.getElementById('service_operation_id" + i + "')").value ;
					if(eval("document.getElementById('spare_part_type" + i + "')").value=="")
					{
						alert(i+".<cf_get_lang dictionary_id='64390.Satır İşlem Seçmelisiniz'> !");
						return false;
					}	
					if(!eval("document.getElementById('related_action_id" + i + "')"))
					{
						alert(i+".<cf_get_lang dictionary_id='64402.Yeni eklenen satırlar olduğu için öncelikle ürün servis işlemlerini güncellemelisiniz!'>");
						return false;
					}	
				}
			}

			if(service_list_.length == 0)
			{
				alert('<cf_get_lang dictionary_id='64396.İrsaliye Kesilecek İşlem Seçmelisiniz'>!');
				return false;
			}		
		}
		else if(document.getElementById('record_num').value == 1)
		{
			if(document.getElementById('service_operation_id1').checked == false)
			{
				alert('<cf_get_lang dictionary_id='64396.İrsaliye Kesilecek İşlem Seçmelisiniz'>!');
				return false;
			}
			service_list_ = service_list_ + document.getElementById('service_operation_id1').value;
		}

	//	windowopen('','wide','ship_window');
		document.add_service.action='<cfoutput>#request.self#?fuseaction=stock.form_add_sale&is_from_operations=1&service_ids=#attributes.service_id#&service_operation_id=' + service_list_ + '</cfoutput>';
	//	document.add_service.target='ship_window';
		document.add_service.target='blank_';
		document.add_service.submit();
	}
		
	function sendToFis()
	{
		 var convert_list = "";
		 var convert_list_amount = "";
		 var convert_list_price = "";
		 var convert_list_price_other = "";
		 var convert_list_money = "";
		 var convert_cost_price = "";
		 var convert_extra_cost = "";
		 
		 for(var i =1 ; i<=document.getElementById('record_num').value; ++i)
		 {
			if(document.getElementById('service_operation_id'+i).checked == true && document.getElementById('stock_id'+i).value != '')
			{
				 <cfif x_select_amount eq 1>
					 if(document.getElementById('amount'+i) != undefined && filterNum(document.getElementById('amount'+i).value) > 0)
					 {
						convert_list += document.getElementById('stock_id'+i).value+",";
						convert_list_amount += parseFloat(filterNum(document.getElementById('amount'+i).value,3))+',';
						convert_list_price_other += 0+',';
						convert_list_price += parseFloat(filterNum(document.getElementById('price'+i).value,3))+',';
						convert_cost_price += 0+',';
						convert_extra_cost += 0+',';
						convert_list_money += list_getat(document.getElementById('money'+i).value,1,';')+',';
					 }
				<cfelse>
					amount_ = 1;
					convert_list += document.getElementById('stock_id'+i).value+",";
					convert_list_amount += parseFloat(filterNum(amount_,3))+',';
					convert_list_price_other += 0+',';
					convert_list_price += parseFloat(filterNum(document.getElementById('price'+i).value,3))+',';
					convert_cost_price += 0+',';
					convert_extra_cost += 0+',';
					convert_list_money += list_getat(document.getElementById('money'+i).value,1,';')+',';
				</cfif>
			}
			else if(eval("document.getElementById('spare_part_type" + i + "')").value=="")
			{
				alert(i+".<cf_get_lang dictionary_id='64390.Satır İşlem Seçmelisiniz'> !");
				return false;
			}
			else if(!eval("document.getElementById('related_action_id" + i + "')"))
			{
				alert(i+".<cf_get_lang dictionary_id='64402.Yeni eklenen satırlar olduğu için öncelikle ürün servis işlemlerini güncellemelisiniz!'>");
				return false;
			}	
			else 
			{
				alert(i+".<cf_get_lang dictionary_id='58227.Ürün Seçmelisiniz'>!");
				return false;
			}

		}
		document.getElementById('convert_stocks_id').value = convert_list;
		document.getElementById('convert_amount_stocks_id').value = convert_list_amount;
		document.getElementById('convert_price').value = convert_list_price;
		document.getElementById('convert_price_other').value = convert_list_price_other;
		document.getElementById('convert_money').value = convert_list_money;
		document.getElementById('convert_cost_price').value = convert_cost_price;
		document.getElementById('convert_extra_cost').value = convert_extra_cost;
		document.getElementById('add_service').action="<cfoutput>#request.self#?fuseaction=stock.form_add_fis&type=convert&service_id=#attributes.service_id#&service=#URLEncodedFormat(get_service_detail.service_no)#</cfoutput>";
		document.getElementById('add_service').submit();
		return true;
	}
	
	function sendToInvoice(str)
	{
		if(document.getElementById('record_num').value > 1)
		{
			service_list_ = "";
			for (i=1; i <= document.getElementById('record_num').value; i++)
			{
				if(eval("document.getElementById('service_operation_id" + i + "')").checked == true)
				{
					service_list_ = service_list_ + eval("document.getElementById('service_operation_id" + i + "')").value + ',';
					if(eval("document.getElementById('spare_part_type" + i + "')").value=="")
					{
						alert(i+".<cf_get_lang dictionary_id='64390.Satır İşlem Seçmelisiniz'> !");
						return false;
					}	
					if(!eval("document.getElementById('related_action_id" + i + "')"))
					{
						alert(i+".<cf_get_lang dictionary_id='64402.Yeni eklenen satırlar olduğu için öncelikle ürün servis işlemlerini güncellemelisiniz!'>");
						return false;
					}	
				}
				
			}

			if(service_list_.length == 0)
			{
				alert('<cf_get_lang dictionary_id='64397.Fatura Kesilecek İşlem Seçmelisiniz'>!');
				return false;
			}		
		}
		else if(document.getElementById('record_num').value == 1)
		{
			if(document.getElementById('service_operation_id1').checked == false)
			{
				alert('<cf_get_lang dictionary_id='64397.Fatura Kesilecek İşlem Seçmelisiniz'>!');
				return false;
			}
		}

		 var convert_list = "";
		 var convert_related_action_id_list = "";
		 var convert_related_action_table_list = "";
		 var convert_money_type_list = "";
		 var convert_net_total_list = "";
		 var convert_quantity_list = "";
		 var convert_kdv_rate_list = "";
		 var convert_product_list = "";
		 var convert_stock_list = "";
		 var convert_kdv_rate_list = "";
		 var convert_wrk_row_id_list = "";
		 var convert_products_list = "";
		 var convert_list_amount = "";
		 var convert_list_price = "";
		 var convert_list_price_other = "";
		 var convert_list_money = "";
		 var convert_cost_price = "";
		 var convert_extra_cost = "";
		 var list_no='0';
		 
		 for(var i =1 ; i<=document.getElementById('record_num').value; ++i)
		 {
			if(document.getElementById('service_operation_id'+i).checked == true && document.getElementById('stock_id'+i).value != '')
			{
				if(list_no==0)
					list_no =i;
				else
					list_no +=","+i;
				<cfif x_select_amount eq 1>
					 if(document.getElementById('amount'+i) != undefined && filterNum(document.getElementById('amount'+i).value) > 0)
					 {
						convert_list += document.getElementById('stock_id'+i).value+",";
						convert_related_action_id_list += document.getElementById('related_action_id'+i).value+",";
						convert_related_action_table_list += document.getElementById('related_action_table'+i).value+",";
						convert_money_type_list += document.getElementById('money_type_'+i).value+",";
						convert_wrk_row_id_list += document.getElementById('wrk_row_id_'+i).value+",";
						convert_net_total_list += document.getElementById('net_total_'+i).value+",";
						convert_quantity_list += document.getElementById('quantity_'+i).value+",";
						convert_kdv_rate_list += document.getElementById('kdv_rate_'+i).value+",";
						convert_product_list += document.getElementById('product_id_'+i).value+",";
						convert_stock_list += document.getElementById('stock_id_'+i).value+",";
						convert_products_list += document.getElementById('product_id'+i).value+",";
						convert_list_amount += parseFloat(filterNum(document.getElementById('amount'+i).value,3))+',';
						convert_list_price_other += 0+',';
						convert_list_price += parseFloat(filterNum(document.getElementById('price'+i).value,3))+',';
						convert_cost_price += 0+',';
						convert_extra_cost += 0+',';
						convert_list_money += list_getat(document.getElementById('money'+i).value,1,';')+',';
					 }
				<cfelse>
					amount_ = 1;
					convert_list += document.getElementById('stock_id'+i).value+",";
					convert_related_action_id_list += document.getElementById('related_action_id'+i).value+",";
					convert_related_action_table_list += document.getElementById('related_action_table'+i).value+",";
					convert_money_type_list += document.getElementById('money_type_'+i).value+",";
					convert_wrk_row_id_list += document.getElementById('wrk_row_id_'+i).value+",";
					convert_net_total_list += document.getElementById('net_total_'+i).value+",";
					convert_quantity_list += document.getElementById('quantity_'+i).value+",";
					convert_kdv_rate_list += document.getElementById('kdv_rate_'+i).value+",";
					convert_product_list += document.getElementById('product_id_'+i).value+",";
					convert_stock_list += document.getElementById('stock_id_'+i).value+",";
					convert_products_list += document.getElementById('product_id'+i).value+",";
					convert_list_amount += parseFloat(filterNum(amount_,3))+',';
					convert_list_price_other += 0+',';
					convert_list_price += parseFloat(filterNum(document.getElementById('price'+i).value,3))+',';
					convert_cost_price += 0+',';
					convert_extra_cost += 0+',';
					convert_list_money += list_getat(document.getElementById('money'+i).value,1,';')+',';
				</cfif>
			}
		}
		document.getElementById('convert_stocks_id').value = convert_list;
		document.getElementById('convert_products_id').value = convert_products_list;
		document.getElementById('convert_amount_stocks_id').value = convert_list_amount;
		document.getElementById('convert_price').value = convert_list_price;
		document.getElementById('convert_price_other').value = convert_list_price_other;
		document.getElementById('convert_money').value = convert_list_money;
		document.getElementById('convert_cost_price').value = convert_cost_price;
		document.getElementById('convert_extra_cost').value = convert_extra_cost;
		document.getElementById('list_no').value=list_no;
		document.getElementById('add_service').action="<cfoutput>#request.self#?fuseaction=invoice.form_add_bill&type=convert&service_id=#attributes.service_id#&service_no=#URLEncodedFormat(get_service_detail.service_no)#</cfoutput>";
		document.getElementById('add_service').submit();
		return true;
	}
		
	function addOrder()
	{
		var convert_list = "";
		var convert_list_amount = "";
		var convert_list_price = "";
		var convert_list_price_other = "";
		var convert_list_money = "";
		var convert_cost_price = "";
		var convert_extra_cost = "";

		if(document.getElementById('record_num').value > 1)
		{
			service_list_ = "";
			for (i=1; i <= document.getElementById('record_num').value; i++)
			{
				if(eval("document.getElementById('service_operation_id" + i + "')").checked == true)
				{
					service_list_ = service_list_ + eval("document.getElementById('service_operation_id" + i + "')").value + ',';
					if(eval("document.getElementById('spare_part_type" + i + "')").value=="")
					{
						alert(i+".<cf_get_lang dictionary_id='64390.Satır İşlem Seçmelisiniz'> !");
						return false;
					}	
					if(!eval("document.getElementById('related_action_id" + i + "')"))
					{
						alert(i+".<cf_get_lang dictionary_id='64402.Yeni eklenen satırlar olduğu için öncelikle ürün servis işlemlerini güncellemelisiniz!'>");
						return false;
					}
				}
			}

			if(service_list_.length == 0)
			{
				alert('<cf_get_lang dictionary_id='64396.İrsaliye Kesilecek İşlem Seçmelisiniz'>!');
				return false;
			}		
		}
		else if(document.getElementById('record_num').value == 1)
		{
			if(document.getElementById('service_operation_id1').checked == false)
			{
				alert('<cf_get_lang dictionary_id='64396.İrsaliye Kesilecek İşlem Seçmelisiniz'>!');
				return false;
			}
		}
				
		for(var i =1 ; i<=document.getElementById('record_num').value; ++i)
		{
			if(document.getElementById('service_operation_id'+i).checked == true && document.getElementById('stock_id'+i).value != '')
			{
				<cfif x_select_amount eq 1>
					amount_ = document.getElementById('amount'+i).value;
					if(filterNum(amount_) > 0)
					{
						convert_list += document.getElementById('stock_id'+i).value+",";
						convert_list_amount += parseFloat(filterNum(amount_,3))+',';
						convert_list_price_other += 0+',';
						//convert_list_price += filterNum(document.getElementById('price'+i).value,3)+',';
						convert_list_price += parseFloat(filterNum(document.getElementById('price'+i).value))+',';
						convert_extra_cost += 0+',';
						convert_list_money += list_getat(document.getElementById('money'+i).value,1,';')+',';
					}
				<cfelse>
					amount_ = '1';
					if(amount_ > 0)
					{
						convert_list += document.getElementById('stock_id'+i).value+",";
						convert_list_amount += parseFloat(filterNum(amount_,3))+',';
						convert_list_price_other += 0+',';
						//convert_list_price += filterNum(document.getElementById('price'+i).value,3)+',';
						convert_list_price += parseFloat(filterNum(document.getElementById('price'+i).value))+',';
						convert_extra_cost += 0+',';
						convert_list_money += list_getat(document.getElementById('money'+i).value,1,';')+',';
					}
				</cfif>
			}
		}
		
		document.getElementById('convert_stocks_id').value = convert_list;
		document.getElementById('convert_amount_stocks_id').value = convert_list_amount;
		document.getElementById('convert_price').value = convert_list_price;
		document.getElementById('convert_price_other').value = convert_list_price_other;
		document.getElementById('convert_money').value = convert_list_money;
		document.getElementById('convert_cost_price').value = convert_cost_price;
		document.getElementById('convert_extra_cost').value = convert_extra_cost;	
		document.getElementById('add_service').action="<cfoutput>#request.self#?fuseaction=purchase.list_internaldemand&event=add&type=convert&service_id=#attributes.service_id#</cfoutput>";
		document.getElementById('add_service').submit();
		return true;
		
	}
	
	function get_product_detail(this_serial_no,row_number)
	{
		var div_name_ = 'check_product_layer'+row_number;
	
		if(document.getElementById(div_name_) != undefined)
		{
			document.getElementById('frm_row_'+row_number).style.display='';
			document.getElementById(div_name_).style.display='';
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=service.emptypopup_get_product_with_serial&serial_no=' + this_serial_no+'&row_number='+row_number,div_name_ ,1);
		}
		else
			setTimeout('_show_("'+this_serial_no+'")',20);
	}
	
	function get_service_cat(count,deger)
	{
		<cfif x_prod_calc_sub_contract and isdefined('attributes.subscription_id') and len(attributes.subscription_id)>
		if(deger==undefined)
		{
			deger1 = <cfoutput>#attributes.subscription_id#</cfoutput>;
			deger2 = document.getElementById('product_id'+count).value;
			var listParam = deger1 + "*" + deger2;
			result_ = wrk_safe_query('srv_get_subscription_price','dsn3',0,listParam);
			if(result_.recordcount > 0)
			{
				my_deger = result_.OTHER_MONEY_VALUE;
				my_deger_money = result_.OTHER_MONEY;
				my_deger_rate1 = result_.RATE1;
				my_deger_rate2 = result_.RATE2;
				document.getElementById('price'+count).value = my_deger;
				document.getElementById('money'+count).value = my_deger_money+';'+my_deger_rate1+';'+my_deger_rate2;
				document.getElementById('total_price'+count).value = my_deger;
			}
		}
		</cfif>
		<cfif x_product_cat_operation>
		if(document.getElementById('product_catid'+count).value)
		{
			deger = document.getElementById('product_catid'+count).value;
			result = wrk_safe_query('srv_get_spare_part','dsn3',0,deger);
			mylist = result.SPARE_PART_ID;
			if(mylist != undefined && mylist != '')
			document.getElementById('spare_part_type'+count).value = mylist;
		}
		</cfif>
	}

	function same_amount(crntrw)
	{
		eval("document.getElementById('amount" + crntrw + "')").value = eval("document.getElementById('predicted_amount" + crntrw + "')").value;	
	}
</script>
