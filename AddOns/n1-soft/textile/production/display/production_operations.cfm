<cfsetting showdebugoutput="no">
<cfquery name="GET_PRODUCTION_OPERATIONS_RESULT_TOTAL" datasource="#DSN3#">
	SELECT
		ISNULL(SUM(REAL_AMOUNT),0) REAL_AMOUNT,
		ISNULL(SUM(LOSS_AMOUNT),0) LOSS_AMOUNT,
		ISNULL(SUM(REAL_TIME),0) REAL_TIME,
		ISNULL(SUM(WAIT_TIME),0) WAIT_TIME,
		POR.OPERATION_ID
		
	FROM
		PRODUCTION_OPERATION_RESULT_MAIN POR,
		PRODUCTION_ORDERS PO
	WHERE
		<!---POR.P_ORDER_ID=PO.P_ORDER_ID AND--->
		PO.PARTY_ID=POR.PARTY_ID AND
		PO.PARTY_ID = #attributes.party_id#
	GROUP BY
		POR.OPERATION_ID
</cfquery>
<cfset opAdmin=0>

<cfquery name="emirden_operasyon_getir" datasource="#dsn3#">
		SELECT OPERATION_TYPE_ID FROM PRODUCTION_ORDERS_MAIN
		WHERE 
			  PARTY_ID=#attributes.party_id# 
</cfquery>

