<cfquery name="get_table_info" datasource="#dsn_dev#">
	SELECT UPPER_TABLE_CODE FROM STOCK_MANAGE_TABLES WHERE TABLE_CODE = '#attributes.table_code#'
</cfquery>

<cfquery name="get_table_upper" datasource="#dsn_dev#">
	SELECT TABLE_CODE FROM STOCK_MANAGE_TABLES WHERE UPPER_TABLE_CODE = '#attributes.table_code#'
</cfquery>
<cftransaction>
    <!--- stok tablolari siliniyor --->
    <cfquery name="del_" datasource="#dsn2#">
        DELETE FROM STOCKS_ROW WHERE WRK_ROW_ID = '#attributes.table_code#'
    </cfquery>
    
    <cfif len(get_table_info.UPPER_TABLE_CODE)>
    	<cfquery name="del_" datasource="#dsn2#">
            DELETE FROM STOCKS_ROW WHERE WRK_ROW_ID = '#get_table_info.UPPER_TABLE_CODE#'
        </cfquery>
    </cfif>
    
    <cfif get_table_upper.recordcount>
    	<cfquery name="del_" datasource="#dsn2#">
            DELETE FROM STOCKS_ROW WHERE WRK_ROW_ID = '#get_table_upper.TABLE_CODE#'
        </cfquery>
    </cfif>
    <!--- stok tablolari siliniyor --->
    
    <!--- liste tablolari siliniyor --->
    <cfquery name="del_" datasource="#dsn2#">
    	DELETE FROM #dsn_dev_alias#.STOCK_MANAGE_TABLES WHERE TABLE_CODE = '#attributes.table_code#'
    </cfquery>
    
    <cfif len(get_table_info.UPPER_TABLE_CODE)>
    	<cfquery name="del_" datasource="#dsn2#">
            DELETE FROM #dsn_dev_alias#.STOCK_MANAGE_TABLES WHERE TABLE_CODE = '#get_table_info.UPPER_TABLE_CODE#'
        </cfquery>
    </cfif>
    
    <cfif get_table_upper.recordcount>
    	<cfquery name="del_" datasource="#dsn2#">
            DELETE FROM #dsn_dev_alias#.STOCK_MANAGE_TABLES WHERE TABLE_CODE = '#get_table_upper.TABLE_CODE#'
        </cfquery>
    </cfif>
    <!--- liste tablolari siliniyor --->
</cftransaction>
<script>
	window.opener.location.reload();
	window.close();
</script>