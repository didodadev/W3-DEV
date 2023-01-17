<cfcomponent>
	<cfset upload_folder = application.systemParam.systemParam().upload_folder>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="addPrintJson" returntype="any" access="remote">
    	<cfargument name="printJson" default="" type="string">
    	<cfset data = deserializeJson(arguments.printJson)>
        <cfif LEN(data.page[1].printActionId)>
        	<cfquery name="DEL_SETUP_PRINT_FILE" datasource="#dsn#">
            	DELETE FROM #dsn#_#data.page[1].cId#.SETUP_PRINT_FILES WHERE FORM_ID = #data.page[1].printActionId#
            </cfquery>
        </cfif>  
		<cfquery name="ADD_SETUP_PRINT_FILES" datasource="#dsn#">
            INSERT INTO
                #dsn#_#data.page[1].cId#.SETUP_PRINT_FILES
            (
                ACTIVE,
                NAME,
                JSON,
                CONTROLLER_NAME,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            )
            VALUES
            (
                1,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#data.page[1].name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.printJson#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#data.page[1].cName#">,
                <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,
                <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
            )
        </cfquery> 
        <cfreturn true>
    </cffunction>

    <cffunction name="getPrintJson" returntype="any" returnformat="json" access="remote">
        <cfargument name="companyId" required="yes" default="" type="string">
        <cfargument name="controllerName" required="yes" default="" type="string">
        <cfargument name="actionId" required="yes" default="" type="string">
        <cfquery name="GET_SETUP_PRINT_FILES" datasource="#dsn#">
        	SELECT
            	JSON
            FROM
            	#dsn#_#arguments.companyId#.SETUP_PRINT_FILES
            WHERE
            	CONTROLLER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.controllerName#">
                AND FORM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.actionId#">
        </cfquery>
        
        
<!---        <cffile action="read" file="#upload_folder#personal_settings/print.json" variable="personalMenu" charset="utf-8">--->
        
        <cfset printJson = Replace(GET_SETUP_PRINT_FILES.JSON,'//','') >
        <cfreturn printJson>
    </cffunction>
</cfcomponent>