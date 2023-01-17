<cfif isdefined('attributes.internal_row_info') and not isdefined("attributes.is_from_internaldemand")>
	<cfif isdefined('internaldemand_id_list') and len(internaldemand_id_list)>
		<cfquery name="GET_BASKET_ACTION_DETAIL" datasource="#DSN3#">
			SELECT
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.STOCK_CODE_2,
				INT_D.SPECT_VAR_ID,
				INT_D.SPECT_VAR_NAME,
				INT_D.UNIQUE_RELATION_ID,
				INT_D.PRODUCT_NAME2,
				INT_D.AMOUNT2,
				INT_D.UNIT2,
				INT_D.I_ID AS ACTION_ID,
				INT_D.I_ROW_ID AS ACTION_ROW_ID,
				INT_D.UNIT,
				INT_D.UNIT_ID,
				INT_D.PRICE,
				INT_D.EXTRA_PRICE,
				INT_D.EXTRA_PRICE_TOTAL,
				INT_D.EXTRA_PRICE_OTHER_TOTAL,
				INT_D.SHELF_NUMBER,
				INT_D.COST_PRICE,
				INT_D.EXTRA_COST,
				INT_D.PRODUCT_MANUFACT_CODE,
				INT_D.OTHER_MONEY,
				INT_D.TAX,
				ISNULL(INT_D.OTV_ORAN,0) AS OTV_ORAN,
				INT_D.PRODUCT_NAME AS NAME_PRODUCT,
				INT_D.QUANTITY AS AMOUNT,
				INT_D.DISCOUNT_1 AS DISCOUNT1,
				INT_D.DISCOUNT_1 AS DISCOUNT1,
				INT_D.DISCOUNT_2 AS DISCOUNT2,
				INT_D.DISCOUNT_3 AS DISCOUNT3,
				INT_D.DISCOUNT_4 AS DISCOUNT4,
				INT_D.DISCOUNT_5 AS DISCOUNT5,
				INT_D.DISCOUNT_6 AS DISCOUNT6,
				INT_D.DISCOUNT_7 AS DISCOUNT7,
				INT_D.DISCOUNT_8 AS DISCOUNT8,
				INT_D.DISCOUNT_9 AS DISCOUNT9,
				INT_D.DISCOUNT_10 AS DISCOUNT10,
				INT_D.DUEDATE AS DUE_DATE,
				INT_D.DELIVER_DATE AS ROW_DELIVER_DATE,
				INT_D.RESERVE_DATE AS ROW_RESERVE_DATE,
				INT_D.PRICE_OTHER,
				'' AS NET_TOTAL,
				'' AS TOTAL_TAX,
				'' AS PAYMETHOD_ID,
				'' AS OTHER_MONEY_GROSS_TOTAL,
				'' AS DELIVER_LOC,
				ISNULL(INT_D.DELIVER_DEPT,I.DEPARTMENT_IN) AS DELIVER_DEPT,
				ISNULL(INT_D.DELIVER_LOCATION,I.LOCATION_IN) AS DELIVER_LOCATION,
				'' AS LOT_NO,
				0 AS OTVTOTAL,
				0 AS DISCOUNT_COST,
				S.IS_INVENTORY,
				S.PROPERTY,
				S.IS_PRODUCTION,
				S.STOCK_CODE,
				S.BARCOD,
				S.IS_SERIAL_NO,
				S.MANUFACT_CODE,
				INT_D.WRK_ROW_ID,
				INT_D.WRK_ROW_RELATION_ID,
				INT_D.PBS_ID,
				INT_D.ROW_PROJECT_ID,
				INT_D.BASKET_EMPLOYEE_ID,
				INT_D.BASKET_EXTRA_INFO_ID,
				INT_D.SELECT_INFO_EXTRA,
				INT_D.DETAIL_INFO_EXTRA,
				INT_D.EXPENSE_CENTER_ID,
				INT_D.EXPENSE_ITEM_ID,
				INT_D.ACTIVITY_TYPE_ID,
				INT_D.ACC_CODE,
				EXC.EXPENSE,
				EXI.EXPENSE_ITEM_NAME
			FROM 
				INTERNALDEMAND I,
				INTERNALDEMAND_ROW INT_D
				LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON INT_D.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
        		LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON INT_D.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID,
				STOCKS S
			WHERE 
				<cfif len(internaldemand_id_list)>
					INT_D.I_ID IN (#internaldemand_id_list#)
				<cfelse>
					INT_D.I_ID < 0
				</cfif>
				<cfif len(internald_row_id_list)>
					AND INT_D.I_ROW_ID IN (#internald_row_id_list#)
				</cfif>
				<!--- AND I.INTERNAL_ID NOT IN (SELECT INTERNALDEMAND_ID FROM INTERNALDEMAND_RELATION_ROW WHERE TO_OFFER_ID IS NOT NULL AND INTERNALDEMAND_ID IS NOT NULL) Daha once teklife cekilmisse tekrar gelmesin --->
				AND INT_D.STOCK_ID=S.STOCK_ID
				AND INT_D.I_ID = I.INTERNAL_ID
			ORDER BY
				INT_D.I_ID DESC,
				INT_D.I_ROW_ID
		</cfquery>
		<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(get_basket_action_detail.ROW_PROJECT_ID)),'numeric','asc',',')>
		<cfset basket_emp_id_list=listsort(ListDeleteDuplicates(valuelist(get_basket_action_detail.BASKET_EMPLOYEE_ID)),'numeric','asc',',')>
	<cfelseif isdefined('pro_material_id_list') and len(pro_material_id_list)><!--- proje malzeme planından belge olusturma --->
		<cfquery name="GET_BASKET_ACTION_DETAIL" datasource="#DSN3#">
			SELECT
				PMR.PRO_MATERIAL_ID AS ACTION_ID,
				PMR.PRO_MATERIAL_ROW_ID ACTION_ROW_ID,
				PMR.PRODUCT_NAME AS NAME_PRODUCT,
				PMR.STOCK_ID,
				PMR.PRODUCT_ID,
				PMR.AMOUNT,
				PMR.UNIT,
				PMR.UNIT_ID,
				PMR.SPECT_VAR_ID,
				PMR.SPECT_VAR_NAME,
				PMR.UNIQUE_RELATION_ID,
				PMR.PRODUCT_NAME2,
				PMR.PRODUCT_NAME AS NAME_PRODUCT,
				PMR.AMOUNT2,
				PMR.UNIT2,
				PMR.PRODUCT_MANUFACT_CODE,
				PMR.DELIVER_DATE AS ROW_DELIVER_DATE,
				PMR.SHELF_NUMBER,
				'' AS ROW_RESERVE_DATE,
				PMR.DUEDATE AS DUE_DATE,
				PMR.PRICE,
                S.STOCK_CODE_2,
				PMR.PRICE_OTHER,
				PMR.TAX,
				ISNULL(PMR.OTV_ORAN,0) AS OTV_ORAN,
				PMR.EXTRA_PRICE_TOTAL,
				PMR.DISCOUNT_COST,
				PMR.COST_PRICE,
				PMR.EXTRA_COST,
				PMR.DISCOUNT1,
				PMR.DISCOUNT2,
				PMR.DISCOUNT3,
				PMR.DISCOUNT4,
				PMR.DISCOUNT5,
				0 AS DISCOUNT6,
				0 AS DISCOUNT7,
				0 AS DISCOUNT8,
				0 AS DISCOUNT9,
				0 AS DISCOUNT10,
				PMR.OTHER_MONEY,
				PMR.MARGIN AS MARJ,
				'' AS NET_TOTAL,
				'' AS TOTAL_TAX,
				'' AS OTVTOTAL,
				'' AS PAYMETHOD_ID,
				'' AS OTHER_MONEY_GROSS_TOTAL,
				'' AS DELIVER_LOC,
				'' AS DELIVER_DEPT,
				'' AS DELIVER_LOCATION,
				'' AS LOT_NO,
				'' AS PAYMETHOD_ID,
				'' AS PROM_RELATION_ID,
				S.IS_INVENTORY,
				S.PROPERTY,
				S.IS_PRODUCTION,
				S.STOCK_CODE,
				S.BARCOD,
				S.IS_SERIAL_NO,
				S.MANUFACT_CODE,
				PMR.WRK_ROW_ID,
				PMR.WRK_ROW_RELATION_ID,
				'' PBS_ID,
				S.STOCK_CODE_2,
				PMR.BASKET_EXTRA_INFO_ID,
				PMR.SELECT_INFO_EXTRA,
				PMR.DETAIL_INFO_EXTRA,
				'' EXPENSE_CENTER_ID,
				'' EXPENSE_ITEM_ID,
				'' ACTIVITY_TYPE_ID,
				'' ACC_CODE,
				'' EXPENSE,
				'' EXPENSE_ITEM_NAME,
				PMR.ROW_PROJECT_ID			
			FROM 
				#dsn_alias#.PRO_MATERIAL_ROW PMR,
				STOCKS S
			WHERE 
				<cfif len(pro_material_id_list)>
				PMR.PRO_MATERIAL_ID IN (#pro_material_id_list#)
				<cfelse>
				PMR.PRO_MATERIAL_ID < 0
				</cfif>
				<cfif len(pro_material_row_id_list)>
				AND PMR.PRO_MATERIAL_ROW_ID IN (#pro_material_row_id_list#)
				</cfif>
				AND PMR.STOCK_ID=S.STOCK_ID
			ORDER BY
				PMR.PRO_MATERIAL_ID DESC,
				PMR.PRO_MATERIAL_ROW_ID
		</cfquery>
		<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(get_basket_action_detail.ROW_PROJECT_ID)),'numeric','asc',',')>
	</cfif>
