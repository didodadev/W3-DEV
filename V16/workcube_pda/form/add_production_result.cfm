<cfset default_round = 8>
<!--- Uretim Sonucu Ekleme/Guncelleme --->
<cfset attributes.start_date = DateFormat(createdate(session.pda.period_year,month(now()),day(now())),'dd/mm/yyyy')>
<cfset attributes.finish_date = DateFormat(createdate(session.pda.period_year,month(now()),day(now())),'dd/mm/yyyy')>
<cfset attributes.ship_number = "">
<cfset attributes.process_cat = "">
<cfset attributes.member_type = "">
<cfset attributes.consumer_id = "">	
<cfset attributes.company_id = "">
<cfset attributes.comp_name = "">
<cfset attributes.partner_id = "">
<cfset attributes.partner_name = "">
<cfset attributes.order_id_listesi = "">
<cfset attributes.order_id = "">
<cfset attributes.lot_no = "">

<cfparam name="phantom_stock_id_list" default="0">
<cfparam name="phantom_spec_main_id_list" default="0">

<cfparam name="product_name2_display" default="none">
<cfparam name="spec_display" default="hidden">
<cfparam name="spec_name_display" default="hidden">
<cfparam name="is_show_spec_name" default="">
<cfparam name="_readonly_" default="readonly">

