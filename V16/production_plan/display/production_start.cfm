<style>
    .ui-draggable-box .ui-form-list-btn {
        position: sticky;
        bottom: -10px;
        left: 10px;
        right: 10px;
        z-index: 99;
        background-color: #fff;
        justify-content: center !important;
    }
    .portBox .portHeadLight{
        margin:0 28px!important;
        border-bottom:0px!important;
        padding-top:20px;
    }
    .portHeadLightMenu{
        margin-right:-5px;
    }
    .portBox .portHeadLightTitle span a {
        color: #44b6ae!important;
        font-size: 22px!important;
    }
    .ui-wrk-btn-extra_green{
        background-color: green!important;
        color: white!important;
        transition: .4s;
    }
    .ui-wrk-btn-extra_blue{
        background-color:#007bff!important;
        color: white!important;
        transition: .4s;
    }
    .grey-btn-list h2 {
        display: flex;
        margin:0;
        color: #555;
        justify-content: center !important;
    }
    .catalystClose {
        font-size: 30px!important;
    }
    .form-group input[type=text], .form-group input[type=search], input[type=search], .form-group input[type=number], .form-group input[type=password], .form-group input[type=file], .form-group select {
        min-height: 40px;
        font-size: 18px;
    }
    .maxi .portHeadLightMenu > ul > li > a{
        color:#FF9B05!important;
    }
    .maxi .portHeadLightMenu > ul > li > a:hover{
        color:#FF9B05!important;
        background-color:white!important;
    }
    .h1_text{
        color:red!important;font-size: 18px;
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
        PU.MAIN_UNIT_ID,
        PO.START_DATE_REAL,
        PO.FINISH_DATE_REAL,
        PU.MAIN_UNIT,
        POR.P_ORDER_ID,
        POR.PR_ORDER_ID,
        SPP.P_ORDER_ID,
        SPP.PROD_PAUSE_TYPE_ID,
        SPT.PROD_PAUSE_TYPE_ID,
        SPT.PROD_PAUSE_TYPE,
        SPP.PROD_PAUSE_ID
    FROM
        PRODUCTION_ORDERS PO
        LEFT JOIN PRODUCTION_ORDER_RESULTS POR ON POR.P_ORDER_ID =PO.P_ORDER_ID
        LEFT JOIN SETUP_PROD_PAUSE SPP  ON SPP.P_ORDER_ID =PO.P_ORDER_ID
        LEFT JOIN SETUP_PROD_PAUSE_TYPE SPT ON SPT.PROD_PAUSE_TYPE_ID =SPP.PROD_PAUSE_TYPE_ID 
        LEFT JOIN STOCKS S ON S.STOCK_ID = PO.STOCK_ID  
        LEFT JOIN PRODUCT P ON  P.PRODUCT_ID = S.PRODUCT_ID  
        LEFT JOIN PRODUCT_UNIT PU ON  PU.PRODUCT_ID = P.PRODUCT_ID 
    
     WHERE 
     PO.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
   
</cfquery>



<cfquery name="get_pauseType" datasource="#dsn3#">
	SELECT 
		*
	FROM 
		SETUP_PROD_PAUSE_TYPE 
        
      
</cfquery>

    <cfsavecontent  variable="message"><cfif isdefined("production_order_result") and len(production_order_result)><cf_get_lang dictionary_id='63169.Geçici Durdurma'><cfelse><cf_get_lang dictionary_id='38059.Üretime Başla'></cfif></cfsavecontent>

<cf_box title="#message#"  box_style="maxi" popup_box="1" settings="0" closable="1" resize="0"  collapsable="0" >
    <div class="grey-btn-list">
        <h2><cfoutput>#GET_DET_PO.p_order_no# <br/><cf_get_lang dictionary_id='38869.Lot'>: #GET_DET_PO.lot_no# </cfoutput></h2>
    </div>
    <cfoutput>
        <h1 class="text-center h1_text">#GET_DET_PO.PRODUCT_NAME#- #GET_DET_PO.QUANTITY# #GET_DET_PO.MAIN_UNIT# </h1>
    </cfoutput>
    <cfform name="production_start"  enctype="multipart/form-data" method="post">
        <cfinput type="hidden" name="p_order_id" id="p_order_id" value="#attributes.p_order_id#">
        <cfif isdefined("attributes.production_order_result") and len(attributes.production_order_result)>
            <input name="PR_ORDER_ID" id="PR_ORDER_ID" type="hidden" <cfif isdefined("GET_DET_PO.PR_ORDER_ID")>value="<cfoutput>#GET_DET_PO.PR_ORDER_ID#</cfoutput>"</cfif>>
            <div class="form-group" id="item-start_date">
                <div class="col col-6 col-xs-12">
                    <div class="input-group ">
                        <cfoutput><input required="Yes" type="text" name="FINISH_DATE_REAL" id="FINISH_DATE_REAL" validate="#validate_style#" <cfif isdefined("get_det_po.FINISH_DATE_REAL") and len(get_det_po.FINISH_DATE_REAL)>value="#dateformat(get_det_po.FINISH_DATE_REAL,dateformat_style)#"<cfelse>value="#dateformat(now(),dateformat_style)#"</cfif>></cfoutput>
                        <span class="input-group-addon"><cf_wrk_date_image date_field="FINISH_DATE_REAL"></span>
                    </div>
                </div>
                <div class="col col-3 col-xs-12">
                    <cfoutput>
                        <cfif len(get_det_po.FINISH_DATE_REAL)>
                            <cf_wrkTimeFormat  name="finish_h" id="finish_h" value="#timeformat(get_det_po.FINISH_DATE_REAL,'HH')#">
                        <cfelse>
                            <cf_wrkTimeFormat  name="finish_h" id="finish_h" value="#timeformat(now(),'HH')#">
                        </cfif>
                    </cfoutput>
                </div>
                <div class="col col-3 col-xs-12">
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
            </div>
            <div class="form-group" id="item-PROD_PAUSE_TYPE_ID">
                <div class="col col-12 col-xs-12">
                     <select name="PROD_PAUSE_TYPE_ID" id="PROD_PAUSE_TYPE_ID">
                        <option value=""><cf_get_lang dictionary_id='55550.Gerekçe'> <cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_pauseType">
                            <option value="#PROD_PAUSE_TYPE_ID#" <cfif PROD_PAUSE_TYPE_ID eq GET_DET_PO.PROD_PAUSE_TYPE_ID>selected</cfif> >#PROD_PAUSE_TYPE#</option> 
                        </cfoutput>
                    </select> 
                </div>
            </div>
            <cfif isdefined("GET_DET_PO.PROD_PAUSE_TYPE_ID") and len(GET_DET_PO.PROD_PAUSE_TYPE_ID)>
                <cfset attributes.PROD_PAUSE_ID=GET_DET_PO.PROD_PAUSE_ID>
                <cfinput name="PROD_PAUSE_ID" type="hidden" id="PROD_PAUSE_ID" value="#attributes.PROD_PAUSE_ID#">
            </cfif>
            <div class="ui-form-list-btn flex-start">
                <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra_blue ui-wrk-btn-addon-center" onclick="stop()"><i class="fa fa-stop"></i> <cf_get_lang dictionary_id='63839.Dur'></a>
            </div>
        <cfelse>
            <div class="form-group" id="item-start_date">
                <div class="col col-6 col-xs-12">
                    <div class="input-group ">
                        <cfoutput>
                            <input required="Yes" type="text" name="START_DATE_REAL" id="START_DATE_REAL" validate="#validate_style#" <cfif isdefined("get_det_po.START_DATE_REAL") and len(get_det_po.START_DATE_REAL)>value="#dateformat(get_det_po.START_DATE_REAL,dateformat_style)#"<cfelse>value="#dateformat(now(),dateformat_style)#"</cfif>>
                        </cfoutput>
                        <span class="input-group-addon"><cf_wrk_date_image date_field="START_DATE_REAL"></span>
                    </div>
                </div>
                <div class="col col-3 col-xs-12">
                    <cfoutput>
                        <cfif len(get_det_po.START_DATE_REAL)>
                            <cf_wrkTimeFormat  name="start_h" id="start_h" value=">#timeformat(get_det_po.START_DATE_REAL,'HH')#">
                        <cfelse>
                            <cf_wrkTimeFormat  name="start_h" id="start_h" value="#timeformat(now(),'HH')#">
                        </cfif>
                    </cfoutput>
                </div><!--- #dateformat(now(),dateformat_style)# --->
                <div class="col col-3 col-xs-12">
                     <cfoutput>
                        <cfif len(get_det_po.START_DATE_REAL)>
                            <select name="start_m" id="start_m">
                                <cfloop from="0" to="59" index="i">
                                    <option value="#i#" <cfif timeformat(get_det_po.START_DATE_REAL,'mm') eq i>selected</cfif>><cfif i lt 10>0</cfif>#I#</option>
                                </cfloop>
                            </select>
                        <cfelse>
                            <select name="start_m" id="start_m">
                                <cfloop from="0" to="59" index="i">
                                    <option value="#i#" <cfif timeformat(now(),'mm') eq i>selected</cfif>><cfif i lt 10>0</cfif>#I#</option>
                                </cfloop>
                            </select>
                        </cfif>
                    </cfoutput>
                </div>
            </div>
            
            <div class="ui-form-list-btn flex-start">
                <a href="javascript://"  class="ui-wrk-btn ui-wrk-btn-extra_green ui-wrk-btn-addon-center" onclick="start()"><i class="fa fa-play"></i> <cf_get_lang dictionary_id='63838.Başla'> </a>
            </div>
        </cfif>
        
    </cfform>
</cf_box>
<script>
        function start(){
 
       
            var data = new FormData();  
            data.append("START_DATE_REAL", $("#START_DATE_REAL").val());
            data.append("start_h", $("#start_h").val());
            data.append("start_m", $("#start_m").val());
           
            data.append("p_order_id", <cfoutput>#attributes.p_order_id#</cfoutput>);
            AjaxControlPostData('V16/production_plan/cfc/production_plan_graph.cfc?method=updateProductionOrderLot', data, function(response) {
                console.log(response);
                 location.reload();
                    });
        }
        function stop(){
            var data = new FormData();  
            data.append("FINISH_DATE_REAL", $("#FINISH_DATE_REAL").val());
            data.append("finish_h", $("#finish_h").val());
            data.append("finish_m", $("#finish_m").val());
            data.append("PR_ORDER_ID", $("#PR_ORDER_ID").val());
            <cfif isdefined("attributes.production_order_result") and len(attributes.production_order_result)>
                data.append("PROD_PAUSE_TYPE_ID", $("#PROD_PAUSE_TYPE_ID").val());
            </cfif>
            <cfif isdefined("attributes.PROD_PAUSE_ID") and len(attributes.PROD_PAUSE_ID)>
            data.append("PROD_PAUSE_ID",<cfoutput>#attributes.PROD_PAUSE_ID#</cfoutput>);
            </cfif>
            
            data.append("p_order_id", <cfoutput>#attributes.p_order_id#</cfoutput>);
            AjaxControlPostData('V16/production_plan/cfc/production_plan_graph.cfc?method=updateProductionOrderStop', data, function(response) {
                console.log(response);
                 location.reload(); 
                    });
 
}
</script>