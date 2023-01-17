<!--- Toplu Sevkiyattan Irsaliye Olusturmak Icin Kullaniliyor FBS --->
<cfsetting enablecfoutputonly="yes">
<cfprocessingdirective suppresswhitespace="yes">
<cffunction name="add_ship_from_order" returntype="boolean" output="true">
	<cfargument name="order_id" type="numeric">
	<cfargument name="order_wrk_row_id_list" type="string">
	<cfargument name="process_catid" required="yes" type="string">
	<cfargument name="ship_result_id" required="yes" type="string">
	<cfargument name="x_ship_group_dept" required="yes" type="string">
	<cfargument name="cari_db" type="string" default="#dsn2#">
	<cfif not isdefined("butceci")>
		<cfinclude template="get_butceci.cfm">
	</cfif>
	<cfif not isdefined("carici")>
		<cfinclude template="get_carici.cfm">
	</cfif>
	<cfif not isdefined("muhasebeci")>
		<cfinclude template="get_muhasebeci.cfm">
	</cfif>
	<cfif not isdefined("get_consumer_period")>
		<cfinclude template="get_user_accounts.cfm">
	</cfif>
	<cfif not isdefined("basket_kur_ekle")>
		<cfinclude template="get_basket_money_js.cfm">
	</cfif>
	<cfif not isdefined("add_order_row_reserved_stock")>
		<cfinclude template="add_order_row_reserved_stock.cfm">
	</cfif>
	<cfif not isdefined("add_reserve_row")>
		<cfinclude template="add_relation_rows.cfm">
	</cfif>
	<cfif not isdefined("add_stock_rows")>
		<cfinclude template="add_stock_rows.cfm">
	</cfif>
	<cfset function_off = 1>

	<cfset List_Wrk_Row_Id = "">
	<cfif isdefined("arguments.order_id") and Len(arguments.order_id)>
		<cfquery name="get_order_detail" datasource="#arguments.cari_db#">
			SELECT * FROM #dsn3_alias#.ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
		</cfquery>
		<cfquery name="get_order_rows" datasource="#arguments.cari_db#">
			SELECT * FROM #dsn3_alias#.ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
		</cfquery>
	<cfelseif isdefined("arguments.order_wrk_row_id_list") and Len(arguments.order_wrk_row_id_list)>
		<cfloop list="#ListDeleteDuplicates(arguments.order_wrk_row_id_list)#" delimiters=";" index="w">
			<cfset List_Wrk_Row_Id = ListAppend(List_Wrk_Row_Id,ListFirst(w,'_'),',')>
		</cfloop>
		<cfif Len(List_Wrk_Row_Id)>
			<cfquery name="Get_Order_Details" datasource="#arguments.cari_db#">
				SELECT
					1 TYPE,
					<cfif isdefined("arguments.x_ship_group_dept") and arguments.x_ship_group_dept eq 1><!--- depo bazında gruplama seçiliyse --->
						'1_' + CAST(ISNULL(O.COMPANY_ID,0) AS NVARCHAR(10))+ '_' + CAST(ISNULL(O.PROJECT_ID,0) AS NVARCHAR(10)) + '_' +  CAST(ISNULL(O.COUNTY_ID,0) AS NVARCHAR(10))+ '_' +  CAST(ISNULL(ISNULL(OW.DELIVER_DEPT,O.DELIVER_DEPT_ID),0) AS NVARCHAR(10))+ '_' +  CAST(ISNULL(ISNULL(OW.DELIVER_LOCATION,O.LOCATION_ID),0) AS NVARCHAR(10)) MEMBER_ID,
					<cfelse>
						'1_' + CAST(ISNULL(O.COMPANY_ID,0) AS NVARCHAR(10))+ '_' + CAST(ISNULL(O.PROJECT_ID,0) AS NVARCHAR(10)) + '_' +  CAST(ISNULL(O.COUNTY_ID,0) AS NVARCHAR(10)) MEMBER_ID,
					</cfif>
					(SELECT IS_INVENTORY FROM #dsn3_alias#.STOCKS STOCKS WHERE OW.STOCK_ID = STOCK_ID) IS_INVENTORY,
					(SELECT IS_PRODUCTION FROM #dsn3_alias#.STOCKS STOCKS WHERE OW.STOCK_ID = STOCK_ID) IS_PRODUCTION,
					(SELECT PACKAGE_CONTROL_TYPE FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = OW.PRODUCT_ID) CONTROL_TYPE,
					O.SHIP_ADDRESS MULTISHIP_ADDRESS,
					OW.OTHER_MONEY_VALUE ROW_OTHER_MONEY_VALUE,
					OW.OTHER_MONEY ROW_OTHER_MONEY,
					OW.TAX ROW_TAX,
					OW.NETTOTAL ROW_NETTOTAL,
					*					
				FROM
					#dsn3_alias#.ORDERS O,
					#dsn3_alias#.ORDER_ROW OW
				WHERE
					OW.ORDER_ID = O.ORDER_ID AND
					O.CONSUMER_ID IS NULL AND
					<cfif isdefined("attributes.no_send_stock_id_list") and len(attributes.no_send_stock_id_list)>
						OW.STOCK_ID NOT IN (#attributes.no_send_stock_id_list#) AND
					</cfif>
					<cfif isdefined("attributes.no_send_ship_wrk_row_list") and len(attributes.no_send_ship_wrk_row_list)>
						<!--- Burasi kaldirilabilir, simdilik kalsin 20100129 --->
						OW.WRK_ROW_ID NOT IN (#ListQualify(attributes.no_send_ship_wrk_row_list,"'",",","all")#) AND
					</cfif>
					OW.WRK_ROW_ID IN (#ListQualify(List_Wrk_Row_Id,"'",",","all")#)

				UNION ALL

				SELECT
					2 TYPE,
					<cfif isdefined("arguments.x_ship_group_dept") and arguments.x_ship_group_dept eq 1><!--- depo bazında gruplama seçiliyse --->
						'2_' + CAST(ISNULL(O.CONSUMER_ID,0) AS NVARCHAR(10))+ '_' + CAST(ISNULL(O.PROJECT_ID,0) AS NVARCHAR(10)) + '_' +  CAST(ISNULL(O.COUNTY_ID,0) AS NVARCHAR(10))+ '_' +  CAST(ISNULL(ISNULL(OW.DELIVER_DEPT,O.DELIVER_DEPT_ID),0) AS NVARCHAR(10))+ '_' +  CAST(ISNULL(ISNULL(OW.DELIVER_LOCATION,O.LOCATION_ID),0) AS NVARCHAR(10)) MEMBER_ID,
					<cfelse>
						'2_' + CAST(ISNULL(O.CONSUMER_ID,0) AS NVARCHAR(10))+ '_' + CAST(ISNULL(O.PROJECT_ID,0) AS NVARCHAR(10)) + '_' +  CAST(ISNULL(O.COUNTY_ID,0) AS NVARCHAR(10)) MEMBER_ID,
					</cfif>
					(SELECT IS_INVENTORY FROM #dsn3_alias#.STOCKS STOCKS WHERE OW.STOCK_ID = STOCK_ID) IS_INVENTORY,
					(SELECT IS_PRODUCTION FROM #dsn3_alias#.STOCKS STOCKS WHERE OW.STOCK_ID = STOCK_ID) IS_PRODUCTION,
					(SELECT PACKAGE_CONTROL_TYPE FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = OW.PRODUCT_ID) CONTROL_TYPE,
					O.SHIP_ADDRESS MULTISHIP_ADDRESS,
					OW.OTHER_MONEY_VALUE ROW_OTHER_MONEY_VALUE,
					OW.OTHER_MONEY ROW_OTHER_MONEY,
					OW.TAX ROW_TAX,
					OW.NETTOTAL ROW_NETTOTAL,
					*					
				FROM
					#dsn3_alias#.ORDERS O,
					#dsn3_alias#.ORDER_ROW OW
				WHERE
					OW.ORDER_ID = O.ORDER_ID AND
					O.COMPANY_ID IS NULL AND
					<cfif isdefined("attributes.no_send_stock_id_list") and len(attributes.no_send_stock_id_list)>
						OW.STOCK_ID NOT IN (#attributes.no_send_stock_id_list#) AND
					</cfif>
					OW.WRK_ROW_ID IN (#ListQualify(List_Wrk_Row_Id,"'",",","all")#)
				ORDER BY
					TYPE,
					MEMBER_ID
			</cfquery>
			<cfquery name="Get_Ship_Result_Info" datasource="#arguments.cari_db#">
				SELECT
					SR.DEPARTMENT_ID,
					SR.LOCATION_ID,
					SR.SHIP_METHOD_TYPE,
					SR.MAIN_SHIP_FIS_NO,
					SR.DELIVERY_DATE,
					DTP.TEAM_CODE
				FROM
					#dsn2_alias#.SHIP_RESULT SR,
					#dsn3_alias#.DISPATCH_TEAM_PLANNING DTP
				WHERE
					SR.EQUIPMENT_PLANNING_ID = DTP.PLANNING_ID AND
					SR.SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ship_result_id#">
			</cfquery>
		<cfelse>
			Eksik Parametre Girişi !!!
		</cfif>
	<cfelse>
		Eksik Parametre Girişi !!!
		<cfabort>
	</cfif>
	
	<cfset row_ind = 0>
	<!--- order_id_listesi bu siparis irsaliye iliskileri saglanirken irsaliye querysindeki function i calistirmak icin gerekli --->
	<cfset attributes.order_id_listesi = ListSort(ListDeleteDuplicates(ValueList(Get_Order_Details.Order_Id,",")),"numeric","asc",",")>
	<cfoutput query="Get_Order_Details" group="Member_Id">
		<cf_papers paper_type = "ship">
		<cfif len(Get_Order_Details.member_id) and Get_Order_Details.type eq 1>
			<cfquery name="get_member_id" datasource="#arguments.cari_db#">
				SELECT
					COMPANY.COMPANY_ID,
					ISNULL(COMPANY.MANAGER_PARTNER_ID,(SELECT TOP 1 PARTNER_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE COMPANY_ID=COMPANY.COMPANY_ID)) PARTNER_ID,
					COMPANY_PERIOD.ACCOUNT_CODE
				FROM 
					#dsn_alias#.COMPANY,
					#dsn_alias#.COMPANY_PERIOD
				WHERE
					COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(Get_Order_Details.Member_Id,2,'_')#"> AND
					COMPANY_PERIOD.COMPANY_ID = COMPANY.COMPANY_ID AND
					COMPANY_PERIOD.PERIOD_ID = <cfif isdefined("session.ep")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#"></cfif>
			</cfquery>
		<cfelse>
			<cfquery name="get_member_id" datasource="#arguments.cari_db#">
				SELECT
					CONSUMER.CONSUMER_ID,
					CONSUMER_PERIOD.ACCOUNT_CODE
				FROM 
					#dsn_alias#.CONSUMER,
					#dsn_alias#.CONSUMER_PERIOD
				WHERE 
					CONSUMER.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(Get_Order_Details.Member_Id,2,'_')#"> AND
					CONSUMER.CONSUMER_ID = CONSUMER_PERIOD.CONSUMER_ID AND
					CONSUMER_PERIOD.PERIOD_ID = <cfif isdefined("session.ep")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#"></cfif>
			</cfquery>
		</cfif>
		<cfquery name="get_money" datasource="#arguments.cari_db#">
			SELECT RATE2,RATE1,MONEY_TYPE FROM #dsn3_alias#.ORDER_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order_Details.Order_Id#">
		</cfquery>
		<cfquery name="get_money_selected" datasource="#arguments.cari_db#">
			SELECT RATE2,RATE1,MONEY_TYPE FROM #dsn3_alias#.ORDER_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order_Details.Order_Id#"> AND IS_SELECTED = 1
		</cfquery>
		<cfscript>
			topla_basket_gross_total = 0;
			topla_basket_net_total = 0;
			topla_basket_discount_total = 0;
			topla_basket_tax_total = 0;
			topla_basket_otv_total = 0;
			
			form.sale_product=1;
			attributes.paper_number = paper_number;
			attributes.ship_number = '#paper_code#-#paper_number#';
			form.ship_number='#paper_code#-#paper_number#';
			ship_number='#paper_code#-#paper_number#';
			attributes.order_id = Get_Order_Details.Order_Id;
			attributes.process_cat=arguments.process_catid;
			form.process_cat=arguments.process_catid;
			get_process_type.IS_STOCK_ACTION=1;
			'ct_process_type_#arguments.process_catid#'=arguments.process_catid;
			if(isdefined("arguments.x_ship_group_dept") and arguments.x_ship_group_dept eq 1)//depo bazında gruplama seçili ise
			{
				if(ListGetAt(Get_Order_Details.Member_Id,5,'_') neq 0)
				{
					attributes.department_id=ListGetAt(Get_Order_Details.Member_Id,5,'_');
					attributes.location_id=ListGetAt(Get_Order_Details.Member_Id,6,'_');
				}
				else
				{
					attributes.department_id=Get_Ship_Result_Info.Department_Id;
					attributes.location_id=Get_Ship_Result_Info.Location_Id;
				}
			}
			else
			{
				attributes.department_id=Get_Ship_Result_Info.Department_Id;
				attributes.location_id=Get_Ship_Result_Info.Location_Id;
			}
			attributes.ship_method=Get_Ship_Result_Info.Ship_Method_Type;
			attributes.ref_no = Get_Ship_Result_Info.Team_Code;

			if(len(Get_Order_Details.Member_Id) and Get_Order_Details.Type eq 1)
			{
				attributes.company_id=ListGetAt(Get_Order_Details.Member_Id,2,'_');
				attributes.comp_name='a';
				attributes.partner_id=Get_Order_Details.partner_id;
				attributes.partner_name='b';
				attributes.consumer_id='';
			}
			else
			{
				attributes.company_id='';
				attributes.comp_name='a';
				attributes.partner_id='';
				attributes.partner_name='b';
				attributes.consumer_id=ListGetAt(Get_Order_Details.Member_Id,2,'_');
			}
			attributes.consumer_reference_code=Get_Order_Details.CONSUMER_REFERENCE_CODE;
			attributes.partner_reference_code=Get_Order_Details.PARTNER_REFERENCE_CODE;
			
			if(isdefined("attributes.ship_out_date") and isdate(attributes.ship_out_date))
				attributes.ship_date=dateformat(attributes.ship_out_date,dateformat_style);
			else
				attributes.ship_date=dateformat(Get_Order_Details.ORDER_DATE,dateformat_style);
			
			if(Len(Get_Ship_Result_Info.Delivery_Date) and isDate(Get_Ship_Result_Info.Delivery_Date))
				attributes.deliver_date_frm=dateformat(Get_Ship_Result_Info.Delivery_Date,dateformat_style);
			else if(isdefined("attributes.ship_out_date") and isdate(attributes.ship_out_date))
				attributes.deliver_date_frm=dateformat(attributes.ship_out_date,dateformat_style);
			else
				attributes.deliver_date_frm=dateformat(Get_Order_Details.ORDER_DATE,dateformat_style);

			attributes.kasa='';
			kasa='';
			attributes.member_account_code=GET_MEMBER_ID.ACCOUNT_CODE;
			note=Get_Order_Details.ORDER_DETAIL;
			attributes.city_id=Get_Order_Details.CITY_ID;
			attributes.county_id=Get_Order_Details.COUNTY_ID;
			attributes.adres=Get_Order_Details.MULTISHIP_ADDRESS;
			adres = Get_Order_Details.MULTISHIP_ADDRESS;
			for(stp_mny=1;stp_mny lte GET_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
			{
				'attributes.hidden_rd_money_#stp_mny#'=GET_MONEY.MONEY_TYPE[stp_mny];
				'attributes.txt_rate1_#stp_mny#'=GET_MONEY.RATE1[stp_mny];	
				'attributes.txt_rate2_#stp_mny#'=GET_MONEY.RATE2[stp_mny];
			}
			form.basket_money=GET_MONEY_SELECTED.MONEY_TYPE;
			attributes.basket_money=GET_MONEY_SELECTED.MONEY_TYPE;
			form.basket_rate1=GET_MONEY_SELECTED.RATE1;
			form.basket_rate2=GET_MONEY_SELECTED.RATE2;
			attributes.kur_say=GET_MONEY.RECORDCOUNT;
			if(Get_Order_Details.purchase_sales eq 0 and Get_Order_Details.order_zone eq 0)//alis
			{
				attributes.basket_id = 11;
				attributes.form_add = 1;
				attributes.basket_sub_id = 4;
			}
			else //satis
			{
				attributes.basket_id = 10;
				attributes.form_add = 1;
			}
			attributes.list_payment_row_id='';
			attributes.subscription_id='';
			attributes.ship_counter_number='';
			attributes.commethod_id='';
			attributes.bool_from_control_bill='';
			attributes.invoice_control_id='';
			attributes.contract_row_ids='';
			attributes.card_paymethod_id=Get_Order_Details.CARD_PAYMETHOD_ID;
			attributes.commission_rate=Get_Order_Details.CARD_PAYMETHOD_RATE;
			attributes.paymethod_id=Get_Order_Details.PAYMETHOD;
			attributes.project_id=Get_Order_Details.PROJECT_ID;
			attributes.project_head='aa';
			EMPO_ID=Get_Order_Details.ORDER_EMPLOYEE_ID;
			PARTO_ID=Get_Order_Details.SALES_PARTNER_ID;
			form.deliver_get='';		
				
			inventory_product_exists = 0;
			attributes.yuvarlama='';
			attributes.tevkifat_oran=0;
			attributes.is_general_prom=0;
			attributes.indirim_total='100000000000000000000,100000000000000000000';
			attributes.general_prom_limit='';
			attributes.general_prom_discount='';
			attributes.general_prom_amount=0;
			attributes.free_prom_limit='';
			attributes.flt_net_total_all=0;
			attributes.currency_multiplier = '';
			attributes.basket_member_pricecat='';
			attributes.basket_due_value_date_=dateformat(Get_Order_Details.DUE_DATE,dateformat_style);
			attributes.BASKET_PRICE_ROUND_NUMBER = 4;
			
			xml_tax_count=1;//kdv sayısı
			xml_otv_count=1;//otv sayısı
		</cfscript>
		
		<cfset row_info = 0>
		<cfoutput><!--- CfOutput Group Icin Kullanilan 2. Output Silinmesin !!! --->
			<cfset row_ind = row_ind + 1>
			<cfset row_info = row_info + 1>
			<!--- Miktarlar Sevkiyattan Gonderiliyor --->
			<cfset OrderWrkRowId  = Get_Order_Details.wrk_row_id[row_ind]>
			<cfloop list="#ListDeleteDuplicates(arguments.order_wrk_row_id_list)#" delimiters=";" index="xx">
				<!--- Compare text ifadeleri karsilastirmak icin kullaniliyor, listfind gibi --->
				<cfif compare(ListFirst(xx,'_'),OrderWrkRowId) eq 0>
					<cfset 'attributes.amount#row_info#'= ListLast(xx,'_')>
				</cfif>
			</cfloop>

			<cfscript>
				price_round_number = 4; //duzenlenecekkkkkkkkkkkkkk
				/* Burasi siparisleri getiriyordu, kaldirildi, ekip bilgileri gelecek sekilde duzenlendi fbs 20100223
				if(not ListFind(attributes.ref_no,Get_Order_Details.ORDER_NUMBER,',')) 
					attributes.ref_no = attributes.ref_no & ',' & Get_Order_Details.ORDER_NUMBER;
				*/
				'attributes.deliver_date#row_info#'=Get_Order_Details.DELIVER_DATE[row_ind];
				'attributes.deliver_dept#row_info#'=""; //Get_Order_Details.DELIVER_DEPT[row_ind]
				'attributes.duedate#row_info#'=Get_Order_Details.DUEDATE[row_ind];
				'attributes.ek_tutar#row_info#'=Get_Order_Details.EK_TUTAR_PRICE[row_ind];
				if(len(Get_Order_Details.EXTRA_PRICE_TOTAL[row_ind])) 'attributes.ek_tutar_total#row_info#'=Get_Order_Details.EXTRA_PRICE_TOTAL[row_ind]; else 'attributes.ek_tutar_total#row_info#'=0;
				if(len(Get_Order_Details.EXTRA_PRICE_OTHER_TOTAL[row_ind])) 'attributes.ek_tutar_other_total#row_info#'=Get_Order_Details.EXTRA_PRICE_OTHER_TOTAL[row_ind]; else 'attributes.ek_tutar_other_total#row_info#'=0;
				if(Len(Get_Order_Details.ROW_TAX[row_ind]))
				{
					'attributes.tax#row_info#'=Get_Order_Details.ROW_TAX[row_ind];
					'attributes.tax_percent#row_info#'=Get_Order_Details.ROW_TAX[row_ind];
				}
				else
				{
					'attributes.tax#row_info#' = 0;
					'attributes.tax_percent#row_info#' = 0;
				}
				'attributes.row_unique_relation_id#row_info#'=Get_Order_Details.UNIQUE_RELATION_ID[row_ind];
				'attributes.shelf_number#row_info#'=Get_Order_Details.SHELF_NUMBER[row_ind];
				'attributes.spect_id#row_info#'=Get_Order_Details.SPECT_VAR_ID[row_ind];
				'attributes.spect_name#row_info#'=Get_Order_Details.SPECT_VAR_NAME[row_ind];
				'attributes.stock_id#row_info#'=Get_Order_Details.STOCK_ID[row_ind];
				'attributes.unit#row_info#'=Get_Order_Details.UNIT[row_ind];
				'attributes.unit_id#row_info#'=Get_Order_Details.UNIT_ID[row_ind];
				'attributes.price_cat#row_info#'=Get_Order_Details.PRICE_CAT[row_ind];
				'attributes.unit_other#row_info#'=Get_Order_Details.UNIT2[row_ind];
				'attributes.basket_employee_id#row_info#'=Get_Order_Details.BASKET_EMPLOYEE_ID[row_ind];
				'attributes.basket_extra_info#row_info#'=Get_Order_Details.BASKET_EXTRA_INFO_ID[row_ind];
				'attributes.select_info_extra#row_info#'=Get_Order_Details.SELECT_INFO_EXTRA[row_ind];
				'attributes.detail_info_extra#row_info#'=Get_Order_Details.DETAIL_INFO_EXTRA[row_ind];
				'attributes.row_promotion_id#row_info#'=Get_Order_Details.PROM_ID[row_ind];
				'attributes.row_service_id#row_info#'='';
				
				'attributes.extra_cost#row_info#'=Get_Order_Details.EXTRA_COST[row_ind];
				'attributes.indirim1#row_info#'=Get_Order_Details.DISCOUNT_1[row_ind];
				'attributes.indirim2#row_info#'=Get_Order_Details.DISCOUNT_2[row_ind];
				'attributes.indirim3#row_info#'=Get_Order_Details.DISCOUNT_3[row_ind];
				'attributes.indirim4#row_info#'=Get_Order_Details.DISCOUNT_4[row_ind];
				'attributes.indirim5#row_info#'=Get_Order_Details.DISCOUNT_5[row_ind];
				'attributes.indirim6#row_info#'=Get_Order_Details.DISCOUNT_6[row_ind];
				'attributes.indirim7#row_info#'=Get_Order_Details.DISCOUNT_7[row_ind];
				'attributes.indirim8#row_info#'=Get_Order_Details.DISCOUNT_8[row_ind];
				'attributes.indirim9#row_info#'=Get_Order_Details.DISCOUNT_9[row_ind];
				'attributes.indirim10#row_info#'=Get_Order_Details.DISCOUNT_10[row_ind];
				'attributes.indirim_carpan#row_info#' = (100-Evaluate('attributes.indirim1#row_info#')) * (100-Evaluate('attributes.indirim2#row_info#')) * (100-Evaluate('attributes.indirim3#row_info#')) * (100-Evaluate('attributes.indirim4#row_info#')) * (100-Evaluate('attributes.indirim5#row_info#')) * (100-Evaluate('attributes.indirim6#row_info#')) * (100-Evaluate('attributes.indirim7#row_info#')) * (100-Evaluate('attributes.indirim8#row_info#')) * (100-Evaluate('attributes.indirim9#row_info#')) * (100-Evaluate('attributes.indirim10#row_info#'));
				
				
				'attributes.iskonto_tutar#row_info#'=Get_Order_Details.DISCOUNT_COST[row_ind];
				'attributes.is_commission#row_info#'=Get_Order_Details.IS_COMMISSION[row_ind];
				'attributes.is_inventory#row_info#'=Get_Order_Details.is_inventory;
				if(Get_Order_Details.is_inventory)	inventory_product_exists = 1;
				'attributes.is_production#row_info#'=Get_Order_Details.IS_PRODUCTION;
	
				'attributes.is_promotion#row_info#'=Get_Order_Details.IS_PROMOTION[row_ind];
				'attributes.karma_product_id#row_info#'=Get_Order_Details.KARMA_PRODUCT_ID[row_ind];
				if(Len(Get_Order_Details.LIST_PRICE[row_ind])) 'attributes.list_price#row_info#'=Get_Order_Details.LIST_PRICE[row_ind]; else 'attributes.list_price#row_info#'= Get_Order_Details.PRICE[row_ind];
				'attributes.lot_no#row_info#'=Get_Order_Details.LOT_NO[row_ind];
				'attributes.manufact_code#row_info#'=Get_Order_Details.PRODUCT_MANUFACT_CODE[row_ind];
				'attributes.marj#row_info#'=Get_Order_Details.MARJ[row_ind];
				'attributes.net_maliyet#row_info#'=Get_Order_Details.COST_PRICE[row_ind];
				'attributes.number_of_installment#row_info#'=Get_Order_Details.NUMBER_OF_INSTALLMENT[row_ind];
				'attributes.order_currency#row_info#'=Get_Order_Details.ORDER_ROW_CURRENCY[row_ind];
				'attributes.product_account_code#row_info#'='';
				'attributes.product_id#row_info#'=Get_Order_Details.PRODUCT_ID[row_ind];
				'attributes.product_name#row_info#'=Get_Order_Details.PRODUCT_NAME[row_ind];
				'attributes.product_name_other#row_info#'=Get_Order_Details.PRODUCT_NAME2[row_ind];
				'attributes.promosyon_maliyet#row_info#'=Get_Order_Details.PROM_COST[row_ind];
				'attributes.promosyon_yuzde#row_info#'=Get_Order_Details.PROM_COMISSION[row_ind];
				'attributes.prom_relation_id#row_info#'=Get_Order_Details.PROM_RELATION_ID[row_ind];
				'attributes.prom_stock_id#row_info#'=Get_Order_Details.PROM_STOCK_ID[row_ind];
				'attributes.reserve_date#row_info#'=Get_Order_Details.RESERVE_DATE[row_ind];
				'attributes.reserve_type#row_info#'=Get_Order_Details.RESERVE_TYPE[row_ind];

				'attributes.otv_oran#row_info#'=Get_Order_Details.OTV_ORAN[row_ind];
				'attributes.price#row_info#'=Get_Order_Details.PRICE[row_ind];
				'attributes.price_other#row_info#'=Get_Order_Details.PRICE_OTHER[row_ind];
				'attributes.other_money_#row_info#'=Get_Order_Details.ROW_OTHER_MONEY[row_ind];
				'attributes.row_total#row_info#'=(Evaluate('attributes.amount#row_info#') * Evaluate('attributes.price#row_info#')) + Evaluate('attributes.ek_tutar_total#row_info#');
				if(Len(Get_Order_Details.ROW_OTHER_MONEY_VALUE[row_ind]) and Get_Order_Details.ROW_OTHER_MONEY_VALUE[row_ind] gt 0)
					'attributes.other_money_value_#row_info#' = ((Get_Order_Details.ROW_OTHER_MONEY_VALUE[row_ind] / Get_Order_Details.QUANTITY[row_ind]) * Evaluate('attributes.amount#row_info#'));
				else
					'attributes.other_money_value_#row_info#'=0;
				'attributes.other_money_gross_total#row_info#'= Evaluate('attributes.other_money_value_#row_info#') + ((Evaluate('attributes.other_money_value_#row_info#')*Evaluate('attributes.tax_percent#row_info#'))/100);

				'attributes.row_nettotal#row_info#'= wrk_round((Evaluate('attributes.row_total#row_info#')/100000000000000000000)*Evaluate('attributes.indirim_carpan#row_info#'),price_round_number);
				'attributes.row_taxtotal#row_info#'=wrk_round(Evaluate('attributes.row_nettotal#row_info#')*(Evaluate('attributes.tax_percent#row_info#')/100),price_round_number);
				if(Get_Order_Details.OTVTOTAL[row_ind])
					'attributes.row_otvtotal#row_info#'=Get_Order_Details.OTVTOTAL[row_ind];
				else
					'attributes.row_otvtotal#row_info#' = 0;
					
				'attributes.row_lasttotal#row_info#'=(Evaluate('attributes.row_nettotal#row_info#') + Evaluate('attributes.row_taxtotal#row_info#')) + Evaluate('attributes.row_otvtotal#row_info#');
				
				topla_basket_gross_total = topla_basket_gross_total + Evaluate('attributes.row_total#row_info#');
				topla_basket_net_total = topla_basket_net_total + Evaluate('attributes.row_nettotal#row_info#');
				topla_basket_discount_total = topla_basket_discount_total + (wrk_round(Evaluate('attributes.row_total#row_info#'),price_round_number) - wrk_round(Evaluate('attributes.row_nettotal#row_info#'),price_round_number));

				//Onemli Wrk_vb Kontrolleri
				'attributes.row_ship_id#row_info#'=Get_Order_Details.ORDER_ID[row_ind];
				if(isdefined('session.pp.userid'))
					'attributes.wrk_row_id#row_info#'="WRK#row_ind##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.pp.userid##round(rand()*100)##row_ind#";
				else if(isdefined('session.ww.userid'))
					'attributes.wrk_row_id#row_info#'="WRK#row_ind##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ww.userid##round(rand()*100)##row_ind#";
				else
					'attributes.wrk_row_id#row_info#'="WRK#row_ind##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##row_ind#";
				'attributes.wrk_row_relation_id#row_info#'=Get_Order_Details.WRK_ROW_ID[row_ind];
				attributes.rows_ = row_info;
			</cfscript>
			<cfscript>
				for(ind_shp_row=1;ind_shp_row lte attributes.rows_;ind_shp_row=ind_shp_row+1)
				{
					//fatura altı indirim varsa ona hesaplanarak satırlara yansıtılıyor
					row_price_=Get_Order_Details.PRICE[ind_shp_row]*Get_Order_Details.QUANTITY[ind_shp_row];
					tmp_tax=0;
					for(ind_tax_count=1;ind_tax_count lte xml_tax_count;ind_tax_count=ind_tax_count+1)
					{
						if(isdefined('form.basket_tax_#ind_tax_count#') and evaluate('form.basket_tax_#ind_tax_count#') eq evaluate('attributes.tax#ind_shp_row#'))
						{
							'form.basket_tax_value_#ind_tax_count#' =evaluate('form.basket_tax_value_#ind_tax_count#') + wrk_round((row_price_/100)*Get_Order_Details.ROW_TAX[ind_shp_row],2);
							topla_basket_tax_total = topla_basket_tax_total + Evaluate('form.basket_tax_value_#ind_tax_count#');
							tmp_tax=1;
							break;
						}
					}
					if(tmp_tax eq 0)
					{
						'form.basket_tax_#xml_tax_count#' = evaluate('attributes.tax#ind_shp_row#');
						'form.basket_tax_value_#xml_tax_count#' =  wrk_round((row_price_/100)*Get_Order_Details.ROW_TAX[ind_shp_row],2);
						topla_basket_tax_total = topla_basket_tax_total + Evaluate('form.basket_tax_value_#xml_tax_count#');
						xml_tax_count=xml_tax_count+1;
					}
					tmp_otv=0;
					for(ind_otv_count=1;ind_otv_count lte xml_otv_count;ind_otv_count=ind_otv_count+1)
					{
						if(isdefined('form.basket_otv_#ind_otv_count#') and evaluate('form.basket_otv_#ind_otv_count#') eq evaluate('attributes.otv_oran#ind_shp_row#'))
						{
							'form.basket_otv_value_#ind_otv_count#'= evaluate('form.basket_otv_value_#ind_otv_count#') + wrk_round((row_price_/100)*Get_Order_Details.OTV_ORAN[ind_shp_row],2);
							topla_basket_otv_total = topla_basket_otv_total + Evaluate('form.basket_otv_value_#ind_otv_count#');
							tmp_otv=1;
							break;
						}
					}
					if(tmp_otv eq 0)	
					{
						'form.basket_otv_#xml_otv_count#'= evaluate('attributes.otv_oran#ind_shp_row#');
						'form.basket_otv_value_#xml_otv_count#'= wrk_round((row_price_/100)*Get_Order_Details.OTV_ORAN[ind_shp_row],2);
						topla_basket_otv_total = topla_basket_otv_total + Evaluate('form.basket_otv_value_#xml_otv_count#');
						xml_otv_count=xml_otv_count+1;
					}
				}
			</cfscript>
			<cfscript>
				//Son toplamlar
				form.genel_indirim=Get_Order_Details.SA_DISCOUNT;
				attributes.genel_indirim=Get_Order_Details.SA_DISCOUNT;
				form.basket_gross_total=topla_basket_gross_total;
				attributes.basket_gross_total=form.basket_gross_total;
				form.basket_net_total=topla_basket_net_total;
				attributes.basket_net_total=form.basket_net_total;
				form.basket_otv_total=topla_basket_otv_total;
				attributes.basket_otv_total=form.basket_otv_total;
				form.basket_tax_total=topla_basket_tax_total;
				attributes.basket_tax_total=form.basket_tax_total;
				attributes.basket_discount_total = topla_basket_discount_total;
				form.basket_discount_total = attributes.basket_discount_total;
	
				form.basket_otv_count = xml_otv_count-1;//otv oran sayısı
				form.basket_tax_count = xml_tax_count-1;//kdv sayısı
			</cfscript>
			
			<cfset xml_import=2>
			<cfif isdefined("session.ep")>
				<cfset form.active_period = session.ep.period_id>
				<cfset attributes.active_period = session.ep.period_id>
			<cfelse>
				<cfset form.active_period = session.pp.period_id>
				<cfset attributes.active_period = session.pp.period_id>
			</cfif>
			
			<cfquery name="Upd_Old_Currency" datasource="#arguments.cari_db#">
				UPDATE
					SHIP_RESULT_ROW
				SET
					OLD_ORDER_ROW_CURRENCY = #Get_Order_Details.ORDER_ROW_CURRENCY[row_ind]#
				WHERE
					SHIP_RESULT_ID = #arguments.ship_result_id# AND
					WRK_ROW_RELATION_ID = '#OrderWrkRowId#'
			</cfquery>
			<cfif Get_Order_Details.ORDER_ROW_CURRENCY[row_ind] eq -5>
				<!--- 
					Asama uretim ise sevk olarak update ediyoruz cunku, irsaliyelestirme yapilirken uretim asamasinda olusan satirlarin asama bilgileri degismiyor, 
					sevk gibi gerekirse kapatilmali ya da eksik, fazla teslimat degisimleri ile miktarlar da guncellenmeli kendisi otomatik olarak
				 --->
				<cfquery name="Upd_Order_Row_Currency" datasource="#arguments.cari_db#">
					UPDATE #dsn3_alias#.ORDER_ROW SET ORDER_ROW_CURRENCY = -6 WHERE ORDER_ROW_CURRENCY = -5 AND ORDER_ID = #Get_Order_Details.Order_Id# AND WRK_ROW_ID = '#Get_Order_Details.Wrk_Row_Id#' 
				</cfquery>
			</cfif>
		
			<!--- Bilesenleri Update Ediliyor --->
			<cfif Get_Order_Details.Control_Type eq 2 and Len(Get_Order_Details.Spect_Var_Id)>
				<cfquery name="Get_Spects_Row" datasource="#dsn2#">
					SELECT * FROM #dsn3_alias#.SPECTS_ROW WHERE SPECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order_Details.Spect_Var_Id#"> AND IS_PROPERTY IN (0,4) AND STOCK_ID IS NOT NULL
				</cfquery>
				<cfloop query="Get_Spects_Row">
					<cfquery name="Upd_Ship_Result_Row_Component_Id" datasource="#arguments.cari_db#">
						UPDATE SHIP_RESULT_ROW_COMPONENT SET SHIP_RESULT_ROW_AMOUNT = #filterNum(Evaluate("attributes.spect_to_ship_amount_#Get_Order_Details.Wrk_Row_Id#_#Get_Spects_Row.Spect_Row_Id#"))# WHERE  SHIP_RESULT_ID = #arguments.ship_result_id# AND WRK_ROW_RELATION_ID = '#Get_Order_Details.Wrk_Row_Id#' AND COMPONENT_SPECT_ROW_ID = #Get_Spects_Row.Spect_Row_Id#
					</cfquery>
				</cfloop>
			</cfif>
			<!--- //Bilesenleri Update Ediliyor --->

		</cfoutput><!--- //CfOutput Group Icin Kullanilan 2. Output Silinmesin !!! --->
		
		<!--- Irsaliye Ekleme Querylerine Bulundugu Kosullara Uygun Geliyor --->
		<cfif Get_Order_Details.purchase_sales eq 0 and Get_Order_Details.order_zone eq 0>
			<!--- Alis --->
			<cfinclude template="../../stock/query/add_purchase.cfm">
		<cfelse>
			<!--- Satis --->
			<cfinclude template="../../stock/query/add_sale.cfm">
		</cfif>
		<cfif isdefined("MAX_ID") and len(MAX_ID.IDENTITYCOL)>
			<cfquery name="Get_Related_Ship_Row" datasource="#arguments.cari_db#">
				SELECT WRK_ROW_RELATION_ID,SHIP_ID,AMOUNT FROM SHIP_ROW WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
			</cfquery>
			<cfloop query="Get_Related_Ship_Row">
				<cfquery name="Upd_Ship_Result_Row_Id" datasource="#arguments.cari_db#">
					UPDATE
						SHIP_RESULT_ROW
					SET
						SHIP_ID = #Get_Related_Ship_Row.Ship_Id#,
						SHIP_RESULT_ROW_AMOUNT = #Get_Related_Ship_Row.Amount#
					WHERE
						SHIP_RESULT_ID = #arguments.ship_result_id# AND
						WRK_ROW_RELATION_ID = '#Get_Related_Ship_Row.Wrk_Row_Relation_Id#'
				</cfquery>
			</cfloop>
		</cfif>
	</cfoutput>
	<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_multi_packetship&main_ship_fis_no=#Get_Ship_Result_Info.Main_Ship_Fis_No#" addtoken="no">
	<cfreturn true> 
</cffunction>
</cfprocessingdirective>
<cfsetting enablecfoutputonly="no">
