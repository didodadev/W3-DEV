<!---<cfsetting showdebugoutput="yes">--->
<cfsetting showdebugoutput="yes">
<div id="prod_stock_and_spec_detail_div" align="center" style="position:absolute;width:300px; height:150; overflow:auto;z-index:1;"></div>
<style type="text/css">
	.detail_basket_list tbody tr.operasyon td {background-color:#FFCCCC !important;}
	.detail_basket_list tbody tr.phantom td {background-color:#FFCC99 !important;}
</style>
<cfquery name="get_xml_alternative_question" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> AND
		FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="prod.add_product_tree"> AND
		PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_related_alternative_question_product">
</cfquery>
<cfquery name="get_workstation_xml" datasource="#dsn#">
	SELECT PROPERTY_VALUE FROM FUSEACTION_PROPERTY WHERE FUSEACTION_NAME = 'prod.add_prod_order' AND PROPERTY_NAME = 'is_product_station_relation' AND OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>
<cfif get_workstation_xml.recordcount and get_workstation_xml.property_value eq 1>
	<cfset is_product_station_relation = 1 >
</cfif>
<cfset is_add_alternative_product = get_xml_alternative_question.PROPERTY_VALUE>
<cfinclude template="../../workdata/get_main_spect_id.cfm">
<cf_xml_page_edit fuseact="prod.upd_prod_order_result">
<cfif is_show_product_name2 eq 1><cfset product_name2_display =""><cfelse><cfset product_name2_display='none'></cfif>
<cfif is_show_spec_id eq 1><cfset spec_display = 'text'><cfelse><cfset spec_display = 'hidden'></cfif>
<cfif is_show_spec_name eq 1><cfset spec_name_display = 'text'><cfelse><cfset spec_name_display = 'hidden'></cfif>
<cfif is_show_spec_id eq 0 and isdefined('is_show_spec_name') and is_show_spec_name eq 0><cfset spec_img_display="none"><cfelse><cfset spec_img_display=""></cfif>
<cfif is_change_amount_demontaj eq 1><cfset _readonly_ =''><cfelse><cfset _readonly_ = 'readonly'></cfif>
<cfif not isdefined("is_changed_spec_main")>
	<cfset is_changed_spec_main = 0>
</cfif>
<cfquery name="upd_paper" datasource="#dsn3#">
	   SELECT PRODUCTION_RESULT_NUMBER,PRODUCTION_RESULT_NO FROM GENERAL_PAPERS WHERE PAPER_TYPE IS NOT NULL
</cfquery>
<cfquery name="get_product_parent" datasource="#DSN3#"><!---Üretim emri verilen alt ürün varmı?Varsa buna bağlı olarak oluşan spectleri buraya yansıtıcaz! --->
	SELECT 
		SPECT_VAR_ID,
		SPECT_VAR_NAME,
		SPEC_MAIN_ID,
		STOCK_ID
	FROM
		PRODUCTION_ORDERS
	WHERE 
		PO_RELATED_ID=#attributes.p_order_id# 
</cfquery>
<cfif get_product_parent.recordcount>
	<cfoutput query="get_product_parent">
		<cfset 'stock#STOCK_ID#_spec_main_id' = SPEC_MAIN_ID>
		<cfset 'stock#STOCK_ID#_spect_name' = SPECT_VAR_NAME>
	</cfoutput>
</cfif>
<cfset xml_all_depo_entry = iif(isdefined("xml_location_auth_entry"),xml_location_auth_entry,DE('-1'))>
<cfset xml_all_depo_outer = iif(isdefined("xml_location_auth_outer"),xml_location_auth_outer,DE('-1'))>
<cfset xml_all_depo_prod = iif(isdefined("xml_location_auth_prod"),xml_location_auth_prod,DE('-1'))>
<cfquery name="GET_PAPER" datasource="#DSN3#">
	SELECT
		MAX(RESULT_NUMBER) MAX_ID
	FROM
		PRODUCTION_ORDER_RESULTS
</cfquery>
<cf_papers paper_type="production_result">
<!--- Ana Ürün --->
<cfquery name="GET_STOCK_ID" datasource="#DSN3#">
		SELECT
		STOCKS.STOCK_ID,
		PRODUCTION_ORDERS.IS_DEMONTAJ,
		PRODUCTION_ORDERS.LOT_NO, 
		PRODUCTION_ORDERS.DETAIL,
		PRODUCTION_ORDERS.STATION_ID,
		PRODUCTION_ORDERS.SPEC_MAIN_ID,
		PRODUCTION_ORDERS.SPECT_VAR_ID,
		PRODUCTION_ORDERS.REFERENCE_NO REFERANS,
		PRODUCTION_ORDERS.P_ORDER_NO,
		PRODUCTION_ORDERS.PROJECT_ID,
		PRODUCTION_ORDERS.ORDER_ID
	FROM
		PRODUCTION_ORDERS,
		STOCKS
	WHERE 
		PRODUCTION_ORDERS.P_ORDER_ID = #attributes.p_order_id# AND 
		PRODUCTION_ORDERS.STOCK_ID = STOCKS.STOCK_ID
</cfquery>
<cfquery name="GET_DET_PO" datasource="#DSN3#">
	SELECT
		1 AS TYPE_PRODUCT,
		PRODUCTION_ORDERS.IS_DEMONTAJ,
		PRODUCTION_ORDERS.LOT_NO, 
		PRODUCTION_ORDERS.DETAIL,
		PRODUCTION_ORDERS.STATION_ID,
		PRODUCTION_ORDERS.SPEC_MAIN_ID,
		PRODUCTION_ORDERS.SPECT_VAR_ID,
		PRODUCTION_ORDERS.REFERENCE_NO REFERANS,
		PRODUCTION_ORDERS.P_ORDER_NO,
		PRODUCTION_ORDERS.PROJECT_ID,
		PRODUCTION_ORDERS.ORDER_ID,
		STOCKS.IS_PROTOTYPE,
		PRODUCTION_ORDERS.START_DATE,
		PRODUCTION_ORDERS.FINISH_DATE,
		'' NAME,
		0 RELATED_SPECT_ID,
		PRODUCTION_ORDERS.QUANTITY AMOUNT,
		0 AS IS_FREE_AMOUNT,
		0 IS_SEVK,
		0 LINE_NUMBER,
		'S' AS TREE_TYPE,
		0 AS IS_PHANTOM,
		0 AS IS_PROPERTY,
		'' AS LOT_NO,
		0 PRODUCT_COST_ID,
		STOCKS.STOCK_CODE,
		STOCKS.PRODUCT_NAME,
		STOCKS.PRODUCT_ID,
		STOCKS.STOCK_ID,
		STOCKS.BARCOD,		
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.MAIN_UNIT,
		PRODUCT_UNIT.DIMENTION,
		STOCKS.IS_PRODUCTION,
		STOCKS.TAX,
		STOCKS.TAX_PURCHASE,
		STOCKS.PRODUCT_UNIT_ID,
		0 PRICE,
		'' MONEY,
		STOCKS.PROPERTY, 
		0 AS SUB_SPEC_MAIN_ID,
		WRK_ROW_ID,
		0 AS IS_MANUAL_COST,
		NULL WIDTH,
		NULL HEIGHT,
		NULL LENGTH,
		PRODUCTION_ORDERS.QUANTITY_2 AS AMOUNT2
	FROM
		PRODUCTION_ORDERS,
		STOCKS,
		PRODUCT_UNIT
	WHERE 
		PRODUCTION_ORDERS.P_ORDER_ID = #attributes.p_order_id# AND 
		PRODUCTION_ORDERS.STOCK_ID = STOCKS.STOCK_ID AND	
		PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
		PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND
		PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
	UNION ALL
	<!--- YAN ÜRÜNLER --->
		SELECT
		1 AS TYPE_PRODUCT,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_STOCK_ID.IS_DEMONTAJ#"> AS IS_DEMONTAJ,
		<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#GET_STOCK_ID.LOT_NO#"> AS LOT_NO, 
		<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#GET_STOCK_ID.DETAIL#"> AS DETAIL,
		<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#GET_STOCK_ID.STATION_ID#"> AS STATION_ID,
		PRODUCT_TREE_BY_PRODUCT.SPECT_ID,
		NULL AS SPECT_VAR_ID,
		<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#GET_STOCK_ID.REFERANS#"> AS REFERANS,
		<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#GET_STOCK_ID.P_ORDER_NO#"> AS P_ORDER_NO,
		<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#GET_STOCK_ID.PROJECT_ID#"> AS PROJECT_ID,
		<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#GET_STOCK_ID.ORDER_ID#"> AS ORDER_ID,
		STOCKS.IS_PROTOTYPE,
		0 AS START_DATE,
		0 AS FINISH_DATE,
		'' NAME,
		0 RELATED_SPECT_ID,
		PRODUCT_TREE_BY_PRODUCT.AMOUNT AS AMOUNT,
		0 AS IS_FREE_AMOUNT,
		0 IS_SEVK,
		0 LINE_NUMBER,
		'S' AS TREE_TYPE,
		0 AS IS_PHANTOM,
		0 AS IS_PROPERTY,
		'' AS LOT_NO,
		0 PRODUCT_COST_ID,
		STOCKS.STOCK_CODE,
		STOCKS.PRODUCT_NAME,
		STOCKS.PRODUCT_ID,
		STOCKS.STOCK_ID,
		STOCKS.BARCOD,		
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.MAIN_UNIT,
		PRODUCT_UNIT.DIMENTION,
		STOCKS.IS_PRODUCTION,
		STOCKS.TAX,
		STOCKS.TAX_PURCHASE,
		STOCKS.PRODUCT_UNIT_ID,
		0 PRICE,
		'' MONEY,
		STOCKS.PROPERTY, 
		0 AS SUB_SPEC_MAIN_ID,
		'' AS WRK_ROW_ID,
		0 AS IS_MANUAL_COST,
		PRODUCT_TREE_BY_PRODUCT.WIDTH,
		PRODUCT_TREE_BY_PRODUCT.HEIGHT,
		PRODUCT_TREE_BY_PRODUCT.LENGTH,
		PRODUCT_TREE_BY_PRODUCT.AMOUNT2 AS AMOUNT2
	FROM
		PRODUCT_TREE_BY_PRODUCT,
		STOCKS,
		PRODUCT_UNIT
	WHERE 
		PRODUCT_TREE_BY_PRODUCT.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_STOCK_ID.STOCK_ID#"> AND 
		PRODUCT_TREE_BY_PRODUCT.RELATED_STOCK_ID = STOCKS.STOCK_ID AND	
		PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
		PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND
		PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
</cfquery>
<!--- 
	bu kısım phantom ürün ağaçları için eklendi.Ana amaç üretim emrinde seçilen spec'e göre
	ilgili ürün ağacındaki phantom ağacı bulmak ve üretim sonucundaki
	sarflar kısmına bu phantom ürünü değil onun bileşenlerini getirmek...
 --->
<cfquery name="get_money" datasource="#dsn#">
	SELECT MONEY,RATE1,RATE2 FROM MONEY_HISTORY WHERE MONEY_HISTORY_ID IN(SELECT MAX(MONEY_HISTORY_ID) FROM MONEY_HISTORY WHERE COMPANY_ID=#session.ep.company_id# AND PERIOD_ID=#session.ep.period_id# AND VALIDATE_DATE <= #createodbcdatetime(get_det_po.finish_date)# GROUP BY MONEY)
</cfquery>
<cfif get_money.recordcount eq 0>
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY
	</cfquery>
</cfif>
<cfquery name="GET_ROW_AMOUNT" datasource="#DSN3#">
	SELECT 
		PR_ORDER_ID
	FROM 
		PRODUCTION_ORDER_RESULTS
	WHERE 
		P_ORDER_ID = #attributes.p_order_id# 
</cfquery>
	<cfif GET_ROW_AMOUNT.RECORDCOUNT>
		<cfquery name="GET_SUM_AMOUNT" datasource="#DSN3#">
			SELECT 
				ISNULL(SUM(POR_.AMOUNT),0) AS SUM_AMOUNT
			FROM 
				PRODUCTION_ORDER_RESULTS_ROW POR_,
				PRODUCTION_ORDER_RESULTS POO
			WHERE 
				POR_.PR_ORDER_ID = POO.PR_ORDER_ID
				AND POO.P_ORDER_ID = #attributes.p_order_id# AND
				POR_.STOCK_ID = #get_det_po.stock_id#
				<cfif len(get_det_po.spec_main_id)>
					AND POR_.SPEC_MAIN_ID = #get_det_po.spec_main_id#
				</cfif>
				AND ISNULL(IS_FREE_AMOUNT,0) = 0
				<cfif GET_DET_PO.IS_DEMONTAJ EQ 0> AND TYPE=1<cfelse>AND TYPE=2</cfif>
		</cfquery>
		<cfquery name="GET_SUM_AMOUNT_FIRE" datasource="#DSN3#">
			SELECT 
				ISNULL(SUM(POR_.AMOUNT),0) AS SUM_AMOUNT
			FROM 
				PRODUCTION_ORDER_RESULTS_ROW POR_,
				PRODUCTION_ORDER_RESULTS POO
			WHERE 
				POR_.PR_ORDER_ID = POO.PR_ORDER_ID
				AND POO.P_ORDER_ID =#attributes.p_order_id# AND
				POR_.STOCK_ID = #get_det_po.stock_id#
				<cfif len(get_det_po.spec_main_id)>
					AND POR_.SPEC_MAIN_ID = #get_det_po.spec_main_id#
				</cfif>
				AND TYPE=3
		</cfquery>
	</cfif>
	<cfquery name="GET_ROW" datasource="#dsn3#">
		SELECT
			ORDERS.ORDER_NUMBER,
			ORDER_ROW.ORDER_ID,
			ORDER_ROW.ORDER_ROW_ID
		FROM
			PRODUCTION_ORDERS_ROW,
			ORDERS,
			ORDER_ROW
		WHERE
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = #attributes.p_order_id# AND
			PRODUCTION_ORDERS_ROW.ORDER_ROW_ID = ORDER_ROW.ORDER_ROW_ID AND
			ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID
	</cfquery>
<cfif len(get_det_po.spect_var_id) OR len(get_det_po.spec_main_id) and (get_det_po.is_production eq 1)><!---  and (get_det_po.is_prototype eq 1) --->
	<cfquery name="GET_SUB_PRODUCTS" datasource="#dsn3#"><!--- SARFLAR --->
		SELECT
			CAST(#createodbcdate(GET_DET_PO.START_DATE)# AS DATETIME) START_DATE,
			CAST(#createodbcdate(GET_DET_PO.FINISH_DATE)# AS DATETIME) FINISH_DATE,
			'Spec' AS NAME,
			PRODUCTION_ORDERS_STOCKS.SPECT_MAIN_ID AS RELATED_SPECT_ID,
			PRODUCTION_ORDERS_STOCKS.AMOUNT AS AMOUNT , 
			PRODUCTION_ORDERS_STOCKS.IS_FREE_AMOUNT,
			PRODUCTION_ORDERS_STOCKS.IS_SEVK,
			PRODUCTION_ORDERS_STOCKS.LINE_NUMBER,
			CASE WHEN (PRODUCTION_ORDERS_STOCKS.IS_PROPERTY = 4) THEN 'O' ELSE 'S' END AS TREE_TYPE,
			ISNULL(PRODUCTION_ORDERS_STOCKS.IS_PHANTOM,0) AS IS_PHANTOM,
			PRODUCTION_ORDERS_STOCKS.IS_PROPERTY,
			PRODUCTION_ORDERS_STOCKS.LOT_NO,
			0 AS PRODUCT_COST_ID,<!---0 ATIYORUZ ŞİMDİLİK DÜZELTİLECEK.--->
			STOCKS.STOCK_CODE,
			STOCKS.PRODUCT_NAME,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_ID,
			STOCKS.BARCOD,
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.MAIN_UNIT,
			PRODUCT_UNIT.DIMENTION,
			STOCKS.IS_PRODUCTION,
			STOCKS.TAX,
			STOCKS.TAX_PURCHASE,
			STOCKS.PRODUCT_UNIT_ID,
			PRICE_STANDART.PRICE,
			PRICE_STANDART.MONEY,
			STOCKS.PROPERTY, 
			0 AS SUB_SPEC_MAIN_ID,
			WRK_ROW_ID,
			0 AS IS_MANUAL_COST
		FROM
			PRODUCTION_ORDERS_STOCKS,
			STOCKS,
			PRODUCT_UNIT,
			PRICE_STANDART
		WHERE
			PRODUCTION_ORDERS_STOCKS.STOCK_ID = STOCKS.STOCK_ID AND
			PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
			PRICE_STANDART.PURCHASESALES = 1 AND
			PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			STOCKS.STOCK_STATUS = 1	AND
			PRODUCTION_ORDERS_STOCKS.P_ORDER_ID = #attributes.p_order_id# AND
			PRODUCTION_ORDERS_STOCKS.IS_PROPERTY IN(0,3,4) AND
			PRODUCTION_ORDERS_STOCKS.TYPE = 2 AND
			<cfif get_det_po.is_demontaj eq 1> PRODUCTION_ORDERS_STOCKS.IS_SEVK = 0 AND</cfif> 
			PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
			STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID AND
			PRODUCTION_ORDERS_STOCKS.IS_PHANTOM = 0 <!--- FANTOM ÜRÜNLERİ SARF LİSTESİNDEN ÇIKARIYORUZ.AŞAĞIDA FHANTOMLARIN SPECLERİNDEN FAYDALANARAK BU ÇIKARTTIĞIMIZ ÜRÜNÜN BİLEŞENLERİNİ DAHİL EDİCEZ.. --->
	UNION ALL
		SELECT
			CAST(#createodbcdate(GET_DET_PO.START_DATE)# AS DATETIME) START_DATE,
			CAST(#createodbcdate(GET_DET_PO.FINISH_DATE)# AS DATETIME) FINISH_DATE,
			'Spec' AS NAME,
			PRODUCTION_ORDERS_STOCKS.SPECT_MAIN_ID AS RELATED_SPECT_ID,
			PRODUCTION_ORDERS_STOCKS.AMOUNT AS AMOUNT , 
			PRODUCTION_ORDERS_STOCKS.IS_FREE_AMOUNT,
			PRODUCTION_ORDERS_STOCKS.IS_SEVK,
			PRODUCTION_ORDERS_STOCKS.LINE_NUMBER,
			'P' AS TREE_TYPE,<!--- BURADAKİ TREE_TYPE'IN P OLMASI ÜRÜNÜN FANTOM OLDUĞUNU GÖSTERİR.. --->
			ISNULL(PRODUCTION_ORDERS_STOCKS.IS_PHANTOM,0) AS IS_PHANTOM,
			PRODUCTION_ORDERS_STOCKS.IS_PROPERTY,
			PRODUCTION_ORDERS_STOCKS.LOT_NO,
			0 AS PRODUCT_COST_ID,<!---0 ATIYORUZ ŞİMDİLİK DÜZELTİLECEK.  --->
			STOCKS.STOCK_CODE,
			STOCKS.PRODUCT_NAME,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_ID,
			STOCKS.BARCOD,
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.MAIN_UNIT,
			PRODUCT_UNIT.DIMENTION,
			STOCKS.IS_PRODUCTION,
			STOCKS.TAX,
			STOCKS.TAX_PURCHASE,
			STOCKS.PRODUCT_UNIT_ID,
			PRICE_STANDART.PRICE,
			PRICE_STANDART.MONEY,
			STOCKS.PROPERTY, 
			0 AS SUB_SPEC_MAIN_ID,
			WRK_ROW_ID,
			0 AS IS_MANUAL_COST
		FROM
			PRODUCTION_ORDERS_STOCKS,
			STOCKS,
			PRODUCT_UNIT,
			PRICE_STANDART
		WHERE
			PRODUCTION_ORDERS_STOCKS.STOCK_ID = STOCKS.STOCK_ID AND
			PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
			PRICE_STANDART.PURCHASESALES = 1 AND
			PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			STOCKS.STOCK_STATUS = 1	AND
			PRODUCTION_ORDERS_STOCKS.P_ORDER_ID = #attributes.p_order_id# AND
			PRODUCTION_ORDERS_STOCKS.IS_PHANTOM = 1 AND
			PRODUCTION_ORDERS_STOCKS.IS_PROPERTY IN(0,4) AND
			PRODUCTION_ORDERS_STOCKS.TYPE = 2 AND
			<cfif get_det_po.is_demontaj eq 1> PRODUCTION_ORDERS_STOCKS.IS_SEVK = 0 AND</cfif> <!--- IS_PROPERTY = 0 YANI SADE CE SARFLAR GELSİN. --->
			PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
			STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
		<cfif isdefined('is_line_number') and is_line_number eq 1>
			ORDER BY
				PRODUCTION_ORDERS_STOCKS.LINE_NUMBER
		</cfif>
	</cfquery>
	<cfquery name="GET_SUB_PRODUCTS_FIRE" datasource="#dsn3#"><!--- Fireler --->
		SELECT
			CAST(#createodbcdate(GET_DET_PO.START_DATE)# AS DATETIME) START_DATE,
			CAST(#createodbcdate(GET_DET_PO.FINISH_DATE)# AS DATETIME) FINISH_DATE,
			'Spec' AS NAME,
			PRODUCTION_ORDERS_STOCKS.SPECT_MAIN_ID AS RELATED_SPECT_ID,
			CASE WHEN PRODUCTION_ORDERS_STOCKS.TYPE = 2 THEN 1 ELSE PRODUCTION_ORDERS_STOCKS.AMOUNT END AS AMOUNT,
			CASE WHEN PRODUCTION_ORDERS_STOCKS.TYPE = 2 THEN 1 ELSE PRODUCTION_ORDERS_STOCKS.AMOUNT2 END AS AMOUNT2,
			PRODUCTION_ORDERS_STOCKS.IS_SEVK,
			PRODUCTION_ORDERS_STOCKS.LINE_NUMBER,
			CASE WHEN (PRODUCTION_ORDERS_STOCKS.IS_PROPERTY = 4) THEN 'O' ELSE 'S' END AS TREE_TYPE,
			ISNULL(PRODUCTION_ORDERS_STOCKS.IS_PHANTOM,0) AS IS_PHANTOM,
			PRODUCTION_ORDERS_STOCKS.IS_PROPERTY,
			PRODUCTION_ORDERS_STOCKS.LOT_NO,
			0 AS PRODUCT_COST_ID,<!---0 ATIYORUZ ŞİMDİLİK DÜZELTİLECEK.--->
			STOCKS.PRODUCT_NAME,
			STOCKS.STOCK_CODE,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_ID,
			STOCKS.BARCOD,
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.MAIN_UNIT,
			PRODUCT_UNIT.DIMENTION,
			STOCKS.TAX,
			STOCKS.TAX_PURCHASE,
			STOCKS.IS_PRODUCTION,
			STOCKS.PRODUCT_UNIT_ID,
			PRICE_STANDART.PRICE,
			PRICE_STANDART.MONEY,
			STOCKS.PROPERTY,
			0 AS SUB_SPEC_MAIN_ID,
			WRK_ROW_ID,
			0 AS IS_MANUAL_COST
		FROM
			PRODUCTION_ORDERS_STOCKS,
			STOCKS,
			PRODUCT_UNIT,
			PRICE_STANDART
		WHERE
			PRODUCTION_ORDERS_STOCKS.STOCK_ID = STOCKS.STOCK_ID AND
			PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
			PRICE_STANDART.PURCHASESALES = 1 AND
			PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			STOCKS.STOCK_STATUS = 1	AND
			ISNULL(IS_PHANTOM,0) = 0 AND
			PRODUCTION_ORDERS_STOCKS.P_ORDER_ID = #attributes.p_order_id# AND
			PRODUCTION_ORDERS_STOCKS.TYPE = 3 AND
			(ISNULL(PRODUCTION_ORDERS_STOCKS.FIRE_AMOUNT,0)<>0 OR ISNULL(PRODUCTION_ORDERS_STOCKS.FIRE_RATE,0)<>0 OR PRODUCTION_ORDERS_STOCKS.TYPE = 3)  AND
			<cfif get_det_po.is_demontaj eq 1> PRODUCTION_ORDERS_STOCKS.IS_SEVK = 0 AND</cfif>
			PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
			STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
		<cfif x_add_fire_product eq 1><!--- Eğer sarf ürünleri fire olarak gelsin seçilmişse 0 ve 2 olanlar geliyor --->
		UNION ALL
			SELECT
				CAST(#createodbcdate(GET_DET_PO.START_DATE)# AS DATETIME) START_DATE,
				CAST(#createodbcdate(GET_DET_PO.FINISH_DATE)# AS DATETIME) FINISH_DATE,
				'Spec' AS NAME,
				PRODUCTION_ORDERS_STOCKS.SPECT_MAIN_ID AS RELATED_SPECT_ID,
				1 AS AMOUNT,
				1 AS AMOUNT2,
				PRODUCTION_ORDERS_STOCKS.IS_SEVK,
				PRODUCTION_ORDERS_STOCKS.LINE_NUMBER,
				'P' AS TREE_TYPE,<!--- BURADAKİ TREE_TYPE'IN P OLMASI ÜRÜNÜN FANTOM OLDUĞUNU GÖSTERİR.. --->
				ISNULL(PRODUCTION_ORDERS_STOCKS.IS_PHANTOM,0) AS IS_PHANTOM,
				PRODUCTION_ORDERS_STOCKS.IS_PROPERTY,
				PRODUCTION_ORDERS_STOCKS.LOT_NO,
				0 AS PRODUCT_COST_ID,<!---0 ATIYORUZ ŞİMDİLİK DÜZELTİLECEK.  --->
				STOCKS.PRODUCT_NAME,
				STOCKS.STOCK_CODE,
				STOCKS.PRODUCT_ID,
				STOCKS.STOCK_ID,
				STOCKS.BARCOD,
				PRODUCT_UNIT.ADD_UNIT,
				PRODUCT_UNIT.MAIN_UNIT,
				PRODUCT_UNIT.DIMENTION,
				STOCKS.IS_PRODUCTION,
				STOCKS.TAX,
				STOCKS.TAX_PURCHASE,
				STOCKS.PRODUCT_UNIT_ID,
				PRICE_STANDART.PRICE,
				PRICE_STANDART.MONEY,
				STOCKS.PROPERTY,
				0 AS SUB_SPEC_MAIN_ID<!--- BU ALAN SARF SATIRINA GELEN ÜRÜNÜN HANGİ SPEC'E BAĞLI OLDUĞUNU GÖSTERMEK İÇİN KONULDU.. --->,
				WRK_ROW_ID,
				0 AS IS_MANUAL_COST
			FROM
				PRODUCTION_ORDERS_STOCKS,
				STOCKS,
				PRODUCT_UNIT,
				PRICE_STANDART
			WHERE
				PRODUCTION_ORDERS_STOCKS.STOCK_ID = STOCKS.STOCK_ID AND
				PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
				PRICE_STANDART.PURCHASESALES = 1 AND
				PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
				STOCKS.STOCK_STATUS = 1	AND
				PRODUCTION_ORDERS_STOCKS.P_ORDER_ID = #attributes.p_order_id# AND
				PRODUCTION_ORDERS_STOCKS.IS_PROPERTY IN(0,2) AND
				PRODUCTION_ORDERS_STOCKS.TYPE = 2 AND
				<cfif get_det_po.is_demontaj eq 1> PRODUCTION_ORDERS_STOCKS.IS_SEVK = 0 AND</cfif> <!--- IS_PROPERTY = 0 YANI SADE CE SARFLAR GELSİN. --->
				PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
				STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
		</cfif>
		<cfif isdefined('is_line_number') and is_line_number eq 1>
			ORDER BY
				PRODUCTION_ORDERS_STOCKS.LINE_NUMBER
		</cfif>
	</cfquery>
	<cfif get_sub_products.recordcount eq 0>
		<cfquery name="GET_SUB_PRODUCTS" datasource="#dsn3#">
			SELECT 
				CAST(#createodbcdate(GET_DET_PO.START_DATE)# AS DATETIME) START_DATE,
				CAST(#createodbcdate(GET_DET_PO.FINISH_DATE)# AS DATETIME) FINISH_DATE,
			   'Ağaç' AS NAME,
				PRODUCT_TREE.SPECT_MAIN_ID AS RELATED_SPECT_ID,
				PRODUCT_TREE.AMOUNT AS AMOUNT,
				PRODUCT_TREE.AMOUNT2 AS AMOUNT2,
				PRODUCT_TREE.IS_FREE_AMOUNT,
				PRODUCT_TREE.IS_SEVK,
				ISNULL(PRODUCT_TREE.LINE_NUMBER,0) LINE_NUMBER,
				'S' AS TREE_TYPE,
				ISNULL(PRODUCT_TREE.IS_PHANTOM,0) AS IS_PHANTOM,
				0 AS IS_PROPERTY,
				'' AS LOT_NO,
				0 AS PRODUCT_COST_ID,<!---0 ATIYORUZ ŞİMDİLİK DÜZELTİLECEK.  --->
				STOCKS.PRODUCT_NAME,
				STOCKS.STOCK_CODE,
				STOCKS.PRODUCT_ID,
				STOCKS.STOCK_ID,
				STOCKS.BARCOD,
				PRODUCT_UNIT.ADD_UNIT,
				PRODUCT_UNIT.MAIN_UNIT,
				PRODUCT_UNIT.DIMENTION,
				STOCKS.IS_PRODUCTION,
				STOCKS.TAX,
				STOCKS.TAX_PURCHASE,
				STOCKS.PRODUCT_UNIT_ID,
				0 PRICE,
				'' MONEY,
				STOCKS.PROPERTY,
				0 AS SUB_SPEC_MAIN_ID,
				'' WRK_ROW_ID,
				0 AS IS_MANUAL_COST
			FROM 
				PRODUCT_TREE,
				STOCKS,
				PRODUCT_UNIT
			WHERE 
				PRODUCT_TREE.STOCK_ID = #get_det_po.stock_id# AND 
				STOCKS.STOCK_ID = PRODUCT_TREE.RELATED_ID AND
				STOCKS.STOCK_STATUS = 1	AND
				PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
				<cfif get_det_po.is_demontaj eq 1>AND PRODUCT_TREE.IS_SEVK = 0</cfif>
			<cfif isdefined('is_line_number') and is_line_number eq 1>
				ORDER BY
					ISNULL(PRODUCT_TREE.LINE_NUMBER,0)
			</cfif>
		</cfquery>
	</cfif>
</cfif>
<cfquery name="GET_DET_PO_2" dbtype="query">
	SELECT 0 AS TYPE_PRODUCT,0 AS IS_DEMONTAJ,'' LOT_NO,'' DETAIL,0 STATION_ID,0 SPEC_MAIN_ID,0 SPECT_VAR_ID,'' REFERANS,'' P_ORDER_NO,0 PROJECT_ID,0 ORDER_ID,0 IS_PROTOTYPE,*,0 WIDTH,0 HEIGHT,0 LENGTH,0 AMOUNT2 FROM GET_SUB_PRODUCTS WHERE IS_FREE_AMOUNT = 1
</cfquery>
<cfquery name="GET_DET_PO" dbtype="query">
	SELECT * FROM GET_DET_PO
	UNION ALL
	SELECT * FROM GET_DET_PO_2
</cfquery>
<cfif len(GET_DET_PO.STATION_ID)>
	<cfquery name="GET_STATION" datasource="#dsn3#">
		SELECT 
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
</cfif>
<cf_catalystHeader>
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_prod_order_result_act" onsubmit="newRows()">
	<input type="hidden" name="is_changed_spec_main" id="is_changed_spec_main" value="<cfoutput>#is_changed_spec_main#</cfoutput>">
	<input type="hidden" name="p_order_id" id="p_order_id" value="<cfoutput>#attributes.p_order_id#</cfoutput>">
	<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
	<input type="hidden" name="is_demontaj" id="is_demontaj" value="<cfoutput>#get_det_po.is_demontaj#</cfoutput>">
	<input type="hidden" name="round_number" id="round_number" value="<cfoutput>#round_number#</cfoutput>">
	<cfoutput query="get_money">
		<input type="hidden" name="hidden_rd_money_#CURRENTROW#" id="hidden_rd_money_#CURRENTROW#" value="#money#">
		<input type="hidden" name="txt_rate1_#CURRENTROW#" id="txt_rate1_#CURRENTROW#" value="#tlformat(rate1)#">
		<input type="hidden" name="txt_rate2_#CURRENTROW#" id="txt_rate2_#CURRENTROW#" value="#tlformat(rate2,session.ep.our_company_info.rate_round_num)#">
	</cfoutput>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box>			
				<cf_box_elements>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-process_cat">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36760.İşlem Kategorisi'> *</label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process_cat slct_width="140">
							</div>
						</div>
						<div class="form-group" id="item-production_order_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36346.Üretim Emir No'> *</label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="production_order_no" id="production_order_no" value="<cfoutput>#GET_DET_PO.p_order_no#</cfoutput>" readonly maxlength="25" style="width:140px;">
							</div>
						</div>
						<div class="form-group" id="item-order_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58211.Siparis No'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="order_no" id="order_no" value="<cfif isdefined("get_row.order_number")><cfoutput>#valuelist(get_row.order_number,',')#</cfoutput></cfif>" readonly maxlength="25" style="width:140px;">
								<input type="hidden" name="order_row_id" id="order_row_id" value="<cfif isdefined("get_row.order_number")><cfoutput>#listdeleteduplicates(valuelist(get_row.ORDER_ROW_ID,','))#</cfoutput></cfif>">
							</div>
						</div>
						<div class="form-group" id="item-expense_employee">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36765.İşlemi Yapan'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="expense_employee_id" id="expense_employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
									<input type="text" name="expense_employee" id="expense_employee" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" style="width:140px;">
									<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_basket.expense_employee_id&field_name=form_basket.expense_employee&select_list=1','list');"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-start_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama'> *</label>
							<div class="col col-4 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="_popup" id="_popup" value="2">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57655.Başlama Tarihi'></cfsavecontent>
									<cfinput type="text" name="start_date" id="start_date" required="Yes" message="#message#" validate="#validate_style#" value="#dateformat(get_det_po.start_date,dateformat_style)#" style="width:65px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
								</div>
							</div>
							<div class="col col-2 col-xs-12">
								<cfoutput>
									<cfif len(get_det_po.start_date)>
										<cfset value_start_h = hour(get_det_po.start_date)>
										<cfset value_start_m = minute(get_det_po.start_date)>
									<cfelse>
										<cfset value_start_h = 0>
										<cfset value_start_m = 0>
									</cfif>
									<select name="start_h" id="start_h">
										<option value="0">00</option>
										<cfloop from="0" to="23" index="i">
											<option value="#i#" <cfif value_start_h eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
										</cfloop>
									</select>
								</cfoutput>
							</div>
							<div class="col col-2 col-xs-12">						
								<cfoutput>
									<select name="start_m" id="start_m">
										<cfloop from="0" to="60" index="i">
											<option value="#i#" <cfif value_start_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#i# </option>
										</cfloop>
									</select>
								</cfoutput>
							</div>
						</div>
						<div class="form-group" id="item-finish_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'> *</label>
							<div class="col col-4 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="_popup" id="_popup" value="2">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
									<cfinput required="Yes" message="#message#" type="text" name="finish_date" id="finish_date" validate="#validate_style#" value="#dateformat(get_det_po.finish_date,dateformat_style)#" style="width:65px;" onBlur="change_money_info('form_basket','finish_date');">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date" call_function="change_money_info"></span>
								</div>
							</div>
							<div class="col col-2 col-xs-12">			
								<cfoutput>
									<select name="finish_h" id="finish_h">
										<cfif len(get_det_po.finish_date)>
											<cfset value_finish_h = hour(get_det_po.finish_date)>
											<cfset value_finish_m = minute(get_det_po.finish_date)>
										<cfelse>
											<cfset value_finish_h = 0>
											<cfset value_finish_m = 0>
										</cfif>
										<cfloop from="0" to="23" index="I">
											<option value="#i#" <cfif value_finish_h eq i>selected</cfif>><cfif i lt 10>0</cfif>#i# </option>
										</cfloop>
									</select>
								</cfoutput>
							</div>
							<div class="col col-2 col-xs-12">						
								<cfoutput>
									<select name="finish_m" id="finish_m">
										<cfloop from="0" to="60" index="i">
											<option value="#i#" <cfif value_finish_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#i# </option>
										</cfloop>
									</select>
								</cfoutput>	
							</div>
						</div>
						<div class="form-group" id="item-production_result_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36762.Sonuç No'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="production_result_no" id="production_result_no" value="<cfoutput>#paper_full#</cfoutput>" readonly style="width:167px;" maxlength="25">							
							</div>
						</div>
						<div class="form-group" id="item-project_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
							<div class="col col-8 col-xs-12">
								<input type="hidden" name="project_id" id="project_id" value="<cfif len(GET_DET_PO.PROJECT_ID)><cfoutput>#GET_DET_PO.PROJECT_ID#</cfoutput></cfif>">
								<input type="text" name="project_name" id="project_name" value="<cfif len(GET_DET_PO.PROJECT_ID)><cfoutput>#get_project_name(GET_DET_PO.PROJECT_ID)#</cfoutput></cfif>" readonly style="width:167px;">
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-process">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process is_upd='0' process_cat_width='130' is_detail='0'>
							</div>
						</div>
						<div class="form-group" id="item-lot_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36698.Lot No'></label>
							<div class="col col-8 col-xs-12">
								<input type="hidden" name="old_lot_no" id="old_lot_no" value="<cfoutput>#GET_DET_PO.lot_no#</cfoutput>">
								<input type="text" name="lot_no" id="lot_no" value="<cfoutput>#GET_DET_PO.lot_no#</cfoutput>" onKeyup="lotno_control(1,1);" <cfif isdefined("x_lot_no") and x_lot_no eq 0>readonly</cfif> maxlength="25" style="width:130px;">								
							</div>
						</div>
						<div class="form-group" id="item-expiration_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33892.Son Kullanma Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="expiration_date" value="" readonly message="#message#" validate="#validate_style#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="expiration_date"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-station_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58834.İstasyon'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfif len(GET_DET_PO.STATION_ID)>
										<input type="hidden" name="station_id" id="station_id" value="<cfoutput>#GET_DET_PO.STATION_ID#</cfoutput>">
										<input type="text" name="station_name" id="station_name" value="<cfoutput>#get_station.station_name#</cfoutput>" readonly style="width:130px;">
									<cfelse>
										<input type="hidden" name="station_id" id="station_id" value="">
										<input type="text" name="station_name" id="station_name" readonly style="width:130px;">
									</cfif>
									<cfif is_change_station eq 1><span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="open_station()"></span></cfif>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-ref_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58784.Referans'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="ref_no" id="ref_no" value="<cfoutput>#get_det_po.REFERANS#</cfoutput>" style="width:130px;">
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
						<div class="form-group" id="item-location">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36761.Sarf Depo'></label>
							<div class="col col-8 col-xs-12">
								<cfif isdefined("get_station.exit_dep_id") and len(get_station.exit_dep_id)>
								<cfquery name="GET_EXIT_DEP" datasource="#DSN#">
									SELECT
										DEPARTMENT_HEAD
									FROM 
										DEPARTMENT
									WHERE
										DEPARTMENT_ID = #get_station.exit_dep_id#
								</cfquery>
								<cfquery name="GET_EXIT_LOC" datasource="#DSN#">
									SELECT
										COMMENT
									FROM
										STOCKS_LOCATION
									WHERE
										LOCATION_ID = #get_station.exit_loc_id# AND
										DEPARTMENT_ID = #get_station.exit_dep_id#
								</cfquery>
								<cf_wrkdepartmentlocation
									returnInputValue="exit_location_id,exit_department,exit_department_id,branch_id"
									returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
									fieldName="exit_department"
									fieldid="exit_location_id"
									department_fldId="exit_department_id"
									department_id="#get_station.exit_dep_id#"
									location_id="#get_station.exit_loc_id#"
									xml_all_depo = "#xml_all_depo_outer#"
									location_name="#get_exit_dep.department_head# - #get_exit_loc.comment#"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									line_info = 1
									width="170">
							<cfelse>
								<cf_wrkdepartmentlocation
									returnInputValue="exit_location_id,exit_department,exit_department_id,branch_id"
									returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
									fieldName="exit_department"
									fieldid="exit_location_id"
									xml_all_depo = "#xml_all_depo_outer#"
									department_fldId="exit_department_id"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									line_info = 1
									width="170">
							</cfif>
							<cfif get_det_po.is_demontaj eq 1><!--- TolgaS 20060912 demontaj isleminde depo seceneleri ters olmali --->
								<cfset location_type =3>
							<cfelse>
								<cfset location_type =1>			
							</cfif>								
							</div>
						</div>
						<div class="form-group" id="item-department">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36763.Üretim Depo'></label>
							<div class="col col-8 col-xs-12">
								<cfif isdefined("get_station.production_dep_id") and len(get_station.production_dep_id)>
								<cfquery name="GET_PRODUCTION_DEP" datasource="#DSN#">
									SELECT
										DEPARTMENT_HEAD,
										BRANCH_ID
									FROM 
										DEPARTMENT
									WHERE
										DEPARTMENT_ID = #get_station.production_dep_id#
								</cfquery>
								<cfquery name="GET_PRODUCTION_LOC" datasource="#DSN#">
									SELECT
										COMMENT
									FROM
										STOCKS_LOCATION
									WHERE
										LOCATION_ID = #get_station.production_loc_id# AND
										DEPARTMENT_ID = #get_station.production_dep_id#
								</cfquery>
								<cf_wrkdepartmentlocation
									returnInputValue="production_location_id,production_department,production_department_id,production_branch_id"
									returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
									fieldName="production_department"
									fieldid="production_location_id"
									department_fldId="production_department_id"
									branch_fldId="production_branch_id"
									branch_id="#get_production_dep.branch_id#"
									xml_all_depo = "#xml_all_depo_prod#"
									department_id="#get_station.production_dep_id#"
									location_id="#get_station.production_loc_id#"
									location_name="#get_production_dep.department_head# - #get_production_loc.comment#"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									line_info = 2
									width="170">
							<cfelse>
								<cf_wrkdepartmentlocation
									returnInputValue="production_location_id,production_department,production_department_id,production_branch_id"
									returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
									fieldName="production_department"
									fieldid="production_location_id"
									xml_all_depo = "#xml_all_depo_prod#"
									department_fldId="production_department_id"
									branch_fldId="production_branch_id"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									line_info = 2
									width="170">
							</cfif>
							<cfif get_det_po.is_demontaj eq 1><!--- TolgaS 20060912 demontaj isleminde depo seceneleri ters olmali --->
								<cfset location_type =1>
							<cfelse>
								<cfset location_type =3>			
							</cfif>							
							</div>
						</div>
						<div class="form-group" id="item-enter_loc">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36764.Sevkiyat Depo'></label>
							<div class="col col-8 col-xs-12">
								<cfif isdefined("get_station.enter_dep_id") and len(get_station.enter_dep_id)>
									<cfquery name="GET_ENTER_DEP" datasource="#DSN#">
										SELECT
											DEPARTMENT_HEAD
										FROM 
											DEPARTMENT
										WHERE
											DEPARTMENT_ID = #get_station.enter_dep_id#
									</cfquery>
									<cfquery name="GET_ENTER_LOC" datasource="#DSN#">
										SELECT
											COMMENT
										FROM
											STOCKS_LOCATION
										WHERE
											LOCATION_ID = #get_station.enter_loc_id# AND
											DEPARTMENT_ID = #get_station.enter_dep_id#							
									</cfquery>
									<cf_wrkdepartmentlocation
										returnInputValue="enter_location_id,enter_department,enter_department_id,branch_id"
										returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
										fieldName="enter_department"
										fieldid="enter_location_id"
										department_fldId="enter_department_id"
										department_id="#get_station.enter_dep_id#"
										location_id="#get_station.enter_loc_id#"
										xml_all_depo = "#xml_all_depo_entry#"
										location_name="#get_enter_dep.department_head# - #get_enter_loc.comment#"
										user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
										line_info = 3
										user_location = 0
										width="170">
								<cfelse>
									<cf_wrkdepartmentlocation
										returnInputValue="enter_location_id,enter_department,enter_department_id,branch_id"
										returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
										fieldName="enter_department"
										fieldid="enter_location_id"
										xml_all_depo = "#xml_all_depo_entry#"
										department_fldId="enter_department_id"
										user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
										line_info = 3
										user_location = 0
										width="170">
								</cfif>		
							</div>
						</div>
						<div class="form-group" id="item-detailLen">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-xs-12">
								<textarea name="reference_no" id="reference_no" maxlength="500" onkeydown="counter(this.form.reference_no,this.form.detailLen,500);return ismaxlength(this);" onkeyup="counter(this.form.reference_no,this.form.detailLen,500);return ismaxlength(this);" onblur="return ismaxlength(this);"><cfif len(get_det_po.detail)><cfoutput>#get_det_po.detail#</cfoutput></cfif></textarea>  
							</div>
						</div>
					</div>
	  			</cf_box_elements>
				<cf_box_footer>
						<cfquery name="get_prod_operation" datasource="#dsn3#">
							SELECT TOP 1 P_ORDER_ID FROM PRODUCTION_ORDER_OPERATIONS WHERE P_ORDER_ID = #attributes.p_order_id#
						</cfquery>
						<cfif get_prod_operation.recordcount>
							<font color="#FF0000"><cf_get_lang dictionary_id='60575.İlişkili Üretim Emri Operatör Ekranında Başlatıldığı İçin Sonlandırma İşlemini Operatör Ekranından Yapabilirsiniz'> . <a href="<cfoutput>#request.self#?fuseaction=production.form_add_production_order&upd=#attributes.p_order_id# #get_det_po.p_order_no#</cfoutput>"></font>
						<cfelse>
							<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
						</cfif>
				</cf_box_footer>
		</cf_box>
		<cf_box>		
				<cfsavecontent variable="header"><cf_get_lang dictionary_id='29651.Üretim Sonucu'></cfsavecontent>
				<cf_seperator header="#header#" id="table1">
				<cf_grid_list id="table1">
					<div id="add_prod1"></div>
					<thead>
						<tr>
							<th width="10">
								<cfset demontaj_cost_price_system = 0>
								<cfset demontaj_purchase_extra_cost_system = 0>
								<cfset demontaj_cost_price_system_2 = 0>
								<cfif get_det_po.is_demontaj eq 1>
									<cfset sonuc_query = 'GET_SUB_PRODUCTS'>
								<cfelse>
									<cfset sonuc_query = 'get_det_po'>
								</cfif>
								<cfset sonuc_recordcount = evaluate('#sonuc_query#.recordcount')>
								<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#sonuc_recordcount#</cfoutput>">
								<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_product#xml_str#</cfoutput>&type=1&project_head=<cfoutput><cfif len(GET_DET_PO.PROJECT_ID)>#get_project_name(GET_DET_PO.PROJECT_ID)#</cfif></cfoutput>&record_num=' + form_basket.record_num.value,'list')"><i class="fa fa-plus"></i></a>
							</th>
							<th width="70"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
							<cfif x_is_barkod_col eq 1><th width="90"><cf_get_lang dictionary_id='57633.Barkod'></th></cfif>
							<th width="170"><cf_get_lang dictionary_id='57452.Stok'></th>
							<th width="170" style="display:<cfoutput>#spec_img_display#</cfoutput>"><cf_get_lang dictionary_id='57647.spect'></th>
							<cfif xml_work eq 1><th style="min-width:150px;"><cf_get_lang dictionary_id='58445.İş'></th></cfif>
							<th style="min-width:90px;"><cf_get_lang dictionary_id='57635.Miktar'></th>
							<cfif x_is_fire_product eq 1>
								<th width="60"><cf_get_lang dictionary_id='29471.Fire'></th>
							</cfif>
							<th width="60"><cf_get_lang dictionary_id='57636.Birim'></th>
								<th style="min-width:65px;"><cf_get_lang dictionary_id='29784.Ağırlık'>(KG)</th>
								<cfif x_is_show_abh eq 1>
									<th style="min-width:65px;"><cf_get_lang dictionary_id="48152.En">(cm)</th>
									<th style="min-width:65px;"><cf_get_lang dictionary_id="55735.Boy">(cm)</th>
									<th style="min-width:65px;"><cf_get_lang dictionary_id="57696.Yükseklik">(cm)</th>
								</cfif>
								<cfif xml_specific_weight eq 1>
									<th style="min-width:65px;"><cf_get_lang dictionary_id="64080.Özgül Ağırlık"></th>
								</cfif>		
							<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
								<th width="100" style="text-align:right;"><cf_get_lang dictionary_id='36767.Birim Maliyet'></th>
								<th width="100" style="text-align:right;"><cf_get_lang dictionary_id="37183.Ek Maliyet"></th>
								<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
									<th width="100" style="text-align:right;"><cf_get_lang dictionary_id='36812.Toplam Maliyet'></th>
								</cfif>
								<th width="50"><cf_get_lang dictionary_id='57489.Para Br'></th>
								<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
									<th width="100" style="text-align:right;"><cf_get_lang dictionary_id='36767.Birim Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									<th width="100" style="text-align:right;"><cf_get_lang dictionary_id="37183.Ek Maliyet"> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
										<th width="100" style="text-align:right;"><cf_get_lang dictionary_id='36812.Toplam Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									</cfif>
									<th width="50"><cf_get_lang dictionary_id='57489.Para Br'></th>
								</cfif>
							</cfif>
							<cfif is_show_two_units eq 1>
								<th width="60">2.<cf_get_lang dictionary_id='57635.Miktar'></th>
								<th width="60">2.<cf_get_lang dictionary_id='57636.Birim'></th>
							</cfif>
							<cfif is_show_product_name2 eq 1>
								<th width="70">2.<cf_get_lang dictionary_id='57629.Açıklama'></th>
							</cfif>
						</tr>
					</thead>
					<tbody>
						<!--- Ana ürün --->
						<cfoutput query="#sonuc_query#">
							<cfquery name="GET_PRODUCT" datasource="#dsn3#" maxrows="1">
								SELECT 
									PRODUCT_COST_ID,
									PURCHASE_NET_MONEY,
									PURCHASE_NET_ALL PURCHASE_NET,
									PURCHASE_NET_SYSTEM_ALL PURCHASE_NET_SYSTEM,
									PURCHASE_NET_SYSTEM_2_ALL PURCHASE_NET_SYSTEM_2,
									PURCHASE_NET_SYSTEM_MONEY,
									PURCHASE_EXTRA_COST,
									PURCHASE_EXTRA_COST_SYSTEM,
									PURCHASE_EXTRA_COST_SYSTEM_2,
									PRODUCT_COST,
									MONEY 
								FROM 
									PRODUCT_COST 
								WHERE 
									PRODUCT_ID = #product_id# AND
									START_DATE <= #now()# 
								ORDER BY 
									START_DATE DESC,
									RECORD_DATE DESC,
									PRODUCT_COST_ID DESC
							</cfquery>
							<cfscript>
								if(session.ep.period_year gt 2008){//1 sene sonra kaldırılmalı!
									if(GET_PRODUCT.MONEY is "YTL") GET_PRODUCT.MONEY = 'TL';
									if(GET_PRODUCT.PURCHASE_NET_MONEY is "YTL") GET_PRODUCT.PURCHASE_NET_MONEY = 'TL';
									if(GET_PRODUCT.PURCHASE_NET_SYSTEM_MONEY is "YTL") GET_PRODUCT.PURCHASE_NET_SYSTEM_MONEY = 'TL';
								}
								if(GET_PRODUCT.RECORDCOUNT eq 0)
								{
									cost_id = 0;
									purchase_extra_cost = 0;
									product_cost = 0;
									product_cost_money = session.ep.money;
									cost_price = 0;
									cost_price_money = session.ep.money;
									cost_price_2 = 0;
									cost_price_money_2 = session.ep.money2;
									cost_price_system = 0;
									cost_price_system_money = session.ep.money;
									purchase_extra_cost_system = 0;
									purchase_extra_cost_system_2 = 0;
								}
								else
								{
									cost_id = get_product.product_cost_id;
									purchase_extra_cost = GET_PRODUCT.PURCHASE_EXTRA_COST;
									product_cost = GET_PRODUCT.PRODUCT_COST;
									product_cost_money = GET_PRODUCT.MONEY;
									cost_price = GET_PRODUCT.PURCHASE_NET;
									cost_price_money = GET_PRODUCT.PURCHASE_NET_MONEY;
									cost_price_2 = GET_PRODUCT.PURCHASE_NET_SYSTEM_2;
									cost_price_money_2 = session.ep.money2;
									cost_price_system = GET_PRODUCT.PURCHASE_NET_SYSTEM;
									cost_price_system_money = GET_PRODUCT.PURCHASE_NET_SYSTEM_MONEY;
									purchase_extra_cost_system = GET_PRODUCT.PURCHASE_EXTRA_COST_SYSTEM;
									purchase_extra_cost_system_2 = GET_PRODUCT.PURCHASE_EXTRA_COST_SYSTEM_2;
								}
							</cfscript>
							<input type="hidden" name="cost_id#currentrow#" id="cost_id#currentrow#" value="#get_product.product_cost_id#">
							<tr id="frm_row#currentrow#" <cfif TREE_TYPE is 'P'>class="phantom" title="Phantom Ağaçtan Ürünler"<cfelseif TREE_TYPE is 'O'>class="operasyon" title="Operasyondan Gelen Ürünler"</cfif>>
								<td>
									<cfif len(wrk_row_id)>
									<input type="hidden" name="wrk_row_id_#currentrow#" id="wrk_row_id_#currentrow#" value="#wrk_row_id#">
									</cfif>
									<input type="hidden" name="tree_type_#currentrow#" id="tree_type_#currentrow#" value="#TREE_TYPE#">
									<input type="hidden" name="is_free_amount_#currentrow#" id="is_free_amount_#currentrow#" value="#is_free_amount#">
									<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
									<input type="hidden" name="product_cost#currentrow#" id="product_cost#currentrow#" value="#product_cost#"><!--- giydirilmiş maliyet --->
									<input type="hidden" name="product_cost_money#currentrow#" id="product_cost_money#currentrow#" value="#product_cost_money#"><!--- giydirilmiş maliyet para birimi--->
									<input type="hidden" name="kdv_amount#currentrow#" id="kdv_amount#currentrow#" value="#tax#"><!--- ürün kdv oranı //tax_purchase--->
									<input type="hidden" name="cost_price_system#currentrow#" id="cost_price_system#currentrow#" value="#cost_price_system#">
									<input type="hidden" name="purchase_extra_cost_system#currentrow#" id="purchase_extra_cost_system#currentrow#" value="#wrk_round(PURCHASE_EXTRA_COST_SYSTEM,8,1)#">
									<input type="hidden" name="purchase_extra_cost#currentrow#" id="purchase_extra_cost#currentrow#" value="#purchase_extra_cost#">
									<input type="hidden" name="money_system#currentrow#" id="money_system#currentrow#" value="#cost_price_system_money#">
									<a style="cursor:pointer" onclick="sil('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
								</td>
								<td><input type="text" name="STOCK_CODE#currentrow#" id="STOCK_CODE#currentrow#" value="#STOCK_CODE#" style="width:120px;" readonly=""></td>
								<cfif x_is_barkod_col eq 1><td><input type="text" name="barcode#currentrow#" id="barcode#currentrow#" value="#barcod#" style="width:90px;" readonly=""></td></cfif>
								<td nowrap="nowrap">
									<div class="fprm-group">
										<div class="input-group">
											<input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
											<input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#stock_id#" >
											<input type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="#product_name# #property#" readonly style="width:230px;">
											<span class="input-group-addon icon-ellipsis btnPointer" onClick="get_stok_spec_detail_ajax('#product_id#');"title="<cf_get_lang dictionary_id='45567.Stok Detay'>"></span>
										</div>
									</div>
								</td>
								<td style="display:#spec_img_display#;" nowrap="nowrap">
									<div class="fprm-group">
										<div class="input-group">
											<cfif ( isdefined('#sonuc_query#.spec_main_id') and len(evaluate('#sonuc_query#.spec_main_id')) and evaluate('#sonuc_query#.spec_main_id') gt 0) or (isdefined('#sonuc_query#.spect_var_id') and len(evaluate('#sonuc_query#.spect_var_id')) and evaluate('#sonuc_query#.spect_var_id') gt 0)><!--- demontajda GET_SUB_PRODUCTS querysi calistigi icin burda spect olmamali yari mamulün spectini bilemeyiz--->
												<cfquery name="GET_SPECT" datasource="#dsn3#">
													<cfif len(evaluate('#sonuc_query#.spect_var_id'))>
														SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = #evaluate('#sonuc_query#.spect_var_id')#
													<cfelse>
														SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = #evaluate('#sonuc_query#.SPEC_MAIN_ID')#
													</cfif>
												</cfquery>
												<input type="hidden" value="#evaluate('#sonuc_query#.spect_var_id')#" name="spect_id_#currentrow#" id="spect_id_#currentrow#">
												<input type="#Evaluate('spec_display')#" value="#evaluate('#sonuc_query#.SPEC_MAIN_ID')#" name="spec_main_id#currentrow#" id="spec_main_id#currentrow#" readonly style="width:40px;">
												<input type="#Evaluate('spec_display')#" value="#evaluate('#sonuc_query#.spect_var_id')#" name="spect_id#currentrow#" id="spect_id#currentrow#" readonly style="width:40px;">
												<input type="#Evaluate('spec_name_display')#" name="spect_name#currentrow#" id="spect_name#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:150px;">
											<cfelse>
												<cfif IS_PRODUCTION eq 1 and not len(RELATED_SPECT_ID) or RELATED_SPECT_ID eq 0>
													<cfif isdefined('IS_PRODUCTION') and IS_PRODUCTION eq 1 and((isdefined('stock#STOCK_ID#_spec_main_id') and not len(Evaluate('stock#STOCK_ID#_spec_main_id'))) or not isdefined('stock#STOCK_ID#_spec_main_id'))>
														<cfscript>
															create_spect_from_product_tree = get_main_spect_id(stock_id);
															if(len(create_spect_from_product_tree.SPECT_MAIN_ID))
																'stock#STOCK_ID#_spec_main_id' = create_spect_from_product_tree.SPECT_MAIN_ID;
														</cfscript>  
													</cfif>
												<cfelse>
												<cfset 'stock#STOCK_ID#_spec_main_id' = RELATED_SPECT_ID>
												</cfif>

												<cfif isdefined('stock#STOCK_ID#_spec_main_id') and len(Evaluate('stock#STOCK_ID#_spec_main_id'))>
													<cfquery name="GET_SPECT_S_" datasource="#dsn3#">
														SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = #Evaluate('stock#STOCK_ID#_spec_main_id')#
													</cfquery>
													<cfif GET_SPECT_S_.recordcount>
														<cfset _spec_main_name__ = GET_SPECT_S_.SPECT_VAR_NAME>
													</cfif>
												<cfelse>
												<cfset _spec_main_name__ = ''>
												</cfif>
												<input type="hidden" value="" name="spect_id_#currentrow#" id="spect_id_#currentrow#">
												<input type="#Evaluate('spec_display')#" name="spec_main_id#currentrow#" id="spec_main_id#currentrow#" value="<cfif isdefined('stock#STOCK_ID#_spec_main_id')>#Evaluate('stock#STOCK_ID#_spec_main_id')#</cfif>" readonly style="width:40px;">
												<input type="#Evaluate('spec_display')#" value="" name="spect_id#currentrow#" id="spect_id#currentrow#" readonly style="width:40px;">
												<input type="#Evaluate('spec_name_display')#" name="spect_name#currentrow#" id="spect_name#currentrow#" value="#_spec_main_name__#" readonly style="width:150px;">
											</cfif>
												<span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_ac_spect('#currentrow#');" style="display:#spec_img_display#"></span>
										</div>
									</div>
								</td>
								<cfif xml_work eq 1>
									<td style="width:140px;" nowrap="nowrap">
										<div class="form-group">
											<div class="input-group">
												<input type="text" name="work_head#currentrow#" id="work_head#currentrow#" style="width:110px;" value="">
												<input type="hidden" name="work_id#currentrow#" id="work_id#currentrow#" value="">
												<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='58691.iş listesi'>" onclick="pencere_ac_work('#currentrow#');"></span> 
											</div>
										</div>					
									</td>
								</cfif>
								<td nowrap="nowrap">
									<div class="form-group">
										<div class="input-group">
											<cfset _AMOUNT_ = wrk_round(AMOUNT,round_number,1)>
											<cfif isDefined("x_exit_amount_change_auto") and x_exit_amount_change_auto neq 1><cfset auto_calc_amount_exit_ = 0><cfelse><cfset auto_calc_amount_exit_ = 1></cfif>
											<input type="hidden" name="auto_calc_amount_exit" id="auto_calc_amount_exit" value="#auto_calc_amount_exit_#">
											<cfif get_det_po.is_demontaj eq 1><!---demantajda miktar carpmali Demontaj alt ürünler--->
												
												<cfif GET_ROW_AMOUNT.RECORDCOUNT>
													<cfset kalan_uretim_miktari = wrk_round(AMOUNT-GET_SUM_AMOUNT.SUM_AMOUNT,round_number,1)><cfif kalan_uretim_miktari lt 0><cfset kalan_uretim_miktari = 1></cfif>
													<cfset kalan_uretim_miktari_new = kalan_uretim_miktari>
													<cfset maliyet_miktarı= kalan_uretim_miktari>
													<input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#TlFormat(kalan_uretim_miktari,round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,1);" class="moneybox" style="width:70px;" <cfif is_change_amount_demontaj eq 0>readonly=""</cfif>>
													<input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="#TlFormat(kalan_uretim_miktari,round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,1);" class="moneybox" style="width:60px;" <cfif is_change_amount_demontaj eq 0>readonly=""</cfif>>
												<cfelseif NOT GET_ROW_AMOUNT.RECORDCOUNT>
													<cfset kalan_uretim_miktari_new = _AMOUNT_><!--- #TlFormat(_AMOUNT_*get_det_po.AMOUNT,8)# --->
													<cfset maliyet_miktarı= _AMOUNT_>
													<input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#TlFormat(_AMOUNT_,round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,1);" class="moneybox" style="width:70px;" <cfif is_change_amount_demontaj eq 0>readonly=""</cfif>>
													<input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="#TlFormat(_AMOUNT_,round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,1);" class="moneybox" style="width:60px;" <cfif is_change_amount_demontaj eq 0>readonly=""</cfif>>
												</cfif>	
											<cfelse><!--- Normal ürün ismi --->
												<cfif GET_ROW_AMOUNT.RECORDCOUNT AND TYPE_PRODUCT eq 1>
													<cfset kalan_uretim_miktari = wrk_round(AMOUNT-GET_SUM_AMOUNT.SUM_AMOUNT,round_number,1)><cfif kalan_uretim_miktari lt 0><cfset kalan_uretim_miktari = 1></cfif>
													<cfset maliyet_miktarı= kalan_uretim_miktari>
													<input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#TlFormat(kalan_uretim_miktari,round_number)#" onchange="find_amount2(#currentrow#)" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox" style="width:70px;">
													<input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="#TlFormat(kalan_uretim_miktari,round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox" style="width:60px;">
												<cfelseif NOT GET_ROW_AMOUNT.RECORDCOUNT or TYPE_PRODUCT eq 0>
													<cfset kalan_uretim_miktari = _AMOUNT_>
													<cfset maliyet_miktarı= kalan_uretim_miktari>
													<input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#TlFormat(_AMOUNT_,round_number)#" onchange="find_amount2(#currentrow#)" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox" style="width:70px;">
													<input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="#TlFormat(_AMOUNT_,round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox" style="width:60px;">
												<cfelseif _AMOUNT_ eq GET_SUM_AMOUNT.SUM_AMOUNT>
													<cfset kalan_uretim_miktari = _AMOUNT_>
													<cfset maliyet_miktarı= 0>
													<input type="text" name="amount#currentrow#" id="amount#currentrow#" value="0" onchange="find_amount2(#currentrow#)" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox" style="width:70px;"onClick="aktar();">
													<input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="0" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox" style="width:60px;"onClick="aktar();"> 
												</cfif>
										
											</cfif>
											<cfif auto_calc_amount_exit_ eq 0>
												<span class="input-group-addon" onclick="document.getElementById('auto_calc_amount_exit').value=1;aktar();"><i class="fa fa-pencil"></i></span>
											</cfif>
										</div>
									</div>
								</td>
								<cfif x_is_fire_product eq 1>
									<td>
										<input type="text" class="moneybox" name="fire_amount_#currentrow#" id="fire_amount_#currentrow#" value="0" style="width:60px;" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,3);aktar();">
									</td>
								</cfif>
								<td>
									<input type="hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="#product_unit_id#">
									<input type="text" name="unit#currentrow#" id="unit#currentrow#" value="#main_unit#" readonly style="width:60px;">
								</td>
								<td>
									<div class="form-group">
										<input type="text" onchange="find_amount2(#currentrow#);Get_Product_Unit_2_And_Quantity_2(#currentrow#);" name="weight#currentrow#" id="weight#currentrow#" value="">
									</div>
								</td>
								<cfif x_is_show_abh eq 1>
									<td>
										<div class="form-group">
											<input type="text" onchange="Get_Product_Unit_2_And_Quantity_2(#currentrow#)" name="width#currentrow#" id="width#currentrow#" <cfif isdefined("width") and len(width)>value="#WIDTH#"</cfif> style="width:60px;">
										</div>
									</td>
									<td>
										<div class="form-group">
											<input type="text" onchange="Get_Product_Unit_2_And_Quantity_2(#currentrow#)" name="height#currentrow#" id="height#currentrow#" <cfif isdefined("HEIGHT") and len(HEIGHT)>value="#HEIGHT#"</cfif>  style="width:60px;">
										</div>
									</td>
									<td>
										<div class="form-group">
											<input type="text" onchange="Get_Product_Unit_2_And_Quantity_2(#currentrow#)"onchange="Get_Product_Unit_2_And_Quantity_2(#currentrow#)" name="length#currentrow#" id="length#currentrow#" <cfif isdefined("LENGTH") and len(LENGTH)>value="#LENGTH#"</cfif>  style="width:60px;">
										</div>
									</td>
								</cfif>
							 	<cfif xml_specific_weight eq 1> 
									<td>
										<div class="form-group">
											<input type="text" onchange="find_weight(#currentrow#);" name="specific_weight#currentrow#" id="specific_weight#currentrow#" value=""  style="width:60px;">
										</div>
									</td>
								</cfif>
								<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
									<td><input type="text" name="cost_price#currentrow#" style="width:125px;" id="cost_price#currentrow#" value="#TLFormat(wrk_round(cost_price,8,1),round_number)#" class="moneybox" readonly></td>
									<td><input type="text" name="cost_price_extra#currentrow#" style="width:125px;" id="cost_price_extra#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM,8,1),round_number)#" class="moneybox" readonly></td>
									<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
										<td><input type="text" name="total_cost_price#currentrow#" style="width:125px;" id="total_cost_price#currentrow#" value="#TLFormat(cost_price*maliyet_miktarı,round_number)#" class="moneybox" readonly></td>
									</cfif>
									<td><input type="text" name="money#currentrow#" id="money#currentrow#" value="#cost_price_money#" readonly style="width:50px;"></td>
									<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
										<td><input type="text" name="cost_price_2#currentrow#" id="cost_price_2#currentrow#" style="width:125px;" value="#TLFormat(wrk_round(cost_price_2,8,1),round_number)#" class="moneybox" readonly></td>
										<td><input type="text" name="cost_price_extra_2#currentrow#" id="cost_price_extra_2#currentrow#" value="#TLFormat(wrk_round(purchase_extra_cost_system_2,8,1),round_number)#"></td>
										<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
											<td><input type="text" name="total_cost_price_2#currentrow#" id="total_cost_price_2#currentrow#" style="width:125px;" value="#TLFormat(wrk_round(cost_price_2+purchase_extra_cost_system_2,8,1)*maliyet_miktarı,round_number)#" class="moneybox" readonly></td>
										</cfif>
										<td><input type="text" name="money_2#currentrow#" id="money_2#currentrow#" value="#cost_price_money_2#" readonly style="width:50px;"></td>
									<cfelse>
										<input type="hidden" name="cost_price_2#currentrow#" id="cost_price_2#currentrow#" value="#TLFormat(wrk_round(cost_price_2,8,1),round_number)#">
										<input type="hidden" name="cost_price_extra_2#currentrow#" id="cost_price_extra_2#currentrow#" value="#TLFormat(wrk_round(purchase_extra_cost_system_2,8,1),round_number)#">
										<input type="hidden" name="money_2#currentrow#" id="money_2#currentrow#" value="#cost_price_money_2#">
									</cfif>
								<cfelse>
									<input type="hidden" name="cost_price#currentrow#" id="cost_price#currentrow#" value="#TLFormat(wrk_round(cost_price,8,1),round_number)#">
									<input type="hidden" name="money#currentrow#" id="money#currentrow#" value="#cost_price_money#">
									<input type="hidden" name="total_cost_price#currentrow#" id="total_cost_price#currentrow#" value="#TLFormat(cost_price*maliyet_miktarı,round_number)#">
									<input type="hidden" name="cost_price_2#currentrow#" id="cost_price_2#currentrow#" value="#TLFormat(wrk_round(cost_price_2,8,1),round_number)#">
									<input type="hidden" name="total_cost_price_2#currentrow#" id="total_cost_price_2#currentrow#" value="#TLFormat((wrk_round(cost_price_2+purchase_extra_cost_system_2,8,1))*maliyet_miktarı,round_number)#">
									<input type="hidden" name="cost_price_extra_2#currentrow#" id="cost_price_extra_2#currentrow#" value="#TLFormat(wrk_round(purchase_extra_cost_system_2,8,1),round_number)#">
									<input type="hidden" name="money_2#currentrow#" id="money_2#currentrow#" value="#cost_price_money_2#">
								</cfif>
								<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
									<cfquery name="production_orders_unit2" datasource="#dsn3#">
										-- Select rows from a Table or View 'TableOrViewName' in schema 'SchemaName'
										SELECT QUANTITY_2,UNIT_2,PR.MULTIPLIER
										  FROM PRODUCTION_ORDERS PO
 									 LEFT JOIN PRODUCT_UNIT      PR ON PR.ADD_UNIT=PO.UNIT_2
										 WHERE P_ORDER_ID=#attributes.p_order_id# 
										   AND PR.PRODUCT_ID=#PRODUCT_ID#
									</cfquery>

									<input type="hidden" name="unit2_order" id="unit2_order" value="#production_orders_unit2.UNIT_2#">
									<input type="hidden" name="unit2_multiplier" id="unit2_multiplier" value="#production_orders_unit2.MULTIPLIER#">
									<td><input type="text" readonly name="amount2_#currentrow#" id="amount2_#currentrow#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="" <cfif isdefined("AMOUNT2") and len(AMOUNT2)>VALUE="#AMOUNT2#"</cfif> class="moneybox" style="width:70px;" onchange="Get_Product_Unit_2_And_Quantity_2(#currentrow#)"></td>
									<td>
										<cfquery name="get_all_unit2" datasource="#dsn3#">
											SELECT 
												PRODUCT_UNIT_ID,ADD_UNIT
											FROM 
												PRODUCT_UNIT 
											WHERE
												PRODUCT_ID = #PRODUCT_ID#
												AND PRODUCT_UNIT_STATUS = 1
										</cfquery>
										<input type="hidden" name="indexCurrent" id="indexCurrent" value="#currentrow#">
										<select name="unit2#currentrow#" id="unit2#currentrow#" onchange="Get_Product_Unit_2_And_Quantity_2(#currentrow#)" style="width:60;" disabled="true">

											<cfloop query="get_all_unit2">
												<option value="#PRODUCT_UNIT_ID#" <cfif get_all_unit2.ADD_UNIT eq production_orders_unit2.UNIT_2>selected</cfif>>#ADD_UNIT#</option>
											</cfloop>
										</select>
									</td>
								</cfif>
								<td style="display:#product_name2_display#"><input type="text" style="width:70px;" name="product_name2#currentrow#" id="product_name2#currentrow#" value=""></td>
							</tr>
							<cfif get_det_po.is_demontaj eq 1>
								<cfscript>
									if(len(GET_PRODUCT.PURCHASE_NET_SYSTEM))
										demontaj_cost_price_system = demontaj_cost_price_system+kalan_uretim_miktari_new*GET_PRODUCT.PURCHASE_NET_SYSTEM;
									if(len(GET_PRODUCT.PURCHASE_NET_SYSTEM_2))
										demontaj_cost_price_system_2 = demontaj_cost_price_system_2+kalan_uretim_miktari_new*GET_PRODUCT.PURCHASE_NET_SYSTEM_2;
									if(len(GET_PRODUCT.PURCHASE_EXTRA_COST_SYSTEM))
										demontaj_purchase_extra_cost_system =demontaj_purchase_extra_cost_system+kalan_uretim_miktari_new*GET_PRODUCT.PURCHASE_EXTRA_COST_SYSTEM;
								</cfscript>
							</cfif>
							</cfoutput>
					</tbody>
				</cf_grid_list>
				<cfif get_det_po.is_demontaj eq 1>
					<cfset sarf_query='get_det_po'>
				<cfelse>
					<cfset sarf_query='GET_SUB_PRODUCTS'>
				</cfif>
				<cfset deger_value_row = evaluate('#sarf_query#.recordcount')>
				<br />
				<cfsavecontent variable="header"><cf_get_lang dictionary_id='40196.Sarf'></cfsavecontent>
				<cf_seperator header="#header#" id="table2">
				<cf_grid_list id="table2">
					<div id="add_prod2"></div>
					<thead>
						<tr>
							<th><input type="hidden" name="record_num_exit" id="record_num_exit" value="<cfoutput>#deger_value_row#</cfoutput>"/><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_product#xml_str#</cfoutput>&type=0&record_num_exit=' + form_basket.record_num_exit.value,'list')"><i class="fa fa-plus"></i></a></th>
							<th width="70"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
							<cfif x_is_barkod_col eq 1><th width="90"><cf_get_lang dictionary_id='57633.Barkod'></th></cfif>
							<th width="170"><cf_get_lang dictionary_id='57452.Stok'></th>
							<th width="270" style="display:<cfoutput>#spec_img_display#</cfoutput>"><cf_get_lang dictionary_id='57647.spect'></th>
							<th width="75"><cf_get_lang dictionary_id='36698.Lot No'></th>
							<th style="width:90px;" nowrap><cf_get_lang dictionary_id='33892.Son Kullanma Tarihi'></th>
							<th width="60"><cf_get_lang dictionary_id='57635.Miktar'></th>
							<th width="60"><cf_get_lang dictionary_id='57636.Birim'></th>
								<th style="min-width:65px;"><cf_get_lang dictionary_id='29784.Ağırlık'>(KG)</th>
								<cfif x_is_show_abh eq 1>
									<th style="min-width:65px;"><cf_get_lang dictionary_id="48152.En">(cm)</th>
									<th style="min-width:65px;"><cf_get_lang dictionary_id="55735.Boy">(cm)</th>
									<th style="min-width:65px;"><cf_get_lang dictionary_id="57696.Yükseklik">(cm)</th>
								</cfif>
								<cfif xml_specific_weight eq 1>
									<th style="min-width:65px;"><cf_get_lang dictionary_id="64080.Özgül Ağırlık"></th>
								</cfif>	
							<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
								<th width="120" style="text-align:right;"><cf_get_lang dictionary_id='36767.Birim Maliyet'></th>
								<th width="120" style="text-align:right;"><cf_get_lang dictionary_id="36502.Ek Maliyet"></th>
								<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
									<th width="120" style="text-align:right;"><cf_get_lang dictionary_id='36812.Toplam Maliyet'></th>
								</cfif>
								<th width="50"><cf_get_lang dictionary_id='57489.Para Br'></th>
								<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
									<th width="120" style="text-align:right;"><cf_get_lang dictionary_id='36767.Birim Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									<th width="120" style="text-align:right;"><cf_get_lang dictionary_id="36502.Ek Maliyet"> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
										<th width="120" style="text-align:right;"><cf_get_lang dictionary_id='36812.Toplam Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									</cfif>
									<th width="50"><cf_get_lang dictionary_id='57489.Para Br'></th>
								</cfif>
							</cfif>
							<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
							<th width="60">2.<cf_get_lang dictionary_id='57635.Miktar'></th>
							<th width="60">2.<cf_get_lang dictionary_id='57636.Birim'></th>
							</cfif>
							<cfif is_show_product_name2 eq 1>
							<th width="70">2.<cf_get_lang dictionary_id='57629.Açıklama'></th>
							</cfif>
							<cfif get_det_po.is_demontaj neq 1 and x_is_show_sb eq 1><th width="30">SB</th></cfif>
							<cfif isdefined('x_is_show_mc') and x_is_show_mc eq 1><th width="30" title="<cf_get_lang dictionary_id='57400.Manuel Maliyet'>">M</th></cfif>
						</tr>
					</thead>
					<tbody id="table2_body">
						<cfoutput query="#sarf_query#">
							<cfif get_det_po.is_demontaj neq 1>
								<cfquery name="GET_SUM_AMOUNT" datasource="#DSN3#">
									SELECT 
										ISNULL(SUM(POR_.AMOUNT),0) AS SUM_AMOUNT
									FROM 
										PRODUCTION_ORDER_RESULTS_ROW POR_,
										PRODUCTION_ORDER_RESULTS POO
									WHERE 
										POR_.PR_ORDER_ID = POO.PR_ORDER_ID
										AND POO.P_ORDER_ID =#attributes.p_order_id#
										AND POR_.STOCK_ID =#STOCK_ID#
										AND POR_.TYPE=2
										<cfif len(related_spect_id)>
											AND POR_.SPEC_MAIN_ID =#related_spect_id#
										</cfif>
										<cfif len(wrk_row_id)>
											AND (POR_.WRK_ROW_RELATION_ID = '#wrk_row_id#' OR POR_.WRK_ROW_RELATION_ID IS NULL)
										</cfif>
								</cfquery>
								<cfquery name="GET_PRODUCT" datasource="#dsn3#" maxrows="1">
									SELECT
										PRODUCT_COST_ID,
										PURCHASE_NET_MONEY,
										PURCHASE_NET_ALL PURCHASE_NET,
										PURCHASE_NET_SYSTEM_ALL PURCHASE_NET_SYSTEM,
										PURCHASE_NET_SYSTEM_2_ALL PURCHASE_NET_SYSTEM_2,
										PURCHASE_NET_SYSTEM_MONEY,
										PURCHASE_EXTRA_COST,
										PURCHASE_EXTRA_COST_SYSTEM,
										PURCHASE_EXTRA_COST_SYSTEM_2,
										PRODUCT_COST,
										MONEY 
									FROM 
										PRODUCT_COST 
									WHERE 
										PRODUCT_ID = #product_id# AND
										DATEADD ( hh , (-1*DATEPART( hh ,DATEADD ( n , (-1*DATEPART( n ,
										DATEADD ( s , (-1*DATEPART( s ,START_DATE)), START_DATE ))), 
										DATEADD ( s , (-1*DATEPART( s ,START_DATE)), START_DATE ) ))), 
										DATEADD ( n , (-1*DATEPART( n ,DATEADD ( s , (-1*DATEPART( s ,START_DATE)), START_DATE ))), 
										DATEADD ( s , (-1*DATEPART( s ,START_DATE)), START_DATE ) ) )  <= #createodbcdate(get_det_po.finish_date)#
									ORDER BY 
										START_DATE DESC,
										RECORD_DATE DESC,
										PRODUCT_COST_ID DESC
								</cfquery>
								<cfscript>
									if(session.ep.period_year gt 2008){//1 sene sonra kaldırılmalı!
										if(GET_PRODUCT.MONEY is "YTL") GET_PRODUCT.MONEY = 'TL';
										if(GET_PRODUCT.PURCHASE_NET_MONEY is "YTL") GET_PRODUCT.PURCHASE_NET_MONEY = 'TL';
										if(GET_PRODUCT.PURCHASE_NET_SYSTEM_MONEY is "YTL") GET_PRODUCT.PURCHASE_NET_SYSTEM_MONEY = 'TL';
									}
									if(GET_PRODUCT.RECORDCOUNT eq 0)
									{
										cost_id = 0;
										purchase_extra_cost = 0;
										product_cost = 0;
										product_cost_money = session.ep.money;
										cost_price = 0;
										cost_price_money = session.ep.money;
										cost_price_2 = 0;
										cost_price_money_2 = session.ep.money2;
										cost_price_system = 0;
										cost_price_system_money = session.ep.money;
										purchase_extra_cost_system = 0;
										purchase_extra_cost_system_2 = 0;
									}
									else
									{
										cost_id = get_product.product_cost_id;
										purchase_extra_cost = GET_PRODUCT.PURCHASE_EXTRA_COST;
										product_cost = GET_PRODUCT.PRODUCT_COST;
										product_cost_money = GET_PRODUCT.MONEY;
										cost_price = GET_PRODUCT.PURCHASE_NET;
										cost_price_money = GET_PRODUCT.PURCHASE_NET_MONEY;
										cost_price_2 = GET_PRODUCT.PURCHASE_NET_SYSTEM_2;
										cost_price_money_2 = session.ep.money2;
										cost_price_system = GET_PRODUCT.PURCHASE_NET_SYSTEM;
										cost_price_system_money = GET_PRODUCT.PURCHASE_NET_SYSTEM_MONEY;
										purchase_extra_cost_system = GET_PRODUCT.PURCHASE_EXTRA_COST_SYSTEM;
										purchase_extra_cost_system_2 = GET_PRODUCT.PURCHASE_EXTRA_COST_SYSTEM_2;
									}
								</cfscript>
							</cfif>
							<!--- SARFLAR --->
							<tr id="frm_row_exit#currentrow#" <cfif TREE_TYPE is 'P'>class="phantom" title="Phantom Ağaçtan Ürünler"<cfelseif TREE_TYPE is 'O'>class="operasyon" title="<cf_get_lang dictionary_id='60507.Operasyondan Gelen Ürünler'>"</cfif>><!--- Eğer fantom ürünün içeriği ise satırın rengini değiştir.. --->
								<cfif get_det_po.is_demontaj eq 1><!---demantajda miktar carpmayalim--->
									<cfif isdefined('GET_SUM_AMOUNT')>
										<cfset sarf_kalan_uretim_emri = get_det_po.AMOUNT-GET_SUM_AMOUNT.SUM_AMOUNT><cfif sarf_kalan_uretim_emri lt 0><cfset sarf_kalan_uretim_emri=1></cfif>
										<cfset sarf_kalan_uretim_emri_new = sarf_kalan_uretim_emri>
									<cfelse>
										<cfset sarf_kalan_uretim_emri_new = get_det_po.AMOUNT>
									</cfif>
								<cfelse>
									<cfif isdefined('GET_SUM_AMOUNT')><!--- Normal ürün alt ürünleri --->
										<cfset sarf_kalan_uretim_emri = get_det_po.AMOUNT-GET_SUM_AMOUNT.SUM_AMOUNT><cfif sarf_kalan_uretim_emri lt 0><cfset sarf_kalan_uretim_emri=1></cfif>
									</cfif>
								</cfif>
								<cfif get_det_po.is_demontaj eq 1>
									<cfscript>
										cost_id = 0;
										if (sarf_kalan_uretim_emri_new gt 0) sarf_kalan_uretim_emri_new_ = sarf_kalan_uretim_emri_new; else sarf_kalan_uretim_emri_new_ = 1;
										purchase_extra_cost = demontaj_purchase_extra_cost_system/sarf_kalan_uretim_emri_new_;
										product_cost = demontaj_cost_price_system/sarf_kalan_uretim_emri_new_;
										product_cost_money = session.ep.money;
										cost_price = demontaj_cost_price_system/sarf_kalan_uretim_emri_new_;
										cost_price_money = session.ep.money;
										cost_price_2 = demontaj_cost_price_system_2/sarf_kalan_uretim_emri_new_;
										cost_price_money_2 = session.ep.money2;
										cost_price_system = demontaj_cost_price_system/sarf_kalan_uretim_emri_new_;
										cost_price_system_money = session.ep.money;
										purchase_extra_cost_system =demontaj_purchase_extra_cost_system/sarf_kalan_uretim_emri_new_;
									</cfscript>
								</cfif>
								<cfset cols_ = 8>
								<input type="hidden" name="cost_id_exit#currentrow#" id="cost_id_exit#currentrow#" value="#cost_id#">
								<input type="hidden" name="is_free_amount#currentrow#" id="is_free_amount#currentrow#" value="#is_free_amount#">
								<input type="hidden" name="line_number_exit_#currentrow#" id="line_number_exit_#currentrow#" value="#line_number#">
								<input type="hidden" name="wrk_row_id_exit_#currentrow#" id="wrk_row_id_exit_#currentrow#" value="#wrk_row_id#">
								<input type="hidden" name="tree_type_exit_#currentrow#" id="tree_type_exit_#currentrow#" value="#TREE_TYPE#">
								<input type="hidden" name="row_kontrol_exit#currentrow#" id="row_kontrol_exit#currentrow#" value="1">
								<input type="hidden" name="product_cost_exit#currentrow#" id="product_cost_exit#currentrow#" value="#product_cost#"><!--- giydirilmiş maliyet --->
								<input type="hidden" name="product_cost_money_exit#currentrow#" id="product_cost_money_exit#currentrow#" value="#product_cost_money#"><!--- giydirilmiş maliyet para birimi--->
								<input type="hidden" name="kdv_amount_exit#currentrow#" id="kdv_amount_exit#currentrow#" value="#tax#"><!--- ürün kdv oranı //tax_purchase--->
								<input type="hidden" name="is_production_spect_exit#currentrow#" id="is_production_spect_exit#currentrow#" value="<cfif isdefined('IS_PRODUCTION') and IS_PRODUCTION eq 1>1<cfelse>0</cfif>"><!--- Üretilen bir ürün ise hidden alan 1 oluyor ve query sayfasında bu ürün için otomatik bir spect oluşuyor --->
								<td nowrap="nowrap" style="text-align:center;width:40px;">
									<a style="cursor:pointer" onclick="copy_row_exit('#currentrow#');" title="<cf_get_lang dictionary_id='1560.Satır Kopyala'>"><img  src="images/copy_list.gif" border="0"></a>
									<a style="cursor:pointer" onclick="sil_exit('#currentrow#');"><img src="images/delete_list.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='57463.Sil'>"></a>
								</td>
								<td><input type="text" name="stock_code_exit#currentrow#" id="stock_code_exit#currentrow#" value="#STOCK_CODE#" style="width:120px;" readonly=""></td>
								<cfif x_is_barkod_col eq 1><td><input type="text" name="barcode_exit#currentrow#" id="barcode_exit#currentrow#" value="#barcod#" readonly style="width:90px;"></td><cfset cols_ = cols_ + 1></cfif>
								<td nowrap>
									<div class="fprm-group">
										<div class="input-group">
											<input type="hidden" name="product_id_exit#currentrow#" id="product_id_exit#currentrow#"value="#product_id#">
											<input type="hidden" name="stock_id_exit#currentrow#" id="stock_id_exit#currentrow#" value="#stock_id#">
											<input type="text" name="product_name_exit#currentrow#" id="product_name_exit#currentrow#" value="#product_name# #property#" readonly style="width:230px;">
											<a href="javascript://" onClick="pencere_ac_alternative(1,'#currentrow#',document.form_basket.product_id_exit#currentrow#.value,document.all.stock_id1.value);"><img src="/images/plus_thin.gif" align="absmiddle" border="0" title="<cf_get_lang dictionary_id='45311.Alternatif Ürünler'>"></a>
											<span class="input-group-addon icon-ellipsis btnPointer" onClick="get_stok_spec_detail_ajax('#product_id#');"title="<cf_get_lang dictionary_id='45567.Stok Detay'>"></span>
										</div>
									</div>
								</td>
								<td style="display:#spec_img_display#;" nowrap>
								<cfif get_det_po.is_demontaj eq 1 and ( len(get_det_po.spect_var_id) or len(get_det_po.spec_main_id) ) ><!--- demontaj ve spec varsa sarfta spec olur--->
									<cfquery name="GET_SPECT" datasource="#dsn3#">
										<cfif len(get_det_po.spect_var_id)>
											SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = #get_det_po.spect_var_id#
										<cfelse>
											SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = #get_det_po.spec_main_id#
										</cfif>
									</cfquery>
									<input type="hidden" name="spect_id_exit_#currentrow#" id="spect_id_exit_#currentrow#" value="#get_det_po.spect_var_id#">
									<input type="#Evaluate('spec_display')#" name="spec_main_id_exit#currentrow#" id="spec_main_id_exit#currentrow#" value="#get_det_po.spec_main_id#" readonly style="width:40px;">
									<input type="#Evaluate('spec_display')#" name="spect_id_exit#currentrow#" id="spect_id_exit#currentrow#" value="#get_det_po.spect_var_id#" readonly style="width:40px;">
									<input type="#Evaluate('spec_name_display')#" name="spect_name_exit#currentrow#" id="spect_name_exit#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:150px;">
									<a href="javascript://" onClick="pencere_ac_spect('#currentrow#',2);"><img src="/images/plus_thin.gif" style="display:#spec_img_display#" align="absmiddle" border="0"></a>
								<cfelse>
									<!--- Alt Üretim Emirlerinde Bir SpecMainId oluşmamış ise ve ürün bir *üretilen* ürün 
									ise bu ürün için MainSpecId'yi burda kendimiz oluşturuyoruz. --->
									<cfif IS_PRODUCTION eq 1 and not len(RELATED_SPECT_ID) or RELATED_SPECT_ID eq 0>
										<cfif isdefined('IS_PRODUCTION') and IS_PRODUCTION  eq 1 and((isdefined('stock#STOCK_ID#_spec_main_id') and not len(Evaluate('stock#STOCK_ID#_spec_main_id'))) or not isdefined('stock#STOCK_ID#_spec_main_id'))>
											<cfscript>
												create_spect_from_product_tree = get_main_spect_id(stock_id);
												if(len(create_spect_from_product_tree.SPECT_MAIN_ID))
													'stock#STOCK_ID#_spec_main_id' = create_spect_from_product_tree.SPECT_MAIN_ID;
											</cfscript> 
										</cfif>
									<cfelse>
										<cfset 'stock#STOCK_ID#_spec_main_id' = RELATED_SPECT_ID>
									</cfif>
									<!--- Eğer demontaj değil ise ve bu sarf ürünler için ana ürün'deki malzeme ihtiyacından üretim yapılmış ise o yapılan üretimler,bu yapılan üretimin alt üretimi
									olacağından ve onlara ait de bir spect oluşacağı için burda o alt üretimlerde oluşan spect id ve ve spect name'leri gösteriyoruz. --->
									<cfif isdefined('stock#STOCK_ID#_spec_main_id') and len(Evaluate('stock#STOCK_ID#_spec_main_id'))>
										<cfquery name="GET_SPECT_S" datasource="#dsn3#">
											SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = #Evaluate('stock#STOCK_ID#_spec_main_id')#
										</cfquery>
										<cfif GET_SPECT_S.recordcount>
											<cfset _spec_main_name__ = GET_SPECT_S.SPECT_VAR_NAME>
										</cfif>
									<cfelse>
										<cfset _spec_main_name__ = ''>
									</cfif>
									<input type="hidden" name="spect_id_exit_#currentrow#" id="spect_id_exit_#currentrow#"value=""><!--- <cfif isdefined('stock#STOCK_ID#_spect_id')>#Evaluate('stock#STOCK_ID#_spect_id')#<cfelseif isdefined('spect_id_exit')>#spect_id_exit#</cfif> --->
									<input type="#Evaluate('spec_display')#" name="spec_main_id_exit#currentrow#" id="spec_main_id_exit#currentrow#" value="<cfif isdefined('stock#STOCK_ID#_spec_main_id')>#Evaluate('stock#STOCK_ID#_spec_main_id')#</cfif>" readonly style="width:40px;">
									<input type="#Evaluate('spec_display')#" name="spect_id_exit#currentrow#" id="spect_id_exit#currentrow#" value="" readonly style="width:40px;"><!--- <cfif isdefined('stock#STOCK_ID#_spect_id')>#Evaluate('stock#STOCK_ID#_spect_id')#<cfelseif isdefined('spect_id_exit')>#spect_id_exit#</cfif> --->
									<input type="#Evaluate('spec_name_display')#" name="spect_name_exit#currentrow#" id="spect_name_exit#currentrow#" value="#_spec_main_name__#" readonly style="width:150px;"><!--- <cfif isdefined('stock#STOCK_ID#_spect_name')>#Evaluate('stock#STOCK_ID#_spect_name')#<cfelseif isdefined('spect_name_exit')>#spect_name_exit#</cfif> --->
									<a href="javascript://" onClick="pencere_ac_spect('#currentrow#',2);"><img src="/images/plus_thin.gif" style="display:#spec_img_display#" align="absmiddle" border="0"></a>
								</cfif>
								</td>
								<td nowrap="nowrap">
									<input type="text" name="lot_no_exit#currentrow#" id="lot_no_exit#currentrow#" value="#lot_no#" onKeyup="lotno_control(#currentrow#,2);" style="width:75px;" />
									<a href="javascript://" onclick="pencere_ac_list_product('#currentrow#','2');"><img src="/images/plus_thin.gif" style="cursor:pointer;" align="absbottom" border="0"></a>
								</td>
								<td nowrap>
									<input type="text" name="expiration_date_exit#currentrow#" id="expiration_date_exit#currentrow#" value="" style="width:70px;" />
									<cf_wrk_date_image date_field="expiration_date_exit#currentrow#">
								</td>
									<cfset _AMOUNT_ = wrk_round(AMOUNT,round_number,1)>
								<td>
									<cfif get_det_po.is_demontaj eq 1><!---demantajda miktar carpmayalim--->
										<cfif isdefined('GET_SUM_AMOUNT')>
											<cfset sarf_kalan_uretim_emri = wrk_round(GET_SUB_PRODUCTS.AMOUNT-GET_SUM_AMOUNT.SUM_AMOUNT,round_number,1)><cfif sarf_kalan_uretim_emri lt 0><cfset sarf_kalan_uretim_emri=1></cfif>
											<cfset sarf_kalan_uretim_emri_new = sarf_kalan_uretim_emri>
											<cfset maliyet_miktarı = sarf_kalan_uretim_emri>
											<input type="text" onchange="find_amount2_exit(#currentrow#)" name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat(sarf_kalan_uretim_emri,round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,0);aktar();" class="moneybox" style="width:70px;">
											<input type="hidden" name="amount_exit_#currentrow#" id="amount_exit_#currentrow#" value="#TlFormat(sarf_kalan_uretim_emri,round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,0);aktar();" class="moneybox" style="width:60px;">
										<cfelse>
											<cfset sarf_kalan_uretim_emri_new = get_det_po.AMOUNT>
											<cfset maliyet_miktarı = get_det_po.AMOUNT>
											<input type="text" onchange="find_amount2_exit(#currentrow#)" name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat(wrk_round(get_det_po.AMOUNT,round_number,1),round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,0);aktar();" class="moneybox" style="width:70px;" onClick="aktar();">
											<input type="hidden" name="amount_exit_#currentrow#" id="amount_exit_#currentrow#" value="#TlFormat(wrk_round(get_det_po.AMOUNT,round_number,1),round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,0);aktar();" class="moneybox" style="width:60px;" onClick="aktar();">
										</cfif>
									<cfelse>
										<cfif is_free_amount eq 1>
											<input type="text" onchange="find_amount2_exit(#currentrow#)" name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat(wrk_round(_AMOUNT_,round_number,1),round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,0);" class="moneybox" style="width:70px;" #_readonly_#>
											<input type="hidden" name="amount_exit_#currentrow#" id="amount_exit_#currentrow#" value="#TlFormat(wrk_round(_AMOUNT_,round_number,1),round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,0);" class="moneybox" style="width:60px;" readonly="">
										<cfelse>	
											<cfif isdefined('GET_SUM_AMOUNT')><!--- Normal ürün alt ürünleri --->
												<cfif isdefined('x_calc_sub_pro_amount') and x_calc_sub_pro_amount eq 1>
													<cfset sarf_kalan_uretim_emri = wrk_round(GET_SUB_PRODUCTS.AMOUNT * kalan_uretim_miktari / get_det_po.amount,round_number,1)>
												<cfelse>
													<cfset sarf_kalan_uretim_emri = wrk_round(GET_SUB_PRODUCTS.AMOUNT-GET_SUM_AMOUNT.SUM_AMOUNT,round_number,1)>
												</cfif>
												<cfif sarf_kalan_uretim_emri lt 0><cfset sarf_kalan_uretim_emri=1></cfif>
												<cfset maliyet_miktarı = sarf_kalan_uretim_emri>
												<input type="text" onchange="find_amount2_exit(#currentrow#)" name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat((sarf_kalan_uretim_emri),round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,0);" class="moneybox" style="width:70px;" #_readonly_# >
												<input type="hidden" name="amount_exit_#currentrow#" id="amount_exit_#currentrow#" value="#TlFormat((sarf_kalan_uretim_emri),round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,0);" class="moneybox" style="width:60px;" readonly="">
											<cfelse>
											<cfset maliyet_miktarı = wrk_round(_AMOUNT_,round_number,1)>
												<input type="text" onchange="find_amount2_exit(#currentrow#)" name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat(_AMOUNT_,round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,0);" class="moneybox" style="width:70px;" #_readonly_#>
												<input type="hidden" name="amount_exit_#currentrow#" id="amount_exit_#currentrow#" value="#TlFormat(_AMOUNT_,round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,0);" class="moneybox" style="width:60px;" readonly="">
											</cfif>
										</cfif>
									</cfif>
								</td>
								<td>
									<input type="hidden" name="unit_id_exit#currentrow#" id="unit_id_exit#currentrow#" value="#product_unit_id#">
									<input type="text" name="unit_exit#currentrow#" id="unit_exit#currentrow#" value="#main_unit#" readonly style="width:60px;">
									<input type="hidden" name="serial_no_exit#currentrow#" id="serial_no_exit#currentrow#" value="" style="width:150px;">
								</td>
								<td>
									<div class="form-group">
										<input type="text" onchange="find_amount2_exit(#currentrow#);Get_Product_Unit_2_And_Quantity_2_exit(#currentrow#);" name="weight_exit#currentrow#" id="weight_exit#currentrow#">
									</div>
								</td>
								<cfif x_is_show_abh eq 1>
									<td>
										<div class="form-group">
											<input type="text" name="width_exit#currentrow#" onchange="Get_Product_Unit_2_And_Quantity_2_exit(#currentrow#)" id="width_exit#currentrow#" style="width:60px;">
										</div>
									</td>
									<td>
										<div class="form-group">
											<input type="text"  name="height_exit#currentrow#" onchange="Get_Product_Unit_2_And_Quantity_2_exit(#currentrow#)" id="height_exit#currentrow#" style="width:60px;">
										</div>
									</td>
									<td>
										<div class="form-group">
											<input type="text" name="length_exit#currentrow#" onchange="Get_Product_Unit_2_And_Quantity_2_exit(#currentrow#)" id="length_exit#currentrow#" style="width:60px;">
										</div>
									</td>
								</cfif>
								<cfif xml_specific_weight eq 1> 
									<td>
										<div class="form-group">
											<input type="text" onchange="find_weight_exit(#currentrow#)" name="specific_weight_exit#currentrow#" id="specific_weight_exit#currentrow#"  style="width:60px;">
										</div>
									</td>
							 	</cfif>
								<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
									<td><input type="text" name="cost_price_exit#currentrow#" id="cost_price_exit#currentrow#" value="#TLFormat(cost_price,round_number)#" class="moneybox" onkeyup="return(FormatCurrency(this,event,8));" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost(#currentrow#,2);"</cfif>></td>
									<td>
										<input type="hidden" name="money_system_exit#currentrow#" id="money_system_exit#currentrow#" value="#cost_price_system_money#">
										<input type="hidden" name="cost_price_system_exit#currentrow#" id="cost_price_system_exit#currentrow#" value="#cost_price_system#">
										<input type="hidden" name="purchase_extra_cost_system_exit#currentrow#" id="purchase_extra_cost_system_exit#currentrow#" value="#wrk_round(purchase_extra_cost_system,8,1)#">
										<input type="text" name="purchase_extra_cost_exit#currentrow#" id="purchase_extra_cost_exit#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST,8,1),8,0)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost(#currentrow#,2);"</cfif>>
									</td>
									<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
										<td><input type="text" name="total_cost_price_exit#currentrow#" id="total_cost_price_exit#currentrow#" value="#TLFormat((cost_price+wrk_round(purchase_extra_cost,8,1))*maliyet_miktarı,round_number)#" readonly class="moneybox"></td>
									</cfif>
									<td><input type="text" name="money_exit#currentrow#" id="money_exit#currentrow#" value="#cost_price_money#" readonly style="width:50px;"></td>
									<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
										<cfset cols_ = cols_ + 3>
										<td><input type="text" name="cost_price_exit_2#currentrow#" id="cost_price_exit_2#currentrow#" value="#TLFormat(cost_price_2,round_number)#" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly</cfif>></td>
										<td><input type="text" name="purchase_extra_cost_exit_2#currentrow#" id="purchase_extra_cost_exit_2#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,8,1),8,0)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly</cfif>></td>
										<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
											<td><input type="text" name="total_cost_price_exit_2#currentrow#" id="total_cost_price_exit_2#currentrow#" value="#TLFormat((cost_price_2+wrk_round(purchase_extra_cost_system_2,8,1))*maliyet_miktarı,round_number)#" readonly class="moneybox"></td>
										</cfif>
										<td><input type="text" name="money_exit_2#currentrow#" id="money_exit_2#currentrow#" value="#cost_price_money_2#" readonly style="width:50px;"></td>
									<cfelse>
										<input type="hidden" name="cost_price_exit_2#currentrow#" id="cost_price_exit_2#currentrow#" value="#TLFormat(cost_price_2,round_number)#">
										<input type="hidden" name="purchase_extra_cost_exit_2#currentrow#" id="purchase_extra_cost_exit_2#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,8,1),8,0)#">
										<input type="hidden" name="money_exit_2#currentrow#" id="money_exit_2#currentrow#" value="#cost_price_money_2#">
									</cfif>
									<cfset cols_ = cols_ + 3>
								<cfelse>
									<input type="hidden" name="cost_price_exit#currentrow#" id="cost_price_exit#currentrow#" value="#TLFormat(cost_price,round_number)#">
									<input type="hidden" name="total_cost_price_exit#currentrow#" id="total_cost_price_exit#currentrow#" value="#TLFormat((cost_price+wrk_round(purchase_extra_cost,8,1)),round_number)#">
									<input type="hidden" name="cost_price_system_exit#currentrow#" id="cost_price_system_exit#currentrow#" value="#cost_price_system#">
									<input type="hidden" name="purchase_extra_cost_system_exit#currentrow#" id="purchase_extra_cost_system_exit#currentrow#" value="#wrk_round(purchase_extra_cost_system,8,1)#">
									<input type="hidden" name="purchase_extra_cost_exit#currentrow#" id="purchase_extra_cost_exit#currentrow#" value="#TLFormat(purchase_extra_cost,round_number)#">
									<input type="hidden" name="money_system_exit#currentrow#" id="money_system_exit#currentrow#" value="#cost_price_system_money#">
									<input type="hidden" name="money_exit#currentrow#" id="money_exit#currentrow#" value="#cost_price_money#">
									<input type="hidden" name="cost_price_exit_2#currentrow#" id="cost_price_exit_2#currentrow#" value="#TLFormat(cost_price_2,round_number)#">
									<input type="hidden" name="total_cost_price_exit_2#currentrow#" id="total_cost_price_exit_2#currentrow#" value="#TLFormat((cost_price_2+wrk_round(purchase_extra_cost_system_2,8,1))*maliyet_miktarı,round_number)#">
									<input type="hidden" name="purchase_extra_cost_exit_2#currentrow#" id="purchase_extra_cost_exit_2#currentrow#" value="#TLFormat(wrk_round(purchase_extra_cost_system_2,8,1),round_number)#">
									<input type="hidden" name="money_exit_2#currentrow#" id="money_exit_2#currentrow#" value="#cost_price_money_2#">
								</cfif>
								<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
								<td><input type="text" name="amount_exit2_#currentrow#" onchange="Get_Product_Unit_2_And_Quantity_2_exit(#currentrow#)" id="amount_exit2_#currentrow#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="" class="moneybox" style="width:70px;"></td>
									<td>
										<cfquery name="get_all_unit2" datasource="#dsn3#">
											SELECT 
												PRODUCT_UNIT_ID,ADD_UNIT
											FROM 
												PRODUCT_UNIT 
											WHERE
												PRODUCT_ID = #PRODUCT_ID#
												AND PRODUCT_UNIT_STATUS = 1
										</cfquery>
										<select name="unit2_exit#currentrow#" id="unit2_exit#currentrow#" style="width:60;" disabled="true">
										<cfloop query="get_all_unit2">
											<option value="#ADD_UNIT#">#ADD_UNIT#</option>
										</cfloop>
										</select>
									</td>
								</cfif>
								<td style="display:#product_name2_display#"><input type="text" style="width:70px;" name="product_name2_exit#currentrow#" id="product_name2_exit#currentrow#" value=""></td>
								<td <cfif x_is_show_sb eq 0> style="display:none;" </cfif>>
									<input type="checkbox" name="is_sevkiyat#currentrow#" id="is_sevkiyat#currentrow#" value="1" <cfif is_sevk eq 1>checked</cfif>><cfif get_det_po.is_demontaj eq 1>SB</cfif>
								</td>
								<td <cfif isdefined('x_is_show_mc') and x_is_show_mc eq 0> style="display:none;" </cfif>>
									<input type="checkbox" name="is_manual_cost_exit#currentrow#" id="is_manual_cost_exit#currentrow#" value="1" <cfif is_manual_cost eq 1>checked</cfif>>
								</td>
								<!--- <td><cfif isdefined('name')>#name#<cfelse>Demontaj</cfif></td> --->
							</tr>
						</cfoutput>
						<input type="hidden" name="sarf_recordcount" id="sarf_recordcount" value="<cfoutput>#GET_SUB_PRODUCTS.recordcount#</cfoutput>">
						<cfset value_currentrow = EVALUATE('#sarf_query#.recordcount')>
					</tbody>
				</cf_grid_list>
				<cfif deger_value_row gt 0>
					<div class="ui-info-bottom flex-end">
						<div><a href="javascript://" onclick="sil_exit_all();" class="ui-wrk-btn ui-wrk-btn-success"><cf_get_lang dictionary_id="30036.hepsini sil"></a></div>
					</div>
				</cfif>
				<cfif get_det_po.is_demontaj eq 1>
					<cfset sarf_query='get_det_po'>
				<cfelse>
					<cfset sarf_query='GET_SUB_PRODUCTS_FIRE'>
				</cfif>
				<cfif isdefined('#sarf_query#.recordcount')>
					<cfset deger_value_row_fire = evaluate('#sarf_query#.recordcount')>
				</cfif>
				<br />
				<cfsavecontent variable="header"><cf_get_lang dictionary_id='29471.Fire'></cfsavecontent>
				<cf_seperator header="#header#" id="table3_cover">
				<cf_grid_list id="table3_cover">
					<div id="add_prod3"></div>
					<thead>
						<tr>
							<th><input type="hidden" name="record_num_outage" id="record_num_outage" value="<cfif isdefined('GET_SUB_PRODUCTS_FIRE.recordcount') and len(GET_SUB_PRODUCTS_FIRE.recordcount) and get_det_po.is_demontaj eq 0><cfoutput>#deger_value_row_fire#</cfoutput><cfelse>0</cfif>"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_product#xml_str#</cfoutput>&type=2&record_num_outage=' + form_basket.record_num_outage.value,'list')"><img id="add_row_outage_image" src="/images/plus_list.gif" align="absmiddle" border="0"></a></th>
							<th width="70"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
							<cfif x_is_barkod_col eq 1><th width="90"><cf_get_lang dictionary_id='57633.Barkod'></th></cfif>
							<th width="250"><cf_get_lang dictionary_id='57452.Stok'></th>
							<th width="230" style="display:<cfoutput>#spec_img_display#</cfoutput>"><cf_get_lang dictionary_id='57647.spect'></th>
							<th width="75"><cf_get_lang dictionary_id='36698.Lot No'></th>
							<th><cf_get_lang dictionary_id='33892.Son Kullanma Tarihi'></th>
							<th width="60"><cf_get_lang dictionary_id='57635.Miktar'></th>
							<th width="60"><cf_get_lang dictionary_id='57636.Birim'></th>
							<th style="min-width:65px;"><cf_get_lang dictionary_id='29784.Ağırlık'>(KG)</th>
								<cfif x_is_show_abh eq 1>
									<th style="min-width:65px;"><cf_get_lang dictionary_id="48152.En">(cm)</th>
									<th style="min-width:65px;"><cf_get_lang dictionary_id="55735.Boy">(cm)</th>
									<th style="min-width:65px;"><cf_get_lang dictionary_id="57696.Yükseklik">(cm)</th>
								</cfif>
								<cfif xml_specific_weight eq 1>
									<th style="min-width:65px;"><cf_get_lang dictionary_id="64080.Özgül Ağırlık"></th>
								</cfif>	
							<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
								<th width="120" style="text-align:right;"><cf_get_lang dictionary_id='36767.Birim Maliyet'></th>
								<th width="120" style="text-align:right;"><cf_get_lang dictionary_id="36502.Ek Maliyet"></th>
								<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
									<th width="120" style="text-align:right;"><cf_get_lang dictionary_id='36812.Toplam Maliyet'></th>
								</cfif>
								<th width="50"><cf_get_lang dictionary_id='57489.Para Br'></th>
								<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
									<th width="120" style="text-align:right;"><cf_get_lang dictionary_id='36767.Birim Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									<th width="120" style="text-align:right;"><cf_get_lang dictionary_id="36502.Ek Maliyet"> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
										<th width="120" style="text-align:right;"><cf_get_lang dictionary_id='36812.Toplam Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									</cfif>
									<th width="50"><cf_get_lang dictionary_id='57489.Para Br'></th>
								</cfif>
							</cfif>
							<cfif is_show_two_units eq 1>
								<th width="60">2.<cf_get_lang dictionary_id='57635.Miktar'></th>
								<th width="60">2.<cf_get_lang dictionary_id='57636.Birim'></th>
							</cfif>
							<cfif is_show_product_name2 eq 1>
							<th width="70">2.<cf_get_lang dictionary_id='57629.Açıklama'></th>
							</cfif>
							<cfif isdefined('x_is_show_mc') and x_is_show_mc eq 1><th width="30" title="<cf_get_lang dictionary_id='57400.Manuel Maliyet'>">M</th></cfif>
						</tr>
					</thead>
					<tbody id="table3_body" name="table3_body">
						<cfif get_det_po.is_demontaj eq 0><!--- Demontajda fire çıktısı olmaz... --->
							<cfif isdefined('GET_SUB_PRODUCTS_FIRE.recordcount')>
								<cfoutput query="#sarf_query#">
									<cfquery name="GET_SUM_AMOUNT_FIRE" datasource="#DSN3#">
										SELECT 
											ISNULL(SUM(POR_.AMOUNT),0) AS SUM_AMOUNT
										FROM 
											PRODUCTION_ORDER_RESULTS_ROW POR_,
											PRODUCTION_ORDER_RESULTS POO
										WHERE 
											POR_.PR_ORDER_ID = POO.PR_ORDER_ID
											AND POO.P_ORDER_ID =#attributes.p_order_id#
											AND POR_.STOCK_ID =#STOCK_ID#
											AND POR_.TYPE=2
											<cfif len(related_spect_id)>
												AND POR_.SPEC_MAIN_ID =#related_spect_id#
											</cfif>
											<cfif len(wrk_row_id)>
												AND (POR_.WRK_ROW_RELATION_ID = '#wrk_row_id#' OR POR_.WRK_ROW_RELATION_ID IS NULL)
											</cfif>
									</cfquery>
									<cfquery name="GET_PRODUCT_FIRE" datasource="#dsn3#" maxrows="1">
										SELECT 
											PRODUCT_COST_ID,
											PURCHASE_NET_MONEY,
											PURCHASE_NET_ALL PURCHASE_NET,
											PURCHASE_NET_SYSTEM_ALL PURCHASE_NET_SYSTEM,
											PURCHASE_NET_SYSTEM_2_ALL PURCHASE_NET_SYSTEM_2,
											PURCHASE_NET_SYSTEM_MONEY,
											PURCHASE_EXTRA_COST,
											PURCHASE_EXTRA_COST_SYSTEM,
											PURCHASE_EXTRA_COST_SYSTEM_2,
											PRODUCT_COST,
											MONEY 
										FROM 
											PRODUCT_COST 
										WHERE 
											PRODUCT_ID = #product_id# AND
											START_DATE <= #createodbcdate(get_det_po.finish_date)#
										ORDER BY 
											START_DATE DESC,
											RECORD_DATE DESC,
											PRODUCT_COST_ID DESC
									</cfquery>
									<cfscript>
										if(GET_PRODUCT_FIRE.RECORDCOUNT eq 0)
										{
											cost_id = 0;
											purchase_extra_cost = 0;
											product_cost = 0;
											product_cost_money = session.ep.money;
											cost_price = 0;
											cost_price_money = session.ep.money;
											cost_price_2 = 0;
											cost_price_money_2 = session.ep.money2;
											cost_price_system = 0;
											cost_price_system_money = session.ep.money;
											purchase_extra_cost_system = 0;
											purchase_extra_cost_system_2 = 0;
										}
										else
										{
											cost_id = GET_PRODUCT_FIRE.product_cost_id;
											purchase_extra_cost = GET_PRODUCT_FIRE.PURCHASE_EXTRA_COST;
											product_cost = GET_PRODUCT_FIRE.PRODUCT_COST;
											product_cost_money = GET_PRODUCT_FIRE.MONEY;
											cost_price = GET_PRODUCT_FIRE.PURCHASE_NET;
											cost_price_money = GET_PRODUCT_FIRE.PURCHASE_NET_MONEY;
											cost_price_2 = GET_PRODUCT_FIRE.PURCHASE_NET_SYSTEM_2;
											cost_price_money_2 = session.ep.money2;
											cost_price_system = GET_PRODUCT_FIRE.PURCHASE_NET_SYSTEM;
											cost_price_system_money = GET_PRODUCT_FIRE.PURCHASE_NET_SYSTEM_MONEY;
											purchase_extra_cost_system = GET_PRODUCT_FIRE.PURCHASE_EXTRA_COST_SYSTEM;
											purchase_extra_cost_system_2 = GET_PRODUCT_FIRE.PURCHASE_EXTRA_COST_SYSTEM_2;
										}
									</cfscript>
									<input type="hidden" name="cost_id_outage#currentrow#" id="cost_id_outage#currentrow#" value="#GET_PRODUCT_FIRE.product_cost_id#">
									<input type="hidden" name="line_number_outage_#currentrow#" id="line_number_outage_#currentrow#" value="#line_number#">
									<input type="hidden" name="wrk_row_id_outage_#currentrow#" id="wrk_row_id_outage_#currentrow#" value="#wrk_row_id#">
									<input type="hidden" name="row_kontrol_outage#currentrow#" id="row_kontrol_outage#currentrow#" value="1">
									<input type="hidden" name="product_cost_outage#currentrow#" id="product_cost_outage#currentrow#" value="#product_cost#"><!--- giydirilmiş maliyet --->
									<input type="hidden" name="product_cost_money_outage#currentrow#" id="product_cost_money_outage#currentrow#" value="#product_cost_money#"><!--- giydirilmiş maliyet para birimi--->
									<input type="hidden" name="kdv_amount_outage#currentrow#" id="kdv_amount_outage#currentrow#" value="#tax#"><!--- ürün kdv oranı //tax_purchase--->
									<tr id="frm_row_outage#currentrow#">
										<td nowrap="nowrap" style="text-align:center;width:40px;">
											<a style="cursor:pointer" onclick="copy_row_outage('#currentrow#');" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"><img  src="images/copy_list.gif" border="0"></a>
											<a style="cursor:pointer" onclick="sil_outage('#currentrow#');"><img src="images/delete_list.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='57463.Sil'>"></a>
										</td>
										<td><input type="text" name="stock_code_outage#currentrow#" id="stock_code_outage#currentrow#" value="#STOCK_CODE#" style="width:120px;" readonly="readonly"></td>
										<cfif x_is_barkod_col eq 1><td><input type="text" name="barcode_outage#currentrow#" id="barcode_outage#currentrow#" value="#barcod#" style="width:90px;" readonly="readonly"></td></cfif>
										<td nowrap="nowrap">
											<div class="fprm-group">
												<div class="input-group">
													<input type="hidden" name="product_id_outage#currentrow#" id="product_id_outage#currentrow#" value="#product_id#">
													<input type="hidden" value="#stock_id#" name="stock_id_outage#currentrow#" id="stock_id_outage#currentrow#">
													<input type="text" name="product_name_outage#currentrow#" id="product_name_outage#currentrow#" value="#product_name# #property#" readonly style="width:230px;">
													<a href="javascript://" onClick="pencere_ac_alternative(2,'#currentrow#',document.form_basket.product_id_outage#currentrow#.value,document.all.stock_id1.value);"><img src="/images/plus_thin.gif" align="absmiddle" border="0" title="<cf_get_lang dictionary_id='45311.Alternatif Ürünler'>"></a>
													<span class="input-group-addon icon-ellipsis btnPointer" onClick="get_stok_spec_detail_ajax('#product_id#');" title="<cf_get_lang dictionary_id='45567.Stok Detay'>"></span>
												</div>
											</div>
										</td>
										<td style="display:#spec_img_display#;" nowrap="nowrap">
											<!--- Alt Üretim Emirlerinde Bir SpecMainId oluşmamış ise ve ürün bir *üretilen* ürün 
											ise bu ürün için MainSpecId'yi burda kendimiz oluşturuyoruz. --->
											<cfif IS_PRODUCTION eq 1 and not len(RELATED_SPECT_ID) or RELATED_SPECT_ID eq 0>
												<cfif isdefined('IS_PRODUCTION') and IS_PRODUCTION  eq 1 and((isdefined('stock#STOCK_ID#_spec_main_id') and not len(Evaluate('stock#STOCK_ID#_spec_main_id'))) or not isdefined('stock#STOCK_ID#_spec_main_id'))>
													<cfscript>
														create_spect_from_product_tree = get_main_spect_id(stock_id);
														if(len(create_spect_from_product_tree.SPECT_MAIN_ID))
															'stock#STOCK_ID#_spec_main_id' = create_spect_from_product_tree.SPECT_MAIN_ID;
													</cfscript> 
												</cfif>
											<cfelse>
												<cfset 'stock#STOCK_ID#_spec_main_id' = RELATED_SPECT_ID>
											</cfif>
											<!--- Eğer demontaj değil ise ve bu sarf ürünler için ana ürün'deki malzeme ihtiyacından üretim yapılmış ise o yapılan üretimler,bu yapılan üretimin alt üretimi
											olacağından ve onlara ait de bir spect oluşacağı için burda o alt üretimlerde oluşan spect id ve ve spect name'leri gösteriyoruz. --->
											<cfif isdefined('stock#STOCK_ID#_spec_main_id') and len(Evaluate('stock#STOCK_ID#_spec_main_id'))>
												<cfquery name="GET_SPECT_S" datasource="#dsn3#">
													SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = #Evaluate('stock#STOCK_ID#_spec_main_id')#
												</cfquery>
												<cfif GET_SPECT_S.recordcount>
													<cfset _spec_main_name__ = GET_SPECT_S.SPECT_VAR_NAME>
												</cfif>
											<cfelse>
												<cfset _spec_main_name__ = ''>
											</cfif>
											<input type="#Evaluate('spec_display')#" name="spec_main_id_outage#currentrow#" id="spec_main_id_outage#currentrow#" value="<cfif isdefined('stock#STOCK_ID#_spec_main_id')>#Evaluate('stock#STOCK_ID#_spec_main_id')#</cfif>" readonly style="width:40px;">
											<input type="#Evaluate('spec_display')#" name="spect_id_outage#currentrow#" id="spect_id_outage#currentrow#" value="" readonly style="width:40px;"><!--- <cfif isdefined('stock#STOCK_ID#_spect_id')>#Evaluate('stock#STOCK_ID#_spect_id')#<cfelseif isdefined('spect_id_exit')>#spect_id_exit#</cfif> --->
											<input type="#Evaluate('spec_name_display')#" name="spect_name_outage#currentrow#" id="spect_name_outage#currentrow#" value="#_spec_main_name__#" readonly style="width:150px;"><!--- <cfif isdefined('stock#STOCK_ID#_spect_name')>#Evaluate('stock#STOCK_ID#_spect_name')#<cfelseif isdefined('spect_name_exit')>#spect_name_exit#</cfif> --->
											<a href="javascript://" onClick="pencere_ac_spect('#currentrow#',3);"><img src="/images/plus_thin.gif" style="display:#spec_img_display#" align="absmiddle" border="0"></a>
										</td>
										<td nowrap="nowrap">
											<input type="text" name="lot_no_outage#currentrow#" id="lot_no_outage#currentrow#" value="#lot_no#" onKeyup="lotno_control(#currentrow#,3);" style="width:75px;">
											<a href="javascript://" onclick="pencere_ac_list_product('#currentrow#','3');"><img src="/images/plus_thin.gif" style="cursor:pointer;" align="absbottom" border="0"></a>
										</td>
										<td nowrap>
											<input type="text" name="expiration_date_outage#currentrow#" id="expiration_date_outage#currentrow#" value="" style="width:70px;" />
											<cf_wrk_date_image date_field="expiration_date_outage#currentrow#">
										</td>
										<cfset _AMOUNT_ = wrk_round(AMOUNT,round_number,1)>
										<td>						   
											<cfif isdefined('GET_SUM_AMOUNT_FIRE')><!--- Normal ürün alt ürünleri --->
												<cfif isdefined('x_calc_sub_pro_amount') and x_calc_sub_pro_amount eq 1>
													<cfset sarf_kalan_uretim_emri = wrk_round(GET_SUB_PRODUCTS_FIRE.AMOUNT * kalan_uretim_miktari / get_det_po.amount,round_number,1)>
												<cfelse>
													<cfset sarf_kalan_uretim_emri = wrk_round(GET_SUB_PRODUCTS_FIRE.AMOUNT-GET_SUM_AMOUNT_FIRE.SUM_AMOUNT,round_number,1)><cfif sarf_kalan_uretim_emri lt 0><cfset sarf_kalan_uretim_emri=1></cfif>
												</cfif>
												<cfset sarf_kalan_uretim_emri_new = sarf_kalan_uretim_emri>
												<cfset maliyet_miktarı = sarf_kalan_uretim_emri>
												<input type="text" name="amount_outage#currentrow#" onchange="find_amount2_outage(#currentrow#);" id="amount_outage#currentrow#" value="#TlFormat((sarf_kalan_uretim_emri),round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,0);aktar();" class="moneybox" style="width:70px;">
												<input type="hidden" name="amount_outage_#currentrow#" id="amount_outage_#currentrow#" value="#TlFormat((sarf_kalan_uretim_emri),round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,0);aktar();" class="moneybox" style="width:60px;">
											<cfelse>							   		
												<cfset sarf_kalan_uretim_emri_new = get_det_po.AMOUNT>
												<cfset maliyet_miktarı =_AMOUNT_>
												<input type="text" name="amount_outage#currentrow#" onchange="find_amount2_outage(#currentrow#);" id="amount_outage#currentrow#" value="#TlFormat(wrk_round(_AMOUNT_,round_number,1),round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,0);aktar();" class="moneybox" style="width:70px;" onClick="aktar();">
												<input type="hidden" name="amount_outage_#currentrow#" id="amount_outage_#currentrow#" value="#TlFormat(wrk_round(_AMOUNT_,round_number,1),round_number)#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,0);aktar();" class="moneybox" style="width:60px;" onClick="aktar();">
											</cfif>							   	
																			
										</td>
										<td>
											<input type="hidden" name="unit_id_outage#currentrow#" id="unit_id_outage#currentrow#" value="#product_unit_id#">
											<input type="hidden" name="serial_no_outage#currentrow#" id="serial_no_outage#currentrow#" value="">
											<input type="text" name="unit_outage#currentrow#" id="unit_outage#currentrow#" value="#main_unit#" readonly style="width:60px;">
										</td>
										<td>
											<div class="form-group">
												<input type="text" onchange="find_amount2_outage(#currentrow#);Get_Product_Unit_2_And_Quantity_2_outage(#currentrow#);" name="weight_outage#currentrow#" id="weight_outage#currentrow#" >
											</div>
										</td>
										<cfif x_is_show_abh eq 1>
											<td>
												<div class="form-group">
													<input type="text" name="width_outage#currentrow#" onchange="Get_Product_Unit_2_And_Quantity_2_outage(#currentrow#)" id="width_outage#currentrow#" style="width:60px;">
												</div>
											</td>
											<td>
												<div class="form-group">
													<input type="text"  name="height_outage#currentrow#" onchange="Get_Product_Unit_2_And_Quantity_2_outage(#currentrow#)" id="height_outage#currentrow#" style="width:60px;">
												</div>
											</td>
											<td>
												<div class="form-group">
													<input type="text" name="length_outage#currentrow#" onchange="Get_Product_Unit_2_And_Quantity_2_outage(#currentrow#)" id="length_outage#currentrow#" style="width:60px;">
												</div>
											</td>
										</cfif>
										<cfif xml_specific_weight eq 1> 
											<td>
												<div class="form-group">
													<input type="text" onchange="find_weight_outage(#currentrow#)" name="specific_weight_outage#currentrow#" id="specific_weight_outage#currentrow#" style="width:60px;">
												</div>
											</td>
										 </cfif>
										<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
											<td><input type="text" name="cost_price_outage#currentrow#" id="cost_price_outage#currentrow#" value="#TLFormat(cost_price,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost(#currentrow#,3);"</cfif>></td>
											<td>
												<input type="hidden" name="cost_price_system_outage#currentrow#" id="cost_price_system_outage#currentrow#" value="#cost_price_system#">
												<input type="hidden" name="purchase_extra_cost_system_outage#currentrow#" id="purchase_extra_cost_system_outage#currentrow#" value="#wrk_round(purchase_extra_cost_system,8,1)#">
												<input type="hidden" name="money_system_outage#currentrow#" id="money_system_outage#currentrow#" value="#cost_price_system_money#">
												<input type="text" name="purchase_extra_cost_outage#currentrow#" id="purchase_extra_cost_outage#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST,8,1),8,0)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost(#currentrow#,3);"</cfif>>
											</td>
											<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
												<td><input type="text" name="total_cost_price_outage#currentrow#" id="total_cost_price_outage#currentrow#" value="#TLFormat((cost_price+purchase_extra_cost)*maliyet_miktarı,round_number)#" readonly class="moneybox"></td>
											</cfif>
											<td><input type="text" name="money_outage#currentrow#" id="money_outage#currentrow#" value="#cost_price_money#" readonly style="width:50px;"></td>
											<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
												<td><input type="text" name="cost_price_outage_2#currentrow#" id="cost_price_outage_2#currentrow#" value="#TLFormat(cost_price_2,round_number)#" class="moneybox" readonly></td>
												<td><input type="text" name="purchase_extra_cost_outage_2#currentrow#" id="purchase_extra_cost_outage_2#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,8,1),8,0)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly</cfif>></td>
												<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
													<td><input type="text" name="total_cost_price_outage_2#currentrow#" id="total_cost_price_outage_2#currentrow#" value="#TLFormat((cost_price_2+wrk_round(purchase_extra_cost_system_2,8,1))*maliyet_miktarı,round_number)#" class="moneybox" readonly></td>
												</cfif>
												<td><input type="text" name="money_outage_2#currentrow#" id="money_outage_2#currentrow#" value="#cost_price_money_2#" readonly style="width:50px;"></td>
											<cfelse>
												<input type="hidden" name="cost_price_outage_2#currentrow#" id="cost_price_outage_2#currentrow#" value="#TLFormat(cost_price_2,round_number)#">
												<input type="hidden" name="purchase_extra_cost_outage_2#currentrow#" id="purchase_extra_cost_outage_2#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,8,1),8,0)#">
												<input type="hidden" name="money_outage_2#currentrow#" id="money_outage_2#currentrow#" value="#cost_price_money_2#">
											</cfif>
										<cfelse>
											<input type="hidden" name="cost_price_system_outage#currentrow#" id="cost_price_system_outage#currentrow#" value="#cost_price_system#">
											<input type="hidden" name="purchase_extra_cost_system_outage#currentrow#" id="purchase_extra_cost_system_outage#currentrow#" value="#wrk_round(purchase_extra_cost_system,8,1)#">
											<input type="hidden" name="cost_price_outage#currentrow#" id="cost_price_outage#currentrow#" value="#TLFormat(cost_price,round_number)#">
											<input type="hidden" name="total_cost_price_outage#currentrow#" id="total_cost_price_outage#currentrow#" value="#TLFormat((cost_price+purchase_extra_cost)*maliyet_miktarı,round_number)#">
											<input type="hidden" name="money_outage#currentrow#" id="money_outage#currentrow#" value="#cost_price_money#">
											<input type="hidden" name="money_system_outage#currentrow#" id="money_system_outage#currentrow#" value="#cost_price_system_money#">
											<input type="hidden" name="purchase_extra_cost_outage#currentrow#" id="purchase_extra_cost_outage#currentrow#" value="#TLFormat(purchase_extra_cost,round_number)#" />
											<input type="hidden" name="cost_price_outage_2#currentrow#" id="cost_price_outage_2#currentrow#" value="#TLFormat(cost_price_2,round_number)#">
											<input type="hidden" name="total_cost_price_outage_2#currentrow#" id="total_cost_price_outage_2#currentrow#" value="#TLFormat((cost_price_2+wrk_round(purchase_extra_cost_system_2,8,1))*maliyet_miktarı,round_number)#">
											<input type="hidden" name="purchase_extra_cost_outage_2#currentrow#" id="purchase_extra_cost_outage_2#currentrow#" value="#TLFormat(wrk_round(purchase_extra_cost_system_2,8,1),round_number)#">
											<input type="hidden" name="money_outage_2#currentrow#" id="money_outage_2#currentrow#" value="#cost_price_money_2#">
										</cfif>
										<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
										<td><input type="text" name="amount_outage2_#currentrow#" id="amount_outage2_#currentrow#" onchange="Get_Product_Unit_2_And_Quantity_2_outage(#currentrow#)" value="" onKeyup="return(FormatCurrency(this,event,8));" onBlur="" class="moneybox" style="width:70px;"></td>
										<td>
											<cfquery name="get_all_unit2" datasource="#dsn3#">
												SELECT 
													PRODUCT_UNIT_ID,ADD_UNIT
												FROM 
													PRODUCT_UNIT 
												WHERE
													PRODUCT_ID = #PRODUCT_ID#
													AND PRODUCT_UNIT_STATUS = 1
													AND IS_MAIN = 0
											</cfquery>
											<select name="unit2_outage#currentrow#" id="unit2_outage#currentrow#" style="width:50;">
											<cfloop query="get_all_unit2">
												<option value="#ADD_UNIT#">#ADD_UNIT#</option>
											</cfloop>
											</select>
										</td>
										</cfif>
										<td style="display:#product_name2_display#"><input type="text" style="width:70px;" name="product_name2_outage#currentrow#" id="product_name2_outage#currentrow#" value=""></td>
										<td <cfif isdefined('x_is_show_mc') and x_is_show_mc eq 0> style="display:none;" </cfif>>
											<input type="checkbox" name="is_manual_cost_outage#currentrow#" id="is_manual_cost_outage#currentrow#" value="1" <cfif is_manual_cost eq 1>checked</cfif>>
										</td>
									</tr>
									<cfif get_det_po.is_demontaj eq 1>
										<cfscript>
										if(len(GET_PRODUCT_FIRE.PURCHASE_NET_SYSTEM))
											demontaj_cost_price_system = demontaj_cost_price_system+GET_PRODUCT_FIRE.PURCHASE_NET_SYSTEM*fire_kalan_uretim_miktari_new;
										if(len(GET_PRODUCT_FIRE.PURCHASE_NET_SYSTEM_2))
											demontaj_cost_price_system_2 = demontaj_cost_price_system_2+GET_PRODUCT_FIRE.PURCHASE_NET_SYSTEM_2*fire_kalan_uretim_miktari_new;
										if(len(GET_PRODUCT_FIRE.PURCHASE_EXTRA_COST_SYSTEM))
											demontaj_purchase_extra_cost_system =demontaj_purchase_extra_cost_system+GET_PRODUCT_FIRE.PURCHASE_EXTRA_COST_SYSTEM*fire_kalan_uretim_miktari_new;
										</cfscript>
									</cfif>
							</cfoutput>
								<input type="hidden" name="fire_recordcount" id="fire_recordcount" value="<cfoutput>#GET_SUB_PRODUCTS_FIRE.recordcount#</cfoutput>">
							</cfif>	
						</cfif>
					</tbody>
				</cf_grid_list>
				<cfif GET_SUB_PRODUCTS_FIRE.recordcount>
					<div class="ui-info-bottom flex-end">
						<div><a href="javascript://" onclick="sil_outage_all();" class="ui-wrk-btn ui-wrk-btn-success"><cf_get_lang dictionary_id="30036.hepsini sil"></a></div>
					</div>
				</cfif>
		</cf_box>
	</div>
 </cfform>	
<script type="text/javascript">
	$(document).ready(function(){
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=prod.popup_add_production_result&is_show_product_name2=#is_show_product_name2#&iframe=1&spec_name_display=#Evaluate('spec_name_display')#&spec_display=#Evaluate('spec_display')#</cfoutput>&type=outage','add_prod3',1);
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=prod.popup_add_production_result&is_show_product_name2=#is_show_product_name2#&iframe=1&spec_name_display=#Evaluate('spec_name_display')#&spec_display=#Evaluate('spec_display')#</cfoutput>&type=exit','add_prod2',1);
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=prod.popup_add_production_result&iframe=1</cfoutput>','add_prod1',1);
	});
	row_count = <cfoutput>#sonuc_recordcount#</cfoutput>;
	row_count_exit = <cfoutput>#deger_value_row#</cfoutput>;
	round_number = <cfoutput>#round_number#</cfoutput>;//xmlden geliyor. miktar kusuratlarini burdan aliyor
	<cfif get_det_po.is_demontaj eq 1>//demontaj ise ve spectli üründen fire geliyorsa 0 olarak kabul et,fire'ye demontaj yapılmaz.
		row_count_outage = 0;
	<cfelse>
		row_count_outage = <cfif isdefined('deger_value_row_fire')><cfoutput>#deger_value_row_fire#</cfoutput><cfelse>0</cfif>;
	</cfif>
	function change_row_cost(row_no,type)
	{
		if(type == 2)
		{
			new_cost = filterNum(document.getElementById("cost_price_exit"+row_no).value,round_number);
			extra_new_cost = filterNum(document.getElementById("purchase_extra_cost_exit"+row_no).value,round_number);
			new_money = document.getElementById("money_exit"+row_no).value;
			amount = document.getElementById("amount_exit"+row_no).value;
			kontrol_money = 0;
			for(s=1;s<=document.getElementById("kur_say").value;s++)
			{
				if(document.getElementById("hidden_rd_money_"+s).value == new_money)
				{
					rate1 = filterNum(document.getElementById("txt_rate1_"+s).value);
					rate2 = filterNum(document.getElementById("txt_rate2_"+s).value);
					kontrol_money = 1;
				}
			}
			if(kontrol_money==0){rate1=1;rate2=1;}
			document.getElementById("cost_price_system_exit"+row_no).value = parseFloat(new_cost)*parseFloat(rate2);
			document.getElementById("purchase_extra_cost_system_exit"+row_no).value = parseFloat(extra_new_cost)*parseFloat(rate2);
			total_cost = (parseFloat(new_cost)+parseFloat(extra_new_cost))*parseFloat(filterNum(amount,round_number),round_number);
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
				document.getElementById("total_cost_price_exit"+row_no).value = commaSplit(total_cost,round_number);
			</cfif>
		}
		else if (type == 3)
		{
			new_cost = filterNum(document.getElementById("cost_price_outage"+row_no).value,round_number);
			extra_new_cost = filterNum(document.getElementById("purchase_extra_cost_outage"+row_no).value,round_number);
			new_money = document.getElementById("money_outage"+row_no).value;
			amount = document.getElementById("amount_outage"+row_no).value;
			kontrol_money = 0;
			for(s=1;s<=document.getElementById("kur_say").value;s++)
			{
				if(document.getElementById("hidden_rd_money_"+s).value == new_money)
				{
					rate1 = filterNum(document.getElementById("txt_rate1_"+s).value);
					rate2 = filterNum(document.getElementById("txt_rate2_"+s).value);
					kontrol_money = 1;
				}
			}
			if(kontrol_money==0){rate1=1;rate2=1;}
			document.getElementById("cost_price_system_outage"+row_no).value = parseFloat(new_cost)*parseFloat(rate2);
			document.getElementById("purchase_extra_cost_system_outage"+row_no).value = parseFloat(extra_new_cost)*parseFloat(rate2);
			total_cost = (parseFloat(new_cost)+parseFloat(extra_new_cost))*parseFloat(filterNum(amount,round_number),round_number);
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
				document.getElementById("total_cost_price_outage"+row_no).value = commaSplit(total_cost,round_number);
			</cfif>	
		}
		else if(type == 1)
		{
			row_no = 1;
			for (var row_no=1;row_no<=row_count_exit;row_no++)//sarflarin satirdaki maliyetlerini gunceliiyor
			{
				if(document.getElementById("row_kontrol_exit"+row_no).value==1)// sarf ürün satırı olması için kontrol eklendi.
				{
					new_cost = filterNum(document.getElementById("cost_price_exit"+row_no).value,round_number);
					extra_new_cost = filterNum(document.getElementById("purchase_extra_cost_exit"+row_no).value,round_number);
					new_money = document.getElementById("money_exit"+row_no).value;
					amount = document.getElementById("amount_exit"+row_no).value;
					kontrol_money = 0;
					for(s=1;s<=document.getElementById("kur_say").value;s++)
					{
						if(document.getElementById("hidden_rd_money_"+s).value == new_money)
						{
							rate1 = filterNum(document.getElementById("txt_rate1_"+s).value);
							rate2 = filterNum(document.getElementById("txt_rate2_"+s).value);
							kontrol_money = 1;
						}
					}
					if(kontrol_money==0){rate1=1;rate2=1;}
					document.getElementById("cost_price_system_exit"+row_no).value = parseFloat(new_cost)*parseFloat(rate2);
					document.getElementById("purchase_extra_cost_system_exit"+row_no).value = parseFloat(extra_new_cost)*parseFloat(rate2);
					total_cost = (parseFloat(new_cost)+parseFloat(extra_new_cost))*parseFloat(filterNum(amount,round_number),round_number);
					<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
						document.getElementById("total_cost_price_exit"+row_no).value = commaSplit(total_cost,round_number);
					</cfif>
				}
			}
			for (var row_no=1;row_no<=row_count_outage;row_no++)//firelerin satirdaki maliyetlerini gunceliiyor
			{
				if(document.getElementById("row_kontrol_outage"+row_no).value==1)// fire ürün satırı olması için kontrol eklendi.
				{
					new_cost = filterNum(document.getElementById("cost_price_outage"+row_no).value,round_number);
					extra_new_cost = filterNum(document.getElementById("purchase_extra_cost_outage"+row_no).value,round_number);
					new_money = document.getElementById("money_outage"+row_no).value;
					amount = document.getElementById("amount_outage"+row_no).value;
					kontrol_money = 0;
					for(s=1;s<=document.getElementById("kur_say").value;s++)
					{
						if(document.getElementById("hidden_rd_money_"+s).value == new_money)
						{
							rate1 = filterNum(document.getElementById("txt_rate1_"+s).value);
							rate2 = filterNum(document.getElementById("txt_rate2_"+s).value);
							kontrol_money = 1;
						}
					}
					if(kontrol_money==0){rate1=1;rate2=1;}
					document.getElementById("cost_price_system_outage"+row_no).value = parseFloat(new_cost)*parseFloat(rate2);
					document.getElementById("purchase_extra_cost_system_outage"+row_no).value = parseFloat(extra_new_cost)*parseFloat(rate2);
					total_cost = (parseFloat(new_cost)+parseFloat(extra_new_cost))*parseFloat(filterNum(amount,round_number),round_number);
					<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
					document.getElementById("total_cost_price_outage"+row_no).value = commaSplit(total_cost,round_number);
					</cfif>
				}
			}
		}
	}
	function sil(sy)
	{
		var my_element=document.getElementById("row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	function sil_exit(sy)
	{
		var my_element=document.getElementById("row_kontrol_exit"+sy);
		my_element.value=0;
		var my_element=eval("frm_row_exit"+sy);
		my_element.style.display="none";
	}
	function sil_exit_all()
	{
		for(i=1;i<=<cfoutput>#deger_value_row#</cfoutput>;i++)
		{
				document.getElementById('frm_row_exit' + i).style.display="none";
				//my_element.parentNode.removeChild(my_element);
				document.getElementById("row_kontrol_exit"+i).value = 0;
		}
	}
	function sil_outage(sy)
	{
		var my_element=document.getElementById("row_kontrol_outage"+sy);
		my_element.value=0;
		var my_element=eval("frm_row_outage"+sy);
		my_element.style.display="none";
	}
	function sil_outage_all(sy)
	{
		for(i=1;i<=<cfoutput>#deger_value_row#</cfoutput>;i++)
		{
				document.getElementById('frm_row_outage' + i).style.display="none";
				document.getElementById("row_kontrol_outage"+i).value = 0;
		}
	}
	function add_row(stock_id,product_id,stock_code,product_name,property,barcode,main_unit,product_unit_id,amount,tax,cost_id,cost_price,cost_price_money,cost_price_2,purchase_extra_cost_2,cost_price_money_2,cost_price_system,cost_price_system_money,purchase_extra_cost,purchase_extra_cost_system,product_cost,product_cost_money,serial,is_production,dimention,spect_main_id,spect_name)
	{ 
		row_count++;
		var newRow;
		var newCell;
		
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		document.getElementById("record_num").value = row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign="center";
		newCell.innerHTML = '<input type="hidden" name="is_production_spect' + row_count +'" id="is_production_spect' + row_count +'" value="'+ is_production +'"><input type="hidden" name="tree_type_' + row_count +'" id="tree_type_' + row_count +'" value="S"><input type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><img src="images/delete_list.gif" border="0" align="absmiddle" alt="Sil"></a><input type="hidden" name="cost_id' + row_count +'" id="cost_id' + row_count +'" value="'+cost_id+'"><input type="hidden" name="product_cost' + row_count +'" id="product_cost' + row_count +'" value="'+product_cost+'"><input type="hidden" name="product_cost_money' + row_count +'" id="product_cost_money' + row_count +'" value="'+product_cost_money+'"><input type="hidden" name="cost_price_system' + row_count +'" id="cost_price_system' + row_count +'" value="'+cost_price_system+'"><input type="hidden" name="money_system' + row_count +'" value="'+cost_price_system_money+'"><input type="hidden" name="purchase_extra_cost' + row_count +'" id="purchase_extra_cost' + row_count +'" value="'+purchase_extra_cost+'"><input type="hidden" name="purchase_extra_cost_system' + row_count +'" id="purchase_extra_cost_system' + row_count +'" value="'+purchase_extra_cost_system+'">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="stock_code' + row_count +'" id="stock_code' + row_count +'" value="'+stock_code+'" readonly style="width:120px;"><input type="hidden" name="kdv_amount' + row_count +'" id="kdv_amount' + row_count +'" value="'+tax+'">';
		<cfif x_is_barkod_col eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="barcode' + row_count +'" id="barcode' + row_count +'" value="'+barcode+'" readonly style="width:90px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'" value="'+product_id+'"><input type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'" value="'+stock_id+'"><input type="text" name="product_name' + row_count +'" id="product_name' + row_count +'" value="'+ product_name + property +'" readonly style="width:230px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.display = "<cfoutput>#spec_img_display#</cfoutput>";
		newCell.innerHTML = '<input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spec_main_id' + row_count +'" id="spec_main_id' + row_count +'" value="'+spect_main_id+'" readonly style="width:40px;"> <input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spect_id' + row_count +'" id="spect_id' + row_count +'" value="" readonly style="width:40px;"> <input type="<cfoutput>#Evaluate('spec_name_display')#</cfoutput>" name="spect_name' + row_count +'" id="spect_name' + row_count +'" value="'+spect_name+'" readonly style="width:150px;"> <img src="/images/plus_thin.gif" onClick="pencere_ac_spect('+ row_count +');" align="absbottom" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount' + row_count +'" id="amount' + row_count +'" value="'+commaSplit(amount,round_number)+'" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(' + row_count +',0);" class="moneybox" style="width:70px;">';//commaSplit(filterNum(amount,8),8)
		<cfif isdefined("x_is_fire_product") and x_is_fire_product eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="fire_amount_' + row_count +'" id="fire_amount_' + row_count +'" value="0" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(' + row_count +',1);" class="moneybox" style="width:60px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="unit_id' + row_count +'" id="unit_id' + row_count +'" value="'+product_unit_id+'"><input type="text" name="unit' + row_count +'" id="unit' + row_count +'" value="'+main_unit+'" readonly style="width:60px;"><input type="hidden" name="serial_no' + row_count +'" id="serial_no' + row_count +'" value="'+serial+'">';
		<cfif isdefined('x_is_show_abh') and x_is_show_abh eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="dimention' + row_count +'" id="dimention' + row_count +'" value="'+dimention+'" readonly style="width:60px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="cost_price' + row_count +'" id="cost_price' + row_count +'" value="'+cost_price+'" style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
		<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="total_cost_price' + row_count +'" id="total_cost_price' + row_count +'" value="'+commaSplit(filterNum(cost_price,round_number) * filterNum(amount,round_number),round_number)+'" style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="money' + row_count +'" id="money' + row_count +'" value="'+cost_price_money+'" readonly style="width:50px;">';
		<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="cost_price_2' + row_count +'" id="cost_price_2' + row_count +'" value="'+cost_price_2+'" style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="total_cost_price_2' + row_count +'" id="total_cost_price_2' + row_count +'" value="'+commaSplit(filterNum(cost_price_2,round_number) * filterNum(amount,round_number),round_number)+'" readonly style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="money_2' + row_count +'" id="money_2' + row_count +'" value="'+cost_price_money_2+'" readonly style="width:50px;">';
		</cfif>
		<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="amount2_' + row_count +'" id="amount2_' + row_count +'" value="" onKeyup="return(FormatCurrency(this,event,8));" onBlur="" class="moneybox" style="width:70px;">';
			//2.birim ekleme
			var get_Unit2_Prod = wrk_safe_query('prdp_get_unit2_prod','dsn3',0,product_id);
			var unit2_values ='<select name="unit2'+row_count+'" id="unit2'+row_count+'" style="width:60;">';
			if(get_Unit2_Prod.recordcount){
			for(xx=0;xx<get_Unit2_Prod.recordcount;xx++)
				unit2_values += '<option value="'+get_Unit2_Prod.ADD_UNIT[xx]+'">'+get_Unit2_Prod.ADD_UNIT[xx]+'</option>';
			}
			unit2_values +='</select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = ''+unit2_values+'';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.display = "<cfoutput>#product_name2_display#</cfoutput>";
		newCell.innerHTML = '<input type="text" style="width:70px;" name="product_name2' + row_count +'" id="product_name2' + row_count +'" value="">';
		//2.birim ekleme bitti.
	}
	row_count_exit = <cfoutput>#deger_value_row#</cfoutput>;
	satir_sarf = document.getElementById("table2").rows.length;
	function add_row_exit(stock_id,product_id,stock_code,product_name,property,barcode,main_unit,product_unit_id,amount,tax,cost_id,cost_price,cost_price_money,cost_price_2,purchase_extra_cost_exit_2,cost_price_money_2,cost_price_system,cost_price_system_money,purchase_extra_cost,purchase_extra_cost_system,product_cost,product_cost_money,serial,is_production,dimention,spect_main_id,spect_name,expiration_date_exit)
	{
		row_count_exit++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table2_body").insertRow(document.getElementById("table2_body").rows.length);
		newRow.setAttribute("name","frm_row_exit" + row_count_exit);
		newRow.setAttribute("id","frm_row_exit" + row_count_exit);
		newRow.setAttribute("NAME","frm_row_exit" + row_count_exit);
		newRow.setAttribute("ID","frm_row_exit" + row_count_exit);
		document.getElementById("record_num_exit").value = row_count_exit;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign="center";
		newCell.innerHTML = '<input type="hidden" name="is_production_spect_exit' + row_count_exit +'" id="is_production_spect_exit' + row_count_exit +'" value="'+ is_production +'"><input type="hidden" name="is_add_info_' + row_count_exit +'" id="is_add_info_' + row_count_exit +'" value="1"><input type="hidden" name="tree_type_exit_' + row_count_exit +'" id="tree_type_exit_' + row_count_exit +'" value="S"><input type="hidden" name="row_kontrol_exit' + row_count_exit +'" id="row_kontrol_exit' + row_count_exit +'" value="1"><a style="cursor:pointer" onclick="copy_row_exit('+row_count_exit+');" title="<cf_get_lang dictionary_id="1560.Satır Kopyala">"><img  src="images/copy_list.gif" border="0"></a> <a style="cursor:pointer" onclick="sil_exit(' + row_count_exit + ');"><img src="images/delete_list.gif" border="0" align="absmiddle" alt="Sil"></a><input type="hidden" name="cost_id_exit' + row_count_exit +'" id="cost_id_exit' + row_count_exit +'" value="'+cost_id+'"><input type="hidden" name="product_cost_exit' + row_count_exit +'" id="product_cost_exit' + row_count_exit +'" value="'+product_cost+'"><input type="hidden" name="product_cost_money_exit' + row_count_exit +'" id="product_cost_money_exit' + row_count_exit +'" value="'+product_cost_money+'"><input type="hidden" name="cost_price_system_exit' + row_count_exit +'" id="cost_price_system_exit' + row_count_exit +'" value="'+cost_price_system+'"><input type="hidden" name="money_system_exit' + row_count_exit +'" id="money_system_exit' + row_count_exit +'" value="'+cost_price_system_money+'"><input type="hidden" name="purchase_extra_cost_system_exit' + row_count_exit +'" id="purchase_extra_cost_system_exit' + row_count_exit +'" value="'+purchase_extra_cost_system+'"><input type="hidden" name="amount_exit_' + row_count_exit +'" id="amount_exit_' + row_count_exit +'" value="'+commaSplit(filterNum(amount,round_number),round_number)+'">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="stock_code_exit' + row_count_exit +'" id="stock_code_exit' + row_count_exit +'" value="'+stock_code+'" readonly style="width:120px;"><input type="hidden" name="kdv_amount_exit' + row_count_exit +'" id="kdv_amount_exit' + row_count_exit +'" value="'+tax+'">';
		<cfif x_is_barkod_col eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="barcode_exit' + row_count_exit +'" id="barcode_exit' + row_count_exit +'" value="'+barcode+'" readonly style="width:90px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="product_id_exit' + row_count_exit +'" id="product_id_exit' + row_count_exit +'" value="'+product_id+'"><input type="hidden" name="stock_id_exit' + row_count_exit +'" id="stock_id_exit' + row_count_exit +'" value="'+stock_id+'"><input type="text" name="product_name_exit' + row_count_exit +'" id="product_name_exit' + row_count_exit +'"value="'+ product_name + property +'" readonly style="width:230px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.display = "<cfoutput>#spec_img_display#</cfoutput>";
		newCell.innerHTML = ' <input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spec_main_id_exit' + row_count_exit +'" id="spec_main_id_exit' + row_count_exit +'" value="'+spect_main_id+'"readonly style="width:40px;"> <input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spect_id_exit' + row_count_exit +'" id="spect_id_exit' + row_count_exit +'" value="" style="width:40px;"> <input type="<cfoutput>#Evaluate('spec_name_display')#</cfoutput>" name="spect_name_exit' + row_count_exit +'" id="spect_name_exit' + row_count_exit +'" value="'+spect_name+'" readonly style="width:150px;"> <img src="/images/plus_thin.gif" onClick="pencere_ac_spect('+ row_count_exit +',2);" align="absbottom" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="lot_no_exit' + row_count_exit +'" id="lot_no_exit' + row_count_exit +'" value="" onKeyup="lotno_control('+ row_count_exit +',2);" style="width:75px;"> <img src="/images/plus_thin.gif" onClick="pencere_ac_list_product('+ row_count_exit +',2);" align="absbottom" border="0">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","expiration_date_exit" + row_count_exit + "_td");
		newCell.innerHTML = '<input type="text" name="expiration_date_exit' + row_count_exit +'" id="expiration_date_exit' + row_count_exit +'" value=""  style="width:70px;"> ';
		wrk_date_image('expiration_date_exit' + row_count_exit);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount_exit' + row_count_exit +'" id="amount_exit' + row_count_exit +'" value="'+commaSplit(filterNum(amount,round_number),round_number)+'" onKeyup="return(FormatCurrency(this,event,8));" onBlur="(' + row_count_exit +',1);" class="moneybox" style="width:70px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="unit_id_exit' + row_count_exit +'" id="unit_id_exit' + row_count_exit +'" value="'+product_unit_id+'"><input type="text" name="unit_exit' + row_count_exit +'" id="unit_exit' + row_count_exit +'" value="'+main_unit+'" readonly style="width:60px;"><input type="hidden" name="serial_no_exit' + row_count_exit +'" id="serial_no_exit' + row_count_exit +'" value="'+serial+'">';
		<cfif isdefined('x_is_show_abh') and x_is_show_abh eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="dimention_exit' + row_count_exit +'" id="dimention_exit' + row_count_exit +'" value="'+dimention+'" readonly style="width:60px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="cost_price_exit' + row_count_exit +'" id="cost_price_exit' + row_count_exit +'" value="'+cost_price+'" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_exit+',2);"</cfif>>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="purchase_extra_cost_exit' + row_count_exit +'" id="purchase_extra_cost_exit' + row_count_exit +'" value="'+purchase_extra_cost+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_exit+',2);"</cfif> class="moneybox">';
		<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="total_cost_price_exit' + row_count_exit +'" id="total_cost_price_exit' + row_count_exit +'" value="'+commaSplit((parseFloat(filterNum(cost_price,round_number))+parseFloat(filterNum(purchase_extra_cost,round_number)))*filterNum(amount,round_number),round_number)+'" readonly class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="money_exit' + row_count_exit +'" id="money_exit' + row_count_exit +'" value="'+cost_price_money+'" readonly style="width:50px;">';
		<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="cost_price_exit_2' + row_count_exit +'" id="cost_price_exit_2' + row_count_exit +'" value="'+cost_price_2+'" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));"  <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_exit+',2);"</cfif>>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="purchase_extra_cost_exit_2' + row_count_exit +'" id="purchase_extra_cost_exit_2' + row_count_exit +'" value="'+purchase_extra_cost_exit_2+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));"  <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_exit+',2);"</cfif> class="moneybox">';
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="total_cost_price_exit_2' + row_count_exit +'" id="total_cost_price_exit_2' + row_count_exit +'" value="'+commaSplit((parseFloat(filterNum(cost_price_2,round_number))+parseFloat(filterNum(purchase_extra_cost_exit_2,round_number)))*filterNum(amount,round_number),round_number)+'" readonly class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="money_exit_2' + row_count_exit +'" id="money_exit_2' + row_count_exit +'" value="'+cost_price_money_2+'" readonly style="width:50px;">';
		</cfif>
		<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount_exit2_' + row_count_exit +'" id="amount_exit2_' + row_count_exit +'" value="" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));" onBlur="" class="moneybox" style="width:70px;">';
		//2.birim ekleme
		var get_Unit2_Prod = wrk_safe_query('prdp_get_unit2_prod','dsn3',0,product_id)
		var unit2_values ='<select name="unit2_exit'+row_count_exit+'" id="unit2_exit'+row_count_exit+'" style="width:60;">';
		if(get_Unit2_Prod.recordcount){
		for(xx=0;xx<get_Unit2_Prod.recordcount;xx++)
			unit2_values += '<option value="'+get_Unit2_Prod.ADD_UNIT[xx]+'">'+get_Unit2_Prod.ADD_UNIT[xx]+'</option>';
		}
		unit2_values +='</select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = ''+unit2_values+'';
		//2.birim ekleme bitti.
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.display = "<cfoutput>#product_name2_display#</cfoutput>";
		newCell.innerHTML = '<input type="text" style="width:70px;" name="product_name2_exit' + row_count +'" id="product_name2_exit' + row_count +'" value="">';
		<cfif isdefined("x_is_show_sb") and x_is_show_sb>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="checkbox" name="is_sevkiyat' + row_count_exit +'" id="is_sevkiyat' + row_count_exit +'" value="1">';
		</cfif>
		<cfif isdefined('x_is_show_mc') and x_is_show_mc eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="checkbox" name="is_manual_cost_exit' + row_count_exit +'" id="is_manual_cost_exit' + row_count_exit +'" value="1">';
		</cfif>
	}
	
	function add_row_outage(stock_id,product_id,stock_code,product_name,property,barcode,main_unit,product_unit_id,amount,tax,cost_id,cost_price,cost_price_money,cost_price_2,purchase_extra_cost_2,cost_price_money_2,cost_price_system,cost_price_system_money,purchase_extra_cost,purchase_extra_cost_system,product_cost,product_cost_money,serial,is_production,dimention,spect_main_id,spect_name,expiration_date_outage)
	{
		row_count_outage++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table3_body").insertRow(document.getElementById("table3_body").rows.length);
		newRow.setAttribute("name","frm_row_outage" + row_count_outage);
		newRow.setAttribute("id","frm_row_outage" + row_count_outage);
		newRow.setAttribute("NAME","frm_row_outage" + row_count_outage);
		newRow.setAttribute("ID","frm_row_outage" + row_count_outage);
		document.getElementById("record_num_outage").value = row_count_outage;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign="center";
		newCell.innerHTML = '<input type="hidden" name="row_kontrol_outage' + row_count_outage +'" id="row_kontrol_outage' + row_count_outage +'" value="1"><a style="cursor:pointer" onclick="copy_row_outage('+row_count_exit+');" title="<cf_get_lang dictionary_id="1560.Satır Kopyala">"><img  src="images/copy_list.gif" border="0"></a> <a style="cursor:pointer" onclick="sil_outage(' + row_count_outage + ');"><img src="images/delete_list.gif" border="0" align="absmiddle" alt="Sil"></a><input type="hidden" name="cost_id_outage' + row_count_outage +'" id="cost_id_outage' + row_count_outage +'" value="'+cost_id+'"><input type="hidden" name="product_cost_outage' + row_count_outage +'" id="product_cost_outage' + row_count_outage +'" value="'+product_cost+'"><input type="hidden" name="product_cost_money_outage' + row_count_outage +'" id="product_cost_money_outage' + row_count_outage +'" value="'+product_cost_money+'"><input type="hidden" name="cost_price_system_outage' + row_count_outage +'" id="cost_price_system_outage' + row_count_outage +'" value="'+cost_price_system+'"><input type="hidden" name="money_system_outage' + row_count_outage +'" id="money_system_outage' + row_count_outage +'" value="'+cost_price_system_money+'"><input type="hidden" name="purchase_extra_cost_system_outage' + row_count_outage +'" id="purchase_extra_cost_system_outage' + row_count_outage +'" value="'+purchase_extra_cost_system+'">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="stock_code_outage' + row_count_outage +'" id="stock_code_outage' + row_count_outage +'" value="'+stock_code+'" readonly style="width:120px;"><input type="hidden" name="kdv_amount_outage' + row_count_outage +'" id="kdv_amount_outage' + row_count_outage +'" value="'+tax+'">';
		<cfif x_is_barkod_col eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="barcode_outage' + row_count_outage +'" id="barcode_outage' + row_count_outage +'" value="'+barcode+'" readonly style="width:90px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="product_id_outage' + row_count_outage +'" id="product_id_outage' + row_count_outage +'" value="'+product_id+'"><input type="hidden" name="stock_id_outage' + row_count_outage +'" id="stock_id_outage' + row_count_outage +'" value="'+stock_id+'"><input type="text" name="product_name_outage' + row_count_outage +'" id="product_name_outage' + row_count_outage +'" value="'+ product_name + property +'" readonly style="width:230px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.style.display = "<cfoutput>#spec_img_display#</cfoutput>";
		newCell.innerHTML = '<input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spec_main_id_outage' + row_count_outage +'" id="spec_main_id_outage' + row_count_outage +'" value="'+spect_main_id+'" readonly style="width:40px;"> <input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spect_id_outage' + row_count_outage +'" id="spect_id_outage' + row_count_outage +'" value="" style="width:40px;"> <input type="<cfoutput>#Evaluate('spec_name_display')#</cfoutput>" name="spect_name_outage' + row_count_outage +'" id="spect_name_outage' + row_count_outage +'" value="'+spect_name+'" readonly style="width:150px;"> <img src="/images/plus_thin.gif" onClick="pencere_ac_spect('+ row_count_outage +',3);" align="absbottom" border="0"></a>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="lot_no_outage' + row_count_outage +'" id="lot_no_outage' + row_count_outage +'" value="" onKeyup="lotno_control('+ row_count_outage +',3);" style="width:75px;"> <img src="/images/plus_thin.gif" onClick="pencere_ac_list_product('+ row_count_outage +',3);" align="absbottom" border="0"></a>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","expiration_date_outage" + row_count_outage + "_td");
		newCell.innerHTML = '<input type="text" name="expiration_date_outage' + row_count_outage +'" id="expiration_date_outage' + row_count_outage +'" value=""  style="width:70px;"> ';
		wrk_date_image('expiration_date_outage' + row_count_outage);

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount_outage' + row_count_outage +'" id="amount_outage' + row_count_outage +'" value="'+commaSplit(filterNum(amount,round_number),round_number)+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));" onBlur="hesapla_deger(' + row_count_outage +',2);" class="moneybox" style="width:70px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="unit_id_outage' + row_count_outage +'" id="unit_id_outage' + row_count_outage +'" value="'+product_unit_id+'"><input type="text" name="unit_outage' + row_count_outage +'" id="unit_outage' + row_count_outage +'" value="'+main_unit+'" readonly style="width:60px;"><input type="hidden" name="serial_no_outage' + row_count_outage +'" id="serial_no_outage' + row_count_outage +'" value="'+serial+'">';
		newCell = newRow.insertCell(newRow.cells.length);
		<cfif isdefined('x_is_show_abh') and x_is_show_abh eq 1>
			newCell.innerHTML = '<input type="text" name="dimention_outage' + row_count_outage +'" id="dimention_outage' + row_count_outage +'" value="'+dimention+'" readonly style="width:60px;">';
			newCell = newRow.insertCell(newRow.cells.length);
		</cfif>
		newCell.innerHTML = '<input type="text" name="cost_price_outage' + row_count_outage +'" id="cost_price_outage' + row_count_outage +'" value="'+cost_price+'" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_outage+',3);"</cfif> onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="purchase_extra_cost_outage' + row_count_outage +'" id="purchase_extra_cost_outage' + row_count_outage +'" value="'+purchase_extra_cost+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_outage+',3);"</cfif> class="moneybox">';
		<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="total_cost_price_outage' + row_count_outage +'" id="total_cost_price_outage' + row_count_outage +'" value="'+commaSplit((parseFloat(filterNum(cost_price,round_number))+parseFloat(filterNum(purchase_extra_cost,round_number)))*filterNum(amount,round_number),round_number)+'" readonly class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="money_outage' + row_count_outage +'" id="money_outage' + row_count_outage +'" value="'+cost_price_money+'" readonly style="width:50px;">';
		<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="cost_price_outage_2' + row_count_outage +'" id="cost_price_outage_2' + row_count_outage +'" value="'+cost_price_2+'" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="purchase_extra_cost_outage_2' + row_count_outage +'" id="purchase_extra_cost_outage_2' + row_count_outage +'" value="'+purchase_extra_cost_2+'"  <cfif is_change_sarf_cost eq 0>readonly</cfif> class="moneybox">';
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="total_cost_price_outage_2' + row_count_outage +'" id="total_cost_price_outage_2' + row_count_outage +'" value="'+commaSplit((parseFloat(filterNum(cost_price_2,round_number))+parseFloat(filterNum(purchase_extra_cost_2,round_number)))*filterNum(amount,round_number),round_number)+'" class="moneybox" readonly onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="money_outage_2' + row_count_outage +'" id="money_outage_2' + row_count_outage +'" value="'+cost_price_money_2+'" readonly style="width:50px;">';
		</cfif>
		<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount_outage2_' + row_count_outage +'" id="amount_outage2_' + row_count_outage +'" value="" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));" onBlur="" class="moneybox" style="width:70px;">';
		//2.birim ekleme
		var get_Unit2_Prod = wrk_safe_query('prdp_get_unit2_prod','dsn3',0,product_id)
		var unit2_values ='<select name="unit2_outage'+row_count_outage+'" id="unit2_outage'+row_count_outage+'" style="width:60;">';
		if(get_Unit2_Prod.recordcount){
		for(xx=0;xx<get_Unit2_Prod.recordcount;xx++)
			unit2_values += '<option value="'+get_Unit2_Prod.ADD_UNIT[xx]+'">'+get_Unit2_Prod.ADD_UNIT[xx]+'</option>';
		}
		unit2_values +='</select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = ''+unit2_values+'';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.display = "<cfoutput>#product_name2_display#</cfoutput>";
		newCell.innerHTML = '<input type="text" name="product_name2_outage' + row_count +'" id="product_name2_outage' + row_count +'" style="width:50px;" value="">';
		<cfif isdefined('x_is_show_mc') and x_is_show_mc eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="checkbox" name="is_manual_cost_outage' + row_count_outage +'" id="is_manual_cost_outage' + row_count_outage +'" value="1">';
		</cfif>
	}
		function copy_row_exit(no_info)
	{
		if (document.getElementById("is_production_spect_exit" + no_info) == undefined) is_production_spect_exit =""; else is_production_spect_exit = document.getElementById("is_production_spect_exit" + no_info).value;
		if (document.getElementById("is_add_info_" + no_info) == undefined) is_add_info_ =""; else is_add_info_ = document.getElementById("is_add_info_" + no_info).value;
		if (document.getElementById("product_cost_money_exit" + no_info) == undefined) product_cost_money_exit =""; else product_cost_money_exit = document.getElementById("product_cost_money_exit" + no_info).value;
		if (document.getElementById("stock_code_exit" + no_info) == undefined) stock_code_exit =""; else stock_code_exit = document.getElementById("stock_code_exit" + no_info).value;
		if (document.getElementById("barcode_exit" + no_info) == undefined) barcode_exit =""; else barcode_exit = document.getElementById("barcode_exit" + no_info).value;
		if (document.getElementById("product_id_exit" + no_info) == undefined) product_id_exit =""; else product_id_exit = document.getElementById("product_id_exit" + no_info).value;
		if (document.getElementById("spec_main_id_exit" + no_info) == undefined) spec_main_id_exit =""; else spec_main_id_exit = document.getElementById("spec_main_id_exit" + no_info).value;
		if (document.getElementById("lot_no_exit" + no_info) == undefined) lot_no_exit =""; else lot_no_exit = document.getElementById("lot_no_exit" + no_info).value;
		if (document.getElementById("amount_exit" + no_info) == undefined) amount_exit =""; else amount_exit = document.getElementById("amount_exit" + no_info).value;
		if (document.getElementById("unit_id_exit" + no_info) == undefined) unit_id_exit =""; else unit_id_exit = document.getElementById("unit_id_exit" + no_info).value;
		if (document.getElementById("dimention_exit" + no_info) == undefined) dimention_exit =""; else dimention_exit = document.getElementById("dimention_exit" + no_info).value;
		if (document.getElementById("cost_price_exit" + no_info) == undefined) cost_price_exit =""; else cost_price_exit = document.getElementById("cost_price_exit" + no_info).value;
		if (document.getElementById("purchase_extra_cost_exit" + no_info) == undefined) purchase_extra_cost_exit =""; else purchase_extra_cost_exit = document.getElementById("purchase_extra_cost_exit" + no_info).value;
		if (document.getElementById("total_cost_price_exit" + no_info) == undefined) total_cost_price_exit =""; else total_cost_price_exit = document.getElementById("total_cost_price_exit" + no_info).value;
		if (document.getElementById("money_exit" + no_info) == undefined) money_exit =""; else money_exit = document.getElementById("money_exit" + no_info).value;
		if (document.getElementById("cost_price_exit_2" + no_info) == undefined) cost_price_exit_2 =""; else cost_price_exit_2 = document.getElementById("cost_price_exit_2" + no_info).value;
		if (document.getElementById("total_cost_price_exit_2" + no_info) == undefined) total_cost_price_exit_2 =""; else total_cost_price_exit_2 = document.getElementById("total_cost_price_exit_2" + no_info).value;
		if (document.getElementById("money_exit_2" + no_info) == undefined) money_exit_2 =""; else money_exit_2 = document.getElementById("money_exit_2" + no_info).value;
		if (document.getElementById("amount_exit2_" + no_info) == undefined)  amount_exit2_ =""; else  amount_exit2_ = document.getElementById("amount_exit2_" + no_info).value;
		if (document.getElementById("product_name2_exit" + no_info) == undefined)  product_name2_exit =""; else  product_name2_exit = document.getElementById("product_name2_exit" + no_info).value;
		if (document.getElementById("is_sevkiyat" + no_info) == undefined) is_sevkiyat =""; else is_sevkiyat = document.getElementById("is_sevkiyat" + no_info).value;
		if (document.getElementById("is_manual_cost_exit" + no_info) == undefined) is_manual_cost_exit =""; else is_manual_cost_exit = document.getElementById("is_manual_cost_exit" + no_info).value;
		if (document.getElementById("tree_type_exit_" + no_info) == undefined) tree_type_exit_ =""; else tree_type_exit_ = document.getElementById("tree_type_exit_" + no_info).value;
		if (document.getElementById("row_kontrol_exit" + no_info) == undefined) row_kontrol_exit =""; else row_kontrol_exit = document.getElementById("row_kontrol_exit" + no_info).value;
		if (document.getElementById("cost_id_exit" + no_info) == undefined) cost_id_exit =""; else cost_id_exit = document.getElementById("cost_id_exit" + no_info).value;
		if (document.getElementById("product_cost_exit" + no_info) == undefined) product_cost_exit =""; else product_cost_exit = document.getElementById("product_cost_exit" + no_info).value;
		if (document.getElementById("cost_price_system_exit" + no_info) == undefined) cost_price_system_exit =""; else cost_price_system_exit = document.getElementById("cost_price_system_exit" + no_info).value;
		if (document.getElementById("money_system_exit" + no_info) == undefined) money_system_exit =""; else money_system_exit = document.getElementById("money_system_exit" + no_info).value;
		if (document.getElementById("purchase_extra_cost_system_exit" + no_info) == undefined) purchase_extra_cost_system_exit =""; else purchase_extra_cost_system_exit = document.getElementById("purchase_extra_cost_system_exit" + no_info).value;
		if (document.getElementById("purchase_extra_cost_exit_2" + no_info) == undefined) purchase_extra_cost_exit_2 =""; else purchase_extra_cost_exit_2 = document.getElementById("purchase_extra_cost_exit_2" + no_info).value;
		if (document.getElementById("amount_exit_" + no_info) == undefined) amount_exit_ =""; else amount_exit_ = document.getElementById("amount_exit_" + no_info).value;
		if (document.getElementById("kdv_amount_exit" + no_info) == undefined) kdv_amount_exit =""; else kdv_amount_exit = document.getElementById("kdv_amount_exit" + no_info).value;
		if (document.getElementById("stock_id_exit" + no_info) == undefined) stock_id_exit =""; else stock_id_exit = document.getElementById("stock_id_exit" + no_info).value;
		if (document.getElementById("product_name_exit" + no_info) == undefined) product_name_exit =""; else product_name_exit = document.getElementById("product_name_exit" + no_info).value;
		if (document.getElementById("spect_id_exit" + no_info) == undefined) spect_id_exit =""; else spect_id_exit = document.getElementById("spect_id_exit" + no_info).value;
		if (document.getElementById("spect_name_exit" + no_info) == undefined) spect_name_exit =""; else spect_name_exit = document.getElementById("spect_name_exit" + no_info).value;
		if (document.getElementById("unit_exit" + no_info) == undefined) unit_exit =""; else unit_exit = document.getElementById("unit_exit" + no_info).value;
		if (document.getElementById("serial_no_exit" + no_info) == undefined) serial_no_exit =""; else serial_no_exit = document.getElementById("serial_no_exit" + no_info).value;
		if (document.getElementById("expiration_date_exit" + no_info) == undefined) expiration_date_exit =""; else expiration_date_exit = document.getElementById("expiration_date_exit" + no_info).value;
		add_row_exit(stock_id_exit,product_id_exit,stock_code_exit,product_name_exit,'',barcode_exit,unit_exit,unit_id_exit,amount_exit,kdv_amount_exit,cost_id_exit,cost_price_exit,money_exit,cost_price_exit_2,purchase_extra_cost_exit_2,money_exit_2,cost_price_system_exit,money_system_exit,purchase_extra_cost_exit,purchase_extra_cost_system_exit,product_cost_exit,product_cost_money_exit,serial_no_exit,is_production_spect_exit,dimention_exit,spec_main_id_exit,spect_name_exit,expiration_date_exit);
 	}
	function copy_row_outage(no_info)
	{
		if (document.getElementById("money_system_outage" + no_info) == undefined) money_system_outage =""; else money_system_outage = document.getElementById("money_system_outage" + no_info).value;
		if (document.getElementById("stock_code_outage" + no_info) == undefined) stock_code_outage =""; else stock_code_outage = document.getElementById("stock_code_outage" + no_info).value;
		if (document.getElementById("barcode_outage" + no_info) == undefined) barcode_outage =""; else barcode_outage = document.getElementById("barcode_outage" + no_info).value;
		if (document.getElementById("product_id_outage" + no_info) == undefined) product_id_outage =""; else product_id_outage = document.getElementById("product_id_outage" + no_info).value;
		if (document.getElementById("lot_no_outage" + no_info) == undefined) lot_no_outage =""; else lot_no_outage = document.getElementById("lot_no_outage" + no_info).value;
		if (document.getElementById("amount_outage" + no_info) == undefined) amount_outage =""; else amount_outage = document.getElementById("amount_outage" + no_info).value;
		if (document.getElementById("unit_id_outage" + no_info) == undefined) unit_id_outage =""; else unit_id_outage = document.getElementById("unit_id_outage" + no_info).value;
		if (document.getElementById("dimention_outage" + no_info) == undefined) dimention_outage =""; else dimention_outage = document.getElementById("dimention_outage" + no_info).value;
		if (document.getElementById("cost_price_outage" + no_info) == undefined) cost_price_outage =""; else cost_price_outage = document.getElementById("cost_price_outage" + no_info).value;
		if (document.getElementById("purchase_extra_cost_outage" + no_info) == undefined) purchase_extra_cost_outage =""; else purchase_extra_cost_outage = document.getElementById("purchase_extra_cost_outage" + no_info).value;
		if (document.getElementById("total_cost_price_outage" + no_info) == undefined) total_cost_price_outage =""; else total_cost_price_outage = document.getElementById("total_cost_price_outage" + no_info).value;
		if (document.getElementById("money_outage" + no_info) == undefined) money_outage =""; else money_outage = document.getElementById("money_outage" + no_info).value;
		if (document.getElementById("cost_price_outage_2" + no_info) == undefined) cost_price_outage_2 =""; else cost_price_outage_2 = document.getElementById("cost_price_outage_2" + no_info).value;
		if (document.getElementById("purchase_extra_cost_outage_2" + no_info) == undefined) purchase_extra_cost_outage_2 =""; else purchase_extra_cost_outage_2 = document.getElementById("purchase_extra_cost_outage_2" + no_info).value;
		if (document.getElementById("total_cost_price_outage_2" + no_info) == undefined) total_cost_price_outage_2 =""; else total_cost_price_outage_2 = document.getElementById("total_cost_price_outage_2" + no_info).value;
		if (document.getElementById("money_outage_2" + no_info) == undefined) money_outage_2 =""; else money_outage_2 = document.getElementById("money_outage_2" + no_info).value;
		if (document.getElementById("amount_outage2_" + no_info) == undefined) amount_outage2_ =""; else amount_outage2_ = document.getElementById("amount_outage2_" + no_info).value;
		if (document.getElementById("product_name2_outage" + no_info) == undefined) product_name2_outage =""; else product_name2_outage = document.getElementById("product_name2_outage" + no_info).value;
		if (document.getElementById("unit_outage" + no_info) == undefined) unit_outage =""; else unit_outage = document.getElementById("unit_outage" + no_info).value;
		if (document.getElementById("cost_id_outage" + no_info) == undefined) cost_id_outage =""; else cost_id_outage = document.getElementById("cost_id_outage" + no_info).value;
		if (document.getElementById("product_cost_outage" + no_info) == undefined) product_cost_outage =""; else product_cost_outage = document.getElementById("product_cost_outage" + no_info).value;
		if (document.getElementById("product_cost_money_outage" + no_info) == undefined) product_cost_money_outage =""; else product_cost_money_outage = document.getElementById("product_cost_money_outage" + no_info).value;
		if (document.getElementById("cost_price_system_outage" + no_info) == undefined) cost_price_system_outage =""; else cost_price_system_outage = document.getElementById("cost_price_system_outage" + no_info).value;
		if (document.getElementById("purchase_extra_cost_system_outage" + no_info) == undefined) purchase_extra_cost_system_outage =""; else purchase_extra_cost_system_outage = document.getElementById("purchase_extra_cost_system_outage" + no_info).value;
		if (document.getElementById("kdv_amount_outage" + no_info) == undefined) kdv_amount_outage =""; else kdv_amount_outage = document.getElementById("kdv_amount_outage" + no_info).value;
		if (document.getElementById("stock_id_outage" + no_info) == undefined) stock_id_outage =""; else stock_id_outage = document.getElementById("stock_id_outage" + no_info).value;
		if (document.getElementById("product_name_outage" + no_info) == undefined) product_name_outage =""; else product_name_outage = document.getElementById("product_name_outage" + no_info).value;
		if (document.getElementById("spect_id_outage" + no_info) == undefined) spect_id_outage =""; else spect_id_outage = document.getElementById("spect_id_outage" + no_info).value;
		if (document.getElementById("spect_name_outage" + no_info) == undefined) spect_name_outage =""; else spect_name_outage = document.getElementById("spect_name_outage" + no_info).value;
		if (document.getElementById("serial_no_outage" + no_info) == undefined) serial_no_outage =""; else serial_no_outage = document.getElementById("serial_no_outage" + no_info).value;
		if (document.getElementById("is_manual_cost_outage" + no_info) == undefined) is_manual_cost_outage =""; else is_manual_cost_outage = document.getElementById("is_manual_cost_outage" + no_info).value;
		if (document.getElementById("expiration_date_outage" + no_info) == undefined) expiration_date_outage =""; else expiration_date_outage = document.getElementById("expiration_date_outage" + no_info).value;
		 add_row_outage(stock_id_outage,product_id_outage,stock_code_outage,product_name_outage,'',barcode_outage,unit_outage,unit_id_outage,amount_outage,kdv_amount_outage,cost_id_outage,cost_price_outage,money_outage,cost_price_outage_2,purchase_extra_cost_outage_2,money_outage_2,cost_price_system_outage,money_system_outage,purchase_extra_cost_outage,purchase_extra_cost_system_outage,product_cost_outage,product_cost_money_outage,serial_no_outage,'',dimention_outage,spect_id_outage,spect_name_outage,expiration_date_outage);
 	}
	function pencere_ac_alternative(type,no,pid,sid)//ürünlerin alternatiflerini açıyor
	{
		if(type == 1)
		{
		form_stock = document.getElementById("stock_id_exit"+no);
		//&field_is_production=form_basket.is_production_spect_exit'+no+'
			<cfif is_add_alternative_product eq 0>
				//var tree_info_null_ = 1;  1 olarak gönderildiğinde sadece ürün detayındaki alternatifleri getirir.
				url_str='&tree_info_null_=1&field_is_production=form_basket.is_production_spect_exit'+no+'&field_tax_purchase=form_basket.kdv_amount_exit'+no+'&product_id=form_basket.product_id_exit'+no+'&run_function=alternative_product_cost&send_product_id=p_id,'+no+'<cfif x_is_barkod_col>&field_barcode=form_basket.barcode_exit'+no+'</cfif>&field_id=form_basket.stock_id_exit'+no+'&field_unit_name=form_basket.unit_exit'+no+'&field_code=form_basket.stock_code_exit'+no+'&field_name=form_basket.product_name_exit' + no + '&field_unit=form_basket.unit_id_exit'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&tree_stock_id='+sid+'&is_form_submitted=1&is_only_alternative=1';
			<cfelse>
				sqlstr = 'SELECT TOP 1 P.STOCK_ID FROM SPECT_MAIN_ROW SR,ALTERNATIVE_PRODUCTS AP,PRODUCT_TREE P,SPECT_MAIN WHERE SR.PRODUCT_ID = AP.PRODUCT_ID AND SR.RELATED_TREE_ID = P.PRODUCT_TREE_ID AND AP.TREE_STOCK_ID = P.STOCK_ID AND AP.PRODUCT_ID = '+ pid +' AND AP.QUESTION_ID <> 0 AND AP.TREE_STOCK_ID = '+ sid +' AND P.RELATED_ID = SR.STOCK_ID AND SR.SPECT_MAIN_ID = SPECT_MAIN.SPECT_MAIN_ID';
				my_query = wrk_query(sqlstr,'dsn3');
				if(my_query.recordcount)
				sid = my_query.STOCK_ID;
				url_str='&tree_stock_id='+sid+'&field_is_production=form_basket.is_production_spect_exit'+no+'&field_tax_purchase=form_basket.kdv_amount_exit'+no+'&product_id=form_basket.product_id_exit'+no+'&run_function=alternative_product_cost&send_product_id=p_id,'+no+'<cfif x_is_barkod_col>&field_barcode=form_basket.barcode_exit'+no+'</cfif>&field_id=form_basket.stock_id_exit'+no+'&field_unit_name=form_basket.unit_exit'+no+'&field_code=form_basket.stock_code_exit'+no+'&field_name=form_basket.product_name_exit' + no + '&field_unit=form_basket.unit_id_exit'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&is_form_submitted=1&is_only_alternative=1';
			</cfif>
		
		}
		else
		{
		form_stock = document.getElementById("stock_id_outage"+no);
		//&field_is_production=form_basket.is_production_spect_exit'+no+'
			<cfif is_add_alternative_product eq 0>
				//var tree_info_null_ = 1;  1 olarak gönderildiğinde sadece ürün detayındaki alternatifleri getirir.
				url_str='&tree_info_null_=1&field_tax_purchase=form_basket.kdv_amount_outage'+no+'&product_id=form_basket.product_id_outage'+no+'&run_function=alternative_product_cost&send_product_id=p_id,'+no+'<cfif x_is_barkod_col>&field_barcode=form_basket.barcode_outage'+no+'</cfif>&field_id=form_basket.stock_id_outage'+no+'&field_unit_name=form_basket.unit_outage'+no+'&field_code=form_basket.stock_code_outage'+no+'&field_name=form_basket.product_name_outage' + no + '&field_unit=form_basket.unit_id_outage'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&tree_stock_id='+sid+'&is_form_submitted=1&is_only_alternative=1';
			<cfelse>
				sqlstr = 'SELECT TOP 1 P.STOCK_ID FROM SPECT_MAIN_ROW SR,ALTERNATIVE_PRODUCTS AP,PRODUCT_TREE P,SPECT_MAIN WHERE SR.PRODUCT_ID = AP.PRODUCT_ID AND SR.RELATED_TREE_ID = P.PRODUCT_TREE_ID AND AP.TREE_STOCK_ID = P.STOCK_ID AND AP.PRODUCT_ID = '+ pid +' AND AP.QUESTION_ID <> 0 AND AP.QUESTION_ID <> 0 AND AP.TREE_STOCK_ID = '+ sid +' AND P.RELATED_ID = SR.STOCK_ID AND SR.SPECT_MAIN_ID = SPECT_MAIN.SPECT_MAIN_ID';
				my_query = wrk_query(sqlstr,'dsn3');
				if(my_query.recordcount)
				sid = my_query.STOCK_ID;
				url_str='&tree_stock_id='+sid+'&field_tax_purchase=form_basket.kdv_amount_outage'+no+'&product_id=form_basket.product_id_outage'+no+'&run_function=alternative_product_cost&send_product_id=p_id,'+no+'<cfif x_is_barkod_col>&field_barcode=form_basket.barcode_outage'+no+'</cfif>&field_id=form_basket.stock_id_outage'+no+'&field_unit_name=form_basket.unit_outage'+no+'&field_code=form_basket.stock_code_outage'+no+'&field_name=form_basket.product_name_outage' + no + '&field_unit=form_basket.unit_id_outage'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&is_form_submitted=1&is_only_alternative=1';
			</cfif>
		
			}
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names'+url_str+'','list');
	}
	function pencere_ac_list_product(no,type)//ürünlere lot_no ekliyor
	{
		if(type == 2)
		{//sarf ise type 2
			form_stock_code = document.getElementById("stock_code_exit"+no).value;
			url_str='&is_sale_product=1&update_product_row_id=0<cfoutput>&round_number=#round_number#</cfoutput>&is_lot_no_based=1&prod_order_result_=1&sort_type=1&deliver_date=form_basket.expiration_date_exit'+no+'&lot_no=form_basket.lot_no_exit'+no+'&keyword=' + form_stock_code+'&is_form_submitted=1&int_basket_id=1';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products'+url_str+'','list');
		}
		else if(type == 3)
		{//fire ise type 3
			form_stock_code = document.getElementById("stock_code_outage"+no).value;
			url_str='&is_sale_product=1&update_product_row_id=0<cfoutput>&round_number=#round_number#</cfoutput>&is_lot_no_based=1&prod_order_result_=1&sort_type=1&deliver_date=form_basket.expiration_date_outage'+no+'&lot_no=form_basket.lot_no_outage'+no+'&keyword=' + form_stock_code+'&is_form_submitted=1&int_basket_id=1';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products'+url_str+'','list');
		}
	}
	function alternative_product_cost(pid,no)
		{
			var listParam = pid + "*" + " <cfoutput>#createodbcdate(get_det_po.finish_date)#</cfoutput>";
			var GET_PRODUCT_COST = wrk_safe_query("prdp_GET_PRODUCT_COST",'dsn3',0,listParam);
			if(!GET_PRODUCT_COST.recordcount)
			{
				
					cost_id = 0;
					purchase_extra_cost = 0;
					product_cost = 0;
					product_cost_money = '<cfoutput>#session.ep.money#</cfoutput>';
					cost_price = 0;
					cost_price_money = '<cfoutput>#session.ep.money#</cfoutput>';
					cost_price_2 = 0;
					cost_price_money_2 = '<cfoutput>#session.ep.money2#</cfoutput>';
					cost_price_system = 0;
					cost_price_system_money = '<cfoutput>#session.ep.money#</cfoutput>';
					purchase_extra_cost_system = 0;
			}
			else
			{
				cost_id = GET_PRODUCT_COST.PRODUCT_COST_ID;
				purchase_extra_cost = GET_PRODUCT_COST.PURCHASE_EXTRA_COST;
				product_cost = GET_PRODUCT_COST.PRODUCT_COST;
				product_cost_money = GET_PRODUCT_COST.MONEY;
				cost_price = GET_PRODUCT_COST.PURCHASE_NET;
				cost_price_money = GET_PRODUCT_COST.PURCHASE_NET_MONEY;
				cost_price_2 = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_2;
				cost_price_money_2 = session.ep.money2;
				cost_price_system = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM;
				cost_price_system_money = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY;
				purchase_extra_cost_system = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM;
			}
			//Ürünün maliyet değerleri
			document.getElementById("cost_id_exit"+no).value = cost_id;
			document.getElementById("purchase_extra_cost_exit"+no).value = purchase_extra_cost;
			document.getElementById("product_cost_exit"+no).value = product_cost;
			document.getElementById("product_cost_money_exit"+no).value = product_cost_money;
			document.getElementById("cost_price_exit"+no).value = commaSplit(cost_price,round_number);
			document.getElementById("money_exit"+no).value = cost_price_money;
			<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
				document.getElementById("cost_price_exit_2"+no).value = commaSplit(cost_price_2,round_number);
				document.getElementById("money_exit_2"+no).value = cost_price_money_2;
			</cfif>
			document.getElementById("cost_price_system_exit"+no).value = cost_price_system;
			document.getElementById("money_system_exit"+no).value = cost_price_system_money;
			document.getElementById("purchase_extra_cost_system_exit"+no).value = purchase_extra_cost_system;
			//ürün değiştiği için spectler sıfırlanıyor
			document.getElementById("spect_id_exit_"+no).value = "";
			document.getElementById("spect_id_exit"+no).value = "";
			document.getElementById("spect_name_exit"+no).value = "";
	
		}
	function pencere_ac_spect(no,type)
	{	
		_department_id_="";
		var exit_department_id_ = document.getElementById('exit_department_id').value;
		var exit_location_id_ = document.getElementById('exit_location_id').value;
		if(exit_department_id_ != "")
		_department_id_ = exit_department_id_;
		if(exit_department_id_ != "" && exit_location_id_!= "")
		_department_id_ +='-'+exit_location_id_;
		if(type==2)//sarflar
		{
			form_stock = document.getElementById("stock_id_exit"+no);
			if(<cfoutput>#get_det_po.is_demontaj#</cfoutput> == 1)
			url_str='&field_main_id=form_basket.spec_main_id_exit'+no+'&field_var_id=form_basket.spect_id_exit'+no+'&field_id=form_basket.spect_id_exit'+no+'&field_name=form_basket.spect_name_exit' + no + '&stock_id=' + form_stock.value + '&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1&p_order_id=<cfoutput>#attributes.p_order_id#</cfoutput>';
			else
			url_str='&field_main_id=form_basket.spec_main_id_exit'+no+'&field_var_id=form_basket.spect_id_exit'+no+'&field_id=form_basket.spect_id_exit'+no+'&field_name=form_basket.spect_name_exit' + no + '&stock_id=' + form_stock.value +'&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1';
			
		}
		else if(type==3)
		{
			form_stock = document.getElementById("stock_id_outage"+no);
			if(<cfoutput>#get_det_po.is_demontaj#</cfoutput> == 1)
			url_str='&field_main_id=form_basket.spec_main_id_outage'+no+'&field_var_id=form_basket.spect_id_outage'+no+'&field_id=form_basket.spect_id_outage'+no+'&field_name=form_basket.spect_name_outage' + no + '&stock_id=' + form_stock.value + '&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1&p_order_id=<cfoutput>#attributes.p_order_id#</cfoutput>';
			else
			url_str='&field_main_id=form_basket.spec_main_id_outage'+no+'&field_var_id=form_basket.spect_id_outage'+no+'&field_id=form_basket.spect_id_outage'+no+'&field_name=form_basket.spect_name_outage' + no + '&stock_id=' + form_stock.value +'&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1';
		}
		else
		{
			form_stock = document.getElementById("stock_id"+no);
			if(<cfoutput>#get_det_po.is_demontaj#</cfoutput> == 1)
				url_str='&field_var_id=form_basket.spect_id'+no+'&field_id=form_basket.spect_id'+no+'&field_name=form_basket.spect_name' + no + '&stock_id=' + form_stock.value + '&create_main_spect_and_add_new_spect_id=1&last_spect=1&p_order_id=<cfoutput>#attributes.p_order_id#</cfoutput>';
			else	
				url_str='&field_var_id=form_basket.spect_id'+no+'&p_order_row_id='+document.getElementById('order_row_id').value+'&field_id=form_basket.spect_id'+no+'&field_name=form_basket.spect_name' + no + '&stock_id=' + form_stock.value + '&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1&p_order_id=<cfoutput>#attributes.p_order_id#</cfoutput>';
			
		}
		if(form_stock.value == "")
			alert("<cf_get_lang dictionary_id='57471.Eksik veri'> : <cf_get_lang dictionary_id='57657.Ürün'>");
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&main_to_add_spect=1' + url_str,'list');
			//windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect' + url_str,'list');-Burası önceden spect_id sayfasını açıyordu ve direkt ekleniyordu ancak stocks_row'a kayıt atılmayan spectler gelmediği için iptal edildi.Onun yerine main_spect sayfası geliyor,seçilen main_spect'e göre bir spect eklenip onun id'si bu sayfaya gönderiliyor.
	}
	function pencere_ac_serial_no(no)
	{
		form_serial_no_exit = document.getElementById("serial_no_exit"+no);
		if(form_serial_no_exit.value == "")
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57637.Seri No'>");
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.serial_no&event=det&product_serial_no=' + form_serial_no_exit.value,'list');	
	}
	function hesapla_deger(value,id)
	{
		if(id==0)
		{
			value_amount_exit = document.getElementById("amount_exit"+value);
			if((value_amount_exit == "") || (value_amount_exit == 0))
			{
				value_amount_exit = 0;
			}
		}
		else if(id==1)
		{
			value_amount = document.getElementById("amount"+value);
			if((value_amount.value == "") || (value_amount.value == 0))
			{
				value_amount.value = 0;
			}
		}
		else if(id==2)
		{
			value_amount = document.getElementById("amount_outage"+value);
			if((value_amount.value == "") || (value_amount.value == 0))
			{
				value_amount.value = 0;
			}
		}
		else if(id==3)
		{
			value_amount = document.getElementById("fire_amount_"+value);
			if((value_amount.value == "") || (value_amount.value == 0))
			{
				value_amount.value = 0;
			}
		}
	}
	function kontrol()
	{	   
		control1=wrk_safe_query("get_remain_order_result1","dsn3",0,document.getElementById('p_order_id').value);
		var round_number = document.getElementById('round_number').value;
		if(!chk_period(document.getElementById("finish_date"), 'İşlem')) return false;
		change_row_cost(1,1);//satirdaki maliyetleri bitis tarihindeki kura göre guncelliyor.
		var Get_Result = wrk_safe_query('prdp_get_result','dsn3',0,document.getElementById('production_result_no').value);	
		if(Get_Result.recordcount > 0){
			alert("<cf_get_lang dictionary_id='60576.Bu Sonuç Numarası Daha Önce Kullanılmış'>");					
				if(control1.REMAIN_AMOUNT > 0){		
					var a=parseInt(list_getat(document.getElementById('production_result_no').value,2,'-'))+1;					
					document.getElementById('production_result_no').value=list_getat(document.getElementById('production_result_no').value,1,'-')+'-'+a;
					}
				else
					{
						alert("<cf_get_lang dictionary_id='60577.Bu üretim emri için Üretim sonucu girilemez'>.");
					}
				//window.location.reload();	
			return false;
		}
		if(document.getElementById("record_num").value == 0)
		{
			alert("<cf_get_lang dictionary_id='35971.Lütfen Ana Ürün Seçiniz'>!");
			return false;
		}
		if(document.getElementById("record_num_exit").value == 0)
		{
			alert("<cf_get_lang dictionary_id='60514.Lütfen Sarf Ürünü Seçiniz'>!");
			return false;
		}
		if(document.getElementById("station_id").value == "" || document.getElementById("station_name").value == "")
		{
			alert("<cf_get_lang dictionary_id='58837.Lütfen İstasyon Seçiniz'> !");
			return false;
		}
		
		if((document.getElementById("sarf_recordcount").value > 0 && (filterNum(document.getElementById("amount_exit_"+1).value,round_number)>0) || document.getElementById("sarf_recordcount").value == 0) && (filterNum(document.getElementById("amount"+1).value,round_number)>0))
		{
			<cfif get_det_po.is_demontaj eq 0><!--- Demontaj Değil ise --->
				if(document.getElementById('spec_main_id1').value == "" && document.getElementById('spect_id1').value == ""){
					alert("<cf_get_lang dictionary_id='60578.Ana Ürün İçin Spec Seçmeniz Gerekmektedir.'>");
					return false;
				}
			</cfif>
			if(!chk_process_cat('form_basket')) return false;
			if(!check_display_files('form_basket')) return false;
			if(!process_cat_control()) return false;
			if(!time_check(form_basket.start_date, form_basket.start_h, form_basket.start_m, form_basket.finish_date, form_basket.finish_h, form_basket.finish_m, "<cf_get_lang dictionary_id='36776.Başlangıç Tarihi Bitiş Tarihinden Büyük'> !")) return false;
			var row_count_exit_ = 0;
			for (var k=1;k<=row_count_exit;k++)//eğer sarfların içinde üretilen bir ürün varsa onun için spect seçilmesini zorunlu kılıyor.Onun kontrolü
			{
				if(document.getElementById("row_kontrol_exit"+k).value==1)// fire ürün satırı olması için kontrol eklendi.
				{
					row_count_exit_ = row_count_exit_ + 1;
					if((document.getElementById("spec_main_id_exit"+k).value == "" || document.getElementById("spec_main_id_exit"+k).value == "") && (document.getElementById("is_production_spect_exit"+k).value == 1)&& document.getElementById("row_kontrol_exit"+k).value==1)//spect id ve spect name varsa vede ürtilen bir ürünse
					{
						alert('<cf_get_lang dictionary_id="36884.Üretilen Ürünler İçin Spect Seçmeniz Gerekmektedir">.(' + document.getElementById("product_name_exit"+k).value + ')');
						return false;
					}
					if(document.getElementById("spec_main_id_exit"+k).value != '')
					{
						var spec_control = wrk_query("SELECT SPECT_MAIN_ID,SPECT_STATUS FROM SPECT_MAIN WHERE SPECT_MAIN_ID = " + document.getElementById("spec_main_id_exit"+k).value,"dsn3");
						if(spec_control.recordcount == 0)
						{
							alert(row_count_exit_+". <cf_get_lang dictionary_id='60579.Satırdaki Sarf Ürün Spec i Silinmiş'>. <cf_get_lang dictionary_id='60580.Lütfen Specinizi Güncelleyiniz'>!");
							return false;
						}
						else if(spec_control.SPECT_STATUS == 0)
						{
							alert(row_count_exit_+". <cf_get_lang dictionary_id='60581.Satırdaki Sarf Ürün Spec i Pasif Durumda'>. <cf_get_lang dictionary_id='60580.Lütfen Specinizi Güncelleyiniz'>!");
							return false;
						}
					}
					<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
						if(check_lotno('form_basket'))//işlem kategorisinde lot no zorunlu olsun seçili ise
						{
							get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.getElementById("stock_id_exit"+k).value);
							if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
							{
								if(document.getElementById("lot_no_exit"+k).value == '')
								{
									alert(row_count_exit_+'. <cf_get_lang dictionary_id="60582.sarf satırındaki"> '+ document.getElementById("product_name_exit"+k).value + ' <cf_get_lang dictionary_id="59285.ürünü için lot no takibi yapılmaktadır">!');
									return false;
								}
							}
						}
					</cfif>
				}
			}
			var row_count_outage_ = 0;
			for (var k=1;k<=row_count_outage;k++)
			{
				if(document.getElementById("row_kontrol_outage"+k).value==1)// fire ürün satırı olması için kontrol eklendi.
				{
					row_count_outage_ = row_count_outage_ + 1;
					if(filterNum(document.getElementById("amount_outage"+k).value,round_number) <= 0)
					{
						alert("<cf_get_lang dictionary_id='65396.Fire Miktarı 0 Olamaz'> , <cf_get_lang dictionary_id='60510.Lütfen Miktarları Kontrol Ediniz'> !");
						return false;
					}
					<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
						if(check_lotno('form_basket'))//işlem kategorisinde lot no zorunlu olsun seçili ise
						{
							get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.getElementById("stock_id_outage"+k).value);
							if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
							{
								if(document.getElementById("lot_no_outage"+k).value == '')
								{
									alert(row_count_outage_+'. <cf_get_lang dictionary_id="60583.fire satırındaki"> '+ document.getElementById("product_name_outage"+k).value + ' <cf_get_lang dictionary_id="59285.ürünü için lot no takibi yapılmaktadır">!');
									return false;
								}
							}
						}
					</cfif>
				}
			}
			var row_count_ = 0;
			for (var r=1;r<=row_count;r++)
			{
				if(document.getElementById("row_kontrol"+r).value==1)//En az bir ana ürün satırı olması için kontrol eklendi.
				{
					row_count_ = row_count_ + 1;
					if(filterNum(document.getElementById("amount"+r).value,round_number) <= 0)
					{
						alert("<cf_get_lang dictionary_id='60509.Ürün Miktarı 0 Olamaz'> , <cf_get_lang dictionary_id='60510.Lütfen Miktarları Kontrol Ediniz'> !");
						return false;
					}
				}
				if(document.getElementById("amount2_"+r) != undefined)
					document.getElementById("amount2_"+r).value = filterNum(document.getElementById("amount2_"+r).value,round_number);
				document.getElementById("amount"+r).value = filterNum(document.getElementById("amount"+r).value,round_number);
				document.getElementById("cost_price"+r).value = filterNum(document.getElementById("cost_price"+r).value,round_number);
				/*if(document.getElementById("purchase_extra_cost_system"+r) != undefined)
					document.getElementById("purchase_extra_cost_system"+r).value = filterNum(document.getElementById("purchase_extra_cost_system"+r).value,8);*/
				if(document.getElementById("cost_price_2"+r) != undefined)
					document.getElementById("cost_price_2"+r).value = filterNum(document.getElementById("cost_price_2"+r).value,round_number);
				if(document.getElementById("cost_price_extra_2"+r) != undefined)
					document.getElementById("cost_price_extra_2"+r).value = filterNum(document.getElementById("cost_price_extra_2"+r).value,round_number);
				<cfif x_is_fire_product eq 1>
					document.getElementById("fire_amount_"+r).value = filterNum(document.getElementById("fire_amount_"+r).value,round_number);
				</cfif>
				document.getElementById("weight"+r).value = filterNum(document.getElementById("weight"+r).value,round_number);
					<cfif xml_specific_weight eq 1>
					document.getElementById("specific_weight"+r).value = filterNum(document.getElementById("specific_weight"+r).value,round_number);
					</cfif>
					<cfif x_is_show_abh eq 1>
					document.getElementById("width"+r).value = filterNum(document.getElementById("width"+r).value,round_number);
					document.getElementById("height"+r).value = filterNum(document.getElementById("height"+r).value,round_number);
					document.getElementById("length"+r).value = filterNum(document.getElementById("length"+r).value,round_number);
					</cfif>
			}
			if(row_count_ == 0)
			{
				alert("<cf_get_lang dictionary_id='35971.Lütfen Ana Ürün Seçiniz'>!");
				return false;
			}
			var row_count_exit_ = 0;
			for (var k=1;k<=row_count_exit;k++)
			{
				if(document.getElementById("row_kontrol_exit"+k).value==1)//En az bir sarf ürün satırı olması için kontrol eklendi.
				{
					row_count_exit_ = row_count_exit_ + 1;
					if(filterNum(document.getElementById("amount_exit"+k).value,round_number) <= 0)
					{
						alert("<cf_get_lang dictionary_id='60513.Sarf Miktarı 0 Olamaz'> , <cf_get_lang dictionary_id='60510.Lütfen Miktarları Kontrol Ediniz'> !");
						return false;
					}
				}
			}
			
			for (var k=1;k<=row_count_exit;k++)
			{
				if(document.getElementById("document.form_basket.amount_exit2_"+r) != undefined)
					document.getElementById("amount_exit2_"+k).value = filterNum(document.getElementById("amount_exit2_"+k).value,round_number);
				document.getElementById("amount_exit"+k).value = filterNum(document.getElementById("amount_exit"+k).value,round_number);
				document.getElementById("cost_price_exit"+k).value = filterNum(document.getElementById("cost_price_exit"+k).value,round_number);
				if(document.getElementById("cost_price_exit_2"+k) != undefined)
					document.getElementById("cost_price_exit_2"+k).value = filterNum(document.getElementById("cost_price_exit_2"+k).value,round_number);	
				if(document.getElementById("purchase_extra_cost_exit_2"+k) != undefined)
					document.getElementById("purchase_extra_cost_exit_2"+k).value = filterNum(document.getElementById("purchase_extra_cost_exit_2"+k).value,round_number);
				document.getElementById("purchase_extra_cost_exit"+k).value = filterNum(document.getElementById("purchase_extra_cost_exit"+k).value,round_number);
				<cfif x_is_show_abh eq 1>
					document.getElementById("width_exit"+k).value = filterNum(document.getElementById("width_exit"+k).value,round_number);
					document.getElementById("height_exit"+k).value = filterNum(document.getElementById("height_exit"+k).value,round_number);
					document.getElementById("length_exit"+k).value = filterNum(document.getElementById("length_exit"+k).value,round_number);
				</cfif>
				document.getElementById("weight_exit"+k).value = filterNum(document.getElementById("weight_exit"+k).value,round_number);
				<cfif xml_specific_weight eq 1>
				document.getElementById("specific_weight_exit"+k).value = filterNum(document.getElementById("specific_weight_exit"+k).value,round_number);
				</cfif>
			}
			if(row_count_exit_ == 0)
			{
				alert("<cf_get_lang dictionary_id='60514.Lütfen Sarf Ürünü Seçiniz'>!");
				return false;
			}
			
			for (var k=1;k<=row_count_outage;k++)
			{
				
				if(document.getElementById("document.form_basket.amount_outage2_"+r) != undefined)
					document.getElementById("amount_outage2_"+k).value = filterNum(document.getElementById("amount_outage2_"+k).value,round_number);
				document.getElementById("amount_outage"+k).value = filterNum(document.getElementById("amount_outage"+k).value,round_number);
				document.getElementById("cost_price_outage"+k).value = filterNum(document.getElementById("cost_price_outage"+k).value,round_number);
				if(document.getElementById("cost_price_outage_2"+k) != undefined)
					document.getElementById("cost_price_outage_2"+k).value = filterNum(document.getElementById("cost_price_outage_2"+k).value,round_number);
				if(document.getElementById("purchase_extra_cost_outage_2"+k) != undefined)
					document.getElementById("purchase_extra_cost_outage_2"+k).value = filterNum(document.getElementById("purchase_extra_cost_outage_2"+k).value,round_number);
				document.getElementById("purchase_extra_cost_outage"+k).value = filterNum(document.getElementById("purchase_extra_cost_outage"+k).value,round_number);
				//document.getElementById("purchase_extra_cost_system_outage"+k).value = filterNum(document.getElementById("purchase_extra_cost_system_outage"+k).value,8);
				<cfif x_is_show_abh eq 1>
					document.getElementById("width_outage"+k).value = filterNum(document.getElementById("width_outage"+k).value,round_number);
					document.getElementById("height_outage"+k).value = filterNum(document.getElementById("height_outage"+k).value,round_number);
					document.getElementById("length_outage"+k).value = filterNum(document.getElementById("length_outage"+k).value,round_number);
				</cfif>
				document.getElementById("weight_outage"+k).value = filterNum(document.getElementById("weight_outage"+k).value,round_number);
				<cfif xml_specific_weight eq 1>
				document.getElementById("specific_weight_outage"+k).value = filterNum(document.getElementById("specific_weight_outage"+k).value,round_number);
				</cfif>
				if(document.getElementById("spec_main_id_outage"+k).value != '')
				{
					var spec_control_outage = wrk_query("SELECT SPECT_MAIN_ID,SPECT_STATUS FROM SPECT_MAIN WHERE SPECT_MAIN_ID =  " + document.getElementById("spec_main_id_outage"+k).value,"dsn3");
					if(spec_control_outage.recordcount == 0)
					{
						alert(k+". <cf_get_lang dictionary_id='60584.Satırdaki Fire Ürün Speci Silinmiş'>. <cf_get_lang dictionary_id='60580.Lütfen Specinizi Güncelleyiniz'>!");
						return false;
					}
					else if(spec_control_outage.SPECT_STATUS == 0)
					{
						alert(k+". <cf_get_lang dictionary_id='60585.Satırdaki Fire Ürün Speci Pasif Durumda'>. <cf_get_lang dictionary_id='60580.Lütfen Specinizi Güncelleyiniz'>!");
						return false;
					}
				}
			}
			return true;
		}
		else
		{
			alert("<cf_get_lang dictionary_id='36442.Miktar 0 Üretim Yapılamaz'>");
			return false;	
		}
	}
	function temizle(id)
	{
		if(id==0)
		{
			document.getElementById("station_id").value = "";
			document.getElementById("station_name").value = "";
		}
	}
	function aktar()
		{
			var sarf_uzunluk=document.getElementById("sarf_recordcount").value;
			if(document.getElementById("fire_recordcount"))
				var fire_uzunluk=document.getElementById("fire_recordcount").value;
			else
				var fire_uzunluk=0;
			<cfif x_por_amount_lte_po eq 0>//<!--- XML ayarlarında üretim sonuçlarının toplamı üretim emrinin miktarından fazla olamaz denildi ise.... --->
				<cfif get_det_po.is_demontaj eq 0>
					if(filterNum(document.getElementById("amount"+1).value,round_number) > filterNum(document.getElementById("amount_"+1).value,round_number))
						{
							alert("<cf_get_lang dictionary_id='60586.Girilen Miktar Oranı Üretim Emrinden Fazla Olamaz.'>");
							eval("form_basket.amount"+1).value=eval("form_basket.amount_"+1).value;
						}
					if(filterNum(document.getElementById("amount_"+1).value,round_number)<1)		
						{
							alert("<cf_get_lang dictionary_id='60587.Bu Üretim Emrinde Kota Dolmuştur,Üretim yapmak için yeni bir Üretim Emri Ekleyiniz.'>");
							document.getElementById("amount"+1).value=0;
							return false;
						}
					if(filterNum(document.getElementById("amount"+1).value,round_number)<1)		
					{
						alert("<cf_get_lang dictionary_id='60588.Üretim Oranı Hatalı Lütfen Doğru Bir Değer Giriniz'>!");
						document.getElementById("amount"+1).value = document.getElementById("amount_"+1).value;
						return false;
					}
				</cfif>	
				<cfif get_det_po.is_demontaj eq 1>
					if(filterNum(document.getElementById("amount_exit"+1).value,round_number)>filterNum(document.getElementById("amount_exit_"+1).value,round_number))
						{
							alert("<cf_get_lang dictionary_id='60586.Girilen Miktar Oranı Üretim Emrinden Fazla Olamaz.'>");
							document.getElementById("amount_exit"+1).value = document.getElementById("amount_exit_"+1).value;
						}
						if(filterNum(document.getElementById("amount_exit_"+1).value,round_number)==0)
						{
							alert("<cf_get_lang dictionary_id='60587.Bu Üretim Emrinde Kota Dolmuştur,Üretim yapmak için yeni bir Üretim Emri Ekleyiniz.'>");
							document.getElementById("amount_exit"+1).value=0;
							return false;	
						}
						if(filterNum(document.getElementById("amount_exit"+1).value,round_number)==0)
						{
							alert("<cf_get_lang dictionary_id='60588.Üretim Oranı Hatalı Lütfen Doğru Bir Değer Giriniz'>!");
							return false;	
						}		
						
				</cfif>	
			</cfif>
			if(sarf_uzunluk>0)
			{
				if(document.getElementById("auto_calc_amount_exit") != undefined && document.getElementById("auto_calc_amount_exit").value == 1)
				{
					for (i=1;i<=sarf_uzunluk;i++)
					{	
						<cfif get_det_po.is_demontaj eq 0>
							if(document.getElementById("is_free_amount"+i).value == 0)
							{
								<cfif isdefined('GET_SUM_AMOUNT')>
									var x=parseInt(document.getElementById("amount"+1).value);
									if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
										{
											if(parseFloat(document.getElementById("amount_"+1).value) != 0 && parseFloat(document.getElementById("amount"+1).value) != 0)
											{
												<cfif x_is_fire_product eq 1>
													var a=document.getElementById("amount_exit"+i).value=(parseFloat(filterNum(document.getElementById("amount_exit_"+i).value,round_number))/parseFloat(filterNum(document.getElementById("amount_"+1).value,round_number)))*(parseFloat(filterNum(document.getElementById("amount"+1).value,round_number))+parseFloat(filterNum(document.getElementById("fire_amount_"+1).value,round_number)));
												<cfelse>
													var a=document.getElementById("amount_exit"+i).value=(filterNum(document.getElementById("amount_exit_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(filterNum(document.getElementById("amount"+1).value,round_number));
												</cfif>
											}
											else
											{
												var a=0;
											}
											var b=commaSplit(a,round_number);
											document.getElementById("amount_exit"+i).value=b;
										}
								<cfelseif not isdefined('GET_SUM_AMOUNT')>
									var x=parseInt(document.getElementById("amount"+1).value);
									if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
										{
											if(parseFloat(document.getElementById("amount_"+1).value) != 0 && parseFloat(document.getElementById("amount"+1).value) != 0)
											{
												<cfif x_is_fire_product eq 1>
													var a=document.getElementById("amount_exit"+i).value=parseFloat((filterNum(document.getElementById("amount_exit_"+i).value,round_number))/(parseFloat(filterNum(document.getElementById("amount_"+1).value,round_number)))*(parseFloat(filterNum(document.getElementById("amount"+1).value,round_number)))+parseFloat(filterNum(document.getElementById("fire_amount_"+1).value,round_number)));
												<cfelse>
													var a=document.getElementById("amount_exit"+i).value=(filterNum(document.getElementById("amount_exit_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(filterNum(document.getElementById("amount"+1).value,round_number));
												</cfif>
											}
											else
											{
												var a=0;
											}
											var b=commaSplit(a,round_number);
											document.getElementById("amount_exit"+i).value=b;
										}	
								</cfif>
							}
						</cfif>
						<cfif get_det_po.is_demontaj eq 1 and isdefined('GET_SUM_AMOUNT')>
						var x=parseInt(document.getElementById("amount_exit"+1).value);
						if(x>0)/*Demontaj yapılacak ürün miktarı 1 den fazla ise*/
							{	var a=document.getElementById("amount"+i).value=(filterNum(document.getElementById("amount_"+i).value,round_number)/parseFloat(<cfoutput>#sarf_kalan_uretim_emri#</cfoutput>))*filterNum(document.getElementById("amount_exit"+1).value,round_number);
								var b=commaSplit(a,round_number);
								document.getElementById("amount"+i).value=b;
							}	
						<cfelseif get_det_po.is_demontaj eq 1 and not isdefined('GET_SUM_AMOUNT')>
						var x=parseInt(document.getElementById("amount_exit"+1).value);
						if(x>0)/*Demontaj yapılacak ürün miktarı 1 den fazla ise*/
							{
								var a=document.getElementById("amount"+i).value=(filterNum(document.getElementById("amount_"+i).value,round_number)/parseFloat(<cfoutput>#get_det_po.AMOUNT#</cfoutput>))*filterNum(document.getElementById("amount_exit"+1).value,round_number);
								var b=commaSplit(a,round_number);
								document.getElementById("amount"+i).value=b;
							}
						</cfif>
					}
					<cfif isDefined("x_exit_amount_change_auto") and x_exit_amount_change_auto neq 1>
						document.getElementById("auto_calc_amount_exit").value = 0;
					</cfif>
				}
			}
			<cfif get_det_po.is_demontaj eq 0>
				if(fire_uzunluk>0)
				{
					for (i=1;i<=fire_uzunluk;i++)
					{	
						<cfif isdefined('GET_SUM_AMOUNT')>
							var x=parseInt(document.getElementById("amount"+1).value);
							if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
								{
									if(parseFloat(document.getElementById("amount_"+1).value) != 0 && parseFloat(document.getElementById("amount"+1).value) != 0)
									{
										<cfif x_is_fire_product eq 1>
											var c=document.getElementById("amount_outage"+i).value=(filterNum(document.getElementById("amount_outage_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(parseFloat(filterNum(document.getElementById("amount"+1).value,round_number))+parseFloat(filterNum(document.getElementById("fire_amount_"+1).value,round_number)));
										<cfelse>
											var c=document.getElementById("amount_outage"+i).value=(filterNum(document.getElementById("amount_outage_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(parseFloat(filterNum(document.getElementById("amount"+1).value,round_number)));
										</cfif>
									}
									else
									{
										var c=0;
									}
									var d=commaSplit(c,round_number);
									document.getElementById("amount_outage"+i).value=d;
								}
						<cfelseif  not isdefined('GET_SUM_AMOUNT')>
							var x=parseInt(document.getElementById("amount"+1).value);
							if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
								{
									if(parseFloat(document.getElementById("amount_"+1).value) != 0 && parseFloat(document.getElementById("amount"+1).value) != 0)
									{
										<cfif x_is_fire_product eq 1>
											var c=document.getElementById("amount_outage"+i).value=(filterNum(document.getElementById("amount_outage_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(parseFloat(filterNum(document.getElementById("amount"+1).value,round_number))+parseFloat(filterNum(document.getElementById("fire_amount_"+1).value,round_number)));
										<cfelse>
											var c=document.getElementById("amount_outage"+i).value=(filterNum(document.getElementById("amount_outage_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(parseFloat(filterNum(document.getElementById("amount"+1).value,round_number)));
										</cfif>
									}
									else
									{
										var c=0;
									}
									var d=commaSplit(c,round_number);
									document.getElementById("amount_outage"+i).value=d;
								}	
						</cfif>
					}
				}	
			</cfif>
		}
	function spect_degistir()
		{
		   if(<cfoutput>#get_det_po.is_demontaj#</cfoutput> == 1)
			{
				if(document.getElementById("spect_id_exit_1").value!= document.getElementById("spect_id_exit1").value)
				 window.location.reload();
			}
		   else
			  {
			  if(document.getElementById("spect_id_1").value!= document.getElementById("spect_id1").value)
			   window.location.reload();


			  }
		}
	function get_stok_spec_detail_ajax(product_id){
		goster(prod_stock_and_spec_detail_div);
		tempX = event.clientX + document.body.scrollLeft;
		tempY = event.clientY + document.body.scrollTop;
		document.getElementById('prod_stock_and_spec_detail_div').style.left = tempX+10;
		document.getElementById('prod_stock_and_spec_detail_div').style.top = tempY;
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=stock.popup_list_product_spects&from_production_result_detail=1&pid='+product_id+'</cfoutput>','prod_stock_and_spec_detail_div',1)	
	}	
	function counter(field, countfield, maxlimit){ 
		if(field.value.length > maxlimit)
		{ 
			field.value = field.value.substring(0, maxlimit);
			alert("Max "+maxlimit+"!"); 
		}
		else 
			countfield.value = maxlimit - field.value.length; 
	} 
	function lotno_control(crntrow,type)
	{
		//var prohibited=' [space] , ",	#,  $, %, &, ', (, ), *, +, ,, ., /, <, =, >, ?, @, [, \, ], ], `, {, |,   }, , «, ';
		var prohibited_asci='32,34,35,36,37,38,39,40,41,42,43,44,47,60,61,62,63,64,91,92,93,94,96,123,124,125,156,171';
		if(type == 2)
			lot_no = document.getElementById('lot_no_exit'+crntrow);
		else if(type ==3)
			lot_no = document.getElementById('lot_no_outage'+crntrow);
		else
			lot_no = document.getElementById('lot_no');
		toplam_ = lot_no.value.length;
		deger_ = lot_no.value;
		if(toplam_>0)
		{
			for(var this_tus_=0; this_tus_< toplam_; this_tus_++)
			{
				tus_ = deger_.charAt(this_tus_);
				cont_ = list_find(prohibited_asci,tus_.charCodeAt());
				if(cont_>0)
				{
					alert("[space],\"\,#,$,%,&,',(,),*,+,,/,<,=,>,?,@,[,\,],],`,{,|,},«,; Katakterlerinden Oluşan Lot No Girilemez!");
					lot_no.value = '';
					break;
				}
			}
		}
	}
	function newRows()
	{  
		for(i=1;i<=row_count;i++)
		{   
			//Ana Ürün
			document.form_basket.appendChild(document.getElementById('cost_id' + i + ''));
			document.form_basket.appendChild(document.getElementById('tree_type_' + i + ''));
			document.form_basket.appendChild(document.getElementById('row_kontrol' + i + ''));
			document.form_basket.appendChild(document.getElementById('product_cost' + i + ''));
			document.form_basket.appendChild(document.getElementById('product_cost_money' + i + ''));
			document.form_basket.appendChild(document.getElementById('kdv_amount' + i + ''));
			document.form_basket.appendChild(document.getElementById('cost_price_system' + i + ''));
			document.form_basket.appendChild(document.getElementById('purchase_extra_cost_system' + i + ''));
			document.form_basket.appendChild(document.getElementById('purchase_extra_cost' + i + ''));
			if(document.getElementById('money_system' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('money_system' + i + ''));
			if(document.getElementById('barcode' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('barcode' + i + ''));
			document.form_basket.appendChild(document.getElementById('product_id' + i + ''));
			document.form_basket.appendChild(document.getElementById('stock_id' + i + ''));
			document.form_basket.appendChild(document.getElementById('product_name' + i + ''));
			if(document.getElementById('stock_code' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('stock_code' + i + ''));
			document.form_basket.appendChild(document.getElementById('spec_main_id' + i + ''));
			document.form_basket.appendChild(document.getElementById('spect_id' + i + ''));
			document.form_basket.appendChild(document.getElementById('spect_name' + i + ''));
			document.form_basket.appendChild(document.getElementById('amount' + i + ''));
			if(document.getElementById('fire_amount_' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('fire_amount_' + i + ''));
			document.form_basket.appendChild(document.getElementById('unit_id' + i + ''));
			document.form_basket.appendChild(document.getElementById('unit' + i + ''));
			if(document.getElementById('dimention' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('dimention' + i + ''));
			document.form_basket.appendChild(document.getElementById('cost_price' + i + ''));
			if(document.getElementById('total_cost_price' + i + '') != undefined)
			document.form_basket.appendChild(document.getElementById('total_cost_price' + i + ''));
			document.form_basket.appendChild(document.getElementById('money' + i + ''));
			if(document.getElementById('cost_price_2' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('cost_price_2' + i + ''));
			if(document.getElementById('cost_price_extra_2' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('cost_price_extra_2' + i + ''));
			if(document.getElementById('total_cost_price_extra_2' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('total_cost_price_extra_2' + i + ''));
			if(document.getElementById('money_2' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('money_2' + i + ''));
			if(document.getElementById('amount2_' + i + '') != undefined)
			{
				document.form_basket.appendChild(document.getElementById('amount2_' + i + ''));
				document.form_basket.appendChild(document.getElementById('unit2' + i + ''));
			}
			document.form_basket.appendChild(document.getElementById('product_name2' + i + ''));
		}	
		for(i=1;i<=row_count_exit;i++)
		{   
			//Sarf Ürün
			if(document.getElementById('is_add_info_' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('is_add_info_' + i + ''));
			document.form_basket.appendChild(document.getElementById('tree_type_exit_' + i + ''));
			document.form_basket.appendChild(document.getElementById('row_kontrol_exit' + i + ''));
			document.form_basket.appendChild(document.getElementById('cost_id_exit' + i + ''));
			document.form_basket.appendChild(document.getElementById('product_cost_exit' + i + ''));
			document.form_basket.appendChild(document.getElementById('product_cost_money_exit' + i + ''));
			document.form_basket.appendChild(document.getElementById('cost_price_system_exit' + i + ''));
			document.form_basket.appendChild(document.getElementById('money_system_exit' + i + ''));
			document.form_basket.appendChild(document.getElementById('purchase_extra_cost_system_exit' + i + ''));
			if(document.getElementById('stock_code_exit' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('stock_code_exit' + i + ''));
			document.form_basket.appendChild(document.getElementById('kdv_amount_exit' + i + ''));
			if(document.getElementById('barcode_exit' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('barcode_exit' + i + '')); 
			document.form_basket.appendChild(document.getElementById('product_id_exit' + i + ''));
			document.form_basket.appendChild(document.getElementById('stock_id_exit' + i + ''));
			document.form_basket.appendChild(document.getElementById('product_name_exit' + i + ''));
			document.form_basket.appendChild(document.getElementById('spec_main_id_exit' + i + ''));
			document.form_basket.appendChild(document.getElementById('spect_id_exit' + i + ''));
			document.form_basket.appendChild(document.getElementById('spect_name_exit' + i + ''));
			document.form_basket.appendChild(document.getElementById('lot_no_exit' + i + ''));
			document.form_basket.appendChild(document.getElementById('amount_exit' + i + ''));
			document.form_basket.appendChild(document.getElementById('amount_exit_' + i + ''));
			document.form_basket.appendChild(document.getElementById('unit_id_exit' + i + ''));
			document.form_basket.appendChild(document.getElementById('unit_exit' + i + ''));
			document.form_basket.appendChild(document.getElementById('serial_no_exit' + i + ''));
			if(document.getElementById('dimention_exit' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('dimention_exit' + i + ''));
			document.form_basket.appendChild(document.getElementById('cost_price_exit' + i + ''));
			document.form_basket.appendChild(document.getElementById('purchase_extra_cost_exit' + i + ''));
			if(document.getElementById('total_cost_price_exit' + i + '') != undefined)
			document.form_basket.appendChild(document.getElementById('total_cost_price_exit' + i + ''));
			document.form_basket.appendChild(document.getElementById('money_exit' + i + ''));
			if(document.getElementById('cost_price_exit_2' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('cost_price_exit_2' + i + ''));
			if(document.getElementById('purchase_extra_cost_exit_2' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('purchase_extra_cost_exit_2' + i + ''));
			if(document.getElementById('total_cost_price_exit_2' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('total_cost_price_exit_2' + i + ''));
			if(document.getElementById('money_exit_2' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('money_exit_2' + i + ''));
			if(document.getElementById('amount_exit2' + i + '') != undefined)
			{
				document.form_basket.appendChild(document.getElementById('amount_exit2' + i + ''));
				document.form_basket.appendChild(document.getElementById('unit2_exit' + i + ''));
			}
			if(document.getElementById('product_name2_exit' + i + '') != undefined)
			{
				document.form_basket.appendChild(document.getElementById('product_name2_exit' + i + ''));
			}
			if(document.getElementById('is_sevkiyat' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('is_sevkiyat' + i + ''));
			document.form_basket.appendChild(document.getElementById('is_production_spect_exit' + i + ''));
		}  
		for(i=1;i<=row_count_outage;i++)
		{   
			//Fire Ürün
			document.form_basket.appendChild(document.getElementById('row_kontrol_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('cost_id_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('product_cost_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('product_cost_money_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('cost_price_system_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('money_system_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('purchase_extra_cost_system_outage' + i + ''));
			if(document.getElementById('stock_code_outage' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('stock_code_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('kdv_amount_outage' + i + ''));
			if(document.getElementById('barcode_outage' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('barcode_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('product_id_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('stock_id_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('product_name_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('spec_main_id_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('spect_id_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('spect_name_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('lot_no_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('amount_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('unit_id_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('unit_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('serial_no_outage' + i + ''));
			if(document.getElementById('dimention_outage' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('dimention_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('cost_price_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('purchase_extra_cost_outage' + i + ''));
			if(document.getElementById('total_cost_price_outage' + i + '') != undefined)
			document.form_basket.appendChild(document.getElementById('total_cost_price_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('money_outage' + i + ''));
			if(document.getElementById('cost_price_outage_2' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('cost_price_outage_2' + i + ''));
			if(document.getElementById('purchase_extra_cost_outage_2' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('purchase_extra_cost_outage_2' + i + ''));
			if(document.getElementById('total_cost_price_outage_2' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('total_cost_price_outage_2' + i + ''));
			if(document.getElementById('money_outage_2' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('money_outage_2' + i + ''));
			if(document.getElementById('amount_outage2' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('amount_outage2' + i + ''));
			if(document.getElementById('unit2_outage' + i + '') != undefined)
				document.form_basket.appendChild(document.getElementById('unit2_outage' + i + ''));
			document.form_basket.appendChild(document.getElementById('product_name2_outage' + i + ''));
		}
	} 
	function open_station(){
		<cfoutput>
			stock_id = document.getElementById('stock_id1').value ;
			str = '#request.self#?fuseaction=prod.popup_list_workstation&field_name=form_basket.station_name&field_id=form_basket.station_id';
			<cfif isdefined("is_product_station_relation") and is_product_station_relation eq 1>
				str = str + '&stock_id='+stock_id ;
			</cfif>
			windowopen(str,'list');
		</cfoutput>
		}
		function find_amount2(value){
		if($("#form_basket #amount"+value).val()!='' && $("#form_basket #weight"+value).val()!='')
			{
				weight=filterNum($("#form_basket #weight"+value).val());
				amount=filterNum($("#form_basket #amount"+value).val());
				$("#form_basket #amount2_"+value).val(commaSplit(amount/weight));
			}
	}
	function find_weight(value) {
		if($("#form_basket #width"+value).val()!='' && $("#form_basket #height"+value).val()!='' && $("#form_basket #length"+value).val()!='')
		{
			dimention=filterNum($("#form_basket #width"+value).val())*filterNum($("#form_basket #height"+value).val())*filterNum($("#form_basket #length"+value).val());
			specific_weight=filterNum($("#form_basket #specific_weight"+value).val());
			$("#form_basket #weight"+value).val(commaSplit(dimention/1000*specific_weight));
		}
		find_amount2(value);
	}
	function Get_Product_Unit_2_And_Quantity_2(value) {
  <!---		elementUnit='unit2'+value;
		get_product_unit = wrk_safe_query('get_units_by_product_unit_id','dsn3',0,document.getElementById(elementUnit).value);
		_quantityValue = document.getElementById('amount'+value).value;
		_quantityValue = _quantityValue.replace(".","");
		_quantityValue = _quantityValue.replace(",",".");
		_selectValue = get_product_unit.MULTIPLIER;
		_quantityValue2=Math.ceil(_quantityValue / _selectValue);
		w=_quantityValue % _selectValue; //kalan ihtiyaç olursa diye..
		document.getElementById('amount2_'+value).value=_quantityValue2;
		return _quantityValue2; --->
		if($("#form_basket #width"+value).val()!='' && $("#form_basket #height"+value).val()!='' && $("#form_basket #length"+value).val()!='')
		{
		dimention=filterNum($("#form_basket #width"+value).val())*filterNum($("#form_basket #height"+value).val())*filterNum($("#form_basket #length"+value).val());
		weight=filterNum($("#form_basket #weight"+value).val());
		$("#form_basket #specific_weight"+value).val(commaSplit(weight*1000/dimention));
		}
		if($("#form_basket #amount2_"+value).val()!='' && $("#form_basket #weight"+value).val()!='')
			{
				weight=filterNum($("#form_basket #weight"+value).val());
				amount2=filterNum($("#form_basket #amount2_"+value).val());
				$("#form_basket #amount"+value).val(commaSplit(amount2*weight));
			}
    }
	function pencere_ac_work(no)
		{

			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&is_form_submitted=1&modal_project_head=<cfoutput><cfif len(GET_DET_PO.PROJECT_ID)>#get_project_name(GET_DET_PO.PROJECT_ID)#</cfif>&modal_project_id=<cfif len(GET_DET_PO.PROJECT_ID)>#GET_DET_PO.PROJECT_ID#</cfif></cfoutput>&field_id=form_basket.work_id' + no +'&field_name=form_basket.work_head' + no);
		}
			<!--- SARFLAR --->
	function find_amount2_exit(value){
		if($("#form_basket #amount_exit"+value).val()!='' && $("#form_basket #weight_exit"+value).val()!='')
			{
				weight=filterNum($("#form_basket #weight_exit"+value).val());
				amount=filterNum($("#form_basket #amount_exit"+value).val());
				$("#form_basket #amount_exit2_"+value).val(commaSplit(amount/weight));
			}
	}
	function find_weight_exit(value) {
		if($("#form_basket #width_exit"+value).val()!='' && $("#form_basket #height_exit"+value).val()!='' && $("#form_basket #length_exit"+value).val()!='')
		{
			dimention=filterNum($("#form_basket #width_exit"+value).val())*filterNum($("#form_basket #height_exit"+value).val())*filterNum($("#form_basket #length_exit"+value).val());
			specific_weight=filterNum($("#form_basket #specific_weight_exit"+value).val());
			$("#form_basket #weight_exit"+value).val(commaSplit(dimention/1000*specific_weight));
		}
		find_amount2_exit(value);
	}
	function Get_Product_Unit_2_And_Quantity_2_exit(value) {
		if($("#form_basket #width_exit"+value).val()!='' && $("#form_basket #height_exit"+value).val()!='' && $("#form_basket #length_exit"+value).val()!='')
		{
		dimention=filterNum($("#form_basket #width_exit"+value).val())*filterNum($("#form_basket #height_exit"+value).val())*filterNum($("#form_basket #length_exit"+value).val());
		weight=filterNum($("#form_basket #weight_exit"+value).val());
		$("#form_basket #specific_weight_exit"+value).val(commaSplit(weight*1000/dimention));
		}
		if($("#form_basket #amount_exit2_"+value).val()!='' && $("#form_basket #weight_exit"+value).val()!='')
			{
				weight=filterNum($("#form_basket #weight_exit"+value).val());
				amount2=filterNum($("#form_basket #amount_exit2_"+value).val());
				$("#form_basket #amount_exit"+value).val(commaSplit(amount2*weight));
			}
    }
	<!--- FİRELER --->
function find_amount2_outage(value){
		if($("#form_basket #amount_outage"+value).val()!='' && $("#form_basket #weight_outage"+value).val()!='')
			{
				weight=filterNum($("#form_basket #weight_outage"+value).val());
				amount=filterNum($("#form_basket #amount_outage"+value).val());
				$("#form_basket #amount_outage2_"+value).val(commaSplit(amount/weight));
			}
	}
	function find_weight_outage(value) {
		if($("#form_basket #width_outage"+value).val()!='' && $("#form_basket #height_outage"+value).val()!='' && $("#form_basket #length_outage"+value).val()!='')
		{
			dimention=filterNum($("#form_basket #width_outage"+value).val())*filterNum($("#form_basket #height_outage"+value).val())*filterNum($("#form_basket #length_outage"+value).val());
			specific_weight=filterNum($("#form_basket #specific_weight_outage"+value).val());
			$("#form_basket #weight_outage"+value).val(commaSplit(dimention/1000*specific_weight));
		}
		find_amount2_outage(value);
	}
	function Get_Product_Unit_2_And_Quantity_2_outage(value) {
		if($("#form_basket #width_outage"+value).val()!='' && $("#form_basket #height_outage"+value).val()!='' && $("#form_basket #length_outage"+value).val()!='')
		{
		dimention=filterNum($("#form_basket #width_outage"+value).val())*filterNum($("#form_basket #height_outage"+value).val())*filterNum($("#form_basket #length_outage"+value).val());
		weight=filterNum($("#form_basket #weight_outage"+value).val());
		$("#form_basket #specific_weight_outage"+value).val(commaSplit(weight*1000/dimention));
		}
		if($("#form_basket #amount_outage2_"+value).val()!='' && $("#form_basket #weight_outage"+value).val()!='')
			{
				weight=filterNum($("#form_basket #weight_outage"+value).val());
				amount2=filterNum($("#form_basket #amount_outage2_"+value).val());
				$("#form_basket #amount_outage"+value).val(commaSplit(amount2*weight));
			}
    }
	<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
	$(document).ready(function(){

		value=document.getElementById("indexCurrent").value;
		sel=document.getElementById('unit2'+value);
		for (i = 0; i < sel.length; i++) {
			opt = sel[i];
			if (document.getElementById("unit2_order").value== opt.text) {
				document.getElementById('unit2'+value).selectedIndex=opt.index;
			}
		}
		Get_Product_Unit_2_And_Quantity_2(value);
	});
	</cfif>
</script>
