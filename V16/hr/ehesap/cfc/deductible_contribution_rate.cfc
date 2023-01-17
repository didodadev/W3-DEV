<!---
    File: V16\hr\ehesap\cfc\deductible_contribution_rate.cfc
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-09-07
    Description: Kesenek katkı oranları
        
    History:
        
    To Do:

--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="GET_DEDUCTIBLE_CONTRIBUTION_RATE" access="remote" returntype="any">
        <cfargument  name="deductible_contribution_rate_id" default="">
        <cfargument  name="startdate" default="">
        <cfargument  name="finishdate" default="">

        <cfquery name="GET_DEDUCTIBLE_CONTRIBUTION_RATE" datasource="#DSN#">
            SELECT
                *              
            FROM
                DEDUCTIBLE_CONTRIBUTION_RATE
            WHERE
                1 = 1
                <cfif len(arguments.deductible_contribution_rate_id)>
                    AND DEDUCTIBLE_CONTRIBUTION_RATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.deductible_contribution_rate_id#">
                </cfif>
                <cfif len(arguments.startdate) and len(arguments.finishdate)>
                    AND
                    (
                        (STARTDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.startdate)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.finishdate)#">) OR
                        (FINISHDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.startdate)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.finishdate)#">) OR
                        (STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.startdate)#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.finishdate)#">)
                    )
                </cfif>
            ORDER BY
                STARTDATE,
                FINISHDATE
        </cfquery>
        <cfreturn GET_DEDUCTIBLE_CONTRIBUTION_RATE>
    </cffunction>

    <cffunction name="GET_DEDUCTIBLE_CONTRIBUTION_RATE_REMOTE" access="remote" returnformat="JSON" returntype="any">
        <cfargument  name="startdate" default="">
        <cfargument  name="finishdate" default="">
        <cfargument  name="dcr_id" default="">
        <cf_date tarih = "arguments.startdate">
        <cf_date tarih = "arguments.finishdate">
        <cfquery name="GET_DEDUCTIBLE_CONTRIBUTION_RATE_REMOTE" datasource="#DSN#">
            SELECT
                *              
            FROM
                DEDUCTIBLE_CONTRIBUTION_RATE
            WHERE
                <cfif isdefined("arguments.dcr_id") and len(arguments.dcr_id)>
                    DEDUCTIBLE_CONTRIBUTION_RATE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.dcr_id#"> AND
                </cfif>
                (
                    (STARTDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.startdate)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.finishdate)#">) OR
                    (FINISHDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.startdate)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.finishdate)#">) OR
                    (STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.startdate)#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.finishdate)#">)
                )
        </cfquery>

        <cfreturn Replace(SerializeJSON(GET_DEDUCTIBLE_CONTRIBUTION_RATE_REMOTE.recordcount),"//","")>
    </cffunction>

    <cffunction name="DEL_DEDUCTIBLE_CONTRIBUTION_RATE" access="public" returntype="any">
        <cftry>
            <cfset responseStruct = structNew()> 
            <cfquery name="DEL_DEDUCTIBLE_CONTRIBUTION_RATE" datasource="#dsn#">
                DELETE FROM DEDUCTIBLE_CONTRIBUTION_RATE WHERE  DEDUCTIBLE_CONTRIBUTION_RATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.deductible_contribution_rate_id#">
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

    <cffunction name="ADD_DEDUCTIBLE_CONTRIBUTION_RATE" access="remote" returntype="any">
        <cfset responseStruct = structNew()>
        <cftry>      
            <cf_date tarih = "arguments.STARTDATE">
            <cf_date tarih = "arguments.FINISHDATE">
            <cfquery name="ADD_DEDUCTIBLE_CONTRIBUTION_RATE" datasource="#DSN#" result="MAX_ID">
                INSERT INTO DEDUCTIBLE_CONTRIBUTION_RATE
                (
                    TITLE
                    ,STARTDATE
                    ,FINISHDATE
                    ,MIN_PAYMENT_1
                    ,MAX_PAYMENT_1
                    ,RATIO_1
                    ,MIN_PAYMENT_2
                    ,MAX_PAYMENT_2
                    ,RATIO_2
                    ,MIN_PAYMENT_3
                    ,MAX_PAYMENT_3
                    ,RATIO_3
                    ,MIN_PAYMENT_4
                    ,MAX_PAYMENT_4
                    ,RATIO_4
                    ,MIN_PAYMENT_5
                    ,MAX_PAYMENT_5
                    ,RATIO_5
                    ,MIN_PAYMENT_6
                    ,MAX_PAYMENT_6
                    ,RATIO_6
                    ,MIN_PAYMENT_7
                    ,MAX_PAYMENT_7
                    ,RATIO_7
                    ,RECORD_DATE
                    ,RECORD_IP
                    ,RECORD_EMP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#">
                    ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.STARTDATE#">
                    ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FINISHDATE#">
                    ,<cfif isdefined("arguments.min_payment_1") and len(evaluate("arguments.min_payment_1"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.min_payment_1#"><cfelse>NULL</cfif>
                    ,<cfif isdefined("arguments.max_payment_1") and len(evaluate("arguments.max_payment_1"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_payment_1#"><cfelse>NULL</cfif>
                    ,<cfif isdefined("arguments.ratio_1") and len(evaluate("arguments.ratio_1"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ratio_1#"><cfelse>NULL</cfif>
                    ,<cfif isdefined("arguments.min_payment_2") and len(evaluate("arguments.min_payment_2"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.min_payment_2#"><cfelse>NULL</cfif>
                    ,<cfif isdefined("arguments.max_payment_2") and len(evaluate("arguments.max_payment_2"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_payment_2#"><cfelse>NULL</cfif>
                    ,<cfif isdefined("arguments.ratio_2") and len(evaluate("arguments.ratio_2"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ratio_2#"><cfelse>NULL</cfif>
                    ,<cfif isdefined("arguments.min_payment_3") and len(evaluate("arguments.min_payment_3"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.min_payment_3#"><cfelse>NULL</cfif>
                    ,<cfif isdefined("arguments.max_payment_3") and len(evaluate("arguments.max_payment_3"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_payment_3#"><cfelse>NULL</cfif>
                    ,<cfif isdefined("arguments.ratio_3") and len(evaluate("arguments.ratio_3"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ratio_3#"><cfelse>NULL</cfif>
                    ,<cfif isdefined("arguments.min_payment_4") and len(evaluate("arguments.min_payment_4"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.min_payment_4#"><cfelse>NULL</cfif>
                    ,<cfif isdefined("arguments.max_payment_4") and len(evaluate("arguments.max_payment_4"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_payment_4#"><cfelse>NULL</cfif>
                    ,<cfif isdefined("arguments.ratio_4") and len(evaluate("arguments.ratio_4"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ratio_4#"><cfelse>NULL</cfif>
                    ,<cfif isdefined("arguments.min_payment_5") and len(evaluate("arguments.min_payment_5"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.min_payment_5#"><cfelse>NULL</cfif>
                    ,<cfif isdefined("arguments.max_payment_5") and len(evaluate("arguments.max_payment_5"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_payment_5#"><cfelse>NULL</cfif>
                    ,<cfif isdefined("arguments.ratio_5") and len(evaluate("arguments.ratio_5"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ratio_5#"><cfelse>NULL</cfif>
                    ,<cfif isdefined("arguments.min_payment_6") and len(evaluate("arguments.min_payment_6"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.min_payment_6#"><cfelse>NULL</cfif>
                    ,<cfif isdefined("arguments.max_payment_6") and len(evaluate("arguments.max_payment_6"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_payment_6#"><cfelse>NULL</cfif>
                    ,<cfif isdefined("arguments.ratio_6") and len(evaluate("arguments.ratio_6"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ratio_6#"><cfelse>NULL</cfif>
                    ,<cfif isdefined("arguments.min_payment_7") and len(evaluate("arguments.min_payment_7"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.min_payment_7#"><cfelse>NULL</cfif>
                    ,<cfif isdefined("arguments.max_payment_7") and len(evaluate("arguments.max_payment_7"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_payment_7#"><cfelse>NULL</cfif>
                    ,<cfif isdefined("arguments.ratio_7") and len(evaluate("arguments.ratio_7"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ratio_7#"><cfelse>NULL</cfif>
                    ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    ,<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                )
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = "">
        <cfcatch>
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>  
    </cffunction>

    <cffunction name="UPD_DEDUCTIBLE_CONTRIBUTION_RATE" access="remote" returntype="any">
        <cfset responseStruct = structNew()>
        <cftry>      
            <cf_date tarih = "arguments.STARTDATE">
            <cf_date tarih = "arguments.FINISHDATE">
            <cfquery name="UPD_DEDUCTIBLE_CONTRIBUTION_RATE" datasource="#DSN#">
                UPDATE 
                    DEDUCTIBLE_CONTRIBUTION_RATE
                SET TITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#">
                    ,STARTDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.STARTDATE#">
                    ,FINISHDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FINISHDATE#">
                    ,MIN_PAYMENT_1 = <cfif isdefined("arguments.min_payment_1") and len(evaluate("arguments.min_payment_1"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.min_payment_1#"><cfelse>NULL</cfif>
                    ,MAX_PAYMENT_1 = <cfif isdefined("arguments.max_payment_1") and len(evaluate("arguments.max_payment_1"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_payment_1#"><cfelse>NULL</cfif>
                    ,RATIO_1 = <cfif isdefined("arguments.ratio_1") and len(evaluate("arguments.ratio_1"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ratio_1#"><cfelse>NULL</cfif>
                    ,MIN_PAYMENT_2 = <cfif isdefined("arguments.min_payment_2") and len(evaluate("arguments.min_payment_2"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.min_payment_2#"><cfelse>NULL</cfif>
                    ,MAX_PAYMENT_2 = <cfif isdefined("arguments.max_payment_2") and len(evaluate("arguments.max_payment_2"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_payment_2#"><cfelse>NULL</cfif>
                    ,RATIO_2 = <cfif isdefined("arguments.ratio_2") and len(evaluate("arguments.ratio_2"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ratio_2#"><cfelse>NULL</cfif>
                    ,MIN_PAYMENT_3 = <cfif isdefined("arguments.min_payment_3") and len(evaluate("arguments.min_payment_3"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.min_payment_3#"><cfelse>NULL</cfif>
                    ,MAX_PAYMENT_3 = <cfif isdefined("arguments.max_payment_3") and len(evaluate("arguments.max_payment_3"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_payment_3#"><cfelse>NULL</cfif>
                    ,RATIO_3 = <cfif isdefined("arguments.ratio_3") and len(evaluate("arguments.ratio_3"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ratio_3#"><cfelse>NULL</cfif>
                    ,MIN_PAYMENT_4 = <cfif isdefined("arguments.min_payment_4") and len(evaluate("arguments.min_payment_4"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.min_payment_4#"><cfelse>NULL</cfif>
                    ,MAX_PAYMENT_4 = <cfif isdefined("arguments.max_payment_4") and len(evaluate("arguments.max_payment_4"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_payment_4#"><cfelse>NULL</cfif>
                    ,RATIO_4 = <cfif isdefined("arguments.ratio_4") and len(evaluate("arguments.ratio_4"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ratio_4#"><cfelse>NULL</cfif>
                    ,MIN_PAYMENT_5 = <cfif isdefined("arguments.min_payment_5") and len(evaluate("arguments.min_payment_5"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.min_payment_5#"><cfelse>NULL</cfif>
                    ,MAX_PAYMENT_5 = <cfif isdefined("arguments.max_payment_5") and len(evaluate("arguments.max_payment_5"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_payment_5#"><cfelse>NULL</cfif>
                    ,RATIO_5 = <cfif isdefined("arguments.ratio_5") and len(evaluate("arguments.ratio_5"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ratio_5#"><cfelse>NULL</cfif>
                    ,MIN_PAYMENT_6 = <cfif isdefined("arguments.min_payment_6") and len(evaluate("arguments.min_payment_6"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.min_payment_6#"><cfelse>NULL</cfif>
                    ,MAX_PAYMENT_6 = <cfif isdefined("arguments.max_payment_6") and len(evaluate("arguments.max_payment_6"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_payment_6#"><cfelse>NULL</cfif>
                    ,RATIO_6 = <cfif isdefined("arguments.ratio_6") and len(evaluate("arguments.ratio_6"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ratio_6#"><cfelse>NULL</cfif>
                    ,MIN_PAYMENT_7 =  <cfif isdefined("arguments.min_payment_7") and len(evaluate("arguments.min_payment_7"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.min_payment_7#"><cfelse>NULL</cfif>
                    ,MAX_PAYMENT_7 =  <cfif isdefined("arguments.max_payment_7") and len(evaluate("arguments.max_payment_7"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_payment_7#"><cfelse>NULL</cfif>
                    ,RATIO_7 = <cfif isdefined("arguments.ratio_7") and len(evaluate("arguments.ratio_7"))><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.ratio_7#"><cfelse>NULL</cfif>
                    ,UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">  
                    ,UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    ,UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                WHERE 
                    DEDUCTIBLE_CONTRIBUTION_RATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.deductible_contribution_rate_id#">
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = "">
        <cfcatch>
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>  
    </cffunction>
</cfcomponent>