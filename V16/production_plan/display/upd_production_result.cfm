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
    font-weight: bold;
    font-size: 20px;
    display: block;
    padding: 10px;
    color: #44b6ae!important;
    background: #f9f9f9;
}
.portBox .portHeadLight{
    padding:10px 0;
    margin:0 28px!important;
    padding-top:20px;
    border-bottom:20px;
}
.maxi .portHeadLight .portHeadLightTitle span a{
    color: #44b6ae;
    letter-spacing:0px;
    font-family:'Roboto', sans-serif !important;
}
.maxi .portHeadLightMenu > ul > li > a{
    color:#FF9B05!important;
}
.maxi .portHeadLightMenu > ul > li > a:hover{
    color:#FF9B05!important;
    background-color:white!important;
}
.ui-scroll::-webkit-scrollbar-thumb {
    background-color: #FFCC66;
    border-radius: 5px;
}
.seperator a i{font-size:15px!important;margin-right:3px;color:#44b6ae!important;transform-origin:center;transition:.4s;}
.seperator a:hover i{color:#44b6ae!important;}
.seperator a.active i{transform:rotate(90deg);transition:.4s;}
.ajax_list > tbody > tr > td, .ajax_list > tfoot > tr > td {
    font-size: 20px;
    padding: 5px;
    height: 20px;
    color: #555;
    white-space: nowrap;
}
.ui-form-list-btn {
    display: flex;
    flex-wrap: wrap;
    flex-direction: row;
    justify-content: center !important;
    align-items: center;
    margin-top: 5px;
    padding-left: 0px !important;
    border-top: 1px solid #ddd;
}
.ajax_list > thead tr th {
    font-size: 18px;
	border-bottom: 0.5px solid #bebfbc;
    padding: 5px;
    height: 20px;
    white-space: nowrap;
}
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
.ui-wrk-btn-extra_green{
    background-color: green!important;
    color: white!important;
    transition: .4s;
}
.ui-wrk-btn-extra_blue{
    background-color: #007bff!important;
    color: white!important;
    transition: .4s;
}
.ui-wrk-btn {
margin: 8px 0 0 20px;
border: 0;
font-size: 20px !important;
padding: 10px 20px !important;
text-align: center;
border-radius: 7px;
transition: .4s !important;
cursor: pointer;
}
.inputs_m input{
background-color:#ffe0ad;
border: 0px solid;
cursor:pointer;
}

.spect > input{background-color:#ffc9ca;border:0;}
.inputs_m2 input{
background-color:#a8daf0;
border: 0px solid; 
cursor:pointer;  
}
.ui-draggable-box .ui-scroll table thead tr th{
    border-bottom:white!important;
}
.ui-form-list .form-group select{
    height:42px;
}
</style>
<cfset new_dsn2 = dsn2>
<cfset variable_ = '0'>
<cfset variable = '1'>
<cfset variable2 = '2'> 
<cfset variable3 = '3'>
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
<cfquery name="GET_DETAIL" datasource="#DSN3#">
	SELECT DISTINCT
		PRODUCTION_ORDERS.REFERENCE_NO REFERANS,
		PRODUCTION_ORDERS.PROJECT_ID,
		PRODUCTION_ORDERS.P_ORDER_NO,
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
		PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDER_RESULTS.P_ORDER_ID
</cfquery>
<cfquery name="GET_ROW_ENTER" datasource="#DSN3#">
	<!---SELECT ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,* FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable#">  ORDER BY PR_ORDER_ROW_ID---->
	SELECT ISNULL(STATION_REFLECTION_COST_SYSTEM,0) STATION_REFLECTION_COST_SYSTEM,ISNULL(LABOR_COST_SYSTEM,0) LABOR_COST_SYSTEM,ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,* FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable#">  ORDER BY PR_ORDER_ROW_ID
</cfquery>
<cfquery name="GET_ROW_EXIT" datasource="#DSN3#">
	<!----SELECT ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,ISNULL(PURCHASE_NET,0) AS PURCHASE_NET,ISNULL(PURCHASE_NET_2,0) PURCHASE_NET_2,* FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable2#"> ORDER BY PR_ORDER_ROW_ID---->
	SELECT ISNULL(STATION_REFLECTION_COST_SYSTEM,0) STATION_REFLECTION_COST_SYSTEM,ISNULL(LABOR_COST_SYSTEM,0) LABOR_COST_SYSTEM,ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,ISNULL(PURCHASE_NET,0) AS PURCHASE_NET,ISNULL(PURCHASE_NET_2,0) PURCHASE_NET_2,* FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable2#"> ORDER BY PR_ORDER_ROW_ID
</cfquery>
<cfquery name="GET_ROW_OUTAGE" datasource="#DSN3#">
	<!---SELECT ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,ISNULL(PURCHASE_NET,0) AS PURCHASE_NET,ISNULL(PURCHASE_NET_2,0) PURCHASE_NET_2,* FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable3#">  ORDER BY PR_ORDER_ROW_ID--->
	SELECT ISNULL(STATION_REFLECTION_COST_SYSTEM,0) STATION_REFLECTION_COST_SYSTEM,ISNULL(LABOR_COST_SYSTEM,0) LABOR_COST_SYSTEM,ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,ISNULL(PURCHASE_NET,0) AS PURCHASE_NET,ISNULL(PURCHASE_NET_2,0) PURCHASE_NET_2,* FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable3#">  ORDER BY PR_ORDER_ROW_ID
</cfquery>
<cfquery name="GET_STOK_FIS" datasource="#new_dsn2#">
	SELECT SHIP_NUMBER,SHIP_ID,SHIP_TYPE FROM SHIP WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_DETAIL.pr_order_id#">
</cfquery>
    <cf_box  title="#getLang('','Üretim sonucu','29651')#" popup_box="1" settings="0" closable="1" resize="0" collapsable="0" >
       
        <cfform name="production_" action="#request.self#?fuseaction=prod.emptypopup_upd_prod_order_result_act&from_order_operator=1&list_type=#attributes.list_type#&part=#attributes.part#" enctype="multipart/form-data" method="post">
            <cfinput type="hidden" name="is_stage" id="is_stage" value="2">
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
                <cfset kontrol_stock_amount = 1>

                <!--- <cfset attributes.stock_list_count = Listlen(stock_and_spect_list)> --->
                <cfoutput query="GET_ROW_EXIT">
                        <cfquery name="GET_PRODUCT" datasource="#dsn1#">
                            SELECT 
                                PRODUCT.PRODUCT_NAME,
                                STOCKS.BARCOD,
                                STOCKS.STOCK_CODE,
                                STOCKS.PRODUCT_UNIT_ID,
                                PRODUCT_UNIT.ADD_UNIT,
                                PRODUCT_UNIT.MAIN_UNIT,
                                PRODUCT_UNIT.DIMENTION,
                                STOCKS.PROPERTY,
                                STOCKS.STOCK_CODE,
                                PRODUCT.IS_SERIAL_NO
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
                        <input type="hidden" name="row_kontrol_exit#currentrow#" id="row_kontrol_exit#currentrow#" value="1">
                        <input type="hidden" name="expiration_date_exit#currentrow#" id="expiration_date_exit#currentrow#"  value="#dateformat(expiration_date,dateformat_style)#">
                        <input type="hidden" name="tree_type_exit_#currentrow#" id="tree_type_exit_#currentrow#" value="#TREE_TYPE#">
                        <input type="hidden" name="product_id_exit#currentrow#" id="product_id_exit#currentrow#" value="#product_id#">
                        <input type="hidden" name="stock_id_exit#currentrow#" id="stock_id_exit#currentrow#" value="#stock_id#">
                        <input type="hidden" name="lot_no_exit#currentrow#" id="lot_no_exit#currentrow#"  value="#lot_no#">
                        <input type="hidden" name="unit_id_exit#currentrow#" id="unit_id_exit#currentrow#" value="#get_product.product_unit_id#">
                        <input type="hidden" name="serial_no_exit#currentrow#" id="serial_no_exit#currentrow#" value="#serial_no#">
                        <input type="hidden" name="product_name_exit#currentrow#" id="product_name_exit#currentrow#" value="#get_product.product_name# #get_product.property#" >
                        <input type="hidden" name="unit_exit#currentrow#" id="unit_exit#currentrow#" value="#get_product.main_unit#">
                        <cfquery name="get_is_production" datasource="#dsn3#">
                            SELECT TOP 1 IS_PRODUCTION FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                        </cfquery>
                        <input type="hidden" name="is_production_spect_exit#currentrow#" id="is_production_spect_exit#currentrow#" value="#get_is_production.IS_PRODUCTION#">
                        <input type="hidden" name="cost_id_exit#currentrow#" id="cost_id_exit#currentrow#" value="#COST_ID#">
                        <input type="hidden" name="kdv_amount_exit#currentrow#" id="kdv_amount_exit#currentrow#" value="#KDV_PRICE#">
                        <input type="hidden" name="cost_price_system_exit#currentrow#" id="cost_price_system_exit#currentrow#" value="#PURCHASE_NET_SYSTEM#">
                        <input type="hidden" name="purchase_extra_cost_system_exit#currentrow#" id="purchase_extra_cost_system_exit#currentrow#" value="#wrk_round(PURCHASE_EXTRA_COST_SYSTEM,8,1)#">
                        <input type="hidden" name="purchase_extra_cost_exit#currentrow#" id="purchase_extra_cost_exit#currentrow#" value="#wrk_round(PURCHASE_EXTRA_COST,8,1)#">
                        <input type="hidden" name="money_system_exit#currentrow#" id="money_system_exit#currentrow#" value="#PURCHASE_NET_SYSTEM_MONEY#">
                        <cfset PURCHASE_NET_ = wrk_round(PURCHASE_NET,8,1)>
                        <cfif len(PURCHASE_NET_2)>
                            <cfset PURCHASE_NET_2_ = wrk_round(PURCHASE_NET_2,8,1)>
                        <cfelse>	
                            <cfset PURCHASE_NET_2_ = 0>
                        </cfif>
                        <input type="hidden" name="cost_price_exit#currentrow#" id="cost_price_exit#currentrow#" value="#PURCHASE_NET_#">
                        <input type="hidden" name="money_exit#currentrow#" id="money_exit#currentrow#" value="#PURCHASE_NET_MONEY#">
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
                            <td> #GET_PRODUCT.STOCK_CODE#<br/>#GET_PRODUCT.PRODUCT_NAME#</td>
                            <td><div class="colorful_td spect" style="background-color:##ffc9ca;padding: 5px;display: flex;">
                                <cfif len(get_row_exit.spect_id) OR LEN(get_row_exit.SPEC_MAIN_ID) >
                                    <cfquery name="GET_SPECT" datasource="#dsn3#">
                                        <cfif len(get_row_exit.spect_id)>
                                            SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_exit.spect_id#">
                                        <cfelse>
                                            SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_exit.SPEC_MAIN_ID#">
                                        </cfif>
                                    </cfquery>
                                        <input type="hidden" name="spect_id_exit_#currentrow#" id="spect_id_exit_#currentrow#" value="#get_row_exit.spect_id#" >
                                        <input type="text" name="spec_main_id_exit#currentrow#" id="spec_main_id_exit#currentrow#" value="#get_row_exit.SPEC_MAIN_ID#" readonly style="width:40px;">
                                        <input type="text" name="spect_id_exit#currentrow#" id="spect_id_exit#currentrow#" value="#get_row_exit.spect_id#"  readonly style="width:40px;">
                                        <input type="text" name="spect_name_exit#currentrow#" id="spect_name_exit#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:160px;">
                                <cfelse>
                                    <input type="hidden" name="spect_id_exit_#currentrow#" id="spect_id_exit_#currentrow#" value="">
                                    <input type="text" name="spec_main_id_exit#currentrow#" id="spec_main_id_exit#currentrow#" value="" readonly style="width:40px;">
                                    <input type="text" name="spect_id_exit#currentrow#" id="spect_id_exit#currentrow#" value="" readonly style="width:40px;">
                                    <input type="text" name="spect_name_exit#currentrow#" id="spect_name_exit#currentrow#" value="" readonly style="width:160px;">
                                 </cfif>
                                
                                 <a href="javascript://" onClick="pencere_ac_spect('#currentrow#',2);">
                                <img src="/images/tamir_k2.jpg" border="0" height="30px" width="30px" style="margin-left:auto;"></a></div></td>
                        
                            <td class="inputs_m"> 
                                <div class="colorful_td" style="display: flex;">
                                    <div class="colorful_td_first text-right" style="background-color:##ffe0ad;padding: 12px;">
                                        <cfinput type="text" style="text-align:right;" onclick="this.select();"  name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat(AMOUNT,8)#">  
                                    </div>
                                    <div class="colorful_td_scnd" style="background-color:##fff2d9;padding: 12px;width: 50%;">
                                            #GET_PRODUCT.MAIN_UNIT#
                                    </div>									
                                </div>
                            </td>
                            <td class="inputs_m2">
                                    <div class="colorful_td" style="display: flex;">
                                        <div class="colorful_td_first text-right" style="background-color:##a8daf0;padding: 12px;">
                                            <cfinput type="text" style="text-align:right;"  onclick="this.select();"  name="amount_exit2_#currentrow#" id="amount_exit2_#currentrow#" value="#TlFormat(AMOUNT2,8)#">  
                                        </div>
                                        <div class="colorful_td_scnd" style="background-color:##cae8f2;padding: 12px;width: 50%;">
                                            #GET_PRODUCT.MAIN_UNIT#
                                        
                                        </div>									
                                    </div>
                                </td>
                            </td>
                            
                        </tr>
                </cfoutput>
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
                        <th width="150px" style="min-width:250px !important;text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
                        <th width="150px" style="min-width:250px !important;text-align:right;">2.<cf_get_lang dictionary_id='57635.Miktar'></th>
                    </tr>
                </thead>
                <tbody id="status" name="status">
            <cfset kontrol_stock_amount = 1>

            <!--- <cfset attributes.stock_list_count = Listlen(stock_and_spect_list)> --->
            <cfoutput query="GET_ROW_OUTAGE">
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
                    <input type="hidden" name="row_kontrol_outage#currentrow#" id="row_kontrol_outage#currentrow#" value="1">
                    <input type="hidden" name="expiration_date_outage#currentrow#" id="expiration_date_outage#currentrow#" value="#dateformat(get_row_outage.expiration_date,dateformat_style)#">
                    <input type="hidden" name="product_id_outage#currentrow#" id="product_id_outage#currentrow#" value="#product_id#">
                    <input type="hidden" name="stock_id_outage#currentrow#" id="stock_id_outage#currentrow#" value="#stock_id#">
                    <input type="hidden" name="lot_no_outage#currentrow#" id="lot_no_outage#currentrow#" value="#lot_no#">
                    <input type="hidden" name="unit_id_outage#currentrow#" id="unit_id_outage#currentrow#" value="#get_product.product_unit_id#">
                    <input type="hidden" name="serial_no_outage#currentrow#" id="serial_no_outage#currentrow#" value="#serial_no#">
                    <input type="hidden" name="kdv_amount_outage#currentrow#" id="kdv_amount_outage#currentrow#" value="#KDV_PRICE#">
                    <input type="hidden" name="unit_outage#currentrow#" id="unit_outage#currentrow#" value="#get_product.main_unit#">
                    <input type="hidden" name="product_name_outage#currentrow#" id="product_name_outage#currentrow#" value="#get_product.product_name# #get_product.property#">
                    <input type="hidden" name="cost_id_outage#currentrow#" id="cost_id_outage#currentrow#" value="#COST_ID#">
                    <input type="hidden" name="product_cost_outage#currentrow#" id="product_cost_outage#currentrow#">
                    <input type="hidden" name="product_cost_money_outage#currentrow#" id="product_cost_money_outage#currentrow#" value="">
                    <input type="hidden" name="cost_price_system_outage#currentrow#" id="cost_price_system_outage#currentrow#" value="">
                    <input type="hidden" name="purchase_extra_cost_system_outage#currentrow#" id="purchase_extra_cost_system_outage#currentrow#" value="">
                    <input type="hidden" name="purchase_extra_cost_outage#currentrow#" id="purchase_extra_cost_outage#currentrow#" value="">
                    <input type="hidden" name="money_system_outage#currentrow#" id="money_system_outage#currentrow#" value="">
                    <input type="hidden" name="cost_price_outage#currentrow#" id="cost_price_outage#currentrow#" value="">
                    <input type="hidden" name="money_outage#currentrow#" id="money_outage#currentrow#" value="">
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
                        <td> #get_product.PRODUCT_NAME#<br/>#get_product.STOCK_CODE#</td>
                        <td><div class="colorful_td spect" style="background-color:##ffc9ca;padding: 5px;display: flex;">
                            <cfif len(get_row_outage.spect_id)  OR LEN(get_row_outage.SPEC_MAIN_ID) >
                                <cfquery name="GET_SPECT" datasource="#dsn3#">
                                    <cfif len(get_row_outage.spect_id)>
                                        SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_outage.spect_id#">
                                    <cfelse>
                                        SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_outage.SPEC_MAIN_ID#">
                                    </cfif>
                                </cfquery>
                                    <input type="text" name="spec_main_id_outage#currentrow#" id="spec_main_id_outage#currentrow#" value="#get_row_outage.SPEC_MAIN_ID#" readonly style="width:40px;">
                                    <input type="text" name="spect_id_outage#currentrow#" id="spect_id_outage#currentrow#" value="#get_row_outage.spect_id#" readonly style="width:40px;">
                                    <input type="text" name="spect_name_outage#currentrow#" id="spect_name_outage#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:160px;">
                            <cfelse>
                                <input type="text" name="spec_main_id_outage#currentrow#" id="spec_main_id_outage#currentrow#" value="" readonly style="width:40px;">
                                <input type="text" name="spect_id_outage#currentrow#" id="spect_id_outage#currentrow#" value="" readonly style="width:40px;">
                                <input type="text" name="spect_name_outage#currentrow#" id="spect_name_outage#currentrow#" value="" readonly style="width:160px;">
                             </cfif>
                             <a href="javascript://" onClick="pencere_ac_spect('#currentrow#',3);">
                            <img src="/images/tamir_k2.jpg" border="0" height="30px" width="30px" style="margin-left:auto;"></a></div></td>
                        <td class="inputs_m"> 
                            <cfif is_free_amount eq 0>
                                <cfset "product_spect_total_amount_#my_value2#" = wrk_round(Evaluate("product_spect_total_amount_#my_value2#")*attributes.this_production_amount,8,1)>
                            </cfif>
                            <div class="colorful_td" style="display: flex;">
                                <div class="colorful_td_first text-right" style="background-color:##ffe0ad;padding: 12px;">
                                    <cfinput type="text" style="text-align:right;" onclick="this.select();"  name="amount_outage#currentrow#" id="amount_outage#currentrow#" value="#TlFormat(amount,8)#">  
                                </div>
                                <div class="colorful_td_scnd" style="background-color:##fff2d9;padding: 12px;width: 50%;">
                                       #get_product.MAIN_UNIT#
                                </div>									
                            </div>
                        </td>
                        <td class="inputs_m2">
                                <cfif is_free_amount eq 0>
                                    <cfset "product_spect_total_amount_#my_value2#" = wrk_round(Evaluate("product_spect_total_amount_#my_value2#")*attributes.this_production_amount,8,1)>
                                </cfif>
                                <div class="colorful_td" style="display: flex;">
                                    <div class="colorful_td_first text-right" style="background-color:##a8daf0;padding: 12px;">
                                        <cfinput type="text" style="text-align:right;" onclick="this.select();"  name="amount_outage2_#currentrow#" id="amount_outage2_#currentrow#" value="#TlFormat(amount2,8)#">  
                                    </div>
                                    <div class="colorful_td_scnd" style="background-color:##cae8f2;padding: 12px;width: 50%;">
                                        #get_product.MAIN_UNIT#
                                    </div>									
                                </div>
                        </td>
                    </tr>
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
                    <th width="150px" style="min-width:300px;"><cf_get_lang dictionary_id='34299.Spec'>/<cf_get_lang dictionary_id='45880.Etiket'></th>
                    <th style="min-width:250px !important;text-align:right;" width="150px"><cf_get_lang dictionary_id='57635.Miktar'></th>
                    <th style="min-width:250px !important;text-align:right;" width="150px">2.<cf_get_lang dictionary_id='57635.Miktar'></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="GET_ROW_ENTER">
                    <cfquery name="GET_PRODUCT" datasource="#dsn1#">
                        SELECT 
                            PRODUCT.PRODUCT_NAME,
                            STOCKS.BARCOD,
                            STOCKS.PRODUCT_UNIT_ID,
                            PRODUCT_UNIT.ADD_UNIT,
                            PRODUCT_UNIT.MAIN_UNIT,
                            PRODUCT_UNIT.DIMENTION,
                            STOCKS.PROPERTY,
                            STOCKS.STOCK_CODE,
                            PRODUCT.IS_SERIAL_NO,
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
                    <cfinput type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                    <input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#stock_id#">
                    <input type="hidden" name="tree_type_#currentrow#" id="tree_type_#currentrow#" value="#tree_type#">
                    <input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
                    <input type="hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="#get_product.product_unit_id#">
					<input type="hidden" name="unit#currentrow#" id="unit#currentrow#" value="#get_product.main_unit#">
                    <input type="hidden" name="kdv_amount#currentrow#" id="kdv_amount#currentrow#" value="#KDV_PRICE#">
                    <input type="hidden" name="product_name#currentrow#" id="product_name#currentrow#" value="#get_product.product_name# #get_product.property#">
                    <input type="hidden" name="spect_name#currentrow#" id="spect_name#currentrow#" value="">
                    <input type="hidden" name="spect_id#currentrow#" id="spect_id#currentrow#" value="">
                    <input type="hidden" name="SPEC_MAIN_ID#currentrow#" id="SPEC_MAIN_ID#currentrow#" value="">
                    <input type="hidden" name="cost_id#currentrow#" id="cost_id#currentrow#" value="">
                    <input type="hidden" name="product_cost#currentrow#" id="product_cost#currentrow#" value="">
                    <input type="hidden" name="product_cost_money#currentrow#" id="product_cost_money#currentrow#" value="">
                    <input type="hidden" name="kdv_amount#currentrow#" id="kdv_amount#currentrow#" value="">
                    <input type="hidden" name="cost_price_system#currentrow#" id="cost_price_system#currentrow#" value="">
                    <input type="hidden" name="purchase_extra_cost_system#currentrow#" id="purchase_extra_cost_system#currentrow#" value="">
                    <input type="hidden" name="purchase_extra_cost#currentrow#" id="purchase_extra_cost#currentrow#" value="">
                    <input type="hidden" name="money_system#currentrow#" id="money_system#currentrow#" value="">
                    <input type="hidden" name="cost_price#currentrow#" id="cost_price#currentrow#" value="">
                    <input type="hidden" name="money#currentrow#" id="money#currentrow#" value="">
                    <tr>	
                        <cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN3#">
                            SELECT 					
                               *
                            FROM 
                                PRODUCT_IMAGES 
                            WHERE 
                                PRODUCT_ID = #PRODUCT_ID# 
                        </cfquery>								
                        <td width="80">
                            <cfif len(GET_PRODUCT_IMAGES.PATH)>
                                <img src="documents/product/#GET_PRODUCT_IMAGES.PATH#" width="70" height="70">
                            <cfelse>
                                <img src="../images/production/no-image.png" width="70" height="70">
                            </cfif>
                        </td>
                        <td>
                            #get_product.STOCK_CODE#<br/>
                            #get_product.PRODUCT_NAME#<br/>
                        </td>
                        <td><div class="colorful_td spect" style="background-color:##ffc9ca;padding: 5px;display: flex;">
                            <cfif len(spect_id) or len(SPEC_MAIN_ID)>
                                <cfquery name="GET_SPECT" datasource="#dsn3#">
                                    <cfif len(spect_id)>
                                        SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#spect_id#">
                                    <cfelse>
                                        SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SPEC_MAIN_ID#">
                                    </cfif>
                                </cfquery>
                                <input type="hidden" name="spect_id_#currentrow#" id="spect_id_#currentrow#" value="#spect_id#">
                                    <input type="text" value="#SPEC_MAIN_ID#" name="spec_main_id#currentrow#" id="spec_main_id#currentrow#" readonly style="width:40px;">
                                    <input type="text" name="spect_id#currentrow#" id="spect_id#currentrow#"value="#spect_id#" readonly style="width:40px;">
                                    <input type="text" name="spect_name#currentrow#" id="spect_name#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:160px;">
                            <cfelse>
                                <input type="hidden" name="spect_id_#currentrow#" id="spect_id_#currentrow#" value="">
                                <input type="text" name="spec_main_id#currentrow#" id="spec_main_id#currentrow#" value="" readonly style="width:40px;">
                                <input type="text" name="spect_id#currentrow#" id="spect_id#currentrow#" value="" readonly style="width:40px;">
                                <input type="text" name="spect_name#currentrow#" id="spect_name#currentrow#" value="" readonly style="width:160px;">
                            </cfif><a href="javascript://" onClick="pencere_ac_spect('#currentrow#');">
                                <img src="/images/tamir_k2.jpg" border="0" height="30px" width="30px" style="margin-left:auto;"></a>
                            </div>
                        </td>
                        <td class="inputs_m">
                            <div class="colorful_td" style="display: flex;">
                                <div class="colorful_td_first text-right" style="background-color:##ffe0ad;padding: 12px;">
                                    <cfinput type="text" style="text-align:right;" onclick="this.select();"  name="amount#currentrow#" id="amount#currentrow#" value="#TlFormat(AMOUNT,8)#">  
                                </div>
                                <div class="colorful_td_scnd" style="background-color:##fff2d9;padding: 12px;width: 50%;">
                                    #get_product.main_unit#
                                </div>									
                            </div>
                        </td>
                        <td  class="inputs_m2">
                            <div class="colorful_td" style="display: flex;">
                                <div class="colorful_td_first text-right" style="background-color:##a8daf0;padding: 12px;">
                                    <cfinput type="text" style="text-align:right;" onclick="this.select();"  name="amount2_#currentrow#" id="amount2_#currentrow#" value="#TlFormat(AMOUNT2,8)#">  
                                </div>
                                <div class="colorful_td_scnd" style="background-color:##cae8f2;padding: 12px;width: 50%;">
                                    #get_product.MAIN_UNIT#
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
            <input  type="hidden" name="start_date" id="start_date"<cfoutput> validate="#validate_style#" value="#dateformat(get_detail.start_date,dateformat_style)#" </cfoutput>>
            <cfoutput><input type="hidden" name="expiration_date" id=" expiration_date" value="#dateformat(get_detail.expiration_date,dateformat_style)#" ></cfoutput>
            <cfif len(get_detail.start_date)>
                <cfset hour_detail = hour(get_detail.start_date)>
                <cfset minute_detail = minute(get_detail.start_date)>
            <cfelse>
                <cfset hour_detail = 0>
                <cfset minute_detail = 0>
            </cfif>
            <cfinput type="hidden" name="start_h" id="start_h"value="#hour_detail#">
            <cfinput type="hidden" name="start_m" id="start_m" value="#minute_detail#">
            <cfinput type="hidden" name="process_cat" id="process_cat" value="115">
            <input type="hidden" name="old_process_type" id="old_process_type" value="117">
            <cfif len(get_detail.station_id)>
                <cfquery name="GET_STATION" datasource="#dsn3#">
                    SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.station_id#">
                </cfquery>
                <input type="hidden" name="station_id" id="station_id" value="<cfoutput>#get_detail.station_id#</cfoutput>">
                <input type="hidden" name="station_name" id="station_name" value="<cfoutput>#get_station.station_name#</cfoutput>">
                <cfelse>
                    <input type="hidden" name="station_id" id="station_id"  value="">
                    <input type="hidden" name="station_name" id="station_name">
                </cfif>
            <cfinput type="hidden" name="production_order_no" id="production_order_no" value="#GET_DETAIL.p_order_no#">
            <input type="hidden" name="order_no" id="order_no" value="<cfif isdefined("get_row.order_number")><cfoutput>#valuelist(get_row.order_number,',')#</cfoutput></cfif>">
            <input type="hidden" name="order_row_id" id="order_row_id" value="<cfif isdefined("get_row.order_number")><cfoutput>#listdeleteduplicates(valuelist(get_row.ORDER_ROW_ID,','))#</cfoutput></cfif>">
            <input type="hidden" name="expense_employee_id" id="expense_employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
            <input type="hidden" name="expense_employee" id="expense_employee" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>">
            <input type="hidden" name="old_lot_no" id="old_lot_no" value="<cfoutput>#GET_DETAIL.lot_no#</cfoutput>">
            <input type="hidden" name="lot_no" id="lot_no" value="<cfoutput>#GET_DETAIL.lot_no#</cfoutput>">					
            <input type="hidden" name="ref_no" id="ref_no" value="<cfoutput>#GET_DETAIL.REFERENCE_NO#</cfoutput>">
            <cfoutput> <input type="hidden" name="record_num" id="record_num" value="#GET_ROW_ENTER.recordCount#">	
            <input type="hidden" name="record_num_exit" id="record_num_exit" value="#GET_ROW_EXIT.recordCount#">
            <input type="hidden" name="record_num_outage" id="record_num_outage" value="#GET_ROW_OUTAGE.recordCount#">	</cfoutput>
            <input type="hidden" name="is_changed_spec_main" id="is_changed_spec_main" value="0">		
            <input type="hidden" name="is_demontaj" id="is_demontaj" value="0">
            <input type="hidden" name="del_pr_order_id" id="del_pr_order_id" value="0">		
            <input type="hidden" name="pr_order_id" id="pr_order_id" value="<cfoutput>#get_Detail.pr_order_id#</cfoutput>">		
            <input type="hidden" name="reference_no" id="reference_no" value="<cfoutput>#GET_DETAIL.REFERENCE_NO#</cfoutput>">							
       <div class="ui-form-list-btn">
        <div class="col col-12">
        <cf_box_elements>
                <div class="form-group col" id="item-start_date">
                    <div class="input-group">
                        <cfoutput>
                            <input required="Yes" style="width:120;margin-top:0px !important;height:42px;" type="text" name="finish_date" id="finish_date" validate="#validate_style#"  value="#dateformat(get_detail.finish_date,dateformat_style)#">
                        </cfoutput>
                        <span class="input-group-addon" style="height:42px;"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <cfif len(get_detail.finish_date)>
                    <cfset value_finish_h = hour(get_detail.finish_date)>
                    <cfset value_finish_m = minute(get_detail.finish_date)>
                <cfelse>
                    <cfset value_finish_h = 0>
                    <cfset value_finish_m = 0>
                </cfif>
                <div class="form-group col col-1">
                    <cfoutput>
                            <cf_wrkTimeFormat  name="finish_h" id="finish_h" value=">#value_finish_h#">
                    </cfoutput>
                </div>
                <div class="form-group col col-1">
                     <cfoutput>
                            <select name="finish_m" id="finish_m">
                                <cfloop from="0" to="59" index="i">
                                    <option value="#i#" <cfif value_finish_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#I#</option>
                                </cfloop>
                            </select>
                    </cfoutput>
                </div>
                <div class="form-group col col-3" style="display:flex;flex:1;">
                    <select id="fis" name="fis">
                        <option value="0"><cf_get_lang dictionary_id='65392.Üretim Fişi'></option>
                    </select>
               </div>
                <div class="form-group col col-5">
                    <div class="col col-12">
                        <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra" style="margin-left:10px!important;float:right;" onclick="designed()"><i  class="fa fa-flag"></i> <cf_get_lang dictionary_id='57464.Güncelle'></a>
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
          production_.submit();
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