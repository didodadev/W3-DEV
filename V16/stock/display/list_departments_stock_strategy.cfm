<cfsetting showdebugoutput="no">
<cfparam name="attributes.our_comp_id" default="#session.ep.company_id#">
<cfquery name="GET_STRATEGY" datasource="#dsn3#">
	SELECT DISTINCT 
		SS.STOCK_STRATEGY_ID,
		SS.PRODUCT_ID,
		SS.STOCK_ID,
		SS.MAXIMUM_STOCK,
		SS.PROVISION_TIME,
		SS.REPEAT_STOCK_VALUE,
		SS.MINIMUM_STOCK,
		SS.MINIMUM_ORDER_STOCK_VALUE,
		SS.MINIMUM_ORDER_UNIT_ID,
		SS.CRITERION_ID,
		SS.ADD_FACTOR_ID,
		SS.IS_LIVE_ORDER,
		SS.STRATEGY_TYPE,
		SS.STRATEGY_ORDER_TYPE,
		SS.DEPARTMENT_ID,
		SS.BLOCK_STOCK_VALUE,
		SS.STOCK_ACTION_ID,
        SS.RECORD_DATE,
        SS.RECORD_EMP,
        SS.RECORD_IP,
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.PRODUCT_UNIT_ID,	
        '' AS UPDATE_DATE,
        '' AS UPDATE_EMP,
        '' AS UPDATE_IP
	FROM
		STOCK_STRATEGY SS, 
		PRODUCT_UNIT
	WHERE
		PRODUCT_UNIT.PRODUCT_UNIT_ID = SS.MINIMUM_ORDER_UNIT_ID AND
		PRODUCT_UNIT.PRODUCT_ID = SS.PRODUCT_ID AND
		PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND
		SS.DEPARTMENT_ID IS NOT NULL AND 
		SS.STOCK_ID = #attributes.sid#
	ORDER BY
		SS.STOCK_STRATEGY_ID
</cfquery>
<cfquery name="get_department_head" datasource="#dsn#">
	SELECT 
		D.DEPARTMENT_ID,
		D.DEPARTMENT_HEAD,
		D.BRANCH_ID,
		B.BRANCH_ID
	FROM 
		DEPARTMENT D,
		BRANCH B
	WHERE
		D.BRANCH_ID = B.BRANCH_ID AND 
		D.DEPARTMENT_STATUS = 1 AND
		D.IS_STORE <> 2 AND
		B.COMPANY_ID = #session.ep.company_id#
	ORDER BY 
		D.DEPARTMENT_HEAD
</cfquery>
<cfquery name="GET_PRODUCT_UNIT" datasource="#dsn3#">
	SELECT 
		PRODUCT_ID,
		PRODUCT_UNIT_STATUS,
		PRODUCT_UNIT_ID,
		ADD_UNIT
	FROM 
		PRODUCT_UNIT
	WHERE 
		PRODUCT_ID = #attributes.pid# AND 
		PRODUCT_UNIT_STATUS = 1
</cfquery>
<cfquery name="PRODUCT_TOTAL_STOCK" datasource="#dsn2#">
	SELECT 
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
		DEPARTMENT_ID
	FROM 
		GET_STOCK_PRODUCT 
	WHERE 
		STOCK_ID = #attributes.sid# AND
		DEPARTMENT_ID IS NOT NULL
	GROUP BY
		STOCK_ID,
		DEPARTMENT_ID
</cfquery>
<cfquery name="GET_SALEABLE_STOCK_ACTION" datasource="#DSN3#">
	SELECT STOCK_ACTION_ID,STOCK_ACTION_NAME FROM SETUP_SALEABLE_STOCK_ACTION
