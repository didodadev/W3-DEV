<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="is_installed" returntype="numeric">
        <cfquery name="query_installed" datasource="#dsn#">
            SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '#dsn#' AND TABLE_NAME = 'PLVN_SETTINGS'
        </cfquery>

        <cfreturn query_installed.recordcount>
    </cffunction>
    
    <cffunction name="get_plevne_settings" returntype="query">
        <cfargument name="id" default="">
        <cfargument name="key" default="">
        <cfargument name="status" default="">
        <cfargument name="timeout" default="0">
        
        <cfquery name="qsettings_cached" datasource="#dsn#" cachedwithin="#createTimespan(0, arguments.timeout, 0, 1)#">
            SELECT * FROM PLVN_SETTINGS 
        </cfquery>
        <cfquery name="qsettings" dbtype="query">
            SELECT * FROM qsettings_cached
            WHERE 1 = 1
            <cfif len(arguments.id)>
                AND SETTING_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.id#'>
            </cfif>
            <cfif len(arguments.key)>
                AND SETTING_KEY = <cfqueryparam cfsqltype='CF_SQL_VARCHAR' value='#arguments.key#'>
            </cfif>
            <cfif len(arguments.status)>
                AND STATUS = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.status#'>
            </cfif>
        </cfquery>

        <cfreturn qsettings>
    </cffunction>

    <cffunction name="save_plevne_settings">
        <cfargument name="SETTING_ID" default="">
        <cfargument name="SETTING_KEY" default="">
        <cfargument name="SETTING_VALUE" default="">
        <cfargument name="STATUS" default="1">

        <cfif len(arguments.SETTING_ID) eq 0 or arguments.SETTING_ID eq "0">
            <cfquery name="qsetting_insert" datasource="#dsn#">
            INSERT INTO PLVN_SETTINGS(SETTING_KEY, SETTING_VALUE, STATUS)
            VALUES (
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.SETTING_KEY#'>,
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.SETTING_VALUE#'>,
                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.STATUS#'>
            )
            </cfquery>
        <cfelse>
            <cfquery name="qsetting_update" datasource="#dsn#">
                UPDATE PLVN_SETTINGS SET SETTING_KEY = SETTING_KEY
                <cfif len(arguments.SETTING_VALUE)>
                ,SETTING_VALUE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.SETTING_VALUE#'>
                </cfif>
                <cfif len(arguments.STATUS)>
                ,STATUS = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.STATUS#'>
                </cfif>
                WHERE 
                <cfif arguments.SETTING_ID eq "-1" and len(arguments.SETTING_KEY)>
                SETTING_KEY = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.SETTING_KEY#'>
                <cfelse>
                SETTING_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.SETTING_ID#'>
                </cfif>
            </cfquery>
        </cfif>
        <cfset get_plevne_settings(id: 0, timeout: 0)>
    </cffunction>

</cfcomponent>