<!--- Yatay Kalite Kontrol Tipleri FBS 20121003 --->
<cfset new_round_num = 4>
<cfif isDefined("attributes.or_q_id") and Len(attributes.or_q_id)>
	<cfquery name="get_order_result_quality_row" datasource="#dsn3#">
		SELECT * FROM ORDER_RESULT_QUALITY_ROW WHERE OR_Q_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.or_q_id#">
	</cfquery>
	<cfset is_upd = 1>
	
	<cfset new_stock_id = get_quality_result.stock_id>
	<cfset new_process_id = get_quality_result.process_id>
	<cfset new_process_row_id = get_quality_result.process_row_id>
	<cfset new_process_cat = get_quality_result.process_cat>
	<cfset new_qid = get_quality_result.or_q_id>
<cfelse>
	<cfset get_order_result_quality_row.recordcount = 0>
	<cfquery name="get_amount_control" datasource="#dsn3#" maxrows="1">
		SELECT
			IS_ALL_AMOUNT
		FROM
			ORDER_RESULT_QUALITY
		WHERE
			IS_ALL_AMOUNT = 1 AND
			PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND
			(
				(PROCESS_CAT IN(76,811,171) AND SHIP_WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_wrk_row_id#">) OR
				(PROCESS_CAT NOT IN(76,811,171) AND PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">)
			)
	</cfquery>
	<cfset is_upd = 0>
	
	<cfset new_stock_id = attributes.stock_id>
	<cfset new_process_id = attributes.process_id>
	<cfset new_process_row_id = attributes.process_row_id>
	<cfset new_process_cat = attributes.process_cat>
	<cfset new_qid = "">
</cfif>
<!--- Kalan Miktar Kontrolu ---><!--- ??? KONTROL EDİLECEK... --->
<cfquery name="get_diff_amount" datasource="#dsn3#">
	SELECT ISNULL(SUM(CONTROL_AMOUNT),0) CONTROL_AMOUNT FROM ORDER_RESULT_QUALITY WHERE IS_REPROCESS= 0 AND STOCK_ID = #new_stock_id# AND PROCESS_ID = #new_process_id# AND PROCESS_ROW_ID = #new_process_row_id# AND PROCESS_CAT = #new_process_cat# <cfif Len(new_qid)> AND OR_Q_ID <> #new_qid#</cfif>
</cfquery>

<cfset Sample_Count = 0>
<cfif len(get_product_info.product_id) and len(get_order_no.company_id) and len(get_product_info.product_catid)>
	<cfquery name="get_paper_inspection" datasource="#dsn3#">
		SELECT INSPECTION_LEVEL_ID FROM PRODUCT_MEMBER_INSPECTION_LEVEL WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_no.company_id#"> AND (PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_info.product_id#"> OR PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_info.product_catid#">)
	</cfquery>
<cfelse>
	<cfset get_paper_inspection.recordcount = 0>
</cfif>

<cfif not get_paper_inspection.recordcount>
	<cfquery name="get_paper_inspection" datasource="#dsn3#">
		SELECT INSPECTION_LEVEL_ID FROM SETUP_INSPECTION_LEVEL WHERE IS_DEFAULT = 1
	</cfquery>
</cfif>

<cfif Len(get_paper_inspection.inspection_level_id) and len(get_product_info.product_id) and len(get_order_no.quantity)>
	<cfquery name="Get_Inspection_Level_Info" datasource="#dsn3#">
		SELECT
			SAMPLE_QUANTITY,
			ACCEPTANCE_QUANTITY,
			REJECTION_QUANTITY
		FROM 
			PRODUCT_QUALITY_PARAMETERS PQP,
			SETUP_INSPECTION_LEVEL SIL
		WHERE
			PQP.INSPECTION_LEVEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_paper_inspection.inspection_level_id#"> AND
			PQP.INSPECTION_LEVEL_ID = SIL.INSPECTION_LEVEL_ID AND
			PQP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_info.product_id#"> AND
			PQP.MIN_QUANTITY <= <cfqueryparam cfsqltype="cf_sql_float" value="#get_order_no.quantity#"> AND PQP.MAX_QUANTITY >= <cfqueryparam cfsqltype="cf_sql_float" value="#get_order_no.quantity#">
	</cfquery>
	<cfif not Get_Inspection_Level_Info.RecordCount>
		<cfquery name="Get_Inspection_Level_Info" datasource="#dsn3#">
			SELECT
				SAMPLE_QUANTITY,
				ACCEPTANCE_QUANTITY,
				REJECTION_QUANTITY
			FROM 
				PRODUCT_QUALITY_PARAMETERS PQP,
				SETUP_INSPECTION_LEVEL SIL
			WHERE
				PQP.INSPECTION_LEVEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_paper_inspection.inspection_level_id#"> AND
				PQP.INSPECTION_LEVEL_ID = SIL.INSPECTION_LEVEL_ID AND
				PQP.PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_info.product_catid#"> AND
				PQP.MIN_QUANTITY <= <cfqueryparam cfsqltype="cf_sql_float" value="#get_order_no.quantity#"> AND PQP.MAX_QUANTITY >= <cfqueryparam cfsqltype="cf_sql_float" value="#get_order_no.quantity#">
		</cfquery>
	</cfif>
	<cfif Len(Get_Inspection_Level_Info.Sample_Quantity)><cfset Sample_Count = Get_Inspection_Level_Info.Sample_Quantity></cfif>
	<cfif not Get_Inspection_Level_Info.RecordCount><cfset Get_Inspection_Level_Info.acceptance_quantity = 0><cfset Get_Inspection_Level_Info.rejection_quantity = 0></cfif>
</cfif>
<cfif Sample_Count eq 0><cfset Sample_Count = 1></cfif><!--- attributes.process_cat eq 171 and --->
<cfset serial_required = 0>
<cfif isDefined("xml_required_serial_number") and Len(xml_required_serial_number)>
	<cfif xml_required_serial_number eq 1 and attributes.process_cat eq 171>
		<cfset serial_required = 1>
	<cfelseif xml_required_serial_number eq 2 and ListFind("76,811",attributes.process_cat)>
		<cfset serial_required = 1>
	<cfelseif xml_required_serial_number eq 3>
		<cfset serial_required = 1>
	</cfif>
</cfif>
		<cf_box title="#getLang("","Seri no",57637)# #getLang("","kontrol",30185)#" >
        <div class="col col-2" id="quality_control_parameters">
            <cf_box_elements>
                <cfif Sample_Count gt 0>
                    <label class="hide"><cf_get_lang dictionary_id='32064.Kalite Kontrol'> <cf_get_lang dictionary_id='43570.Tablo'></label>
                    <cf_grid_list sort="0">
						<thead> 
							<cfoutput>	
								<cfloop from="1" to="#Sample_Count#" index="sq">
									<cfif get_order_result_quality_row.recordcount><!--- Guncelle --->
										<cfquery name="get_order_result_quality_row_query" dbtype="query">
											SELECT DISTINCT SERIAL FROM get_order_result_quality_row WHERE SAMPLE_COLUMN = #sq#
										</cfquery>
									</cfif>
									<tr>
										<th width="20">
											<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_add_serial_no_list&field_serial_no=add_quality.serial_number_#sq#&stock_id=#new_stock_id#&spect_id=','list');"><i class="fa fa-plus"></i></a>
										</th>
									</tr>
									<tr>
										<td width="20">
											<input type="text" name="serial_number_#sq#" id="serial_number_#sq#" value="<cfif get_order_result_quality_row.recordcount>#get_order_result_quality_row_query.serial#</cfif>" maxlength="100">
										</td>
									</tr>
								</cfloop>
								<input type="hidden" name="is_horizontal" id="is_horizontal" value="1"><!--- Tipler Yatay --->
								<input type="hidden" name="quantity_sample_count" id="quantity_sample_count" value="#Sample_Count#"><!--- Numune Sayisi --->
							</cfoutput>	
						</thead>
						<tbody>
							<cfoutput query="get_quality_type">
								<cfset _TYPE_ID_ = get_quality_type.type_id>
								<cfquery name="get_quality_type_row" datasource="#dsn3#">
									SELECT QUALITY_CONTROL_ROW, ISNULL(TOLERANCE,0) TOLERANCE, ISNULL(TOLERANCE_2,0) TOLERANCE_2, QUALITY_CONTROL_ROW_ID, QUALITY_ROW_DESCRIPTION, ISNULL(QUALITY_VALUE,0) QUALITY_VALUE, ISNULL(RESULT_TYPE,0) RESULT_TYPE FROM QUALITY_CONTROL_ROW WHERE QUALITY_CONTROL_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#_TYPE_ID_#">
								</cfquery>
							
								<cfloop query="get_quality_type_row">
								<tr class="color-row">
									<cfif len(GET_QUALITY_TYPE.TOLERANCE)>
										<cfset TOLERANCE_ = GET_QUALITY_TYPE.TOLERANCE>
									<cfelseif len(GET_QUALITY_TYPE_ROW.TOLERANCE)>
										<cfset TOLERANCE_ = GET_QUALITY_TYPE_ROW.TOLERANCE>
									<cfelse>
										<cfset TOLERANCE_ = 0>
									</cfif>
									<cfif len(GET_QUALITY_TYPE.TOLERANCE_2)>
										<cfset TOLERANCE_2_ = GET_QUALITY_TYPE.TOLERANCE_2>
									<cfelseif len(GET_QUALITY_TYPE_ROW.TOLERANCE_2)>
										<cfset TOLERANCE_2_ = GET_QUALITY_TYPE_ROW.TOLERANCE_2>
									<cfelse>
										<cfset TOLERANCE_2_ = 0>
									</cfif> 
									
									<input type="hidden" name="quality_control_row_id_list_#_TYPE_ID_#" id="quality_control_row_id_list_#_TYPE_ID_#" value="#quality_control_row_id#">
									<cfloop from="1" to="#Sample_Count#" index="sq">
										<cfif get_order_result_quality_row.recordcount><!--- Guncelle --->
											<cfquery name="get_order_result_quality_row_query" dbtype="query">
												SELECT * FROM get_order_result_quality_row WHERE CONTROL_TYPE_ID = #_TYPE_ID_# AND CONTROL_ROW_ID = #quality_control_row_id#  AND SAMPLE_COLUMN = #sq#
											</cfquery>
										<cfelse>
											<cfset get_order_result_quality_row_query.control_result = "">
											<cfset get_order_result_quality_row_query.quality_value = 1>
										</cfif>
										
											<cfset rule_ = 0>
											<cfif len(GET_QUALITY_TYPE.quality_rule)>
												<cfset rule_ = GET_QUALITY_TYPE.quality_rule>
											</cfif> 
											<input type="hidden" name="quality_rule_#_TYPE_ID_#_#quality_control_row_id#_#sq#" id="quality_rule_#_TYPE_ID_#_#quality_control_row_id#_#sq#" value="#rule_#" style="width:50px;">
									</cfloop>
								</tr>
								</cfloop>
							</cfoutput>
						</tbody>
                    </cf_grid_list>
                <cfelse>
                    <label class="bold"><cf_get_lang dictionary_id='60590.Lütfen Kalite Tanımlarınızı Düzenleyiniz'>...</label>
                </cfif>
            </cf_box_elements>
        </div>
	</cf_box>
<cfset get_queries = createObject("component","V16.production_plan.cfc.get_succes_name")>
<cfset get_quality_success =get_queries.get_succes_name()>

		
<script language="javascript">
var new_round_num = "<cfoutput>#new_round_num#</cfoutput>";
function all_amount_control()
{
	if(document.getElementById("is_all_amount").checked == true)
	{
		if(document.getElementById("tr_control_success") != undefined) document.getElementById("tr_control_success").style.display = "";
		if(document.getElementById("tr_control_amount") != undefined) document.getElementById("tr_control_amount").style.display = "";
		if(document.getElementById("tr_success_label") != undefined) document.getElementById("tr_success_label").style.display = "none";
	}
	else
	{
		if(document.getElementById("tr_control_success") != undefined) document.getElementById("tr_control_success").style.display = "none";
		if(document.getElementById("tr_control_amount") != undefined) document.getElementById("tr_control_amount").style.display = "none";
		if(document.getElementById("tr_success_label") != undefined) document.getElementById("tr_success_label").style.display = "";
	}
}
function calculate()
{
	//if(document.getElementById("is_all_amount") == undefined || document.getElementById("is_all_amount").checked == false)
	//{
		var row_ = 0;
		var new_tolerance_neg = 0;
		var new_tolerance_pos = 0;
		<cfif Sample_Count gt 0>
			<cfif get_quality_type.recordcount>
				<cfoutput query="get_quality_type">
					<cfquery name="get_quality_type_row_js" datasource="#dsn3#">
						SELECT QUALITY_CONTROL_ROW, ISNULL(TOLERANCE,0) TOLERANCE, ISNULL(TOLERANCE_2,0) TOLERANCE_2, QUALITY_CONTROL_ROW_ID, QUALITY_ROW_DESCRIPTION, ISNULL(QUALITY_VALUE,0) QUALITY_VALUE, ISNULL(RESULT_TYPE,0) RESULT_TYPE FROM QUALITY_CONTROL_ROW WHERE QUALITY_CONTROL_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_quality_type.type_id#">
					</cfquery>
					<cfif get_quality_type_row_js.recordcount>
						if(document.getElementById("is_all_amount") == undefined || document.getElementById("is_all_amount").checked == false)
						{
							<cfloop query="get_quality_type_row_js">
								row_++;
								<cfif get_quality_type_row_js.result_type neq 1>
									var new_tolerance_neg = parseFloat("#get_quality_type_row_js.quality_value-get_quality_type_row_js.tolerance_2#");
									var new_tolerance_pos = parseFloat("#get_quality_type_row_js.quality_value+get_quality_type_row_js.tolerance#");
								</cfif>
								<cfloop from="1" to="#Sample_Count#" index="sq">
									<cfif serial_required eq 1>
										if(document.getElementById("serial_number_#sq#").value == "")
										{
											alert("#sq#. <cf_get_lang dictionary_id='57412.Seri No Boş Bırakılmamalıdır'>!");
											return false;
										}
									</cfif>
									<cfif get_quality_type_row_js.result_type neq 1>
										var new_quality_result_ = parseFloat(filterNum(document.getElementById("quality_result_#get_quality_type.type_id#_#get_quality_type_row_js.quality_control_row_id#_#sq#").value,new_round_num));
										if(document.getElementById("quality_result_#get_quality_type.type_id#_#get_quality_type_row_js.quality_control_row_id#_#sq#") != undefined && document.getElementById("quality_result_#get_quality_type.type_id#_#get_quality_type_row_js.quality_control_row_id#_#sq#").value == "")
										{
											alert(row_ + ". <cf_get_lang dictionary_id='58508.Satır'>. #sq#. <cf_get_lang dictionary_id='60591.Sütun Değeri Boş Bırakılmamalıdır'>!");
											return false;
										}
										if((new_quality_result_ >= new_tolerance_neg) && (new_quality_result_ <= new_tolerance_pos))
											document.getElementById("quality_result_value_#get_quality_type.type_id#_#get_quality_type_row_js.quality_control_row_id#_#sq#").value = 1;
										else
											document.getElementById("quality_result_value_#get_quality_type.type_id#_#get_quality_type_row_js.quality_control_row_id#_#sq#").value = 0;
									</cfif>
								</cfloop>
							</cfloop>
						}
					<cfelse>
						alert("<cf_get_lang dictionary_id='60592.Lütfen Kalite Kontrol Kriterlerini Düzenleyiniz'>!");
						return false;
					</cfif>
				</cfoutput>
			<cfelse>
				alert("<cf_get_lang dictionary_id='60592.Lütfen Kalite Kontrol Kriterlerini Düzenleyiniz'>!");
				return false;
			</cfif>

			if(document.getElementById("is_all_amount") == undefined || document.getElementById("is_all_amount").checked == false)
			{
				<cfoutput>
				var rejection_count = 0;
				<cfif get_quality_type.recordcount>
					<cfquery name="get_quality_type_row_js" datasource="#dsn3#">
						SELECT QUALITY_CONTROL_TYPE_ID,QUALITY_CONTROL_ROW, ISNULL(TOLERANCE,0) TOLERANCE, ISNULL(TOLERANCE_2,0) TOLERANCE_2, QUALITY_CONTROL_ROW_ID, QUALITY_ROW_DESCRIPTION, ISNULL(QUALITY_VALUE,0) QUALITY_VALUE, ISNULL(RESULT_TYPE,0) RESULT_TYPE FROM QUALITY_CONTROL_ROW WHERE QUALITY_CONTROL_TYPE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#ValueList(get_quality_type.type_id)#">)
					</cfquery>
					<cfloop from="1" to="#Sample_Count#" index="xx">
						var result_calc_#xx# = 1;
						<cfloop query="get_quality_type_row_js">
							//Sonuc Kontrolleri Yapiliyor
							var new_quality_result_value = parseFloat(filterNum(document.getElementById("quality_result_value_#get_quality_type_row_js.quality_control_type_id#_#get_quality_type_row_js.quality_control_row_id#_#xx#").value,new_round_num));
							if(new_quality_result_value == 0)
								result_calc_#xx# = 0;
						</cfloop>
						if(result_calc_#xx# == 0)
							rejection_count++;
					</cfloop>
				</cfif>
				<cfif attributes.process_cat eq 171 or (ListFind("76,811",attributes.process_cat) and Sample_Count eq 1)>
					//Uretim Sonucunda Red Varsa Red, Yoksa Kabuldur Cunku Tek Gelir
					if(rejection_count > 0)
						var success_result = 0;
					else
						var success_result = 1;
				<cfelse>
					//Kabul-Red Karsilastirmasi Yapilir
					<cfif isDefined("Get_Inspection_Level_Info") and Get_Inspection_Level_Info.RecordCount>
					if(rejection_count <= parseFloat("#Get_Inspection_Level_Info.acceptance_quantity#"))
						var success_result = 1;
					else if(rejection_count >= parseFloat("#Get_Inspection_Level_Info.rejection_quantity#"))
						var success_result = 0;
					else
						var success_result = 2;
					<cfelse>
						var success_result = 2;
					</cfif>
				</cfif>
				
				get_success = wrk_query("SELECT SUCCESS_ID,IS_SUCCESS_TYPE FROM QUALITY_SUCCESS WHERE IS_DEFAULT_TYPE = 1 AND IS_SUCCESS_TYPE = " + success_result,"dsn3");
				if(get_success.recordcount)
					document.getElementById("success_id").value = get_success.SUCCESS_ID;
				</cfoutput>
			}
		</cfif>
		if(document.getElementById("is_all_amount") == undefined || document.getElementById("is_all_amount").checked == false)
			document.getElementById("control_amount").value = document.getElementById("quantity_sample_count").value;
	/*
	}
	else
	*/
	if(document.getElementById("is_all_amount") != undefined && document.getElementById("is_all_amount").checked == true)
	{
		if(document.getElementById("control_amount_control").value == "")
		{
			alert("<cf_get_lang dictionary_id ='57471.Eksik Veri'> : <cf_get_lang dictionary_id='36657.Kontrol Edilen Miktar'>");
			return false;
		}
		if(parseFloat(filterNum(document.getElementById("control_amount_control").value,new_round_num)) > parseFloat(filterNum(document.getElementById("control_amount").value,new_round_num)))
		{
			alert("<cf_get_lang dictionary_id='36681.Kontrol Miktarı'>  <cf_get_lang dictionary_id='60593.Büyük Olamaz'>!" + document.getElementById("control_amount").value );
			return false;
		}
		if(document.getElementById("success_id_control").value == "")
		{
			alert("<cf_get_lang dictionary_id ='57471.Eksik Veri'> : <cf_get_lang dictionary_id='36552.Kontrol Sonucu'>");
			return false;
		}
		document.getElementById("success_id").value = document.getElementById("success_id_control").value;
		document.getElementById("control_amount").value = document.getElementById("control_amount_control").value;
	}
	return true;
}
</script>
