<cfif attributes.my_type eq 1>
	<cfquery name="get_sales_imports" datasource="#DSN2#">
        SELECT DISTINCT FIS_ID,FIS_PROCESS_TYPE FROM SAYIMLAR WHERE GIRIS_ID = #attributes.file_id#
    </cfquery>
    <cfoutput query="get_sales_imports">
        <cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
            DELETE FROM STOCKS_ROW WHERE PROCESS_TYPE=#FIS_PROCESS_TYPE# AND UPD_ID=#FIS_ID#
        </cfquery>
        <cfquery name="del_stock_fis_row" datasource="#dsn2#">
            DELETE FROM STOCK_FIS_MONEY WHERE ACTION_ID = #FIS_ID#
        </cfquery>
        <cfquery name="del_stock_fis_row" datasource="#dsn2#">
            DELETE FROM STOCK_FIS_ROW WHERE FIS_ID = #FIS_ID#
        </cfquery>
        <cfquery name="DEL_FIS_NUMBER" datasource="#dsn2#">
            DELETE FROM STOCK_FIS WHERE FIS_ID = #FIS_ID#
        </cfquery>
        <cfquery name="DEL_FILE_IMPORTS_TOTAL" datasource="#dsn2#"> 
            UPDATE 
                SAYIMLAR 
            SET 
                FIS_ID=NULL,
                FIS_PROCESS_TYPE= NULL 
            WHERE 
                FIS_ID=#FIS_ID# 
                AND FIS_PROCESS_TYPE=#FIS_PROCESS_TYPE#
        </cfquery>
	</cfoutput>
<cfelse>
	<cfquery name="get_sales_imports" datasource="#DSN2#">
        DELETE FROM SAYIMLAR WHERE GIRIS_ID = #attributes.file_id#
    </cfquery>
</cfif>
<cfoutput>
	<script language="JavaScript" type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfoutput>
