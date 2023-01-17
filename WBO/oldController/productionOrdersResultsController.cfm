<cf_get_lang_set module_name="prod">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
   <cfsetting showdebugoutput="yes">
    <cfparam name="attributes.is_submitted" default="">    
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.lotno" default="">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.page" default='1'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfparam name="attributes.totalrecords" default="0">    
    <cfparam name="attributes.station_id" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.product_id" default="">
    <cfparam name="attributes.product_name" default="">
    <cfparam name="attributes.product_catid" default="">
    <cfparam name="attributes.product_cat" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfparam name="attributes.hierarchy" default="">
    <cfparam name="attributes.position_code" default="">
    <cfparam name="attributes.position_name" default="">
    <cfparam name="attributes.stock_fis_status" default="">
    <cfparam name="attributes.station_list" default="0">
    <cfquery name="GET_W" datasource="#dsn#">
        SELECT 
            CASE WHEN UP_STATION IS NULL THEN
                STATION_ID 
            ELSE
                UP_STATION 
            END AS UPSTATION_ID,
            STATION_ID,
            STATION_NAME,
            UP_STATION,
            CASE WHEN (SELECT TOP 1 WS1.UP_STATION FROM #dsn3_alias#.WORKSTATIONS WS1 WHERE WS1.UP_STATION = WORKSTATIONS.STATION_ID) IS NOT NULL THEN 0 ELSE 1 END AS TYPE
        FROM 
            #dsn3_alias#.WORKSTATIONS
        WHERE 
            ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
            DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
        ORDER BY 
            UPSTATION_ID, 
            TYPE
    </cfquery>
    <cfif GET_W.recordcount><cfset authority_station_id_list = ValueList(GET_W.STATION_ID,',')><cfelse><cfset authority_station_id_list = 0></cfif>
    <cfif len(attributes.station_id)>
        <cfquery name="get_station_list" datasource="#dsn3#">
            SELECT STATION_ID FROM WORKSTATIONS WHERE UP_STATION = #attributes.station_id#
        </cfquery>
        <cfif get_station_list.recordcount><cfset station_list = ValueList(get_station_list.STATION_ID)><cfelse><cfset station_list = 0></cfif>
    </cfif>
    <cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
        <cf_date tarih='attributes.start_date'>
    <cfelse>
        <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
            <cfset attributes.start_date=''>
        <cfelse>
            <cfset attributes.start_date=wrk_get_today() >
        </cfif>
    </cfif>	
    <cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
        <cf_date tarih='attributes.finish_date'>
    <cfelse>
        <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
            <cfset attributes.finish_date=''>
        <cfelse>
        <cfset attributes.finish_date = date_add('d',1,now())>
        </cfif>
    </cfif>
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.location_id" default="">
    <cfparam name="attributes.department" default="">
    <cfif len(attributes.is_submitted)>
        <cfscript>
            get_prod_order_result_action = createObject("component", "production.cfc.get_production_order_result");
            get_prod_order_result_action.dsn = dsn;
            get_prod_order_result_action.dsn3 = dsn3;
            get_prod_order_result_action.dsn_alias = dsn_alias;
            get_prod_order_result_action.dsn1_alias = dsn1_alias;
            get_po_det = get_prod_order_result_action.get_po_det_fnc(
                authority_station_id_list : '#IIf(IsDefined("authority_station_id_list"),"authority_station_id_list",DE(""))#',
                keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
                lotno : '#IIf(IsDefined("attributes.lotno"),"attributes.lotno",DE(""))#',
                maxrows : '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
                startrow : '#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
                spect_main_id : '#IIf(IsDefined("attributes.spect_main_id"),"attributes.spect_main_id",DE(""))#',
                spect_name : '#IIf(IsDefined("attributes.spect_name"),"attributes.spect_name",DE(""))#',
                process : '#IIf(IsDefined("attributes.process"),"attributes.process",DE(""))#',
                position_code : '#IIf(IsDefined("attributes.position_code"),"attributes.position_code",DE(""))#',
                position_name : '#IIf(IsDefined("attributes.position_name"),"attributes.position_name",DE(""))#',
                station_id : '#IIf(IsDefined("attributes.station_id"),"attributes.station_id",DE(""))#',
                department : '#IIf(IsDefined("attributes.department"),"attributes.department",DE(""))#',
                department_id : '#IIf(IsDefined("attributes.department_id"),"attributes.department_id",DE(""))#',
                location_id : '#IIf(IsDefined("attributes.location_id"),"attributes.location_id",DE(""))#',
                product_cat : '#IIf(IsDefined("attributes.product_cat"),"attributes.product_cat",DE(""))#',
                hierarchy : '#IIf(IsDefined("attributes.hierarchy"),"attributes.hierarchy",DE(""))#',
                project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
                project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
                product_id : '#IIf(IsDefined("attributes.product_id"),"attributes.product_id",DE(""))#',
                product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
                start_date_result : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
                finish_date_result : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
                stock_fis_status : '#IIf(IsDefined("attributes.stock_fis_status"),"attributes.stock_fis_status",DE(""))#',
                station_list : '#IIf(IsDefined("station_list"),"station_list",DE(""))#'
            );
        </cfscript>
    
    	<cfif get_po_det.recordcount>
            <cfset attributes.totalrecords = get_po_det.query_count>
        <cfelse>
            <cfset attributes.totalrecords = 0>
        </cfif>        
    </cfif>
    
    <cfoutput>
    #wrkUrlStrings('url_str','is_submitted','stock_fis_status','keyword','station_id','location_id','department','product_id','product_name','product_catid','product_cat','hierarchy','start_date','finish_date','position_code','position_name','project_id','project_head')#
</cfoutput>
    <cfquery name="get_process" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%prod.add_prod_order_result%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    <cfif len(attributes.is_submitted)>
		<cfif get_po_det.recordcount>
        	<cfset production_order_value_list = ''>
			<cfset station_id_list = ''>
            <cfoutput query="get_po_det" >
                <cfset production_order_value_list = listappend(production_order_value_list,p_order_id,',')>
                <cfif len(station_id) and not listfind(station_id_list,station_id)>
                    <cfset station_id_list=listappend(station_id_list,station_id)>
                </cfif>	
            </cfoutput>
            <cfif len(station_id_list)>
                <cfset station_id_list=listsort(station_id_list,"numeric","ASC",",")>
                <cfquery name="get_station" datasource="#DSN3#">
                    SELECT
                        W.STATION_NAME,
                        W.STATION_ID
                    FROM 
                        WORKSTATIONS W
                    WHERE
                        W.STATION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#station_id_list#" list="yes">)
                    ORDER BY
                        W.STATION_ID
                </cfquery>
                <cfset station_id_list = listsort(listdeleteduplicates(valuelist(get_station.STATION_ID,',')),'numeric','ASC',',')>
            </cfif>
        </cfif>
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>	
    <div id="prod_stock_and_spec_detail_div" align="center" style="position:absolute;width:300px; height:150; overflow:auto;z-index:1;"></div>
    <style type="text/css">
        .detail_basket_list tbody tr.operasyon td {background-color:#FFCCCC !important;}
        .detail_basket_list tbody tr.phantom td {background-color:#FFCC99 !important;}
    </style>
    <cfinclude template="../workdata/get_main_spect_id.cfm">
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
            0 AS IS_MANUAL_COST
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
        SELECT 0 AS TYPE_PRODUCT,0 AS IS_DEMONTAJ,'' LOT_NO,'' DETAIL,0 STATION_ID,0 SPEC_MAIN_ID,0 SPECT_VAR_ID,'' REFERANS,'' P_ORDER_NO,0 PROJECT_ID,0 ORDER_ID,0 IS_PROTOTYPE,* FROM GET_SUB_PRODUCTS WHERE IS_FREE_AMOUNT = 1
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
    <cfoutput>
		<cfif len(get_det_po.start_date)>
            <cfset value_start_h = hour(get_det_po.start_date)>
            <cfset value_start_m = minute(get_det_po.start_date)>
        <cfelse>
            <cfset value_start_h = 0>
            <cfset value_start_m = 0>
        </cfif>
        <cfif len(get_det_po.finish_date)>
			<cfset value_finish_h = hour(get_det_po.finish_date)>
            <cfset value_finish_m = minute(get_det_po.finish_date)>
        <cfelse>
            <cfset value_finish_h = 0>
            <cfset value_finish_m = 0>
        </cfif>
   </cfoutput>
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
  </cfif>
    <cfif get_det_po.is_demontaj eq 1><!--- TolgaS 20060912 demontaj isleminde depo seceneleri ters olmali --->
		<cfset location_type =3>
    <cfelse>
        <cfset location_type =1>			
    </cfif>	
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
    </cfif>
    <cfif get_det_po.is_demontaj eq 1><!--- TolgaS 20060912 demontaj isleminde depo seceneleri ters olmali --->
		<cfset location_type =1>
    <cfelse>
        <cfset location_type =3>			
    </cfif>	
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
    </cfif>
    <cfquery name="get_prod_operation" datasource="#dsn3#">
            SELECT TOP 1 P_ORDER_ID FROM PRODUCTION_ORDER_OPERATIONS WHERE P_ORDER_ID = #attributes.p_order_id#
    </cfquery>	
    <cfset demontaj_cost_price_system = 0>
	<cfset demontaj_purchase_extra_cost_system = 0>
    <cfset demontaj_cost_price_system_2 = 0>
    <cfif get_det_po.is_demontaj eq 1>
        <cfset sonuc_query = 'GET_SUB_PRODUCTS'>
    <cfelse>
        <cfset sonuc_query = 'get_det_po'>
    </cfif>
    <cfset sonuc_recordcount = evaluate('#sonuc_query#.recordcount')>
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
                ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,
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
     </cfoutput>
    <cfif get_det_po.is_demontaj eq 1>
        <cfset sarf_query='get_det_po'>
    <cfelse>
        <cfset sarf_query='GET_SUB_PRODUCTS'>
    </cfif>
    <cfset deger_value_row = evaluate('#sarf_query#.recordcount')>
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
                    ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,
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
    </cfoutput>
    <cfif get_det_po.is_demontaj eq 1>
        <cfset sarf_query='get_det_po'>
    <cfelse>
        <cfset sarf_query='GET_SUB_PRODUCTS_FIRE'>
    </cfif>
    <cfif isdefined('#sarf_query#.recordcount')>
        <cfset deger_value_row_fire = evaluate('#sarf_query#.recordcount')>
    </cfif>	
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
                        ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,
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
            </cfoutput>
   		</cfif>
    </cfif>       		
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cf_xml_page_edit fuseact="prod.upd_prod_order_result">
    <cfif is_show_product_name2 eq 1><cfset product_name2_display =""><cfelse><cfset product_name2_display='none'></cfif>
    <cfif is_show_spec_id eq 1><cfset spec_display = 'text'><cfelse><cfset spec_display = 'hidden'></cfif>
    <cfif is_show_spec_name eq 1><cfset spec_name_display = 'text'><cfelse><cfset spec_name_display = 'hidden'></cfif>
    <cfif is_show_spec_id eq 0 and isdefined('is_show_spec_name') and is_show_spec_name eq 0><cfset spec_img_display="none"><cfelse><cfset spec_img_display=""></cfif>
    <cfif is_change_amount_demontaj eq 1><cfset _readonly_ =''><cfelse><cfset _readonly_ = 'readonly'></cfif>
    <cfset variable_ = '0'>
    <cfset variable = '1'>
    <cfset variable2 = '2'> 
    <cfset variable3 = '3'>
    <cfif not isnumeric(attributes.p_order_id) or not isnumeric(attributes.pr_order_id)>
        <cfset hata  = 10>
        <cfinclude template="../dsp_hata.cfm">
        <cfabort>
    </cfif>
    <cfquery name="GET_DETAIL" datasource="#DSN3#">
        SELECT 
            PRODUCTION_ORDERS.REFERENCE_NO REFERANS,
            PRODUCTION_ORDERS.PROJECT_ID,
            PRODUCTION_ORDERS.P_ORDER_NO,
            PRODUCTION_ORDERS.ORDER_ID,
            PRODUCTION_ORDERS.IS_DEMONTAJ,
            PRODUCTION_ORDERS.QUANTITY AS AMOUNT,
            PRODUCTION_ORDER_RESULTS.*
        FROM
            PRODUCTION_ORDERS,
            PRODUCTION_ORDER_RESULTS
        WHERE
            PRODUCTION_ORDERS.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">  AND 
            PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND
            PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDER_RESULTS.P_ORDER_ID
    </cfquery>
    <cfset dep_id_list =''>
    <cfset loc_id_list =''>
    <cfif len(GET_DETAIL.exit_dep_id)>
        <cfset dep_id_list = ListAppend(dep_id_list,GET_DETAIL.exit_dep_id,',')>
        <cfset loc_id_list = ListAppend(loc_id_list,GET_DETAIL.exit_loc_id,',')>
    </cfif>
    <cfif len(GET_DETAIL.production_dep_id)>
        <cfset dep_id_list = ListAppend(dep_id_list,GET_DETAIL.production_dep_id,',')>
        <cfset loc_id_list = ListAppend(loc_id_list,GET_DETAIL.production_loc_id,',')>
    </cfif>
    <cfif len(GET_DETAIL.enter_dep_id)>
        <cfset dep_id_list = ListAppend(dep_id_list,GET_DETAIL.enter_dep_id,',')>
        <cfset loc_id_list = ListAppend(loc_id_list,GET_DETAIL.enter_loc_id,',')>
    </cfif>
    <cfif len(dep_id_list)>
        <cfquery name="GET_DEP" datasource="#DSN#">
            SELECT
                DEPARTMENT_HEAD,
                DEPARTMENT_ID,
                BRANCH_ID
            FROM
                DEPARTMENT
            WHERE
                DEPARTMENT_ID IN (#dep_id_list#)
        </cfquery>
        <cfif len(loc_id_list)> 
            <cfquery name="GET_LOC" datasource="#DSN#">
                SELECT
                    COMMENT,
                    LOCATION_ID,
                    DEPARTMENT_ID
                FROM
                    STOCKS_LOCATION
                WHERE
                    LOCATION_ID IN (#loc_id_list#) AND
                    DEPARTMENT_ID IN (#dep_id_list#)
            </cfquery>
    </cfif>
    <cfset production_branch_id = ''>
    <cfset exit_dep_name = ''>
    <cfset production_dep_name = ''>
    <cfset enter_dep_name = ''>
    <cfset exit_loc_comment = ''>
    <cfset production_loc_comment = ''>
    <cfset enter_loc_comment = ''>
    <cfloop query="GET_DEP">
        <cfif GET_DETAIL.exit_dep_id eq DEPARTMENT_ID>
            <cfset exit_dep_name = DEPARTMENT_HEAD>
        </cfif>
        <cfif GET_DETAIL.production_dep_id eq DEPARTMENT_ID>
            <cfset production_dep_name = DEPARTMENT_HEAD>
            <cfset production_branch_id = BRANCH_ID>
        </cfif>
        <cfif GET_DETAIL.enter_dep_id eq DEPARTMENT_ID>
            <cfset enter_dep_name = DEPARTMENT_HEAD>
        </cfif>
    </cfloop>
    <cfloop query="GET_LOC">
        <cfif GET_DETAIL.exit_loc_id eq LOCATION_ID and GET_DETAIL.exit_dep_id eq DEPARTMENT_ID>
            <cfset exit_loc_comment = COMMENT>
        </cfif>
        <cfif GET_DETAIL.production_loc_id eq LOCATION_ID and GET_DETAIL.production_dep_id eq DEPARTMENT_ID>
            <cfset production_loc_comment =  COMMENT>
        </cfif>
        <cfif GET_DETAIL.enter_loc_id eq LOCATION_ID and GET_DETAIL.enter_dep_id eq DEPARTMENT_ID>
            <cfset enter_loc_comment = COMMENT>
        </cfif>
    </cfloop>
    </cfif>
    <cfif GET_DETAIL.recordcount>
    <!--- Bu blok,üretim emri birden fazla sipariş ile ilişkili ise,yapılacak spec değişikliklerinde 
    ilgili siparişlerin de spect_var_id'leri güncellenerek ilişkinin kopmamış olması sağlanıyor--->
        <cfquery name="get_orders_all" datasource="#dsn3#">
            SELECT ORDER_ROW_ID FROM PRODUCTION_ORDERS_ROW POR_ WHERE POR_.PRODUCTION_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
        </cfquery>
    </cfif>
    <cfif not GET_DETAIL.RECORDCOUNT>
        <cfset hata  = 10 >
        <cfinclude template="../dsp_hata.cfm">
        <cfabort>
    </cfif>
    <cfquery name="get_money" datasource="#dsn#">
        SELECT MONEY,RATE1,RATE2 FROM MONEY_HISTORY WHERE MONEY_HISTORY_ID IN(SELECT MAX(MONEY_HISTORY_ID) FROM MONEY_HISTORY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND VALIDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_detail.finish_date)#"> GROUP BY MONEY)
    </cfquery>
    <cfif get_money.recordcount eq 0>
        <cfquery name="get_money" datasource="#dsn2#">
            SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY
        </cfquery>
    </cfif>
    <cfquery name="get_money_rate" datasource="#dsn#">
        SELECT MONEY,RATE1,RATE2 FROM MONEY_HISTORY WHERE MONEY_HISTORY_ID IN(SELECT MAX(MONEY_HISTORY_ID) FROM MONEY_HISTORY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND VALIDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_detail.finish_date)#"> GROUP BY MONEY)
    </cfquery>
    <cfif get_money_rate.recordcount eq 0>
        <cfquery name="get_money_rate" datasource="#dsn2#">
            SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
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
    <cfif GET_ROW_AMOUNT.RECORDCOUNT>
        <cfquery name="GET_SUM_AMOUNT" datasource="#DSN3#">
            SELECT 
                SUM(AMOUNT) AS SUM_AMOUNT
            FROM 
                PRODUCTION_ORDER_RESULTS_ROW
            WHERE 
                PR_ORDER_ID IN
                (
                SELECT 
                    PR_ORDER_ID
                FROM 
                    PRODUCTION_ORDER_RESULTS
                WHERE 
                    P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
                    )
                <cfif GET_DETAIL.IS_DEMONTAJ EQ 0> AND TYPE=<cfqueryparam cfsqltype="cf_sql_integer" value="#variable#"><cfelse>AND TYPE=<cfqueryparam cfsqltype="cf_sql_integer" value="#variable2#"></cfif>
        </cfquery>
    </cfif>
    <!---<cfset new_dsn2 = '#dsn#_#year(GET_DETAIL.FINISH_DATE)#_#session.ep.company_id#'>
    ---><cfset new_dsn2 = dsn2>
    <cfquery name="GET_ROW_ENTER" datasource="#DSN3#">
        SELECT * FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable#">  ORDER BY PR_ORDER_ROW_ID
    </cfquery>
    <cfquery name="GET_ROW_EXIT" datasource="#DSN3#">
        SELECT * FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable2#"> ORDER BY PR_ORDER_ROW_ID
    </cfquery>
    <cfquery name="GET_ROW_OUTAGE" datasource="#DSN3#">
        SELECT * FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable3#">  ORDER BY PR_ORDER_ROW_ID
    </cfquery>
    <cfquery name="GET_STOK_FIS" datasource="#new_dsn2#">
        SELECT SHIP_NUMBER,SHIP_ID,SHIP_TYPE FROM SHIP WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#">
    </cfquery>
    <cfif len(get_detail.order_id)>
        <cfquery name="GET_ORDER_NUMBER" datasource="#DSN3#">
            SELECT ORDER_NUMBER FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.order_id#">
        </cfquery>
    </cfif>
    <cfset var119 = '119'>
    <cfset var110 = '110'>
    <cfset var111 = '111'>
    <cfset var112 = '112'>
    <cfset var113 = '113'>
    <cfset GET_CAT.recordcount = 0>
    <cfset GET_FIS.recordcount = 0>
    <cfset GET_FIS_SARF.recordcount = 0>
    <cfset GET_FIS_AMBAR.recordcount = 0>
    <cfset GET_FIS_FIRE.recordcount = 0>
    <cfset GET_FIS2.recordcount = 0>
    <cfquery name="GET_CAT" datasource="#DSN3#">
        SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE =<cfif GET_DETAIL.IS_DEMONTAJ eq 1><cfqueryparam cfsqltype="cf_sql_integer" value="#var119#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#var110#"></cfif><!--- uretimden giris fisi demontej veya uretimden giris fisi --->
    </cfquery>
    <cfif GET_CAT.recordcount>
        <cfquery name="GET_FIS" datasource="#new_dsn2#">
            SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND FIS_TYPE = 110
        </cfquery>
        <cfquery name="GET_FIS2" datasource="#new_dsn2#">
            SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND FIS_TYPE = 119
        </cfquery>
    </cfif>
    <cfquery name="GET_CAT_SARF" datasource="#DSN3#">
        SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#var111#">
    </cfquery>
    <cfif GET_CAT_SARF.recordcount>
        <cfquery name="GET_FIS_SARF" datasource="#new_dsn2#">
            SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND FIS_TYPE = 111
        </cfquery>
    </cfif>
    <cfquery name="GET_CAT_AMBAR" datasource="#DSN3#">
        SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#var113#">
    </cfquery>
    <cfif GET_CAT_AMBAR.recordcount>
        <cfquery name="GET_FIS_AMBAR" datasource="#new_dsn2#">
            SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND FIS_TYPE = 113
        </cfquery>
    </cfif>
    <cfquery name="GET_CAT_FIRE" datasource="#DSN3#">
        SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#var112#">
    </cfquery>
    <cfif GET_CAT_FIRE.recordcount>
        <cfquery name="GET_FIS_FIRE" datasource="#new_dsn2#">
            SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND FIS_TYPE = 112
        </cfquery>
    </cfif>
    <cfset Product_id_List = ''>
    <cfset Product_cat_List = ''>
    <cfif get_row_enter.recordcount>
        <cfoutput query="GET_ROW_ENTER">
            <cfif isdefined('product_id') and len(product_id) and not listfind(Product_id_List,product_id)>
                <cfset Product_id_List=listappend(Product_id_List,product_id)>
            </cfif>
        </cfoutput>
        <cfif len(Product_id_List)>
            <cfset Product_id_List=listsort(Product_id_List,"numeric","ASC",",")>
            <cfquery name="get_product_cat" datasource="#dsn1#">
                SELECT PRODUCT_CATID,PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID IN (#Product_id_List#) ORDER BY PRODUCT_ID
            </cfquery>
            <cfset Product_id_List = listsort(listdeleteduplicates(valuelist(get_product_cat.PRODUCT_ID,',')),'numeric','ASC',',')>
            <cfset Product_cat_List = listsort(listdeleteduplicates(valuelist(get_product_cat.PRODUCT_CATID,',')),'numeric','ASC',',')>
        </cfif>
    </cfif>
    <cfif isdefined("get_detail.production_dep_id") and len(get_detail.production_dep_id)>
        <cfquery name="GET_PRODUCTION_DEP" datasource="#DSN#">
            SELECT
                DEPARTMENT_HEAD,
                BRANCH_ID
            FROM 
                DEPARTMENT
            WHERE
                DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.production_dep_id#">
        </cfquery>
        <cfquery name="GET_PRODUCTION_LOC" datasource="#DSN#">
            SELECT
                COMMENT
            FROM
                STOCKS_LOCATION
            WHERE
                LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.production_loc_id#"> AND
                DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.production_dep_id#">
        </cfquery>	
	</cfif>
</cfif>  

<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<script type="text/javascript">
		function kontrol()
			{
				if(!date_check (document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Önce Olamaz'>!"))
					return false;
				else
					return true;	
			}
		function product_control(){/*Ürün seçmeden spec seçemesin.*/
			if(document.getElementById('product_id').value=="" || document.getElementById('product_name').value == "" ){
				alert("Spect Seçmek için öncelikle ürün seçmeniz gerekmektedir");
				return false;
			}
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=list_prod_order.spect_main_id&field_name=list_prod_order.spect_name&is_display=1&product_id='+document.getElementById('product_id').value,'list');
		}		
    </script>
<cfelseif isdefined("attributes.event") and  attributes.event is 'add'>
	<script type="text/javascript">
		$( document ).ready(function() {
            row_count = <cfoutput>#sonuc_recordcount#</cfoutput>;
            row_count_exit = <cfoutput>#deger_value_row#</cfoutput>;
            round_number = <cfoutput>#round_number#</cfoutput>;//xmlden geliyor. miktar kusuratlarini burdan aliyor
            <cfif get_det_po.is_demontaj eq 1>//demontaj ise ve spectli üründen fire geliyorsa 0 olarak kabul et,fire'ye demontaj yapılmaz.
                row_count_outage = 0;
            <cfelse>
                row_count_outage = <cfif isdefined('deger_value_row_fire')><cfoutput>#deger_value_row_fire#</cfoutput><cfelse>0</cfif>;
            </cfif>
		});			
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
                    document.getElementById("total_cost_price_exit"+row_no).value = commaSplit(total_cost,round_number);
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
                    document.getElementById("total_cost_price_outage"+row_no).value = commaSplit(total_cost,round_number);
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
                            document.getElementById("total_cost_price_exit"+row_no).value = commaSplit(total_cost,round_number);
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
                            document.getElementById("total_cost_price_outage"+row_no).value = commaSplit(total_cost,round_number);
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
            function add_row_exit(stock_id,product_id,stock_code,product_name,property,barcode,main_unit,product_unit_id,amount,tax,cost_id,cost_price,cost_price_money,cost_price_2,purchase_extra_cost_exit_2,cost_price_money_2,cost_price_system,cost_price_system_money,purchase_extra_cost,purchase_extra_cost_system,product_cost,product_cost_money,serial,is_production,dimention,spect_main_id,spect_name)
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
                newCell.innerHTML = '<input type="hidden" name="is_production_spect_exit' + row_count_exit +'" id="is_production_spect_exit' + row_count_exit +'" value="'+ is_production +'"><input type="hidden" name="is_add_info_' + row_count_exit +'" id="is_add_info_' + row_count_exit +'" value="1"><input type="hidden" name="tree_type_exit_' + row_count_exit +'" id="tree_type_exit_' + row_count_exit +'" value="S"><input type="hidden" name="row_kontrol_exit' + row_count_exit +'" id="row_kontrol_exit' + row_count_exit +'" value="1"><a style="cursor:pointer" onclick="copy_row_exit('+row_count_exit+');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img  src="images/copy_list.gif" border="0"></a> <a style="cursor:pointer" onclick="sil_exit(' + row_count_exit + ');"><img src="images/delete_list.gif" border="0" align="absmiddle" alt="Sil"></a><input type="hidden" name="cost_id_exit' + row_count_exit +'" id="cost_id_exit' + row_count_exit +'" value="'+cost_id+'"><input type="hidden" name="product_cost_exit' + row_count_exit +'" id="product_cost_exit' + row_count_exit +'" value="'+product_cost+'"><input type="hidden" name="product_cost_money_exit' + row_count_exit +'" id="product_cost_money_exit' + row_count_exit +'" value="'+product_cost_money+'"><input type="hidden" name="cost_price_system_exit' + row_count_exit +'" id="cost_price_system_exit' + row_count_exit +'" value="'+cost_price_system+'"><input type="hidden" name="money_system_exit' + row_count_exit +'" id="money_system_exit' + row_count_exit +'" value="'+cost_price_system_money+'"><input type="hidden" name="purchase_extra_cost_system_exit' + row_count_exit +'" id="purchase_extra_cost_system_exit' + row_count_exit +'" value="'+purchase_extra_cost_system+'"><input type="hidden" name="amount_exit_' + row_count_exit +'" id="amount_exit_' + row_count_exit +'" value="'+commaSplit(filterNum(amount,round_number),round_number)+'">';
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
            
            function add_row_outage(stock_id,product_id,stock_code,product_name,property,barcode,main_unit,product_unit_id,amount,tax,cost_id,cost_price,cost_price_money,cost_price_2,purchase_extra_cost_2,cost_price_money_2,cost_price_system,cost_price_system_money,purchase_extra_cost,purchase_extra_cost_system,product_cost,product_cost_money,serial,is_production,dimention,spect_main_id,spect_name)
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
                newCell.innerHTML = '<input type="hidden" name="row_kontrol_outage' + row_count_outage +'" id="row_kontrol_outage' + row_count_outage +'" value="1"><a style="cursor:pointer" onclick="copy_row_outage('+row_count_exit+');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img  src="images/copy_list.gif" border="0"></a> <a style="cursor:pointer" onclick="sil_outage(' + row_count_outage + ');"><img src="images/delete_list.gif" border="0" align="absmiddle" alt="Sil"></a><input type="hidden" name="cost_id_outage' + row_count_outage +'" id="cost_id_outage' + row_count_outage +'" value="'+cost_id+'"><input type="hidden" name="product_cost_outage' + row_count_outage +'" id="product_cost_outage' + row_count_outage +'" value="'+product_cost+'"><input type="hidden" name="product_cost_money_outage' + row_count_outage +'" id="product_cost_money_outage' + row_count_outage +'" value="'+product_cost_money+'"><input type="hidden" name="cost_price_system_outage' + row_count_outage +'" id="cost_price_system_outage' + row_count_outage +'" value="'+cost_price_system+'"><input type="hidden" name="money_system_outage' + row_count_outage +'" id="money_system_outage' + row_count_outage +'" value="'+cost_price_system_money+'"><input type="hidden" name="purchase_extra_cost_system_outage' + row_count_outage +'" id="purchase_extra_cost_system_outage' + row_count_outage +'" value="'+purchase_extra_cost_system+'">';
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
                add_row_exit(stock_id_exit,product_id_exit,stock_code_exit,product_name_exit,'',barcode_exit,unit_exit,unit_id_exit,amount_exit,kdv_amount_exit,cost_id_exit,cost_price_exit,money_exit,cost_price_exit_2,purchase_extra_cost_exit_2,money_exit_2,cost_price_system_exit,money_system_exit,purchase_extra_cost_exit,purchase_extra_cost_system_exit,product_cost_exit,product_cost_money_exit,serial_no_exit,is_production_spect_exit,dimention_exit,spec_main_id_exit,spect_name_exit);
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
                 add_row_outage(stock_id_outage,product_id_outage,stock_code_outage,product_name_outage,'',barcode_outage,unit_outage,unit_id_outage,amount_outage,kdv_amount_outage,cost_id_outage,cost_price_outage,money_outage,cost_price_outage_2,purchase_extra_cost_outage_2,money_outage_2,cost_price_system_outage,money_system_outage,purchase_extra_cost_outage,purchase_extra_cost_system_outage,product_cost_outage,product_cost_money_outage,serial_no_outage,'',dimention_outage,spect_id_outage,spect_name_outage);
            }
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
                    url_str='&is_sale_product=1&update_product_row_id=0<cfoutput>&round_number=#round_number#</cfoutput>&is_lot_no_based=1&prod_order_result_=1&sort_type=1&lot_no=form_basket.lot_no_exit'+no+'&keyword=' + form_stock_code+'&is_form_submitted=1&int_basket_id=1';
                    windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products'+url_str+'','list');
                }
                else if(type == 3)
                {//fire ise type 3
                    form_stock_code = document.getElementById("stock_code_outage"+no).value;
                    url_str='&is_sale_product=1&update_product_row_id=0<cfoutput>&round_number=#round_number#</cfoutput>&is_lot_no_based=1&prod_order_result_=1&sort_type=1&lot_no=form_basket.lot_no_outage'+no+'&keyword=' + form_stock_code+'&is_form_submitted=1&int_basket_id=1';
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
            function pencere_ac_serial_no(no)
            {
                form_serial_no_exit = document.getElementById("serial_no_exit"+no);
                if(form_serial_no_exit.value == "")
                    alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='225.Seri No'>");
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
				newRows();
                change_row_cost(1,1);//satirdaki maliyetleri bitis tarihindeki kura göre guncelliyor.
                var Get_Result = wrk_safe_query('prdp_get_result','dsn3',0,document.getElementById('production_result_no').value);	
                if(Get_Result.recordcount > 0){
                    alert('Bu Sonuç Numarası Daha Önce Kullanılmış');					
                        if(control1.REMAIN_AMOUNT > 0){		
                            var a=parseInt(list_getat(document.getElementById('production_result_no').value,2,'-'))+1;					
                            document.getElementById('production_result_no').value=list_getat(document.getElementById('production_result_no').value,1,'-')+'-'+a;
                            }
                        else
                            {alert("Bu üretim emri için Üretim sonucu girilemez.");alert();
                            }
                        //window.location.reload();	
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
                if(document.getElementById("station_id").value == "" || document.getElementById("station_name").value == "")
                {
                    alert("Lütfen İstasyon Seçiniz !");
                    return false;
                }
                
                if((document.getElementById("sarf_recordcount").value > 0 && (filterNum(document.getElementById("amount_exit_"+1).value,round_number)>0) || document.getElementById("sarf_recordcount").value == 0) && (filterNum(document.getElementById("amount"+1).value,round_number)>0))
                {
                    <cfif get_det_po.is_demontaj eq 0><!--- Demontaj Değil ise --->
                        if(document.getElementById('spec_main_id1').value == "" && document.getElementById('spect_id1').value == ""){
                            alert('Ana Ürün İçin Spec Seçmeniz Gerekmektedir.');
                            return false;
                        }
                    </cfif>
                    if(!chk_process_cat('form_basket')) return false;
                    if(!check_display_files('form_basket')) return false;
                    if(!process_cat_control()) return false;
                    if(!time_check(form_basket.start_date, form_basket.start_h, form_basket.start_m, form_basket.finish_date, form_basket.finish_h, form_basket.finish_m, "<cf_get_lang no='463.Başlangıç Tarihi Bitiş Tarihinden Büyük'> !")) return false;
                    var row_count_exit_ = 0;
                    for (var k=1;k<=row_count_exit;k++)//eğer sarfların içinde üretilen bir ürün varsa onun için spect seçilmesini zorunlu kılıyor.Onun kontrolü
                    {
                        if(document.getElementById("row_kontrol_exit"+k).value==1)// fire ürün satırı olması için kontrol eklendi.
                        {
                            row_count_exit_ = row_count_exit_ + 1;
                            if((document.getElementById("spec_main_id_exit"+k).value == "" || document.getElementById("spec_main_id_exit"+k).value == "") && (document.getElementById("is_production_spect_exit"+k).value == 1)&& document.getElementById("row_kontrol_exit"+k).value==1)//spect id ve spect name varsa vede ürtilen bir ürünse
                            {
                                alert('Üretilen Ürünler İçin Spect Seçmeniz Gerekmektedir.(' + document.getElementById("product_name_exit"+k).value + ')');
                                return false;
                            }
                            if(document.getElementById("spec_main_id_exit"+k).value != '')
                            {
                                var spec_control = wrk_query("SELECT SPECT_MAIN_ID,SPECT_STATUS FROM SPECT_MAIN WHERE SPECT_MAIN_ID = " + document.getElementById("spec_main_id_exit"+k).value,"dsn3");
                                if(spec_control.recordcount == 0)
                                {
                                    alert(row_count_exit_+". Satırdaki Sarf Ürün Spec'i Silinmiş. Lütfen Spec'inizi Güncelleyiniz!");
                                    return false;
                                }
                                else if(spec_control.SPECT_STATUS == 0)
                                {
                                    alert(row_count_exit_+". Satırdaki Sarf Ürün Spec'i Pasif Durumda. Lütfen Spec'inizi Güncelleyiniz!");
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
                                            alert(row_count_exit_+'. sarf satırındaki '+ document.getElementById("product_name_exit"+k).value + ' ürünü için lot no takibi yapılmaktadır!');
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
                            <cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
                                if(check_lotno('form_basket'))//işlem kategorisinde lot no zorunlu olsun seçili ise
                                {
                                    get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.getElementById("stock_id_outage"+k).value);
                                    if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
                                    {
                                        if(document.getElementById("lot_no_outage"+k).value == '')
                                        {
                                            alert(row_count_outage_+'. fire satırındaki '+ document.getElementById("product_name_outage"+k).value + ' ürünü için lot no takibi yapılmaktadır!');
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
                                alert("Ürün Miktarı 0 Olamaz , Lütfen Miktarları Kontrol Ediniz !");
                                return false;
                            }
                        }
                        if(document.getElementById("document.form_basket.amount2_"+r) != undefined)
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
                    }
                    if(row_count_ == 0)
                    {
                        alert("Lütfen Ana Ürün Seçiniz!");
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
                                alert("Sarf Miktarı 0 Olamaz , Lütfen Miktarları Kontrol Ediniz !");
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
                    }
                    if(row_count_exit_ == 0)
                    {
                        alert("Lütfen Sarf Ürünü Seçiniz!");
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
                        if(document.getElementById("spec_main_id_outage"+k).value != '')
                        {
                            var spec_control_outage = wrk_query("SELECT SPECT_MAIN_ID,SPECT_STATUS FROM SPECT_MAIN WHERE SPECT_MAIN_ID =  " + document.getElementById("spec_main_id_outage"+k).value,"dsn3");
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
				return true;
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
                //var prohibited=' [space] , ",    #,  $, %, &, ', (, ), *, +, ,, ., /, <, =, >, ?, @, [, \, ], ], `, {, |,   }, , «, ';
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
        </script>
<cfelseif isdefined("attributes.event") and  attributes.event is 'upd'>
	<script language="javascript">
	$( document ).ready(function() {
		document.getElementById('search_production_result_no').focus();
		row_count=<cfoutput>#get_row_enter.recordcount#</cfoutput>;
		row_count_exit=<cfoutput>#get_row_exit.recordcount#</cfoutput>;
		row_count_outage = <cfoutput>#get_row_outage.recordcount#</cfoutput>;
		round_number = <cfoutput>#round_number#</cfoutput>;//xmlden geliyor. miktar kusuratlarini burdan aliyor
	});
	
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
			document.getElementById("total_cost_price_exit"+row_no).value = commaSplit(total_cost,round_number);
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
			document.getElementById("total_cost_price_outage"+row_no).value = commaSplit(total_cost,round_number);
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
					document.getElementById("total_cost_price_exit"+row_no).value = commaSplit(total_cost,round_number);
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
					document.getElementById("total_cost_price_outage"+row_no).value = commaSplit(total_cost,round_number);
				}
			}
		}
	}
	function counter(field, countfield, maxlimit){ 
		if(field.value.length > maxlimit){ 
			field.value = field.value.substring(0, maxlimit);
			alert("Max "+maxlimit+"!"); 
		}
		else 
			countfield.value = maxlimit - field.value.length; 
	} 
	function kontrol2()
	{
		if(!chk_period(document.getElementById("finish_date"), 'İşlem')) return false;
		if (!process_cat_control()) return false;
		if (!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		form_basket.del_pr_order_id.value = <cfoutput>#get_Detail.pr_order_id#</cfoutput>;
		<cfif x_fis_kontrol eq 1 and isdefined("get_ship_kontrol") and get_ship_kontrol.recordcount and get_ship_kontrol.is_delivered eq 1>
			alert("Oluşan Sevk İrsaliyesi Teslim Alınmıştır. Lütfen Teslim Al Seçeneğini Kaldırınız !");
			return false;
		</cfif>
		return true;
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
		for(i=1;i<=<cfoutput>#get_row_exit.recordcount#</cfoutput>;i++)
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
		for(i=1;i<=<cfoutput>#get_row_outage.recordcount#</cfoutput>;i++)
		{
				document.getElementById('frm_row_outage' + i).style.display="none";
				document.getElementById("row_kontrol_outage"+i).value = 0;
		}
	}
	//iframe çalıstiriyor add_row fonksiyonunu
	<!--- XX --->function add_row(stock_id,product_id,stock_code,product_name,property,barcode,main_unit,product_unit_id,amount,tax,cost_id,cost_price,cost_price_money,cost_price_2,purchase_extra_cost_2,cost_price_money_2,cost_price_system,cost_price_system_money,purchase_extra_cost,purchase_extra_cost_system,product_cost,product_cost_money,serial,is_production,dimention,spect_main_id,spect_name)
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
		newCell.innerHTML = '<input type="hidden" name="tree_type_' + row_count +'" id="tree_type_' + row_count +'" value="S"><input type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0" align="absbottom" alt="Sil"></a><input type="hidden" name="cost_id' + row_count +'" id="cost_id' + row_count +'" value="'+cost_id+'"><input type="hidden" name="product_cost' + row_count +'" id="product_cost' + row_count +'" value="'+product_cost+'"><input type="hidden" name="product_cost_money' + row_count +'" id="product_cost_money' + row_count +'" value="'+product_cost_money+'"><input type="hidden" name="cost_price_system' + row_count +'" id="cost_price_system' + row_count +'" value="'+cost_price_system+'"><input type="hidden" name="money_system' + row_count +'" id="money_system' + row_count +'" value="'+cost_price_system_money+'"><input type="hidden" name="purchase_extra_cost' + row_count +'" id="purchase_extra_cost' + row_count +'" value="'+purchase_extra_cost+'"><input type="hidden" name="purchase_extra_cost_system' + row_count +'" id="purchase_extra_cost_system' + row_count +'" value="'+purchase_extra_cost_system+'"><cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1><input type="hidden" name="cost_price_extra_2' + row_count +'" id="cost_price_extra_2' + row_count +'" value="'+purchase_extra_cost_2+'" readonly class="moneybox"></cfif>';
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
		newCell.innerHTML = '<input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spec_main_id' + row_count +'" id="spec_main_id' + row_count +'" value="'+spect_main_id+'" readonly style="width:40px;"> <input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spect_id' + row_count +'" id="spect_id' + row_count +'" value="" readonly style="width:40px;"> <input type="<cfoutput>#Evaluate('spec_name_display')#</cfoutput>" name="spect_name' + row_count +'" id="spect_name' + row_count +'"value="'+spect_name+'" readonly style="width:150px;"> <img src="/images/plus_thin.gif" onClick="pencere_ac_spect('+ row_count +');" align="absbottom" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount' + row_count +'" id="amount' + row_count +'" value="'+commaSplit(filterNum(amount,6),6)+'" onKeyup="return(FormatCurrency(this,event,6));" onBlur="hesapla_deger(' + row_count +',1);" class="moneybox" style="width:70px;">';
		<cfif isdefined("x_is_fire_product") and x_is_fire_product eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="fire_amount_' + row_count +'" id="fire_amount_' + row_count +'" value="0" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(' + row_count +',1);" class="moneybox" style="width:60px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" value="'+product_unit_id+'" name="unit_id' + row_count +'" id="unit_id' + row_count +'"><input type="text" name="unit' + row_count +'" id="unit' + row_count +'" value="'+main_unit+'" readonly style="width:60px;">';
		<cfif isdefined('x_is_show_abh') and x_is_show_abh eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="dimention' + row_count +'" id="dimention' + row_count +'" value="'+dimention+'" readonly style="width:60px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="cost_price' + row_count +'" id="cost_price' + row_count +'" value="'+cost_price+'" readonly style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
		<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="total_cost_price' + row_count +'" id="total_cost_price' + row_count +'" value="'+commaSplit(filterNum(cost_price,round_number) * filterNum(amount,round_number),round_number)+'" readonly style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
		</cfif>
		<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="labor_cost' + row_count +'" id="labor_cost' + row_count +'" value="" class="moneybox" style="width:0px;"><input type="text" name="____labor_cost' + row_count +'" id="____labor_cost' + row_count +'" value="" style="width:90px;">';
		</cfif>
		<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="station_reflection_cost_system' + row_count +'" id="station_reflection_cost_system' + row_count +'" value="" class="moneybox" style="width:0px;"><input type="text" name="____station_reflection_cost_system' + row_count +'" id="____station_reflection_cost_system' + row_count +'" value="" style="width:90px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="money' + row_count +'" id="money' + row_count +'" value="'+cost_price_money+'" readonly style="width:50px;">';	
		<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="cost_price_2' + row_count +'" id="cost_price_2' + row_count +'" value="'+cost_price_2+'" readonly style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="total_cost_price_2' + row_count +'" id="total_cost_price_2' + row_count +'" value="'+commaSplit(filterNum(cost_price_2,round_number) * filterNum(amount,round_number),round_number)+'" readonly style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
			</cfif>
		</cfif>
		<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="____labor_cost2_' + row_count +'" id="____labor_cost2_' + row_count +'" value="" style="width:90px;">';
		</cfif>
		<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="____station_reflection_cost_system2_' + row_count +'" id="____station_reflection_cost_system2_' + row_count +'" value="" style="width:90px;">';
		</cfif>
		<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="money_2' + row_count +'" id="money_2' + row_count +'" value="'+cost_price_money_2+'" readonly style="width:50px;">';	
		</cfif>
		<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount2_' + row_count +'" id="amount2_' + row_count +'" value="" onKeyup="return(FormatCurrency(this,event,6));" onBlur="" class="moneybox" style="width:70px;">';
		//2.birim ekleme
		var get_Unit2_Prod = wrk_safe_query('prdp_get_unit2_prod','dsn3',0,product_id)
		var unit2_values ='<select name="unit2'+row_count+'" id="unit2'+row_count+'" style="width:60;">';
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
		newCell.innerHTML = '<input type="text" style="width:70px;" name="product_name2' + row_count +'" id="product_name2' + row_count +'" value="">';
		//2.birim ekleme bitti.
	}
	//satir_sarf = document.getElementById("table2").rows.length;
	function add_row_exit(stock_id,product_id,stock_code,product_name,property,barcode,main_unit,product_unit_id,amount,tax,cost_id,cost_price,cost_price_money,cost_price_2,purchase_extra_cost_2,cost_price_money_2,cost_price_system,cost_price_system_money,purchase_extra_cost,purchase_extra_cost_system,product_cost,product_cost_money,serial,is_production,dimention,spect_main_id,spect_name)
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
		newCell.innerHTML = '<input type="hidden" name="is_production_spect_exit' + row_count_exit +'" id="is_production_spect_exit' + row_count_exit +'" value="'+ is_production +'"><input type="hidden" name="is_add_info_' + row_count_exit +'" id="is_add_info_' + row_count_exit +'" value="1"><input type="hidden" name="tree_type_exit_' + row_count_exit +'" id="tree_type_exit_' + row_count_exit +'" value="S"><input type="hidden" name="row_kontrol_exit' + row_count_exit +'" id="row_kontrol_exit' + row_count_exit +'" value="1"><a style="cursor:pointer" onclick="copy_row_exit('+row_count_exit+');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img  src="images/copy_list.gif" border="0"></a> <a style="cursor:pointer" onclick="sil_exit(' + row_count_exit + ');"><img  src="images/delete_list.gif" border="0" align="absbottom" alt="Sil"></a><input type="hidden" name="cost_id_exit' + row_count_exit +'" id="cost_id_exit' + row_count_exit +'" value="'+cost_id+'"><input type="hidden" name="product_cost_exit' + row_count_exit +'" id="product_cost_exit' + row_count_exit +'" value="'+product_cost+'"><input type="hidden" name="product_cost_money_exit' + row_count_exit +'" id="product_cost_money_exit' + row_count_exit +'" value="'+product_cost_money+'"><input type="hidden" name="cost_price_system_exit' + row_count_exit +'" id="cost_price_system_exit' + row_count_exit +'" value="'+cost_price_system+'"><input type="hidden" name="money_system_exit' + row_count_exit +'" id="money_system_exit' + row_count_exit +'" value="'+cost_price_system_money+'"><input type="hidden" name="purchase_extra_cost_system_exit' + row_count_exit +'" id="purchase_extra_cost_system_exit' + row_count_exit +'" value="'+purchase_extra_cost_system+'">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="stock_code_exit' + row_count_exit +'" id="stock_code_exit' + row_count_exit +'" value="'+stock_code+'" readonly style="width:120px;"><input type="hidden" name="kdv_amount_exit' + row_count_exit +'" id="kdv_amount_exit' + row_count_exit +'" value="'+tax+'">';
		<cfif x_is_barkod_col eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="barcode_exit' + row_count_exit +'" id="barcode_exit' + row_count_exit +'" value="'+barcode+'" readonly style="width:90px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="product_id_exit' + row_count_exit +'" id="product_id_exit' + row_count_exit +'" value="'+product_id+'"><input type="hidden" name="stock_id_exit' + row_count_exit +'" id="stock_id_exit' + row_count_exit +'" value="'+stock_id+'"><input type="text" name="product_name_exit' + row_count_exit +'" id="product_name_exit' + row_count_exit +'" value="'+ product_name + property +'" readonly style="width:230px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.display = "<cfoutput>#spec_img_display#</cfoutput>";
		newCell.innerHTML = ' <input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spec_main_id_exit' + row_count_exit +'" id="spec_main_id_exit' + row_count_exit +'"  value="'+spect_main_id+'" readonly style="width:40px;"> <input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spect_id_exit' + row_count_exit +'" id="spect_id_exit' + row_count_exit +'" value="" style="width:40px;"> <input type="<cfoutput>#Evaluate('spec_name_display')#</cfoutput>" name="spect_name_exit' + row_count_exit +'" id="spect_name_exit' + row_count_exit +'" value="'+spect_name+'" readonly style="width:160px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="lot_no_exit' + row_count_exit +'" id="lot_no_exit' + row_count_exit +'" value="" onKeyup="lotno_control('+ row_count_exit +',2);" style="width:75px;"> <img src="/images/plus_thin.gif" onClick="pencere_ac_list_product('+ row_count_exit +',2);" align="absbottom" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount_exit' + row_count_exit +'" id="amount_exit' + row_count_exit +'" value="'+commaSplit(filterNum(amount,6),6)+'" onKeyup="return(FormatCurrency(this,event,6));" onBlur="hesapla_deger(' + row_count_exit +',0);" class="moneybox" style="width:70px;"><input type="hidden" name="amount_exit_' + row_count_exit +'" id="amount_exit_' + row_count_exit +'" value="'+commaSplit(filterNum(amount,6),6)+'">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="unit_id_exit' + row_count_exit +'" id="unit_id_exit' + row_count_exit +'" value="'+product_unit_id+'"><input type="text" name="unit_exit' + row_count_exit +'" id="unit_exit' + row_count_exit +'" value="'+main_unit+'" readonly style="width:60px;"><input type="hidden" name="serial_no_exit' + row_count_exit +'" id="serial_no_exit' + row_count_exit +'" value="'+serial+'">';
		<cfif isdefined('x_is_show_abh') and x_is_show_abh eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="dimention_exit' + row_count_exit +'" id="dimention_exit' + row_count_exit +'" value="'+dimention+'" readonly style="width:60px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="cost_price_exit' + row_count_exit +'" id="cost_price_exit' + row_count_exit +'" value="'+cost_price+'" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_exit+',2);"</cfif>>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="purchase_extra_cost_exit' + row_count_exit +'" id="purchase_extra_cost_exit' + row_count_exit +'" value="'+purchase_extra_cost+'"  onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_exit+',2);"</cfif> class="moneybox">';
		<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="total_cost_price_exit' + row_count_exit +'" id="total_cost_price_exit' + row_count_exit +'" value="'+commaSplit((parseFloat(filterNum(cost_price,round_number))+parseFloat(filterNum(purchase_extra_cost,round_number)))*filterNum(amount,round_number),round_number)+'" readonly class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="money_exit' + row_count_exit +'" id="money_exit' + row_count_exit +'" value="'+cost_price_money+'" readonly style="width:50px;">';
		<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="cost_price_exit_2' + row_count_exit +'" id="cost_price_exit_2' + row_count_exit +'" value="'+cost_price_2+'" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="purchase_extra_cost_exit_2' + row_count_exit +'" id="purchase_extra_cost_exit_2' + row_count_exit +'" value="'+purchase_extra_cost_2+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));" <cfif is_change_sarf_cost eq 0>readonly</cfif> class="moneybox">';
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="total_cost_price_exit_2' + row_count_exit +'" id="total_cost_price_exit_2' + row_count_exit +'" value="'+commaSplit((parseFloat(filterNum(cost_price_2,round_number))+parseFloat(filterNum(purchase_extra_cost_2,round_number)))*filterNum(amount,round_number),round_number)+'" class="moneybox" readonly>';
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="money_exit_2' + row_count_exit +'" id="money_exit_2' + row_count_exit +'" value="'+cost_price_money_2+'" readonly style="width:50px;">';
		</cfif>
		<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount_exit2_' + row_count_exit +'" id="amount_exit2_' + row_count_exit +'" value="" onKeyup="return(FormatCurrency(this,event,6));" onBlur="" class="moneybox" style="width:70px;">';
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
		newCell.innerHTML = '<input type="text" style="width:70px;" name="product_name2_exit' + row_count_exit +'" id="product_name2_exit' + row_count_exit +'" value="">';
		<cfif isdefined("x_is_show_sb") and x_is_show_sb>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="checkbox" name="is_sevkiyat' + row_count_exit +'" id="is_sevkiyat' + row_count_exit +'" value="1">';
		</cfif>
		<cfif isdefined('x_is_show_mc') and x_is_show_mc eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="checkbox" name="is_manual_cost_exit' + row_count_exit +'" id="is_manual_cost_exit' + row_count_exit +'" value="1">';
		</cfif>
	}
	
	function add_row_outage(stock_id,product_id,stock_code,product_name,property,barcode,main_unit,product_unit_id,amount,tax,cost_id,cost_price,cost_price_money,cost_price_2,purchase_extra_cost_2,cost_price_money_2,cost_price_system,cost_price_system_money,purchase_extra_cost,purchase_extra_cost_system,product_cost,product_cost_money,serial,is_production,dimention,spect_main_id,spect_name)

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
		newCell.innerHTML  ='<input type="hidden" name="row_kontrol_outage' + row_count_outage +'" id="row_kontrol_outage' + row_count_outage +'" value="1">';
		newCell.innerHTML +='<a style="cursor:pointer" onclick="copy_row_outage('+row_count_outage+');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img src="images/copy_list.gif" border="0"></a> ';
		newCell.innerHTML +='<a style="cursor:pointer" onclick="sil_outage(' + row_count_outage + ');"><img src="images/delete_list.gif" border="0" align="absbottom" alt="<cf_get_lang_main no="51.Sil">"></a>';
		newCell.innerHTML +='<input type="hidden" name="cost_id_outage' + row_count_outage +'" id="cost_id_outage' + row_count_outage +'" value="'+cost_id+'">';
		newCell.innerHTML +='<input type="hidden" name="product_cost_outage' + row_count_outage +'" id="product_cost_outage' + row_count_outage +'" value="'+product_cost+'">';
		newCell.innerHTML +='<input type="hidden" name="product_cost_money_outage' + row_count_outage +'" id="product_cost_money_outage' + row_count_outage +'" value="'+product_cost_money+'">';
		newCell.innerHTML +='<input type="hidden" name="cost_price_system_outage' + row_count_outage +'" id="cost_price_system_outage' + row_count_outage +'" value="'+cost_price_system+'">';
		newCell.innerHTML +='<input type="hidden" name="money_system_outage' + row_count_outage +'" id="money_system_outage' + row_count_outage +'" value="'+cost_price_system_money+'">';
		newCell.innerHTML +='<input type="hidden" name="purchase_extra_cost_system_outage' + row_count_outage +'" id="purchase_extra_cost_system_outage' + row_count_outage +'" value="'+purchase_extra_cost_system+'">';'';
		
		newCell.setAttribute('nowrap','nowrap');
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="stock_code_outage' + row_count_outage +'" id="stock_code_outage' + row_count_outage +'" value="'+stock_code+'" readonly style="width:120px;"><input type="hidden" name="kdv_amount_outage' + row_count_outage +'" id="kdv_amount_outage' + row_count_outage +'" value="'+tax+'">';
		<cfif x_is_barkod_col eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="barcode_outage' + row_count_outage +'" id="barcode_outage' + row_count_outage +'" value="'+barcode+'" readonly style="width:90px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="product_id_outage' + row_count_outage +'" id="product_id_outage' + row_count_outage +'" value="'+product_id+'"><input type="hidden" name="stock_id_outage' + row_count_outage +'" id="stock_id_outage' + row_count_outage +'" value="'+stock_id+'"><input type="text" name="product_name_outage' + row_count_outage +'" id="product_name_outage' + row_count_outage +'" value="'+ product_name + property +'" readonly style="width:230px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.display = "<cfoutput>#spec_img_display#</cfoutput>";
		newCell.innerHTML = ' <input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spec_main_id_outage' + row_count_outage +'" id="spec_main_id_outage' + row_count_outage +'" value="'+spect_main_id+'" readonly style="width:40px;"> <input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spect_id_outage' + row_count_outage +'" id="spect_id_outage' + row_count_outage +'" value="" style="width:40px;"> <input type="<cfoutput>#Evaluate('spec_name_display')#</cfoutput>" name="spect_name_outage' + row_count_outage +'" id="spect_name_outage' + row_count_outage +'" value="'+spect_name+'" readonly style="width:150px;"> <img src="/images/plus_thin.gif" onClick="pencere_ac_spect('+ row_count_outage +',3);" align="absbottom" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="lot_no_outage' + row_count_outage +'" id="lot_no_outage' + row_count_outage +'" value="" onKeyup="lotno_control('+ row_count_outage +',3);" style="width:75px;"> <img src="/images/plus_thin.gif" onClick="pencere_ac_list_product('+ row_count_outage +',3);" align="absbottom" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount_outage' + row_count_outage +'" id="amount_outage' + row_count_outage +'" value="'+commaSplit(filterNum(amount,6),6)+'" onKeyup="return(FormatCurrency(this,event,6));" onBlur="hesapla_deger(' + row_count_outage +',2);" class="moneybox" style="width:70px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" value="'+product_unit_id+'" name="unit_id_outage' + row_count_outage +'" id="unit_id_outage' + row_count_outage +'"><input type="text" name="unit_outage' + row_count_outage +'" id="unit_outage' + row_count_outage +'" value="'+main_unit+'" readonly style="width:60px;"><input type="hidden" name="serial_no_outage' + row_count_outage +'" id="serial_no_outage' + row_count_outage +'" value="'+serial+'">';
		<cfif isdefined('x_is_show_abh') and x_is_show_abh eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="dimention_outage' + row_count_outage +'" id="dimention_outage' + row_count_outage +'" value="'+dimention+'" readonly style="width:60px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
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
			newCell.innerHTML = '<input type="text" name="purchase_extra_cost_outage_2' + row_count_outage +'" id="purchase_extra_cost_outage_2' + row_count_outage +'" value="'+purchase_extra_cost_2+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));" <cfif is_change_sarf_cost eq 0>readonly</cfif> class="moneybox">';
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="total_cost_price_outage_2' + row_count_outage +'" id="total_cost_price_outage_2' + row_count_outage +'" value="'+commaSplit((parseFloat(filterNum(cost_price_2,round_number))+parseFloat(filterNum(purchase_extra_cost_2,round_number)))*filterNum(amount,round_number),round_number)+'" readonly class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="money_outage_2' + row_count_outage +'" id="money_outage_2' + row_count_outage +'" value="'+cost_price_money_2+'" readonly style="width:50px;">';
		</cfif>
		<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="amount_outage2_' + row_count_outage +'" id="amount_outage2_' + row_count_outage +'" value="" onKeyup="return(FormatCurrency(this,event,6));" onBlur="" class="moneybox" style="width:70px;">';
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
		newCell.style.display = "<cfoutput>#product_name2_display#</cfoutput>";
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" style="width:50px;" name="product_name2_outage' + row_count_outage +'" id="product_name2_outage' + row_count_outage +'" value="'+cost_price_money_2+'">';
		//2.birim ekleme bitti.
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
		add_row_exit(stock_id_exit,product_id_exit,stock_code_exit,product_name_exit,'',barcode_exit,unit_exit,unit_id_exit,amount_exit,kdv_amount_exit,cost_id_exit,cost_price_exit,money_exit,cost_price_exit_2,purchase_extra_cost_exit_2,money_exit_2,cost_price_system_exit,money_system_exit,purchase_extra_cost_exit,purchase_extra_cost_system_exit,product_cost_exit,product_cost_money_exit,serial_no_exit,is_production_spect_exit,dimention_exit,spec_main_id_exit,spect_name_exit);
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
		 add_row_outage(stock_id_outage,product_id_outage,stock_code_outage,product_name_outage,'',barcode_outage,unit_outage,unit_id_outage,amount_outage,kdv_amount_outage,cost_id_outage,cost_price_outage,money_outage,cost_price_outage_2,purchase_extra_cost_outage_2,money_outage_2,cost_price_system_outage,money_system_outage,purchase_extra_cost_outage,purchase_extra_cost_system_outage,product_cost_outage,product_cost_money_outage,serial_no_outage,'',dimention_outage,spect_id_outage,spect_name_outage);
 	}
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
			url_str='&is_sale_product=1&update_product_row_id=0<cfoutput>&round_number=#round_number#</cfoutput>&is_lot_no_based=1&prod_order_result_=1&sort_type=1&lot_no=form_basket.lot_no_exit'+no+'&keyword=' + form_stock_code+'&is_form_submitted=1&int_basket_id=1';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products'+url_str+'','list');
		}
		else if(type == 3)
		{//fire ise type 3
			form_stock_code = document.getElementById("stock_code_outage"+no).value;
			url_str='&is_sale_product=1&update_product_row_id=0<cfoutput>&round_number=#round_number#</cfoutput>&is_lot_no_based=1&prod_order_result_=1&sort_type=1&lot_no=form_basket.lot_no_outage'+no+'&keyword=' + form_stock_code+'&is_form_submitted=1&int_basket_id=1';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products'+url_str+'','list');
		}
	}
	function alternative_product_cost(pid,no)
		{
			var new_sql = "SELECT TOP 1 PRODUCT_COST_ID,PURCHASE_NET,PURCHASE_NET_MONEY,PURCHASE_NET_SYSTEM,PURCHASE_NET_SYSTEM_MONEY,PURCHASE_EXTRA_COST,PURCHASE_EXTRA_COST_SYSTEM,PRODUCT_COST,MONEY FROM PRODUCT_COST WHERE PRODUCT_ID = "+pid+" AND START_DATE <= <cfoutput>#createodbcdate(GET_DETAIL.finish_date)#</cfoutput> ORDER BY START_DATE DESC,RECORD_DATE DESC";	
			var listParam = pid + "*" + "<cfoutput>#createodbcdate(GET_DETAIL.finish_date)#</cfoutput>";
			var GET_PRODUCT_COST = wrk_safe_query("prdp_GET_PRODUCT_COST",'dsn3',0,listParam);
			if(!GET_PRODUCT_COST.recordcount)
			{
					cost_id = 0;
					purchase_extra_cost = 0;
					product_cost = 0;
					product_cost_money = '<cfoutput>#session.ep.money#</cfoutput>';
					cost_price = 0;
					cost_price_money = '<cfoutput>#session.ep.money#</cfoutput>';
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
				cost_price_system = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM;
				cost_price_system_money = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY;
				purchase_extra_cost_system = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM;
			}
			//Ürünün maliyet değerleri
			document.getElementById("purchase_extra_cost_exit"+no).value = purchase_extra_cost;
			document.getElementById("cost_price_exit"+no).value = commaSplit(cost_price,round_number);
			document.getElementById("money_exit"+no).value = cost_price_money;
			document.getElementById("cost_price_system_exit"+no).value =  cost_price_system;
			document.getElementById("money_system_exit"+no).value = cost_price_system_money;
			document.getElementById("purchase_extra_cost_system_exit"+no).value =  purchase_extra_cost_system;
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
	
	if(type==4 && document.getElementById("spect_id"+no).value != "")//Type'nin 4 olması açılacak olan sayfanın GÜNCELLEME sayfası olduğunu gösteriyor.
		{
			if(document.getElementById("stock_id"+no) == undefined || document.getElementById("stock_id"+no) == "")
				alert("<cf_get_lang no='461.Lütfen Ürün Seçiniz'>");
			else
			 url_str='&id='+document.getElementById("spect_id"+no).value;
			 windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_spec&is_spec=1' + url_str,'list');<!--- objects.popup_list_spect_main --->
		}
	else
		{	
		<cfif (not get_fis.recordcount or not get_fis_sarf.recordcount)>//stok fişi oluşturulmamış ise
			if(type==2)
			{	
				form_stock = document.getElementById("stock_id_exit"+no);
				<cfif GET_DETAIL.IS_DEMONTAJ eq 1>
					url_str='&department_id='+_department_id_+'&field_main_id=form_basket.spec_main_id_exit'+no+'&field_id=form_basket.spect_id_exit'+no+'&field_name=form_basket.spect_name_exit' + no + '&stock_id=' + form_stock.value + '&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1&is_demontaj=1&p_order_id=<cfoutput>#attributes.p_order_id#&pr_order_id=#attributes.pr_order_id#</cfoutput>';
				<cfelse>
					url_str='&department_id='+_department_id_+'&field_main_id=form_basket.spec_main_id_exit'+no+'&field_id=form_basket.spect_id_exit'+no+'&field_name=form_basket.spect_name_exit' + no + '&stock_id=' + form_stock.value+'&last_spect=1&create_main_spect_and_add_new_spect_id=1';
				</cfif>
				
			}
			else if(type==3)
			{
				form_stock = document.getElementById("stock_id_outage"+no);
				url_str='&field_id=form_basket.spect_id_outage'+no+'&field_name=form_basket.spect_name_outage' + no + '&stock_id=' + form_stock.value+'&last_spect=1';
			}
			else
			{
				form_stock = document.getElementById("stock_id"+no);
				<cfif GET_DETAIL.IS_DEMONTAJ eq 1>
					url_str='&field_id=form_basket.spect_id'+no+'&field_name=form_basket.spect_name' + no + '&stock_id=' + form_stock.value +'&create_main_spect_and_add_new_spect_id=1&last_spect=1&<cfoutput>p_order_id=#attributes.p_order_id#&pr_order_id=#attributes.pr_order_id#</cfoutput>';
				<cfelse>
					url_str='&p_order_row_id='+document.getElementById('order_row_id').value+'&field_id=form_basket.spect_id'+no+'&field_name=form_basket.spect_name' + no + '&stock_id=' + form_stock.value +'&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1&<cfoutput>p_order_id=#attributes.p_order_id#&pr_order_id=#attributes.pr_order_id#</cfoutput>';
				</cfif>
			}
			if(form_stock.value == "")
				alert("<cf_get_lang no='461.Lütfen Ürün Seçiniz'>");
			else
				 windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&main_to_add_spect=1' + url_str,'list');
		<cfelse>
			alert("<cf_get_lang no ='570.Stok Fişi Oluşturulduğu için spectlerde herhangi bi değişiklik yapamazsınız'>");
		</cfif>
		}
	}
	
	function pencere_ac_serial_no(no)
	{
		form_serial_no_exit = document.getElementById("serial_no_exit"+no);
		if(form_serial_no_exit.value == "")
			alert("<cf_get_lang no='462.Lütfen Seri No Giriniz'> !");
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.serial_no&event=det&product_serial_no=' + form_serial_no_exit.value,'list');	
	}
	function lotno_control(crntrow,type)
	{
		//var prohibited=' [space] , ",    #,  $, %, &, ', (, ), *, +, ,, ., /, <, =, >, ?, @, [, \, ], ],  `, {, |,   }, , «, ';
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
	
	function hesapla_deger(value,id)
	{
		if(id==0)
		{
			var value_amount_exit = document.getElementById("amount_exit"+value);
			if((value_amount_exit.value == "") || (value_amount_exit.value == 0))
			{
				value_amount_exit.value = 1;
			}
		}
		else if(id==1)
		{
			var value_amount = document.getElementById("amount"+value);
			if((value_amount.value == "") || (value_amount.value == 0))
			{
				value_amount.value = 1;
			}
		}else if(id==2)
		{
			var value_amount = document.getElementById("amount_outage"+value);
			if((value_amount.value == "") || (value_amount.value == 0))
			{
				value_amount.value = 1;
			}
		}
		else if(id==3)
		{
			var value_amount = document.getElementById("fire_amount_"+value);
			if((value_amount.value == "") || (value_amount.value == 0))
			{
				value_amount.value = 0;
			}
		}
	}
	function kontrol()
	{
		//if( document.getElementById('is_delstock') && document.getElementById('is_delstock').checked == true || document.getElementById('is_delstock') == undefined){//Üretime sonuç girilmiş ise güncelleme yapılamasın üretim emrinde.
		    var round_number = document.getElementById('round_number').value;
			if(!chk_period(document.getElementById("finish_date"), 'İşlem')) return false;
			if(!chk_process_cat('form_basket')) return false;
			if(!check_display_files('form_basket')) return false;
			if (!process_cat_control()) return false;
			if(document.getElementById("production_result_no").value != '')
			{
				var listParam = document.getElementById("production_result_no").value + "*" + "<cfoutput>#attributes.pr_order_id#</cfoutput>";
				var doc_no_control = wrk_safe_query("prdp_doc_no_control","dsn3",0,listParam);
				if(doc_no_control.recordcount > 0)
				{
					alert("<cf_get_lang_main no='710.Girdiğiniz Belge No Kullanılıyor'>!");
					return false;
				}
			}
			if(document.getElementById("station_id").value == "" || document.getElementById("station_name").value == "")
			{
				alert("<cf_get_lang_main no='1425.Lütfen İstasyon Seçiniz'> !");
				return false;
			}
			tarih1_ = form_basket.start_date.value.substr(6,6) + form_basket.start_date.value.substr(3,2) + form_basket.start_date.value.substr(0,2);
			tarih2_ = form_basket.finish_date.value.substr(6,6) + form_basket.finish_date.value.substr(3,2) + form_basket.finish_date.value.substr(0,2);
		
			if (form_basket.start_h.value.length < 2) saat1_ = '0' + form_basket.start_h.value; else saat1_ = form_basket.start_h.value;
			if (form_basket.start_m.value.length < 2) dakika1_ = '0' + form_basket.start_m.value; else dakika1_ = form_basket.start_m.value;
			if (form_basket.finish_h.value.length < 2) saat2_ = '0' + form_basket.finish_h.value; else saat2_ = form_basket.finish_h.value;
			if (form_basket.finish_m.value.length < 2) dakika2_ = '0' + form_basket.finish_m.value; else dakika2_ = form_basket.finish_m.value;
		
			tarih1_ = tarih1_ + saat1_ + dakika1_;
			tarih2_ = tarih2_ + saat2_ + dakika2_;	
			
			if (tarih1_ >= tarih2_) 
			{
				alert("<cf_get_lang no='463.Başlangıç Tarihi Bitiş Tarihinden Büyük'> !");
				return false;
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
			}
			if(row_count_ == 0)
			{
				alert("Lütfen Ana Ürün Seçiniz!");
				return false;
			}
			var row_count_exit_ = 0;
			for (var k=1;k<=row_count_exit;k++)
			{
				if(document.getElementById("row_kontrol_exit"+k).value==1)//En az bir sarf ürün satırı olması için kontrol eklendi.
				{
					row_count_exit_ = row_count_exit_ + 1;
					if(filterNum(document.getElementById("amount_exit_"+k).value,round_number) <= 0)
					{
						alert("Sarf Miktarı 0 Olamaz , Lütfen Miktarları Kontrol Ediniz !");
						return false;
					}
					<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
						if(check_lotno('form_basket'))//işlem kategorisinde lot no zorunlu olsun seçili ise
						{
							get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.getElementById("stock_id_exit"+k).value);
							if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
							{
								if(document.getElementById("lot_no_exit"+k).value == '')
								{
									alert(row_count_exit_+'. sarf satırındaki '+ document.getElementById("product_name_exit"+k).value + ' ürünü için lot no takibi yapılmaktadır!');
									return false;
								}
							}
						}
					</cfif>
				}
			}
			if(row_count_exit_ == 0)
			{
				alert("Lütfen Sarf Ürünü Seçiniz!");
				return false;
			}	
			for (var k=1;k<=row_count_exit;k++)//eğer sarfların içinde üretilen bir ürün varsa onun için spect seçilmesini zorunlu kılıyor.Onun kontrolü
			{	
				if((document.getElementById("is_delstock") == undefined) || (document.getElementById("is_delstock") != undefined && document.getElementById("is_delstock").checked == false))//Stok Fişleri Silinsin tanımlı değilse yada tanımlı ancak seçili değilse,eğer seçili ise kontrole sokmuyoruz ve direkt olarak siliyoruz.
				{	
					if((document.getElementById("spec_main_id_exit"+k).value == "" || document.getElementById("spect_name_exit"+k).value == "") && (document.getElementById("is_production_spect_exit"+k)!= undefined && document.getElementById("is_production_spect_exit"+k).value == 1) && document.getElementById("row_kontrol_exit"+k).value==1)//spect id ve spect name varsa vede ürtilen bir ürünse//vede 
					{
						//alert("<cf_get_lang no ="571.Üretilen Ürünler İçin Spec Seçmeniz Gerekmektedir">.(' + eval("document.form_basket.product_name_exit"+k).value + ')");
						alert('<cf_get_lang no ="571.Üretilen Ürünler İçin Spec Seçmeniz Gerekmektedir">.(' + document.getElementById("product_name_exit"+k).value + ')');
						return false;
					}
				}
			}
			row_count_outage_ = 0;
			for (var k=1;k<=row_count_outage;k++)
			{
				if(document.getElementById("row_kontrol_outage"+k).value==1)// fire ürün satırı olması için kontrol eklendi.
				{
					row_count_outage_ = row_count_outage_ + 1;
					<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
						if(check_lotno('form_basket'))//işlem kategorisinde lot no zorunlu olsun seçili ise
						{
							get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.getElementById("stock_id_outage"+k).value);
							if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
							{
								if(document.getElementById("lot_no_outage"+k).value == '')
								{
									alert(row_count_outage_+'. fire satırındaki '+ document.getElementById("product_name_outage"+k).value + ' ürünü için lot no takibi yapılmaktadır!');
									return false;
								}
							}
						}
					</cfif>
				}
			}
			<cfif get_fis.recordcount or get_fis_sarf.recordcount>
				<cfif isdefined("x_update_result") and x_update_result eq 1>
					if(document.getElementById("is_delstock").checked == false)
					{
						alert("Stok Fişleri Silinsin Seçeneğini Seçmeden Güncelleme Yapamazsınız !");
						return false;
					}
				</cfif>
				if(document.getElementById("is_delstock").checked == true)
				{
					if(! confirm("<cf_get_lang no='470.Fişleri Siliyorsunuz'>. <cf_get_lang no ='572.Yaptığınız Değişiklikler Stok ve İrsaliye Fişlerinin Silinmesine Neden Olacak Kayda Devam Etmek İstediğinizden Emin misiniz'> ! ")) return false;
				}
				for (var r=1;r<=row_count;r++)
				{
					document.getElementById("amount"+r).value = filterNum(document.getElementById("amount"+r).value,round_number);
					if(document.getElementById("amount2_"+r))
						document.getElementById("amount2_"+r).value = filterNum(document.getElementById("amount2_"+r).value,round_number);
					document.getElementById("cost_price"+r).value = filterNum(document.getElementById("cost_price"+r).value,round_number);
					document.getElementById("purchase_extra_cost"+r).value = filterNum(document.getElementById("purchase_extra_cost"+r).value,round_number);
					document.getElementById("purchase_extra_cost_system"+r).value = filterNum(document.getElementById("purchase_extra_cost_system"+r).value,round_number);
					if(document.getElementById("cost_price_2"+r) != undefined)
						document.getElementById("cost_price_2"+r).value = filterNum(document.getElementById("cost_price_2"+r).value,round_number);
					if(document.getElementById("cost_price_extra_2"+r) != undefined)
						document.getElementById("cost_price_extra_2"+r).value = filterNum(document.getElementById("cost_price_extra_2"+r).value,round_number);
					<cfif x_is_fire_product eq 1>
						document.getElementById("fire_amount_"+r).value = filterNum(document.getElementById("fire_amount_"+r).value,round_number);
					</cfif>
				}
				for (var k=1;k<=row_count_exit;k++)
				{
					document.getElementById("amount_exit"+k).value = filterNum(document.getElementById("amount_exit"+k).value,round_number);
					if(document.getElementById("amount_exit2_"+k))
						document.getElementById("amount_exit2_"+k).value = filterNum(document.getElementById("amount_exit2_"+k).value,round_number);
					document.getElementById("cost_price_exit"+k).value = filterNum(document.getElementById("cost_price_exit"+k).value,round_number);
	
					document.getElementById("purchase_extra_cost_exit"+k).value = filterNum(document.getElementById("purchase_extra_cost_exit"+k).value,round_number);
					//document.getElementById("purchase_extra_cost_system_exit"+k).value = filterNum(document.getElementById("purchase_extra_cost_system_exit"+k).value,8);
					if(document.getElementById("cost_price_exit_2"+k) != undefined)
						document.getElementById("cost_price_exit_2"+k).value = filterNum(document.getElementById("cost_price_exit_2"+k).value,round_number);
					if(document.getElementById("purchase_extra_cost_exit_2"+k) != undefined)
						document.getElementById("purchase_extra_cost_exit_2"+k).value = filterNum(document.getElementById("purchase_extra_cost_exit_2"+k).value,round_number);
				}
				for (var k=1;k<=row_count_outage;k++)
				{
					document.getElementById("amount_outage"+k).value = filterNum(document.getElementById("amount_outage"+k).value,round_number);
					if(document.getElementById("amount_outage2_"+k))
						document.getElementById("amount_outage2_"+k).value = filterNum(document.getElementById("amount_outage2_"+k).value,round_number);
					document.getElementById("cost_price_outage"+k).value = filterNum(document.getElementById("cost_price_outage"+k).value,round_number);
					if(document.getElementById("cost_price_outage_2"+k) != undefined)
						document.getElementById("cost_price_outage_2"+k).value = filterNum(document.getElementById("cost_price_outage_2"+k).value,round_number);
					if(document.getElementById("purchase_extra_cost_outage_2"+k) != undefined)
						document.getElementById("purchase_extra_cost_outage_2"+k).value = filterNum(document.getElementById("purchase_extra_cost_outage_2"+k).value,round_number);
					document.getElementById("purchase_extra_cost_outage"+k).value = filterNum(document.getElementById("purchase_extra_cost_outage"+k).value,round_number);
					//document.getElementById("purchase_extra_cost_system_outage"+k).value = filterNum(document.getElementById("purchase_extra_cost_system_outage"+k).value,8);
				}			
			<cfelse>
				for (var r=1;r<=row_count;r++)
				{
					document.getElementById("amount"+r).value = filterNum(document.getElementById("amount"+r).value,round_number);
					if(document.getElementById("amount2_"+r))
						document.getElementById("amount2_"+r).value = filterNum(document.getElementById("amount2_"+r).value,round_number);
					document.getElementById("cost_price"+r).value = filterNum(document.getElementById("cost_price"+r).value,round_number);
					document.getElementById("purchase_extra_cost"+r).value = filterNum(document.getElementById("purchase_extra_cost"+r).value,round_number);
					if(document.getElementById("cost_price_2"+r) != undefined)
						document.getElementById("cost_price_2"+r).value = filterNum(document.getElementById("cost_price_2"+r).value,round_number);
					if(document.getElementById("cost_price_extra_2"+r) != undefined)
						document.getElementById("cost_price_extra_2"+r).value = filterNum(document.getElementById("cost_price_extra_2"+r).value,round_number);
					<cfif x_is_fire_product eq 1>
						document.getElementById("fire_amount_"+r).value = filterNum(document.getElementById("fire_amount_"+r).value,round_number);
					</cfif>
				}
				for (var k=1;k<=row_count_exit;k++)
				{
					document.getElementById("amount_exit"+k).value = filterNum(document.getElementById("amount_exit"+k).value,round_number);
					if(document.getElementById("amount_exit2_"+k))
						document.getElementById("amount_exit2_"+k).value = filterNum(document.getElementById("amount_exit2_"+k).value,round_number);
					document.getElementById("cost_price_exit"+k).value = filterNum(document.getElementById("cost_price_exit"+k).value,round_number);
	
					document.getElementById("purchase_extra_cost_exit"+k).value = filterNum(document.getElementById("purchase_extra_cost_exit"+k).value,round_number);
					if(document.getElementById("cost_price_exit_2"+k) != undefined)
						document.getElementById("cost_price_exit_2"+k).value = filterNum(document.getElementById("cost_price_exit_2"+k).value,round_number);
					if(document.getElementById("purchase_extra_cost_exit_2"+k) != undefined)
						document.getElementById("purchase_extra_cost_exit_2"+k).value = filterNum(document.getElementById("purchase_extra_cost_exit_2"+k).value,round_number);
				}
				for (var k=1;k<=row_count_outage;k++)
				{
					document.getElementById("amount_outage"+k).value = filterNum(document.getElementById("amount_outage"+k).value,round_number);
					if(document.getElementById("amount_outage2_"+k))
						document.getElementById("amount_outage2_"+k).value = filterNum(document.getElementById("amount_outage2_"+k).value,round_number);
					document.getElementById("cost_price_outage"+k).value = filterNum(document.getElementById("cost_price_outage"+k).value,round_number);
					if(document.getElementById("cost_price_outage_2"+k) != undefined)
						document.getElementById("cost_price_outage_2"+k).value = filterNum(document.getElementById("cost_price_outage_2"+k).value,round_number);
					if(document.getElementById("purchase_extra_cost_outage_2"+k) != undefined)
						document.getElementById("purchase_extra_cost_outage_2"+k).value = filterNum(document.getElementById("purchase_extra_cost_outage_2"+k).value,round_number);
					document.getElementById("purchase_extra_cost_outage"+k).value = filterNum(document.getElementById("purchase_extra_cost_outage"+k).value,round_number);
				}			
			</cfif>
			return true;
		
		/*}
		else
			alert('Sonuç Girilmiş Üretim Emri Güncellenemez!');
			return false;*/
	}
	<!--- todo --->
	function zero_stock_control()
	{
		var hata = '';
		var lotno_hata = '';
		var stock_list = 0;
		var stock_type = 0;
		var is_update = 0;
		var round_number = document.getElementById('round_number').value;
		var stock_id_list='0';
		var stock_amount_list='0';
		var spec_id_list='0';
		var spec_amount_list='0';
		var main_spec_id_list='0';
		var main_spec_amount_list='0';
		var popup_spec_type=<cfoutput>#is_stock_control_with_spec#</cfoutput>;//specli mi normal stokmu
		//stok kontrollerinin hangi tarihe gore yapılacagi XML parametresi ile belirlenir
		var loc_id = form_basket.exit_location_id.value;
		var dep_id = form_basket.exit_department_id.value;
		zero_stock_control_date = <cfoutput>'#zero_stock_control_date#'</cfoutput>;
		<cfif isdefined('zero_stock_control_date') and zero_stock_control_date eq 1>
			var paper_date_kontrol = js_date(document.getElementById('finish_date').value.toString());	
		<cfelse>
			var paper_date_kontrol = js_date(document.getElementById('today_date_').value.toString());	
		</cfif>
		<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
			if(check_lotno('form_basket') != undefined && check_lotno('form_basket'))//işlem kategorisinde lot no zorunlu olsun seçili ise
			{
				for (var k=1;k<=row_count_exit;k++)
				{//sarf
					if(document.getElementById("row_kontrol_exit"+k).value==1)
					{
						varName = "lot_no_" + document.getElementById("stock_id_exit"+k).value + document.getElementById("lot_no_exit"+k).value.replace(/-/g, '_').replace(/\./g, '_');
						this[varName] = 0;
						stock_list=stock_list+';'+document.getElementById("stock_id_exit"+k).value+'§'+document.getElementById("lot_no_exit"+k).value+'§'+document.getElementById("amount_exit_"+k).value;
					}
				}
				for (var k=1;k<=row_count_outage;k++)

				{//fire
					if(document.getElementById("row_kontrol_outage"+k).value==1)
					{
						varName = "lot_no_" + document.getElementById("stock_id_outage"+k).value + document.getElementById("lot_no_outage"+k).value.replace(/-/g, '_').replace(/\./g, '_');
						this[varName] = 0;
						stock_list=stock_list+';'+document.getElementById("stock_id_outage"+k).value+'§'+document.getElementById("lot_no_outage"+k).value+'§'+document.getElementById("amount_outage"+k).value;
					}
				}
			}
			if(stock_list != undefined && stock_list != 0)
			{
				//var xx = '';
				var myarray = stock_list.split(';');
				for(var ss=1;ss<=myarray.length;ss++)
				{
					if(myarray[ss] != undefined && myarray[ss] != 0)
					{
						var stock_id = list_getat(myarray[ss],1,'§');
						var lot_no = list_getat(myarray[ss],2,'§');
						var stock_amount = list_getat(myarray[ss],3,'§');
						if(stock_id != '' )
						{
							get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,stock_id);
							if(get_prod_detail.IS_LOT_NO == 1 && get_prod_detail.IS_ZERO_STOCK == 0)//üründe lot no takibi yapılıyor seçili ise ve sifir stok ile calis secili degil ise
							{
								varName = "lot_no_" + stock_id + lot_no.replace(/-/g, '_').replace(/\./g, '_');
								var xxx = commaSplit(String(this[varName]),round_number);
								var yyy = stock_amount;
								this[varName] = parseFloat( filterNum(xxx,round_number) ) + parseFloat( filterNum(yyy,round_number) );
								if(dep_id=='' || dep_id==undefined || loc_id=='' || loc_id==undefined)
								{
									if(stock_type==undefined || stock_type==0)
									{
										if(is_update != 0)
											url_= '/V16/production_plan/cfc/get_prod_stock_detail.cfc?method=prdp_get_total_lot_no_stock&lot_no='+ encodeURIComponent(lot_no) +'&stock_id='+ stock_id +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol)+'&is_update='+ is_update;
										else
											url_= '/V16/production_plan/cfc/get_prod_stock_detail.cfc?method=prdp_get_total_lot_no_stock_2&lot_no='+ encodeURIComponent(lot_no) +'&stock_id='+ stock_id +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol);		
									}
									else
										url_= '/V16/production_plan/cfc/get_prod_stock_detail.cfc?method=prdp_get_total_lot_no_stock_3&lot_no='+ encodeURIComponent(lot_no) +'&stock_id='+ stock_id;
								}
								else
								{
									if(is_update != 0)
										url_= '/V16/production_plan/cfc/get_prod_stock_detail.cfc?method=prdp_get_total_lot_no_stock_4&lot_no='+ encodeURIComponent(lot_no) +'&stock_id='+ stock_id +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id +'&is_update='+ is_update;
									else
										url_= '/V16/production_plan/cfc/get_prod_stock_detail.cfc?method=prdp_get_total_lot_no_stock_5&lot_no='+ encodeURIComponent(lot_no) +'&stock_id='+ stock_id +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id;
								}
								//$('#reference_no').val(url_);
								$.ajax({
										url: url_,
										dataType: "text",
										cache:false,
										async: false,
										success: function(read_data) {
										data_ = jQuery.parseJSON(read_data);
										if(data_.DATA.length != 0)
										{
											$.each(data_.DATA,function(i){
												var PRODUCT_TOTAL_STOCK = data_.DATA[i][0];
												var STOCK_ID = data_.DATA[i][1];
												var STOCK_CODE = data_.DATA[i][2];
												var PRODUCT_NAME = data_.DATA[i][3];
												if(eval(varName) > PRODUCT_TOTAL_STOCK)
												{
													lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+')\n';
												}
											});
										}
										else if(data_.DATA.length == 0)
										{
											lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
										}
										else
										{
											if(parseFloat(eval(varName))< 0)
												lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
										}
									}
								});
							}
						}
					}
				}
			}
		</cfif>
		for (var k=1;k<=row_count_exit;k++)
		{//sarf
			if(document.getElementById('is_sevkiyat'+k).value != undefined && document.getElementById('is_sevkiyat'+k).value != 0) 
				var sb=document.getElementById('is_sevkiyat'+k).checked; 
			else 
				var sb=false;
			if(sb!=true)
			{
				if(document.getElementById("row_kontrol_exit"+k).value==1)
				{
					if(document.getElementById('spec_main_id_exit'+k).value != undefined && document.getElementById('spec_main_id_exit'+k).value != '')
					{
						var yer=list_find(spec_id_list,document.getElementById('spec_main_id_exit'+k).value,',');
						if(yer)
						{
							top_stock_miktar=parseFloat(list_getat(spec_amount_list,yer,','))+parseFloat(filterNum(document.getElementById("amount_exit_"+k).value));
							spec_amount_list=list_setat(spec_amount_list,yer,top_stock_miktar,',');
						}else{
							spec_id_list=spec_id_list+','+document.getElementById('spec_main_id_exit'+k).value;
							spec_amount_list=spec_amount_list+','+filterNum(document.getElementById("amount_exit_"+k).value);
						}
					}
					//artık uretilen urun ıcınde once kendi stok miktarı olmalı sonra specli stoğa bakılıyor
					var yer=list_find(stock_id_list,document.getElementById("stock_id_exit"+k).value,',');
					if(yer)
					{
						top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNum(document.getElementById("amount_exit_"+k).value));
						stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
					}
					else
					{
						stock_id_list=stock_id_list+','+document.getElementById("stock_id_exit"+k).value;
						stock_amount_list=stock_amount_list+','+filterNum(document.getElementById("amount_exit_"+k).value);
					}
				}
			}			
		}
		for (var k=1;k<=row_count_outage;k++)
		{//fire
			if(document.getElementById("row_kontrol_outage"+k).value==1)
			{
				if(document.getElementById('spec_main_id_outage'+k).value != undefined && document.getElementById('spec_main_id_outage'+k).value != '')
				{
					var yer=list_find(spec_id_list,document.getElementById('spec_main_id_outage'+k).value,',');
					if(yer)
					{
						top_stock_miktar=parseFloat(list_getat(spec_amount_list,yer,','))+parseFloat(filterNum(document.getElementById("amount_outage"+k).value));
						spec_amount_list=list_setat(spec_amount_list,yer,top_stock_miktar,',');
					}else{
						spec_id_list=spec_id_list+','+document.getElementById('spec_main_id_outage'+k).value;
						spec_amount_list=spec_amount_list+','+filterNum(document.getElementById("amount_outage"+k).value);
					}
				}
				//artık uretilen urun ıcınde once kendi stok miktarı olmalı sonra specli stoğa bakılıyor
				var yer=list_find(stock_id_list,document.getElementById("stock_id_outage"+k).value,',');
				if(yer)
				{
					top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNum(document.getElementById("amount_outage"+k).value));
					stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
				}
				else
				{
					stock_id_list=stock_id_list+','+document.getElementById("stock_id_outage"+k).value;
					stock_amount_list=stock_amount_list+','+filterNum(document.getElementById("amount_outage"+k).value);
				}
			}
		}
		main_spec_id_list = spec_id_list;
		main_spec_amount_list = spec_amount_list;
		get_spect='';
		var stock_id_count=list_len(stock_id_list,',');
		//stock kontrolleri
		if(stock_id_count >1)
		{
			if(dep_id=='' || dep_id==undefined || loc_id=='' || loc_id==undefined)//departman ve lokasyon yok ise
			{
				if(stock_type==undefined || stock_type==0)
				{
					var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + is_update + "*" + paper_date_kontrol;
					if(is_update != 0)
						var new_sql = 'prdp_get_total_stock';
					else
						var new_sql = 'prdp_get_total_stock_2';			
				}
				else
				{
					var listParam = stock_id_list + "*" + "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + "<cfoutput>#dsn_alias#</cfoutput>" + "*" + is_update + "*" + paper_date_kontrol;
					if(is_update != 0)
						var new_sql='prdp_get_total_stock_3';						
					else
						var new_sql='prdp_get_total_stock_4';
				}
			}
			else
			{
				var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + loc_id + "*" + dep_id + "*" + is_update  + "*" + paper_date_kontrol;
				if(is_update != 0)
					var new_sql = 'prdp_get_total_stock_5';
				else
					var new_sql = 'prdp_get_total_stock_6';
			}
			var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);
			if(get_total_stock.recordcount)
			{
				var query_stock_id_list='0';
				for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
				{
					query_stock_id_list=query_stock_id_list+','+get_total_stock.STOCK_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
					var yer=list_find(stock_id_list,get_total_stock.STOCK_ID[cnt],',');
					if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(stock_amount_list,yer,',')))
						hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+' (Stok Kodu: '+get_total_stock.STOCK_CODE[cnt]+')\n';
				}
			}
			var diff_stock_id='0';
			for(var lst_cnt=1;lst_cnt <= list_len(stock_id_list);lst_cnt++)
			{
				var stk_id=list_getat(stock_id_list,lst_cnt,',')
				if(query_stock_id_list==undefined || query_stock_id_list=='0' || list_find(query_stock_id_list,stk_id,',') == '0')
					diff_stock_id=diff_stock_id+','+stk_id;//kayıt gelmeyen urunler
			}
			if(list_len(diff_stock_id,',')>1)
			{//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden yazıldı
				var get_stock = wrk_safe_query('prdp_get_stock','dsn3',0,diff_stock_id);
				for(var cnt=0; cnt < get_stock.recordcount; cnt++)
					hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+' (Stok Kodu: '+get_stock.STOCK_CODE[cnt]+')\n';
			}
			get_total_stock='';
			//document.getElementById('product_name_exit1').value =new_sql;
		}
		//specli stok kontrolleri
		if(popup_spec_type==1 && list_len(main_spec_id_list,',') >1)//sepcli stok bakılacaksa 
		{
			if(dep_id=='' || dep_id==undefined || loc_id=='' || loc_id==undefined)
			{
				
				if(stock_type==undefined || stock_type==0)
				{
					var listParam2 = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + main_spec_id_list + "*" + is_update + "*" + paper_date_kontrol;
					if(is_update != 0)
						var new_sql = 'prdp_get_total_stock_7';
					else
						var new_sql = 'prdp_get_total_stock_8';
				}
				else
				{
					var listParam = main_spec_id_list + "*" + <cfoutput>#dsn3_alias#</cfoutput> + "*" + <cfoutput>#dsn_alias#</cfoutput> + "*" + is_update + "*" + paper_date_kontrol;
					if(is_update != 0)
					{
						var new_sql='prdp_get_total_stock_9';
					}
					else
					{					
						var new_sql='prdp_get_total_stock_10';
					}
				}
			}
			else
			{
				var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + main_spec_id_list + "*" + is_update + "*" + loc_id + "*" + dep_id + "*" + paper_date_kontrol;
				if(is_update != 0)
					var new_sql = 'prdp_get_total_stock_11';
				else
					var new_sql = 'prdp_get_total_stock_12';
			}
			var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);
			var query_spec_id_list='0';
			if(get_total_stock.recordcount)
			{
				for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
				{
					query_spec_id_list=query_spec_id_list+','+get_total_stock.SPECT_MAIN_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
					var yer=list_find(main_spec_id_list,get_total_stock.SPECT_MAIN_ID[cnt],',');
					//alert(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]);
					//alert(main_spec_amount_list);
					if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(main_spec_amount_list,yer,',')))
						hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+' (Stok Kodu: '+get_total_stock.STOCK_CODE[cnt]+') (main spec id: '+get_total_stock.SPECT_MAIN_ID[cnt]+')\n';
				}
			}
			var diff_spec_id='0';
			for(var lst_cnt=1;lst_cnt <= list_len(main_spec_id_list,',');lst_cnt++)
			{
				var spc_id=list_getat(main_spec_id_list,lst_cnt,',');
				if(!list_find(query_spec_id_list,spc_id,','))
					diff_spec_id=diff_spec_id+','+spc_id;//kayıt ge"lmeyen urunler
			}
			if(diff_spec_id!='0' && list_len(diff_spec_id,',')>1)
			{//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden else yazıldı
				var get_stock = wrk_safe_query('prdp_get_stock_2','dsn3',0,diff_spec_id);
				for(var cnt=0; cnt < get_stock.recordcount; cnt++)
					hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+' (Stok Kodu: '+get_stock.STOCK_CODE[cnt]+') (main spec id: '+get_stock.SPECT_MAIN_ID[cnt]+')\n';
			}
			get_total_stock='';
		}
	
		if(lotno_hata != '')
		{
			if(stock_type==undefined || stock_type==0)
				alert(lotno_hata+'\n\nYukarıdaki ürünlerde lot no bazında stok miktarı yeterli değildir. Lütfen seçtiğiniz depo-lokasyonundaki miktarları kontrol ediniz !');
			else
				alert(lotno_hata+'\n\nYukarıdaki ürünlerde lot no bazında satılabilir stok miktarı yeterli değildir. Lütfen miktarları kontrol ediniz !');
			lotno_hata='';
			return false;
		}
		else if(hata!='')
		{
			if(stock_type==undefined || stock_type==0)
				alert(hata+"\n\n<cf_get_lang no ='575.Yukarıdaki ürünlerde stok miktarı yeterli değildir Lütfen seçtiğiniz depo-lokasyonundaki miktarları kontrol ediniz'> ");
			else
				alert(hata+"\n\n<cf_get_lang no ='574.Yukarıdaki ürünlerde satılabilir stok miktarı yeterli değildir Lütfen miktarları kontrol ediniz'>");
			hata='';
			return false;
		}
		else
			return true;
	}
	<!--- todo --->	
	function kontrol_et()
	{
		if(!chk_period(document.getElementById("finish_date"), 'İşlem')) return false;
		if((document.getElementById("exit_department_id").value == "") || (document.getElementById("production_department_id").value == ""))
		{
			alert("<cf_get_lang no='468.Stok Fişi Oluşturuyorsunuz'> !. <cf_get_lang no='469.Lütfen Giriş ve Çıkış Depolarınız Seçiniz'> !");
			return false;
		}
		<cfif isdefined('x_quality_control') and x_quality_control eq 1>
			<cfoutput query="get_row_enter">
				var pr_order_id_ = #pr_order_id#;
				if(document.getElementById("is_success_type_"+pr_order_id_) != undefined && document.getElementById("is_success_type_"+pr_order_id_).value != 1)
				{
					alert("Kalite Kontrol İşlemi Tamamlanmadan Sevk Edemezsiniz!");
					return false;
				}
			</cfoutput>
		</cfif>
		var get_process = wrk_safe_query('prdp_get_process','dsn3',0,document.getElementById("process_cat").value);
		if(get_process.IS_ZERO_STOCK_CONTROL == 1)
		{
			if(!zero_stock_control()) return false; //todo
			//if(!zero_stock_control(form_basket.exit_department_id.value,form_basket.exit_location_id.value,0,'form_basket.record_num_exit','form_basket.product_id_exit','form_basket.stock_id_exit','form_basket.amount_exit_','form_basket.product_name_exit','form_basket.is_sevkiyat','form_basket.row_kontrol_exit','form_basket.spec_main_id_exit',0,'form_basket.lot_no_exit')) return false;
			//if(!zero_stock_control(form_basket.exit_department_id.value,form_basket.exit_location_id.value,0,'form_basket.record_num_outage','form_basket.product_id_outage','form_basket.stock_id_outage','form_basket.amount_outage','form_basket.product_name_outage',0,'form_basket.row_kontrol_outage','form_basket.spec_main_id_outage',0,'form_basket.lot_no_outage')) return false;
		}
		_sesion_control_();
		form_basket.action='<cfoutput>#request.self#</cfoutput>?fuseaction=prod.emptypopup_add_production_result_to_stock';
		form_basket.submit();
		return false;
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
		var round_number = document.getElementById('round_number').value;
		if(document.getElementById("fire_recordcount"))
			var fire_uzunluk=document.getElementById("fire_recordcount").value;
		else
			var fire_uzunluk=0;
		var sarf_uzunluk=parseInt(document.getElementById("sarf_recordcount").value);/*Toplam alt ürünlerin sayısı*/
		var toplam=parseFloat(<cfoutput>#GET_SUM_AMOUNT.SUM_AMOUNT#</cfoutput>)-filterNum(document.getElementById("amount_"+1).value,round_number);/*Şu ana kadar üretilen toplam*/
		var emir=parseFloat(<cfoutput>#GET_DETAIL.AMOUNT#</cfoutput>);
		var kalan=wrk_round(parseFloat(emir)-parseFloat(toplam),round_number);
		<cfif x_por_amount_lte_po eq 0>//<!--- XML ayarlarında üretim sonuçlarının toplamı üretim emrinin miktarından fazla olamaz denildi ise.... --->
			<cfif GET_DETAIL.IS_DEMONTAJ eq 0 and isdefined('GET_SUM_AMOUNT')>
				var toplam=parseFloat(<cfoutput>#GET_SUM_AMOUNT.SUM_AMOUNT#</cfoutput>)-filterNum(document.getElementById("amount_exit_"+1).value,round_number);/*Şu ana kadar üretilen toplam*/
				if(filterNum(document.getElementById("amount"+1).value,round_number)>(kalan))
					{
					alert("<cf_get_lang no ='573.Girilen Üretim Miktarı,Belirtilen Emir Miktarını Geçmektedir,Değerlerinizi Kontrol Ediniz Max Üretim Miktarı'>: "+kalan);
					document.getElementById("amount"+1).value = document.getElementById("amount_"+1).value;
					}
			<cfelseif GET_DETAIL.IS_DEMONTAJ eq 1 and isdefined('GET_SUM_AMOUNT')>
				var toplam=parseFloat(<cfoutput>#GET_SUM_AMOUNT.SUM_AMOUNT#</cfoutput>)-filterNum(document.getElementById("amount_"+1).value,round_number);/*Şu ana kadar üretilen toplam*/
				if(filterNum(document.getElementById("amount_exit"+1).value,round_number)>(kalan))
					{
					alert("<cf_get_lang no ='573.Girilen Üretim Miktarı,Belirtilen Emir Miktarını Geçmektedir,Değerlerinizi Kontrol Ediniz Max Üretim Miktarı'>: "+kalan);
					document.getElementById("amount_exit"+1).value = document.getElementById("amount_exit_"+1).value;
					}
			</cfif>
		</cfif>
		<cfif get_detail.is_demontaj eq 0>
			for (i=1;i<=sarf_uzunluk;i++)
			{
				if(document.getElementById("is_free_amount"+i).value == 0)
				{
					<cfif isdefined('GET_SUM_AMOUNT')>
						var x=parseInt(document.getElementById("amount"+1).value);
						if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
							{
								<cfif x_is_fire_product eq 1>
									var a=document.getElementById("amount_exit"+i).value=(parseFloat(filterNum(document.getElementById("amount_exit_"+i).value,round_number))/parseFloat(filterNum(document.getElementById("amount_"+1).value,round_number)))*(parseFloat(filterNum(document.getElementById("amount"+1).value,round_number))+parseFloat(filterNum(document.getElementById("fire_amount_"+1).value,round_number)));
								<cfelse>
									var a=document.getElementById("amount_exit"+i).value=(filterNum(document.getElementById("amount_exit_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(filterNum(document.getElementById("amount"+1).value,round_number));
								</cfif>
								var b=commaSplit(a,round_number);
								document.getElementById("amount_exit"+i).value=b;
							}
					<cfelseif not isdefined('GET_SUM_AMOUNT')>
						var x=parseInt(document.getElementById("amount"+1).value);
						if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
							{
								<cfif x_is_fire_product eq 1>
									var a=document.getElementById("amount_exit"+i).value=parseFloat((filterNum(document.getElementById("amount_exit_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(filterNum(document.getElementById("amount"+1).value,round_number))+parseFloat(filterNum(document.getElementById("fire_amount_"+1).value,round_number)));
								<cfelse>
									var a=document.getElementById("amount_exit"+i).value=(filterNum(document.getElementById("amount_exit_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(filterNum(document.getElementById("amount"+1).value,round_number));
								</cfif>
								var b=commaSplit(a,round_number);
								document.getElementById("amount_exit"+i).value=b;
								
							}	
					</cfif>
				}
			}
			if(fire_uzunluk>0)
			{
				for (i=1;i<=fire_uzunluk;i++)
				{	
					<cfif get_detail.is_demontaj eq 0 and isdefined('GET_SUM_AMOUNT')>
						var x=parseInt(document.getElementById("amount"+1).value);
						if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
							{
								if(parseFloat(document.getElementById("amount_"+1).value) != 0 && parseFloat(document.getElementById("amount"+1).value) != 0)
								{
									<cfif x_is_fire_product eq 1>
										var c=document.getElementById("amount_outage"+i).value=(filterNum(document.getElementById("amount_outage_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(parseFloat(filterNum(document.getElementById("amount"+1).value,round_number))+parseFloat(filterNum(document.getElementById("fire_amount_"+1).value,round_number)));
									<cfelse>
										var c=document.getElementById("amount_outage"+i).value=(filterNum(document.getElementById("amount_outage_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(filterNum(document.getElementById("amount"+1).value,round_number));
									</cfif>
								}
								else
								{
									var c=0;
								}
								var d=commaSplit(c,round_number);
								document.getElementById("amount_outage"+i).value=d;
							}
					<cfelseif get_detail.is_demontaj eq 0 and not isdefined('GET_SUM_AMOUNT')>
						var x=parseInt(document.getElementById("amount"+1).value);
						if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
							{
								if(parseFloat(document.getElementById("amount_"+1).value) != 0 && parseFloat(document.getElementById("amount"+1).value) != 0)
								{
									<cfif x_is_fire_product eq 1>
										var c=document.getElementById("amount_outage"+i).value=(filterNum(document.getElementById("amount_outage_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(parseFloat(filterNum(document.getElementById("amount"+1).value,round_number))+parseFloat(filterNum(document.getElementById("fire_amount_"+1).value,round_number)));
									<cfelse>
										var c=document.getElementById("amount_outage"+i).value=(filterNum(document.getElementById("amount_outage_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(filterNum(document.getElementById("amount"+1).value,round_number));
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
			<cfif GET_DETAIL.IS_DEMONTAJ eq 0>
				if(document.getElementById("spect_id_1").value!= document.getElementById("spect_id1").value)
				window.location.reload();
			<cfelse><!--- Eğer demontaj ise --->
				if(document.getElementById("spect_id_exit_1").value!= document.getElementById("spect_id_exit1").value)
				window.location.reload();
			</cfif>
		}
	function get_stok_spec_detail_ajax(product_id){
		goster(prod_stock_and_spec_detail_div);
		tempX = event.clientX + document.body.scrollLeft;
		tempY = event.clientY + document.body.scrollTop;
		document.getElementById('prod_stock_and_spec_detail_div').style.left = tempX+10;
		document.getElementById('prod_stock_and_spec_detail_div').style.top = tempY;
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=stock.popup_list_product_spects&from_production_result_detail=1&pid='+product_id+'</cfoutput>','prod_stock_and_spec_detail_div',1)	
	}
	function send_dep_loc(){	
		var station_id=document.getElementById('station_id').value;
		if(station_id!="")
		{
			var GET_STATION=wrk_safe_query('prdp_get_station','dsn3',0,station_id);
			var exit_dep_id=GET_STATION.EXIT_DEP_ID;
			var exit_loc_id=GET_STATION.EXIT_LOC_ID;
			var production_dep_id=GET_STATION.PRODUCTION_DEP_ID;
			var production_loc_id=GET_STATION.PRODUCTION_LOC_ID;
			var enter_dep_id=GET_STATION.ENTER_DEP_ID;
			var enter_loc_id=GET_STATION.ENTER_LOC_ID;
			if(exit_dep_id!="" && exit_loc_id!="" ){
					var exit_dep_query=workdata('get_department_id',exit_dep_id);
					var exit_loc_query=workdata('get_location_id',exit_loc_id,exit_dep_id);
					document.getElementById('exit_department_id').value=exit_dep_query.DEPARTMENT_ID;
					document.getElementById('exit_location_id').value=exit_loc_query.LOCATION_ID;
					document.getElementById('exit_department').value=exit_dep_query.DEPARTMENT_HEAD +'-' + exit_loc_query.COMMENT;
				}
			else{
					document.getElementById('exit_department_id').value="";
					document.getElementById('exit_location_id').value="";
					document.getElementById('exit_department').value="";
				}
		  if(production_dep_id!="" && production_loc_id!="" ){
					var production_dep_query=workdata('get_department_id',production_dep_id);
					var production_loc_query=workdata('get_location_id',production_loc_id,production_dep_id);
					document.getElementById('production_department_id').value=production_dep_query.DEPARTMENT_ID;
					document.getElementById('production_location_id').value=production_loc_query.LOCATION_ID;
					document.getElementById('production_department').value=production_dep_query.DEPARTMENT_HEAD +'-'+ production_loc_query.COMMENT;
				}
			else{
					document.getElementById('production_department_id').value="";
					document.getElementById('production_location_id').value="";
					document.getElementById('production_department').value="";
				}
			if(enter_dep_id!="" && enter_loc_id!="" ){
					var enter_dep_query=workdata('get_department_id',enter_dep_id);
					var enter_loc_query=workdata('get_location_id',enter_loc_id,enter_dep_id);
					document.getElementById('enter_department_id').value=enter_dep_query.DEPARTMENT_ID;
					document.getElementById('enter_location_id').value=enter_loc_query.LOCATION_ID;
					document.getElementById('enter_department').value=enter_dep_query.DEPARTMENT_HEAD +'-' + enter_loc_query.COMMENT;
				}
			else{
					document.getElementById('enter_department_id').value="";
					document.getElementById('enter_location_id').value="";
					document.getElementById('enter_department').value="";
				}
		}
		else
		return false;
	} 
</script>

</cfif>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.list_results';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'production_plan/display/list_prod_order_results.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.list_results';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'production_plan/form/add_prod_order_result.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'production_plan/query/add_prod_order_result.cfm';
	WOStruct['#attributes.fuseaction#']['add']['parameters'] = 'is_changed_spec_main=##is_changed_spec_main##';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.list_results&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('order_result','order_result_bask')";
	
	WOStruct['#attributes.fuseaction#']['ordersDetail'] = structNew();
	WOStruct['#attributes.fuseaction#']['ordersDetail']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['ordersDetail']['fuseaction'] = 'prod.list_results';
	WOStruct['#attributes.fuseaction#']['ordersDetail']['filePath'] = 'production_plan/query/locat_production_orders_detail.cfm';
	WOStruct['#attributes.fuseaction#']['ordersDetail']['queryPath'] = 'production_plan/query/locat_production_orders_detail.cfm';
	WOStruct['#attributes.fuseaction#']['ordersDetail']['nextEvent'] = 'prod.list_results&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'prod.list_results';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'production_plan/form/upd_prod_order_result.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'production_plan/query/upd_prod_order_result.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'prod.list_results&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'pr_order_id=##pr_order_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##pr_order_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('order_result','order_result_bask')";	
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'prod.emptypopup_upd_prod_order_result_act&is_changed_spec_main=#is_changed_spec_main#&event=del';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'production_plan/query/upd_prod_order_result.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'production_plan/query/upd_prod_order_result.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'prod.list_results';
		WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'process_cat&del_pr_order_id&p_order_id&old_process_type&production_result_no&is_demontaj&pr_order_id&production_order_no&process_stage';
	}
	
	 if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = 'Duraklamalar';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=prod.popup_add_prod_pause&Product_cat_List=#Product_cat_List#&action_id=#attributes.pr_order_id#&action_date=#get_detail.finish_date#','list')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = 'Zaman Harcaması Ekle';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=service.popup_add_timecost&p_order_result_id=#attributes.pr_order_id#&is_p_order_result=1','page_horizantal')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = 'Fiziki Varlıklar';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=prod.popup_add_prod_result_asset&id=#attributes.pr_order_id#','list')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = 'Uyarılar';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=prod.upd_prod_order_result&action_name=p_order_id&action_id=#attributes.p_order_id#&action_name2=pr_order_id&action_id2=#attributes.pr_order_id#&relation_papers_type=P_ORDER_ID','list')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = 'Üretim Emri';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=prod.order&event=updorder&upd=#get_detail.p_order_id#')";

		if (get_module_user(22)){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = 'Mahsup Fişi';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.pr_order_id#&process_cat='+form_basket.old_process_type.value,'page','upd_prod_order_result')";
		}
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();	
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.pr_order_id#&iid=#attributes.p_order_id#&print_type=280','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'productionOrdersResultsController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'PRODUCTION_ORDER_RESULTS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-process_cat','item-production_order_no','item-order_no','item-start_date','item-finish_date','item-station_name']";
	
</cfscript>