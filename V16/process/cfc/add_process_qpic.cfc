<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="saveToRow"  access="remote" returntype="any" returnformat="json">
        <cftry>
        <cfif isDefined('arguments.hiddenID') and arguments.hiddenID gt 0>
                <cfquery name="upd_main_process" datasource="#DSN#">
                    UPDATE
                        PROCESS_MAIN
                    SET
                        PROCESS_MAIN_HEADER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.main#">,
                        PROCESS_MAIN_DETAIL = <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                        UPDATE_DATE = #now()#,
                        UPDATE_EMP = #session.ep.userid#,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    WHERE
                        PROCESS_MAIN_ID = #arguments.hiddenID#
                </cfquery>
                  <cfreturn arguments.hiddenID> 
            <cfelse>
                <cfquery name="add_main_process" datasource="#DSN#" result="add_main_process_result">
                            
                        INSERT INTO
                        PROCESS_MAIN
                    (
                        PROCESS_MAIN_HEADER,
                        PROCESS_MAIN_DETAIL,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.main#">,
                        <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                        #now()#,
                        #session.ep.userid#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">		
                    )
                </cfquery>
                    <cfreturn add_main_process_result.generatedkey>
        </cfif>

<cfcatch type="exception">

    <cfdump  var="#cfcatch#">
</cfcatch>
</cftry>
</cffunction>
<cffunction  name="deleteToRow" access="remote" returntype="any">
    
    <cfquery name="del_main_process" datasource="#dsn#">
		DELETE FROM PROCESS_MAIN WHERE PROCESS_MAIN_ID = #arguments.hiddenID#
	</cfquery>
</cffunction>