<cfif get_ship_id.recordcount and get_ship_id.is_with_ship> 
	<!--- faturanın önceki kendi irsaliyesi silinip yeniden oluşturulacak --->
	<cfquery name="DEL_SHIP_ROW4" datasource="#dsn2#">
		DELETE FROM SHIP_MONEY WHERE ACTION_ID = #get_ship_id.ship_id#
	</cfquery>			
	<cfquery name="DEL_SHIP_RESULT_ROWS" datasource="#dsn2#">
		DELETE FROM SHIP_RESULT_ROW WHERE SHIP_ID = #get_ship_id.ship_id#
	</cfquery>		
	<cfquery name="DEL_SHIP_ROW" datasource="#dsn2#">
		DELETE FROM SHIP_ROW WHERE SHIP_ID = #get_ship_id.ship_id#
	</cfquery>
	<cfquery name="DEL_SHIP" datasource="#dsn2#">
		DELETE FROM SHIP WHERE SHIP_ID = #get_ship_id.ship_id#
	</cfquery>
	<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
		DELETE FROM STOCKS_ROW WHERE UPD_ID = #get_ship_id.ship_id# AND PROCESS_TYPE = #get_ship_id.ship_type#
	</cfquery>
	<cfquery name="DEL_INVOICE_SHIPS" datasource="#dsn2#"><!--- invoice ve ship baglantilarının tutuldugu tablo --->
		DELETE FROM INVOICE_SHIPS WHERE SHIP_ID = #get_ship_id.ship_id# AND SHIP_PERIOD_ID=#session.ep.period_id# AND INVOICE_ID IS NOT NULL
	</cfquery>
	<cfset seri_ship_id_ = get_ship_id.ship_id>
	<!--- siparişten fatura olusturuldugunda aradaki baglantının kopmaması icin  ORDERS_SHIP tablosuna kayıt atılır, irsaliye silinince bu kayıtlar silinip, yeni oluşturulacak irsaliye_id si ile tekrar eklenir.--->
	<cfif isDefined("attributes.order_id_listesi") and len(attributes.order_id_listesi)>
		<cfloop list="#attributes.order_id_listesi#" index="kk">
			<cfquery name="DEL_ORDERS_SHIP" datasource="#dsn2#"> 
				DELETE FROM #dsn3_alias#.ORDERS_SHIP WHERE SHIP_ID=#get_ship_id.ship_id# AND ORDER_ID=#kk# AND PERIOD_ID=#session.ep.period_id#
			</cfquery>
		</cfloop>
	<cfelseif isDefined("attributes.order_id") and len(attributes.order_id)>
		<cfquery name="DEL_ORDERS_SHIP" datasource="#dsn2#"> 
			DELETE FROM #dsn3_alias#.ORDERS_SHIP WHERE SHIP_ID=#get_ship_id.ship_id# AND ORDER_ID=#attributes.order_id# AND PERIOD_ID=#session.ep.period_id#
		</cfquery>
	</cfif>
</cfif>
<cfif isdefined("attributes.basket_due_value") and len(attributes.basket_due_value)>
	<cfset ship_due_date = date_add("d",attributes.basket_due_value,attributes.invoice_date)>
<cfelse>
	<cfset ship_due_date = "">
</cfif>
<cfif (isdefined("attributes.order_id") and len(attributes.order_id)) or (isdefined("attributes.order_id_listesi") and len(attributes.order_id_listesi))>
	<cfquery name="get_relation_orders_invoices" datasource="#dsn2#"><!--- fbs 20150615 satir iliskisi yoksa belge iliskileri de kaldirilir veya hic eklenmez --->
		SELECT
			OW.ORDER_ID
		FROM 
			INVOICE_ROW IW,
			#dsn3_alias#.ORDER_ROW OW
		WHERE
			OW.WRK_ROW_ID = IW.WRK_ROW_RELATION_ID AND
			IW.INVOICE_ID = #form.invoice_id#
		GROUP BY
			OW.ORDER_ID
	</cfquery>
</cfif>