</cfquery>
<cfscript>
	if(GET_STRATEGY.recordcount)
	{
		for(str_i=1;str_i lte GET_STRATEGY.recordcount;str_i=str_i+1)
		{
			'strategy_min_stock_#GET_STRATEGY.DEPARTMENT_ID[str_i]#'=GET_STRATEGY.MINIMUM_STOCK[str_i];
			'strategy_max_stock_#GET_STRATEGY.DEPARTMENT_ID[str_i]#'=GET_STRATEGY.MAXIMUM_STOCK[str_i];
			'strategy_min_order_stock_value_#GET_STRATEGY.DEPARTMENT_ID[str_i]#'= GET_STRATEGY.MINIMUM_ORDER_STOCK_VALUE[str_i];
			'strategy_repeat_stock_value_#GET_STRATEGY.DEPARTMENT_ID[str_i]#'= GET_STRATEGY.REPEAT_STOCK_VALUE[str_i];
			'strategy_provision_time_#GET_STRATEGY.DEPARTMENT_ID[str_i]#'= GET_STRATEGY.PROVISION_TIME[str_i];
			'strategy_type_#GET_STRATEGY.DEPARTMENT_ID[str_i]#'= GET_STRATEGY.STRATEGY_TYPE[str_i];
			'strategy_islive_order_#GET_STRATEGY.DEPARTMENT_ID[str_i]#'= GET_STRATEGY.IS_LIVE_ORDER[str_i];
			'strategy_min_order_unit_#GET_STRATEGY.DEPARTMENT_ID[str_i]#'= GET_STRATEGY.MINIMUM_ORDER_UNIT_ID[str_i];
			if(len(GET_STRATEGY.STRATEGY_ORDER_TYPE[str_i]))
				'strategy_order_type_#GET_STRATEGY.DEPARTMENT_ID[str_i]#'= GET_STRATEGY.STRATEGY_ORDER_TYPE[str_i];
			else
				'strategy_order_type_#GET_STRATEGY.DEPARTMENT_ID[str_i]#'= "";
			'strategy_block_stock_value_#GET_STRATEGY.DEPARTMENT_ID[str_i]#'= GET_STRATEGY.BLOCK_STOCK_VALUE[str_i];
			'saleable_stock_action_id_#GET_STRATEGY.DEPARTMENT_ID[str_i]#'= GET_STRATEGY.STOCK_ACTION_ID[str_i];
		}
	}
	if(PRODUCT_TOTAL_STOCK.recordcount)
	{
		for(ii=1;ii lte product_total_stock.recordcount;ii=ii+1)
			'total_stock_amount_#PRODUCT_TOTAL_STOCK.DEPARTMENT_ID[ii]#'=PRODUCT_TOTAL_STOCK.PRODUCT_STOCK[ii];
	}
