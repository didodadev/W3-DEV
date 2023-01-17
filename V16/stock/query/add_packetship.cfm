

<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="GET_PAPER_NUMBER" datasource="#DSN3#" maxrows="1">
	SELECT
		SHIP_FIS_NO,
		SHIP_FIS_NUMBER 
	FROM
		GENERAL_PAPERS
	WHERE
		CAMPAIGN_NO IS NOT NULL OR PROMOTION_NO IS NOT NULL OR CATALOG_NO IS NOT NULL 
</cfquery>
<cfif (not len(get_paper_number.ship_fis_no)) or (not len(get_paper_number.ship_fis_number))>
	<script type="text/javascript">
		alert("<cf_get_lang no ='535.Lütfen Tanımlardan Belge Numaralarını Tanımlayınız'> !");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
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
		<cfquery name="get_gen_paper" datasource="#DSN2#">
			SELECT
				SHIP_FIS_NO,
				SHIP_FIS_NUMBER    
			FROM
				#dsn3_alias#.GENERAL_PAPERS GENERAL_PAPERS
			WHERE 
				PAPER_TYPE IS NULL 
		</cfquery>
		<cfset paper_code = evaluate('get_gen_paper.ship_fis_no')>
		<cfset paper_number = evaluate('get_gen_paper.ship_fis_number') +1>
		<cfset paper_full = '#paper_code#-#paper_number#'>
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
				SERVICE_CONSUMER_ID,
				SERVICE_CONSUMER_MEMBER_ID,
				ASSETP_ID,
				DELIVER_EMP,
				ASSETP,
				DELIVER_EMP_NAME,
				PLATE,
				PLATE2,
				NOTE,
				SHIP_FIS_NO,
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
				SENDING_ADDRESS,
				SENDING_POSTCODE,
				SENDING_SEMT,
				SENDING_COUNTY_ID,
				SENDING_CITY_ID,
				SENDING_COUNTRY_ID,	
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE,
				INSURANCE_COMP_ID,
				INSURANCE_COMP_PART,
				DUTY_COMP_ID,
				DUTY_COMP_PARTNER,
				WAREHOUSE_ENTRY_DATE,
				PROJECT_ID,  <!--- Bu alan #67836 numaralı iş gereği MCP tarafından açılmıştır. --->
				OTHER_MONEY_VALUE,
				OTHER_MONEY,
				DELIVER_EMP_TC
			)
			VALUES
			(
				<cfif len(attributes.company_id)>
					#attributes.company_id#,
					<cfif len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
					NULL,
				<cfelseif len(attributes.consumer_id)>
					NULL,
					NULL,
					#attributes.consumer_id#,
				<cfelse>
					NULL,
					NULL,
					NULL,			
				</cfif>
				<cfif len(attributes.ship_method_id)>#attributes.ship_method_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.transport_comp_id)>#attributes.transport_comp_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.transport_deliver_id)>#attributes.transport_deliver_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.transport_cons_id)>#attributes.transport_cons_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.transport_cons_deliver_id)>#attributes.transport_cons_deliver_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)>#attributes.assetp_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.vehicle_emp_id") and len(attributes.vehicle_emp_id)>#attributes.vehicle_emp_id#<cfelse>NULL</cfif>,
				<cfif not isdefined("attributes.assetp_id") and len(attributes.assetp_name)>'#attributes.assetp_name#'<cfelse>NULL</cfif>,
				<cfif not isdefined("attributes.vehicle_emp_id") and len(attributes.vehicle_emp_name)>'#attributes.vehicle_emp_name#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.plate") and len(attributes.plate)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.plate#"><cfelse>NULL</cfif>,
				<cfif isDefined("attributes.plate2") and len(attributes.plate2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.plate2#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.note#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#paper_full#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.transport_paper_no#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.reference_no#">,
				<cfif len(attributes.action_date_value)>#attributes.action_date_value#<cfelse>NULL</cfif>,
				<cfif len(attributes.deliver_date_value)>#attributes.deliver_date_value#<cfelse>NULL</cfif>,
				<cfif len(attributes.deliver_id2)>#attributes.deliver_id2#<cfelse>NULL</cfif>,
				<cfif len(attributes.department_id)>#attributes.department_id#<cfelse>NULL</cfif>,
				#attributes.process_stage#,
				<cfif isdefined("attributes.total_cost_value")>#attributes.total_cost_value#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
				<cfif isdefined("attributes.total_cost2_value")>#attributes.total_cost2_value#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.sending_address)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.sending_postcode)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.sending_semt)#">,
				<cfif len(attributes.sending_county_id)>#attributes.sending_county_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.sending_city_id)>#attributes.sending_city_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.sending_country_id)>#attributes.sending_country_id#<cfelse>NULL</cfif>,			
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				#now()#,
				<cfif isdefined("attributes.insurance_comp_id") and len(attributes.insurance_comp_id)>#attributes.insurance_comp_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.insurance_comp_partner_id") and len(attributes.insurance_comp_partner_id)>#attributes.insurance_comp_partner_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.duty_comp_id") and len(attributes.duty_comp_id)>#attributes.duty_comp_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.duty_comp_partner_id") and len(attributes.duty_comp_partner_id)>#attributes.duty_comp_partner_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.warehouse_entry_date_value") and len(attributes.warehouse_entry_date_value)>#attributes.warehouse_entry_date_value#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.project_id") and len(attributes.project_id)>'#attributes.project_id#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.ship_price") and  len(attributes.ship_price)>#attributes.ship_price#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.ship_price_name") and len(attributes.ship_price_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_price_name#"><cfelse>NULL</cfif>,
				<cfif isDefined("attributes.vehicle_emp_tc") and len(attributes.vehicle_emp_tc)><cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.vehicle_emp_tc#'><cfelse>NULL</cfif>
			)
		</cfquery>
		<cfif len(attributes.record_num) and attributes.record_num neq 0>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif evaluate("attributes.row_kontrol#i#")>
					<cfscript>
						form_ship_id = evaluate("attributes.ship_id#i#");
						form_ship_number = evaluate("attributes.ship_number#i#");
						form_ship_date = evaluate("attributes.ship_date#i#");
						form_ship_deliver = evaluate("attributes.ship_deliver#i#");
						form_ship_type = evaluate("attributes.ship_type#i#");
						form_ship_adress = evaluate("attributes.ship_adress#i#");
					</cfscript>
					<cfif len(form_ship_date)><cf_date tarih='form_ship_date'></cfif>
					<cfif len(form_ship_id)>
						<!--- Irsaliyelere sevk bilgisi update ediliyor --->
						<cfquery name="UPD_SHIP" datasource="#DSN2#">
							UPDATE 
								SHIP
							SET
								IS_DISPATCH = 1
							WHERE
								SHIP_ID = #form_ship_id#
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
								#MAX_ID.IDENTITYCOL#,
								<cfif len(form_ship_id)>#form_ship_id#<cfelse>NULL</cfif>,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_number#">,
								<cfif len(form_ship_date)>#form_ship_date#<cfelse>NULL</cfif>,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_deliver#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_type#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_adress#">
							)
						</cfquery>
					</cfif>
				</cfif>
				</cfloop>
		</cfif>
		<cfif isdefined("attributes.record_num_other") and len(attributes.record_num_other)>
				<cfloop from="1" to="#attributes.record_num_other#" index="i">
				<cfif evaluate("attributes.row_kontrol_other#i#")>
					<cfscript>
						form_quantity = evaluate("attributes.quantity#i#");
						form_package_type = evaluate("attributes.package_type#i#");
						form_ship_ebat = evaluate("attributes.ship_ebat#i#");
						form_ship_agirlik = evaluate("attributes.ship_agirlik#i#");
						form_total_price = evaluate("attributes.total_price#i#");
						form_other_money = evaluate("attributes.other_money#i#");
						form_ship_barcod = evaluate("attributes.ship_barcod#i#");
						form_ship_barcod = evaluate("attributes.ship_barcod#i#");
						form_pack_emp_id = evaluate("attributes.pack_emp_id#i#");
						form_pack_emp_name = evaluate("attributes.pack_emp_name#i#");
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
							#MAX_ID.IDENTITYCOL#,
							<cfif len(form_quantity)>#form_quantity#<cfelse>NULL</cfif>,
							<cfif len(deger_form_package_type)>#deger_form_package_type#<cfelse>NULL</cfif>,
							<cfif len(form_ship_ebat)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_ebat#"><cfelse>NULL</cfif>,
							<cfif len(form_ship_agirlik)>#form_ship_agirlik#<cfelse>NULL</cfif>,
							<cfif len(form_total_price)>#form_total_price#<cfelse>NULL</cfif>,
							<cfif len(form_other_money) and len(form_total_price)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form_other_money#"><cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_barcod#">,
							<cfif len(form_pack_emp_id) and len(form_pack_emp_name)>#form_pack_emp_id#<cfelse>NULL</cfif>
						)
					</cfquery>
				</cfif>
				</cfloop>
		</cfif>

		<!--- Irsaliyeye ait siparislerin sevk bilgisi update ediliyor  --->
		<cfquery name="GET_SHIP_RESULT_ROW" datasource="#DSN2#">
			SELECT SHIP_ID FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID = #MAX_ID.IDENTITYCOL# AND SHIP_ID IS NOT NULL
		</cfquery>
		<cfif get_ship_result_row.recordcount>
			<cfquery name="UPD_ORDERS" datasource="#DSN2#">
				UPDATE #dsn3_alias#.ORDERS SET IS_DISPATCH = 1 WHERE ORDER_ID IN (SELECT ORDER_ID FROM #dsn3_alias#.ORDERS_SHIP WHERE PERIOD_ID = #session.ep.period_id# AND SHIP_ID IN (#valuelist(get_ship_result_row.ship_id)#))
			</cfquery>
		</cfif>

		<!--- Belge numarasi update ediliyor. --->
		<cfquery name="UPD_GEN_PAP" datasource="#DSN2#">
			UPDATE 
				#dsn3_alias#.GENERAL_PAPERS
			SET
				SHIP_FIS_NUMBER = #paper_number#
			WHERE
				SHIP_FIS_NUMBER IS NOT NULL
		</cfquery>
		</cftransaction>
</cflock>
<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#'
	action_table='SHIP_RESULT'
	action_column='SHIP_RESULT_ID'
	action_id='#MAX_ID.IDENTITYCOL#'
	action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_packetship&event=upd&ship_result_id=#MAX_ID.IDENTITYCOL#'
	warning_description = 'Sevkiyat No : #attributes.transport_no1#'>
	
<cfset attributes.actionId = MAX_ID.IDENTITYCOL >
<script type="text/javascript">
<cfif isdefined("attributes.ship_id") and len(attributes.ship_id)>
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_sale&event=upd&ship_id=#attributes.ship_id#</cfoutput>";
<cfelse>
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_packetship&event=upd&ship_result_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
</cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

