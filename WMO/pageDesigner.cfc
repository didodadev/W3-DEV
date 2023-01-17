<!--- json_type parametresi 1 : tab menü, 2: page bar, null : page designer 
	objectID parametresi gelirse pageBar duzenleniyor
--->
	
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="menuModified" returntype="any" returnFormat="plain" access="remote">
        <cfargument name="data" default="" type="any">
        <cfargument name="jsonType" default="0" type="numeric">
        <cfargument name="controller" default="" type="any">
        <cfargument name="eventList" default="" type="any">
        <cfargument name="objectId" default="0" type="numeric">
        
        <cfif arguments.objectId neq 0>
        	<cfquery name="getObjectModuleNo" datasource="#dsn#">
            	SELECT MODULE_NO FROM WRK_OBJECTS WHERE WRK_OBJECTS_ID = #arguments.objectId#
            </cfquery>
        </cfif>
        
        <cfscript>
			if(listFindNoCase('1,5',arguments.jsonType,','))
				delModified(controllerName:arguments.controller,jsonType:arguments.jsonType); 
			else 
				delModified(moduleNo:getObjectModuleNo.module_no,jsonType:arguments.jsonType);
		</cfscript>
        
		<cfquery name="INSERT_DB" datasource="#DSN#">
            INSERT INTO
                MODIFIED_PAGE
            (
                CONTROLLER_NAME,
                EVENT_LIST,
                COMPANY_ID,
                PERIOD_ID,
                POSITION_CODE,
                JSON_DATA,
                JSON_TYPE,
                MODULE_NO,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            )
            VALUES
            (
                <cfif len(arguments.controller)>'#arguments.controller#'<cfelse>NULL</cfif>,
                <cfif len(arguments.eventlist)>'#arguments.eventlist#'<cfelse>NULL</cfif>,
                #session.ep.company_id#,
                #session.ep.period_id#,
                -1,
                '#arguments.data#',
                #arguments.jsonType#,
                <cfif arguments.objectId neq 0>#getObjectModuleNo.module_no#<cfelse>NULL</cfif>,
                #now()#,
                #session.ep.userid#,
                '#cgi.REMOTE_ADDR#'
            )
        </cfquery>
        <cfreturn true>
    </cffunction>
    
    <cffunction name="delModified" returntype="any" returnFormat="plain" access="remote">
    	<cfargument name="controllerName" default="" type="string">
        <cfargument name="moduleNo" default="0" type="numeric">
        <cfargument name="jsonType" default="0" type="numeric">

        <cfquery name="DEL_DB" datasource="#DSN#">
            DELETE FROM 
            	MODIFIED_PAGE 
            WHERE 
				<cfif len(arguments.controllerName)>
                	CONTROLLER_NAME = '#arguments.controllerName#' 
                <cfelse> 
                	MODULE_NO = #arguments.moduleNo# 
                </cfif>
                AND JSON_TYPE = #arguments.jsonType#
       </cfquery>
       <cfreturn true>
    </cffunction>
    
    <cffunction name="getMenuModified" returntype="any" returnFormat="plain" access="remote">
    	<cfargument name="controller" default="" type="string">
        <cfargument name="jsonType" default="0" type="numeric">
        <cfargument name="objectId" default="0" type="numeric">
        <cfargument name="eventList" default="" type="string">
        
        <cfif len(arguments.objectId)>
        	<cfquery name="getObjectModuleNo" datasource="#dsn#">
            	SELECT MODULE_NO FROM WRK_OBJECTS WHERE WRK_OBJECTS_ID = #arguments.objectId#
            </cfquery>
        </cfif>
        
        <cfif IsDefined("session.ep.company_id") and IsDefined("session.ep.period_id")>
            <cfquery name="getModified" datasource="#DSN#">
                SELECT
                    JSON_DATA 
                FROM 
                    MODIFIED_PAGE 
                WHERE 
                    <cfif len(arguments.controller)>
                        CONTROLLER_NAME = '#arguments.controller#'
                        AND EVENT_LIST IN ('#arguments.eventList#')
                    <cfelse>  
                        MODULE_NO = #getObjectModuleNo.MODULE_NO# 
                    </cfif>
                    AND JSON_TYPE = #arguments.jsonType# AND
                    COMPANY_ID = #session.ep.company_id# AND
                    PERIOD_ID = #session.ep.period_id#
            </cfquery>
            <cfreturn getModified.JSON_DATA>
        <cfelse>
            <cfreturn '{}'>
        </cfif>
    </cffunction>
    
	<cffunction name="getList" access="remote" returntype="any" returnFormat="json">
    	<cfargument name="controllerName" required="yes" default="">
        <cfquery name="GET_LIST" datasource="#dsn#">
        	SELECT
            	JSON_DATA
            FROM
            	MODIFIED_PAGE
            WHERE
            	CONTROLLER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.controllerName#">
                AND JSON_TYPE = 5
        </cfquery>
        <cfreturn Replace(SerializeJSON(GET_LIST),'//','')>
    </cffunction>

</cfcomponent>