<cfsetting showdebugoutput="no">
<cfparam  name="attributes.seperator_order_id" default="1">
<style>
    .seperator  {
        list-style-type: none;
        background-color: #f9f9f9;
        padding-left: inherit;
    }
    .seperator{flex:1;flex-direction:column;}
    .seperator a {
        font-size: 18px;
        color: #44b6ae!important;
    }
    .portBox .portHeadLight{
        margin:0 28px!important;
        padding-top:20px;
        border-bottom:0px;
    }
    .ui-scroll::-webkit-scrollbar-thumb {
        background-color: #FFCC66;
        border-radius: 5px;
    }
    .seperator a i{font-size:15px!important;color:#44b6ae!important;}
    .seperator a:hover i{color:#44b6ae!important;}
    .seperator a.active i{transform:rotate(90deg);transition:.4s;}
    .ui-form-list-btn {
        display: flex;
        flex-wrap: wrap;
        flex-direction: row;
        justify-content: center !important;
        align-items: center;
        margin-top: 5px;
        padding-left: 0px !important;
    }
    .scroll ~ .ui-form-list-btn, .ui-scroll ~ .ui-form-list-btn{
        border-top: 1px solid #bbb!important;
    }
    .ajax_list > thead tr th {
        font-size: 18px;
    }
    .spect > input{background-color:#ffc9ca;border:0;}
    .spect > select{background-color:#cae8f2;border:0;}
    .tablesorter-header-inner {
        font-size: 20px;
    }
    .scrollContent::-webkit-scrollbar-thumb {
        background-color: #FFCC66;
        border-radius: 10px;
    }
    .scrollContent::-webkit-scrollbar {
        width: 15px;
        height: 8px;
    }
    .portHeadLightMenu ul li a i {
        font-size: 20px;
    }
    .catalystClose {
        font-size: 35px!important;
        padding: 0px;
        margin-top: -6px;
        font-weight: 300;
        line-height: 11px;
    }
    .ui-wrk-btn-extra {
        background-color: red!important;
        color: white!important;
        transition: .4s;
    }
    .ui-wrk-btn-extra_blue{
        background-color: #007bff!important;
        color: white!important;
    }
    .inputs_m input{
        background-color:#ffe0ad;
        border: 0px solid;
    }
    .inputs_m2 input{
        background-color:#a8daf0;
        border: 0px solid;   
    }
    .maxi .portHeadLightMenu > ul > li > a{
        color:#FF9B05!important;
    }
    .maxi .portHeadLightMenu > ul > li > a:hover{
        color:#FF9B05!important;
        background-color:white!important;
    }
    .maxi .portHeadLight .portHeadLightTitle span a{
        color:#44b6ae;
        letter-spacing:0px!important;
        font-family:'Roboto', sans-serif !important;
    }
    .ui-draggable-box .ui-scroll table thead tr th{
        border-bottom:white!important;
    }
    .ui-form-list .form-group select{
        height:42px;
    }
</style>
    <cfinclude template="../../workdata/get_main_spect_id.cfm">
    <cfquery name="get_scrap_locations" datasource="#dsn#"><!--- Hurda depo ve lokasyonlar çekiliyor! GERÇEK STOK ONA GÖRE BELLİ OLACAK!--->
        SELECT
            SL.LOCATION_ID,
            SL.DEPARTMENT_ID
        FROM 
            STOCKS_LOCATION SL,
            DEPARTMENT D
        WHERE
            SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND SL.IS_SCRAP = 1
    </cfquery>
    <cfif (isdefined("attributes.p_order_id") and len(attributes.p_order_id))>
        <cfquery name="GET_DET_PO" datasource="#dsn3#">
            SELECT 
                PO.* ,
                S.STOCK_ID,
                S.PRODUCT_ID,
                P.PRODUCT_ID,
                'S' TREE_TYPE,
                P.PRODUCT_NAME,
                PO.SPEC_MAIN_ID,
		        PO.SPECT_VAR_ID,
                PU.MAIN_UNIT,
                p.SHELF_LIFE,
                P_I.PATH_SERVER_ID, 
			    P_I.PATH,
                PO.STOCK_ID,
                ISNULL(PO.SPEC_MAIN_ID,0) AS SPEC_MAIN_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.PRODUCT_NAME,
                S.TAX,
                PO.IS_STAGE,
                PU.PRODUCT_UNIT_ID
            FROM
                PRODUCTION_ORDERS PO
                LEFT JOIN STOCKS S ON S.STOCK_ID = PO.STOCK_ID  
                LEFT JOIN PRODUCT P ON  P.PRODUCT_ID = S.PRODUCT_ID
                LEFT JOIN #DSN1#.PRODUCT_IMAGES P_I ON  P_I.PRODUCT_ID = S.PRODUCT_ID,
                PRODUCT_UNIT PU
             WHERE 
                PO.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#"> and
                PU.PRODUCT_UNIT_STATUS = 1 AND
                PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID
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
            STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_DET_PO.STATION_ID#">
        </cfquery>
    </cfif>
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
        PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
        STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
    </cfquery>
    </cfif>
    <cfif get_scrap_locations.recordcount>
        <cfsavecontent variable="scrap_location">
            <cfoutput>
            <cfloop query="get_scrap_locations">
              AND NOT ( STORE_LOCATION = #LOCATION_ID# AND STORE = #DEPARTMENT_ID#)
            </cfloop>
            </cfoutput>
        </cfsavecontent>
    </cfif>
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
    <cf_box  title="#getLang('','Üretim sonucu','29651')#" box_style="maxi" popup_box="1" settings="0" closable="1" resize="0"  collapsable="0" >
       
        <cfform name="production_" action="#request.self#?fuseaction=prod.emptypopup_add_prod_order_result_act&from_order_operator=1&list_type=#attributes.list_type#&part=#attributes.part#" enctype="multipart/form-data" method="post">
          
    <div class="op_item_upside" style="display:flex;align-items:center;margin-top:-30px;">
        <div class="op_item_barcode" style="margin:5px;">
            <!--- <img src="/images/tamir_k2.jpg" border="0" height="70px" width="70px"> --->
            <cfoutput><cf_workcube_barcode show="1" type="qrcode" width="100" height="100" value="#GET_DET_PO.P_ORDER_NO#/#GET_DET_PO.lot_no#"></cfoutput>
        </div>
        <div class="op_item_product_lot" style="font-weight:bold;font-size:16px;">
            <cfoutput>#GET_DET_PO.P_ORDER_NO# / <cf_get_lang dictionary_id='38869.Lot'> : #GET_DET_PO.lot_no#</cfoutput>	
        </div>

        
        <div class="op_item_upside_right" style="margin-left:auto;display:flex;align-items: center;">
            <div class="op_item_upside_text" style="margin-right:5px;font-weight:bold;font-size:16px">
                <cfoutput><p>#GET_DET_PO.PRODUCT_NAME#</p>
                <p>#GET_DET_PO.QUANTITY# #GET_DET_PO.MAIN_UNIT#</p></cfoutput>
            </div>
            
              <cfoutput>
            <cfif isdefined("GET_DET_PO.PATH") and len(GET_DET_PO.PATH)>
                <img src="documents/product/#GET_DET_PO.PATH#" border="0" height="70px" width="70px" style="border-radius:50%;">
            <cfelse>
                <img src="/images/tamir_k2.jpg" border="0" height="70px" width="70px" style="border-radius:50%;">
            </cfif> </cfoutput>
        </div>
        
    </div>
    <cfsavecontent  variable="variable_1"><cf_get_lang dictionary_id="38110.Girdiler/Sarflar"></cfsavecontent>
    <cf_seperator title="#variable_1#" id="girdi">
    <cf_flat_list id="girdi">
        <thead>
            <tr>
                <th></th>
                <th><cf_get_lang dictionary_id='57657.Ürün'>-<cf_get_lang dictionary_id='444.Malzeme'></th>
                <th width="150px"  style="min-width:300px;"><cf_get_lang dictionary_id='34299.Spec'>/<cf_get_lang dictionary_id='45880.Etiket'></th>
                <th style="min-width:250px !important;text-align:right;" width="150px"><cf_get_lang dictionary_id='57635.Miktar'></th>
                <th style="min-width:250px !important;text-align:right;" width="150px">2.<cf_get_lang dictionary_id='57635.Miktar'></th>
            </tr>
        </thead>
        <tbody id="status" name="status">
                <cfloop query="GET_SUB_PRODUCTS">
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
                    <cfoutput>
                        <input type="hidden" name="row_kontrol_exit#currentrow#" id="row_kontrol_exit#currentrow#" value="1">
                        <input type="hidden" name="expiration_date_exit#currentrow#" id="expiration_date_exit#currentrow#" value="">
                        <input type="hidden" name="tree_type_exit_#currentrow#" id="tree_type_exit_#currentrow#" value="#TREE_TYPE#">
                        <input type="hidden" name="spec_main_id_exit#currentrow#" id="spec_main_id_exit#currentrow#" value="">
                        <input type="hidden" name="spect_id_exit#currentrow#" id="spect_id_exit#currentrow#" value="">
                        <input type="hidden" name="product_id_exit#currentrow#" id="product_id_exit#currentrow#" value="#product_id#">
                        <input type="hidden" name="stock_id_exit#currentrow#" id="stock_id_exit#currentrow#" value="#stock_id#">
                        <input type="hidden" name="lot_no_exit#currentrow#" id="lot_no_exit#currentrow#" value="#lot_no#">
                        <input type="hidden" name="unit_id_exit#currentrow#" id="unit_id_exit#currentrow#" value="#product_unit_id#">
                        <input type="hidden" name="serial_no_exit#currentrow#" id="serial_no_exit#currentrow#">
                        <input type="hidden" name="product_name_exit#currentrow#" id="product_name_exit#currentrow#" value="#product_name# #property#">
                        <input type="hidden" name="unit_exit#currentrow#" id="unit_exit#currentrow#" value="#main_unit#">
                        <input type="hidden" name="is_production_spect_exit#currentrow#" id="is_production_spect_exit#currentrow#" value="<cfif isdefined('IS_PRODUCTION') and IS_PRODUCTION eq 1>1<cfelse>0</cfif>">
                        <input type="hidden" name="cost_id_exit#currentrow#" id="cost_id_exit#currentrow#" value="#cost_id#">                        
                        <input type="hidden" name="kdv_amount_exit#currentrow#" id="kdv_amount_exit#currentrow#" value="#tax#">
                        <input type="hidden" name="cost_price_system_exit#currentrow#" id="cost_price_system_exit#currentrow#" value="#cost_price_system#">
                        <input type="hidden" name="purchase_extra_cost_system_exit#currentrow#" id="purchase_extra_cost_system_exit#currentrow#" value="#purchase_extra_cost_system#">
                        <input type="hidden" name="purchase_extra_cost_exit#currentrow#" id="purchase_extra_cost_exit#currentrow#" value="#PURCHASE_EXTRA_COST#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox">
                        <input type="hidden" name="money_system_exit#currentrow#" id="money_system_exit#currentrow#" value="#cost_price_system_money#">
                        <input type="hidden" name="cost_price_exit#currentrow#" id="cost_price_exit#currentrow#" value="">									
                        <input type="hidden" name="total_cost_price_exit#currentrow#" id="total_cost_price_exit#currentrow#" value="#cost_price+purchase_extra_cost#">
                        <input type="hidden" name="money_exit#currentrow#" id="money_exit#currentrow#" value="#cost_price_money#">
                        <input type="hidden" name="cost_price_exit_2#currentrow#" id="cost_price_exit_2#currentrow#" value="#cost_price_2#">
                        <input type="hidden" name="total_cost_price_exit_2#currentrow#" id="total_cost_price_exit_2#currentrow#" value="#cost_price_2+purchase_extra_cost_system_2*amount#">
                        <input type="hidden" name="purchase_extra_cost_exit_2#currentrow#" id="purchase_extra_cost_exit_2#currentrow#" value="#purchase_extra_cost_system_2#">
                        <input type="hidden" name="money_exit_2#currentrow#" id="money_exit_2#currentrow#" value="#cost_price_money_2#">
                        <cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN3#">
                            SELECT 					
                               *
                            FROM 
                                PRODUCT_IMAGES 
                            WHERE 
                                PRODUCT_ID = #PRODUCT_ID# 
                        </cfquery>
                        <tr>
                            <td width="80">
                                <cfif len(GET_PRODUCT_IMAGES.PATH)>
                                    <img src="documents/product/#GET_PRODUCT_IMAGES.PATH#" width="70" height="70">
                                <cfelse>
                                    <img src="../images/production/no-image.png" width="70" height="70">
                                </cfif>
                            </td>
                            <td>
                                #STOCK_CODE#<br/>
                                #PRODUCT_NAME#
                            </td>
                            <td>
                                <div class="colorful_td spect" style="background-color:##ffc9ca;padding: 5px;display: flex;">
                                    <cfif get_det_po.is_demontaj eq 1 and ( len(get_det_po.spect_var_id) or len(get_det_po.spec_main_id) ) ><!--- demontaj ve spec varsa sarfta spec olur--->
                                        <cfquery name="GET_SPECT" datasource="#dsn3#">
                                            <cfif len(get_det_po.spect_var_id)>
                                                SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = #get_det_po.spect_var_id#
                                            <cfelse>
                                                SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = #get_det_po.spec_main_id#
                                            </cfif>
                                        </cfquery>
                                        <input type="hidden" name="spect_id_exit_#currentrow#" id="spect_id_exit_#currentrow#" value="#get_det_po.spect_var_id#">
                                        <input type="text" name="spec_main_id_exit#currentrow#" id="spec_main_id_exit#currentrow#" value="#get_det_po.spec_main_id#" readonly style="width:40px;">
                                        <input type="text" name="spect_id_exit#currentrow#" id="spect_id_exit#currentrow#" value="#get_det_po.spect_var_id#" readonly style="width:40px;">
                                        <input type="text" name="spect_name_exit#currentrow#" id="spect_name_exit#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:150px;">
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
                                        <input type="text" name="spec_main_id_exit#currentrow#" id="spec_main_id_exit#currentrow#" value="<cfif isdefined('stock#STOCK_ID#_spec_main_id')>#Evaluate('stock#STOCK_ID#_spec_main_id')#</cfif>" readonly style="width:40px;">
                                        <input type="text" name="spect_id_exit#currentrow#" id="spect_id_exit#currentrow#" value="" readonly style="width:40px;"><!--- <cfif isdefined('stock#STOCK_ID#_spect_id')>#Evaluate('stock#STOCK_ID#_spect_id')#<cfelseif isdefined('spect_id_exit')>#spect_id_exit#</cfif> --->
                                        <input type="text" name="spect_name_exit#currentrow#" id="spect_name_exit#currentrow#" value="#_spec_main_name__#" readonly style="width:150px;"><!--- <cfif isdefined('stock#STOCK_ID#_spect_name')>#Evaluate('stock#STOCK_ID#_spect_name')#<cfelseif isdefined('spect_name_exit')>#spect_name_exit#</cfif> --->
                                    </cfif>
                                <a href="javascript://" onClick="pencere_ac_spect('#currentrow#',2);">
                                    <img src="/images/tamir_k2.jpg" border="0" height="30px" width="30px" style="margin-left:auto;"></a>
                                </div>
                            </td>
                            <td class="inputs_m"> 
                                <div class="colorful_td" style="display: flex;">
                                    <div class="colorful_td_first text-right" style="background-color:##ffe0ad;padding: 12px;">
                                        <cfinput type="text" style="text-align:right;" onclick="this.select();" name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat(amount,8)#">  
                                    </div>
                                    <div class="colorful_td_scnd" style="background-color:##fff2d9;padding: 12px;width: 50%;">
                                       
                                            #MAIN_UNIT#
                                    
                                    </div>									
                                </div>
                            </td>
                           
                            <td class="inputs_m2">
                                    <div class="colorful_td" style="display: flex;">
                                        <div class="colorful_td_first text-right" style="background-color:##a8daf0;padding: 12px;">
                                            <cfinput type="text" style="text-align:right;" onclick="this.select();" name="amount_exit2_#currentrow#" id="amount_exit2_#currentrow#">  
                                        </div>
                                        <div class="colorful_td_scnd spect" style="background-color:##cae8f2;padding: 12px;width: 50%;">
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
                                        </div>									
                                    </div>
                                </td>
                            </td>
                            
                        </tr>
                    </cfoutput>
                </cfloop>
            </tbody>
        </cf_flat_list>
        <cfsavecontent  variable="variable_3"><cf_get_lang dictionary_id="29471.Fireler"></cfsavecontent>
            <cf_seperator title="#variable_3#" id="girdi3">
            <cf_flat_list id="girdi3">
                <thead>
                    <tr>
                        <th></th>
                        <th><cf_get_lang dictionary_id='57657.Ürün'>-<cf_get_lang dictionary_id='444.Malzeme'></th>
                        <th width="150px" style="min-width:300px;"><cf_get_lang dictionary_id='34299.Spec'>/<cf_get_lang dictionary_id='45880.Etiket'></th>
                        <th style="min-width:250px !important;text-align:right;" width="150px"><cf_get_lang dictionary_id='57635.Miktar'></th>
                        <th style="min-width:250px !important;text-align:right;" width="150px">2.<cf_get_lang dictionary_id='57635.Miktar'></th>
                    </tr>
                </thead>
                <tbody id="status" name="status">
            <cfset kontrol_stock_amount = 1>

            <!--- <cfset attributes.stock_list_count = Listlen(stock_and_spect_list)> --->
            <cfoutput query="GET_SUB_PRODUCTS_FIRE">
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
                <cfoutput>
                    <input type="hidden" name="row_kontrol_outage#currentrow#" id="row_kontrol_outage#currentrow#" value="1">
                    <input type="hidden" name="expiration_date_outage#currentrow#" id="expiration_date_outage#currentrow#" value="">
                    <input type="hidden" name="product_id_outage#currentrow#" id="product_id_outage#currentrow#"value="#product_id#">
                    <input type="hidden" name="stock_id_outage#currentrow#" id="stock_id_outage#currentrow#" value="#stock_id#">
                    <input type="hidden" name="lot_no_outage#currentrow#" id="lot_no_outage#currentrow#" value="#lot_no#">
                    <input type="hidden" name="unit_id_outage#currentrow#" id="unit_id_outage#currentrow#" value="#product_unit_id#">
                    <input type="hidden" name="serial_no_outage#currentrow#" id="serial_no_outage#currentrow#">
                    <input type="hidden" name="unit_outage#currentrow#" id="unit_outage#currentrow#" value="#main_unit#">
                    <input type="hidden" name="product_name_outage#currentrow#" id="product_name_outage#currentrow#" value="#product_name# #property#">
                    <input type="hidden" name="cost_id_outage#currentrow#" id="cost_id_outage#currentrow#" value="#GET_PRODUCT_FIRE.product_cost_id#">
                    <input type="hidden" name="line_number_outage_#currentrow#" id="line_number_outage_#currentrow#" value="#line_number#">
                    <input type="hidden" name="wrk_row_id_outage_#currentrow#" id="wrk_row_id_outage_#currentrow#" value="#wrk_row_id#">
                    <input type="hidden" name="product_cost_outage#currentrow#" id="product_cost_outage#currentrow#" value="#product_cost#">
                    <input type="hidden" name="product_cost_money_outage#currentrow#" id="product_cost_money_outage#currentrow#" value="#product_cost_money#">
                    <input type="hidden" name="kdv_amount_outage#currentrow#" id="kdv_amount_outage#currentrow#" value="#tax#">
                    <input type="hidden" name="cost_price_system_outage#currentrow#" id="cost_price_system_outage#currentrow#" value="#cost_price_system#">
                    <input type="hidden" name="purchase_extra_cost_system_outage#currentrow#" id="purchase_extra_cost_system_outage#currentrow#" value="#purchase_extra_cost_system#">
                    <input type="hidden" name="money_system_outage#currentrow#" id="money_system_outage#currentrow#" value="#cost_price_system_money#">
                    <input type="hidden" name="purchase_extra_cost_outage#currentrow#" id="purchase_extra_cost_outage#currentrow#" value="#PURCHASE_EXTRA_COST#">
                    <input type="hidden" name="cost_price_outage_2#currentrow#" id="cost_price_outage_2#currentrow#" value="#cost_price_2#">
                    <input type="hidden" name="purchase_extra_cost_outage_2#currentrow#" id="purchase_extra_cost_outage_2#currentrow#" value="#PURCHASE_EXTRA_COST_SYSTEM_2#">
                    <input type="hidden" name="money_outage_2#currentrow#" id="money_outage_2#currentrow#" value="#cost_price_money_2#">
                    <input type="hidden" name="cost_price_outage#currentrow#" id="cost_price_outage#currentrow#" value="#cost_price#">
                    <input type="hidden" name="total_cost_price_outage#currentrow#" id="total_cost_price_outage#currentrow#" value="#cost_price+purchase_extra_cost*maliyet_miktarı#">
                    <input type="hidden" name="money_outage#currentrow#" id="money_outage#currentrow#" value="#cost_price_money#">
                    <input type="hidden" name="total_cost_price_outage_2#currentrow#" id="total_cost_price_outage_2#currentrow#" value="#cost_price_2+purchase_extra_cost_system_2*maliyet_miktarı#">
                    <cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN3#">
                        SELECT 					
                           *
                        FROM 
                            PRODUCT_IMAGES 
                        WHERE 
                            PRODUCT_ID = #PRODUCT_ID#
                    </cfquery>
                    <tr>
                        <td width="80">
                            <cfif len(GET_PRODUCT_IMAGES.PATH)>
                                <img src="documents/product/#GET_PRODUCT_IMAGES.PATH#" width="70" height="70">
                            <cfelse>
                                <img src="../images/production/no-image.png" width="70" height="70">
                            </cfif>
                        </td>
                        <td>
                            #STOCK_CODE#<br/>
                            #PRODUCT_NAME#
                        </td>
                        <td><div class="colorful_td spect" style="background-color:##ffc9ca;padding: 5px;display: flex;">
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
                                    <input type="text" name="spec_main_id_outage#currentrow#" id="spec_main_id_outage#currentrow#" value="<cfif isdefined('stock#STOCK_ID#_spec_main_id')>#Evaluate('stock#STOCK_ID#_spec_main_id')#</cfif>" readonly style="width:40px;">
                                    <input type="text" name="spect_id_outage#currentrow#" id="spect_id_outage#currentrow#" value="" readonly style="width:40px;"><!--- <cfif isdefined('stock#STOCK_ID#_spect_id')>#Evaluate('stock#STOCK_ID#_spect_id')#<cfelseif isdefined('spect_id_exit')>#spect_id_exit#</cfif> --->
                                    <input type="text" name="spect_name_outage#currentrow#" id="spect_name_outage#currentrow#" value="#_spec_main_name__#" readonly style="width:150px;"><!--- <cfif isdefined('stock#STOCK_ID#_spect_name')>#Evaluate('stock#STOCK_ID#_spect_name')#<cfelseif isdefined('spect_name_exit')>#spect_name_exit#</cfif> --->
                                    <a href="javascript://" onClick="pencere_ac_spect('#currentrow#',3);">
                            <img src="/images/tamir_k2.jpg" border="0" height="30px" width="30px" style="margin-left:auto;"></a></div></td>
                        <td class="inputs_m"> 
                            <div class="colorful_td" style="display: flex;">
                                <div class="colorful_td_first text-right" style="background-color:##ffe0ad;padding: 12px;">
                                    <cfinput style="text-align:right;" type="text" onclick="this.select();" name="amount_outage#currentrow#" id="amount_outage#currentrow#" value="#TlFormat(amount,8)#">  
                                </div>
                                <div class="colorful_td_scnd" style="background-color:##fff2d9;padding: 12px;width: 50%;">
                                       #MAIN_UNIT#
                                </div>									
                            </div>
                        </td>
                       
                        <td class="inputs_m2">
                                <div class="colorful_td" style="display: flex;">
                                    <div class="colorful_td_first text-right" style="background-color:##a8daf0;padding: 12px;">
                                        <cfinput  style="text-align:right;" type="text" onclick="this.select();" name="amount_outage2_#currentrow#" id="amount_outage2_#currentrow#" >  
                                    </div>
                                    <div class="colorful_td_scnd spect" style="background-color:##cae8f2;padding: 12px;width: 50%;">
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
                                    </div>									
                                </div>
                            </td>
                        </td>
                        
                    </tr>
                </cfoutput>
            </cfoutput>
        </tbody>
    
    </cf_flat_list>
        <cfsavecontent  variable="variable_1"><cf_get_lang dictionary_id='36476.Çıktılar'>/<cf_get_lang dictionary_id='63815.Üretilenler'></cfsavecontent>
            <cf_seperator title="#variable_1#" id="girdi2">
        <cf_flat_list id="girdi2">
            <thead>
                <tr>
                    <th></th>
                    <th><cf_get_lang dictionary_id='57657.Ürün'>-<cf_get_lang dictionary_id='444.Malzeme'></th>
                    <th width="150px"  style="min-width:300px;"><cf_get_lang dictionary_id='34299.Spec'>/<cf_get_lang dictionary_id='45880.Etiket'></th>
                    <th style="min-width:250px !important;text-align:right;" width="150px"><cf_get_lang dictionary_id='57635.Miktar'></th>
                    <th style="min-width:250px !important;text-align:right;" width="150px">2.<cf_get_lang dictionary_id='57635.Miktar'></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="GET_DET_PO">
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
                    <cfinput type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                    <input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#stock_id#">
                    <input type="hidden" name="tree_type_#currentrow#" id="tree_type_#currentrow#" value="#tree_type#">
                    <input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
                    <input type="hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="#product_unit_id#">
                    <input type="hidden" name="unit#currentrow#" id="unit#currentrow#" value="#main_unit#">
                    <input type="hidden" name="kdv_amount#currentrow#" id="kdv_amount#currentrow#" value="#tax#">
                    <input type="hidden" name="product_name#currentrow#" id="product_name#currentrow#" value="#product_name# #property#">
                    <input type="hidden" name="cost_id#currentrow#" id="cost_id#currentrow#" value="#get_product.product_cost_id#">
                    <input type="hidden" name="product_cost#currentrow#" id="product_cost#currentrow#" value="#product_cost#">
                    <input type="hidden" name="product_cost_money#currentrow#" id="product_cost_money#currentrow#" value="#product_cost_money#">
                    <input type="hidden" name="cost_price_system#currentrow#" id="cost_price_system#currentrow#" value="#cost_price_system#">
                    <input type="hidden" name="purchase_extra_cost_system#currentrow#" id="purchase_extra_cost_system#currentrow#" value="#PURCHASE_EXTRA_COST_SYSTEM#">
                    <input type="hidden" name="purchase_extra_cost#currentrow#" id="purchase_extra_cost#currentrow#" value="#purchase_extra_cost#">
                    <input type="hidden" name="money_system#currentrow#" id="money_system#currentrow#" value="#cost_price_system_money#">
                    <input type="hidden" name="cost_price#currentrow#" id="cost_price#currentrow#" value="#cost_price#">
                    <input type="hidden" name="money#currentrow#" id="money#currentrow#" value="#cost_price_money#">
                    <input type="hidden" name="total_cost_price#currentrow#" id="total_cost_price#currentrow#" value="#cost_price*QUANTITY#">
                    <input type="hidden" name="cost_price_2#currentrow#" id="cost_price_2#currentrow#" value="#cost_price_2#">
                    <input type="hidden" name="total_cost_price_2#currentrow#" id="total_cost_price_2#currentrow#" value="#cost_price_2+purchase_extra_cost_system_2#">
                    <input type="hidden" name="cost_price_extra_2#currentrow#" id="cost_price_extra_2#currentrow#" value="#purchase_extra_cost_system_2#">
                    <input type="hidden" name="money_2#currentrow#" id="money_2#currentrow#" value="#cost_price_money_2#">
                    <tr>								
                        <td width="80">
                            <cfif isdefined('GET_DET_PO.PATH')>
                                <img src="documents/product/#GET_DET_PO.PATH#" width="70" height="70">
                            <cfelse>
                                <img src="/images/tamir_k2.jpg" border="0">
                            </cfif>
                        </td>
                        <td>
                            #IS_STAGE#
                            #STOCK_CODE#<br/>
                            #PRODUCT_NAME#<br/>
                            #SPEC_MAIN_ID#
                        </td>
                        <td>
                            <div class="colorful_td spect" style="background-color:##ffc9ca;padding: 5px;display: flex;">
                                <cfif ( isdefined('spec_main_id') and len(evaluate('spec_main_id')) and evaluate('spec_main_id') gt 0) or (isdefined('spect_var_id') and len(evaluate('spect_var_id')) and evaluate('spect_var_id') gt 0)><!--- demontajda GET_SUB_PRODUCTS querysi calistigi icin burda spect olmamali yari mamulün spectini bilemeyiz--->
                                    <cfquery name="GET_SPECT" datasource="#dsn3#">
                                        <cfif len(evaluate('spect_var_id'))>
                                            SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = #evaluate('spect_var_id')#
                                        <cfelse>
                                            SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = #evaluate('SPEC_MAIN_ID')#
                                        </cfif>
                                    </cfquery>
                                    <input type="hidden" value="#evaluate('spect_var_id')#" name="spect_id_#currentrow#" id="spect_id_#currentrow#">
                                    <input type="text" value="#evaluate('SPEC_MAIN_ID')#" name="spec_main_id#currentrow#" id="spec_main_id#currentrow#" readonly style="width:40px;">
                                    <input type="text" value="#evaluate('spect_var_id')#" name="spect_id#currentrow#" id="spect_id#currentrow#" readonly style="width:40px;">
                                    <input type="text" name="spect_name#currentrow#" id="spect_name#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:150px;">
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
                                    <input type="text" name="spec_main_id#currentrow#" id="spec_main_id#currentrow#" value="<cfif isdefined('stock#STOCK_ID#_spec_main_id')>#Evaluate('stock#STOCK_ID#_spec_main_id')#</cfif>" readonly style="width:40px;">
                                    <input type="text" value="" name="spect_id#currentrow#" id="spect_id#currentrow#" readonly style="width:40px;">
                                    <input type="text" name="spect_name#currentrow#" id="spect_name#currentrow#" value="#_spec_main_name__#" readonly style="width:150px;">
                                </cfif>	
                                
                                <a href="javascript://" onClick="pencere_ac_spect('#currentrow#');">

                                <img src="/images/tamir_k2.jpg" border="0" height="30px" width="30px" style="margin-left:auto;"></a></div></td>
                        <td class="inputs_m">
                            <div class="colorful_td" style="display: flex;">
                                <div class="colorful_td_first text-right" style="background-color:##ffe0ad;padding: 12px;">
                                    <cfinput style="text-align:right;"  type="text" onclick="this.select();" name="amount#currentrow#" id="amount#currentrow#" value="#TlFormat(QUANTITY,8)#">  
                                </div>
                                <div class="colorful_td_scnd" style="background-color:##fff2d9;padding: 12px;width: 50%;">
                                    #MAIN_UNIT#
                                </div>									
                            </div>
                        </td>
                        <td  class="inputs_m2">
                            <div class="colorful_td" style="display: flex;">
                                <div class="colorful_td_first text-right" style="background-color:##a8daf0;padding: 12px;">
                                    <cfinput style="text-align:right;" type="text" onclick="this.select();" name="amount2_#currentrow#" id="amount2_#currentrow#" value="#TlFormat(QUANTITY_2,8)#">  
                                </div>
                                <div class="colorful_td_scnd spect" style="background-color:##cae8f2;padding: 12px;width: 50%;">
                                    <cfquery name="production_orders_unit2" datasource="#dsn3#">
										SELECT QUANTITY_2,UNIT_2,PR.MULTIPLIER
										  FROM PRODUCTION_ORDERS PO
 									 LEFT JOIN PRODUCT_UNIT      PR ON PR.ADD_UNIT=PO.UNIT_2
										 WHERE P_ORDER_ID=#attributes.p_order_id# 
										   AND PR.PRODUCT_ID=#PRODUCT_ID#
									</cfquery>
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
                                    <select name="unit2#currentrow#" id="unit2#currentrow#" onchange="Get_Product_Unit_2_And_Quantity_2(#currentrow#)" disabled="true">
                                        <cfloop query="get_all_unit2">
                                            <option value="#PRODUCT_UNIT_ID#" <cfif get_all_unit2.ADD_UNIT eq production_orders_unit2.UNIT_2>selected</cfif>>#ADD_UNIT#</option>
                                        </cfloop>
                                    </select>
                                </div>									
                            </div>
                        </td>									
                    </tr>
                </cfoutput>
            </tbody>
        </cf_flat_list>
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
        <cfoutput>
            <input type="hidden" name="exit_department" id="exit_department" value="<cfif isdefined("get_station.exit_dep_id") and len(get_station.exit_dep_id)>1</cfif>">
            <input type="hidden" name="exit_department_id" id="exit_department_id" value="<cfif isdefined("get_station.exit_dep_id") and len(get_station.exit_dep_id)>#get_station.exit_dep_id#</cfif>">
            <input type="hidden" name="exit_location_id" id="exit_location_id" value="<cfif isdefined("get_station.exit_dep_id") and len(get_station.exit_dep_id)>#get_station.exit_loc_id#</cfif>">
            <input type="hidden" name="production_department" id="exit_department" value="<cfif isdefined("get_station.production_dep_id") and len(get_station.production_dep_id)>1</cfif>">
            <input type="hidden" name="production_department_id" id="production_department_id" value="<cfif isdefined("get_station.production_dep_id") and len(get_station.production_dep_id)>#get_station.production_dep_id#</cfif>">
            <input type="hidden" name="production_location_id" id="production_location_id" value="<cfif isdefined("get_station.production_dep_id") and len(get_station.production_dep_id)>#get_station.production_loc_id#</cfif>">
            <input type="hidden" name="enter_department" id="exit_department" value="<cfif isdefined("get_station.enter_dep_id") and len(get_station.enter_dep_id)>1</cfif>">
            <input type="hidden" name="enter_department_id" id="enter_department_id" value="<cfif isdefined("get_station.enter_dep_id") and len(get_station.enter_dep_id)>#get_station.enter_dep_id#</cfif>">
            <input type="hidden" name="enter_location_id" id="enter_location_id" value="<cfif isdefined("get_station.enter_dep_id") and len(get_station.enter_dep_id)>#get_station.enter_loc_id#</cfif>">
        </cfoutput>
            <cf_papers paper_type="production_result">
            <input type="hidden" name="production_result_no" id="production_result_no" value="<cfoutput>#paper_full#</cfoutput>" >							
            <cfinput type="hidden" name="p_order_id" id="p_order_id" value="#attributes.p_order_id#">
            <cfinput type="hidden" name="is_stage" id="is_stage" value="2">
            <cfinput type="hidden" name="process_stage" id="process_stage" value="60">
            <input  type="hidden" name="start_date" id="start_date"<cfoutput> validate="#validate_style#" <cfif isdefined("get_det_po.START_DATE_REAL") and len(get_det_po.START_DATE_REAL)>value="#dateformat(get_det_po.START_DATE_REAL,dateformat_style)#"<cfelse>value="#dateformat(now(),dateformat_style)#"</cfif></cfoutput>>
            <cfoutput><input type="hidden" name="expiration_date" id=" expiration_date"  <cfif isdefined("get_det_po.SHELF_LIFE") and len(get_det_po.SHELF_LIFE) and get_det_po.SHELF_LIFE neq 0 and isnumeric(get_det_po.SHELF_LIFE)>value="#dateformat((Fix(get_det_po.START_DATE_REAL)+get_det_po.SHELF_LIFE),dateformat_style)#"<cfelse>value=""</cfif>></cfoutput>
            <cfif len(get_det_po.START_DATE_REAL)>
                <cfinput type="hidden" name="start_h" id="start_h" value="#timeformat(get_det_po.START_DATE_REAL,'HH')#">
            <cfelse>
                <cfinput type="hidden" name="start_h" id="start_h" value="#timeformat(now(),'HH')#">
            </cfif>
            <cfif len(get_det_po.START_DATE_REAL)>
                <cfinput type="hidden" name="start_m" id="start_m" value="#timeformat(get_det_po.START_DATE_REAL,'mm')#">
            <cfelse>
                <cfinput type="hidden" name="start_m" id="start_m" value="#timeformat(now(),'mm')#">
            </cfif>
            <cfinput type="hidden" name="process_cat" id="process_cat" value="115">
            <cfinput type="hidden" name="station_id" id="station_id" value="#GET_DET_PO.station_id#">
            <input type="hidden" name="station_name" id="station_name" value="<cfoutput><cfif len(GET_DET_PO.STATION_ID)>#GET_STATION.STATION_NAME#</cfif></cfoutput>">
            <cfinput type="hidden" name="production_order_no" id="production_order_no" value="#GET_DET_PO.p_order_no#">
            <input type="hidden" name="order_no" id="order_no" value="<cfif isdefined("get_row.order_number")><cfoutput>#valuelist(get_row.order_number,',')#</cfoutput></cfif>">
            <input type="hidden" name="order_row_id" id="order_row_id" value="<cfif isdefined("get_row.order_number")><cfoutput>#listdeleteduplicates(valuelist(get_row.ORDER_ROW_ID,','))#</cfoutput></cfif>">
            <input type="hidden" name="expense_employee_id" id="expense_employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
            <input type="hidden" name="expense_employee" id="expense_employee" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>">
            <input type="hidden" name="old_lot_no" id="old_lot_no" value="<cfoutput>#GET_DET_PO.lot_no#</cfoutput>">
            <input type="hidden" name="lot_no" id="lot_no" value="<cfoutput>#GET_DET_PO.lot_no#</cfoutput>">					
            <input type="hidden" name="ref_no" id="ref_no" value="<cfoutput>#GET_DET_PO.REFERENCE_NO#</cfoutput>">
            <cfoutput> <input type="hidden" name="record_num" id="record_num" value="#GET_DET_PO.recordCount#">	
            <input type="hidden" name="record_num_exit" id="record_num_exit" value="#GET_SUB_PRODUCTS.recordCount#">
            <input type="hidden" name="record_num_outage" id="record_num_outage" value="#GET_SUB_PRODUCTS_FIRE.recordCount#">	</cfoutput>
            <input type="hidden" name="is_changed_spec_main" id="is_changed_spec_main" value="0">		
            <input type="hidden" name="is_demontaj" id="is_demontaj" value="0">											
            <div class="ui-form-list-btn">
            <div class="col col-12">
            <cf_box_elements>
                <div class="form-group col" id="item-start_date">
                    <div class="input-group">
                        <cfoutput>
                            <input required="Yes" style="margin-top:0px !important;height:42px;" type="text" name="finish_date" id="finish_date" validate="#validate_style#" <cfif isdefined("get_det_po.FINISH_DATE_REAL") and len(get_det_po.FINISH_DATE_REAL)>value="#dateformat(get_det_po.FINISH_DATE_REAL,dateformat_style)#"<cfelse>value="#dateformat(now(),dateformat_style)#"</cfif>>
                        </cfoutput>
                        <span class="input-group-addon" style="height:42px;"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group col col-1">
                    <cfoutput>
                        <cfif len(get_det_po.FINISH_DATE_REAL)>
                            <cf_wrkTimeFormat  name="finish_h" id="finish_h" value=">#timeformat(get_det_po.FINISH_DATE_REAL,'HH')#">
                        <cfelse>
                            <cf_wrkTimeFormat  name="finish_h" id="finish_h" value="#timeformat(now(),'HH')#">
                        </cfif>
                    </cfoutput>
                </div>
                <div class="form-group col col-1">
                     <cfoutput>
                        <cfif len(get_det_po.FINISH_DATE_REAL)>
                            <select name="finish_m" id="finish_m">
                                <cfloop from="0" to="59" index="i">
                                    <option value="#i#" <cfif timeformat(get_det_po.FINISH_DATE_REAL,'mm') eq i>selected</cfif>><cfif i lt 10>0</cfif>#I#</option>
                                </cfloop>
                            </select>
                        <cfelse>
                            <select name="finish_m" id="finish_m">
                                <cfloop from="0" to="59" index="i">
                                    <option value="#i#" <cfif timeformat(now(),'mm') eq i>selected</cfif>><cfif i lt 10>0</cfif>#I#</option>
                                </cfloop>
                            </select>
                        </cfif>
                    </cfoutput>
                </div>
                <div class="form-group col col-3" style="display:flex;flex:1;">
                    <select id="fis" name="fis">
                        <option value="0"><cf_get_lang dictionary_id='65392.Üretim Fişi'></option>
                    </select>
               </div>
                <div class="form-group col col-5">
                    <div class="col col-12">
                        <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra" onclick="designed()" style="margin-left:10px!important;float:right;"><i  class="fa fa-flag"></i> <cf_get_lang dictionary_id='63887.Sonuçlandır'></a>
                        <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra_blue ui-wrk-btn-addon-left" style="float:right;"><i class="fa fa-print"></i> <cf_get_lang dictionary_id='57474.Yazdır'></a> 
                    </div>
                </div>
            </cf_box_elements>
            </div>
        </div>
        </cfform>
    </cf_box>
    <script>
        function designed(){
            var row_count=$("#record_num").val();
            var row_count_exit=$("#record_num_exit").val();
            var row_count_outage=$("#record_num_outage").val();
        	for (var k=1;k<=row_count;k++)
			{
				document.getElementById("amount2_"+k).value = filterNum(document.getElementById("amount2_"+k).value,8);
				document.getElementById("amount"+k).value = filterNum(document.getElementById("amount"+k).value,8);
			}
        	for (var k=1;k<=row_count_exit;k++)
			{
				document.getElementById("amount_exit2_"+k).value = filterNum(document.getElementById("amount_exit2_"+k).value,8);
				document.getElementById("amount_exit"+k).value = filterNum(document.getElementById("amount_exit"+k).value,8);
			}
            for (var k=1;k<=row_count_outage;k++)
			{
				document.getElementById("amount_outage2_"+k).value = filterNum(document.getElementById("amount_outage2_"+k).value,8);
				document.getElementById("amount_outage"+k).value = filterNum(document.getElementById("amount_outage"+k).value,8);
			}
                var data = new FormData();  
                data.append("is_stage", $("#is_stage").val());
                data.append("p_order_id", <cfoutput>#attributes.p_order_id#</cfoutput>);
                AjaxControlPostData('V16/production_plan/cfc/production_plan_graph.cfc?method=updateProductionResult', data, function(response) {
                    production_.submit();
                    });
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
    </script>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">