</cfscript>
<cf_box title="#getLang('stock',24)#:#get_product_name(product_id:attributes.pid)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"> 
<cfform name="list_stock_str" action="#request.self#?fuseaction=stock.emptypopup_add_product_strategy" method="post">
<cf_grid_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='58763.Depo'></th>
			<th nowrap="nowrap"><cf_get_lang dictionary_id='44728.Strateji Türü'></th>
			<th nowrap="nowrap"><cf_get_lang dictionary_id='37321.Minimum'></th>
			<th nowrap="nowrap"><cf_get_lang dictionary_id='63814.Maximum'></th>
			<th><cf_get_lang dictionary_id ='58882.Bloke Stok'></th>
			<th nowrap="nowrap"><cf_get_lang dictionary_id ='44734.Minimum Sipariş Miktarı'></th>
			<th width="50"><cf_get_lang dictionary_id ='57636.Birim'></th>
			<th><cf_get_lang dictionary_id ='45707.Sipariş Tipi'></th>
			<th><cf_get_lang dictionary_id='44740.Tedarik Süresi'></th>
			<th><cf_get_lang dictionary_id='45205.Yeniden Sip Noktası'></th>
			<th><cf_get_lang dictionary_id ='51408.Stok Miktarı'></th>
			<th width="40" nowrap="nowrap"><cf_get_lang dictionary_id ='44743.Yeniden Sip Noktasında Uyar'></th>
			<th nowrap="nowrap"><cf_get_lang dictionary_id ='58747.Satılabilir Stok Prensipleri'></th>
			<th></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_department_head.recordcount>
		<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_department_head.recordcount#</cfoutput>">
		<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.pid#</cfoutput>">
		<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.sid#</cfoutput>">
		<cfoutput query="get_department_head">
		<cfset row_dept_id = DEPARTMENT_ID>
			<tr>
				<input type="hidden" name="department_id#currentrow#" id="department_id#currentrow#" value="#row_dept_id#">
				<td width="10"><input type="text" name="department_head#currentrow#" id="department_head#currentrow#" value="#department_head#" class="boxtext" style="width:95px;" readonly=""></td>
				<td width="10">
					<div class="form-group">
					<select name="strategy_type#currentrow#" id="strategy_type#currentrow#" value="" required="yes">
						<option value="1"<cfif isdefined('strategy_type_#row_dept_id#') and len(evaluate('strategy_type_#row_dept_id#'))and evaluate('strategy_type_#row_dept_id#') eq 1>selected</cfif>><cf_get_lang dictionary_id='57490.Gün'></option>
						<option value="0"<cfif isdefined('strategy_type_#row_dept_id#') and len(evaluate('strategy_type_#row_dept_id#'))and evaluate('strategy_type_#row_dept_id#') eq 0>selected</cfif>><cf_get_lang dictionary_id='57636.Birim'></option>
					</select>
				</div>
				</td>
				<td width="60" style="text-align:right;" title="<cf_get_lang dictionary_id='37321.Minimum'>"><input type="text" name="minimum_stock#currentrow#" id="minimum_stock#currentrow#" value="<cfif isdefined('strategy_min_stock_#row_dept_id#') and len(evaluate('strategy_min_stock_#row_dept_id#'))>#evaluate('strategy_min_stock_#row_dept_id#')#</cfif>" onkeyup="return(FormatCurrency(this,event,0));" class="box" style="width:50px;" onBlur="chk_strategy(#currentrow#);"></td>
				<td width="60" style="text-align:right;" title="<cf_get_lang dictionary_id='63814.Maximum'>"><input type="text" name="maximum_stock#currentrow#" id="maximum_stock#currentrow#" value="<cfif isdefined('strategy_max_stock_#row_dept_id#') and len(evaluate('strategy_max_stock_#row_dept_id#'))>#evaluate('strategy_max_stock_#row_dept_id#')#</cfif>" onkeyup="return(FormatCurrency(this,event,0));" class="box" style="width:50px;" onBlur="chk_strategy(#currentrow#);"></td><!---  required="yes" --->
				<td width="60" style="text-align:right;" title="Bloke Stok"><input type="text" name="block_stock_value#currentrow#" id="block_stock_value#currentrow#" value="<cfif isdefined('strategy_block_stock_value_#row_dept_id#') and len(evaluate('strategy_block_stock_value_#row_dept_id#'))>#evaluate('strategy_block_stock_value_#row_dept_id#')#</cfif>" onkeyup="return(FormatCurrency(this,event,0));" class="box" style="width:50px;" onBlur="chk_strategy(#currentrow#);"></td><!---  required="yes" --->
				<td width="60" style="text-align:right;" title="<cf_get_lang dictionary_id ='44734.Minimum Sipariş Miktarı'>"><input type="text" name="minimum_order_stock_value#currentrow#" id="minimum_order_stock_value#currentrow#"  value="<cfif isdefined('strategy_min_order_stock_value_#row_dept_id#') and len(evaluate('strategy_min_order_stock_value_#row_dept_id#'))>#evaluate('strategy_min_order_stock_value_#row_dept_id#')#</cfif>" passthrough="onkeyup=""return(FormatCurrency(this,event,0));""" class="box" style="width:50px;"onBlur="chk_strategy(#currentrow#);"></td>
				<td width="10">
					<div class="form-group">
					<select name="minimum_order_unit_id#currentrow#" id="minimum_order_unit_id#currentrow#">
						<cfloop query="get_product_unit">
						<cfset _birim_ = product_unit_id>
							<option value="#product_unit_id#" <cfif isdefined('strategy_min_order_unit_#row_dept_id#') and len(evaluate('strategy_min_order_unit_#row_dept_id#')) and evaluate('strategy_min_order_unit_#row_dept_id#') eq _birim_>selected</cfif>>#ADD_UNIT#</option>
						</cfloop>
					</select>
				</div>				
			</td>
				<td title="Sipariş Tipi">
					<div class="form-group">
					<select name="strategy_order_type#currentrow#" id="strategy_order_type#currentrow#" style="width:100px;" class="box">
						<option value="0"<cfif isdefined('strategy_order_type_#row_dept_id#') and len(evaluate('strategy_order_type_#row_dept_id#')) and evaluate('strategy_order_type_#row_dept_id#') eq 0>selected</cfif>><cf_get_lang dictionary_id ='45706.Artarak Devam'></option>
						<option value="1"<cfif isdefined('strategy_order_type_#row_dept_id#') and len(evaluate('strategy_order_type_#row_dept_id#')) and evaluate('strategy_order_type_#row_dept_id#') eq 1>selected</cfif>><cf_get_lang dictionary_id ='45705.Katları Şeklinde'></option>
					</select>
				</div>
				</td>
				<td width="60" style="text-align:right;" title="Tedarik Süresi"><input type="text" style="width:50px;" name="provision_time#currentrow#" id="provision_time#currentrow#" value="<cfif isdefined('strategy_provision_time_#row_dept_id#') and len(evaluate('strategy_provision_time_#row_dept_id#'))>#evaluate('strategy_provision_time_#row_dept_id#')#</cfif>" class="box" onBlur="chk_strategy(#currentrow#);"></td>
				<td width="95" style="text-align:right;" title="Yeniden Sipariş Noktası"><input type="text" style="width:90px;" name="repeat_stock_value#currentrow#" id="repeat_stock_value#currentrow#" value="<cfif isdefined('strategy_repeat_stock_value_#row_dept_id#') and len(evaluate('strategy_repeat_stock_value_#row_dept_id#'))>#evaluate('strategy_repeat_stock_value_#row_dept_id#')#</cfif>" passthrough="onkeyup=""return(FormatCurrency(this,event,0));""" class="box"  onBlur="chk_strategy(#currentrow#);"></td>
				<td style="text-align:right;"><cfif isdefined('total_stock_amount_#row_dept_id#') and len(evaluate('total_stock_amount_#row_dept_id#'))>#AmountFormat(evaluate('total_stock_amount_#row_dept_id#'))#</cfif></td>
				<td width="80" title="Yeniden Sipariş Noktasında Uyar"><input type="checkbox" value="1" name="is_live_order#currentrow#" id="is_live_order#currentrow#" <cfif isdefined('strategy_islive_order_#row_dept_id#') and len(evaluate('strategy_islive_order_#row_dept_id#')) and evaluate('strategy_islive_order_#row_dept_id#') eq 1>checked</cfif>></td>
				<td width="100">
					<div class="form-group">
					<select name="saleable_stock_action_id#currentrow#" id="saleable_stock_action_id#currentrow#" style="width:120px;">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>!</option>
						<cfloop query="GET_SALEABLE_STOCK_ACTION">
							<option value="#GET_SALEABLE_STOCK_ACTION.STOCK_ACTION_ID#" <cfif isdefined('saleable_stock_action_id_#row_dept_id#') and len(evaluate('saleable_stock_action_id_#row_dept_id#')) and GET_SALEABLE_STOCK_ACTION.STOCK_ACTION_ID>selected</cfif>>#GET_SALEABLE_STOCK_ACTION.STOCK_ACTION_NAME#</option>
						</cfloop>
					</select>
					</div>
				</td>
				<td width="15"><input type="checkbox" name="add_strategy#currentrow#" id="add_strategy#currentrow#" value="1" <cfif isdefined('strategy_type_#row_dept_id#') and len(evaluate('strategy_type_#row_dept_id#'))> checked </cfif> class="box"></td>
			</tr>
		</cfoutput>
	</tbody>
