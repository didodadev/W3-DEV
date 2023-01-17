<<!---
File: V16\report\standart\cfc\ban.cfc
Author: Aziz Hakan Uysal
Date: 27.09.2021
Description:
    
History:
    
To Do:

--->

<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="GET_FAILED_LOGINS" access="remote" returntype="any">
        <cfargument name="user_name" type="any" default="">
        <cfargument name="status" type="any" default="">
        <cfargument name="start_date" type="any" default="">
        <cfargument name="finish_date" type="any" default="">
        <cfargument name="keyword" type="any" default="">

        <cfquery name="GET_FAILED_LOGINS" datasource="#dsn#">
            SELECT
                IS_ACTIVE,
                USER_NAME,
                USER_IP,
                LOGIN_DATE,
                OPEN_BAN_USER_EMP,
                OPEN_BAN_DATE
            FROM
                FAILED_LOGINS
            WHERE
                1 = 1
                <cfif len(arguments.user_name)>
                    AND USER_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.user_name#">
                </cfif>
                <cfif len(arguments.status)>
                    AND IS_ACTIVE=<cfif arguments.status eq 1>1<cfelse>0</cfif>
                </cfif>
                <cfif isdate(arguments.start_date) and isdate(arguments.finish_date)>
                    AND LOGIN_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('d',1,arguments.finish_date)#">
                <cfelseif isdate(arguments.start_date)>
                    AND LOGIN_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                <cfelseif isdate(arguments.finish_date)>
                    AND LOGIN_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('d',1,arguments.finish_date)#">
                </cfif>
                <cfif len(arguments.keyword)>
                    AND USER_NAME LIKE '%#arguments.keyword#%'
                </cfif>
            ORDER BY
                USER_NAME,
                LOGIN_DATE DESC
        </cfquery>
        <cfreturn GET_FAILED_LOGINS>
    </cffunction>
</cfcomponent>