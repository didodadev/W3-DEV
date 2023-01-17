<!--- get_basket 11 ve 10 un birleştirilmis hali, alış ve satıs irsaliyeleri icin ortak calısıyor 20080212 --->
<cfif isdefined('attributes.ship_id')>
	<cfquery name="GET_SHIP_ROW" datasource="#dsn2#">
		SELECT
			SH.*,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.STOCK_CODE,
			S.BARCOD,
			S.IS_SERIAL_NO,
			S.MANUFACT_CODE,
			S.STOCK_CODE_2,
			EXC.EXPENSE,
			EXI.EXPENSE_ITEM_NAME
		FROM 
			SHIP_ROW SH
			LEFT JOIN EXPENSE_CENTER AS EXC ON SH.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
			LEFT JOIN EXPENSE_ITEMS AS EXI ON SH.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID,
			#dsn3_alias#.STOCKS S
		WHERE 
			SH.SHIP_ID IN (#attributes.ship_id#) AND 
			SH.STOCK_ID=S.STOCK_ID
			<cfif isdefined("attributes.ship_row_id_list") and len(attributes.ship_row_id_list)>
				AND SH.SHIP_ROW_ID IN (#attributes.ship_row_id_list#)
			</cfif>
		ORDER BY
			SH.SHIP_ROW_ID
	</cfquery><!--- özel rapordan veri çekildiği için SH.SHIP_ID IN() olarak çektim. hgul --->
<cfelseif isdefined("attributes.receiving_detail_id") and len(attributes.receiving_detail_id)>
	<cfif ( isdefined("attributes.order_id_listesi") and len(attributes.order_id_listesi) ) or ( isDefined("attributes.order_create_from_row") and attributes.order_create_from_row eq 1 and isDefined("attributes.order_create_row_list") and len(attributes.order_create_row_list) )> <!--- gelen e-irsaliyede sipariş seçilmiş ise--->
		<cfquery name="GET_SHIP_ROW" datasource="#DSN3#">
			SELECT
				ORDERS.REF_NO,
				ORDERS.LOCATION_ID AS PAPER_LOCATION_ID,
				ORDERS.DELIVER_DEPT_ID AS PAPER_DEPARTMENT_ID,
				ORDERS.ORDER_ID,
				ORDERS.ORDER_NUMBER,	
				ORDERS.SALES_PARTNER_ID,
				ORDERS.DELIVERDATE,		
				ORDERS.PAYMETHOD,
				ORDERS.COMMETHOD_ID,
				ORDERS.OTHER_MONEY AS ORDER_MONEY,
				ORDERS.GENERAL_PROM_ID,
				ORDERS.GENERAL_PROM_LIMIT,
				ORDERS.GENERAL_PROM_AMOUNT,
				ORDERS.GENERAL_PROM_DISCOUNT,
				ORDERS.CARD_PAYMETHOD_ID,
				ORDERS.CARD_PAYMETHOD_RATE,
				ORDERS.ORDER_EMPLOYEE_ID,
				ISNULL(ORDER_ROW.ROW_PROJECT_ID,ORDERS.PROJECT_ID) PROJECT_ID_NEW,
				(SELECT PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS PP WHERE PP.PROJECT_ID = ISNULL(ORDER_ROW.ROW_PROJECT_ID,ORDERS.PROJECT_ID)) PROJECT_HEAD_NEW,
				(SELECT WORK_HEAD FROM #dsn_alias#.PRO_WORKS PW WHERE PW.WORK_ID = ORDER_ROW.ROW_WORK_ID) ROW_WORK_HEAD,
				'' DUE_DATE,
				ORDERS.ORDER_DATE,
				ORDERS.ORDER_DETAIL,
				ORDERS.DELIVER_COMP_ID,
				ORDERS.DELIVER_CONS_ID,
				ORDERS.SUBSCRIPTION_ID,
				ORDERS.SHIP_METHOD,
				ORDER_ROW.*,	
				EXC.EXPENSE,
				EXI.EXPENSE_ITEM_NAME,
				(SELECT E.EMPLOYEE_NAME +' '+E.EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES E WHERE E.EMPLOYEE_ID=ORDER_ROW.BASKET_EMPLOYEE_ID) AS BASKET_EMPLOYEE,
				-1 AS PURCHASE,
				ODR.DEPARTMENT_ID AS DELIVER_DEPT_2,
				ODR.LOCATION_ID AS LOCATION_ID,
				ODR.ORDER_ROW_ID,
				(ODR.AMOUNT-ISNULL(ORDER_ROW.CANCEL_AMOUNT,0)) AS AMOUNT,
				STOCKS.STOCK_CODE,
				STOCKS.STOCK_CODE_2,
				STOCKS.BARCOD,
				STOCKS.MANUFACT_CODE,
				STOCKS.IS_SERIAL_NO,
				STOCKS.IS_INVENTORY,
				STOCKS.IS_PRODUCTION,
				STOCKS.PRODUCT_NAME NAME_PRODUCT,
				STOCKS.PRODUCT_NAME PRODUCT_NAME2,
				'' AS ROW_PAYMETHOD_ID,
				'' AS MARGIN,
				'' SERVICE_ID,
				'' DELIVER_LOC,
				'' DELIVER_DEPT,
				'' PRICE_CAT,
				0 DISCOUNTTOTAL,
				0 TAXTOTAL,
				0 OTHER_MONEY_GROSS_TOTAL,
				ORDER_ROW.GTIP_NUMBER
			FROM 
				ORDERS,
				ORDER_ROW 
				LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON ORDER_ROW.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
				LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON ORDER_ROW.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID,
				ORDER_ROW_DEPARTMENTS ODR,
				STOCKS AS STOCKS
			WHERE 
				ORDERS.ORDER_ID=ORDER_ROW.ORDER_ID AND
				<cfif isdefined('attributes.order_create_from_row') and attributes.order_create_from_row eq 1>
					ORDER_ROW.ORDER_ROW_ID IN (#attributes.order_create_row_list#) AND
				<cfelse>
					ORDER_ROW.ORDER_ID IN (#attributes.order_id_listesi#) AND
				</cfif>
				ORDER_ROW.STOCK_ID = STOCKS.STOCK_ID
				AND ODR.ORDER_ROW_ID = ORDER_ROW.ORDER_ROW_ID 
				AND ORDER_ROW.ORDER_ROW_CURRENCY IN (-6,-7)
			ORDER BY
				ORDERS.ORDER_ID,
				ORDER_ROW.ORDER_ROW_ID
		</cfquery>
	<cfelse>
		<cfset kontrol_row = 0>
		<cfloop from="1" to="#attributes.line_count#" index="x">
			<cfif isdefined("attributes.stock_id_#x#") and len(evaluate("attributes.stock_id_#x#"))>
				<cfset kontrol_row = kontrol_row+1>
			</cfif>
		</cfloop>
		<cfif kontrol_row neq 0>
			<cfquery name="GET_SHIP_ROW" datasource="#dsn2#">
				<cfset count_row = 0>
				<cfloop from="1" to="#attributes.line_count#" index="x">
					<cfif len(evaluate("attributes.stock_id_#x#"))>
						<cfset count_row = count_row + 1>
						SELECT 
							PRODUCT_UNIT.MAIN_UNIT_ID AS UNIT_ID,
							PRODUCT_UNIT.MAIN_UNIT AS UNIT,
							'' UNIT2,
							STOCKS.PRODUCT_NAME NAME_PRODUCT,
							STOCKS.PRODUCT_NAME PRODUCT_NAME2,
							STOCKS.IS_SERIAL_NO,
							STOCKS.STOCK_ID,
							STOCKS.PRODUCT_ID,
							STOCKS.STOCK_CODE,
							STOCKS.STOCK_CODE_2,
							STOCKS.BARCOD,
							STOCKS.IS_INVENTORY,
							STOCKS.IS_PRODUCTION,
							STOCKS.TAX_PURCHASE TAX,
							0 NETTOTAL,
							0 DISCOUNTTOTAL,
							0 TAXTOTAL,
							0 OTHER_MONEY_GROSS_TOTAL,
							'' ACC_CODE,
							'' PRICE_OTHER,
							'' EXPENSE_CENTER_ID,
							'' EXPENSE_ITEM_ID,
							'' SERVICE_ID,
							'' PAYMETHOD_ID,
							'' WRK_ROW_RELATION_ID,
							'' RELATED_ACTION_ID,
							'' RELATED_ACTION_TABLE,
							'' UNIQUE_RELATION_ID,
							'' PROM_RELATION_ID,
							'' SHIP_ID,
							'' EXTRA_COST,
							'' DUE_DATE,
							'' DELIVER_LOC,
							'' DELIVER_DEPT,
							'' PROM_COMISSION,
							'' PROM_COST,
							'' PROM_ID,
							'' IS_COMMISSION,
							'' BASKET_EXTRA_INFO_ID,
							'' SELECT_INFO_EXTRA,
							'' DETAIL_INFO_EXTRA,
							'' BASKET_EMPLOYEE_ID,
							'' PRICE_CAT,
							'' KARMA_PRODUCT_ID,
							'' CATALOG_ID,
							0 NUMBER_OF_INSTALLMENT,			
							'' AS WRK_ROW_ID,
							'' AS WRK_ROW_RELATION_ID,
							'' AS ROW_PAYMETHOD_ID,
							'#session.ep.other_money#' AS MONEY,
							'#session.ep.other_money#' AS OTHER_MONEY,
							0 AS PRICE,
							#evaluate("attributes.quantity_#x#")# AS AMOUNT,
							#evaluate("attributes.quantity_#x#")# AS AMOUNT2,
							0 AS DISCOUNT,
							0 AS DISCOUNT2,
							0 AS DISCOUNT3,
							0 AS DISCOUNT4,
							0 AS DISCOUNT5,
							0 AS DISCOUNT6,
							0 AS DISCOUNT7,
							0 AS DISCOUNT8,
							0 AS DISCOUNT9,
							0 AS DISCOUNT10,
							0 AS DISCOUNT_COST,
							'' AS MARGIN,
							#NOW()# AS DELIVER_DATE,
							'' AS WIDTH_VALUE,
							'' AS DEPTH_VALUE,
							'' AS HEIGHT_VALUE,
							'' AS ROW_PROJECT_ID,
							'' AS ROW_WORK_ID,
							'' COST_PRICE,
							'' EXTRA_PRICE,
							'' EK_TUTAR_PRICE,
							'' EXTRA_PRICE_TOTAL,
							'' EXTRA_PRICE_OTHER_TOTAL,
							'' SHELF_NUMBER,
							'' PRODUCT_MANUFACT_CODE,
							'' OTVTOTAL,
							0 OTV_ORAN,
							0 OTHER_MONEY_VALUE,
							'' SPECT_VAR_ID,
							'' SPECT_VAR_NAME,
							'' LOT_NO,
							'' IS_PROMOTION,
							'' PROM_STOCK_ID,
							'' ROW_EXP_CENTER_ID,
							'' ACTIVITY_ID,
							'' ROW_EXP_ITEM_ID,
							'' ACTIVITY_TYPE_ID,
							'' ROW_ACC_CODE,
							'' REASON_CODE,
							'' OIV_RATE,
							'' BSMV_RATE,
							'' BSMV_AMOUNT,
							'' BSMV_CURRENCY,
							'' OIV_RATE,
							'' OIV_AMOUNT,
							'' TEVKIFAT_RATE,
							'' TEVKIFAT_AMOUNT,
							'' AS GTIP_NUMBER,
							0 AS WEIGHT,
							0 AS SPECIFIC_WEIGHT,
							0 AS VOLUME
						FROM 
							#dsn3_alias#.STOCKS AS STOCKS,
							#dsn3_alias#.PRODUCT_UNIT
						WHERE
							PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
							PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
							STOCKS.STOCK_ID = #evaluate("attributes.stock_id_#x#")#
							<cfif count_row neq kontrol_row>
								UNION ALL
							</cfif>
					</cfif>
				</cfloop>
			</cfquery>
		<cfelse>
		</cfif>
	</cfif>
</cfif>

<cfset basket_emp_id_list = "">
<cfset row_project_id_list_ = "">
<cfset row_work_id_list_ = "">
<cfif isDefined("GET_SHIP_ROW")>
	<cfset basket_emp_id_list=listsort(ListDeleteDuplicates(valuelist(GET_SHIP_ROW.BASKET_EMPLOYEE_ID)),'numeric','asc',',')>
	<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_SHIP_ROW.ROW_PROJECT_ID)),'numeric','asc',',')>
	<cfset row_work_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_SHIP_ROW.ROW_WORK_ID)),'numeric','asc',',')>
