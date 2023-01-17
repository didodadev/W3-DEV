<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cfif len(attributes.action_date)><cf_date tarih='attributes.action_date'></cfif>
<cfif len(attributes.deliver_date)><cf_date tarih='attributes.deliver_date'></cfif>
<cfif isdefined("attributes.warehouse_entry_date") and len(attributes.warehouse_entry_date)><cf_date tarih='attributes.warehouse_entry_date'></cfif>
<cfset attributes.action_date_value = createdatetime(year(attributes.action_date),month(attributes.action_date),day(attributes.action_date),attributes.start_h,attributes.start_m,0)>
<cfif len(attributes.deliver_date)>
	<cfset attributes.deliver_date_value = createdatetime(year(attributes.deliver_date),month(attributes.deliver_date),day(attributes.deliver_date),attributes.deliver_h,attributes.deliver_m,0)>
<cfelse>
	<cfset attributes.deliver_date_value = "NULL">
</cfif>
<cfif isdefined("attributes.warehouse_entry_date") and len(attributes.warehouse_entry_date)>
	<cfset attributes.warehouse_entry_date_value = createdatetime(year(attributes.warehouse_entry_date),month(attributes.warehouse_entry_date),day(attributes.warehouse_entry_date),attributes.warehouse_entry_h,attributes.warehouse_entry_m,0)>
<cfelse>
	<cfset attributes.warehouse_entry_date_value = "NULL">
