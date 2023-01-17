<cf_get_lang_set module_name="prod">
	<cf_xml_page_edit fuseact="prod.popup_add_quality_control_report">
	<cfquery name="get_quality_result" datasource="#dsn3#">
		SELECT * FROM ORDER_RESULT_QUALITY WHERE OR_Q_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.OR_Q_ID#">
	</cfquery>
	<cfset attributes.process_cat = GET_QUALITY_RESULT.process_cat>
	<cfset attributes.process_id = GET_QUALITY_RESULT.process_id>
	<cfset attributes.process_row_id = GET_QUALITY_RESULT.process_row_id>
	<cfset attributes.ship_wrk_row_id = GET_QUALITY_RESULT.ship_wrk_row_id>
	<!--- Belge No, Uretim ise Uretime Gore Ayri Gelir, Uretimin Kontrol No Bos ise Digeri Gelmeye Devam Eder --->
	<cfif attributes.process_cat eq 171><cfset paper_type_ = "PRODUCTION_QUALITY_CONTROL"><cf_papers paper_type="production_quality_control"></cfif>
	<cfif not isDefined("paper_number") or not Len(paper_number)><cfset paper_type_ = "QUALITY_CONTROL"><cf_papers paper_type="quality_control"></cfif>
	<!--- //Belge No, Uretim ise Uretime Gore Ayri Gelir, Uretimin Kontrol No Bos ise Digeri Gelmeye Devam Eder --->
	<cfquery name="GET_ORDER_NO" datasource="#dsn3#">
		<cfif attributes.process_cat eq 171><!--- Üretim Sonucu --->
			SELECT
				(SELECT AMOUNT FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = POR.PR_ORDER_ID AND TYPE=1 AND WRK_ROW_ID = '#attributes.ship_wrk_row_id#') AS QUANTITY,
				PO.P_ORDER_NO,
				POR.RESULT_NO,
				0 AS COMPANY_ID
			FROM 
				PRODUCTION_ORDERS PO,
				PRODUCTION_ORDER_RESULTS POR
			WHERE
				POR.P_ORDER_ID = PO.P_ORDER_ID AND
				PO.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND
				POR.PR_ORDER_ID = (SELECT PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW WHERE WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_wrk_row_id#">)
		<cfelseif attributes.process_cat eq 76 or attributes.process_cat eq 811><!--- Mal Alım İrsaliyesi --->
			SELECT 
				SR.AMOUNT AS QUANTITY,
				S.SHIP_NUMBER AS P_ORDER_NO,
				S.SHIP_NUMBER AS RESULT_NO,
				S.COMPANY_ID AS COMPANY_ID
			FROM 
				#dsn2_alias#.SHIP S,#dsn2_alias#.SHIP_ROW SR
			WHERE 
				S.SHIP_ID = SR.SHIP_ID AND 
				S.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND 
				SR.WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_wrk_row_id#"> AND
				S.SHIP_TYPE IN(76,811)
		<cfelseif attributes.process_cat eq -1><!--- Operasyonlar --->
			SELECT
				ISNULL(PO.AMOUNT,0) AS QUANTITY,
				POS.P_ORDER_NO,
				POS.P_ORDER_NO AS RESULT_NO ,
				0 AS COMPANY_ID
			FROM
				PRODUCTION_OPERATION_RESULT POR,
				PRODUCTION_OPERATION PO,
				PRODUCTION_ORDERS POS
			WHERE
				POR.P_ORDER_ID = POS.P_ORDER_ID AND
				PO.P_OPERATION_ID = POR.OPERATION_ID AND
				POR.OPERATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">
		<cfelseif attributes.process_cat eq -2><!--- Operasyonlar --->
			SELECT
				1 QUANTITY,
				SERVICE_HEAD P_ORDER_NO,
				SERVICE_HEAD  AS RESULT_NO,
				0 AS COMPANY_ID
			FROM 
				SERVICE 
			WHERE	
				SERVICE.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">
		<cfelseif attributes.process_cat eq -3><!--- Lab İşlemleri --->
			SELECT
				LSR.SAMPLE_AMOUNT QUANTITY,
				RLT.LAB_REPORT_NO P_ORDER_NO,
				RLT.LAB_REPORT_NO  AS RESULT_NO,
				0 AS COMPANY_ID
			FROM 
				#dsn#.REFINERY_LAB_TESTS RLT
				LEFT JOIN #dsn#.LAB_SAMPLING LS ON RLT.REFINERY_LAB_TEST_ID = LS.SAMPLE_ANALYSIS_ID
				LEFT JOIN #dsn#.LAB_SAMPLING_ROW LSR ON LSR.SAMPLING_ID = LS.SAMPLING_ID
			WHERE	
				LSR.SAMPLING_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">
		</cfif>
	</cfquery>
	<cfif isdefined("GET_QUALITY_RESULT.stock_id") and len(GET_QUALITY_RESULT.stock_id)>
		<cfquery name="get_product_info" datasource="#dsn3#">
			SELECT PRODUCT_ID,PRODUCT_NAME,STOCK_CODE,PRODUCT_CATID,STOCK_ID FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_QUALITY_RESULT.stock_id#">
		</cfquery>
	</cfif>
	<cfquery name="get_quality_type" datasource="#dsn3#">
		SELECT 
			CCT.QUALITY_CONTROL_TYPE,
			CCT.TYPE_ID,
			CCT.QUALITY_MEASURE,
			CCT.TYPE_DESCRIPTION,
			CCT.STANDART_VALUE,
			PQ.*
		FROM
			QUALITY_CONTROL_TYPE CCT,
			PRODUCT_QUALITY PQ
		WHERE 
			PQ.QUALITY_TYPE_ID = CCT.TYPE_ID 
			<cfif isdefined("get_product_info.product_id") and len(get_product_info.product_id)>
				AND PQ.PRODUCT_ID IS NOT NULL 
				AND PQ.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_info.product_id#"> 
			<cfelse>
				AND 1 = 0 	
			</cfif>
			<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
				AND PQ.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#">
			</cfif>
			<cfif isdefined("attributes.operation_type_id") and len(attributes.operation_type_id)>
				AND OPERATION_TYPE_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#operation_type_id#%">
			</cfif>
		ORDER BY
			PQ.PRODUCT_ID,
			PQ.PRODUCT_CAT_ID,
			PQ.ORDER_NO,
			PQ.QUALITY_TYPE_ID
	</cfquery>
	<cfif not get_quality_type.recordcount><!--- Urunde Yoksa Kategoriye Bakilir --->
		<cfquery name="get_quality_type" datasource="#dsn3#">
			SELECT 
				CCT.QUALITY_CONTROL_TYPE,
				CCT.TYPE_ID,
				CCT.QUALITY_MEASURE,
				CCT.TYPE_DESCRIPTION,
				CCT.STANDART_VALUE,
				PQ.*
			FROM
				QUALITY_CONTROL_TYPE CCT,
				PRODUCT_QUALITY PQ
			WHERE 
				PQ.QUALITY_TYPE_ID = CCT.TYPE_ID 
				<cfif isdefined("get_product_info.product_id") and len(get_product_info.product_id)>
					AND PQ.PRODUCT_CAT_ID IS  NOT NULL AND PQ.PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_info.product_catid#"> 
				<cfelse>
					AND 1 = 0 	
				</cfif>
				<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
					AND PQ.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#">
				</cfif>
				<cfif isdefined("attributes.operation_type_id") and len(attributes.operation_type_id)>
					AND OPERATION_TYPE_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#operation_type_id#%">
				</cfif>
			ORDER BY
				PQ.PRODUCT_ID,
				PQ.PRODUCT_CAT_ID,
				PQ.ORDER_NO,
				PQ.QUALITY_TYPE_ID
		</cfquery>
	</cfif>
	<cfset record_date = wrk_get_today()>
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
		SELECT ISNULL(SUM(CONTROL_AMOUNT),0) CONTROL_AMOUNT FROM ORDER_RESULT_QUALITY WHERE IS_REPROCESS= 0 AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_stock_id#"> AND PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_process_id#"> AND PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_process_row_id#"> AND PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_process_cat#"> <cfif Len(new_qid)> AND OR_Q_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#new_qid#"></cfif>
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
	<cfquery name="get_quality_list" datasource="#dsn3#">
		SELECT
			ISNULL(SUM(CONTROL_AMOUNT),0) CONTROL_AMOUNT
		FROM 
			ORDER_RESULT_QUALITY ORQ 
		WHERE
			IS_REPROCESS = 0 AND
			PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND
			(
				(PROCESS_CAT IN(76,811,171) AND SHIP_WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_wrk_row_id#">) OR
				(PROCESS_CAT NOT IN(76,811,171) AND PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">)
			)
	</cfquery>
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
	<cfset get_queries = createObject("component","V16.production_plan.cfc.get_succes_name")>
	<cfset get_quality_success =get_queries.get_succes_name()>
	<cfset record_date = wrk_get_today()>
	<cfset is_upd="1">
	<cfset pageHead = #getLang('prod',337)# & " : " & #get_order_no.P_ORDER_NO#>
	<cfif not isDefined('attributes.draggable')><cf_catalystHeader></cfif>
		<cfsavecontent variable="message"><cfif isdefined("get_product_info.product_id") and len(get_product_info.product_id)><cfoutput>#get_product_info.PRODUCT_NAME#</cfoutput></cfif></cfsavecontent>
	<div class="col col-12">
		<cfform action="#request.self#?fuseaction=stock.emptypopup_upd_quality_control_report_row" method="post" name="upd_quality">

		<cf_box title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
			<cfif not isdefined("attributes.ship_wrk_row_id")><cfset attributes.ship_wrk_row_id = ''></cfif>
				<cfoutput>
					<cf_box_elements>
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="ui-info-bottom">
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" sort="true" index="1">
								<div class="form-group" id="item-file_no">
									<label class="col col-5 col-md-4 col-sm-4 col-xs-12 bold"><cf_get_lang dictionary_id='60244.Kaynak Belge No'>:</label>
									<label class="col col-7 col-md-8 col-sm-8 col-xs-12 "><cfoutput>#get_order_no.result_no#</cfoutput></label>
								</div>
							</div>
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" sort="true" index="2">
								<div class="form-group" id="item-stock_no">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12 bold"><cf_get_lang dictionary_id='57800.İşlem Tipi'>:</label>
									<label lass="col col-8 col-md-8 col-sm-8 col-xs-12 ">
										<cfif attributes.process_cat eq 76><cf_get_lang dictionary_id='29581.Mal Alım İrsaliyesi'></cfif>
										<cfif attributes.process_cat eq 171><cf_get_lang dictionary_id='29651.Üretim Sonucu'></cfif>
										<cfif attributes.process_cat eq 811><cf_get_lang dictionary_id="29588.İthal Mal Girişi"></cfif>
										<cfif attributes.process_cat eq -1><cf_get_lang dictionary_id="36376.Operasyonlar"></cfif>
										<cfif attributes.process_cat eq -2><cf_get_lang dictionary_id="57656.Servis"></cfif>
										<cfif attributes.process_cat eq -3><cf_get_lang dictionary_id='64426.Laboratuvar İşlemi'></cfif>
									</label>
								</div>
							</div>
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" sort="true" index="3">
								<div class="form-group" id="item-stock_no">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12 bold"><cf_get_lang dictionary_id='57518.Stok Kodu'>:</label>
									<label lass="col col-8 col-md-8 col-sm-8 col-xs-12 "><cfif isdefined("get_product_info.product_id") and len(get_product_info.product_id)>#get_product_info.stock_code#</cfif></label>
								</div>
							</div>
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" sort="true" index="4">
								<div class="form-group" id="item-quantity">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12 bold"><cf_get_lang dictionary_id='59084.Parti Miktarı'>:</label>
									<label lass="col col-8 col-md-8 col-sm-8 col-xs-12 "><cfoutput>#get_order_no.quantity#</cfoutput></label>
								</div>
							</div>
						</div>
					</div>
					</cf_box_elements>
				</cfoutput>
				<!--- Yatay --->
				<div id="control_def">
					<cfset attributes.pid = get_product_info.product_id>
					<cf_box_elements>
						<cfinclude template="quality_control_report_upd.cfm">
					</cf_box_elements>
				</div>
				<cf_seperator id="doc_result" title="#getLang('','Başarım  Sonucu','64128')#">
				<div id="doc_result">
					<cfif not len(get_order_no.quantity)><cfset get_order_no_ = 0><cfelse><cfset get_order_no_ = get_order_no.quantity></cfif>
						<cfset control_amount_n=get_order_no_-get_diff_amount.control_amount>
						<input type="hidden" name="control_amount_" id="control_amount_" value="<cfif len(get_order_no.quantity) and len(get_diff_amount.control_amount)><cfoutput>#control_amount_n#</cfoutput></cfif>">
						<input type="hidden" name="quality_type_list" id="quality_type_list" value="<cfoutput>#ValueList(GET_QUALITY_TYPE.TYPE_ID,',')#</cfoutput>">
						<input type="hidden" name="success_id" id="success_id" value="<cfoutput><cfif is_upd eq 1>#get_quality_result.success_id#</cfif></cfoutput>" />
						<cfif not isdefined("attributes.ship_wrk_row_id")><cfset attributes.ship_wrk_row_id = ''></cfif>
						<cfoutput>
							<input type="hidden" name="control_amount_old" id="control_amount_old" value="<cfif len(get_order_no.quantity) and len(get_quality_list.control_amount)>#get_order_no.quantity-get_quality_list.control_amount#<cfelse>#get_order_no.quantity#</cfif>">
							<input type="hidden" name="process_cat" id="process_cat" value="#attributes.process_cat#">
							<input type="hidden" name="process_id" id="process_id" value="#attributes.process_id#">
							<input type="hidden" name="process_row_id" id="process_row_id" value="#attributes.process_row_id#">
							<input type="hidden" name="ship_wrk_row_id" id="ship_wrk_row_id" value="#attributes.ship_wrk_row_id#">
							<input type="hidden" name="stock_id" id="stock_id" value="#get_product_info.stock_id#">
							<input type="hidden" name="result_no" id="result_no" value="#get_order_no.result_no#"><!--- Belge No --->
							<input type="hidden" name="qualtity_" id="qualtity_" value="#get_order_no.quantity#"><!--- parti no --->
							<input type="hidden" name="pid" id="pid" value="<cfif isdefined("attributes.pid")>#attributes.pid#</cfif>">
							<input type="hidden" name="or_q_id" id="or_q_id" value="<cfif isdefined("attributes.or_q_id")>#attributes.or_q_id#</cfif>">
						</cfoutput>
						<cf_box_elements>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
								<cf_grid_list sort="0">
									<thead>
										<tr>
											<th width="150"><cf_get_lang dictionary_id='36468.Başarım'></th>
											<th width="90" class="text-right"><cf_get_lang dictionary_id='57635.Miktar'></th>
										</tr>
									</thead>
									<tbody>
										<cfset sum_amount = 0>
										<cfif get_quality_success.RecordCount>
											<cfoutput query="get_quality_success">
												<tr>
													<td>
														<cfinput type="hidden" name="q_success_id#currentrow#" id="q_success_id#currentrow#" value="#get_quality_success.SUCCESS_ID#">
														#SUCCESS#
													</td>
													<td class="text-right">
														<cfquery name="get_succes_type" datasource="#dsn3#">
															SELECT ISNULL(AMOUNT, 0) AMOUNT FROM ORDER_RESULT_QUALITY_SUCCESS_TYPE
															WHERE ORDER_RESULT_QUALITY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.or_q_id#">
															AND SUCCESS_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#SUCCESS_ID#">
														</cfquery>
														<cfif not len (get_succes_type.AMOUNT)><cfset success_amount= 0><cfelse><cfset success_amount= get_succes_type.AMOUNT></cfif>
														<cfset sum_amount = sum_amount + success_amount>
														<input type="text" name="success_amount#currentrow#" id="success_amount#currentrow#" value="#get_succes_type.AMOUNT#" onblur="sum()" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox sum_">
													</td>
												</tr>
											</cfoutput>
											<tr>
												<td class="bold"><cf_get_lang dictionary_id='57492.Toplam'></td>
												<td class="text-right bold">
													
													<cfset kalan_ = get_order_no_- get_quality_list.control_amount>
													<cfinput type="text" name="control_amount_control" id="control_amount_control" value="#sum_amount#" class="moneybox">
												</td>
												<cfinput type="hidden" name="row_count" id="row_count" value="#get_quality_success.recordcount#">
											</tr>
										</cfif>
									</tbody>
								</cf_grid_list>							
							</div>
							<cfoutput>
								<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
									<div class="form-group" id="item-q_control_no">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12 "><cf_get_lang dictionary_id='36479.Kontrol No'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12 ">
											<input type="text" name="q_control_no" id="q_control_no" value="#paper_code & '-' & paper_number#" style="width:120px;">
										</div>
									</div>
									<div class="form-group" id="item-date">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12 "><cf_get_lang dictionary_id='57094.Kontrol Tarihi'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<div class="input-group">
												<cfinput type="text" name="control_date" id="control_date" maxlength="10" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="control_date"></span>
											</div>
										</div>									
									</div>									
									<div class="form-group" id="item-process_cat">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12 "><cf_get_lang dictionary_id="58859.Süreç"> *</label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12 ">
											<cf_workcube_process is_upd='0' process_cat_width='120' is_detail='0'>
										</div>
									</div>
									<div class="form-group" id="item-controller_emp">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12 "><cf_get_lang dictionary_id='57032.Kontrol Eden'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12 ">
											<div class="input-group">
												<cfoutput>
													<input type="hidden" name="controller_emp_id" id="controller_emp_id" value="<cfif is_upd eq 1>#get_quality_result.controller_emp_id#<cfelse>#attributes.controller_emp_id#</cfif>">			
													<input type="text" name="controller_emp" id="controller_emp" value="<cfif is_upd eq 1>#get_emp_info(get_quality_result.controller_emp_id,0,0)#<cfelse>#attributes.controller_emp#</cfif>" onFocus="AutoComplete_Create('controller_emp_','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','controller_emp_id','','3','130');" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_emps&field_id=add_quality.controller_emp_id&field_name=add_quality.controller_emp&select_list=1</cfoutput>');"></span>
												</cfoutput>
											</div>
										</div>
									</div>
								</div>
							</cfoutput>
						</cf_box_elements>
							<cf_box_footer>
								<div class="col col-6 col-xs-12">
									<cf_record_info query_name="GET_QUALITY_RESULT">
								</div>
								<div class="col col-6 col-xs-12">
									<cf_workcube_buttons type_format='1' is_upd="1" is_delete="1" add_function="unformat_fields()" delete_page_url='#request.self#?fuseaction=stock.emptypopup_upd_quality_control_report_row&is_delete=1&OR_Q_ID=#attributes.OR_Q_ID#'>
								</div>
							</cf_box_footer>
						<cfif isdefined("get_quality_list.control_amount") and get_quality_list.control_amount gte get_order_no.quantity>
							<script type="text/javascript">
								document.getElementById('wrk_submit_button').disabled = true;
								document.getElementById('wrk_submit_button').value = "<cf_get_lang dictionary_id='64385.Tüm Miktarlar Kontrol Edildi'>";
								document.getElementById("wrk_submit_button").className = 'ui-wrk-btn-extra';
							</script>
						</cfif>
				</div>
		</cf_box>	
		<cfif not attributes.fuseaction eq 'objects.widget_loader' and not isDefined('attributes.draggable')>
			<cf_box title="#getLang('','Yapılan Kontroller','36668')#" box_page="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_ajax_list_quality_controls&from_add_contol_page=1&process_id_=#attributes.process_id#&process_row_id_=#attributes.process_row_id#&ship_wrk_row_id_=#attributes.ship_wrk_row_id#&production_quantity=#get_order_no.quantity#&pid=#get_product_info.product_id#&is_upd_page=1">
			</cf_box>
		</cfif>	
		
		</cfform>  
	</div>
	<script type="text/javascript">
		function unformat_fields()
		{	
			var control_amount_filterrr = filterNum(document.getElementById('control_amount_control_').value);
			if(control_amount_filterrr > document.getElementById('qualtity__').value)
			{
				alert("<cf_get_lang dictionary_id='63487.Kontrol edilen miktar parti miktarından büyük olamaz'>!");
			
				return false;
			}

			if(!paper_control(upd_quality.q_control_no,'<cfoutput>#paper_type_#',true,'#attributes.OR_Q_ID#','','','','','#dsn3#</cfoutput>')) return false;
			//if (!chk_period(upd_quality.quality_date,"İşlem")) return false; //tabloda kalite tarihi olmadığı,kalite şirkette tutulduğu ve ayrıca period_id bilgisinide tuttuğumuz için tarih kontrolünü kaldırıyorum hgul20140122.
			if (!process_cat_control()) return false;
			if(!form_warning('control_amount','Kontrol Miktarı Giriniz!')) return false;
			<cfif isDefined("xml_show_horizontal_quality_type") and xml_show_horizontal_quality_type eq 1>
				var control_amount_filter = document.getElementById('control_amount').value;
			<cfelse>
				var control_amount_filter = filterNum(document.getElementById('control_amount').value);
			</cfif>
			if(parseInt(control_amount_filter) > "<cfoutput>#GET_ORDER_NO.QUANTITY#</cfoutput>")
			{
				alert("<cf_get_lang dictionary_id='36706.Kontrol Miktarı İşlem Miktarından Büyük Olamaz'>!");
				return false;
			}		
			<cfif isDefined("xml_show_horizontal_quality_type") and xml_show_horizontal_quality_type eq 0>
				if(document.getElementById('success_id') != undefined && document.getElementById('success_id').value=='')
				{
					alert("<cf_get_lang dictionary_id='36679.Kontrol Tipi Girmelisiniz'>!");
					return false;
				}
				<cfif GET_QUALITY_TYPE.recordcount>
					<cfoutput query="GET_QUALITY_TYPE">
					{
						if(!form_warning('result_#TYPE_ID#',"<cf_get_lang dictionary_id='36683.Sonuç Giriniz'>")) 
							return false;
						if(document.getElementById('result_#TYPE_ID#') != undefined && document.getElementById('quality_rule__#TYPE_ID#') == 0)
							document.getElementById('result_#TYPE_ID#').value = filterNum(document.getElementById('result_#TYPE_ID#').value,4);
					}
					</cfoutput>
				<cfelse>
					{
						alert("<cf_get_lang dictionary_id='36686.Ürün İçin Tanımlı Kalite Kontrol Tipi Yok'>!");
						return false;
					}
				</cfif>
				//queryde filtreliyor buna gerek yok document.upd_quality.control_amount.value = filterNum(document.upd_quality.control_amount.value,3);
			</cfif>
			<cfif isDefined("xml_show_horizontal_quality_type") and xml_show_horizontal_quality_type eq 1>
			return calculate();
			</cfif>
		}
		function sum() {
			var sum = 0;
			$(".sum_").each(function() {   
				sum += +filterNum(this.value);
			});
			$('#control_amount_control').val(sum);
	
		}

	</script>
	<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
	