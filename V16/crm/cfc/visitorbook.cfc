<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="GETLIST" access="public">
        <cfargument name="visit_name" default="">
        <cfargument name="keyword"  default="">
        <cfargument name="start_date"  default="">
        <cfargument name="finish_date"  default="">

        <cfquery name="GETVISITOR" datasource="#DSN#">
            SELECT 
                EMPLOYEES.*,
                VISITOR_BOOK.*,
                D.DEPARTMENT_HEAD,
                B.BRANCH_NAME
            FROM 
                VISITOR_BOOK 
                    LEFT JOIN EMPLOYEES ON  EMPLOYEES.EMPLOYEE_ID=VISITOR_BOOK.EMP_ID
                    LEFT JOIN BRANCH B ON B.BRANCH_ID=VISITOR_BOOK.BRANCH_ID
                    LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID=VISITOR_BOOK.DEPARTMENT_ID
            WHERE 
                VISITOR_BOOK.VISIT_ID IS NOT NULL
            <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                AND
                (	
                    EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#IIf(len(arguments.keyword) gt 2,DE("%"),DE(""))##arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI 
                )
                OR
                (	
                    VISITOR_BOOK.VISIT_NAME+' '+VISITOR_BOOK.VISIT_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#IIf(len(arguments.keyword) gt 2,DE("%"),DE(""))##arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI 
                )
                OR
                (	
                    VISITOR_BOOK.CARD_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#IIf(len(arguments.keyword) gt 2,DE("%"),DE(""))##arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI 
                )
            </cfif>
            <cfif isDefined("arguments.START_DATE")>
                <cfif len(arguments.START_DATE) AND len(arguments.FINISH_DATE)>
                    AND
                    (
                        (
                            VISITOR_BOOK.VISIT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.START_DATE#"> AND
                            VISITOR_BOOK.VISIT_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,arguments.FINISH_DATE)#">
                        )
                    OR
                        (
                            VISITOR_BOOK.VISIT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.START_DATE#"> AND
                            VISITOR_BOOK.VISIT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.START_DATE#">
                        )
                    )
                    <cfelseif len(arguments.START_DATE)>
                    AND
                    (
                        VISITOR_BOOK.VISIT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.START_DATE#">
                        OR
                        (
                            VISITOR_BOOK.VISIT_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.START_DATE#"> AND
                            VISITOR_BOOK.VISIT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.START_DATE#">
                        )
                    )
                    <cfelseif len(arguments.FINISH_DATE)>
                    AND
                    (
                        VISITOR_BOOK.FINISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,arguments.FINISH_DATE)#">
                        OR
                        (
                            VISITOR_BOOK.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,arguments.FINISH_DATE)#"> AND
                            VISITOR_BOOK.FINISH_DATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,arguments.FINISH_DATE)#">
                        )
                    )
                </cfif>
            </cfif>          
        </cfquery>
        <cfreturn GETVISITOR>
    </cffunction>

 
    <cffunction name="GETADD" access="public"  returnFormat="json"  returntype="any">
        <cfargument name="visit_id">
        <cfargument name="visit_name">
        <cfargument name="visit_surname">
        <cfargument name="card_no">
        <cfargument name="VISIT_DATE" >
        <cfargument name="start_time">
        <cfargument name="end_time" >
        <cfargument name="start_minute">
        <cfargument name="finish_minute">
        <cfargument name="reason_visit">
        <cfargument name="emp_id" >
        <cfargument name="branch_id" >
        <cfargument name="department_id">

        <cfquery name="QUERY_ADD" datasource="#dsn#" result="MAX_ID">
            INSERT INTO 
                VISITOR_BOOK 
                (
                    VISIT_NAME,
                    VISIT_SURNAME,
                    CARD_NO,
                    VISIT_DATE,
                    START_TIME,
                    END_TIME,
                    START_MINUTE,
                    FINISH_MINUTE,
                    REASON_VISIT,
                    EMP_ID,
                    BRANCH_ID,
                    DEPARTMENT_ID,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                )
            VALUES
            (
                <cfif len(arguments.visit_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.visit_name#"><cfelse>NULL</cfif>,
                <cfif len(arguments.visit_surname)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.visit_surname#"><cfelse>NULL</cfif>,
                <cfif len(arguments.card_no)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.card_no#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_date"     value="#arguments.VISIT_DATE#">,
                <cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.start_time#">,
                <cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.end_time#">,
                <cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.start_minute#">,
                <cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.finish_minute#">,
                <cfif len(arguments.reason_visit)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.reason_visit#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.EMP_ID#">,
                <cfif len(arguments.branch_id)><cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.branch_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.department_id)><cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.department_id#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value='#cgi.REMOTE_ADDR#'>
            ) 
        </cfquery>
        <cfreturn MAX_ID.IDENTITYCOL>
    </cffunction>

    <cffunction name="GETUPD">
        <cfargument name="visit_id"  >  
        <cfargument name="visit_name"  >
        <cfargument name="visit_surname" >
        <cfargument name="card_no" >
        <cfargument name="VISIT_DATE" >
        <cfargument name="start_time"  >
        <cfargument name="end_time"  >
        <cfargument name="start_minute" >
        <cfargument name="finish_minute">
        <cfargument name="reason_visit" >
        <cfargument name="EMP_ID"  >
        <cfargument name="branch_id" >
        <cfargument name="department_id">

        <cfquery name="QUERY_UPD" datasource="#dsn#">
            UPDATE 
                VISITOR_BOOK 
            SET 
                VISIT_NAME = <cfif len(arguments.visit_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.visit_name#"><cfelse>NULL</cfif>,
                VISIT_SURNAME = <cfif len(arguments.visit_surname)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.visit_surname#"><cfelse>NULL</cfif>,
                CARD_NO= <cfif len(arguments.card_no)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.card_no#"><cfelse>NULL</cfif>,
                VISIT_DATE= <cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.VISIT_DATE#'>,
                START_TIME = <cfqueryparam cfsqltype='cf_sql_integer' value='#arguments.start_time#'>,
                END_TIME = <cfqueryparam cfsqltype='cf_sql_integer' value='#arguments.end_time#'>,
                START_MINUTE = <cfqueryparam cfsqltype='cf_sql_integer' value='#arguments.start_minute#'>,
                FINISH_MINUTE = <cfqueryparam cfsqltype='cf_sql_integer' value='#arguments.finish_minute#'>,
                REASON_VISIT = <cfif len(arguments.reason_visit)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.reason_visit#"><cfelse>NULL</cfif>,
                EMP_ID = <cfqueryparam cfsqltype='cf_sql_integer' value='#arguments.EMP_ID#'>,
                BRANCH_ID = <cfif len(arguments.branch_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"><cfelse>NULL</cfif>,
                DEPARTMENT_ID =<cfif len(arguments.department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#"><cfelse>NULL</cfif>,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remot_addr#">
            WHERE 
                VISIT_ID = <cfqueryparam cfsqltype='cf_sql_integer' value='#arguments.visit_id#'>
        </cfquery>
    </cffunction>

    <cffunction name="DEL_VISITOR" access="public">
        <cfargument name="visit_id" required="yes">
            <cfquery name="QUERY_DEL" datasource="#dsn#">
                DELETE 
                FROM 
                    VISITOR_BOOK  
                WHERE 
                    VISIT_ID=<cfqueryparam cfsqltype='cf_sql_integer' value='#arguments.visit_id#'>
            </cfquery>
    </cffunction> 

    <cffunction name="GET_VISITORBOOK" access="public" returntype="query">
        <cfargument name="visit_id" default="">
            <cfquery name="GET_VISITORBOOK" datasource="#DSN#">
                SELECT
                    EMPLOYEES.*,
                    VISITOR_BOOK.*,
                    VISITOR_BOOK.RECORD_EMP AS RECORD_EMP1,
                    VISITOR_BOOK.UPDATE_EMP AS UPDATE_EMP1,
                    VISITOR_BOOK.RECORD_DATE AS RECORD_DATE1,
                    VISITOR_BOOK.UPDATE_DATE AS UPDATE_DATE1,
                    D.DEPARTMENT_HEAD,
                    B.BRANCH_NAME
                FROM 
                    VISITOR_BOOK 
                        LEFT JOIN EMPLOYEES ON  EMPLOYEES.EMPLOYEE_ID=VISITOR_BOOK.EMP_ID
                        LEFT JOIN BRANCH B ON B.BRANCH_ID=VISITOR_BOOK.BRANCH_ID
                        LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID=VISITOR_BOOK.DEPARTMENT_ID
                WHERE 
                    VISITOR_BOOK.VISIT_ID=<cfqueryparam cfsqltype='cf_sql_integer' value='#arguments.visit_id#'>
            </cfquery>
        <cfreturn GET_VISITORBOOK>
    </cffunction>
</cfcomponent>