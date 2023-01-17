<cfparam name="attributes.modal_id">
<cfquery name="GET_DET_PO" datasource="#dsn3#">
    SELECT 
        PO.* ,
        S.STOCK_ID,
        S.PRODUCT_ID,
        P.PRODUCT_ID,
        P.PRODUCT_NAME,
        P_I.PATH_SERVER_ID, 
        P_I.PATH,
        ISNULL(PO.SPEC_MAIN_ID,0) AS SPEC_MAIN_ID,
        S.STOCK_CODE,
        S.PRODUCT_NAME,
        PT.STOCK_ID,
        PT.OPERATION_TYPE_ID,
        PT.PRODUCT_ID,
        OT.OPERATION_TYPE_ID,
        OT.OPERATION_TYPE
    
    FROM
        PRODUCTION_ORDERS PO
        LEFT JOIN PRODUCT_TREE PT ON PT.STOCK_ID=PO.STOCK_ID
        LEFT JOIN OPERATION_TYPES OT ON OT.OPERATION_TYPE_ID=PT.OPERATION_TYPE_ID
        LEFT JOIN STOCKS S ON S.STOCK_ID = PO.STOCK_ID  
        LEFT JOIN PRODUCT P ON  P.PRODUCT_ID = S.PRODUCT_ID
        LEFT JOIN #DSN1#.PRODUCT_IMAGES P_I ON  P_I.PRODUCT_ID = S.PRODUCT_ID   
     WHERE 
     PO.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
     AND 
     PT.OPERATION_TYPE_ID IS NOT NULL
</cfquery>
<cfif GET_DET_PO.recordCount eq 0>
    <script>alert("<cf_get_lang dictionary_id='65386.İşlem Bulunamadı.'> !");
        closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
    </script>
   <cfabort>