<cfif not len(emirden_operasyon_getir.OPERATION_TYPE_ID)>
			<cfquery name="siparistenOperasyonGetir" datasource="#dsn3#">
				SELECT OPERATION_ID FROM KRD_OPERASYON_SECIM 
				WHERE 
				<cfif isdefined("attributes.order_idd") and len(attributes.order_idd)>
					ORDER_ID=#attributes.order_idd# 
				<cfelse>
					1=2
				</cfif>
				<!--- AND STOCK_ID IN (#attributes.rbproductid#) --->
				AND STOCK_ID IN (#attributes.stock_id#) 
				<cfif isdefined("attributes.row_id") and len(attributes.row_id)>
					AND ROW_ID='#attributes.row_id#'
				<cfelse>
					and 1=2
				</cfif>
				and ISNULL(OPERATION_ID,0)>0
			</cfquery>
			<cfif siparistenOperasyonGetir.recordcount eq 0>
				<cfquery name="anamamaulOperasyonGetir" datasource="#dsn3#">
					SELECT OPERATION_ID FROM KRD_OPERASYON_SECIM 
					WHERE 
						<cfif isdefined("attributes.order_idd") and len(attributes.order_idd)>
							ORDER_ID=#attributes.order_idd# 
						<cfelse>
							1=2
						</cfif>
						AND STOCK_ID IN (SELECT STOCK_ID FROM STOCKS WHERE STOCK_ID IN (select STOCK_ID FROM PRODUCT_TREE WHERE RELATED_ID=#attributes.stock_id#)) 
						<cfif isdefined("attributes.row_id") and len(attributes.row_id)>
							AND ROW_ID='#attributes.row_id#'
						<cfelse>
							and 1=2
						</cfif>
				</cfquery>
				<cfset opAdmin=anamamaulOperasyonGetir.OPERATION_ID>
			<cfelse>
				<cfset opAdmin=siparistenOperasyonGetir.OPERATION_ID>
			</cfif>
<cfelse>
		<cfset opAdmin=emirden_operasyon_getir.OPERATION_TYPE_ID>
</cfif>


<cfquery name="GET_PRODUCTION_OPERATIONS" datasource="#DSN3#">
SELECT
	OPERATION_TYPE_ID,
	OPERATION_TYPE,
	 O_MINUTE, 
	 SUM(AMOUNT) AMOUNT,
	 STATION_ID,
	 STATION_NAME,
	P_MAIN_OPERATION_ID  P_OPERATION_ID,
	 SUM(RESULT_AMOUNT) RESULT_AMOUNT
	FROM
	(
	SELECT
    	PO.OPERATION_TYPE_ID,
    	(SELECT OPERATION_TYPE FROM OPERATION_TYPES WHERE OPERATION_TYPES.OPERATION_TYPE_ID=PO.OPERATION_TYPE_ID) AS OPERATION_TYPE,
    	ISNULL(O_MINUTE,0) AS O_MINUTE,
        (SELECT STATION_NAME FROM WORKSTATIONS WS WHERE WS.STATION_ID = PO.STATION_ID) AS STATION_NAME,
	      PO.AMOUNT,
		PO.P_MAIN_OPERATION_ID,
		PO.STATION_ID,
		ISNULL((SELECT SUM(POR.REAL_AMOUNT) FROM PRODUCTION_OPERATION_RESULT_MAIN POR WHERE POR.OPERATION_ID = PO.P_MAIN_OPERATION_ID AND POR.PARTY_ID = PO.PARTY_ID),0) RESULT_AMOUNT
	FROM
		PRODUCTION_OPERATION_MAIN PO
	WHERE
		PO.PARTY_ID=#attributes.party_id#
		AND PO.OPERATION_TYPE_ID IN (<cfif len(opAdmin)>#opAdmin#<cfelse>0</cfif>) 

	)
	AS RAPOR
	GROUP BY
		OPERATION_TYPE_ID,
		OPERATION_TYPE,
		 O_MINUTE,
P_MAIN_OPERATION_ID,
		 STATION_ID,
		 STATION_NAME

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
            AND WP.MAIN_STOCK_ID IS NULL
	UNION ALL
        SELECT
        	WP.MAIN_STOCK_ID,
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
            AND WP.MAIN_STOCK_ID = #attributes.STOCK_ID#
    </cfquery>
<cfelse>
	<cfset GET_STATIONS.recordcount = 0>
</cfif>
<cfquery name="GET_PRODUCTION_OPERATION_RESULT" datasource="#DSN3#">
	
	
	SELECT
	DISTINCT
		PO.OPERATION_TYPE_ID,
		(SELECT OPERATION_TYPE FROM OPERATION_TYPES WHERE OPERATION_TYPES.OPERATION_TYPE_ID=PO.OPERATION_TYPE_ID) AS OPERATION_TYPE,
		ISNULL(POM.O_MINUTE,0) AS O_MINUTE,
		POR.*,
		PO.AMOUNT
	FROM
		PRODUCTION_OPERATION_RESULT_MAIN POR, 
		PRODUCTION_OPERATION_MAIN POM,
		PRODUCTION_OPERATION PO,
		PRODUCTION_ORDERS
	WHERE
		POM.P_MAIN_OPERATION_ID = POR.OPERATION_ID AND
		PO.P_ORDER_ID =PRODUCTION_ORDERS.P_ORDER_ID AND
		PRODUCTION_ORDERS.PARTY_ID=POR.PARTY_ID
		AND PRODUCTION_ORDERS.PARTY_ID=#attributes.party_id#
</cfquery>

<cfoutput query="GET_PRODUCTION_OPERATIONS_RESULT_TOTAL">
	<cfset "real_amount_#operation_id#" = GET_PRODUCTION_OPERATIONS_RESULT_TOTAL.REAL_AMOUNT>
	<cfset "loss_amount_#operation_id#" = GET_PRODUCTION_OPERATIONS_RESULT_TOTAL.LOSS_AMOUNT>
	<cfset "real_time_#operation_id#" = GET_PRODUCTION_OPERATIONS_RESULT_TOTAL.REAL_TIME>
	<cfset "wait_time_#operation_id#" = GET_PRODUCTION_OPERATIONS_RESULT_TOTAL.WAIT_TIME>
</cfoutput>
<!---/*Operasyonlar*/--->
<cf_seperator title="Operasyonlar" id="operasyonlar_" is_closed="1">
<div id="operasyonlar_" style="display:none;">
	<cf_form_list>
		<thead>
			<tr>
				<th width="40"><cf_get_lang_main no='75.No'></th>
				<th width="130" nowrap><cf_get_lang_main no='1622.Operasyon'></th>
				<th width="110"><cf_get_lang no='185.Üretim Miktarı'></th>
				<th width="130"><cf_get_lang_main no='1422.İstasyon'></th>
				<th><cf_get_lang no='197.Gerçekleşen Miktar'></th>
				<th><cf_get_lang_main no='1674.Fire'></th>
				<th><cf_get_lang no='199.Gerçekleşen Süre'></th>
				<th><cf_get_lang no='204.Duruş Süresi'></th>
				<th width="1%"></th>
			</tr>
		</thead>
		<tbody id="table4" name="table4">
			<cfif GET_PRODUCTION_OPERATIONS.recordcount>
				<cfoutput query="GET_PRODUCTION_OPERATIONS">
					<tr>
						<td style="width:40px;">#currentrow#</td>
						<td style="width:130px;" nowrap>#OPERATION_TYPE#</td>
						<td style="width:110px;">#AMOUNT#</td>
						<td style="width:130px;">#STATION_NAME#</td>
							<td style="text-align:right;">#TlFormat(0)#</td>
						<td style="text-align:right;">#TlFormat(0)#</td>
						<td style="text-align:right;">#TlFormat(0)#</td>
						<td style="text-align:right;">#TlFormat(0)#</td>
					<!---	<td style="text-align:right;"><cfif isdefined("real_amount_#p_operation_id#")>#TlFormat(evaluate("real_amount_#p_operation_id#"))#<cfelse>#TlFormat(0)#</cfif></td>
						<td style="text-align:right;"><cfif isdefined("loss_amount_#p_operation_id#")>#TlFormat(evaluate("loss_amount_#p_operation_id#"))#<cfelse>#TlFormat(0)#</cfif></td>
						<td style="text-align:right;"><cfif isdefined("real_time_#p_operation_id#")>#TlFormat(evaluate("real_time_#p_operation_id#"))#<cfelse>#TlFormat(0)#</cfif></td>
						<td style="text-align:right;"><cfif isdefined("wait_time_#p_operation_id#")>#TlFormat(evaluate("wait_time_#p_operation_id#"))#<cfelse>#TlFormat(0)#</cfif></td>
						--->
						<td></td>
					</tr>
				</cfoutput>
			</cfif>
		</tbody>
	</cf_form_list>
</div>
<cfif GET_PRODUCTION_OPERATIONS.recordcount>
<cf_seperator header="Sonuçlar" id="operasyonlar1_" is_closed="1">
<div id="operasyonlar1_" style="display:none;">
<cfform name="UpdOperationResult" method="post" action="#request.self#?fuseaction=prod.emptypopup_addOperationResult_tex">
    <cf_form_list>
		<thead>
			<tr>
				<th style="width:40px;"><cf_get_lang_main no='75.No'></th>
				<th style="width:130px;" nowrap><cf_get_lang_main no='1622.Operasyon'></th>
				<th style="width:130px;" nowrap><cf_get_lang no='206.Gerçekleştiren'></th>
				<th style="width:110px;"><cf_get_lang no='185.Üretim Miktarı'></th>
				<th style="width:130px;"><cf_get_lang_main no='1422.İstasyon'></th>
				<th><cf_get_lang no='197.Gerçekleşen Miktar'></th>
				<th><cf_get_lang_main no='1674.Fire'></th>
				<th><cf_get_lang no='199.Gerçekleşen Süre'></th>
				<th><cf_get_lang no='204.Duruş Süresi'></th>
				<th><div style="position:absolute;margin-left:250px;" id="deleteMessage"></div></th>
			</tr>
		</thead>
		<tbody id="table5" name="table5">
			<cfif GET_PRODUCTION_OPERATION_RESULT.recordcount>
				<cfquery name="opidbul" datasource="#dsn3#">
					SELECT OPERATION_ID FROM KRD_OPERASYON_SECIM WHERE ORDER_ID=#attributes.order_idd#
				</cfquery>				
				<input type="hidden" name="STOCK_ID" id="STOCK_ID" value="<cfoutput>#attributes.STOCK_ID#</cfoutput>">
			<!---	<input type="hidden" name="upd_id" id="upd_id" value="<cfoutput>#attributes.upd#</cfoutput>">--->
					<input type="hidden" name="party_id" id="party_id" value="<cfoutput>#attributes.party_id#</cfoutput>">
				<input type="hidden" name="is_upd" id="is_upd" value="1">
				<input type="hidden" name="operation_count" id="operation_count" value="<cfoutput>#GET_PRODUCTION_OPERATION_RESULT.RECORDCOUNT#</cfoutput>">
				<input type="hidden" name="op_id" id="op_id" value="<cfoutput>#opidbul.operation_id#</cfoutput>">
				<input type="hidden" name="order_idd" value="<cfoutput>#attributes.order_idd#</cfoutput>">
				<input type="hidden" name="fuse" value="<cfoutput>#attributes.fuse#</cfoutput>">
				<input type="hidden" name="row_id" value="<cfoutput>#attributes.row_id#</cfoutput>">
				<input type="hidden" name="rbproductid" value="<cfoutput>#attributes.rbproductid#</cfoutput>">             		
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
						<tr id="result_#MAIN_RESULT_ID#">
							<input type="hidden" name="operation_result_id_#currentrow#" id="operation_result_id_#currentrow#" value="#MAIN_RESULT_ID#">
							<td style="width:40px;">#currentrow#</td>
							<td style="width:100px;">#OPERATION_TYPE#</td>
							<td nowrap>
								<input type="hidden" name="employee_id_#CURRENTROW#" id="employee_id_#CURRENTROW#" value="#action_employee_id#">
								<input type="text" style="width:115px;" name="employee_name_#CURRENTROW#" id="employee_name_#CURRENTROW#" value="#get_emp_info(action_employee_id,0,0)#" class="text">
								<a href="javascript://" onClick="pencere_ac_employee1(#CURRENTROW#);"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" title="<cf_get_lang_main no='322.Seçiniz'>"></a>
							</td>
							<td style="width:100px;">#AMOUNT#</td>
							<td style="width:100px;">
								<select name="station_id_#CURRENTROW#" id="station_id_#CURRENTROW#" style="width:130px;" onChange="calc_time(#CURRENTROW#,2);">
									<cfloop query="GET_STATIONS___">
										<option value="#STATION_ID_#;#P_TIME#" <cfif MAIN_STOCK_ID eq 0>style="background:CCCCCC"</cfif> <cfif STATION_ID_ eq GET_PRODUCTION_OPERATION_RESULT.STATION_ID>selected</cfif>>#STATION_NAME#</option>
									</cfloop>
								</select>
							</td>
							<td><input type="text" name="realized_amount_#CURRENTROW#" id="realized_amount_#CURRENTROW#" class="moneybox" value="#TlFormat(REAL_AMOUNT)#" onKeyup="return(FormatCurrency(this,event,4));" onBlur="calc_time(#CURRENTROW#,2);" style="width:120px;"></td>
							<td><input type="text" name="fire_#CURRENTROW#" id="fire_#CURRENTROW#" class="moneybox" value="<cfif len(LOSS_AMOUNT)>#TlFormat(LOSS_AMOUNT)#<cfelse>#TlFormat(0)#</cfif>" onKeyup="return(FormatCurrency(this,event,4));" style="width:120px;"></td>
							<td><input type="text" name="realized_duration_#CURRENTROW#" id="realized_duration_#CURRENTROW#" value="#TlFormat(REAL_TIME)#" class="moneybox"  onKeyup="isNumber(this,1);return(FormatCurrency(this,event,4));" style="width:120px;"></td>
							<td><input type="text" name="duration_time_#CURRENTROW#" id="duration_time_#CURRENTROW#" value="<cfif len(WAIT_TIME)>#TlFormat(WAIT_TIME)#<cfelse>#TlFormat(0)#</cfif>" class="moneybox" onKeyup="isNumber(this,1);return(FormatCurrency(this,event,4));" style="width:120px;"></td>
							<td style="text-align:center;20px;">
								<a style="cursor:pointer;" onClick="deleteOperationRow(#MAIN_RESULT_ID#,#CURRENTROW#);"><img src="/images/delete.gif" align="absmiddle" border="0"/></a><cfif get_prod_quality.recordcount><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=prod.popup_add_quality_control_report&product_id=#get_product.product_id#&stock_id=#attributes.STOCK_ID#&process_id=#attributes.upd#&process_row_id=#operation_id#&process_cat=-1&operation_type_id=#operation_type_id#','project');"><img src="/images/control.gif" border="0" align="absmiddle" title="<cf_get_lang no='337.Kalite Kontrol'>"></a></cfif>
							</td>
						</tr>
					</cfoutput>
                 </tbody>
                 <tfoot>
					<tr>
						<td colspan="10" style="text-align:right;"><div style="position:absolute;margin-left:-250px;" id="userSuccesMessage2"></div><input type="button" name="UpdOperationR" id="UpdOperationR" value="Güncelle" onClick="controlOperation(1);"></td>
					</tr>
                 </tfoot>
				 </cfif>
	</cf_form_list>
	</cfform>
</div>
<!--- /*Operasyon Sonuç Girişi*/ --->
<cf_seperator header="Operasyon Sonuç Girişi" id="operationResultHeader" is_closed="1"><!--- id=operationResultHeader --->
<div id="operationResultHeader" style="display:none;">
<cfform name="AddOperationResult" method="post" action="#request.self#?fuseaction=prod.emptypopup_addOperationResult_tex">
   	<cf_form_list>
		<thead>
			<tr>
				<th style="width:40px;"><cf_get_lang_main no='75.No'></th>
				<th style="width:130px;" nowrap><cf_get_lang_main no='1622.Operasyon'></th>
				<th style="width:130px;" nowrap><cf_get_lang no='206.Gerçekleştiren'></th>
				<th style="width:110px;"><cf_get_lang no='185.Üretim Miktarı'></th>
				<th style="width:130px;"><cf_get_lang_main no='1422.İstasyon'></th>
				<th><cf_get_lang no='197.Gerçekleşen Miktar'></th>
				<th><cf_get_lang_main no='1674.Fire'></th>
				<th><cf_get_lang no='199.Gerçekleşen Süre'></th>
				<th><cf_get_lang no='204.Duruş Süresi'></th>
				<th></th>
			</tr>
		</thead>
		<tbody id="table6" name="table6">
			<cfif GET_PRODUCTION_OPERATIONS.recordcount>
				
					<input type="hidden" name="STOCK_ID" id="STOCK_ID" value="<cfoutput>#attributes.STOCK_ID#</cfoutput>">
					<!---<input type="hidden" name="upd_id" id="upd_id" value="<cfoutput>#attributes.upd#</cfoutput>">--->
					<input type="hidden" name="party_id" id="party_id" value="<cfoutput>#attributes.party_id#</cfoutput>">
					<input type="hidden" name="operation_count" id="operation_count" value="<cfoutput>#GET_PRODUCTION_OPERATIONS.RECORDCOUNT#</cfoutput>">
					 <input type="hidden" name="order_idd" value="<cfoutput>#attributes.order_idd#</cfoutput>">
					<input type="hidden" name="fuse" value="<cfoutput>#attributes.fuse#</cfoutput>">
					<input type="hidden" name="row_id" value="<cfoutput>#attributes.row_id#</cfoutput>">
					<input type="hidden" name="rbproductid" value="<cfoutput>#attributes.rbproductid#</cfoutput>">
					<cfset opSay=0>
					<cfoutput query="GET_PRODUCTION_OPERATIONS">
						<cfset opSay=opSay+1>					
						<cfquery name="GET_STATIONS___" dbtype="query">
							SELECT * FROM GET_STATIONS WHERE OPERATION_TYPE_ID = #operation_type_id#
						</cfquery>
			
						<input type="hidden" name="op_id" id="op_id" value="<cfoutput>#operation_type_id#</cfoutput>">
				
						<input type="hidden" name="operation_id_#currentrow#" id="operation_id_#currentrow#" value="#p_operation_id#">
								<input type="hidden" name="party_id#currentrow#" id="party_id#currentrow#" value="<cfoutput>#attributes.party_id#</cfoutput>">
						<tr>
							<td width="40">#currentrow#</td>
							<td width="130" nowrap>#OPERATION_TYPE#</td>
							<td nowrap>
								<input type="hidden" name="employee_id_#CURRENTROW#" id="employee_id_#CURRENTROW#" value="#session.ep.userid#">
								<input type="text" style="width:115px;" name="employee_name_#CURRENTROW#" id="employee_name_#CURRENTROW#" value="#get_emp_info(session.ep.userid,0,0)#" class="text">
								<a href="javascript://" onClick="pencere_ac_employee(#CURRENTROW#);"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" title="<cf_get_lang_main no='322.Seçiniz'>"></a>
							</td>
							<td width="110">#AMOUNT#</td>
							<td width="130">
								<select name="station_id_#CURRENTROW#" id="station_id_#CURRENTROW#" style="width:130px;" onChange="calc_time(#CURRENTROW#,1);">
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
							<td nowrap><input type="text" name="realized_amount_#CURRENTROW#" id="realized_amount_#CURRENTROW#" class="moneybox" value="#TlFormat(row_amount)#" onKeyup="return(FormatCurrency(this,event,4));" onBlur="calc_time(#CURRENTROW#,1);" style="width:120px;">
							<a href="javascript://"  onClick="git(1,#CURRENTROW#);"><img src="/images/plus_thin.gif" border="0" alt="Miktar Ekleme Penceresi" align="absmiddle"></a>							
							</td>
							<td><input type="text" name="fire_#CURRENTROW#" id="fire_#CURRENTROW#" class="moneybox" value="#TlFormat(0)#" onKeyup="isNumber(this,1);return(FormatCurrency(this,event,4));" style="width:120px;"></td>
							<td><input type="text" name="realized_duration_#CURRENTROW#" id="realized_duration_#CURRENTROW#" value="#TlFormat(O_MINUTE*row_amount)#" class="moneybox" onKeyup="isNumber(this,1);return(FormatCurrency(this,event,4));" style="width:120px;"></td>
							<td><input type="text" name="duration_time_#CURRENTROW#" id="duration_time_#CURRENTROW#" class="moneybox" onKeyup="isNumber(this,1);return(FormatCurrency(this,event,4));" style="width:120px;"></td>
							<td><input type="checkbox" name="is_record_#CURRENTROW#" id="is_record_#CURRENTROW#" value="1"></td>
						</tr>
						<input type="hidden" name="opSay" value="#opSay#">					
                 </tbody>
                 <tfoot>
					<tr class="color-list" height="25px;">
						<td colspan="10" style="text-align:right;"><div style="position:absolute;margin-left:-250px;" id="userSuccesMessage"></div><input type="button" name="AddOperationR" id="AddOperationR" value="<cf_get_lang_main no='49.Kaydet'>" onClick="controlOperation(0,#CURRENTROW#);"></td>
					</tr>
				 </tfoot>
			</cfoutput>
                 
				</cfif>
   </cf_form_list>
   </cfform>
</div>
</cfif> 
<script type="text/javascript">
	/* function deleteOperationRow(id,satirrow){
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
		if(type==1)
		{
			amount_value = eval("document.AddOperationResult.realized_amount_"+row_count).value;
			minute_value = list_getat(eval("document.AddOperationResult.station_id_"+row_count).value,2,';');
			duration_value = eval("document.AddOperationResult.realized_duration_"+row_count);
		}
		else
		{
			amount_value = eval("document.UpdOperationResult.realized_amount_"+row_count).value;
			minute_value = list_getat(eval("document.UpdOperationResult.station_id_"+row_count).value,2,';');
			duration_value = eval("document.UpdOperationResult.realized_duration_"+row_count);
		}
		if(amount_value == "") amount_value = 0;
		amount_value = filterNum(amount_value);
		duration_value.value = commaSplit(parseFloat(amount_value * minute_value));
	}*/
	function deleteOperationRow(id){
		document.getElementById('result_'+id).style.display='none';
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.emptypopup_addOperationResult_tex&is_delete='+id+'','deleteMessage','Siliniyor!','Silindi!');
	}	
	function pencere_ac_employee1(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=employee_id_' + no +'&field_name=employee_name_' + no +'&select_list=1,9','list');
	}
	function pencere_ac_employee(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=employee_id_' + no +'&field_name=employee_name_' + no +'&select_list=1,9','list');
	}	
	function calc_time(row_count,type)
	{
		if(type==1){
				var formName = 'form[name="AddOperationResult"]';	 		
		}else{
				var formName = 'form[name="UpdOperationResult"]';		
		}

		var amount_value 	=	$( formName + ' #realized_amount_' + row_count ).val();
		var minute_value 	=   list_getat ( $( formName + ' #station_id_' + row_count ).val(),2,';' );
		var duration_value  =   $( formName + ' #realized_duration_' + row_count );
		
		if(amount_value == "") amount_value = 0;
		amount_value = filterNum(amount_value);
		duration_value.val( commaSplit( parseFloat( amount_value * minute_value) ) );

	}
	function controlOperation(type,satirrow)
	{

		if(type == 0)
		{
			var row_count_operation = <cfoutput>'#GET_PRODUCTION_OPERATIONS.recordcount#'</cfoutput>;
			for (var k=1;k<=row_count_operation;k++)
			{
				if(eval("document.AddOperationResult.is_record_"+k).checked == true)
					if(eval("document.AddOperationResult.station_id_"+k).value == "")
					{
						alert("Lütfen İstasyon Seçiniz ! Satır: "+ k);
						return false;
					}
						
				
			}
			for (var k=1;k<=row_count_operation;k++)
			{
				eval("document.AddOperationResult.realized_amount_"+k).value = filterNum(eval("document.AddOperationResult.realized_amount_"+k).value,6);
				eval("document.AddOperationResult.fire_"+k).value = filterNum(eval("document.AddOperationResult.fire_"+k).value,6);
				eval("document.AddOperationResult.realized_duration_"+k).value = filterNum(eval("document.AddOperationResult.realized_duration_"+k).value,6);
				eval("document.AddOperationResult.duration_time_"+k).value = filterNum(eval("document.AddOperationResult.duration_time_"+k).value,6);
			}
		}
		else
		{
			var row_count_operation = <cfoutput>'#GET_PRODUCTION_OPERATION_RESULT.recordcount#'</cfoutput>;
			for (var k=1;k<=row_count_operation;k++)
			{
				if(eval("document.UpdOperationResult.station_id_"+k).value == "")
				{
					alert("Lütfen İstasyon Seçiniz ! Satır: "+ k);
					return false;
				}
			}
			for (var k=1;k<=row_count_operation;k++)
			{
				eval("document.UpdOperationResult.realized_amount_"+k).value = filterNum(eval("document.UpdOperationResult.realized_amount_"+k).value,6);
				eval("document.UpdOperationResult.fire_"+k).value = filterNum(eval("document.UpdOperationResult.fire_"+k).value,6);
				eval("document.UpdOperationResult.realized_duration_"+k).value = filterNum(eval("document.UpdOperationResult.realized_duration_"+k).value,6);
				eval("document.UpdOperationResult.duration_time_"+k).value = filterNum(eval("document.UpdOperationResult.duration_time_"+k).value,6);
			}
		}

		if(type == 0)
			{
		
				document.getElementById('AddOperationR').disabled=true;
				AjaxFormSubmit(AddOperationResult,'userSuccesMessage',1,'','','','',1);
				//document.AddOperationResult.submit();

			}
		else
			{
				document.getElementById('UpdOperationR').disabled=true;
				AjaxFormSubmit(UpdOperationResult,'userSuccesMessage2',1,'','','','',1);
				//document.UpdOperationResult.submit();
				
			}
			
		//document.getElementById('AddOperationR').disabled=true;
		/*if(type == 0)
			{
		
				AjaxFormSubmit(AddOperationResult,'userSuccesMessage',1,'','','','',1);
			}
		else
			{
				AjaxFormSubmit(UpdOperationResult,'userSuccesMessage2',1,'','','','',1);
			}*/
	}

</script>
<script type="text/javascript">
	function addOperation(){
		document.getElementById('table5').style.display='';
		document.getElementById('table6').style.display='';
	}
</script>
