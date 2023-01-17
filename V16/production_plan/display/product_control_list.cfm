<cf_get_lang_set module_name="objects">
<style>
    .portBox .portHeadLightTitle span a {
        color: #44b6ae!important;
        font-size: 22px!important;
        margin-left:3px;
    }
    .op_item_detail_left_2 .op_detail_content_title {
        font-size: 18px;
        color: #E08283;
    }
    .ajax_list > thead tr th {
        font-size: 18px;
    }
    .tab a, #basket_main_div .tabNav a {
        font-size: 18px;
    }
    .ui-draggable-box .ui-form-list-btn {
        justify-content: center !important;
        border-top:1px solid #bbb!important;
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
    .portBox .portHeadLight {
        border-bottom:0px;
        margin: 0 28px!important;
        padding-top:20px;
    }
    .catalystClose {
        font-size: 35px!important;
        margin-top: -6px;
    }
    .portHeadLightMenu > ul > li > a{
        color:#FF9B05!important;
        padding:0px!important;
    }
    .portHeadLightMenu > ul > li > a:hover{
        color:#FF9B05!important;
        background-color:white!important;
    }
    .portHeadLightMenu > ul > li > a > i{
        color:#FF9B05!important;
    }
    .portHeadLightMenu > ul > li > a > i, .portHeadLightMenu > ul > li > span > i{
        color:#FF9B05!important;
    }
    .tabcontent .uniqueBox{
        margin-top:0px!important;
    }
    #unique_access a > img{
        max-width:50px;
    }
    .ui-draggable-box .ui-scroll table thead tr th{
        border-bottom:white!important;
    }
</style>
    
<cfquery name="GET_DET_PO" datasource="#dsn3#">
    SELECT 
        PO.* ,
        S.STOCK_ID,
        S.PRODUCT_ID,
        P.PRODUCT_ID,
        P.PRODUCT_NAME,
        PU.PRODUCT_ID,
        PU.MAIN_UNIT,
        PO.STOCKS_JSON
    FROM
        PRODUCTION_ORDERS PO
        LEFT JOIN STOCKS S ON S.STOCK_ID = PO.STOCK_ID  
        LEFT JOIN PRODUCT P ON  P.PRODUCT_ID = S.PRODUCT_ID  
        LEFT JOIN PRODUCT_UNIT PU ON PU.PRODUCT_ID =P.PRODUCT_ID
        WHERE 
        PO.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
</cfquery>
<cfquery name="GET_DET_PRO" datasource="#dsn3#">
    SELECT 
        PR.PRODUCT_ID,
        PR.STOCK_ID,
        P.PRODUCT_ID,
        P.PRODUCT_NAME,
        P.PRODUCT_CODE,
        P_I.PATH,
        PR.AMOUNT,
        PU.PRODUCT_ID,
        PU.MAIN_UNIT,
        S.STOCK_ID AS STOCK_ID_MAIN
    FROM
        PRODUCT_TREE PR
        LEFT JOIN PRODUCT P ON P.PRODUCT_ID = PR.PRODUCT_ID 
        LEFT JOIN PRODUCT_IMAGES P_I ON P_I.PRODUCT_ID = P.PRODUCT_ID 
        LEFT JOIN PRODUCT_UNIT PU ON PU.PRODUCT_ID =P.PRODUCT_ID 
        LEFT JOIN STOCKS S ON S.PRODUCT_ID =P.PRODUCT_ID 
    WHERE 
        PR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_DET_PO.STOCK_ID#">
        and 
        PR.PRODUCT_ID IS NOT NULL
      
</cfquery>

