<!---
    File: V16\hr\ehesap\cfc\grade_step_params.cfc
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-05-30
    Description: Memur Gösterge Tablosu
        
    History:
        
    To Do:

--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="GET_EMPLOYEES_GRADE_STEP_PARAMS" access="public" returntype="any">
        <cfargument  name="start_date">
        <cfargument  name="finish_date">
        <cfargument  name="start_month">
        <cfargument  name="end_month">
        <cfargument  name="grade">
        <cfargument  name="step">
        
     <!---    <cf_date tarih = "arguments.start_date">
        <cf_date tarih = "arguments.finish_date"> --->

        <cfquery name="GET_EMPLOYEES_GRADE_STEP_PARAMS" datasource="#DSN#">
            SELECT
                *              
            FROM
                EMPLOYEES_GRADE_STEP_PARAMS
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
                    AND
                        GRADE = <cfqueryparam cfsqltype="cf_sql_integer" value="#grade#">
                </cfif>        
            ORDER BY
                START_DATE,
                FINISH_DATE
        </cfquery>
        
        <cfreturn GET_EMPLOYEES_GRADE_STEP_PARAMS>
    </cffunction>

    <cffunction name="GET_EMPLOYEES_GRADE_STEP_PARAMS_REMOTE" access="remote" returnformat="JSON" returntype="any">
        <cfargument  name="start_date">
        <cfargument  name="finish_date">
        <cf_date tarih = "arguments.start_date">
        <cf_date tarih = "arguments.finish_date">
        <cfquery name="GET_EMPLOYEES_GRADE_STEP_PARAMS_REMOTE" datasource="#DSN#">
            SELECT
                *              
            FROM
                EMPLOYEES_GRADE_STEP_PARAMS
            WHERE
                (START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.start_date)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.finish_date)#">) OR
                (FINISH_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.start_date)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.finish_date)#">) OR
                (START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.start_date)#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.finish_date)#">)
        </cfquery>

        <cfreturn Replace(SerializeJSON(GET_EMPLOYEES_GRADE_STEP_PARAMS_REMOTE.recordcount),"//","")>
    </cffunction>

    <cffunction name="ADD_EMPLOYEES_GRADE_STEP_PARAMS" access="remote" returntype="any">
        <cf_date tarih = "arguments.STARTDATE">
        <cf_date tarih = "arguments.FINISHDATE">
        <cfloop index="i" from="1" to="15">
            <cfquery name="ADD_EMPLOYEES_GRADE_STEP_PARAMS" datasource="#DSN#" result="MAX_ID">
                INSERT INTO EMPLOYEES_GRADE_STEP_PARAMS
                (
                    TITLE
                    ,GRADE
                    ,STEP_1
                    ,STEP_2
                    ,STEP_3
                    ,STEP_4
                    ,STEP_5
                    ,STEP_6
                    ,STEP_7
                    ,STEP_8
                    ,STEP_9
                    ,START_DATE
                    ,FINISH_DATE
                    ,RECORD_DATE
                    ,RECORD_IP
                    ,RECORD_EMP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.NAME#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">,
                    <cfif isdefined("arguments.step_#i#_1") and len(evaluate("arguments.step_#i#_1"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.step_#i#_1")#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.step_#i#_2") and len(evaluate("arguments.step_#i#_2"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.step_#i#_2")#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.step_#i#_3") and len(evaluate("arguments.step_#i#_3"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.step_#i#_3")#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.step_#i#_4") and len(evaluate("arguments.step_#i#_4"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.step_#i#_4")#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.step_#i#_5") and len(evaluate("arguments.step_#i#_5"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.step_#i#_5")#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.step_#i#_6") and len(evaluate("arguments.step_#i#_6"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.step_#i#_6")#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.step_#i#_7") and len(evaluate("arguments.step_#i#_7"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.step_#i#_7")#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.step_#i#_8") and len(evaluate("arguments.step_#i#_8"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.step_#i#_8")#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.step_#i#_9") and len(evaluate("arguments.step_#i#_9"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.step_#i#_9")#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.STARTDATE#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FINISHDATE#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                )
            </cfquery>
        </cfloop>
        <script type="text/javascript">
            window.location.href = '<cfoutput>/index.cfm?fuseaction=ehesap.personal_payment</cfoutput>';
        </script>
    </cffunction>

    <cffunction name="UPD_EMPLOYEES_GRADE_STEP_PARAMS" access="remote" returntype="any">
        <cf_date tarih = "arguments.STARTDATE">
        <cf_date tarih = "arguments.FINISHDATE">
        <cfloop index="i" from="1" to="15">
            <cfquery name="UPD_EMPLOYEES_GRADE_STEP_PARAMS" datasource="#DSN#">
                UPDATE EMPLOYEES_GRADE_STEP_PARAMS
                SET 
                    GRADE = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
                    ,STEP_1 = <cfif isdefined("arguments.step_#i#_1") and len(evaluate("arguments.step_#i#_1"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.step_#i#_1")#"><cfelse>NULL</cfif>
                    ,STEP_2 = <cfif isdefined("arguments.step_#i#_2") and len(evaluate("arguments.step_#i#_2"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.step_#i#_2")#"><cfelse>NULL</cfif>
                    ,STEP_3 = <cfif isdefined("arguments.step_#i#_3") and len(evaluate("arguments.step_#i#_3"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.step_#i#_3")#"><cfelse>NULL</cfif>
                    ,STEP_4 = <cfif isdefined("arguments.step_#i#_4") and len(evaluate("arguments.step_#i#_4"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.step_#i#_4")#"><cfelse>NULL</cfif>
                    ,STEP_5 = <cfif isdefined("arguments.step_#i#_5") and len(evaluate("arguments.step_#i#_5"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.step_#i#_5")#"><cfelse>NULL</cfif>
                    ,STEP_6 = <cfif isdefined("arguments.step_#i#_6") and len(evaluate("arguments.step_#i#_6"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.step_#i#_6")#"><cfelse>NULL</cfif>
                    ,STEP_7 = <cfif isdefined("arguments.step_#i#_7") and len(evaluate("arguments.step_#i#_7"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.step_#i#_7")#"><cfelse>NULL</cfif>
                    ,STEP_8 = <cfif isdefined("arguments.step_#i#_8") and len(evaluate("arguments.step_#i#_8"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.step_#i#_8")#"><cfelse>NULL</cfif>
                    ,STEP_9 = <cfif isdefined("arguments.step_#i#_9") and len(evaluate("arguments.step_#i#_9"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.step_#i#_9")#"><cfelse>NULL</cfif>
                    ,START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.STARTDATE#">
                    ,FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FINISHDATE#">
                    ,UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    ,UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    ,UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                    ,TITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.NAME#">
                WHERE 
                    GRADE_STEP_PARAMS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.grade_step_params_id_#i#")#"> 
            </cfquery>
        </cfloop>
        <script type="text/javascript">
            window.location.href = '<cfoutput>/index.cfm?fuseaction=ehesap.personal_payment</cfoutput>';
        </script>
    </cffunction>

    <cffunction name="DEL_EMPLOYEES_GRADE_STEP_PARAMS" access="remote" returntype="any">
        <cfquery name="DEL_EMPLOYEES_GRADE_STEP_PARAMS" datasource="#DSN#">
            DELETE             
            FROM
                EMPLOYEES_GRADE_STEP_PARAMS
            WHERE
                START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                AND FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
        </cfquery>
        <script type="text/javascript">
            window.location.href = '<cfoutput>/index.cfm?fuseaction=ehesap.personal_payment</cfoutput>';
        </script>
    </cffunction>
</cfcomponent>