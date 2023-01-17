<cfif invoice_cat eq 52><!--- stok işlemi yapılabilir bir fatura ise --->
	<cfscript>
		get_ship_process = createObject("component", "V16.invoice.cfc.get_ship_process_cat");
		get_ship_process.dsn2 = dsn2;
		get_ship_process.dsn3_alias = dsn3_alias;
	</cfscript>
	<cfset int_ship_process_type = 70>
    <cfset int_ship_process_cat = get_ship_process.get_ship_process_cat(process_cat:PROCESS_CAT)>
    
	<cfif get_ship_id.recordcount and get_ship_id.is_with_ship>
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
			DELETE FROM INVOICE_SHIPS WHERE SHIP_ID = #get_ship_id.ship_id# AND SHIP_PERIOD_ID=#session.ep.period_id#
		</cfquery>
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
        <cfset seri_ship_id_ = get_ship_id.ship_id>
	</cfif>
	<cfif not len(attributes.ship_ids)>
		<cfif inventory_product_exists eq 1><!--- fatura satırlarında envantere dahil mal var ise erk 20040327 --->
		<!--- karma koli olan urunler seciliyor --->
			<cfif isdefined("karma_product_list") and len(karma_product_list)>
				<cfquery name="CHECK_KARMA_PRODUCTS" datasource="#dsn2#">
					SELECT PRODUCT_ID FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID IN (#karma_product_list#) AND IS_KARMA=1
				</cfquery>
				<cfif CHECK_KARMA_PRODUCTS.recordcount>
					<cfquery name="GET_KARMA_PRODUCTS" datasource="#dsn2#">
						SELECT 
							S.STOCK_ID,
							KP.PRODUCT_ID,
							KP.PRODUCT_AMOUNT,
							KP.KARMA_PRODUCT_ID
						FROM 
							#dsn1_alias#.KARMA_PRODUCTS KP,
							#dsn1_alias#.PRODUCT P,
							#dsn1_alias#.STOCKS S
						WHERE  
							P.PRODUCT_ID = KP.PRODUCT_ID AND 
							S.PRODUCT_ID = KP.PRODUCT_ID AND
							S.STOCK_ID = KP.STOCK_ID AND
							KP.KARMA_PRODUCT_ID IN (#valuelist(CHECK_KARMA_PRODUCTS.PRODUCT_ID,",")#)
					</cfquery>
				</cfif>
			</cfif>
			<!--- //karma koli olan urunler seciliyor --->
			<cfquery name="ADD_SALE" datasource="#dsn2#" result="MAX_ID">
				INSERT INTO SHIP
					(
					PURCHASE_SALES,
					SHIP_NUMBER,
					SHIP_TYPE,
                    PROCESS_CAT,
					SHIP_METHOD,
					SHIP_DATE,
					DELIVER_DATE,
				<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
					COMPANY_ID,
					<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>
					PARTNER_ID,
					</cfif>
				<cfelse>
					CONSUMER_ID,
				</cfif>
					DELIVER_EMP, 
					DISCOUNTTOTAL,
					NETTOTAL,
					GROSSTOTAL,
					TAXTOTAL,
					DELIVER_STORE_ID,
					LOCATION,
					ADDRESS,
					RECORD_DATE,
					RECORD_EMP,
					IS_WITH_SHIP
					)
				VALUES
					(
					1,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.INVOICE_NUMBER#">,
					#int_ship_process_type#,
                    <cfif len(int_ship_process_cat)>#int_ship_process_cat#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.ship_method') and len(attributes.ship_method)>#attributes.ship_method#<cfelse>NULL</cfif>,
					#attributes.invoice_date#,
					#attributes.invoice_date#,
				<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
					#attributes.company_id#,
					<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>
					#attributes.partner_id#,
					</cfif>
				<cfelse>
					#attributes.consumer_id#,
				</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(TRIM(DELIVER_GET),50)#">,
					#form.basket_discount_total#,
					#form.basket_net_total#,
					#form.basket_gross_total#,
					#form.basket_tax_total#,
					#attributes.department_id#,
					#attributes.location_id#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address#">,
					#NOW()#,
					#SESSION.EP.USERID#,
					1
					)
			</cfquery>
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
							DISCOUNT_COST,
							UNIQUE_RELATION_ID,
							PROM_RELATION_ID,
							OTHER_MONEY,
							OTHER_MONEY_VALUE,
							OTHER_MONEY_GROSS_TOTAL,
						<cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>
							SPECT_VAR_ID,
							SPECT_VAR_NAME,
						</cfif>
							LOT_NO,
							PRICE_OTHER,
							BASKET_EMPLOYEE_ID,
							LIST_PRICE,
							PRICE_CAT,
							CATALOG_ID,
							NUMBER_OF_INSTALLMENT,
							IS_PROMOTION,
							WRK_ROW_ID,
							WRK_ROW_RELATION_ID,
							WIDTH_VALUE,
							DEPTH_VALUE,
							HEIGHT_VALUE,
							ROW_PROJECT_ID
							<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,EXPENSE_CENTER_ID</cfif>
							<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,EXPENSE_ITEM_ID</cfif>
							<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
							<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,ACC_CODE</cfif>
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
							#MAX_ID.IDENTITYCOL#,
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
							<cfif isdefined("attributes.deliver_date#i#") and len(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
								#attributes.department_id#,
								#attributes.location_id#,
							<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
							<cfif isdefined("attributes.other_money_#i#") and len(evaluate("attributes.other_money_#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.other_money_#i#')#"><cfelse>NULL</cfif>,
							<cfif isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.other_money_gross_total#i#') and len(evaluate('attributes.other_money_gross_total#i#'))>#evaluate('attributes.other_money_gross_total#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>
								#evaluate("attributes.spect_id#i#")#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.spect_name#i#')#">,
							</cfif>
							<cfif isdefined("attributes.lot_no#i#") and len(evaluate("attributes.lot_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
							<cfif isdefined("attributes.price_other#i#") and len(evaluate("attributes.price_other#i#"))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
								0,
							#row_temp_wrk_id#,
							<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>
							<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_center_id#i#')#"></cfif>
							<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_item_id#i#')#"></cfif>
							<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_activity_id#i#')#"></cfif>
							<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.row_acc_code#i#')#"></cfif>
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
                    <cfif isdefined("seri_ship_id_")>
						<!--- eğer ürün silinirse girilmiş serilerde delete edilir PY 1114 --->
                        <cfquery name="del_serial_numbers" datasource="#dsn2#">
                            UPDATE 
                                #dsn3_alias#.SERVICE_GUARANTY_NEW 
                            SET
                                PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
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
                                AND WRK_ROW_ID NOT IN (SELECT WRK_ROW_ID FROM SHIP_ROW WHERE SHIP_ID = #MAX_ID.IDENTITYCOL# )
                                AND WRK_ROW_ID IS NOT NULL
                                AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                                AND PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">                    
                        </cfquery>
					</cfif>
					<cfif get_process_type.IS_STOCK_ACTION eq 1><!--- Stok hareketi yapılsın --->
					<cfinclude template="get_unit_add_fis.cfm">
					<cfif get_unit.recordcount and len(get_unit.multiplier)>
						<cfset multi=get_unit.multiplier*evaluate("attributes.amount#i#")>
					<cfelse>
						<cfset multi=evaluate("attributes.amount#i#")>
					</cfif>
                    
					<!---  specli bir satirsa main_spec id yazilacak stok row a --->
					<cfset form_spect_main_id="">
					<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
						<cfset form_spect_id="#evaluate('attributes.spect_id#i#')#">
						<cfif len(form_spect_id) and len(form_spect_id)>
							<cfquery name="GET_MAIN_SPECT" datasource="#DSN2#">
								SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECT_VAR_ID=#form_spect_id#
							</cfquery>
							<cfif GET_MAIN_SPECT.RECORDCOUNT>
								<cfset form_spect_main_id=GET_MAIN_SPECT.SPECT_MAIN_ID>
							</cfif>
						</cfif>
					</cfif>
					<cfif isdefined("karma_product_list") and len(karma_product_list) and (CHECK_KARMA_PRODUCTS.recordcount)>
						<cfquery name="GET_KARMA_PRODUCT" dbtype="query">
							SELECT 
								STOCK_ID,
								PRODUCT_ID,
								PRODUCT_AMOUNT
							FROM
								GET_KARMA_PRODUCTS
							WHERE  
								KARMA_PRODUCT_ID = #evaluate("attributes.product_id#i#")#
						</cfquery>
					<cfelse>
						<cfset GET_KARMA_PRODUCT.recordcount=0>
					</cfif>
					<cfif GET_KARMA_PRODUCT.recordcount>
						<cfloop query="GET_KARMA_PRODUCT">
							<cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
								INSERT INTO STOCKS_ROW
									(
									UPD_ID,
									PRODUCT_ID,
									STOCK_ID,
									PROCESS_TYPE,
									STOCK_OUT,
									STORE,
									STORE_LOCATION,
									PROCESS_DATE,
									SPECT_VAR_ID,
									LOT_NO,
									DELIVER_DATE,
									SHELF_NUMBER,
									PRODUCT_MANUFACT_CODE
									)
								VALUES
									(
									#MAX_ID.IDENTITYCOL#,
									#GET_KARMA_PRODUCT.product_id#,
									#GET_KARMA_PRODUCT.stock_id#,
									#int_ship_process_type#,
									#multi*GET_KARMA_PRODUCT.product_amount#,
									#attributes.department_id#,
									#attributes.location_id#,
									#attributes.invoice_date#,
								<cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>#form_spect_main_id#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.lot_no#i#") and len(evaluate("attributes.lot_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
								<cfif isdefined("attributes.deliver_date#i#") and len(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
								<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
								<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>
									)
							</cfquery>
						</cfloop>
					<cfelse>
						<cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
							INSERT INTO STOCKS_ROW
								(
								UPD_ID,
								PRODUCT_ID,
								STOCK_ID,
								PROCESS_TYPE,
								STOCK_OUT,
								STORE,
								STORE_LOCATION,
								PROCESS_DATE,
								DELIVER_DATE,
								SHELF_NUMBER,
								SPECT_VAR_ID,
								LOT_NO,
								PRODUCT_MANUFACT_CODE
								)
							VALUES
								(
								#MAX_ID.IDENTITYCOL#,
								#evaluate("attributes.product_id#i#")#,
								#evaluate("attributes.stock_id#i#")#,
								#int_ship_process_type#,
								#multi#,
								#attributes.department_id#,
								#attributes.location_id#,
								#attributes.invoice_date#,
							<cfif isdefined("attributes.deliver_date#i#") and len(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>#form_spect_main_id#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>
								)
						</cfquery>
					</cfif>
				</cfif>
				</cfif>
			</cfloop>
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
						#MAX_ID.IDENTITYCOL#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
						1,<!--- faturanın kendi irsaliyesi --->
						#session.ep.period_id#
					)
			</cfquery>
		</cfif>
	</cfif>
</cfif>
<cfif isdefined("get_relation_orders_invoices") and get_relation_orders_invoices.recordcount>
	<cfscript>
		if(not isdefined('xml_import'))// xml importdan gelmiyorsa yüklensin
			include('add_order_row_reserved_stock.cfm','\objects\functions');
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