<div id="prod_stock_and_spec_detail_div" align="center" style="position:absolute;width:300px; height:150; overflow:auto;z-index:1;"></div>
<style type="text/css">
	.detail_basket_list tbody tr.operasyon td {background-color:#FFCCCC !important;}
	.detail_basket_list tbody tr.phantom td {background-color:#FFCC99 !important;}
</style>
<cfinclude template="../../workdata/get_main_spect_id.cfm">
<cfset is_show_spec_id = 1>
<cfset is_show_spec_name = 1>
<cfset is_show_spec_id = 0>
<cfset is_change_amount_demontaj = 1>
<cfset is_changed_spec_main = 1>
<cfset process_type_111 = 1>
<cfset process_type_112 = 1>
<cfset process_type_81 = 1>
<cfset process_type_110 = 1>
<cfset process_type_119 = 1>
<cfset round_number = 2>
<cfset is_change_station = 1>
<cfset x_pro_add_barkod_and_seri_no = 1>
<cfset xml_str = ''>
<cfset x_is_barkod_col = 1>
<cfset x_is_fire_product = 1>
<cfset x_is_show_abh = 1>
<cfset is_show_two_units = 1>
<cfset is_show_product_name2 = 1>
<cfset x_is_show_sb = 1>
<cfset x_fis_kontrol = 1>
<cfset x_is_show_labor_cost = 1>
<cfset x_is_show_refl_cost = 1>
<cfset is_stock_control_with_spec = 1>
<cfset x_por_amount_lte_po = 1>
<cfset x_add_fire_product = 1>
<cfset is_change_sarf_cost = 1>
<cfif is_show_product_name2 eq 1><cfset product_name2_display =""><cfelse><cfset product_name2_display='none'></cfif>
<cfif is_show_spec_id eq 1><cfset spec_display = 'text'><cfelse><cfset spec_display = 'hidden'></cfif>
<cfif is_show_spec_name eq 1><cfset spec_name_display = 'text'><cfelse><cfset spec_name_display = 'hidden'></cfif>
<cfif is_show_spec_id eq 0 and isdefined('is_show_spec_name') and is_show_spec_name eq 0><cfset spec_img_display="none"><cfelse><cfset spec_img_display=""></cfif>
<cfif is_change_amount_demontaj eq 1><cfset _readonly_ =''><cfelse><cfset _readonly_ = 'readonly'></cfif>
<cfif not isdefined("is_changed_spec_main")>
	<cfset is_changed_spec_main = 0>
</cfif>
<cfquery name="GET_PRODUCT_PARENT" datasource="#DSN3#"><!---Üretim emri verilen alt ürün varmı?Varsa buna bağlı olarak oluşan spectleri buraya yansıtıcaz! --->
	SELECT 
		SPECT_VAR_ID,
		SPECT_VAR_NAME,
        SPEC_MAIN_ID,
		STOCK_ID
	FROM
		PRODUCTION_ORDERS
	WHERE 
		PO_RELATED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#"> 
</cfquery>
<cfif get_product_parent.recordcount>
	<cfoutput query="get_product_parent">
		<cfset 'stock#stock_id#_spec_main_id' = spec_main_id>
		<cfset 'stock#stock_id#_spect_name' = spect_var_name>
	</cfoutput>
</cfif>
<cfquery name="GET_PAPER" datasource="#DSN3#">
	SELECT
		MAX(RESULT_NUMBER) MAX_ID
	FROM
		PRODUCTION_ORDER_RESULTS
</cfquery>
<cf_papers paper_type="production_result">
<!--- Ana Ürün --->
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
        <!--- 0 LINE_NUMBER, --->
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
		WRK_ROW_ID
	FROM
		PRODUCTION_ORDERS,
		STOCKS,
		PRODUCT_UNIT
	WHERE 
		PRODUCTION_ORDERS.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#"> AND 
		PRODUCTION_ORDERS.STOCK_ID = STOCKS.STOCK_ID AND	
		PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
		PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND
		PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
</cfquery>
<!--- 
	bu kısım phantom ürün ağaçları için eklendi.Ana amaç üretim emrinde seçilen spec'e göre
	ilgili ürün ağacındaki phantom ağacı bulmak ve üretim sonucundaki
	sarflar kısmına bu phantom ürünü değil onun bileşenlerini getirmek...
 --->
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT 
    	MONEY,
        RATE1,
        RATE2 
    FROM 
    	MONEY_HISTORY 
    WHERE 
    	MONEY_HISTORY_ID IN(SELECT MAX(MONEY_HISTORY_ID) FROM MONEY_HISTORY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"> AND VALIDATE_DATE <= #createodbcdatetime(get_det_po.finish_date)# GROUP BY MONEY)
</cfquery>
<cfif get_money.recordcount eq 0>
	<cfquery name="GET_MONEY" datasource="#DSN2#">
		SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY
	</cfquery>
</cfif>
<cfquery name="GET_ROW_AMOUNT" datasource="#DSN3#">
	SELECT 
		PR_ORDER_ID
	FROM 
		PRODUCTION_ORDER_RESULTS
	WHERE 
		P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#"> 
</cfquery>

<cfif get_row_amount.recordcount>
	<cfquery name="GET_SUM_AMOUNT" datasource="#DSN3#">
		SELECT 
			ISNULL(SUM(POR_.AMOUNT),0) AS SUM_AMOUNT
		FROM 
			PRODUCTION_ORDER_RESULTS_ROW POR_,
			PRODUCTION_ORDER_RESULTS POO
		WHERE 
			POR_.PR_ORDER_ID = POO.PR_ORDER_ID AND
			POO.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#"> AND
			POR_.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_det_po.stock_id#">
			<cfif len(get_det_po.spec_main_id)>
				AND POR_.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_det_po.spec_main_id#">
			</cfif>
			AND ISNULL(IS_FREE_AMOUNT,0) = 0
			<cfif get_det_po.is_demontaj eq 0> AND TYPE=1 <cfelse> AND TYPE=2 </cfif>
	</cfquery>
	<cfquery name="GET_SUM_AMOUNT_FIRE" datasource="#DSN3#">
		SELECT 
			ISNULL(SUM(POR_.AMOUNT),0) AS SUM_AMOUNT
		FROM 
			PRODUCTION_ORDER_RESULTS_ROW POR_,
			PRODUCTION_ORDER_RESULTS POO
		WHERE 
			POR_.PR_ORDER_ID = POO.PR_ORDER_ID
			AND POO.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#"> AND
			POR_.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_det_po.stock_id#">
			<cfif len(get_det_po.spec_main_id)>
				AND POR_.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_det_po.spec_main_id#">
			</cfif>
			AND TYPE=3
	</cfquery>
</cfif>
<cfquery name="GET_ROW" datasource="#DSN3#">
	SELECT
		ORDERS.ORDER_NUMBER,
		ORDER_ROW.ORDER_ID,
		ORDER_ROW.ORDER_ROW_ID
	FROM
		PRODUCTION_ORDERS_ROW,
		ORDERS,
		ORDER_ROW
	WHERE
		PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#"> AND
		PRODUCTION_ORDERS_ROW.ORDER_ROW_ID = ORDER_ROW.ORDER_ROW_ID AND
		ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID
</cfquery>
<cfif len(get_det_po.spect_var_id) OR len(get_det_po.spec_main_id) and (get_det_po.is_production eq 1)><!---  and (get_det_po.is_prototype eq 1) --->
	<cfquery name="GET_SUB_PRODUCTS" datasource="#DSN3#"><!--- SARFLAR --->
		SELECT
			CAST(#createodbcdate(GET_DET_PO.START_DATE)# AS DATETIME) START_DATE,
			CAST(#createodbcdate(GET_DET_PO.FINISH_DATE)# AS DATETIME) FINISH_DATE,
			'Spec' AS NAME,
			PRODUCTION_ORDERS_STOCKS.SPECT_MAIN_ID AS RELATED_SPECT_ID,
			PRODUCTION_ORDERS_STOCKS.AMOUNT AS AMOUNT , 
			PRODUCTION_ORDERS_STOCKS.IS_FREE_AMOUNT,
			PRODUCTION_ORDERS_STOCKS.IS_SEVK,
            <!---PRODUCTION_ORDERS_STOCKS.LINE_NUMBER,--->
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
			WRK_ROW_ID
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
			PRODUCTION_ORDERS_STOCKS.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#"> AND
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
            <!---PRODUCTION_ORDERS_STOCKS.LINE_NUMBER,--->
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
			WRK_ROW_ID
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
			PRODUCTION_ORDERS_STOCKS.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#"> AND
			PRODUCTION_ORDERS_STOCKS.IS_PHANTOM = 1 AND
			PRODUCTION_ORDERS_STOCKS.IS_PROPERTY IN(0,4) AND
			PRODUCTION_ORDERS_STOCKS.TYPE = 2 AND
			<cfif get_det_po.is_demontaj eq 1> PRODUCTION_ORDERS_STOCKS.IS_SEVK = 0 AND</cfif> <!--- IS_PROPERTY = 0 YANI SADE CE SARFLAR GELSİN. --->
			PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
			STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
        <!---<cfif isdefined('is_line_number') and is_line_number eq 1>
            ORDER BY
                PRODUCTION_ORDERS_STOCKS.LINE_NUMBER
        </cfif>--->
	</cfquery>
	<cfquery name="GET_SUB_PRODUCTS_FIRE" datasource="#DSN3#"><!--- Fireler --->
		SELECT
			CAST(#createodbcdate(GET_DET_PO.START_DATE)# AS DATETIME) START_DATE,
			CAST(#createodbcdate(GET_DET_PO.FINISH_DATE)# AS DATETIME) FINISH_DATE,
			'Spec' AS NAME,
			PRODUCTION_ORDERS_STOCKS.SPECT_MAIN_ID AS RELATED_SPECT_ID,
			CASE WHEN PRODUCTION_ORDERS_STOCKS.TYPE = 2 THEN 1 ELSE PRODUCTION_ORDERS_STOCKS.AMOUNT END AS AMOUNT,
			PRODUCTION_ORDERS_STOCKS.IS_SEVK,
            <!---PRODUCTION_ORDERS_STOCKS.LINE_NUMBER,--->
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
			0 AS SUB_SPEC_MAIN_ID,
			WRK_ROW_ID
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
			PRODUCTION_ORDERS_STOCKS.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#"> AND
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
                        <!---PRODUCTION_ORDERS_STOCKS.LINE_NUMBER,--->
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
                        0 AS SUB_SPEC_MAIN_ID<!--- BU ALAN SARF SATIRINA GELEN ÜRÜNÜN HANGİ SPEC'E BAĞLI OLDUĞUNU GÖSTERMEK İÇİN KONULDU.. --->,
                        WRK_ROW_ID
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
                        PRODUCTION_ORDERS_STOCKS.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#"> AND
                        PRODUCTION_ORDERS_STOCKS.IS_PROPERTY IN(0,2) AND
                        PRODUCTION_ORDERS_STOCKS.TYPE = 2 AND
                        <cfif get_det_po.is_demontaj eq 1> PRODUCTION_ORDERS_STOCKS.IS_SEVK = 0 AND</cfif> <!--- IS_PROPERTY = 0 YANI SADE CE SARFLAR GELSİN. --->
                        PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
                        STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
            </cfif>
			<!---<cfif isdefined('is_line_number') and is_line_number eq 1>
                ORDER BY
                    PRODUCTION_ORDERS_STOCKS.LINE_NUMBER
            </cfif> --->
	</cfquery>
	<cfif get_sub_products.recordcount eq 0>
		<cfquery name="GET_SUB_PRODUCTS" datasource="#DSN3#">
			SELECT 
				CAST(#createodbcdate(GET_DET_PO.START_DATE)# AS DATETIME) START_DATE,
				CAST(#createodbcdate(GET_DET_PO.FINISH_DATE)# AS DATETIME) FINISH_DATE,
			   'Ağaç' AS NAME,
				PRODUCT_TREE.SPECT_MAIN_ID AS RELATED_SPECT_ID,
				PRODUCT_TREE.AMOUNT AS AMOUNT,
				PRODUCT_TREE.IS_FREE_AMOUNT,
				PRODUCT_TREE.IS_SEVK,
                <!---ISNULL(PRODUCT_TREE.LINE_NUMBER,0) LINE_NUMBER,--->
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
				0 AS SUB_SPEC_MAIN_ID,
				'' WRK_ROW_ID
			FROM 
				PRODUCT_TREE,
				STOCKS,
				PRODUCT_UNIT
			WHERE 
				PRODUCT_TREE.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_det_po.stock_id#"> AND 
				STOCKS.STOCK_ID = PRODUCT_TREE.RELATED_ID AND
				STOCKS.STOCK_STATUS = 1	AND
				PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
				<cfif get_det_po.is_demontaj eq 1>AND PRODUCT_TREE.IS_SEVK = 0</cfif>
		</cfquery>
	</cfif>
</cfif>
<cfquery name="GET_DET_PO_2" dbtype="query">
	SELECT 0 AS TYPE_PRODUCT,0 AS IS_DEMONTAJ,'' LOT_NO,'' DETAIL,0 STATION_ID,0 SPEC_MAIN_ID,0 SPECT_VAR_ID,'' REFERANS,'' P_ORDER_NO,0 PROJECT_ID,0 ORDER_ID,0 IS_PROTOTYPE,* FROM GET_SUB_PRODUCTS WHERE IS_FREE_AMOUNT = 1
</cfquery>
<cfquery name="GET_DET_PO" dbtype="query">
	SELECT * FROM GET_DET_PO
	UNION ALL
	SELECT * FROM GET_DET_PO_2
</cfquery>
<cfif len(get_det_po.station_id)>
	<cfquery name="GET_STATION" datasource="#DSN3#">
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
			STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_det_po.station_id#">
	</cfquery>
</cfif>
<table class="dph">
    <tr>
		<td class="dpht"><a href="javascript:gizle_goster_ikili('order_result','order_result_bask');">&raquo;</a><cf_get_lang_main no='1854.Üretim Sonucu'> : <cfoutput>#get_det_po.p_order_no#</cfoutput></td>
    </tr>
</table>
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_prod_order_result&is_changed_spec_main=#is_changed_spec_main#" onsubmit="newRows()">
<input type="hidden" name="p_order_id" id="p_order_id" value="<cfoutput>#attributes.p_order_id#</cfoutput>">
<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
<input type="hidden" name="is_demontaj" id="is_demontaj" value="<cfoutput>#get_det_po.is_demontaj#</cfoutput>">
<input type="hidden" name="round_number" id="round_number" value="<cfoutput>#round_number#</cfoutput>">
<input type="hidden" name="process_cat" id="process_cat" value="115" /> <!--- Üretim Sonucu --->
<cfoutput query="get_money">
    <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
    <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#tlformat(rate1)#">
    <input type="hidden" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="">
</cfoutput>
<table>
	<tr>
    	<td style="vertical-align:top;">
            <table>
                <tr>
                    <td>Üretim Emir No *</td>
                    <td><input type="text" name="production_order_no" id="production_order_no" value="<cfoutput>#get_det_po.p_order_no#</cfoutput>" readonly maxlength="25" style="width:140px;"></td>
                </tr>
                <tr>
                    <td type="text"><cf_get_lang_main no='799.Sipariş No'> *</td>
                    <td>
                        <input type="text" name="order_no" id="order_no" value="<cfif isdefined("get_row.order_number")><cfoutput>#valuelist(get_row.order_number,',')#</cfoutput></cfif>" readonly maxlength="25" style="width:140px;">
                        <input type="hidden" name="order_row_id" id="order_row_id" value="<cfif isdefined("get_row.order_number")><cfoutput>#listdeleteduplicates(valuelist(get_row.order_row_id,','))#</cfoutput></cfif>">
                    </td>
                </tr>
                <tr>
                    <td type="text">İşlemi Yapan</td>
                    <td>
                        <input type="hidden" name="expense_employee_id" id="expense_employee_id" value="">
                        <input type="text" name="expense_employee" id="expense_employee" value="" style="width:140px;">
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_list_positions&field_emp_id=form_basket.expense_employee_id&field_name=form_basket.expense_employee&select_list=1','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>								
                    </td>
                </tr>
            </table>
        </td>
        <td style="vertical-align:top;">
			<table>
                <tr>
                    <td type="text"><cf_get_lang_main no='243.Başlama'> *</td>
                    <td>
                        <input type="hidden" name="_popup" id="_popup" value="2">
                        <cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='243.Başlama Tarihi'></cfsavecontent>
                        <cfinput type="text" name="start_date" id="start_date" required="Yes" message="#message#" validate="eurodate" value="#dateformat(get_det_po.start_date,'dd/mm/yyyy')#" style="width:65px;">
                        <cf_wrk_date_image date_field="start_date">
                        <cfoutput>
                        <cfif len(get_det_po.start_date)>
                            <cfset value_start_h = hour(get_det_po.start_date)>
                            <cfset value_start_m = minute(get_det_po.start_date)>
                        <cfelse>
                            <cfset value_start_h = 0>
                            <cfset value_start_m = 0>
                        </cfif>
                        <select name="start_h" id="start_h" style="width:40px;">
                            <option value="0">00</option>
                            <cfloop from="0" to="23" index="i">
                                <option value="#i#" <cfif value_start_h eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                            </cfloop>
                        </select>
                        <select name="start_m" id="start_m" style="width:40px;">
                            <cfloop from="0" to="60" index="i">
                                <option value="#i#" <cfif value_start_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#i# </option>
                            </cfloop>
                        </select>
                        </cfoutput>
                    </td>
                </tr>
                <tr id="form_ul_finish_date" extra_select="finish_h,finish_m" title="#header_#">
                    <td type="text"><cf_get_lang_main no='288.Bitiş Tarihi'> *</td>
                    <td>
                        <input type="hidden" name="_popup" id="_popup" value="2">
                        <cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='288.Bitiş Tarihi'></cfsavecontent>
                        <cfinput required="Yes" message="#message#" type="text" name="finish_date" id="finish_date" validate="eurodate" value="#dateformat(get_det_po.finish_date,'dd/mm/yyyy')#" style="width:65px;" passthrough="onBlur=""change_money_info('form_basket','finish_date');""">
                        <cf_wrk_date_image date_field="finish_date" call_function="change_money_info">
                        <cfoutput>
                            <select name="finish_h" id="finish_h" style="width:40px;">
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
                            <select name="finish_m" id="finish_m" style="width:40px;">
                                <cfloop from="0" to="60" index="i">
                                    <option value="#i#" <cfif value_finish_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#i# </option>
                                </cfloop>
                            </select>
                        </cfoutput>								
                    </td>
                </tr>
                <tr>
                    <td type="text">Sonuç No</td>
                    <td><input type="text" name="production_result_no" id="production_result_no" value="<cfoutput>#paper_full#</cfoutput>" maxlength="25" readonly style="width:167px;">							</td>
                </tr>
                <tr>
                    <td type="text"><cf_get_lang_main no='4.Proje'></td>
                    <td>
                        <input type="hidden" name="project_id" id="project_id" value="<cfif len(get_det_po.project_id)><cfoutput>#get_det_po.project_id#</cfoutput></cfif>">
                        <input type="text" name="project_name" id="project_name" value="<cfif len(get_det_po.project_id)><cfoutput>#get_project_name(get_det_po.project_id)#</cfoutput></cfif>" readonly style="width:167px;">
                    </td>
                </tr>
			</table>
        </td>
        <td style="vertical-align:top;">
        	<table>
                <tr>
                    <td type="text"><cf_get_lang_main no="1447.Süreç"></td>
                    <td><cf_workcube_process is_upd='0' process_cat_width='130' is_detail='0'></td>
                </tr>
				<tr>
                    <td type="text">Lot No</td>
                    <td>
                        <input type="hidden" name="old_lot_no" id="old_lot_no" value="<cfoutput>#get_det_po.lot_no#</cfoutput>">
                        <input type="text" name="lot_no" id="lot_no" value="<cfoutput>#get_det_po.lot_no#</cfoutput>" <cfif isdefined("x_lot_no") and x_lot_no eq 0>readonly</cfif> maxlength="25" style="width:130px;">                                
                    </td>
                </tr>
                <tr>
                    <td type="text"><cf_get_lang_main no='1422.İstasyon'> *</td>
                    <td>
                        <cfif len(get_det_po.station_id)>
                            <input type="hidden" name="station_id" id="station_id" value="<cfoutput>#get_det_po.station_id#</cfoutput>">
                            <input type="text" name="station_name" id="station_name" value="<cfoutput>#get_station.station_name#</cfoutput>" readonly style="width:130px;">
                        <cfelse>
                            <input type="hidden" name="station_id" id="station_id" value="">
                            <input type="text" name="station_name" id="station_name" readonly style="width:130px;">
                        </cfif>
                        <!--- <a href="javascript://" onclick="temizle(1);windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_list_workstation&field_name=form_basket.station_name&field_id=form_basket.station_id</cfoutput>','medium')"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a> --->
                    </td>
                </tr>
                <tr>
                    <td type="text"><cf_get_lang_main no='1372.Referans'></td>
                    <td><input type="text" name="ref_no" id="ref_no" value="<cfoutput>#get_det_po.referans#</cfoutput>" style="width:130px;"></td>
                </tr>
            </table>
        </td>
        <td style="vertical-align:top;">
        	<table>
                <tr>
                    <td type="text">Sarf Depo</td>
                    <td>
                        <cfif isdefined("get_station.exit_dep_id") and len(get_station.exit_dep_id)>
                            <cfquery name="GET_EXIT_DEP" datasource="#DSN#">
                                SELECT
                                    DEPARTMENT_HEAD
                                FROM 
                                    DEPARTMENT
                                WHERE
                                    DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_station.exit_dep_id#">
                            </cfquery>
                            <cfquery name="GET_EXIT_LOC" datasource="#DSN#">
                                SELECT
                                    COMMENT
                                FROM
                                    STOCKS_LOCATION
                                WHERE
                                    LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_station.exit_loc_id#"> AND
                                    DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_station.exit_dep_id#">
                            </cfquery>
                            <input type="hidden" name="branch_id"  id="branch_id" value="">
                            <input type="hidden" name="exit_department_id" id="exit_department_id" value="<cfoutput>#get_station.exit_dep_id#</cfoutput>">
                            <input type="hidden" name="exit_location_id" id="exit_location_id" value="<cfoutput>#get_station.exit_loc_id#</cfoutput>">
                            <input type="text" name="exit_department" id="exit_department" style="width:170px" value="<cfoutput>#get_exit_dep.department_head# - #get_exit_loc.comment#</cfoutput>">
                            <!---<cf_wrkdepartmentlocation
                                returnInputValue="exit_location_id,exit_department,exit_department_id,branch_id"
                                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                fieldName="exit_department"
                                fieldid="exit_location_id"
                                department_fldId="exit_department_id"
                                department_id="#get_station.exit_dep_id#"
                                location_id="#get_station.exit_loc_id#"
                                location_name="#get_exit_dep.department_head# - #get_exit_loc.comment#"
                                user_level_control=""
                                line_info = 1
                                width="170">--->
                        <cfelse>
                            <input type="hidden" name="branch_id"  id="branch_id" value="">
                            <input type="hidden" name="exit_department_id" id="exit_department_id" value="">
                            <input type="hidden" name="exit_location_id" id="exit_location_id" value="">
                            <input type="text" name="exit_department" id="exit_department" style="width:170px" value="<cfoutput>#get_exit_dep.department_head# - #get_exit_loc.comment#</cfoutput>">

                           <!--- <cf_wrkdepartmentlocation
                                returnInputValue="exit_location_id,exit_department,exit_department_id,branch_id"
                                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                fieldName="exit_department"
                                fieldid="exit_location_id"
                                department_fldId="exit_department_id"
                                user_level_control=""
                                line_info = 1
                                width="170"> --->
                        </cfif>
                        <cfif get_det_po.is_demontaj eq 1><!--- TolgaS 20060912 demontaj isleminde depo seceneleri ters olmali --->
                            <cfset location_type =3>
                        <cfelse>
                            <cfset location_type =1>			
                        </cfif>								
                    </td>
				</tr>
               	<tr>
                    <td type="text">Üretim Depo</td>
                    <td>
						<cfif isdefined("get_station.production_dep_id") and len(get_station.production_dep_id)>
                            <cfquery name="GET_PRODUCTION_DEP" datasource="#DSN#">
                                SELECT
                                    DEPARTMENT_HEAD,
                                    BRANCH_ID
                                FROM 
                                    DEPARTMENT
                                WHERE
                                    DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_station.production_dep_id#">
                            </cfquery>
                            <cfquery name="GET_PRODUCTION_LOC" datasource="#DSN#">
                                SELECT
                                    COMMENT
                                FROM
                                    STOCKS_LOCATION
                                WHERE
                                    LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_station.production_loc_id#"> AND
                                    DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_station.production_dep_id#">
                            </cfquery>
                            <!---<cf_wrkdepartmentlocation
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
                                user_level_control=""
                                line_info = 2
                                width="170">--->
                     		<input type="hidden" name="production_branch_id"  id="production_branch_id" value="<cfoutput>#get_production_dep.branch_id#</cfoutput>">
                            <input type="hidden" name="production_department_id" id="production_department_id" value="<cfoutput>#get_station.production_dep_id#</cfoutput>">
                            <input type="hidden" name="production_location_id" id="production_location_id" value="<cfoutput>#get_station.production_loc_id#</cfoutput>">
                            <input type="text" name="production_department" id="production_department" value="<cfoutput>#get_production_dep.department_head# - #get_production_loc.comment#</cfoutput>" style="width:170px" onblur="compenentInputValueEmptyinglocation_2(this);" autocomplete="off"> <!---onkeypress="if(event.keyCode==13) {compenentAutoCompletelocation_2(this,'wrkDepartmentLocationDiv_production_department','&IS_STORE_KONTROL=1&BOXHEIGHT=200&DEPARTMENT_ID=26&BOXWIDTH=250&BRANCH_ID=1&IS_STORE_MODULE=0&DEPARTMENT_FLDID=production_department_id&STATUS=1&LINE_INFO=2&RETURNINPUTVALUE=production_location_id,production_department,production_department_id,production_branch_id&FIELDID=production_location_id&FIELDNAME=production_department&LOCATION_NAME=Üretim Yönetimi Şefliği - Üretim Depo&COMPENENT_NAME=get_department_location&ADDPAGEURL=project.addpro&RETURNQUERYVALUE=LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID&IS_DEPARTMENT=0&WIDTH=170&JS_PAGE=0&LOCATION_ID=1&BRANCH_FLDID=production_branch_id&UPDPAGEURL=project.prodetailâ–ˆid=&USER_LOCATION=1&LISTPAGE=0&RETURNQUERYVALUE2=DEPARTMENT_ID,DEPARTMENT_HEAD&IS_SUBMIT=0&TITLE=Departman - Lokasyon&columnList=LOCATION_NAME@Lokasyon,'); return false;}"--->
                        <cfelse>
                            <!--- <cf_wrkdepartmentlocation
                                returnInputValue="production_location_id,production_department,production_department_id,production_branch_id"
                                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                fieldName="production_department"
                                fieldid="production_location_id"
                                department_fldId="production_department_id"
                                branch_fldId="production_branch_id"
                                user_level_control=""
                                line_info = 2
                                width="170"> --->
                     		<input type="hidden" name="production_branch_id"  id="production_branch_id" value="">
                            <input type="hidden" name="production_department_id" id="production_department_id" value="">
                            <input type="hidden" name="production_location_id" id="production_location_id" value="">
                            <input type="text" name="production_department" id="production_department" value="" style="width:170px" onblur="compenentInputValueEmptyinglocation_2(this);" autocomplete="off">
                        </cfif>
                        <cfif get_det_po.is_demontaj eq 1><!--- TolgaS 20060912 demontaj isleminde depo seceneleri ters olmali --->
                            <cfset location_type =1>
                        <cfelse>
                            <cfset location_type =3>			
                        </cfif>														
                    </td>
                </tr> 
            	<tr>
                    <td type="text">Sevkiyat Depo</td>
                    <td>
                        <cfif isdefined("get_station.enter_dep_id") and len(get_station.enter_dep_id)>
                            <cfquery name="GET_ENTER_DEP" datasource="#DSN#">
                                SELECT
				    				DEPARTMENT_ID ENTER_DEP_ID,
                                    DEPARTMENT_HEAD
                                FROM 
                                    DEPARTMENT
                                WHERE
                                    DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_station.enter_dep_id#">
                            </cfquery>
                            <cfquery name="GET_ENTER_LOC" datasource="#DSN#">
                                SELECT
                                	LOCATION_ID ENTER_LOC_ID,
                                    COMMENT
                                FROM
                                    STOCKS_LOCATION
                                WHERE
                                    LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_station.enter_loc_id#"> AND
                                    DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_station.enter_dep_id#">							
                            </cfquery>
                            <!---<cf_wrkdepartmentlocation
                                returnInputValue="enter_location_id,enter_department,enter_department_id,branch_id"
                                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                fieldName="enter_department"
                                fieldid="enter_location_id"
                                department_fldId="enter_department_id"
                                department_id="#get_station.enter_dep_id#"
                                location_id="#get_station.enter_loc_id#"
                                location_name="#get_enter_dep.department_head# - #get_enter_loc.comment#"
                                user_level_control=""
                                line_info = 3
                                width="170">--->
                            <input type="hidden" name="branch_id"  id="branch_id" value="">
                            <input type="hidden" name="enter_department_id" id="enter_department_id" value="<cfoutput>#get_enter_dep.enter_dep_id#</cfoutput>">
                            <input type="hidden" name="enter_location_id" id="enter_location_id" value="<cfoutput>#get_enter_loc.enter_loc_id#</cfoutput>">
                            <input type="text" name="enter_department" id="enter_department" value="<cfoutput>#get_enter_dep.department_head# - #get_enter_loc.comment#</cfoutput>"  autocomplete="off" style="width:170px" onblur="compenentInputValueEmptyinglocation_3(this);">
                        <cfelse><!---  onkeypress="if(event.keyCode==13) {compenentAutoCompletelocation_3(this,'wrkDepartmentLocationDiv_enter_department','&IS_STORE_KONTROL=1&BOXHEIGHT=200&BOXWIDTH=250&IS_STORE_MODULE=0&DEPARTMENT_FLDID=enter_department_id&STATUS=1&LINE_INFO=3&RETURNINPUTVALUE=enter_location_id,enter_department,enter_department_id,branch_id&FIELDID=enter_location_id&FIELDNAME=enter_department&COMPENENT_NAME=get_department_location&ADDPAGEURL=project.addpro&RETURNQUERYVALUE=LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID&IS_DEPARTMENT=0&WIDTH=170&JS_PAGE=0&BRANCH_FLDID=branch_id&UPDPAGEURL=project.prodetailâ–ˆid=&USER_LOCATION=1&LISTPAGE=0&RETURNQUERYVALUE2=DEPARTMENT_ID,DEPARTMENT_HEAD&IS_SUBMIT=0&TITLE=Departman - Lokasyon&columnList=LOCATION_NAME@Lokasyon,'); return false;}"--->
                            <!--- <cf_wrkdepartmentlocation
                                returnInputValue="enter_location_id,enter_department,enter_department_id,branch_id"
                                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                fieldName="enter_department"
                                fieldid="enter_location_id"
                                department_fldId="enter_department_id"
                                user_level_control=""
                                line_info = 3
                                width="170"> --->
                            <input type="hidden" name="branch_id"  id="branch_id" value="">
                            <input type="hidden" name="enter_department_id" id="enter_department_id" value="">
                            <input type="hidden" name="enter_location_id" id="enter_location_id" value="">
                            <input type="text" name="enter_department" id="enter_department" value=""  autocomplete="off" style="width:170px" onblur="compenentInputValueEmptyinglocation_3(this);">                                
                        </cfif>
                        <cfif get_det_po.is_demontaj eq 1><!--- TolgaS 20060912 demontaj isleminde depo seceneleri ters olmali --->
                            <cfset location_type =1>
                        <cfelse>
                            <cfset location_type =3>			
                        </cfif>					
                    </td>
                </tr>
            </table>
		</td>
        <td style="vertical-align:top;">
        	<table>
            	<tr>
                	<td><cf_get_lang_main no='217.Açıklama'></td>
                    <td>
                        <textarea name="reference_no" id="reference_no" maxlength="500" style="width:167px;height:73px;" onkeydown="counter(this.form.reference_no,this.form.detailLen,500);return ismaxlength(this);" onkeyup="counter(this.form.reference_no,this.form.detailLen,500);return ismaxlength(this);" onblur="return ismaxlength(this);"><cfif len(get_det_po.detail)><cfoutput>#get_det_po.detail#</cfoutput></cfif></textarea>
                        <input type="text" name="detailLen"  id="detailLen" size="1"  style="width:25px;" value="500" readonly />                              
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<cf_basket_form_button>
    <cfquery name="GET_PROD_OPERATION" datasource="#DSN3#">
            SELECT TOP 1 P_ORDER_ID FROM PRODUCTION_ORDER_OPERATIONS WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
    </cfquery>
    <cfif get_prod_operation.recordcount>
        <font color="#FF0000">İlişkili Üretim Emri Operatör Ekranında Başlatıldığı İçin Sonlandırma İşlemini Operatör Ekranından Yapabilirsiniz . <a href="<cfoutput>#request.self#?fuseaction=production.form_add_production_order&upd=#attributes.p_order_id#">#get_det_po.p_order_no#</cfoutput></a> </font>
    <cfelse>
        <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
    </cfif>
</cf_basket_form_button>

<cf_seperator header="#getLang('main',1854)#" id="table1">
<table id="table1" name="id1" class="detail_basket_list">
    <!---<iframe name="add_prod" id="add_prod" frameborder="0" vspace="0" hspace="0" scrolling="no" src="<cfoutput>#request.self#?fuseaction=objects2.form_add_prod_order_result&iframe=1</cfoutput>" width="100%" height="22"></iframe>--->
    <thead>
        <tr>
            <th width="10">
                <!---<cfset demontaj_cost_price_system = 0>
                <cfset demontaj_purchase_extra_cost_system = 0>
                <cfset demontaj_cost_price_system_2 = 0>--->
                <cfif get_det_po.is_demontaj eq 1>
                    <cfset sonuc_query = 'get_sub_products'>
                <cfelse>
                    <cfset sonuc_query = 'get_det_po'>
                </cfif>
                <cfset sonuc_recordcount = evaluate('#sonuc_query#.recordcount')>
                <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#sonuc_recordcount#</cfoutput>">
                <!---<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_product#xml_str#</cfoutput>&type=1&record_num=' + form_basket.record_num.value,'list')"><img id="add_row_image" src="/images/plus_list.gif" align="absmiddle" border="0"></a>--->
            </th>
            <th width="70"><cf_get_lang_main no='106.Stok Kodu'></th>
            <th width="200"><cf_get_lang_main no='40.Stok'></th>
            <th width="200" style="display:<cfoutput>#spec_img_display#</cfoutput>"><cf_get_lang_main no='235.spect'></th>
            <th width="60"><cf_get_lang_main no='223.Miktar'></th>
            <th width="60"><cf_get_lang_main no='224.Birim'></th>
        </tr>
	</thead>
    <tbody>
        <!--- Ana ürün --->
        <cfoutput query="#sonuc_query#">
            <cfquery name="GET_PRODUCT" datasource="#DSN3#" maxrows="1">
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
                    PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
                    START_DATE <= #now()# 
                ORDER BY 
                    START_DATE DESC,
                    RECORD_DATE DESC,
                    PRODUCT_COST_ID DESC
            </cfquery>
            <cfscript>
                if(get_product.recordcount eq 0)
                {
                    cost_id = 0;
                    purchase_extra_cost = 0;
                    product_cost = 0;
                    product_cost_money = session.pp.money;
                    cost_price = 0;
                    cost_price_money = session.pp.money;
                    cost_price_2 = 0;
                    cost_price_money_2 = session.pp.money2;
                    cost_price_system = 0;
                    cost_price_system_money = session.pp.money;
                    purchase_extra_cost_system = 0;
                    purchase_extra_cost_system_2 = 0;
                }
                else
                {
                    cost_id = get_product.product_cost_id;
                    purchase_extra_cost = get_product.purchase_extra_cost;
                    product_cost = get_product.product_cost;
                    product_cost_money = get_product.money;
                    cost_price = get_product.purchase_net;
                    cost_price_money = get_product.purchase_net_money;
                    cost_price_2 = get_product.purchase_net_system_2;
                    cost_price_money_2 = session.pp.money2;
                    cost_price_system = get_product.purchase_net_system;
                    cost_price_system_money = get_product.purchase_net_system_money;
                    purchase_extra_cost_system = get_product.purchase_extra_cost_system;
                    purchase_extra_cost_system_2 = get_product.purchase_extra_cost_system_2;
                }
            </cfscript>
            <input type="hidden" name="cost_id#currentrow#" id="cost_id#currentrow#" value="#get_product.product_cost_id#">
            <tr id="frm_row#currentrow#" <cfif tree_type is 'P'>class="phantom" title="Phantom Ağaçtan Ürünler"<cfelseif tree_type is 'O'>class="operasyon" title="Operasyondan Gelen Ürünler"</cfif>>
                <td>
                    <input type="hidden" name="wrk_row_id_#currentrow#" id="wrk_row_id_#currentrow#" value="#wrk_row_id#">
                    <input type="hidden" name="tree_type_#currentrow#" id="tree_type_#currentrow#" value="#tree_type#">
                    <input type="hidden" name="is_free_amount_#currentrow#" id="is_free_amount_#currentrow#" value="#is_free_amount#">
                    <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                    <input type="hidden" name="product_cost#currentrow#" id="product_cost#currentrow#" value="#product_cost#"><!--- giydirilmiş maliyet --->
                    <input type="hidden" name="product_cost_money#currentrow#" id="product_cost_money#currentrow#" value="#product_cost_money#"><!--- giydirilmiş maliyet para birimi--->
                    <input type="hidden" name="kdv_amount#currentrow#" id="kdv_amount#currentrow#" value="#tax#"><!--- ürün kdv oranı //tax_purchase--->
                    <input type="hidden" name="cost_price_system#currentrow#" id="cost_price_system#currentrow#" value="#cost_price_system#">
                    <input type="hidden" name="purchase_extra_cost_system#currentrow#" id="purchase_extra_cost_system#currentrow#" value="#purchase_extra_cost_system#">
                    <input type="hidden" name="purchase_extra_cost#currentrow#" id="purchase_extra_cost#currentrow#" value="#purchase_extra_cost#">
                    <input type="hidden" name="money_system#currentrow#" id="money_system#currentrow#" value="#cost_price_system_money#">
                   <!--- <a style="cursor:pointer" onclick="sil('#currentrow#');"><img src="images/delete_list.gif" border="0" align="absmiddle" title="<cf_get_lang_main no='51.Sil'>"></a> --->
                </td>
                <td><input type="text" name="stock_code#currentrow#" id="stock_code#currentrow#" value="#stock_code#" style="width:70px;" readonly=""></td>
                <td nowrap="nowrap"><input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
                    <input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#stock_id#" >
                    <input type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="#product_name# #property#" readonly style="width:180px;">                
				</td>
                <td style="display:#spec_img_display#;" nowrap="nowrap">
                <cfif ( isdefined('#sonuc_query#.spec_main_id') and len(evaluate('#sonuc_query#.spec_main_id')) and evaluate('#sonuc_query#.spec_main_id') gt 0) or (isdefined('#sonuc_query#.spect_var_id') and len(evaluate('#sonuc_query#.spect_var_id')) and evaluate('#sonuc_query#.spect_var_id') gt 0)><!--- demontajda GET_SUB_PRODUCTS querysi calistigi icin burda spect olmamali yari mamulün spectini bilemeyiz--->
                    <cfquery name="GET_SPECT" datasource="#DSN3#">
                        <cfif len(evaluate('#sonuc_query#.spect_var_id'))>
                            SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('#sonuc_query#.spect_var_id')#">
                        <cfelse>
                            SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('#sonuc_query#.spec_main_id')#">
                        </cfif>
                    </cfquery>
                    <input type="hidden" name="spect_id_#currentrow#" id="spect_id_#currentrow#" value="#evaluate('#sonuc_query#.spect_var_id')#">
                    <input type="#evaluate('spec_display')#" value="#evaluate('#sonuc_query#.spec_main_id')#" name="spec_main_id#currentrow#" id="spec_main_id#currentrow#" readonly style="width:40px;">
                    <input type="#evaluate('spec_display')#" value="#evaluate('#sonuc_query#.spect_var_id')#" name="spect_id#currentrow#" id="spect_id#currentrow#" readonly style="width:40px;">
                    <input type="#evaluate('spec_name_display')#" name="spect_name#currentrow#" id="spect_name#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:150px;">
                <cfelse>
                    <cfif is_production eq 1 and not len(related_spect_id) or related_spect_id eq 0>
                        <cfif isdefined('is_production') and is_production eq 1 and((isdefined('stock#stock_id#_spec_main_id') and not len(evaluate('stock#stock_id#_spec_main_id'))) or not isdefined('stock#stock_id#_spec_main_id'))>
                            <cfscript>
                                create_spect_from_product_tree = get_main_spect_id(stock_id);
                                if(len(create_spect_from_product_tree.spect_main_id))
                                    'stock#stock_id#_spec_main_id' = create_spect_from_product_tree.spect_main_id;
                            </cfscript>  
                        </cfif>
                    <cfelse>
                       <cfset 'stock#stock_id#_spec_main_id' = related_spect_id>
                    </cfif>
    
                    <cfif isdefined('stock#stock_id#_spec_main_id') and len(evaluate('stock#stock_id#_spec_main_id'))>
                        <cfquery name="GET_SPECT_S_" datasource="#DSN3#">
                            SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('stock#stock_id#_spec_main_id')#">
                        </cfquery>
                        <cfif get_spect_s_.recordcount>
                            <cfset _spec_main_name__ = get_spect_s_.spect_var_name>
                        </cfif>
                    <cfelse>
                       <cfset _spec_main_name__ = ''>
                    </cfif>          
                    <input type="hidden" value="" name="spect_id_#currentrow#" id="spect_id_#currentrow#">
                    <input type="#evaluate('spec_display')#" name="spec_main_id#currentrow#" id="spec_main_id#currentrow#" value="<cfif isdefined('stock#stock_id#_spec_main_id')>#evaluate('stock#stock_id#_spec_main_id')#</cfif>" readonly style="width:40px;">
                    <input type="#evaluate('spec_display')#" value="" name="spect_id#currentrow#" id="spect_id#currentrow#" readonly style="width:40px;">
                    <input type="#evaluate('spec_name_display')#" name="spect_name#currentrow#" id="spect_name#currentrow#" value="#_spec_main_name__#" readonly style="width:150px;">
                </cfif>
                    <a href="javascript://" onclick="pencere_ac_spect('#currentrow#');"><img src="/images/plus_thin.gif" style="display:#spec_img_display#" align="absmiddle" border="0"></a>
                </td>
                <td>
                <input type="hidden" name="fire_amount_#currentrow#" id="fire_amount_#currentrow#" value="0" style="width:60px;" class="moneybox" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,3);aktar();">
                <cfset _amount_ = wrk_round(AMOUNT,8,1)>
                <cfif get_det_po.is_demontaj eq 1><!---demantajda miktar carpmali Demontaj alt ürünler--->
                    <cfif GET_ROW_AMOUNT.RECORDCOUNT>
                        <cfset kalan_uretim_miktarı = _amount_-get_sum_amount.SUM_AMOUNT><cfif kalan_uretim_miktarı lt 0><cfset kalan_uretim_miktarı = 1></cfif>
                        <cfset kalan_uretim_miktarı_new = kalan_uretim_miktarı>
                        <cfset maliyet_miktarı= kalan_uretim_miktarı>
                        <input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#TlFormat(kalan_uretim_miktarı,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,1);" class="moneybox" style="width:70px;" <cfif is_change_amount_demontaj eq 0>readonly=""</cfif>></td>
                        <input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="#TlFormat(kalan_uretim_miktarı,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,1);" class="moneybox" style="width:60px;" <cfif is_change_amount_demontaj eq 0>readonly=""</cfif>>
                    <cfelseif NOT GET_ROW_AMOUNT.RECORDCOUNT>
                        <cfset kalan_uretim_miktarı_new = _AMOUNT_><!--- #TlFormat(_AMOUNT_*get_det_po.AMOUNT,8)# --->
                        <cfset maliyet_miktarı= _AMOUNT_>
                        <input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#TlFormat(_AMOUNT_,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,1);" class="moneybox" style="width:70px;" <cfif is_change_amount_demontaj eq 0>readonly=""</cfif>></td>
                        <input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="#TlFormat(_AMOUNT_,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,1);" class="moneybox" style="width:60px;" <cfif is_change_amount_demontaj eq 0>readonly=""</cfif>>
                    </cfif>	
                <cfelse><!--- Normal ürün ismi --->
                    <cfif GET_ROW_AMOUNT.RECORDCOUNT AND TYPE_PRODUCT eq 1>
                        <cfset kalan_uretim_miktarı = _AMOUNT_-get_sum_amount.SUM_AMOUNT><cfif kalan_uretim_miktarı lt 0><cfset kalan_uretim_miktarı = 1></cfif>
                        <cfset maliyet_miktarı= kalan_uretim_miktarı>
                        <input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#TlFormat(kalan_uretim_miktarı,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox" style="width:70px;"></td>
                        <input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="#TlFormat(kalan_uretim_miktarı,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox" style="width:60px;">
                    <cfelseif NOT GET_ROW_AMOUNT.RECORDCOUNT or TYPE_PRODUCT eq 0>
                        <cfset kalan_uretim_miktarı = _AMOUNT_>
                        <cfset maliyet_miktarı= kalan_uretim_miktarı>
                        <input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#TlFormat(_AMOUNT_,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox" style="width:70px;"></td>
                        <input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="#TlFormat(_AMOUNT_,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox" style="width:60px;">
                    <cfelseif _AMOUNT_ eq get_sum_amount.SUM_AMOUNT>
                        <cfset kalan_uretim_miktarı = _AMOUNT_>
                        <cfset maliyet_miktarı= 0>
                        <input type="text" name="amount#currentrow#" id="amount#currentrow#" value="0" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox" style="width:70px;"onclick="aktar();"></td>
                        <input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="0" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox" style="width:60px;"onclick="aktar();"> 
                    </cfif>	
                </cfif>
                <td>
                    <input type="hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="#product_unit_id#">
                    <input type="text" name="unit#currentrow#" id="unit#currentrow#" value="#main_unit#" readonly style="width:60px;">
                </td>
                <!---<td style="display:#product_name2_display#"><input type="text" style="width:70px;" name="product_name2#currentrow#" id="product_name2#currentrow#" value=""></td>--->
            </tr>
            <cfif get_det_po.is_demontaj eq 1>
                <cfscript>
                    if(len(get_product.purchase_net_system))
                        demontaj_cost_price_system = demontaj_cost_price_system+kalan_uretim_miktarı_new*get_product.purchase_net_system;
                    if(len(get_product.purchase_net_system_2))
                        demontaj_cost_price_system_2 = demontaj_cost_price_system_2+kalan_uretim_miktarı_new*get_product.purchase_net_system_2;
                    if(len(get_product.purchase_extra_cost_system))
                        demontaj_purchase_extra_cost_system =demontaj_purchase_extra_cost_system+kalan_uretim_miktarı_new*get_product.purchase_extra_cost_system;
                </cfscript>
            </cfif>
        </cfoutput>
   </tbody>
</table>
<cfif get_det_po.is_demontaj eq 1>
    <cfset sarf_query='get_det_po'>
<cfelse>
    <cfset sarf_query='get_sub_products'>
</cfif>
<cfset deger_value_row = evaluate('#sarf_query#.recordcount')>
<br />
<cf_seperator header="Sarf" id="table2">
<input type="hidden" name="record_num_exit" id="record_num_exit" value="<cfoutput>#deger_value_row#</cfoutput>"/>
<table id="table2" name="table2" class="detail_basket_list">
    <!---<iframe name="add_prod" id="add_prod" frameborder="0" vspace="0" hspace="0" scrolling="no" src="<cfoutput>#request.self#?fuseaction=prod.popup_add_production_result&is_show_product_name2=#is_show_product_name2#&iframe=1&spec_name_display=#evaluate('spec_name_display')#&spec_display=#evaluate('spec_display')#</cfoutput>&type=exit" width="100%" height="22"></iframe> --->
    <thead>
        <tr>
            <!---<th style="text-align:center;"><!---<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_product#xml_str#</cfoutput>&type=0&record_num_exit=' + form_basket.record_num_exit.value,'list')"><img id="add_row_exit_image" src="/images/plus_list.gif" align="absmiddle" border="0"></a>---></th>--->
            <th width="70"><cf_get_lang_main no='106.Stok Kodu'></th>
            <th width="170"><cf_get_lang_main no='40.Stok'></th>
            <th width="270" style="display:<cfoutput>#spec_img_display#</cfoutput>"><cf_get_lang_main no='235.spect'></th>
            <th width="75">Lot No</th>
            <th width="60"><cf_get_lang_main no='223.Miktar'></th>
            <th width="60"><cf_get_lang_main no='224.Birim'></th>
        </tr>
    </thead>
    <tbody>
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
                        AND POO.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
                        AND POR_.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
                        AND POR_.TYPE=2
                        <cfif len(related_spect_id)>
                            AND POR_.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#related_spect_id#">
                        </cfif>
                        <cfif len(wrk_row_id)>
                            AND (POR_.WRK_ROW_RELATION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_row_id#"> OR POR_.WRK_ROW_RELATION_ID IS NULL)
                        </cfif>
                </cfquery>
                <cfquery name="GET_PRODUCT" datasource="#DSN3#" maxrows="1">
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
                        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
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
                    if(get_product.recordcount eq 0)
                    {
                        cost_id = 0;
                        purchase_extra_cost = 0;
                        product_cost = 0;
                        product_cost_money = session.pp.money;
                        cost_price = 0;
                        cost_price_money = session.pp.money;
                        cost_price_2 = 0;
                        cost_price_money_2 = session.pp.money2;
                        cost_price_system = 0;
                        cost_price_system_money = session.pp.money;
                        purchase_extra_cost_system = 0;
                        purchase_extra_cost_system_2 = 0;
                    }
                    else
                    {
                        cost_id = get_product.product_cost_id;
                        purchase_extra_cost = get_product.purchase_extra_cost;
                        product_cost = get_product.product_cost;
                        product_cost_money = get_product.money;
                        cost_price = get_product.purchase_net;
                        cost_price_money = get_product.purchase_net_money;
                        cost_price_2 = get_product.purchase_net_system_2;
                        cost_price_money_2 = session.pp.money2;
                        cost_price_system = get_product.purchase_net_system;
                        cost_price_system_money = get_product.purchase_net_system_money;
                        purchase_extra_cost_system = get_product.purchase_extra_cost_system;
                        purchase_extra_cost_system_2 = get_product.purchase_extra_cost_system_2;
                    }
                </cfscript>
            </cfif>
            <!--- SARFLAR --->
            <tr id="frm_row_exit#currentrow#" <cfif tree_type is 'P'>class="phantom" title="Phantom Ağaçtan Ürünler"<cfelseif tree_type is 'O'>class="operasyon" title="Operasyondan Gelen Ürünler"</cfif>><!--- Eğer fantom ürünün içeriği ise satırın rengini değiştir.. --->
                <cfif get_det_po.is_demontaj eq 1><!---demantajda miktar carpmayalim--->
                    <cfif isdefined('get_sum_amount')>
                        <cfset sarf_kalan_uretim_emri = get_det_po.amount-get_sum_amount.sum_amount><cfif sarf_kalan_uretim_emri lt 0><cfset sarf_kalan_uretim_emri=1></cfif>
                        <cfset sarf_kalan_uretim_emri_new = sarf_kalan_uretim_emri>
                    <cfelse>
                        <cfset sarf_kalan_uretim_emri_new = get_det_po.amount>
                    </cfif>
                <cfelse>
                    <cfif isdefined('get_sum_amount')><!--- Normal ürün alt ürünleri --->
                        <cfset sarf_kalan_uretim_emri = get_det_po.AMOUNT-get_sum_amount.SUM_AMOUNT><cfif sarf_kalan_uretim_emri lt 0><cfset sarf_kalan_uretim_emri=1></cfif>
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
                <input type="hidden" name="cost_id_exit#currentrow#" id="cost_id_exit#currentrow#" value="#cost_id#">
                <input type="hidden" name="is_free_amount#currentrow#" id="is_free_amount#currentrow#" value="#is_free_amount#">
                <!---<input type="hidden" name="line_number_exit_#currentrow#" id="line_number_exit_#currentrow#" value="#line_number#">--->
                <input type="hidden" name="wrk_row_id_exit_#currentrow#" id="wrk_row_id_exit_#currentrow#" value="#wrk_row_id#">
                <input type="hidden" name="tree_type_exit_#currentrow#" id="tree_type_exit_#currentrow#" value="#tree_type#">
                <input type="hidden" name="row_kontrol_exit#currentrow#" id="row_kontrol_exit#currentrow#" value="1">
                <input type="hidden" name="product_cost_exit#currentrow#" id="product_cost_exit#currentrow#" value="#product_cost#"><!--- giydirilmiş maliyet --->
                <input type="hidden" name="product_cost_money_exit#currentrow#" id="product_cost_money_exit#currentrow#" value="#product_cost_money#"><!--- giydirilmiş maliyet para birimi--->
                <input type="hidden" name="kdv_amount_exit#currentrow#" id="kdv_amount_exit#currentrow#" value="#tax#"><!--- ürün kdv oranı //tax_purchase--->
                <input type="hidden" name="is_production_spect_exit#currentrow#" id="is_production_spect_exit#currentrow#" value="<cfif isdefined('is_production') and is_production eq 1>1<cfelse>0</cfif>">
                <!---<td nowrap="nowrap">
                    <a style="cursor:pointer" onclick="copy_row_exit('#currentrow#');" title="<cf_get_lang_main no='1560.Satır Kopyala'>"><img  src="images/copy_list.gif" border="0"></a>
                    <a style="cursor:pointer" onclick="sil_exit('#currentrow#');"><img src="images/delete_list.gif" border="0" align="absmiddle" title="<cf_get_lang_main no='51.Sil'>"></a>
                </td>--->
                <td><input type="text" name="stock_code_exit#currentrow#" id="stock_code_exit#currentrow#" value="#stock_code#" style="width:70px;" readonly=""></td>
                <!---<cfif x_is_barkod_col eq 1><td><input type="text" name="barcode_exit#currentrow#" id="barcode_exit#currentrow#" value="#barcod#" readonly style="width:90px;"></td></cfif>--->
                <td nowrap>
                    <input type="hidden" name="product_id_exit#currentrow#" id="product_id_exit#currentrow#"value="#product_id#">
                    <input type="hidden" name="stock_id_exit#currentrow#" id="stock_id_exit#currentrow#" value="#stock_id#">
                    <input type="text" name="product_name_exit#currentrow#" id="product_name_exit#currentrow#" value="#product_name# #property#" readonly style="width:180px;">
                </td>
                <td style="display:#spec_img_display#;" nowrap>
                <cfif get_det_po.is_demontaj eq 1 and ( len(get_det_po.spect_var_id) or len(get_det_po.spec_main_id) ) ><!--- demontaj ve spec varsa sarfta spec olur--->
                    <cfquery name="GET_SPECT" datasource="#DSN3#">
                        <cfif len(get_det_po.spect_var_id)>
                            SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_det_po.spect_var_id#">
                        <cfelse>
                            SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_det_po.spec_main_id#">
                        </cfif>
                    </cfquery>
                    <input type="hidden" name="spect_id_exit_#currentrow#" id="spect_id_exit_#currentrow#" value="#get_det_po.spect_var_id#">
                    <input type="#evaluate('spec_display')#" name="spec_main_id_exit#currentrow#" id="spec_main_id_exit#currentrow#" value="#get_det_po.spec_main_id#" readonly style="width:40px;">
                    <input type="#evaluate('spec_display')#" name="spect_id_exit#currentrow#" id="spect_id_exit#currentrow#" value="#get_det_po.spect_var_id#" readonly style="width:40px;">
                    <input type="#evaluate('spec_name_display')#" name="spect_name_exit#currentrow#" id="spect_name_exit#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:150px;">
                    <a href="javascript://" onclick="pencere_ac_spect('#currentrow#',2);"><img src="/images/plus_thin.gif" style="display:#spec_img_display#" align="absmiddle" border="0"></a>
                <cfelse>
                    <!--- Alt Üretim Emirlerinde Bir SpecMainId oluşmamış ise ve ürün bir *üretilen* ürün 
                    ise bu ürün için MainSpecId'yi burda kendimiz oluşturuyoruz. --->
                    <cfif is_production eq 1 and not len(related_spect_id) or related_spect_id eq 0>
                        <cfif isdefined('is_production') and is_production  eq 1 and((isdefined('stock#stock_id#_spec_main_id') and not len(evaluate('stock#stock_id#_spec_main_id'))) or not isdefined('stock#stock_id#_spec_main_id'))>
                            <cfscript>
                                create_spect_from_product_tree = get_main_spect_id(stock_id);
                                if(len(create_spect_from_product_tree.spect_main_id))
                                    'stock#stock_id#_spec_main_id' = create_spect_from_product_tree.spect_main_id;
                            </cfscript> 
                        </cfif>
                    <cfelse>
                        <cfset 'stock#stock_id#_spec_main_id' = related_spect_id>
                    </cfif>
                    <!--- Eğer demontaj değil ise ve bu sarf ürünler için ana ürün'deki malzeme ihtiyacından üretim yapılmış ise o yapılan üretimler,bu yapılan üretimin alt üretimi
                    olacağından ve onlara ait de bir spect oluşacağı için burda o alt üretimlerde oluşan spect id ve ve spect name'leri gösteriyoruz. --->
                    <cfif isdefined('stock#stock_id#_spec_main_id') and len(evaluate('stock#stock_id#_spec_main_id'))>
                        <cfquery name="GET_SPECT_S" datasource="#DSN3#">
                            SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('stock#stock_id#_spec_main_id')#">
                        </cfquery>
                        <cfif get_spect_s.recordcount>
                            <cfset _spec_main_name__ = get_spect_s.spect_var_name>
                        </cfif>
                    <cfelse>
                        <cfset _spec_main_name__ = ''>
                    </cfif>
                    <input type="hidden" name="spect_id_exit_#currentrow#" id="spect_id_exit_#currentrow#"value=""><!--- <cfif isdefined('stock#STOCK_ID#_spect_id')>#evaluate('stock#STOCK_ID#_spect_id')#<cfelseif isdefined('spect_id_exit')>#spect_id_exit#</cfif> --->
                    <input type="#evaluate('spec_display')#" name="spec_main_id_exit#currentrow#" id="spec_main_id_exit#currentrow#" value="<cfif isdefined('stock#STOCK_ID#_spec_main_id')>#evaluate('stock#STOCK_ID#_spec_main_id')#</cfif>" readonly style="width:40px;">
                    <input type="#evaluate('spec_display')#" name="spect_id_exit#currentrow#" id="spect_id_exit#currentrow#" value="" readonly style="width:40px;"><!--- <cfif isdefined('stock#STOCK_ID#_spect_id')>#evaluate('stock#STOCK_ID#_spect_id')#<cfelseif isdefined('spect_id_exit')>#spect_id_exit#</cfif> --->
                    <input type="#evaluate('spec_name_display')#" name="spect_name_exit#currentrow#" id="spect_name_exit#currentrow#" value="#_spec_main_name__#" readonly style="width:150px;"><!--- <cfif isdefined('stock#STOCK_ID#_spect_name')>#evaluate('stock#STOCK_ID#_spect_name')#<cfelseif isdefined('spect_name_exit')>#spect_name_exit#</cfif> --->
                    <a href="javascript://" onclick="pencere_ac_spect('#currentrow#',2);"><img src="/images/plus_thin.gif" style="display:#spec_img_display#" align="absmiddle" border="0"></a>
                </cfif>
                </td>
                <td nowrap="nowrap">
                    <input type="text" name="lot_no_exit#currentrow#" id="lot_no_exit#currentrow#" value="" style="width:75px;" />
                    <a href="javascript://" onclick="pencere_ac_list_product('#currentrow#','2');"><img src="/images/plus_thin.gif" style="cursor:pointer;" align="absbottom" border="0"></a>
                </td>
				<cfset _amount_ = wrk_round(amount,8,1)>
                <td>
                    <cfif get_det_po.is_demontaj eq 1><!---demantajda miktar carpmayalim--->
                        <cfif isdefined('get_sum_amount')>
                            <cfset sarf_kalan_uretim_emri = get_sub_products.amount-get_sum_amount.sum_amount><cfif sarf_kalan_uretim_emri lt 0><cfset sarf_kalan_uretim_emri=1></cfif>
                            <cfset sarf_kalan_uretim_emri_new = sarf_kalan_uretim_emri>
                            <cfset maliyet_miktarı = sarf_kalan_uretim_emri>
                            <input type="text" name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat(sarf_kalan_uretim_emri,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,0);aktar();" class="moneybox" style="width:70px;" readonly="yes">
                            <input type="hidden" name="amount_exit_#currentrow#" id="amount_exit_#currentrow#" value="#TlFormat(sarf_kalan_uretim_emri,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,0);aktar();" class="moneybox" style="width:60px;" readonly="yes">
                        <cfelse>
                            <cfset sarf_kalan_uretim_emri_new = get_det_po.amount>
                            <cfset maliyet_miktarı = get_det_po.amount>
                            <input type="text" name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat(get_det_po.amount,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,0);aktar();" class="moneybox" style="width:70px;" onclick="aktar();" readonly="yes">
                            <input type="hidden" name="amount_exit_#currentrow#" id="amount_exit_#currentrow#" value="#TlFormat(get_det_po.amount,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,0);aktar();" class="moneybox" style="width:60px;" onclick="aktar();" readonly="yes">
                        </cfif>
                    <cfelse>
                        <cfif is_free_amount eq 1>
                            <input type="text" name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat(wrk_round(_AMOUNT_,8,1),round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,0);" class="moneybox" style="width:70px;" readonly="yes"><!---#_readonly_#--->
                            <input type="hidden" name="amount_exit_#currentrow#" id="amount_exit_#currentrow#" value="#TlFormat(wrk_round(_AMOUNT_,8,1),round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,0);" class="moneybox" style="width:60px;" readonly="yes"><!---#_readonly_#--->
                        <cfelse>	
                            <cfif isdefined('get_sum_amount')><!--- Normal ürün alt ürünleri --->
                                <cfif isdefined('x_calc_sub_pro_amount') and x_calc_sub_pro_amount eq 1>
                                    <cfset sarf_kalan_uretim_emri = GET_SUB_PRODUCTS.AMOUNT * kalan_uretim_miktarı / get_det_po.amount>
                                <cfelse>
                                    <cfset sarf_kalan_uretim_emri = GET_SUB_PRODUCTS.AMOUNT-get_sum_amount.SUM_AMOUNT>
                                </cfif>
                                <cfif sarf_kalan_uretim_emri lt 0><cfset sarf_kalan_uretim_emri=1></cfif>
                                <cfset maliyet_miktarı = sarf_kalan_uretim_emri>
                                <input type="text" name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat((sarf_kalan_uretim_emri),round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,0);" class="moneybox" style="width:70px;" readonly="yes"><!---#_readonly_#--->
                                <input type="hidden" name="amount_exit_#currentrow#" id="amount_exit_#currentrow#" value="#TlFormat((sarf_kalan_uretim_emri),round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,0);" class="moneybox" style="width:60px;" readonly="yes"><!---#_readonly_#--->
                            <cfelse>
                            <cfset maliyet_miktarı = wrk_round(_amount_,8,1)>
                                <input type="text" name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat(wrk_round(_amount_,8,1),round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,0);" class="moneybox" style="width:70px;" readonly="yes" /><!---#_readonly_#--->
                                <input type="hidden" name="amount_exit_#currentrow#" id="amount_exit_#currentrow#" value="#TlFormat(wrk_round(_amount_,8,1),round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,0);" class="moneybox" style="width:60px;" readonly="yes"><!---#_readonly_#--->
                            </cfif>
                        </cfif>
                    </cfif>
                </td>
                <td>
                    <input type="hidden" name="unit_id_exit#currentrow#" id="unit_id_exit#currentrow#" value="#product_unit_id#">
                    <input type="text" name="unit_exit#currentrow#" id="unit_exit#currentrow#" value="#main_unit#" readonly style="width:60px;">
                    <input type="hidden" name="serial_no_exit#currentrow#" id="serial_no_exit#currentrow#" value="" style="width:150px;">
                </td>
            </tr>
        </cfoutput>
        <input type="hidden" name="sarf_recordcount" id="sarf_recordcount" value="<cfoutput>#GET_SUB_PRODUCTS.recordcount#</cfoutput>">
        <cfset value_currentrow = evaluate('#sarf_query#.recordcount')>
    </tbody>
</table>
<cfif get_det_po.is_demontaj eq 1>
    <cfset sarf_query='get_det_po'>
<cfelse>
    <cfset sarf_query='get_sub_products_fire'>
</cfif>
<cfif isdefined('#sarf_query#.recordcount')>
    <cfset deger_value_row_fire = evaluate('#sarf_query#.recordcount')>
</cfif>
<br />
<cf_seperator header="#getLang('main',1674)#" id="table3_cover">
<input type="hidden" name="record_num_outage" id="record_num_outage" value="<cfif isdefined('get_sub_products_fire.recordcount') and len(get_sub_products_fire.recordcount) and get_det_po.is_demontaj eq 0><cfoutput>#deger_value_row_fire#</cfoutput><cfelse>0</cfif>">
<table id="table3_cover" name="table3_cover" class="detail_basket_list">
    <!---<iframe name="add_prod" id="add_prod" frameborder="0" vspace="0" hspace="0" scrolling="no" src="<cfoutput>#request.self#?fuseaction=prod.popup_add_production_result&is_show_product_name2=#is_show_product_name2#&iframe=1&spec_name_display=#evaluate('spec_name_display')#&spec_display=#evaluate('spec_display')#</cfoutput>&type=outage" width="100%" height="22"></iframe>
    ---><thead>
        <tr>
            <!---<th style="text-align:center;"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_product#xml_str#</cfoutput>&type=2&record_num_outage=' + form_basket.record_num_outage.value,'list')"><img id="add_row_outage_image" src="/images/plus_list.gif" align="absmiddle" border="0"></a>---></th>
            <th width="70"><cf_get_lang_main no='106.Stok Kodu'></th>
            <!---<cfif x_is_barkod_col eq 1><th width="90"><cf_get_lang_main no='221.Barkod'></th></cfif>--->
            <th width="250"><cf_get_lang_main no='40.Stok'></th>
            <th width="230" style="display:<cfoutput>#spec_img_display#</cfoutput>"><cf_get_lang_main no='235.spect'></th>
            <th width="75">Lot No</th>
            <th width="60"><cf_get_lang_main no='223.Miktar'></th>
            <th width="60"><cf_get_lang_main no='224.Birim'></th>
        </tr>
     </thead>
     <tbody id="table3" name="table3">
        <cfif get_det_po.is_demontaj eq 0><!--- Demontajda fire çıktısı olmaz... --->
            <cfif isdefined('get_sub_products_fire.recordcount')>
                <cfoutput query="#sarf_query#">
                    <cfquery name="GET_SUM_AMOUNT_FIRE" datasource="#DSN3#">
                        SELECT 
                            ISNULL(SUM(POR_.AMOUNT),0) AS SUM_AMOUNT
                        FROM 
                            PRODUCTION_ORDER_RESULTS_ROW POR_,
                            PRODUCTION_ORDER_RESULTS POO
                        WHERE 
                            POR_.PR_ORDER_ID = POO.PR_ORDER_ID AND 
                            POO.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#"> AND 
                            POR_.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> AND 
                            POR_.TYPE=2
                            <cfif len(related_spect_id)>
                                AND POR_.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#related_spect_id#">
                            </cfif>
                            <cfif len(wrk_row_id)>
                                AND (POR_.WRK_ROW_RELATION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_row_id#"> OR POR_.WRK_ROW_RELATION_ID IS NULL)
                            </cfif>
                    </cfquery>
                    <cfquery name="GET_PRODUCT_FIRE" datasource="#DSN3#" maxrows="1">
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
                            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
                            START_DATE <= #createodbcdate(get_det_po.finish_date)#
                        ORDER BY 
                            START_DATE DESC,
                            RECORD_DATE DESC,
                            PRODUCT_COST_ID DESC
                    </cfquery>
                    <cfscript>
                        if(get_product_fire.recordcount eq 0)
                        {
                            cost_id = 0;
                            purchase_extra_cost = 0;
                            product_cost = 0;
                            product_cost_money = session.pp.money;
                            cost_price = 0;
                            cost_price_money = session.pp.money;
                            cost_price_2 = 0;
                            cost_price_money_2 = session.pp.money2;
                            cost_price_system = 0;
                            cost_price_system_money = session.pp.money;
                            purchase_extra_cost_system = 0;
                            purchase_extra_cost_system_2 = 0;
                        }
                        else
                        {
                            cost_id = get_product_fire.product_cost_id;
                            purchase_extra_cost = get_product_fire.purchase_extra_cost;
                            product_cost = get_product_fire.product_cost;
                            product_cost_money = get_product_fire.money;
                            cost_price = get_product_fire.purchase_net;
                            cost_price_money = get_product_fire.purchase_net_money;
                            cost_price_2 = get_product_fire.purchase_net_system_2;
                            cost_price_money_2 = session.pp.money2;
                            cost_price_system = get_product_fire.purchase_net_system;
                            cost_price_system_money = get_product_fire.purchase_net_system_money;
                            purchase_extra_cost_system = get_product_fire.purchase_extra_cost_system;
                            purchase_extra_cost_system_2 = get_product_fire.purchase_extra_cost_system_2;
                        }
                    </cfscript>
                    <input type="hidden" name="cost_id_outage#currentrow#" id="cost_id_outage#currentrow#" value="#get_product_fire.product_cost_id#">
                    <!---<input type="hidden" name="line_number_outage_#currentrow#" id="line_number_outage_#currentrow#" value="#line_number#">--->
                    <input type="hidden" name="wrk_row_id_outage_#currentrow#" id="wrk_row_id_outage_#currentrow#" value="#wrk_row_id#">
                    <input type="hidden" name="row_kontrol_outage#currentrow#" id="row_kontrol_outage#currentrow#" value="1">
                    <input type="hidden" name="product_cost_outage#currentrow#" id="product_cost_outage#currentrow#" value="#product_cost#"><!--- giydirilmiş maliyet --->
                    <input type="hidden" name="product_cost_money_outage#currentrow#" id="product_cost_money_outage#currentrow#" value="#product_cost_money#"><!--- giydirilmiş maliyet para birimi--->
                    <input type="hidden" name="kdv_amount_outage#currentrow#" id="kdv_amount_outage#currentrow#" value="#tax#"><!--- ürün kdv oranı //tax_purchase--->
                    <tr id="frm_row_outage#currentrow#">
                        <!--- <td nowrap="nowrap">
                            <a style="cursor:pointer" onclick="copy_row_outage('#currentrow#');" title="<cf_get_lang_main no='1560.Satır Kopyala'>"><img  src="images/copy_list.gif" border="0"></a>
                            <a style="cursor:pointer" onclick="sil_outage('#currentrow#');"><img src="images/delete_list.gif" border="0" align="absmiddle" title="<cf_get_lang_main no='51.Sil'>"></a>
                        </td> --->
                        <td><input type="text" name="stock_code_outage#currentrow#" id="stock_code_outage#currentrow#" value="#stock_code#" style="width:70px;" readonly="readonly"></td>
                        <!--- <cfif x_is_barkod_col eq 1><td><input type="text" name="barcode_outage#currentrow#" id="barcode_outage#currentrow#" value="#barcod#" style="width:90px;" readonly="readonly"></td></cfif>--->
                        <td nowrap="nowrap"><input type="hidden" name="product_id_outage#currentrow#" id="product_id_outage#currentrow#" value="#product_id#">
                            <input type="hidden" value="#stock_id#" name="stock_id_outage#currentrow#" id="stock_id_outage#currentrow#">
                            <input type="text" name="product_name_outage#currentrow#" id="product_name_outage#currentrow#" value="#product_name# #property#" readonly style="width:180px;">
                        </td>
                        <td style="display:#spec_img_display#;" nowrap="nowrap">
                            <!--- Alt Üretim Emirlerinde Bir SpecMainId oluşmamış ise ve ürün bir *üretilen* ürün 
                            ise bu ürün için MainSpecId'yi burda kendimiz oluşturuyoruz. --->
                            <cfif is_production eq 1 and not len(related_spect_id) or related_spect_id eq 0>
                                <cfif isdefined('is_production') and is_production  eq 1 and((isdefined('stock#stock_id#_spec_main_id') and not len(evaluate('stock#stock_id#_spec_main_id'))) or not isdefined('stock#stock_id#_spec_main_id'))>
                                    <cfscript>
                                        create_spect_from_product_tree = get_main_spect_id(stock_id);
                                        if(len(create_spect_from_product_tree.spect_main_id))
                                            'stock#stock_id#_spec_main_id' = create_spect_from_product_tree.spect_main_id;
                                    </cfscript> 
                                </cfif>
                            <cfelse>
                                <cfset 'stock#stock_id#_spec_main_id' = related_spect_id>
                            </cfif>
                            <!--- Eğer demontaj değil ise ve bu sarf ürünler için ana ürün'deki malzeme ihtiyacından üretim yapılmış ise o yapılan üretimler,bu yapılan üretimin alt üretimi
                            olacağından ve onlara ait de bir spect oluşacağı için burda o alt üretimlerde oluşan spect id ve ve spect name'leri gösteriyoruz. --->
                            <cfif isdefined('stock#stock_id#_spec_main_id') and len(evaluate('stock#stock_id#_spec_main_id'))>
                                <cfquery name="GET_SPECT_S" datasource="#DSN3#">
                                    SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('stock#stock_id#_spec_main_id')#">
                                </cfquery>
                                <cfif get_spect_s.recordcount>
                                    <cfset _spec_main_name__ = get_spect_s.spect_var_name>
                                </cfif>
                            <cfelse>
                                <cfset _spec_main_name__ = ''>
                            </cfif>
                            <input type="#evaluate('spec_display')#" name="spec_main_id_outage#currentrow#" id="spec_main_id_outage#currentrow#" value="<cfif isdefined('stock#stock_id#_spec_main_id')>#evaluate('stock#STOCK_ID#_spec_main_id')#</cfif>" readonly style="width:40px;">
                            <input type="#evaluate('spec_display')#" name="spect_id_outage#currentrow#" id="spect_id_outage#currentrow#" value="" readonly style="width:40px;"><!--- <cfif isdefined('stock#STOCK_ID#_spect_id')>#evaluate('stock#STOCK_ID#_spect_id')#<cfelseif isdefined('spect_id_exit')>#spect_id_exit#</cfif> --->
                            <input type="#evaluate('spec_name_display')#" name="spect_name_outage#currentrow#" id="spect_name_outage#currentrow#" value="#_spec_main_name__#" readonly style="width:150px;"><!--- <cfif isdefined('stock#STOCK_ID#_spect_name')>#evaluate('stock#STOCK_ID#_spect_name')#<cfelseif isdefined('spect_name_exit')>#spect_name_exit#</cfif> --->
                            <a href="javascript://" onclick="pencere_ac_spect('#currentrow#',3);"><img src="/images/plus_thin.gif" style="display:#spec_img_display#" align="absmiddle" border="0"></a>
                        </td>
                        <td nowrap="nowrap">
                            <input type="text" name="lot_no_outage#currentrow#" id="lot_no_outage#currentrow#" value="" style="width:75px;">
                            <a href="javascript://" onclick="pencere_ac_list_product('#currentrow#','3');"><img src="/images/plus_thin.gif" style="cursor:pointer;" align="absbottom" border="0"></a>
                        </td>
                        <cfset _amount_ = wrk_round(amount,8,1)>
                        <td>
                            <cfif isdefined('get_sum_amount_fire')><!--- Normal ürün alt ürünleri --->
                                <cfset sarf_kalan_uretim_emri = get_sub_products_fire.amount-get_sum_amount_fire.sum_amount><cfif sarf_kalan_uretim_emri lt 0><cfset sarf_kalan_uretim_emri=1></cfif>
                                <cfset maliyet_miktarı = sarf_kalan_uretim_emri>
                                <input type="text" name="amount_outage#currentrow#" id="amount_outage#currentrow#" value="#TlFormat((sarf_kalan_uretim_emri),round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,0);" class="moneybox" style="width:70px;" readonly="yes">
                                <input type="hidden" name="amount_outage_#currentrow#" id="amount_outage_#currentrow#" value="#TlFormat((sarf_kalan_uretim_emri),round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,0);" class="moneybox" style="width:60px;" readonly="yes">
                            <cfelse>
                                <cfset maliyet_miktarı = _amount_>
                                <input type="text" name="amount_outage#currentrow#" id="amount_outage#currentrow#" value="#TlFormat(_amount_,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,0);" class="moneybox" style="width:70px;" readonly="yes">
                                <input type="hidden" name="amount_outage_#currentrow#" id="amount_outage_#currentrow#" value="#TlFormat(_amount_,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,0);" class="moneybox" style="width:60px;" readonly="yes">
                            </cfif>
                        </td>
                        <td>
                            <input type="hidden" name="unit_id_outage#currentrow#" id="unit_id_outage#currentrow#" value="#product_unit_id#">
                            <input type="hidden" name="serial_no_outage#currentrow#" id="serial_no_outage#currentrow#" value="">
                            <input type="text" name="unit_outage#currentrow#" id="unit_outage#currentrow#" value="#main_unit#" readonly style="width:60px;">
                        </td>
                    </tr>
                    <cfif get_det_po.is_demontaj eq 1>
                        <cfscript>
                        if(len(get_product_fire.purchase_net_system))
                            demontaj_cost_price_system = demontaj_cost_price_system+get_product_fire.purchase_net_system*fire_kalan_uretim_miktarı_new;
                        if(len(get_product_fire.purchase_net_system_2))
                            demontaj_cost_price_system_2 = demontaj_cost_price_system_2+get_product_fire.purchase_net_system_2*fire_kalan_uretim_miktarı_new;
                        if(len(get_product_fire.purchase_extra_cost_system))
                            demontaj_purchase_extra_cost_system =demontaj_purchase_extra_cost_system+get_product_fire.purchase_extra_cost_system*fire_kalan_uretim_miktarı_new;
                        </cfscript>
                    </cfif>
				</cfoutput>
                <input type="hidden" name="fire_recordcount" id="fire_recordcount" value="<cfoutput>#get_sub_products_fire.recordcount#</cfoutput>">
            </cfif>	
        </cfif>
    </tbody>
</table>
<br /><br />
</cfform>	

<script type="text/javascript">
	row_count = <cfoutput>#sonuc_recordcount#</cfoutput>;
	row_count_exit = <cfoutput>#deger_value_row#</cfoutput>;
	round_number = <cfoutput>#round_number#</cfoutput>;//xmlden geliyor. miktar kusuratlarini burdan aliyor
	<cfif get_det_po.is_demontaj eq 1>//demontaj ise ve spectli üründen fire geliyorsa 0 olarak kabul et,fire'ye demontaj yapılmaz.
		row_count_outage = 0;
	<cfelse>
		row_count_outage = <cfif isdefined('deger_value_row_fire')><cfoutput>#deger_value_row_fire#</cfoutput><cfelse>0</cfif>;
	</cfif>
	function change_row_cost(row_no)
	{
		new_cost = filterNum(document.getElementById("cost_price_exit"+row_no).value,round_number);
		new_money = document.getElementById("money_exit"+row_no).value;
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
	}


	row_count_exit = <cfoutput>#deger_value_row#</cfoutput>;
	satir_sarf = document.getElementById("table2").rows.length;

	
	function pencere_ac_alternative(no,pid,sid)//ürünlerin alternatiflerini açıyor
	{
		form_stock = document.getElementById("stock_id_exit"+no);
		//&field_is_production=form_basket.is_production_spect_exit'+no+'
		url_str='&tree_stock_id='+sid+'&field_is_production=form_basket.is_production_spect_exit'+no+'&field_tax_purchase=form_basket.kdv_amount_exit'+no+'&product_id=form_basket.product_id_exit'+no+'&run_function=alternative_product_cost&send_product_id=p_id,'+no+'&field_barcode=form_basket.barcode_exit'+no+'&field_id=form_basket.stock_id_exit'+no+'&field_unit_name=form_basket.unit_exit'+no+'&field_code=form_basket.stock_code_exit'+no+'&field_name=form_basket.product_name_exit' + no + '&field_unit=form_basket.unit_id_exit'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&is_form_submitted=1&is_only_alternative=1';
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names'+url_str+'','list');
	}
	function pencere_ac_list_product(no,type)//ürünlere lot_no ekliyor
	{
		if(type == 2)
		{//sarf ise type 2
			form_stock_code = document.getElementById("stock_code_exit"+no).value;
			url_str='&is_sale_product=1&update_product_row_id=0&is_lot_no_based=1&prod_order_result_=1&sort_type=1&lot_no=form_basket.lot_no_exit'+no+'&keyword=' + form_stock_code+'&is_form_submitted=1&int_basket_id=1';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_list_products'+url_str+'','list');
		}
		else if(type == 3)
		{//fire ise type 3
			form_stock_code = document.getElementById("stock_code_outage"+no).value;
			url_str='&is_sale_product=1&update_product_row_id=0&is_lot_no_based=1&prod_order_result_=1&sort_type=1&lot_no=form_basket.lot_no_outage'+no+'&keyword=' + form_stock_code+'&is_form_submitted=1&int_basket_id=1';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_list_products'+url_str+'','list');
		}
	}
	function alternative_product_cost(pid,no)
		{
			var listParam = pid + "*" + " <cfoutput>#createodbcdate(get_det_po.finish_date)#</cfoutput>";
			var get_product_cost = wrk_safe_query("prdp_GET_PRODUCT_COST",'dsn3',0,listParam);
			if(!get_product_cost.recordcount)
			{
				
					cost_id = 0;
					purchase_extra_cost = 0;
					product_cost = 0;
					product_cost_money = '<cfoutput>#session.pp.money#</cfoutput>';
					cost_price = 0;
					cost_price_money = '<cfoutput>#session.pp.money#</cfoutput>';
					cost_price_2 = 0;
					cost_price_money_2 = '<cfoutput>#session.pp.money2#</cfoutput>';
					cost_price_system = 0;
					cost_price_system_money = '<cfoutput>#session.pp.money#</cfoutput>';
					purchase_extra_cost_system = 0;
			}
			else
			{
				cost_id = get_product_cost.PRODUCT_COST_ID;
				purchase_extra_cost = get_product_cost.PURCHASE_EXTRA_COST;
				product_cost = get_product_cost.PRODUCT_COST;
				product_cost_money = get_product_cost.MONEY;
				cost_price = get_product_cost.PURCHASE_NET;
				cost_price_money = get_product_cost.PURCHASE_NET_MONEY;
				cost_price_2 = get_product_cost.PURCHASE_NET_SYSTEM_2;
				cost_price_money_2 = session.ep.money2;
				cost_price_system = get_product_cost.PURCHASE_NET_SYSTEM;
				cost_price_system_money = get_product_cost.PURCHASE_NET_SYSTEM_MONEY;
				purchase_extra_cost_system = get_product_cost.PURCHASE_EXTRA_COST_SYSTEM;
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
			url_str='&department_id='+_department_id_+'&field_main_id=form_basket.spec_main_id_exit'+no+'&field_id=form_basket.spect_id_exit'+no+'&field_name=form_basket.spect_name_exit' + no + '&stock_id=' + form_stock.value + '&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1&p_order_id=<cfoutput>#attributes.p_order_id#</cfoutput>';
			else
			url_str='&department_id='+_department_id_+'&field_main_id=form_basket.spec_main_id_exit'+no+'&field_id=form_basket.spect_id_exit'+no+'&field_name=form_basket.spect_name_exit' + no + '&stock_id=' + form_stock.value +'&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1';
			
		}
		else if(type==3)
		{
			form_stock = document.getElementById("stock_id_outage"+no);
			if(<cfoutput>#get_det_po.is_demontaj#</cfoutput> == 1)
			url_str='&department_id='+_department_id_+'&field_main_id=form_basket.spec_main_id_outage'+no+'&field_id=form_basket.spect_id_outage'+no+'&field_name=form_basket.spect_name_outage' + no + '&stock_id=' + form_stock.value + '&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1&p_order_id=<cfoutput>#attributes.p_order_id#</cfoutput>';
			else
			url_str='&department_id='+_department_id_+'&field_main_id=form_basket.spec_main_id_outage'+no+'&field_id=form_basket.spect_id_outage'+no+'&field_name=form_basket.spect_name_outage' + no + '&stock_id=' + form_stock.value +'&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1';
		}
		else
		{
			form_stock = document.getElementById("stock_id"+no);
			if(<cfoutput>#get_det_po.is_demontaj#</cfoutput> == 1)
				url_str='&field_id=form_basket.spect_id'+no+'&field_name=form_basket.spect_name' + no + '&stock_id=' + form_stock.value + '&create_main_spect_and_add_new_spect_id=1&last_spect=1&p_order_id=<cfoutput>#attributes.p_order_id#</cfoutput>';
			else	
				url_str='&p_order_row_id='+document.getElementById('order_row_id').value+'&field_id=form_basket.spect_id'+no+'&field_name=form_basket.spect_name' + no + '&stock_id=' + form_stock.value + '&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1&p_order_id=<cfoutput>#attributes.p_order_id#</cfoutput>';
			
		}
		if(form_stock.value == "")
			alert("<cf_get_lang_main no='59.Eksik veri'> : <cf_get_lang_main no='245.Ürün'>");
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&main_to_add_spect=1' + url_str,'list');
			//windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect' + url_str,'list');-Burası önceden spect_id sayfasını açıyordu ve direkt ekleniyordu ancak stocks_row'a kayıt atılmayan spectler gelmediği için iptal edildi.Onun yerine main_spect sayfası geliyor,seçilen main_spect'e göre bir spect eklenip onun id'si bu sayfaya gönderiliyor.
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
		var round_number = document.getElementById('round_number').value;
		//if(!chk_period(document.getElementById("finish_date"), 'İşlem')) return false;
		var Get_Result = wrk_safe_query('prdp_get_result','dsn3',0,document.getElementById('production_result_no').value);	
		if(Get_Result.recordcount > 0){
			alert('Bu Sonuç Numarası Daha Önce Kullanılmış');
			window.location.reload();
			return false;
		}
		if(document.getElementById("record_num").value == 0)
		{
			alert("Lütfen Ana Ürün Seçiniz!");
			return false;
		}
		if(document.getElementById("record_num_exit").value == 0)
		{
			alert("Lütfen Sarf Ürünü Seçiniz!");
			return false;
		}
		/* if(document.getElementById("station_id").value == "" || document.getElementById("station_name").value == "")
		{
			alert("Lütfen İstasyon Seçiniz !");
			return false;
		}*/
		
		if((document.getElementById("sarf_recordcount").value > 0 && (filterNum(document.getElementById("amount_exit_"+1).value,round_number)>0) || document.getElementById("sarf_recordcount").value == 0) && (filterNum(document.getElementById("amount"+1).value,round_number)>0))
		{
			<cfif get_det_po.is_demontaj eq 0><!--- Demontaj Değil ise --->
				if(document.getElementById('spec_main_id1').value == "" && document.getElementById('spect_id1').value == ""){
					alert('Ana Ürün İçin Spec Seçmeniz Gerekmektedir.');
					return false;
				}
			</cfif>
			/*if(!chk_process_cat('form_basket')) return false;
			if(!check_display_files('form_basket')) return false;
			if(!process_cat_control()) return false;
			if(!time_check(form_basket.start_date, form_basket.start_h, form_basket.start_m, form_basket.finish_date, form_basket.finish_h, form_basket.finish_m, "<cf_get_lang no='463.Başlangıç Tarihi Bitiş Tarihinden Büyük'> !")) return false;
			*/
			
			for (var k=1;k<=row_count_exit;k++)//eğer sarfların içinde üretilen bir ürün varsa onun için spect seçilmesini zorunlu kılıyor.Onun kontrolü
			{
				if((document.getElementById("spec_main_id_exit"+k).value == "" || document.getElementById("spec_main_id_exit"+k).value == "") && (document.getElementById("is_production_spect_exit"+k).value == 1)&& document.getElementById("row_kontrol_exit"+k).value==1)//spect id ve spect name varsa vede ürtilen bir ürünse
				{
					alert('Üretilen Ürünler İçin Spect Seçmeniz Gerekmektedir.(' + document.getElementById("product_name_exit"+k).value + ')');
					return false;
				}
				if(document.getElementById("spec_main_id_exit"+k).value != '')
				{
					var spec_control = wrk_safe_query("obj2_getSpecName",'dsn3',0,document.getElementById("spec_main_id_exit"+k).value);
					if(spec_control.recordcount == 0)
					{
						alert(k+". Satırdaki Sarf Ürün Spec'i Silinmiş. Lütfen Spec'inizi Güncelleyiniz!");
						return false;
					}
					else if(spec_control.SPECT_STATUS == 0)
					{
						alert(k+". Satırdaki Sarf Ürün Spec'i Pasif Durumda. Lütfen Spec'inizi Güncelleyiniz!");
						return false;
					}
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
						alert("Ürün Miktarı 0 Olamaz , Lütfen Miktarları Kontrol Ediniz !");
						return false;
					}
				}
				if(document.getElementById("document.form_basket.amount2_"+r) != undefined)
					document.getElementById("amount2_"+r).value = filterNum(document.getElementById("amount2_"+r).value,round_number);
				document.getElementById("amount"+r).value = filterNum(document.getElementById("amount"+r).value,round_number);
				/*document.getElementById("cost_price"+r).value = filterNum(document.getElementById("cost_price"+r).value,round_number);
				if(document.getElementById("purchase_extra_cost_system"+r) != undefined)
					document.getElementById("purchase_extra_cost_system"+r).value = filterNum(document.getElementById("purchase_extra_cost_system"+r).value,8);*/
				<!---if(document.getElementById("cost_price_2"+r) != undefined)
					document.getElementById("cost_price_2"+r).value = filterNum(document.getElementById("cost_price_2"+r).value,round_number);
				if(document.getElementById("cost_price_extra_2"+r) != undefined)
					document.getElementById("cost_price_extra_2"+r).value = filterNum(document.getElementById("cost_price_extra_2"+r).value,round_number);--->
				<cfif x_is_fire_product eq 1>
					document.getElementById("fire_amount_"+r).value = filterNum(document.getElementById("fire_amount_"+r).value,round_number);
				</cfif>
			}

			if(row_count_ == 0)
			{
				alert("Lütfen Ana Ürün Seçiniz!");
				return false;
			}


			for (var k=1;k<=row_count_exit;k++)
			{

				/*if(document.getElementById("row_kontrol_exit"+k).value==1)//En az bir sarf ürün satırı olması için kontrol eklendi.
				{
					row_count_exit_ = row_count_exit_ + 1;
					if(filterNum(document.getElementById("amount_exit"+k).value,round_number) <= 0)
					{
						alert("Sarf Miktarı 0 Olamaz , Lütfen Miktarları Kontrol Ediniz !");
						return false;
					}
				}*/
				//if(document.getElementById("document.form_basket.amount_exit2_"+r) != undefined)
				//	document.getElementById("amount_exit2_"+k).value = filterNum(document.getElementById("amount_exit2_"+k).value,round_number);
				document.getElementById("amount_exit"+k).value = filterNum(document.getElementById("amount_exit"+k).value,round_number);
				
				<!---document.getElementById("cost_price_exit"+k).value = filterNum(document.getElementById("cost_price_exit"+k).value,round_number);
				if(document.getElementById("cost_price_exit_2"+k) != undefined)
					document.getElementById("cost_price_exit_2"+k).value = filterNum(document.getElementById("cost_price_exit_2"+k).value,round_number);	
				if(document.getElementById("purchase_extra_cost_exit_2"+k) != undefined)
					document.getElementById("purchase_extra_cost_exit_2"+k).value = filterNum(document.getElementById("purchase_extra_cost_exit_2"+k).value,round_number);
				document.getElementById("purchase_extra_cost_exit"+k).value = filterNum(document.getElementById("purchase_extra_cost_exit"+k).value,round_number);--->
			}

			for (var k=1;k<=row_count_outage;k++)
			{
				if(document.getElementById("document.form_basket.amount_outage2_"+r) != undefined)
					document.getElementById("amount_outage2_"+k).value = filterNum(document.getElementById("amount_outage2_"+k).value,round_number);
				document.getElementById("amount_outage"+k).value = filterNum(document.getElementById("amount_outage"+k).value,round_number);
				// document.getElementById("cost_price_outage"+k).value = filterNum(document.getElementById("cost_price_outage"+k).value,round_number);
				if(document.getElementById("cost_price_outage_2"+k) != undefined)
					document.getElementById("cost_price_outage_2"+k).value = filterNum(document.getElementById("cost_price_outage_2"+k).value,round_number);
				/* if(document.getElementById("purchase_extra_cost_outage_2"+k) != undefined)
					document.getElementById("purchase_extra_cost_outage_2"+k).value = filterNum(document.getElementById("purchase_extra_cost_outage_2"+k).value,round_number); */
				// document.getElementById("purchase_extra_cost_outage"+k).value = filterNum(document.getElementById("purchase_extra_cost_outage"+k).value,round_number);
				//document.getElementById("purchase_extra_cost_system_outage"+k).value = filterNum(document.getElementById("purchase_extra_cost_system_outage"+k).value,8);
				if(document.getElementById("spec_main_id_outage"+k).value != '')
				{
					var spec_control_outage = wrk_safe_query("obj2_getSpecName",'dsn3',0,document.getElementById("spec_main_id_outage"+k).value);
					if(spec_control_outage.recordcount == 0)
					{
						alert(k+". Satırdaki Fire Ürün Spec'i Silinmiş. Lütfen Spec'inizi Güncelleyiniz!");
						return false;
					}
					else if(spec_control_outage.SPECT_STATUS == 0)
					{
						alert(k+". Satırdaki Fire Ürün Spec'i Pasif Durumda. Lütfen Spec'inizi Güncelleyiniz!");
						return false;
					}
				}
			}
			return true;
		}
		else
		{
			alert('Miktar 0 Üretim Yapılamaz.');
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
							alert('Girilen Miktar Oranı Üretim Emrinden Fazla Olamaz.');
							eval("form_basket.amount"+1).value=eval("form_basket.amount_"+1).value;
						}
					if(filterNum(document.getElementById("amount_"+1).value,round_number)<1)		
						{
							alert('Bu Üretim Emrinde Kota Doldulmuştur,Üretim yapmak için yeni bir Üretim Emri Ekleyiniz.');
							document.getElementById("amount"+1).value=0;
							return false;
						}
					if(filterNum(document.getElementById("amount"+1).value,round_number)<1)		
					{
						alert('Üretim Oranı Hatalı Lütfen Doğru Bir Değer Giriniz.!!');
						document.getElementById("amount"+1).value = document.getElementById("amount_"+1).value;
						return false;
					}
				</cfif>	
				<cfif get_det_po.is_demontaj eq 1>
					if(filterNum(document.getElementById("amount_exit"+1).value,round_number)>filterNum(document.getElementById("amount_exit_"+1).value,round_number))
						{
							alert('Girilen Miktar Oranı Üretim Emrinden Fazla Olamaz.');
							document.getElementById("amount_exit"+1).value = document.getElementById("amount_exit_"+1).value;
						}
						if(filterNum(document.getElementById("amount_exit_"+1).value,round_number)==0)
						{
							alert('Bu Üretim Emrinde Kota Doldulmuştur,Üretim yapmak için yeni bir Üretim Emri Ekleyiniz.');
							document.getElementById("amount_exit"+1).value=0;
							return false;	
						}
						if(filterNum(document.getElementById("amount_exit"+1).value,round_number)==0)
						{
							alert('Üretim Oranı Hatalı Lütfen Doğru Bir Değer Giriniz.');
							return false;	
						}		
						
				</cfif>	
			</cfif>
			if(sarf_uzunluk>0)
			{
				for (i=1;i<=sarf_uzunluk;i++)
					{	
						<cfif get_det_po.is_demontaj eq 0>
							if(document.getElementById("is_free_amount"+i).value == 0)
							{
								<cfif isdefined('get_sum_amount')>
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
								<cfelseif not isdefined('get_sum_amount')>
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
						<cfif get_det_po.is_demontaj eq 1 and isdefined('get_sum_amount')>
						var x=parseInt(document.getElementById("amount_exit"+1).value);
						if(x>0)/*Demontaj yapılacak ürün miktarı 1 den fazla ise*/
							{	var a=document.getElementById("amount"+i).value=(filterNum(document.getElementById("amount_"+i).value,round_number)/parseFloat(<cfoutput>#sarf_kalan_uretim_emri#</cfoutput>))*filterNum(document.getElementById("amount_exit"+1).value,round_number);
								var b=commaSplit(a,round_number);
								document.getElementById("amount"+i).value=b;
							}	
						<cfelseif get_det_po.is_demontaj eq 1 and not isdefined('get_sum_amount')>
						var x=parseInt(document.getElementById("amount_exit"+1).value);
						if(x>0)/*Demontaj yapılacak ürün miktarı 1 den fazla ise*/
							{
								var a=document.getElementById("amount"+i).value=(filterNum(document.getElementById("amount_"+i).value,round_number)/parseFloat(<cfoutput>#get_det_po.AMOUNT#</cfoutput>))*filterNum(document.getElementById("amount_exit"+1).value,round_number);
								var b=commaSplit(a,round_number);
								document.getElementById("amount"+i).value=b;
							}
						</cfif>
					}
			}

			<cfif get_det_po.is_demontaj eq 0>
				if(fire_uzunluk>0)
				{
					for (i=1;i<=fire_uzunluk;i++)
					{	
						<cfif isdefined('get_sum_amount')>
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
						<cfelseif  not isdefined('get_sum_amount')>
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

	
	function counter(field, countfield, maxlimit){ 
		if(field.value.length > maxlimit)
		{ 
			field.value = field.value.substring(0, maxlimit);
			alert("Max "+maxlimit+"!"); 
		}
		else 
			countfield.value = maxlimit - field.value.length; 
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
			{
				document.form_basket.appendChild(document.getElementById('amount_outage2' + i + ''));
				document.form_basket.appendChild(document.getElementById('unit2_outage' + i + ''));
			}
			document.form_basket.appendChild(document.getElementById('product_name2_outage' + i + ''));
		}
	} 
</script>
