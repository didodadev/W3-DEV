<!---
    File :          encryption table
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          13.12.2019
    Description :   GDPR da fuseaction eşleşmesine göre tabloları hashler
    Notes :         
--->
<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = dsn & "_product">
    <cfset dsn2 = dsn & "_" & session.ep.period_year & "_" & session.ep.company_id>
    <cfset dsn3 = dsn & "_" & session.ep.company_id>

    <cffunction name="encrypt" access="public">
        <cfargument name="fuseaction">

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
            
            <!--- o tabloda ki classificate edilen column lardan null olmayanları getir şifreleyelim --->
            <cfquery name="query_current_table" datasource="#schema_to_dsn(query_tables.SCHEMA_NAME)#">
                SELECT #query_tables.KEY_COLUMN#, #table_columns# FROM #query_tables.TABLE_NAME#
                WHERE #arrayToList( arrayMap( listToArray(table_columns), 
                    function(itm) {
                        lq = duplicate( query_gdpr_classification );
                        lq = queryFilter(lq, function( gdpr_row ) {
                            return gdpr_row.SCHEMA_NAME eq query_tables.SCHEMA_NAME and gdpr_row.TABLE_NAME eq query_tables.TABLE_NAME and gdpr_row.COLUMN_NAME eq itm;
                        });
                        door = createObject("component", "WDO.gdpr.doors.door#lq.PLEVNE_DOOR#");
                        return itm & " <> " & door.defaultvalue();
                    }
                ), " OR ")#
            </cfquery>

            <!--- o tabloda ki verileri işleyelim --->
            <cfloop query="query_current_table">

                <!--- column lara bakıyoruz --->
                <cfloop list="#table_columns#" index="table_column_name">

                    <!--- column gdpr id sini alak ki plevnede lazım olucek --->
                    <cfset gdprid = find_column_gdprid( query_tables.SCHEMA_NAME, query_tables.TABLE_NAME, table_column_name, query_gdpr_classification )>

                    <!--- çoklu alan üzerinde sorgu yapıldığı için column dolumu bakmak gerekir --->
                    <cfif len(evaluate("query_current_table.#table_column_name#"))>
                        
                        <cfscript>
                            lq = duplicate( query_gdpr_classification );
                            lq = queryFilter(lq, function( gdpr_row ) {
                                return gdpr_row.SCHEMA_NAME eq query_tables.SCHEMA_NAME and gdpr_row.TABLE_NAME eq query_tables.TABLE_NAME and gdpr_row.COLUMN_NAME eq table_column_name;
                            });
                        </cfscript>

                        <!--- plevnede kaydı varsa güncelle yoksa yeni bir plevne satırı aç --->
                        <!--- be gardaş gezdiren gendin gendini --->
                        <cfquery name="query_update_plevne" datasource="#dsn#">
                            IF EXISTS ( SELECT 1 FROM PLEVNE_DOCK WHERE CLASSIFICATION_ID = #gdprid# AND RELATION_ID = #evaluate("query_current_table.#query_tables.KEY_COLUMN#")# )
                            BEGIN
                                UPDATE PLEVNE_DOCK SET PLEVNE_DOCK = #"'" & door.encrypt( evaluate("query_current_table.#table_column_name#"), "wrk" & evaluate("query_current_table.#query_tables.KEY_COLUMN#")) & "'"# 
                                WHERE CLASSIFICATION_ID = #gdprid# AND RELATION_ID = #evaluate("query_current_table.#query_tables.KEY_COLUMN#")#
                            END
                            ELSE
                            BEGIN
                                INSERT INTO PLEVNE_DOCK ( CLASSIFICATION_ID, SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, KEY_COLUMN, RELATION_ID, PLEVNE_DOOR, PLEVNE_DOCK )
                                VALUES ( #gdprid#, '#query_tables.SCHEMA_NAME#', '#query_tables.TABLE_NAME#', '#table_column_name#', '#query_tables.KEY_COLUMN#', #evaluate("query_current_table.#query_tables.KEY_COLUMN#")#, #lq.PLEVNE_DOOR#, #"'" & door.encrypt(evaluate("query_current_table.#table_column_name#"), "wrk" & evaluate("query_current_table.#query_tables.KEY_COLUMN#")) & "'"# );
                            END
                        </cfquery>

                    </cfif>
                    
                </cfloop>

            </cfloop>

            <cfscript>
                setnull_code = arrayMap( listToArray(table_columns), 
                        function(itm) {
                            lq = duplicate( query_gdpr_classification );
                            lq = queryFilter(lq, function( gdpr_row ) {
                                return gdpr_row.SCHEMA_NAME eq query_tables.SCHEMA_NAME and gdpr_row.TABLE_NAME eq query_tables.TABLE_NAME and gdpr_row.COLUMN_NAME eq itm;
                            });
                            door = createObject("component", "WDO.gdpr.doors.door#lq.PLEVNE_DOOR#");
                            return itm & " = " & door.defaultvalue();
                        }
                    );
                isnotnull_code = arrayMap( listToArray(table_columns), 
                        function(itm) {
                            lq = duplicate( query_gdpr_classification );
                            lq = queryFilter(lq, function( gdpr_row ) {
                                return gdpr_row.SCHEMA_NAME eq query_tables.SCHEMA_NAME and gdpr_row.TABLE_NAME eq query_tables.TABLE_NAME and gdpr_row.COLUMN_NAME eq itm;
                            });
                            door = createObject("component", "WDO.gdpr.doors.door#lq.PLEVNE_DOOR#");
                            return itm & " <> " & door.defaultvalue();
                        }
                    );
            </cfscript>
            <!--- o tabloda ki classificate edilen column ları temizleyelim --->
            <cfquery name="query_current_table_empty" datasource="#schema_to_dsn(query_tables.SCHEMA_NAME)#">
                UPDATE #query_tables.TABLE_NAME#
                SET #arrayToList( setnull_code, ", ")#
                WHERE #arrayToList( isnotnull_code, " OR ")#
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

    <!--- gdpr tablosunda ki schema table ve column alanlarına göre classification id yi verir --->
    <cffunction name="find_column_gdprid">
        <cfargument name="schema_name">
        <cfargument name="table_name">
        <cfargument name="column_name">
        <cfargument name="query">

        <cfscript>
            lq = duplicate( arguments.query );
            filtered = queryFilter( lq, function( row ) {
                return row.SCHEMA_NAME eq schema_name and row.TABLE_NAME eq table_name and row.COLUMN_NAME eq column_name;
            });
        </cfscript>

        <cfreturn filtered.CLASSIFICATION_ID>
    </cffunction>

</cfcomponent>