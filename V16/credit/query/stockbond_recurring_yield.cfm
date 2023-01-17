
<cf_date tarih="attributes.due_date">
<cfquery name="add_row" datasource=#dsn3#>
    INSERT INTO #dsn3_alias#.STOCKBONDS_YIELD_PLAN_ROWS
        (
            STOCKBOND_ID,
            OPERATION_NAME,
            IS_PAYMENT,
            BANK_ACTION_DATE,
            AMOUNT,
            EXPENSE_ITEM_TAHAKKUK_ID,
            RECURRING_YIELD,
            RECURRING_ACTION_DATE,
            RECURRING_DUE_VALUE,
            RECURRING_YIELD_RATE,
            RECURRING_YIELD_TOTAL
        )
        VALUES 
        (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stockbond_id#">,
            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="1. Getiri">,
            0,
            <cfqueryparam cfsqltype="cf_sql_date"  value="#attributes.due_date#">,
            <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.getiri_tutari#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tahakkuk_item_id#">,
            1,
            <cfqueryparam cfsqltype="cf_sql_date"  value="#attributes.action_date#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.due_value#">,
            <cfqueryparam cfsqltype="cf_sql_float"  value="#attributes.getiri_orani#">,
            <cfqueryparam cfsqltype="cf_sql_float"  value="#attributes.getiri_tutari#">
        )
</cfquery>