</cfif>
<cflock timeout="60">
	<cftransaction>
		<cfquery name="UPD_SHIP_RESULT" datasource="#DSN2#">
			UPDATE
				SHIP_RESULT
			SET
			  <cfif len(attributes.company_id)>
				COMPANY_ID = #attributes.company_id#,
				PARTNER_ID = <cfif len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
				CONSUMER_ID = NULL,
			  <cfelseif len(attributes.consumer_id)>
				COMPANY_ID = NULL,
				PARTNER_ID = NULL,
				CONSUMER_ID = #attributes.consumer_id#,
			  <cfelse>
				COMPANY_ID = NULL,
				PARTNER_ID = NULL,
				CONSUMER_ID = NULL,
			  </cfif>
				SHIP_METHOD_TYPE = <cfif isdefined("attributes.ship_method_id") and len(attributes.ship_method_id)>#attributes.ship_method_id#<cfelse>NULL</cfif>,
				SERVICE_COMPANY_ID = <cfif isdefined("attributes.transport_comp_id") and len(attributes.transport_comp_id)>#attributes.transport_comp_id#<cfelse>NULL</cfif>,
				SERVICE_MEMBER_ID = <cfif isdefined("attributes.transport_deliver_id") and len(attributes.transport_deliver_id)>#attributes.transport_deliver_id#<cfelse>NULL</cfif>,
				SERVICE_CONSUMER_ID = <cfif isdefined("attributes.transport_cons_id") and len(attributes.transport_cons_id)>#attributes.transport_cons_id#<cfelse>NULL</cfif>,
				SERVICE_CONSUMER_MEMBER_ID = <cfif isdefined("attributes.transport_cons_deliver_id") and len(attributes.transport_cons_deliver_id)>#attributes.transport_cons_deliver_id#<cfelse>NULL</cfif>,
				ASSETP_ID = <cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)>#attributes.assetp_id#<cfelse>NULL</cfif>,
				DELIVER_EMP = <cfif isdefined("attributes.vehicle_emp_id") and len(attributes.vehicle_emp_id)>#attributes.vehicle_emp_id#<cfelse>NULL</cfif>,
				ASSETP = <cfif not isdefined("attributes.assetp_id") and len(attributes.assetp_name)>'#attributes.assetp_name#'<cfelse>NULL</cfif>,
				DELIVER_EMP_NAME = <cfif not isdefined("attributes.vehicle_emp_id") and len(attributes.vehicle_emp_name)>'#attributes.vehicle_emp_name#'<cfelse>NULL</cfif>,
				PLATE = <cfif isdefined("attributes.plate") and len(attributes.plate)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.plate#"><cfelse>NULL</cfif>,
				PLATE2 = <cfif isdefined("attributes.plate2") and len(attributes.plate2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.plate2#"><cfelse>NULL</cfif>,
				NOTE = <cfif isdefined("attributes.note") and len(attributes.note)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.note#"><cfelse>NULL</cfif>,
				SHIP_FIS_NO = <cfif isdefined("attributes.transport_no1") and len(attributes.transport_no1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.transport_no1#"><cfelse>NULL</cfif>,
				DELIVER_PAPER_NO = <cfif isdefined("attributes.transport_paper_no") and len(attributes.transport_paper_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.transport_paper_no#"><cfelse>NULL</cfif>,
				REFERENCE_NO = <cfif isdefined("attributes.reference_no") and len(attributes.reference_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.reference_no#"><cfelse>NULL</cfif>,
				OUT_DATE = <cfif isdefined("attributes.action_date_value") and len(attributes.action_date_value)>#attributes.action_date_value#<cfelse>NULL</cfif>,
				DELIVERY_DATE = <cfif isdefined("attributes.deliver_date_value") and len(attributes.deliver_date_value)>#attributes.deliver_date_value#<cfelse>NULL</cfif>,
				DELIVER_POS = <cfif isdefined("attributes.deliver_id2") and len(attributes.deliver_id2)>#attributes.deliver_id2#<cfelse>NULL</cfif>,
				DEPARTMENT_ID = <cfif isdefined("attributes.department_id") and len(attributes.department_id)>#attributes.department_id#<cfelse>NULL</cfif>,
				SHIP_STAGE = <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
				COST_VALUE = <cfif isdefined("attributes.total_cost_value")>#attributes.total_cost_value#<cfelse>NULL</cfif>,
				COST_VALUE_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
				COST_VALUE2 = <cfif isdefined("attributes.total_cost2_value") and len(attributes.total_cost2_value)>#attributes.total_cost2_value#<cfelse>NULL</cfif>,
				COST_VALUE2_MONEY = <cfif isdefined("session.ep.money2") and len(session.ep.money2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"><cfelse>NULL</cfif>,
				SENDING_ADDRESS = <cfif isdefined("attributes.sending_address") and len(attributes.sending_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.sending_address)#"><cfelse>NULL</cfif>,
				SENDING_POSTCODE = <cfif isdefined("attributes.sending_postcode") and len(attributes.sending_postcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.sending_postcode)#"><cfelse>NULL</cfif>,
				SENDING_SEMT = <cfif isdefined("attributes.sending_semt") and len(attributes.sending_semt)><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.sending_semt)#"><cfelse>NULL</cfif>,
				SENDING_COUNTY_ID = <cfif isdefined("attributes.sending_county_id") and len(attributes.sending_county_id)>#attributes.sending_county_id#<cfelse>NULL</cfif>,
				SENDING_CITY_ID = <cfif isdefined("attributes.sending_city_id") and len(attributes.sending_city_id)>#attributes.sending_city_id#<cfelse>NULL</cfif>,
				SENDING_COUNTRY_ID = <cfif isdefined("attributes.sending_country_id") and len(attributes.sending_country_id)>#attributes.sending_country_id#<cfelse>NULL</cfif>,
				UPDATE_EMP = <cfif isdefined("session.ep.userid") and len(session.ep.userid)>#session.ep.userid#<cfelse>NULL</cfif>,
				UPDATE_IP = <cfif isdefined("cgi.remote_addr") and len(cgi.remote_addr)><cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"><cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
                INSURANCE_COMP_ID = <cfif isdefined("attributes.insurance_comp_id") and len(attributes.insurance_comp_id)>#attributes.insurance_comp_id#<cfelse>NULL</cfif>,
                INSURANCE_COMP_PART = <cfif isdefined("attributes.insurance_comp_partner_id") and len(attributes.insurance_comp_partner_id)>#attributes.insurance_comp_partner_id#<cfelse>NULL</cfif>,
                DUTY_COMP_ID = <cfif isdefined("attributes.duty_comp_id") and len(attributes.duty_comp_id)>#attributes.duty_comp_id#<cfelse>NULL</cfif>,
                DUTY_COMP_PARTNER = <cfif isdefined("attributes.duty_comp_partner_id") and len(attributes.duty_comp_partner_id)>#attributes.duty_comp_partner_id#<cfelse>NULL</cfif>,
                WAREHOUSE_ENTRY_DATE = <cfif isdefined("attributes.warehouse_entry_date_value") and len(attributes.warehouse_entry_date_value)>#attributes.warehouse_entry_date_value#<cfelse>NULL</cfif>,
                PROJECT_ID=<cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
                OTHER_MONEY_VALUE = <cfif isdefined("attributes.ship_price") and len(attributes.ship_price)>#attributes.ship_price#<cfelse>NULL</cfif>,
				OTHER_MONEY = <cfif isdefined("attributes.ship_price_name") and len(attributes.ship_price_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_price_name#"><cfelse>NULL</cfif>,
				DELIVER_EMP_TC = <cfif isDefined("attributes.vehicle_emp_tc") and len(attributes.vehicle_emp_tc)><cfqueryparam cfsqltype='CF_SQL_nvarchar' value='#attributes.vehicle_emp_tc#'><cfelse>NULL</cfif>
			WHERE
				SHIP_RESULT_ID = #attributes.ship_result_id#
		</cfquery>
		
		<!--- Eger irsaliye ise --->
		<cfif attributes.is_type neq 2>
			<!--- siparis iliskisi silinir --->
			<cfquery name="GET_SHIP_RESULT_ROW" datasource="#DSN2#">
				SELECT SHIP_ID FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID = #attributes.ship_result_id# AND SHIP_ID IS NOT NULL
			</cfquery>
			<cfif get_ship_result_row.recordcount>
				<cfquery name="UPD_ORDERS" datasource="#DSN2#">
					UPDATE #dsn3_alias#.ORDERS SET IS_DISPATCH = 0 WHERE ORDER_ID IN (SELECT ORDER_ID FROM #dsn3_alias#.ORDERS_SHIP WHERE PERIOD_ID = #session.ep.period_id# AND SHIP_ID IN (#valuelist(get_ship_result_row.ship_id)#))
				</cfquery>
			</cfif>
			<!--- irsaliye iliskisi silinir --->
			<cfquery name="UPD_SHIP" datasource="#DSN2#">
				UPDATE 
					SHIP
				SET
					IS_DISPATCH = 0
				WHERE
					SHIP_ID IN(SELECT SHIP_ID FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID = #attributes.ship_result_id#) 
			</cfquery>
		<cfelse>
			<cfquery name="UPD_ORDER" datasource="#DSN2#">
				UPDATE 
					#dsn3_alias#.ORDERS
				SET
					IS_DISPATCH = 0
				WHERE
					ORDER_ID IN(SELECT SHIP_ID FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID = #attributes.ship_result_id#) 
			</cfquery>
		</cfif>
		
		<!--- kapattim
		
		<cfquery name="DEL_ROW" datasource="#DSN2#">
			DELETE FROM
				SHIP_RESULT_ROW
			WHERE
				SHIP_RESULT_ID = #attributes.ship_result_id#
		</cfquery> --->
	
		<cfif len(attributes.record_num) and attributes.record_num neq 0>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				
					<cfscript>
						form_ship_id = evaluate("attributes.ship_id#i#");
						form_ship_number = evaluate("attributes.ship_number#i#");
						form_ship_date = evaluate("attributes.ship_date#i#");
						form_ship_deliver = evaluate("attributes.ship_deliver#i#");
						form_ship_type = evaluate("attributes.ship_type#i#");
						form_ship_adress = evaluate("attributes.ship_adress#i#");
						form_ship_result_row_id = evaluate("attributes.ship_result_row_id#i#");
					</cfscript>
					<cfif len(form_ship_date)><cf_date tarih='form_ship_date'></cfif>
					<cfif attributes.is_type neq 2 and isDefined('form_ship_id')>
						<!--- Irsaliyelere sevk bilgisi update ediliyor --->
						<cfquery name="UPD_SHIP" datasource="#DSN2#">
							UPDATE 
								SHIP
							SET
								IS_DISPATCH = 1
							WHERE
								SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form_ship_id#">
						</cfquery>
					<cfelse>
						<!--- Siparislere sevk bilgisi update ediliyor --->
						<cfquery name="UPD_ORDERS" datasource="#DSN2#">
							UPDATE 
								#dsn3_alias#.ORDERS
							SET
								IS_DISPATCH = 1
							WHERE
								ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form_ship_id#">
						</cfquery>	
					</cfif>
					
					<cfif evaluate("attributes.row_kontrol#i#") and not len(form_ship_result_row_id)>
						<!--- Ekleme --->
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
								#attributes.ship_result_id#,
								<cfif len(form_ship_id)>#form_ship_id#<cfelse>NULL</cfif>,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_number#">,
								<cfif len(form_ship_date)>#form_ship_date#<cfelse>NULL</cfif>,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_deliver#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_type#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_adress#">
							)
						</cfquery>
					<cfelseif evaluate("attributes.row_kontrol#i#") and len(form_ship_result_row_id)>
						<!--- Guncelleme --->
						<cfquery name="UPD_SHIP_RESULT_ROW" datasource="#DSN2#">
							UPDATE 
								SHIP_RESULT_ROW
							SET
								SHIP_RESULT_ID = #attributes.ship_result_id#,
								SHIP_ID = <cfif len(form_ship_id)>#form_ship_id#<cfelse>NULL</cfif>,
								SHIP_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_number#">,
								SHIP_DATE = <cfif len(form_ship_date)>#form_ship_date#<cfelse>NULL</cfif>,
								DELIVER_COMP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_deliver#">,
								DELIVER_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_type#">,
								DELIVER_ADRESS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_adress#">
							WHERE
								SHIP_RESULT_ROW_ID = #form_ship_result_row_id#
						</cfquery>
					<cfelseif evaluate("attributes.row_kontrol#i#") eq 0 and len(form_ship_result_row_id)>
						<!--- Silme --->
						<cfquery name="DEL_SHIP_RESULT_ROW" datasource="#DSN2#">
							DELETE FROM SHIP_RESULT_PACKAGE_PRODUCT WHERE SHIP_ID = (SELECT SHIP_ID FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ROW_ID = #form_ship_result_row_id#)
							DELETE FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ROW_ID = #form_ship_result_row_id#
						</cfquery>
					</cfif>
					
					<!--- <cfquery name="ADD_SHIP_ROW" datasource="#DSN2#">
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
							#attributes.ship_result_id#,
							<cfif len(form_ship_id)>#form_ship_id#<cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_number#">,
							<cfif len(form_ship_date)>#form_ship_date#<cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_deliver#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_type#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_adress#">
						)
					</cfquery> --->
				
			</cfloop>
			
			
			<cfif attributes.is_type neq 2>
				<!--- Irsaliyeye ait siparislerin sevk bilgisi update ediliyor  --->
				<cfquery name="GET_SHIP_RESULT_ROW" datasource="#DSN2#">
					SELECT SHIP_ID FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID = #attributes.ship_result_id# AND SHIP_ID IS NOT NULL
				</cfquery>
				<cfif get_ship_result_row.recordcount>
					<cfquery name="UPD_ORDERS" datasource="#DSN2#">
						UPDATE #dsn3_alias#.ORDERS SET IS_DISPATCH = 1 WHERE ORDER_ID IN (SELECT ORDER_ID FROM #dsn3_alias#.ORDERS_SHIP WHERE PERIOD_ID = #session.ep.period_id# AND SHIP_ID IN (#valuelist(get_ship_result_row.ship_id)#))
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
		<cfif isdefined("attributes.record_num_other") and len(attributes.record_num_other)>
			<cfloop from="1" to="#attributes.record_num_other#" index="i">
				<cfscript>
					form_ship_result_package_id = evaluate("attributes.ship_result_package_id#i#");
					form_quantity = evaluate("attributes.quantity#i#");
					form_package_type = evaluate("attributes.package_type#i#");
					form_ship_ebat = evaluate("attributes.ship_ebat#i#");
					form_ship_agirlik = evaluate("attributes.ship_agirlik#i#");
					form_total_price = evaluate("attributes.total_price#i#");
					form_other_money = evaluate("attributes.other_money#i#");
					form_ship_barcod = evaluate("attributes.ship_barcod#i#");
					form_pack_emp_id = evaluate("attributes.pack_emp_id#i#");
					form_pack_emp_name = evaluate("attributes.pack_emp_name#i#");												
				</cfscript>
				<cfset form_package_type = listfirst(form_package_type,',')>
				<cfif evaluate("attributes.row_kontrol_other#i#") and not len(form_ship_result_package_id)>
					<!--- Ekleme --->
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
							#attributes.ship_result_id#,
							<cfif len(form_quantity)>#form_quantity#<cfelse>NULL</cfif>,
							<cfif len(form_package_type)>#form_package_type#<cfelse>NULL</cfif>,
							<cfif len(form_ship_ebat)>'#form_ship_ebat#'<cfelse>NULL</cfif>,
							<cfif len(form_ship_agirlik)>#form_ship_agirlik#<cfelse>NULL</cfif>,
							<cfif len(form_total_price)>#form_total_price#<cfelse>NULL</cfif>,
							<cfif len(form_other_money) and len(form_total_price)>'#form_other_money#'<cfelse>NULL</cfif>,
							<cfif len(form_ship_barcod)>'#form_ship_barcod#'<cfelse>NULL</cfif>,
							<cfif len(form_pack_emp_id) and len(form_pack_emp_name)>#form_pack_emp_id#<cfelse>NULL</cfif>
						)
					</cfquery>
				<cfelseif evaluate("attributes.row_kontrol_other#i#") and len(form_ship_result_package_id)>
					<!--- Guncelleme --->
					<cfquery name="UPD_SHIP_RESULT_PACKAGE" datasource="#DSN2#">
						UPDATE 
							SHIP_RESULT_PACKAGE
						SET
							SHIP_ID = #attributes.ship_result_id#,
							PACKAGE_PIECE = <cfif len(form_quantity)>#form_quantity#<cfelse>NULL</cfif>,
							PACKAGE_TYPE = <cfif len(form_package_type)>#form_package_type#<cfelse>NULL</cfif>,
							PACKAGE_DIMENTION = <cfif len(form_ship_ebat)>'#form_ship_ebat#'<cfelse>NULL</cfif>,
							PACKAGE_WEIGHT = <cfif len(form_ship_agirlik)>#form_ship_agirlik#<cfelse>NULL</cfif>,
							TOTAL_PRICE = <cfif len(form_total_price)>#form_total_price#<cfelse>NULL</cfif>,
							OTHER_MONEY = <cfif len(form_other_money) and len(form_total_price)>'#form_other_money#'<cfelse>NULL</cfif>,
							BARCODE = <cfif len(form_ship_barcod)>'#form_ship_barcod#'<cfelse>NULL</cfif>,
							PACK_EMP_ID = <cfif len(form_pack_emp_id) and len(form_pack_emp_name)>#form_pack_emp_id#<cfelse>NULL</cfif>
						WHERE
							SHIP_RESULT_PACKAGE_ID = #form_ship_result_package_id#
					</cfquery>
				<cfelseif evaluate("attributes.row_kontrol_other#i#") eq 0 and len(form_ship_result_package_id)>
					<!--- Silme --->
					<cfquery name="DEL_SHIP_RESULT_PACKAGE" datasource="#DSN2#">
						DELETE FROM SHIP_RESULT_PACKAGE WHERE SHIP_RESULT_PACKAGE_ID = #form_ship_result_package_id#
						DELETE FROM SHIP_RESULT_PACKAGE_PRODUCT WHERE SHIP_RESULT_PACKAGE_ID = #form_ship_result_package_id#
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<cf_workcube_process 
		is_upd='1' 
		old_process_line='#attributes.old_process_line#'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_table='SHIP_RESULT'
		action_column='SHIP_RESULT_ID'
		action_id='#attributes.ship_result_id#'
		action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_packetship&event=upd&ship_result_id=#attributes.ship_result_id#'
		warning_description = 'Sevkiyat No : #attributes.transport_no1#'>
<cfset attributes.actionId = attributes.ship_result_id >
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_packetship&event=upd&ship_result_id=#attributes.ship_result_id#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

