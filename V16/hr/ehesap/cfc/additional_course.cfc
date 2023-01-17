<!---
    File: V16\hr\ehesap\cfc\additional_course.cfc
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-06-13
    Description:  Memur Ek Ders ÜCret
        
    History:
        
    To Do:

--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="GET_ADDITIONAL_COURSE_TABLE" access="public" returntype="any">
        <cfargument  name="start_date">
        <cfargument  name="finish_date">
        <cfargument  name="additional_course_id">
        
     <!---    <cf_date tarih = "arguments.start_date">
        <cf_date tarih = "arguments.finish_date"> --->

        <cfquery name="GET_ADDITIONAL_COURSE_TABLE" datasource="#DSN#">
            SELECT
                *              
            FROM
                ADDITIONAL_COURSE_TABLE
            WHERE
                1 = 1
                <cfif isdefined("arguments.start_date") and len(arguments.start_date) and isdefined("arguments.finish_date") and len(arguments.finish_date)>
                    AND START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                    AND FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                </cfif>      
                <cfif isdefined("arguments.start_month") and len(arguments.start_month) and isdefined("arguments.end_month") and len(arguments.end_month)>
                    AND
                    (
                        (START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.start_month)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.end_month)#">) OR
                        (FINISH_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.start_month)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.end_month)#">) OR
                        (START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.start_month)#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.end_month)#">)
                    )
                </cfif>        
                <cfif isdefined("arguments.start_date") and len(arguments.start_date) and isdefined("arguments.finish_date") and len(arguments.finish_date)>
                    AND ADDITIONAL_COURSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.additional_course_id#">
                </cfif>    
            ORDER BY
                START_DATE,
                FINISH_DATE
        </cfquery>
        
        <cfreturn GET_ADDITIONAL_COURSE_TABLE>
    </cffunction>

    <cffunction name="ADD_ADDITIONAL_COURSE_TABLE" access="remote" returntype="any">
        <cf_date tarih = "arguments.START_DATE">
        <cf_date tarih = "arguments.FINISH_DATE">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfquery name="ADD_ADDITIONAL_COURSE_TABLE" datasource="#DSN#" result="MAX_ID">
                INSERT INTO ADDITIONAL_COURSE_TABLE
                (
                    START_DATE
                    ,FINISH_DATE
                    ,TITLE
                    ,DAYTIME_EDUCATION_1
                    ,DAYTIME_EDUCATION_2
                    ,DAYTIME_EDUCATION_3
                    ,DAYTIME_EDUCATION_4
                    ,DAYTIME_EDUCATION_5
                    ,PUBLIC_HOLIDAY_1
                    ,PUBLIC_HOLIDAY_2
                    ,PUBLIC_HOLIDAY_3
                    ,PUBLIC_HOLIDAY_4
                    ,PUBLIC_HOLIDAY_5
                    ,EVENING_EDUCATION_1
                    ,EVENING_EDUCATION_2
                    ,EVENING_EDUCATION_3
                    ,EVENING_EDUCATION_4
                    ,EVENING_EDUCATION_5
                    ,RECORD_DATE
                    ,RECORD_IP
                    ,RECORD_EMP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.START_DATE#">
                    ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FINISH_DATE#">
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.daytime_education_1#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.daytime_education_2#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.daytime_education_3#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.daytime_education_4#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.daytime_education_5#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.public_holiday_1#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.public_holiday_2#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.public_holiday_3#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.public_holiday_4#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.public_holiday_5#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.evening_education_1#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.evening_education_2#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.evening_education_3#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.evening_education_4#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.evening_education_5#">
                    ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    ,<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                )
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="UPD_ADDITIONAL_COURSE_TABLE" access="remote" returntype="any">
        <cf_date tarih = "arguments.STARTDATE">
        <cf_date tarih = "arguments.FINISHDATE">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfquery name="UPD_ADDITIONAL_COURSE_TABLE" datasource="#DSN#">
                UPDATE 
                    ADDITIONAL_COURSE_TABLE
                SET 
                    START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.START_DATE#">
                    ,FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FINISH_DATE#">
                    ,TITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#">
                    ,DAYTIME_EDUCATION_1 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.daytime_education_1#">
                    ,DAYTIME_EDUCATION_2 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.daytime_education_2#">
                    ,DAYTIME_EDUCATION_3 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.daytime_education_3#">
                    ,DAYTIME_EDUCATION_4 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.daytime_education_4#">
                    ,DAYTIME_EDUCATION_5 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.daytime_education_5#">
                    ,PUBLIC_HOLIDAY_1 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.public_holiday_1#">
                    ,PUBLIC_HOLIDAY_2 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.public_holiday_2#">
                    ,PUBLIC_HOLIDAY_3 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.public_holiday_3#">
                    ,PUBLIC_HOLIDAY_4 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.public_holiday_4#">
                    ,PUBLIC_HOLIDAY_5 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.public_holiday_4#">
                    ,EVENING_EDUCATION_1 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.evening_education_1#">
                    ,EVENING_EDUCATION_2 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.evening_education_2#">
                    ,EVENING_EDUCATION_3 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.evening_education_3#">
                    ,EVENING_EDUCATION_4 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.evening_education_4#">
                    ,EVENING_EDUCATION_5 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.evening_education_5#">
                    ,UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    ,UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    ,UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                WHERE 
                    ADDITIONAL_COURSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ADDITIONAL_COURSE_ID#">
            </cfquery>
             <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="DEL_ADDITIONAL_COURSE_TABLE" access="remote" returntype="any">
        <cftry>
            <cfquery name="DEL_ADDITIONAL_COURSE_TABLE" datasource="#DSN#">
                DELETE             
                FROM
                    ADDITIONAL_COURSE_TABLE
                WHERE
                    ADDITIONAL_COURSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ADDITIONAL_COURSE_ID#">
            </cfquery>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>
</cfcomponent>