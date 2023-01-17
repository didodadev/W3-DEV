<cfif attributes.is_order_terms eq 1>
	<!--- Planlama Bazinda Sevkiyat Iliskisi Gerekli Alanlar --->
	<cfset attributes.assetp_id = "">
	<cfset attributes.assetp_name = "">
	<cfset attributes.deliver_h = 0>
	<cfset attributes.deliver_m = 0>
	<cfset attributes.max_limit = "">
	<cfset attributes.note = attributes.note_2>
	<cfset attributes.plate = "">
	<cfset attributes.total_cost_value = 0>
	<cfset attributes.total_cost2_value = 0>
	<cfset attributes.vehicle_emp_id = "">
	<cfset attributes.vehicle_emp_name = "">
	<cfloop from="1" to="#attributes.record_num#" index="xyz">
		<cfset 'attributes.cari_#xyz#_ship_id_list' = "">
		<cfset 'attributes.cari_kontrol#xyz#' = "">
		<cfset 'attributes.company_id#xyz#' = "">
		<cfset 'attributes.partner_id#xyz#' = "">
		<cfset 'attributes.consumer_id#xyz#' = "">
		<cfset 'attributes.member_name#xyz#' = "">
		<cfset 'attributes.related_row_kontrol#xyz#' = "">
		<cfset 'attributes.row_count_#xyz#_list' = "">
		<cfset 'attributes.ship_adress#xyz#' = Evaluate("attributes.order_address#xyz#")>
		<cfset 'attributes.ship_date#xyz#' = Evaluate("attributes.order_date#xyz#")>
		<cfset 'attributes.ship_deliver#xyz#' = "">
		<cfset 'attributes.ship_number#xyz#' = "">
		<cfset 'attributes.ship_type#xyz#' = "">
		<cfset 'attributes.total_cost_value#xyz#' = 0>
		<cfset 'attributes.total_cost2_value#xyz#' = 0>
		<cfset 'attributes.total_price#xyz#' = "">
		<cfset 'attributes.ship_result_id#xyz#' = attributes.ship_result_id>
	</cfloop>
</cfif>
<cfif len(attributes.action_date)><cf_date tarih='attributes.action_date'></cfif>
<cfif isdefined("attributes.deliver_date") and len(attributes.deliver_date)><cf_date tarih='attributes.deliver_date'></cfif>
<cfset attributes.action_date_value = createdatetime(year(attributes.action_date),month(attributes.action_date),day(attributes.action_date),attributes.start_h,attributes.start_m,0)>
<cfif isdefined("attributes.deliver_date") and len(attributes.deliver_date)>
	<cfset attributes.deliver_date_value = createdatetime(year(attributes.deliver_date),month(attributes.deliver_date),day(attributes.deliver_date),attributes.deliver_h,attributes.deliver_m,0)>
<cfelse>
	<cfset attributes.deliver_date_value = "NULL">
</cfif>
<cfquery name="GET_SHIP_RESULT" datasource="#DSN2#">
	SELECT SHIP_RESULT_ID FROM SHIP_RESULT WHERE MAIN_SHIP_FIS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.main_ship_fis_no#">
