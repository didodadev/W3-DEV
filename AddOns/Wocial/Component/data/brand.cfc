<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn />

    <cffunction name="get" access="public">
        <cfargument name="brand_id" required="false" default="">
        <cfargument name="platform_id" required="false" default="">
        <cfargument name="brand_name" required="false" default="">
        <cfargument name="brand_manager_id" required="false" default="">
        <cfargument name="brand_status" default="">

        <cfquery name="get_query" datasource="#dsn#" result="result">
            SELECT 
                WB.*,
                WP.PLATFORM_NAME,
                WP.PLATFORM_PROVIDER_NAME,
                EMP.EMPLOYEE_NAME,
                EMP.EMPLOYEE_SURNAME,
                WAT.ACCESS_TOKEN,
                WAT.ACCESS_TOKEN_EXPIRED_DATE
            FROM WOCIAL_BRAND AS WB
            JOIN WOCIAL_PLATFORM AS WP ON WB.PLATFORM_ID = WP.PLATFORM_ID
            JOIN EMPLOYEES AS EMP ON EMP.EMPLOYEE_ID = WB.BRAND_MANAGER
            LEFT JOIN WOCIAL_ACCESS_TOKEN AS WAT ON (WB.BRAND_ID = WAT.BRAND_ID AND WB.PLATFORM_ID = WAT.PLATFORM_ID)
            WHERE 1 = 1
            <cfif IsDefined("arguments.brand_id") and len(arguments.brand_id)>
                AND WB.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_id#">
            </cfif>
            <cfif IsDefined("arguments.platform_id") and len(arguments.platform_id)>
                AND WB.PLATFORM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.platform_id#">
            </cfif>
            <cfif IsDefined("arguments.brand_name") and len(arguments.brand_name)>
                AND WB.BRAND_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.brand_name#">
            </cfif>
            <cfif IsDefined("arguments.brand_manager_id") and len(arguments.brand_manager_id)>
                AND WB.BRAND_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_manager_id#">
            </cfif>
            <cfif IsDefined("arguments.brand_status") and len(arguments.brand_status)>
                AND WB.BRAND_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.brand_status#">
            </cfif>
        </cfquery>

        <cfreturn get_query />

    </cffunction>

    <cffunction name="insert" access="public">
        <cfargument name="platform_id" required="true">
        <cfargument name="brand_name" required="true">
        <cfargument name="social_media_url" required="true">
        <cfargument name="website_url" required="false" default="">
        <cfargument name="brand_manager_id" required="true">
        <cfargument name="brand_manager_name" required="true">
        <cfargument name="brand_description" required="false" default="">
        <cfargument name="brand_keyword" required="false" default="">
        <cfargument name="brand_status" default="0">

        <cfquery name="insert_query" datasource="#dsn#" result="result">
            INSERT INTO [WOCIAL_BRAND]
            (
                [PLATFORM_ID]
                ,[BRAND_NAME]
                ,[BRAND_SOCIAL_MEDIA_URL]
                ,[BRAND_WEBSITE_URL]
                ,[BRAND_MANAGER]
                ,[BRAND_DESCRIPTION]
                ,[BRAND_KEYWORD]
                ,[BRAND_STATUS]
                ,[RECORD_EMP]
                ,[RECORD_DATE]
                ,[RECORD_IP]
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.platform_id#">
                ,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.brand_name#">
                ,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.social_media_url#">
                ,<cfif IsDefined("arguments.website_url") and len(arguments.website_url)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.website_url#"><cfelse>NULL</cfif>
                ,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_manager_id#">
                ,<cfif IsDefined("arguments.brand_description") and len(arguments.brand_description)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.brand_description#"><cfelse>NULL</cfif>
                ,<cfif IsDefined("arguments.brand_keyword") and len(arguments.brand_keyword)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.brand_keyword#"><cfelse>NULL</cfif>
                ,<cfif IsDefined("arguments.brand_status") and arguments.brand_status eq 1>1<cfelse>0</cfif>
                ,#session.ep.userid#
                ,#now()#
                ,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
            )
        </cfquery>

        <cfreturn result />

    </cffunction>

    <cffunction name="update" access="public">
        <cfargument name="brand_id" required="true">
        <cfargument name="brand_name" required="true">
        <cfargument name="social_media_url" required="true">
        <cfargument name="website_url" required="false">
        <cfargument name="brand_manager_id" required="true">
        <cfargument name="brand_description" required="false">
        <cfargument name="brand_keyword" required="false">
        <cfargument name="brand_status" default="0">

        <cfquery name="update_query" datasource="#dsn#">
            UPDATE [WOCIAL_BRAND]
            SET  [BRAND_NAME] = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.brand_name#">
                ,[BRAND_SOCIAL_MEDIA_URL] = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.social_media_url#">
                ,[BRAND_WEBSITE_URL] = <cfif IsDefined("arguments.website_url") and len(arguments.website_url)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.website_url#"><cfelse>NULL</cfif>
                ,[BRAND_MANAGER] = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_manager_id#">
                ,[BRAND_DESCRIPTION] = <cfif IsDefined("arguments.brand_description") and len(arguments.brand_description)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.brand_description#"><cfelse>NULL</cfif>
                ,[BRAND_KEYWORD] = <cfif IsDefined("arguments.brand_keyword") and len(arguments.brand_keyword)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.brand_keyword#"><cfelse>NULL</cfif>
                ,[BRAND_STATUS] = <cfif IsDefined("arguments.brand_status") and len(arguments.brand_status)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.brand_status#"><cfelse>0</cfif>
                ,[UPDATE_EMP] = #session.ep.userid#
                ,[UPDATE_DATE] = #now()#
                ,[UPDATE_IP] = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
            WHERE [BRAND_ID] = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_id#">
        </cfquery>

        <cfreturn true />

    </cffunction>
    
    <cffunction name="delete" access="public">
        <cfargument name="brand_id" required="true">

        <cfquery name="delete_query" datasource="#dsn#">
            DELETE FROM [WOCIAL_BRAND]
            WHERE [BRAND_ID] = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_id#">
        </cfquery>

        <cfreturn true />

    </cffunction>

</cfcomponent>