<cfelseif isdefined("attributes.is_from_internaldemand")>
	<cfquery name="GET_BASKET_ACTION_DETAIL" datasource="#DSN3#">
		SELECT
			S.PRODUCT_ID,
			S.STOCK_ID,
            S.STOCK_CODE_2,
			INT_D.SPECT_VAR_ID,
			INT_D.SPECT_VAR_NAME,
			INT_D.UNIQUE_RELATION_ID,
			INT_D.PRODUCT_NAME2,
			INT_D.AMOUNT2,
			INT_D.UNIT2,
			INT_D.I_ID AS ACTION_ID,
			INT_D.I_ROW_ID AS ACTION_ROW_ID,
			INT_D.UNIT,
			INT_D.UNIT_ID,
			INT_D.PRICE,
			INT_D.EXTRA_PRICE,
			INT_D.EXTRA_PRICE_TOTAL,
			INT_D.EXTRA_PRICE_OTHER_TOTAL,
			INT_D.SHELF_NUMBER,
			INT_D.COST_PRICE,
			INT_D.EXTRA_COST,
			INT_D.PRODUCT_MANUFACT_CODE,
			INT_D.OTHER_MONEY,
			INT_D.TAX,
			ISNULL(INT_D.OTV_ORAN,0) AS OTV_ORAN,
			INT_D.PRODUCT_NAME AS NAME_PRODUCT,
			INT_D.QUANTITY AS AMOUNT,
			INT_D.DISCOUNT_1 AS DISCOUNT1,
			INT_D.DISCOUNT_1 AS DISCOUNT1,
			INT_D.DISCOUNT_2 AS DISCOUNT2,
			INT_D.DISCOUNT_3 AS DISCOUNT3,
			INT_D.DISCOUNT_4 AS DISCOUNT4,
			INT_D.DISCOUNT_5 AS DISCOUNT5,
			INT_D.DISCOUNT_6 AS DISCOUNT6,
			INT_D.DISCOUNT_7 AS DISCOUNT7,
			INT_D.DISCOUNT_8 AS DISCOUNT8,
			INT_D.DISCOUNT_9 AS DISCOUNT9,
			INT_D.DISCOUNT_10 AS DISCOUNT10,
			INT_D.DUEDATE AS DUE_DATE,
			INT_D.DELIVER_DATE AS ROW_DELIVER_DATE,
			INT_D.RESERVE_DATE AS ROW_RESERVE_DATE,
			INT_D.PRICE_OTHER,
			'' AS NET_TOTAL,
			'' AS TOTAL_TAX,
			'' AS PAYMETHOD_ID,
			'' AS OTHER_MONEY_GROSS_TOTAL,
			'' AS DELIVER_LOC,
			ISNULL(INT_D.DELIVER_DEPT,I.DEPARTMENT_IN) AS DELIVER_DEPT,
			ISNULL(INT_D.DELIVER_LOCATION,I.LOCATION_IN) AS DELIVER_LOCATION,
			'' AS LOT_NO,
			0 AS OTVTOTAL,
			INT_D.DISCOUNT_COST AS DISCOUNT_COST,
			S.IS_INVENTORY,
			S.PROPERTY,
			S.IS_PRODUCTION,
			S.STOCK_CODE,
			S.BARCOD,
			S.IS_SERIAL_NO,
			S.MANUFACT_CODE,
			INT_D.WRK_ROW_ID,
			INT_D.WRK_ROW_RELATION_ID,
			INT_D.PBS_ID,
			S.STOCK_CODE_2,
			INT_D.ROW_PROJECT_ID,
			INT_D.BASKET_EMPLOYEE_ID,
			INT_D.BASKET_EXTRA_INFO_ID,
			INT_D.SELECT_INFO_EXTRA,
			INT_D.DETAIL_INFO_EXTRA,
			INT_D.EXPENSE_CENTER_ID,
			INT_D.EXPENSE_ITEM_ID,
			INT_D.ACTIVITY_TYPE_ID,
			INT_D.ACC_CODE,
			EXC.EXPENSE,
        	EXI.EXPENSE_ITEM_NAME
		FROM 
			INTERNALDEMAND I,
			INTERNALDEMAND_ROW INT_D
			LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON INT_D.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
        	LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON INT_D.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID,
			STOCKS S
		WHERE 
			<cfif len(internaldemand_id_list)>
				INT_D.I_ID IN (#internaldemand_id_list#)
			<cfelse>
				INT_D.I_ID < 0
			</cfif>
			<cfif len(internald_row_id_list)>
				AND INT_D.I_ROW_ID IN (#internald_row_id_list#)
			</cfif>
			--AND I.INTERNAL_ID NOT IN (SELECT INTERNALDEMAND_ID FROM INTERNALDEMAND_RELATION_ROW WHERE TO_INTERNALDEMAND_ID IS NOT NULL AND INTERNALDEMAND_ID IS NOT NULL) 
			AND INT_D.STOCK_ID=S.STOCK_ID
			AND INT_D.I_ID = I.INTERNAL_ID
		ORDER BY
			INT_D.I_ID DESC,
			INT_D.I_ROW_ID
	</cfquery>
	<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(get_basket_action_detail.ROW_PROJECT_ID)),'numeric','asc',',')>
	<cfset basket_emp_id_list=listsort(ListDeleteDuplicates(valuelist(get_basket_action_detail.BASKET_EMPLOYEE_ID)),'numeric','asc',',')>
