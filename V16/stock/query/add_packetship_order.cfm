<!--- Not: SHIP_RESULT tablosundaki IS_TYPE alani siparis datayindaki Sevkiyat popup'dan atılan kayıtlarda (sadece bu kayitlarda) 2 set edilir.
	O yuzden ekleme ve silme işlemi su an yapilamamakta BK 20070405
 --->
 
 <cf_date tarih='attributes.order_date'>
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
			alert("<cf_get_lang no ='535.Lütfen Tanımlardan Belge Numaralarını Tanımlayınız'>!");
			history.go(-1);
		</script>
		<cfabort>
	</cfif>
	
	<cfif isdefined("attributes.warehouse_entry_date") and len(attributes.warehouse_entry_date)><cf_date tarih='attributes.warehouse_entry_date'></cfif>
	<cfif isdefined("attributes.action_date") and len(attributes.action_date)><cf_date tarih='attributes.action_date'></cfif>
	<cfif isdefined("attributes.deliver_date") and len(attributes.deliver_date)><cf_date tarih='attributes.deliver_date'></cfif>
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
	
	<cf_papers paper_type="ship_fis">
	<cflock timeout="60">
		  <cftransaction>
			<cfquery name="ADD_SHIP_RESULT" datasource="#DSN2#" result="MAX_ID">
				INSERT INTO
					SHIP_RESULT
				(
					IS_TYPE,
				  <cfif len(attributes.company_id)>
					COMPANY_ID,
					PARTNER_ID,
				  <cfelse>
					CONSUMER_ID,
				  </cfif>		
					SHIP_METHOD_TYPE,
					SERVICE_COMPANY_ID,
					SERVICE_MEMBER_ID,
					ASSETP_ID,
					DELIVER_EMP,
					PLATE,
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
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					INSURANCE_COMP_ID,
					INSURANCE_COMP_PART,
					DUTY_COMP_ID,
					DUTY_COMP_PARTNER,
					WAREHOUSE_ENTRY_DATE
				)
				VALUES
				(
					#attributes.is_type#,
				  <cfif len(attributes.company_id)>
					#attributes.company_id#,
					<cfif len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
				  <cfelse>
					#attributes.consumer_id#,
				  </cfif>		
					<cfif len(attributes.ship_method_id)>#attributes.ship_method_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.transport_comp_id)>#attributes.transport_comp_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.transport_deliver_id)>#attributes.transport_deliver_id#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.assetp_id') and len(attributes.assetp_id)>#attributes.assetp_id#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.vehicle_emp_id') and len(attributes.vehicle_emp_id)>#attributes.vehicle_emp_id#<cfelse>NULL</cfif>,
					'#attributes.plate#',
					'#attributes.note#',
					'#paper_code & '-' & paper_number#',
					'#attributes.transport_paper_no#',
					'#attributes.reference_no#',
					<cfif len(attributes.action_date_value)>#attributes.action_date_value#<cfelse>NULL</cfif>,
					<cfif len(attributes.deliver_date_value)>#attributes.deliver_date_value#<cfelse>NULL</cfif>,
					<cfif len(attributes.deliver_id2)>#attributes.deliver_id2#<cfelse>NULL</cfif>,
					<cfif len(attributes.department_id)>#attributes.department_id#<cfelse>NULL</cfif>,
					#attributes.process_stage#,
					<cfif isdefined("attributes.total_cost_value")>#attributes.total_cost_value#<cfelse>NULL</cfif>,
					'#session.ep.money#',
					<cfif isdefined("attributes.total_cost2_value")>#attributes.total_cost2_value#<cfelse>NULL</cfif>,
					'#session.ep.money2#',
					#session.ep.userid#,
					'#cgi.remote_addr#',
					#now()#,
					<cfif isdefined("attributes.insurance_comp_id") and len(attributes.insurance_comp_id)>#attributes.insurance_comp_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.insurance_comp_partner_id") and len(attributes.insurance_comp_partner_id)>#attributes.insurance_comp_partner_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.duty_comp_id") and len(attributes.duty_comp_id)>#attributes.duty_comp_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.duty_comp_partner_id") and len(attributes.duty_comp_partner_id)>#attributes.duty_comp_partner_id#<cfelse>NULL</cfif>,
					#attributes.warehouse_entry_date_value#
				)
			</cfquery>
			<!--- Sipasislerde sevk bilgisi update ediliyor --->
			<cfquery name="UPD_SHIP" datasource="#DSN2#">
				UPDATE 
					#dsn3_alias#.ORDERS
				SET
					IS_DISPATCH = 1
				WHERE
					ORDER_ID = #attributes.order_id#
			</cfquery>
	
			<!--- Siparisin Kaydı FA--->
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
					#attributes.order_id#,
					'#attributes.order_number#',
					#attributes.order_date#,
				<cfif len(order_cons)>
					'#attributes.order_cons#',
				<cfelse>
					'#attributes.order_comp#',
				</cfif>
					<cfif len(attributes.order_type)>'#attributes.order_type#',<cfelse>NULL,</cfif>
					<cfif len(attributes.order_adress)>'#attributes.order_adress#'<cfelse>NULL</cfif>
				)
			</cfquery>
			<!--- Siparişin Kaydı --->
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
								<cfif len(form_ship_ebat)>'#form_ship_ebat#'<cfelse>NULL</cfif>,
								<cfif len(form_ship_agirlik)>#form_ship_agirlik#<cfelse>NULL</cfif>,
								<cfif len(form_total_price)>#form_total_price#<cfelse>NULL</cfif>,
								<cfif len(form_other_money) and len(form_total_price)>'#form_other_money#'<cfelse>NULL</cfif>,
								'#form_ship_barcod#',
								<cfif len(form_pack_emp_id) and len(form_pack_emp_name)>#form_pack_emp_id#<cfelse>NULL</cfif>
							)
						</cfquery>
					</cfif>
				  </cfloop>
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
		action_page='#request.self#?fuseaction=stock.form_upd_packetship&ship_result_id=#MAX_ID.IDENTITYCOL#'
		warning_description = 'Sevkiyat No : #attributes.transport_no1#'>
	<script type="text/javascript">
		<cfif attributes.draggable eq 1>
			location.href =document.referrer;
		<cfelse>
			self.close();
			opener.location.href='<cfoutput>#request.self#?fuseaction=stock.list_packetship&event=upd&ship_result_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
		</cfif>
	</script>
	
	