<!--- Üretim Emirleri Operasyonlar Sayfası --->
<cfif not isnumeric(attributes.prod_id)>
	<cfset hata  = 10>
	<cfinclude template="../../dsp_hata.cfm">
</cfif>
<cf_xml_page_edit fuseact="production.form_add_production_operation">
<cfquery name="get_order" datasource="#dsn3#">
	SELECT 
		PO.P_ORDER_ID,
		PO.P_ORDER_NO,
		PO.STATION_ID,
		PO.FINISH_DATE,
		PO.IS_DEMONTAJ,
		S.PRODUCT_NAME,
		S.STOCK_ID,
		PO.SPECT_VAR_NAME,
		PO.QUANTITY,
		PO.SPECT_VAR_ID,
		PO.SPEC_MAIN_ID,
		PO.PO_RELATED_ID,
		ISNULL((SELECT
					SUM(POR_.AMOUNT) ORDER_AMOUNT
				FROM
					PRODUCTION_ORDER_RESULTS_ROW POR_,
					PRODUCTION_ORDER_RESULTS POO
				WHERE
					POR_.PR_ORDER_ID = POO.PR_ORDER_ID
					AND POO.P_ORDER_ID = PO.P_ORDER_ID
					AND POR_.TYPE = 1
					AND POO.IS_STOCK_FIS = 1
				),0) ROW_RESULT_AMOUNT,
		(SELECT TOP 1 MAIN_UNIT FROM PRODUCT_UNIT WHERE PRODUCT_UNIT.PRODUCT_ID = S.PRODUCT_ID) AS MAIN_UNIT,
		(SELECT TOP 1 PRODUCT_CATID FROM #dsn1_alias#.PRODUCT WHERE PRODUCT.PRODUCT_ID = S.PRODUCT_ID) PRODUCT_CATID
	FROM 
		PRODUCTION_ORDERS PO,
		STOCKS S
	WHERE 
		P_ORDER_ID = #attributes.prod_id# AND
		S.STOCK_ID = PO.STOCK_ID
</cfquery>
<cfif not get_order.RECORDCOUNT>
	<cfset hata  = 10>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfquery name="GET_ROW" datasource="#dsn3#">
		SELECT
			ORDER_NUMBER,
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID
		FROM
			PRODUCTION_ORDERS_ROW,
			ORDERS
		WHERE
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = #attributes.prod_id# AND
			PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID 
	</cfquery>
	<cfif len(get_order.station_id)>
		<cfquery name="get_w" datasource="#dsn3#">
			SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = #get_order.station_id#
		</cfquery>
		<cfquery name="get_relation_physical_asset" datasource="#dsn#">
			SELECT 
				ASSET_P.ASSETP_ID, 
				ASSET_P.ASSETP, 
				RELATION_PHYSICAL_ASSET_STATION.STATION_ID	
			FROM 
				ASSET_P, 
				RELATION_PHYSICAL_ASSET_STATION 
			WHERE 
				ASSET_P.ASSETP_ID = RELATION_PHYSICAL_ASSET_STATION.PHYSICAL_ASSET_ID AND 
				RELATION_PHYSICAL_ASSET_STATION.STATION_ID = #get_order.station_id#
		</cfquery>
	<cfelse>
		<cfset get_w.recordcount = 0>
		<cfset get_relation_physical_asset.recordcount = 0>
	</cfif>
	<cfif len(get_order.station_id)>
		<cfquery name="GET_STATION_INFO" datasource="#dsn3#">
			SELECT 
				DEPARTMENT,
				STATION_NAME,
				EXIT_DEP_ID,
				EXIT_LOC_ID,
				ENTER_DEP_ID,
				ENTER_LOC_ID,
				PRODUCTION_DEP_ID,
				PRODUCTION_LOC_ID
			FROM 
				WORKSTATIONS 
			WHERE 
				STATION_ID = #get_order.STATION_ID#
		</cfquery>
	<cfelse>
		<cfset get_station_info.recordcount = 0>
	</cfif>
	<cfif GET_STATION_INFO.recordcount and len(GET_STATION_INFO.DEPARTMENT)>
		<cfquery name="get_employees" datasource="#dsn#">
			SELECT EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME EMPLOYEE,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE DEPARTMENT_ID = #GET_STATION_INFO.DEPARTMENT# AND EMPLOYEE_ID IS NOT NULL
		</cfquery>
	<cfelse>
		<cfset get_employees.recordcount = 0>
		<cfset get_employees.EMPLOYEE = ''>
		<cfset get_employees.EMPLOYEE_ID = ''>
	</cfif>
	<cfquery name="get_production_operations" datasource="#dsn3#">
		SELECT
			PO.OPERATION_TYPE_ID,
			PO.P_OPERATION_ID,
			OT.OPERATION_TYPE
		FROM
			PRODUCTION_OPERATION PO,
			OPERATION_TYPES OT
		WHERE
			OT.OPERATION_TYPE_ID=PO.OPERATION_TYPE_ID AND
			PO.P_ORDER_ID = #attributes.prod_id#
		ORDER BY
			PO.P_OPERATION_ID DESC
	</cfquery>
	<style>
		.box_yazi_td {font-size:14px;border-color:#666666;font:bold;color:#0033FF} 
		.box_yazi_td2 {font-size:18px;border-color:#666666;font:bold}
		.box_yazi {font-size:16px;border-color:#666666;font:bold;} 
	</style>
	<table cellspacing="0" cellpadding="0" width="100%" height="100%" align="center" border="1" style="border-color:#666666;">
		<tr class="color-row">
			<td colspan="2" valign="top" style="text-align:center;">
				<cfform name="production_operation" method="post" action="#request.self#?fuseaction=production.form_add_production_operation&prod_id=#attributes.prod_id#">
					<input type="hidden" name="record_num" id="record_num" value="">
					<div align="center">
						<table border="0" align="center">
							<cfoutput query="get_order">
								<tr><td>&nbsp;</td></tr>
								<tr style="background-color:CCCCCC;">
									<td>
										<table border="0" align="center">
											<tr>
												<td class="box_yazi"><cf_get_lang dictionary_id='38046.EMİR NO'></td>
												<td class="box_yazi_td" style="width:100px;background-color:FFFFCC;">#p_order_no#</td>
												<td class="box_yazi"><cf_get_lang dictionary_id='38047.SİPARİŞ NO'></td>
												<td class="box_yazi_td" style="width:100px;background-color:FFFFCC;">#get_row.order_number#</td>
												<td class="box_yazi"><cf_get_lang dictionary_id='38048.ANA EMİR NO'></td>
												<td class="box_yazi_td" style="width:100px;background-color:FFFFCC;">
													<cfif len(get_order.PO_RELATED_ID)>
														<cfquery name="get_related" datasource="#dsn3#">
															SELECT TOP 1 P_ORDER_ID,P_ORDER_NO FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = #get_order.PO_RELATED_ID#
														</cfquery>
														#get_related.P_ORDER_NO#
													</cfif>
												</td>
												<td class="box_yazi"><cf_get_lang dictionary_id='38049.İSTASYON ADI'></td>
												<td class="box_yazi_td" style="width:100px;background-color:FFFFCC"><cfif len(get_order.station_id)>#get_w.station_name#</cfif></td>
												<td><div style="position:absolute;" id="open_order_"></div></td>
												<td class="box_yazi">DEPO :</td>
												<td class="box_yazi_td" style="width:100px;background-color:FFFFCC">
													<cfif get_station_info.recordcount and len(get_station_info.EXIT_DEP_ID)>
														<cfquery name="get_department" datasource="#dsn#">
															SELECT 
																D.DEPARTMENT_HEAD 
															FROM 
																DEPARTMENT D,
																STOCKS_LOCATION SL 
															WHERE 
																D.DEPARTMENT_ID = SL.DEPARTMENT_ID AND 
																D.DEPARTMENT_ID = #GET_STATION_INFO.EXIT_DEP_ID# AND
																SL.LOCATION_ID = #GET_STATION_INFO.EXIT_LOC_ID#
														</cfquery>
														#get_department.DEPARTMENT_HEAD#
													</cfif>
												</td>
												<td><a href="javascript://" onclick="control();"><img src="images/p.gif" border="0"></a></td>
											</tr>
										</table>
									</td>
								</tr>
							</cfoutput>
							<cfquery name="get_operations_row" datasource="#dsn3#">
								SELECT * FROM P_ORDER_OPERATIONS_ROW WHERE WRK_ROW_RELATION_ID = '#attributes.wrk_row_id#'
							</cfquery>
							<cfquery name="get_row_count" dbtype="query">
								SELECT 
									COUNT(WRK_ROW_ID),
									EMPLOYEE_ID,
									ASSET_ID,
									OPERATION_TYPE_ID,
									QUANTITY,
									WRK_ROW_ID
								FROM 
									get_operations_row 
								WHERE 
									TYPE = 1
								GROUP BY 
									EMPLOYEE_ID,
									ASSET_ID,
									OPERATION_TYPE_ID,
									QUANTITY,
									WRK_ROW_ID
								ORDER BY 
									WRK_ROW_ID
							</cfquery>
							<tr>
								<td colspan="8">
									<cfquery name="get_amount" datasource="#dsn3#">
										SELECT ISNULL(SUM(QUANTITY),0) AMOUNT FROM (SELECT QUANTITY,WRK_ROW_ID FROM P_ORDER_OPERATIONS_ROW WHERE P_ORDER_ID = #attributes.prod_id# AND WRK_ROW_ID = '#get_row_count.WRK_ROW_ID#' AND TYPE=1 GROUP BY QUANTITY,WRK_ROW_ID)T1
									</cfquery>
									<input type="hidden" name="toplam_tutar" id="toplam_tutar" value="<cfoutput>#get_amount.AMOUNT#</cfoutput>">
								</td>
							</tr>
							<tr style="text-align:center">
								<td colspan="8">
									<div align="center">
										<table align="center" border="0" id="table1" name="table1">
											<input type="hidden" name="record_num_2" id="record_num_2" value="">
											<input type="hidden" name="remaining" id="remaining" value="<cfoutput>#attributes.production_amount#</cfoutput>" />
											<cfif get_row_count.recordcount>
												<input type="hidden" name="count_" id="count_" value="<cfoutput>#get_row_count.recordcount#</cfoutput>" />
												<cfoutput query="get_row_count">
													<cfquery name="get_type" datasource="#dsn3#">
														SELECT TOP 1 TYPE,START_COUNTER,FINISH_COUNTER FROM P_ORDER_OPERATIONS_ROW WHERE P_ORDER_ID = #attributes.prod_id# AND WRK_ROW_ID = '#get_row_count.WRK_ROW_ID#' ORDER BY RECORD_DATE DESC
													</cfquery>
													<cfif isdefined("xml_is_counter") and xml_is_counter eq 1>
														<tr id="frm_row#currentrow#">
															<td style="height:100px;text-align:center;vertical-align:bottom" colspan="8"><div align="center"><strong><cf_get_lang dictionary_id='38053.Başlangıç Sayacı'>&nbsp;</strong><input type="text" name="start_counter_#currentrow#" id="start_counter_#currentrow#" value="#get_type.START_COUNTER#" onkeyup="isNumber(this);" title="<cf_get_lang dictionary_id='38053.Başlangıç Sayacı'>" style="font-size:26px;width:200px;height:40px;">&nbsp;&nbsp;&nbsp; <strong><cf_get_lang dictionary_id='38054.Bitiş Sayacı'>&nbsp;</strong><input type="text" name="finish_counter_#currentrow#" id="finish_counter_#currentrow#" value="#get_type.FINISH_COUNTER#" onkeyup="isNumber(this);" title="<cf_get_lang dictionary_id='38054.Bitiş Sayacı'>" style="font-size:26px;width:200px;height:40px;"></div></td>
														</tr>
													</cfif>
													<tr id="frm_row_2#currentrow#">
														<td style="height:60px;text-align:center;" colspan="8">
															<cfset currentrow_ = currentrow>
															<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
															<input type="hidden" name="row_count_1#currentrow#" id="row_count_1#currentrow#" value="">
															<input type="button" name="op_start#currentrow#" id="op_start#currentrow#" <cfif get_type.type eq 1 or get_type.type eq 2>disabled="disabled"</cfif>  style="font-size:18px;font:bold;width:270px;height:44px;" value="<cfif get_type.type eq 1><cf_get_lang dictionary_id='38076.OPERASYON BAŞLADI'><cfelseif get_type.type eq 0><cf_get_lang dictionary_id='38077.OPERASYONA DEVAM ET'><cfelse><cf_get_lang dictionary_id='38078.OPERASYONA BAŞLA'></cfif>" onclick="operation_start(#currentrow#,'#wrk_row_id#');">
															<input type="button" name="op_stop#currentrow#" id="op_stop#currentrow#" <cfif get_type.type eq 0 or get_type.type eq 2>disabled="disabled"</cfif> style="font-size:18px;font:bold;width:270px;height:44px;" value="<cfif get_type.type eq 0><cf_get_lang dictionary_id='38079.OPERASYON DURDU'><cfelse><cf_get_lang dictionary_id='38080.OPERASYONU DURDUR'></cfif>" onclick="operation_stop(#currentrow#,'#wrk_row_id#');">
															<input type="button" name="op_finish#currentrow#" id="op_finish#currentrow#" <cfif get_type.type eq 0 or get_type.type eq 2>disabled="disabled"</cfif> style="font-size:18px;font:bold;width:270px;height:44px;" value="<cfif get_type.type eq 2><cf_get_lang dictionary_id='38081.OPERASYON SONLANDIRILIYOR'><cfelse><cf_get_lang dictionary_id='38082.OPERASYONU SONLANDIR'></cfif>" onclick="operation_finish(#currentrow#,'#wrk_row_id#');">
															<input type="text" name="amount#currentrow#" id="amount#currentrow#" readonly="yes" value="#TLFormat(quantity)#" maxlength="10" onkeyup="return(FormatCurrency(this,event));" style="font-size:28px;width:150px;height:44px;">
														</td>
													</tr>
													<tr id="frm_row_3#currentrow#">
														<td style="width:40px;">&nbsp;</td>
														<td class="box_yazi"><strong><cf_get_lang dictionary_id='57576.Çalışan'></strong></td>
														<td style="width:210px;">
															<select name="employee#currentrow#" id="employee#currentrow#" disabled="disabled" style="width:200px;height:25px;font-size:18px">
																<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
																<cfif get_employees.recordcount>
																	<cfloop query="get_employees">
																		<option value="#EMPLOYEE_ID#" <cfif EMPLOYEE_ID eq get_row_count.EMPLOYEE_ID>selected</cfif>>#EMPLOYEE#</option>
																	</cfloop>
																</cfif>
															</select>
														</td>
														<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
															<td class="box_yazi"><strong><cf_get_lang dictionary_id='58833.Fiziki Varlık'></strong></td>
															<td style="width:210px;">
																<select name="asset#currentrow#" id="asset#currentrow#" disabled="disabled" style="width:200px;height:25px;font-size:18px">
																	<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
																	<cfif get_relation_physical_asset.recordcount>
																		<cfloop query="get_relation_physical_asset">
																			<option value="#ASSETP_ID#" <cfif assetp_id eq get_row_count.asset_id>selected</cfif>>#assetp#</option>
																		</cfloop>
																	</cfif>
																</select>
															</td>
														</cfif>
														<td class="box_yazi"><strong><cf_get_lang dictionary_id='38056.Operasyonlar'></strong></td>
														<td style="width:230px;">
															<select name="operation#currentrow#" id="operation#currentrow#" disabled="disabled" style="width:200px;height:25px;font-size:18px">
																<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
																<cfif get_production_operations.recordcount>
																	<cfloop query="get_production_operations">
																		<option value="#OPERATION_TYPE_ID#-#P_OPERATION_ID#" <cfif OPERATION_TYPE_ID eq get_row_count.OPERATION_TYPE_ID>selected</cfif>>#OPERATION_TYPE#</option>
																	</cfloop>
																</cfif>
															</select>
														</td>
													</tr>
													<cfif isdefined("xml_is_row_product") and xml_is_row_product eq 1>
														<cfquery name="get_row_product" datasource="#dsn3#">
															SELECT PRODUCT_ID,STOCK_ID,PRODUCT_NAME,AMOUNT FROM P_ORDER_OPERATIONS_ROW_PRODUCT WHERE P_ORDER_ID = #attributes.prod_id# AND WRK_ROW_ID = '#get_row_count.WRK_ROW_ID#' ORDER BY RECORD_DATE DESC
														</cfquery>
														<tr id="frm_row_4#currentrow#">
															<td colspan="8">
																<table align="center">
																<cfloop query="get_row_product">
																	<tr>
																		<td>
																			<div align="center">
																				<input type="hidden" name="row_kontrol_2#currentrow_#_#currentrow#" id="row_kontrol_2#currentrow_#_#currentrow#" value="">
																				<input type="text" name="amount#currentrow_#_#currentrow#" id="amount#currentrow_#_#currentrow#" disabled="disabled" value="#get_row_product.amount#" maxlength="10" onkeyup="return(FormatCurrency(this,event));" title="<cf_get_lang dictionary_id='57635.Miktar'>" style="font-size:22px;width:150px;height:30px;">
																				<input type="hidden" name="product_id#currentrow_#_#currentrow#" id="product_id#currentrow_#_#currentrow#" value="#get_row_product.product_id#">
																				<input  type="hidden" name="stock_id#currentrow_#_#currentrow#" id="stock_id#currentrow_#_#currentrow#" value="#get_row_product.stock_id#">
																				<input type="text" name="product_name#currentrow_#_#currentrow#" id="product_name#currentrow_#_#currentrow#" disabled="disabled" value="#get_row_product.product_name#" title="<cf_get_lang dictionary_id='57657.Ürün'>" style="font-size:22px;width:450px;height:30px;">
																			</div>
																		</td>
																	</tr>
																</cfloop>
																</table>
															</td>
														</tr>
													</cfif>
												</cfoutput>
											</cfif>
										</table>
									</div>
								</td>
							</tr>
						</table>
					</div>
				</cfform>
			</td>
		</tr>
	</table>	
	<script type="text/javascript">
		var row_count = <cfoutput>#get_row_count.recordcount#</cfoutput>;
		document.getElementById('record_num').value = row_count;
		function sil(sy)
		{
			var my_element=eval("production_operation.row_kontrol"+sy);
			my_element.value=0;
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
			var my_element_2=eval("frm_row_2"+sy);
			my_element_2.style.display="none";
		   	var my_element_3=eval("frm_row_3"+sy);
			my_element_3.style.display="none";
			for(i=1;i<=document.getElementById('row_count_1'+sy).value; ++i)
			{
				var my_element_4=eval("production_operation.row_kontrol_2"+sy+'_'+i);
				my_element_4.value=0;
				var my_element_4=eval("frm_row_4"+sy+'_'+i);
				my_element_4.style.display="none";
			}
			var wrk_row_id_ = "";
			var p_order_id_ = '<cfoutput>#attributes.prod_id#</cfoutput>'; //Üretim Emri ID
			var wrk_row_relation_id_ = '<cfoutput>#attributes.wrk_row_id#</cfoutput>'; // uretim emri satiri wrk_row_id
			var userid_ = '<cfoutput>#session.ep.userid#</cfoutput>';
			var relation_id_ = list_getat(wrk_row_relation_id_,1,'_');
			wrk_row_id_ = relation_id_+'_'+sy+'_'+p_order_id_+'_'+userid_;
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=production.emptypopup_ajax_add_p_order_operation_row&wrk_row_id='+wrk_row_id_+'&is_del=1');	
			//windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=production.emptypopup_ajax_add_p_order_operation_row&wrk_row_id='+wrk_row_id_+'&is_del=1','list');	
			toplam_kontrol();
		}

		function add_row()
		{
			row_count_2 = 0;
			row_count++;
			var NewRow;
			var NewCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			newRow.setAttribute("align","center" + row_count); 
			document.getElementById('record_num').value=row_count;
			<cfif isdefined("xml_is_counter") and xml_is_counter eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.colSpan = 8;
				newCell.height = "100";
				newCell.style.verticalAlign= 'bottom';
				newCell.align = "center";
				newCell.innerHTML = '<div align="center"><strong><cf_get_lang dictionary_id='38053.Başlangıç Sayacı'>&nbsp;</strong><input type="text" name="start_counter_'+row_count+'" id="start_counter_'+row_count+'" value="" onkeyup="isNumber(this);" title="<cf_get_lang dictionary_id='38053.Başlangıç Sayacı'>" style="font-size:26px;width:200px;height:40px;">&nbsp;&nbsp;&nbsp; <strong><cf_get_lang dictionary_id='38054.Bitiş Sayacı'>&nbsp;</strong><input type="text" name="finish_counter_'+row_count+'" id="finish_counter_'+row_count+'" value="" onkeyup="isNumber(this);" title="<cf_get_lang dictionary_id='38054.Bitiş Sayacı'>" style="font-size:26px;width:200px;height:40px;"></div>';
			</cfif>
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row_2" + row_count);
			newRow.setAttribute("id","frm_row_2" + row_count);
			newRow.setAttribute("align","center" + row_count); 
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.colSpan = 8;
			newCell.height = "60";
			newCell.align = "center";
			newCell.innerHTML = '<div align="center"><input type="hidden" name="row_count_1'+row_count+'" id="row_count_1'+row_count+'" value=""><input type="button" name="op_start'+row_count+'" id="op_start'+row_count+'" style="font-size:18px;font:bold;width:270px;height:44px;" value="<cf_get_lang dictionary_id='38078.OPERASYONA BAŞLA'>" onclick="operation_start('+ row_count +');"> <input type="button" name="op_stop'+row_count+'" id="op_stop'+row_count+'" disabled="disabled" style="font-size:18px;font:bold;width:270px;height:44px;"value="<cf_get_lang dictionary_id='38080.OPERASYONU DURDUR'>" onclick="operation_stop(' + row_count + ');"> <input type="button" name="op_finish'+row_count+'" id="op_finish'+row_count+'" disabled="disabled" style="font-size:18px;font:bold;width:270px;height:44px;" value="<cf_get_lang dictionary_id='38082.OPERASYONU SONLANDIR'>" onclick="operation_finish(' + row_count + ');"><td style="width:80px;"> <input type="text" name="amount'+row_count+'" id="amount'+row_count+'" value="1" maxlength="10" onkeyup="return(FormatCurrency(this,event));" style="font-size:28px;width:150px;height:40px;"></td></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="row_kontrol'+row_count+'" id="row_kontrol'+row_count+'" value="1"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row_3" + row_count);
			newRow.setAttribute("id","frm_row_3" + row_count);
			newRow.setAttribute("align","center" + row_count);
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.width = "40";
			newCell.innerHTML = '<td>&nbsp;</td>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.style.fontSize = "16px";
			newCell.style.fontWeight = "bold";
			newCell.align = "center";
			newCell.innerHTML = '<td style="text-align:right;"><cf_get_lang dictionary_id="57576.Çalışan"></td>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
				b = '<select name="employee' + row_count  +'" id="employee' + row_count  +'" style="width:200px;height:25px;font-size:18px"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>';
				<cfif get_employees.recordcount>
					<cfoutput query="get_employees">
						if('#employee_id#' == #session.ep.userid#)
							b += '<option value="#employee_id#" selected>#employee#</option>';
						else
							b += '<option value="#employee_id#">#employee#</option>';
					</cfoutput>
				</cfif>
				newCell.innerHTML =b+ '</select>';
			<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.style.fontSize = "16px";
				newCell.style.fontWeight = "bold";
				newCell.innerHTML = '<td><cf_get_lang dictionary_id="58833.Fiziki Varlık"></td>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("nowrap","nowrap");
					c = '<select name="asset' + row_count +'" id="asset' + row_count  +'" style="width:200px;height:25px;font-size:18px">';
					<cfif get_relation_physical_asset.recordcount>
						<cfoutput query="get_relation_physical_asset">
							c += '<option value="#ASSETP_ID#">#ASSETP#</option>';
						</cfoutput>
					</cfif>
					newCell.innerHTML =c+ '</select>';
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.style.fontSize = "16px";
			newCell.style.fontWeight = "bold";
			newCell.innerHTML = '<td><cf_get_lang dictionary_id="38056.Operasyonlar"></td>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
				d = '<select name="operation' + row_count +'" id="operation' + row_count  +'" style="width:200px;height:25px;font-size:18px"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>';
				<cfif get_production_operations.recordcount>
					<cfoutput query="get_production_operations">
						d += '<option value="#OPERATION_TYPE_ID#-#P_OPERATION_ID#">#OPERATION_TYPE#</option>';
					</cfoutput>
				</cfif>
				newCell.innerHTML =d+ '</select><cfif isdefined("xml_is_row_product") and xml_is_row_product eq 1> <a href="javascript://" style="vertical-align:bottom" onclick="add_product_row('+ row_count +');"><img src="images/p.gif" border="0"></a></cfif>';
			toplam_kontrol();
		}
		var row_count_2=0;
		document.getElementById('record_num_2').value = row_count_2;
		function add_product_row(no)
		{
			if (document.getElementById('record_num').value > no)
			{
				alert("<cf_get_lang dictionary_id='38083.Farklı Operasyon Bulunduğu için Ürün Ekleyemezsiniz'>!");
				return false;
			}
			row_count_2++;
			var NewRow;
			var NewCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row_4" + no + "_" + row_count_2);
			newRow.setAttribute("id","frm_row_4" + no + "_" +  row_count_2);
			newRow.setAttribute("align","center"  + no + "_" +  row_count_2);
			document.getElementById('record_num_2').value=row_count_2;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.height = "55";
			newCell.colSpan = 8;//alert(no);alert(row_count_2);
			document.getElementById('row_count_1'+no).value = row_count_2;
			newCell.innerHTML = '<div align ="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <input type="hidden" name="row_kontrol_2'+no+'_' +row_count_2+'" id="row_kontrol_2'+no+'_' +row_count_2+'" value="1"><input type="text" name="amount_product'+no+'_' +row_count_2+'" id="amount_product'+no+'_' +row_count_2+'" value="1" maxlength="10" onkeyup="return(FormatCurrency(this,event));" title="<cf_get_lang dictionary_id='57635.Miktar'>" style="font-size:22px;width:100px;height:30px;">&nbsp;<input type="hidden" name="product_id'+no+'_' +row_count_2+'" id="product_id'+no+'_' +row_count_2+'" value=""><input  type="hidden" name="stock_id'+no+'_' +row_count_2+'" id="stock_id'+no+'_' +row_count_2+'" value=""><input type="text" name="product_name'+no+'_' +row_count_2+'" value="" id="product_name'+no+'_' +row_count_2+'" title="<cf_get_lang dictionary_id='57657.Ürün'>" style="font-size:22px;width:450px;height:30px;" style="width:145px;" value=""><a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid='+document.getElementById('product_id"+row_count_2+"').value+'&sid='+document.getElementById('stock_id"+row_count_2+"').value+'','list');"+'"><img src="/images/plus_thin_p.gif" border="0" align="absbottom" alt="<cf_get_lang dictionary_id="32848.Ürün Detay">" style="display:none;" id="product_info'+no+'_' +row_count_2+'"></a><a href="javascript://" onClick="pencere_ac_product('+no+','+ row_count_2 +');"> <img src="/images/plus_thin_big.gif" border="0" align="absbottom"></a><a style="cursor:pointer" onclick="sil_product('+no+','+ row_count_2 +');"><img  src="images/delete_list.gif" border="0"></a></div>';
		}
		function pencere_ac_product(no,row_)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=all.product_id'+no+'_'+row_+'&field_id=all.stock_id'+no+'_'+row_+'&field_name=all.product_name'+no+'_'+row_,'list');
		}
		
		function toplam_kontrol()
		{	
			var row_no=0;
			row_no=document.getElementById('record_num').value;
			total_amount(row_no);
			return true;
		}
		function total_amount(no)
		{	
			var toplam_1=0;
			for(var i=1; i <= no; i++)
			{
				if(eval("document.getElementById('amount'+i)").value != '' && eval("document.production_operation.row_kontrol"+i).value == 1)
				{
					var ara_toplam=filterNum(eval("document.getElementById('amount'+i)").value);
					if(ara_toplam!= null && ara_toplam.value != "")
					{
						toplam_1 = parseFloat(toplam_1 + parseFloat(ara_toplam));
						document.production_operation.toplam_tutar.value=toplam_1;
					}
				}
			}
		}
		function control()
		{
			for(i=1;i<=document.getElementById('record_num').value;++i)
			{
			var production_count = 0;
				if(document.getElementById('frm_row_2'+i).style.display =='')
					var production_count = parseFloat(filterNum(eval("document.getElementById('amount'+i)").value,2));
			<cfif isdefined("xml_is_amount_kontrol") and xml_is_amount_kontrol eq 1>
				if(document.getElementById('remaining').value < production_count)
				{
					alert("<cf_get_lang dictionary_id='41452.Satırlardaki Miktar Üretim Satırındaki Miktardan Fazla'>!");
					return false;
				}
			</cfif>
			} 

			add_row();
		}

		function sil_product(no,row_)
		{
			var my_element=eval('production_operation.row_kontrol_2'+no+'_'+row_);
			my_element.value=0;
			var my_element=eval('frm_row_4'+no+'_'+row_);
			my_element.style.display="none";
		}
		
		function operation_start(no,wrkrow)
		{//üretime başla denilmiş ise
			<cfif isdefined("xml_is_amount_kontrol") and xml_is_amount_kontrol eq 1>
				flag=0;
				const amount_values = [];
				$('[id^="operation"]').each(function(index){
					operation_id=$(this).val().replace(/-/g,"");
					deger=$("#amount"+(index+1)).val();
					if(amount_values[operation_id]!=undefined)
					amount_values[operation_id] = parseFloat(deger) + parseFloat(amount_values[operation_id]);
					else
					amount_values[operation_id] = parseFloat(deger);
				});

				amount_values.forEach(function(entry) {
				if(document.getElementById('remaining').value < entry)
				{
					flag=1;
				}
				});
				if(flag == 1)
				{
					alert("<cf_get_lang dictionary_id='41452.Satırlardaki Miktar Üretim Satırındaki Miktardan Fazla'>!");
					return false;
				}
			</cfif>

			var record_num_ = document.getElementById('row_count_1'+no).value;
			var wrk_row_relation_id_ = '<cfoutput>#attributes.wrk_row_id#</cfoutput>'; // uretim emri satiri wrk_row_id
			var p_order_id_ = '<cfoutput>#attributes.prod_id#</cfoutput>'; //Üretim Emri ID
			if (wrkrow != undefined && wrkrow != '')
			{
				wrk_row_id_ = wrkrow;
			}
			else
			{
				var wrk_row_id_ = "";
				var userid_ = '<cfoutput>#session.ep.userid#</cfoutput>';
				var relation_id_ = list_getat(wrk_row_relation_id_,1,'_');
				wrk_row_id_ = relation_id_+'_'+no+'_'+p_order_id_+'_'+userid_;
			}
			if (eval("document.getElementById('employee'+no)") == undefined || eval("document.getElementById('employee'+no)").value == '')
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57576.Çalışan'>");
				return false;
			}
			<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
				if (eval("document.getElementById('asset'+no)") == undefined || eval("document.getElementById('asset'+no)").value == '')
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58833.Fiziki Varlık'>");
					return false;
				}
			</cfif>
			if (eval("document.getElementById('operation'+no)") == undefined || eval("document.getElementById('operation'+no)").value == '')
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='29419.Operasyon'>");
				return false;
			}
			if (eval("document.getElementById('amount'+no)") == undefined || eval("document.getElementById('amount'+no)").value == '')
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57635.Miktar'>");
				return false;
			}
			document.getElementById('op_finish'+no+'').disabled=false;//butona 2 kere tıklanmasın diye pasif yapıyoruz.!
			document.getElementById('op_stop'+no+'').disabled=false;
			var employee_ = eval("document.getElementById('employee'+no)").value;
			<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
				var asset_id_ = eval("document.getElementById('asset'+no)").value;
			<cfelse>
				var asset_id_ = '';
			</cfif>
			var operation_ = eval("document.getElementById('operation'+no)").value;
			var amount_value = eval("document.getElementById('amount'+no)").value;
			var amount_ = filterNum(amount_value,'#session.ep.our_company_info.rate_round_num#');
			<cfif isdefined("xml_is_counter") and xml_is_counter eq 1>
				var start_counter_ = document.getElementById('start_counter_'+no).value;
				var finish_counter_ = document.getElementById('finish_counter_'+no).value;
			<cfelse>
				var start_counter_ = '';
				var finish_counter_ = '';
			</cfif>
			var url='';
			<cfif isdefined("xml_is_row_product") and xml_is_row_product eq 1>
				for(i=1;i<=row_count_2;++i)
				{
					if(document.getElementById('product_id'+no+'_'+i).value !='' && document.getElementById('stock_id'+no+'_'+i).value !='' && document.getElementById('amount_product'+no+'_'+i).value !='')
					{
						product_id_ = document.getElementById('product_id'+no+'_'+i).value;
						stock_id_ = document.getElementById('stock_id'+no+'_'+i).value;
						product_name_ = document.getElementById('product_name'+no+'_'+i).value;
						amount_value_ = document.getElementById('amount_product'+no+'_'+i).value;
						amount_product_ = filterNum(amount_value_,'#session.ep.our_company_info.rate_round_num#');
						row_kontrol_ = document.getElementById('row_kontrol_2'+no+'_'+i).value;
						row_ = no +'_'+i;
						url += '&product_id'+row_+'='+product_id_+'&stock_id'+row_+'='+stock_id_+'&product_name'+row_+'='+product_name_+'&amount'+row_+'='+amount_product_+'&row_kontrol'+row_+'='+row_kontrol_+'';
					}
					else
					{
						alert(i+'. <cf_get_lang dictionary_id="38070.Satırda bilgiler eksik">');
						return false;
					}
				}
			</cfif>
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=production.emptypopup_ajax_add_p_order_operation_row'+url+'&no='+no+'&record_num='+record_num_+'&start_counter='+start_counter_+'&finish_counter='+finish_counter_+'&wrk_row_relation_id='+wrk_row_relation_id_ +'&wrk_row_id='+wrk_row_id_+'&type=1&is_del=0&p_order_id='+p_order_id_+'&employee='+employee_+'&asset_id='+asset_id_+'&operation='+operation_+'&amount='+amount_+'');	
			//windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=production.emptypopup_ajax_add_p_order_operation_row'+url+'&no='+no+'&record_num='+record_num_+'&start_counter='+start_counter_+'&finish_counter='+finish_counter_+'&wrk_row_relation_id='+wrk_row_relation_id_ +'&wrk_row_id='+wrk_row_id_+'&type=1&is_del=0&p_order_id='+p_order_id_+'&employee='+employee_+'&asset_id='+asset_id_+'&operation='+operation_+'&amount='+amount_+'','list');	
			document.getElementById('op_start'+no+'').value = "<cf_get_lang dictionary_id='38076.OPERASYON BAŞLADI'>";
			document.getElementById('op_stop'+no+'').value = "<cf_get_lang dictionary_id='38080.OPERASYONU DURDUR'>";
			document.getElementById('op_start'+no+'').disabled=true;//butona 2 kere tıklanmasın diye pasif yapıyoruz.!
			document.getElementById('op_stop'+no+'').disabled=false;
			document.getElementById('employee'+no+'').disabled=true;
			<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
				document.getElementById('asset'+no+'').disabled=true;
			</cfif>
			document.getElementById('operation'+no+'').disabled=true;
			alert("<cf_get_lang dictionary_id='38086.Operasyon Başlatıldı'>!");
		}
		function operation_stop(no,wrkrow)
		{//üretime başla denilmiş ise
			var record_num_ = document.getElementById('row_count_1'+no).value;
			var wrk_row_relation_id_ = '<cfoutput>#attributes.wrk_row_id#</cfoutput>'; // uretim emri satiri wrk_row_id
			var p_order_id_ = '<cfoutput>#attributes.prod_id#</cfoutput>'; //Üretim Emri ID
			if (wrkrow != undefined && wrkrow != '')
			{
				wrk_row_id_ = wrkrow;
			}
			else
			{
				var wrk_row_id_ = "";
				var userid_ = '<cfoutput>#session.ep.userid#</cfoutput>';
				var relation_id_ = list_getat(wrk_row_relation_id_,1,'_');
				wrk_row_id_ = relation_id_+'_'+no+'_'+p_order_id_+'_'+userid_;
			}
			if (eval("document.getElementById('employee'+no)") == undefined || eval("document.getElementById('employee'+no)").value == '')
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57576.Çalışan'>");
				return false;
			}
			<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
				if (eval("document.getElementById('asset'+no)") == undefined || eval("document.getElementById('asset'+no)").value == '')
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58833.Fiziki Varlık'>");
					return false;
				}
			</cfif>
			if (eval("document.getElementById('operation'+no)") == undefined || eval("document.getElementById('operation'+no)").value == '')
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='29419.Operasyon'>");
				return false;
			}
			document.getElementById('op_stop'+no+'').disabled=true;
			document.getElementById('op_finish'+no+'').disabled=true;
			document.getElementById('op_start'+no+'').disabled=false;
			document.getElementById('op_stop'+no+'').value = '<cf_get_lang dictionary_id="38079.OPERASYON DURDU">';
			document.getElementById('op_start'+no+'').value = '<cf_get_lang dictionary_id="38077.OPERASYONA DEVAM ET">';
			var employee_ = eval("document.getElementById('employee'+no)").value;
			<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
				var asset_id_ = eval("document.getElementById('asset'+no)").value;
			</cfif>
			var operation_ = eval("document.getElementById('operation'+no)").value;
			var amount_value = eval("document.getElementById('amount'+no)").value;
			var amount_ = filterNum(amount_value,'#session.ep.our_company_info.rate_round_num#');
			<cfif isdefined("xml_is_counter") and xml_is_counter eq 1>
				var start_counter_ = document.getElementById('start_counter_'+no).value;
				var finish_counter_ = document.getElementById('finish_counter_'+no).value;
			<cfelse>
				var start_counter_ = '';
				var finish_counter_ = '';
			</cfif>
			var product_catid_ = '<cfoutput>#get_order.PRODUCT_CATID#</cfoutput>'; //Ürün Kategorisi
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=production.popup_prod_operations&is_oper_row=1&product_catid='+product_catid_+'&no='+no+'&record_num='+record_num_+'&start_counter='+start_counter_+'&finish_counter='+finish_counter_+'&wrk_row_relation_id='+wrk_row_relation_id_ +'&wrk_row_id='+wrk_row_id_+'&type=0&is_del=0&p_order_id='+p_order_id_+'&employee='+employee_+'&asset_id='+asset_id_+'&operation='+operation_+'&amount='+amount_+'','small');	
		}
		
		function operation_finish(no,wrkrow)
		{//üretime başla denilmiş ise
			var record_num_ = document.getElementById('row_count_1'+no).value;
			var wrk_row_relation_id_ = '<cfoutput>#attributes.wrk_row_id#</cfoutput>'; // uretim emri satiri wrk_row_id
			var p_order_id_ = '<cfoutput>#attributes.prod_id#</cfoutput>'; //Üretim Emri ID
			if (wrkrow != undefined && wrkrow != '')
			{
				wrk_row_id_ = wrkrow;
			}
			else
			{
				var wrk_row_id_ = "";
				var userid_ = '<cfoutput>#session.ep.userid#</cfoutput>';
				var relation_id_ = list_getat(wrk_row_relation_id_,1,'_');
				wrk_row_id_ = relation_id_+'_'+no+'_'+p_order_id_+'_'+userid_;
			}
			if (eval("document.getElementById('employee'+no)") == undefined || eval("document.getElementById('employee'+no)").value == '')
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57576.Çalışan'>");
				return false;
			}
			<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
				if (eval("document.getElementById('asset'+no)") == undefined || eval("document.getElementById('asset'+no)").value == '')
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58833.Fiziki Varlık'>");
					return false;
				}
			</cfif>
			if (eval("document.getElementById('operation'+no)") == undefined || eval("document.getElementById('operation'+no)").value == '')
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='29419.Operasyon'>");
				return false;
			}
			<cfif isdefined("xml_is_counter") and xml_is_counter eq 1>
				if (eval("document.getElementById('start_counter_'+no)").value != '' && eval("document.getElementById('finish_counter_'+no)").value == '')
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='38054.Bitiş Sayacı'>");
					return false;
				}
			</cfif>
			document.getElementById('op_stop'+no+'').disabled=true;
			document.getElementById('op_start'+no+'').disabled=true;
			document.getElementById('op_finish'+no+'').disabled=true;
			document.getElementById('op_finish'+no+'').value = '<cf_get_lang dictionary_id="38081.OPERASYON SONLANDIRILIYOR">';
			var employee_ = eval("document.getElementById('employee'+no)").value;
			<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
				var asset_id_ = eval("document.getElementById('asset'+no)").value;
			<cfelse>
				var asset_id_ = '';
			</cfif>
			var operation_ = eval("document.getElementById('operation'+no)").value;
			var amount_value = eval("document.getElementById('amount'+no)").value;
			var amount_ = filterNum(amount_value,'#session.ep.our_company_info.rate_round_num#');
			<cfif isdefined("xml_is_counter") and xml_is_counter eq 1>
				var start_counter_ = document.getElementById('start_counter_'+no).value;
				var finish_counter_ = document.getElementById('finish_counter_'+no).value;
			<cfelse>
				var start_counter_ = '';
				var finish_counter_ = '';
			</cfif>
			//windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=production.emptypopup_ajax_add_p_order_operation_row&no='+no+'&record_num='+record_num_+'&start_counter='+start_counter_+'&finish_counter='+finish_counter_+'&wrk_row_relation_id='+wrk_row_relation_id_ +'&wrk_row_id='+wrk_row_id_+'&type=2&is_del=0&p_order_id='+p_order_id_+'&employee='+employee_+'&asset_id='+asset_id_+'','list');	
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=production.emptypopup_ajax_add_p_order_operation_row&no='+no+'&record_num='+record_num_+'&start_counter='+start_counter_+'&finish_counter='+finish_counter_+'&wrk_row_relation_id='+wrk_row_relation_id_ +'&wrk_row_id='+wrk_row_id_+'&type=2&is_del=0&p_order_id='+p_order_id_+'&employee='+employee_+'&asset_id='+asset_id_+'&operation='+operation_+'&amount='+amount_+'');	
		}
	</script>
</cfif>
