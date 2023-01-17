<cfquery name="get_virtual_p_order" datasource="#dsn3#">
	SELECT        
        IFLOW_P_ORDER_ID, 
        PRODUCT_TYPE, 
        STOCK_ID, 
        START_DATE, 
        FINISH_DATE, 
        QUANTITY, 
        DETAIL, 
        LOT_NO
	FROM          
    	EZGI_IFLOW_PRODUCTION_ORDERS
	WHERE        
    	MASTER_PLAN_ID = #attributes.iflow_master_plan_id# AND 
        IFLOW_P_ORDER_ID IN (#attributes.iid#) AND 
        REL_P_ORDER_ID IS NULL
</cfquery>
<cfquery name="get_defaults" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_DEFAULTS
</cfquery>

<cfif Listlen(attributes.iid)>
	<cfquery name="get_virtual_p_order" datasource="#dsn3#">
    	SELECT        
        	E.IFLOW_P_ORDER_ID,
            E.ORDER_ROW_ID,
            (SELECT ORDER_ID FROM ORDER_ROW WHERE ORDER_ROW_ID = E.ORDER_ROW_ID) AS ORDER_ID,
            E.PRODUCT_TYPE, 
            E.STOCK_ID, 
            E.START_DATE, 
            E.FINISH_DATE, 
            E.QUANTITY, 
            E.DETAIL, 
            E.LOT_NO, 
            S.PRODUCT_NAME,
            E.SPECT_MAIN_ID,
            (
            	SELECT        
                	TOP (1) SPECT_MAIN_NAME
				FROM     
                	SPECT_MAIN
				WHERE        
                	SPECT_MAIN_ID = S.STOCK_ID AND 
                    SPECT_STATUS = 1
				ORDER BY 
                	STOCK_ID DESC
            ) AS SPECT_MAIN_NAME,
            (SELECT MAIN_UNIT FROM #dsn1_alias#.PRODUCT_UNIT WHERE PRODUCT_UNIT_STATUS = 1 AND PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT,
            (SELECT TOP (1) WS_ID FROM WORKSTATIONS_PRODUCTS WHERE STOCK_ID = S.STOCK_ID) AS STATION_ID
		FROM            
        	EZGI_IFLOW_PRODUCTION_ORDERS AS E INNER JOIN
          	STOCKS AS S ON E.STOCK_ID = S.STOCK_ID
		WHERE        
        	E.MASTER_PLAN_ID = #attributes.iflow_master_plan_id# AND 
            E.IFLOW_P_ORDER_ID IN (#attributes.iid#) AND 
            S.IS_KARMA = 0 AND
            E.PRODUCT_TYPE IN (2,3,4)<!--- AND 
            S.IS_PROTOTYPE = 0--->
      	UNION ALL
    	SELECT        
        	E.IFLOW_P_ORDER_ID, 
            E.ORDER_ROW_ID,
            (SELECT ORDER_ID FROM ORDER_ROW WHERE ORDER_ROW_ID = E.ORDER_ROW_ID) AS ORDER_ID,
            E.PRODUCT_TYPE, 
            K.STOCK_ID, 
            E.START_DATE, 
            E.FINISH_DATE, 
            K.PRODUCT_AMOUNT * E.QUANTITY AS QUANTITY, 
            E.DETAIL, 
            E.LOT_NO, 
            K.PRODUCT_NAME, 
          	K.SPEC_MAIN_ID SPECT_MAIN_ID,
            (
            	SELECT        
                	TOP (1) SPECT_MAIN_NAME
				FROM     
                	SPECT_MAIN
				WHERE        
                	SPECT_MAIN_ID = K.SPEC_MAIN_ID AND 
                    SPECT_STATUS = 1
				ORDER BY 
                	STOCK_ID DESC
            ) AS SPECT_MAIN_NAME,
            (SELECT MAIN_UNIT FROM #dsn1_alias#.PRODUCT_UNIT WHERE PRODUCT_UNIT_STATUS = 1 AND PRODUCT_ID = K.PRODUCT_ID AND IS_MAIN = 1) AS UNIT,
            (SELECT TOP (1) WS_ID FROM WORKSTATIONS_PRODUCTS WHERE STOCK_ID = K.STOCK_ID) AS STATION_ID
		FROM      
        	EZGI_IFLOW_PRODUCTION_ORDERS AS E INNER JOIN
         	STOCKS AS S ON E.STOCK_ID = S.STOCK_ID INNER JOIN
       		#dsn1_alias#.KARMA_PRODUCTS AS K ON S.PRODUCT_ID = K.KARMA_PRODUCT_ID
		WHERE        
        	E.MASTER_PLAN_ID = #attributes.iflow_master_plan_id# AND 
            E.IFLOW_P_ORDER_ID IN (#attributes.iid#) AND 
            E.PRODUCT_TYPE = 2 AND 
            S.IS_KARMA = 1
    </cfquery>
</cfif>

<cfset attributes.islem_id = -1>
<cfset attributes.is_collacted = 1>
<cfset attributes.is_manuel = 1>
<cfset attributes.IS_SELECT_SUB_PRODUCT = 1>
<cfset attributes.is_demand = 0>
<cfset attributes.PROCESS_STAGE = get_process_type.PROCESS_ROW_ID>
<cfset attributes.PROJECT_HEAD = ''>
<cfset attributes.PROJECT_ID= ''>
<cfset attributes.STAGE_INFO= ''>
<cfset attributes.record_num = get_virtual_p_order.recordcount>
<cfset _KEYWORD_ = 'Üretim Emri'>
<cfif get_virtual_p_order.recordcount>
    <cfloop query="get_virtual_p_order">
        <cfset attributes.master_alt_plan_id = IFLOW_P_ORDER_ID>
        <cfset 'lot_no#currentrow#' = LOT_NO>
        <cfset 'attributes.demand_no#currentrow#' = ''>
        <cfset 'attributes.finish_date#currentrow#' = DateFormat(finish_date,'DD/MM/YYYY')>
        <cfset 'attributes.finish_h#currentrow#' = TimeFormat(finish_date,'HH')>
        <cfset 'attributes.finish_m#currentrow#' = TimeFormat(finish_date,'MM')>>
        <cfset 'attributes.start_date#currentrow#' = DateFormat(start_date,'DD/MM/YYYY')>
        <cfset 'attributes.start_h#currentrow#' = TimeFormat(start_date,'HH')>>
        <cfset 'attributes.start_m#currentrow#' = TimeFormat(start_date,'MM')>
        <cfset 'attributes.is_line_number#currentrow#' = 0>
        <cfset 'attributes.order_id#currentrow#' = ORDER_ID>
        <cfset 'attributes.order_row_id#currentrow#' = ORDER_ROW_ID>
        <cfset 'attributes.product_name#currentrow#' = PRODUCT_NAME>
        <cfset 'attributes.quantity#currentrow#' = QUANTITY>
        <cfset 'attributes.ROW_KONTROL#currentrow#' = 1>
        <cfset 'attributes.SPECT_MAIN_ID#currentrow#' = SPECT_MAIN_ID>
        <cfset 'attributes.SPECT_VAR_ID#currentrow#' = ''>
        <cfset 'attributes.SPECT_VAR_NAME#currentrow#' = SPECT_MAIN_NAME>
        <cfset 'attributes.STATION_ID_#currentrow#_0' = STATION_ID>
        <cfset 'attributes.STATION_NAME_#currentrow#' = ''>
        <cfset 'attributes.STOCK_ID#currentrow#' = STOCK_ID>
        <cfset 'attributes.UNIT#currentrow#' = UNIT>
        <cfset 'attributes.WRK_ROW_RELATION_ID#currentrow#' = ''>
    </cfloop>
    <cfinclude template="add_ezgi_production_order_all_sub.cfm">
</cfif>
<cfquery name="upd_p_order" datasource="#dsn3#">
	UPDATE       
    	PRODUCTION_ORDERS
	SET                
    	P_ORDER_NO = RIGHT(PRODUCTION_ORDERS.P_ORDER_NO, LEN(PRODUCTION_ORDERS.P_ORDER_NO) - 1)
	FROM            
    	EZGI_IFLOW_PRODUCTION_ORDERS AS E INNER JOIN
     	PRODUCTION_ORDERS ON E.LOT_NO = PRODUCTION_ORDERS.LOT_NO
	WHERE        
    	E.IFLOW_P_ORDER_ID IN (#attributes.iid#) AND 
        LEFT(PRODUCTION_ORDERS.P_ORDER_NO, 1) = '-'
</cfquery>
<script type="text/javascript">
	alert('<cf_get_lang_main no='3456.Üretim Emirleri Başarıyla Oluşturulmuştur'>');
  	wrk_opener_reload();
 	window.close();
</script>