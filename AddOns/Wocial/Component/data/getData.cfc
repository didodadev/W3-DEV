<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn />

    <cffunction name="getPlatform" access="public">
        <cfargument name="platform_id" required="false">
        <cfargument name="provider_name" required="false">
        
        <cfquery name="getPlatform" datasource="#dsn#">
            SELECT * FROM WOCIAL_PLATFORM 
            WHERE 1 = 1
            <cfif isDefined("arguments.platform_id") and len(arguments.platform_id)>
                AND PLATFORM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.platform_id#">
            </cfif>
            <cfif isDefined("arguments.provider_name") and len(arguments.provider_name)>
                AND PLATFORM_PROVIDER_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.provider_name#">
            </cfif>
            ORDER BY PLATFORM_NAME ASC
        </cfquery>
        <cfreturn getPlatform />
    </cffunction>

    <cffunction name="getAccessToken" access="public">
        <cfargument name="platform_id" required="false" type="any">
        <cfargument name="brand_id" required="false" type="any">
        <cfargument name="date" required="false" type="any">
        
        <cfquery name="getAccessToken" datasource="#dsn#">
            SELECT 
                WP.*,
                WAT.ACCESS_TOKEN, 
                WAT.STATE, 
                WAT.PLATFORM_ID, 
                WAT.ACCESS_TOKEN_START_DATE, 
                WAT.ACCESS_TOKEN_EXPIRED_DATE,
                CASE 
                    WHEN WAT.ACCESS_TOKEN_EXPIRED_DATE > #now()# THEN 1
                    ELSE 0
                END AS EXPIRED_STATUS
            FROM WOCIAL_PLATFORM AS WP
            LEFT JOIN WOCIAL_ACCESS_TOKEN AS WAT ON WP.PLATFORM_ID = WAT.PLATFORM_ID
            WHERE 
                1 = 1
                <cfif isDefined("arguments.platform_id") and len( arguments.platform_id )>
                    AND WP.PLATFORM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.platform_id#">
                </cfif>
                <cfif isDefined("arguments.brand_id") and len( arguments.brand_id )>
                    AND WP.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_id#">
                </cfif>
                <cfif isDefined("arguments.date") and len( arguments.date )>
                    AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date#"> BETWEEN WAT.ACCESS_TOKEN_START_DATE AND WAT.ACCESS_TOKEN_EXPIRED_DATE
                </cfif>
        </cfquery>

        <cfreturn getAccessToken />

    </cffunction>

</cfcomponent>