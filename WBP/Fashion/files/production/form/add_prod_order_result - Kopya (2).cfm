<!---<cfsetting showdebugoutput="yes">--->
<cfsetting showdebugoutput="yes">
<cf_get_lang_set module_name="prod">

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
<cfinclude template="/V16/workdata/get_main_spect_id.cfm">
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
		PARTY_ID=#attributes.party_id# AND
		PO_RELATED_ID IS NOT NULL
		<!---PO_RELATED_ID=#attributes.p_order_id#--->
</cfquery>
<cfif get_product_parent.recordcount>
	<cfoutput query="get_product_parent">
		<cfset 'stock#STOCK_ID#_spec_main_id' = SPEC_MAIN_ID>
		<cfset 'stock#STOCK_ID#_spect_name' = SPECT_VAR_NAME>
	</cfoutput>
</cfif>
<cfquery name="GET_PAPER" datasource="#DSN3#">
	SELECT
		MAX(RESULT_NUMBER) MAX_ID
	FROM
		PRODUCTION_ORDER_RESULTS
</cfquery>
<cf_papers paper_type="production_result">

<cfquery name="get_sarf_" datasource="#dsn3#">
select
	 AMOUNT,
	 PO.P_ORDER_ID,
	 POS.STOCK_ID
FROM
	PRODUCTION_ORDERS_STOCKS POS,
	PRODUCTION_ORDERS PO
WHERE 
	POS.P_ORDER_ID=PO.P_ORDER_ID AND
	PO.PARTY_ID=#attributes.party_id# AND
	POS.TYPE=2
</cfquery>

<!--- Ana Ürün --->
<cfquery name="GET_DET_PO" datasource="#DSN3#">
	SELECT
		1 AS TYPE_PRODUCT,
		PRODUCTION_ORDERS.IS_DEMONTAJ,
		PRODUCTION_ORDERS.LOT_NO, 
		PRODUCTION_ORDERS.PARTY_ID, 
		PRODUCTION_ORDERS_MAIN.PARTY_NO,
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
    	'S' AS TREE_TYPE,
		0 AS IS_PHANTOM,
        0 AS IS_PROPERTY,
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
		PRODUCTION_ORDERS.P_ORDER_ID
	FROM
		TEXTILE_PRODUCTION_ORDERS_MAIN AS PRODUCTION_ORDERS_MAIN,
		PRODUCTION_ORDERS,
		STOCKS,
		PRODUCT_UNIT
	WHERE 
		PRODUCTION_ORDERS.PARTY_ID=PRODUCTION_ORDERS_MAIN.PARTY_ID and
		PRODUCTION_ORDERS.PARTY_ID='#attributes.party_id#' AND		
		PRODUCTION_ORDERS.STOCK_ID = STOCKS.STOCK_ID AND	
		PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
		PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND
		PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
</cfquery>

<cfset grup_uretimidleri=ValueList(GET_DET_PO.P_ORDER_ID)>
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
		<cfif len(GET_DET_PO.PARTY_ID)>
			PARTY_ID='#GET_DET_PO.PARTY_ID#'
		<cfelse>
			P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
		</cfif>
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
				<cfif len(GET_DET_PO.PARTY_ID)>
					AND POO.PARTY_ID =#attributes.party_id#
				<cfelse>
					AND POO.P_ORDER_ID =#attributes.p_order_id#
				</cfif>
				AND ISNULL(IS_FREE_AMOUNT,0) = 0
				<cfif GET_DET_PO.IS_DEMONTAJ EQ 0> AND TYPE=1<cfelse>AND TYPE=2</cfif>
		</cfquery>
		<cfquery name="GET_SUM_AMOUNT_" datasource="#DSN3#">
			SELECT 
				DISTINCT
				ISNULL(SUM(POR_.AMOUNT),0) AS SUM_AMOUNT,
				POR_.P_ORDER_ID,
				PO.QUANTITY,
				CASE WHEN ISNULL(SUM(POR_.AMOUNT),0)>= PO.QUANTITY THEN 1 ELSE 0 END AS URETIM_TAMAM
			FROM 
				PRODUCTION_ORDER_RESULTS_ROW POR_,
				PRODUCTION_ORDER_RESULTS POO,
				PRODUCTION_ORDERS PO
				
			WHERE 
				POR_.PR_ORDER_ID = POO.PR_ORDER_ID AND
				PO.P_ORDER_ID=POR_.P_ORDER_ID 
				<cfif len(GET_DET_PO.PARTY_ID)>
					AND POO.PARTY_ID =#attributes.party_id#
				<cfelse>
					AND POO.P_ORDER_ID =#attributes.p_order_id#
				</cfif>
				AND ISNULL(IS_FREE_AMOUNT,0) = 0
				<cfif GET_DET_PO.IS_DEMONTAJ EQ 0> AND TYPE=1<cfelse>AND TYPE=2</cfif>
				GROUP BY
						POR_.P_ORDER_ID,
						PO.QUANTITY
		</cfquery>
		
		<cfquery name="GET_SUM_AMOUNT_FIRE" datasource="#DSN3#">
			SELECT 
				ISNULL(SUM(POR_.AMOUNT),0) AS SUM_AMOUNT
			FROM 
				PRODUCTION_ORDER_RESULTS_ROW POR_,
				PRODUCTION_ORDER_RESULTS POO
			WHERE 
				POR_.PR_ORDER_ID = POO.PR_ORDER_ID
				<cfif len(GET_DET_PO.PARTY_ID)>
						AND POO.PARTY_ID =#attributes.party_id#
				<cfelse>
				AND POO.P_ORDER_ID =#attributes.p_order_id#
				</cfif>
				AND TYPE=3
		</cfquery>
	</cfif>
    <cfquery name="GET_ROW" datasource="#dsn3#">
        SELECT
			DISTINCT
            ORDERS.ORDER_NUMBER,
            ORDER_ROW.ORDER_ID,
            ORDER_ROW.ORDER_ROW_ID
        FROM
            PRODUCTION_ORDERS_ROW,
			PRODUCTION_ORDERS,
            ORDERS,
            ORDER_ROW
        WHERE
            PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID =PRODUCTION_ORDERS.P_ORDER_ID AND
			PRODUCTION_ORDERS.PARTY_ID=#attributes.party_id# and
            PRODUCTION_ORDERS_ROW.ORDER_ROW_ID = ORDER_ROW.ORDER_ROW_ID AND
            ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID
    </cfquery>
