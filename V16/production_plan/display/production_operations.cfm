<cfsetting showdebugoutput="no">
<cfquery name="GET_PRODUCTION_OPERATIONS_RESULT_TOTAL" datasource="#DSN3#">
	SELECT
		ISNULL(SUM(REAL_AMOUNT),0) REAL_AMOUNT,
		ISNULL(SUM(LOSS_AMOUNT),0) LOSS_AMOUNT,
		ISNULL(SUM(REAL_TIME),0) REAL_TIME,
		ISNULL(SUM(WAIT_TIME),0) WAIT_TIME,
		POR.OPERATION_ID
	FROM
		PRODUCTION_OPERATION_RESULT POR
	WHERE
		POR.P_ORDER_ID = #attributes.upd#
	GROUP BY
		POR.OPERATION_ID
</cfquery>
<cfquery name="GET_PRODUCTION_OPERATIONS" datasource="#DSN3#">
	SELECT
    	PO.OPERATION_TYPE_ID,
    	(SELECT OPERATION_TYPE FROM OPERATION_TYPES WHERE OPERATION_TYPES.OPERATION_TYPE_ID=PO.OPERATION_TYPE_ID) AS OPERATION_TYPE,
    	ISNULL(O_MINUTE,0) AS O_MINUTE,
        (SELECT STATION_NAME FROM WORKSTATIONS WS WHERE WS.STATION_ID = PO.STATION_ID) AS STATION_NAME,
		PO.AMOUNT,
		PO.P_OPERATION_ID,
		PO.STATION_ID,
		ISNULL((SELECT SUM(POR.REAL_AMOUNT) FROM PRODUCTION_OPERATION_RESULT POR WHERE POR.OPERATION_ID = PO.P_OPERATION_ID AND POR.P_ORDER_ID = #attributes.upd#),0) RESULT_AMOUNT
	FROM
		PRODUCTION_OPERATION PO
	WHERE
		PO.P_ORDER_ID = #attributes.upd#
	ORDER BY
		PO.P_OPERATION_ID DESC
</cfquery>
<cfset operation_type_id_list = listdeleteduplicates(ValueList(GET_PRODUCTION_OPERATIONS.OPERATION_TYPE_ID,','))>
<cfif len(operation_type_id_list)>
    <cfquery name="GET_STATIONS" datasource="#DSN3#">
        SELECT
        	0 AS MAIN_STOCK_ID ,
        	W.STATION_ID AS STATION_ID_ ,
            W.STATION_NAME,
            WP.OPERATION_TYPE_ID,
			ISNULL(WP.PRODUCTION_TIME,0) P_TIME
        FROM 
            WORKSTATIONS W,
            WORKSTATIONS_PRODUCTS WP
        WHERE
        	W.STATION_ID = WP.WS_ID 
            AND WP.OPERATION_TYPE_ID IN (#operation_type_id_list#)
    </cfquery>
<cfelse>
	<cfset GET_STATIONS.recordcount = 0>
</cfif>
<cfquery name="GET_PRODUCTION_OPERATION_RESULT" datasource="#DSN3#">
	SELECT
		PO.OPERATION_TYPE_ID,
		(SELECT OPERATION_TYPE FROM OPERATION_TYPES WHERE OPERATION_TYPES.OPERATION_TYPE_ID=PO.OPERATION_TYPE_ID) AS OPERATION_TYPE,
		ISNULL(O_MINUTE,0) AS O_MINUTE,
		POR.*,
		PO.AMOUNT
	FROM
		PRODUCTION_OPERATION_RESULT POR, 
		PRODUCTION_OPERATION PO
	WHERE
		PO.P_OPERATION_ID = POR.OPERATION_ID
		AND POR.P_ORDER_ID = #attributes.upd#	
</cfquery>
<cfoutput query="GET_PRODUCTION_OPERATIONS_RESULT_TOTAL">
	<cfset "real_amount_#operation_id#" = GET_PRODUCTION_OPERATIONS_RESULT_TOTAL.REAL_AMOUNT>
	<cfset "loss_amount_#operation_id#" = GET_PRODUCTION_OPERATIONS_RESULT_TOTAL.LOSS_AMOUNT>
	<cfset "real_time_#operation_id#" = GET_PRODUCTION_OPERATIONS_RESULT_TOTAL.REAL_TIME>
	<cfset "wait_time_#operation_id#" = GET_PRODUCTION_OPERATIONS_RESULT_TOTAL.WAIT_TIME>
</cfoutput>
<!---/*Operasyonlar*/--->
<cfsavecontent variable="message"><cf_get_lang dictionary_id='36376.Operasyonlar'></cfsavecontent>
<cf_seperator title="#message#" id="operasyonlar_" is_closed="1">
<div id="operasyonlar_" style="display:none;">
	<cf_grid_list>
		<thead>
			<tr>
				<th width="40"><cf_get_lang dictionary_id='57487.No'></th>
				<th width="130" nowrap><cf_get_lang dictionary_id='29419.Operasyon'></th>
				<th width="110"><cf_get_lang dictionary_id='36498.Üretim Miktarı'></th>
				<th width="130"><cf_get_lang dictionary_id='58834.İstasyon'></th>
				<th><cf_get_lang dictionary_id='36510.Gerçekleşen Miktar'></th>
				<th><cf_get_lang dictionary_id='29471.Fire'></th>
				<th><cf_get_lang dictionary_id='36512.Gerçekleşen Süre'></th>
				<th><cf_get_lang dictionary_id='36517.Duruş Süresi'></th>
				<th width="1%"></th>
			</tr>
		</thead>
		<tbody id="table4" name="table4">
			<cfif GET_PRODUCTION_OPERATIONS.recordcount>
				<cfoutput query="GET_PRODUCTION_OPERATIONS">
					<tr>
						<td width="25">#currentrow#</td>
						<td nowrap>#OPERATION_TYPE#</td>
						<td class="moneybox">#TlFormat(AMOUNT)#</td>
						<td>#STATION_NAME#</td>
						<td class="moneybox"><cfif isdefined("real_amount_#p_operation_id#")>#TlFormat(evaluate("real_amount_#p_operation_id#"))#<cfelse>#TlFormat(0)#</cfif></td>
						<td class="moneybox"><cfif isdefined("loss_amount_#p_operation_id#")>#TlFormat(evaluate("loss_amount_#p_operation_id#"))#<cfelse>#TlFormat(0)#</cfif></td>
						<td class="moneybox"><cfif isdefined("real_time_#p_operation_id#")>#TlFormat(evaluate("real_time_#p_operation_id#"))#<cfelse>#TlFormat(0)#</cfif></td>
						<td class="moneybox"><cfif isdefined("wait_time_#p_operation_id#")>#TlFormat(evaluate("wait_time_#p_operation_id#"))#<cfelse>#TlFormat(0)#</cfif></td>
						<td></td>
					</tr>
				</cfoutput>
			</cfif>
		</tbody>
	</cf_grid_list>
</div>
<cfif GET_PRODUCTION_OPERATIONS.recordcount>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='58135.Sonuçlar'></cfsavecontent>
<cf_seperator header="#message#" id="operasyonlar1_" is_closed="1"><!--- id=operationResultHeader --->
<div id="operasyonlar1_" style="display:none;">
	<form name="UpdOperationResult" method="post" action="<cfoutput>#request.self#?fuseaction=prod.emptypopup_addOperationResult</cfoutput>">
    <cf_grid_list>
		<thead>
			<tr>
				<th width="25"><cf_get_lang dictionary_id='57487.No'></th>
				<th nowrap><cf_get_lang dictionary_id='29419.Operasyon'></th>
				<th nowrap><cf_get_lang dictionary_id='36519.Gerçekleştiren'></th>
				<th><cf_get_lang dictionary_id='36498.Üretim Miktarı'></th>
				<th><cf_get_lang dictionary_id='58834.İstasyon'></th>
				<th><cf_get_lang dictionary_id='36510.Gerçekleşen Miktar'></th>
				<th><cf_get_lang dictionary_id='29471.Fire'></th>
				<th><cf_get_lang dictionary_id='36512.Gerçekleşen Süre'></th>
				<th><cf_get_lang dictionary_id='36517.Duruş Süresi'></th>
				<th><div style="position:absolute;margin-left:250px;" id="deleteMessage"></div></th>
			</tr>
		</thead>
		<tbody id="table5" name="table5">
			 <cfif GET_PRODUCTION_OPERATION_RESULT.recordcount>
                <input type="hidden" name="STOCK_ID" id="STOCK_ID" value="<cfoutput>#attributes.STOCK_ID#</cfoutput>">
                <input type="hidden" name="upd_id" id="upd_id" value="<cfoutput>#attributes.upd#</cfoutput>">
                <input type="hidden" name="is_upd" id="is_upd" value="1">
                <input type="hidden" name="operation_count" id="operation_count" value="<cfoutput>#GET_PRODUCTION_OPERATION_RESULT.RECORDCOUNT#</cfoutput>">
                <cfquery name="get_product" datasource="#dsn1#">
                    SELECT PRODUCT_ID FROM STOCKS WHERE STOCK_ID = #attributes.STOCK_ID#
                </cfquery>
                <cfoutput query="GET_PRODUCTION_OPERATION_RESULT">
                    <cfquery name="GET_STATIONS___" dbtype="query">
                        SELECT * FROM GET_STATIONS WHERE OPERATION_TYPE_ID = #operation_type_id#
                    </cfquery>
                    <cfquery name="get_prod_quality" datasource="#dsn3#">
                        SELECT QUALITY_TYPE_ID FROM PRODUCT_QUALITY WHERE OPERATION_TYPE_ID LIKE '%#operation_type_id#%' AND PRODUCT_ID = #get_product.product_id#
                    </cfquery>
                    <tr id="result_#OPERATION_RESULT_ID#">
                        <input type="hidden" name="operation_result_id_#currentrow#" id="operation_result_id_#currentrow#" value="#operation_result_id#">
                        <td width="25">#currentrow#</td>
                        <td>#OPERATION_TYPE#</td>
                        <td nowrap>
                            <input type="hidden" name="employee_id_#CURRENTROW#" id="employee_id_#CURRENTROW#" value="#action_employee_id#">
                            <input type="text" name="employee_name_#CURRENTROW#" id="employee_name_#CURRENTROW#" value="#get_emp_info(action_employee_id,0,0)#" class="text">
                            <a href="javascript://" onClick="pencere_ac_employee1(#CURRENTROW#);"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" title="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>
                        </td>
                        <td class="moneybox">#TLformat(AMOUNT)#</td>
                        <td>
                            <select name="station_id_#CURRENTROW#" id="station_id_#CURRENTROW#" onChange="calc_time(#CURRENTROW#,2);">
                                <cfloop query="GET_STATIONS___">
                                    <option value="#STATION_ID_#;#P_TIME#" <cfif MAIN_STOCK_ID eq 0>style="background:CCCCCC"</cfif> <cfif STATION_ID_ eq GET_PRODUCTION_OPERATION_RESULT.STATION_ID>selected</cfif>>#STATION_NAME#</option>
                                </cfloop>
                            </select>
                        </td>
                        <td><input type="text" name="realized_amount_#CURRENTROW#" id="realized_amount_#CURRENTROW#" class="moneybox" value="#TlFormat(REAL_AMOUNT)#" onKeyup="return(FormatCurrency(this,event,4));" onBlur="calc_time(#CURRENTROW#,2);"></td>
                        <td><input type="text" name="fire_#CURRENTROW#" id="fire_#CURRENTROW#" class="moneybox" value="<cfif len(LOSS_AMOUNT)>#TlFormat(LOSS_AMOUNT)#<cfelse>#TlFormat(0)#</cfif>" onKeyup="return(FormatCurrency(this,event,4));"></td>
                        <td><input type="text" name="realized_duration_#CURRENTROW#" id="realized_duration_#CURRENTROW#" value="#TlFormat(REAL_TIME)#" class="moneybox"  onKeyup="isNumber(this,1);return(FormatCurrency(this,event,4));"></td>
                        <td><input type="text" name="duration_time_#CURRENTROW#" id="duration_time_#CURRENTROW#" value="<cfif len(WAIT_TIME)>#TlFormat(WAIT_TIME)#<cfelse>#TlFormat(0)#</cfif>" class="moneybox" onKeyup="isNumber(this,1);return(FormatCurrency(this,event,4));"></td>
                        <td style="text-align:center;20px;">
                            <a style="cursor:pointer;" onClick="deleteOperationRow(#OPERATION_RESULT_ID#);"><i class="fa fa-minus" align="absmiddle" border="0"/></i></a><cfif get_prod_quality.recordcount><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=prod.popup_add_quality_control_report&product_id=#get_product.product_id#&stock_id=#attributes.STOCK_ID#&process_id=#attributes.upd#&process_row_id=#operation_id#&process_cat=-1&operation_type_id=#operation_type_id#','project');"><img src="/images/control.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='36650.Kalite Kontrol'>"></a></cfif>
                        </td>
                    </tr>
                </cfoutput>
             </tbody>
             <tfoot>
                <tr>
                    <td colspan="10" style="text-align:right;"><div style="position:absolute;margin-left:-250px;" id="userSuccesMessage2"></div><button type="button"  name="UpdOperationR"class=" ui-wrk-btn ui-wrk-btn-success" id="UpdOperationR"  onClick="controlOperation(1);"><cf_get_lang dictionary_id='57464.Güncelle'></button></td>
                </tr>
             </tfoot>
         </cfif>
	</cf_grid_list>
	</form>
</div>
<!--- /*Operasyon Sonuç Girişi*/ --->
<cfsavecontent variable="message"><cf_get_lang dictionary_id='36520.Operasyon Sonuç Girişi'></cfsavecontent>
<cf_seperator header="#message#" id="operationResultHeader" is_closed="1"><!--- id=operationResultHeader --->
<div id="operationResultHeader" style="display:none;">
    <form name="AddOperationResult" method="post" action="<cfoutput>#request.self#?fuseaction=prod.emptypopup_addOperationResult</cfoutput>">
   	<cf_grid_list>
		<thead>
			<tr>
				<th width="25"><cf_get_lang dictionary_id='57487.No'></th>
				<th nowrap><cf_get_lang dictionary_id='29419.Operasyon'></th>
				<th nowrap><cf_get_lang dictionary_id='36519.Gerçekleştiren'></th>
				<th><cf_get_lang dictionary_id='36498.Üretim Miktarı'></th>
				<th><cf_get_lang dictionary_id='58834.İstasyon'></th>
				<th><cf_get_lang dictionary_id='36510.Gerçekleşen Miktar'></th>
				<th><cf_get_lang dictionary_id='29471.Fire'></th>
				<th><cf_get_lang dictionary_id='36512.Gerçekleşen Süre'></th>
				<th><cf_get_lang dictionary_id='36517.Duruş Süresi'></th>
				<th></th>
			</tr>
		</thead>
		<tbody id="table6" name="table6">
			<cfif GET_PRODUCTION_OPERATIONS.recordcount>
                <input type="hidden" name="STOCK_ID" id="STOCK_ID" value="<cfoutput>#attributes.STOCK_ID#</cfoutput>">
                <input type="hidden" name="upd_id" id="upd_id" value="<cfoutput>#attributes.upd#</cfoutput>">
                <input type="hidden" name="operation_count" id="operation_count" value="<cfoutput>#GET_PRODUCTION_OPERATIONS.RECORDCOUNT#</cfoutput>">
                <cfoutput query="GET_PRODUCTION_OPERATIONS">
                    <cfquery name="GET_STATIONS___" dbtype="query">
                        SELECT * FROM GET_STATIONS WHERE OPERATION_TYPE_ID = #operation_type_id#
                    </cfquery>
                    <input type="hidden" name="operation_id_#currentrow#" id="operation_id_#currentrow#" value="#p_operation_id#">
                    <tr>
                        <td width="25">#currentrow#</td>
                        <td nowrap>#OPERATION_TYPE#</td>
                        <td nowrap>
                            <input type="hidden" name="employee_id_#CURRENTROW#" id="employee_id_#CURRENTROW#" value="#session.ep.userid#">
                            <input type="text" name="employee_name_#CURRENTROW#" id="employee_name_#CURRENTROW#" value="#get_emp_info(session.ep.userid,0,0)#" class="text">
                            <a href="javascript://" onClick="pencere_ac_employee(#CURRENTROW#);"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" title="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>
                        </td>
                        <td class="moneybox">#TLformat(AMOUNT)#</td>
                        <td>
                            <select name="station_id_#CURRENTROW#" id="Station_id_#CURRENTROW#" onChange="calc_time(#CURRENTROW#,1);">
                                <cfloop query="GET_STATIONS___">
                                    <option value="#STATION_ID_#;#P_TIME#"<cfif MAIN_STOCK_ID eq 0>style="background:CCCCCC"</cfif><cfif STATION_ID_ eq GET_PRODUCTION_OPERATIONS.STATION_ID>selected</cfif>>#STATION_NAME#</option>
                                </cfloop>
                            </select>
                        </td>
                        <cfif (AMOUNT-RESULT_AMOUNT) gt 0>
                            <cfset row_amount = AMOUNT-RESULT_AMOUNT>
                        <cfelse>
                            <cfset row_amount = 0>
                        </cfif>
                        <td><input type="text" name="realized_amount_#CURRENTROW#" id="Realized_amount_#CURRENTROW#" class="moneybox" value="#TlFormat(row_amount)#" onKeyup="return(FormatCurrency(this,event,4));" onBlur="calc_time(#CURRENTROW#,1);"></td>
                        <td><input type="text" name="fire_#CURRENTROW#" id="Fire_#CURRENTROW#" class="moneybox" value="#TlFormat(0)#" onKeyup="isNumber(this,1);return(FormatCurrency(this,event,4));"></td>
                        <td><input type="text" name="realized_duration_#CURRENTROW#" id="Realized_duration_#CURRENTROW#" value="#TlFormat(O_MINUTE*row_amount)#" class="moneybox" onKeyup="isNumber(this,1);return(FormatCurrency(this,event,4));"></td>
                        <td><input type="text" name="duration_time_#CURRENTROW#" id="Duration_time_#CURRENTROW#" class="moneybox" onKeyup="isNumber(this,1);return(FormatCurrency(this,event,4));"></td>
                        <td><input type="checkbox" name="is_record_#CURRENTROW#" id="is_record_#CURRENTROW#" value="1"></td>
                    </tr>
                </cfoutput>
             </tbody>
             <tfoot>
                <tr class="color-list" height="25px;">
                    <td colspan="10" style="text-align:right;"><div style="position:absolute;margin-left:-250px;" id="userSuccesMessage"></div><button type="button" class=" ui-wrk-btn ui-wrk-btn-success" name="AddOperationR" id="AddOperationR"  onClick="controlOperation(0);"><cf_get_lang dictionary_id='57461.Kaydet'></button></td>
                </tr>
             </tfoot>
		</cfif>
   </cf_grid_list>
   </form>
</div>
</cfif> 
<script type="text/javascript">
	function deleteOperationRow(id){
		document.getElementById('result_'+id).style.display='none';
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.emptypopup_addOperationResult&is_delete='+id+'','deleteMessage','Siliniyor!','Silindi!');
	}	
	function pencere_ac_employee1(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=UpdOperationResult.employee_id_' + no +'&field_name=UpdOperationResult.employee_name_' + no +'&select_list=1,9','list');
	}
	function pencere_ac_employee(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=AddOperationResult.employee_id_' + no +'&field_name=AddOperationResult.employee_name_' + no +'&select_list=1,9','list');
	}
	function calc_time(row_count,type)
	{
		/*if(type==1){
				var formName = 'form[name="AddOperationResult"]';	
				var minute_value 	=   list_getat ( $( formName + ' #Station_id_' + row_count ).val(),2,';' ); 		
		}else{
				var formName = 'form[name="UpdOperationResult"]';
				var minute_value 	=   list_getat ( $( formName + ' #station_id_' + row_count ).val(),2,';' );		
		}//if

		var amount_value 	=	$( formName + ' #realized_amount_' + row_count ).val();
		var duration_value  =   $( formName + ' #realized_duration_' + row_count );
		
		if(amount_value == "") amount_value = 0;
		amount_value = filterNum(amount_value);
		duration_value.val( commaSplit( parseFloat( amount_value * minute_value) ) );
		*/
		
		if(type==1)
		{
			amount_value = document.getElementById('Realized_amount_'+row_count).value;
			minute_value = list_getat(document.getElementById('Station_id_'+row_count).value,2,';');
			duration_value = document.getElementById('Realized_duration_'+row_count);
		}
		else
		{
			amount_value = document.getElementById('realized_amount_'+row_count).value;
			minute_value = list_getat(document.getElementById('station_id_'+row_count).value,2,';');
			duration_value = document.getElementById('realized_duration_'+row_count);
		}
		if(amount_value == "") amount_value = 0;
		amount_value = filterNum(amount_value);
		duration_value.value = commaSplit(parseFloat(amount_value * minute_value));

	}// function 
	function controlOperation(type)
	{
		if(type == 0)
		{
			var row_count_operation = <cfoutput>'#GET_PRODUCTION_OPERATIONS.recordcount#'</cfoutput>;
			for (var k=1;k<=row_count_operation;k++)
			{
				if(document.getElementById('is_record_'+k).checked == true)
					if(document.getElementById('Station_id_'+k).value == "")
					{
						alert("<cf_get_lang dictionary_id='58837.Lütfen İstasyon Seçiniz'> ! <cf_get_lang dictionary_id='58508.Satır'>: "+ k);
						return false;
					}
			}
			for (var k=1;k<=row_count_operation;k++)
			{
				document.getElementById('Realized_amount_'+k).value = filterNum(document.getElementById('Realized_amount_'+k).value,6);
				document.getElementById('Fire_'+k).value = filterNum(document.getElementById('Fire_'+k).value,6);
				document.getElementById('Realized_duration_'+k).value = filterNum(document.getElementById('Realized_duration_'+k).value,6);
				document.getElementById('Duration_time_'+k).value = filterNum(document.getElementById('Duration_time_'+k).value,6);
			}
		}
		else
		{
			var row_count_operation = <cfoutput>'#GET_PRODUCTION_OPERATION_RESULT.recordcount#'</cfoutput>;
			for (var k=1;k<=row_count_operation;k++)
			{
				if(document.getElementById('station_id_'+k).value == "")
				{
					alert("<cf_get_lang dictionary_id='58837.Lütfen İstasyon Seçiniz'> ! <cf_get_lang dictionary_id='58508.Satır'>: "+ k);
					return false;
				}
			}
			for (var k=1;k<=row_count_operation;k++)
			{
				document.getElementById('realized_amount_'+k).value = filterNum(document.getElementById('realized_amount_'+k).value,6);
				document.getElementById('fire_'+k).value = filterNum(document.getElementById('fire_'+k).value,6);
				document.getElementById('realized_duration_'+k).value = filterNum(document.getElementById('realized_duration_'+k).value,6);
				document.getElementById('duration_time_'+k).value = filterNum(document.getElementById('duration_time_'+k).value,6);
			}
		}
		if(type == 0)
			{
				document.getElementById('AddOperationR').disabled=true;
				AjaxFormSubmit(AddOperationResult,'userSuccesMessage',1,'','','','',1);
			}
		else
			{
				document.getElementById('UpdOperationR').disabled=true;
				AjaxFormSubmit(UpdOperationResult,'userSuccesMessage2',1,'','','','',1);
			}
	}
</script>
<script type="text/javascript">
	function addOperation(){
		document.getElementById('table5').style.display='';
		document.getElementById('table6').style.display='';
	}
</script>
