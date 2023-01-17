<cfcomponent>
    <cffunction name="ModuleName" access="remote" returntype="query">
        <cfargument name="datasource" default="#dsn#" required="yes">
        <cfargument name="fuseaction" required="yes">
        <cfquery name="GET_MODULE_NAME" datasource="#arguments.datasource#">
           SELECT
                WM.MODULE_ID,
                ISNULL(Replace(S1.ITEM_#UCASE(session.ep.language)#,'''',''),WM.MODULE) AS MODULE
            FROM
                WRK_MODULE AS WM
                LEFT JOIN WRK_OBJECTS AS OBJ ON OBJ.MODULE_NO = WM.MODULE_NO
                LEFT JOIN SETUP_LANGUAGE_TR AS S1 ON WM.MODULE_DICTIONARY_ID = S1.DICTIONARY_ID
            WHERE
                OBJ.FULL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fuseaction#">
        </cfquery>
        <cfreturn GET_MODULE_NAME/>
    </cffunction>
</cfcomponent>