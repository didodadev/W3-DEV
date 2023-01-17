<!---
    File: V16\settings\cfc\language_allowance.cfc
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-05-27
    Description: Yabancı Dil Tazminatı Gösterge Rakamı
        
    History:
        
    To Do:

--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="GET_SETUP_LANGUAGE_ALLOWANCE" access="public" returntype="any">
        <cfargument  name="language_allowance_id">
        <cfquery name="GET_SETUP_LANGUAGE_ALLOWANCE" datasource="#DSN#">
            SELECT
                #dsn#.Get_Dynamic_Language(LANGUAGE_ALLOWANCE_ID,'#session.ep.language#','SETUP_LANGUAGE_ALLOWANCE','LANGUAGE_LEVEL',NULL,NULL,LANGUAGE_LEVEL) AS LANGUAGE_LEVEL,
                LANGUAGE_ALLOWANCE_ID,
                LANGUANGE_STATUE,
                LANGUAGE_AMOUNT
            FROM
                SETUP_LANGUAGE_ALLOWANCE
            WHERE
                1 = 1
                <cfif isdefined("arguments.language_allowance_id") and len(arguments.language_allowance_id)>
                   AND LANGUAGE_ALLOWANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.language_allowance_id#">
                </cfif>        
            ORDER BY
                LANGUANGE_STATUE,
                LANGUAGE_LEVEL
        </cfquery>
        <cfreturn GET_SETUP_LANGUAGE_ALLOWANCE>
    </cffunction>

    <cffunction name="DEL_SETUP_LANGUAGE_ALLOWANCE" access="remote" returntype="any">
        <cfargument  name="language_allowance_id">
        <cfquery name="DEL_SETUP_LANGUAGE_ALLOWANCE" datasource="#DSN#">
            DELETE            
            FROM
                SETUP_LANGUAGE_ALLOWANCE
            WHERE
                LANGUAGE_ALLOWANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.language_allowance_id#">
        </cfquery>
       <script type="text/javascript">
            window.location.href = '<cfoutput>/index.cfm?fuseaction=settings.add_language_allowance</cfoutput>';
        </script>
    </cffunction>

    <cffunction name="add_setup_language_allowance" access="remote" returntype="any">
        <cfargument  name="LANGUANGE_STATUE">
        <cfargument  name="language_level">
        <cfargument  name="language_amount">
        <cfquery name="add_setup_language_allowance" datasource="#DSN#" result="MAX_ID">
           INSERT INTO 
           SETUP_LANGUAGE_ALLOWANCE
           (
                LANGUANGE_STATUE
                ,LANGUAGE_LEVEL
                ,LANGUAGE_AMOUNT
                ,RECORD_DATE
                ,RECORD_IP
                ,RECORD_EMP
           )
            VALUES
           (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.LANGUANGE_STATUE#">
                ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language_level#">
                ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.language_amount#">
                ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                ,<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            )
                            
        </cfquery>
        <script type="text/javascript">
            window.location.href = '<cfoutput>/index.cfm?fuseaction=settings.add_language_allowance&language_allowance_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
        </script>
    </cffunction>

    <cffunction name="upd_setup_language_allowance" access="remote" returntype="any">
        <cfargument  name="LANGUANGE_STATUE">
        <cfargument  name="language_level">
        <cfargument  name="language_amount">
        <cfargument  name="language_allowance_id">
        <cfquery name="upd_setup_language_allowance" datasource="#DSN#">
            UPDATE 
                SETUP_LANGUAGE_ALLOWANCE
            SET
                LANGUANGE_STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.LANGUANGE_STATUE#">
                ,LANGUAGE_LEVEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language_level#">
                ,LANGUAGE_AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.language_amount#">
                ,UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                ,UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                ,UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            WHERE
                LANGUAGE_ALLOWANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.language_allowance_id#">   
        </cfquery>
        <script type="text/javascript">
            window.location.href = '<cfoutput>/index.cfm?fuseaction=settings.add_language_allowance&language_allowance_id=#arguments.language_allowance_id#</cfoutput>';
        </script>
    </cffunction>

    <cffunction name="GET_SETUP_LANGUAGE_NAME" access="public" returntype="any">
        <cfquery name="GET_SETUP_LANGUAGE_NAME" datasource="#DSN#">
            SELECT
                *              
            FROM
                SETUP_LANGUAGES
        </cfquery>
        <cfreturn GET_SETUP_LANGUAGE_NAME>
    </cffunction>
</cfcomponent>