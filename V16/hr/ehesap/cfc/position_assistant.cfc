
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2= "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cffunction name="GET_POSITION_ASSISTANT" access="remote" returntype="query">
        <cfargument name="position_id" default="">
        <cfquery name="GET_POSITION_ASSISTANT" datasource="#DSN#">
            SELECT * FROM POSITION_ASSISTANT_MODULES WHERE POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_id#">
        </cfquery>
        <cfreturn GET_POSITION_ASSISTANT>
    </cffunction>  
    <cffunction name="DEL_POSITION_ASSISTANT" access="remote" returntype="any">
        <cfargument name="position_assistant_modules_id" default="">
        <cfquery name="DEL_POSITION_ASSISTANT" datasource="#DSN#">
            DELETE FROM POSITION_ASSISTANT_MODULES WHERE POSITION_ASSISTANT_MODULES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_assistant_modules_id#">
        </cfquery>
        <script>
            location.href=document.referrer;
        </script>
    </cffunction>  
    <cffunction name="ADD_POSITION_ASSISTANT" access="remote" returnFormat="json" returntype="any">
        <cfargument name="record_num" default="">
        <cfargument name="position_assistant_modules_id" default="">
        <cfargument name="row_kontrol" default="">
        <cfargument name="id" default="">
        <cfargument name="position_id" default="">
        <cfargument name="position_assistant_code" default="">
        <cfargument name="position_assistant_id" default="">
        <cfargument name="position_assistant_module" default="">  
        <cfif len(arguments.record_num) and arguments.record_num neq ''>
            <cfquery name="GET_POSITION_ASSISTANT" datasource="#DSN#">
                SELECT * FROM POSITION_ASSISTANT_MODULES WHERE POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_id#">
            </cfquery>
            <cfif GET_POSITION_ASSISTANT.recordcount>
                <cfquery name="DEL_POSITION_ASSISTANT" datasource="#DSN#">
                    DELETE FROM POSITION_ASSISTANT_MODULES WHERE POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_id#">
                </cfquery>
            </cfif>
            <cfloop from="1" to="#arguments.record_num#" index="i">
                <cfif isdefined("arguments.row_kontrol#i#") and evaluate("arguments.row_kontrol#i#") eq 1>
                  
                    <cfquery name="ADD_POSITION_ASSISTANT" datasource="#DSN#">
                        INSERT INTO POSITION_ASSISTANT_MODULES
                        (
                        POSITION_ID
                        ,POSITION_ASSISTANT_CODE
                        ,POSITION_ASSISTANT_ID
                        ,POSITION_ASSISTANT_MODULES
                        )
                        VALUES
                        (<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.position_id")#">
                        ,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.position_assistant_code#i#")#">
                        ,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.position_assistant_id#i#")#">
                        ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("arguments.position_assistant_module#i#")#">
                        )    
                    </cfquery>
                </cfif>
            </cfloop>
        </cfif>
        <script type="text/javascript">
            history.back();
        </script>
    </cffunction>  
    <cffunction name="GET_MODULES" access="remote" returntype="query">
        <cfquery name="GET_MODULES" datasource="#DSN#">
            SELECT 
                MODULE_ID,
                MODULE_NAME,
                MODULE_NAME_TR,
                MODULE_SHORT_NAME,
                FOLDER,
                MODUL_NO,
                MODULE_TYPE,
                #dsn#.Get_Dynamic_Language(MODULE_ID,'#session.ep.language#','MODULES','MODULE',NULL,NULL,MODULE) AS MODULE,
                SOLUTION,
                FAMILY,
                MODULE_DICTIONARY_ID,
                SOLUTION_DICTIONARY_ID,
                FAMILY_DICTIONARY_ID,
                FAMILY_ID,
                IS_MENU
            FROM 
                MODULES 
            ORDER BY 
                MODULE ASC
        </cfquery>
        <cfreturn GET_MODULES>
    </cffunction>  
    <cffunction name="get_modules_no" access="remote" returntype="query">
        <cfargument name="fuseaction" default="">
        <cfquery name="get_modules_no" datasource="#dsn#">
            SELECT MODULE_NO FROM WRK_OBJECTS WHERE FULL_FUSEACTION LIKE '%#listgetat(arguments.fuseaction,1,'.')#%'
        </cfquery>
        <cfreturn get_modules_no>
    </cffunction> 
</cfcomponent> 