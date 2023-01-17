<cfquery name="GET_CASHES" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
    WITH CTE1 AS (
        SELECT
            ISNULL(CASH_ACTION_TO_CASH_ID,CASH_ACTION_FROM_CASH_ID) AS CASH_ID,
            (CASE WHEN CASH_ACTION_TO_CASH_ID IS NOT NULL THEN 0 ELSE 1 END) AS BA,
            CASH_ACTION_VALUE
        FROM
            CASH_ACTIONS
    ),
    CTE2 AS (
        SELECT
            CASH_ID,
            SUM(ROUND(CTE1.CASH_ACTION_VALUE * (1 - 2 * CTE1.BA),2)) BAKIYE
        FROM
            CTE1
        GROUP BY
            CTE1.CASH_ID
    )
    SELECT 
        DISTINCT
        ISNULL(CTE2.BAKIYE,0) BAKIYE,
        CASH.CASH_ID,
        CASH.CASH_CURRENCY_ID,
        CASH.CASH_NAME,
        CASH.CASH_CODE,
        CASH.CASH_ACC_CODE,
        B.BRANCH_NAME,
        B.BRANCH_ID,
        CASH.CASH_STATUS
    FROM 
        CTE2 RIGHT JOIN CASH ON CASH.CASH_ID=CTE2.CASH_ID
             LEFT JOIN #dsn_alias#.SETUP_MONEY SM ON SM.MONEY=CASH.CASH_CURRENCY_ID
             LEFT JOIN #dsn_alias#.BRANCH B ON B.BRANCH_ID=CASH.BRANCH_ID 
    WHERE
        CASH.CASH_ID IS NOT NULL
		<cfif isDefined("attributes.BRANCH_ID") and len(attributes.BRANCH_ID)>
            AND CASH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.BRANCH_ID#">
        </cfif>
        <cfif (isDefined("attributes.cash_status") and len(attributes.cash_status))>
            AND CASH.CASH_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cash_status#">
        </cfif>
        <cfif isDefined("attributes.cash_currency_id") and len(attributes.cash_currency_id)>
            AND CASH.CASH_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cash_currency_id#">
        </cfif>
        <cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
            AND
            (
                CASH.CASH_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.KEYWORD#%"> OR
                CASH.CASH_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.KEYWORD#%">
            )
        </cfif>
     ORDER BY
        CASH.CASH_NAME
</cfquery>