<cfelseif isdefined('attributes.from_sale_ship')>
	<cfquery name="GET_BASKET_ACTION_DETAIL" datasource="#DSN3#">
		SELECT
			SR.SHIP_ID AS ACTION_ID,
			SR.SHIP_ROW_ID ACTION_ROW_ID,
			SR.NAME_PRODUCT,
			SR.STOCK_ID,
			SR.PRODUCT_ID,
			SR.AMOUNT,
			SR.UNIT,
			SR.UNIT_ID,
			SR.SPECT_VAR_ID,
			SR.SPECT_VAR_NAME,
			SR.UNIQUE_RELATION_ID,
			SR.PRODUCT_NAME2,
			SR.AMOUNT2,
			SR.UNIT2,
			SR.PRODUCT_MANUFACT_CODE,
			SR.DELIVER_DATE AS ROW_DELIVER_DATE,
			SR.SHELF_NUMBER,
			'' AS ROW_RESERVE_DATE,
			SR.DUE_DATE,
			SR.PRICE,
			SR.PRICE_OTHER,
			SR.TAX,
			ISNULL(SR.OTV_ORAN,0) AS OTV_ORAN,
			SR.EXTRA_PRICE_TOTAL,
			SR.DISCOUNT_COST,
			SR.COST_PRICE,
			SR.EXTRA_COST,
			SR.DISCOUNT AS DISCOUNT1,
			SR.DISCOUNT2,
			SR.DISCOUNT3,
			SR.DISCOUNT4,
			SR.DISCOUNT5,
			SR.DISCOUNT6,
			SR.DISCOUNT7,
			SR.DISCOUNT8,
			SR.DISCOUNT9,
			SR.DISCOUNT10,
			SR.OTHER_MONEY,
			SR.MARGIN AS MARJ,
			'' AS NET_TOTAL,
			'' AS TOTAL_TAX,
			'' AS OTVTOTAL,
			'' AS PAYMETHOD_ID,
			'' AS OTHER_MONEY_GROSS_TOTAL,
			'' AS DELIVER_LOC,
			'' AS DELIVER_DEPT,
			'' AS DELIVER_LOCATION,
			'' AS LOT_NO,
			'' AS PAYMETHOD_ID,
			'' AS PROM_RELATION_ID,
			S.IS_INVENTORY,
			S.PROPERTY,
			S.IS_PRODUCTION,
			S.STOCK_CODE,
			S.BARCOD,
            S.STOCK_CODE_2,
			S.IS_SERIAL_NO,
			S.MANUFACT_CODE,
            S.STOCK_CODE_2,
			SR.WRK_ROW_ID,
			SR.WRK_ROW_RELATION_ID,
			'' PBS_ID,
			S.STOCK_CODE_2,
			SR.BASKET_EXTRA_INFO_ID,
			SR.SELECT_INFO_EXTRA,
			SR.DETAIL_INFO_EXTRA
		FROM 
			#dsn2_alias#.SHIP_ROW SR,
			STOCKS S
		WHERE 
			SHIP_ID=#attributes.ship_id#
			AND SR.STOCK_ID=S.STOCK_ID
		ORDER BY
			SR.SHIP_ROW_ID
	</cfquery>
