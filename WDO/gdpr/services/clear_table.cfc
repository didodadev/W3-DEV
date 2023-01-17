<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = dsn & "_product">
    <cfset dsn2 = dsn & "_" & session.ep.period_year & "_" & session.ep.company_id>
    <cfset dsn3 = dsn & "_" & session.ep.company_id>

    <cffunction name="clear">
        <cfargument name="fuseaction">

        <!--- classification bul --->
        <cfquery name="query_gdpr_classification" datasource="#dsn#">
            SELECT * FROM GDPR_CLASSIFICATION WHERE FUSEACTION LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.fuseaction#%'>
        </cfquery>
        
        <!--- tablo bazında grupla --->
        <cfquery name="query_tables" dbtype="query">
            SELECT SCHEMA_NAME, TABLE_NAME, KEY_COLUMN FROM query_gdpr_classification
            GROUP BY SCHEMA_NAME, TABLE_NAME, KEY_COLUMN
        </cfquery>
        
        <!--- gruplanmış tablolarda gdpr verilerine bak --->
        <cfloop query="query_tables">
            
            <!--- o tabloya ait column lar --->
            <cfset table_columns = find_table_columns(query_tables.SCHEMA_NAME, query_tables.TABLE_NAME, query_gdpr_classification)>

            <cfquery name="query_current_table" datasource="#schema_to_dsn(query_tables.SCHEMA_NAME)#">
                UPDATE #query_tables.TABLE_NAME# SET #arrayToList( arrayMap( listToArray(table_columns),
                    function(itm) {
                        lq = duplicate( query_gdpr_classification );
                        lq = queryFilter(lq, function( gdpr_row ) {
                            return gdpr_row.SCHEMA_NAME eq query_tables.SCHEMA_NAME and gdpr_row.TABLE_NAME eq query_tables.TABLE_NAME and gdpr_row.COLUMN_NAME eq itm;
                        });
                        door = createObject("component", "WDO.gdpr.doors.door#lq.PLEVNE_DOOR#");
                        return itm & " = " & door.defaultvalue();
                    }
                ), ", ")#
            </cfquery>

        </cfloop>
    </cffunction>

        <!--- şema tiplerini dsn e çevirir --->
        <cffunction name="schema_to_dsn">
            <cfargument name="schema">
    
            <cfif arguments.schema eq "main">
                <cfreturn dsn>
            <cfelseif arguments.schema eq "period">
                <cfreturn dsn2>
            <cfelseif arguments.schema eq "company">
                <cfreturn dsn3>
            <cfelseif arguments.schema eq "product">
                <cfreturn dsn1>
            </cfif>
        </cffunction>
    
        <!--- gdpr tablosunda ki schema ve table alanlarına göre column ları verir --->
        <cffunction name="find_table_columns">
            <cfargument name="schema_name">
            <cfargument name="table_name">
            <cfargument name="query">
    
            <cfscript>
                filtered = queryFilter( arguments.query, function( row ) {
                    return row.SCHEMA_NAME eq schema_name and row.TABLE_NAME eq table_name;
                });
                result = valueList( filtered.COLUMN_NAME );
            </cfscript>
            <cfreturn result>
        </cffunction>

</cfcomponent>