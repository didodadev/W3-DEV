<cfquery name="get_table_id" datasource="#dsn_dev#">
    SELECT TABLE_ID FROM SEARCH_TABLES WHERE TABLE_CODE = '#attributes.table_code#'
</cfquery>
<cfset attributes.table_id = get_table_id.TABLE_ID>

<cfquery name="del_rows" datasource="#dsn_dev#">
	DELETE FROM 
    	SEARCH_TABLES_ROWS 
    WHERE 
    	TABLE_ID = #attributes.table_id# 
</cfquery>

<cfquery name="del_rows" datasource="#dsn_dev#">
	DELETE FROM 
    	SEARCH_TABLES_PRODUCTS 
    WHERE 
        TABLE_ID = #attributes.table_id# 
</cfquery>

<cfquery name="del_rows" datasource="#dsn_dev#">
	DELETE FROM SEARCH_TABLES_DEPARTMENTS WHERE TABLE_ID = #attributes.table_id#
</cfquery>

<cfquery name="del_table" datasource="#dsn_dev#">
	DELETE FROM SEARCH_TABLES WHERE TABLE_ID = #attributes.table_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=retail.list_manage_products" addtoken="no">