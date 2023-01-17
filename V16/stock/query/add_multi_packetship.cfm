<cfif isDefined("attributes.order_row_list_") and Len(attributes.order_row_list_)>
	<!--- Sevkiyat Planlama Bazli Emirlerden Gelen Bilgiler Icin Include, Bu Sayfada Yapilacak Degisiklikler Include 'a da Yansitilmalidir FBS20091118  --->
	<cfinclude template="add_multi_packetship_order.cfm">
<cfelse>
	<!--- Normal Toplu Sevkiyat --->
	<cfif len(attributes.action_date)><cf_date tarih='attributes.action_date'></cfif>
	<cfif len(attributes.deliver_date)><cf_date tarih='attributes.deliver_date'></cfif>
	<cfset attributes.action_date_value = createdatetime(year(attributes.action_date),month(attributes.action_date),day(attributes.action_date),attributes.start_h,attributes.start_m,0)>
	<cfif len(attributes.deliver_date)>
		<cfset attributes.deliver_date_value = createdatetime(year(attributes.deliver_date),month(attributes.deliver_date),day(attributes.deliver_date),attributes.deliver_h,attributes.deliver_m,0)>
	<cfelse>
		<cfset attributes.deliver_date_value = "NULL">
	</cfif>
	<cflock timeout="60">
		<cftransaction>
			<cfquery name="get_gen_paper" datasource="#DSN2#">
				SELECT SHIP_FIS_NO, SHIP_FIS_NUMBER FROM #dsn3_alias#.GENERAL_PAPERS GENERAL_PAPERS WHERE PAPER_TYPE IS NULL
			</cfquery>
			<cfset paper_code = evaluate('get_gen_paper.SHIP_FIS_NO')>
			<cfset paper_number = evaluate('get_gen_paper.SHIP_FIS_NUMBER') +1>
			<cfset paper_full = '#paper_code#-#paper_number#'>
			<cfset paper_count =0>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<!--- Eger satır silinmemis ve iliskili irsaliye degilse --->
				<cfif evaluate("attributes.row_kontrol#i#") and not len(evaluate("attributes.related_row_kontrol#i#"))>
					<cfset paper_count = paper_count+1>
					<cfscript>
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
					</cfscript>
					<cfset paper_full_last = '#paper_code#-#paper_number#-#paper_count#'>
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
							<cfif len(form_company_id)>#form_company_id#<cfelse>NULL</cfif>,
							<cfif len(form_partner_id)>#form_partner_id#<cfelse>NULL</cfif>,
							<cfif Len(form_consumer_id)>#form_consumer_id#<cfelse>NULL</cfif>,
							<cfif len(attributes.ship_method_id)>#attributes.ship_method_id#<cfelse>NULL</cfif>,
							<cfif len(attributes.transport_comp_id)>#attributes.transport_comp_id#<cfelse>NULL</cfif>,
							<cfif len(attributes.transport_deliver_id)>#attributes.transport_deliver_id#<cfelse>NULL</cfif>,
							<cfif len(attributes.assetp_id)>#attributes.assetp_id#<cfelse>NULL</cfif>,
							<cfif len(attributes.vehicle_emp_id)>#attributes.vehicle_emp_id#<cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.plate#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.note#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#paper_full_last#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#paper_full#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.transport_paper_no#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.reference_no#">,
							<cfif len(attributes.action_date_value)>#attributes.action_date_value#<cfelse>NULL</cfif>,
							<cfif len(attributes.deliver_date_value)>#attributes.deliver_date_value#<cfelse>NULL</cfif>,
							<cfif len(attributes.deliver_id2)>#attributes.deliver_id2#<cfelse>NULL</cfif>,
							<cfif len(attributes.department_id)>#attributes.department_id#<cfelse>NULL</cfif>,
							#attributes.process_stage#,
							#form_total_cost_value#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
							#form_total_cost2_value#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,
							#session.ep.userid#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							#now()#
						)
					</cfquery>
					<cfif Len(form_ship_id)>
						<!--- Irsaliyelere sevk bilgisi update ediliyor --->
						<cfquery name="UPD_SHIP" datasource="#DSN2#">
							UPDATE SHIP SET IS_DISPATCH = 1 WHERE SHIP_ID = #form_ship_id#
						</cfquery>
					</cfif>
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
							#form_ship_id#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_number#">,
							<cfif len(form_ship_date)>#form_ship_date#<cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_deliver#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_type#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_adress#">
						)
					</cfquery>
					<cfif len(form_row_count_list)><!--- sevkiyat bazli kosulunda buraya girmemeli --->
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
							<cf_date tarih='form_ship_date'>
							<cfif Len(form_ship_id)>
							<!--- Irsaliyelere sevk bilgisi update ediliyor --->
							<cfquery name="UPD_SHIP" datasource="#DSN2#">
								UPDATE SHIP SET IS_DISPATCH = 1 WHERE SHIP_ID = #form_ship_id#
							</cfquery>
							</cfif>
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
									#form_ship_id#,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_number#">,
									<cfif len(form_ship_date)>#form_ship_date#<cfelse>NULL</cfif>,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_deliver#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_type#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_ship_adress#">
								)
							</cfquery>
						</cfloop>
					</cfif>
					<cfif len(form_ship_id_list)><!--- sevkiyat bazli kosulunda buraya girmemeli --->
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
				</cfif>
			</cfloop>
	
			<!--- Irsaliyeye ait siparislerin sevk bilgisi update ediliyor  --->
			<cfquery name="GET_SHIP_RESULT_ROW" datasource="#DSN2#">
				SELECT SHIP_ID FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID IN(SELECT SR.SHIP_RESULT_ID FROM SHIP_RESULT SR WHERE SR.MAIN_SHIP_FIS_NO = '#paper_full#') AND SHIP_ID IS NOT NULL
			</cfquery>
			<cfif get_ship_result_row.recordcount>
				<cfquery name="UPD_ORDERS" datasource="#DSN2#">
					UPDATE #dsn3_alias#.ORDERS SET IS_DISPATCH = 1 WHERE ORDER_ID IN (SELECT ORDER_ID FROM #dsn3_alias#.ORDERS_SHIP WHERE PERIOD_ID = #session.ep.period_id# AND SHIP_ID IN (#valuelist(get_ship_result_row.ship_id)#))
				</cfquery>
			</cfif>
	
			<!--- Belge numarasi update ediliyor. --->
			<cfquery name="UPD_GEN_PAP" datasource="#DSN2#">
				UPDATE #dsn3_alias#.GENERAL_PAPERS SET SHIP_FIS_NUMBER = #paper_number# WHERE SHIP_FIS_NUMBER IS NOT NULL
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
		action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_multi_packetship&event=upd&main_ship_fis_no=#paper_full#'
		warning_description = 'Sevkiyat No : #paper_full#'>

	<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_multi_packetship&event=upd&main_ship_fis_no=#paper_full#" addtoken="no">
	<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
</cfif>
