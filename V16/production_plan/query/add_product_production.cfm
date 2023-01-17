<!--- popuptan satıra ürün ekleme sayfası --->
<script type="text/javascript" src="/JS/js_functions.js"></script>
<cfif isdefined('attributes.product_cost_date') and len(attributes.product_cost_date)>
	<cfif listlen(attributes.product_cost_date,'-') gt 1>
		<cfset hour_ = listgetat(attributes.product_cost_date,2,'-')>
		<cfset min_ = listgetat(attributes.product_cost_date,3,'-')>
	<cfelse>
		<cfset hour_ = 0>
		<cfset min_ = 0>
	</cfif>
	<cfset attributes.product_cost_date =  listfirst(attributes.product_cost_date,'-')>
	<cf_date tarih = "attributes.product_cost_date">
	<cfset attributes.product_cost_date = createdatetime(year(attributes.product_cost_date),month(attributes.product_cost_date),day(attributes.product_cost_date),hour_,min_,0)>
</cfif>
<cfparam name="attributes.product_cost_date" default="#now()#">
<cf_xml_page_edit page_control_list="is_show_product_name2,is_change_amount,is_show_two_units,is_show_spec_id,is_show_spec_name,x_is_show_total_cost_price,round_number" default_value="1" fuseact="prod.upd_prod_order_result,prod.add_prod_order_result">
<cfif isdefined('is_show_product_name2') and is_show_product_name2 eq 1>
	<cfset attributes.product_name2_display ="">
<cfelse>
	<cfset attributes.product_name2_display='none'>
</cfif>
<cfif isdefined('is_show_spec_id') and is_show_spec_id eq 1>
	<cfset attributes.spec_display = 'text'>
<cfelse>
	<cfset attributes.spec_display = 'hidden'>
</cfif>
<cfif isdefined('is_show_spec_name') and is_show_spec_name eq 1>
	<cfset attributes.spec_name_display = 'text'>
<cfelse>
	<cfset attributes.spec_name_display = 'hidden'>
</cfif>
<cfif isdefined('is_show_spec_id') and is_show_spec_id eq 0 and isdefined('is_show_spec_name') and is_show_spec_name eq 0>
	<cfset attributes.spec_img_display="none">
<cfelse>
	<cfset attributes.spec_img_display="">
</cfif>
<cfif isdefined('attributes.p_order_id') and isdefined('attributes.pr_order_id')>
	<cfquery name="GET_DETAIL" datasource="#dsn3#">
		SELECT 
			PRODUCTION_ORDERS.IS_DEMONTAJ,
			PROJECT_ID
		FROM 
			PRODUCTION_ORDERS
		WHERE 
			PRODUCTION_ORDERS.P_ORDER_ID = #attributes.p_order_id#
	</cfquery>
	<cfquery name="get_detail_row" datasource="#dsn3#">
        SELECT 
            PORR.STATION_REFLECTION_COST_SYSTEM,
            PORR.LABOR_COST_SYSTEM 
        FROM 
        	PRODUCTION_ORDERS PO,
            PRODUCTION_ORDER_RESULTS POR,
            PRODUCTION_ORDER_RESULTS_ROW PORR
        WHERE 
        	PO.P_ORDER_ID = POR.P_ORDER_ID AND
            POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND 
            PO.STOCK_ID = PORR.STOCK_ID AND 
        	POR.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> 
            AND PORR.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">  
            AND PORR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> 
        ORDER BY 
        	PORR.TREE_TYPE DESC	
    </cfquery>
	<cfquery name="get_prod_result" datasource="#dsn3#">
		SELECT POR.FINISH_DATE FROM PRODUCTION_ORDER_RESULTS POR WHERE POR.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#"> AND POR.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#">
	</cfquery>
	<cfquery name="get_money_rate" datasource="#dsn#">
		SELECT MONEY,RATE1,RATE2 FROM MONEY_HISTORY WHERE MONEY_HISTORY_ID IN(SELECT MAX(MONEY_HISTORY_ID) FROM MONEY_HISTORY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND VALIDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_prod_result.finish_date)#"> GROUP BY MONEY)
	</cfquery>
	<cfif len(get_detail_row.LABOR_COST_SYSTEM)>
		<cfset LABOR_COST_SYSTEM_ = get_detail_row.LABOR_COST_SYSTEM / get_money_rate.rate2>
	<cfelse>
		<cfset LABOR_COST_SYSTEM_ = get_detail_row.LABOR_COST_SYSTEM>
	</cfif>
	<cfif len(get_detail_row.STATION_REFLECTION_COST_SYSTEM)>
		<cfset STATION_REFLECTION_COST_SYSTEM_ = get_detail_row.STATION_REFLECTION_COST_SYSTEM / get_money_rate.rate2>
	<cfelse>
		<cfset STATION_REFLECTION_COST_SYSTEM_ = get_detail_row.STATION_REFLECTION_COST_SYSTEM>
	</cfif>
<cfelse>
	<cfset attributes.p_order_id = ''>
	<cfset GET_DETAIL.IS_DEMONTAJ = ''>
	<cfset get_detail_row.LABOR_COST_SYSTEM = ''>
	<cfset get_detail_row.STATION_REFLECTION_COST_SYSTEM = ''>
	<cfset LABOR_COST_SYSTEM_ = ''>
	<cfset STATION_REFLECTION_COST_SYSTEM_ = ''>
</cfif>
<cfquery name="GET_PRODUCT_COST" datasource="#dsn3#" maxrows="1">
	SELECT top 1
		PRODUCT_COST_ID,
		PURCHASE_NET,
		PURCHASE_NET_MONEY,
		PURCHASE_NET_SYSTEM,
		PURCHASE_NET_SYSTEM_2,
		PURCHASE_NET_SYSTEM_MONEY,
		PURCHASE_EXTRA_COST,
		PURCHASE_EXTRA_COST_SYSTEM,
		PURCHASE_EXTRA_COST_SYSTEM_2,
		PRODUCT_COST,
		MONEY 
	FROM 
		PRODUCT_COST 
	WHERE 
		PRODUCT_ID = #product_id# AND
		START_DATE < #attributes.product_cost_date# 
	ORDER BY 
		START_DATE DESC,
	 	RECORD_DATE DESC
