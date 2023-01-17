<!---
    File: V16/purchase/cfc/purchase_dashboard.cfc
    Author: Workcube-Botan Kaygan <botankaygan@workcube.com>
    Date: 11.05.2020
    Controller: -
    Description: -
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">

    <cffunction name="GET_ACTIVE_OFFERS" access="remote" returntype="any">
        <cfargument name="offer_show_ids" default="">
        <cfargument name="offer_hide_ids" default="">
        <cfquery name="GET_ACTIVE_OFFERS" datasource="#dsn3#">
            SELECT
                O.OFFER_STAGE,
                PTR.STAGE,
                O.OFFER_ID,
                (SELECT COUNT(*) FROM OFFER WHERE FOR_OFFER_ID = O.OFFER_ID) AS COUNT_RECORD,
                (SELECT SUM(PRICE) FROM OFFER WHERE OFFER_ID = O.OFFER_ID OR FOR_OFFER_ID = O.OFFER_ID) AS SUM_RECORD
            FROM
                OFFER O
                LEFT JOIN #dsn#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = O.OFFER_STAGE
            WHERE
                ((O.OFFER_ZONE = 1 AND O.PURCHASE_SALES = 1) OR (O.OFFER_ZONE = 0 AND O.PURCHASE_SALES = 0))
                AND O.OFFER_STATUS = 1 AND O.FOR_OFFER_ID IS NULL
                <cfif len(arguments.offer_show_ids)>
                    AND
                        O.OFFER_STAGE IN (<cfqueryparam value="#arguments.offer_show_ids#" cfsqltype="cf_sql_integer" list="true">)
                </cfif>
                <cfif len(arguments.offer_hide_ids)>
                    AND
                        O.OFFER_STAGE NOT IN (<cfqueryparam value="#arguments.offer_hide_ids#" cfsqltype="cf_sql_integer" list="true">)
                </cfif>
        </cfquery>
        <cfquery name="GET_ACTIVE_OFFERS_BY_GROUP" dbtype="query">
            SELECT
                OFFER_STAGE,
                STAGE,
                COUNT(OFFER_ID) AS COUNT_RECORD,
                SUM(COUNT_RECORD) AS COUNT_ALT_RECORD,
                SUM(SUM_RECORD) AS SUM_RECORD
            FROM
                GET_ACTIVE_OFFERS
            GROUP BY
                OFFER_STAGE,
                STAGE
        </cfquery>
        <cfreturn GET_ACTIVE_OFFERS_BY_GROUP>
    </cffunction>

    <cffunction name="GET_ACTIVE_DEMANDS" access="remote" returntype="any">
        <cfargument name="demand_show_ids" default="">
        <cfargument name="demand_hide_ids" default="">
        <cfquery name="GET_ACTIVE_DEMANDS" datasource="#dsn3#">
            SELECT
                I.INTERNALDEMAND_STAGE,
                PTR.STAGE,
                COUNT(I.INTERNAL_ID) AS COUNT_RECORD,
                SUM(I.NET_TOTAL) AS SUM_RECORD
            FROM
                INTERNALDEMAND I
                LEFT JOIN #dsn#.PROCESS_TYPE_ROWS PTR ON I.INTERNALDEMAND_STAGE = PTR.PROCESS_ROW_ID
            WHERE
                I.DEMAND_TYPE = 1 AND I.IS_ACTIVE = 1
                <cfif len(arguments.demand_show_ids)>
                    AND I.INTERNALDEMAND_STAGE IN (<cfqueryparam value="#arguments.demand_show_ids#" cfsqltype="cf_sql_integer" list="true">)
                </cfif>
                <cfif len(arguments.demand_hide_ids)>
                    AND I.INTERNALDEMAND_STAGE NOT IN (<cfqueryparam value="#arguments.demand_hide_ids#" cfsqltype="cf_sql_integer" list="true">)
                </cfif>
            GROUP BY
                I.INTERNALDEMAND_STAGE,
                PTR.STAGE
        </cfquery>
        <cfreturn GET_ACTIVE_DEMANDS>
    </cffunction>

    <cffunction name="GET_ACTIVE_ORDERS" access="remote" returntype="any">
        <cfargument name="order_show_ids" default="">
        <cfargument name="order_hide_ids" default="">
        <cfquery name="GET_ACTIVE_ORDERS" datasource="#dsn3#">
            SELECT
                O.ORDER_STAGE,
                PTR.STAGE,
                COUNT(O.ORDER_ID) AS COUNT_RECORD,
                SUM(O.NETTOTAL) AS SUM_RECORD
            FROM
                ORDERS O
                LEFT JOIN #dsn#.PROCESS_TYPE_ROWS PTR ON O.ORDER_STAGE = PTR.PROCESS_ROW_ID
            WHERE
                (O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 0 AND O.ORDER_STATUS = 1)
                <cfif len(arguments.order_show_ids)>
                    AND O.ORDER_STAGE IN (<cfqueryparam value="#arguments.order_show_ids#" cfsqltype="cf_sql_integer" list="true">)
                </cfif>
                <cfif len(arguments.order_hide_ids)>
                    AND O.ORDER_STAGE NOT IN (<cfqueryparam value="#arguments.order_hide_ids#" cfsqltype="cf_sql_integer" list="true">)
                </cfif>
            GROUP BY
                O.ORDER_STAGE,
                PTR.STAGE
        </cfquery>
        <cfreturn GET_ACTIVE_ORDERS>
    </cffunction>

    <cffunction name="GET_PURCHASE_ACTIVITY" access="remote" returntype="any">
        <cfargument name="offer_show_ids" default="">
        <cfargument name="offer_hide_ids" default="">
        <cfargument name="order_show_ids" default="">
        <cfargument name="order_hide_ids" default="">
        <cfargument name="demand_show_ids" default="">
        <cfargument name="demand_hide_ids" default="">
        <cfargument name="active_year" default="">
        <cfargument name="order_stage" default="">
        <cfargument name="offer_stage" default="">
        <cfargument name="demand_stage" default="">
        <cfquery name="GET_PURCHASE_ACTIVITY" datasource="#dsn3#">
            WITH t1 AS
            (
                SELECT
                    MONTH(ORDER_DATE) PURCHASE_MONTH,
                    ISNULL(SUM(NETTOTAL),0) AS SIPARIS,
                    0 TEKLIF,
                    0 TALEP
                FROM
                    ORDERS
                WHERE
                    (PURCHASE_SALES = 0 AND ORDER_ZONE = 0 AND ORDER_STATUS = 1)
                    AND YEAR(ORDER_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    <cfif len(arguments.order_show_ids)>
                        AND ORDER_STAGE IN (<cfqueryparam value="#arguments.order_show_ids#" cfsqltype="cf_sql_integer" list="true">)
                    </cfif>
                    <cfif len(arguments.order_hide_ids)>
                        AND ORDER_STAGE NOT IN (<cfqueryparam value="#arguments.order_hide_ids#" cfsqltype="cf_sql_integer" list="true">)
                    </cfif>
                    <cfif len(arguments.order_stage)>
                        AND ORDER_STAGE IN (<cfqueryparam value="#arguments.order_stage#" cfsqltype="cf_sql_integer" list="true">)
                    </cfif>
                GROUP BY
                    MONTH(ORDER_DATE)
                UNION ALL
                SELECT
                    MONTH(OFFER_DATE) PURCHASE_MONTH,
                    0 SIPARIS,
                    ISNULL(SUM(PRICE),0) AS TEKLIF,
                    0 TALEP
                FROM
                    OFFER
                WHERE
                    ((OFFER_ZONE = 1 AND PURCHASE_SALES = 1) OR (OFFER_ZONE = 0 AND PURCHASE_SALES = 0))
                    AND OFFER_STATUS = 1
                    AND YEAR(OFFER_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    <cfif len(arguments.offer_show_ids)>
                        AND OFFER_STAGE IN (<cfqueryparam value="#arguments.offer_show_ids#" cfsqltype="cf_sql_integer" list="true">)
                    </cfif>
                    <cfif len(arguments.offer_hide_ids)>
                        AND OFFER_STAGE NOT IN (<cfqueryparam value="#arguments.offer_hide_ids#" cfsqltype="cf_sql_integer" list="true">)
                    </cfif>
                    <cfif len(arguments.offer_stage)>
                        AND OFFER_STAGE IN (<cfqueryparam value="#arguments.offer_stage#" cfsqltype="cf_sql_integer" list="true">)
                    </cfif>
                GROUP BY
                    MONTH(OFFER_DATE)
                UNION ALL
                SELECT
                    MONTH(RECORD_DATE) PURCHASE_MONTH,
                    0 SIPARIS,
                    0 TEKLIF,
                    ISNULL(SUM(NET_TOTAL),0) TALEP
                FROM
                    INTERNALDEMAND
                WHERE
                    DEMAND_TYPE = 1 AND IS_ACTIVE = 1
                    AND YEAR(RECORD_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.active_year#">
                    <cfif len(arguments.demand_show_ids)>
                        AND INTERNALDEMAND_STAGE IN (<cfqueryparam value="#arguments.demand_show_ids#" cfsqltype="cf_sql_integer" list="true">)
                    </cfif>
                    <cfif len(arguments.demand_hide_ids)>
                        AND INTERNALDEMAND_STAGE NOT IN (<cfqueryparam value="#arguments.demand_hide_ids#" cfsqltype="cf_sql_integer" list="true">)
                    </cfif>
                    <cfif len(arguments.demand_stage)>
                        AND INTERNALDEMAND_STAGE IN (<cfqueryparam value="#arguments.demand_stage#" cfsqltype="cf_sql_integer" list="true">)
                    </cfif>
                GROUP BY
                    MONTH(RECORD_DATE)
                UNION ALL
                SELECT 1 PURCHASE_MONTH, 0 SIPARIS, 0 TEKLIF, 0 TALEP
                UNION ALL
                SELECT 2 PURCHASE_MONTH, 0 SIPARIS, 0 TEKLIF, 0 TALEP
                UNION ALL
                SELECT 3 PURCHASE_MONTH, 0 SIPARIS, 0 TEKLIF, 0 TALEP
                UNION ALL
                SELECT 4 PURCHASE_MONTH, 0 SIPARIS, 0 TEKLIF, 0 TALEP
                UNION ALL
                SELECT 5 PURCHASE_MONTH, 0 SIPARIS, 0 TEKLIF, 0 TALEP
                UNION ALL
                SELECT 6 PURCHASE_MONTH, 0 SIPARIS, 0 TEKLIF, 0 TALEP
                UNION ALL
                SELECT 7 PURCHASE_MONTH, 0 SIPARIS, 0 TEKLIF, 0 TALEP
                UNION ALL
                SELECT 8 PURCHASE_MONTH, 0 SIPARIS, 0 TEKLIF, 0 TALEP
                UNION ALL
                SELECT 9 PURCHASE_MONTH, 0 SIPARIS, 0 TEKLIF, 0 TALEP
                UNION ALL
                SELECT 10 PURCHASE_MONTH, 0 SIPARIS, 0 TEKLIF, 0 TALEP
                UNION ALL
                SELECT 11 PURCHASE_MONTH, 0 SIPARIS, 0 TEKLIF, 0 TALEP
                UNION ALL
                SELECT 12 PURCHASE_MONTH, 0 SIPARIS, 0 TEKLIF, 0 TALEP
            )
            SELECT
                PURCHASE_MONTH,
                ISNULL(SUM(SIPARIS),0) AS SIPARIS,
                ISNULL(SUM(TEKLIF),0) AS TEKLIF,
                ISNULL(SUM(TALEP),0) AS TALEP
            FROM
                t1
            GROUP BY
                PURCHASE_MONTH
        </cfquery>
        <cfreturn GET_PURCHASE_ACTIVITY>
    </cffunction>

    <cffunction name="GET_ACTIVE_SECUREFUND" access="remote" returntype="any">
        <cfquery name="GET_ACTIVE_SECUREFUND" datasource="#dsn#">
            SELECT
                SECUREFUND_ID,
                GIVE_TAKE,
                ACTION_VALUE2,
                ACTION_VALUE,
                SECUREFUND_TOTAL,
                MONEY_CAT
            FROM
                COMPANY_SECUREFUND
            WHERE
                OUR_COMPANY_ID = #session.ep.company_id#
                AND ISNULL(IS_CRM,0) = 0
                AND SECUREFUND_STATUS = 1
                AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
        </cfquery>
        <cfreturn GET_ACTIVE_SECUREFUND>
    </cffunction>

    <cffunction name="GET_TOP_PURCHASED_BY_GROUP" access="remote" returntype="any">
        <cfargument name="list_type" default="">
        <cfargument name="selected_year" default="">
        <cfargument name="order_show_ids" default="">
        <cfargument name="order_hide_ids" default="">
        <cfquery name="GET_TOP_PURCHASED_BY_GROUP" datasource="#dsn3#">
            <cfif arguments.list_type eq 1>
                SELECT TOP 10
                    SUM(((ORD_ROW.QUANTITY*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)+(((ORD_ROW.QUANTITY*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)*ORD_ROW.TAX/100)) AS PRICE,
                    SUM(ISNULL(ORD_ROW.QUANTITY,0)) AS TOTAL_QUANTITY,
                    PC.PRODUCT_CAT,
                    PC.PRODUCT_CATID
                FROM
                    ORDERS O
                    LEFT JOIN ORDER_ROW ORD_ROW ON O.ORDER_ID = ORD_ROW.ORDER_ID
                    LEFT JOIN PRODUCT P ON ORD_ROW.PRODUCT_ID = P.PRODUCT_ID
                    LEFT JOIN PRODUCT_CAT PC ON PC.PRODUCT_CATID = P.PRODUCT_CATID
                WHERE
                    (O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 0 AND O.ORDER_STATUS = 1 AND ORD_ROW.PRODUCT_ID IS NOT NULL AND P.PRODUCT_CATID IS NOT NULL)
                    <cfif len(arguments.order_show_ids)>
                        AND O.ORDER_STAGE IN (<cfqueryparam value="#arguments.order_show_ids#" cfsqltype="cf_sql_integer" list="true">)
                    </cfif>
                    <cfif len(arguments.order_hide_ids)>
                        AND O.ORDER_STAGE NOT IN (<cfqueryparam value="#arguments.order_hide_ids#" cfsqltype="cf_sql_integer" list="true">)
                    </cfif>
                    <cfif len(arguments.selected_year)>
                        AND YEAR(ORDER_DATE) = <cfqueryparam value="#arguments.selected_year#" cfsqltype="cf_sql_integer">
                    </cfif>
                GROUP BY
                    PC.PRODUCT_CAT,
                    PC.PRODUCT_CATID
                ORDER BY
                    SUM(ISNULL(ORD_ROW.QUANTITY,0)) DESC
            <cfelse>
                SELECT TOP 10
                    SUM(((ORD_ROW.QUANTITY*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)+(((ORD_ROW.QUANTITY*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)*ORD_ROW.TAX/100)) AS PRICE,
                    SUM(ISNULL(ORD_ROW.QUANTITY,0)) AS TOTAL_QUANTITY,
                    P.PRODUCT_NAME,
                    P.PRODUCT_ID
                FROM
                    ORDERS O
                    LEFT JOIN ORDER_ROW ORD_ROW ON O.ORDER_ID = ORD_ROW.ORDER_ID
                    LEFT JOIN PRODUCT P ON ORD_ROW.PRODUCT_ID = P.PRODUCT_ID
                WHERE
                    (O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 0 AND O.ORDER_STATUS = 1 AND ORD_ROW.PRODUCT_ID IS NOT NULL)
                    <cfif len(arguments.order_show_ids)>
                        AND O.ORDER_STAGE IN (<cfqueryparam value="#arguments.order_show_ids#" cfsqltype="cf_sql_integer" list="true">)
                    </cfif>
                    <cfif len(arguments.order_hide_ids)>
                        AND O.ORDER_STAGE NOT IN (<cfqueryparam value="#arguments.order_hide_ids#" cfsqltype="cf_sql_integer" list="true">)
                    </cfif>
                    <cfif len(arguments.selected_year)>
                        AND YEAR(ORDER_DATE) = <cfqueryparam value="#arguments.selected_year#" cfsqltype="cf_sql_integer">
                    </cfif>
                GROUP BY
                    P.PRODUCT_NAME,
                    P.PRODUCT_ID
                ORDER BY
                    SUM(ISNULL(ORD_ROW.QUANTITY,0)) DESC
            </cfif>
        </cfquery>
        <cfreturn GET_TOP_PURCHASED_BY_GROUP>
    </cffunction>

    <cffunction name="GET_TOP_SUPPLIERS" access="remote" returntype="any">
        <cfargument name="order_show_ids" default="">
        <cfargument name="order_hide_ids" default="">
        <cfquery name="GET_TOP_SUPPLIERS" datasource="#dsn3#">
            SELECT TOP 10
                COMPANY_ID,
                CONSUMER_ID,
                SUM(NETTOTAL) AS NETTOTAL
            FROM
                ORDERS
            WHERE
                (PURCHASE_SALES = 0 AND ORDER_ZONE = 0 AND ORDER_STATUS = 1)
                <cfif len(arguments.order_show_ids)>
                    AND ORDER_STAGE IN (<cfqueryparam value="#arguments.order_show_ids#" cfsqltype="cf_sql_integer" list="true">)
                </cfif>
                <cfif len(arguments.order_hide_ids)>
                    AND ORDER_STAGE NOT IN (<cfqueryparam value="#arguments.order_hide_ids#" cfsqltype="cf_sql_integer" list="true">)
                </cfif>
            GROUP BY
                COMPANY_ID,
                CONSUMER_ID
            ORDER BY
                SUM(NETTOTAL) DESC
        </cfquery>
        <cfreturn GET_TOP_SUPPLIERS>
    </cffunction>

    <cffunction name="GET_NETTOTAL_ORDERS" access="remote" returntype="any">
        <cfargument name="order_show_ids" default="">
        <cfargument name="order_hide_ids" default="">
        <cfquery name="GET_NETTOTAL_ORDERS" datasource="#dsn3#">
            SELECT
                SUM(NETTOTAL) AS NETTOTAL
            FROM
                ORDERS
            WHERE
                (PURCHASE_SALES = 0 AND ORDER_ZONE = 0 AND ORDER_STATUS = 1)
                <cfif len(arguments.order_show_ids)>
                    AND ORDER_STAGE IN (<cfqueryparam value="#arguments.order_show_ids#" cfsqltype="cf_sql_integer" list="true">)
                </cfif>
                <cfif len(arguments.order_hide_ids)>
                    AND ORDER_STAGE NOT IN (<cfqueryparam value="#arguments.order_hide_ids#" cfsqltype="cf_sql_integer" list="true">)
                </cfif>
        </cfquery>
        <cfreturn GET_NETTOTAL_ORDERS>
    </cffunction>

    <cffunction name="SUPER_SUMMARY_GET_BUDGET" access="remote" returntype="any">
        <cfargument name="budget_id" default="">
        <cfquery name="SUPER_SUMMARY_GET_BUDGET" datasource="#dsn#">
            SELECT
                B.BUDGET_ID,
                B.BUDGET_NAME,
                SUM(ISNULL(DIFF_TOTAL,0)) AS DIFF_TOTAL,
                SUM(ISNULL(DIFF_TOTAL_2,0)) AS DIFF_TOTAL_2
            FROM
                BUDGET B
                LEFT JOIN BUDGET_PLAN BP ON BP.BUDGET_ID = B.BUDGET_ID
            WHERE
                B.BUDGET_ID = <cfqueryparam value="#arguments.budget_id#" cfsqltype="cf_sql_integer">
                AND BP.PROCESS_TYPE = 160
            GROUP BY
                B.BUDGET_ID,
                B.BUDGET_NAME
        </cfquery>
        <cfreturn SUPER_SUMMARY_GET_BUDGET>
    </cffunction>

    <cffunction name="SUPER_SUMMARY_GET_USE_BUDGET" access="remote" returntype="any">
        <cfargument name="budget_id" default="">
        <cfquery name="SUPER_SUMMARY_GET_USE_BUDGET" datasource="#dsn#">
            SELECT
                SUM(ISNULL(OTHER_MONEY_VALUE,0)) AS TOTAL_VALUE,
                SUM(ISNULL(OTHER_MONEY_VALUE_2,0)) AS TOTAL_VALUE_2
            FROM
                BUDGET_PLAN BP
                LEFT JOIN BUDGET_PLAN_ROW BPR ON BPR.BUDGET_PLAN_ID = BP.BUDGET_PLAN_ID
                LEFT JOIN #dsn2#.EXPENSE_ITEMS_ROWS EIR ON EIR.EXPENSE_ITEM_ID = BPR.BUDGET_ITEM_ID
            WHERE
                BP.BUDGET_ID = <cfqueryparam value="#arguments.budget_id#" cfsqltype="cf_sql_integer">
                AND BP.PROCESS_TYPE = 160
        </cfquery>
        <cfreturn SUPER_SUMMARY_GET_USE_BUDGET>
    </cffunction>

    <cffunction name="GET_OFFERS_CURRENCY_TOTAL" access="remote" returntype="any">
        <cfargument name="offer_show_ids" default="">
        <cfargument name="offer_hide_ids" default="">
        <cfquery name="GET_OFFERS_CURRENCY_TOTAL" datasource="#dsn3#">
            SELECT
                SUM(O.PRICE/OM.RATE2) AS TOTAL_USD
            FROM
                OFFER O
                LEFT JOIN OFFER_MONEY OM ON O.OFFER_ID = OM.ACTION_ID
            WHERE
                ((O.OFFER_ZONE = 1 AND O.PURCHASE_SALES = 1) OR (O.OFFER_ZONE = 0 AND O.PURCHASE_SALES = 0))
                AND O.OFFER_STATUS = 1
                AND OM.MONEY_TYPE = '#session.ep.money2#'
                <cfif len(arguments.offer_show_ids)>
                    AND O.OFFER_STAGE IN (<cfqueryparam value="#arguments.offer_show_ids#" cfsqltype="cf_sql_integer" list="true">)
                </cfif>
                <cfif len(arguments.offer_hide_ids)>
                    AND O.OFFER_STAGE NOT IN (<cfqueryparam value="#arguments.offer_hide_ids#" cfsqltype="cf_sql_integer" list="true">)
                </cfif>
        </cfquery>
        <cfreturn GET_OFFERS_CURRENCY_TOTAL>
    </cffunction>

    <cffunction name="GET_ORDERS_CURRENCY_TOTAL" access="remote" returntype="any">
        <cfargument name="order_show_ids" default="">
        <cfargument name="order_hide_ids" default="">
        <cfquery name="GET_ORDERS_CURRENCY_TOTAL" datasource="#dsn3#">
            SELECT
                SUM(O.NETTOTAL/OM.RATE2) AS TOTAL_USD
            FROM
                ORDERS O
                LEFT JOIN ORDER_MONEY OM ON O.ORDER_ID = OM.ACTION_ID
            WHERE
                (O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 0 AND O.ORDER_STATUS = 1)
                AND OM.MONEY_TYPE = '#session.ep.money2#'
                <cfif len(arguments.order_show_ids)>
                    AND O.ORDER_STAGE IN (<cfqueryparam value="#arguments.order_show_ids#" cfsqltype="cf_sql_integer" list="true">)
                </cfif>
                <cfif len(arguments.order_hide_ids)>
                    AND O.ORDER_STAGE NOT IN (<cfqueryparam value="#arguments.order_hide_ids#" cfsqltype="cf_sql_integer" list="true">)
                </cfif>
        </cfquery>
        <cfreturn GET_ORDERS_CURRENCY_TOTAL>
    </cffunction>

    <cffunction name="GET_DEMANDS_CURRENCY_TOTAL" access="remote" returntype="any">
        <cfargument name="demand_show_ids" default="">
        <cfargument name="demand_hide_ids" default="">
        <cfquery name="GET_DEMANDS_CURRENCY_TOTAL" datasource="#dsn3#">
            SELECT
                SUM(I.NET_TOTAL/IM.RATE2) AS TOTAL_USD
            FROM
                INTERNALDEMAND I
                LEFT JOIN INTERNALDEMAND_MONEY IM ON I.INTERNAL_ID = IM.ACTION_ID
            WHERE
                I.DEMAND_TYPE = 1 AND I.IS_ACTIVE = 1
                AND IM.MONEY_TYPE = '#session.ep.money2#'
                <cfif len(arguments.demand_show_ids)>
                    AND I.INTERNALDEMAND_STAGE IN (<cfqueryparam value="#arguments.demand_show_ids#" cfsqltype="cf_sql_integer" list="true">)
                </cfif>
                <cfif len(arguments.demand_hide_ids)>
                    AND I.INTERNALDEMAND_STAGE NOT IN (<cfqueryparam value="#arguments.demand_hide_ids#" cfsqltype="cf_sql_integer" list="true">)
                </cfif>
        </cfquery>
        <cfreturn GET_DEMANDS_CURRENCY_TOTAL>
    </cffunction>

    <cffunction name="GET_PERIOD_YEARS" access="remote" returntype="any">
        <cfargument name="company_id" default="">
        <cfquery name="GET_PERIOD_YEARS" datasource="#dsn#">
            SELECT
                PERIOD_YEAR
            FROM
                SETUP_PERIOD
            WHERE
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>
        <cfreturn GET_PERIOD_YEARS>
    </cffunction>
</cfcomponent>