<cfquery name="GET_DET_OPERATIONS" datasource="#dsn3#">
    SELECT 
        PR.PRODUCT_ID,
        PR.STOCK_ID,
        P.PRODUCT_ID,
        P.PRODUCT_NAME,
        P.PRODUCT_CODE,
        P_I.PATH,
        PR.AMOUNT,
        PU.PRODUCT_ID,
        PU.MAIN_UNIT,
        PR.PRODUCT_ID,
        OT.OPERATION_TYPE_ID,
        OT.OPERATION_TYPE
        
    FROM
        PRODUCT_TREE PR
        LEFT JOIN PRODUCT P ON P.PRODUCT_ID = PR.PRODUCT_ID 
        LEFT JOIN PRODUCT_IMAGES P_I ON P_I.PRODUCT_ID = P.PRODUCT_ID 
        LEFT JOIN OPERATION_TYPES OT ON OT.OPERATION_TYPE_ID=PR.OPERATION_TYPE_ID
        LEFT JOIN PRODUCT_UNIT PU ON PU.PRODUCT_ID =P.PRODUCT_ID 
    WHERE 
        PR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_DET_PO.STOCK_ID#">
        and 
        PR.OPERATION_TYPE_ID IS NOT NULL
      
</cfquery>
<cf_box title="#getLang('','','63800')#"  box_style="maxi" popup_box="1" settings="0" closable="1" resize="0"  collapsable="0" >
    <cf_tab defaultOpen="definitions" divId="definitions,lang_and_money,access,theme"  divLang="#getLang('','Stoklar',58166)#;#getLang('','İşlemler',57777)#;#getLang('','çizim',60648)# #getLang('','ve','57989')# #getLang('','belgeler','57568')#;#getLang('','kalite',59157)# #getLang('','tanımları',132)#">       
        <div id="unique_definitions" class="ui-info-text uniqueBox uniqueBox_new">
            <cfform name="add_control" method="post" action="#request.self#?fuseaction=prod.emptypopup_addQualityControl">
                <input type="hidden" name="p_order_id" value="<cfoutput>#attributes.p_order_id#</cfoutput>">
                <input type="hidden" name="list_type" value="<cfoutput>#attributes.list_type#</cfoutput>">
                <input type="hidden" name="part" value="<cfoutput>#attributes.part#</cfoutput>">
            <cf_flat_list>
                <thead>
                    <tr>
                    </tr>
                </thead>
                <tbody>
                    <div class="op_item_detail_2">
                        <div class="op_item_detail_info_2">
                            <cfoutput>
                                <div class="op_item_detail_left_2">
                                    <h1 class="op_detail_content_title">#GET_DET_PO.PRODUCT_NAME#- #GET_DET_PO.QUANTITY# #GET_DET_PO.MAIN_UNIT#</h1>
                                </div>
                            </cfoutput>
                        </div>
                    </div>
                    <cfif len(GET_DET_PO.STOCKS_JSON)><cfset get_stock_ids=deserializeJSON(GET_DET_PO.STOCKS_JSON)></cfif>
                    <cfloop query="GET_DET_PRO">
                        <cfoutput>
                            <tr>
                                <cfset toplam_miktar_='#GET_DET_PO.QUANTITY#'*'#AMOUNT#'>
                                <td>#currentrow#</td>
                                <td class="text-center" width="80">
                                    <cfif len(GET_DET_PRO.PATH)>
                                        <img src="documents/product/#GET_DET_PRO.PATH#" width="70" height="70">
                                    <cfelse>
                                        <img src="../images/production/no-image.png" width="70" height="70">
                                    </cfif>
                                </td>
                                <td>#PRODUCT_CODE#</td>
                                <td>#product_name#</td>
                                <td>#toplam_miktar_##maın_unıt#</td>
                                <td>
                                    <div class="checkbox checbox-switch">
                                        <label>
                                            <input type="hidden" name="stock_id" value="#STOCK_ID_MAIN#" checked="checked">
                                            <input type="checkbox" name="check_ids" value="#currentrow#" <cfif isDefined("get_stock_ids") and StructKeyExists(get_stock_ids,STOCK_ID_MAIN)>checked="checked"</cfif>>
                                            <span></span>
                                        </label>
                                    </div>
                                </td>
                            </tr>
                        </cfoutput>
                    </cfloop>
                </tbody>
            </cf_flat_list>
             </cfform>
        </div>
        <div id="unique_lang_and_money" class="ui-info-text uniqueBox uniqueBox_new">
            <cf_flat_list>
                <thead>
                    <tr>
                        <th width="30px"></th>
                        <th><cf_get_lang dictionary_id='61806.İşlem Tipi'></th>
                        <th class="text-right" width="10px"><cf_get_lang dictionary_id='33267.İşlem Miktarı'></th>
                       
                    </tr>
                </thead>
                <tbody>
                    <cfif GET_DET_OPERATIONS.recordcount>
                        <cfloop query="GET_DET_OPERATIONS">
                            <cfset toplam_miktar_='#GET_DET_PO.QUANTITY#'*'#AMOUNT#'>
                            <cfoutput>
                                    <tr>
                                        <td>#currentrow#</td>
                                        <td>#OPERATION_TYPE#</td>
                                        <td>#toplam_miktar_#</td>
                                    </tr>
                            </cfoutput>
                        </cfloop>
                    <cfelse>
                        <tr class="color-row" height="20">
                            <td colspan="15"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_flat_list>
        </div>
        <div id="unique_access" class="ui-info-text uniqueBox uniqueBox_new">
            <cf_wrk_images pid="#GET_DET_PO.PRODUCT_ID#" type="product"  style="1" no_border="1">
            <cf_get_workcube_asset asset_cat_id="-3" module_id='35' action_section='PRODUCT_TREE' action_id='#GET_DET_PO.stock_id#'  style="1" no_border="1">
        </div>
        <div id="unique_theme" class="ui-info-text uniqueBox uniqueBox_new">
            <cfset get_product_quality_types = createObject("component","V16.settings.cfc.setupQualityControlType").getProductQualityTypes(dsn3:dsn3,product_id:get_det_po.product_id)>
            <cfif get_product_quality_types.recordcount>
                <cfset is_upd_ = "1">
            <cfelse>
                <cfset is_upd_ = "0">
            </cfif>
                <div id="kalite_kontrol_list" >
                    <cf_flat_list>
                        <thead>
                            <tr>
                                <th width="350" nowrap><cf_get_lang dictionary_id='37665.Kontrol Tipi'></th>
                                <th width="75"><cf_get_lang dictionary_id='33137.Standart'>-<cf_get_lang dictionary_id='33616.Değer'></th>
                                <th width="75"><cf_get_lang dictionary_id='29443.Tolerans'>(+)</th>
                                <th width="75"><cf_get_lang dictionary_id='29443.Tolerans'> (-)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfif get_product_quality_types.recordcount>
                                <cfoutput query="get_product_quality_types">
                                    <tr>
                                        <td>
                                           #QUALITY_CONTROL_TYPE#<cfif len(get_product_quality_types.type_description)>-#type_description#</cfif>
                                        </td>
                                        <td class="text-right">#tlformat(default_value,4)#</td>
                                        <td class="text-right">#tlformat(tolerance,4)#</td>
                                        <td class="text-right">#tlformat(tolerance_2,4)#</td>
                                    </tr>
                                </cfoutput>
                            </cfif>
                        </tbody>
                    </cf_flat_list>
                </div>
            
        </div>
        <div class="ui-form-list-btn flex-start">
            <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra_blue ui-wrk-btn-addon-left"><i class="fa fa-print"></i> <cf_get_lang dictionary_id='57474.Yazdır'></a> 
            <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-center" onclick="rejection()"><i  class="fa fa-puzzle-piece"></i> <cf_get_lang dictionary_id='29537.Red'></a>
            <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra_green ui-wrk-btn-addon-center" onclick="assent()"><i  class="fa fa-puzzle-piece"></i> <cf_get_lang dictionary_id='58475.Onayla'></a>
        </div>
    </cf_tab>
</cf_box>
<script>
    
    function assent(){
        var data = new FormData();  
        data.append("p_order_id", <cfoutput>#attributes.p_order_id#</cfoutput>);
        AjaxControlPostData('V16/production_plan/cfc/production_plan_graph.cfc?method=updateProductionControl', data, function(response) {
            console.log(response);
            add_control.submit();
                });
    }
    function rejection(){
        var data = new FormData();  
        data.append("p_order_id", <cfoutput>#attributes.p_order_id#</cfoutput>);
        AjaxControlPostData('V16/production_plan/cfc/production_plan_graph.cfc?method=updateProductionRejection', data, function(response) {
            console.log(response);
            location.reload();
                });
    }
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
    