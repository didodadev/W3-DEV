<cfcomponent>
    <cfheader name="Access-Control-Allow-Origin" value="*" />
    <cfheader name="Access-Control-Allow-Methods" value="GET,POST" />
    <cfheader name="Access-Control-Allow-Headers" value="Content-Type" />
    <cfset dsn = application.systemParam.systemParam().dsn>
     <cffunction name="GET_USER_MENUS" access="remote" returntype="string" returnFormat="json">
        <cfquery name="GET_USER_MENUS" datasource="#dsn#">        	
                SELECT
                    WRK_MENU_ID,
                    WRK_MENU_NAME,
                    MENU_JSON
                FROM
                    WRK_MENU
                WHERE
                    WRK_MENU_ID = #session.ep.menu_id#
        </cfquery>
        <cfreturn Replace(serializeJSON(GET_USER_MENUS),'//','')>
    </cffunction>
 
    <cffunction name="GET_MENUS" access="remote" returntype="string" returnFormat="json">
        <cfquery name="GET_MENUS" datasource="#dsn#">        	
                SELECT
                    WRK_MENU_ID,
                    WRK_MENU_NAME,
                    RECORD_DATE,
                    AUTHOR	
                FROM
                    WRK_MENU
        </cfquery>
        <cfreturn Replace(serializeJSON(GET_MENUS),'//','')>
    </cffunction>
    <cffunction name="GET_MENU" access="remote" returntype="string" returnFormat="json">
        <cfquery name="GET_MENU" datasource="#dsn#">        	
                SELECT
                    WRK_MENU_ID,
                    WRK_MENU_NAME,
                    MENU_JSON,
                    MENU_STATUS,
                    BEST_PRACTISE,
                    AUTHOR,
                    RECORD_DATE,
                    UPDATE_DATE
                FROM
                    WRK_MENU
                WHERE
                    WRK_MENU_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.MID#"> 
        </cfquery>
        <cfreturn Replace(serializeJSON(GET_MENU),'//','')>
    </cffunction>

    <cffunction name="GET_SOLUTIONS" access="remote" returntype="string" returnFormat="json">
        <cfquery name="GET_SOLUTIONS" datasource="#dsn#">        	
            SELECT
                WRK_SOLUTION_ID,
                SOLUTION,
                SOLUTION_DICTIONARY_ID
            FROM
                WRK_SOLUTION
            WHERE
                IS_MENU=1   
        </cfquery>
        <cfreturn Replace(serializeJSON(GET_SOLUTIONS),'//','')>
    </cffunction>
    <cffunction name="GET_FAMILYS" access="remote" returntype="string" returnFormat="json">
        <cfquery name="GET_FAMILYS" datasource="#dsn#">        	
            SELECT
                WRK_FAMILY_ID,
                FAMILY,
                FAMILY_DICTIONARY_ID,
                WRK_SOLUTION_ID
            FROM
                WRK_FAMILY
            WHERE
                IS_MENU = 1
                AND WRK_SOLUTION_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.solution#">
        </cfquery>
        <cfreturn Replace(serializeJSON(GET_FAMILYS),'//','')>
    </cffunction>
    <cffunction name="GET_MODULES" access="remote" returntype="string" returnFormat="json">
        <cfquery name="GET_MODULES" datasource="#dsn#">        	
                SELECT
                    MODULE_NO,
                    MODULE,
                    MODULE_DICTIONARY_ID,
                    FAMILY_ID
                FROM
                    WRK_MODULE
                WHERE
                    IS_MENU=1
                AND FAMILY_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.family#">
        </cfquery>
        <cfreturn Replace(serializeJSON(GET_MODULES),'//','')>
    </cffunction>
    <cffunction name="GET_OBJECTS" access="remote" returntype="string" returnFormat="json">
        <cfquery name="GET_OBJECTS" datasource="#dsn#">        	
                SELECT
                    WRK_OBJECTS_ID,
                    HEAD,
                    DICTIONARY_ID,
                    MODULE_NO,
                    FULL_FUSEACTION,
                    DETAIL
                FROM
                    WRK_OBJECTS
                WHERE
                    IS_ACTIVE = 1
                    AND IS_MENU = 1
                    AND MODULE_NO = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.module#">
        </cfquery>
        <cfreturn Replace(serializeJSON(GET_OBJECTS),'//','')>
    </cffunction>
    <cffunction name="GET_BESTPACTICE" access="remote" returntype="string" returnFormat="json">
        <cfquery name="GET_BESTPACTICE" datasource="#dsn#">        	
                SELECT
                    BESTPRACTICE_ID,BESTPRACTICE_NAME
                FROM
                    WRK_BESTPRACTICE
        </cfquery>
        <cfreturn Replace(serializeJSON(GET_BESTPACTICE),'//','')>
    </cffunction>
    <cffunction name="GET_USERGROUP" access="remote" returntype="string" returnFormat="json">
        <cfquery name="GET_USERGROUP" datasource="#dsn#">        	
                SELECT
                    USER_GROUP_ID,USER_GROUP_NAME
                FROM
                    USER_GROUP
        </cfquery>
        <cfreturn Replace(serializeJSON(GET_USERGROUP),'//','')>
    </cffunction>
    <cffunction name="SET_MENU" access="remote" returntype="any" returnFormat="json">
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>  
    	<cfif len(arguments['name'])>
        	<cfquery name="SET_MENU" datasource="#dsn#" result="query_result">	
                INSERT INTO
                    WRK_MENU  (WRK_MENU_NAME, AUTHOR, MENU_JSON, MENU_STATUS, BEST_PRACTISE, RECORD_DATE)
                VALUES
                	(
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.menuAuthor#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.menuJson#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bestPractise[1]#">,                        
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    )
            </cfquery>
        	<cfset returnData = #query_result.identitycol#> 
        <cfelse>
        	<cfset returnData = 0 >           
        </cfif>
        <cfreturn Replace(SerializeJSON(returnData),'//','')>
    </cffunction> 
    <cffunction name="UPD_MENU" access="remote" returntype="any" returnFormat="json">
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>
    	<cfif len(arguments['name']) AND len(arguments['id'])>
        	<cfquery name="UPD_MENU" datasource="#dsn#">
                UPDATE
                    WRK_MENU
                SET
                    WRK_MENU_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">,
                    AUTHOR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.menuAuthor#">,
                    MENU_JSON = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.menuJson#">,
                    MENU_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status#">,
                    BEST_PRACTISE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bestPractise[1]#">,
                    UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                WHERE
                    WRK_MENU_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">               
            </cfquery>
        	<cfset returnData = 500> 
        <cfelse>
        	<cfset returnData = 0 >           
        </cfif>
        <cfreturn Replace(SerializeJSON(returnData),'//','')>
    </cffunction>
    <cffunction name="DEL_MENU" access="remote" returntype="string" returnFormat="json">
        <cfif len(arguments['MENU_ID'])>
            <cfquery name="DEL_MENU" datasource="#dsn#">        	
                    DELETE FROM WRK_MENU WHERE WRK_MENU_ID = #arguments['MENU_ID']#
            </cfquery>
            <cfset returnData = 500> 
        <cfelse>
        	<cfset returnData = 0 >           
        </cfif>
        <cfreturn Replace(serializeJSON(returnData),'//','')>
    </cffunction>
    <cffunction name="GET_LANG" access="remote" returntype="string" returnFormat="plain">       
        <cfif len(arguments.dictionary_id)>
            <cfquery name="LANG" datasource="#dsn#">        	
                SELECT 
                    ITEM_#session.ep.language# AS ITEM
                FROM
                    SETUP_LANGUAGE_TR
                WHERE
                    DICTIONARY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.dictionary_id#">
            </cfquery>
            <cfset returnData = LANG.ITEM> 
        <cfelse>
        	<cfset returnData = 0 >           
        </cfif>
        <cfreturn returnData>
    </cffunction>

</cfcomponent>