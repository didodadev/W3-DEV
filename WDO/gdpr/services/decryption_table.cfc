<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = dsn & "_" & session.ep.period_year & "_" & session.ep.company_id>
    <cfset dsn3 = dsn & "_" & session.ep.company_id>

    <cffunction name="decrypt" access="public">
        <cfargument name="fuseaction">
        <cfargument name="filters">

        <!--- classification bul --->
        <cfquery name="query_gdpr_classification" datasource="#dsn#">
            SELECT * FROM GDPR_CLASSIFICATION WHERE FUSEACTION LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.fuseaction#%'>
        </cfquery>

        <cfif query_gdpr_classification.recordcount eq 0><creturn ""></cfif>

        <!--- tablo bazında grupla --->
        <cfquery name="query_tables" dbtype="query">
            SELECT SCHEMA_NAME, TABLE_NAME, KEY_COLUMN FROM query_gdpr_classification
            GROUP BY SCHEMA_NAME, TABLE_NAME, KEY_COLUMN
        </cfquery>

        <!--- gruplanmış tablolarda gdpr verilerine bak --->
        <cfloop query="query_tables">

            <!--- o tabloya ait column lar --->
            <cfset table_columns = find_table_columns(query_tables.SCHEMA_NAME, query_tables.TABLE_NAME, query_gdpr_classification)>

            <!--- tabloya ait filtreleri al --->
            <cfset table_filters = arrayFilter( arguments.filters, function(filter) {
                return filter[1] eq query_tables.SCHEMA_NAME and filter[2] eq query_tables.TABLE_NAME;
            } )>

            <!--- orijinal tablodan id leri bul --->
            <cfquery name="query_current_table" datasource="#schema_to_dsn(query_tables.SCHEMA_NAME)#">
                SELECT #query_tables.KEY_COLUMN#, #table_columns# FROM #query_tables.TABLE_NAME#
                WHERE #arrayToList( arrayMap( table_filters, 
                    function(filter) {
                        return "#filter[3]# = #filter[4]#";
                    }
                ), " AND ")#
            </cfquery>

            <!--- colonları işleri --->
            <cfloop list="#table_columns#" index="col">

                <cfquery name="query_filtered_classification" dbtype="query">
                    SELECT CLASSIFICATION_ID FROM query_gdpr_classification WHERE SCHEMA_NAME = '#query_tables.SCHEMA_NAME#' AND TABLE_NAME = '#query_tables.TABLE_NAME#' AND COLUMN_NAME = '#col#'
                </cfquery>

                <!--- plevneden orijinal değeri al --->
                <cfquery name="query_original_value" datasource="#dsn#">
                    SELECT PLEVNE_DOCK.PLEVNE_DOCK, PLEVNE_DOCK.PLEVNE_DOOR FROM PLEVNE_DOCK WHERE CLASSIFICATION_ID = #query_filtered_classification.CLASSIFICATION_ID# AND RELATION_ID = #evaluate("query_current_table.#query_tables.KEY_COLUMN#")#
                </cfquery>

                <!--- kapıyı aç --->
                <cfset door = createObject("component", "WDO.gdpr.doors.door#query_original_value.PLEVNE_DOOR#")>

                <!--- kendi yerlerine doldur --->
                <cfquery name="query_update" datasource="#schema_to_dsn(query_tables.SCHEMA_NAME)#">
                    UPDATE #query_tables.TABLE_NAME# SET
                    #col# = #door.decrypt(query_original_value.PLEVNE_DOCK, "wrk" & evaluate("query_current_table.#query_tables.KEY_COLUMN#"))#
                    WHERE #query_tables.KEY_COLUMN# = #evaluate("query_current_table.#query_tables.KEY_COLUMN#")#
                    
                </cfquery>

            </cfloop>

        </cfloop>


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

</cfcomponent>