<!--- Xml Tanimlari Burada Gerekli Duzenlemeler Yapilacak!!!! --->
<cfparam name="x_add_fire_product" default="0">
<cfparam name="x_por_amount_lte_po" default="1">
<cfparam name="x_is_fire_product" default="1">
<cfparam name="is_change_amount_demontaj" default="0">
<cfset variable_ = '0'>
<cfset variable = '1'>
<cfset variable2 = '2'>
<cfset variable3 = '3'>
<cfif isDefined("attributes.pr_order_id") and Len(attributes.pr_order_id)>
	<!--- Uretim Sonucu Guncelleme --->
	
	<cfset is_update = 1>
	<cfquery name="GET_PRODUCTION_ORDERS" datasource="#DSN3#"><!--- GET_DETAIL --->
		SELECT 
			PRODUCTION_ORDERS.REFERENCE_NO REFERANS,
			PRODUCTION_ORDERS.PROJECT_ID,
			PRODUCTION_ORDERS.P_ORDER_NO,
			PRODUCTION_ORDERS.ORDER_ID,
			PRODUCTION_ORDERS.IS_DEMONTAJ,
			PRODUCTION_ORDERS.QUANTITY AS AMOUNT,
			PRODUCTION_ORDER_RESULTS.PROCESS_ID PROCESS_CAT_ID,
			(SELECT PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = PRODUCTION_ORDER_RESULTS.PROCESS_ID) PROCESS_TYPE,
			PRODUCTION_ORDER_RESULTS.*
		FROM
			PRODUCTION_ORDERS,
			PRODUCTION_ORDER_RESULTS
		WHERE
			PRODUCTION_ORDERS.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">  AND 
			PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND
			PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDER_RESULTS.P_ORDER_ID
	</cfquery>
	<cfset attributes.lot_no = get_production_orders.lot_no>

	<cfif not get_production_orders.recordcount>
		<cfset hata  = 10>
		<cfinclude template="../../dsp_hata.cfm">
	</cfif>
	<cfquery name="GET_MONEY" datasource="#DSN#">
		SELECT 
        	MONEY,
            RATE1,
            RATE2 
        FROM 
        	MONEY_HISTORY 
        WHERE 
        	MONEY_HISTORY_ID IN(SELECT MAX(MONEY_HISTORY_ID) FROM MONEY_HISTORY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.period_id#"> AND VALIDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_production_orders.finish_date)#"> GROUP BY MONEY)
	</cfquery>
	<cfif get_money.recordcount eq 0>
		<cfquery name="GET_MONEY" datasource="#DSN2#">
			SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY
		</cfquery>
	</cfif>
	<cfquery name="GET_ROW_ENTER" datasource="#DSN3#">
		SELECT 
            TYPE, 
            PR_ORDER_ID, 
            BARCODE, 
            NAME_PRODUCT, 
            STOCK_ID, 
            PRODUCT_ID, 
            AMOUNT, 
            KDV_PRICE, 
            UNIT_ID, 
            SPECT_ID, 
            SPECT_NAME, 
            SERIAL_NO, 
            COST_ID, 
            PURCHASE_EXTRA_COST, 
            PURCHASE_NET_SYSTEM, 
            PURCHASE_NET_SYSTEM_MONEY, 
            PURCHASE_EXTRA_COST_SYSTEM, 
            PURCHASE_NET_SYSTEM_TOTAL, 
            PURCHASE_NET, 
            PURCHASE_NET_MONEY, 
            UNIT2, AMOUNT2, 
            SPEC_MAIN_ID, 
            TREE_TYPE, 
            PRODUCT_NAME2, 
            FIRE_AMOUNT, 
            IS_FREE_AMOUNT, 
            LOT_NO 
        FROM 
        	PRODUCTION_ORDER_RESULTS_ROW 
        WHERE 
        	PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_production_orders.pr_order_id#"> AND 
            TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable#">  
        ORDER BY 
        	TREE_TYPE DESC
	</cfquery>
	<cfquery name="GET_ROW_EXIT" datasource="#DSN3#">
		SELECT 
            TYPE, 
            PR_ORDER_ID, 
            BARCODE, 
            NAME_PRODUCT, 
            STOCK_ID, 
            PRODUCT_ID, 
            AMOUNT, 
            KDV_PRICE, 
            UNIT_ID, 
            SPECT_ID, 
            SPECT_NAME, 
            SERIAL_NO, 
            COST_ID, 
            PURCHASE_EXTRA_COST, 
            PURCHASE_NET_SYSTEM, 
            PURCHASE_NET_SYSTEM_MONEY, 
            PURCHASE_EXTRA_COST_SYSTEM, 
            PURCHASE_NET_SYSTEM_TOTAL, 
            PURCHASE_NET, 
            PURCHASE_NET_MONEY, 
            UNIT2, AMOUNT2, 
            SPEC_MAIN_ID, 
            TREE_TYPE, 
            PRODUCT_NAME2, 
            FIRE_AMOUNT, 
            IS_FREE_AMOUNT, 
            LOT_NO 
        FROM 
        	PRODUCTION_ORDER_RESULTS_ROW 
        WHERE 
        	PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_production_orders.pr_order_id#"> AND
            TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable2#"> 
        ORDER BY 
         	TREE_TYPE DESC
	</cfquery>
	<cfquery name="GET_ROW_OUTAGE" datasource="#DSN3#">
		SELECT 
            TYPE, 
            PR_ORDER_ID, 
            BARCODE, 
            NAME_PRODUCT, 
            STOCK_ID, 
            PRODUCT_ID, 
            AMOUNT, 
            KDV_PRICE, 
            UNIT_ID, 
            SPECT_ID, 
            SPECT_NAME, 
            SERIAL_NO, 
            COST_ID, 
            PURCHASE_EXTRA_COST, 
            PURCHASE_NET_SYSTEM, 
            PURCHASE_NET_SYSTEM_MONEY, 
            PURCHASE_EXTRA_COST_SYSTEM, 
            PURCHASE_NET_SYSTEM_TOTAL, 
            PURCHASE_NET, 
            PURCHASE_NET_MONEY, 
            UNIT2, AMOUNT2, 
            SPEC_MAIN_ID, 
            TREE_TYPE, 
            PRODUCT_NAME2, 
            FIRE_AMOUNT, 
            IS_FREE_AMOUNT, 
            LOT_NO 
        FROM 
        	PRODUCTION_ORDER_RESULTS_ROW 
        WHERE 
        	PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_production_orders.pr_order_id#"> AND 
            TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable3#">  
        ORDER BY 
        	TREE_TYPE DESC
	</cfquery>
	<cfset product_id_list = ''>
	<cfif get_row_enter.recordcount>
		<cfoutput query="get_row_enter">
			<cfif isdefined('product_id') and len(product_id) and not listfind(product_id_list,product_id)>
				<cfset product_id_list=listappend(product_id_list,product_id)>
			</cfif>
		</cfoutput>
		<cfif len(product_id_list)>
			<cfset product_id_list=listsort(product_id_list,"numeric","ASC",",")>
			<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
				SELECT PRODUCT_CATID,PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID IN (#product_id_list#) ORDER BY PRODUCT_ID
			</cfquery>
			<cfset product_id_list = listsort(listdeleteduplicates(valuelist(get_product_cat.product_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfset product_cat_list = ValueList(get_product_cat.product_catid,',')>
	</cfif>
<cfelse><!--- if isDefined("attributes.p_order_id") and Len(attributes.p_order_id) --->
	<!--- Uretim Sonucu Ekleme --->
	<cfset is_update = 0>

	<cfquery name="GET_PRODUCTION_ORDERS" datasource="#DSN3#">
		SELECT
			1 AS TYPE_PRODUCT,
			PO.IS_DEMONTAJ,
			PO.LOT_NO, 
			PO.STATION_ID,
			PO.SPEC_MAIN_ID,
			PO.SPECT_VAR_ID,
			PO.REFERENCE_NO REFERANS,
			PO.P_ORDER_NO,
			PO.PROJECT_ID,
			PO.ORDER_ID,
			S.IS_PROTOTYPE,
			PO.START_DATE,
			PO.FINISH_DATE,
			'' NAME,
			0 RELATED_SPECT_ID,
			PO.QUANTITY AMOUNT,
			0 AS IS_FREE_AMOUNT,
			0 IS_SEVK,
			'S' AS TREE_TYPE,
			0 AS IS_PHANTOM,
			0 AS IS_PROPERTY,
			0 PRODUCT_COST_ID,
			S.STOCK_CODE,
			S.PRODUCT_NAME, 
			S.PRODUCT_ID,
			S.STOCK_ID,
			S.BARCOD,		
			PU.ADD_UNIT,
			PU.MAIN_UNIT,
			PU.DIMENTION,
			S.IS_PRODUCTION,
			S.TAX,
			S.TAX_PURCHASE,
			S.PRODUCT_UNIT_ID,
			0 PRICE,
			'' MONEY,
			S.PROPERTY, 
			'' AS SUB_SPEC_MAIN_ID
		FROM
			STOCKS S,
			PRODUCTION_ORDERS PO,
			PRODUCT_UNIT PU
		WHERE
			PO.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#"> AND
			PO.STOCK_ID = S.STOCK_ID AND	
			PU.PRODUCT_ID = S.PRODUCT_ID AND
			PU.PRODUCT_UNIT_STATUS = 1 AND
			PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID			
	</cfquery>
	<cfif len(get_production_orders.spec_main_id)>
		<cfset main_product_spec_main_id = get_production_orders.spec_main_id>
	<cfelseif len(get_production_orders.spect_var_id)>
		<cfquery name="GET_MAIN_SPEC_ID" datasource="#DSN3#">
			SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_production_orders.spect_var_id#">
		</cfquery>
		<cfset main_product_spec_main_id = get_main_spec_id.spect_main_id>
	<cfelse>
		<cfquery name="GET_MAIN_SPEC_ID" datasource="#DSN3#">
			SELECT TOP 1 SPECT_MAIN_ID FROM SPECT_MAIN SM WHERE SM.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_production_orders.stock_id#">
		</cfquery>
		<cfset main_product_spec_main_id = get_main_spec_id.spect_main_id>
	</cfif>
	<cfif main_product_spec_main_id gt 0>
		<cfscript>
			function get_subs(spect_id)
			{										
				SQLStr = "
						SELECT
							AMOUNT,
							ISNULL(RELATED_MAIN_SPECT_ID,0) RELATED_MAIN_SPECT_ID,
							STOCK_ID
						FROM 
							SPECT_MAIN_ROW SM
						WHERE
							SPECT_MAIN_ID = #spect_id#
							AND IS_PHANTOM = 1
					";
				query1 = cfquery(SQLString : SQLStr, Datasource : dsn3);
				stock_id_ary='';
				for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
				{
					stock_id_ary=listappend(stock_id_ary,query1.AMOUNT[str_i],'█');
					stock_id_ary=listappend(stock_id_ary,query1.RELATED_MAIN_SPECT_ID[str_i],'§');
					stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'§');
				}
				return stock_id_ary;
			}
			function writeTree(spect_main_id)
			{
				var i = 1;
				var sub_products = get_subs(spect_main_id);
				for (i=1; i lte listlen(sub_products,'█'); i = i+1)
				{
					_next_amount_ = ListGetAt(ListGetAt(sub_products,i,'█'),1,'§');//alt+987 = █ --//alt+789 = §
					_next_spect_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),2,'§');
					_next_stock_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),3,'§');
					phantom_spec_main_id_list = listappend(phantom_spec_main_id_list,_next_spect_id_,',');
					phantom_stock_id_list = listappend(phantom_stock_id_list,_next_stock_id_,',');
					'multipler_#_next_spect_id_#' = _next_amount_;
					if(_next_spect_id_ gt 0)
						writeTree(_next_spect_id_);
				 }
			}
			writeTree(main_product_spec_main_id);
		</cfscript>
	</cfif>

	<cfif len(get_production_orders.spect_var_id) or len(get_production_orders.spec_main_id) and (get_production_orders.is_production eq 1)>
		<cfquery name="GET_SUB_PRODUCTS" datasource="#DSN3#"><!--- SARFLAR --->
			SELECT
				CAST(#createodbcdate(get_production_orders.start_date)# AS DATETIME) START_DATE,
				CAST(#createodbcdate(get_production_orders.finish_date)# AS DATETIME) FINISH_DATE,
				'Spec' AS NAME,
                <cfif len(get_production_orders.spec_main_id)>
                    SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID AS RELATED_SPECT_ID,
                    SPECT_MAIN_ROW.AMOUNT AS AMOUNT , 
					ISNULL(SPECT_MAIN_ROW.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
                    SPECT_MAIN_ROW.IS_SEVK,
                    CASE WHEN (SPECT_MAIN_ROW.IS_PROPERTY = 4) THEN 'O' ELSE 'S' END AS TREE_TYPE,
                    ISNULL(SPECT_MAIN_ROW.IS_PHANTOM,0) AS IS_PHANTOM,
                    SPECT_MAIN_ROW.IS_PROPERTY,
                    0 AS PRODUCT_COST_ID,
				<cfelse>
                    SPECTS_ROW.RELATED_SPECT_ID,
                    SPECTS_ROW.AMOUNT_VALUE AS AMOUNT,
					0 IS_FREE_AMOUNT,
                    SPECTS_ROW.IS_SEVK,
                    CASE WHEN (SPECTS_ROW.IS_PROPERTY = 4) THEN 'O' ELSE 'S' END AS TREE_TYPE, 
                    ISNULL(SPECTS_ROW.IS_PHANTOM,0) AS IS_PHANTOM,
                    SPECTS_ROW.IS_PROPERTY,
                    SPECTS_ROW.PRODUCT_COST_ID AS PRODUCT_COST_ID,
                </cfif>
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
                '' AS SUB_SPEC_MAIN_ID
			FROM
            	<cfif len(get_production_orders.spec_main_id)>
                    SPECT_MAIN,
                    SPECT_MAIN_ROW,
				<cfelse>
                    SPECTS,
                    SPECTS_ROW,		
                </cfif>
				STOCKS,
				PRODUCT_UNIT,
				PRICE_STANDART
			WHERE
				PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
				PRICE_STANDART.PURCHASESALES = 1 AND
				PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
				STOCKS.STOCK_STATUS = 1	AND
                <cfif len(get_production_orders.spec_main_id)>
					SPECT_MAIN.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_production_orders.spec_main_id#"> AND
                    SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
                    SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
                    SPECT_MAIN_ROW.IS_PROPERTY IN(0,4) AND
                   <cfif get_production_orders.is_demontaj eq 1> SPECT_MAIN_ROW.IS_SEVK = 0 AND</cfif> 
                <cfelse>
					SPECTS.SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_production_orders.spect_var_id#"> AND
                    SPECTS.SPECT_VAR_ID = SPECTS_ROW.SPECT_ID AND
                    SPECTS_ROW.STOCK_ID = STOCKS.STOCK_ID AND
                    SPECTS_ROW.IS_PROPERTY IN(0,4) AND              
                    <cfif get_production_orders.is_demontaj eq 1> SPECTS_ROW.IS_SEVK = 0 AND</cfif>
				</cfif>
				PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
				STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
				<cfif len(phantom_stock_id_list)><!--- FANTOM ÜRÜNLERİ SARF LİSTESİNDEN ÇIKARIYORUZ.AŞAĞIDA FHANTOMLARIN SPECLERİNDEN FAYDALANARAK BU ÇIKARTTIĞIMIZ ÜRÜNÜN BİLEŞENLERİNİ DAHİL EDİCEZ.. --->
					AND STOCKS.STOCK_ID NOT IN (#phantom_stock_id_list#)
				</cfif>
				<cfif phantom_spec_main_id_list gt 0><!--- eğer phantom ürün var ise... --->
                    UNION ALL
                        SELECT
                            CAST(#createodbcdate(get_production_orders.start_date)# AS DATETIME) START_DATE,
                            CAST(#createodbcdate(get_production_orders.finish_date)# AS DATETIME) FINISH_DATE,
                            'Spec' AS NAME,
                            SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID AS RELATED_SPECT_ID,
                            SPECT_MAIN_ROW.AMOUNT AS AMOUNT ,
                            ISNULL(SPECT_MAIN_ROW.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
                            SPECT_MAIN_ROW.IS_SEVK,
                            'P' AS TREE_TYPE,<!--- BURADAKİ TREE_TYPE'IN P OLMASI ÜRÜNÜN FANTOM OLDUĞUNU GÖSTERİR.. --->
                            ISNULL(SPECT_MAIN_ROW.IS_PHANTOM,0) AS IS_PHANTOM,
                            SPECT_MAIN_ROW.IS_PROPERTY,
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
                            SPECT_MAIN.SPECT_MAIN_ID AS SUB_SPEC_MAIN_ID<!--- BU ALAN SARF SATIRINA GELEN ÜRÜNÜN HANGİ SPEC'E BAĞLI OLDUĞUNU GÖSTERMEK İÇİN KONULDU.. --->
                        FROM
                            SPECT_MAIN,
                            SPECT_MAIN_ROW,
                            STOCKS,
                            PRODUCT_UNIT,
                            PRICE_STANDART
                        WHERE
                            PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                            PRICE_STANDART.PURCHASESALES = 1 AND
                            PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
                            STOCKS.STOCK_STATUS = 1	AND
                            SPECT_MAIN.SPECT_MAIN_ID IN (#phantom_spec_main_id_list#) AND
                            SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
                            SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
                            SPECT_MAIN_ROW.IS_PROPERTY IN(0,4) AND
                            ISNULL(SPECT_MAIN_ROW.IS_PHANTOM,0)=0 AND
                            <cfif get_production_orders.is_demontaj eq 1> SPECT_MAIN_ROW.IS_SEVK = 0 AND</cfif> <!--- IS_PROPERTY = 0 YANI SADE CE SARFLAR GELSİN. --->
                            PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
                            STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
                </cfif>
		</cfquery>
		<cfquery name="GET_SUB_PRODUCTS_FIRE" datasource="#DSN3#"><!--- Fireler --->
			SELECT
				#createodbcdate(get_production_orders.start_date)# START_DATE,
				#createodbcdate(get_production_orders.finish_date)# FINISH_DATE,
				'Spec' AS NAME,
				 <cfif len(get_production_orders.spec_main_id)>
                    SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID AS RELATED_SPECT_ID,
                    SPECT_MAIN_ROW.AMOUNT AS AMOUNT ,
                    SPECT_MAIN_ROW.IS_SEVK,
                    CASE WHEN (SPECT_MAIN_ROW.IS_PROPERTY = 4) THEN 'O' ELSE 'S' END AS TREE_TYPE,
                    ISNULL(SPECT_MAIN_ROW.IS_PHANTOM,0) AS IS_PHANTOM,
                    SPECT_MAIN_ROW.IS_PROPERTY,
                    0 AS PRODUCT_COST_ID,<!---0 ATIYORUZ ŞİMDİLİK DÜZELTİLECEK.--->
				<cfelse>
                    SPECTS_ROW.RELATED_SPECT_ID,
                    SPECTS_ROW.AMOUNT_VALUE AS AMOUNT,
                    SPECTS_ROW.IS_SEVK,
                    CASE WHEN (SPECTS_ROW.IS_PROPERTY = 4) THEN 'O' ELSE 'S' END AS TREE_TYPE, 
                    ISNULL(SPECTS_ROW.IS_PHANTOM,0) AS IS_PHANTOM,
                    SPECTS_ROW.IS_PROPERTY,
                    SPECTS_ROW.PRODUCT_COST_ID AS PRODUCT_COST_ID,
                </cfif>
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
				'' AS SUB_SPEC_MAIN_ID
			FROM
				<cfif len(get_production_orders.spec_main_id)>
                    SPECT_MAIN,
                    SPECT_MAIN_ROW,
				<cfelse>
                    SPECTS,
                    SPECTS_ROW,		
                </cfif>	
				STOCKS,
				PRODUCT_UNIT,
				PRICE_STANDART
			WHERE
				PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
				PRICE_STANDART.PURCHASESALES = 1 AND
				PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
				STOCKS.STOCK_STATUS = 1	AND
				ISNULL(IS_PHANTOM,0) = 0 AND
			   <cfif len(get_production_orders.spec_main_id)>
					SPECT_MAIN.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_production_orders.spec_main_id#"> AND
                    SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
                    SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
					<cfif x_add_fire_product eq 1><!--- Eğer sarf ürünleri fire olarak gelsin seçilmişse 0 ve 2 olanlar geliyor --->
						SPECT_MAIN_ROW.IS_PROPERTY IN(2,0) AND
					<cfelse>
						(ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0)<>0 OR ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0)<>0) AND
					</cfif>
                   <cfif get_production_orders.is_demontaj eq 1> SPECT_MAIN_ROW.IS_SEVK = 0 AND</cfif>
                <cfelse>
					SPECTS.SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_production_orders.spect_var_id#"> AND
                    SPECTS.SPECT_VAR_ID = SPECTS_ROW.SPECT_ID AND
                    SPECTS_ROW.STOCK_ID = STOCKS.STOCK_ID AND
                   	<cfif x_add_fire_product eq 1>
				    	SPECTS_ROW.IS_PROPERTY IN(0,2) AND
					<cfelse>
				    	SPECTS_ROW.IS_PROPERTY=2 AND
					</cfif>
                    <cfif get_production_orders.Is_Demontaj eq 1> SPECTS_ROW.IS_SEVK = 0 AND</cfif>
				</cfif>
				PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
				STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
			<cfif phantom_spec_main_id_list gt 0 and x_add_fire_product eq 1><!--- eğer phantom ürün var ise... --->
                UNION ALL
                    SELECT
                        #createodbcdate(get_production_orders.start_date)# START_DATE,
                        #createodbcdate(get_production_orders.finish_date)# FINISH_DATE,
                        'Spec' AS NAME,
                        SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID AS RELATED_SPECT_ID,
                        SPECT_MAIN_ROW.AMOUNT AS AMOUNT ,
                        SPECT_MAIN_ROW.IS_SEVK,
                        'P' AS TREE_TYPE,<!--- BURADAKİ TREE_TYPE'IN P OLMASI ÜRÜNÜN FANTOM OLDUĞUNU GÖSTERİR.. --->
                        ISNULL(SPECT_MAIN_ROW.IS_PHANTOM,0) AS IS_PHANTOM,
                        SPECT_MAIN_ROW.IS_PROPERTY,
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
                        SPECT_MAIN.SPECT_MAIN_ID AS SUB_SPEC_MAIN_ID<!--- BU ALAN SARF SATIRINA GELEN ÜRÜNÜN HANGİ SPEC'E BAĞLI OLDUĞUNU GÖSTERMEK İÇİN KONULDU.. --->
                    FROM
                        SPECT_MAIN,
                        SPECT_MAIN_ROW,
                        STOCKS,
                        PRODUCT_UNIT,
                        PRICE_STANDART
                    WHERE
                        PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                        PRICE_STANDART.PURCHASESALES = 1 AND
                        PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
                        STOCKS.STOCK_STATUS = 1	AND
                        SPECT_MAIN.SPECT_MAIN_ID IN (#phantom_spec_main_id_list#) AND
                        SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
                        SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
                        SPECT_MAIN_ROW.IS_PROPERTY IN(0,4) AND
                        ISNULL(SPECT_MAIN_ROW.IS_PHANTOM,0)=0 AND
                        <cfif get_production_orders.is_demontaj eq 1> SPECT_MAIN_ROW.IS_SEVK = 0 AND</cfif> <!--- IS_PROPERTY = 0 YANI SADE CE SARFLAR GELSİN. --->
                        PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
                        STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
			</cfif>
		</cfquery>
		<cfif get_sub_products.recordcount eq 0>
            <cfquery name="GET_SUB_PRODUCTS" datasource="#DSN3#">
                SELECT 
					#createodbcdate(get_production_orders.start_date)# START_DATE,
					#createodbcdate(get_production_orders.finish_date)# FINISH_DATE,
                   'Ağaç' AS NAME,
                    PRODUCT_TREE.SPECT_MAIN_ID AS RELATED_SPECT_ID,
					'S' AS TREE_TYPE,
                    PRODUCT_TREE.AMOUNT AS AMOUNT,
					0 IS_FREE_AMOUNT,
                    STOCKS.STOCK_CODE,
                    PRODUCT_TREE.IS_SEVK,
                    STOCKS.PRODUCT_NAME,
                    STOCKS.PRODUCT_ID,
                    STOCKS.STOCK_ID,
                    STOCKS.BARCOD,
					STOCKS.IS_PRODUCTION,
                    PRODUCT_UNIT.ADD_UNIT,
                    PRODUCT_UNIT.MAIN_UNIT,
					PRODUCT_UNIT.DIMENTION,
                    STOCKS.TAX,
                    STOCKS.TAX_PURCHASE,
                    STOCKS.PRODUCT_UNIT_ID,
                    STOCKS.PROPERTY,
					'' AS SUB_SPEC_MAIN_ID
                FROM 
                    PRODUCT_TREE,
                    STOCKS,
                    PRODUCT_UNIT
                WHERE 
                    PRODUCT_TREE.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_production_orders.stock_id#"> AND 
                    STOCKS.STOCK_ID = PRODUCT_TREE.RELATED_ID AND
                    STOCKS.STOCK_STATUS = 1	AND
					PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
                    <cfif get_production_orders.is_demontaj eq 1>AND PRODUCT_TREE.IS_SEVK = 0</cfif>
            </cfquery>
        </cfif>
    <cfelse>
    	<cfset get_sub_products.recordcount = 0>
	</cfif>
    <cfif get_sub_products.recordcount>
        <cfquery name="GET_PRODUCTION_ORDERS_2" dbtype="query">
            SELECT 0 AS TYPE_PRODUCT,0 AS IS_DEMONTAJ,'' LOT_NO,0 STATION_ID,0 SPEC_MAIN_ID,0 SPECT_VAR_ID,'' REFERANS,'' P_ORDER_NO,0 PROJECT_ID,0 ORDER_ID,0 IS_PROTOTYPE,* FROM GET_SUB_PRODUCTS WHERE IS_FREE_AMOUNT = 1
        </cfquery>
    <cfelse>
    	<cfset get_production_orders_2.recordcount = 0>
    </cfif>
	<cfquery name="GET_PRODUCTION_ORDERS" dbtype="query">
		SELECT * FROM GET_PRODUCTION_ORDERS
        <cfif get_production_orders_2.recordcount>
            UNION ALL
            SELECT * FROM GET_PRODUCTION_ORDERS_2
        </cfif>
	</cfquery>
</cfif>
<cfif is_update eq 1>
	<cfquery name="GET_FIS_CONTROL" datasource="#DSN2#"><!--- Uretim veya Sarf Fisi Varsa --->
		SELECT FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND FIS_TYPE IN (110,111)
	</cfquery>
</cfif>

<!--- Ekleme ve Guncellemede Ortak Kullanilan Degerler --->
<cfif len(get_production_orders.finish_date)>
	<cfquery name="GET_MONEY" datasource="#DSN#">
		SELECT 
        	MONEY,
            RATE1,RATE2 
        FROM 
        	MONEY_HISTORY 
        WHERE 
        	MONEY_HISTORY_ID IN(SELECT MAX(MONEY_HISTORY_ID) FROM MONEY_HISTORY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.period_id#"> AND VALIDATE_DATE <= #createodbcdatetime(get_production_orders.finish_date)# GROUP BY MONEY)
	</cfquery>
	<cfif get_money.recordcount eq 0>
		<cfquery name="GET_MONEY" datasource="#DSN2#">
			SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY
		</cfquery>
	</cfif>
</cfif>
<cfif Len(get_production_orders.station_id)>
	<cfquery name="GET_WORKSTATIONS" datasource="#DSN3#">
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
			STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_production_orders.station_id#">
	</cfquery>
</cfif>
<cfquery name="GET_ROW_AMOUNT" datasource="#DSN3#">
    SELECT PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
</cfquery>
<cfif get_row_amount.recordcount>
    <cfquery name="GET_SUM_AMOUNT" datasource="#DSN3#">
        SELECT 
            ISNULL(SUM(AMOUNT),0) AS SUM_AMOUNT
        FROM 
            PRODUCTION_ORDER_RESULTS_ROW
        WHERE 
            PR_ORDER_ID IN
            (	SELECT 
                    PR_ORDER_ID
                FROM 
                    PRODUCTION_ORDER_RESULTS
                WHERE 
                    P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
            )
            <cfif get_production_orders.is_demontaj eq 0> AND TYPE = 1<cfelse>AND TYPE = 2</cfif>
    </cfquery>
</cfif>
<!--- Ekleme ve Guncellemede Ortak Kullanilan Degerler --->

<cfif is_update eq 1>
	<cfset attributes.exit_department_id = get_production_orders.exit_dep_id>
	<cfset attributes.exit_location_id = get_production_orders.exit_loc_id>
	<cfset attributes.production_department_id = get_production_orders.production_dep_id>
	<cfset attributes.production_location_id = get_production_orders.production_loc_id>
	<cfset attributes.enter_department_id = get_production_orders.enter_dep_id>
	<cfset attributes.enter_location_id = get_production_orders.enter_loc_id>
<cfelseif is_update eq 0 and len(get_production_orders.station_id)>
	<cfset attributes.exit_department_id = get_workstations.exit_dep_id>
	<cfset attributes.exit_location_id = get_workstations.exit_loc_id>
	<cfset attributes.production_department_id = get_workstations.production_dep_id>
	<cfset attributes.production_location_id = get_workstations.production_loc_id>
	<cfset attributes.enter_department_id = get_workstations.enter_dep_id>
	<cfset attributes.enter_location_id = get_workstations.enter_loc_id>
<cfelse>
	<cfset attributes.exit_department_id = "">
	<cfset attributes.exit_location_id = "">
	<cfset attributes.production_department_id = "">
	<cfset attributes.production_location_id = "">
	<cfset attributes.enter_department_id = "">
	<cfset attributes.enter_location_id = "">
</cfif>
	
<cfset sonuc_recordcount = 0>
<cfset sarf_recordcount = 0>
<cfset fire_recordcount = 0>
<cfoutput>
<table cellpadding="2" cellspacing="0" border="0" align="center" style="width:98%;">
	<tr style="height:30px;">
		<td class="headbold">Üretim Sonucu <cfif is_update eq 1>Güncelleme : #get_production_orders.result_no#<cfelse>Ekleme : #get_production_orders.p_order_no#</cfif></td>
		<cfif is_update eq 1><td style="text-align:right;"><a href="#request.self#?fuseaction=pda.time_cost&pr_order_id=#attributes.pr_order_id#"><img src="/images/kum.gif" align="absmiddle" border="0" title="Zaman Harcaması"></a></td></cfif>
	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%;">
	<tr>
		<td class="color-row">
            <table>
            <cfif is_update eq 1>
                <cfset new_fuseaction = "emptypopup_upd_production_result">
            <cfelse>
                <cfset new_fuseaction = "emptypopup_add_production_result">
            </cfif>
            <cfform name="add_production_result" id="add_production_result" method="post" action="#request.self#?fuseaction=pda.#new_fuseaction#">
                <input type="hidden" name="p_order_id" id="p_order_id" value="#attributes.p_order_id#">
                <input type="hidden" name="process_cat" id="process_cat" value="#xml_process_id#"> <!--- İşlem Kategorisi --->
                <input type="hidden" name="process_stage" id="process_stage" value="#xml_process_stage#"> <!--- Aşama --->
                <input type="hidden" name="process_type_110" id="process_type_110" value="#xml_process_type_110#"> <!--- Üretimden Giriş İşlem Kategorisi --->
                <input type="hidden" name="process_type_111" id="process_type_111" value="#xml_process_type_111#"> <!--- Sarf Fişi İşlem Kategorisi --->
                <input type="hidden" name="process_type_112" id="process_type_112" value="#xml_process_type_112#"> <!--- Fire Fişi İşlem Kategorisi --->
                <input type="hidden" name="process_type_119" id="process_type_119" value="#xml_process_type_119#"> <!--- Üretimden Giriş (Demontaj) İşlem Kategorisi --->
                <input type="hidden" name="process_type_81" id="process_type_81" value="#xml_process_type_81#"> <!--- Depolararası Sevk İşlem Kategorisi --->
                <cfif is_update eq 1>
                    <input type="hidden" name="pr_order_id" id="pr_order_id" value="#attributes.pr_order_id#">
                    <input type="hidden" name="old_process_type" id="old_process_type" value="#get_production_orders.process_type#">
                    <input type="hidden" name="old_process_cat_id" id="old_process_cat_id" value="#get_production_orders.process_cat_id#">
                    <input type="hidden" name="production_result_no" id="production_result_no" value="#get_production_orders.result_no#">
                </cfif>
                <input type="hidden" name="production_order_no" id="production_order_no" value="#get_production_orders.p_order_no#">
                <input type="hidden" name="kur_say" id="kur_say" value="#get_money.recordcount#">
                <input type="hidden" name="is_demontaj" id="is_demontaj" value="#get_production_orders.is_demontaj#">
                <input type="hidden" name="station_id" id="station_id" value="#get_production_orders.station_id#">
                <input type="hidden" name="station_name" id="station_name" value="#get_workstations.station_name#">
                <tr>
                    <td style="width:70px;">Başlangıç T. *</td>
                    <td style="width:200px;">
                        <cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:60px;">
                        <cf_wrk_date_image date_field="start_date">
                    </td>
                </tr>
                <tr>
                    <td style="width:70px;">Bitiş T. *</td>
                    <td style="width:200px;">
                        <cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:60px;">
                        <cf_wrk_date_image date_field="finish_date">
                    </td>
                </tr>
                <tr>
                    <td>Sarf D.</td>
                    <td><cfset attributes.department_id = attributes.exit_department_id>
                        <cfset attributes.location_id = attributes.exit_location_id>
                        <cfinclude template="../query/get_department_location.cfm">
                        <cfset attributes.exit_branch_id = attributes.branch_id>
                        <cfset attributes.exit_department_location = attributes.department_location>
                        <input type="hidden" name="exit_location_id" id="exit_location_id" value="#attributes.exit_location_id#">
                        <input type="hidden" name="exit_department_id" id="exit_department_id" value="#attributes.exit_department_id#">
                        <input type="hidden" name="exit_branch_id" id="exit_branch_id" value="#attributes.exit_branch_id#">
                        <cfsavecontent variable="message">Depo Seçmelisiniz!</cfsavecontent>
                        <cfinput type="text" name="exit_department_location" id="exit_department_location" value="#attributes.exit_department_location#" style="width:120px;">
                        <a href="javascript://" onclick="get_turkish_letters_div('document.add_production_result.exit_department_location','open_all_div');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                        <a href="javascript://" onclick="get_location_all_div('open_all_div','add_production_result','exit_branch_id','exit_department_id','exit_location_id','exit_department_location');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
                    </td>
                </tr>
                <tr>
                    <td>Üretim D.</td>
                    <td><cfset attributes.department_id = attributes.production_department_id>
                        <cfset attributes.location_id = attributes.production_location_id>
                        <cfinclude template="../query/get_department_location.cfm">
                        <cfset attributes.production_branch_id = attributes.branch_id>
                        <cfset attributes.production_department_location = attributes.department_location>
                        <input type="hidden" name="production_location_id" id="production_location_id" value="#attributes.production_location_id#">
                        <input type="hidden" name="production_department_id" id="production_department_id" value="#attributes.production_department_id#">
                        <input type="hidden" name="production_branch_id" id="production_branch_id" value="#attributes.production_branch_id#">
                        <cfsavecontent variable="message">Depo Seçmelisiniz!</cfsavecontent>
                        <cfinput type="text" name="production_department_location" id="production_department_location" value="#attributes.production_department_location#" style="width:120px;">
                        <a href="javascript://" onclick="get_turkish_letters_div('document.add_production_result.production_department_location','open_all_div');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                        <a href="javascript://" onclick="get_location_all_div('open_all_div','add_production_result','production_branch_id','production_department_id','production_location_id','production_department_location');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
                    </td>
                </tr>
                <tr>
                    <td>Sevkiyat D.</td>
                    <td><cfset attributes.department_id = attributes.enter_department_id>
                        <cfset attributes.location_id = attributes.enter_location_id>
                        <cfinclude template="../query/get_department_location.cfm">
                        <cfset attributes.enter_branch_id = attributes.branch_id>
                        <cfset attributes.enter_department_location = attributes.department_location>
                        <input type="hidden" name="enter_location_id" id="enter_location_id" value="#attributes.enter_location_id#">
                        <input type="hidden" name="enter_department_id" id="enter_department_id" value="#attributes.enter_department_id#">
                        <input type="hidden" name="enter_branch_id" id="enter_branch_id" value="#attributes.enter_branch_id#">
                        <cfsavecontent variable="message">Depo Seçmelisiniz!</cfsavecontent>
                        <cfinput type="text" name="enter_department_location" id="enter_department_location" value="#attributes.enter_department_location#" style="width:120px;">
                        <a href="javascript://" onclick="get_turkish_letters_div('document.add_production_result.enter_department_location','open_all_div');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                        <a href="javascript://" onclick="get_location_all_div('open_all_div','add_production_result','enter_branch_id','enter_department_id','enter_location_id','enter_department_location');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
                    </td>
                </tr>
                <tr>
                    <td>Lot No</td>
                    <td><cfinput type="text" name="search_lot_no" id="search_lot_no" value="#attributes.lot_no#" style="width:120px;"></td>
                </tr>
                <tr style="height:25px;">
                    <td colspan="2"><div id="open_all_div"></div></td>
                </tr>
                <div id="production_row_div"><!--- Urun Blogu --->
                    <tr style="height:30px;">
                        <td colspan="2" class="txtboldblue">Ürün Bilgileri</td>
                    </tr>
                    <tr valign="top">
                        <td colspan="2">
                            <table cellpadding="1" cellspacing="0">
                                <tr>
                                    <td style="width:27px;">Miktar</td>
                                    <td style="width:27px;">Fire</td>
                                    <td style="width:170px;">Ürün</td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <cfset demontaj_cost_price_system =0>
                                        <cfset demontaj_purchase_extra_cost_system =0>
                                        <cfif isDefined("attributes.pr_order_id") and Len(attributes.pr_order_id)>
                                            <cfset sonuc_query='get_row_enter'>
                                        <cfelse>
                                            <cfif get_production_orders.is_demontaj eq 1>
                                                <cfset sonuc_query='get_sub_products'>
                                            <cfelse>
                                                <cfset sonuc_query='get_production_orders'>
                                            </cfif>
                                        </cfif>
                                        <cfset sonuc_recordcount=evaluate('#sonuc_query#.recordcount')>
                                        <input type="hidden" name="record_num" id="record_num" value="#sonuc_recordcount#">
                                        <cfloop  query="#sonuc_query#">
                                            <div id="product_info#currentrow#">
                                            <table cellpadding="1" cellspacing="0">
                                                <cfif is_update eq 1>
                                                    <cfquery name="GET_PRODUCT" datasource="#DSN1#">
                                                        SELECT 
                                                            PRODUCT.PRODUCT_NAME,
                                                            PRODUCT.BARCOD,
                                                            STOCKS.PRODUCT_UNIT_ID,
                                                            PRODUCT_UNIT.ADD_UNIT,
                                                            PRODUCT_UNIT.MAIN_UNIT,
                                                            PRODUCT_UNIT.DIMENTION,
                                                            STOCKS.PROPERTY,
                                                            STOCKS.STOCK_CODE
                                                        FROM 
                                                            PRODUCT,
                                                            STOCKS,
                                                            PRODUCT_UNIT
                                                        WHERE 
                                                            STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                                                            STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> AND
                                                            PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                                                            PRODUCT_UNIT.PRODUCT_UNIT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable#"> AND
                                                            PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
                                                    </cfquery>
                                                    <cfset stock_code = get_product.stock_code>
                                                    <cfset product_unit_id = get_product.product_unit_id>
                                                    <cfset main_unit = get_product.main_unit>
                                                    <cfset cost_price = purchase_net_system>
                                                    <cfset cost_price_money = purchase_net_system_money>
                                                    <cfset cost_price_system = purchase_net_system>
                                                    <cfset cost_price_system_money = purchase_net_system_money>
                                                    <cfset barcod = get_product.barcod>
                                                    <cfset product_name = get_product.product_name>
                                                    <cfset tax = kdv_price>
                                                    <cfset fire_amount_ = fire_amount>
                                                <cfelse>
                                                    <cfquery name="GET_PRODUCT" datasource="#DSN3#" maxrows="1">
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
                                                            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
                                                            START_DATE <= #now()# 
                                                        ORDER BY 
                                                            START_DATE DESC,
                                                            RECORD_DATE DESC,
                                                            PRODUCT_COST_ID DESC
                                                    </cfquery>
                                                    <cfscript>
                                                        if(session.pda.period_year gt 2008){//1 sene sonra kaldırılmalı!
                                                            if(get_product.money is "YTL") get_product.money = 'TL';
                                                            if(get_product.purchase_net_money is "YTL") get_product.purchase_net_money = 'TL';
                                                            if(get_product.purchase_net_system_money is "YTL") get_product.purchase_net_system_money = 'TL';
                                                        }
                                                        if(get_product.recordcount eq 0)
                                                        {
                                                            cost_id = 0;
                                                            purchase_extra_cost = 0;
                                                            product_cost = 0;
                                                            product_cost_money = session.pda.money;
                                                            cost_price = 0;
                                                            cost_price_money = session.pda.money;
                                                            cost_price_system = 0;
                                                            cost_price_system_money = session.pda.money;
                                                            purchase_extra_cost_system = 0;
                                                        }
                                                        else
                                                        {
                                                            cost_id = get_product.product_cost_id;
                                                            purchase_extra_cost = get_product.purchase_extra_cost;
                                                            product_cost = get_product.product_cost;
                                                            product_cost_money = get_product.money;
                                                            cost_price = get_product.purchase_net;
                                                            cost_price_money = get_product.purchase_net_money;
                                                            cost_price_system = get_product.purchase_net_system;
                                                            cost_price_system_money = get_product.purchase_net_system_money;
                                                            purchase_extra_cost_system = get_product.purchase_extra_cost_system;
                                                        }
                                                    </cfscript>
                                                    <cfset fire_amount_ = 0>
                                                </cfif>
                                                <tr>
                                                    <input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
                                                    <input type="hidden" name="tree_type_#currentrow#" id="tree_type_#currentrow#" value="#tree_type#">
                                                    <input type="hidden" name="is_free_amount_#currentrow#" id="is_free_amount_#currentrow#" value="#is_free_amount#">
                                                    <input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#stock_id#">
                                                    <input type="hidden" name="stock_code#currentrow#" id="stock_code#currentrow#" value="#stock_code#">
                                                    <input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
                                                    <input type="hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="#product_unit_id#">
                                                    <input type="hidden" name="unit#currentrow#" id="unit#currentrow#" value="#main_unit#">
                                                    <input type="hidden" name="serial_no#currentrow#" id="serial_not#currentrow#" value="">
                                                    <input type="hidden" name="is_production_spect#currentrow#" id="is_production_spect#currentrow#" value="<cfif isdefined('is_production') and is_production eq 1>1<cfelse>0</cfif>">
                                                                
                                                    <input type="hidden" name="cost_id#currentrow#" id="cost_id#currentrow#" value="#cost_id#">
                                                    <input type="hidden" name="cost_price#currentrow#" id="cost_price#currentrow#" value="#cost_price#">
                                                    <input type="hidden" name="money#currentrow#" id="money#currentrow#" value="#cost_price_money#">
                                                    <cfif is_update eq 0>
                                                        <input type="hidden" name="product_cost#currentrow#" id="product_cost#currentrow#" value="#product_cost#"><!--- giydirilmiş maliyet --->
                                                        <input type="hidden" name="product_cost_money#currentrow#" id="product_cost_money#currentrow#" value="#product_cost_money#"><!--- giydirilmiş maliyet para birimi--->
                                                    </cfif>
                                                    <input type="hidden" name="kdv_amount#currentrow#" id="kdv_amount#currentrow#" value="#tax#"><!--- ürün kdv oranı //tax_purchase--->
                                                    <input type="hidden" name="cost_price_system#currentrow#" id="cost_price_system#currentrow#" value="#cost_price_system#">
                                                    <input type="hidden" name="purchase_extra_cost_system#currentrow#" id="purchase_extra_cost_system#currentrow#" value="#purchase_extra_cost_system#">
                                                    <input type="hidden" name="purchase_extra_cost#currentrow#" id="purchase_extra_cost#currentrow#" value="#purchase_extra_cost#">
                                                    <input type="hidden" name="money_system#currentrow#" id="money_system#currentrow#" value="#cost_price_system_money#">
                                                    
                                                    <cfif is_update eq 1>
                                                        <cfif len(spect_id) or len(spec_main_id)>
                                                            <cfquery name="GET_SPECT" datasource="#DSN3#">
                                                                <cfif len(spect_id)>
                                                                    SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#spect_id#">
                                                                <cfelse>
                                                                    SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SPEC_MAIN_ID#">
                                                                </cfif>
                                                            </cfquery>
                                                            <input type="hidden" name="spect_id_#currentrow#" id="spect_id_#currentrow#" value="#spect_id#">
                                                            <input type="hidden" name="spec_main_id#currentrow#" id="spec_main_id#currentrow#" value="#spec_main_id#" readonly style="width:40px;">
                                                            <input type="hidden" name="spect_id#currentrow#" id="spect_id#currentrow#"value="#spect_id#" readonly style="width:40px;">
                                                            <input type="hidden" name="spect_name#currentrow#" id="spect_name#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:100px;">
                                                        <cfelse>
                                                            <input type="hidden" name="spect_id_#currentrow#" id="spect_id_#currentrow#" value="">
                                                            <input type="hidden" value="" name="spec_main_id#currentrow#" id="spec_main_id#currentrow#" readonly style="width:40px;">
                                                            <input type="hidden" name="spect_id#currentrow#" id="spect_id#currentrow#" value="" readonly style="width:40px;">
                                                            <input type="hidden" name="spect_name#currentrow#" id="spect_name#currentrow#" value="" readonly style="width:100px;">
                                                        </cfif>
                                                    <cfelse>
                                                        <cfif ( isdefined('#sonuc_query#.spec_main_id') and len(evaluate('#sonuc_query#.spec_main_id')) and evaluate('#sonuc_query#.spec_main_id') gt 0) or (isdefined('#sonuc_query#.spect_var_id') and len(evaluate('#sonuc_query#.spect_var_id')) and evaluate('#sonuc_query#.spect_var_id') gt 0)><!--- demontajda GET_SUB_PRODUCTS querysi calistigi icin burda spect olmamali yari mamulün spectini bilemeyiz--->
                                                            <cfquery name="GET_SPECT" datasource="#DSN3#">
                                                                <cfif len(evaluate('#sonuc_query#.spect_var_id'))>
                                                                    SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('#sonuc_query#.spect_var_id')#">
                                                                <cfelse>
                                                                    SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('#sonuc_query#.spec_main_id')#">
                                                                </cfif>
                                                            </cfquery>
                                                            <input type="hidden" name="spect_id_#currentrow#" id="spect_id_#currentrow#" value="#evaluate('#sonuc_query#.spect_var_id')#">
                                                            <input type="hidden" name="spec_main_id#currentrow#" id="spec_main_id#currentrow#" value="#evaluate('#sonuc_query#.spec_main_id')#" readonly style="width:40px;">
                                                            <input type="hidden" name="spect_id#currentrow#" id="spect_id#currentrow# value="#evaluate('#sonuc_query#.spect_var_id')#"" readonly style="width:40px;">
                                                            <input type="hidden" name="spect_name#currentrow#" id="spect_name#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:150px;">
                                                        <cfelse>
                                                            <cfif is_production eq 1 and not len(related_spect_id) or related_spect_id eq 0>
                                                                <cfif isdefined('is_production') and is_production eq 1 and((isdefined('stock#stock_id#_spec_main_id') and not len(Evaluate('stock#stock_id#_spec_main_id'))) or not isdefined('stock#stock_id#_spec_main_id'))>
                                                                    <cfscript>
                                                                        create_spect_from_product_tree = get_main_spect_id(stock_id);
                                                                        if(len(create_spect_from_product_tree.spect_main_id))
                                                                            'stock#stock_id#_spec_main_id' = create_spect_from_product_tree.spect_main_id;
                                                                    </cfscript>  
                                                                </cfif>
                                                            <cfelse>
                                                               <cfset 'stock#stock_id#_spec_main_id' = related_spect_id>
                                                            </cfif>
                        
                                                            <cfif isdefined('stock#stock_id#_spec_main_id') and len(Evaluate('stock#stock_id#_spec_main_id'))>
                                                                <cfquery name="GET_SPECT_S_" datasource="#dsn3#">
                                                                    SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('stock#stock_id#_spec_main_id')#">
                                                                </cfquery>
                                                                <cfif get_spect_s_.recordcount>
                                                                    <cfset _spec_main_name__ = get_spect_s_.spect_var_name>
                                                                </cfif>
                                                            <cfelse>
                                                               <cfset _spec_main_name__ = ''>
                                                            </cfif>                                
                                                            <input type="hidden" value="" name="spect_id_#currentrow#" id="spect_id_#currentrow#">
                                                            <input type="hidden" name="spec_main_id#currentrow#" id="spec_main_id#currentrow#" value="<cfif isdefined('stock#stock_id#_spec_main_id')>#Evaluate('stock#stock_id#_spec_main_id')#</cfif>" readonly style="width:40px;">
                                                            <input type="hidden" value="" name="spect_id#currentrow#" id="spect_id#currentrow#" readonly style="width:40px;">
                                                            <input type="hidden" name="spect_name#currentrow#" id="spect_name#currentrow#" value="#_spec_main_name__#" readonly style="width:150px;">
                                                        </cfif>
                                                    </cfif>
                                                    <td style="width:27px;">
                                                        <cfset _amount_ = wrk_round(amount,default_round,1)>
                                                        <cfif is_update eq 1>
                                                            <cfif len(get_row_enter.fire_amount)><cfset fire_amount_ = get_row_enter.fire_amount><cfelse><cfset fire_amount_ = 0></cfif>
                                                            <input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#TlFormat(_amount_,default_round)#" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,1); <cfif get_production_orders.is_demontaj eq 0 and isdefined('get_sum_amount')>aktar();</cfif>"<cfif get_fis_control.recordcount>readonly</cfif> class="moneybox" style="width:25.5px;"></td>
                                                            <input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="#TlFormat(_amount_+fire_amount_,default_round)#" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox" <cfif is_change_amount_demontaj eq 0>readonly</cfif>>
                                                        <cfelse>
                                                            <cfif isDefined("sub_spec_main_id") and isdefined('multipler_#sub_spec_main_id#')>
                                                                <cfset _amount_ =  evaluate('multipler_#sub_spec_main_id#')*amount>
                                                            </cfif>
                                                            <cfif get_production_orders.is_demontaj eq 1><!---demantajda miktar carpmali demontaj alt ürünler--->
                                                                <cfif get_row_amount.recordcount>
                                                                    <cfset kalan_uretim_miktarı = get_production_orders.amount-get_sum_amount.sum_amount><cfif kalan_uretim_miktarı lt 0><cfset kalan_uretim_miktarı = 1></cfif>
                                                                    <cfset kalan_uretim_miktarı_new = _amount_*kalan_uretim_miktarı>
                                                                    <input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#TlFormat(_AMOUNT_*(kalan_uretim_miktarı),default_round)#" style="width:25.5px;" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,1);" class="moneybox" <cfif is_change_amount_demontaj eq 0>readonly=""</cfif>></td>
                                                                    <input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="#TlFormat(_AMOUNT_*(kalan_uretim_miktarı),default_round)#" style="width:25.5px;" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,1);" class="moneybox" <cfif is_change_amount_demontaj eq 0>readonly=""</cfif>>
                                                                <cfelseif not get_row_amount.recordcount>
                                                                    <cfset kalan_uretim_miktarı_new = _amount_*get_production_orders.amount>
                                                                    <input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#TlFormat(_AMOUNT_*Get_Production_Orders.AMOUNT,default_round)#" style="width:25.5px;" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,1);" class="moneybox" <cfif is_change_amount_demontaj eq 0>readonly=""</cfif>></td>
                                                                    <input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="#TlFormat(_AMOUNT_*Get_Production_Orders.AMOUNT,default_round)#" style="width:25.5px;" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,1);" class="moneybox" <cfif is_change_amount_demontaj eq 0>readonly=""</cfif>>
                                                                </cfif>	
                                                            <cfelse><!--- Normal ürün ismi --->
                                                                <cfif get_row_amount.recordcount and type_product eq 1>
                                                                    <cfset kalan_uretim_miktarı = _amount_-get_sum_amount.sum_amount><cfif kalan_uretim_miktarı lt 0><cfset kalan_uretim_miktarı = 1></cfif>
                                                                    <input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#TlFormat(kalan_uretim_miktarı,default_round)#" style="width:25.5px;" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox"></td>
                                                                    <input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="#TlFormat(kalan_uretim_miktarı,default_round)#" style="width:25.5px;" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox">
                                                                <cfelseif not get_row_amount.recordcount or type_product eq 0>
                                                                    <input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#TlFormat(_AMOUNT_,default_round)#" style="width:25.5px;" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox"></td>
                                                                    <input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="#TlFormat(_AMOUNT_,default_round)#" style="width:25.5px;" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox">
                                                                <cfelseif _amount_ eq get_sum_amount.sum_amount>
                                                                    <input type="text" name="amount#currentrow#" id="amount#currentrow#" value="0" onkeyup="return(FormatCurrency(this,event,default_round));" style="width:25.5px;" onblur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox" onclick="aktar();"></td>
                                                                    <input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="0" onkeyup="return(FormatCurrency(this,event,default_round));" style="width:25.5px;" onblur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox" onclick="aktar();"> 
                                                                </cfif>	
                                                            </cfif>
                                                        </cfif>
                                                    </td>
                                                    <td style="width:27px;"><input type="text" name="fire_amount_#currentrow#" id="fire_amount_#currentrow#" style="width:25.5px;" value="#TLFormat(fire_amount_,default_round)#" class="moneybox" onkeyup="FormatCurrency(this,2);" <cfif session.pda.use_onkeydown_enter>onkeydown<cfelse>onchange</cfif>="<cfif session.pda.use_onkeydown_enter>if(event.keyCode == 13)</cfif> {clear_barcode();}" onblur="hesapla_deger(#currentrow#,0);aktar();"></td>
                                                    <td><input type="text" style="width:120px;" name="barcode#currentrow#" id="barcode#currentrow#" value="#barcod#">
                                                        <a href="javascript://" onclick="del_production_barcode(1,#currentrow#);"><img  src="images/delete_list.gif" align="absmiddle" border="0"></a>
                                                        <a href="javascript://" onclick="gizle_goster('tr_product_name#currentrow#');"><img  src="images/plus_ques.gif" align="absmiddle" border="0"></a>
                                                    </td>
                                                </tr>
                                                <tr id="tr_product_name#currentrow#" style="display:none;">
                                                    <td colspan="3"><input type="text" style="width:189px;" name="product_name#currentrow#" id="product_name#currentrow#" value="#product_name#" readonly></td>
                                                </tr>
                                            </table>
                                            </div>
                                        </cfloop>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </div>
                <div id="production_exit_row_div"><!--- Sarf Blogu --->
                    <tr style="height:30px;">
                        <td colspan="2" class="txtboldblue">Sarf Bilgileri</td>
                    </tr>
                    <tr>
                        <td colspan="2" style="vertical-align:top;">
                            <table cellpadding="1" cellspacing="0">
                                <tr>
                                    <td style="width:60px;">Barkod</td>
                                    <td><input type="text" name="search_barcode_exit" id="search_barcode_exit" value="" style="width:120px;" <cfif session.pda.use_onkeydown_enter>onkeydown<cfelse>onchange</cfif>="<cfif session.pda.use_onkeydown_enter>if(event.keyCode == 13)</cfif> {document.getElementById('search_lot_no_exit').select();}"></td>
                                </tr>
                                <tr>
                                    <td>Lot No</td>
                                    <td><input type="text" name="search_lot_no_exit" id="search_lot_no_exit" value="" style="width:120px;" <cfif session.pda.use_onkeydown_enter>onkeydown<cfelse>onchange</cfif>="<cfif session.pda.use_onkeydown_enter>if(event.keyCode == 13)</cfif> {return add_production_barcode(2,document.getElementById('search_barcode_exit').value);}"></td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <table cellpadding="1" cellspacing="0">
                                            <tr>
                                                <td style="width:27px;">Miktar</td>
                                                <td style="width:57px;">Lot No</td>
                                                <td style="width:140px;">Ürün</td>
                                            </tr>
                                            <tr>
                                                <td colspan="3">
                                                    <cfif is_update eq 1>
                                                        <cfset sarf_query='get_row_exit'>
                                                    <cfelse>
                                                        <cfif get_production_orders.is_demontaj eq 1>
                                                            <cfset sarf_query='get_production_orders'>
                                                        <cfelse>
                                                            <cfset sarf_query='get_sub_products'>
                                                        </cfif>
                                                    </cfif>
                                                    <cfif evaluate('#sarf_query#.recordcount')>
                                                    	<cfset sarf_recordcount = evaluate('#sarf_query#.recordcount')>
                                                    <cfelse>
                                                    	<cfset sarf_recordcount = 0>
                                                    </cfif>
                                                    <input type="hidden" name="record_num_exit" id="record_num_exit" value="#sarf_recordcount#">
                                                    <cfif sarf_recordcount>
                                                        <cfloop query="#sarf_query#">
                                                            <div id="product_info_exit#currentrow#">
                                                            <table cellpadding="1" cellspacing="0">
                                                                <cfif is_update eq 1>
                                                                    <cfquery name="GET_PRODUCT" datasource="#DSN1#">
                                                                        SELECT 
                                                                            PRODUCT.PRODUCT_NAME,
                                                                            PRODUCT.BARCOD,
                                                                            STOCKS.PRODUCT_UNIT_ID,
                                                                            PRODUCT_UNIT.ADD_UNIT,
                                                                            PRODUCT_UNIT.MAIN_UNIT,
                                                                            PRODUCT_UNIT.DIMENTION,
                                                                            STOCKS.PROPERTY,
                                                                            STOCKS.STOCK_CODE
                                                                        FROM 
                                                                            PRODUCT,
                                                                            STOCKS,
                                                                            PRODUCT_UNIT
                                                                        WHERE 
                                                                            STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                                                                            STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> AND
                                                                            PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                                                                            PRODUCT_UNIT.PRODUCT_UNIT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable#"> AND
                                                                            PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
                                                                    </cfquery>
                                                                    <cfset stock_code = get_product.stock_code>
                                                                    <cfset product_unit_id = get_product.product_unit_id>
                                                                    <cfset main_unit = get_product.main_unit>
                                                                    <cfset cost_price = purchase_net_system>
                                                                    <cfset cost_price_money = purchase_net_system_money>
                                                                    <cfset cost_price_system = purchase_net_system>
                                                                    <cfset cost_price_system_money = purchase_net_system_money>
                                                                    <cfset barcod = get_product.barcod>
                                                                    <cfset product_name = get_product.product_name>
                                                                    <cfset tax = kdv_price>
                                                                    <cfquery name="GET_IS_PRODUCTION" datasource="#DSN3#">
                                                                        SELECT TOP 1 IS_PRODUCTION FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                                                                    </cfquery>
                                                                    <cfset is_production = get_is_production.is_production>
                                                                    <cfset lot_no_exit = lot_no>
                                                                <cfelse>
                                                                    <cfif get_production_orders.is_demontaj neq 1>
                                                                        <cfquery name="GET_PRODUCT" datasource="#DSN3#" maxrows="1">
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
                                                                                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
                                                                                START_DATE <= #createodbcdate(get_production_orders.finish_date)#
                                                                            ORDER BY 
                                                                                START_DATE DESC,
                                                                                RECORD_DATE DESC,
                                                                                PRODUCT_COST_ID DESC
                                                                        </cfquery>
                                                                        <cfscript>
                                                                            if(session.pda.period_year gt 2008){//1 sene sonra kaldırılmalı!
                                                                                if(get_product.money is "YTL") get_product.money = 'TL';
                                                                                if(get_product.purchase_net_money is "YTL") get_product.purchase_net_money = 'TL';
                                                                                if(get_product.purchase_net_system_money is "YTL") get_product.purchase_net_system_money = 'TL';
                                                                            }
                                                                            if(get_product.recordcount eq 0)
                                                                            {
                                                                                cost_id = 0;
                                                                                purchase_extra_cost = 0;
                                                                                product_cost = 0;
                                                                                product_cost_money = session.pda.money;
                                                                                cost_price = 0;
                                                                                cost_price_money = session.pda.money;
                                                                                cost_price_system = 0;
                                                                                cost_price_system_money = session.pda.money;
                                                                                purchase_extra_cost_system = 0;
                                                                            }
                                                                            else
                                                                            {
                                                                                cost_id = get_product.product_cost_id;
                                                                                purchase_extra_cost = get_product.purchase_extra_cost;
                                                                                product_cost = get_product.product_cost;
                                                                                product_cost_money = get_product.money;
                                                                                cost_price = get_product.purchase_net;
                                                                                cost_price_money = get_product.purchase_net_money;
                                                                                cost_price_system = get_product.purchase_net_system;
                                                                                cost_price_system_money = get_product.purchase_net_system_money;
                                                                                purchase_extra_cost_system = get_product.purchase_extra_cost_system;
                                                                            }
                                                                        </cfscript>
                                                                        <cfset lot_no_exit = "">
                                                                    </cfif>
                                                                    <cfif get_production_orders.is_demontaj eq 1><!---demantajda miktar carpmayalim--->
                                                                        <cfif isdefined('get_sum_amount')>
                                                                            <cfset sarf_kalan_uretim_emri = get_production_orders.amount-get_sum_amount.sum_amount><cfif sarf_kalan_uretim_emri lt 0><cfset sarf_kalan_uretim_emri=1></cfif>
                                                                            <cfset sarf_kalan_uretim_emri_new = sarf_kalan_uretim_emri>
                                                                        <cfelse>
                                                                            <cfset sarf_kalan_uretim_emri_new = get_production_orders.amount>
                                                                        </cfif>
                                                                    <cfelse>
                                                                        <cfif isdefined('get_sum_amount')><!--- Normal ürün alt ürünleri --->
                                                                            <cfset sarf_kalan_uretim_emri = get_production_orders.amount-get_sum_amount.sum_amount><cfif sarf_kalan_uretim_emri lt 0><cfset sarf_kalan_uretim_emri=1></cfif>
                                                                        </cfif>
                                                                    </cfif>
                                                                    <cfif get_production_orders.is_demontaj eq 1>
                                                                        <cfscript>
                                                                            cost_id = 0;
                                                                            purchase_extra_cost = demontaj_purchase_extra_cost_system/sarf_kalan_uretim_emri_new;
                                                                            product_cost = demontaj_cost_price_system/sarf_kalan_uretim_emri_new;
                                                                            product_cost_money = session.pda.money;
                                                                            cost_price = demontaj_cost_price_system/sarf_kalan_uretim_emri_new;
                                                                            cost_price_money = session.pda.money;
                                                                            cost_price_system = demontaj_cost_price_system/sarf_kalan_uretim_emri_new;
                                                                            cost_price_system_money = session.pda.money;
                                                                            purchase_extra_cost_system =demontaj_purchase_extra_cost_system/sarf_kalan_uretim_emri_new;
                                                                        </cfscript>
                                                                    </cfif>
                                                                </cfif>
                                                                
                                                                <input type="hidden" name="cost_id_exit#currentrow#" id="cost_id_exit#currentrow#" value="#cost_id#">
                                                                <input type="hidden" name="is_free_amount#currentrow#" id="is_free_amount#currentrow#" value="#is_free_amount#">
                                                                <input type="hidden" name="tree_type_exit_#currentrow#" id="tree_type_exit_#currentrow#" value="#tree_type#">
                                                                <input type="hidden" name="row_kontrol_exit#currentrow#" id="row_kontrol_exit#currentrow#" value="1">
                                                                <cfif is_update eq 0>
                                                                    <input type="hidden" name="product_cost_exit#currentrow#" id="product_cost_exit#currentrow#" value="#product_cost#"><!--- giydirilmiş maliyet --->
                                                                    <input type="hidden" name="product_cost_money_exit#currentrow#" id="product_cost_money_exit#currentrow#" value="#product_cost_money#"><!--- giydirilmiş maliyet para birimi--->
                                                                </cfif>
                                                                <input type="hidden" name="kdv_amount_exit#currentrow#" id="kdv_amount_exit#currentrow#" value="#tax#"><!--- ürün kdv oranı //tax_purchase--->
                                                                
                                                                <input type="hidden" name="stock_id_exit#currentrow#" id="stock_id_exit#currentrow#" value="#stock_id#">
                                                                <input type="hidden" name="stock_code_exit#currentrow#" id="stock_code_exit#currentrow#" value="#stock_code#">
                                                                <input type="hidden" name="product_id_exit#currentrow#" id="product_id_exit#currentrow#" value="#product_id#">
                                                                <input type="hidden" name="unit_id_exit#currentrow#" id="unit_id_exit#currentrow#" value="#product_unit_id#">
                                                                <input type="hidden" name="unit_exit#currentrow#" id="unit_exit#currentrow#" value="#main_unit#">
                                                                <input type="hidden" name="serial_no_exit#currentrow#" id="serial_no_exit#currentrow#" value="">
                                                                <input type="hidden" name="is_production_spect_exit#currentrow#" id="is_production_spect_exit#currentrow#" value="<cfif isdefined('IS_PRODUCTION') and IS_PRODUCTION eq 1>1<cfelse>0</cfif>"><!--- Üretilen bir ürün ise hidden alan 1 oluyor ve query sayfasında bu ürün için otomatik bir spect oluşuyor --->
                                                                
                                                                <input type="hidden" name="cost_price_exit#currentrow#" id="cost_price_exit#currentrow#" value="#cost_price#">
                                                                <input type="hidden" name="cost_price_system_exit#currentrow#" id="cost_price_system_exit#currentrow#" value="#cost_price_system#">
                                                                <input type="hidden" name="purchase_extra_cost_system_exit#currentrow#" id="purchase_extra_cost_system_exit#currentrow#" value="#purchase_extra_cost_system#">
                                                                <input type="hidden" name="purchase_extra_cost_exit#currentrow#" id="purchase_extra_cost_exit#currentrow#" value="#purchase_extra_cost#">
                                                                <input type="hidden" name="money_system_exit#currentrow#" id="money_system_exit#currentrow#" value="#cost_price_system_money#">
                                                                <input type="hidden" name="money_exit#currentrow#" id="money_exit#currentrow#" value="#cost_price_money#">
                                                                
                                                                <!--- Spec Duzenlemeleri, Display Etmiyoruz --->
                                                                <cfif is_update eq 1>
                                                                    <cfif len(get_row_exit.spect_id) OR LEN(get_row_exit.spec_main_id)>
                                                                        <cfquery name="GET_SPECT" datasource="#DSN3#">
                                                                            <cfif len(get_row_exit.spect_id)>
                                                                                SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_exit.spect_id#">
                                                                            <cfelse>
                                                                                SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_exit.spec_main_id#">
                                                                            </cfif>
                                                                        </cfquery>
                                                                        <input type="hidden" name="spect_id_exit_#currentrow#" id="spect_id_exit_#currentrow#" value="#get_row_exit.spect_id#" >
                                                                        <input type="hidden" name="spec_main_id_exit#currentrow#" id="spec_main_id_exit#currentrow#" value="#get_row_exit.spec_main_id#" readonly style="width:40px;">
                                                                        <input type="hidden" name="spect_id_exit#currentrow#" id="spect_id_exit#currentrow#" value="#get_row_exit.spect_id#"  readonly style="width:40px;">
                                                                        <input type="hidden" name="spect_name_exit#currentrow#" id="spect_name_exit#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:150px;">
                                                                    <cfelse>
                                                                    <!--- Demontaj sırasında spect'in değişip değişmediğini kontrol etmek için,değişmiş ise sayfa reload ediliyor. --->
                                                                        <input type="hidden" name="spect_id_exit_#currentrow#" id="spect_id_exit_#currentrow#" value="">
                                                                        <input type="hidden" name="spec_main_id_exit#currentrow#" id="spec_main_id_exit#currentrow#" value="" readonly style="width:40px;">
                                                                        <input type="hidden" name="spect_id_exit#currentrow#" id="spect_id_exit#currentrow#" value="" readonly style="width:40px;">
                                                                        <input type="hidden" name="spect_name_exit#currentrow#" id="spect_name_exit#currentrow#" value="" readonly style="width:150px;">
                                                                    </cfif>
                                                                <cfelse>
                                                                    <cfif get_production_orders.is_demontaj eq 1 and ( len(get_production_orders.spect_var_id) or len(get_production_orders.spec_main_id) ) ><!--- demontaj ve spec varsa sarfta spec olur--->
                                                                        <cfquery name="GET_SPECT" datasource="#DSN3#">
                                                                            <cfif len(get_production_orders.spect_var_id)>
                                                                                SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_production_orders.spect_var_id#">
                                                                            <cfelse>
                                                                                SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_production_orders.spec_main_id#">
                                                                            </cfif>
                                                                        </cfquery>
                                                                        <input type="hidden" name="spect_id_exit_#currentrow#" id="spect_id_exit_#currentrow#" value="#Get_Production_Orders.spect_var_id#">
                                                                        <input type="#Evaluate('spec_display')#" name="spec_main_id_exit#currentrow#" id="spec_main_id_exit#currentrow#" value="#Get_Production_Orders.spec_main_id#" readonly style="width:40px;">
                                                                        <input type="#Evaluate('spec_display')#" name="spect_id_exit#currentrow#" id="spect_id_exit#currentrow#" value="#Get_Production_Orders.spect_var_id#" readonly style="width:40px;">
                                                                        <input type="#Evaluate('spec_name_display')#" name="spect_name_exit#currentrow#" id="spect_name_exit#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:150px;">
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
                                                                        <cfif isdefined('stock#stock_id#_spec_main_id') and len(Evaluate('stock#stock_id#_spec_main_id'))>
                                                                            <cfquery name="GET_SPECT_S" datasource="#DSN3#">
                                                                                SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = #Evaluate('stock#stock_id#_spec_main_id')#
                                                                            </cfquery>
                                                                            <cfif get_spect_s.recordcount>
                                                                                <cfset _spec_main_name__ = get_spect_s.spect_var_name>
                                                                            </cfif>
                                                                        <cfelse>
                                                                            <cfset _spec_main_name__ = ''>
                                                                        </cfif>
                                                                        <input type="hidden" name="spect_id_exit_#currentrow#" id="spect_id_exit_#currentrow#"value=""><!--- <cfif isdefined('stock#STOCK_ID#_spect_id')>#Evaluate('stock#STOCK_ID#_spect_id')#<cfelseif isdefined('spect_id_exit')>#spect_id_exit#</cfif> --->
                                                                        <input type="#Evaluate('spec_display')#" name="spec_main_id_exit#currentrow#" id="spec_main_id_exit#currentrow#" value="<cfif isdefined('stock#stock_id#_spec_main_id')>#Evaluate('stock#stock_id#_spec_main_id')#</cfif>" readonly style="width:40px;">
                                                                        <input type="#Evaluate('spec_display')#" name="spect_id_exit#currentrow#" id="spect_id_exit#currentrow#" value="" readonly style="width:40px;"><!--- <cfif isdefined('stock#STOCK_ID#_spect_id')>#Evaluate('stock#STOCK_ID#_spect_id')#<cfelseif isdefined('spect_id_exit')>#spect_id_exit#</cfif> --->
                                                                        <input type="#Evaluate('spec_name_display')#" name="spect_name_exit#currentrow#" id="spect_name_exit#currentrow#" value="#_spec_main_name__#" readonly style="width:150px;"><!--- <cfif isdefined('stock#STOCK_ID#_spect_name')>#Evaluate('stock#STOCK_ID#_spect_name')#<cfelseif isdefined('spect_name_exit')>#spect_name_exit#</cfif> --->
                                                                    </cfif>
                                                                </cfif>
                                                                <!--- //Spec Duzenlemeleri, Display Etmiyoruz --->
                
                                                                <tr>
                                                                    <td><cfset _amount_ = wrk_round(amount,default_round,1)>
                                                                        <cfif is_update eq 1>
                                                                            <input type="text" name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat(_amount_,default_round)#" onkeyup="return(FormatCurrency(this,event,#default_round#));"  onblur="hesapla_deger(#currentrow#,0);<cfif Get_Production_Orders.IS_DEMONTAJ eq 1 and isdefined('GET_SUM_AMOUNT')>aktar();</cfif>" <cfif Get_Production_Orders.IS_DEMONTAJ eq 0>readonly</cfif> class="moneybox" style="width:25.5px;">
                                                                            <input type="hidden" name="amount_exit_#currentrow#" id="amount_exit_#currentrow#" value="#TlFormat(_amount_,default_round)#" onkeyup="return(FormatCurrency(this,event,#default_round#));"  onblur="hesapla_deger(#currentrow#,0);" class="moneybox">
                                                                        <cfelse>
                                                                            <cfif isDefined("sub_spec_main_id") and isdefined('multipler_#sub_spec_main_id#')>
                                                                                <cfset _amount_ =  evaluate('multipler_#sub_spec_main_id#')*amount>
                                                                            </cfif>
                                                                            <cfif get_production_orders.is_demontaj eq 1><!---demantajda miktar carpmayalim--->
                                                                                <cfif isdefined('get_sum_amount')>
                                                                                    <cfset sarf_kalan_uretim_emri = get_production_orders.amount-get_sum_amount.sum_amount><cfif sarf_kalan_uretim_emri lt 0><cfset sarf_kalan_uretim_emri=1></cfif>
                                                                                    <cfset sarf_kalan_uretim_emri_new = sarf_kalan_uretim_emri>
                                                                                    <input type="text" name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat(sarf_kalan_uretim_emri,default_round)#" style="width:25.5px;" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,2);aktar();" class="moneybox">
                                                                                    <input type="hidden" name="amount_exit_#currentrow#" id="amount_exit_#currentrow#" value="#TlFormat(sarf_kalan_uretim_emri,default_round)#" style="width:25.5px;" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,2);aktar();" class="moneybox">
                                                                                <cfelse>
                                                                                    <cfset sarf_kalan_uretim_emri_new = get_production_orders.amount>
                                                                                    <input type="text" name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat(Get_Production_Orders.amount,default_round)#" style="width:25.5px;" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,2);aktar();" class="moneybox" onclick="aktar();">
                                                                                    <input type="hidden" name="amount_exit_#currentrow#" id="amount_exit_#currentrow#" value="#TlFormat(Get_Production_Orders.amount,default_round)#" style="width:25.5px;" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,2);aktar();" class="moneybox" onclick="aktar();">
                                                                                </cfif>
                                                                            <cfelse>
                                                                                <cfif is_free_amount eq 1>
                                                                                    <input type="text" name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat(wrk_round(_amount_,default_round,1),default_round)#" style="width:25.5px;" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,2);" class="moneybox" #_readonly_#>
                                                                                    <input type="hidden" name="amount_exit_#currentrow#" id="amount_exit_#currentrow#" value="#TlFormat(wrk_round(_amount_,default_round,1),default_round)#" style="width:25.5px;" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,2);" class="moneybox" readonly="">
                                                                                <cfelse>	
                                                                                    <cfif isdefined('get_sum_amount')><!--- Normal ürün alt ürünleri --->
                                                                                        <cfset sarf_kalan_uretim_emri = get_production_orders.amount-get_sum_amount.sum_amount><cfif sarf_kalan_uretim_emri lt 0><cfset sarf_kalan_uretim_emri=1></cfif>
                                                                                        <input type="text" name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat(_amount_*(sarf_kalan_uretim_emri),default_round)#" style="width:25.5px;" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,2);" class="moneybox" #_readonly_# >
                                                                                        <input type="hidden" name="amount_exit_#currentrow#" id="amount_exit_#currentrow#" value="#TlFormat(_amount_*(sarf_kalan_uretim_emri),default_round)#" style="width:25.5px;" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,2);" class="moneybox" readonly="">
                                                                                    <cfelse>
                                                                                        <input type="text" name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat(wrk_round(_amount_*(get_production_orders.amount),default_round,1),default_round)#" style="width:25.5px;" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,2);" class="moneybox" #_readonly_#>
                                                                                        <input type="hidden" name="amount_exit_#currentrow#" id="amount_exit_#currentrow#" value="#TlFormat(wrk_round(_amount_*(get_production_orders.amount),default_round,1),default_round)#" style="width:25.5px;" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,2);" class="moneybox" readonly="">
                                                                                    </cfif>
                                                                                </cfif>
                                                                            </cfif>
                                                                        </cfif>
                                                                    </td>
                                                                    <td><input type="text" name="lot_no_exit#currentrow#" id="lot_no_exit#currentrow#" style="width:54px;" value="#lot_no_exit#" onkeyup="FormatCurrency(this,2);" <cfif session.pda.use_onkeydown_enter>onkeydown<cfelse>onchange</cfif>="<cfif session.pda.Use_onKeyDown_Enter>if(event.keyCode == 13)</cfif> {clear_barcode();}"></td>
                                                                    <td><input type="text" name="barcode_exit#currentrow#" id="barcode_exit#currentrow#" value="#barcod#" style="width:90px;">
                                                                        <a href="javascript://" onclick="del_production_barcode(2,#currentrow#);"><img  src="images/delete_list.gif" align="absmiddle" border="0"></a>
                                                                        <a href="javascript://" onclick="gizle_goster('tr_product_name_exit#currentrow#');"><img  src="images/plus_ques.gif" align="absmiddle" border="0"></a>
                                                                    </td>
                                                                </tr>
                                                                <tr id="tr_product_name_exit#currentrow#" style="display:none;">
                                                                    <td colspan="3"><input type="text" style="width:191px;" name="product_name_exit#currentrow#" id="product_name_exit#currentrow#" value="#product_name#" readonly></td>
                                                                </tr>
                                                            </table>
                                                            </div>
                                                        </cfloop>
                                                    </cfif>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </div>
                <div id="production_outage_row_div"><!--- Fire Blogu --->
                    <tr style="height:30px;">
                        <td colspan="2" class="txtboldblue">Fire Bilgileri</td>
                    </tr>
                    <tr valign="top">
                        <td colspan="2">
                            <table cellpadding="1" cellspacing="0">
                                <tr>
                                    <td style="width:60px;">Barkod</td>
                                    <td><input type="text" name="search_barcode_outage" id="search_barcode_outage" value="" style="width:120px;" <cfif session.pda.use_onkeydown_enter>onkeydown<cfelse>onchange</cfif>="<cfif session.pda.Use_onKeyDown_Enter>if(event.keyCode == 13)</cfif> {document.getElementById('search_lot_no_outage').select();}"></td>
                                </tr>
                                <tr>
                                    <td>Lot - Miktar</td>
                                    <td><input type="text" name="search_lot_no_outage" id="search_lot_no_outage" value="" style="width:85px;" <cfif session.pda.use_onkeydown_enter>onkeydown<cfelse>onchange</cfif>="<cfif session.pda.Use_onKeyDown_Enter>if(event.keyCode == 13)</cfif> {document.getElementById('search_amount_outage').select();}">
                                        <input type="text" name="search_amount_outage" id="search_amount_outage" value="0" style="width:25px;" <cfif session.pda.use_onkeydown_enter>onkeydown<cfelse>onchange</cfif>="<cfif session.pda.Use_onKeyDown_Enter>if(event.keyCode == 13)</cfif> {return add_production_barcode(3,document.getElementById('search_barcode_outage').value);}">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <table cellpadding="1" cellspacing="0">
                                            <tr>
                                                <td style="width:27px;">Miktar</td>
                                                <td style="width:57px;">Lot No</td>
                                                <td style="width:140px;">Ürün</td>
                                            </tr>
                                            <tr>
                                                <td colspan="3">
                                                    <cfif is_update eq 1>
                                                        <cfset fire_query='get_row_outage'>
                                                    <cfelse>
                                                        <cfif Get_Production_Orders.Is_Demontaj eq 1>
                                                            <cfset fire_query='get_production_orders'>
                                                        <cfelse>
                                                            <cfset fire_query='get_sub_products_fire'>
                                                        </cfif>
                                                    </cfif>
                                                    <cfif isdefined('#fire_query#.recordcount')><cfset fire_recordcount = evaluate('#fire_query#.recordcount')></cfif>
                                                    <input type="hidden" name="record_num_outage" id="record_num_outage" value="#fire_recordcount#">
                                                    <cfif (is_update eq 0 and Get_Production_Orders.is_demontaj eq 0) or is_update eq 1><!--- Demontajda fire çıktısı olmaz... --->
                                                        <cfif (is_update eq 0 and isdefined('get_sub_products_fire.recordcount')) or is_update eq 1>
                                                            <cfloop query="#fire_query#">
                                                                <cfif is_update eq 1>
                                                                    <cfquery name="GET_PRODUCT" datasource="#DSN1#">
                                                                        SELECT 
                                                                            PRODUCT.PRODUCT_NAME,
                                                                            PRODUCT.BARCOD,
                                                                            STOCKS.PRODUCT_UNIT_ID,
                                                                            PRODUCT_UNIT.ADD_UNIT,
                                                                            PRODUCT_UNIT.MAIN_UNIT,
                                                                            PRODUCT_UNIT.DIMENTION,
                                                                            STOCKS.PROPERTY,
                                                                            STOCKS.STOCK_CODE
                                                                        FROM 
                                                                            PRODUCT,
                                                                            STOCKS,
                                                                            PRODUCT_UNIT
                                                                        WHERE 
                                                                            PRODUCT.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
                                                                            STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                                                                            STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> AND
                                                                            PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                                                                            PRODUCT_UNIT.PRODUCT_UNIT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable#"> AND
                                                                            PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
                                                                    </cfquery>
                                                                    <cfset stock_code = GET_PRODUCT.stock_code>
                                                                    <cfset product_unit_id = GET_PRODUCT.product_unit_id>
                                                                    <cfset main_unit = GET_PRODUCT.main_unit>
                                                                    <cfset cost_price = purchase_net_system>
                                                                    <cfset cost_price_money = purchase_net_system_money>
                                                                    <cfset cost_price_system = purchase_net_system>
                                                                    <cfset cost_price_system_money = purchase_net_system_money>
                                                                    <cfset barcod = GET_PRODUCT.barcod>
                                                                    <cfset product_name = GET_PRODUCT.product_name>
                                                                    <cfset tax = KDV_PRICE>
                                                                    <cfquery name="get_is_production" datasource="#dsn3#">
                                                                        SELECT TOP 1 IS_PRODUCTION FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                                                                    </cfquery>
                                                                    <cfset is_production = get_is_production.IS_PRODUCTION>
                                                                    <cfset lot_no_outage = lot_no>
                                                                <cfelse>
                                                                    <cfquery name="GET_PRODUCT_FIRE" datasource="#dsn3#" maxrows="1">
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
                                                                            PRODUCT_ID = #product_id# AND
                                                                            START_DATE <= #now()# 
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
                                                                            product_cost_money = session.pda.money;
                                                                            cost_price = 0;
                                                                            cost_price_money = session.pda.money;
                                                                            cost_price_system = 0;
                                                                            cost_price_system_money = session.pda.money;
                                                                            purchase_extra_cost_system = 0;
                                                                        }
                                                                        else
                                                                        {
                                                                            cost_id = GET_PRODUCT_FIRE.product_cost_id;
                                                                            purchase_extra_cost = GET_PRODUCT_FIRE.PURCHASE_EXTRA_COST;
                                                                            product_cost = GET_PRODUCT_FIRE.PRODUCT_COST;
                                                                            product_cost_money = GET_PRODUCT_FIRE.MONEY;
                                                                            cost_price = GET_PRODUCT_FIRE.PURCHASE_NET;
                                                                            cost_price_money = GET_PRODUCT_FIRE.PURCHASE_NET_MONEY;
                                                                            cost_price_system = GET_PRODUCT_FIRE.PURCHASE_NET_SYSTEM;
                                                                            cost_price_system_money = GET_PRODUCT_FIRE.PURCHASE_NET_SYSTEM_MONEY;
                                                                            purchase_extra_cost_system = GET_PRODUCT_FIRE.PURCHASE_EXTRA_COST_SYSTEM;
                                                                        }
                                                                    </cfscript>
                                                                    <cfset lot_no_outage = "">
                                                                </cfif>
                                                                
                                                                <div id="product_info_outage#currentrow#">
                                                                <table cellpadding="1" cellspacing="0">
                                                                    <input type="hidden" name="cost_id_outage#currentrow#" id="cost_id_outage#currentrow#" value="#cost_id#">
                                                                    <cfif is_update eq 0>
                                                                        <input type="hidden" name="product_cost_outage#currentrow#" id="product_cost_outage#currentrow#" value="#product_cost#"><!--- giydirilmiş maliyet --->
                                                                        <input type="hidden" name="product_cost_money_outage#currentrow#" id="product_cost_money_outage#currentrow#" value="#product_cost_money#"><!--- giydirilmiş maliyet para birimi--->
                                                                    </cfif>
                                                                    <input type="hidden" name="kdv_amount_outage#currentrow#" id="kdv_amount_outage#currentrow#" value="#tax#"><!--- ürün kdv oranı //tax_purchase--->
                                                                    <input type="hidden" name="cost_price_outage#currentrow#" id="cost_price_outage#currentrow#" value="#cost_price#">
                                                                    <input type="hidden" name="cost_price_system_outage#currentrow#" id="cost_price_system_outage#currentrow#" value="#cost_price_system#">
                                                                    <input type="hidden" name="purchase_extra_cost_system_outage#currentrow#" id="purchase_extra_cost_system_outage#currentrow#" value="#purchase_extra_cost_system#">
                                                                    <input type="hidden" name="purchase_extra_cost_outage#currentrow#" id="purchase_extra_cost_outage#currentrow#" value="#purchase_extra_cost#">
                                                                    <input type="hidden" name="money_system_outage#currentrow#" id="money_system_outage#currentrow#" value="#cost_price_system_money#">
                                                                    <input type="hidden" name="money_outage#currentrow#" id="money_outage#currentrow#" value="#cost_price_money#">
                    
                                                                    <input type="hidden" value="1" name="row_kontrol_outage#currentrow#" id="row_kontrol_outage#currentrow#">
                                                                    <input type="hidden" name="tree_type_outage_#currentrow#" id="tree_type_outage_#currentrow#" value="#TREE_TYPE#">
                                                                    <input type="hidden" name="stock_id_outage#currentrow#" id="stock_id_outage#currentrow#" value="#stock_id#">
                                                                    <input type="hidden" name="stock_code_outage#currentrow#" id="stock_code_outage#currentrow#" value="#stock_code#">
                                                                    <input type="hidden" name="product_id_outage#currentrow#" id="product_id_outage#currentrow#" value="#product_id#">
                                                                    <input type="hidden" name="unit_id_outage#currentrow#" id="unit_id_outage#currentrow#" value="#product_unit_id#">
                                                                    <input type="hidden" name="unit_outage#currentrow#" id="unit_outage#currentrow#" value="#main_unit#">
                                                                    <input type="hidden" name="serial_no_outage#currentrow#" id="serial_no_outaget#currentrow#" value="">
                                                                    <input type="hidden" name="is_production_spect_outage#currentrow#" id="is_production_spect_outage#currentrow#" value="<cfif isdefined('IS_PRODUCTION') and IS_PRODUCTION eq 1>1<cfelse>0</cfif>"><!--- Üretilen bir ürün ise hidden alan 1 oluyor ve query sayfasında bu ürün için otomatik bir spect oluşuyor --->
                                                                    
                                                                    
                                                                    <!--- Spec Duzenlemeleri, Display Etmiyoruz --->
                                                                    <cfif is_update eq 1>
                                                                        <cfif len(get_row_outage.spect_id)  OR LEN(get_row_outage.SPEC_MAIN_ID) >
                                                                            <cfquery name="GET_SPECT" datasource="#dsn3#">
                                                                                <cfif len(get_row_outage.spect_id)>
                                                                                    SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_outage.spect_id#">
                                                                                <cfelse>
                                                                                    SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_outage.SPEC_MAIN_ID#">
                                                                                </cfif>
                                                                            </cfquery>
                                                                            <input type="hidden" name="spec_main_id_outage#currentrow#" id="spec_main_id_outage#currentrow#" value="#get_row_outage.SPEC_MAIN_ID#" readonly style="width:40px;">
                                                                            <input type="hidden" name="spect_id_outage#currentrow#" id="spect_id_outage#currentrow#" value="#get_row_outage.spect_id#" readonly style="width:40px;">
                                                                            <input type="hidden" name="spect_name_outage#currentrow#" id="spect_name_outage#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:150px;">
                                                                        <cfelse>
                                                                            <input type="hidden" name="spec_main_id_outage#currentrow#" id="spec_main_id_outage#currentrow#" value="" readonly style="width:40px;">
                                                                            <input type="hidden" name="spect_id_outage#currentrow#" id="spect_id_outage#currentrow#" value="" readonly style="width:40px;">
                                                                            <input type="hidden" name="spect_name_outage#currentrow#" id="spect_name_outage#currentrow#" value="" readonly style="width:150px;">
                                                                        </cfif>
                                                                    <cfelse>
                                                                        <!--- Alt Üretim Emirlerinde Bir SpecMainId oluşmamış ise ve ürün bir *üretilen* ürün 
                                                                        ise bu ürün için MainSpecId'yi burda kendimiz oluşturuyoruz. --->
                                                                        <cfif is_production eq 1 and not len(related_spect_id) or related_spect_id eq 0>
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
                                                                        <input type="hidden" name="spec_main_id_outage#currentrow#" id="spec_main_id_outage#currentrow#" value="<cfif isdefined('stock#STOCK_ID#_spec_main_id')>#Evaluate('stock#STOCK_ID#_spec_main_id')#</cfif>" readonly style="width:40px;">
                                                                        <input type="hidden" name="spect_id_outage#currentrow#" id="spect_id_outage#currentrow#" value="" readonly style="width:40px;"><!--- <cfif isdefined('stock#STOCK_ID#_spect_id')>#Evaluate('stock#STOCK_ID#_spect_id')#<cfelseif isdefined('spect_id_exit')>#spect_id_exit#</cfif> --->
                                                                        <input type="hidden" name="spect_name_outage#currentrow#" id="spect_name_outage#currentrow#" value="#_spec_main_name__#" readonly style="width:150px;"><!--- <cfif isdefined('stock#STOCK_ID#_spect_name')>#Evaluate('stock#STOCK_ID#_spect_name')#<cfelseif isdefined('spect_name_exit')>#spect_name_exit#</cfif> --->
                                                                    </cfif>
                                                                    <!--- //Spec Duzenlemeleri, Display Etmiyoruz --->
                                                                    
                                                                    <tr>
                                                                        <td style="width:27px;">
                                                                            <cfif is_update eq 1>
                                                                                <cfset _AMOUNT_ = wrk_round(AMOUNT,default_round,1)>
                                                                                <input type="text" name="amount_outage#currentrow#" id="amount_outage#currentrow#" readonly value="#TlFormat(_AMOUNT_,default_round)#" onkeyup="return(FormatCurrency(this,event,default_round));" onblur="hesapla_deger(#currentrow#,2);" class="moneybox" style="width:25.5px;">
                                                                            <cfelse>
                                                                                <cfset _AMOUNT_ = wrk_round(AMOUNT,default_round,1)>
                                                                                <cfif isdefined('GET_SUM_AMOUNT')><!--- Normal ürün alt ürünleri --->
                                                                                    <cfset sarf_kalan_uretim_emri = Get_Production_Orders.AMOUNT-Get_Sum_Amount.SUM_AMOUNT><cfif sarf_kalan_uretim_emri lt 0><cfset sarf_kalan_uretim_emri=1></cfif>
                                                                                    <input type="text" name="amount_outage#currentrow#" id="amount_outage#currentrow#" style="width:25.5px;" value="#TlFormat(_AMOUNT_*(sarf_kalan_uretim_emri),default_round)#" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,3);aktar();" class="moneybox">
                                                                                    <input type="hidden" name="amount_outage_#currentrow#" id="amount_outage_#currentrow#" value="#TlFormat(_AMOUNT_*(sarf_kalan_uretim_emri),default_round)#" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,3);aktar();" class="moneybox">
                                                                                <cfelse>
                                                                                    <input type="text" name="amount_outage#currentrow#" id="amount_outage#currentrow#" style="width:25.5px;" value="#TlFormat(_AMOUNT_*Get_Production_Orders.AMOUNT,default_round)#" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,3);aktar();" class="moneybox">
                                                                                    <input type="hidden" name="amount_outage_#currentrow#" id="amount_outage_#currentrow#" value="#TlFormat(_AMOUNT_*Get_Production_Orders.AMOUNT,default_round)#" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,3);aktar();" class="moneybox">
                                                                                </cfif>
                                                                            </cfif>
                                                                        </td>
                                                                        <td style="width:57px;"><input type="text" name="lot_no_outage#currentrow#" id="lot_no_outage#currentrow#" style="width:54px;" value="#lot_no_outage#" onkeyup="FormatCurrency(this,2);" <cfif session.pda.use_onkeydown_enter>onkeydown<cfelse>onchange</cfif>="<cfif session.pda.Use_onKeyDown_Enter>if(event.keyCode == 13)</cfif> {clear_barcode();}"></td>
                                                                        <td><input type="text" name="barcode_outage#currentrow#" id="barcode_outage#currentrow#" value="#barcod#" style="width:90px;">
                                                                            <a href="javascript://" onclick="del_production_barcode(3,#currentrow#);"><img  src="images/delete_list.gif" align="absmiddle" border="0"></a>
                                                                            <a href="javascript://" onclick="gizle_goster('tr_product_name_outage#currentrow#');"><img  src="images/plus_ques.gif" align="absmiddle" border="0"></a>
                                                                        </td>
                                                                    </tr>
                                                                    <tr id="tr_product_name_outage#currentrow#" style="display:none;">
                                                                        <td colspan="3"><input type="text" style="width:187px;" name="product_name_outage#currentrow#" id="product_name_outage#currentrow#" value="#product_name#" readonly></td>
                                                                    </tr>
                                                                </table>
                                                                </div>
                                                                <cfset TREE_TYPE_ = TREE_TYPE>
                                                            </cfloop>
                                                        </cfif>
                                                    </cfif>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3">
                                                    <cfloop from="#fire_recordcount+1#" to="#fire_recordcount+10#" index="currentrow">
                                                        <div id="product_info_outage#currentrow#" style="display:none;">
                                                        <table cellpadding="1" cellspacing="0">
                                                            <input type="hidden" name="cost_id_outage#currentrow#" id="cost_id_outage#currentrow#" value="">
                                                            <cfif is_update eq 0>
                                                                <input type="hidden" name="product_cost_outage#currentrow#" id="product_cost_outage#currentrow#" value="#product_cost#"><!--- giydirilmiş maliyet --->
                                                                <input type="hidden" name="product_cost_money_outage#currentrow#" id="product_cost_money_outage#currentrow#" value="#product_cost_money#"><!--- giydirilmiş maliyet para birimi--->
                                                            </cfif>
                                                            <input type="hidden" name="kdv_amount_outage#currentrow#" id="kdv_amount_outage#currentrow#" value=""><!--- ürün kdv oranı //tax_purchase--->
                                                            <input type="hidden" name="cost_price_outage#currentrow#" id="cost_price_outage#currentrow#" value="">
                                                            <input type="hidden" name="cost_price_system_outage#currentrow#" id="cost_price_system_outage#currentrow#" value="">
                                                            <input type="hidden" name="purchase_extra_cost_system_outage#currentrow#" id="purchase_extra_cost_system_outage#currentrow#" value="">
                                                            <input type="hidden" name="purchase_extra_cost_outage#currentrow#" id="purchase_extra_cost_outage#currentrow#" value="">
                                                            <input type="hidden" name="money_system_outage#currentrow#" id="money_system_outage#currentrow#" value="">
                                                            <input type="hidden" name="money_outage#currentrow#" id="money_outage#currentrow#" value="">
            
                                                            <input type="hidden" value="1" name="row_kontrol_outage#currentrow#" id="row_kontrol_outage#currentrow#">
                                                            <input type="hidden" name="tree_type_outage_#currentrow#" id="tree_type_outage_#currentrow#" value="3">
                                                            <input type="hidden" name="stock_id_outage#currentrow#" id="stock_id_outage#currentrow#" value="">
                                                            <input type="hidden" name="stock_code_outage#currentrow#" id="stock_code_outage#currentrow#" value="">
                                                            <input type="hidden" name="product_id_outage#currentrow#" id="product_id_outage#currentrow#" value="">
                                                            <input type="hidden" name="unit_id_outage#currentrow#" id="unit_id_outage#currentrow#" value="">
                                                            <input type="hidden" name="unit_outage#currentrow#" id="unit_outage#currentrow#" value="">
                                                            <input type="hidden" name="serial_no_outage#currentrow#" id="serial_no_outaget#currentrow#" value="">
                                                            <input type="hidden" name="is_production_spect_outage#currentrow#" id="is_production_spect_outage#currentrow#" value="<cfif isdefined('IS_PRODUCTION') and IS_PRODUCTION eq 1>1<cfelse>0</cfif>"><!--- Üretilen bir ürün ise hidden alan 1 oluyor ve query sayfasında bu ürün için otomatik bir spect oluşuyor --->
                                                            
                                                            <input type="hidden" name="spec_main_id_outage#currentrow#" id="spec_main_id_outage#currentrow#" value="" readonly>
                                                            <input type="hidden" name="spect_id_outage#currentrow#" id="spect_id_outage#currentrow#" value="" readonly>
                                                            <input type="hidden" name="spect_name_outage#currentrow#" id="spect_name_outage#currentrow#" value="">
                                                            <tr>
                                                                <td style="width:27px;">
                                                                    <input type="text" name="amount_outage#currentrow#" id="amount_outage#currentrow#" style="width:25.5px;" value="0" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,3);aktar();" class="moneybox">
                                                                    <input type="hidden" name="amount_outage_#currentrow#" id="amount_outage_#currentrow#" value="0" onkeyup="return(FormatCurrency(this,event,#default_round#));" onblur="hesapla_deger(#currentrow#,3);aktar();" class="moneybox">
                                                                </td>
                                                                <td style="width:57px;"><input type="text" name="lot_no_outage#currentrow#" id="lot_no_outage#currentrow#" style="width:54px;" value="" onkeyup="FormatCurrency(this,2);" <cfif session.pda.use_onkeydown_enter>onkeydown<cfelse>onchange</cfif>="<cfif session.pda.Use_onKeyDown_Enter>if(event.keyCode == 13)</cfif> clear_barcode();"></td>
                                                                <td><input type="text" name="barcode_outage#currentrow#" id="barcode_outage#currentrow#" value="" style="width:90px;">
                                                                    <a href="javascript://" onclick="del_production_barcode(3,#currentrow#);"><img  src="images/delete_list.gif" align="absmiddle" border="0"></a>
                                                                    <a href="javascript://" onclick="gizle_goster('tr_product_name_outage#currentrow#');"><img  src="images/plus_ques.gif" align="absmiddle" border="0"></a>
                                                                </td>
                                                            </tr>
                                                            <tr id="tr_product_name_outage#currentrow#" style="display:none;">
                                                                <td colspan="3"><input type="text" style="width:187px;" name="product_name_outage#currentrow#" id="product_name_outage#currentrow#" value="" readonly></td>
                                                            </tr>
                                                        </table>
                                                        </div>
                                                    </cfloop>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </div>
                <tr>
                    <td colspan="2" align="center">
                        <cfif is_update eq 1>
                            <input type="hidden" name="is_newstock" id="is_newstock" value=""><!--- Stok Fisi Oluşturmak Icin --->
                            <input type="hidden" name="is_delstock" id="is_delstock" value=""><!--- Stok Fisi Silmek Icin --->
                            <input type="hidden" name="del_pr_order_id" id="del_pr_order_id" value="0"><!--- Uretim Sonucu Silmek Icin --->
                            <input type="button" value="Sil" onclick="control_inputs('del');">
                            <input type="button" value="Güncelle" onclick="control_inputs('upd');">
                            <cfif get_fis_control.recordcount>
                                <input type="button" value="Stok Fişlerini Sil" onclick="control_inputs('sf_del');">
                            <cfelse>
                                <input type="button" value="Stok Fişi Oluştur" onclick="control_inputs('sf_ins');">
                            </cfif>
                        <cfelse>
                            <input type="button" value="Kaydet" onclick="control_inputs();">
                        </cfif>
                    </td>
                </tr>
            </cfform>
            </table>
		</td>
	</tr>