</cfquery>
<cfparam name="attributes.spec_name" default="">
<cfif isdefined('attributes.SPECT_MAIN_ID') and len(attributes.SPECT_MAIN_ID)>
	<cfquery name="get_spec_main_name" datasource="#dsn3#">
    	SELECT SPECT_MAIN_NAME  FROM SPECT_MAIN WHERE SPECT_MAIN_ID =#attributes.SPECT_MAIN_ID#
    </cfquery>
    <cfset attributes.spec_name = get_spec_main_name.SPECT_MAIN_NAME>
</cfif>
<cfscript>
if(GET_PRODUCT_COST.RECORDCOUNT eq 0)
{
	cost_id = 0;
	purchase_extra_cost = 0;
	product_cost = 0;
	product_cost_money = session.ep.money;
	cost_price = 0;
	cost_price_money = session.ep.money;
	cost_price_2 = 0;
	cost_price_money_2 = session.ep.money2;
	cost_price_system = 0;
	cost_price_system_money = session.ep.money;
	purchase_extra_cost_system = 0;
	purchase_extra_cost_system_2 = 0;
}
else
{
	cost_id = GET_PRODUCT_COST.product_cost_id;
	purchase_extra_cost = wrk_round(GET_PRODUCT_COST.PURCHASE_EXTRA_COST,8,1);
	product_cost = GET_PRODUCT_COST.PRODUCT_COST;
	product_cost_money = GET_PRODUCT_COST.MONEY;
	cost_price = GET_PRODUCT_COST.PURCHASE_NET;
	cost_price_money = GET_PRODUCT_COST.PURCHASE_NET_MONEY;
	cost_price_2 = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_2;
	cost_price_money_2 = session.ep.money2;
	cost_price_system = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM;
	cost_price_system_money = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY;
	purchase_extra_cost_system = wrk_round(GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM,8,1);
	purchase_extra_cost_system_2 = wrk_round(GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_2,8,1);
}
if(session.ep.period_year gt 2008){
	if(cost_price_money is 'YTL') cost_price_money = 'TL';
	if(product_cost_money is 'YTL') product_cost_money = 'TL';
	if(cost_price_system_money is 'YTL') cost_price_system_money = 'TL';
}
if(session.ep.period_year lt 2009){
	if(cost_price_money is 'TL') cost_price_money = 'YTL';
	if(product_cost_money is 'TL') product_cost_money = 'YTL';
	if(cost_price_system_money is 'TL') cost_price_system_money = 'YTL';
}
</cfscript>
<script type="text/javascript">
<cfoutput>
	<cfif isdefined("attributes.type") and (attributes.type eq 1)>
		round_number = #round_number#;
		row_count = #attributes.record_num#;
		row_count++;
		opener.row_count=row_count;
		var newRow;
		var newCell;
		newRow = opener.document.getElementById("table1").insertRow(opener.document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		opener.document.all.record_num.value = row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="tree_type_' + row_count +'" id="tree_type_' + row_count +'" value="S"><input type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="fa fa-minus"></i></a><input type="hidden" name="cost_id' + row_count +'" id="cost_id' + row_count +'" value="#cost_id#"><input type="hidden" name="product_cost' + row_count +'" id="product_cost' + row_count +'" value="#product_cost#"><input type="hidden" name="product_cost_money' + row_count +'" id="product_cost_money' + row_count +'" value="#product_cost_money#"><input type="hidden" name="cost_price_system' + row_count +'" id="cost_price_system' + row_count +'" value="#cost_price_system#"><input type="hidden" name="money_system' + row_count +'" id="money_system' + row_count +'" value="#cost_price_system_money#"><input type="hidden" name="purchase_extra_cost' + row_count +'" id="purchase_extra_cost' + row_count +'" value="#purchase_extra_cost#"><input type="hidden" name="purchase_extra_cost_system' + row_count +'" id="purchase_extra_cost_system' + row_count +'" value="#purchase_extra_cost_system#"><input type="hidden" name="cost_price_extra_2' + row_count +'" id="cost_price_extra_2' + row_count +'" value="#TlFormat(purchase_extra_cost_system_2,round_number)#" readonly class="moneybox">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="stock_code' + row_count +'" id="stock_code' + row_count +'" value="#attributes.STOCK_CODE#" readonly style="width:120px;"><input type="hidden" name="kdv_amount' + row_count +'" id="kdv_amount' + row_count +'" value="#attributes.tax#"></div>';
		<cfif x_is_barkod_col eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="barcode' + row_count +'" id="barcode' + row_count +'" value="#attributes.barcode#" readonly style="width:90px;"></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'" value="#attributes.product_id#"><input type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'" value="#attributes.stock_id#"><input type="text" name="product_name' + row_count +'" id="product_name' + row_count +'" value="#attributes.product_name# #attributes.property#" readonly style="width:230px;"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		<cfif len(attributes.spec_img_display)>
			newCell.style.display = 'none';
		</cfif>
		newCell.innerHTML = '<div class="form-group"><div class="col col-3"><input type="<cfoutput>#attributes.spec_display#</cfoutput>" name="spec_main_id' + row_count +'" id="spec_main_id' + row_count +'" value="<cfoutput>#attributes.SPECT_MAIN_ID#</cfoutput>" readonly style="width:40px;"></div><div class="col col-3"> <input type="<cfoutput>#attributes.spec_display#</cfoutput>" name="spect_id' + row_count +'" id="spect_id' + row_count +'" value=""style="width:40px;"></div><div class="col col-6"><div class="input-group"> <input type="<cfoutput>#attributes.spec_name_display#</cfoutput>" name="spect_name' + row_count +'" id="spect_name' + row_count +'" <cfoutput>value="#attributes.spec_name#"</cfoutput> readonly style="width:150px;"> <span class="input-group-addon icon-ellipsis" onClick="pencere_ac_spect('+ row_count +');"></span></div></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		<cfif xml_work eq 1>
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="work_head' + row_count +'" id="work_head' + row_count +'"><input type="hidden" name="work_id' + row_count +'" id="work_id' + row_count +'"><span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='58691.iş listesi'>" onclick="pencere_ac_work(' + row_count +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		</cfif>
		newCell.innerHTML = '<div class="form-group"><input type="text" name="amount' + row_count +'" onchange="find_amount2(row_count)" id="amount' + row_count +'" value="#TlFormat(attributes.amount,round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(' + row_count +',1);" class="moneybox" style="width:70px;"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		<cfif isdefined("x_is_fire_product") and x_is_fire_product eq 1>
			newCell.innerHTML = '<div class="form-group"><input type="text" name="fire_amount_' + row_count +'" id="fire_amount_' + row_count +'" value="0" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(' + row_count +',1);" class="moneybox" style="width:60px;"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
		</cfif>
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="unit_id' + row_count +'" id="unit_id' + row_count +'" value="#attributes.unit_id#"><input type="text" name="unit' + row_count +'" id="unit' + row_count +'" value="#attributes.unit#" readonly style="width:60px;"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" onchange="find_amount2(row_count);Get_Product_Unit_2_And_Quantity_2(row_count)"  name="weight' + row_count +'" id="weight' + row_count +'"   style="width:60px;"></div>';
		<cfif isdefined('x_is_show_abh') and x_is_show_abh eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" onchange="Get_Product_Unit_2_And_Quantity_2(row_count)"  name="width' + row_count +'" id="width' + row_count +'"   style="width:60px;"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" onchange="Get_Product_Unit_2_And_Quantity_2(row_count)"  name="height' + row_count +'" id="height' + row_count +'"   style="width:60px;"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" onchange="Get_Product_Unit_2_And_Quantity_2(row_count)"  name="length' + row_count +'" id="length' + row_count +'"   style="width:60px;"></div>';
		</cfif>
		<cfif isdefined('xml_specific_weight') and xml_specific_weight eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" onchange="find_weight(row_count)"  name="specific_weight' + row_count +'" id="specific_weight' + row_count +'"   style="width:60px;"></div>';
		</cfif>
		<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="cost_price' + row_count +'" id="cost_price' + row_count +'" value="#TlFormat(cost_price,round_number)#" style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,8));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="cost_price_extra' + row_count +'" id="cost_price_extra' + row_count +'" value="" style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,8));">';
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="total_cost_price' + row_count +'" id="total_cost_price' + row_count +'" value="#TlFormat(cost_price*attributes.amount,round_number)#" style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,8));"></div>';
			</cfif>
			<cfif x_is_show_labor_cost eq 1 >
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="hidden" name="labor_cost' + row_count +'" id="labor_cost' + row_count +'" value="#get_detail_row.LABOR_COST_SYSTEM#" class="moneybox" style="width:0px;"><input type="text" name="____labor_cost' + row_count +'" id="____labor_cost' + row_count +'" class="moneybox" value=""  onKeyUp="isNumber(this)" style="width:90px;"></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="____labor_cost_total' + row_count +'" id="____labor_cost_total' + row_count +'" value="" class="moneybox" style="width:0px;"></div>';
			</cfif>
			<cfif x_is_show_refl_cost eq 1 >
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="hidden" name="station_reflection_cost_system' + row_count +'" id="station_reflection_cost_system' + row_count +'" value="#get_detail_row.STATION_REFLECTION_COST_SYSTEM#" class="moneybox" style="width:0px;"><input type="text" name="____station_reflection_cost_system' + row_count +'" id="____station_reflection_cost_system' + row_count +'" class="moneybox" value=""  onKeyUp="isNumber(this)" style="width:90px;"></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML ='<div class="form-group"><input type="text" name="____station_reflection_cost_system_total' + row_count +'" id="____station_reflection_cost_system_total' + row_count +'" value="" class="moneybox" style="width:0px;"></div>';
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<cfif isdefined('x_is_cost_price_2') and x_is_cost_price_2 eq 0><input type="hidden" name="money_2' + row_count +'" id="money_2' + row_count +'" value="#cost_price_money_2#"><input type="hidden" name="cost_price_2' + row_count +'" id="cost_price_2' + row_count +'" value="#TlFormat(cost_price_2,round_number)#"></cfif><div class="form-group"><input type="text" name="money' + row_count +'" id="money' + row_count +'" value="#cost_price_money#" readonly style="width:50px;"></div>';
			<cfif isdefined('x_is_cost_price_2') and x_is_cost_price_2 eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="cost_price_2' + row_count +'" id="cost_price_2' + row_count +'" style="width:125px;" value="#TlFormat(cost_price_2,round_number)#" class="moneybox" onKeyup="return(FormatCurrency(this,event,8));"></div>';
				<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="total_cost_price_2' + row_count +'" id="total_cost_price_2' + row_count +'" style="width:125px;" value="#TlFormat(cost_price_2*attributes.amount,round_number)#" class="moneybox" onKeyup="return(FormatCurrency(this,event,8));"></div>';
				</cfif>
			
			<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="____labor_cost2_' + row_count +'" id="____labor_cost2_' + row_count +'" onKeyUp="isNumber(this)" class="moneybox" value="#LABOR_COST_SYSTEM_#" style="width:90px;"></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="____labor_cost2_total' + row_count +'" id="____labor_cost2_total' + row_count +'" value="" style="width:90px;"></div>';
			</cfif>
			<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="____station_reflection_cost_system2_' + row_count +'" id="____station_reflection_cost_system2_' + row_count +'" onKeyUp="isNumber(this)" class="moneybox" value="#STATION_REFLECTION_COST_SYSTEM_#" style="width:90px;"></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="____station_reflection_cost_system2_total' + row_count +'" id="____station_reflection_cost_system2_total' + row_count +'" value="" style="width:90px;"></div>';
			</cfif>
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="total_cost_price_2' + row_count +'" id="total_cost_price_2' + row_count +'" readonly style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));"></div>';
			</cfif>
			<cfif isdefined('x_is_cost_price_2') and x_is_cost_price_2 eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="money_2' + row_count +'" id="money_2' + row_count +'" value="#cost_price_money_2#" readonly style="width:50px;"></div>';
			</cfif>
		</cfif>
		<cfelse>
			newCell.innerHTML = newCell.innerHTML+'<input type="hidden" name="money' + row_count +'" id="money' + row_count +'" value="#cost_price_money#" readonly style="width:50px;"><input type="hidden" name="station_reflection_cost_system' + row_count +'" id="station_reflection_cost_system' + row_count +'" value="#get_detail_row.STATION_REFLECTION_COST_SYSTEM#" class="moneybox" style="width:0px;"><input type="hidden" name="____station_reflection_cost_system' + row_count +'" id="____station_reflection_cost_system' + row_count +'" value="" style="width:90px;"><input type="hidden" name="money_2' + row_count +'" id="money_2' + row_count +'" value="#cost_price_money_2#" readonly style="width:50px;"><input type="hidden" name="cost_price_2' + row_count +'" id="cost_price_2' + row_count +'" style="width:125px;" value="#TlFormat(cost_price_2,round_number)#" class="moneybox" onKeyup="return(FormatCurrency(this,event,8));"><input type="hidden" name="cost_price' + row_count +'" id="cost_price' + row_count +'" value="#TlFormat(cost_price,round_number)#" style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,8));"><input type="hidden" name="labor_cost' + row_count +'" id="labor_cost' + row_count +'" value="#get_detail_row.LABOR_COST_SYSTEM#" class="moneybox" style="width:0px;"><input type="hidden" name="____labor_cost' + row_count +'" id="____labor_cost' + row_count +'" value="" style="width:90px;">';	
		</cfif>
		<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" onchange="Get_Product_Unit_2_And_Quantity_2(row_count)" name="amount2_' + row_count +'" id="amount2_' + row_count +'" value="" onKeyup="return(FormatCurrency(this,event,8));" onBlur="" class="moneybox" style="width:70px;"></div>';
		//2.birim ekleme
		
		var get_Unit2_Prod = wrk_safe_query('prdp_get_unit2_prod','dsn3',0,#attributes.product_id#)
		var unit2_values ='<div class="form-group"><select name="unit2'+row_count+'" style="width:60;" disabled="true">';
		if(get_Unit2_Prod.recordcount){
		for(xx=0;xx<get_Unit2_Prod.recordcount;xx++)
			unit2_values += '<option value="'+get_Unit2_Prod.ADD_UNIT[xx]+'">'+get_Unit2_Prod.ADD_UNIT[xx]+'</option>';
		}
		unit2_values +='</select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = ''+unit2_values+'';
		//2.birim ekleme bitti.
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		<cfif len(attributes.product_name2_display)>
		newCell.style.display = "none";
		</cfif>
		newCell.innerHTML = '<div class="form-group"><input type="text" style="width:70px;" name="product_name2' + row_count +'" id="product_name2' + row_count +'" value=""></div>';
	<cfelseif isdefined("attributes.type") and (attributes.type eq 0)>
		row_count_exit = #attributes.record_num_exit#;
		row_count_exit++;
		opener.row_count_exit=row_count_exit;
		opener.record_num_exit=row_count_exit;
		var newRow;
		var newCell;
		newRow = opener.document.getElementById("table2_body").insertRow(opener.document.getElementById("table2_body").rows.length);
		newRow.setAttribute("name","frm_row_exit" + row_count_exit);
		newRow.setAttribute("id","frm_row_exit" + row_count_exit);
		newRow.setAttribute("NAME","frm_row_exit" + row_count_exit);
		newRow.setAttribute("ID","frm_row_exit" + row_count_exit);
		opener.document.all.record_num_exit.value = row_count_exit;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign="center";
		newCell.innerHTML = '<input type="hidden" name="is_production_spect_exit' + row_count_exit +'" id="is_production_spect_exit' + row_count_exit +'" value="#attributes.is_production#"><input type="hidden" name="is_add_info_' + row_count_exit +'" id="is_add_info_' + row_count_exit +'" value="1"><input type="hidden" name="tree_type_exit_' + row_count_exit +'" id="tree_type_exit_' + row_count_exit +'" value="S"><input type="hidden" name="row_kontrol_exit' + row_count_exit +'" id="row_kontrol_exit' + row_count_exit +'" value="1"><a style="cursor:pointer" onclick="sil_exit(' + row_count_exit + ');"><img  src="images/delete_list.gif" border="0" align="absmiddle" alt="Sil"></a><input type="hidden" name="cost_id_exit' + row_count_exit +'" id="cost_id_exit' + row_count_exit +'" value="#cost_id#"><input type="hidden" name="product_cost_exit' + row_count_exit +'" id="product_cost_exit' + row_count_exit +'" value="#product_cost#"><input type="hidden" name="product_cost_money_exit' + row_count_exit +'" id="product_cost_money_exit' + row_count_exit +'" value="#product_cost_money#"><input type="hidden" name="cost_price_system_exit' + row_count_exit +'" id="cost_price_system_exit' + row_count_exit +'" value="#cost_price_system#"><input type="hidden" name="money_system_exit' + row_count_exit +'" id="money_system_exit' + row_count_exit +'" value="#cost_price_system_money#"><input type="hidden" name="purchase_extra_cost_system_exit' + row_count_exit +'" id="purchase_extra_cost_system_exit' + row_count_exit +'" value="#purchase_extra_cost_system#">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="stock_code_exit' + row_count_exit +'" id="stock_code_exit' + row_count_exit +'" value="#attributes.STOCK_CODE#" readonly style="width:120px;"><input type="hidden" name="kdv_amount_exit' + row_count_exit +'" id="kdv_amount_exit' + row_count_exit +'" value="#attributes.tax#"></div>';
		<cfif x_is_barkod_col eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="barcode_exit' + row_count_exit +'" id="barcode_exit' + row_count_exit +'" value="#attributes.barcode#" readonly style="width:90px;"></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="product_id_exit' + row_count_exit +'" id="product_id_exit' + row_count_exit +'" value="#attributes.product_id#"><input type="hidden" name="stock_id_exit' + row_count_exit +'" id="stock_id_exit' + row_count_exit +'" value="#attributes.stock_id#"><input type="text" name="product_name_exit' + row_count_exit +'" id="product_name_exit' + row_count_exit +'" value="#attributes.product_name# #attributes.property#" readonly style="width:230px;"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		<cfif len(attributes.spec_img_display)>
			newCell.style.display = 'none';
		</cfif>
		newCell.innerHTML = '<div class="form-group"><div class="col col-3"><input type="<cfoutput>#attributes.spec_display#</cfoutput>" name="spec_main_id_exit' + row_count_exit +'" id="spec_main_id_exit' + row_count_exit +'" value="<cfoutput>#attributes.SPECT_MAIN_ID#</cfoutput>" readonly style="width:40px;"></div><div class="col col-3"> <input type="<cfoutput>#attributes.spec_display#</cfoutput>" name="spect_id_exit' + row_count_exit +'" id="spect_id_exit' + row_count_exit +'" value="" style="width:40px;"> </div><div class="col col-6"><div class="input-group"><input type="<cfoutput>#attributes.spec_name_display#</cfoutput>" name="spect_name_exit' + row_count_exit +'" id="spect_name_exit' + row_count_exit +'" <cfoutput>value="#attributes.spec_name#"</cfoutput> readonly style="width:150px;"> <span class="input-group-addon icon-ellipsis" onClick="pencere_ac_spect('+ row_count_exit +',2);"></span></div></div></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="lot_no_exit' + row_count_exit +'" id="lot_no_exit' + row_count_exit +'" value="" onKeyup="lotno_control('+ row_count_exit +',2);" style="width:75px;"> <span class="input-group-addon icon-ellipsis" onClick="pencere_ac_list_product('+ row_count_exit +',2);"></span></div></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="expiration_date_exit' + row_count_exit +'" id="expiration_date_exit' + row_count_exit +'" value=""  style="width:70px;"><span class="input-group-addon" id="expiration_date_exit'+row_count_exit +'_td"></span></div></div>';
		window.opener.wrk_date_image('expiration_date_exit' + row_count_exit);

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" onchange="find_amount2_exit(row_count_exit)"  name="amount_exit' + row_count_exit +'" id="amount_exit' + row_count_exit +'" value="#TlFormat(attributes.amount,round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(' + row_count_exit +',0);" class="moneybox" style="width:70px;"><input type="hidden" name="amount_exit_' + row_count_exit +'" id="amount_exit_' + row_count_exit +'" value="#TlFormat(attributes.amount,round_number)#"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="unit_id_exit' + row_count_exit +'" id="unit_id_exit' + row_count_exit +'" value="#attributes.unit_id#"><input type="text" name="unit_exit' + row_count_exit +'" id="unit_exit' + row_count_exit +'" value="#attributes.unit#" readonly style="width:60px;"><input type="hidden" name="serial_no_exit' + row_count_exit +'" id="serial_no_exit' + row_count_exit +'" value=""></div>';
		newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" onchange="find_amount2_exit(row_count_exit);Get_Product_Unit_2_And_Quantity_2_exit(row_count_exit);"  name="weight_exit' + row_count_exit +'" id="weight_exit' + row_count_exit +'"   style="width:60px;"></div>';
		<cfif isdefined('x_is_show_abh') and x_is_show_abh eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" onchange="Get_Product_Unit_2_And_Quantity_2_exit(row_count_exit)" name="width_exit' + row_count_exit +'" id="width_exit' + row_count_exit +'"   style="width:60px;"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" onchange="Get_Product_Unit_2_And_Quantity_2_exit(row_count_exit)"  name="height_exit' + row_count_exit +'" id="height_exit' + row_count_exit +'"   style="width:60px;"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" onchange="Get_Product_Unit_2_And_Quantity_2_exit(row_count_exit)"  name="length_exit' + row_count_exit +'" id="length_exit' + row_count_exit +'"   style="width:60px;"></div>';
		</cfif>
		<cfif isdefined('xml_specific_weight') and xml_specific_weight eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" onchange="find_weight_exit(row_count_exit)"  name="specific_weight_exit' + row_count_exit +'" id="specific_weight_exit' + row_count_exit +'"   style="width:60px;"></div>';
		</cfif>
		<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="cost_price_exit' + row_count_exit +'" id="cost_price_exit' + row_count_exit +'" <cfif attributes.is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_exit+',2);"</cfif> value="#TlFormat(cost_price,round_number)#" class="moneybox" onKeyup="return(FormatCurrency(this,event,8));"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="purchase_extra_cost_exit' + row_count_exit +'" id="purchase_extra_cost_exit' + row_count_exit +'" value="#TlFormat(purchase_extra_cost,round_number)#" <cfif attributes.is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_exit+',2);"</cfif> class="moneybox"></div>';
			<cfif x_is_show_labor_cost eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="labor_cost_exit' + row_count_exit +'" id="labor_cost_exit' + row_count_exit +'" value="" style="width:90px;"></div>';
			</cfif>
			<cfif x_is_show_refl_cost eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="reflection_cost_exit' + row_count_exit +'" id="reflection_cost_exit' + row_count_exit +'" value="" style="width:90px;"></div>';
			</cfif>
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="total_cost_price_exit' + row_count_exit +'" id="total_cost_price_exit' + row_count_exit +'" readonly value="#TlFormat((cost_price+purchase_extra_cost)*attributes.amount,round_number)#" class="moneybox" onKeyup="return(FormatCurrency(this,event,8));"></div>';
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="money_exit' + row_count_exit +'" id="money_exit' + row_count_exit +'" value="#cost_price_money#" readonly style="width:50px;"></div>';
			<cfif isdefined('x_is_cost_price_2') and x_is_cost_price_2 eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="cost_price_exit_2' + row_count_exit +'" id="cost_price_exit_2' + row_count_exit +'" <cfif attributes.is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_exit+',2);"</cfif> value="#TlFormat(cost_price_2,round_number)#" class="moneybox" onKeyup="return(FormatCurrency(this,event,8));"></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="purchase_extra_cost_exit_2' + row_count_exit +'" id="purchase_extra_cost_exit_2' + row_count_exit +'" value="#TlFormat(purchase_extra_cost_system_2,round_number)#" readonly class="moneybox"></div>';
				<cfif isdefined("x_is_show_labor_cost") and x_is_show_labor_cost eq 1>
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="total_labor_cost_exit_2'+row_count_exit+'" id="total_labor_cost_exit_2'+row_count_exit+'" value="" readonly class="moneybox"></div>';
				</cfif>
				<cfif isdefined("x_is_show_refl_cost") and x_is_show_refl_cost eq 1>
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="total_reflection_cost_exit_2'+row_count_exit+'" id="total_reflection_cost_exit_2'+row_count_exit+'" value="" readonly class="moneybox"></div>';
				</cfif>
				<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="total_cost_price_exit_2' + row_count_exit +'" id="total_cost_price_exit_2' + row_count_exit +'" readonly value="#TlFormat((cost_price_2+purchase_extra_cost_system_2)*attributes.amount,round_number)#" class="moneybox" onKeyup="return(FormatCurrency(this,event,8));"></div>';
				</cfif>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="money_exit_2' + row_count_exit +'" id="money_exit_2' + row_count_exit +'" value="#cost_price_money_2#" readonly style="width:50px;"></div>';
			</cfif>
		<cfelse>
			newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="money_exit_2' + row_count_exit +'" id="money_exit_2' + row_count_exit +'" value="#cost_price_money_2#" readonly style="width:50px;"><input type="hidden" name="purchase_extra_cost_exit_2' + row_count_exit +'" id="purchase_extra_cost_exit_2' + row_count_exit +'" value="#TlFormat(purchase_extra_cost_system_2,round_number)#" readonly class="moneybox"><input type="hidden" name="cost_price_exit_2' + row_count_exit +'" id="cost_price_exit_2' + row_count_exit +'" value="#TlFormat(cost_price_2,round_number)#" class="moneybox" onKeyup="return(FormatCurrency(this,event,8));"><input type="hidden" name="money_exit' + row_count_exit +'" id="money_exit' + row_count_exit +'" value="#cost_price_money#" readonly style="width:50px;"><input type="hidden" name="purchase_extra_cost_exit' + row_count_exit +'" id="purchase_extra_cost_exit' + row_count_exit +'" value="#TlFormat(purchase_extra_cost,round_number)#" readonly class="moneybox"><input type="hidden" name="cost_price_exit' + row_count_exit +'" id="cost_price_exit' + row_count_exit +'" value="#TlFormat(cost_price,round_number)#" class="moneybox" onKeyup="return(FormatCurrency(this,event,8));">';
		</cfif>
		<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" onchange="Get_Product_Unit_2_And_Quantity_2_exit(row_count_exit)" name="amount_exit2_' + row_count_exit +'" id="amount_exit2_' + row_count_exit +'" value="" onKeyup="return(FormatCurrency(this,event,8));" onBlur="" class="moneybox" style="width:70px;"></div>';
		//2.birim ekleme
		var get_Unit2_Prod = wrk_safe_query('prdp_get_unit2_prod','dsn3',0,#attributes.product_id#)
		var unit2_values ='<div class="form-group"><select name="unit2_exit'+row_count_exit+'" id="unit2_exit'+row_count_exit+'" style="width:60;">';
		if(get_Unit2_Prod.recordcount){
		for(xx=0;xx<get_Unit2_Prod.recordcount;xx++)
			unit2_values += '<option value="'+get_Unit2_Prod.ADD_UNIT[xx]+'">'+get_Unit2_Prod.ADD_UNIT[xx]+'</option>';
		}
		unit2_values +='</select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = ''+unit2_values+'';
		//2.birim ekleme bitti.
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.display = "<cfoutput>#attributes.product_name2_display#</cfoutput>";
		newCell.innerHTML = '<div class="form-group"><input type="text" name="product_name2_exit' + row_count_exit +'" id="product_name2_exit' + row_count_exit +'" style="width:70px;" value=""></div>';
		<cfif isdefined("x_is_show_sb") and x_is_show_sb>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="checkbox" name="is_sevkiyat' + row_count_exit +'" id="is_sevkiyat' + row_count_exit +'">';
		</cfif>
		<cfif isdefined('x_is_show_mc') and x_is_show_mc eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="checkbox" name="is_manual_cost_exit' + row_count_exit +'" id="is_manual_cost_exit' + row_count_exit +'" value="1">';
		</cfif>
	<cfelseif isdefined("attributes.type") and (attributes.type eq 2)>
		row_count_outage = #attributes.record_num_outage#;
		row_count_outage++;
		window.opener.row_count_outage=row_count_outage;
		var newRow;
		var newCell;
		newRow = window.opener.document.getElementById("table3_body").insertRow(opener.document.getElementById("table3_body").rows.length);
		newRow.setAttribute("name","frm_row_outage" + row_count_outage);
		newRow.setAttribute("id","frm_row_outage" + row_count_outage);
		newRow.setAttribute("NAME","frm_row_outage" + row_count_outage);
		newRow.setAttribute("ID","frm_row_outage" + row_count_outage);
		newRow.setAttribute('height','20');
		window.opener.document.getElementById('record_num_outage').value = row_count_outage;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign="center";
		newCell.innerHTML = '<input type="hidden" name="row_kontrol_outage' + row_count_outage +'" id="row_kontrol_outage' + row_count_outage +'" value="1"><a style="cursor:pointer" onclick="sil_outage(' + row_count_outage + ');"><img  src="images/delete_list.gif" border="0" align="absmiddle" alt="Sil"></a><input type="hidden" name="cost_id_outage' + row_count_outage +'" id="cost_id_outage' + row_count_outage +'" value="#cost_id#"><input type="hidden" name="product_cost_outage' + row_count_outage +'" id="product_cost_outage' + row_count_outage +'" value="#product_cost#"><input type="hidden" name="product_cost_money_outage' + row_count_outage +'" id="product_cost_money_outage' + row_count_outage +'" value="#product_cost_money#"><input type="hidden" name="cost_price_system_outage' + row_count_outage +'" id="cost_price_system_outage' + row_count_outage +'" value="#cost_price_system#"><input type="hidden" name="money_system_outage' + row_count_outage +'" id="money_system_outage' + row_count_outage +'" value="#cost_price_system_money#"><input type="hidden" name="purchase_extra_cost_system_outage' + row_count_outage +'" id="purchase_extra_cost_system_outage' + row_count_outage +'" value="#purchase_extra_cost_system#">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="stock_code_outage' + row_count_outage +'" id="stock_code_outage' + row_count_outage +'" value="#attributes.stock_code#" readonly style="width:120px;"><input type="hidden" name="kdv_amount_outage' + row_count_outage +'" id="kdv_amount_outage' + row_count_outage +'" value="#attributes.tax#"></div>';
		<cfif x_is_barkod_col eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="barcode_outage' + row_count_outage +'" id="barcode_outage' + row_count_outage +'" value="#attributes.barcode#" readonly style="width:90px;"></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="product_id_outage' + row_count_outage +'" id="product_id_outage' + row_count_outage +'" value="#attributes.product_id#"><input type="hidden" name="stock_id_outage' + row_count_outage +'" id="stock_id_outage' + row_count_outage +'" value="#attributes.stock_id#"><input type="text" name="product_name_outage' + row_count_outage +'" id="product_name_outage' + row_count_outage +'" value="#attributes.product_name# #attributes.property#" readonly style="width:230px;"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		<cfif len(attributes.spec_img_display)>
			newCell.style.display = 'none';
		</cfif>
		xxx_ = ReplaceAll("#attributes.spec_name#","'","");
		newCell.innerHTML = '<div class="form-group"><div class="col col-3"><input type="#attributes.spec_display#" name="spec_main_id_outage' + row_count_outage +'" id="spec_main_id_outage' + row_count_outage +'" value="#attributes.SPECT_MAIN_ID#" readonly style="width:40px;"></div><div class="col col-3"> <input type="#attributes.spec_display#" name="spect_id_outage' + row_count_outage +'" id="spect_id_outage' + row_count_outage +'" value=""style="width:40px;"></div><div class="col col-6"><div class="input-group"> <input type="#attributes.spec_name_display#" name="spect_name_outage' + row_count_outage +'" id="spect_name_outage' + row_count_outage +'" value="'+xxx_+'" readonly style="width:150px;"> <span class="input-group-addon icon-ellipsis" onClick="pencere_ac_spect('+ row_count_outage +',3);"></span></div></div></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="lot_no_outage' + row_count_outage +'" id="lot_no_outage' + row_count_outage +'" value="" onKeyup="lotno_control('+ row_count_outage +',3);" style="width:75px;"> <span class="input-group-addon icon-ellipsis"  onClick="pencere_ac_list_product('+ row_count_outage +',3);"></span></div></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"> <input type="text" name="expiration_date_outage' + row_count_outage +'" id="expiration_date_outage' + row_count_outage +'" value=""  style="width:70px;"><span class="input-group-addon" id="expiration_date_outage'+row_count_outage +'_td"></span></div></div>';
		window.opener.wrk_date_image('expiration_date_outage' + row_count_outage);

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" onchange="find_amount2_outage(row_count_outage)" name="amount_outage' + row_count_outage +'" id="amount_outage' + row_count_outage +'" value="#TlFormat(attributes.amount,round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(' + row_count_outage +',2);" class="moneybox" style="width:70px;"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="unit_id_outage' + row_count_outage +'" id="unit_id_outage' + row_count_outage +'" value="#attributes.unit_id#"><input type="text" name="unit_outage' + row_count_outage +'" id="unit_outage' + row_count_outage +'" value="#attributes.unit#" readonly style="width:60px;"><input type="hidden" name="serial_no_outage' + row_count_outage +'" id="serial_no_outage' + row_count_outage +'" value=""></div>';
		newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" onchange="find_amount2_outage(row_count_outage);Get_Product_Unit_2_And_Quantity_2_outage(row_count_outage)"  name="weight_outage' + row_count_outage +'" id="weight_outage' + row_count_outage +'"   style="width:60px;"></div>';
		<cfif isdefined('x_is_show_abh') and x_is_show_abh eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" onchange="Get_Product_Unit_2_And_Quantity_2_outage(row_count_outage)" name="width_outage' + row_count_outage +'" id="width_outage' + row_count_outage +'"   style="width:60px;"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" onchange="Get_Product_Unit_2_And_Quantity_2_outage(row_count_outage)"  name="height_outage' + row_count_outage +'" id="height_outage' + row_count_outage +'"   style="width:60px;"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" onchange="Get_Product_Unit_2_And_Quantity_2_outage(row_count_outage)"  name="length_outage' + row_count_outage +'" id="length_outage' + row_count_outage +'"   style="width:60px;"></div>';
		</cfif>
		<cfif isdefined('xml_specific_weight') and xml_specific_weight eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" onchange="find_weight_outage(row_count_outage)"  name="specific_weight_outage' + row_count_outage +'" id="specific_weight_outage' + row_count_outage +'"   style="width:60px;"></div>';
		</cfif>
		<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="cost_price_outage' + row_count_outage +'" id="cost_price_outage' + row_count_outage +'" value="#TlFormat(cost_price,round_number)#" <cfif attributes.is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_outage+',3);"</cfif> class="moneybox" onKeyup="return(FormatCurrency(this,event,8));"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="purchase_extra_cost_outage' + row_count_outage +'" id="purchase_extra_cost_outage' + row_count_outage +'" <cfif attributes.is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_outage+',3);"</cfif> value="#TlFormat(purchase_extra_cost,round_number)#" class="moneybox" onKeyup="return(FormatCurrency(this,event,8));"></div>';
			<cfif x_is_show_labor_cost eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="labor_cost_outage' + row_count_outage +'" id="labor_cost_outage' + row_count_outage +'" value="" style="width:90px;"></div>';
			</cfif>
			<cfif x_is_show_refl_cost eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="reflection_cost_outage' + row_count_outage +'" id="reflection_cost_outage' + row_count_outage +'" value="" style="width:90px;"></div>';
			</cfif>
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="total_cost_price_outage' + row_count_outage +'" id="total_cost_price_outage' + row_count_outage +'" value="#TlFormat((cost_price+purchase_extra_cost)*attributes.amount,round_number)#" readonly class="moneybox" onKeyup="return(FormatCurrency(this,event,8));"></div>';
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="money_outage' + row_count_outage +'" id="money_outage' + row_count_outage +'" value="#cost_price_money#" readonly style="width:50px;"></div>';
			<cfif isdefined('x_is_cost_price_2') and x_is_cost_price_2 eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="cost_price_outage_2' + row_count_outage +'" id="cost_price_outage_2' + row_count_outage +'" value="#TlFormat(cost_price_2,round_number)#" class="moneybox" <cfif attributes.is_change_sarf_cost eq 0>readonly</cfif> onKeyup="return(FormatCurrency(this,event,8));"></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="purchase_extra_cost_outage_2' + row_count_outage +'" id="purchase_extra_cost_outage_2' + row_count_outage +'" value="#TlFormat(purchase_extra_cost_system_2,round_number)#" <cfif attributes.is_change_sarf_cost eq 0>readonly</cfif> class="moneybox"></div>';
				<cfif x_is_show_labor_cost eq 1>
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="labor_cost_outage_2' + row_count_outage +'" id="labor_cost_outage_2' + row_count_outage +'" value="" style="width:90px;"></div>';
				</cfif>
				<cfif x_is_show_refl_cost eq 1>
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="reflection_cost_outage_2' + row_count_outage +'" id="reflection_cost_outage_2' + row_count_outage +'" value="" style="width:90px;"></div>';
				</cfif>
				<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="total_cost_price_outage_2' + row_count_outage +'" id="total_cost_price_outage_2' + row_count_outage +'" value="#TlFormat((cost_price_2+purchase_extra_cost_system_2)*attributes.amount,round_number)#" readonly class="moneybox" onKeyup="return(FormatCurrency(this,event,8));"></div>';
				</cfif>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="money_outage_2' + row_count_outage +'" id="money_outage_2' + row_count_outage +'" value="#cost_price_money_2#" readonly style="width:50px;"></div>';
			</cfif>
		<cfelse>
			newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="money_outage_2' + row_count_outage +'" id="money_outage_2' + row_count_outage +'" value="#cost_price_money_2#" readonly style="width:50px;"><input type="hidden" name="purchase_extra_cost_outage_2' + row_count_outage +'" id="purchase_extra_cost_outage_2' + row_count_outage +'" value="#TlFormat(purchase_extra_cost_system_2,round_number)#" readonly class="moneybox"><input type="hidden" name="cost_price_outage_2' + row_count_outage +'" id="cost_price_outage_2' + row_count_outage +'" value="#TlFormat(cost_price_2,round_number)#" class="moneybox" onKeyup="return(FormatCurrency(this,event,8));"><input type="hidden" name="money_outage' + row_count_outage +'" id="money_outage' + row_count_outage +'" value="#cost_price_money#" readonly style="width:50px;"><input type="hidden" name="purchase_extra_cost_outage' + row_count_outage +'" id="purchase_extra_cost_outage' + row_count_outage +'" value="#TlFormat(purchase_extra_cost,round_number)#" class="moneybox" onKeyup="return(FormatCurrency(this,event,8));"><input type="hidden" name="cost_price_outage' + row_count_outage +'" id="cost_price_outage' + row_count_outage +'" value="#TlFormat(cost_price,round_number)#" class="moneybox" onKeyup="return(FormatCurrency(this,event,8));">';
		</cfif>
		<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text"  onchange="Get_Product_Unit_2_And_Quantity_2_outage(row_count_outage)" name="amount_outage2_' + row_count_outage +'" id="amount_outage2_' + row_count_outage +'" value="" onKeyup="return(FormatCurrency(this,event,8));" onBlur="" class="moneybox" style="width:70px;"></div>';
			//2.birim ekleme
			var get_Unit2_Prod = wrk_safe_query('prdp_get_unit2_prod','dsn3',0,#attributes.product_id#)
			var unit2_values ='<div class="form-group"><select name="unit2_outage'+row_count_outage+'" style="width:60;">';
			if(get_Unit2_Prod.recordcount){
				for(xx=0;xx<get_Unit2_Prod.recordcount;xx++)
					unit2_values += '<option value="'+get_Unit2_Prod.ADD_UNIT[xx]+'">'+get_Unit2_Prod.ADD_UNIT[xx]+'</option>';
			}
			unit2_values +='</select></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = ''+unit2_values+'';
			//2.birim ekleme bitti.
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.display = "<cfoutput>#attributes.product_name2_display#</cfoutput>";
		newCell.innerHTML = '<div class="form-group"><input type="text" name="product_name2_outage' + row_count_outage +'" id="product_name2_outage' + row_count_outage +'" style="width:50px;" value=""></div>';
		<cfif isdefined('x_is_show_mc') and x_is_show_mc eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="checkbox" name="is_manual_cost_outage' + row_count_outage +'" id="is_manual_cost_outage' + row_count_outage +'" value="1">';
		</cfif>
	
	<cfelse>
		<cfquery name="GET_DET_PU" datasource="#dsn3#">
			SELECT 
				PU.MAIN_UNIT, 
				PU.PRODUCT_UNIT_ID 
			FROM 
				PRODUCT_UNIT PU 
			WHERE 
				PRODUCT_ID = #attributes.product_id# AND
				IS_MAIN = 1
		</cfquery>
		<cfquery name="GET_DET_PUL" datasource="#dsn3#">
			SELECT 
				PU.ADD_UNIT, 
				PU.PRODUCT_UNIT_ID 
			FROM 
				PRODUCT_UNIT PU 
			WHERE 
				PRODUCT_ID = #attributes.product_id# AND
				PRODUCT_UNIT_ID <> #GET_DET_PU.PRODUCT_UNIT_ID#
		</cfquery>		
		row_count = #attributes.record_num#;
		
		row_count++;
		opener.row_count=row_count;
		var newRow;
		var newCell;
		
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row_enter" + row_count);
		newRow.setAttribute("id","frm_row_enter" + row_count);
		newRow.setAttribute("NAME","frm_row_enter" + row_count);
		newRow.setAttribute("ID","frm_row_enter" + row_count);
		opener.document.all.record_num.value = row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="fa fa-minus"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'" value="#attributes.stock_id#"><input type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'" value="#attributes.product_id#"><input type="text" name="product_name' + row_count +'" id="product_name' + row_count +'" value="#attributes.product_name# #attributes.property#" readonly style="width:220px;"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="io' + row_count +'" style="width:70px;"><option value="0">Çıktı</option><option value="1">Sarf</option><option value="2">Fire</option></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="amount' + row_count +'" id="amount' + row_count +'" value="1" onBlur="hesapla_deger(' + row_count +',1);" onKeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:50px;"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="birim' + row_count +'" style="width:50px;"><cfloop query="get_det_pu"><option value="0">#main_unit#</option></cfloop><cfloop query="get_det_pul"><option value="#product_unit_id#">#add_unit#</option></cfloop></select></div>';
	</cfif>
	<cfif isdefined("attributes.record_num")>
		window.location = '#request.self#?fuseaction=prod.popup_add_product&#attributes.pre_url_info#&record_num='+row_count+'';
	<cfelseif isdefined("attributes.record_num_exit")>
		window.location = '#request.self#?fuseaction=prod.popup_add_product&#attributes.pre_url_info#&record_num_exit='+row_count_exit+'';
	<cfelseif isdefined("attributes.record_num_outage")>
		window.location = '#request.self#?fuseaction=prod.popup_add_product&#attributes.pre_url_info#&record_num_outage='+row_count_outage+'';
	</cfif>
	//window.close();
</cfoutput>
</script>
