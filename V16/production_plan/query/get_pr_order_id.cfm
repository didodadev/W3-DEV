<cfquery name="get_p_order_result" datasource="#DSN3#">
    SELECT
        PR_ORDER_ID
    FROM
        PRODUCTION_ORDER_RESULTS
    WHERE
        P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#">
</cfquery>

