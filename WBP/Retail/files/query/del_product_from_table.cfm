<cfquery name="del_rows" datasource="#dsn_dev#">
    DELETE FROM 
        SEARCH_TABLES_ROWS 
    WHERE 
        TABLE_ID = #attributes.table_id# 
        AND PRODUCT_ID IN (#attributes.product_id#)
</cfquery>

<cfquery name="del_rows" datasource="#dsn_dev#">
    DELETE FROM 
        SEARCH_TABLES_PRODUCTS 
    WHERE 
        TABLE_ID = #attributes.table_id# 
        AND PRODUCT_ID IN (#attributes.product_id#)
</cfquery>