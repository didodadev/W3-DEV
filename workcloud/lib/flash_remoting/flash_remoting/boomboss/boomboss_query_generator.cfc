<cfcomponent output="no">
	<cfset MODULE_NAME = "queryGenerator">

    <!--- Test --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "BoomBoss - Query Generator component is accessible.">
	</cffunction>
    
    <!--- Load Query --->
    <cffunction name="loadQuery" access="remote" returntype="any" output="no">
        <cfargument name="query_id" type="any" required="yes">
        
        <cfset result = StructNew()>
        
        <cftry>
        	<cfquery name="query_info" datasource="#session.databaseName#">
            	SELECT
                	REPORT_QUERY_NAME 			AS name,
                    REPORT_QUERY_DETAIL			AS description,
                    LIST_VIEW					AS listView,
                    GRAPHIC_TYPE				AS graphicType,
                    MAX_ROWS					AS maxRows,
                    REPORT_QUERY				AS queryCode,
                    GRAPH_VALUE_QUERY_COLUMN_ID	AS valueColumnID,
                    GRAPH_LABEL_QUERY_COLUMN_ID	AS labelColumnID
				FROM
                	REPORT_QUERY
				WHERE
                	REPORT_QUERY_ID = #arguments.query_id#
            </cfquery>
            
           	<cfquery name="query_columns" datasource="#session.databaseName#">
            	SELECT
                	REPORT_QUERY_COLUMN_ID		AS id,
                	COLUMN_TYPE					AS columnType,
                    COLUMN_NAME					AS fieldColumnName,
                    SOURCE_DB_TABLE				AS fieldData,
                    COLUMN_FORMAT				AS fieldFormat,
                    COLUMN_FUNCTION				AS fieldFunction,
                    COLUMN_PRIORITY				AS fieldPriority,
                    COLUMN_DESCRIPTION			AS fieldDescription,
                    CONDITION_OPEN_PARANTHESIS	AS openParanthesis,
                    CONDITION_DB_TABLE			AS conditionDataSrc,
                    CONDITION_TYPE				AS conditionType,
                    CONDITION_FORMAT			AS conditionFormat,
                    CONDITION_VALUE				AS conditionValue,
                    CONDITION_CLOSE_PARANTHESIS	AS closeParanthesis,
                    OR_AND_VALUE				AS operator
				FROM
                	REPORT_QUERY_COLUMNS
				WHERE
                	REPORT_QUERY_ID = #arguments.query_id#
				ORDER BY
                	fieldPriority
            </cfquery>
            
            <cfset result["queryInfo"] = query_info>
            <cfset result["queryColumns"] = query_columns>
        
            <cfcatch type="any">
            	<cfset cfcatchLine = cfcatch.tagcontext[1].raw_trace>
                <cfset cfcatchLine = right(cfcatchLine, len(listlast(cfcatchLine, ':')))>
                <cfset cfcatchLine = left(cfcatchLine, len(cfcatchLine) - 1)>
                <cfset result["error"] = "#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nLine: #cfcatchLine#">
                <cfreturn result>
            </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>
    
    <!--- Save Query --->
    <cffunction name="saveQuery" access="remote" returntype="any" output="no">
        <cfargument name="query_name" type="string" required="yes">
        <cfargument name="query_description" type="string" required="yes">
        <cfargument name="column_delete_list" type="array" required="yes">
        <cfargument name="field_list" type="array" required="yes">
        <cfargument name="condition_list" type="array" required="yes">
        <cfargument name="query_code" type="string" required="yes">
        <cfargument name="list_view" type="numeric" required="no" default="0">
        <cfargument name="graphic_type" type="numeric" required="no" default="-1">
        <cfargument name="graphic_label_column_index" type="numeric" required="no" default="-1">
        <cfargument name="graphic_value_column_index" type="numeric" required="no" default="-1">
        <cfargument name="max_rows" type="numeric" required="no" default="0">
        <cfargument name="query_id" type="any" required="no">
        
        <cftransaction>
			<cfset result = StructNew()>
            
            <cftry>
            	<!-- Fix quotes -->
            	<cfset arguments.query_code = replaceNoCase(trim(arguments.query_code), "'", "''", "ALL")>
                <cfif isDefined('arguments.query_id') and len(arguments.query_id)>
                	<!-- Update query -->
                    <cfquery name="update_query" datasource="#session.databaseName#">
                    	UPDATE
                        	REPORT_QUERY
						SET
                        	REPORT_QUERY_NAME = '#arguments.query_name#',
                            REPORT_QUERY_DETAIL = '#arguments.query_description#',
                            REPORT_QUERY = '#arguments.query_code#',
                            LIST_VIEW = #arguments.list_view#,
                            GRAPHIC_TYPE = #arguments.graphic_type#,
                            MAX_ROWS = #arguments.max_rows#,
                            UPDATE_EMP = #session.userID#,
                            UPDATE_DATE = #now()#,
                            UPDATE_IP = '#cgi.REMOTE_ADDR#'
						WHERE
                        	REPORT_QUERY_ID = #arguments.query_id#
                    </cfquery>
                <cfelse>
                	<!-- Save query -->
                    <cfquery name="insert_query" datasource="#session.databaseName#" result="queryResult">
                        INSERT INTO
                            REPORT_QUERY
                            (
                                REPORT_QUERY_NAME,
                                REPORT_QUERY_DETAIL,
                                REPORT_QUERY,
                                LIST_VIEW,
                                GRAPHIC_TYPE,
                                MAX_ROWS,
                                RECORD_EMP,
                                RECORD_DATE,
                                RECORD_IP
                            )
                            VALUES
                            (
                                '#arguments.query_name#',
                                '#arguments.query_description#',
                                '#arguments.query_code#',
                                #arguments.list_view#,
                                #arguments.graphic_type#,
                                #arguments.max_rows#,
                                #session.userID#,
                                #now()#,
                                '#cgi.REMOTE_ADDR#'
                            )
                    </cfquery>
                    <!-- Get saved query id and assign it as query_id -->
                    <cfset arguments.query_id = queryResult.identityCol>
                </cfif>
                
                <!-- Clear deleted columns from database -->
                <cfloop from="1" to="#ArrayLen(arguments.column_delete_list)#" index="i">
                	<cfquery name="delete_column" datasource="#session.databaseName#">
	                    DELETE FROM REPORT_QUERY_COLUMNS WHERE REPORT_QUERY_COLUMN_ID = #arguments.column_delete_list[i]#
                    </cfquery>
                </cfloop>
                
                <!-- Insert/Update fields -->
                <cfloop from="1" to="#ArrayLen(arguments.field_list)#" index="i">
                    <cfset field_item = arguments.field_list[i]>
                    <cfif isDefined('field_item.id') and len(field_item.id)>
                        <cfquery name="update_query_column" datasource="#session.databaseName#">
                            UPDATE
                                REPORT_QUERY_COLUMNS
                            SET
                                COLUMN_TYPE = 0,
                                COLUMN_PRIORITY = #field_item.priority#,
                                COLUMN_NAME = '#field_item.columnName#',
                                SOURCE_DB_TABLE = '#field_item.dataField#',
                                COLUMN_FORMAT = #field_item.format#,
                                COLUMN_FUNCTION = #field_item.func#,
                                COLUMN_DESCRIPTION = '#field_item.description#'
                            WHERE
                                REPORT_QUERY_COLUMN_ID = #field_item.id#
                        </cfquery>
                    <cfelse>
                        <cfquery name="insert_query_column" datasource="#session.databaseName#" result="queryResult">
                        	INSERT INTO
                            	REPORT_QUERY_COLUMNS
                                (
                                	REPORT_QUERY_ID,
                                	COLUMN_TYPE,
                                    COLUMN_PRIORITY,
                                    COLUMN_NAME,
                                    SOURCE_DB_TABLE,
                                    COLUMN_FORMAT,
                                    COLUMN_FUNCTION,
                                    COLUMN_DESCRIPTION
                                )
                                VALUES
                                (
                                	#arguments.query_id#,
                                	0,
                                    #field_item.priority#,
                                    '#field_item.columnName#',
                                    '#field_item.dataField#',
                                    #field_item.format#,
                                    #field_item.func#,
                                    '#field_item.description#'
                                )
                        </cfquery>
                        <!-- Get saved field id and assign it to the list -->
                        <cfset field_item["id"] = queryResult.identityCol>
                        <cfset arguments.field_list[i]["id"] = queryResult.identityCol>
                    </cfif>
                    
                    <!-- Update query graph label column and value column if indices are matching -->
                    <cfif i eq arguments.graphic_label_column_index>
                        <cfquery name="update_query_graph_column" datasource="#session.databaseName#">
                            UPDATE REPORT_QUERY SET GRAPH_LABEL_QUERY_COLUMN_ID = #field_item.id# WHERE REPORT_QUERY_ID = #arguments.query_id#
                        </cfquery>
					<cfelseif i eq arguments.graphic_value_column_index>
                    	<cfquery name="update_query_graph_column" datasource="#session.databaseName#">
                            UPDATE REPORT_QUERY SET GRAPH_VALUE_QUERY_COLUMN_ID = #field_item.id# WHERE REPORT_QUERY_ID = #arguments.query_id#
                        </cfquery>
                    </cfif>
                </cfloop>
                
                <!-- Insert/Update conditions -->
                <cfloop from="1" to="#ArrayLen(arguments.condition_list)#" index="i">
                    <cfset condition_item = arguments.condition_list[i]>
                    <cfif isDefined('condition_item.id') and len(condition_item.id)>
                        <cfquery name="update_query_column" datasource="#session.databaseName#">
                            UPDATE
                                REPORT_QUERY_COLUMNS
                            SET
                                COLUMN_TYPE = 1,
                                CONDITION_OPEN_PARANTHESIS = #condition_item.openParanthesis#,
                                CONDITION_DB_TABLE = '#condition_item.dataFieldSrc#',
                                CONDITION_TYPE = #condition_item.condition#,
                                CONDITION_FORMAT = #condition_item.format#,
                                CONDITION_VALUE = '#condition_item.dataFieldValue#',
                                CONDITION_CLOSE_PARANTHESIS = #condition_item.closeParanthesis#,
                                OR_AND_VALUE = '#condition_item.operator#'
                            WHERE
                                REPORT_QUERY_COLUMN_ID = #condition_item.id#
                        </cfquery>
                    <cfelse>
                        <cfquery name="insert_query_column" datasource="#session.databaseName#" result="queryResult">
                        	INSERT
                            	REPORT_QUERY_COLUMNS
                                (
                                	REPORT_QUERY_ID,
                                	COLUMN_TYPE,
                                    CONDITION_OPEN_PARANTHESIS,
                                    CONDITION_DB_TABLE,
                                    CONDITION_TYPE,
                                    CONDITION_FORMAT,
                                    CONDITION_VALUE,
                                    CONDITION_CLOSE_PARANTHESIS,
                                    OR_AND_VALUE
                                )
                                VALUES
                                (
                                	#arguments.query_id#,
                                	1,
                                    #condition_item.openParanthesis#,
                                    '#condition_item.dataFieldSrc#',
                                    #condition_item.condition#,
                                    #condition_item.format#,
                                    '#condition_item.dataFieldValue#',
                                    #condition_item.closeParanthesis#,
                                    '#condition_item.operator#'
                                )
                        </cfquery>
                        <!-- Get saved condition id and assign it to the list -->
                        <cfset condition_item["id"] = queryResult.identityCol>
                        <cfset arguments.condition_list[i]["id"] = queryResult.identityCol>
                    </cfif>
                </cfloop>
                
                <cfset result["queryID"] = arguments.query_id>
                <cfset result["savedFields"] = arguments.field_list>
                <cfset result["savedConditions"] = arguments.condition_list>
                
                <cfcatch type="any">
					<cfset cfcatchLine = cfcatch.tagcontext[1].raw_trace>
                    <cfset cfcatchLine = right(cfcatchLine, len(listlast(cfcatchLine, ':')))>
                    <cfset cfcatchLine = left(cfcatchLine, len(cfcatchLine) - 1)>
                    <cfset result["error"] = "#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nLine: #cfcatchLine#">
                    <cfreturn result>
                </cfcatch>
            </cftry>
        </cftransaction>
        
        <cfreturn result>
    </cffunction>
    
    <!--- Clone Query --->
    <cffunction name="cloneQuery" access="remote" returntype="any" output="no">
    	<cfargument name="query_id" type="any" required="yes" default="">
        <cfargument name="clone_word" type="string" required="yes">
        
        <cftransaction>
			<cfset result = StructNew()>
            
            <cftry>
                <cfquery name="get_query" datasource="#session.databaseName#">
                	SELECT * FROM REPORT_QUERY WHERE REPORT_QUERY_ID = #arguments.query_id#
                </cfquery>
                <cfquery name="get_query_rows" datasource="#session.databaseName#">
                	SELECT * FROM REPORT_QUERY_COLUMNS WHERE REPORT_QUERY_ID = #arguments.query_id#
                </cfquery>
                
                <cfset recordDate = now()>
                <cfset queryTitle = "#get_query.REPORT_QUERY_NAME# (#arguments.clone_word#)">
                <cfset queryGraphLabelColumnID = "">
                <cfset queryGraphValueColumnID = "">
                
                <cfquery name="insert_query" datasource="#session.databaseName#" result="queryResult">
                	INSERT INTO
                   		REPORT_QUERY
                        (
							REPORT_QUERY_NAME,
                            REPORT_QUERY_DETAIL,
                            LIST_VIEW,
                            GRAPHIC_TYPE,
                            MAX_ROWS,
                            REPORT_QUERY,
                            REPORT_QUERY_VIEW,
                            REPORT_QUERY_TABLE,
                            GRAPH_LABEL_QUERY_COLUMN_ID,
                            GRAPH_VALUE_QUERY_COLUMN_ID,
                            RECORD_EMP,
                            RECORD_DATE,
                            RECORD_IP
                        )
                        VALUES
                        (
                        	'#queryTitle#',
                            '#get_query.REPORT_QUERY_DETAIL#',
                            '#get_query.LIST_VIEW#',
                            '#get_query.GRAPHIC_TYPE#',
                            '#get_query.MAX_ROWS#',
                            '#get_query.REPORT_QUERY#',
                            '#get_query.REPORT_QUERY_VIEW#',
                            '#get_query.REPORT_QUERY_TABLE#',
                            '#get_query.GRAPH_LABEL_QUERY_COLUMN_ID#',
                            '#get_query.GRAPH_VALUE_QUERY_COLUMN_ID#',
                            #session.userID#,
                            #now()#,
                            '#cgi.REMOTE_ADDR#'
                        )
                </cfquery>
                
                <cfloop query="get_query_rows">                
                    <cfquery name="insert_query_row" datasource="#session.databaseName#" result="queryRowResult">
                        INSERT INTO
                            REPORT_QUERY_COLUMNS
                            (
                                REPORT_QUERY_ID,
                                COLUMN_TYPE,
                                COLUMN_NAME,
                                SOURCE_DB_TABLE,
                                COLUMN_FORMAT,
                                COLUMN_FUNCTION,
                                COLUMN_PRIORITY,
                                COLUMN_DESCRIPTION,
                                CONDITION_OPEN_PARANTHESIS,
                                CONDITION_DB_TABLE,
                                CONDITION_TYPE,
                                CONDITION_FORMAT,
                                CONDITION_VALUE,
                                CONDITION_CLOSE_PARANTHESIS,
                                OR_AND_VALUE
                            )
                            VALUES
                            (
                                '#queryResult.identityCol#',
                                '#get_query_rows.COLUMN_TYPE#',
                                '#get_query_rows.COLUMN_NAME#',
                                '#get_query_rows.SOURCE_DB_TABLE#',
                                '#get_query_rows.COLUMN_FORMAT#',
                                '#get_query_rows.COLUMN_FUNCTION#',
                                '#get_query_rows.COLUMN_PRIORITY#',
                                '#get_query_rows.COLUMN_DESCRIPTION#',
                                '#get_query_rows.CONDITION_OPEN_PARANTHESIS#',
                                '#get_query_rows.CONDITION_DB_TABLE#',
                                '#get_query_rows.CONDITION_TYPE#',
                                '#get_query_rows.CONDITION_FORMAT#',
                                '#get_query_rows.CONDITION_VALUE#',
                                '#get_query_rows.CONDITION_CLOSE_PARANTHESIS#',
                                '#get_query_rows.OR_AND_VALUE#'
                            )
                    </cfquery>
                    
                    <cfif get_query.GRAPH_LABEL_QUERY_COLUMN_ID eq get_query_rows.REPORT_QUERY_COLUMN_ID><cfset queryGraphLabelColumnID = queryRowResult.identityCol></cfif>
                    <cfif get_query.GRAPH_VALUE_QUERY_COLUMN_ID eq get_query_rows.REPORT_QUERY_COLUMN_ID><cfset queryGraphValueColumnID = queryRowResult.identityCol></cfif>
                </cfloop>
                
                <!-- Update new query -->
                <cfif not len(queryGraphLabelColumnID)><cfset queryGraphLabelColumnID = "NULL"></cfif>
                <cfif not len(queryGraphValueColumnID)><cfset queryGraphValueColumnID = "NULL"></cfif>
                <cfquery name="update_new_query" datasource="#session.databaseName#">
                	UPDATE REPORT_QUERY SET GRAPH_LABEL_QUERY_COLUMN_ID = #queryGraphLabelColumnID#, GRAPH_VALUE_QUERY_COLUMN_ID = #queryGraphValueColumnID# WHERE REPORT_QUERY_ID = #queryResult.identityCol#
                </cfquery>
                
                <cfset result["queryID"] = queryResult.identityCol>
                
                <cfcatch type="any">
					<cfset cfcatchLine = cfcatch.tagcontext[1].raw_trace>
                    <cfset cfcatchLine = right(cfcatchLine, len(listlast(cfcatchLine, ':')))>
                    <cfset cfcatchLine = left(cfcatchLine, len(cfcatchLine) - 1)>
                    <cfset result["error"] = "#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nLine: #cfcatchLine#">
                    <cfreturn result>
                </cfcatch>
            </cftry>
        </cftransaction>
        
        <cfreturn result>
   	</cffunction>
    
    <!--- Delete Query --->
    <cffunction name="deleteQuery" access="remote" returntype="any" output="no">
        <cfargument name="query_id" type="numeric" required="yes">
        <cfargument name="detail" type="any" required="no" default="">
        
        <cfset result = StructNew()>
        
        <cfquery name="delete_query_columns" datasource="#session.databaseName#">
        	DELETE FROM REPORT_QUERY_COLUMNS WHERE REPORT_QUERY_ID = #arguments.query_id#
        </cfquery>
        
        <cfquery name="delete_query" datasource="#session.databaseName#">
        	DELETE FROM REPORT_QUERY WHERE REPORT_QUERY_ID = #arguments.query_id#
        </cfquery>
        
        <cfquery name="delete_query_permissions" datasource="#session.databaseName#">
        	DELETE FROM REPORT_PERMISSIONS WHERE QUERY_ID = #arguments.query_id#
        </cfquery>
        
        <cfreturn result>
    </cffunction>
    
    <!--- CROSS FUNCTIONS --->
        
    <!--- Get Databases --->
    <cffunction name="getDatabases" access="remote" returntype="any" output="no">
    	<cfargument name="filter" type="string" required="no" default="">
    	
        <cfset result = StructNew()>
        
        <cfreturn CreateObject("component", "core.database").getDatabases(filter: arguments.filter)>
    </cffunction>
    
    <!--- Get Tables --->
    <cffunction name="getTables" access="remote" returntype="any" output="no">
    	<cfargument name="db_name" type="string" required="no" default="#session.databaseName#">
        
        <cfset result = StructNew()>
        
        <cfreturn CreateObject("component", "core.database").getTables(db_name: arguments.db_name)>
    </cffunction>
    
    <!--- Get Fields --->
    <cffunction name="getFields" access="remote" returntype="any" output="no">
    	<cfargument name="db_name" type="string" required="no" default="#session.databaseName#">
        <cfargument name="table_name" type="string" required="yes">
        <cfargument name="only_identity_fields" type="boolean" required="no" default="0">
        
        <cfset result = StructNew()>
        
        <cfreturn CreateObject("component", "core.database").getFields(db_name: arguments.db_name, table_name: arguments.table_name, only_identity_fields: arguments.only_identity_fields)>
    </cffunction>
</cfcomponent>