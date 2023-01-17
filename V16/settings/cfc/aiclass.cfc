<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="list_aiclass" access="remote" returntype="query">
        <cfquery name="list_aiclass" datasource="#dsn#">        
            SELECT 
            	AI_CLASS_ID , AI_CLASS , AI_CLASS_DETAIL
            FROM
                AI_CLASS
        </cfquery>
        <cfreturn list_aiclass>
    </cffunction> 
    <cffunction name="aiclass_add_new" access="remote" returntype="any" returnFormat="json">
        <cfargument  name="AI_CLASS" default="">
        <cfargument  name="AI_CLASS_DETAIL" default="">
    	<cfif len(arguments.AI_CLASS) and len(arguments.AI_CLASS_DETAIL)>
        	<cfquery name="GET_CLASSNEW" datasource="#dsn#" result="query_result">	
                INSERT INTO 
                AI_CLASS (AI_CLASS, AI_CLASS_DETAIL ) 
                VALUES
                	(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.AI_CLASS#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.AI_CLASS_DETAIL#">)
            </cfquery>
        	<cfset returnData = #query_result.identitycol#> 
        <cfelse>
        	<cfset returnData =0>           
        </cfif>
        <cfreturn Replace(SerializeJSON(returnData),'//','')>
    </cffunction>
    <cffunction name="aiclass_delete" access="remote" returntype="any" returnFormat="json">
    	<cfif len(arguments.primary)>
        	<cfquery name="GET_SITESUPDATE" datasource="#dsn#">	
                DELETE FROM AI_CLASS WHERE AI_CLASS_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.primary#">
            </cfquery>
        	<cfset returnData = 1> 
        <cfelse>
        	<cfset returnData =0>           
        </cfif>
        <cfreturn Replace(SerializeJSON(returnData),'//','')>
    </cffunction>
    <cffunction name="aiclass_update" access="remote" returntype="any" returnFormat="json">
        <cfargument  name="AI_CLASS" default="">
        <cfargument  name="AI_CLASS_DETAIL" default="">
    	<cfif len(arguments.primary)>
        	<cfquery name="GET_PAGESUPDATE" datasource="#dsn#">        	
                UPDATE
                    AI_CLASS
                SET
                    AI_CLASS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.AI_CLASS#">,
                    AI_CLASS_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.AI_CLASS_DETAIL#">                              
                WHERE 
                AI_CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.primary#">
                 
            </cfquery>
        	<cfset returnData =1> 
        <cfelse>
        	<cfset returnData =0>           
        </cfif>
        <cfreturn Replace(SerializeJSON(returnData),'//','')>
    </cffunction>
    <cffunction  name="add_ai_class" access="public">
        <cfquery name="delete_ai_class" datasource="#dsn#">
            DELETE FROM AI_CLASS_DATA WHERE SCHEMA_NAME= <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#schema_name#"> AND TABLE_NAME=<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#table_name#"> AND COLUMN_NAME=<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#column_name#">
        </cfquery>
        <cfloop from="1" to="#listlen(arguments.CLASS_NAME)#" index="i">
            <cfset class_id = listgetat(listgetat(arguments.CLASS_NAME,i,','),'1','@')>
           <!---  <cfset class_names = listgetat(listgetat(arguments.CLASS_NAME,i,','),'2','@')> --->
     
        <cfquery name="add_ai_class" datasource="#dsn#">
            INSERT INTO AI_CLASS_DATA
            (
                SCHEMA_NAME,
                TABLE_NAME,
                COLUMN_NAME,
                AI_CLASS_ID,
                AI_CLASS
            ) 
            SELECT  
            
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#schema_name#">,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#table_name#">,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#column_name#">,
                
                AI_CLASS_ID, AI_CLASS FROM AI_CLASS WHERE AI_CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#">
    </cfquery> 
    </cfloop> 
    </cffunction>
    <cffunction name="add_ai_Selected" access="public">
        <cfquery name="add_ai_selected" datasource="#dsn#">
            SELECT AI_CLASS_ID FROM AI_CLASS_DATA WHERE SCHEMA_NAME= <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#schema_name#"> and TABLE_NAME=<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#table_name#"> and COLUMN_NAME=<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#column_name#">
        </cfquery>
        <cfreturn add_ai_selected>
    </cffunction>
    <cffunction  name="GetAiClass" access="public">

        <cfquery name="get_ai_class" datasource="#dsn#" dbtype="any">
            SELECT AI_CLASS,AI_CLASS_ID FROM AI_CLASS
        </cfquery> 
        <cfreturn get_ai_class>
    </cffunction>
    
    
    
</cfcomponent> 