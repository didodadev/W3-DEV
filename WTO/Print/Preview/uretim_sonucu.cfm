<cfinclude template="/V16/objects/functions/barcode.cfm">
<cfquery name="GET_DETAIL" datasource="#dsn3#">
	SELECT 
		PRODUCTION_ORDERS.P_ORDER_NO,
		PRODUCTION_ORDERS.SPECT_VAR_ID,
		PRODUCTION_ORDERS.SPECT_VAR_NAME,
		PRODUCTION_ORDERS.ORDER_ID,
		PRODUCTION_ORDER_RESULTS.*
	FROM
		PRODUCTION_ORDERS,
		PRODUCTION_ORDER_RESULTS
	WHERE
		<!--- PRODUCTION_ORDERS.P_ORDER_ID = #attributes.action_id# AND  --->
		PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
		PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDER_RESULTS.P_ORDER_ID
</cfquery>
<cfquery name="GET_ROW_ENTER" datasource="#dsn3#">
	SELECT * FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND TYPE = 1
</cfquery>
<cfquery name="GET_CAT" datasource="#dsn3#">
	SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 110
</cfquery>
<cfquery name="GET_FIS" datasource="#dsn2#">
	SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CAT.PROCESS_CAT_ID#">
</cfquery>
<cfquery name="get_stock_info" datasource="#dsn3#">
	SELECT STOCK_CODE,PRODUCT_NAME,PROPERTY FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_ROW_ENTER.stock_id#">
</cfquery>

<cfquery name="GET_SERIAL_INFO" datasource="#DSN3#">
	SELECT
		SG.LOT_NO,
		SG.SERIAL_NO
	FROM
		SERVICE_GUARANTY_NEW AS SG
	WHERE
		STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_ROW_ENTER.stock_id#"> AND
		PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
		PROCESS_CAT = 171 AND
		SG.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
</cfquery>
<cfif (not GET_SERIAL_INFO.recordcount) and GET_FIS.recordcount>
	<cfquery name="GET_SERIAL_INFO" datasource="#DSN3#">
        SELECT
            SG.LOT_NO,
            SG.SERIAL_NO
        FROM
            SERVICE_GUARANTY_NEW AS SG
        WHERE
            STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_ROW_ENTER.stock_id#"> AND
            PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_FIS.FIS_ID#"> AND
            PROCESS_CAT = 110 AND
            SG.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
    </cfquery>
</cfif>
<cfloop query="GET_DETAIL">
    <cfoutput>
        <cf_woc_header>
            <cf_woc_elements>
                <cf_wuxi id="production_order_no" data="#get_detail.production_order_no#" label="29474" type="cell">
                <cf_wuxi id="order_no" data="#get_detail.order_no#" label="58211" type="cell">
                <cf_wuxi id="result_no" data="#get_detail.result_no#" label="34314" type="cell">
                <cf_wuxi id="get_stock_info.stock_code" data="#get_stock_info.stock_code#" label="57518" type="cell">
                <cf_wuxi id="finish_date,dateformat_style" data="#dateformat(get_detail.finish_date,dateformat_style)# #timeformat(get_detail.finish_date,timeformat_style)#" label="32473" type="cell">
                
                <cfsavecontent variable="barkod">
                    <cfif (len(GET_ROW_ENTER.barcode) eq 13) or (len(GET_ROW_ENTER.barcode) eq 12)>
                        <cf_workcube_barcode type="ean13" show="1" value="#GET_ROW_ENTER.barcode#">
                        </br>#GET_ROW_ENTER.barcode#
                    <cfelseif (len(GET_ROW_ENTER.barcode) eq 8) or (len(GET_ROW_ENTER.barcode) eq 7)>
                        <cf_workcube_barcode type="EAN8" show="1" value="#GET_ROW_ENTER.barcode#">
                        </br>#GET_ROW_ENTER.barcode#
                    <cfelseif (len(GET_ROW_ENTER.barcode) eq 9)>
                        <cf_workcube_barcode type="EAN13" value="#GET_ROW_ENTER.barcode#000">
                        </br>#GET_ROW_ENTER.barcode#
                    <cfelseif (len(GET_ROW_ENTER.barcode) eq 10)>
                        <cf_workcube_barcode type="EAN13" value="#GET_ROW_ENTER.barcode#00">
                        </br>#GET_ROW_ENTER.barcode#
                    <cfelseif (len(GET_ROW_ENTER.barcode) eq 11)>
                        <cf_workcube_barcode type="EAN13" value="#GET_ROW_ENTER.barcode#0">
                        </br>#GET_ROW_ENTER.barcode#
                    </cfif>
                </cfsavecontent>
                <cf_wuxi id="aa" data="#barkod#"  type="cell">

            </cf_woc_elements>
        </cfoutput>
</cfloop>
<cf_woc_footer>
