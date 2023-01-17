<cfcomponent accessors="true">

    <cfproperty name="session_base" type="struct">
    <cfproperty name="dsn2" type="string">
    <cfproperty name="dsn3" type="string">

    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name = "init">
        <cfargument name="sessions" type="struct" required="true">
        <cfscript>
            setSession_base( arguments.sessions );
            setDsn2( "#dsn#_#getSession_base().period_year#_#getSession_base().company_id#" );
            setDsn3( "#dsn#_#getSession_base().company_id#" );
        </cfscript>
        <cfreturn this />
    </cffunction>

    <cffunction name="get_basket" access="public">
        <cfargument name="basket_id">
        <cfargument name="is_view" default="">

        <cfquery name="query_get_basket" datasource="#getdsn3()#">
            SELECT 
                SETUP_BASKET.PURCHASE_SALES,
                SETUP_BASKET.AMOUNT_ROUND,
                SETUP_BASKET.PRICE_ROUND_NUMBER,
                SETUP_BASKET.BASKET_TOTAL_ROUND_NUMBER,
                SETUP_BASKET.BASKET_RATE_ROUND_NUMBER,
                SETUP_BASKET.USE_PROJECT_DISCOUNT,
                SETUP_BASKET.OTV_CALC_TYPE,
                #DSN#.#dsn#.Get_Dynamic_Language(BASKET_ROW_ID,'#getSession_base().language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,ISNULL(SLT.ITEM_#UCase(getSession_base().language)#, TITLE_NAME)) AS TITLE_NAME,
                SETUP_BASKET_ROWS.BASKET_ID, 
                SETUP_BASKET_ROWS.LINE_ORDER_NO, 
                SETUP_BASKET_ROWS.IS_SELECTED, 
                SETUP_BASKET_ROWS.TITLE, 
                SETUP_BASKET_ROWS.B_TYPE, 
                SETUP_BASKET_ROWS.GENISLIK, 
                SETUP_BASKET_ROWS.IS_READONLY,
                SETUP_BASKET_ROWS.IS_REQUIRED,
                SETUP_BASKET_ROWS.BASKET_ROW_ID,
                SETUP_BASKET.LINE_NUMBER
            FROM 
                SETUP_BASKET,
                SETUP_BASKET_ROWS LEFT JOIN #DSN#.SETUP_LANGUAGE_TR AS SLT ON SLT.DICTIONARY_ID = SETUP_BASKET_ROWS.LANGUAGE_ID 
            WHERE 
                SETUP_BASKET_ROWS.BASKET_ID = SETUP_BASKET.BASKET_ID AND
                SETUP_BASKET_ROWS.B_TYPE = SETUP_BASKET.B_TYPE AND
                <cfif len(arguments.is_view) and arguments.is_view eq 1>
                    SETUP_BASKET_ROWS.B_TYPE = 0 AND
                <cfelse>
                    SETUP_BASKET_ROWS.B_TYPE = 1 AND
                </cfif>
                   SETUP_BASKET.BASKET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.basket_id#">
            ORDER BY
                SETUP_BASKET_ROWS.LINE_ORDER_NO ASC
        </cfquery>

        <cfreturn query_get_basket>
    </cffunction>

    <cffunction name="get_basket_visiblity" access="public">
        <cfargument name="basket_data">
        <cfargument name="extend" default="">
        <cfargument name="is_visible" default="1">

        <cfquery name="query_basket_visibility" dbtype="query">
            SELECT 
                TITLE,TITLE_NAME,GENISLIK,PURCHASE_SALES,IS_READONLY,IS_REQUIRED
            FROM
                basket_data
            WHERE 
                IS_SELECTED = #arguments.is_visible#
                <cfif len(arguments.extend)>
                <cfif arguments.is_visible eq 1>
                    AND TITLE NOT IN (#listQualify(arguments.extend, "'")#)
                <cfelse>
                    OR TITLE IN (#listQualify(arguments.extend, "'")#)
                </cfif>
                </cfif>
        </cfquery>

        <cfreturn query_basket_visibility>
    </cffunction>

</cfcomponent>