</cfquery>
<cflock timeout="60">
	<cftransaction>
		<cfset paper_count = attributes.ship_fis_no_count+1>
		<cfset paper_full = '#attributes.main_ship_fis_no#-#paper_count#'>
		
		<!--- irsaliye iliskisi silinir --->
		<cfquery name="UPD_SHIP" datasource="#DSN2#">
			UPDATE SHIP SET IS_DISPATCH = 0 WHERE SHIP_ID IN(SELECT SHIP_ID FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID IN (<cfqueryparam value="#valuelist(get_ship_result.ship_result_id)#" cfsqltype="cf_sql_integer" list="true">))
		</cfquery>	

		<!--- siparis iliskisi silinir --->
		<cfquery name="GET_SHIP_RESULT_ROW" datasource="#DSN2#">
			SELECT SHIP_ID FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID IN (<cfqueryparam value="#valuelist(get_ship_result.ship_result_id)#" cfsqltype="cf_sql_integer" list="true">) AND SHIP_ID IS NOT NULL
		</cfquery>
		<cfif get_ship_result_row.recordcount>
			<cfquery name="UPD_ORDERS" datasource="#DSN2#">
				UPDATE #dsn3_alias#.ORDERS SET IS_DISPATCH = 0 WHERE ORDER_ID IN (SELECT ORDER_ID FROM #dsn3_alias#.ORDERS_SHIP WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND SHIP_ID IN (#valuelist(get_ship_result_row.ship_id)#))
			</cfquery>
		</cfif>
	
		<cfquery name="DEL_SHIP_RESULT_ROW" datasource="#DSN2#">
			DELETE FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID IN (<cfqueryparam value="#valuelist(get_ship_result.ship_result_id)#" cfsqltype="cf_sql_integer" list="true">)
		</cfquery>
		<cfquery name="DEL_SHIP_RESULT_ROW_COMPONENT" datasource="#DSN2#">
			DELETE FROM SHIP_RESULT_ROW_COMPONENT WHERE SHIP_RESULT_ID IN (<cfqueryparam value="#valuelist(get_ship_result.ship_result_id)#" cfsqltype="cf_sql_integer" list="true">)
		</cfquery>
		<cfquery name="DEL_SHIP_RESULT_PACKAGE" datasource="#DSN2#">
			DELETE FROM SHIP_RESULT_PACKAGE WHERE SHIP_ID IN (<cfqueryparam value="#valuelist(get_ship_result.ship_result_id)#" cfsqltype="cf_sql_integer" list="true">)
		</cfquery>
		
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfscript>
				form_row_kontrol = evaluate("attributes.row_kontrol#i#");
				form_company_id = evaluate("attributes.company_id#i#");
				form_partner_id = evaluate("attributes.partner_id#i#");
				form_consumer_id = evaluate("attributes.consumer_id#i#");
				form_related_row_kontrol = evaluate("attributes.related_row_kontrol#i#");
				form_row_count_list = evaluate("attributes.row_count_#i#_list");
				form_total_cost_value = evaluate("attributes.total_cost_value#i#");
				form_total_cost2_value = evaluate("attributes.total_cost2_value#i#");
				form_ship_id = evaluate("attributes.ship_id#i#");
				form_ship_number = evaluate("attributes.ship_number#i#");
				form_ship_date = evaluate("attributes.ship_date#i#");
				form_ship_deliver = evaluate("attributes.ship_deliver#i#");
				form_ship_type = evaluate("attributes.ship_type#i#");
				form_ship_adress = evaluate("attributes.ship_adress#i#");
				form_ship_id_list = evaluate("attributes.cari_#i#_ship_id_list");				
				form_ship_result_id = evaluate("attributes.ship_result_id#i#");
				form_ship_result_row_id = evaluate("attributes.ship_result_row_id#i#");
				if(attributes.is_order_terms eq 1)
				{
					form_order_id = Evaluate("attributes.order_id#i#");
					form_order_row_id = Evaluate("attributes.order_row_id#i#");
					form_order_wrk_row_id = Evaluate("attributes.order_wrk_row_id#i#");
					form_order_number = Evaluate("attributes.order_number#i#");
					form_order_row_amount = Evaluate("attributes.order_row_amount_#i#");
					form_ship_result_row_amount = Evaluate("attributes.ship_row_amount_#i#");
					form_ship_result_wrk_row_id = Evaluate("attributes.ship_result_wrk_row_id#i#");
					form_is_problem = Evaluate("attributes.is_problem#i#");
				}
			</cfscript>	
			<cfif len(form_ship_date)><cf_date tarih='form_ship_date'></cfif>		
			<!--- Eger satır silinmemis ve iliskili irsaliye degilse --->
				<cfif (form_row_kontrol eq 1) and not len(form_related_row_kontrol)>
					<cfset paper_full_last = '#attributes.main_ship_fis_no#-#paper_count#'>
					<!--- yeni kayit ise --->
					<cfif not len(form_ship_result_id)>
						<cfquery name="ADD_SHIP_RESULT" datasource="#DSN2#" result="MAX_ID">
							INSERT INTO
								SHIP_RESULT
							(
								COMPANY_ID,
								PARTNER_ID,
								CONSUMER_ID,
								SHIP_METHOD_TYPE,
								SERVICE_COMPANY_ID,
								SERVICE_MEMBER_ID,
								ASSETP_ID,
								DELIVER_EMP,
								PLATE,
								NOTE,
								SHIP_FIS_NO,
								MAIN_SHIP_FIS_NO,
								DELIVER_PAPER_NO,
								REFERENCE_NO,
								OUT_DATE,
								DELIVERY_DATE,
								DELIVER_POS,
								DEPARTMENT_ID,
								SHIP_STAGE,
								COST_VALUE,
								COST_VALUE_MONEY,
								COST_VALUE2,
								COST_VALUE2_MONEY,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE
							)
							VALUES
							(
								<cfif len(form_company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_company_id#"><cfelse>NULL</cfif>,
								<cfif len(form_partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_partner_id#"><cfelse>NULL</cfif>,
								<cfif len(form_consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_consumer_id#"><cfelse>NULL</cfif>,
								<cfif len(attributes.ship_method_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#"><cfelse>NULL</cfif>,
								<cfif len(attributes.transport_comp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.transport_comp_id#"><cfelse>NULL</cfif>,
								<cfif len(attributes.transport_deliver_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.transport_deliver_id#"><cfelse>NULL</cfif>,
								<cfif len(attributes.assetp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#"><cfelse>NULL</cfif>,
								<cfif len(attributes.vehicle_emp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.vehicle_emp_id#"><cfelse>NULL</cfif>,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.plate#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.note#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#paper_full_last#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.main_ship_fis_no#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.transport_paper_no#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.reference_no#">,
								<cfif len(attributes.action_date_value)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date_value#"><cfelse>NULL</cfif>,
								<cfif len(attributes.deliver_date_value)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.deliver_date_value#"><cfelse>NULL</cfif>,
								<cfif len(attributes.deliver_id2)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.deliver_id2#"><cfelse>NULL</cfif>,
								<cfif len(attributes.department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"><cfelse>NULL</cfif>,
								<cfif Len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form_total_cost_value#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form_total_cost2_value#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
								#now()#
							)
						</cfquery>
						<cfset paper_count = paper_count+1>
						<cfset temp_ship_result_id = MAX_ID.IDENTITYCOL>
					<!--- eski kayit ise --->
					<cfelse>
						<cfquery name="UPD_SHIP_RESULT" datasource="#DSN2#">
							UPDATE
								SHIP_RESULT
							SET
								<cfif attributes.is_order_terms eq 1>
									EQUIPMENT_PLANNING_ID = <cfif Len(attributes.equipment_planning)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.equipment_planning#"><cfelse>NULL</cfif>,
								</cfif>
								COMPANY_ID = <cfif len(form_company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_company_id#"><cfelse>NULL</cfif>,
								PARTNER_ID = <cfif len(form_partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_partner_id#"><cfelse>NULL</cfif>,
								CONSUMER_ID = <cfif len(form_consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_consumer_id#"><cfelse>NULL</cfif>,
								SHIP_METHOD_TYPE = <cfif len(attributes.ship_method_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#"><cfelse>NULL</cfif>,
								SERVICE_COMPANY_ID = <cfif len(attributes.transport_comp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.transport_comp_id#"><cfelse>NULL</cfif>,
								SERVICE_MEMBER_ID = <cfif len(attributes.transport_deliver_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.transport_deliver_id#"><cfelse>NULL</cfif>,
								ASSETP_ID = <cfif len(attributes.assetp_id) and len(attributes.assetp_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#"><cfelse>NULL</cfif>,
								DELIVER_EMP = <cfif len(attributes.vehicle_emp_id) and len(attributes.vehicle_emp_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.vehicle_emp_id#"><cfelse>NULL</cfif>,
								PLATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.plate#">,
								NOTE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.note#">,
								REFERENCE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.reference_no#">,
								OUT_DATE = <cfif len(attributes.action_date_value)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date_value#"><cfelse>NULL</cfif>,
								DELIVERY_DATE = <cfif len(attributes.deliver_date_value)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.deliver_date_value#"><cfelse>NULL</cfif>,
								DELIVER_POS = <cfif len(attributes.deliver_id2) and len(attributes.deliver_name2)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.deliver_id2#"><cfelse>NULL</cfif>,
								DEPARTMENT_ID = <cfif len(attributes.department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"><cfelse>NULL</cfif>,
								LOCATION_ID = <cfif Len(attributes.location_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#"><cfelse>NULL</cfif>,
								SHIP_STAGE = <cfif Len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelseif isDefined('attributes.old_process_stage')><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.OLD_PROCESS_STAGE#"><cfelse>NULL</cfif>,
								COST_VALUE = <cfif Len(form_total_cost_value)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_total_cost_value#"><cfelse>NULL</cfif>,
								COST_VALUE_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
								COST_VALUE2 = <cfif Len(form_total_cost2_value)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_total_cost2_value#"><cfelse>NULL</cfif>,
								COST_VALUE2_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,
								UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
								UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
								UPDATE_DATE = #now()#
							WHERE
								SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form_ship_result_id#">					
						</cfquery>
						<cfset temp_ship_result_id = form_ship_result_id>
					</cfif>
					
					<cfif Len(form_ship_id)>
						<!--- Irsaliyelere sevk bilgisi update ediliyor --->
						<cfquery name="UPD_SHIP" datasource="#DSN2#">
							UPDATE SHIP SET IS_DISPATCH = 1 WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form_ship_id#">
						</cfquery>
					</cfif>
					<cfif (attributes.is_order_terms eq 1 and Len(form_order_row_id)) or (attributes.is_order_terms neq 1)>
						<cfquery name="ADD_SHIP_RESULT_ROW" datasource="#DSN2#">
							INSERT INTO
								SHIP_RESULT_ROW
							(
								SHIP_RESULT_ID,
								<cfif attributes.is_order_terms eq 1>
									IS_PROBLEM,
									ORDER_ID,
									ORDER_ROW_ID,
									WRK_ROW_ID,
									WRK_ROW_RELATION_ID,
									ORDER_NUMBER,
									ORDER_ROW_AMOUNT,
									SHIP_RESULT_ROW_AMOUNT,
								</cfif>
								SHIP_ID,
								SHIP_NUMBER,
								SHIP_DATE,
								DELIVER_COMP,
								DELIVER_TYPE,
								DELIVER_ADRESS
							)
							VALUES
							(
								<cfqueryparam cfsqltype="cf_sql_integer" value="#temp_ship_result_id#">,
								<cfif attributes.is_order_terms eq 1>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#form_is_problem#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#form_order_id#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#form_order_row_id#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_result_wrk_row_id#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_order_wrk_row_id#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_order_number#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#form_order_row_amount#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#filterNum(form_ship_result_row_amount)#">,
								</cfif>
								<cfif len(form_ship_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_ship_id#"><cfelse>NULL</cfif>,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_number#">,
								<cfif len(form_ship_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#form_ship_date#"><cfelse>NULL</cfif>,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_deliver#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_type#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_adress#">
							)
						</cfquery>
						<cfif attributes.is_order_terms eq 1>
							<cfquery name="Get_Max_Result_Row" datasource="#dsn2#">
								SELECT MAX(SHIP_RESULT_ROW_ID) MAX_RESULT_ROW FROM SHIP_RESULT_ROW
							</cfquery>
							<cfquery name="Get_Component_Info" datasource="#dsn2#">
								SELECT
									SW.*,
									(SELECT PRODUCT_ID FROM #dsn1_alias#.STOCKS WHERE STOCK_ID = SW.STOCK_ID) SPRODUCT_ID,
									OW.ORDER_ROW_ID,
									OW.PRODUCT_ID OPRODUCT_ID,
									OW.WRK_ROW_ID
								FROM
									#dsn3_alias#.SPECTS_ROW SW,
									#dsn3_alias#.ORDER_ROW OW
								WHERE
									OW.WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form_order_wrk_row_id#"> AND
									SW.SPECT_ID = OW.SPECT_VAR_ID AND 
									SW.IS_PROPERTY IN (0,4) AND 
									SW.STOCK_ID IS NOT NULL
							</cfquery>
							<cfif Get_Component_Info.RecordCount>
							<cfloop query="Get_Component_Info">
								<cfquery name="add_ship_result_row_component" datasource="#dsn2#">
									INSERT INTO
										SHIP_RESULT_ROW_COMPONENT
									(
										SHIP_RESULT_ROW_ID,
										SHIP_RESULT_ID,
										COMPONENT_PRODUCT_ID,
										COMPONENT_PRODUCT_NAME,
										COMPONENT_STOCK_ID,
										COMPONENT_SPECT_ID,
										COMPONENT_SPECT_ROW_ID,
										COMPONENT_AMOUNT,
										ORDER_ROW_ID,
										ORDER_ROW_PRODUCT_ID,
										SHIP_RESULT_ROW_AMOUNT,
										WRK_ROW_RELATION_ID
									)
									VALUES
									(
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Max_Result_Row.Max_Result_Row#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#temp_ship_result_id#">,
										<cfif Len(Get_Component_Info.SProduct_Id)><cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Component_Info.SProduct_Id#"><cfelse>NULL</cfif>,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#Get_Component_Info.Product_Name#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Component_Info.Stock_Id#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Component_Info.Spect_Id#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Component_Info.Spect_Row_Id#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Component_Info.Amount_Value#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Component_Info.Order_Row_Id#">,
										<cfif Len(Get_Component_Info.OProduct_Id)><cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Component_Info.OProduct_Id#"><cfelse>NULL</cfif>,
										<cfif isdefined("attributes.spect_to_ship_amount_#Get_Component_Info.Wrk_Row_Id#_#Get_Component_Info.Spect_Row_Id#")>#filterNum(Evaluate("attributes.spect_to_ship_amount_#Get_Component_Info.Wrk_Row_Id#_#Get_Component_Info.Spect_Row_Id#"))#<cfelse>0</cfif>,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#Get_Component_Info.Wrk_Row_Id#">
									)
								</cfquery>
							</cfloop>
							</cfif>
						</cfif>
					</cfif>
					
					<cfif len(form_row_count_list)>
						<cfloop from="1" to="#listlen(form_row_count_list)#" index="ii">
							<cfset temp_row_count = listgetat(form_row_count_list,ii)>
							<cfscript>
								form_ship_id = evaluate("attributes.ship_id#temp_row_count#");
								form_ship_number = evaluate("attributes.ship_number#temp_row_count#");
								form_ship_date = evaluate("attributes.ship_date#temp_row_count#");
								form_ship_deliver = evaluate("attributes.ship_deliver#temp_row_count#");
								form_ship_type = evaluate("attributes.ship_type#temp_row_count#");
								form_ship_adress = evaluate("attributes.ship_adress#temp_row_count#");				
							</cfscript>
							<cfif len(form_ship_date)><cf_date tarih='form_ship_date'></cfif>

							<!--- Irsaliyelere sevk bilgisi update ediliyor --->
							<cfquery name="UPD_SHIP" datasource="#DSN2#">
								UPDATE SHIP SET IS_DISPATCH = 1 WHERE SHIP_ID = #form_ship_id#
							</cfquery>
							<cfquery name="ADD_SHIP_RESULT_ROW" datasource="#DSN2#">
								INSERT INTO
									SHIP_RESULT_ROW
								(
									SHIP_RESULT_ID,
									SHIP_ID,
									SHIP_NUMBER,						
									SHIP_DATE,
									DELIVER_COMP,
									DELIVER_TYPE,
									DELIVER_ADRESS
								)
								VALUES

								(
									<cfqueryparam cfsqltype="cf_sql_integer" value="#temp_ship_result_id#">,
									<cfif len(form_ship_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_ship_id#"><cfelse>NULL</cfif>,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_number#">,
									<cfif len(form_ship_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#form_ship_date#"><cfelse>NULL</cfif>,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_deliver#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_type#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_adress#">
								)
							</cfquery>	
						</cfloop>
					</cfif>
					<cfif len(form_ship_id_list)>
						<cfloop from="1" to="#listlen(form_ship_id_list)#" index="iii">
							<cfset temp_row_count_other = listgetat(form_ship_id_list,iii)>
								<cfif evaluate("attributes.row_kontrol_other#temp_row_count_other#")>
									<cfscript>
										form_quantity = evaluate("attributes.quantity#temp_row_count_other#");
										form_package_type = evaluate("attributes.package_type#temp_row_count_other#");
										form_ship_ebat = evaluate("attributes.ship_ebat#temp_row_count_other#");
										form_ship_agirlik = evaluate("attributes.ship_agirlik#temp_row_count_other#");
										form_total_price = evaluate("attributes.total_price#temp_row_count_other#");
										form_other_money = evaluate("attributes.other_money#temp_row_count_other#");
										form_ship_barcod = evaluate("attributes.ship_barcod#temp_row_count_other#");
										form_ship_barcod = evaluate("attributes.ship_barcod#temp_row_count_other#");
										form_pack_emp_id = evaluate("attributes.pack_emp_id#temp_row_count_other#");
										form_pack_emp_name = evaluate("attributes.pack_emp_name#temp_row_count_other#");
										
										form_ship_result_package_id = evaluate("attributes.ship_result_package_id#temp_row_count_other#");
									</cfscript>
									<cfset deger_form_package_type = listfirst(form_package_type,',')>
									<cfquery name="ADD_SHIP_RESULT_PACKAGE" datasource="#DSN2#">
										INSERT INTO
											SHIP_RESULT_PACKAGE
										(
											SHIP_ID,
											PACKAGE_PIECE,
											PACKAGE_TYPE,
											PACKAGE_DIMENTION,
											PACKAGE_WEIGHT,
											TOTAL_PRICE,
											OTHER_MONEY,
											BARCODE,
											PACK_EMP_ID
										)
										VALUES
										(
											<cfqueryparam cfsqltype="cf_sql_integer" value="#temp_ship_result_id#">,
											<cfif len(form_quantity)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_quantity#"><cfelse>NULL</cfif>,
											<cfif len(deger_form_package_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#deger_form_package_type#"><cfelse>NULL</cfif>,
											<cfif len(form_ship_ebat)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_ebat#"><cfelse>NULL</cfif>,
											<cfif len(form_ship_agirlik)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_ship_agirlik#"><cfelse>NULL</cfif>,
											<cfif len(form_total_price)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_total_price#"><cfelse>NULL</cfif>,
											<cfif len(form_other_money) and len(form_total_price)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form_other_money#"><cfelse>NULL</cfif>,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_barcod#">,
											<cfif len(form_pack_emp_id) and len(form_pack_emp_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_pack_emp_id#"><cfelse>NULL</cfif>
										)
									</cfquery>
								</cfif>
						</cfloop>
					</cfif>
				<cfelseif (form_row_kontrol eq 0 and attributes.is_order_terms neq 1)>
					<cfquery name="ADD_SHIP_RESULT_PACKAGE" datasource="#DSN2#">
						DELETE FROM SHIP_RESULT WHERE SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form_ship_result_id#">					
					</cfquery>
				</cfif>
		</cfloop>
		<!--- Irsaliyeye ait siparislerin sevk bilgisi update ediliyor  --->
		<cfquery name="GET_SHIP_RESULT_ROW" datasource="#DSN2#">
			SELECT SHIP_ID FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID IN(SELECT SR.SHIP_RESULT_ID FROM SHIP_RESULT SR WHERE SR.MAIN_SHIP_FIS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.main_ship_fis_no#">) AND SHIP_ID IS NOT NULL
		</cfquery>
		<cfif get_ship_result_row.recordcount>
			<cfquery name="UPD_ORDERS" datasource="#DSN2#">
				UPDATE #dsn3_alias#.ORDERS SET IS_DISPATCH = 1 WHERE ORDER_ID IN (SELECT ORDER_ID FROM #dsn3_alias#.ORDERS_SHIP WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND SHIP_ID IN (<cfqueryparam value="#valuelist(get_ship_result_row.ship_id)#" cfsqltype="cf_sql_integer" list="true">))
			</cfquery>
		</cfif>		
	</cftransaction>
</cflock>
<cfif Len(attributes.process_stage)>
	<cfset pro_stage= attributes.process_stage>
<cfelse>
	<cfset pro_stage= attributes.OLD_PROCESS_STAGE>
</cfif>
<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#pro_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#'
	action_table='SHIP_RESULT'
	action_column='SHIP_RESULT_ID'
	action_id='#form_ship_result_id#'
	>

<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_multi_packetship&event=upd&main_ship_fis_no=#attributes.main_ship_fis_no#" addtoken="no">
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
