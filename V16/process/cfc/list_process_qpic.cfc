<cfset dsn = application.systemParam.systemParam().dsn>
<cffunction  name="listToRow" returntype="any">
        <cfquery name="list_main_process" datasource="#dsn#">
            SELECT
                PM.PROCESS_MAIN_ID,
                PM.PROCESS_MAIN_HEADER,
                PM.PROCESS_MAIN_DETAIL,
                PM.RECORD_DATE,
                PM.RECORD_EMP
            FROM
                PROCESS_MAIN PM
            
        </cfquery>
        <cfreturn list_main_process>
     
</cffunction>