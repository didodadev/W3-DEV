<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="CreateScript" access="public"  returntype="string" >
        <cfargument name="tableName" type="string" default="">
        <cfquery name="queryCreateScript" datasource="#dsn#" result="result">
        DECLARE @table_name SYSNAME
        SELECT @table_name = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#tableName#'>

        DECLARE 
            @object_name SYSNAME
            , @object_id INT

        SELECT 
            @object_name = '[' + s.name + '].[' + o.name + ']'
            , @object_id = o.[object_id]
        FROM sys.objects o WITH (NOWAIT)
        JOIN sys.schemas s WITH (NOWAIT) ON o.[schema_id] = s.[schema_id]
        WHERE s.name + '.' + o.name = @table_name
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
        SELECT @SQL = 'CREATE TABLE ' + @object_name + CHAR(13) + '(' + CHAR(13) + STUFF((
            SELECT CHAR(9) + ', [' + c.name + '] ' + 
                CASE WHEN c.is_computed = 1
                    THEN 'AS ' + cc.[definition] 
                    ELSE LOWER(tp.name) + 
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
            + ISNULL((SELECT (
                SELECT CHAR(13) +
                    'ALTER TABLE ' + @object_name + ' WITH' 
                    + CASE WHEN fk.is_not_trusted = 1 
                        THEN ' NOCHECK' 
                        ELSE ' CHECK' 
                    END + 
                    ' ADD CONSTRAINT [' + fk.name  + '] FOREIGN KEY(' 
                    + STUFF((
                        SELECT ', [' + k.cname + ']'
                        FROM fk_columns k
                        WHERE k.constraint_object_id = fk.[object_id]
                        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
                    + ')' +
                    ' REFERENCES [' + SCHEMA_NAME(ro.[schema_id]) + '].[' + ro.name + '] ('
                    + STUFF((
                        SELECT ', [' + k.rcname + ']'
                        FROM fk_columns k
                        WHERE k.constraint_object_id = fk.[object_id]
                        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
                    + ')'
                    + CASE 
                        WHEN fk.delete_referential_action = 1 THEN ' ON DELETE CASCADE' 
                        WHEN fk.delete_referential_action = 2 THEN ' ON DELETE SET NULL'
                        WHEN fk.delete_referential_action = 3 THEN ' ON DELETE SET DEFAULT' 
                        ELSE '' 
                    END
                    + CASE 
                        WHEN fk.update_referential_action = 1 THEN ' ON UPDATE CASCADE'
                        WHEN fk.update_referential_action = 2 THEN ' ON UPDATE SET NULL'
                        WHEN fk.update_referential_action = 3 THEN ' ON UPDATE SET DEFAULT'  
                        ELSE '' 
                    END 
                    + CHAR(13) + 'ALTER TABLE ' + @object_name + ' CHECK CONSTRAINT [' + fk.name  + ']' + CHAR(13)
                FROM sys.foreign_keys fk WITH (NOWAIT)
                JOIN sys.objects ro WITH (NOWAIT) ON ro.[object_id] = fk.referenced_object_id
                WHERE fk.parent_object_id = @object_id
                FOR XML PATH(N''), TYPE).value('.', 'NVARCHAR(MAX)')), '')
            + ISNULL(((SELECT
                CHAR(13) + 'CREATE' + CASE WHEN i.is_unique = 1 THEN ' UNIQUE' ELSE '' END 
                        + ' NONCLUSTERED INDEX [' + i.name + '] ON ' + @object_name + ' (' +
                        STUFF((
                        SELECT ', [' + c.name + ']' + CASE WHEN c.is_descending_key = 1 THEN ' DESC' ELSE ' ASC' END
                        FROM index_column c
                        WHERE c.is_included_column = 0
                            AND c.index_id = i.index_id
                        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') + ')'  
                        + ISNULL(CHAR(13) + 'INCLUDE (' + 
                            STUFF((
                            SELECT ', [' + c.name + ']'
                            FROM index_column c
                            WHERE c.is_included_column = 1
                                AND c.index_id = i.index_id
                            FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') + ')', '')  + CHAR(13)
                FROM sys.indexes i WITH (NOWAIT)
                WHERE i.[object_id] = @object_id
                    AND i.is_primary_key = 0
                    AND i.[type] = 2
                FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)')
            ), '')

        SELECT @SQL AS script
        </cfquery>

        <cfset returnQueryText="">
        <cfloop query = "queryCreateScript"> 
            <cfset returnQueryText &= script >
        </cfloop>

        <cfreturn returnQueryText> 

    </cffunction>

    <cffunction name="InsertScript" access="public"  returntype="string" >
        <cfargument name="tableName" type="string" default="">
        <cfargument name="condition" type="string" default="">
        <cfargument name="off_identity" type="boolean" default="0">
        <cfargument name="remove_schema_name" type="boolean" default="0">
        
        <cfquery name="get_table_primary_column" datasource="#dsn#">
            SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_NAME = '#listLast(arguments.tableName,".")#' and TABLE_SCHEMA = '#listFirst(arguments.tableName,".")#'
        </cfquery>
        <cfif get_table_primary_column.recordcount>
            <cfset tablePrimaryColumn = get_table_primary_column.COLUMN_NAME />
        </cfif>
        
        <cfquery name="queryInsertScript" datasource="#dsn#" result="result">
            DECLARE  @Query  Varchar(MAX)=<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#tableName#'>
            SET @Query += ' where 1=1'
            <cfif Len(arguments.condition)>
            SET @Query += ' AND #arguments.condition#'
            </cfif>                                                   
              

            DECLARE @WithStrINdex as INT                            
            DECLARE @WhereStrINdex as INT                            
            DECLARE @INDExtouse as INT                            
            
            DECLARE @SchemaAndTAble VArchar(270)                            
            DECLARE @Schema_name  varchar(30)                            
            DECLARE @Table_name  varchar(240)                            
            DECLARE @Condition  Varchar(MAX)                             
            
            SET @WithStrINdex=0                            
            
            SELECT @WithStrINdex=CHARINDEX('With',@Query )                            
            , @WhereStrINdex=CHARINDEX('WHERE', @Query)                            
            
            IF(@WithStrINdex!=0)                            
            SELECT @INDExtouse=@WithStrINdex                            
            ELSE                            
            SELECT @INDExtouse=@WhereStrINdex                            
            
            SELECT @SchemaAndTAble=Left (@Query,@INDExtouse-1)                                                     
            SELECT @SchemaAndTAble=Ltrim (Rtrim( @SchemaAndTAble))                            
            
            SELECT @Schema_name= Left (@SchemaAndTAble, CharIndex('.',@SchemaAndTAble )-1)                            
            ,      @Table_name = SUBSTRING(  @SchemaAndTAble , CharIndex('.',@SchemaAndTAble )+1,LEN(@SchemaAndTAble) )                            
            
            ,      @Condition=SUBSTRING(@Query,@WhereStrINdex+6,LEN(@Query))--27+6                            
            
            
            DECLARE @COLUMNS  table (Row_number SmallINT , Column_Name VArchar(Max) )                              
            DECLARE @CONDITIONS as varchar(MAX)                              
            DECLARE @Total_Rows as SmallINT                              
            DECLARE @Counter as SmallINT              
            
            DECLARE @ComaCol as varchar(max)            
            SELECT @ComaCol=''                   
            
            SET @Counter=1                              
            SET @CONDITIONS=''                              
            
            INSERT INTO @COLUMNS                              
            SELECT Row_number()Over (Order by ORDINAL_POSITION ) [Count], Column_Name 
            FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_SCHEMA=@Schema_name 
            AND TABLE_NAME=@Table_name 
            <cfif arguments.off_identity eq 0 and IsDefined("tablePrimaryColumn")> AND Column_Name <> '#tablePrimaryColumn#'</cfif>        
            AND Column_Name <> 'RECORD_EMP'
            AND Column_Name <> 'RECORD_IP'
            AND Column_Name <> 'RECORD_DATE'
            AND Column_Name <> 'UPDATE_EMP'
            AND Column_Name <> 'UPDATE_IP'
            AND Column_Name <> 'UPDATE_DATE'
            
            SELECT @Total_Rows= Count(1) 
            FROM @COLUMNS                              
            
            SELECT @Table_name= '['+@Table_name+']'
            SELECT @Schema_name= '['+@Schema_name+']'
              
            While (@Counter<=@Total_Rows )                              
            begin                               
            --PRINT @Counter                              
            
            SELECT @ComaCol= @ComaCol+'['+Column_Name+'],'            
            FROM @COLUMNS                              
            WHERE [Row_number]=@Counter                          
            
            SELECT @CONDITIONS=@CONDITIONS+ ' + Case When ['+Column_Name+'] is null then ''Null'' Else '''''''' + Replace( Convert(varchar(Max),['+Column_Name+']  ) ,'''''''',''''  ) +'''''''' end+'+''','''                                                     
            FROM @COLUMNS                              
            WHERE [Row_number]=@Counter                              
            
            SET @Counter=@Counter+1                              
            
            End                              
            
            SELECT @CONDITIONS=Right(@CONDITIONS,LEN(@CONDITIONS)-2)                              
            
            SELECT @CONDITIONS=LEFT(@CONDITIONS,LEN(@CONDITIONS)-4)              
            SELECT @ComaCol= substring (@ComaCol,0,  len(@ComaCol) )                            
            
            <cfif arguments.remove_schema_name eq 0>
            SELECT @CONDITIONS= '''INSERT INTO '+@Schema_name+'.'+@Table_name+ '('+@ComaCol+')' +' Values( '+'''' + '+'+@CONDITIONS
            <cfelse>
            SELECT @CONDITIONS= '''INSERT INTO '+@Table_name+ '('+@ComaCol+')' +' Values( '+'''' + '+'+@CONDITIONS
            </cfif>
            
            SELECT @CONDITIONS=@CONDITIONS+'+'+ ''');'''                              
            
            SELECT @CONDITIONS= 'Select  '+@CONDITIONS +' as script from  ' +@Schema_name+'.'+@Table_name+' With(NOLOCK) ' + ' Where '+@Condition                              
            --print(@CONDITIONS)                              
            Exec(@CONDITIONS)
        </cfquery>

        <cfset returnQueryText = "" />
        <cfif arguments.off_identity eq 1><cfset returnQueryText="SET IDENTITY_INSERT #arguments.remove_schema_name eq 0 ? arguments.tableName : listLast( arguments.tableName, '.' )# ON" & Chr(13)></cfif>
        <cfloop query = "queryInsertScript" > 
            <cfset returnQueryText &= script >
            <cfset returnQueryText &= Chr(13) >
        </cfloop>
        <cfif arguments.off_identity eq 1><cfset returnQueryText &= "SET IDENTITY_INSERT #arguments.remove_schema_name eq 0 ? arguments.tableName : listLast( arguments.tableName, '.' )# OFF"></cfif>

		<cfreturn returnQueryText>        
    </cffunction>

</cfcomponent>