</cfif>
<cfif len(basket_emp_id_list)>
	<cfquery name="GET_BASKET_EMPLOYEES" datasource="#dsn#">
		SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS BASKET_EMPLOYEE, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#basket_emp_id_list#) ORDER BY EMPLOYEE_ID
	</cfquery>
	<cfset basket_emp_id_list = valuelist(GET_BASKET_EMPLOYEES.EMPLOYEE_ID)> <!--- bulunan kayıtlara gore liste yeniden set ediliyor --->
</cfif>
<cfif len(row_project_id_list_)>
	<cfquery name="GET_ROW_PROJECTS" datasource="#dsn#">
		SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#row_project_id_list_#) ORDER BY PROJECT_ID
	</cfquery>
	<cfset row_project_id_list_=valuelist(GET_ROW_PROJECTS.PROJECT_ID)>
</cfif>
<cfif len(row_work_id_list_)>
	<cfquery name="GET_ROW_WORKS" datasource="#dsn#">
		SELECT WORK_HEAD,WORK_ID FROM PRO_WORKS WHERE WORK_ID IN (#row_work_id_list_#) ORDER BY WORK_ID
	</cfquery>
	<cfset row_work_id_list_=valuelist(GET_ROW_WORKS.WORK_ID)>
</cfif>
<cfscript>
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	sepet.kdv_array = ArrayNew(2);
	sepet.otv_array = ArrayNew(2);
	sepet.total = 0;
	sepet.toplam_indirim = 0;
	sepet.total_tax = 0;
	sepet.total_otv = 0;
	sepet.net_total = 0;
	sepet.genel_indirim = 0;
	if( isdefined("GET_UPD_PURCHASE")){
		sepet.other_money = GET_UPD_PURCHASE.OTHER_MONEY;
	}
	
	if(attributes.basket_id eq 10) //satıs irsaliyesiyse
	{
		if (isnumeric(GET_UPD_PURCHASE.SA_DISCOUNT))
			sepet.genel_indirim = GET_UPD_PURCHASE.SA_DISCOUNT;
		
		if(isdefined("get_upd_purchase.general_prom_id") and len(get_upd_purchase.general_prom_id) and isdefined("get_upd_purchase.general_prom_limit"))
		{
			sepet.general_prom_id = get_upd_purchase.general_prom_id;
			sepet.general_prom_limit = get_upd_purchase.general_prom_limit;
			sepet.general_prom_discount = get_upd_purchase.general_prom_discount;
			sepet.general_prom_amount = get_upd_purchase.general_prom_amount;
		}
		if(isdefined("get_upd_purchase.free_prom_id") and len(get_upd_purchase.free_prom_id))
		{
			sepet.free_prom_id = get_upd_purchase.free_prom_id;
			sepet.free_prom_limit = get_upd_purchase.free_prom_limit;
			sepet.free_prom_amount = get_upd_purchase.free_prom_amount;
			sepet.free_prom_cost = get_upd_purchase.free_prom_cost;
			sepet.free_prom_stock_id = get_upd_purchase.free_prom_stock_id;
			sepet.free_stock_price = get_upd_purchase.free_stock_price;
			sepet.free_stock_money = get_upd_purchase.free_stock_money;
		}
	}
</cfscript>
<cfif isDefined("GET_SHIP_ROW")>
	<cfoutput query="GET_SHIP_ROW">
		<cfscript>
			i = currentrow;
			sepet.satir[i] = StructNew();
			sepet.satir[i].product_id = PRODUCT_ID;
			sepet.satir[i].is_inventory = IS_INVENTORY;
			sepet.satir[i].is_production = IS_PRODUCTION;
			sepet.satir[i].product_name = NAME_PRODUCT;
			sepet.satir[i].amount = AMOUNT;
			sepet.satir[i].unit = UNIT;
			sepet.satir[i].unit_id = UNIT_ID;
			sepet.satir[i].price = PRICE;		
			sepet.satir[i].IS_SERIAL_NO = IS_SERIAL_NO;	

			if(not isdefined('attributes.is_ship_copy') and not (isdefined("attributes.event") and attributes.event is 'copy') and isdefined("RELATED_SHIP_ID") and len(RELATED_SHIP_ID) and len(RELATED_SHIP_PERIOD)) /*satırın ilişkili oldugu konsinye irsaliyenin id si tutuluyor*/
				sepet.satir[i].row_ship_id = '#RELATED_SHIP_ID#;#RELATED_SHIP_PERIOD#';
			else if(not isdefined('attributes.is_ship_copy') and not (isdefined("attributes.event") and attributes.event is 'copy') and isdefined("ROW_ORDER_ID") and len(ROW_ORDER_ID))	/*satırın ilişkili oldugu siparisin id si tutuluyor*/
				sepet.satir[i].row_ship_id = ROW_ORDER_ID;
			else if(( isdefined("attributes.order_id_listesi") and len(attributes.order_id_listesi)) or (isDefined("attributes.order_create_from_row") and attributes.order_create_from_row eq 1 and isDefined("attributes.order_create_row_list") and len(attributes.order_create_row_list)))
				sepet.satir[i].row_ship_id = ORDER_ID;
			else
				sepet.satir[i].row_ship_id = 0;

			if(isdefined('attributes.is_ship_copy')) //irsaliye kopyalama
			{
				sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
				sepet.satir[i].wrk_row_relation_id='';
				sepet.satir[i].related_action_id='';
				sepet.satir[i].related_action_table='';
			}
			else //irsaliye detay
			{
				sepet.satir[i].wrk_row_relation_id = WRK_ROW_RELATION_ID;
				sepet.satir[i].wrk_row_id=WRK_ROW_ID;
				sepet.satir[i].related_action_id=RELATED_ACTION_ID;
				sepet.satir[i].related_action_table=RELATED_ACTION_TABLE;
			}
			if(len(KARMA_PRODUCT_ID)) sepet.satir[i].karma_product_id = KARMA_PRODUCT_ID; else  sepet.satir[i].karma_product_id = '';	
			
			if ( ( isdefined("attributes.order_id_listesi") and len(attributes.order_id_listesi) ) or ( isDefined("attributes.order_create_from_row") and attributes.order_create_from_row eq 1 and isDefined("attributes.order_create_row_list") and len(attributes.order_create_row_list) ))
			{
				if (not len(DISCOUNT_1)) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = DISCOUNT_1;
				if (not len(DISCOUNT_2)) sepet.satir[i].indirim2 = 0; else sepet.satir[i].indirim2 = DISCOUNT_2;
				if (not len(DISCOUNT_3)) sepet.satir[i].indirim3 = 0; else sepet.satir[i].indirim3 = DISCOUNT_3;
				if (not len(DISCOUNT_4)) sepet.satir[i].indirim4 = 0; else sepet.satir[i].indirim4 = DISCOUNT_4;
				if (not len(DISCOUNT_5)) sepet.satir[i].indirim5 = 0; else sepet.satir[i].indirim5 = DISCOUNT_5;
				if (not len(DISCOUNT_6)) sepet.satir[i].indirim6 = 0; else sepet.satir[i].indirim6 = DISCOUNT_6;
				if (not len(DISCOUNT_7)) sepet.satir[i].indirim7 = 0; else sepet.satir[i].indirim7 = DISCOUNT_7;
				if (not len(DISCOUNT_8)) sepet.satir[i].indirim8 = 0; else sepet.satir[i].indirim8 = DISCOUNT_8;
				if (not len(DISCOUNT_9)) sepet.satir[i].indirim9 = 0; else sepet.satir[i].indirim9 = DISCOUNT_9;		
				if (not len(DISCOUNT_10)) sepet.satir[i].indirim10 = 0; else sepet.satir[i].indirim10 = DISCOUNT_10;

				sepet.satir[i].wrk_row_id = "WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
				sepet.satir[i].wrk_row_relation_id = WRK_ROW_ID;

			}else {

				if (not len(DISCOUNT)) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = DISCOUNT;
				if (not len(DISCOUNT2)) sepet.satir[i].indirim2 = 0; else sepet.satir[i].indirim2 = DISCOUNT2;
				if (not len(DISCOUNT3)) sepet.satir[i].indirim3 = 0; else sepet.satir[i].indirim3 = DISCOUNT3;
				if (not len(DISCOUNT4)) sepet.satir[i].indirim4 = 0; else sepet.satir[i].indirim4 = DISCOUNT4;
				if (not len(DISCOUNT5)) sepet.satir[i].indirim5 = 0; else sepet.satir[i].indirim5 = DISCOUNT5;
				if (not len(DISCOUNT6)) sepet.satir[i].indirim6 = 0; else sepet.satir[i].indirim6 = DISCOUNT6;
				if (not len(DISCOUNT7)) sepet.satir[i].indirim7 = 0; else sepet.satir[i].indirim7 = DISCOUNT7;
				if (not len(DISCOUNT8)) sepet.satir[i].indirim8 = 0; else sepet.satir[i].indirim8 = DISCOUNT8;
				if (not len(DISCOUNT9)) sepet.satir[i].indirim9 = 0; else sepet.satir[i].indirim9 = DISCOUNT9;		
				if (not len(DISCOUNT10)) sepet.satir[i].indirim10 = 0; else sepet.satir[i].indirim10 = DISCOUNT10;

			}
			sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);

			sepet.satir[i].row_paymethod_id = row_paymethod_id;
			if (len(COST_PRICE)) sepet.satir[i].net_maliyet = COST_PRICE; else sepet.satir[i].net_maliyet=0;
			if (len(MARGIN)) sepet.satir[i].marj = MARGIN; else sepet.satir[i].marj = 0;
			if(len(DISCOUNT_COST)) sepet.satir[i].iskonto_tutar = DISCOUNT_COST; else sepet.satir[i].iskonto_tutar = 0;
			if (len(EXTRA_COST)) sepet.satir[i].extra_cost = EXTRA_COST; else sepet.satir[i].extra_cost = 0;
			if(len(UNIQUE_RELATION_ID)) sepet.satir[i].row_unique_relation_id = UNIQUE_RELATION_ID; else sepet.satir[i].row_unique_relation_id = "";
			if(len(PROM_RELATION_ID)) sepet.satir[i].prom_relation_id = PROM_RELATION_ID; else sepet.satir[i].prom_relation_id = "";
			if(len(PRODUCT_NAME2)) sepet.satir[i].product_name_other = trim(PRODUCT_NAME2); else sepet.satir[i].product_name_other = "";
			if(len(AMOUNT2)) sepet.satir[i].amount_other = AMOUNT2; else sepet.satir[i].amount_other = "";
			if(len(UNIT2)) sepet.satir[i].unit_other = UNIT2; else sepet.satir[i].unit_other = "";
			if(len(EXTRA_PRICE)) sepet.satir[i].ek_tutar = EXTRA_PRICE; else sepet.satir[i].ek_tutar = 0;

			if(len(EK_TUTAR_PRICE))
			{
				sepet.satir[i].ek_tutar_price = EK_TUTAR_PRICE;
				if(len(AMOUNT2)) sepet.satir[i].ek_tutar_cost = EK_TUTAR_PRICE*AMOUNT2; else sepet.satir[i].ek_tutar_cost = EK_TUTAR_PRICE;
			}
			else
			{ sepet.satir[i].ek_tutar_price = 0;sepet.satir[i].ek_tutar_cost =0;}
			
			if(len(sepet.satir[i].ek_tutar_cost) and sepet.satir[i].ek_tutar_cost neq 0)
				sepet.satir[i].ek_tutar_marj = (sepet.satir[i].ek_tutar*100/sepet.satir[i].ek_tutar_cost)-100;
			else
				sepet.satir[i].ek_tutar_marj ='';
			
			if(len(EXTRA_PRICE_TOTAL)) sepet.satir[i].ek_tutar_total = EXTRA_PRICE_TOTAL; else sepet.satir[i].ek_tutar_total = 0;
			if(len(EXTRA_PRICE_OTHER_TOTAL)) sepet.satir[i].ek_tutar_other_total = EXTRA_PRICE_OTHER_TOTAL; else sepet.satir[i].ek_tutar_other_total = 0;
			if(len(SHELF_NUMBER)) sepet.satir[i].shelf_number = SHELF_NUMBER; else sepet.satir[i].shelf_number = "";
			if(isdefined("TO_SHELF_NUMBER") and len(TO_SHELF_NUMBER)) sepet.satir[i].to_shelf_number = TO_SHELF_NUMBER; else sepet.satir[i].to_shelf_number = "";
			if(len(BASKET_EXTRA_INFO_ID)) sepet.satir[i].basket_extra_info = BASKET_EXTRA_INFO_ID; else sepet.satir[i].basket_extra_info="";
			if(len(SELECT_INFO_EXTRA)) sepet.satir[i].select_info_extra = SELECT_INFO_EXTRA; else sepet.satir[i].select_info_extra="";
			if(len(DETAIL_INFO_EXTRA)) sepet.satir[i].detail_info_extra = DETAIL_INFO_EXTRA; else sepet.satir[i].detail_info_extra="";

			if(isdefined("LIST_PRICE") and len(LIST_PRICE)) sepet.satir[i].list_price = LIST_PRICE; else sepet.satir[i].list_price = PRICE;
			if(len(PRICE_CAT)) sepet.satir[i].price_cat = PRICE_CAT; else  sepet.satir[i].price_cat = '';
			if(len(CATALOG_ID)) sepet.satir[i].row_catalog_id = CATALOG_ID; else  sepet.satir[i].row_catalog_id = '';
			if(len(NUMBER_OF_INSTALLMENT)) sepet.satir[i].number_of_installment = NUMBER_OF_INSTALLMENT; else sepet.satir[i].number_of_installment = 0;
			if(len(DUE_DATE)) sepet.satir[i].duedate = DUE_DATE; else sepet.satir[i].duedate = DUE_DATE;
			if(len(BASKET_EMPLOYEE_ID))
			{	
				sepet.satir[i].basket_employee_id = BASKET_EMPLOYEE_ID; 
				sepet.satir[i].basket_employee = GET_BASKET_EMPLOYEES.BASKET_EMPLOYEE[listfind(basket_emp_id_list,BASKET_EMPLOYEE_ID)]; 
			}
			else
			{		
				sepet.satir[i].basket_employee_id = '';
				sepet.satir[i].basket_employee = '';
			}
			
			sepet.satir[i].spect_id = spect_var_id;
			sepet.satir[i].spect_name = spect_var_name;
			sepet.satir[i].lot_no = LOT_NO;
			sepet.satir[i].row_service_id = service_id;
			sepet.satir[i].paymethod_id = PAYMETHOD_ID;
			sepet.satir[i].stock_id = STOCK_ID;
			sepet.satir[i].barcode = BARCOD;
			sepet.satir[i].special_code = STOCK_CODE_2;
			sepet.satir[i].stock_code = STOCK_CODE;
			sepet.satir[i].manufact_code = PRODUCT_MANUFACT_CODE;
			if(len(TAX))
				sepet.satir[i].tax_percent = TAX;
			else if(NETTOTAL neq 0) 
				sepet.satir[i].tax_percent = (TAXTOTAL/NETTOTAL)*100; 
			else 
				sepet.satir[i].tax_percent = 0;
				
			if(len(OTV_ORAN)) //özel tüketim vergisi
				sepet.satir[i].otv_oran = OTV_ORAN;
			else if(NETTOTAL neq 0 and len(OTVTOTAL) and OTVTOTAL neq 0) 
				sepet.satir[i].otv_oran = (OTVTOTAL/NETTOTAL)*100; 
			else 
				sepet.satir[i].otv_oran = 0;
			//sepet.satir[i].row_total = amount*price;
			
			if(len(NETTOTAL))
			{
				sepet.satir[i].row_total = NETTOTAL+DISCOUNTTOTAL;//amount*price;
				sepet.satir[i].row_nettotal = NETTOTAL;
				sepet.satir[i].row_taxtotal = TAXTOTAL;
				if(len(OTVTOTAL))
				{ 
					sepet.satir[i].row_otvtotal =OTVTOTAL;
					sepet.satir[i].row_lasttotal = NETTOTAL+TAXTOTAL+OTVTOTAL;
				}
				else
				{
					sepet.satir[i].row_otvtotal = 0;
					sepet.satir[i].row_lasttotal = NETTOTAL+TAXTOTAL;
				}
			}else{
				sepet.satir[i].row_total = (sepet.satir[i].amount * sepet.satir[i].price)+sepet.satir[i].ek_tutar_total;
				sepet.satir[i].row_nettotal = (sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan;
				sepet.satir[i].row_taxtotal = sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100);
				
				if(len(OTVTOTAL)) sepet.satir[i].row_otvtotal =OTVTOTAL; else sepet.satir[i].row_otvtotal = 0;
				sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal + sepet.satir[i].row_otvtotal;
			}
			
			
			sepet.satir[i].other_money = OTHER_MONEY;
			if(len(OTHER_MONEY_VALUE)) sepet.satir[i].other_money_value = OTHER_MONEY_VALUE; else sepet.satir[i].other_money_value =0;
			sepet.satir[i].other_money_grosstotal = OTHER_MONEY_GROSS_TOTAL;
			sepet.satir[i].deliver_date = dateformat(DELIVER_DATE,dateformat_style);

			if(len(DELIVER_LOC)) 
				sepet.satir[i].deliver_dept = DELIVER_DEPT & "-" & DELIVER_LOC ; 
			else 
				sepet.satir[i].deliver_dept = DELIVER_DEPT ; 
			
			if(len(PRICE_OTHER)) sepet.satir[i].price_other = PRICE_OTHER; else	sepet.satir[i].price_other = PRICE;
			sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
			sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
			sepet.net_total = sepet.net_total + sepet.satir[i].row_nettotal; //nettotal_ a daha sonra kdv toplam ekleniyor altta
				
			// kdv array
			kdv_flag = 0;
			for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
				{
				if (sepet.kdv_array[k][1] eq sepet.satir[i].tax_percent)
					{
					kdv_flag = 1;
					//sepet.kdv_array[k][2] = sepet.kdv_array[k][2] + 0;
					sepet.kdv_array[k][2] = sepet.kdv_array[k][2] + wrk_round(sepet.satir[i].row_taxtotal,basket_total_round_number);
					if (ListFindNoCase(display_list, "otv_from_tax_price"))
						sepet.kdv_array[k][3] = sepet.kdv_array[k][3] + wrk_round((sepet.satir[i].row_nettotal+sepet.satir[i].row_otvtotal),basket_total_round_number);
					else
						sepet.kdv_array[k][3] = sepet.kdv_array[k][3] + wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);			
					}
				}
			if (not kdv_flag)
				{
				sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = sepet.satir[i].tax_percent;
				sepet.kdv_array[arraylen(sepet.kdv_array)][2] = wrk_round(sepet.satir[i].row_taxtotal,basket_total_round_number);
				//sepet.kdv_array[arraylen(sepet.kdv_array)][2] = 0;
				if (ListFindNoCase(display_list, "otv_from_tax_price"))
					sepet.kdv_array[arraylen(sepet.kdv_array)][3] = wrk_round((sepet.satir[i].row_nettotal+sepet.satir[i].row_otvtotal),basket_total_round_number);
				else
					sepet.kdv_array[arraylen(sepet.kdv_array)][3] = wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);
				}


			otv_flag = 0;
			if(len(gtip_number)) sepet.satir[i].gtip_number=gtip_number; else sepet.satir[i].gtip_number='';
			for (z=1;z lte arraylen(sepet.otv_array);z=z+1)
				{
				if (sepet.otv_array[z][1] eq sepet.satir[i].otv_oran)
					{
					otv_flag = 1;
					sepet.otv_array[z][2] = sepet.otv_array[z][2] + sepet.satir[i].row_otvtotal;
					}
				}
			if (not otv_flag)
				{
				sepet.otv_array[arraylen(sepet.otv_array)+1][1] = sepet.satir[i].otv_oran;
				sepet.otv_array[arraylen(sepet.otv_array)][2] = sepet.satir[i].row_otvtotal;
				}
			sepet.satir[i].assortment_array = ArrayNew(1);// asorti işlemleri duzenlenecek
			
			if (len(PROM_COMISSION)) sepet.satir[i].promosyon_yuzde = PROM_COMISSION; else sepet.satir[i].promosyon_yuzde = '';	
			if (len(PROM_COST)) sepet.satir[i].promosyon_maliyet = PROM_COST; else sepet.satir[i].promosyon_maliyet = 0;
			if(len(IS_PROMOTION)) sepet.satir[i].is_promotion = IS_PROMOTION; else sepet.satir[i].is_promotion = 0;
			if(len(PROM_STOCK_ID)) sepet.satir[i].prom_stock_id = PROM_STOCK_ID; else sepet.satir[i].prom_stock_id ='';
			if(len(PROM_ID)) sepet.satir[i].row_promotion_id =PROM_ID ; else sepet.satir[i].row_promotion_id ='' ;
			if(len(IS_COMMISSION)) sepet.satir[i].is_commission = IS_COMMISSION; else sepet.satir[i].is_commission =0;
			if(len(WIDTH_VALUE)) sepet.satir[i].row_width = WIDTH_VALUE; else sepet.satir[i].row_width = '';
			if(len(DEPTH_VALUE)) sepet.satir[i].row_depth = DEPTH_VALUE; else  sepet.satir[i].row_depth = '';
			if(len(HEIGHT_VALUE)) sepet.satir[i].row_height = HEIGHT_VALUE; else  sepet.satir[i].row_height = '';
			if(len(ROW_PROJECT_ID))
			{
				sepet.satir[i].row_project_id=ROW_PROJECT_ID;
				sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,ROW_PROJECT_ID)];
			}
			if(len(ROW_WORK_ID))
			{
				sepet.satir[i].row_work_id=ROW_WORK_ID;
				sepet.satir[i].row_work_name=GET_ROW_WORKS.WORK_HEAD[listfind(row_work_id_list_,ROW_WORK_ID)];
			}
			/*Masraf Merkezi*/
			if( len(EXPENSE_CENTER_ID) )
			{
				sepet.satir[i].row_exp_center_id = EXPENSE_CENTER_ID;
				sepet.satir[i].row_exp_center_name = EXPENSE;
			}

			//Aktivite Tipi
			sepet.satir[i].row_activity_id = ACTIVITY_TYPE_ID;

			//Bütçe Kalemi
			if( len(EXPENSE_ITEM_ID) )
			{
				sepet.satir[i].row_exp_item_id = EXPENSE_ITEM_ID;
				sepet.satir[i].row_exp_item_name = EXPENSE_ITEM_NAME;
			}

			//Muhasebe Kodu
			if(len(ACC_CODE))
			{
				sepet.satir[i].row_acc_code = ACC_CODE;
			}

			sepet.satir[i].row_oiv_rate = ( len( OIV_RATE ) ) ? OIV_RATE : '';
			sepet.satir[i].row_bsmv_rate = ( len( BSMV_RATE ) ) ? BSMV_RATE : '';
			sepet.satir[i].row_bsmv_currency = ( len( BSMV_CURRENCY ) ) ? BSMV_CURRENCY : '';
			sepet.satir[i].row_tevkifat_rate = ( len( TEVKIFAT_RATE ) ) ? TEVKIFAT_RATE : '';
			sepet.satir[i].row_tevkifat_amount = ( len( TEVKIFAT_AMOUNT ) ) ? TEVKIFAT_AMOUNT : '';
			sepet.satir[i].reason_code = ( len( REASON_CODE ) ) ? REASON_CODE & '--' & REASON_NAME : '';
			sepet.satir[i].row_weight = ( len( WEIGHT ) ) ? WEIGHT : 0;
			sepet.satir[i].row_specific_weight = ( len( SPECIFIC_WEIGHT ) ) ? SPECIFIC_WEIGHT : 0;
			sepet.satir[i].row_volume = ( len( VOLUME ) ) ? VOLUME : 0;
		</cfscript>
	</cfoutput>
</cfif>
<cfscript>
	/*for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
		*/
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
		
	
	for (t=1;t lte arraylen(sepet.otv_array);t=t+1)
		sepet.total_otv = sepet.total_otv + wrk_round(sepet.otv_array[t][2],price_round_number);
	
	sepet.net_total = sepet.net_total + sepet.total_tax + sepet.total_otv;
</cfscript>