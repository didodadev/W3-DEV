<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cffunction name="GET_PERIOD_YEARS" access="remote"  returntype="any">
        <cfquery name="GET_PERIOD_YEARS" datasource="#dsn#">
            SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id# ORDER BY PERIOD_YEAR DESC
        </cfquery>
        <cfreturn GET_PERIOD_YEARS>
    </cffunction>
    <cffunction name="GET_HEALTH_EXPENSE_SUM" access="remote"  returntype="any">
        <cfargument name="dashboard_dsn" default="">
        <cfargument name="date_field" default="">
        <cfargument name="period_year" default="">
        <cfquery name="GET_HEALTH_EXPENSE_SUM" datasource="#arguments.dashboard_dsn#">
            SELECT
                ISNULL(SUM(NET_TOTAL_AMOUNT),0) AS NET_TOTAL_AMOUNT,
                ISNULL(SUM(OUR_COMPANY_HEALTH_AMOUNT),0) AS OUR_COMPANY_HEALTH_AMOUNT,
                ISNULL(SUM(TREATMENT_AMOUNT),0) AS TREATMENT_AMOUNT
            FROM
                EXPENSE_ITEM_PLAN_REQUESTS
            WHERE
                TREATED IS NOT NULL
                AND IS_APPROVE = 1
                AND IS_PAYMENT = 1
                AND YEAR(#arguments.date_field#) = #arguments.period_year#
        </cfquery>
        <cfreturn GET_HEALTH_EXPENSE_SUM>
    </cffunction>
    <cffunction name="GET_HEALTH_EXPENSE_BY_ASSURANCE" access="remote"  returntype="any">
        <cfargument name="dashboard_dsn" default="">
        <cfargument name="date_field" default="">
        <cfargument name="period_year" default="">
        <cfquery name="GET_HEALTH_EXPENSE_BY_ASSURANCE" datasource="#arguments.dashboard_dsn#">
            SELECT
                CASE
                    WHEN SHAT.MAIN_ASSURANCE_TYPE_ID IS NULL THEN EIPR.ASSURANCE_ID
                    ELSE SHAT2.ASSURANCE_ID
                END ASSURANCE_ID,
                CASE
                    WHEN SHAT.MAIN_ASSURANCE_TYPE_ID IS NULL THEN SHAT.ASSURANCE
                    ELSE SHAT2.ASSURANCE
                END ASSURANCE,
                ISNULL(SUM(EIPR.NET_TOTAL_AMOUNT),0) AS NET_TOTAL_AMOUNT,
                ISNULL(SUM(EIPR.OUR_COMPANY_HEALTH_AMOUNT),0) AS OUR_COMPANY_HEALTH_AMOUNT,
                ISNULL(SUM(EIPR.TREATMENT_AMOUNT),0) AS TREATMENT_AMOUNT
            FROM
                EXPENSE_ITEM_PLAN_REQUESTS EIPR
                LEFT JOIN #dsn#.SETUP_HEALTH_ASSURANCE_TYPE SHAT ON EIPR.ASSURANCE_ID = SHAT.ASSURANCE_ID
                LEFT JOIN #dsn#.SETUP_HEALTH_ASSURANCE_TYPE SHAT2 ON SHAT2.ASSURANCE_ID = SHAT.MAIN_ASSURANCE_TYPE_ID
            WHERE
                EIPR.ASSURANCE_ID IS NOT NULL
                AND EIPR.TREATED IS NOT NULL
                AND EIPR.IS_APPROVE = 1
                AND EIPR.IS_PAYMENT = 1
                AND YEAR(EIPR.#arguments.date_field#) = #arguments.period_year#
            GROUP BY
                CASE
                    WHEN SHAT.MAIN_ASSURANCE_TYPE_ID IS NULL THEN EIPR.ASSURANCE_ID
                    ELSE SHAT2.ASSURANCE_ID
                END,
                CASE
                    WHEN SHAT.MAIN_ASSURANCE_TYPE_ID IS NULL THEN SHAT.ASSURANCE
                    ELSE SHAT2.ASSURANCE
                END
        </cfquery>
        <cfreturn GET_HEALTH_EXPENSE_BY_ASSURANCE>
    </cffunction>
    <cffunction name="GET_HEALTH_EXPENSE_CONTRACTED" access="remote"  returntype="any">
        <cfargument name="dashboard_dsn" default="">
        <cfargument name="date_field" default="">
        <cfargument name="period_year" default="">
        <cfquery name="GET_HEALTH_EXPENSE_CONTRACTED" datasource="#arguments.dashboard_dsn#">
            SELECT
                ISNULL(SUM(NET_TOTAL_AMOUNT),0) AS NET_TOTAL_AMOUNT,
                ISNULL(SUM(OUR_COMPANY_HEALTH_AMOUNT),0) AS OUR_COMPANY_HEALTH_AMOUNT,
                ISNULL(SUM(TREATMENT_AMOUNT),0) AS TREATMENT_AMOUNT
            FROM
                EXPENSE_ITEM_PLAN_REQUESTS
            WHERE
                INVOICE_NO IS NOT NULL
                AND TREATED IS NOT NULL
                AND IS_APPROVE = 1
                AND IS_PAYMENT = 1
                AND YEAR(#arguments.date_field#) = #arguments.period_year#
        </cfquery>
        <cfreturn GET_HEALTH_EXPENSE_CONTRACTED>
    </cffunction>
    <cffunction name="GET_HEALTH_EXPENSE_UNCONTRACTED" access="remote"  returntype="any">
        <cfargument name="dashboard_dsn" default="">
        <cfargument name="date_field" default="">
        <cfargument name="period_year" default="">
        <cfquery name="GET_HEALTH_EXPENSE_UNCONTRACTED" datasource="#arguments.dashboard_dsn#">
            SELECT
                ISNULL(SUM(NET_TOTAL_AMOUNT),0) AS NET_TOTAL_AMOUNT,
                ISNULL(SUM(OUR_COMPANY_HEALTH_AMOUNT),0) AS OUR_COMPANY_HEALTH_AMOUNT,
                ISNULL(SUM(TREATMENT_AMOUNT),0) AS TREATMENT_AMOUNT
            FROM
                EXPENSE_ITEM_PLAN_REQUESTS
            WHERE
                INVOICE_NO IS NULL
                AND TREATED IS NOT NULL
                AND IS_APPROVE = 1
                AND IS_PAYMENT = 1
                AND YEAR(#arguments.date_field#) = #arguments.period_year#
        </cfquery>
        <cfreturn GET_HEALTH_EXPENSE_UNCONTRACTED>
    </cffunction>
    <cffunction name="GET_HEALTH_EXPENSE_MONTHS" access="remote"  returntype="any">
        <cfargument name="dashboard_dsn" default="">
        <cfargument name="date_field" default="">
        <cfargument name="period_year" default="">
        <cfquery name="GET_HEALTH_EXPENSE_MONTHS" datasource="#arguments.dashboard_dsn#">
            WITH t1 as
            (
                SELECT
                    MONTH(#arguments.date_field#) AS EXP_MONTH,
                    ISNULL(SUM(NET_TOTAL_AMOUNT),0) AS NET_TOTAL_AMOUNT,
                    ISNULL(SUM(OUR_COMPANY_HEALTH_AMOUNT),0) AS OUR_COMPANY_HEALTH_AMOUNT,
                    ISNULL(SUM(TREATMENT_AMOUNT),0) AS TREATMENT_AMOUNT
                FROM
                    EXPENSE_ITEM_PLAN_REQUESTS
                WHERE
                    TREATED IS NOT NULL
                    AND IS_APPROVE = 1
                    AND IS_PAYMENT = 1
                    AND YEAR(#arguments.date_field#) = #arguments.period_year#
                GROUP BY
                    MONTH(#arguments.date_field#)
                UNION ALL
                SELECT 1 AS EXP_MONTH, 0 AS NET_TOTAL_AMOUNT, 0 AS OUR_COMPANY_HEALTH_AMOUNT, 0 AS TREATMENT_AMOUNT
                UNION ALL
                SELECT 2 AS EXP_MONTH, 0 AS NET_TOTAL_AMOUNT, 0 AS OUR_COMPANY_HEALTH_AMOUNT, 0 AS TREATMENT_AMOUNT
                UNION ALL
                SELECT 3 AS EXP_MONTH, 0 AS NET_TOTAL_AMOUNT, 0 AS OUR_COMPANY_HEALTH_AMOUNT, 0 AS TREATMENT_AMOUNT
                UNION ALL
                SELECT 4 AS EXP_MONTH, 0 AS NET_TOTAL_AMOUNT, 0 AS OUR_COMPANY_HEALTH_AMOUNT, 0 AS TREATMENT_AMOUNT
                UNION ALL
                SELECT 5 AS EXP_MONTH, 0 AS NET_TOTAL_AMOUNT, 0 AS OUR_COMPANY_HEALTH_AMOUNT, 0 AS TREATMENT_AMOUNT
                UNION ALL
                SELECT 6 AS EXP_MONTH, 0 AS NET_TOTAL_AMOUNT, 0 AS OUR_COMPANY_HEALTH_AMOUNT, 0 AS TREATMENT_AMOUNT
                UNION ALL
                SELECT 7 AS EXP_MONTH, 0 AS NET_TOTAL_AMOUNT, 0 AS OUR_COMPANY_HEALTH_AMOUNT, 0 AS TREATMENT_AMOUNT
                UNION ALL
                SELECT 8 AS EXP_MONTH, 0 AS NET_TOTAL_AMOUNT, 0 AS OUR_COMPANY_HEALTH_AMOUNT, 0 AS TREATMENT_AMOUNT
                UNION ALL
                SELECT 9 AS EXP_MONTH, 0 AS NET_TOTAL_AMOUNT, 0 AS OUR_COMPANY_HEALTH_AMOUNT, 0 AS TREATMENT_AMOUNT
                UNION ALL
                SELECT 10 AS EXP_MONTH, 0 AS NET_TOTAL_AMOUNT, 0 AS OUR_COMPANY_HEALTH_AMOUNT, 0 AS TREATMENT_AMOUNT
                UNION ALL
                SELECT 11 AS EXP_MONTH, 0 AS NET_TOTAL_AMOUNT, 0 AS OUR_COMPANY_HEALTH_AMOUNT, 0 AS TREATMENT_AMOUNT
                UNION ALL
                SELECT 12 AS EXP_MONTH, 0 AS NET_TOTAL_AMOUNT, 0 AS OUR_COMPANY_HEALTH_AMOUNT, 0 AS TREATMENT_AMOUNT
            )
            SELECT
                EXP_MONTH,
                ISNULL(SUM(OUR_COMPANY_HEALTH_AMOUNT),0) AS OUR_COMPANY_HEALTH_AMOUNT,
                ISNULL(SUM(NET_TOTAL_AMOUNT),0) AS NET_TOTAL_AMOUNT,
                ISNULL(SUM(TREATMENT_AMOUNT),0) AS TREATMENT_AMOUNT
            FROM
                T1
            GROUP BY
                EXP_MONTH
        </cfquery>
        <cfreturn GET_HEALTH_EXPENSE_MONTHS>
    </cffunction>
    <cffunction name="GET_HEALTH_EXPENSE_COMPANIES" access="remote"  returntype="any">
        <cfargument name="dashboard_dsn" default="">
        <cfargument name="date_field" default="">
        <cfargument name="period_year" default="">
        <cfquery name="GET_HEALTH_EXPENSE_COMPANIES" datasource="#arguments.dashboard_dsn#">
            SELECT
                EIPR.COMPANY_ID,
                C.NICKNAME,
                ISNULL(SUM(EIPR.NET_TOTAL_AMOUNT),0) AS NET_TOTAL_AMOUNT,
                ISNULL(SUM(EIPR.OUR_COMPANY_HEALTH_AMOUNT),0) AS OUR_COMPANY_HEALTH_AMOUNT,
                ISNULL(SUM(EIPR.TREATMENT_AMOUNT),0) AS TREATMENT_AMOUNT
            FROM
                EXPENSE_ITEM_PLAN_REQUESTS EIPR
                LEFT JOIN #dsn#.COMPANY C ON EIPR.COMPANY_ID = C.COMPANY_ID
            WHERE
                EIPR.INVOICE_NO IS NOT NULL
                AND EIPR.TREATED IS NOT NULL
                AND EIPR.IS_APPROVE = 1
                AND EIPR.IS_PAYMENT = 1
                AND YEAR(EIPR.#arguments.date_field#) = #arguments.period_year#
            GROUP BY
                EIPR.COMPANY_ID, C.NICKNAME
        </cfquery>
        <cfreturn GET_HEALTH_EXPENSE_COMPANIES>
    </cffunction>
    <cffunction name="GET_HEALTH_EXPENSE_RELATIVES" access="remote"  returntype="any">
        <cfargument name="dashboard_dsn" default="">
        <cfargument name="date_field" default="">
        <cfargument name="period_year" default="">
        <cfquery name="GET_HEALTH_EXPENSE_RELATIVES" datasource="#arguments.dashboard_dsn#">
            WITH t1 AS
            (
                SELECT
                    MONTH(EIPR.#arguments.date_field#) AS EXP_MONTH,
                    SUM(ISNULL(EIPR.OUR_COMPANY_HEALTH_AMOUNT,0)) AS BABA,
                    0 AS ANNE,
                    0 AS ES,
                    0 AS COCUK,
                    0 AS KARDES,
                    0 AS CALISAN
                FROM
                    EXPENSE_ITEM_PLAN_REQUESTS EIPR
                    LEFT JOIN #dsn#.EMPLOYEES_RELATIVES ER ON EIPR.RELATIVE_ID = ER.RELATIVE_ID
                WHERE
                    EIPR.TREATED = 2
                    AND ER.RELATIVE_LEVEL = 1
                    AND EIPR.IS_APPROVE = 1
                    AND EIPR.IS_PAYMENT = 1
                    AND YEAR(EIPR.#arguments.date_field#) = #arguments.period_year#
                GROUP BY
                    MONTH(EIPR.#arguments.date_field#)
                UNION ALL
                SELECT
                    MONTH(EIPR.#arguments.date_field#) AS EXP_MONTH,
                    0 AS BABA,
                    SUM(ISNULL(EIPR.OUR_COMPANY_HEALTH_AMOUNT,0)) AS ANNE,
                    0 AS ES,
                    0 AS COCUK,
                    0 AS KARDES,
                    0 AS CALISAN
                FROM
                    EXPENSE_ITEM_PLAN_REQUESTS EIPR
                    LEFT JOIN #dsn#.EMPLOYEES_RELATIVES ER ON EIPR.RELATIVE_ID = ER.RELATIVE_ID
                WHERE
                    EIPR.TREATED = 2
                    AND ER.RELATIVE_LEVEL = 2
                    AND EIPR.IS_APPROVE = 1
                    AND EIPR.IS_PAYMENT = 1
                    AND YEAR(EIPR.#arguments.date_field#) = #arguments.period_year#
                GROUP BY
                    MONTH(EIPR.#arguments.date_field#)
                UNION ALL
                SELECT
                    MONTH(EIPR.#arguments.date_field#) AS EXP_MONTH,
                    0 AS BABA,
                    0 AS ANNE,
                    SUM(ISNULL(EIPR.OUR_COMPANY_HEALTH_AMOUNT,0)) AS ES,
                    0 AS COCUK,
                    0 AS KARDES,
                    0 AS CALISAN
                FROM
                    EXPENSE_ITEM_PLAN_REQUESTS EIPR
                    LEFT JOIN #dsn#.EMPLOYEES_RELATIVES ER ON EIPR.RELATIVE_ID = ER.RELATIVE_ID
                WHERE
                    EIPR.TREATED = 2
                    AND ER.RELATIVE_LEVEL = 3
                    AND EIPR.IS_APPROVE = 1
                    AND EIPR.IS_PAYMENT = 1
                    AND YEAR(EIPR.#arguments.date_field#) = #arguments.period_year#
                GROUP BY
                    MONTH(EIPR.#arguments.date_field#)
                UNION ALL
                SELECT
                    MONTH(EIPR.#arguments.date_field#) AS EXP_MONTH,
                    0 AS BABA,
                    0 AS ANNE,
                    0 AS ES,
                    SUM(ISNULL(EIPR.OUR_COMPANY_HEALTH_AMOUNT,0)) AS COCUK,
                    0 AS KARDES,
                    0 AS CALISAN
                FROM
                    EXPENSE_ITEM_PLAN_REQUESTS EIPR
                    LEFT JOIN #dsn#.EMPLOYEES_RELATIVES ER ON EIPR.RELATIVE_ID = ER.RELATIVE_ID
                WHERE
                    EIPR.TREATED = 2
                    AND ER.RELATIVE_LEVEL IN (4,5)
                    AND EIPR.IS_APPROVE = 1
                    AND EIPR.IS_PAYMENT = 1
                    AND YEAR(EIPR.#arguments.date_field#) = #arguments.period_year#
                GROUP BY
                    MONTH(EIPR.#arguments.date_field#)
                UNION ALL
                SELECT
                    MONTH(EIPR.#arguments.date_field#) AS EXP_MONTH,
                    0 AS BABA,
                    0 AS ANNE,
                    0 AS ES,
                    0 AS COCUK,
                    SUM(ISNULL(EIPR.OUR_COMPANY_HEALTH_AMOUNT,0)) AS KARDES,
                    0 AS CALISAN
                FROM
                    EXPENSE_ITEM_PLAN_REQUESTS EIPR
                    LEFT JOIN #dsn#.EMPLOYEES_RELATIVES ER ON EIPR.RELATIVE_ID = ER.RELATIVE_ID
                WHERE
                    EIPR.TREATED = 2
                    AND ER.RELATIVE_LEVEL = 6
                    AND EIPR.IS_APPROVE = 1
                    AND EIPR.IS_PAYMENT = 1
                    AND YEAR(EIPR.#arguments.date_field#) = #arguments.period_year#
                GROUP BY
                    MONTH(EIPR.#arguments.date_field#)
                UNION ALL
                SELECT
                    MONTH(EIPR.#arguments.date_field#) AS EXP_MONTH,
                    0 AS BABA,
                    0 AS ANNE,
                    0 AS ES,
                    0 AS COCUK,
                    0 AS KARDES,
                    SUM(ISNULL(EIPR.OUR_COMPANY_HEALTH_AMOUNT,0)) AS CALISAN
                FROM
                    EXPENSE_ITEM_PLAN_REQUESTS EIPR
                WHERE
                    EIPR.TREATED = 1
                    AND EIPR.IS_APPROVE = 1
                    AND EIPR.IS_PAYMENT = 1
                    AND YEAR(EIPR.#arguments.date_field#) = #arguments.period_year#
                GROUP BY
                    MONTH(EIPR.#arguments.date_field#)
                UNION ALL
                SELECT 1 EXP_MONTH, 0 BABA, 0 ANNE, 0 ES, 0 COCUK, 0 KARDES, 0 CALISAN
                UNION ALL
                SELECT 2 EXP_MONTH, 0 BABA, 0 ANNE, 0 ES, 0 COCUK, 0 KARDES, 0 CALISAN
                UNION ALL
                SELECT 3 EXP_MONTH, 0 BABA, 0 ANNE, 0 ES, 0 COCUK, 0 KARDES, 0 CALISAN
                UNION ALL
                SELECT 4 EXP_MONTH, 0 BABA, 0 ANNE, 0 ES, 0 COCUK, 0 KARDES, 0 CALISAN
                UNION ALL
                SELECT 5 EXP_MONTH, 0 BABA, 0 ANNE, 0 ES, 0 COCUK, 0 KARDES, 0 CALISAN
                UNION ALL
                SELECT 6 EXP_MONTH, 0 BABA, 0 ANNE, 0 ES, 0 COCUK, 0 KARDES, 0 CALISAN
                UNION ALL
                SELECT 7 EXP_MONTH, 0 BABA, 0 ANNE, 0 ES, 0 COCUK, 0 KARDES, 0 CALISAN
                UNION ALL
                SELECT 8 EXP_MONTH, 0 BABA, 0 ANNE, 0 ES, 0 COCUK, 0 KARDES, 0 CALISAN
                UNION ALL
                SELECT 9 EXP_MONTH, 0 BABA, 0 ANNE, 0 ES, 0 COCUK, 0 KARDES, 0 CALISAN
                UNION ALL
                SELECT 10 EXP_MONTH, 0 BABA, 0 ANNE, 0 ES, 0 COCUK, 0 KARDES, 0 CALISAN
                UNION ALL
                SELECT 11 EXP_MONTH, 0 BABA, 0 ANNE, 0 ES, 0 COCUK, 0 KARDES, 0 CALISAN
                UNION ALL
                SELECT 12 EXP_MONTH, 0 BABA, 0 ANNE, 0 ES, 0 COCUK, 0 KARDES, 0 CALISAN
            )
            SELECT
                EXP_MONTH,
                ISNULL(SUM(BABA),0) AS BABA,
                ISNULL(SUM(ANNE),0) AS ANNE,
                ISNULL(SUM(ES),0) AS ES,
                ISNULL(SUM(COCUK),0) AS COCUK,
                ISNULL(SUM(KARDES),0) AS KARDES,
                ISNULL(SUM(CALISAN),0) AS CALISAN
            FROM
                t1
            GROUP BY
                EXP_MONTH
            ORDER BY
                EXP_MONTH
        </cfquery>
        <cfreturn GET_HEALTH_EXPENSE_RELATIVES>
    </cffunction>
    <cffunction name="GET_HEALTH_EXPENSE_SUM_BY_MONTHS" access="remote"  returntype="any">
        <cfargument name="dashboard_dsn" default="">
        <cfargument name="date_field" default="">
        <cfargument name="period_year" default="">
        <cfquery name="GET_HEALTH_EXPENSE_SUM_BY_MONTHS" datasource="#arguments.dashboard_dsn#">
            WITH t1 as
            (
                SELECT
                    MONTH(#arguments.date_field#) EXP_MONTH,
                    ISNULL(SUM(OUR_COMPANY_HEALTH_AMOUNT),0) AS ANLASMALI,
                    0 ANLASMASIZ,
                    0 KESINTI,
                    0 VERGI,
                    0 TOPLAM
                FROM
                    EXPENSE_ITEM_PLAN_REQUESTS
                WHERE
                    INVOICE_NO IS NOT NULL
                    AND TREATED IS NOT NULL
                    AND IS_APPROVE = 1
                    AND IS_PAYMENT = 1
                    AND YEAR(#arguments.date_field#) = #arguments.period_year#
                GROUP BY
                    MONTH(#arguments.date_field#)
                UNION ALL
                SELECT
                    MONTH(#arguments.date_field#) EXP_MONTH,
                    0 ANLASMALI,
                    ISNULL(SUM(OUR_COMPANY_HEALTH_AMOUNT),0) AS ANLASMASIZ,
                    0 KESINTI,
                    0 VERGI,
                    0 TOPLAM
                FROM
                    EXPENSE_ITEM_PLAN_REQUESTS
                WHERE
                    INVOICE_NO IS NULL
                    AND TREATED IS NOT NULL
                    AND IS_APPROVE = 1
                    AND IS_PAYMENT = 1
                    AND YEAR(#arguments.date_field#) = #arguments.period_year#
                GROUP BY
                    MONTH(#arguments.date_field#)
                UNION ALL
                SELECT
                    MONTH(#arguments.date_field#) EXP_MONTH,
                    0 ANLASMALI,
                    0 ANLASMASIZ,
                    ISNULL(SUM(PAYMENT_INTERRUPTION_VALUE),0) AS KESINTI,
                    ISNULL(SUM(NET_KDV_AMOUNT),0) AS VERGI,
                    ISNULL(SUM(OUR_COMPANY_HEALTH_AMOUNT),0) AS TOPLAM
                FROM
                    EXPENSE_ITEM_PLAN_REQUESTS
                WHERE
                    TREATED IS NOT NULL
                    AND IS_APPROVE = 1
                    AND IS_PAYMENT = 1
                    AND YEAR(#arguments.date_field#) = #arguments.period_year#
                GROUP BY
                    MONTH(#arguments.date_field#)
                UNION ALL
                SELECT 1 EXP_MONTH, 0 ANLASMALI, 0 ANLASMASIZ, 0 KESINTI, 0 VERGI, 0 TOPLAM
                UNION ALL
                SELECT 2 EXP_MONTH, 0 ANLASMALI, 0 ANLASMASIZ, 0 KESINTI, 0 VERGI, 0 TOPLAM
                UNION ALL
                SELECT 3 EXP_MONTH, 0 ANLASMALI, 0 ANLASMASIZ, 0 KESINTI, 0 VERGI, 0 TOPLAM
                UNION ALL
                SELECT 4 EXP_MONTH, 0 ANLASMALI, 0 ANLASMASIZ, 0 KESINTI, 0 VERGI, 0 TOPLAM
                UNION ALL
                SELECT 5 EXP_MONTH, 0 ANLASMALI, 0 ANLASMASIZ, 0 KESINTI, 0 VERGI, 0 TOPLAM
                UNION ALL
                SELECT 6 EXP_MONTH, 0 ANLASMALI, 0 ANLASMASIZ, 0 KESINTI, 0 VERGI, 0 TOPLAM
                UNION ALL
                SELECT 7 EXP_MONTH, 0 ANLASMALI, 0 ANLASMASIZ, 0 KESINTI, 0 VERGI, 0 TOPLAM
                UNION ALL
                SELECT 8 EXP_MONTH, 0 ANLASMALI, 0 ANLASMASIZ, 0 KESINTI, 0 VERGI, 0 TOPLAM
                UNION ALL
                SELECT 9 EXP_MONTH, 0 ANLASMALI, 0 ANLASMASIZ, 0 KESINTI, 0 VERGI, 0 TOPLAM
                UNION ALL
                SELECT 10 EXP_MONTH, 0 ANLASMALI, 0 ANLASMASIZ, 0 KESINTI, 0 VERGI, 0 TOPLAM
                UNION ALL
                SELECT 11 EXP_MONTH, 0 ANLASMALI, 0 ANLASMASIZ, 0 KESINTI, 0 VERGI, 0 TOPLAM
                UNION ALL
                SELECT 12 EXP_MONTH, 0 ANLASMALI, 0 ANLASMASIZ, 0 KESINTI, 0 VERGI, 0 TOPLAM
            )
            SELECT
                EXP_MONTH,
                ISNULL(SUM(ANLASMALI),0) AS ANLASMALI,
                ISNULL(SUM(ANLASMASIZ),0) AS ANLASMASIZ,
                ISNULL(SUM(KESINTI),0) AS KESINTI,
                ISNULL(SUM(VERGI),0) AS VERGI,
                ISNULL(SUM(TOPLAM),0) AS TOPLAM
            FROM
                t1
            GROUP BY
                EXP_MONTH
        </cfquery>
        <cfreturn GET_HEALTH_EXPENSE_SUM_BY_MONTHS>
    </cffunction>
    <cffunction name="ASSURANCE_TYPE_CONTROL" access="remote"  returntype="any">
        <cfargument name="assurance_id" default="">
        <cfquery name="ASSURANCE_TYPE_CONTROL" datasource="#dsn#">
            SELECT
                ASSURANCE_ID,
                IS_MAIN
            FROM
                SETUP_HEALTH_ASSURANCE_TYPE
            WHERE
                ASSURANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#">
        </cfquery>
        <cfif ASSURANCE_TYPE_CONTROL.IS_MAIN eq 1>
            <cfquery name="ASSURANCE_TYPE_CONTROL_2" datasource="#dsn#">
                SELECT
                    ASSURANCE_ID
                FROM
                    SETUP_HEALTH_ASSURANCE_TYPE
                WHERE
                    MAIN_ASSURANCE_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ASSURANCE_TYPE_CONTROL.ASSURANCE_ID#">
            </cfquery>
            <cfreturn ASSURANCE_TYPE_CONTROL_2>
        <cfelse>
            <cfreturn ASSURANCE_TYPE_CONTROL>
        </cfif>
    </cffunction>
</cfcomponent>