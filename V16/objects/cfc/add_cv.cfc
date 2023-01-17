<cfcomponent>
    <cfset dsn=application.systemParam.systemParam().dsn>
    <cffunction name="add_cv" access="remote" returntype="any">
        <cfset attributes = arguments>
       <cfif arguments.is_upd eq 1>
            <cfquery name="upd_cv" datasource="#dsn#">
                UPDATE
                    EMPLOYEES_APP
                SET            
                    RESUME_TEXT	= <cfif isDefined('arguments.resume_text') and len(arguments.resume_text)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.resume_text#"><cfelse>NULL</cfif>,
                    UPDATE_IP= <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    UPDATE_EMP=  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    UPDATE_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.emp_id#">
            </cfquery>
        <cfelseif arguments.is_upd eq 0>
            <cfquery name="add_cv" datasource="#dsn#">
                INSERT INTO EMPLOYEES_APP
                (
                    RESUME_TEXT,
                    EMPLOYEE_ID,
                    RECORD_IP,
                    RECORD_EMP,
                    RECORD_DATE
                )
                VALUES
                (
                    <cfif isDefined('arguments.resume_text') and len(arguments.resume_text)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.resume_text#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.emp_id#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )
            </cfquery>
        </cfif>
        <script>
            location.href= document.referrer;
        </script>
    </cffunction>
</cfcomponent>