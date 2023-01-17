<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
    
    <cffunction name = "get_user_info" returnType = "any" access = "public" description = "Get user info">
        <cfargument name="userkey" type="string" required="true" displayname="user key string">
        
        <cfif arguments.userkey contains "e">
            <cfquery name="USERINFO" datasource="#DSN#">
                SELECT
                    EMPLOYEE_ID,
                    EMPLOYEE_NAME AS NAME,
                    EMPLOYEE_SURNAME AS SURNAME,
                    EMPLOYEE_EMAIL AS EMAIL,
                    'ÇALIŞAN' AS MEMBER_TYPE,
                    PHOTO
                FROM
                    EMPLOYEES
                WHERE
                    EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(arguments.userkey,"-")#">
            </cfquery>	
        <cfelseif arguments.userkey contains "p">
            <cfquery name="USERINFO" datasource="#DSN#">
                SELECT
                    PARTNER_ID,
                    COMPANY_PARTNER_NAME AS NAME,
                    COMPANY_PARTNER_SURNAME AS SURNAME,
                    COMPANY_PARTNER_EMAIL AS EMAIL,
                    'PARTNER' AS MEMBER_TYPE,
                    PHOTO  
                FROM
                    COMPANY_PARTNER
                WHERE
                    PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(arguments.userkey,"-")#">
            </cfquery>	
        <cfelseif arguments.userkey contains "c">
            <cfquery name="USERINFO" datasource="#DSN#">
                SELECT
                    CONSUMER_ID,
                    CONSUMER_NAME AS NAME,
                    CONSUMER_SURNAME AS SURNAME,
                    CONSUMER_EMAIL AS EMAIL,
                    'MÜŞTERI' AS MEMBER_TYPE,
                    PICTURE AS PHOTO
                FROM
                    CONSUMER
                WHERE
                    CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(arguments.userkey,"-")#">
            </cfquery>	
        </cfif>

        <cfreturn USERINFO> 

    </cffunction>

</cfcomponent>