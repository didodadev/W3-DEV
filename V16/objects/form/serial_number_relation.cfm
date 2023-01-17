<cfquery name="get_upper_seri_numbers" datasource="#dsn3#">
    SELECT  DISTINCT
        A.PROCESS_ID AS PROCESS_ID1,
        A.PROCESS_NO AS PROCESS_NO1,
        A.SERIAL_NO AS SERIAL_NO1,
        B.PROCESS_ID,
        B.PROCESS_NO,
        B.SERIAL_NO,
        A.STOCK_ID AS STOCK_ID1 ,
        B.STOCK_ID,
        ISNULL((SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID =  B.STOCK_ID) ,0) AS PRODUCT_NAME,
        ISNULL((SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID =  A.STOCK_ID) ,0) AS PRODUCT_NAME2,
        ISNULL((SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID =  C.STOCK_ID) ,0) AS PRODUCT_NAME3,
        C.PROCESS_ID AS PROCESS_ID3,
        C.SERIAL_NO as SERIAL_NO3,
        C.STOCK_ID AS STOCK_ID3,
        C.PROCESS_NO AS PROCESS_NO3
    FROM 
        SERVICE_GUARANTY_NEW A  
        JOIN SERVICE_GUARANTY_NEW B
        ON A.PROCESS_ID = B.MAIN_PROCESS_ID AND
        A.SERIAL_NO = B.MAIN_SERIAL_NO
        LEFT JOIN SERVICE_GUARANTY_NEW C
        ON C.PROCESS_ID = A.MAIN_PROCESS_ID AND
        C.SERIAL_NO = A.MAIN_SERIAL_NO
    WHERE 
        A.SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#product_serial_no#"> 
    <cfif isDefined("attributes.seri_stock_id") and len(attributes.seri_stock_id)>
        AND
        A.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#seri_stock_id#">
    </cfif>
</cfquery>
<cf_ajax_list>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='57657.Ürün'></th>
            <th><cf_get_lang dictionary_id='57637.Seri No'></th>
            <th width="60"><cf_get_lang dictionary_id='57468.Belge'></th>
        </tr>
     </thead>
     <cfif get_upper_seri_numbers.recordcount>
     <tbody>
            <tr>
            <cfoutput>
                <cfif len(get_upper_seri_numbers.PROCESS_ID3)>
                    <cfquery name="GET_PR_IDS" datasource="#dsn3#">
                        SELECT P_ORDER_ID FROM PRODUCTION_ORDER_RESULTS WHERE PR_ORDER_ID = #get_upper_seri_numbers.PROCESS_ID3#
                    </cfquery>
                    <cfset main_process_id = '#get_upper_seri_numbers.PROCESS_ID3#'>
                    <td style="color:##F00">#get_upper_seri_numbers.PRODUCT_NAME3#</td>
                    <td>#get_upper_seri_numbers.SERIAL_NO3#</td>
                    <td><a class="tableyazi" target="_blank" href="#request.self#?fuseaction=prod.upd_prod_order_result&p_order_id=#GET_PR_IDS.P_ORDER_ID#&pr_order_id=#get_upper_seri_numbers.PROCESS_ID3#">#get_upper_seri_numbers.PROCESS_NO3#</a></td>
                </cfif>
            </cfoutput>
            </tr>
            <tr>
            <cfoutput>
                <cfquery name="GET_PR_IDS" datasource="#dsn3#">
                    SELECT P_ORDER_ID FROM PRODUCTION_ORDER_RESULTS WHERE PR_ORDER_ID = #get_upper_seri_numbers.PROCESS_ID1#
                </cfquery>
                <cfset main_process_id = '#get_upper_seri_numbers.PROCESS_ID1#'>
                <td style="color:##F00">#get_upper_seri_numbers.PRODUCT_NAME2#</td>
                <td>#get_upper_seri_numbers.SERIAL_NO1#</td>
                <td><a class="tableyazi" target="_blank" href="#request.self#?fuseaction=prod.upd_prod_order_result&p_order_id=#GET_PR_IDS.P_ORDER_ID#&pr_order_id=#get_upper_seri_numbers.PROCESS_ID1#">#get_upper_seri_numbers.PROCESS_NO1#</a></td>
            </cfoutput>
            </tr>
            <cfoutput query="get_upper_seri_numbers" group="stock_id">
            <tr>
                <cfquery name="get_serials" datasource="#dsn3#">
                    SELECT 
                        SERIAL_NO 
                    FROM 
                        SERVICE_GUARANTY_NEW 
                    WHERE 
                        STOCK_ID = #STOCK_ID# AND 
                        PROCESS_ID = #PROCESS_ID# AND 
                        MAIN_SERIAL_NO = '#product_serial_no#' AND
                        MAIN_PROCESS_ID = '#main_process_id#' AND
                        MAIN_PROCESS_TYPE = 171
                </cfquery>
                <cfset serials_ =  valuelist(get_serials.serial_no)>
                <td>#PRODUCT_NAME#</td>
                <td>#serials_#</td>
                <cfif PROCESS_NO contains 'STF'>
                    <cfquery name="get_stock_fis" datasource="#dsn2#">
                        SELECT FIS_NUMBER,FIS_ID FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_id#"> AND FIS_TYPE = 111
                    </cfquery>
                    <cfset url_str = "stock.form_add_fis&event=upd&upd_id=#PROCESS_ID#">
                <cfelse>
                    <cfquery name="GET_PR_IDS" datasource="#dsn3#">
                        SELECT P_ORDER_ID FROM PRODUCTION_ORDER_RESULTS WHERE PR_ORDER_ID = #PROCESS_ID#
                    </cfquery>
                    <cfset url_str = "prod.upd_prod_order_result&p_order_id=#GET_PR_IDS.P_ORDER_ID#&pr_order_id=#PROCESS_ID#">
                </cfif>
                <td><a class="tableyazi" target="_blank" href="#request.self#?fuseaction=#url_str#">#PROCESS_NO#</a></td>
            </tr>
            </cfoutput>
     </tbody>
     </cfif>
 </cf_ajax_list>
