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

    <cffunction name="GET_SETUP_ACADEMIC_PERSONNEL" access="public" returntype="any">
        <cfargument  name="start_date">
        <cfargument  name="finish_date">
        <cfargument  name="start_month">
        <cfargument  name="end_month">
        <cfargument  name="additional_course_id">
        
     <!---    <cf_date tarih = "arguments.start_date">
        <cf_date tarih = "arguments.finish_date"> --->

        <cfquery name="GET_SETUP_ACADEMIC_PERSONNEL" datasource="#DSN#">
            SELECT
                *              
            FROM
                SETUP_ACADEMIC_PERSONNEL
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
                <cfif isdefined("arguments.additional_course_id") and len(arguments.additional_course_id)>
                    AND ADDITIONAL_COURSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.additional_course_id#">
                </cfif>    
            ORDER BY
                START_DATE,
                FINISH_DATE
        </cfquery>
        
        <cfreturn GET_SETUP_ACADEMIC_PERSONNEL>
    </cffunction>

    <cffunction name="ADD_SETUP_ACADEMIC_PERSONNEL" access="remote" returntype="any">
        <cf_date tarih = "arguments.START_DATE">
        <cf_date tarih = "arguments.FINISH_DATE">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfquery name="ADD_SETUP_ACADEMIC_PERSONNEL" datasource="#DSN#" result="MAX_ID">
                INSERT INTO SETUP_ACADEMIC_PERSONNEL
                (
                    START_DATE
                    ,FINISH_DATE
                    ,TITLE
                    ,RATE_1
                    ,RATE_2
                    ,RATE_3
                    ,RATE_4
                    ,RATE_5
                    ,RATE_6
                    ,RECORD_DATE
                    ,RECORD_IP
                    ,RECORD_EMP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.START_DATE#">
                    ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FINISH_DATE#">
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.rate_1#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.rate_2#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.rate_3#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.rate_4#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.rate_5#">
                    ,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.rate_6#">
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

    <cffunction name="UPD_SETUP_ACADEMIC_PERSONNEL" access="remote" returntype="any">
        <cf_date tarih = "arguments.STARTDATE">
        <cf_date tarih = "arguments.FINISHDATE">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfquery name="UPD_SETUP_ACADEMIC_PERSONNEL" datasource="#DSN#">
                UPDATE 
                    SETUP_ACADEMIC_PERSONNEL
                SET 
                    START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.START_DATE#">
                    ,FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FINISH_DATE#">
                    ,TITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#">
                    ,RATE_1 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.rate_1#">
                    ,RATE_2 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.rate_2#">
                    ,RATE_3 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.rate_3#">
                    ,RATE_4 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.rate_4#">
                    ,RATE_5 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.rate_5#">
                    ,RATE_6 = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.rate_6#">
                    ,UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    ,UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    ,UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                WHERE 
                    SETUP_ACADEMIC_PERSONNEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.setup_academic_personnel_id#">
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

    <cffunction name="DEL_SETUP_ACADEMIC_PERSONNEL" access="remote" returntype="any">
        <cftry>
            <cfquery name="DEL_SETUP_ACADEMIC_PERSONNEL" datasource="#DSN#">
                DELETE             
                FROM
                    SETUP_ACADEMIC_PERSONNEL
                WHERE
                    SETUP_ACADEMIC_PERSONNEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.setup_academic_personnel_id#">
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