</table>
</cfoutput>
<br/>
<script language="javascript">
	var default_round_ = '<cfoutput>#default_round#</cfoutput>';
	function control_inputs(val)
	{
		if(document.getElementById("start_date").value == "" || document.getElementById("finish_date").value == "")
		{
			alert("Lütfen Tarih Değerlerini Kontrol Ediniz!");
			return false;
		}
		
		if(val != "" && val == "sf_del")
			document.getElementById("is_delstock").value = 1;
			
		if(val != "" && val == "sf_ins")
			document.getElementById("is_newstock").value = 1;
		
		if(val != "" && val == "del")
			document.getElementById("del_pr_order_id").value = 1;
	
		
		//filterNum Kontrolleri
		var recordCount = document.getElementById("record_num").value;
		if(recordCount > 0)
		{
			for(var r=1; r<=recordCount; r++)
			{
				if(document.getElementById("amount"+r) != undefined)
					document.getElementById("amount"+r).value = filterNum(document.getElementById("amount"+r).value,default_round_);
				if(document.getElementById("amount_"+r) != undefined)
					document.getElementById("amount_"+r).value = filterNum(document.getElementById("amount_"+r).value,default_round_);
				if(document.getElementById("fire_amount_"+r) != undefined)
					document.getElementById("fire_amount_"+r).value = filterNum(document.getElementById("fire_amount_"+r).value,default_round_);
			}
		}

		var cnt_ = 0;
		var product_exists = 0;
		var yy = parseInt(document.getElementById('record_num').value);
		for(var i=1; i<=yy; i++)
		{
			if(eval('document.getElementById("row_kontrol'+i+'")').value == 1)
			{
				cnt_ ++;
				product_exists = product_exists + 1;
				if(eval("document.getElementById('amount"+i+"')") != undefined && parseFloat(filterNum(eval("document.getElementById('amount"+i+"')").value,4)) <= 0)
				{
					alert(cnt_ + ". Satırda Girilen Miktar 0 Dan Farklı Olmalıdır!");
					return false;
				}
			}
		}	
			
		var recordCount_exit = document.getElementById("record_num_exit").value;
		if(recordCount_exit > 0)
		{
			for(var r=1; r<=recordCount_exit; r++)
			{
				if(document.getElementById("amount_exit"+r) != undefined)
					document.getElementById("amount_exit"+r).value = filterNum(document.getElementById("amount_exit"+r).value,default_round_);
				if(document.getElementById("amount_exit_"+r) != undefined)
					document.getElementById("amount_exit_"+r).value = filterNum(document.getElementById("amount_exit_"+r).value,default_round_);
			}
		}
		var recordCount_outage = document.getElementById("record_num_outage").value;
		if(recordCount_outage > 0)
		{
			for(var r=1; r<=recordCount_outage; r++)
			{
				if(document.getElementById("amount_outage"+r) != undefined)
					document.getElementById("amount_outage"+r).value = filterNum(document.getElementById("amount_outage"+r).value,default_round_);
				if(document.getElementById("amount_outage_"+r) != undefined)
					document.getElementById("amount_outage_"+r).value = filterNum(document.getElementById("amount_outage_"+r).value,default_round_);
			}
		}
		
		document.add_production_result.submit();
	}
	
	function add_production_barcode(type,barcode)
	{
		//type = 1: Urun, 2: Sarf, 3:Fire
		if(type == 3) var add = "_outage";
		else if(type == 2) var add = "_exit";
		else var add = "";
		
		barcode_found = 0;
		var recordCount = document.getElementById("record_num"+add).value;
		if(recordCount > 0)
		{
			for(var i=1; i<=recordCount; i++)
			{	
				if(document.getElementById("row_kontrol"+add+i).value == 1)
				{	
					if(barcode == document.getElementById("barcode"+add+i).value)
					{
						document.getElementById("lot_no"+add+i).value = document.getElementById("search_lot_no"+add).value;
						if(document.getElementById("search_amount"+add) != undefined)
							document.getElementById("amount"+add+i).value = document.getElementById("search_amount"+add).value;
						
						barcode_found = 1;
						break;
					}
				}
			}
		}
		if(type == 3)
		{
			if(barcode_found == 0)
			{
				var i = parseInt(recordCount)+1;
				var GET_BARCODE = wrk_query("SELECT DISTINCT BARCODE FROM STOCKS_BARCODES WHERE STOCK_ID = (SELECT DISTINCT SB.STOCK_ID FROM STOCKS AS S,PRODUCT_UNIT AS PU,STOCKS_BARCODES SB WHERE SB.STOCK_ID = S.STOCK_ID AND S.PRODUCT_STATUS = 1 AND S.STOCK_STATUS = 1 AND S.PRODUCT_ID = PU.PRODUCT_ID AND SB.BARCODE = '" + barcode + "')","dsn3");
				if(GET_BARCODE.recordcount > 0)
				{
					document.getElementById("row_kontrol"+add+i).value = 1;
					document.getElementById("barcode"+add+i).value = barcode;
					document.getElementById("lot_no"+add+i).value = document.getElementById("search_lot_no_outage").value;
					document.getElementById("amount"+add+i).value = document.getElementById("search_amount_outage").value;
					
					var get_product_name = wrk_query("SELECT TOP 1 S.PRODUCT_NAME,S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_ID,SB.UNIT_ID,PU.MAIN_UNIT FROM STOCKS S, STOCKS_BARCODES SB,PRODUCT_UNIT PU WHERE S.STOCK_ID = SB.STOCK_ID AND PU.PRODUCT_UNIT_ID = SB.UNIT_ID AND SB.BARCODE ='"+barcode+"'","dsn3",1);
					if(get_product_name.recordcount > 0)
					{
						document.getElementById("product_name"+add+i).value = get_product_name.PRODUCT_NAME;
						document.getElementById("product_id"+add+i).value = get_product_name.PRODUCT_ID;
						document.getElementById("stock_id"+add+i).value = get_product_name.STOCK_ID;
						document.getElementById("stock_code"+add+i).value = get_product_name.STOCK_CODE;
						document.getElementById("unit_id"+add+i).value = get_product_name.UNIT_ID;
						document.getElementById("unit"+add+i).value = get_product_name.MAIN_UNIT;	
					}
				}
				else
				{
					alert("Barkod Bulunamadı !");
					document.getElementById('search_barcode'+add).focus();
					//clear_barcode();
					return false;
				}
				goster(document.getElementById("product_info_outage"+i));
				document.getElementById("record_num"+add).value = parseInt(document.getElementById("record_num"+add).value) + 1;
			}
		}
		document.getElementById('search_barcode'+add).select();
	}
	
	function del_production_barcode(type,currentrow)
	{
		if(type == 3) var add = "_outage";
		else if(type == 2) var add = "_exit";
		else var add = "";
		document.getElementById('product_info'+add+currentrow).style.display = 'none';
		document.getElementById('row_kontrol'+add+currentrow).value = 0;
	}
	
	function hesapla_deger(currentrow,type)
	{
		if(type == 3) var add = "_outage";
		else if(type == 2) var add = "_exit";
		else var add = "";
		
		if(type == 0)
		if((document.getElementById("fire_amount_"+currentrow).value == "") || (document.getElementById("fire_amount_"+currentrow).value == 0))
			document.getElementById("fire_amount_"+currentrow).value = 0;
		else
			if((document.getElementById("amount"+add+currentrow).value == "") || (document.getElementById("amount"+add+currentrow).value == 0))
				document.getElementById("amount"+add+currentrow).value = 0;
	}
	
	function aktar()
	{
		var sarf_uzunluk=document.getElementById("record_num_exit").value;
		<cfif x_por_amount_lte_po eq 0>//<!--- XML ayarlarında üretim sonuçlarının toplamı üretim emrinin miktarından fazla olamaz denildi ise.... --->
			<cfif Get_Production_Orders.Is_Demontaj eq 0>
				if(filterNum(document.getElementById("amount"+1).value,default_round_) > filterNum(document.getElementById("amount_"+1).value,default_round_))
					{
						alert('Girilen Miktar Oranı Üretim Emrinden Fazla Olamaz.');
						eval("form_basket.amount"+1).value=eval("form_basket.amount_"+1).value;
					}
				if(filterNum(document.getElementById("amount_"+1).value,default_round_)<1)		
					{
						alert('Bu Üretim Emrinde Kota Doldulmuştur,Üretim yapmak için yeni bir Üretim Emri Ekleyiniz.');
						document.getElementById("amount"+1).value=0;
						return false;
					}
				if(filterNum(document.getElementById("amount"+1).value,default_round_)<1)		
				{
					alert('Üretim Oranı Hatalı Lütfen Doğru Bir Değer Giriniz.!!');
					document.getElementById("amount"+1).value=document.getElementById("amount_"+1).value;
					return false;
				}
			</cfif>	
			<cfif Get_Production_Orders.Is_Demontaj eq 1>
				if(filterNum(document.getElementById("amount_exit"+1).value,default_round_)>filterNum(document.getElementById("amount_exit_"+1).value,default_round_))
					{
						alert('Girilen Miktar Oranı Üretim Emrinden Fazla Olamaz.');
						eval("form_basket.amount_exit"+1).value=eval("form_basket.amount_exit_"+1).value;
					}
					if(filterNum(document.getElementById("amount_exit_"+1).value,default_round_)==0)
					{
						alert('Bu Üretim Emrinde Kota Doldulmuştur,Üretim yapmak için yeni bir Üretim Emri Ekleyiniz.');
						eval("form_basket.amount_exit"+1).value=0;
						return false;	
					}
					if(filterNum(document.getElementById("amount_exit"+1).value,default_round_)==0)
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
					if(document.getElementById("is_free_amount"+i).value == 0)
					{
						<cfif Get_Production_Orders.Is_Demontaj eq 0 and isdefined('GET_SUM_AMOUNT')>
							var x=parseInt(document.getElementById("amount"+1).value);
							if(x>0)//Eğer Üretilecek olan ana ürün miktarı 1den büyükse.
								{
									//alert(filterNum(document.getElementById("amount_exit_"+i).value,default_round_)+"/"+filterNum(document.getElementById("amount_"+1).value,default_round_)+"*"+filterNum(document.getElementById("amount"+1).value,default_round_)+"+"+filterNum(document.getElementById("fire_amount_"+1).value,default_round_));
									<cfif x_is_fire_product eq 1>
										var a=document.getElementById("amount_exit"+i).value=(parseFloat(filterNum(document.getElementById("amount_exit_"+i).value,default_round_))/parseFloat(filterNum(document.getElementById("amount_"+1).value,default_round_)))*(parseFloat(filterNum(document.getElementById("amount"+1).value,default_round_))+parseFloat(filterNum(document.getElementById("fire_amount_"+1).value,default_round_)));
									<cfelse>
										var a=document.getElementById("amount_exit"+i).value=(filterNum(document.getElementById("amount_exit_"+i).value,default_round_))/(filterNum(document.getElementById("amount_"+1).value,default_round_))*(filterNum(document.getElementById("amount"+1).value,default_round_));
									</cfif>
									var b=commaSplit(a,default_round_);
									document.getElementById("amount_exit"+i).value=b;
								}
						<cfelseif Get_Production_Orders.Is_Demontaj eq 0 and not isdefined('GET_SUM_AMOUNT')>
							var x=parseInt(document.getElementById("amount"+1).value);
							if(x>0)//Eğer Üretilecek olan ana ürün miktarı 1den büyükse.
								{
									<cfif x_is_fire_product eq 1>
										var a=document.getElementById("amount_exit"+i).value=(parseFloat(filterNum(document.getElementById("amount_exit_"+i).value,default_round_))/parseFloat(filterNum(document.getElementById("amount_"+1).value,default_round_)))*(parseFloat(filterNum(document.getElementById("amount"+1).value,default_round_))+parseFloat(filterNum(document.getElementById("fire_amount_"+1).value,default_round_)));
									<cfelse>
										var a=document.getElementById("amount_exit"+i).value=(filterNum(document.getElementById("amount_exit_"+i).value,default_round_))/(filterNum(document.getElementById("amount_"+1).value,default_round_))*(filterNum(document.getElementById("amount"+1).value,default_round_));
									</cfif>
									var b=commaSplit(a,default_round_);
									document.getElementById("amount_exit"+i).value=b;
									
								}	
						</cfif>
					}
					<cfif Get_Production_Orders.Is_Demontaj eq 1 and isdefined('GET_SUM_AMOUNT')>
					var x=parseInt(document.getElementById("amount_exit"+1).value);
					if(x>0)//Demontaj yapılacak ürün miktarı 1 den fazla ise
						{	var a=document.getElementById("amount"+i).value=(filterNum(document.getElementById("amount_"+i).value,default_round_)/parseFloat(<cfoutput>#sarf_kalan_uretim_emri#</cfoutput>))*filterNum(document.getElementById("amount_exit"+1).value,default_round_);
							var b=commaSplit(a,default_round_);
							document.getElementById("amount"+i).value=b;
						}	
					<cfelseif Get_Production_Orders.Is_Demontaj eq 1 and not isdefined('GET_SUM_AMOUNT')>
					var x=parseInt(document.getElementById("amount_exit"+1).value);
					if(x>0)//Demontaj yapılacak ürün miktarı 1 den fazla ise
						{
							var a=document.getElementById("amount"+i).value=(filterNum(document.getElementById("amount_"+i).value,default_round_)/parseFloat(<cfoutput>#Get_Production_Orders.AMOUNT#</cfoutput>))*filterNum(document.getElementById("amount_exit"+1).value,default_round_);
							var b=commaSplit(a,default_round_);
							document.getElementById("amount"+i).value=b;
						}
					</cfif>
				}
		}		
	}
</script>
<cfinclude template="basket_js_functions.cfm">
