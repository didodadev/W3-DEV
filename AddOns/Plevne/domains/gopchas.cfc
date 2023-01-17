<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="get_gopchas" returntype="query">
        <cfargument name="gopcha_id" default="">
        <cfargument name="user_id" default="">
        <cfargument name="gopcha_type" default="">
        <cfargument name="gopcha_key" default="">
        <cfargument name="gopcha_code" default="">
        <cfargument name="address" default="">
        <cfargument name="gopcha_until" default="">
        <cfargument name="ip" default="">
        <cfargument name="unusedis" default="">

        <cfquery name="query_get_gopchas" datasource="#dsn#">
            SELECT * FROM PLVN_GOPCHA
            WHERE 1 = 1
            <cfif len(arguments.gopcha_id)>
            AND GOPCHA_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.gopcha_id#'>
            </cfif>
            <cfif len(arguments.user_id)>
            AND USER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.user_id#'>
            </cfif>
            <cfif len(arguments.gopcha_type)>
            AND GOPCHA_TYPE = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.gopcha_type#'>
            </cfif>
            <cfif len(arguments.gopcha_key)>
            AND GOPCHA_KEY = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.gopcha_key#'>
            </cfif>
            <cfif len(arguments.gopcha_code)>
            AND GOPCHA_CODE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.gopcha_code#'>
            </cfif>
            <cfif len(arguments.address)>
            AND ADDRESS = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.address#'>
            </cfif>
            <cfif arguments.gopcha_until neq "">
            AND GOPTCHA_UNTIL = <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#arguments.gopcha_until#' null="#arguments.gopcha_until eq "NULL"#">
            </cfif>
            <cfif len(arguments.ip)>
            AND IP = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.ip#'>
            </cfif>
            <cfif arguments.unusedis eq "1">
            AND GOPCHA_UNTIL IS NULL
            ORDER BY GOPCHA_ID DESC
            </cfif>
            <cfif arguments.unusedis eq "2">
            AND GOPCHA_UNTIL > #now()#
            ORDER BY GOPCHA_ID DESC
            </cfif>
        </cfquery>

        <cfreturn query_get_gopchas>
    </cffunction>

    <cffunction name="save_gopcha">
        <cfargument name="gopcha_id" default="0" type="numeric">
        <cfargument name="user_id" type="numeric">
        <cfargument name="gopcha_type" type="numeric">
        <cfargument name="gopcha_key" type="string">
        <cfargument name="gopcha_code" type="string">
        <cfargument name="address" type="string">
        <cfargument name="gopcha_until" type="date">
        <cfargument name="ip" type="string">

        <cfif arguments.gopcha_id eq 0>
            <cfquery name="query_insert_gopcha" datasource="#dsn#">
            INSERT INTO PLVN_GOPCHA ( 
                USER_ID, 
                GOPCHA_TYPE, 
                GOPCHA_KEY, 
                GOPCHA_CODE, 
                ADDRESS,
                IP )
            VALUES (
                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.user_id#'>,
                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.gopcha_type#'>,
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.gopcha_key#'>,
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.gopcha_code#'>,
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.address#'>,
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.ip#'>
            )
            </cfquery>
        <cfelse>
            <cfquery name="query_update_gopcha" datasource="#dsn#">
            UPDATE PLVN_GOPCHA SET 
            GOPCHA_UNTIL = <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#arguments.gopcha_until#'>
            WHERE GOPCHA_KEY = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.gopcha_key#'>
            AND USER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.user_id#'>
            </cfquery>
        </cfif>
    </cffunction>

    <cffunction name="delete_gopcha">
        <cfargument name="gopcha_id" default="">
        <cfargument name="gopcha_key" default="">
        <cfargument name="remove_expired" default="0">

        <cfquery name="delete_gopcha" datasource="#dsn#">
            DELETE FROM PLVN_GOPCHA
            WHERE 1 = 2
            <cfif len(arguments.gopcha_id)>
            OR GOPCHA_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.gopcha_id#'>
            </cfif>
            <cfif len(arguments.gopcha_key)>
            OR GOPCHA_KEY = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.gopcha_key#'>
            </cfif>
            <cfif arguments.remove_expired eq "1">
            OR (GOPCHA_UNTIL IS NOT NULL AND GOPCHA_UNTIL < #now()#)
            </cfif>
        </cfquery>
    </cffunction>

</cfcomponent>