<cfif isdefined('attributes.stock_id')>
	<cfquery name="get_row_money" dbtype="query">
		SELECT RATE2/RATE1 RATE FROM get_money_bskt WHERE MONEY_TYPE = '#attributes.net_total_money#'
	</cfquery>
	<cfquery name="GET_INVOICE_ROW" datasource="#dsn3#">
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
			STOCKS.PROPERTY,
			STOCKS.IS_INVENTORY,
			STOCKS.IS_PRODUCTION,
			#attributes.invoice_tax# TAX,
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
			<cfif isdefined("x") and isdefined("get_row_money_#x#.rate")>
				#wrk_round(attributes.net_total*evaluate("get_row_money_#x#.rate"))# LIST_PRICE,
			<cfelse>
				#wrk_round(attributes.net_total*get_row_money.rate)# LIST_PRICE,
			</cfif>
			'' PRICE_CAT,
			'' KARMA_PRODUCT_ID,
			'' CATALOG_ID,
			0 NUMBER_OF_INSTALLMENT,			
			'' AS WRK_ROW_ID,
			'' AS WRK_ROW_RELATION_ID,
			'' AS ROW_PAYMETHOD_ID,
			<cfif isdefined("x") and isdefined("get_row_money_#x#.rate")>
				#wrk_round(attributes.net_total*evaluate("get_row_money_#x#.rate"))# PRICE,
			<cfelse>
				#wrk_round(attributes.net_total*get_row_money.rate)# PRICE,
			</cfif>
			1 AS AMOUNT,
			1 AS AMOUNT2,
			#attributes.net_total# AS PRICE_OTHER,
			<cfif isdefined("x") and isdefined("get_row_money_#x#.rate")>
				#wrk_round(attributes.net_total*evaluate("get_row_money_#x#.rate"))# AS NETTOTAL,
			<cfelse>
				#wrk_round(attributes.net_total*get_row_money.rate)# AS NETTOTAL,
			</cfif>
			0 AS PRICE_KDV,
			'#attributes.net_total_money#' AS MONEY,
			'#attributes.net_total_money#' AS OTHER_MONEY,
			#attributes.net_total#+#wrk_round(attributes.net_total)#*#attributes.invoice_tax#/100 AS OTHER_MONEY_GROSS_TOTAL,
			<cfif isdefined("x") and isdefined("get_row_money_#x#.rate")>
				(#wrk_round(attributes.net_total*evaluate("get_row_money_#x#.rate"))#*#attributes.invoice_tax#/100) AS TAXTOTAL,
			<cfelse>
				(#wrk_round(attributes.net_total*get_row_money.rate)#*#attributes.invoice_tax#/100) AS TAXTOTAL,
			</cfif>
			0 AS DISCOUNTTOTAL,
			0 AS DISCOUNT1,
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
			#attributes.project_id# AS ROW_PROJECT_ID,
			'' AS ROW_WORK_ID,
			'' COST_PRICE,
			'' EXTRA_PRICE,
			'' EK_TUTAR_PRICE,
			'' EXTRA_PRICE_TOTAL,
			'' EXTRA_PRICE_OTHER_TOTAL,
			'' SHELF_NUMBER,
			'' PRODUCT_MANUFACT_CODE,
			'' OTVTOTAL,
			'' OTV_ORAN,
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
			'' OTV_TYPE,
			'' OTV_DISCOUNT,
            '' DELIVERY_CONDITION,
            '' CONTAINER_TYPE,
            '' CONTAINER_NUMBER,
            '' CONTAINER_QUANTITY,
            '' DELIVERY_COUNTRY,
            '' DELIVERY_CITY,
            '' DELIVERY_COUNTY,
            '' DELIVERY_TYPE,
            '' GTIP_NUMBER,
			'' SUBSCRIPTION_ID,
			'' ASSETP_ID,
			'' ASSETP,
			'' SUBSCRIPTION_NO,
			'' SUBSCRIPTION_HEAD,
			'' ASSET_P_ID,
			'' ASSET_P,
			'' BSMV_RATE,
			'' BSMV_AMOUNT,
			'' BSMV_CURRENCY,
			'' OIV_RATE,
			'' OIV_AMOUNT,
			'' TEVKIFAT_RATE,
			'' TEVKIFAT_AMOUNT,
			'' VAT_EXCEPTION_ID,
			'' TEVKIFAT_ID,
			0 SPECIFIC_WEIGHT,
			0 WEIGHT,
			0 VOLUME 
		FROM 
			STOCKS AS STOCKS,
			PRODUCT_UNIT
		WHERE
			PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
			STOCKS.STOCK_ID = #attributes.stock_id#
	</cfquery>
	<cfscript>
		if(isdefined('attributes.stoppage_amount')) get_sale_det.STOPAJ = attributes.stoppage_amount; else get_sale_det.STOPAJ = '';
		if(isdefined('attributes.stoppage_rate')) get_sale_det.STOPAJ_ORAN = attributes.stoppage_rate; else get_sale_det.STOPAJ_ORAN = '';
		if(isdefined('attributes.stoppage_rate_id')) get_sale_det.STOPAJ_RATE_ID = attributes.stoppage_rate_id; else get_sale_det.STOPAJ_RATE_ID = '';
		get_sale_det.ROUND_MONEY = 0;
		get_sale_det.OTHER_MONEY = attributes.net_total_money;
		get_sale_det.general_prom_id = '';
		get_sale_det.free_prom_id = '';
		get_sale_det.sa_discount = '';
		get_sale_det.TEVKIFAT = 0;
		default_basket_money_ = attributes.net_total_money;
	</cfscript>
<cfelseif isdefined("attributes.receiving_detail_id") and len(attributes.receiving_detail_id)>
	<cfif isdefined("attributes.order_id_listesi") and len(attributes.order_id_listesi)>
		<cfquery name="GET_INVOICE_ROW" datasource="#DSN3#">
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
				'' ROW_EXP_CENTER_ID,
				'' ROW_EXP_ITEM_ID,
				'' VAT_EXCEPTION_ID,
				'' ROW_ACC_CODE,
				'' DELIVERY_CONDITION,
				'' CONTAINER_TYPE,
				'' CONTAINER_NUMBER,
				'' CONTAINER_QUANTITY,
				'' DELIVERY_COUNTRY,
				'' DELIVERY_CITY,
				'' DELIVERY_COUNTY,
				'' DELIVERY_TYPE,
				'' GTIP_NUMBER,
				'' SUBSCRIPTION_ID,
				'' SUBSCRIPTION_NO,
				'' SUBSCRIPTION_HEAD,
				'' ASSETP,
				'' TEVKIFAT_ID,
				0 DISCOUNTTOTAL,
				0 TAXTOTAL,
				0 OTHER_MONEY_GROSS_TOTAL,
				0 AS DISCOUNT1,
				0 AS DISCOUNT2,
				0 AS DISCOUNT3,
				0 AS DISCOUNT4,
				0 AS DISCOUNT5,
				0 AS DISCOUNT6,
				0 AS DISCOUNT7,
				0 AS DISCOUNT8,
				0 AS DISCOUNT9,
				0 AS DISCOUNT10
			FROM 
				ORDERS,
				ORDER_ROW,
				ORDER_ROW_DEPARTMENTS ODR,
				STOCKS AS STOCKS
			WHERE 
				ORDERS.ORDER_ID=ORDER_ROW.ORDER_ID AND
				ORDER_ROW.ORDER_ID IN (#attributes.order_id_listesi#) AND
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
			<cfquery name="GET_INVOICE_ROW" datasource="#dsn3#">
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
							STOCKS.PROPERTY,
							STOCKS.IS_INVENTORY,
							STOCKS.IS_PRODUCTION,
							#evaluate("attributes.tax_#x#")# TAX,
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
							#wrk_round(evaluate("attributes.price_#x#"))# LIST_PRICE,
							'' PRICE_CAT,
							'' KARMA_PRODUCT_ID,
							'' CATALOG_ID,
							0 NUMBER_OF_INSTALLMENT,			
							'' AS WRK_ROW_ID,
							'' AS WRK_ROW_RELATION_ID,
							'' AS ROW_PAYMETHOD_ID,
							#wrk_round(evaluate("attributes.price_#x#"))# PRICE,
							#evaluate("attributes.quantity_#x#")# AS AMOUNT,
							#evaluate("attributes.quantity_#x#")# AS AMOUNT2,
							#evaluate("attributes.price_#x#")# AS PRICE_OTHER,
							#wrk_round(evaluate("attributes.net_total_#x#"))# AS NETTOTAL,
							0 AS PRICE_KDV,
							'#session.ep.other_money#' AS MONEY,
							'#session.ep.other_money#' AS OTHER_MONEY,
							((#evaluate("attributes.net_total_#x#")#+#wrk_round(evaluate("attributes.net_total_#x#"))#*#evaluate("attributes.tax_#x#")#)/100) AS OTHER_MONEY_GROSS_TOTAL,
							(#wrk_round(evaluate("attributes.net_total_#x#"))#*#evaluate("attributes.tax_#x#")#/100) AS TAXTOTAL,
							#wrk_round(evaluate("attributes.net_total_#x#"))*wrk_round(evaluate("attributes.discount_#x#"))/100#  AS DISCOUNTTOTAL,
							#wrk_round(evaluate("attributes.discount_#x#"))# AS DISCOUNT1,
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
							STOCKS.MANUFACT_CODE PRODUCT_MANUFACT_CODE,
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
							'' OTV_TYPE,
							'' OTV_DISCOUNT,
							'' DELIVERY_CONDITION,
							'' CONTAINER_TYPE,
							'' CONTAINER_NUMBER,
							'' CONTAINER_QUANTITY,
							'' DELIVERY_COUNTRY,
							'' DELIVERY_CITY,
							'' DELIVERY_COUNTY,
							'' DELIVERY_TYPE,
							'' GTIP_NUMBER,
							'' SUBSCRIPTION_ID,
							'' ASSETP_ID,
							'' ASSETP,
							'' SUBSCRIPTION_NO,
							'' SUBSCRIPTION_HEAD,
							'' ASSET_P_ID,
							'' ASSET_P,
							'' BSMV_RATE,
							'' BSMV_AMOUNT,
							'' BSMV_CURRENCY,
							'' OIV_RATE,
							'' OIV_AMOUNT,
							'' TEVKIFAT_RATE,
							'' TEVKIFAT_AMOUNT,
							'' VAT_EXCEPTION_ID,
							'' TEVKIFAT_ID,
							0 SPECIFIC_WEIGHT,
							0 WEIGHT,
							0 VOLUME 
						FROM 
							STOCKS AS STOCKS,
							PRODUCT_UNIT
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
			<cfquery name="GET_INVOICE_ROW" datasource="#dsn3#">
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
					STOCKS.PROPERTY,
					STOCKS.IS_INVENTORY,
					STOCKS.IS_PRODUCTION,
					0 TAX,
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
					0 LIST_PRICE,
					'' PRICE_CAT,
					'' KARMA_PRODUCT_ID,
					'' CATALOG_ID,
					0 NUMBER_OF_INSTALLMENT,			
					'' AS WRK_ROW_ID,
					'' AS WRK_ROW_RELATION_ID,
					'' AS ROW_PAYMETHOD_ID,
					0 PRICE,
					0 AS AMOUNT,
					0AS AMOUNT2,
					0 AS PRICE_OTHER,
					0 AS NETTOTAL,
					0 AS PRICE_KDV,
					'#session.ep.other_money#' AS MONEY,
					'#session.ep.other_money#' AS OTHER_MONEY,
					0 AS OTHER_MONEY_GROSS_TOTAL,
					0 AS TAXTOTAL,
					0 AS DISCOUNTTOTAL,
					0 AS DISCOUNT1,
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
					'' OTV_TYPE,
					'' OTV_DISCOUNT,
					'' DELIVERY_CONDITION,
					'' CONTAINER_TYPE,
					'' CONTAINER_NUMBER,
					'' CONTAINER_QUANTITY,
					'' DELIVERY_COUNTRY,
					'' DELIVERY_CITY,
					'' DELIVERY_COUNTY,
					'' DELIVERY_TYPE,
					'' GTIP_NUMBER,
					'' SUBSCRIPTION_ID,
					'' ASSETP_ID,
					'' ASSETP,
					'' SUBSCRIPTION_NO,
					'' SUBSCRIPTION_HEAD,
					'' ASSET_P_ID,
					'' ASSET_P,
					'' BSMV_RATE,
					'' BSMV_AMOUNT,
					'' BSMV_CURRENCY,
					'' OIV_RATE,
					'' OIV_AMOUNT,
					'' TEVKIFAT_RATE,
					'' TEVKIFAT_AMOUNT,
					'' VAT_EXCEPTION_ID,
					'' TEVKIFAT_ID,
					0 SPECIFIC_WEIGHT,
					0 WEIGHT,
					0 VOLUME 
				FROM 
					STOCKS AS STOCKS,
					PRODUCT_UNIT
				WHERE
					PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
					PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
					STOCKS.STOCK_ID = 0
			</cfquery>
		</cfif>
	</cfif>
	<cfscript>
		get_sale_det.STOPAJ = '';
		get_sale_det.STOPAJ_ORAN = '';
		get_sale_det.STOPAJ_RATE_ID = '';
		get_sale_det.ROUND_MONEY = 0;
		if(len(session.ep.other_money))
		{
			get_sale_det.OTHER_MONEY = '#session.ep.other_money#';
			default_basket_money_ = '#session.ep.other_money#';
		}
		else
		{
			get_sale_det.OTHER_MONEY ='TL';
			default_basket_money_='TL';
		}
		get_sale_det.general_prom_id = '';
		get_sale_det.free_prom_id = '';
		get_sale_det.sa_discount = '';
		get_sale_det.TEVKIFAT = 0;
	</cfscript>
<cfelseif not (isDefined("attributes.iid") and Len(attributes.iid)) and isdefined("attributes.convert_products_id") and len(attributes.convert_products_id) and isdefined("attributes.convert_stocks_id") and len(attributes.convert_stocks_id)>
    <cfif isDefined("attributes.convert_round_number")><cfset round_number_ = attributes.convert_round_number><cfelse><cfset round_number_ = basket_total_round_number></cfif>
	<cfloop from="1" to="#listlen(attributes.convert_products_id)#" index="x">
    	<cfif IsDefined("attributes.service_id") and len(attributes.service_id)>
			<cfset 'attributes.net_total_#listgetat(attributes.list_no,x,',')#' = Filternum(evaluate("attributes.net_total_#listgetat(attributes.list_no,x,',')#"))>
            <cfset 'attributes.quantity_#listgetat(attributes.list_no,x,',')#' = Filternum(evaluate("attributes.quantity_#listgetat(attributes.list_no,x,',')#"))>
            <cfset 'attributes.amount#listgetat(attributes.list_no,x,',')#' = Filternum(evaluate("attributes.amount#listgetat(attributes.list_no,x,',')#"))>
        </cfif>
		<cfquery name="get_row_money_#x#" dbtype="query">
			SELECT RATE2/RATE1 RATE FROM get_money_bskt WHERE MONEY_TYPE = '#evaluate("attributes.money_type_#listgetat(attributes.list_no,x,',')#")#'
		</cfquery>
	</cfloop>
	<cfquery name="GET_INVOICE_ROW" datasource="#dsn3#">
		<cfloop from="1" to="#listlen(attributes.convert_products_id)#" index="x">
			SELECT 
				PRODUCT_UNIT.MAIN_UNIT_ID AS UNIT_ID,
				PRODUCT_UNIT.MAIN_UNIT AS UNIT,
				'' UNIT2,
				<cfif isDefined("attributes.name_product_#listgetat(attributes.list_no,x,',')#") and Len(Evaluate("attributes.name_product_#listgetat(attributes.list_no,x,',')#"))>
					'#Evaluate("attributes.name_product_#listgetat(attributes.list_no,x,',')#")#' NAME_PRODUCT,
				<cfelse>
					STOCKS.PRODUCT_NAME NAME_PRODUCT,
				</cfif>
				<cfif isDefined("attributes.product_name_other_#listgetat(attributes.list_no,x,',')#") and Len(Evaluate("attributes.product_name_other_#listgetat(attributes.list_no,x,',')#"))>
					'#Evaluate("attributes.product_name_other_#listgetat(attributes.list_no,x,',')#")#' PRODUCT_NAME2,
				<cfelse>
					STOCKS.PRODUCT_NAME PRODUCT_NAME2,
				</cfif>
				STOCKS.IS_SERIAL_NO,
				STOCKS.STOCK_ID,
				STOCKS.PRODUCT_ID,
				STOCKS.STOCK_CODE,
                STOCKS.STOCK_CODE_2,
				STOCKS.BARCOD,
				STOCKS.PROPERTY,
				STOCKS.IS_INVENTORY,
				STOCKS.IS_PRODUCTION,
              	'#evaluate("attributes.wrk_row_id_#listgetat(attributes.list_no,x,',')#")#' WRK_ROW_RELATION_ID,
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
				<cfif isDefined("attributes.basket_employee_id_#listgetat(attributes.list_no,x,',')#") and Len(Evaluate("attributes.basket_employee_id_#listgetat(attributes.list_no,x,',')#"))>
					'#Evaluate("attributes.basket_employee_id_#listgetat(attributes.list_no,x,',')#")#' BASKET_EMPLOYEE_ID,
				<cfelse>
					'' BASKET_EMPLOYEE_ID,
				</cfif>
 				#wrk_round(evaluate("attributes.net_total_#listgetat(attributes.list_no,x,',')#")*evaluate("get_row_money_#x#.rate"),round_number_)# LIST_PRICE,
				'' PRICE_CAT,
				'' KARMA_PRODUCT_ID,
				'' CATALOG_ID,
				0 NUMBER_OF_INSTALLMENT,			
				'' AS WRK_ROW_ID,
				'' AS WRK_ROW_RELATION_ID,
				'' AS ROW_PAYMETHOD_ID,
				<cfif isDefined("attributes.kdv_rate_#listgetat(attributes.list_no,x,',')#") and Len(Evaluate("attributes.kdv_rate_#listgetat(attributes.list_no,x,',')#"))>
					#evaluate("attributes.kdv_rate_#listgetat(attributes.list_no,x,',')#")# TAX,
				<cfelse>
					0 TAX,
				</cfif>
				<cfif isDefined("attributes.is_report_parameters")>
					<!--- Rapordan Butun Parametreler Gonderildigi Icin Hesaplamaya Girmesine Gerek Yok FBS 20150103 --->
					<cfif isDefined("attributes.price_other_#listgetat(attributes.list_no,x,',')#") and Len(Evaluate("attributes.price_other_#listgetat(attributes.list_no,x,',')#"))>
						#evaluate("attributes.price_other_#listgetat(attributes.list_no,x,',')#")# PRICE_OTHER,
					<cfelse>
						#wrk_round(evaluate("attributes.price_#listgetat(attributes.list_no,x,',')#")/evaluate("get_row_money_#x#.rate"),round_number_)# PRICE_OTHER,
					</cfif>
					#evaluate("attributes.price_#listgetat(attributes.list_no,x,',')#")# AS PRICE,
					#evaluate("attributes.net_total_#listgetat(attributes.list_no,x,',')#")# AS NETTOTAL,
					<cfif isDefined("attributes.grosstotal_#listgetat(attributes.list_no,x,',')#") and Len(evaluate("attributes.grosstotal_#listgetat(attributes.list_no,x,',')#"))>
						#evaluate("attributes.grosstotal_#listgetat(attributes.list_no,x,',')#")# AS GROSSTOTAL,
					</cfif>
					<cfif isDefined("attributes.taxtotal_#listgetat(attributes.list_no,x,',')#") and Len(evaluate("attributes.taxtotal_#listgetat(attributes.list_no,x,',')#"))>
						#evaluate("attributes.taxtotal_#listgetat(attributes.list_no,x,',')#")# AS TAXTOTAL,
					<cfelse>
						0 AS TAXTOTAL,
					</cfif>
					#evaluate("attributes.discount1_#listgetat(attributes.list_no,x,',')#")# AS DISCOUNT1,
					<cfif isDefined("attributes.other_money_gross_total_#listgetat(attributes.list_no,x,',')#") and Len(evaluate("attributes.other_money_gross_total_#listgetat(attributes.list_no,x,',')#"))>
						#evaluate("attributes.other_money_gross_total_#listgetat(attributes.list_no,x,',')#")# AS OTHER_MONEY_GROSS_TOTAL,
					<cfelse>
						0 AS OTHER_MONEY_GROSS_TOTAL,

					</cfif>
					#evaluate("attributes.other_money_value_#listgetat(attributes.list_no,x,',')#")# AS OTHER_MONEY_VALUE,
					'#evaluate("attributes.money_type_#listgetat(attributes.list_no,x,',')#")#' AS OTHER_MONEY,
				<cfelse>
					#listgetat(attributes.convert_price,x)# PRICE_OTHER,				
					#wrk_round(evaluate("#listgetat(attributes.convert_price,x)#")*evaluate("get_row_money_#x#.rate"),round_number_)# PRICE,
					#wrk_round(evaluate("attributes.net_total_#listgetat(attributes.list_no,x,',')#")*evaluate("get_row_money_#x#.rate"),round_number_)# AS NETTOTAL,
					(#wrk_round(evaluate("attributes.net_total_#listgetat(attributes.list_no,x,',')#")*evaluate("get_row_money_#x#.rate"),round_number_)#*#evaluate("attributes.kdv_rate_#listgetat(attributes.list_no,x,',')#")#/100) AS TAXTOTAL,
					0 AS DISCOUNT1,
					((#evaluate("attributes.net_total_#listgetat(attributes.list_no,x,',')#")#+#wrk_round(evaluate("attributes.net_total_#listgetat(attributes.list_no,x,',')#"),round_number_)#*#evaluate("attributes.kdv_rate_#listgetat(attributes.list_no,x,',')#")#)/100) AS OTHER_MONEY_GROSS_TOTAL,
					0 OTHER_MONEY_VALUE,
                    <cfif IsDefined("convert_service_id")>
						'#evaluate("attributes.money_type_#listgetat(attributes.list_no,x,',')#")#' AS OTHER_MONEY,
                    <cfelse>
    					'#session.ep.other_money#' AS OTHER_MONEY,
                    </cfif>
				</cfif>
				#evaluate("attributes.quantity_#listgetat(attributes.list_no,x,',')#")# AS AMOUNT,
				#evaluate("attributes.quantity_#listgetat(attributes.list_no,x,',')#")# AS AMOUNT2,
				0 AS PRICE_KDV,
				'#session.ep.other_money#' AS MONEY,
				0 AS DISCOUNTTOTAL,
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
				<cfif isDefined("attributes.project_id_#listgetat(attributes.list_no,x,',')#") and Len(evaluate("attributes.project_id_#listgetat(attributes.list_no,x,',')#"))>
					#evaluate("attributes.project_id_#listgetat(attributes.list_no,x,',')#")# AS ROW_PROJECT_ID,
				<cfelse>
				'' AS ROW_PROJECT_ID,
				</cfif>
                <cfif isDefined("attributes.work_id_#listgetat(attributes.list_no,x,',')#") and Len(evaluate("attributes.work_id_#listgetat(attributes.list_no,x,',')#"))>
					#evaluate("attributes.work_id_#listgetat(attributes.list_no,x,',')#")# AS ROW_WORK_ID,
				<cfelse>
				'' AS ROW_WORK_ID,
				</cfif>
				'' COST_PRICE,
				'' EXTRA_PRICE,
				'' EK_TUTAR_PRICE,
				'' EXTRA_PRICE_TOTAL,
				'' EXTRA_PRICE_OTHER_TOTAL,
				'' SHELF_NUMBER,
				'' PRODUCT_MANUFACT_CODE,
				'' OTVTOTAL,
				<cfif isDefined("attributes.otv_rate_#listgetat(attributes.list_no,x,',')#") and Len(evaluate("attributes.otv_rate_#listgetat(attributes.list_no,x,',')#"))>
					#evaluate("attributes.otv_rate_#listgetat(attributes.list_no,x,',')#")# OTV_ORAN,
				<cfelse>
					0  AS OTV_ORAN,
				</cfif>
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
				'' OTV_TYPE,
				'' OTV_DISCOUNT,
                '' DELIVERY_CONDITION,
                '' CONTAINER_TYPE,
                '' CONTAINER_NUMBER,
                '' CONTAINER_QUANTITY,
                '' DELIVERY_COUNTRY,
                '' DELIVERY_CITY,
                '' DELIVERY_COUNTY,
                '' DELIVERY_TYPE,
                '' GTIP_NUMBER,
				'' SUBSCRIPTION_ID,
				'' ASSETP_ID,
				'' ASSETP,
				'' SUBSCRIPTION_NO,
				'' SUBSCRIPTION_HEAD,
				'' ASSET_P_ID,
				'' ASSET_P,
				'' BSMV_RATE,
				'' BSMV_AMOUNT,
				'' BSMV_CURRENCY,
				'' OIV_RATE,
				'' OIV_AMOUNT,
				'' TEVKIFAT_RATE,
				'' TEVKIFAT_AMOUNT,
				'' VAT_EXCEPTION_ID,
				'' TEVKIFAT_ID,
				0 SPECIFIC_WEIGHT,
				0 WEIGHT,
				0 VOLUME 
			FROM 
				STOCKS AS STOCKS,
				PRODUCT_UNIT
			WHERE
				PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
				PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
				PRODUCT_UNIT.PRODUCT_ID IN (#evaluate("attributes.product_id_#listgetat(attributes.list_no,x,',')#")#) AND
				STOCKS.STOCK_ID IN (#evaluate("attributes.stock_id_#listgetat(attributes.list_no,x,',')#")#)
				<cfif x neq listlen(attributes.convert_products_id)>
				 UNION ALL
				</cfif>
		</cfloop>
	</cfquery>
	<cfscript>
		get_sale_det.STOPAJ = '';
		get_sale_det.STOPAJ_ORAN = '';
		get_sale_det.STOPAJ_RATE_ID = '';
		get_sale_det.ROUND_MONEY = 0;
		if(len(session.ep.other_money))
		{
			get_sale_det.OTHER_MONEY = '#session.ep.other_money#';
			default_basket_money_ = '#session.ep.other_money#';
		}
		else
		{
			get_sale_det.OTHER_MONEY ='TL';
			default_basket_money_='TL';
		}
		get_sale_det.general_prom_id = '';
		get_sale_det.free_prom_id = '';
		get_sale_det.sa_discount = '';
		get_sale_det.TEVKIFAT = 0;
	</cfscript>
<cfelse>
	<cfif isdefined("attributes.convert_products_id") and len(attributes.convert_products_id) and isdefined("attributes.convert_stocks_id") and len(attributes.convert_stocks_id) and isDefined("attributes.new_period_year") and Len(attributes.new_period_year)>
		<cfset new_dsn2 = "#dsn#_#attributes.new_period_year#_#session.ep.company_id#">
	<cfelse>
		<cfset new_dsn2 = dsn2>
	</cfif>
	 <cfquery name="GET_INVOICE_ROW" datasource="#new_dsn2#">
		SELECT 
			INVOICE_ROW.*,
			STOCKS.IS_SERIAL_NO,
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			STOCKS.STOCK_CODE_2,
			STOCKS.BARCOD,
			STOCKS.PROPERTY,
			STOCKS.IS_INVENTORY,
			STOCKS.IS_PRODUCTION,
			STOCKS.MANUFACT_CODE,
			SC.SUBSCRIPTION_NO,
			SC.SUBSCRIPTION_HEAD,
			ASSP.ASSETP,
			'' TEVKIFAT_ID,
			(SELECT VAT_EXCEPTION_ID FROM INVOICE WHERE INVOICE_ID = INVOICE_ROW.INVOICE_ID) AS VAT_EXCEPTION_ID
		FROM
			INVOICE_ROW
			LEFT JOIN #dsn3#.SUBSCRIPTION_CONTRACT AS SC ON INVOICE_ROW.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID
			LEFT JOIN #dsn#.ASSET_P AS ASSP ON INVOICE_ROW.ASSETP_ID = ASSP.ASSETP_ID,
			#dsn3_alias#.STOCKS AS STOCKS
		WHERE
			INVOICE_ROW.INVOICE_ID = #attributes.iid# AND
			INVOICE_ROW.STOCK_ID = STOCKS.STOCK_ID
		ORDER BY
			INVOICE_ROW_ID
	</cfquery>
</cfif>
<cfset product_id_list=listsort(ListDeleteDuplicates(valuelist(GET_INVOICE_ROW.PRODUCT_ID)),'numeric','asc',',')>
<cfset basket_emp_id_list=listsort(ListDeleteDuplicates(valuelist(GET_INVOICE_ROW.BASKET_EMPLOYEE_ID)),'numeric','asc',',')>
<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_INVOICE_ROW.ROW_PROJECT_ID)),'numeric','asc',',')>
<cfset row_work_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_INVOICE_ROW.ROW_WORK_ID)),'numeric','asc',',')>
<cfset row_expense_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_INVOICE_ROW.ROW_EXP_CENTER_ID)),'numeric','asc',',')>
<cfset row_expense_item_list_=listsort(ListDeleteDuplicates(valuelist(GET_INVOICE_ROW.ROW_EXP_ITEM_ID)),'numeric','asc',',')>
<cfset row_activity_id=listsort(ListDeleteDuplicates(valuelist(GET_INVOICE_ROW.ACTIVITY_TYPE_ID)),'numeric','asc',',')>
<cfif listlen(product_id_list)>
	<cfquery name="get_product_accounts" datasource="#dsn3#">
		SELECT
			PER.ACCOUNT_CODE,
			PER.ACCOUNT_CODE_PUR,
			PER.PRODUCT_ID
		FROM
			PRODUCT_PERIOD PER
		WHERE
			PER.PRODUCT_ID IN (#product_id_list#) AND
			PER.PERIOD_ID = #session_base.period_id#
		ORDER BY
			PER.PRODUCT_ID
	</cfquery>
	<cfset product_id_list=listsort(ListDeleteDuplicates(valuelist(get_product_accounts.PRODUCT_ID)),'numeric','asc',',')>
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
<cfif len(row_expense_id_list_)>
	<cfquery name="GET_ROW_EXP_CENTER" datasource="#dsn2#">
		SELECT EXPENSE_ID,EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#row_expense_id_list_#) ORDER BY EXPENSE_ID
	</cfquery>
	<cfset row_expense_id_list_=valuelist(GET_ROW_EXP_CENTER.EXPENSE_ID)>
</cfif>
<cfif len(row_expense_item_list_)>
	<cfquery name="GET_EXP_ITEM" datasource="#dsn2#">
		SELECT EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#row_expense_item_list_#) ORDER BY EXPENSE_ITEM_ID
	</cfquery>
	<cfset row_expense_item_list_=valuelist(GET_EXP_ITEM.EXPENSE_ITEM_ID)>
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
	sepet.total_tax = 0;
	sepet.otv_array = ArrayNew(2);
	sepet.total_otv = 0;
	sepet.total = 0;
	sepet.toplam_indirim = 0;
	sepet.net_total = 0;
	sepet.genel_indirim = 0;
	sepet.vat_exception_id=GET_INVOICE_ROW.vat_exception_id;
	if(isdefined("attributes.convert_products_id") and len(attributes.convert_products_id) and isdefined("attributes.convert_stocks_id") and len(attributes.convert_stocks_id))
	{
		if(isDefined("attributes.stopaj") and Len(attributes.stopaj)) get_sale_det.STOPAJ = attributes.stopaj; else get_sale_det.STOPAJ = '';
		if(isDefined("attributes.stopaj_yuzde") and Len(attributes.stopaj_yuzde)) get_sale_det.STOPAJ_ORAN = attributes.stopaj_yuzde; else get_sale_det.STOPAJ_ORAN = '';
		if(isDefined("attributes.stopaj_rate_id") and Len(attributes.stopaj_rate_id)) get_sale_det.STOPAJ_RATE_ID = attributes.stopaj_rate_id; else get_sale_det.STOPAJ_RATE_ID = '';
		get_sale_det.ROUND_MONEY = 0;
		if(len(session.ep.other_money))
		{
			get_sale_det.OTHER_MONEY = '#session.ep.other_money#';
			default_basket_money_ = '#session.ep.other_money#';
		}
		else
		{
			get_sale_det.OTHER_MONEY ='TL';
			default_basket_money_='TL';
		}
		get_sale_det.general_prom_id = '';
		get_sale_det.free_prom_id = '';
		get_sale_det.sa_discount = '';
		if(isDefined("attributes.tevkifat_box") and Len(attributes.tevkifat_box)) get_sale_det.tevkifat = attributes.tevkifat_box; else get_sale_det.tevkifat = '';
		if(isDefined("attributes.tevkifat_oran") and Len(attributes.tevkifat_oran)) get_sale_det.tevkifat_oran = attributes.tevkifat_oran; else get_sale_det.tevkifat_oran = '';
		if(isDefined("attributes.tevkifat_id") and Len(attributes.tevkifat_id)) get_sale_det.tevkifat_id = attributes.tevkifat_id; else get_sale_det.tevkifat_id = '';
	}
		
	if(len(get_sale_det.STOPAJ))
		sepet.stopaj = get_sale_det.STOPAJ;
	else
		sepet.stopaj = 0;
	if(len(get_sale_det.STOPAJ_ORAN))
		sepet.stopaj_yuzde = get_sale_det.STOPAJ_ORAN;
	else
		sepet.stopaj_yuzde = 0;
	if(len(get_sale_det.STOPAJ_RATE_ID))
		sepet.stopaj_rate_id = get_sale_det.STOPAJ_RATE_ID;
	else
		sepet.stopaj_rate_id = 0;
	sepet.yuvarlama = get_sale_det.ROUND_MONEY;
	sepet.other_money = get_sale_det.OTHER_MONEY;
	if(len(get_sale_det.general_prom_id) )
	{
		sepet.general_prom_id = get_sale_det.general_prom_id;
		sepet.general_prom_limit = get_sale_det.general_prom_limit;
		sepet.general_prom_discount = get_sale_det.general_prom_discount;
		sepet.general_prom_amount = get_sale_det.general_prom_amount;
	}
	if(len(get_sale_det.free_prom_id) )
	{
		sepet.free_prom_id = get_sale_det.free_prom_id;
		sepet.free_prom_limit = get_sale_det.free_prom_limit;
		sepet.free_prom_amount = get_sale_det.free_prom_amount;
		sepet.free_prom_cost = get_sale_det.free_prom_cost;
		sepet.free_prom_stock_id = get_sale_det.free_prom_stock_id;
		sepet.free_stock_price = get_sale_det.free_stock_price;
		sepet.free_stock_money = get_sale_det.free_stock_money;
	}
 
	if (isnumeric(get_sale_det.sa_discount))
		sepet.genel_indirim = get_sale_det.SA_DISCOUNT;
	if( (get_sale_det.TEVKIFAT eq 1) and len(get_sale_det.TEVKIFAT_ORAN) )
	{
		sepet.tevkifat_box = 1;
		sepet.tevkifat_oran = get_sale_det.TEVKIFAT_ORAN;
		sepet.tevkifat_id = get_sale_det.TEVKIFAT_ID;
	}
</cfscript>
<cfoutput query="get_invoice_row">
	<cfscript>
		i = currentrow;
		sepet.satir[i] = StructNew();
		
		//Kopyalama ve rapordan vs donusturmede Wrk_row_id degeri sifirdan olusmalidir, digerleri icin ornegin guncellemede ayni kalmalidir
		if((isdefined("attributes.event") and (attributes.event is 'copy' or attributes.event is 'add')) or (isdefined("attributes.convert_products_id") and len(attributes.convert_products_id) and isdefined("attributes.convert_stocks_id") and len(attributes.convert_stocks_id)) )
		{
			sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
			if(isdefined("attributes.event") and attributes.event is 'copy')
			{
				sepet.satir[i].wrk_row_relation_id = "";
				
			}
			else
				if(isDefined("attributes.iid") and Len(attributes.iid))
					sepet.satir[i].wrk_row_relation_id = get_invoice_row.wrk_row_id;
				else
					sepet.satir[i].wrk_row_relation_id = get_invoice_row.wrk_row_relation_id;
		}
		else
		{
			sepet.satir[i].wrk_row_id = get_invoice_row.wrk_row_id;
			sepet.satir[i].wrk_row_relation_id = get_invoice_row.wrk_row_relation_id;
		}

		if( (isdefined("attributes.event") and (attributes.event is 'copy' or attributes.event is 'add')) or (isdefined("attributes.convert_products_id") and len(attributes.convert_products_id) and isdefined("attributes.convert_stocks_id") and len(attributes.convert_stocks_id)) )
		{
			sepet.satir[i].related_action_id="";
			sepet.satir[i].related_action_table="";
		}
		else
		{
			sepet.satir[i].related_action_id=RELATED_ACTION_ID;
			sepet.satir[i].related_action_table=RELATED_ACTION_TABLE;	
		}
		
		sepet.satir[i].product_id = PRODUCT_ID;
		sepet.satir[i].is_inventory = IS_INVENTORY;
		sepet.satir[i].is_production = IS_PRODUCTION;
		sepet.satir[i].product_name = NAME_PRODUCT;
		sepet.satir[i].amount = AMOUNT;
		sepet.satir[i].unit = UNIT;
		sepet.satir[i].unit_id = UNIT_ID;
		sepet.satir[i].price = PRICE;	
		if(len(ROW_PAYMETHOD_ID)) sepet.satir[i].row_paymethod_id = ROW_PAYMETHOD_ID; else  sepet.satir[i].row_paymethod_id = '';
		if(sale_product eq 0)
			sepet.satir[i].product_account_code = get_product_accounts.ACCOUNT_CODE_PUR[listfind(product_id_list,PRODUCT_ID,',')];
		else
			sepet.satir[i].product_account_code = get_product_accounts.ACCOUNT_CODE[listfind(product_id_list,PRODUCT_ID,',')];
		if(not (isdefined("attributes.event") and (attributes.event is 'copy' or attributes.event is 'add')) and len(SHIP_ID) and len(SHIP_PERIOD_ID) and SHIP_PERIOD_ID neq 0)/*20050301 kopyalamada irsaliye id ler bos gecilmeli*/
			sepet.satir[i].row_ship_id = '#SHIP_ID#;#SHIP_PERIOD_ID#';
		else if(not (isdefined("attributes.event") and (attributes.event is 'copy' or attributes.event is 'add')) and len(SHIP_ID))
			sepet.satir[i].row_ship_id = SHIP_ID;
		if(len(KARMA_PRODUCT_ID)) sepet.satir[i].karma_product_id =  KARMA_PRODUCT_ID; else sepet.satir[i].karma_product_id = ''; 
		if (not len(DISCOUNT1)) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = DISCOUNT1;
		if (not len(DISCOUNT2)) sepet.satir[i].indirim2 = 0; else sepet.satir[i].indirim2 = DISCOUNT2;
		if (not len(DISCOUNT3)) sepet.satir[i].indirim3 = 0; else sepet.satir[i].indirim3 = DISCOUNT3;
		if (not len(DISCOUNT4)) sepet.satir[i].indirim4 = 0; else sepet.satir[i].indirim4 = DISCOUNT4;
		if (not len(DISCOUNT5)) sepet.satir[i].indirim5 = 0; else sepet.satir[i].indirim5 = DISCOUNT5;
		if (not len(DISCOUNT6)) sepet.satir[i].indirim6 = 0; else sepet.satir[i].indirim6 = DISCOUNT6;
		if (not len(DISCOUNT7)) sepet.satir[i].indirim7 = 0; else sepet.satir[i].indirim7 = DISCOUNT7;
		if (not len(DISCOUNT8)) sepet.satir[i].indirim8 = 0; else sepet.satir[i].indirim8 = DISCOUNT8;
		if (not len(DISCOUNT9)) sepet.satir[i].indirim9 = 0; else sepet.satir[i].indirim9 = DISCOUNT9;
		if (not len(DISCOUNT10)) sepet.satir[i].indirim10 = 0; else sepet.satir[i].indirim10 = DISCOUNT10;
		sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
		if(len(COST_PRICE)) sepet.satir[i].net_maliyet = COST_PRICE; else sepet.satir[i].net_maliyet=0;
		if(len(MARGIN)) sepet.satir[i].marj = MARGIN; else sepet.satir[i].marj = 0;
		if(len(extra_cost)) sepet.satir[i].extra_cost = extra_cost; else sepet.satir[i].extra_cost =0;
		if(len(UNIQUE_RELATION_ID)) sepet.satir[i].row_unique_relation_id = UNIQUE_RELATION_ID; else sepet.satir[i].row_unique_relation_id = "";
		if(len(PROM_RELATION_ID)) sepet.satir[i].prom_relation_id = PROM_RELATION_ID; else sepet.satir[i].prom_relation_id = "";
		if(len(PRODUCT_NAME2)) sepet.satir[i].product_name_other = PRODUCT_NAME2; else sepet.satir[i].product_name_other = "";
		if(len(UNIT2)) sepet.satir[i].unit_other = UNIT2; else sepet.satir[i].unit_other = "";
		//iscilik birim ucretinden maliyet ve ektutar hesaplaması iscilik marj oranı dahil edilerek
		if(len(AMOUNT2)) sepet.satir[i].amount_other = AMOUNT2; else sepet.satir[i].amount_other = "";
		if(len(EXTRA_PRICE)) sepet.satir[i].ek_tutar = EXTRA_PRICE;	else sepet.satir[i].ek_tutar = 0;
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
		//iscilik birim ucretinden maliyet ve ektutar hesaplaması iscilik marj oranı dahil edilerek
		if(len(EXTRA_PRICE_TOTAL)) sepet.satir[i].ek_tutar_total = EXTRA_PRICE_TOTAL; else sepet.satir[i].ek_tutar_total = 0;
		if(len(EXTRA_PRICE_OTHER_TOTAL)) sepet.satir[i].ek_tutar_other_total = EXTRA_PRICE_OTHER_TOTAL; else sepet.satir[i].ek_tutar_other_total = 0;
		if(len(SHELF_NUMBER)) sepet.satir[i].shelf_number = SHELF_NUMBER; else sepet.satir[i].shelf_number = "";
		if(len(BASKET_EXTRA_INFO_ID)) sepet.satir[i].basket_extra_info = BASKET_EXTRA_INFO_ID; else sepet.satir[i].basket_extra_info="";
		sepet.satir[i].stock_id = STOCK_ID;
		sepet.satir[i].barcode = BARCOD;
		sepet.satir[i].stock_code = STOCK_CODE;
		sepet.satir[i].special_code = STOCK_CODE_2;
		sepet.satir[i].manufact_code = PRODUCT_MANUFACT_CODE;
		if(len(DUE_DATE)) sepet.satir[i].duedate = DUE_DATE; else  sepet.satir[i].duedate = '';
		sepet.satir[i].row_total = NETTOTAL+DISCOUNTTOTAL;//amount*price;	
		sepet.satir[i].row_nettotal = NETTOTAL;
		sepet.satir[i].row_taxtotal = TAXTOTAL;
		sepet.satir[i].row_oiv_amount = ( len( OIV_AMOUNT ) ) ? OIV_AMOUNT : 0;
		sepet.satir[i].row_bsmv_amount = ( len( BSMV_AMOUNT ) ) ? BSMV_AMOUNT : 0;
		sepet.satir[i].row_weight = ( len( WEIGHT ) ) ? WEIGHT : 0;
		sepet.satir[i].row_specific_weight = ( len( SPECIFIC_WEIGHT ) ) ? SPECIFIC_WEIGHT : 0;
		sepet.satir[i].row_volume = ( len( VOLUME ) ) ? VOLUME : 0;
		if(len(OTVTOTAL))
		{ 
			sepet.satir[i].row_otvtotal =OTVTOTAL;
			/*20060530 aksi halde taxtotal daki kusurler basket toplamini bozuyor. if(len(GROSSTOTAL)) sepet.satir[i].row_lasttotal = GROSSTOTAL; else sepet.satir[i].row_lasttotal = 0;*/
			sepet.satir[i].row_lasttotal = NETTOTAL+TAXTOTAL+OTVTOTAL + sepet.satir[i].row_oiv_amount + sepet.satir[i].row_bsmv_amount;
		}
		else
		{
		 	sepet.satir[i].row_otvtotal = 0;
			sepet.satir[i].row_lasttotal = NETTOTAL+TAXTOTAL + sepet.satir[i].row_oiv_amount + sepet.satir[i].row_bsmv_amount;
		}
		sepet.satir[i].other_money = OTHER_MONEY;
		sepet.satir[i].other_money_value = OTHER_MONEY_VALUE;
		sepet.satir[i].other_money_grosstotal = OTHER_MONEY_GROSS_TOTAL;
		if(len(deliver_date)) sepet.satir[i].deliver_date = DELIVER_DATE; else  sepet.satir[i].deliver_date = '';
		
		if(len(DELIVER_LOC)) 
			sepet.satir[i].deliver_dept = DELIVER_DEPT & "-" & DELIVER_LOC ; 
		else 
			sepet.satir[i].deliver_dept = DELIVER_DEPT ; 
		
		sepet.satir[i].spect_id = SPECT_VAR_ID;
		sepet.satir[i].spect_name = SPECT_VAR_NAME;
		sepet.satir[i].lot_no = LOT_NO;
		
		if(len(PRICE_OTHER))
			sepet.satir[i].price_other = PRICE_OTHER;
		else
			sepet.satir[i].price_other = PRICE;
	
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

		sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
		
		sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,basket_total_round_number) - wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number)); //discount_
		//writeoutput('#sepet.toplam_indirim#--#wrk_round(sepet.satir[i].row_total)#---#wrk_round(sepet.satir[i].row_nettotal)#<br/>');
		sepet.net_total = sepet.net_total + wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number); //nettotal_ a daha sonra kdv toplam ekleniyor altta
		// kdv array
		
		kdv_flag = 0;
		for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
			{
			if (sepet.kdv_array[k][1] eq sepet.satir[i].tax_percent)
				{
				kdv_flag = 1;
				sepet.kdv_array[k][2] = sepet.kdv_array[k][2] + wrk_round(sepet.satir[i].row_taxtotal,basket_total_round_number);
				sepet.kdv_array[k][3] = sepet.kdv_array[k][3] + wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);			
				}
			}
		if (not kdv_flag)
			{
			sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = sepet.satir[i].tax_percent;
			sepet.kdv_array[arraylen(sepet.kdv_array)][2] = wrk_round(sepet.satir[i].row_taxtotal,basket_total_round_number);
			sepet.kdv_array[arraylen(sepet.kdv_array)][3] = wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);
			}
			
		// ötv array
		otv_flag = 0;
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
	
		sepet.satir[i].promosyon_yuzde = PROM_COMISSION;
		if (len(PROM_COST)) sepet.satir[i].promosyon_maliyet = PROM_COST; else sepet.satir[i].promosyon_maliyet = 0;
		sepet.satir[i].iskonto_tutar = DISCOUNT_COST;
		sepet.satir[i].is_promotion = IS_PROMOTION;
		sepet.satir[i].prom_stock_id = PROM_STOCK_ID;
		sepet.satir[i].row_promotion_id = PROM_ID ;
		sepet.satir[i].is_commission = IS_COMMISSION;
	
		if(len(LIST_PRICE)) sepet.satir[i].list_price = LIST_PRICE; else sepet.satir[i].list_price = PRICE;
		if(len(PRICE_CAT)) sepet.satir[i].price_cat = PRICE_CAT; else  sepet.satir[i].price_cat = '';
		if(len(CATALOG_ID)) sepet.satir[i].row_catalog_id = CATALOG_ID; else  sepet.satir[i].row_catalog_id = '';
		if(len(NUMBER_OF_INSTALLMENT)) sepet.satir[i].number_of_installment = NUMBER_OF_INSTALLMENT; else sepet.satir[i].number_of_installment = 0;

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
		if(len(ROW_EXP_CENTER_ID))
		{
			sepet.satir[i].row_exp_center_id=ROW_EXP_CENTER_ID;
			sepet.satir[i].row_exp_center_name=GET_ROW_EXP_CENTER.EXPENSE[listfind(row_expense_id_list_,ROW_EXP_CENTER_ID)];
		}
		//Aktivite Tipi
		if(len(ACTIVITY_TYPE_ID))
		{
			sepet.satir[i].row_activity_id = ACTIVITY_TYPE_ID;
		}
		if(len(ROW_EXP_ITEM_ID))
		{
			sepet.satir[i].row_exp_item_id=ROW_EXP_ITEM_ID;
			sepet.satir[i].row_exp_item_name=GET_EXP_ITEM.EXPENSE_ITEM_NAME[listfind(row_expense_item_list_,ROW_EXP_ITEM_ID)];
		}
		if(len(ROW_ACC_CODE))
		{
			sepet.satir[i].row_acc_code=ROW_ACC_CODE;
		}
		if(len(reason_code))
			sepet.satir[i].reason_code=REASON_CODE & '--' & REASON_NAME;
		else
			sepet.satir[i].reason_code='';

		sepet.satir[i].otv_type = isDefined('OTV_TYPE') and len(OTV_TYPE) ? OTV_TYPE : '';

		sepet.satir[i].otv_discount = isDefined('OTV_DISCOUNT') and len(OTV_DISCOUNT) ? OTV_DISCOUNT : '';

		//Ek Satır Açıklama
		if(len(detail_info_extra))
			sepet.satir[i].detail_info_extra=detail_info_extra;
		else
			sepet.satir[i].detail_info_extra='';
		//Ek Satır Açıklama
		if(len(select_info_extra))
		sepet.satir[i].select_info_extra=select_info_extra;
	else
		sepet.satir[i].select_info_extra='';
		//ihracat
		if(len(delivery_condition))
			sepet.satir[i].delivery_condition=delivery_condition;
		else
			sepet.satir[i].delivery_condition='';
		if(len(container_type))
			sepet.satir[i].container_type=container_type;
		else
			sepet.satir[i].container_type='';
		if(len(container_number))
			sepet.satir[i].container_number=container_number;
		else
			sepet.satir[i].container_number='';
		if(len(container_quantity))
			sepet.satir[i].container_quantity=container_quantity;
		else
			sepet.satir[i].container_quantity='';
		if(len(delivery_country))
			sepet.satir[i].delivery_country=delivery_country;
		else
			sepet.satir[i].delivery_country='';
		if(len(delivery_city))
			sepet.satir[i].delivery_city=delivery_city;
		else
			sepet.satir[i].delivery_city='';
		if(len(delivery_county))
			sepet.satir[i].delivery_county=delivery_county;
		else
			sepet.satir[i].delivery_county='';
		if(len(delivery_type))
			sepet.satir[i].delivery_type=delivery_type;
		else
			sepet.satir[i].delivery_type='';
		if(len(gtip_number))
			sepet.satir[i].gtip_number=gtip_number;
		else
			sepet.satir[i].gtip_number='';
		
		sepet.satir[i].row_subscription_id = ( len( SUBSCRIPTION_ID ) ) ? SUBSCRIPTION_ID : '';
		sepet.satir[i].row_subscription_name = ( len( SUBSCRIPTION_NO ) and len( SUBSCRIPTION_HEAD ) ) ? SUBSCRIPTION_NO & " - " & SUBSCRIPTION_HEAD : '';
		sepet.satir[i].row_assetp_id = ( len( ASSETP_ID ) ) ? ASSETP_ID : '';
		sepet.satir[i].row_assetp_name = ( len( ASSETP ) ) ? ASSETP : '';
		sepet.satir[i].row_oiv_rate = ( len( OIV_RATE ) ) ? OIV_RATE : '';
		sepet.satir[i].row_bsmv_rate = ( len( BSMV_RATE ) ) ? BSMV_RATE : '';
		sepet.satir[i].row_bsmv_currency = ( len( BSMV_CURRENCY ) ) ? BSMV_CURRENCY : '';
		sepet.satir[i].row_tevkifat_rate = ( len( TEVKIFAT_RATE ) ) ? TEVKIFAT_RATE : '';
		sepet.satir[i].row_tevkifat_amount = ( len( TEVKIFAT_AMOUNT ) ) ? TEVKIFAT_AMOUNT : '';
		sepet.satir[i].row_tevkifat_id = ( len( TEVKIFAT_ID ) ) ? TEVKIFAT_ID : '';
	
	</cfscript>
</cfoutput>
<cfscript>		
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
		
	for (t=1;t lte arraylen(sepet.otv_array);t=t+1)
		sepet.total_otv = sepet.total_otv + wrk_round(sepet.otv_array[t][2],price_round_number);
	
	sepet.net_total = sepet.net_total + sepet.total_tax + sepet.total_otv;
</cfscript>