<cfelseif isdefined('attributes.demand_id') and len(attributes.demand_id)><!--- objects2den eklenen bekleyen siparis taleplerinin siparişe çevrilmesi --->
	<cfquery name="GET_BASKET_ACTION_DETAIL" datasource="#DSN#">
		SELECT
			ORD_D.DEMAND_ID AS ACTION_ID,
			ORD_D.DEMAND_ID ACTION_ROW_ID,
			S.PRODUCT_ID,
			S.PRODUCT_NAME AS NAME_PRODUCT,
            S.STOCK_CODE_2,
			'' AS PAYMETHOD_ID,
			PU.MAIN_UNIT AS UNIT,
			PU.PRODUCT_UNIT_ID AS UNIT_ID,
			'' AS UNIQUE_RELATION_ID,
			'' AS PROM_RELATION_ID,
			(ORD_D.DEMAND_AMOUNT - ORD_D.GIVEN_AMOUNT) AS AMOUNT,
			'' AS PRODUCT_NAME2,
			'' AS AMOUNT2,'' AS UNIT2,
			0 AS EXTRA_PRICE,
			0 AS EK_TUTAR_PRICE,
			0 AS EXTRA_PRICE_TOTAL,
			0 AS EXTRA_PRICE_OTHER_TOTAL,
			'' AS SHELF_NUMBER,
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
			0 AS DUE_DATE,
			0 AS PROM_COMISSION,
			0 AS PROM_COST,
			0 AS DISCOUNT_COST,
			0 AS IS_PROMOTION,
			0 AS PROM_STOCK_ID,
			0 AS PROM_ID,
			0 AS IS_COMMISSION,
			0 AS  DISCOUNT1,
			0 AS  DISCOUNT2,
			0 AS  DISCOUNT3,
			0 AS  DISCOUNT4,
			0 AS  DISCOUNT5,
			0 AS DISCOUNT6,
			0 AS DISCOUNT7,
			0 AS DISCOUNT8,
			0 AS DISCOUNT9,
			0 AS DISCOUNT10,
			'' AS BASKET_EMPLOYEE_ID,
			'' AS KARMA_PRODUCT_ID,
			'' AS ROW_DELIVER_DATE,'' AS DELIVER_LOCATION,'' AS DELIVER_DEPT,'' AS SPECT_VAR_ID,'' AS SPECT_VAR_NAME,'#session.ep.money#' AS OTHER_MONEY,0 AS OTHER_MONEY_VALUE,
			'' LOT_NO,
			-1 RESERVE_TYPE,
			'' ROW_RESERVE_DATE,
			S.BARCOD,S.STOCK_CODE,S.IS_INVENTORY,S.IS_PRODUCTION,
			'' AS NET_TOTAL,0 AS OTVTOTAL,
			'' AS TOTAL_TAX,
			DEMAND_ID AS ORDER_ROW_ID,
			'' AS PRO_MATERIAL_ID,
			-1 AS ORDER_ROW_CURRENCY,
			'' AS ROW_PRO_MATERIAL_ID,
			'' AS WRK_ROW_ID,
			'' AS WRK_ROW_RELATION_ID,
			'' AS RELATED_ACTION_ID,
			'' AS RELATED_ACTION_TABLE,
			'' PBS_ID,
			S.STOCK_CODE_2,
			'' BASKET_EXTRA_INFO_ID,
			'' SELECT_INFO_EXTRA,
			'' DETAIL_INFO_EXTRA
		FROM 
			#dsn3_alias#.ORDER_DEMANDS ORD_D,
			#dsn3_alias#.STOCKS S,
			#dsn3_alias#.PRODUCT_UNIT PU
		WHERE
			ORD_D.DEMAND_ID=#attributes.demand_id#
			AND ORD_D.STOCK_ID=S.STOCK_ID
			AND ORD_D.DEMAND_UNIT_ID = PU.PRODUCT_UNIT_ID
	</cfquery>
	
