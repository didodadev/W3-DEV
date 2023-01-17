<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction  name="saveToRow" access="remote" returntype="any" returnformat="json">
        <cftry>
            <cfif isDefined('arguments.ProcessID') and arguments.ProcessID gt 0>
                <cfdump  var="#arguments.ProcessID#">
                <cfquery name="UPD_PROCESS" datasource="#dsn#">
                    UPDATE
                        PROCESS_TYPE
                    SET
                        PROCESS_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.process#">,
                        UPDATE_DATE = #now()#,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                        UPDATE_EMP = #session.ep.userid#
                    WHERE
                        PROCESS_ID = #arguments.ProcessID#
                </cfquery>
                  <cfquery name="UPD_PROCESS" datasource="#dsn#">
                    UPDATE
                        PROCESS_MAIN_ROWS
                    SET
                        DESIGN_TITLE   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.process#">,
                        UPDATE_DATE = #now()#,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                        UPDATE_EMP = #session.ep.userid#
                    WHERE
                        PROCESS_ID = #arguments.ProcessID#
                </cfquery>
                <cfreturn arguments.ProcessID> 
            <cfelse>
                <cfquery name="add_process" datasource="#dsn#" result="add_process_result">
                    INSERT INTO
                        PROCESS_TYPE
                    (
                        PROCESS_NAME,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.process#">,
                        #now()#,
                        #session.ep.userid#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">		
                    )
                    
                </cfquery> 
                <cfquery name="record_main_rows" datasource="#dsn#">
                    INSERT INTO
                        PROCESS_MAIN_ROWS
                        (	
                            PROCESS_MAIN_ID,
                            PROCESS_ID,
                            DESIGN_TITLE,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP
                        )
                    VALUES
                        (
                            <cfif isdefined('arguments.mainid') and len(arguments.mainid)><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.mainid#'><cfelse>Null</cfif>,
                            #add_process_result.generatedkey#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.process#">,
                            #now()#,
                            #session.ep.userid#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">	
                        )
                </cfquery> 
                    <cfreturn add_process_result.generatedkey>
            </cfif>
        <cfcatch type="exception">

            <cfdump  var="#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>
    
<cffunction  name="deleteToRow" access="remote" returntype="any">
    
    <cfquery name="del_main_process" datasource="#dsn#">
		DELETE FROM PROCESS_TYPE WHERE PROCESS_ID = #arguments.processID#
    </cfquery>
    <cfquery name="del_main_proces" datasource="#dsn#">
    
		DELETE FROM PROCESS_MAIN_ROWS WHERE PROCESS_ID = #arguments.processID#
	</cfquery>
</cffunction>