<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Egemen Ateş		Developer	: Egemen Ateş		
Analys Date : 18/05/2016			Dev Date	: 18/05/2016		
Description :
	Bu Companent tablo bilgilerini ve kolon bilgilerini döndürür.
----------------------------------------------------------------------->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset download_folder = application.systemParam.systemParam().download_folder />
    <!--- Bu fonksiyon Schema Bilgilerini Döndürür --->
    <cffunction name="SchemaInfo" access="remote" returntype="query">
        <cfquery name="get" datasource="#dsn#">
            SELECT
                TOP 50 * 
            FROM
                INFORMATION_SCHEMA.SCHEMATA
            WHERE
                SCHEMA_NAME LIKE '#dsn#%'
            ORDER BY
                SCHEMA_NAME
        </cfquery>
        <cfset DBLog("SchemaInfo", serializeJSON(arguments))>
        <cfreturn get>
    </cffunction>
    <!--- Bu fonksiyon Tablo Bilgilerini Döndürür--->
    <cffunction name="TableInfo" access="remote" returntype="query" >
		<cfargument name="table_name" type="string" default="">
        <cfargument name="schema_name" type="string" default="">
        <cfquery name="get" datasource="#dsn#">
			SELECT 
            	TOP 50 * 
            FROM 
            	INFORMATION_SCHEMA.TABLES 
            WHERE 
            	TABLE_SCHEMA LIKE 'V16_CATALYST%'
            ORDER BY 
            	TABLE_SCHEMA,TABLE_NAME
        </cfquery>
        <cfset DBLog("TableInfo", serializeJSON(arguments),#arguments.schema_name#,#arguments.table_name#)>
		<cfreturn get>
	</cffunction>
    <cffunction name="TableInfoAjax" access="remote" returnFormat="plain" returntype="string" >
        <cfargument name="table_name" type="string" default="">
        <cfquery name="get" datasource="#dsn#">
			SELECT 
            	TOP 50 * 
            FROM 
            	INFORMATION_SCHEMA.TABLES 
            WHERE 
            	TABLE_SCHEMA LIKE 'V16_CATALYST%' 
                <cfif len(arguments.table_name)>
                	AND TABLE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.table_name#%">
                </cfif>
            ORDER BY 
            	TABLE_SCHEMA,TABLE_NAME
        </cfquery>
        <cfset DBLog("TableInfo", serializeJSON(arguments))>
		<cfreturn replace(serializeJson(get),'//','')>
    </cffunction>

    <cffunction name="TableInfoAjaxWithPaging" access="remote" returnformat="plain" returntype="string">
        <cfargument name="table_name" type="string" default="">
        <cfargument name="page" type="numeric" default="0">
        <cfargument name="scheme_name" type="string" default="V16_CATALYST%">
        <cfset offset=page*100>
        <cfquery name="pagecount" datasource="#dsn#">
            SELECT
                CEILING(COUNT(*) / 100) as PAGES
            FROM 
            	INFORMATION_SCHEMA.TABLES 
            WHERE 
            	TABLE_SCHEMA LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheme_name#">
                <cfif len(arguments.table_name)>
                	AND TABLE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.table_name#%">
                </cfif>
        </cfquery>
        <cfquery name="get" datasource="#dsn#">
            SELECT 
            	*
            FROM 
            	INFORMATION_SCHEMA.TABLES 
            WHERE 
            	TABLE_SCHEMA LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheme_name#">
                <cfif len(arguments.table_name)>
                	AND LOWER(TABLE_NAME) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(LCase(arguments.table_name))#%">
                </cfif>
            ORDER BY 
            	TABLE_SCHEMA,TABLE_NAME
            OFFSET #offset# ROWS FETCH NEXT 100 ROWS ONLY
        </cfquery>
        <cfset DBLog("TableInfo", serializeJSON(arguments),#arguments.scheme_name#,#arguments.table_name#)>
        <cfreturn '{ "PAGECOUNT" : ' & pagecount.PAGES & ', "TABLEINFO" : ' & replace(serializeJSON(get), '//', '') & ' }'>
    </cffunction>
    <!---Bu fonksiyon Kolon Bilgilerini Döndürür --->
    <cffunction name="ColumnInfo" access="remote" returntype="query">
    	<cfargument name="schema_name" type="string" default="">
        <cfargument name="table_name"  type="string" default="">
        <cfargument name="column_name" type="string" default="">
            <cfquery name="get" datasource="#dsn#">
                SELECT 
                    i_s.COLUMN_NAME,
                    i_s.DATA_TYPE,
                    i_s.CHARACTER_MAXIMUM_LENGTH MAXIMUM_LENGTH,
                    s.value DESCRIPTION_TR,
                    i_s.TABLE_SCHEMA,
                    i_s.IS_NULLABLE,
                    COLUMNPROPERTY(object_id(TABLE_SCHEMA+'.'+TABLE_NAME), COLUMN_NAME, 'IsIdentity') AS IS_IDENTITY
                FROM
                    INFORMATION_SCHEMA.COLUMNS as i_s
                    LEFT JOIN sys.columns AS sc ON sc.object_id= OBJECT_ID(i_s.TABLE_SCHEMA+'.'+i_s.TABLE_NAME) AND sc.name=i_s.COLUMN_NAME
                    LEFT JOIN sys.extended_properties s ON s.major_id = OBJECT_ID(i_s.TABLE_SCHEMA+'.'+i_s.TABLE_NAME) AND s.minor_id = sc.column_id AND s.name = 'MS_Description'
                 WHERE
                    1=1
                <cfif isdefined("arguments.schema_name") and len(arguments.schema_name)>
                    AND i_s.TABLE_SCHEMA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.schema_name#">
                </cfif>
                <cfif isdefined("arguments.table_name") and len(arguments.table_name)>
                    AND i_s.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.table_name#">
                </cfif>
                <cfif (isdefined("arguments.column_name") and len(arguments.column_name))>
                    AND i_s.COLUMN_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.column_name#%">
                </cfif>
            </cfquery>
        <cfset DBLog("ColumnInfo", serializeJSON(arguments),#arguments.schema_name#,#arguments.table_name#,#arguments.column_name#)>
        <cfreturn get>
    </cffunction>

    <cffunction name="ColumnInfoAjax" access="remote" returnformat="plain" returntype="string">
    	<cfargument name="schema_name" type="string" default="">
        <cfargument name="table_name"  type="string" default="">
        <cfargument name="column_name" type="string" default="">
            <cfquery name="get" datasource="#dsn#">
                SELECT 
                    i_s.COLUMN_NAME,
                    i_s.DATA_TYPE,
                    i_s.CHARACTER_MAXIMUM_LENGTH MAXIMUM_LENGTH,
                    s.value DESCRIPTION_TR,
                    i_s.TABLE_SCHEMA,
                    i_s.IS_NULLABLE
                FROM
                    INFORMATION_SCHEMA.COLUMNS as i_s
                    LEFT JOIN sys.extended_properties s ON s.major_id = OBJECT_ID(i_s.TABLE_SCHEMA+'.'+i_s.TABLE_NAME) AND s.minor_id = i_s.ORDINAL_POSITION AND s.name = 'MS_Description'
                 WHERE
                    1=1
                <cfif isdefined("arguments.schema_name") and len(arguments.schema_name)>
                    AND i_s.TABLE_SCHEMA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.schema_name#">
                </cfif>
                <cfif isdefined("arguments.table_name") and len(arguments.table_name)>
                    AND i_s.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.table_name#">
                </cfif>
            </cfquery>
        <cfset DBLog("ColumnInfo", serializeJSON(arguments),#arguments.schema_name#,#arguments.table_name#,#arguments.column_name#)>
        <cfreturn replace(serializeJSON(get), '//', '')>
    </cffunction>

    <cffunction name="PKInfo" access="public" returntype="query">
        <cfargument name="scheme" type="string">
        <cfargument name="table" type="string">
        <cfquery name="query_pkinfo" datasource="#dsn#">
            SELECT cu.COLUMN_NAME
            FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS cc
            INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE cu ON cc.CONSTRAINT_NAME = cu.CONSTRAINT_NAME
            WHERE cc.TABLE_SCHEMA = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.scheme#'> 
                AND cc.TABLE_NAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.table#'> AND cc.CONSTRAINT_TYPE = 'PRIMARY KEY'
        </cfquery>
    </cffunction>
    
    <cffunction name="GetCount" access="remote" returntype="any">
        <cfargument name="schema_name" type="string">
        <cfargument name="table_name" type="string">
        <cfargument name="column_name" type="string" default="">
        <cfargument name="column_type" type="string" default="NVARCHAR">
        <cfargument name="filter_value" type="any" default="">
        <cfquery name="get" datasource="#dsn#">
            SELECT COUNT(<cfif arguments.column_name eq "">*<cfelse>#column_name#</cfif>) AS CNT FROM #arguments.schema_name#.#arguments.table_name#
            <cfif arguments.filter_value neq "">
            WHERE #column_name# <cfif arguments.filter_value eq "NULL">IS NULL<cfelse>= <cfqueryparam cfsqltype="CF_SQL_#column_type#" value="#filter_value#"></cfif> 
            </cfif>
        </cfquery>
        <cfset DBLog("ColumnInfo", serializeJSON(arguments),#arguments.schema_name#,#arguments.table_name#,#arguments.column_name#)>
        <cfreturn get.CNT>
    </cffunction>
    
    <!--- colon günceller --->
	<cffunction name="UpdColumn" access="remote" returntype="any">
        <cfargument name="column_name" type="string" required="yes">
		<cfargument name="schema_name" type="string" required="yes">
		<cfargument name="table_name" type="string"  required="yes">
        <cfargument name="max_length" type="string" default=""  required="yes">
        <cfargument name="description_tr" type="string"  required="yes">
		<cfargument name="data_type" type="string">        
        
        <cftransaction>
        <cfquery name="updColumn" datasource="#dsn#" result="queryResult">
            DECLARE @extendedCount INT
            ALTER TABLE #arguments.schema_name#.#arguments.table_name#
            ALTER COLUMN #arguments.column_name# #arguments.data_type# <cfif len(arguments.max_length) >(#arguments.max_length#)</cfif>
            
            select 
            @extendedCount=COUNT(sep.value)
            from sys.tables st
            inner join sys.columns sc on st.object_id = sc.object_id
            INNER JOIN sys.schemas scm ON scm.schema_id=st.schema_id
            left join sys.extended_properties sep on st.object_id = sep.major_id
                                                and sc.column_id = sep.minor_id
                                                and sep.name = 'MS_Description'
            WHERE scm.name='#arguments.schema_name#' AND st.name = '#arguments.table_name#' AND sc.name = '#arguments.column_name#'
            
            IF(@extendedCount>0)
            BEGIN
            EXEC sp_dropextendedproperty 
                @level0type=N'SCHEMA', @level0name='#arguments.schema_name#',
                @level1type=N'TABLE', @level1name='#arguments.table_name#',
                @level2type=N'COLUMN', @level2name='#arguments.column_name#',
                @name=N'MS_Description'
            EXEC sp_addextendedproperty 
                @name = N'MS_Description', @value = '#arguments.description_tr#',
                @level0type = N'Schema',   @level0name = '#arguments.schema_name#',
                @level1type = N'Table',    @level1name = '#arguments.table_name#',
                @level2type = N'Column',   @level2name = '#arguments.column_name#'
            END
            ELSE
            BEGIN
            EXEC sp_addextendedproperty 
                @name = N'MS_Description', @value = '#arguments.description_tr#',
                @level0type = N'Schema',   @level0name = '#arguments.schema_name#',
                @level1type = N'Table',    @level1name = '#arguments.table_name#',
                @level2type = N'Column',   @level2name = '#arguments.column_name#'
            END


        </cfquery>
        </cftransaction>
        <!---
        <cfif len(arguments.max_length)>
        	<cfquery name="updMaxLength" datasource="#dsn#">
				ALTER TABLE #arguments.schema_name#.#arguments.table_name# ALTER COLUMN #arguments.column_name# VARCHAR (#arguments.max_length#)
            </cfquery>
        </cfif>
        --->
        <cfset DBLog("UpdColumn", serializeJSON(arguments), #queryResult.sql#, #arguments.schema_name#, #arguments.table_name#, #arguments.column_name#)>
        <cfreturn  'ok' >
    </cffunction>
    
    <!--- Tablo kolonunu siler --->
	<cffunction name="DropColumn" access="remote" returntype="any">
        <cfargument name="column_name" type="string" required="yes">
		<cfargument name="schema_name" type="string" required="yes">
		<cfargument name="table_name" type="string"  required="yes">
		
        <cfquery name="dropColumnQuery" datasource="#dsn#" result="queryResult">
            ALTER TABLE #arguments.schema_name#.#arguments.table_name#
            DROP COLUMN #arguments.column_name# 
        </cfquery>
        <cfset DBLog("DropColumn", serializeJSON(arguments),#queryResult.sql#,#arguments.schema_name#,#arguments.table_name#,#arguments.column_name#)>
        <cfreturn  'ok' >
    </cffunction>

	<!--- yeni kolon ekler --->
    <cffunction name="SaveColumn" access="remote" returntype="any" returnformat="JSON" >
        <cfargument name="column_name" type="string" required="yes">
		<cfargument name="schema_name" type="string" required="yes">
		<cfargument name="table_name" type="string"  required="yes">
		<cfargument name="description_tr" type="string"  required="yes">
		<cfargument name="max_len" type="string"  required="yes">
		<cfargument name="data_type" type="string"  required="yes">

        <cfset objResponse=StructNew()>
        <cftry>
            
        <cfquery name="updColumn" datasource="#dsn#" result="queryResult">
        	ALTER TABLE 
            	#arguments.schema_name#.#arguments.table_name#
            ADD 
            	#arguments.column_name# 
                #arguments.data_type#<cfif len(arguments.max_len)>(#arguments.max_len#)</cfif>
			<cfif len(arguments.description_tr)>
                EXEC sp_addextendedproperty 
                    @name = N'MS_Description', @value = '#arguments.description_tr#',
                    @level0type = N'Schema',   @level0name = '#arguments.schema_name#',
                    @level1type = N'Table',    @level1name = '#arguments.table_name#',
                    @level2type = N'Column',   @level2name = '#arguments.column_name#'
			</cfif>                
        </cfquery>
        <cfset DBLog("SaveColumn", serializeJSON(arguments), #queryResult.sql#,#arguments.schema_name#,#arguments.table_name#,#arguments.column_name#)>                

        <cfset objResponse.SUCCESS=true >
        <cfcatch type="exception">
            <cfset objResponse.SUCCESS=false >
        </cfcatch>
        </cftry>
        

        <cfset jsonResponse= serializeJSON(objResponse,"struct") >
        <cfset jsonResponse=replace(jsonResponse,"//","")>
        <cfreturn jsonResponse >

    </cffunction>

    <!--- yeni tablo ekler --->
    <cffunction name="Add" access="remote" returntype="any" returnformat="JSON" >
        <cfset objResponse=StructNew()>
        <cftry>

            <!---<cflock name="#createUUID()#" timeout="20">--->
                <cftransaction>
                
                <cfquery name="query_table" datasource="#dsn#" result="queryResult">
                    CREATE TABLE #arguments.schema#.#arguments.table_name#
                    (
                    <cfloop from="1" to="#arguments.sayac_kontrol#" index="idx">
                        <cfif isDefined("arguments.colum_name_" & idx)>
                        #arguments['colum_name_' & idx]# #arguments['data_type_' & idx]# <cfif isDefined("arguments.max_len_" & idx) and len(arguments['max_len_' & idx])>(#arguments['max_len_' & idx]#)</cfif> <cfif isDefined("arguments.auto_increment_" & idx) and arguments['auto_increment_' & idx] eq 1>IDENTITY (1,1)</cfif><cfif isDefined("arguments.primary_key_" & idx) and arguments['primary_key_' & idx] eq 1> PRIMARY KEY NOT NULL </cfif><cfif idx lt arguments.sayac_kontrol>,</cfif>       
                        </cfif>
                    </cfloop>
                    ) 

                    <cfif isDefined("arguments.table_desc")>
                        <cfif arguments.table_desc gt 0 >
                            EXEC sys.sp_addextendedproperty @name = 'MS_Description',       -- sysname
                                    @value = '#arguments.table_desc#',      -- sql_variant
                                    @level0type = 'Schema',   -- varchar(128)
                                    @level0name = #arguments.schema#, -- sysname
                                    @level1type = 'Table',   -- varchar(128)
                                    @level1name = #arguments.table_name# -- sysname
                  
                        </cfif>
                    </cfif>
                    <cfloop from="1" to="#arguments.sayac_kontrol#" index="idx">
                        <cfif isDefined("arguments.colum_name_" & idx)>
                            <cfif len(arguments["description_tr_" & idx]) gt 0>
                            EXEC sys.sp_addextendedproperty @name = 'MS_Description',       -- sysname
                                @value = '#arguments["description_tr_" & idx]#',      -- sql_variant
                                @level0type = 'Schema',   -- varchar(128)
                                @level0name = #arguments.schema#, -- sysname
                                @level1type = 'Table',   -- varchar(128)
                                @level1name = #arguments.table_name#, -- sysname
                                @level2type = 'Column',   -- varchar(128)
                                @level2name = #arguments["colum_name_" & idx]#; -- sysname
                            </cfif>
                        </cfif>
                    </cfloop>
                
                </cfquery>


                <cfset DBLog("Add", serializeJSON(arguments),#queryResult.sql#,#arguments.schema#,#arguments.table_name#)>

                </cftransaction>
            <!---</cflock>--->


            <cfset objResponse.SUCCESS=true >
        <cfcatch type="exception">
            <cfset objResponse.SUCCESS=false >
        </cfcatch>
        </cftry>
        

        <cfset jsonResponse= serializeJSON(objResponse,"struct") >
        <cfset jsonResponse=replace(jsonResponse,"//","")>
        <cfreturn jsonResponse >
    </cffunction>
    <cffunction name="Query_result" access="remote" returntype="any" output="true">
        <cfargument name="q" type="string">
        <cfquery name="query_runner" datasource="#dsn#" maxrows="500">
            #preserveSingleQuotes(arguments.q)#
        </cfquery>
        <cfreturn query_runner>
    </cffunction>

    <!--- run query --->
    <cffunction name="Query" access="remote" returntype="any" output="true">
        <cfargument name="q" type="string">
        <cfset DBLog("Query", serializeJSON(arguments))>
        <cfif findNoCase('drop ', arguments.q) or findNoCase('truncate ', arguments.q) or findNoCase('--', arguments.q)>
            <cfdump var="#{ message: "Query contains dangerous variable. Please check and re-run!", query: arguments.q }#" abort>
        </cfif>
        <cfquery name="query_runner" datasource="#dsn#" maxrows="500">
            #preserveSingleQuotes(arguments.q)#
        </cfquery>

        <!--- Schema ve table name bilgilerini bulur --->
        <cfloop list="#arguments.q#" item="item" index="i" delimiters=" ">
            <cfif lCase(item) eq 'from'>

                <cfset tableName = listGetAt(arguments.q, i + 1, " ") />
                <cfif tableName contains '.'>
                    <cfset objectsArray = listToArray(tableName,".") />
                    <cfset tableSchema = arrayLen( objectsArray ) eq 3 ? objectsArray[2] : objectsArray[1] />
                    <cfset tableName = objectsArray[arrayLen( objectsArray )] />
                <cfelse>
                    <cfset tableSchema = dsn />
                </cfif>

                <cfquery name="get_table_primary_column" datasource="#dsn#">
                    SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_NAME = '#tableName#' and TABLE_SCHEMA = '#tableSchema#'
                </cfquery>
                <cfif get_table_primary_column.recordcount>
                    <cfset tablePrimaryColumn = get_table_primary_column.COLUMN_NAME />
                </cfif>

                <cfbreak>
            </cfif>
        </cfloop>
        <script>
            if($('table[sort="true"]').length > 0){
                $('table[sort="true"]').dragtable({
                    dragaccept: '.drag-enable',
                    dragHandle: '.table-handle',
                }).tablesorter();
                $( 'table[sort="true"] th' ).each(function( index , element ) {
                    if($(this).hasClass('header_icn_none'))
                    {
                        $(this).unbind('click');
                    }
                    else if ($(this).hasClass('header_icn_text')) 
                    {
                        $(this).unbind('click');		
                    }
                });
            }
        </script>
        <cfset iterator = createObject("component", "WDO.helpers.queryIterator").init(query_runner)>
        <cf_grid_list sort="1">
            <thead>
                <tr>
                    <cfif isDefined("tablePrimaryColumn")><th><input type="checkbox" id="primary_column_id_all"></th></cfif>
                    <th>Row Nr</th>
                    <cfloop array="#iterator.columns#" index="name">
                    <th><cfoutput>#name#</cfoutput></th>
                    </cfloop>
                </tr>
            </thead>
            <tbody>
                <cfset rownr = 0>
                <cfloop condition="#iterator.hasiter()#">
                    <tr>
                        <cfif isDefined("tablePrimaryColumn")><td><input type="checkbox" name="primary_column_id" class="primary_column_id" value="<cfoutput>#iterator.Get(tablePrimaryColumn)#</cfoutput>"></td></cfif>
                        <td><cfoutput>#++rownr#</cfoutput></td>
                        <cfset rowarr = iterator.GetRowArray()>
                        <cfloop from="1" to="#arrayLen(rowarr)#" index="i">
                        <td><cfoutput>#rowarr[i]#</cfoutput></td>
                        </cfloop>
                        <cfset iterator.Next()>
                    </tr>
                </cfloop>
            </tbody>
        </cf_grid_list>
        <cf_grid_list>
            <tbody>
                <tr>
                    <td><b>Count</b></td>
                    <td><cfoutput>#query_runner.recordcount#</cfoutput></td>
                </tr>
                <cfif isDefined("query_runner.recordcount")>
                    <cfquery name="query_count" datasource="#dsn#" maxrows="1">
                        SELECT COUNT(*) AS CNT FROM (#preserveSingleQuotes(arguments.q)#) TBL
                    </cfquery>
                    <tr><td><b>Total</b></td><td><cfoutput>#query_count.CNT#</cfoutput></td></tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif isDefined("tablePrimaryColumn")>
            <div class="ui-info-bottom flex-end">
                <a href="javascript://" onclick="sendToDBManager('<cfoutput>#tableSchema#</cfoutput>','<cfoutput>#tableName#</cfoutput>','<cfoutput>#tablePrimaryColumn#</cfoutput>')" class="ui-wrk-btn ui-wrk-btn-success">Send To Data Script</a>
            </div>
        </cfif>
        <script>
            document.querySelector('##primary_column_id_all').addEventListener('change', function() {
                if( this.checked ) document.querySelectorAll('.primary_column_id').forEach(element => { element.checked = true });
                else document.querySelectorAll('.primary_column_id').forEach(element => { element.checked = false });
            });
        </script>
    </cffunction>

    <!--- dblog --->
    <cffunction name="DBLog">
        <cfargument name="eventlog_type">
        <cfargument name="parameters_dump">
        <cfargument name="queryresult" default="">
        <cfargument name="schema" default="">
        <cfargument name="table" default="">
        <cfargument name="column" default="">

        <cfquery name="query_log" datasource="#dsn#">
            INSERT INTO WRK_DBLOG(
                EVENT_TYPE,
                PARAMETERS_DUMP,
                RECORD_IP,
                RECORD_USER
                <cfif len(arguments.queryresult)>
                    ,QUERY_RESULT
                </cfif>
                <cfif len(arguments.schema)>
                    ,SCHEMA_NAME
                </cfif>
                <cfif len(arguments.table)>
                    ,TABLE_NAME
                </cfif>
                <cfif len(arguments.column)>
                    ,COLUMN_NAME
                </cfif>
            ) VALUES (
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.eventlog_type#'>
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.parameters_dump#'>
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#cgi.remote_addr#'>
                ,<cfif isDefined('session.ep')><cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer"><cfelseif isDefined('session.pp')><cfqueryparam value="#session.pp.userid#" cfsqltype="cf_sql_integer"><cfelse><cfqueryparam value="#session.pda.userid#" cfsqltype="cf_sql_integer"></cfif>
                <cfif len(arguments.queryresult)>,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.queryresult#'></cfif>
                <cfif len(arguments.schema)>
                    ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.schema#'>
                </cfif>
                <cfif len(arguments.table)>
                    ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.table#'>
                </cfif>
                <cfif len(arguments.column)>
                    ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.column#'>
                </cfif>
            )
        </cfquery>
    </cffunction>

    <!--- Database Dashboard --->
    <cffunction name="GetDesignDashboard" access="public" returntype="struct">
        <!---<cfargument name="" type="string">--->

        <cfset dashboardStruct=StructNew()>

        <cfset dsn1 = '#dsn#_product'>
        <cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">
        <cfset dsn3 = "#dsn#_#session.ep.company_id#">

        <cfquery name="getSchemaCount" datasource="#dsn#">
            SELECT COUNT(T.TABLE_SCHEMA) CNT FROM (
            SELECT TABLE_SCHEMA FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_TYPE='BASE TABLE'
            AND TABLE_SCHEMA IN(
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn#'>,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn1#'>,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn2#'>,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn3#'>
            )            
            GROUP BY TABLE_SCHEMA) T
        </cfquery>

        <cfquery name="getTableCount" datasource="#dsn#">
            SELECT COUNT(*) as CNT FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_TYPE='BASE TABLE'
            AND TABLE_SCHEMA IN(
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn#'>,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn1#'>,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn2#'>,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn3#'>
            )
        </cfquery>

        <cfquery name="getViewCount" datasource="#dsn#">
            SELECT COUNT(*) as CNT FROM INFORMATION_SCHEMA.VIEWS
            WHERE TABLE_SCHEMA IN(
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn#'>,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn1#'>,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn2#'>,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn3#'>
            )
        </cfquery>

        <cfquery name="getColumnCount" datasource="#dsn#">
            SELECT COUNT(*) AS CNT FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA IN(
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn#'>,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn1#'>,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn2#'>,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn3#'>
            )
        </cfquery>       
        
        <cfquery name="getEmptyTableCount" datasource="#dsn#">
            SELECT (COUNT(T.TableName)-1) CNT FROM (
            SELECT SCHEMA_NAME(schema_id) AS [SchemaName],
            [Tables].name AS [TableName],
            SUM([Partitions].[rows]) AS [TotalRowCount]
            FROM sys.tables AS [Tables]
            JOIN sys.partitions AS [Partitions]
            ON [Tables].[object_id] = [Partitions].[object_id]
            WHERE SCHEMA_NAME(schema_id) IN(
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn#'>,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn1#'>,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn2#'>,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn3#'>
			)
            AND [Partitions].index_id IN ( 0, 1 )
            GROUP BY SCHEMA_NAME(schema_id), [Tables].name
            HAVING SUM([Partitions].[rows])<=0) T
        </cfquery>  

        <cfquery name="getClassificationCount" datasource="#dsn#">
            SELECT COUNT(*) AS CNT FROM AI_CLASS
        </cfquery>

        <cfquery name="getClassificationColumnCount" datasource="#dsn#">
            SELECT COUNT(*) AS CNT FROM AI_CLASS_DATA
        </cfquery>

        <cfquery name="getEmptyColumnCount" datasource="#dsn#">
            SELECT COUNT(*) AS CNT FROM EMPTY_COLUMN 
            WHERE SCHEMA_NAME IN(
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn#'>,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn1#'>,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn2#'>,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#dsn3#'>
			)
        </cfquery>

        <cfset dashboardStruct.SchemaCount=getSchemaCount.CNT >
        <cfset dashboardStruct.TableCount=getTableCount.CNT >
        <cfset dashboardStruct.ViewCount=getViewCount.CNT >
        <cfset dashboardStruct.ColumnCount=getColumnCount.CNT >
        <cfset dashboardStruct.EmptyTableCount=getEmptyTableCount.CNT >
        <cfset dashboardStruct.ClassificationCount=getClassificationCount.CNT >
        <cfset dashboardStruct.ClassificationColumnCount=getClassificationColumnCount.CNT >
        <cfset dashboardStruct.EmptyColumnCount=getEmptyColumnCount.CNT >


        <cfreturn dashboardStruct>
    </cffunction>
    

    <cffunction name="GetGeneralDashboard" access="public" returntype="struct">
        <!---<cfargument name="" type="string">--->

        <cfset dashboardStruct=StructNew()>

        <cfquery name="getSchemaCount" datasource="#dsn#">
            SELECT COUNT(T.TABLE_SCHEMA) CNT FROM (
            SELECT TABLE_SCHEMA FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME<>'sysdiagrams'
            GROUP BY TABLE_SCHEMA) T
        </cfquery>

        <cfquery name="getTableCount" datasource="#dsn#">
            SELECT COUNT(*) as CNT FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME<>'sysdiagrams' 
        </cfquery>

        <cfquery name="getViewCount" datasource="#dsn#">
            SELECT COUNT(*) as CNT FROM INFORMATION_SCHEMA.VIEWS
        </cfquery>

        <cfquery name="getColumnCount" datasource="#dsn#">
            SELECT COUNT(*) AS CNT FROM INFORMATION_SCHEMA.COLUMNS
        </cfquery>       
        
        <cfquery name="getEmptyTableCount" datasource="#dsn#">
            SELECT (COUNT(T.TableName)-1) CNT FROM (
            SELECT SCHEMA_NAME(schema_id) AS [SchemaName],
            [Tables].name AS [TableName],
            SUM([Partitions].[rows]) AS [TotalRowCount]
            FROM sys.tables AS [Tables]
            JOIN sys.partitions AS [Partitions]
            ON [Tables].[object_id] = [Partitions].[object_id]
            AND [Partitions].index_id IN ( 0, 1 )
            GROUP BY SCHEMA_NAME(schema_id), [Tables].name
            HAVING SUM([Partitions].[rows])<=0) T
        </cfquery>  

        <cfquery name="getClassificationCount" datasource="#dsn#">
            SELECT COUNT(*) AS CNT FROM AI_CLASS
        </cfquery>

        <cfquery name="getClassificationColumnCount" datasource="#dsn#">
            SELECT COUNT(*) AS CNT FROM AI_CLASS_DATA
        </cfquery>

        <cfquery name="getEmptyColumnCount" datasource="#dsn#">
            SELECT COUNT(*) AS CNT FROM EMPTY_COLUMN 
        </cfquery>

        <cfset dashboardStruct.SchemaCount=getSchemaCount.CNT >
        <cfset dashboardStruct.TableCount=getTableCount.CNT >
        <cfset dashboardStruct.ViewCount=getViewCount.CNT >
        <cfset dashboardStruct.ColumnCount=getColumnCount.CNT >
        <cfset dashboardStruct.EmptyTableCount=getEmptyTableCount.CNT >
        <cfset dashboardStruct.ClassificationCount=getClassificationCount.CNT >
        <cfset dashboardStruct.ClassificationColumnCount=getClassificationColumnCount.CNT >
        <cfset dashboardStruct.EmptyColumnCount=getEmptyColumnCount.CNT >

        <cfreturn dashboardStruct>
    </cffunction>

    <!--- Data Script Export Log --->
    <cffunction name="ScriptExportLog" access="remote" returntype="any" returnformat="JSON" >
        <cfargument name="table" type="string" default="">
		<cfargument name="bestpractice_id" type="numeric" default="">
		<cfargument name="bestpractice" type="string" default="">
		<cfargument name="datatype" type="string" default="">
		<cfargument name="head" type="string" default="">
		<cfargument name="detail" type="string" default="">
        <cfargument name="create_date" type="date" default="">
		<cfargument name="author_id" type="numeric" default="">
        <cfargument name="type" type="string" required="false" default="export">
        <cfargument name="condition" type="string" default="">
        <cfargument name="off_identity" type="boolean" default="0">
        <cfargument name="remove_old_file" type="boolean" default="0">
        <cfargument name="remove_schema_name" type="boolean" default="0">
        <cfargument name="associate_config" type="string" default="">
        
        <cfset objResponse=StructNew()>
        <cftry>

            <cfset scriptGenerator = CreateObject("component","V16.settings.query.SqlScriptGenerator")>
            <cfset createScript=scriptGenerator.CreateScript(#table#)>
            <cfset insertScript=scriptGenerator.InsertScript(#table#,'#condition#',arguments.off_identity,arguments.remove_schema_name)>

            <cfquery name="query_log" datasource="#dsn#">
                INSERT INTO DATA_SCRIPT_EXPORT_LOG
                (
                    TABLE_NAME,
                    BEST_PRACTICE_ID,
                    BEST_PRACTICE_NAME,
                    TYPE,
                    HEAD,
                    DETAIL,
                    DATE,
                    AUTHOR_ID,
                    CREATE_SCRIPT,
                    INSERT_SCRIPT,
                    CREATE_DATE,
                    CREATE_USER_ID,
                    CREATE_USER_IP
                )
                VALUES
                (   <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.table#'>,       -- TABLE_NAME - nvarchar(50)
                    <cfqueryparam cfsqltype='cf_sql_integer' value='#arguments.bestpractice_id#'>,         -- BEST_PRACTICE_ID - int
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.bestpractice#'>,       -- BEST_PRACTICE_NAME - nvarchar(50)
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.datatype#'>,       -- TYPE - nvarchar(50)
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.head#'>,       -- HEAD - nvarchar(50)
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.detail#'>,       -- DETAIL - nvarchar(150)
                    <cfqueryparam cfsqltype='cf_sql_date' value='#arguments.create_date#'>, -- DATE - datetime
                    <cfqueryparam cfsqltype='cf_sql_integer' value='#arguments.author_id#'>,         -- AUTHOR_ID - int
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#createScript#'>,       -- CREATE_SCRIPT - nvarchar(max)
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#insertScript#'>,       -- INSERT_SCRIPT - nvarchar(max)
                    GETDATE(), -- CREATE_DATE - datetime
                    <cfif isDefined('session.ep')><cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer"><cfelseif isDefined('session.pp')><cfqueryparam value="#session.pp.userid#" cfsqltype="cf_sql_integer"><cfelse><cfqueryparam value="#session.pda.userid#" cfsqltype="cf_sql_integer"></cfif>,         -- CREATE_USER_ID - int
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#cgi.remote_addr#'>       -- CREATE_USER_IP - nvarchar(20)
                )
            </cfquery>

            <cfset DBLog("ScriptExport", serializeJSON(arguments))>

            <cfset objResponse.CREATESCRIPT=createScript>
            <cfset objResponse.INSERTSCRIPT=insertScript>
            <cfset objResponse.SUCCESS=true >

            <cfif arguments.type eq 'exportFolder'>

                <cfset schemaFounder =  CreateObject("component","WDO.helpers.schemaFounder")>
                <cfset getSchemaInfo = schemaFounder.getSchemaInfo( schemaName: listFirst( arguments.table, '.' ) ) />
                
                <cfquery name="query_bp" datasource="#dsn#">
                    SELECT * FROM WRK_BESTPRACTICE WHERE BESTPRACTICE_ID = <cfqueryparam cfsqltype='cf_sql_integer' value='#arguments.bestpractice_id#'>
                </cfquery>

                <cfif query_bp.recordcount and len(query_bp.BESTPRACTICE_FILE_PATH) and DirectoryExists('#download_folder#/#query_bp.BESTPRACTICE_FILE_PATH#/install/data_library')>

                    <cfif not DirectoryExists('#download_folder#/#query_bp.BESTPRACTICE_FILE_PATH#/install/data_library/#getSchemaInfo.type#')>
                        <cfset DirectoryCreate('#download_folder#/#query_bp.BESTPRACTICE_FILE_PATH#/install/data_library/#getSchemaInfo.type#') />
                    </cfif>

                    <cfif not DirectoryExists('#download_folder#/#query_bp.BESTPRACTICE_FILE_PATH#/install/data_library/#getSchemaInfo.type#/#arguments.datatype#')>
                        <cfset DirectoryCreate('#download_folder#/#query_bp.BESTPRACTICE_FILE_PATH#/install/data_library/#getSchemaInfo.type#/#arguments.datatype#') />
                    </cfif>

                    <cffile
                        action = "#arguments.remove_old_file ? 'write' : 'append'#"
                        file = "#download_folder#/#query_bp.BESTPRACTICE_FILE_PATH#/install/data_library/#getSchemaInfo.type#/#arguments.datatype#/#arguments.head#.txt"
                        output = "#objResponse.INSERTSCRIPT#"
                        addNewLine = "yes"
                        charset = "utf-8">
                    
                    <!--- config dosyası oluşturulur ya da varolan dosya üzerinde düzenleme yapılır. --->
                    <cfif len( arguments.associate_config )>
                        <cfif fileExists('#download_folder#/#query_bp.BESTPRACTICE_FILE_PATH#/config.json')>
                            <cffile action = "read" file = "#download_folder#/#query_bp.BESTPRACTICE_FILE_PATH#/config.json" variable = "fileConfig" charset = "utf-8" />
                            <cfif len( fileConfig )>
                                <cfset fileConfigStruct = deserializeJson( fileConfig ) />
                                <cfif StructKeyExists(fileConfigStruct, arguments.head)>
                                    <cfset fileConfigStruct[ arguments.head ]['associate_config'] = deserializeJson(arguments.associate_config) />
                                <cfelse>
                                    <cfset StructInsert(fileConfigStruct, arguments.head, { associate_config: deserializeJson(arguments.associate_config) }) />
                                </cfif>
                            </cfif>
                        <cfelse>
                            <cfset fileConfigStruct = StructNew() />
                            <cfset StructInsert(fileConfigStruct, arguments.head, { associate_config: deserializeJson(arguments.associate_config) }) />
                        </cfif>

                        <cffile
                            action = "write"
                            file = "#download_folder#/#query_bp.BESTPRACTICE_FILE_PATH#/config.json"
                            output = "#replace(serializeJson( fileConfigStruct ), '//', '', 'all')#"
                            addNewLine = "yes"
                            charset = "utf-8">
                    </cfif>

                    <cfset objResponse.SUCCESS=true >
                <cfelse>
                    <cfset objResponse.SUCCESS=false >
                </cfif>

            </cfif>

        <cfcatch type="exception">
            <cfset objResponse.SUCCESS=false >
        </cfcatch>
        </cftry>
        
        <cfreturn replace(serializeJSON(objResponse,"struct"),"//","") >

    </cffunction>

    <!--- Empty Column Insert --->
    <cffunction name="EmptyColumnInsert" access="remote" returntype="any">
        <cfquery name="InsertEmptyColumn" datasource="#dsn#">
        TRUNCATE TABLE EMPTY_COLUMN
        DECLARE @schemaName NVARCHAR(100), @tableName NVARCHAR(100), @columnName NVARCHAR(100)
        DECLARE @query NVARCHAR(MAX)

            DECLARE CRS_EMPTY_COLUMN CURSOR FOR
            
            SELECT TABLE_SCHEMA,TABLE_NAME,COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS

            OPEN CRS_EMPTY_COLUMN
        
            FETCH NEXT FROM CRS_EMPTY_COLUMN INTO @schemaName, @tableName,@columnName
        
            WHILE @@FETCH_STATUS =0
                BEGIN
                    
        SET @query='SELECT ''' + @schemaName + ''' AS SCHEMA_NAME,''' + @tableName + ''' AS TABLE_NAME, ''' + @columnName + ''' AS COLUMN_NAME, GETDATE() AS CREATE_DATE FROM ' + @schemaName + '.' + @tableName + ' ' + ' HAVING COUNT(' + @columnName + ') = 0 AND COUNT(*)>0'

        INSERT INTO EMPTY_COLUMN
        EXEC (@query)

                    FETCH NEXT FROM CRS_EMPTY_COLUMN INTO @schemaName, @tableName,@columnName
                END
            CLOSE CRS_EMPTY_COLUMN
        
            DEALLOCATE CRS_EMPTY_COLUMN
        </cfquery>
        <cfreturn '{ "SUCCESS" : true }'>
    </cffunction>

</cfcomponent>