<cfelse>
	<tr>
		<td colspan="14"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
	</tr>
</cfif>
</cf_grid_list>
<cf_box_footer>
	<cfif get_department_head.recordcount and GET_STRATEGY.recordcount>
		<cf_record_info query_name="GET_STRATEGY">
	</cfif>
	<div id="_USER_INFO_MESSAGE_"></div> <cf_workcube_buttons type_format='1' is_upd='0' add_function='form_control1()'>
</cf_box_footer>
</cfform>
</cf_box>
<script type="text/javascript">
var rec_n = $('#list_stock_str #record_num').val();

function chk_strategy(id)
{
	if ($('#list_stock_str #minimum_stock'+id).val() !='' && $('#list_stock_str #maximum_stock'+id).val() != '' &&  $('#list_stock_str #minimum_order_stock_value'+id).val() !='' && $('#list_stock_str #provision_time'+id).val() !='' && $('#list_stock_str #repeat_stock_value'+id).val() !='' )
		$('#list_stock_str #add_strategy'+id).prop('checked', true);
	else
		$('#list_stock_str #add_strategy'+id).prop('checked', false);
}
function form_control1()
{
	for(var i=1;i<rec_n;i++)
	{
		if($('#list_stock_str #add_strategy'+i).is(':checked') ==true) 
		{
			if ($('#list_stock_str #minimum_stock'+i).val() =="" || $('#list_stock_str #maximum_stock'+i).val() == "" ||  $('#list_stock_str #minimum_order_stock_value'+i).val() =="" || $('#list_stock_str #provision_time'+i).val() =="" || $('#list_stock_str #repeat_stock_value'+i).val() =="" )
			{	
				alert("<cf_get_lang dictionary_id ='45611.Lütfen depo stratejisindeki tüm bilgileri giriniz'>...");
				return false;
			}
		}
	}
	for(var k=1;k<rec_n;k++)
	{
		if(document.getElementById('add_strategy'+k).checked == true)
		{	
			document.getElementById('minimum_stock'+k).value=filterNum(document.getElementById('minimum_stock'+k).value);
			document.getElementById('maximum_stock'+k).value=filterNum(document.getElementById('maximum_stock'+k).value);
			document.getElementById('minimum_order_stock_value'+k).value=filterNum(document.getElementById('minimum_order_stock_value'+k).value);
			document.getElementById('provision_time'+k).value=filterNum(document.getElementById('provision_time'+k).value);
			document.getElementById('repeat_stock_value'+k).value=filterNum(document.getElementById('repeat_stock_value'+k).value);
			document.getElementById('block_stock_value'+k).value=filterNum(document.getElementById('block_stock_value'+k).value);
		}
	}
	return true;
	/*AjaxFormSubmit('add_stock_str','_USER_INFO_MESSAGE_','1',"<cf_get_lang dictionary_id='58889.Kaydediliyor'>..","<cf_get_lang dictionary_id='58890.Kaydedildi'>","<cfoutput>#request.self#?fuseaction=stock.popup_list_departments_stock_strategy&pid=#attributes.pid#&sid=#attributes.sid#</cfoutput>",'XXXXXXXXXXXXXXXX');
	return false;*/
}
</script>
