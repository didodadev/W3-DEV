<cfif isdefined('attributes.is_from_report') and isdefined("attributes.is_wrk_row_id")><!--- toplu satınalma sipariş sayfası --->
	<cfset GET_UPD_PURCHASE.OTHER_MONEY = '#session.ep.money2#'>
	<cfset deliver_date ="#now()#">
	<cfset CONVERT_STOCKS_ID = left(attributes.CONVERT_STOCKS_ID,len(attributes.CONVERT_STOCKS_ID)-1)>
	<cfif isdefined("attributes.CONVERT_MONEY")>
		<cfset CONVERT_MONEY = left(attributes.CONVERT_MONEY,len(attributes.CONVERT_MONEY)-1)>
		<cfset CONVERT_PRICE = left(attributes.CONVERT_PRICE,len(attributes.CONVERT_PRICE)-1)>
		<cfset CONVERT_PRICE_OTHER = left(attributes.CONVERT_PRICE_OTHER,len(attributes.CONVERT_PRICE_OTHER)-1)>
	</cfif>
	<cfif not listlen(attributes.convert_demand_row_id)><cfset convert_demand_row_id = 0><cfelse><cfset convert_demand_row_id = attributes.convert_demand_row_id></cfif>
	<cfif not listlen(attributes.convert_order_row_id)><cfset convert_order_row_id = 0><cfelse><cfset convert_order_row_id =attributes.convert_order_row_id></cfif>
	<cfquery name="GET_ORDER_PRODUCTS" datasource="#DSN3#">
		SELECT
			'' ORDER_ROW_ID, 
			S.PRODUCT_ID,
			S.STOCK_ID,
			S.MANUFACT_CODE AS PRODUCT_MANUFACT_CODE,
			S.PROPERTY,
			S.BARCOD,
			S.STOCK_CODE,
			S.PRODUCT_NAME+' - '+ISNULL(S.PROPERTY,'') PRODUCT_NAME,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.STOCK_CODE_2,
			S.TAX TAX_,
			S.TAX_PURCHASE TAX,
			S.TAX_PURCHASE,
			PRODUCT_UNIT.MAIN_UNIT AS UNIT,
			PRODUCT_UNIT.PRODUCT_UNIT_ID AS UNIT_ID,
			<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
				0 PRICE,
				ISNULL((SELECT TOP 1 PP.PRICE FROM PRICE PP WHERE PP.PRODUCT_ID = S.PRODUCT_ID AND PP.PRICE_CATID = #attributes.price_catid# AND (PP.STARTDATE <=#now()# AND (PP.FINISHDATE IS NULL OR PP.FINISHDATE >=#now()#))),0) PRICE_OTHER,
				#attributes.price_catid# PRICE_CAT,
				ISNULL((SELECT TOP 1 PP.MONEY FROM PRICE PP WHERE PP.PRODUCT_ID = S.PRODUCT_ID AND PP.PRICE_CATID = #attributes.price_catid# AND (PP.STARTDATE <=#now()# AND (PP.FINISHDATE IS NULL OR PP.FINISHDATE >=#now()#))),'TL') AS OTHER_MONEY,
			<cfelse>	
				0 PRICE,
				0 AS PRICE_OTHER,
				'' PRICE_CAT,
				 OTHER_MONEY,
			</cfif>
			'TL' AS OTHER_MONEY_VALUE,
			ORR.PRODUCT_NAME2,
			'' AS DELIVER_DEPT,
			ORR.SPECT_VAR_ID AS SPECT_VAR_ID,
			ORR.SPECT_VAR_NAME AS SPECT_VAR_NAME,
			'' AS LOT_NO,
			'' AS I_ROW_ID,
			0 AS NETTOTAL,
			0 AS NET_TOTAL,
			'' AS TOTAL_TAX,
			0 AS OTV_ORAN,
			0 AS OTVTOTAL,
			0 AS TAXTOTAL,
			0 AS COST_PRICE,
			'' AS MARJ,
			0 AS EXTRA_COST,
			ORR.DISCOUNT_COST,
			ORR.AMOUNT2,
			0 AS EXTRA_PRICE,
			0 AS EK_TUTAR_PRICE,
			0 AS EXTRA_PRICE_TOTAL,
			0 AS EXTRA_PRICE_OTHER_TOTAL,
			'' AS UNIQUE_RELATION_ID,
			'' AS PROM_RELATION_ID,
			ORR.PRODUCT_NAME2,
			ORR.UNIT2,
			'' AS SHELF_NUMBER,
			'' AS BASKET_EXTRA_INFO_ID,
			'' SELECT_INFO_EXTRA,
			'' DETAIL_INFO_EXTRA,
			ORR.DISCOUNT_1,
			ORR.DISCOUNT_2,
			ORR.DISCOUNT_3,
			ORR.DISCOUNT_4,
			ORR.DISCOUNT_5,
			ORR.DISCOUNT_6,
			ORR.DISCOUNT_7,
			ORR.DISCOUNT_8,
			ORR.DISCOUNT_9,
			ORR.DISCOUNT_10,
			'' AS PRO_MATERIAL_ID,
			ORR.WRK_ROW_ID AS WRK_ROW_ID,
			ORR.WRK_ROW_RELATION_ID AS WRK_ROW_RELATION_ID,
			I_ID AS ROW_INTERNALDEMAND_ID,
			I_ROW_ID AS RELATED_INTERNALDEMAND_ROW_ID,
			'' AS WIDTH_VALUE,
			'' AS DEPTH_VALUE,
			'' AS HEIGHT_VALUE,
			'' AS ROW_PROJECT_ID,
			'' AS ROW_WORK_ID,
			'' AS LIST_PRICE,
			'' AS CATALOG_ID,
			'' AS NUMBER_OF_INSTALLMENT,
			<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
				ISNULL((SELECT TOP 1 PP.PRICE FROM PRICE PP WHERE PP.PRODUCT_ID = S.PRODUCT_ID AND PP.PRICE_CATID = #attributes.price_catid# AND (PP.STARTDATE <=#now()# AND (PP.FINISHDATE IS NULL OR PP.FINISHDATE >=#now()#))),0) PRICE,
				#attributes.price_catid# PRICE_CAT
			<cfelse>	
				PS.PRICE PRICE,
				'' PRICE_CAT
			</cfif>,
			'' AS RELATED_ACTION_ID,
			'' AS RELATED_ACTION_TABLE,
			'' BASKET_EMPLOYEE_ID,
			'' ROW_PRO_MATERIAL_ID,
			'' AS PAYMETHOD_ID,
			-1 RESERVE_TYPE,
			'' RESERVE_DATE,
			'' DUEDATE,
			-1 AS ORDER_ROW_CURRENCY,
			'' AS KARMA_PRODUCT_ID,
			'' DELIVER_DATE,
			'' DELIVER_LOCATION,
			'' DELIVER_DEPT,
			EXC.EXPENSE,
			EXC.EXPENSE_ID EXPENSE_CENTER_ID,
			EXI.EXPENSE_ITEM_ID,
			EXI.EXPENSE_ITEM_NAME,
			ORR.ACTIVITY_TYPE_ID,
			ORR.ACC_CODE
			,'' OIV_RATE
			,'' OIV_AMOUNT
			,'' BSMV_RATE
			,'' BSMV_AMOUNT
			,'' BSMV_CURRENCY
			,'' TEVKIFAT_RATE
			,'' TEVKIFAT_AMOUNT
		FROM
			STOCKS S,
			PRODUCT_UNIT,
			PRICE_STANDART AS PS,
			INTERNALDEMAND_ROW ORR
			LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON ORR.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
			LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON ORR.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID
		WHERE
			PRODUCT_UNIT.PRODUCT_ID = S.PRODUCT_ID AND
			PS.PRODUCT_ID = S.PRODUCT_ID AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND
			PS.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
			PS.PRICESTANDART_STATUS = 1 AND
			PS.PURCHASESALES = 0 AND
			ORR.STOCK_ID = S.STOCK_ID AND
			ORR.I_ROW_ID IN (#convert_demand_row_id#)
		UNION ALL
		SELECT
			'' ORDER_ROW_ID,
			S.PRODUCT_ID,
			S.STOCK_ID,
			S.MANUFACT_CODE AS PRODUCT_MANUFACT_CODE,
			S.PROPERTY,
			S.BARCOD,
			S.STOCK_CODE,
			S.PRODUCT_NAME+' - '+ISNULL(S.PROPERTY,'') PRODUCT_NAME,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.STOCK_CODE_2,
			S.TAX TAX_,
			S.TAX_PURCHASE TAX,
			S.TAX_PURCHASE,
			PRODUCT_UNIT.MAIN_UNIT AS UNIT,
			PRODUCT_UNIT.PRODUCT_UNIT_ID AS UNIT_ID,
			<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
				0 PRICE,
				ISNULL((SELECT TOP 1 PP.PRICE FROM PRICE PP WHERE PP.PRODUCT_ID = S.PRODUCT_ID AND PP.PRICE_CATID = #attributes.price_catid# AND (PP.STARTDATE <=#now()# AND (PP.FINISHDATE IS NULL OR PP.FINISHDATE >=#now()#))),0) PRICE_OTHER,
				#attributes.price_catid# PRICE_CAT,
				ISNULL((SELECT TOP 1 PP.MONEY FROM PRICE PP WHERE PP.PRODUCT_ID = S.PRODUCT_ID AND PP.PRICE_CATID = #attributes.price_catid# AND (PP.STARTDATE <=#now()# AND (PP.FINISHDATE IS NULL OR PP.FINISHDATE >=#now()#))),'TL') AS OTHER_MONEY,
			<cfelse>	
				0 PRICE,
				0 AS PRICE_OTHER,
				'' PRICE_CAT,
				 OTHER_MONEY,
			</cfif>
			'' AS OTHER_MONEY_VALUE,
			'' AS PRODUCT_NAME2,
			'' AS DELIVER_DEPT,
			ORR.SPECT_VAR_ID AS SPECT_VAR_ID,
			ORR.SPECT_VAR_NAME AS SPECT_VAR_NAME,
			'' AS LOT_NO,
			'' AS I_ROW_ID,
			0 AS NETTOTAL,
			0 AS NET_TOTAL,
			'' AS TOTAL_TAX,
			0 AS OTV_ORAN,
			0 AS OTVTOTAL,
			0 AS TAXTOTAL,
			0 AS COST_PRICE,
			'' AS MARJ,
			0 AS EXTRA_COST,
			0 AS DISCOUNT_COST,
			ORR.AMOUNT2,
			0 AS EXTRA_PRICE,
			0 AS EK_TUTAR_PRICE,
			0 AS EXTRA_PRICE_TOTAL,
			0 AS EXTRA_PRICE_OTHER_TOTAL,
			'' AS UNIQUE_RELATION_ID,
			'' AS PROM_RELATION_ID,
			'' AS PRODUCT_NAME2,
			ORR.UNIT2,
			'' AS SHELF_NUMBER,
			'' AS BASKET_EXTRA_INFO_ID,
			'' SELECT_INFO_EXTRA,
			'' DETAIL_INFO_EXTRA,
			0 AS DISCOUNT_1,
			0 AS DISCOUNT_2,
			0 AS DISCOUNT_3,
			0 AS DISCOUNT_4,
			0 AS DISCOUNT_5,
			0 AS DISCOUNT_6,
			0 AS DISCOUNT_7,
			0 AS DISCOUNT_8,
			0 AS DISCOUNT_9,
			0 AS DISCOUNT_10,
			'' AS PRO_MATERIAL_ID,
			ORR.WRK_ROW_ID AS WRK_ROW_ID,
			ORR.WRK_ROW_RELATION_ID AS WRK_ROW_RELATION_ID,
			'' AS ROW_INTERNALDEMAND_ID,
			'' RELATED_INTERNALDEMAND_ROW_ID,
			'' AS WIDTH_VALUE,
			'' AS DEPTH_VALUE,
			'' AS HEIGHT_VALUE,
			'' AS ROW_PROJECT_ID,
			'' AS ROW_WORK_ID,
			'' AS LIST_PRICE,
			'' AS CATALOG_ID,
			'' AS NUMBER_OF_INSTALLMENT,
			<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
				ISNULL((SELECT TOP 1 PP.PRICE FROM PRICE PP WHERE PP.PRODUCT_ID = S.PRODUCT_ID AND PP.PRICE_CATID = #attributes.price_catid# AND (PP.STARTDATE <=#now()# AND (PP.FINISHDATE IS NULL OR PP.FINISHDATE >=#now()#))),0) PRICE,
				#attributes.price_catid# PRICE_CAT
			<cfelse>	
				PS.PRICE PRICE,
				'' PRICE_CAT
			</cfif>,
			'' AS RELATED_ACTION_ID,
			'' AS RELATED_ACTION_TABLE,
			'' BASKET_EMPLOYEE_ID,
			'' ROW_PRO_MATERIAL_ID,
			'' AS PAYMETHOD_ID,
			-1 RESERVE_TYPE,
			'' RESERVE_DATE,
			'' DUEDATE,
			-1 AS ORDER_ROW_CURRENCY,
			'' AS KARMA_PRODUCT_ID,
			'' DELIVER_DATE,
			'' DELIVER_LOCATION,
			'' DELIVER_DEPT,
			EXC.EXPENSE,
			EXC.EXPENSE_ID EXPENSE_CENTER_ID,
			EXI.EXPENSE_ITEM_ID,
			EXI.EXPENSE_ITEM_NAME,
			ORR.ACTIVITY_TYPE_ID,
			ORR.ACC_CODE
			,ORR.OIV_RATE
			,ORR.OIV_AMOUNT
			,ORR.BSMV_RATE
			,ORR.BSMV_AMOUNT
			,ORR.BSMV_CURRENCY
			,ORR.TEVKIFAT_RATE
			,ORR.TEVKIFAT_AMOUNT
		FROM
			STOCKS S,
			PRODUCT_UNIT,
			PRICE_STANDART AS PS,
			ORDER_ROW ORR
			LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON ORR.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
			LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON ORR.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID
		WHERE
			PRODUCT_UNIT.PRODUCT_ID = S.PRODUCT_ID AND
			PS.PRODUCT_ID = S.PRODUCT_ID AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND
			PS.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
			PS.PRICESTANDART_STATUS = 1 AND
			PS.PURCHASESALES = 0 AND
			ORR.STOCK_ID = S.STOCK_ID AND
			ORR.ORDER_ROW_ID IN (#convert_order_row_id#)
	</cfquery>
	<cfif len(convert_demand_row_id)>
		<cfquery name="get_demands" datasource="#dsn3#">
			SELECT DISTINCT I_ID FROM INTERNALDEMAND_ROW WHERE I_ROW_ID IN (#convert_demand_row_id#)
		</cfquery>
		<cfif get_demands.recordcount>
			<script>
				document.form_basket.internaldemand_id_list.value = "<cfoutput>#valuelist(get_demands.I_ID)#</cfoutput>";
			</script>
		</cfif>
	</cfif>
	<cfif len(GET_ORDER_PRODUCTS.DELIVER_DEPT)>
		<cfset get_order_detail.deliver_dept_id = GET_ORDER_PRODUCTS.DELIVER_DEPT>
	<cfelse>
		<cfset get_order_detail.deliver_dept_id = ''>
	</cfif>
<cfelseif isdefined('attributes.is_from_report')>
	<cfset GET_UPD_PURCHASE.OTHER_MONEY = '#session.ep.money2#'>
	<cfset deliver_date ="#now()#"><!--- Üretim Malzeme İhtiyaçları listesinden dönüşüm yapılıyorsa --->
	<cfset CONVERT_STOCKS_ID = left(attributes.CONVERT_STOCKS_ID,len(attributes.CONVERT_STOCKS_ID)-1)>
	<cfif isdefined("attributes.CONVERT_MONEY")>
		<cfset CONVERT_MONEY = left(attributes.CONVERT_MONEY,len(attributes.CONVERT_MONEY)-1)>
		<cfset CONVERT_PRICE = left(attributes.CONVERT_PRICE,len(attributes.CONVERT_PRICE)-1)>
		<cfset CONVERT_PRICE_OTHER = left(attributes.CONVERT_PRICE_OTHER,len(attributes.CONVERT_PRICE_OTHER)-1)>
	</cfif>
	<cfquery name="GET_ORDER_PRODUCTS" datasource="#DSN3#">
		SELECT
			'' ORDER_ROW_ID,
			S.PRODUCT_ID,
			S.STOCK_ID,
			S.MANUFACT_CODE AS PRODUCT_MANUFACT_CODE,
			S.PROPERTY,
			S.BARCOD,
			S.STOCK_CODE,
			S.PRODUCT_NAME+' - '+ISNULL(S.PROPERTY,'') PRODUCT_NAME,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.STOCK_CODE_2,
			S.TAX,
			S.TAX_PURCHASE,
			PRODUCT_UNIT.MAIN_UNIT AS UNIT,
			PRODUCT_UNIT.PRODUCT_UNIT_ID AS UNIT_ID,
			<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
				ISNULL((SELECT PP.PRICE FROM PRICE PP WHERE PP.PRODUCT_ID = S.PRODUCT_ID AND PP.PRICE_CATID = #attributes.price_catid# AND (PP.STARTDATE <=#now()# AND (PP.FINISHDATE IS NULL OR PP.FINISHDATE >=#now()#))),0) PRICE,
				#attributes.price_catid# PRICE_CAT,
				ISNULL((SELECT PP.MONEY FROM PRICE PP WHERE PP.PRODUCT_ID = S.PRODUCT_ID AND PP.PRICE_CATID = #attributes.price_catid# AND (PP.STARTDATE <=#now()# AND (PP.FINISHDATE IS NULL OR PP.FINISHDATE >=#now()#))),'TL') AS OTHER_MONEY,
			<cfelse>	
				0 PRICE,
				'' PRICE_CAT,
				'TL' OTHER_MONEY,
			</cfif>
			'' AS OTHER_MONEY_VALUE,
			'' AS PRODUCT_NAME2,
			'' AS DELIVER_DEPT,
			'' AS SPECT_VAR_ID,
			'' AS SPECT_VAR_NAME,
			'' AS LOT_NO,
			'' AS I_ROW_ID,
			0 AS PRICE_OTHER,
			0 AS NETTOTAL,
			0 AS NET_TOTAL,
			'' AS TOTAL_TAX,
			0 AS OTV_ORAN,
			0 AS OTVTOTAL,
			0 AS TAXTOTAL,
			0 AS COST_PRICE,
			'' AS MARJ,
			0 AS EXTRA_COST,
			0 AS DISCOUNT_COST,
			0 AS AMOUNT2,
			0 AS EXTRA_PRICE,
			0 AS EK_TUTAR_PRICE,
			0 AS EXTRA_PRICE_TOTAL,
			0 AS EXTRA_PRICE_OTHER_TOTAL,
			'' AS UNIQUE_RELATION_ID,
			'' AS PROM_RELATION_ID,
			'' AS PRODUCT_NAME2,
			'' AS UNIT2,
			'' AS SHELF_NUMBER,
			'' AS BASKET_EXTRA_INFO_ID,
			'' SELECT_INFO_EXTRA,
			'' DETAIL_INFO_EXTRA,
			0 AS DISCOUNT_1,
			0 AS DISCOUNT_2,
			0 AS DISCOUNT_3,
			0 AS DISCOUNT_4,
			0 AS DISCOUNT_5,
			0 AS DISCOUNT_6,
			0 AS DISCOUNT_7,
			0 AS DISCOUNT_8,
			0 AS DISCOUNT_9,
			0 AS DISCOUNT_10,
			'' AS PRO_MATERIAL_ID,
			'' AS WRK_ROW_ID,
			'' AS WRK_ROW_RELATION_ID,
			'' AS ROW_INTERNALDEMAND_ID,
			'' AS WIDTH_VALUE,
			'' AS DEPTH_VALUE,
			'' AS HEIGHT_VALUE,
			'' AS ROW_PROJECT_ID,
			'' AS ROW_WORK_ID,
			'' AS LIST_PRICE,
			'' AS CATALOG_ID,
			'' AS NUMBER_OF_INSTALLMENT,
			<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
				ISNULL((SELECT PP.PRICE FROM PRICE PP WHERE PP.PRODUCT_ID = S.PRODUCT_ID AND PP.PRICE_CATID = #attributes.price_catid# AND (PP.STARTDATE <=#now()# AND (PP.FINISHDATE IS NULL OR PP.FINISHDATE >=#now()#))),0) PRICE,
				#attributes.price_catid# PRICE_CAT
			<cfelse>	
				0 PRICE,
				'' PRICE_CAT
			</cfif>,
			'' AS RELATED_ACTION_ID,
			'' AS RELATED_ACTION_TABLE,
			'' BASKET_EMPLOYEE_ID,
			'' ROW_PRO_MATERIAL_ID,
			'' AS PAYMETHOD_ID,
			-1 RESERVE_TYPE,
			'' RESERVE_DATE,
			'' DUEDATE,
			-1 AS ORDER_ROW_CURRENCY,
			'' AS KARMA_PRODUCT_ID,
			'' DELIVER_DATE,
			'' DELIVER_LOCATION,
			'' DELIVER_DEPT,
			'' EXPENSE,
			'' EXPENSE_CENTER_ID,
			'' EXPENSE_ITEM_ID,
			'' EXPENSE_ITEM_NAME,
			'' ACTIVITY_TYPE_ID,
			'' ACC_CODE
			,'' OIV_RATE
			,'' OIV_AMOUNT
			,'' BSMV_RATE
			,'' BSMV_AMOUNT
			,'' BSMV_CURRENCY
			,'' TEVKIFAT_RATE
			,'' TEVKIFAT_AMOUNT
		FROM
			STOCKS S,
			PRODUCT_UNIT,
			PRICE_STANDART AS PS 
		WHERE
			S.STOCK_ID IN (#CONVERT_STOCKS_ID#) AND
			PRODUCT_UNIT.PRODUCT_ID = S.PRODUCT_ID AND
			PS.PRODUCT_ID = S.PRODUCT_ID AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND
			PS.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
			PS.PRICESTANDART_STATUS = 1 AND
			PS.PURCHASESALES = 0
		ORDER BY
			S.PRODUCT_NAME
	</cfquery>
	<cfif len(GET_ORDER_PRODUCTS.DELIVER_DEPT)>
		<cfset get_order_detail.deliver_dept_id = GET_ORDER_PRODUCTS.DELIVER_DEPT>
	<cfelse>
		<cfset get_order_detail.deliver_dept_id = ''>
	</cfif>
<cfelseif isdefined('attributes.from_project_material')>
	<cfquery name="GET_ORDER_PRODUCTS" datasource="#DSN#">
		SELECT
			PMR.PRODUCT_ID,
			PMR.PRODUCT_NAME,
			'' AS PAYMETHOD_ID,
			PMR.UNIT,
			PMR.UNIT_ID,
			'' AS UNIQUE_RELATION_ID,
			'' AS PROM_RELATION_ID,
			PMR.AMOUNT AS ROW_QUANTITY,
			PMR.PRODUCT_NAME2,
			PMR.AMOUNT2,
			PMR.UNIT2,
            '' AS CATALOG_ID,
			'' AS RELATED_INTERNALDEMAND_ROW_ID,
			PMR.EXTRA_PRICE,
			PMR.EK_TUTAR_PRICE,
			PMR.EXTRA_PRICE_TOTAL,
			PMR.EXTRA_PRICE_OTHER_TOTAL,
			PMR.SHELF_NUMBER,
			PMR.BASKET_EXTRA_INFO_ID,
			PMR.SELECT_INFO_EXTRA,
			PMR.DETAIL_INFO_EXTRA,
			PMR.PRICE,
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
			'' AS ROW_WORK_ID,
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
			PMR.DELIVER_DATE,
			PMR.DELIVER_LOCATION,
			PMR.DELIVER_DEPT,
			PMR.SPECT_VAR_ID,
			PMR.SPECT_VAR_NAME,
			PMR.OTHER_MONEY,
			PMR.OTHER_MONEY_VALUE,
			'' AS BASKET_EMPLOYEE_ID,
			'' AS LIST_PRICE,
			'' AS PRICE_CAT,
			'' AS NUMBER_OF_INSTALLMENT,
			'' LOT_NO,
			-1 RESERVE_TYPE,
			'' RESERVE_DATE,
			S.BARCOD,
			S.STOCK_CODE,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			'' AS KARMA_PRODUCT_ID,
			PMR.NETTOTAL,
			PMR.OTVTOTAL,
			PMR.PRO_MATERIAL_ROW_ID AS ORDER_ROW_ID,
			-1 AS ORDER_ROW_CURRENCY,
			'' AS ROW_INTERNALDEMAND_ID,
			'' AS WRK_ROW_ID,
			'' AS WRK_RELATION_ID,
			'' AS RELATED_ACTION_ID,
			'' AS RELATED_ACTION_TABLE,
			S.STOCK_CODE_2,
			PMR.PRO_MATERIAL_ID AS ROW_PRO_MATERIAL_ID, <!--- row_ship_id ye yazdırılıyor --->
			'' EXPENSE,
			'' EXPENSE_CENTER_ID,
			'' EXPENSE_ITEM_ID,
			'' EXPENSE_ITEM_NAME,
			'' ACTIVITY_TYPE_ID,
			'' ACC_CODE
			,'' OIV_RATE
			,'' OIV_AMOUNT
			,'' BSMV_RATE
			,'' BSMV_AMOUNT
			,'' BSMV_CURRENCY
			,'' TEVKIFAT_RATE
			,'' TEVKIFAT_AMOUNT
		FROM 
			PRO_MATERIAL_ROW PMR,
			#dsn3_alias#.STOCKS S
		WHERE
			<cfif isdefined('attributes.from_project_material_id')><!--- Eğer malzeme ihtiyaç listesinin detayından geliyorsa sadece o malzeme listesindeki ürünleri alsın, proje detaydan geliyorsa projeyle ilgili tüm malzeme planlarındaki urunleri alır --->
			PMR.PRO_MATERIAL_ID IN (#attributes.from_project_material_id#) AND
			</cfif>
			PMR.STOCK_ID=S.STOCK_ID
		ORDER BY
			PMR.PRO_MATERIAL_ROW_ID
	</cfquery>
	<cfif len(GET_ORDER_PRODUCTS.DELIVER_DEPT)>
		<cfset get_order_detail.deliver_dept_id = GET_ORDER_PRODUCTS.DELIVER_DEPT>
	<cfelse>
		<cfset get_order_detail.deliver_dept_id = ''>
	</cfif>
<cfelse>
	<cfquery name="GET_ORDER_PRODUCTS" datasource="#dsn3#">
		SELECT
			ORR.*,
			(ORR.QUANTITY) AS ROW_QUANTITY,
			S.PROPERTY,
			S.STOCK_CODE,
			S.BARCOD,
			S.MANUFACT_CODE,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.STOCK_CODE_2,
			EXC.EXPENSE,
			EXI.EXPENSE_ITEM_NAME
		FROM
			ORDER_ROW ORR
			LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON ORR.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
			LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON ORR.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID,
			STOCKS S
		WHERE
			ORR.ORDER_ID=#attributes.ORDER_ID# AND
			ORR.STOCK_ID=S.STOCK_ID
		ORDER BY
			ORR.ORDER_ROW_ID
	</cfquery> 
</cfif>
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
<cfif listlen(valuelist(GET_ORDER_PRODUCTS.ORDER_ROW_ID,','))>
	<cfquery name="GET_ORDER_ROW_DEPARTMENTS" datasource="#dsn3#">
		SELECT * FROM ORDER_ROW_DEPARTMENTS WHERE ORDER_ROW_ID IN (#valuelist(GET_ORDER_PRODUCTS.ORDER_ROW_ID,',')#)
	</cfquery>
</cfif>
<!--- Siparis satirlari icin depo dağılımında sipariste secilen genel depodan farklı kayıt olup olmadıgı kontrol ediliyor --->
<cfif len(get_order_detail.deliver_dept_id)>
	<cfquery name="DEPARTMENT_KONTROL" dbtype="query">
		SELECT DEPARTMENT_ID FROM GET_ORDER_ROW_DEPARTMENTS WHERE DEPARTMENT_ID <> #get_order_detail.deliver_dept_id#
	</cfquery>
<cfelse>
	<cfset DEPARTMENT_KONTROL.recordcount=0>
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
	if (isdefined('get_order_detail.SA_DISCOUNT') and isnumeric(get_order_detail.SA_DISCOUNT))
	{
		sepet.genel_indirim = get_order_detail.SA_DISCOUNT;
	}

	if( not isdefined('attributes.from_project_material') and not isdefined("attributes.is_from_report"))
		sepet.other_money = get_order_detail.OTHER_MONEY;
	else
		sepet.other_money = 'TL';
	
	for (i = 1; i lte get_order_products.recordcount;i=i+1)
	{
		sepet.satir[i] = StructNew();
		if(not (isdefined("attributes.event") and attributes.event is 'copy') and len(get_order_products.row_internaldemand_id[i]))
		{
			if(len(get_order_products.RELATED_INTERNALDEMAND_ROW_ID[i]))
				sepet.satir[i].row_ship_id = "#get_order_products.row_internaldemand_id[i]#;#get_order_products.RELATED_INTERNALDEMAND_ROW_ID[i]#";
			else
				sepet.satir[i].row_ship_id = get_order_products.row_internaldemand_id[i];
		}
		else if(not (isdefined("attributes.event") and attributes.event is 'copy') and len(get_order_products.ROW_PRO_MATERIAL_ID[i]))
			sepet.satir[i].row_ship_id = get_order_products.ROW_PRO_MATERIAL_ID[i];
		else
			sepet.satir[i].row_ship_id = '';
			
		if(isdefined('attributes.is_from_report') and isdefined("attributes.is_wrk_row_id")) //toplu sipariş sayfasından
		{
			sepet.satir[i].wrk_row_relation_id=get_order_products.WRK_ROW_ID[i];
			sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
			sepet.satir[i].related_action_id='';
			sepet.satir[i].related_action_table='';
		}
		else if(isdefined('attributes.from_project_material') and isdefined("attributes.is_from_report")) //proje mazleme planından siparis olusturulacaksa
		{
			sepet.satir[i].wrk_row_relation_id=get_order_products.WRK_ROW_ID[i];
			sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
			sepet.satir[i].related_action_id='';
			sepet.satir[i].related_action_table='';
		}
		else if(findnocase('copy',fusebox.fuseaction)) //siparis kopyalama
		{
			sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
			sepet.satir[i].wrk_row_relation_id='';
			sepet.satir[i].related_action_id='';
			sepet.satir[i].related_action_table='';
		}
		else if(isdefined("attributes.is_from_report")) //convert
		{
			sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
			sepet.satir[i].wrk_row_relation_id='';
			sepet.satir[i].related_action_id='';
			sepet.satir[i].related_action_table='';
		}
		else //satış siparisi guncelleme
		{
			sepet.satir[i].action_row_id = get_order_products.order_row_id[i]; 
			sepet.satir[i].wrk_row_relation_id = get_order_products.wrk_row_relation_id[i];
			sepet.satir[i].wrk_row_id=get_order_products.WRK_ROW_ID[i];
			sepet.satir[i].related_action_id=get_order_products.RELATED_ACTION_ID[i];
			sepet.satir[i].related_action_table=get_order_products.RELATED_ACTION_TABLE[i];
		}
		sepet.satir[i].product_id = get_order_products.product_id[i];
		sepet.satir[i].paymethod_id = get_order_products.paymethod_id[i];
		if (isdefined('attributes.is_from_report') and isdefined('attributes.is_wrk_row_id')) 
			sepet.satir[i].amount  = listgetat(CONVERT_AMOUNT_STOCKS_ID,listfind(CONVERT_WRK_ROW_ID,get_order_products.WRK_ROW_ID[i],','),',');
		else if (isdefined('attributes.is_from_report')) 
			sepet.satir[i].amount  = listgetat(CONVERT_AMOUNT_STOCKS_ID,listfind(CONVERT_STOCKS_ID,get_order_products.STOCK_ID[i],','),',');
		else
			sepet.satir[i].amount = get_order_products.row_quantity[i];
		
		sepet.satir[i].unit = get_order_products.unit[i];
		sepet.satir[i].unit_id = get_order_products.unit_id[i];
		sepet.satir[i].product_name = get_order_products.PRODUCT_NAME[i];
		sepet.satir[i].reserve_type = get_order_products.RESERVE_TYPE[i];
		sepet.satir[i].reserve_date = dateformat(get_order_products.reserve_date[i],dateformat_style);
		if(len(get_order_products.price_other[i]))
			sepet.satir[i].price_other = get_order_products.price_other[i];
		else
			sepet.satir[i].price_other = get_order_products.price[i];
		if(isdefined('attributes.is_from_report') and isdefined("attributes.is_wrk_row_id"))
		{
			get_rate2 = cfquery("SELECT RATE2 FROM SETUP_MONEY WHERE MONEY = '#get_order_products.OTHER_MONEY[i]#'",dsn2);
			if(get_rate2.recordcount)
				sepet.satir[i].price = wrk_round(get_order_products.price_other[i]*get_rate2.rate2,4);
			else
				sepet.satir[i].price = get_order_products.price[i];
		}
		else
			sepet.satir[i].price = get_order_products.price[i];
		sepet.satir[i].tax_percent = get_order_products.tax[i];
		if(len(get_order_products.OTV_ORAN[i])) //özel tüketim vergisi
			sepet.satir[i].otv_oran = get_order_products.OTV_ORAN[i];
		else 
			sepet.satir[i].otv_oran = 0;
		sepet.satir[i].catalog_id = 0;
		sepet.satir[i].stock_id = get_order_products.stock_id[i];
		if(len(get_order_products.DUEDATE[i])) sepet.satir[i].duedate = get_order_products.duedate[i]; else sepet.satir[i].duedate = '';
		sepet.satir[i].order_currency = get_order_products.ORDER_ROW_CURRENCY[i]; //satır siparis asaması
		
		if( len(get_order_products.unique_relation_id[i]) ) sepet.satir[i].row_unique_relation_id = get_order_products.unique_relation_id[i]; else sepet.satir[i].row_unique_relation_id = "";
		if( len(get_order_products.prom_relation_id[i]) ) sepet.satir[i].prom_relation_id = get_order_products.prom_relation_id[i]; else sepet.satir[i].prom_relation_id = "";
		if( len(get_order_products.product_name2[i]) ) sepet.satir[i].product_name_other = get_order_products.product_name2[i]; else sepet.satir[i].product_name_other = "";
		if( len(get_order_products.amount2[i]) ) sepet.satir[i].amount_other = get_order_products.amount2[i]; else sepet.satir[i].amount_other = "";
		if( len(get_order_products.unit2[i]) ) sepet.satir[i].unit_other = get_order_products.unit2[i]; else sepet.satir[i].unit_other = "";
		if( len(get_order_products.extra_price[i]) ) sepet.satir[i].ek_tutar = get_order_products.extra_price[i]; else sepet.satir[i].ek_tutar = 0;
		if(len(get_order_products.WIDTH_VALUE[i])) sepet.satir[i].row_width = get_order_products.WIDTH_VALUE[i]; else sepet.satir[i].row_width = '';
		if(len(get_order_products.DEPTH_VALUE[i])) sepet.satir[i].row_depth = get_order_products.DEPTH_VALUE[i]; else  sepet.satir[i].row_depth = '';
		if(len(get_order_products.HEIGHT_VALUE[i])) sepet.satir[i].row_height = get_order_products.HEIGHT_VALUE[i]; else  sepet.satir[i].row_height = '';
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
		
		if( len(get_order_products.extra_price_total[i]) ) sepet.satir[i].ek_tutar_total = get_order_products.extra_price_total[i]; else sepet.satir[i].ek_tutar_total = 0;
		if( len(get_order_products.EXTRA_PRICE_OTHER_TOTAL[i]) ) sepet.satir[i].ek_tutar_other_total = get_order_products.EXTRA_PRICE_OTHER_TOTAL[i]; else sepet.satir[i].ek_tutar_other_total = 0;
		if( len(get_order_products.shelf_number[i]) ) sepet.satir[i].shelf_number = get_order_products.shelf_number[i]; else sepet.satir[i].shelf_number = "";
		if( len(get_order_products.BASKET_EXTRA_INFO_ID[i]) ) sepet.satir[i].basket_extra_info = get_order_products.BASKET_EXTRA_INFO_ID[i]; else sepet.satir[i].basket_extra_info="";
		if( len(get_order_products.SELECT_INFO_EXTRA[i]) ) sepet.satir[i].select_info_extra = get_order_products.SELECT_INFO_EXTRA[i]; else sepet.satir[i].select_info_extra="";
		if( len(get_order_products.DETAIL_INFO_EXTRA[i]) ) sepet.satir[i].detail_info_extra = get_order_products.DETAIL_INFO_EXTRA[i]; else sepet.satir[i].detail_info_extra="";
		
		if(len(get_order_products.LIST_PRICE[i]) ) sepet.satir[i].list_price = get_order_products.list_price[i]; else sepet.satir[i].list_price = get_order_products.price[i]; 
		if(len(get_order_products.PRICE_CAT[i]) ) sepet.satir[i].price_cat = get_order_products.PRICE_CAT[i]; else sepet.satir[i].price_cat ='';
		if(len(get_order_products.NUMBER_OF_INSTALLMENT[i]) ) sepet.satir[i].number_of_installment = get_order_products.NUMBER_OF_INSTALLMENT[i]; sepet.satir[i].number_of_installment = 0;
		if(len(get_order_products.BASKET_EMPLOYEE_ID[i]) )
		{	
			sepet.satir[i].basket_employee_id = get_order_products.BASKET_EMPLOYEE_ID[i]; 
			sepet.satir[i].basket_employee = GET_BASKET_EMPLOYEES.BASKET_EMPLOYEE[listfind(basket_emp_id_list,get_order_products.BASKET_EMPLOYEE_ID[i])]; 
		}
		else
		{		
			sepet.satir[i].basket_employee_id = '';
			sepet.satir[i].basket_employee = '';
		}
		if(len(get_order_products.KARMA_PRODUCT_ID[i]) ) sepet.satir[i].karma_product_id = get_order_products.KARMA_PRODUCT_ID[i]; else sepet.satir[i].karma_product_id ='';
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
		if (not len(get_order_products.discount_cost[i])) sepet.satir[i].iskonto_tutar = 0; else sepet.satir[i].iskonto_tutar = get_order_products.discount_cost[i];

		if(len(get_order_products.COST_PRICE[i]))
			sepet.satir[i].net_maliyet = get_order_products.COST_PRICE[i];
		else
			sepet.satir[i].net_maliyet = 0;
		if(len(get_order_products.MARJ[i]))
			sepet.satir[i].marj = get_order_products.MARJ[i];
		else
			sepet.satir[i].marj = 0;
		if (len(get_order_products.EXTRA_COST[i]))
			sepet.satir[i].extra_cost = get_order_products.EXTRA_COST[i];
		else
			sepet.satir[i].extra_cost = 0;
		sepet.satir[i].deliver_date = dateformat(get_order_products.deliver_date[i],dateformat_style);
		if(len(trim(get_order_products.deliver_LOCATION[i])))
			sepet.satir[i].deliver_dept = "#get_order_products.deliver_dept[i]#-#get_order_products.deliver_LOCATION[i]#";
		else
			sepet.satir[i].deliver_dept = "#get_order_products.deliver_dept[i]#";
		sepet.satir[i].spect_id = get_order_products.SPECT_VAR_ID[i];
		sepet.satir[i].spect_name = get_order_products.SPECT_VAR_NAME[i];
		sepet.satir[i].other_money = get_order_products.OTHER_MONEY[i];
		sepet.satir[i].special_code = get_order_products.STOCK_CODE_2[i];
		sepet.satir[i].other_money_value = get_order_products.OTHER_MONEY_VALUE[i];
		sepet.satir[i].lot_no = get_order_products.LOT_NO[i];
		sepet.satir[i].barcode = get_order_products.barcod[i];
		sepet.satir[i].stock_code = get_order_products.stock_code[i];
		sepet.satir[i].is_inventory= get_order_products.is_inventory[i];
		sepet.satir[i].is_production= get_order_products.is_production[i];
		sepet.satir[i].manufact_code = get_order_products.PRODUCT_MANUFACT_CODE[i];//arzu bt 20022004:4966 nolu bug icin bruaya eklendi.		
		sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
		sepet.satir[i].row_total = ((sepet.satir[i].amount * sepet.satir[i].price) + sepet.satir[i].ek_tutar_total);
		//sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan);
		if(isdefined("attributes.is_from_report"))
			sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan);
		else
			sepet.satir[i].row_nettotal = get_order_products.NETTOTAL[i];
		sepet.satir[i].row_taxtotal = wrk_round((sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100)),price_round_number);
		if(len(get_order_products.OTVTOTAL[i]))
		{ 
			sepet.satir[i].row_otvtotal = get_order_products.OTVTOTAL[i];
			sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal + sepet.satir[i].row_otvtotal;
		}
		else
		{
		 	sepet.satir[i].row_otvtotal = 0;
			sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
		}
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
		
		if(len(get_order_products.LIST_PRICE[i])) sepet.satir[i].list_price = get_order_products.LIST_PRICE[i]; else sepet.satir[i].list_price = get_order_products.PRICE[i];
		if(len(get_order_products.PRICE_CAT[i])) sepet.satir[i].price_cat = get_order_products.PRICE_CAT[i]; else  sepet.satir[i].price_cat = '';
		if(len(get_order_products.CATALOG_ID[i])) sepet.satir[i].row_catalog_id = get_order_products.CATALOG_ID[i]; else  sepet.satir[i].row_catalog_id = '';
		if(len(get_order_products.NUMBER_OF_INSTALLMENT[i])) sepet.satir[i].number_of_installment = get_order_products.NUMBER_OF_INSTALLMENT[i]; else sepet.satir[i].number_of_installment = 0;

		// urun asortileri , 20050322 uretilmeyen urunlerin asortilerine bakmaya gerek yoktu?...
		if(get_order_products.IS_PRODUCTION[i] and len(get_order_products.ORDER_ROW_ID[i])){
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
			}
		if (department_kontrol.recordcount neq 0) 
		//teslim depo dagiliminda farklı department kaydı varsa siparis satirlari icin teslim depo kayitlari tutuluyor.
		// Bu degiskenlere bagli olarak order_row_departmens tablosu güncelleniyor. 
		//Değiskenler set edilmemis ise order_row_departmens tablosuna sipariste secilen de deparmant_id gonderiliyor.
		{
			// urun departman dagilimi
			SQLString = "SELECT * FROM get_order_row_departments WHERE ORDER_ROW_ID=#get_order_products.ORDER_ROW_ID[i]#";
			get_departman_products = cfquery(SQLString:SQLString,Datasource:'',dbtype:'query');
			sepet.satir[i].department_array = ArrayNew(1);
			for(j = 1 ; j lte get_departman_products.recordcount ; j=j+1)
				{
					sepet.satir[i].department_array[j] = StructNew();
					sepet.satir[i].department_array[j].AMOUNT = get_departman_products.AMOUNT[j];
					sepet.satir[i].department_array[j].DEPARTMENT_ID = get_departman_products.DEPARTMENT_ID[j];
					sepet.satir[i].department_array[j].LOCATION_ID = get_departman_products.LOCATION_ID[j];
				}		
		}

		/*Masraf Merkezi*/
		if( len(get_order_products.EXPENSE_CENTER_ID[i]) )
		{
			sepet.satir[i].row_exp_center_id = get_order_products.EXPENSE_CENTER_ID[i];
			sepet.satir[i].row_exp_center_name = get_order_products.EXPENSE[i];
		}

		//Aktivite Tipi
		if( len(get_order_products.ACTIVITY_TYPE_ID[i]) )
			sepet.satir[i].row_activity_id = get_order_products.ACTIVITY_TYPE_ID[i];

		//Bütçe Kalemi
		if( len(get_order_products.EXPENSE_ITEM_ID[i]) )
		{
			sepet.satir[i].row_exp_item_id = get_order_products.EXPENSE_ITEM_ID[i];
			sepet.satir[i].row_exp_item_name = get_order_products.EXPENSE_ITEM_NAME[i];
		}

		//Muhasebe Kodu
		if( len(get_order_products.ACC_CODE[i]) )
			sepet.satir[i].row_acc_code = get_order_products.ACC_CODE[i];

			sepet.satir[i].row_oiv_rate = ( len( get_order_products.OIV_RATE ) ) ? get_order_products.OIV_RATE : '';
			sepet.satir[i].row_oiv_amount = ( len( get_order_products.OIV_AMOUNT ) ) ? get_order_products.OIV_AMOUNT : '';
			sepet.satir[i].row_bsmv_rate = ( len( get_order_products.BSMV_RATE ) ) ? get_order_products.BSMV_RATE : '';
			sepet.satir[i].row_bsmv_amount = ( len( get_order_products.BSMV_AMOUNT ) ) ? get_order_products.BSMV_AMOUNT : '';
			sepet.satir[i].row_bsmv_currency = ( len( get_order_products.BSMV_CURRENCY ) ) ? get_order_products.BSMV_CURRENCY : '';
			sepet.satir[i].row_tevkifat_rate = ( len( get_order_products.TEVKIFAT_RATE ) ) ? get_order_products.TEVKIFAT_RATE : '';
			sepet.satir[i].row_tevkifat_amount = ( len( get_order_products.TEVKIFAT_AMOUNT ) ) ? get_order_products.TEVKIFAT_AMOUNT : '';	

	}
		
		//proje iskontoları
		
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
		
	
	for (t=1;t lte arraylen(sepet.otv_array);t=t+1)
		sepet.total_otv = sepet.total_otv + wrk_round(sepet.otv_array[t][2],price_round_number);
	
	sepet.net_total = sepet.net_total + sepet.total_tax + sepet.total_otv;
</cfscript>
<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.is_from_report")>
	<cfquery name="get_project_discounts" datasource="#dsn3#">
		SELECT
			PD.DISCOUNT_1,PD.DISCOUNT_2,PD.DISCOUNT_3,PD.DISCOUNT_4,PD.DISCOUNT_5,ISNULL(PD.IS_CHECK_PRJ_PRODUCT,0) IS_CHECK_PRJ_PRODUCT,PD.PRO_DISCOUNT_ID,
			PDC.BRAND_ID,PDC.PRODUCT_CATID,PDC.PRODUCT_ID
		FROM 
			PROJECT_DISCOUNTS PD,
			PROJECT_DISCOUNT_CONDITIONS PDC
		WHERE
			PD.PRO_DISCOUNT_ID=PDC.PRO_DISCOUNT_ID
			AND PD.PROJECT_ID=#attributes.project_id#
			<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
				AND (PD.IS_CHECK_PRJ_MEMBER=0 OR PD.COMPANY_ID=#attributes.company_id#)
			<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
				AND (PD.IS_CHECK_PRJ_MEMBER=0 OR PD.CONSUMER_ID=#attributes.consumer_id#)
			</cfif>
			<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
				AND PD.START_DATE <= #attributes.search_process_date#
				AND PD.FINISH_DATE >= #attributes.search_process_date#
			<cfelse>
				AND PD.START_DATE <= #now()#
				AND PD.FINISH_DATE >= #now()#
			</cfif>
			<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)> <!--- fiyat listesi secilmemisse standart alıs fiyatından kontrol eder --->
				AND (PD.IS_CHECK_PRJ_PRICE_CAT=0 OR PD.PRICE_CATID=#attributes.price_catid#)
			<cfelse>
				AND (PD.IS_CHECK_PRJ_PRICE_CAT=0 OR PD.PRICE_CATID=-1)
			</cfif>
		ORDER BY PRODUCT_ID DESC,BRAND_ID DESC,PRODUCT_CATID DESC
	</cfquery>
	<cfoutput query="get_order_products">
		<cfif get_project_discounts.recordcount and get_project_discounts.IS_CHECK_PRJ_PRODUCT eq 1>
			<cfset prj_prod_list_=listsort(valuelist(get_project_discounts.PRODUCT_ID),'numeric','asc')>
			<cfset prj_brand_list_=listsort(valuelist(get_project_discounts.BRAND_ID),'numeric','asc')>
			<cfset prj_prod_cat_list=listsort(valuelist(get_project_discounts.PRODUCT_CATID),'numeric','asc')>
			<cfquery name="get_project_prods" datasource="#dsn3#">
				SELECT
					PRODUCT_ID,PRODUCT_NAME
				FROM
					PRODUCT
				WHERE
					PRODUCT_ID=#get_order_products.product_id#
					<cfif len(prj_brand_list_)>
					AND ISNULL(BRAND_ID,0) IN (#prj_brand_list_#)
					</cfif>
					<cfif len(prj_prod_cat_list)>
					AND ISNULL(PRODUCT_CATID,0) IN (#prj_prod_cat_list#) 
					</cfif>
					<cfif len(prj_prod_list_)>
					AND PRODUCT_ID IN (#prj_prod_list_#) 
					</cfif>
			</cfquery>
		</cfif>
		<cfif get_project_discounts.recordcount neq 0 and ( (get_project_discounts.IS_CHECK_PRJ_PRODUCT eq 0) or (get_project_discounts.IS_CHECK_PRJ_PRODUCT eq 1 and get_project_prods.recordcount neq 0) )>
			<cfset use_other_discounts=0> <!--- proje iskontoları kullanılacak --->
			<cfscript>
				sepet.satir[currentrow].indirim1 = get_project_discounts.DISCOUNT_1;
				sepet.satir[currentrow].indirim2 = get_project_discounts.DISCOUNT_2;
				sepet.satir[currentrow].indirim3 = get_project_discounts.DISCOUNT_3;
				sepet.satir[currentrow].indirim4 = get_project_discounts.DISCOUNT_4;
				sepet.satir[currentrow].indirim5 = get_project_discounts.DISCOUNT_5;
			</cfscript>
			<cfset use_other_discounts=0>
		</cfif>	
	</cfoutput>
</cfif>
<cfif isdefined("attributes.is_from_report")>
	<cfoutput query="get_order_products">
		<cfset row_stock = listfind(CONVERT_STOCKS_ID,get_order_products.STOCK_ID[currentrow],',')>
		<cfif row_stock gt 0 and isdefined("convert_spect_id") and len(convert_spect_id)>
			<cfset spect_main_id_row = listgetat(convert_spect_id,row_stock,',')>
			<cfif len(spect_main_id_row) and spect_main_id_row gt 0>
				<cfscript>
					new_cre_spect_id = specer(
						dsn_type:dsn3,
						add_to_main_spec:1,
						main_spec_id:spect_main_id_row
					);
				</cfscript>
				<cfif isdefined("new_cre_spect_id") and len(new_cre_spect_id)>
					<cfset sepet.satir[currentrow].spect_id = listgetat(new_cre_spect_id,2,',')>
					<cfset sepet.satir[currentrow].spect_name = listgetat(new_cre_spect_id,3,',')>
				</cfif>
			</cfif>
		</cfif>
	</cfoutput>
</cfif>
