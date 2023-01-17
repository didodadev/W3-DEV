<cftry>
    <cfquery name="DEL_PROCESS_TYPE_ROWS_WORKGRUOP" datasource="#dsn#"><!--- Ilgili asamanin surec grubunu siler --->
        DELETE FROM PROCESS_TYPE_ROWS_WORKGRUOP 
        WHERE 
            MAINWORKGROUP_ID = <cfqueryparam value="#attributes.workgroup_id#" cfsqltype="cf_sql_integer">
            AND PROCESS_ROW_ID = <cfqueryparam value="#attributes.process_row_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    
    <script type="text/javascript">
        wrk_opener_reload();
        window.close();
    </script>

    <cfcatch type="any">
        <script type="text/javascript">alert("<cf_get_lang dictionary_id = '52126'>")</script>
    </cfcatch>
</cftry>