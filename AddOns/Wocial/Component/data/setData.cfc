<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn />

    <cffunction name="setAccessToken" access="public">
        <cfargument name="access_token" required="true" type="string">
        <cfargument name="state" required="true" type="string">
        <cfargument name="platform_id" required="true" type="numeric">
        <cfargument name="expiredDate" required="true" type="any">
        
        <cfquery name="setAccessToken" datasource="#dsn#" result="result">
            INSERT INTO WOCIAL_ACCESS_TOKEN( 
                ACCESS_TOKEN, 
                STATE, 
                PLATFORM_ID, 
                ACCESS_TOKEN_START_DATE, 
                ACCESS_TOKEN_EXPIRED_DATE,
                RECORD_EMP,
                RECORD_DATE,
                RECORD_IP
            )
            VALUES(
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.access_token#">,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.state#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.platform_id#">,
                #now()#,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.expiredDate#">,
                #session.ep.userid#,
                #now()#,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
            )
        </cfquery>

        <cfreturn result />

    </cffunction>

</cfcomponent>