</cfif>
<style>
    .text-font{
        color:#555;
        text-align:right;
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
    .ui-form-list-btn {
        justify-content: center !important;
    }
    .scroll ~ .ui-form-list-btn, .ui-scroll ~ .ui-form-list-btn{
        border-top:1px solid #bbb!important;
    }
    .ajax_list > thead tr th {
        font-size: 18px;
    }
    .scrollContent::-webkit-scrollbar-thumb {
        background-color: #FFCC66;
        border-radius: 10px;
    }
    .scrollContent::-webkit-scrollbar {
        width: 15px;
        height: 8px;
    }
    .catalystClose {
        font-size: 35px!important;
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
    input {
        border-width: 0px;
        border-top-width: 0px;
        border-right-width: 0px;
        border-bottom-width: 0px;
        border-left-width: 0px;
    }
    .ui-wrk-btn-extra{
        background-color: #00b046!important;
    }
    .ui-wrk-btn-extra_blue{
        background-color: #007bff!important;
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
    }
    .ui-draggable-box .ui-scroll table thead tr th{
        border-bottom:white!important;
    }
</style>
<cfquery name="GET_PRODUCTION_OPERATIONS" datasource="#DSN3#">
	SELECT
    	PO.OPERATION_TYPE_ID,
    	(SELECT OPERATION_TYPE FROM OPERATION_TYPES WHERE OPERATION_TYPES.OPERATION_TYPE_ID=PO.OPERATION_TYPE_ID) AS OPERATION_TYPE,
    	ISNULL(O_MINUTE,0) AS O_MINUTE,
        (SELECT STATION_NAME FROM WORKSTATIONS WS WHERE WS.STATION_ID = PO.STATION_ID) AS STATION_NAME,
		PO.AMOUNT,
		PO.P_OPERATION_ID,
		PO.STATION_ID,
		ISNULL((SELECT SUM(POR.REAL_AMOUNT) FROM PRODUCTION_OPERATION_RESULT POR WHERE POR.OPERATION_ID = PO.P_OPERATION_ID AND POR.P_ORDER_ID = #attributes.p_order_id#),0) RESULT_AMOUNT
	FROM
		PRODUCTION_OPERATION PO
	WHERE
		PO.P_ORDER_ID = #attributes.p_order_id#
	ORDER BY
		PO.P_OPERATION_ID
</cfquery>
<cfset operation_type_id_list = listdeleteduplicates(ValueList(GET_PRODUCTION_OPERATIONS.OPERATION_TYPE_ID,','))>
<cfif len(operation_type_id_list)>
    <cfquery name="GET_STATIONS" datasource="#DSN3#">
        SELECT
        	0 AS MAIN_STOCK_ID ,
        	W.STATION_ID AS STATION_ID_ ,
            W.STATION_NAME,
            WP.OPERATION_TYPE_ID,
			ISNULL(WP.PRODUCTION_TIME,0) P_TIME
        FROM 
            WORKSTATIONS W,
            WORKSTATIONS_PRODUCTS WP
        WHERE
        	W.STATION_ID = WP.WS_ID 
            AND WP.OPERATION_TYPE_ID IN (#operation_type_id_list#)
    </cfquery>
<cfelse>
	<cfset GET_STATIONS.recordcount = 0>
</cfif>
    <cfquery name="get_stocks_name" datasource="#dsn3#">
        SELECT PRODUCT_NAME +'  '+ ISNULL(PROPERTY,'') AS PRODUCT_NAME,STOCK_ID,STOCK_CODE,MAIN_UNIT FROM STOCKS,PRODUCT_UNIT WHERE PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND STOCK_ID IN (#GET_DET_PO.STOCK_ID#) ORDER BY STOCK_ID
    </cfquery>
    <cf_box  title="#getLang('','İşlem Sonucu','63847')#" popup_box="1" closable="1" resize="0"  collapsable="0" >
        <div class="op_item_upside" style="display:flex;align-items:center;margin-top:-30px;">
            <div class="op_item_barcode" style="margin:5px;">
                <cfoutput><cf_workcube_barcode show="1" type="qrcode" width="100" height="100" value="#GET_DET_PO.P_ORDER_NO#/#GET_DET_PO.lot_no#"></cfoutput>
            </div>
            <div class="op_item_product_lot" style="font-weight:bold;font-size:16px;">
                
                <cfoutput>#GET_DET_PO.P_ORDER_NO# / <cf_get_lang dictionary_id='38869.Lot'> : #GET_DET_PO.lot_no#</cfoutput>	
            </div>
            <div class="op_item_upside_right" style="margin-left:auto;display:flex;align-items: center;">
                <div class="op_item_upside_text" style="margin-right:5px;font-weight:bold;font-size:16px">
                    <cfoutput><p>#GET_DET_PO.PRODUCT_NAME#</p>
                    <p>#GET_DET_PO.QUANTITY# #get_stocks_name.MAIN_UNIT#</p></cfoutput>
                </div>
                <cfoutput>
                    <cfif isdefined("GET_DET_PO.PATH") and len(GET_DET_PO.PATH)>
                        <img src="documents/product/#GET_DET_PO.PATH#" border="0" height="70px" width="70px" style="border-radius:50%;">
                    <cfelse>
                        <img src="/images/tamir_k2.jpg" border="0" height="70px" width="70px" style="border-radius:50%;">
                    </cfif>
                </cfoutput>
            </div>
        </div>
        <cfform name="production_result_operations"  action="#request.self#?fuseaction=prod.emptypopup_addOperationResult&part=#attributes.part#&list_type=#attributes.list_type#"  enctype="multipart/form-data" method="post">
            <cf_flat_list>
                <thead>
                    <tr>
                        <th width="30px"></th>
                        <th><cf_get_lang dictionary_id='61806.İşlem Tipi'></th>
                        <th class="text-center"><cf_get_lang dictionary_id='57951.Hedef'><cf_get_lang dictionary_id='57635.Miktar'></th>
                        <th class="text-center"><cf_get_lang dictionary_id='58444.Kalan'><cf_get_lang dictionary_id='57635.Miktar'></th>
                        <th width="150px"><cf_get_lang dictionary_id='58834.İstasyon'></th>
                        <th class="text-center" style="max-width:120px !important;" width="30px"><cf_get_lang dictionary_id='55688.Gerçekleşen'><br><cf_get_lang dictionary_id='57635.Miktar'></th>
                        <th class="text-center" style="max-width:60px !important;" width="10px"><cf_get_lang dictionary_id='29471.Fire'><br><cf_get_lang dictionary_id='63411.Miktarı'></th>
                        <th class="text-center" width="10px"><cf_get_lang dictionary_id='65410.Harcanan Süre'><br><cf_get_lang dictionary_id="65412.Sa Dk"></th>
                        <th class="text-center" width="10px"><cf_get_lang dictionary_id='36517.Duruş Süresi'><br><cf_get_lang dictionary_id="65412.Sa Dk"></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif GET_DET_PO.recordcount>
                        <input type="hidden" name="from_prod" id="from_prod" value="1">
                        <input type="hidden" name="STOCK_ID" id="STOCK_ID" value="<cfoutput>#attributes.STOCK_ID#</cfoutput>">
                        <input type="hidden" name="upd_id" id="upd_id" value="<cfoutput>#attributes.p_order_id#</cfoutput>">
                        <input type="hidden" name="operation_count" id="operation_count" value="<cfoutput>#GET_PRODUCTION_OPERATIONS.RECORDCOUNT#</cfoutput>">
                         <cfoutput query="GET_PRODUCTION_OPERATIONS">
                            <input type="hidden" name="employee_id_#CURRENTROW#" id="employee_id_#CURRENTROW#" value="#session.ep.userid#">
                            <input type="hidden" name="employee_name_#CURRENTROW#" id="employee_name_#CURRENTROW#" value="#get_emp_info(session.ep.userid,0,0)#" class="text">    
                            <cfquery name="GET_STATIONS___" dbtype="query">
                                SELECT * FROM GET_STATIONS WHERE OPERATION_TYPE_ID = #operation_type_id#
                            </cfquery>
                            <input type="hidden" name="operation_id_#currentrow#" id="operation_id_#currentrow#" value="#p_operation_id#">
                            <tr>
                                <td width="25">#currentrow#</td>
                                <td nowrap>#OPERATION_TYPE#</td>
                                <td class="text-center">#TLformat(AMOUNT)#</td>
                                <td class="text-center">#TLformat(AMOUNT-RESULT_AMOUNT)#</td>
                                <td>
                                    <select name="station_id_#CURRENTROW#" id="Station_id_#CURRENTROW#" class="text-font" style="cursor:pointer;height:40px;background-color:##e5e5e5;border:0px;min-width: 170px;">
                                        <cfloop query="GET_STATIONS___">
                                            <option value="#STATION_ID_#;#P_TIME#"style="text-align:left;"<cfif MAIN_STOCK_ID eq 0>style="background:##CCCCCC"</cfif><cfif STATION_ID_ eq GET_PRODUCTION_OPERATIONS.STATION_ID>selected</cfif>>#STATION_NAME#</option>
                                        </cfloop>
                                    </select>
                                </td>
                                <cfif (AMOUNT-RESULT_AMOUNT) gt 0>
                                    <cfset row_amount = AMOUNT-RESULT_AMOUNT>
                                <cfelse>
                                    <cfset row_amount = 0>
                                </cfif>
                                <input type="hidden" name="target_amount#CURRENTROW#" id="target_amount#CURRENTROW#" value="#TLformat(AMOUNT)#">
                                <input type="hidden" name="Realized_duration_#CURRENTROW#" id="Realized_duration_#CURRENTROW#">
                                <input type="hidden" name="Duration_time_#CURRENTROW#" id="Duration_time_#CURRENTROW#">
                                <td><input onclick="this.select();" class="text-font" style="font-size:15px;height:40px;width:120px;padding: 0px 10px 0px 10px;background-color:##fec97b;font-weight:bold;" type="text" onchange="amount_limit(#currentrow#)" name="realized_amount_#CURRENTROW#" id="Realized_amount_#CURRENTROW#" class="moneybox" value="#TlFormat(row_amount)#" onKeyup="return(FormatCurrency(this,event,4));"></td>
                                <td><input onclick="this.select();" class="text-font" style="font-size:15px;height:40px;width:60px;padding: 0px 10px 0px 10px;background-color:##e1e2c3;font-weight:bold;" type="text" name="fire_#CURRENTROW#" id="Fire_#CURRENTROW#" class="moneybox" value="#TlFormat(0)#" onKeyup="isNumber(this,1);return(FormatCurrency(this,event,4));"></td>
                                <td><input onclick="this.select();" class="text-font" style="font-size:15px;height:40px;width:50px;padding: 0px 5px 0px 10px;background-color:##d6e7f9;font-weight:bold;" type="text" name="hs_saat#CURRENTROW#" id="hs_saat#CURRENTROW#" value="0" class="moneybox" onKeyup="isNumber(this,1);return(FormatCurrency(this,event,4));"><input onclick="this.select();" type="text" class="text-left text-font" style="font-size:15px;height:40px;width:50px;padding: 0px 10px 0px 5px;background-color:##d5dce4;font-weight:bold;" name="hs_dakika#CURRENTROW#" id="hs_dakika#CURRENTROW#" value="0" class="moneybox" onKeyup="isNumber(this,1);return(FormatCurrency(this,event,4));"></td>
                                <td><input onclick="this.select();" class="text-font" style="font-size:15px;height:40px;width:50px;padding: 0px 5px 0px 10px;background-color:##d6e7f9;font-weight:bold;"  type="text" name="d_saat#CURRENTROW#" id="d_saat#CURRENTROW#" value="0" class="moneybox" onKeyup="isNumber(this,1);return(FormatCurrency(this,event,4));"><input onclick="this.select();" class="text-left text-font" style="font-size:15px;height:40px;width:50px;padding: 0px 10px 0px 5px;background-color:##d5dce4;font-weight:bold;" value="0"  type="text" name="d_dakika#CURRENTROW#" id="d_dakika#CURRENTROW#" class="moneybox" onKeyup="isNumber(this,1);return(FormatCurrency(this,event,4));"></td>
                                <td  class="text-right"><div class="checkbox checbox-switch"><label><input type="checkbox" <cfif row_amount lte 0 >disabled</cfif> name="is_record_#CURRENTROW#" id="is_record_#CURRENTROW#" value="1"><span></span></label></div></td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr class="color-row" height="20">
                            <td colspan="15"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_flat_list>
            <cfinput type="hidden" name="p_order_id" id="p_order_id"value="#attributes.p_order_id#">
            <cfinput type="hidden" name="is_stage" id="is_stage"value="2">
            <cf_box_footer>
                <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra_blue ui-wrk-btn-addon-left"><i class="fa fa-print"></i> <cf_get_lang dictionary_id='57474.Yazdır'></a> 
               <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-center" onclick="controlOperation()"><i class="icon-caret-right" style="font-size: 40px;margin: 0px 3px 3px 0px;"></i> <cf_get_lang dictionary_id='63846.Seçili İşlemleri Tamamla'></a>
               </cf_box_footer>
        </cfform>
    </cf_box>

    <script>
        function controlOperation(type)
        {
            var row_count_operation = <cfoutput>'#GET_PRODUCTION_OPERATIONS.recordcount#'</cfoutput>;
            for (var k=1;k<=row_count_operation;k++)
            {
                if(document.getElementById('is_record_'+k).checked == true){
                    if(document.getElementById('Station_id_'+k).value == "")
                    {
                        alert("<cf_get_lang dictionary_id='58837.Lütfen İstasyon Seçiniz'> ! <cf_get_lang dictionary_id='58508.Satır'>: "+ k);
                        return false;
                    }
            }}
            for (var k=1;k<=row_count_operation;k++)
            {
                document.getElementById('Realized_amount_'+k).value = filterNum(document.getElementById('Realized_amount_'+k).value,6);
                document.getElementById('Fire_'+k).value = filterNum(document.getElementById('Fire_'+k).value,6);
                realized_duration=parseFloat(document.getElementById('hs_dakika'+k).value)+(parseFloat(document.getElementById('hs_saat'+k).value)*60);
                duration_time=parseFloat(document.getElementById('d_dakika'+k).value)+(parseFloat(document.getElementById('d_saat'+k).value)*60);
                document.getElementById('Realized_duration_'+k).value=commaSplit(realized_duration,6);
                document.getElementById('Duration_time_'+k).value=commaSplit(duration_time,6);
                document.getElementById('Realized_duration_'+k).value = filterNum(document.getElementById('Realized_duration_'+k).value,6);
                document.getElementById('Duration_time_'+k).value = filterNum(document.getElementById('Duration_time_'+k).value,6);
            }
            production_result_operations.submit();
        }
        function amount_limit(id){
            console.log(parseFloat(filterNum($("#Realized_amount_"+id).val(),4)));
            console.log(parseFloat(filterNum($("#target_amount"+id).val(),4)));
              if(parseFloat(filterNum($("#Realized_amount_"+id).val(),4)) > parseFloat(filterNum($("#target_amount"+id).val(),4)))
              { 
                if(confirm( "<cf_get_lang dictionary_id='65417.Gerçekleşen miktar hedef miktardan fazla. Devam etmek istiyor musunuz?'>" )) 
                {
                    
                }
                else
                {
                    $("#Realized_amount_"+id).val(commaSplit(0,2));
                }
              }
        }
    </script>