<cfif len(get_det_po.spect_var_id) OR len(get_det_po.spec_main_id) and (get_det_po.is_production eq 1)><!---  and (get_det_po.is_prototype eq 1) --->
	<cfquery name="GET_SUB_PRODUCTS1" datasource="#dsn3#"><!--- SARFLAR --->
		SELECT
			CAST(#createodbcdate(GET_DET_PO.START_DATE)# AS DATETIME) START_DATE,
			CAST(#createodbcdate(GET_DET_PO.FINISH_DATE)# AS DATETIME) FINISH_DATE,
			'Spec' AS NAME,
			PRODUCTION_ORDERS_STOCKS.SPECT_MAIN_ID AS RELATED_SPECT_ID,
			PRODUCTION_ORDERS_STOCKS.AMOUNT AS AMOUNT , 
			PRODUCTION_ORDERS_STOCKS.IS_FREE_AMOUNT,
			PRODUCTION_ORDERS_STOCKS.IS_SEVK,
			CASE WHEN (PRODUCTION_ORDERS_STOCKS.IS_PROPERTY = 4) THEN 'O' ELSE 'S' END AS TREE_TYPE,
			ISNULL(PRODUCTION_ORDERS_STOCKS.IS_PHANTOM,0) AS IS_PHANTOM,
			PRODUCTION_ORDERS_STOCKS.IS_PROPERTY,
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
			PRODUCTION_ORDERS_STOCKS.P_ORDER_ID
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
			<!---PRODUCTION_ORDERS_STOCKS.P_ORDER_ID = #attributes.p_order_id# AND--->
			PRODUCTION_ORDERS_STOCKS.P_ORDER_ID IN(#grup_uretimidleri#) AND
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
			'P' AS TREE_TYPE,<!--- BURADAKİ TREE_TYPE'IN P OLMASI ÜRÜNÜN FANTOM OLDUĞUNU GÖSTERİR.. --->
			ISNULL(PRODUCTION_ORDERS_STOCKS.IS_PHANTOM,0) AS IS_PHANTOM,
			PRODUCTION_ORDERS_STOCKS.IS_PROPERTY,
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
			PRODUCTION_ORDERS_STOCKS.P_ORDER_ID
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
			<!---PRODUCTION_ORDERS_STOCKS.P_ORDER_ID = #attributes.p_order_id# AND--->
					PRODUCTION_ORDERS_STOCKS.P_ORDER_ID IN(#grup_uretimidleri#) AND
			PRODUCTION_ORDERS_STOCKS.IS_PHANTOM = 1 AND
			PRODUCTION_ORDERS_STOCKS.IS_PROPERTY IN(0,4) AND
			PRODUCTION_ORDERS_STOCKS.TYPE = 2 AND
			<cfif get_det_po.is_demontaj eq 1> PRODUCTION_ORDERS_STOCKS.IS_SEVK = 0 AND</cfif> <!--- IS_PROPERTY = 0 YANI SADE CE SARFLAR GELSİN. --->
			PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
			STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
	</cfquery>
	<cfquery name="GET_SUB_PRODUCTS" datasource="#dsn3#"><!--- SARFLAR --->
	SELECT
		START_DATE,
		FINISH_DATE,
		NAME,
		RELATED_SPECT_ID,
		SUM(AMOUNT) AMOUNT, 
		IS_FREE_AMOUNT,
		IS_SEVK,
		TREE_TYPE,
		IS_PHANTOM,
		IS_PROPERTY,
		PRODUCT_COST_ID,
		STOCK_CODE,
		PRODUCT_NAME,
		PRODUCT_ID,
		STOCK_ID,
		BARCOD,
		ADD_UNIT,
		MAIN_UNIT,
		DIMENTION,
		IS_PRODUCTION,
		TAX,
		TAX_PURCHASE,
		PRODUCT_UNIT_ID,
		AVG(PRICE) PRICE,
		MONEY,
		PROPERTY, 
		SUB_SPEC_MAIN_ID,
		0 P_ORDER_ID,
		LOT_NO
	FROM
	(
		SELECT
			CAST(#createodbcdate(GET_DET_PO.START_DATE)# AS DATETIME) START_DATE,
			CAST(#createodbcdate(GET_DET_PO.FINISH_DATE)# AS DATETIME) FINISH_DATE,
			'Spec' AS NAME,
			PRODUCTION_ORDERS_STOCKS.SPECT_MAIN_ID AS RELATED_SPECT_ID,
			ISNULL(PRODUCTION_ORDERS_STOCKS.AMOUNT,0) AS AMOUNT , 
			PRODUCTION_ORDERS_STOCKS.IS_FREE_AMOUNT,
			PRODUCTION_ORDERS_STOCKS.IS_SEVK,
			CASE WHEN (PRODUCTION_ORDERS_STOCKS.IS_PROPERTY = 4) THEN 'O' ELSE 'S' END AS TREE_TYPE,
			ISNULL(PRODUCTION_ORDERS_STOCKS.IS_PHANTOM,0) AS IS_PHANTOM,
			PRODUCTION_ORDERS_STOCKS.IS_PROPERTY,
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
			PRODUCTION_ORDERS_STOCKS.P_ORDER_ID,
			PRODUCTION_ORDERS_STOCKS.LOT_NO
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
			<!---PRODUCTION_ORDERS_STOCKS.P_ORDER_ID = #attributes.p_order_id# AND--->
			PRODUCTION_ORDERS_STOCKS.P_ORDER_ID IN(#grup_uretimidleri#) AND
			PRODUCTION_ORDERS_STOCKS.IS_PROPERTY IN(0,2,3,4) AND
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
			'P' AS TREE_TYPE,<!--- BURADAKİ TREE_TYPE'IN P OLMASI ÜRÜNÜN FANTOM OLDUĞUNU GÖSTERİR.. --->
			ISNULL(PRODUCTION_ORDERS_STOCKS.IS_PHANTOM,0) AS IS_PHANTOM,
			PRODUCTION_ORDERS_STOCKS.IS_PROPERTY,
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
			PRODUCTION_ORDERS_STOCKS.P_ORDER_ID,
			PRODUCTION_ORDERS_STOCKS.LOT_NO
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
			<!---PRODUCTION_ORDERS_STOCKS.P_ORDER_ID = #attributes.p_order_id# AND--->
					PRODUCTION_ORDERS_STOCKS.P_ORDER_ID IN(#grup_uretimidleri#) AND
			PRODUCTION_ORDERS_STOCKS.IS_PHANTOM = 1 AND
			PRODUCTION_ORDERS_STOCKS.IS_PROPERTY IN(0,4,99) AND
			PRODUCTION_ORDERS_STOCKS.TYPE = 2 AND
			<cfif get_det_po.is_demontaj eq 1> PRODUCTION_ORDERS_STOCKS.IS_SEVK = 0 AND</cfif> <!--- IS_PROPERTY = 0 YANI SADE CE SARFLAR GELSİN. --->
			PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
			STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
		
	)
		AS
			RAPOR
			GROUP BY
					START_DATE,
					FINISH_DATE,
					NAME,
					RELATED_SPECT_ID,
					IS_FREE_AMOUNT,
					IS_SEVK,
					TREE_TYPE,
					IS_PHANTOM,
					IS_PROPERTY,
					PRODUCT_COST_ID,
					STOCK_CODE,
					PRODUCT_NAME,
					PRODUCT_ID,
					STOCK_ID,
					BARCOD,
					ADD_UNIT,
					MAIN_UNIT,
					DIMENTION,
					IS_PRODUCTION,
					TAX,
					TAX_PURCHASE,
					PRODUCT_UNIT_ID,
					MONEY,
					PROPERTY, 
					SUB_SPEC_MAIN_ID,
					LOT_NO
	</cfquery>
	<!---<cfdump var="#GET_SUB_PRODUCTS#">--->
	<cfquery name="GET_SUB_PRODUCTS_FIRE" datasource="#dsn3#"><!--- Fireler --->
		SELECT
			CAST(#createodbcdate(GET_DET_PO.START_DATE)# AS DATETIME) START_DATE,
			CAST(#createodbcdate(GET_DET_PO.FINISH_DATE)# AS DATETIME) FINISH_DATE,
			'Spec' AS NAME,
			PRODUCTION_ORDERS_STOCKS.SPECT_MAIN_ID AS RELATED_SPECT_ID,
			CASE WHEN PRODUCTION_ORDERS_STOCKS.TYPE = 2 THEN 1 ELSE PRODUCTION_ORDERS_STOCKS.AMOUNT END AS AMOUNT,
			PRODUCTION_ORDERS_STOCKS.IS_SEVK,
			CASE WHEN (PRODUCTION_ORDERS_STOCKS.IS_PROPERTY = 4) THEN 'O' ELSE 'S' END AS TREE_TYPE,
			ISNULL(PRODUCTION_ORDERS_STOCKS.IS_PHANTOM,0) AS IS_PHANTOM,
			PRODUCTION_ORDERS_STOCKS.IS_PROPERTY,
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
			0 AS SUB_SPEC_MAIN_ID
		FROM
			PRODUCTION_ORDERS_STOCKS,
			PRODUCTION_ORDERS,
			STOCKS,
			PRODUCT_UNIT,
			PRICE_STANDART
		WHERE
			PRODUCTION_ORDERS_STOCKS.P_ORDER_ID=PRODUCTION_ORDERS.P_ORDER_ID AND
			PRODUCTION_ORDERS_STOCKS.STOCK_ID = STOCKS.STOCK_ID AND
			PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
			PRICE_STANDART.PURCHASESALES = 1 AND
			PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			STOCKS.STOCK_STATUS = 1	AND
			ISNULL(IS_PHANTOM,0) = 0 AND
			PRODUCTION_ORDERS.PARTY_ID = #attributes.party_id# AND
			<cfif x_add_fire_product eq 1><!--- Eğer sarf ürünleri fire olarak gelsin seçilmişse 0 ve 2 olanlar geliyor --->
				PRODUCTION_ORDERS_STOCKS.TYPE IN(2,3) AND
			<cfelse>
				PRODUCTION_ORDERS_STOCKS.TYPE = 3 AND
				(ISNULL(PRODUCTION_ORDERS_STOCKS.FIRE_AMOUNT,0)<>0 OR ISNULL(PRODUCTION_ORDERS_STOCKS.FIRE_RATE,0)<>0 OR PRODUCTION_ORDERS_STOCKS.TYPE = 3)  AND
			</cfif>
			<cfif get_det_po.is_demontaj eq 1> PRODUCTION_ORDERS_STOCKS.IS_SEVK = 0 AND</cfif>
			PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
			STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
	<cfif x_add_fire_product eq 1><!--- eğer phantom ürün var ise... --->
	UNION ALL
		SELECT
			CAST(#createodbcdate(GET_DET_PO.START_DATE)# AS DATETIME) START_DATE,
			CAST(#createodbcdate(GET_DET_PO.FINISH_DATE)# AS DATETIME) FINISH_DATE,
			'Spec' AS NAME,
			PRODUCTION_ORDERS_STOCKS.SPECT_MAIN_ID AS RELATED_SPECT_ID,
			1 AS AMOUNT,
			PRODUCTION_ORDERS_STOCKS.IS_SEVK,
			'P' AS TREE_TYPE,<!--- BURADAKİ TREE_TYPE'IN P OLMASI ÜRÜNÜN FANTOM OLDUĞUNU GÖSTERİR.. --->
			ISNULL(PRODUCTION_ORDERS_STOCKS.IS_PHANTOM,0) AS IS_PHANTOM,
			PRODUCTION_ORDERS_STOCKS.IS_PROPERTY,
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
			0 AS SUB_SPEC_MAIN_ID<!--- BU ALAN SARF SATIRINA GELEN ÜRÜNÜN HANGİ SPEC'E BAĞLI OLDUĞUNU GÖSTERMEK İÇİN KONULDU.. --->
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
			<!---PRODUCTION_ORDERS_STOCKS.P_ORDER_ID = #attributes.p_order_id# AND--->
				PRODUCTION_ORDERS.LOT_NO IN(SELECT LOT_NO FROM PRODUCTION_ORDERS WHERE P_ORDER_ID=#attributes.p_order_id#)  AND
			PRODUCTION_ORDERS_STOCKS.IS_PROPERTY IN(0,2) AND
			PRODUCTION_ORDERS_STOCKS.TYPE = 2 AND
			<cfif get_det_po.is_demontaj eq 1> PRODUCTION_ORDERS_STOCKS.IS_SEVK = 0 AND</cfif> <!--- IS_PROPERTY = 0 YANI SADE CE SARFLAR GELSİN. --->
			PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
			STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
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
				PRODUCT_TREE.IS_FREE_AMOUNT,
				PRODUCT_TREE.IS_SEVK,
				'S' AS TREE_TYPE,
				ISNULL(PRODUCT_TREE.IS_PHANTOM,0) AS IS_PHANTOM,
				0 AS IS_PROPERTY,
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
				0 AS SUB_SPEC_MAIN_ID
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
		</cfquery>
	</cfif>
</cfif>
<!<cfquery name="GET_DET_PO_2" dbtype="query">
	SELECT 0 AS TYPE_PRODUCT,0 AS IS_DEMONTAJ,'' LOT_NO,0 PARTY_ID,'' PARTY_NO,'' DETAIL,0 STATION_ID,0 SPEC_MAIN_ID,0 SPECT_VAR_ID,'' REFERANS,'' P_ORDER_NO,0 PROJECT_ID,0 ORDER_ID,0 IS_PROTOTYPE,* FROM GET_SUB_PRODUCTS WHERE IS_FREE_AMOUNT = 1
</cfquery>
<cfquery name="GET_DET_PO" dbtype="query">
	SELECT * FROM GET_DET_PO
	<!---UNION ALL
	SELECT * FROM GET_DET_PO_2--->
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
<!-------------------------------------------------------------------------------------------------->
<!------------------------------ BU BÖLÜMDEN ÜSTTE KALANLAR SQL SORGULARI -------------------------->
<!-------------------------------------------------------------------------------------------------->
<div id="prod_stock_and_spec_detail_div" align="center" style="position:absolute;width:300px; height:150; overflow:auto;z-index:1;"></div>
<style type="text/css">
	.detail_basket_list tbody tr.operasyon td {background-color:#FFCCCC !important;}
	.detail_basket_list tbody tr.phantom td {background-color:#FFCC99 !important;}
</style>

<!--------------------------------------------KÜNYE------------------------------------------------>
<cfquery name="get_req_id" datasource="#dsn3#">
	SELECT * FROM TEXTILE_SAMPLE_REQUEST WHERE PROJECT_ID=#GET_DET_PO.PROJECT_ID#
</cfquery>

<cfscript>
	CreateCompenent = CreateObject("component","WBP.Fashion.files.cfc.get_sample_request");
	attributes.req_id=get_req_id.req_id;
	getAsset=CreateCompenent.getAssetRequest(action_id:#attributes.req_id#,action_section:'REQ_ID');
</cfscript>

<div class="row">
	<cfinclude template="../../sales/query/get_req.cfm">
	<div class="col col-12">
		<cf_box id="sample_request" closable="1" unload_body = "1"  title="Numune Özet" >
			<div class="col col-10 col-xs-12 ">
					<cfinclude template="/V16/sales/query/get_opportunity_type.cfm">
					<cfinclude template="../../sales/display/dsp_sample_request.cfm">
			</div>
			<div class="col col-2 col-xs-2">
				<cfinclude template="../../objects/display/asset_image.cfm">
			</div>
		</cf_box>
	</div>
</div>
<!--------------------------------------------KÜNYE------------------------------------------------>

<!------------------------------------FORM ALANI BAŞLANGICI---------------------------------------->

<cf_catalystHeader>
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=textile.emptypopup_add_prod_order_result_act" onsubmit="newRows()">
	<input type="hidden" name="is_changed_spec_main" id="is_changed_spec_main" value="<cfoutput>#is_changed_spec_main#</cfoutput>">
	<!---<input type="hidden" name="p_order_id" id="p_order_id" value="<cfoutput>#attributes.p_order_id#</cfoutput>">--->
	<input type="hidden" name="party_id" id="party_id" value="<cfoutput>#attributes.party_id#</cfoutput>">
	<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
	<input type="hidden" name="is_demontaj" id="is_demontaj" value="<cfoutput>#get_det_po.is_demontaj#</cfoutput>">
	<input type="hidden" name="round_number" id="round_number" value="<cfoutput>#round_number#</cfoutput>">
<cfoutput query="get_money">
    <input type="hidden" name="hidden_rd_money_#CURRENTROW#" id="hidden_rd_money_#CURRENTROW#" value="#money#">
    <input type="hidden" name="txt_rate1_#CURRENTROW#" id="txt_rate1_#CURRENTROW#" value="#tlformat(rate1)#">
    <input type="hidden" name="txt_rate2_#CURRENTROW#" id="txt_rate2_#CURRENTROW#" value="#tlformat(rate2,session.ep.our_company_info.rate_round_num)#">
</cfoutput>

<cf_basket_form id="order_result">
	<cf_object_main_table>
    <div class="row">
	    <div class="col col-9 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    	<div class="form-group" id="item-process_cat">
	                    	<label class="col col-4 col-xs-12"><cf_get_lang no='447.İşlem Kategorisi'> *</label>
	                        <div class="col col-8 col-xs-12">
	                        	<cf_workcube_process_cat slct_width="140" module_id="26">
	                        </div>
	                    </div>
                        <div class="form-group" id="item-production_order_no">
	                    	<label class="col col-4 col-xs-12">Parti Üretim Emir No *</label>
	                        <div class="col col-8 col-xs-12">
	                        	<input type="text" name="production_order_no" id="production_order_no" value="<cfoutput>#GET_DET_PO.p_order_no#</cfoutput>" readonly maxlength="25" style="width:140px;">
	                        </div>
	                    </div>
                        <div class="form-group" id="item-order_no">
	                    	<label class="col col-4 col-xs-12"><cf_get_lang_main no='799.Siparis No'> *</label>
	                        <div class="col col-8 col-xs-12">
	                        	<input type="text" name="order_no" id="order_no" value="<cfif isdefined("get_row.order_number")><cfoutput>#valuelist(get_row.order_number,',')#</cfoutput></cfif>" readonly maxlength="25" style="width:140px;">
                    			<input type="hidden" name="order_row_id" id="order_row_id" value="<cfif isdefined("get_row.order_number")><cfoutput>#listdeleteduplicates(valuelist(get_row.ORDER_ROW_ID,','))#</cfoutput></cfif>">
	                        </div>
	                    </div>
                        <div class="form-group" id="item-expense_employee">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='452.İşlemi Yapan'></label>
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
	                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='243.Başlama'> *</label>
	                        <div class="col col-8 col-xs-12">
	                            <div class="input-group">
	                            	<input type="hidden" name="_popup" id="_popup" value="2">
									<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='243.Başlama Tarihi'></cfsavecontent>
									<cfinput type="text" name="start_date" id="start_date" required="Yes" message="#message#" validate="eurodate" value="#dateformat(get_det_po.start_date,'dd/mm/yyyy')#" style="width:65px;">
	                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
		                            <span class="input-group-addon">
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
                                    </span>
                                    <span class="input-group-addon">
                                    	<select name="start_m" id="start_m">
											<cfloop from="0" to="60" index="i">
												<option value="#i#" <cfif value_start_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#i# </option>
											</cfloop>
										</select>
										</cfoutput>
                                    </span>
	                            </div>
	                        </div>
	                    </div>
                        <div class="form-group" id="item-finish_date">
	                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='288.Bitiş Tarihi'> *</label>
	                        <div class="col col-8 col-xs-12">
	                            <div class="input-group">
	                            	<input type="hidden" name="_popup" id="_popup" value="2">
				                    <cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='288.Bitiş Tarihi'></cfsavecontent>
				                    <cfinput required="Yes" message="#message#" type="text" name="finish_date" id="finish_date" validate="eurodate" value="#dateformat(get_det_po.finish_date,'dd/mm/yyyy')#" style="width:65px;" onBlur="change_money_info('form_basket','finish_date');">
	                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date" call_function="change_money_info"></span>
		                            <span class="input-group-addon">
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
                                    </span>
                                    <span class="input-group-addon">
                                    	<select name="finish_m" id="finish_m">
                                            <cfloop from="0" to="60" index="i">
                                                <option value="#i#" <cfif value_finish_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#i# </option>
                                            </cfloop>
                                        </select>
                                    </cfoutput>	
                                    </span>
	                            </div>
	                        </div>
	                    </div>
                        <div class="form-group" id="item-production_result_no">
	                    	<label class="col col-4 col-xs-12"><cf_get_lang no='449.Sonuç No'></label>
	                        <div class="col col-8 col-xs-12">
                    			<input type="text" name="production_result_no" id="production_result_no" value="<cfoutput>#paper_full#</cfoutput>" readonly style="width:167px;" maxlength="25">							
	                        </div>
	                    </div>
                        <div class="form-group" id="item-project_name">
	                    	<label class="col col-4 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
	                        <div class="col col-8 col-xs-12">
			                    <input type="hidden" name="project_id" id="project_id" value="<cfif len(GET_DET_PO.PROJECT_ID)><cfoutput>#GET_DET_PO.PROJECT_ID#</cfoutput></cfif>">
			                    <input type="text" name="project_name" id="project_name" value="<cfif len(GET_DET_PO.PROJECT_ID)><cfoutput>#get_project_name(GET_DET_PO.PROJECT_ID)#</cfoutput></cfif>" readonly style="width:167px;">
	                        </div>
	                    </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    	<div class="form-group" id="item-process">
	                    	<label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç"></label>
	                        <div class="col col-8 col-xs-12">
                    			<cf_workcube_process is_upd='0' process_cat_width='130' is_detail='0'>
	                        </div>
	                    </div>
                        <div class="form-group" id="item-lot_no">
	                    	<label class="col col-4 col-xs-12"><cf_get_lang no='385.Lot No'></label>
	                        <div class="col col-8 col-xs-12">
			                    <input type="hidden" name="old_lot_no" id="old_lot_no" value="<cfoutput>#GET_DET_PO.lot_no#</cfoutput>">
			                    <input type="text" name="lot_no" id="lot_no" value="<cfoutput>#GET_DET_PO.lot_no#</cfoutput>" onKeyup="lotno_control(1,1);" <cfif isdefined("x_lot_no") and x_lot_no eq 0>readonly</cfif> maxlength="25" style="width:130px;">                                
	                        </div>
	                    </div>
                        <div class="form-group" id="item-station_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1422.İstasyon'> *</label>
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
	                    	<label class="col col-4 col-xs-12"><cf_get_lang_main no='1372.Referans'></label>
	                        <div class="col col-8 col-xs-12">
                    			<input type="text" name="ref_no" id="ref_no" value="<cfoutput>#get_det_po.REFERANS#</cfoutput>" style="width:130px;">
	                        </div>
	                    </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    	<div class="form-group" id="item-location">
	                    	<label class="col col-4 col-xs-12"><cf_get_lang no='448.Sarf Depo'></label>
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
	                    	<label class="col col-4 col-xs-12"><cf_get_lang no='450.Üretim Depo'></label>
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
	                    	<label class="col col-4 col-xs-12"><cf_get_lang no='451.Sevkiyat Depo'></label>
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
			                            department_fldId="enter_department_id"
			                            user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
			                            line_info = 3
			                            user_location = 0
			                            width="170">
			                    </cfif>		
	                        </div>
	                    </div>
                        <div class="form-group" id="item-detailLen">
	                    	<label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
	                        <div class="col col-8 col-xs-12">
								<textarea name="reference_no" id="reference_no" maxlength="500" style="width:167px;height:73px;" onkeydown="counter(this.form.reference_no,this.form.detailLen,500);return ismaxlength(this);" onkeyup="counter(this.form.reference_no,this.form.detailLen,500);return ismaxlength(this);" onblur="return ismaxlength(this);"><cfif len(get_det_po.detail)><cfoutput>#get_det_po.detail#</cfoutput></cfif></textarea>
								<input type="text" name="detailLen"  id="detailLen" size="1"  style="width:25px;" value="500" readonly class="no-bg text-right"/>                              
	                        </div>
	                    </div>
                    </div>
      			</div>
                <div class="row formContentFooter">
                    <div class="col col-12">
                        <cfquery name="get_prod_operation" datasource="#dsn3#">
							SELECT TOP 1 PRODUCTION_ORDER_OPERATIONS.P_ORDER_ID FROM PRODUCTION_ORDER_OPERATIONS,PRODUCTION_ORDERS WHERE PRODUCTION_ORDER_OPERATIONS.P_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID AND PRODUCTION_ORDERS.PARTY_ID=#attributes.party_id#
						</cfquery>
						<cfif get_prod_operation.recordcount>
							<font color="#FF0000">İlişkili Üretim Emri Operatör Ekranında Başlatıldığı İçin Sonlandırma İşlemini Operatör Ekranından Yapabilirsiniz . <a href="<cfoutput>#request.self#?fuseaction=production.form_add_production_order&upd=#attributes.p_order_id#">#get_det_po.p_order_no#</cfoutput></a> </font>
						<cfelse>
							<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
						</cfif>
                    </div>
                </div>
    		</div>
    	</div>
    </div>
<!------------------------------------FORM ALANI BİTİŞİ---------------------------------------->	

<!----------------------------ÜRETİM SONUCU BASKET ALANI BAŞLANGISI---------------------------->	
<div class="row">
	<div class="col col-9 col-xs-12 uniqueRow">
		<div class="row formContent">
			<div class="form-group" id="item-detailLen">
<!------------------------------------BARKOD EKLEME ALANI-------------------------------------->
				<cf_basket id="order_result_bask">
				<cf_seperator header="#getLang('main',1854)#" id="table1">
				<iframe name="add_prod" id="add_prod" frameborder="0" vspace="0" hspace="0" scrolling="no" src="<cfoutput>#request.self#?fuseaction=prod.popup_add_production_result&iframe=1</cfoutput>" width="100%" height="50"></iframe>
<!------------------------------------BARKOD EKLEME ALANI-------------------------------------->				
				<cf_form_list id="table3">
					<thead>
						<th width="10">
							<tr>
								<th>
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
								<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_product#xml_str#</cfoutput>&type=1&record_num=' + form_basket.record_num.value,'list')"><img id="add_row_image" src="/images/plus_list.gif" align="absmiddle" border="0"></a>
								</th>
								<th width="30"><cf_get_lang_main no='106.Stok Kodu'></th>
								<cfif x_is_barkod_col eq 1><th width="90"><cf_get_lang_main no='221.Barkod'></th></cfif>
								<th width="70"><cf_get_lang_main no='40.Stok'></th>
								<th width="70" style="display:<cfoutput>#spec_img_display#</cfoutput>"><cf_get_lang_main no='235.spect'></th>
								<th width="60"><cf_get_lang_main no='223.Miktar'></th>
								<th width="60"><cf_get_lang_main no='223.Miktar'></th>
								<cfif x_is_fire_product eq 1>
								<th width="60"><cf_get_lang_main no='1674.Fire'></th>
								</cfif>
								<th width="60"><cf_get_lang_main no='224.Birim'></th>
								<cfif x_is_show_abh eq 1>
								<!---<th width="60">a*b*h</th>--->
								</cfif>
								<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
								<th width="100" style="text-align:right;"><cf_get_lang no='454.Birim Maliyet'></th>
								<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
								<th width="100" style="text-align:right;"><cf_get_lang no='499.Toplam Maliyet'></th>
								</cfif>
								<th width="50"><cf_get_lang_main no='77.Para Br'></th>
								<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
								<th width="100" style="text-align:right;"><cf_get_lang no='454.Birim Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
								<th width="100" style="text-align:right;"><cf_get_lang no='499.Toplam Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									</cfif>
								<th width="50"><cf_get_lang_main no='77.Para Br'></th>
									</cfif>
								</cfif>
								<cfif is_show_two_units eq 1>
									<th width="60">2.<cf_get_lang_main no='223.Miktar'></th>
									<th width="60">2.<cf_get_lang_main no='224.Birim'></th>
								</cfif>
								<cfif is_show_product_name2 eq 1>
									<th width="70">2.<cf_get_lang_main no='217.Açıklama'></th>
								</cfif>
							</tr>
						</th>
					</thead>
					<tbody>
					<!--- Ana ürün --->
					<cfset mamul_recordcount = EVALUATE('#sonuc_query#.recordcount')>
					<input type="hidden" name="mamul_recordcount" id="mamul_recordcount" value="<cfoutput>#mamul_recordcount#</cfoutput>"> 
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
							<cfset sifirmiktarli_mamul_gizle=0>
							<cfif GET_ROW_AMOUNT.RECORDCOUNT>
								<cfquery name="get_prod_result_sum_amount" dbtype="query">
									select *from get_sum_amount_ where P_ORDER_ID=#P_ORDER_ID#
								</cfquery>
								<cfif get_prod_result_sum_amount.uretim_tamam eq 1>
									<cfset sifirmiktarli_mamul_gizle=1>
								</cfif>
								
							</cfif>
							<input type="hidden" name="cost_id#currentrow#" id="cost_id#currentrow#" value="#get_product.product_cost_id#">
							<tr id="frm_row#currentrow#" <cfif sifirmiktarli_mamul_gizle>style="display:none;"</cfif> <cfif TREE_TYPE is 'P' >bgcolor="FFCCCC"<cfelseif TREE_TYPE is 'O'>bgcolor="FFCC99"</cfif>>
							<td>	  
								<input type="hidden" value="#p_order_id#" name="sub_p_order_id#currentrow#" id="sub_p_order_id#currentrow#">
								<input type="hidden" name="is_free_amount_#currentrow#" id="is_free_amount_#currentrow#" value="#is_free_amount#">
								<input type="hidden" name="tree_type_#currentrow#" id="tree_type_#currentrow#" value="#TREE_TYPE#">
								<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="<cfif sifirmiktarli_mamul_gizle>0<cfelse>1</cfif>">
								<input type="hidden" name="product_cost#currentrow#" id="product_cost#currentrow#" value="#product_cost#"><!--- giydirilmiş maliyet --->
								<input type="hidden" name="product_cost_money#currentrow#" id="product_cost_money#currentrow#" value="#product_cost_money#"><!--- giydirilmiş maliyet para birimi--->
								<input type="hidden" name="kdv_amount#currentrow#" id="kdv_amount#currentrow#" value="#tax#"><!--- ürün kdv oranı //tax_purchase--->
								<input type="hidden" name="cost_price_system#currentrow#" id="cost_price_system#currentrow#" value="#cost_price_system#">
								<input type="hidden" name="purchase_extra_cost_system#currentrow#" id="purchase_extra_cost_system#currentrow#" value="#purchase_extra_cost_system#">
								<input type="hidden" name="purchase_extra_cost#currentrow#" id="purchase_extra_cost#currentrow#" value="#purchase_extra_cost#">
								<input type="hidden" name="money_system#currentrow#" id="money_system#currentrow#" value="#cost_price_system_money#">
								<a style="cursor:pointer" onclick="sil('#currentrow#');"><img src="images/delete_list.gif" border="0" align="absmiddle" title="<cf_get_lang_main no='51.Sil'>"></a>
							</td>
							<td><input type="text" name="STOCK_CODE#currentrow#" id="STOCK_CODE#currentrow#" value="#STOCK_CODE#" style="width:120px; border:none;" readonly=""></td>
								<cfif x_is_barkod_col eq 1>
							<td><input type="text" name="barcode#currentrow#" id="barcode#currentrow#" value="#barcod#" style="width:120px; border:none;" readonly=""></td>
								</cfif>
							<td nowrap="nowrap">
								<input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#"   value="#product_id#" style="width:120px; border:none;">
								<input type="hidden" name="stock_id#currentrow#"   id="stock_id#currentrow#"     value="#stock_id#"   style="width:120px; border:none;">
								<input type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="#product_name# #property#" readonly style="width:192px; border:none;">
								<a href="javascript://" onClick="get_stok_spec_detail_ajax('#product_id#');"><img src="/images/plus_thin_p.gif" style="cursor:pointer;" align="absmiddle" border="0" title="Stok Detay"></a>
							</td>
							<td style="display:#spec_img_display#;" nowrap="nowrap">
							<cfif ( isdefined('#sonuc_query#.spec_main_id') and len(evaluate('#sonuc_query#.spec_main_id')) and evaluate('#sonuc_query#.spec_main_id') gt 0) or (isdefined('#sonuc_query#.spect_var_id') and len(evaluate('#sonuc_query#.spect_var_id')) and evaluate('#sonuc_query#.spect_var_id') gt 0)><!--- demontajda GET_SUB_PRODUCTS querysi calistigi icin burda spect olmamali yari mamulün spectini bilemeyiz--->
								<cfquery name="GET_SPECT" datasource="#dsn3#">
									<cfif len(evaluate('#sonuc_query#.spect_var_id'))>
										SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = #evaluate('#sonuc_query#.spect_var_id')#
									<cfelse>
										SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = #evaluate('#sonuc_query#.SPEC_MAIN_ID')#
									</cfif>
								</cfquery>
								<input type="hidden" value="#evaluate('#sonuc_query#.spect_var_id')#" name="spect_id_#currentrow#" id="spect_id_#currentrow#" style="width:120px; border:none;">
								<input type="#Evaluate('spec_display')#" value="#evaluate('#sonuc_query#.SPEC_MAIN_ID')#" name="spec_main_id#currentrow#" id="spec_main_id#currentrow#" readonly style="width:40px; border:none;">
								<input type="#Evaluate('spec_display')#" value="#evaluate('#sonuc_query#.spect_var_id')#" name="spect_id#currentrow#" id="spect_id#currentrow#" readonly style="width:40px; border:none;">
								<input type="#Evaluate('spec_name_display')#" name="spect_name#currentrow#" id="spect_name#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:150px; border:none;">
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
								<input type="#Evaluate('spec_display')#" name="spec_main_id#currentrow#" id="spec_main_id#currentrow#" value="<cfif isdefined('stock#STOCK_ID#_spec_main_id')>#Evaluate('stock#STOCK_ID#_spec_main_id')#</cfif>" readonly style="width:40px; border:none;">
								<input type="#Evaluate('spec_display')#" value="" name="spect_id#currentrow#" id="spect_id#currentrow#" readonly style="width:40px; border:none;">
								<input type="#Evaluate('spec_name_display')#" name="spect_name#currentrow#" id="spect_name#currentrow#" value="#_spec_main_name__#" readonly style="width:150px; border:none;">
							</cfif>
								<a href="javascript://" onClick="pencere_ac_spect('#currentrow#');"><img src="/images/plus_thin.gif" style="display:#spec_img_display#" align="absmiddle" border="0"></a>
							</td>
							<td style="text-align:center";>#AMOUNT#</td>
							<td style="text-align:center";>
									<div id="miktar_sonuc_#currentrow#"></div>
							<cfset _AMOUNT_ = wrk_round(AMOUNT,8,1)>
							<cfif get_det_po.is_demontaj eq 1><!---demontajda miktar carpmali Demontaj alt ürünler--->
								<cfif GET_ROW_AMOUNT.RECORDCOUNT>
									<cfif len(get_prod_result_sum_amount.SUM_AMOUNT)>
										<cfset kalan_uretim_miktarı = _AMOUNT_-get_prod_result_sum_amount.SUM_AMOUNT>
									<cfelse>
										<cfset kalan_uretim_miktarı = _AMOUNT_-0>
									</cfif>
									<cfif kalan_uretim_miktarı lt 0><cfset kalan_uretim_miktarı = 1></cfif>
									<cfset kalan_uretim_miktarı_new = kalan_uretim_miktarı>
									<input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#kalan_uretim_miktarı#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,1);" class="moneybox" style="width:70px; border:none;" <cfif is_change_amount_demontaj eq 0>readonly=""</cfif>>
							</td>
							
								   <input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="#kalan_uretim_miktarı#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,1);" class="moneybox" style="width:60px; border:none;" <cfif is_change_amount_demontaj eq 0>readonly=""</cfif>>
								<cfelseif NOT GET_ROW_AMOUNT.RECORDCOUNT>
									<cfset kalan_uretim_miktarı_new = _AMOUNT_><!--- #TlFormat(_AMOUNT_*get_det_po.AMOUNT,8)# --->
								   <input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#_AMOUNT_#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,1);" class="moneybox" style="width:70px; border:none;" <cfif is_change_amount_demontaj eq 0>readonly=""</cfif>></td>
								   <input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="#_AMOUNT_#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,1);" class="moneybox" style="width:60px; border:none;" <cfif is_change_amount_demontaj eq 0>readonly=""</cfif>>
								</cfif>	
								
							<cfelse><!--- Normal ürün ismi --->
							
								<cfif GET_ROW_AMOUNT.RECORDCOUNT AND TYPE_PRODUCT eq 1>
											<cfif len(get_prod_result_sum_amount.SUM_AMOUNT)>
												<cfset kalan_uretim_miktarı = _AMOUNT_-get_prod_result_sum_amount.SUM_AMOUNT>
											<cfelse>
													<cfset kalan_uretim_miktarı = _AMOUNT_-0>
											</cfif>
									
									<cfif kalan_uretim_miktarı lt 0><cfset kalan_uretim_miktarı = 1></cfif>
									<input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#kalan_uretim_miktarı#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,1);aktar('#p_order_id#','#currentrow#');" class="moneybox" style="width:70px; border:none;">
									</td>
									<input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="#_AMOUNT_#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,1);aktar('#p_order_id#','#currentrow#');" class="moneybox" style="width:60px; border:none;">
								<cfelseif NOT GET_ROW_AMOUNT.RECORDCOUNT or TYPE_PRODUCT eq 0>
									<cfset kalan_uretim_miktarı = _AMOUNT_>
									<input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#_AMOUNT_#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,1);aktar('#p_order_id#','#currentrow#');" class="moneybox" style="width:70px; border:none;"></td>
									<input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="#_AMOUNT_#" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,1);aktar('#p_order_id#','#currentrow#');" class="moneybox" style="width:60px; border:none;">
								<cfelseif _AMOUNT_ eq GET_SUM_AMOUNT.SUM_AMOUNT>
									<cfset kalan_uretim_miktarı = _AMOUNT_>
									<input type="text" name="amount#currentrow#" id="amount#currentrow#" value="0" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,1);aktar('#p_order_id#','#currentrow#');" class="moneybox" style="width:70px; border:none;"onClick="aktar('#p_order_id#','#currentrow#');"></td>
									<input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="0" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,1);aktar('#p_order_id#','#currentrow#');" class="moneybox" style="width:60px; border:none;"onClick="aktar('#p_order_id#','#currentrow#');"> 
								</cfif>	
							</cfif>
							<cfif x_is_fire_product eq 1>
								<td>
									<input type="text" class="moneybox" name="fire_amount_#currentrow#" id="fire_amount_#currentrow#" value="0" style="width:60px; border:none;" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(#currentrow#,3);aktar('#p_order_id#','#currentrow#');">
								</td>
							</cfif>
							<td>
								<input type="hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="#product_unit_id#">
								<input type="text" name="unit#currentrow#" id="unit#currentrow#" value="#main_unit#" readonly style="width:60px; border:none;">
							</td>
								<!---<cfif x_is_show_abh eq 1>
							<td><input type="text" name="dimention#currentrow#" id="dimention#currentrow#" value="#dimention#" readonly style="width:60px;"></td>
								</cfif>--->
							  <cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
								<td><input type="text" name="cost_price#currentrow#" style="width:125px; border:none;" id="cost_price#currentrow#" value="#TLFormat(cost_price,8)#" class="moneybox" readonly></td>
								<td><input type="text" name="money#currentrow#" id="money#currentrow#" value="#cost_price_money#" readonly style="width:50px; border:none;"></td>
								<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
									<td><input type="text" name="cost_price_2#currentrow#" id="cost_price_2#currentrow#" style="width:125px; border:none;" value="#TLFormat(cost_price_2,8)#" class="moneybox" readonly></td>
									<input type="hidden" name="cost_price_extra_2#currentrow#" id="cost_price_extra_2#currentrow#" value="#TLFormat(purchase_extra_cost_system_2,8)#">
									<td><input type="text" name="money_2#currentrow#" id="money_2#currentrow#" value="#cost_price_money_2#" readonly style="width:50px; border:none;"></td>
								</cfif>
							<cfelse>
								<input type="hidden" name="cost_price#currentrow#" id="cost_price#currentrow#" value="#TLFormat(cost_price,8)#">
								<input type="hidden" name="money#currentrow#" id="money#currentrow#" value="#cost_price_money#">
								<input type="hidden" name="cost_price_2#currentrow#" id="cost_price_2#currentrow#" value="#TLFormat(cost_price_2,8)#">
								<input type="hidden" name="cost_price_extra_2#currentrow#" id="cost_price_extra_2#currentrow#" value="#TLFormat(purchase_extra_cost_system_2,8)#">
								<input type="hidden" name="money_2#currentrow#" id="money_2#currentrow#" value="#cost_price_money_2#">
							</cfif>
							<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
							<td><input type="text" name="amount2_#currentrow#" id="amount2_#currentrow#" value="" onKeyup="return(FormatCurrency(this,event,8));" onBlur="" class="moneybox" style="width:70px; border:none;"></td>
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
								<select name="unit2#currentrow#" id="unit2#currentrow#" style="width:60; border:none;">
								<cfloop query="get_all_unit2">
									<option value="#PRODUCT_UNIT_ID#">#ADD_UNIT#</option>
								</cfloop>
								</select>
							</td>
							</cfif>
							<td style="display:#product_name2_display#"><input type="text" style="width:70px; border:none;" name="product_name2#currentrow#" id="product_name2#currentrow#" value=""></td>
						</tr>
						<cfif get_det_po.is_demontaj eq 1>
							<cfscript>
								if(len(GET_PRODUCT.PURCHASE_NET_SYSTEM))
									demontaj_cost_price_system = demontaj_cost_price_system+kalan_uretim_miktarı_new*GET_PRODUCT.PURCHASE_NET_SYSTEM;
								if(len(GET_PRODUCT.PURCHASE_NET_SYSTEM_2))
									demontaj_cost_price_system_2 = demontaj_cost_price_system_2+kalan_uretim_miktarı_new*GET_PRODUCT.PURCHASE_NET_SYSTEM_2;
								if(len(GET_PRODUCT.PURCHASE_EXTRA_COST_SYSTEM))
									demontaj_purchase_extra_cost_system =demontaj_purchase_extra_cost_system+kalan_uretim_miktarı_new*GET_PRODUCT.PURCHASE_EXTRA_COST_SYSTEM;
							</cfscript>
						</cfif>
						</cfoutput>
					</tbody>
				</cf_form_list>
			</div>
		</div>
	</div>
</div>
<!-------------------------------ÜRETİM SONUCU BASKET ALANI SONU-------------------------------->






</cf_object_main_table>          
</cf_basket_form>
</cfform>


<cf_get_lang_set module_name="textile"><!--- sayfanin en ustunde acilisi var --->