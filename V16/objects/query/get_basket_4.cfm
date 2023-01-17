<!--- is_copy parametresi siparis kopyalama sayfaları icin eklendi BK 20060424  --->
<cfif isdefined('attributes.from_project_material')>
	<cfquery name="GET_ORDER_PRODUCTS" datasource="#DSN#">
		SELECT
			0 AS ORDER_ROW_ID,
			PMR.PRODUCT_ID,
			PMR.PRODUCT_NAME,
			'' AS PAYMETHOD_ID,
			PMR.UNIT,
			PMR.UNIT_ID,
			'' AS UNIQUE_RELATION_ID,
			'' AS PROM_RELATION_ID,
			PMR.AMOUNT AS QUANTITY,
			PMR.PRODUCT_NAME2,
			'' AS AMOUNT2,
            '' AS UNIT2,
			PMR.EXTRA_PRICE,
			PMR.EK_TUTAR_PRICE,
			PMR.EXTRA_PRICE_TOTAL,
			PMR.EXTRA_PRICE_OTHER_TOTAL,
			PMR.SHELF_NUMBER,
			PMR.BASKET_EXTRA_INFO_ID,
			PMR.SELECT_INFO_EXTRA,
			PMR.DETAIL_INFO_EXTRA,
			PMR.PRICE,
          	PMR.LIST_PRICE,
            PMR.PRICE_CAT,
            '' AS CATALOG_ID,
            '' AS NUMBER_OF_INSTALLMENT,
			PMR.COST_PRICE,
			PMR.MARGIN AS MARJ,
			PMR.EXTRA_COST,
			PMR.PRICE_OTHER,
			PMR.TAX,
			PMR.OTV_ORAN,
			S.STOCK_ID,
			PMR.PRODUCT_MANUFACT_CODE,
			PMR.DUEDATE,
			PMR.PROM_COMISSION,
			PMR.PROM_COST,
			PMR.DISCOUNT_COST,
			PMR.IS_PROMOTION,
			PMR.PROM_STOCK_ID,
			PMR.PROM_ID,
			PMR.WIDTH_VALUE,
			PMR.DEPTH_VALUE,
			PMR.HEIGHT_VALUE,
			PMR.ROW_PROJECT_ID,
			0 AS IS_COMMISSION,
			PMR.DISCOUNT1 AS DISCOUNT_1,
			PMR.DISCOUNT2 AS DISCOUNT_2,
			PMR.DISCOUNT3 AS DISCOUNT_3,
			PMR.DISCOUNT4 AS DISCOUNT_4,
			PMR.DISCOUNT5 AS DISCOUNT_5,
			0 AS DISCOUNT_6,
			0 AS DISCOUNT_7,
			0 AS DISCOUNT_8,
			0 AS DISCOUNT_9,
			0 AS DISCOUNT_10,
			'' AS BASKET_EMPLOYEE_ID,
			'' AS KARMA_PRODUCT_ID,
			PMR.DELIVER_DATE,PMR.DELIVER_LOCATION,PMR.DELIVER_DEPT,PMR.SPECT_VAR_ID,PMR.SPECT_VAR_NAME,PMR.OTHER_MONEY,PMR.OTHER_MONEY_VALUE,
			'' LOT_NO,
			-1 RESERVE_TYPE,
			'' RESERVE_DATE,
			S.BARCOD,S.STOCK_CODE,S.IS_INVENTORY,S.IS_PRODUCTION,
			PMR.NETTOTAL,PMR.OTVTOTAL,
			PMR.PRO_MATERIAL_ROW_ID AS ORDER_ROW_ID,
			PMR.PRO_MATERIAL_ID,
			-1 AS ORDER_ROW_CURRENCY,
			PMR.PRO_MATERIAL_ID AS ROW_PRO_MATERIAL_ID,
			WRK_ROW_ID,
			WRK_ROW_RELATION_ID,
			'' AS RELATED_ACTION_ID,
			'' AS RELATED_ACTION_TABLE,
			S.STOCK_CODE_2,
            '' AS ROW_WORK_ID,
			'' AS REASON_CODE,
			'' AS EXPENSE_CENTER_ID,
			'' AS ACTIVITY_TYPE_ID,
			'' AS EXPENSE_ITEM_ID,
			'' AS ACC_CODE,
			'' AS SUBSCRIPTION_ID,
			'' AS SUBSCRIPTION_NO,
			'' AS ASSETP_ID,
			'' AS ASSETP,
			'' AS OIV_RATE,
			'' AS OIV_AMOUNT,
			'' AS BSMV_RATE,
			'' AS BSMV_AMOUNT,
		    '' AS BSMV_CURRENCY,
			'' AS TEVKIFAT_RATE,
			'' AS TEVKIFAT_AMOUNT,
			'' AS GTIP_NUMBER,
			'' AS OTV_TYPE,
			'' AS OTV_DISCOUNT,
			0 SPECIFIC_WEIGHT,
			0 WEIGHT,
			0 VOLUME 
		FROM 
			PRO_MATERIAL_ROW PMR,
			#dsn3_alias#.STOCKS S
		WHERE
			<cfif isdefined('attributes.from_project_material_id') and len(attributes.from_project_material_id)><!--- Eğer malzeme ihtiyaç listesinin detayından geliyorsa sadece o malzeme listesindeki ürünleri alsın. --->
				PMR.PRO_MATERIAL_ID IN (#attributes.from_project_material_id#) AND
			</cfif>
			PMR.STOCK_ID = S.STOCK_ID
		ORDER BY
			PMR.PRO_MATERIAL_ROW_ID
	</cfquery>
	<cfelseif isdefined("attributes.opp_id") and len(attributes.opp_id)>
		<cfquery name="GET_ORDER_PRODUCTS" datasource="#DSN3#">
			SELECT
					PS.PRODUCT_SAMPLE_ID ,
					0 AS ORDER_ROW_ID,
					P.PRODUCT_ID,
					 PS.PRODUCT_SAMPLE_NAME  AS PRODUCT_NAME,
					'' AS PAYMETHOD_ID,
					PS.TARGET_AMOUNT_UNITY AS UNIT_ID,
					SU.UNIT AS UNIT,
					'' AS UNIT2,
					'' AS UNIQUE_RELATION_ID,
					'' AS PROM_RELATION_ID,
					ISNULL(PS.TARGET_AMOUNT, 0 ) AS QUANTITY,
					'' AS PRODUCT_NAME2,
					'' BARCOD,S.STOCK_CODE,S.IS_INVENTORY,S.IS_PRODUCTION,
					'' AS AMOUNT2,
					 S.STOCK_ID,
					0 AS EXTRA_PRICE,
					'' AS EK_TUTAR_PRICE,
					'' AS EXTRA_PRICE_TOTAL,
					'' AS EXTRA_PRICE_OTHER_TOTAL,
					'' AS SHELF_NUMBER,
					'' AS BASKET_EXTRA_INFO_ID,
					PS.SALES_PRICE AS PRICE,
					'' as LIST_PRICE,
					'' AS PRICE_CAT,
					'' AS CATALOG_ID,
					'' AS NUMBER_OF_INSTALLMENT,
					0 AS COST_PRICE,
					0 AS MARJ,
					0 AS EXTRA_COST,
					0 AS PRICE_OTHER,
					0 AS TAX,
					0 AS OTV_ORAN,
					PS.SALES_PRICE_CURRENCY  AS OTHER_MONEY,
					''  PRODUCT_MANUFACT_CODE,
					0 AS DUEDATE,
					'' AS PROM_COMISSION,
					0 AS PROM_COST,
					0 AS DISCOUNT_COST,
					0 AS IS_PROMOTION,
					'' AS PROM_STOCK_ID,
					'' AS PROM_ID,
					0 AS IS_COMMISSION,
					0 AS  DISCOUNT_1,
					0 AS  DISCOUNT_2,
					0 AS  DISCOUNT_3,
					0 AS  DISCOUNT_4,
					0 AS  DISCOUNT_5,
					0 AS DISCOUNT_6,
					0 AS DISCOUNT_7,
					0 AS DISCOUNT_8,
					0 AS DISCOUNT_9,
					0 AS DISCOUNT_10,
					'' AS BASKET_EMPLOYEE_ID,
					'' AS KARMA_PRODUCT_ID,
					'' AS DELIVER_DATE,'' AS DELIVER_LOCATION,'' AS DELIVER_DEPT,'' AS SPECT_VAR_ID,'' AS SPECT_VAR_NAME,
					'' LOT_NO,
					-1 RESERVE_TYPE,
					'' RESERVE_DATE,
				
				
				'' AS NETTOTAL,
				'' AS OTVTOTAL,
					P.PRODUCT_ID AS ORDER_ROW_ID,
					'' AS PRO_MATERIAL_ID,
					-1 AS ORDER_ROW_CURRENCY,
					'' AS ROW_PRO_MATERIAL_ID,
					'' AS WRK_ROW_ID,
					'' AS WRK_ROW_RELATION_ID,
				'' AS RELATED_ACTION_ID,
				'' AS RELATED_ACTION_TABLE,
					'' AS WIDTH_VALUE,
					'' AS DEPTH_VALUE,
					'' AS HEIGHT_VALUE,
					'' AS ROW_PROJECT_ID,
					PS.CUSTOMER_MODEL_NO AS STOCK_CODE_2,
					'' ROW_WORK_ID,
					'' SELECT_INFO_EXTRA,
					'' DETAIL_INFO_EXTRA,
					'' AS REASON_CODE,
				'' AS EXPENSE_CENTER_ID,
				'' AS ACTIVITY_TYPE_ID,
				'' AS EXPENSE_ITEM_ID,
				'' AS ACC_CODE,
				'' AS SUBSCRIPTION_ID,
				'' AS SUBSCRIPTION_NO,
				'' AS ASSETP_ID,
				'' AS ASSETP,
				0 AS OIV_RATE,
				0 AS OIV_AMOUNT,
				0 AS BSMV_RATE,
				0 AS BSMV_AMOUNT,
				0 AS BSMV_CURRENCY,
				0 AS TEVKIFAT_RATE,
				0 AS TEVKIFAT_AMOUNT,
				'' AS GTIP_NUMBER,
				0 AS OTV_TYPE,
				0 AS OTV_DISCOUNT,
				'' AS OTHER_MONEY_VALUE 
				, PS.OPPORTUNITY_ID 
				,P.PRODUCT_ID AS ORDER_ROW_ID
				,O.OPP_ID 
				, P.P_SAMPLE_ID
				,0 SPECIFIC_WEIGHT
				,0 WEIGHT
				,0 VOLUME 
				FROM 
				#dsn1#.PRODUCT AS P
				LEFT JOIN PRODUCT_SAMPLE AS PS ON PS.PRODUCT_SAMPLE_ID = P.P_SAMPLE_ID 
				LEFT JOIN OPPORTUNITIES AS O ON  O.OPP_ID =PS.OPPORTUNITY_ID 
				LEFT JOIN #dsn#.SETUP_UNIT AS SU ON  SU.UNIT_ID = PS.TARGET_AMOUNT_UNITY 
				LEFT JOIN STOCKS AS S ON S.PRODUCT_ID=P.PRODUCT_ID
			
				
			WHERE
				P.PRODUCT_ID   IN (#ListQualify(product_id,"'",",")#) 
				
			ORDER BY
				P.PRODUCT_ID
		</cfquery>
	
<cfelseif isDefined("attributes.req_id")>
	<cfquery name="GET_ORDER_PRODUCTS" datasource="#dsn3#">
		SELECT
				0 AS ORDER_ROW_ID,
				S.PRODUCT_ID,
				 S.PRODUCT_NAME +' '+S.PROPERTY AS PRODUCT_NAME,
				'' AS PAYMETHOD_ID,
				PRODUCT_UNIT.MAIN_UNIT_ID AS UNIT_ID,
				PRODUCT_UNIT.MAIN_UNIT AS UNIT,
				'' AS UNIT2,
				'' AS UNIQUE_RELATION_ID,
				'' AS PROM_RELATION_ID,
				ISNULL(PITR.STOCK_AMOUNT, 0) * ISNULL(PITR.ASSORTMENT_AMOUNT, 0) AS QUANTITY,
				'' AS PRODUCT_NAME2,
				'' AS AMOUNT2,
				0 AS EXTRA_PRICE,
				0 AS EK_TUTAR_PRICE,
				0 AS EXTRA_PRICE_TOTAL,
				0 AS EXTRA_PRICE_OTHER_TOTAL,
				'' AS SHELF_NUMBER,
				'' AS BASKET_EXTRA_INFO_ID,
				ISNULL(SREQ.CONFIG_PRICE_OTHER, 0) AS PRICE,
				0 AS LIST_PRICE,
				'' AS PRICE_CAT,
				'' AS CATALOG_ID,
				'' AS NUMBER_OF_INSTALLMENT,
			
				0 AS COST_PRICE,
				0 AS MARJ,
				0 AS EXTRA_COST,
				ISNULL(SREQ.CONFIG_PRICE_OTHER, 0) AS PRICE_OTHER,
				S.TAX,
				0 AS OTV_ORAN,
				S.STOCK_ID,
				S.MANUFACT_CODE AS PRODUCT_MANUFACT_CODE,
				0 AS DUEDATE,
				0 AS PROM_COMISSION,
				0 AS PROM_COST,
				0 AS DISCOUNT_COST,
				0 AS IS_PROMOTION,
				0 AS PROM_STOCK_ID,
				0 AS PROM_ID,
				0 AS IS_COMMISSION,
				0 AS  DISCOUNT_1,
				0 AS  DISCOUNT_2,
				0 AS  DISCOUNT_3,
				0 AS  DISCOUNT_4,
				0 AS  DISCOUNT_5,
				0 AS DISCOUNT_6,
				0 AS DISCOUNT_7,
				0 AS DISCOUNT_8,
				0 AS DISCOUNT_9,
				0 AS DISCOUNT_10,
				'' AS BASKET_EMPLOYEE_ID,
				'' AS KARMA_PRODUCT_ID,
				'' AS DELIVER_DATE,'' AS DELIVER_LOCATION,'' AS DELIVER_DEPT,'' AS SPECT_VAR_ID,'' AS SPECT_VAR_NAME
				,ISNULL(SREQ.CONFIG_PRICE_OTHER, 0) * ISNULL(PITR.STOCK_AMOUNT, 0) * ISNULL(PITR.ASSORTMENT_AMOUNT, 0) AS OTHER_MONEY_VALUE
				,'' LOT_NO,
				-1 RESERVE_TYPE,
				'' RESERVE_DATE,
				S.BARCOD,S.STOCK_CODE,S.IS_INVENTORY,S.IS_PRODUCTION,
				0 AS NETTOTAL,
				0 AS OTVTOTAL,
				PITR.ASSORTMENT_ID AS ORDER_ROW_ID,
				'' AS PRO_MATERIAL_ID,
				-1 AS ORDER_ROW_CURRENCY,
				'' AS ROW_PRO_MATERIAL_ID,
				'' AS WRK_ROW_ID,
				PITR.WRK_ROW_ID AS WRK_ROW_RELATION_ID,
				#attributes.req_id# AS RELATED_ACTION_ID,
				'TEXTILE_SAMPLE_REQUEST' AS RELATED_ACTION_TABLE,
				'' AS WIDTH_VALUE,
				'' AS DEPTH_VALUE,
				'' AS HEIGHT_VALUE,
				'' AS ROW_PROJECT_ID,
				S.STOCK_CODE_2,
				'' ROW_WORK_ID,
				SREQ.CONFIG_PRICE_MONEY AS OTHER_MONEY,
				'' SELECT_INFO_EXTRA,
				'' DETAIL_INFO_EXTRA,
				'' AS REASON_CODE,
			'' AS EXPENSE_CENTER_ID,
			'' AS ACTIVITY_TYPE_ID,
			'' AS EXPENSE_ITEM_ID,
			'' AS ACC_CODE,
			'' AS SUBSCRIPTION_ID,
			'' AS SUBSCRIPTION_NO,
			'' AS ASSETP_ID,
			'' AS ASSETP,
			'' AS OIV_RATE,
			'' AS OIV_AMOUNT,
			'' AS BSMV_RATE,
			'' AS BSMV_AMOUNT,
		    '' AS BSMV_CURRENCY,
			'' AS TEVKIFAT_RATE,
			'' AS TEVKIFAT_AMOUNT,
			'' AS GTIP_NUMBER,
			'' AS OTV_TYPE,
			'' AS OTV_DISCOUNT,
			0 SPECIFIC_WEIGHT,
			0 WEIGHT,
			0 VOLUME 
			FROM 
	
				#dsn3_alias#.TEXTILE_ASSORTMENT PITR,
				#dsn3_alias#.STOCKS S,
				#dsn3_alias#.PRODUCT_UNIT,
				<!---,
				#dsn2_alias#.SETUP_MONEY--->
				#dsn3_alias#.TEXTILE_SAMPLE_REQUEST SREQ
	
			WHERE
				PITR.STOCK_ID=S.STOCK_ID AND
				PRODUCT_UNIT.PRODUCT_ID = S.PRODUCT_ID AND
				PRODUCT_UNIT.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND
				SREQ.REQ_ID = PITR.REQUEST_ID AND
				PITR.REQUEST_ID=#attributes.req_id#
		</cfquery>
		<CFSET attributes.stock_id="">
		
<cfelseif isdefined('attributes.demand_id') and len(attributes.demand_id)>
	<cfquery name="GET_ORDER_PRODUCTS" datasource="#DSN#">
		SELECT
			0 AS ORDER_ROW_ID,
			S.PRODUCT_ID,
			S.PRODUCT_NAME,
			'' AS PAYMETHOD_ID,
			'' AS UNIT,
			'' AS UNIT_ID,
			'' AS UNIQUE_RELATION_ID,
			'' AS PROM_RELATION_ID,
			ORD_D.DEMAND_AMOUNT AS QUANTITY,
			'' AS PRODUCT_NAME2,
			'' AS AMOUNT2,'' AS UNIT2,
			0 AS EXTRA_PRICE,
			0 AS EK_TUTAR_PRICE,
			0 AS EXTRA_PRICE_TOTAL,
			0 AS EXTRA_PRICE_OTHER_TOTAL,
			'' AS SHELF_NUMBER,
			'' AS BASKET_EXTRA_INFO_ID,
			'' SELECT_INFO_EXTRA,
			'' DETAIL_INFO_EXTRA,
			ORD_D.PRICE,
			ORD_D.PRICE AS LIST_PRICE,
			'' AS PRICE_CAT,
			'' AS CATALOG_ID,
			'' AS NUMBER_OF_INSTALLMENT,
			0 AS COST_PRICE,
			0 AS MARJ,
			0 AS EXTRA_COST,
			ORD_D.PRICE AS PRICE_OTHER,
			S.TAX,
			0 AS OTV_ORAN,
			S.STOCK_ID,
			S.MANUFACT_CODE AS PRODUCT_MANUFACT_CODE,
			0 AS DUEDATE,
			0 AS PROM_COMISSION,
			0 AS PROM_COST,
			0 AS DISCOUNT_COST,
			0 AS IS_PROMOTION,
			0 AS PROM_STOCK_ID,
			0 AS PROM_ID,
			0 AS IS_COMMISSION,
			0 AS  DISCOUNT_1,
			0 AS  DISCOUNT_2,
			0 AS  DISCOUNT_3,
			0 AS  DISCOUNT_4,
			0 AS  DISCOUNT_5,
			0 AS DISCOUNT_6,
			0 AS DISCOUNT_7,
			0 AS DISCOUNT_8,
			0 AS DISCOUNT_9,
			0 AS DISCOUNT_10,
			'' AS BASKET_EMPLOYEE_ID,
			'' AS KARMA_PRODUCT_ID,
			'' AS DELIVER_DATE,'' AS DELIVER_LOCATION,'' AS DELIVER_DEPT,'' AS SPECT_VAR_ID,'' AS SPECT_VAR_NAME,'#session.ep.money#' AS OTHER_MONEY,0 AS OTHER_MONEY_VALUE,
			'' LOT_NO,
			-1 RESERVE_TYPE,
			'' RESERVE_DATE,
			S.BARCOD,S.STOCK_CODE,S.IS_INVENTORY,S.IS_PRODUCTION,
			0 AS NETTOTAL,0 AS OTVTOTAL,
			DEMAND_ID AS ORDER_ROW_ID,
			'' AS PRO_MATERIAL_ID,
			-1 AS ORDER_ROW_CURRENCY,
			'' AS ROW_PRO_MATERIAL_ID,
			'' AS WRK_ROW_ID,
			'' AS WRK_ROW_RELATION_ID,
			'' AS RELATED_ACTION_ID,
			'' AS RELATED_ACTION_TABLE,
			'' AS WIDTH_VALUE,
			'' AS DEPTH_VALUE,
			'' AS HEIGHT_VALUE,
			'' AS ROW_PROJECT_ID,
			S.STOCK_CODE_2,
            '' AS ROW_WORK_ID,
			'' AS REASON_CODE,
			'' AS EXPENSE_CENTER_ID,
			'' AS ACTIVITY_TYPE_ID,
			'' AS EXPENSE_ITEM_ID,
			'' AS ACC_CODE,
			'' AS SUBSCRIPTION_ID,
			'' AS SUBSCRIPTION_NO ,
			'' AS ASSETP_ID,
			'' AS ASSETP,
			'' AS OIV_RATE,
			'' AS OIV_AMOUNT,
			'' AS BSMV_RATE,
            '' AS BSMV_AMOUNT ,
			'' AS BSMV_CURRENCY,
			'' AS TEVKIFAT_RATE,
			'' AS TEVKIFAT_AMOUNT,
			'' AS GTIP_NUMBER,
			'' AS OTV_TYPE,
			'' AS OTV_DISCOUNT,
			0 SPECIFIC_WEIGHT,
			0 WEIGHT,
			0 VOLUME 
		FROM 
			#dsn3_alias#.ORDER_DEMANDS ORD_D,
			#dsn3_alias#.STOCKS S
		WHERE
			ORD_D.DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.demand_id#">
			AND ORD_D.STOCK_ID = S.STOCK_ID
	</cfquery>
<cfelseif ((isDefined("attributes.offer_id") and Len(attributes.offer_id)) or (isDefined("form.offer_row_check_info") and len(form.offer_row_check_info))) and not (isdefined("attributes.is_copy") and attributes.is_copy eq 1) and not (attributes.fuseaction contains 'list_order' and (isdefined("url.event") and url.event is 'upd'))>
	<!--- Satis Teklifinden Siparise Donusturme Kontrolleri get_basket_3'ten Buraya Tasindi FBS 20101229 --->
	<cfif isDefined("form.offer_row_check_info") and len(form.offer_row_check_info)>
		<cfset offer_row_list = "">
		<cfset wrk_row_list = "">
		<cfloop list="#form.offer_row_check_info#" index="rci">
			<cfset offer_row_list = ListAppend(offer_row_list,ListFirst(rci,'_'),',')>
			<cfset wrk_row_list = ListAppend(wrk_row_list,ListLast(rci,'_'),',')>
		</cfloop>
	</cfif>
	<cfquery name="GET_OFFER_" datasource="#DSN3#">
		SELECT TOP 1
			COMPANY_ID,
			CONSUMER_ID,
			OTHER_MONEY
		FROM
			OFFER
		WHERE
			<cfif isDefined("offer_row_list") and listLen(offer_row_list)>
				OFFER_ID IN (#ListDeleteDuplicates(offer_row_list)#)
			<cfelse>
				OFFER_ID IN (#attributes.OFFER_ID#)
			</cfif>
	</cfquery>
	<cfset get_offer.other_money = get_offer_.other_money>
	<cfquery name="GET_ORDER_PRODUCTS" datasource="#DSN3#">
		SELECT
			OFR.OFFER_ID,
			0 AS ORDER_ROW_ID,
			OFR.PRODUCT_ID,
			OFR.PRODUCT_NAME,
			'' AS PAYMETHOD_ID,
			OFR.UNIT,
			OFR.UNIT_ID,
			OFR.UNIQUE_RELATION_ID,
			'' AS PROM_RELATION_ID,
			OFR.QUANTITY AS QUANTITY,
			OFR.PRODUCT_NAME2,
			OFR.AMOUNT2,
			OFR.UNIT2,
			OFR.EXTRA_PRICE,
			OFR.EK_TUTAR_PRICE,
			OFR.EXTRA_PRICE_TOTAL,
			OFR.EXTRA_PRICE_OTHER_TOTAL,
			OFR.SHELF_NUMBER,
			OFR.BASKET_EXTRA_INFO_ID,
			OFR.SELECT_INFO_EXTRA,
			OFR.DETAIL_INFO_EXTRA,
			OFR.PRICE,
			OFR.LIST_PRICE AS LIST_PRICE,
			OFR.PRICE_CAT,
			OFR.CATALOG_ID,
			OFR.NUMBER_OF_INSTALLMENT,
			0 AS COST_PRICE,
			OFR.MARJ,
			OFR.EXTRA_COST,
			OFR.PRICE_OTHER AS PRICE_OTHER,
			OFR.TAX,
			OFR.OTV_ORAN,
			OFR.STOCK_ID,
			OFR.PRODUCT_MANUFACT_CODE,
			OFR.DUEDATE,
			OFR.PROM_COMISSION,
			OFR.PROM_COST,
			OFR.DISCOUNT_COST,
			OFR.IS_PROMOTION,
			OFR.PROM_STOCK_ID,
			OFR.PROM_ID,
			0 AS IS_COMMISSION,
			OFR.DISCOUNT_1,
			OFR.DISCOUNT_2,
			OFR.DISCOUNT_3,
			OFR.DISCOUNT_4,
			OFR.DISCOUNT_5,
			OFR.DISCOUNT_6,
			OFR.DISCOUNT_7,
			OFR.DISCOUNT_8,
			OFR.DISCOUNT_9,
			OFR.DISCOUNT_10,
			'' AS BASKET_EMPLOYEE_ID,
			OFR.KARMA_PRODUCT_ID,
			OFR.DELIVER_DATE,
			OFR.DELIVER_LOCATION,
			OFR.DELIVER_DEPT,
			OFR.SPECT_VAR_ID,
			OFR.SPECT_VAR_NAME,
			OFR.OTHER_MONEY OTHER_MONEY,
			OFR.OTHER_MONEY_VALUE,
			'' AS LOT_NO,
			-1 RESERVE_TYPE,
			'' RESERVE_DATE,
			S.BARCOD,
			S.STOCK_CODE,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.PROPERTY,
			S.MANUFACT_CODE,
			'' AS NETTOTAL,
			OFR.OTVTOTAL,
			OFFER_ROW_ID AS ORDER_ROW_ID,
			'' AS PRO_MATERIAL_ID,
			-1 AS ORDER_ROW_CURRENCY,
			'' AS ROW_PRO_MATERIAL_ID,
			OFR.WRK_ROW_ID,
			OFR.WRK_ROW_RELATION_ID,
			OFR.RELATED_ACTION_ID,
			OFR.RELATED_ACTION_TABLE,
			OFR.WIDTH_VALUE,
			OFR.DEPTH_VALUE,
			OFR.HEIGHT_VALUE,
			OFR.ROW_PROJECT_ID,
			S.STOCK_CODE_2,
			OFR.EXPENSE_CENTER_ID,
			OFR.EXPENSE_ITEM_ID,
			OFR.ACTIVITY_TYPE_ID,
			OFR.ACC_CODE,
			OFR.BSMV_RATE,
			OFR.BSMV_AMOUNT,
			OFR.BSMV_CURRENCY,
			OFR.OIV_RATE,
			OFR.OIV_AMOUNT,
			OFR.TEVKIFAT_RATE,
			OFR.TEVKIFAT_AMOUNT,
			EXC.EXPENSE,
			EXI.EXPENSE_ITEM_NAME,
			'' AS ROW_WORK_ID,
			'' AS SUBSCRIPTION_ID,
			'' AS SUBSCRIPTION_HEAD,
			'' AS SUBSCRIPTION_NO,
			'' AS ASSETP_ID,
			'' AS ASSETP,
			'' as REASON_CODE,
			'' AS GTIP_NUMBER,
			OFR.OTV_TYPE,
			OFR.OTV_DISCOUNT,
			OFR.SPECIFIC_WEIGHT,
			OFR.WEIGHT,
			OFR.VOLUME 
		FROM
			#dsn3_alias#.OFFER_ROW OFR
			LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON OFR.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
			LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON OFR.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID,
			#dsn3_alias#.STOCKS S
			
		WHERE
			OFR.STOCK_ID = S.STOCK_ID AND
			<cfif isDefined("offer_row_list") and listLen(offer_row_list)>
				OFR.OFFER_ID IN (#ListDeleteDuplicates(offer_row_list)#) AND
				OFR.WRK_ROW_ID IN (#ListQualify(wrk_row_list,"'",",")#)
			<cfelse>
				OFR.OFFER_ID IN (#attributes.offer_id#)
			</cfif>
		ORDER BY
			OFR.OFFER_ROW_ID
	</cfquery>
<cfelseif isdefined("attributes.order_id")>
	<cfquery name="GET_ORDER_PRODUCTS" datasource="#DSN3#">
		SELECT
			ORR.*,
			S.PROPERTY,
			S.STOCK_CODE,
			S.BARCOD,
			S.MANUFACT_CODE,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.STOCK_CODE_2,
			EXC.EXPENSE,
			EXI.EXPENSE_ITEM_NAME,
			SC.SUBSCRIPTION_NO,
			SC.SUBSCRIPTION_HEAD,
			ASSP.ASSETP
		FROM
			ORDER_ROW ORR WITH (NOLOCK)
			LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON ORR.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
			LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON ORR.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID
			LEFT JOIN #dsn3#.SUBSCRIPTION_CONTRACT AS SC ON ORR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID
			LEFT JOIN #dsn#.ASSET_P AS ASSP ON ORR.ASSETP_ID = ASSP.ASSETP_ID,
			STOCKS S WITH (NOLOCK)
		WHERE
			ORR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
			AND ORR.STOCK_ID = S.STOCK_ID
			<cfif isdefined("attributes.is_copy") and attributes.is_copy eq 1> <!--- // satıs siparis kopyalamada aktif ve satıstaki urunleri getirmek icin --->
                AND S.PRODUCT_STATUS = 1
                AND S.IS_SALES = 1
			</cfif>
		ORDER BY
			ORR.ORDER_ROW_ID
	</cfquery>


<cfelse>
	<cfset get_order_products.recordcount = 0>
</cfif>

<cfif get_order_products.recordcount>
	<cfset basket_emp_id_list=listsort(ListDeleteDuplicates(valuelist(GET_ORDER_PRODUCTS.BASKET_EMPLOYEE_ID)),'numeric','asc',',')>
	<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_ORDER_PRODUCTS.ROW_PROJECT_ID)),'numeric','asc',',')>
    <cfset row_work_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_ORDER_PRODUCTS.ROW_WORK_ID)),'numeric','asc',',')>
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
	if( not isdefined('attributes.req_id') and not isdefined('attributes.from_project_material') and not isdefined('attributes.demand_id') and not isdefined("form.offer_row_check_info") and not isdefined("attributes.offer_id") and not isdefined("attributes.opp_id"))
	{
		sepet.other_money = GET_ORDER_DETAIL.OTHER_MONEY;
		if( len(get_order_detail.general_prom_id))
		{
			sepet.general_prom_id = get_order_detail.general_prom_id;
			sepet.general_prom_limit = get_order_detail.general_prom_limit;
			sepet.general_prom_discount = get_order_detail.general_prom_discount;
			sepet.general_prom_amount = get_order_detail.general_prom_amount;
		}
		if( len(get_order_detail.free_prom_id))
		{
			sepet.free_prom_id = get_order_detail.free_prom_id;
			sepet.free_prom_limit = get_order_detail.free_prom_limit;
			sepet.free_prom_amount = get_order_detail.free_prom_amount;
			sepet.free_prom_cost = get_order_detail.free_prom_cost;
			sepet.free_prom_stock_id = get_order_detail.free_prom_stock_id;
			sepet.free_stock_price = get_order_detail.free_stock_price;
			sepet.free_stock_money = get_order_detail.free_stock_money;
		}
	}
	else if(isdefined("attributes.opp_id")){
		sepet.other_money = GET_ORDER_PRODUCTS.OTHER_MONEY;
	}
	else
		sepet.other_money = '';
		
	if (isdefined('GET_ORDER_DETAIL.SA_DISCOUNT') and isnumeric(GET_ORDER_DETAIL.SA_DISCOUNT))
		sepet.genel_indirim = GET_ORDER_DETAIL.SA_DISCOUNT;
	//eger teklif siparise donusmusse
	if (isdefined('GET_OFFER.SA_DISCOUNT') and isnumeric(GET_OFFER.SA_DISCOUNT))
		sepet.genel_indirim = GET_OFFER.SA_DISCOUNT;
		
	for (i = 1; i lte get_order_products.recordcount;i=i+1)
	{
		sepet.satir[i] = StructNew();
		if(isdefined('attributes.from_project_material')) //proje mazleme planından siparis olusturulacaksa
		{
			sepet.satir[i].wrk_row_relation_id=get_order_products.WRK_ROW_ID[i];
			sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
			sepet.satir[i].related_action_id='';
			sepet.satir[i].related_action_table='';
		}
	
		else if(isdefined("attributes.is_copy") and attributes.is_copy eq 1) //siparis kopyalama
		{
			sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
			if(isdefined("get_order_products.wrk_row_id") and len(get_order_products.wrk_row_id[i]) and (isdefined("attributes.update_order") or isdefined("attributes.upd_order")))
				sepet.satir[i].wrk_row_relation_id=get_order_products.wrk_row_id[i];
			else
				sepet.satir[i].wrk_row_relation_id='';
			sepet.satir[i].related_action_id='';
			sepet.satir[i].related_action_table='';
		}
		else if((isdefined("attributes.offer_row_check_info") and len(attributes.offer_row_check_info) or (isDefined("attributes.offer_id") and Len(attributes.offer_id)) or (isdefined("attributes.offer_to_order") and attributes.offer_to_order eq 1)) and  not (attributes.fuseaction contains 'list_order' and (isdefined("url.event") and url.event is 'upd'))) // iliskili teklif siparise donusturme
		{
			sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
			sepet.satir[i].wrk_row_relation_id=get_order_products.WRK_ROW_ID[i];
			sepet.satir[i].related_action_id=get_order_products.offer_id[i];
			sepet.satir[i].related_action_table="OFFER";
		}
		else //satış siparisi guncelleme
		{
			sepet.satir[i].wrk_row_relation_id = get_order_products.wrk_row_relation_id[i];
			sepet.satir[i].wrk_row_id=get_order_products.WRK_ROW_ID[i];
			sepet.satir[i].related_action_id=get_order_products.RELATED_ACTION_ID[i];
			sepet.satir[i].related_action_table=get_order_products.RELATED_ACTION_TABLE[i];
		}

		if(len(get_order_products.ROW_PRO_MATERIAL_ID[i])) // MALZEME PLANINDAN GELMISSE SATIRIN HANGISINDEN GELDIDINI TUTUYOR
			sepet.satir[i].row_ship_id = get_order_products.ROW_PRO_MATERIAL_ID[i];
		
		if(len(get_order_products.LIST_PRICE[i])) sepet.satir[i].list_price = get_order_products.LIST_PRICE[i]; else sepet.satir[i].list_price = get_order_products.PRICE[i];
		if(len(get_order_products.PRICE_CAT[i])) sepet.satir[i].price_cat = get_order_products.PRICE_CAT[i]; else  sepet.satir[i].price_cat = '';
		if(len(get_order_products.CATALOG_ID[i])) sepet.satir[i].row_catalog_id = get_order_products.CATALOG_ID[i]; else  sepet.satir[i].row_catalog_id = '';
		if(len(get_order_products.NUMBER_OF_INSTALLMENT[i])) sepet.satir[i].number_of_installment = get_order_products.NUMBER_OF_INSTALLMENT[i]; else sepet.satir[i].number_of_installment = 0;
		
		sepet.satir[i].action_row_id = get_order_products.order_row_id[i]; 
		sepet.satir[i].product_id = get_order_products.product_id[i];
		sepet.satir[i].product_name = get_order_products.product_name[i];
		sepet.satir[i].paymethod_id = get_order_products.paymethod_id[i];
		sepet.satir[i].amount = get_order_products.quantity[i];
		sepet.satir[i].unit = get_order_products.unit[i];
		sepet.satir[i].unit_id = get_order_products.unit_id[i];
		sepet.satir[i].special_code = get_order_products.stock_code_2[i];
		if( len(get_order_products.unique_relation_id[i]) ) sepet.satir[i].row_unique_relation_id = get_order_products.unique_relation_id[i]; else sepet.satir[i].row_unique_relation_id = "";
		if( len(get_order_products.prom_relation_id[i]) ) sepet.satir[i].prom_relation_id = get_order_products.prom_relation_id[i]; else sepet.satir[i].prom_relation_id = "";
		if( len(get_order_products.product_name2[i]) ) sepet.satir[i].product_name_other = get_order_products.product_name2[i]; else sepet.satir[i].product_name_other = "";
		if( len(get_order_products.amount2[i]) ) sepet.satir[i].amount_other = get_order_products.amount2[i]; else sepet.satir[i].amount_other = "";
		if( len(get_order_products.unit2[i]) ) sepet.satir[i].unit_other = get_order_products.unit2[i]; else sepet.satir[i].unit_other = "";
		if( len(get_order_products.extra_price[i]) ) sepet.satir[i].ek_tutar = get_order_products.extra_price[i]; else sepet.satir[i].ek_tutar = 0;
		if( len(get_order_products.extra_price_total[i]) ) sepet.satir[i].ek_tutar_total = get_order_products.extra_price_total[i]; else sepet.satir[i].ek_tutar_total = 0;
		if( len(get_order_products.EXTRA_PRICE_OTHER_TOTAL[i])) sepet.satir[i].ek_tutar_other_total = get_order_products.EXTRA_PRICE_OTHER_TOTAL[i]; else sepet.satir[i].ek_tutar_other_total = 0;

		if(len(get_order_products.WIDTH_VALUE[i])) sepet.satir[i].row_width = get_order_products.WIDTH_VALUE[i]; else sepet.satir[i].row_width = '';
		if(len(get_order_products.DEPTH_VALUE[i])) sepet.satir[i].row_depth = get_order_products.DEPTH_VALUE[i]; else  sepet.satir[i].row_depth = '';
		if(len(get_order_products.HEIGHT_VALUE[i])) sepet.satir[i].row_height = get_order_products.HEIGHT_VALUE[i]; else  sepet.satir[i].row_height = '';
		if(isdefined("get_order_products.PAYMETHOD_ID") and len(get_order_products.PAYMETHOD_ID[i])) sepet.satir[i].row_paymethod_id = get_order_products.PAYMETHOD_ID[i]; else  sepet.satir[i].row_paymethod_id = '';
		if(len(get_order_products.ROW_PROJECT_ID[i]))
		{
			sepet.satir[i].row_project_id=get_order_products.ROW_PROJECT_ID[i];
			sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,get_order_products.ROW_PROJECT_ID[i])];
		}
		if(len(get_order_products.ROW_WORK_ID[i]))
		{
			sepet.satir[i].row_work_id=get_order_products.ROW_WORK_ID[i];
			sepet.satir[i].row_work_name=GET_ROW_WORKS.WORK_HEAD[listfind(row_work_id_list_,get_order_products.ROW_WORK_ID[i])];
		}

		if(len(get_order_products.ek_tutar_price[i]))
		{
			sepet.satir[i].ek_tutar_price = get_order_products.ek_tutar_price[i];
			if(len(get_order_products.amount2[i])) sepet.satir[i].ek_tutar_cost = get_order_products.ek_tutar_price[i]*get_order_products.amount2[i]; else sepet.satir[i].ek_tutar_cost = get_order_products.ek_tutar_price[i];
		}
		else
		{ sepet.satir[i].ek_tutar_price = 0;sepet.satir[i].ek_tutar_cost =0;}
		
		if(len(sepet.satir[i].ek_tutar_cost) and sepet.satir[i].ek_tutar_cost neq 0)
			sepet.satir[i].ek_tutar_marj = (sepet.satir[i].ek_tutar*100/sepet.satir[i].ek_tutar_cost)-100;
		else
			sepet.satir[i].ek_tutar_marj ='';
		
		if( len(get_order_products.shelf_number[i]) ) sepet.satir[i].shelf_number = get_order_products.shelf_number[i]; else sepet.satir[i].shelf_number = "";
		if( len(get_order_products.BASKET_EXTRA_INFO_ID[i]) ) sepet.satir[i].basket_extra_info = get_order_products.BASKET_EXTRA_INFO_ID[i]; else sepet.satir[i].basket_extra_info="";
		if( len(get_order_products.SELECT_INFO_EXTRA[i]) ) sepet.satir[i].select_info_extra = get_order_products.SELECT_INFO_EXTRA[i]; else sepet.satir[i].select_info_extra="";
		if( len(get_order_products.DETAIL_INFO_EXTRA[i]) ) sepet.satir[i].detail_info_extra = get_order_products.DETAIL_INFO_EXTRA[i]; else sepet.satir[i].detail_info_extra="";
		if( len(get_order_products.price[i])) 
			sepet.satir[i].price = get_order_products.price[i];
		else
			sepet.satir[i].price = 0;
		sepet.satir[i].net_maliyet = get_order_products.COST_PRICE[i];
		sepet.satir[i].marj = get_order_products.MARJ[i];
		if (len(get_order_products.EXTRA_COST[i]))	
			sepet.satir[i].extra_cost = get_order_products.EXTRA_COST[i];
		else
			sepet.satir[i].extra_cost = 0;
		if(len(get_order_products.price_other[i]))
			sepet.satir[i].price_other = get_order_products.price_other[i];
		else
			sepet.satir[i].price_other = get_order_products.price[i];
		sepet.satir[i].tax_percent = get_order_products.tax[i];
		if(len(get_order_products.OTV_ORAN[i])) //özel tüketim vergisi
			sepet.satir[i].otv_oran = get_order_products.OTV_ORAN[i];
		else 
			sepet.satir[i].otv_oran = 0;
		sepet.satir[i].catalog_id = 0;
		sepet.satir[i].stock_id = get_order_products.stock_id[i];
		sepet.satir[i].manufact_code = get_order_products.PRODUCT_MANUFACT_CODE[i];
		sepet.satir[i].duedate = get_order_products.duedate[i];
	
		sepet.satir[i].promosyon_yuzde = get_order_products.PROM_COMISSION[i];
		if (len(get_order_products.PROM_COST[i]))	
			sepet.satir[i].promosyon_maliyet = get_order_products.PROM_COST[i];
		else
			sepet.satir[i].promosyon_maliyet = 0;
		sepet.satir[i].iskonto_tutar = get_order_products.DISCOUNT_COST[i];
		sepet.satir[i].is_promotion = get_order_products.IS_PROMOTION[i];
		sepet.satir[i].prom_stock_id = get_order_products.prom_stock_id[i];
		sepet.satir[i].row_promotion_id =get_order_products.PROM_ID[i] ;
		
		sepet.satir[i].is_commission = get_order_products.IS_COMMISSION[i];
		if(isdefined("attributes.is_copy") and attributes.is_copy)
		{
			sepet.satir[i].order_currency = -1;
		}
		else 
			sepet.satir[i].order_currency = get_order_products.ORDER_ROW_CURRENCY[i];
		if( not isdefined('attributes.from_project_material'))
		{
			sepet.satir[i].list_price = get_order_products.LIST_PRICE[i];
			sepet.satir[i].price_cat = get_order_products.PRICE_CAT[i];
			sepet.satir[i].number_of_installment = get_order_products.NUMBER_OF_INSTALLMENT[i];
		}

		if( len(get_order_products.KARMA_PRODUCT_ID[i]) ) sepet.satir[i].karma_product_id = get_order_products.KARMA_PRODUCT_ID[i]; else sepet.satir[i].karma_product_id = "";
		if (not len(get_order_products.discount_1[i])) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = get_order_products.discount_1[i];
		if (not len(get_order_products.discount_2[i])) sepet.satir[i].indirim2 = 0; else sepet.satir[i].indirim2 = get_order_products.discount_2[i];
		if (not len(get_order_products.discount_3[i])) sepet.satir[i].indirim3 = 0; else sepet.satir[i].indirim3 = get_order_products.discount_3[i];
		if (not len(get_order_products.discount_4[i])) sepet.satir[i].indirim4 = 0; else sepet.satir[i].indirim4 = get_order_products.discount_4[i];
		if (not len(get_order_products.discount_5[i])) sepet.satir[i].indirim5 = 0; else sepet.satir[i].indirim5 = get_order_products.discount_5[i];
		if (not len(get_order_products.discount_6[i])) sepet.satir[i].indirim6 = 0; else sepet.satir[i].indirim6 = get_order_products.discount_6[i];
		if (not len(get_order_products.discount_7[i])) sepet.satir[i].indirim7 = 0; else sepet.satir[i].indirim7 = get_order_products.discount_7[i];
		if (not len(get_order_products.discount_8[i])) sepet.satir[i].indirim8 = 0; else sepet.satir[i].indirim8 = get_order_products.discount_8[i];
		if (not len(get_order_products.discount_9[i])) sepet.satir[i].indirim9 = 0; else sepet.satir[i].indirim9 = get_order_products.discount_9[i];
		if (not len(get_order_products.discount_10[i])) sepet.satir[i].indirim10 = 0; else sepet.satir[i].indirim10 = get_order_products.discount_10[i];
		sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);

		sepet.satir[i].deliver_date = dateformat(get_order_products.deliver_date[i],dateformat_style);
		if(len(trim(get_order_products.deliver_LOCATION[i]))){
			sepet.satir[i].deliver_dept = "#get_order_products.deliver_dept[i]#-#get_order_products.deliver_LOCATION[i]#";
		}else{
			sepet.satir[i].deliver_dept = "#get_order_products.deliver_dept[i]#";
		}
		
		if (isdefined("attributes.is_copy") and attributes.is_copy and len(get_order_products.SPECT_VAR_ID[i]) and get_order_products.SPECT_VAR_ID[i] neq 0)
		{
			main_spec_sql = "SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID="&get_order_products.SPECT_VAR_ID[i];
			get_main_spec = cfquery(SQLString : main_spec_sql, Datasource : DSN3);
			if(isdefined("get_money_bskt"))
			{
				money_list='';
				money_rate1_list='';
				money_rate2_list='';
				for(spec_money=1;spec_money lte get_money_bskt.recordcount;spec_money=spec_money+1)
				{
					money_list=listappend(money_list,get_money_bskt.MONEY_TYPE,',');
					money_rate1_list=listappend(money_rate1_list,get_money_bskt.RATE1,',');
					money_rate2_list=listappend(money_rate2_list,get_money_bskt.RATE2,',');
				}
				spec_money_list='money_list:#money_list#,money_rate1_list:#money_rate1_list#,';
			}
			if(len(GET_ORDER_DETAIL.COMPANY_ID))
				spec_member='company_id:#GET_ORDER_DETAIL.COMPANY_ID#';
			else
				spec_member='consumer_id:#GET_ORDER_DETAIL.CONSUMER_ID#';
			new_creat_spect_var=specer(
				dsn_type:dsn3,
				main_spec_id:get_main_spec.SPECT_MAIN_ID,
				add_to_main_spec:1);
			sepet.satir[i].spect_id = ListGetAt(new_creat_spect_var,2,',');
			sepet.satir[i].spect_name =ListGetAt(new_creat_spect_var,3,',');
		}
		else
		{
			sepet.satir[i].spect_id = get_order_products.SPECT_VAR_ID[i];
			sepet.satir[i].spect_name = get_order_products.SPECT_VAR_NAME[i];
		}

		sepet.satir[i].other_money = get_order_products.OTHER_MONEY[i];
		sepet.satir[i].other_money_value = get_order_products.OTHER_MONEY_VALUE[i];
		sepet.satir[i].lot_no = get_order_products.LOT_NO[i];

		if(len(get_order_products.BASKET_EMPLOYEE_ID[i]))
		{	
			sepet.satir[i].basket_employee_id = get_order_products.BASKET_EMPLOYEE_ID[i]; 
			sepet.satir[i].basket_employee = GET_BASKET_EMPLOYEES.BASKET_EMPLOYEE[listfind(basket_emp_id_list,get_order_products.BASKET_EMPLOYEE_ID[i])]; 
		}
		else
		{		
			sepet.satir[i].basket_employee_id = '';
			sepet.satir[i].basket_employee = '';
		}

		if(isdefined("attributes.is_copy") and attributes.is_copy)
		{
			if(listfind('-1,-2,-4',get_order_products.RESERVE_TYPE[i])) //rezerve, kapatılmıs rezerve ve kısmı rezerve secenekleri copy siparise rezerve olarak tasınır
				sepet.satir[i].reserve_type = -1;
			else
				sepet.satir[i].reserve_type = -3; //rezerve degil
		}
		else
			sepet.satir[i].reserve_type=get_order_products.RESERVE_TYPE[i];
		if(len(get_order_products.reserve_date[i]))
			sepet.satir[i].reserve_date = dateformat(get_order_products.reserve_date[i],dateformat_style);
		else
			sepet.satir[i].reserve_date ='';
		sepet.satir[i].barcode = get_order_products.barcod[i];
		sepet.satir[i].stock_code = get_order_products.stock_code[i];
		sepet.satir[i].is_inventory = get_order_products.is_inventory[i];
		sepet.satir[i].is_production = get_order_products.is_production[i];
		sepet.satir[i].row_total = wrk_round((sepet.satir[i].amount * sepet.satir[i].price) + sepet.satir[i].ek_tutar_total,price_round_number);
		if(len(get_order_products.NETTOTAL[i]))
			sepet.satir[i].row_nettotal = get_order_products.NETTOTAL[i];
		else
		{
			sepet.satir[i].row_nettotal = sepet.satir[i].row_total;
			if(len(sepet.satir[i].iskonto_tutar) and get_money_bskt.recordcount)
				for(k=1;k lte get_money_bskt.recordcount;k=k+1)
					if(sepet.satir[i].other_money eq get_money_bskt.MONEY_TYPE[k])
						sepet.satir[i].row_nettotal = sepet.satir[i].row_nettotal - (sepet.satir[i].iskonto_tutar * get_money_bskt.RATE2[k] / get_money_bskt.RATE1[k] * sepet.satir[i].amount);
			if(len(sepet.satir[i].promosyon_yuzde))
				sepet.satir[i].row_nettotal = sepet.satir[i].row_nettotal * (100-sepet.satir[i].promosyon_yuzde) /100;
	
			sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_nettotal * sepet.satir[i].indirim_carpan) /100000000000000000000,price_round_number);
		}
		if(len(get_order_products.OTVTOTAL[i]))
		{ 
			sepet.satir[i].row_otvtotal = get_order_products.OTVTOTAL[i];
		}
		else
		{
		 	sepet.satir[i].row_otvtotal = 0;
		}
		if (ListFindNoCase(display_list, "otv_from_tax_price"))
			sepet.satir[i].row_taxtotal = wrk_round(((sepet.satir[i].row_nettotal+sepet.satir[i].row_otvtotal) * (sepet.satir[i].tax_percent/100)),price_round_number);
		else
			sepet.satir[i].row_taxtotal = wrk_round((sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100)),price_round_number);
		sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal + sepet.satir[i].row_otvtotal;
		sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
		sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
		sepet.net_total = sepet.net_total + sepet.satir[i].row_nettotal; //nettotal_

		// kdv array
		kdv_flag = 0;
		for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		{
			if (sepet.kdv_array[k][1] eq sepet.satir[i].tax_percent)
				{
				kdv_flag = 1;
				sepet.kdv_array[k][2] = sepet.kdv_array[k][2] + 0;
				if (ListFindNoCase(display_list, "otv_from_tax_price"))
					sepet.kdv_array[k][3] = sepet.kdv_array[k][3] + wrk_round((sepet.satir[i].row_nettotal+sepet.satir[i].row_otvtotal),basket_total_round_number);
				else
					sepet.kdv_array[k][3] = sepet.kdv_array[k][3] + wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);
				}
		}
		if (not kdv_flag)
		{
			sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = sepet.satir[i].tax_percent;
			sepet.kdv_array[arraylen(sepet.kdv_array)][2] = 0;
			if (ListFindNoCase(display_list, "otv_from_tax_price"))
				sepet.kdv_array[arraylen(sepet.kdv_array)][3] = wrk_round((sepet.satir[i].row_nettotal+sepet.satir[i].row_otvtotal),basket_total_round_number);
			else
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
		// urun asortileri 
		SQLString = "SELECT * FROM PRODUCTION_ASSORTMENT WHERE ACTION_TYPE=2 AND ASSORTMENT_ID=#get_order_products.ORDER_ROW_ID[i]# ORDER BY PARSE1,PARSE2";
		get_assort = cfquery(SQLString : SQLString, Datasource : DSN3);

		sepet.satir[i].assortment_array = ArrayNew(1);
		for(j = 1 ; j lte get_assort.recordcount ; j=j+1)
		{
			sepet.satir[i].assortment_array[j] = StructNew();
			sepet.satir[i].assortment_array[j].property_id = get_assort.PARSE1[j];
			sepet.satir[i].assortment_array[j].property_detail_id = get_assort.PARSE2[j];
			sepet.satir[i].assortment_array[j].property_amount = get_assort.AMOUNT[j];
		}
		//abort('toplam İndirim:#sepet.toplam_indirim#')	;

		/*Masraf Merkezi*/
			if( len(GET_ORDER_PRODUCTS.EXPENSE_CENTER_ID[i]) )
			{
				sepet.satir[i].row_exp_center_id = GET_ORDER_PRODUCTS.EXPENSE_CENTER_ID[i];
				sepet.satir[i].row_exp_center_name = GET_ORDER_PRODUCTS.EXPENSE[i];
			}
	
			//Aktivite Tipi
			sepet.satir[i].row_activity_id = GET_ORDER_PRODUCTS.ACTIVITY_TYPE_ID[i];
	
			//Bütçe Kalemi
			if( len(GET_ORDER_PRODUCTS.EXPENSE_ITEM_ID[i]) )
			{
				sepet.satir[i].row_exp_item_id = GET_ORDER_PRODUCTS.EXPENSE_ITEM_ID[i];
				sepet.satir[i].row_exp_item_name = GET_ORDER_PRODUCTS.EXPENSE_ITEM_NAME[i];
			}
	
			//Muhasebe Kodu
			if(len(GET_ORDER_PRODUCTS.ACC_CODE[i]))
			{
				sepet.satir[i].row_acc_code = GET_ORDER_PRODUCTS.ACC_CODE[i];
			}
			
			if(len(GET_ORDER_PRODUCTS.gtip_number[i]))
				sepet.satir[i].gtip_number=GET_ORDER_PRODUCTS.gtip_number[i];
			else
				sepet.satir[i].gtip_number='';

			sepet.satir[i].row_subscription_id = ( len( GET_ORDER_PRODUCTS.SUBSCRIPTION_ID[i] ) ) ? GET_ORDER_PRODUCTS.SUBSCRIPTION_ID[i] : '';
			sepet.satir[i].row_subscription_name = ( len( GET_ORDER_PRODUCTS.SUBSCRIPTION_NO[i] ) and len( GET_ORDER_PRODUCTS.SUBSCRIPTION_HEAD[i] ) ) ? GET_ORDER_PRODUCTS.SUBSCRIPTION_NO[i] & " - " & GET_ORDER_PRODUCTS.SUBSCRIPTION_HEAD[i] : '';
			sepet.satir[i].row_assetp_id = ( len( GET_ORDER_PRODUCTS.ASSETP_ID[i] ) ) ? GET_ORDER_PRODUCTS.ASSETP_ID[i] : '';
			sepet.satir[i].row_assetp_name = ( len( GET_ORDER_PRODUCTS.ASSETP[i] ) ) ? GET_ORDER_PRODUCTS.ASSETP[i] : '';
			sepet.satir[i].row_oiv_rate = ( len( GET_ORDER_PRODUCTS.OIV_RATE[i] ) ) ? GET_ORDER_PRODUCTS.OIV_RATE[i] : '';
			sepet.satir[i].row_oiv_amount = ( len( GET_ORDER_PRODUCTS.OIV_AMOUNT[i] ) ) ? GET_ORDER_PRODUCTS.OIV_AMOUNT[i] : '';
			sepet.satir[i].row_bsmv_rate = ( len( GET_ORDER_PRODUCTS.BSMV_RATE[i] ) ) ? GET_ORDER_PRODUCTS.BSMV_RATE[i] : '';
			sepet.satir[i].row_bsmv_amount = ( len( GET_ORDER_PRODUCTS.BSMV_AMOUNT[i] ) ) ? GET_ORDER_PRODUCTS.BSMV_AMOUNT[i] : '';
			sepet.satir[i].row_bsmv_currency = ( len( GET_ORDER_PRODUCTS.BSMV_CURRENCY[i] ) ) ? GET_ORDER_PRODUCTS.BSMV_CURRENCY[i] : '';
			sepet.satir[i].row_tevkifat_rate = ( len( GET_ORDER_PRODUCTS.TEVKIFAT_RATE[i] ) ) ? GET_ORDER_PRODUCTS.TEVKIFAT_RATE[i] : '';
			sepet.satir[i].row_tevkifat_amount = ( len( GET_ORDER_PRODUCTS.TEVKIFAT_AMOUNT[i] ) ) ? GET_ORDER_PRODUCTS.TEVKIFAT_AMOUNT[i] : '';
			sepet.satir[i].reason_code = ( len( GET_ORDER_PRODUCTS.REASON_CODE[i] ) ) ? GET_ORDER_PRODUCTS.REASON_CODE[i] & '--' & GET_ORDER_PRODUCTS.REASON_NAME[i] : '';
			sepet.satir[i].otv_type = ( len( GET_ORDER_PRODUCTS.OTV_TYPE[i] ) ) ? GET_ORDER_PRODUCTS.OTV_TYPE[i] : '';
			sepet.satir[i].reason_code = ( len( GET_ORDER_PRODUCTS.OTV_DISCOUNT[i] ) ) ? GET_ORDER_PRODUCTS.OTV_DISCOUNT[i] : '';
			sepet.satir[i].row_weight = ( len( GET_ORDER_PRODUCTS.WEIGHT[i] ) ) ? GET_ORDER_PRODUCTS.WEIGHT[i] : '';
			sepet.satir[i].row_specific_weight = ( len( GET_ORDER_PRODUCTS.SPECIFIC_WEIGHT[i] ) ) ? GET_ORDER_PRODUCTS.SPECIFIC_WEIGHT[i] : '';
			sepet.satir[i].row_volume = ( len( GET_ORDER_PRODUCTS.VOLUME[i] ) ) ? GET_ORDER_PRODUCTS.VOLUME[i] : '';
		
	}
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
		
	
	for (t=1;t lte arraylen(sepet.otv_array);t=t+1)
		sepet.total_otv = sepet.total_otv + wrk_round(sepet.otv_array[t][2],price_round_number);
	
	sepet.net_total = sepet.net_total + sepet.total_tax + sepet.total_otv;
</cfscript>