<cfif listfind('52,53,531,62,5311,533',invoice_cat,',')><!--- stok işlemi yapılabilir bir fatura ise --->
	<cfscript>
		get_ship_process = createObject("component", "V16.invoice.cfc.get_ship_process_cat");
		get_ship_process.dsn2 = dsn2;
		get_ship_process.dsn3_alias = dsn3_alias;
	</cfscript>

	<cfif invoice_cat eq 52> <!--- perakende satıs faturası --->
		<cfset int_ship_process_type = 70>
        <cfset int_ship_process_cat = get_ship_process.get_ship_process_cat(process_cat:PROCESS_CAT)>
	<cfelseif invoice_cat eq 53> <!--- toptan satış faturası--->
		<cfset int_ship_process_type = 71>
        <cfset int_ship_process_cat = get_ship_process.get_ship_process_cat(process_cat:PROCESS_CAT)>
	<cfelseif invoice_cat eq 531> <!--- ihracat faturası --->
		<cfset int_ship_process_type = 88> <!--- ihracat irsaliyesi --->
        <cfset int_ship_process_cat = get_ship_process.get_ship_process_cat(process_cat:PROCESS_CAT)>
	<cfelseif listfind('5311,533',invoice_cat,',')> <!--- ihraç Kayıtlı Satış ve KDV den Muaf Satış --->
		<cfset int_ship_process_type = 71> <!--- Satış irsaliyesi --->
        <cfset int_ship_process_cat = get_ship_process.get_ship_process_cat(process_cat:PROCESS_CAT,new_datasource:new_dsn2_group)>
	<cfelse>
		<cfset int_ship_process_type = 78> <!---Alım iade irsaliyesi  --->
        <cfset int_ship_process_cat = get_ship_process.get_ship_process_cat(process_cat:PROCESS_CAT)>
	</cfif>
	<cfif not included_irs> 
		<cfif inventory_product_exists eq 1><!--- fatura satırlarında envantere dahil mal var ise erk 20040327 --->
			<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
			<cfquery name="ADD_SALE" datasource="#dsn2#" result="MAX_ID">
				INSERT INTO SHIP
					(
					WRK_ID,
					PURCHASE_SALES,
					SHIP_NUMBER,
					SHIP_TYPE,
                    PROCESS_CAT,
					SHIP_METHOD,
					SHIP_DATE,
					DELIVER_DATE,
				<cfif isDefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.comp_name") and len(attributes.comp_name)>
					COMPANY_ID,
					<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>
					PARTNER_ID,
					</cfif>
				<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
					CONSUMER_ID,
				<cfelse>
					EMPLOYEE_ID,
				</cfif>
				<cfif session.ep.our_company_info.project_followup eq 1>
					PROJECT_ID,
				</cfif>
					DELIVER_EMP,
					COMMETHOD_ID,
					DISCOUNTTOTAL,
					NETTOTAL,
					GROSSTOTAL,
					TAXTOTAL,
					OTV_TOTAL,
					DELIVER_STORE_ID,
					LOCATION,
					ADDRESS,
					CITY_ID,
					COUNTY_ID,
					SUBSCRIPTION_ID,
					RECORD_DATE,
					RECORD_EMP,
					IS_WITH_SHIP,
					PAYMETHOD_ID,
					REF_NO,
					DUE_DATE
					)
				VALUES
					(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
					1,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.INVOICE_NUMBER#">,
					#int_ship_process_type#,
                    <cfif len(int_ship_process_cat)>#int_ship_process_cat#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.ship_method') and len(attributes.ship_method)>#attributes.ship_method#<cfelse>NULL</cfif>,
					#attributes.invoice_date#,
					<cfif isdefined("attributes.ship_date") and len(attributes.ship_date) and isdate(attributes.ship_date)>#attributes.ship_date#<cfelse>#attributes.invoice_date#</cfif>,
				<cfif isDefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.comp_name") and len(attributes.comp_name)>
					#attributes.company_id#,
					<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>
					#attributes.partner_id#,
					</cfif>
				<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
					#attributes.consumer_id#,
				<cfelse>
					#attributes.employee_id#,
				</cfif>
				<cfif session.ep.our_company_info.project_followup eq 1>
					<cfif isdefined("attributes.project_id") and len(attributes.project_id)  and isdefined("attributes.project_head") and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
				</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(TRIM(DELIVER_GET),50)#">,
					<cfif isdefined("attributes.commethod_id") and len(attributes.commethod_id)>#attributes.commethod_id#<cfelse>NULL</cfif>,
					#form.basket_discount_total#,
					#form.basket_net_total#,
					#form.basket_gross_total#,
					#form.basket_tax_total#,
					<cfif isdefined("attributes.basket_otv_total") and len(attributes.basket_otv_total)>#attributes.basket_otv_total#<cfelse>NULL</cfif>,
					#attributes.department_id#,
					#attributes.location_id#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.adres#">,
					<cfif isdefined("attributes.city_id") and len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.county_id") and len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>#attributes.subscription_id#<cfelse>NULL</cfif>,
					#NOW()#,
					#SESSION.EP.USERID#,
					1,
					<cfif isdefined('attributes.paymethod_id') and len(attributes.paymethod_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ref_no') and len(attributes.ref_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ref_no#"><cfelse>NULL</cfif>,
					<cfif isdefined("ship_due_date") and len(ship_due_date)>#ship_due_date#<cfelse>NULL</cfif>
					)
			</cfquery>
            <cfset max_ship_value_ = MAX_ID.IDENTITYCOL>
			<cfloop from="1" to="#attributes.rows_#" index="i">
				<cfif evaluate('attributes.is_inventory#i#') eq 1><!--- envantere dahil ürün satırı ise --->
					<cfinclude template="get_dis_amount.cfm">
					<cfset row_temp_wrk_id="#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#">
					<cfquery name="ADD_SHIP_ROW" datasource="#dsn2#">
						INSERT INTO SHIP_ROW
							(
							NAME_PRODUCT,
							SHIP_ID,
							STOCK_ID,
							PRODUCT_ID,
							AMOUNT,
							UNIT,
							UNIT_ID,
							TAX,
							PRICE,
							PURCHASE_SALES,
							DISCOUNT,
							DISCOUNT2,
							DISCOUNT3,
							DISCOUNT4,
							DISCOUNT5,
							DISCOUNT6,
							DISCOUNT7,
							DISCOUNT8,
							DISCOUNT9,
							DISCOUNT10,
							DISCOUNTTOTAL,
							GROSSTOTAL,
							NETTOTAL,
							TAXTOTAL,													
							DELIVER_DATE,
							DELIVER_DEPT,
							DELIVER_LOC,
							OTHER_MONEY,
							OTHER_MONEY_VALUE,
							OTHER_MONEY_GROSS_TOTAL,
						<cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>
							SPECT_VAR_ID,
							SPECT_VAR_NAME,
						</cfif>
							LOT_NO,
							PRICE_OTHER,
							IS_PROMOTION,
							DISCOUNT_COST,
							COST_PRICE,
							EXTRA_COST,
							UNIQUE_RELATION_ID,
							PROM_RELATION_ID,
							PRODUCT_NAME2,
							AMOUNT2,
							UNIT2,
							EXTRA_PRICE,
							EXTRA_PRICE_TOTAL,
							EXTRA_PRICE_OTHER_TOTAL,
							SHELF_NUMBER,
							PRODUCT_MANUFACT_CODE,
							BASKET_EMPLOYEE_ID,
							LIST_PRICE,
							NUMBER_OF_INSTALLMENT,
							DUE_DATE,
							PRICE_CAT,
							CATALOG_ID,
							KARMA_PRODUCT_ID,
							OTV_ORAN,
							OTVTOTAL,
							WRK_ROW_ID,
							WRK_ROW_RELATION_ID,
							ROW_ORDER_ID,
							WIDTH_VALUE,
							DEPTH_VALUE,
							HEIGHT_VALUE,
							ROW_PROJECT_ID,
							ROW_WORK_ID
							<cfif isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#")) and isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#"))>,EXPENSE_CENTER_ID</cfif>
							<cfif isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#")) and isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#"))>,EXPENSE_ITEM_ID</cfif>
							<cfif isdefined('attributes.basket_acc_code#i#') and len(evaluate("attributes.basket_acc_code#i#"))>,ACC_CODE</cfif>
							<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
							<cfif isdefined('attributes.row_subscription_name#i#') and len(evaluate("attributes.row_subscription_name#i#")) and isdefined('attributes.row_subscription_id#i#') and len(evaluate("attributes.row_subscription_id#i#"))>,SUBSCRIPTION_ID</cfif>
							<cfif isdefined('attributes.row_assetp_name#i#') and len(evaluate("attributes.row_assetp_name#i#")) and isdefined('attributes.row_assetp_id#i#') and len(evaluate("attributes.row_assetp_id#i#"))>,ASSETP_ID</cfif>
							<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,BSMV_RATE</cfif>
							<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,BSMV_AMOUNT</cfif>
							<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,BSMV_CURRENCY</cfif>
							<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,OIV_RATE</cfif>
							<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,OIV_AMOUNT</cfif>
							<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,TEVKIFAT_RATE</cfif>
							<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,TEVKIFAT_AMOUNT</cfif>
							)
						VALUES
							(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(wrk_eval('attributes.product_name#i#'),250)#">,
							#max_ship_value_#,
							#evaluate("attributes.stock_id#i#")#,
							#evaluate("attributes.product_id#i#")#,
							#evaluate("attributes.amount#i#")#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.unit#i#')#">,
							#evaluate("attributes.unit_id#i#")#,
							#evaluate("attributes.tax#i#")#,
							#evaluate("attributes.price#i#")#,
							1,
							#indirim1#,
							#indirim2#,
							#indirim3#,
							#indirim4#,
							#indirim5#,
							#indirim6#,
							#indirim7#,
							#indirim8#,
							#indirim9#,
							#indirim10#,
							#DISCOUNT_AMOUNT#,
							#evaluate("attributes.row_lasttotal#i#")#,
							#evaluate("attributes.row_nettotal#i#")#,
							#evaluate("attributes.row_taxtotal#i#")#,										
							<cfif isdefined('attributes.deliver_date#i#') and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
								#listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
							<cfelseif isdefined('attributes.department_id') and len(attributes.department_id)>
								#attributes.department_id#,
							<cfelse>
								NULL,
							</cfif>
							<cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
								#listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
							<cfelseif isdefined('attributes.location_id') and len(attributes.location_id)>
								#attributes.location_id#,
							<cfelse>
								NULL,
							</cfif>
							<cfif isdefined('attributes.other_money_#i#')><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.other_money_#i#')#"><cfelse>NULL</cfif>,
							<cfif isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.other_money_gross_total#i#") and len(evaluate("attributes.other_money_gross_total#i#"))>#evaluate("attributes.other_money_gross_total#i#")#<cfelse>0</cfif>,
							<cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>
								#evaluate("attributes.spect_id#i#")#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.spect_name#i#'),500)#">,
							</cfif>
							<cfif isdefined("attributes.lot_no#i#") and len(evaluate("attributes.lot_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
							<cfif isdefined("attributes.price_other#i#") and len(evaluate("attributes.price_other#i#"))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
								0,
							<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
							<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
							<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.ek_tutar_other_total#i#') and len(evaluate('attributes.ek_tutar_other_total#i#'))>#evaluate('attributes.ek_tutar_other_total#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.duedate#i#") and len(evaluate("attributes.duedate#i#"))>#evaluate("attributes.duedate#i#")#<cfelse>0</cfif>,
							<cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.karma_product_id#i#') and len(evaluate('attributes.karma_product_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.karma_product_id#i#')#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
							#row_temp_wrk_id#,
							<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,<!--- faturanın wrk_row_id si olusturdugu irsaliyenin wrk_row_relation_id sine gonderiliyor --->
							<cfif isdefined("attributes.row_ship_id#i#") and len(evaluate("attributes.row_ship_id#i#"))>#listfirst(evaluate("attributes.row_ship_id#i#"),';')#<cfelseif isDefined("attributes.order_id") and len(attributes.order_id)>#attributes.order_id#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.row_work_id#i#') and len(evaluate('attributes.row_work_id#i#'))>#evaluate('attributes.row_work_id#i#')#<cfelse>NULL</cfif>
							<cfif isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#")) and isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_center_id#i#')#"></cfif>
							<cfif isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#")) and isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_item_id#i#')#"></cfif>
							<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.row_acc_code#i#')#"></cfif>
							<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_activity_id#i#')#"></cfif>
							<cfif isdefined('attributes.row_subscription_name#i#') and len(evaluate("attributes.row_subscription_name#i#")) and isdefined('attributes.row_subscription_id#i#') and len(evaluate("attributes.row_subscription_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_subscription_id#i#')#"></cfif>
							<cfif isdefined('attributes.row_assetp_name#i#') and len(evaluate("attributes.row_assetp_name#i#")) and isdefined('attributes.row_assetp_id#i#') and len(evaluate("attributes.row_assetp_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_assetp_id#i#')#"></cfif>
							<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_rate#i#')#"></cfif>
							<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_amount#i#')#"></cfif>
							<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_currency#i#')#"></cfif>
							<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_rate#i#')#"></cfif>
							<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_amount#i#')#"></cfif>
							<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_rate#i#')#"></cfif>
							<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_amount#i#')#"></cfif>
							)
					</cfquery>
				</cfif>
			</cfloop>
			<cfscript>
				if(get_process_type.IS_STOCK_ACTION eq 1)//Stok hareketi yapılsın
				{
					sr_product_id_list ="";
					sr_stock_id_list ="";
					sr_unit_list ="";
					sr_amount_list ="";
					sr_spec_id_list ="";
					sr_lot_no_list ="";
					sr_shelf_number_list ="";
					sr_manufact_code_list ="";
					sr_amount_other_list ="";
					sr_unit_other_list ="";
					sr_deliver_date_list ="";
					sr_row_width_list="";
					sr_row_height_list="";
					sr_row_depth_list="";
					sr_row_department_list="";
					sr_row_location_list="";

					if(isdefined('attributes.deliver_date_frm') and isdate(attributes.deliver_date_frm))
						sr_process_date_=attributes.deliver_date_frm;
					else
						sr_process_date_=attributes.invoice_date;
					for(_ind_=1;_ind_ lte attributes.rows_;_ind_=_ind_+1)
					{
						if(evaluate('attributes.is_inventory#_ind_#') eq 1) //urun envantere dahilse stock hareketi yapar
						{
							sr_product_id_list = ListAppend(sr_product_id_list,Evaluate('attributes.product_id#_ind_#'),',');
							sr_stock_id_list = ListAppend(sr_stock_id_list,Evaluate('attributes.stock_id#_ind_#'),',');
							sr_unit_list = ListAppend(sr_unit_list,Evaluate('attributes.unit#_ind_#'),',');
							sr_amount_list = ListAppend(sr_amount_list,Evaluate('attributes.amount#_ind_#'),',');
							if(isdefined('attributes.spect_id#_ind_#') and len(Evaluate('attributes.spect_id#_ind_#')) )
								sr_spec_id_list = ListAppend(sr_spec_id_list,Evaluate('attributes.spect_id#_ind_#'),',');
							else
								sr_spec_id_list = ListAppend(sr_spec_id_list,0,',');
							if(isdefined('attributes.lot_no#_ind_#') and len(Evaluate('attributes.lot_no#_ind_#')) )
								sr_lot_no_list = ListAppend(sr_lot_no_list,Evaluate('attributes.lot_no#_ind_#'),',');
							else
								sr_lot_no_list = ListAppend(sr_lot_no_list,0,',');
							
							if(isdefined('attributes.shelf_number#_ind_#') and len(Evaluate('attributes.shelf_number#_ind_#')) )
								sr_shelf_number_list = ListAppend(sr_shelf_number_list,Evaluate('attributes.shelf_number#_ind_#'),',');
							else
								sr_shelf_number_list = ListAppend(sr_shelf_number_list,0,',');
							
							if(isdefined('attributes.manufact_code#_ind_#') and len(Evaluate('attributes.manufact_code#_ind_#')) )
								sr_manufact_code_list = ListAppend(sr_manufact_code_list,Evaluate('attributes.manufact_code#_ind_#'),',');
							else
								sr_manufact_code_list = ListAppend(sr_manufact_code_list,0,',');
							
							if(isdefined('attributes.amount_other#_ind_#') and len(Evaluate('attributes.amount_other#_ind_#')) )
								sr_amount_other_list = ListAppend(sr_amount_other_list,Evaluate('attributes.amount_other#_ind_#'),',');
							else
								sr_amount_other_list = ListAppend(sr_amount_other_list,0,',');
							
							if(isdefined('attributes.unit_other#_ind_#') and len(evaluate('attributes.unit_other#_ind_#')) )
								sr_unit_other_list = ListAppend(sr_unit_other_list,evaluate('attributes.unit_other#_ind_#'),',');
							else
								sr_unit_other_list = ListAppend(sr_unit_other_list,0,',');
							if(isdefined('attributes.deliver_date#_ind_#') and isdate(evaluate('attributes.deliver_date#_ind_#')) )
								sr_deliver_date_list = ListAppend(sr_deliver_date_list,evaluate('attributes.deliver_date#_ind_#'),',');
							else
								sr_deliver_date_list = ListAppend(sr_deliver_date_list,0,',');
								
							if(isdefined('attributes.row_width#_ind_#') and len(evaluate('attributes.row_width#_ind_#')) )
								sr_row_width_list = ListAppend(sr_row_width_list,evaluate('attributes.row_width#_ind_#'),',');
							else
								sr_row_width_list = ListAppend(sr_row_width_list,0,',');
							
							if(isdefined('attributes.row_height#_ind_#') and len(evaluate('attributes.row_height#_ind_#')) )
								sr_row_height_list = ListAppend(sr_row_height_list,evaluate('attributes.row_height#_ind_#'),',');
							else
								sr_row_height_list = ListAppend(sr_row_height_list,0,',');
						
							if(isdefined('attributes.row_depth#_ind_#') and len(evaluate('attributes.row_depth#_ind_#')) )
								sr_row_depth_list = ListAppend(sr_row_depth_list,evaluate('attributes.row_depth#_ind_#'),',');
							else
								sr_row_depth_list = ListAppend(sr_row_depth_list,0,',');
								
							if(isdefined('attributes.deliver_dept#_ind_#') and listlen(evaluate('attributes.deliver_dept#_ind_#'),'-') eq 2 ) //teslim depo-lokasyon
							{
								sr_row_department_list=ListAppend(sr_row_department_list,listfirst(evaluate('attributes.deliver_dept#_ind_#'),'-') );
								sr_row_location_list=ListAppend(sr_row_location_list,listlast(evaluate('attributes.deliver_dept#_ind_#'),'-') );
							}
							else
							{
								sr_row_department_list=attributes.department_id;
								sr_row_location_list=attributes.location_id;
							}
						}
					}
					if(len(sr_product_id_list) and len(sr_stock_id_list))
					{
							
						add_stock_rows(
							sr_is_purchase_sales : 1,
							sr_stock_row_count : listlen(sr_stock_id_list,','),
							sr_max_id :max_ship_value_,
							sr_department_id : attributes.department_id,
							sr_location_id : attributes.location_id,
							sr_process_date :sr_process_date_,
							sr_document_date : attributes.invoice_date,
							sr_process_type : int_ship_process_type,
							sr_main_process_type : invoice_cat,
							sr_product_id_list: sr_product_id_list,
							sr_control_process_type : '62', // iade process type lar satıs ve alısa gore degisiyor, dikkat plz.
							sr_stock_id_list: sr_stock_id_list,
							sr_unit_list: sr_unit_list,
							sr_amount_list: sr_amount_list,
							sr_spec_id_list: sr_spec_id_list,
							sr_lot_no_list: sr_lot_no_list,
							sr_shelf_number_list:sr_shelf_number_list,
							sr_manufact_code_list:sr_manufact_code_list,
							sr_amount_other_list : sr_amount_other_list,
							sr_unit_other_list : sr_unit_other_list,
							sr_deliver_date_list :sr_deliver_date_list,
							sr_width_list:sr_row_width_list,
							sr_depth_list:sr_row_depth_list,
							sr_height_list:sr_row_height_list,
							sr_row_department_id:sr_row_department_list,
							sr_row_location_id:sr_row_location_list
						);
					}
				}
				basket_kur_ekle(action_id:max_ship_value_,table_type_id:2,process_type:0,basket_money_db:dsn2);	
			</cfscript>
			<cfif isdefined("seri_ship_id_")>
				<cfquery name="del_serial_numbers" datasource="#dsn2#">
					UPDATE 
						#dsn3_alias#.SERVICE_GUARANTY_NEW 
					SET
						PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#max_ship_value_#">,
						PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
						PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_ship_process_type#">,
						PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
					WHERE
						PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#seri_ship_id_#"> AND
						PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				</cfquery>
                <cfquery name="get_stock_info" datasource="#dsn2#">
                    DELETE									
                    FROM 
                        #DSN3_ALIAS#.SERVICE_GUARANTY_NEW 
                    WHERE 
                        PROCESS_NO = '#form.INVOICE_NUMBER#' 
                        AND PROCESS_CAT = #int_ship_process_type# 
                        AND WRK_ROW_ID NOT IN (SELECT WRK_ROW_ID FROM SHIP_ROW WHERE SHIP_ID = #max_ship_value_# )
                        AND WRK_ROW_ID IS NOT NULL
                        AND WRK_ROW_ID <> ''
                        AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                        AND PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#seri_ship_id_#">
                </cfquery>
            </cfif>

			<cfquery name="ADD_INVOICE_SHIPS" datasource="#dsn2#">
				INSERT INTO
					INVOICE_SHIPS
					(
					INVOICE_ID,
					INVOICE_NUMBER,
					SHIP_ID,
					SHIP_NUMBER,
					IS_WITH_SHIP,
					SHIP_PERIOD_ID
					)
				VALUES
					(
					#form.invoice_id#,					
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
					#max_ship_value_#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
					1 ,<!--- faturanın kendi irsaliyesi --->
					#session.ep.period_id#
					)
			</cfquery>
			<!---irsaliye cekilerek oluşturulmuş bir fatura önce iptal edilip, ardından iptal geri alınarak tekrar güncellenirse
			fatura kendi irsaliyesini oluşturduğu halde INVOICE tablosundaki IS_WITH_SHIP alanı 0 kalıyordu, bu yüzden INVOICE
			update ediliyor OZDEN20061017
			 --->
			<cfquery name="UPD_INV_" datasource="#dsn2#">
				UPDATE INVOICE SET IS_WITH_SHIP = 1 WHERE INVOICE_ID = #form.invoice_id#
			</cfquery>
			<cfif isdefined("get_relation_orders_invoices") and get_relation_orders_invoices.recordcount>
				<!--- <cfif isDefined("attributes.order_id") and len(attributes.order_id)><cfset attributes.order_id_listesi = attributes.order_id></cfif> --->
				<cfif isDefined("attributes.order_id_listesi") and len(attributes.order_id_listesi)>
					<!--- sevkiyat ekranından geliyorsa ilgili tüm siparişlerle ilişkilendirilir. --->
					<!--- fatura siparisten olusturuluyorsa, irsaliye ve siparis arasında baglantının kopmaması icin ORDERS_SHIP tablosuna kayıt atılır. --->
					<cfloop list="#attributes.order_id_listesi#" index="kk">
						<cfquery name="add_orders_ship" datasource="#new_dsn2_group#">
							INSERT INTO
								#dsn3_alias#.ORDERS_SHIP
								(
									ORDER_ID,
									SHIP_ID,
									PERIOD_ID
								)
								VALUES
								(
									#kk#,
									#max_ship_value_#,
									#session_base.period_id#
								)
						</cfquery>
					</cfloop>
				<cfelseif isDefined("attributes.order_id") and len(attributes.order_id)>
					<!--- fatura siparisten olusturuluyorsa, irsaliye ve siparis arasında baglantının kopmaması icin ORDERS_SHIP tablosuna kayıt atılır. --->
					<cfquery name="add_orders_ship" datasource="#new_dsn2_group#">
						INSERT INTO
							#dsn3_alias#.ORDERS_SHIP
							(
								ORDER_ID,
								SHIP_ID,
								PERIOD_ID
							)
							VALUES
							(
								#attributes.order_id#,
								#max_ship_value_#,
								#session_base.period_id#
							)
					</cfquery>
				</cfif>
			</cfif>
		</cfif>	
	</cfif>
</cfif>
<cfif isdefined("get_relation_orders_invoices") and get_relation_orders_invoices.recordcount>
	<cfscript>
		row_order_id_ = ValueList(get_relation_orders_invoices.order_id);
		
		add_reserve_row(
			reserve_order_id:row_order_id_,
			related_process_id : form.invoice_id,
			reserve_action_type:1,
			is_order_process:2,
			is_purchase_sales:1,
			is_stock_row_action :get_process_type.IS_STOCK_ACTION,
			process_db :dsn2
			);
	</cfscript>
<cfelseif (isdefined("attributes.order_id") and len(attributes.order_id)) or (isdefined("attributes.order_id_listesi") and len(attributes.order_id_listesi))>
	<cfquery name="del_orders_invoice" datasource="#dsn2#">
		DELETE FROM #dsn3_alias#.ORDERS_INVOICE WHERE ORDER_ID = <cfif isdefined("attributes.order_id") and len(attributes.order_id)>#attributes.order_id#<cfelse>#attributes.order_id_listesi#</cfif> AND INVOICE_ID = #form.invoice_id# AND PERIOD_ID = #session.ep.period_id#
	</cfquery>
	<cfquery name="upd_invoice_order" datasource="#dsn2#">
		UPDATE INVOICE SET ORDER_ID = NULL WHERE INVOICE_ID = #form.invoice_id#
	</cfquery>
</cfif>
