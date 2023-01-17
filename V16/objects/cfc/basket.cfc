<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">

    <cffunction name="get_basket" access="public">
        <cfargument name="basket_id">
        <cfargument name="is_view" default="">

        <cfquery name="query_get_basket" datasource="#dsn3#">
            SELECT 
                SETUP_BASKET.PURCHASE_SALES,
                SETUP_BASKET.AMOUNT_ROUND,
                SETUP_BASKET.PRICE_ROUND_NUMBER,
                SETUP_BASKET.BASKET_TOTAL_ROUND_NUMBER,
                SETUP_BASKET.BASKET_RATE_ROUND_NUMBER,
                SETUP_BASKET.USE_PROJECT_DISCOUNT,
                SETUP_BASKET.OTV_CALC_TYPE,
                #DSN#.#dsn#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,ISNULL(SLT.ITEM_#UCase(session.ep.language)#, TITLE_NAME)) AS TITLE_NAME,
                SETUP_BASKET_ROWS.BASKET_ID, 
                SETUP_BASKET_ROWS.LINE_ORDER_NO, 
                SETUP_BASKET_ROWS.IS_SELECTED, 
                SETUP_BASKET_ROWS.TITLE, 
                SETUP_BASKET_ROWS.B_TYPE, 
                SETUP_BASKET_ROWS.GENISLIK, 
                SETUP_BASKET_ROWS.IS_READONLY,
                SETUP_BASKET_ROWS.IS_REQUIRED,
                SETUP_BASKET_ROWS.BASKET_ROW_ID,
                SETUP_BASKET.LINE_NUMBER,
                SETUP_BASKET_ROWS.IS_MOBILE
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

    <cffunction name="get_basket_mod" access="public">
        <cfargument name="basket_id">

        <cfquery name="query_get_basket" datasource="#dsn3#">
            SELECT 
                SETUP_BASKET.BASKET_MOD
            FROM 
                SETUP_BASKET
            WHERE 
                   SETUP_BASKET.BASKET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.basket_id#">
        </cfquery>

        <cfif query_get_basket.recordcount eq 0 or len(query_get_basket.BASKET_MOD) eq 0 or query_get_basket.BASKET_MOD eq 1>
            <cfreturn 1>
        <cfelse>
            <cfreturn query_get_basket.BASKET_MOD>
        </cfif>
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

    <cffunction name="get_session_basket_rate" access="public">
        <cfargument name="action_id">
        <cfargument name="table_type_id">
        <cfargument name="to_table_type_id">
        <cfargument name="process_type">

        <cfif listFindNoCase(application.systemParam.systemParam().employee_url, cgi.http_host, ';')>
            <cfset session_source = session.ep>
        <cfelseif listFindNoCase(application.systemParam.systemParam().partner_url, cgi.http_host, ';')>
            <cfset session_source = session.pp>
        <cfelseif listFindNoCase(application.systemParam.systemParam().server_url, cgi.http_host, ';')>
            <cfset session_source = session.ww>
        <cfelseif listFindNoCase(application.systemParam.systemParam().pda_url, cgi.http_host, ';')>
            <cfset session_source = session.pda>
        </cfif>
        <cfquery name="query_standart_process_money" datasource="#dsn#">
            SELECT STANDART_PROCESS_MONEY FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#session_source.period_id#'>
        </cfquery>
        <cfif arguments.process_type eq 1>
            <cfswitch expression="#arguments.table_type_id#">
                <cfcase value="1">
                    <cfset fnc_table_name = "INVOICE_MONEY">
                    <cfset fnc_dsn_name = "#dsn2#">
                </cfcase>
                <cfcase value="2">
                    <cfset fnc_table_name = "SHIP_MONEY">
                    <cfset fnc_dsn_name = "#dsn2#">
                </cfcase>
                <cfcase value="3">
                    <cfset fnc_table_name = "ORDER_MONEY">
                    <cfset fnc_dsn_name = "#dsn3#">
                </cfcase>
                <cfcase value="4">
                    <cfset fnc_table_name = "OFFER_MONEY">
                    <cfset fnc_dsn_name = "#dsn3#">
                </cfcase>
                <cfcase value="5">
                    <cfset fnc_table_name = "SERVICE_MONEY">
                    <cfset fnc_dsn_name = "#dsn3#">
                </cfcase>
                <cfcase value="6">
                    <cfset fnc_table_name = "STOCK_FIS_MONEY">
                    <cfset fnc_dsn_name = "#dsn2#">
                </cfcase>
                <cfcase value="7">
                    <cfset fnc_table_name = "INTERNALDEMAND_MONEY">
                    <cfset fnc_dsn_name = "#dsn3#">
                </cfcase>
                <cfcase value="8">
                    <cfset fnc_table_name = "CATALOG_MONEY">
                    <cfset fnc_dsn_name = "#dsn3#">
                </cfcase>
                <cfcase value="10">
                    <cfset fnc_table_name = "SHIP_INTERNAL_MONEY">
                    <cfset fnc_dsn_name = "#dsn2#">
                </cfcase>
                <cfcase value="11">
                    <cfset fnc_table_name = "PAYROLL_MONEY">
                    <cfset fnc_dsn_name = "#dsn2#">
                </cfcase>
                <cfcase value="12">
                    <cfset fnc_table_name = "VOUCHER_PAYROLL_MONEY">
                    <cfset fnc_dsn_name = "#dsn2#">
                </cfcase>
                <cfcase value="13">
                    <cfset fnc_table_name = "SUBSCRIPTION_CONTRACT_MONEY">
                    <cfset fnc_dsn_name = "#dsn3#">
                </cfcase>
                <cfcase value="14">
                    <cfset fnc_table_name = "PRO_MATERIAL_MONEY">
                    <cfset fnc_dsn_name = "#dsn#">
                </cfcase>
            </cfswitch>
            <cfset is_rate_from_pre_paper = 1>
            <cfif isDefined("arguments.to_table_type_id") and arguments.to_table_type_id neq arguments.table_type_id>
                <cfquery name="query_control_comp_rate_type" datasource="#dsn#">
                    SELECT IS_RATE_FROM_PRE_PAPER FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#session_source.OUR_COMPANY_ID#'>
                </cfquery>
                <cfif len(query_control_comp_rate_type.IS_RATE_FROM_PRE_PAPER) and query_control_comp_rate_type.IS_RATE_FROM_PRE_PAPER eq 0>
                    <cfset is_rate_from_pre_paper = 0>
                </cfif>
            </cfif>
            <cfif is_rate_from_pre_paper>
                <cfquery name="query_our_company_info" datasource="#dsn#">
                    SELECT IS_RATE_FROM_PRE_PAPER FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session_source.OUR_COMPANY_ID#">           	
                </cfquery>
                <cfquery name="query_money_bskt" datasource="#fnc_dsn_name#">
                    SELECT 
                        <cfif session_source.period_year gte 2009>
                            CASE WHEN TABLE_NAME.MONEY_TYPE = 'YTL' THEN '<cfoutput>#session_source.MONEY#</cfoutput>' ELSE TABLE_NAME.MONEY_TYPE END AS MONEY_TYPE,
                        <cfelseif fnc_dsn_name is dsn3>
                            CASE WHEN TABLE_NAME.MONEY_TYPE = 'TL' THEN '<cfoutput>#session_source.MONEY#</cfoutput>' ELSE TABLE_NAME.MONEY_TYPE END AS MONEY_TYPE,
                        <cfelse>
                            TABLE_NAME.MONEY_TYPE,
                        </cfif> 
                        TABLE_NAME.ACTION_ID,
                        TABLE_NAME.RATE2,
                        TABLE_NAME.RATE1,
                        TABLE_NAME.IS_SELECTED
                    FROM 
                        #fnc_table_name#  TABLE_NAME
                    WHERE 
                        TABLE_NAME.ACTION_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.action_id#">
                    ORDER BY TABLE_NAME.ACTION_MONEY_ID
                </cfquery>
                <cfif not query_money_bskt.recordcount>
                    <cfquery name="query_money_bskt" datasource="#dsn#">
                        SELECT 
                            MONEY AS MONEY_TYPE, 0 AS IS_SELECTED, * 
                        FROM 
                            SETUP_MONEY 
                        WHERE 
                            COMPANY_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session_source.COMPANY_ID#">
                            AND PERIOD_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session_source.PERIOD_ID#">
                            AND MONEY_STATUS = 1 
                        ORDER BY MONEY_ID
                    </cfquery>
                </cfif>
            <cfelse>
                <cfquery name="query_comp_info" datasource="#dsn#">
                    SELECT ISNULL(IS_SELECT_RISK_MONEY,0) IS_SELECT_RISK_MONEY FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session_source.COMPANY_ID#">
                </cfquery>
            </cfif>
        </cfif>
    </cffunction>

</cfcomponent>