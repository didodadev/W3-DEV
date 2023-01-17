<cfset dsn = application.systemParam.systemParam().dsn>
<cffunction  name="listToRow" access="remote" returntype="any" returnformat="json">
     <cfquery name="list_main_process" datasource="#dsn#">
            SELECT
                PROCESS_MAIN_ID, 
                PROCESS_ID,
                DESIGN_TITLE
                
            FROM
                PROCESS_MAIN_ROWS 
            WHERE
                PROCESS_MAIN_ID = '#url.mainid#'      

        </cfquery>
        <cfreturn list_main_process>
     
</cffunction>
<cffunction  name="listToHead" access="remote" returntype="any" returnformat="json">
    <cfquery name="list_main_head" datasource="#dsn#">
           SELECT
               *
           FROM
                PROCESS_MAIN 
           WHERE
               PROCESS_MAIN_ID = '#url.mainid#'      

       </cfquery>
       <cfreturn list_main_head>
    
</cffunction>
<!--- <cffunction  name="listToEmp" access="remote" returntype="any" returnformat="json">
    <cfdump  var="#argument.hiddentID#" abort>
        <cfquery name="list_main_emp" datasource="#dsn#">
           SELECT RECORD_EMP FROM PROCESS_MAIN WHERE PROCESS_MAIN_ID='#argument.hiddentID#'     
       </cfquery>
       <cfreturn list_main_emp>
    
</cffunction> --->