<cfelseif isdefined('attributes.convert_stocks_id')>
	<cfset convert_stock_id = attributes.convert_stocks_id>
	<cfquery name="GET_BASKET_ACTION_DETAIL" datasource="#DSN3#">
		SELECT
			S.PRODUCT_ID,
			S.STOCK_ID,
			S.MANUFACT_CODE AS PRODUCT_MANUFACT_CODE,
			S.PROPERTY,
			S.BARCOD,
			S.STOCK_CODE,
			S.PRODUCT_NAME+' - '+ISNULL(S.PROPERTY,'') AS NAME_PRODUCT,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.TAX,
			S.TAX_PURCHASE,
            S.STOCK_CODE_2,
			PRODUCT_UNIT.MAIN_UNIT AS UNIT,
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.PRODUCT_UNIT_ID AS UNIT_ID,
			PS.PRICE,
			PS.PRICE_KDV,
			PS.MONEY AS OTHER_MONEY,
			'' AS OTHER_MONEY_VALUE,
			'' AS UNIQUE_RELATION_ID,
			'' AS PRODUCT_NAME2,
			'' AS AMOUNT2,
			'' AS UNIT2,
			'' AS EXTRA_PRICE,
			'' AS EXTRA_PRICE_TOTAL,
			'' AS EXTRA_PRICE_OTHER_TOTAL,
			'' AS SHELF_NUMBER,
			'' AS DELIVER_DEPT,
			'' AS SPECT_VAR_ID,
			'' AS SPECT_VAR_NAME,
			'' AS LOT_NO,
			0 AS PRICE_OTHER,
			'' AS OTV_ORAN,
			'' AS NETTOTAL,
			'' AS DISCOUNT_COST,
			'' AS COST_PRICE,
			'' AS EXTRA_COST,
			'' AS NET_TOTAL,
			'' AS TOTAL_TAX,
			'' AS ROW_DELIVER_DATE ,
			'' AS ROW_RESERVE_DATE,
			'' AS ROW_INTERNALDEMAND_ID,
			'' AS WRK_ROW_ID,
			'' AS WRK_ROW_RELATION_ID,
			'' AS WIDTH_VALUE,
			'' AS DEPTH_VALUE,
			'' AS HEIGHT_VALUE,
			'' AS ROW_PROJECT_ID,
			0 AS  DISCOUNT1,
			0 AS  DISCOUNT2,
			0 AS  DISCOUNT3,
			0 AS  DISCOUNT4,
			0 AS  DISCOUNT5,
			0 AS DISCOUNT6,
			0 AS DISCOUNT7,
			0 AS DISCOUNT8,
			0 AS DISCOUNT9,
			0 AS DISCOUNT10,
			'' DUE_DATE,
			'' AS OTVTOTAL,
			'' AS ROW_DELIVER_DATE,'' AS DELIVER_LOCATION,'' AS DELIVER_DEPT,'' AS SPECT_VAR_ID,'' AS SPECT_VAR_NAME,'#session.ep.money#' AS OTHER_MONEY,0 AS OTHER_MONEY_VALUE,
			'' PBS_ID,
			S.STOCK_CODE_2,
			'' BASKET_EXTRA_INFO_ID,
			'' SELECT_INFO_EXTRA,
			'' DETAIL_INFO_EXTRA
		FROM
			STOCKS S,
			PRODUCT_UNIT,
			PRICE_STANDART AS PS 
		WHERE
			S.STOCK_ID IN (#convert_stock_id#) AND
			PRODUCT_UNIT.PRODUCT_ID = S.PRODUCT_ID AND
			PS.PRODUCT_ID = S.PRODUCT_ID AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND
			PS.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
			PS.PRICESTANDART_STATUS = 1 AND
			PS.PURCHASESALES = 0
		ORDER BY
			S.PRODUCT_NAME
	</cfquery>
</cfif>
<cfif isdefined("row_project_id_list_") and len(row_project_id_list_)>
	<cfquery name="GET_ROW_PROJECTS" datasource="#dsn#">
		SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#row_project_id_list_#) ORDER BY PROJECT_ID
	</cfquery>
	<cfset row_project_id_list_=valuelist(GET_ROW_PROJECTS.PROJECT_ID)>
</cfif>
<cfif isdefined("basket_emp_id_list") and len(basket_emp_id_list)>
	<cfquery name="GET_BASKET_EMPLOYEES" datasource="#dsn#">
		SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS BASKET_EMPLOYEE, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#basket_emp_id_list#) ORDER BY EMPLOYEE_ID
	</cfquery>
	<cfset basket_emp_id_list = valuelist(GET_BASKET_EMPLOYEES.EMPLOYEE_ID)> <!--- bulunan kayıtlara gore liste yeniden set ediliyor --->
</cfif>
<cfscript>
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	sepet.kdv_array = ArrayNew(2);
	sepet.otv_array = ArrayNew(2);
	sepet.total_otv = 0;
	sepet.total = 0;
	sepet.total_other_money = 0;
	sepet.total_other_money_tax = 0;
	sepet.toplam_indirim = 0;
	sepet.total_tax = 0;
	sepet.net_total = 0;
	sepet.genel_indirim = 0;
</cfscript>
<cfoutput query="get_basket_action_detail">
	<cfset cost_price_ = get_basket_action_detail.cost_price>
    <cfset extra_cost_ = get_basket_action_detail.extra_cost>
	<!----her türlü lokasyon bazlı maliyet çeekilmiş neden olduğu anlaşılamadı PY 1219 kapatıldı 
    <cfquery name="get_product_all_multip" datasource="#dsn3#">
        SELECT
            PRODUCT.IS_COST
        FROM
            PRODUCT
        WHERE
            PRODUCT_ID=#GET_BASKET_ACTION_DETAIL.product_id#
    </cfquery>
    <cfset price_ = 0>
	<cfif  len(get_product_all_multip.IS_COST) and get_product_all_multip.IS_COST>
    	<cfquery name="GET_PRODUCT_COST" datasource="#dsn3#" maxrows="1">
			SELECT
				PC.PRODUCT_COST_ID,
				PC.PURCHASE_NET_LOCATION_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
				PC.PURCHASE_EXTRA_COST_LOCATION * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
			FROM
				PRODUCT_COST PC,
				#dsn2_alias#.SETUP_MONEY SM
			WHERE 
				SM.MONEY = PC.PURCHASE_NET_MONEY AND
				PC.PRODUCT_COST IS NOT NULL AND
				<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
					PC.START_DATE < #DATEADD('d',1,attributes.search_process_date)# AND 
				<cfelse>
					PC.START_DATE < #now()# AND
				</cfif>
				PC.PRODUCT_ID = #GET_BASKET_ACTION_DETAIL.product_id#
                <cfif session.ep.our_company_info.is_cost_location eq 1>
					<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
                        AND PC.DEPARTMENT_ID = #listfirst(attributes.department_id)#	
                    </cfif>
                    <cfif isdefined("attributes.location_id") and len(attributes.location_id)>
                        AND PC.LOCATION_ID = #attributes.location_id#	
                    </cfif>
                </cfif>
			ORDER BY 
				PC.START_DATE DESC,PC.RECORD_DATE DESC,PC.PRODUCT_COST_ID DESC
		</cfquery>
		<cfdump  var="#GET_PRODUCT_COST#"><cfabort>
        <cfif GET_PRODUCT_COST.recordcount>
			<cfset cost_price_ = GET_PRODUCT_COST.PURCHASE_NET>
            <cfset extra_cost_ = GET_PRODUCT_COST.PURCHASE_EXTRA_COST>
            <cfset price_ = 0>
            <cfif len(GET_PRODUCT_COST.PURCHASE_NET)>
            	<cfset price_ = GET_PRODUCT_COST.PURCHASE_NET>
            </cfif>
            <cfif len(GET_PRODUCT_COST.PURCHASE_EXTRA_COST)>
            	<cfset price_ = price_ + GET_PRODUCT_COST.PURCHASE_EXTRA_COST>
            </cfif>
        </cfif>
	</cfif>
	---->
	<cfscript>
	i = currentrow;
	sepet.satir[i] = StructNew();
	sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
	if(len(get_basket_action_detail.WRK_ROW_ID))
		sepet.satir[i].wrk_row_relation_id =get_basket_action_detail.WRK_ROW_ID;
	else
		sepet.satir[i].wrk_row_relation_id ='';
		
	if(isdefined('attributes.internal_row_info') and len(attributes.internal_row_info)) //iç talep donusturme
	{
		//sepet.satir[i].row_ship_id=get_basket_action_detail.ACTION_ID;
		sepet.satir[i].row_ship_id="#get_basket_action_detail.ACTION_ID#;#get_basket_action_detail.ACTION_ROW_ID#"; //iç talep teklife donusturulurken ic talebin satır id si de tutuluyor
	}
	else if(isdefined('get_basket_action_detail.ROW_INTERNALDEMAND_ID') and len(get_basket_action_detail.ROW_INTERNALDEMAND_ID))
		sepet.satir[i].row_ship_id=get_basket_action_detail.ROW_INTERNALDEMAND_ID;
	else
		sepet.satir[i].row_ship_id=0;

	if(isdefined('get_basket_action_detail.BASKET_EXTRA_INFO_ID') and len(get_basket_action_detail.BASKET_EXTRA_INFO_ID))
		sepet.satir[i].basket_extra_info=get_basket_action_detail.BASKET_EXTRA_INFO_ID;
	else
		sepet.satir[i].basket_extra_info="";

	if(isdefined('get_basket_action_detail.SELECT_INFO_EXTRA') and len(get_basket_action_detail.SELECT_INFO_EXTRA))
		sepet.satir[i].select_info_extra=get_basket_action_detail.SELECT_INFO_EXTRA;
	else
		sepet.satir[i].select_info_extra="";
    
    if(isdefined('get_basket_action_detail.DETAIL_INFO_EXTRA') and len(get_basket_action_detail.DETAIL_INFO_EXTRA))
		sepet.satir[i].detail_info_extra=get_basket_action_detail.DETAIL_INFO_EXTRA;
	else
		sepet.satir[i].detail_info_extra="";


	if(isdefined('attributes.demand_id') and len(attributes.demand_id))
	{
		sepet.satir[i].related_action_id=ACTION_ID;
		sepet.satir[i].related_action_table='ORDER_DEMANDS';
	}
	
	sepet.satir[i].product_id = get_basket_action_detail.product_id;
	sepet.satir[i].is_inventory = get_basket_action_detail.is_inventory;
	sepet.satir[i].is_production = get_basket_action_detail.IS_PRODUCTION;
	sepet.satir[i].pbs_id = get_basket_action_detail.PBS_ID;
	sepet.satir[i].product_name = get_basket_action_detail.name_product;
	
	if(isdefined('attributes.type'))//Üretim planlamadaki malzeme listesinde seçilen ürünlerin miktarlarınıda alır.
		sepet.satir[i].amount  = listgetat(CONVERT_AMOUNT_STOCKS_ID,listfind(CONVERT_STOCKS_ID,get_basket_action_detail.STOCK_ID[i],','),',');
	else if(isdefined('convert_stocks_id')) // gönderilen stok id ve miktar listesine göre listedeki miktarlar yazılır
		sepet.satir[i].amount  = listgetat(CONVERT_AMOUNT_STOCKS_ID,listfind(convert_stocks_id,get_basket_action_detail.STOCK_ID[i],','),',');
	else if(isdefined('internald_row_amount_list')) //satır bazlı ic talep listesinde secilen satırların miktarlarını alır
		sepet.satir[i].amount  = listgetat(internald_row_amount_list,listfind(internald_row_id_list,get_basket_action_detail.ACTION_ROW_ID[i],','),',');
	else if(isdefined('pro_material_amount_list')) //satır bazlı proje malzeme planından secilen satırların miktarlarını alır
		sepet.satir[i].amount  = listgetat(pro_material_amount_list,listfind(pro_material_row_id_list,get_basket_action_detail.ACTION_ROW_ID[i],','),',');
	else
		sepet.satir[i].amount = amount;
	sepet.satir[i].unit = unit;
	sepet.satir[i].unit_id = unit_id;
	sepet.satir[i].stock_id = stock_id;
	sepet.satir[i].spect_id = spect_var_id;
	sepet.satir[i].spect_name = spect_var_name;
	sepet.satir[i].barcode = get_basket_action_detail.BARCOD;
	sepet.satir[i].special_code = get_basket_action_detail.STOCK_CODE_2;
	sepet.satir[i].stock_code = get_basket_action_detail.STOCK_CODE;
	sepet.satir[i].manufact_code = get_basket_action_detail.PRODUCT_MANUFACT_CODE;
	sepet.satir[i].deliver_date = dateformat(ROW_DELIVER_DATE,dateformat_style);
	if(isdefined("row_project_id_list_") and len(get_basket_action_detail.ROW_PROJECT_ID[i]))
	{
		sepet.satir[i].row_project_id=get_basket_action_detail.ROW_PROJECT_ID[i];
		sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,get_basket_action_detail.ROW_PROJECT_ID[i])];
	}	
	if(isdefined("basket_emp_id_list") and len(get_basket_action_detail.BASKET_EMPLOYEE_ID[i]))
	{	
		sepet.satir[i].basket_employee_id = get_basket_action_detail.BASKET_EMPLOYEE_ID[i]; 
		sepet.satir[i].basket_employee = GET_BASKET_EMPLOYEES.BASKET_EMPLOYEE[listfind(basket_emp_id_list,get_basket_action_detail.BASKET_EMPLOYEE_ID[i])]; 
	}
	else
	{		
		sepet.satir[i].basket_employee_id = '';
		sepet.satir[i].basket_employee = '';
	}
	if(len(get_basket_action_detail.LOT_NO)) sepet.satir[i].lot_no = LOT_NO; else sepet.satir[i].lot_no = "";
	if(len(get_basket_action_detail.ROW_RESERVE_DATE)) sepet.satir[i].reserve_date = dateformat(ROW_RESERVE_DATE,dateformat_style); else sepet.satir[i].reserve_date ='';
	if(len(get_basket_action_detail.UNIQUE_RELATION_ID)) sepet.satir[i].row_unique_relation_id = get_basket_action_detail.UNIQUE_RELATION_ID; else sepet.satir[i].row_unique_relation_id = "";
	if(len(get_basket_action_detail.PRODUCT_NAME2)) sepet.satir[i].product_name_other = get_basket_action_detail.PRODUCT_NAME2; else sepet.satir[i].product_name_other = "";
	if(len(get_basket_action_detail.AMOUNT2)) sepet.satir[i].amount_other = get_basket_action_detail.AMOUNT2; else sepet.satir[i].amount_other= "";
	if(len(get_basket_action_detail.UNIT2)) sepet.satir[i].unit_other = get_basket_action_detail.UNIT2; else sepet.satir[i].unit_other = "";
	if(len(get_basket_action_detail.DUE_DATE))sepet.satir[i].duedate = get_basket_action_detail.DUE_DATE; else sepet.satir[i].duedate = '';
	if(len(get_basket_action_detail.SHELF_NUMBER)) sepet.satir[i].shelf_number = get_basket_action_detail.SHELF_NUMBER; else sepet.satir[i].shelf_number = "";
	sepet.satir[i].deliver_dept = "#deliver_dept#-#deliver_location#";

	if (not len(get_basket_action_detail.discount1)) sepet.satir[i].indirim1=0; else  sepet.satir[i].indirim1=get_basket_action_detail.discount1;
	if (not len(get_basket_action_detail.discount2)) sepet.satir[i].indirim2=0; else  sepet.satir[i].indirim2=get_basket_action_detail.discount2;
	if (not len(get_basket_action_detail.discount3)) sepet.satir[i].indirim3=0; else  sepet.satir[i].indirim3=get_basket_action_detail.discount3;
	if (not len(get_basket_action_detail.discount4)) sepet.satir[i].indirim4=0; else  sepet.satir[i].indirim4=get_basket_action_detail.discount4;
	if (not len(get_basket_action_detail.discount5)) sepet.satir[i].indirim5=0; else  sepet.satir[i].indirim5=get_basket_action_detail.discount5;
	sepet.satir[i].indirim6 = 0;
	sepet.satir[i].indirim7 = 0;
	sepet.satir[i].indirim8 = 0;
	sepet.satir[i].indirim9 = 0;
	sepet.satir[i].indirim10 = 0;
	sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
	row_rate_info =1;
	if(OTHER_MONEY is not session.ep.money)
	{
		for (money_i=1;money_i lte get_money_bskt.recordcount;money_i=money_i+1) //satır para biriminin kuru belgeden alınıyor
			if(get_money_bskt.money_type[money_i] is OTHER_MONEY)
				row_rate_info=(get_money_bskt.rate1[money_i]/get_money_bskt.rate2[money_i]);
	}
	if(len(price) and not findnocase('form_add_offer',fusebox.fuseaction)) 
		sepet.satir[i].price = price; else sepet.satir[i].price = 0;
	/*if(isdefined("price_") and price_ neq 0 and not findnocase('form_add_offer',fusebox.fuseaction)) 
	sepet.satir[i].price = price_;*/
	if(OTHER_MONEY is not session.ep.money)
		sepet.satir[i].price_other = sepet.satir[i].price*row_rate_info;
	else
		if(len(PRICE_OTHER) and not findnocase('form_add_offer',fusebox.fuseaction)) sepet.satir[i].price_other = (PRICE_OTHER*row_rate_info); else sepet.satir[i].price_other = 0;
	
	if(len(EXTRA_PRICE_TOTAL) and EXTRA_PRICE_TOTAL neq 0)
	{
		sepet.satir[i].ek_tutar=(EXTRA_PRICE_TOTAL/AMOUNT)*row_rate_info;
		sepet.satir[i].ek_tutar_total=(EXTRA_PRICE_TOTAL/AMOUNT)*sepet.satir[i].amount;
		sepet.satir[i].ek_tutar_other_total=(EXTRA_PRICE_TOTAL/AMOUNT)*sepet.satir[i].amount*row_rate_info;
	}
	else
	{
		sepet.satir[i].ek_tutar=0;
		sepet.satir[i].ek_tutar_total=0;
		sepet.satir[i].ek_tutar_other_total=0;
	}
	
	//TEKRAR BAKILACAK
	if(len(get_basket_action_detail.DISCOUNT_COST)) sepet.satir[i].iskonto_tutar = get_basket_action_detail.DISCOUNT_COST; else sepet.satir[i].iskonto_tutar = 0;
	
	sepet.satir[i].marj = 0;  
	if (len(COST_PRICE_) and not findnocase('form_add_offer',fusebox.fuseaction)) sepet.satir[i].net_maliyet = COST_PRICE_; else sepet.satir[i].net_maliyet=0;
	if (len(extra_cost_)) sepet.satir[i].extra_cost = extra_cost_; else sepet.satir[i].extra_cost =0; 


	sepet.satir[i].row_total = (sepet.satir[i].amount*sepet.satir[i].price)+sepet.satir[i].ek_tutar_total;
	if(len(NET_TOTAL)) //listelerden miktar bazlı urun secilerek olusturulan fislerde net_total gonderilmez
		sepet.satir[i].row_nettotal = wrk_round(NET_TOTAL,price_round_number);
	else
		sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan,price_round_number);
	
	if(len(TAX)) sepet.satir[i].tax_percent = TAX; else sepet.satir[i].tax_percent = 0;
	if(len(OTV_ORAN)) sepet.satir[i].otv_oran = OTV_ORAN; else sepet.satir[i].otv_oran = 0;

	if(len(TOTAL_TAX))
		sepet.satir[i].row_taxtotal = TOTAL_TAX;
	else
		sepet.satir[i].row_taxtotal = wrk_round(sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100),price_round_number);
	if(len(OTVTOTAL))
		sepet.satir[i].row_otvtotal =OTVTOTAL;
	else
		sepet.satir[i].row_otvtotal = wrk_round(sepet.satir[i].row_nettotal * (sepet.satir[i].otv_oran/100),price_round_number);

	sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal+sepet.satir[i].row_otvtotal;
	sepet.satir[i].other_money = OTHER_MONEY;
	sepet.satir[i].other_money_value = sepet.satir[i].row_nettotal*row_rate_info;
	sepet.satir[i].other_money_grosstotal ='';

	sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
	/*sepet.total_other_money = sepet.total_other_money + wrk_round(sepet.satir[i].other_money_value_,basket_total_round_number); //subtotal_other_money
	sepet.total_other_money_tax = sepet.total_other_money_tax + wrk_round(sepet.satir[i].other_money_gross_total,basket_total_round_number); //subtotal_other_money_with_tax*/
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
				sepet.kdv_array[k][3] = sepet.kdv_array[k][3] + wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);			
				}
			}
		if (not kdv_flag)
			{
			sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = sepet.satir[i].tax_percent;
			sepet.kdv_array[arraylen(sepet.kdv_array)][2] = 0;
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

	sepet.satir[i].assortment_array = ArrayNew(1);
	
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
	
	</cfscript>
</cfoutput>
<cfscript>
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
		
	
	for (t=1;t lte arraylen(sepet.otv_array);t=t+1)
		sepet.total_otv = sepet.total_otv + wrk_round(sepet.otv_array[t][2],price_round_number);
	
	sepet.net_total = sepet.net_total + sepet.total_tax + sepet.total_otv;
</cfscript>
