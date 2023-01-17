<cfcomponent>
    
    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
    <cfelseif isdefined("session.qq")>
        <cfset session_base = evaluate('session.qq')>
    </cfif>

    <cfset dsn = application.systemParam.systemParam().dsn />
    <cfset dsn1 = "#dsn#_product" />
    <cfset dsn3 = "#dsn#_#session_base.our_company_id#" />

    <cffunction name = "get_pre_order_products" access="public" returntype="query">
        <cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
        <cfargument name="cookie_name" default="">
        
        <cfquery name="q_get_pre_order_products" datasource="#dsn3#">
            SELECT
                OPR.PRODUCT_ID,
                OPR.STOCK_ID,
                OPR.QUANTITY,
                (OPR.QUANTITY * PS.PRICE_KDV * SM.RATE2 / SM.RATE1) AS PRICE_KDV_TL,
                (OPR.QUANTITY * PS.PRICE * SM.RATE2 / SM.RATE1) AS PRICE_TL,
                PS.PRICE_KDV,
                PS.PRICE,
                PS.MONEY,
                OPR.IS_CARGO,
                OPR.ORDER_ROW_ID,
                OPR.PRICE AS PRICE_CARGO,
                OPR.IS_SPEC,
                OPR.DISCOUNT1,
                OPR.DISCOUNT2,
                OPR.DISCOUNT3,
                OPR.DISCOUNT4,
                OPR.DISCOUNT5,					
                S.PRODUCT_NAME,
                S.PROPERTY,
                S.TAX,
                S.COUNTER_TYPE_ID,
                PU.MAIN_UNIT,
                PU.PRODUCT_UNIT_ID,
                ISNULL(OPR.PROM_STOCK_AMOUNT,1) AS PROM_STOCK_AMOUNT,
                OPR.PROM_AMOUNT_DISCOUNT,
                OPR.PROM_DISCOUNT,
                OPR.PROM_ID,
                OPR.IS_PROM_ASIL_HEDIYE,
                OPR.IS_COMMISSION,
                OPR.IS_PRODUCT_PROMOTION_NONEFFECT,
                OPR.IS_GENERAL_PROM
            FROM 
                ORDER_PRE_ROWS OPR
                JOIN #dsn1#.PRICE_STANDART PS ON PS.PRODUCT_ID=OPR.PRODUCT_ID
                JOIN #dsn#.SETUP_MONEY AS SM ON PS.MONEY = SM.MONEY
                JOIN STOCKS S ON S.PRODUCT_ID=OPR.PRODUCT_ID
                JOIN PRODUCT_UNIT PU ON S.PRODUCT_ID=PU.PRODUCT_ID
            WHERE
                PU.IS_MAIN = 1 AND
                PS.PURCHASESALES=1 AND
                PS.PRICESTANDART_STATUS=1 AND
                SM.MONEY_STATUS = 1 AND
                SM.PERIOD_ID = #session_base.period_id#
                <cfif isDefined("arguments.consumer_id") and  len(arguments.consumer_id)>
                    AND OPR.RECORD_CONS = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#arguments.consumer_id#">
                <cfelseif isDefined("arguments.partner_id") and len(arguments.partner_id)>
                    AND OPR.RECORD_PAR = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#arguments.partner_id#">
                <cfelseif isDefined("arguments.cookie_name") and len(arguments.cookie_name)>
                    AND OPR.COOKIE_NAME = <cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#arguments.cookie_name#">
                </cfif>
        </cfquery>

        <cfreturn q_get_pre_order_products />

    </cffunction>

    <cffunction name = "get_total_pre_order_products" access="public" returntype="query">
        <cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
        <cfargument name="cookie_name" default="">
        <cfargument name="stock_id" default="">

        <cfquery name="q_get_total_pre_order_products" datasource="#dsn3#">
            SELECT
                OPR.STOCK_ID,
                SUM(OPR.QUANTITY) AS TOTAL_QUANTITY,
                SUM(OPR.QUANTITY * PS.PRICE_KDV * SM.RATE2 / SM.RATE1) AS TOTAL_PRICE_KDV_TL,
                SUM(OPR.QUANTITY * PS.PRICE * SM.RATE2 / SM.RATE1) AS TOTAL_PRICE_TL,
                SUM(PS.PRICE_KDV) AS TOTAL_PRICE_KDV,
                SUM(PS.PRICE) AS TOTAL_PRICE,
                PS.MONEY
            FROM 
                ORDER_PRE_ROWS OPR
                JOIN #dsn1#.PRICE_STANDART PS ON PS.PRODUCT_ID=OPR.PRODUCT_ID
                JOIN #dsn#.SETUP_MONEY AS SM ON PS.MONEY = SM.MONEY
                JOIN STOCKS S ON S.PRODUCT_ID=OPR.PRODUCT_ID
                JOIN PRODUCT_UNIT PU ON S.PRODUCT_ID=PU.PRODUCT_ID
            WHERE
                PU.IS_MAIN = 1 AND
                PS.PURCHASESALES=1 AND
                PS.PRICESTANDART_STATUS=1 AND
                SM.MONEY_STATUS = 1 AND
                SM.PERIOD_ID = #session_base.period_id#
                <cfif isDefined("arguments.consumer_id") and  len(arguments.consumer_id)>
                    AND OPR.RECORD_CONS = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#arguments.consumer_id#">
                <cfelseif isDefined("arguments.partner_id") and len(arguments.partner_id)>
                    AND OPR.RECORD_PAR = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#arguments.partner_id#">
                <cfelseif isDefined("arguments.cookie_name") and len(arguments.cookie_name)>
                    AND OPR.COOKIE_NAME = <cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#arguments.cookie_name#">
                </cfif>
            GROUP BY
                OPR.STOCK_ID,
                PS.MONEY
        </cfquery>

        <cfreturn q_get_total_pre_order_products />
        
    </cffunction>

</cfcomponent>