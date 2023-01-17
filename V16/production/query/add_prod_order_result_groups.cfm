<!--- Toplu Üretim Sonucu Kaydetme Ekranı! --->
<cfsetting showdebugoutput="no">
<cfset emp_list = "">
<cfif isdefined('attributes.p_order_id_list') and listlen(p_order_id_list,',')><!--- ÜretimID'leri varsa... --->
	<cfinclude template="../../workdata/get_main_spect_id.cfm">
	<cfif isdefined("attributes.wrk_row_id")>
		<cfset attributes.wrk_row_id = attributes.wrk_row_id>
	<cfelse>
		<cfset attributes.wrk_row_id = 0>
	</cfif>
	<cfloop list="#attributes.p_order_id_list#" index="p_o_id"><!--- ÜretimID'lerinin listesini döndürüyoruz. --->
		<!--- Üretim Emrinin Detayları Aynı Zamanda Ana Ürünün Bilgileri!--->
		<cfquery name="GET_DET_PO" datasource="#DSN3#"><!--- Her bir üretim emri tek tek döndürülüyor! --->
			SELECT 
				PRODUCTION_ORDERS.ORDER_ID,
				PRODUCTION_ORDERS.IS_DEMONTAJ,
				PRODUCTION_ORDERS.SPECT_VAR_ID,
				PRODUCTION_ORDERS.SPEC_MAIN_ID,
				STOCKS.STOCK_CODE,
				PRODUCTION_ORDERS.STOCK_ID, 
				PRODUCTION_ORDERS.P_ORDER_NO,
				PRODUCTION_ORDERS.STATION_ID,
				PRODUCTION_ORDERS.START_DATE,
				PRODUCTION_ORDERS.FINISH_DATE,
				PRODUCTION_ORDERS.QUANTITY AMOUNT,
				PRODUCTION_ORDERS.IS_DEMONTAJ,
				PRODUCTION_ORDERS.LOT_NO,
                PRODUCTION_ORDERS.WRK_ROW_ID,
				STOCKS.PROPERTY, 
				STOCKS.STOCK_ID,
				STOCKS.PRODUCT_UNIT_ID,
				STOCKS.IS_PRODUCTION,
				STOCKS.IS_PROTOTYPE,
				STOCKS.PRODUCT_NAME, 
				STOCKS.PRODUCT_ID,
				STOCKS.TAX,
				STOCKS.TAX_PURCHASE,
				STOCKS.BARCOD,		
				PRODUCT_UNIT.ADD_UNIT,
				PRODUCT_UNIT.MAIN_UNIT,
				0 IS_SEVK,
				0 AS IS_FREE_AMOUNT,
				0 LINE_NUMBER,
				'S' AS TREE_TYPE,
				0 AS IS_PHANTOM,
				0 AS IS_PROPERTY,
				'' AS LOT_NO,
				0 PRODUCT_COST_ID
			FROM
				PRODUCTION_ORDERS,
				STOCKS,
				PRODUCT_UNIT
			WHERE 
				PRODUCTION_ORDERS.P_ORDER_ID = #p_o_id# AND 
				PRODUCTION_ORDERS.STOCK_ID = STOCKS.STOCK_ID AND	
				PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
				PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND
				PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID							
		</cfquery>
		<cfquery name="get_prod_operation" datasource="#dsn3#">
			SELECT TOP 1
				ASSET_ID,
				SERIAL_NO,
                POR_OPERATION_ID
			FROM
				PRODUCTION_ORDER_OPERATIONS
			WHERE
				WRK_ROW_ID = '#attributes.wrk_row_id#' AND
				TYPE = 1
		</cfquery>
		<cfif get_prod_operation.recordCount>
			<cfquery name="get_prod_operation_emp" datasource="#dsn3#">
				SELECT
					EMPLOYEE_ID
				FROM
					PRODUCTION_ORDER_OPERATIONS_EMPLOYEE
				WHERE
					OPERATION_ID = #get_prod_operation.POR_OPERATION_ID#
			</cfquery>
        	<cfset emp_list = valuelist(get_prod_operation_emp.EMPLOYEE_ID)>
		</cfif>
		<cfif not len(GET_DET_PO.SPEC_MAIN_ID) and not len(GET_DET_PO.SPEC_MAIN_ID.SPECT_VAR_ID)>
			<script type="text/javascript">
				alert('Üretim Yapılabilmesi İçin Üretilen Ürüne Spec Seçmeniz Gerekmektedir!');
			</script>
			<cfabort>
		</cfif>
		<cf_papers paper_type="production_result"><!--- Üretim Sonucu Her Satır İçin Ekleniyor! --->
		<cfscript>
			system_paper_no = paper_code & '-' & paper_number;
			system_paper_no_add = paper_number;
			attributes.start_date = dateadd('h',session.ep.time_zone,CreateODBCDateTime( GET_DET_PO.START_DATE));
			attributes.finish_date = dateadd('h', session.ep.time_zone,CreateODBCDateTime(GET_DET_PO.FINISH_DATE));
			account_action_date=GET_DET_PO.FINISH_DATE; /*muhasebe isleminde kullanılıyor*/
		</cfscript>
		<cftransaction>
			<cfif isdefined("attributes.is_prod") and len(attributes.is_prod)>
				<cfquery name="add_operations" datasource="#dsn3#" result="my_result">
					INSERT INTO
						PRODUCTION_ORDER_OPERATIONS
					(
						P_ORDER_ID,
						TYPE,
						PAUSE_TYPE,
						OPERATION_DATE,
						ASSET_ID,
						SERIAL_NO,
						AMOUNT,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP,
						WRK_ROW_ID
					)
					VALUES
					(
						#attributes.p_order_id_list#,
						#attributes.type#,
						<cfif isdefined("attributes.pause_type") and len(attributes.pause_type)>#attributes.pause_type#<cfelse>NULL</cfif>,
						#now()#,
						<cfif len(get_prod_operation.asset_id)>#get_prod_operation.asset_id#<cfelse>NULL</cfif>,
						<cfif len(get_prod_operation.serial_no)>'#get_prod_operation.serial_no#'<cfelse>NULL</cfif>,
						#attributes.amount#,
						#now()#,
						#session.ep.userid#,
						'#CGI.REMOTE_ADDR#',
						'#attributes.wrk_row_id#'
					)
				</cfquery>
                <cfif len(emp_list)>
                	<cfquery name="add_emps" datasource="#dsn3#">
                        <cfloop list="#emp_list#" index="cc">
                            INSERT INTO 
                                PRODUCTION_ORDER_OPERATIONS_EMPLOYEE
                            (
                                OPERATION_ID,
                                EMPLOYEE_ID
                            )
                            VALUES
                            (
                                #my_result.IDENTITYCOL#,
                                #cc#
                            )
                        </cfloop>
                    </cfquery>
                </cfif>
				<cfif len(attributes.record_num)>
					<cfquery name="del_prod_rows" datasource="#dsn3#">
						DELETE FROM PRODUCTION_ORDER_OPERATIONS_PRODUCT WHERE WRK_ROW_ID = '#attributes.wrk_row_id#'
					</cfquery>
					<cfloop from="1" to="#attributes.record_num#" index="i">
						<cfif isdefined("attributes.row_kontrol#no#_#i#") and evaluate("attributes.row_kontrol#no#_#i#") eq 1>
							<cfquery name="get_product_" datasource="#dsn3#">
								SELECT PRODUCT_ID,PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #evaluate('attributes.stock_id#no#_#i#')#
							</cfquery>
							<cfquery name="add_row_product" datasource="#dsn3#">
								INSERT INTO
									PRODUCTION_ORDER_OPERATIONS_PRODUCT
								(
									WRK_ROW_ID,
									P_ORDER_ID,
									PRODUCT_ID,
									STOCK_ID,
									PRODUCT_NAME,
									AMOUNT,
									RECORD_DATE,
									RECORD_EMP,
									RECORD_IP
								)
								VALUES
								(
									'#attributes.wrk_row_id#',
									#attributes.p_order_id_list#,
									#get_product_.product_id#,
									#evaluate('attributes.stock_id#no#_#i#')#,
									'#get_product_.product_name#',
									#evaluate('attributes.amount#no#_#i#')#,
									#now()#,
									#session.ep.userid#,
									'#CGI.REMOTE_ADDR#'
								)
							</cfquery>
						</cfif>
					</cfloop>
				</cfif>
				<cfquery name="get_operation_date" datasource="#dsn3#">
					SELECT 
						MIN(OPERATION_DATE) START_DATE,
						MAX(OPERATION_DATE) FINISH_DATE
					FROM
						PRODUCTION_ORDER_OPERATIONS
					WHERE
						P_ORDER_ID = #attributes.p_order_id_list# AND
						WRK_ROW_ID = '#attributes.wrk_row_id#'
				</cfquery>
				<cfscript>
                	attributes.start_date = dateadd('h',session.ep.time_zone,CreateODBCDateTime( get_operation_date.START_DATE));
					attributes.finish_date = dateadd('h', session.ep.time_zone,CreateODBCDateTime(get_operation_date.FINISH_DATE));
                </cfscript>
			</cfif>
			<cfquery name="get_production_orders_rel" datasource="#dsn3#"><!--- Emirlerler ilişkili Siparişleri Çekiyoruz. --->
				SELECT 
					(SELECT ORDER_NUMBER FROM ORDERS WHERE ORDER_ID = POR.ORDER_ID) AS ORDER_NUMBER
				FROM 
					PRODUCTION_ORDERS_ROW POR
				WHERE
					POR.PRODUCTION_ORDER_ID = #p_o_id#
			</cfquery>
			<cfif get_production_orders_rel.recordcount><!--- Sipariş numarası --->
				<cfset attributes.order_no = get_production_orders_rel.ORDER_NUMBER>
			<cfelse>
				<cfset attributes.order_no = ''>
			</cfif>
			<cfif len(GET_DET_PO.station_id)>
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
						STATION_ID = #GET_DET_PO.STATION_ID#
				</cfquery>
			<cfelse>
				<cfset get_station_info.recordcount = 0>
			</cfif>
			<cfif GET_STATION_INFO.recordcount>
				<cfset attributes.exit_department_id = GET_STATION_INFO.EXIT_DEP_ID><!--- //Sarf Depo --->
				<cfset attributes.exit_location_id = GET_STATION_INFO.EXIT_LOC_ID><!--- //Sarf Depo location --->
				<cfset attributes.production_department_id = GET_STATION_INFO.PRODUCTION_DEP_ID><!--- //üretim depo --->
				<cfset attributes.production_location_id = GET_STATION_INFO.PRODUCTION_LOC_ID><!--- //üretim location --->
				<cfset attributes.enter_department_id = GET_STATION_INFO.ENTER_DEP_ID><!--- //sevkiyat dep --->
				<cfset attributes.enter_location_id = GET_STATION_INFO.ENTER_LOC_ID><!--- //sevkiyat loca --->
			<cfelse>
				<cfset attributes.exit_department_id = ''>
				<cfset attributes.exit_location_id = ''>
				<cfset attributes.production_department_id = ''>
				<cfset attributes.production_location_id = ''>
				<cfset attributes.enter_department_id = ''>
				<cfset attributes.enter_location_id = ''>
			</cfif>
			<cfquery name="ADD_PRODUCTION_ORDER" datasource="#DSN3#"><!--- Üretim Sonucu Ekliyoruz. --->
				SET NOCOUNT ON
				INSERT INTO 
					PRODUCTION_ORDER_RESULTS 
				( 
					P_ORDER_ID,
					PROCESS_ID,
					START_DATE,
					FINISH_DATE,
					EXIT_DEP_ID,
					EXIT_LOC_ID,
					STATION_ID,
					PRODUCTION_ORDER_NO,
					RESULT_NO,
					ENTER_DEP_ID,
					ENTER_LOC_ID,
					ORDER_NO,
					POSITION_ID ,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP,
					LOT_NO,
					PRODUCTION_DEP_ID,
					PRODUCTION_LOC_ID,
					PROD_ORD_RESULT_STAGE,
					IS_STOCK_FIS
				)
				VALUES
				(
					#p_o_id#,
					#attributes.process_cat#,
					<cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
					<cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
					<cfif len(attributes.exit_department_id)>'#attributes.exit_department_id#'<cfelse>NULL</cfif>,<!--- len(attributes.exit_department) and --->
					<cfif len(attributes.exit_location_id)>'#attributes.exit_location_id#'<cfelse>NULL</cfif>,<!--- len(attributes.exit_department) and  --->
					<cfif len(GET_DET_PO.station_id)>#GET_DET_PO.station_id#<cfelse>NULL</cfif>,<!---  and len(attributes.station_name) --->
					<cfif len(GET_DET_PO.P_ORDER_NO)>'#GET_DET_PO.P_ORDER_NO#'<cfelse>NULL</cfif>,
					<cfif len(paper_full)>'#paper_full#'<cfelse>NULL</cfif>,
					<cfif len(attributes.enter_department_id)>'#attributes.enter_department_id#'<cfelse>NULL</cfif>,<!--- len(attributes.enter_department) and  --->
					<cfif len(attributes.enter_location_id)>'#attributes.enter_location_id#'<cfelse>NULL</cfif>,<!--- len(attributes.enter_department) and  --->
					<cfif len(attributes.order_no)>'#attributes.order_no#'<cfelse>NULL</cfif>,<!--- Sipariş numarası --->                
					#session.ep.userid#,
					#session.ep.userid#,
					#now()#,
					'#cgi.remote_addr#',
					<cfif len(GET_DET_PO.LOT_NO)>'#GET_DET_PO.LOT_NO#'<cfelse>NULL</cfif>,
					<cfif len(attributes.production_department_id)>'#attributes.production_department_id#'<cfelse>NULL</cfif>,<!--- len(attributes.production_department) and  --->
					<cfif len(attributes.production_location_id)>'#attributes.production_location_id#'<cfelse>NULL</cfif>,<!---  len(attributes.production_department) and  --->
					#attributes.process_stage#,
					0
				)
				SELECT @@Identity AS MAX_ID      
				SET NOCOUNT OFF
			</cfquery>
			<cfquery name="upd_prod_order" datasource="#dsn3#"><!--- 1 OLUNCA ÜRETİM BAŞLAMIŞ OLUYOR! --->
				UPDATE PRODUCTION_ORDERS SET IS_STAGE = 1 WHERE P_ORDER_ID =  #p_o_id#
			</cfquery>
			<cfscript>
				value_price = 0;
				value_price_extra = 0;
			</cfscript>
			<!--- Sarflar ve fireler --->
			<cfquery name="GET_SUB_PRODUCTS" datasource="#dsn3#">
				SELECT
					'Spec' AS NAME,
					POS.AMOUNT,
					POS.IS_SEVK,
					POS.IS_PROPERTY,
                    POS.SPECT_MAIN_ID SPECT_VAR_ID,
					POS.SPECT_MAIN_ID SPEC_MAIN_ID,
					POS.IS_FREE_AMOUNT ,
					'' PRODUCT_COST_ID,
					STOCKS.STOCK_CODE,
					STOCKS.PRODUCT_NAME,
					STOCKS.PRODUCT_ID,
					STOCKS.STOCK_ID,
					STOCKS.BARCOD,
					PRODUCT_UNIT.ADD_UNIT,
					PRODUCT_UNIT.MAIN_UNIT,
					STOCKS.IS_PRODUCTION,
					STOCKS.TAX,
					STOCKS.TAX_PURCHASE,
					STOCKS.PRODUCT_UNIT_ID,
					PRICE_STANDART.PRICE,
					PRICE_STANDART.MONEY,
					STOCKS.PROPERTY,
					POS.TYPE,
                    POS.LOT_NO,
                    POS.WRK_ROW_ID
				FROM
					PRODUCTION_ORDERS_STOCKS POS,
					STOCKS,
					PRODUCT_UNIT,
					PRICE_STANDART
				WHERE
					PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
					PRICE_STANDART.PURCHASESALES = 1 AND
					PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
					STOCKS.STOCK_STATUS = 1	AND
					POS.P_ORDER_ID = #p_o_id# AND
					POS.IS_PROPERTY IN(0,4) AND
					<cfif get_det_po.is_demontaj eq 1> POS.IS_SEVK = 0 AND</cfif>
					POS.STOCK_ID = STOCKS.STOCK_ID AND
					PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
					STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
			UNION ALL
				SELECT
					'Spec' AS NAME,
					POS.AMOUNT,
					0 IS_SEVK,
					0 IS_PROPERTY,
                    '' SPECT_VAR_ID,
					'' SPEC_MAIN_ID,
					0 IS_FREE_AMOUNT ,
					'' PRODUCT_COST_ID,
					STOCKS.STOCK_CODE,
					STOCKS.PRODUCT_NAME,
					STOCKS.PRODUCT_ID,
					STOCKS.STOCK_ID,
					STOCKS.BARCOD,
					PRODUCT_UNIT.ADD_UNIT,
					PRODUCT_UNIT.MAIN_UNIT,
					STOCKS.IS_PRODUCTION,
					STOCKS.TAX,
					STOCKS.TAX_PURCHASE,
					STOCKS.PRODUCT_UNIT_ID,
					PRICE_STANDART.PRICE,
					PRICE_STANDART.MONEY,
					STOCKS.PROPERTY,
					2 AS TYPE,
                    '' LOT_NO,
                    '' WRK_ROW_ID
				FROM
					PRODUCTION_ORDER_OPERATIONS_PRODUCT POS,
					STOCKS,
					PRODUCT_UNIT,
					PRICE_STANDART
				WHERE
					PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
					PRICE_STANDART.PURCHASESALES = 1 AND
					PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
					STOCKS.STOCK_STATUS = 1	AND
					POS.P_ORDER_ID = #p_o_id# AND
					POS.STOCK_ID = STOCKS.STOCK_ID AND
					PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
					STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID AND
					POS.WRK_ROW_ID = '#attributes.wrk_row_id#'
			</cfquery>
			<!--- SARFLAR --->
			<cfif get_det_po.is_demontaj eq 1>
            	<cfset is_demontaj_ = 1>
				<cfset sarf_query='get_det_po'>
                <cfset sonuc_query = 'GET_SUB_PRODUCTS'>
			<cfelse>
				<cfset sarf_query='GET_SUB_PRODUCTS'>
                <cfset sonuc_query = 'get_det_po'>
			</cfif>
            <cfif isdefined("attributes.amount") and len(attributes.amount)>
				<cfset miktar_ = attributes.amount>
			<cfelse>
				<cfset miktar_ = evaluate('#sonuc_query#.AMOUNT')>
			</cfif>
            <cfset sonuc_miktar = evaluate('#sonuc_query#.AMOUNT')>
			<cfset deger_value_row = evaluate('#sarf_query#.recordcount')>
			<cfif deger_value_row>
				<cfloop query="#sarf_query#"><!--- Sarfları Döndürülüyor! --->
						<cfquery name="GET_PRODUCT" datasource="#dsn3#" maxrows="1"><!--- Maliyet --->
							SELECT
								PRODUCT_COST_ID,
								PURCHASE_NET,
								PURCHASE_NET_MONEY,
								PURCHASE_NET_SYSTEM,
								PURCHASE_NET_SYSTEM_MONEY,
								PURCHASE_EXTRA_COST,
								PURCHASE_EXTRA_COST_SYSTEM,
								PRODUCT_COST,
								MONEY 
							FROM 
								PRODUCT_COST 
							WHERE 
								PRODUCT_ID = #PRODUCT_ID# AND
								START_DATE <= #createodbcdate(get_det_po.finish_date)#
							ORDER BY 
								START_DATE DESC,
								RECORD_DATE DESC
						</cfquery>
						<cfscript>
							//maliyet
							if(GET_PRODUCT.RECORDCOUNT eq 0)
							{
								cost_id = 0;
								purchase_extra_cost = 0;
								product_cost = 0;
								product_cost_money = session.ep.money;
								cost_price = 0;
								cost_price_money = session.ep.money;
								cost_price_system = 0;
								cost_price_system_money = session.ep.money;
								purchase_extra_cost_system = 0;
							}
							else
							{
								cost_id = get_product.product_cost_id;
								purchase_extra_cost = GET_PRODUCT.PURCHASE_EXTRA_COST;
								product_cost = GET_PRODUCT.PRODUCT_COST;
								product_cost_money = GET_PRODUCT.MONEY;
								cost_price = GET_PRODUCT.PURCHASE_NET;
								cost_price_money = GET_PRODUCT.PURCHASE_NET_MONEY;
								cost_price_system = GET_PRODUCT.PURCHASE_NET_SYSTEM;
								cost_price_system_money = GET_PRODUCT.PURCHASE_NET_SYSTEM_MONEY;
								purchase_extra_cost_system = GET_PRODUCT.PURCHASE_EXTRA_COST_SYSTEM;
							}
							//-maliyet
							
							//form_spect_var_id_exit = evaluate("attributes.spect_id_exit#st#");
							form_spec_main_id_exit = SPEC_MAIN_ID;
							form_barcode_exit = BARCOD;
							form_product_id_exit = PRODUCT_ID;
							form_stock_id_exit = STOCK_ID;
							form_lot_no_exit = LOT_NO;
							form_wrk_row_id_exit = WRK_ROW_ID;
							
								if(IS_FREE_AMOUNT == 1)
									form_amount_exit = amount;
								else
									form_amount_exit = miktar_*amount/sonuc_miktar; // sarf miktar hesaplaması eklend PY 0615
							
							form_unit_id_exit = PRODUCT_UNIT_ID;
							form_exit_product_name = PRODUCT_NAME;
							form_exit_unit = MAIN_UNIT;
							if(form_spec_main_id_exit gt 0){
							specNameSqlStr="SELECT SPECT_MAIN_NAME FROM SPECT_MAIN  WHERE SPECT_MAIN_ID =#form_spec_main_id_exit#";
							specNameSqlQuery = cfquery(SQLString : specNameSqlStr, Datasource : dsn3);
								if(specNameSqlQuery.recordcount)
									form_spect_name_exit = specNameSqlQuery.SPECT_MAIN_NAME;
								else
									form_spect_name_exit ='';
							}
							else
								form_spect_name_exit ='';
							form_is_production_spect_exit = IS_PRODUCTION;//eğer sarfa spect seçilmemişse ve üretilen bir ürünse bu sarf,otomatik olarak spect oluşacak.
							//maliyet tanımlamaları.	
							form_cost_id_exit = cost_id;
							form_kdv_amount_exit=TAX;
							form_cost_price_system_exit=cost_price_system;
							form_purchase_extra_cost_system_exit=purchase_extra_cost_system;
							form_purchase_extra_cost_exit=purchase_extra_cost;
							form_money_system_exit = cost_price_system_money;
							form_cost_price_exit = cost_price;
							form_money_exit = cost_price_money;
						</cfscript>
						<!--- Üretilen fakat spect seçilmemiş ürünler için spect kontrolü --->
						<cfif not len(SPEC_MAIN_ID) and IS_PRODUCTION eq 1 ><!--- spect seçilmemiş ise ve ürün üretiliyor ise --->
							<cfscript>
									new_spec_value = get_main_spect_id(STOCK_ID);
									if(len(new_spec_value.SPECT_MAIN_ID) )
										form_spec_main_id_exit = new_spec_value.SPECT_MAIN_ID;
									else
										form_spec_main_id_exit = 0;
							</cfscript>
						</cfif>
						<!--- Sarf --->
						<cfset wrk_row_id_sarf = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##ADD_PRODUCTION_ORDER.MAX_ID##form_stock_id_exit#_#TYPE#'>
						<cfquery name="ADD_ROW_ENTER_S" datasource="#dsn3#">
							INSERT
							INTO
								PRODUCTION_ORDER_RESULTS_ROW
								(
									TYPE,
									PR_ORDER_ID,
									BARCODE,
									STOCK_ID,
									PRODUCT_ID,
									AMOUNT,
									UNIT_ID,
									NAME_PRODUCT,
									UNIT_NAME,
									IS_SEVKIYAT,
									SPEC_MAIN_ID,
									SPECT_NAME,
									COST_ID,
									KDV_PRICE,
									PURCHASE_NET_SYSTEM,
									PURCHASE_NET_SYSTEM_MONEY,
									PURCHASE_EXTRA_COST_SYSTEM,
									PURCHASE_NET_SYSTEM_TOTAL,
									PURCHASE_NET,
									PURCHASE_NET_MONEY,
									PURCHASE_EXTRA_COST,
									PURCHASE_NET_TOTAL,
									WRK_ROW_ID,
                                    LOT_NO,
                                    WRK_ROW_RELATION_ID
								)
								VALUES
								(
									#TYPE#,
									#ADD_PRODUCTION_ORDER.MAX_ID#,
									<cfif len(form_barcode_exit)>'#form_barcode_exit#'<cfelse>NULL</cfif>,
									<cfif len(form_stock_id_exit)>#form_stock_id_exit#<cfelse>NULL</cfif>,
									<cfif len(form_product_id_exit)>#form_product_id_exit#<cfelse>NULL</cfif>,
									<cfif len(form_amount_exit)>#form_amount_exit#<cfelse>NULL</cfif>,
									<cfif len(form_unit_id_exit)>#form_unit_id_exit#<cfelse>NULL</cfif>,
									'#left(form_exit_product_name,75)#',
									'#left(form_exit_unit,75)#',
									<cfif IS_SEVK eq 1 >1<cfelse>0</cfif>,
									<cfif len(form_spec_main_id_exit) and form_spec_main_id_exit gt 0>#form_spec_main_id_exit#<cfelse>NULL</cfif>,
									<cfif len(form_spect_name_exit)>'#left(form_spect_name_exit,50)#'<cfelse>NULL</cfif>,
									<cfif len(form_cost_id_exit) and (form_cost_id_exit neq 0)>#form_cost_id_exit#<cfelse>NULL</cfif>,
									<cfif len(form_kdv_amount_exit)>#form_kdv_amount_exit#<cfelse>0</cfif>,
									<cfif len(form_cost_price_system_exit)>#form_cost_price_system_exit#<cfelse>0</cfif>,
									<cfif len(form_money_system_exit)>'#form_money_system_exit#'<cfelse>'#session.ep.money#'</cfif>,
									<cfif len(form_purchase_extra_cost_system_exit)>#form_purchase_extra_cost_system_exit#<cfelse>0</cfif>,
									<cfif len(form_cost_price_system_exit) and len(form_amount_exit)>#form_cost_price_system_exit*form_amount_exit#<cfelse>0</cfif>,
									<cfif len(form_cost_price_exit)>#form_cost_price_exit#<cfelse>0</cfif>,
									<cfif len(form_money_exit)>'#form_money_exit#'<cfelse>'#session.ep.money#'</cfif>,
									<cfif len(form_purchase_extra_cost_exit)>#form_purchase_extra_cost_exit#<cfelse>0</cfif>,
									<cfif len(form_cost_price_exit)>#form_cost_price_exit*form_amount_exit#<cfelse>0</cfif>,
									'#wrk_row_id_sarf#',
                                    <cfif len(form_lot_no_exit)>'#form_lot_no_exit#'<cfelse>NULL</cfif>,
                                    <cfif len(form_wrk_row_id_exit)>'#form_wrk_row_id_exit#'<cfelse>NULL</cfif>
								)				 
						</cfquery>
						<cfscript>
						if(not len(form_amount_exit))form_amount_exit=0;
						if(not len(form_cost_price_system_exit))form_cost_price_system_exit=0;
						if(not len(form_purchase_extra_cost_system_exit))form_purchase_extra_cost_system_exit=0;
						if(get_det_po.is_demontaj eq 0){
							value_price = value_price + form_cost_price_system_exit * form_amount_exit;
							value_price_extra = value_price_extra + form_purchase_extra_cost_system_exit * form_amount_exit;
						}
						</cfscript>
				</cfloop>
			</cfif>
			<!--- /SARFLAR BİTTİ --->
			<!--- Ana Ürün --->
			<cfif GET_DET_PO.recordcount gt 0>
				<cfquery name="GET_DET_PO_2" dbtype="query">
					SELECT * FROM GET_SUB_PRODUCTS WHERE IS_FREE_AMOUNT = 1
				</cfquery>
				<cfquery name="GET_DET_PO" dbtype="query">
					SELECT 
						STOCK_CODE,
						PRODUCT_NAME,
						PRODUCT_ID,
						STOCK_ID,
						BARCOD,
						ADD_UNIT,
						MAIN_UNIT,
						IS_PRODUCTION,
						TAX,
						TAX_PURCHASE,
						PRODUCT_UNIT_ID,
						SPEC_MAIN_ID ,
						SPECT_VAR_ID,
						AMOUNT,
						0 IS_FREE_AMOUNT,
                        LOT_NO,
                        WRK_ROW_ID
					 FROM 
					 	GET_DET_PO
					UNION ALL
					SELECT 
						STOCK_CODE,
						PRODUCT_NAME,
						PRODUCT_ID,
						STOCK_ID,
						BARCOD,
						ADD_UNIT,
						MAIN_UNIT,
						IS_PRODUCTION,
						TAX,
						TAX_PURCHASE,
						PRODUCT_UNIT_ID,
						SPEC_MAIN_ID,
						0 SPECT_VAR_ID,
						AMOUNT,
						IS_FREE_AMOUNT,
                        LOT_NO,
                        WRK_ROW_ID
					 FROM 
					 	GET_DET_PO_2
				</cfquery>
				<!--- Ana Ürün Dönüyor! --->
				<cfset demontaj_cost_price_system = 0>
				<cfset demontaj_purchase_extra_cost_system = 0>
				<cfset demontaj_cost_price_system_2 = 0>
				<cfset sonuc_recordcount = evaluate('#sonuc_query#.recordcount')>
				<cfloop query="#sonuc_query#">
					<cfquery name="GET_PRODUCT_M" datasource="#dsn3#" maxrows="1"><!--- Ana Ürün İçin Maliyet Çekiliyor. --->
						SELECT 
							PRODUCT_COST_ID,
							PURCHASE_NET,
							PURCHASE_NET_MONEY,
							PURCHASE_NET_SYSTEM,
							PURCHASE_NET_SYSTEM_MONEY,
							PURCHASE_EXTRA_COST,
							PURCHASE_EXTRA_COST_SYSTEM,
							PRODUCT_COST,
							MONEY 
						FROM 
							PRODUCT_COST 
						WHERE 
							PRODUCT_ID = #PRODUCT_ID# AND
							START_DATE <= #now()# 
						ORDER BY 
							START_DATE DESC,
							RECORD_DATE DESC
					</cfquery>
					<cfscript>
						if(GET_PRODUCT_M.RECORDCOUNT eq 0)
						{
							m_cost_id = 0;
							m_purchase_extra_cost = 0;
							m_product_cost = 0;
							m_product_cost_money = session.ep.money;
							m_cost_price = 0;
							m_cost_price_money = session.ep.money;
							m_cost_price_system = 0;
							m_cost_price_system_money = session.ep.money;
							m_purchase_extra_cost_system = 0;
						}
						else
						{
							m_cost_id = GET_PRODUCT_M.product_cost_id;
							m_purchase_extra_cost = GET_PRODUCT_M.PURCHASE_EXTRA_COST;
							m_product_cost = GET_PRODUCT_M.PRODUCT_COST;
							m_product_cost_money = GET_PRODUCT_M.MONEY;
							m_cost_price = GET_PRODUCT_M.PURCHASE_NET;
							m_cost_price_money = GET_PRODUCT_M.PURCHASE_NET_MONEY;
							m_cost_price_system = GET_PRODUCT_M.PURCHASE_NET_SYSTEM;
							m_cost_price_system_money = GET_PRODUCT_M.PURCHASE_NET_SYSTEM_MONEY;
							m_purchase_extra_cost_system = GET_PRODUCT_M.PURCHASE_EXTRA_COST_SYSTEM;
						}
					</cfscript>
					<!--- --->
					<cfscript>
						form_barcode = BARCOD;
						form_product_id = PRODUCT_ID;
						form_stock_id = STOCK_ID;
						form_lot_no = LOT_NO;
						
					/*	if (isdefined("attributes.amount") and len(attributes.amount) and (IS_FREE_AMOUNT neq 1))
							{form_amount = attributes.amount;}
						else
							{form_amount = AMOUNT;}*/
							
						if(IS_FREE_AMOUNT == 1)
							form_amount = amount;
						else
							form_amount = miktar_*amount/get_det_po.amount; // sarf miktar hesaplaması eklend PY 0615
						form_is_production_spect_exit = IS_PRODUCTION;
						form_unit_id = PRODUCT_UNIT_ID;
						form_unit = MAIN_UNIT;
						form_kdv_amount = TAX;
						form_product_name = PRODUCT_NAME;
						form_spec_main_id = SPEC_MAIN_ID;
						form_wrk_row_id = WRK_ROW_ID;
						if(SPECT_VAR_ID neq 0)
							form_spect_id = SPECT_VAR_ID;
						else
							form_spect_id = '';
						if(form_spec_main_id gt 0){
						specNameSqlStr="SELECT SPECT_MAIN_NAME FROM SPECT_MAIN  WHERE SPECT_MAIN_ID =#form_spec_main_id#";
						specNameSqlQuery = cfquery(SQLString : specNameSqlStr, Datasource : dsn3);
							if(specNameSqlQuery.recordcount)
								form_spect_name = specNameSqlQuery.SPECT_MAIN_NAME;
							else
								form_spect_name ='';
						}
						else
							form_spect_name ='';
						form_cost_id = m_cost_id;
						form_product_cost=m_product_cost;
						form_product_cost_money=m_product_cost_money;
						form_cost_price_system = m_cost_price_system;
						form_purchase_extra_cost_system=m_purchase_extra_cost_system;
						form_purchase_extra_cost=m_purchase_extra_cost;
						form_money_system=m_cost_price_system_money;
						form_cost_price=m_cost_price;
						form_money=m_cost_price_money;
						//if(GET_DET_PO.recordcount eq 1)
					//	form_cost_price_system=100;// sonuc ürünü tek satir oldugunda total_cost 100 atandıgı için burdada 100 atanıyor maliyetin tamamı bu ürüne yazıyor
						//else if(not len(form_cost_price_system))form_cost_price_system=0;
						birim_cost=value_price/100;
						birim_cost_extra=value_price_extra/100;
						if(GET_DET_PO.recordcount eq 1)
						{//bir üretim soncu varsa maliyet adede bölünüyorki birim maliyet bulunsun
							deger_value_price=(birim_cost*form_cost_price_system)/form_amount;
							deger_value_price_extra=(birim_cost_extra*form_cost_price_system)/form_amount;
						}else{
							deger_value_price=(birim_cost*form_cost_price_system);
							deger_value_price_extra=(birim_cost_extra*form_cost_price_system);
						}
						deger_value_total_price = deger_value_price * form_amount;
                    </cfscript>
					<cfset wrk_row_id_ = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##ADD_PRODUCTION_ORDER.MAX_ID##form_stock_id#_1'>
					<cfquery name="ADD_ROW_ENTER" datasource="#dsn3#">
						INSERT
						INTO
							PRODUCTION_ORDER_RESULTS_ROW
							(
								TYPE,
								PR_ORDER_ID,
								BARCODE,
								STOCK_ID,
								PRODUCT_ID,
								AMOUNT,
								UNIT_ID,
								NAME_PRODUCT,
								UNIT_NAME,
								SPECT_ID,
								SPEC_MAIN_ID,
								SPECT_NAME,
								COST_ID,
								KDV_PRICE,
								PURCHASE_NET_SYSTEM,
								PURCHASE_NET_SYSTEM_MONEY,
								PURCHASE_EXTRA_COST_SYSTEM,
								PURCHASE_NET_SYSTEM_TOTAL,
								PURCHASE_NET,
								PURCHASE_NET_MONEY,
								PURCHASE_EXTRA_COST,
								PURCHASE_NET_TOTAL,
								WRK_ROW_ID,
                                LOT_NO,
                                WRK_ROW_RELATION_ID
							)
							VALUES
							(
								1,
								#ADD_PRODUCTION_ORDER.MAX_ID#,
								<cfif len(form_barcode)>'#form_barcode#',<cfelse>NULL,</cfif>
								<cfif len(form_stock_id)>#form_stock_id#,<cfelse>NULL,</cfif>
								<cfif len(form_product_id)>#form_product_id#,<cfelse>NULL,</cfif>
								<cfif len(form_amount)>#form_amount#,<cfelse>NULL,</cfif>
								<cfif len(form_unit_id)>#form_unit_id#,<cfelse>NULL,</cfif>
								'#left(form_product_name,75)#',
								'#left(form_unit,75)#',
								<cfif len(form_spect_id)>#form_spect_id#,<cfelse>NULL,</cfif>
								<cfif len(form_spec_main_id)>#form_spec_main_id#,<cfelse>NULL,</cfif>
								<cfif len(form_spect_name)>'#left(form_spect_name,50)#',<cfelse>NULL,</cfif>
								<cfif len(form_cost_id) and (form_cost_id neq 0)>#form_cost_id#<cfelse>NULL</cfif>,
								<cfif len(form_kdv_amount)>#form_kdv_amount#<cfelse>0</cfif>,
                                <cfif isdefined("is_demontaj_")>
									<cfif len(form_cost_price_system)>#form_cost_price_system#<cfelse>0</cfif>,
                                    <cfif len(form_product_cost_money)>'#form_product_cost_money#'<cfelse>'#session.ep.money#'</cfif>,
                                    <cfif len(form_purchase_extra_cost_system)>#form_purchase_extra_cost_system#<cfelse>0</cfif>,
                                    	<cfif len(deger_value_total_price)>#deger_value_total_price#<cfelse>0</cfif>,
                                    <cfif len(form_cost_price)>#form_cost_price#<cfelse>0</cfif>,
                                    <cfif len(form_money)>'#form_money#'<cfelse>'#session.ep.money#'</cfif>,
                                    <cfif len(form_purchase_extra_cost)>#form_purchase_extra_cost#<cfelse>0</cfif>,
                                    	<cfif len(form_cost_price) and len(form_amount)>#form_cost_price*form_amount#<cfelse>0</cfif>,
                                <cfelse>
                                	<cfif len(deger_value_price)>#deger_value_price#<cfelse>0</cfif>,
                                    <cfif len(form_money_system)>'#form_money_system#'<cfelse>'#session.ep.money#'</cfif>,
                                    <cfif len(deger_value_price_extra)>#deger_value_price_extra#<cfelse>0</cfif>,
                                    <cfif len(deger_value_total_price)>#deger_value_total_price#<cfelse>0</cfif>,
                                    <cfif len(form_cost_price)>#form_cost_price#<cfelse>0</cfif>,
                                    <cfif len(form_money)>'#form_money#'<cfelse>'#session.ep.money#'</cfif>,
                                    <cfif len(form_purchase_extra_cost)>#form_purchase_extra_cost#<cfelse>0</cfif>,
                                    <cfif len(form_cost_price) and len(form_amount)>#form_cost_price*form_amount#<cfelse>0</cfif>,
                                </cfif>
								'#wrk_row_id_#',
                                <cfif len(form_lot_no)>'#form_lot_no#'<cfelse>NULL</cfif>,
                                <cfif len(form_wrk_row_id)>'#form_wrk_row_id#'<cfelse>NULL</cfif>
							)				
					</cfquery>
                    <cfscript>
						if(isdefined("is_demontaj_")){
							value_price = value_price + form_cost_price_system_exit * form_amount_exit;
							value_price_extra = value_price_extra + form_purchase_extra_cost_system_exit * form_amount_exit;
						}
					</cfscript>
				</cfloop>
			</cfif>
			<cfquery name="UPD_GEN_PAP" datasource="#dsn3#">
				UPDATE 
					GENERAL_PAPERS
				SET
					PRODUCTION_RESULT_NUMBER = #system_paper_no_add#
				WHERE
					PRODUCTION_RESULT_NUMBER IS NOT NULL
			</cfquery>
			<cfquery name="GET_MAX2" datasource="#dsn3#">
				SELECT MAX(PR_ORDER_ID) AS MAX_ID FROM PRODUCTION_ORDER_RESULTS
			</cfquery>
			<cfif isdefined("attributes.wrk_row_id") and len(attributes.wrk_row_id) and attributes.wrk_row_id gt 0>
				<cfquery name="upd_operation" datasource="#dsn3#">
					UPDATE
						PRODUCTION_ORDER_OPERATIONS
					SET
						PR_ORDER_ID = #ADD_PRODUCTION_ORDER.MAX_ID#
					WHERE
						WRK_ROW_ID = '#attributes.wrk_row_id#'
						AND P_ORDER_ID = #attributes.p_order_id_list#
				</cfquery>
			</cfif>
			<cfquery name="GET_PROCESS_TYPE" datasource="#dsn3#">
				SELECT 
					PROCESS_TYPE,
					IS_ACCOUNT,
					IS_ACCOUNT_GROUP,
					ACTION_FILE_NAME,
					ACTION_FILE_FROM_TEMPLATE,
					ISNULL(IS_DEPT_BASED_ACC,0) IS_DEPT_BASED_ACC
				 FROM 
					SETUP_PROCESS_CAT 
				WHERE 
					PROCESS_CAT_ID = #attributes.process_cat#
			</cfquery>
			<cfif len(get_process_type.action_file_name)><!--- secilen islem kategorisine bir action file eklenmisse --->
				<cf_workcube_process_cat 
					process_cat="#attributes.process_cat#"
					action_id = #p_o_id#
					is_action_file = 1
					action_file_name='#get_process_type.action_file_name#'
					action_page='#request.self#?fuseaction=production.form_add_production_order&upd=#p_o_id#'
					action_db_type = '#dsn3#'
					is_template_action_file = '#get_process_type.action_file_from_template#'>
			</cfif>
		</cftransaction>
		<cf_workcube_process 
			is_upd='1' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_page='#request.self#?fuseaction=production.form_add_production_order&upd=#p_o_id#' 
			action_table='PRODUCTION_ORDERS'
			action_column='P_ORDER_ID'
			action_id='#p_o_id#'
			warning_description = 'Üretim Sonucu : #system_paper_no_add#'
			>
	</cfloop>
		
	<script type="text/javascript">
		if (eval("document.getElementById('p_starts')") != undefined)
		{
			document.getElementById('p_starts').style.display ="none";
			document.getElementById('p_finish').style.display = "";
			alert("Üretimler Başlatıldı!");
		}
    </script>
	<cfif isdefined("attributes.is_prod") and attributes.is_prod eq 1>
		<cfset pr_order_id_new = ADD_PRODUCTION_ORDER.MAX_ID>  
		<cfset no = attributes.no>
		<cfinclude template="add_production_result_to_stock_groups.cfm">
	</cfif>
<cfelse>
	<script type="text/javascript">
		alert("Üretim Emri Bulunamadı!");  
		document.getElementById('b_p_starts').disabled=false;//pasif yaptığımız butonu tekrar aktif hale getiriyoruz  
    </script>    
</cfif>
