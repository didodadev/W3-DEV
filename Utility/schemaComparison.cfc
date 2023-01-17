﻿<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name = "createTableScript" access = "private">
        <cfargument name = "object" type = "string">
        <cfargument name = "source_ds" type = "string">
        <cfargument name = "target_ds" type = "string">

        <cfquery name = "getCreateTableScript" datasource = "#source_ds#">
            DECLARE @table_name SYSNAME
            SELECT @table_name = '#arguments.object#'

            DECLARE 
                @object_name SYSNAME
                , @object_id INT

            SELECT 
                @object_name = '[' + o.name + ']'
                , @object_id = o.[object_id]
            FROM sys.objects o WITH (NOWAIT)
            JOIN sys.schemas s WITH (NOWAIT) ON o.[schema_id] = s.[schema_id]
            WHERE o.name = @table_name
                AND o.[type] = 'U'
                AND o.is_ms_shipped = 0

            DECLARE @SQL NVARCHAR(MAX) = ''

            ;WITH index_column AS 
            (
                SELECT 
                    ic.[object_id]
                    , ic.index_id
                    , ic.is_descending_key
                    , ic.is_included_column
                    , c.name
                FROM sys.index_columns ic WITH (NOWAIT)
                JOIN sys.columns c WITH (NOWAIT) ON ic.[object_id] = c.[object_id] AND ic.column_id = c.column_id
                WHERE ic.[object_id] = @object_id
            ),
            fk_columns AS 
            (
                SELECT 
                    k.constraint_object_id
                    , cname = c.name
                    , rcname = rc.name
                FROM sys.foreign_key_columns k WITH (NOWAIT)
                JOIN sys.columns rc WITH (NOWAIT) ON rc.[object_id] = k.referenced_object_id AND rc.column_id = k.referenced_column_id 
                JOIN sys.columns c WITH (NOWAIT) ON c.[object_id] = k.parent_object_id AND c.column_id = k.parent_column_id
                WHERE k.parent_object_id = @object_id
            )
            SELECT @SQL = 'CREATE TABLE #target_schema#.' + @object_name + CHAR(13) + '(' + CHAR(13) + STUFF((
                SELECT CHAR(9) + ', [' + c.name + '] ' + 
                    CASE WHEN c.is_computed = 1
                        THEN 'AS ' + cc.[definition] 
                        ELSE tp.name + 
                            CASE WHEN tp.name IN ('varchar', 'char', 'varbinary', 'binary', 'text')
                                THEN '(' + CASE WHEN c.max_length = -1 THEN 'MAX' ELSE CAST(c.max_length AS VARCHAR(5)) END + ')'
                                WHEN tp.name IN ('nvarchar', 'nchar', 'ntext')
                                THEN '(' + CASE WHEN c.max_length = -1 THEN 'MAX' ELSE CAST(c.max_length / 2 AS VARCHAR(5)) END + ')'
                                WHEN tp.name IN ('datetime2', 'time2', 'datetimeoffset') 
                                THEN '(' + CAST(c.scale AS VARCHAR(5)) + ')'
                                WHEN tp.name = 'decimal' 
                                THEN '(' + CAST(c.[precision] AS VARCHAR(5)) + ',' + CAST(c.scale AS VARCHAR(5)) + ')'
                                ELSE ''
                            END +
                            CASE WHEN c.collation_name IS NOT NULL THEN ' COLLATE ' + c.collation_name ELSE '' END +
                            CASE WHEN c.is_nullable = 1 THEN ' NULL' ELSE ' NOT NULL' END +
                            CASE WHEN dc.[definition] IS NOT NULL THEN ' DEFAULT' + dc.[definition] ELSE '' END + 
                            CASE WHEN ic.is_identity = 1 THEN ' IDENTITY(' + CAST(ISNULL(ic.seed_value, '0') AS CHAR(1)) + ',' + CAST(ISNULL(ic.increment_value, '1') AS CHAR(1)) + ')' ELSE '' END 
                    END + CHAR(13)
                FROM sys.columns c WITH (NOWAIT)
                JOIN sys.types tp WITH (NOWAIT) ON c.user_type_id = tp.user_type_id
                LEFT JOIN sys.computed_columns cc WITH (NOWAIT) ON c.[object_id] = cc.[object_id] AND c.column_id = cc.column_id
                LEFT JOIN sys.default_constraints dc WITH (NOWAIT) ON c.default_object_id != 0 AND c.[object_id] = dc.parent_object_id AND c.column_id = dc.parent_column_id
                LEFT JOIN sys.identity_columns ic WITH (NOWAIT) ON c.is_identity = 1 AND c.[object_id] = ic.[object_id] AND c.column_id = ic.column_id
                WHERE c.[object_id] = @object_id
                ORDER BY c.column_id
                FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, CHAR(9) + ' ')
                + ISNULL((SELECT CHAR(9) + ', CONSTRAINT [' + k.name + '] PRIMARY KEY (' + 
                                (SELECT STUFF((
                                    SELECT ', [' + c.name + '] ' + CASE WHEN ic.is_descending_key = 1 THEN 'DESC' ELSE 'ASC' END
                                    FROM sys.index_columns ic WITH (NOWAIT)
                                    JOIN sys.columns c WITH (NOWAIT) ON c.[object_id] = ic.[object_id] AND c.column_id = ic.column_id
                                    WHERE ic.is_included_column = 0
                                        AND ic.[object_id] = k.parent_object_id 
                                        AND ic.index_id = k.unique_index_id     
                                    FOR XML PATH(N''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, ''))
                        + ')' + CHAR(13)
                        FROM sys.key_constraints k WITH (NOWAIT)
                        WHERE k.parent_object_id = @object_id 
                            AND k.[type] = 'PK'), '') + ')'  + CHAR(13)
            SELECT @SQL AS CREATE_SCRIPT
        </cfquery>
        <cfreturn getCreateTableScript.create_script>
    </cffunction>
    <cffunction name = "schemaComparison" access = "remote" returnType = "any" returnFormat = "json">
        <cfargument name = "source_ds" type = "string">
        <cfargument name = "target_ds" type = "string">

        <cftry>
            <cfset dsStruct = getDataSources()>

            <cfscript>
                diffStruct = {};
            </cfscript>

            <cfset dsList = listAppend(source_ds, target_ds)>

            <cfloop from = "1" to = "#listlen(dsList)#" index = "ds">
                <cfset thisDS = listGetAt(dsList, ds)>

                <cfquery name = "getSchemaStructure" datasource = "#thisDS#">
                    WITH CTE11 AS (
                            SELECT
                                i.name as index_name,
                                s.name as schema_name,
                                t.name as object_name,
                                c.name as column_name,
                                t.object_id,
                                '[' + c.name + '] ' + CASE ic.is_descending_key WHEN 1 THEN 'DESC' ELSE 'ASC' END AS COL_DEF
                            FROM
                                sys.tables t
                                    LEFT JOIN sys.schemas s on s.schema_id = t.schema_id
                                    LEFT JOIN sys.indexes i on i.object_id = t.object_id and i.type = 2
                                    LEFT JOIN sys.index_columns ic on ic.object_id = i.object_id and ic.index_id = i.index_id
                                    LEFT JOIN sys.columns c on c.object_id = t.object_id and c.column_id = ic.column_id
                            WHERE
                                1 = 1
                    ),
                    CTE12 AS (
                        SELECT
                            schema_name,
                            object_name,
                            index_name,
                            object_id,
                            CREATE_INDEX_SQL = 'CREATE NONCLUSTERED INDEX [' + index_name + '] ON [' + schema_name + '].[' + object_name + '] (' +
                                STUFF(
                                (
                                    SELECT
                                        ',' + col_def 
                                    FROM
                                        CTE11 c1
                                    WHERE
                                        c1.schema_name = c2.schema_name
                                        and c1.object_name = c2.object_name
                                        and c1.index_name = c2.index_name
                                    FOR XML PATH (''))
                                    , 1, 1, ''
                            ) + ')',
                            'DROP INDEX [' + index_name + '] ON [' + schema_name + '].[' + object_name + ']' AS DROP_INDEX_SQL
                        FROM
                            CTE11 c2
                        GROUP BY
                            schema_name,
                            object_name,
                            index_name,
                            object_id
                    ),
                    CTE1 AS (
                        SELECT
                            schema_name,
                            object_name,
                            object_id,
                            CREATE_INDEX_SQL = STUFF((
                                SELECT
                                    ' ' + CREATE_INDEX_SQL
                                FROM
                                    CTE12 c1
                                WHERE
                                    c1.schema_name = c2.schema_name
                                    and c1.object_name = c2.object_name
                                FOR XML PATH (''))
                                , 1, 1, ''
                            ),
                            DROP_INDEX_SQL = STUFF((
                                SELECT
                                    ' ' + DROP_INDEX_SQL
                                FROM
                                    CTE12 c1
                                WHERE
                                    c1.schema_name = c2.schema_name
                                    and c1.object_name = c2.object_name
                                FOR XML PATH (''))
                                , 1, 1, ''
                            )
                        FROM
                            CTE12 c2
                        GROUP BY
                            schema_name,
                            object_name,
                            object_id
                    )
                    SELECT
                        s.schema_id,
                        s.name AS schema_name,
                        o.object_id,
                        o.name AS object_name,
                        t.system_type_id,
                        t.user_type_id,
                        t.name AS type_name,
                        c.column_id,
                        c.name AS column_name,
                        c.system_type_id,
                        c.user_type_id,
                        CASE c.max_length WHEN -1 THEN 'max' ELSE CONVERT(varchar,c.max_length / (CASE WHEN t.name IN ('nvarchar','nchar','ntext') THEN 2 ELSE 1 END)) END AS max_length,
                        c.precision,
                        c.scale,
                        c.collation_name,
                        c.is_nullable,
                        c.is_ansi_padded,
                        c.is_rowguidcol,
                        c.is_identity,
                        c.is_computed,
                        c.is_filestream,
                        c.is_replicated,
                        c.is_non_sql_subscribed,
                        c.is_merge_published,
                        c.is_dts_replicated,
                        c.is_xml_document,
                        c.xml_collection_id,
                        c.default_object_id,
                        c.rule_object_id,
                        c.is_sparse,
                        c.is_column_set,
                        CTE1.DROP_INDEX_SQL,
                        CTE1.CREATE_INDEX_SQL
                    FROM
                        sys.schemas s
                            LEFT JOIN sys.objects o on o.schema_id = s.schema_id
                            LEFT JOIN sys.columns c on c.object_id = o.object_id
                            LEFT JOIN sys.types t on t.system_type_id = c.system_type_id AND t.user_type_id = c.user_type_id
                            LEFT JOIN CTE1 ON CTE1.object_id = o.object_id
                    WHERE
                        s.name = SCHEMA_NAME()
                        AND o.type = 'U'
                    ORDER BY
                        s.name,
                        o.name,
                        c.name
                </cfquery>
                <cfif listFind(source_ds, thisDS)>
                    <cfset dbStruct.source[thisDS] = getSchemaStructure>
                <cfelseif listFind(target_ds, thisDS)>
                    <cfset dbStruct.target[thisDS] = getSchemaStructure>
                </cfif>
            </cfloop>

            <cfloop from = "1" to = "#listLen(source_ds)#" index = "s">
                <cfset source_schema = listGetAt(source_ds, s)>
                <cfloop from = "1" to = "#listLen(target_ds)#" index = "t">
                    <cfset target_schema = listGetAt(target_ds, t)>

                    <cfset diffStruct[target_schema] = {}>

                    <cfset source_structure = dbStruct['source'][source_schema]>
                    <cfset target_structure = dbStruct['target'][target_schema]>

                    <cfquery name = "getSourceObjects" dbtype = "query">
                        SELECT DISTINCT OBJECT_NAME, CREATE_INDEX_SQL FROM source_structure
                    </cfquery>

                    <cfloop query = "getSourceObjects">
                        <cfset alter_or_create_table = 0>

                        <cfquery name = "isObjectExistsOnTarget" dbtype = "query">
                            SELECT OBJECT_ID, DROP_INDEX_SQL FROM target_structure WHERE OBJECT_NAME = '#getSourceObjects.object_name[getSourceObjects.currentrow]#'
                        </cfquery>

                        <cfif isObjectExistsOnTarget.recordcount>
                            <!--- hedefte obje mevcut --->
                            <cfquery name = "getSourceColumns" dbtype = "query">
                                SELECT * FROM source_structure WHERE OBJECT_NAME = '#getSourceObjects.object_name[getSourceObjects.currentrow]#'
                            </cfquery>

                            <cfloop query = "getSourceColumns">
                                <cfquery name = "getTargetColumn" dbtype = "query">
                                    SELECT * FROM target_structure WHERE OBJECT_NAME = '#getSourceObjects.object_name[getSourceObjects.currentrow]#' AND COLUMN_NAME = '#getSourceColumns.column_name[getSourceColumns.currentrow]#'
                                </cfquery>

                                <cfif getTargetColumn.recordcount>
                                    <!--- hedefte kolon mevcut --->
                                    <cfscript>
                                        alterColumn = 0;
                                        alterColumnDescription = '';
                                        alterColumnType = '';

                                        /*
                                            alter tipleri şunlar:
                                            type - max_length - precision - scale
                                            collation_name
                                            is_nullable
                                        */

                                        source_column_type = getSourceColumns.type_name[getSourceColumns.currentrow];

                                        switch(getSourceColumns.type_name[getSourceColumns.currentrow]) {
                                            case "nvarchar" :
                                            case "varchar" :
                                                source_column_type = '#getSourceColumns.type_name[getSourceColumns.currentrow]#(#getSourceColumns.max_length[getSourceColumns.currentrow]#)';
                                            break;
                                            case "nchar" :
                                            case "char" :
                                                source_column_type = '#getSourceColumns.type_name[getSourceColumns.currentrow]#(#getSourceColumns.max_length[getSourceColumns.currentrow]#)';
                                            break;
                                            case "ntext" :
                                            case "text" :
                                                source_column_type = '#getSourceColumns.type_name[getSourceColumns.currentrow]#';
                                            break;
                                            case "decimal" :
                                                source_column_type = '#getSourceColumns.type_name[getSourceColumns.currentrow]#(#getSourceColumns.precision[getSourceColumns.currentrow]#,#getSourceColumns.scale[getSourceColumns.currentrow]#)';
                                            break;
                                        }
                                        
                                        switch(getTargetColumn.type_name) {
                                            case "nvarchar" :
                                            case "varchar" :
                                                target_column_type = '#getTargetColumn.type_name#(#getTargetColumn.max_length#)';
                                            break;
                                            case "nchar" :
                                            case "char" :
                                                target_column_type = '#getTargetColumn.type_name#(#getTargetColumn.max_length#)';
                                            break;
                                            case "ntext" :
                                            case "text" :
                                                target_column_type = '#getTargetColumn.type_name#';
                                            break;
                                            case "decimal" :
                                                target_column_type = '#getTargetColumn.type_name[getSourceColumns.currentrow]#(#getTargetColumn.precision#,#getTargetColumn.scale#)';
                                            break;
                                            default :
                                                target_column_type = getTargetColumn.type_name;
                                            break;
                                        }

                                        if(getSourceColumns.type_name[getSourceColumns.currentrow] neq getTargetColumn.type_name or getSourceColumns.max_length[getSourceColumns.currentrow] neq getTargetColumn.max_length or getSourceColumns.precision[getSourceColumns.currentrow] neq getTargetColumn.precision or getSourceColumns.scale[getSourceColumns.currentrow] neq getTargetColumn.scale or getSourceColumns.is_nullable[getSourceColumns.currentrow] neq getTargetColumn.is_nullable) {
                                            alterColumn = 1;
                                            alterColumnType = listAppend(alterColumnType, 'type');

                                            alterColumnDescription = listAppend(alterColumnDescription, 'Change type from #target_column_type# to #source_column_type#');
                                        }

                                        if(getSourceColumns.collation_name[getSourceColumns.currentrow] neq getTargetColumn.collation_name and 1 eq 2) {
                                            alterColumn = 1;
                                            alterColumnType = listAppend(alterColumnType, 'collation_name');
                                            alterColumnDescription = listAppend(alterColumnDescription, 'Change collation_name from #getTargetColumn.collation_name# to #getSourceColumns.collation_name[getSourceColumns.currentrow]#');
                                        }

                                        if(getSourceColumns.is_nullable[getSourceColumns.currentrow] neq getTargetColumn.is_nullable) {
                                            alterColumn = 1;
                                            alterColumnType = listAppend(alterColumnType, 'is_nullable');
                                            alterColumnDescription = listAppend(alterColumnDescription, 'Change is_nullable from #getTargetColumn.is_nullable# to #getSourceColumns.is_nullable[getSourceColumns.currentrow]#');
                                        }

                                        if(alterColumn eq 1) {
                                            alter_or_create_table = 1;

                                            if(not structKeyExists(diffStruct[target_schema], getSourceObjects.object_name)) {
                                                diffStruct[target_schema][getSourceObjects.object_name] = {};
                                            }
                                            if(not structKeyExists(diffStruct[target_schema][getSourceObjects.object_name], 'columns')) {
                                                diffStruct[target_schema][getSourceObjects.object_name].columns = {};
                                            }

                                            type_sql = source_column_type;

                                            if(len(getSourceColumns.collation_name[getSourceColumns.currentrow])) {
                                                collation_sql = ' COLLATE #getSourceColumns.collation_name[getSourceColumns.currentrow]#';
                                            } else {
                                                collation_sql = '';
                                            }

                                            nullable_sql = ' ' & iif(getSourceColumns.is_nullable[getSourceColumns.currentrow],DE("NULL"),DE("NOT NULL"));

                                            alterColumnSQL = 'ALTER TABLE #target_schema#.#getSourceObjects.object_name[getSourceObjects.currentrow]# ALTER COLUMN #getSourceColumns.column_name[getSourceColumns.currentrow]# #type_sql##collation_sql##nullable_sql#';

                                            diffStruct[target_schema][getSourceObjects.object_name].diffType = 'different_object';
                                            diffStruct[target_schema][getSourceObjects.object_name]['columns'][getSourceColumns.column_name[getSourceColumns.currentrow]] = {};
                                            diffStruct[target_schema][getSourceObjects.object_name]['columns'][getSourceColumns.column_name[getSourceColumns.currentrow]].diffType = 'different_column';
                                            diffStruct[target_schema][getSourceObjects.object_name]['columns'][getSourceColumns.column_name[getSourceColumns.currentrow]].diffDescription = 'Modify column #getSourceColumns.column_name[getSourceColumns.currentrow]# on table #target_schema#.#getSourceObjects.object_name[getSourceObjects.currentrow]#. #alterColumnDescription#';
                                            diffStruct[target_schema][getSourceObjects.object_name]['columns'][getSourceColumns.column_name[getSourceColumns.currentrow]].diffSQL = '#alterColumnSQL#';
                                        }
                                    </cfscript>
                                <cfelse>
                                    <!--- hedefte kolon mevcut değil --->
                                    <cfscript>
                                        if(not structKeyExists(diffStruct[target_schema], getSourceObjects.object_name)) {
                                            diffStruct[target_schema][getSourceObjects.object_name] = {};
                                        }
                                        if(not structKeyExists(diffStruct[target_schema][getSourceObjects.object_name], 'columns')) {
                                            diffStruct[target_schema][getSourceObjects.object_name].columns = {};
                                        }
                                        switch(getSourceColumns.type_name[getSourceColumns.currentrow]) {
                                            case "nvarchar" :
                                                column_type = '#getSourceColumns.type_name[getSourceColumns.currentrow]#(#getSourceColumns.max_length[getSourceColumns.currentrow]#)';
                                            break;
                                            case "nchar" :
                                                column_type = '#getSourceColumns.type_name[getSourceColumns.currentrow]#(#getSourceColumns.max_length[getSourceColumns.currentrow]#)';
                                            break;
                                            case "ntext" :
                                                column_type = '#getSourceColumns.type_name[getSourceColumns.currentrow]#(#getSourceColumns.max_length[getSourceColumns.currentrow]#)';
                                            break;

                                            default :
                                                column_type = getSourceColumns.type_name[getSourceColumns.currentrow];
                                            break;
                                        }
                                        diffStruct[target_schema][getSourceObjects.object_name].diffType = 'different_object';
                                        diffStruct[target_schema][getSourceObjects.object_name]['columns'][getSourceColumns.column_name[getSourceColumns.currentrow]] = {};
                                        diffStruct[target_schema][getSourceObjects.object_name]['columns'][getSourceColumns.column_name[getSourceColumns.currentrow]].diffType = 'missing_column';
                                        diffStruct[target_schema][getSourceObjects.object_name]['columns'][getSourceColumns.column_name[getSourceColumns.currentrow]].diffDescription = 'Add column #getSourceColumns.column_name[getSourceColumns.currentrow]# to table #target_schema#.#getSourceObjects.object_name[getSourceObjects.currentrow]#';
                                        diffStruct[target_schema][getSourceObjects.object_name]['columns'][getSourceColumns.column_name[getSourceColumns.currentrow]].diffSQL = 'ALTER TABLE #target_schema#.#getSourceObjects.object_name[getSourceObjects.currentrow]# ADD #getSourceColumns.column_name[getSourceColumns.currentrow]# #column_type#';
                                    </cfscript>
                                </cfif>
                            </cfloop>
                        <cfelse>
                            <cfset alter_or_create_table = 1>
                            <!--- hedefte obje mevcut değil --->
                            <cfscript>
                                diffStruct[target_schema][getSourceObjects.object_name] = {};
                                diffStruct[target_schema][getSourceObjects.object_name].diffType = 'missing_object';
                                diffStruct[target_schema][getSourceObjects.object_name].diffDescription = 'Create table #target_schema#.#getSourceObjects.object_name[getSourceObjects.currentrow]#';
                                diffStruct[target_schema][getSourceObjects.object_name].diffSQL = createTableScript(getSourceObjects.object_name[getSourceObjects.currentrow],source_schema,target_schema);
                            </cfscript>
                        </cfif>

                        <cfscript>
                            if(alter_or_create_table eq 1) {
                                diffStruct[target_schema][getSourceObjects.object_name].drop_indexes_sql = isObjectExistsOnTarget.drop_index_sql;
                                diffStruct[target_schema][getSourceObjects.object_name].create_indexes_sql = replace(getSourceObjects.create_index_sql[getSourceObjects.currentrow],source_schema,target_schema,'all');
                            }
                        </cfscript>

                        <cfif structCount(diffStruct[target_schema]) gt 200>
                            <cfbreak>
                        </cfif>
                    </cfloop>
                </cfloop>
            </cfloop>

            <cfcatch>
                <cfscript>
                    diffStruct.error = cfcatch.Message;
                    diffStruct.errorDetail = cfcatch;
                </cfscript>
            </cfcatch>
            <cffinally>
                <cfscript>
                    diffJSON = serializeJSON(diffStruct);
                    if(left(diffJSON,2) eq '//') {
                        diffJSON = replace(diffJSON, '//', '');
                    }
                    return diffJSON;
                </cfscript>
            </cffinally>
        </cftry>
    </cffunction>

    <cffunction name = "getDatasources" access = "remote" returnType = "any" returnformat="plain">
        <cfargument name="datasource" type="string" required="false" default="">

        <cfset arguments.datasource = (IsDefined("arguments.datasource") and Len(arguments.datasource)) ? arguments.datasource : application.systemParam.systemParam().dsn />
        
        <cfquery name="getDataSource" datasource="#datasource#">
            SELECT
                DATA_SOURCE_NAME
            FROM
                WRK_DATA_SOURCE
            WHERE
                1 = 1
            ORDER BY
                DATA_SOURCE_NAME
        </cfquery>

        <cfloop from = "1" to = "#getDataSource.recordcount#" index = "i">
            <cfquery name = "get_schemas_#i#" datasource="#getDataSource.data_source_name[i]#">
                SELECT
                    '#getDataSource.data_source_name[i]#' AS SCHEMA_NAME

                UNION ALL

                SELECT
                    '#getDataSource.data_source_name[i]#_product'

                UNION ALL

                SELECT
                    '#getDataSource.data_source_name[i]#_' + convert(varchar,COMP_ID)
                FROM
                     #getDataSource.data_source_name[i]#.OUR_COMPANY

                UNION ALL

                SELECT
                    '#getDataSource.data_source_name[i]#_' + convert(varchar,PERIOD_YEAR) + '_' + convert(varchar,OUR_COMPANY_ID)
                FROM
                     #getDataSource.data_source_name[i]#.SETUP_PERIOD
            </cfquery>
        </cfloop>

        <cfquery name = "all_datasources" dbtype="query">
            <cfloop from = "1" to = "#getDataSource.recordcount#" index = "i">
                SELECT SCHEMA_NAME FROM get_schemas_#i#

                <cfif i neq getDataSource.recordcount>
                    UNION ALL
                </cfif>
            </cfloop>
            ORDER BY SCHEMA_NAME
        </cfquery>


        <cfreturn replace(serializeJSON(all_datasources),'//','')>
    </cffunction>

    <cffunction name = "runSQL" access = "remote" returnType = "any" returnFormat = "plain">
        <cfargument name="datasource" type = "string">
        <cfargument name="query" type = "string">

        <cftry>
            <cfset returnStruct = {}>
            <cfscript>
                sqlExecuter = new query( datasource = arguments.datasource );
                sqlExecuter.execute( sql = arguments.query);
            </cfscript>
            <cfset returnStruct.success = 1>
            <cfset returnStruct.message = 'Query has been executed successfully.'>
            <cfcatch>
                <cfset returnStruct.success = 0>
                <cfset returnStruct.message = cfcatch.queryError>
            </cfcatch>
        </cftry>

        <cfreturn replace(serializeJSON(returnStruct),'//','')>
    </cffunction>
</cfcomponent>
